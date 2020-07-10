classdef HashStore
    properties (SetAccess = protected)
        hTable;
        path;
        speaker;
        model;
    end
    methods
        
         function M = HashStore() %% constructor
             folder_path = 'C:\Forensic_Audio_workspace';
             
             if(exist(folder_path,'dir'))
                 display('folder found');
             else
                 mkdir(folder_path);
             end

             M.path = 'C:\Forensic_Audio_workspace\cases.mat';
              if(exist(M.path,'file'))  % small problem with the exist logic.. works the other way when there is nothing
                disp('Database file found.');
                h = load(M.path);
                M.hTable = h.hTable;
               
              else
                   disp('No database file found. Creating new file');
                    M.hTable =  containers.Map();
                       
         end
         end
         
         function result = add_case(M,ID,name,Date,officer_name,officer_id,description)
             if (isKey(M.hTable,ID))
                    result = ' This case has already been entered';
             else
             new_case = struct();
             new_case.Name = name;
             new_case.Date = Date;
             new_case.Evidence = containers.Map();
             new_case.Option1 = struct();
             new_case.Option1.Suspects = containers.Map();
             new_case.Option2 = struct();
             new_case.Option2.Suspects = containers.Map();
             new_case.Option3 = struct();
             new_case.Option3.Suspects = containers.Map();
             new_case.Officer_name = officer_name;
             new_case.Officer_ID = officer_id;
             new_case.Description = description;
             M.hTable(ID)= new_case;
             
              result = 'New Case successfully saved';
                    hTable = M.hTable;
                    save(M.path,'hTable');
             end
         end
         
         function result = add_evidence(M,ID,remarks,recording_date,s,fs,path,filename,clip_length)
              if (isKey(M.hTable,ID)) 
             key = M.hTable(ID);
              Table = key.Evidence;
                            
             if (isKey(Table,filename))
                    result = ' This clip has already been entered';
                else
                    evidence=struct();
                     display('calculating MFCC');
                     X = Utils.mfcc(s, fs, 20)';
              
                   
                    evidence.ID = ID;
                    evidence.remarks = remarks;
                    evidence.clip_length = clip_length;                   
                    evidence.Recording_Date = recording_date;
                    evidence.filepath = path;
                    evidence.MFCC = X;
                    
                    key.Evidence(filename) = evidence;
                    
                    result = 'Evidence and clip successfully saved';
                    hTable = M.hTable;
                    save(M.path,'hTable');
             end
              else
                  result = 'Case not found';
              end
         end
        
    
         function result = add_suspect(M,option,ID,name,NIC,bday,gender,address,recording_date,mismatch,remarks,s,fs,path,filename,clip_length)
              if (isKey(M.hTable,ID)) 
             key = M.hTable(ID);
             
             if(option == 1)
                 Struct =  key.Option1();
             elseif (option == 2)
                 Struct =  key.Option2();
                 
             else
                 (option == 3)
                 Struct =  key.Option3();
             end
             Table = Struct.Suspects;
             
             if (isKey(Table,filename))
                    result = ' This clip has already been entered';
                else
                    suspect=struct();
                    [X,suspect_model] = HashStore.new_model(s,fs);
                    
                    suspect.Name = name;
                    suspect.NIC = NIC;
                    suspect.Birthday = bday;
                    suspect.clip_length =clip_length;
                    
                    if (gender==1)
                    suspect.Gender = 'Female';
                    else
                    suspect.Gender = 'Male';
                    end
                            
                    suspect.Address =  address;
                    suspect.Recording_Date = recording_date;
                    suspect.mismatch =mismatch;
                    suspect.Remarks = remarks;
                    suspect.filepath = path;
                    suspect.MFCC = X;
                    suspect.model = suspect_model;
                    Struct.Suspects(filename) = suspect;
                    
                    result = 'Suspect and clip successfully saved';
                    hTable = M.hTable;
                    save(M.path,'hTable');
             end
                 else
                  result = 'Case not found';
         end
     
         end
    
         function result =  save_ubm(M,ID,ubm,Table,eer,details)
              key = M.hTable(ID);
              Struct1 =  key.Option2();
              Struct1.UBM = ubm;
              Struct1.Table = Table;
              Struct1.eer = eer;
              Struct1.details = details;
              key.Option2 = Struct1;
              M.hTable(ID) = key;
              hTable = M.hTable;
              save(M.path,'hTable');
              result = 'UBM successfully saved';
         end
         
    end
    
    methods(Static)
        
        function [X,model] = new_model(s, fs)
            display('calculating MFCC');
            X = Utils.mfcc(s, fs, 20)';
            % run VAD and send percentage of voice to total audio length
                  
          options = statset('Display','final','MaxIter',Utils.MAXIMUM_ITERATIONS);
            model = gmdistribution.fit(X,16,...
                'Start','randSample',...
                'Replicates',Utils.REPLICATES,...
                'CovType','diagonal',...
                'SharedCov',false,...
                'Options',options);
            
        end
        
        
        
        function score = verify(suspect,evidence,ubm)
              X = evidence.MFCC ; 
            [~, log_like_ubm] = posterior(ubm.x.model,X);
            
            [~, log_like_model] = posterior(suspect.model,X);
                score = log_like_model - log_like_ubm;
                score = score/length(X);
              
              
            end
         
        
    end
end