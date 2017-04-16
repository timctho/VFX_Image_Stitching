function [match] = FeatureMatch(f1,features1,descriptor1,f2,features2,descriptor2,threshold)


    [~,width,~] = size(f1);


    fcom = [f1 f2];
    
    
    
    [idx1to2] = Mysearch(descriptor1,descriptor2,threshold);
    [idx2to1] = Mysearch(descriptor2,descriptor1,threshold);
 
    
    imshow(fcom);
    hold on;
    plot(features1(:,1),features1(:,2),'r.');
    plot(width +features2(:,1), features2(:,2),'b.');
%     flop = zeros(200,1);
%     for i = 1:200
%        flop(i) = (features1(i,2)- features2(idx1to2(i),2))/(features1(i,1) - 1279+features2(idx1to2(i),1));
%     end
  %  flopall = mode(flop);
    match = zeros(1,200);
    for i = 1:length(idx1to2)
        if idx1to2(i)~=0
            if  idx2to1(idx1to2(i)) == i  
                 plot( [features1(i,1) width+features2(idx1to2(i),1)],[features1(i,2) features2(idx1to2(i),2)],'w-');
                 match(i) = idx1to2(i);
            end
        end
    %     if idx2to1(2,idx1to2(2,i)) == i
    %          plot( [features1(i,1) features2(idx1to2(2,i),1)],[features1(i,2) width+features2(idx1to2(2,i),2)],'g-');
    %     end    
    end
end
%&&
