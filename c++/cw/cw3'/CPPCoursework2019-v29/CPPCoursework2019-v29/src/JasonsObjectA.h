#pragma once
#include "DisplayableObject.h"

class JasonsObjectA :
	public DisplayableObject
{
public:
	JasonsObjectA(BaseEngine* pEngine);
	~JasonsObjectA();

	bool deleteOnRemoval() { return false; }
	void virtDraw();
	void virtDoUpdate(int iCurrentTime);
};

