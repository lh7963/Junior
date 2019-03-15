
#include "cstdio"
#include "cstring"
#include "cstdlib" 
#include <ctime>
#include <ctype.h>

bool isavailiales(char* str, char c)
{
	if (str[c - 'a'] == '.')
	{
		return false;
	}
	str[c - 'a'] = '.';
	return true;
}

bool isinthewords(const char* str, char c)
{
	bool temp = false;
	for (signed int i = 0; i < (signed)strlen(str); i++)
	{
		if (str[i] == c)
		{
			return true;
		}
	}
	return false;
}

int mains(int argc, char* argv[])
{
	if (argc < 2)
	{
		srand((unsigned int)time(nullptr));
	}
	else
	{
		srand(atoi(argv[1]));
	}
	const char* arrWordList[] = { "multiplie", "pluse", "minuse", "divide", "moduloe" };//array, store the pointers
	const int iWordCount = sizeof(arrWordList) / sizeof(char*);
	const char* arrLetters = "abcdefghijklmnopqrstuvwxyz";//(1)
	while (1)
	{
		int iWrongGuessesLeft = 8;
		int iTargetWordNumber = rand() % iWordCount;
		const char* pCurrentWord = arrWordList[iTargetWordNumber];
		int iWordLength = strlen(arrWordList[iTargetWordNumber]);

		char arrAvailable[27] = { '.' };
		//strcpy(arrAvailable, arrLetters);//(1)

		char* pBlankWord = (char*)malloc(iWordLength + 1);
		pBlankWord[iWordLength] = '\0';
		memset(pBlankWord, '-', iWordLength);
		int iLettersGuessed = 0;
		while (1)
		{
			printf("Current state: letters in word: %d,  letters left: %d, wrong chance left: %d\n", iWordLength, iWordLength - iLettersGuessed, iWrongGuessesLeft);
			//printf("%s\n", pCurrentWord);
			printf("%s\n", pBlankWord);
			printf("Choose the guess letter form %s\n", arrAvailable);
			char c;
			bool again = true;
			do
			{
				printf("enter your guess:");
				c = tolower(getchar());
				while (getchar() != '\n');
				if (c<'a' || c>'z')
				{
					printf("what you enter is invalid\n");
				}
				else
					again = false;
			} while (again);
			if (!isavailiales(arrAvailable, c))
			{//already guessed
				printf("you have already guess %c.\n", c);
			}
			else if (isinthewords(pCurrentWord, c))
			{//guess right
				for (int i = 0; i < iWordLength; i++)
				{
					if (pCurrentWord[i] == c)
					{
						iLettersGuessed++;
						pBlankWord[i] = c;
					}
				}
				//printf("%s\n", pBlankWord);
				if (iLettersGuessed == iWordLength)
				{
					printf("%s\n", pBlankWord);
					printf("succeed\n");
					break;
				}
			}
			else
			{
				printf("wrong guess\n");
				iWrongGuessesLeft--;
			}
			if (iWrongGuessesLeft == 0)
			{
				printf("(run out of guesses, fail\n");
				break;
			}
		}
		free(pBlankWord);
		printf("do you want to play one more time?[Y=yes/N=no]\n");
		char replay = tolower(getchar());
		while (getchar() != '\n');
		if (replay == 'n')
			return 0;
	}
}