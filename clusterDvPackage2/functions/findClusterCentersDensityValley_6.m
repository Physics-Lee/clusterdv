%%
%%%%%%%%%%%%%% what does it do %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1) Calculates local densities with mixture of gaussians - if kdedens is
%empty it calculates if kdedens is density obj it uses it as input

%2) Calculates local density rho and delta (density paths using matlab simple linkage)

%3) Calculates SImeasure:  -miniDipp./rho + 1

%4) does same thing for resampled distribution - resampled distribution
%method does not work for density valleys - put multirep = [] to skip this


%%
%%%%%%%%%%%%%%% inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1) data - data to find cluster centers
%2) kdedens * density obj - if it is empty function calculates it
%3) densityType - to calculate kdedens: local, localp, ROT, ...
%4) linedensityMethod - method used to calculate density lines: may use slow, medium or fast line density method 
%5)numextra - for medium linedensityMethod there is the need to define the
%number of points to use - ROT: sqrt(length(data))
%6) nsamps - number of divisions in density line - 10 is enough
%7) multirep - number of times to repeat rand distribution - if 0 does not do it
%8) makeplot - make decision plots




%%
 function [rho,realRho,delta,SImeasure,SImeasureSorted,kdedens,kdedensRand,maxjump,rhoRand,realRhoRand,deltaRand,SImeasureRand,SImeasureRandSorterAvr,clusterCentersSortedIdx,SImeasureRandSortedAll,diffSImeasure,jumpSImeasure] = findClusterCentersDensityValley_6(data,kdedens,densityType,linedensityMethod,numextra,nsamps,multirep,numbPointsToShow,clusterThreshold,resampleMethod,scallingFactor,makeplot)



%%
% %%%%%%%%%%%%%%%%% test function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kdedens = [];
% densityType = 'local';
% linedensityMethod = 'fast';
% numextra = sqrt(length(data));
% nsamps = 10;
% multirep = 0;
% makeplot = 1;
% numbPointsToShow = 40;

%%
%%%%%%%%%%%%%%%%%%%%% calculate density kernel %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(kdedens) 
    
makeplot4 = 0;    
    
