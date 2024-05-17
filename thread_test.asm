
_thread_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    }
  }
}

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 0c             	sub    $0xc,%esp
  int i;
  for (i = 0; i < NUM_THREAD; i++)
    expected[i] = i;
  11:	c7 05 fc 11 00 00 00 	movl   $0x0,0x11fc
  18:	00 00 00 

  printf(1, "Test 1: Basic test\n");
  1b:	68 94 0c 00 00       	push   $0xc94
  20:	6a 01                	push   $0x1
    expected[i] = i;
  22:	c7 05 00 12 00 00 01 	movl   $0x1,0x1200
  29:	00 00 00 
  2c:	c7 05 04 12 00 00 02 	movl   $0x2,0x1204
  33:	00 00 00 
  36:	c7 05 08 12 00 00 03 	movl   $0x3,0x1208
  3d:	00 00 00 
  40:	c7 05 0c 12 00 00 04 	movl   $0x4,0x120c
  47:	00 00 00 
  printf(1, "Test 1: Basic test\n");
  4a:	e8 41 08 00 00       	call   890 <printf>
  create_all(2, thread_basic);
  4f:	58                   	pop    %eax
  50:	5a                   	pop    %edx
  51:	68 70 01 00 00       	push   $0x170
  56:	6a 02                	push   $0x2
  58:	e8 93 03 00 00       	call   3f0 <create_all>
  sleep(100);
  5d:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  64:	e8 4a 07 00 00       	call   7b3 <sleep>
  printf(1, "Parent waiting for children...\n");
  69:	59                   	pop    %ecx
  6a:	58                   	pop    %eax
  6b:	68 58 0d 00 00       	push   $0xd58
  70:	6a 01                	push   $0x1
  72:	e8 19 08 00 00       	call   890 <printf>
  join_all(2);
  77:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  7e:	e8 cd 03 00 00       	call   450 <join_all>
  if (status != 1) {
  83:	83 c4 10             	add    $0x10,%esp
  86:	83 3d 24 12 00 00 01 	cmpl   $0x1,0x1224
  8d:	74 13                	je     a2 <main+0xa2>
    printf(1, "Join returned before thread exit, or the address space is not properly shared\n");
  8f:	50                   	push   %eax
  90:	50                   	push   %eax
  91:	68 78 0d 00 00       	push   $0xd78
  96:	6a 01                	push   $0x1
  98:	e8 f3 07 00 00       	call   890 <printf>
    failed();
  9d:	e8 2e 01 00 00       	call   1d0 <failed>
  }
  printf(1, "Test 1 passed\n\n");
  a2:	50                   	push   %eax
  a3:	50                   	push   %eax
  a4:	68 a8 0c 00 00       	push   $0xca8
  a9:	6a 01                	push   $0x1
  ab:	e8 e0 07 00 00       	call   890 <printf>
  
  printf(1, "Test 2: Fork test\n");
  b0:	58                   	pop    %eax
  b1:	5a                   	pop    %edx
  b2:	68 b8 0c 00 00       	push   $0xcb8
  b7:	6a 01                	push   $0x1
  b9:	e8 d2 07 00 00       	call   890 <printf>
  create_all(NUM_THREAD, thread_fork);
  be:	59                   	pop    %ecx
  bf:	58                   	pop    %eax
  c0:	68 f0 01 00 00       	push   $0x1f0
  c5:	6a 05                	push   $0x5
  c7:	e8 24 03 00 00       	call   3f0 <create_all>
  join_all(NUM_THREAD);
  cc:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  d3:	e8 78 03 00 00       	call   450 <join_all>
  if (status != 2) {
  d8:	a1 24 12 00 00       	mov    0x1224,%eax
  dd:	83 c4 10             	add    $0x10,%esp
  e0:	83 f8 02             	cmp    $0x2,%eax
  e3:	74 2e                	je     113 <main+0x113>
    if (status == 3) {
  e5:	83 f8 03             	cmp    $0x3,%eax
  e8:	74 16                	je     100 <main+0x100>
      printf(1, "Child process referenced parent's memory\n");
    }
    else {
      printf(1, "Status expected 2, found %d\n", status);
  ea:	51                   	push   %ecx
  eb:	50                   	push   %eax
  ec:	68 cb 0c 00 00       	push   $0xccb
  f1:	6a 01                	push   $0x1
  f3:	e8 98 07 00 00       	call   890 <printf>
  f8:	83 c4 10             	add    $0x10,%esp
    }
    failed();
  fb:	e8 d0 00 00 00       	call   1d0 <failed>
      printf(1, "Child process referenced parent's memory\n");
 100:	50                   	push   %eax
 101:	50                   	push   %eax
 102:	68 c8 0d 00 00       	push   $0xdc8
 107:	6a 01                	push   $0x1
 109:	e8 82 07 00 00       	call   890 <printf>
 10e:	83 c4 10             	add    $0x10,%esp
 111:	eb e8                	jmp    fb <main+0xfb>
  }
  printf(1, "Test 2 passed\n\n");
 113:	50                   	push   %eax
 114:	50                   	push   %eax
 115:	68 e8 0c 00 00       	push   $0xce8
 11a:	6a 01                	push   $0x1
 11c:	e8 6f 07 00 00       	call   890 <printf>

  printf(1, "Test 3: Sbrk test\n");
 121:	5a                   	pop    %edx
 122:	59                   	pop    %ecx
 123:	68 f8 0c 00 00       	push   $0xcf8
 128:	6a 01                	push   $0x1
 12a:	e8 61 07 00 00       	call   890 <printf>
  create_all(NUM_THREAD, thread_sbrk);
 12f:	58                   	pop    %eax
 130:	5a                   	pop    %edx
 131:	68 b0 02 00 00       	push   $0x2b0
 136:	6a 05                	push   $0x5
 138:	e8 b3 02 00 00       	call   3f0 <create_all>
  join_all(NUM_THREAD);
 13d:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 144:	e8 07 03 00 00       	call   450 <join_all>
  printf(1, "Test 3 passed\n\n");
 149:	59                   	pop    %ecx
 14a:	58                   	pop    %eax
 14b:	68 0b 0d 00 00       	push   $0xd0b
 150:	6a 01                	push   $0x1
 152:	e8 39 07 00 00       	call   890 <printf>

  printf(1, "All tests passed!\n");
 157:	58                   	pop    %eax
 158:	5a                   	pop    %edx
 159:	68 1b 0d 00 00       	push   $0xd1b
 15e:	6a 01                	push   $0x1
 160:	e8 2b 07 00 00       	call   890 <printf>
  exit();
 165:	e8 b9 05 00 00       	call   723 <exit>
 16a:	66 90                	xchg   %ax,%ax
 16c:	66 90                	xchg   %ax,%ax
 16e:	66 90                	xchg   %ax,%ax

