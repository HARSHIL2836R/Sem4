
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;

  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 ae 00 00 00       	jmp    c0 <grep+0xc0>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 e0 0d 00 00       	add    $0xde0,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 e0 0d 00 00 	movl   $0xde0,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 44                	jmp    70 <grep+0x70>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	83 ec 08             	sub    $0x8,%esp
  35:	ff 75 f0             	push   -0x10(%ebp)
  38:	ff 75 08             	push   0x8(%ebp)
  3b:	e8 8f 01 00 00       	call   1cf <match>
  40:	83 c4 10             	add    $0x10,%esp
  43:	85 c0                	test   %eax,%eax
  45:	74 20                	je     67 <grep+0x67>
        *q = '\n';
  47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4a:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  50:	83 c0 01             	add    $0x1,%eax
  53:	2b 45 f0             	sub    -0x10(%ebp),%eax
  56:	83 ec 04             	sub    $0x4,%esp
  59:	50                   	push   %eax
  5a:	ff 75 f0             	push   -0x10(%ebp)
  5d:	6a 01                	push   $0x1
  5f:	e8 3e 05 00 00       	call   5a2 <write>
  64:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  6a:	83 c0 01             	add    $0x1,%eax
  6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  70:	83 ec 08             	sub    $0x8,%esp
  73:	6a 0a                	push   $0xa
  75:	ff 75 f0             	push   -0x10(%ebp)
  78:	e8 84 03 00 00       	call   401 <strchr>
  7d:	83 c4 10             	add    $0x10,%esp
  80:	89 45 e8             	mov    %eax,-0x18(%ebp)
  83:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  87:	75 a3                	jne    2c <grep+0x2c>
    }
    if(p == buf)
  89:	81 7d f0 e0 0d 00 00 	cmpl   $0xde0,-0x10(%ebp)
  90:	75 07                	jne    99 <grep+0x99>
      m = 0;
  92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  9d:	7e 21                	jle    c0 <grep+0xc0>
      m -= p - buf;
  9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a2:	2d e0 0d 00 00       	sub    $0xde0,%eax
  a7:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  aa:	83 ec 04             	sub    $0x4,%esp
  ad:	ff 75 f4             	push   -0xc(%ebp)
  b0:	ff 75 f0             	push   -0x10(%ebp)
  b3:	68 e0 0d 00 00       	push   $0xde0
  b8:	e8 80 04 00 00       	call   53d <memmove>
  bd:	83 c4 10             	add    $0x10,%esp
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c3:	ba ff 03 00 00       	mov    $0x3ff,%edx
  c8:	29 c2                	sub    %eax,%edx
  ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  cd:	05 e0 0d 00 00       	add    $0xde0,%eax
  d2:	83 ec 04             	sub    $0x4,%esp
  d5:	52                   	push   %edx
  d6:	50                   	push   %eax
  d7:	ff 75 0c             	push   0xc(%ebp)
  da:	e8 bb 04 00 00       	call   59a <read>
  df:	83 c4 10             	add    $0x10,%esp
  e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  e9:	0f 8f 23 ff ff ff    	jg     12 <grep+0x12>
    }
  }
}
  ef:	90                   	nop
  f0:	90                   	nop
  f1:	c9                   	leave
  f2:	c3                   	ret

000000f3 <main>:

