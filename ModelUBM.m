classdef ModelUBM
    
    properties (SetAccess = protected)
        model;
        building_time;
        mixture_size;
        speakers_arr;
        llh_arr;
        max_misses;
        max_false;
    end
    
    
    
    methods (Static)
        function M = Model_UBM(X,no_of_components)
            
            M.model = ModelUBM.fitModel(X,no_of_components);
            
            M.mixture_size = no_of_components;
            M.speakers_arr = logical([]);
            M.llh_arr = [];
            M.max_misses = 0;
            M.max_false = 0;
        end
        
        function [speakers,llh,max_mis,max_fal] = getResults(obj)
            if (isempty(obj))
                disp('UBM not found!!!');
            else
                speakers = obj.speakers_arr;
                llh = obj.llh_arr;
                max_mis = obj.max_misses;
                max_fal = obj.max_false;
            end
        end
        
        function c = clearResults(c)
            c.speakers_arr = logical([]);
            c.llh_arr = [];
            c.max_misses = 0;
            c.max_false = 0;
        end
        
        function c = setResults(c, speakers,llh,max_mis,max_fal)
            c.speakers_arr = speakers;
            c.llh_arr = llh;
            c.max_misses = max_mis;
            c.max_false = max_fal;
        end
        
        function model = fitModel(X,no_of_components)
            options = statset('Display','final','MaxIter',Utils.MAXIMUM_ITERATIONS);
            model = gmdistribution.fit(X,no_of_components,...
                'Start','randSample',...
                'Replicates',Utils.UBM_REPLICATES,...
                'CovType','diagonal',...
                'SharedCov',false,...
                'Options',options);
        end
        
        
        function score = verify(suspect,evidence,ubm)
              X = evidence.MFCC ; 
            [~, log_like_ubm] = posterior(ubm.model,X);
            
            [~, log_like_model] = posterior(suspect.model,X);
                score = log_like_model - log_like_ubm;
                score = score/length(X);
              
              
        end
           
          function [llhs, model_names] = Old_verify(X, models, ubm)
            [~, log_like_ubm] = posterior(ubm.model,X);
            log_like_ubm = log_like_ubm/size(X,1);
            
            llhs = zeros(1,length(models));
            model_names = cell(1,length(models));
            for t=1:length(models)
                [~, log_like_model] = posterior(models{t}.model,X);
                log_like_model = log_like_model/size(X,1);
                llhs(1,t) = log_like_model - log_like_ubm;
                model_names{1,t} = models{t}.speaker;
            end
        end
        function ubm = makeUBM(mixture_size,Path)
            
            
            X = [];
            disp('calculating feature vectors for UBM');
             Folders = dir((Path));
             for i=1:length(Folders)
                        if (Folders(i).isdir && ~strcmp(Folders(i).name, '.')&& ~strcmp(Folders(i).name, '..'))
                            FolderPath  = [Path, '\', Folders(i).name];
            files = dir([FolderPath, '\*.wav']);
            for j=1:size(files,1)
                file_path=[FolderPath '\' files(j).name];
                [s,fs] = audioread(file_path);
                X = [X; Utils.mfcc(s, fs, 20)'];
            end
                        end
             end
            
            disp('building GMM model for UBM');
            ubm = ModelUBM.Model_UBM(X,mixture_size);
            
            
        end
        
        
        
       
        end
    end
    