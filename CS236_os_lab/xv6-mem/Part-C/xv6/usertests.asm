
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "iput test\n");
       6:	a1 80 64 00 00       	mov    0x6480,%eax
       b:	83 ec 08             	sub    $0x8,%esp
       e:	68 42 45 00 00       	push   $0x4542
      13:	50                   	push   %eax
      14:	e8 5c 41 00 00       	call   4175 <printf>
      19:	83 c4 10             	add    $0x10,%esp

  if(mkdir("iputdir") < 0){
      1c:	83 ec 0c             	sub    $0xc,%esp
      1f:	68 4d 45 00 00       	push   $0x454d
      24:	e8 38 40 00 00       	call   4061 <mkdir>
      29:	83 c4 10             	add    $0x10,%esp
      2c:	85 c0                	test   %eax,%eax
      2e:	79 1b                	jns    4b <iputtest+0x4b>
    printf(stdout, "mkdir failed\n");
      30:	a1 80 64 00 00       	mov    0x6480,%eax
      35:	83 ec 08             	sub    $0x8,%esp
      38:	68 55 45 00 00       	push   $0x4555
      3d:	50                   	push   %eax
      3e:	e8 32 41 00 00       	call   4175 <printf>
      43:	83 c4 10             	add    $0x10,%esp
    exit();
      46:	e8 ae 3f 00 00       	call   3ff9 <exit>
  }
  if(chdir("iputdir") < 0){
      4b:	83 ec 0c             	sub    $0xc,%esp
      4e:	68 4d 45 00 00       	push   $0x454d
      53:	e8 11 40 00 00       	call   4069 <chdir>
      58:	83 c4 10             	add    $0x10,%esp
      5b:	85 c0                	test   %eax,%eax
      5d:	79 1b                	jns    7a <iputtest+0x7a>
    printf(stdout, "chdir iputdir failed\n");
      5f:	a1 80 64 00 00       	mov    0x6480,%eax
      64:	83 ec 08             	sub    $0x8,%esp
      67:	68 63 45 00 00       	push   $0x4563
      6c:	50                   	push   %eax
      6d:	e8 03 41 00 00       	call   4175 <printf>
      72:	83 c4 10             	add    $0x10,%esp
    exit();
      75:	e8 7f 3f 00 00       	call   3ff9 <exit>
  }
  if(unlink("../iputdir") < 0){
      7a:	83 ec 0c             	sub    $0xc,%esp
      7d:	68 79 45 00 00       	push   $0x4579
      82:	e8 c2 3f 00 00       	call   4049 <unlink>
      87:	83 c4 10             	add    $0x10,%esp
      8a:	85 c0                	test   %eax,%eax
      8c:	79 1b                	jns    a9 <iputtest+0xa9>
    printf(stdout, "unlink ../iputdir failed\n");
      8e:	a1 80 64 00 00       	mov    0x6480,%eax
      93:	83 ec 08             	sub    $0x8,%esp
      96:	68 84 45 00 00       	push   $0x4584
      9b:	50                   	push   %eax
      9c:	e8 d4 40 00 00       	call   4175 <printf>
      a1:	83 c4 10             	add    $0x10,%esp
    exit();
      a4:	e8 50 3f 00 00       	call   3ff9 <exit>
  }
  if(chdir("/") < 0){
      a9:	83 ec 0c             	sub    $0xc,%esp
      ac:	68 9e 45 00 00       	push   $0x459e
      b1:	e8 b3 3f 00 00       	call   4069 <chdir>
      b6:	83 c4 10             	add    $0x10,%esp
      b9:	85 c0                	test   %eax,%eax
      bb:	79 1b                	jns    d8 <iputtest+0xd8>
    printf(stdout, "chdir / failed\n");
      bd:	a1 80 64 00 00       	mov    0x6480,%eax
      c2:	83 ec 08             	sub    $0x8,%esp
      c5:	68 a0 45 00 00       	push   $0x45a0
      ca:	50                   	push   %eax
      cb:	e8 a5 40 00 00       	call   4175 <printf>
      d0:	83 c4 10             	add    $0x10,%esp
    exit();
      d3:	e8 21 3f 00 00       	call   3ff9 <exit>
  }
  printf(stdout, "iput test ok\n");
      d8:	a1 80 64 00 00       	mov    0x6480,%eax
      dd:	83 ec 08             	sub    $0x8,%esp
      e0:	68 b0 45 00 00       	push   $0x45b0
      e5:	50                   	push   %eax
      e6:	e8 8a 40 00 00       	call   4175 <printf>
      eb:	83 c4 10             	add    $0x10,%esp
}
      ee:	90                   	nop
      ef:	c9                   	leave
      f0:	c3                   	ret

000000f1 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      f1:	55                   	push   %ebp
      f2:	89 e5                	mov    %esp,%ebp
      f4:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      f7:	a1 80 64 00 00       	mov    0x6480,%eax
      fc:	83 ec 08             	sub    $0x8,%esp
      ff:	68 be 45 00 00       	push   $0x45be
     104:	50                   	push   %eax
     105:	e8 6b 40 00 00       	call   4175 <printf>
     10a:	83 c4 10             	add    $0x10,%esp

  pid = fork();
     10d:	e8 df 3e 00 00       	call   3ff1 <fork>
     112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     115:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     119:	79 1b                	jns    136 <exitiputtest+0x45>
    printf(stdout, "fork failed\n");
     11b:	a1 80 64 00 00       	mov    0x6480,%eax
     120:	83 ec 08             	sub    $0x8,%esp
     123:	68 cd 45 00 00       	push   $0x45cd
     128:	50                   	push   %eax
     129:	e8 47 40 00 00       	call   4175 <printf>
     12e:	83 c4 10             	add    $0x10,%esp
    exit();
     131:	e8 c3 3e 00 00       	call   3ff9 <exit>
  }
  if(pid == 0){
     136:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     13a:	0f 85 92 00 00 00    	jne    1d2 <exitiputtest+0xe1>
    if(mkdir("iputdir") < 0){
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	68 4d 45 00 00       	push   $0x454d
     148:	e8 14 3f 00 00       	call   4061 <mkdir>
     14d:	83 c4 10             	add    $0x10,%esp
     150:	85 c0                	test   %eax,%eax
     152:	79 1b                	jns    16f <exitiputtest+0x7e>
      printf(stdout, "mkdir failed\n");
     154:	a1 80 64 00 00       	mov    0x6480,%eax
     159:	83 ec 08             	sub    $0x8,%esp
     15c:	68 55 45 00 00       	push   $0x4555
     161:	50                   	push   %eax
     162:	e8 0e 40 00 00       	call   4175 <printf>
     167:	83 c4 10             	add    $0x10,%esp
      exit();
     16a:	e8 8a 3e 00 00       	call   3ff9 <exit>
    }
    if(chdir("iputdir") < 0){
     16f:	83 ec 0c             	sub    $0xc,%esp
     172:	68 4d 45 00 00       	push   $0x454d
     177:	e8 ed 3e 00 00       	call   4069 <chdir>
     17c:	83 c4 10             	add    $0x10,%esp
     17f:	85 c0                	test   %eax,%eax
     181:	79 1b                	jns    19e <exitiputtest+0xad>
      printf(stdout, "child chdir failed\n");
     183:	a1 80 64 00 00       	mov    0x6480,%eax
     188:	83 ec 08             	sub    $0x8,%esp
     18b:	68 da 45 00 00       	push   $0x45da
     190:	50                   	push   %eax
     191:	e8 df 3f 00 00       	call   4175 <printf>
     196:	83 c4 10             	add    $0x10,%esp
      exit();
     199:	e8 5b 3e 00 00       	call   3ff9 <exit>
    }
    if(unlink("../iputdir") < 0){
     19e:	83 ec 0c             	sub    $0xc,%esp
     1a1:	68 79 45 00 00       	push   $0x4579
     1a6:	e8 9e 3e 00 00       	call   4049 <unlink>
     1ab:	83 c4 10             	add    $0x10,%esp
     1ae:	85 c0                	test   %eax,%eax
     1b0:	79 1b                	jns    1cd <exitiputtest+0xdc>
      printf(stdout, "unlink ../iputdir failed\n");
     1b2:	a1 80 64 00 00       	mov    0x6480,%eax
     1b7:	83 ec 08             	sub    $0x8,%esp
     1ba:	68 84 45 00 00       	push   $0x4584
     1bf:	50                   	push   %eax
     1c0:	e8 b0 3f 00 00       	call   4175 <printf>
     1c5:	83 c4 10             	add    $0x10,%esp
      exit();
     1c8:	e8 2c 3e 00 00       	call   3ff9 <exit>
    }
    exit();
     1cd:	e8 27 3e 00 00       	call   3ff9 <exit>
  }
  wait();
     1d2:	e8 2a 3e 00 00       	call   4001 <wait>
  printf(stdout, "exitiput test ok\n");
     1d7:	a1 80 64 00 00       	mov    0x6480,%eax
     1dc:	83 ec 08             	sub    $0x8,%esp
     1df:	68 ee 45 00 00       	push   $0x45ee
     1e4:	50                   	push   %eax
     1e5:	e8 8b 3f 00 00       	call   4175 <printf>
     1ea:	83 c4 10             	add    $0x10,%esp
}
     1ed:	90                   	nop
     1ee:	c9                   	leave
     1ef:	c3                   	ret

000001f0 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1f0:	55                   	push   %ebp
     1f1:	89 e5                	mov    %esp,%ebp
     1f3:	83 ec 18             	sub    $0x18,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1f6:	a1 80 64 00 00       	mov    0x6480,%eax
     1fb:	83 ec 08             	sub    $0x8,%esp
     1fe:	68 00 46 00 00       	push   $0x4600
     203:	50                   	push   %eax
     204:	e8 6c 3f 00 00       	call   4175 <printf>
     209:	83 c4 10             	add    $0x10,%esp
  if(mkdir("oidir") < 0){
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	68 0f 46 00 00       	push   $0x460f
     214:	e8 48 3e 00 00       	call   4061 <mkdir>
     219:	83 c4 10             	add    $0x10,%esp
     21c:	85 c0                	test   %eax,%eax
     21e:	79 1b                	jns    23b <openiputtest+0x4b>
    printf(stdout, "mkdir oidir failed\n");
     220:	a1 80 64 00 00       	mov    0x6480,%eax
     225:	83 ec 08             	sub    $0x8,%esp
     228:	68 15 46 00 00       	push   $0x4615
     22d:	50                   	push   %eax
     22e:	e8 42 3f 00 00       	call   4175 <printf>
     233:	83 c4 10             	add    $0x10,%esp
    exit();
     236:	e8 be 3d 00 00       	call   3ff9 <exit>
  }
  pid = fork();
     23b:	e8 b1 3d 00 00       	call   3ff1 <fork>
     240:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     243:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     247:	79 1b                	jns    264 <openiputtest+0x74>
    printf(stdout, "fork failed\n");
     249:	a1 80 64 00 00       	mov    0x6480,%eax
     24e:	83 ec 08             	sub    $0x8,%esp
     251:	68 cd 45 00 00       	push   $0x45cd
     256:	50                   	push   %eax
     257:	e8 19 3f 00 00       	call   4175 <printf>
     25c:	83 c4 10             	add    $0x10,%esp
    exit();
     25f:	e8 95 3d 00 00       	call   3ff9 <exit>
  }
  if(pid == 0){
     264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     268:	75 3b                	jne    2a5 <openiputtest+0xb5>
    int fd = open("oidir", O_RDWR);
     26a:	83 ec 08             	sub    $0x8,%esp
     26d:	6a 02                	push   $0x2
     26f:	68 0f 46 00 00       	push   $0x460f
     274:	e8 c0 3d 00 00       	call   4039 <open>
     279:	83 c4 10             	add    $0x10,%esp
     27c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0){
     27f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     283:	78 1b                	js     2a0 <openiputtest+0xb0>
      printf(stdout, "open directory for write succeeded\n");
     285:	a1 80 64 00 00       	mov    0x6480,%eax
     28a:	83 ec 08             	sub    $0x8,%esp
     28d:	68 2c 46 00 00       	push   $0x462c
     292:	50                   	push   %eax
     293:	e8 dd 3e 00 00       	call   4175 <printf>
     298:	83 c4 10             	add    $0x10,%esp
      exit();
     29b:	e8 59 3d 00 00       	call   3ff9 <exit>
    }
    exit();
     2a0:	e8 54 3d 00 00       	call   3ff9 <exit>
  }
  sleep(1);
     2a5:	83 ec 0c             	sub    $0xc,%esp
     2a8:	6a 01                	push   $0x1
     2aa:	e8 da 3d 00 00       	call   4089 <sleep>
     2af:	83 c4 10             	add    $0x10,%esp
  if(unlink("oidir") != 0){
     2b2:	83 ec 0c             	sub    $0xc,%esp
     2b5:	68 0f 46 00 00       	push   $0x460f
     2ba:	e8 8a 3d 00 00       	call   4049 <unlink>
     2bf:	83 c4 10             	add    $0x10,%esp
     2c2:	85 c0                	test   %eax,%eax
     2c4:	74 1b                	je     2e1 <openiputtest+0xf1>
    printf(stdout, "unlink failed\n");
     2c6:	a1 80 64 00 00       	mov    0x6480,%eax
     2cb:	83 ec 08             	sub    $0x8,%esp
     2ce:	68 50 46 00 00       	push   $0x4650
     2d3:	50                   	push   %eax
     2d4:	e8 9c 3e 00 00       	call   4175 <printf>
     2d9:	83 c4 10             	add    $0x10,%esp
    exit();
     2dc:	e8 18 3d 00 00       	call   3ff9 <exit>
  }
  wait();
     2e1:	e8 1b 3d 00 00       	call   4001 <wait>
  printf(stdout, "openiput test ok\n");
     2e6:	a1 80 64 00 00       	mov    0x6480,%eax
     2eb:	83 ec 08             	sub    $0x8,%esp
     2ee:	68 5f 46 00 00       	push   $0x465f
     2f3:	50                   	push   %eax
     2f4:	e8 7c 3e 00 00       	call   4175 <printf>
     2f9:	83 c4 10             	add    $0x10,%esp
}
     2fc:	90                   	nop
     2fd:	c9                   	leave
     2fe:	c3                   	ret

000002ff <opentest>:

// simple file system tests

void
opentest(void)
{
     2ff:	55                   	push   %ebp
     300:	89 e5                	mov    %esp,%ebp
     302:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(stdout, "open test\n");
     305:	a1 80 64 00 00       	mov    0x6480,%eax
     30a:	83 ec 08             	sub    $0x8,%esp
     30d:	68 71 46 00 00       	push   $0x4671
     312:	50                   	push   %eax
     313:	e8 5d 3e 00 00       	call   4175 <printf>
     318:	83 c4 10             	add    $0x10,%esp
  fd = open("echo", 0);
     31b:	83 ec 08             	sub    $0x8,%esp
     31e:	6a 00                	push   $0x0
     320:	68 2c 45 00 00       	push   $0x452c
     325:	e8 0f 3d 00 00       	call   4039 <open>
     32a:	83 c4 10             	add    $0x10,%esp
     32d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
     330:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     334:	79 1b                	jns    351 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
     336:	a1 80 64 00 00       	mov    0x6480,%eax
     33b:	83 ec 08             	sub    $0x8,%esp
     33e:	68 7c 46 00 00       	push   $0x467c
     343:	50                   	push   %eax
     344:	e8 2c 3e 00 00       	call   4175 <printf>
     349:	83 c4 10             	add    $0x10,%esp
    exit();
     34c:	e8 a8 3c 00 00       	call   3ff9 <exit>
  }
  close(fd);
     351:	83 ec 0c             	sub    $0xc,%esp
     354:	ff 75 f4             	push   -0xc(%ebp)
     357:	e8 c5 3c 00 00       	call   4021 <close>
     35c:	83 c4 10             	add    $0x10,%esp
  fd = open("doesnotexist", 0);
     35f:	83 ec 08             	sub    $0x8,%esp
     362:	6a 00                	push   $0x0
     364:	68 8f 46 00 00       	push   $0x468f
     369:	e8 cb 3c 00 00       	call   4039 <open>
     36e:	83 c4 10             	add    $0x10,%esp
     371:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
     374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     378:	78 1b                	js     395 <opentest+0x96>
    printf(stdout, "open doesnotexist succeeded!\n");
     37a:	a1 80 64 00 00       	mov    0x6480,%eax
     37f:	83 ec 08             	sub    $0x8,%esp
     382:	68 9c 46 00 00       	push   $0x469c
     387:	50                   	push   %eax
     388:	e8 e8 3d 00 00       	call   4175 <printf>
     38d:	83 c4 10             	add    $0x10,%esp
    exit();
     390:	e8 64 3c 00 00       	call   3ff9 <exit>
  }
  printf(stdout, "open test ok\n");
     395:	a1 80 64 00 00       	mov    0x6480,%eax
     39a:	83 ec 08             	sub    $0x8,%esp
     39d:	68 ba 46 00 00       	push   $0x46ba
     3a2:	50                   	push   %eax
     3a3:	e8 cd 3d 00 00       	call   4175 <printf>
     3a8:	83 c4 10             	add    $0x10,%esp
}
     3ab:	90                   	nop
     3ac:	c9                   	leave
     3ad:	c3                   	ret

000003ae <writetest>:

void
writetest(void)
{
     3ae:	55                   	push   %ebp
     3af:	89 e5                	mov    %esp,%ebp
     3b1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     3b4:	a1 80 64 00 00       	mov    0x6480,%eax
     3b9:	83 ec 08             	sub    $0x8,%esp
     3bc:	68 c8 46 00 00       	push   $0x46c8
     3c1:	50                   	push   %eax
     3c2:	e8 ae 3d 00 00       	call   4175 <printf>
     3c7:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_CREATE|O_RDWR);
     3ca:	83 ec 08             	sub    $0x8,%esp
     3cd:	68 02 02 00 00       	push   $0x202
     3d2:	68 d9 46 00 00       	push   $0x46d9
     3d7:	e8 5d 3c 00 00       	call   4039 <open>
     3dc:	83 c4 10             	add    $0x10,%esp
     3df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     3e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3e6:	78 22                	js     40a <writetest+0x5c>
    printf(stdout, "creat small succeeded; ok\n");
     3e8:	a1 80 64 00 00       	mov    0x6480,%eax
     3ed:	83 ec 08             	sub    $0x8,%esp
     3f0:	68 df 46 00 00       	push   $0x46df
     3f5:	50                   	push   %eax
     3f6:	e8 7a 3d 00 00       	call   4175 <printf>
     3fb:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     405:	e9 8f 00 00 00       	jmp    499 <writetest+0xeb>
    printf(stdout, "error: creat small failed!\n");
     40a:	a1 80 64 00 00       	mov    0x6480,%eax
     40f:	83 ec 08             	sub    $0x8,%esp
     412:	68 fa 46 00 00       	push   $0x46fa
     417:	50                   	push   %eax
     418:	e8 58 3d 00 00       	call   4175 <printf>
     41d:	83 c4 10             	add    $0x10,%esp
    exit();
     420:	e8 d4 3b 00 00       	call   3ff9 <exit>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     425:	83 ec 04             	sub    $0x4,%esp
     428:	6a 0a                	push   $0xa
     42a:	68 16 47 00 00       	push   $0x4716
     42f:	ff 75 f0             	push   -0x10(%ebp)
     432:	e8 e2 3b 00 00       	call   4019 <write>
     437:	83 c4 10             	add    $0x10,%esp
     43a:	83 f8 0a             	cmp    $0xa,%eax
     43d:	74 1e                	je     45d <writetest+0xaf>
      printf(stdout, "error: write aa %d new file failed\n", i);
     43f:	a1 80 64 00 00       	mov    0x6480,%eax
     444:	83 ec 04             	sub    $0x4,%esp
     447:	ff 75 f4             	push   -0xc(%ebp)
     44a:	68 24 47 00 00       	push   $0x4724
     44f:	50                   	push   %eax
     450:	e8 20 3d 00 00       	call   4175 <printf>
     455:	83 c4 10             	add    $0x10,%esp
      exit();
     458:	e8 9c 3b 00 00       	call   3ff9 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     45d:	83 ec 04             	sub    $0x4,%esp
     460:	6a 0a                	push   $0xa
     462:	68 48 47 00 00       	push   $0x4748
     467:	ff 75 f0             	push   -0x10(%ebp)
     46a:	e8 aa 3b 00 00       	call   4019 <write>
     46f:	83 c4 10             	add    $0x10,%esp
     472:	83 f8 0a             	cmp    $0xa,%eax
     475:	74 1e                	je     495 <writetest+0xe7>
      printf(stdout, "error: write bb %d new file failed\n", i);
     477:	a1 80 64 00 00       	mov    0x6480,%eax
     47c:	83 ec 04             	sub    $0x4,%esp
     47f:	ff 75 f4             	push   -0xc(%ebp)
     482:	68 54 47 00 00       	push   $0x4754
     487:	50                   	push   %eax
     488:	e8 e8 3c 00 00       	call   4175 <printf>
     48d:	83 c4 10             	add    $0x10,%esp
      exit();
     490:	e8 64 3b 00 00       	call   3ff9 <exit>
  for(i = 0; i < 100; i++){
     495:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     499:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     49d:	7e 86                	jle    425 <writetest+0x77>
    }
  }
  printf(stdout, "writes ok\n");
     49f:	a1 80 64 00 00       	mov    0x6480,%eax
     4a4:	83 ec 08             	sub    $0x8,%esp
     4a7:	68 78 47 00 00       	push   $0x4778
     4ac:	50                   	push   %eax
     4ad:	e8 c3 3c 00 00       	call   4175 <printf>
     4b2:	83 c4 10             	add    $0x10,%esp
  close(fd);
     4b5:	83 ec 0c             	sub    $0xc,%esp
     4b8:	ff 75 f0             	push   -0x10(%ebp)
     4bb:	e8 61 3b 00 00       	call   4021 <close>
     4c0:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
     4c3:	83 ec 08             	sub    $0x8,%esp
     4c6:	6a 00                	push   $0x0
     4c8:	68 d9 46 00 00       	push   $0x46d9
     4cd:	e8 67 3b 00 00       	call   4039 <open>
     4d2:	83 c4 10             	add    $0x10,%esp
     4d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     4d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4dc:	78 3c                	js     51a <writetest+0x16c>
    printf(stdout, "open small succeeded ok\n");
     4de:	a1 80 64 00 00       	mov    0x6480,%eax
     4e3:	83 ec 08             	sub    $0x8,%esp
     4e6:	68 83 47 00 00       	push   $0x4783
     4eb:	50                   	push   %eax
     4ec:	e8 84 3c 00 00       	call   4175 <printf>
     4f1:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     4f4:	83 ec 04             	sub    $0x4,%esp
     4f7:	68 d0 07 00 00       	push   $0x7d0
     4fc:	68 a0 64 00 00       	push   $0x64a0
     501:	ff 75 f0             	push   -0x10(%ebp)
     504:	e8 08 3b 00 00       	call   4011 <read>
     509:	83 c4 10             	add    $0x10,%esp
     50c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     50f:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     516:	75 57                	jne    56f <writetest+0x1c1>
     518:	eb 1b                	jmp    535 <writetest+0x187>
    printf(stdout, "error: open small failed!\n");
     51a:	a1 80 64 00 00       	mov    0x6480,%eax
     51f:	83 ec 08             	sub    $0x8,%esp
     522:	68 9c 47 00 00       	push   $0x479c
     527:	50                   	push   %eax
     528:	e8 48 3c 00 00       	call   4175 <printf>
     52d:	83 c4 10             	add    $0x10,%esp
    exit();
     530:	e8 c4 3a 00 00       	call   3ff9 <exit>
    printf(stdout, "read succeeded ok\n");
     535:	a1 80 64 00 00       	mov    0x6480,%eax
     53a:	83 ec 08             	sub    $0x8,%esp
     53d:	68 b7 47 00 00       	push   $0x47b7
     542:	50                   	push   %eax
     543:	e8 2d 3c 00 00       	call   4175 <printf>
     548:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     54b:	83 ec 0c             	sub    $0xc,%esp
     54e:	ff 75 f0             	push   -0x10(%ebp)
     551:	e8 cb 3a 00 00       	call   4021 <close>
     556:	83 c4 10             	add    $0x10,%esp

  if(unlink("small") < 0){
     559:	83 ec 0c             	sub    $0xc,%esp
     55c:	68 d9 46 00 00       	push   $0x46d9
     561:	e8 e3 3a 00 00       	call   4049 <unlink>
     566:	83 c4 10             	add    $0x10,%esp
     569:	85 c0                	test   %eax,%eax
     56b:	79 38                	jns    5a5 <writetest+0x1f7>
     56d:	eb 1b                	jmp    58a <writetest+0x1dc>
    printf(stdout, "read failed\n");
     56f:	a1 80 64 00 00       	mov    0x6480,%eax
     574:	83 ec 08             	sub    $0x8,%esp
     577:	68 ca 47 00 00       	push   $0x47ca
     57c:	50                   	push   %eax
     57d:	e8 f3 3b 00 00       	call   4175 <printf>
     582:	83 c4 10             	add    $0x10,%esp
    exit();
     585:	e8 6f 3a 00 00       	call   3ff9 <exit>
    printf(stdout, "unlink small failed\n");
     58a:	a1 80 64 00 00       	mov    0x6480,%eax
     58f:	83 ec 08             	sub    $0x8,%esp
     592:	68 d7 47 00 00       	push   $0x47d7
     597:	50                   	push   %eax
     598:	e8 d8 3b 00 00       	call   4175 <printf>
     59d:	83 c4 10             	add    $0x10,%esp
    exit();
     5a0:	e8 54 3a 00 00       	call   3ff9 <exit>
  }
  printf(stdout, "small file test ok\n");
     5a5:	a1 80 64 00 00       	mov    0x6480,%eax
     5aa:	83 ec 08             	sub    $0x8,%esp
     5ad:	68 ec 47 00 00       	push   $0x47ec
     5b2:	50                   	push   %eax
     5b3:	e8 bd 3b 00 00       	call   4175 <printf>
     5b8:	83 c4 10             	add    $0x10,%esp
}
     5bb:	90                   	nop
     5bc:	c9                   	leave
     5bd:	c3                   	ret

000005be <writetest1>:

void
writetest1(void)
{
     5be:	55                   	push   %ebp
     5bf:	89 e5                	mov    %esp,%ebp
     5c1:	83 ec 18             	sub    $0x18,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     5c4:	a1 80 64 00 00       	mov    0x6480,%eax
     5c9:	83 ec 08             	sub    $0x8,%esp
     5cc:	68 00 48 00 00       	push   $0x4800
     5d1:	50                   	push   %eax
     5d2:	e8 9e 3b 00 00       	call   4175 <printf>
     5d7:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_CREATE|O_RDWR);
     5da:	83 ec 08             	sub    $0x8,%esp
     5dd:	68 02 02 00 00       	push   $0x202
     5e2:	68 10 48 00 00       	push   $0x4810
     5e7:	e8 4d 3a 00 00       	call   4039 <open>
     5ec:	83 c4 10             	add    $0x10,%esp
     5ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     5f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     5f6:	79 1b                	jns    613 <writetest1+0x55>
    printf(stdout, "error: creat big failed!\n");
     5f8:	a1 80 64 00 00       	mov    0x6480,%eax
     5fd:	83 ec 08             	sub    $0x8,%esp
     600:	68 14 48 00 00       	push   $0x4814
     605:	50                   	push   %eax
     606:	e8 6a 3b 00 00       	call   4175 <printf>
     60b:	83 c4 10             	add    $0x10,%esp
    exit();
     60e:	e8 e6 39 00 00       	call   3ff9 <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     613:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     61a:	eb 4b                	jmp    667 <writetest1+0xa9>
    ((int*)buf)[0] = i;
     61c:	ba a0 64 00 00       	mov    $0x64a0,%edx
     621:	8b 45 f4             	mov    -0xc(%ebp),%eax
     624:	89 02                	mov    %eax,(%edx)
    if(write(fd, buf, 512) != 512){
     626:	83 ec 04             	sub    $0x4,%esp
     629:	68 00 02 00 00       	push   $0x200
     62e:	68 a0 64 00 00       	push   $0x64a0
     633:	ff 75 ec             	push   -0x14(%ebp)
     636:	e8 de 39 00 00       	call   4019 <write>
     63b:	83 c4 10             	add    $0x10,%esp
     63e:	3d 00 02 00 00       	cmp    $0x200,%eax
     643:	74 1e                	je     663 <writetest1+0xa5>
      printf(stdout, "error: write big file failed\n", i);
     645:	a1 80 64 00 00       	mov    0x6480,%eax
     64a:	83 ec 04             	sub    $0x4,%esp
     64d:	ff 75 f4             	push   -0xc(%ebp)
     650:	68 2e 48 00 00       	push   $0x482e
     655:	50                   	push   %eax
     656:	e8 1a 3b 00 00       	call   4175 <printf>
     65b:	83 c4 10             	add    $0x10,%esp
      exit();
     65e:	e8 96 39 00 00       	call   3ff9 <exit>
  for(i = 0; i < MAXFILE; i++){
     663:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     667:	8b 45 f4             	mov    -0xc(%ebp),%eax
     66a:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     66f:	76 ab                	jbe    61c <writetest1+0x5e>
    }
  }

  close(fd);
     671:	83 ec 0c             	sub    $0xc,%esp
     674:	ff 75 ec             	push   -0x14(%ebp)
     677:	e8 a5 39 00 00       	call   4021 <close>
     67c:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_RDONLY);
     67f:	83 ec 08             	sub    $0x8,%esp
     682:	6a 00                	push   $0x0
     684:	68 10 48 00 00       	push   $0x4810
     689:	e8 ab 39 00 00       	call   4039 <open>
     68e:	83 c4 10             	add    $0x10,%esp
     691:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     694:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     698:	79 1b                	jns    6b5 <writetest1+0xf7>
    printf(stdout, "error: open big failed!\n");
     69a:	a1 80 64 00 00       	mov    0x6480,%eax
     69f:	83 ec 08             	sub    $0x8,%esp
     6a2:	68 4c 48 00 00       	push   $0x484c
     6a7:	50                   	push   %eax
     6a8:	e8 c8 3a 00 00       	call   4175 <printf>
     6ad:	83 c4 10             	add    $0x10,%esp
    exit();
     6b0:	e8 44 39 00 00       	call   3ff9 <exit>
  }

  n = 0;
     6b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     6bc:	83 ec 04             	sub    $0x4,%esp
     6bf:	68 00 02 00 00       	push   $0x200
     6c4:	68 a0 64 00 00       	push   $0x64a0
     6c9:	ff 75 ec             	push   -0x14(%ebp)
     6cc:	e8 40 39 00 00       	call   4011 <read>
     6d1:	83 c4 10             	add    $0x10,%esp
     6d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     6d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6db:	75 27                	jne    704 <writetest1+0x146>
      if(n == MAXFILE - 1){
     6dd:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     6e4:	75 7d                	jne    763 <writetest1+0x1a5>
        printf(stdout, "read only %d blocks from big", n);
     6e6:	a1 80 64 00 00       	mov    0x6480,%eax
     6eb:	83 ec 04             	sub    $0x4,%esp
     6ee:	ff 75 f0             	push   -0x10(%ebp)
     6f1:	68 65 48 00 00       	push   $0x4865
     6f6:	50                   	push   %eax
     6f7:	e8 79 3a 00 00       	call   4175 <printf>
     6fc:	83 c4 10             	add    $0x10,%esp
        exit();
     6ff:	e8 f5 38 00 00       	call   3ff9 <exit>
      }
      break;
    } else if(i != 512){
     704:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     70b:	74 1e                	je     72b <writetest1+0x16d>
      printf(stdout, "read failed %d\n", i);
     70d:	a1 80 64 00 00       	mov    0x6480,%eax
     712:	83 ec 04             	sub    $0x4,%esp
     715:	ff 75 f4             	push   -0xc(%ebp)
     718:	68 82 48 00 00       	push   $0x4882
     71d:	50                   	push   %eax
     71e:	e8 52 3a 00 00       	call   4175 <printf>
     723:	83 c4 10             	add    $0x10,%esp
      exit();
     726:	e8 ce 38 00 00       	call   3ff9 <exit>
    }
    if(((int*)buf)[0] != n){
     72b:	b8 a0 64 00 00       	mov    $0x64a0,%eax
     730:	8b 00                	mov    (%eax),%eax
     732:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     735:	74 23                	je     75a <writetest1+0x19c>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     737:	b8 a0 64 00 00       	mov    $0x64a0,%eax
      printf(stdout, "read content of block %d is %d\n",
     73c:	8b 10                	mov    (%eax),%edx
     73e:	a1 80 64 00 00       	mov    0x6480,%eax
     743:	52                   	push   %edx
     744:	ff 75 f0             	push   -0x10(%ebp)
     747:	68 94 48 00 00       	push   $0x4894
     74c:	50                   	push   %eax
     74d:	e8 23 3a 00 00       	call   4175 <printf>
     752:	83 c4 10             	add    $0x10,%esp
      exit();
     755:	e8 9f 38 00 00       	call   3ff9 <exit>
    }
    n++;
     75a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    i = read(fd, buf, 512);
     75e:	e9 59 ff ff ff       	jmp    6bc <writetest1+0xfe>
      break;
     763:	90                   	nop
  }
  close(fd);
     764:	83 ec 0c             	sub    $0xc,%esp
     767:	ff 75 ec             	push   -0x14(%ebp)
     76a:	e8 b2 38 00 00       	call   4021 <close>
     76f:	83 c4 10             	add    $0x10,%esp
  if(unlink("big") < 0){
     772:	83 ec 0c             	sub    $0xc,%esp
     775:	68 10 48 00 00       	push   $0x4810
     77a:	e8 ca 38 00 00       	call   4049 <unlink>
     77f:	83 c4 10             	add    $0x10,%esp
     782:	85 c0                	test   %eax,%eax
     784:	79 1b                	jns    7a1 <writetest1+0x1e3>
    printf(stdout, "unlink big failed\n");
     786:	a1 80 64 00 00       	mov    0x6480,%eax
     78b:	83 ec 08             	sub    $0x8,%esp
     78e:	68 b4 48 00 00       	push   $0x48b4
     793:	50                   	push   %eax
     794:	e8 dc 39 00 00       	call   4175 <printf>
     799:	83 c4 10             	add    $0x10,%esp
    exit();
     79c:	e8 58 38 00 00       	call   3ff9 <exit>
  }
  printf(stdout, "big files ok\n");
     7a1:	a1 80 64 00 00       	mov    0x6480,%eax
     7a6:	83 ec 08             	sub    $0x8,%esp
     7a9:	68 c7 48 00 00       	push   $0x48c7
     7ae:	50                   	push   %eax
     7af:	e8 c1 39 00 00       	call   4175 <printf>
     7b4:	83 c4 10             	add    $0x10,%esp
}
     7b7:	90                   	nop
     7b8:	c9                   	leave
     7b9:	c3                   	ret

000007ba <createtest>:

void
createtest(void)
{
     7ba:	55                   	push   %ebp
     7bb:	89 e5                	mov    %esp,%ebp
     7bd:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     7c0:	a1 80 64 00 00       	mov    0x6480,%eax
     7c5:	83 ec 08             	sub    $0x8,%esp
     7c8:	68 d8 48 00 00       	push   $0x48d8
     7cd:	50                   	push   %eax
     7ce:	e8 a2 39 00 00       	call   4175 <printf>
     7d3:	83 c4 10             	add    $0x10,%esp

  name[0] = 'a';
     7d6:	c6 05 a0 84 00 00 61 	movb   $0x61,0x84a0
  name[2] = '\0';
     7dd:	c6 05 a2 84 00 00 00 	movb   $0x0,0x84a2
  for(i = 0; i < 52; i++){
     7e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7eb:	eb 35                	jmp    822 <createtest+0x68>
    name[1] = '0' + i;
     7ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7f0:	83 c0 30             	add    $0x30,%eax
     7f3:	a2 a1 84 00 00       	mov    %al,0x84a1
    fd = open(name, O_CREATE|O_RDWR);
     7f8:	83 ec 08             	sub    $0x8,%esp
     7fb:	68 02 02 00 00       	push   $0x202
     800:	68 a0 84 00 00       	push   $0x84a0
     805:	e8 2f 38 00 00       	call   4039 <open>
     80a:	83 c4 10             	add    $0x10,%esp
     80d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     810:	83 ec 0c             	sub    $0xc,%esp
     813:	ff 75 f0             	push   -0x10(%ebp)
     816:	e8 06 38 00 00       	call   4021 <close>
     81b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 52; i++){
     81e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     822:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     826:	7e c5                	jle    7ed <createtest+0x33>
  }
  name[0] = 'a';
     828:	c6 05 a0 84 00 00 61 	movb   $0x61,0x84a0
  name[2] = '\0';
     82f:	c6 05 a2 84 00 00 00 	movb   $0x0,0x84a2
  for(i = 0; i < 52; i++){
     836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     83d:	eb 1f                	jmp    85e <createtest+0xa4>
    name[1] = '0' + i;
     83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     842:	83 c0 30             	add    $0x30,%eax
     845:	a2 a1 84 00 00       	mov    %al,0x84a1
    unlink(name);
     84a:	83 ec 0c             	sub    $0xc,%esp
     84d:	68 a0 84 00 00       	push   $0x84a0
     852:	e8 f2 37 00 00       	call   4049 <unlink>
     857:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 52; i++){
     85a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     85e:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     862:	7e db                	jle    83f <createtest+0x85>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     864:	a1 80 64 00 00       	mov    0x6480,%eax
     869:	83 ec 08             	sub    $0x8,%esp
     86c:	68 00 49 00 00       	push   $0x4900
     871:	50                   	push   %eax
     872:	e8 fe 38 00 00       	call   4175 <printf>
     877:	83 c4 10             	add    $0x10,%esp
}
     87a:	90                   	nop
     87b:	c9                   	leave
     87c:	c3                   	ret

0000087d <dirtest>:

void dirtest(void)
{
     87d:	55                   	push   %ebp
     87e:	89 e5                	mov    %esp,%ebp
     880:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "mkdir test\n");
     883:	a1 80 64 00 00       	mov    0x6480,%eax
     888:	83 ec 08             	sub    $0x8,%esp
     88b:	68 26 49 00 00       	push   $0x4926
     890:	50                   	push   %eax
     891:	e8 df 38 00 00       	call   4175 <printf>
     896:	83 c4 10             	add    $0x10,%esp

  if(mkdir("dir0") < 0){
     899:	83 ec 0c             	sub    $0xc,%esp
     89c:	68 32 49 00 00       	push   $0x4932
     8a1:	e8 bb 37 00 00       	call   4061 <mkdir>
     8a6:	83 c4 10             	add    $0x10,%esp
     8a9:	85 c0                	test   %eax,%eax
     8ab:	79 1b                	jns    8c8 <dirtest+0x4b>
    printf(stdout, "mkdir failed\n");
     8ad:	a1 80 64 00 00       	mov    0x6480,%eax
     8b2:	83 ec 08             	sub    $0x8,%esp
     8b5:	68 55 45 00 00       	push   $0x4555
     8ba:	50                   	push   %eax
     8bb:	e8 b5 38 00 00       	call   4175 <printf>
     8c0:	83 c4 10             	add    $0x10,%esp
    exit();
     8c3:	e8 31 37 00 00       	call   3ff9 <exit>
  }

  if(chdir("dir0") < 0){
     8c8:	83 ec 0c             	sub    $0xc,%esp
     8cb:	68 32 49 00 00       	push   $0x4932
     8d0:	e8 94 37 00 00       	call   4069 <chdir>
     8d5:	83 c4 10             	add    $0x10,%esp
     8d8:	85 c0                	test   %eax,%eax
     8da:	79 1b                	jns    8f7 <dirtest+0x7a>
    printf(stdout, "chdir dir0 failed\n");
     8dc:	a1 80 64 00 00       	mov    0x6480,%eax
     8e1:	83 ec 08             	sub    $0x8,%esp
     8e4:	68 37 49 00 00       	push   $0x4937
     8e9:	50                   	push   %eax
     8ea:	e8 86 38 00 00       	call   4175 <printf>
     8ef:	83 c4 10             	add    $0x10,%esp
    exit();
     8f2:	e8 02 37 00 00       	call   3ff9 <exit>
  }

  if(chdir("..") < 0){
     8f7:	83 ec 0c             	sub    $0xc,%esp
     8fa:	68 4a 49 00 00       	push   $0x494a
     8ff:	e8 65 37 00 00       	call   4069 <chdir>
     904:	83 c4 10             	add    $0x10,%esp
     907:	85 c0                	test   %eax,%eax
     909:	79 1b                	jns    926 <dirtest+0xa9>
    printf(stdout, "chdir .. failed\n");
     90b:	a1 80 64 00 00       	mov    0x6480,%eax
     910:	83 ec 08             	sub    $0x8,%esp
     913:	68 4d 49 00 00       	push   $0x494d
     918:	50                   	push   %eax
     919:	e8 57 38 00 00       	call   4175 <printf>
     91e:	83 c4 10             	add    $0x10,%esp
    exit();
     921:	e8 d3 36 00 00       	call   3ff9 <exit>
  }

  if(unlink("dir0") < 0){
     926:	83 ec 0c             	sub    $0xc,%esp
     929:	68 32 49 00 00       	push   $0x4932
     92e:	e8 16 37 00 00       	call   4049 <unlink>
     933:	83 c4 10             	add    $0x10,%esp
     936:	85 c0                	test   %eax,%eax
     938:	79 1b                	jns    955 <dirtest+0xd8>
    printf(stdout, "unlink dir0 failed\n");
     93a:	a1 80 64 00 00       	mov    0x6480,%eax
     93f:	83 ec 08             	sub    $0x8,%esp
     942:	68 5e 49 00 00       	push   $0x495e
     947:	50                   	push   %eax
     948:	e8 28 38 00 00       	call   4175 <printf>
     94d:	83 c4 10             	add    $0x10,%esp
    exit();
     950:	e8 a4 36 00 00       	call   3ff9 <exit>
  }
  printf(stdout, "mkdir test ok\n");
     955:	a1 80 64 00 00       	mov    0x6480,%eax
     95a:	83 ec 08             	sub    $0x8,%esp
     95d:	68 72 49 00 00       	push   $0x4972
     962:	50                   	push   %eax
     963:	e8 0d 38 00 00       	call   4175 <printf>
     968:	83 c4 10             	add    $0x10,%esp
}
     96b:	90                   	nop
     96c:	c9                   	leave
     96d:	c3                   	ret

