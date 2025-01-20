#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

int main(int argc, const char *argv[]){

	int childs = 0;
	pid_t cpid;
	for (int i=0;i<4;i++){
		cpid = fork();
		if (cpid == -1){
			perror("fork");
			exit(EXIT_FAILURE);
		}
		else if (cpid == 0){
			printf("I am the child, my pid is: %d\n", (int) getpid());
		}
		else {
			waitpid(cpid,NULL,0);
			printf("Parent has reaped child: %d\n",(int) cpid);
		}
	}
}
