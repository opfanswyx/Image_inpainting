function color=one_level_bezier(a,x1,y1,x2,y2)
%对图像的单通道做bezier曲线拟合
%cform = makecform('srgb2lab');
%lab = applycform(q, cform);

A1=x1;
B1=y1;
r=a(:,:,1);
for t=0.01:1/200:0.99
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
    p1=r(ceil(y1),ceil(x1));
    p2=r(ceil(y2),ceil(x2));
    p=(w1*p1+w2*p2)/(w1+w2);
    p=round(p);
    r(ceil(B1),ceil(A1))=ceil(p);
end;

A1=x1;
B1=y1;
g=a(:,:,2);
for t=0.01:1/200:0.99
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
    p1=g(ceil(y1),ceil(x1));
    p2=g(ceil(y2),ceil(x2));
    p=(w1*p1+w2*p2)/(w1+w2);
    p=round(p);
    g(ceil(B1),ceil(A1))=ceil(p);
end;

A1=x1;
B1=y1;
b=a(:,:,3);
for t=0.01:1/200:0.99
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
    p1=b(ceil(y1),ceil(x1));
    p2=b(ceil(y2),ceil(x2));
    p=(w1*p1+w2*p2)/(w1+w2);
    p=round(p);
    b(ceil(B1),ceil(A1))=ceil(p);
end;

%lab=cat(3,l,a,b);
%cform = makecform('lab2srgb');
%rgb = applycform(lab, cform);
%r=rgb(:,:,1);
%g=rgb(:,:,2);
%b=rgb(:,:,3);
color=cat(3,r,g,b);
