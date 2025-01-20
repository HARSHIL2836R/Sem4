#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <signal.h>

int main(int argc, const char *argv[]){
	pid_t cpid = fork();
	if (cpid == -1){
		perror("fork");
		exit(EXIT_FAILURE);
	}
	else if (cpid == 0){
		printf("I am the child, my pid is: %d\n", (int) getpid());
		printf("Print statement before sleep\n");
		sleep(100);
		printf("Print statement after sleep\n");
	}
	else {
        kill(cpid,9);// 9 is SIGKILL
		printf("Child Process %d is terminated\n",cpid);
		waitpid(cpid,NULL,0);
		printf("Parent has reaped child: %d\n",(int) cpid);
	}
}
