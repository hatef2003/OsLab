#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"
int main(int argc, char *argv[])
{
    for (int i =0 ; i<10000;i++)
    {
        printf(1,".");
    }
    printf(1,"%d",get_process_lifetime(1));
exit();
}