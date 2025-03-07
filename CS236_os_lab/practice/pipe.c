#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#define read_end 0
#define write_end 1
int main(){
    int pipe_fd[2];
    pipe(pipe_fd);

    int cpid = fork();
    if (cpid==0){
        close(pipe_fd[read_end]);
        char buf[100];
        bzero(buf, sizeof(buf));
        strcpy(buf, "Hi daddy");
        write(pipe_fd[write_end],buf,sizeof(buf));
        printf("Message sent: %s\n",buf);
        close(pipe_fd[write_end]);
        exit(0);
    }
    else{
        wait(NULL);
        close(pipe_fd[write_end]);
        char buf[100];
        bzero(buf,sizeof(buf));
        read(pipe_fd[read_end],buf, sizeof(buf));
        printf("Message recieved: %s\n",buf);
        close(pipe_fd[read_end]);
        exit(0);
    }
}