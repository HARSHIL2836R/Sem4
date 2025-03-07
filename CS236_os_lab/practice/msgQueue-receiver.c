#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <string.h>

struct msg_buffer {
    long msg_type;
    char msg_text[8];
};

int main() {
    key_t key = 1236;
    int msg_id = msgget(key, 0666);
    printf("Msg_id = %d\n",msg_id);
    struct msg_buffer message;

    printf("Val = %ld\n",msgrcv(msg_id, &message, sizeof(message.msg_text), 2, 0));
    printf("Received: %s\n", message.msg_text);

    message.msg_type = 2;
    // strcpy(message.msg_text, "Hello from Receiver!");

    // msgsnd(msg_id, &message, sizeof(message.msg_text), 0);

    return 0;
}
