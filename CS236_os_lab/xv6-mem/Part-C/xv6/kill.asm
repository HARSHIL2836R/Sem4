
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 fc 07 00 00       	push   $0x7fc
  21:	6a 02                	push   $0x2
  23:	e8 1d 04 00 00       	call   445 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 99 02 00 00       	call   2c9 <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2d                	jmp    66 <main+0x66>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e4 01 00 00       	call   237 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 9a 02 00 00       	call   2f9 <kill>
  5f:	83 c4 10             	add    $0x10,%esp
  for(i=1; i<argc; i++)
  62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	3b 03                	cmp    (%ebx),%eax
  6b:	7c cc                	jl     39 <main+0x39>
  exit();
  6d:	e8 57 02 00 00       	call   2c9 <exit>

00000072 <stosb>:
  stosb(dst, c, n);
  return dst;
}

char*
strchr(const char *s, char c)
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	57                   	push   %edi
  76:	53                   	push   %ebx
{
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	8b 55 10             	mov    0x10(%ebp),%edx
  7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  80:	89 cb                	mov    %ecx,%ebx
  82:	89 df                	mov    %ebx,%edi
  84:	89 d1                	mov    %edx,%ecx
  86:	fc                   	cld
  87:	f3 aa                	rep stos %al,%es:(%edi)
  89:	89 ca                	mov    %ecx,%edx
  8b:	89 fb                	mov    %edi,%ebx
  8d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  90:	89 55 10             	mov    %edx,0x10(%ebp)
  for(; *s; s++)
    if(*s == c)
      return (char*)s;
  return 0;
  93:	90                   	nop
  94:	5b                   	pop    %ebx
  95:	5f                   	pop    %edi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret

00000098 <strcpy>:
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	83 ec 10             	sub    $0x10,%esp
  os = s;
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a4:	90                   	nop
  a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  a8:	8d 42 01             	lea    0x1(%edx),%eax
  ab:	89 45 0c             	mov    %eax,0xc(%ebp)
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	8d 48 01             	lea    0x1(%eax),%ecx
  b4:	89 4d 08             	mov    %ecx,0x8(%ebp)
  b7:	0f b6 12             	movzbl (%edx),%edx
  ba:	88 10                	mov    %dl,(%eax)
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	75 e2                	jne    a5 <strcpy+0xd>
  return os;
  c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c6:	c9                   	leave
  c7:	c3                   	ret

000000c8 <strcmp>:
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cb:	eb 08                	jmp    d5 <strcmp+0xd>
    p++, q++;
  cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	74 10                	je     ef <strcmp+0x27>
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	0f b6 10             	movzbl (%eax),%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	0f b6 00             	movzbl (%eax),%eax
  eb:	38 c2                	cmp    %al,%dl
  ed:	74 de                	je     cd <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	0f b6 d0             	movzbl %al,%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	0f b6 c0             	movzbl %al,%eax
 101:	29 c2                	sub    %eax,%edx
 103:	89 d0                	mov    %edx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret

00000107 <strlen>:
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	83 ec 10             	sub    $0x10,%esp
  for(n = 0; s[n]; n++)
 10d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 114:	eb 04                	jmp    11a <strlen+0x13>
 116:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	01 d0                	add    %edx,%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 ed                	jne    116 <strlen+0xf>
  return n;
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12c:	c9                   	leave
 12d:	c3                   	ret

0000012e <memset>:
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 131:	8b 45 10             	mov    0x10(%ebp),%eax
 134:	50                   	push   %eax
 135:	ff 75 0c             	push   0xc(%ebp)
 138:	ff 75 08             	push   0x8(%ebp)
 13b:	e8 32 ff ff ff       	call   72 <stosb>
 140:	83 c4 0c             	add    $0xc,%esp
  return dst;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
}
 146:	c9                   	leave
 147:	c3                   	ret

