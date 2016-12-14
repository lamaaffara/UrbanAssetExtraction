% Demo for Sticky Superpixels (please see readme.txt first).
addpath('D:\Image Datasets\INRIA\code3.2.1\data-INRIA\VOCdevkit_18-May-2011\VOCdevkit\VOCcode');
addpath('E:\E\KAUST\GMSV\Urban_Image_Processing\LargeScaleWindowDetection\code\tools');
addpath('E:\E\KAUST\GMSV\Urban_Image_Processing\LargeScaleWindowDetection\code\resultgeneration');
%InitializeParallel(12)
clc;clear all;close all;

cd(fileparts(which('spDemo.m')));
%% load pre-trained edge detection model and set opts (see edgesDemo.m)
model=load('models/forest/modelBsds'); model=model.model;
model.opts.nms=-1; model.opts.nThreads=4;
model.opts.multiscale=0; model.opts.sharpen=2;

%% set up opts for spDetect (see spDetect.m)
% opts = spDetect;
% opts.nThreads = 4;  % number of computation threads
% opts.k = 0.01;       % controls scale of superpixels (big k -> big sp)
% opts.alpha = .5;    % relative importance of regularity versus data terms
% opts.beta = .9;     % relative importance of edge versus color terms
% opts.merge = 0;     % set to small value to merge nearby superpixels at end

opts = spDetect;
opts.nThreads = 12;  % number of computation threads
opts.k = 512;       % controls scale of superpixels (big k -> big sp)
opts.alpha = .5;    % relative importance of regularity versus data terms
opts.beta = .9;     % relative importance of edge versus color terms
opts.merge = 0;     % set to small value to merge nearby superpixels at end
opts.bounds=1;

%% detect and display superpixels (see spDetect.m)
cd('E:\E\KAUST\GMSV\Urban_Image_Processing\edges-master\private')

imdir='E:\E\KAUST\GMSV\Datasets\Urban\strasburg\rectified\';

imname='IMG_3669.jpg';
I=(imread([imdir imname]));

[E,~,~,segs]=edgesDetect(I,model);
tic, [S,V] = spDetect(I,E,opts); toc
% figure(1); im(I); figure(2); im(V);

%% compute ultrametric contour map from superpixels (see spAffinities.m)
% tic, [~,~,U]=spAffinities(S,E,segs,opts.nThreads); toc
%  figure(3); im(1-U); return;


gtdir='E:\E\KAUST\GMSV\Datasets\Urban\strasburg\groundtruth\map\';
gt = bbGt('bbLoad',['E:\E\KAUST\GMSV\Datasets\Urban\strasburg\groundtruth\BBoxes_voc\' imname(1:end-4) '.txt'],{'format',1});
bb=cat(1,gt(:).bb);

map=(imread([gtdir imname(1:end-4) '.png']));
max(S(:))
sc1=superpixelEvaluation(map,S,0.5)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I1=rgb2gray(I);

H=double(sum(E,1));V=double(sum(E,2));

[subs_h,~] = nonMaxSupr(H,1);
subs_h=subs_h(H(subs_h(:,2))>0,2);
[subs_v,~] = nonMaxSupr(V',1);
subs_v=subs_v(V(subs_v(:,2))>0,2);

c=[1;sort(subs_h);size(I,2)];
r=[1;sort(subs_v);size(I,1)];
% cdif=Inf;rdif=Inf;
% while cdif>0 || rdif>0
% 
% dif=c-[0;c(1:length(c)-1)];
% c([1;dif(1:length(c)-1)]<=0)=[];
% cdif=sum(dif<=0)
% dif=r-[0;r(1:length(r)-1)];
% r([1;dif(1:length(r)-1)]<=0)=[];
% rdif=sum(dif<=1)
% if c(1)>2
%     c=[1;c];
% else
%     c(1)=1;
% end
% if r(1)>2
%     r=[1;r];
% else
%     r(1)=1;
% end
% 
% if c(end)<size(I,2)-2
%     c=[c;size(I,2)];
% else
%     c(end)=size(I,2);
% end
% if r(end)<size(I,1)-2
%     r=[r;size(I,1)];
% else
%     r(end)=size(I,1);
% end
% end
k=1;
S21=zeros(size(I1));
for i=2:length(r)
    for j=2:length(c)
        S21(r(i-1):r(i)-1,c(j-1):c(j)-1)=k;
        k=k+1;
    end
end
  k
  S21(:,c)=0;
   S21(r,:)=0;
   
  S21 = uint32(S21);
%   Imap=spVisualize(I,S21);
% figure;imagesc(rgb2gray(Imap));colormap gray;hold on;bbApply('draw',bb); 
sc2=superpixelEvaluation(map,S21,0.5)

% tic, J = rgbConvert( Imap, 'luv' ); toc
% figure;imagesc(J(:,:,3))
%%%%%%%%%%%%%%%%%%%%%%%%
I1=rgb2gray(I);

[gx,gy]=imgradient(I1);

H=(sum(gx,1));V=(sum(gx,2));

[subs_h,~] = nonMaxSupr(H,1);
[subs_v,~] = nonMaxSupr(V',1);




k=1;

S2=zeros(size(I1));
for i=2:length(r)
    for j=2:length(c)
        S2(r(i-1):r(i)-1,c(j-1):c(j)-1)=k;
        k=k+1;
    end
end
  k
S2(:,c)=0;
S2(r,:)=0;
   
S2 = uint32(S2);
sc3=superpixelEvaluation(map,S2,0.5) 

% Imap=spVisualize(I,S2);
% figure;imagesc(Imap);

 
S3 = spDetectMex('merge',uint32(S),E,2e-3);
length(unique(S3(:)))
sc6=superpixelEvaluation(map,S3,0.5) 
% Imap=spVisualize(I,S3);
% figure;imagesc(Imap);hold on;bbApply('draw',bb);
 
S3 = spDetectMex('merge',uint32(S21),E,2e-3);
length(unique(S3(:)))
sc4=superpixelEvaluation(map,S3,0.5) 
% Imap=spVisualize(I,S3);
% figure;imagesc(Imap);hold on;bbApply('draw',bb); 

locs_c=zeros(size(I1));locs_r=zeros(size(I1));locs_sp=zeros(size(I1));
locs_c(:,c)=1;locs_r(r,:)=1;locs_sp(S3==0)=1;
locs=(locs_c & locs_r & locs_sp);
[y,x]=find(locs);
imagesc(I)
hold on
scatter(x,y,'*')
sum(locs(:))
return
S3 = spDetectMex('merge',uint32(S2),E,2e-3);
length(unique(S3(:)))
sc5=superpixelEvaluation(map,S3,0.5)  
Imap=spVisualize(I,S3);
figure;imagesc(Imap);hold on;bbApply('draw',bb); 


%% compute video superpixels reusing initialization from previous frame
% Is=seqIo(which('peds30.seq'),'toImgs'); Vs=single(Is); opts.bounds=0; tic
% for i=1:size(Is,4), I=Is(:,:,:,i); E=edgesDetect(I,model);
%   [opts.seed,Vs(:,:,:,i)]=spDetect(I,E,opts); end; opts.seed=[]; toc
% Vs=uint8(Vs*255); playMovie([Is Vs],15,-10,struct('hasChn',1))

