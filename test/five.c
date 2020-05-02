#include <stdio.h>
#include <stdlib.h>

struct test{
        char str[2];
        void (*funPtr)();
};
void breakme()
{
	struct test a[20];
}
void hello()
{
        printf("hello");
}
void pwn()
{
	printf("Thou base belongs to us");
}

int main()
{
	breakme();
        struct test a;
        a.funPtr = &hello;
        a.funPtr();
	strcpy(a.str, "@@@@@@@@@\a@@@@");        
	a.funPtr();

        return 0;
}