00000148 <strchr>:
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	83 ec 04             	sub    $0x4,%esp
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 154:	eb 14                	jmp    16a <strchr+0x22>
    if(*s == c)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	38 45 fc             	cmp    %al,-0x4(%ebp)
 15f:	75 05                	jne    166 <strchr+0x1e>
      return (char*)s;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	eb 13                	jmp    179 <strchr+0x31>
  for(; *s; s++)
 166:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	84 c0                	test   %al,%al
 172:	75 e2                	jne    156 <strchr+0xe>
  return 0;
 174:	b8 00 00 00 00       	mov    $0x0,%eax
}
 179:	c9                   	leave
 17a:	c3                   	ret

0000017b <gets>:

char*
gets(char *buf, int max)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 188:	eb 42                	jmp    1cc <gets+0x51>
    cc = read(0, &c, 1);
 18a:	83 ec 04             	sub    $0x4,%esp
 18d:	6a 01                	push   $0x1
 18f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 192:	50                   	push   %eax
 193:	6a 00                	push   $0x0
 195:	e8 47 01 00 00       	call   2e1 <read>
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a4:	7e 33                	jle    1d9 <gets+0x5e>
      break;
    buf[i++] = c;
 1a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a9:	8d 50 01             	lea    0x1(%eax),%edx
 1ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1af:	89 c2                	mov    %eax,%edx
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	01 c2                	add    %eax,%edx
 1b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ba:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c0:	3c 0a                	cmp    $0xa,%al
 1c2:	74 16                	je     1da <gets+0x5f>
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	74 0e                	je     1da <gets+0x5f>
  for(i=0; i+1 < max; ){
 1cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cf:	83 c0 01             	add    $0x1,%eax
 1d2:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1d5:	7f b3                	jg     18a <gets+0xf>
 1d7:	eb 01                	jmp    1da <gets+0x5f>
      break;
 1d9:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave
 1e9:	c3                   	ret

000001ea <stat>:

int
stat(const char *n, struct stat *st)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 00                	push   $0x0
 1f5:	ff 75 08             	push   0x8(%ebp)
 1f8:	e8 0c 01 00 00       	call   309 <open>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 207:	79 07                	jns    210 <stat+0x26>
    return -1;
 209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20e:	eb 25                	jmp    235 <stat+0x4b>
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	push   0xc(%ebp)
 216:	ff 75 f4             	push   -0xc(%ebp)
 219:	e8 03 01 00 00       	call   321 <fstat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 224:	83 ec 0c             	sub    $0xc,%esp
 227:	ff 75 f4             	push   -0xc(%ebp)
 22a:	e8 c2 00 00 00       	call   2f1 <close>
 22f:	83 c4 10             	add    $0x10,%esp
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave
 236:	c3                   	ret

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 244:	eb 25                	jmp    26b <atoi+0x34>
    n = n*10 + *s++ - '0';
 246:	8b 55 fc             	mov    -0x4(%ebp),%edx
 249:	89 d0                	mov    %edx,%eax
 24b:	c1 e0 02             	shl    $0x2,%eax
 24e:	01 d0                	add    %edx,%eax
 250:	01 c0                	add    %eax,%eax
 252:	89 c1                	mov    %eax,%ecx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8d 50 01             	lea    0x1(%eax),%edx
 25a:	89 55 08             	mov    %edx,0x8(%ebp)
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	0f be c0             	movsbl %al,%eax
 263:	01 c8                	add    %ecx,%eax
 265:	83 e8 30             	sub    $0x30,%eax
 268:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	3c 2f                	cmp    $0x2f,%al
 273:	7e 0a                	jle    27f <atoi+0x48>
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	3c 39                	cmp    $0x39,%al
 27d:	7e c7                	jle    246 <atoi+0xf>
  return n;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 282:	c9                   	leave
 283:	c3                   	ret

00000284 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 296:	eb 17                	jmp    2af <memmove+0x2b>
    *dst++ = *src++;
 298:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29b:	8d 42 01             	lea    0x1(%edx),%eax
 29e:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a4:	8d 48 01             	lea    0x1(%eax),%ecx
 2a7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2aa:	0f b6 12             	movzbl (%edx),%edx
 2ad:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
 2b2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b5:	89 55 10             	mov    %edx,0x10(%ebp)
 2b8:	85 c0                	test   %eax,%eax
 2ba:	7f dc                	jg     298 <memmove+0x14>
  return vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave
 2c0:	c3                   	ret

000002c1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c1:	b8 01 00 00 00       	mov    $0x1,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret

000002c9 <exit>:
SYSCALL(exit)
 2c9:	b8 02 00 00 00       	mov    $0x2,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret

000002d1 <wait>:
SYSCALL(wait)
 2d1:	b8 03 00 00 00       	mov    $0x3,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret

000002d9 <pipe>:
SYSCALL(pipe)
 2d9:	b8 04 00 00 00       	mov    $0x4,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret

000002e1 <read>:
SYSCALL(read)
 2e1:	b8 05 00 00 00       	mov    $0x5,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret

000002e9 <write>:
SYSCALL(write)
 2e9:	b8 10 00 00 00       	mov    $0x10,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret

000002f1 <close>:
SYSCALL(close)
 2f1:	b8 15 00 00 00       	mov    $0x15,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret

000002f9 <kill>:
SYSCALL(kill)
 2f9:	b8 06 00 00 00       	mov    $0x6,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret

00000301 <exec>:
SYSCALL(exec)
 301:	b8 07 00 00 00       	mov    $0x7,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret

00000309 <open>:
SYSCALL(open)
 309:	b8 0f 00 00 00       	mov    $0xf,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret

00000311 <mknod>:
SYSCALL(mknod)
 311:	b8 11 00 00 00       	mov    $0x11,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret

00000319 <unlink>:
SYSCALL(unlink)
 319:	b8 12 00 00 00       	mov    $0x12,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret

00000321 <fstat>:
SYSCALL(fstat)
 321:	b8 08 00 00 00       	mov    $0x8,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret

00000329 <link>:
SYSCALL(link)
 329:	b8 13 00 00 00       	mov    $0x13,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret

00000331 <mkdir>:
SYSCALL(mkdir)
 331:	b8 14 00 00 00       	mov    $0x14,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret

00000339 <chdir>:
SYSCALL(chdir)
 339:	b8 09 00 00 00       	mov    $0x9,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret

00000341 <dup>:
SYSCALL(dup)
 341:	b8 0a 00 00 00       	mov    $0xa,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret

00000349 <getpid>:
SYSCALL(getpid)
 349:	b8 0b 00 00 00       	mov    $0xb,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret

00000351 <sbrk>:
SYSCALL(sbrk)
 351:	b8 0c 00 00 00       	mov    $0xc,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret

00000359 <sleep>:
SYSCALL(sleep)
 359:	b8 0d 00 00 00       	mov    $0xd,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret

00000361 <uptime>:
SYSCALL(uptime)
 361:	b8 0e 00 00 00       	mov    $0xe,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret

00000369 <getNumFreePages>:
SYSCALL(getNumFreePages)
 369:	b8 16 00 00 00       	mov    $0x16,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret

00000371 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 371:	55                   	push   %ebp
 372:	89 e5                	mov    %esp,%ebp
 374:	83 ec 18             	sub    $0x18,%esp
 377:	8b 45 0c             	mov    0xc(%ebp),%eax
 37a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 37d:	83 ec 04             	sub    $0x4,%esp
 380:	6a 01                	push   $0x1
 382:	8d 45 f4             	lea    -0xc(%ebp),%eax
 385:	50                   	push   %eax
 386:	ff 75 08             	push   0x8(%ebp)
 389:	e8 5b ff ff ff       	call   2e9 <write>
 38e:	83 c4 10             	add    $0x10,%esp
}
 391:	90                   	nop
 392:	c9                   	leave
 393:	c3                   	ret

