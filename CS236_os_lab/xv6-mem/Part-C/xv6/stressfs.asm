
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  14:	c7 45 e6 73 74 72 65 	movl   $0x65727473,-0x1a(%ebp)
  1b:	c7 45 ea 73 73 66 73 	movl   $0x73667373,-0x16(%ebp)
  22:	66 c7 45 ee 30 00    	movw   $0x30,-0x12(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 dc 08 00 00       	push   $0x8dc
  30:	6a 01                	push   $0x1
  32:	e8 ee 04 00 00       	call   525 <printf>
  37:	83 c4 10             	add    $0x10,%esp
  memset(data, 'a', sizeof(data));
  3a:	83 ec 04             	sub    $0x4,%esp
  3d:	68 00 02 00 00       	push   $0x200
  42:	6a 61                	push   $0x61
  44:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  4a:	50                   	push   %eax
  4b:	e8 be 01 00 00       	call   20e <memset>
  50:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  5a:	eb 0d                	jmp    69 <main+0x69>
    if(fork() > 0)
  5c:	e8 40 03 00 00       	call   3a1 <fork>
  61:	85 c0                	test   %eax,%eax
  63:	7f 0c                	jg     71 <main+0x71>
  for(i = 0; i < 4; i++)
  65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  69:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
  6d:	7e ed                	jle    5c <main+0x5c>
  6f:	eb 01                	jmp    72 <main+0x72>
      break;
  71:	90                   	nop

  printf(1, "write %d\n", i);
  72:	83 ec 04             	sub    $0x4,%esp
  75:	ff 75 f4             	push   -0xc(%ebp)
  78:	68 ef 08 00 00       	push   $0x8ef
  7d:	6a 01                	push   $0x1
  7f:	e8 a1 04 00 00       	call   525 <printf>
  84:	83 c4 10             	add    $0x10,%esp

  path[8] += i;
  87:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
  8b:	89 c2                	mov    %eax,%edx
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	01 d0                	add    %edx,%eax
  92:	88 45 ee             	mov    %al,-0x12(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  95:	83 ec 08             	sub    $0x8,%esp
  98:	68 02 02 00 00       	push   $0x202
  9d:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  a0:	50                   	push   %eax
  a1:	e8 43 03 00 00       	call   3e9 <open>
  a6:	83 c4 10             	add    $0x10,%esp
  a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 20; i++)
  ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  b3:	eb 1e                	jmp    d3 <main+0xd3>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  b5:	83 ec 04             	sub    $0x4,%esp
  b8:	68 00 02 00 00       	push   $0x200
  bd:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  c3:	50                   	push   %eax
  c4:	ff 75 f0             	push   -0x10(%ebp)
  c7:	e8 fd 02 00 00       	call   3c9 <write>
  cc:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 20; i++)
  cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  d3:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  d7:	7e dc                	jle    b5 <main+0xb5>
  close(fd);
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	ff 75 f0             	push   -0x10(%ebp)
  df:	e8 ed 02 00 00       	call   3d1 <close>
  e4:	83 c4 10             	add    $0x10,%esp

  printf(1, "read\n");
  e7:	83 ec 08             	sub    $0x8,%esp
  ea:	68 f9 08 00 00       	push   $0x8f9
  ef:	6a 01                	push   $0x1
  f1:	e8 2f 04 00 00       	call   525 <printf>
  f6:	83 c4 10             	add    $0x10,%esp

  fd = open(path, O_RDONLY);
  f9:	83 ec 08             	sub    $0x8,%esp
  fc:	6a 00                	push   $0x0
  fe:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 101:	50                   	push   %eax
 102:	e8 e2 02 00 00       	call   3e9 <open>
 107:	83 c4 10             	add    $0x10,%esp
 10a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < 20; i++)
 10d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 114:	eb 1e                	jmp    134 <main+0x134>
    read(fd, data, sizeof(data));
 116:	83 ec 04             	sub    $0x4,%esp
 119:	68 00 02 00 00       	push   $0x200
 11e:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
 124:	50                   	push   %eax
 125:	ff 75 f0             	push   -0x10(%ebp)
 128:	e8 94 02 00 00       	call   3c1 <read>
 12d:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 20; i++)
 130:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 134:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 138:	7e dc                	jle    116 <main+0x116>
  close(fd);
 13a:	83 ec 0c             	sub    $0xc,%esp
 13d:	ff 75 f0             	push   -0x10(%ebp)
 140:	e8 8c 02 00 00       	call   3d1 <close>
 145:	83 c4 10             	add    $0x10,%esp

  wait();
 148:	e8 64 02 00 00       	call   3b1 <wait>

  exit();
 14d:	e8 57 02 00 00       	call   3a9 <exit>

