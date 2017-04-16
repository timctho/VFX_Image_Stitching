function [ idx ] = Mysearch( descriptor1,descriptor2,threshold)
%   MYSEARCH Summary of this function goes here
%   Detailed explanation goes here
    descriptor1 = double(cell2mat(descriptor1));
    descriptor2 = double(cell2mat(descriptor2));
    num = size(descriptor1,1);
    idx = zeros(num,1);
    
    inlier = zeros(num,1);
    for i = 1:num
        disMax = zeros(num,1);       
        for j = 1:num
            disMax(j) = sum((descriptor1(i,:) - descriptor2(j,:)).^2);
        end
        % inlier(i) = length(find(disMax < 0.9));
        
        
        temp = sort(disMax);
        if temp(1)/temp(2) < threshold
            idx(i,1) = find(disMax == temp(1));
        end
    end
    

end