00000170 <thread_basic>:
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	53                   	push   %ebx
 174:	83 ec 08             	sub    $0x8,%esp
 177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(1, "Thread %d start\n", val);
 17a:	53                   	push   %ebx
 17b:	68 b8 0b 00 00       	push   $0xbb8
 180:	6a 01                	push   $0x1
 182:	e8 09 07 00 00       	call   890 <printf>
  if (val == 1) {
 187:	83 c4 10             	add    $0x10,%esp
 18a:	83 fb 01             	cmp    $0x1,%ebx
 18d:	74 21                	je     1b0 <thread_basic+0x40>
  printf(1, "Thread %d end\n", val);
 18f:	83 ec 04             	sub    $0x4,%esp
 192:	53                   	push   %ebx
 193:	68 c9 0b 00 00       	push   $0xbc9
 198:	6a 01                	push   $0x1
 19a:	e8 f1 06 00 00       	call   890 <printf>
  thread_exit(arg);
 19f:	89 1c 24             	mov    %ebx,(%esp)
 1a2:	e8 24 06 00 00       	call   7cb <thread_exit>
}
 1a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1aa:	31 c0                	xor    %eax,%eax
 1ac:	c9                   	leave  
 1ad:	c3                   	ret    
 1ae:	66 90                	xchg   %ax,%ax
    sleep(200);
 1b0:	83 ec 0c             	sub    $0xc,%esp
 1b3:	68 c8 00 00 00       	push   $0xc8
 1b8:	e8 f6 05 00 00       	call   7b3 <sleep>
    status = 1;
 1bd:	83 c4 10             	add    $0x10,%esp
 1c0:	c7 05 24 12 00 00 01 	movl   $0x1,0x1224
 1c7:	00 00 00 
 1ca:	eb c3                	jmp    18f <thread_basic+0x1f>
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001d0 <failed>:
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 10             	sub    $0x10,%esp
  printf(1, "Test failed!\n");
 1d6:	68 d8 0b 00 00       	push   $0xbd8
 1db:	6a 01                	push   $0x1
 1dd:	e8 ae 06 00 00       	call   890 <printf>
  exit();
 1e2:	e8 3c 05 00 00       	call   723 <exit>
 1e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ee:	66 90                	xchg   %ax,%ax

