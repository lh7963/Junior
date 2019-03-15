/*Lecture8 CLASSES
only use new and delete
*/
#include <fstream>
#include<iostream>
#include <string>
struct Myday
{
	int day;
	int month;
	int year;
};
struct MyStruct
{
	public:
	int ai[4];
	short j;
};
void myfunction()
{
	/*
	malloc
	allocate memory
	new
	1.allcate memory
	2.create the object
	3.call constructor
	*/
	MyStruct* mysPtr = new MyStruct;
	MyStruct* myArrayPtr = new MyStruct[4];
	delete mysPtr;
	delete[] myArrayPtr;
	// ***if point to an array, delete[]
}


//-------------------------structs and classes-------------------------
/*
The difference is (ONLY!!!) in encapsulation
¨C struct defaults to public, class to private

when to use:
if need function: classes
else use struct(struct can also have function, but we just do it in this way)
*/
class BaseClass
{
public:
	int GetValue() { return m_iValue; }
	void SetValue(int iValue)
	{
		m_iValue = iValue;
	}
private:
	int m_iValue;
};//semi-colon at the end

class SubClass : public BaseClass
{
	
};//semi-colon at the end



class DemoClass
{
public:
	//constructor
	DemoClass()
	{ }
	DemoClass(int a)
	{
		m_iValue = a;
	}
	//deconstructor
	~DemoClass()
	{ }
	int GetValue() const { return m_iValue; }
	void SetValue(int iValue) { m_iValue = iValue; }
private:
	int m_iValue;
};


void myfunctiosn()
{
	DemoClass haha;
	/*
	IMPORTANT: Do NOT add empty brackets ()
	when constructing on the stack if there are no
	parameters!
	ie.DemoClass myDemoClass1(); // WRONG!!!
	*/
	DemoClass myDemoClass1(3);//ok!




	//basic types can be initialised in the same way as classes
	int ival = 4;
	int ivalf(4);//in the stack, no worry
	int* pInt = new int;
	int* pInt2 = new int(4);
	int* pIntArray = new int[50];
	delete pInt;
	delete pInt2;
	delete[] pIntArray;
	

}

/*
inline:no function call is made 
inline int max(int a, intb)
{return a>b ? a:b;}
*/

/*
Interface methods can be :
Mutators ¨C change the ¡®state¡¯ of the object
Accessors ¨C only query values, no changes
	   .These should really be ¡®const¡¯ functions, which means that the
		compiler will guarantee they do not alter the state - see lecture 9
*/
class anoBaseClass//default access is private 
{
public://<-keyword


	
	anoBaseClass()//no return value  //default construstor
	{
		str = "kkak";
		std::cout << str << std::endl;
		std::cout << this;
	}
	
	anoBaseClass(const char* anounsement, int iValue = -1)//Default parameters    |Will match any of the following:
																	//|DemoClass myDemoClass3("Temp", 3);
																	//|DemoClass myDemoClass4("Temp");
													//		General C++ rule: if your code introduces ambiguity then it will not compile
	{ 

	}
	anoBaseClass(int iValue, int iValue2)
		: m_iValue(iValue), m_iValue2(m_iValue2) //Initialisation list just define what value should we assign to the data it very first time	
												 /*
														1.use comma to selipreate
														2.m_iValue is initialised with value iValue,same with m_iValue2
														3.then call the code inside the barket
												*/
	{
		
	}
	/*
	anoBaseClass(int iValue, int iValue2,int m)   //m_iValue is created,but not initialised
	{
		str = "fa";
		m_iValue = iValue;				//iValue is assigned to it
		m_iValue2 = iValue2;			// ie. value would be set twice!
	}
	*/
	

	~anoBaseClass()//no return value
	{
		std::cout << "the class is destoryed." << std::endl;
	}
	int GetValue() const //Accessor Access only, no changes Ideally label the function with keyword ¡®const¡¯ (see later lecture for why)
	{ 
		return m_iValue; 
	}
	void SetValue(int iValue) // Mutator. Mutates/changes the object 
	{
		this->m_iValue = iValue;//Member functions can access the data in classes or structs
								//  "this" is a hidden pointer is any member function
	}
	static void getthis()
	{
		std::cout << "this is this:" << 3 << std::endl;
	}
private://<-keyword
	int m_iValue;
	int m_iValue2;
	std::string str;

	
}; //<- sime-colon at the end

class anoSubClass : public anoBaseClass
{
public:
	int init;
};


/*
: inline functions(see later) for methods can ensure
that it is(guaranteed) no slower at runtime to use
accessors than to use the variable names
*/

int mains8(int argc, char* argv)
{
	//create an object in stack:
	anoBaseClass abs;//             <-Create an object on stact, using default constructor.don't use (), otherwise compiler will think it is a funtion declarlation!!!
	anoBaseClass h[5];
	
	//anoBaseClass abs2("Temp");
	//create an object in heap:
	//anoBaseClass* abh = new anoBaseClass();
	//anoBaseClass* abh2 = new anoBaseClass("Temp");
	/*
	anoBaseClass* aasdf2[5];// = new anoBaseClass("Temp");
	aasdf2[0] = new anoBaseClass();
	aasdf2[0]->GetValue();
	int i = abs.GetValue();
	std::cout <<'\n'<<"i = "<< i << std::endl;
	*/
	//Can new/delete basic types
	int* pInt = new int(4);
	int* pIntarray = new int[50];
	delete pInt;
	delete[] pIntarray;

	std::string str;
	std::cin >> str;
	return 0;
}