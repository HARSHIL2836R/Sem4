#include <pthread.h>
#include <stdio.h>
#include <assert.h>

#define N_threads 20
#define runs 10000

int counter = 0;
pthread_mutex_t mutex;

void *hello(void *arg){
    printf("Hello\n");
    return NULL;
}

void *increment(void *arg){
    for (int i=0;i<runs;i++)
        counter++;
    return NULL;
}

void *increment_with_lock(void *arg){
    pthread_mutex_lock(&mutex);
    for (int i=0;i<runs;i++)
    counter++;
    pthread_mutex_unlock(&mutex);
    return NULL;
}

int main(){
    pthread_t thread;
    if (pthread_create(&thread,NULL,hello,NULL) != 0)
        perror("thread not created");
    int ret = pthread_join(thread,NULL);
    assert(ret == 0);

    pthread_t my_threads[N_threads];
    for(int i=0;i<N_threads;i++)
    {
        if (pthread_create(&my_threads[i],NULL,increment,NULL) != 0)
            perror("Thread not created");
    }

    for (int i = 0; i < N_threads; i++)
    {
        ret = pthread_join(my_threads[i],NULL);
        assert(ret == 0);
    }

    printf("Counter without locking increment: %d\n",counter);
    
    counter = 0;
    
    for(int i=0;i<N_threads;i++)
    {
        if (pthread_create(&my_threads[i],NULL,increment_with_lock,NULL) != 0)
        perror("Thread not created");
    }
    
    for (int i = 0; i < N_threads; i++)
    {
        ret = pthread_join(my_threads[i],NULL);
        assert(ret == 0);
    }
    printf("Counter with locking increment: %d\n",counter);
    
    return 0;
}