00000394 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 394:	55                   	push   %ebp
 395:	89 e5                	mov    %esp,%ebp
 397:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 39a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3a1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3a5:	74 17                	je     3be <printint+0x2a>
 3a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ab:	79 11                	jns    3be <printint+0x2a>
    neg = 1;
 3ad:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b7:	f7 d8                	neg    %eax
 3b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3bc:	eb 06                	jmp    3c4 <printint+0x30>
  } else {
    x = xx;
 3be:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d1:	ba 00 00 00 00       	mov    $0x0,%edx
 3d6:	f7 f1                	div    %ecx
 3d8:	89 d1                	mov    %edx,%ecx
 3da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3dd:	8d 50 01             	lea    0x1(%eax),%edx
 3e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3e3:	0f b6 91 60 0a 00 00 	movzbl 0xa60(%ecx),%edx
 3ea:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 3ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f4:	ba 00 00 00 00       	mov    $0x0,%edx
 3f9:	f7 f1                	div    %ecx
 3fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 402:	75 c7                	jne    3cb <printint+0x37>
  if(neg)
 404:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 408:	74 2d                	je     437 <printint+0xa3>
    buf[i++] = '-';
 40a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40d:	8d 50 01             	lea    0x1(%eax),%edx
 410:	89 55 f4             	mov    %edx,-0xc(%ebp)
 413:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 418:	eb 1d                	jmp    437 <printint+0xa3>
    putc(fd, buf[i]);
 41a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 41d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 420:	01 d0                	add    %edx,%eax
 422:	0f b6 00             	movzbl (%eax),%eax
 425:	0f be c0             	movsbl %al,%eax
 428:	83 ec 08             	sub    $0x8,%esp
 42b:	50                   	push   %eax
 42c:	ff 75 08             	push   0x8(%ebp)
 42f:	e8 3d ff ff ff       	call   371 <putc>
 434:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 437:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 43b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 43f:	79 d9                	jns    41a <printint+0x86>
}
 441:	90                   	nop
 442:	90                   	nop
 443:	c9                   	leave
 444:	c3                   	ret

