function [inpaintedImg,origImg,fillImg_org,C,D,fillMovie] = inpaint(imgFilename,fillFilename,fillColor)
%INPAINT  Exemplar-based inpainting.
%
% Usage:   [inpaintedImg,origImg,fillImg,C,D,fillMovie] ...
%                = inpaint(imgFilename,fillFilename,fillColor)
% Inputs: 
%   imgFilename    原始图像.   
%   fillFilename   指定了修复区域的图像. 
%   fillColor      为了指定修复区域而由RGB三分量表示的一个颜色
% Outputs:
%   inpaintedImg   双精度度的M*N*3的修复好了的图像. 
%   origImg        双精度度的M*N*3的原始图像.
%   fillImg        双精度度的M*N*3的填充区域图像.
%   C              各次迭代中，M*N的置信度值的矩阵.
%   D              各次迭代中，M*N的数据项值的矩阵.
%   fillMovie      展示每次迭代后的填充区域.. 
%
% Example:
%   [i1,i2,i3,c,d,mov] = inpaint('21.png','22.png',[0 255 0]);
%  plotall;           % quick and dirty plotting script
%  close; movie(mov); % grab some popcorn 
%  author: Sooraj Bhat

warning off MATLAB:divideByZero %关闭警告
[img,fillImg_org,fillRegion,number_of_inpainted]= loadimgs(imgFilename,fillFilename,fillColor);%加载图像并填充区域，使用“fillColor”作为标记值，以了解要填充的像素。
imshow(fillRegion);
img = double(img);
origImg = img;  %双精度的原图像
ind = img2ind(img);  %调用img2ind()函数 将RGB图像转换为索引图像，使用图像本身作为色彩图像。
sz = [size(img,1) size(img,2)];%sz=[img行数 img列数] r=size(A,1)该语句返回的时矩阵A的行数， c=size(A,2) 该语句返回的时矩阵A的列数。
sourceRegion = ~fillRegion;%~放在一个矩阵的前面，矩阵里只要不为0的数都取非为0，原来是0的数都是1
fillImg=fillImg_org;%****************************************
% Initialize isophote values
[Ix(:,:,3) Iy(:,:,3)] = gradient(img(:,:,3)); %gradient()是求数值梯度函数的命令
%[Fx,Fy]=gradient(x)，其中Fx为其水平方向上的梯度，Fy为其垂直方向上的梯度，Fx的第一列元素为原矩阵第二列与第一列元素之差，
%Fx的第二列元素为原矩阵第三列与第一列元素之差除以2，以此类推：Fx(i,j)=(F(i,j+1)-F(i,j-1))/2。最后一列则为最后两列之差。同理，可以得到Fy。
[Ix(:,:,2) Iy(:,:,2)] = gradient(img(:,:,2));
[Ix(:,:,1) Iy(:,:,1)] = gradient(img(:,:,1));
Ix = sum(Ix,3)/(3*255); Iy = sum(Iy,3)/(3*255);%当图像为RGB三通道时，则sum(A,3)运算后的值为每个通道对应位置的值各自相加
%imshow(Ix)
%imshow(Iy)
temp = Ix; Ix = -Iy; Iy = temp;  % Rotate gradient 90 degrees，旋转梯度90度

% Initialize confidence and data terms 初始化置信度和数据条件
C = double(sourceRegion);   
D = repmat(-.1,sz);   %重复矩阵，重复大小为sz的矩阵，每个值都是-0.1

% Visualization stuff可视化的东西
if nargout==6    %nargout输出参数的个数
  fillMovie(1).cdata=uint8(img); 
  fillMovie(1).colormap=[];
  origImg(1,1,:) = fillColor;
  iter = 2;
end

% Seed 'rand' for reproducible results (good for testing)种子'rand'可重复的结果（有利于测试）
rand('state',0);  %Resets the generator to its initial state.将发生器重置为初始状态。


    %% while any(fillRegion(:)) %any()非零时为真
    
