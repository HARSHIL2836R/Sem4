/**
 * Simple program demonstrating shared memory in POSIX systems.
 *
 * This is the producer process that writes to the shared memory region.
 *
 * Figure 3.17
 *
 * @author Silberschatz, Galvin, and Gagne
 * Operating System Concepts  - Ninth Edition
 * Copyright John Wiley & Sons - 2013
 */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/types.h>

#define MY_PIPE "my_pipe"
#define THEIR_PIPE "their_pipe"

int main()
{
	const int SIZE = 4096;
	const char *name = "OS";
	const char *my_free = "freeeee";

	int shm_fd;
	void *ptr;

	/* create the shared memory segment */
	shm_fd = shm_open(name, O_CREAT | O_RDWR, 0666);

	/* configure the size of the shared memory segment */
	ftruncate(shm_fd,SIZE);

	/* now map the shared memory segment in the address space of the process */
	ptr = mmap(0,SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);
	if (ptr == MAP_FAILED) {
		printf("Map failed\n");
		return -1;
	}

	/**
	 * Now write to the shared memory region.
 	 *
	 * Note we must increment the value of ptr after each write.
	 */
	void *old_ptr = ptr;
	for (int i=0;i<512;i++){
		sprintf(ptr,"%s",my_free);
		ptr += 8;
	}

	if (mkfifo(MY_PIPE, 0666) < 0)
		perror("Pipe not formed\n");
	if (mkfifo(THEIR_PIPE, 0666) < 0)
		perror("Pipe not formed\n");

	int fd = open(MY_PIPE, O_WRONLY);
	int to_read = open(THEIR_PIPE, O_RDONLY);

	ptr = old_ptr;
	char *my_str = "OSisFUN";
	int temp;
	for (int i=0;i<1000;i++){
		snprintf(ptr,8,"%s",my_str);
		int offset = ptr - old_ptr;
		write(fd, (void*)&offset, 4);
		ptr += 8;
		if (ptr-old_ptr >= SIZE) ptr = old_ptr;
		// do{
		// 	read(to_read,temp,sizeof temp);
		// }
		// while(*temp!=i);
		read(to_read,(void*)&temp,sizeof temp);
		printf("%d\n",i);
	}
	int done=-1;
	write(fd, (void*)&done, 4);

	close(fd);
	close(to_read);

	unlink(MY_PIPE);
	unlink(THEIR_PIPE);

	return 0;
}