00000152 <stosb>:
  stosb(dst, c, n);
  return dst;
}

char*
strchr(const char *s, char c)
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	57                   	push   %edi
 156:	53                   	push   %ebx
{
 157:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15a:	8b 55 10             	mov    0x10(%ebp),%edx
 15d:	8b 45 0c             	mov    0xc(%ebp),%eax
 160:	89 cb                	mov    %ecx,%ebx
 162:	89 df                	mov    %ebx,%edi
 164:	89 d1                	mov    %edx,%ecx
 166:	fc                   	cld
 167:	f3 aa                	rep stos %al,%es:(%edi)
 169:	89 ca                	mov    %ecx,%edx
 16b:	89 fb                	mov    %edi,%ebx
 16d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 170:	89 55 10             	mov    %edx,0x10(%ebp)
  for(; *s; s++)
    if(*s == c)
      return (char*)s;
  return 0;
 173:	90                   	nop
 174:	5b                   	pop    %ebx
 175:	5f                   	pop    %edi
 176:	5d                   	pop    %ebp
 177:	c3                   	ret

00000178 <strcpy>:
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	83 ec 10             	sub    $0x10,%esp
  os = s;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 184:	90                   	nop
 185:	8b 55 0c             	mov    0xc(%ebp),%edx
 188:	8d 42 01             	lea    0x1(%edx),%eax
 18b:	89 45 0c             	mov    %eax,0xc(%ebp)
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	8d 48 01             	lea    0x1(%eax),%ecx
 194:	89 4d 08             	mov    %ecx,0x8(%ebp)
 197:	0f b6 12             	movzbl (%edx),%edx
 19a:	88 10                	mov    %dl,(%eax)
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	84 c0                	test   %al,%al
 1a1:	75 e2                	jne    185 <strcpy+0xd>
  return os;
 1a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a6:	c9                   	leave
 1a7:	c3                   	ret

000001a8 <strcmp>:
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1ab:	eb 08                	jmp    1b5 <strcmp+0xd>
    p++, q++;
 1ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 1b5:	8b 45 08             	mov    0x8(%ebp),%eax
 1b8:	0f b6 00             	movzbl (%eax),%eax
 1bb:	84 c0                	test   %al,%al
 1bd:	74 10                	je     1cf <strcmp+0x27>
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	0f b6 10             	movzbl (%eax),%edx
 1c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c8:	0f b6 00             	movzbl (%eax),%eax
 1cb:	38 c2                	cmp    %al,%dl
 1cd:	74 de                	je     1ad <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	0f b6 00             	movzbl (%eax),%eax
 1d5:	0f b6 d0             	movzbl %al,%edx
 1d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	0f b6 c0             	movzbl %al,%eax
 1e1:	29 c2                	sub    %eax,%edx
 1e3:	89 d0                	mov    %edx,%eax
}
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret

000001e7 <strlen>:
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 10             	sub    $0x10,%esp
  for(n = 0; s[n]; n++)
 1ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1f4:	eb 04                	jmp    1fa <strlen+0x13>
 1f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	01 d0                	add    %edx,%eax
 202:	0f b6 00             	movzbl (%eax),%eax
 205:	84 c0                	test   %al,%al
 207:	75 ed                	jne    1f6 <strlen+0xf>
  return n;
 209:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20c:	c9                   	leave
 20d:	c3                   	ret

0000020e <memset>:
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 211:	8b 45 10             	mov    0x10(%ebp),%eax
 214:	50                   	push   %eax
 215:	ff 75 0c             	push   0xc(%ebp)
 218:	ff 75 08             	push   0x8(%ebp)
 21b:	e8 32 ff ff ff       	call   152 <stosb>
 220:	83 c4 0c             	add    $0xc,%esp
  return dst;
 223:	8b 45 08             	mov    0x8(%ebp),%eax
}
 226:	c9                   	leave
 227:	c3                   	ret

