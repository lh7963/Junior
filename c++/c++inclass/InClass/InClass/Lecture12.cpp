#include <string>
#include <iostream>

class AT
{
public:
	int i = 3;
	virtual void fun1() { std::cout << "A1" << std::endl; };
	void fun2() { std::cout << "A2" << std::endl; };
};

class BT : public AT
{
public:
	void fun1() { std::cout << "B1" << std::endl; };
	
};

int Do10(int(*func)(int))
{
	int tot = 0;
	for (int i = 0; i < 10; i++)
	{
		tot += func(i);
	}
	return tot;
}

int functi(int x)
{
	std::cout << "x: " << x << std::endl;
	return x;
}

class test
{
public:
	test()
		:i(5),j(5)
	{

	}
	const int i;
	const int j;
};

class MyClass
{
public:
	int num1;
	int num2;
	// Constructor
	MyClass()
	{
		num1 = 3;
		num2 = 4;
	}
	// Destructor
	~MyClass()
	{
	}
	// Copy constructor
	MyClass(const MyClass& rhs)
		:num1(5),num2(6)
	{
	
	}
	// Assignment operator
	
	MyClass& operator=(
		const MyClass& rhs)
	{
		// Assign each member
		num1 = rhs.num1;
		num2 = rhs.num2;
		return *this;
	}
	
};

int mainas(int argc, char* argv)
{
	MyClass mc1;
	MyClass mc2;
	mc2 = mc1;
	std::cout << mc1.num1 << std::endl;
	std::cout << mc1.num1 << std::endl;
	AT nono;
	const AT &rno = nono;
	nono.i = 4;
	BT fu;

	const AT *pno = &nono;
	nono.i = 4;
	//(*pno).i = 5;

	test tadsf;
	


	AT *haha = &fu;
	
	haha->fun1();
	fu.fun2();
	int(*f)(int) = functi;
	int total = Do10(f);
	std::cout << "total: " << total << std::endl;

	int(**fptr)(int);
	int(*fptrarrat[5])(int) ;
	std:: string str;
	std::cin >> str;
}