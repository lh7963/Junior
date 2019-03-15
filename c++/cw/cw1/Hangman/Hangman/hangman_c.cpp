#define _CRT_SECURE_NO_WARNINGS
#include "cstdio"
#include "cstring"
#include "cstdlib" 
#include <ctime>
#include <ctype.h>

bool isavailiale(char* str, char c)
{
	if (str[c - 'a'] == '.')
	{
		return false;
	}
	str[c - 'a'] = '.';
	return true;
}

bool isintheword(const char* str, char c)
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

int main(int argc, char* argv[])
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
		strcpy(arrAvailable, arrLetters);//

		char* pBlankWord = (char*)malloc(iWordLength + 1);
		pBlankWord[iWordLength] = '\0';
		memset(pBlankWord, '-', iWordLength);
		int iLettersGuessed = 0;
		while (1)
		{
			printf("\nGuess a letter for the word:\'%s\'\n", pBlankWord);
			printf("You have %d wrong guesses left, and have guessed %d letters out of %d so far.\n", iWrongGuessesLeft, iLettersGuessed, iWordLength);
			printf("Available letters are: %s\n", arrAvailable);
			char c;
			bool again = true;
			do
			{
				printf("Enter your guess:");
				while ((c = getchar()) == '\n');
				c = tolower(c);
				if (c<'a' || c>'z')
				{
					printf("\'%c\' is not a valid letter! Try again.\n", c);
				}
				else
					again = false;
			} while (again);
			if (!isavailiale(arrAvailable, c))
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
				printf("\n*** Correct guess - \'%c\' IS in the word ***\n", c);
				if (iLettersGuessed == iWordLength)
				{
					printf("\nWell done! The word was '%s'. \nYou finished with %d wrong guesses left.\n", pBlankWord, iWrongGuessesLeft);
					break;
				}
			}
			else
			{
				printf("\n!!! Wrong guess - \'%c\' is not in the word !!!\n", c);
				iWrongGuessesLeft--;
			}
			if (iWrongGuessesLeft == 0)
			{
				printf("\nYou failed. The word was '%s'\n", pCurrentWord);
				break;
			}
		}
		free(pBlankWord);
		printf("Try again?[Y=yes/N=no]\n");
		char replay;
		while ((replay = getchar()) == '\n');
		if (replay == 'n')
			return 0;
	}
}