00000228 <strchr>:
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 04             	sub    $0x4,%esp
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 234:	eb 14                	jmp    24a <strchr+0x22>
    if(*s == c)
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	0f b6 00             	movzbl (%eax),%eax
 23c:	38 45 fc             	cmp    %al,-0x4(%ebp)
 23f:	75 05                	jne    246 <strchr+0x1e>
      return (char*)s;
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	eb 13                	jmp    259 <strchr+0x31>
  for(; *s; s++)
 246:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	84 c0                	test   %al,%al
 252:	75 e2                	jne    236 <strchr+0xe>
  return 0;
 254:	b8 00 00 00 00       	mov    $0x0,%eax
}
 259:	c9                   	leave
 25a:	c3                   	ret

0000025b <gets>:

char*
gets(char *buf, int max)
{
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 268:	eb 42                	jmp    2ac <gets+0x51>
    cc = read(0, &c, 1);
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	6a 01                	push   $0x1
 26f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 272:	50                   	push   %eax
 273:	6a 00                	push   $0x0
 275:	e8 47 01 00 00       	call   3c1 <read>
 27a:	83 c4 10             	add    $0x10,%esp
 27d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 284:	7e 33                	jle    2b9 <gets+0x5e>
      break;
    buf[i++] = c;
 286:	8b 45 f4             	mov    -0xc(%ebp),%eax
 289:	8d 50 01             	lea    0x1(%eax),%edx
 28c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 28f:	89 c2                	mov    %eax,%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	01 c2                	add    %eax,%edx
 296:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 29c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a0:	3c 0a                	cmp    $0xa,%al
 2a2:	74 16                	je     2ba <gets+0x5f>
 2a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a8:	3c 0d                	cmp    $0xd,%al
 2aa:	74 0e                	je     2ba <gets+0x5f>
  for(i=0; i+1 < max; ){
 2ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2af:	83 c0 01             	add    $0x1,%eax
 2b2:	39 45 0c             	cmp    %eax,0xc(%ebp)
 2b5:	7f b3                	jg     26a <gets+0xf>
 2b7:	eb 01                	jmp    2ba <gets+0x5f>
      break;
 2b9:	90                   	nop
      break;
  }
  buf[i] = '\0';
 2ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	01 d0                	add    %edx,%eax
 2c2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c8:	c9                   	leave
 2c9:	c3                   	ret

000002ca <stat>:

int
stat(const char *n, struct stat *st)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d0:	83 ec 08             	sub    $0x8,%esp
 2d3:	6a 00                	push   $0x0
 2d5:	ff 75 08             	push   0x8(%ebp)
 2d8:	e8 0c 01 00 00       	call   3e9 <open>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e7:	79 07                	jns    2f0 <stat+0x26>
    return -1;
 2e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ee:	eb 25                	jmp    315 <stat+0x4b>
  r = fstat(fd, st);
 2f0:	83 ec 08             	sub    $0x8,%esp
 2f3:	ff 75 0c             	push   0xc(%ebp)
 2f6:	ff 75 f4             	push   -0xc(%ebp)
 2f9:	e8 03 01 00 00       	call   401 <fstat>
 2fe:	83 c4 10             	add    $0x10,%esp
 301:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 304:	83 ec 0c             	sub    $0xc,%esp
 307:	ff 75 f4             	push   -0xc(%ebp)
 30a:	e8 c2 00 00 00       	call   3d1 <close>
 30f:	83 c4 10             	add    $0x10,%esp
  return r;
 312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 315:	c9                   	leave
 316:	c3                   	ret

00000317 <atoi>:

int
atoi(const char *s)
{
 317:	55                   	push   %ebp
 318:	89 e5                	mov    %esp,%ebp
 31a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 31d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 324:	eb 25                	jmp    34b <atoi+0x34>
    n = n*10 + *s++ - '0';
 326:	8b 55 fc             	mov    -0x4(%ebp),%edx
 329:	89 d0                	mov    %edx,%eax
 32b:	c1 e0 02             	shl    $0x2,%eax
 32e:	01 d0                	add    %edx,%eax
 330:	01 c0                	add    %eax,%eax
 332:	89 c1                	mov    %eax,%ecx
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	8d 50 01             	lea    0x1(%eax),%edx
 33a:	89 55 08             	mov    %edx,0x8(%ebp)
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	0f be c0             	movsbl %al,%eax
 343:	01 c8                	add    %ecx,%eax
 345:	83 e8 30             	sub    $0x30,%eax
 348:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
 34e:	0f b6 00             	movzbl (%eax),%eax
 351:	3c 2f                	cmp    $0x2f,%al
 353:	7e 0a                	jle    35f <atoi+0x48>
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	0f b6 00             	movzbl (%eax),%eax
 35b:	3c 39                	cmp    $0x39,%al
 35d:	7e c7                	jle    326 <atoi+0xf>
  return n;
 35f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 362:	c9                   	leave
 363:	c3                   	ret

00000364 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
 36d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 370:	8b 45 0c             	mov    0xc(%ebp),%eax
 373:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 376:	eb 17                	jmp    38f <memmove+0x2b>
    *dst++ = *src++;
 378:	8b 55 f8             	mov    -0x8(%ebp),%edx
 37b:	8d 42 01             	lea    0x1(%edx),%eax
 37e:	89 45 f8             	mov    %eax,-0x8(%ebp)
 381:	8b 45 fc             	mov    -0x4(%ebp),%eax
 384:	8d 48 01             	lea    0x1(%eax),%ecx
 387:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 38a:	0f b6 12             	movzbl (%edx),%edx
 38d:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 38f:	8b 45 10             	mov    0x10(%ebp),%eax
 392:	8d 50 ff             	lea    -0x1(%eax),%edx
 395:	89 55 10             	mov    %edx,0x10(%ebp)
 398:	85 c0                	test   %eax,%eax
 39a:	7f dc                	jg     378 <memmove+0x14>
  return vdst;
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 39f:	c9                   	leave
 3a0:	c3                   	ret

000003a1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3a1:	b8 01 00 00 00       	mov    $0x1,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret

000003a9 <exit>:
SYSCALL(exit)
 3a9:	b8 02 00 00 00       	mov    $0x2,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret

000003b1 <wait>:
SYSCALL(wait)
 3b1:	b8 03 00 00 00       	mov    $0x3,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret

000003b9 <pipe>:
SYSCALL(pipe)
 3b9:	b8 04 00 00 00       	mov    $0x4,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret

000003c1 <read>:
SYSCALL(read)
 3c1:	b8 05 00 00 00       	mov    $0x5,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret

000003c9 <write>:
SYSCALL(write)
 3c9:	b8 10 00 00 00       	mov    $0x10,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret

000003d1 <close>:
SYSCALL(close)
 3d1:	b8 15 00 00 00       	mov    $0x15,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret

000003d9 <kill>:
SYSCALL(kill)
 3d9:	b8 06 00 00 00       	mov    $0x6,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret

000003e1 <exec>:
SYSCALL(exec)
 3e1:	b8 07 00 00 00       	mov    $0x7,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret

000003e9 <open>:
SYSCALL(open)
 3e9:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret

000003f1 <mknod>:
SYSCALL(mknod)
 3f1:	b8 11 00 00 00       	mov    $0x11,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret

000003f9 <unlink>:
SYSCALL(unlink)
 3f9:	b8 12 00 00 00       	mov    $0x12,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret

00000401 <fstat>:
SYSCALL(fstat)
 401:	b8 08 00 00 00       	mov    $0x8,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret

00000409 <link>:
SYSCALL(link)
 409:	b8 13 00 00 00       	mov    $0x13,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret

00000411 <mkdir>:
SYSCALL(mkdir)
 411:	b8 14 00 00 00       	mov    $0x14,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret

00000419 <chdir>:
SYSCALL(chdir)
 419:	b8 09 00 00 00       	mov    $0x9,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret

00000421 <dup>:
SYSCALL(dup)
 421:	b8 0a 00 00 00       	mov    $0xa,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret

00000429 <getpid>:
SYSCALL(getpid)
 429:	b8 0b 00 00 00       	mov    $0xb,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret

00000431 <sbrk>:
SYSCALL(sbrk)
 431:	b8 0c 00 00 00       	mov    $0xc,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret

00000439 <sleep>:
SYSCALL(sleep)
 439:	b8 0d 00 00 00       	mov    $0xd,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret

00000441 <uptime>:
SYSCALL(uptime)
 441:	b8 0e 00 00 00       	mov    $0xe,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret

00000449 <getNumFreePages>:
SYSCALL(getNumFreePages)
 449:	b8 16 00 00 00       	mov    $0x16,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret

00000451 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 451:	55                   	push   %ebp
 452:	89 e5                	mov    %esp,%ebp
 454:	83 ec 18             	sub    $0x18,%esp
 457:	8b 45 0c             	mov    0xc(%ebp),%eax
 45a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 45d:	83 ec 04             	sub    $0x4,%esp
 460:	6a 01                	push   $0x1
 462:	8d 45 f4             	lea    -0xc(%ebp),%eax
 465:	50                   	push   %eax
 466:	ff 75 08             	push   0x8(%ebp)
 469:	e8 5b ff ff ff       	call   3c9 <write>
 46e:	83 c4 10             	add    $0x10,%esp
}
 471:	90                   	nop
 472:	c9                   	leave
 473:	c3                   	ret

00000474 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 474:	55                   	push   %ebp
 475:	89 e5                	mov    %esp,%ebp
 477:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 47a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 481:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 485:	74 17                	je     49e <printint+0x2a>
 487:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 48b:	79 11                	jns    49e <printint+0x2a>
    neg = 1;
 48d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 494:	8b 45 0c             	mov    0xc(%ebp),%eax
 497:	f7 d8                	neg    %eax
 499:	89 45 ec             	mov    %eax,-0x14(%ebp)
 49c:	eb 06                	jmp    4a4 <printint+0x30>
  } else {
    x = xx;
 49e:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b1:	ba 00 00 00 00       	mov    $0x0,%edx
 4b6:	f7 f1                	div    %ecx
 4b8:	89 d1                	mov    %edx,%ecx
 4ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bd:	8d 50 01             	lea    0x1(%eax),%edx
 4c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4c3:	0f b6 91 4c 0b 00 00 	movzbl 0xb4c(%ecx),%edx
 4ca:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 4ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d4:	ba 00 00 00 00       	mov    $0x0,%edx
 4d9:	f7 f1                	div    %ecx
 4db:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e2:	75 c7                	jne    4ab <printint+0x37>
  if(neg)
 4e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4e8:	74 2d                	je     517 <printint+0xa3>
    buf[i++] = '-';
 4ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ed:	8d 50 01             	lea    0x1(%eax),%edx
 4f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4f3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4f8:	eb 1d                	jmp    517 <printint+0xa3>
    putc(fd, buf[i]);
 4fa:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 500:	01 d0                	add    %edx,%eax
 502:	0f b6 00             	movzbl (%eax),%eax
 505:	0f be c0             	movsbl %al,%eax
 508:	83 ec 08             	sub    $0x8,%esp
 50b:	50                   	push   %eax
 50c:	ff 75 08             	push   0x8(%ebp)
 50f:	e8 3d ff ff ff       	call   451 <putc>
 514:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 517:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 51b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 51f:	79 d9                	jns    4fa <printint+0x86>
}
 521:	90                   	nop
 522:	90                   	nop
 523:	c9                   	leave
 524:	c3                   	ret

