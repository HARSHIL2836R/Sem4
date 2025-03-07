#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#define SOCK_PATH "example_socket"
int main(){
    int socketfd = socket(AF_UNIX,SOCK_DGRAM,0);
    struct sockaddr_un serv_addr;
    serv_addr.sun_family = AF_UNIX;
    strcpy(serv_addr.sun_path,SOCK_PATH);
    int len = sizeof(serv_addr);
    char buf[100];
    bzero(buf, sizeof(buf));
    strcpy(buf,"Harshil is here");
    sendto(socketfd,buf,sizeof(buf)-1,0,(struct sockaddr*)&serv_addr,(unsigned int) len);
    close(socketfd);
}