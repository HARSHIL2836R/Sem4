#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>
#include <stdio.h>
#define SIZE 4096
int main(){
    const char *name = "OSABASASsadasdasdasD";
    int memfd = shm_open(name,O_CREAT | O_RDWR, 0666);
    ftruncate(memfd, SIZE);
    void *shmp = mmap(0, SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, memfd, 0);
    char *buf = "HARSHIL";
    printf("%d\n",memfd);
    printf("%p\n",shmp);
    sprintf(shmp,"%s",buf);
    shm_unlink(name);
}