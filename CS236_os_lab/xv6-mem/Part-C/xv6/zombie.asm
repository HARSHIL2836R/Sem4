
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 65 02 00 00       	call   27b <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 ef 02 00 00       	call   313 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 57 02 00 00       	call   283 <exit>

0000002c <stosb>:
  stosb(dst, c, n);
  return dst;
}

char*
strchr(const char *s, char c)
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
{
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
  for(; *s; s++)
    if(*s == c)
      return (char*)s;
  return 0;
  4d:	90                   	nop
  4e:	5b                   	pop    %ebx
  4f:	5f                   	pop    %edi
  50:	5d                   	pop    %ebp
  51:	c3                   	ret

00000052 <strcpy>:
{
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	83 ec 10             	sub    $0x10,%esp
  os = s;
  58:	8b 45 08             	mov    0x8(%ebp),%eax
  5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5e:	90                   	nop
  5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  62:	8d 42 01             	lea    0x1(%edx),%eax
  65:	89 45 0c             	mov    %eax,0xc(%ebp)
  68:	8b 45 08             	mov    0x8(%ebp),%eax
  6b:	8d 48 01             	lea    0x1(%eax),%ecx
  6e:	89 4d 08             	mov    %ecx,0x8(%ebp)
  71:	0f b6 12             	movzbl (%edx),%edx
  74:	88 10                	mov    %dl,(%eax)
  76:	0f b6 00             	movzbl (%eax),%eax
  79:	84 c0                	test   %al,%al
  7b:	75 e2                	jne    5f <strcpy+0xd>
  return os;
  7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80:	c9                   	leave
  81:	c3                   	ret

00000082 <strcmp>:
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  85:	eb 08                	jmp    8f <strcmp+0xd>
    p++, q++;
  87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 00             	movzbl (%eax),%eax
  95:	84 c0                	test   %al,%al
  97:	74 10                	je     a9 <strcmp+0x27>
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	38 c2                	cmp    %al,%dl
  a7:	74 de                	je     87 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	0f b6 d0             	movzbl %al,%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	0f b6 c0             	movzbl %al,%eax
  bb:	29 c2                	sub    %eax,%edx
  bd:	89 d0                	mov    %edx,%eax
}
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret

000000c1 <strlen>:
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	83 ec 10             	sub    $0x10,%esp
  for(n = 0; s[n]; n++)
  c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ce:	eb 04                	jmp    d4 <strlen+0x13>
  d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 d0                	add    %edx,%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	84 c0                	test   %al,%al
  e1:	75 ed                	jne    d0 <strlen+0xf>
  return n;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave
  e7:	c3                   	ret

000000e8 <memset>:
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  eb:	8b 45 10             	mov    0x10(%ebp),%eax
  ee:	50                   	push   %eax
  ef:	ff 75 0c             	push   0xc(%ebp)
  f2:	ff 75 08             	push   0x8(%ebp)
  f5:	e8 32 ff ff ff       	call   2c <stosb>
  fa:	83 c4 0c             	add    $0xc,%esp
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave
 101:	c3                   	ret

00000102 <strchr>:
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	38 45 fc             	cmp    %al,-0x4(%ebp)
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave
 134:	c3                   	ret

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 42                	jmp    186 <gets+0x51>
    cc = read(0, &c, 1);
 144:	83 ec 04             	sub    $0x4,%esp
 147:	6a 01                	push   $0x1
 149:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14c:	50                   	push   %eax
 14d:	6a 00                	push   $0x0
 14f:	e8 47 01 00 00       	call   29b <read>
 154:	83 c4 10             	add    $0x10,%esp
 157:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 15a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15e:	7e 33                	jle    193 <gets+0x5e>
      break;
    buf[i++] = c;
 160:	8b 45 f4             	mov    -0xc(%ebp),%eax
 163:	8d 50 01             	lea    0x1(%eax),%edx
 166:	89 55 f4             	mov    %edx,-0xc(%ebp)
 169:	89 c2                	mov    %eax,%edx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	01 c2                	add    %eax,%edx
 170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 174:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0a                	cmp    $0xa,%al
 17c:	74 16                	je     194 <gets+0x5f>
 17e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 182:	3c 0d                	cmp    $0xd,%al
 184:	74 0e                	je     194 <gets+0x5f>
  for(i=0; i+1 < max; ){
 186:	8b 45 f4             	mov    -0xc(%ebp),%eax
 189:	83 c0 01             	add    $0x1,%eax
 18c:	39 45 0c             	cmp    %eax,0xc(%ebp)
 18f:	7f b3                	jg     144 <gets+0xf>
 191:	eb 01                	jmp    194 <gets+0x5f>
      break;
 193:	90                   	nop
      break;
  }
  buf[i] = '\0';
 194:	8b 55 f4             	mov    -0xc(%ebp),%edx
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	01 d0                	add    %edx,%eax
 19c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a2:	c9                   	leave
 1a3:	c3                   	ret

000001a4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	83 ec 08             	sub    $0x8,%esp
 1ad:	6a 00                	push   $0x0
 1af:	ff 75 08             	push   0x8(%ebp)
 1b2:	e8 0c 01 00 00       	call   2c3 <open>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c1:	79 07                	jns    1ca <stat+0x26>
    return -1;
 1c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c8:	eb 25                	jmp    1ef <stat+0x4b>
  r = fstat(fd, st);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	ff 75 0c             	push   0xc(%ebp)
 1d0:	ff 75 f4             	push   -0xc(%ebp)
 1d3:	e8 03 01 00 00       	call   2db <fstat>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1de:	83 ec 0c             	sub    $0xc,%esp
 1e1:	ff 75 f4             	push   -0xc(%ebp)
 1e4:	e8 c2 00 00 00       	call   2ab <close>
 1e9:	83 c4 10             	add    $0x10,%esp
  return r;
 1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ef:	c9                   	leave
 1f0:	c3                   	ret

000001f1 <atoi>:

int
atoi(const char *s)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1fe:	eb 25                	jmp    225 <atoi+0x34>
    n = n*10 + *s++ - '0';
 200:	8b 55 fc             	mov    -0x4(%ebp),%edx
 203:	89 d0                	mov    %edx,%eax
 205:	c1 e0 02             	shl    $0x2,%eax
 208:	01 d0                	add    %edx,%eax
 20a:	01 c0                	add    %eax,%eax
 20c:	89 c1                	mov    %eax,%ecx
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	8d 50 01             	lea    0x1(%eax),%edx
 214:	89 55 08             	mov    %edx,0x8(%ebp)
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	0f be c0             	movsbl %al,%eax
 21d:	01 c8                	add    %ecx,%eax
 21f:	83 e8 30             	sub    $0x30,%eax
 222:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	3c 2f                	cmp    $0x2f,%al
 22d:	7e 0a                	jle    239 <atoi+0x48>
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	3c 39                	cmp    $0x39,%al
 237:	7e c7                	jle    200 <atoi+0xf>
  return n;
 239:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23c:	c9                   	leave
 23d:	c3                   	ret

0000023e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 250:	eb 17                	jmp    269 <memmove+0x2b>
    *dst++ = *src++;
 252:	8b 55 f8             	mov    -0x8(%ebp),%edx
 255:	8d 42 01             	lea    0x1(%edx),%eax
 258:	89 45 f8             	mov    %eax,-0x8(%ebp)
 25b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25e:	8d 48 01             	lea    0x1(%eax),%ecx
 261:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 264:	0f b6 12             	movzbl (%edx),%edx
 267:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 269:	8b 45 10             	mov    0x10(%ebp),%eax
 26c:	8d 50 ff             	lea    -0x1(%eax),%edx
 26f:	89 55 10             	mov    %edx,0x10(%ebp)
 272:	85 c0                	test   %eax,%eax
 274:	7f dc                	jg     252 <memmove+0x14>
  return vdst;
 276:	8b 45 08             	mov    0x8(%ebp),%eax
}
 279:	c9                   	leave
 27a:	c3                   	ret