00000525 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 525:	55                   	push   %ebp
 526:	89 e5                	mov    %esp,%ebp
 528:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 52b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 532:	8d 45 0c             	lea    0xc(%ebp),%eax
 535:	83 c0 04             	add    $0x4,%eax
 538:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 53b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 542:	e9 59 01 00 00       	jmp    6a0 <printf+0x17b>
    c = fmt[i] & 0xff;
 547:	8b 55 0c             	mov    0xc(%ebp),%edx
 54a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 54d:	01 d0                	add    %edx,%eax
 54f:	0f b6 00             	movzbl (%eax),%eax
 552:	0f be c0             	movsbl %al,%eax
 555:	25 ff 00 00 00       	and    $0xff,%eax
 55a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 55d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 561:	75 2c                	jne    58f <printf+0x6a>
      if(c == '%'){
 563:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 567:	75 0c                	jne    575 <printf+0x50>
        state = '%';
 569:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 570:	e9 27 01 00 00       	jmp    69c <printf+0x177>
      } else {
        putc(fd, c);
 575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 578:	0f be c0             	movsbl %al,%eax
 57b:	83 ec 08             	sub    $0x8,%esp
 57e:	50                   	push   %eax
 57f:	ff 75 08             	push   0x8(%ebp)
 582:	e8 ca fe ff ff       	call   451 <putc>
 587:	83 c4 10             	add    $0x10,%esp
 58a:	e9 0d 01 00 00       	jmp    69c <printf+0x177>
      }
    } else if(state == '%'){
 58f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 593:	0f 85 03 01 00 00    	jne    69c <printf+0x177>
      if(c == 'd'){
 599:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 59d:	75 1e                	jne    5bd <printf+0x98>
        printint(fd, *ap, 10, 1);
 59f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a2:	8b 00                	mov    (%eax),%eax
 5a4:	6a 01                	push   $0x1
 5a6:	6a 0a                	push   $0xa
 5a8:	50                   	push   %eax
 5a9:	ff 75 08             	push   0x8(%ebp)
 5ac:	e8 c3 fe ff ff       	call   474 <printint>
 5b1:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b8:	e9 d8 00 00 00       	jmp    695 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5bd:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5c1:	74 06                	je     5c9 <printf+0xa4>
 5c3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5c7:	75 1e                	jne    5e7 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cc:	8b 00                	mov    (%eax),%eax
 5ce:	6a 00                	push   $0x0
 5d0:	6a 10                	push   $0x10
 5d2:	50                   	push   %eax
 5d3:	ff 75 08             	push   0x8(%ebp)
 5d6:	e8 99 fe ff ff       	call   474 <printint>
 5db:	83 c4 10             	add    $0x10,%esp
        ap++;
 5de:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e2:	e9 ae 00 00 00       	jmp    695 <printf+0x170>
      } else if(c == 's'){
 5e7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5eb:	75 43                	jne    630 <printf+0x10b>
        s = (char*)*ap;
 5ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f0:	8b 00                	mov    (%eax),%eax
 5f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5f5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5fd:	75 25                	jne    624 <printf+0xff>
          s = "(null)";
 5ff:	c7 45 f4 ff 08 00 00 	movl   $0x8ff,-0xc(%ebp)
        while(*s != 0){
 606:	eb 1c                	jmp    624 <printf+0xff>
          putc(fd, *s);
 608:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60b:	0f b6 00             	movzbl (%eax),%eax
 60e:	0f be c0             	movsbl %al,%eax
 611:	83 ec 08             	sub    $0x8,%esp
 614:	50                   	push   %eax
 615:	ff 75 08             	push   0x8(%ebp)
 618:	e8 34 fe ff ff       	call   451 <putc>
 61d:	83 c4 10             	add    $0x10,%esp
          s++;
 620:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 624:	8b 45 f4             	mov    -0xc(%ebp),%eax
 627:	0f b6 00             	movzbl (%eax),%eax
 62a:	84 c0                	test   %al,%al
 62c:	75 da                	jne    608 <printf+0xe3>
 62e:	eb 65                	jmp    695 <printf+0x170>
        }
      } else if(c == 'c'){
 630:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 634:	75 1d                	jne    653 <printf+0x12e>
        putc(fd, *ap);
 636:	8b 45 e8             	mov    -0x18(%ebp),%eax
 639:	8b 00                	mov    (%eax),%eax
 63b:	0f be c0             	movsbl %al,%eax
 63e:	83 ec 08             	sub    $0x8,%esp
 641:	50                   	push   %eax
 642:	ff 75 08             	push   0x8(%ebp)
 645:	e8 07 fe ff ff       	call   451 <putc>
 64a:	83 c4 10             	add    $0x10,%esp
        ap++;
 64d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 651:	eb 42                	jmp    695 <printf+0x170>
      } else if(c == '%'){
 653:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 657:	75 17                	jne    670 <printf+0x14b>
        putc(fd, c);
 659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65c:	0f be c0             	movsbl %al,%eax
 65f:	83 ec 08             	sub    $0x8,%esp
 662:	50                   	push   %eax
 663:	ff 75 08             	push   0x8(%ebp)
 666:	e8 e6 fd ff ff       	call   451 <putc>
 66b:	83 c4 10             	add    $0x10,%esp
 66e:	eb 25                	jmp    695 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 670:	83 ec 08             	sub    $0x8,%esp
 673:	6a 25                	push   $0x25
 675:	ff 75 08             	push   0x8(%ebp)
 678:	e8 d4 fd ff ff       	call   451 <putc>
 67d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 683:	0f be c0             	movsbl %al,%eax
 686:	83 ec 08             	sub    $0x8,%esp
 689:	50                   	push   %eax
 68a:	ff 75 08             	push   0x8(%ebp)
 68d:	e8 bf fd ff ff       	call   451 <putc>
 692:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 695:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 69c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6a0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a6:	01 d0                	add    %edx,%eax
 6a8:	0f b6 00             	movzbl (%eax),%eax
 6ab:	84 c0                	test   %al,%al
 6ad:	0f 85 94 fe ff ff    	jne    547 <printf+0x22>
    }
  }
}
 6b3:	90                   	nop
 6b4:	90                   	nop
 6b5:	c9                   	leave
 6b6:	c3                   	ret

