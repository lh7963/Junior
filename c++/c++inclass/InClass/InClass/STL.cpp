#include <iostream>
#include <string>
#include <vector>
using namespace std;
int maisn()
{
	vector<char> v(10);
	int size = v.size(); // Can ask for size
	cout << "Size is: " << size << endl;
	// Set each value, using []
	for (unsigned int i = 0; i < size; i++)
		v[i] = 'a' + i;
	v.push_back('z'); // Append to the end
	v.push_back('y');
	// Output the contents
	size = v.size();
	cout << "Size is: " << size << endl;
	for (int i = 0; i < v.size(); i++)
		cout << v[i] ;

	string temp;
	cin >> temp; // Wait before closing
	return 0;
}