0000027b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 27b:	b8 01 00 00 00       	mov    $0x1,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret

00000283 <exit>:
SYSCALL(exit)
 283:	b8 02 00 00 00       	mov    $0x2,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret

0000028b <wait>:
SYSCALL(wait)
 28b:	b8 03 00 00 00       	mov    $0x3,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret

00000293 <pipe>:
SYSCALL(pipe)
 293:	b8 04 00 00 00       	mov    $0x4,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret

0000029b <read>:
SYSCALL(read)
 29b:	b8 05 00 00 00       	mov    $0x5,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret

000002a3 <write>:
SYSCALL(write)
 2a3:	b8 10 00 00 00       	mov    $0x10,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret

000002ab <close>:
SYSCALL(close)
 2ab:	b8 15 00 00 00       	mov    $0x15,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <kill>:
SYSCALL(kill)
 2b3:	b8 06 00 00 00       	mov    $0x6,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <exec>:
SYSCALL(exec)
 2bb:	b8 07 00 00 00       	mov    $0x7,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <open>:
SYSCALL(open)
 2c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <mknod>:
SYSCALL(mknod)
 2cb:	b8 11 00 00 00       	mov    $0x11,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <unlink>:
SYSCALL(unlink)
 2d3:	b8 12 00 00 00       	mov    $0x12,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <fstat>:
