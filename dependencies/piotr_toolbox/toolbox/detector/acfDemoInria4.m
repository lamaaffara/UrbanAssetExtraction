% Demo for aggregate channel features object detector on Inria dataset.
%
% See also acfReadme.m
%
% Piotr's Computer Vision Matlab Toolbox      Version 3.40
% Copyright 2014 Piotr Dollar.  [pdollar-at-gmail.com]
% Licensed under the Simplified BSD License [see external/bsd.txt]

%%
addpath('D:\Image Datasets\INRIA\code3.2.1\data-INRIA\VOCdevkit_18-May-2011\VOCdevkit\VOCcode');
clc;clear all;close all;

%% extract training and testing images and ground truth
cd(fileparts(which('acfDemoInria2.m'))); dataDir='D:\Image Datasets\INRIA\code3.2.1\data-INRIA\Window\strasburg\';

%% set up opts for training detector (see acfTrain)
opts=acfTrain(); 
opts.posImgDir=[dataDir 'train/pos'];
opts.posGtDir=[dataDir 'train/posGt'];
opts.negImgDir=[dataDir 'train/neg'];
% opts.posWinDir=[dataDir 'P'];
% opts.negWinDir=[dataDir 'N'];

opts.pJitter=struct('flip',1); 
opts.pBoost.pTree.fracFtrs=1/16;
opts.pLoad={'format',1};

opts.name='models/AcfWindow2+';

% opts.modelDs=[100 41]; opts.modelDsPad=[128 64];
opts.nWeak=[32 128 512 2048];

%opts.modelDs=[20 20]; opts.modelDsPad=[27 27];
%opts.modelDs=[8 8]; opts.modelDsPad=[12 12];
opts.modelDs=[37.5 20]; opts.modelDsPad=[50 27];
%opts.nWeak=[64 256 1024 4096];
opts.pPyramid.pChns.pColor.smooth=0; 
% opts.pPyramid.pChns.pGradHist.softBin=1;
% opts.pPyramid.pChns.shrink=2; 
% 
% opts.pBoost.pTree.maxDepth=5; 
% opts.pBoost.discrete=0;
% opts.nNeg=25000; opts.nAccNeg=50000;

opts.pNms.overlap=1;

%pLoad={'lbls',{'person'},'ilbls',{'people'},'squarify',{3,.41}};
%opts.pLoad = [pLoad 'hRng',[50 inf], 'vRng',[1 1] ];


%% optionally switch to LDCF version of detector (see acfTrain)
if( 0 )
  opts.filters=[5 4]; opts.pJitter=struct('flip',1,'nTrn',3,'mTrn',1);
  opts.pBoost.pTree.maxDepth=3; opts.pBoost.discrete=0; opts.seed=2;
  opts.pPyramid.pChns.shrink=2; opts.name='models/LdcfInria';
end

%% train detector (see acfTrain)
detector = acfTrain( opts );

%% modify detector (see acfModify)
pModify=struct('cascThr',-1,'cascCal',.01);
detector=acfModify(detector,pModify);

%% run detector on a sample image (see acfDetect)
imgNms=bbGt('getFiles',{[dataDir 'test/pos']});
for it=1:30%length(imgNms)
I=imread([imdir 'IMG_3194' '.jpg']); tic, bbs=acfDetect(I,detector); toc
imgNms{it}
clf; im(I); 
I1=rgb2gray(I);
[gx,gy]=imgradient(I1);
hold on
H=(sum(gx,1));V=(sum(gx,2));

[subs_h,~] = nonMaxSupr(H,3);subs_h=sort(subs_h(:,2));
[subs_v,~] = nonMaxSupr(V',3);subs_v=sort(subs_v(:,2));

plot(H/max(H)*100,'linewidth',2);
plot([subs_h subs_h],[1 size(I,1)],'b');

plot(V/max(V)*100,1:size(I,1),'red','linewidth',2);
plot([1 size(I,2)],[subs_v subs_v],'r');

bbApply('draw',bbs(bbs(:,5)>40,:)); 
input('');
end

%% test detector and plot roc (see acfTest)
tic
[miss,~,gt,dt]=acfTest('name',opts.name,'imgDir',[dataDir 'test/pos'],...
  'gtDir',[dataDir 'test/posGt'],'pLoad',opts.pLoad,...
  'pModify',pModify,'reapply',0,'show',0);
toc

plotpr(gt,dt,0,11);
return
%% optional timing test for detector (should be ~30 fps)
if( 1 )
  detector1=acfModify(detector,'pad',[0 0]); n=60; Is=cell(1,n);
  for i=1:n, Is{i}=(imread(imgNms{i})); end
  tic, for i=1:n, acfDetect(Is{i},detector1); end;
  fprintf('Detector runs at %.2f fps on 640x480 images.\n',n/toc);
end

%% optionally show top false positives ('type' can be 'fp','fn','tp','dt')
figure;
if( 1 ), bbGt('cropRes',gt,dt,imgNms,'type','tp','n',50,...
    'show',3,'dims',opts.modelDs([2 1])); end
