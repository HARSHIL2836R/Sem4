
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 ca 0e 00 00       	call   edb <exit>

  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 3c 14 00 00 	mov    0x143c(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	83 ec 0c             	sub    $0xc,%esp
      27:	68 10 14 00 00       	push   $0x1410
      2c:	e8 6e 03 00 00       	call   39f <panic>
      31:	83 c4 10             	add    $0x10,%esp

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      34:	8b 45 08             	mov    0x8(%ebp),%eax
      37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(ecmd->argv[0] == 0)
      3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      3d:	8b 40 04             	mov    0x4(%eax),%eax
      40:	85 c0                	test   %eax,%eax
      42:	75 05                	jne    49 <runcmd+0x49>
      exit();
      44:	e8 92 0e 00 00       	call   edb <exit>
    exec(ecmd->argv[0], ecmd->argv);
      49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      4c:	8d 50 04             	lea    0x4(%eax),%edx
      4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      52:	8b 40 04             	mov    0x4(%eax),%eax
      55:	83 ec 08             	sub    $0x8,%esp
      58:	52                   	push   %edx
      59:	50                   	push   %eax
      5a:	e8 b4 0e 00 00       	call   f13 <exec>
      5f:	83 c4 10             	add    $0x10,%esp
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      65:	8b 40 04             	mov    0x4(%eax),%eax
      68:	83 ec 04             	sub    $0x4,%esp
      6b:	50                   	push   %eax
      6c:	68 17 14 00 00       	push   $0x1417
      71:	6a 02                	push   $0x2
      73:	e8 df 0f 00 00       	call   1057 <printf>
      78:	83 c4 10             	add    $0x10,%esp
    break;
      7b:	e9 c6 01 00 00       	jmp    246 <runcmd+0x246>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 e8             	mov    %eax,-0x18(%ebp)
    close(rcmd->fd);
      86:	8b 45 e8             	mov    -0x18(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	83 ec 0c             	sub    $0xc,%esp
      8f:	50                   	push   %eax
      90:	e8 6e 0e 00 00       	call   f03 <close>
      95:	83 c4 10             	add    $0x10,%esp
    if(open(rcmd->file, rcmd->mode) < 0){
      98:	8b 45 e8             	mov    -0x18(%ebp),%eax
      9b:	8b 50 10             	mov    0x10(%eax),%edx
      9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
      a1:	8b 40 08             	mov    0x8(%eax),%eax
      a4:	83 ec 08             	sub    $0x8,%esp
      a7:	52                   	push   %edx
      a8:	50                   	push   %eax
      a9:	e8 6d 0e 00 00       	call   f1b <open>
      ae:	83 c4 10             	add    $0x10,%esp
      b1:	85 c0                	test   %eax,%eax
      b3:	79 1e                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
      b8:	8b 40 08             	mov    0x8(%eax),%eax
      bb:	83 ec 04             	sub    $0x4,%esp
      be:	50                   	push   %eax
      bf:	68 27 14 00 00       	push   $0x1427
      c4:	6a 02                	push   $0x2
      c6:	e8 8c 0f 00 00       	call   1057 <printf>
      cb:	83 c4 10             	add    $0x10,%esp
      exit();
      ce:	e8 08 0e 00 00       	call   edb <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	83 ec 0c             	sub    $0xc,%esp
      dc:	50                   	push   %eax
      dd:	e8 1e ff ff ff       	call   0 <runcmd>
      e2:	83 c4 10             	add    $0x10,%esp
    break;
      e5:	e9 5c 01 00 00       	jmp    246 <runcmd+0x246>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      ea:	8b 45 08             	mov    0x8(%ebp),%eax
      ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fork1() == 0)
      f0:	e8 ca 02 00 00       	call   3bf <fork1>
      f5:	85 c0                	test   %eax,%eax
      f7:	75 12                	jne    10b <runcmd+0x10b>
      runcmd(lcmd->left);
      f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
      fc:	8b 40 04             	mov    0x4(%eax),%eax
      ff:	83 ec 0c             	sub    $0xc,%esp
     102:	50                   	push   %eax
     103:	e8 f8 fe ff ff       	call   0 <runcmd>
     108:	83 c4 10             	add    $0x10,%esp
    wait();
     10b:	e8 d3 0d 00 00       	call   ee3 <wait>
    runcmd(lcmd->right);
     110:	8b 45 f0             	mov    -0x10(%ebp),%eax
     113:	8b 40 08             	mov    0x8(%eax),%eax
     116:	83 ec 0c             	sub    $0xc,%esp
     119:	50                   	push   %eax
     11a:	e8 e1 fe ff ff       	call   0 <runcmd>
     11f:	83 c4 10             	add    $0x10,%esp
    break;
     122:	e9 1f 01 00 00       	jmp    246 <runcmd+0x246>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     127:	8b 45 08             	mov    0x8(%ebp),%eax
     12a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pipe(p) < 0)
     12d:	83 ec 0c             	sub    $0xc,%esp
     130:	8d 45 dc             	lea    -0x24(%ebp),%eax
     133:	50                   	push   %eax
     134:	e8 b2 0d 00 00       	call   eeb <pipe>
     139:	83 c4 10             	add    $0x10,%esp
     13c:	85 c0                	test   %eax,%eax
     13e:	79 10                	jns    150 <runcmd+0x150>
      panic("pipe");
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	68 37 14 00 00       	push   $0x1437
     148:	e8 52 02 00 00       	call   39f <panic>
     14d:	83 c4 10             	add    $0x10,%esp
    if(fork1() == 0){
     150:	e8 6a 02 00 00       	call   3bf <fork1>
     155:	85 c0                	test   %eax,%eax
     157:	75 4c                	jne    1a5 <runcmd+0x1a5>
      close(1);
     159:	83 ec 0c             	sub    $0xc,%esp
     15c:	6a 01                	push   $0x1
     15e:	e8 a0 0d 00 00       	call   f03 <close>
     163:	83 c4 10             	add    $0x10,%esp
      dup(p[1]);
     166:	8b 45 e0             	mov    -0x20(%ebp),%eax
     169:	83 ec 0c             	sub    $0xc,%esp
     16c:	50                   	push   %eax
     16d:	e8 e1 0d 00 00       	call   f53 <dup>
     172:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     175:	8b 45 dc             	mov    -0x24(%ebp),%eax
     178:	83 ec 0c             	sub    $0xc,%esp
     17b:	50                   	push   %eax
     17c:	e8 82 0d 00 00       	call   f03 <close>
     181:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     184:	8b 45 e0             	mov    -0x20(%ebp),%eax
     187:	83 ec 0c             	sub    $0xc,%esp
     18a:	50                   	push   %eax
     18b:	e8 73 0d 00 00       	call   f03 <close>
     190:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->left);
     193:	8b 45 ec             	mov    -0x14(%ebp),%eax
     196:	8b 40 04             	mov    0x4(%eax),%eax
     199:	83 ec 0c             	sub    $0xc,%esp
     19c:	50                   	push   %eax
     19d:	e8 5e fe ff ff       	call   0 <runcmd>
     1a2:	83 c4 10             	add    $0x10,%esp
    }
    if(fork1() == 0){
     1a5:	e8 15 02 00 00       	call   3bf <fork1>
     1aa:	85 c0                	test   %eax,%eax
     1ac:	75 4c                	jne    1fa <runcmd+0x1fa>
      close(0);
     1ae:	83 ec 0c             	sub    $0xc,%esp
     1b1:	6a 00                	push   $0x0
     1b3:	e8 4b 0d 00 00       	call   f03 <close>
     1b8:	83 c4 10             	add    $0x10,%esp
      dup(p[0]);
     1bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1be:	83 ec 0c             	sub    $0xc,%esp
     1c1:	50                   	push   %eax
     1c2:	e8 8c 0d 00 00       	call   f53 <dup>
     1c7:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     1ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1cd:	83 ec 0c             	sub    $0xc,%esp
     1d0:	50                   	push   %eax
     1d1:	e8 2d 0d 00 00       	call   f03 <close>
     1d6:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     1d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1dc:	83 ec 0c             	sub    $0xc,%esp
     1df:	50                   	push   %eax
     1e0:	e8 1e 0d 00 00       	call   f03 <close>
     1e5:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->right);
     1e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
     1eb:	8b 40 08             	mov    0x8(%eax),%eax
     1ee:	83 ec 0c             	sub    $0xc,%esp
     1f1:	50                   	push   %eax
     1f2:	e8 09 fe ff ff       	call   0 <runcmd>
     1f7:	83 c4 10             	add    $0x10,%esp
    }
    close(p[0]);
     1fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1fd:	83 ec 0c             	sub    $0xc,%esp
     200:	50                   	push   %eax
     201:	e8 fd 0c 00 00       	call   f03 <close>
     206:	83 c4 10             	add    $0x10,%esp
    close(p[1]);
     209:	8b 45 e0             	mov    -0x20(%ebp),%eax
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	50                   	push   %eax
     210:	e8 ee 0c 00 00       	call   f03 <close>
     215:	83 c4 10             	add    $0x10,%esp
    wait();
     218:	e8 c6 0c 00 00       	call   ee3 <wait>
    wait();
     21d:	e8 c1 0c 00 00       	call   ee3 <wait>
    break;
     222:	eb 22                	jmp    246 <runcmd+0x246>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     224:	8b 45 08             	mov    0x8(%ebp),%eax
     227:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(fork1() == 0)
     22a:	e8 90 01 00 00       	call   3bf <fork1>
     22f:	85 c0                	test   %eax,%eax
     231:	75 12                	jne    245 <runcmd+0x245>
      runcmd(bcmd->cmd);
     233:	8b 45 f4             	mov    -0xc(%ebp),%eax
     236:	8b 40 04             	mov    0x4(%eax),%eax
     239:	83 ec 0c             	sub    $0xc,%esp
     23c:	50                   	push   %eax
     23d:	e8 be fd ff ff       	call   0 <runcmd>
     242:	83 c4 10             	add    $0x10,%esp
    break;
     245:	90                   	nop
  }
  exit();
     246:	e8 90 0c 00 00       	call   edb <exit>

0000024b <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     24b:	55                   	push   %ebp
     24c:	89 e5                	mov    %esp,%ebp
     24e:	83 ec 08             	sub    $0x8,%esp
  printf(2, "$ ");
     251:	83 ec 08             	sub    $0x8,%esp
     254:	68 54 14 00 00       	push   $0x1454
     259:	6a 02                	push   $0x2
     25b:	e8 f7 0d 00 00       	call   1057 <printf>
     260:	83 c4 10             	add    $0x10,%esp
  memset(buf, 0, nbuf);
     263:	8b 45 0c             	mov    0xc(%ebp),%eax
     266:	83 ec 04             	sub    $0x4,%esp
     269:	50                   	push   %eax
     26a:	6a 00                	push   $0x0
     26c:	ff 75 08             	push   0x8(%ebp)
     26f:	e8 cc 0a 00 00       	call   d40 <memset>
     274:	83 c4 10             	add    $0x10,%esp
  gets(buf, nbuf);
     277:	83 ec 08             	sub    $0x8,%esp
     27a:	ff 75 0c             	push   0xc(%ebp)
     27d:	ff 75 08             	push   0x8(%ebp)
     280:	e8 08 0b 00 00       	call   d8d <gets>
     285:	83 c4 10             	add    $0x10,%esp
  if(buf[0] == 0) // EOF
     288:	8b 45 08             	mov    0x8(%ebp),%eax
     28b:	0f b6 00             	movzbl (%eax),%eax
     28e:	84 c0                	test   %al,%al
     290:	75 07                	jne    299 <getcmd+0x4e>
    return -1;
     292:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     297:	eb 05                	jmp    29e <getcmd+0x53>
  return 0;
     299:	b8 00 00 00 00       	mov    $0x0,%eax
}
     29e:	c9                   	leave
     29f:	c3                   	ret

