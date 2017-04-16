function [ features, descriptor ] = myHarris(image_file,total_feature,radius)

   image = imread(image_file);
   image = rgb2gray(image);
   
   
   % calculate derivatives
   dx = [-1 0 1;-1 0 1;-1 0 1];
   dy = dx';
   Ix = filter2(dx,image);
   Iy = filter2(dy,image); 
   
   % product of derivatives
   Ix2 = Ix.^2;
   Iy2 = Iy.^2;
   Ixy = Ix.*Iy;
   
   % gaussian filter
   h= fspecial('gaussian',10,2); 
   Ix2 = filter2(h,Ix2);
   Iy2 = filter2(h,Iy2);
   Ixy = filter2(h,Ixy);
  
   
   % calculate response of each pixel
   m = size(image,1);
   n = size(image,2);
   R = zeros(m,n);
  
   for i=radius+1:m-radius
       for j=radius+1:n-radius
           M = [Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)]; 
           R(i,j) = det(M)-0.05*(trace(M))^2;
       end
   end
   
   % apply threshold to find features
   nonmax_R = NMS(R,total_feature);
   [features(:,2), features(:,1)] = find(nonmax_R~=0);
                                        
   % save descriptor
   descriptor = cell(size(features,1),1);
   for i=1:size(features,1)
       co_y = features(i,2);
       co_x = features(i,1);
%        descriptor{i} = [ image(co_x-1,co_y-1),image(co_x-1,co_y),image(co_x-1,co_y+1),image(co_x,co_y-1),image(co_x,co_y),image(co_x,co_y+1),image(co_x+1,co_y-1),image(co_x+1,co_y),image(co_x+1,co_y+1)];
       descriptor{i} = reshape(image(co_y-radius:co_y+radius,co_x-radius:co_x+radius),1,[]);
   end     
   
   img_color = imread(image_file);
   imshow(img_color);
   hold on;
   plot(features(:,1),features(:,2),'r.','MarkerSize',10);
   
   dot = strfind(image_file,'.');
   name = image_file(1:dot-1);
   f_name = [name,'_f.mat'];
   d_name = [name,'_d.mat'];
   
   save(f_name,'features');
   save(d_name,'descriptor');
   
   
   
   
             
end

