
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   6:	eb 31                	jmp    39 <cat+0x39>
    if (write(1, buf, n) != n) {
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	push   -0xc(%ebp)
   e:	68 80 0b 00 00       	push   $0xb80
  13:	6a 01                	push   $0x1
  15:	e8 88 03 00 00       	call   3a2 <write>
  1a:	83 c4 10             	add    $0x10,%esp
  1d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  20:	74 17                	je     39 <cat+0x39>
      printf(1, "cat: write error\n");
  22:	83 ec 08             	sub    $0x8,%esp
  25:	68 b5 08 00 00       	push   $0x8b5
  2a:	6a 01                	push   $0x1
  2c:	e8 cd 04 00 00       	call   4fe <printf>
  31:	83 c4 10             	add    $0x10,%esp
      exit();
  34:	e8 49 03 00 00       	call   382 <exit>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  39:	83 ec 04             	sub    $0x4,%esp
  3c:	68 00 02 00 00       	push   $0x200
  41:	68 80 0b 00 00       	push   $0xb80
  46:	ff 75 08             	push   0x8(%ebp)
  49:	e8 4c 03 00 00       	call   39a <read>
  4e:	83 c4 10             	add    $0x10,%esp
  51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  58:	7f ae                	jg     8 <cat+0x8>
    }
  }
  if(n < 0){
  5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  5e:	79 17                	jns    77 <cat+0x77>
    printf(1, "cat: read error\n");
  60:	83 ec 08             	sub    $0x8,%esp
  63:	68 c7 08 00 00       	push   $0x8c7
  68:	6a 01                	push   $0x1
  6a:	e8 8f 04 00 00       	call   4fe <printf>
  6f:	83 c4 10             	add    $0x10,%esp
    exit();
  72:	e8 0b 03 00 00       	call   382 <exit>
  }
}
  77:	90                   	nop
  78:	c9                   	leave
  79:	c3                   	ret

0000007a <main>:

int
main(int argc, char *argv[])
{
  7a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  7e:	83 e4 f0             	and    $0xfffffff0,%esp
  81:	ff 71 fc             	push   -0x4(%ecx)
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	53                   	push   %ebx
  88:	51                   	push   %ecx
  89:	83 ec 10             	sub    $0x10,%esp
  8c:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  8e:	83 3b 01             	cmpl   $0x1,(%ebx)
  91:	7f 12                	jg     a5 <main+0x2b>
    cat(0);
  93:	83 ec 0c             	sub    $0xc,%esp
  96:	6a 00                	push   $0x0
  98:	e8 63 ff ff ff       	call   0 <cat>
  9d:	83 c4 10             	add    $0x10,%esp
    exit();
  a0:	e8 dd 02 00 00       	call   382 <exit>
  }

  for(i = 1; i < argc; i++){
  a5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  ac:	eb 71                	jmp    11f <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
  ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  b8:	8b 43 04             	mov    0x4(%ebx),%eax
  bb:	01 d0                	add    %edx,%eax
  bd:	8b 00                	mov    (%eax),%eax
  bf:	83 ec 08             	sub    $0x8,%esp
  c2:	6a 00                	push   $0x0
  c4:	50                   	push   %eax
  c5:	e8 f8 02 00 00       	call   3c2 <open>
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  d4:	79 29                	jns    ff <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
  d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  e0:	8b 43 04             	mov    0x4(%ebx),%eax
  e3:	01 d0                	add    %edx,%eax
  e5:	8b 00                	mov    (%eax),%eax
  e7:	83 ec 04             	sub    $0x4,%esp
  ea:	50                   	push   %eax
  eb:	68 d8 08 00 00       	push   $0x8d8
  f0:	6a 01                	push   $0x1
  f2:	e8 07 04 00 00       	call   4fe <printf>
  f7:	83 c4 10             	add    $0x10,%esp
      exit();
  fa:	e8 83 02 00 00       	call   382 <exit>
    }
    cat(fd);
  ff:	83 ec 0c             	sub    $0xc,%esp
 102:	ff 75 f0             	push   -0x10(%ebp)
 105:	e8 f6 fe ff ff       	call   0 <cat>
 10a:	83 c4 10             	add    $0x10,%esp
    close(fd);
 10d:	83 ec 0c             	sub    $0xc,%esp
 110:	ff 75 f0             	push   -0x10(%ebp)
 113:	e8 92 02 00 00       	call   3aa <close>
 118:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
 11b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 11f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 122:	3b 03                	cmp    (%ebx),%eax
 124:	7c 88                	jl     ae <main+0x34>
  }
  exit();
 126:	e8 57 02 00 00       	call   382 <exit>

