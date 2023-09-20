


%%
%%%%%%%%%%%%% what this function does %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1) assigns data points to clusters - closest points to density center


function [clusterAssignment,indClusterCenters] = assignPointsToClustersDistance_1(data,indClusterCenters,makeplot)


%%
%%%%%%%%%%%%%%%% calculate distances %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


distances = pdist(data,'euclidean');

distanceSquare = squareform(distances);




%%

%assign cluster centers
clusterAssignment = zeros(1,length(data));
clusterAssignment(indClusterCenters) = 1:length(indClusterCenters);


for h =  1 : length(distanceSquare)%loop through each point
    
    if clusterAssignment(h) == 0%avoid cluster centers beacuse they are already assigned
        
        
        distanceOfCenters = distanceSquare(h,indClusterCenters);
        
        [~,centerInd] = max(distanceOfCenters);
        clusterAssignment(h) = centerInd;
        
    end
       
end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% make plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numbClusters = length(indClusterCenters);


if makeplot == 1
    
figure
subplot(1,2,1)
plot(data(:,1),data(:,2), 'k.')
hold on


axis square
box off
 
 col =  jet(numbClusters);
 subplot(1,2,2)
 
 for n = 1 :  numbClusters% loop through each cluster
     hold on 

      
      %cluster core
      indThisCluster = find(clusterAssignment == n);
      
%       plot(data(indThisCluster,1),data(indThisCluster,2), 'o','MarkerFaceColor', col(n,:),'MarkerEdgeColor', 'k','MarkerSize',10,'lineWidth',3)
      plot(data(indThisCluster,1),data(indThisCluster,2), '.','color', col(n,:))%,'MarkerEdgeColor', 'k','MarkerSize',10,'lineWidth',3)

     plot(data(indClusterCenters(n),1),data(indClusterCenters(n),2), 'o','MarkerFaceColor', col(n,:),'MarkerEdgeColor', 'k','MarkerSize',10,'lineWidth',3)

      
box off
title(numbClusters)
      
 end

 
 
 axis square
 hold off
 
 
end  
