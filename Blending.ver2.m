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
    L = 2;
    Bigwidth = length(photoset{1}(1,:,1)) ;
    BigHeight = L*length(photoset{1}(:,:,1));
    PhotoBegin = zeros(length(photoset),2);
    PhotoBegin(1,:) = [1 round(((L-1)/(2*L))*BigHeight)];
    % MaxX = zeros(length(PhotoNewSet),1);
    xsum = 0;
    for i = 1:length(photoset)  


        if i > 1
            xsum = xsum + Point{i-1}(2)+length(photoset{i}(1,:,1));   
    %         ysum = ysum + Point{i-1}(3);
            Bigwidth = Bigwidth + length(photoset{i}(1,:,1)) - xsum;
            PhotoBegin(i,2) = PhotoBegin(i-1,2) - Point{i-1}(3);
            PhotoBegin(i,1) = 1+(i-1)*length(photoset{i}(1,:,1)) -xsum;
    %         MaxX(i) = Point{i-1}(2);
        end

    end
    % xshift = max(abs(MaxX));
    Map = uint8(zeros(BigHeight, Bigwidth, 3));
    %


    for i =1:length(photoset)
        Map((PhotoBegin(i,2)):(PhotoBegin(i,2)+length(photoset{1}(:,:,1))-1), PhotoBegin(i,1):PhotoBegin(i,1)+length(photoset{i}(1,:,1))-1,:) = photoset{i}(:,:,:);
    end


    
% 算黑邊顏色值
    Colorsum= zeros(length(Map),1);
    %Blacksum = length(find(Map(round(((L-1)/(2*L))*BigHeight)+50,:,:)==0));
    for i = 1:length(Map)
        Colorsum(i) = sum(sum(Map(:,i,:)));
    end
    NOTBLACK = find(Colorsum > 20);
    BLACK =  find(Colorsum < 20);
    BLACKidx = zeros(length(BLACK)-1,2);
    BLACKidx2 = zeros(length(BLACK)-1,1); 
    for i = 1:length(BLACK)-1
        BLACKidx2(i) = BLACK(i+1) - BLACK(i);
        if BLACKidx2(i)>2
            BLACKidx(i+1,1) = BLACK(i+1);
            BLACKidx(i+1,2) = i-BLACKidx(i,2);
        end
    end
    
     y = length(BLACKidx(1,:));
    BLACKidx = BLACKidx(BLACKidx ~=0);
    temp = length(BLACKidx(:,1))/y; 
    BLACKidx = reshape(BLACKidx,temp,2);

 %% 得到黑邊起始idx跟黑邊寬   
    for i = 1:length(BLACKidx(:,1))-1
        BLACKidx(length(BLACKidx(:,1))-i+1,2) = BLACKidx(length(BLACKidx(:,1))-i+1,2) - BLACKidx(length(BLACKidx(:,1))-i,2);
    end
    BLACKidx(length(BLACKidx),2) = BLACKidx(length(BLACKidx),2) - (length(Map) - length(NOTBLACK) -1);
        
    Mapnew = uint8(zeros(size(Map(:,1,1)),length(NOTBLACK),3));

%     for i = 1:length(ZERO)
%         Mapnew(:,i,:) = Map(:,ZERO(i),:);
%     end
%     
%     interval = zeros(length(PhotoBegin(:,1))-1,2);
%     for i =1:length(photoset)-1
%         interval(i) = abs(Point{i}(2));
%     end
 
     ColorInterval(:,1) = PhotoBegin(:,1) + BLACKidx(:,2);   
     ColorInterval(:,2) = PhotoBegin(:,1)+length(photoset{1}(1,:,1)) - BLACKidx(:,2);
  %   PhotoBegin(:,1) = ColorInterval(:,1); %更改新的圖片起始位置(因為要去黑邊)
 %去黑邊後貼圖
     Map2 = uint8(zeros(BigHeight, Bigwidth, 3));
%     for i =1:length(photoset)
%         Map2((PhotoBegin(i,2)):(PhotoBegin(i,2)+length(photoset{1}(:,:,1))-1), PhotoBegin(i,1):PhotoBegin(i,1)+length(photoset{i}(1,:,1) - BLACKidx(i,3))-1,:) = photoset{i}(:,1:length(photoset{i}(:,:,1))-1- BLACKidx(i,3),:);
%     end  
%        figure(length(photoset)+3);
%        imshow(Map2);
      figure(length(photoset)+3);   
    imshow(Map);
     hold on;
     for i = 1: length(photoset)
        plot([PhotoBegin(i,1) PhotoBegin(i,1)],[1 514],'r-');
        plot([PhotoBegin(i,1)+length(photoset{1}(1,:,1)) PhotoBegin(i,1)+length(photoset{1}(1,:,1))],[1 514],'b-');  
        plot([ColorInterval(i,1) ColorInterval(i,1)],[1 514],'g-');
        plot([ColorInterval(i,2) ColorInterval(i,2)],[1 514],'W-');     
     end
     
 %    傳圖去做 possion blending
    
     PossionInterval = zeros(length(ColorInterval)-1,2);
     for i= 1:length(PossionInterval)
         PossionInterval(i,1) = ColorInterval(i,2) - ColorInterval(i+1,1);
         PossionInterval(i,2) = length(photoset{i}(1,:,1)) - BLACKidx(i,2);
         PossionInterval(i,1) = PossionInterval(i,2) - PossionInterval(i,1)+1;
     end
     

    for i = length(photoset)-1
        
        
        
    end




end