0000012b <stosb>:
  stosb(dst, c, n);
  return dst;
}

char*
strchr(const char *s, char c)
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
 12e:	57                   	push   %edi
 12f:	53                   	push   %ebx
{
 130:	8b 4d 08             	mov    0x8(%ebp),%ecx
 133:	8b 55 10             	mov    0x10(%ebp),%edx
 136:	8b 45 0c             	mov    0xc(%ebp),%eax
 139:	89 cb                	mov    %ecx,%ebx
 13b:	89 df                	mov    %ebx,%edi
 13d:	89 d1                	mov    %edx,%ecx
 13f:	fc                   	cld
 140:	f3 aa                	rep stos %al,%es:(%edi)
 142:	89 ca                	mov    %ecx,%edx
 144:	89 fb                	mov    %edi,%ebx
 146:	89 5d 08             	mov    %ebx,0x8(%ebp)
 149:	89 55 10             	mov    %edx,0x10(%ebp)
  for(; *s; s++)
    if(*s == c)
      return (char*)s;
  return 0;
 14c:	90                   	nop
 14d:	5b                   	pop    %ebx
 14e:	5f                   	pop    %edi
 14f:	5d                   	pop    %ebp
 150:	c3                   	ret

00000151 <strcpy>:
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	83 ec 10             	sub    $0x10,%esp
  os = s;
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 15d:	90                   	nop
 15e:	8b 55 0c             	mov    0xc(%ebp),%edx
 161:	8d 42 01             	lea    0x1(%edx),%eax
 164:	89 45 0c             	mov    %eax,0xc(%ebp)
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	8d 48 01             	lea    0x1(%eax),%ecx
 16d:	89 4d 08             	mov    %ecx,0x8(%ebp)
 170:	0f b6 12             	movzbl (%edx),%edx
 173:	88 10                	mov    %dl,(%eax)
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	75 e2                	jne    15e <strcpy+0xd>
  return os;
 17c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17f:	c9                   	leave
 180:	c3                   	ret

00000181 <strcmp>:
{
 181:	55                   	push   %ebp
 182:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 184:	eb 08                	jmp    18e <strcmp+0xd>
    p++, q++;
 186:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 18a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	0f b6 00             	movzbl (%eax),%eax
 194:	84 c0                	test   %al,%al
 196:	74 10                	je     1a8 <strcmp+0x27>
 198:	8b 45 08             	mov    0x8(%ebp),%eax
 19b:	0f b6 10             	movzbl (%eax),%edx
 19e:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	38 c2                	cmp    %al,%dl
 1a6:	74 de                	je     186 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	0f b6 00             	movzbl (%eax),%eax
 1ae:	0f b6 d0             	movzbl %al,%edx
 1b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b4:	0f b6 00             	movzbl (%eax),%eax
 1b7:	0f b6 c0             	movzbl %al,%eax
 1ba:	29 c2                	sub    %eax,%edx
 1bc:	89 d0                	mov    %edx,%eax
}
 1be:	5d                   	pop    %ebp
 1bf:	c3                   	ret

000001c0 <strlen>:
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	83 ec 10             	sub    $0x10,%esp
  for(n = 0; s[n]; n++)
 1c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1cd:	eb 04                	jmp    1d3 <strlen+0x13>
 1cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	01 d0                	add    %edx,%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	84 c0                	test   %al,%al
 1e0:	75 ed                	jne    1cf <strlen+0xf>
  return n;
 1e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1e5:	c9                   	leave
 1e6:	c3                   	ret

000001e7 <memset>:
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ea:	8b 45 10             	mov    0x10(%ebp),%eax
 1ed:	50                   	push   %eax
 1ee:	ff 75 0c             	push   0xc(%ebp)
 1f1:	ff 75 08             	push   0x8(%ebp)
 1f4:	e8 32 ff ff ff       	call   12b <stosb>
 1f9:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ff:	c9                   	leave
 200:	c3                   	ret

00000201 <strchr>:
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 04             	sub    $0x4,%esp
 207:	8b 45 0c             	mov    0xc(%ebp),%eax
 20a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 20d:	eb 14                	jmp    223 <strchr+0x22>
    if(*s == c)
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	0f b6 00             	movzbl (%eax),%eax
 215:	38 45 fc             	cmp    %al,-0x4(%ebp)
 218:	75 05                	jne    21f <strchr+0x1e>
      return (char*)s;
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	eb 13                	jmp    232 <strchr+0x31>
  for(; *s; s++)
 21f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	75 e2                	jne    20f <strchr+0xe>
  return 0;
 22d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 232:	c9                   	leave
 233:	c3                   	ret

00000234 <gets>:

char*
gets(char *buf, int max)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 241:	eb 42                	jmp    285 <gets+0x51>
    cc = read(0, &c, 1);
 243:	83 ec 04             	sub    $0x4,%esp
 246:	6a 01                	push   $0x1
 248:	8d 45 ef             	lea    -0x11(%ebp),%eax
 24b:	50                   	push   %eax
 24c:	6a 00                	push   $0x0
 24e:	e8 47 01 00 00       	call   39a <read>
 253:	83 c4 10             	add    $0x10,%esp
 256:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 259:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 25d:	7e 33                	jle    292 <gets+0x5e>
      break;
    buf[i++] = c;
 25f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 262:	8d 50 01             	lea    0x1(%eax),%edx
 265:	89 55 f4             	mov    %edx,-0xc(%ebp)
 268:	89 c2                	mov    %eax,%edx
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	01 c2                	add    %eax,%edx
 26f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 273:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 275:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 279:	3c 0a                	cmp    $0xa,%al
 27b:	74 16                	je     293 <gets+0x5f>
 27d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 281:	3c 0d                	cmp    $0xd,%al
 283:	74 0e                	je     293 <gets+0x5f>
  for(i=0; i+1 < max; ){
 285:	8b 45 f4             	mov    -0xc(%ebp),%eax
 288:	83 c0 01             	add    $0x1,%eax
 28b:	39 45 0c             	cmp    %eax,0xc(%ebp)
 28e:	7f b3                	jg     243 <gets+0xf>
 290:	eb 01                	jmp    293 <gets+0x5f>
      break;
 292:	90                   	nop
      break;
  }
  buf[i] = '\0';
 293:	8b 55 f4             	mov    -0xc(%ebp),%edx
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	01 d0                	add    %edx,%eax
 29b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a1:	c9                   	leave
 2a2:	c3                   	ret

000002a3 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
 2a6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a9:	83 ec 08             	sub    $0x8,%esp
 2ac:	6a 00                	push   $0x0
 2ae:	ff 75 08             	push   0x8(%ebp)
 2b1:	e8 0c 01 00 00       	call   3c2 <open>
 2b6:	83 c4 10             	add    $0x10,%esp
 2b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c0:	79 07                	jns    2c9 <stat+0x26>
    return -1;
 2c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c7:	eb 25                	jmp    2ee <stat+0x4b>
  r = fstat(fd, st);
 2c9:	83 ec 08             	sub    $0x8,%esp
 2cc:	ff 75 0c             	push   0xc(%ebp)
 2cf:	ff 75 f4             	push   -0xc(%ebp)
 2d2:	e8 03 01 00 00       	call   3da <fstat>
 2d7:	83 c4 10             	add    $0x10,%esp
 2da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2dd:	83 ec 0c             	sub    $0xc,%esp
 2e0:	ff 75 f4             	push   -0xc(%ebp)
 2e3:	e8 c2 00 00 00       	call   3aa <close>
 2e8:	83 c4 10             	add    $0x10,%esp
  return r;
 2eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2ee:	c9                   	leave
 2ef:	c3                   	ret

000002f0 <atoi>:

int
atoi(const char *s)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2fd:	eb 25                	jmp    324 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
 302:	89 d0                	mov    %edx,%eax
 304:	c1 e0 02             	shl    $0x2,%eax
 307:	01 d0                	add    %edx,%eax
 309:	01 c0                	add    %eax,%eax
 30b:	89 c1                	mov    %eax,%ecx
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	8d 50 01             	lea    0x1(%eax),%edx
 313:	89 55 08             	mov    %edx,0x8(%ebp)
 316:	0f b6 00             	movzbl (%eax),%eax
 319:	0f be c0             	movsbl %al,%eax
 31c:	01 c8                	add    %ecx,%eax
 31e:	83 e8 30             	sub    $0x30,%eax
 321:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	0f b6 00             	movzbl (%eax),%eax
 32a:	3c 2f                	cmp    $0x2f,%al
 32c:	7e 0a                	jle    338 <atoi+0x48>
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	0f b6 00             	movzbl (%eax),%eax
 334:	3c 39                	cmp    $0x39,%al
 336:	7e c7                	jle    2ff <atoi+0xf>
  return n;
 338:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 33b:	c9                   	leave
 33c:	c3                   	ret

0000033d <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 33d:	55                   	push   %ebp
 33e:	89 e5                	mov    %esp,%ebp
 340:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 349:	8b 45 0c             	mov    0xc(%ebp),%eax
 34c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 34f:	eb 17                	jmp    368 <memmove+0x2b>
    *dst++ = *src++;
 351:	8b 55 f8             	mov    -0x8(%ebp),%edx
 354:	8d 42 01             	lea    0x1(%edx),%eax
 357:	89 45 f8             	mov    %eax,-0x8(%ebp)
 35a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 35d:	8d 48 01             	lea    0x1(%eax),%ecx
 360:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 363:	0f b6 12             	movzbl (%edx),%edx
 366:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 368:	8b 45 10             	mov    0x10(%ebp),%eax
 36b:	8d 50 ff             	lea    -0x1(%eax),%edx
 36e:	89 55 10             	mov    %edx,0x10(%ebp)
 371:	85 c0                	test   %eax,%eax
 373:	7f dc                	jg     351 <memmove+0x14>
  return vdst;
 375:	8b 45 08             	mov    0x8(%ebp),%eax
}
 378:	c9                   	leave
 379:	c3                   	ret

