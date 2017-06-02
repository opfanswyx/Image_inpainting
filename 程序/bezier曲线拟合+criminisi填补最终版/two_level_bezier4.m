function color=two_level_bezier4(a,x1,y1,x2,y2,x3,y3,x4,y4)

d=(y3-y1)*(x4-x2)-(y4-y2)*(x3-x1);
%x0=((x3-x1)*(x4-x2)*(x2-x1)+(y3-y1)*(x4-x2)*x1-(y4-y2)*(x3-x1)*x2)/(d);
%y0=((y3-y1)*(y4-y2)*(x2-x1)+(x3-x1)*(y4-y2)*y1-(x4-x2)*(y3-y1)*y2)/(-d);
%x0=(x2*y4-x4*y2)*(x1-x3)-(x1*y3-x3*y1)*(x2-x4)/(d);
%x0=round(x0);
%y0=(x4*y2-x2*y4)*(y1-y3)-(x3*y1-x1*y3)*(y2-y4)/(-d);
%y0=round(y0);
x0=((x2*y4-x4*y2)*(x1-x3)-(x1*y3-x3*y1)*(x2-x4))/(d);
x0=round(x0);
y0=((x4*y2-x2*y4)*(y1-y3)-(x3*y1-x1*y3)*(y2-y4))/(-d);
y0=round(y0);


Xb1=x1;
Yb1=y1;
Xb2=x0;
Yb2=y0;
r=a(:,:,1);
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
     
    w1=1/sqrt((x1-Xc)^2+(y1-Xc)^2);
    w2=1/sqrt((x2-Yc)^2+(y2-Yc)^2);
    p1=r(round(y1),round(x1));
    p2=r(round(y2),round(x2));
    p=(w1*p1+w2*p2)/(w1+w2);
    r(round(Yc),ceil(Xc))=round(p);
end;

Xb1=x1;
Yb1=y1;
Xb2=x0;
Yb2=y0;
g=a(:,:,2);
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
     
    w1=1/sqrt((x1-Xc)^2+(y1-Xc)^2);
    w2=1/sqrt((x2-Yc)^2+(y2-Yc)^2);
    p1=g(round(y1),round(x1));
    p2=g(round(y2),round(x2));
    p=(w1*p1+w2*p2)/(w1+w2);
    g(round(Yc),ceil(Xc))=round(p);
end;

Xb1=x1;
Yb1=y1;
Xb2=x0;
Yb2=y0;
b=a(:,:,3);
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
     
    w1=1/sqrt((x1-Xc)^2+(y1-Xc)^2);
    w2=1/sqrt((x2-Yc)^2+(y2-Yc)^2);
    p1=b(round(y1),round(x1));
    p2=b(round(y2),round(x2));
    p=(w1*p1+w2*p2)/(w1+w2);
    b(round(Yc),ceil(Xc))=round(p);
end;

color=cat(3,r,g,b);