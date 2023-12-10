#include "types.h"
#include "stat.h"
#include "user.h"
#include "date.h"
int main(int argc, char *argv[])
{

    change_queue(get_pid(), 1);
    print_info();

    exit();
}