000006b7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b7:	55                   	push   %ebp
 6b8:	89 e5                	mov    %esp,%ebp
 6ba:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6bd:	8b 45 08             	mov    0x8(%ebp),%eax
 6c0:	83 e8 08             	sub    $0x8,%eax
 6c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c6:	a1 68 0b 00 00       	mov    0xb68,%eax
 6cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ce:	eb 24                	jmp    6f4 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	8b 00                	mov    (%eax),%eax
 6d5:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6d8:	72 12                	jb     6ec <free+0x35>
 6da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dd:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6e0:	72 24                	jb     706 <free+0x4f>
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	8b 00                	mov    (%eax),%eax
 6e7:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6ea:	72 1a                	jb     706 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 00                	mov    (%eax),%eax
 6f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f7:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6fa:	73 d4                	jae    6d0 <free+0x19>
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	8b 00                	mov    (%eax),%eax
 701:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 704:	73 ca                	jae    6d0 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 706:	8b 45 f8             	mov    -0x8(%ebp),%eax
 709:	8b 40 04             	mov    0x4(%eax),%eax
 70c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 713:	8b 45 f8             	mov    -0x8(%ebp),%eax
 716:	01 c2                	add    %eax,%edx
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	8b 00                	mov    (%eax),%eax
 71d:	39 c2                	cmp    %eax,%edx
 71f:	75 24                	jne    745 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 721:	8b 45 f8             	mov    -0x8(%ebp),%eax
 724:	8b 50 04             	mov    0x4(%eax),%edx
 727:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72a:	8b 00                	mov    (%eax),%eax
 72c:	8b 40 04             	mov    0x4(%eax),%eax
 72f:	01 c2                	add    %eax,%edx
 731:	8b 45 f8             	mov    -0x8(%ebp),%eax
 734:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 737:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73a:	8b 00                	mov    (%eax),%eax
 73c:	8b 10                	mov    (%eax),%edx
 73e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 741:	89 10                	mov    %edx,(%eax)
 743:	eb 0a                	jmp    74f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 10                	mov    (%eax),%edx
 74a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 74f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 752:	8b 40 04             	mov    0x4(%eax),%eax
 755:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 75c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75f:	01 d0                	add    %edx,%eax
 761:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 764:	75 20                	jne    786 <free+0xcf>
    p->s.size += bp->s.size;
 766:	8b 45 fc             	mov    -0x4(%ebp),%eax
 769:	8b 50 04             	mov    0x4(%eax),%edx
 76c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76f:	8b 40 04             	mov    0x4(%eax),%eax
 772:	01 c2                	add    %eax,%edx
 774:	8b 45 fc             	mov    -0x4(%ebp),%eax
 777:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 77a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77d:	8b 10                	mov    (%eax),%edx
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	89 10                	mov    %edx,(%eax)
 784:	eb 08                	jmp    78e <free+0xd7>
  } else
    p->s.ptr = bp;
 786:	8b 45 fc             	mov    -0x4(%ebp),%eax
 789:	8b 55 f8             	mov    -0x8(%ebp),%edx
 78c:	89 10                	mov    %edx,(%eax)
  freep = p;
 78e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 791:	a3 68 0b 00 00       	mov    %eax,0xb68
}
 796:	90                   	nop
 797:	c9                   	leave
 798:	c3                   	ret

