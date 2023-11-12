#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"
#include "fcntl.h"
int main(int argc, char *argv[])
{
    
    int a = copy_file(argv[1], argv[2]);
    if(a == 1){
        printf(1, "copying failed\n");
    }
    
    exit();
}