
_myTest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fcntl.h"

int num = 5;

int main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  printf(1, "Hello, world!\n");
  11:	83 ec 08             	sub    $0x8,%esp
  14:	68 b4 0a 00 00       	push   $0xab4
  19:	6a 01                	push   $0x1
  1b:	e8 da 06 00 00       	call   6fa <printf>
  20:	83 c4 10             	add    $0x10,%esp
  printf(1,"The number of free pages before I allocate 2 is : %d, call this x\n",getNumFreePages());
  23:	e8 f6 05 00 00       	call   61e <getNumFreePages>
  28:	83 ec 04             	sub    $0x4,%esp
  2b:	50                   	push   %eax
  2c:	68 c4 0a 00 00       	push   $0xac4
  31:	6a 01                	push   $0x1
  33:	e8 c2 06 00 00       	call   6fa <printf>
  38:	83 c4 10             	add    $0x10,%esp
  char* mem = sbrk(8192);
  3b:	83 ec 0c             	sub    $0xc,%esp
  3e:	68 00 20 00 00       	push   $0x2000
  43:	e8 be 05 00 00       	call   606 <sbrk>
  48:	83 c4 10             	add    $0x10,%esp
  4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int* tmp = (int*)mem;
  4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  tmp[0] = 5;
  54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  57:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  printf(1,"The number of free pages after I allocate 2 is : %d, should be x-2\n",getNumFreePages());
  5d:	e8 bc 05 00 00       	call   61e <getNumFreePages>
  62:	83 ec 04             	sub    $0x4,%esp
  65:	50                   	push   %eax
  66:	68 08 0b 00 00       	push   $0xb08
  6b:	6a 01                	push   $0x1
  6d:	e8 88 06 00 00       	call   6fa <printf>
  72:	83 c4 10             	add    $0x10,%esp
  int n = fork();
  75:	e8 fc 04 00 00       	call   576 <fork>
  7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (n == 0) {
  7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  81:	0f 85 ac 00 00 00    	jne    133 <main+0x133>
    sleep(50);
  87:	83 ec 0c             	sub    $0xc,%esp
  8a:	6a 32                	push   $0x32
  8c:	e8 7d 05 00 00       	call   60e <sleep>
  91:	83 c4 10             	add    $0x10,%esp

    printf(1,"Child 2: Num = %d (should be 5), number of free pages = %d, should be z-2\n",num,getNumFreePages());
  94:	e8 85 05 00 00       	call   61e <getNumFreePages>
  99:	8b 15 30 13 00 00    	mov    0x1330,%edx
  9f:	50                   	push   %eax
  a0:	52                   	push   %edx
  a1:	68 4c 0b 00 00       	push   $0xb4c
  a6:	6a 01                	push   $0x1
  a8:	e8 4d 06 00 00       	call   6fa <printf>
  ad:	83 c4 10             	add    $0x10,%esp
    printf(1,"Child 2: Incrementing num\n");
  b0:	83 ec 08             	sub    $0x8,%esp
  b3:	68 97 0b 00 00       	push   $0xb97
  b8:	6a 01                	push   $0x1
  ba:	e8 3b 06 00 00       	call   6fa <printf>
  bf:	83 c4 10             	add    $0x10,%esp
    num++;
  c2:	a1 30 13 00 00       	mov    0x1330,%eax
  c7:	83 c0 01             	add    $0x1,%eax
  ca:	a3 30 13 00 00       	mov    %eax,0x1330
    printf(1,"Child 2: Num = %d (should be 6), number of free pages = %d, should be z-2\n",num,getNumFreePages());
  cf:	e8 4a 05 00 00       	call   61e <getNumFreePages>
  d4:	8b 15 30 13 00 00    	mov    0x1330,%edx
  da:	50                   	push   %eax
  db:	52                   	push   %edx
  dc:	68 b4 0b 00 00       	push   $0xbb4
  e1:	6a 01                	push   $0x1
  e3:	e8 12 06 00 00       	call   6fa <printf>
  e8:	83 c4 10             	add    $0x10,%esp
    printf(1,"Child 2: mem[0] = %d (should be 5), number of free pages = %d, should be z-2\n",tmp[0],getNumFreePages());
  eb:	e8 2e 05 00 00       	call   61e <getNumFreePages>
  f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  f3:	8b 12                	mov    (%edx),%edx
  f5:	50                   	push   %eax
  f6:	52                   	push   %edx
  f7:	68 00 0c 00 00       	push   $0xc00
  fc:	6a 01                	push   $0x1
  fe:	e8 f7 05 00 00       	call   6fa <printf>
 103:	83 c4 10             	add    $0x10,%esp
    tmp[0]++;
 106:	8b 45 f0             	mov    -0x10(%ebp),%eax
 109:	8b 00                	mov    (%eax),%eax
 10b:	8d 50 01             	lea    0x1(%eax),%edx
 10e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 111:	89 10                	mov    %edx,(%eax)
    printf(1,"Child 2: Incremented mem[0], now it is %d (should be 6), number of free pages = %d, should be z-2\n",tmp[0],getNumFreePages());      
 113:	e8 06 05 00 00       	call   61e <getNumFreePages>
 118:	8b 55 f0             	mov    -0x10(%ebp),%edx
 11b:	8b 12                	mov    (%edx),%edx
 11d:	50                   	push   %eax
 11e:	52                   	push   %edx
 11f:	68 50 0c 00 00       	push   $0xc50
 124:	6a 01                	push   $0x1
 126:	e8 cf 05 00 00       	call   6fa <printf>
 12b:	83 c4 10             	add    $0x10,%esp
    exit();
 12e:	e8 4b 04 00 00       	call   57e <exit>

  }
  else {
    int r = fork();
 133:	e8 3e 04 00 00       	call   576 <fork>
 138:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (r == 0) {
 13b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 13f:	0f 85 9f 00 00 00    	jne    1e4 <main+0x1e4>

      printf(1,"Child 1: num is %d (should be 5), the number of free pages = %d, call this y < x\n",num,getNumFreePages());
 145:	e8 d4 04 00 00       	call   61e <getNumFreePages>
 14a:	8b 15 30 13 00 00    	mov    0x1330,%edx
 150:	50                   	push   %eax
 151:	52                   	push   %edx
 152:	68 b4 0c 00 00       	push   $0xcb4
 157:	6a 01                	push   $0x1
 159:	e8 9c 05 00 00       	call   6fa <printf>
 15e:	83 c4 10             	add    $0x10,%esp
      printf(1,"Child 1: Incrementing num\n");
 161:	83 ec 08             	sub    $0x8,%esp
 164:	68 06 0d 00 00       	push   $0xd06
 169:	6a 01                	push   $0x1
 16b:	e8 8a 05 00 00       	call   6fa <printf>
 170:	83 c4 10             	add    $0x10,%esp
      num++;
 173:	a1 30 13 00 00       	mov    0x1330,%eax
 178:	83 c0 01             	add    $0x1,%eax
 17b:	a3 30 13 00 00       	mov    %eax,0x1330
      printf(1,"Child 1: num is %d (should be 6), the number of free pages = %d, should be y-1\n",num,getNumFreePages());
 180:	e8 99 04 00 00       	call   61e <getNumFreePages>
 185:	8b 15 30 13 00 00    	mov    0x1330,%edx
 18b:	50                   	push   %eax
 18c:	52                   	push   %edx
 18d:	68 24 0d 00 00       	push   $0xd24
 192:	6a 01                	push   $0x1
 194:	e8 61 05 00 00       	call   6fa <printf>
 199:	83 c4 10             	add    $0x10,%esp
      printf(1,"Child 1: mem[0] = %d (should be 5), number of free pages = %d, should be y-1\n",tmp[0],getNumFreePages());
 19c:	e8 7d 04 00 00       	call   61e <getNumFreePages>
 1a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
 1a4:	8b 12                	mov    (%edx),%edx
 1a6:	50                   	push   %eax
 1a7:	52                   	push   %edx
 1a8:	68 74 0d 00 00       	push   $0xd74
 1ad:	6a 01                	push   $0x1
 1af:	e8 46 05 00 00       	call   6fa <printf>
 1b4:	83 c4 10             	add    $0x10,%esp
      tmp[0]++;
 1b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1ba:	8b 00                	mov    (%eax),%eax
 1bc:	8d 50 01             	lea    0x1(%eax),%edx
 1bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1c2:	89 10                	mov    %edx,(%eax)
      printf(1,"Child 1: Incremented mem[0], now it is %d (should be 6), number of free pages = %d, should be y-2\n",tmp[0],getNumFreePages());
 1c4:	e8 55 04 00 00       	call   61e <getNumFreePages>
 1c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
 1cc:	8b 12                	mov    (%edx),%edx
 1ce:	50                   	push   %eax
 1cf:	52                   	push   %edx
 1d0:	68 c4 0d 00 00       	push   $0xdc4
 1d5:	6a 01                	push   $0x1
 1d7:	e8 1e 05 00 00       	call   6fa <printf>
 1dc:	83 c4 10             	add    $0x10,%esp
      exit();
 1df:	e8 9a 03 00 00       	call   57e <exit>
    
    }
    else {

      wait();
 1e4:	e8 9d 03 00 00       	call   586 <wait>
      printf(1,"Parent: Num = %d (should be 5), number of free pages = %d, call this z < x, z > y\n",num,getNumFreePages());
 1e9:	e8 30 04 00 00       	call   61e <getNumFreePages>
 1ee:	8b 15 30 13 00 00    	mov    0x1330,%edx
 1f4:	50                   	push   %eax
 1f5:	52                   	push   %edx
 1f6:	68 28 0e 00 00       	push   $0xe28
 1fb:	6a 01                	push   $0x1
 1fd:	e8 f8 04 00 00       	call   6fa <printf>
 202:	83 c4 10             	add    $0x10,%esp
      printf(1,"Parent: Incrementing num\n");
 205:	83 ec 08             	sub    $0x8,%esp
 208:	68 7b 0e 00 00       	push   $0xe7b
 20d:	6a 01                	push   $0x1
 20f:	e8 e6 04 00 00       	call   6fa <printf>
 214:	83 c4 10             	add    $0x10,%esp
      num++;
 217:	a1 30 13 00 00       	mov    0x1330,%eax
 21c:	83 c0 01             	add    $0x1,%eax
 21f:	a3 30 13 00 00       	mov    %eax,0x1330
      printf(1,"Parent: Num = %d (should be 6), number of free pages = %d, should be z-1\n",num,getNumFreePages());
 224:	e8 f5 03 00 00       	call   61e <getNumFreePages>
 229:	8b 15 30 13 00 00    	mov    0x1330,%edx
 22f:	50                   	push   %eax
 230:	52                   	push   %edx
 231:	68 98 0e 00 00       	push   $0xe98
 236:	6a 01                	push   $0x1
 238:	e8 bd 04 00 00       	call   6fa <printf>
 23d:	83 c4 10             	add    $0x10,%esp
      printf(1,"Parent: mem[0] = %d (should be 5), number of free pages = %d, should be z-1\n",tmp[0],getNumFreePages());
 240:	e8 d9 03 00 00       	call   61e <getNumFreePages>
 245:	8b 55 f0             	mov    -0x10(%ebp),%edx
 248:	8b 12                	mov    (%edx),%edx
 24a:	50                   	push   %eax
 24b:	52                   	push   %edx
 24c:	68 e4 0e 00 00       	push   $0xee4
 251:	6a 01                	push   $0x1
 253:	e8 a2 04 00 00       	call   6fa <printf>
 258:	83 c4 10             	add    $0x10,%esp
      tmp[0]++;
 25b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 25e:	8b 00                	mov    (%eax),%eax
 260:	8d 50 01             	lea    0x1(%eax),%edx
 263:	8b 45 f0             	mov    -0x10(%ebp),%eax
 266:	89 10                	mov    %edx,(%eax)
      printf(1,"Parent: Incremented mem[0], now it is %d (should be 6), number of free pages = %d, should be z-2\n",tmp[0],getNumFreePages());     
 268:	e8 b1 03 00 00       	call   61e <getNumFreePages>
 26d:	8b 55 f0             	mov    -0x10(%ebp),%edx
 270:	8b 12                	mov    (%edx),%edx
 272:	50                   	push   %eax
 273:	52                   	push   %edx
 274:	68 34 0f 00 00       	push   $0xf34
 279:	6a 01                	push   $0x1
 27b:	e8 7a 04 00 00       	call   6fa <printf>
 280:	83 c4 10             	add    $0x10,%esp
      
      wait();
 283:	e8 fe 02 00 00       	call   586 <wait>
      printf(1,"Parent: Num = %d (should be 6), number of free pages = %d, should be x-2\n",num,getNumFreePages());
 288:	e8 91 03 00 00       	call   61e <getNumFreePages>
 28d:	8b 15 30 13 00 00    	mov    0x1330,%edx
 293:	50                   	push   %eax
 294:	52                   	push   %edx
 295:	68 98 0f 00 00       	push   $0xf98
 29a:	6a 01                	push   $0x1
 29c:	e8 59 04 00 00       	call   6fa <printf>
 2a1:	83 c4 10             	add    $0x10,%esp
      printf(1,"Parent: Incrementing num\n");
 2a4:	83 ec 08             	sub    $0x8,%esp
 2a7:	68 7b 0e 00 00       	push   $0xe7b
 2ac:	6a 01                	push   $0x1
 2ae:	e8 47 04 00 00       	call   6fa <printf>
 2b3:	83 c4 10             	add    $0x10,%esp
      num++;
 2b6:	a1 30 13 00 00       	mov    0x1330,%eax
 2bb:	83 c0 01             	add    $0x1,%eax
 2be:	a3 30 13 00 00       	mov    %eax,0x1330
      printf(1,"Parent: Num = %d (should be 7), number of free pages = %d, should be x-2\n",num,getNumFreePages());
 2c3:	e8 56 03 00 00       	call   61e <getNumFreePages>
 2c8:	8b 15 30 13 00 00    	mov    0x1330,%edx
 2ce:	50                   	push   %eax
 2cf:	52                   	push   %edx
 2d0:	68 e4 0f 00 00       	push   $0xfe4
 2d5:	6a 01                	push   $0x1
 2d7:	e8 1e 04 00 00       	call   6fa <printf>
 2dc:	83 c4 10             	add    $0x10,%esp
      printf(1,"Parent: mem[0] = %d (should be 6), number of free pages = %d, should be x-2\n",tmp[0],getNumFreePages());
 2df:	e8 3a 03 00 00       	call   61e <getNumFreePages>
 2e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
 2e7:	8b 12                	mov    (%edx),%edx
 2e9:	50                   	push   %eax
 2ea:	52                   	push   %edx
 2eb:	68 30 10 00 00       	push   $0x1030
 2f0:	6a 01                	push   $0x1
 2f2:	e8 03 04 00 00       	call   6fa <printf>
 2f7:	83 c4 10             	add    $0x10,%esp
      tmp[0]++;
 2fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2fd:	8b 00                	mov    (%eax),%eax
 2ff:	8d 50 01             	lea    0x1(%eax),%edx
 302:	8b 45 f0             	mov    -0x10(%ebp),%eax
 305:	89 10                	mov    %edx,(%eax)
      printf(1,"Parent: Incremented mem[0], now it is %d (should be 7), number of free pages = %d, should be x-2\n",tmp[0],getNumFreePages());     
 307:	e8 12 03 00 00       	call   61e <getNumFreePages>
 30c:	8b 55 f0             	mov    -0x10(%ebp),%edx
 30f:	8b 12                	mov    (%edx),%edx
 311:	50                   	push   %eax
 312:	52                   	push   %edx
 313:	68 80 10 00 00       	push   $0x1080
 318:	6a 01                	push   $0x1
 31a:	e8 db 03 00 00       	call   6fa <printf>
 31f:	83 c4 10             	add    $0x10,%esp
      exit();
 322:	e8 57 02 00 00       	call   57e <exit>

00000327 <stosb>:
  stosb(dst, c, n);
  return dst;
}

char*
strchr(const char *s, char c)
 327:	55                   	push   %ebp
 328:	89 e5                	mov    %esp,%ebp
 32a:	57                   	push   %edi
 32b:	53                   	push   %ebx
{
 32c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 32f:	8b 55 10             	mov    0x10(%ebp),%edx
 332:	8b 45 0c             	mov    0xc(%ebp),%eax
 335:	89 cb                	mov    %ecx,%ebx
 337:	89 df                	mov    %ebx,%edi
 339:	89 d1                	mov    %edx,%ecx
 33b:	fc                   	cld
 33c:	f3 aa                	rep stos %al,%es:(%edi)
 33e:	89 ca                	mov    %ecx,%edx
 340:	89 fb                	mov    %edi,%ebx
 342:	89 5d 08             	mov    %ebx,0x8(%ebp)
 345:	89 55 10             	mov    %edx,0x10(%ebp)
  for(; *s; s++)
    if(*s == c)
      return (char*)s;
  return 0;
 348:	90                   	nop
 349:	5b                   	pop    %ebx
 34a:	5f                   	pop    %edi
 34b:	5d                   	pop    %ebp
 34c:	c3                   	ret

0000034d <strcpy>:
{
 34d:	55                   	push   %ebp
 34e:	89 e5                	mov    %esp,%ebp
 350:	83 ec 10             	sub    $0x10,%esp
  os = s;
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 359:	90                   	nop
 35a:	8b 55 0c             	mov    0xc(%ebp),%edx
 35d:	8d 42 01             	lea    0x1(%edx),%eax
 360:	89 45 0c             	mov    %eax,0xc(%ebp)
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	8d 48 01             	lea    0x1(%eax),%ecx
 369:	89 4d 08             	mov    %ecx,0x8(%ebp)
 36c:	0f b6 12             	movzbl (%edx),%edx
 36f:	88 10                	mov    %dl,(%eax)
 371:	0f b6 00             	movzbl (%eax),%eax
 374:	84 c0                	test   %al,%al
 376:	75 e2                	jne    35a <strcpy+0xd>
  return os;
 378:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 37b:	c9                   	leave
 37c:	c3                   	ret

0000037d <strcmp>:
{
 37d:	55                   	push   %ebp
 37e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 380:	eb 08                	jmp    38a <strcmp+0xd>
    p++, q++;
 382:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 386:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 38a:	8b 45 08             	mov    0x8(%ebp),%eax
 38d:	0f b6 00             	movzbl (%eax),%eax
 390:	84 c0                	test   %al,%al
 392:	74 10                	je     3a4 <strcmp+0x27>
 394:	8b 45 08             	mov    0x8(%ebp),%eax
 397:	0f b6 10             	movzbl (%eax),%edx
 39a:	8b 45 0c             	mov    0xc(%ebp),%eax
 39d:	0f b6 00             	movzbl (%eax),%eax
 3a0:	38 c2                	cmp    %al,%dl
 3a2:	74 de                	je     382 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 3a4:	8b 45 08             	mov    0x8(%ebp),%eax
 3a7:	0f b6 00             	movzbl (%eax),%eax
 3aa:	0f b6 d0             	movzbl %al,%edx
 3ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b0:	0f b6 00             	movzbl (%eax),%eax
 3b3:	0f b6 c0             	movzbl %al,%eax
 3b6:	29 c2                	sub    %eax,%edx
 3b8:	89 d0                	mov    %edx,%eax
}
 3ba:	5d                   	pop    %ebp
 3bb:	c3                   	ret

000003bc <strlen>:
{
 3bc:	55                   	push   %ebp
 3bd:	89 e5                	mov    %esp,%ebp
 3bf:	83 ec 10             	sub    $0x10,%esp
  for(n = 0; s[n]; n++)
 3c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3c9:	eb 04                	jmp    3cf <strlen+0x13>
 3cb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d2:	8b 45 08             	mov    0x8(%ebp),%eax
 3d5:	01 d0                	add    %edx,%eax
 3d7:	0f b6 00             	movzbl (%eax),%eax
 3da:	84 c0                	test   %al,%al
 3dc:	75 ed                	jne    3cb <strlen+0xf>
  return n;
 3de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e1:	c9                   	leave
 3e2:	c3                   	ret

000003e3 <memset>:
{
 3e3:	55                   	push   %ebp
 3e4:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3e6:	8b 45 10             	mov    0x10(%ebp),%eax
 3e9:	50                   	push   %eax
 3ea:	ff 75 0c             	push   0xc(%ebp)
 3ed:	ff 75 08             	push   0x8(%ebp)
 3f0:	e8 32 ff ff ff       	call   327 <stosb>
 3f5:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3fb:	c9                   	leave
 3fc:	c3                   	ret

000003fd <strchr>:
{
 3fd:	55                   	push   %ebp
 3fe:	89 e5                	mov    %esp,%ebp
 400:	83 ec 04             	sub    $0x4,%esp
 403:	8b 45 0c             	mov    0xc(%ebp),%eax
 406:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 409:	eb 14                	jmp    41f <strchr+0x22>
    if(*s == c)
 40b:	8b 45 08             	mov    0x8(%ebp),%eax
 40e:	0f b6 00             	movzbl (%eax),%eax
 411:	38 45 fc             	cmp    %al,-0x4(%ebp)
 414:	75 05                	jne    41b <strchr+0x1e>
      return (char*)s;
 416:	8b 45 08             	mov    0x8(%ebp),%eax
 419:	eb 13                	jmp    42e <strchr+0x31>
  for(; *s; s++)
 41b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
 422:	0f b6 00             	movzbl (%eax),%eax
 425:	84 c0                	test   %al,%al
 427:	75 e2                	jne    40b <strchr+0xe>
  return 0;
 429:	b8 00 00 00 00       	mov    $0x0,%eax
}
 42e:	c9                   	leave
 42f:	c3                   	ret

00000430 <gets>:

char*
gets(char *buf, int max)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 436:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 43d:	eb 42                	jmp    481 <gets+0x51>
    cc = read(0, &c, 1);
 43f:	83 ec 04             	sub    $0x4,%esp
 442:	6a 01                	push   $0x1
 444:	8d 45 ef             	lea    -0x11(%ebp),%eax
 447:	50                   	push   %eax
 448:	6a 00                	push   $0x0
 44a:	e8 47 01 00 00       	call   596 <read>
 44f:	83 c4 10             	add    $0x10,%esp
 452:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 455:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 459:	7e 33                	jle    48e <gets+0x5e>
      break;
    buf[i++] = c;
 45b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45e:	8d 50 01             	lea    0x1(%eax),%edx
 461:	89 55 f4             	mov    %edx,-0xc(%ebp)
 464:	89 c2                	mov    %eax,%edx
 466:	8b 45 08             	mov    0x8(%ebp),%eax
 469:	01 c2                	add    %eax,%edx
 46b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 46f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 471:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 475:	3c 0a                	cmp    $0xa,%al
 477:	74 16                	je     48f <gets+0x5f>
 479:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 47d:	3c 0d                	cmp    $0xd,%al
 47f:	74 0e                	je     48f <gets+0x5f>
  for(i=0; i+1 < max; ){
 481:	8b 45 f4             	mov    -0xc(%ebp),%eax
 484:	83 c0 01             	add    $0x1,%eax
 487:	39 45 0c             	cmp    %eax,0xc(%ebp)
 48a:	7f b3                	jg     43f <gets+0xf>
 48c:	eb 01                	jmp    48f <gets+0x5f>
      break;
 48e:	90                   	nop
      break;
  }
  buf[i] = '\0';
 48f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 492:	8b 45 08             	mov    0x8(%ebp),%eax
 495:	01 d0                	add    %edx,%eax
 497:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 49d:	c9                   	leave
 49e:	c3                   	ret

0000049f <stat>:

int
stat(const char *n, struct stat *st)
{
 49f:	55                   	push   %ebp
 4a0:	89 e5                	mov    %esp,%ebp
 4a2:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4a5:	83 ec 08             	sub    $0x8,%esp
 4a8:	6a 00                	push   $0x0
 4aa:	ff 75 08             	push   0x8(%ebp)
 4ad:	e8 0c 01 00 00       	call   5be <open>
 4b2:	83 c4 10             	add    $0x10,%esp
 4b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4bc:	79 07                	jns    4c5 <stat+0x26>
    return -1;
 4be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4c3:	eb 25                	jmp    4ea <stat+0x4b>
  r = fstat(fd, st);
 4c5:	83 ec 08             	sub    $0x8,%esp
 4c8:	ff 75 0c             	push   0xc(%ebp)
 4cb:	ff 75 f4             	push   -0xc(%ebp)
 4ce:	e8 03 01 00 00       	call   5d6 <fstat>
 4d3:	83 c4 10             	add    $0x10,%esp
 4d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4d9:	83 ec 0c             	sub    $0xc,%esp
 4dc:	ff 75 f4             	push   -0xc(%ebp)
 4df:	e8 c2 00 00 00       	call   5a6 <close>
 4e4:	83 c4 10             	add    $0x10,%esp
  return r;
 4e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4ea:	c9                   	leave
 4eb:	c3                   	ret

000004ec <atoi>:

int
atoi(const char *s)
{
 4ec:	55                   	push   %ebp
 4ed:	89 e5                	mov    %esp,%ebp
 4ef:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4f9:	eb 25                	jmp    520 <atoi+0x34>
    n = n*10 + *s++ - '0';
 4fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4fe:	89 d0                	mov    %edx,%eax
 500:	c1 e0 02             	shl    $0x2,%eax
 503:	01 d0                	add    %edx,%eax
 505:	01 c0                	add    %eax,%eax
 507:	89 c1                	mov    %eax,%ecx
 509:	8b 45 08             	mov    0x8(%ebp),%eax
 50c:	8d 50 01             	lea    0x1(%eax),%edx
 50f:	89 55 08             	mov    %edx,0x8(%ebp)
 512:	0f b6 00             	movzbl (%eax),%eax
 515:	0f be c0             	movsbl %al,%eax
 518:	01 c8                	add    %ecx,%eax
 51a:	83 e8 30             	sub    $0x30,%eax
 51d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 520:	8b 45 08             	mov    0x8(%ebp),%eax
 523:	0f b6 00             	movzbl (%eax),%eax
 526:	3c 2f                	cmp    $0x2f,%al
 528:	7e 0a                	jle    534 <atoi+0x48>
 52a:	8b 45 08             	mov    0x8(%ebp),%eax
 52d:	0f b6 00             	movzbl (%eax),%eax
 530:	3c 39                	cmp    $0x39,%al
 532:	7e c7                	jle    4fb <atoi+0xf>
  return n;
 534:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 537:	c9                   	leave
 538:	c3                   	ret

00000539 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 539:	55                   	push   %ebp
 53a:	89 e5                	mov    %esp,%ebp
 53c:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 53f:	8b 45 08             	mov    0x8(%ebp),%eax
 542:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 545:	8b 45 0c             	mov    0xc(%ebp),%eax
 548:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 54b:	eb 17                	jmp    564 <memmove+0x2b>
    *dst++ = *src++;
 54d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 550:	8d 42 01             	lea    0x1(%edx),%eax
 553:	89 45 f8             	mov    %eax,-0x8(%ebp)
 556:	8b 45 fc             	mov    -0x4(%ebp),%eax
 559:	8d 48 01             	lea    0x1(%eax),%ecx
 55c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 55f:	0f b6 12             	movzbl (%edx),%edx
 562:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 564:	8b 45 10             	mov    0x10(%ebp),%eax
 567:	8d 50 ff             	lea    -0x1(%eax),%edx
 56a:	89 55 10             	mov    %edx,0x10(%ebp)
 56d:	85 c0                	test   %eax,%eax
 56f:	7f dc                	jg     54d <memmove+0x14>
  return vdst;
 571:	8b 45 08             	mov    0x8(%ebp),%eax
}
 574:	c9                   	leave
 575:	c3                   	ret

00000576 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 576:	b8 01 00 00 00       	mov    $0x1,%eax
 57b:	cd 40                	int    $0x40
 57d:	c3                   	ret

0000057e <exit>:
SYSCALL(exit)
 57e:	b8 02 00 00 00       	mov    $0x2,%eax
 583:	cd 40                	int    $0x40
 585:	c3                   	ret

00000586 <wait>:
SYSCALL(wait)
 586:	b8 03 00 00 00       	mov    $0x3,%eax
 58b:	cd 40                	int    $0x40
 58d:	c3                   	ret

0000058e <pipe>:
SYSCALL(pipe)
 58e:	b8 04 00 00 00       	mov    $0x4,%eax
 593:	cd 40                	int    $0x40
 595:	c3                   	ret

00000596 <read>:
SYSCALL(read)
 596:	b8 05 00 00 00       	mov    $0x5,%eax
 59b:	cd 40                	int    $0x40
 59d:	c3                   	ret

0000059e <write>:
SYSCALL(write)
 59e:	b8 10 00 00 00       	mov    $0x10,%eax
 5a3:	cd 40                	int    $0x40
 5a5:	c3                   	ret

000005a6 <close>:
SYSCALL(close)
 5a6:	b8 15 00 00 00       	mov    $0x15,%eax
 5ab:	cd 40                	int    $0x40
 5ad:	c3                   	ret

000005ae <kill>:
SYSCALL(kill)
 5ae:	b8 06 00 00 00       	mov    $0x6,%eax
 5b3:	cd 40                	int    $0x40
 5b5:	c3                   	ret

000005b6 <exec>:
SYSCALL(exec)
 5b6:	b8 07 00 00 00       	mov    $0x7,%eax
 5bb:	cd 40                	int    $0x40
 5bd:	c3                   	ret

000005be <open>:
SYSCALL(open)
 5be:	b8 0f 00 00 00       	mov    $0xf,%eax
 5c3:	cd 40                	int    $0x40
 5c5:	c3                   	ret

000005c6 <mknod>:
SYSCALL(mknod)
 5c6:	b8 11 00 00 00       	mov    $0x11,%eax
 5cb:	cd 40                	int    $0x40
 5cd:	c3                   	ret

000005ce <unlink>:
SYSCALL(unlink)
 5ce:	b8 12 00 00 00       	mov    $0x12,%eax
 5d3:	cd 40                	int    $0x40
 5d5:	c3                   	ret

000005d6 <fstat>:
SYSCALL(fstat)
 5d6:	b8 08 00 00 00       	mov    $0x8,%eax
 5db:	cd 40                	int    $0x40
 5dd:	c3                   	ret

000005de <link>:
SYSCALL(link)
 5de:	b8 13 00 00 00       	mov    $0x13,%eax
 5e3:	cd 40                	int    $0x40
 5e5:	c3                   	ret

000005e6 <mkdir>:
SYSCALL(mkdir)
 5e6:	b8 14 00 00 00       	mov    $0x14,%eax
 5eb:	cd 40                	int    $0x40
 5ed:	c3                   	ret

000005ee <chdir>:
SYSCALL(chdir)
 5ee:	b8 09 00 00 00       	mov    $0x9,%eax
 5f3:	cd 40                	int    $0x40
 5f5:	c3                   	ret

000005f6 <dup>:
SYSCALL(dup)
 5f6:	b8 0a 00 00 00       	mov    $0xa,%eax
 5fb:	cd 40                	int    $0x40
 5fd:	c3                   	ret

000005fe <getpid>:
SYSCALL(getpid)
 5fe:	b8 0b 00 00 00       	mov    $0xb,%eax
 603:	cd 40                	int    $0x40
 605:	c3                   	ret

00000606 <sbrk>:
SYSCALL(sbrk)
 606:	b8 0c 00 00 00       	mov    $0xc,%eax
 60b:	cd 40                	int    $0x40
 60d:	c3                   	ret

0000060e <sleep>:
SYSCALL(sleep)
 60e:	b8 0d 00 00 00       	mov    $0xd,%eax
 613:	cd 40                	int    $0x40
 615:	c3                   	ret

00000616 <uptime>:
SYSCALL(uptime)
 616:	b8 0e 00 00 00       	mov    $0xe,%eax
 61b:	cd 40                	int    $0x40
 61d:	c3                   	ret

0000061e <getNumFreePages>:
SYSCALL(getNumFreePages)
 61e:	b8 16 00 00 00       	mov    $0x16,%eax
 623:	cd 40                	int    $0x40
 625:	c3                   	ret

00000626 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 626:	55                   	push   %ebp
 627:	89 e5                	mov    %esp,%ebp
 629:	83 ec 18             	sub    $0x18,%esp
 62c:	8b 45 0c             	mov    0xc(%ebp),%eax
 62f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 632:	83 ec 04             	sub    $0x4,%esp
 635:	6a 01                	push   $0x1
 637:	8d 45 f4             	lea    -0xc(%ebp),%eax
 63a:	50                   	push   %eax
 63b:	ff 75 08             	push   0x8(%ebp)
 63e:	e8 5b ff ff ff       	call   59e <write>
 643:	83 c4 10             	add    $0x10,%esp
}
 646:	90                   	nop
 647:	c9                   	leave
 648:	c3                   	ret

00000649 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 649:	55                   	push   %ebp
 64a:	89 e5                	mov    %esp,%ebp
 64c:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 64f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 656:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 65a:	74 17                	je     673 <printint+0x2a>
 65c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 660:	79 11                	jns    673 <printint+0x2a>
    neg = 1;
 662:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 669:	8b 45 0c             	mov    0xc(%ebp),%eax
 66c:	f7 d8                	neg    %eax
 66e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 671:	eb 06                	jmp    679 <printint+0x30>
  } else {
    x = xx;
 673:	8b 45 0c             	mov    0xc(%ebp),%eax
 676:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 679:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 680:	8b 4d 10             	mov    0x10(%ebp),%ecx
 683:	8b 45 ec             	mov    -0x14(%ebp),%eax
 686:	ba 00 00 00 00       	mov    $0x0,%edx
 68b:	f7 f1                	div    %ecx
 68d:	89 d1                	mov    %edx,%ecx
 68f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 692:	8d 50 01             	lea    0x1(%eax),%edx
 695:	89 55 f4             	mov    %edx,-0xc(%ebp)
 698:	0f b6 91 34 13 00 00 	movzbl 0x1334(%ecx),%edx
 69f:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 6a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a9:	ba 00 00 00 00       	mov    $0x0,%edx
 6ae:	f7 f1                	div    %ecx
 6b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6b7:	75 c7                	jne    680 <printint+0x37>
  if(neg)
 6b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6bd:	74 2d                	je     6ec <printint+0xa3>
    buf[i++] = '-';
 6bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c2:	8d 50 01             	lea    0x1(%eax),%edx
 6c5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6c8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6cd:	eb 1d                	jmp    6ec <printint+0xa3>
    putc(fd, buf[i]);
 6cf:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d5:	01 d0                	add    %edx,%eax
 6d7:	0f b6 00             	movzbl (%eax),%eax
 6da:	0f be c0             	movsbl %al,%eax
 6dd:	83 ec 08             	sub    $0x8,%esp
 6e0:	50                   	push   %eax
 6e1:	ff 75 08             	push   0x8(%ebp)
 6e4:	e8 3d ff ff ff       	call   626 <putc>
 6e9:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 6ec:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f4:	79 d9                	jns    6cf <printint+0x86>
}
 6f6:	90                   	nop
 6f7:	90                   	nop
 6f8:	c9                   	leave
 6f9:	c3                   	ret

000006fa <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6fa:	55                   	push   %ebp
 6fb:	89 e5                	mov    %esp,%ebp
 6fd:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 700:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 707:	8d 45 0c             	lea    0xc(%ebp),%eax
 70a:	83 c0 04             	add    $0x4,%eax
 70d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 710:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 717:	e9 59 01 00 00       	jmp    875 <printf+0x17b>
    c = fmt[i] & 0xff;
 71c:	8b 55 0c             	mov    0xc(%ebp),%edx
 71f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 722:	01 d0                	add    %edx,%eax
 724:	0f b6 00             	movzbl (%eax),%eax
 727:	0f be c0             	movsbl %al,%eax
 72a:	25 ff 00 00 00       	and    $0xff,%eax
 72f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 732:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 736:	75 2c                	jne    764 <printf+0x6a>
      if(c == '%'){
 738:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 73c:	75 0c                	jne    74a <printf+0x50>
        state = '%';
 73e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 745:	e9 27 01 00 00       	jmp    871 <printf+0x177>
      } else {
        putc(fd, c);
 74a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 74d:	0f be c0             	movsbl %al,%eax
 750:	83 ec 08             	sub    $0x8,%esp
 753:	50                   	push   %eax
 754:	ff 75 08             	push   0x8(%ebp)
 757:	e8 ca fe ff ff       	call   626 <putc>
 75c:	83 c4 10             	add    $0x10,%esp
 75f:	e9 0d 01 00 00       	jmp    871 <printf+0x177>
      }
    } else if(state == '%'){
 764:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 768:	0f 85 03 01 00 00    	jne    871 <printf+0x177>
      if(c == 'd'){
 76e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 772:	75 1e                	jne    792 <printf+0x98>
        printint(fd, *ap, 10, 1);
 774:	8b 45 e8             	mov    -0x18(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	6a 01                	push   $0x1
 77b:	6a 0a                	push   $0xa
 77d:	50                   	push   %eax
 77e:	ff 75 08             	push   0x8(%ebp)
 781:	e8 c3 fe ff ff       	call   649 <printint>
 786:	83 c4 10             	add    $0x10,%esp
        ap++;
 789:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 78d:	e9 d8 00 00 00       	jmp    86a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 792:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 796:	74 06                	je     79e <printf+0xa4>
 798:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 79c:	75 1e                	jne    7bc <printf+0xc2>
        printint(fd, *ap, 16, 0);
 79e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a1:	8b 00                	mov    (%eax),%eax
 7a3:	6a 00                	push   $0x0
 7a5:	6a 10                	push   $0x10
 7a7:	50                   	push   %eax
 7a8:	ff 75 08             	push   0x8(%ebp)
 7ab:	e8 99 fe ff ff       	call   649 <printint>
 7b0:	83 c4 10             	add    $0x10,%esp
        ap++;
 7b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7b7:	e9 ae 00 00 00       	jmp    86a <printf+0x170>
      } else if(c == 's'){
 7bc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7c0:	75 43                	jne    805 <printf+0x10b>
        s = (char*)*ap;
 7c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c5:	8b 00                	mov    (%eax),%eax
 7c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d2:	75 25                	jne    7f9 <printf+0xff>
          s = "(null)";
 7d4:	c7 45 f4 e2 10 00 00 	movl   $0x10e2,-0xc(%ebp)
        while(*s != 0){
 7db:	eb 1c                	jmp    7f9 <printf+0xff>
          putc(fd, *s);
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	0f b6 00             	movzbl (%eax),%eax
 7e3:	0f be c0             	movsbl %al,%eax
 7e6:	83 ec 08             	sub    $0x8,%esp
 7e9:	50                   	push   %eax
 7ea:	ff 75 08             	push   0x8(%ebp)
 7ed:	e8 34 fe ff ff       	call   626 <putc>
 7f2:	83 c4 10             	add    $0x10,%esp
          s++;
 7f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	0f b6 00             	movzbl (%eax),%eax
 7ff:	84 c0                	test   %al,%al
 801:	75 da                	jne    7dd <printf+0xe3>
 803:	eb 65                	jmp    86a <printf+0x170>
        }
      } else if(c == 'c'){
 805:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 809:	75 1d                	jne    828 <printf+0x12e>
        putc(fd, *ap);
 80b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80e:	8b 00                	mov    (%eax),%eax
 810:	0f be c0             	movsbl %al,%eax
 813:	83 ec 08             	sub    $0x8,%esp
 816:	50                   	push   %eax
 817:	ff 75 08             	push   0x8(%ebp)
 81a:	e8 07 fe ff ff       	call   626 <putc>
 81f:	83 c4 10             	add    $0x10,%esp
        ap++;
 822:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 826:	eb 42                	jmp    86a <printf+0x170>
      } else if(c == '%'){
 828:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 82c:	75 17                	jne    845 <printf+0x14b>
        putc(fd, c);
 82e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 831:	0f be c0             	movsbl %al,%eax
 834:	83 ec 08             	sub    $0x8,%esp
 837:	50                   	push   %eax
 838:	ff 75 08             	push   0x8(%ebp)
 83b:	e8 e6 fd ff ff       	call   626 <putc>
 840:	83 c4 10             	add    $0x10,%esp
 843:	eb 25                	jmp    86a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 845:	83 ec 08             	sub    $0x8,%esp
 848:	6a 25                	push   $0x25
 84a:	ff 75 08             	push   0x8(%ebp)
 84d:	e8 d4 fd ff ff       	call   626 <putc>
 852:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 858:	0f be c0             	movsbl %al,%eax
 85b:	83 ec 08             	sub    $0x8,%esp
 85e:	50                   	push   %eax
 85f:	ff 75 08             	push   0x8(%ebp)
 862:	e8 bf fd ff ff       	call   626 <putc>
 867:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 86a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 871:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 875:	8b 55 0c             	mov    0xc(%ebp),%edx
 878:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87b:	01 d0                	add    %edx,%eax
 87d:	0f b6 00             	movzbl (%eax),%eax
 880:	84 c0                	test   %al,%al
 882:	0f 85 94 fe ff ff    	jne    71c <printf+0x22>
    }
  }
}
 888:	90                   	nop
 889:	90                   	nop
 88a:	c9                   	leave
 88b:	c3                   	ret

0000088c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 88c:	55                   	push   %ebp
 88d:	89 e5                	mov    %esp,%ebp
 88f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 892:	8b 45 08             	mov    0x8(%ebp),%eax
 895:	83 e8 08             	sub    $0x8,%eax
 898:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89b:	a1 50 13 00 00       	mov    0x1350,%eax
 8a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8a3:	eb 24                	jmp    8c9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a8:	8b 00                	mov    (%eax),%eax
 8aa:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8ad:	72 12                	jb     8c1 <free+0x35>
 8af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b2:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8b5:	72 24                	jb     8db <free+0x4f>
 8b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ba:	8b 00                	mov    (%eax),%eax
 8bc:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8bf:	72 1a                	jb     8db <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c4:	8b 00                	mov    (%eax),%eax
 8c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cc:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8cf:	73 d4                	jae    8a5 <free+0x19>
 8d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d4:	8b 00                	mov    (%eax),%eax
 8d6:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8d9:	73 ca                	jae    8a5 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8de:	8b 40 04             	mov    0x4(%eax),%eax
 8e1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8eb:	01 c2                	add    %eax,%edx
 8ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f0:	8b 00                	mov    (%eax),%eax
 8f2:	39 c2                	cmp    %eax,%edx
 8f4:	75 24                	jne    91a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f9:	8b 50 04             	mov    0x4(%eax),%edx
 8fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ff:	8b 00                	mov    (%eax),%eax
 901:	8b 40 04             	mov    0x4(%eax),%eax
 904:	01 c2                	add    %eax,%edx
 906:	8b 45 f8             	mov    -0x8(%ebp),%eax
 909:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 90c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90f:	8b 00                	mov    (%eax),%eax
 911:	8b 10                	mov    (%eax),%edx
 913:	8b 45 f8             	mov    -0x8(%ebp),%eax
 916:	89 10                	mov    %edx,(%eax)
 918:	eb 0a                	jmp    924 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 91a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91d:	8b 10                	mov    (%eax),%edx
 91f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 922:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 924:	8b 45 fc             	mov    -0x4(%ebp),%eax
 927:	8b 40 04             	mov    0x4(%eax),%eax
 92a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 931:	8b 45 fc             	mov    -0x4(%ebp),%eax
 934:	01 d0                	add    %edx,%eax
 936:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 939:	75 20                	jne    95b <free+0xcf>
    p->s.size += bp->s.size;
 93b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93e:	8b 50 04             	mov    0x4(%eax),%edx
 941:	8b 45 f8             	mov    -0x8(%ebp),%eax
 944:	8b 40 04             	mov    0x4(%eax),%eax
 947:	01 c2                	add    %eax,%edx
 949:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 94f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 952:	8b 10                	mov    (%eax),%edx
 954:	8b 45 fc             	mov    -0x4(%ebp),%eax
 957:	89 10                	mov    %edx,(%eax)
 959:	eb 08                	jmp    963 <free+0xd7>
  } else
    p->s.ptr = bp;
 95b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 961:	89 10                	mov    %edx,(%eax)
  freep = p;
 963:	8b 45 fc             	mov    -0x4(%ebp),%eax
 966:	a3 50 13 00 00       	mov    %eax,0x1350
}
 96b:	90                   	nop
 96c:	c9                   	leave
 96d:	c3                   	ret

0000096e <morecore>:

static Header*
morecore(uint nu)
{
 96e:	55                   	push   %ebp
 96f:	89 e5                	mov    %esp,%ebp
 971:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 974:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 97b:	77 07                	ja     984 <morecore+0x16>
    nu = 4096;
 97d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 984:	8b 45 08             	mov    0x8(%ebp),%eax
 987:	c1 e0 03             	shl    $0x3,%eax
 98a:	83 ec 0c             	sub    $0xc,%esp
 98d:	50                   	push   %eax
 98e:	e8 73 fc ff ff       	call   606 <sbrk>
 993:	83 c4 10             	add    $0x10,%esp
 996:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 999:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 99d:	75 07                	jne    9a6 <morecore+0x38>
    return 0;
 99f:	b8 00 00 00 00       	mov    $0x0,%eax
 9a4:	eb 26                	jmp    9cc <morecore+0x5e>
  hp = (Header*)p;
 9a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9af:	8b 55 08             	mov    0x8(%ebp),%edx
 9b2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b8:	83 c0 08             	add    $0x8,%eax
 9bb:	83 ec 0c             	sub    $0xc,%esp
 9be:	50                   	push   %eax
 9bf:	e8 c8 fe ff ff       	call   88c <free>
 9c4:	83 c4 10             	add    $0x10,%esp
  return freep;
 9c7:	a1 50 13 00 00       	mov    0x1350,%eax
}
 9cc:	c9                   	leave
 9cd:	c3                   	ret

000009ce <malloc>:

void*
malloc(uint nbytes)
{
 9ce:	55                   	push   %ebp
 9cf:	89 e5                	mov    %esp,%ebp
 9d1:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d4:	8b 45 08             	mov    0x8(%ebp),%eax
 9d7:	83 c0 07             	add    $0x7,%eax
 9da:	c1 e8 03             	shr    $0x3,%eax
 9dd:	83 c0 01             	add    $0x1,%eax
 9e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9e3:	a1 50 13 00 00       	mov    0x1350,%eax
 9e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9ef:	75 23                	jne    a14 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9f1:	c7 45 f0 48 13 00 00 	movl   $0x1348,-0x10(%ebp)
 9f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fb:	a3 50 13 00 00       	mov    %eax,0x1350
 a00:	a1 50 13 00 00       	mov    0x1350,%eax
 a05:	a3 48 13 00 00       	mov    %eax,0x1348
    base.s.size = 0;
 a0a:	c7 05 4c 13 00 00 00 	movl   $0x0,0x134c
 a11:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a17:	8b 00                	mov    (%eax),%eax
 a19:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1f:	8b 40 04             	mov    0x4(%eax),%eax
 a22:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a25:	72 4d                	jb     a74 <malloc+0xa6>
      if(p->s.size == nunits)
 a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2a:	8b 40 04             	mov    0x4(%eax),%eax
 a2d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a30:	75 0c                	jne    a3e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a35:	8b 10                	mov    (%eax),%edx
 a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3a:	89 10                	mov    %edx,(%eax)
 a3c:	eb 26                	jmp    a64 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a41:	8b 40 04             	mov    0x4(%eax),%eax
 a44:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a47:	89 c2                	mov    %eax,%edx
 a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a52:	8b 40 04             	mov    0x4(%eax),%eax
 a55:	c1 e0 03             	shl    $0x3,%eax
 a58:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a61:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a67:	a3 50 13 00 00       	mov    %eax,0x1350
      return (void*)(p + 1);
 a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6f:	83 c0 08             	add    $0x8,%eax
 a72:	eb 3b                	jmp    aaf <malloc+0xe1>
    }
    if(p == freep)
 a74:	a1 50 13 00 00       	mov    0x1350,%eax
 a79:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a7c:	75 1e                	jne    a9c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a7e:	83 ec 0c             	sub    $0xc,%esp
 a81:	ff 75 ec             	push   -0x14(%ebp)
 a84:	e8 e5 fe ff ff       	call   96e <morecore>
 a89:	83 c4 10             	add    $0x10,%esp
 a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a93:	75 07                	jne    a9c <malloc+0xce>
        return 0;
 a95:	b8 00 00 00 00       	mov    $0x0,%eax
 a9a:	eb 13                	jmp    aaf <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa5:	8b 00                	mov    (%eax),%eax
 aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 aaa:	e9 6d ff ff ff       	jmp    a1c <malloc+0x4e>
  }
}
 aaf:	c9                   	leave
 ab0:	c3                   	ret