0000037a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 37a:	b8 01 00 00 00       	mov    $0x1,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret

00000382 <exit>:
SYSCALL(exit)
 382:	b8 02 00 00 00       	mov    $0x2,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret

0000038a <wait>:
SYSCALL(wait)
 38a:	b8 03 00 00 00       	mov    $0x3,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret

00000392 <pipe>:
SYSCALL(pipe)
 392:	b8 04 00 00 00       	mov    $0x4,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret

0000039a <read>:
SYSCALL(read)
 39a:	b8 05 00 00 00       	mov    $0x5,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret

000003a2 <write>:
SYSCALL(write)
 3a2:	b8 10 00 00 00       	mov    $0x10,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret

000003aa <close>:
SYSCALL(close)
 3aa:	b8 15 00 00 00       	mov    $0x15,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret

000003b2 <kill>:
SYSCALL(kill)
 3b2:	b8 06 00 00 00       	mov    $0x6,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret

000003ba <exec>:
SYSCALL(exec)
 3ba:	b8 07 00 00 00       	mov    $0x7,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret

000003c2 <open>:
SYSCALL(open)
 3c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret

000003ca <mknod>:
SYSCALL(mknod)
 3ca:	b8 11 00 00 00       	mov    $0x11,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret

