#include "header.h"

// My header file:
#include "MyDemoA.h"

#include <ctime>
#include "templates.h"

// Needs one of the following #includes, to include the class definition
#include "SimpleDemo.h"
#include "BouncingBallMain.h"
#include "MazeDemoMain.h"
#include "DraggingDemo.h"
#include "ZoomingDemo.h"
#include "PlayingCardsDemo.h"
#include "ImageObjectDemo.h"

// MY HEADER FILE:
#include "JasonsDemoA.h"


const int BaseScreenWidth = 800;
const int BaseScreenHeight = 600;


int main(int argc, char *argv[])
{
	int iResult;

	// Send random number generator with current time
	::srand(time(0));

	// Needs just one of the following lines - choose which object to create.
	// Note these are from simplest to most complex demo.
	//JasonsDemoA oMain; // Jason's version of MyDemoA, MyObjectA and MyTileManagerA
	MyDemoA oMain;
	//SimpleDemo oMain;
	//ImageObjectDemo oMain; // Shows drawing images to the foreground and background
	//BouncingBallMain oMain; // A ball bouncing around with images and shapes drawn
	//MazeDemoMain oMain; // Demonstrates a tile manager being used and updated
	//DraggingDemo oMain; // Includes dragable images and image objects
	//ZoomingDemo oMain;	// Shows the use of a filter to shift and rescale the display - this is complex and you can ignore it!
	//PlayingCardsDemo oMain; // The most advanced demo - you may want to ignore this one totally!
	
	
	
	
	
	char buf[1024];
	sprintf( buf, "My Demonstration Program : Size %d x %d", BaseScreenWidth, BaseScreenHeight);
	iResult = oMain.initialise( buf, BaseScreenWidth, BaseScreenHeight, "Cornerstone Regular.ttf", 24 );
	iResult = oMain.mainLoop();
	oMain.deinitialise();
	 
	return iResult;
	
}
