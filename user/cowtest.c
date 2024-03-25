#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/memlayout.h"
#include "user/user.h"



void
cwtest()
{
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = phys_size / 4;
  int pid1, pid2;


  
  char *p = sbrk(sz);
  if(p == (char*)0xffffffffffffffffL){
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  pid1 = fork();
  if(pid1 < 0){
    printf("fork failed\n");
    exit(-1);
  }
  if(pid1 == 0){
    pid2 = fork();
    if(pid2 < 0){
      printf("fork failed");
      exit(-1);
    }
    if(pid2 == 0){
      
      exit(-1);
    }
   
    exit(0);
  }

  
  printf("ok\n");
}


int
main(int argc, char *argv[])
{

  cwtest();
 

  printf(" COW TEST PASSED\n");

  exit(0);
}