00000799 <morecore>:

static Header*
morecore(uint nu)
{
 799:	55                   	push   %ebp
 79a:	89 e5                	mov    %esp,%ebp
 79c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 79f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7a6:	77 07                	ja     7af <morecore+0x16>
    nu = 4096;
 7a8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7af:	8b 45 08             	mov    0x8(%ebp),%eax
 7b2:	c1 e0 03             	shl    $0x3,%eax
 7b5:	83 ec 0c             	sub    $0xc,%esp
 7b8:	50                   	push   %eax
 7b9:	e8 73 fc ff ff       	call   431 <sbrk>
 7be:	83 c4 10             	add    $0x10,%esp
 7c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7c4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7c8:	75 07                	jne    7d1 <morecore+0x38>
    return 0;
 7ca:	b8 00 00 00 00       	mov    $0x0,%eax
 7cf:	eb 26                	jmp    7f7 <morecore+0x5e>
  hp = (Header*)p;
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7da:	8b 55 08             	mov    0x8(%ebp),%edx
 7dd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e3:	83 c0 08             	add    $0x8,%eax
 7e6:	83 ec 0c             	sub    $0xc,%esp
 7e9:	50                   	push   %eax
 7ea:	e8 c8 fe ff ff       	call   6b7 <free>
 7ef:	83 c4 10             	add    $0x10,%esp
  return freep;
 7f2:	a1 68 0b 00 00       	mov    0xb68,%eax
}
 7f7:	c9                   	leave
 7f8:	c3                   	ret

