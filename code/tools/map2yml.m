function map2yml()

cf = DatasetConfig.getInstance();

gtdir=get_adr('bing_labels');
ymldir=get_adr('bing_ymlannotations');
mkdirIfNotExist(ymldir);

images = dir(strcat(gtdir,'\*.png'));

 parfor i=1:length(images)
        imname=images(i).name;
        map=imread([gtdir imname]);[H,W]=size(map);
        st = regionprops(rgb2gray(map)==76, 'BoundingBox');
        BB = round(cat(1,st.BoundingBox));
        
        fileId(i)=fopen([ymldir imname(1:end-4) '.yml'],'w');
         fprintf(fileId(i),'%%YAML:1.0\n');
         fprintf(fileId(i),'\n');
         fprintf(fileId(i),'annotation:\n');
         fprintf(fileId(i),'  folder: VOC2007\n');
        fprintf(fileId(i),['  filename: "' imname(1:end-4) '.jpg"\n']); 
        fprintf(fileId(i),['  size: {width: ''' num2str(W) ''', height: ''' num2str(H) ''', depth: ''' num2str(3) '''}\n']);
         fprintf(fileId(i),'  segmented: ''0''\n');
         fprintf(fileId(i),'  object:\n');
        for k=1:size(BB,1)
            x1=max(1,(BB(k,1)));y1=max(1,(BB(k,2)));x2=min(W,(BB(k,1))+(BB(k,3)));y2=min(H,(BB(k,2))+(BB(k,4)));
        fprintf(fileId(i),['    - bndbox: {xmin: ''' num2str(x1) ''', ymin: ''' num2str(y1) ''', xmax: '''...
                                                  num2str(x2) ''', ymax: ''' num2str(y2) '''}\n']);   
         fprintf(fileId(i),'      name: window\n');
         fprintf(fileId(i),'      pose: Unspecified\n');
         fprintf(fileId(i),'      truncated: ''0''\n');
         fprintf(fileId(i),'      difficult: ''0''\n');
        end
        fclose(fileId(i));
 end