#include "stdafx.h"
#include <stdio.h>
#include <string.h>
#include <iostream>
#include <opencv2\highgui\highgui.hpp>
#include <opencv2\imgproc\imgproc.hpp>
#include <opencv2\core\core.hpp>

using namespace cv;
using namespace std;

void MyFilledCircle(Mat img, Point center,Scalar s)
{
	int thickness = -1;
	int lineType = 8;
	circle(img,
		center,
		25,
		s,
		thickness,
		lineType);
}

int main()
{
	//Mat a(600, 600, CV_8UC3, Scalar(255, 255, 255));
	Point p0(150, 150);
	Scalar s0(0, 0, 255);
	Point p1(150, 450);
	Scalar s1(0, 255, 0);
	Point p2(450, 150);
	Scalar s2(255, 0, 0);
	Point p3(450, 450);
	Scalar s3(0, 255, 255);
	Point p4(300, 300);
	Scalar s4(0, 69, 255);
	namedWindow("Window1", WINDOW_AUTOSIZE);
	imshow("Window1", a);
	Mat img1;
	imwrite("Image11.jpg", a);*/
	Scalar sca[5];
	sca[0] = s0;
	sca[1] = s1;
	sca[2] = s2;
	sca[3] = s3;
	sca[4] = s4;
	int ctr = 0;
	for (int i = 0; i < 5; i++)
	{
		for (int j = 0; j < 5; j++)
		{
			for (int k = 0; k < 5; k++)
			{
				for (int l = 0; l < 5; l++)
				{
					for (int m = 0; m < 5; m++)
					{
						if (i != j && i != k && i != l && i != m && k != l && j != k && j != l && j != m && k != m && l != m)
						{
							Mat a(600, 600, CV_8UC3, Scalar(255, 255, 255));
							MyFilledCircle(a, p0, sca[i]);
							MyFilledCircle(a, p1, sca[j]);
							MyFilledCircle(a, p2, sca[k]);
							MyFilledCircle(a, p3, sca[l]);
							MyFilledCircle(a, p4, sca[m]);
							String str = "imgs/Image" + std::to_string(ctr) + ".jpg";
							imwrite(str, a);
							ctr++;
						}
					}
				}
			}
		}
	}
	waitKey(0);
}