000007f9 <malloc>:

void*
malloc(uint nbytes)
{
 7f9:	55                   	push   %ebp
 7fa:	89 e5                	mov    %esp,%ebp
 7fc:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ff:	8b 45 08             	mov    0x8(%ebp),%eax
 802:	83 c0 07             	add    $0x7,%eax
 805:	c1 e8 03             	shr    $0x3,%eax
 808:	83 c0 01             	add    $0x1,%eax
 80b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 80e:	a1 68 0b 00 00       	mov    0xb68,%eax
 813:	89 45 f0             	mov    %eax,-0x10(%ebp)
 816:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 81a:	75 23                	jne    83f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 81c:	c7 45 f0 60 0b 00 00 	movl   $0xb60,-0x10(%ebp)
 823:	8b 45 f0             	mov    -0x10(%ebp),%eax
 826:	a3 68 0b 00 00       	mov    %eax,0xb68
 82b:	a1 68 0b 00 00       	mov    0xb68,%eax
 830:	a3 60 0b 00 00       	mov    %eax,0xb60
    base.s.size = 0;
 835:	c7 05 64 0b 00 00 00 	movl   $0x0,0xb64
 83c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 842:	8b 00                	mov    (%eax),%eax
 844:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	8b 40 04             	mov    0x4(%eax),%eax
 84d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 850:	72 4d                	jb     89f <malloc+0xa6>
      if(p->s.size == nunits)
 852:	8b 45 f4             	mov    -0xc(%ebp),%eax
 855:	8b 40 04             	mov    0x4(%eax),%eax
 858:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 85b:	75 0c                	jne    869 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	8b 10                	mov    (%eax),%edx
 862:	8b 45 f0             	mov    -0x10(%ebp),%eax
 865:	89 10                	mov    %edx,(%eax)
 867:	eb 26                	jmp    88f <malloc+0x96>
      else {
        p->s.size -= nunits;
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	8b 40 04             	mov    0x4(%eax),%eax
 86f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 872:	89 c2                	mov    %eax,%edx
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	8b 40 04             	mov    0x4(%eax),%eax
 880:	c1 e0 03             	shl    $0x3,%eax
 883:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	8b 55 ec             	mov    -0x14(%ebp),%edx
 88c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 88f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 892:	a3 68 0b 00 00       	mov    %eax,0xb68
      return (void*)(p + 1);
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	83 c0 08             	add    $0x8,%eax
 89d:	eb 3b                	jmp    8da <malloc+0xe1>
    }
    if(p == freep)
 89f:	a1 68 0b 00 00       	mov    0xb68,%eax
 8a4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8a7:	75 1e                	jne    8c7 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8a9:	83 ec 0c             	sub    $0xc,%esp
 8ac:	ff 75 ec             	push   -0x14(%ebp)
 8af:	e8 e5 fe ff ff       	call   799 <morecore>
 8b4:	83 c4 10             	add    $0x10,%esp
 8b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8be:	75 07                	jne    8c7 <malloc+0xce>
        return 0;
 8c0:	b8 00 00 00 00       	mov    $0x0,%eax
 8c5:	eb 13                	jmp    8da <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d0:	8b 00                	mov    (%eax),%eax
 8d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8d5:	e9 6d ff ff ff       	jmp    847 <malloc+0x4e>
  }
}
 8da:	c9                   	leave
 8db:	c3                   	ret
