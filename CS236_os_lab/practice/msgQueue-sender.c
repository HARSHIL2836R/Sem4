#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <string.h>

struct msg_buffer {
    // long msg_type;
    char msg_text[100];
};

int main() {
    key_t key = 1235;
    int msg_id = msgget(key, 0666 | IPC_CREAT);
    struct msg_buffer message;

    // message.msg_type = 2;
    
    strcpy(message.msg_text, "Hello from Sender!");

    if (msgsnd(msg_id, &message, sizeof(message.msg_text),0)<0)
        printf("Error in send\n");
    printf("Message sent.\n");

    // printf("Val = %ld\n",msgrcv(msg_id, &message, sizeof(message.msg_text), 2, 0));
    // printf("Received: %s\n", message.msg_text);

    return 0;
}