int
main(int argc, char *argv[])
{
  f3:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f7:	83 e4 f0             	and    $0xfffffff0,%esp
  fa:	ff 71 fc             	push   -0x4(%ecx)
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	53                   	push   %ebx
 101:	51                   	push   %ecx
 102:	83 ec 10             	sub    $0x10,%esp
 105:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;

  if(argc <= 1){
 107:	83 3b 01             	cmpl   $0x1,(%ebx)
 10a:	7f 17                	jg     123 <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 10c:	83 ec 08             	sub    $0x8,%esp
 10f:	68 b8 0a 00 00       	push   $0xab8
 114:	6a 02                	push   $0x2
 116:	e8 e3 05 00 00       	call   6fe <printf>
 11b:	83 c4 10             	add    $0x10,%esp
    exit();
 11e:	e8 5f 04 00 00       	call   582 <exit>
  }
  pattern = argv[1];
 123:	8b 43 04             	mov    0x4(%ebx),%eax
 126:	8b 40 04             	mov    0x4(%eax),%eax
 129:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(argc <= 2){
 12c:	83 3b 02             	cmpl   $0x2,(%ebx)
 12f:	7f 15                	jg     146 <main+0x53>
    grep(pattern, 0);
 131:	83 ec 08             	sub    $0x8,%esp
 134:	6a 00                	push   $0x0
 136:	ff 75 f0             	push   -0x10(%ebp)
 139:	e8 c2 fe ff ff       	call   0 <grep>
 13e:	83 c4 10             	add    $0x10,%esp
    exit();
 141:	e8 3c 04 00 00       	call   582 <exit>
  }

  for(i = 2; i < argc; i++){
 146:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 14d:	eb 74                	jmp    1c3 <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 14f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 152:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 159:	8b 43 04             	mov    0x4(%ebx),%eax
 15c:	01 d0                	add    %edx,%eax
 15e:	8b 00                	mov    (%eax),%eax
 160:	83 ec 08             	sub    $0x8,%esp
 163:	6a 00                	push   $0x0
 165:	50                   	push   %eax
 166:	e8 57 04 00 00       	call   5c2 <open>
 16b:	83 c4 10             	add    $0x10,%esp
 16e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 171:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 175:	79 29                	jns    1a0 <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 177:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 181:	8b 43 04             	mov    0x4(%ebx),%eax
 184:	01 d0                	add    %edx,%eax
 186:	8b 00                	mov    (%eax),%eax
 188:	83 ec 04             	sub    $0x4,%esp
 18b:	50                   	push   %eax
 18c:	68 d8 0a 00 00       	push   $0xad8
 191:	6a 01                	push   $0x1
 193:	e8 66 05 00 00       	call   6fe <printf>
 198:	83 c4 10             	add    $0x10,%esp
      exit();
 19b:	e8 e2 03 00 00       	call   582 <exit>
    }
    grep(pattern, fd);
 1a0:	83 ec 08             	sub    $0x8,%esp
 1a3:	ff 75 ec             	push   -0x14(%ebp)
 1a6:	ff 75 f0             	push   -0x10(%ebp)
 1a9:	e8 52 fe ff ff       	call   0 <grep>
 1ae:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1b1:	83 ec 0c             	sub    $0xc,%esp
 1b4:	ff 75 ec             	push   -0x14(%ebp)
 1b7:	e8 ee 03 00 00       	call   5aa <close>
 1bc:	83 c4 10             	add    $0x10,%esp
  for(i = 2; i < argc; i++){
 1bf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c6:	3b 03                	cmp    (%ebx),%eax
 1c8:	7c 85                	jl     14f <main+0x5c>
  }
  exit();
 1ca:	e8 b3 03 00 00       	call   582 <exit>

000001cf <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1cf:	55                   	push   %ebp
 1d0:	89 e5                	mov    %esp,%ebp
 1d2:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1d5:	8b 45 08             	mov    0x8(%ebp),%eax
 1d8:	0f b6 00             	movzbl (%eax),%eax
 1db:	3c 5e                	cmp    $0x5e,%al
 1dd:	75 17                	jne    1f6 <match+0x27>
    return matchhere(re+1, text);
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	83 c0 01             	add    $0x1,%eax
 1e5:	83 ec 08             	sub    $0x8,%esp
 1e8:	ff 75 0c             	push   0xc(%ebp)
 1eb:	50                   	push   %eax
 1ec:	e8 38 00 00 00       	call   229 <matchhere>
 1f1:	83 c4 10             	add    $0x10,%esp
 1f4:	eb 31                	jmp    227 <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
 1f6:	83 ec 08             	sub    $0x8,%esp
 1f9:	ff 75 0c             	push   0xc(%ebp)
 1fc:	ff 75 08             	push   0x8(%ebp)
 1ff:	e8 25 00 00 00       	call   229 <matchhere>
 204:	83 c4 10             	add    $0x10,%esp
 207:	85 c0                	test   %eax,%eax
 209:	74 07                	je     212 <match+0x43>
      return 1;
 20b:	b8 01 00 00 00       	mov    $0x1,%eax
 210:	eb 15                	jmp    227 <match+0x58>
  }while(*text++ != '\0');
 212:	8b 45 0c             	mov    0xc(%ebp),%eax
 215:	8d 50 01             	lea    0x1(%eax),%edx
 218:	89 55 0c             	mov    %edx,0xc(%ebp)
 21b:	0f b6 00             	movzbl (%eax),%eax
 21e:	84 c0                	test   %al,%al
 220:	75 d4                	jne    1f6 <match+0x27>
  return 0;
 222:	b8 00 00 00 00       	mov    $0x0,%eax
}
 227:	c9                   	leave
 228:	c3                   	ret

00000229 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 229:	55                   	push   %ebp
 22a:	89 e5                	mov    %esp,%ebp
 22c:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	84 c0                	test   %al,%al
 237:	75 0a                	jne    243 <matchhere+0x1a>
    return 1;
 239:	b8 01 00 00 00       	mov    $0x1,%eax
 23e:	e9 99 00 00 00       	jmp    2dc <matchhere+0xb3>
  if(re[1] == '*')
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	83 c0 01             	add    $0x1,%eax
 249:	0f b6 00             	movzbl (%eax),%eax
 24c:	3c 2a                	cmp    $0x2a,%al
 24e:	75 21                	jne    271 <matchhere+0x48>
    return matchstar(re[0], re+2, text);
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	8d 50 02             	lea    0x2(%eax),%edx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	0f be c0             	movsbl %al,%eax
 25f:	83 ec 04             	sub    $0x4,%esp
 262:	ff 75 0c             	push   0xc(%ebp)
 265:	52                   	push   %edx
 266:	50                   	push   %eax
 267:	e8 72 00 00 00       	call   2de <matchstar>
 26c:	83 c4 10             	add    $0x10,%esp
 26f:	eb 6b                	jmp    2dc <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	0f b6 00             	movzbl (%eax),%eax
 277:	3c 24                	cmp    $0x24,%al
 279:	75 1d                	jne    298 <matchhere+0x6f>
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	83 c0 01             	add    $0x1,%eax
 281:	0f b6 00             	movzbl (%eax),%eax
 284:	84 c0                	test   %al,%al
 286:	75 10                	jne    298 <matchhere+0x6f>
    return *text == '\0';
 288:	8b 45 0c             	mov    0xc(%ebp),%eax
 28b:	0f b6 00             	movzbl (%eax),%eax
 28e:	84 c0                	test   %al,%al
 290:	0f 94 c0             	sete   %al
 293:	0f b6 c0             	movzbl %al,%eax
 296:	eb 44                	jmp    2dc <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 298:	8b 45 0c             	mov    0xc(%ebp),%eax
 29b:	0f b6 00             	movzbl (%eax),%eax
 29e:	84 c0                	test   %al,%al
 2a0:	74 35                	je     2d7 <matchhere+0xae>
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	0f b6 00             	movzbl (%eax),%eax
 2a8:	3c 2e                	cmp    $0x2e,%al
 2aa:	74 10                	je     2bc <matchhere+0x93>
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	0f b6 10             	movzbl (%eax),%edx
 2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b5:	0f b6 00             	movzbl (%eax),%eax
 2b8:	38 c2                	cmp    %al,%dl
 2ba:	75 1b                	jne    2d7 <matchhere+0xae>
    return matchhere(re+1, text+1);
 2bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bf:	8d 50 01             	lea    0x1(%eax),%edx
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	83 c0 01             	add    $0x1,%eax
 2c8:	83 ec 08             	sub    $0x8,%esp
 2cb:	52                   	push   %edx
 2cc:	50                   	push   %eax
 2cd:	e8 57 ff ff ff       	call   229 <matchhere>
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	eb 05                	jmp    2dc <matchhere+0xb3>
  return 0;
 2d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2dc:	c9                   	leave
 2dd:	c3                   	ret

