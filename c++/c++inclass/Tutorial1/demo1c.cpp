#include "cstdio"
#include "cstring"
#include "cstdlib" // malloc

// Reverse a command line string
// const
// malloc
// strlen
// printf

int main(int argc, char* argv[])
{
	if (argc < 2)
	{
		printf("I need a word to reverse!\n");
		return 1;
	}
	const char* word = argv[1];
	
	int len = strlen(word);
	char* myWord = (char*)malloc(len + 1);
	for (int i = 0; i < len; i++)
		myWord[i] = word[len - i -1];
	myWord[len] = 0; // Terminate the new string

	printf("%s\n", myWord);

	// Good to get into practice of freeing all allocated memory
	free(myWord); 
	
	return 0;
}
