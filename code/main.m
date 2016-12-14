clear all;close all;clc;

header;

%% Configure Code

% input: dataset_number, object_proposal_method, feature_method, classifier, rectification_method
% if no input argument, select from dialog boxes
[datasets,dataset_id,objectprop,features,classifier,rectMethod]=selectDataMethods(7,5,2,1,2);

datasetConfig = DatasetConfig.getInstance(datasets,dataset_id,classifier,objectprop,features,rectMethod,ov,numProp,dd);
% run in parallel for large datasets
if datasetConfig.nWorkers>1
    parfor i=1:datasetConfig.nWorkers
        DatasetConfig.getInstance(datasets,dataset_id,classifier,objectprop,features,rectMethod,ov,numProp,dd);
    end
end

%% Rectify
Rectify;


