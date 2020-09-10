#include <stdio.h>
#include <string.h>


void greet(const unsigned char* arg)
{
        unsigned char name[64]={0};
        strcpy(name, arg);
        printf("Hello ");
        printf(name);
        printf("\n");
}


int main(int argc, char** argv, char** envp)
{
        if(argc < 2)
        {
                printf("Missing name!\n");
                return -1;
        }

        greet(argv[1]);

        return 0;
}
