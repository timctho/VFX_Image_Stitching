function img = CLProj( img_folder, havefeatures )
        
        % read all images
        dir_name = [img_folder,'\*.jpg'];
        fdir = dir(dir_name);
        pic_num = length(fdir);
        img = cell(pic_num,1);
        for i=1:pic_num
            pic_name = [img_folder,'\',fdir(i).name];
            img{i} = imread(pic_name);
        end
        
        new_dirname = [img_folder,'_proj'];
        mkdir(new_dirname);
        addpath(new_dirname);
        
        % read all features
        if (havefeatures ==1)
            feature_file = cell(pic_num,1);
            feature_name = cell(pic_num,1);
            descriptor_file = cell(pic_num,1);
            descriptor_name = cell(pic_num,1);
            for i=1:pic_num
                dot = strfind(fdir(i).name,'.');
                feature_name{i} = [img_folder,'\',fdir(i).name(1:dot-1),'_f.mat'];
                feature_file{i} = load(feature_name{i});
                feature_name{i} = [new_dirname,'\',fdir(i).name(1:dot-1),'_f.mat'];
                
                descriptor_name{i} = [img_folder,'\',fdir(i).name(1:dot-1),'_d.mat'];
                descriptor_file{i} = load(descriptor_name{i});
                descriptor_name{i} = [new_dirname,'\',fdir(i).name(1:dot-1),'_d.mat'];
               
            end
        end
        
                
        
        
        height = size(img{1},1);
        width = size(img{1},2);
        
        % read focal length
        focal_name = [img_folder,'\focal.txt'];
        focal_length = dlmread(focal_name);
        
        
        
       
        
        % cylindrical projection
        for i=1:pic_num % for each image
            f = focal_length(i);
            temp_pic = zeros(height,width,3);
            
           
            hx = width/2;
            hy = height/2;
            
            % project the image
            for j=1:height
                for k=1:width
                    % projection formula
                    x_p = floor(f*atan((k-hx) / f)+hx+1);
                    y_p = floor(f*(j-hy) / (sqrt((k-hx)*(k-hx) + f*f))+hy+1);
                    temp_pic(y_p, x_p,:) = img{i}(j,k,:);
                end
            end
            
            % project feature point
            if (havefeatures==1)
                for j=1:length(feature_file{i})
                    temp_x = round(f*atan((feature_file{i}.features(j,1)-hx) / f)+hx+1);
                    temp_y = round(f*(feature_file{i}.features(j,2)-hy) / (sqrt((feature_file{i}.features(j,1)-hx)*(feature_file{i}.features(j,1)-hx) + f*f))+hy+1);
                    feature_file{i}.features(j,1) = temp_x;
                    feature_file{i}.features(j,2) = temp_y;
                end
                features = feature_file{i}.features;
                save(feature_name{i},'features');
                
                
            end
            descriptor = descriptor_file{i}.descriptor;
            save(descriptor_name{i},'descriptor');
                
            
        
            % save projected image
            proj_img_name = [new_dirname,'\',fdir(i).name];
            temp_pic = uint8(temp_pic);
            imwrite(temp_pic, proj_img_name, 'jpg');
            
        end
        
            
        
        
        
        


end