000002a0 <main>:

int
main(void)
{
     2a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     2a4:	83 e4 f0             	and    $0xfffffff0,%esp
     2a7:	ff 71 fc             	push   -0x4(%ecx)
     2aa:	55                   	push   %ebp
     2ab:	89 e5                	mov    %esp,%ebp
     2ad:	51                   	push   %ecx
     2ae:	83 ec 14             	sub    $0x14,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     2b1:	eb 16                	jmp    2c9 <main+0x29>
    if(fd >= 3){
     2b3:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
     2b7:	7e 10                	jle    2c9 <main+0x29>
      close(fd);
     2b9:	83 ec 0c             	sub    $0xc,%esp
     2bc:	ff 75 f4             	push   -0xc(%ebp)
     2bf:	e8 3f 0c 00 00       	call   f03 <close>
     2c4:	83 c4 10             	add    $0x10,%esp
      break;
     2c7:	eb 1b                	jmp    2e4 <main+0x44>
  while((fd = open("console", O_RDWR)) >= 0){
     2c9:	83 ec 08             	sub    $0x8,%esp
     2cc:	6a 02                	push   $0x2
     2ce:	68 57 14 00 00       	push   $0x1457
     2d3:	e8 43 0c 00 00       	call   f1b <open>
     2d8:	83 c4 10             	add    $0x10,%esp
     2db:	89 45 f4             	mov    %eax,-0xc(%ebp)
     2de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2e2:	79 cf                	jns    2b3 <main+0x13>
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2e4:	e9 97 00 00 00       	jmp    380 <main+0xe0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2e9:	0f b6 05 c0 19 00 00 	movzbl 0x19c0,%eax
     2f0:	3c 63                	cmp    $0x63,%al
     2f2:	75 5f                	jne    353 <main+0xb3>
     2f4:	0f b6 05 c1 19 00 00 	movzbl 0x19c1,%eax
     2fb:	3c 64                	cmp    $0x64,%al
     2fd:	75 54                	jne    353 <main+0xb3>
     2ff:	0f b6 05 c2 19 00 00 	movzbl 0x19c2,%eax
     306:	3c 20                	cmp    $0x20,%al
     308:	75 49                	jne    353 <main+0xb3>
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     30a:	83 ec 0c             	sub    $0xc,%esp
     30d:	68 c0 19 00 00       	push   $0x19c0
     312:	e8 02 0a 00 00       	call   d19 <strlen>
     317:	83 c4 10             	add    $0x10,%esp
     31a:	83 e8 01             	sub    $0x1,%eax
     31d:	c6 80 c0 19 00 00 00 	movb   $0x0,0x19c0(%eax)
      if(chdir(buf+3) < 0)
     324:	b8 c3 19 00 00       	mov    $0x19c3,%eax
     329:	83 ec 0c             	sub    $0xc,%esp
     32c:	50                   	push   %eax
     32d:	e8 19 0c 00 00       	call   f4b <chdir>
     332:	83 c4 10             	add    $0x10,%esp
     335:	85 c0                	test   %eax,%eax
     337:	79 46                	jns    37f <main+0xdf>
        printf(2, "cannot cd %s\n", buf+3);
     339:	b8 c3 19 00 00       	mov    $0x19c3,%eax
     33e:	83 ec 04             	sub    $0x4,%esp
     341:	50                   	push   %eax
     342:	68 5f 14 00 00       	push   $0x145f
     347:	6a 02                	push   $0x2
     349:	e8 09 0d 00 00       	call   1057 <printf>
     34e:	83 c4 10             	add    $0x10,%esp
      continue;
     351:	eb 2c                	jmp    37f <main+0xdf>
    }
    if(fork1() == 0)
     353:	e8 67 00 00 00       	call   3bf <fork1>
     358:	85 c0                	test   %eax,%eax
     35a:	75 1c                	jne    378 <main+0xd8>
      runcmd(parsecmd(buf));
     35c:	83 ec 0c             	sub    $0xc,%esp
     35f:	68 c0 19 00 00       	push   $0x19c0
     364:	e8 ad 03 00 00       	call   716 <parsecmd>
     369:	83 c4 10             	add    $0x10,%esp
     36c:	83 ec 0c             	sub    $0xc,%esp
     36f:	50                   	push   %eax
     370:	e8 8b fc ff ff       	call   0 <runcmd>
     375:	83 c4 10             	add    $0x10,%esp
    wait();
     378:	e8 66 0b 00 00       	call   ee3 <wait>
     37d:	eb 01                	jmp    380 <main+0xe0>
      continue;
     37f:	90                   	nop
  while(getcmd(buf, sizeof(buf)) >= 0){
     380:	83 ec 08             	sub    $0x8,%esp
     383:	6a 64                	push   $0x64
     385:	68 c0 19 00 00       	push   $0x19c0
     38a:	e8 bc fe ff ff       	call   24b <getcmd>
     38f:	83 c4 10             	add    $0x10,%esp
     392:	85 c0                	test   %eax,%eax
     394:	0f 89 4f ff ff ff    	jns    2e9 <main+0x49>
  }
  exit();
     39a:	e8 3c 0b 00 00       	call   edb <exit>

0000039f <panic>:
}

void
panic(char *s)
{
     39f:	55                   	push   %ebp
     3a0:	89 e5                	mov    %esp,%ebp
     3a2:	83 ec 08             	sub    $0x8,%esp
  printf(2, "%s\n", s);
     3a5:	83 ec 04             	sub    $0x4,%esp
     3a8:	ff 75 08             	push   0x8(%ebp)
     3ab:	68 6d 14 00 00       	push   $0x146d
     3b0:	6a 02                	push   $0x2
     3b2:	e8 a0 0c 00 00       	call   1057 <printf>
     3b7:	83 c4 10             	add    $0x10,%esp
  exit();
     3ba:	e8 1c 0b 00 00       	call   edb <exit>

000003bf <fork1>:
}

int
fork1(void)
{
     3bf:	55                   	push   %ebp
     3c0:	89 e5                	mov    %esp,%ebp
     3c2:	83 ec 18             	sub    $0x18,%esp
  int pid;

  pid = fork();
     3c5:	e8 09 0b 00 00       	call   ed3 <fork>
     3ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     3cd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     3d1:	75 10                	jne    3e3 <fork1+0x24>
    panic("fork");
     3d3:	83 ec 0c             	sub    $0xc,%esp
     3d6:	68 71 14 00 00       	push   $0x1471
     3db:	e8 bf ff ff ff       	call   39f <panic>
     3e0:	83 c4 10             	add    $0x10,%esp
  return pid;
     3e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3e6:	c9                   	leave
     3e7:	c3                   	ret

000003e8 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3e8:	55                   	push   %ebp
     3e9:	89 e5                	mov    %esp,%ebp
     3eb:	83 ec 18             	sub    $0x18,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3ee:	83 ec 0c             	sub    $0xc,%esp
     3f1:	6a 54                	push   $0x54
     3f3:	e8 33 0f 00 00       	call   132b <malloc>
     3f8:	83 c4 10             	add    $0x10,%esp
     3fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3fe:	83 ec 04             	sub    $0x4,%esp
     401:	6a 54                	push   $0x54
     403:	6a 00                	push   $0x0
     405:	ff 75 f4             	push   -0xc(%ebp)
     408:	e8 33 09 00 00       	call   d40 <memset>
     40d:	83 c4 10             	add    $0x10,%esp
  cmd->type = EXEC;
     410:	8b 45 f4             	mov    -0xc(%ebp),%eax
     413:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     419:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     41c:	c9                   	leave
     41d:	c3                   	ret

0000041e <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     41e:	55                   	push   %ebp
     41f:	89 e5                	mov    %esp,%ebp
     421:	83 ec 18             	sub    $0x18,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     424:	83 ec 0c             	sub    $0xc,%esp
     427:	6a 18                	push   $0x18
     429:	e8 fd 0e 00 00       	call   132b <malloc>
     42e:	83 c4 10             	add    $0x10,%esp
     431:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     434:	83 ec 04             	sub    $0x4,%esp
     437:	6a 18                	push   $0x18
     439:	6a 00                	push   $0x0
     43b:	ff 75 f4             	push   -0xc(%ebp)
     43e:	e8 fd 08 00 00       	call   d40 <memset>
     443:	83 c4 10             	add    $0x10,%esp
  cmd->type = REDIR;
     446:	8b 45 f4             	mov    -0xc(%ebp),%eax
     449:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     44f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     452:	8b 55 08             	mov    0x8(%ebp),%edx
     455:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     458:	8b 45 f4             	mov    -0xc(%ebp),%eax
     45b:	8b 55 0c             	mov    0xc(%ebp),%edx
     45e:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     461:	8b 45 f4             	mov    -0xc(%ebp),%eax
     464:	8b 55 10             	mov    0x10(%ebp),%edx
     467:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     46a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     46d:	8b 55 14             	mov    0x14(%ebp),%edx
     470:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     473:	8b 45 f4             	mov    -0xc(%ebp),%eax
     476:	8b 55 18             	mov    0x18(%ebp),%edx
     479:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     47c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     47f:	c9                   	leave
     480:	c3                   	ret

00000481 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     481:	55                   	push   %ebp
     482:	89 e5                	mov    %esp,%ebp
     484:	83 ec 18             	sub    $0x18,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     487:	83 ec 0c             	sub    $0xc,%esp
     48a:	6a 0c                	push   $0xc
     48c:	e8 9a 0e 00 00       	call   132b <malloc>
     491:	83 c4 10             	add    $0x10,%esp
     494:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     497:	83 ec 04             	sub    $0x4,%esp
     49a:	6a 0c                	push   $0xc
     49c:	6a 00                	push   $0x0
     49e:	ff 75 f4             	push   -0xc(%ebp)
     4a1:	e8 9a 08 00 00       	call   d40 <memset>
     4a6:	83 c4 10             	add    $0x10,%esp
  cmd->type = PIPE;
     4a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ac:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     4b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4b5:	8b 55 08             	mov    0x8(%ebp),%edx
     4b8:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4be:	8b 55 0c             	mov    0xc(%ebp),%edx
     4c1:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4c7:	c9                   	leave
     4c8:	c3                   	ret

000004c9 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     4c9:	55                   	push   %ebp
     4ca:	89 e5                	mov    %esp,%ebp
     4cc:	83 ec 18             	sub    $0x18,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4cf:	83 ec 0c             	sub    $0xc,%esp
     4d2:	6a 0c                	push   $0xc
     4d4:	e8 52 0e 00 00       	call   132b <malloc>
     4d9:	83 c4 10             	add    $0x10,%esp
     4dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4df:	83 ec 04             	sub    $0x4,%esp
     4e2:	6a 0c                	push   $0xc
     4e4:	6a 00                	push   $0x0
     4e6:	ff 75 f4             	push   -0xc(%ebp)
     4e9:	e8 52 08 00 00       	call   d40 <memset>
     4ee:	83 c4 10             	add    $0x10,%esp
  cmd->type = LIST;
     4f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4f4:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     4fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4fd:	8b 55 08             	mov    0x8(%ebp),%edx
     500:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     503:	8b 45 f4             	mov    -0xc(%ebp),%eax
     506:	8b 55 0c             	mov    0xc(%ebp),%edx
     509:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     50c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     50f:	c9                   	leave
     510:	c3                   	ret

00000511 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     511:	55                   	push   %ebp
     512:	89 e5                	mov    %esp,%ebp
     514:	83 ec 18             	sub    $0x18,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     517:	83 ec 0c             	sub    $0xc,%esp
     51a:	6a 08                	push   $0x8
     51c:	e8 0a 0e 00 00       	call   132b <malloc>
     521:	83 c4 10             	add    $0x10,%esp
     524:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     527:	83 ec 04             	sub    $0x4,%esp
     52a:	6a 08                	push   $0x8
     52c:	6a 00                	push   $0x0
     52e:	ff 75 f4             	push   -0xc(%ebp)
     531:	e8 0a 08 00 00       	call   d40 <memset>
     536:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     539:	8b 45 f4             	mov    -0xc(%ebp),%eax
     53c:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     542:	8b 45 f4             	mov    -0xc(%ebp),%eax
     545:	8b 55 08             	mov    0x8(%ebp),%edx
     548:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     54b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     54e:	c9                   	leave
     54f:	c3                   	ret

00000550 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     550:	55                   	push   %ebp
     551:	89 e5                	mov    %esp,%ebp
     553:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int ret;

  s = *ps;
     556:	8b 45 08             	mov    0x8(%ebp),%eax
     559:	8b 00                	mov    (%eax),%eax
     55b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     55e:	eb 04                	jmp    564 <gettoken+0x14>
    s++;
     560:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     564:	8b 45 f4             	mov    -0xc(%ebp),%eax
     567:	3b 45 0c             	cmp    0xc(%ebp),%eax
     56a:	73 1e                	jae    58a <gettoken+0x3a>
     56c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     56f:	0f b6 00             	movzbl (%eax),%eax
     572:	0f be c0             	movsbl %al,%eax
     575:	83 ec 08             	sub    $0x8,%esp
     578:	50                   	push   %eax
     579:	68 88 19 00 00       	push   $0x1988
     57e:	e8 d7 07 00 00       	call   d5a <strchr>
     583:	83 c4 10             	add    $0x10,%esp
     586:	85 c0                	test   %eax,%eax
     588:	75 d6                	jne    560 <gettoken+0x10>
  if(q)
     58a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     58e:	74 08                	je     598 <gettoken+0x48>
    *q = s;
     590:	8b 45 10             	mov    0x10(%ebp),%eax
     593:	8b 55 f4             	mov    -0xc(%ebp),%edx
     596:	89 10                	mov    %edx,(%eax)
  ret = *s;
     598:	8b 45 f4             	mov    -0xc(%ebp),%eax
     59b:	0f b6 00             	movzbl (%eax),%eax
     59e:	0f be c0             	movsbl %al,%eax
     5a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     5a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5a7:	0f b6 00             	movzbl (%eax),%eax
     5aa:	0f be c0             	movsbl %al,%eax
     5ad:	83 f8 7c             	cmp    $0x7c,%eax
     5b0:	74 2c                	je     5de <gettoken+0x8e>
     5b2:	83 f8 7c             	cmp    $0x7c,%eax
     5b5:	7f 48                	jg     5ff <gettoken+0xaf>
     5b7:	83 f8 3e             	cmp    $0x3e,%eax
     5ba:	74 28                	je     5e4 <gettoken+0x94>
     5bc:	83 f8 3e             	cmp    $0x3e,%eax
     5bf:	7f 3e                	jg     5ff <gettoken+0xaf>
     5c1:	83 f8 3c             	cmp    $0x3c,%eax
     5c4:	7f 39                	jg     5ff <gettoken+0xaf>
     5c6:	83 f8 3b             	cmp    $0x3b,%eax
     5c9:	7d 13                	jge    5de <gettoken+0x8e>
     5cb:	83 f8 29             	cmp    $0x29,%eax
     5ce:	7f 2f                	jg     5ff <gettoken+0xaf>
     5d0:	83 f8 28             	cmp    $0x28,%eax
     5d3:	7d 09                	jge    5de <gettoken+0x8e>
     5d5:	85 c0                	test   %eax,%eax
     5d7:	74 79                	je     652 <gettoken+0x102>
     5d9:	83 f8 26             	cmp    $0x26,%eax
     5dc:	75 21                	jne    5ff <gettoken+0xaf>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     5e2:	eb 75                	jmp    659 <gettoken+0x109>
  case '>':
    s++;
     5e4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     5e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5eb:	0f b6 00             	movzbl (%eax),%eax
     5ee:	3c 3e                	cmp    $0x3e,%al
     5f0:	75 63                	jne    655 <gettoken+0x105>
      ret = '+';
     5f2:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     5f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     5fd:	eb 56                	jmp    655 <gettoken+0x105>
  default:
    ret = 'a';
     5ff:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     606:	eb 04                	jmp    60c <gettoken+0xbc>
      s++;
     608:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     60c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     60f:	3b 45 0c             	cmp    0xc(%ebp),%eax
     612:	73 44                	jae    658 <gettoken+0x108>
     614:	8b 45 f4             	mov    -0xc(%ebp),%eax
     617:	0f b6 00             	movzbl (%eax),%eax
     61a:	0f be c0             	movsbl %al,%eax
     61d:	83 ec 08             	sub    $0x8,%esp
     620:	50                   	push   %eax
     621:	68 88 19 00 00       	push   $0x1988
     626:	e8 2f 07 00 00       	call   d5a <strchr>
     62b:	83 c4 10             	add    $0x10,%esp
     62e:	85 c0                	test   %eax,%eax
     630:	75 26                	jne    658 <gettoken+0x108>
     632:	8b 45 f4             	mov    -0xc(%ebp),%eax
     635:	0f b6 00             	movzbl (%eax),%eax
     638:	0f be c0             	movsbl %al,%eax
     63b:	83 ec 08             	sub    $0x8,%esp
     63e:	50                   	push   %eax
     63f:	68 90 19 00 00       	push   $0x1990
     644:	e8 11 07 00 00       	call   d5a <strchr>
     649:	83 c4 10             	add    $0x10,%esp
     64c:	85 c0                	test   %eax,%eax
     64e:	74 b8                	je     608 <gettoken+0xb8>
    break;
     650:	eb 06                	jmp    658 <gettoken+0x108>
    break;
     652:	90                   	nop
     653:	eb 04                	jmp    659 <gettoken+0x109>
    break;
     655:	90                   	nop
     656:	eb 01                	jmp    659 <gettoken+0x109>
    break;
     658:	90                   	nop
  }
  if(eq)
     659:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     65d:	74 0e                	je     66d <gettoken+0x11d>
    *eq = s;
     65f:	8b 45 14             	mov    0x14(%ebp),%eax
     662:	8b 55 f4             	mov    -0xc(%ebp),%edx
     665:	89 10                	mov    %edx,(%eax)

  while(s < es && strchr(whitespace, *s))
     667:	eb 04                	jmp    66d <gettoken+0x11d>
    s++;
     669:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     66d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     670:	3b 45 0c             	cmp    0xc(%ebp),%eax
     673:	73 1e                	jae    693 <gettoken+0x143>
     675:	8b 45 f4             	mov    -0xc(%ebp),%eax
     678:	0f b6 00             	movzbl (%eax),%eax
     67b:	0f be c0             	movsbl %al,%eax
     67e:	83 ec 08             	sub    $0x8,%esp
     681:	50                   	push   %eax
     682:	68 88 19 00 00       	push   $0x1988
     687:	e8 ce 06 00 00       	call   d5a <strchr>
     68c:	83 c4 10             	add    $0x10,%esp
     68f:	85 c0                	test   %eax,%eax
     691:	75 d6                	jne    669 <gettoken+0x119>
  *ps = s;
     693:	8b 45 08             	mov    0x8(%ebp),%eax
     696:	8b 55 f4             	mov    -0xc(%ebp),%edx
     699:	89 10                	mov    %edx,(%eax)
  return ret;
     69b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     69e:	c9                   	leave
     69f:	c3                   	ret

000006a0 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     6a0:	55                   	push   %ebp
     6a1:	89 e5                	mov    %esp,%ebp
     6a3:	83 ec 18             	sub    $0x18,%esp
  char *s;

  s = *ps;
     6a6:	8b 45 08             	mov    0x8(%ebp),%eax
     6a9:	8b 00                	mov    (%eax),%eax
     6ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     6ae:	eb 04                	jmp    6b4 <peek+0x14>
    s++;
     6b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     6b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
     6ba:	73 1e                	jae    6da <peek+0x3a>
     6bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6bf:	0f b6 00             	movzbl (%eax),%eax
     6c2:	0f be c0             	movsbl %al,%eax
     6c5:	83 ec 08             	sub    $0x8,%esp
     6c8:	50                   	push   %eax
     6c9:	68 88 19 00 00       	push   $0x1988
     6ce:	e8 87 06 00 00       	call   d5a <strchr>
     6d3:	83 c4 10             	add    $0x10,%esp
     6d6:	85 c0                	test   %eax,%eax
     6d8:	75 d6                	jne    6b0 <peek+0x10>
  *ps = s;
     6da:	8b 45 08             	mov    0x8(%ebp),%eax
     6dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6e0:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     6e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6e5:	0f b6 00             	movzbl (%eax),%eax
     6e8:	84 c0                	test   %al,%al
     6ea:	74 23                	je     70f <peek+0x6f>
     6ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ef:	0f b6 00             	movzbl (%eax),%eax
     6f2:	0f be c0             	movsbl %al,%eax
     6f5:	83 ec 08             	sub    $0x8,%esp
     6f8:	50                   	push   %eax
     6f9:	ff 75 10             	push   0x10(%ebp)
     6fc:	e8 59 06 00 00       	call   d5a <strchr>
     701:	83 c4 10             	add    $0x10,%esp
     704:	85 c0                	test   %eax,%eax
     706:	74 07                	je     70f <peek+0x6f>
     708:	b8 01 00 00 00       	mov    $0x1,%eax
     70d:	eb 05                	jmp    714 <peek+0x74>
     70f:	b8 00 00 00 00       	mov    $0x0,%eax
}
     714:	c9                   	leave
     715:	c3                   	ret

