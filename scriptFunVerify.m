function [Table, eer] = scriptFunVerify(db_name,c)

db_Path = [Utils.DB_FOLDER '\' db_name];
Folders = dir((db_Path));
% [speakers,likz,max_misses,max_false] = ModelUBM.getResults(c.ubm);isempty(speakers)
likz = [];
speakers = logical([]);
max_misses=0;
max_false=0;
 %c.ubm = ubm.model;
if (1)
    for i=1:length(Folders)
        if (Folders(i).isdir && ~strcmp(Folders(i).name, '.')&& ~strcmp(Folders(i).name, '..'))
            FolderPath  = [db_Path, '\', Folders(i).name];
            files = dir([FolderPath, '\*.wav']);
            disp(['comparing folder: ' FolderPath]);
            for j=1:size(files,1)
                file_path=[FolderPath '\' files(j).name];
                as = c.excludedModels(file_path); % no need to evaluate this each time
                [llhs, model_names] = c.verify(as,file_path);       % similarity  verify(models, ubmpath, s,fs) or verify(models, ubmpath, wav_file_path)
                
                likz = [likz; llhs];
                speakers = [speakers; strcmp(Folders(i).name, model_names)];
                
                max_misses = max_misses+1;
                max_false = max_false + length(model_names)-1;
            end
        end
    end
    c.ubm = ModelUBM.setResults(c.ubm,speakers,likz,max_misses,max_false);
    c.saveDB();
else
    disp('Likelihood results found. Skipping to threshold test');
end

%% normalize


%%
arr = -100:.001:100;
pfa = zeros(size(arr));
pmis = zeros(size(arr));
i=0;
for thesh = arr
    i = i+1;
    temp = likz < thesh;
    pfa(i) = sum(temp(~speakers))/max_false;
    pmis(i) = sum(~temp(speakers))/max_misses;
end

Table(:,1) = arr;
Table(:,2) = pmis;
Table(:,3) = pfa;

sq = (pfa-pmis).^2;
ss = sort(sq);
ff = find(sq==ss(1));
eer = .5*pfa(ff(ceil(length(ff)/2))) + .5*pmis(ff(ceil(length(ff)/2)));

save('workz');