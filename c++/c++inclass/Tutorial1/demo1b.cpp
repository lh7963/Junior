// Demo lecture 1 example
// Command line arguments 
// atoi
// char* as an array of chars - accessing first element
// if, switch, for
// switch on a char, since a char is a number
// function call
// sizeof on type and array
// Array initialiser - array of chars and array of char*s

#include <cstdio>
#include <cstdlib>

int apply(char op, int param1, int param2)
{
	switch (op)
	{
	case '*': return param1 * param2;
	case '+': return param1 + param2;
	case '-': return param1 - param2;
	case '/': if (param2 == 0) { printf("Division by 0 error!\n"); return 0; } else return param1 / param2;
	case '%': if (param2 == 0) { printf("Division by 0 error!\n"); return 0; } return param1 % param2;
	}
	printf("Error - invalid operator %c in apply()\n", op );
	return 0;
}

int main(int argc, char* argv[])
{
	if (argc < 4)
	{
		printf("Too few arguments. Needs number, operator, number");
		return 1;
	}

	int arg1 = atoi(argv[1]);
	char op = argv[2][0];
	int arg2 = atoi(argv[3]);

	char ops[] = { '*', '+', '-', '/', '%' };
	const char* opnames[] = { "multiplied by", "plus", "minus", "divided by", "modulo" };//array, store the pointers

	int iNumberOps = sizeof(ops) / sizeof(char);
	if (sizeof(opnames) / sizeof(char*) != iNumberOps)
	{
		printf("Jason made a mistake in array sizes - check them.");
		return 2;
	}

	int index = -1;
	for (int i = 0; i < iNumberOps; i++ )
	{
		if (ops[i] == op)
			index = i;
	}
	if (index == -1)
	{ // Was not found
		printf("Invalid operator: '%c'\n", op );
		return 0;
	}
	else
	{ // Have a valid index so use it
		printf("%d %s %d = %d\n", arg1, opnames[index], arg2, apply(op, arg1, arg2));
	}
	return 0; // success
}
