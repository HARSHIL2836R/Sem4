#include  <stdio.h>
#include  <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

#define MAX_INPUT_SIZE 1024
#define MAX_TOKEN_SIZE 64
#define MAX_NUM_TOKENS 64

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


int main(int argc, char* argv[]) {
	char  line[MAX_INPUT_SIZE];            
	char  **tokens;              
	int i;


	while(1) {			
		/* BEGIN: TAKING INPUT */
		bzero(line, sizeof(line));
		printf("$ ");
		scanf("%[^\n]", line);
		getchar();

		if (strcmp(line, "") == 0){continue;}
		else if (strcmp(line, "exit") == 0){return 0;}

		//printf("Command entered: %s (remove this debug output later)\n", line);

		/* END: TAKING INPUT */

		line[strlen(line)] = '\n'; //terminate with new line
		tokens = tokenize(line);
   
       //do whatever you want with the commands, here we just print them

		for(i=0;tokens[i]!=NULL;i++){
			//printf("found token %s (remove this debug output later)\n", tokens[i]);
		}
       
       //Forking
       pid_t cpid = fork();
		if (cpid == -1){
			perror("fork");
			exit(EXIT_FAILURE);
		}
		else if (cpid == 0){
			//printf("I am the child, my pid is: %d\n", (int) getpid());
			//printf("Print statement before exec\n");
			int ret = execvp(tokens[0],tokens);
			if (ret == -1){
				printf("Cannot execute command\n");
				continue;
			}
			//printf("Print statement after exec\n");
		}
		else {
			waitpid(cpid,NULL,0);
			//printf("Parent has reaped child: %d\n",(int) cpid);
		}
       
		// Freeing the allocated memory	
		for(i=0;tokens[i]!=NULL;i++){
			free(tokens[i]);
		}
		free(tokens);

	}
	return 0;
}
