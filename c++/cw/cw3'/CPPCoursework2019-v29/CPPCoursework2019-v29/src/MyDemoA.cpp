#include "header.h"
#include "MyDemoA.h"



MyDemoA::MyDemoA()
{
}


MyDemoA::~MyDemoA()
{
}


void MyDemoA::virtSetupBackgroundBuffer()
{
	fillBackground(0x000000);
	for (int iX = 0; iX < getWindowWidth(); iX++)
		for (int iY = 0; iY < this->getWindowHeight(); iY++)
			switch (rand() % 100)
			{
			case 0: setBackgroundPixel(iX, iY, 0xFF0000); break;	//red
			case 1: setBackgroundPixel(iX, iY, 0x00FF00); break;	//green
			case 2: setBackgroundPixel(iX, iY, 0x0000FF); break;	//blue
			case 3: setBackgroundPixel(iX, iY, 0xFFFF00); break;	//yellow
			case 4: setBackgroundPixel(iX, iY, 0x00FFFF); break;	//aqua
			case 5: setBackgroundPixel(iX, iY, 0xFF00FF); break;	//pink
			}
	
	for (int i = 0; i < 15; i++)
		for (int j = 0; j < 15; j++)
			tm.setMapValue(i, j, rand());
	tm.setTopLeftPositionOnScreen(50, 50);
	tm.drawAllTiles(this, getBackgroundSurface());
}


/*
void MyDemoA::virtMouseDown(int iButton, int iX, int iY)
{
	printf("Mouse clicked at %d %d\n", iX, iY);
	if (iButton == SDL_BUTTON_LEFT)
	{
		drawForegroundRectangle(iX - 10, iY - 10, iX + 10, iY + 10, 0xff0000);
		
		void drawForegroundRectangle(int iVirtualX1, int iVirtualY1, int iVirtualX2, int iVirtualY2, unsigned int uiColour)
		void drawForegroundOval(int iVirtualX1, int iVirtualY1, int iVirtualX2, int iVirtualY2, unsigned int uiColour)
		void drawForegroundPolygon( double fX1, double fY1, double fX2, double fY2,
		double fX3, double fY3, double fX4, double fY4, unsigned int uiColour )
		

		redrawDisplay(); // Force background to be redrawn to foreground
	}
}
*/
/*
void MyDemoA::virtMouseDown(int iButton, int iX, int iY)
{
	printf("Mouse clicked at %d %d\n", iX, iY);
	if (iButton == SDL_BUTTON_LEFT)
	{
		drawBackgroundRectangle(iX - 10, iY - 10, iX + 10, iY + 10, 0xff0000);
		redrawDisplay(); // Force background to be redrawn to foreground
	}
}
*/
			//virtKeyUp
void MyDemoA::virtKeyDown(int iKeyCode)
{
	switch (iKeyCode)  //See  http://wiki.libsdl.org/moin.cgi/SDLKeycodeLookup
	{
	case ' ':
		virtSetupBackgroundBuffer();
		redrawDisplay();
		break;
	}
}void MyDemoA::virtMouseDown(int iButton, int iX, int iY)
{
	printf("Mouse clicked at %d %d\n", iX, iY);
	if (iButton == SDL_BUTTON_LEFT)
	{
		//drawBackgroundRectangle(iX - 10, iY - 10, iX + 10, iY + 10, 0xff0000);
		if (tm.isValidTilePosition(iX, iY)) // Clicked within tiles?
		{
			int mapX = tm.getMapXForScreenX(iX); // Which column?
			int mapY = tm.getMapYForScreenY(iY); // Which row?
			int value = tm.getMapValue(mapX, mapY); // Current value?
			tm.setAndRedrawMapValueAt(mapX, mapY, value + 1, this, getBackgroundSurface()
			);
		}
		redrawDisplay(); // Force background to be redrawn to foreground
	}
	else if (iButton == SDL_BUTTON_RIGHT)
	{
		drawBackgroundOval(iX - 10, iY - 10, iX + 10, iY + 10, 0x0000ff);
		redrawDisplay(); // Force background to be redrawn to foreground
	}
}