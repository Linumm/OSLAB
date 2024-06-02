#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int parent_fp, child_fp, parent_pp, child_pp, parent_ptp, child_ptp;
  int pid;

  printf(1, "[Test 1] initial sharing\n");
  printf(1, "Before fp: %d\n", countfp());
	
  parent_fp = countfp();
  parent_pp = countpp();
  parent_ptp = countptp();

  pid = fork();
  if(pid == 0){
    child_fp = countfp();
	child_pp = countpp();
	child_ptp = countptp();
	printf(1, "fp p, c: %d %d\n", parent_fp, child_fp);
	printf(1, "pp+ptp p, c: %d %d\n", parent_pp + parent_ptp, child_pp + child_ptp);
    
    if(parent_fp - child_fp == 68)
      printf(1, "[Test 1] pass\n\n");
    else
      printf(1, "[Test 1] fail\n\n");
    
    exit();
  }
  else{
    wait();
	printf(1, "After fp: %d\n", countfp());
  }

  exit();
}

