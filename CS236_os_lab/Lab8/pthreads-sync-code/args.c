#include <pthread.h>
#include <stdio.h>
#include <assert.h>

#define N_threads 10

int counter = 0;
pthread_mutex_t mutex;

void *hello(void *arg){
    pthread_mutex_lock(&mutex);
    printf("I am thread %d\n",*(int *)arg);
    pthread_mutex_unlock(&mutex);
    return NULL;
}

int main(){
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