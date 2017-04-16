function [y] = ImageMatching(match,features1,features2,k)
    long = length(find(match~=0));
    xyfeat= zeros(long,4);


    for i  = 1:200
        if match(i) ~= 0 
            xyfeat(i,1:2) = features1(i,:);
            xyfeat(i,3:4) = features2(match(i),:);
        end
    end
    
    xyfeat = xyfeat(xyfeat ~= 0);
    xyfeat = reshape(xyfeat,long,4);
    %%¨úsample
    Point = zeros(k,7);
    Inlier = zeros(k,4);
    
    
     for i = 1:k
 
        ranidx = randperm(long);
        ranidx =ranidx(1)';
        
        
        

        offset = [xyfeat(ranidx,3)-xyfeat(ranidx,1) xyfeat(ranidx,4)-xyfeat(ranidx,2)];
                Max = -inf;
        Min = inf;
        for j = 1:long
            
            temp = (xyfeat(j,1)-offset(1) - xyfeat(j,3))^2 + (xyfeat(j,2)-offset(2) - xyfeat(j,4))^2 ;
%                if (xyfeat(j,1)-offset(1) - xyfeat(j,3))^2 + (xyfeat(j,2)-offset(2) - xyfeat(j,4))^2 < 60000
                  if temp > Max
                      Max = temp;
                  end
                  if temp < Min
                      Min = temp;
                  end
                  threshold = 0.5*(Max+Min);
                   
%                   Point(i,1) = Point(i,1) + (xyfeat(j,1)-offset(1) - xyfeat(j,3))^2 + (xyfeat(j,2)-offset(2) - xyfeat(j,4))^2;
%                 Point(i,1) = Point(i,1) + 1;
%               end
              
        end
        for j = 1:long
            temp = (xyfeat(j,1)-offset(1) - xyfeat(j,3))^2 + (xyfeat(j,2)-offset(2) - xyfeat(j,4))^2 ;
            if temp < threshold
                Point(i,1) = Point(i,1) + 1;
            end
        end
        Point(i,2:7) = [offset xyfeat(ranidx,:)];
    end
    [~,mini] = min(Point(:,1));
    
    y= Point(mini,:);
end