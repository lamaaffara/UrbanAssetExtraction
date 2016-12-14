% Demo for Edge Boxes (please see readme.txt first).

%% load pre-trained edge detection model and set opts (see edgesDemo.m)
model_bb=load('models/forest/modelBsds'); model_bb=model_bb.model;
model_bb.opts.multiscale=0; model_bb.opts.sharpen=2; model_bb.opts.nThreads=4;

%% set up opts for edgeBoxes (see edgeBoxes.m)
opts_bb = edgeBoxes;
opts_bb.alpha = .65;     % step size of sliding window search
opts_bb.beta  = .75;     % nms threshold for object proposals
opts_bb.minScore = .01;  % min score of boxes to detect
opts_bb.maxBoxes = 1e4;  % max number of boxes to detect