00000445 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 445:	55                   	push   %ebp
 446:	89 e5                	mov    %esp,%ebp
 448:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 44b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 452:	8d 45 0c             	lea    0xc(%ebp),%eax
 455:	83 c0 04             	add    $0x4,%eax
 458:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 45b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 462:	e9 59 01 00 00       	jmp    5c0 <printf+0x17b>
    c = fmt[i] & 0xff;
 467:	8b 55 0c             	mov    0xc(%ebp),%edx
 46a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 46d:	01 d0                	add    %edx,%eax
 46f:	0f b6 00             	movzbl (%eax),%eax
 472:	0f be c0             	movsbl %al,%eax
 475:	25 ff 00 00 00       	and    $0xff,%eax
 47a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 47d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 481:	75 2c                	jne    4af <printf+0x6a>
      if(c == '%'){
 483:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 487:	75 0c                	jne    495 <printf+0x50>
        state = '%';
 489:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 490:	e9 27 01 00 00       	jmp    5bc <printf+0x177>
      } else {
        putc(fd, c);
 495:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 498:	0f be c0             	movsbl %al,%eax
 49b:	83 ec 08             	sub    $0x8,%esp
 49e:	50                   	push   %eax
 49f:	ff 75 08             	push   0x8(%ebp)
 4a2:	e8 ca fe ff ff       	call   371 <putc>
 4a7:	83 c4 10             	add    $0x10,%esp
 4aa:	e9 0d 01 00 00       	jmp    5bc <printf+0x177>
      }
    } else if(state == '%'){
 4af:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4b3:	0f 85 03 01 00 00    	jne    5bc <printf+0x177>
      if(c == 'd'){
 4b9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4bd:	75 1e                	jne    4dd <printf+0x98>
        printint(fd, *ap, 10, 1);
 4bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c2:	8b 00                	mov    (%eax),%eax
 4c4:	6a 01                	push   $0x1
 4c6:	6a 0a                	push   $0xa
 4c8:	50                   	push   %eax
 4c9:	ff 75 08             	push   0x8(%ebp)
 4cc:	e8 c3 fe ff ff       	call   394 <printint>
 4d1:	83 c4 10             	add    $0x10,%esp
        ap++;
 4d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d8:	e9 d8 00 00 00       	jmp    5b5 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4dd:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4e1:	74 06                	je     4e9 <printf+0xa4>
 4e3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4e7:	75 1e                	jne    507 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ec:	8b 00                	mov    (%eax),%eax
 4ee:	6a 00                	push   $0x0
 4f0:	6a 10                	push   $0x10
 4f2:	50                   	push   %eax
 4f3:	ff 75 08             	push   0x8(%ebp)
 4f6:	e8 99 fe ff ff       	call   394 <printint>
 4fb:	83 c4 10             	add    $0x10,%esp
        ap++;
 4fe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 502:	e9 ae 00 00 00       	jmp    5b5 <printf+0x170>
      } else if(c == 's'){
 507:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 50b:	75 43                	jne    550 <printf+0x10b>
        s = (char*)*ap;
 50d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 510:	8b 00                	mov    (%eax),%eax
 512:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 515:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 519:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 51d:	75 25                	jne    544 <printf+0xff>
          s = "(null)";
 51f:	c7 45 f4 10 08 00 00 	movl   $0x810,-0xc(%ebp)
        while(*s != 0){
 526:	eb 1c                	jmp    544 <printf+0xff>
          putc(fd, *s);
 528:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52b:	0f b6 00             	movzbl (%eax),%eax
 52e:	0f be c0             	movsbl %al,%eax
 531:	83 ec 08             	sub    $0x8,%esp
 534:	50                   	push   %eax
 535:	ff 75 08             	push   0x8(%ebp)
 538:	e8 34 fe ff ff       	call   371 <putc>
 53d:	83 c4 10             	add    $0x10,%esp
          s++;
 540:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 544:	8b 45 f4             	mov    -0xc(%ebp),%eax
 547:	0f b6 00             	movzbl (%eax),%eax
 54a:	84 c0                	test   %al,%al
 54c:	75 da                	jne    528 <printf+0xe3>
 54e:	eb 65                	jmp    5b5 <printf+0x170>
        }
      } else if(c == 'c'){
 550:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 554:	75 1d                	jne    573 <printf+0x12e>
        putc(fd, *ap);
 556:	8b 45 e8             	mov    -0x18(%ebp),%eax
 559:	8b 00                	mov    (%eax),%eax
 55b:	0f be c0             	movsbl %al,%eax
 55e:	83 ec 08             	sub    $0x8,%esp
 561:	50                   	push   %eax
 562:	ff 75 08             	push   0x8(%ebp)
 565:	e8 07 fe ff ff       	call   371 <putc>
 56a:	83 c4 10             	add    $0x10,%esp
        ap++;
 56d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 571:	eb 42                	jmp    5b5 <printf+0x170>
      } else if(c == '%'){
 573:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 577:	75 17                	jne    590 <printf+0x14b>
        putc(fd, c);
 579:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 57c:	0f be c0             	movsbl %al,%eax
 57f:	83 ec 08             	sub    $0x8,%esp
 582:	50                   	push   %eax
 583:	ff 75 08             	push   0x8(%ebp)
 586:	e8 e6 fd ff ff       	call   371 <putc>
 58b:	83 c4 10             	add    $0x10,%esp
 58e:	eb 25                	jmp    5b5 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 590:	83 ec 08             	sub    $0x8,%esp
 593:	6a 25                	push   $0x25
 595:	ff 75 08             	push   0x8(%ebp)
 598:	e8 d4 fd ff ff       	call   371 <putc>
 59d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a3:	0f be c0             	movsbl %al,%eax
 5a6:	83 ec 08             	sub    $0x8,%esp
 5a9:	50                   	push   %eax
 5aa:	ff 75 08             	push   0x8(%ebp)
 5ad:	e8 bf fd ff ff       	call   371 <putc>
 5b2:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5bc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5c0:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c6:	01 d0                	add    %edx,%eax
 5c8:	0f b6 00             	movzbl (%eax),%eax
 5cb:	84 c0                	test   %al,%al
 5cd:	0f 85 94 fe ff ff    	jne    467 <printf+0x22>
    }
  }
}
 5d3:	90                   	nop
 5d4:	90                   	nop
 5d5:	c9                   	leave
 5d6:	c3                   	ret