000003d2 <unlink>:
SYSCALL(unlink)
 3d2:	b8 12 00 00 00       	mov    $0x12,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret

000003da <fstat>:
SYSCALL(fstat)
 3da:	b8 08 00 00 00       	mov    $0x8,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret

000003e2 <link>:
SYSCALL(link)
 3e2:	b8 13 00 00 00       	mov    $0x13,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret

000003ea <mkdir>:
SYSCALL(mkdir)
 3ea:	b8 14 00 00 00       	mov    $0x14,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret

000003f2 <chdir>:
SYSCALL(chdir)
 3f2:	b8 09 00 00 00       	mov    $0x9,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret

000003fa <dup>:
SYSCALL(dup)
 3fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret

00000402 <getpid>:
SYSCALL(getpid)
 402:	b8 0b 00 00 00       	mov    $0xb,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret

0000040a <sbrk>:
SYSCALL(sbrk)
 40a:	b8 0c 00 00 00       	mov    $0xc,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret

00000412 <sleep>:
SYSCALL(sleep)
 412:	b8 0d 00 00 00       	mov    $0xd,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret

0000041a <uptime>:
SYSCALL(uptime)
 41a:	b8 0e 00 00 00       	mov    $0xe,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret

00000422 <getNumFreePages>:
SYSCALL(getNumFreePages)
 422:	b8 16 00 00 00       	mov    $0x16,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret

0000042a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 42a:	55                   	push   %ebp
 42b:	89 e5                	mov    %esp,%ebp
 42d:	83 ec 18             	sub    $0x18,%esp
 430:	8b 45 0c             	mov    0xc(%ebp),%eax
 433:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 436:	83 ec 04             	sub    $0x4,%esp
 439:	6a 01                	push   $0x1
 43b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 43e:	50                   	push   %eax
 43f:	ff 75 08             	push   0x8(%ebp)
 442:	e8 5b ff ff ff       	call   3a2 <write>
 447:	83 c4 10             	add    $0x10,%esp
}
 44a:	90                   	nop
 44b:	c9                   	leave
 44c:	c3                   	ret

0000044d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44d:	55                   	push   %ebp
 44e:	89 e5                	mov    %esp,%ebp
 450:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 453:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 45a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 45e:	74 17                	je     477 <printint+0x2a>
 460:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 464:	79 11                	jns    477 <printint+0x2a>
    neg = 1;
 466:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 46d:	8b 45 0c             	mov    0xc(%ebp),%eax
 470:	f7 d8                	neg    %eax
 472:	89 45 ec             	mov    %eax,-0x14(%ebp)
 475:	eb 06                	jmp    47d <printint+0x30>
  } else {
    x = xx;
 477:	8b 45 0c             	mov    0xc(%ebp),%eax
 47a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 47d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 484:	8b 4d 10             	mov    0x10(%ebp),%ecx
 487:	8b 45 ec             	mov    -0x14(%ebp),%eax
 48a:	ba 00 00 00 00       	mov    $0x0,%edx
 48f:	f7 f1                	div    %ecx
 491:	89 d1                	mov    %edx,%ecx
 493:	8b 45 f4             	mov    -0xc(%ebp),%eax
 496:	8d 50 01             	lea    0x1(%eax),%edx
 499:	89 55 f4             	mov    %edx,-0xc(%ebp)
 49c:	0f b6 91 5c 0b 00 00 	movzbl 0xb5c(%ecx),%edx
 4a3:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 4a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ad:	ba 00 00 00 00       	mov    $0x0,%edx
 4b2:	f7 f1                	div    %ecx
 4b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4bb:	75 c7                	jne    484 <printint+0x37>
  if(neg)
 4bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4c1:	74 2d                	je     4f0 <printint+0xa3>
    buf[i++] = '-';
 4c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c6:	8d 50 01             	lea    0x1(%eax),%edx
 4c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4cc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4d1:	eb 1d                	jmp    4f0 <printint+0xa3>
    putc(fd, buf[i]);
 4d3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d9:	01 d0                	add    %edx,%eax
 4db:	0f b6 00             	movzbl (%eax),%eax
 4de:	0f be c0             	movsbl %al,%eax
 4e1:	83 ec 08             	sub    $0x8,%esp
 4e4:	50                   	push   %eax
 4e5:	ff 75 08             	push   0x8(%ebp)
 4e8:	e8 3d ff ff ff       	call   42a <putc>
 4ed:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4f0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f8:	79 d9                	jns    4d3 <printint+0x86>
}
 4fa:	90                   	nop
 4fb:	90                   	nop
 4fc:	c9                   	leave
 4fd:	c3                   	ret