000001f0 <thread_fork>:
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	53                   	push   %ebx
 1f4:	83 ec 08             	sub    $0x8,%esp
 1f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(1, "Thread %d start\n", val);
 1fa:	53                   	push   %ebx
 1fb:	68 b8 0b 00 00       	push   $0xbb8
 200:	6a 01                	push   $0x1
 202:	e8 89 06 00 00       	call   890 <printf>
  pid = fork();
 207:	e8 0f 05 00 00       	call   71b <fork>
  if (pid < 0) {
 20c:	83 c4 10             	add    $0x10,%esp
 20f:	85 c0                	test   %eax,%eax
 211:	78 35                	js     248 <thread_fork+0x58>
  if (pid == 0) {
 213:	74 59                	je     26e <thread_fork+0x7e>
    status = 2;
 215:	c7 05 24 12 00 00 02 	movl   $0x2,0x1224
 21c:	00 00 00 
    if (wait() == -1) {
 21f:	e8 07 05 00 00       	call   72b <wait>
 224:	83 f8 ff             	cmp    $0xffffffff,%eax
 227:	74 32                	je     25b <thread_fork+0x6b>
  printf(1, "Thread %d end\n", val);
 229:	83 ec 04             	sub    $0x4,%esp
 22c:	53                   	push   %ebx
 22d:	68 c9 0b 00 00       	push   $0xbc9
 232:	6a 01                	push   $0x1
 234:	e8 57 06 00 00       	call   890 <printf>
  thread_exit(arg);
 239:	89 1c 24             	mov    %ebx,(%esp)
 23c:	e8 8a 05 00 00       	call   7cb <thread_exit>
}
 241:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 244:	31 c0                	xor    %eax,%eax
 246:	c9                   	leave  
 247:	c3                   	ret    
    printf(1, "Fork error on thread %d\n", val);
 248:	51                   	push   %ecx
 249:	53                   	push   %ebx
 24a:	68 e6 0b 00 00       	push   $0xbe6
 24f:	6a 01                	push   $0x1
 251:	e8 3a 06 00 00       	call   890 <printf>
    failed();
 256:	e8 75 ff ff ff       	call   1d0 <failed>
      printf(1, "Thread %d lost their child\n", val);
 25b:	50                   	push   %eax
 25c:	53                   	push   %ebx
 25d:	68 31 0c 00 00       	push   $0xc31
 262:	6a 01                	push   $0x1
 264:	e8 27 06 00 00       	call   890 <printf>
      failed();
 269:	e8 62 ff ff ff       	call   1d0 <failed>
    printf(1, "Child of thread %d start\n", val);
 26e:	52                   	push   %edx
 26f:	53                   	push   %ebx
 270:	68 ff 0b 00 00       	push   $0xbff
 275:	6a 01                	push   $0x1
 277:	e8 14 06 00 00       	call   890 <printf>
    sleep(100);
 27c:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 283:	e8 2b 05 00 00       	call   7b3 <sleep>
    printf(1, "Child of thread %d end\n", val);
 288:	83 c4 0c             	add    $0xc,%esp
    status = 3;
 28b:	c7 05 24 12 00 00 03 	movl   $0x3,0x1224
 292:	00 00 00 
    printf(1, "Child of thread %d end\n", val);
 295:	53                   	push   %ebx
 296:	68 19 0c 00 00       	push   $0xc19
 29b:	6a 01                	push   $0x1
 29d:	e8 ee 05 00 00       	call   890 <printf>
    exit();
 2a2:	e8 7c 04 00 00       	call   723 <exit>
 2a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ae:	66 90                	xchg   %ax,%ax

000002b0 <thread_sbrk>:
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	56                   	push   %esi
 2b5:	53                   	push   %ebx
 2b6:	83 ec 10             	sub    $0x10,%esp
 2b9:	8b 75 08             	mov    0x8(%ebp),%esi
  printf(1, "Thread %d start\n", val);
 2bc:	56                   	push   %esi
 2bd:	68 b8 0b 00 00       	push   $0xbb8
 2c2:	6a 01                	push   $0x1
 2c4:	e8 c7 05 00 00       	call   890 <printf>
  if (val == 0) {
 2c9:	83 c4 10             	add    $0x10,%esp
 2cc:	85 f6                	test   %esi,%esi
 2ce:	0f 84 d8 00 00 00    	je     3ac <thread_sbrk+0xfc>
    while (ptr == 0)
 2d4:	8b 15 f8 11 00 00    	mov    0x11f8,%edx
 2da:	85 d2                	test   %edx,%edx
 2dc:	75 17                	jne    2f5 <thread_sbrk+0x45>
      sleep(1);
 2de:	83 ec 0c             	sub    $0xc,%esp
 2e1:	6a 01                	push   $0x1
 2e3:	e8 cb 04 00 00       	call   7b3 <sleep>
    while (ptr == 0)
 2e8:	8b 15 f8 11 00 00    	mov    0x11f8,%edx
 2ee:	83 c4 10             	add    $0x10,%esp
 2f1:	85 d2                	test   %edx,%edx
 2f3:	74 e9                	je     2de <thread_sbrk+0x2e>
{
 2f5:	31 c0                	xor    %eax,%eax
 2f7:	eb 0d                	jmp    306 <thread_sbrk+0x56>
 2f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while (ptr != 0)
 300:	8b 15 f8 11 00 00    	mov    0x11f8,%edx
      ptr[i] = val;
 306:	89 34 02             	mov    %esi,(%edx,%eax,1)
    for (i = 0; i < 16384; i++)
 309:	83 c0 04             	add    $0x4,%eax
 30c:	3d 00 00 01 00       	cmp    $0x10000,%eax
 311:	75 ed                	jne    300 <thread_sbrk+0x50>
  while (ptr != 0)
 313:	a1 f8 11 00 00       	mov    0x11f8,%eax
 318:	85 c0                	test   %eax,%eax
 31a:	74 16                	je     332 <thread_sbrk+0x82>
    sleep(1);
 31c:	83 ec 0c             	sub    $0xc,%esp
 31f:	6a 01                	push   $0x1
 321:	e8 8d 04 00 00       	call   7b3 <sleep>
  while (ptr != 0)
 326:	a1 f8 11 00 00       	mov    0x11f8,%eax
 32b:	83 c4 10             	add    $0x10,%esp
 32e:	85 c0                	test   %eax,%eax
 330:	75 ea                	jne    31c <thread_sbrk+0x6c>
{
 332:	bb d0 07 00 00       	mov    $0x7d0,%ebx
    int *p = (int *)malloc(65536);
 337:	83 ec 0c             	sub    $0xc,%esp
 33a:	68 00 00 01 00       	push   $0x10000
 33f:	e8 7c 07 00 00       	call   ac0 <malloc>
 344:	83 c4 10             	add    $0x10,%esp
 347:	89 c7                	mov    %eax,%edi
    for (j = 0; j < 16384; j++)
 349:	89 c2                	mov    %eax,%edx
 34b:	8d 88 00 00 01 00    	lea    0x10000(%eax),%ecx
 351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      p[j] = val;
 358:	89 30                	mov    %esi,(%eax)
    for (j = 0; j < 16384; j++)
 35a:	83 c0 04             	add    $0x4,%eax
 35d:	39 c8                	cmp    %ecx,%eax
 35f:	75 f7                	jne    358 <thread_sbrk+0xa8>
 361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if (p[j] != val) {
 368:	8b 02                	mov    (%edx),%eax
 36a:	39 f0                	cmp    %esi,%eax
 36c:	75 2b                	jne    399 <thread_sbrk+0xe9>
    for (j = 0; j < 16384; j++) {
 36e:	83 c2 04             	add    $0x4,%edx
 371:	39 ca                	cmp    %ecx,%edx
 373:	75 f3                	jne    368 <thread_sbrk+0xb8>
    free(p);
 375:	83 ec 0c             	sub    $0xc,%esp
 378:	57                   	push   %edi
 379:	e8 b2 06 00 00       	call   a30 <free>
  for (i = 0; i < 2000; i++) {
 37e:	83 c4 10             	add    $0x10,%esp
 381:	83 eb 01             	sub    $0x1,%ebx
 384:	75 b1                	jne    337 <thread_sbrk+0x87>
  thread_exit(arg);
 386:	83 ec 0c             	sub    $0xc,%esp
 389:	56                   	push   %esi
 38a:	e8 3c 04 00 00       	call   7cb <thread_exit>
}
 38f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 392:	31 c0                	xor    %eax,%eax
 394:	5b                   	pop    %ebx
 395:	5e                   	pop    %esi
 396:	5f                   	pop    %edi
 397:	5d                   	pop    %ebp
 398:	c3                   	ret    
        printf(1, "Thread %d found %d\n", val, p[j]);
 399:	50                   	push   %eax
 39a:	56                   	push   %esi
 39b:	68 4d 0c 00 00       	push   $0xc4d
 3a0:	6a 01                	push   $0x1
 3a2:	e8 e9 04 00 00       	call   890 <printf>
        failed();
 3a7:	e8 24 fe ff ff       	call   1d0 <failed>
    ptr = (int *)malloc(65536);
 3ac:	83 ec 0c             	sub    $0xc,%esp
 3af:	68 00 00 01 00       	push   $0x10000
 3b4:	e8 07 07 00 00       	call   ac0 <malloc>
    sleep(100);
 3b9:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
    ptr = (int *)malloc(65536);
 3c0:	a3 f8 11 00 00       	mov    %eax,0x11f8
    sleep(100);
 3c5:	e8 e9 03 00 00       	call   7b3 <sleep>
    free(ptr);
 3ca:	5a                   	pop    %edx
 3cb:	ff 35 f8 11 00 00    	push   0x11f8
 3d1:	e8 5a 06 00 00       	call   a30 <free>
    ptr = 0;
 3d6:	83 c4 10             	add    $0x10,%esp
 3d9:	c7 05 f8 11 00 00 00 	movl   $0x0,0x11f8
 3e0:	00 00 00 
  while (ptr != 0)
 3e3:	e9 4a ff ff ff       	jmp    332 <thread_sbrk+0x82>
 3e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ef:	90                   	nop

000003f0 <create_all>:
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
 3f6:	83 ec 0c             	sub    $0xc,%esp
 3f9:	8b 75 08             	mov    0x8(%ebp),%esi
 3fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for (i = 0; i < n; i++) {
 3ff:	85 f6                	test   %esi,%esi
 401:	7e 25                	jle    428 <create_all+0x38>
 403:	31 db                	xor    %ebx,%ebx
 405:	8d 76 00             	lea    0x0(%esi),%esi
    if (thread_create(&thread[i], entry, (void *)i) != 0) {
 408:	83 ec 04             	sub    $0x4,%esp
 40b:	8d 04 9d 10 12 00 00 	lea    0x1210(,%ebx,4),%eax
 412:	53                   	push   %ebx
 413:	57                   	push   %edi
 414:	50                   	push   %eax
 415:	e8 a9 03 00 00       	call   7c3 <thread_create>
 41a:	83 c4 10             	add    $0x10,%esp
 41d:	85 c0                	test   %eax,%eax
 41f:	75 0f                	jne    430 <create_all+0x40>
  for (i = 0; i < n; i++) {
 421:	83 c3 01             	add    $0x1,%ebx
 424:	39 de                	cmp    %ebx,%esi
 426:	75 e0                	jne    408 <create_all+0x18>
}
 428:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42b:	5b                   	pop    %ebx
 42c:	5e                   	pop    %esi
 42d:	5f                   	pop    %edi
 42e:	5d                   	pop    %ebp
 42f:	c3                   	ret    
      printf(1, "Error creating thread %d\n", i);
 430:	83 ec 04             	sub    $0x4,%esp
 433:	53                   	push   %ebx
 434:	68 61 0c 00 00       	push   $0xc61
 439:	6a 01                	push   $0x1
 43b:	e8 50 04 00 00       	call   890 <printf>
      failed();
 440:	e8 8b fd ff ff       	call   1d0 <failed>
 445:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000450 <join_all>:
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
 456:	83 ec 1c             	sub    $0x1c,%esp
 459:	8b 75 08             	mov    0x8(%ebp),%esi
  for (i = 0; i < n; i++) {
 45c:	85 f6                	test   %esi,%esi
 45e:	7e 34                	jle    494 <join_all+0x44>
 460:	31 db                	xor    %ebx,%ebx
 462:	8d 7d e4             	lea    -0x1c(%ebp),%edi
 465:	8d 76 00             	lea    0x0(%esi),%esi
    if (thread_join(thread[i], (void **)&retval) != 0) {
 468:	83 ec 08             	sub    $0x8,%esp
 46b:	57                   	push   %edi
 46c:	ff 34 9d 10 12 00 00 	push   0x1210(,%ebx,4)
 473:	e8 5b 03 00 00       	call   7d3 <thread_join>
 478:	83 c4 10             	add    $0x10,%esp
 47b:	85 c0                	test   %eax,%eax
 47d:	75 1d                	jne    49c <join_all+0x4c>
    if (retval != expected[i]) {
 47f:	8b 14 9d fc 11 00 00 	mov    0x11fc(,%ebx,4),%edx
 486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 489:	39 c2                	cmp    %eax,%edx
 48b:	75 24                	jne    4b1 <join_all+0x61>
  for (i = 0; i < n; i++) {
 48d:	83 c3 01             	add    $0x1,%ebx
 490:	39 de                	cmp    %ebx,%esi
 492:	75 d4                	jne    468 <join_all+0x18>
}
 494:	8d 65 f4             	lea    -0xc(%ebp),%esp
 497:	5b                   	pop    %ebx
 498:	5e                   	pop    %esi
 499:	5f                   	pop    %edi
 49a:	5d                   	pop    %ebp
 49b:	c3                   	ret    
      printf(1, "Error joining thread %d\n", i);
 49c:	83 ec 04             	sub    $0x4,%esp
 49f:	53                   	push   %ebx
 4a0:	68 7b 0c 00 00       	push   $0xc7b
 4a5:	6a 01                	push   $0x1
 4a7:	e8 e4 03 00 00       	call   890 <printf>
      failed();
 4ac:	e8 1f fd ff ff       	call   1d0 <failed>
      printf(1, "Thread %d returned %d, but expected %d\n", i, retval, expected[i]);
 4b1:	83 ec 0c             	sub    $0xc,%esp
 4b4:	52                   	push   %edx
 4b5:	50                   	push   %eax
 4b6:	53                   	push   %ebx
 4b7:	68 30 0d 00 00       	push   $0xd30
 4bc:	6a 01                	push   $0x1
 4be:	e8 cd 03 00 00       	call   890 <printf>
      failed();
 4c3:	83 c4 20             	add    $0x20,%esp
 4c6:	e8 05 fd ff ff       	call   1d0 <failed>
 4cb:	66 90                	xchg   %ax,%ax
 4cd:	66 90                	xchg   %ax,%ax
 4cf:	90                   	nop

000004d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 4d0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4d1:	31 c0                	xor    %eax,%eax
{
 4d3:	89 e5                	mov    %esp,%ebp
 4d5:	53                   	push   %ebx
 4d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 4dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 4e0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 4e4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 4e7:	83 c0 01             	add    $0x1,%eax
 4ea:	84 d2                	test   %dl,%dl
 4ec:	75 f2                	jne    4e0 <strcpy+0x10>
    ;
  return os;
}
 4ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4f1:	89 c8                	mov    %ecx,%eax
 4f3:	c9                   	leave  
 4f4:	c3                   	ret    
 4f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000500 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	53                   	push   %ebx
 504:	8b 55 08             	mov    0x8(%ebp),%edx
 507:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 50a:	0f b6 02             	movzbl (%edx),%eax
 50d:	84 c0                	test   %al,%al
 50f:	75 17                	jne    528 <strcmp+0x28>
 511:	eb 3a                	jmp    54d <strcmp+0x4d>
 513:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 517:	90                   	nop
 518:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 51c:	83 c2 01             	add    $0x1,%edx
 51f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 522:	84 c0                	test   %al,%al
 524:	74 1a                	je     540 <strcmp+0x40>
    p++, q++;
 526:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 528:	0f b6 19             	movzbl (%ecx),%ebx
 52b:	38 c3                	cmp    %al,%bl
 52d:	74 e9                	je     518 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 52f:	29 d8                	sub    %ebx,%eax
}
 531:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 534:	c9                   	leave  
 535:	c3                   	ret    
 536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 53d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 540:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 544:	31 c0                	xor    %eax,%eax
 546:	29 d8                	sub    %ebx,%eax
}
 548:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 54b:	c9                   	leave  
 54c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 54d:	0f b6 19             	movzbl (%ecx),%ebx
 550:	31 c0                	xor    %eax,%eax
 552:	eb db                	jmp    52f <strcmp+0x2f>
 554:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 55b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 55f:	90                   	nop

00000560 <strlen>:

uint
strlen(const char *s)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 566:	80 3a 00             	cmpb   $0x0,(%edx)
 569:	74 15                	je     580 <strlen+0x20>
 56b:	31 c0                	xor    %eax,%eax
 56d:	8d 76 00             	lea    0x0(%esi),%esi
 570:	83 c0 01             	add    $0x1,%eax
 573:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 577:	89 c1                	mov    %eax,%ecx
 579:	75 f5                	jne    570 <strlen+0x10>
    ;
  return n;
}
 57b:	89 c8                	mov    %ecx,%eax
 57d:	5d                   	pop    %ebp
 57e:	c3                   	ret    
 57f:	90                   	nop
  for(n = 0; s[n]; n++)
 580:	31 c9                	xor    %ecx,%ecx
}
 582:	5d                   	pop    %ebp
 583:	89 c8                	mov    %ecx,%eax
 585:	c3                   	ret    
 586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58d:	8d 76 00             	lea    0x0(%esi),%esi

00000590 <memset>:

void*
memset(void *dst, int c, uint n)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 597:	8b 4d 10             	mov    0x10(%ebp),%ecx
 59a:	8b 45 0c             	mov    0xc(%ebp),%eax
 59d:	89 d7                	mov    %edx,%edi
 59f:	fc                   	cld    
 5a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 5a2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 5a5:	89 d0                	mov    %edx,%eax
 5a7:	c9                   	leave  
 5a8:	c3                   	ret    
 5a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005b0 <strchr>:

char*
strchr(const char *s, char c)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	8b 45 08             	mov    0x8(%ebp),%eax
 5b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 5ba:	0f b6 10             	movzbl (%eax),%edx
 5bd:	84 d2                	test   %dl,%dl
 5bf:	75 12                	jne    5d3 <strchr+0x23>
 5c1:	eb 1d                	jmp    5e0 <strchr+0x30>
 5c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5c7:	90                   	nop
 5c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 5cc:	83 c0 01             	add    $0x1,%eax
 5cf:	84 d2                	test   %dl,%dl
 5d1:	74 0d                	je     5e0 <strchr+0x30>
    if(*s == c)
 5d3:	38 d1                	cmp    %dl,%cl
 5d5:	75 f1                	jne    5c8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 5d7:	5d                   	pop    %ebp
 5d8:	c3                   	ret    
 5d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 5e0:	31 c0                	xor    %eax,%eax
}
 5e2:	5d                   	pop    %ebp
 5e3:	c3                   	ret    
 5e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5ef:	90                   	nop

000005f0 <gets>:

char*
gets(char *buf, int max)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	57                   	push   %edi
 5f4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 5f5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 5f8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 5f9:	31 db                	xor    %ebx,%ebx
{
 5fb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 5fe:	eb 27                	jmp    627 <gets+0x37>
    cc = read(0, &c, 1);
 600:	83 ec 04             	sub    $0x4,%esp
 603:	6a 01                	push   $0x1
 605:	57                   	push   %edi
 606:	6a 00                	push   $0x0
 608:	e8 2e 01 00 00       	call   73b <read>
    if(cc < 1)
 60d:	83 c4 10             	add    $0x10,%esp
 610:	85 c0                	test   %eax,%eax
 612:	7e 1d                	jle    631 <gets+0x41>
      break;
    buf[i++] = c;
 614:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 618:	8b 55 08             	mov    0x8(%ebp),%edx
 61b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 61f:	3c 0a                	cmp    $0xa,%al
 621:	74 1d                	je     640 <gets+0x50>
 623:	3c 0d                	cmp    $0xd,%al
 625:	74 19                	je     640 <gets+0x50>
  for(i=0; i+1 < max; ){
 627:	89 de                	mov    %ebx,%esi
 629:	83 c3 01             	add    $0x1,%ebx
 62c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 62f:	7c cf                	jl     600 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 631:	8b 45 08             	mov    0x8(%ebp),%eax
 634:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 638:	8d 65 f4             	lea    -0xc(%ebp),%esp
 63b:	5b                   	pop    %ebx
 63c:	5e                   	pop    %esi
 63d:	5f                   	pop    %edi
 63e:	5d                   	pop    %ebp
 63f:	c3                   	ret    
  buf[i] = '\0';
 640:	8b 45 08             	mov    0x8(%ebp),%eax
 643:	89 de                	mov    %ebx,%esi
 645:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 649:	8d 65 f4             	lea    -0xc(%ebp),%esp
 64c:	5b                   	pop    %ebx
 64d:	5e                   	pop    %esi
 64e:	5f                   	pop    %edi
 64f:	5d                   	pop    %ebp
 650:	c3                   	ret    
 651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 65f:	90                   	nop

00000660 <stat>:

int
stat(const char *n, struct stat *st)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	56                   	push   %esi
 664:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 665:	83 ec 08             	sub    $0x8,%esp
 668:	6a 00                	push   $0x0
 66a:	ff 75 08             	push   0x8(%ebp)
 66d:	e8 f1 00 00 00       	call   763 <open>
  if(fd < 0)
 672:	83 c4 10             	add    $0x10,%esp
 675:	85 c0                	test   %eax,%eax
 677:	78 27                	js     6a0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 679:	83 ec 08             	sub    $0x8,%esp
 67c:	ff 75 0c             	push   0xc(%ebp)
 67f:	89 c3                	mov    %eax,%ebx
 681:	50                   	push   %eax
 682:	e8 f4 00 00 00       	call   77b <fstat>
  close(fd);
 687:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 68a:	89 c6                	mov    %eax,%esi
  close(fd);
 68c:	e8 ba 00 00 00       	call   74b <close>
  return r;
 691:	83 c4 10             	add    $0x10,%esp
}
 694:	8d 65 f8             	lea    -0x8(%ebp),%esp
 697:	89 f0                	mov    %esi,%eax
 699:	5b                   	pop    %ebx
 69a:	5e                   	pop    %esi
 69b:	5d                   	pop    %ebp
 69c:	c3                   	ret    
 69d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 6a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 6a5:	eb ed                	jmp    694 <stat+0x34>
 6a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ae:	66 90                	xchg   %ax,%ax

000006b0 <atoi>:

int
atoi(const char *s)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	53                   	push   %ebx
 6b4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6b7:	0f be 02             	movsbl (%edx),%eax
 6ba:	8d 48 d0             	lea    -0x30(%eax),%ecx
 6bd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 6c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 6c5:	77 1e                	ja     6e5 <atoi+0x35>
 6c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ce:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 6d0:	83 c2 01             	add    $0x1,%edx
 6d3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 6d6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 6da:	0f be 02             	movsbl (%edx),%eax
 6dd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 6e0:	80 fb 09             	cmp    $0x9,%bl
 6e3:	76 eb                	jbe    6d0 <atoi+0x20>
  return n;
}
 6e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6e8:	89 c8                	mov    %ecx,%eax
 6ea:	c9                   	leave  
 6eb:	c3                   	ret    
 6ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	57                   	push   %edi
 6f4:	8b 45 10             	mov    0x10(%ebp),%eax
 6f7:	8b 55 08             	mov    0x8(%ebp),%edx
 6fa:	56                   	push   %esi
 6fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 6fe:	85 c0                	test   %eax,%eax
 700:	7e 13                	jle    715 <memmove+0x25>
 702:	01 d0                	add    %edx,%eax
  dst = vdst;
 704:	89 d7                	mov    %edx,%edi
 706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 70d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 710:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 711:	39 f8                	cmp    %edi,%eax
 713:	75 fb                	jne    710 <memmove+0x20>
  return vdst;
}
 715:	5e                   	pop    %esi
 716:	89 d0                	mov    %edx,%eax
 718:	5f                   	pop    %edi
 719:	5d                   	pop    %ebp
 71a:	c3                   	ret    

0000071b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 71b:	b8 01 00 00 00       	mov    $0x1,%eax
 720:	cd 40                	int    $0x40
 722:	c3                   	ret    

00000723 <exit>:
SYSCALL(exit)
 723:	b8 02 00 00 00       	mov    $0x2,%eax
 728:	cd 40                	int    $0x40
 72a:	c3                   	ret    

0000072b <wait>:
SYSCALL(wait)
 72b:	b8 03 00 00 00       	mov    $0x3,%eax
 730:	cd 40                	int    $0x40
 732:	c3                   	ret    

00000733 <pipe>:
SYSCALL(pipe)
 733:	b8 04 00 00 00       	mov    $0x4,%eax
 738:	cd 40                	int    $0x40
 73a:	c3                   	ret    

0000073b <read>:
SYSCALL(read)
 73b:	b8 05 00 00 00       	mov    $0x5,%eax
 740:	cd 40                	int    $0x40
 742:	c3                   	ret    

00000743 <write>:
SYSCALL(write)
 743:	b8 10 00 00 00       	mov    $0x10,%eax
 748:	cd 40                	int    $0x40
 74a:	c3                   	ret    

0000074b <close>:
SYSCALL(close)
 74b:	b8 15 00 00 00       	mov    $0x15,%eax
 750:	cd 40                	int    $0x40
 752:	c3                   	ret    

00000753 <kill>:
SYSCALL(kill)
 753:	b8 06 00 00 00       	mov    $0x6,%eax
 758:	cd 40                	int    $0x40
 75a:	c3                   	ret    

0000075b <exec>:
SYSCALL(exec)
 75b:	b8 07 00 00 00       	mov    $0x7,%eax
 760:	cd 40                	int    $0x40
 762:	c3                   	ret    

00000763 <open>:
SYSCALL(open)
 763:	b8 0f 00 00 00       	mov    $0xf,%eax
 768:	cd 40                	int    $0x40
 76a:	c3                   	ret    

0000076b <mknod>:
SYSCALL(mknod)
 76b:	b8 11 00 00 00       	mov    $0x11,%eax
 770:	cd 40                	int    $0x40
 772:	c3                   	ret    

00000773 <unlink>:
SYSCALL(unlink)
 773:	b8 12 00 00 00       	mov    $0x12,%eax
 778:	cd 40                	int    $0x40
 77a:	c3                   	ret    

0000077b <fstat>:
SYSCALL(fstat)
 77b:	b8 08 00 00 00       	mov    $0x8,%eax
 780:	cd 40                	int    $0x40
 782:	c3                   	ret    

00000783 <link>:
SYSCALL(link)
 783:	b8 13 00 00 00       	mov    $0x13,%eax
 788:	cd 40                	int    $0x40
 78a:	c3                   	ret    

0000078b <mkdir>:
SYSCALL(mkdir)
 78b:	b8 14 00 00 00       	mov    $0x14,%eax
 790:	cd 40                	int    $0x40
 792:	c3                   	ret    

00000793 <chdir>:
SYSCALL(chdir)
 793:	b8 09 00 00 00       	mov    $0x9,%eax
 798:	cd 40                	int    $0x40
 79a:	c3                   	ret    

0000079b <dup>:
SYSCALL(dup)
 79b:	b8 0a 00 00 00       	mov    $0xa,%eax
 7a0:	cd 40                	int    $0x40
 7a2:	c3                   	ret    

000007a3 <getpid>:
SYSCALL(getpid)
 7a3:	b8 0b 00 00 00       	mov    $0xb,%eax
 7a8:	cd 40                	int    $0x40
 7aa:	c3                   	ret    

000007ab <sbrk>:
SYSCALL(sbrk)
 7ab:	b8 0c 00 00 00       	mov    $0xc,%eax
 7b0:	cd 40                	int    $0x40
 7b2:	c3                   	ret    

000007b3 <sleep>:
SYSCALL(sleep)
 7b3:	b8 0d 00 00 00       	mov    $0xd,%eax
 7b8:	cd 40                	int    $0x40
 7ba:	c3                   	ret    

000007bb <uptime>:
SYSCALL(uptime)
 7bb:	b8 0e 00 00 00       	mov    $0xe,%eax
 7c0:	cd 40                	int    $0x40
 7c2:	c3                   	ret    

000007c3 <thread_create>:
SYSCALL(thread_create)
 7c3:	b8 16 00 00 00       	mov    $0x16,%eax
 7c8:	cd 40                	int    $0x40
 7ca:	c3                   	ret    

000007cb <thread_exit>:
SYSCALL(thread_exit)
 7cb:	b8 17 00 00 00       	mov    $0x17,%eax
 7d0:	cd 40                	int    $0x40
 7d2:	c3                   	ret    

000007d3 <thread_join>:
SYSCALL(thread_join)
 7d3:	b8 18 00 00 00       	mov    $0x18,%eax
 7d8:	cd 40                	int    $0x40
 7da:	c3                   	ret    
 7db:	66 90                	xchg   %ax,%ax
 7dd:	66 90                	xchg   %ax,%ax
 7df:	90                   	nop

000007e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	57                   	push   %edi
 7e4:	56                   	push   %esi
 7e5:	53                   	push   %ebx
 7e6:	83 ec 3c             	sub    $0x3c,%esp
 7e9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 7ec:	89 d1                	mov    %edx,%ecx
{
 7ee:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 7f1:	85 d2                	test   %edx,%edx
 7f3:	0f 89 7f 00 00 00    	jns    878 <printint+0x98>
 7f9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 7fd:	74 79                	je     878 <printint+0x98>
    neg = 1;
 7ff:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 806:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 808:	31 db                	xor    %ebx,%ebx
 80a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 80d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 810:	89 c8                	mov    %ecx,%eax
 812:	31 d2                	xor    %edx,%edx
 814:	89 cf                	mov    %ecx,%edi
 816:	f7 75 c4             	divl   -0x3c(%ebp)
 819:	0f b6 92 54 0e 00 00 	movzbl 0xe54(%edx),%edx
 820:	89 45 c0             	mov    %eax,-0x40(%ebp)
 823:	89 d8                	mov    %ebx,%eax
 825:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 828:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 82b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 82e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 831:	76 dd                	jbe    810 <printint+0x30>
  if(neg)
 833:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 836:	85 c9                	test   %ecx,%ecx
 838:	74 0c                	je     846 <printint+0x66>
    buf[i++] = '-';
 83a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 83f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 841:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 846:	8b 7d b8             	mov    -0x48(%ebp),%edi
 849:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 84d:	eb 07                	jmp    856 <printint+0x76>
 84f:	90                   	nop
    putc(fd, buf[i]);
 850:	0f b6 13             	movzbl (%ebx),%edx
 853:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 856:	83 ec 04             	sub    $0x4,%esp
 859:	88 55 d7             	mov    %dl,-0x29(%ebp)
 85c:	6a 01                	push   $0x1
 85e:	56                   	push   %esi
 85f:	57                   	push   %edi
 860:	e8 de fe ff ff       	call   743 <write>
  while(--i >= 0)
 865:	83 c4 10             	add    $0x10,%esp
 868:	39 de                	cmp    %ebx,%esi
 86a:	75 e4                	jne    850 <printint+0x70>
}
 86c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 86f:	5b                   	pop    %ebx
 870:	5e                   	pop    %esi
 871:	5f                   	pop    %edi
 872:	5d                   	pop    %ebp
 873:	c3                   	ret    
 874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 878:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 87f:	eb 87                	jmp    808 <printint+0x28>
 881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 888:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 88f:	90                   	nop

00000890 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	57                   	push   %edi
 894:	56                   	push   %esi
 895:	53                   	push   %ebx
 896:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 899:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 89c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 89f:	0f b6 13             	movzbl (%ebx),%edx
 8a2:	84 d2                	test   %dl,%dl
 8a4:	74 6a                	je     910 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 8a6:	8d 45 10             	lea    0x10(%ebp),%eax
 8a9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 8ac:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 8af:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 8b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 8b4:	eb 36                	jmp    8ec <printf+0x5c>
 8b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8bd:	8d 76 00             	lea    0x0(%esi),%esi
 8c0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 8c3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 8c8:	83 f8 25             	cmp    $0x25,%eax
 8cb:	74 15                	je     8e2 <printf+0x52>
  write(fd, &c, 1);
 8cd:	83 ec 04             	sub    $0x4,%esp
 8d0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 8d3:	6a 01                	push   $0x1
 8d5:	57                   	push   %edi
 8d6:	56                   	push   %esi
 8d7:	e8 67 fe ff ff       	call   743 <write>
 8dc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 8df:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 8e2:	0f b6 13             	movzbl (%ebx),%edx
 8e5:	83 c3 01             	add    $0x1,%ebx
 8e8:	84 d2                	test   %dl,%dl
 8ea:	74 24                	je     910 <printf+0x80>
    c = fmt[i] & 0xff;
 8ec:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 8ef:	85 c9                	test   %ecx,%ecx
 8f1:	74 cd                	je     8c0 <printf+0x30>
      }
    } else if(state == '%'){
 8f3:	83 f9 25             	cmp    $0x25,%ecx
 8f6:	75 ea                	jne    8e2 <printf+0x52>
      if(c == 'd'){
 8f8:	83 f8 25             	cmp    $0x25,%eax
 8fb:	0f 84 07 01 00 00    	je     a08 <printf+0x178>
 901:	83 e8 63             	sub    $0x63,%eax
 904:	83 f8 15             	cmp    $0x15,%eax
 907:	77 17                	ja     920 <printf+0x90>
 909:	ff 24 85 fc 0d 00 00 	jmp    *0xdfc(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 910:	8d 65 f4             	lea    -0xc(%ebp),%esp
 913:	5b                   	pop    %ebx
 914:	5e                   	pop    %esi
 915:	5f                   	pop    %edi
 916:	5d                   	pop    %ebp
 917:	c3                   	ret    
 918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 91f:	90                   	nop
  write(fd, &c, 1);
 920:	83 ec 04             	sub    $0x4,%esp
 923:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 926:	6a 01                	push   $0x1
 928:	57                   	push   %edi
 929:	56                   	push   %esi
 92a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 92e:	e8 10 fe ff ff       	call   743 <write>
        putc(fd, c);
 933:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 937:	83 c4 0c             	add    $0xc,%esp
 93a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 93d:	6a 01                	push   $0x1
 93f:	57                   	push   %edi
 940:	56                   	push   %esi
 941:	e8 fd fd ff ff       	call   743 <write>
        putc(fd, c);
 946:	83 c4 10             	add    $0x10,%esp
      state = 0;
 949:	31 c9                	xor    %ecx,%ecx
 94b:	eb 95                	jmp    8e2 <printf+0x52>
 94d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 950:	83 ec 0c             	sub    $0xc,%esp
 953:	b9 10 00 00 00       	mov    $0x10,%ecx
 958:	6a 00                	push   $0x0
 95a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 95d:	8b 10                	mov    (%eax),%edx
 95f:	89 f0                	mov    %esi,%eax
 961:	e8 7a fe ff ff       	call   7e0 <printint>
        ap++;
 966:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 96a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 96d:	31 c9                	xor    %ecx,%ecx
 96f:	e9 6e ff ff ff       	jmp    8e2 <printf+0x52>
 974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 978:	8b 45 d0             	mov    -0x30(%ebp),%eax
 97b:	8b 10                	mov    (%eax),%edx
        ap++;
 97d:	83 c0 04             	add    $0x4,%eax
 980:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 983:	85 d2                	test   %edx,%edx
 985:	0f 84 8d 00 00 00    	je     a18 <printf+0x188>
        while(*s != 0){
 98b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 98e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 990:	84 c0                	test   %al,%al
 992:	0f 84 4a ff ff ff    	je     8e2 <printf+0x52>
 998:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 99b:	89 d3                	mov    %edx,%ebx
 99d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 9a0:	83 ec 04             	sub    $0x4,%esp
          s++;
 9a3:	83 c3 01             	add    $0x1,%ebx
 9a6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 9a9:	6a 01                	push   $0x1
 9ab:	57                   	push   %edi
 9ac:	56                   	push   %esi
 9ad:	e8 91 fd ff ff       	call   743 <write>
        while(*s != 0){
 9b2:	0f b6 03             	movzbl (%ebx),%eax
 9b5:	83 c4 10             	add    $0x10,%esp
 9b8:	84 c0                	test   %al,%al
 9ba:	75 e4                	jne    9a0 <printf+0x110>
      state = 0;
 9bc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 9bf:	31 c9                	xor    %ecx,%ecx
 9c1:	e9 1c ff ff ff       	jmp    8e2 <printf+0x52>
 9c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9cd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 9d0:	83 ec 0c             	sub    $0xc,%esp
 9d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 9d8:	6a 01                	push   $0x1
 9da:	e9 7b ff ff ff       	jmp    95a <printf+0xca>
 9df:	90                   	nop
        putc(fd, *ap);
 9e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 9e3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 9e6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 9e8:	6a 01                	push   $0x1
 9ea:	57                   	push   %edi
 9eb:	56                   	push   %esi
        putc(fd, *ap);
 9ec:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 9ef:	e8 4f fd ff ff       	call   743 <write>
        ap++;
 9f4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 9f8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 9fb:	31 c9                	xor    %ecx,%ecx
 9fd:	e9 e0 fe ff ff       	jmp    8e2 <printf+0x52>
 a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 a08:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 a0b:	83 ec 04             	sub    $0x4,%esp
 a0e:	e9 2a ff ff ff       	jmp    93d <printf+0xad>
 a13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a17:	90                   	nop
          s = "(null)";
 a18:	ba f2 0d 00 00       	mov    $0xdf2,%edx
        while(*s != 0){
 a1d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 a20:	b8 28 00 00 00       	mov    $0x28,%eax
 a25:	89 d3                	mov    %edx,%ebx
 a27:	e9 74 ff ff ff       	jmp    9a0 <printf+0x110>
 a2c:	66 90                	xchg   %ax,%ax
 a2e:	66 90                	xchg   %ax,%ax

00000a30 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a30:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a31:	a1 28 12 00 00       	mov    0x1228,%eax
{
 a36:	89 e5                	mov    %esp,%ebp
 a38:	57                   	push   %edi
 a39:	56                   	push   %esi
 a3a:	53                   	push   %ebx
 a3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 a3e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a48:	89 c2                	mov    %eax,%edx
 a4a:	8b 00                	mov    (%eax),%eax
 a4c:	39 ca                	cmp    %ecx,%edx
 a4e:	73 30                	jae    a80 <free+0x50>
 a50:	39 c1                	cmp    %eax,%ecx
 a52:	72 04                	jb     a58 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a54:	39 c2                	cmp    %eax,%edx
 a56:	72 f0                	jb     a48 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 a58:	8b 73 fc             	mov    -0x4(%ebx),%esi
 a5b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 a5e:	39 f8                	cmp    %edi,%eax
 a60:	74 30                	je     a92 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 a62:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 a65:	8b 42 04             	mov    0x4(%edx),%eax
 a68:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 a6b:	39 f1                	cmp    %esi,%ecx
 a6d:	74 3a                	je     aa9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 a6f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 a71:	5b                   	pop    %ebx
  freep = p;
 a72:	89 15 28 12 00 00    	mov    %edx,0x1228
}
 a78:	5e                   	pop    %esi
 a79:	5f                   	pop    %edi
 a7a:	5d                   	pop    %ebp
 a7b:	c3                   	ret    
 a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a80:	39 c2                	cmp    %eax,%edx
 a82:	72 c4                	jb     a48 <free+0x18>
 a84:	39 c1                	cmp    %eax,%ecx
 a86:	73 c0                	jae    a48 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 a88:	8b 73 fc             	mov    -0x4(%ebx),%esi
 a8b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 a8e:	39 f8                	cmp    %edi,%eax
 a90:	75 d0                	jne    a62 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 a92:	03 70 04             	add    0x4(%eax),%esi
 a95:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 a98:	8b 02                	mov    (%edx),%eax
 a9a:	8b 00                	mov    (%eax),%eax
 a9c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 a9f:	8b 42 04             	mov    0x4(%edx),%eax
 aa2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 aa5:	39 f1                	cmp    %esi,%ecx
 aa7:	75 c6                	jne    a6f <free+0x3f>
    p->s.size += bp->s.size;
 aa9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 aac:	89 15 28 12 00 00    	mov    %edx,0x1228
    p->s.size += bp->s.size;
 ab2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 ab5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 ab8:	89 0a                	mov    %ecx,(%edx)
}
 aba:	5b                   	pop    %ebx
 abb:	5e                   	pop    %esi
 abc:	5f                   	pop    %edi
 abd:	5d                   	pop    %ebp
 abe:	c3                   	ret    
 abf:	90                   	nop

00000ac0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ac0:	55                   	push   %ebp
 ac1:	89 e5                	mov    %esp,%ebp
 ac3:	57                   	push   %edi
 ac4:	56                   	push   %esi
 ac5:	53                   	push   %ebx
 ac6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 acc:	8b 3d 28 12 00 00    	mov    0x1228,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ad2:	8d 70 07             	lea    0x7(%eax),%esi
 ad5:	c1 ee 03             	shr    $0x3,%esi
 ad8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 adb:	85 ff                	test   %edi,%edi
 add:	0f 84 9d 00 00 00    	je     b80 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ae3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 ae5:	8b 4a 04             	mov    0x4(%edx),%ecx
 ae8:	39 f1                	cmp    %esi,%ecx
 aea:	73 6a                	jae    b56 <malloc+0x96>
 aec:	bb 00 10 00 00       	mov    $0x1000,%ebx
 af1:	39 de                	cmp    %ebx,%esi
 af3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 af6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 afd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 b00:	eb 17                	jmp    b19 <malloc+0x59>
 b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b08:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 b0a:	8b 48 04             	mov    0x4(%eax),%ecx
 b0d:	39 f1                	cmp    %esi,%ecx
 b0f:	73 4f                	jae    b60 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b11:	8b 3d 28 12 00 00    	mov    0x1228,%edi
 b17:	89 c2                	mov    %eax,%edx
 b19:	39 d7                	cmp    %edx,%edi
 b1b:	75 eb                	jne    b08 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 b1d:	83 ec 0c             	sub    $0xc,%esp
 b20:	ff 75 e4             	push   -0x1c(%ebp)
 b23:	e8 83 fc ff ff       	call   7ab <sbrk>
  if(p == (char*)-1)
 b28:	83 c4 10             	add    $0x10,%esp
 b2b:	83 f8 ff             	cmp    $0xffffffff,%eax
 b2e:	74 1c                	je     b4c <malloc+0x8c>
  hp->s.size = nu;
 b30:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 b33:	83 ec 0c             	sub    $0xc,%esp
 b36:	83 c0 08             	add    $0x8,%eax
 b39:	50                   	push   %eax
 b3a:	e8 f1 fe ff ff       	call   a30 <free>
  return freep;
 b3f:	8b 15 28 12 00 00    	mov    0x1228,%edx
      if((p = morecore(nunits)) == 0)
 b45:	83 c4 10             	add    $0x10,%esp
 b48:	85 d2                	test   %edx,%edx
 b4a:	75 bc                	jne    b08 <malloc+0x48>
        return 0;
  }
}
 b4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 b4f:	31 c0                	xor    %eax,%eax
}
 b51:	5b                   	pop    %ebx
 b52:	5e                   	pop    %esi
 b53:	5f                   	pop    %edi
 b54:	5d                   	pop    %ebp
 b55:	c3                   	ret    
    if(p->s.size >= nunits){
 b56:	89 d0                	mov    %edx,%eax
 b58:	89 fa                	mov    %edi,%edx
 b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 b60:	39 ce                	cmp    %ecx,%esi
 b62:	74 4c                	je     bb0 <malloc+0xf0>
        p->s.size -= nunits;
 b64:	29 f1                	sub    %esi,%ecx
 b66:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 b69:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 b6c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 b6f:	89 15 28 12 00 00    	mov    %edx,0x1228
}
 b75:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 b78:	83 c0 08             	add    $0x8,%eax
}
 b7b:	5b                   	pop    %ebx
 b7c:	5e                   	pop    %esi
 b7d:	5f                   	pop    %edi
 b7e:	5d                   	pop    %ebp
 b7f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 b80:	c7 05 28 12 00 00 2c 	movl   $0x122c,0x1228
 b87:	12 00 00 
    base.s.size = 0;
 b8a:	bf 2c 12 00 00       	mov    $0x122c,%edi
    base.s.ptr = freep = prevp = &base;
 b8f:	c7 05 2c 12 00 00 2c 	movl   $0x122c,0x122c
 b96:	12 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b99:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 b9b:	c7 05 30 12 00 00 00 	movl   $0x0,0x1230
 ba2:	00 00 00 
    if(p->s.size >= nunits){
 ba5:	e9 42 ff ff ff       	jmp    aec <malloc+0x2c>
 baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 bb0:	8b 08                	mov    (%eax),%ecx
 bb2:	89 0a                	mov    %ecx,(%edx)
 bb4:	eb b9                	jmp    b6f <malloc+0xaf>
