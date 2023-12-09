#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"



int main(int argc, char* argv[]){

    if(argc < 4){
        printf(1, "not enough args\n");
        return 1;
    }
    bjf_validation_system();
    exit();
    

}