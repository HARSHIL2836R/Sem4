#include <stdio.h>
#include <unistd.h>

int main(){
    close(STDOUT_FILENO);
    printf("HI\n"); // Where would it print???
    close(STDIN_FILENO);
    char h[100];
    scanf("%[^\n]",h); // Where would it take input from

    // On running the program just closes
}