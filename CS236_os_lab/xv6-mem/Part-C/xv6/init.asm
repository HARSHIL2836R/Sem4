
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 8e 08 00 00       	push   $0x88e
  1b:	e8 78 03 00 00       	call   398 <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 8e 08 00 00       	push   $0x88e
  33:	e8 68 03 00 00       	call   3a0 <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 8e 08 00 00       	push   $0x88e
  45:	e8 4e 03 00 00       	call   398 <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 79 03 00 00       	call   3d0 <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 6c 03 00 00       	call   3d0 <dup>
  64:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  67:	83 ec 08             	sub    $0x8,%esp
  6a:	68 96 08 00 00       	push   $0x896
  6f:	6a 01                	push   $0x1
  71:	e8 5e 04 00 00       	call   4d4 <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 d2 02 00 00       	call   350 <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 a9 08 00 00       	push   $0x8a9
  8f:	6a 01                	push   $0x1
  91:	e8 3e 04 00 00       	call   4d4 <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 ba 02 00 00       	call   358 <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 3e                	jne    e2 <main+0xe2>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 28 0b 00 00       	push   $0xb28
  ac:	68 8b 08 00 00       	push   $0x88b
  b1:	e8 da 02 00 00       	call   390 <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 bc 08 00 00       	push   $0x8bc
  c1:	6a 01                	push   $0x1
  c3:	e8 0c 04 00 00       	call   4d4 <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 88 02 00 00       	call   358 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 d2 08 00 00       	push   $0x8d2
  d8:	6a 01                	push   $0x1
  da:	e8 f5 03 00 00       	call   4d4 <printf>
  df:	83 c4 10             	add    $0x10,%esp
    while((wpid=wait()) >= 0 && wpid != pid)
  e2:	e8 79 02 00 00       	call   360 <wait>
  e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  ee:	0f 88 73 ff ff ff    	js     67 <main+0x67>
  f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  fa:	75 d4                	jne    d0 <main+0xd0>
    printf(1, "init: starting sh\n");
  fc:	e9 66 ff ff ff       	jmp    67 <main+0x67>

00000101 <stosb>:
  stosb(dst, c, n);
  return dst;
}

