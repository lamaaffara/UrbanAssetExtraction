 function InitializeParallel(nWorkers)
    c = parcluster('local');
    c.NumWorkers = nWorkers;
   try
        matlabpool(nWorkers);
   catch end
 end