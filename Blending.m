function [ Map ] = Blending( photoset,Point)
% BLENDING Summary of this function goes here
%   Detailed explanation goes here

% 造一張大黑圖 +算圖片起始

% temp = length(photoset{1}(1,:,1));
% for i = 1:length(photoset)
%     PhotoNewSet{i} =  photoset{i}(:,8:temp-7,:);
% %     if i < length(photoset)
% %         Point{i}(4) = Point{i}(4) -7;
% %         Point{i}(6) = Point{i}(6) -7;
% %     end
% end

Bigwidth = size(photoset{1},2) ;
BigHeight = 4*size(photoset{1},1);
PhotoBegin = zeros(length(photoset),2);
PhotoEnd = zeros(length(photoset),2);
PhotoBegin(1,:) = [1 0.5*BigHeight];
Photo_num = length(photoset);
% MaxX = zeros(length(PhotoNewSet),1);
xsum = 0;
for i = 1:Photo_num

    
    if i > 1
        xsum = xsum + Point{i-1}(2)+length(photoset{i}(1,:,1));   
%         ysum = ysum + Point{i-1}(3);
        Bigwidth = Bigwidth + length(photoset{i}(1,:,1)) - xsum;
        PhotoBegin(i,2) = PhotoBegin(i-1,2) - Point{i-1}(3);
        PhotoBegin(i,1) = 1+(i-1)*length(photoset{i}(1,:,1)) -xsum;
%         MaxX(i) = Point{i-1}(2);
    end
    
end

PhotoEnd(:,1) = PhotoBegin(:,1) + size(photoset{i},2)-1;
PhotoEnd(:,2) = PhotoBegin(:,2) + size(photoset{i},1)-1;

% xshift = max(abs(MaxX));
Map = uint8(zeros(BigHeight, Bigwidth, 3));


    


% PhotoBegin 2~18 is each adjacent picture pair's mixing boundary
% extract overlapping zone
overlap = cell(Photo_num-1,2);
for i=1:Photo_num-1
    % overlap bounding box
    box_min_y = min(PhotoBegin(i,2),PhotoBegin(i+1,2));
    box_max_y = max(PhotoEnd(i,2),PhotoEnd(i+1,2));
    bounding_box = zeros(box_max_y-box_min_y+1,PhotoEnd(i,1)-PhotoBegin(i+1,1)+1,3);
    
    
    
    overlap{i,1} = bounding_box;
    overlap{i,2} = bounding_box;
    
    % extract overlapping region
    if PhotoBegin(i,2) <= PhotoBegin(i+1,2)
        overlap{i,1}(1:size(bounding_box,1)-abs(Point{i}(3)),:,:) = photoset{i}(:,1+PhotoBegin(i+1,1)-PhotoBegin(i,1):end,:);  
        overlap{i,2}(1+abs(Point{i}(3)):size(bounding_box,1),:,:) = photoset{i+1}(:,1:PhotoEnd(i,1)-PhotoBegin(i+1,1)+1,:);
    else
         overlap{i,2}(1:size(bounding_box,1)-abs(Point{i}(3)),:,:) = photoset{i+1}(:,1:PhotoEnd(i,1)-PhotoBegin(i+1,1)+1,:);
         overlap{i,1}(1+abs(Point{i}(3)):size(bounding_box,1),:,:) = photoset{i}(:,1+PhotoBegin(i+1,1)-PhotoBegin(i,1):end,:);  
    end
end


blend_boundary = cell(Photo_num-1,1);
for i=1:Photo_num-1
    % blending each boundary
    blend_boundary{i} = easyblend(overlap{i,1},overlap{i,2});
    
     blend_boundary{i} = blend_boundary{i}(:,1:round(0.3*size(blend_boundary{i},2)),:);
     fprintf('blend %d complete\n', i);
    
%     for j=1:size(blend_boundary{i},1)
%         for k=1:size(blend_boundary{i},2)
%             if j==1 | k==1 | j==size(blend_boundary{i},1) | k==size(blend_boundary{i},2)
%                 blend_boundary{i}(j,k,:) = [255 0 0];
%             end
%         end
%     end
end


% stitch default panorama
for i =1:length(photoset)
    Map((PhotoBegin(i,2)):(PhotoBegin(i,2)+size(photoset{i},1)-1), PhotoBegin(i,1):PhotoBegin(i,1)+size(photoset{i},2)-1,:) = photoset{i}(:,:,:);
end

% update overlapping region
for i=1:Photo_num-1
    if PhotoBegin(i,2)>PhotoBegin(i+1,2)
        temp_y_start = PhotoBegin(i+1,2);
        temp_x_start = PhotoBegin(i+1,1);
    else
        temp_y_start = PhotoBegin(i,2);
        temp_x_start = PhotoBegin(i+1,1);
    end
    Map(temp_y_start:temp_y_start+size(blend_boundary{i},1)-1,temp_x_start:temp_x_start+size(blend_boundary{i},2)-1,:) = blend_boundary{i}(:,:,:);
end

box_upper_boundy = -inf;
box_lower_boundy = inf;
RGBsum = sum(Map,3);
RGBsum_y = sum(RGBsum,1);
for i=1:size(Map,2)
    
    
    temp = find(RGBsum(:,i)~=0);
    if RGBsum_y(i) > 0.5*mean(RGBsum_y)
     
    temp_up = temp(1);
    temp_low = temp(end);
    if temp_up > box_upper_boundy
        box_upper_boundy = temp_up;
    end
    if temp_low < box_lower_boundy
        box_lower_boundy = temp_low;
    end
    
    end
    
 
   
end
Map = Map(box_upper_boundy:box_lower_boundy,:,:);
% box_upper_boundx = inf;
% box_lower_boundx = -inf;
 RGBsum = sum(Map,3);
 RGBsum_x = sum(RGBsum,2);
% for i=1:size(Map,1)
%     
%     
%     temp = find(RGBsum(i,:)~=0);
%     if RGBsum_x(i) > 0.5*mean(RGBsum_x)
%      
%     temp_up = temp(1);
%     temp_low = temp(end);
%     if temp_up < box_upper_boundx
%         box_upper_boundx = temp_up;
%     end
%     if temp_low > box_lower_boundx
%         box_lower_boundx = temp_low;
%     end
%     
%     end
%     
%  
%    
% end
% Map = Map(:,box_upper_boundx:box_lower_boundx,:);

x_shift = find(RGBsum((round(size(Map,1)*0.5)),:) > 200);

% fprintf('%d\n',x_shift);

Map = Map(:,x_shift(1):x_shift(end),:);
    

figure(length(photoset)+5);
imshow(Map);
hold on;
% plot(PhotoBegin(:,1),PhotoBegin(:,2),'r.','MarkerSize',12);



end