0000096e <exectest>:

void
exectest(void)
{
     96e:	55                   	push   %ebp
     96f:	89 e5                	mov    %esp,%ebp
     971:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "exec test\n");
     974:	a1 80 64 00 00       	mov    0x6480,%eax
     979:	83 ec 08             	sub    $0x8,%esp
     97c:	68 81 49 00 00       	push   $0x4981
     981:	50                   	push   %eax
     982:	e8 ee 37 00 00       	call   4175 <printf>
     987:	83 c4 10             	add    $0x10,%esp
  if(exec("echo", echoargv) < 0){
     98a:	83 ec 08             	sub    $0x8,%esp
     98d:	68 6c 64 00 00       	push   $0x646c
     992:	68 2c 45 00 00       	push   $0x452c
     997:	e8 95 36 00 00       	call   4031 <exec>
     99c:	83 c4 10             	add    $0x10,%esp
     99f:	85 c0                	test   %eax,%eax
     9a1:	79 1b                	jns    9be <exectest+0x50>
    printf(stdout, "exec echo failed\n");
     9a3:	a1 80 64 00 00       	mov    0x6480,%eax
     9a8:	83 ec 08             	sub    $0x8,%esp
     9ab:	68 8c 49 00 00       	push   $0x498c
     9b0:	50                   	push   %eax
     9b1:	e8 bf 37 00 00       	call   4175 <printf>
     9b6:	83 c4 10             	add    $0x10,%esp
    exit();
     9b9:	e8 3b 36 00 00       	call   3ff9 <exit>
  }
}
     9be:	90                   	nop
     9bf:	c9                   	leave
     9c0:	c3                   	ret

000009c1 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     9c1:	55                   	push   %ebp
     9c2:	89 e5                	mov    %esp,%ebp
     9c4:	83 ec 28             	sub    $0x28,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     9c7:	83 ec 0c             	sub    $0xc,%esp
     9ca:	8d 45 d8             	lea    -0x28(%ebp),%eax
     9cd:	50                   	push   %eax
     9ce:	e8 36 36 00 00       	call   4009 <pipe>
     9d3:	83 c4 10             	add    $0x10,%esp
     9d6:	85 c0                	test   %eax,%eax
     9d8:	74 17                	je     9f1 <pipe1+0x30>
    printf(1, "pipe() failed\n");
     9da:	83 ec 08             	sub    $0x8,%esp
     9dd:	68 9e 49 00 00       	push   $0x499e
     9e2:	6a 01                	push   $0x1
     9e4:	e8 8c 37 00 00       	call   4175 <printf>
     9e9:	83 c4 10             	add    $0x10,%esp
    exit();
     9ec:	e8 08 36 00 00       	call   3ff9 <exit>
  }
  pid = fork();
     9f1:	e8 fb 35 00 00       	call   3ff1 <fork>
     9f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     9f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     a00:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a04:	0f 85 89 00 00 00    	jne    a93 <pipe1+0xd2>
    close(fds[0]);
     a0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
     a0d:	83 ec 0c             	sub    $0xc,%esp
     a10:	50                   	push   %eax
     a11:	e8 0b 36 00 00       	call   4021 <close>
     a16:	83 c4 10             	add    $0x10,%esp
    for(n = 0; n < 5; n++){
     a19:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     a20:	eb 66                	jmp    a88 <pipe1+0xc7>
      for(i = 0; i < 1033; i++)
     a22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     a29:	eb 19                	jmp    a44 <pipe1+0x83>
        buf[i] = seq++;
     a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a2e:	8d 50 01             	lea    0x1(%eax),%edx
     a31:	89 55 f4             	mov    %edx,-0xc(%ebp)
     a34:	89 c2                	mov    %eax,%edx
     a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a39:	05 a0 64 00 00       	add    $0x64a0,%eax
     a3e:	88 10                	mov    %dl,(%eax)
      for(i = 0; i < 1033; i++)
     a40:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     a44:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     a4b:	7e de                	jle    a2b <pipe1+0x6a>
      if(write(fds[1], buf, 1033) != 1033){
     a4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a50:	83 ec 04             	sub    $0x4,%esp
     a53:	68 09 04 00 00       	push   $0x409
     a58:	68 a0 64 00 00       	push   $0x64a0
     a5d:	50                   	push   %eax
     a5e:	e8 b6 35 00 00       	call   4019 <write>
     a63:	83 c4 10             	add    $0x10,%esp
     a66:	3d 09 04 00 00       	cmp    $0x409,%eax
     a6b:	74 17                	je     a84 <pipe1+0xc3>
        printf(1, "pipe1 oops 1\n");
     a6d:	83 ec 08             	sub    $0x8,%esp
     a70:	68 ad 49 00 00       	push   $0x49ad
     a75:	6a 01                	push   $0x1
     a77:	e8 f9 36 00 00       	call   4175 <printf>
     a7c:	83 c4 10             	add    $0x10,%esp
        exit();
     a7f:	e8 75 35 00 00       	call   3ff9 <exit>
    for(n = 0; n < 5; n++){
     a84:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     a88:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     a8c:	7e 94                	jle    a22 <pipe1+0x61>
      }
    }
    exit();
     a8e:	e8 66 35 00 00       	call   3ff9 <exit>
  } else if(pid > 0){
     a93:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a97:	0f 8e f4 00 00 00    	jle    b91 <pipe1+0x1d0>
    close(fds[1]);
     a9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     aa0:	83 ec 0c             	sub    $0xc,%esp
     aa3:	50                   	push   %eax
     aa4:	e8 78 35 00 00       	call   4021 <close>
     aa9:	83 c4 10             	add    $0x10,%esp
    total = 0;
     aac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     ab3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     aba:	eb 66                	jmp    b22 <pipe1+0x161>
      for(i = 0; i < n; i++){
     abc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     ac3:	eb 3b                	jmp    b00 <pipe1+0x13f>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ac8:	05 a0 64 00 00       	add    $0x64a0,%eax
     acd:	0f b6 00             	movzbl (%eax),%eax
     ad0:	0f be c8             	movsbl %al,%ecx
     ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad6:	8d 50 01             	lea    0x1(%eax),%edx
     ad9:	89 55 f4             	mov    %edx,-0xc(%ebp)
     adc:	31 c8                	xor    %ecx,%eax
     ade:	0f b6 c0             	movzbl %al,%eax
     ae1:	85 c0                	test   %eax,%eax
     ae3:	74 17                	je     afc <pipe1+0x13b>
          printf(1, "pipe1 oops 2\n");
     ae5:	83 ec 08             	sub    $0x8,%esp
     ae8:	68 bb 49 00 00       	push   $0x49bb
     aed:	6a 01                	push   $0x1
     aef:	e8 81 36 00 00       	call   4175 <printf>
     af4:	83 c4 10             	add    $0x10,%esp
     af7:	e9 ac 00 00 00       	jmp    ba8 <pipe1+0x1e7>
      for(i = 0; i < n; i++){
     afc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b03:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     b06:	7c bd                	jl     ac5 <pipe1+0x104>
          return;
        }
      }
      total += n;
     b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b0b:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     b0e:	d1 65 e8             	shll   $1,-0x18(%ebp)
      if(cc > sizeof(buf))
     b11:	8b 45 e8             	mov    -0x18(%ebp),%eax
     b14:	3d 00 20 00 00       	cmp    $0x2000,%eax
     b19:	76 07                	jbe    b22 <pipe1+0x161>
        cc = sizeof(buf);
     b1b:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     b22:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b25:	83 ec 04             	sub    $0x4,%esp
     b28:	ff 75 e8             	push   -0x18(%ebp)
     b2b:	68 a0 64 00 00       	push   $0x64a0
     b30:	50                   	push   %eax
     b31:	e8 db 34 00 00       	call   4011 <read>
     b36:	83 c4 10             	add    $0x10,%esp
     b39:	89 45 ec             	mov    %eax,-0x14(%ebp)
     b3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b40:	0f 8f 76 ff ff ff    	jg     abc <pipe1+0xfb>
    }
    if(total != 5 * 1033){
     b46:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     b4d:	74 1a                	je     b69 <pipe1+0x1a8>
      printf(1, "pipe1 oops 3 total %d\n", total);
     b4f:	83 ec 04             	sub    $0x4,%esp
     b52:	ff 75 e4             	push   -0x1c(%ebp)
     b55:	68 c9 49 00 00       	push   $0x49c9
     b5a:	6a 01                	push   $0x1
     b5c:	e8 14 36 00 00       	call   4175 <printf>
     b61:	83 c4 10             	add    $0x10,%esp
      exit();
     b64:	e8 90 34 00 00       	call   3ff9 <exit>
    }
    close(fds[0]);
     b69:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b6c:	83 ec 0c             	sub    $0xc,%esp
     b6f:	50                   	push   %eax
     b70:	e8 ac 34 00 00       	call   4021 <close>
     b75:	83 c4 10             	add    $0x10,%esp
    wait();
     b78:	e8 84 34 00 00       	call   4001 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     b7d:	83 ec 08             	sub    $0x8,%esp
     b80:	68 ef 49 00 00       	push   $0x49ef
     b85:	6a 01                	push   $0x1
     b87:	e8 e9 35 00 00       	call   4175 <printf>
     b8c:	83 c4 10             	add    $0x10,%esp
     b8f:	eb 17                	jmp    ba8 <pipe1+0x1e7>
    printf(1, "fork() failed\n");
     b91:	83 ec 08             	sub    $0x8,%esp
     b94:	68 e0 49 00 00       	push   $0x49e0
     b99:	6a 01                	push   $0x1
     b9b:	e8 d5 35 00 00       	call   4175 <printf>
     ba0:	83 c4 10             	add    $0x10,%esp
    exit();
     ba3:	e8 51 34 00 00       	call   3ff9 <exit>
}
     ba8:	c9                   	leave
     ba9:	c3                   	ret

00000baa <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     baa:	55                   	push   %ebp
     bab:	89 e5                	mov    %esp,%ebp
     bad:	83 ec 28             	sub    $0x28,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     bb0:	83 ec 08             	sub    $0x8,%esp
     bb3:	68 f9 49 00 00       	push   $0x49f9
     bb8:	6a 01                	push   $0x1
     bba:	e8 b6 35 00 00       	call   4175 <printf>
     bbf:	83 c4 10             	add    $0x10,%esp
  pid1 = fork();
     bc2:	e8 2a 34 00 00       	call   3ff1 <fork>
     bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     bce:	75 03                	jne    bd3 <preempt+0x29>
    for(;;)
     bd0:	90                   	nop
     bd1:	eb fd                	jmp    bd0 <preempt+0x26>
      ;

  pid2 = fork();
     bd3:	e8 19 34 00 00       	call   3ff1 <fork>
     bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     bdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bdf:	75 03                	jne    be4 <preempt+0x3a>
    for(;;)
     be1:	90                   	nop
     be2:	eb fd                	jmp    be1 <preempt+0x37>
      ;

  pipe(pfds);
     be4:	83 ec 0c             	sub    $0xc,%esp
     be7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     bea:	50                   	push   %eax
     beb:	e8 19 34 00 00       	call   4009 <pipe>
     bf0:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
     bf3:	e8 f9 33 00 00       	call   3ff1 <fork>
     bf8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     bfb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     bff:	75 4e                	jne    c4f <preempt+0xa5>
    close(pfds[0]);
     c01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c04:	83 ec 0c             	sub    $0xc,%esp
     c07:	50                   	push   %eax
     c08:	e8 14 34 00 00       	call   4021 <close>
     c0d:	83 c4 10             	add    $0x10,%esp
    if(write(pfds[1], "x", 1) != 1)
     c10:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c13:	83 ec 04             	sub    $0x4,%esp
     c16:	6a 01                	push   $0x1
     c18:	68 03 4a 00 00       	push   $0x4a03
     c1d:	50                   	push   %eax
     c1e:	e8 f6 33 00 00       	call   4019 <write>
     c23:	83 c4 10             	add    $0x10,%esp
     c26:	83 f8 01             	cmp    $0x1,%eax
     c29:	74 12                	je     c3d <preempt+0x93>
      printf(1, "preempt write error");
     c2b:	83 ec 08             	sub    $0x8,%esp
     c2e:	68 05 4a 00 00       	push   $0x4a05
     c33:	6a 01                	push   $0x1
     c35:	e8 3b 35 00 00       	call   4175 <printf>
     c3a:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     c3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c40:	83 ec 0c             	sub    $0xc,%esp
     c43:	50                   	push   %eax
     c44:	e8 d8 33 00 00       	call   4021 <close>
     c49:	83 c4 10             	add    $0x10,%esp
    for(;;)
     c4c:	90                   	nop
     c4d:	eb fd                	jmp    c4c <preempt+0xa2>
      ;
  }

  close(pfds[1]);
     c4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c52:	83 ec 0c             	sub    $0xc,%esp
     c55:	50                   	push   %eax
     c56:	e8 c6 33 00 00       	call   4021 <close>
     c5b:	83 c4 10             	add    $0x10,%esp
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c61:	83 ec 04             	sub    $0x4,%esp
     c64:	68 00 20 00 00       	push   $0x2000
     c69:	68 a0 64 00 00       	push   $0x64a0
     c6e:	50                   	push   %eax
     c6f:	e8 9d 33 00 00       	call   4011 <read>
     c74:	83 c4 10             	add    $0x10,%esp
     c77:	83 f8 01             	cmp    $0x1,%eax
     c7a:	74 14                	je     c90 <preempt+0xe6>
    printf(1, "preempt read error");
     c7c:	83 ec 08             	sub    $0x8,%esp
     c7f:	68 19 4a 00 00       	push   $0x4a19
     c84:	6a 01                	push   $0x1
     c86:	e8 ea 34 00 00       	call   4175 <printf>
     c8b:	83 c4 10             	add    $0x10,%esp
     c8e:	eb 7e                	jmp    d0e <preempt+0x164>
    return;
  }
  close(pfds[0]);
     c90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c93:	83 ec 0c             	sub    $0xc,%esp
     c96:	50                   	push   %eax
     c97:	e8 85 33 00 00       	call   4021 <close>
     c9c:	83 c4 10             	add    $0x10,%esp
  printf(1, "kill... ");
     c9f:	83 ec 08             	sub    $0x8,%esp
     ca2:	68 2c 4a 00 00       	push   $0x4a2c
     ca7:	6a 01                	push   $0x1
     ca9:	e8 c7 34 00 00       	call   4175 <printf>
     cae:	83 c4 10             	add    $0x10,%esp
  kill(pid1);
     cb1:	83 ec 0c             	sub    $0xc,%esp
     cb4:	ff 75 f4             	push   -0xc(%ebp)
     cb7:	e8 6d 33 00 00       	call   4029 <kill>
     cbc:	83 c4 10             	add    $0x10,%esp
  kill(pid2);
     cbf:	83 ec 0c             	sub    $0xc,%esp
     cc2:	ff 75 f0             	push   -0x10(%ebp)
     cc5:	e8 5f 33 00 00       	call   4029 <kill>
     cca:	83 c4 10             	add    $0x10,%esp
  kill(pid3);
     ccd:	83 ec 0c             	sub    $0xc,%esp
     cd0:	ff 75 ec             	push   -0x14(%ebp)
     cd3:	e8 51 33 00 00       	call   4029 <kill>
     cd8:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
     cdb:	83 ec 08             	sub    $0x8,%esp
     cde:	68 35 4a 00 00       	push   $0x4a35
     ce3:	6a 01                	push   $0x1
     ce5:	e8 8b 34 00 00       	call   4175 <printf>
     cea:	83 c4 10             	add    $0x10,%esp
  wait();
     ced:	e8 0f 33 00 00       	call   4001 <wait>
  wait();
     cf2:	e8 0a 33 00 00       	call   4001 <wait>
  wait();
     cf7:	e8 05 33 00 00       	call   4001 <wait>
  printf(1, "preempt ok\n");
     cfc:	83 ec 08             	sub    $0x8,%esp
     cff:	68 3e 4a 00 00       	push   $0x4a3e
     d04:	6a 01                	push   $0x1
     d06:	e8 6a 34 00 00       	call   4175 <printf>
     d0b:	83 c4 10             	add    $0x10,%esp
}
     d0e:	c9                   	leave
     d0f:	c3                   	ret

00000d10 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     d10:	55                   	push   %ebp
     d11:	89 e5                	mov    %esp,%ebp
     d13:	83 ec 18             	sub    $0x18,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     d16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d1d:	eb 4f                	jmp    d6e <exitwait+0x5e>
    pid = fork();
     d1f:	e8 cd 32 00 00       	call   3ff1 <fork>
     d24:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     d27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d2b:	79 14                	jns    d41 <exitwait+0x31>
      printf(1, "fork failed\n");
     d2d:	83 ec 08             	sub    $0x8,%esp
     d30:	68 cd 45 00 00       	push   $0x45cd
     d35:	6a 01                	push   $0x1
     d37:	e8 39 34 00 00       	call   4175 <printf>
     d3c:	83 c4 10             	add    $0x10,%esp
      return;
     d3f:	eb 45                	jmp    d86 <exitwait+0x76>
    }
    if(pid){
     d41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d45:	74 1e                	je     d65 <exitwait+0x55>
      if(wait() != pid){
     d47:	e8 b5 32 00 00       	call   4001 <wait>
     d4c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
     d4f:	74 19                	je     d6a <exitwait+0x5a>
        printf(1, "wait wrong pid\n");
     d51:	83 ec 08             	sub    $0x8,%esp
     d54:	68 4a 4a 00 00       	push   $0x4a4a
     d59:	6a 01                	push   $0x1
     d5b:	e8 15 34 00 00       	call   4175 <printf>
     d60:	83 c4 10             	add    $0x10,%esp
        return;
     d63:	eb 21                	jmp    d86 <exitwait+0x76>
      }
    } else {
      exit();
     d65:	e8 8f 32 00 00       	call   3ff9 <exit>
  for(i = 0; i < 100; i++){
     d6a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d6e:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     d72:	7e ab                	jle    d1f <exitwait+0xf>
    }
  }
  printf(1, "exitwait ok\n");
     d74:	83 ec 08             	sub    $0x8,%esp
     d77:	68 5a 4a 00 00       	push   $0x4a5a
     d7c:	6a 01                	push   $0x1
     d7e:	e8 f2 33 00 00       	call   4175 <printf>
     d83:	83 c4 10             	add    $0x10,%esp
}
     d86:	c9                   	leave
     d87:	c3                   	ret

00000d88 <mem>:

void
mem(void)
{
     d88:	55                   	push   %ebp
     d89:	89 e5                	mov    %esp,%ebp
     d8b:	83 ec 18             	sub    $0x18,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     d8e:	83 ec 08             	sub    $0x8,%esp
     d91:	68 67 4a 00 00       	push   $0x4a67
     d96:	6a 01                	push   $0x1
     d98:	e8 d8 33 00 00       	call   4175 <printf>
     d9d:	83 c4 10             	add    $0x10,%esp
  ppid = getpid();
     da0:	e8 d4 32 00 00       	call   4079 <getpid>
     da5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     da8:	e8 44 32 00 00       	call   3ff1 <fork>
     dad:	89 45 ec             	mov    %eax,-0x14(%ebp)
     db0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     db4:	0f 85 b7 00 00 00    	jne    e71 <mem+0xe9>
    m1 = 0;
     dba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     dc1:	eb 0e                	jmp    dd1 <mem+0x49>
      *(char**)m2 = m1;
     dc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
     dc9:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     dcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     dd1:	83 ec 0c             	sub    $0xc,%esp
     dd4:	68 11 27 00 00       	push   $0x2711
     dd9:	e8 6b 36 00 00       	call   4449 <malloc>
     dde:	83 c4 10             	add    $0x10,%esp
     de1:	89 45 e8             	mov    %eax,-0x18(%ebp)
     de4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     de8:	75 d9                	jne    dc3 <mem+0x3b>
    }
    while(m1){
     dea:	eb 1c                	jmp    e08 <mem+0x80>
      m2 = *(char**)m1;
     dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     def:	8b 00                	mov    (%eax),%eax
     df1:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     df4:	83 ec 0c             	sub    $0xc,%esp
     df7:	ff 75 f4             	push   -0xc(%ebp)
     dfa:	e8 08 35 00 00       	call   4307 <free>
     dff:	83 c4 10             	add    $0x10,%esp
      m1 = m2;
     e02:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e05:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(m1){
     e08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e0c:	75 de                	jne    dec <mem+0x64>
    }
    m1 = malloc(1024*20);
     e0e:	83 ec 0c             	sub    $0xc,%esp
     e11:	68 00 50 00 00       	push   $0x5000
     e16:	e8 2e 36 00 00       	call   4449 <malloc>
     e1b:	83 c4 10             	add    $0x10,%esp
     e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     e21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e25:	75 25                	jne    e4c <mem+0xc4>
      printf(1, "couldn't allocate mem?!!\n");
     e27:	83 ec 08             	sub    $0x8,%esp
     e2a:	68 71 4a 00 00       	push   $0x4a71
     e2f:	6a 01                	push   $0x1
     e31:	e8 3f 33 00 00       	call   4175 <printf>
     e36:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
     e39:	83 ec 0c             	sub    $0xc,%esp
     e3c:	ff 75 f0             	push   -0x10(%ebp)
     e3f:	e8 e5 31 00 00       	call   4029 <kill>
     e44:	83 c4 10             	add    $0x10,%esp
      exit();
     e47:	e8 ad 31 00 00       	call   3ff9 <exit>
    }
    free(m1);
     e4c:	83 ec 0c             	sub    $0xc,%esp
     e4f:	ff 75 f4             	push   -0xc(%ebp)
     e52:	e8 b0 34 00 00       	call   4307 <free>
     e57:	83 c4 10             	add    $0x10,%esp
    printf(1, "mem ok\n");
     e5a:	83 ec 08             	sub    $0x8,%esp
     e5d:	68 8b 4a 00 00       	push   $0x4a8b
     e62:	6a 01                	push   $0x1
     e64:	e8 0c 33 00 00       	call   4175 <printf>
     e69:	83 c4 10             	add    $0x10,%esp
    exit();
     e6c:	e8 88 31 00 00       	call   3ff9 <exit>
  } else {
    wait();
     e71:	e8 8b 31 00 00       	call   4001 <wait>
  }
}
     e76:	90                   	nop
     e77:	c9                   	leave
     e78:	c3                   	ret

00000e79 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     e79:	55                   	push   %ebp
     e7a:	89 e5                	mov    %esp,%ebp
     e7c:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     e7f:	83 ec 08             	sub    $0x8,%esp
     e82:	68 93 4a 00 00       	push   $0x4a93
     e87:	6a 01                	push   $0x1
     e89:	e8 e7 32 00 00       	call   4175 <printf>
     e8e:	83 c4 10             	add    $0x10,%esp

  unlink("sharedfd");
     e91:	83 ec 0c             	sub    $0xc,%esp
     e94:	68 a2 4a 00 00       	push   $0x4aa2
     e99:	e8 ab 31 00 00       	call   4049 <unlink>
     e9e:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", O_CREATE|O_RDWR);
     ea1:	83 ec 08             	sub    $0x8,%esp
     ea4:	68 02 02 00 00       	push   $0x202
     ea9:	68 a2 4a 00 00       	push   $0x4aa2
     eae:	e8 86 31 00 00       	call   4039 <open>
     eb3:	83 c4 10             	add    $0x10,%esp
     eb6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     eb9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     ebd:	79 17                	jns    ed6 <sharedfd+0x5d>
    printf(1, "fstests: cannot open sharedfd for writing");
     ebf:	83 ec 08             	sub    $0x8,%esp
     ec2:	68 ac 4a 00 00       	push   $0x4aac
     ec7:	6a 01                	push   $0x1
     ec9:	e8 a7 32 00 00       	call   4175 <printf>
     ece:	83 c4 10             	add    $0x10,%esp
    return;
     ed1:	e9 84 01 00 00       	jmp    105a <sharedfd+0x1e1>
  }
  pid = fork();
     ed6:	e8 16 31 00 00       	call   3ff1 <fork>
     edb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ede:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     ee2:	75 07                	jne    eeb <sharedfd+0x72>
     ee4:	b8 63 00 00 00       	mov    $0x63,%eax
     ee9:	eb 05                	jmp    ef0 <sharedfd+0x77>
     eeb:	b8 70 00 00 00       	mov    $0x70,%eax
     ef0:	83 ec 04             	sub    $0x4,%esp
     ef3:	6a 0a                	push   $0xa
     ef5:	50                   	push   %eax
     ef6:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     ef9:	50                   	push   %eax
     efa:	e8 5f 2f 00 00       	call   3e5e <memset>
     eff:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 1000; i++){
     f02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f09:	eb 31                	jmp    f3c <sharedfd+0xc3>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     f0b:	83 ec 04             	sub    $0x4,%esp
     f0e:	6a 0a                	push   $0xa
     f10:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f13:	50                   	push   %eax
     f14:	ff 75 e8             	push   -0x18(%ebp)
     f17:	e8 fd 30 00 00       	call   4019 <write>
     f1c:	83 c4 10             	add    $0x10,%esp
     f1f:	83 f8 0a             	cmp    $0xa,%eax
     f22:	74 14                	je     f38 <sharedfd+0xbf>
      printf(1, "fstests: write sharedfd failed\n");
     f24:	83 ec 08             	sub    $0x8,%esp
     f27:	68 d8 4a 00 00       	push   $0x4ad8
     f2c:	6a 01                	push   $0x1
     f2e:	e8 42 32 00 00       	call   4175 <printf>
     f33:	83 c4 10             	add    $0x10,%esp
      break;
     f36:	eb 0d                	jmp    f45 <sharedfd+0xcc>
  for(i = 0; i < 1000; i++){
     f38:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f3c:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     f43:	7e c6                	jle    f0b <sharedfd+0x92>
    }
  }
  if(pid == 0)
     f45:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     f49:	75 05                	jne    f50 <sharedfd+0xd7>
    exit();
     f4b:	e8 a9 30 00 00       	call   3ff9 <exit>
  else
    wait();
     f50:	e8 ac 30 00 00       	call   4001 <wait>
  close(fd);
     f55:	83 ec 0c             	sub    $0xc,%esp
     f58:	ff 75 e8             	push   -0x18(%ebp)
     f5b:	e8 c1 30 00 00       	call   4021 <close>
     f60:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", 0);
     f63:	83 ec 08             	sub    $0x8,%esp
     f66:	6a 00                	push   $0x0
     f68:	68 a2 4a 00 00       	push   $0x4aa2
     f6d:	e8 c7 30 00 00       	call   4039 <open>
     f72:	83 c4 10             	add    $0x10,%esp
     f75:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     f78:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     f7c:	79 17                	jns    f95 <sharedfd+0x11c>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f7e:	83 ec 08             	sub    $0x8,%esp
     f81:	68 f8 4a 00 00       	push   $0x4af8
     f86:	6a 01                	push   $0x1
     f88:	e8 e8 31 00 00       	call   4175 <printf>
     f8d:	83 c4 10             	add    $0x10,%esp
    return;
     f90:	e9 c5 00 00 00       	jmp    105a <sharedfd+0x1e1>
  }
  nc = np = 0;
     f95:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     f9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     fa2:	eb 3b                	jmp    fdf <sharedfd+0x166>
    for(i = 0; i < sizeof(buf); i++){
     fa4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     fab:	eb 2a                	jmp    fd7 <sharedfd+0x15e>
      if(buf[i] == 'c')
     fad:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fb3:	01 d0                	add    %edx,%eax
     fb5:	0f b6 00             	movzbl (%eax),%eax
     fb8:	3c 63                	cmp    $0x63,%al
     fba:	75 04                	jne    fc0 <sharedfd+0x147>
        nc++;
     fbc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
     fc0:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fc6:	01 d0                	add    %edx,%eax
     fc8:	0f b6 00             	movzbl (%eax),%eax
     fcb:	3c 70                	cmp    $0x70,%al
     fcd:	75 04                	jne    fd3 <sharedfd+0x15a>
        np++;
     fcf:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    for(i = 0; i < sizeof(buf); i++){
     fd3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fda:	83 f8 09             	cmp    $0x9,%eax
     fdd:	76 ce                	jbe    fad <sharedfd+0x134>
  while((n = read(fd, buf, sizeof(buf))) > 0){
     fdf:	83 ec 04             	sub    $0x4,%esp
     fe2:	6a 0a                	push   $0xa
     fe4:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     fe7:	50                   	push   %eax
     fe8:	ff 75 e8             	push   -0x18(%ebp)
     feb:	e8 21 30 00 00       	call   4011 <read>
     ff0:	83 c4 10             	add    $0x10,%esp
     ff3:	89 45 e0             	mov    %eax,-0x20(%ebp)
     ff6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     ffa:	7f a8                	jg     fa4 <sharedfd+0x12b>
    }
  }
  close(fd);
     ffc:	83 ec 0c             	sub    $0xc,%esp
     fff:	ff 75 e8             	push   -0x18(%ebp)
    1002:	e8 1a 30 00 00       	call   4021 <close>
    1007:	83 c4 10             	add    $0x10,%esp
  unlink("sharedfd");
    100a:	83 ec 0c             	sub    $0xc,%esp
    100d:	68 a2 4a 00 00       	push   $0x4aa2
    1012:	e8 32 30 00 00       	call   4049 <unlink>
    1017:	83 c4 10             	add    $0x10,%esp
  if(nc == 10000 && np == 10000){
    101a:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
    1021:	75 1d                	jne    1040 <sharedfd+0x1c7>
    1023:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
    102a:	75 14                	jne    1040 <sharedfd+0x1c7>
    printf(1, "sharedfd ok\n");
    102c:	83 ec 08             	sub    $0x8,%esp
    102f:	68 23 4b 00 00       	push   $0x4b23
    1034:	6a 01                	push   $0x1
    1036:	e8 3a 31 00 00       	call   4175 <printf>
    103b:	83 c4 10             	add    $0x10,%esp
    103e:	eb 1a                	jmp    105a <sharedfd+0x1e1>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    1040:	ff 75 ec             	push   -0x14(%ebp)
    1043:	ff 75 f0             	push   -0x10(%ebp)
    1046:	68 30 4b 00 00       	push   $0x4b30
    104b:	6a 01                	push   $0x1
    104d:	e8 23 31 00 00       	call   4175 <printf>
    1052:	83 c4 10             	add    $0x10,%esp
    exit();
    1055:	e8 9f 2f 00 00       	call   3ff9 <exit>
  }
}
    105a:	c9                   	leave
    105b:	c3                   	ret

0000105c <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    105c:	55                   	push   %ebp
    105d:	89 e5                	mov    %esp,%ebp
    105f:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    1062:	c7 45 c8 45 4b 00 00 	movl   $0x4b45,-0x38(%ebp)
    1069:	c7 45 cc 48 4b 00 00 	movl   $0x4b48,-0x34(%ebp)
    1070:	c7 45 d0 4b 4b 00 00 	movl   $0x4b4b,-0x30(%ebp)
    1077:	c7 45 d4 4e 4b 00 00 	movl   $0x4b4e,-0x2c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
    107e:	83 ec 08             	sub    $0x8,%esp
    1081:	68 51 4b 00 00       	push   $0x4b51
    1086:	6a 01                	push   $0x1
    1088:	e8 e8 30 00 00       	call   4175 <printf>
    108d:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    1090:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1097:	e9 f0 00 00 00       	jmp    118c <fourfiles+0x130>
    fname = names[pi];
    109c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    109f:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    10a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    unlink(fname);
    10a6:	83 ec 0c             	sub    $0xc,%esp
    10a9:	ff 75 e4             	push   -0x1c(%ebp)
    10ac:	e8 98 2f 00 00       	call   4049 <unlink>
    10b1:	83 c4 10             	add    $0x10,%esp

    pid = fork();
    10b4:	e8 38 2f 00 00       	call   3ff1 <fork>
    10b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if(pid < 0){
    10bc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    10c0:	79 17                	jns    10d9 <fourfiles+0x7d>
      printf(1, "fork failed\n");
    10c2:	83 ec 08             	sub    $0x8,%esp
    10c5:	68 cd 45 00 00       	push   $0x45cd
    10ca:	6a 01                	push   $0x1
    10cc:	e8 a4 30 00 00       	call   4175 <printf>
    10d1:	83 c4 10             	add    $0x10,%esp
      exit();
    10d4:	e8 20 2f 00 00       	call   3ff9 <exit>
    }

    if(pid == 0){
    10d9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    10dd:	0f 85 a5 00 00 00    	jne    1188 <fourfiles+0x12c>
      fd = open(fname, O_CREATE | O_RDWR);
    10e3:	83 ec 08             	sub    $0x8,%esp
    10e6:	68 02 02 00 00       	push   $0x202
    10eb:	ff 75 e4             	push   -0x1c(%ebp)
    10ee:	e8 46 2f 00 00       	call   4039 <open>
    10f3:	83 c4 10             	add    $0x10,%esp
    10f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(fd < 0){
    10f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10fd:	79 17                	jns    1116 <fourfiles+0xba>
        printf(1, "create failed\n");
    10ff:	83 ec 08             	sub    $0x8,%esp
    1102:	68 61 4b 00 00       	push   $0x4b61
    1107:	6a 01                	push   $0x1
    1109:	e8 67 30 00 00       	call   4175 <printf>
    110e:	83 c4 10             	add    $0x10,%esp
        exit();
    1111:	e8 e3 2e 00 00       	call   3ff9 <exit>
      }

      memset(buf, '0'+pi, 512);
    1116:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1119:	83 c0 30             	add    $0x30,%eax
    111c:	83 ec 04             	sub    $0x4,%esp
    111f:	68 00 02 00 00       	push   $0x200
    1124:	50                   	push   %eax
    1125:	68 a0 64 00 00       	push   $0x64a0
    112a:	e8 2f 2d 00 00       	call   3e5e <memset>
    112f:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < 12; i++){
    1132:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1139:	eb 42                	jmp    117d <fourfiles+0x121>
        if((n = write(fd, buf, 500)) != 500){
    113b:	83 ec 04             	sub    $0x4,%esp
    113e:	68 f4 01 00 00       	push   $0x1f4
    1143:	68 a0 64 00 00       	push   $0x64a0
    1148:	ff 75 e0             	push   -0x20(%ebp)
    114b:	e8 c9 2e 00 00       	call   4019 <write>
    1150:	83 c4 10             	add    $0x10,%esp
    1153:	89 45 dc             	mov    %eax,-0x24(%ebp)
    1156:	81 7d dc f4 01 00 00 	cmpl   $0x1f4,-0x24(%ebp)
    115d:	74 1a                	je     1179 <fourfiles+0x11d>
          printf(1, "write failed %d\n", n);
    115f:	83 ec 04             	sub    $0x4,%esp
    1162:	ff 75 dc             	push   -0x24(%ebp)
    1165:	68 70 4b 00 00       	push   $0x4b70
    116a:	6a 01                	push   $0x1
    116c:	e8 04 30 00 00       	call   4175 <printf>
    1171:	83 c4 10             	add    $0x10,%esp
          exit();
    1174:	e8 80 2e 00 00       	call   3ff9 <exit>
      for(i = 0; i < 12; i++){
    1179:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    117d:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    1181:	7e b8                	jle    113b <fourfiles+0xdf>
        }
      }
      exit();
    1183:	e8 71 2e 00 00       	call   3ff9 <exit>
  for(pi = 0; pi < 4; pi++){
    1188:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    118c:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    1190:	0f 8e 06 ff ff ff    	jle    109c <fourfiles+0x40>
    }
  }

  for(pi = 0; pi < 4; pi++){
    1196:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    119d:	eb 09                	jmp    11a8 <fourfiles+0x14c>
    wait();
    119f:	e8 5d 2e 00 00       	call   4001 <wait>
  for(pi = 0; pi < 4; pi++){
    11a4:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    11a8:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    11ac:	7e f1                	jle    119f <fourfiles+0x143>
  }

  for(i = 0; i < 2; i++){
    11ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11b5:	e9 d4 00 00 00       	jmp    128e <fourfiles+0x232>
    fname = names[i];
    11ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11bd:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    11c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    fd = open(fname, 0);
    11c4:	83 ec 08             	sub    $0x8,%esp
    11c7:	6a 00                	push   $0x0
    11c9:	ff 75 e4             	push   -0x1c(%ebp)
    11cc:	e8 68 2e 00 00       	call   4039 <open>
    11d1:	83 c4 10             	add    $0x10,%esp
    11d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    total = 0;
    11d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11de:	eb 4a                	jmp    122a <fourfiles+0x1ce>
      for(j = 0; j < n; j++){
    11e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    11e7:	eb 33                	jmp    121c <fourfiles+0x1c0>
        if(buf[j] != '0'+i){
    11e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11ec:	05 a0 64 00 00       	add    $0x64a0,%eax
    11f1:	0f b6 00             	movzbl (%eax),%eax
    11f4:	0f be d0             	movsbl %al,%edx
    11f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11fa:	83 c0 30             	add    $0x30,%eax
    11fd:	39 c2                	cmp    %eax,%edx
    11ff:	74 17                	je     1218 <fourfiles+0x1bc>
          printf(1, "wrong char\n");
    1201:	83 ec 08             	sub    $0x8,%esp
    1204:	68 81 4b 00 00       	push   $0x4b81
    1209:	6a 01                	push   $0x1
    120b:	e8 65 2f 00 00       	call   4175 <printf>
    1210:	83 c4 10             	add    $0x10,%esp
          exit();
    1213:	e8 e1 2d 00 00       	call   3ff9 <exit>
      for(j = 0; j < n; j++){
    1218:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    121c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    121f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
    1222:	7c c5                	jl     11e9 <fourfiles+0x18d>
        }
      }
      total += n;
    1224:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1227:	01 45 ec             	add    %eax,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    122a:	83 ec 04             	sub    $0x4,%esp
    122d:	68 00 20 00 00       	push   $0x2000
    1232:	68 a0 64 00 00       	push   $0x64a0
    1237:	ff 75 e0             	push   -0x20(%ebp)
    123a:	e8 d2 2d 00 00       	call   4011 <read>
    123f:	83 c4 10             	add    $0x10,%esp
    1242:	89 45 dc             	mov    %eax,-0x24(%ebp)
    1245:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    1249:	7f 95                	jg     11e0 <fourfiles+0x184>
    }
    close(fd);
    124b:	83 ec 0c             	sub    $0xc,%esp
    124e:	ff 75 e0             	push   -0x20(%ebp)
    1251:	e8 cb 2d 00 00       	call   4021 <close>
    1256:	83 c4 10             	add    $0x10,%esp
    if(total != 12*500){
    1259:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
    1260:	74 1a                	je     127c <fourfiles+0x220>
      printf(1, "wrong length %d\n", total);
    1262:	83 ec 04             	sub    $0x4,%esp
    1265:	ff 75 ec             	push   -0x14(%ebp)
    1268:	68 8d 4b 00 00       	push   $0x4b8d
    126d:	6a 01                	push   $0x1
    126f:	e8 01 2f 00 00       	call   4175 <printf>
    1274:	83 c4 10             	add    $0x10,%esp
      exit();
    1277:	e8 7d 2d 00 00       	call   3ff9 <exit>
    }
    unlink(fname);
    127c:	83 ec 0c             	sub    $0xc,%esp
    127f:	ff 75 e4             	push   -0x1c(%ebp)
    1282:	e8 c2 2d 00 00       	call   4049 <unlink>
    1287:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 2; i++){
    128a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    128e:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    1292:	0f 8e 22 ff ff ff    	jle    11ba <fourfiles+0x15e>
  }

  printf(1, "fourfiles ok\n");
    1298:	83 ec 08             	sub    $0x8,%esp
    129b:	68 9e 4b 00 00       	push   $0x4b9e
    12a0:	6a 01                	push   $0x1
    12a2:	e8 ce 2e 00 00       	call   4175 <printf>
    12a7:	83 c4 10             	add    $0x10,%esp
}
    12aa:	90                   	nop
    12ab:	c9                   	leave
    12ac:	c3                   	ret

