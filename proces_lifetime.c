#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"
int main(int argc, char *argv[])
{
    int child = fork();
    if (child == 0)
    {
        sleep(1000);
        printf(1, "child life :%d\n", get_process_lifetime(get_pid()));
        exit();
    }
    else
    {
        sleep(500);
        printf(1, "parent life_time : %d",get_process_lifetime(get_pid()));
        exit();
    }
}