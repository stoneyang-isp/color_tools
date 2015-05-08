clf;

x = 1:1:8;
Q = [0.8292 .8355 .8974 .8191 .8203 .7773 .8161 .9146];
S = [.8801 .8292 .8651 .8844 .8855 .8591 .8776 .8637];
N = [.1785 .2704 .5504 .1320 .1357 .0198 .1272 .6615];

plot(x, Q, '-o', 'linewidth', 2);
hold all;
plot(x, S, '-+', 'linewidth', 2);
hold all;
plot(x, N, '-*', 'linewidth', 2);

xlabel('TMO Index', 'FontSize', 14);
ylabel('Scores', 'FontSize', 14);
title('Tone mapped image quality assessment (trafficLight)', 'FontSize', 18);

legend('Q', 'S', 'N'); 
set(gca,'XTick',1:8);
set(gca,'XTickLabel',{'Drago','Durand','Kim','Reinhard','ReinhardBil','Schlick','WardHistAdj','Fairchild'});