char*
strchr(const char *s, char c)
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	57                   	push   %edi
 105:	53                   	push   %ebx
{
 106:	8b 4d 08             	mov    0x8(%ebp),%ecx
 109:	8b 55 10             	mov    0x10(%ebp),%edx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	89 cb                	mov    %ecx,%ebx
 111:	89 df                	mov    %ebx,%edi
 113:	89 d1                	mov    %edx,%ecx
 115:	fc                   	cld
 116:	f3 aa                	rep stos %al,%es:(%edi)
 118:	89 ca                	mov    %ecx,%edx
 11a:	89 fb                	mov    %edi,%ebx
 11c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11f:	89 55 10             	mov    %edx,0x10(%ebp)
  for(; *s; s++)
    if(*s == c)
      return (char*)s;
  return 0;
 122:	90                   	nop
 123:	5b                   	pop    %ebx
 124:	5f                   	pop    %edi
 125:	5d                   	pop    %ebp
 126:	c3                   	ret

00000127 <strcpy>:
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 10             	sub    $0x10,%esp
  os = s;
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
 130:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 133:	90                   	nop
 134:	8b 55 0c             	mov    0xc(%ebp),%edx
 137:	8d 42 01             	lea    0x1(%edx),%eax
 13a:	89 45 0c             	mov    %eax,0xc(%ebp)
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	8d 48 01             	lea    0x1(%eax),%ecx
 143:	89 4d 08             	mov    %ecx,0x8(%ebp)
 146:	0f b6 12             	movzbl (%edx),%edx
 149:	88 10                	mov    %dl,(%eax)
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	84 c0                	test   %al,%al
 150:	75 e2                	jne    134 <strcpy+0xd>
  return os;
 152:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 155:	c9                   	leave
 156:	c3                   	ret

00000157 <strcmp>:
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 15a:	eb 08                	jmp    164 <strcmp+0xd>
    p++, q++;
 15c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 160:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	84 c0                	test   %al,%al
 16c:	74 10                	je     17e <strcmp+0x27>
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 10             	movzbl (%eax),%edx
 174:	8b 45 0c             	mov    0xc(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	38 c2                	cmp    %al,%dl
 17c:	74 de                	je     15c <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	0f b6 00             	movzbl (%eax),%eax
 184:	0f b6 d0             	movzbl %al,%edx
 187:	8b 45 0c             	mov    0xc(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	0f b6 c0             	movzbl %al,%eax
 190:	29 c2                	sub    %eax,%edx
 192:	89 d0                	mov    %edx,%eax
}
 194:	5d                   	pop    %ebp
 195:	c3                   	ret

00000196 <strlen>:
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
 199:	83 ec 10             	sub    $0x10,%esp
  for(n = 0; s[n]; n++)
 19c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a3:	eb 04                	jmp    1a9 <strlen+0x13>
 1a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	01 d0                	add    %edx,%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	84 c0                	test   %al,%al
 1b6:	75 ed                	jne    1a5 <strlen+0xf>
  return n;
 1b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1bb:	c9                   	leave
 1bc:	c3                   	ret

000001bd <memset>:
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c0:	8b 45 10             	mov    0x10(%ebp),%eax
 1c3:	50                   	push   %eax
 1c4:	ff 75 0c             	push   0xc(%ebp)
 1c7:	ff 75 08             	push   0x8(%ebp)
 1ca:	e8 32 ff ff ff       	call   101 <stosb>
 1cf:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d5:	c9                   	leave
 1d6:	c3                   	ret

000001d7 <strchr>:
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e3:	eb 14                	jmp    1f9 <strchr+0x22>
    if(*s == c)
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	0f b6 00             	movzbl (%eax),%eax
 1eb:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1ee:	75 05                	jne    1f5 <strchr+0x1e>
      return (char*)s;
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	eb 13                	jmp    208 <strchr+0x31>
  for(; *s; s++)
 1f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	84 c0                	test   %al,%al
 201:	75 e2                	jne    1e5 <strchr+0xe>
  return 0;
 203:	b8 00 00 00 00       	mov    $0x0,%eax
}
 208:	c9                   	leave
 209:	c3                   	ret

0000020a <gets>:

char*
gets(char *buf, int max)
{
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 210:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 217:	eb 42                	jmp    25b <gets+0x51>
    cc = read(0, &c, 1);
 219:	83 ec 04             	sub    $0x4,%esp
 21c:	6a 01                	push   $0x1
 21e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 221:	50                   	push   %eax
 222:	6a 00                	push   $0x0
 224:	e8 47 01 00 00       	call   370 <read>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 233:	7e 33                	jle    268 <gets+0x5e>
      break;
    buf[i++] = c;
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	8d 50 01             	lea    0x1(%eax),%edx
 23b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23e:	89 c2                	mov    %eax,%edx
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	01 c2                	add    %eax,%edx
 245:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 249:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 24b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24f:	3c 0a                	cmp    $0xa,%al
 251:	74 16                	je     269 <gets+0x5f>
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	3c 0d                	cmp    $0xd,%al
 259:	74 0e                	je     269 <gets+0x5f>
  for(i=0; i+1 < max; ){
 25b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25e:	83 c0 01             	add    $0x1,%eax
 261:	39 45 0c             	cmp    %eax,0xc(%ebp)
 264:	7f b3                	jg     219 <gets+0xf>
 266:	eb 01                	jmp    269 <gets+0x5f>
      break;
 268:	90                   	nop
      break;
  }
  buf[i] = '\0';
 269:	8b 55 f4             	mov    -0xc(%ebp),%edx
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	01 d0                	add    %edx,%eax
 271:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 274:	8b 45 08             	mov    0x8(%ebp),%eax
}
 277:	c9                   	leave
 278:	c3                   	ret

00000279 <stat>:

int
stat(const char *n, struct stat *st)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27f:	83 ec 08             	sub    $0x8,%esp
 282:	6a 00                	push   $0x0
 284:	ff 75 08             	push   0x8(%ebp)
 287:	e8 0c 01 00 00       	call   398 <open>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 292:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 296:	79 07                	jns    29f <stat+0x26>
    return -1;
 298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 29d:	eb 25                	jmp    2c4 <stat+0x4b>
  r = fstat(fd, st);
 29f:	83 ec 08             	sub    $0x8,%esp
 2a2:	ff 75 0c             	push   0xc(%ebp)
 2a5:	ff 75 f4             	push   -0xc(%ebp)
 2a8:	e8 03 01 00 00       	call   3b0 <fstat>
 2ad:	83 c4 10             	add    $0x10,%esp
 2b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b3:	83 ec 0c             	sub    $0xc,%esp
 2b6:	ff 75 f4             	push   -0xc(%ebp)
 2b9:	e8 c2 00 00 00       	call   380 <close>
 2be:	83 c4 10             	add    $0x10,%esp
  return r;
 2c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c4:	c9                   	leave
 2c5:	c3                   	ret

000002c6 <atoi>:

int
atoi(const char *s)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2d3:	eb 25                	jmp    2fa <atoi+0x34>
    n = n*10 + *s++ - '0';
 2d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d8:	89 d0                	mov    %edx,%eax
 2da:	c1 e0 02             	shl    $0x2,%eax
 2dd:	01 d0                	add    %edx,%eax
 2df:	01 c0                	add    %eax,%eax
 2e1:	89 c1                	mov    %eax,%ecx
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	8d 50 01             	lea    0x1(%eax),%edx
 2e9:	89 55 08             	mov    %edx,0x8(%ebp)
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	0f be c0             	movsbl %al,%eax
 2f2:	01 c8                	add    %ecx,%eax
 2f4:	83 e8 30             	sub    $0x30,%eax
 2f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	0f b6 00             	movzbl (%eax),%eax
 300:	3c 2f                	cmp    $0x2f,%al
 302:	7e 0a                	jle    30e <atoi+0x48>
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	0f b6 00             	movzbl (%eax),%eax
 30a:	3c 39                	cmp    $0x39,%al
 30c:	7e c7                	jle    2d5 <atoi+0xf>
  return n;
 30e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 311:	c9                   	leave
 312:	c3                   	ret

00000313 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 313:	55                   	push   %ebp
 314:	89 e5                	mov    %esp,%ebp
 316:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 31f:	8b 45 0c             	mov    0xc(%ebp),%eax
 322:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 325:	eb 17                	jmp    33e <memmove+0x2b>
    *dst++ = *src++;
 327:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32a:	8d 42 01             	lea    0x1(%edx),%eax
 32d:	89 45 f8             	mov    %eax,-0x8(%ebp)
 330:	8b 45 fc             	mov    -0x4(%ebp),%eax
 333:	8d 48 01             	lea    0x1(%eax),%ecx
 336:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 339:	0f b6 12             	movzbl (%edx),%edx
 33c:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 33e:	8b 45 10             	mov    0x10(%ebp),%eax
 341:	8d 50 ff             	lea    -0x1(%eax),%edx
 344:	89 55 10             	mov    %edx,0x10(%ebp)
 347:	85 c0                	test   %eax,%eax
 349:	7f dc                	jg     327 <memmove+0x14>
  return vdst;
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34e:	c9                   	leave
 34f:	c3                   	ret

00000350 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 350:	b8 01 00 00 00       	mov    $0x1,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret

00000358 <exit>:
SYSCALL(exit)
 358:	b8 02 00 00 00       	mov    $0x2,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret

00000360 <wait>:
SYSCALL(wait)
 360:	b8 03 00 00 00       	mov    $0x3,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret

00000368 <pipe>:
SYSCALL(pipe)
 368:	b8 04 00 00 00       	mov    $0x4,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret

00000370 <read>:
SYSCALL(read)
 370:	b8 05 00 00 00       	mov    $0x5,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret

00000378 <write>:
SYSCALL(write)
 378:	b8 10 00 00 00       	mov    $0x10,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret

00000380 <close>:
SYSCALL(close)
 380:	b8 15 00 00 00       	mov    $0x15,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret

00000388 <kill>:
SYSCALL(kill)
 388:	b8 06 00 00 00       	mov    $0x6,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret

00000390 <exec>:
SYSCALL(exec)
 390:	b8 07 00 00 00       	mov    $0x7,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret

00000398 <open>:
SYSCALL(open)
 398:	b8 0f 00 00 00       	mov    $0xf,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret

000003a0 <mknod>:
SYSCALL(mknod)
 3a0:	b8 11 00 00 00       	mov    $0x11,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret

000003a8 <unlink>:
SYSCALL(unlink)
 3a8:	b8 12 00 00 00       	mov    $0x12,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret

000003b0 <fstat>:
SYSCALL(fstat)
 3b0:	b8 08 00 00 00       	mov    $0x8,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret

000003b8 <link>:
SYSCALL(link)
 3b8:	b8 13 00 00 00       	mov    $0x13,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret

000003c0 <mkdir>:
SYSCALL(mkdir)
 3c0:	b8 14 00 00 00       	mov    $0x14,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret

000003c8 <chdir>:
SYSCALL(chdir)
 3c8:	b8 09 00 00 00       	mov    $0x9,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret

000003d0 <dup>:
SYSCALL(dup)
 3d0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret

000003d8 <getpid>:
SYSCALL(getpid)
 3d8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret

000003e0 <sbrk>:
SYSCALL(sbrk)
 3e0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret

000003e8 <sleep>:
SYSCALL(sleep)
 3e8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret

000003f0 <uptime>:
SYSCALL(uptime)
 3f0:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret

000003f8 <getNumFreePages>:
SYSCALL(getNumFreePages)
 3f8:	b8 16 00 00 00       	mov    $0x16,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret

00000400 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	83 ec 18             	sub    $0x18,%esp
 406:	8b 45 0c             	mov    0xc(%ebp),%eax
 409:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 40c:	83 ec 04             	sub    $0x4,%esp
 40f:	6a 01                	push   $0x1
 411:	8d 45 f4             	lea    -0xc(%ebp),%eax
 414:	50                   	push   %eax
 415:	ff 75 08             	push   0x8(%ebp)
 418:	e8 5b ff ff ff       	call   378 <write>
 41d:	83 c4 10             	add    $0x10,%esp
}
 420:	90                   	nop
 421:	c9                   	leave
 422:	c3                   	ret

