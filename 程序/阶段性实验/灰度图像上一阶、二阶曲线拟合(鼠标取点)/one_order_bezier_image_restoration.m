clear all;
i=imread('马球图分块.png');
i2=rgb2gray(i);
%imshow(i2);
i3=i2;%imcrop(i2,[13 200 213 101]);%分割图像
%figure;
imshow(i3);
hold on; %是当前轴及图形保持而不被刷新，准备接受此后将绘制
[x1,y1]=ginput(1);
[x2,y2]=ginput(1);
%[x3,y3]=ginput(1);
%[x4,y4]=ginput(1);
plot(x1,y1,'o','MarkerFaceColor','r','MarkerSize',8);
text(x1,y1,'p1');
plot(x2,y2,'o','MarkerFaceColor','r','MarkerSize',8);
text(x2,y2,'p2');
%plot(x3,y3,'o','MarkerFaceColor','r','MarkerSize',8);
%text(x3,y3,'p3');
%plot(x4,y4,'o','MarkerFaceColor','r','MarkerSize',8);
%text(x4,y4,'p4');
for t=0.01:1/200:0.99
    A1=(1-t)*x1+t*x2;
    B1=(1-t)*y1+t*y2;
    %A2=(1-t)*x3+t*x4;
    %B2=(1-t)*y3+t*y4;
    hold on;
    drawnow;
    %plot(A1,B1,'-ks','MarkerFaceColor','k','MarkerSize',1);
    %plot(A2,B2,'-ks','MarkerFaceColor','k','MarkerSize',1);
    w1=1/sqrt((x1-A1)^2+(y1-B1)^2);
    w2=1/sqrt((x2-A1)^2+(y2-B1)^2);
    %w3=1/sqrt((x3-A1)^2+(y3-B1)^2);
    %w4=1/sqrt((x4-A1)^2+(y4-B1)^2);
    p1=i3(round(y1),round(x1));
    p2=i3(round(y2),round(x2));
    %p3=i3(round(y3),round(x3));
    %p4=i3(round(y4),round(x4));
    p=(w1*p1+w2*p2)/(w1+w2);
    %pp=(w1*p3+w2*p4)/(w1+w2);
    i3(round(B1),round(A1))=round(p);
    %i3(round(B2),round(A2))=round(pp);
    %figure;
    imshow(i3);
end;
%imshow(i3);

