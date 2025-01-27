#include  <stdio.h>
#include  <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

#include <signal.h>
#include <errno.h>
#include <stdbool.h>

#define MAX_INPUT_SIZE 1024
#define MAX_TOKEN_SIZE 64
#define MAX_NUM_TOKENS 64

#define _XOPEN_SOURCE 700

/* Splits the string by space and returns the array of tokens
*
*/
char **tokenize(char *line)
{
  char **tokens = (char **)malloc(MAX_NUM_TOKENS * sizeof(char *));
  char *token = (char *)malloc(MAX_TOKEN_SIZE * sizeof(char));
  int i, tokenIndex = 0, tokenNo = 0;

  for(i =0; i < strlen(line); i++){

    char readChar = line[i];

    if (readChar == ' ' || readChar == '\n' || readChar == '\t'){
      token[tokenIndex] = '\0';
      if (tokenIndex != 0){
	tokens[tokenNo] = (char*)malloc(MAX_TOKEN_SIZE*sizeof(char));
	strcpy(tokens[tokenNo++], token);
	tokenIndex = 0; 
      }
    } else {
      token[tokenIndex++] = readChar;
    }
  }
 
  free(token);
  tokens[tokenNo] = NULL ;
  return tokens;
}

// static void handler(int sig, siginfo_t *info, void *ucontext){
// 	if (sig ==SIGCHLD){
// 		waitpid(info->si_pid,NULL,0);
// 		printf("Shell: Background process finished. PID: %d\n",info->si_pid);
// 		return;
// 	}
// }

int main(int argc, char* argv[]) {
	char  line[MAX_INPUT_SIZE];            
	char  **tokens;              
	int i;

	pid_t back_procs_pid = fork();

	if (back_procs_pid == -1){
		perror("fork");
		exit(EXIT_FAILURE);
	}
	else if (back_procs_pid == 0) {
		// printf("Child Back proc Running\n");
		setpgid(0,0);
		while(1);
	}
	else if (back_procs_pid > 0){
		while(1) {

		waitid(P_PGID, getpgid(back_procs_pid), NULL, WNOHANG);

		// //Define Signal Handler
		// struct sigaction sa;
		// sa.sa_flags = SA_SIGINFO;
		// sa.sa_sigaction = handler;
		// if (sigaction(SIGCHLD, &sa, NULL) == -1){
		// 	perror("sigaction"); exit(EXIT_FAILURE);
		// }

		bool background_process = 0;	
		/* BEGIN: TAKING INPUT */
		bzero(line, sizeof(line));
		printf("$ ");
		scanf("%[^\n]", line);
		getchar();

		if (strcmp(line, "") == 0){continue;}
		else if (strcmp(line, "exit") == 0){
			if (getpgid(back_procs_pid) == back_procs_pid) kill(getpgid(back_procs_pid),9);
			// printf("Back Killed\n");
			if (waitpid(back_procs_pid,NULL,0) == -1){
				perror("waitpid");
				exit(EXIT_FAILURE);
			}
		}

		//printf("Command entered: %s (remove this debug output later)\n", line);

		/* END: TAKING INPUT */

		line[strlen(line)] = '\n'; //terminate with new line
		tokens = tokenize(line);
	
		//do whatever you want with the commands, here we just print them

		for(i=0;tokens[i]!=NULL;i++){
			//printf("found token %s (remove this debug output later)\n", tokens[i]);
			if (!strcmp(tokens[i],"&")){
				tokens[i] = NULL;
				background_process = 1;
			}
		}

		// HANDLING cd
		if (!strcmp(tokens[0],"cd")){
			if (tokens[1] == NULL){
				printf("Usage: cd <directoryname>/.. \n");
				continue;
			}
			int ret = chdir(tokens[1]);
			if (ret == -1){
				printf("Error occured while parsing, Code: %d",errno);
			}
			continue;
		}
			
		//Forking
		pid_t cpid = fork();
		if (cpid == -1){
			perror("fork");
			exit(EXIT_FAILURE);
		}
		if (background_process){
			if (setpgid(cpid, getpgid(back_procs_pid)) == -1){
				perror("setpgid");
				exit(EXIT_FAILURE);
			}
			if (cpid == 0){
				int ret = execvp(tokens[0],tokens);
				if (ret == -1){
					printf("Cannot execute command\n");
					continue;
				}
				exit(0);
			}
			else {
				//Do nothing and let it run
			}
		}
		else{
			if (cpid == 0){
			//printf("I am the child, my pid is: %d\n", (int) getpid());
			//printf("Print statement before exec\n");
			int ret = execvp(tokens[0],tokens);
			if (ret == -1){
				printf("Cannot execute command\n");
				continue;
			}
			//printf("Print statement after exec\n");
			exit(0);
			}
			else {
				waitpid(cpid,NULL,0);
				// waitpid(cpid,NULL,0);
				// printf("Parent has reaped child: %d\n",(int) cpid);
			}
		}
	
		// Freeing the allocated memory	
		for(i=0;tokens[i]!=NULL;i++){
			free(tokens[i]);
		}
		free(tokens);
		}
	}

	return 0;
}
