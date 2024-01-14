#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"



// void forked_prog(int id)
// {
//     int ref = open_sharedmem(1);
//     printf(
//         1 , "%d\n" , ref
//     );
//     int* mem_addr = (int *) ref ;
//     // printf(1  , " %d\n" ,*mem_addr);
// }
int main(int argc, char* argv[]){
    int frame_address = open_sharedmem(1);
    *frame_address = 0;
    printf(1, "abbas\n");
    int id = fork();
    if(id == 0){
        // char* gogail = (char*)open_sharedmem(1);
        // char* gorg_value = (char*) gogail;
        // printf(1, "%d\n", *gorg_value);
    }
    exit();
    return 0;
}