SYSCALL(fstat)
 2db:	b8 08 00 00 00       	mov    $0x8,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <link>:
SYSCALL(link)
 2e3:	b8 13 00 00 00       	mov    $0x13,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <mkdir>:
SYSCALL(mkdir)
 2eb:	b8 14 00 00 00       	mov    $0x14,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <chdir>:
SYSCALL(chdir)
 2f3:	b8 09 00 00 00       	mov    $0x9,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <dup>:
SYSCALL(dup)
 2fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <getpid>:
SYSCALL(getpid)
 303:	b8 0b 00 00 00       	mov    $0xb,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <sbrk>:
SYSCALL(sbrk)
 30b:	b8 0c 00 00 00       	mov    $0xc,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <sleep>:
SYSCALL(sleep)
 313:	b8 0d 00 00 00       	mov    $0xd,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <uptime>:
SYSCALL(uptime)
 31b:	b8 0e 00 00 00       	mov    $0xe,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <getNumFreePages>:
SYSCALL(getNumFreePages)
 323:	b8 16 00 00 00       	mov    $0x16,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 32b:	55                   	push   %ebp
 32c:	89 e5                	mov    %esp,%ebp
 32e:	83 ec 18             	sub    $0x18,%esp
 331:	8b 45 0c             	mov    0xc(%ebp),%eax
 334:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 337:	83 ec 04             	sub    $0x4,%esp
 33a:	6a 01                	push   $0x1
 33c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 33f:	50                   	push   %eax
 340:	ff 75 08             	push   0x8(%ebp)
 343:	e8 5b ff ff ff       	call   2a3 <write>
 348:	83 c4 10             	add    $0x10,%esp
}
 34b:	90                   	nop
 34c:	c9                   	leave
 34d:	c3                   	ret