00000423 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 423:	55                   	push   %ebp
 424:	89 e5                	mov    %esp,%ebp
 426:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 429:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 430:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 434:	74 17                	je     44d <printint+0x2a>
 436:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 43a:	79 11                	jns    44d <printint+0x2a>
    neg = 1;
 43c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 443:	8b 45 0c             	mov    0xc(%ebp),%eax
 446:	f7 d8                	neg    %eax
 448:	89 45 ec             	mov    %eax,-0x14(%ebp)
 44b:	eb 06                	jmp    453 <printint+0x30>
  } else {
    x = xx;
 44d:	8b 45 0c             	mov    0xc(%ebp),%eax
 450:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 453:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 45a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 45d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 460:	ba 00 00 00 00       	mov    $0x0,%edx
 465:	f7 f1                	div    %ecx
 467:	89 d1                	mov    %edx,%ecx
 469:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46c:	8d 50 01             	lea    0x1(%eax),%edx
 46f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 472:	0f b6 91 30 0b 00 00 	movzbl 0xb30(%ecx),%edx
 479:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 47d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 480:	8b 45 ec             	mov    -0x14(%ebp),%eax
 483:	ba 00 00 00 00       	mov    $0x0,%edx
 488:	f7 f1                	div    %ecx
 48a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 48d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 491:	75 c7                	jne    45a <printint+0x37>
  if(neg)
 493:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 497:	74 2d                	je     4c6 <printint+0xa3>
    buf[i++] = '-';
 499:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49c:	8d 50 01             	lea    0x1(%eax),%edx
 49f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4a7:	eb 1d                	jmp    4c6 <printint+0xa3>
    putc(fd, buf[i]);
 4a9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4af:	01 d0                	add    %edx,%eax
 4b1:	0f b6 00             	movzbl (%eax),%eax
 4b4:	0f be c0             	movsbl %al,%eax
 4b7:	83 ec 08             	sub    $0x8,%esp
 4ba:	50                   	push   %eax
 4bb:	ff 75 08             	push   0x8(%ebp)
 4be:	e8 3d ff ff ff       	call   400 <putc>
 4c3:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4c6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ce:	79 d9                	jns    4a9 <printint+0x86>
}
 4d0:	90                   	nop
 4d1:	90                   	nop
 4d2:	c9                   	leave
 4d3:	c3                   	ret

