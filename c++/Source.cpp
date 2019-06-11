#include <iostream>
namespace hl
{
	void insertion_sort(int* arr, long len) {
		for (int j = 1; j < len; j++)
		{
			int i = j - 1;
			int temp = arr[j];
			while (i >= 0 && arr[i] > temp)
			{
				arr[i + 1] = arr[i];
				i--;
			}
			arr[i + 1] = temp;
		}
	}
}


int main()
{
	using namespace std;
	int arr[] = { 5,2,4,6,1,3 };
	hl::insertion_sort(arr, sizeof(arr) / sizeof(*arr));
	for (int i = 0; i < sizeof(arr) / sizeof(*arr); i++)
	{
		cout << arr[i] << ' ';
	}
	cin.get();
}