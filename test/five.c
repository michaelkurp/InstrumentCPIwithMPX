#include <stdio.h>
#include <stdlib.h>

struct test{
        char str[5];
        void (*funPtr)();
};
void breakme()
{
}
void pwn()
{
	printf("Thou base belongs to us");
}

void hello()
{
        printf("hello");
}

int main()
{
	breakme();
        struct test a;
        a.funPtr = &hello;
        a.funPtr();

        gets(a.str);

        a.funPtr();

        return 0;
}