0000034e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 34e:	55                   	push   %ebp
 34f:	89 e5                	mov    %esp,%ebp
 351:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 354:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 35b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 35f:	74 17                	je     378 <printint+0x2a>
 361:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 365:	79 11                	jns    378 <printint+0x2a>
    neg = 1;
 367:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 36e:	8b 45 0c             	mov    0xc(%ebp),%eax
 371:	f7 d8                	neg    %eax
 373:	89 45 ec             	mov    %eax,-0x14(%ebp)
 376:	eb 06                	jmp    37e <printint+0x30>
  } else {
    x = xx;
 378:	8b 45 0c             	mov    0xc(%ebp),%eax
 37b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 37e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 385:	8b 4d 10             	mov    0x10(%ebp),%ecx
 388:	8b 45 ec             	mov    -0x14(%ebp),%eax
 38b:	ba 00 00 00 00       	mov    $0x0,%edx
 390:	f7 f1                	div    %ecx
 392:	89 d1                	mov    %edx,%ecx
 394:	8b 45 f4             	mov    -0xc(%ebp),%eax
 397:	8d 50 01             	lea    0x1(%eax),%edx
 39a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 39d:	0f b6 91 04 0a 00 00 	movzbl 0xa04(%ecx),%edx
 3a4:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 3a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ae:	ba 00 00 00 00       	mov    $0x0,%edx
 3b3:	f7 f1                	div    %ecx
 3b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3bc:	75 c7                	jne    385 <printint+0x37>
  if(neg)
 3be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3c2:	74 2d                	je     3f1 <printint+0xa3>
    buf[i++] = '-';
 3c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3c7:	8d 50 01             	lea    0x1(%eax),%edx
 3ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3cd:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3d2:	eb 1d                	jmp    3f1 <printint+0xa3>
    putc(fd, buf[i]);
 3d4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3da:	01 d0                	add    %edx,%eax
 3dc:	0f b6 00             	movzbl (%eax),%eax
 3df:	0f be c0             	movsbl %al,%eax
 3e2:	83 ec 08             	sub    $0x8,%esp
 3e5:	50                   	push   %eax
 3e6:	ff 75 08             	push   0x8(%ebp)
 3e9:	e8 3d ff ff ff       	call   32b <putc>
 3ee:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 3f1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 3f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3f9:	79 d9                	jns    3d4 <printint+0x86>
}
 3fb:	90                   	nop
 3fc:	90                   	nop
 3fd:	c9                   	leave
 3fe:	c3                   	ret

