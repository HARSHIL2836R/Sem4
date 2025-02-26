/**
 * Simple program demonstrating shared memory in POSIX systems.
 *
 * This is the consumer process
 *
 * Figure 3.18
 *
 * @author Gagne, Galvin, Silberschatz
 * Operating System Concepts - Ninth Edition
 * Copyright John Wiley & Sons - 2013
 */

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>

#define MY_PIPE "my_pipe"
#define THEIR_PIPE "their_pipe"

int main()
{
	const char *name = "OS";
	const int SIZE = 4096;

	int shm_fd;
	void *ptr;
	int i;

	/* open the shared memory segment */
	shm_fd = shm_open(name, O_RDWR, 0666);
	if (shm_fd == -1) {
		printf("shared memory failed\n");
		exit(-1);
	}

	/* now map the shared memory segment in the address space of the process */
	ptr = mmap(0,SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);
	if (ptr == MAP_FAILED) {
		printf("Map failed\n");
		exit(-1);
	}

	/* now read from the shared memory region */
	// printf("%s", (char *)ptr);
	int fd = open(MY_PIPE, O_RDONLY);
	if(fd < 0)
		perror("Error in opening read pipe\n");
	int to_write = open(THEIR_PIPE, O_WRONLY);
	if(to_write <0)
		perror("Error in opening read pipe\n");

	int count = 0;
	// char *my_free = malloc(8);
	const char *my_free = "freeeee";
	const char *my_str = "OSisFUN";
	void *old_ptr = ptr;
	while (1){
		int addr;
		if (read(fd,(void *)&addr,sizeof addr)<0)
			perror("Read error\n");
		if (addr == -1) break;
		count += 1;
		snprintf(old_ptr+addr,8,"%s",my_free);
		if (write(to_write,(void *)&addr,sizeof addr)<0)
			perror("Read error\n");
			
		printf("%d\n",addr);
		// sleep(1);
	}

	close(fd);
	close(to_write);

	unlink(MY_PIPE);
	unlink(THEIR_PIPE);

	printf("Everything Done\n");
	// fgetc(stdin);

	/* remove the shared memory segment */
	if (shm_unlink(name) == -1) {
		printf("Error removing %s\n",name);
		exit(-1);
	}

	return 0;
}
// Use watch -n 0.2 xxd /dev/shm/OS to view live memory layout