000004d4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4d4:	55                   	push   %ebp
 4d5:	89 e5                	mov    %esp,%ebp
 4d7:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4e1:	8d 45 0c             	lea    0xc(%ebp),%eax
 4e4:	83 c0 04             	add    $0x4,%eax
 4e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4f1:	e9 59 01 00 00       	jmp    64f <printf+0x17b>
    c = fmt[i] & 0xff;
 4f6:	8b 55 0c             	mov    0xc(%ebp),%edx
 4f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4fc:	01 d0                	add    %edx,%eax
 4fe:	0f b6 00             	movzbl (%eax),%eax
 501:	0f be c0             	movsbl %al,%eax
 504:	25 ff 00 00 00       	and    $0xff,%eax
 509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 50c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 510:	75 2c                	jne    53e <printf+0x6a>
      if(c == '%'){
 512:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 516:	75 0c                	jne    524 <printf+0x50>
        state = '%';
 518:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 51f:	e9 27 01 00 00       	jmp    64b <printf+0x177>
      } else {
        putc(fd, c);
 524:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 527:	0f be c0             	movsbl %al,%eax
 52a:	83 ec 08             	sub    $0x8,%esp
 52d:	50                   	push   %eax
 52e:	ff 75 08             	push   0x8(%ebp)
 531:	e8 ca fe ff ff       	call   400 <putc>
 536:	83 c4 10             	add    $0x10,%esp
 539:	e9 0d 01 00 00       	jmp    64b <printf+0x177>
      }
    } else if(state == '%'){
 53e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 542:	0f 85 03 01 00 00    	jne    64b <printf+0x177>
      if(c == 'd'){
 548:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 54c:	75 1e                	jne    56c <printf+0x98>
        printint(fd, *ap, 10, 1);
 54e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 551:	8b 00                	mov    (%eax),%eax
 553:	6a 01                	push   $0x1
 555:	6a 0a                	push   $0xa
 557:	50                   	push   %eax
 558:	ff 75 08             	push   0x8(%ebp)
 55b:	e8 c3 fe ff ff       	call   423 <printint>
 560:	83 c4 10             	add    $0x10,%esp
        ap++;
 563:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 567:	e9 d8 00 00 00       	jmp    644 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 56c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 570:	74 06                	je     578 <printf+0xa4>
 572:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 576:	75 1e                	jne    596 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 578:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57b:	8b 00                	mov    (%eax),%eax
 57d:	6a 00                	push   $0x0
 57f:	6a 10                	push   $0x10
 581:	50                   	push   %eax
 582:	ff 75 08             	push   0x8(%ebp)
 585:	e8 99 fe ff ff       	call   423 <printint>
 58a:	83 c4 10             	add    $0x10,%esp
        ap++;
 58d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 591:	e9 ae 00 00 00       	jmp    644 <printf+0x170>
      } else if(c == 's'){
 596:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 59a:	75 43                	jne    5df <printf+0x10b>
        s = (char*)*ap;
 59c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59f:	8b 00                	mov    (%eax),%eax
 5a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ac:	75 25                	jne    5d3 <printf+0xff>
          s = "(null)";
 5ae:	c7 45 f4 db 08 00 00 	movl   $0x8db,-0xc(%ebp)
        while(*s != 0){
 5b5:	eb 1c                	jmp    5d3 <printf+0xff>
          putc(fd, *s);
 5b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ba:	0f b6 00             	movzbl (%eax),%eax
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	83 ec 08             	sub    $0x8,%esp
 5c3:	50                   	push   %eax
 5c4:	ff 75 08             	push   0x8(%ebp)
 5c7:	e8 34 fe ff ff       	call   400 <putc>
 5cc:	83 c4 10             	add    $0x10,%esp
          s++;
 5cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d6:	0f b6 00             	movzbl (%eax),%eax
 5d9:	84 c0                	test   %al,%al
 5db:	75 da                	jne    5b7 <printf+0xe3>
 5dd:	eb 65                	jmp    644 <printf+0x170>
        }
      } else if(c == 'c'){
 5df:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e3:	75 1d                	jne    602 <printf+0x12e>
        putc(fd, *ap);
 5e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e8:	8b 00                	mov    (%eax),%eax
 5ea:	0f be c0             	movsbl %al,%eax
 5ed:	83 ec 08             	sub    $0x8,%esp
 5f0:	50                   	push   %eax
 5f1:	ff 75 08             	push   0x8(%ebp)
 5f4:	e8 07 fe ff ff       	call   400 <putc>
 5f9:	83 c4 10             	add    $0x10,%esp
        ap++;
 5fc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 600:	eb 42                	jmp    644 <printf+0x170>
      } else if(c == '%'){
 602:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 606:	75 17                	jne    61f <printf+0x14b>
        putc(fd, c);
 608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60b:	0f be c0             	movsbl %al,%eax
 60e:	83 ec 08             	sub    $0x8,%esp
 611:	50                   	push   %eax
 612:	ff 75 08             	push   0x8(%ebp)
 615:	e8 e6 fd ff ff       	call   400 <putc>
 61a:	83 c4 10             	add    $0x10,%esp
 61d:	eb 25                	jmp    644 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 61f:	83 ec 08             	sub    $0x8,%esp
 622:	6a 25                	push   $0x25
 624:	ff 75 08             	push   0x8(%ebp)
 627:	e8 d4 fd ff ff       	call   400 <putc>
 62c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 62f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 632:	0f be c0             	movsbl %al,%eax
 635:	83 ec 08             	sub    $0x8,%esp
 638:	50                   	push   %eax
 639:	ff 75 08             	push   0x8(%ebp)
 63c:	e8 bf fd ff ff       	call   400 <putc>
 641:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 644:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 64b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 64f:	8b 55 0c             	mov    0xc(%ebp),%edx
 652:	8b 45 f0             	mov    -0x10(%ebp),%eax
 655:	01 d0                	add    %edx,%eax
 657:	0f b6 00             	movzbl (%eax),%eax
 65a:	84 c0                	test   %al,%al
 65c:	0f 85 94 fe ff ff    	jne    4f6 <printf+0x22>
    }
  }
}
 662:	90                   	nop
 663:	90                   	nop
 664:	c9                   	leave
 665:	c3                   	ret

