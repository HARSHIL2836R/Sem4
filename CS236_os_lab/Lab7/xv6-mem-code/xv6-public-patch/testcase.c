#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(void)
{
  int nums = numvp();
  printf(1, "Hello, world! Nums = %d\n", nums);
  exit();
}
