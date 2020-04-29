#include <stdio.h>

struct test{
	int ID;
	void (*funPtr)();
};

void hello()
{
	printf("hello");
}

int main()
{
	struct test a;
	a.funPtr = &hello;
	a.funPtr();
}
