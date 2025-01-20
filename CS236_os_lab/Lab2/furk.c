#include <stdio.h> //For Input Output
#include <stdlib.h> //FOr Standard Libraries
#include <unistd.h> //Unix-Standard Library? Provides API for Posix Like Systems

int main(int argc, char *argv[]){
	printf("I am Forking\n");
	int ret =  fork();
	if (ret < 0){
		printf("Fork failed with exit code: %d\n", (int) ret);
	}
	else if (ret == 0){
		printf("I am Child\n");
		exit(1);
	}
	else{
		printf("I am Parent\n");
//		wait();
	}
}
