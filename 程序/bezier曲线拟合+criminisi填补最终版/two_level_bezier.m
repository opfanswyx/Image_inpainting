function color=two_level_bezier(a,x1,y1,x2,y2,x3,y3)

Xb1=x1;
Yb1=y1;
Xb2=x2;
Yb2=y2;

r=a(:,:,1);
g=a(:,:,2);
b=a(:,:,3);
for t=0.01:1/200:0.99
    if Xb1~=x2-1
        Xb1=(1-t)*x1+t*x2;
    else
        Xb1=x2-1;
    end;
    if Yb1~=y2-1
        Yb1=(1-t)*y1+t*y2;
    else
        Yb1=y2-1;
    end;
    A=[Xb1,Yb1];
    if Xb2~=x3-1
        Xb2=(1-t)*x2+t*x3;
    else
        Xb2=x3-1;
    end;
    if Yb2~=y3-1
    Yb2=(1-t)*y2+t*y3;
    else
        Yb2=y3-1;
    end;
    B=[Xb2,Yb2];
    Xc=(1-t)*Xb1+t*Xb2;
    Yc=(1-t)*Yb1+t*Yb2;
    
    w1=1/sqrt((x1-Xc)^2+(y1-Xc)^2);
    w2=1/sqrt((x2-Yc)^2+(y2-Yc)^2);
    %r通道
    p1=r(y1,x1);
    p2=r(y3,x3);
    p=(w1*p1+w2*p2)/(w1+w2);
    r(ceil(Yc),ceil(Xc))=ceil(p);
    %g通道
    p1=g(y1,x1);
    p2=g(y3,x3);
    p=(w1*p1+w2*p2)/(w1+w2);
    g(ceil(Yc),ceil(Xc))=ceil(p);
    %b通道
    p1=b(y1,x1);
    p2=b(y3,x3);
    p=(w1*p1+w2*p2)/(w1+w2);
    b(ceil(Yc),ceil(Xc))=ceil(p);
end;


color=cat(3,r,g,b);