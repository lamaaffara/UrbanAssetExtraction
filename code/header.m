% include project paths
addpath(genpath('asset_extraction/'));
addpath(genpath('proposals/'));
addpath(genpath('rectification/'));
addpath(genpath('config/'));
addpath(genpath('tools/'));

% include dependecies
addpath('..\dependencies');
addpath(genpath('..\dependencies\gop_matlab'));
addpath(genpath('..\dependencies\piotr_toolbox'));
addpath(genpath('..\dependencies\edges-master'));
addpath(genpath('..\dependencies\RANSAC-Toolbox-master'));
addpath('..\dependencies\liblinear');
addpath('..\dependencies\libsvm');

% set evaluation parameters
ov=0.7; % overlap threshold
numProp=3000; %number of proposals
dd=true; %datadriven flag