000005d7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d7:	55                   	push   %ebp
 5d8:	89 e5                	mov    %esp,%ebp
 5da:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5dd:	8b 45 08             	mov    0x8(%ebp),%eax
 5e0:	83 e8 08             	sub    $0x8,%eax
 5e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e6:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 5eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ee:	eb 24                	jmp    614 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f3:	8b 00                	mov    (%eax),%eax
 5f5:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5f8:	72 12                	jb     60c <free+0x35>
 5fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fd:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 600:	72 24                	jb     626 <free+0x4f>
 602:	8b 45 fc             	mov    -0x4(%ebp),%eax
 605:	8b 00                	mov    (%eax),%eax
 607:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 60a:	72 1a                	jb     626 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60f:	8b 00                	mov    (%eax),%eax
 611:	89 45 fc             	mov    %eax,-0x4(%ebp)
 614:	8b 45 f8             	mov    -0x8(%ebp),%eax
 617:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 61a:	73 d4                	jae    5f0 <free+0x19>
 61c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61f:	8b 00                	mov    (%eax),%eax
 621:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 624:	73 ca                	jae    5f0 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 626:	8b 45 f8             	mov    -0x8(%ebp),%eax
 629:	8b 40 04             	mov    0x4(%eax),%eax
 62c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 633:	8b 45 f8             	mov    -0x8(%ebp),%eax
 636:	01 c2                	add    %eax,%edx
 638:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63b:	8b 00                	mov    (%eax),%eax
 63d:	39 c2                	cmp    %eax,%edx
 63f:	75 24                	jne    665 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 641:	8b 45 f8             	mov    -0x8(%ebp),%eax
 644:	8b 50 04             	mov    0x4(%eax),%edx
 647:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	8b 40 04             	mov    0x4(%eax),%eax
 64f:	01 c2                	add    %eax,%edx
 651:	8b 45 f8             	mov    -0x8(%ebp),%eax
 654:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	8b 00                	mov    (%eax),%eax
 65c:	8b 10                	mov    (%eax),%edx
 65e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 661:	89 10                	mov    %edx,(%eax)
 663:	eb 0a                	jmp    66f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 10                	mov    (%eax),%edx
 66a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	8b 40 04             	mov    0x4(%eax),%eax
 675:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	01 d0                	add    %edx,%eax
 681:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 684:	75 20                	jne    6a6 <free+0xcf>
    p->s.size += bp->s.size;
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	8b 50 04             	mov    0x4(%eax),%edx
 68c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68f:	8b 40 04             	mov    0x4(%eax),%eax
 692:	01 c2                	add    %eax,%edx
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 69a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69d:	8b 10                	mov    (%eax),%edx
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	89 10                	mov    %edx,(%eax)
 6a4:	eb 08                	jmp    6ae <free+0xd7>
  } else
    p->s.ptr = bp;
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ac:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b1:	a3 7c 0a 00 00       	mov    %eax,0xa7c
}
 6b6:	90                   	nop
 6b7:	c9                   	leave
 6b8:	c3                   	ret

