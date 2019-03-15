#include <string>
#include <iostream>

void foo(const int& x, const int y)
{
	int& xr = const_cast<int&>(x);
	// Since we cast away const-ness we CAN do this
	xr = 5;
	// or this
	int yr = const_cast<int&>(y);
	
}



int mainas(int argc, char* argv)
{
	int i = 3;
	int& p = const_cast<int&>(i);
	
	double d = static_cast<double>(i);

}