000012ad <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    12ad:	55                   	push   %ebp
    12ae:	89 e5                	mov    %esp,%ebp
    12b0:	83 ec 38             	sub    $0x38,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    12b3:	83 ec 08             	sub    $0x8,%esp
    12b6:	68 ac 4b 00 00       	push   $0x4bac
    12bb:	6a 01                	push   $0x1
    12bd:	e8 b3 2e 00 00       	call   4175 <printf>
    12c2:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    12c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    12cc:	e9 f6 00 00 00       	jmp    13c7 <createdelete+0x11a>
    pid = fork();
    12d1:	e8 1b 2d 00 00       	call   3ff1 <fork>
    12d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid < 0){
    12d9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    12dd:	79 17                	jns    12f6 <createdelete+0x49>
      printf(1, "fork failed\n");
    12df:	83 ec 08             	sub    $0x8,%esp
    12e2:	68 cd 45 00 00       	push   $0x45cd
    12e7:	6a 01                	push   $0x1
    12e9:	e8 87 2e 00 00       	call   4175 <printf>
    12ee:	83 c4 10             	add    $0x10,%esp
      exit();
    12f1:	e8 03 2d 00 00       	call   3ff9 <exit>
    }

    if(pid == 0){
    12f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    12fa:	0f 85 c3 00 00 00    	jne    13c3 <createdelete+0x116>
      name[0] = 'p' + pi;
    1300:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1303:	83 c0 70             	add    $0x70,%eax
    1306:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    1309:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    130d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1314:	e9 9b 00 00 00       	jmp    13b4 <createdelete+0x107>
        name[1] = '0' + i;
    1319:	8b 45 f4             	mov    -0xc(%ebp),%eax
    131c:	83 c0 30             	add    $0x30,%eax
    131f:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    1322:	83 ec 08             	sub    $0x8,%esp
    1325:	68 02 02 00 00       	push   $0x202
    132a:	8d 45 c8             	lea    -0x38(%ebp),%eax
    132d:	50                   	push   %eax
    132e:	e8 06 2d 00 00       	call   4039 <open>
    1333:	83 c4 10             	add    $0x10,%esp
    1336:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if(fd < 0){
    1339:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    133d:	79 17                	jns    1356 <createdelete+0xa9>
          printf(1, "create failed\n");
    133f:	83 ec 08             	sub    $0x8,%esp
    1342:	68 61 4b 00 00       	push   $0x4b61
    1347:	6a 01                	push   $0x1
    1349:	e8 27 2e 00 00       	call   4175 <printf>
    134e:	83 c4 10             	add    $0x10,%esp
          exit();
    1351:	e8 a3 2c 00 00       	call   3ff9 <exit>
        }
        close(fd);
    1356:	83 ec 0c             	sub    $0xc,%esp
    1359:	ff 75 ec             	push   -0x14(%ebp)
    135c:	e8 c0 2c 00 00       	call   4021 <close>
    1361:	83 c4 10             	add    $0x10,%esp
        if(i > 0 && (i % 2 ) == 0){
    1364:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1368:	7e 46                	jle    13b0 <createdelete+0x103>
    136a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    136d:	83 e0 01             	and    $0x1,%eax
    1370:	85 c0                	test   %eax,%eax
    1372:	75 3c                	jne    13b0 <createdelete+0x103>
          name[1] = '0' + (i / 2);
    1374:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1377:	89 c2                	mov    %eax,%edx
    1379:	c1 ea 1f             	shr    $0x1f,%edx
    137c:	01 d0                	add    %edx,%eax
    137e:	d1 f8                	sar    $1,%eax
    1380:	83 c0 30             	add    $0x30,%eax
    1383:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    1386:	83 ec 0c             	sub    $0xc,%esp
    1389:	8d 45 c8             	lea    -0x38(%ebp),%eax
    138c:	50                   	push   %eax
    138d:	e8 b7 2c 00 00       	call   4049 <unlink>
    1392:	83 c4 10             	add    $0x10,%esp
    1395:	85 c0                	test   %eax,%eax
    1397:	79 17                	jns    13b0 <createdelete+0x103>
            printf(1, "unlink failed\n");
    1399:	83 ec 08             	sub    $0x8,%esp
    139c:	68 50 46 00 00       	push   $0x4650
    13a1:	6a 01                	push   $0x1
    13a3:	e8 cd 2d 00 00       	call   4175 <printf>
    13a8:	83 c4 10             	add    $0x10,%esp
            exit();
    13ab:	e8 49 2c 00 00       	call   3ff9 <exit>
      for(i = 0; i < N; i++){
    13b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    13b4:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    13b8:	0f 8e 5b ff ff ff    	jle    1319 <createdelete+0x6c>
          }
        }
      }
      exit();
    13be:	e8 36 2c 00 00       	call   3ff9 <exit>
  for(pi = 0; pi < 4; pi++){
    13c3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    13c7:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13cb:	0f 8e 00 ff ff ff    	jle    12d1 <createdelete+0x24>
    }
  }

  for(pi = 0; pi < 4; pi++){
    13d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13d8:	eb 09                	jmp    13e3 <createdelete+0x136>
    wait();
    13da:	e8 22 2c 00 00       	call   4001 <wait>
  for(pi = 0; pi < 4; pi++){
    13df:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    13e3:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13e7:	7e f1                	jle    13da <createdelete+0x12d>
  }

  name[0] = name[1] = name[2] = 0;
    13e9:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    13ed:	0f b6 45 ca          	movzbl -0x36(%ebp),%eax
    13f1:	88 45 c9             	mov    %al,-0x37(%ebp)
    13f4:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
    13f8:	88 45 c8             	mov    %al,-0x38(%ebp)
  for(i = 0; i < N; i++){
    13fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1402:	e9 b2 00 00 00       	jmp    14b9 <createdelete+0x20c>
    for(pi = 0; pi < 4; pi++){
    1407:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    140e:	e9 98 00 00 00       	jmp    14ab <createdelete+0x1fe>
      name[0] = 'p' + pi;
    1413:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1416:	83 c0 70             	add    $0x70,%eax
    1419:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    141c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    141f:	83 c0 30             	add    $0x30,%eax
    1422:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    1425:	83 ec 08             	sub    $0x8,%esp
    1428:	6a 00                	push   $0x0
    142a:	8d 45 c8             	lea    -0x38(%ebp),%eax
    142d:	50                   	push   %eax
    142e:	e8 06 2c 00 00       	call   4039 <open>
    1433:	83 c4 10             	add    $0x10,%esp
    1436:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if((i == 0 || i >= N/2) && fd < 0){
    1439:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    143d:	74 06                	je     1445 <createdelete+0x198>
    143f:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1443:	7e 21                	jle    1466 <createdelete+0x1b9>
    1445:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1449:	79 1b                	jns    1466 <createdelete+0x1b9>
        printf(1, "oops createdelete %s didn't exist\n", name);
    144b:	83 ec 04             	sub    $0x4,%esp
    144e:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1451:	50                   	push   %eax
    1452:	68 c0 4b 00 00       	push   $0x4bc0
    1457:	6a 01                	push   $0x1
    1459:	e8 17 2d 00 00       	call   4175 <printf>
    145e:	83 c4 10             	add    $0x10,%esp
        exit();
    1461:	e8 93 2b 00 00       	call   3ff9 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1466:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    146a:	7e 27                	jle    1493 <createdelete+0x1e6>
    146c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1470:	7f 21                	jg     1493 <createdelete+0x1e6>
    1472:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1476:	78 1b                	js     1493 <createdelete+0x1e6>
        printf(1, "oops createdelete %s did exist\n", name);
    1478:	83 ec 04             	sub    $0x4,%esp
    147b:	8d 45 c8             	lea    -0x38(%ebp),%eax
    147e:	50                   	push   %eax
    147f:	68 e4 4b 00 00       	push   $0x4be4
    1484:	6a 01                	push   $0x1
    1486:	e8 ea 2c 00 00       	call   4175 <printf>
    148b:	83 c4 10             	add    $0x10,%esp
        exit();
    148e:	e8 66 2b 00 00       	call   3ff9 <exit>
      }
      if(fd >= 0)
    1493:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1497:	78 0e                	js     14a7 <createdelete+0x1fa>
        close(fd);
    1499:	83 ec 0c             	sub    $0xc,%esp
    149c:	ff 75 ec             	push   -0x14(%ebp)
    149f:	e8 7d 2b 00 00       	call   4021 <close>
    14a4:	83 c4 10             	add    $0x10,%esp
    for(pi = 0; pi < 4; pi++){
    14a7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    14ab:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14af:	0f 8e 5e ff ff ff    	jle    1413 <createdelete+0x166>
  for(i = 0; i < N; i++){
    14b5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    14b9:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    14bd:	0f 8e 44 ff ff ff    	jle    1407 <createdelete+0x15a>
    }
  }

  for(i = 0; i < N; i++){
    14c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    14ca:	eb 38                	jmp    1504 <createdelete+0x257>
    for(pi = 0; pi < 4; pi++){
    14cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14d3:	eb 25                	jmp    14fa <createdelete+0x24d>
      name[0] = 'p' + i;
    14d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d8:	83 c0 70             	add    $0x70,%eax
    14db:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    14de:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e1:	83 c0 30             	add    $0x30,%eax
    14e4:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    14e7:	83 ec 0c             	sub    $0xc,%esp
    14ea:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14ed:	50                   	push   %eax
    14ee:	e8 56 2b 00 00       	call   4049 <unlink>
    14f3:	83 c4 10             	add    $0x10,%esp
    for(pi = 0; pi < 4; pi++){
    14f6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    14fa:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14fe:	7e d5                	jle    14d5 <createdelete+0x228>
  for(i = 0; i < N; i++){
    1500:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1504:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1508:	7e c2                	jle    14cc <createdelete+0x21f>
    }
  }

  printf(1, "createdelete ok\n");
    150a:	83 ec 08             	sub    $0x8,%esp
    150d:	68 04 4c 00 00       	push   $0x4c04
    1512:	6a 01                	push   $0x1
    1514:	e8 5c 2c 00 00       	call   4175 <printf>
    1519:	83 c4 10             	add    $0x10,%esp
}
    151c:	90                   	nop
    151d:	c9                   	leave
    151e:	c3                   	ret

0000151f <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    151f:	55                   	push   %ebp
    1520:	89 e5                	mov    %esp,%ebp
    1522:	83 ec 18             	sub    $0x18,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1525:	83 ec 08             	sub    $0x8,%esp
    1528:	68 15 4c 00 00       	push   $0x4c15
    152d:	6a 01                	push   $0x1
    152f:	e8 41 2c 00 00       	call   4175 <printf>
    1534:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1537:	83 ec 08             	sub    $0x8,%esp
    153a:	68 02 02 00 00       	push   $0x202
    153f:	68 26 4c 00 00       	push   $0x4c26
    1544:	e8 f0 2a 00 00       	call   4039 <open>
    1549:	83 c4 10             	add    $0x10,%esp
    154c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    154f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1553:	79 17                	jns    156c <unlinkread+0x4d>
    printf(1, "create unlinkread failed\n");
    1555:	83 ec 08             	sub    $0x8,%esp
    1558:	68 31 4c 00 00       	push   $0x4c31
    155d:	6a 01                	push   $0x1
    155f:	e8 11 2c 00 00       	call   4175 <printf>
    1564:	83 c4 10             	add    $0x10,%esp
    exit();
    1567:	e8 8d 2a 00 00       	call   3ff9 <exit>
  }
  write(fd, "hello", 5);
    156c:	83 ec 04             	sub    $0x4,%esp
    156f:	6a 05                	push   $0x5
    1571:	68 4b 4c 00 00       	push   $0x4c4b
    1576:	ff 75 f4             	push   -0xc(%ebp)
    1579:	e8 9b 2a 00 00       	call   4019 <write>
    157e:	83 c4 10             	add    $0x10,%esp
  close(fd);
    1581:	83 ec 0c             	sub    $0xc,%esp
    1584:	ff 75 f4             	push   -0xc(%ebp)
    1587:	e8 95 2a 00 00       	call   4021 <close>
    158c:	83 c4 10             	add    $0x10,%esp

  fd = open("unlinkread", O_RDWR);
    158f:	83 ec 08             	sub    $0x8,%esp
    1592:	6a 02                	push   $0x2
    1594:	68 26 4c 00 00       	push   $0x4c26
    1599:	e8 9b 2a 00 00       	call   4039 <open>
    159e:	83 c4 10             	add    $0x10,%esp
    15a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    15a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15a8:	79 17                	jns    15c1 <unlinkread+0xa2>
    printf(1, "open unlinkread failed\n");
    15aa:	83 ec 08             	sub    $0x8,%esp
    15ad:	68 51 4c 00 00       	push   $0x4c51
    15b2:	6a 01                	push   $0x1
    15b4:	e8 bc 2b 00 00       	call   4175 <printf>
    15b9:	83 c4 10             	add    $0x10,%esp
    exit();
    15bc:	e8 38 2a 00 00       	call   3ff9 <exit>
  }
  if(unlink("unlinkread") != 0){
    15c1:	83 ec 0c             	sub    $0xc,%esp
    15c4:	68 26 4c 00 00       	push   $0x4c26
    15c9:	e8 7b 2a 00 00       	call   4049 <unlink>
    15ce:	83 c4 10             	add    $0x10,%esp
    15d1:	85 c0                	test   %eax,%eax
    15d3:	74 17                	je     15ec <unlinkread+0xcd>
    printf(1, "unlink unlinkread failed\n");
    15d5:	83 ec 08             	sub    $0x8,%esp
    15d8:	68 69 4c 00 00       	push   $0x4c69
    15dd:	6a 01                	push   $0x1
    15df:	e8 91 2b 00 00       	call   4175 <printf>
    15e4:	83 c4 10             	add    $0x10,%esp
    exit();
    15e7:	e8 0d 2a 00 00       	call   3ff9 <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    15ec:	83 ec 08             	sub    $0x8,%esp
    15ef:	68 02 02 00 00       	push   $0x202
    15f4:	68 26 4c 00 00       	push   $0x4c26
    15f9:	e8 3b 2a 00 00       	call   4039 <open>
    15fe:	83 c4 10             	add    $0x10,%esp
    1601:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    1604:	83 ec 04             	sub    $0x4,%esp
    1607:	6a 03                	push   $0x3
    1609:	68 83 4c 00 00       	push   $0x4c83
    160e:	ff 75 f0             	push   -0x10(%ebp)
    1611:	e8 03 2a 00 00       	call   4019 <write>
    1616:	83 c4 10             	add    $0x10,%esp
  close(fd1);
    1619:	83 ec 0c             	sub    $0xc,%esp
    161c:	ff 75 f0             	push   -0x10(%ebp)
    161f:	e8 fd 29 00 00       	call   4021 <close>
    1624:	83 c4 10             	add    $0x10,%esp

  if(read(fd, buf, sizeof(buf)) != 5){
    1627:	83 ec 04             	sub    $0x4,%esp
    162a:	68 00 20 00 00       	push   $0x2000
    162f:	68 a0 64 00 00       	push   $0x64a0
    1634:	ff 75 f4             	push   -0xc(%ebp)
    1637:	e8 d5 29 00 00       	call   4011 <read>
    163c:	83 c4 10             	add    $0x10,%esp
    163f:	83 f8 05             	cmp    $0x5,%eax
    1642:	74 17                	je     165b <unlinkread+0x13c>
    printf(1, "unlinkread read failed");
    1644:	83 ec 08             	sub    $0x8,%esp
    1647:	68 87 4c 00 00       	push   $0x4c87
    164c:	6a 01                	push   $0x1
    164e:	e8 22 2b 00 00       	call   4175 <printf>
    1653:	83 c4 10             	add    $0x10,%esp
    exit();
    1656:	e8 9e 29 00 00       	call   3ff9 <exit>
  }
  if(buf[0] != 'h'){
    165b:	0f b6 05 a0 64 00 00 	movzbl 0x64a0,%eax
    1662:	3c 68                	cmp    $0x68,%al
    1664:	74 17                	je     167d <unlinkread+0x15e>
    printf(1, "unlinkread wrong data\n");
    1666:	83 ec 08             	sub    $0x8,%esp
    1669:	68 9e 4c 00 00       	push   $0x4c9e
    166e:	6a 01                	push   $0x1
    1670:	e8 00 2b 00 00       	call   4175 <printf>
    1675:	83 c4 10             	add    $0x10,%esp
    exit();
    1678:	e8 7c 29 00 00       	call   3ff9 <exit>
  }
  if(write(fd, buf, 10) != 10){
    167d:	83 ec 04             	sub    $0x4,%esp
    1680:	6a 0a                	push   $0xa
    1682:	68 a0 64 00 00       	push   $0x64a0
    1687:	ff 75 f4             	push   -0xc(%ebp)
    168a:	e8 8a 29 00 00       	call   4019 <write>
    168f:	83 c4 10             	add    $0x10,%esp
    1692:	83 f8 0a             	cmp    $0xa,%eax
    1695:	74 17                	je     16ae <unlinkread+0x18f>
    printf(1, "unlinkread write failed\n");
    1697:	83 ec 08             	sub    $0x8,%esp
    169a:	68 b5 4c 00 00       	push   $0x4cb5
    169f:	6a 01                	push   $0x1
    16a1:	e8 cf 2a 00 00       	call   4175 <printf>
    16a6:	83 c4 10             	add    $0x10,%esp
    exit();
    16a9:	e8 4b 29 00 00       	call   3ff9 <exit>
  }
  close(fd);
    16ae:	83 ec 0c             	sub    $0xc,%esp
    16b1:	ff 75 f4             	push   -0xc(%ebp)
    16b4:	e8 68 29 00 00       	call   4021 <close>
    16b9:	83 c4 10             	add    $0x10,%esp
  unlink("unlinkread");
    16bc:	83 ec 0c             	sub    $0xc,%esp
    16bf:	68 26 4c 00 00       	push   $0x4c26
    16c4:	e8 80 29 00 00       	call   4049 <unlink>
    16c9:	83 c4 10             	add    $0x10,%esp
  printf(1, "unlinkread ok\n");
    16cc:	83 ec 08             	sub    $0x8,%esp
    16cf:	68 ce 4c 00 00       	push   $0x4cce
    16d4:	6a 01                	push   $0x1
    16d6:	e8 9a 2a 00 00       	call   4175 <printf>
    16db:	83 c4 10             	add    $0x10,%esp
}
    16de:	90                   	nop
    16df:	c9                   	leave
    16e0:	c3                   	ret

000016e1 <linktest>:

void
linktest(void)
{
    16e1:	55                   	push   %ebp
    16e2:	89 e5                	mov    %esp,%ebp
    16e4:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "linktest\n");
    16e7:	83 ec 08             	sub    $0x8,%esp
    16ea:	68 dd 4c 00 00       	push   $0x4cdd
    16ef:	6a 01                	push   $0x1
    16f1:	e8 7f 2a 00 00       	call   4175 <printf>
    16f6:	83 c4 10             	add    $0x10,%esp

  unlink("lf1");
    16f9:	83 ec 0c             	sub    $0xc,%esp
    16fc:	68 e7 4c 00 00       	push   $0x4ce7
    1701:	e8 43 29 00 00       	call   4049 <unlink>
    1706:	83 c4 10             	add    $0x10,%esp
  unlink("lf2");
    1709:	83 ec 0c             	sub    $0xc,%esp
    170c:	68 eb 4c 00 00       	push   $0x4ceb
    1711:	e8 33 29 00 00       	call   4049 <unlink>
    1716:	83 c4 10             	add    $0x10,%esp

  fd = open("lf1", O_CREATE|O_RDWR);
    1719:	83 ec 08             	sub    $0x8,%esp
    171c:	68 02 02 00 00       	push   $0x202
    1721:	68 e7 4c 00 00       	push   $0x4ce7
    1726:	e8 0e 29 00 00       	call   4039 <open>
    172b:	83 c4 10             	add    $0x10,%esp
    172e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1735:	79 17                	jns    174e <linktest+0x6d>
    printf(1, "create lf1 failed\n");
    1737:	83 ec 08             	sub    $0x8,%esp
    173a:	68 ef 4c 00 00       	push   $0x4cef
    173f:	6a 01                	push   $0x1
    1741:	e8 2f 2a 00 00       	call   4175 <printf>
    1746:	83 c4 10             	add    $0x10,%esp
    exit();
    1749:	e8 ab 28 00 00       	call   3ff9 <exit>
  }
  if(write(fd, "hello", 5) != 5){
    174e:	83 ec 04             	sub    $0x4,%esp
    1751:	6a 05                	push   $0x5
    1753:	68 4b 4c 00 00       	push   $0x4c4b
    1758:	ff 75 f4             	push   -0xc(%ebp)
    175b:	e8 b9 28 00 00       	call   4019 <write>
    1760:	83 c4 10             	add    $0x10,%esp
    1763:	83 f8 05             	cmp    $0x5,%eax
    1766:	74 17                	je     177f <linktest+0x9e>
    printf(1, "write lf1 failed\n");
    1768:	83 ec 08             	sub    $0x8,%esp
    176b:	68 02 4d 00 00       	push   $0x4d02
    1770:	6a 01                	push   $0x1
    1772:	e8 fe 29 00 00       	call   4175 <printf>
    1777:	83 c4 10             	add    $0x10,%esp
    exit();
    177a:	e8 7a 28 00 00       	call   3ff9 <exit>
  }
  close(fd);
    177f:	83 ec 0c             	sub    $0xc,%esp
    1782:	ff 75 f4             	push   -0xc(%ebp)
    1785:	e8 97 28 00 00       	call   4021 <close>
    178a:	83 c4 10             	add    $0x10,%esp

  if(link("lf1", "lf2") < 0){
    178d:	83 ec 08             	sub    $0x8,%esp
    1790:	68 eb 4c 00 00       	push   $0x4ceb
    1795:	68 e7 4c 00 00       	push   $0x4ce7
    179a:	e8 ba 28 00 00       	call   4059 <link>
    179f:	83 c4 10             	add    $0x10,%esp
    17a2:	85 c0                	test   %eax,%eax
    17a4:	79 17                	jns    17bd <linktest+0xdc>
    printf(1, "link lf1 lf2 failed\n");
    17a6:	83 ec 08             	sub    $0x8,%esp
    17a9:	68 14 4d 00 00       	push   $0x4d14
    17ae:	6a 01                	push   $0x1
    17b0:	e8 c0 29 00 00       	call   4175 <printf>
    17b5:	83 c4 10             	add    $0x10,%esp
    exit();
    17b8:	e8 3c 28 00 00       	call   3ff9 <exit>
  }
  unlink("lf1");
    17bd:	83 ec 0c             	sub    $0xc,%esp
    17c0:	68 e7 4c 00 00       	push   $0x4ce7
    17c5:	e8 7f 28 00 00       	call   4049 <unlink>
    17ca:	83 c4 10             	add    $0x10,%esp

  if(open("lf1", 0) >= 0){
    17cd:	83 ec 08             	sub    $0x8,%esp
    17d0:	6a 00                	push   $0x0
    17d2:	68 e7 4c 00 00       	push   $0x4ce7
    17d7:	e8 5d 28 00 00       	call   4039 <open>
    17dc:	83 c4 10             	add    $0x10,%esp
    17df:	85 c0                	test   %eax,%eax
    17e1:	78 17                	js     17fa <linktest+0x119>
    printf(1, "unlinked lf1 but it is still there!\n");
    17e3:	83 ec 08             	sub    $0x8,%esp
    17e6:	68 2c 4d 00 00       	push   $0x4d2c
    17eb:	6a 01                	push   $0x1
    17ed:	e8 83 29 00 00       	call   4175 <printf>
    17f2:	83 c4 10             	add    $0x10,%esp
    exit();
    17f5:	e8 ff 27 00 00       	call   3ff9 <exit>
  }

  fd = open("lf2", 0);
    17fa:	83 ec 08             	sub    $0x8,%esp
    17fd:	6a 00                	push   $0x0
    17ff:	68 eb 4c 00 00       	push   $0x4ceb
    1804:	e8 30 28 00 00       	call   4039 <open>
    1809:	83 c4 10             	add    $0x10,%esp
    180c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    180f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1813:	79 17                	jns    182c <linktest+0x14b>
    printf(1, "open lf2 failed\n");
    1815:	83 ec 08             	sub    $0x8,%esp
    1818:	68 51 4d 00 00       	push   $0x4d51
    181d:	6a 01                	push   $0x1
    181f:	e8 51 29 00 00       	call   4175 <printf>
    1824:	83 c4 10             	add    $0x10,%esp
    exit();
    1827:	e8 cd 27 00 00       	call   3ff9 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    182c:	83 ec 04             	sub    $0x4,%esp
    182f:	68 00 20 00 00       	push   $0x2000
    1834:	68 a0 64 00 00       	push   $0x64a0
    1839:	ff 75 f4             	push   -0xc(%ebp)
    183c:	e8 d0 27 00 00       	call   4011 <read>
    1841:	83 c4 10             	add    $0x10,%esp
    1844:	83 f8 05             	cmp    $0x5,%eax
    1847:	74 17                	je     1860 <linktest+0x17f>
    printf(1, "read lf2 failed\n");
    1849:	83 ec 08             	sub    $0x8,%esp
    184c:	68 62 4d 00 00       	push   $0x4d62
    1851:	6a 01                	push   $0x1
    1853:	e8 1d 29 00 00       	call   4175 <printf>
    1858:	83 c4 10             	add    $0x10,%esp
    exit();
    185b:	e8 99 27 00 00       	call   3ff9 <exit>
  }
  close(fd);
    1860:	83 ec 0c             	sub    $0xc,%esp
    1863:	ff 75 f4             	push   -0xc(%ebp)
    1866:	e8 b6 27 00 00       	call   4021 <close>
    186b:	83 c4 10             	add    $0x10,%esp

  if(link("lf2", "lf2") >= 0){
    186e:	83 ec 08             	sub    $0x8,%esp
    1871:	68 eb 4c 00 00       	push   $0x4ceb
    1876:	68 eb 4c 00 00       	push   $0x4ceb
    187b:	e8 d9 27 00 00       	call   4059 <link>
    1880:	83 c4 10             	add    $0x10,%esp
    1883:	85 c0                	test   %eax,%eax
    1885:	78 17                	js     189e <linktest+0x1bd>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1887:	83 ec 08             	sub    $0x8,%esp
    188a:	68 73 4d 00 00       	push   $0x4d73
    188f:	6a 01                	push   $0x1
    1891:	e8 df 28 00 00       	call   4175 <printf>
    1896:	83 c4 10             	add    $0x10,%esp
    exit();
    1899:	e8 5b 27 00 00       	call   3ff9 <exit>
  }

  unlink("lf2");
    189e:	83 ec 0c             	sub    $0xc,%esp
    18a1:	68 eb 4c 00 00       	push   $0x4ceb
    18a6:	e8 9e 27 00 00       	call   4049 <unlink>
    18ab:	83 c4 10             	add    $0x10,%esp
  if(link("lf2", "lf1") >= 0){
    18ae:	83 ec 08             	sub    $0x8,%esp
    18b1:	68 e7 4c 00 00       	push   $0x4ce7
    18b6:	68 eb 4c 00 00       	push   $0x4ceb
    18bb:	e8 99 27 00 00       	call   4059 <link>
    18c0:	83 c4 10             	add    $0x10,%esp
    18c3:	85 c0                	test   %eax,%eax
    18c5:	78 17                	js     18de <linktest+0x1fd>
    printf(1, "link non-existant succeeded! oops\n");
    18c7:	83 ec 08             	sub    $0x8,%esp
    18ca:	68 94 4d 00 00       	push   $0x4d94
    18cf:	6a 01                	push   $0x1
    18d1:	e8 9f 28 00 00       	call   4175 <printf>
    18d6:	83 c4 10             	add    $0x10,%esp
    exit();
    18d9:	e8 1b 27 00 00       	call   3ff9 <exit>
  }

  if(link(".", "lf1") >= 0){
    18de:	83 ec 08             	sub    $0x8,%esp
    18e1:	68 e7 4c 00 00       	push   $0x4ce7
    18e6:	68 b7 4d 00 00       	push   $0x4db7
    18eb:	e8 69 27 00 00       	call   4059 <link>
    18f0:	83 c4 10             	add    $0x10,%esp
    18f3:	85 c0                	test   %eax,%eax
    18f5:	78 17                	js     190e <linktest+0x22d>
    printf(1, "link . lf1 succeeded! oops\n");
    18f7:	83 ec 08             	sub    $0x8,%esp
    18fa:	68 b9 4d 00 00       	push   $0x4db9
    18ff:	6a 01                	push   $0x1
    1901:	e8 6f 28 00 00       	call   4175 <printf>
    1906:	83 c4 10             	add    $0x10,%esp
    exit();
    1909:	e8 eb 26 00 00       	call   3ff9 <exit>
  }

  printf(1, "linktest ok\n");
    190e:	83 ec 08             	sub    $0x8,%esp
    1911:	68 d5 4d 00 00       	push   $0x4dd5
    1916:	6a 01                	push   $0x1
    1918:	e8 58 28 00 00       	call   4175 <printf>
    191d:	83 c4 10             	add    $0x10,%esp
}
    1920:	90                   	nop
    1921:	c9                   	leave
    1922:	c3                   	ret

