#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

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
		char* str_cpid;
		sprintf(str_cpid, "%d",cpid);
		char* myargs[4];
		myargs[0] = strdup("kill");
		myargs[1] = strdup(str_cpid);
		myargs[2] = strdup("-SIGTERM");
		myargs[3] = NULL;
		execvp(myargs[0],myargs);
		printf("Child Process %d is terminated\n",cpid);
		waitpid(cpid,NULL,0);
		printf("Parent has reaped child: %d\n",(int) cpid);
	}
}