000003ff <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3ff:	55                   	push   %ebp
 400:	89 e5                	mov    %esp,%ebp
 402:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 405:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 40c:	8d 45 0c             	lea    0xc(%ebp),%eax
 40f:	83 c0 04             	add    $0x4,%eax
 412:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 41c:	e9 59 01 00 00       	jmp    57a <printf+0x17b>
    c = fmt[i] & 0xff;
 421:	8b 55 0c             	mov    0xc(%ebp),%edx
 424:	8b 45 f0             	mov    -0x10(%ebp),%eax
 427:	01 d0                	add    %edx,%eax
 429:	0f b6 00             	movzbl (%eax),%eax
 42c:	0f be c0             	movsbl %al,%eax
 42f:	25 ff 00 00 00       	and    $0xff,%eax
 434:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 437:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43b:	75 2c                	jne    469 <printf+0x6a>
      if(c == '%'){
 43d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 441:	75 0c                	jne    44f <printf+0x50>
        state = '%';
 443:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 44a:	e9 27 01 00 00       	jmp    576 <printf+0x177>
      } else {
        putc(fd, c);
 44f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 452:	0f be c0             	movsbl %al,%eax
 455:	83 ec 08             	sub    $0x8,%esp
 458:	50                   	push   %eax
 459:	ff 75 08             	push   0x8(%ebp)
 45c:	e8 ca fe ff ff       	call   32b <putc>
 461:	83 c4 10             	add    $0x10,%esp
 464:	e9 0d 01 00 00       	jmp    576 <printf+0x177>
      }
    } else if(state == '%'){
 469:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 46d:	0f 85 03 01 00 00    	jne    576 <printf+0x177>
      if(c == 'd'){
 473:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 477:	75 1e                	jne    497 <printf+0x98>
        printint(fd, *ap, 10, 1);
 479:	8b 45 e8             	mov    -0x18(%ebp),%eax
 47c:	8b 00                	mov    (%eax),%eax
 47e:	6a 01                	push   $0x1
 480:	6a 0a                	push   $0xa
 482:	50                   	push   %eax
 483:	ff 75 08             	push   0x8(%ebp)
 486:	e8 c3 fe ff ff       	call   34e <printint>
 48b:	83 c4 10             	add    $0x10,%esp
        ap++;
 48e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 492:	e9 d8 00 00 00       	jmp    56f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 497:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 49b:	74 06                	je     4a3 <printf+0xa4>
 49d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4a1:	75 1e                	jne    4c1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a6:	8b 00                	mov    (%eax),%eax
 4a8:	6a 00                	push   $0x0
 4aa:	6a 10                	push   $0x10
 4ac:	50                   	push   %eax
 4ad:	ff 75 08             	push   0x8(%ebp)
 4b0:	e8 99 fe ff ff       	call   34e <printint>
 4b5:	83 c4 10             	add    $0x10,%esp
        ap++;
 4b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4bc:	e9 ae 00 00 00       	jmp    56f <printf+0x170>
      } else if(c == 's'){
 4c1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4c5:	75 43                	jne    50a <printf+0x10b>
        s = (char*)*ap;
 4c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ca:	8b 00                	mov    (%eax),%eax
 4cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d7:	75 25                	jne    4fe <printf+0xff>
          s = "(null)";
 4d9:	c7 45 f4 b6 07 00 00 	movl   $0x7b6,-0xc(%ebp)
        while(*s != 0){
 4e0:	eb 1c                	jmp    4fe <printf+0xff>
          putc(fd, *s);
 4e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e5:	0f b6 00             	movzbl (%eax),%eax
 4e8:	0f be c0             	movsbl %al,%eax
 4eb:	83 ec 08             	sub    $0x8,%esp
 4ee:	50                   	push   %eax
 4ef:	ff 75 08             	push   0x8(%ebp)
 4f2:	e8 34 fe ff ff       	call   32b <putc>
 4f7:	83 c4 10             	add    $0x10,%esp
          s++;
 4fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 4fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 501:	0f b6 00             	movzbl (%eax),%eax
 504:	84 c0                	test   %al,%al
 506:	75 da                	jne    4e2 <printf+0xe3>
 508:	eb 65                	jmp    56f <printf+0x170>
        }
      } else if(c == 'c'){
 50a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 50e:	75 1d                	jne    52d <printf+0x12e>
        putc(fd, *ap);
 510:	8b 45 e8             	mov    -0x18(%ebp),%eax
 513:	8b 00                	mov    (%eax),%eax
 515:	0f be c0             	movsbl %al,%eax
 518:	83 ec 08             	sub    $0x8,%esp
 51b:	50                   	push   %eax
 51c:	ff 75 08             	push   0x8(%ebp)
 51f:	e8 07 fe ff ff       	call   32b <putc>
 524:	83 c4 10             	add    $0x10,%esp
        ap++;
 527:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52b:	eb 42                	jmp    56f <printf+0x170>
      } else if(c == '%'){
 52d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 531:	75 17                	jne    54a <printf+0x14b>
        putc(fd, c);
 533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 536:	0f be c0             	movsbl %al,%eax
 539:	83 ec 08             	sub    $0x8,%esp
 53c:	50                   	push   %eax
 53d:	ff 75 08             	push   0x8(%ebp)
 540:	e8 e6 fd ff ff       	call   32b <putc>
 545:	83 c4 10             	add    $0x10,%esp
 548:	eb 25                	jmp    56f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 54a:	83 ec 08             	sub    $0x8,%esp
 54d:	6a 25                	push   $0x25
 54f:	ff 75 08             	push   0x8(%ebp)
 552:	e8 d4 fd ff ff       	call   32b <putc>
 557:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 55a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 55d:	0f be c0             	movsbl %al,%eax
 560:	83 ec 08             	sub    $0x8,%esp
 563:	50                   	push   %eax
 564:	ff 75 08             	push   0x8(%ebp)
 567:	e8 bf fd ff ff       	call   32b <putc>
 56c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 56f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 576:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 57a:	8b 55 0c             	mov    0xc(%ebp),%edx
 57d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 580:	01 d0                	add    %edx,%eax
 582:	0f b6 00             	movzbl (%eax),%eax
 585:	84 c0                	test   %al,%al
 587:	0f 85 94 fe ff ff    	jne    421 <printf+0x22>
    }
  }
}
 58d:	90                   	nop
 58e:	90                   	nop
 58f:	c9                   	leave
 590:	c3                   	ret

