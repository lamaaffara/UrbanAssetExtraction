% Demo for Structured Edge Detector (please see readme.txt first).

%% set opts for training (see edgesTrain.m)
opts=edgesTrain();                % default options (good settings)
opts.modelDir='models/';          % model will be in models/forest
opts.modelFnm='modelBsds';        % model name
opts.nPos=5e5; opts.nNeg=5e5;     % decrease to speedup training
opts.useParfor=0;                 % parallelize if sufficient memory

%% train edge detector (~20m/8Gb per tree, proportional to nPos/nNeg)
tic, model=edgesTrain(opts); toc; % will load model if already trained

%% set detection parameters (can set after training)
model.opts.multiscale=0;          % for top accuracy set multiscale=1
model.opts.sharpen=2;             % for top speed set sharpen=0
model.opts.nTreesEval=4;          % for top speed set nTreesEval=1
model.opts.nThreads=4;            % max number threads for evaluation
model.opts.nms=0;                 % set to true to enable nms

%% evaluate edge detector on BSDS500 (see edgesEval.m)
if(0), edgesEval( model, 'show',1, 'name','' ); end

%% detect edge and visualize results
ldir='C:\Users\affarala\Downloads\londonNew\layer2\';
imdir='D:\Image Datasets\urban\full\london\rectified\';
imname='IMG_5643';
I=imread([imdir imname '.jpg']);
tic, E=edgesDetect(I,model); toc

I2=imread([ldir imname '.png']);
tic, E2=edgesDetect(I2,model); toc

subplot(2,2,1)
imagesc(I);axis off


subplot(2,2,2)
imagesc(1-E2);colormap gray;axis off


subplot(2,2,3)
imagesc(1-E);colormap gray;axis off


subplot(2,2,4)
imshow(im2double(cat(3,(1-3*E),(1-E2),ones(size(E)))));hold on;

  s= regionprops(rgb2gray(I2)==76,'centroid','boundingbox');
 
  for i=1:length(s);
      rectangle('position',s(i).BoundingBox,'edgecolor','r');
  end
      