000004fe <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4fe:	55                   	push   %ebp
 4ff:	89 e5                	mov    %esp,%ebp
 501:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 504:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 50b:	8d 45 0c             	lea    0xc(%ebp),%eax
 50e:	83 c0 04             	add    $0x4,%eax
 511:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 514:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 51b:	e9 59 01 00 00       	jmp    679 <printf+0x17b>
    c = fmt[i] & 0xff;
 520:	8b 55 0c             	mov    0xc(%ebp),%edx
 523:	8b 45 f0             	mov    -0x10(%ebp),%eax
 526:	01 d0                	add    %edx,%eax
 528:	0f b6 00             	movzbl (%eax),%eax
 52b:	0f be c0             	movsbl %al,%eax
 52e:	25 ff 00 00 00       	and    $0xff,%eax
 533:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 536:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 53a:	75 2c                	jne    568 <printf+0x6a>
      if(c == '%'){
 53c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 540:	75 0c                	jne    54e <printf+0x50>
        state = '%';
 542:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 549:	e9 27 01 00 00       	jmp    675 <printf+0x177>
      } else {
        putc(fd, c);
 54e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 551:	0f be c0             	movsbl %al,%eax
 554:	83 ec 08             	sub    $0x8,%esp
 557:	50                   	push   %eax
 558:	ff 75 08             	push   0x8(%ebp)
 55b:	e8 ca fe ff ff       	call   42a <putc>
 560:	83 c4 10             	add    $0x10,%esp
 563:	e9 0d 01 00 00       	jmp    675 <printf+0x177>
      }
    } else if(state == '%'){
 568:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 56c:	0f 85 03 01 00 00    	jne    675 <printf+0x177>
      if(c == 'd'){
 572:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 576:	75 1e                	jne    596 <printf+0x98>
        printint(fd, *ap, 10, 1);
 578:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57b:	8b 00                	mov    (%eax),%eax
 57d:	6a 01                	push   $0x1
 57f:	6a 0a                	push   $0xa
 581:	50                   	push   %eax
 582:	ff 75 08             	push   0x8(%ebp)
 585:	e8 c3 fe ff ff       	call   44d <printint>
 58a:	83 c4 10             	add    $0x10,%esp
        ap++;
 58d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 591:	e9 d8 00 00 00       	jmp    66e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 596:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 59a:	74 06                	je     5a2 <printf+0xa4>
 59c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5a0:	75 1e                	jne    5c0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a5:	8b 00                	mov    (%eax),%eax
 5a7:	6a 00                	push   $0x0
 5a9:	6a 10                	push   $0x10
 5ab:	50                   	push   %eax
 5ac:	ff 75 08             	push   0x8(%ebp)
 5af:	e8 99 fe ff ff       	call   44d <printint>
 5b4:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5bb:	e9 ae 00 00 00       	jmp    66e <printf+0x170>
      } else if(c == 's'){
 5c0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5c4:	75 43                	jne    609 <printf+0x10b>
        s = (char*)*ap;
 5c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c9:	8b 00                	mov    (%eax),%eax
 5cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d6:	75 25                	jne    5fd <printf+0xff>
          s = "(null)";
 5d8:	c7 45 f4 ed 08 00 00 	movl   $0x8ed,-0xc(%ebp)
        while(*s != 0){
 5df:	eb 1c                	jmp    5fd <printf+0xff>
          putc(fd, *s);
 5e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e4:	0f b6 00             	movzbl (%eax),%eax
 5e7:	0f be c0             	movsbl %al,%eax
 5ea:	83 ec 08             	sub    $0x8,%esp
 5ed:	50                   	push   %eax
 5ee:	ff 75 08             	push   0x8(%ebp)
 5f1:	e8 34 fe ff ff       	call   42a <putc>
 5f6:	83 c4 10             	add    $0x10,%esp
          s++;
 5f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 600:	0f b6 00             	movzbl (%eax),%eax
 603:	84 c0                	test   %al,%al
 605:	75 da                	jne    5e1 <printf+0xe3>
 607:	eb 65                	jmp    66e <printf+0x170>
        }
      } else if(c == 'c'){
 609:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 60d:	75 1d                	jne    62c <printf+0x12e>
        putc(fd, *ap);
 60f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 612:	8b 00                	mov    (%eax),%eax
 614:	0f be c0             	movsbl %al,%eax
 617:	83 ec 08             	sub    $0x8,%esp
 61a:	50                   	push   %eax
 61b:	ff 75 08             	push   0x8(%ebp)
 61e:	e8 07 fe ff ff       	call   42a <putc>
 623:	83 c4 10             	add    $0x10,%esp
        ap++;
 626:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 62a:	eb 42                	jmp    66e <printf+0x170>
      } else if(c == '%'){
 62c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 630:	75 17                	jne    649 <printf+0x14b>
        putc(fd, c);
 632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 635:	0f be c0             	movsbl %al,%eax
 638:	83 ec 08             	sub    $0x8,%esp
 63b:	50                   	push   %eax
 63c:	ff 75 08             	push   0x8(%ebp)
 63f:	e8 e6 fd ff ff       	call   42a <putc>
 644:	83 c4 10             	add    $0x10,%esp
 647:	eb 25                	jmp    66e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 649:	83 ec 08             	sub    $0x8,%esp
 64c:	6a 25                	push   $0x25
 64e:	ff 75 08             	push   0x8(%ebp)
 651:	e8 d4 fd ff ff       	call   42a <putc>
 656:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65c:	0f be c0             	movsbl %al,%eax
 65f:	83 ec 08             	sub    $0x8,%esp
 662:	50                   	push   %eax
 663:	ff 75 08             	push   0x8(%ebp)
 666:	e8 bf fd ff ff       	call   42a <putc>
 66b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 66e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 675:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 679:	8b 55 0c             	mov    0xc(%ebp),%edx
 67c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 67f:	01 d0                	add    %edx,%eax
 681:	0f b6 00             	movzbl (%eax),%eax
 684:	84 c0                	test   %al,%al
 686:	0f 85 94 fe ff ff    	jne    520 <printf+0x22>
    }
  }
}
 68c:	90                   	nop
 68d:	90                   	nop
 68e:	c9                   	leave
 68f:	c3                   	ret

