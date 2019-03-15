#include <fstream>
#include <iostream>
#include <string>
#include "test.h"
#include <vector>
using namespace std;

int MyClass::var = 15;
void MyClass::foo()
{

}

class A
{
public: 
	 virtual void hello() 
	 { 
		 std::cout << "I'm A" << std::endl;
	 }
	 // char const* bar() { return "BaseBar"; }
};

class B : public A
{
public:
	void hello()
	{
		std::cout << "I'm B" << std::endl;
	}
	// char const* bar() { return "BaseBar"; }
};

class C : public B
{
public:
	void hello()
	{
		std::cout << "I'm C" << std::endl;
	}
	// char const* bar() { return "BaseBar"; }
};



int mains(int argc, char* argv)
{
	
	
	B sb1;
	A* a_ptr = &sb1;
	a_ptr->hello();
	int i = 0;
	return 0;
	/*
	int i = 2;
	int&j = i;
	j = 4;
	int* pi = &i;

	MyClass mc(5);
	MyClass mcs(5);
	MyClass const* p = &mc;
	p = &mcs;
	std::string str = "adsf";
	std::string const * sp = &str;
	str[0] = 'f';
	std::string str2 = "adsfadsf";
	sp = &str2;



	std::cout << str;
	std::string strs;
	std::cin >> strs;
	*/

}