00000716 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     716:	55                   	push   %ebp
     717:	89 e5                	mov    %esp,%ebp
     719:	53                   	push   %ebx
     71a:	83 ec 14             	sub    $0x14,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     71d:	8b 5d 08             	mov    0x8(%ebp),%ebx
     720:	8b 45 08             	mov    0x8(%ebp),%eax
     723:	83 ec 0c             	sub    $0xc,%esp
     726:	50                   	push   %eax
     727:	e8 ed 05 00 00       	call   d19 <strlen>
     72c:	83 c4 10             	add    $0x10,%esp
     72f:	01 d8                	add    %ebx,%eax
     731:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     734:	83 ec 08             	sub    $0x8,%esp
     737:	ff 75 f4             	push   -0xc(%ebp)
     73a:	8d 45 08             	lea    0x8(%ebp),%eax
     73d:	50                   	push   %eax
     73e:	e8 61 00 00 00       	call   7a4 <parseline>
     743:	83 c4 10             	add    $0x10,%esp
     746:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     749:	83 ec 04             	sub    $0x4,%esp
     74c:	68 76 14 00 00       	push   $0x1476
     751:	ff 75 f4             	push   -0xc(%ebp)
     754:	8d 45 08             	lea    0x8(%ebp),%eax
     757:	50                   	push   %eax
     758:	e8 43 ff ff ff       	call   6a0 <peek>
     75d:	83 c4 10             	add    $0x10,%esp
  if(s != es){
     760:	8b 45 08             	mov    0x8(%ebp),%eax
     763:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     766:	74 26                	je     78e <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     768:	8b 45 08             	mov    0x8(%ebp),%eax
     76b:	83 ec 04             	sub    $0x4,%esp
     76e:	50                   	push   %eax
     76f:	68 77 14 00 00       	push   $0x1477
     774:	6a 02                	push   $0x2
     776:	e8 dc 08 00 00       	call   1057 <printf>
     77b:	83 c4 10             	add    $0x10,%esp
    panic("syntax");
     77e:	83 ec 0c             	sub    $0xc,%esp
     781:	68 86 14 00 00       	push   $0x1486
     786:	e8 14 fc ff ff       	call   39f <panic>
     78b:	83 c4 10             	add    $0x10,%esp
  }
  nulterminate(cmd);
     78e:	83 ec 0c             	sub    $0xc,%esp
     791:	ff 75 f0             	push   -0x10(%ebp)
     794:	e8 ef 03 00 00       	call   b88 <nulterminate>
     799:	83 c4 10             	add    $0x10,%esp
  return cmd;
     79c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     79f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     7a2:	c9                   	leave
     7a3:	c3                   	ret

