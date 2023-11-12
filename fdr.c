#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"
int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        exit();
    }
    int saved_ebx, number = atoi(argv[1]);
    //
    asm volatile(
        "movl %%ebx, %0;" // saved_ebx = ebx
        "movl %1, %%ebx;" // ebx = number
        : "=r"(saved_ebx)
        : "r"(number));
    printf(1,"digtal root is %d\n",find_digital_root());
    asm("movl %0, %%ebx" : : "r"(saved_ebx)); // ebx = saved_ebx -> restore
    // 
    exit();
}