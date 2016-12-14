bb=bbs(bbs(:,5)>40,:);
 p=bb(:,5);
% 
 d=2; k=length(p);
% 
% mu=[bb(:,1) bb(:,2)];
% %sigma=zeros(1,d,k);
% %sigma(1,:,:)=5*[bb(:,3) bb(:,4)]';
sigma=[200 0;0 200];


%p=[bb(:,5);bb(:,5);bb(:,5);bb(:,5)];

%d=2; k=length(p);

mu=[bb(:,1)+bb(:,3)/2    bb(:,2);
    bb(:,1)+bb(:,3)/2   bb(:,2) + bb(:,4);
   bb(:,1)               bb(:,2)+ bb(:,4)/2;
   bb(:,1)+bb(:,3)       bb(:,2) + bb(:,4)/2];

%sigma=zeros(1,d,k);
% %sigma(1,:,:)=[  bb(:,3) bb(:,4);
%                 bb(:,3) bb(:,4);
%                 bb(:,3) bb(:,4);
%                 bb(:,3) bb(:,4)]';

mapv=[];
for m=1:4
gx_=abs(gx)./max(abs(gx(:)));
[y,x]=meshgrid(1:size(I,1),1:size(I,2));


obj = gmdistribution(mu((m-1)*k+1:m*k,:),sigma,p);
vals=pdf(obj,[x(:) y(:)]); 
vals_=((vals)./max((vals(:))));
% vals_=max(vals_)-vals_;vals_(vals_>0.9)=0;
mapv(m,:,:)=(reshape(vals_,size(I1'))');
end

maxmapv=squeeze(max(mapv));
figure;
imagesc(maxmapv);hold on
bbApply('draw',bbs(bbs(:,5)>40,:)); 

a=zeros(size(I1));
f=maxmapv.*gx_;
a(subs_v,:)=f(subs_v,:)+f(subs_v+1,:)+f(subs_v-1,:);
a(:,subs_h)=f(:,subs_h)+f(:,subs_h+1)+f(:,subs_h-1);
figure;
imagesc(a);hold on
bbApply('draw',bbs(bbs(:,5)>40,:)); 