kdedens = kde(data',densityType);

% [kdedensCutOff,bandWidthsScalled] = calculateLocalDensitiesScallingBW_1(boutDataPCASampleThis,kdedens,scallingFactor,densityType,makeplot);
[kdedens,bandWidths] = calculateLocalDensitiesScallingBWCORRECT(data,kdedens,scallingFactor,densityType,makeplot4);


    
end

numbPointsUsedToCalcualateKde = length(getPoints(kdedens));

%%
%%%%%%%%%%%%%% calculate rho delta by max jump %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
doplot = 0;

[rho,delta,maxjump,densityNorm] = calculateRhoAndDeltaMaxDensityJumpLinkage_5(data,nsamps,densityType,kdedens,linedensityMethod,numextra,doplot);

%calculate real rho
realRho = rho.*numbPointsUsedToCalcualateKde;

%%
%%%%%%%%%%%% calculate SImeasure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SI measure is (-minidipp/rho) + 1

maxrho = max(rho);

miniDipp = maxrho - delta;

SImeasure = -miniDipp./rho + 1;


SImeasureRandSortedAll = zeros(multirep,length(data));

%%
%%% calculate rho delta and SImeasure for resampled distribution %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if multirep ~=0%put zero in multirep not to do random dist
for multi = 1 : multirep
multi
%%
%%%%%%%%%%%%%%%% resampled distribution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch resampleMethod

    case 'simplex'
    plotMaker = 0;

    [dataRand] = resampleDistribution_3(data,length(data),plotMaker);

    case 'onion'
    nDims = size(data,2);
    [dataRand] = resampleDensityMatching(rho,nDims);

       
end 


% doPlot = 0;
% [dataRand] = resampleDistribution_3(data,size(data,1),doPlot);
% % 
% 
%%
%%%%%%%%%%%%%% calculate rho delta by max jump %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 kdedensRand = kde(dataRand',densityType);

 makeplot4 = 0;
 [kdedensRand,bandWidthsRand] = calculateLocalDensitiesScallingBWCORRECT(dataRand,kdedensRand,scallingFactor,densityType,makeplot4);

 
 
doplot = 0;
[rhoRand,deltaRand,maxjumpRand,densityNormRand] = calculateRhoAndDeltaMaxDensityJumpLinkage_5(dataRand,nsamps,densityType,kdedensRand,linedensityMethod,numextra,doplot);
% size(dataRand)

%%
%%%%%%%%%%%%% calculate real rho %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numbPointsUsedToCalcualateKdeRand = length(getPoints(kdedensRand));

%calculate real rho
realRhoRand = rhoRand.*numbPointsUsedToCalcualateKdeRand;

%%
%%%%%%%%%%% calculate SImeasure for rand distribution %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


maxrhoRand = max(rhoRand);

miniDippRand = maxrhoRand - deltaRand;

SImeasureRand = -miniDippRand./rhoRand + 1;

[SImeasureRandSorted SImeasureRandIdx] = sort(SImeasureRand, 'descend');
SImeasureRandSortedAll(multi,:) = SImeasureRandSorted;

end


 SImeasureRandSorterAvr = nanmean(SImeasureRandSortedAll,1);

%sort SI measure
[SImeasureSorted, SImeasureIdx] = sort(SImeasure, 'descend');

% SImeasureRandSorterAvr(1) = SImeasureRandSorterAvr(2);
diffSImeasure = SImeasureSorted - SImeasureRandSorterAvr;
diffSImeasure = SImeasureSorted - SImeasureRandSorterAvr;

diffSImeasure2 = diffSImeasure;
% diffSImeasure2(1) = 1;
jumpSImeasure = diff(diffSImeasure2);

 

diffSImeasureDiv = diffSImeasure./SImeasureSorted;
diffdiffSImeasureDiv = diff(diffSImeasureDiv);
 
 
else% not doing resampled distribution
    
rhoRand = [];   
realRhoRand = [];
deltaRand = []; 
miniDippRand = [];
SImeasureRand = [];
SImeasureRandSorterAvr = [];
jumpSImeasure = [];
kdedensRand = [];
dataRand = [];
diffSImeasure = [];
jumpSImeasure = [];
end

[SImeasureSorted, SImeasureIdx] = sort(SImeasure, 'descend');


%%
%%%%%%%%%%%%%% find all cluster centers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%find cluster centers
indClusterCenters = find(SImeasure > clusterThreshold);



%order cluster centers by SImeasure
[~, SImeasureIdx] = sort(SImeasure, 'descend');
clusterCentersSortedIdx = SImeasureIdx(1:(length(indClusterCenters)));







%%
%%%%%%%%%%%%%% make plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if makeplot == 1

figure
subplot(2,4,1)
plot(realRho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
hold on
if multirep ~= 0
     plot(realRhoRand(:),deltaRand(:),'o','MarkerSize',5,'MarkerFaceColor','g','MarkerEdgeColor','g');
end
box off
axis square
xlabel('\rho')
ylabel('\delta')


subplot(2,4,2)
plot(realRho(:),miniDipp(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k'); 
hold on
if multirep ~= 0
     plot(realRhoRand(:),miniDippRand(:),'o','MarkerSize',5,'MarkerFaceColor','g','MarkerEdgeColor','g');
end
box off
axis square
xlabel('\rho')
ylabel('miniDipp')

subplot(2,4,3)
plot(realRho(:),SImeasure(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
hold on
if multirep ~= 0
plot(realRhoRand(:),SImeasureRand(:),'o','MarkerSize',5,'MarkerFaceColor','g','MarkerEdgeColor','g');
end

col = jet(length(clusterCentersSortedIdx));
invCol = flipud(col);

for n = 1 : length(clusterCentersSortedIdx)

plot(realRho(clusterCentersSortedIdx(n)),SImeasure(clusterCentersSortedIdx(n)),'o','MarkerSize',5,'MarkerFaceColor',invCol(n,:),'MarkerEdgeColor',invCol(n,:))
end

axis square
xlabel('\rho')
ylabel('-miniDipp/\rho + 1')

subplot(2,4,4)
plot(SImeasureSorted(1:numbPointsToShow),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
hold on
if multirep ~= 0
 plot(SImeasureRandSorterAvr(1:numbPointsToShow),'o','MarkerSize',5,'MarkerFaceColor','g','MarkerEdgeColor','g');   
end
box off
axis square
xlabel('Sorted points')
ylabel('-miniDipp/\rho + 1')


subplot(2,4,7)

scatter(data(:,1),data(:,2),5,rho,'filled')
axis square

if multirep ~= 0
subplot(2,4,5)
plot(diffSImeasure(1:numbPointsToShow),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
hold on

box off
axis square
xlabel('Sorted points')
ylabel('-miniDipp/\rho + 1')

% subplot(2,5,6)
% plot(diffSImeasureDiv(1:numbPointsToShow),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
% hold on
% 
% box off
% axis square
% xlabel('Sorted points')
% ylabel('-miniDipp/\rho + 1')

% subplot(2,5,7)
% plot(diffdiffSImeasureDiv(1:numbPointsToShow),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
% hold on
% 
% box off
% axis square
% xlabel('Sorted points')
% ylabel('-miniDipp/\rho + 1')





subplot(2,4,6)
plot(jumpSImeasure(1:numbPointsToShow),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
hold on

box off
axis square
xlabel('Sorted points')
ylabel('-miniDipp/\rho + 1')




subplot(2,4,8)
% plot3(dataRand(:,1),dataRand(:,2),dataRand(:,3),'.')
scatter(dataRand(:,1),dataRand(:,2),5,rhoRand,'filled')
axis square



end

end