00001923 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1923:	55                   	push   %ebp
    1924:	89 e5                	mov    %esp,%ebp
    1926:	83 ec 58             	sub    $0x58,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    1929:	83 ec 08             	sub    $0x8,%esp
    192c:	68 e2 4d 00 00       	push   $0x4de2
    1931:	6a 01                	push   $0x1
    1933:	e8 3d 28 00 00       	call   4175 <printf>
    1938:	83 c4 10             	add    $0x10,%esp
  file[0] = 'C';
    193b:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    193f:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    1943:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    194a:	e9 fc 00 00 00       	jmp    1a4b <concreate+0x128>
    file[1] = '0' + i;
    194f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1952:	83 c0 30             	add    $0x30,%eax
    1955:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    1958:	83 ec 0c             	sub    $0xc,%esp
    195b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    195e:	50                   	push   %eax
    195f:	e8 e5 26 00 00       	call   4049 <unlink>
    1964:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    1967:	e8 85 26 00 00       	call   3ff1 <fork>
    196c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid && (i % 3) == 1){
    196f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1973:	74 3b                	je     19b0 <concreate+0x8d>
    1975:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1978:	ba 56 55 55 55       	mov    $0x55555556,%edx
    197d:	89 c8                	mov    %ecx,%eax
    197f:	f7 ea                	imul   %edx
    1981:	89 c8                	mov    %ecx,%eax
    1983:	c1 f8 1f             	sar    $0x1f,%eax
    1986:	29 c2                	sub    %eax,%edx
    1988:	89 d0                	mov    %edx,%eax
    198a:	01 c0                	add    %eax,%eax
    198c:	01 d0                	add    %edx,%eax
    198e:	29 c1                	sub    %eax,%ecx
    1990:	89 ca                	mov    %ecx,%edx
    1992:	83 fa 01             	cmp    $0x1,%edx
    1995:	75 19                	jne    19b0 <concreate+0x8d>
      link("C0", file);
    1997:	83 ec 08             	sub    $0x8,%esp
    199a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    199d:	50                   	push   %eax
    199e:	68 f2 4d 00 00       	push   $0x4df2
    19a3:	e8 b1 26 00 00       	call   4059 <link>
    19a8:	83 c4 10             	add    $0x10,%esp
    19ab:	e9 87 00 00 00       	jmp    1a37 <concreate+0x114>
    } else if(pid == 0 && (i % 5) == 1){
    19b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    19b4:	75 3b                	jne    19f1 <concreate+0xce>
    19b6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    19b9:	ba 67 66 66 66       	mov    $0x66666667,%edx
    19be:	89 c8                	mov    %ecx,%eax
    19c0:	f7 ea                	imul   %edx
    19c2:	d1 fa                	sar    $1,%edx
    19c4:	89 c8                	mov    %ecx,%eax
    19c6:	c1 f8 1f             	sar    $0x1f,%eax
    19c9:	29 c2                	sub    %eax,%edx
    19cb:	89 d0                	mov    %edx,%eax
    19cd:	c1 e0 02             	shl    $0x2,%eax
    19d0:	01 d0                	add    %edx,%eax
    19d2:	29 c1                	sub    %eax,%ecx
    19d4:	89 ca                	mov    %ecx,%edx
    19d6:	83 fa 01             	cmp    $0x1,%edx
    19d9:	75 16                	jne    19f1 <concreate+0xce>
      link("C0", file);
    19db:	83 ec 08             	sub    $0x8,%esp
    19de:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19e1:	50                   	push   %eax
    19e2:	68 f2 4d 00 00       	push   $0x4df2
    19e7:	e8 6d 26 00 00       	call   4059 <link>
    19ec:	83 c4 10             	add    $0x10,%esp
    19ef:	eb 46                	jmp    1a37 <concreate+0x114>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    19f1:	83 ec 08             	sub    $0x8,%esp
    19f4:	68 02 02 00 00       	push   $0x202
    19f9:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19fc:	50                   	push   %eax
    19fd:	e8 37 26 00 00       	call   4039 <open>
    1a02:	83 c4 10             	add    $0x10,%esp
    1a05:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(fd < 0){
    1a08:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a0c:	79 1b                	jns    1a29 <concreate+0x106>
        printf(1, "concreate create %s failed\n", file);
    1a0e:	83 ec 04             	sub    $0x4,%esp
    1a11:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a14:	50                   	push   %eax
    1a15:	68 f5 4d 00 00       	push   $0x4df5
    1a1a:	6a 01                	push   $0x1
    1a1c:	e8 54 27 00 00       	call   4175 <printf>
    1a21:	83 c4 10             	add    $0x10,%esp
        exit();
    1a24:	e8 d0 25 00 00       	call   3ff9 <exit>
      }
      close(fd);
    1a29:	83 ec 0c             	sub    $0xc,%esp
    1a2c:	ff 75 ec             	push   -0x14(%ebp)
    1a2f:	e8 ed 25 00 00       	call   4021 <close>
    1a34:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1a37:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1a3b:	75 05                	jne    1a42 <concreate+0x11f>
      exit();
    1a3d:	e8 b7 25 00 00       	call   3ff9 <exit>
    else
      wait();
    1a42:	e8 ba 25 00 00       	call   4001 <wait>
  for(i = 0; i < 40; i++){
    1a47:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1a4b:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1a4f:	0f 8e fa fe ff ff    	jle    194f <concreate+0x2c>
  }

  memset(fa, 0, sizeof(fa));
    1a55:	83 ec 04             	sub    $0x4,%esp
    1a58:	6a 28                	push   $0x28
    1a5a:	6a 00                	push   $0x0
    1a5c:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1a5f:	50                   	push   %eax
    1a60:	e8 f9 23 00 00       	call   3e5e <memset>
    1a65:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    1a68:	83 ec 08             	sub    $0x8,%esp
    1a6b:	6a 00                	push   $0x0
    1a6d:	68 b7 4d 00 00       	push   $0x4db7
    1a72:	e8 c2 25 00 00       	call   4039 <open>
    1a77:	83 c4 10             	add    $0x10,%esp
    1a7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  n = 0;
    1a7d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1a84:	e9 99 00 00 00       	jmp    1b22 <concreate+0x1ff>
    if(de.inum == 0)
    1a89:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    1a8d:	66 85 c0             	test   %ax,%ax
    1a90:	0f 84 8b 00 00 00    	je     1b21 <concreate+0x1fe>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1a96:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    1a9a:	3c 43                	cmp    $0x43,%al
    1a9c:	0f 85 80 00 00 00    	jne    1b22 <concreate+0x1ff>
    1aa2:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    1aa6:	84 c0                	test   %al,%al
    1aa8:	75 78                	jne    1b22 <concreate+0x1ff>
      i = de.name[1] - '0';
    1aaa:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    1aae:	0f be c0             	movsbl %al,%eax
    1ab1:	83 e8 30             	sub    $0x30,%eax
    1ab4:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1ab7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1abb:	78 08                	js     1ac5 <concreate+0x1a2>
    1abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac0:	83 f8 27             	cmp    $0x27,%eax
    1ac3:	76 1e                	jbe    1ae3 <concreate+0x1c0>
        printf(1, "concreate weird file %s\n", de.name);
    1ac5:	83 ec 04             	sub    $0x4,%esp
    1ac8:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1acb:	83 c0 02             	add    $0x2,%eax
    1ace:	50                   	push   %eax
    1acf:	68 11 4e 00 00       	push   $0x4e11
    1ad4:	6a 01                	push   $0x1
    1ad6:	e8 9a 26 00 00       	call   4175 <printf>
    1adb:	83 c4 10             	add    $0x10,%esp
        exit();
    1ade:	e8 16 25 00 00       	call   3ff9 <exit>
      }
      if(fa[i]){
    1ae3:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ae9:	01 d0                	add    %edx,%eax
    1aeb:	0f b6 00             	movzbl (%eax),%eax
    1aee:	84 c0                	test   %al,%al
    1af0:	74 1e                	je     1b10 <concreate+0x1ed>
        printf(1, "concreate duplicate file %s\n", de.name);
    1af2:	83 ec 04             	sub    $0x4,%esp
    1af5:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1af8:	83 c0 02             	add    $0x2,%eax
    1afb:	50                   	push   %eax
    1afc:	68 2a 4e 00 00       	push   $0x4e2a
    1b01:	6a 01                	push   $0x1
    1b03:	e8 6d 26 00 00       	call   4175 <printf>
    1b08:	83 c4 10             	add    $0x10,%esp
        exit();
    1b0b:	e8 e9 24 00 00       	call   3ff9 <exit>
      }
      fa[i] = 1;
    1b10:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b16:	01 d0                	add    %edx,%eax
    1b18:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1b1b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1b1f:	eb 01                	jmp    1b22 <concreate+0x1ff>
      continue;
    1b21:	90                   	nop
  while(read(fd, &de, sizeof(de)) > 0){
    1b22:	83 ec 04             	sub    $0x4,%esp
    1b25:	6a 10                	push   $0x10
    1b27:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b2a:	50                   	push   %eax
    1b2b:	ff 75 ec             	push   -0x14(%ebp)
    1b2e:	e8 de 24 00 00       	call   4011 <read>
    1b33:	83 c4 10             	add    $0x10,%esp
    1b36:	85 c0                	test   %eax,%eax
    1b38:	0f 8f 4b ff ff ff    	jg     1a89 <concreate+0x166>
    }
  }
  close(fd);
    1b3e:	83 ec 0c             	sub    $0xc,%esp
    1b41:	ff 75 ec             	push   -0x14(%ebp)
    1b44:	e8 d8 24 00 00       	call   4021 <close>
    1b49:	83 c4 10             	add    $0x10,%esp

  if(n != 40){
    1b4c:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1b50:	74 17                	je     1b69 <concreate+0x246>
    printf(1, "concreate not enough files in directory listing\n");
    1b52:	83 ec 08             	sub    $0x8,%esp
    1b55:	68 48 4e 00 00       	push   $0x4e48
    1b5a:	6a 01                	push   $0x1
    1b5c:	e8 14 26 00 00       	call   4175 <printf>
    1b61:	83 c4 10             	add    $0x10,%esp
    exit();
    1b64:	e8 90 24 00 00       	call   3ff9 <exit>
  }

  for(i = 0; i < 40; i++){
    1b69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1b70:	e9 43 01 00 00       	jmp    1cb8 <concreate+0x395>
    file[1] = '0' + i;
    1b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b78:	83 c0 30             	add    $0x30,%eax
    1b7b:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1b7e:	e8 6e 24 00 00       	call   3ff1 <fork>
    1b83:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid < 0){
    1b86:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1b8a:	79 17                	jns    1ba3 <concreate+0x280>
      printf(1, "fork failed\n");
    1b8c:	83 ec 08             	sub    $0x8,%esp
    1b8f:	68 cd 45 00 00       	push   $0x45cd
    1b94:	6a 01                	push   $0x1
    1b96:	e8 da 25 00 00       	call   4175 <printf>
    1b9b:	83 c4 10             	add    $0x10,%esp
      exit();
    1b9e:	e8 56 24 00 00       	call   3ff9 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1ba3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1ba6:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1bab:	89 c8                	mov    %ecx,%eax
    1bad:	f7 ea                	imul   %edx
    1baf:	89 c8                	mov    %ecx,%eax
    1bb1:	c1 f8 1f             	sar    $0x1f,%eax
    1bb4:	29 c2                	sub    %eax,%edx
    1bb6:	89 d0                	mov    %edx,%eax
    1bb8:	01 c0                	add    %eax,%eax
    1bba:	01 d0                	add    %edx,%eax
    1bbc:	29 c1                	sub    %eax,%ecx
    1bbe:	89 ca                	mov    %ecx,%edx
    1bc0:	85 d2                	test   %edx,%edx
    1bc2:	75 06                	jne    1bca <concreate+0x2a7>
    1bc4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1bc8:	74 28                	je     1bf2 <concreate+0x2cf>
       ((i % 3) == 1 && pid != 0)){
    1bca:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1bcd:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1bd2:	89 c8                	mov    %ecx,%eax
    1bd4:	f7 ea                	imul   %edx
    1bd6:	89 c8                	mov    %ecx,%eax
    1bd8:	c1 f8 1f             	sar    $0x1f,%eax
    1bdb:	29 c2                	sub    %eax,%edx
    1bdd:	89 d0                	mov    %edx,%eax
    1bdf:	01 c0                	add    %eax,%eax
    1be1:	01 d0                	add    %edx,%eax
    1be3:	29 c1                	sub    %eax,%ecx
    1be5:	89 ca                	mov    %ecx,%edx
    if(((i % 3) == 0 && pid == 0) ||
    1be7:	83 fa 01             	cmp    $0x1,%edx
    1bea:	75 7c                	jne    1c68 <concreate+0x345>
       ((i % 3) == 1 && pid != 0)){
    1bec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1bf0:	74 76                	je     1c68 <concreate+0x345>
      close(open(file, 0));
    1bf2:	83 ec 08             	sub    $0x8,%esp
    1bf5:	6a 00                	push   $0x0
    1bf7:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1bfa:	50                   	push   %eax
    1bfb:	e8 39 24 00 00       	call   4039 <open>
    1c00:	83 c4 10             	add    $0x10,%esp
    1c03:	83 ec 0c             	sub    $0xc,%esp
    1c06:	50                   	push   %eax
    1c07:	e8 15 24 00 00       	call   4021 <close>
    1c0c:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c0f:	83 ec 08             	sub    $0x8,%esp
    1c12:	6a 00                	push   $0x0
    1c14:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c17:	50                   	push   %eax
    1c18:	e8 1c 24 00 00       	call   4039 <open>
    1c1d:	83 c4 10             	add    $0x10,%esp
    1c20:	83 ec 0c             	sub    $0xc,%esp
    1c23:	50                   	push   %eax
    1c24:	e8 f8 23 00 00       	call   4021 <close>
    1c29:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c2c:	83 ec 08             	sub    $0x8,%esp
    1c2f:	6a 00                	push   $0x0
    1c31:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c34:	50                   	push   %eax
    1c35:	e8 ff 23 00 00       	call   4039 <open>
    1c3a:	83 c4 10             	add    $0x10,%esp
    1c3d:	83 ec 0c             	sub    $0xc,%esp
    1c40:	50                   	push   %eax
    1c41:	e8 db 23 00 00       	call   4021 <close>
    1c46:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1c49:	83 ec 08             	sub    $0x8,%esp
    1c4c:	6a 00                	push   $0x0
    1c4e:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c51:	50                   	push   %eax
    1c52:	e8 e2 23 00 00       	call   4039 <open>
    1c57:	83 c4 10             	add    $0x10,%esp
    1c5a:	83 ec 0c             	sub    $0xc,%esp
    1c5d:	50                   	push   %eax
    1c5e:	e8 be 23 00 00       	call   4021 <close>
    1c63:	83 c4 10             	add    $0x10,%esp
    1c66:	eb 3c                	jmp    1ca4 <concreate+0x381>
    } else {
      unlink(file);
    1c68:	83 ec 0c             	sub    $0xc,%esp
    1c6b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c6e:	50                   	push   %eax
    1c6f:	e8 d5 23 00 00       	call   4049 <unlink>
    1c74:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c77:	83 ec 0c             	sub    $0xc,%esp
    1c7a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c7d:	50                   	push   %eax
    1c7e:	e8 c6 23 00 00       	call   4049 <unlink>
    1c83:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c86:	83 ec 0c             	sub    $0xc,%esp
    1c89:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c8c:	50                   	push   %eax
    1c8d:	e8 b7 23 00 00       	call   4049 <unlink>
    1c92:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1c95:	83 ec 0c             	sub    $0xc,%esp
    1c98:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c9b:	50                   	push   %eax
    1c9c:	e8 a8 23 00 00       	call   4049 <unlink>
    1ca1:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1ca4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1ca8:	75 05                	jne    1caf <concreate+0x38c>
      exit();
    1caa:	e8 4a 23 00 00       	call   3ff9 <exit>
    else
      wait();
    1caf:	e8 4d 23 00 00       	call   4001 <wait>
  for(i = 0; i < 40; i++){
    1cb4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1cb8:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1cbc:	0f 8e b3 fe ff ff    	jle    1b75 <concreate+0x252>
  }

  printf(1, "concreate ok\n");
    1cc2:	83 ec 08             	sub    $0x8,%esp
    1cc5:	68 79 4e 00 00       	push   $0x4e79
    1cca:	6a 01                	push   $0x1
    1ccc:	e8 a4 24 00 00       	call   4175 <printf>
    1cd1:	83 c4 10             	add    $0x10,%esp
}
    1cd4:	90                   	nop
    1cd5:	c9                   	leave
    1cd6:	c3                   	ret

00001cd7 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1cd7:	55                   	push   %ebp
    1cd8:	89 e5                	mov    %esp,%ebp
    1cda:	83 ec 18             	sub    $0x18,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1cdd:	83 ec 08             	sub    $0x8,%esp
    1ce0:	68 87 4e 00 00       	push   $0x4e87
    1ce5:	6a 01                	push   $0x1
    1ce7:	e8 89 24 00 00       	call   4175 <printf>
    1cec:	83 c4 10             	add    $0x10,%esp

  unlink("x");
    1cef:	83 ec 0c             	sub    $0xc,%esp
    1cf2:	68 03 4a 00 00       	push   $0x4a03
    1cf7:	e8 4d 23 00 00       	call   4049 <unlink>
    1cfc:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    1cff:	e8 ed 22 00 00       	call   3ff1 <fork>
    1d04:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1d07:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d0b:	79 17                	jns    1d24 <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1d0d:	83 ec 08             	sub    $0x8,%esp
    1d10:	68 cd 45 00 00       	push   $0x45cd
    1d15:	6a 01                	push   $0x1
    1d17:	e8 59 24 00 00       	call   4175 <printf>
    1d1c:	83 c4 10             	add    $0x10,%esp
    exit();
    1d1f:	e8 d5 22 00 00       	call   3ff9 <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1d24:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d28:	74 07                	je     1d31 <linkunlink+0x5a>
    1d2a:	b8 01 00 00 00       	mov    $0x1,%eax
    1d2f:	eb 05                	jmp    1d36 <linkunlink+0x5f>
    1d31:	b8 61 00 00 00       	mov    $0x61,%eax
    1d36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1d39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1d40:	e9 98 00 00 00       	jmp    1ddd <linkunlink+0x106>
    x = x * 1103515245 + 12345;
    1d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d48:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1d4e:	05 39 30 00 00       	add    $0x3039,%eax
    1d53:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1d56:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d59:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d5e:	89 c8                	mov    %ecx,%eax
    1d60:	f7 e2                	mul    %edx
    1d62:	d1 ea                	shr    $1,%edx
    1d64:	89 d0                	mov    %edx,%eax
    1d66:	01 c0                	add    %eax,%eax
    1d68:	01 d0                	add    %edx,%eax
    1d6a:	29 c1                	sub    %eax,%ecx
    1d6c:	89 ca                	mov    %ecx,%edx
    1d6e:	85 d2                	test   %edx,%edx
    1d70:	75 23                	jne    1d95 <linkunlink+0xbe>
      close(open("x", O_RDWR | O_CREATE));
    1d72:	83 ec 08             	sub    $0x8,%esp
    1d75:	68 02 02 00 00       	push   $0x202
    1d7a:	68 03 4a 00 00       	push   $0x4a03
    1d7f:	e8 b5 22 00 00       	call   4039 <open>
    1d84:	83 c4 10             	add    $0x10,%esp
    1d87:	83 ec 0c             	sub    $0xc,%esp
    1d8a:	50                   	push   %eax
    1d8b:	e8 91 22 00 00       	call   4021 <close>
    1d90:	83 c4 10             	add    $0x10,%esp
    1d93:	eb 44                	jmp    1dd9 <linkunlink+0x102>
    } else if((x % 3) == 1){
    1d95:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d98:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d9d:	89 c8                	mov    %ecx,%eax
    1d9f:	f7 e2                	mul    %edx
    1da1:	d1 ea                	shr    $1,%edx
    1da3:	89 d0                	mov    %edx,%eax
    1da5:	01 c0                	add    %eax,%eax
    1da7:	01 d0                	add    %edx,%eax
    1da9:	29 c1                	sub    %eax,%ecx
    1dab:	89 ca                	mov    %ecx,%edx
    1dad:	83 fa 01             	cmp    $0x1,%edx
    1db0:	75 17                	jne    1dc9 <linkunlink+0xf2>
      link("cat", "x");
    1db2:	83 ec 08             	sub    $0x8,%esp
    1db5:	68 03 4a 00 00       	push   $0x4a03
    1dba:	68 98 4e 00 00       	push   $0x4e98
    1dbf:	e8 95 22 00 00       	call   4059 <link>
    1dc4:	83 c4 10             	add    $0x10,%esp
    1dc7:	eb 10                	jmp    1dd9 <linkunlink+0x102>
    } else {
      unlink("x");
    1dc9:	83 ec 0c             	sub    $0xc,%esp
    1dcc:	68 03 4a 00 00       	push   $0x4a03
    1dd1:	e8 73 22 00 00       	call   4049 <unlink>
    1dd6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1dd9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1ddd:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1de1:	0f 8e 5e ff ff ff    	jle    1d45 <linkunlink+0x6e>
    }
  }

  if(pid)
    1de7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1deb:	74 07                	je     1df4 <linkunlink+0x11d>
    wait();
    1ded:	e8 0f 22 00 00       	call   4001 <wait>
    1df2:	eb 05                	jmp    1df9 <linkunlink+0x122>
  else
    exit();
    1df4:	e8 00 22 00 00       	call   3ff9 <exit>

  printf(1, "linkunlink ok\n");
    1df9:	83 ec 08             	sub    $0x8,%esp
    1dfc:	68 9c 4e 00 00       	push   $0x4e9c
    1e01:	6a 01                	push   $0x1
    1e03:	e8 6d 23 00 00       	call   4175 <printf>
    1e08:	83 c4 10             	add    $0x10,%esp
}
    1e0b:	90                   	nop
    1e0c:	c9                   	leave
    1e0d:	c3                   	ret

00001e0e <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1e0e:	55                   	push   %ebp
    1e0f:	89 e5                	mov    %esp,%ebp
    1e11:	83 ec 28             	sub    $0x28,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1e14:	83 ec 08             	sub    $0x8,%esp
    1e17:	68 ab 4e 00 00       	push   $0x4eab
    1e1c:	6a 01                	push   $0x1
    1e1e:	e8 52 23 00 00       	call   4175 <printf>
    1e23:	83 c4 10             	add    $0x10,%esp
  unlink("bd");
    1e26:	83 ec 0c             	sub    $0xc,%esp
    1e29:	68 b8 4e 00 00       	push   $0x4eb8
    1e2e:	e8 16 22 00 00       	call   4049 <unlink>
    1e33:	83 c4 10             	add    $0x10,%esp

  fd = open("bd", O_CREATE);
    1e36:	83 ec 08             	sub    $0x8,%esp
    1e39:	68 00 02 00 00       	push   $0x200
    1e3e:	68 b8 4e 00 00       	push   $0x4eb8
    1e43:	e8 f1 21 00 00       	call   4039 <open>
    1e48:	83 c4 10             	add    $0x10,%esp
    1e4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1e4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1e52:	79 17                	jns    1e6b <bigdir+0x5d>
    printf(1, "bigdir create failed\n");
    1e54:	83 ec 08             	sub    $0x8,%esp
    1e57:	68 bb 4e 00 00       	push   $0x4ebb
    1e5c:	6a 01                	push   $0x1
    1e5e:	e8 12 23 00 00       	call   4175 <printf>
    1e63:	83 c4 10             	add    $0x10,%esp
    exit();
    1e66:	e8 8e 21 00 00       	call   3ff9 <exit>
  }
  close(fd);
    1e6b:	83 ec 0c             	sub    $0xc,%esp
    1e6e:	ff 75 f0             	push   -0x10(%ebp)
    1e71:	e8 ab 21 00 00       	call   4021 <close>
    1e76:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 500; i++){
    1e79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e80:	eb 69                	jmp    1eeb <bigdir+0xdd>
    name[0] = 'x';
    1e82:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e89:	8d 50 3f             	lea    0x3f(%eax),%edx
    1e8c:	85 c0                	test   %eax,%eax
    1e8e:	0f 48 c2             	cmovs  %edx,%eax
    1e91:	c1 f8 06             	sar    $0x6,%eax
    1e94:	83 c0 30             	add    $0x30,%eax
    1e97:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1e9d:	89 d0                	mov    %edx,%eax
    1e9f:	c1 f8 1f             	sar    $0x1f,%eax
    1ea2:	c1 e8 1a             	shr    $0x1a,%eax
    1ea5:	01 c2                	add    %eax,%edx
    1ea7:	83 e2 3f             	and    $0x3f,%edx
    1eaa:	29 c2                	sub    %eax,%edx
    1eac:	89 d0                	mov    %edx,%eax
    1eae:	83 c0 30             	add    $0x30,%eax
    1eb1:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1eb4:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1eb8:	83 ec 08             	sub    $0x8,%esp
    1ebb:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1ebe:	50                   	push   %eax
    1ebf:	68 b8 4e 00 00       	push   $0x4eb8
    1ec4:	e8 90 21 00 00       	call   4059 <link>
    1ec9:	83 c4 10             	add    $0x10,%esp
    1ecc:	85 c0                	test   %eax,%eax
    1ece:	74 17                	je     1ee7 <bigdir+0xd9>
      printf(1, "bigdir link failed\n");
    1ed0:	83 ec 08             	sub    $0x8,%esp
    1ed3:	68 d1 4e 00 00       	push   $0x4ed1
    1ed8:	6a 01                	push   $0x1
    1eda:	e8 96 22 00 00       	call   4175 <printf>
    1edf:	83 c4 10             	add    $0x10,%esp
      exit();
    1ee2:	e8 12 21 00 00       	call   3ff9 <exit>
  for(i = 0; i < 500; i++){
    1ee7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1eeb:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1ef2:	7e 8e                	jle    1e82 <bigdir+0x74>
    }
  }

  unlink("bd");
    1ef4:	83 ec 0c             	sub    $0xc,%esp
    1ef7:	68 b8 4e 00 00       	push   $0x4eb8
    1efc:	e8 48 21 00 00       	call   4049 <unlink>
    1f01:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    1f04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1f0b:	eb 64                	jmp    1f71 <bigdir+0x163>
    name[0] = 'x';
    1f0d:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f14:	8d 50 3f             	lea    0x3f(%eax),%edx
    1f17:	85 c0                	test   %eax,%eax
    1f19:	0f 48 c2             	cmovs  %edx,%eax
    1f1c:	c1 f8 06             	sar    $0x6,%eax
    1f1f:	83 c0 30             	add    $0x30,%eax
    1f22:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1f28:	89 d0                	mov    %edx,%eax
    1f2a:	c1 f8 1f             	sar    $0x1f,%eax
    1f2d:	c1 e8 1a             	shr    $0x1a,%eax
    1f30:	01 c2                	add    %eax,%edx
    1f32:	83 e2 3f             	and    $0x3f,%edx
    1f35:	29 c2                	sub    %eax,%edx
    1f37:	89 d0                	mov    %edx,%eax
    1f39:	83 c0 30             	add    $0x30,%eax
    1f3c:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1f3f:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1f43:	83 ec 0c             	sub    $0xc,%esp
    1f46:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1f49:	50                   	push   %eax
    1f4a:	e8 fa 20 00 00       	call   4049 <unlink>
    1f4f:	83 c4 10             	add    $0x10,%esp
    1f52:	85 c0                	test   %eax,%eax
    1f54:	74 17                	je     1f6d <bigdir+0x15f>
      printf(1, "bigdir unlink failed");
    1f56:	83 ec 08             	sub    $0x8,%esp
    1f59:	68 e5 4e 00 00       	push   $0x4ee5
    1f5e:	6a 01                	push   $0x1
    1f60:	e8 10 22 00 00       	call   4175 <printf>
    1f65:	83 c4 10             	add    $0x10,%esp
      exit();
    1f68:	e8 8c 20 00 00       	call   3ff9 <exit>
  for(i = 0; i < 500; i++){
    1f6d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f71:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1f78:	7e 93                	jle    1f0d <bigdir+0xff>
    }
  }

  printf(1, "bigdir ok\n");
    1f7a:	83 ec 08             	sub    $0x8,%esp
    1f7d:	68 fa 4e 00 00       	push   $0x4efa
    1f82:	6a 01                	push   $0x1
    1f84:	e8 ec 21 00 00       	call   4175 <printf>
    1f89:	83 c4 10             	add    $0x10,%esp
}
    1f8c:	90                   	nop
    1f8d:	c9                   	leave
    1f8e:	c3                   	ret

00001f8f <subdir>:

void
subdir(void)
{
    1f8f:	55                   	push   %ebp
    1f90:	89 e5                	mov    %esp,%ebp
    1f92:	83 ec 18             	sub    $0x18,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1f95:	83 ec 08             	sub    $0x8,%esp
    1f98:	68 05 4f 00 00       	push   $0x4f05
    1f9d:	6a 01                	push   $0x1
    1f9f:	e8 d1 21 00 00       	call   4175 <printf>
    1fa4:	83 c4 10             	add    $0x10,%esp

  unlink("ff");
    1fa7:	83 ec 0c             	sub    $0xc,%esp
    1faa:	68 12 4f 00 00       	push   $0x4f12
    1faf:	e8 95 20 00 00       	call   4049 <unlink>
    1fb4:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dd") != 0){
    1fb7:	83 ec 0c             	sub    $0xc,%esp
    1fba:	68 15 4f 00 00       	push   $0x4f15
    1fbf:	e8 9d 20 00 00       	call   4061 <mkdir>
    1fc4:	83 c4 10             	add    $0x10,%esp
    1fc7:	85 c0                	test   %eax,%eax
    1fc9:	74 17                	je     1fe2 <subdir+0x53>
    printf(1, "subdir mkdir dd failed\n");
    1fcb:	83 ec 08             	sub    $0x8,%esp
    1fce:	68 18 4f 00 00       	push   $0x4f18
    1fd3:	6a 01                	push   $0x1
    1fd5:	e8 9b 21 00 00       	call   4175 <printf>
    1fda:	83 c4 10             	add    $0x10,%esp
    exit();
    1fdd:	e8 17 20 00 00       	call   3ff9 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1fe2:	83 ec 08             	sub    $0x8,%esp
    1fe5:	68 02 02 00 00       	push   $0x202
    1fea:	68 30 4f 00 00       	push   $0x4f30
    1fef:	e8 45 20 00 00       	call   4039 <open>
    1ff4:	83 c4 10             	add    $0x10,%esp
    1ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1ffa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ffe:	79 17                	jns    2017 <subdir+0x88>
    printf(1, "create dd/ff failed\n");
    2000:	83 ec 08             	sub    $0x8,%esp
    2003:	68 36 4f 00 00       	push   $0x4f36
    2008:	6a 01                	push   $0x1
    200a:	e8 66 21 00 00       	call   4175 <printf>
    200f:	83 c4 10             	add    $0x10,%esp
    exit();
    2012:	e8 e2 1f 00 00       	call   3ff9 <exit>
  }
  write(fd, "ff", 2);
    2017:	83 ec 04             	sub    $0x4,%esp
    201a:	6a 02                	push   $0x2
    201c:	68 12 4f 00 00       	push   $0x4f12
    2021:	ff 75 f4             	push   -0xc(%ebp)
    2024:	e8 f0 1f 00 00       	call   4019 <write>
    2029:	83 c4 10             	add    $0x10,%esp
  close(fd);
    202c:	83 ec 0c             	sub    $0xc,%esp
    202f:	ff 75 f4             	push   -0xc(%ebp)
    2032:	e8 ea 1f 00 00       	call   4021 <close>
    2037:	83 c4 10             	add    $0x10,%esp

  if(unlink("dd") >= 0){
    203a:	83 ec 0c             	sub    $0xc,%esp
    203d:	68 15 4f 00 00       	push   $0x4f15
    2042:	e8 02 20 00 00       	call   4049 <unlink>
    2047:	83 c4 10             	add    $0x10,%esp
    204a:	85 c0                	test   %eax,%eax
    204c:	78 17                	js     2065 <subdir+0xd6>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    204e:	83 ec 08             	sub    $0x8,%esp
    2051:	68 4c 4f 00 00       	push   $0x4f4c
    2056:	6a 01                	push   $0x1
    2058:	e8 18 21 00 00       	call   4175 <printf>
    205d:	83 c4 10             	add    $0x10,%esp
    exit();
    2060:	e8 94 1f 00 00       	call   3ff9 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    2065:	83 ec 0c             	sub    $0xc,%esp
    2068:	68 72 4f 00 00       	push   $0x4f72
    206d:	e8 ef 1f 00 00       	call   4061 <mkdir>
    2072:	83 c4 10             	add    $0x10,%esp
    2075:	85 c0                	test   %eax,%eax
    2077:	74 17                	je     2090 <subdir+0x101>
    printf(1, "subdir mkdir dd/dd failed\n");
    2079:	83 ec 08             	sub    $0x8,%esp
    207c:	68 79 4f 00 00       	push   $0x4f79
    2081:	6a 01                	push   $0x1
    2083:	e8 ed 20 00 00       	call   4175 <printf>
    2088:	83 c4 10             	add    $0x10,%esp
    exit();
    208b:	e8 69 1f 00 00       	call   3ff9 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2090:	83 ec 08             	sub    $0x8,%esp
    2093:	68 02 02 00 00       	push   $0x202
    2098:	68 94 4f 00 00       	push   $0x4f94
    209d:	e8 97 1f 00 00       	call   4039 <open>
    20a2:	83 c4 10             	add    $0x10,%esp
    20a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    20a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    20ac:	79 17                	jns    20c5 <subdir+0x136>
    printf(1, "create dd/dd/ff failed\n");
    20ae:	83 ec 08             	sub    $0x8,%esp
    20b1:	68 9d 4f 00 00       	push   $0x4f9d
    20b6:	6a 01                	push   $0x1
    20b8:	e8 b8 20 00 00       	call   4175 <printf>
    20bd:	83 c4 10             	add    $0x10,%esp
    exit();
    20c0:	e8 34 1f 00 00       	call   3ff9 <exit>
  }
  write(fd, "FF", 2);
    20c5:	83 ec 04             	sub    $0x4,%esp
    20c8:	6a 02                	push   $0x2
    20ca:	68 b5 4f 00 00       	push   $0x4fb5
    20cf:	ff 75 f4             	push   -0xc(%ebp)
    20d2:	e8 42 1f 00 00       	call   4019 <write>
    20d7:	83 c4 10             	add    $0x10,%esp
  close(fd);
    20da:	83 ec 0c             	sub    $0xc,%esp
    20dd:	ff 75 f4             	push   -0xc(%ebp)
    20e0:	e8 3c 1f 00 00       	call   4021 <close>
    20e5:	83 c4 10             	add    $0x10,%esp

  fd = open("dd/dd/../ff", 0);
    20e8:	83 ec 08             	sub    $0x8,%esp
    20eb:	6a 00                	push   $0x0
    20ed:	68 b8 4f 00 00       	push   $0x4fb8
    20f2:	e8 42 1f 00 00       	call   4039 <open>
    20f7:	83 c4 10             	add    $0x10,%esp
    20fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    20fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2101:	79 17                	jns    211a <subdir+0x18b>
    printf(1, "open dd/dd/../ff failed\n");
    2103:	83 ec 08             	sub    $0x8,%esp
    2106:	68 c4 4f 00 00       	push   $0x4fc4
    210b:	6a 01                	push   $0x1
    210d:	e8 63 20 00 00       	call   4175 <printf>
    2112:	83 c4 10             	add    $0x10,%esp
    exit();
    2115:	e8 df 1e 00 00       	call   3ff9 <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    211a:	83 ec 04             	sub    $0x4,%esp
    211d:	68 00 20 00 00       	push   $0x2000
    2122:	68 a0 64 00 00       	push   $0x64a0
    2127:	ff 75 f4             	push   -0xc(%ebp)
    212a:	e8 e2 1e 00 00       	call   4011 <read>
    212f:	83 c4 10             	add    $0x10,%esp
    2132:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    2135:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    2139:	75 0b                	jne    2146 <subdir+0x1b7>
    213b:	0f b6 05 a0 64 00 00 	movzbl 0x64a0,%eax
    2142:	3c 66                	cmp    $0x66,%al
    2144:	74 17                	je     215d <subdir+0x1ce>
    printf(1, "dd/dd/../ff wrong content\n");
    2146:	83 ec 08             	sub    $0x8,%esp
    2149:	68 dd 4f 00 00       	push   $0x4fdd
    214e:	6a 01                	push   $0x1
    2150:	e8 20 20 00 00       	call   4175 <printf>
    2155:	83 c4 10             	add    $0x10,%esp
    exit();
    2158:	e8 9c 1e 00 00       	call   3ff9 <exit>
  }
  close(fd);
    215d:	83 ec 0c             	sub    $0xc,%esp
    2160:	ff 75 f4             	push   -0xc(%ebp)
    2163:	e8 b9 1e 00 00       	call   4021 <close>
    2168:	83 c4 10             	add    $0x10,%esp

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    216b:	83 ec 08             	sub    $0x8,%esp
    216e:	68 f8 4f 00 00       	push   $0x4ff8
    2173:	68 94 4f 00 00       	push   $0x4f94
    2178:	e8 dc 1e 00 00       	call   4059 <link>
    217d:	83 c4 10             	add    $0x10,%esp
    2180:	85 c0                	test   %eax,%eax
    2182:	74 17                	je     219b <subdir+0x20c>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2184:	83 ec 08             	sub    $0x8,%esp
    2187:	68 04 50 00 00       	push   $0x5004
    218c:	6a 01                	push   $0x1
    218e:	e8 e2 1f 00 00       	call   4175 <printf>
    2193:	83 c4 10             	add    $0x10,%esp
    exit();
    2196:	e8 5e 1e 00 00       	call   3ff9 <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    219b:	83 ec 0c             	sub    $0xc,%esp
    219e:	68 94 4f 00 00       	push   $0x4f94
    21a3:	e8 a1 1e 00 00       	call   4049 <unlink>
    21a8:	83 c4 10             	add    $0x10,%esp
    21ab:	85 c0                	test   %eax,%eax
    21ad:	74 17                	je     21c6 <subdir+0x237>
    printf(1, "unlink dd/dd/ff failed\n");
    21af:	83 ec 08             	sub    $0x8,%esp
    21b2:	68 25 50 00 00       	push   $0x5025
    21b7:	6a 01                	push   $0x1
    21b9:	e8 b7 1f 00 00       	call   4175 <printf>
    21be:	83 c4 10             	add    $0x10,%esp
    exit();
    21c1:	e8 33 1e 00 00       	call   3ff9 <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    21c6:	83 ec 08             	sub    $0x8,%esp
    21c9:	6a 00                	push   $0x0
    21cb:	68 94 4f 00 00       	push   $0x4f94
    21d0:	e8 64 1e 00 00       	call   4039 <open>
    21d5:	83 c4 10             	add    $0x10,%esp
    21d8:	85 c0                	test   %eax,%eax
    21da:	78 17                	js     21f3 <subdir+0x264>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    21dc:	83 ec 08             	sub    $0x8,%esp
    21df:	68 40 50 00 00       	push   $0x5040
    21e4:	6a 01                	push   $0x1
    21e6:	e8 8a 1f 00 00       	call   4175 <printf>
    21eb:	83 c4 10             	add    $0x10,%esp
    exit();
    21ee:	e8 06 1e 00 00       	call   3ff9 <exit>
  }

  if(chdir("dd") != 0){
    21f3:	83 ec 0c             	sub    $0xc,%esp
    21f6:	68 15 4f 00 00       	push   $0x4f15
    21fb:	e8 69 1e 00 00       	call   4069 <chdir>
    2200:	83 c4 10             	add    $0x10,%esp
    2203:	85 c0                	test   %eax,%eax
    2205:	74 17                	je     221e <subdir+0x28f>
    printf(1, "chdir dd failed\n");
    2207:	83 ec 08             	sub    $0x8,%esp
    220a:	68 64 50 00 00       	push   $0x5064
    220f:	6a 01                	push   $0x1
    2211:	e8 5f 1f 00 00       	call   4175 <printf>
    2216:	83 c4 10             	add    $0x10,%esp
    exit();
    2219:	e8 db 1d 00 00       	call   3ff9 <exit>
  }
  if(chdir("dd/../../dd") != 0){
    221e:	83 ec 0c             	sub    $0xc,%esp
    2221:	68 75 50 00 00       	push   $0x5075
    2226:	e8 3e 1e 00 00       	call   4069 <chdir>
    222b:	83 c4 10             	add    $0x10,%esp
    222e:	85 c0                	test   %eax,%eax
    2230:	74 17                	je     2249 <subdir+0x2ba>
    printf(1, "chdir dd/../../dd failed\n");
    2232:	83 ec 08             	sub    $0x8,%esp
    2235:	68 81 50 00 00       	push   $0x5081
    223a:	6a 01                	push   $0x1
    223c:	e8 34 1f 00 00       	call   4175 <printf>
    2241:	83 c4 10             	add    $0x10,%esp
    exit();
    2244:	e8 b0 1d 00 00       	call   3ff9 <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    2249:	83 ec 0c             	sub    $0xc,%esp
    224c:	68 9b 50 00 00       	push   $0x509b
    2251:	e8 13 1e 00 00       	call   4069 <chdir>
    2256:	83 c4 10             	add    $0x10,%esp
    2259:	85 c0                	test   %eax,%eax
    225b:	74 17                	je     2274 <subdir+0x2e5>
    printf(1, "chdir dd/../../dd failed\n");
    225d:	83 ec 08             	sub    $0x8,%esp
    2260:	68 81 50 00 00       	push   $0x5081
    2265:	6a 01                	push   $0x1
    2267:	e8 09 1f 00 00       	call   4175 <printf>
    226c:	83 c4 10             	add    $0x10,%esp
    exit();
    226f:	e8 85 1d 00 00       	call   3ff9 <exit>
  }
  if(chdir("./..") != 0){
    2274:	83 ec 0c             	sub    $0xc,%esp
    2277:	68 aa 50 00 00       	push   $0x50aa
    227c:	e8 e8 1d 00 00       	call   4069 <chdir>
    2281:	83 c4 10             	add    $0x10,%esp
    2284:	85 c0                	test   %eax,%eax
    2286:	74 17                	je     229f <subdir+0x310>
    printf(1, "chdir ./.. failed\n");
    2288:	83 ec 08             	sub    $0x8,%esp
    228b:	68 af 50 00 00       	push   $0x50af
    2290:	6a 01                	push   $0x1
    2292:	e8 de 1e 00 00       	call   4175 <printf>
    2297:	83 c4 10             	add    $0x10,%esp
    exit();
    229a:	e8 5a 1d 00 00       	call   3ff9 <exit>
  }

  fd = open("dd/dd/ffff", 0);
    229f:	83 ec 08             	sub    $0x8,%esp
    22a2:	6a 00                	push   $0x0
    22a4:	68 f8 4f 00 00       	push   $0x4ff8
    22a9:	e8 8b 1d 00 00       	call   4039 <open>
    22ae:	83 c4 10             	add    $0x10,%esp
    22b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    22b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    22b8:	79 17                	jns    22d1 <subdir+0x342>
    printf(1, "open dd/dd/ffff failed\n");
    22ba:	83 ec 08             	sub    $0x8,%esp
    22bd:	68 c2 50 00 00       	push   $0x50c2
    22c2:	6a 01                	push   $0x1
    22c4:	e8 ac 1e 00 00       	call   4175 <printf>
    22c9:	83 c4 10             	add    $0x10,%esp
    exit();
    22cc:	e8 28 1d 00 00       	call   3ff9 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    22d1:	83 ec 04             	sub    $0x4,%esp
    22d4:	68 00 20 00 00       	push   $0x2000
    22d9:	68 a0 64 00 00       	push   $0x64a0
    22de:	ff 75 f4             	push   -0xc(%ebp)
    22e1:	e8 2b 1d 00 00       	call   4011 <read>
    22e6:	83 c4 10             	add    $0x10,%esp
    22e9:	83 f8 02             	cmp    $0x2,%eax
    22ec:	74 17                	je     2305 <subdir+0x376>
    printf(1, "read dd/dd/ffff wrong len\n");
    22ee:	83 ec 08             	sub    $0x8,%esp
    22f1:	68 da 50 00 00       	push   $0x50da
    22f6:	6a 01                	push   $0x1
    22f8:	e8 78 1e 00 00       	call   4175 <printf>
    22fd:	83 c4 10             	add    $0x10,%esp
    exit();
    2300:	e8 f4 1c 00 00       	call   3ff9 <exit>
  }
  close(fd);
    2305:	83 ec 0c             	sub    $0xc,%esp
    2308:	ff 75 f4             	push   -0xc(%ebp)
    230b:	e8 11 1d 00 00       	call   4021 <close>
    2310:	83 c4 10             	add    $0x10,%esp

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2313:	83 ec 08             	sub    $0x8,%esp
    2316:	6a 00                	push   $0x0
    2318:	68 94 4f 00 00       	push   $0x4f94
    231d:	e8 17 1d 00 00       	call   4039 <open>
    2322:	83 c4 10             	add    $0x10,%esp
    2325:	85 c0                	test   %eax,%eax
    2327:	78 17                	js     2340 <subdir+0x3b1>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2329:	83 ec 08             	sub    $0x8,%esp
    232c:	68 f8 50 00 00       	push   $0x50f8
    2331:	6a 01                	push   $0x1
    2333:	e8 3d 1e 00 00       	call   4175 <printf>
    2338:	83 c4 10             	add    $0x10,%esp
    exit();
    233b:	e8 b9 1c 00 00       	call   3ff9 <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2340:	83 ec 08             	sub    $0x8,%esp
    2343:	68 02 02 00 00       	push   $0x202
    2348:	68 1d 51 00 00       	push   $0x511d
    234d:	e8 e7 1c 00 00       	call   4039 <open>
    2352:	83 c4 10             	add    $0x10,%esp
    2355:	85 c0                	test   %eax,%eax
    2357:	78 17                	js     2370 <subdir+0x3e1>
    printf(1, "create dd/ff/ff succeeded!\n");
    2359:	83 ec 08             	sub    $0x8,%esp
    235c:	68 26 51 00 00       	push   $0x5126
    2361:	6a 01                	push   $0x1
    2363:	e8 0d 1e 00 00       	call   4175 <printf>
    2368:	83 c4 10             	add    $0x10,%esp
    exit();
    236b:	e8 89 1c 00 00       	call   3ff9 <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2370:	83 ec 08             	sub    $0x8,%esp
    2373:	68 02 02 00 00       	push   $0x202
    2378:	68 42 51 00 00       	push   $0x5142
    237d:	e8 b7 1c 00 00       	call   4039 <open>
    2382:	83 c4 10             	add    $0x10,%esp
    2385:	85 c0                	test   %eax,%eax
    2387:	78 17                	js     23a0 <subdir+0x411>
    printf(1, "create dd/xx/ff succeeded!\n");
    2389:	83 ec 08             	sub    $0x8,%esp
    238c:	68 4b 51 00 00       	push   $0x514b
    2391:	6a 01                	push   $0x1
    2393:	e8 dd 1d 00 00       	call   4175 <printf>
    2398:	83 c4 10             	add    $0x10,%esp
    exit();
    239b:	e8 59 1c 00 00       	call   3ff9 <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    23a0:	83 ec 08             	sub    $0x8,%esp
    23a3:	68 00 02 00 00       	push   $0x200
    23a8:	68 15 4f 00 00       	push   $0x4f15
    23ad:	e8 87 1c 00 00       	call   4039 <open>
    23b2:	83 c4 10             	add    $0x10,%esp
    23b5:	85 c0                	test   %eax,%eax
    23b7:	78 17                	js     23d0 <subdir+0x441>
    printf(1, "create dd succeeded!\n");
    23b9:	83 ec 08             	sub    $0x8,%esp
    23bc:	68 67 51 00 00       	push   $0x5167
    23c1:	6a 01                	push   $0x1
    23c3:	e8 ad 1d 00 00       	call   4175 <printf>
    23c8:	83 c4 10             	add    $0x10,%esp
    exit();
    23cb:	e8 29 1c 00 00       	call   3ff9 <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    23d0:	83 ec 08             	sub    $0x8,%esp
    23d3:	6a 02                	push   $0x2
    23d5:	68 15 4f 00 00       	push   $0x4f15
    23da:	e8 5a 1c 00 00       	call   4039 <open>
    23df:	83 c4 10             	add    $0x10,%esp
    23e2:	85 c0                	test   %eax,%eax
    23e4:	78 17                	js     23fd <subdir+0x46e>
    printf(1, "open dd rdwr succeeded!\n");
    23e6:	83 ec 08             	sub    $0x8,%esp
    23e9:	68 7d 51 00 00       	push   $0x517d
    23ee:	6a 01                	push   $0x1
    23f0:	e8 80 1d 00 00       	call   4175 <printf>
    23f5:	83 c4 10             	add    $0x10,%esp
    exit();
    23f8:	e8 fc 1b 00 00       	call   3ff9 <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    23fd:	83 ec 08             	sub    $0x8,%esp
    2400:	6a 01                	push   $0x1
    2402:	68 15 4f 00 00       	push   $0x4f15
    2407:	e8 2d 1c 00 00       	call   4039 <open>
    240c:	83 c4 10             	add    $0x10,%esp
    240f:	85 c0                	test   %eax,%eax
    2411:	78 17                	js     242a <subdir+0x49b>
    printf(1, "open dd wronly succeeded!\n");
    2413:	83 ec 08             	sub    $0x8,%esp
    2416:	68 96 51 00 00       	push   $0x5196
    241b:	6a 01                	push   $0x1
    241d:	e8 53 1d 00 00       	call   4175 <printf>
    2422:	83 c4 10             	add    $0x10,%esp
    exit();
    2425:	e8 cf 1b 00 00       	call   3ff9 <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    242a:	83 ec 08             	sub    $0x8,%esp
    242d:	68 b1 51 00 00       	push   $0x51b1
    2432:	68 1d 51 00 00       	push   $0x511d
    2437:	e8 1d 1c 00 00       	call   4059 <link>
    243c:	83 c4 10             	add    $0x10,%esp
    243f:	85 c0                	test   %eax,%eax
    2441:	75 17                	jne    245a <subdir+0x4cb>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    2443:	83 ec 08             	sub    $0x8,%esp
    2446:	68 bc 51 00 00       	push   $0x51bc
    244b:	6a 01                	push   $0x1
    244d:	e8 23 1d 00 00       	call   4175 <printf>
    2452:	83 c4 10             	add    $0x10,%esp
    exit();
    2455:	e8 9f 1b 00 00       	call   3ff9 <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    245a:	83 ec 08             	sub    $0x8,%esp
    245d:	68 b1 51 00 00       	push   $0x51b1
    2462:	68 42 51 00 00       	push   $0x5142
    2467:	e8 ed 1b 00 00       	call   4059 <link>
    246c:	83 c4 10             	add    $0x10,%esp
    246f:	85 c0                	test   %eax,%eax
    2471:	75 17                	jne    248a <subdir+0x4fb>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2473:	83 ec 08             	sub    $0x8,%esp
    2476:	68 e0 51 00 00       	push   $0x51e0
    247b:	6a 01                	push   $0x1
    247d:	e8 f3 1c 00 00       	call   4175 <printf>
    2482:	83 c4 10             	add    $0x10,%esp
    exit();
    2485:	e8 6f 1b 00 00       	call   3ff9 <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    248a:	83 ec 08             	sub    $0x8,%esp
    248d:	68 f8 4f 00 00       	push   $0x4ff8
    2492:	68 30 4f 00 00       	push   $0x4f30
    2497:	e8 bd 1b 00 00       	call   4059 <link>
    249c:	83 c4 10             	add    $0x10,%esp
    249f:	85 c0                	test   %eax,%eax
    24a1:	75 17                	jne    24ba <subdir+0x52b>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    24a3:	83 ec 08             	sub    $0x8,%esp
    24a6:	68 04 52 00 00       	push   $0x5204
    24ab:	6a 01                	push   $0x1
    24ad:	e8 c3 1c 00 00       	call   4175 <printf>
    24b2:	83 c4 10             	add    $0x10,%esp
    exit();
    24b5:	e8 3f 1b 00 00       	call   3ff9 <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    24ba:	83 ec 0c             	sub    $0xc,%esp
    24bd:	68 1d 51 00 00       	push   $0x511d
    24c2:	e8 9a 1b 00 00       	call   4061 <mkdir>
    24c7:	83 c4 10             	add    $0x10,%esp
    24ca:	85 c0                	test   %eax,%eax
    24cc:	75 17                	jne    24e5 <subdir+0x556>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    24ce:	83 ec 08             	sub    $0x8,%esp
    24d1:	68 26 52 00 00       	push   $0x5226
    24d6:	6a 01                	push   $0x1
    24d8:	e8 98 1c 00 00       	call   4175 <printf>
    24dd:	83 c4 10             	add    $0x10,%esp
    exit();
    24e0:	e8 14 1b 00 00       	call   3ff9 <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    24e5:	83 ec 0c             	sub    $0xc,%esp
    24e8:	68 42 51 00 00       	push   $0x5142
    24ed:	e8 6f 1b 00 00       	call   4061 <mkdir>
    24f2:	83 c4 10             	add    $0x10,%esp
    24f5:	85 c0                	test   %eax,%eax
    24f7:	75 17                	jne    2510 <subdir+0x581>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    24f9:	83 ec 08             	sub    $0x8,%esp
    24fc:	68 41 52 00 00       	push   $0x5241
    2501:	6a 01                	push   $0x1
    2503:	e8 6d 1c 00 00       	call   4175 <printf>
    2508:	83 c4 10             	add    $0x10,%esp
    exit();
    250b:	e8 e9 1a 00 00       	call   3ff9 <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    2510:	83 ec 0c             	sub    $0xc,%esp
    2513:	68 f8 4f 00 00       	push   $0x4ff8
    2518:	e8 44 1b 00 00       	call   4061 <mkdir>
    251d:	83 c4 10             	add    $0x10,%esp
    2520:	85 c0                	test   %eax,%eax
    2522:	75 17                	jne    253b <subdir+0x5ac>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2524:	83 ec 08             	sub    $0x8,%esp
    2527:	68 5c 52 00 00       	push   $0x525c
    252c:	6a 01                	push   $0x1
    252e:	e8 42 1c 00 00       	call   4175 <printf>
    2533:	83 c4 10             	add    $0x10,%esp
    exit();
    2536:	e8 be 1a 00 00       	call   3ff9 <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    253b:	83 ec 0c             	sub    $0xc,%esp
    253e:	68 42 51 00 00       	push   $0x5142
    2543:	e8 01 1b 00 00       	call   4049 <unlink>
    2548:	83 c4 10             	add    $0x10,%esp
    254b:	85 c0                	test   %eax,%eax
    254d:	75 17                	jne    2566 <subdir+0x5d7>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    254f:	83 ec 08             	sub    $0x8,%esp
    2552:	68 79 52 00 00       	push   $0x5279
    2557:	6a 01                	push   $0x1
    2559:	e8 17 1c 00 00       	call   4175 <printf>
    255e:	83 c4 10             	add    $0x10,%esp
    exit();
    2561:	e8 93 1a 00 00       	call   3ff9 <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    2566:	83 ec 0c             	sub    $0xc,%esp
    2569:	68 1d 51 00 00       	push   $0x511d
    256e:	e8 d6 1a 00 00       	call   4049 <unlink>
    2573:	83 c4 10             	add    $0x10,%esp
    2576:	85 c0                	test   %eax,%eax
    2578:	75 17                	jne    2591 <subdir+0x602>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    257a:	83 ec 08             	sub    $0x8,%esp
    257d:	68 95 52 00 00       	push   $0x5295
    2582:	6a 01                	push   $0x1
    2584:	e8 ec 1b 00 00       	call   4175 <printf>
    2589:	83 c4 10             	add    $0x10,%esp
    exit();
    258c:	e8 68 1a 00 00       	call   3ff9 <exit>
  }
  if(chdir("dd/ff") == 0){
    2591:	83 ec 0c             	sub    $0xc,%esp
    2594:	68 30 4f 00 00       	push   $0x4f30
    2599:	e8 cb 1a 00 00       	call   4069 <chdir>
    259e:	83 c4 10             	add    $0x10,%esp
    25a1:	85 c0                	test   %eax,%eax
    25a3:	75 17                	jne    25bc <subdir+0x62d>
    printf(1, "chdir dd/ff succeeded!\n");
    25a5:	83 ec 08             	sub    $0x8,%esp
    25a8:	68 b1 52 00 00       	push   $0x52b1
    25ad:	6a 01                	push   $0x1
    25af:	e8 c1 1b 00 00       	call   4175 <printf>
    25b4:	83 c4 10             	add    $0x10,%esp
    exit();
    25b7:	e8 3d 1a 00 00       	call   3ff9 <exit>
  }
  if(chdir("dd/xx") == 0){
    25bc:	83 ec 0c             	sub    $0xc,%esp
    25bf:	68 c9 52 00 00       	push   $0x52c9
    25c4:	e8 a0 1a 00 00       	call   4069 <chdir>
    25c9:	83 c4 10             	add    $0x10,%esp
    25cc:	85 c0                	test   %eax,%eax
    25ce:	75 17                	jne    25e7 <subdir+0x658>
    printf(1, "chdir dd/xx succeeded!\n");
    25d0:	83 ec 08             	sub    $0x8,%esp
    25d3:	68 cf 52 00 00       	push   $0x52cf
    25d8:	6a 01                	push   $0x1
    25da:	e8 96 1b 00 00       	call   4175 <printf>
    25df:	83 c4 10             	add    $0x10,%esp
    exit();
    25e2:	e8 12 1a 00 00       	call   3ff9 <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    25e7:	83 ec 0c             	sub    $0xc,%esp
    25ea:	68 f8 4f 00 00       	push   $0x4ff8
    25ef:	e8 55 1a 00 00       	call   4049 <unlink>
    25f4:	83 c4 10             	add    $0x10,%esp
    25f7:	85 c0                	test   %eax,%eax
    25f9:	74 17                	je     2612 <subdir+0x683>
    printf(1, "unlink dd/dd/ff failed\n");
    25fb:	83 ec 08             	sub    $0x8,%esp
    25fe:	68 25 50 00 00       	push   $0x5025
    2603:	6a 01                	push   $0x1
    2605:	e8 6b 1b 00 00       	call   4175 <printf>
    260a:	83 c4 10             	add    $0x10,%esp
    exit();
    260d:	e8 e7 19 00 00       	call   3ff9 <exit>
  }
  if(unlink("dd/ff") != 0){
    2612:	83 ec 0c             	sub    $0xc,%esp
    2615:	68 30 4f 00 00       	push   $0x4f30
    261a:	e8 2a 1a 00 00       	call   4049 <unlink>
    261f:	83 c4 10             	add    $0x10,%esp
    2622:	85 c0                	test   %eax,%eax
    2624:	74 17                	je     263d <subdir+0x6ae>
    printf(1, "unlink dd/ff failed\n");
    2626:	83 ec 08             	sub    $0x8,%esp
    2629:	68 e7 52 00 00       	push   $0x52e7
    262e:	6a 01                	push   $0x1
    2630:	e8 40 1b 00 00       	call   4175 <printf>
    2635:	83 c4 10             	add    $0x10,%esp
    exit();
    2638:	e8 bc 19 00 00       	call   3ff9 <exit>
  }
  if(unlink("dd") == 0){
    263d:	83 ec 0c             	sub    $0xc,%esp
    2640:	68 15 4f 00 00       	push   $0x4f15
    2645:	e8 ff 19 00 00       	call   4049 <unlink>
    264a:	83 c4 10             	add    $0x10,%esp
    264d:	85 c0                	test   %eax,%eax
    264f:	75 17                	jne    2668 <subdir+0x6d9>
    printf(1, "unlink non-empty dd succeeded!\n");
    2651:	83 ec 08             	sub    $0x8,%esp
    2654:	68 fc 52 00 00       	push   $0x52fc
    2659:	6a 01                	push   $0x1
    265b:	e8 15 1b 00 00       	call   4175 <printf>
    2660:	83 c4 10             	add    $0x10,%esp
    exit();
    2663:	e8 91 19 00 00       	call   3ff9 <exit>
  }
  if(unlink("dd/dd") < 0){
    2668:	83 ec 0c             	sub    $0xc,%esp
    266b:	68 1c 53 00 00       	push   $0x531c
    2670:	e8 d4 19 00 00       	call   4049 <unlink>
    2675:	83 c4 10             	add    $0x10,%esp
    2678:	85 c0                	test   %eax,%eax
    267a:	79 17                	jns    2693 <subdir+0x704>
    printf(1, "unlink dd/dd failed\n");
    267c:	83 ec 08             	sub    $0x8,%esp
    267f:	68 22 53 00 00       	push   $0x5322
    2684:	6a 01                	push   $0x1
    2686:	e8 ea 1a 00 00       	call   4175 <printf>
    268b:	83 c4 10             	add    $0x10,%esp
    exit();
    268e:	e8 66 19 00 00       	call   3ff9 <exit>
  }
  if(unlink("dd") < 0){
    2693:	83 ec 0c             	sub    $0xc,%esp
    2696:	68 15 4f 00 00       	push   $0x4f15
    269b:	e8 a9 19 00 00       	call   4049 <unlink>
    26a0:	83 c4 10             	add    $0x10,%esp
    26a3:	85 c0                	test   %eax,%eax
    26a5:	79 17                	jns    26be <subdir+0x72f>
    printf(1, "unlink dd failed\n");
    26a7:	83 ec 08             	sub    $0x8,%esp
    26aa:	68 37 53 00 00       	push   $0x5337
    26af:	6a 01                	push   $0x1
    26b1:	e8 bf 1a 00 00       	call   4175 <printf>
    26b6:	83 c4 10             	add    $0x10,%esp
    exit();
    26b9:	e8 3b 19 00 00       	call   3ff9 <exit>
  }

  printf(1, "subdir ok\n");
    26be:	83 ec 08             	sub    $0x8,%esp
    26c1:	68 49 53 00 00       	push   $0x5349
    26c6:	6a 01                	push   $0x1
    26c8:	e8 a8 1a 00 00       	call   4175 <printf>
    26cd:	83 c4 10             	add    $0x10,%esp
}
    26d0:	90                   	nop
    26d1:	c9                   	leave
    26d2:	c3                   	ret

000026d3 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    26d3:	55                   	push   %ebp
    26d4:	89 e5                	mov    %esp,%ebp
    26d6:	83 ec 18             	sub    $0x18,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    26d9:	83 ec 08             	sub    $0x8,%esp
    26dc:	68 54 53 00 00       	push   $0x5354
    26e1:	6a 01                	push   $0x1
    26e3:	e8 8d 1a 00 00       	call   4175 <printf>
    26e8:	83 c4 10             	add    $0x10,%esp

  unlink("bigwrite");
    26eb:	83 ec 0c             	sub    $0xc,%esp
    26ee:	68 63 53 00 00       	push   $0x5363
    26f3:	e8 51 19 00 00       	call   4049 <unlink>
    26f8:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    26fb:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    2702:	e9 a8 00 00 00       	jmp    27af <bigwrite+0xdc>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2707:	83 ec 08             	sub    $0x8,%esp
    270a:	68 02 02 00 00       	push   $0x202
    270f:	68 63 53 00 00       	push   $0x5363
    2714:	e8 20 19 00 00       	call   4039 <open>
    2719:	83 c4 10             	add    $0x10,%esp
    271c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    271f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2723:	79 17                	jns    273c <bigwrite+0x69>
      printf(1, "cannot create bigwrite\n");
    2725:	83 ec 08             	sub    $0x8,%esp
    2728:	68 6c 53 00 00       	push   $0x536c
    272d:	6a 01                	push   $0x1
    272f:	e8 41 1a 00 00       	call   4175 <printf>
    2734:	83 c4 10             	add    $0x10,%esp
      exit();
    2737:	e8 bd 18 00 00       	call   3ff9 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    273c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2743:	eb 3f                	jmp    2784 <bigwrite+0xb1>
      int cc = write(fd, buf, sz);
    2745:	83 ec 04             	sub    $0x4,%esp
    2748:	ff 75 f4             	push   -0xc(%ebp)
    274b:	68 a0 64 00 00       	push   $0x64a0
    2750:	ff 75 ec             	push   -0x14(%ebp)
    2753:	e8 c1 18 00 00       	call   4019 <write>
    2758:	83 c4 10             	add    $0x10,%esp
    275b:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    275e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2761:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2764:	74 1a                	je     2780 <bigwrite+0xad>
        printf(1, "write(%d) ret %d\n", sz, cc);
    2766:	ff 75 e8             	push   -0x18(%ebp)
    2769:	ff 75 f4             	push   -0xc(%ebp)
    276c:	68 84 53 00 00       	push   $0x5384
    2771:	6a 01                	push   $0x1
    2773:	e8 fd 19 00 00       	call   4175 <printf>
    2778:	83 c4 10             	add    $0x10,%esp
        exit();
    277b:	e8 79 18 00 00       	call   3ff9 <exit>
    for(i = 0; i < 2; i++){
    2780:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2784:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    2788:	7e bb                	jle    2745 <bigwrite+0x72>
      }
    }
    close(fd);
    278a:	83 ec 0c             	sub    $0xc,%esp
    278d:	ff 75 ec             	push   -0x14(%ebp)
    2790:	e8 8c 18 00 00       	call   4021 <close>
    2795:	83 c4 10             	add    $0x10,%esp
    unlink("bigwrite");
    2798:	83 ec 0c             	sub    $0xc,%esp
    279b:	68 63 53 00 00       	push   $0x5363
    27a0:	e8 a4 18 00 00       	call   4049 <unlink>
    27a5:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    27a8:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    27af:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    27b6:	0f 8e 4b ff ff ff    	jle    2707 <bigwrite+0x34>
  }

  printf(1, "bigwrite ok\n");
    27bc:	83 ec 08             	sub    $0x8,%esp
    27bf:	68 96 53 00 00       	push   $0x5396
    27c4:	6a 01                	push   $0x1
    27c6:	e8 aa 19 00 00       	call   4175 <printf>
    27cb:	83 c4 10             	add    $0x10,%esp
}
    27ce:	90                   	nop
    27cf:	c9                   	leave
    27d0:	c3                   	ret

000027d1 <bigfile>:

void
bigfile(void)
{
    27d1:	55                   	push   %ebp
    27d2:	89 e5                	mov    %esp,%ebp
    27d4:	83 ec 18             	sub    $0x18,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    27d7:	83 ec 08             	sub    $0x8,%esp
    27da:	68 a3 53 00 00       	push   $0x53a3
    27df:	6a 01                	push   $0x1
    27e1:	e8 8f 19 00 00       	call   4175 <printf>
    27e6:	83 c4 10             	add    $0x10,%esp

  unlink("bigfile");
    27e9:	83 ec 0c             	sub    $0xc,%esp
    27ec:	68 b1 53 00 00       	push   $0x53b1
    27f1:	e8 53 18 00 00       	call   4049 <unlink>
    27f6:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", O_CREATE | O_RDWR);
    27f9:	83 ec 08             	sub    $0x8,%esp
    27fc:	68 02 02 00 00       	push   $0x202
    2801:	68 b1 53 00 00       	push   $0x53b1
    2806:	e8 2e 18 00 00       	call   4039 <open>
    280b:	83 c4 10             	add    $0x10,%esp
    280e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    2811:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2815:	79 17                	jns    282e <bigfile+0x5d>
    printf(1, "cannot create bigfile");
    2817:	83 ec 08             	sub    $0x8,%esp
    281a:	68 b9 53 00 00       	push   $0x53b9
    281f:	6a 01                	push   $0x1
    2821:	e8 4f 19 00 00       	call   4175 <printf>
    2826:	83 c4 10             	add    $0x10,%esp
    exit();
    2829:	e8 cb 17 00 00       	call   3ff9 <exit>
  }
  for(i = 0; i < 20; i++){
    282e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2835:	eb 52                	jmp    2889 <bigfile+0xb8>
    memset(buf, i, 600);
    2837:	83 ec 04             	sub    $0x4,%esp
    283a:	68 58 02 00 00       	push   $0x258
    283f:	ff 75 f4             	push   -0xc(%ebp)
    2842:	68 a0 64 00 00       	push   $0x64a0
    2847:	e8 12 16 00 00       	call   3e5e <memset>
    284c:	83 c4 10             	add    $0x10,%esp
    if(write(fd, buf, 600) != 600){
    284f:	83 ec 04             	sub    $0x4,%esp
    2852:	68 58 02 00 00       	push   $0x258
    2857:	68 a0 64 00 00       	push   $0x64a0
    285c:	ff 75 ec             	push   -0x14(%ebp)
    285f:	e8 b5 17 00 00       	call   4019 <write>
    2864:	83 c4 10             	add    $0x10,%esp
    2867:	3d 58 02 00 00       	cmp    $0x258,%eax
    286c:	74 17                	je     2885 <bigfile+0xb4>
      printf(1, "write bigfile failed\n");
    286e:	83 ec 08             	sub    $0x8,%esp
    2871:	68 cf 53 00 00       	push   $0x53cf
    2876:	6a 01                	push   $0x1
    2878:	e8 f8 18 00 00       	call   4175 <printf>
    287d:	83 c4 10             	add    $0x10,%esp
      exit();
    2880:	e8 74 17 00 00       	call   3ff9 <exit>
  for(i = 0; i < 20; i++){
    2885:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2889:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    288d:	7e a8                	jle    2837 <bigfile+0x66>
    }
  }
  close(fd);
    288f:	83 ec 0c             	sub    $0xc,%esp
    2892:	ff 75 ec             	push   -0x14(%ebp)
    2895:	e8 87 17 00 00       	call   4021 <close>
    289a:	83 c4 10             	add    $0x10,%esp

  fd = open("bigfile", 0);
    289d:	83 ec 08             	sub    $0x8,%esp
    28a0:	6a 00                	push   $0x0
    28a2:	68 b1 53 00 00       	push   $0x53b1
    28a7:	e8 8d 17 00 00       	call   4039 <open>
    28ac:	83 c4 10             	add    $0x10,%esp
    28af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    28b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    28b6:	79 17                	jns    28cf <bigfile+0xfe>
    printf(1, "cannot open bigfile\n");
    28b8:	83 ec 08             	sub    $0x8,%esp
    28bb:	68 e5 53 00 00       	push   $0x53e5
    28c0:	6a 01                	push   $0x1
    28c2:	e8 ae 18 00 00       	call   4175 <printf>
    28c7:	83 c4 10             	add    $0x10,%esp
    exit();
    28ca:	e8 2a 17 00 00       	call   3ff9 <exit>
  }
  total = 0;
    28cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    28d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    28dd:	83 ec 04             	sub    $0x4,%esp
    28e0:	68 2c 01 00 00       	push   $0x12c
    28e5:	68 a0 64 00 00       	push   $0x64a0
    28ea:	ff 75 ec             	push   -0x14(%ebp)
    28ed:	e8 1f 17 00 00       	call   4011 <read>
    28f2:	83 c4 10             	add    $0x10,%esp
    28f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    28f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    28fc:	79 17                	jns    2915 <bigfile+0x144>
      printf(1, "read bigfile failed\n");
    28fe:	83 ec 08             	sub    $0x8,%esp
    2901:	68 fa 53 00 00       	push   $0x53fa
    2906:	6a 01                	push   $0x1
    2908:	e8 68 18 00 00       	call   4175 <printf>
    290d:	83 c4 10             	add    $0x10,%esp
      exit();
    2910:	e8 e4 16 00 00       	call   3ff9 <exit>
    }
    if(cc == 0)
    2915:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2919:	74 7a                	je     2995 <bigfile+0x1c4>
      break;
    if(cc != 300){
    291b:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    2922:	74 17                	je     293b <bigfile+0x16a>
      printf(1, "short read bigfile\n");
    2924:	83 ec 08             	sub    $0x8,%esp
    2927:	68 0f 54 00 00       	push   $0x540f
    292c:	6a 01                	push   $0x1
    292e:	e8 42 18 00 00       	call   4175 <printf>
    2933:	83 c4 10             	add    $0x10,%esp
      exit();
    2936:	e8 be 16 00 00       	call   3ff9 <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    293b:	0f b6 05 a0 64 00 00 	movzbl 0x64a0,%eax
    2942:	0f be d0             	movsbl %al,%edx
    2945:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2948:	89 c1                	mov    %eax,%ecx
    294a:	c1 e9 1f             	shr    $0x1f,%ecx
    294d:	01 c8                	add    %ecx,%eax
    294f:	d1 f8                	sar    $1,%eax
    2951:	39 c2                	cmp    %eax,%edx
    2953:	75 1a                	jne    296f <bigfile+0x19e>
    2955:	0f b6 05 cb 65 00 00 	movzbl 0x65cb,%eax
    295c:	0f be d0             	movsbl %al,%edx
    295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2962:	89 c1                	mov    %eax,%ecx
    2964:	c1 e9 1f             	shr    $0x1f,%ecx
    2967:	01 c8                	add    %ecx,%eax
    2969:	d1 f8                	sar    $1,%eax
    296b:	39 c2                	cmp    %eax,%edx
    296d:	74 17                	je     2986 <bigfile+0x1b5>
      printf(1, "read bigfile wrong data\n");
    296f:	83 ec 08             	sub    $0x8,%esp
    2972:	68 23 54 00 00       	push   $0x5423
    2977:	6a 01                	push   $0x1
    2979:	e8 f7 17 00 00       	call   4175 <printf>
    297e:	83 c4 10             	add    $0x10,%esp
      exit();
    2981:	e8 73 16 00 00       	call   3ff9 <exit>
    }
    total += cc;
    2986:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2989:	01 45 f0             	add    %eax,-0x10(%ebp)
  for(i = 0; ; i++){
    298c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    cc = read(fd, buf, 300);
    2990:	e9 48 ff ff ff       	jmp    28dd <bigfile+0x10c>
      break;
    2995:	90                   	nop
  }
  close(fd);
    2996:	83 ec 0c             	sub    $0xc,%esp
    2999:	ff 75 ec             	push   -0x14(%ebp)
    299c:	e8 80 16 00 00       	call   4021 <close>
    29a1:	83 c4 10             	add    $0x10,%esp
  if(total != 20*600){
    29a4:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    29ab:	74 17                	je     29c4 <bigfile+0x1f3>
    printf(1, "read bigfile wrong total\n");
    29ad:	83 ec 08             	sub    $0x8,%esp
    29b0:	68 3c 54 00 00       	push   $0x543c
    29b5:	6a 01                	push   $0x1
    29b7:	e8 b9 17 00 00       	call   4175 <printf>
    29bc:	83 c4 10             	add    $0x10,%esp
    exit();
    29bf:	e8 35 16 00 00       	call   3ff9 <exit>
  }
  unlink("bigfile");
    29c4:	83 ec 0c             	sub    $0xc,%esp
    29c7:	68 b1 53 00 00       	push   $0x53b1
    29cc:	e8 78 16 00 00       	call   4049 <unlink>
    29d1:	83 c4 10             	add    $0x10,%esp

  printf(1, "bigfile test ok\n");
    29d4:	83 ec 08             	sub    $0x8,%esp
    29d7:	68 56 54 00 00       	push   $0x5456
    29dc:	6a 01                	push   $0x1
    29de:	e8 92 17 00 00       	call   4175 <printf>
    29e3:	83 c4 10             	add    $0x10,%esp
}
    29e6:	90                   	nop
    29e7:	c9                   	leave
    29e8:	c3                   	ret

000029e9 <fourteen>:

void
fourteen(void)
{
    29e9:	55                   	push   %ebp
    29ea:	89 e5                	mov    %esp,%ebp
    29ec:	83 ec 18             	sub    $0x18,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    29ef:	83 ec 08             	sub    $0x8,%esp
    29f2:	68 67 54 00 00       	push   $0x5467
    29f7:	6a 01                	push   $0x1
    29f9:	e8 77 17 00 00       	call   4175 <printf>
    29fe:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234") != 0){
    2a01:	83 ec 0c             	sub    $0xc,%esp
    2a04:	68 76 54 00 00       	push   $0x5476
    2a09:	e8 53 16 00 00       	call   4061 <mkdir>
    2a0e:	83 c4 10             	add    $0x10,%esp
    2a11:	85 c0                	test   %eax,%eax
    2a13:	74 17                	je     2a2c <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    2a15:	83 ec 08             	sub    $0x8,%esp
    2a18:	68 85 54 00 00       	push   $0x5485
    2a1d:	6a 01                	push   $0x1
    2a1f:	e8 51 17 00 00       	call   4175 <printf>
    2a24:	83 c4 10             	add    $0x10,%esp
    exit();
    2a27:	e8 cd 15 00 00       	call   3ff9 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2a2c:	83 ec 0c             	sub    $0xc,%esp
    2a2f:	68 a4 54 00 00       	push   $0x54a4
    2a34:	e8 28 16 00 00       	call   4061 <mkdir>
    2a39:	83 c4 10             	add    $0x10,%esp
    2a3c:	85 c0                	test   %eax,%eax
    2a3e:	74 17                	je     2a57 <fourteen+0x6e>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2a40:	83 ec 08             	sub    $0x8,%esp
    2a43:	68 c4 54 00 00       	push   $0x54c4
    2a48:	6a 01                	push   $0x1
    2a4a:	e8 26 17 00 00       	call   4175 <printf>
    2a4f:	83 c4 10             	add    $0x10,%esp
    exit();
    2a52:	e8 a2 15 00 00       	call   3ff9 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2a57:	83 ec 08             	sub    $0x8,%esp
    2a5a:	68 00 02 00 00       	push   $0x200
    2a5f:	68 f4 54 00 00       	push   $0x54f4
    2a64:	e8 d0 15 00 00       	call   4039 <open>
    2a69:	83 c4 10             	add    $0x10,%esp
    2a6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a73:	79 17                	jns    2a8c <fourteen+0xa3>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2a75:	83 ec 08             	sub    $0x8,%esp
    2a78:	68 24 55 00 00       	push   $0x5524
    2a7d:	6a 01                	push   $0x1
    2a7f:	e8 f1 16 00 00       	call   4175 <printf>
    2a84:	83 c4 10             	add    $0x10,%esp
    exit();
    2a87:	e8 6d 15 00 00       	call   3ff9 <exit>
  }
  close(fd);
    2a8c:	83 ec 0c             	sub    $0xc,%esp
    2a8f:	ff 75 f4             	push   -0xc(%ebp)
    2a92:	e8 8a 15 00 00       	call   4021 <close>
    2a97:	83 c4 10             	add    $0x10,%esp
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2a9a:	83 ec 08             	sub    $0x8,%esp
    2a9d:	6a 00                	push   $0x0
    2a9f:	68 64 55 00 00       	push   $0x5564
    2aa4:	e8 90 15 00 00       	call   4039 <open>
    2aa9:	83 c4 10             	add    $0x10,%esp
    2aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2aaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2ab3:	79 17                	jns    2acc <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2ab5:	83 ec 08             	sub    $0x8,%esp
    2ab8:	68 94 55 00 00       	push   $0x5594
    2abd:	6a 01                	push   $0x1
    2abf:	e8 b1 16 00 00       	call   4175 <printf>
    2ac4:	83 c4 10             	add    $0x10,%esp
    exit();
    2ac7:	e8 2d 15 00 00       	call   3ff9 <exit>
  }
  close(fd);
    2acc:	83 ec 0c             	sub    $0xc,%esp
    2acf:	ff 75 f4             	push   -0xc(%ebp)
    2ad2:	e8 4a 15 00 00       	call   4021 <close>
    2ad7:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234/12345678901234") == 0){
    2ada:	83 ec 0c             	sub    $0xc,%esp
    2add:	68 ce 55 00 00       	push   $0x55ce
    2ae2:	e8 7a 15 00 00       	call   4061 <mkdir>
    2ae7:	83 c4 10             	add    $0x10,%esp
    2aea:	85 c0                	test   %eax,%eax
    2aec:	75 17                	jne    2b05 <fourteen+0x11c>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2aee:	83 ec 08             	sub    $0x8,%esp
    2af1:	68 ec 55 00 00       	push   $0x55ec
    2af6:	6a 01                	push   $0x1
    2af8:	e8 78 16 00 00       	call   4175 <printf>
    2afd:	83 c4 10             	add    $0x10,%esp
    exit();
    2b00:	e8 f4 14 00 00       	call   3ff9 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2b05:	83 ec 0c             	sub    $0xc,%esp
    2b08:	68 1c 56 00 00       	push   $0x561c
    2b0d:	e8 4f 15 00 00       	call   4061 <mkdir>
    2b12:	83 c4 10             	add    $0x10,%esp
    2b15:	85 c0                	test   %eax,%eax
    2b17:	75 17                	jne    2b30 <fourteen+0x147>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2b19:	83 ec 08             	sub    $0x8,%esp
    2b1c:	68 3c 56 00 00       	push   $0x563c
    2b21:	6a 01                	push   $0x1
    2b23:	e8 4d 16 00 00       	call   4175 <printf>
    2b28:	83 c4 10             	add    $0x10,%esp
    exit();
    2b2b:	e8 c9 14 00 00       	call   3ff9 <exit>
  }

  printf(1, "fourteen ok\n");
    2b30:	83 ec 08             	sub    $0x8,%esp
    2b33:	68 6d 56 00 00       	push   $0x566d
    2b38:	6a 01                	push   $0x1
    2b3a:	e8 36 16 00 00       	call   4175 <printf>
    2b3f:	83 c4 10             	add    $0x10,%esp
}
    2b42:	90                   	nop
    2b43:	c9                   	leave
    2b44:	c3                   	ret

00002b45 <rmdot>:

void
rmdot(void)
{
    2b45:	55                   	push   %ebp
    2b46:	89 e5                	mov    %esp,%ebp
    2b48:	83 ec 08             	sub    $0x8,%esp
  printf(1, "rmdot test\n");
    2b4b:	83 ec 08             	sub    $0x8,%esp
    2b4e:	68 7a 56 00 00       	push   $0x567a
    2b53:	6a 01                	push   $0x1
    2b55:	e8 1b 16 00 00       	call   4175 <printf>
    2b5a:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dots") != 0){
    2b5d:	83 ec 0c             	sub    $0xc,%esp
    2b60:	68 86 56 00 00       	push   $0x5686
    2b65:	e8 f7 14 00 00       	call   4061 <mkdir>
    2b6a:	83 c4 10             	add    $0x10,%esp
    2b6d:	85 c0                	test   %eax,%eax
    2b6f:	74 17                	je     2b88 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    2b71:	83 ec 08             	sub    $0x8,%esp
    2b74:	68 8b 56 00 00       	push   $0x568b
    2b79:	6a 01                	push   $0x1
    2b7b:	e8 f5 15 00 00       	call   4175 <printf>
    2b80:	83 c4 10             	add    $0x10,%esp
    exit();
    2b83:	e8 71 14 00 00       	call   3ff9 <exit>
  }
  if(chdir("dots") != 0){
    2b88:	83 ec 0c             	sub    $0xc,%esp
    2b8b:	68 86 56 00 00       	push   $0x5686
    2b90:	e8 d4 14 00 00       	call   4069 <chdir>
    2b95:	83 c4 10             	add    $0x10,%esp
    2b98:	85 c0                	test   %eax,%eax
    2b9a:	74 17                	je     2bb3 <rmdot+0x6e>
    printf(1, "chdir dots failed\n");
    2b9c:	83 ec 08             	sub    $0x8,%esp
    2b9f:	68 9e 56 00 00       	push   $0x569e
    2ba4:	6a 01                	push   $0x1
    2ba6:	e8 ca 15 00 00       	call   4175 <printf>
    2bab:	83 c4 10             	add    $0x10,%esp
    exit();
    2bae:	e8 46 14 00 00       	call   3ff9 <exit>
  }
  if(unlink(".") == 0){
    2bb3:	83 ec 0c             	sub    $0xc,%esp
    2bb6:	68 b7 4d 00 00       	push   $0x4db7
    2bbb:	e8 89 14 00 00       	call   4049 <unlink>
    2bc0:	83 c4 10             	add    $0x10,%esp
    2bc3:	85 c0                	test   %eax,%eax
    2bc5:	75 17                	jne    2bde <rmdot+0x99>
    printf(1, "rm . worked!\n");
    2bc7:	83 ec 08             	sub    $0x8,%esp
    2bca:	68 b1 56 00 00       	push   $0x56b1
    2bcf:	6a 01                	push   $0x1
    2bd1:	e8 9f 15 00 00       	call   4175 <printf>
    2bd6:	83 c4 10             	add    $0x10,%esp
    exit();
    2bd9:	e8 1b 14 00 00       	call   3ff9 <exit>
  }
  if(unlink("..") == 0){
    2bde:	83 ec 0c             	sub    $0xc,%esp
    2be1:	68 4a 49 00 00       	push   $0x494a
    2be6:	e8 5e 14 00 00       	call   4049 <unlink>
    2beb:	83 c4 10             	add    $0x10,%esp
    2bee:	85 c0                	test   %eax,%eax
    2bf0:	75 17                	jne    2c09 <rmdot+0xc4>
    printf(1, "rm .. worked!\n");
    2bf2:	83 ec 08             	sub    $0x8,%esp
    2bf5:	68 bf 56 00 00       	push   $0x56bf
    2bfa:	6a 01                	push   $0x1
    2bfc:	e8 74 15 00 00       	call   4175 <printf>
    2c01:	83 c4 10             	add    $0x10,%esp
    exit();
    2c04:	e8 f0 13 00 00       	call   3ff9 <exit>
  }
  if(chdir("/") != 0){
    2c09:	83 ec 0c             	sub    $0xc,%esp
    2c0c:	68 9e 45 00 00       	push   $0x459e
    2c11:	e8 53 14 00 00       	call   4069 <chdir>
    2c16:	83 c4 10             	add    $0x10,%esp
    2c19:	85 c0                	test   %eax,%eax
    2c1b:	74 17                	je     2c34 <rmdot+0xef>
    printf(1, "chdir / failed\n");
    2c1d:	83 ec 08             	sub    $0x8,%esp
    2c20:	68 a0 45 00 00       	push   $0x45a0
    2c25:	6a 01                	push   $0x1
    2c27:	e8 49 15 00 00       	call   4175 <printf>
    2c2c:	83 c4 10             	add    $0x10,%esp
    exit();
    2c2f:	e8 c5 13 00 00       	call   3ff9 <exit>
  }
  if(unlink("dots/.") == 0){
    2c34:	83 ec 0c             	sub    $0xc,%esp
    2c37:	68 ce 56 00 00       	push   $0x56ce
    2c3c:	e8 08 14 00 00       	call   4049 <unlink>
    2c41:	83 c4 10             	add    $0x10,%esp
    2c44:	85 c0                	test   %eax,%eax
    2c46:	75 17                	jne    2c5f <rmdot+0x11a>
    printf(1, "unlink dots/. worked!\n");
    2c48:	83 ec 08             	sub    $0x8,%esp
    2c4b:	68 d5 56 00 00       	push   $0x56d5
    2c50:	6a 01                	push   $0x1
    2c52:	e8 1e 15 00 00       	call   4175 <printf>
    2c57:	83 c4 10             	add    $0x10,%esp
    exit();
    2c5a:	e8 9a 13 00 00       	call   3ff9 <exit>
  }
  if(unlink("dots/..") == 0){
    2c5f:	83 ec 0c             	sub    $0xc,%esp
    2c62:	68 ec 56 00 00       	push   $0x56ec
    2c67:	e8 dd 13 00 00       	call   4049 <unlink>
    2c6c:	83 c4 10             	add    $0x10,%esp
    2c6f:	85 c0                	test   %eax,%eax
    2c71:	75 17                	jne    2c8a <rmdot+0x145>
    printf(1, "unlink dots/.. worked!\n");
    2c73:	83 ec 08             	sub    $0x8,%esp
    2c76:	68 f4 56 00 00       	push   $0x56f4
    2c7b:	6a 01                	push   $0x1
    2c7d:	e8 f3 14 00 00       	call   4175 <printf>
    2c82:	83 c4 10             	add    $0x10,%esp
    exit();
    2c85:	e8 6f 13 00 00       	call   3ff9 <exit>
  }
  if(unlink("dots") != 0){
    2c8a:	83 ec 0c             	sub    $0xc,%esp
    2c8d:	68 86 56 00 00       	push   $0x5686
    2c92:	e8 b2 13 00 00       	call   4049 <unlink>
    2c97:	83 c4 10             	add    $0x10,%esp
    2c9a:	85 c0                	test   %eax,%eax
    2c9c:	74 17                	je     2cb5 <rmdot+0x170>
    printf(1, "unlink dots failed!\n");
    2c9e:	83 ec 08             	sub    $0x8,%esp
    2ca1:	68 0c 57 00 00       	push   $0x570c
    2ca6:	6a 01                	push   $0x1
    2ca8:	e8 c8 14 00 00       	call   4175 <printf>
    2cad:	83 c4 10             	add    $0x10,%esp
    exit();
    2cb0:	e8 44 13 00 00       	call   3ff9 <exit>
  }
  printf(1, "rmdot ok\n");
    2cb5:	83 ec 08             	sub    $0x8,%esp
    2cb8:	68 21 57 00 00       	push   $0x5721
    2cbd:	6a 01                	push   $0x1
    2cbf:	e8 b1 14 00 00       	call   4175 <printf>
    2cc4:	83 c4 10             	add    $0x10,%esp
}
    2cc7:	90                   	nop
    2cc8:	c9                   	leave
    2cc9:	c3                   	ret

00002cca <dirfile>:

void
dirfile(void)
{
    2cca:	55                   	push   %ebp
    2ccb:	89 e5                	mov    %esp,%ebp
    2ccd:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "dir vs file\n");
    2cd0:	83 ec 08             	sub    $0x8,%esp
    2cd3:	68 2b 57 00 00       	push   $0x572b
    2cd8:	6a 01                	push   $0x1
    2cda:	e8 96 14 00 00       	call   4175 <printf>
    2cdf:	83 c4 10             	add    $0x10,%esp

  fd = open("dirfile", O_CREATE);
    2ce2:	83 ec 08             	sub    $0x8,%esp
    2ce5:	68 00 02 00 00       	push   $0x200
    2cea:	68 38 57 00 00       	push   $0x5738
    2cef:	e8 45 13 00 00       	call   4039 <open>
    2cf4:	83 c4 10             	add    $0x10,%esp
    2cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2cfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2cfe:	79 17                	jns    2d17 <dirfile+0x4d>
    printf(1, "create dirfile failed\n");
    2d00:	83 ec 08             	sub    $0x8,%esp
    2d03:	68 40 57 00 00       	push   $0x5740
    2d08:	6a 01                	push   $0x1
    2d0a:	e8 66 14 00 00       	call   4175 <printf>
    2d0f:	83 c4 10             	add    $0x10,%esp
    exit();
    2d12:	e8 e2 12 00 00       	call   3ff9 <exit>
  }
  close(fd);
    2d17:	83 ec 0c             	sub    $0xc,%esp
    2d1a:	ff 75 f4             	push   -0xc(%ebp)
    2d1d:	e8 ff 12 00 00       	call   4021 <close>
    2d22:	83 c4 10             	add    $0x10,%esp
  if(chdir("dirfile") == 0){
    2d25:	83 ec 0c             	sub    $0xc,%esp
    2d28:	68 38 57 00 00       	push   $0x5738
    2d2d:	e8 37 13 00 00       	call   4069 <chdir>
    2d32:	83 c4 10             	add    $0x10,%esp
    2d35:	85 c0                	test   %eax,%eax
    2d37:	75 17                	jne    2d50 <dirfile+0x86>
    printf(1, "chdir dirfile succeeded!\n");
    2d39:	83 ec 08             	sub    $0x8,%esp
    2d3c:	68 57 57 00 00       	push   $0x5757
    2d41:	6a 01                	push   $0x1
    2d43:	e8 2d 14 00 00       	call   4175 <printf>
    2d48:	83 c4 10             	add    $0x10,%esp
    exit();
    2d4b:	e8 a9 12 00 00       	call   3ff9 <exit>
  }
  fd = open("dirfile/xx", 0);
    2d50:	83 ec 08             	sub    $0x8,%esp
    2d53:	6a 00                	push   $0x0
    2d55:	68 71 57 00 00       	push   $0x5771
    2d5a:	e8 da 12 00 00       	call   4039 <open>
    2d5f:	83 c4 10             	add    $0x10,%esp
    2d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d69:	78 17                	js     2d82 <dirfile+0xb8>
    printf(1, "create dirfile/xx succeeded!\n");
    2d6b:	83 ec 08             	sub    $0x8,%esp
    2d6e:	68 7c 57 00 00       	push   $0x577c
    2d73:	6a 01                	push   $0x1
    2d75:	e8 fb 13 00 00       	call   4175 <printf>
    2d7a:	83 c4 10             	add    $0x10,%esp
    exit();
    2d7d:	e8 77 12 00 00       	call   3ff9 <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2d82:	83 ec 08             	sub    $0x8,%esp
    2d85:	68 00 02 00 00       	push   $0x200
    2d8a:	68 71 57 00 00       	push   $0x5771
    2d8f:	e8 a5 12 00 00       	call   4039 <open>
    2d94:	83 c4 10             	add    $0x10,%esp
    2d97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d9e:	78 17                	js     2db7 <dirfile+0xed>
    printf(1, "create dirfile/xx succeeded!\n");
    2da0:	83 ec 08             	sub    $0x8,%esp
    2da3:	68 7c 57 00 00       	push   $0x577c
    2da8:	6a 01                	push   $0x1
    2daa:	e8 c6 13 00 00       	call   4175 <printf>
    2daf:	83 c4 10             	add    $0x10,%esp
    exit();
    2db2:	e8 42 12 00 00       	call   3ff9 <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2db7:	83 ec 0c             	sub    $0xc,%esp
    2dba:	68 71 57 00 00       	push   $0x5771
    2dbf:	e8 9d 12 00 00       	call   4061 <mkdir>
    2dc4:	83 c4 10             	add    $0x10,%esp
    2dc7:	85 c0                	test   %eax,%eax
    2dc9:	75 17                	jne    2de2 <dirfile+0x118>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2dcb:	83 ec 08             	sub    $0x8,%esp
    2dce:	68 9a 57 00 00       	push   $0x579a
    2dd3:	6a 01                	push   $0x1
    2dd5:	e8 9b 13 00 00       	call   4175 <printf>
    2dda:	83 c4 10             	add    $0x10,%esp
    exit();
    2ddd:	e8 17 12 00 00       	call   3ff9 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2de2:	83 ec 0c             	sub    $0xc,%esp
    2de5:	68 71 57 00 00       	push   $0x5771
    2dea:	e8 5a 12 00 00       	call   4049 <unlink>
    2def:	83 c4 10             	add    $0x10,%esp
    2df2:	85 c0                	test   %eax,%eax
    2df4:	75 17                	jne    2e0d <dirfile+0x143>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2df6:	83 ec 08             	sub    $0x8,%esp
    2df9:	68 b7 57 00 00       	push   $0x57b7
    2dfe:	6a 01                	push   $0x1
    2e00:	e8 70 13 00 00       	call   4175 <printf>
    2e05:	83 c4 10             	add    $0x10,%esp
    exit();
    2e08:	e8 ec 11 00 00       	call   3ff9 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2e0d:	83 ec 08             	sub    $0x8,%esp
    2e10:	68 71 57 00 00       	push   $0x5771
    2e15:	68 d5 57 00 00       	push   $0x57d5
    2e1a:	e8 3a 12 00 00       	call   4059 <link>
    2e1f:	83 c4 10             	add    $0x10,%esp
    2e22:	85 c0                	test   %eax,%eax
    2e24:	75 17                	jne    2e3d <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2e26:	83 ec 08             	sub    $0x8,%esp
    2e29:	68 dc 57 00 00       	push   $0x57dc
    2e2e:	6a 01                	push   $0x1
    2e30:	e8 40 13 00 00       	call   4175 <printf>
    2e35:	83 c4 10             	add    $0x10,%esp
    exit();
    2e38:	e8 bc 11 00 00       	call   3ff9 <exit>
  }
  if(unlink("dirfile") != 0){
    2e3d:	83 ec 0c             	sub    $0xc,%esp
    2e40:	68 38 57 00 00       	push   $0x5738
    2e45:	e8 ff 11 00 00       	call   4049 <unlink>
    2e4a:	83 c4 10             	add    $0x10,%esp
    2e4d:	85 c0                	test   %eax,%eax
    2e4f:	74 17                	je     2e68 <dirfile+0x19e>
    printf(1, "unlink dirfile failed!\n");
    2e51:	83 ec 08             	sub    $0x8,%esp
    2e54:	68 fb 57 00 00       	push   $0x57fb
    2e59:	6a 01                	push   $0x1
    2e5b:	e8 15 13 00 00       	call   4175 <printf>
    2e60:	83 c4 10             	add    $0x10,%esp
    exit();
    2e63:	e8 91 11 00 00       	call   3ff9 <exit>
  }

  fd = open(".", O_RDWR);
    2e68:	83 ec 08             	sub    $0x8,%esp
    2e6b:	6a 02                	push   $0x2
    2e6d:	68 b7 4d 00 00       	push   $0x4db7
    2e72:	e8 c2 11 00 00       	call   4039 <open>
    2e77:	83 c4 10             	add    $0x10,%esp
    2e7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2e7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e81:	78 17                	js     2e9a <dirfile+0x1d0>
    printf(1, "open . for writing succeeded!\n");
    2e83:	83 ec 08             	sub    $0x8,%esp
    2e86:	68 14 58 00 00       	push   $0x5814
    2e8b:	6a 01                	push   $0x1
    2e8d:	e8 e3 12 00 00       	call   4175 <printf>
    2e92:	83 c4 10             	add    $0x10,%esp
    exit();
    2e95:	e8 5f 11 00 00       	call   3ff9 <exit>
  }
  fd = open(".", 0);
    2e9a:	83 ec 08             	sub    $0x8,%esp
    2e9d:	6a 00                	push   $0x0
    2e9f:	68 b7 4d 00 00       	push   $0x4db7
    2ea4:	e8 90 11 00 00       	call   4039 <open>
    2ea9:	83 c4 10             	add    $0x10,%esp
    2eac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2eaf:	83 ec 04             	sub    $0x4,%esp
    2eb2:	6a 01                	push   $0x1
    2eb4:	68 03 4a 00 00       	push   $0x4a03
    2eb9:	ff 75 f4             	push   -0xc(%ebp)
    2ebc:	e8 58 11 00 00       	call   4019 <write>
    2ec1:	83 c4 10             	add    $0x10,%esp
    2ec4:	85 c0                	test   %eax,%eax
    2ec6:	7e 17                	jle    2edf <dirfile+0x215>
    printf(1, "write . succeeded!\n");
    2ec8:	83 ec 08             	sub    $0x8,%esp
    2ecb:	68 33 58 00 00       	push   $0x5833
    2ed0:	6a 01                	push   $0x1
    2ed2:	e8 9e 12 00 00       	call   4175 <printf>
    2ed7:	83 c4 10             	add    $0x10,%esp
    exit();
    2eda:	e8 1a 11 00 00       	call   3ff9 <exit>
  }
  close(fd);
    2edf:	83 ec 0c             	sub    $0xc,%esp
    2ee2:	ff 75 f4             	push   -0xc(%ebp)
    2ee5:	e8 37 11 00 00       	call   4021 <close>
    2eea:	83 c4 10             	add    $0x10,%esp

  printf(1, "dir vs file OK\n");
    2eed:	83 ec 08             	sub    $0x8,%esp
    2ef0:	68 47 58 00 00       	push   $0x5847
    2ef5:	6a 01                	push   $0x1
    2ef7:	e8 79 12 00 00       	call   4175 <printf>
    2efc:	83 c4 10             	add    $0x10,%esp
}
    2eff:	90                   	nop
    2f00:	c9                   	leave
    2f01:	c3                   	ret

00002f02 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2f02:	55                   	push   %ebp
    2f03:	89 e5                	mov    %esp,%ebp
    2f05:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2f08:	83 ec 08             	sub    $0x8,%esp
    2f0b:	68 57 58 00 00       	push   $0x5857
    2f10:	6a 01                	push   $0x1
    2f12:	e8 5e 12 00 00       	call   4175 <printf>
    2f17:	83 c4 10             	add    $0x10,%esp

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2f1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2f21:	e9 e7 00 00 00       	jmp    300d <iref+0x10b>
    if(mkdir("irefd") != 0){
    2f26:	83 ec 0c             	sub    $0xc,%esp
    2f29:	68 68 58 00 00       	push   $0x5868
    2f2e:	e8 2e 11 00 00       	call   4061 <mkdir>
    2f33:	83 c4 10             	add    $0x10,%esp
    2f36:	85 c0                	test   %eax,%eax
    2f38:	74 17                	je     2f51 <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2f3a:	83 ec 08             	sub    $0x8,%esp
    2f3d:	68 6e 58 00 00       	push   $0x586e
    2f42:	6a 01                	push   $0x1
    2f44:	e8 2c 12 00 00       	call   4175 <printf>
    2f49:	83 c4 10             	add    $0x10,%esp
      exit();
    2f4c:	e8 a8 10 00 00       	call   3ff9 <exit>
    }
    if(chdir("irefd") != 0){
    2f51:	83 ec 0c             	sub    $0xc,%esp
    2f54:	68 68 58 00 00       	push   $0x5868
    2f59:	e8 0b 11 00 00       	call   4069 <chdir>
    2f5e:	83 c4 10             	add    $0x10,%esp
    2f61:	85 c0                	test   %eax,%eax
    2f63:	74 17                	je     2f7c <iref+0x7a>
      printf(1, "chdir irefd failed\n");
    2f65:	83 ec 08             	sub    $0x8,%esp
    2f68:	68 82 58 00 00       	push   $0x5882
    2f6d:	6a 01                	push   $0x1
    2f6f:	e8 01 12 00 00       	call   4175 <printf>
    2f74:	83 c4 10             	add    $0x10,%esp
      exit();
    2f77:	e8 7d 10 00 00       	call   3ff9 <exit>
    }

    mkdir("");
    2f7c:	83 ec 0c             	sub    $0xc,%esp
    2f7f:	68 96 58 00 00       	push   $0x5896
    2f84:	e8 d8 10 00 00       	call   4061 <mkdir>
    2f89:	83 c4 10             	add    $0x10,%esp
    link("README", "");
    2f8c:	83 ec 08             	sub    $0x8,%esp
    2f8f:	68 96 58 00 00       	push   $0x5896
    2f94:	68 d5 57 00 00       	push   $0x57d5
    2f99:	e8 bb 10 00 00       	call   4059 <link>
    2f9e:	83 c4 10             	add    $0x10,%esp
    fd = open("", O_CREATE);
    2fa1:	83 ec 08             	sub    $0x8,%esp
    2fa4:	68 00 02 00 00       	push   $0x200
    2fa9:	68 96 58 00 00       	push   $0x5896
    2fae:	e8 86 10 00 00       	call   4039 <open>
    2fb3:	83 c4 10             	add    $0x10,%esp
    2fb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fbd:	78 0e                	js     2fcd <iref+0xcb>
      close(fd);
    2fbf:	83 ec 0c             	sub    $0xc,%esp
    2fc2:	ff 75 f0             	push   -0x10(%ebp)
    2fc5:	e8 57 10 00 00       	call   4021 <close>
    2fca:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2fcd:	83 ec 08             	sub    $0x8,%esp
    2fd0:	68 00 02 00 00       	push   $0x200
    2fd5:	68 97 58 00 00       	push   $0x5897
    2fda:	e8 5a 10 00 00       	call   4039 <open>
    2fdf:	83 c4 10             	add    $0x10,%esp
    2fe2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fe5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fe9:	78 0e                	js     2ff9 <iref+0xf7>
      close(fd);
    2feb:	83 ec 0c             	sub    $0xc,%esp
    2fee:	ff 75 f0             	push   -0x10(%ebp)
    2ff1:	e8 2b 10 00 00       	call   4021 <close>
    2ff6:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2ff9:	83 ec 0c             	sub    $0xc,%esp
    2ffc:	68 97 58 00 00       	push   $0x5897
    3001:	e8 43 10 00 00       	call   4049 <unlink>
    3006:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 50 + 1; i++){
    3009:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    300d:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    3011:	0f 8e 0f ff ff ff    	jle    2f26 <iref+0x24>
  }

  chdir("/");
    3017:	83 ec 0c             	sub    $0xc,%esp
    301a:	68 9e 45 00 00       	push   $0x459e
    301f:	e8 45 10 00 00       	call   4069 <chdir>
    3024:	83 c4 10             	add    $0x10,%esp
  printf(1, "empty file name OK\n");
    3027:	83 ec 08             	sub    $0x8,%esp
    302a:	68 9a 58 00 00       	push   $0x589a
    302f:	6a 01                	push   $0x1
    3031:	e8 3f 11 00 00       	call   4175 <printf>
    3036:	83 c4 10             	add    $0x10,%esp
}
    3039:	90                   	nop
    303a:	c9                   	leave
    303b:	c3                   	ret

0000303c <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    303c:	55                   	push   %ebp
    303d:	89 e5                	mov    %esp,%ebp
    303f:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
    3042:	83 ec 08             	sub    $0x8,%esp
    3045:	68 ae 58 00 00       	push   $0x58ae
    304a:	6a 01                	push   $0x1
    304c:	e8 24 11 00 00       	call   4175 <printf>
    3051:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<1000; n++){
    3054:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    305b:	eb 1d                	jmp    307a <forktest+0x3e>
    pid = fork();
    305d:	e8 8f 0f 00 00       	call   3ff1 <fork>
    3062:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    3065:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3069:	78 1a                	js     3085 <forktest+0x49>
      break;
    if(pid == 0)
    306b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    306f:	75 05                	jne    3076 <forktest+0x3a>
      exit();
    3071:	e8 83 0f 00 00       	call   3ff9 <exit>
  for(n=0; n<1000; n++){
    3076:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    307a:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    3081:	7e da                	jle    305d <forktest+0x21>
    3083:	eb 01                	jmp    3086 <forktest+0x4a>
      break;
    3085:	90                   	nop
  }

  if(n == 1000){
    3086:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    308d:	75 3b                	jne    30ca <forktest+0x8e>
    printf(1, "fork claimed to work 1000 times!\n");
    308f:	83 ec 08             	sub    $0x8,%esp
    3092:	68 bc 58 00 00       	push   $0x58bc
    3097:	6a 01                	push   $0x1
    3099:	e8 d7 10 00 00       	call   4175 <printf>
    309e:	83 c4 10             	add    $0x10,%esp
    exit();
    30a1:	e8 53 0f 00 00       	call   3ff9 <exit>
  }

  for(; n > 0; n--){
    if(wait() < 0){
    30a6:	e8 56 0f 00 00       	call   4001 <wait>
    30ab:	85 c0                	test   %eax,%eax
    30ad:	79 17                	jns    30c6 <forktest+0x8a>
      printf(1, "wait stopped early\n");
    30af:	83 ec 08             	sub    $0x8,%esp
    30b2:	68 de 58 00 00       	push   $0x58de
    30b7:	6a 01                	push   $0x1
    30b9:	e8 b7 10 00 00       	call   4175 <printf>
    30be:	83 c4 10             	add    $0x10,%esp
      exit();
    30c1:	e8 33 0f 00 00       	call   3ff9 <exit>
  for(; n > 0; n--){
    30c6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    30ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    30ce:	7f d6                	jg     30a6 <forktest+0x6a>
    }
  }

  if(wait() != -1){
    30d0:	e8 2c 0f 00 00       	call   4001 <wait>
    30d5:	83 f8 ff             	cmp    $0xffffffff,%eax
    30d8:	74 17                	je     30f1 <forktest+0xb5>
    printf(1, "wait got too many\n");
    30da:	83 ec 08             	sub    $0x8,%esp
    30dd:	68 f2 58 00 00       	push   $0x58f2
    30e2:	6a 01                	push   $0x1
    30e4:	e8 8c 10 00 00       	call   4175 <printf>
    30e9:	83 c4 10             	add    $0x10,%esp
    exit();
    30ec:	e8 08 0f 00 00       	call   3ff9 <exit>
  }

  printf(1, "fork test OK\n");
    30f1:	83 ec 08             	sub    $0x8,%esp
    30f4:	68 05 59 00 00       	push   $0x5905
    30f9:	6a 01                	push   $0x1
    30fb:	e8 75 10 00 00       	call   4175 <printf>
    3100:	83 c4 10             	add    $0x10,%esp
}
    3103:	90                   	nop
    3104:	c9                   	leave
    3105:	c3                   	ret

00003106 <sbrktest>:

void
sbrktest(void)
{
    3106:	55                   	push   %ebp
    3107:	89 e5                	mov    %esp,%ebp
    3109:	83 ec 68             	sub    $0x68,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    310c:	a1 80 64 00 00       	mov    0x6480,%eax
    3111:	83 ec 08             	sub    $0x8,%esp
    3114:	68 13 59 00 00       	push   $0x5913
    3119:	50                   	push   %eax
    311a:	e8 56 10 00 00       	call   4175 <printf>
    311f:	83 c4 10             	add    $0x10,%esp
  oldbrk = sbrk(0);
    3122:	83 ec 0c             	sub    $0xc,%esp
    3125:	6a 00                	push   $0x0
    3127:	e8 55 0f 00 00       	call   4081 <sbrk>
    312c:	83 c4 10             	add    $0x10,%esp
    312f:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    3132:	83 ec 0c             	sub    $0xc,%esp
    3135:	6a 00                	push   $0x0
    3137:	e8 45 0f 00 00       	call   4081 <sbrk>
    313c:	83 c4 10             	add    $0x10,%esp
    313f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){
    3142:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3149:	eb 4f                	jmp    319a <sbrktest+0x94>
    b = sbrk(1);
    314b:	83 ec 0c             	sub    $0xc,%esp
    314e:	6a 01                	push   $0x1
    3150:	e8 2c 0f 00 00       	call   4081 <sbrk>
    3155:	83 c4 10             	add    $0x10,%esp
    3158:	89 45 d0             	mov    %eax,-0x30(%ebp)
    if(b != a){
    315b:	8b 45 d0             	mov    -0x30(%ebp),%eax
    315e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3161:	74 24                	je     3187 <sbrktest+0x81>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    3163:	a1 80 64 00 00       	mov    0x6480,%eax
    3168:	83 ec 0c             	sub    $0xc,%esp
    316b:	ff 75 d0             	push   -0x30(%ebp)
    316e:	ff 75 f4             	push   -0xc(%ebp)
    3171:	ff 75 f0             	push   -0x10(%ebp)
    3174:	68 1e 59 00 00       	push   $0x591e
    3179:	50                   	push   %eax
    317a:	e8 f6 0f 00 00       	call   4175 <printf>
    317f:	83 c4 20             	add    $0x20,%esp
      exit();
    3182:	e8 72 0e 00 00       	call   3ff9 <exit>
    }
    *b = 1;
    3187:	8b 45 d0             	mov    -0x30(%ebp),%eax
    318a:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    318d:	8b 45 d0             	mov    -0x30(%ebp),%eax
    3190:	83 c0 01             	add    $0x1,%eax
    3193:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; i < 5000; i++){
    3196:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    319a:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    31a1:	7e a8                	jle    314b <sbrktest+0x45>
  }
  pid = fork();
    31a3:	e8 49 0e 00 00       	call   3ff1 <fork>
    31a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(pid < 0){
    31ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    31af:	79 1b                	jns    31cc <sbrktest+0xc6>
    printf(stdout, "sbrk test fork failed\n");
    31b1:	a1 80 64 00 00       	mov    0x6480,%eax
    31b6:	83 ec 08             	sub    $0x8,%esp
    31b9:	68 39 59 00 00       	push   $0x5939
    31be:	50                   	push   %eax
    31bf:	e8 b1 0f 00 00       	call   4175 <printf>
    31c4:	83 c4 10             	add    $0x10,%esp
    exit();
    31c7:	e8 2d 0e 00 00       	call   3ff9 <exit>
  }
  c = sbrk(1);
    31cc:	83 ec 0c             	sub    $0xc,%esp
    31cf:	6a 01                	push   $0x1
    31d1:	e8 ab 0e 00 00       	call   4081 <sbrk>
    31d6:	83 c4 10             	add    $0x10,%esp
    31d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  c = sbrk(1);
    31dc:	83 ec 0c             	sub    $0xc,%esp
    31df:	6a 01                	push   $0x1
    31e1:	e8 9b 0e 00 00       	call   4081 <sbrk>
    31e6:	83 c4 10             	add    $0x10,%esp
    31e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a + 1){
    31ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    31ef:	83 c0 01             	add    $0x1,%eax
    31f2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
    31f5:	74 1b                	je     3212 <sbrktest+0x10c>
    printf(stdout, "sbrk test failed post-fork\n");
    31f7:	a1 80 64 00 00       	mov    0x6480,%eax
    31fc:	83 ec 08             	sub    $0x8,%esp
    31ff:	68 50 59 00 00       	push   $0x5950
    3204:	50                   	push   %eax
    3205:	e8 6b 0f 00 00       	call   4175 <printf>
    320a:	83 c4 10             	add    $0x10,%esp
    exit();
    320d:	e8 e7 0d 00 00       	call   3ff9 <exit>
  }
  if(pid == 0)
    3212:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3216:	75 05                	jne    321d <sbrktest+0x117>
    exit();
    3218:	e8 dc 0d 00 00       	call   3ff9 <exit>
  wait();
    321d:	e8 df 0d 00 00       	call   4001 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    3222:	83 ec 0c             	sub    $0xc,%esp
    3225:	6a 00                	push   $0x0
    3227:	e8 55 0e 00 00       	call   4081 <sbrk>
    322c:	83 c4 10             	add    $0x10,%esp
    322f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    3232:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3235:	ba 00 00 40 06       	mov    $0x6400000,%edx
    323a:	29 c2                	sub    %eax,%edx
    323c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  p = sbrk(amt);
    323f:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3242:	83 ec 0c             	sub    $0xc,%esp
    3245:	50                   	push   %eax
    3246:	e8 36 0e 00 00       	call   4081 <sbrk>
    324b:	83 c4 10             	add    $0x10,%esp
    324e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if (p != a) {
    3251:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3254:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3257:	74 1b                	je     3274 <sbrktest+0x16e>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    3259:	a1 80 64 00 00       	mov    0x6480,%eax
    325e:	83 ec 08             	sub    $0x8,%esp
    3261:	68 6c 59 00 00       	push   $0x596c
    3266:	50                   	push   %eax
    3267:	e8 09 0f 00 00       	call   4175 <printf>
    326c:	83 c4 10             	add    $0x10,%esp
    exit();
    326f:	e8 85 0d 00 00       	call   3ff9 <exit>
  }
  lastaddr = (char*) (BIG-1);
    3274:	c7 45 d8 ff ff 3f 06 	movl   $0x63fffff,-0x28(%ebp)
  *lastaddr = 99;
    327b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    327e:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    3281:	83 ec 0c             	sub    $0xc,%esp
    3284:	6a 00                	push   $0x0
    3286:	e8 f6 0d 00 00       	call   4081 <sbrk>
    328b:	83 c4 10             	add    $0x10,%esp
    328e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    3291:	83 ec 0c             	sub    $0xc,%esp
    3294:	68 00 f0 ff ff       	push   $0xfffff000
    3299:	e8 e3 0d 00 00       	call   4081 <sbrk>
    329e:	83 c4 10             	add    $0x10,%esp
    32a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c == (char*)0xffffffff){
    32a4:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
    32a8:	75 1b                	jne    32c5 <sbrktest+0x1bf>
    printf(stdout, "sbrk could not deallocate\n");
    32aa:	a1 80 64 00 00       	mov    0x6480,%eax
    32af:	83 ec 08             	sub    $0x8,%esp
    32b2:	68 aa 59 00 00       	push   $0x59aa
    32b7:	50                   	push   %eax
    32b8:	e8 b8 0e 00 00       	call   4175 <printf>
    32bd:	83 c4 10             	add    $0x10,%esp
    exit();
    32c0:	e8 34 0d 00 00       	call   3ff9 <exit>
  }
  c = sbrk(0);
    32c5:	83 ec 0c             	sub    $0xc,%esp
    32c8:	6a 00                	push   $0x0
    32ca:	e8 b2 0d 00 00       	call   4081 <sbrk>
    32cf:	83 c4 10             	add    $0x10,%esp
    32d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a - 4096){
    32d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32d8:	2d 00 10 00 00       	sub    $0x1000,%eax
    32dd:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
    32e0:	74 1e                	je     3300 <sbrktest+0x1fa>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    32e2:	a1 80 64 00 00       	mov    0x6480,%eax
    32e7:	ff 75 e4             	push   -0x1c(%ebp)
    32ea:	ff 75 f4             	push   -0xc(%ebp)
    32ed:	68 c8 59 00 00       	push   $0x59c8
    32f2:	50                   	push   %eax
    32f3:	e8 7d 0e 00 00       	call   4175 <printf>
    32f8:	83 c4 10             	add    $0x10,%esp
    exit();
    32fb:	e8 f9 0c 00 00       	call   3ff9 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    3300:	83 ec 0c             	sub    $0xc,%esp
    3303:	6a 00                	push   $0x0
    3305:	e8 77 0d 00 00       	call   4081 <sbrk>
    330a:	83 c4 10             	add    $0x10,%esp
    330d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    3310:	83 ec 0c             	sub    $0xc,%esp
    3313:	68 00 10 00 00       	push   $0x1000
    3318:	e8 64 0d 00 00       	call   4081 <sbrk>
    331d:	83 c4 10             	add    $0x10,%esp
    3320:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    3323:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3326:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3329:	75 1a                	jne    3345 <sbrktest+0x23f>
    332b:	83 ec 0c             	sub    $0xc,%esp
    332e:	6a 00                	push   $0x0
    3330:	e8 4c 0d 00 00       	call   4081 <sbrk>
    3335:	83 c4 10             	add    $0x10,%esp
    3338:	8b 55 f4             	mov    -0xc(%ebp),%edx
    333b:	81 c2 00 10 00 00    	add    $0x1000,%edx
    3341:	39 d0                	cmp    %edx,%eax
    3343:	74 1e                	je     3363 <sbrktest+0x25d>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    3345:	a1 80 64 00 00       	mov    0x6480,%eax
    334a:	ff 75 e4             	push   -0x1c(%ebp)
    334d:	ff 75 f4             	push   -0xc(%ebp)
    3350:	68 00 5a 00 00       	push   $0x5a00
    3355:	50                   	push   %eax
    3356:	e8 1a 0e 00 00       	call   4175 <printf>
    335b:	83 c4 10             	add    $0x10,%esp
    exit();
    335e:	e8 96 0c 00 00       	call   3ff9 <exit>
  }
  if(*lastaddr == 99){
    3363:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3366:	0f b6 00             	movzbl (%eax),%eax
    3369:	3c 63                	cmp    $0x63,%al
    336b:	75 1b                	jne    3388 <sbrktest+0x282>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    336d:	a1 80 64 00 00       	mov    0x6480,%eax
    3372:	83 ec 08             	sub    $0x8,%esp
    3375:	68 28 5a 00 00       	push   $0x5a28
    337a:	50                   	push   %eax
    337b:	e8 f5 0d 00 00       	call   4175 <printf>
    3380:	83 c4 10             	add    $0x10,%esp
    exit();
    3383:	e8 71 0c 00 00       	call   3ff9 <exit>
  }

  a = sbrk(0);
    3388:	83 ec 0c             	sub    $0xc,%esp
    338b:	6a 00                	push   $0x0
    338d:	e8 ef 0c 00 00       	call   4081 <sbrk>
    3392:	83 c4 10             	add    $0x10,%esp
    3395:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    3398:	83 ec 0c             	sub    $0xc,%esp
    339b:	6a 00                	push   $0x0
    339d:	e8 df 0c 00 00       	call   4081 <sbrk>
    33a2:	83 c4 10             	add    $0x10,%esp
    33a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
    33a8:	29 c2                	sub    %eax,%edx
    33aa:	83 ec 0c             	sub    $0xc,%esp
    33ad:	52                   	push   %edx
    33ae:	e8 ce 0c 00 00       	call   4081 <sbrk>
    33b3:	83 c4 10             	add    $0x10,%esp
    33b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(c != a){
    33b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    33bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    33bf:	74 1e                	je     33df <sbrktest+0x2d9>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    33c1:	a1 80 64 00 00       	mov    0x6480,%eax
    33c6:	ff 75 e4             	push   -0x1c(%ebp)
    33c9:	ff 75 f4             	push   -0xc(%ebp)
    33cc:	68 58 5a 00 00       	push   $0x5a58
    33d1:	50                   	push   %eax
    33d2:	e8 9e 0d 00 00       	call   4175 <printf>
    33d7:	83 c4 10             	add    $0x10,%esp
    exit();
    33da:	e8 1a 0c 00 00       	call   3ff9 <exit>
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    33df:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    33e6:	eb 76                	jmp    345e <sbrktest+0x358>
    ppid = getpid();
    33e8:	e8 8c 0c 00 00       	call   4079 <getpid>
    33ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    pid = fork();
    33f0:	e8 fc 0b 00 00       	call   3ff1 <fork>
    33f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pid < 0){
    33f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    33fc:	79 1b                	jns    3419 <sbrktest+0x313>
      printf(stdout, "fork failed\n");
    33fe:	a1 80 64 00 00       	mov    0x6480,%eax
    3403:	83 ec 08             	sub    $0x8,%esp
    3406:	68 cd 45 00 00       	push   $0x45cd
    340b:	50                   	push   %eax
    340c:	e8 64 0d 00 00       	call   4175 <printf>
    3411:	83 c4 10             	add    $0x10,%esp
      exit();
    3414:	e8 e0 0b 00 00       	call   3ff9 <exit>
    }
    if(pid == 0){
    3419:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    341d:	75 33                	jne    3452 <sbrktest+0x34c>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    341f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3422:	0f b6 00             	movzbl (%eax),%eax
    3425:	0f be d0             	movsbl %al,%edx
    3428:	a1 80 64 00 00       	mov    0x6480,%eax
    342d:	52                   	push   %edx
    342e:	ff 75 f4             	push   -0xc(%ebp)
    3431:	68 79 5a 00 00       	push   $0x5a79
    3436:	50                   	push   %eax
    3437:	e8 39 0d 00 00       	call   4175 <printf>
    343c:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
    343f:	83 ec 0c             	sub    $0xc,%esp
    3442:	ff 75 d4             	push   -0x2c(%ebp)
    3445:	e8 df 0b 00 00       	call   4029 <kill>
    344a:	83 c4 10             	add    $0x10,%esp
      exit();
    344d:	e8 a7 0b 00 00       	call   3ff9 <exit>
    }
    wait();
    3452:	e8 aa 0b 00 00       	call   4001 <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3457:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    345e:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    3465:	76 81                	jbe    33e8 <sbrktest+0x2e2>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    3467:	83 ec 0c             	sub    $0xc,%esp
    346a:	8d 45 c8             	lea    -0x38(%ebp),%eax
    346d:	50                   	push   %eax
    346e:	e8 96 0b 00 00       	call   4009 <pipe>
    3473:	83 c4 10             	add    $0x10,%esp
    3476:	85 c0                	test   %eax,%eax
    3478:	74 17                	je     3491 <sbrktest+0x38b>
    printf(1, "pipe() failed\n");
    347a:	83 ec 08             	sub    $0x8,%esp
    347d:	68 9e 49 00 00       	push   $0x499e
    3482:	6a 01                	push   $0x1
    3484:	e8 ec 0c 00 00       	call   4175 <printf>
    3489:	83 c4 10             	add    $0x10,%esp
    exit();
    348c:	e8 68 0b 00 00       	call   3ff9 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3491:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3498:	e9 86 00 00 00       	jmp    3523 <sbrktest+0x41d>
    if((pids[i] = fork()) == 0){
    349d:	e8 4f 0b 00 00       	call   3ff1 <fork>
    34a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
    34a5:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    34a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34ac:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34b0:	85 c0                	test   %eax,%eax
    34b2:	75 4a                	jne    34fe <sbrktest+0x3f8>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    34b4:	83 ec 0c             	sub    $0xc,%esp
    34b7:	6a 00                	push   $0x0
    34b9:	e8 c3 0b 00 00       	call   4081 <sbrk>
    34be:	83 c4 10             	add    $0x10,%esp
    34c1:	89 c2                	mov    %eax,%edx
    34c3:	b8 00 00 40 06       	mov    $0x6400000,%eax
    34c8:	29 d0                	sub    %edx,%eax
    34ca:	83 ec 0c             	sub    $0xc,%esp
    34cd:	50                   	push   %eax
    34ce:	e8 ae 0b 00 00       	call   4081 <sbrk>
    34d3:	83 c4 10             	add    $0x10,%esp
      write(fds[1], "x", 1);
    34d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
    34d9:	83 ec 04             	sub    $0x4,%esp
    34dc:	6a 01                	push   $0x1
    34de:	68 03 4a 00 00       	push   $0x4a03
    34e3:	50                   	push   %eax
    34e4:	e8 30 0b 00 00       	call   4019 <write>
    34e9:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    34ec:	83 ec 0c             	sub    $0xc,%esp
    34ef:	68 e8 03 00 00       	push   $0x3e8
    34f4:	e8 90 0b 00 00       	call   4089 <sleep>
    34f9:	83 c4 10             	add    $0x10,%esp
    34fc:	eb ee                	jmp    34ec <sbrktest+0x3e6>
    }
    if(pids[i] != -1)
    34fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3501:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3505:	83 f8 ff             	cmp    $0xffffffff,%eax
    3508:	74 15                	je     351f <sbrktest+0x419>
      read(fds[0], &scratch, 1);
    350a:	8b 45 c8             	mov    -0x38(%ebp),%eax
    350d:	83 ec 04             	sub    $0x4,%esp
    3510:	6a 01                	push   $0x1
    3512:	8d 55 9f             	lea    -0x61(%ebp),%edx
    3515:	52                   	push   %edx
    3516:	50                   	push   %eax
    3517:	e8 f5 0a 00 00       	call   4011 <read>
    351c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    351f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3523:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3526:	83 f8 09             	cmp    $0x9,%eax
    3529:	0f 86 6e ff ff ff    	jbe    349d <sbrktest+0x397>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    352f:	83 ec 0c             	sub    $0xc,%esp
    3532:	68 00 10 00 00       	push   $0x1000
    3537:	e8 45 0b 00 00       	call   4081 <sbrk>
    353c:	83 c4 10             	add    $0x10,%esp
    353f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3542:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3549:	eb 2b                	jmp    3576 <sbrktest+0x470>
    if(pids[i] == -1)
    354b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    354e:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3552:	83 f8 ff             	cmp    $0xffffffff,%eax
    3555:	74 1a                	je     3571 <sbrktest+0x46b>
      continue;
    kill(pids[i]);
    3557:	8b 45 f0             	mov    -0x10(%ebp),%eax
    355a:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    355e:	83 ec 0c             	sub    $0xc,%esp
    3561:	50                   	push   %eax
    3562:	e8 c2 0a 00 00       	call   4029 <kill>
    3567:	83 c4 10             	add    $0x10,%esp
    wait();
    356a:	e8 92 0a 00 00       	call   4001 <wait>
    356f:	eb 01                	jmp    3572 <sbrktest+0x46c>
      continue;
    3571:	90                   	nop
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3572:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3576:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3579:	83 f8 09             	cmp    $0x9,%eax
    357c:	76 cd                	jbe    354b <sbrktest+0x445>
  }
  if(c == (char*)0xffffffff){
    357e:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
    3582:	75 1b                	jne    359f <sbrktest+0x499>
    printf(stdout, "failed sbrk leaked memory\n");
    3584:	a1 80 64 00 00       	mov    0x6480,%eax
    3589:	83 ec 08             	sub    $0x8,%esp
    358c:	68 92 5a 00 00       	push   $0x5a92
    3591:	50                   	push   %eax
    3592:	e8 de 0b 00 00       	call   4175 <printf>
    3597:	83 c4 10             	add    $0x10,%esp
    exit();
    359a:	e8 5a 0a 00 00       	call   3ff9 <exit>
  }

  if(sbrk(0) > oldbrk)
    359f:	83 ec 0c             	sub    $0xc,%esp
    35a2:	6a 00                	push   $0x0
    35a4:	e8 d8 0a 00 00       	call   4081 <sbrk>
    35a9:	83 c4 10             	add    $0x10,%esp
    35ac:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    35af:	73 1e                	jae    35cf <sbrktest+0x4c9>
    sbrk(-(sbrk(0) - oldbrk));
    35b1:	83 ec 0c             	sub    $0xc,%esp
    35b4:	6a 00                	push   $0x0
    35b6:	e8 c6 0a 00 00       	call   4081 <sbrk>
    35bb:	83 c4 10             	add    $0x10,%esp
    35be:	8b 55 ec             	mov    -0x14(%ebp),%edx
    35c1:	29 c2                	sub    %eax,%edx
    35c3:	83 ec 0c             	sub    $0xc,%esp
    35c6:	52                   	push   %edx
    35c7:	e8 b5 0a 00 00       	call   4081 <sbrk>
    35cc:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "sbrk test OK\n");
    35cf:	a1 80 64 00 00       	mov    0x6480,%eax
    35d4:	83 ec 08             	sub    $0x8,%esp
    35d7:	68 ad 5a 00 00       	push   $0x5aad
    35dc:	50                   	push   %eax
    35dd:	e8 93 0b 00 00       	call   4175 <printf>
    35e2:	83 c4 10             	add    $0x10,%esp
}
    35e5:	90                   	nop
    35e6:	c9                   	leave
    35e7:	c3                   	ret

