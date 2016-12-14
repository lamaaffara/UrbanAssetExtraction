function imnames = LoadFilenames(imdir,ext)
   images = dir([imdir '*' ext]);
   N=size(images,1);
   imnames=cell(N,1);
   parfor i=1:N
        imnames{i}=images(i).name(1:end-4);
   end
end