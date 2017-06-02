function color=one_level_bezier(a,x1,y1,x2,y2)

A1=x1;
B1=y1;
r=a(:,:,1);
g=a(:,:,2);
b=a(:,:,3);
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
end;

color=cat(3,r,g,b);