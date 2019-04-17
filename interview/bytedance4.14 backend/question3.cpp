#include <iostream>
#include <cstdio>
#include <vector>
#include <cmath>

/*
3
1 6 4

3
*/
int main()
{
	using namespace std;
	int n;
	cin >> n;
	int *a = new int[n];
	for (int i = 0; i < n; i++)
	{
		cin >> a[i];
	}
	int t = 0;
	for (int i = n - 1; i >= 0; i--)
	{
		a[i] = ((a[i] + t+1) / 2);
		t = a[i];
	}
	cout << a[0] << endl;
	cin.get();

	
}