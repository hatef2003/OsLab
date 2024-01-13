#include "syscall.h"
#include "traps.h"

#define SYSCALL(name) \
  .globl name; \
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
SYSCALL(exit)
SYSCALL(wait)
SYSCALL(pipe)
SYSCALL(read)
SYSCALL(write)
SYSCALL(close)
SYSCALL(kill)
SYSCALL(exec)
SYSCALL(open)
SYSCALL(mknod)
SYSCALL(unlink)
SYSCALL(fstat)
SYSCALL(link)
SYSCALL(mkdir)
SYSCALL(chdir)
SYSCALL(dup)
SYSCALL(getpid)
SYSCALL(sbrk)
SYSCALL(sleep)
SYSCALL(uptime)
SYSCALL(get_process_lifetime)
SYSCALL(get_uncle_count)
SYSCALL(get_pid)
SYSCALL(copy_file)
SYSCALL(find_digital_root)
SYSCALL(get_parent)
SYSCALL(change_queue)
SYSCALL(bjf_validation_process)
SYSCALL(bjf_validation_system)
SYSCALL(print_info)
SYSCALL(print_lopck_que)
SYSCALL(plock_test)
SYSCALL(open_shm)