000035e8 <validateint>:

void
validateint(int *p)
{
    35e8:	55                   	push   %ebp
    35e9:	89 e5                	mov    %esp,%ebp
    35eb:	53                   	push   %ebx
    35ec:	83 ec 10             	sub    $0x10,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    35ef:	b8 0d 00 00 00       	mov    $0xd,%eax
    35f4:	8b 55 08             	mov    0x8(%ebp),%edx
    35f7:	89 d1                	mov    %edx,%ecx
    35f9:	89 e3                	mov    %esp,%ebx
    35fb:	89 cc                	mov    %ecx,%esp
    35fd:	cd 40                	int    $0x40
    35ff:	89 dc                	mov    %ebx,%esp
    3601:	89 45 f8             	mov    %eax,-0x8(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    3604:	90                   	nop
    3605:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3608:	c9                   	leave
    3609:	c3                   	ret

0000360a <validatetest>:

void
validatetest(void)
{
    360a:	55                   	push   %ebp
    360b:	89 e5                	mov    %esp,%ebp
    360d:	83 ec 18             	sub    $0x18,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    3610:	a1 80 64 00 00       	mov    0x6480,%eax
    3615:	83 ec 08             	sub    $0x8,%esp
    3618:	68 bb 5a 00 00       	push   $0x5abb
    361d:	50                   	push   %eax
    361e:	e8 52 0b 00 00       	call   4175 <printf>
    3623:	83 c4 10             	add    $0x10,%esp
  hi = 1100*1024;
    3626:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    362d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3634:	e9 8a 00 00 00       	jmp    36c3 <validatetest+0xb9>
    if((pid = fork()) == 0){
    3639:	e8 b3 09 00 00       	call   3ff1 <fork>
    363e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3641:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3645:	75 14                	jne    365b <validatetest+0x51>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    3647:	8b 45 f4             	mov    -0xc(%ebp),%eax
    364a:	83 ec 0c             	sub    $0xc,%esp
    364d:	50                   	push   %eax
    364e:	e8 95 ff ff ff       	call   35e8 <validateint>
    3653:	83 c4 10             	add    $0x10,%esp
      exit();
    3656:	e8 9e 09 00 00       	call   3ff9 <exit>
    }
    sleep(0);
    365b:	83 ec 0c             	sub    $0xc,%esp
    365e:	6a 00                	push   $0x0
    3660:	e8 24 0a 00 00       	call   4089 <sleep>
    3665:	83 c4 10             	add    $0x10,%esp
    sleep(0);
    3668:	83 ec 0c             	sub    $0xc,%esp
    366b:	6a 00                	push   $0x0
    366d:	e8 17 0a 00 00       	call   4089 <sleep>
    3672:	83 c4 10             	add    $0x10,%esp
    kill(pid);
    3675:	83 ec 0c             	sub    $0xc,%esp
    3678:	ff 75 ec             	push   -0x14(%ebp)
    367b:	e8 a9 09 00 00       	call   4029 <kill>
    3680:	83 c4 10             	add    $0x10,%esp
    wait();
    3683:	e8 79 09 00 00       	call   4001 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    3688:	8b 45 f4             	mov    -0xc(%ebp),%eax
    368b:	83 ec 08             	sub    $0x8,%esp
    368e:	50                   	push   %eax
    368f:	68 ca 5a 00 00       	push   $0x5aca
    3694:	e8 c0 09 00 00       	call   4059 <link>
    3699:	83 c4 10             	add    $0x10,%esp
    369c:	83 f8 ff             	cmp    $0xffffffff,%eax
    369f:	74 1b                	je     36bc <validatetest+0xb2>
      printf(stdout, "link should not succeed\n");
    36a1:	a1 80 64 00 00       	mov    0x6480,%eax
    36a6:	83 ec 08             	sub    $0x8,%esp
    36a9:	68 d5 5a 00 00       	push   $0x5ad5
    36ae:	50                   	push   %eax
    36af:	e8 c1 0a 00 00       	call   4175 <printf>
    36b4:	83 c4 10             	add    $0x10,%esp
      exit();
    36b7:	e8 3d 09 00 00       	call   3ff9 <exit>
  for(p = 0; p <= (uint)hi; p += 4096){
    36bc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    36c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    36c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    36c9:	0f 83 6a ff ff ff    	jae    3639 <validatetest+0x2f>
    }
  }

  printf(stdout, "validate ok\n");
    36cf:	a1 80 64 00 00       	mov    0x6480,%eax
    36d4:	83 ec 08             	sub    $0x8,%esp
    36d7:	68 ee 5a 00 00       	push   $0x5aee
    36dc:	50                   	push   %eax
    36dd:	e8 93 0a 00 00       	call   4175 <printf>
    36e2:	83 c4 10             	add    $0x10,%esp
}
    36e5:	90                   	nop
    36e6:	c9                   	leave
    36e7:	c3                   	ret

000036e8 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    36e8:	55                   	push   %ebp
    36e9:	89 e5                	mov    %esp,%ebp
    36eb:	83 ec 18             	sub    $0x18,%esp
  int i;

  printf(stdout, "bss test\n");
    36ee:	a1 80 64 00 00       	mov    0x6480,%eax
    36f3:	83 ec 08             	sub    $0x8,%esp
    36f6:	68 fb 5a 00 00       	push   $0x5afb
    36fb:	50                   	push   %eax
    36fc:	e8 74 0a 00 00       	call   4175 <printf>
    3701:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    3704:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    370b:	eb 2e                	jmp    373b <bsstest+0x53>
    if(uninit[i] != '\0'){
    370d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3710:	05 c0 84 00 00       	add    $0x84c0,%eax
    3715:	0f b6 00             	movzbl (%eax),%eax
    3718:	84 c0                	test   %al,%al
    371a:	74 1b                	je     3737 <bsstest+0x4f>
      printf(stdout, "bss test failed\n");
    371c:	a1 80 64 00 00       	mov    0x6480,%eax
    3721:	83 ec 08             	sub    $0x8,%esp
    3724:	68 05 5b 00 00       	push   $0x5b05
    3729:	50                   	push   %eax
    372a:	e8 46 0a 00 00       	call   4175 <printf>
    372f:	83 c4 10             	add    $0x10,%esp
      exit();
    3732:	e8 c2 08 00 00       	call   3ff9 <exit>
  for(i = 0; i < sizeof(uninit); i++){
    3737:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    373b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    373e:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    3743:	76 c8                	jbe    370d <bsstest+0x25>
    }
  }
  printf(stdout, "bss test ok\n");
    3745:	a1 80 64 00 00       	mov    0x6480,%eax
    374a:	83 ec 08             	sub    $0x8,%esp
    374d:	68 16 5b 00 00       	push   $0x5b16
    3752:	50                   	push   %eax
    3753:	e8 1d 0a 00 00       	call   4175 <printf>
    3758:	83 c4 10             	add    $0x10,%esp
}
    375b:	90                   	nop
    375c:	c9                   	leave
    375d:	c3                   	ret

0000375e <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    375e:	55                   	push   %ebp
    375f:	89 e5                	mov    %esp,%ebp
    3761:	83 ec 18             	sub    $0x18,%esp
  int pid, fd;

  unlink("bigarg-ok");
    3764:	83 ec 0c             	sub    $0xc,%esp
    3767:	68 23 5b 00 00       	push   $0x5b23
    376c:	e8 d8 08 00 00       	call   4049 <unlink>
    3771:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    3774:	e8 78 08 00 00       	call   3ff1 <fork>
    3779:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    377c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3780:	0f 85 97 00 00 00    	jne    381d <bigargtest+0xbf>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3786:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    378d:	eb 12                	jmp    37a1 <bigargtest+0x43>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    378f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3792:	c7 04 85 e0 ab 00 00 	movl   $0x5b30,0xabe0(,%eax,4)
    3799:	30 5b 00 00 
    for(i = 0; i < MAXARG-1; i++)
    379d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    37a1:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    37a5:	7e e8                	jle    378f <bigargtest+0x31>
    args[MAXARG-1] = 0;
    37a7:	c7 05 5c ac 00 00 00 	movl   $0x0,0xac5c
    37ae:	00 00 00 
    printf(stdout, "bigarg test\n");
    37b1:	a1 80 64 00 00       	mov    0x6480,%eax
    37b6:	83 ec 08             	sub    $0x8,%esp
    37b9:	68 0d 5c 00 00       	push   $0x5c0d
    37be:	50                   	push   %eax
    37bf:	e8 b1 09 00 00       	call   4175 <printf>
    37c4:	83 c4 10             	add    $0x10,%esp
    exec("echo", args);
    37c7:	83 ec 08             	sub    $0x8,%esp
    37ca:	68 e0 ab 00 00       	push   $0xabe0
    37cf:	68 2c 45 00 00       	push   $0x452c
    37d4:	e8 58 08 00 00       	call   4031 <exec>
    37d9:	83 c4 10             	add    $0x10,%esp
    printf(stdout, "bigarg test ok\n");
    37dc:	a1 80 64 00 00       	mov    0x6480,%eax
    37e1:	83 ec 08             	sub    $0x8,%esp
    37e4:	68 1a 5c 00 00       	push   $0x5c1a
    37e9:	50                   	push   %eax
    37ea:	e8 86 09 00 00       	call   4175 <printf>
    37ef:	83 c4 10             	add    $0x10,%esp
    fd = open("bigarg-ok", O_CREATE);
    37f2:	83 ec 08             	sub    $0x8,%esp
    37f5:	68 00 02 00 00       	push   $0x200
    37fa:	68 23 5b 00 00       	push   $0x5b23
    37ff:	e8 35 08 00 00       	call   4039 <open>
    3804:	83 c4 10             	add    $0x10,%esp
    3807:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    380a:	83 ec 0c             	sub    $0xc,%esp
    380d:	ff 75 ec             	push   -0x14(%ebp)
    3810:	e8 0c 08 00 00       	call   4021 <close>
    3815:	83 c4 10             	add    $0x10,%esp
    exit();
    3818:	e8 dc 07 00 00       	call   3ff9 <exit>
  } else if(pid < 0){
    381d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3821:	79 1b                	jns    383e <bigargtest+0xe0>
    printf(stdout, "bigargtest: fork failed\n");
    3823:	a1 80 64 00 00       	mov    0x6480,%eax
    3828:	83 ec 08             	sub    $0x8,%esp
    382b:	68 2a 5c 00 00       	push   $0x5c2a
    3830:	50                   	push   %eax
    3831:	e8 3f 09 00 00       	call   4175 <printf>
    3836:	83 c4 10             	add    $0x10,%esp
    exit();
    3839:	e8 bb 07 00 00       	call   3ff9 <exit>
  }
  wait();
    383e:	e8 be 07 00 00       	call   4001 <wait>
  fd = open("bigarg-ok", 0);
    3843:	83 ec 08             	sub    $0x8,%esp
    3846:	6a 00                	push   $0x0
    3848:	68 23 5b 00 00       	push   $0x5b23
    384d:	e8 e7 07 00 00       	call   4039 <open>
    3852:	83 c4 10             	add    $0x10,%esp
    3855:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    3858:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    385c:	79 1b                	jns    3879 <bigargtest+0x11b>
    printf(stdout, "bigarg test failed!\n");
    385e:	a1 80 64 00 00       	mov    0x6480,%eax
    3863:	83 ec 08             	sub    $0x8,%esp
    3866:	68 43 5c 00 00       	push   $0x5c43
    386b:	50                   	push   %eax
    386c:	e8 04 09 00 00       	call   4175 <printf>
    3871:	83 c4 10             	add    $0x10,%esp
    exit();
    3874:	e8 80 07 00 00       	call   3ff9 <exit>
  }
  close(fd);
    3879:	83 ec 0c             	sub    $0xc,%esp
    387c:	ff 75 ec             	push   -0x14(%ebp)
    387f:	e8 9d 07 00 00       	call   4021 <close>
    3884:	83 c4 10             	add    $0x10,%esp
  unlink("bigarg-ok");
    3887:	83 ec 0c             	sub    $0xc,%esp
    388a:	68 23 5b 00 00       	push   $0x5b23
    388f:	e8 b5 07 00 00       	call   4049 <unlink>
    3894:	83 c4 10             	add    $0x10,%esp
}
    3897:	90                   	nop
    3898:	c9                   	leave
    3899:	c3                   	ret

0000389a <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    389a:	55                   	push   %ebp
    389b:	89 e5                	mov    %esp,%ebp
    389d:	53                   	push   %ebx
    389e:	83 ec 64             	sub    $0x64,%esp
  int nfiles;
  int fsblocks = 0;
    38a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    38a8:	83 ec 08             	sub    $0x8,%esp
    38ab:	68 58 5c 00 00       	push   $0x5c58
    38b0:	6a 01                	push   $0x1
    38b2:	e8 be 08 00 00       	call   4175 <printf>
    38b7:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    38ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    38c1:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    38c5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    38c8:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38cd:	89 c8                	mov    %ecx,%eax
    38cf:	f7 ea                	imul   %edx
    38d1:	c1 fa 06             	sar    $0x6,%edx
    38d4:	89 c8                	mov    %ecx,%eax
    38d6:	c1 f8 1f             	sar    $0x1f,%eax
    38d9:	29 c2                	sub    %eax,%edx
    38db:	89 d0                	mov    %edx,%eax
    38dd:	83 c0 30             	add    $0x30,%eax
    38e0:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    38e3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    38e6:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38eb:	89 d8                	mov    %ebx,%eax
    38ed:	f7 ea                	imul   %edx
    38ef:	c1 fa 06             	sar    $0x6,%edx
    38f2:	89 d8                	mov    %ebx,%eax
    38f4:	c1 f8 1f             	sar    $0x1f,%eax
    38f7:	89 d1                	mov    %edx,%ecx
    38f9:	29 c1                	sub    %eax,%ecx
    38fb:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3901:	29 c3                	sub    %eax,%ebx
    3903:	89 d9                	mov    %ebx,%ecx
    3905:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    390a:	89 c8                	mov    %ecx,%eax
    390c:	f7 ea                	imul   %edx
    390e:	c1 fa 05             	sar    $0x5,%edx
    3911:	89 c8                	mov    %ecx,%eax
    3913:	c1 f8 1f             	sar    $0x1f,%eax
    3916:	29 c2                	sub    %eax,%edx
    3918:	89 d0                	mov    %edx,%eax
    391a:	83 c0 30             	add    $0x30,%eax
    391d:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3920:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3923:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3928:	89 d8                	mov    %ebx,%eax
    392a:	f7 ea                	imul   %edx
    392c:	c1 fa 05             	sar    $0x5,%edx
    392f:	89 d8                	mov    %ebx,%eax
    3931:	c1 f8 1f             	sar    $0x1f,%eax
    3934:	89 d1                	mov    %edx,%ecx
    3936:	29 c1                	sub    %eax,%ecx
    3938:	6b c1 64             	imul   $0x64,%ecx,%eax
    393b:	29 c3                	sub    %eax,%ebx
    393d:	89 d9                	mov    %ebx,%ecx
    393f:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3944:	89 c8                	mov    %ecx,%eax
    3946:	f7 ea                	imul   %edx
    3948:	c1 fa 02             	sar    $0x2,%edx
    394b:	89 c8                	mov    %ecx,%eax
    394d:	c1 f8 1f             	sar    $0x1f,%eax
    3950:	29 c2                	sub    %eax,%edx
    3952:	89 d0                	mov    %edx,%eax
    3954:	83 c0 30             	add    $0x30,%eax
    3957:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    395a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    395d:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3962:	89 c8                	mov    %ecx,%eax
    3964:	f7 ea                	imul   %edx
    3966:	c1 fa 02             	sar    $0x2,%edx
    3969:	89 c8                	mov    %ecx,%eax
    396b:	c1 f8 1f             	sar    $0x1f,%eax
    396e:	29 c2                	sub    %eax,%edx
    3970:	89 d0                	mov    %edx,%eax
    3972:	c1 e0 02             	shl    $0x2,%eax
    3975:	01 d0                	add    %edx,%eax
    3977:	01 c0                	add    %eax,%eax
    3979:	29 c1                	sub    %eax,%ecx
    397b:	89 ca                	mov    %ecx,%edx
    397d:	89 d0                	mov    %edx,%eax
    397f:	83 c0 30             	add    $0x30,%eax
    3982:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3985:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    3989:	83 ec 04             	sub    $0x4,%esp
    398c:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    398f:	50                   	push   %eax
    3990:	68 65 5c 00 00       	push   $0x5c65
    3995:	6a 01                	push   $0x1
    3997:	e8 d9 07 00 00       	call   4175 <printf>
    399c:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    399f:	83 ec 08             	sub    $0x8,%esp
    39a2:	68 02 02 00 00       	push   $0x202
    39a7:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    39aa:	50                   	push   %eax
    39ab:	e8 89 06 00 00       	call   4039 <open>
    39b0:	83 c4 10             	add    $0x10,%esp
    39b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    39b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    39ba:	79 18                	jns    39d4 <fsfull+0x13a>
      printf(1, "open %s failed\n", name);
    39bc:	83 ec 04             	sub    $0x4,%esp
    39bf:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    39c2:	50                   	push   %eax
    39c3:	68 71 5c 00 00       	push   $0x5c71
    39c8:	6a 01                	push   $0x1
    39ca:	e8 a6 07 00 00       	call   4175 <printf>
    39cf:	83 c4 10             	add    $0x10,%esp
      break;
    39d2:	eb 6b                	jmp    3a3f <fsfull+0x1a5>
    }
    int total = 0;
    39d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    39db:	83 ec 04             	sub    $0x4,%esp
    39de:	68 00 02 00 00       	push   $0x200
    39e3:	68 a0 64 00 00       	push   $0x64a0
    39e8:	ff 75 e8             	push   -0x18(%ebp)
    39eb:	e8 29 06 00 00       	call   4019 <write>
    39f0:	83 c4 10             	add    $0x10,%esp
    39f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    39f6:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    39fd:	7e 0c                	jle    3a0b <fsfull+0x171>
        break;
      total += cc;
    39ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3a02:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    3a05:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while(1){
    3a09:	eb d0                	jmp    39db <fsfull+0x141>
        break;
    3a0b:	90                   	nop
    }
    printf(1, "wrote %d bytes\n", total);
    3a0c:	83 ec 04             	sub    $0x4,%esp
    3a0f:	ff 75 ec             	push   -0x14(%ebp)
    3a12:	68 81 5c 00 00       	push   $0x5c81
    3a17:	6a 01                	push   $0x1
    3a19:	e8 57 07 00 00       	call   4175 <printf>
    3a1e:	83 c4 10             	add    $0x10,%esp
    close(fd);
    3a21:	83 ec 0c             	sub    $0xc,%esp
    3a24:	ff 75 e8             	push   -0x18(%ebp)
    3a27:	e8 f5 05 00 00       	call   4021 <close>
    3a2c:	83 c4 10             	add    $0x10,%esp
    if(total == 0)
    3a2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3a33:	74 09                	je     3a3e <fsfull+0x1a4>
  for(nfiles = 0; ; nfiles++){
    3a35:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3a39:	e9 83 fe ff ff       	jmp    38c1 <fsfull+0x27>
      break;
    3a3e:	90                   	nop
  }

  while(nfiles >= 0){
    3a3f:	e9 db 00 00 00       	jmp    3b1f <fsfull+0x285>
    char name[64];
    name[0] = 'f';
    3a44:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3a48:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3a4b:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a50:	89 c8                	mov    %ecx,%eax
    3a52:	f7 ea                	imul   %edx
    3a54:	c1 fa 06             	sar    $0x6,%edx
    3a57:	89 c8                	mov    %ecx,%eax
    3a59:	c1 f8 1f             	sar    $0x1f,%eax
    3a5c:	29 c2                	sub    %eax,%edx
    3a5e:	89 d0                	mov    %edx,%eax
    3a60:	83 c0 30             	add    $0x30,%eax
    3a63:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3a66:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a69:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a6e:	89 d8                	mov    %ebx,%eax
    3a70:	f7 ea                	imul   %edx
    3a72:	c1 fa 06             	sar    $0x6,%edx
    3a75:	89 d8                	mov    %ebx,%eax
    3a77:	c1 f8 1f             	sar    $0x1f,%eax
    3a7a:	89 d1                	mov    %edx,%ecx
    3a7c:	29 c1                	sub    %eax,%ecx
    3a7e:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3a84:	29 c3                	sub    %eax,%ebx
    3a86:	89 d9                	mov    %ebx,%ecx
    3a88:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3a8d:	89 c8                	mov    %ecx,%eax
    3a8f:	f7 ea                	imul   %edx
    3a91:	c1 fa 05             	sar    $0x5,%edx
    3a94:	89 c8                	mov    %ecx,%eax
    3a96:	c1 f8 1f             	sar    $0x1f,%eax
    3a99:	29 c2                	sub    %eax,%edx
    3a9b:	89 d0                	mov    %edx,%eax
    3a9d:	83 c0 30             	add    $0x30,%eax
    3aa0:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3aa3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3aa6:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3aab:	89 d8                	mov    %ebx,%eax
    3aad:	f7 ea                	imul   %edx
    3aaf:	c1 fa 05             	sar    $0x5,%edx
    3ab2:	89 d8                	mov    %ebx,%eax
    3ab4:	c1 f8 1f             	sar    $0x1f,%eax
    3ab7:	89 d1                	mov    %edx,%ecx
    3ab9:	29 c1                	sub    %eax,%ecx
    3abb:	6b c1 64             	imul   $0x64,%ecx,%eax
    3abe:	29 c3                	sub    %eax,%ebx
    3ac0:	89 d9                	mov    %ebx,%ecx
    3ac2:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3ac7:	89 c8                	mov    %ecx,%eax
    3ac9:	f7 ea                	imul   %edx
    3acb:	c1 fa 02             	sar    $0x2,%edx
    3ace:	89 c8                	mov    %ecx,%eax
    3ad0:	c1 f8 1f             	sar    $0x1f,%eax
    3ad3:	29 c2                	sub    %eax,%edx
    3ad5:	89 d0                	mov    %edx,%eax
    3ad7:	83 c0 30             	add    $0x30,%eax
    3ada:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3add:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3ae0:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3ae5:	89 c8                	mov    %ecx,%eax
    3ae7:	f7 ea                	imul   %edx
    3ae9:	c1 fa 02             	sar    $0x2,%edx
    3aec:	89 c8                	mov    %ecx,%eax
    3aee:	c1 f8 1f             	sar    $0x1f,%eax
    3af1:	29 c2                	sub    %eax,%edx
    3af3:	89 d0                	mov    %edx,%eax
    3af5:	c1 e0 02             	shl    $0x2,%eax
    3af8:	01 d0                	add    %edx,%eax
    3afa:	01 c0                	add    %eax,%eax
    3afc:	29 c1                	sub    %eax,%ecx
    3afe:	89 ca                	mov    %ecx,%edx
    3b00:	89 d0                	mov    %edx,%eax
    3b02:	83 c0 30             	add    $0x30,%eax
    3b05:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3b08:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    3b0c:	83 ec 0c             	sub    $0xc,%esp
    3b0f:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3b12:	50                   	push   %eax
    3b13:	e8 31 05 00 00       	call   4049 <unlink>
    3b18:	83 c4 10             	add    $0x10,%esp
    nfiles--;
    3b1b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  while(nfiles >= 0){
    3b1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3b23:	0f 89 1b ff ff ff    	jns    3a44 <fsfull+0x1aa>
  }

  printf(1, "fsfull test finished\n");
    3b29:	83 ec 08             	sub    $0x8,%esp
    3b2c:	68 91 5c 00 00       	push   $0x5c91
    3b31:	6a 01                	push   $0x1
    3b33:	e8 3d 06 00 00       	call   4175 <printf>
    3b38:	83 c4 10             	add    $0x10,%esp
}
    3b3b:	90                   	nop
    3b3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3b3f:	c9                   	leave
    3b40:	c3                   	ret

00003b41 <uio>:

void
uio()
{
    3b41:	55                   	push   %ebp
    3b42:	89 e5                	mov    %esp,%ebp
    3b44:	83 ec 18             	sub    $0x18,%esp
  #define RTC_ADDR 0x70
  #define RTC_DATA 0x71

  ushort port = 0;
    3b47:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
  uchar val = 0;
    3b4d:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
  int pid;

  printf(1, "uio test\n");
    3b51:	83 ec 08             	sub    $0x8,%esp
    3b54:	68 a7 5c 00 00       	push   $0x5ca7
    3b59:	6a 01                	push   $0x1
    3b5b:	e8 15 06 00 00       	call   4175 <printf>
    3b60:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    3b63:	e8 89 04 00 00       	call   3ff1 <fork>
    3b68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    3b6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3b6f:	75 3a                	jne    3bab <uio+0x6a>
    port = RTC_ADDR;
    3b71:	66 c7 45 f6 70 00    	movw   $0x70,-0xa(%ebp)
    val = 0x09;  /* year */
    3b77:	c6 45 f5 09          	movb   $0x9,-0xb(%ebp)
    /* http://wiki.osdev.org/Inline_Assembly/Examples */
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    3b7b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    3b7f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
    3b83:	ee                   	out    %al,(%dx)
    port = RTC_DATA;
    3b84:	66 c7 45 f6 71 00    	movw   $0x71,-0xa(%ebp)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    3b8a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    3b8e:	89 c2                	mov    %eax,%edx
    3b90:	ec                   	in     (%dx),%al
    3b91:	88 45 f5             	mov    %al,-0xb(%ebp)
    printf(1, "uio: uio succeeded; test FAILED\n");
    3b94:	83 ec 08             	sub    $0x8,%esp
    3b97:	68 b4 5c 00 00       	push   $0x5cb4
    3b9c:	6a 01                	push   $0x1
    3b9e:	e8 d2 05 00 00       	call   4175 <printf>
    3ba3:	83 c4 10             	add    $0x10,%esp
    exit();
    3ba6:	e8 4e 04 00 00       	call   3ff9 <exit>
  } else if(pid < 0){
    3bab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3baf:	79 17                	jns    3bc8 <uio+0x87>
    printf (1, "fork failed\n");
    3bb1:	83 ec 08             	sub    $0x8,%esp
    3bb4:	68 cd 45 00 00       	push   $0x45cd
    3bb9:	6a 01                	push   $0x1
    3bbb:	e8 b5 05 00 00       	call   4175 <printf>
    3bc0:	83 c4 10             	add    $0x10,%esp
    exit();
    3bc3:	e8 31 04 00 00       	call   3ff9 <exit>
  }
  wait();
    3bc8:	e8 34 04 00 00       	call   4001 <wait>
  printf(1, "uio test done\n");
    3bcd:	83 ec 08             	sub    $0x8,%esp
    3bd0:	68 d5 5c 00 00       	push   $0x5cd5
    3bd5:	6a 01                	push   $0x1
    3bd7:	e8 99 05 00 00       	call   4175 <printf>
    3bdc:	83 c4 10             	add    $0x10,%esp
}
    3bdf:	90                   	nop
    3be0:	c9                   	leave
    3be1:	c3                   	ret

00003be2 <argptest>:

void argptest()
{
    3be2:	55                   	push   %ebp
    3be3:	89 e5                	mov    %esp,%ebp
    3be5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  fd = open("init", O_RDONLY);
    3be8:	83 ec 08             	sub    $0x8,%esp
    3beb:	6a 00                	push   $0x0
    3bed:	68 e4 5c 00 00       	push   $0x5ce4
    3bf2:	e8 42 04 00 00       	call   4039 <open>
    3bf7:	83 c4 10             	add    $0x10,%esp
    3bfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (fd < 0) {
    3bfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3c01:	79 17                	jns    3c1a <argptest+0x38>
    printf(2, "open failed\n");
    3c03:	83 ec 08             	sub    $0x8,%esp
    3c06:	68 e9 5c 00 00       	push   $0x5ce9
    3c0b:	6a 02                	push   $0x2
    3c0d:	e8 63 05 00 00       	call   4175 <printf>
    3c12:	83 c4 10             	add    $0x10,%esp
    exit();
    3c15:	e8 df 03 00 00       	call   3ff9 <exit>
  }
  read(fd, sbrk(0) - 1, -1);
    3c1a:	83 ec 0c             	sub    $0xc,%esp
    3c1d:	6a 00                	push   $0x0
    3c1f:	e8 5d 04 00 00       	call   4081 <sbrk>
    3c24:	83 c4 10             	add    $0x10,%esp
    3c27:	83 e8 01             	sub    $0x1,%eax
    3c2a:	83 ec 04             	sub    $0x4,%esp
    3c2d:	6a ff                	push   $0xffffffff
    3c2f:	50                   	push   %eax
    3c30:	ff 75 f4             	push   -0xc(%ebp)
    3c33:	e8 d9 03 00 00       	call   4011 <read>
    3c38:	83 c4 10             	add    $0x10,%esp
  close(fd);
    3c3b:	83 ec 0c             	sub    $0xc,%esp
    3c3e:	ff 75 f4             	push   -0xc(%ebp)
    3c41:	e8 db 03 00 00       	call   4021 <close>
    3c46:	83 c4 10             	add    $0x10,%esp
  printf(1, "arg test passed\n");
    3c49:	83 ec 08             	sub    $0x8,%esp
    3c4c:	68 f6 5c 00 00       	push   $0x5cf6
    3c51:	6a 01                	push   $0x1
    3c53:	e8 1d 05 00 00       	call   4175 <printf>
    3c58:	83 c4 10             	add    $0x10,%esp
}
    3c5b:	90                   	nop
    3c5c:	c9                   	leave
    3c5d:	c3                   	ret

00003c5e <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3c5e:	55                   	push   %ebp
    3c5f:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3c61:	a1 84 64 00 00       	mov    0x6484,%eax
    3c66:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    3c6c:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3c71:	a3 84 64 00 00       	mov    %eax,0x6484
  return randstate;
    3c76:	a1 84 64 00 00       	mov    0x6484,%eax
}
    3c7b:	5d                   	pop    %ebp
    3c7c:	c3                   	ret

00003c7d <main>:

