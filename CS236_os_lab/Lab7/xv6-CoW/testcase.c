#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(void)
{
  int nums = getNumFreePages();
  printf(1, "Hello, world! Nums = %d\n", nums);
  
  int ret = fork();
  
  nums = getNumFreePages();
  printf(1, "Hello, world! Nums = %d %d\n", nums,ret);

  exit();
}
