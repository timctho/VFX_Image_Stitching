
   img_folder = input   ('Folder?                         :','s');
   k = input                  ('Ransac k?  (ex: 2000)  :'); 
   threshold = input     ('threshold?  (ex: 0.6)     :');
   total_feature = input('How many Features?   :');
   radius = input          ('Descriptors radius?      :');
   
   
   
    dir_name = [img_folder,'\*.jpg'];
    fdir = dir(dir_name);
    pic_num = length(fdir);
   % img = cell(pic_num,1);
    pic_name = cell(pic_num,1);
    for i=1:pic_num
        pic_name{i} = [img_folder,'\',fdir(i).name];
        photoset{i} = imread(pic_name{i});
    end
 
for i = 1:pic_num
    [features{i}, descriptor{i}] = myHarris(pic_name{i},total_feature,radius);

end   

   CLProj(img_folder,1);
   
   


   dir_match = [img_folder,'_match'];
   mkdir(dir_match);
   addpath(dir_match);
   
%    dir_name = [img_folder,'_proj','\*.jpg'];
%     fdir = dir(dir_name);
%     pic_num = length(fdir);
%     img = cell(pic_num,1);
%     pic_name = cell(pic_num,1);
%     for i=1:pic_num
%         pic_name{i} = [img_folder,'_proj\',fdir(i).name];
%         photoset{i} = imread(pic_name{i});
%         
%     end
   
for i = 1:length(photoset)-1
     figure(i);
    match{i} = FeatureMatch(photoset{i},features{i},descriptor{i},photoset{i+1},features{i+1},descriptor{i+1},threshold);
%     hold on;
    figure_name = [dir_match,'\Match_',num2str(i),'.jpg'];
    hgexport(figure(i),figure_name,hgexport('factorystyle'),'Format','jpeg');
    close(figure(i));
end


for i = 1:length(photoset)-1
    [Point{i}] = ImageMatching(match{i},features{i},features{i+1},k);
      figure(i);
        imshow([photoset{i} photoset{i+1}]);
        hold on;
        plot([Point{i}(1,4) Point{i}(1,6)+length(photoset{i}(1,:,:))],[Point{i}(1,5) Point{i}(1,7)],'r.-');   
    
    
end



    dir_name = [img_folder,'_proj','\*.jpg'];
%     dir_name = [img_folder,'\*.jpg'];
    fdir = dir(dir_name);
    pic_num = length(fdir);
    img = cell(pic_num,1);
    pic_name = cell(pic_num,1);
    for i=1:pic_num
        pic_name{i} = [img_folder,'_proj\',fdir(i).name];
%         pic_name{i} = [img_folder,'\',fdir(i).name];
        photoset{i} = imread(pic_name{i});
    end


 Map  = Blending( photoset,Point);

 