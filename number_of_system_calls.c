#include "types.h"
#include "user.h"
// #include "file.h"
#include "date.h"
#include "stat.h"
#include "fcntl.h"
int main(int argc, char *argv[])
{
    int first = fork();
    int second=1;
    if (first != 0)
    {
        second = fork();
        // if (second == 0)
        // {
        //     sleep(100);
        //     printf(1, "Pid: %d , Number_Call: %d \n", get_pid(), number_of_sys_calls());
        // }
    }
    // else
    // {
    //     sleep(200);
    //      printf(1, "Pid: %d , Number_Call: %d \n", get_pid(), number_of_sys_calls());
    // }
    if (second != 0 && first != 0)
    {
        int fd = open("README", O_WRONLY);
        fd=fd;
        write(fd, "HI", 7);
        // get_process_lifetime(get_pid());
        printf(1, "Number_Call: %d \n",  number_of_sys_calls());
    }
    // wait();
    // int fd = open("README", O_WRONLY);
    // write(fd, "siktir", 7);
    // int i = fork();
    // if (i != 0)
    // {
    //     // printf(1, "%d ", number_sys_calls_global());
    //     // printf(1, "%d ", number_sys_calls_global());

    //     printf(1, "Number_Call: %d \n", number_of_sys_calls());
    //     printf(1, "Number_Call: %d \n", number_of_sys_calls());
    //     printf(1, "Number_Call: %d \n", number_of_sys_calls());
    //     printf(1, "Number_Call: %d \n", number_of_sys_calls());

    // }
    exit();
}