#include <iostream>
#include <fstream>
#include <vector>
#include <string>
using namespace std;

vector<vector<int>> input()
{
	vector<vector<int>>v;
	while (1)
	{
		char ch = cin.peek();
		if (ch == '\n')
			break;
		vector<int> temp;
		while (cin.get(ch))
		{
			
			if (ch == '0' || ch == '1' || ch == '2')
			{
				temp.push_back(ch - '0');
			}
			if (ch == '\n')
			{
				v.push_back(temp);
				break;
			}
		}
	}
	return v;
}

void show(vector<vector<int>> v)
{
	for (int i = 0; i < v.size(); i++)
	{
		for (int j = 0; j < v[i].size(); j++)
		{
			cout << v[i][j] << " ";
		}
		cout << endl;
	}
}

bool getre(vector<vector<int>> v)
{
	int flag;
	int h = v.size()-1;
	if (h == 0)
		return true;
	int w = v[0].size()-1;
	
	vector<vector<int>> temp = v;
	do
	{
		flag = 0;
		for (int i = 0; i < v.size(); i++)
		{
			for (int j = 0; j < v[i].size(); j++)
			{
				bool up = false;
				bool down = false;
				bool left = false;
				bool right = false;
				if (v[i][j] == 1)
				{
					if (i != 0)
						if(v[i - 1][j] == 2)
							up = true;
					if (j != 0)
						if (v[i][j - 1] == 2)
							left = true;
					if (j != w)
						if (v[i][j + 1] == 2)
							right = true;
					if (i != h)
						if (v[i + 1][j] == 2)
							down = true;
					if (up || left || right || down)
					{
						temp[i][j] = 2;
						flag = 1;
					}
				}
			}
		}
		v = temp;
	} while (flag == 1);
	for (int i = 0; i < v.size(); i++)
	{
		for (int j = 0; j < v[i].size(); j++)
		{
			if (v[i][j] == 1)
				return false;
		}
	}
	return true;
}


int main()
{
	vector<vector<int>> matrix = input();
	cout << getre(matrix);
	string str;
	cin >> str;
}