00000591 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 591:	55                   	push   %ebp
 592:	89 e5                	mov    %esp,%ebp
 594:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 597:	8b 45 08             	mov    0x8(%ebp),%eax
 59a:	83 e8 08             	sub    $0x8,%eax
 59d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a0:	a1 20 0a 00 00       	mov    0xa20,%eax
 5a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5a8:	eb 24                	jmp    5ce <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ad:	8b 00                	mov    (%eax),%eax
 5af:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5b2:	72 12                	jb     5c6 <free+0x35>
 5b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5b7:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5ba:	72 24                	jb     5e0 <free+0x4f>
 5bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5bf:	8b 00                	mov    (%eax),%eax
 5c1:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 5c4:	72 1a                	jb     5e0 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c9:	8b 00                	mov    (%eax),%eax
 5cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5d1:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5d4:	73 d4                	jae    5aa <free+0x19>
 5d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d9:	8b 00                	mov    (%eax),%eax
 5db:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 5de:	73 ca                	jae    5aa <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e3:	8b 40 04             	mov    0x4(%eax),%eax
 5e6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 5ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f0:	01 c2                	add    %eax,%edx
 5f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f5:	8b 00                	mov    (%eax),%eax
 5f7:	39 c2                	cmp    %eax,%edx
 5f9:	75 24                	jne    61f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 5fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fe:	8b 50 04             	mov    0x4(%eax),%edx
 601:	8b 45 fc             	mov    -0x4(%ebp),%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	8b 40 04             	mov    0x4(%eax),%eax
 609:	01 c2                	add    %eax,%edx
 60b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 611:	8b 45 fc             	mov    -0x4(%ebp),%eax
 614:	8b 00                	mov    (%eax),%eax
 616:	8b 10                	mov    (%eax),%edx
 618:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61b:	89 10                	mov    %edx,(%eax)
 61d:	eb 0a                	jmp    629 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 61f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 622:	8b 10                	mov    (%eax),%edx
 624:	8b 45 f8             	mov    -0x8(%ebp),%eax
 627:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 629:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62c:	8b 40 04             	mov    0x4(%eax),%eax
 62f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 636:	8b 45 fc             	mov    -0x4(%ebp),%eax
 639:	01 d0                	add    %edx,%eax
 63b:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 63e:	75 20                	jne    660 <free+0xcf>
    p->s.size += bp->s.size;
 640:	8b 45 fc             	mov    -0x4(%ebp),%eax
 643:	8b 50 04             	mov    0x4(%eax),%edx
 646:	8b 45 f8             	mov    -0x8(%ebp),%eax
 649:	8b 40 04             	mov    0x4(%eax),%eax
 64c:	01 c2                	add    %eax,%edx
 64e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 651:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 654:	8b 45 f8             	mov    -0x8(%ebp),%eax
 657:	8b 10                	mov    (%eax),%edx
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	89 10                	mov    %edx,(%eax)
 65e:	eb 08                	jmp    668 <free+0xd7>
  } else
    p->s.ptr = bp;
 660:	8b 45 fc             	mov    -0x4(%ebp),%eax
 663:	8b 55 f8             	mov    -0x8(%ebp),%edx
 666:	89 10                	mov    %edx,(%eax)
  freep = p;
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	a3 20 0a 00 00       	mov    %eax,0xa20
}
 670:	90                   	nop
 671:	c9                   	leave
 672:	c3                   	ret

00000673 <morecore>:

static Header*
morecore(uint nu)
{
 673:	55                   	push   %ebp
 674:	89 e5                	mov    %esp,%ebp
 676:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 679:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 680:	77 07                	ja     689 <morecore+0x16>
    nu = 4096;
 682:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 689:	8b 45 08             	mov    0x8(%ebp),%eax
 68c:	c1 e0 03             	shl    $0x3,%eax
 68f:	83 ec 0c             	sub    $0xc,%esp
 692:	50                   	push   %eax
 693:	e8 73 fc ff ff       	call   30b <sbrk>
 698:	83 c4 10             	add    $0x10,%esp
 69b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 69e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6a2:	75 07                	jne    6ab <morecore+0x38>
    return 0;
 6a4:	b8 00 00 00 00       	mov    $0x0,%eax
 6a9:	eb 26                	jmp    6d1 <morecore+0x5e>
  hp = (Header*)p;
 6ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b4:	8b 55 08             	mov    0x8(%ebp),%edx
 6b7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bd:	83 c0 08             	add    $0x8,%eax
 6c0:	83 ec 0c             	sub    $0xc,%esp
 6c3:	50                   	push   %eax
 6c4:	e8 c8 fe ff ff       	call   591 <free>
 6c9:	83 c4 10             	add    $0x10,%esp
  return freep;
 6cc:	a1 20 0a 00 00       	mov    0xa20,%eax
}
 6d1:	c9                   	leave
 6d2:	c3                   	ret

