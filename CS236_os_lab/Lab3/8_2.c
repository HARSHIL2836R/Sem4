#include <signal.h>
#include <stdio.h>
#include <stdlib.h>

void signal_handler(int sig){
    printf("\nI will run forever\n");
}

int main(int argc, char *argv[]){
    while (1){
        signal(SIGINT,signal_handler);
    }
}