000007a4 <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     7a4:	55                   	push   %ebp
     7a5:	89 e5                	mov    %esp,%ebp
     7a7:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     7aa:	83 ec 08             	sub    $0x8,%esp
     7ad:	ff 75 0c             	push   0xc(%ebp)
     7b0:	ff 75 08             	push   0x8(%ebp)
     7b3:	e8 99 00 00 00       	call   851 <parsepipe>
     7b8:	83 c4 10             	add    $0x10,%esp
     7bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     7be:	eb 23                	jmp    7e3 <parseline+0x3f>
    gettoken(ps, es, 0, 0);
     7c0:	6a 00                	push   $0x0
     7c2:	6a 00                	push   $0x0
     7c4:	ff 75 0c             	push   0xc(%ebp)
     7c7:	ff 75 08             	push   0x8(%ebp)
     7ca:	e8 81 fd ff ff       	call   550 <gettoken>
     7cf:	83 c4 10             	add    $0x10,%esp
    cmd = backcmd(cmd);
     7d2:	83 ec 0c             	sub    $0xc,%esp
     7d5:	ff 75 f4             	push   -0xc(%ebp)
     7d8:	e8 34 fd ff ff       	call   511 <backcmd>
     7dd:	83 c4 10             	add    $0x10,%esp
     7e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     7e3:	83 ec 04             	sub    $0x4,%esp
     7e6:	68 8d 14 00 00       	push   $0x148d
     7eb:	ff 75 0c             	push   0xc(%ebp)
     7ee:	ff 75 08             	push   0x8(%ebp)
     7f1:	e8 aa fe ff ff       	call   6a0 <peek>
     7f6:	83 c4 10             	add    $0x10,%esp
     7f9:	85 c0                	test   %eax,%eax
     7fb:	75 c3                	jne    7c0 <parseline+0x1c>
  }
  if(peek(ps, es, ";")){
     7fd:	83 ec 04             	sub    $0x4,%esp
     800:	68 8f 14 00 00       	push   $0x148f
     805:	ff 75 0c             	push   0xc(%ebp)
     808:	ff 75 08             	push   0x8(%ebp)
     80b:	e8 90 fe ff ff       	call   6a0 <peek>
     810:	83 c4 10             	add    $0x10,%esp
     813:	85 c0                	test   %eax,%eax
     815:	74 35                	je     84c <parseline+0xa8>
    gettoken(ps, es, 0, 0);
     817:	6a 00                	push   $0x0
     819:	6a 00                	push   $0x0
     81b:	ff 75 0c             	push   0xc(%ebp)
     81e:	ff 75 08             	push   0x8(%ebp)
     821:	e8 2a fd ff ff       	call   550 <gettoken>
     826:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     829:	83 ec 08             	sub    $0x8,%esp
     82c:	ff 75 0c             	push   0xc(%ebp)
     82f:	ff 75 08             	push   0x8(%ebp)
     832:	e8 6d ff ff ff       	call   7a4 <parseline>
     837:	83 c4 10             	add    $0x10,%esp
     83a:	83 ec 08             	sub    $0x8,%esp
     83d:	50                   	push   %eax
     83e:	ff 75 f4             	push   -0xc(%ebp)
     841:	e8 83 fc ff ff       	call   4c9 <listcmd>
     846:	83 c4 10             	add    $0x10,%esp
     849:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     84f:	c9                   	leave
     850:	c3                   	ret

00000851 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     851:	55                   	push   %ebp
     852:	89 e5                	mov    %esp,%ebp
     854:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     857:	83 ec 08             	sub    $0x8,%esp
     85a:	ff 75 0c             	push   0xc(%ebp)
     85d:	ff 75 08             	push   0x8(%ebp)
     860:	e8 f0 01 00 00       	call   a55 <parseexec>
     865:	83 c4 10             	add    $0x10,%esp
     868:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     86b:	83 ec 04             	sub    $0x4,%esp
     86e:	68 91 14 00 00       	push   $0x1491
     873:	ff 75 0c             	push   0xc(%ebp)
     876:	ff 75 08             	push   0x8(%ebp)
     879:	e8 22 fe ff ff       	call   6a0 <peek>
     87e:	83 c4 10             	add    $0x10,%esp
     881:	85 c0                	test   %eax,%eax
     883:	74 35                	je     8ba <parsepipe+0x69>
    gettoken(ps, es, 0, 0);
     885:	6a 00                	push   $0x0
     887:	6a 00                	push   $0x0
     889:	ff 75 0c             	push   0xc(%ebp)
     88c:	ff 75 08             	push   0x8(%ebp)
     88f:	e8 bc fc ff ff       	call   550 <gettoken>
     894:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     897:	83 ec 08             	sub    $0x8,%esp
     89a:	ff 75 0c             	push   0xc(%ebp)
     89d:	ff 75 08             	push   0x8(%ebp)
     8a0:	e8 ac ff ff ff       	call   851 <parsepipe>
     8a5:	83 c4 10             	add    $0x10,%esp
     8a8:	83 ec 08             	sub    $0x8,%esp
     8ab:	50                   	push   %eax
     8ac:	ff 75 f4             	push   -0xc(%ebp)
     8af:	e8 cd fb ff ff       	call   481 <pipecmd>
     8b4:	83 c4 10             	add    $0x10,%esp
     8b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8bd:	c9                   	leave
     8be:	c3                   	ret

000008bf <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     8bf:	55                   	push   %ebp
     8c0:	89 e5                	mov    %esp,%ebp
     8c2:	83 ec 18             	sub    $0x18,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     8c5:	e9 ba 00 00 00       	jmp    984 <parseredirs+0xc5>
    tok = gettoken(ps, es, 0, 0);
     8ca:	6a 00                	push   $0x0
     8cc:	6a 00                	push   $0x0
     8ce:	ff 75 10             	push   0x10(%ebp)
     8d1:	ff 75 0c             	push   0xc(%ebp)
     8d4:	e8 77 fc ff ff       	call   550 <gettoken>
     8d9:	83 c4 10             	add    $0x10,%esp
     8dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     8df:	8d 45 ec             	lea    -0x14(%ebp),%eax
     8e2:	50                   	push   %eax
     8e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
     8e6:	50                   	push   %eax
     8e7:	ff 75 10             	push   0x10(%ebp)
     8ea:	ff 75 0c             	push   0xc(%ebp)
     8ed:	e8 5e fc ff ff       	call   550 <gettoken>
     8f2:	83 c4 10             	add    $0x10,%esp
     8f5:	83 f8 61             	cmp    $0x61,%eax
     8f8:	74 10                	je     90a <parseredirs+0x4b>
      panic("missing file for redirection");
     8fa:	83 ec 0c             	sub    $0xc,%esp
     8fd:	68 93 14 00 00       	push   $0x1493
     902:	e8 98 fa ff ff       	call   39f <panic>
     907:	83 c4 10             	add    $0x10,%esp
    switch(tok){
     90a:	83 7d f4 3e          	cmpl   $0x3e,-0xc(%ebp)
     90e:	74 31                	je     941 <parseredirs+0x82>
     910:	83 7d f4 3e          	cmpl   $0x3e,-0xc(%ebp)
     914:	7f 6e                	jg     984 <parseredirs+0xc5>
     916:	83 7d f4 2b          	cmpl   $0x2b,-0xc(%ebp)
     91a:	74 47                	je     963 <parseredirs+0xa4>
     91c:	83 7d f4 3c          	cmpl   $0x3c,-0xc(%ebp)
     920:	75 62                	jne    984 <parseredirs+0xc5>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     922:	8b 55 ec             	mov    -0x14(%ebp),%edx
     925:	8b 45 f0             	mov    -0x10(%ebp),%eax
     928:	83 ec 0c             	sub    $0xc,%esp
     92b:	6a 00                	push   $0x0
     92d:	6a 00                	push   $0x0
     92f:	52                   	push   %edx
     930:	50                   	push   %eax
     931:	ff 75 08             	push   0x8(%ebp)
     934:	e8 e5 fa ff ff       	call   41e <redircmd>
     939:	83 c4 20             	add    $0x20,%esp
     93c:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     93f:	eb 43                	jmp    984 <parseredirs+0xc5>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     941:	8b 55 ec             	mov    -0x14(%ebp),%edx
     944:	8b 45 f0             	mov    -0x10(%ebp),%eax
     947:	83 ec 0c             	sub    $0xc,%esp
     94a:	6a 01                	push   $0x1
     94c:	68 01 02 00 00       	push   $0x201
     951:	52                   	push   %edx
     952:	50                   	push   %eax
     953:	ff 75 08             	push   0x8(%ebp)
     956:	e8 c3 fa ff ff       	call   41e <redircmd>
     95b:	83 c4 20             	add    $0x20,%esp
     95e:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     961:	eb 21                	jmp    984 <parseredirs+0xc5>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     963:	8b 55 ec             	mov    -0x14(%ebp),%edx
     966:	8b 45 f0             	mov    -0x10(%ebp),%eax
     969:	83 ec 0c             	sub    $0xc,%esp
     96c:	6a 01                	push   $0x1
     96e:	68 01 02 00 00       	push   $0x201
     973:	52                   	push   %edx
     974:	50                   	push   %eax
     975:	ff 75 08             	push   0x8(%ebp)
     978:	e8 a1 fa ff ff       	call   41e <redircmd>
     97d:	83 c4 20             	add    $0x20,%esp
     980:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     983:	90                   	nop
  while(peek(ps, es, "<>")){
     984:	83 ec 04             	sub    $0x4,%esp
     987:	68 b0 14 00 00       	push   $0x14b0
     98c:	ff 75 10             	push   0x10(%ebp)
     98f:	ff 75 0c             	push   0xc(%ebp)
     992:	e8 09 fd ff ff       	call   6a0 <peek>
     997:	83 c4 10             	add    $0x10,%esp
     99a:	85 c0                	test   %eax,%eax
     99c:	0f 85 28 ff ff ff    	jne    8ca <parseredirs+0xb>
    }
  }
  return cmd;
     9a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9a5:	c9                   	leave
     9a6:	c3                   	ret

000009a7 <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     9a7:	55                   	push   %ebp
     9a8:	89 e5                	mov    %esp,%ebp
     9aa:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     9ad:	83 ec 04             	sub    $0x4,%esp
     9b0:	68 b3 14 00 00       	push   $0x14b3
     9b5:	ff 75 0c             	push   0xc(%ebp)
     9b8:	ff 75 08             	push   0x8(%ebp)
     9bb:	e8 e0 fc ff ff       	call   6a0 <peek>
     9c0:	83 c4 10             	add    $0x10,%esp
     9c3:	85 c0                	test   %eax,%eax
     9c5:	75 10                	jne    9d7 <parseblock+0x30>
    panic("parseblock");
     9c7:	83 ec 0c             	sub    $0xc,%esp
     9ca:	68 b5 14 00 00       	push   $0x14b5
     9cf:	e8 cb f9 ff ff       	call   39f <panic>
     9d4:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     9d7:	6a 00                	push   $0x0
     9d9:	6a 00                	push   $0x0
     9db:	ff 75 0c             	push   0xc(%ebp)
     9de:	ff 75 08             	push   0x8(%ebp)
     9e1:	e8 6a fb ff ff       	call   550 <gettoken>
     9e6:	83 c4 10             	add    $0x10,%esp
  cmd = parseline(ps, es);
     9e9:	83 ec 08             	sub    $0x8,%esp
     9ec:	ff 75 0c             	push   0xc(%ebp)
     9ef:	ff 75 08             	push   0x8(%ebp)
     9f2:	e8 ad fd ff ff       	call   7a4 <parseline>
     9f7:	83 c4 10             	add    $0x10,%esp
     9fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     9fd:	83 ec 04             	sub    $0x4,%esp
     a00:	68 c0 14 00 00       	push   $0x14c0
     a05:	ff 75 0c             	push   0xc(%ebp)
     a08:	ff 75 08             	push   0x8(%ebp)
     a0b:	e8 90 fc ff ff       	call   6a0 <peek>
     a10:	83 c4 10             	add    $0x10,%esp
     a13:	85 c0                	test   %eax,%eax
     a15:	75 10                	jne    a27 <parseblock+0x80>
    panic("syntax - missing )");
     a17:	83 ec 0c             	sub    $0xc,%esp
     a1a:	68 c2 14 00 00       	push   $0x14c2
     a1f:	e8 7b f9 ff ff       	call   39f <panic>
     a24:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     a27:	6a 00                	push   $0x0
     a29:	6a 00                	push   $0x0
     a2b:	ff 75 0c             	push   0xc(%ebp)
     a2e:	ff 75 08             	push   0x8(%ebp)
     a31:	e8 1a fb ff ff       	call   550 <gettoken>
     a36:	83 c4 10             	add    $0x10,%esp
  cmd = parseredirs(cmd, ps, es);
     a39:	83 ec 04             	sub    $0x4,%esp
     a3c:	ff 75 0c             	push   0xc(%ebp)
     a3f:	ff 75 08             	push   0x8(%ebp)
     a42:	ff 75 f4             	push   -0xc(%ebp)
     a45:	e8 75 fe ff ff       	call   8bf <parseredirs>
     a4a:	83 c4 10             	add    $0x10,%esp
     a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     a53:	c9                   	leave
     a54:	c3                   	ret

00000a55 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     a55:	55                   	push   %ebp
     a56:	89 e5                	mov    %esp,%ebp
     a58:	83 ec 28             	sub    $0x28,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     a5b:	83 ec 04             	sub    $0x4,%esp
     a5e:	68 b3 14 00 00       	push   $0x14b3
     a63:	ff 75 0c             	push   0xc(%ebp)
     a66:	ff 75 08             	push   0x8(%ebp)
     a69:	e8 32 fc ff ff       	call   6a0 <peek>
     a6e:	83 c4 10             	add    $0x10,%esp
     a71:	85 c0                	test   %eax,%eax
     a73:	74 16                	je     a8b <parseexec+0x36>
    return parseblock(ps, es);
     a75:	83 ec 08             	sub    $0x8,%esp
     a78:	ff 75 0c             	push   0xc(%ebp)
     a7b:	ff 75 08             	push   0x8(%ebp)
     a7e:	e8 24 ff ff ff       	call   9a7 <parseblock>
     a83:	83 c4 10             	add    $0x10,%esp
     a86:	e9 fb 00 00 00       	jmp    b86 <parseexec+0x131>

  ret = execcmd();
     a8b:	e8 58 f9 ff ff       	call   3e8 <execcmd>
     a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a96:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     a99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     aa0:	83 ec 04             	sub    $0x4,%esp
     aa3:	ff 75 0c             	push   0xc(%ebp)
     aa6:	ff 75 08             	push   0x8(%ebp)
     aa9:	ff 75 f0             	push   -0x10(%ebp)
     aac:	e8 0e fe ff ff       	call   8bf <parseredirs>
     ab1:	83 c4 10             	add    $0x10,%esp
     ab4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     ab7:	e9 87 00 00 00       	jmp    b43 <parseexec+0xee>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     abc:	8d 45 e0             	lea    -0x20(%ebp),%eax
     abf:	50                   	push   %eax
     ac0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     ac3:	50                   	push   %eax
     ac4:	ff 75 0c             	push   0xc(%ebp)
     ac7:	ff 75 08             	push   0x8(%ebp)
     aca:	e8 81 fa ff ff       	call   550 <gettoken>
     acf:	83 c4 10             	add    $0x10,%esp
     ad2:	89 45 e8             	mov    %eax,-0x18(%ebp)
     ad5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     ad9:	0f 84 84 00 00 00    	je     b63 <parseexec+0x10e>
      break;
    if(tok != 'a')
     adf:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     ae3:	74 10                	je     af5 <parseexec+0xa0>
      panic("syntax");
     ae5:	83 ec 0c             	sub    $0xc,%esp
     ae8:	68 86 14 00 00       	push   $0x1486
     aed:	e8 ad f8 ff ff       	call   39f <panic>
     af2:	83 c4 10             	add    $0x10,%esp
    cmd->argv[argc] = q;
     af5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
     afb:	8b 55 f4             	mov    -0xc(%ebp),%edx
     afe:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     b02:	8b 55 e0             	mov    -0x20(%ebp),%edx
     b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b08:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     b0b:	83 c1 08             	add    $0x8,%ecx
     b0e:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     b12:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     b16:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     b1a:	7e 10                	jle    b2c <parseexec+0xd7>
      panic("too many args");
     b1c:	83 ec 0c             	sub    $0xc,%esp
     b1f:	68 d5 14 00 00       	push   $0x14d5
     b24:	e8 76 f8 ff ff       	call   39f <panic>
     b29:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
     b2c:	83 ec 04             	sub    $0x4,%esp
     b2f:	ff 75 0c             	push   0xc(%ebp)
     b32:	ff 75 08             	push   0x8(%ebp)
     b35:	ff 75 f0             	push   -0x10(%ebp)
     b38:	e8 82 fd ff ff       	call   8bf <parseredirs>
     b3d:	83 c4 10             	add    $0x10,%esp
     b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     b43:	83 ec 04             	sub    $0x4,%esp
     b46:	68 e3 14 00 00       	push   $0x14e3
     b4b:	ff 75 0c             	push   0xc(%ebp)
     b4e:	ff 75 08             	push   0x8(%ebp)
     b51:	e8 4a fb ff ff       	call   6a0 <peek>
     b56:	83 c4 10             	add    $0x10,%esp
     b59:	85 c0                	test   %eax,%eax
     b5b:	0f 84 5b ff ff ff    	je     abc <parseexec+0x67>
     b61:	eb 01                	jmp    b64 <parseexec+0x10f>
      break;
     b63:	90                   	nop
  }
  cmd->argv[argc] = 0;
     b64:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b67:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b6a:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     b71:	00 
  cmd->eargv[argc] = 0;
     b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b75:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b78:	83 c2 08             	add    $0x8,%edx
     b7b:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     b82:	00 
  return ret;
     b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     b86:	c9                   	leave
     b87:	c3                   	ret

