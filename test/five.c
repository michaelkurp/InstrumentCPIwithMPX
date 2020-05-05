#include <string.h>
#include <stdio.h>
#include <stdlib.h>

struct test{
        char str[2];
        void (*funPtr)();
};
void breakme()
{
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
//	breakme();
        struct test a;
        a.funPtr = &hello;
	a.funPtr();
	strcpy(a.str, "@@@@@@@@@\a@");        
	breakme();
	a.funPtr();

        return 0;
}