000006b9 <morecore>:

static Header*
morecore(uint nu)
{
 6b9:	55                   	push   %ebp
 6ba:	89 e5                	mov    %esp,%ebp
 6bc:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6bf:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6c6:	77 07                	ja     6cf <morecore+0x16>
    nu = 4096;
 6c8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6cf:	8b 45 08             	mov    0x8(%ebp),%eax
 6d2:	c1 e0 03             	shl    $0x3,%eax
 6d5:	83 ec 0c             	sub    $0xc,%esp
 6d8:	50                   	push   %eax
 6d9:	e8 73 fc ff ff       	call   351 <sbrk>
 6de:	83 c4 10             	add    $0x10,%esp
 6e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6e4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6e8:	75 07                	jne    6f1 <morecore+0x38>
    return 0;
 6ea:	b8 00 00 00 00       	mov    $0x0,%eax
 6ef:	eb 26                	jmp    717 <morecore+0x5e>
  hp = (Header*)p;
 6f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fa:	8b 55 08             	mov    0x8(%ebp),%edx
 6fd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 700:	8b 45 f0             	mov    -0x10(%ebp),%eax
 703:	83 c0 08             	add    $0x8,%eax
 706:	83 ec 0c             	sub    $0xc,%esp
 709:	50                   	push   %eax
 70a:	e8 c8 fe ff ff       	call   5d7 <free>
 70f:	83 c4 10             	add    $0x10,%esp
  return freep;
 712:	a1 7c 0a 00 00       	mov    0xa7c,%eax
}
 717:	c9                   	leave
 718:	c3                   	ret

