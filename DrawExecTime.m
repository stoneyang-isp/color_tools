close all;
clear all;
clc;
clf;

x = 1:1:22;
time = [2.39 10.13 0.32 0.96 0.22 8.62 8.71 0.36 0.42 4.51 9.17 0.27 0.13 1.13 14.45 0.44 0.87 0.73 0.22 0.30 0.19 0.67];

timePairs = [];

for i = 1:22
    timePairs(i,1) = x(i);
    timePairs(i,2) = time(i);
end

% disp(timePairs);

gtmPairs    = [timePairs(3,:); timePairs(5,:); timePairs(8,:); timePairs(9,:); timePairs(12,:); timePairs(13,:); timePairs(18,:); timePairs(19,:); timePairs(20,:); timePairs(21,:); timePairs(22,:)];
ltmPairs    = [timePairs(1,:); timePairs(2,:); timePairs(6,:); timePairs(10,:); timePairs(14,:); timePairs(16,:); timePairs(17,:)];
frqPairs    = [timePairs(4,:); timePairs(15,:)];
gradPairs   = [timePairs(7,:)];
uncataPairs = [timePairs(11,:)];

% disp(gtmPairs);
% disp(ltmPairs);
% disp(frqPairs);
% disp(gradPairs);
% disp(uncataPairs);

plot(gtmPairs(:,1), gtmPairs(:,2), '-g+', 'linewidth', 2);
hold all;
plot(ltmPairs(:,1), ltmPairs(:,2), '-ro', 'linewidth', 2);
hold all;
plot(frqPairs(:,1), frqPairs(:,2), '-b*', 'linewidth', 2);
hold all;
plot(gradPairs(:,1), gradPairs(:,2), '-cx', 'linewidth', 2);
hold all;
plot(uncataPairs(:,1), uncataPairs(:,2), '-ms', 'linewidth', 2);
hold all;
xlabel('TMO Index', 'FontSize', 14);
ylabel('Execution Time (sec)', 'FontSize', 14);
title('Execution Time of selected TMOs (trafficLight)', 'FontSize', 18);
% set(gca, 'FontSize', 20);
axis([1 22 0 15]);

legend('Global', 'Local', 'Frequency', 'Gradient', 'Uncatagorized'); 
set(gca,'XTick',1:22);
set(gca,'XTickLabel',{'Ashikhmin', 'Chiu', 'Drago', 'Durand', 'exp',...
    'Fairchild', 'Fattal', 'Ferwerda', 'Kim', 'Krawczyk',...
    'Lischinski', 'log', 'norm', 'Pattanaik', 'Raman',...
    'Reinhard', 'ReBil', 'ReDev', 'Schlick', 'TumRush',...
    'Ward', 'WardHA'});