% 寻找边界 &归一化填充区域的梯度
fill=find(fillRegion==1);
dR = find(conv2(single(fillRegion),[1,1,1;1,-8,1;1,1,1],'same')>0);  
%single（）变成单精度的，                               
%conv2（a,b,'same'）二维卷积,返回和a一样大小的矩阵；
%find()返回满足条件的矩阵中元素的序列号列向量，按列
%fillRegion原图大小 
                                                                     
                                                                       
 [Nx,Ny] = gradient(1-fillRegion);
 N = [Nx(dR(:)) Ny(dR(:))];
 % imshow(N);
 N = normr(N);     %按行归一化 
 N(~isfinite(N))=0; % 处理 NaN and Inf ，isfinite()返回向量，元素为有限则对应1，元素为无限则对应0
  
 %---------------------------------------------
 %沿着填充边缘计算置信度
 %获取块的大小，计算优先值
 %---------------------------------------------
  
    a=rgb2gray(fillImg);
    a=double(a);
    %fillRegion=double(fillRegion);
    BB1 = edge(a,'canny');
    BB=edge(fillRegion,'canny');

    BW=BB1-BB;
    imshow(BW);
    
 number_1=sum(sum(BW));
  ww=[];
  for k=dR'
     [Hp,rows,cols,w]= getpatch_auto(BW,k);      %调用getpatch_auto()函数
     q = Hp(~(fillRegion(Hp))); %fillRegion(Hp)是(2w+1)*(2w+1)的块，里面待填充区域是1，源区域是0
                                 %q是列向量，由源区域像素点构成
     C(k) = sum(C(q))/numel(Hp);%numel()面积即像素数
       %tt=numel(Hp);
     ww=[ww w];
  end
  
  % 优先值= confidence term * data term
  D(dR) = abs(Ix(dR).*N(:,1)+Iy(dR).*N(:,2)) + 0.00001;
  priorities = (C(dR)).* D(dR);   %列向量
  
     
  %找到最大的优先值, Hp
     %[unused,ndx] = max(priorities(:));%max()找到每列中的最大值放入unused，第几个放入ndx
  priorities=priorities';%行向量
  [X,I]=sort(priorities);
  x=fliplr(X);    %从大到小存放优先值
  ndx=fliplr(I);  %优先值对应的在dR中的顺序
     
  for i=1:size(dR,1)
      ww_order(i)=ww(ndx(i));
  end
  
  prior=priorities;
  
  dR=dR';   %行向量
  
  
  % 循环直到全部修复完

 while or(any(dR),any(fillRegion))
     
     %----------------------------------------------------------
     %修复优先级最高的点
     %
     %----------------------------------------------------------

     p = dR(ndx(1));   %取dR中优先级最大的点
     w_max=ww_order(1);
     [Hp,rows,cols]= getpatch(fillImg,w_max,p);%rows行数行向量，cols列数列向量
     toFill = fillRegion(Hp); %9*9二值块
     qq = Hp(~(fillRegion(Hp)));
     %搜索匹配
     Hq = bestexemplar(img,img(rows,cols,:),toFill',sourceRegion);%调用bestexemplar（）
    
   
     % 更新填充区域
     fillRegion(Hp(toFill)) = false;   % 块Hp为0，已知点 
      
     %更新后的边缘梯度
     [Nx,Ny] = gradient(1-fillRegion);  

     % Propagate confidence & isophote values
     
     rr=img(:,:,1);
     pp1=rr(qq);
     gg=img(:,:,2);
     pp2=gg(qq);
     bb=img(:,:,3);
     pp3=bb(qq);
     pp=(pp1+pp2+pp3)/3;
     
     C(Hp(toFill))  = C(p)*exp(-1*mse(pp));
%      C(Hp(toFill))  = C(p)
     Ix(Hp(toFill)) = Ix(Hq(toFill));
     Iy(Hp(toFill)) = Iy(Hq(toFill));
  
     % Copy image data from Hq to Hp
    ind(Hp(toFill)) = ind(Hq(toFill));
    img(rows,cols,:) = ind2img(ind(rows,cols),origImg);  
    fillImg(rows,cols,:)= ind2img(ind(rows,cols),origImg);  
   
    % Visualization stuff
    if nargout==6
       ind2=ind;
       ind2(fillRegion)= 1;
       fillMovie(iter).cdata=uint8(ind2img(ind2,origImg)); 
       fillMovie(iter).colormap=[];
    end      
     
    %---------------------------------------------------------
    %去掉已填充点，插入新的像素点；包括在dR,x,ndx，ww中
    %---------------------------------------------------------
    
    dR_new_1=find(conv2(single(fillRegion),[1,1,1;1,-8,1;1,1,1],'same')>0);
    dR_new=dR_new_1'; %行向量
    compare_dR=ismember(dR,dR_new);%dR_new中的元素在dR中，对应位置为1，否则为0
   
    dR_notin_dR_new=[];
    
    for u=1:size(compare_dR,2)
        if compare_dR(u)==0
        dR_notin_dR_new=[dR_notin_dR_new u];
        end
    end
        
    dR(:,dR_notin_dR_new)=[];
    ww(:,dR_notin_dR_new)=[];
    prior(:,dR_notin_dR_new)=[];
    %增加
    compare_dR_new=ismember(dR_new,dR);
    
    a=rgb2gray(fillImg); 
    a=double(a);

    BB1 = edge(a,'canny');

   if any(fillRegion(:)) 
      BB=edge(fillRegion,'canny');
   else BB=repmat(0,sz);
   end

    BW=BB1-BB;   %循环计算
    
    figure(2);
%    imshow(BW);
    
    for  v=1:size(compare_dR_new,2)
       if compare_dR_new(v)==0
          new_index=dR_new(v);
          dR=[dR new_index];
            
             %计算优先值
          [Hp,rows,cols,w]= getpatch_auto(BW,new_index);
            
          ww=[ww w];
            
          q = Hp(~(fillRegion(Hp)));%q 已知点
          C(new_index)= sum(C(q))/numel(Hp);
            
             
          N = [Nx(new_index) Ny(new_index)];
          N = normr(N);     %按行归一化 
          N(~isfinite(N))=0;
          D(new_index)= abs(Ix(new_index)*N(1,1)+Iy(new_index)*N(1,2)) + 0.00001;
            
          p_new=C(new_index)*D(new_index);
              
          prior=[prior p_new];
       end
     end
    
      [X,I]=sort(prior);
      x=fliplr(X);    %从大到小存放优先值
      ndx=fliplr(I);  %优先值对应的在dR中的顺序
     
      for i=1:size(dR,2)
         ww_order(i)=ww(ndx(i));
      end
     
    
  iter = iter+1;  
end

inpaintedImg=img;

fill_mse=[];

for i=3:-1:1 
    temp1=origImg(:,:,i); 
    temp2=inpaintedImg(:,:,i);
    uu=temp1(fill(:))-temp2(fill(:));
    fill_mse=[fill_mse mse(uu)]
end;




%---------------------------------------------------------------------
% Scans over the entire image (with a sliding window)
%扫描整个图像（带滑动窗口）
% for the exemplar with the lowest error. Calls a MEX function.
%对于具有最低错误的示例。 调用MEX功能。
%---------------------------------------------------------------------
function Hq = bestexemplar(img,Ip,toFill,sourceRegion)
m=size(Ip,1);n=size(Ip,2);mm=size(img,1); nn=size(img,2);
best = bestexemplarhelper(mm,nn,m,n,img,Ip,toFill,sourceRegion);
Hq = sub2ndx(best(1):best(2),(best(3):best(4))',mm);


%---------------------------------------------------------------------
% Returns the indices for a 9x9 patch centered at pixel p.
%返回以像素p为中心的9x9补丁的索引。
%---------------------------------------------------------------------
function [Hp,rows,cols,w]=getpatch_auto(BW,p)
% [x,y] = ind2sub(sz,p);  % 2*w+1 == the patch size


sz=size(BW);

p=p-1;
y=floor(p/sz(1))+1;
p=rem(p,sz(1)); 
x=floor(p)+1;

number=0;
w=1;
while (number<3&&w<7)
    rows = max(x-w,1):min(x+w,sz(1));          %9*9的块 rows是行向量
    cols = (max(y-w,1):min(y+w,sz(2)))';       %cols是列向量

    MM = rows(ones(length(cols),1),:);% ones()是length(cols)*1的全1列向量
    %imshow(X);title('x');          %X是9*9矩阵，每一列的元素都一样，都是行数
    %[yy,ee]=size(X)
    NN = cols(:,ones(1,length(rows)));%Y是9*9矩阵，每一行的元素都一样，都是列数
    N = MM+(NN-1)*sz(1);  %索引矩阵
    %figure(3);
    %imshow(N);
    %imshow(BW(N));
    %BW(N);

   [a b]=size(BW(N));
   BW2=reshape(BW(N),1,a*b);

    for k=1:a*b
      if BW2(k)==1
       number=number+1;
      end
    end
   
    w=w+1;
end  

 
 if number<8
      w=w-1;
 else w=w-2;
 end
                                                              
rows = max(x-w,1):min(x+w,sz(1));          %9*9的块 rows是行向量
cols = (max(y-w,1):min(y+w,sz(2)))';       %cols是列向量
Hp = sub2ndx(rows,cols,sz(1));     %调用sub2ndx()


%---------------------------------------------------------------------
% Returns the indices for a w_max*w_max patch centered at pixel p.
%返回以像素p为中心的w_max * w_max补丁的索引。
%---------------------------------------------------------------------

function [Hp,rows,cols]=getpatch(fillImg,w_max,p)
% [x,y] = ind2sub(sz,p);  % 2*w+1 == the patch size
sz=size(fillImg);
p=p-1; y=floor(p/sz(1))+1; p=rem(p,sz(1)); x=floor(p)+1;  %floor(x)小于x的最大的整数,rem(x,y)=x - n.*y, n=fix(x./y)=floor(x./y)
                                                               %x是p的行数，y是p的列数

rows = max(x-w_max,1):min(x+w_max,sz(1));          %9*9的块 rows是行向量
cols = (max(y-w_max,1):min(y+w_max,sz(2)))';       %cols是列向量
Hp = sub2ndx(rows,cols,sz(1));  



%---------------------------------------------------------------------
% Converts the (rows,cols) subscript-style indices to Matlab index-style
% indices.  Unforunately, 'sub2ind' cannot be used for this.
%将（rows，cols）下标样式索引转换为Matlab索引样式索引。 不幸的是，'sub2ind'不能用于此。
%---------------------------------------------------------------------
function N = sub2ndx(rows,cols,nTotalRows)
X = rows(ones(length(cols),1),:);% ones()是length(cols)*1的全1列向量
%imshow(X);title('x');          %X是9*9矩阵，每一列的元素都一样，都是行数
%[yy,ee]=size(X)
Y = cols(:,ones(1,length(rows)));%Y是9*9矩阵，每一行的元素都一样，都是列数
N = X+(Y-1)*nTotalRows;  %索引矩阵


%---------------------------------------------------------------------
% Converts an indexed image into an RGB image, using 'img' as a colormap
%将索引图像转换为RGB图像，使用“img”作为色彩图像
%---------------------------------------------------------------------
function img2 = ind2img(ind,img)
for i=3:-1:1, temp=img(:,:,i); img2(:,:,i)=temp(ind); end;


%---------------------------------------------------------------------
% Converts an RGB image into a indexed image, using the image itself as
%将RGB图像转换为索引图像，使用图像本身作为色彩图像。
% the colormap.
%---------------------------------------------------------------------
function ind = img2ind(img)
s=size(img); ind=reshape(1:s(1)*s(2),s(1),s(2));%1到s(1)*s(2)按列给出s(1)行s(2)列的矩阵，按列赋值


%---------------------------------------------------------------------
% Loads the an image and it's fill region, using 'fillColor' as a marker
% value for knowing which pixels are to be filled.
%加载图像并填充区域，使用“fillColor”作为标记值，以了解要填充的像素。
%---------------------------------------------------------------------
function [img,fillImg,fillRegion,number_of_inpainted]= loadimgs(imgFilename,fillFilename,fillColor)
img = imread(imgFilename); fillImg = imread(fillFilename);
fillRegion = fillImg(:,:,1)==fillColor(1) & ...
    fillImg(:,:,2)==fillColor(2) & fillImg(:,:,3)==fillColor(3);
a=single(fillRegion);
number_of_inpainted=sum(sum(a))
rate=number_of_inpainted/(size(img,1)*size(img,2))