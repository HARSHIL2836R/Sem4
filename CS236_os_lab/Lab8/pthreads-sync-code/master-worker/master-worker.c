#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <wait.h>
#include <pthread.h>
#include <unistd.h>

#define EMPTY -1

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t empty = PTHREAD_COND_INITIALIZER;
pthread_cond_t full = PTHREAD_COND_INITIALIZER;

int item_to_produce, curr_buf_size;
int total_items, max_buf_size, num_workers, num_masters;
int items_consumed;
int *buffer;

void print_produced(int num, int master, void *ptr) {

  printf("Produced %d by master %d %p\n", num, master,ptr);
}

void print_consumed(int num, int worker) {

  printf("Consumed %d by worker %d\n", num, worker);
  
}

//produce items and place in buffer
//modify code below to synchronize correctly
void *generate_requests_loop(void *data)
{
  int thread_id = *((int *)data);

  while(1)
    {
      pthread_mutex_lock(&mutex);
      if(item_to_produce >= total_items) {
        printf("broadcasting by %d\n",thread_id);
        pthread_cond_broadcast(&empty);
        break;
      } 
      
      while (curr_buf_size >= max_buf_size)
      {
        printf("me so raha hu %d\n",thread_id);
        pthread_cond_wait(&full,&mutex);
        printf("me uth gaya hu %d \n",thread_id);
      }

      buffer[curr_buf_size++] = item_to_produce;
      print_produced(item_to_produce, thread_id,buffer+curr_buf_size-1);
      pthread_cond_signal(&empty);
      printf("curr_buff_size:%d, max_buff_size:%d, items_to_produce:%d\n",curr_buf_size,max_buf_size,item_to_produce);
      item_to_produce++;

      pthread_mutex_unlock(&mutex);
    }
  return 0;
}

void *consume(void *data)
{
  int thread_id = *(int *)data;
  int run = 1;
  int temp;

  while(run)
  {
    pthread_mutex_lock(&mutex);

    while(curr_buf_size < 0)
      {
        printf("waiting\n");
        pthread_cond_wait(&empty,&mutex);
        printf("uth gaya\n");
      }

    while (curr_buf_size >= 0)
    {
      if(curr_buf_size>=max_buf_size)curr_buf_size--;
      temp = buffer[curr_buf_size];
      buffer[curr_buf_size--] = EMPTY;
      print_consumed(temp,thread_id);
      printf("curr_buff_size:%d, max_buff_size:%d, items_consumed:%d\n",1+curr_buf_size,max_buf_size,items_consumed);
      // pthread_cond_signal(&full);
      pthread_cond_broadcast(&full);
      items_consumed++;
      if (items_consumed >= total_items)
        {
          printf("ran wway\n");
          pthread_cond_broadcast(&full);
          run = 0;
          break;
        }
    }
    printf("just here\n");
    pthread_mutex_unlock(&mutex);
  }

  return NULL;
}

//write function to be run by worker threads
//ensure that the workers call the function print_consumed when they consume an item

int main(int argc, char *argv[])
{
  int *master_thread_id;
  pthread_t *master_thread;
  item_to_produce = 0;
  items_consumed = 0;
  curr_buf_size = 0;
  
  int i;
  
   if (argc < 5) {
    printf("./master-worker #total_items #max_buf_size #num_workers #masters e.g. ./exe 10000 1000 4 3\n");
    exit(1);
  }
  else {
    num_masters = atoi(argv[4]);
    num_workers = atoi(argv[3]);
    total_items = atoi(argv[1]);
    max_buf_size = atoi(argv[2]);
  }
    

   buffer = (int *)malloc (sizeof(int) * max_buf_size);
   printf("%p\n",buffer);

   //create master producer threads
   master_thread_id = (int *)malloc(sizeof(int) * num_masters);
   master_thread = (pthread_t *)malloc(sizeof(pthread_t) * num_masters);
  for (i = 0; i < num_masters; i++)
    master_thread_id[i] = i;

  for (i = 0; i < num_masters; i++)
    pthread_create(&master_thread[i], NULL, generate_requests_loop, (void *)&master_thread_id[i]);
  
  //create worker consumer threads
  int *consumer_thread_id = (int *)malloc(sizeof(int) * num_workers);
  pthread_t *consumer_thread = (pthread_t *)malloc(sizeof(pthread_t) * num_workers);
  for (i = 0; i< num_workers;i++)
    consumer_thread_id[i] = i;

  for (i = 0;i<num_workers;i++)
    pthread_create(&consumer_thread[i],NULL,consume, (void *)&consumer_thread_id[i]);
  
  //wait for all threads to complete
  for (i = 0; i < num_masters; i++)
    {
      pthread_join(master_thread[i], NULL);
      printf("master %d joined\n", i);
    }

  for (i = 0; i < num_workers; i++)
    {
      pthread_join(consumer_thread[i], NULL);
      printf("consumer %d joined\n", i);
    }
  
  /*----Deallocating Buffers---------------------*/
  free(buffer);
  free(master_thread_id);
  free(master_thread);
  free(consumer_thread);
  free(consumer_thread_id);
  
  return 0;
}