000002de <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
 2e1:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2e4:	83 ec 08             	sub    $0x8,%esp
 2e7:	ff 75 10             	push   0x10(%ebp)
 2ea:	ff 75 0c             	push   0xc(%ebp)
 2ed:	e8 37 ff ff ff       	call   229 <matchhere>
 2f2:	83 c4 10             	add    $0x10,%esp
 2f5:	85 c0                	test   %eax,%eax
 2f7:	74 07                	je     300 <matchstar+0x22>
      return 1;
 2f9:	b8 01 00 00 00       	mov    $0x1,%eax
 2fe:	eb 29                	jmp    329 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 300:	8b 45 10             	mov    0x10(%ebp),%eax
 303:	0f b6 00             	movzbl (%eax),%eax
 306:	84 c0                	test   %al,%al
 308:	74 1a                	je     324 <matchstar+0x46>
 30a:	8b 45 10             	mov    0x10(%ebp),%eax
 30d:	8d 50 01             	lea    0x1(%eax),%edx
 310:	89 55 10             	mov    %edx,0x10(%ebp)
 313:	0f b6 00             	movzbl (%eax),%eax
 316:	0f be c0             	movsbl %al,%eax
 319:	39 45 08             	cmp    %eax,0x8(%ebp)
 31c:	74 c6                	je     2e4 <matchstar+0x6>
 31e:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 322:	74 c0                	je     2e4 <matchstar+0x6>
  return 0;
 324:	b8 00 00 00 00       	mov    $0x0,%eax
}
 329:	c9                   	leave
 32a:	c3                   	ret

0000032b <stosb>:
  stosb(dst, c, n);
  return dst;
}

