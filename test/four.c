#include <stdlib.h>
int add(int a, int b){
	return a + b;
}

int sub(int a, int b){
	return a-b;
}
int foo(int x) {
	int (*a_fptr)(int, int) = add;
	int (*s_fptr)(int, int) = sub;
	int (*t_fptr)(int, int) = 0;

	int op1 =1, op2=2;

	if (x== 3) {
		t_fptr = a_fptr;
	}
	else
	{
	t_fptr = s_fptr;
	}
	if(t_fptr != NULL)
	{
		unsigned result = t_fptr(op1, op2);
	}
	return 0;
}

int main()
{
	int test = foo(2);
return 0;
}
