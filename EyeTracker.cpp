// EyeTracker.cpp : Defines the entry point for the console application.
//
// SampleEyeXApp.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#define TX_NODEBUGOBJECT
#include <Windows.h>
#include <stdio.h>
#include <conio.h>
#include <assert.h>
#include <fstream>
#include <iostream>
#include <vector>
#include "eyex/EyeX.h"
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/core/core.hpp>
#include <string.h>


using namespace std;
using namespace cv;

Mat img;
Mat imgarr[30];
Mat imgb;
Mat scaleFactor;
Point cur_pt = Point(0, 0);
Point last_pt = Point(0, 0);
int scale_inc;
ofstream out_file;
vector< Point > pts;
vector< float > tms;
float lastTime;

#pragma comment (lib, "Tobii.EyeX.Client.lib")

// ID of the global interactor that provides our data stream; must be unique within the application.
static const TX_STRING InteractorId = "Twilight Sparkle";

// global variables
static TX_HANDLE g_hGlobalInteractorSnapshot = TX_EMPTY_HANDLE;

/*
* Initializes g_hGlobalInteractorSnapshot with an interactor that has the Gaze Point behavior.
*/
BOOL InitializeGlobalInteractorSnapshot(TX_CONTEXTHANDLE hContext)
{
	TX_HANDLE hInteractor = TX_EMPTY_HANDLE;
	TX_GAZEPOINTDATAPARAMS params = { TX_GAZEPOINTDATAMODE_LIGHTLYFILTERED };
	BOOL success;

	success = txCreateGlobalInteractorSnapshot(
		hContext,
		InteractorId,
		&g_hGlobalInteractorSnapshot,
		&hInteractor) == TX_RESULT_OK;
	success &= txCreateGazePointDataBehavior(hInteractor, &params) == TX_RESULT_OK;

	txReleaseObject(&hInteractor);

	return success;
}

/*
* Callback function invoked when a snapshot has been committed.
*/
void TX_CALLCONVENTION OnSnapshotCommitted(TX_CONSTHANDLE hAsyncData, TX_USERPARAM param)
{
	// check the result code using an assertion.
	// this will catch validation errors and runtime errors in debug builds. in release builds it won't do anything.

	TX_RESULT result = TX_RESULT_UNKNOWN;
	txGetAsyncDataResultCode(hAsyncData, &result);
	assert(result == TX_RESULT_OK || result == TX_RESULT_CANCELLED);
}

/*
* Callback function invoked when the status of the connection to the EyeX Engine has changed.
*/
void TX_CALLCONVENTION OnEngineConnectionStateChanged(TX_CONNECTIONSTATE connectionState, TX_USERPARAM userParam)
{
	switch (connectionState) {
	case TX_CONNECTIONSTATE_CONNECTED: {
										   BOOL success;
										   printf("The connection state is now CONNECTED (We are connected to the EyeX Engine)\n");
										   // commit the snapshot with the global interactor as soon as the connection to the engine is established.
										   // (it cannot be done earlier because committing means "send to the engine".)
										   success = txCommitSnapshotAsync(g_hGlobalInteractorSnapshot, OnSnapshotCommitted, NULL) == TX_RESULT_OK;
										   if (!success) {
											   printf("Failed to initialize the data stream.\n");
										   }
										   else {
											   printf("Waiting for gaze data to start streaming...\n");
										   }
	}
		break;

	case TX_CONNECTIONSTATE_DISCONNECTED:
		printf("The connection state is now DISCONNECTED (We are disconnected from the EyeX Engine)\n");
		break;

	case TX_CONNECTIONSTATE_TRYINGTOCONNECT:
		printf("The connection state is now TRYINGTOCONNECT (We are trying to connect to the EyeX Engine)\n");
		break;

	case TX_CONNECTIONSTATE_SERVERVERSIONTOOLOW:
		printf("The connection state is now SERVER_VERSION_TOO_LOW: this application requires a more recent version of the EyeX Engine to run.\n");
		break;

	case TX_CONNECTIONSTATE_SERVERVERSIONTOOHIGH:
		printf("The connection state is now SERVER_VERSION_TOO_HIGH: this application requires an older version of the EyeX Engine to run.\n");
		break;
	}
}

int getd2(int x2, int y2, int x1, int y1) {
	float dx = (x2 - x1);
	float dy = (y2 - y1);
	return dx*dx + dy*dy;
}

float timeSum = 0;
bool doneReading;

/*
* Handles an event from the Gaze Point data stream.
*/
void OnGazeDataEvent(TX_HANDLE hGazeDataBehavior)
{
	TX_GAZEPOINTDATAEVENTPARAMS eventParams;
	if (txGetGazePointDataEventParams(hGazeDataBehavior, &eventParams) == TX_RESULT_OK) {
		cur_pt.x = eventParams.X;
		cur_pt.y = eventParams.Y;
		pts.emplace_back(cur_pt);

		tms.emplace_back(eventParams.Timestamp);

		printf("Gaze Data: (%.1f, %.1f); timestamp %.0f ms\n", eventParams.X, eventParams.Y, eventParams.Timestamp);
		double dt = eventParams.Timestamp - lastTime;//exposure time
		if (lastTime >=0){
			out_file << cur_pt.x << "," << cur_pt.y << "," << dt << endl;//csv format (x,y,dt)
			timeSum += dt;
		}

		if (!doneReading){
			lastTime = eventParams.Timestamp;
			last_pt.x = eventParams.X;
			last_pt.y = eventParams.Y;
		}
	}
	else {
		printf("Failed to interpret gaze data event packet.\n");
	}
}

