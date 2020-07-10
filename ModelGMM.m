classdef ModelGMM < Model
    
    methods
        function M = ModelGMM(X,no_of_components,speaker_name,fl,vata)
            tStart=tic;
            M.model = ModelGMM.fitModel(X,no_of_components);
            M.building_time = toc(tStart);
            M.voiced_to_toal_audio_length=vata;
            M.speaker =  speaker_name;
            M.file_list = fl;
        end
    end
    
    methods (Static)
        function model = fitModel(X,no_of_components)
            options = statset('Display','final','MaxIter',Utils.MAXIMUM_ITERATIONS);
            model = gmdistribution.fit(X,no_of_components,...
                'Start','randSample',...
                'Replicates',Utils.REPLICATES,...
                'CovType','diagonal',...
                'SharedCov',false,...
                'Options',options);
        end
        
        function obj = compare(X, models)
            ll = inf;
            size(X)
            for t=1:length(models)
                [~, loglike] = posterior(models{t}.model,X);
                loglike = loglike/size(X,1);
                if loglike<ll
                    ll = loglike;
                    answer = t;
                end
            end
            obj = models{answer};
        end
        
    end
end
