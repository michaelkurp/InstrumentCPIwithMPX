#include <stdio.h>
#include <stdlib.h>

struct test{
        char str[10];
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

        gets(a.str);

        a.funPtr();

        return 0;
}
