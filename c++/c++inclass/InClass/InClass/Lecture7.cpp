//namespace and scoping
/*
namespace <NamespaceName>
{
	<put code for classes or functions here>
}
Can use scoping to specify a namespace to ＆look in＊:
<namespace>::<class>::<function>
e.g. MyNameSpace::MyClass::foo();
<namespace>::<globalfunction>
e.g. MyNameSpace::bar();
*/

#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <fstream>
#include<iostream>
#include <string>
#include <sstream>
using namespace std;//don't need to specify (std::)anymore
	//using std::cin;//don't need to specify (std::cin) anymore but still need (cin)
	//using std::cout;//don't need to specify (std::cin) anymore but still need (cout)
//using namespace cpp;
namespace cpp
{
	int i = 0;
	void myPrint1()
	{
		std::printf("this is myPrint1() in namespcace cpp\n");
	}

	void myPrint2()
	{
		printf("here use muPrint2 to call myPrint1 which are both in namespace \"cpp\":{\n");
		myPrint1();//it can access the function in the same namespace
		printf("}\n");
	}
}

class Ilike
{
public:
	int GetValue() { return m_iValue; }
	void SetValue(int iValue)
	{
		m_iValue = iValue;
	}
	void modify();
private:
	int m_iValue;
	
};

void Ilike::modify() 
{
	printf("asdffadsfaf\n");
}

int nomain(int argc, char** argv)
{
	Ilike fa;
	fa.modify();
	//1.default empty string
	std::string ha;//in stack ha is a pointer
	//2.
	std::string wa("abcdefghijklmnopqrstuvwxyz\n");
	//3.
	const std::string pa("sdfaf");
	std::string ka(pa);
	//4.
	std::string ja = "abcdefghijklmnopqrstuvwxyz\n";
	
	std::printf("%d %d %d\n", sizeof(ha),sizeof(wa),sizeof(ja));
	//string class methods:
	wa.append("fdsa\n");
	string sa = wa.substr(0, 3);
	wa.insert(0, "NIHAIYAOWOZHENGYANG");
	string co = "zfffadsffffadsfaf";
	string no("zfffadsffffadsfaf");
	string ko = co + no;
	printf("%s\n",no.c_str());
	
	if (1)
	{
		printf("%c sadf\n", no[1]);
	}
	/*
	int i;
	int total = 0;
	cout << "Enter your integer1:" << endl;
	cin >> i;
	total = total + i;
	cout << "Enter your integer2:" << endl;
	cin >> i;
	total = total + i;
	cout << "the sum is: " << total;
	*/
	/*
	//to readin
	std::ifstream ifile;
	ifile.open("input_file.txt");
	int a;
	char cs[100];
	string str;
	char c;
	char d;
	ifile >> a;
	ifile >> cs;
	ifile >> str;
	ifile >> c;
	ifile >> d;
	ifile.close();
	
	cout <<"a:"<< a;
	cout << "cs:"<< cs;
	std::cout << "str:"<< str;
	cout << "c:"<< c << endl;
	cout << "d:"<< d;
	
	//to putout
	std::ofstream ofile;
	ofile.open("output_file.txt");
	ofile  << a;
	ofile <<cs;
	ofile <<str;
	ofile <<c;
	ofile <<d;
	ofile.close();
	*/
	
	/*
	string str;
	ifstream file;
	file.open("input_file.txt");
	while (file)
	{
		file >> str;
		cout << str << endl;
	}
	file.close();


	double d;
	std::string line;
	cout << "Please enter a double value:" << endl;
	
	while (!(cin >> d))
	{
		cin.clear();//clear error flag
		std::getline(std::cin,line);//remove bad line
		cout << "what you enter in invalie!" << endl;
		cout << "please reenter a double value:" << endl;
	}
	cout << "What you enter is: " << d;
	cout << "the line: " << line << endl;
	*/
	/*
	  Left of scoping operator is
	每 blank (to access a global variable/function)
	每 class name (to access member of that class)
	每 namespace name (to use that namespace)
	*/
	cout << "kkkkkkkkkkkkkkkkkkkkkkkkkkk" << endl;
	stringstream strstream;
	string str;
	short year = 1996;
	short month = 7;
	short day = 28;

	strstream << year << "/";
	strstream << month << "/";
	strstream << day;
	strstream >> str;
	cout << "date:" << str << endl;
	string haliluya = "asdfaf";
	printf("%d %d\n", haliluya.size(), haliluya.length());
	
	cpp::myPrint1();
	//cpp::myPrint1();
	//cpp::myPrint2();
	







	//--------------------------------------------- Standard class library classes--------------------------
	//The string class is in the std namespace
	/*
	Three of the string constructors :
	string();
	  1.Default empty string
		string(const char* str);
	  2.From a char* type string
		string(const string& str);
	  3.From another string 每 the copy constructor
	*/

















	/*
	std::string s1("Test string");//Lowercase ＆s＊ on the class name (＆string＊, not ＆String＊)
	//s1.append("hakl");
	int i = 0;
	cout << "Enter a value................";
	cin >> i;
	cout << s1 << endl;
	printf("%s\n",s1.c_str());//s1.c_str() convert a string to char*
	//cin >> sin;
	*/
	getchar();
	return 0;
}