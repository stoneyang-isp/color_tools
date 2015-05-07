clf;

plot(x, Q, '-o', 'linewidth', 2);
hold all;
plot(x, S, '-+', 'linewidth', 2);
hold all;
plot(x, N, '-*', 'linewidth', 2);
hold all;

xlabel('TMO Index');
hold all;
ylabel('Scores');

legend('Q', 'S', 'N'); 
set(gca,'XTick',1:8);
set(gca,'XTickLabel',{'Drago','Durand','Kim','Reinhard','ReinhardBil','Schlick','WardHistAdj','Fairchild'});