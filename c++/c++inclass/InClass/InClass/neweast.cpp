#include <string>
#include <vector>
using namespace std;

class Solution {
private:
	bool is_balancedheight(vector<int> v)
	{
		vector<int>* lt;
		vector<int>* rt;
		getlrtree(v, &lt, &rt);
		int lth = tree_height(*lt);
		int rth = tree_height(*rt);
		vector<int>vl = *lt;
		vector<int>vr = *rt;
		delete lt;
		delete rt;
		if (lth - rth > 1 || lth - rth < -1)
		{
			return false;
		}
		else if (lth == 0 || rth == 0)
		{
			return true;
		}
		else
		{
			return is_balancedheight(vl) && is_balancedheight(vr);
		}
	}

	int tree_height(vector<int> t)
	{
		int size = static_cast<int>(t.size());
		if (size == 0)
			return 0;
		else if (size == 1 && t[0] == 0)
			return 0;
		else
		{
			vector<int>* lt;
			vector<int>* rt;
			getlrtree(t, &lt, &rt);

			int lsize = tree_height(*lt);
			int rsize = tree_height(*rt);
			delete lt;
			delete rt;
			return (lsize > rsize) ? (lsize + 1) : (rsize + 1);
		}
	}

	void  getlrtree(vector<int> a, vector<int>** lt, vector<int>** rt)
	{
		int len = static_cast<int>(a.size());
		vector<int>*lefttree = new vector<int>(0);
		vector<int>*righttree = new vector<int>(0);

		int m = 1;
		int i = 1;
		while (i <= len)
		{
			int flag = 0;
			int j = i;
			for (; j < i + m; j++)
			{
				if (j >= len)
				{
					flag = 1;
					break;
				}
				(*lefttree).push_back(a[j]);
			}
			for (; j < i + m + m; j++)
			{
				if (j >= len)
				{
					flag = 1;
					break;
				}
				(*righttree).push_back(a[j]);
			}
			if (flag)
				break;
			i = i + m + m;
			m = m * 2;
		}
		*lt = lefttree;
		*rt = righttree;
	}

public:
	//entry for the question1
	bool start(int* arr, int len)
	{
		vector<int> v;
		for (int i = 0; i < len; i++)
		{
			v.push_back(arr[i]);
		}
		return is_balancedheight(v);
	}

	

	//question2
	int longestMountain(std::vector<int>& A)
	{
		int max = 0;
		int size = static_cast<int>(A.size());
		for (int i = 0; i < size; i++)
		{
			if (size - i <= max || size - i < 3)
			{
				return max;
			}
			if (A[i] >= A[i + 1])
			{
				continue;
			}

			int j;
			for (j = i; j < size; j++)
			{
				if (j == size - 1)
				{
					return max;
				}
				if (A[j] >= A[j + 1])
				{
					break;
				}
			}
			if (A[j] == A[j + 1])
			{
				i = j + 1;
				continue;
			}
			else//A[j] > A[j+1]
			{
				for (; j < size; j++)
				{
					if (j == size - 1 || A[j] <= A[j + 1])
					{
						max = max > j - i + 1 ? max : j - i + 1;
						break;
					}
				}
				i = j + 1;
			}
		}
		return max;

	}

	//question3
	bool isMatch(std::string s, std::string p)
	{
		vector< pair<char, vector<int> > >transfer;

		for (unsigned int i = 0; i < p.length(); i++)
		{

			if (p[i] == '*')
			{
				vector<int>k;
				k.push_back(i);
				k.push_back(i + 1);
				transfer.push_back(make_pair('*', k));
			}
			else
			{
				vector<int>k;
				k.push_back(i + 1);
				transfer.push_back(make_pair(p[i], k));
			}
		}
		vector<int>k;
		transfer.push_back(make_pair('!', k));

		vector<int>state;
		state.push_back(0);
		if (p[0] == '*')
			state.push_back(1);
		for (int i = 0; i < s.length(); i++)
		{
			int statesize = static_cast<int>(state.size());
			if (statesize == 0)
				break;
			char c = s[i];
			vector<int>temp;
			for (vector<int>::iterator it = state.begin(); it != state.end(); ++it)
			{
				pair<char, vector<int>> pa = transfer[*it];
				if (pa.first == '!')
				{
					continue;
				}
				if (pa.first == '*' || pa.first == '?' || pa.first == c)
				{
					for (vector<int>::iterator iit = pa.second.begin(); iit != pa.second.end(); ++iit)
					{
						int m = 0;
						for (vector<int>::iterator tit = temp.begin(); tit != temp.end(); ++tit)
						{
							if (*iit == *tit)
							{
								m = 1;
								break;
							}
						}
						if (m == 0)
						{
							temp.push_back(*iit);
						}
					}
				}
			}
			state = temp;
		}
		for (vector<int>::iterator it = state.begin(); it != state.end(); ++it)
		{
			if (*it == p.length())
				return true;
		}
		return false;
	}
};
//answer for question4 and question5 are specified in Test.docx
