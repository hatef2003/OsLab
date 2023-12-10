#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"



int main(int argc, char* argv[]){
    if(argc < 6){
        printf(1, "not enough args\n");
        return 1;
    }
    bjf_validation_process(atoi(argv[1]), atoi(argv[2]), atoi(argv[3]), atoi(argv[4]), atoi(argv[5]));
    exit();
}