#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <wait.h>
#include "zemaphore.h"

void zem_init(zem_t *s, int value) {
    s->counter = value;
}

void zem_down(zem_t *s) {
    pthread_mutex_lock(&s->lock);
    if (--(s->counter) < 0)
        {
            // printf("waiting\n");
            pthread_cond_wait(&s->cond,&s->lock);
        }
    // printf("not waiitng\n");
    pthread_mutex_unlock(&s->lock);
}

void zem_up(zem_t *s) {
    pthread_mutex_lock(&s->lock);
    s->counter++;
    pthread_mutex_unlock(&s->lock);
    pthread_cond_signal(&s->cond);
}
