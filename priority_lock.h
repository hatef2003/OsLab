#include "spinlock.h"
// Long-term locks for processes
struct priority_lock {
  int locked;       // Is the lock held?
  struct spinlock lk; // spinlock protecting this sleep lock
  
  // For debugging:
  char *name;        // Name of lock.
  int pid;           // Process holding lock
};

