#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

int main(int argc, const char *argv[]){
	printf("This is a program to mimic ls!\n");
	pid_t cpid = fork();
	if (cpid == -1){
		perror("fork");
		exit(EXIT_FAILURE);
	}
	else if (cpid == 0){
		printf("I am the child, my pid is: %d\n", (int) getpid());
		char* myargs[3];
		myargs[0] = strdup("ls");
		if (argv[1]!=NULL){
			myargs[1] = strdup(argv[1]);
		}
		else{
			myargs[1] = NULL;
		}
		myargs[2] = NULL;
		execvp(myargs[0],myargs);
	}
	else {
		waitpid(cpid,NULL,0);
		printf("Parent has reaped child: %d\n",(int) cpid);
	}
}
