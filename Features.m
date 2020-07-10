classdef Features
    methods(Static)
        
        function X = featureSet(s,fs,dim,type)
            if (nargin<4)
                type = 'mfcc';
            end
            
            if (strcmp(type,'delta')==1)
                [X, M] = Features.mfcc(s, fs, dim*2);
                X = X(1:dim,:);
                %                 X(1,:) = sum(M.^2)/dim;
                
                d = (Features.deltacoeff(X')).*0.6;         %Computes delta-mfcc
                d1 = (Features.deltacoeff(d)).*0.4;         %as above for delta-delta-mfcc
                X = [X; d'; d1'];                           %concatenates all together
                
            elseif (strcmp(type,'mfcc')==1)
                X = Features.mfcc(s, fs, dim);
                
            elseif (strcmp(type,'halfmfcc')==1)
                X = Features.mfcc(s, fs, dim*2);
                X = X(1:dim,:);
            end
            
           % X = Features.warp_mfcc(X);                  %% warping
            %             mf = mfcc(s, fs, dim);
            %             meanceps = mean(ceps,2);
            %             ceps = ceps - repmat(meanceps,1,frames);
        end
        
        function [X, M] = mfcc(s, fs, dim)
            %% windowing
            m = ceil(fs*Utils.DEFAULT_SPACING_MFCC/1000);               %% sapcing
            n = pow2(nextpow2(fs*Utils.DEFAULT_WINDOW_MFCC/1000));      %% frame size
            
            l = length(s);
            nbFrame = floor((l - n) / m) + 1;
            M = s(bsxfun(@plus,repmat((1:n)',1,nbFrame),(0:nbFrame-1)*m));
            
            h = hamming(n);                     %% define n size hamming window
            M2 = diag(h) * M;                   %% multiply by hamming coef
            
            %% FFT filter bank
            frame = fft(M2,[],1);
            m = Features.melfb(dim, n, fs);        % m = melfilter bank output
            n2 = 1 + floor(n / 2);
            z = m * abs(frame(1:n2, :)).^2; 	%% select rows of size (256/2+1) cloums = 129
            
            logz = log(z);
            %             logz = logz - repmat(mean(logz,1),size(logz,1),1);        %             lsms
            X = dct(logz);
            
            wasnan=any(isnan(X),1);
            if (any(wasnan))
                X = X( :, ~wasnan);
            end
            
            %             acx = sum(M2.^2,1);               %energy in window
            %             X(1,:) = acx(~wasnan);
        end
        function N = warp_mfcc(X)
            % X = rand(10,3000);
            wind = 255;
            spacing = 1;
            
            [vdim, leng] = size(X);
            X  = padarray(X,[0 127]);
            
            c = zeros(vdim, leng);
            
            for k = 1:vdim
                c(k,:) = Features.get_rank(X(k,:),spacing,wind);
            end
            
            B = (1+((1-2*c)/(2*wind)));
            N = norminv(B,0,1);
        end
        
        function R = get_rank(s,m,n)
            
            % m = 1;                      %% sapcing
            % n = 245;                    %% frame size 245 ODD values preffered
            
            l = length(s);
            nbFrame = floor((l - n) / m) + 1;
            M = s(bsxfun(@plus,repmat((1:n)',1,nbFrame),(0:nbFrame-1)*m));
            Mid = M(ceil((n+1)/2),:);
            M1 = sort(M);
            M2 = bsxfun(@eq,M1,Mid);
            
            as1 = find(M2);
            as2 = floor((as1-1)/n);
            [~, ia, ~] = unique(as2);
            
            R = mod(as1(ia),n)';
            R(R==0) = n;
        end
        
        function diff = deltacoeff(x)
            %Author:        Olutope Foluso Omogbenigun
            %Email:         olutopeomogbenigun at hotmail.com
            %University:    London Metropolitan University
            %Date:          12/07/07
            %Syntax:        diff = deltacoeff(Matrix);
            %Calculates the time derivative of  the MFCC
            %coefficients matrix x and returns the result as a new matrix.
            
            [nr,~] = size(x); % rows are vectors
            K = 3;          %Number of frame span(backward and forward span equal)
            b = K:-1:-K;    %Vector of filter coefficients
            %pads cepstral  coefficients matrix by repeating first and last rows K times
            px = [repmat(x(1,:),K,1);x;repmat(x(end,:),K,1)];
            
            diff = filter(b, 1, px, [], 1);  % filter data vector along each column
            diff = diff/sum(b.^2);           %Divide by sum of square of all span values
            % Trim off upper and lower K rows to make input and output matrix equal
            diff = diff(K + (1:nr),:);
        end
        
        function m = melfb(p, n, fs)
            % MELFB         Determine matrix for a mel-spaced filterbank
            %
            % Inputs:       p   number of filters in filterbank
            %               n   length of fft
            %               fs  sample rate in Hz
            %
            % Outputs:      x   a (sparse) matrix containing the filterbank amplitudes
            %                   size(x) = [p, 1+floor(n/2)]
            %
            % Usage:        For example, to compute the mel-scale spectrum of a
            %               colum-vector signal s, with length n and sample rate fs:
            %
            %               f = fft(s);
            %               m = melfb(p, n, fs);
            %               n2 = 1 + floor(n/2);
            %               z = m * abs(f(1:n2)).^2;
            %
            %               z would contain p samples of the desired mel-scale spectrum
            %
            %               To plot filterbanks e.g.:
            %
            %               plot(linspace(0, (12500/2), 129), melfb(20, 256, 12500)')
            %               title('Mel-spaced filterbank'), xlabel('Frequency (Hz)');
            
            f0 = 700 / fs;
            fn2 = floor(n/2);
            
            lr = log(1 + 0.5/f0) / (p+1);
            
            % convert to fft bin numbers with 0 for DC term
            bl = n * (f0 * (exp([0 1 p p+1] * lr) - 1));
            
            b1 = floor(bl(1)) + 1;
            b2 = ceil(bl(2));
            b3 = floor(bl(3));
            b4 = min(fn2, ceil(bl(4))) - 1;
            
            pf = log(1 + (b1:b4)/n/f0) / lr;
            fp = floor(pf);
            pm = pf - fp;
            
            r = [fp(b2:b4) 1+fp(1:b3)];
            c = [b2:b4 1:b3] + 1;
            v = 2 * [1-pm(b2:b4) pm(1:b3)];
            
            m = sparse(r, c, v, p, 1+fn2);
        end
    end
end
