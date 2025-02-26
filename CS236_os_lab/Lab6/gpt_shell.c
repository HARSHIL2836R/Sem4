#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <errno.h>

#define MAX_INPUT_SIZE 1024
#define MAX_TOKEN_SIZE 64
#define MAX_NUM_TOKENS 64

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

int main()
{
	char line[MAX_INPUT_SIZE];
	char **tokens;
	int i;

	while (1)
	{
		printf("$ ");
		fgets(line, sizeof(line), stdin);
		line[strcspn(line, "\n")] = 0; // Remove newline

		if (strcmp(line, "") == 0)
		{
			continue;
		}

		tokens = tokenize(line);

		// Handle exit command
		if (tokens[0] && !strcmp(tokens[0], "exit"))
		{
			for (i = 0; tokens[i] != NULL; i++)
			{
				free(tokens[i]);
			}
			free(tokens);
			exit(0);
		}

		// Check if command contains a pipe
		int pipe_pos = -1;
		for (i = 0; tokens[i] != NULL; i++)
		{
			if (!strcmp(tokens[i], "|"))
			{
				pipe_pos = i;
				break;
			}
		}

		if (pipe_pos != -1) // Pipe found
		{
			int fd[2];
			pipe(fd);

			tokens[pipe_pos] = NULL; // Split the tokens into two commands
			char **cmd1 = tokens;
			char **cmd2 = tokens + pipe_pos + 1;

			// Ensure cmd2 is valid
			if (cmd2[0] == NULL)
			{
				fprintf(stderr, "Error: Invalid pipe usage\n");
				continue;
			}

			pid_t cpid1 = fork();
			if (cpid1 == 0)
			{
				// First process writes to the pipe
				dup2(fd[1], STDOUT_FILENO);
				close(fd[0]);
				close(fd[1]);
				execvp(cmd1[0], cmd1);
				perror("execvp");
				exit(EXIT_FAILURE);
			}

			pid_t cpid2 = fork();
			if (cpid2 == 0)
			{
				// Second process reads from the pipe
				dup2(fd[0], STDIN_FILENO);
				close(fd[0]);
				close(fd[1]);
				execvp(cmd2[0], cmd2);
				perror("execvp");
				exit(EXIT_FAILURE);
			}

			close(fd[0]);
			close(fd[1]);

			waitpid(cpid1, NULL, 0);
			waitpid(cpid2, NULL, 0);
		}
		else
		{
			// No pipe, just a regular command
			pid_t cpid = fork();
			if (cpid == 0)
			{
				execvp(tokens[0], tokens);
				perror("execvp");
				exit(EXIT_FAILURE);
			}
			else
			{
				waitpid(cpid, NULL, 0);
			}
		}

		// Free allocated memory
		for (i = 0; tokens[i] != NULL; i++)
		{
			free(tokens[i]);
		}
		free(tokens);
	}

	return 0;
}
