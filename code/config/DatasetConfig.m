classdef (Sealed) DatasetConfig < handle
    properties
        nWorkers;    
        name;
        id;
        location;
        trlocation;
                
        kFold;
        nRounds;
        gtAvailable;
        
        rectificationNeeded;
        rectificationMethod;
        resizeImages;
        
        overlapthreshold;
        
        configuration;
        proposalNum;
        
        adaptive;
        
        dataLocation                = '..\data\';            
                imageLocation                      = 'images\';   
                labelLocation                      = 'groundtruth\';
                
        outputLocation              = '..\output\';        
            workLocation                       = 'rectified\';
        	resultsLocation                    = 'results\';
            
        windowDBLocation            = '..\data\database\';
                    modelLocation                = 'models\';
                    priorsLocation               = 'priors\';
                    
        evaluationLocation          ='..\output\evalutaion\';
    end
    
    %%
    methods (Access = private)
        function datasetConfig = DatasetConfig(datasets,dataset_id,classifier,objectprop,features,rectMethod,ov,numProp,dd)
            % Configure parameters used to run the window extraction
            %   nWorkers: number of parallel workers 
            
            %   name: datasetname
            %   location: {1} images, {2} groundtruth maps
            
            %   nClasses: number of labels            
            %   cm: colormap used: NanColormap(),HaussmannColormap()
            
            %   kFold: 0(input split lists), k (k-fold cross validation)
            %   nRounds: number of training-testing rounds if kFold>1
            %   gtAvailable: must be true if training is needed i.e. if kFold>1 or kFold==0
            
            datasetConfig.nWorkers              = 12;
            
            datasetConfig.id                    = dataset_id;          
            datasetConfig.name                  = datasets{dataset_id,1}; 
            datasetConfig.location{1}           = datasets{dataset_id,2};   
            datasetConfig.location{2}           = datasets{dataset_id,3};
            
            datasetConfig.trlocation{1}         = '..\data\database\windowDB\db2\images\';   
            datasetConfig.trlocation{2}         = '..\data\database\windowDB\db2\labels\';   
            datasetConfig.trlocation{3}         = ''; 

            datasetConfig.kFold              	= 0;
            datasetConfig.nRounds              	= 1;
            datasetConfig.gtAvailable           = true;

            datasetConfig.rectificationMethod   = rectMethod;
            datasetConfig.resizeImages          = false;
            
            datasetConfig.overlapthreshold      = ov;
            datasetConfig.proposalNum           = numProp;
            
            datasetConfig.adaptive              = dd;

            datasetConfig.configuration = ConfigFactory.MakeConfig(classifier,objectprop,features,numProp);
        end
    end
    %%
    methods (Static)
        function singleObj = getInstance(dataset,id,classifier,op,features,ov,numProp,dd,rectMethod)
            persistent localObj
            if nargin<1
                if isempty(localObj) || ~isvalid(localObj)
                    error('DatasetConfig not initialized! Call getInstance(datasetName) once!');
                else
                    singleObj = localObj;
                end
                
            elseif nargin==9
                localObj = DatasetConfig(dataset,id,classifier,op,features,ov,numProp,dd,rectMethod);
                singleObj = localObj;
            else
                error('Usage: getInstance([dataset,id,classifier,objectproposals,features])');
            end
        end  
    end 
    
end