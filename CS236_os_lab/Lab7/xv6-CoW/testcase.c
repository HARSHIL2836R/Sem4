#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(void)
{
  int a = 25;
  int ret = fork();
  if (ret == 0)
  {
    printf(1,"Inside child\n");
    printf(1,"%d\n",getFreePages());
    a =30;
    printf(1,"Changed a\n");
  }
  else
  {
    sleep(50);
    printf(1,"Parent woke after sleep\n");
    printf(1,"%d\n",getFreePages());
    wait();
  }
  exit();
}