int
main(int argc, char *argv[])
{
    3c7d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3c81:	83 e4 f0             	and    $0xfffffff0,%esp
    3c84:	ff 71 fc             	push   -0x4(%ecx)
    3c87:	55                   	push   %ebp
    3c88:	89 e5                	mov    %esp,%ebp
    3c8a:	51                   	push   %ecx
    3c8b:	83 ec 04             	sub    $0x4,%esp
  printf(1, "usertests starting\n");
    3c8e:	83 ec 08             	sub    $0x8,%esp
    3c91:	68 07 5d 00 00       	push   $0x5d07
    3c96:	6a 01                	push   $0x1
    3c98:	e8 d8 04 00 00       	call   4175 <printf>
    3c9d:	83 c4 10             	add    $0x10,%esp

  if(open("usertests.ran", 0) >= 0){
    3ca0:	83 ec 08             	sub    $0x8,%esp
    3ca3:	6a 00                	push   $0x0
    3ca5:	68 1b 5d 00 00       	push   $0x5d1b
    3caa:	e8 8a 03 00 00       	call   4039 <open>
    3caf:	83 c4 10             	add    $0x10,%esp
    3cb2:	85 c0                	test   %eax,%eax
    3cb4:	78 17                	js     3ccd <main+0x50>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3cb6:	83 ec 08             	sub    $0x8,%esp
    3cb9:	68 2c 5d 00 00       	push   $0x5d2c
    3cbe:	6a 01                	push   $0x1
    3cc0:	e8 b0 04 00 00       	call   4175 <printf>
    3cc5:	83 c4 10             	add    $0x10,%esp
    exit();
    3cc8:	e8 2c 03 00 00       	call   3ff9 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3ccd:	83 ec 08             	sub    $0x8,%esp
    3cd0:	68 00 02 00 00       	push   $0x200
    3cd5:	68 1b 5d 00 00       	push   $0x5d1b
    3cda:	e8 5a 03 00 00       	call   4039 <open>
    3cdf:	83 c4 10             	add    $0x10,%esp
    3ce2:	83 ec 0c             	sub    $0xc,%esp
    3ce5:	50                   	push   %eax
    3ce6:	e8 36 03 00 00       	call   4021 <close>
    3ceb:	83 c4 10             	add    $0x10,%esp

  argptest();
    3cee:	e8 ef fe ff ff       	call   3be2 <argptest>
  createdelete();
    3cf3:	e8 b5 d5 ff ff       	call   12ad <createdelete>
  linkunlink();
    3cf8:	e8 da df ff ff       	call   1cd7 <linkunlink>
  concreate();
    3cfd:	e8 21 dc ff ff       	call   1923 <concreate>
  fourfiles();
    3d02:	e8 55 d3 ff ff       	call   105c <fourfiles>
  sharedfd();
    3d07:	e8 6d d1 ff ff       	call   e79 <sharedfd>

  bigargtest();
    3d0c:	e8 4d fa ff ff       	call   375e <bigargtest>
  bigwrite();
    3d11:	e8 bd e9 ff ff       	call   26d3 <bigwrite>
  bigargtest();
    3d16:	e8 43 fa ff ff       	call   375e <bigargtest>
  bsstest();
    3d1b:	e8 c8 f9 ff ff       	call   36e8 <bsstest>
  sbrktest();
    3d20:	e8 e1 f3 ff ff       	call   3106 <sbrktest>
  validatetest();
    3d25:	e8 e0 f8 ff ff       	call   360a <validatetest>

  opentest();
    3d2a:	e8 d0 c5 ff ff       	call   2ff <opentest>
  writetest();
    3d2f:	e8 7a c6 ff ff       	call   3ae <writetest>
  writetest1();
    3d34:	e8 85 c8 ff ff       	call   5be <writetest1>
  createtest();
    3d39:	e8 7c ca ff ff       	call   7ba <createtest>

  openiputtest();
    3d3e:	e8 ad c4 ff ff       	call   1f0 <openiputtest>
  exitiputtest();
    3d43:	e8 a9 c3 ff ff       	call   f1 <exitiputtest>
  iputtest();
    3d48:	e8 b3 c2 ff ff       	call   0 <iputtest>

  mem();
    3d4d:	e8 36 d0 ff ff       	call   d88 <mem>
  pipe1();
    3d52:	e8 6a cc ff ff       	call   9c1 <pipe1>
  preempt();
    3d57:	e8 4e ce ff ff       	call   baa <preempt>
  exitwait();
    3d5c:	e8 af cf ff ff       	call   d10 <exitwait>

  rmdot();
    3d61:	e8 df ed ff ff       	call   2b45 <rmdot>
  fourteen();
    3d66:	e8 7e ec ff ff       	call   29e9 <fourteen>
  bigfile();
    3d6b:	e8 61 ea ff ff       	call   27d1 <bigfile>
  subdir();
    3d70:	e8 1a e2 ff ff       	call   1f8f <subdir>
  linktest();
    3d75:	e8 67 d9 ff ff       	call   16e1 <linktest>
  unlinkread();
    3d7a:	e8 a0 d7 ff ff       	call   151f <unlinkread>
  dirfile();
    3d7f:	e8 46 ef ff ff       	call   2cca <dirfile>
  iref();
    3d84:	e8 79 f1 ff ff       	call   2f02 <iref>
  forktest();
    3d89:	e8 ae f2 ff ff       	call   303c <forktest>
  bigdir(); // slow
    3d8e:	e8 7b e0 ff ff       	call   1e0e <bigdir>

  uio();
    3d93:	e8 a9 fd ff ff       	call   3b41 <uio>

  exectest();
    3d98:	e8 d1 cb ff ff       	call   96e <exectest>

  exit();
    3d9d:	e8 57 02 00 00       	call   3ff9 <exit>

00003da2 <stosb>:
  stosb(dst, c, n);
  return dst;
}

char*
strchr(const char *s, char c)
    3da2:	55                   	push   %ebp
    3da3:	89 e5                	mov    %esp,%ebp
    3da5:	57                   	push   %edi
    3da6:	53                   	push   %ebx
{
    3da7:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3daa:	8b 55 10             	mov    0x10(%ebp),%edx
    3dad:	8b 45 0c             	mov    0xc(%ebp),%eax
    3db0:	89 cb                	mov    %ecx,%ebx
    3db2:	89 df                	mov    %ebx,%edi
    3db4:	89 d1                	mov    %edx,%ecx
    3db6:	fc                   	cld
    3db7:	f3 aa                	rep stos %al,%es:(%edi)
    3db9:	89 ca                	mov    %ecx,%edx
    3dbb:	89 fb                	mov    %edi,%ebx
    3dbd:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3dc0:	89 55 10             	mov    %edx,0x10(%ebp)
  for(; *s; s++)
    if(*s == c)
      return (char*)s;
  return 0;
    3dc3:	90                   	nop
    3dc4:	5b                   	pop    %ebx
    3dc5:	5f                   	pop    %edi
    3dc6:	5d                   	pop    %ebp
    3dc7:	c3                   	ret

00003dc8 <strcpy>:
{
    3dc8:	55                   	push   %ebp
    3dc9:	89 e5                	mov    %esp,%ebp
    3dcb:	83 ec 10             	sub    $0x10,%esp
  os = s;
    3dce:	8b 45 08             	mov    0x8(%ebp),%eax
    3dd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3dd4:	90                   	nop
    3dd5:	8b 55 0c             	mov    0xc(%ebp),%edx
    3dd8:	8d 42 01             	lea    0x1(%edx),%eax
    3ddb:	89 45 0c             	mov    %eax,0xc(%ebp)
    3dde:	8b 45 08             	mov    0x8(%ebp),%eax
    3de1:	8d 48 01             	lea    0x1(%eax),%ecx
    3de4:	89 4d 08             	mov    %ecx,0x8(%ebp)
    3de7:	0f b6 12             	movzbl (%edx),%edx
    3dea:	88 10                	mov    %dl,(%eax)
    3dec:	0f b6 00             	movzbl (%eax),%eax
    3def:	84 c0                	test   %al,%al
    3df1:	75 e2                	jne    3dd5 <strcpy+0xd>
  return os;
    3df3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3df6:	c9                   	leave
    3df7:	c3                   	ret

00003df8 <strcmp>:
{
    3df8:	55                   	push   %ebp
    3df9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3dfb:	eb 08                	jmp    3e05 <strcmp+0xd>
    p++, q++;
    3dfd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3e01:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    3e05:	8b 45 08             	mov    0x8(%ebp),%eax
    3e08:	0f b6 00             	movzbl (%eax),%eax
    3e0b:	84 c0                	test   %al,%al
    3e0d:	74 10                	je     3e1f <strcmp+0x27>
    3e0f:	8b 45 08             	mov    0x8(%ebp),%eax
    3e12:	0f b6 10             	movzbl (%eax),%edx
    3e15:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e18:	0f b6 00             	movzbl (%eax),%eax
    3e1b:	38 c2                	cmp    %al,%dl
    3e1d:	74 de                	je     3dfd <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    3e1f:	8b 45 08             	mov    0x8(%ebp),%eax
    3e22:	0f b6 00             	movzbl (%eax),%eax
    3e25:	0f b6 d0             	movzbl %al,%edx
    3e28:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e2b:	0f b6 00             	movzbl (%eax),%eax
    3e2e:	0f b6 c0             	movzbl %al,%eax
    3e31:	29 c2                	sub    %eax,%edx
    3e33:	89 d0                	mov    %edx,%eax
}
    3e35:	5d                   	pop    %ebp
    3e36:	c3                   	ret

00003e37 <strlen>:
{
    3e37:	55                   	push   %ebp
    3e38:	89 e5                	mov    %esp,%ebp
    3e3a:	83 ec 10             	sub    $0x10,%esp
  for(n = 0; s[n]; n++)
    3e3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3e44:	eb 04                	jmp    3e4a <strlen+0x13>
    3e46:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3e4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3e4d:	8b 45 08             	mov    0x8(%ebp),%eax
    3e50:	01 d0                	add    %edx,%eax
    3e52:	0f b6 00             	movzbl (%eax),%eax
    3e55:	84 c0                	test   %al,%al
    3e57:	75 ed                	jne    3e46 <strlen+0xf>
  return n;
    3e59:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3e5c:	c9                   	leave
    3e5d:	c3                   	ret

00003e5e <memset>:
{
    3e5e:	55                   	push   %ebp
    3e5f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    3e61:	8b 45 10             	mov    0x10(%ebp),%eax
    3e64:	50                   	push   %eax
    3e65:	ff 75 0c             	push   0xc(%ebp)
    3e68:	ff 75 08             	push   0x8(%ebp)
    3e6b:	e8 32 ff ff ff       	call   3da2 <stosb>
    3e70:	83 c4 0c             	add    $0xc,%esp
  return dst;
    3e73:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3e76:	c9                   	leave
    3e77:	c3                   	ret

00003e78 <strchr>:
{
    3e78:	55                   	push   %ebp
    3e79:	89 e5                	mov    %esp,%ebp
    3e7b:	83 ec 04             	sub    $0x4,%esp
    3e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e81:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3e84:	eb 14                	jmp    3e9a <strchr+0x22>
    if(*s == c)
    3e86:	8b 45 08             	mov    0x8(%ebp),%eax
    3e89:	0f b6 00             	movzbl (%eax),%eax
    3e8c:	38 45 fc             	cmp    %al,-0x4(%ebp)
    3e8f:	75 05                	jne    3e96 <strchr+0x1e>
      return (char*)s;
    3e91:	8b 45 08             	mov    0x8(%ebp),%eax
    3e94:	eb 13                	jmp    3ea9 <strchr+0x31>
  for(; *s; s++)
    3e96:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3e9a:	8b 45 08             	mov    0x8(%ebp),%eax
    3e9d:	0f b6 00             	movzbl (%eax),%eax
    3ea0:	84 c0                	test   %al,%al
    3ea2:	75 e2                	jne    3e86 <strchr+0xe>
  return 0;
    3ea4:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3ea9:	c9                   	leave
    3eaa:	c3                   	ret

00003eab <gets>:

char*
gets(char *buf, int max)
{
    3eab:	55                   	push   %ebp
    3eac:	89 e5                	mov    %esp,%ebp
    3eae:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3eb1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3eb8:	eb 42                	jmp    3efc <gets+0x51>
    cc = read(0, &c, 1);
    3eba:	83 ec 04             	sub    $0x4,%esp
    3ebd:	6a 01                	push   $0x1
    3ebf:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3ec2:	50                   	push   %eax
    3ec3:	6a 00                	push   $0x0
    3ec5:	e8 47 01 00 00       	call   4011 <read>
    3eca:	83 c4 10             	add    $0x10,%esp
    3ecd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3ed0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3ed4:	7e 33                	jle    3f09 <gets+0x5e>
      break;
    buf[i++] = c;
    3ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ed9:	8d 50 01             	lea    0x1(%eax),%edx
    3edc:	89 55 f4             	mov    %edx,-0xc(%ebp)
    3edf:	89 c2                	mov    %eax,%edx
    3ee1:	8b 45 08             	mov    0x8(%ebp),%eax
    3ee4:	01 c2                	add    %eax,%edx
    3ee6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3eea:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    3eec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3ef0:	3c 0a                	cmp    $0xa,%al
    3ef2:	74 16                	je     3f0a <gets+0x5f>
    3ef4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3ef8:	3c 0d                	cmp    $0xd,%al
    3efa:	74 0e                	je     3f0a <gets+0x5f>
  for(i=0; i+1 < max; ){
    3efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3eff:	83 c0 01             	add    $0x1,%eax
    3f02:	39 45 0c             	cmp    %eax,0xc(%ebp)
    3f05:	7f b3                	jg     3eba <gets+0xf>
    3f07:	eb 01                	jmp    3f0a <gets+0x5f>
      break;
    3f09:	90                   	nop
      break;
  }
  buf[i] = '\0';
    3f0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3f0d:	8b 45 08             	mov    0x8(%ebp),%eax
    3f10:	01 d0                	add    %edx,%eax
    3f12:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3f15:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3f18:	c9                   	leave
    3f19:	c3                   	ret

00003f1a <stat>:

int
stat(const char *n, struct stat *st)
{
    3f1a:	55                   	push   %ebp
    3f1b:	89 e5                	mov    %esp,%ebp
    3f1d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3f20:	83 ec 08             	sub    $0x8,%esp
    3f23:	6a 00                	push   $0x0
    3f25:	ff 75 08             	push   0x8(%ebp)
    3f28:	e8 0c 01 00 00       	call   4039 <open>
    3f2d:	83 c4 10             	add    $0x10,%esp
    3f30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3f33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3f37:	79 07                	jns    3f40 <stat+0x26>
    return -1;
    3f39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3f3e:	eb 25                	jmp    3f65 <stat+0x4b>
  r = fstat(fd, st);
    3f40:	83 ec 08             	sub    $0x8,%esp
    3f43:	ff 75 0c             	push   0xc(%ebp)
    3f46:	ff 75 f4             	push   -0xc(%ebp)
    3f49:	e8 03 01 00 00       	call   4051 <fstat>
    3f4e:	83 c4 10             	add    $0x10,%esp
    3f51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3f54:	83 ec 0c             	sub    $0xc,%esp
    3f57:	ff 75 f4             	push   -0xc(%ebp)
    3f5a:	e8 c2 00 00 00       	call   4021 <close>
    3f5f:	83 c4 10             	add    $0x10,%esp
  return r;
    3f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3f65:	c9                   	leave
    3f66:	c3                   	ret

00003f67 <atoi>:

int
atoi(const char *s)
{
    3f67:	55                   	push   %ebp
    3f68:	89 e5                	mov    %esp,%ebp
    3f6a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3f6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3f74:	eb 25                	jmp    3f9b <atoi+0x34>
    n = n*10 + *s++ - '0';
    3f76:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3f79:	89 d0                	mov    %edx,%eax
    3f7b:	c1 e0 02             	shl    $0x2,%eax
    3f7e:	01 d0                	add    %edx,%eax
    3f80:	01 c0                	add    %eax,%eax
    3f82:	89 c1                	mov    %eax,%ecx
    3f84:	8b 45 08             	mov    0x8(%ebp),%eax
    3f87:	8d 50 01             	lea    0x1(%eax),%edx
    3f8a:	89 55 08             	mov    %edx,0x8(%ebp)
    3f8d:	0f b6 00             	movzbl (%eax),%eax
    3f90:	0f be c0             	movsbl %al,%eax
    3f93:	01 c8                	add    %ecx,%eax
    3f95:	83 e8 30             	sub    $0x30,%eax
    3f98:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3f9b:	8b 45 08             	mov    0x8(%ebp),%eax
    3f9e:	0f b6 00             	movzbl (%eax),%eax
    3fa1:	3c 2f                	cmp    $0x2f,%al
    3fa3:	7e 0a                	jle    3faf <atoi+0x48>
    3fa5:	8b 45 08             	mov    0x8(%ebp),%eax
    3fa8:	0f b6 00             	movzbl (%eax),%eax
    3fab:	3c 39                	cmp    $0x39,%al
    3fad:	7e c7                	jle    3f76 <atoi+0xf>
  return n;
    3faf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3fb2:	c9                   	leave
    3fb3:	c3                   	ret

00003fb4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    3fb4:	55                   	push   %ebp
    3fb5:	89 e5                	mov    %esp,%ebp
    3fb7:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
    3fba:	8b 45 08             	mov    0x8(%ebp),%eax
    3fbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fc3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3fc6:	eb 17                	jmp    3fdf <memmove+0x2b>
    *dst++ = *src++;
    3fc8:	8b 55 f8             	mov    -0x8(%ebp),%edx
    3fcb:	8d 42 01             	lea    0x1(%edx),%eax
    3fce:	89 45 f8             	mov    %eax,-0x8(%ebp)
    3fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fd4:	8d 48 01             	lea    0x1(%eax),%ecx
    3fd7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    3fda:	0f b6 12             	movzbl (%edx),%edx
    3fdd:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    3fdf:	8b 45 10             	mov    0x10(%ebp),%eax
    3fe2:	8d 50 ff             	lea    -0x1(%eax),%edx
    3fe5:	89 55 10             	mov    %edx,0x10(%ebp)
    3fe8:	85 c0                	test   %eax,%eax
    3fea:	7f dc                	jg     3fc8 <memmove+0x14>
  return vdst;
    3fec:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3fef:	c9                   	leave
    3ff0:	c3                   	ret

00003ff1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3ff1:	b8 01 00 00 00       	mov    $0x1,%eax
    3ff6:	cd 40                	int    $0x40
    3ff8:	c3                   	ret

00003ff9 <exit>:
SYSCALL(exit)
    3ff9:	b8 02 00 00 00       	mov    $0x2,%eax
    3ffe:	cd 40                	int    $0x40
    4000:	c3                   	ret

00004001 <wait>:
SYSCALL(wait)
    4001:	b8 03 00 00 00       	mov    $0x3,%eax
    4006:	cd 40                	int    $0x40
    4008:	c3                   	ret

00004009 <pipe>:
SYSCALL(pipe)
    4009:	b8 04 00 00 00       	mov    $0x4,%eax
    400e:	cd 40                	int    $0x40
    4010:	c3                   	ret

00004011 <read>:
SYSCALL(read)
    4011:	b8 05 00 00 00       	mov    $0x5,%eax
    4016:	cd 40                	int    $0x40
    4018:	c3                   	ret

00004019 <write>:
SYSCALL(write)
    4019:	b8 10 00 00 00       	mov    $0x10,%eax
    401e:	cd 40                	int    $0x40
    4020:	c3                   	ret

00004021 <close>:
SYSCALL(close)
    4021:	b8 15 00 00 00       	mov    $0x15,%eax
    4026:	cd 40                	int    $0x40
    4028:	c3                   	ret

00004029 <kill>:
SYSCALL(kill)
    4029:	b8 06 00 00 00       	mov    $0x6,%eax
    402e:	cd 40                	int    $0x40
    4030:	c3                   	ret

00004031 <exec>:
SYSCALL(exec)
    4031:	b8 07 00 00 00       	mov    $0x7,%eax
    4036:	cd 40                	int    $0x40
    4038:	c3                   	ret

00004039 <open>:
SYSCALL(open)
    4039:	b8 0f 00 00 00       	mov    $0xf,%eax
    403e:	cd 40                	int    $0x40
    4040:	c3                   	ret

00004041 <mknod>:
SYSCALL(mknod)
    4041:	b8 11 00 00 00       	mov    $0x11,%eax
    4046:	cd 40                	int    $0x40
    4048:	c3                   	ret

00004049 <unlink>:
SYSCALL(unlink)
    4049:	b8 12 00 00 00       	mov    $0x12,%eax
    404e:	cd 40                	int    $0x40
    4050:	c3                   	ret

00004051 <fstat>:
SYSCALL(fstat)
    4051:	b8 08 00 00 00       	mov    $0x8,%eax
    4056:	cd 40                	int    $0x40
    4058:	c3                   	ret

00004059 <link>:
SYSCALL(link)
    4059:	b8 13 00 00 00       	mov    $0x13,%eax
    405e:	cd 40                	int    $0x40
    4060:	c3                   	ret

00004061 <mkdir>:
SYSCALL(mkdir)
    4061:	b8 14 00 00 00       	mov    $0x14,%eax
    4066:	cd 40                	int    $0x40
    4068:	c3                   	ret

00004069 <chdir>:
SYSCALL(chdir)
    4069:	b8 09 00 00 00       	mov    $0x9,%eax
    406e:	cd 40                	int    $0x40
    4070:	c3                   	ret

00004071 <dup>:
SYSCALL(dup)
    4071:	b8 0a 00 00 00       	mov    $0xa,%eax
    4076:	cd 40                	int    $0x40
    4078:	c3                   	ret

00004079 <getpid>:
SYSCALL(getpid)
    4079:	b8 0b 00 00 00       	mov    $0xb,%eax
    407e:	cd 40                	int    $0x40
    4080:	c3                   	ret

00004081 <sbrk>:
SYSCALL(sbrk)
    4081:	b8 0c 00 00 00       	mov    $0xc,%eax
    4086:	cd 40                	int    $0x40
    4088:	c3                   	ret

00004089 <sleep>:
SYSCALL(sleep)
    4089:	b8 0d 00 00 00       	mov    $0xd,%eax
    408e:	cd 40                	int    $0x40
    4090:	c3                   	ret

00004091 <uptime>:
SYSCALL(uptime)
    4091:	b8 0e 00 00 00       	mov    $0xe,%eax
    4096:	cd 40                	int    $0x40
    4098:	c3                   	ret

00004099 <getNumFreePages>:
SYSCALL(getNumFreePages)
    4099:	b8 16 00 00 00       	mov    $0x16,%eax
    409e:	cd 40                	int    $0x40
    40a0:	c3                   	ret

000040a1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    40a1:	55                   	push   %ebp
    40a2:	89 e5                	mov    %esp,%ebp
    40a4:	83 ec 18             	sub    $0x18,%esp
    40a7:	8b 45 0c             	mov    0xc(%ebp),%eax
    40aa:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    40ad:	83 ec 04             	sub    $0x4,%esp
    40b0:	6a 01                	push   $0x1
    40b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
    40b5:	50                   	push   %eax
    40b6:	ff 75 08             	push   0x8(%ebp)
    40b9:	e8 5b ff ff ff       	call   4019 <write>
    40be:	83 c4 10             	add    $0x10,%esp
}
    40c1:	90                   	nop
    40c2:	c9                   	leave
    40c3:	c3                   	ret

000040c4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    40c4:	55                   	push   %ebp
    40c5:	89 e5                	mov    %esp,%ebp
    40c7:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    40ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    40d1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    40d5:	74 17                	je     40ee <printint+0x2a>
    40d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    40db:	79 11                	jns    40ee <printint+0x2a>
    neg = 1;
    40dd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    40e4:	8b 45 0c             	mov    0xc(%ebp),%eax
    40e7:	f7 d8                	neg    %eax
    40e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    40ec:	eb 06                	jmp    40f4 <printint+0x30>
  } else {
    x = xx;
    40ee:	8b 45 0c             	mov    0xc(%ebp),%eax
    40f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    40f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    40fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
    40fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4101:	ba 00 00 00 00       	mov    $0x0,%edx
    4106:	f7 f1                	div    %ecx
    4108:	89 d1                	mov    %edx,%ecx
    410a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    410d:	8d 50 01             	lea    0x1(%eax),%edx
    4110:	89 55 f4             	mov    %edx,-0xc(%ebp)
    4113:	0f b6 91 88 64 00 00 	movzbl 0x6488(%ecx),%edx
    411a:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
    411e:	8b 4d 10             	mov    0x10(%ebp),%ecx
    4121:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4124:	ba 00 00 00 00       	mov    $0x0,%edx
    4129:	f7 f1                	div    %ecx
    412b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    412e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4132:	75 c7                	jne    40fb <printint+0x37>
  if(neg)
    4134:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4138:	74 2d                	je     4167 <printint+0xa3>
    buf[i++] = '-';
    413a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    413d:	8d 50 01             	lea    0x1(%eax),%edx
    4140:	89 55 f4             	mov    %edx,-0xc(%ebp)
    4143:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    4148:	eb 1d                	jmp    4167 <printint+0xa3>
    putc(fd, buf[i]);
    414a:	8d 55 dc             	lea    -0x24(%ebp),%edx
    414d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4150:	01 d0                	add    %edx,%eax
    4152:	0f b6 00             	movzbl (%eax),%eax
    4155:	0f be c0             	movsbl %al,%eax
    4158:	83 ec 08             	sub    $0x8,%esp
    415b:	50                   	push   %eax
    415c:	ff 75 08             	push   0x8(%ebp)
    415f:	e8 3d ff ff ff       	call   40a1 <putc>
    4164:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
    4167:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    416b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    416f:	79 d9                	jns    414a <printint+0x86>
}
    4171:	90                   	nop
    4172:	90                   	nop
    4173:	c9                   	leave
    4174:	c3                   	ret

00004175 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    4175:	55                   	push   %ebp
    4176:	89 e5                	mov    %esp,%ebp
    4178:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    417b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    4182:	8d 45 0c             	lea    0xc(%ebp),%eax
    4185:	83 c0 04             	add    $0x4,%eax
    4188:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    418b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    4192:	e9 59 01 00 00       	jmp    42f0 <printf+0x17b>
    c = fmt[i] & 0xff;
    4197:	8b 55 0c             	mov    0xc(%ebp),%edx
    419a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    419d:	01 d0                	add    %edx,%eax
    419f:	0f b6 00             	movzbl (%eax),%eax
    41a2:	0f be c0             	movsbl %al,%eax
    41a5:	25 ff 00 00 00       	and    $0xff,%eax
    41aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    41ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    41b1:	75 2c                	jne    41df <printf+0x6a>
      if(c == '%'){
    41b3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    41b7:	75 0c                	jne    41c5 <printf+0x50>
        state = '%';
    41b9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    41c0:	e9 27 01 00 00       	jmp    42ec <printf+0x177>
      } else {
        putc(fd, c);
    41c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    41c8:	0f be c0             	movsbl %al,%eax
    41cb:	83 ec 08             	sub    $0x8,%esp
    41ce:	50                   	push   %eax
    41cf:	ff 75 08             	push   0x8(%ebp)
    41d2:	e8 ca fe ff ff       	call   40a1 <putc>
    41d7:	83 c4 10             	add    $0x10,%esp
    41da:	e9 0d 01 00 00       	jmp    42ec <printf+0x177>
      }
    } else if(state == '%'){
    41df:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    41e3:	0f 85 03 01 00 00    	jne    42ec <printf+0x177>
      if(c == 'd'){
    41e9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    41ed:	75 1e                	jne    420d <printf+0x98>
        printint(fd, *ap, 10, 1);
    41ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
    41f2:	8b 00                	mov    (%eax),%eax
    41f4:	6a 01                	push   $0x1
    41f6:	6a 0a                	push   $0xa
    41f8:	50                   	push   %eax
    41f9:	ff 75 08             	push   0x8(%ebp)
    41fc:	e8 c3 fe ff ff       	call   40c4 <printint>
    4201:	83 c4 10             	add    $0x10,%esp
        ap++;
    4204:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4208:	e9 d8 00 00 00       	jmp    42e5 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    420d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    4211:	74 06                	je     4219 <printf+0xa4>
    4213:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    4217:	75 1e                	jne    4237 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    4219:	8b 45 e8             	mov    -0x18(%ebp),%eax
    421c:	8b 00                	mov    (%eax),%eax
    421e:	6a 00                	push   $0x0
    4220:	6a 10                	push   $0x10
    4222:	50                   	push   %eax
    4223:	ff 75 08             	push   0x8(%ebp)
    4226:	e8 99 fe ff ff       	call   40c4 <printint>
    422b:	83 c4 10             	add    $0x10,%esp
        ap++;
    422e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4232:	e9 ae 00 00 00       	jmp    42e5 <printf+0x170>
      } else if(c == 's'){
    4237:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    423b:	75 43                	jne    4280 <printf+0x10b>
        s = (char*)*ap;
    423d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4240:	8b 00                	mov    (%eax),%eax
    4242:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    4245:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    4249:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    424d:	75 25                	jne    4274 <printf+0xff>
          s = "(null)";
    424f:	c7 45 f4 56 5d 00 00 	movl   $0x5d56,-0xc(%ebp)
        while(*s != 0){
    4256:	eb 1c                	jmp    4274 <printf+0xff>
          putc(fd, *s);
    4258:	8b 45 f4             	mov    -0xc(%ebp),%eax
    425b:	0f b6 00             	movzbl (%eax),%eax
    425e:	0f be c0             	movsbl %al,%eax
    4261:	83 ec 08             	sub    $0x8,%esp
    4264:	50                   	push   %eax
    4265:	ff 75 08             	push   0x8(%ebp)
    4268:	e8 34 fe ff ff       	call   40a1 <putc>
    426d:	83 c4 10             	add    $0x10,%esp
          s++;
    4270:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    4274:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4277:	0f b6 00             	movzbl (%eax),%eax
    427a:	84 c0                	test   %al,%al
    427c:	75 da                	jne    4258 <printf+0xe3>
    427e:	eb 65                	jmp    42e5 <printf+0x170>
        }
      } else if(c == 'c'){
    4280:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    4284:	75 1d                	jne    42a3 <printf+0x12e>
        putc(fd, *ap);
    4286:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4289:	8b 00                	mov    (%eax),%eax
    428b:	0f be c0             	movsbl %al,%eax
    428e:	83 ec 08             	sub    $0x8,%esp
    4291:	50                   	push   %eax
    4292:	ff 75 08             	push   0x8(%ebp)
    4295:	e8 07 fe ff ff       	call   40a1 <putc>
    429a:	83 c4 10             	add    $0x10,%esp
        ap++;
    429d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    42a1:	eb 42                	jmp    42e5 <printf+0x170>
      } else if(c == '%'){
    42a3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    42a7:	75 17                	jne    42c0 <printf+0x14b>
        putc(fd, c);
    42a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    42ac:	0f be c0             	movsbl %al,%eax
    42af:	83 ec 08             	sub    $0x8,%esp
    42b2:	50                   	push   %eax
    42b3:	ff 75 08             	push   0x8(%ebp)
    42b6:	e8 e6 fd ff ff       	call   40a1 <putc>
    42bb:	83 c4 10             	add    $0x10,%esp
    42be:	eb 25                	jmp    42e5 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    42c0:	83 ec 08             	sub    $0x8,%esp
    42c3:	6a 25                	push   $0x25
    42c5:	ff 75 08             	push   0x8(%ebp)
    42c8:	e8 d4 fd ff ff       	call   40a1 <putc>
    42cd:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    42d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    42d3:	0f be c0             	movsbl %al,%eax
    42d6:	83 ec 08             	sub    $0x8,%esp
    42d9:	50                   	push   %eax
    42da:	ff 75 08             	push   0x8(%ebp)
    42dd:	e8 bf fd ff ff       	call   40a1 <putc>
    42e2:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    42e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    42ec:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    42f0:	8b 55 0c             	mov    0xc(%ebp),%edx
    42f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    42f6:	01 d0                	add    %edx,%eax
    42f8:	0f b6 00             	movzbl (%eax),%eax
    42fb:	84 c0                	test   %al,%al
    42fd:	0f 85 94 fe ff ff    	jne    4197 <printf+0x22>
    }
  }
}
    4303:	90                   	nop
    4304:	90                   	nop
    4305:	c9                   	leave
    4306:	c3                   	ret

00004307 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4307:	55                   	push   %ebp
    4308:	89 e5                	mov    %esp,%ebp
    430a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    430d:	8b 45 08             	mov    0x8(%ebp),%eax
    4310:	83 e8 08             	sub    $0x8,%eax
    4313:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4316:	a1 68 ac 00 00       	mov    0xac68,%eax
    431b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    431e:	eb 24                	jmp    4344 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4320:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4323:	8b 00                	mov    (%eax),%eax
    4325:	39 45 fc             	cmp    %eax,-0x4(%ebp)
    4328:	72 12                	jb     433c <free+0x35>
    432a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    432d:	39 45 fc             	cmp    %eax,-0x4(%ebp)
    4330:	72 24                	jb     4356 <free+0x4f>
    4332:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4335:	8b 00                	mov    (%eax),%eax
    4337:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    433a:	72 1a                	jb     4356 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    433c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    433f:	8b 00                	mov    (%eax),%eax
    4341:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4344:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4347:	39 45 fc             	cmp    %eax,-0x4(%ebp)
    434a:	73 d4                	jae    4320 <free+0x19>
    434c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    434f:	8b 00                	mov    (%eax),%eax
    4351:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    4354:	73 ca                	jae    4320 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    4356:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4359:	8b 40 04             	mov    0x4(%eax),%eax
    435c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4363:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4366:	01 c2                	add    %eax,%edx
    4368:	8b 45 fc             	mov    -0x4(%ebp),%eax
    436b:	8b 00                	mov    (%eax),%eax
    436d:	39 c2                	cmp    %eax,%edx
    436f:	75 24                	jne    4395 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    4371:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4374:	8b 50 04             	mov    0x4(%eax),%edx
    4377:	8b 45 fc             	mov    -0x4(%ebp),%eax
    437a:	8b 00                	mov    (%eax),%eax
    437c:	8b 40 04             	mov    0x4(%eax),%eax
    437f:	01 c2                	add    %eax,%edx
    4381:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4384:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    4387:	8b 45 fc             	mov    -0x4(%ebp),%eax
    438a:	8b 00                	mov    (%eax),%eax
    438c:	8b 10                	mov    (%eax),%edx
    438e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4391:	89 10                	mov    %edx,(%eax)
    4393:	eb 0a                	jmp    439f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    4395:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4398:	8b 10                	mov    (%eax),%edx
    439a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    439d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    439f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43a2:	8b 40 04             	mov    0x4(%eax),%eax
    43a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    43ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43af:	01 d0                	add    %edx,%eax
    43b1:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    43b4:	75 20                	jne    43d6 <free+0xcf>
    p->s.size += bp->s.size;
    43b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43b9:	8b 50 04             	mov    0x4(%eax),%edx
    43bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43bf:	8b 40 04             	mov    0x4(%eax),%eax
    43c2:	01 c2                	add    %eax,%edx
    43c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43c7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    43ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
    43cd:	8b 10                	mov    (%eax),%edx
    43cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43d2:	89 10                	mov    %edx,(%eax)
    43d4:	eb 08                	jmp    43de <free+0xd7>
  } else
    p->s.ptr = bp;
    43d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
    43dc:	89 10                	mov    %edx,(%eax)
  freep = p;
    43de:	8b 45 fc             	mov    -0x4(%ebp),%eax
    43e1:	a3 68 ac 00 00       	mov    %eax,0xac68
}
    43e6:	90                   	nop
    43e7:	c9                   	leave
    43e8:	c3                   	ret

000043e9 <morecore>:

static Header*
morecore(uint nu)
{
    43e9:	55                   	push   %ebp
    43ea:	89 e5                	mov    %esp,%ebp
    43ec:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    43ef:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    43f6:	77 07                	ja     43ff <morecore+0x16>
    nu = 4096;
    43f8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    43ff:	8b 45 08             	mov    0x8(%ebp),%eax
    4402:	c1 e0 03             	shl    $0x3,%eax
    4405:	83 ec 0c             	sub    $0xc,%esp
    4408:	50                   	push   %eax
    4409:	e8 73 fc ff ff       	call   4081 <sbrk>
    440e:	83 c4 10             	add    $0x10,%esp
    4411:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    4414:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    4418:	75 07                	jne    4421 <morecore+0x38>
    return 0;
    441a:	b8 00 00 00 00       	mov    $0x0,%eax
    441f:	eb 26                	jmp    4447 <morecore+0x5e>
  hp = (Header*)p;
    4421:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4424:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    4427:	8b 45 f0             	mov    -0x10(%ebp),%eax
    442a:	8b 55 08             	mov    0x8(%ebp),%edx
    442d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    4430:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4433:	83 c0 08             	add    $0x8,%eax
    4436:	83 ec 0c             	sub    $0xc,%esp
    4439:	50                   	push   %eax
    443a:	e8 c8 fe ff ff       	call   4307 <free>
    443f:	83 c4 10             	add    $0x10,%esp
  return freep;
    4442:	a1 68 ac 00 00       	mov    0xac68,%eax
}
    4447:	c9                   	leave
    4448:	c3                   	ret

00004449 <malloc>:

void*
malloc(uint nbytes)
{
    4449:	55                   	push   %ebp
    444a:	89 e5                	mov    %esp,%ebp
    444c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    444f:	8b 45 08             	mov    0x8(%ebp),%eax
    4452:	83 c0 07             	add    $0x7,%eax
    4455:	c1 e8 03             	shr    $0x3,%eax
    4458:	83 c0 01             	add    $0x1,%eax
    445b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    445e:	a1 68 ac 00 00       	mov    0xac68,%eax
    4463:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4466:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    446a:	75 23                	jne    448f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    446c:	c7 45 f0 60 ac 00 00 	movl   $0xac60,-0x10(%ebp)
    4473:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4476:	a3 68 ac 00 00       	mov    %eax,0xac68
    447b:	a1 68 ac 00 00       	mov    0xac68,%eax
    4480:	a3 60 ac 00 00       	mov    %eax,0xac60
    base.s.size = 0;
    4485:	c7 05 64 ac 00 00 00 	movl   $0x0,0xac64
    448c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    448f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4492:	8b 00                	mov    (%eax),%eax
    4494:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    4497:	8b 45 f4             	mov    -0xc(%ebp),%eax
    449a:	8b 40 04             	mov    0x4(%eax),%eax
    449d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    44a0:	72 4d                	jb     44ef <malloc+0xa6>
      if(p->s.size == nunits)
    44a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44a5:	8b 40 04             	mov    0x4(%eax),%eax
    44a8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    44ab:	75 0c                	jne    44b9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    44ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44b0:	8b 10                	mov    (%eax),%edx
    44b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    44b5:	89 10                	mov    %edx,(%eax)
    44b7:	eb 26                	jmp    44df <malloc+0x96>
      else {
        p->s.size -= nunits;
    44b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44bc:	8b 40 04             	mov    0x4(%eax),%eax
    44bf:	2b 45 ec             	sub    -0x14(%ebp),%eax
    44c2:	89 c2                	mov    %eax,%edx
    44c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44c7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    44ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44cd:	8b 40 04             	mov    0x4(%eax),%eax
    44d0:	c1 e0 03             	shl    $0x3,%eax
    44d3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    44d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
    44dc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    44df:	8b 45 f0             	mov    -0x10(%ebp),%eax
    44e2:	a3 68 ac 00 00       	mov    %eax,0xac68
      return (void*)(p + 1);
    44e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    44ea:	83 c0 08             	add    $0x8,%eax
    44ed:	eb 3b                	jmp    452a <malloc+0xe1>
    }
    if(p == freep)
    44ef:	a1 68 ac 00 00       	mov    0xac68,%eax
    44f4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    44f7:	75 1e                	jne    4517 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    44f9:	83 ec 0c             	sub    $0xc,%esp
    44fc:	ff 75 ec             	push   -0x14(%ebp)
    44ff:	e8 e5 fe ff ff       	call   43e9 <morecore>
    4504:	83 c4 10             	add    $0x10,%esp
    4507:	89 45 f4             	mov    %eax,-0xc(%ebp)
    450a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    450e:	75 07                	jne    4517 <malloc+0xce>
        return 0;
    4510:	b8 00 00 00 00       	mov    $0x0,%eax
    4515:	eb 13                	jmp    452a <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4517:	8b 45 f4             	mov    -0xc(%ebp),%eax
    451a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    451d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4520:	8b 00                	mov    (%eax),%eax
    4522:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    4525:	e9 6d ff ff ff       	jmp    4497 <malloc+0x4e>
  }
}
    452a:	c9                   	leave
    452b:	c3                   	ret
