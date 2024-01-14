#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"

int main(int argc, char *argv[])
{
    printf(1, "Hiiii\n");
    int id = 1;
    open_shm(id);
    // *addr = 0;
    printf(1, "BYYYYYeeee%d\n", 1);
    // for (int i = 0; i < 10; i++)
    // {
    //     int j = fork();
    //     if (j == 0)
    //     {
    //         Aquire();
    //         char *addr2 = (char *)open_shm(1);
    //         *addr2 = (*addr2) + 1;
    //         printf(1, " val -> %d\n", *addr2);
    //         C(1);

    //         R();
    //         exit();
    //     }
    //     else
    //     {
    //         sleep(10);
    //     }
    // }
    C(1);
    printf(1, "kirmaos\n");
    // sleep(1000);
    exit();
}