char*
strchr(const char *s, char c)
 32b:	55                   	push   %ebp
 32c:	89 e5                	mov    %esp,%ebp
 32e:	57                   	push   %edi
 32f:	53                   	push   %ebx
{
 330:	8b 4d 08             	mov    0x8(%ebp),%ecx
 333:	8b 55 10             	mov    0x10(%ebp),%edx
 336:	8b 45 0c             	mov    0xc(%ebp),%eax
 339:	89 cb                	mov    %ecx,%ebx
 33b:	89 df                	mov    %ebx,%edi
 33d:	89 d1                	mov    %edx,%ecx
 33f:	fc                   	cld
 340:	f3 aa                	rep stos %al,%es:(%edi)
 342:	89 ca                	mov    %ecx,%edx
 344:	89 fb                	mov    %edi,%ebx
 346:	89 5d 08             	mov    %ebx,0x8(%ebp)
 349:	89 55 10             	mov    %edx,0x10(%ebp)
  for(; *s; s++)
    if(*s == c)
      return (char*)s;
  return 0;
 34c:	90                   	nop
 34d:	5b                   	pop    %ebx
 34e:	5f                   	pop    %edi
 34f:	5d                   	pop    %ebp
 350:	c3                   	ret

00000351 <strcpy>:
{
 351:	55                   	push   %ebp
 352:	89 e5                	mov    %esp,%ebp
 354:	83 ec 10             	sub    $0x10,%esp
  os = s;
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 35d:	90                   	nop
 35e:	8b 55 0c             	mov    0xc(%ebp),%edx
 361:	8d 42 01             	lea    0x1(%edx),%eax
 364:	89 45 0c             	mov    %eax,0xc(%ebp)
 367:	8b 45 08             	mov    0x8(%ebp),%eax
 36a:	8d 48 01             	lea    0x1(%eax),%ecx
 36d:	89 4d 08             	mov    %ecx,0x8(%ebp)
 370:	0f b6 12             	movzbl (%edx),%edx
 373:	88 10                	mov    %dl,(%eax)
 375:	0f b6 00             	movzbl (%eax),%eax
 378:	84 c0                	test   %al,%al
 37a:	75 e2                	jne    35e <strcpy+0xd>
  return os;
 37c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 37f:	c9                   	leave
 380:	c3                   	ret

00000381 <strcmp>:
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 384:	eb 08                	jmp    38e <strcmp+0xd>
    p++, q++;
 386:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 38a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	0f b6 00             	movzbl (%eax),%eax
 394:	84 c0                	test   %al,%al
 396:	74 10                	je     3a8 <strcmp+0x27>
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	0f b6 10             	movzbl (%eax),%edx
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	0f b6 00             	movzbl (%eax),%eax
 3a4:	38 c2                	cmp    %al,%dl
 3a6:	74 de                	je     386 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	0f b6 00             	movzbl (%eax),%eax
 3ae:	0f b6 d0             	movzbl %al,%edx
 3b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b4:	0f b6 00             	movzbl (%eax),%eax
 3b7:	0f b6 c0             	movzbl %al,%eax
 3ba:	29 c2                	sub    %eax,%edx
 3bc:	89 d0                	mov    %edx,%eax
}
 3be:	5d                   	pop    %ebp
 3bf:	c3                   	ret

000003c0 <strlen>:
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	83 ec 10             	sub    $0x10,%esp
  for(n = 0; s[n]; n++)
 3c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3cd:	eb 04                	jmp    3d3 <strlen+0x13>
 3cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d6:	8b 45 08             	mov    0x8(%ebp),%eax
 3d9:	01 d0                	add    %edx,%eax
 3db:	0f b6 00             	movzbl (%eax),%eax
 3de:	84 c0                	test   %al,%al
 3e0:	75 ed                	jne    3cf <strlen+0xf>
  return n;
 3e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e5:	c9                   	leave
 3e6:	c3                   	ret

000003e7 <memset>:
{
 3e7:	55                   	push   %ebp
 3e8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3ea:	8b 45 10             	mov    0x10(%ebp),%eax
 3ed:	50                   	push   %eax
 3ee:	ff 75 0c             	push   0xc(%ebp)
 3f1:	ff 75 08             	push   0x8(%ebp)
 3f4:	e8 32 ff ff ff       	call   32b <stosb>
 3f9:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ff:	c9                   	leave
 400:	c3                   	ret

00000401 <strchr>:
{
 401:	55                   	push   %ebp
 402:	89 e5                	mov    %esp,%ebp
 404:	83 ec 04             	sub    $0x4,%esp
 407:	8b 45 0c             	mov    0xc(%ebp),%eax
 40a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 40d:	eb 14                	jmp    423 <strchr+0x22>
    if(*s == c)
 40f:	8b 45 08             	mov    0x8(%ebp),%eax
 412:	0f b6 00             	movzbl (%eax),%eax
 415:	38 45 fc             	cmp    %al,-0x4(%ebp)
 418:	75 05                	jne    41f <strchr+0x1e>
      return (char*)s;
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	eb 13                	jmp    432 <strchr+0x31>
  for(; *s; s++)
 41f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	0f b6 00             	movzbl (%eax),%eax
 429:	84 c0                	test   %al,%al
 42b:	75 e2                	jne    40f <strchr+0xe>
  return 0;
 42d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 432:	c9                   	leave
 433:	c3                   	ret

00000434 <gets>:

char*
gets(char *buf, int max)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 43a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 441:	eb 42                	jmp    485 <gets+0x51>
    cc = read(0, &c, 1);
 443:	83 ec 04             	sub    $0x4,%esp
 446:	6a 01                	push   $0x1
 448:	8d 45 ef             	lea    -0x11(%ebp),%eax
 44b:	50                   	push   %eax
 44c:	6a 00                	push   $0x0
 44e:	e8 47 01 00 00       	call   59a <read>
 453:	83 c4 10             	add    $0x10,%esp
 456:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 459:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 45d:	7e 33                	jle    492 <gets+0x5e>
      break;
    buf[i++] = c;
 45f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 462:	8d 50 01             	lea    0x1(%eax),%edx
 465:	89 55 f4             	mov    %edx,-0xc(%ebp)
 468:	89 c2                	mov    %eax,%edx
 46a:	8b 45 08             	mov    0x8(%ebp),%eax
 46d:	01 c2                	add    %eax,%edx
 46f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 473:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 475:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 479:	3c 0a                	cmp    $0xa,%al
 47b:	74 16                	je     493 <gets+0x5f>
 47d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 481:	3c 0d                	cmp    $0xd,%al
 483:	74 0e                	je     493 <gets+0x5f>
  for(i=0; i+1 < max; ){
 485:	8b 45 f4             	mov    -0xc(%ebp),%eax
 488:	83 c0 01             	add    $0x1,%eax
 48b:	39 45 0c             	cmp    %eax,0xc(%ebp)
 48e:	7f b3                	jg     443 <gets+0xf>
 490:	eb 01                	jmp    493 <gets+0x5f>
      break;
 492:	90                   	nop
      break;
  }
  buf[i] = '\0';
 493:	8b 55 f4             	mov    -0xc(%ebp),%edx
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	01 d0                	add    %edx,%eax
 49b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 49e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4a1:	c9                   	leave
 4a2:	c3                   	ret

000004a3 <stat>:

int
stat(const char *n, struct stat *st)
{
 4a3:	55                   	push   %ebp
 4a4:	89 e5                	mov    %esp,%ebp
 4a6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4a9:	83 ec 08             	sub    $0x8,%esp
 4ac:	6a 00                	push   $0x0
 4ae:	ff 75 08             	push   0x8(%ebp)
 4b1:	e8 0c 01 00 00       	call   5c2 <open>
 4b6:	83 c4 10             	add    $0x10,%esp
 4b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c0:	79 07                	jns    4c9 <stat+0x26>
    return -1;
 4c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4c7:	eb 25                	jmp    4ee <stat+0x4b>
  r = fstat(fd, st);
 4c9:	83 ec 08             	sub    $0x8,%esp
 4cc:	ff 75 0c             	push   0xc(%ebp)
 4cf:	ff 75 f4             	push   -0xc(%ebp)
 4d2:	e8 03 01 00 00       	call   5da <fstat>
 4d7:	83 c4 10             	add    $0x10,%esp
 4da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4dd:	83 ec 0c             	sub    $0xc,%esp
 4e0:	ff 75 f4             	push   -0xc(%ebp)
 4e3:	e8 c2 00 00 00       	call   5aa <close>
 4e8:	83 c4 10             	add    $0x10,%esp
  return r;
 4eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4ee:	c9                   	leave
 4ef:	c3                   	ret

000004f0 <atoi>:

int
atoi(const char *s)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4fd:	eb 25                	jmp    524 <atoi+0x34>
    n = n*10 + *s++ - '0';
 4ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
 502:	89 d0                	mov    %edx,%eax
 504:	c1 e0 02             	shl    $0x2,%eax
 507:	01 d0                	add    %edx,%eax
 509:	01 c0                	add    %eax,%eax
 50b:	89 c1                	mov    %eax,%ecx
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	8d 50 01             	lea    0x1(%eax),%edx
 513:	89 55 08             	mov    %edx,0x8(%ebp)
 516:	0f b6 00             	movzbl (%eax),%eax
 519:	0f be c0             	movsbl %al,%eax
 51c:	01 c8                	add    %ecx,%eax
 51e:	83 e8 30             	sub    $0x30,%eax
 521:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 524:	8b 45 08             	mov    0x8(%ebp),%eax
 527:	0f b6 00             	movzbl (%eax),%eax
 52a:	3c 2f                	cmp    $0x2f,%al
 52c:	7e 0a                	jle    538 <atoi+0x48>
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	0f b6 00             	movzbl (%eax),%eax
 534:	3c 39                	cmp    $0x39,%al
 536:	7e c7                	jle    4ff <atoi+0xf>
  return n;
 538:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 53b:	c9                   	leave
 53c:	c3                   	ret

0000053d <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 53d:	55                   	push   %ebp
 53e:	89 e5                	mov    %esp,%ebp
 540:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 549:	8b 45 0c             	mov    0xc(%ebp),%eax
 54c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 54f:	eb 17                	jmp    568 <memmove+0x2b>
    *dst++ = *src++;
 551:	8b 55 f8             	mov    -0x8(%ebp),%edx
 554:	8d 42 01             	lea    0x1(%edx),%eax
 557:	89 45 f8             	mov    %eax,-0x8(%ebp)
 55a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 55d:	8d 48 01             	lea    0x1(%eax),%ecx
 560:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 563:	0f b6 12             	movzbl (%edx),%edx
 566:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 568:	8b 45 10             	mov    0x10(%ebp),%eax
 56b:	8d 50 ff             	lea    -0x1(%eax),%edx
 56e:	89 55 10             	mov    %edx,0x10(%ebp)
 571:	85 c0                	test   %eax,%eax
 573:	7f dc                	jg     551 <memmove+0x14>
  return vdst;
 575:	8b 45 08             	mov    0x8(%ebp),%eax
}
 578:	c9                   	leave
 579:	c3                   	ret

0000057a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 57a:	b8 01 00 00 00       	mov    $0x1,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret

00000582 <exit>:
SYSCALL(exit)
 582:	b8 02 00 00 00       	mov    $0x2,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret

0000058a <wait>:
SYSCALL(wait)
 58a:	b8 03 00 00 00       	mov    $0x3,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret

00000592 <pipe>:
SYSCALL(pipe)
 592:	b8 04 00 00 00       	mov    $0x4,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret

0000059a <read>:
SYSCALL(read)
 59a:	b8 05 00 00 00       	mov    $0x5,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret

000005a2 <write>:
SYSCALL(write)
 5a2:	b8 10 00 00 00       	mov    $0x10,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret

000005aa <close>:
SYSCALL(close)
 5aa:	b8 15 00 00 00       	mov    $0x15,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret

000005b2 <kill>:
SYSCALL(kill)
 5b2:	b8 06 00 00 00       	mov    $0x6,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret

000005ba <exec>:
SYSCALL(exec)
 5ba:	b8 07 00 00 00       	mov    $0x7,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret

000005c2 <open>:
SYSCALL(open)
 5c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret

000005ca <mknod>:
SYSCALL(mknod)
 5ca:	b8 11 00 00 00       	mov    $0x11,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret

000005d2 <unlink>:
SYSCALL(unlink)
 5d2:	b8 12 00 00 00       	mov    $0x12,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret

000005da <fstat>:
SYSCALL(fstat)
 5da:	b8 08 00 00 00       	mov    $0x8,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret

000005e2 <link>:
SYSCALL(link)
 5e2:	b8 13 00 00 00       	mov    $0x13,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret

000005ea <mkdir>:
SYSCALL(mkdir)
 5ea:	b8 14 00 00 00       	mov    $0x14,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret

000005f2 <chdir>:
SYSCALL(chdir)
 5f2:	b8 09 00 00 00       	mov    $0x9,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret

000005fa <dup>:
SYSCALL(dup)
 5fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret

00000602 <getpid>:
SYSCALL(getpid)
 602:	b8 0b 00 00 00       	mov    $0xb,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret

0000060a <sbrk>:
SYSCALL(sbrk)
 60a:	b8 0c 00 00 00       	mov    $0xc,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret

00000612 <sleep>:
SYSCALL(sleep)
 612:	b8 0d 00 00 00       	mov    $0xd,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret

0000061a <uptime>:
SYSCALL(uptime)
 61a:	b8 0e 00 00 00       	mov    $0xe,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret

00000622 <getNumFreePages>:
SYSCALL(getNumFreePages)
 622:	b8 16 00 00 00       	mov    $0x16,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret

0000062a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 62a:	55                   	push   %ebp
 62b:	89 e5                	mov    %esp,%ebp
 62d:	83 ec 18             	sub    $0x18,%esp
 630:	8b 45 0c             	mov    0xc(%ebp),%eax
 633:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 636:	83 ec 04             	sub    $0x4,%esp
 639:	6a 01                	push   $0x1
 63b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 63e:	50                   	push   %eax
 63f:	ff 75 08             	push   0x8(%ebp)
 642:	e8 5b ff ff ff       	call   5a2 <write>
 647:	83 c4 10             	add    $0x10,%esp
}
 64a:	90                   	nop
 64b:	c9                   	leave
 64c:	c3                   	ret

0000064d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 64d:	55                   	push   %ebp
 64e:	89 e5                	mov    %esp,%ebp
 650:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 653:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 65a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 65e:	74 17                	je     677 <printint+0x2a>
 660:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 664:	79 11                	jns    677 <printint+0x2a>
    neg = 1;
 666:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 66d:	8b 45 0c             	mov    0xc(%ebp),%eax
 670:	f7 d8                	neg    %eax
 672:	89 45 ec             	mov    %eax,-0x14(%ebp)
 675:	eb 06                	jmp    67d <printint+0x30>
  } else {
    x = xx;
 677:	8b 45 0c             	mov    0xc(%ebp),%eax
 67a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 67d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 684:	8b 4d 10             	mov    0x10(%ebp),%ecx
 687:	8b 45 ec             	mov    -0x14(%ebp),%eax
 68a:	ba 00 00 00 00       	mov    $0x0,%edx
 68f:	f7 f1                	div    %ecx
 691:	89 d1                	mov    %edx,%ecx
 693:	8b 45 f4             	mov    -0xc(%ebp),%eax
 696:	8d 50 01             	lea    0x1(%eax),%edx
 699:	89 55 f4             	mov    %edx,-0xc(%ebp)
 69c:	0f b6 91 c0 0d 00 00 	movzbl 0xdc0(%ecx),%edx
 6a3:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 6a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6ad:	ba 00 00 00 00       	mov    $0x0,%edx
 6b2:	f7 f1                	div    %ecx
 6b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6bb:	75 c7                	jne    684 <printint+0x37>
  if(neg)
 6bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6c1:	74 2d                	je     6f0 <printint+0xa3>
    buf[i++] = '-';
 6c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c6:	8d 50 01             	lea    0x1(%eax),%edx
 6c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6cc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6d1:	eb 1d                	jmp    6f0 <printint+0xa3>
    putc(fd, buf[i]);
 6d3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d9:	01 d0                	add    %edx,%eax
 6db:	0f b6 00             	movzbl (%eax),%eax
 6de:	0f be c0             	movsbl %al,%eax
 6e1:	83 ec 08             	sub    $0x8,%esp
 6e4:	50                   	push   %eax
 6e5:	ff 75 08             	push   0x8(%ebp)
 6e8:	e8 3d ff ff ff       	call   62a <putc>
 6ed:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 6f0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f8:	79 d9                	jns    6d3 <printint+0x86>
}
 6fa:	90                   	nop
 6fb:	90                   	nop
 6fc:	c9                   	leave
 6fd:	c3                   	ret

000006fe <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6fe:	55                   	push   %ebp
 6ff:	89 e5                	mov    %esp,%ebp
 701:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 704:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 70b:	8d 45 0c             	lea    0xc(%ebp),%eax
 70e:	83 c0 04             	add    $0x4,%eax
 711:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 714:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 71b:	e9 59 01 00 00       	jmp    879 <printf+0x17b>
    c = fmt[i] & 0xff;
 720:	8b 55 0c             	mov    0xc(%ebp),%edx
 723:	8b 45 f0             	mov    -0x10(%ebp),%eax
 726:	01 d0                	add    %edx,%eax
 728:	0f b6 00             	movzbl (%eax),%eax
 72b:	0f be c0             	movsbl %al,%eax
 72e:	25 ff 00 00 00       	and    $0xff,%eax
 733:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 736:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 73a:	75 2c                	jne    768 <printf+0x6a>
      if(c == '%'){
 73c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 740:	75 0c                	jne    74e <printf+0x50>
        state = '%';
 742:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 749:	e9 27 01 00 00       	jmp    875 <printf+0x177>
      } else {
        putc(fd, c);
 74e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 751:	0f be c0             	movsbl %al,%eax
 754:	83 ec 08             	sub    $0x8,%esp
 757:	50                   	push   %eax
 758:	ff 75 08             	push   0x8(%ebp)
 75b:	e8 ca fe ff ff       	call   62a <putc>
 760:	83 c4 10             	add    $0x10,%esp
 763:	e9 0d 01 00 00       	jmp    875 <printf+0x177>
      }
    } else if(state == '%'){
 768:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 76c:	0f 85 03 01 00 00    	jne    875 <printf+0x177>
      if(c == 'd'){
 772:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 776:	75 1e                	jne    796 <printf+0x98>
        printint(fd, *ap, 10, 1);
 778:	8b 45 e8             	mov    -0x18(%ebp),%eax
 77b:	8b 00                	mov    (%eax),%eax
 77d:	6a 01                	push   $0x1
 77f:	6a 0a                	push   $0xa
 781:	50                   	push   %eax
 782:	ff 75 08             	push   0x8(%ebp)
 785:	e8 c3 fe ff ff       	call   64d <printint>
 78a:	83 c4 10             	add    $0x10,%esp
        ap++;
 78d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 791:	e9 d8 00 00 00       	jmp    86e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 796:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 79a:	74 06                	je     7a2 <printf+0xa4>
 79c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7a0:	75 1e                	jne    7c0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a5:	8b 00                	mov    (%eax),%eax
 7a7:	6a 00                	push   $0x0
 7a9:	6a 10                	push   $0x10
 7ab:	50                   	push   %eax
 7ac:	ff 75 08             	push   0x8(%ebp)
 7af:	e8 99 fe ff ff       	call   64d <printint>
 7b4:	83 c4 10             	add    $0x10,%esp
        ap++;
 7b7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7bb:	e9 ae 00 00 00       	jmp    86e <printf+0x170>
      } else if(c == 's'){
 7c0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7c4:	75 43                	jne    809 <printf+0x10b>
        s = (char*)*ap;
 7c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c9:	8b 00                	mov    (%eax),%eax
 7cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d6:	75 25                	jne    7fd <printf+0xff>
          s = "(null)";
 7d8:	c7 45 f4 ee 0a 00 00 	movl   $0xaee,-0xc(%ebp)
        while(*s != 0){
 7df:	eb 1c                	jmp    7fd <printf+0xff>
          putc(fd, *s);
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	0f b6 00             	movzbl (%eax),%eax
 7e7:	0f be c0             	movsbl %al,%eax
 7ea:	83 ec 08             	sub    $0x8,%esp
 7ed:	50                   	push   %eax
 7ee:	ff 75 08             	push   0x8(%ebp)
 7f1:	e8 34 fe ff ff       	call   62a <putc>
 7f6:	83 c4 10             	add    $0x10,%esp
          s++;
 7f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	0f b6 00             	movzbl (%eax),%eax
 803:	84 c0                	test   %al,%al
 805:	75 da                	jne    7e1 <printf+0xe3>
 807:	eb 65                	jmp    86e <printf+0x170>
        }
      } else if(c == 'c'){
 809:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 80d:	75 1d                	jne    82c <printf+0x12e>
        putc(fd, *ap);
 80f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 812:	8b 00                	mov    (%eax),%eax
 814:	0f be c0             	movsbl %al,%eax
 817:	83 ec 08             	sub    $0x8,%esp
 81a:	50                   	push   %eax
 81b:	ff 75 08             	push   0x8(%ebp)
 81e:	e8 07 fe ff ff       	call   62a <putc>
 823:	83 c4 10             	add    $0x10,%esp
        ap++;
 826:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 82a:	eb 42                	jmp    86e <printf+0x170>
      } else if(c == '%'){
 82c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 830:	75 17                	jne    849 <printf+0x14b>
        putc(fd, c);
 832:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 835:	0f be c0             	movsbl %al,%eax
 838:	83 ec 08             	sub    $0x8,%esp
 83b:	50                   	push   %eax
 83c:	ff 75 08             	push   0x8(%ebp)
 83f:	e8 e6 fd ff ff       	call   62a <putc>
 844:	83 c4 10             	add    $0x10,%esp
 847:	eb 25                	jmp    86e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 849:	83 ec 08             	sub    $0x8,%esp
 84c:	6a 25                	push   $0x25
 84e:	ff 75 08             	push   0x8(%ebp)
 851:	e8 d4 fd ff ff       	call   62a <putc>
 856:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 859:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 85c:	0f be c0             	movsbl %al,%eax
 85f:	83 ec 08             	sub    $0x8,%esp
 862:	50                   	push   %eax
 863:	ff 75 08             	push   0x8(%ebp)
 866:	e8 bf fd ff ff       	call   62a <putc>
 86b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 86e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 875:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 879:	8b 55 0c             	mov    0xc(%ebp),%edx
 87c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87f:	01 d0                	add    %edx,%eax
 881:	0f b6 00             	movzbl (%eax),%eax
 884:	84 c0                	test   %al,%al
 886:	0f 85 94 fe ff ff    	jne    720 <printf+0x22>
    }
  }
}
 88c:	90                   	nop
 88d:	90                   	nop
 88e:	c9                   	leave
 88f:	c3                   	ret

