#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"




int main(int argc, char* argv[]){
    printf(1, "%d\n", open_sharedmem(1));
    return 0;
}