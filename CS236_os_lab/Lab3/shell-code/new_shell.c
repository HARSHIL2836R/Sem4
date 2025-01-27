#include <stdio.h>
#include <sys/types.h>
#include <signal.h>
#include <wait.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#define MAX_INPUT_SIZE 1024
#define MAX_TOKEN_SIZE 64
#define MAX_NUM_TOKENS 64

int fore_pgid = -1;
int back_pgid = -1;
int back_num = 0;

char **tokenize (char* line) {
    char **tokens = (char **)malloc(MAX_NUM_TOKENS * sizeof(char *));
    char *token = (char *)malloc(MAX_TOKEN_SIZE * sizeof(char));
    int i, tokenIndex = 0, tokenNo = 0;
    for (i = 0 ; i < strlen(line) ; i ++) {
        char readChar = line[i];
        if (readChar == ' ' || readChar == '\n' || readChar == '\t') {
            token[tokenIndex] = '\0';
            if (tokenIndex != 0){
                tokens[tokenNo] = (char*)malloc(MAX_TOKEN_SIZE*sizeof(char));
                strcpy(tokens[tokenNo++], token);
                tokenIndex = 0; 
            }
        }
        else {
            token[tokenIndex++] = readChar;
        }
    }
    free(token);
    tokens[tokenNo] = NULL ;
    return tokens;
}

void signal_handler(int sig){
    if (fore_pgid == -1) return;
    else if (sig == SIGINT) kill(-fore_pgid, SIGTERM);
}

void free_mem(char **tokens){
    // To free the memory taken by these strings
	for(int i = 0 ; tokens[i] != NULL ; i++ ) {
		free(tokens[i]);
	}
	free(tokens);
}

int main(int argc, char *argv){
    char line[MAX_INPUT_SIZE];
    char** tokens;
    int i;
    signal(SIGINT, signal_handler);

    while(1){
        bzero(line, sizeof(line));
        printf("$ ");
        scanf("%[^\n]",line);
        getchar();
        line[strlen(line)] = '\n';

        tokens = tokenize(line);

        if(tokens[0] && !strcmp(tokens[0],"exit") && !tokens[1]){
			// If first token is exit, and 2nd is NULL then free memory
			free_mem(tokens);
            // For exit, we need to kill both fore_pgid and back_pgid
            if (fore_pgid != -1 ) kill(-fore_pgid, SIGTERM);
            if (back_pgid != -1 ) kill(-back_pgid, SIGTERM);
			kill(-getpid(),SIGTERM); // Kill all processes in same pgid; see how we are using -<pid-of-main-shell> to kill all the processes from the same group
			exit(0);
		}

        while (waitpid(-1, NULL, WNOHANG)>0){
            printf("Shell: Background process terminated\n");
            back_num--;
        }

        if (back_num == 0) back_pgid = -1;

        if (!tokens[0]){
            continue;
        }

        int background = -1;
        for (i = 0; i < MAX_NUM_TOKENS; i++)
        {
            if (tokens[i] == NULL) break;
            else if (!strcmp(tokens[i],"&")) {
                if (tokens[i+1] == NULL) {
                    background = i;
                }
                else{
                    printf("Shell: Multiple commands after &\n");
                    background = -2;
                }
            }
        }

        if (background > 0 ) {
            // If background term exists, and "&&" or "&&&" are also present, then we should throw error
            for (int i = 0 ; i < MAX_NUM_TOKENS ; i ++ ) {
                if (tokens[i] == NULL) break;
                if (!strcmp(tokens[i], "&&") || !strcmp(tokens[i], "&&&")) {
                    background = -2;
                    break;
                }
            }
        }

        if (background == -2){
            printf("Shell : Incorrect Usage of &\n");
            free_mem(tokens);
            continue;
        }

        if (strcmp(tokens[0],"cd")){ // Command is not cd
            
            if (background > 0){
                tokens[background] = NULL;
                back_num++;
            }

            int cpid = fork();
            if (cpid == 0){
                if (background > 0) {
                    if (back_num == 1 ) setpgid(0, 0); // Changing the process group id, as described in the question, since this is the first background process, we use it's id as the group id
                    else setpgid(0, back_pgid); // Already a back_pgid available, so we use that.
                } 
                else setpgid(0, 0);
                int num_subproc = 1; // Number of subprocesses (parallel) in the currently entered user line
                int prev = 0; // Index of the last seen && and &&&
                for (int i = 0 ; i < MAX_NUM_TOKENS ; i ++ ) {
                    if (tokens[i] == NULL) break;
                    if (!strcmp(tokens[i], "&&")) {
                        tokens[i] = NULL; // We replace "&&" with NULL, to help execvp, another way would be to create a separate char* argv[]
                        if (fork() == 0) {
                            setpgid(0, fore_pgid); // If we get a SIGINT in between, we need to handle it correctly
                            execvp(*(tokens+prev), (tokens+prev)); // Execute the current command
                            printf("Shell: Incorrect Command : %s\n",*(tokens+prev));
							exit(0);
                        }
                        else {
                            wait(NULL); // Since "&&" denotes sequential, we need to wait for the previous foreground process to get done
                            prev = i + 1; // Index updated
                        }
                        continue;
                    }
                    if (!strcmp(tokens[i], "&&&")) {
                        tokens[i] = NULL; // We replace "&&" with NULL, to help execvp, another way would be to create a separate char* argv[]
                        num_subproc ++ ; // Number of parallel processes increased by 1
                        if (fork() == 0) {
                            setpgid(0, fore_pgid); // If we get a SIGINT in between, we need to handle it correctly
                            execvp(*(tokens+prev), (tokens+prev)); // Execute the current command
                            printf("Shell: Incorrect Command : %s\n",*(tokens+prev));
							exit(0);
                        }
                        else {
                            // wait(null) not needed
                            prev = i + 1; // Index updated

                        }
                        continue;
                    }
                    // Remember, we still have the final command left, so let's execute that too
                    if( fork() == 0 ) {
                        execvp(*(tokens+prev),tokens+prev);
                        printf("Shell: Incorrect Command : %s\n",tokens[0]);
                        exit(0);
                    }
                    else {

                        for(int i = 0 ; i < num_subproc ; i++){
                            wait(NULL);
                        }
                        // Must have as many wait statements as the processes we created
                        // For && we were reaping instantly, for &&& we incremented the counter
                    }
                    exit(0);
                }
            }
            else {
                if (background == -1) {
                    fore_pgid = cpid; // update value of fore_pgid (for SIGINT to work properly)
                    waitpid(cpid, NULL, 0); // 
                }
                else if (back_num == 1 ) back_pgid = cpid; // Update value of back_pgid if it is the first background process
                fore_pgid = -1; // Foreground process reaped, so set to -1 again
            }

        }
        else {
            // the command is cd, so no need to fork (we want the current main shell to change its default directory)
            if (background > 0) {
                printf("Shell: cd cannot be executed in background :\n");
				free_mem(tokens);
				continue;
            }
            if (!tokens[1] || tokens[2]) {
                // First argument is null, or the second argument contains data
                printf("Shell: Incorrect Command : %s\n",tokens[0]);
            }
            else {
                int ret = chdir(tokens[1]); // to change the directory to the location specified
                if (ret) {
                    printf("Shell: Incorrect Command : %s\n",tokens[0]);
                }
            }
        }
        free_mem(tokens);
    }
}