function [gt,dt]=getboxes(outdir,datadir,indices)

% cf = DatasetConfig.getInstance();

imageNames=LoadFilenames(outdir,'txt');
if ~isempty(indices)    
imageNames=imageNames(indices);
end

parfor it=1:length(imageNames)
    if ~isempty(datadir)
    map=imread([datadir imageNames{it} '.png']);[L,W,~]=size(map);
    
    s=regionprops(rgb2gray(map)==76,'BoundingBox');
    
    bb=cat(1,s.BoundingBox); 
    
    gt{it}=bb;
    
    else
        gt{it}=[];
    end
    
    try
    boxes_nms=dlmread([outdir imageNames{it} '.txt']);
    dt0=xy2wl(boxes_nms);
    %dt0(dt0(:,3)./dt0(:,4)<0.25 | dt0(:,3)<(0.025*W) | dt0(:,4)<(0.025*L) ,:)=[];
    
    dt{it}=dt0;
    
    catch
        dt{it}=[];
        %warning([outdir imageNames{it} '.txt']);
    end
    
    
end

