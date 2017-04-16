
    
    
    img_folder =input('folder:','s');


    dir_name = [img_folder,'\*.jpg'];
    fdir = dir(dir_name);
    pic_num = length(fdir);
    img = cell(pic_num,1);
    pic_name = cell(pic_num,1);
    for i=1:pic_num
        pic_name{i} = [img_folder,'\',fdir(i).name];
        photoset{i} = imread(pic_name{i});
    end
 
for i = 1:pic_num
    [features{i}, descriptor{i}] = myHarris(pic_name{i});
end






CLProj(img_folder,1);















Proj_img_folder = [img_folder '_proj'];

    dir_name = [Proj_img_folder,'\*.jpg'];
    fdir = dir(dir_name);
    pic_num = length(fdir);
    img = cell(pic_num,1);
    pic_name = cell(pic_num,1);
    total_feature = cell(pic_num,1);
    total_d = cell(pic_num,1);
    photoset = cell(pic_num,1);
    
    
    for i=1:pic_num
        pic_name = [Proj_img_folder,'\',fdir(i).name];
        dot = strfind(pic_name,'.');
        name = pic_name(1:dot-1);
        f_name = [name,'_f.mat'];
        d_name = [name,'_d.mat'];
        total_feature{i} = load(f_name);
        total_d{i} = load(d_name);
        photoset{i} = imread(pic_name);
    end
    
    
    for i = 1:length(photoset)-1
    match{i} = FeatureMatch(photoset{i},total_feature{i}.features,total_d{i}.descriptor,photoset{i+1},total_feature{i+1}.features,total_d{i+1}.descriptor);
    end
    
    figure(2);
    
    for i = 1:length(photoset)-1
        [Point{i}] = ImageMatching(match{i},total_feature{i}.features,total_feature{i+1}.features,2000);
        figure(i);
        imshow([photoset{i} photoset{i+1}]);
        hold on;
        plot([Point{i}(1,4) Point{i}(1,6)+384],[Point{i}(1,5) Point{i}(1,7)],'r.');
    end
 
 Map  = Blending( photoset,Point);
    
    
    