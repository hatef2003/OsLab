#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"
#include "fcntl.h"
int main(int argc, char *argv[])
{
    int f = fork();
    int s;
    int t;
    int e;
    if (f != 0)
    {
        s = fork();
        if (s != 0)
        {
            t = fork();
            if (t != 0)
            {
                e = fork();
                if (e != 0)
                    sleep(100);
            }
        }
    }
    s = s;
    e = e;
    t = t;
//oljp
    plock_test();
    exit();
}