00000719 <malloc>:

void*
malloc(uint nbytes)
{
 719:	55                   	push   %ebp
 71a:	89 e5                	mov    %esp,%ebp
 71c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71f:	8b 45 08             	mov    0x8(%ebp),%eax
 722:	83 c0 07             	add    $0x7,%eax
 725:	c1 e8 03             	shr    $0x3,%eax
 728:	83 c0 01             	add    $0x1,%eax
 72b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 72e:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 733:	89 45 f0             	mov    %eax,-0x10(%ebp)
 736:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 73a:	75 23                	jne    75f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 73c:	c7 45 f0 74 0a 00 00 	movl   $0xa74,-0x10(%ebp)
 743:	8b 45 f0             	mov    -0x10(%ebp),%eax
 746:	a3 7c 0a 00 00       	mov    %eax,0xa7c
 74b:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 750:	a3 74 0a 00 00       	mov    %eax,0xa74
    base.s.size = 0;
 755:	c7 05 78 0a 00 00 00 	movl   $0x0,0xa78
 75c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 762:	8b 00                	mov    (%eax),%eax
 764:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 767:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76a:	8b 40 04             	mov    0x4(%eax),%eax
 76d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 770:	72 4d                	jb     7bf <malloc+0xa6>
      if(p->s.size == nunits)
 772:	8b 45 f4             	mov    -0xc(%ebp),%eax
 775:	8b 40 04             	mov    0x4(%eax),%eax
 778:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 77b:	75 0c                	jne    789 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 77d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 780:	8b 10                	mov    (%eax),%edx
 782:	8b 45 f0             	mov    -0x10(%ebp),%eax
 785:	89 10                	mov    %edx,(%eax)
 787:	eb 26                	jmp    7af <malloc+0x96>
      else {
        p->s.size -= nunits;
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	8b 40 04             	mov    0x4(%eax),%eax
 78f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 792:	89 c2                	mov    %eax,%edx
 794:	8b 45 f4             	mov    -0xc(%ebp),%eax
 797:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 79a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79d:	8b 40 04             	mov    0x4(%eax),%eax
 7a0:	c1 e0 03             	shl    $0x3,%eax
 7a3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ac:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b2:	a3 7c 0a 00 00       	mov    %eax,0xa7c
      return (void*)(p + 1);
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	83 c0 08             	add    $0x8,%eax
 7bd:	eb 3b                	jmp    7fa <malloc+0xe1>
    }
    if(p == freep)
 7bf:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 7c4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7c7:	75 1e                	jne    7e7 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7c9:	83 ec 0c             	sub    $0xc,%esp
 7cc:	ff 75 ec             	push   -0x14(%ebp)
 7cf:	e8 e5 fe ff ff       	call   6b9 <morecore>
 7d4:	83 c4 10             	add    $0x10,%esp
 7d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7de:	75 07                	jne    7e7 <malloc+0xce>
        return 0;
 7e0:	b8 00 00 00 00       	mov    $0x0,%eax
 7e5:	eb 13                	jmp    7fa <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f0:	8b 00                	mov    (%eax),%eax
 7f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f5:	e9 6d ff ff ff       	jmp    767 <malloc+0x4e>
  }
}
 7fa:	c9                   	leave
 7fb:	c3                   	ret