00000666 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 666:	55                   	push   %ebp
 667:	89 e5                	mov    %esp,%ebp
 669:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66c:	8b 45 08             	mov    0x8(%ebp),%eax
 66f:	83 e8 08             	sub    $0x8,%eax
 672:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 675:	a1 4c 0b 00 00       	mov    0xb4c,%eax
 67a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67d:	eb 24                	jmp    6a3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	8b 00                	mov    (%eax),%eax
 684:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 687:	72 12                	jb     69b <free+0x35>
 689:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68c:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 68f:	72 24                	jb     6b5 <free+0x4f>
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	8b 00                	mov    (%eax),%eax
 696:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 699:	72 1a                	jb     6b5 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	8b 00                	mov    (%eax),%eax
 6a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6a9:	73 d4                	jae    67f <free+0x19>
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 00                	mov    (%eax),%eax
 6b0:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6b3:	73 ca                	jae    67f <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b8:	8b 40 04             	mov    0x4(%eax),%eax
 6bb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c5:	01 c2                	add    %eax,%edx
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 00                	mov    (%eax),%eax
 6cc:	39 c2                	cmp    %eax,%edx
 6ce:	75 24                	jne    6f4 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d3:	8b 50 04             	mov    0x4(%eax),%edx
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	8b 00                	mov    (%eax),%eax
 6db:	8b 40 04             	mov    0x4(%eax),%eax
 6de:	01 c2                	add    %eax,%edx
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	8b 00                	mov    (%eax),%eax
 6eb:	8b 10                	mov    (%eax),%edx
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	89 10                	mov    %edx,(%eax)
 6f2:	eb 0a                	jmp    6fe <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	8b 10                	mov    (%eax),%edx
 6f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fc:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	8b 40 04             	mov    0x4(%eax),%eax
 704:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	01 d0                	add    %edx,%eax
 710:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 713:	75 20                	jne    735 <free+0xcf>
    p->s.size += bp->s.size;
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 50 04             	mov    0x4(%eax),%edx
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	8b 40 04             	mov    0x4(%eax),%eax
 721:	01 c2                	add    %eax,%edx
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 729:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72c:	8b 10                	mov    (%eax),%edx
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	89 10                	mov    %edx,(%eax)
 733:	eb 08                	jmp    73d <free+0xd7>
  } else
    p->s.ptr = bp;
 735:	8b 45 fc             	mov    -0x4(%ebp),%eax
 738:	8b 55 f8             	mov    -0x8(%ebp),%edx
 73b:	89 10                	mov    %edx,(%eax)
  freep = p;
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	a3 4c 0b 00 00       	mov    %eax,0xb4c
}
 745:	90                   	nop
 746:	c9                   	leave
 747:	c3                   	ret

