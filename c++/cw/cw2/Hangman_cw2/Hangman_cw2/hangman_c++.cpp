#define _CRT_SECURE_NO_WARNINGS
#include <ctime>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
using namespace std;
bool isavailiale(string* str, char c)
{
	
	if ((*str)[c - 'a'] == '.')
	{
		return false;
	}
	(*str)[c - 'a'] = '.';
	return true;
}

bool isintheword(string str, char c)
{
	bool temp = false;
	for (unsigned int i = 0; i < str.length(); i++)
	{
		if (str[i] == c)
		{
			return true;
		}
	}
	return false;
}

int main(int argc, char* argv[])
{
	ifstream file;
	srand((unsigned int)time(nullptr));
	if (argc < 2)
	{
		file.open("wordlist.txt");
	}
	else
	{
		file.open(argv[1]);
		if (!file)
		{
			cout << "Failed to open file " << argv[1] << endl;
			string wait;
			cin >> wait;
			return 0;
		}
	}
	vector<string> arrWordList;
	string temp;
	int iWordCount = 0;
	while (file >> temp)
	{
		arrWordList.push_back(temp);
		iWordCount++;
	}
	
	arrWordList.pop_back();

	while (1)
	{
		int iWrongGuessesLeft = 8;
		int iTargetWordNumber = rand() % iWordCount;
		string pCurrentWord = arrWordList[iTargetWordNumber];
		int iWordLength = pCurrentWord.length();
		string arrLetters = "abcdefghijklmnopqrstuvwxyz";
		string pBlankWord = pCurrentWord;
		for (int i = 0; i < iWordLength; i++)
		{
			pBlankWord[i] = '-';
		}
		int iLettersGuessed = 0;
		
		while (1)
		{
			cout << "\nGuess a letter for the word:\'" << pBlankWord << "\'\n";
			cout << "You have " << iWrongGuessesLeft << " wrong guesses left, and have guessed " << iLettersGuessed << " letters out of " << iWordLength << " so far.\n";
			cout << "Available letters are: " << arrLetters << "\n";

			char c;
			bool again = true;
			do
			{
				cout << "Enter your guess:";
				do
				{
					cin >> c;
				}while(c == '\n');
				c = tolower(c);
				if (c<'a' || c>'z')
				{
					cout << "\'" << c << "\' is not a valid letter! Try again.\n";
				}
				else
					again = false;
			} while (again);
			if (!isavailiale(&arrLetters, c))
			{//already guessed
				printf("\n!!! You already tried \'%c\' !!!\n", c);
			}
			else if (isintheword(pCurrentWord, c))
			{//guess right
				for (int i = 0; i < iWordLength; i++)
				{
					if (pCurrentWord[i] == c)
					{
						iLettersGuessed++;
						pBlankWord[i] = c;
					}
				}
				cout << "\n*** Correct guess - \'" << c << "\' IS in the word ***\n";
				if (iLettersGuessed == iWordLength)
				{
					cout << "\nWell done! The word was '" << pBlankWord << "'. \nYou finished with " << iWrongGuessesLeft << " wrong guesses left.\n";
					break;
				}
			}
			else
			{
				cout << "\n!!! Wrong guess - \'" << c << "\' is not in the word !!!\n";
				iWrongGuessesLeft--;
			}
			if (iWrongGuessesLeft == 0)
			{
				cout << "\nYou failed. The word was '"<<pCurrentWord<<"'\n";
				break;
			}
		}
		cout << "Try again?[Y=yes/N=no]\n";
		char replay;
		do
		{
			cin >> replay;
		} while (replay == '\n');
		replay = tolower(replay);
		if (replay == 'n')
			return 0;
	}
}