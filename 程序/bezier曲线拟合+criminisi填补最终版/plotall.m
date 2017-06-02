% This is a simple script to plot some diagrams.这是一个简单的绘图脚本
% It assumes you have already run inpaint, storing into the variables i1,i2,i3,c,d, like so.假设你已经运行填补,存储到变量:
clear all;
[i1,i2,i3,c,d,mov]=inpaint('hello3.png','hello3.png',[0 255 0]);

figure(1);
image(uint8(i2)); title('原图像');
figure(2);
image(uint8(i3)); title('选定了修复区域');
figure(3);
image(uint8(i1)); title('修复后的图像');
% subplot(234);imagesc(c); title('置信度');
% subplot(235);imagesc(d); title('数据项');

figure(4);
image(uint8(i1)); title('修复后的图像');
%figure;
%subplot(121);imagesc(c); title('Confidence term');
%subplot(122);imagesc(d); title('Data term');
imwrite(uint8(i1),'inpainted.png')
close;
figure(5);
movie(mov);