clear all;
i=imread('blacktest.png');
i2=rgb2gray(i);
imshow(i2);
hold on;
[x1,y1]=ginput(1);
[x2,y2]=ginput(1);
[x3,y3]=ginput(1);
[x4,y4]=ginput(1);
x1=round(x1);y1=round(y1);
x2=round(x2);y2=round(y2);
x3=round(x3);y3=round(y3);
x4=round(x4);y4=round(y4);
%x1=input('输入x1:');y1=input('输入y1:');
 %            x2=input('输入x2:');y2=input('输入y2:');
  %           x3=input('输入x3:');y3=input('输入y3:');
   %          x4=input('输入x4:');y4=input('输入y4:');
plot(x1,y1,'o','MarkerFaceColor','r','MarkerSize',8);
text(x1,y1,'p1');
plot(x2,y2,'o','MarkerFaceColor','r','MarkerSize',8);
text(x2,y2,'p2');
plot(x3,y3,'o','MarkerFaceColor','r','MarkerSize',8);
text(x3,y3,'p3');
plot(x4,y4,'o','MarkerFaceColor','r','MarkerSize',8);
text(x4,y4,'p4');
d=(y3-y1)*(x4-x2)-(y4-y2)*(x3-x1);
%x0=((x3-x1)*(x4-x2)*(x2-x1)+(y3-y1)*(x4-x2)*x1-(y4-y2)*(x3-x1)*x2)/(d);
%y0=((y3-y1)*(y4-y2)*(x2-x1)+(x3-x1)*(y4-y2)*(y1)-(x4-x2)*(y3-y1)*(y2))/(-d);
x0=((x2*y4-x4*y2)*(x1-x3)-(x1*y3-x3*y1)*(x2-x4))/(d);
x0=round(x0);
y0=((x4*y2-x2*y4)*(y1-y3)-(x3*y1-x1*y3)*(y2-y4))/(-d);
y0=round(y0);
plot(x0,y0,'o','MarkerFaceColor','g','MarkerSize',8);
text(x0,y0,'p0');

Xb1=x1;
Yb1=y1;
Xb2=x0;
Yb2=y0;
for t=0.01:1/200:0.99
    if Xb1~=x0-1
        Xb1=(1-t)*x1+t*x0;
    else
        Xb1=x0-1;
    end;
    Xb1=round(Xb1);
    
    if Yb1~=y0-1
        Yb1=(1-t)*y1+t*y2;
    else
        Yb1=y0-1;
    end;
    Yb1=round(Yb1);
    A=[Xb1,Yb1];
    
    
    if Xb2~=x2-1
        Xb2=(1-t)*x0+t*x2;
    else
        Xb2=x2-1;
    end;
    Xb2=round(Xb2);
    if Yb2~=y2-1
    Yb2=(1-t)*y0+t*y2;
    else
        Yb2=y2-1;
    end;
    Yb2=round(Yb2);
    B=[Xb2,Yb2];
    Xc=(1-t)*Xb1+t*Xb2;
    Xc=round(Xc);
    Yc=(1-t)*Yb1+t*Yb2;
    Yc=round(Yc);
    %hold on;
    drawnow;
    %plot(Xb1,Yb1,'o','MarkerFaceColor','r','MarkerSize',5);
    %plot(Xb2,Yb2,'o','MarkerFaceColor','r','MarkerSize',5);
        %plot([Xb1,Xb2],[Yb1,Yb2],':k');
        %plot(Xb1,Yb1,'-ks','MarkerFaceColor','y','MarkerSize',1);
        %plot(Xb2,Yb2,'-ks','MarkerFaceColor','y','MarkerSize',1);
        %plot(Xc,Yc,'-ks','MarkerFaceColor','y','MarkerSize',1);
    %plot(x3,y3,'k.');
    %comet(x3,y3);
    %grid on;
    
    
    w1=1/sqrt((x1-Xc)^2+(y1-Xc)^2);
    w2=1/sqrt((x2-Yc)^2+(y2-Yc)^2);
    p1=i2(round(y1),round(x1));
    p2=i2(round(y2),round(x2));
    p=(w1*p1+w2*p2)/(w1+w2);
    i2(round(Yc),ceil(Xc))=round(p);
end;
imshow(i2);