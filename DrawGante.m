%machine num time1 time2
a=[1    1   0   2;
   1    3   2   8;
   2    2   0   5;
   3    4   0   4;
   4    4   4   10;
   4    2   10  13;
   5    1   2   7;
   5    3   8   10;
   6    3   10  13;
   8    1   7   9;
   8    2   13  18;
   9    4   10  18];
figure(1);clf;
w=0.5;       %ºáÌõ¿í¶È
set(gcf,'color','w');
for ii=1:size(a,1)
    x=a(ii,[3 3 4 4]);
    y=a(ii,1)+[-w/2 w/2 w/2 -w/2];
    p=patch('xdata',x,'ydata',y,'facecolor','none','edgecolor','k');
    text(a(ii,3)+0.5,a(ii,1),num2str(a(ii,2)));
end
xlabel('processing time(s)');
ylabel('Machine');
axis([0 20 0 10]);
set(gca,'Box','on');
set(gca,'YTick',0:10);
set(gca,'YTickLabel',[{''};num2str((1:9)','M%d');{''}]);