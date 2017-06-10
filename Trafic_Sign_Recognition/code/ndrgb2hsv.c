#include <math.h>
#include "mex.h"
/*
  mex ndrgb2hsv.c
   A = double(ceil(255*rand(200 , 300 , 3 , 4)));
   Z = ndrgb2hsv(A);
*/
#define MIN(a , b) ((a) < (b) ? (a) : (b))
#define MAX(a , b) ((a) >= (b) ? (a) : (b))
#define NO_HUE 0
/*-------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------*/
/*------------------------ Headers   --------------------------------------*/
/*-------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------*/
void ndrgb2hsv (double * , double * , int , int , int , double );
/*-------------------------------------------------------------------------*/
/*-------------------------------------------------------------------------*/
void mexFunction( int nlhs, mxArray *plhs[] , 
        int nrhs, const mxArray *prhs[] )
{
	double *RGB;
	double *HSV;
	double cte = 1.0/255.0;
	int *dimsRGB=NULL;
	int i , n , m , slice = 1 , numdimsRGB;
/*---------------------------------------------------------------*/
/*---------------------- PARSE INPUT ----------------------------*/	
/*---------------------------------------------------------------*/
	if(nrhs != 1)
	{
		mexErrMsgTxt("1 input is required");
	}
/*---------------- Input 1 ----------------------*/
	RGB = mxGetPr(prhs[0]);
	numdimsRGB = mxGetNumberOfDimensions(prhs[0]);
	dimsRGB = mxGetDimensions(prhs[0]);
	if ((numdimsRGB < 3) || !(mxIsDouble(prhs[0])))
	{
		mexErrMsgTxt("First input must at least a Double Matrix (n x m x 3)");
	}
	n = dimsRGB[0];
	m = dimsRGB[1];
	if (numdimsRGB > 3)
	{
		for (i = 3 ; i < numdimsRGB ; i++)
		{
			slice *= dimsRGB[i];
		}
	}
/*------------------- Output 1 ----------------------*/
plhs[0] = mxCreateNumericArray(numdimsRGB, dimsRGB, mxDOUBLE_CLASS, mxREAL);
	HSV = mxGetPr(plhs[0]);
/*----------- Convert into HSV ---------------*/
	ndrgb2hsv(RGB , HSV , n , m , slice , cte);
/*--------------------------------------------*/
}
/*----------------------------------------------------------------------------------------------- */
/*----------------------------------------------------------------------------------------------- */
void ndrgb2hsv (double *RGB , double *HSV , int n , int m , int slice , double cte)
{
	double r , g , b , max , min , delta;
	double h , s , v ;
	int nm = n*m , nm3 = nm*3 , i , sl , slnm3 ;
	for(sl = 0 ; sl < slice ; sl++)
	{
		slnm3 = sl*nm3;
		for (i = 0; i < nm ; i++)
		{	
			r = RGB[i + + slnm3]*cte;
			g = RGB[i + nm + slnm3]*cte;
			b = RGB[i + 2*nm + slnm3]*cte;
			max = MAX(r , MAX(g , b));
			min = MIN(r , MIN(g , b));
			delta = (max - min);
			v = max;
			if (max != 0.0)
			{
				s = delta/max;
			}else{
				s = 0.0;
			}
			if (s == 0.0)
			{
				h = NO_HUE;
			}else{	
				if (r == max)
				{
					h = (g - b)/delta;
				}
				else if (g == max)
				{
					h = 2.0 + (b - r)/delta;
				}
				else if (b == max)
				{
					h = 4.0 + (r - g)/delta;
				}
				h *= 60.0;
				if (h < 0)
				{
					h += 360.0;
				}
				h /= 360.0;	
			}
			HSV[i + slnm3] = h;
			HSV[i + nm + slnm3] = s;
			HSV[i + 2*nm + slnm3] = v;

		}

	}
}
/*----------------------------------------------------------------------------------------------- */
/*----------------------------------------------------------------------------------------------- */
