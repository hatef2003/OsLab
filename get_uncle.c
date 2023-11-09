#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"
int main(int argc, char *argv[])
{
    // printf(1,"%daaa",get_pid());
    // int f = fork(), t = -1, s = -1;
    // int fc = -1, sc = -1, tc = -1;
    // if (f != 0)
    // {
    //     s = fork();
    //     if (s != 0)
    //     {
    //         t = fork();
    //         if (t == 0)
    //         {
    //             tc = fork();
    //         }
    //         else
    //         {
    //             printf(1,"%d\n",t);
    //         }
    //     }
    //     if (s == 0)
    //     {
    //         sc = fork();
    //         sc++;
    //         sc--;
    //     }
    // }
    // if (f == 0)
    // {
    //     fc = fork();
    //     fc++;
    //     fc--;
    // }
    // if (tc == 0)
    // {
    //     printf(1, "%d\n", get_uncle_count(3));
    //     exit();
    // }
    // // fork();
    // // fork();
    // // int a = fork();
    // // if(a>0)
    // // {

    // //     printf(1,"%d\n",a);
    // // }
    copy_file("README","amir");
    printf(1,"done");
    
    
    exit();

    
}