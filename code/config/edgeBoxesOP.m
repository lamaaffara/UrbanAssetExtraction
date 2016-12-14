classdef edgeBoxesOP < objectProp
    properties
        modeltype;
        model;
        dd;
        opts;
    end
    methods
        
        function obj = edgeBoxesOP()
            obj.name = 'edgeBoxesOP';
        end
        
        function setModel(obj,model)
            obj.modeltype=model;
        end
        
        function setupOP(obj,dd,~)
            %% load pre-trained edge detection model and set opts (see edgesDemo.m)
            model_=load([get_adr(obj.modeltype) 'modelBsds']); model_=model_.model;
            model_.opts.multiscale=0; model_.opts.sharpen=2; model_.opts.nThreads=4;
            
            obj.model=model_;
            
            
            %% set up opts for edgeBoxes (see edgeBoxes.m)
            opts_ = edgeBoxes;
            opts_.alpha = .65;     % step size of sliding window search
            opts_.beta  = .9;     % nms threshold for object proposals
            opts_.minScore = .01;  % min score of boxes to detect
            
            if dd
                opts_.maxBoxes = obj.maxBoxes+20000;  % max number of boxes to detect
            else
                opts_.maxBoxes =  obj.maxBoxes;
            end
            obj.dd=dd;
            obj.opts=opts_;
            
            
        end
        
        function boxes=runOP(obj,I,~)
            boxes=edgeBoxes(I,obj.model,obj.opts);
            try
            boxes=wl2xy(boxes);
            catch;end;
        end
    end
end