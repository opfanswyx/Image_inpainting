clear all;
i=imread('马球图分块.png');
%i2=rgb2gray(i);
i3=i;
imshow(i3);
hold on; %是当前轴及图形保持而不被刷新，准备接受此后将绘制
[x1,y1]=ginput(1);
[x2,y2]=ginput(1);
plot(x1,y1,'o','MarkerFaceColor','r','MarkerSize',8);
text(x1,y1,'p1');
plot(x2,y2,'o','MarkerFaceColor','r','MarkerSize',8);
text(x2,y2,'p2');
%for t=0.01:1/200:0.99
   % A1=(1-t)*x1+t*x2;
  %  B1=(1-t)*y1+t*y2;
 %   hold on;
  %  drawnow;
%    w1=1/sqrt((x1-A1)^2+(y1-B1)^2);
%    w2=1/sqrt((x2-A1)^2+(y2-B1)^2);
%    p1=i3(round(y1),round(x1));
%    p=(w1*p1+w2*p2)/(w1+w2);
%    imshow(i3);
A1=x1;
B1=y1;
r=i3(:,:,1);
g=i3(:,:,2);
b=i3(:,:,3);
for t=0.005:1/300:1
    if A1~=x2-1
        A1=(1-t)*x1+t*x2;
        A1=ceil(A1);
    else
        A1=x2-1;
    end;
    if B1~=y2-1
        B1=(1-t)*y1+t*y2;
        B1=ceil(B1);
    else
        B1=y2-1;
    end;
    hold on;
    drawnow;
    w1=1/sqrt((x1-A1)^2+(y1-B1)^2);
    w2=1/sqrt((x2-A1)^2+(y2-B1)^2);
    %r通道
    p1=r(y1,x1);
    p2=r(y1,x1);
    p=(w1*p1+w2*p2)/(w1+w2);
    %p=(p1+p2)/2;
    r(B1,A1)=p;
    %g通道
    p3=g(y1,x1);
    p4=g(y1,x1);
    pp=(w1*p3+w2*p4)/(w1+w2);
    %pp=(p3+p4)/2;
    g(B1,A1)=pp;
    %b通道
    p5=b(y1,x1);
    p6=b(y1,x1);
    ppp=(w1*p5+w2*p6)/(w1+w2);
    %ppp=(p5+p6)/2;
    b(B1,A1)=ppp;
    i3=cat(3,r,g,b);
    imshow(i3);
end;