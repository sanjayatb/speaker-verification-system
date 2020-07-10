classdef ModelStore
    
    methods (Static)
        
        function value = getHash(file_list)
            value = regexprep(strjoin(extractfield(file_list, 'name')),'[^a-zA-Z0-9]+','');
        end
        
        function model = new_model(s, fs, no_of_components, file_list, speaker_name, dimns,ty,featype)
            X = Features.featureSet(s, fs, dimns, featype)';
            % run VAD and send percentage of voice to total audio length
            vata = 1;
            if (strcmp(ty,'gmm')==1)
                model = ModelGMM(X,no_of_components,speaker_name,file_list,vata);
            elseif(strcmp(ty,'kmeans')==1)
                model = ModelKMeans(X,no_of_components,speaker_name,file_list,vata);
            end
        end
        
        function [mx, fs] = mix_audio(file_list,folder_path,mx_path)
            if (~exist(mx_path,'file'))
                x=cell(length(file_list),1);
                for k=1:length(file_list)
                    path = [folder_path, '\', file_list(k).name];
                    [x{k}, fs] =  audioread(path);
                end
                mx = cell2mat(x);
                audiowrite(mx_path,mx,fs);
            else
                [mx, fs] = audioread(mx_path);
            end
        end
        
        function model = newMixedModel(file_list,folder_path, dest, no_of_components, speaker_name, dimns,ty,featype)
            [s, fs] = ModelStore.mix_audio(file_list,folder_path,dest);
            model = ModelStore.new_model(s, fs, no_of_components, file_list, speaker_name, dimns,ty,featype);
        end
    end
    
    properties (SetAccess = public)
        db_path;
        destination;
        hTable;
        no_of_components;
        type;
        dimns;
        ubm;
        featureType;
    end
    
    methods
        function M = ModelStore(path,dst,noc,dm,ty,ftyp)  %% constructor
            if(exist(path,'file'))  % small problem with the exist logic.. works the other way when there is nothing
                disp('Database file found.');
                h = load(path);
                h = h.obj;
                M.hTable = h.hTable;
                M.db_path = h.db_path;
                M.destination = h.destination;
                M.no_of_components = h.no_of_components;
                M.dimns = h.dimns;
                M.type = h.type;
                M.ubm = h.ubm;
                M.featureType = h.featureType;
                disp(M);
                if (strcmp(ty,M.type)==0 || strcmp(ftyp,M.featureType)==0 || M.dimns~=dm || M.no_of_components~=noc)
                    warning('LODED PARAMETERS ARE NOT SAME AS INPUT PARAMTERS');
                end
                if (strcmp(dst,M.destination)==0 || strcmp(path,M.db_path)==0)
                    warning('DB_PATH and DESTINATION updated');
                    M.destination = dst;
                    M.db_path = path;
                end
            else
                if (nargin<5)
                    error('Model db no found at given location. No enough input argumanets to build new model db');
                else
                    disp('No database file found. Creating new file');
                    M.hTable =  containers.Map();
                    M.featureType = ftyp;
                    M.db_path = path;
                    M.destination = dst;
                    M.no_of_components = noc;
                    M.dimns = dm;
                    M.type = ty;
                    M.ubm=[];
                end
            end
            %             this.saveDB();
        end
        
        function removeUBM(this)
            this.ubm = [];
            this.saveDB();
        end
        
        function this = makeUBM(this,mixture_size)
            if (strcmp(this.type,'gmm')==1)
                if (isempty(this.ubm))
                    db_Path = this.destination;
                    Folders = dir((db_Path));
                    X = [];
                    disp('calculating feature vectors for UBM');
                    for i=1:length(Folders)
                        if (Folders(i).isdir && ~strcmp(Folders(i).name, '.')&& ~strcmp(Folders(i).name, '..'))
                            FolderPath  = [db_Path, '\', Folders(i).name];
                            files = dir([FolderPath, '\*.wav']);
                            for j=1:size(files,1)
                                file_path=[FolderPath '\' files(j).name];
                                [s,fs] = audioread(file_path);
                                X = [X; Features.featureSet(s, fs, this.dimns,this.featureType)'];
                            end
                        end
                    end
                    disp('building GMM model for UBM');
                    this.ubm = ModelUBM.Model_UBM(X,mixture_size);
                    this.saveDB();
                else
                    disp('UBM found in store');
                end
            else
                disp('UBM applicable only for GMM distributions!');
            end
        end
        
        function result = add_model(obj, file_list, folder_path, speaker_name, type)
            if (strcmp(type,'all')==1)
                dest = [obj.destination '\' speaker_name '.wav'];
                if (isKey(obj.hTable,speaker_name))
                    if (~isfield(obj.hTable(speaker_name),'all'))
                        ee = obj.hTable(speaker_name);
                        ee.all = ModelStore.newMixedModel(file_list,folder_path, dest, obj.no_of_components, speaker_name,obj.dimns, obj.type,obj.featureType);
                        obj.hTable(speaker_name) = ee;
                    end
                else
                    aa=struct();
                    aa.all = ModelStore.newMixedModel(file_list,folder_path, dest, obj.no_of_components, speaker_name,obj.dimns, obj.type,obj.featureType);
                    obj.hTable(speaker_name) = aa;
                end
                
            elseif(strcmp(type,'sub')==1)
                [~, order] = sortrows(strvcat(file_list(:).name));
                file_list = file_list(order);
                hash_string = [speaker_name '_' ModelStore.getHash(file_list)];
                dest = [obj.destination,'\',hash_string, '_sub.wav'];
                
                if (isKey(obj.hTable,speaker_name))
                    if (isfield(obj.hTable(speaker_name),'sub'))
                        if (~isKey(obj.hTable(speaker_name).sub,hash_string))
                            ma = obj.hTable(speaker_name);
                            subma = ma.sub;
                            subma(hash_string) = ModelStore.newMixedModel(file_list,folder_path, dest, obj.no_of_components, speaker_name,obj.dimns, obj.type,obj.featureType);
                            ma.sub = subma;
                            obj.hTable(speaker_name) = ma;
                        end
                    else
                        ab=containers.Map();
                        ab(hash_string) = ModelStore.newMixedModel(file_list,folder_path, dest, obj.no_of_components, speaker_name,obj.dimns, obj.type,obj.featureType);
                        ma = obj.hTable(speaker_name);
                        ma.sub = ab;
                        obj.hTable(speaker_name) = ma;
                    end
                else
                    ab=containers.Map();
                    ab(hash_string) = ModelStore.newMixedModel(file_list,folder_path, dest, obj.no_of_components, speaker_name,obj.dimns, obj.type,obj.featureType);
                    aa=struct();
                    aa.sub = ab;
                    obj.hTable(speaker_name) = aa;
                end
            end
            result = values(obj.hTable);
        end
        
        function saveDB(obj)
            save(obj.db_path);
        end
        
        function allmodels = excludedModels(this, file_path)
            key = keys(this.hTable)';
            val = values(this.hTable)';
            [filepathstr, filename, ext] = fileparts(file_path);
            [~,speakername] = fileparts(filepathstr);
            
            allmodels = val(~strcmp(key,speakername));
            for i=1:length(allmodels)
                allmodels{i,1} = allmodels{i,1}.all;
            end
            
            me = val(strcmp(key,speakername));
            
            if (sum(strcmp(key,speakername))>0)
                submodels = values(me{1}.sub);
                for i=1:length(submodels)
                    currfiles = submodels{i}.file_list;
                    check = 0;
                    for kk=1:length(currfiles)
                        if (strcmp(currfiles(kk).name, [filename ext])==1)
                            check = 1;
                            break;
                        end
                    end
                    if (check==0)
                        cand = submodels{i};
                        break;
                    end
                end
                
                if (exist('cand','var'))
                    allmodels{size(allmodels,1)+1,1} = cand;
                end
            end
        end
        
        function obj = compare(this, models, s,fs)      % format: compare(this, models, s,fs) or compare(this, models, wav_file_path)
            if (nargin==3)
                [s, fs] = audioread(s);
            end
            X = Features.featureSet(s, fs, this.dimns,this.featureType)';
            obj = models{1}.compare(X,models);
        end
        
        function [llhs, model_names] = verify(this, models, s,fs)      % format: compare(this, models, s,fs) or compare(this, models, wav_file_path)
            if (nargin==3)
                [s, fs] = audioread(s);
            end
            X = Features.featureSet(s, fs, this.dimns, this.featureType)';
            [llhs, model_names] = ModelUBM.Old_verify(X,models,this.ubm);
        end
        
        function [simi, model_names] = similarity(this, models, s,fs)      % format: compare(this, models, s,fs) or compare(this, models, wav_file_path)
            if (nargin==3)
                [s, fs] = audioread(s);
            end
            
            X = Features.featureSet(s, fs, this.dimns, this.featureType)';
            simi = zeros(1,length(models));
            model_names = cell(1,length(models));
            for t=1:length(models)
                [~, log_like_model] = posterior(models{t}.model,X);
                simi(1,t) = log_like_model/size(X,1);
                model_names{1,t} = models{t}.speaker;
            end
        end
        
    end
end
