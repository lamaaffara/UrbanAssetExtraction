bb=bbs(bbs(:,5)>40,:);
p=bb(:,5);

d=2; k=length(p);

mu=[(bb(:,1) + bb(:,3)/2) (bb(:,2) + bb(:,4)/2)];
%sigma=zeros(1,d,k);
%sigma(1,:,:)=5*[bb(:,3) bb(:,4)]';
sigma=[200 0;0 200];

obj = gmdistribution(mu,sigma,p);
gx_=abs(gx)./max(abs(gx(:)));
[y,x]=meshgrid(1:size(I,1),1:size(I,2));

vals=pdf(obj,[x(:) y(:)]); 
vals_=((vals)./max((vals(:))));
% vals_=max(vals_)-vals_;vals_(vals_>0.9)=0;
mapv=(reshape(vals_,size(I1'))');
figure;
imagesc(mapv);hold on
bbApply('draw',bbs(bbs(:,5)>40,:)); 


E=corner(I1,'SensitivityFactor',0.24);
figure;
imagesc(I);hold on;scatter(E(:,1),E(:,2));