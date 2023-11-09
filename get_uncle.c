#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"
#define print printf
int main(int argc, char *argv[])
{
    int f = fork();
    int s = -1;
    int third = -1;
    third = third;
    int temp = -1;
    temp = temp;

    if (f != 0)
    {

        s = fork();
        if (s != 0 && f != 0)
        {
            third = fork();
        }
    }

    if (third == 0 && f != 0 && s != 0)
    {
        int tc = fork();
        if (tc != 0)
            temp = tc;
        if (tc != 0)
        {

            printf(1, "%d", get_uncle_count(temp));
        }
        // if (temp != -1)
        // {

        // }
        // printf(1, "%d tc \n", temp);
    }
    

    // printf(1, "%d a\n", get_parent());

    // int a = fork();
    // if (a != 0)
    // {
    //     int t = fork();
    //     if (t != 0)
    //     {
    //         int y = fork();
    //         if (y != 0)
    //         {
    //             printf(1, "amo tamom\n");
    //         }
    //         else
    //         {
    //             int z = fork();

    //             if (z == 0)
    //             {
    //                 printf(1, "I am grand child with pid:%d and my father id is : %d\n", get_pid(), get_parent());
    //             }
    //         }
    //     }
    // }
    sleep(10);
    exit();
}
// #include "types.h"
// #include "stat.h"
// #include "user.h"
// #include "date.h"
// int main(int argc, char *argv[])
// {

//     int a = fork();
//     if (a != 0)
//     {
//         // printf(1, "I am grandparent with pid : %d\n", get_pid());
//         int x = fork();
//         if (x != 0)
//         {
//             int y = fork();
//             if (y != 0)
//             {
//                 int z = fork();
//                 if (z != 0)
//                 {
//                     // printf(1, "amo tamom\n");
//                 }
//             }
//         }
//     }
//     else
//     {
//         // printf(1, "I am father with pid : %d\n", get_pid());
//         int y = fork();
//         if (y == 0)
//         {
//             printf(1, "I am the grandchild and I have %d uncles\n", get_uncle_count(get_pid()));
//         }
//     }

//     exit();
// }