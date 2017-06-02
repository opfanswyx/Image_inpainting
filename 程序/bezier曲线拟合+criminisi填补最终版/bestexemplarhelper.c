/**
 * A best exemplar finder.  Scans over the entire image (using a
sliding window) and finds the exemplar which minimizes the sum
 * squared error (SSE) over the to-be-filled pixels in the target patch. 
 *一个最佳范例。扫描整个图像(使用滑动窗口),发现最小平方误差之和的范例(SSE)在要填充像素目标补丁。
 * @author Sooraj Bhat
 */
#include "mex.h"
#include <limits.h>

void bestexemplarhelper(const int mm, const int nn, const int m, const int n,    /*计算子程序*/
			const double *img, const double *Ip, 
			const mxLogical *toFill, const mxLogical *sourceRegion,
			double *best)   /*best是输出参数，mm,nn,m,n,img,Ip,toFill,sourceRegion是输入参数*/
{
  register int i,j,ii,jj,ii2,jj2,M,N,I,J,ndx,ndx2,mn=m*n,mmnn=mm*nn;
  double patchErr=0.0,err=0.0,bestErr=1000000000.0;

  /* foreach patch */
  N=nn-n+1;  M=mm-m+1;
  for (j=1; j<=N; ++j) {
    J=j+n-1;
    for (i=1; i<=M; ++i) {
      I=i+m-1;
      /*** Calculate patch error计算补丁错误***/
      /* foreach pixel in the current patch每一个像素在当前的补丁 */
      for (jj=j,jj2=1; jj<=J; ++jj,++jj2) {
	for (ii=i,ii2=1; ii<=I; ++ii,++ii2) {
	  ndx=ii-1+mm*(jj-1);
	  if (!sourceRegion[ndx])
	    goto skipPatch;
	  ndx2=ii2-1+m*(jj2-1);
	  if (!toFill[ndx2]) {
	    err=img[ndx      ] - Ip[ndx2    ]; patchErr += err*err;
	    err=img[ndx+=mmnn] - Ip[ndx2+=mn]; patchErr += err*err;
	    err=img[ndx+=mmnn] - Ip[ndx2+=mn]; patchErr += err*err;
	  }
	}
      }
      /*** Update校正***/
      if (patchErr < bestErr) {
	bestErr = patchErr; 
	best[0] = i; best[1] = I;
	best[2] = j; best[3] = J;
      }
      /*** Reset重置 ***/
    skipPatch:
      patchErr = 0.0; 
    }
  }
}

/* best = bestexemplarhelper(mm,nn,m,n,img,Ip,toFill,sourceRegion); 最佳范例助手*/
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])    /*入口子程序,
                                                                              nlhs表示输出参数的个数
                                                                              类型为mxArray的指针数组plhs[]，用于指向输出的每个参数
                                                                              nrhs表示输入参数的个数
                                                                              类型为mxArray的指针数组prhs[]，用于指向输入的每个参数
                                                                              */
{
  int mm,nn,m,n;
  double *img,*Ip,*best;
  mxLogical *toFill,*sourceRegion; /*定义函数的输入参数*/

  /* Extract the inputs提取输入 */
  mm = (int)mxGetScalar(prhs[0]);
  nn = (int)mxGetScalar(prhs[1]);
  m  = (int)mxGetScalar(prhs[2]);
  n  = (int)mxGetScalar(prhs[3]);
  img = mxGetPr(prhs[4]);
  Ip  = mxGetPr(prhs[5]);
  toFill = mxGetLogicals(prhs[6]);
  sourceRegion = mxGetLogicals(prhs[7]);
  
  /* Setup the output设置输出 */
  plhs[0] = mxCreateDoubleMatrix(4,1,mxREAL);  /*创建2维双精度浮点矩阵，可以是实数(mxREAL)或者复数(mxCOMPLEX)*/
  best = mxGetPr(plhs[0]);
  best[0]=best[1]=best[2]=best[3]=0.0;

  /* Do the actual work做实际的工作 */
  bestexemplarhelper(mm,nn,m,n,img,Ip,toFill,sourceRegion,best);
}