00000890 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 896:	8b 45 08             	mov    0x8(%ebp),%eax
 899:	83 e8 08             	sub    $0x8,%eax
 89c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89f:	a1 e8 11 00 00       	mov    0x11e8,%eax
 8a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8a7:	eb 24                	jmp    8cd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ac:	8b 00                	mov    (%eax),%eax
 8ae:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8b1:	72 12                	jb     8c5 <free+0x35>
 8b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b6:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8b9:	72 24                	jb     8df <free+0x4f>
 8bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8be:	8b 00                	mov    (%eax),%eax
 8c0:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8c3:	72 1a                	jb     8df <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c8:	8b 00                	mov    (%eax),%eax
 8ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d0:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8d3:	73 d4                	jae    8a9 <free+0x19>
 8d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d8:	8b 00                	mov    (%eax),%eax
 8da:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8dd:	73 ca                	jae    8a9 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e2:	8b 40 04             	mov    0x4(%eax),%eax
 8e5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ef:	01 c2                	add    %eax,%edx
 8f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f4:	8b 00                	mov    (%eax),%eax
 8f6:	39 c2                	cmp    %eax,%edx
 8f8:	75 24                	jne    91e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fd:	8b 50 04             	mov    0x4(%eax),%edx
 900:	8b 45 fc             	mov    -0x4(%ebp),%eax
 903:	8b 00                	mov    (%eax),%eax
 905:	8b 40 04             	mov    0x4(%eax),%eax
 908:	01 c2                	add    %eax,%edx
 90a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 910:	8b 45 fc             	mov    -0x4(%ebp),%eax
 913:	8b 00                	mov    (%eax),%eax
 915:	8b 10                	mov    (%eax),%edx
 917:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91a:	89 10                	mov    %edx,(%eax)
 91c:	eb 0a                	jmp    928 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 91e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 921:	8b 10                	mov    (%eax),%edx
 923:	8b 45 f8             	mov    -0x8(%ebp),%eax
 926:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 928:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92b:	8b 40 04             	mov    0x4(%eax),%eax
 92e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 935:	8b 45 fc             	mov    -0x4(%ebp),%eax
 938:	01 d0                	add    %edx,%eax
 93a:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 93d:	75 20                	jne    95f <free+0xcf>
    p->s.size += bp->s.size;
 93f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 942:	8b 50 04             	mov    0x4(%eax),%edx
 945:	8b 45 f8             	mov    -0x8(%ebp),%eax
 948:	8b 40 04             	mov    0x4(%eax),%eax
 94b:	01 c2                	add    %eax,%edx
 94d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 950:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 953:	8b 45 f8             	mov    -0x8(%ebp),%eax
 956:	8b 10                	mov    (%eax),%edx
 958:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95b:	89 10                	mov    %edx,(%eax)
 95d:	eb 08                	jmp    967 <free+0xd7>
  } else
    p->s.ptr = bp;
 95f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 962:	8b 55 f8             	mov    -0x8(%ebp),%edx
 965:	89 10                	mov    %edx,(%eax)
  freep = p;
 967:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96a:	a3 e8 11 00 00       	mov    %eax,0x11e8
}
 96f:	90                   	nop
 970:	c9                   	leave
 971:	c3                   	ret

