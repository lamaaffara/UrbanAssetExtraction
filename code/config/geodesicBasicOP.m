classdef geodesicBasicOP < objectProp
    properties
        modeltype;
        p;
    end
    methods
        function obj = geodesicBasicOP()
            obj.name = 'geodesicBasicOP';
        end
        
        function setModel(obj,model)
            obj.modeltype=model;
        end
        
        function setupOP(obj,~,~)
            mssf=['MultiScaleStructuredForest("' get_adr(obj.modeltype) 'sf.dat")'];
            gop_mex( 'setDetector', mssf );
            
            switch obj.maxBoxes
                case 1000
                    un=150;%84;
                case 2000
                    un=175;
                case 3000
                    un=1300;%1200;%266;
                case 5000
                    un=448;
                case 10000
                    un=902;
            end
            
            % Setup the proposal pipeline (baseline)
            obj.p = Proposal('max_iou', 1,...
                'unary', un, 5, 'seedUnary()', 'backgroundUnary({0,15})',...
                'unary', un, 1, 'seedUnary()', 'backgroundUnary({})', 0, 0, ... % Seed Proposals (v1.2 and newer)
                'unary', 0, 5, 'zeroUnary()', 'backgroundUnary({0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15})' ... % Background Proposals
                );
        end
        
        function boxes=runOP(obj,I,~)
            
            os = OverSegmentation( I );[L,W,~]=size(I);
                        
            props = obj.p.propose( os );
                     
            boxes = os.maskToBox( props );
            dt0=double(xy2wl(boxes));
            dt0((dt0(:,3)/W)<0.025 | (dt0(:,4)/L)<0.025 | (dt0(:,3)./dt0(:,4))<0.25,:)=[];
            dt0((dt0(:,3)/W)>0.2 | (dt0(:,4)/L)>0.2 | (dt0(:,3)./dt0(:,4))>4,:)=[];
            boxes=uint32(wl2xy(dt0));
        end
    end
end