/*
* Callback function invoked when an event has been received from the EyeX Engine.
*/
void TX_CALLCONVENTION HandleEvent(TX_CONSTHANDLE hAsyncData, TX_USERPARAM userParam)
{
	TX_HANDLE hEvent = TX_EMPTY_HANDLE;
	TX_HANDLE hBehavior = TX_EMPTY_HANDLE;

	txGetAsyncDataContent(hAsyncData, &hEvent);

	// NOTE. Uncomment the following line of code to view the event object.
	//The same function can be used with any interaction object.
	//OutputDebugStringA(txDebugObject(hEvent));

	if (txGetEventBehavior(hEvent, &hBehavior, TX_BEHAVIORTYPE_GAZEPOINTDATA) == TX_RESULT_OK) {
		OnGazeDataEvent(hBehavior);
		txReleaseObject(&hBehavior);
	}
	
	txReleaseObject(&hEvent);
}

bool inImg(int x, int y) {//checks if x,y is inside the image
	if ((x >= 0) && (x < img.cols) && (y >= 0) && (y < img.rows))
		return true;
	return false;
}

#include <time.h>
#include <direct.h>

const double FRAME_TIME = 3.000;
const double BLACK_TIME = 1.000;

const int PERSON_ID = 234;//increment counter for every person
const int SETID = PERSON_ID % 4;//set id

//Random partitioning of image ids...Any random partition can be used.
vector<int> sets[] = {
	{ 12, 1, 56, 49, 102, 101, 36, 86, 29, 45, 65, 46, 32, 68, 82, 51, 96, 54, 103, 17, 8, 47, 22, 34, 104, 7, 110, 94, 89, 115 },
	{ 112, 52, 42, 35, 113, 58, 25, 3, 107, 16, 70, 99, 14, 93, 24, 71, 83, 88, 20, 72, 63, 33, 21, 28, 41, 91, 109, 77, 85, 61 },
	{ 114, 78, 66, 108, 5, 18, 23, 106, 76, 73, 74, 15, 119, 111, 92, 38, 40, 81, 55, 64, 11, 39, 62, 53, 9, 59, 100, 44, 19, 79 },
	{ 48, 60, 75, 13, 80, 67, 26, 30, 57, 118, 31, 116, 0, 90, 97, 87, 50, 69, 10, 84, 6, 43, 2, 95, 98, 117, 27, 4, 37, 105 }
};

