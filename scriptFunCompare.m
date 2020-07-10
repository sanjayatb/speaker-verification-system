function [acc, corr, incr, duracompare, incr_list] = scriptFunCompare(db_name,c,noiseFile,SNR)

db_Path = [Utils.DB_FOLDER '\' db_name];
Folders = dir((db_Path));
tStart=tic;
incr_list = cell(0);
corr=0;
incr=0;
for i=1:length(Folders)
    if (Folders(i).isdir && ~strcmp(Folders(i).name, '.')&& ~strcmp(Folders(i).name, '..'))
        FolderPath  = [db_Path, '\', Folders(i).name];
        files = dir([FolderPath, '\*.wav']);
        disp(['comparing folder: ' FolderPath]);
        disp(['speaker: ' Folders(i).name]);
        for j=1:size(files,1)
            file_path=[FolderPath '\' files(j).name];
            as = c.excludedModels(file_path);
            
            if (nargin>2)
                [aa,fs] = NoiseStore.addNoise(SNR,file_path,[Utils.DB_FOLDER '\' Utils.NOISE_DB '\' noiseFile], [Utils.DB_FOLDER '\noisy\' noiseFile '_' num2str(SNR) '_']);
                answer = c.compare(as,aa,fs);
            else
                answer = c.compare(as,file_path);       % format: compare(models, s,fs) or compare(models, wav_file_path)
            end
            disp(['result: ' answer.speaker]);
            
            if (strcmp(answer.speaker,Folders(i).name)==1)
                corr = corr+1;
            else
                incr = incr+1;
                st = struct();
                st.answer = answer;
                st.actual = Folders(i).name;
                st.file = file_path;
                incr_list = [incr_list; st];
            end
        end
    end
end
acc = 100*corr/(corr+incr);
duracompare=toc(tStart);
end