#include <pthread.h>
#include <stdio.h>
#include <assert.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>

#define N_threads 10

int count = 0;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cv[N_threads] = {PTHREAD_COND_INITIALIZER};

void *hello(void *arg){
    int secs = (10 * random())/(RAND_MAX-1);
    pthread_mutex_lock(&mutex);
    int i = *(int *)arg;
    while (count != i)
    {
        pthread_cond_wait(&cv[i],&mutex);
    }
    sleep(secs);
    printf("I am thread %d slept for %d secs\n",*(int *)arg,secs);
    count++;
    pthread_cond_signal(&cv[i+1]);
    pthread_mutex_unlock(&mutex);
    return NULL;
}

int main(){
    srand(time(NULL));
    pthread_t my_threads[N_threads];
    int ret;
    int nums[N_threads];
    for (int i = 0; i < N_threads; i++)
    {
        nums[i] = i;
    }

    for(int i=0;i<N_threads;i++)
    {
        if (pthread_create(&my_threads[i],NULL,hello,(void *)&nums[i]) != 0)
            perror("Thread not created");
    }

    for (int i = 0; i < N_threads; i++)
    {
        ret = pthread_join(my_threads[i],NULL);
        assert(ret == 0);
    }

    printf("I am the main thread\n");

    return 0;
}