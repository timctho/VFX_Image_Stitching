function  nonmax_response = NMS( response ,total_feature)
      
     m = size(response,1);
     n = size(response,2);
     nonmax_response = zeros(m,n);
     
     sort_score = sort(reshape(response,[],1),1,'descend');
     
     % how many features want
     feature_num = 0;
     radiuses = 3; % suppression radius
     
     now = 1;
     while(feature_num < total_feature) 
         [y,x] = find(response == sort_score(now,1));
         for i = 1:length(y)
         if (((y(i)-radiuses)>0) && ((y(i)+radiuses)<m) && ((x(i)-radiuses)>0) && ((x(i)+radiuses)<n))
         sub_block = response((y(i)-radiuses):(y(i)+radiuses),(x(i)-radiuses):(x(i)+radiuses));
              % chech if it is local maximal 
              if sort_score(now,1) == max(max(sub_block))
                  nonmax_response(y,x) = sort_score(now,1);
                  feature_num = feature_num +1 ;
                  %if feature_num==total_feature
                  fprintf('feature_select: %d\n',feature_num);
              
                  
              end
         end
            if feature_num >= total_feature;
                break;
            end
          
         end
      
         now = now +1;
         
     end
   
     
%      while(feature_num>1000)
%      suppression_response = response;
%      for i=(1+radius) : (m-radius)
%          for j=(1+radius):(n-radius)
%              % check if it is local maximal
%              sub_block = suppression_response((i-radius):(i+radius),(j-radius):(j+radius));
%              if suppression_response(i,j) == max(max(sub_block))
%                  temp = suppression_response(i,j);
%                  suppression_response((i-radius):(i+radius),(j-radius):(j+radius)) = 0;
%                  suppression_response(i,j) = temp;
%                  j = j+ radius +1;
%              end
%          end
%      end
%      radius = radius + 1;
%      feature_num = length(find(suppression_response~=0));
%      end
     
     
     


end

