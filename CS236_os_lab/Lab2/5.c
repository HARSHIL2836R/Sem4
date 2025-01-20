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
		char* myargs[3];
		myargs[0] = strdup("terminal-parrot");
		myargs[1] = NULL;
		myargs[2] = NULL;
		printf("Print statement before exec\n");
		execvp(myargs[0],myargs);
		printf("Print statement after exec\n");
	}
	else {
		waitpid(cpid,NULL,0);
		printf("Parent has reaped child: %d\n",(int) cpid);
	}
}
