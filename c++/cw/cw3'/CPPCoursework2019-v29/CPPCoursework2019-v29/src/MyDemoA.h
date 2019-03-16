#include "BaseEngine.h"
#include "MyTilemanager.h"

class MyDemoA :
	public BaseEngine
{
public:
	MyDemoA();
	~MyDemoA();
	void virtSetupBackgroundBuffer();
	void virtMouseDown(int iButton, int iX, int iY);
	void virtKeyDown(int iKeyCode);

protected:
	MyTileManager tm;
};

