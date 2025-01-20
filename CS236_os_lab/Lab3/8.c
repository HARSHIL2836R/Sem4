#include <signal.h>
#include <stdio.h>
#include <stdlib.h>

void signal_handler(int sig){
    printf("I will run forever\n");// You need to end line other wise it'll be stored in buffer but never printed because the program gets killed by SIGQUIT
}

int main(int argc, char *argv[]){
    signal(SIGINT,signal_handler);
    while (1);
}