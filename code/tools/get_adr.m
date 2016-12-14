function adr = get_adr(type)

datasetConfig = DatasetConfig.getInstance();

projectbase='\\gmsv-strgcon-01\Lama\LargeScaleWindowDetection';
dt=datasetConfig.dataLocation;dt=dt(3:end);

switch type
    
    % ========================================= < Data Files > =========================================
    case 'data'
        adr = [datasetConfig.dataLocation];
    case 'splits'
        adr = [datasetConfig.dataLocation datasetConfig.splitsLocation];
    case 'tr_images'
        adr = [datasetConfig.trlocation{1}];
    case 'tr_labels'
        adr = [datasetConfig.trlocation{2} 'positive\'];
    case 'tr_labels_negative'
        adr = [datasetConfig.dataLocation datasetConfig.trainLocation datasetConfig.neglabelLocation];
    case 'images'
        adr = [datasetConfig.location{1} '\'];
    case 'labels' 
        adr = [datasetConfig.location{2} '\'];
    
    % ======================================== < Output Files > ========================================
    case 'output'
        adr = [datasetConfig.outputLocation];
    case 'rectified'
        adr = [datasetConfig.outputLocation datasetConfig.workLocation];
    case 'models'
        adr = [datasetConfig.outputLocation datasetConfig.modelLocation];
    case 'results'
        adr = [datasetConfig.outputLocation datasetConfig.resultsLocation];
    case 'results_windows'
        adr = [datasetConfig.outputLocation datasetConfig.resultsLocation 'windows/'];
    case 'results_images'
        adr = [datasetConfig.outputLocation datasetConfig.resultsLocation 'images/'];
    case 'results_proposals'
        adr = [datasetConfig.outputLocation datasetConfig.resultsLocation 'proposals/'];
    case 'results_proposals+urban'
        adr = [datasetConfig.outputLocation datasetConfig.resultsLocation 'proposals+urban/'];
    case 'results_bboxes'
        adr = [datasetConfig.outputLocation datasetConfig.resultsLocation 'bboxes/'];
    case 'results_features'
        adr = [datasetConfig.outputLocation datasetConfig.resultsLocation 'features/'];
    case 'priors'    
        adr = [datasetConfig.outputLocation datasetConfig.priorsLocation];
        
   % ======================================= < Database Files > =======================================
    case 'windowDB'
        adr = [datasetConfig.windowDBLocation];
    case 'models_0'        
        adr = [datasetConfig.windowDBLocation datasetConfig.modelLocation];
    case 'priors_0'    
        adr = [datasetConfig.windowDBLocation datasetConfig.priorsLocation];
        
   % ======================================= < Temporary Files > ======================================       
    case 'tmp'
        adr = '../tmp/';
   
    % Other
    case 'images_splits'
        adr = [projectbase dt 'test\images\'];
    case 'tr_images_splits'
        adr = [projectbase dt 'train\images\'];
    case 'bing_labels'
        adr = [datasetConfig.dataLocation 'labels/'];
    case 'bing_images'
        adr = [datasetConfig.dataLocation 'images/'];
    case 'bing_ymlannotations'
        adr = [datasetConfig.dataLocation 'annotations/'];
    otherwise
        error('Unrecognized type!');
end

end


%     case 'image_orig'
%         adr = [datasetConfig.dataLocation datasetConfig.imageLocation par1];
%     case 'label'
%         adr = [datasetConfig.dataLocation datasetConfig.labelLocation par1];
%     case 'image_tr'
%         adr = [datasetConfig.dataLocation datasetConfig.trimageLocation par1];
%     case 'label_tr'
%         adr = [datasetConfig.dataLocation datasetConfig.trlabelLocation par1];
%         
%         
%     case 'image_work'
%         adr = [datasetConfig.outputLocation 'work/' par1 '.jpg'];
%     case 'proposal'
%         adr = [datasetConfig.outputLocation 'results/proposals/' par1 '.txt'];
%     case 'bbox'
%         adr = [datasetConfig.outputLocation 'results/bboxes/' par1 '.txt'];
%     case 'features'
%         adr = [datasetConfig.outputLocation 'results/features/' par1 '.mat'];