00000b88 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     b88:	55                   	push   %ebp
     b89:	89 e5                	mov    %esp,%ebp
     b8b:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     b8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     b92:	75 0a                	jne    b9e <nulterminate+0x16>
    return 0;
     b94:	b8 00 00 00 00       	mov    $0x0,%eax
     b99:	e9 e4 00 00 00       	jmp    c82 <nulterminate+0xfa>

  switch(cmd->type){
     b9e:	8b 45 08             	mov    0x8(%ebp),%eax
     ba1:	8b 00                	mov    (%eax),%eax
     ba3:	83 f8 05             	cmp    $0x5,%eax
     ba6:	0f 87 d3 00 00 00    	ja     c7f <nulterminate+0xf7>
     bac:	8b 04 85 e8 14 00 00 	mov    0x14e8(,%eax,4),%eax
     bb3:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     bb5:	8b 45 08             	mov    0x8(%ebp),%eax
     bb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     bbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     bc2:	eb 14                	jmp    bd8 <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     bc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
     bc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bca:	83 c2 08             	add    $0x8,%edx
     bcd:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     bd1:	c6 00 00             	movb   $0x0,(%eax)
    for(i=0; ecmd->argv[i]; i++)
     bd4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     bd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
     bdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bde:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     be2:	85 c0                	test   %eax,%eax
     be4:	75 de                	jne    bc4 <nulterminate+0x3c>
    break;
     be6:	e9 94 00 00 00       	jmp    c7f <nulterminate+0xf7>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     beb:	8b 45 08             	mov    0x8(%ebp),%eax
     bee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(rcmd->cmd);
     bf1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bf4:	8b 40 04             	mov    0x4(%eax),%eax
     bf7:	83 ec 0c             	sub    $0xc,%esp
     bfa:	50                   	push   %eax
     bfb:	e8 88 ff ff ff       	call   b88 <nulterminate>
     c00:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     c03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c06:	8b 40 0c             	mov    0xc(%eax),%eax
     c09:	c6 00 00             	movb   $0x0,(%eax)
    break;
     c0c:	eb 71                	jmp    c7f <nulterminate+0xf7>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     c0e:	8b 45 08             	mov    0x8(%ebp),%eax
     c11:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     c14:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c17:	8b 40 04             	mov    0x4(%eax),%eax
     c1a:	83 ec 0c             	sub    $0xc,%esp
     c1d:	50                   	push   %eax
     c1e:	e8 65 ff ff ff       	call   b88 <nulterminate>
     c23:	83 c4 10             	add    $0x10,%esp
    nulterminate(pcmd->right);
     c26:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c29:	8b 40 08             	mov    0x8(%eax),%eax
     c2c:	83 ec 0c             	sub    $0xc,%esp
     c2f:	50                   	push   %eax
     c30:	e8 53 ff ff ff       	call   b88 <nulterminate>
     c35:	83 c4 10             	add    $0x10,%esp
    break;
     c38:	eb 45                	jmp    c7f <nulterminate+0xf7>

  case LIST:
    lcmd = (struct listcmd*)cmd;
     c3a:	8b 45 08             	mov    0x8(%ebp),%eax
     c3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(lcmd->left);
     c40:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c43:	8b 40 04             	mov    0x4(%eax),%eax
     c46:	83 ec 0c             	sub    $0xc,%esp
     c49:	50                   	push   %eax
     c4a:	e8 39 ff ff ff       	call   b88 <nulterminate>
     c4f:	83 c4 10             	add    $0x10,%esp
    nulterminate(lcmd->right);
     c52:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c55:	8b 40 08             	mov    0x8(%eax),%eax
     c58:	83 ec 0c             	sub    $0xc,%esp
     c5b:	50                   	push   %eax
     c5c:	e8 27 ff ff ff       	call   b88 <nulterminate>
     c61:	83 c4 10             	add    $0x10,%esp
    break;
     c64:	eb 19                	jmp    c7f <nulterminate+0xf7>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     c66:	8b 45 08             	mov    0x8(%ebp),%eax
     c69:	89 45 f0             	mov    %eax,-0x10(%ebp)
    nulterminate(bcmd->cmd);
     c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c6f:	8b 40 04             	mov    0x4(%eax),%eax
     c72:	83 ec 0c             	sub    $0xc,%esp
     c75:	50                   	push   %eax
     c76:	e8 0d ff ff ff       	call   b88 <nulterminate>
     c7b:	83 c4 10             	add    $0x10,%esp
    break;
     c7e:	90                   	nop
  }
  return cmd;
     c7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c82:	c9                   	leave
     c83:	c3                   	ret

00000c84 <stosb>:
  stosb(dst, c, n);
  return dst;
}

