classdef priors < handle
    
    properties (SetAccess = protected)
        globalPrior;
        dataPrior;
        imagePrior;
        combinedPrior;
        w_data=0.3;
        w_global=0.3;
        w_image=0.4;
    end
    
    
    methods
        
        function setGlobalPrior(obj,prior)
            obj.globalPrior=prior;
        end
        
        function setDataPrior(obj,prior)
            obj.dataPrior=prior;
        end
        
        function setImagePrior(obj,prior)
            obj.imagePrior=prior;
        end
        
        function setImagePriorXY(obj,pdfx,pdfy,pdfs,pdfar)
            obj.imagePrior.p_x=pdfx;
            obj.imagePrior.p_y=pdfy;
            obj.imagePrior.p_s=pdfs;
            obj.imagePrior.p_ar=pdfar;
            
        end
        
        function Initialize(obj,g,d,im)
            obj.imagePrior=obj.globalPrior;
            obj.dataPrior=obj.globalPrior;
            obj.combinedPrior=obj.globalPrior;
            if nargin>1
            obj.w_global=g;
            obj.w_data=d;            
            obj.w_image=im;
            end
        end
        
        function TrainGlobal(obj,boxes)
            data=cell2mat(boxes);
            
            p_x = ksdensity(data(:,1),0:0.001:1,'function','pdf','width',0.05);p_x=p_x/sum(p_x);
            p_y = ksdensity(data(:,2),0:0.001:1,'function','pdf','width',0.05);p_y=p_y/sum(p_y);
            p_s = ksdensity(data(:,4),0:0.001:1,'function','pdf','width',0.007);p_s=p_s/sum(p_s);
            p_ar = ksdensity(data(:,5),0:0.01:10,'function','pdf','width',0.03);p_ar=p_ar/sum(p_ar);
            
            obj.globalPrior.p_x=p_x;
            obj.globalPrior.p_y=p_y;
            obj.globalPrior.p_s=p_s;
            obj.globalPrior.p_ar=p_ar;
            
            obj.combinedPrior=obj.globalPrior;
        end
        
        function TrainData(obj,boxes)
            data=cell2mat(boxes);
            
            p_x = ksdensity(data(:,1),0:0.001:1,'function','pdf','width',0.05,'weights',data(:,end));p_x=p_x/sum(p_x);
            p_y = ksdensity(data(:,2),0:0.001:1,'function','pdf','width',0.05,'weights',data(:,end));p_y=p_y/sum(p_y);
            p_s = ksdensity(data(:,4),0:0.001:1,'function','pdf','width',0.007,'weights',data(:,end));p_s=p_s/sum(p_s);
            p_ar = ksdensity(data(:,5),0:0.01:10,'function','pdf','width',0.03,'weights',data(:,end));p_ar=p_ar/sum(p_ar);
            
            obj.dataPrior.p_x=p_x;
            obj.dataPrior.p_y=p_y;
            obj.dataPrior.p_s=p_s;
            obj.dataPrior.p_ar=p_ar;
            
        end
        
        function TrainImage(obj,boxes)
            data=cell2mat(boxes);
            
            p_x = ksdensity(data(:,1),0:0.001:1,'function','pdf','width',0.05,'weights',data(:,end));p_x=p_x/sum(p_x);
            p_y = ksdensity(data(:,2),0:0.001:1,'function','pdf','width',0.05,'weights',data(:,end));p_y=p_y/sum(p_y);
            p_s = ksdensity(data(:,4),0:0.001:1,'function','pdf','width',0.007,'weights',data(:,end));p_s=p_s/sum(p_s);
            p_ar = ksdensity(data(:,5),0:0.01:10,'function','pdf','width',0.03,'weights',data(:,end));p_ar=p_ar/sum(p_ar);
            
            obj.imagePrior.p_x=p_x;
            obj.imagePrior.p_y=p_y;
            obj.imagePrior.p_s=p_s;
            obj.imagePrior.p_ar=p_ar;
            
        end
        
        function Update(obj)
            w_im=obj.w_image;w_d=obj.w_data;w_gl=obj.w_global;
            obj.combinedPrior.p_x=(w_im*obj.imagePrior.p_x+w_d*obj.dataPrior.p_x+w_gl*obj.globalPrior.p_x);
            obj.combinedPrior.p_y=(w_im*obj.imagePrior.p_y+w_d*obj.dataPrior.p_y+w_gl*obj.globalPrior.p_y);
            obj.combinedPrior.p_s=(w_im*obj.imagePrior.p_s+w_d*obj.dataPrior.p_s+w_gl*obj.globalPrior.p_s);
            obj.combinedPrior.p_ar=(w_im*obj.imagePrior.p_ar+w_d*obj.dataPrior.p_ar+w_gl*obj.globalPrior.p_ar);
        end
        
        function Plot(obj)
            
            x=linspace(0,1,length(obj.combinedPrior.p_x));x2=linspace(0,10,length(obj.combinedPrior.p_ar));
            
            subplot(4,4,1);plot(x,obj.combinedPrior.p_x,'linewidth',1,'color','r');axis([0 1 0 4e-3]);
            subplot(4,4,2);plot(x,obj.combinedPrior.p_y,'linewidth',1,'color','r');axis([0 1 0 4e-3]);
            subplot(4,4,3);plot(x,obj.combinedPrior.p_s,'linewidth',1,'color','r');axis([0 0.5 0 0.04]);
            
            subplot(4,4,4);plot(x2,obj.combinedPrior.p_ar,'linewidth',1,'color','r');axis([0 5 0 0.04]);
            
            
            subplot(4,4,5);plot(x,obj.imagePrior.p_x,'linewidth',1,'color','r');axis([0 1 0 4e-3]);
            subplot(4,4,6);plot(x,obj.imagePrior.p_y,'linewidth',1,'color','r');axis([0 1 0 4e-3]);
            subplot(4,4,7);plot(x,obj.imagePrior.p_s,'linewidth',1,'color','r');axis([0 0.5 0 0.04]);
            subplot(4,4,8);plot(x2,obj.imagePrior.p_ar,'linewidth',1,'color','r');axis([0 5 0 0.04]);
            
            subplot(4,4,9);plot(x,obj.dataPrior.p_x,'linewidth',1,'color','r');axis([0 1 0 4e-3]);
            subplot(4,4,10);plot(x,obj.dataPrior.p_y,'linewidth',1,'color','r');axis([0 1 0 4e-3]);
            subplot(4,4,11);plot(x,obj.dataPrior.p_s,'linewidth',1,'color','r');axis([0 0.5 0 0.04]);
            subplot(4,4,12);plot(x2,obj.dataPrior.p_ar,'linewidth',1,'color','r');axis([0 5 0 0.04]);
            
            subplot(4,4,13);plot(x,obj.globalPrior.p_x,'linewidth',1,'color','r');axis([0 1 0 4e-3]);
            subplot(4,4,14);plot(x,obj.globalPrior.p_y,'linewidth',1,'color','r');axis([0 1 0 4e-3]);
            subplot(4,4,15);plot(x,obj.globalPrior.p_s,'linewidth',1,'color','r');axis([0 0.5 0 0.04]);
            subplot(4,4,16);plot(x2,obj.globalPrior.p_ar,'linewidth',1,'color','r');axis([0 5 0 0.04]);
        end
        
    end
    
end