/*
* Application entry point.
*/
int main(int argc, char* argv[])
{
	//out_file.open("data.csv");
	TX_CONTEXTHANDLE hContext = TX_EMPTY_HANDLE;
	TX_TICKET hConnectionStateChangedTicket = TX_INVALID_TICKET;
	TX_TICKET hEventHandlerTicket = TX_INVALID_TICKET;
	BOOL success;
	const char* window = "IMG";
	namedWindow(window, WINDOW_AUTOSIZE/*CV_WINDOW_NORMAL*/);
	setWindowProperty(window, CV_WND_PROP_FULLSCREEN, CV_WINDOW_FULLSCREEN);

	string s;
	//images that are required
	for (int i = 0; i < 30; i++){
		s = "C:\\Users\\Administrator\\Documents\\visual studio 2013\\Projects\\EyeTracker\\EyeTracker\\images\\Image"
			+ std::to_string(sets[SETID][i]) + ".jpg";
		imgarr[i] = imread(s, 1);
	}
	imgb = Mat(600, 600, CV_8UC1, Scalar(0));

	//img = imread("C:\\Users\\Administrator\\Documents\\Visual Studio 2013\\Projects\\EyeTracker\\EyeTracker\\abc.jpg", 1);

	scaleFactor = Mat(img.rows, img.cols, CV_8UC1, Scalar(0));
	// initialize and enable the context that is our link to the EyeX Engine.
	success = txInitializeEyeX(TX_EYEXCOMPONENTOVERRIDEFLAG_NONE, NULL, NULL, NULL, NULL) == TX_RESULT_OK;
	success &= txCreateContext(&hContext, TX_FALSE) == TX_RESULT_OK;
	success &= InitializeGlobalInteractorSnapshot(hContext);
	success &= txRegisterConnectionStateChangedHandler(hContext, &hConnectionStateChangedTicket, OnEngineConnectionStateChanged, NULL) == TX_RESULT_OK;
	success &= txRegisterEventHandler(hContext, &hEventHandlerTicket, HandleEvent, NULL) == TX_RESULT_OK;
	success &= txEnableConnection(hContext) == TX_RESULT_OK;

	// let the events flow until a key is pressed.
	if (success) {
		printf("Initialization was successful.\n");
	}
	else {
		printf("Initialization failed.\n");
	}

	//Replace this with your directory
	string folderName = "C:\\Users\\Administrator\\Documents\\visual studio 2013\\Projects\\EyeTracker\\EyeTracker\\csv\\User" +
		std::to_string(PERSON_ID);

	int r1 = 10, r2 = 25, r3 = 50;

	for (int frame_count = 0; frame_count < 30; frame_count++){//slide show of 30 frames.
		_mkdir(folderName.c_str());
		out_file.open(
			"C:\\Users\\Administrator\\Documents\\visual studio 2013\\Projects\\EyeTracker\\EyeTracker\\csv\\User" +
			std::to_string(PERSON_ID) +
			"\\Image" + std::to_string(sets[SETID][frame_count]) + ".csv"
			);

		time_t start = clock();
		timeSum = 0;
		lastTime = -1;//just the initial flag
		doneReading = false;

		while ((clock() - start) / (CLOCKS_PER_SEC) <= FRAME_TIME)
		{
			if (waitKey(30) > 0) {
				break;
			}
			Mat img1 = imgarr[frame_count].clone();
			//comment out to hide red dot
			circle(img1, cur_pt, 15, Scalar(0, 0, 255), -1, 8, 0);
			imshow(window, img1);

			int w = 50;
			for (int i = cur_pt.x - w; i <= cur_pt.x + w; i++) {
				for (int j = cur_pt.y - w; j <= cur_pt.y + w; j++) {
					if (inImg(i, j)){
						//std::cerr << cur_pt.x+i << ',' << cur_pt.y+j << endl;
						int scale = (int)scaleFactor.at<uchar>(j, i);
						if (getd2(cur_pt.x, cur_pt.y, i, j) <= r1*r1){
							scale_inc = 15;
							if (scale + scale_inc < 255)scaleFactor.at<uchar>(j, i) = scale + scale_inc;
						}
						else if (getd2(cur_pt.x, cur_pt.y, i, j) <= r2*r2){
							scale_inc = 12;
							if (scale + scale_inc < 255)scaleFactor.at<uchar>(j, i) = scale + scale_inc;
						}
						else if (getd2(cur_pt.x, cur_pt.y, i, j) <= r3*r3){
							scale_inc = 8;
							if (scale + scale_inc < 255)scaleFactor.at<uchar>(j, i) = scale + scale_inc;
						}
					}
				}
			}

		}
		doneReading = true;//

		start = clock();
		while ((clock() - start) / (CLOCKS_PER_SEC) <= BLACK_TIME)
		{
			if (waitKey(30) > 0) {
				break;
			}
			imshow(window, imgb);
		}

		out_file.close();

		cerr << " Total : " << timeSum << endl;
	}

	/*Uncomment for generating heatmap*/
	Mat heatmap = Mat(img.rows, img.cols, CV_8UC3, Scalar(0, 0, 0));
	for (int i = 0; i < img.cols; i++) {
		for (int j = 0; j < img.rows; j++) {
			int scale = (int)scaleFactor.at<uchar>(j, i);
			if (scale == 0) scale = 10;
			if (scale < 100) {
				heatmap.at<Vec3b>(j, i)[2] = 0;
				heatmap.at<Vec3b>(j, i)[1] = scale;
				heatmap.at<Vec3b>(j, i)[0] = 0;
			}
			else if (scale >= 100 && scale < 200) {
				heatmap.at<Vec3b>(j, i)[2] = scale;
				heatmap.at<Vec3b>(j, i)[1] = scale;
				heatmap.at<Vec3b>(j, i)[0] = 0;
			}
			else {
				heatmap.at<Vec3b>(j, i)[2] = scale;
				heatmap.at<Vec3b>(j, i)[1] = 0;
				heatmap.at<Vec3b>(j, i)[0] = 0;
			}

		}
	}

	//imwrite("scalefactor.jpg", scaleFactor);
	imwrite("heatmap.jpg", heatmap);

	for (int i = 1; i < pts.size(); i++) {//build gaze pattern
		line(img, pts[i], pts[i - 1], Scalar(0, 0, 255), 2, 8, 0);
	}
	imwrite("gaze_pattern.jpg", img);
	//printf("Press any key to exit...\n");_getch();

	printf("Exiting.\n");
	// disable and delete the context.
	txDisableConnection(hContext);
	txReleaseObject(&g_hGlobalInteractorSnapshot);
	success = txShutdownContext(hContext, TX_CLEANUPTIMEOUT_DEFAULT, TX_FALSE) == TX_RESULT_OK;
	success &= txReleaseContext(&hContext) == TX_RESULT_OK;
	success &= txUninitializeEyeX() == TX_RESULT_OK;
	if (!success) {
		printf("EyeX could not be shut down cleanly. Did you remember to release all handles?\n");
	}

	return 0;
}