00000748 <morecore>:

static Header*
morecore(uint nu)
{
 748:	55                   	push   %ebp
 749:	89 e5                	mov    %esp,%ebp
 74b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 74e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 755:	77 07                	ja     75e <morecore+0x16>
    nu = 4096;
 757:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 75e:	8b 45 08             	mov    0x8(%ebp),%eax
 761:	c1 e0 03             	shl    $0x3,%eax
 764:	83 ec 0c             	sub    $0xc,%esp
 767:	50                   	push   %eax
 768:	e8 73 fc ff ff       	call   3e0 <sbrk>
 76d:	83 c4 10             	add    $0x10,%esp
 770:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 773:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 777:	75 07                	jne    780 <morecore+0x38>
    return 0;
 779:	b8 00 00 00 00       	mov    $0x0,%eax
 77e:	eb 26                	jmp    7a6 <morecore+0x5e>
  hp = (Header*)p;
 780:	8b 45 f4             	mov    -0xc(%ebp),%eax
 783:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 786:	8b 45 f0             	mov    -0x10(%ebp),%eax
 789:	8b 55 08             	mov    0x8(%ebp),%edx
 78c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 78f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 792:	83 c0 08             	add    $0x8,%eax
 795:	83 ec 0c             	sub    $0xc,%esp
 798:	50                   	push   %eax
 799:	e8 c8 fe ff ff       	call   666 <free>
 79e:	83 c4 10             	add    $0x10,%esp
  return freep;
 7a1:	a1 4c 0b 00 00       	mov    0xb4c,%eax
}
 7a6:	c9                   	leave
 7a7:	c3                   	ret

