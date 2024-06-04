#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int parent_fp, child_fp;
  int pid;

  printf(1, "[Test 1] initial sharing\n");
  printf(1, "Before fp: %d\n", countfp());
	
  parent_fp = countfp();

  pid = fork();
  if(pid == 0){
    child_fp = countfp();
	printf(1, "fp p, c: %d %d\n", parent_fp, child_fp);
    
    if(parent_fp - child_fp == 68)
      printf(1, "[Test 1] pass\n\n");
    else
      printf(1, "[Test 1] fail\n\n");
    
    exit();
  }
  else{
    wait();
	sleep(10);
	printf(1, "After fp: %d\n", countfp());
  }

  exit();
}