000006d3 <malloc>:

void*
malloc(uint nbytes)
{
 6d3:	55                   	push   %ebp
 6d4:	89 e5                	mov    %esp,%ebp
 6d6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
 6dc:	83 c0 07             	add    $0x7,%eax
 6df:	c1 e8 03             	shr    $0x3,%eax
 6e2:	83 c0 01             	add    $0x1,%eax
 6e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6e8:	a1 20 0a 00 00       	mov    0xa20,%eax
 6ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6f4:	75 23                	jne    719 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 6f6:	c7 45 f0 18 0a 00 00 	movl   $0xa18,-0x10(%ebp)
 6fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 700:	a3 20 0a 00 00       	mov    %eax,0xa20
 705:	a1 20 0a 00 00       	mov    0xa20,%eax
 70a:	a3 18 0a 00 00       	mov    %eax,0xa18
    base.s.size = 0;
 70f:	c7 05 1c 0a 00 00 00 	movl   $0x0,0xa1c
 716:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 719:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71c:	8b 00                	mov    (%eax),%eax
 71e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 721:	8b 45 f4             	mov    -0xc(%ebp),%eax
 724:	8b 40 04             	mov    0x4(%eax),%eax
 727:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 72a:	72 4d                	jb     779 <malloc+0xa6>
      if(p->s.size == nunits)
 72c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72f:	8b 40 04             	mov    0x4(%eax),%eax
 732:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 735:	75 0c                	jne    743 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 737:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73a:	8b 10                	mov    (%eax),%edx
 73c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73f:	89 10                	mov    %edx,(%eax)
 741:	eb 26                	jmp    769 <malloc+0x96>
      else {
        p->s.size -= nunits;
 743:	8b 45 f4             	mov    -0xc(%ebp),%eax
 746:	8b 40 04             	mov    0x4(%eax),%eax
 749:	2b 45 ec             	sub    -0x14(%ebp),%eax
 74c:	89 c2                	mov    %eax,%edx
 74e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 751:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 754:	8b 45 f4             	mov    -0xc(%ebp),%eax
 757:	8b 40 04             	mov    0x4(%eax),%eax
 75a:	c1 e0 03             	shl    $0x3,%eax
 75d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 760:	8b 45 f4             	mov    -0xc(%ebp),%eax
 763:	8b 55 ec             	mov    -0x14(%ebp),%edx
 766:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 769:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76c:	a3 20 0a 00 00       	mov    %eax,0xa20
      return (void*)(p + 1);
 771:	8b 45 f4             	mov    -0xc(%ebp),%eax
 774:	83 c0 08             	add    $0x8,%eax
 777:	eb 3b                	jmp    7b4 <malloc+0xe1>
    }
    if(p == freep)
 779:	a1 20 0a 00 00       	mov    0xa20,%eax
 77e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 781:	75 1e                	jne    7a1 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 783:	83 ec 0c             	sub    $0xc,%esp
 786:	ff 75 ec             	push   -0x14(%ebp)
 789:	e8 e5 fe ff ff       	call   673 <morecore>
 78e:	83 c4 10             	add    $0x10,%esp
 791:	89 45 f4             	mov    %eax,-0xc(%ebp)
 794:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 798:	75 07                	jne    7a1 <malloc+0xce>
        return 0;
 79a:	b8 00 00 00 00       	mov    $0x0,%eax
 79f:	eb 13                	jmp    7b4 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7aa:	8b 00                	mov    (%eax),%eax
 7ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7af:	e9 6d ff ff ff       	jmp    721 <malloc+0x4e>
  }
}
 7b4:	c9                   	leave
 7b5:	c3                   	ret
