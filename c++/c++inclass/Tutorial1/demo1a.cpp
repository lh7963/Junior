// Demo lecture 1 example
// Command line arguments 
// atoi
// srand
// rand
// time
// Visual studio keeping window open hack

#include <cstdio>
#include <cstdlib>
#include <ctime>

int main(int argc, char* argv[])
{
	printf("%d\n", argc);
	/*
	if (argc < 2)
	{
		srand( (unsigned int)time(nullptr));
	}
	else
	{
		printf("the argv[1] is %s, the argv[2] is %s\n", argv[1], argv[2]);
		printf("argc: %d  atoi(argv[1]): %d \n", argc, atoi(argv[1]));
		srand(atoi(argv[1]));
		
		1. discards as many whitespace characters
		2. takes an optional initial plus or minus sign
		3. takes as many base 10 digits followed by the sign as possible
		4. if the string is not match the convention, 0 is returned
		
	}
	*/
	for (int j = 0; j < 3; j++)
	{
		srand(4);
		for (int i = 0; i < 6; i++)
		{
			printf("%d ", rand() % 6);
		}
		printf("\n");
	}
	printf("%d\n", sizeof(int*));// 8 (64bit) pointer always take 64 bits to record the logical location
	printf("%d\n", sizeof(char));// 1 (8bit)
	//while (getchar() != '\n');
	printf("================\n");
	char ac[] = {'c','+','+','c','+','+'};
	printf("%s\n", ac);
	char c;
	{
		printf("%d", c);
	}
}
