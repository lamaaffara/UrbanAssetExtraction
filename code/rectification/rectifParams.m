function params=rectifParams

%% General parameters
params.lineangleth=20;   %discard horizontal lines 
params.medianth=2;       %for plotting horizontal lines

%% RANSAC options
params.ransacoptions.P_inlier = 0.8;
params.ransacoptions.sigma = 1;
params.ransacoptions.est_fun = @estimate_line;
params.ransacoptions.man_fun = @error_line;
params.ransacoptions.mode = 'MSAC';
params.ransacoptions.Ps = [];
params.ransacoptions.notify_iters = [];
params.ransacoptions.min_iters = 100;
params.ransacoptions.fix_seed = false;
params.ransacoptions.reestimate = true;
params.ransacoptions.stabilize = false;
params.ransacoptions.verbose=false;

%%
params.plotflag=false;
params.saveflag=false;

end