00000690 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 696:	8b 45 08             	mov    0x8(%ebp),%eax
 699:	83 e8 08             	sub    $0x8,%eax
 69c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69f:	a1 88 0d 00 00       	mov    0xd88,%eax
 6a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a7:	eb 24                	jmp    6cd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 00                	mov    (%eax),%eax
 6ae:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6b1:	72 12                	jb     6c5 <free+0x35>
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6b9:	72 24                	jb     6df <free+0x4f>
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	8b 00                	mov    (%eax),%eax
 6c0:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6c3:	72 1a                	jb     6df <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 00                	mov    (%eax),%eax
 6ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d0:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6d3:	73 d4                	jae    6a9 <free+0x19>
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6dd:	73 ca                	jae    6a9 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e2:	8b 40 04             	mov    0x4(%eax),%eax
 6e5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ef:	01 c2                	add    %eax,%edx
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	39 c2                	cmp    %eax,%edx
 6f8:	75 24                	jne    71e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	8b 50 04             	mov    0x4(%eax),%edx
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	8b 00                	mov    (%eax),%eax
 705:	8b 40 04             	mov    0x4(%eax),%eax
 708:	01 c2                	add    %eax,%edx
 70a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	8b 00                	mov    (%eax),%eax
 715:	8b 10                	mov    (%eax),%edx
 717:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71a:	89 10                	mov    %edx,(%eax)
 71c:	eb 0a                	jmp    728 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 10                	mov    (%eax),%edx
 723:	8b 45 f8             	mov    -0x8(%ebp),%eax
 726:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 40 04             	mov    0x4(%eax),%eax
 72e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 735:	8b 45 fc             	mov    -0x4(%ebp),%eax
 738:	01 d0                	add    %edx,%eax
 73a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 73d:	75 20                	jne    75f <free+0xcf>
    p->s.size += bp->s.size;
 73f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 742:	8b 50 04             	mov    0x4(%eax),%edx
 745:	8b 45 f8             	mov    -0x8(%ebp),%eax
 748:	8b 40 04             	mov    0x4(%eax),%eax
 74b:	01 c2                	add    %eax,%edx
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	8b 10                	mov    (%eax),%edx
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	89 10                	mov    %edx,(%eax)
 75d:	eb 08                	jmp    767 <free+0xd7>
  } else
    p->s.ptr = bp;
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	8b 55 f8             	mov    -0x8(%ebp),%edx
 765:	89 10                	mov    %edx,(%eax)
  freep = p;
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	a3 88 0d 00 00       	mov    %eax,0xd88
}
 76f:	90                   	nop
 770:	c9                   	leave
 771:	c3                   	ret

00000772 <morecore>:

static Header*
morecore(uint nu)
{
 772:	55                   	push   %ebp
 773:	89 e5                	mov    %esp,%ebp
 775:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 778:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 77f:	77 07                	ja     788 <morecore+0x16>
    nu = 4096;
 781:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 788:	8b 45 08             	mov    0x8(%ebp),%eax
 78b:	c1 e0 03             	shl    $0x3,%eax
 78e:	83 ec 0c             	sub    $0xc,%esp
 791:	50                   	push   %eax
 792:	e8 73 fc ff ff       	call   40a <sbrk>
 797:	83 c4 10             	add    $0x10,%esp
 79a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 79d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7a1:	75 07                	jne    7aa <morecore+0x38>
    return 0;
 7a3:	b8 00 00 00 00       	mov    $0x0,%eax
 7a8:	eb 26                	jmp    7d0 <morecore+0x5e>
  hp = (Header*)p;
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b3:	8b 55 08             	mov    0x8(%ebp),%edx
 7b6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bc:	83 c0 08             	add    $0x8,%eax
 7bf:	83 ec 0c             	sub    $0xc,%esp
 7c2:	50                   	push   %eax
 7c3:	e8 c8 fe ff ff       	call   690 <free>
 7c8:	83 c4 10             	add    $0x10,%esp
  return freep;
 7cb:	a1 88 0d 00 00       	mov    0xd88,%eax
}
 7d0:	c9                   	leave
 7d1:	c3                   	ret

000007d2 <malloc>:

void*
malloc(uint nbytes)
{
 7d2:	55                   	push   %ebp
 7d3:	89 e5                	mov    %esp,%ebp
 7d5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d8:	8b 45 08             	mov    0x8(%ebp),%eax
 7db:	83 c0 07             	add    $0x7,%eax
 7de:	c1 e8 03             	shr    $0x3,%eax
 7e1:	83 c0 01             	add    $0x1,%eax
 7e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7e7:	a1 88 0d 00 00       	mov    0xd88,%eax
 7ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f3:	75 23                	jne    818 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7f5:	c7 45 f0 80 0d 00 00 	movl   $0xd80,-0x10(%ebp)
 7fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ff:	a3 88 0d 00 00       	mov    %eax,0xd88
 804:	a1 88 0d 00 00       	mov    0xd88,%eax
 809:	a3 80 0d 00 00       	mov    %eax,0xd80
    base.s.size = 0;
 80e:	c7 05 84 0d 00 00 00 	movl   $0x0,0xd84
 815:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 818:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81b:	8b 00                	mov    (%eax),%eax
 81d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 820:	8b 45 f4             	mov    -0xc(%ebp),%eax
 823:	8b 40 04             	mov    0x4(%eax),%eax
 826:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 829:	72 4d                	jb     878 <malloc+0xa6>
      if(p->s.size == nunits)
 82b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82e:	8b 40 04             	mov    0x4(%eax),%eax
 831:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 834:	75 0c                	jne    842 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 836:	8b 45 f4             	mov    -0xc(%ebp),%eax
 839:	8b 10                	mov    (%eax),%edx
 83b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83e:	89 10                	mov    %edx,(%eax)
 840:	eb 26                	jmp    868 <malloc+0x96>
      else {
        p->s.size -= nunits;
 842:	8b 45 f4             	mov    -0xc(%ebp),%eax
 845:	8b 40 04             	mov    0x4(%eax),%eax
 848:	2b 45 ec             	sub    -0x14(%ebp),%eax
 84b:	89 c2                	mov    %eax,%edx
 84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 850:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	8b 40 04             	mov    0x4(%eax),%eax
 859:	c1 e0 03             	shl    $0x3,%eax
 85c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 85f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 862:	8b 55 ec             	mov    -0x14(%ebp),%edx
 865:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 868:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86b:	a3 88 0d 00 00       	mov    %eax,0xd88
      return (void*)(p + 1);
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	83 c0 08             	add    $0x8,%eax
 876:	eb 3b                	jmp    8b3 <malloc+0xe1>
    }
    if(p == freep)
 878:	a1 88 0d 00 00       	mov    0xd88,%eax
 87d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 880:	75 1e                	jne    8a0 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 882:	83 ec 0c             	sub    $0xc,%esp
 885:	ff 75 ec             	push   -0x14(%ebp)
 888:	e8 e5 fe ff ff       	call   772 <morecore>
 88d:	83 c4 10             	add    $0x10,%esp
 890:	89 45 f4             	mov    %eax,-0xc(%ebp)
 893:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 897:	75 07                	jne    8a0 <malloc+0xce>
        return 0;
 899:	b8 00 00 00 00       	mov    $0x0,%eax
 89e:	eb 13                	jmp    8b3 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a9:	8b 00                	mov    (%eax),%eax
 8ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8ae:	e9 6d ff ff ff       	jmp    820 <malloc+0x4e>
  }
}
 8b3:	c9                   	leave
 8b4:	c3                   	ret