000007a8 <malloc>:

void*
malloc(uint nbytes)
{
 7a8:	55                   	push   %ebp
 7a9:	89 e5                	mov    %esp,%ebp
 7ab:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ae:	8b 45 08             	mov    0x8(%ebp),%eax
 7b1:	83 c0 07             	add    $0x7,%eax
 7b4:	c1 e8 03             	shr    $0x3,%eax
 7b7:	83 c0 01             	add    $0x1,%eax
 7ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7bd:	a1 4c 0b 00 00       	mov    0xb4c,%eax
 7c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c9:	75 23                	jne    7ee <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7cb:	c7 45 f0 44 0b 00 00 	movl   $0xb44,-0x10(%ebp)
 7d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d5:	a3 4c 0b 00 00       	mov    %eax,0xb4c
 7da:	a1 4c 0b 00 00       	mov    0xb4c,%eax
 7df:	a3 44 0b 00 00       	mov    %eax,0xb44
    base.s.size = 0;
 7e4:	c7 05 48 0b 00 00 00 	movl   $0x0,0xb48
 7eb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f1:	8b 00                	mov    (%eax),%eax
 7f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	8b 40 04             	mov    0x4(%eax),%eax
 7fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ff:	72 4d                	jb     84e <malloc+0xa6>
      if(p->s.size == nunits)
 801:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804:	8b 40 04             	mov    0x4(%eax),%eax
 807:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 80a:	75 0c                	jne    818 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 10                	mov    (%eax),%edx
 811:	8b 45 f0             	mov    -0x10(%ebp),%eax
 814:	89 10                	mov    %edx,(%eax)
 816:	eb 26                	jmp    83e <malloc+0x96>
      else {
        p->s.size -= nunits;
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	8b 40 04             	mov    0x4(%eax),%eax
 81e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 821:	89 c2                	mov    %eax,%edx
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	8b 40 04             	mov    0x4(%eax),%eax
 82f:	c1 e0 03             	shl    $0x3,%eax
 832:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 835:	8b 45 f4             	mov    -0xc(%ebp),%eax
 838:	8b 55 ec             	mov    -0x14(%ebp),%edx
 83b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 83e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 841:	a3 4c 0b 00 00       	mov    %eax,0xb4c
      return (void*)(p + 1);
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	83 c0 08             	add    $0x8,%eax
 84c:	eb 3b                	jmp    889 <malloc+0xe1>
    }
    if(p == freep)
 84e:	a1 4c 0b 00 00       	mov    0xb4c,%eax
 853:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 856:	75 1e                	jne    876 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 858:	83 ec 0c             	sub    $0xc,%esp
 85b:	ff 75 ec             	push   -0x14(%ebp)
 85e:	e8 e5 fe ff ff       	call   748 <morecore>
 863:	83 c4 10             	add    $0x10,%esp
 866:	89 45 f4             	mov    %eax,-0xc(%ebp)
 869:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86d:	75 07                	jne    876 <malloc+0xce>
        return 0;
 86f:	b8 00 00 00 00       	mov    $0x0,%eax
 874:	eb 13                	jmp    889 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	8b 00                	mov    (%eax),%eax
 881:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 884:	e9 6d ff ff ff       	jmp    7f6 <malloc+0x4e>
  }
}
 889:	c9                   	leave
 88a:	c3                   	ret