00000972 <morecore>:

static Header*
morecore(uint nu)
{
 972:	55                   	push   %ebp
 973:	89 e5                	mov    %esp,%ebp
 975:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 978:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 97f:	77 07                	ja     988 <morecore+0x16>
    nu = 4096;
 981:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 988:	8b 45 08             	mov    0x8(%ebp),%eax
 98b:	c1 e0 03             	shl    $0x3,%eax
 98e:	83 ec 0c             	sub    $0xc,%esp
 991:	50                   	push   %eax
 992:	e8 73 fc ff ff       	call   60a <sbrk>
 997:	83 c4 10             	add    $0x10,%esp
 99a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 99d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9a1:	75 07                	jne    9aa <morecore+0x38>
    return 0;
 9a3:	b8 00 00 00 00       	mov    $0x0,%eax
 9a8:	eb 26                	jmp    9d0 <morecore+0x5e>
  hp = (Header*)p;
 9aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b3:	8b 55 08             	mov    0x8(%ebp),%edx
 9b6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9bc:	83 c0 08             	add    $0x8,%eax
 9bf:	83 ec 0c             	sub    $0xc,%esp
 9c2:	50                   	push   %eax
 9c3:	e8 c8 fe ff ff       	call   890 <free>
 9c8:	83 c4 10             	add    $0x10,%esp
  return freep;
 9cb:	a1 e8 11 00 00       	mov    0x11e8,%eax
}
 9d0:	c9                   	leave
 9d1:	c3                   	ret

