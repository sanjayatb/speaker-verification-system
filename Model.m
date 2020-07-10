classdef Model
    
    properties (SetAccess = protected)
        speaker;
        file_list;
        model;
		voiced_to_toal_audio_length;
		building_time;
    end
    
    methods(Static, Abstract)
        fitModel(X,no_of_components);
        compare(file_path, models);
    end
end
