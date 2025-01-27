#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

#include <signal.h>
#include <errno.h>

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

	for (i = 0; i < strlen(line); i++)
	{

		char readChar = line[i];

		if (readChar == ' ' || readChar == '\n' || readChar == '\t')
		{
			token[tokenIndex] = '\0';
			if (tokenIndex != 0)
			{
				tokens[tokenNo] = (char *)malloc(MAX_TOKEN_SIZE * sizeof(char));
				strcpy(tokens[tokenNo++], token);
				tokenIndex = 0;
			}
		}
		else
		{
			token[tokenIndex++] = readChar;
		}
	}

	free(token);
	tokens[tokenNo] = NULL;
	return tokens;
}

// static void handler(int sig, siginfo_t *info, void *ucontext){
// 	if (sig ==SIGCHLD){
// 		waitpid(info->si_pid,NULL,0);
// 		printf("Shell: Background process finished. PID: %d\n",info->si_pid);
// 		return;
// 	}
// }

int main(int argc, char *argv[])
{
	char line[MAX_INPUT_SIZE];
	char **tokens;
	int i;

	while (1)
	{

		while (waitpid(-1, NULL, WNOHANG) > 0){
			printf("Shell: Background Process Finished\n");
		}

		int background_process = -1;
		/* BEGIN: TAKING INPUT */
		bzero(line, sizeof(line));
		printf("$ ");
		scanf("%[^\n]", line);
		getchar();

		if (strcmp(line, "") == 0)
		{
			continue;
		}
		

		// printf("Command entered: %s (remove this debug output later)\n", line);

		/* END: TAKING INPUT */

		line[strlen(line)] = '\n'; // terminate with new line
		tokens = tokenize(line);

		// do whatever you want with the commands, here we just print them

		if(tokens[0] && !strcmp(tokens[0],"exit") && !tokens[1]){
			// If first token is exit, and 2nd is NULL then free memory
			// Freeing the allocated memory
			for (i = 0; tokens[i] != NULL; i++)
			{
				free(tokens[i]);
			}
			free(tokens);
			kill(-getpid(), SIGTERM); // Kill all processes in same pgid; see how we are using -<pid-of-main-shell> to kill all the processes from the same group
			exit(0);
		}
	
		for (i = 0; tokens[i] != NULL; i++)
		{
			// printf("found token %s (remove this debug output later)\n", tokens[i]);
			if (!strcmp(tokens[i], "&"))
			{
				if (tokens[i+1] == NULL) tokens[i] = NULL;
				else{
					printf("Multiple commands after &\n");
					background_process = -2;
				}
			}
		}

		if (background_process == -2) {
            // If background is not the last argument, then return
			// Freeing the allocated memory
			for (i = 0; tokens[i] != NULL; i++)
			{
				free(tokens[i]);
			}
			free(tokens);
			continue;
        }

		// HANDLING cd
		if (!strcmp(tokens[0], "cd"))
		{
			if (tokens[1] == NULL)
			{
				printf("Usage: cd <directoryname>/.. \n");
				continue;
			}
			int ret = chdir(tokens[1]);
			if (ret == -1)
			{
				printf("Error occured while parsing, Code: %d", errno);
			}
			continue;
		}

		// Forking
		pid_t cpid = fork();
		if (cpid == -1)
		{
			perror("fork");
			exit(EXIT_FAILURE);
		}
			if (cpid == 0)
			{
				int ret = execvp(tokens[0], tokens);
				if (ret == -1)
				{
					printf("Cannot execute command\n");
				}
				exit(0);
			}
			else
			{
				if (background_process == -1 ) waitpid(cpid,NULL,0);
			}

		// Freeing the allocated memory
		for (i = 0; tokens[i] != NULL; i++)
		{
			free(tokens[i]);
		}
		free(tokens);
	}

	return 0;
}