char*
strchr(const char *s, char c)
     c84:	55                   	push   %ebp
     c85:	89 e5                	mov    %esp,%ebp
     c87:	57                   	push   %edi
     c88:	53                   	push   %ebx
{
     c89:	8b 4d 08             	mov    0x8(%ebp),%ecx
     c8c:	8b 55 10             	mov    0x10(%ebp),%edx
     c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
     c92:	89 cb                	mov    %ecx,%ebx
     c94:	89 df                	mov    %ebx,%edi
     c96:	89 d1                	mov    %edx,%ecx
     c98:	fc                   	cld
     c99:	f3 aa                	rep stos %al,%es:(%edi)
     c9b:	89 ca                	mov    %ecx,%edx
     c9d:	89 fb                	mov    %edi,%ebx
     c9f:	89 5d 08             	mov    %ebx,0x8(%ebp)
     ca2:	89 55 10             	mov    %edx,0x10(%ebp)
  for(; *s; s++)
    if(*s == c)
      return (char*)s;
  return 0;
     ca5:	90                   	nop
     ca6:	5b                   	pop    %ebx
     ca7:	5f                   	pop    %edi
     ca8:	5d                   	pop    %ebp
     ca9:	c3                   	ret

00000caa <strcpy>:
{
     caa:	55                   	push   %ebp
     cab:	89 e5                	mov    %esp,%ebp
     cad:	83 ec 10             	sub    $0x10,%esp
  os = s;
     cb0:	8b 45 08             	mov    0x8(%ebp),%eax
     cb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     cb6:	90                   	nop
     cb7:	8b 55 0c             	mov    0xc(%ebp),%edx
     cba:	8d 42 01             	lea    0x1(%edx),%eax
     cbd:	89 45 0c             	mov    %eax,0xc(%ebp)
     cc0:	8b 45 08             	mov    0x8(%ebp),%eax
     cc3:	8d 48 01             	lea    0x1(%eax),%ecx
     cc6:	89 4d 08             	mov    %ecx,0x8(%ebp)
     cc9:	0f b6 12             	movzbl (%edx),%edx
     ccc:	88 10                	mov    %dl,(%eax)
     cce:	0f b6 00             	movzbl (%eax),%eax
     cd1:	84 c0                	test   %al,%al
     cd3:	75 e2                	jne    cb7 <strcpy+0xd>
  return os;
     cd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     cd8:	c9                   	leave
     cd9:	c3                   	ret

00000cda <strcmp>:
{
     cda:	55                   	push   %ebp
     cdb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     cdd:	eb 08                	jmp    ce7 <strcmp+0xd>
    p++, q++;
     cdf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     ce3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
     ce7:	8b 45 08             	mov    0x8(%ebp),%eax
     cea:	0f b6 00             	movzbl (%eax),%eax
     ced:	84 c0                	test   %al,%al
     cef:	74 10                	je     d01 <strcmp+0x27>
     cf1:	8b 45 08             	mov    0x8(%ebp),%eax
     cf4:	0f b6 10             	movzbl (%eax),%edx
     cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
     cfa:	0f b6 00             	movzbl (%eax),%eax
     cfd:	38 c2                	cmp    %al,%dl
     cff:	74 de                	je     cdf <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
     d01:	8b 45 08             	mov    0x8(%ebp),%eax
     d04:	0f b6 00             	movzbl (%eax),%eax
     d07:	0f b6 d0             	movzbl %al,%edx
     d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
     d0d:	0f b6 00             	movzbl (%eax),%eax
     d10:	0f b6 c0             	movzbl %al,%eax
     d13:	29 c2                	sub    %eax,%edx
     d15:	89 d0                	mov    %edx,%eax
}
     d17:	5d                   	pop    %ebp
     d18:	c3                   	ret

00000d19 <strlen>:
{
     d19:	55                   	push   %ebp
     d1a:	89 e5                	mov    %esp,%ebp
     d1c:	83 ec 10             	sub    $0x10,%esp
  for(n = 0; s[n]; n++)
     d1f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     d26:	eb 04                	jmp    d2c <strlen+0x13>
     d28:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     d2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
     d2f:	8b 45 08             	mov    0x8(%ebp),%eax
     d32:	01 d0                	add    %edx,%eax
     d34:	0f b6 00             	movzbl (%eax),%eax
     d37:	84 c0                	test   %al,%al
     d39:	75 ed                	jne    d28 <strlen+0xf>
  return n;
     d3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d3e:	c9                   	leave
     d3f:	c3                   	ret

00000d40 <memset>:
{
     d40:	55                   	push   %ebp
     d41:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
     d43:	8b 45 10             	mov    0x10(%ebp),%eax
     d46:	50                   	push   %eax
     d47:	ff 75 0c             	push   0xc(%ebp)
     d4a:	ff 75 08             	push   0x8(%ebp)
     d4d:	e8 32 ff ff ff       	call   c84 <stosb>
     d52:	83 c4 0c             	add    $0xc,%esp
  return dst;
     d55:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d58:	c9                   	leave
     d59:	c3                   	ret

00000d5a <strchr>:
{
     d5a:	55                   	push   %ebp
     d5b:	89 e5                	mov    %esp,%ebp
     d5d:	83 ec 04             	sub    $0x4,%esp
     d60:	8b 45 0c             	mov    0xc(%ebp),%eax
     d63:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     d66:	eb 14                	jmp    d7c <strchr+0x22>
    if(*s == c)
     d68:	8b 45 08             	mov    0x8(%ebp),%eax
     d6b:	0f b6 00             	movzbl (%eax),%eax
     d6e:	38 45 fc             	cmp    %al,-0x4(%ebp)
     d71:	75 05                	jne    d78 <strchr+0x1e>
      return (char*)s;
     d73:	8b 45 08             	mov    0x8(%ebp),%eax
     d76:	eb 13                	jmp    d8b <strchr+0x31>
  for(; *s; s++)
     d78:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d7c:	8b 45 08             	mov    0x8(%ebp),%eax
     d7f:	0f b6 00             	movzbl (%eax),%eax
     d82:	84 c0                	test   %al,%al
     d84:	75 e2                	jne    d68 <strchr+0xe>
  return 0;
     d86:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d8b:	c9                   	leave
     d8c:	c3                   	ret

00000d8d <gets>:

char*
gets(char *buf, int max)
{
     d8d:	55                   	push   %ebp
     d8e:	89 e5                	mov    %esp,%ebp
     d90:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d9a:	eb 42                	jmp    dde <gets+0x51>
    cc = read(0, &c, 1);
     d9c:	83 ec 04             	sub    $0x4,%esp
     d9f:	6a 01                	push   $0x1
     da1:	8d 45 ef             	lea    -0x11(%ebp),%eax
     da4:	50                   	push   %eax
     da5:	6a 00                	push   $0x0
     da7:	e8 47 01 00 00       	call   ef3 <read>
     dac:	83 c4 10             	add    $0x10,%esp
     daf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     db2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     db6:	7e 33                	jle    deb <gets+0x5e>
      break;
    buf[i++] = c;
     db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dbb:	8d 50 01             	lea    0x1(%eax),%edx
     dbe:	89 55 f4             	mov    %edx,-0xc(%ebp)
     dc1:	89 c2                	mov    %eax,%edx
     dc3:	8b 45 08             	mov    0x8(%ebp),%eax
     dc6:	01 c2                	add    %eax,%edx
     dc8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     dcc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     dce:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     dd2:	3c 0a                	cmp    $0xa,%al
     dd4:	74 16                	je     dec <gets+0x5f>
     dd6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     dda:	3c 0d                	cmp    $0xd,%al
     ddc:	74 0e                	je     dec <gets+0x5f>
  for(i=0; i+1 < max; ){
     dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
     de1:	83 c0 01             	add    $0x1,%eax
     de4:	39 45 0c             	cmp    %eax,0xc(%ebp)
     de7:	7f b3                	jg     d9c <gets+0xf>
     de9:	eb 01                	jmp    dec <gets+0x5f>
      break;
     deb:	90                   	nop
      break;
  }
  buf[i] = '\0';
     dec:	8b 55 f4             	mov    -0xc(%ebp),%edx
     def:	8b 45 08             	mov    0x8(%ebp),%eax
     df2:	01 d0                	add    %edx,%eax
     df4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     df7:	8b 45 08             	mov    0x8(%ebp),%eax
}
     dfa:	c9                   	leave
     dfb:	c3                   	ret

00000dfc <stat>:

int
stat(const char *n, struct stat *st)
{
     dfc:	55                   	push   %ebp
     dfd:	89 e5                	mov    %esp,%ebp
     dff:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e02:	83 ec 08             	sub    $0x8,%esp
     e05:	6a 00                	push   $0x0
     e07:	ff 75 08             	push   0x8(%ebp)
     e0a:	e8 0c 01 00 00       	call   f1b <open>
     e0f:	83 c4 10             	add    $0x10,%esp
     e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     e15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e19:	79 07                	jns    e22 <stat+0x26>
    return -1;
     e1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e20:	eb 25                	jmp    e47 <stat+0x4b>
  r = fstat(fd, st);
     e22:	83 ec 08             	sub    $0x8,%esp
     e25:	ff 75 0c             	push   0xc(%ebp)
     e28:	ff 75 f4             	push   -0xc(%ebp)
     e2b:	e8 03 01 00 00       	call   f33 <fstat>
     e30:	83 c4 10             	add    $0x10,%esp
     e33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     e36:	83 ec 0c             	sub    $0xc,%esp
     e39:	ff 75 f4             	push   -0xc(%ebp)
     e3c:	e8 c2 00 00 00       	call   f03 <close>
     e41:	83 c4 10             	add    $0x10,%esp
  return r;
     e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     e47:	c9                   	leave
     e48:	c3                   	ret

00000e49 <atoi>:

int
atoi(const char *s)
{
     e49:	55                   	push   %ebp
     e4a:	89 e5                	mov    %esp,%ebp
     e4c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     e4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     e56:	eb 25                	jmp    e7d <atoi+0x34>
    n = n*10 + *s++ - '0';
     e58:	8b 55 fc             	mov    -0x4(%ebp),%edx
     e5b:	89 d0                	mov    %edx,%eax
     e5d:	c1 e0 02             	shl    $0x2,%eax
     e60:	01 d0                	add    %edx,%eax
     e62:	01 c0                	add    %eax,%eax
     e64:	89 c1                	mov    %eax,%ecx
     e66:	8b 45 08             	mov    0x8(%ebp),%eax
     e69:	8d 50 01             	lea    0x1(%eax),%edx
     e6c:	89 55 08             	mov    %edx,0x8(%ebp)
     e6f:	0f b6 00             	movzbl (%eax),%eax
     e72:	0f be c0             	movsbl %al,%eax
     e75:	01 c8                	add    %ecx,%eax
     e77:	83 e8 30             	sub    $0x30,%eax
     e7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     e7d:	8b 45 08             	mov    0x8(%ebp),%eax
     e80:	0f b6 00             	movzbl (%eax),%eax
     e83:	3c 2f                	cmp    $0x2f,%al
     e85:	7e 0a                	jle    e91 <atoi+0x48>
     e87:	8b 45 08             	mov    0x8(%ebp),%eax
     e8a:	0f b6 00             	movzbl (%eax),%eax
     e8d:	3c 39                	cmp    $0x39,%al
     e8f:	7e c7                	jle    e58 <atoi+0xf>
  return n;
     e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     e94:	c9                   	leave
     e95:	c3                   	ret

00000e96 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e96:	55                   	push   %ebp
     e97:	89 e5                	mov    %esp,%ebp
     e99:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
     e9c:	8b 45 08             	mov    0x8(%ebp),%eax
     e9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
     ea5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     ea8:	eb 17                	jmp    ec1 <memmove+0x2b>
    *dst++ = *src++;
     eaa:	8b 55 f8             	mov    -0x8(%ebp),%edx
     ead:	8d 42 01             	lea    0x1(%edx),%eax
     eb0:	89 45 f8             	mov    %eax,-0x8(%ebp)
     eb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
     eb6:	8d 48 01             	lea    0x1(%eax),%ecx
     eb9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
     ebc:	0f b6 12             	movzbl (%edx),%edx
     ebf:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
     ec1:	8b 45 10             	mov    0x10(%ebp),%eax
     ec4:	8d 50 ff             	lea    -0x1(%eax),%edx
     ec7:	89 55 10             	mov    %edx,0x10(%ebp)
     eca:	85 c0                	test   %eax,%eax
     ecc:	7f dc                	jg     eaa <memmove+0x14>
  return vdst;
     ece:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ed1:	c9                   	leave
     ed2:	c3                   	ret

00000ed3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     ed3:	b8 01 00 00 00       	mov    $0x1,%eax
     ed8:	cd 40                	int    $0x40
     eda:	c3                   	ret

00000edb <exit>:
SYSCALL(exit)
     edb:	b8 02 00 00 00       	mov    $0x2,%eax
     ee0:	cd 40                	int    $0x40
     ee2:	c3                   	ret

00000ee3 <wait>:
SYSCALL(wait)
     ee3:	b8 03 00 00 00       	mov    $0x3,%eax
     ee8:	cd 40                	int    $0x40
     eea:	c3                   	ret

00000eeb <pipe>:
SYSCALL(pipe)
     eeb:	b8 04 00 00 00       	mov    $0x4,%eax
     ef0:	cd 40                	int    $0x40
     ef2:	c3                   	ret

00000ef3 <read>:
SYSCALL(read)
     ef3:	b8 05 00 00 00       	mov    $0x5,%eax
     ef8:	cd 40                	int    $0x40
     efa:	c3                   	ret

00000efb <write>:
SYSCALL(write)
     efb:	b8 10 00 00 00       	mov    $0x10,%eax
     f00:	cd 40                	int    $0x40
     f02:	c3                   	ret

00000f03 <close>:
SYSCALL(close)
     f03:	b8 15 00 00 00       	mov    $0x15,%eax
     f08:	cd 40                	int    $0x40
     f0a:	c3                   	ret

00000f0b <kill>:
SYSCALL(kill)
     f0b:	b8 06 00 00 00       	mov    $0x6,%eax
     f10:	cd 40                	int    $0x40
     f12:	c3                   	ret

00000f13 <exec>:
SYSCALL(exec)
     f13:	b8 07 00 00 00       	mov    $0x7,%eax
     f18:	cd 40                	int    $0x40
     f1a:	c3                   	ret

00000f1b <open>:
SYSCALL(open)
     f1b:	b8 0f 00 00 00       	mov    $0xf,%eax
     f20:	cd 40                	int    $0x40
     f22:	c3                   	ret

00000f23 <mknod>:
SYSCALL(mknod)
     f23:	b8 11 00 00 00       	mov    $0x11,%eax
     f28:	cd 40                	int    $0x40
     f2a:	c3                   	ret

00000f2b <unlink>:
SYSCALL(unlink)
     f2b:	b8 12 00 00 00       	mov    $0x12,%eax
     f30:	cd 40                	int    $0x40
     f32:	c3                   	ret

00000f33 <fstat>:
SYSCALL(fstat)
     f33:	b8 08 00 00 00       	mov    $0x8,%eax
     f38:	cd 40                	int    $0x40
     f3a:	c3                   	ret

00000f3b <link>:
SYSCALL(link)
     f3b:	b8 13 00 00 00       	mov    $0x13,%eax
     f40:	cd 40                	int    $0x40
     f42:	c3                   	ret

00000f43 <mkdir>:
SYSCALL(mkdir)
     f43:	b8 14 00 00 00       	mov    $0x14,%eax
     f48:	cd 40                	int    $0x40
     f4a:	c3                   	ret

00000f4b <chdir>:
SYSCALL(chdir)
     f4b:	b8 09 00 00 00       	mov    $0x9,%eax
     f50:	cd 40                	int    $0x40
     f52:	c3                   	ret

00000f53 <dup>:
SYSCALL(dup)
     f53:	b8 0a 00 00 00       	mov    $0xa,%eax
     f58:	cd 40                	int    $0x40
     f5a:	c3                   	ret

00000f5b <getpid>:
SYSCALL(getpid)
     f5b:	b8 0b 00 00 00       	mov    $0xb,%eax
     f60:	cd 40                	int    $0x40
     f62:	c3                   	ret

00000f63 <sbrk>:
SYSCALL(sbrk)
     f63:	b8 0c 00 00 00       	mov    $0xc,%eax
     f68:	cd 40                	int    $0x40
     f6a:	c3                   	ret

00000f6b <sleep>:
SYSCALL(sleep)
     f6b:	b8 0d 00 00 00       	mov    $0xd,%eax
     f70:	cd 40                	int    $0x40
     f72:	c3                   	ret

00000f73 <uptime>:
SYSCALL(uptime)
     f73:	b8 0e 00 00 00       	mov    $0xe,%eax
     f78:	cd 40                	int    $0x40
     f7a:	c3                   	ret

00000f7b <getNumFreePages>:
SYSCALL(getNumFreePages)
     f7b:	b8 16 00 00 00       	mov    $0x16,%eax
     f80:	cd 40                	int    $0x40
     f82:	c3                   	ret

00000f83 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     f83:	55                   	push   %ebp
     f84:	89 e5                	mov    %esp,%ebp
     f86:	83 ec 18             	sub    $0x18,%esp
     f89:	8b 45 0c             	mov    0xc(%ebp),%eax
     f8c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     f8f:	83 ec 04             	sub    $0x4,%esp
     f92:	6a 01                	push   $0x1
     f94:	8d 45 f4             	lea    -0xc(%ebp),%eax
     f97:	50                   	push   %eax
     f98:	ff 75 08             	push   0x8(%ebp)
     f9b:	e8 5b ff ff ff       	call   efb <write>
     fa0:	83 c4 10             	add    $0x10,%esp
}
     fa3:	90                   	nop
     fa4:	c9                   	leave
     fa5:	c3                   	ret

00000fa6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     fa6:	55                   	push   %ebp
     fa7:	89 e5                	mov    %esp,%ebp
     fa9:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     fac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     fb3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     fb7:	74 17                	je     fd0 <printint+0x2a>
     fb9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     fbd:	79 11                	jns    fd0 <printint+0x2a>
    neg = 1;
     fbf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
     fc9:	f7 d8                	neg    %eax
     fcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fce:	eb 06                	jmp    fd6 <printint+0x30>
  } else {
    x = xx;
     fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
     fd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     fd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     fdd:	8b 4d 10             	mov    0x10(%ebp),%ecx
     fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
     fe3:	ba 00 00 00 00       	mov    $0x0,%edx
     fe8:	f7 f1                	div    %ecx
     fea:	89 d1                	mov    %edx,%ecx
     fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fef:	8d 50 01             	lea    0x1(%eax),%edx
     ff2:	89 55 f4             	mov    %edx,-0xc(%ebp)
     ff5:	0f b6 91 98 19 00 00 	movzbl 0x1998(%ecx),%edx
     ffc:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
    1000:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1003:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1006:	ba 00 00 00 00       	mov    $0x0,%edx
    100b:	f7 f1                	div    %ecx
    100d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1010:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1014:	75 c7                	jne    fdd <printint+0x37>
  if(neg)
    1016:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    101a:	74 2d                	je     1049 <printint+0xa3>
    buf[i++] = '-';
    101c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    101f:	8d 50 01             	lea    0x1(%eax),%edx
    1022:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1025:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    102a:	eb 1d                	jmp    1049 <printint+0xa3>
    putc(fd, buf[i]);
    102c:	8d 55 dc             	lea    -0x24(%ebp),%edx
    102f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1032:	01 d0                	add    %edx,%eax
    1034:	0f b6 00             	movzbl (%eax),%eax
    1037:	0f be c0             	movsbl %al,%eax
    103a:	83 ec 08             	sub    $0x8,%esp
    103d:	50                   	push   %eax
    103e:	ff 75 08             	push   0x8(%ebp)
    1041:	e8 3d ff ff ff       	call   f83 <putc>
    1046:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
    1049:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    104d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1051:	79 d9                	jns    102c <printint+0x86>
}
    1053:	90                   	nop
    1054:	90                   	nop
    1055:	c9                   	leave
    1056:	c3                   	ret

00001057 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1057:	55                   	push   %ebp
    1058:	89 e5                	mov    %esp,%ebp
    105a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    105d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1064:	8d 45 0c             	lea    0xc(%ebp),%eax
    1067:	83 c0 04             	add    $0x4,%eax
    106a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    106d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1074:	e9 59 01 00 00       	jmp    11d2 <printf+0x17b>
    c = fmt[i] & 0xff;
    1079:	8b 55 0c             	mov    0xc(%ebp),%edx
    107c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    107f:	01 d0                	add    %edx,%eax
    1081:	0f b6 00             	movzbl (%eax),%eax
    1084:	0f be c0             	movsbl %al,%eax
    1087:	25 ff 00 00 00       	and    $0xff,%eax
    108c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    108f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1093:	75 2c                	jne    10c1 <printf+0x6a>
      if(c == '%'){
    1095:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1099:	75 0c                	jne    10a7 <printf+0x50>
        state = '%';
    109b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    10a2:	e9 27 01 00 00       	jmp    11ce <printf+0x177>
      } else {
        putc(fd, c);
    10a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10aa:	0f be c0             	movsbl %al,%eax
    10ad:	83 ec 08             	sub    $0x8,%esp
    10b0:	50                   	push   %eax
    10b1:	ff 75 08             	push   0x8(%ebp)
    10b4:	e8 ca fe ff ff       	call   f83 <putc>
    10b9:	83 c4 10             	add    $0x10,%esp
    10bc:	e9 0d 01 00 00       	jmp    11ce <printf+0x177>
      }
    } else if(state == '%'){
    10c1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    10c5:	0f 85 03 01 00 00    	jne    11ce <printf+0x177>
      if(c == 'd'){
    10cb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    10cf:	75 1e                	jne    10ef <printf+0x98>
        printint(fd, *ap, 10, 1);
    10d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10d4:	8b 00                	mov    (%eax),%eax
    10d6:	6a 01                	push   $0x1
    10d8:	6a 0a                	push   $0xa
    10da:	50                   	push   %eax
    10db:	ff 75 08             	push   0x8(%ebp)
    10de:	e8 c3 fe ff ff       	call   fa6 <printint>
    10e3:	83 c4 10             	add    $0x10,%esp
        ap++;
    10e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    10ea:	e9 d8 00 00 00       	jmp    11c7 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    10ef:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    10f3:	74 06                	je     10fb <printf+0xa4>
    10f5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    10f9:	75 1e                	jne    1119 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    10fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10fe:	8b 00                	mov    (%eax),%eax
    1100:	6a 00                	push   $0x0
    1102:	6a 10                	push   $0x10
    1104:	50                   	push   %eax
    1105:	ff 75 08             	push   0x8(%ebp)
    1108:	e8 99 fe ff ff       	call   fa6 <printint>
    110d:	83 c4 10             	add    $0x10,%esp
        ap++;
    1110:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1114:	e9 ae 00 00 00       	jmp    11c7 <printf+0x170>
      } else if(c == 's'){
    1119:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    111d:	75 43                	jne    1162 <printf+0x10b>
        s = (char*)*ap;
    111f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1122:	8b 00                	mov    (%eax),%eax
    1124:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1127:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    112b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    112f:	75 25                	jne    1156 <printf+0xff>
          s = "(null)";
    1131:	c7 45 f4 00 15 00 00 	movl   $0x1500,-0xc(%ebp)
        while(*s != 0){
    1138:	eb 1c                	jmp    1156 <printf+0xff>
          putc(fd, *s);
    113a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    113d:	0f b6 00             	movzbl (%eax),%eax
    1140:	0f be c0             	movsbl %al,%eax
    1143:	83 ec 08             	sub    $0x8,%esp
    1146:	50                   	push   %eax
    1147:	ff 75 08             	push   0x8(%ebp)
    114a:	e8 34 fe ff ff       	call   f83 <putc>
    114f:	83 c4 10             	add    $0x10,%esp
          s++;
    1152:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    1156:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1159:	0f b6 00             	movzbl (%eax),%eax
    115c:	84 c0                	test   %al,%al
    115e:	75 da                	jne    113a <printf+0xe3>
    1160:	eb 65                	jmp    11c7 <printf+0x170>
        }
      } else if(c == 'c'){
    1162:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1166:	75 1d                	jne    1185 <printf+0x12e>
        putc(fd, *ap);
    1168:	8b 45 e8             	mov    -0x18(%ebp),%eax
    116b:	8b 00                	mov    (%eax),%eax
    116d:	0f be c0             	movsbl %al,%eax
    1170:	83 ec 08             	sub    $0x8,%esp
    1173:	50                   	push   %eax
    1174:	ff 75 08             	push   0x8(%ebp)
    1177:	e8 07 fe ff ff       	call   f83 <putc>
    117c:	83 c4 10             	add    $0x10,%esp
        ap++;
    117f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1183:	eb 42                	jmp    11c7 <printf+0x170>
      } else if(c == '%'){
    1185:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1189:	75 17                	jne    11a2 <printf+0x14b>
        putc(fd, c);
    118b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    118e:	0f be c0             	movsbl %al,%eax
    1191:	83 ec 08             	sub    $0x8,%esp
    1194:	50                   	push   %eax
    1195:	ff 75 08             	push   0x8(%ebp)
    1198:	e8 e6 fd ff ff       	call   f83 <putc>
    119d:	83 c4 10             	add    $0x10,%esp
    11a0:	eb 25                	jmp    11c7 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    11a2:	83 ec 08             	sub    $0x8,%esp
    11a5:	6a 25                	push   $0x25
    11a7:	ff 75 08             	push   0x8(%ebp)
    11aa:	e8 d4 fd ff ff       	call   f83 <putc>
    11af:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    11b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11b5:	0f be c0             	movsbl %al,%eax
    11b8:	83 ec 08             	sub    $0x8,%esp
    11bb:	50                   	push   %eax
    11bc:	ff 75 08             	push   0x8(%ebp)
    11bf:	e8 bf fd ff ff       	call   f83 <putc>
    11c4:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    11c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    11ce:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    11d2:	8b 55 0c             	mov    0xc(%ebp),%edx
    11d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11d8:	01 d0                	add    %edx,%eax
    11da:	0f b6 00             	movzbl (%eax),%eax
    11dd:	84 c0                	test   %al,%al
    11df:	0f 85 94 fe ff ff    	jne    1079 <printf+0x22>
    }
  }
}
    11e5:	90                   	nop
    11e6:	90                   	nop
    11e7:	c9                   	leave
    11e8:	c3                   	ret

000011e9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11e9:	55                   	push   %ebp
    11ea:	89 e5                	mov    %esp,%ebp
    11ec:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11ef:	8b 45 08             	mov    0x8(%ebp),%eax
    11f2:	83 e8 08             	sub    $0x8,%eax
    11f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11f8:	a1 2c 1a 00 00       	mov    0x1a2c,%eax
    11fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1200:	eb 24                	jmp    1226 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1202:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1205:	8b 00                	mov    (%eax),%eax
    1207:	39 45 fc             	cmp    %eax,-0x4(%ebp)
    120a:	72 12                	jb     121e <free+0x35>
    120c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    120f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
    1212:	72 24                	jb     1238 <free+0x4f>
    1214:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1217:	8b 00                	mov    (%eax),%eax
    1219:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    121c:	72 1a                	jb     1238 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    121e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1221:	8b 00                	mov    (%eax),%eax
    1223:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1226:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1229:	39 45 fc             	cmp    %eax,-0x4(%ebp)
    122c:	73 d4                	jae    1202 <free+0x19>
    122e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1231:	8b 00                	mov    (%eax),%eax
    1233:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    1236:	73 ca                	jae    1202 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1238:	8b 45 f8             	mov    -0x8(%ebp),%eax
    123b:	8b 40 04             	mov    0x4(%eax),%eax
    123e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1245:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1248:	01 c2                	add    %eax,%edx
    124a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    124d:	8b 00                	mov    (%eax),%eax
    124f:	39 c2                	cmp    %eax,%edx
    1251:	75 24                	jne    1277 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1253:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1256:	8b 50 04             	mov    0x4(%eax),%edx
    1259:	8b 45 fc             	mov    -0x4(%ebp),%eax
    125c:	8b 00                	mov    (%eax),%eax
    125e:	8b 40 04             	mov    0x4(%eax),%eax
    1261:	01 c2                	add    %eax,%edx
    1263:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1266:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1269:	8b 45 fc             	mov    -0x4(%ebp),%eax
    126c:	8b 00                	mov    (%eax),%eax
    126e:	8b 10                	mov    (%eax),%edx
    1270:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1273:	89 10                	mov    %edx,(%eax)
    1275:	eb 0a                	jmp    1281 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1277:	8b 45 fc             	mov    -0x4(%ebp),%eax
    127a:	8b 10                	mov    (%eax),%edx
    127c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    127f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1281:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1284:	8b 40 04             	mov    0x4(%eax),%eax
    1287:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    128e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1291:	01 d0                	add    %edx,%eax
    1293:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    1296:	75 20                	jne    12b8 <free+0xcf>
    p->s.size += bp->s.size;
    1298:	8b 45 fc             	mov    -0x4(%ebp),%eax
    129b:	8b 50 04             	mov    0x4(%eax),%edx
    129e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12a1:	8b 40 04             	mov    0x4(%eax),%eax
    12a4:	01 c2                	add    %eax,%edx
    12a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12a9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    12ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12af:	8b 10                	mov    (%eax),%edx
    12b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b4:	89 10                	mov    %edx,(%eax)
    12b6:	eb 08                	jmp    12c0 <free+0xd7>
  } else
    p->s.ptr = bp;
    12b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12be:	89 10                	mov    %edx,(%eax)
  freep = p;
    12c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12c3:	a3 2c 1a 00 00       	mov    %eax,0x1a2c
}
    12c8:	90                   	nop
    12c9:	c9                   	leave
    12ca:	c3                   	ret

000012cb <morecore>:

static Header*
morecore(uint nu)
{
    12cb:	55                   	push   %ebp
    12cc:	89 e5                	mov    %esp,%ebp
    12ce:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    12d1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    12d8:	77 07                	ja     12e1 <morecore+0x16>
    nu = 4096;
    12da:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    12e1:	8b 45 08             	mov    0x8(%ebp),%eax
    12e4:	c1 e0 03             	shl    $0x3,%eax
    12e7:	83 ec 0c             	sub    $0xc,%esp
    12ea:	50                   	push   %eax
    12eb:	e8 73 fc ff ff       	call   f63 <sbrk>
    12f0:	83 c4 10             	add    $0x10,%esp
    12f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    12f6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    12fa:	75 07                	jne    1303 <morecore+0x38>
    return 0;
    12fc:	b8 00 00 00 00       	mov    $0x0,%eax
    1301:	eb 26                	jmp    1329 <morecore+0x5e>
  hp = (Header*)p;
    1303:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1306:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1309:	8b 45 f0             	mov    -0x10(%ebp),%eax
    130c:	8b 55 08             	mov    0x8(%ebp),%edx
    130f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1312:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1315:	83 c0 08             	add    $0x8,%eax
    1318:	83 ec 0c             	sub    $0xc,%esp
    131b:	50                   	push   %eax
    131c:	e8 c8 fe ff ff       	call   11e9 <free>
    1321:	83 c4 10             	add    $0x10,%esp
  return freep;
    1324:	a1 2c 1a 00 00       	mov    0x1a2c,%eax
}
    1329:	c9                   	leave
    132a:	c3                   	ret

0000132b <malloc>:

void*
malloc(uint nbytes)
{
    132b:	55                   	push   %ebp
    132c:	89 e5                	mov    %esp,%ebp
    132e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1331:	8b 45 08             	mov    0x8(%ebp),%eax
    1334:	83 c0 07             	add    $0x7,%eax
    1337:	c1 e8 03             	shr    $0x3,%eax
    133a:	83 c0 01             	add    $0x1,%eax
    133d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1340:	a1 2c 1a 00 00       	mov    0x1a2c,%eax
    1345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1348:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    134c:	75 23                	jne    1371 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    134e:	c7 45 f0 24 1a 00 00 	movl   $0x1a24,-0x10(%ebp)
    1355:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1358:	a3 2c 1a 00 00       	mov    %eax,0x1a2c
    135d:	a1 2c 1a 00 00       	mov    0x1a2c,%eax
    1362:	a3 24 1a 00 00       	mov    %eax,0x1a24
    base.s.size = 0;
    1367:	c7 05 28 1a 00 00 00 	movl   $0x0,0x1a28
    136e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1371:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1374:	8b 00                	mov    (%eax),%eax
    1376:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1379:	8b 45 f4             	mov    -0xc(%ebp),%eax
    137c:	8b 40 04             	mov    0x4(%eax),%eax
    137f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1382:	72 4d                	jb     13d1 <malloc+0xa6>
      if(p->s.size == nunits)
    1384:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1387:	8b 40 04             	mov    0x4(%eax),%eax
    138a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    138d:	75 0c                	jne    139b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    138f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1392:	8b 10                	mov    (%eax),%edx
    1394:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1397:	89 10                	mov    %edx,(%eax)
    1399:	eb 26                	jmp    13c1 <malloc+0x96>
      else {
        p->s.size -= nunits;
    139b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    139e:	8b 40 04             	mov    0x4(%eax),%eax
    13a1:	2b 45 ec             	sub    -0x14(%ebp),%eax
    13a4:	89 c2                	mov    %eax,%edx
    13a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13a9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    13ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13af:	8b 40 04             	mov    0x4(%eax),%eax
    13b2:	c1 e0 03             	shl    $0x3,%eax
    13b5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    13b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
    13be:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    13c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13c4:	a3 2c 1a 00 00       	mov    %eax,0x1a2c
      return (void*)(p + 1);
    13c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13cc:	83 c0 08             	add    $0x8,%eax
    13cf:	eb 3b                	jmp    140c <malloc+0xe1>
    }
    if(p == freep)
    13d1:	a1 2c 1a 00 00       	mov    0x1a2c,%eax
    13d6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    13d9:	75 1e                	jne    13f9 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    13db:	83 ec 0c             	sub    $0xc,%esp
    13de:	ff 75 ec             	push   -0x14(%ebp)
    13e1:	e8 e5 fe ff ff       	call   12cb <morecore>
    13e6:	83 c4 10             	add    $0x10,%esp
    13e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    13f0:	75 07                	jne    13f9 <malloc+0xce>
        return 0;
    13f2:	b8 00 00 00 00       	mov    $0x0,%eax
    13f7:	eb 13                	jmp    140c <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    13ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1402:	8b 00                	mov    (%eax),%eax
    1404:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1407:	e9 6d ff ff ff       	jmp    1379 <malloc+0x4e>
  }
}
    140c:	c9                   	leave
    140d:	c3                   	ret