000009d2 <malloc>:

void*
malloc(uint nbytes)
{
 9d2:	55                   	push   %ebp
 9d3:	89 e5                	mov    %esp,%ebp
 9d5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d8:	8b 45 08             	mov    0x8(%ebp),%eax
 9db:	83 c0 07             	add    $0x7,%eax
 9de:	c1 e8 03             	shr    $0x3,%eax
 9e1:	83 c0 01             	add    $0x1,%eax
 9e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9e7:	a1 e8 11 00 00       	mov    0x11e8,%eax
 9ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9f3:	75 23                	jne    a18 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9f5:	c7 45 f0 e0 11 00 00 	movl   $0x11e0,-0x10(%ebp)
 9fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ff:	a3 e8 11 00 00       	mov    %eax,0x11e8
 a04:	a1 e8 11 00 00       	mov    0x11e8,%eax
 a09:	a3 e0 11 00 00       	mov    %eax,0x11e0
    base.s.size = 0;
 a0e:	c7 05 e4 11 00 00 00 	movl   $0x0,0x11e4
 a15:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1b:	8b 00                	mov    (%eax),%eax
 a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a23:	8b 40 04             	mov    0x4(%eax),%eax
 a26:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a29:	72 4d                	jb     a78 <malloc+0xa6>
      if(p->s.size == nunits)
 a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2e:	8b 40 04             	mov    0x4(%eax),%eax
 a31:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a34:	75 0c                	jne    a42 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a39:	8b 10                	mov    (%eax),%edx
 a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3e:	89 10                	mov    %edx,(%eax)
 a40:	eb 26                	jmp    a68 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a45:	8b 40 04             	mov    0x4(%eax),%eax
 a48:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a4b:	89 c2                	mov    %eax,%edx
 a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a50:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a56:	8b 40 04             	mov    0x4(%eax),%eax
 a59:	c1 e0 03             	shl    $0x3,%eax
 a5c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a62:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a65:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a6b:	a3 e8 11 00 00       	mov    %eax,0x11e8
      return (void*)(p + 1);
 a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a73:	83 c0 08             	add    $0x8,%eax
 a76:	eb 3b                	jmp    ab3 <malloc+0xe1>
    }
    if(p == freep)
 a78:	a1 e8 11 00 00       	mov    0x11e8,%eax
 a7d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a80:	75 1e                	jne    aa0 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a82:	83 ec 0c             	sub    $0xc,%esp
 a85:	ff 75 ec             	push   -0x14(%ebp)
 a88:	e8 e5 fe ff ff       	call   972 <morecore>
 a8d:	83 c4 10             	add    $0x10,%esp
 a90:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a97:	75 07                	jne    aa0 <malloc+0xce>
        return 0;
 a99:	b8 00 00 00 00       	mov    $0x0,%eax
 a9e:	eb 13                	jmp    ab3 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa9:	8b 00                	mov    (%eax),%eax
 aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 aae:	e9 6d ff ff ff       	jmp    a20 <malloc+0x4e>
  }
}
 ab3:	c9                   	leave
 ab4:	c3                   	ret
