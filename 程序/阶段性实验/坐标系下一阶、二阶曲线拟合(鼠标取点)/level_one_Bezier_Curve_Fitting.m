clear all;
x1=2;
y1=2;
x2=10;
y2=10;
hold on;
plot(x1,y1,'o','MarkerFaceColor','r','MarkerSize',8);
text(x1-0.7,y1,'p1');
plot(x2,y2,'o','MarkerFaceColor','r','MarkerSize',8);
text(x2-0.7,y2,'p2');
set(gca,'XLim',[0 12]);%X轴的数据显示范围
set(gca,'YLim',[0 12]);
for t=0:1/300:1
    x3=(1-t)*x1+t*x2;
    y3=(1-t)*y1+t*y2;
    hold on;
    drawnow;
    plot(x3,y3,'-ks','MarkerFaceColor','k','MarkerSize',1);
    %plot(x3,y3,'k.');
    %comet(x3,y3);
    %grid on;
end;

