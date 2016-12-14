function listfiles(imdir,filename)

system(['dir /s/b ' imdir '*.jpg > All.txt']);

fid = fopen('All.txt');

if fid==-1
    fatal();
end
file_str_idx = textscan(fid, '%s'); fclose(fid);

file_str=file_str_idx{1};

for j=1:size(file_str,1)
    file_str{j,1}=strrep(file_str{j,1},imdir,'');
    file_str{j,1}=strrep(file_str{j,1},'.jpg','');
end


fid = fopen(filename,'w');

fprintf(fid,'%s\n',file_str{:});

fclose(fid);

if exist('All.txt', 'file')
  delete('All.txt');
end


