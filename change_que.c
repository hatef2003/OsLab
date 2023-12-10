#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"
int main(int argc, char *argv[])
{

    change_queue(atoi(argv[1]), atoi(argv[2]));

    exit();
}
