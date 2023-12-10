#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"
int main(int argc, char *argv[])
{
    int i = fork();
    if (i == 0)
    {
        while (1)
            ;
    }
    else
    {
        for (;;)
            ;
    }
    exit();
}
