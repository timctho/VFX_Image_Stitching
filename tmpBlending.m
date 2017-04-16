function [ Map ] = Blending( photoset,Point)
%BLENDING Summary of this function goes here
%   Detailed explanation goes here

%% 造一張大黑圖 +算圖片起始

temp = length(photoset{1}(1,:,1));
for i = 1:length(photoset)
    PhotoNewSet{i} =  photoset{i}(:,8:temp-7,:);
    if i < length(photoset)
        Point{i}(4) = Point{i}(4) -7;
        Point{i}(6) = Point{i}(6) -7;
    end
end

Bigwidth = length(PhotoNewSet{i}(1,:,1)) ;
PhotoBegin = zeros(length(PhotoNewSet),2);
PhotoBegin(1,:) = [1 1];
MaxX = zeros(length(PhotoNewSet),1);
ysum = 0;
for i = 1:length(PhotoNewSet)  

    if i < length(PhotoNewSet)
         ysum = ysum + Point{i}(2);       
        Bigwidth = Bigwidth + length(PhotoNewSet{i}(1,:,1)) +ysum;      
    end
    if i > 1
        
        PhotoBegin(i,2) = PhotoBegin(i-1,2) + length(PhotoNewSet{i}(1,:,1)) +Point{i-1}(2);
        PhotoBegin(i,1) = PhotoBegin(i-1,1) - (Point{i-1}(3));
        MaxX(i) = Point{i-1}(2);
    end
    
end
xshift = max(abs(MaxX));
Map = uint8(zeros(2*xshift,Bigwidth-1,3));
%%


for i =1:length(PhotoNewSet)
    Map(PhotoBegin(i,1):PhotoBegin(i,1)+length(PhotoNewSet{1})-1, PhotoBegin(i,2):PhotoBegin(i,2)+length(PhotoNewSet{i}(1,:,1))-1,:) = PhotoNewSet{i}(:,:,:);
end

imshow(Map);



end

