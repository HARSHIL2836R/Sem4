#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#define SOCK_PATH "example_socket"
int main(char argc, char *argv){
    int socketfd = socket(AF_UNIX,SOCK_DGRAM,0);
    struct sockaddr_un serv_addr, cli_addr;
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sun_family = AF_UNIX;
    strcpy(serv_addr.sun_path,SOCK_PATH);
    if (bind(socketfd,(const struct sockaddr*)&serv_addr,sizeof(serv_addr))<0)
        printf("Bind error\n");
    char buf[100];
    bzero(buf, sizeof buf);
    int len = sizeof(cli_addr);
    recvfrom(socketfd, buf,sizeof buf,0,(struct sockaddr * restrict)&cli_addr,&len);
    printf("Message recieved: %s\n",buf);
    unlink(SOCK_PATH);
}