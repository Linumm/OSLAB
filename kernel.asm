
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 d4 14 80       	mov    $0x8014d4d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 32 10 80       	mov    $0x80103260,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 74 10 80       	push   $0x801074a0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 75 45 00 00       	call   801045d0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 74 10 80       	push   $0x801074a7
80100097:	50                   	push   %eax
80100098:	e8 03 44 00 00       	call   801044a0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 b7 46 00 00       	call   801047a0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 d9 45 00 00       	call   80104740 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 43 00 00       	call   801044e0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ae 74 10 80       	push   $0x801074ae
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 bd 43 00 00       	call   80104580 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 bf 74 10 80       	push   $0x801074bf
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 43 00 00       	call   80104580 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 2c 43 00 00       	call   80104540 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 80 45 00 00       	call   801047a0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 cf 44 00 00       	jmp    80104740 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 c6 74 10 80       	push   $0x801074c6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 fb 44 00 00       	call   801047a0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 6e 3f 00 00       	call   80104240 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 89 38 00 00       	call   80103b70 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 45 44 00 00       	call   80104740 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 ef 43 00 00       	call   80104740 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 52 27 00 00       	call   80102af0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 cd 74 10 80       	push   $0x801074cd
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 3f 7e 10 80 	movl   $0x80107e3f,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 23 42 00 00       	call   801045f0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 e1 74 10 80       	push   $0x801074e1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 b1 5a 00 00       	call   80105ed0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 c6 59 00 00       	call   80105ed0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 ba 59 00 00       	call   80105ed0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 ae 59 00 00       	call   80105ed0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 aa 43 00 00       	call   80104900 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 f5 42 00 00       	call   80104860 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 e5 74 10 80       	push   $0x801074e5
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005ab:	e8 f0 41 00 00       	call   801047a0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ef 10 80       	push   $0x8010ef20
801005e4:	e8 57 41 00 00       	call   80104740 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 10 75 10 80 	movzbl -0x7fef8af0(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ef 10 80       	push   $0x8010ef20
801007e8:	e8 b3 3f 00 00       	call   801047a0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf f8 74 10 80       	mov    $0x801074f8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ef 10 80       	push   $0x8010ef20
8010085b:	e8 e0 3e 00 00       	call   80104740 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 ff 74 10 80       	push   $0x801074ff
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ef 10 80       	push   $0x8010ef20
80100893:	e8 08 3f 00 00       	call   801047a0 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100945:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
8010096c:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100985:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100999:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009b7:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ef 10 80       	push   $0x8010ef20
801009d0:	e8 6b 3d 00 00       	call   80104740 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 cd 39 00 00       	jmp    801043e0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a3f:	68 00 ef 10 80       	push   $0x8010ef00
80100a44:	e8 b7 38 00 00       	call   80104300 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 08 75 10 80       	push   $0x80107508
80100a6b:	68 20 ef 10 80       	push   $0x8010ef20
80100a70:	e8 5b 3b 00 00       	call   801045d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c f9 10 80 90 	movl   $0x80100590,0x8010f90c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 af 30 00 00       	call   80103b70 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 94 24 00 00       	call   80102f60 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 bc 24 00 00       	call   80102fd0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 27 65 00 00       	call   80107060 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 d8 62 00 00       	call   80106e80 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 b2 61 00 00       	call   80106d90 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 c0 63 00 00       	call   80106fe0 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 7a 23 00 00       	call   80102fd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 19 62 00 00       	call   80106e80 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 78 64 00 00       	call   80107100 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 88 3d 00 00       	call   80104a60 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 74 3d 00 00       	call   80104a60 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 b3 65 00 00       	call   801072b0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 ca 62 00 00       	call   80106fe0 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 48 65 00 00       	call   801072b0 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 7a 3c 00 00       	call   80104a20 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 2e 5e 00 00       	call   80106c00 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 06 62 00 00       	call   80106fe0 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 21 00 00       	call   80102fd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 21 75 10 80       	push   $0x80107521
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 2d 75 10 80       	push   $0x8010752d
80100e1b:	68 60 ef 10 80       	push   $0x8010ef60
80100e20:	e8 ab 37 00 00       	call   801045d0 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ef 10 80       	push   $0x8010ef60
80100e41:	e8 5a 39 00 00       	call   801047a0 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ef 10 80       	push   $0x8010ef60
80100e71:	e8 ca 38 00 00       	call   80104740 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ef 10 80       	push   $0x8010ef60
80100e8a:	e8 b1 38 00 00       	call   80104740 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ef 10 80       	push   $0x8010ef60
80100eaf:	e8 ec 38 00 00       	call   801047a0 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ef 10 80       	push   $0x8010ef60
80100ecc:	e8 6f 38 00 00       	call   80104740 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 34 75 10 80       	push   $0x80107534
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ef 10 80       	push   $0x8010ef60
80100f01:	e8 9a 38 00 00       	call   801047a0 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ef 10 80       	push   $0x8010ef60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 ff 37 00 00       	call   80104740 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 cd 37 00 00       	jmp    80104740 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 e3 1f 00 00       	call   80102f60 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 39 20 00 00       	jmp    80102fd0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 82 27 00 00       	call   80103730 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 3c 75 10 80       	push   $0x8010753c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 3e 28 00 00       	jmp    801038d0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 46 75 10 80       	push   $0x80107546
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 c2 1e 00 00       	call   80102fd0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 2d 1e 00 00       	call   80102f60 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 66 1e 00 00       	call   80102fd0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 4f 75 10 80       	push   $0x8010754f
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 22 26 00 00       	jmp    801037d0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 55 75 10 80       	push   $0x80107555
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 2e 1f 00 00       	call   80103140 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 5f 75 10 80       	push   $0x8010755f
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 72 75 10 80       	push   $0x80107572
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 3e 1e 00 00       	call   80103140 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 36 35 00 00       	call   80104860 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 0e 1e 00 00       	call   80103140 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 f9 10 80       	push   $0x8010f960
8010136a:	e8 31 34 00 00       	call   801047a0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 f9 10 80       	push   $0x8010f960
801013d7:	e8 64 33 00 00       	call   80104740 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 f9 10 80       	push   $0x8010f960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 36 33 00 00       	call   80104740 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 88 75 10 80       	push   $0x80107588
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 76 1c 00 00       	call   80103140 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 98 75 10 80       	push   $0x80107598
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 ba 33 00 00       	call   80104900 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 ab 75 10 80       	push   $0x801075ab
80101571:	68 60 f9 10 80       	push   $0x8010f960
80101576:	e8 55 30 00 00       	call   801045d0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 b2 75 10 80       	push   $0x801075b2
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 0c 2f 00 00       	call   801044a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 15 11 80       	push   $0x801115b4
801015bc:	e8 3f 33 00 00       	call   80104900 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 15 11 80    	push   0x801115cc
801015cf:	ff 35 c8 15 11 80    	push   0x801115c8
801015d5:	ff 35 c4 15 11 80    	push   0x801115c4
801015db:	ff 35 c0 15 11 80    	push   0x801115c0
801015e1:	ff 35 bc 15 11 80    	push   0x801115bc
801015e7:	ff 35 b8 15 11 80    	push   0x801115b8
801015ed:	ff 35 b4 15 11 80    	push   0x801115b4
801015f3:	68 18 76 10 80       	push   $0x80107618
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 cd 31 00 00       	call   80104860 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 1a 00 00       	call   80103140 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 b8 75 10 80       	push   $0x801075b8
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 ca 31 00 00       	call   80104900 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 02 1a 00 00       	call   80103140 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 f9 10 80       	push   $0x8010f960
8010175f:	e8 3c 30 00 00       	call   801047a0 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010176f:	e8 cc 2f 00 00       	call   80104740 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 39 2d 00 00       	call   801044e0 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 e3 30 00 00       	call   80104900 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 d0 75 10 80       	push   $0x801075d0
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 ca 75 10 80       	push   $0x801075ca
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 08 2d 00 00       	call   80104580 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 ac 2c 00 00       	jmp    80104540 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 df 75 10 80       	push   $0x801075df
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 1b 2c 00 00       	call   801044e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 61 2c 00 00       	call   80104540 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801018e6:	e8 b5 2e 00 00       	call   801047a0 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 3b 2e 00 00       	jmp    80104740 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 f9 10 80       	push   $0x8010f960
80101910:	e8 8b 2e 00 00       	call   801047a0 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010191f:	e8 1c 2e 00 00       	call   80104740 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 58 2b 00 00       	call   80104580 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 01 2b 00 00       	call   80104540 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 df 75 10 80       	push   $0x801075df
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 c4 2d 00 00       	call   80104900 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 c8 2c 00 00       	call   80104900 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 15 00 00       	call   80103140 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 9d 2c 00 00       	call   80104970 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 3e 2c 00 00       	call   80104970 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 f9 75 10 80       	push   $0x801075f9
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 e7 75 10 80       	push   $0x801075e7
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 c1 1d 00 00       	call   80103b70 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 f9 10 80       	push   $0x8010f960
80101dba:	e8 e1 29 00 00       	call   801047a0 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101dca:	e8 71 29 00 00       	call   80104740 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 d4 2a 00 00       	call   80104900 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 ef 26 00 00       	call   80104580 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 8d 26 00 00       	call   80104540 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 20 2a 00 00       	call   80104900 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 50 26 00 00       	call   80104580 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 f1 25 00 00       	call   80104540 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 0e 26 00 00       	call   80104580 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 eb 25 00 00       	call   80104580 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 94 25 00 00       	call   80104540 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 df 75 10 80       	push   $0x801075df
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 7e 29 00 00       	call   801049c0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 08 76 10 80       	push   $0x80107608
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 de 7b 10 80       	push   $0x80107bde
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 74 76 10 80       	push   $0x80107674
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 6b 76 10 80       	push   $0x8010766b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 86 76 10 80       	push   $0x80107686
801021cb:	68 00 16 11 80       	push   $0x80111600
801021d0:	e8 fb 23 00 00       	call   801045d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 97 14 80       	mov    0x80149784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 16 11 80       	push   $0x80111600
8010224e:	e8 4d 25 00 00       	call   801047a0 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 4e 20 00 00       	call   80104300 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 16 11 80       	push   $0x80111600
801022cb:	e8 70 24 00 00       	call   80104740 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 8d 22 00 00       	call   80104580 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 16 11 80       	push   $0x80111600
80102328:	e8 73 24 00 00       	call   801047a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 16 11 80       	push   $0x80111600
80102368:	53                   	push   %ebx
80102369:	e8 d2 1e 00 00       	call   80104240 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 b5 23 00 00       	jmp    80104740 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 b5 76 10 80       	push   $0x801076b5
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 a0 76 10 80       	push   $0x801076a0
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 8a 76 10 80       	push   $0x8010768a
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 16 11 80    	mov    0x80111634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 97 14 80 	movzbl 0x80149780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 d4 76 10 80       	push   $0x801076d4
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	56                   	push   %esi
801024c4:	8b 75 08             	mov    0x8(%ebp),%esi
801024c7:	53                   	push   %ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024c8:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
801024ce:	0f 85 b9 00 00 00    	jne    8010258d <kfree+0xcd>
801024d4:	81 fe d0 d4 14 80    	cmp    $0x8014d4d0,%esi
801024da:	0f 82 ad 00 00 00    	jb     8010258d <kfree+0xcd>
801024e0:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
801024e6:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
801024ec:	0f 87 9b 00 00 00    	ja     8010258d <kfree+0xcd>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  //memset(v, 1, PGSIZE);

  if(kmem.use_lock)
801024f2:	8b 15 74 16 11 80    	mov    0x80111674,%edx
801024f8:	85 d2                	test   %edx,%edx
801024fa:	75 7c                	jne    80102578 <kfree+0xb8>
    acquire(&kmem.lock);

  if(kmem.pgref[V2P(v) >> PTXSHIFT] > 0)
801024fc:	c1 eb 0c             	shr    $0xc,%ebx
801024ff:	83 c3 10             	add    $0x10,%ebx
80102502:	8b 04 9d 40 16 11 80 	mov    -0x7feee9c0(,%ebx,4),%eax
80102509:	85 c0                	test   %eax,%eax
8010250b:	74 23                	je     80102530 <kfree+0x70>
	kmem.pgref[V2P(v) >> PTXSHIFT]--;
8010250d:	83 e8 01             	sub    $0x1,%eax
80102510:	89 04 9d 40 16 11 80 	mov    %eax,-0x7feee9c0(,%ebx,4)
  if(kmem.pgref[V2P(v) >> PTXSHIFT] == 0){
80102517:	74 17                	je     80102530 <kfree+0x70>
  	r = (struct run*)v;
  	r->next = kmem.freelist;
  	kmem.freelist = r;
	kmem.num_free++;
  }
  if(kmem.use_lock)
80102519:	a1 74 16 11 80       	mov    0x80111674,%eax
8010251e:	85 c0                	test   %eax,%eax
80102520:	75 3e                	jne    80102560 <kfree+0xa0>
    release(&kmem.lock);
}
80102522:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102525:	5b                   	pop    %ebx
80102526:	5e                   	pop    %esi
80102527:	5d                   	pop    %ebp
80102528:	c3                   	ret    
80102529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	memset(v, 1, PGSIZE);
80102530:	83 ec 04             	sub    $0x4,%esp
80102533:	68 00 10 00 00       	push   $0x1000
80102538:	6a 01                	push   $0x1
8010253a:	56                   	push   %esi
8010253b:	e8 20 23 00 00       	call   80104860 <memset>
  	r->next = kmem.freelist;
80102540:	a1 78 16 11 80       	mov    0x80111678,%eax
	kmem.num_free++;
80102545:	83 c4 10             	add    $0x10,%esp
  	r->next = kmem.freelist;
80102548:	89 06                	mov    %eax,(%esi)
  if(kmem.use_lock)
8010254a:	a1 74 16 11 80       	mov    0x80111674,%eax
	kmem.num_free++;
8010254f:	83 05 7c 16 11 80 01 	addl   $0x1,0x8011167c
  	kmem.freelist = r;
80102556:	89 35 78 16 11 80    	mov    %esi,0x80111678
  if(kmem.use_lock)
8010255c:	85 c0                	test   %eax,%eax
8010255e:	74 c2                	je     80102522 <kfree+0x62>
    release(&kmem.lock);
80102560:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
80102567:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010256a:	5b                   	pop    %ebx
8010256b:	5e                   	pop    %esi
8010256c:	5d                   	pop    %ebp
    release(&kmem.lock);
8010256d:	e9 ce 21 00 00       	jmp    80104740 <release>
80102572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102578:	83 ec 0c             	sub    $0xc,%esp
8010257b:	68 40 16 11 80       	push   $0x80111640
80102580:	e8 1b 22 00 00       	call   801047a0 <acquire>
80102585:	83 c4 10             	add    $0x10,%esp
80102588:	e9 6f ff ff ff       	jmp    801024fc <kfree+0x3c>
    panic("kfree");
8010258d:	83 ec 0c             	sub    $0xc,%esp
80102590:	68 06 77 10 80       	push   $0x80107706
80102595:	e8 e6 dd ff ff       	call   80100380 <panic>
8010259a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801025a0 <freerange>:
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025a4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025a7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025aa:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801025b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025bd:	39 de                	cmp    %ebx,%esi
801025bf:	72 37                	jb     801025f8 <freerange+0x58>
801025c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	kmem.pgref[V2P(p) >> PTXSHIFT] = 0;
801025c8:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kfree(p);
801025ce:	83 ec 0c             	sub    $0xc,%esp
	kmem.pgref[V2P(p) >> PTXSHIFT] = 0;
801025d1:	c1 e8 0c             	shr    $0xc,%eax
801025d4:	c7 04 85 80 16 11 80 	movl   $0x0,-0x7feee980(,%eax,4)
801025db:	00 00 00 00 
    kfree(p);
801025df:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801025e5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025eb:	50                   	push   %eax
801025ec:	e8 cf fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801025f1:	83 c4 10             	add    $0x10,%esp
801025f4:	39 f3                	cmp    %esi,%ebx
801025f6:	76 d0                	jbe    801025c8 <freerange+0x28>
}
801025f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025fb:	5b                   	pop    %ebx
801025fc:	5e                   	pop    %esi
801025fd:	5d                   	pop    %ebp
801025fe:	c3                   	ret    
801025ff:	90                   	nop

80102600 <kinit2>:
{
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102604:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102607:	8b 75 0c             	mov    0xc(%ebp),%esi
8010260a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010260b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102611:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102617:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010261d:	39 de                	cmp    %ebx,%esi
8010261f:	72 37                	jb     80102658 <kinit2+0x58>
80102621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	kmem.pgref[V2P(p) >> PTXSHIFT] = 0;
80102628:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kfree(p);
8010262e:	83 ec 0c             	sub    $0xc,%esp
	kmem.pgref[V2P(p) >> PTXSHIFT] = 0;
80102631:	c1 e8 0c             	shr    $0xc,%eax
80102634:	c7 04 85 80 16 11 80 	movl   $0x0,-0x7feee980(,%eax,4)
8010263b:	00 00 00 00 
    kfree(p);
8010263f:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102645:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010264b:	50                   	push   %eax
8010264c:	e8 6f fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102651:	83 c4 10             	add    $0x10,%esp
80102654:	39 de                	cmp    %ebx,%esi
80102656:	73 d0                	jae    80102628 <kinit2+0x28>
  kmem.use_lock = 1;
80102658:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010265f:	00 00 00 
}
80102662:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102665:	5b                   	pop    %ebx
80102666:	5e                   	pop    %esi
80102667:	5d                   	pop    %ebp
80102668:	c3                   	ret    
80102669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102670 <kinit1>:
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	56                   	push   %esi
80102674:	53                   	push   %ebx
80102675:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102678:	83 ec 08             	sub    $0x8,%esp
8010267b:	68 0c 77 10 80       	push   $0x8010770c
80102680:	68 40 16 11 80       	push   $0x80111640
80102685:	e8 46 1f 00 00       	call   801045d0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010268a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010268d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102690:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102697:	00 00 00 
  kmem.num_free = 0;
8010269a:	c7 05 7c 16 11 80 00 	movl   $0x0,0x8011167c
801026a1:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026a4:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026aa:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801026b0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026b6:	39 de                	cmp    %ebx,%esi
801026b8:	72 36                	jb     801026f0 <kinit1+0x80>
801026ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	kmem.pgref[V2P(p) >> PTXSHIFT] = 0;
801026c0:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kfree(p);
801026c6:	83 ec 0c             	sub    $0xc,%esp
	kmem.pgref[V2P(p) >> PTXSHIFT] = 0;
801026c9:	c1 e8 0c             	shr    $0xc,%eax
801026cc:	c7 04 85 80 16 11 80 	movl   $0x0,-0x7feee980(,%eax,4)
801026d3:	00 00 00 00 
    kfree(p);
801026d7:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801026dd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026e3:	50                   	push   %eax
801026e4:	e8 d7 fd ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801026e9:	83 c4 10             	add    $0x10,%esp
801026ec:	39 de                	cmp    %ebx,%esi
801026ee:	73 d0                	jae    801026c0 <kinit1+0x50>
}
801026f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026f3:	5b                   	pop    %ebx
801026f4:	5e                   	pop    %esi
801026f5:	5d                   	pop    %ebp
801026f6:	c3                   	ret    
801026f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026fe:	66 90                	xchg   %ax,%ax

80102700 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102700:	a1 74 16 11 80       	mov    0x80111674,%eax
80102705:	85 c0                	test   %eax,%eax
80102707:	75 2f                	jne    80102738 <kalloc+0x38>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102709:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r){
8010270e:	85 c0                	test   %eax,%eax
80102710:	74 1e                	je     80102730 <kalloc+0x30>
	kmem.pgref[V2P((uint)r) >> PTXSHIFT] = 1;
80102712:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80102718:	c1 ea 0c             	shr    $0xc,%edx
8010271b:	c7 04 95 80 16 11 80 	movl   $0x1,-0x7feee980(,%edx,4)
80102722:	01 00 00 00 
    kmem.freelist = r->next;
80102726:	8b 10                	mov    (%eax),%edx
80102728:	89 15 78 16 11 80    	mov    %edx,0x80111678
  }
  if(kmem.use_lock)
8010272e:	c3                   	ret    
8010272f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102730:	c3                   	ret    
80102731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102738:	55                   	push   %ebp
80102739:	89 e5                	mov    %esp,%ebp
8010273b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010273e:	68 40 16 11 80       	push   $0x80111640
80102743:	e8 58 20 00 00       	call   801047a0 <acquire>
  r = kmem.freelist;
80102748:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
8010274d:	8b 0d 74 16 11 80    	mov    0x80111674,%ecx
  if(r){
80102753:	83 c4 10             	add    $0x10,%esp
80102756:	85 c0                	test   %eax,%eax
80102758:	74 1c                	je     80102776 <kalloc+0x76>
	kmem.pgref[V2P((uint)r) >> PTXSHIFT] = 1;
8010275a:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80102760:	c1 ea 0c             	shr    $0xc,%edx
80102763:	c7 04 95 80 16 11 80 	movl   $0x1,-0x7feee980(,%edx,4)
8010276a:	01 00 00 00 
    kmem.freelist = r->next;
8010276e:	8b 10                	mov    (%eax),%edx
80102770:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
80102776:	85 c9                	test   %ecx,%ecx
80102778:	74 16                	je     80102790 <kalloc+0x90>
    release(&kmem.lock);
8010277a:	83 ec 0c             	sub    $0xc,%esp
8010277d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102780:	68 40 16 11 80       	push   $0x80111640
80102785:	e8 b6 1f 00 00       	call   80104740 <release>
  return (char*)r;
8010278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
8010278d:	83 c4 10             	add    $0x10,%esp
}
80102790:	c9                   	leave  
80102791:	c3                   	ret    
80102792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801027a0 <incr_refc>:

void
incr_refc(uint pa)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	53                   	push   %ebx
801027a4:	83 ec 04             	sub    $0x4,%esp
  if(kmem.use_lock)
801027a7:	8b 15 74 16 11 80    	mov    0x80111674,%edx
{
801027ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
801027b0:	85 d2                	test   %edx,%edx
801027b2:	75 1c                	jne    801027d0 <incr_refc+0x30>
	acquire(&kmem.lock);
  kmem.pgref[pa >> PTXSHIFT]++;
801027b4:	89 d8                	mov    %ebx,%eax
801027b6:	c1 e8 0c             	shr    $0xc,%eax
801027b9:	83 04 85 80 16 11 80 	addl   $0x1,-0x7feee980(,%eax,4)
801027c0:	01 
  if(kmem.use_lock)
	release(&kmem.lock);
}
801027c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027c4:	c9                   	leave  
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi
	acquire(&kmem.lock);
801027d0:	83 ec 0c             	sub    $0xc,%esp
801027d3:	68 40 16 11 80       	push   $0x80111640
801027d8:	e8 c3 1f 00 00       	call   801047a0 <acquire>
  kmem.pgref[pa >> PTXSHIFT]++;
801027dd:	89 d8                	mov    %ebx,%eax
  if(kmem.use_lock)
801027df:	83 c4 10             	add    $0x10,%esp
  kmem.pgref[pa >> PTXSHIFT]++;
801027e2:	c1 e8 0c             	shr    $0xc,%eax
801027e5:	83 04 85 80 16 11 80 	addl   $0x1,-0x7feee980(,%eax,4)
801027ec:	01 
  if(kmem.use_lock)
801027ed:	a1 74 16 11 80       	mov    0x80111674,%eax
801027f2:	85 c0                	test   %eax,%eax
801027f4:	74 cb                	je     801027c1 <incr_refc+0x21>
	release(&kmem.lock);
801027f6:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
801027fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102800:	c9                   	leave  
	release(&kmem.lock);
80102801:	e9 3a 1f 00 00       	jmp    80104740 <release>
80102806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010280d:	8d 76 00             	lea    0x0(%esi),%esi

80102810 <decr_refc>:

void
decr_refc(uint pa)
{
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
80102813:	53                   	push   %ebx
80102814:	83 ec 04             	sub    $0x4,%esp
  if(kmem.use_lock)
80102817:	8b 15 74 16 11 80    	mov    0x80111674,%edx
{
8010281d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102820:	85 d2                	test   %edx,%edx
80102822:	75 1c                	jne    80102840 <decr_refc+0x30>
	acquire(&kmem.lock);
  kmem.pgref[pa >> PTXSHIFT]--;
80102824:	89 d8                	mov    %ebx,%eax
80102826:	c1 e8 0c             	shr    $0xc,%eax
80102829:	83 2c 85 80 16 11 80 	subl   $0x1,-0x7feee980(,%eax,4)
80102830:	01 
  if(kmem.use_lock)
	release(&kmem.lock);
}
80102831:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102834:	c9                   	leave  
80102835:	c3                   	ret    
80102836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010283d:	8d 76 00             	lea    0x0(%esi),%esi
	acquire(&kmem.lock);
80102840:	83 ec 0c             	sub    $0xc,%esp
80102843:	68 40 16 11 80       	push   $0x80111640
80102848:	e8 53 1f 00 00       	call   801047a0 <acquire>
  kmem.pgref[pa >> PTXSHIFT]--;
8010284d:	89 d8                	mov    %ebx,%eax
  if(kmem.use_lock)
8010284f:	83 c4 10             	add    $0x10,%esp
  kmem.pgref[pa >> PTXSHIFT]--;
80102852:	c1 e8 0c             	shr    $0xc,%eax
80102855:	83 2c 85 80 16 11 80 	subl   $0x1,-0x7feee980(,%eax,4)
8010285c:	01 
  if(kmem.use_lock)
8010285d:	a1 74 16 11 80       	mov    0x80111674,%eax
80102862:	85 c0                	test   %eax,%eax
80102864:	74 cb                	je     80102831 <decr_refc+0x21>
	release(&kmem.lock);
80102866:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010286d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102870:	c9                   	leave  
	release(&kmem.lock);
80102871:	e9 ca 1e 00 00       	jmp    80104740 <release>
80102876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010287d:	8d 76 00             	lea    0x0(%esi),%esi

80102880 <get_refc>:

int
get_refc(uint pa)
{
80102880:	55                   	push   %ebp
80102881:	89 e5                	mov    %esp,%ebp
80102883:	53                   	push   %ebx
80102884:	83 ec 14             	sub    $0x14,%esp
  int ret = 0;
  if(kmem.use_lock)
	acquire(&kmem.lock);
  ret = kmem.pgref[pa >> PTXSHIFT];
80102887:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
8010288a:	8b 0d 74 16 11 80    	mov    0x80111674,%ecx
  ret = kmem.pgref[pa >> PTXSHIFT];
80102890:	c1 eb 0c             	shr    $0xc,%ebx
  if(kmem.use_lock)
80102893:	85 c9                	test   %ecx,%ecx
80102895:	75 11                	jne    801028a8 <get_refc+0x28>
  ret = kmem.pgref[pa >> PTXSHIFT];
80102897:	8b 04 9d 80 16 11 80 	mov    -0x7feee980(,%ebx,4),%eax
  if(kmem.use_lock)
	release(&kmem.lock);
  return ret;
}
8010289e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028a1:	c9                   	leave  
801028a2:	c3                   	ret    
801028a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028a7:	90                   	nop
	acquire(&kmem.lock);
801028a8:	83 ec 0c             	sub    $0xc,%esp
801028ab:	68 40 16 11 80       	push   $0x80111640
801028b0:	e8 eb 1e 00 00       	call   801047a0 <acquire>
  if(kmem.use_lock)
801028b5:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  ret = kmem.pgref[pa >> PTXSHIFT];
801028bb:	8b 04 9d 80 16 11 80 	mov    -0x7feee980(,%ebx,4),%eax
  if(kmem.use_lock)
801028c2:	83 c4 10             	add    $0x10,%esp
801028c5:	85 d2                	test   %edx,%edx
801028c7:	74 d5                	je     8010289e <get_refc+0x1e>
	release(&kmem.lock);
801028c9:	83 ec 0c             	sub    $0xc,%esp
801028cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028cf:	68 40 16 11 80       	push   $0x80111640
801028d4:	e8 67 1e 00 00       	call   80104740 <release>
  return ret;
801028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801028dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
	release(&kmem.lock);
801028df:	83 c4 10             	add    $0x10,%esp
}
801028e2:	c9                   	leave  
801028e3:	c3                   	ret    
801028e4:	66 90                	xchg   %ax,%ax
801028e6:	66 90                	xchg   %ax,%ax
801028e8:	66 90                	xchg   %ax,%ax
801028ea:	66 90                	xchg   %ax,%ax
801028ec:	66 90                	xchg   %ax,%ax
801028ee:	66 90                	xchg   %ax,%ax

801028f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f0:	ba 64 00 00 00       	mov    $0x64,%edx
801028f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028f6:	a8 01                	test   $0x1,%al
801028f8:	0f 84 c2 00 00 00    	je     801029c0 <kbdgetc+0xd0>
{
801028fe:	55                   	push   %ebp
801028ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102904:	89 e5                	mov    %esp,%ebp
80102906:	53                   	push   %ebx
80102907:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102908:	8b 1d 80 96 14 80    	mov    0x80149680,%ebx
  data = inb(KBDATAP);
8010290e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102911:	3c e0                	cmp    $0xe0,%al
80102913:	74 5b                	je     80102970 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102915:	89 da                	mov    %ebx,%edx
80102917:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010291a:	84 c0                	test   %al,%al
8010291c:	78 62                	js     80102980 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010291e:	85 d2                	test   %edx,%edx
80102920:	74 09                	je     8010292b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102922:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102925:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102928:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010292b:	0f b6 91 40 78 10 80 	movzbl -0x7fef87c0(%ecx),%edx
  shift ^= togglecode[data];
80102932:	0f b6 81 40 77 10 80 	movzbl -0x7fef88c0(%ecx),%eax
  shift |= shiftcode[data];
80102939:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010293b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010293d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010293f:	89 15 80 96 14 80    	mov    %edx,0x80149680
  c = charcode[shift & (CTL | SHIFT)][data];
80102945:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102948:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010294b:	8b 04 85 20 77 10 80 	mov    -0x7fef88e0(,%eax,4),%eax
80102952:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102956:	74 0b                	je     80102963 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102958:	8d 50 9f             	lea    -0x61(%eax),%edx
8010295b:	83 fa 19             	cmp    $0x19,%edx
8010295e:	77 48                	ja     801029a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102960:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102963:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102966:	c9                   	leave  
80102967:	c3                   	ret    
80102968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010296f:	90                   	nop
    shift |= E0ESC;
80102970:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102973:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102975:	89 1d 80 96 14 80    	mov    %ebx,0x80149680
}
8010297b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010297e:	c9                   	leave  
8010297f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102980:	83 e0 7f             	and    $0x7f,%eax
80102983:	85 d2                	test   %edx,%edx
80102985:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102988:	0f b6 81 40 78 10 80 	movzbl -0x7fef87c0(%ecx),%eax
8010298f:	83 c8 40             	or     $0x40,%eax
80102992:	0f b6 c0             	movzbl %al,%eax
80102995:	f7 d0                	not    %eax
80102997:	21 d8                	and    %ebx,%eax
}
80102999:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010299c:	a3 80 96 14 80       	mov    %eax,0x80149680
    return 0;
801029a1:	31 c0                	xor    %eax,%eax
}
801029a3:	c9                   	leave  
801029a4:	c3                   	ret    
801029a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801029a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801029ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801029ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029b1:	c9                   	leave  
      c += 'a' - 'A';
801029b2:	83 f9 1a             	cmp    $0x1a,%ecx
801029b5:	0f 42 c2             	cmovb  %edx,%eax
}
801029b8:	c3                   	ret    
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801029c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801029c5:	c3                   	ret    
801029c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029cd:	8d 76 00             	lea    0x0(%esi),%esi

801029d0 <kbdintr>:

void
kbdintr(void)
{
801029d0:	55                   	push   %ebp
801029d1:	89 e5                	mov    %esp,%ebp
801029d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029d6:	68 f0 28 10 80       	push   $0x801028f0
801029db:	e8 a0 de ff ff       	call   80100880 <consoleintr>
}
801029e0:	83 c4 10             	add    $0x10,%esp
801029e3:	c9                   	leave  
801029e4:	c3                   	ret    
801029e5:	66 90                	xchg   %ax,%ax
801029e7:	66 90                	xchg   %ax,%ax
801029e9:	66 90                	xchg   %ax,%ax
801029eb:	66 90                	xchg   %ax,%ax
801029ed:	66 90                	xchg   %ax,%ax
801029ef:	90                   	nop

801029f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029f0:	a1 84 96 14 80       	mov    0x80149684,%eax
801029f5:	85 c0                	test   %eax,%eax
801029f7:	0f 84 cb 00 00 00    	je     80102ac8 <lapicinit+0xd8>
  lapic[index] = value;
801029fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a04:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a07:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a0a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a11:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a14:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a17:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a1e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a21:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a24:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a2b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a31:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a38:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a3e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a45:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a48:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a4b:	8b 50 30             	mov    0x30(%eax),%edx
80102a4e:	c1 ea 10             	shr    $0x10,%edx
80102a51:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102a57:	75 77                	jne    80102ad0 <lapicinit+0xe0>
  lapic[index] = value;
80102a59:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a60:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a63:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a66:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a6d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a70:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a73:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a7a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a7d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a80:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a87:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a8a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a8d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a94:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a97:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a9a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102aa1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa4:	8b 50 20             	mov    0x20(%eax),%edx
80102aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102ab0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102ab6:	80 e6 10             	and    $0x10,%dh
80102ab9:	75 f5                	jne    80102ab0 <lapicinit+0xc0>
  lapic[index] = value;
80102abb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102ac2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102ac8:	c3                   	ret    
80102ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102ad0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102ad7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ada:	8b 50 20             	mov    0x20(%eax),%edx
}
80102add:	e9 77 ff ff ff       	jmp    80102a59 <lapicinit+0x69>
80102ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102af0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102af0:	a1 84 96 14 80       	mov    0x80149684,%eax
80102af5:	85 c0                	test   %eax,%eax
80102af7:	74 07                	je     80102b00 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102af9:	8b 40 20             	mov    0x20(%eax),%eax
80102afc:	c1 e8 18             	shr    $0x18,%eax
80102aff:	c3                   	ret    
    return 0;
80102b00:	31 c0                	xor    %eax,%eax
}
80102b02:	c3                   	ret    
80102b03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b10 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102b10:	a1 84 96 14 80       	mov    0x80149684,%eax
80102b15:	85 c0                	test   %eax,%eax
80102b17:	74 0d                	je     80102b26 <lapiceoi+0x16>
  lapic[index] = value;
80102b19:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b20:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b23:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102b26:	c3                   	ret    
80102b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b2e:	66 90                	xchg   %ax,%ax

80102b30 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102b30:	c3                   	ret    
80102b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b3f:	90                   	nop

80102b40 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b40:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b41:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b46:	ba 70 00 00 00       	mov    $0x70,%edx
80102b4b:	89 e5                	mov    %esp,%ebp
80102b4d:	53                   	push   %ebx
80102b4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b51:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b54:	ee                   	out    %al,(%dx)
80102b55:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b5a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b5f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b60:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b62:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b65:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b6b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b6d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102b70:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b72:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b75:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b78:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b7e:	a1 84 96 14 80       	mov    0x80149684,%eax
80102b83:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b89:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b8c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b93:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b96:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b99:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ba0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ba6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102baf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bb5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bb8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bbe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bc1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bc7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102bca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bcd:	c9                   	leave  
80102bce:	c3                   	ret    
80102bcf:	90                   	nop

80102bd0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102bd0:	55                   	push   %ebp
80102bd1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102bd6:	ba 70 00 00 00       	mov    $0x70,%edx
80102bdb:	89 e5                	mov    %esp,%ebp
80102bdd:	57                   	push   %edi
80102bde:	56                   	push   %esi
80102bdf:	53                   	push   %ebx
80102be0:	83 ec 4c             	sub    $0x4c,%esp
80102be3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102be4:	ba 71 00 00 00       	mov    $0x71,%edx
80102be9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102bea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bed:	bb 70 00 00 00       	mov    $0x70,%ebx
80102bf2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102bf5:	8d 76 00             	lea    0x0(%esi),%esi
80102bf8:	31 c0                	xor    %eax,%eax
80102bfa:	89 da                	mov    %ebx,%edx
80102bfc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c02:	89 ca                	mov    %ecx,%edx
80102c04:	ec                   	in     (%dx),%al
80102c05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c08:	89 da                	mov    %ebx,%edx
80102c0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102c0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c10:	89 ca                	mov    %ecx,%edx
80102c12:	ec                   	in     (%dx),%al
80102c13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c16:	89 da                	mov    %ebx,%edx
80102c18:	b8 04 00 00 00       	mov    $0x4,%eax
80102c1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1e:	89 ca                	mov    %ecx,%edx
80102c20:	ec                   	in     (%dx),%al
80102c21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c24:	89 da                	mov    %ebx,%edx
80102c26:	b8 07 00 00 00       	mov    $0x7,%eax
80102c2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2c:	89 ca                	mov    %ecx,%edx
80102c2e:	ec                   	in     (%dx),%al
80102c2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c32:	89 da                	mov    %ebx,%edx
80102c34:	b8 08 00 00 00       	mov    $0x8,%eax
80102c39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3a:	89 ca                	mov    %ecx,%edx
80102c3c:	ec                   	in     (%dx),%al
80102c3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c3f:	89 da                	mov    %ebx,%edx
80102c41:	b8 09 00 00 00       	mov    $0x9,%eax
80102c46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c47:	89 ca                	mov    %ecx,%edx
80102c49:	ec                   	in     (%dx),%al
80102c4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c4c:	89 da                	mov    %ebx,%edx
80102c4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c54:	89 ca                	mov    %ecx,%edx
80102c56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c57:	84 c0                	test   %al,%al
80102c59:	78 9d                	js     80102bf8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c5f:	89 fa                	mov    %edi,%edx
80102c61:	0f b6 fa             	movzbl %dl,%edi
80102c64:	89 f2                	mov    %esi,%edx
80102c66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c70:	89 da                	mov    %ebx,%edx
80102c72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102c75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c89:	31 c0                	xor    %eax,%eax
80102c8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8c:	89 ca                	mov    %ecx,%edx
80102c8e:	ec                   	in     (%dx),%al
80102c8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c92:	89 da                	mov    %ebx,%edx
80102c94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c97:	b8 02 00 00 00       	mov    $0x2,%eax
80102c9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9d:	89 ca                	mov    %ecx,%edx
80102c9f:	ec                   	in     (%dx),%al
80102ca0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca3:	89 da                	mov    %ebx,%edx
80102ca5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ca8:	b8 04 00 00 00       	mov    $0x4,%eax
80102cad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cae:	89 ca                	mov    %ecx,%edx
80102cb0:	ec                   	in     (%dx),%al
80102cb1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb4:	89 da                	mov    %ebx,%edx
80102cb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102cb9:	b8 07 00 00 00       	mov    $0x7,%eax
80102cbe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cbf:	89 ca                	mov    %ecx,%edx
80102cc1:	ec                   	in     (%dx),%al
80102cc2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cc5:	89 da                	mov    %ebx,%edx
80102cc7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102cca:	b8 08 00 00 00       	mov    $0x8,%eax
80102ccf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cd0:	89 ca                	mov    %ecx,%edx
80102cd2:	ec                   	in     (%dx),%al
80102cd3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd6:	89 da                	mov    %ebx,%edx
80102cd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102cdb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ce0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ce1:	89 ca                	mov    %ecx,%edx
80102ce3:	ec                   	in     (%dx),%al
80102ce4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ce7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102cea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ced:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102cf0:	6a 18                	push   $0x18
80102cf2:	50                   	push   %eax
80102cf3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102cf6:	50                   	push   %eax
80102cf7:	e8 b4 1b 00 00       	call   801048b0 <memcmp>
80102cfc:	83 c4 10             	add    $0x10,%esp
80102cff:	85 c0                	test   %eax,%eax
80102d01:	0f 85 f1 fe ff ff    	jne    80102bf8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102d07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102d0b:	75 78                	jne    80102d85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d10:	89 c2                	mov    %eax,%edx
80102d12:	83 e0 0f             	and    $0xf,%eax
80102d15:	c1 ea 04             	shr    $0x4,%edx
80102d18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d24:	89 c2                	mov    %eax,%edx
80102d26:	83 e0 0f             	and    $0xf,%eax
80102d29:	c1 ea 04             	shr    $0x4,%edx
80102d2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d38:	89 c2                	mov    %eax,%edx
80102d3a:	83 e0 0f             	and    $0xf,%eax
80102d3d:	c1 ea 04             	shr    $0x4,%edx
80102d40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d4c:	89 c2                	mov    %eax,%edx
80102d4e:	83 e0 0f             	and    $0xf,%eax
80102d51:	c1 ea 04             	shr    $0x4,%edx
80102d54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d60:	89 c2                	mov    %eax,%edx
80102d62:	83 e0 0f             	and    $0xf,%eax
80102d65:	c1 ea 04             	shr    $0x4,%edx
80102d68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d74:	89 c2                	mov    %eax,%edx
80102d76:	83 e0 0f             	and    $0xf,%eax
80102d79:	c1 ea 04             	shr    $0x4,%edx
80102d7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d85:	8b 75 08             	mov    0x8(%ebp),%esi
80102d88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d8b:	89 06                	mov    %eax,(%esi)
80102d8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d90:	89 46 04             	mov    %eax,0x4(%esi)
80102d93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d96:	89 46 08             	mov    %eax,0x8(%esi)
80102d99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102d9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102da2:	89 46 10             	mov    %eax,0x10(%esi)
80102da5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102da8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102dab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102db5:	5b                   	pop    %ebx
80102db6:	5e                   	pop    %esi
80102db7:	5f                   	pop    %edi
80102db8:	5d                   	pop    %ebp
80102db9:	c3                   	ret    
80102dba:	66 90                	xchg   %ax,%ax
80102dbc:	66 90                	xchg   %ax,%ax
80102dbe:	66 90                	xchg   %ax,%ax

80102dc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102dc0:	8b 0d e8 96 14 80    	mov    0x801496e8,%ecx
80102dc6:	85 c9                	test   %ecx,%ecx
80102dc8:	0f 8e 8a 00 00 00    	jle    80102e58 <install_trans+0x98>
{
80102dce:	55                   	push   %ebp
80102dcf:	89 e5                	mov    %esp,%ebp
80102dd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102dd2:	31 ff                	xor    %edi,%edi
{
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 0c             	sub    $0xc,%esp
80102dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102de0:	a1 d4 96 14 80       	mov    0x801496d4,%eax
80102de5:	83 ec 08             	sub    $0x8,%esp
80102de8:	01 f8                	add    %edi,%eax
80102dea:	83 c0 01             	add    $0x1,%eax
80102ded:	50                   	push   %eax
80102dee:	ff 35 e4 96 14 80    	push   0x801496e4
80102df4:	e8 d7 d2 ff ff       	call   801000d0 <bread>
80102df9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dfb:	58                   	pop    %eax
80102dfc:	5a                   	pop    %edx
80102dfd:	ff 34 bd ec 96 14 80 	push   -0x7feb6914(,%edi,4)
80102e04:	ff 35 e4 96 14 80    	push   0x801496e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e0d:	e8 be d2 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e1a:	68 00 02 00 00       	push   $0x200
80102e1f:	50                   	push   %eax
80102e20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102e23:	50                   	push   %eax
80102e24:	e8 d7 1a 00 00       	call   80104900 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e29:	89 1c 24             	mov    %ebx,(%esp)
80102e2c:	e8 7f d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102e31:	89 34 24             	mov    %esi,(%esp)
80102e34:	e8 b7 d3 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102e39:	89 1c 24             	mov    %ebx,(%esp)
80102e3c:	e8 af d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e41:	83 c4 10             	add    $0x10,%esp
80102e44:	39 3d e8 96 14 80    	cmp    %edi,0x801496e8
80102e4a:	7f 94                	jg     80102de0 <install_trans+0x20>
  }
}
80102e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e4f:	5b                   	pop    %ebx
80102e50:	5e                   	pop    %esi
80102e51:	5f                   	pop    %edi
80102e52:	5d                   	pop    %ebp
80102e53:	c3                   	ret    
80102e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e58:	c3                   	ret    
80102e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	53                   	push   %ebx
80102e64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e67:	ff 35 d4 96 14 80    	push   0x801496d4
80102e6d:	ff 35 e4 96 14 80    	push   0x801496e4
80102e73:	e8 58 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e7d:	a1 e8 96 14 80       	mov    0x801496e8,%eax
80102e82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102e85:	85 c0                	test   %eax,%eax
80102e87:	7e 19                	jle    80102ea2 <write_head+0x42>
80102e89:	31 d2                	xor    %edx,%edx
80102e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102e90:	8b 0c 95 ec 96 14 80 	mov    -0x7feb6914(,%edx,4),%ecx
80102e97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e9b:	83 c2 01             	add    $0x1,%edx
80102e9e:	39 d0                	cmp    %edx,%eax
80102ea0:	75 ee                	jne    80102e90 <write_head+0x30>
  }
  bwrite(buf);
80102ea2:	83 ec 0c             	sub    $0xc,%esp
80102ea5:	53                   	push   %ebx
80102ea6:	e8 05 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102eab:	89 1c 24             	mov    %ebx,(%esp)
80102eae:	e8 3d d3 ff ff       	call   801001f0 <brelse>
}
80102eb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102eb6:	83 c4 10             	add    $0x10,%esp
80102eb9:	c9                   	leave  
80102eba:	c3                   	ret    
80102ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ebf:	90                   	nop

80102ec0 <initlog>:
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	53                   	push   %ebx
80102ec4:	83 ec 2c             	sub    $0x2c,%esp
80102ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102eca:	68 40 79 10 80       	push   $0x80107940
80102ecf:	68 a0 96 14 80       	push   $0x801496a0
80102ed4:	e8 f7 16 00 00       	call   801045d0 <initlock>
  readsb(dev, &sb);
80102ed9:	58                   	pop    %eax
80102eda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102edd:	5a                   	pop    %edx
80102ede:	50                   	push   %eax
80102edf:	53                   	push   %ebx
80102ee0:	e8 3b e6 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102ee5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ee8:	59                   	pop    %ecx
  log.dev = dev;
80102ee9:	89 1d e4 96 14 80    	mov    %ebx,0x801496e4
  log.size = sb.nlog;
80102eef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ef2:	a3 d4 96 14 80       	mov    %eax,0x801496d4
  log.size = sb.nlog;
80102ef7:	89 15 d8 96 14 80    	mov    %edx,0x801496d8
  struct buf *buf = bread(log.dev, log.start);
80102efd:	5a                   	pop    %edx
80102efe:	50                   	push   %eax
80102eff:	53                   	push   %ebx
80102f00:	e8 cb d1 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102f05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102f08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102f0b:	89 1d e8 96 14 80    	mov    %ebx,0x801496e8
  for (i = 0; i < log.lh.n; i++) {
80102f11:	85 db                	test   %ebx,%ebx
80102f13:	7e 1d                	jle    80102f32 <initlog+0x72>
80102f15:	31 d2                	xor    %edx,%edx
80102f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102f20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102f24:	89 0c 95 ec 96 14 80 	mov    %ecx,-0x7feb6914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f2b:	83 c2 01             	add    $0x1,%edx
80102f2e:	39 d3                	cmp    %edx,%ebx
80102f30:	75 ee                	jne    80102f20 <initlog+0x60>
  brelse(buf);
80102f32:	83 ec 0c             	sub    $0xc,%esp
80102f35:	50                   	push   %eax
80102f36:	e8 b5 d2 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f3b:	e8 80 fe ff ff       	call   80102dc0 <install_trans>
  log.lh.n = 0;
80102f40:	c7 05 e8 96 14 80 00 	movl   $0x0,0x801496e8
80102f47:	00 00 00 
  write_head(); // clear the log
80102f4a:	e8 11 ff ff ff       	call   80102e60 <write_head>
}
80102f4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f52:	83 c4 10             	add    $0x10,%esp
80102f55:	c9                   	leave  
80102f56:	c3                   	ret    
80102f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f5e:	66 90                	xchg   %ax,%ax

80102f60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f66:	68 a0 96 14 80       	push   $0x801496a0
80102f6b:	e8 30 18 00 00       	call   801047a0 <acquire>
80102f70:	83 c4 10             	add    $0x10,%esp
80102f73:	eb 18                	jmp    80102f8d <begin_op+0x2d>
80102f75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f78:	83 ec 08             	sub    $0x8,%esp
80102f7b:	68 a0 96 14 80       	push   $0x801496a0
80102f80:	68 a0 96 14 80       	push   $0x801496a0
80102f85:	e8 b6 12 00 00       	call   80104240 <sleep>
80102f8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f8d:	a1 e0 96 14 80       	mov    0x801496e0,%eax
80102f92:	85 c0                	test   %eax,%eax
80102f94:	75 e2                	jne    80102f78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f96:	a1 dc 96 14 80       	mov    0x801496dc,%eax
80102f9b:	8b 15 e8 96 14 80    	mov    0x801496e8,%edx
80102fa1:	83 c0 01             	add    $0x1,%eax
80102fa4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102fa7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102faa:	83 fa 1e             	cmp    $0x1e,%edx
80102fad:	7f c9                	jg     80102f78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102faf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102fb2:	a3 dc 96 14 80       	mov    %eax,0x801496dc
      release(&log.lock);
80102fb7:	68 a0 96 14 80       	push   $0x801496a0
80102fbc:	e8 7f 17 00 00       	call   80104740 <release>
      break;
    }
  }
}
80102fc1:	83 c4 10             	add    $0x10,%esp
80102fc4:	c9                   	leave  
80102fc5:	c3                   	ret    
80102fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fcd:	8d 76 00             	lea    0x0(%esi),%esi

80102fd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	57                   	push   %edi
80102fd4:	56                   	push   %esi
80102fd5:	53                   	push   %ebx
80102fd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102fd9:	68 a0 96 14 80       	push   $0x801496a0
80102fde:	e8 bd 17 00 00       	call   801047a0 <acquire>
  log.outstanding -= 1;
80102fe3:	a1 dc 96 14 80       	mov    0x801496dc,%eax
  if(log.committing)
80102fe8:	8b 35 e0 96 14 80    	mov    0x801496e0,%esi
80102fee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ff1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102ff4:	89 1d dc 96 14 80    	mov    %ebx,0x801496dc
  if(log.committing)
80102ffa:	85 f6                	test   %esi,%esi
80102ffc:	0f 85 22 01 00 00    	jne    80103124 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103002:	85 db                	test   %ebx,%ebx
80103004:	0f 85 f6 00 00 00    	jne    80103100 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010300a:	c7 05 e0 96 14 80 01 	movl   $0x1,0x801496e0
80103011:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103014:	83 ec 0c             	sub    $0xc,%esp
80103017:	68 a0 96 14 80       	push   $0x801496a0
8010301c:	e8 1f 17 00 00       	call   80104740 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103021:	8b 0d e8 96 14 80    	mov    0x801496e8,%ecx
80103027:	83 c4 10             	add    $0x10,%esp
8010302a:	85 c9                	test   %ecx,%ecx
8010302c:	7f 42                	jg     80103070 <end_op+0xa0>
    acquire(&log.lock);
8010302e:	83 ec 0c             	sub    $0xc,%esp
80103031:	68 a0 96 14 80       	push   $0x801496a0
80103036:	e8 65 17 00 00       	call   801047a0 <acquire>
    wakeup(&log);
8010303b:	c7 04 24 a0 96 14 80 	movl   $0x801496a0,(%esp)
    log.committing = 0;
80103042:	c7 05 e0 96 14 80 00 	movl   $0x0,0x801496e0
80103049:	00 00 00 
    wakeup(&log);
8010304c:	e8 af 12 00 00       	call   80104300 <wakeup>
    release(&log.lock);
80103051:	c7 04 24 a0 96 14 80 	movl   $0x801496a0,(%esp)
80103058:	e8 e3 16 00 00       	call   80104740 <release>
8010305d:	83 c4 10             	add    $0x10,%esp
}
80103060:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103063:	5b                   	pop    %ebx
80103064:	5e                   	pop    %esi
80103065:	5f                   	pop    %edi
80103066:	5d                   	pop    %ebp
80103067:	c3                   	ret    
80103068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010306f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103070:	a1 d4 96 14 80       	mov    0x801496d4,%eax
80103075:	83 ec 08             	sub    $0x8,%esp
80103078:	01 d8                	add    %ebx,%eax
8010307a:	83 c0 01             	add    $0x1,%eax
8010307d:	50                   	push   %eax
8010307e:	ff 35 e4 96 14 80    	push   0x801496e4
80103084:	e8 47 d0 ff ff       	call   801000d0 <bread>
80103089:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010308b:	58                   	pop    %eax
8010308c:	5a                   	pop    %edx
8010308d:	ff 34 9d ec 96 14 80 	push   -0x7feb6914(,%ebx,4)
80103094:	ff 35 e4 96 14 80    	push   0x801496e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010309a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010309d:	e8 2e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801030a2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030a5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801030a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801030aa:	68 00 02 00 00       	push   $0x200
801030af:	50                   	push   %eax
801030b0:	8d 46 5c             	lea    0x5c(%esi),%eax
801030b3:	50                   	push   %eax
801030b4:	e8 47 18 00 00       	call   80104900 <memmove>
    bwrite(to);  // write the log
801030b9:	89 34 24             	mov    %esi,(%esp)
801030bc:	e8 ef d0 ff ff       	call   801001b0 <bwrite>
    brelse(from);
801030c1:	89 3c 24             	mov    %edi,(%esp)
801030c4:	e8 27 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
801030c9:	89 34 24             	mov    %esi,(%esp)
801030cc:	e8 1f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030d1:	83 c4 10             	add    $0x10,%esp
801030d4:	3b 1d e8 96 14 80    	cmp    0x801496e8,%ebx
801030da:	7c 94                	jl     80103070 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030dc:	e8 7f fd ff ff       	call   80102e60 <write_head>
    install_trans(); // Now install writes to home locations
801030e1:	e8 da fc ff ff       	call   80102dc0 <install_trans>
    log.lh.n = 0;
801030e6:	c7 05 e8 96 14 80 00 	movl   $0x0,0x801496e8
801030ed:	00 00 00 
    write_head();    // Erase the transaction from the log
801030f0:	e8 6b fd ff ff       	call   80102e60 <write_head>
801030f5:	e9 34 ff ff ff       	jmp    8010302e <end_op+0x5e>
801030fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103100:	83 ec 0c             	sub    $0xc,%esp
80103103:	68 a0 96 14 80       	push   $0x801496a0
80103108:	e8 f3 11 00 00       	call   80104300 <wakeup>
  release(&log.lock);
8010310d:	c7 04 24 a0 96 14 80 	movl   $0x801496a0,(%esp)
80103114:	e8 27 16 00 00       	call   80104740 <release>
80103119:	83 c4 10             	add    $0x10,%esp
}
8010311c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010311f:	5b                   	pop    %ebx
80103120:	5e                   	pop    %esi
80103121:	5f                   	pop    %edi
80103122:	5d                   	pop    %ebp
80103123:	c3                   	ret    
    panic("log.committing");
80103124:	83 ec 0c             	sub    $0xc,%esp
80103127:	68 44 79 10 80       	push   $0x80107944
8010312c:	e8 4f d2 ff ff       	call   80100380 <panic>
80103131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010313f:	90                   	nop

80103140 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103140:	55                   	push   %ebp
80103141:	89 e5                	mov    %esp,%ebp
80103143:	53                   	push   %ebx
80103144:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103147:	8b 15 e8 96 14 80    	mov    0x801496e8,%edx
{
8010314d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103150:	83 fa 1d             	cmp    $0x1d,%edx
80103153:	0f 8f 85 00 00 00    	jg     801031de <log_write+0x9e>
80103159:	a1 d8 96 14 80       	mov    0x801496d8,%eax
8010315e:	83 e8 01             	sub    $0x1,%eax
80103161:	39 c2                	cmp    %eax,%edx
80103163:	7d 79                	jge    801031de <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103165:	a1 dc 96 14 80       	mov    0x801496dc,%eax
8010316a:	85 c0                	test   %eax,%eax
8010316c:	7e 7d                	jle    801031eb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010316e:	83 ec 0c             	sub    $0xc,%esp
80103171:	68 a0 96 14 80       	push   $0x801496a0
80103176:	e8 25 16 00 00       	call   801047a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010317b:	8b 15 e8 96 14 80    	mov    0x801496e8,%edx
80103181:	83 c4 10             	add    $0x10,%esp
80103184:	85 d2                	test   %edx,%edx
80103186:	7e 4a                	jle    801031d2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103188:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010318b:	31 c0                	xor    %eax,%eax
8010318d:	eb 08                	jmp    80103197 <log_write+0x57>
8010318f:	90                   	nop
80103190:	83 c0 01             	add    $0x1,%eax
80103193:	39 c2                	cmp    %eax,%edx
80103195:	74 29                	je     801031c0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103197:	39 0c 85 ec 96 14 80 	cmp    %ecx,-0x7feb6914(,%eax,4)
8010319e:	75 f0                	jne    80103190 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801031a0:	89 0c 85 ec 96 14 80 	mov    %ecx,-0x7feb6914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801031a7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801031aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801031ad:	c7 45 08 a0 96 14 80 	movl   $0x801496a0,0x8(%ebp)
}
801031b4:	c9                   	leave  
  release(&log.lock);
801031b5:	e9 86 15 00 00       	jmp    80104740 <release>
801031ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801031c0:	89 0c 95 ec 96 14 80 	mov    %ecx,-0x7feb6914(,%edx,4)
    log.lh.n++;
801031c7:	83 c2 01             	add    $0x1,%edx
801031ca:	89 15 e8 96 14 80    	mov    %edx,0x801496e8
801031d0:	eb d5                	jmp    801031a7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801031d2:	8b 43 08             	mov    0x8(%ebx),%eax
801031d5:	a3 ec 96 14 80       	mov    %eax,0x801496ec
  if (i == log.lh.n)
801031da:	75 cb                	jne    801031a7 <log_write+0x67>
801031dc:	eb e9                	jmp    801031c7 <log_write+0x87>
    panic("too big a transaction");
801031de:	83 ec 0c             	sub    $0xc,%esp
801031e1:	68 53 79 10 80       	push   $0x80107953
801031e6:	e8 95 d1 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801031eb:	83 ec 0c             	sub    $0xc,%esp
801031ee:	68 69 79 10 80       	push   $0x80107969
801031f3:	e8 88 d1 ff ff       	call   80100380 <panic>
801031f8:	66 90                	xchg   %ax,%ax
801031fa:	66 90                	xchg   %ax,%ax
801031fc:	66 90                	xchg   %ax,%ax
801031fe:	66 90                	xchg   %ax,%ax

80103200 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	53                   	push   %ebx
80103204:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103207:	e8 44 09 00 00       	call   80103b50 <cpuid>
8010320c:	89 c3                	mov    %eax,%ebx
8010320e:	e8 3d 09 00 00       	call   80103b50 <cpuid>
80103213:	83 ec 04             	sub    $0x4,%esp
80103216:	53                   	push   %ebx
80103217:	50                   	push   %eax
80103218:	68 84 79 10 80       	push   $0x80107984
8010321d:	e8 7e d4 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103222:	e8 b9 28 00 00       	call   80105ae0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103227:	e8 c4 08 00 00       	call   80103af0 <mycpu>
8010322c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010322e:	b8 01 00 00 00       	mov    $0x1,%eax
80103233:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010323a:	e8 f1 0b 00 00       	call   80103e30 <scheduler>
8010323f:	90                   	nop

80103240 <mpenter>:
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103246:	e8 a5 39 00 00       	call   80106bf0 <switchkvm>
  seginit();
8010324b:	e8 10 39 00 00       	call   80106b60 <seginit>
  lapicinit();
80103250:	e8 9b f7 ff ff       	call   801029f0 <lapicinit>
  mpmain();
80103255:	e8 a6 ff ff ff       	call   80103200 <mpmain>
8010325a:	66 90                	xchg   %ax,%ax
8010325c:	66 90                	xchg   %ax,%ax
8010325e:	66 90                	xchg   %ax,%ax

80103260 <main>:
{
80103260:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103264:	83 e4 f0             	and    $0xfffffff0,%esp
80103267:	ff 71 fc             	push   -0x4(%ecx)
8010326a:	55                   	push   %ebp
8010326b:	89 e5                	mov    %esp,%ebp
8010326d:	53                   	push   %ebx
8010326e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010326f:	83 ec 08             	sub    $0x8,%esp
80103272:	68 00 00 40 80       	push   $0x80400000
80103277:	68 d0 d4 14 80       	push   $0x8014d4d0
8010327c:	e8 ef f3 ff ff       	call   80102670 <kinit1>
  kvmalloc();      // kernel page table
80103281:	e8 5a 3e 00 00       	call   801070e0 <kvmalloc>
  mpinit();        // detect other processors
80103286:	e8 85 01 00 00       	call   80103410 <mpinit>
  lapicinit();     // interrupt controller
8010328b:	e8 60 f7 ff ff       	call   801029f0 <lapicinit>
  seginit();       // segment descriptors
80103290:	e8 cb 38 00 00       	call   80106b60 <seginit>
  picinit();       // disable pic
80103295:	e8 76 03 00 00       	call   80103610 <picinit>
  ioapicinit();    // another interrupt controller
8010329a:	e8 31 f1 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010329f:	e8 bc d7 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801032a4:	e8 47 2b 00 00       	call   80105df0 <uartinit>
  pinit();         // process table
801032a9:	e8 22 08 00 00       	call   80103ad0 <pinit>
  tvinit();        // trap vectors
801032ae:	e8 ad 27 00 00       	call   80105a60 <tvinit>
  binit();         // buffer cache
801032b3:	e8 88 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
801032b8:	e8 53 db ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801032bd:	e8 fe ee ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032c2:	83 c4 0c             	add    $0xc,%esp
801032c5:	68 8a 00 00 00       	push   $0x8a
801032ca:	68 8c a4 10 80       	push   $0x8010a48c
801032cf:	68 00 70 00 80       	push   $0x80007000
801032d4:	e8 27 16 00 00       	call   80104900 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032d9:	83 c4 10             	add    $0x10,%esp
801032dc:	69 05 84 97 14 80 b0 	imul   $0xb0,0x80149784,%eax
801032e3:	00 00 00 
801032e6:	05 a0 97 14 80       	add    $0x801497a0,%eax
801032eb:	3d a0 97 14 80       	cmp    $0x801497a0,%eax
801032f0:	76 7e                	jbe    80103370 <main+0x110>
801032f2:	bb a0 97 14 80       	mov    $0x801497a0,%ebx
801032f7:	eb 20                	jmp    80103319 <main+0xb9>
801032f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103300:	69 05 84 97 14 80 b0 	imul   $0xb0,0x80149784,%eax
80103307:	00 00 00 
8010330a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103310:	05 a0 97 14 80       	add    $0x801497a0,%eax
80103315:	39 c3                	cmp    %eax,%ebx
80103317:	73 57                	jae    80103370 <main+0x110>
    if(c == mycpu())  // We've started already.
80103319:	e8 d2 07 00 00       	call   80103af0 <mycpu>
8010331e:	39 c3                	cmp    %eax,%ebx
80103320:	74 de                	je     80103300 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103322:	e8 d9 f3 ff ff       	call   80102700 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103327:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010332a:	c7 05 f8 6f 00 80 40 	movl   $0x80103240,0x80006ff8
80103331:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103334:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010333b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010333e:	05 00 10 00 00       	add    $0x1000,%eax
80103343:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103348:	0f b6 03             	movzbl (%ebx),%eax
8010334b:	68 00 70 00 00       	push   $0x7000
80103350:	50                   	push   %eax
80103351:	e8 ea f7 ff ff       	call   80102b40 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103356:	83 c4 10             	add    $0x10,%esp
80103359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103360:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103366:	85 c0                	test   %eax,%eax
80103368:	74 f6                	je     80103360 <main+0x100>
8010336a:	eb 94                	jmp    80103300 <main+0xa0>
8010336c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103370:	83 ec 08             	sub    $0x8,%esp
80103373:	68 00 00 00 8e       	push   $0x8e000000
80103378:	68 00 00 40 80       	push   $0x80400000
8010337d:	e8 7e f2 ff ff       	call   80102600 <kinit2>
  userinit();      // first user process
80103382:	e8 19 08 00 00       	call   80103ba0 <userinit>
  mpmain();        // finish this processor's setup
80103387:	e8 74 fe ff ff       	call   80103200 <mpmain>
8010338c:	66 90                	xchg   %ax,%ax
8010338e:	66 90                	xchg   %ax,%ax

80103390 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	57                   	push   %edi
80103394:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103395:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010339b:	53                   	push   %ebx
  e = addr+len;
8010339c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010339f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801033a2:	39 de                	cmp    %ebx,%esi
801033a4:	72 10                	jb     801033b6 <mpsearch1+0x26>
801033a6:	eb 50                	jmp    801033f8 <mpsearch1+0x68>
801033a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033af:	90                   	nop
801033b0:	89 fe                	mov    %edi,%esi
801033b2:	39 fb                	cmp    %edi,%ebx
801033b4:	76 42                	jbe    801033f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033b6:	83 ec 04             	sub    $0x4,%esp
801033b9:	8d 7e 10             	lea    0x10(%esi),%edi
801033bc:	6a 04                	push   $0x4
801033be:	68 98 79 10 80       	push   $0x80107998
801033c3:	56                   	push   %esi
801033c4:	e8 e7 14 00 00       	call   801048b0 <memcmp>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	85 c0                	test   %eax,%eax
801033ce:	75 e0                	jne    801033b0 <mpsearch1+0x20>
801033d0:	89 f2                	mov    %esi,%edx
801033d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801033d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e0:	39 fa                	cmp    %edi,%edx
801033e2:	75 f4                	jne    801033d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033e4:	84 c0                	test   %al,%al
801033e6:	75 c8                	jne    801033b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033eb:	89 f0                	mov    %esi,%eax
801033ed:	5b                   	pop    %ebx
801033ee:	5e                   	pop    %esi
801033ef:	5f                   	pop    %edi
801033f0:	5d                   	pop    %ebp
801033f1:	c3                   	ret    
801033f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033fb:	31 f6                	xor    %esi,%esi
}
801033fd:	5b                   	pop    %ebx
801033fe:	89 f0                	mov    %esi,%eax
80103400:	5e                   	pop    %esi
80103401:	5f                   	pop    %edi
80103402:	5d                   	pop    %ebp
80103403:	c3                   	ret    
80103404:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010340b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010340f:	90                   	nop

80103410 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103419:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103420:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103427:	c1 e0 08             	shl    $0x8,%eax
8010342a:	09 d0                	or     %edx,%eax
8010342c:	c1 e0 04             	shl    $0x4,%eax
8010342f:	75 1b                	jne    8010344c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103431:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103438:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010343f:	c1 e0 08             	shl    $0x8,%eax
80103442:	09 d0                	or     %edx,%eax
80103444:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103447:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010344c:	ba 00 04 00 00       	mov    $0x400,%edx
80103451:	e8 3a ff ff ff       	call   80103390 <mpsearch1>
80103456:	89 c3                	mov    %eax,%ebx
80103458:	85 c0                	test   %eax,%eax
8010345a:	0f 84 40 01 00 00    	je     801035a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103460:	8b 73 04             	mov    0x4(%ebx),%esi
80103463:	85 f6                	test   %esi,%esi
80103465:	0f 84 25 01 00 00    	je     80103590 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010346b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010346e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103474:	6a 04                	push   $0x4
80103476:	68 9d 79 10 80       	push   $0x8010799d
8010347b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010347c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010347f:	e8 2c 14 00 00       	call   801048b0 <memcmp>
80103484:	83 c4 10             	add    $0x10,%esp
80103487:	85 c0                	test   %eax,%eax
80103489:	0f 85 01 01 00 00    	jne    80103590 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010348f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103496:	3c 01                	cmp    $0x1,%al
80103498:	74 08                	je     801034a2 <mpinit+0x92>
8010349a:	3c 04                	cmp    $0x4,%al
8010349c:	0f 85 ee 00 00 00    	jne    80103590 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801034a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801034a9:	66 85 d2             	test   %dx,%dx
801034ac:	74 22                	je     801034d0 <mpinit+0xc0>
801034ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801034b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801034b3:	31 d2                	xor    %edx,%edx
801034b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801034b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801034bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801034c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801034c4:	39 c7                	cmp    %eax,%edi
801034c6:	75 f0                	jne    801034b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801034c8:	84 d2                	test   %dl,%dl
801034ca:	0f 85 c0 00 00 00    	jne    80103590 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801034d6:	a3 84 96 14 80       	mov    %eax,0x80149684
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801034e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801034e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801034f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801034f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034f7:	90                   	nop
801034f8:	39 d0                	cmp    %edx,%eax
801034fa:	73 15                	jae    80103511 <mpinit+0x101>
    switch(*p){
801034fc:	0f b6 08             	movzbl (%eax),%ecx
801034ff:	80 f9 02             	cmp    $0x2,%cl
80103502:	74 4c                	je     80103550 <mpinit+0x140>
80103504:	77 3a                	ja     80103540 <mpinit+0x130>
80103506:	84 c9                	test   %cl,%cl
80103508:	74 56                	je     80103560 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010350a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010350d:	39 d0                	cmp    %edx,%eax
8010350f:	72 eb                	jb     801034fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103511:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103514:	85 f6                	test   %esi,%esi
80103516:	0f 84 d9 00 00 00    	je     801035f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010351c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103520:	74 15                	je     80103537 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103522:	b8 70 00 00 00       	mov    $0x70,%eax
80103527:	ba 22 00 00 00       	mov    $0x22,%edx
8010352c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010352d:	ba 23 00 00 00       	mov    $0x23,%edx
80103532:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103533:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103536:	ee                   	out    %al,(%dx)
  }
}
80103537:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010353a:	5b                   	pop    %ebx
8010353b:	5e                   	pop    %esi
8010353c:	5f                   	pop    %edi
8010353d:	5d                   	pop    %ebp
8010353e:	c3                   	ret    
8010353f:	90                   	nop
    switch(*p){
80103540:	83 e9 03             	sub    $0x3,%ecx
80103543:	80 f9 01             	cmp    $0x1,%cl
80103546:	76 c2                	jbe    8010350a <mpinit+0xfa>
80103548:	31 f6                	xor    %esi,%esi
8010354a:	eb ac                	jmp    801034f8 <mpinit+0xe8>
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103550:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103554:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103557:	88 0d 80 97 14 80    	mov    %cl,0x80149780
      continue;
8010355d:	eb 99                	jmp    801034f8 <mpinit+0xe8>
8010355f:	90                   	nop
      if(ncpu < NCPU) {
80103560:	8b 0d 84 97 14 80    	mov    0x80149784,%ecx
80103566:	83 f9 07             	cmp    $0x7,%ecx
80103569:	7f 19                	jg     80103584 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010356b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103571:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103575:	83 c1 01             	add    $0x1,%ecx
80103578:	89 0d 84 97 14 80    	mov    %ecx,0x80149784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010357e:	88 9f a0 97 14 80    	mov    %bl,-0x7feb6860(%edi)
      p += sizeof(struct mpproc);
80103584:	83 c0 14             	add    $0x14,%eax
      continue;
80103587:	e9 6c ff ff ff       	jmp    801034f8 <mpinit+0xe8>
8010358c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	68 a2 79 10 80       	push   $0x801079a2
80103598:	e8 e3 cd ff ff       	call   80100380 <panic>
8010359d:	8d 76 00             	lea    0x0(%esi),%esi
{
801035a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801035a5:	eb 13                	jmp    801035ba <mpinit+0x1aa>
801035a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ae:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801035b0:	89 f3                	mov    %esi,%ebx
801035b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801035b8:	74 d6                	je     80103590 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035ba:	83 ec 04             	sub    $0x4,%esp
801035bd:	8d 73 10             	lea    0x10(%ebx),%esi
801035c0:	6a 04                	push   $0x4
801035c2:	68 98 79 10 80       	push   $0x80107998
801035c7:	53                   	push   %ebx
801035c8:	e8 e3 12 00 00       	call   801048b0 <memcmp>
801035cd:	83 c4 10             	add    $0x10,%esp
801035d0:	85 c0                	test   %eax,%eax
801035d2:	75 dc                	jne    801035b0 <mpinit+0x1a0>
801035d4:	89 da                	mov    %ebx,%edx
801035d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801035e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801035e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801035e8:	39 d6                	cmp    %edx,%esi
801035ea:	75 f4                	jne    801035e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035ec:	84 c0                	test   %al,%al
801035ee:	75 c0                	jne    801035b0 <mpinit+0x1a0>
801035f0:	e9 6b fe ff ff       	jmp    80103460 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801035f5:	83 ec 0c             	sub    $0xc,%esp
801035f8:	68 bc 79 10 80       	push   $0x801079bc
801035fd:	e8 7e cd ff ff       	call   80100380 <panic>
80103602:	66 90                	xchg   %ax,%ax
80103604:	66 90                	xchg   %ax,%ax
80103606:	66 90                	xchg   %ax,%ax
80103608:	66 90                	xchg   %ax,%ax
8010360a:	66 90                	xchg   %ax,%ax
8010360c:	66 90                	xchg   %ax,%ax
8010360e:	66 90                	xchg   %ax,%ax

80103610 <picinit>:
80103610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103615:	ba 21 00 00 00       	mov    $0x21,%edx
8010361a:	ee                   	out    %al,(%dx)
8010361b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103620:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103621:	c3                   	ret    
80103622:	66 90                	xchg   %ax,%ax
80103624:	66 90                	xchg   %ax,%ax
80103626:	66 90                	xchg   %ax,%ax
80103628:	66 90                	xchg   %ax,%ax
8010362a:	66 90                	xchg   %ax,%ax
8010362c:	66 90                	xchg   %ax,%ax
8010362e:	66 90                	xchg   %ax,%ax

80103630 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
80103635:	53                   	push   %ebx
80103636:	83 ec 0c             	sub    $0xc,%esp
80103639:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010363c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010363f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103645:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010364b:	e8 e0 d7 ff ff       	call   80100e30 <filealloc>
80103650:	89 03                	mov    %eax,(%ebx)
80103652:	85 c0                	test   %eax,%eax
80103654:	0f 84 a8 00 00 00    	je     80103702 <pipealloc+0xd2>
8010365a:	e8 d1 d7 ff ff       	call   80100e30 <filealloc>
8010365f:	89 06                	mov    %eax,(%esi)
80103661:	85 c0                	test   %eax,%eax
80103663:	0f 84 87 00 00 00    	je     801036f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103669:	e8 92 f0 ff ff       	call   80102700 <kalloc>
8010366e:	89 c7                	mov    %eax,%edi
80103670:	85 c0                	test   %eax,%eax
80103672:	0f 84 b0 00 00 00    	je     80103728 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103678:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010367f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103682:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103685:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010368c:	00 00 00 
  p->nwrite = 0;
8010368f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103696:	00 00 00 
  p->nread = 0;
80103699:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801036a0:	00 00 00 
  initlock(&p->lock, "pipe");
801036a3:	68 db 79 10 80       	push   $0x801079db
801036a8:	50                   	push   %eax
801036a9:	e8 22 0f 00 00       	call   801045d0 <initlock>
  (*f0)->type = FD_PIPE;
801036ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801036b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801036b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036b9:	8b 03                	mov    (%ebx),%eax
801036bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036bf:	8b 03                	mov    (%ebx),%eax
801036c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036c5:	8b 03                	mov    (%ebx),%eax
801036c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036ca:	8b 06                	mov    (%esi),%eax
801036cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036d2:	8b 06                	mov    (%esi),%eax
801036d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036d8:	8b 06                	mov    (%esi),%eax
801036da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036de:	8b 06                	mov    (%esi),%eax
801036e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036e6:	31 c0                	xor    %eax,%eax
}
801036e8:	5b                   	pop    %ebx
801036e9:	5e                   	pop    %esi
801036ea:	5f                   	pop    %edi
801036eb:	5d                   	pop    %ebp
801036ec:	c3                   	ret    
801036ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801036f0:	8b 03                	mov    (%ebx),%eax
801036f2:	85 c0                	test   %eax,%eax
801036f4:	74 1e                	je     80103714 <pipealloc+0xe4>
    fileclose(*f0);
801036f6:	83 ec 0c             	sub    $0xc,%esp
801036f9:	50                   	push   %eax
801036fa:	e8 f1 d7 ff ff       	call   80100ef0 <fileclose>
801036ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103702:	8b 06                	mov    (%esi),%eax
80103704:	85 c0                	test   %eax,%eax
80103706:	74 0c                	je     80103714 <pipealloc+0xe4>
    fileclose(*f1);
80103708:	83 ec 0c             	sub    $0xc,%esp
8010370b:	50                   	push   %eax
8010370c:	e8 df d7 ff ff       	call   80100ef0 <fileclose>
80103711:	83 c4 10             	add    $0x10,%esp
}
80103714:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103717:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010371c:	5b                   	pop    %ebx
8010371d:	5e                   	pop    %esi
8010371e:	5f                   	pop    %edi
8010371f:	5d                   	pop    %ebp
80103720:	c3                   	ret    
80103721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103728:	8b 03                	mov    (%ebx),%eax
8010372a:	85 c0                	test   %eax,%eax
8010372c:	75 c8                	jne    801036f6 <pipealloc+0xc6>
8010372e:	eb d2                	jmp    80103702 <pipealloc+0xd2>

80103730 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	56                   	push   %esi
80103734:	53                   	push   %ebx
80103735:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103738:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010373b:	83 ec 0c             	sub    $0xc,%esp
8010373e:	53                   	push   %ebx
8010373f:	e8 5c 10 00 00       	call   801047a0 <acquire>
  if(writable){
80103744:	83 c4 10             	add    $0x10,%esp
80103747:	85 f6                	test   %esi,%esi
80103749:	74 65                	je     801037b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010374b:	83 ec 0c             	sub    $0xc,%esp
8010374e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103754:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010375b:	00 00 00 
    wakeup(&p->nread);
8010375e:	50                   	push   %eax
8010375f:	e8 9c 0b 00 00       	call   80104300 <wakeup>
80103764:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103767:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010376d:	85 d2                	test   %edx,%edx
8010376f:	75 0a                	jne    8010377b <pipeclose+0x4b>
80103771:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103777:	85 c0                	test   %eax,%eax
80103779:	74 15                	je     80103790 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010377b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010377e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103781:	5b                   	pop    %ebx
80103782:	5e                   	pop    %esi
80103783:	5d                   	pop    %ebp
    release(&p->lock);
80103784:	e9 b7 0f 00 00       	jmp    80104740 <release>
80103789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
80103793:	53                   	push   %ebx
80103794:	e8 a7 0f 00 00       	call   80104740 <release>
    kfree((char*)p);
80103799:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010379c:	83 c4 10             	add    $0x10,%esp
}
8010379f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037a2:	5b                   	pop    %ebx
801037a3:	5e                   	pop    %esi
801037a4:	5d                   	pop    %ebp
    kfree((char*)p);
801037a5:	e9 16 ed ff ff       	jmp    801024c0 <kfree>
801037aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801037b0:	83 ec 0c             	sub    $0xc,%esp
801037b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801037b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801037c0:	00 00 00 
    wakeup(&p->nwrite);
801037c3:	50                   	push   %eax
801037c4:	e8 37 0b 00 00       	call   80104300 <wakeup>
801037c9:	83 c4 10             	add    $0x10,%esp
801037cc:	eb 99                	jmp    80103767 <pipeclose+0x37>
801037ce:	66 90                	xchg   %ax,%ax

801037d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	57                   	push   %edi
801037d4:	56                   	push   %esi
801037d5:	53                   	push   %ebx
801037d6:	83 ec 28             	sub    $0x28,%esp
801037d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801037dc:	53                   	push   %ebx
801037dd:	e8 be 0f 00 00       	call   801047a0 <acquire>
  for(i = 0; i < n; i++){
801037e2:	8b 45 10             	mov    0x10(%ebp),%eax
801037e5:	83 c4 10             	add    $0x10,%esp
801037e8:	85 c0                	test   %eax,%eax
801037ea:	0f 8e c0 00 00 00    	jle    801038b0 <pipewrite+0xe0>
801037f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801037ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103802:	03 45 10             	add    0x10(%ebp),%eax
80103805:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103808:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010380e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103814:	89 ca                	mov    %ecx,%edx
80103816:	05 00 02 00 00       	add    $0x200,%eax
8010381b:	39 c1                	cmp    %eax,%ecx
8010381d:	74 3f                	je     8010385e <pipewrite+0x8e>
8010381f:	eb 67                	jmp    80103888 <pipewrite+0xb8>
80103821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103828:	e8 43 03 00 00       	call   80103b70 <myproc>
8010382d:	8b 48 24             	mov    0x24(%eax),%ecx
80103830:	85 c9                	test   %ecx,%ecx
80103832:	75 34                	jne    80103868 <pipewrite+0x98>
      wakeup(&p->nread);
80103834:	83 ec 0c             	sub    $0xc,%esp
80103837:	57                   	push   %edi
80103838:	e8 c3 0a 00 00       	call   80104300 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010383d:	58                   	pop    %eax
8010383e:	5a                   	pop    %edx
8010383f:	53                   	push   %ebx
80103840:	56                   	push   %esi
80103841:	e8 fa 09 00 00       	call   80104240 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103846:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010384c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103852:	83 c4 10             	add    $0x10,%esp
80103855:	05 00 02 00 00       	add    $0x200,%eax
8010385a:	39 c2                	cmp    %eax,%edx
8010385c:	75 2a                	jne    80103888 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010385e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103864:	85 c0                	test   %eax,%eax
80103866:	75 c0                	jne    80103828 <pipewrite+0x58>
        release(&p->lock);
80103868:	83 ec 0c             	sub    $0xc,%esp
8010386b:	53                   	push   %ebx
8010386c:	e8 cf 0e 00 00       	call   80104740 <release>
        return -1;
80103871:	83 c4 10             	add    $0x10,%esp
80103874:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103879:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010387c:	5b                   	pop    %ebx
8010387d:	5e                   	pop    %esi
8010387e:	5f                   	pop    %edi
8010387f:	5d                   	pop    %ebp
80103880:	c3                   	ret    
80103881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103888:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010388b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010388e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103894:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010389a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010389d:	83 c6 01             	add    $0x1,%esi
801038a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801038a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801038aa:	0f 85 58 ff ff ff    	jne    80103808 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801038b0:	83 ec 0c             	sub    $0xc,%esp
801038b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038b9:	50                   	push   %eax
801038ba:	e8 41 0a 00 00       	call   80104300 <wakeup>
  release(&p->lock);
801038bf:	89 1c 24             	mov    %ebx,(%esp)
801038c2:	e8 79 0e 00 00       	call   80104740 <release>
  return n;
801038c7:	8b 45 10             	mov    0x10(%ebp),%eax
801038ca:	83 c4 10             	add    $0x10,%esp
801038cd:	eb aa                	jmp    80103879 <pipewrite+0xa9>
801038cf:	90                   	nop

801038d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	57                   	push   %edi
801038d4:	56                   	push   %esi
801038d5:	53                   	push   %ebx
801038d6:	83 ec 18             	sub    $0x18,%esp
801038d9:	8b 75 08             	mov    0x8(%ebp),%esi
801038dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038df:	56                   	push   %esi
801038e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038e6:	e8 b5 0e 00 00       	call   801047a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038f1:	83 c4 10             	add    $0x10,%esp
801038f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801038fa:	74 2f                	je     8010392b <piperead+0x5b>
801038fc:	eb 37                	jmp    80103935 <piperead+0x65>
801038fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103900:	e8 6b 02 00 00       	call   80103b70 <myproc>
80103905:	8b 48 24             	mov    0x24(%eax),%ecx
80103908:	85 c9                	test   %ecx,%ecx
8010390a:	0f 85 80 00 00 00    	jne    80103990 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103910:	83 ec 08             	sub    $0x8,%esp
80103913:	56                   	push   %esi
80103914:	53                   	push   %ebx
80103915:	e8 26 09 00 00       	call   80104240 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010391a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103920:	83 c4 10             	add    $0x10,%esp
80103923:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103929:	75 0a                	jne    80103935 <piperead+0x65>
8010392b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103931:	85 c0                	test   %eax,%eax
80103933:	75 cb                	jne    80103900 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103935:	8b 55 10             	mov    0x10(%ebp),%edx
80103938:	31 db                	xor    %ebx,%ebx
8010393a:	85 d2                	test   %edx,%edx
8010393c:	7f 20                	jg     8010395e <piperead+0x8e>
8010393e:	eb 2c                	jmp    8010396c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103940:	8d 48 01             	lea    0x1(%eax),%ecx
80103943:	25 ff 01 00 00       	and    $0x1ff,%eax
80103948:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010394e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103953:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103956:	83 c3 01             	add    $0x1,%ebx
80103959:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010395c:	74 0e                	je     8010396c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010395e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103964:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010396a:	75 d4                	jne    80103940 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010396c:	83 ec 0c             	sub    $0xc,%esp
8010396f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103975:	50                   	push   %eax
80103976:	e8 85 09 00 00       	call   80104300 <wakeup>
  release(&p->lock);
8010397b:	89 34 24             	mov    %esi,(%esp)
8010397e:	e8 bd 0d 00 00       	call   80104740 <release>
  return i;
80103983:	83 c4 10             	add    $0x10,%esp
}
80103986:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103989:	89 d8                	mov    %ebx,%eax
8010398b:	5b                   	pop    %ebx
8010398c:	5e                   	pop    %esi
8010398d:	5f                   	pop    %edi
8010398e:	5d                   	pop    %ebp
8010398f:	c3                   	ret    
      release(&p->lock);
80103990:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103993:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103998:	56                   	push   %esi
80103999:	e8 a2 0d 00 00       	call   80104740 <release>
      return -1;
8010399e:	83 c4 10             	add    $0x10,%esp
}
801039a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039a4:	89 d8                	mov    %ebx,%eax
801039a6:	5b                   	pop    %ebx
801039a7:	5e                   	pop    %esi
801039a8:	5f                   	pop    %edi
801039a9:	5d                   	pop    %ebp
801039aa:	c3                   	ret    
801039ab:	66 90                	xchg   %ax,%ax
801039ad:	66 90                	xchg   %ax,%ax
801039af:	90                   	nop

801039b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039b4:	bb 54 9d 14 80       	mov    $0x80149d54,%ebx
{
801039b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801039bc:	68 20 9d 14 80       	push   $0x80149d20
801039c1:	e8 da 0d 00 00       	call   801047a0 <acquire>
801039c6:	83 c4 10             	add    $0x10,%esp
801039c9:	eb 10                	jmp    801039db <allocproc+0x2b>
801039cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039d0:	83 c3 7c             	add    $0x7c,%ebx
801039d3:	81 fb 54 bc 14 80    	cmp    $0x8014bc54,%ebx
801039d9:	74 75                	je     80103a50 <allocproc+0xa0>
    if(p->state == UNUSED)
801039db:	8b 43 0c             	mov    0xc(%ebx),%eax
801039de:	85 c0                	test   %eax,%eax
801039e0:	75 ee                	jne    801039d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039e2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801039e7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039ea:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801039f1:	89 43 10             	mov    %eax,0x10(%ebx)
801039f4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801039f7:	68 20 9d 14 80       	push   $0x80149d20
  p->pid = nextpid++;
801039fc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103a02:	e8 39 0d 00 00       	call   80104740 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103a07:	e8 f4 ec ff ff       	call   80102700 <kalloc>
80103a0c:	83 c4 10             	add    $0x10,%esp
80103a0f:	89 43 08             	mov    %eax,0x8(%ebx)
80103a12:	85 c0                	test   %eax,%eax
80103a14:	74 53                	je     80103a69 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a16:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a1c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a1f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a24:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a27:	c7 40 14 52 5a 10 80 	movl   $0x80105a52,0x14(%eax)
  p->context = (struct context*)sp;
80103a2e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a31:	6a 14                	push   $0x14
80103a33:	6a 00                	push   $0x0
80103a35:	50                   	push   %eax
80103a36:	e8 25 0e 00 00       	call   80104860 <memset>
  p->context->eip = (uint)forkret;
80103a3b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a3e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a41:	c7 40 10 80 3a 10 80 	movl   $0x80103a80,0x10(%eax)
}
80103a48:	89 d8                	mov    %ebx,%eax
80103a4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a4d:	c9                   	leave  
80103a4e:	c3                   	ret    
80103a4f:	90                   	nop
  release(&ptable.lock);
80103a50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a53:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a55:	68 20 9d 14 80       	push   $0x80149d20
80103a5a:	e8 e1 0c 00 00       	call   80104740 <release>
}
80103a5f:	89 d8                	mov    %ebx,%eax
  return 0;
80103a61:	83 c4 10             	add    $0x10,%esp
}
80103a64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a67:	c9                   	leave  
80103a68:	c3                   	ret    
    p->state = UNUSED;
80103a69:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a70:	31 db                	xor    %ebx,%ebx
}
80103a72:	89 d8                	mov    %ebx,%eax
80103a74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a77:	c9                   	leave  
80103a78:	c3                   	ret    
80103a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a86:	68 20 9d 14 80       	push   $0x80149d20
80103a8b:	e8 b0 0c 00 00       	call   80104740 <release>

  if (first) {
80103a90:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103a95:	83 c4 10             	add    $0x10,%esp
80103a98:	85 c0                	test   %eax,%eax
80103a9a:	75 04                	jne    80103aa0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a9c:	c9                   	leave  
80103a9d:	c3                   	ret    
80103a9e:	66 90                	xchg   %ax,%ax
    first = 0;
80103aa0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103aa7:	00 00 00 
    iinit(ROOTDEV);
80103aaa:	83 ec 0c             	sub    $0xc,%esp
80103aad:	6a 01                	push   $0x1
80103aaf:	e8 ac da ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103ab4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103abb:	e8 00 f4 ff ff       	call   80102ec0 <initlog>
}
80103ac0:	83 c4 10             	add    $0x10,%esp
80103ac3:	c9                   	leave  
80103ac4:	c3                   	ret    
80103ac5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ad0 <pinit>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ad6:	68 e0 79 10 80       	push   $0x801079e0
80103adb:	68 20 9d 14 80       	push   $0x80149d20
80103ae0:	e8 eb 0a 00 00       	call   801045d0 <initlock>
}
80103ae5:	83 c4 10             	add    $0x10,%esp
80103ae8:	c9                   	leave  
80103ae9:	c3                   	ret    
80103aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103af0 <mycpu>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	56                   	push   %esi
80103af4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103af5:	9c                   	pushf  
80103af6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103af7:	f6 c4 02             	test   $0x2,%ah
80103afa:	75 46                	jne    80103b42 <mycpu+0x52>
  apicid = lapicid();
80103afc:	e8 ef ef ff ff       	call   80102af0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b01:	8b 35 84 97 14 80    	mov    0x80149784,%esi
80103b07:	85 f6                	test   %esi,%esi
80103b09:	7e 2a                	jle    80103b35 <mycpu+0x45>
80103b0b:	31 d2                	xor    %edx,%edx
80103b0d:	eb 08                	jmp    80103b17 <mycpu+0x27>
80103b0f:	90                   	nop
80103b10:	83 c2 01             	add    $0x1,%edx
80103b13:	39 f2                	cmp    %esi,%edx
80103b15:	74 1e                	je     80103b35 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103b17:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103b1d:	0f b6 99 a0 97 14 80 	movzbl -0x7feb6860(%ecx),%ebx
80103b24:	39 c3                	cmp    %eax,%ebx
80103b26:	75 e8                	jne    80103b10 <mycpu+0x20>
}
80103b28:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b2b:	8d 81 a0 97 14 80    	lea    -0x7feb6860(%ecx),%eax
}
80103b31:	5b                   	pop    %ebx
80103b32:	5e                   	pop    %esi
80103b33:	5d                   	pop    %ebp
80103b34:	c3                   	ret    
  panic("unknown apicid\n");
80103b35:	83 ec 0c             	sub    $0xc,%esp
80103b38:	68 e7 79 10 80       	push   $0x801079e7
80103b3d:	e8 3e c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b42:	83 ec 0c             	sub    $0xc,%esp
80103b45:	68 c4 7a 10 80       	push   $0x80107ac4
80103b4a:	e8 31 c8 ff ff       	call   80100380 <panic>
80103b4f:	90                   	nop

80103b50 <cpuid>:
cpuid() {
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b56:	e8 95 ff ff ff       	call   80103af0 <mycpu>
}
80103b5b:	c9                   	leave  
  return mycpu()-cpus;
80103b5c:	2d a0 97 14 80       	sub    $0x801497a0,%eax
80103b61:	c1 f8 04             	sar    $0x4,%eax
80103b64:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b6a:	c3                   	ret    
80103b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b6f:	90                   	nop

80103b70 <myproc>:
myproc(void) {
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	53                   	push   %ebx
80103b74:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b77:	e8 d4 0a 00 00       	call   80104650 <pushcli>
  c = mycpu();
80103b7c:	e8 6f ff ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103b81:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b87:	e8 14 0b 00 00       	call   801046a0 <popcli>
}
80103b8c:	89 d8                	mov    %ebx,%eax
80103b8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b91:	c9                   	leave  
80103b92:	c3                   	ret    
80103b93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ba0 <userinit>:
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	53                   	push   %ebx
80103ba4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ba7:	e8 04 fe ff ff       	call   801039b0 <allocproc>
80103bac:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bae:	a3 54 bc 14 80       	mov    %eax,0x8014bc54
  if((p->pgdir = setupkvm()) == 0)
80103bb3:	e8 a8 34 00 00       	call   80107060 <setupkvm>
80103bb8:	89 43 04             	mov    %eax,0x4(%ebx)
80103bbb:	85 c0                	test   %eax,%eax
80103bbd:	0f 84 bd 00 00 00    	je     80103c80 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103bc3:	83 ec 04             	sub    $0x4,%esp
80103bc6:	68 2c 00 00 00       	push   $0x2c
80103bcb:	68 60 a4 10 80       	push   $0x8010a460
80103bd0:	50                   	push   %eax
80103bd1:	e8 3a 31 00 00       	call   80106d10 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103bd6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103bd9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bdf:	6a 4c                	push   $0x4c
80103be1:	6a 00                	push   $0x0
80103be3:	ff 73 18             	push   0x18(%ebx)
80103be6:	e8 75 0c 00 00       	call   80104860 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103beb:	8b 43 18             	mov    0x18(%ebx),%eax
80103bee:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bf3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bf6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bfb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bff:	8b 43 18             	mov    0x18(%ebx),%eax
80103c02:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c06:	8b 43 18             	mov    0x18(%ebx),%eax
80103c09:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c0d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c11:	8b 43 18             	mov    0x18(%ebx),%eax
80103c14:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c18:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c1c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c1f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c26:	8b 43 18             	mov    0x18(%ebx),%eax
80103c29:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c30:	8b 43 18             	mov    0x18(%ebx),%eax
80103c33:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c3a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c3d:	6a 10                	push   $0x10
80103c3f:	68 10 7a 10 80       	push   $0x80107a10
80103c44:	50                   	push   %eax
80103c45:	e8 d6 0d 00 00       	call   80104a20 <safestrcpy>
  p->cwd = namei("/");
80103c4a:	c7 04 24 19 7a 10 80 	movl   $0x80107a19,(%esp)
80103c51:	e8 4a e4 ff ff       	call   801020a0 <namei>
80103c56:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c59:	c7 04 24 20 9d 14 80 	movl   $0x80149d20,(%esp)
80103c60:	e8 3b 0b 00 00       	call   801047a0 <acquire>
  p->state = RUNNABLE;
80103c65:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c6c:	c7 04 24 20 9d 14 80 	movl   $0x80149d20,(%esp)
80103c73:	e8 c8 0a 00 00       	call   80104740 <release>
}
80103c78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c7b:	83 c4 10             	add    $0x10,%esp
80103c7e:	c9                   	leave  
80103c7f:	c3                   	ret    
    panic("userinit: out of memory?");
80103c80:	83 ec 0c             	sub    $0xc,%esp
80103c83:	68 f7 79 10 80       	push   $0x801079f7
80103c88:	e8 f3 c6 ff ff       	call   80100380 <panic>
80103c8d:	8d 76 00             	lea    0x0(%esi),%esi

80103c90 <growproc>:
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	56                   	push   %esi
80103c94:	53                   	push   %ebx
80103c95:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c98:	e8 b3 09 00 00       	call   80104650 <pushcli>
  c = mycpu();
80103c9d:	e8 4e fe ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103ca2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ca8:	e8 f3 09 00 00       	call   801046a0 <popcli>
  sz = curproc->sz;
80103cad:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103caf:	85 f6                	test   %esi,%esi
80103cb1:	7f 1d                	jg     80103cd0 <growproc+0x40>
  } else if(n < 0){
80103cb3:	75 3b                	jne    80103cf0 <growproc+0x60>
  switchuvm(curproc);
80103cb5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103cb8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103cba:	53                   	push   %ebx
80103cbb:	e8 40 2f 00 00       	call   80106c00 <switchuvm>
  return 0;
80103cc0:	83 c4 10             	add    $0x10,%esp
80103cc3:	31 c0                	xor    %eax,%eax
}
80103cc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cc8:	5b                   	pop    %ebx
80103cc9:	5e                   	pop    %esi
80103cca:	5d                   	pop    %ebp
80103ccb:	c3                   	ret    
80103ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cd0:	83 ec 04             	sub    $0x4,%esp
80103cd3:	01 c6                	add    %eax,%esi
80103cd5:	56                   	push   %esi
80103cd6:	50                   	push   %eax
80103cd7:	ff 73 04             	push   0x4(%ebx)
80103cda:	e8 a1 31 00 00       	call   80106e80 <allocuvm>
80103cdf:	83 c4 10             	add    $0x10,%esp
80103ce2:	85 c0                	test   %eax,%eax
80103ce4:	75 cf                	jne    80103cb5 <growproc+0x25>
      return -1;
80103ce6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ceb:	eb d8                	jmp    80103cc5 <growproc+0x35>
80103ced:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cf0:	83 ec 04             	sub    $0x4,%esp
80103cf3:	01 c6                	add    %eax,%esi
80103cf5:	56                   	push   %esi
80103cf6:	50                   	push   %eax
80103cf7:	ff 73 04             	push   0x4(%ebx)
80103cfa:	e8 b1 32 00 00       	call   80106fb0 <deallocuvm>
80103cff:	83 c4 10             	add    $0x10,%esp
80103d02:	85 c0                	test   %eax,%eax
80103d04:	75 af                	jne    80103cb5 <growproc+0x25>
80103d06:	eb de                	jmp    80103ce6 <growproc+0x56>
80103d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d0f:	90                   	nop

80103d10 <fork>:
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	57                   	push   %edi
80103d14:	56                   	push   %esi
80103d15:	53                   	push   %ebx
80103d16:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d19:	e8 32 09 00 00       	call   80104650 <pushcli>
  c = mycpu();
80103d1e:	e8 cd fd ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103d23:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d29:	e8 72 09 00 00       	call   801046a0 <popcli>
  if((np = allocproc()) == 0){
80103d2e:	e8 7d fc ff ff       	call   801039b0 <allocproc>
80103d33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d36:	85 c0                	test   %eax,%eax
80103d38:	0f 84 b7 00 00 00    	je     80103df5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d3e:	83 ec 08             	sub    $0x8,%esp
80103d41:	ff 33                	push   (%ebx)
80103d43:	89 c7                	mov    %eax,%edi
80103d45:	ff 73 04             	push   0x4(%ebx)
80103d48:	e8 03 34 00 00       	call   80107150 <copyuvm>
80103d4d:	83 c4 10             	add    $0x10,%esp
80103d50:	89 47 04             	mov    %eax,0x4(%edi)
80103d53:	85 c0                	test   %eax,%eax
80103d55:	0f 84 a1 00 00 00    	je     80103dfc <fork+0xec>
  np->sz = curproc->sz;
80103d5b:	8b 03                	mov    (%ebx),%eax
80103d5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d60:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d62:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103d65:	89 c8                	mov    %ecx,%eax
80103d67:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d6a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d6f:	8b 73 18             	mov    0x18(%ebx),%esi
80103d72:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d74:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d76:	8b 40 18             	mov    0x18(%eax),%eax
80103d79:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103d80:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d84:	85 c0                	test   %eax,%eax
80103d86:	74 13                	je     80103d9b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d88:	83 ec 0c             	sub    $0xc,%esp
80103d8b:	50                   	push   %eax
80103d8c:	e8 0f d1 ff ff       	call   80100ea0 <filedup>
80103d91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d94:	83 c4 10             	add    $0x10,%esp
80103d97:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d9b:	83 c6 01             	add    $0x1,%esi
80103d9e:	83 fe 10             	cmp    $0x10,%esi
80103da1:	75 dd                	jne    80103d80 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103da3:	83 ec 0c             	sub    $0xc,%esp
80103da6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103da9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103dac:	e8 9f d9 ff ff       	call   80101750 <idup>
80103db1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103db4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103db7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dba:	8d 47 6c             	lea    0x6c(%edi),%eax
80103dbd:	6a 10                	push   $0x10
80103dbf:	53                   	push   %ebx
80103dc0:	50                   	push   %eax
80103dc1:	e8 5a 0c 00 00       	call   80104a20 <safestrcpy>
  pid = np->pid;
80103dc6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103dc9:	c7 04 24 20 9d 14 80 	movl   $0x80149d20,(%esp)
80103dd0:	e8 cb 09 00 00       	call   801047a0 <acquire>
  np->state = RUNNABLE;
80103dd5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103ddc:	c7 04 24 20 9d 14 80 	movl   $0x80149d20,(%esp)
80103de3:	e8 58 09 00 00       	call   80104740 <release>
  return pid;
80103de8:	83 c4 10             	add    $0x10,%esp
}
80103deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dee:	89 d8                	mov    %ebx,%eax
80103df0:	5b                   	pop    %ebx
80103df1:	5e                   	pop    %esi
80103df2:	5f                   	pop    %edi
80103df3:	5d                   	pop    %ebp
80103df4:	c3                   	ret    
    return -1;
80103df5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103dfa:	eb ef                	jmp    80103deb <fork+0xdb>
    kfree(np->kstack);
80103dfc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103dff:	83 ec 0c             	sub    $0xc,%esp
80103e02:	ff 73 08             	push   0x8(%ebx)
80103e05:	e8 b6 e6 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103e0a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103e11:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e14:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e1b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e20:	eb c9                	jmp    80103deb <fork+0xdb>
80103e22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e30 <scheduler>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	57                   	push   %edi
80103e34:	56                   	push   %esi
80103e35:	53                   	push   %ebx
80103e36:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e39:	e8 b2 fc ff ff       	call   80103af0 <mycpu>
  c->proc = 0;
80103e3e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e45:	00 00 00 
  struct cpu *c = mycpu();
80103e48:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e4a:	8d 78 04             	lea    0x4(%eax),%edi
80103e4d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e50:	fb                   	sti    
    acquire(&ptable.lock);
80103e51:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e54:	bb 54 9d 14 80       	mov    $0x80149d54,%ebx
    acquire(&ptable.lock);
80103e59:	68 20 9d 14 80       	push   $0x80149d20
80103e5e:	e8 3d 09 00 00       	call   801047a0 <acquire>
80103e63:	83 c4 10             	add    $0x10,%esp
80103e66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e6d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103e70:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e74:	75 33                	jne    80103ea9 <scheduler+0x79>
      switchuvm(p);
80103e76:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e79:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e7f:	53                   	push   %ebx
80103e80:	e8 7b 2d 00 00       	call   80106c00 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e85:	58                   	pop    %eax
80103e86:	5a                   	pop    %edx
80103e87:	ff 73 1c             	push   0x1c(%ebx)
80103e8a:	57                   	push   %edi
      p->state = RUNNING;
80103e8b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103e92:	e8 e4 0b 00 00       	call   80104a7b <swtch>
      switchkvm();
80103e97:	e8 54 2d 00 00       	call   80106bf0 <switchkvm>
      c->proc = 0;
80103e9c:	83 c4 10             	add    $0x10,%esp
80103e9f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ea6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ea9:	83 c3 7c             	add    $0x7c,%ebx
80103eac:	81 fb 54 bc 14 80    	cmp    $0x8014bc54,%ebx
80103eb2:	75 bc                	jne    80103e70 <scheduler+0x40>
    release(&ptable.lock);
80103eb4:	83 ec 0c             	sub    $0xc,%esp
80103eb7:	68 20 9d 14 80       	push   $0x80149d20
80103ebc:	e8 7f 08 00 00       	call   80104740 <release>
    sti();
80103ec1:	83 c4 10             	add    $0x10,%esp
80103ec4:	eb 8a                	jmp    80103e50 <scheduler+0x20>
80103ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ecd:	8d 76 00             	lea    0x0(%esi),%esi

80103ed0 <sched>:
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	56                   	push   %esi
80103ed4:	53                   	push   %ebx
  pushcli();
80103ed5:	e8 76 07 00 00       	call   80104650 <pushcli>
  c = mycpu();
80103eda:	e8 11 fc ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80103edf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ee5:	e8 b6 07 00 00       	call   801046a0 <popcli>
  if(!holding(&ptable.lock))
80103eea:	83 ec 0c             	sub    $0xc,%esp
80103eed:	68 20 9d 14 80       	push   $0x80149d20
80103ef2:	e8 09 08 00 00       	call   80104700 <holding>
80103ef7:	83 c4 10             	add    $0x10,%esp
80103efa:	85 c0                	test   %eax,%eax
80103efc:	74 4f                	je     80103f4d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103efe:	e8 ed fb ff ff       	call   80103af0 <mycpu>
80103f03:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f0a:	75 68                	jne    80103f74 <sched+0xa4>
  if(p->state == RUNNING)
80103f0c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f10:	74 55                	je     80103f67 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f12:	9c                   	pushf  
80103f13:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f14:	f6 c4 02             	test   $0x2,%ah
80103f17:	75 41                	jne    80103f5a <sched+0x8a>
  intena = mycpu()->intena;
80103f19:	e8 d2 fb ff ff       	call   80103af0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f1e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f21:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f27:	e8 c4 fb ff ff       	call   80103af0 <mycpu>
80103f2c:	83 ec 08             	sub    $0x8,%esp
80103f2f:	ff 70 04             	push   0x4(%eax)
80103f32:	53                   	push   %ebx
80103f33:	e8 43 0b 00 00       	call   80104a7b <swtch>
  mycpu()->intena = intena;
80103f38:	e8 b3 fb ff ff       	call   80103af0 <mycpu>
}
80103f3d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f40:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f49:	5b                   	pop    %ebx
80103f4a:	5e                   	pop    %esi
80103f4b:	5d                   	pop    %ebp
80103f4c:	c3                   	ret    
    panic("sched ptable.lock");
80103f4d:	83 ec 0c             	sub    $0xc,%esp
80103f50:	68 1b 7a 10 80       	push   $0x80107a1b
80103f55:	e8 26 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	68 47 7a 10 80       	push   $0x80107a47
80103f62:	e8 19 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103f67:	83 ec 0c             	sub    $0xc,%esp
80103f6a:	68 39 7a 10 80       	push   $0x80107a39
80103f6f:	e8 0c c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103f74:	83 ec 0c             	sub    $0xc,%esp
80103f77:	68 2d 7a 10 80       	push   $0x80107a2d
80103f7c:	e8 ff c3 ff ff       	call   80100380 <panic>
80103f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f8f:	90                   	nop

80103f90 <exit>:
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	57                   	push   %edi
80103f94:	56                   	push   %esi
80103f95:	53                   	push   %ebx
80103f96:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103f99:	e8 d2 fb ff ff       	call   80103b70 <myproc>
  if(curproc == initproc)
80103f9e:	39 05 54 bc 14 80    	cmp    %eax,0x8014bc54
80103fa4:	0f 84 fd 00 00 00    	je     801040a7 <exit+0x117>
80103faa:	89 c3                	mov    %eax,%ebx
80103fac:	8d 70 28             	lea    0x28(%eax),%esi
80103faf:	8d 78 68             	lea    0x68(%eax),%edi
80103fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103fb8:	8b 06                	mov    (%esi),%eax
80103fba:	85 c0                	test   %eax,%eax
80103fbc:	74 12                	je     80103fd0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103fbe:	83 ec 0c             	sub    $0xc,%esp
80103fc1:	50                   	push   %eax
80103fc2:	e8 29 cf ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103fc7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103fcd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103fd0:	83 c6 04             	add    $0x4,%esi
80103fd3:	39 f7                	cmp    %esi,%edi
80103fd5:	75 e1                	jne    80103fb8 <exit+0x28>
  begin_op();
80103fd7:	e8 84 ef ff ff       	call   80102f60 <begin_op>
  iput(curproc->cwd);
80103fdc:	83 ec 0c             	sub    $0xc,%esp
80103fdf:	ff 73 68             	push   0x68(%ebx)
80103fe2:	e8 c9 d8 ff ff       	call   801018b0 <iput>
  end_op();
80103fe7:	e8 e4 ef ff ff       	call   80102fd0 <end_op>
  curproc->cwd = 0;
80103fec:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103ff3:	c7 04 24 20 9d 14 80 	movl   $0x80149d20,(%esp)
80103ffa:	e8 a1 07 00 00       	call   801047a0 <acquire>
  wakeup1(curproc->parent);
80103fff:	8b 53 14             	mov    0x14(%ebx),%edx
80104002:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104005:	b8 54 9d 14 80       	mov    $0x80149d54,%eax
8010400a:	eb 0e                	jmp    8010401a <exit+0x8a>
8010400c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104010:	83 c0 7c             	add    $0x7c,%eax
80104013:	3d 54 bc 14 80       	cmp    $0x8014bc54,%eax
80104018:	74 1c                	je     80104036 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010401a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010401e:	75 f0                	jne    80104010 <exit+0x80>
80104020:	3b 50 20             	cmp    0x20(%eax),%edx
80104023:	75 eb                	jne    80104010 <exit+0x80>
      p->state = RUNNABLE;
80104025:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010402c:	83 c0 7c             	add    $0x7c,%eax
8010402f:	3d 54 bc 14 80       	cmp    $0x8014bc54,%eax
80104034:	75 e4                	jne    8010401a <exit+0x8a>
      p->parent = initproc;
80104036:	8b 0d 54 bc 14 80    	mov    0x8014bc54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010403c:	ba 54 9d 14 80       	mov    $0x80149d54,%edx
80104041:	eb 10                	jmp    80104053 <exit+0xc3>
80104043:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104047:	90                   	nop
80104048:	83 c2 7c             	add    $0x7c,%edx
8010404b:	81 fa 54 bc 14 80    	cmp    $0x8014bc54,%edx
80104051:	74 3b                	je     8010408e <exit+0xfe>
    if(p->parent == curproc){
80104053:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104056:	75 f0                	jne    80104048 <exit+0xb8>
      if(p->state == ZOMBIE)
80104058:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010405c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010405f:	75 e7                	jne    80104048 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104061:	b8 54 9d 14 80       	mov    $0x80149d54,%eax
80104066:	eb 12                	jmp    8010407a <exit+0xea>
80104068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010406f:	90                   	nop
80104070:	83 c0 7c             	add    $0x7c,%eax
80104073:	3d 54 bc 14 80       	cmp    $0x8014bc54,%eax
80104078:	74 ce                	je     80104048 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010407a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010407e:	75 f0                	jne    80104070 <exit+0xe0>
80104080:	3b 48 20             	cmp    0x20(%eax),%ecx
80104083:	75 eb                	jne    80104070 <exit+0xe0>
      p->state = RUNNABLE;
80104085:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010408c:	eb e2                	jmp    80104070 <exit+0xe0>
  curproc->state = ZOMBIE;
8010408e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104095:	e8 36 fe ff ff       	call   80103ed0 <sched>
  panic("zombie exit");
8010409a:	83 ec 0c             	sub    $0xc,%esp
8010409d:	68 68 7a 10 80       	push   $0x80107a68
801040a2:	e8 d9 c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
801040a7:	83 ec 0c             	sub    $0xc,%esp
801040aa:	68 5b 7a 10 80       	push   $0x80107a5b
801040af:	e8 cc c2 ff ff       	call   80100380 <panic>
801040b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040bf:	90                   	nop

801040c0 <wait>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	56                   	push   %esi
801040c4:	53                   	push   %ebx
  pushcli();
801040c5:	e8 86 05 00 00       	call   80104650 <pushcli>
  c = mycpu();
801040ca:	e8 21 fa ff ff       	call   80103af0 <mycpu>
  p = c->proc;
801040cf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040d5:	e8 c6 05 00 00       	call   801046a0 <popcli>
  acquire(&ptable.lock);
801040da:	83 ec 0c             	sub    $0xc,%esp
801040dd:	68 20 9d 14 80       	push   $0x80149d20
801040e2:	e8 b9 06 00 00       	call   801047a0 <acquire>
801040e7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040ea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040ec:	bb 54 9d 14 80       	mov    $0x80149d54,%ebx
801040f1:	eb 10                	jmp    80104103 <wait+0x43>
801040f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040f7:	90                   	nop
801040f8:	83 c3 7c             	add    $0x7c,%ebx
801040fb:	81 fb 54 bc 14 80    	cmp    $0x8014bc54,%ebx
80104101:	74 1b                	je     8010411e <wait+0x5e>
      if(p->parent != curproc)
80104103:	39 73 14             	cmp    %esi,0x14(%ebx)
80104106:	75 f0                	jne    801040f8 <wait+0x38>
      if(p->state == ZOMBIE){
80104108:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010410c:	74 62                	je     80104170 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010410e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104111:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104116:	81 fb 54 bc 14 80    	cmp    $0x8014bc54,%ebx
8010411c:	75 e5                	jne    80104103 <wait+0x43>
    if(!havekids || curproc->killed){
8010411e:	85 c0                	test   %eax,%eax
80104120:	0f 84 a0 00 00 00    	je     801041c6 <wait+0x106>
80104126:	8b 46 24             	mov    0x24(%esi),%eax
80104129:	85 c0                	test   %eax,%eax
8010412b:	0f 85 95 00 00 00    	jne    801041c6 <wait+0x106>
  pushcli();
80104131:	e8 1a 05 00 00       	call   80104650 <pushcli>
  c = mycpu();
80104136:	e8 b5 f9 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
8010413b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104141:	e8 5a 05 00 00       	call   801046a0 <popcli>
  if(p == 0)
80104146:	85 db                	test   %ebx,%ebx
80104148:	0f 84 8f 00 00 00    	je     801041dd <wait+0x11d>
  p->chan = chan;
8010414e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104151:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104158:	e8 73 fd ff ff       	call   80103ed0 <sched>
  p->chan = 0;
8010415d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104164:	eb 84                	jmp    801040ea <wait+0x2a>
80104166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104170:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104173:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104176:	ff 73 08             	push   0x8(%ebx)
80104179:	e8 42 e3 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010417e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104185:	5a                   	pop    %edx
80104186:	ff 73 04             	push   0x4(%ebx)
80104189:	e8 52 2e 00 00       	call   80106fe0 <freevm>
        p->pid = 0;
8010418e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104195:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010419c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041a0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041a7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801041ae:	c7 04 24 20 9d 14 80 	movl   $0x80149d20,(%esp)
801041b5:	e8 86 05 00 00       	call   80104740 <release>
        return pid;
801041ba:	83 c4 10             	add    $0x10,%esp
}
801041bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041c0:	89 f0                	mov    %esi,%eax
801041c2:	5b                   	pop    %ebx
801041c3:	5e                   	pop    %esi
801041c4:	5d                   	pop    %ebp
801041c5:	c3                   	ret    
      release(&ptable.lock);
801041c6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041c9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041ce:	68 20 9d 14 80       	push   $0x80149d20
801041d3:	e8 68 05 00 00       	call   80104740 <release>
      return -1;
801041d8:	83 c4 10             	add    $0x10,%esp
801041db:	eb e0                	jmp    801041bd <wait+0xfd>
    panic("sleep");
801041dd:	83 ec 0c             	sub    $0xc,%esp
801041e0:	68 74 7a 10 80       	push   $0x80107a74
801041e5:	e8 96 c1 ff ff       	call   80100380 <panic>
801041ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041f0 <yield>:
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	53                   	push   %ebx
801041f4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801041f7:	68 20 9d 14 80       	push   $0x80149d20
801041fc:	e8 9f 05 00 00       	call   801047a0 <acquire>
  pushcli();
80104201:	e8 4a 04 00 00       	call   80104650 <pushcli>
  c = mycpu();
80104206:	e8 e5 f8 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
8010420b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104211:	e8 8a 04 00 00       	call   801046a0 <popcli>
  myproc()->state = RUNNABLE;
80104216:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010421d:	e8 ae fc ff ff       	call   80103ed0 <sched>
  release(&ptable.lock);
80104222:	c7 04 24 20 9d 14 80 	movl   $0x80149d20,(%esp)
80104229:	e8 12 05 00 00       	call   80104740 <release>
}
8010422e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104231:	83 c4 10             	add    $0x10,%esp
80104234:	c9                   	leave  
80104235:	c3                   	ret    
80104236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010423d:	8d 76 00             	lea    0x0(%esi),%esi

80104240 <sleep>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	57                   	push   %edi
80104244:	56                   	push   %esi
80104245:	53                   	push   %ebx
80104246:	83 ec 0c             	sub    $0xc,%esp
80104249:	8b 7d 08             	mov    0x8(%ebp),%edi
8010424c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010424f:	e8 fc 03 00 00       	call   80104650 <pushcli>
  c = mycpu();
80104254:	e8 97 f8 ff ff       	call   80103af0 <mycpu>
  p = c->proc;
80104259:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010425f:	e8 3c 04 00 00       	call   801046a0 <popcli>
  if(p == 0)
80104264:	85 db                	test   %ebx,%ebx
80104266:	0f 84 87 00 00 00    	je     801042f3 <sleep+0xb3>
  if(lk == 0)
8010426c:	85 f6                	test   %esi,%esi
8010426e:	74 76                	je     801042e6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104270:	81 fe 20 9d 14 80    	cmp    $0x80149d20,%esi
80104276:	74 50                	je     801042c8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104278:	83 ec 0c             	sub    $0xc,%esp
8010427b:	68 20 9d 14 80       	push   $0x80149d20
80104280:	e8 1b 05 00 00       	call   801047a0 <acquire>
    release(lk);
80104285:	89 34 24             	mov    %esi,(%esp)
80104288:	e8 b3 04 00 00       	call   80104740 <release>
  p->chan = chan;
8010428d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104290:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104297:	e8 34 fc ff ff       	call   80103ed0 <sched>
  p->chan = 0;
8010429c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801042a3:	c7 04 24 20 9d 14 80 	movl   $0x80149d20,(%esp)
801042aa:	e8 91 04 00 00       	call   80104740 <release>
    acquire(lk);
801042af:	89 75 08             	mov    %esi,0x8(%ebp)
801042b2:	83 c4 10             	add    $0x10,%esp
}
801042b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042b8:	5b                   	pop    %ebx
801042b9:	5e                   	pop    %esi
801042ba:	5f                   	pop    %edi
801042bb:	5d                   	pop    %ebp
    acquire(lk);
801042bc:	e9 df 04 00 00       	jmp    801047a0 <acquire>
801042c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801042c8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042cb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042d2:	e8 f9 fb ff ff       	call   80103ed0 <sched>
  p->chan = 0;
801042d7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042e1:	5b                   	pop    %ebx
801042e2:	5e                   	pop    %esi
801042e3:	5f                   	pop    %edi
801042e4:	5d                   	pop    %ebp
801042e5:	c3                   	ret    
    panic("sleep without lk");
801042e6:	83 ec 0c             	sub    $0xc,%esp
801042e9:	68 7a 7a 10 80       	push   $0x80107a7a
801042ee:	e8 8d c0 ff ff       	call   80100380 <panic>
    panic("sleep");
801042f3:	83 ec 0c             	sub    $0xc,%esp
801042f6:	68 74 7a 10 80       	push   $0x80107a74
801042fb:	e8 80 c0 ff ff       	call   80100380 <panic>

80104300 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
80104304:	83 ec 10             	sub    $0x10,%esp
80104307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010430a:	68 20 9d 14 80       	push   $0x80149d20
8010430f:	e8 8c 04 00 00       	call   801047a0 <acquire>
80104314:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104317:	b8 54 9d 14 80       	mov    $0x80149d54,%eax
8010431c:	eb 0c                	jmp    8010432a <wakeup+0x2a>
8010431e:	66 90                	xchg   %ax,%ax
80104320:	83 c0 7c             	add    $0x7c,%eax
80104323:	3d 54 bc 14 80       	cmp    $0x8014bc54,%eax
80104328:	74 1c                	je     80104346 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010432a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010432e:	75 f0                	jne    80104320 <wakeup+0x20>
80104330:	3b 58 20             	cmp    0x20(%eax),%ebx
80104333:	75 eb                	jne    80104320 <wakeup+0x20>
      p->state = RUNNABLE;
80104335:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010433c:	83 c0 7c             	add    $0x7c,%eax
8010433f:	3d 54 bc 14 80       	cmp    $0x8014bc54,%eax
80104344:	75 e4                	jne    8010432a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104346:	c7 45 08 20 9d 14 80 	movl   $0x80149d20,0x8(%ebp)
}
8010434d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104350:	c9                   	leave  
  release(&ptable.lock);
80104351:	e9 ea 03 00 00       	jmp    80104740 <release>
80104356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010435d:	8d 76 00             	lea    0x0(%esi),%esi

80104360 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 10             	sub    $0x10,%esp
80104367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010436a:	68 20 9d 14 80       	push   $0x80149d20
8010436f:	e8 2c 04 00 00       	call   801047a0 <acquire>
80104374:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104377:	b8 54 9d 14 80       	mov    $0x80149d54,%eax
8010437c:	eb 0c                	jmp    8010438a <kill+0x2a>
8010437e:	66 90                	xchg   %ax,%ax
80104380:	83 c0 7c             	add    $0x7c,%eax
80104383:	3d 54 bc 14 80       	cmp    $0x8014bc54,%eax
80104388:	74 36                	je     801043c0 <kill+0x60>
    if(p->pid == pid){
8010438a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010438d:	75 f1                	jne    80104380 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010438f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104393:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010439a:	75 07                	jne    801043a3 <kill+0x43>
        p->state = RUNNABLE;
8010439c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043a3:	83 ec 0c             	sub    $0xc,%esp
801043a6:	68 20 9d 14 80       	push   $0x80149d20
801043ab:	e8 90 03 00 00       	call   80104740 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043b3:	83 c4 10             	add    $0x10,%esp
801043b6:	31 c0                	xor    %eax,%eax
}
801043b8:	c9                   	leave  
801043b9:	c3                   	ret    
801043ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801043c0:	83 ec 0c             	sub    $0xc,%esp
801043c3:	68 20 9d 14 80       	push   $0x80149d20
801043c8:	e8 73 03 00 00       	call   80104740 <release>
}
801043cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801043d0:	83 c4 10             	add    $0x10,%esp
801043d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043d8:	c9                   	leave  
801043d9:	c3                   	ret    
801043da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	57                   	push   %edi
801043e4:	56                   	push   %esi
801043e5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801043e8:	53                   	push   %ebx
801043e9:	bb c0 9d 14 80       	mov    $0x80149dc0,%ebx
801043ee:	83 ec 3c             	sub    $0x3c,%esp
801043f1:	eb 24                	jmp    80104417 <procdump+0x37>
801043f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043f7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	68 3f 7e 10 80       	push   $0x80107e3f
80104400:	e8 9b c2 ff ff       	call   801006a0 <cprintf>
80104405:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104408:	83 c3 7c             	add    $0x7c,%ebx
8010440b:	81 fb c0 bc 14 80    	cmp    $0x8014bcc0,%ebx
80104411:	0f 84 81 00 00 00    	je     80104498 <procdump+0xb8>
    if(p->state == UNUSED)
80104417:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010441a:	85 c0                	test   %eax,%eax
8010441c:	74 ea                	je     80104408 <procdump+0x28>
      state = "???";
8010441e:	ba 8b 7a 10 80       	mov    $0x80107a8b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104423:	83 f8 05             	cmp    $0x5,%eax
80104426:	77 11                	ja     80104439 <procdump+0x59>
80104428:	8b 14 85 ec 7a 10 80 	mov    -0x7fef8514(,%eax,4),%edx
      state = "???";
8010442f:	b8 8b 7a 10 80       	mov    $0x80107a8b,%eax
80104434:	85 d2                	test   %edx,%edx
80104436:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104439:	53                   	push   %ebx
8010443a:	52                   	push   %edx
8010443b:	ff 73 a4             	push   -0x5c(%ebx)
8010443e:	68 8f 7a 10 80       	push   $0x80107a8f
80104443:	e8 58 c2 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104448:	83 c4 10             	add    $0x10,%esp
8010444b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010444f:	75 a7                	jne    801043f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104451:	83 ec 08             	sub    $0x8,%esp
80104454:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104457:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010445a:	50                   	push   %eax
8010445b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010445e:	8b 40 0c             	mov    0xc(%eax),%eax
80104461:	83 c0 08             	add    $0x8,%eax
80104464:	50                   	push   %eax
80104465:	e8 86 01 00 00       	call   801045f0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010446a:	83 c4 10             	add    $0x10,%esp
8010446d:	8d 76 00             	lea    0x0(%esi),%esi
80104470:	8b 17                	mov    (%edi),%edx
80104472:	85 d2                	test   %edx,%edx
80104474:	74 82                	je     801043f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104476:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104479:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010447c:	52                   	push   %edx
8010447d:	68 e1 74 10 80       	push   $0x801074e1
80104482:	e8 19 c2 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104487:	83 c4 10             	add    $0x10,%esp
8010448a:	39 fe                	cmp    %edi,%esi
8010448c:	75 e2                	jne    80104470 <procdump+0x90>
8010448e:	e9 65 ff ff ff       	jmp    801043f8 <procdump+0x18>
80104493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104497:	90                   	nop
  }
}
80104498:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010449b:	5b                   	pop    %ebx
8010449c:	5e                   	pop    %esi
8010449d:	5f                   	pop    %edi
8010449e:	5d                   	pop    %ebp
8010449f:	c3                   	ret    

801044a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	53                   	push   %ebx
801044a4:	83 ec 0c             	sub    $0xc,%esp
801044a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044aa:	68 04 7b 10 80       	push   $0x80107b04
801044af:	8d 43 04             	lea    0x4(%ebx),%eax
801044b2:	50                   	push   %eax
801044b3:	e8 18 01 00 00       	call   801045d0 <initlock>
  lk->name = name;
801044b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801044bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801044c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801044c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801044cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801044ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044d1:	c9                   	leave  
801044d2:	c3                   	ret    
801044d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	56                   	push   %esi
801044e4:	53                   	push   %ebx
801044e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044e8:	8d 73 04             	lea    0x4(%ebx),%esi
801044eb:	83 ec 0c             	sub    $0xc,%esp
801044ee:	56                   	push   %esi
801044ef:	e8 ac 02 00 00       	call   801047a0 <acquire>
  while (lk->locked) {
801044f4:	8b 13                	mov    (%ebx),%edx
801044f6:	83 c4 10             	add    $0x10,%esp
801044f9:	85 d2                	test   %edx,%edx
801044fb:	74 16                	je     80104513 <acquiresleep+0x33>
801044fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104500:	83 ec 08             	sub    $0x8,%esp
80104503:	56                   	push   %esi
80104504:	53                   	push   %ebx
80104505:	e8 36 fd ff ff       	call   80104240 <sleep>
  while (lk->locked) {
8010450a:	8b 03                	mov    (%ebx),%eax
8010450c:	83 c4 10             	add    $0x10,%esp
8010450f:	85 c0                	test   %eax,%eax
80104511:	75 ed                	jne    80104500 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104513:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104519:	e8 52 f6 ff ff       	call   80103b70 <myproc>
8010451e:	8b 40 10             	mov    0x10(%eax),%eax
80104521:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104524:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104527:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010452a:	5b                   	pop    %ebx
8010452b:	5e                   	pop    %esi
8010452c:	5d                   	pop    %ebp
  release(&lk->lk);
8010452d:	e9 0e 02 00 00       	jmp    80104740 <release>
80104532:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104540 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	56                   	push   %esi
80104544:	53                   	push   %ebx
80104545:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104548:	8d 73 04             	lea    0x4(%ebx),%esi
8010454b:	83 ec 0c             	sub    $0xc,%esp
8010454e:	56                   	push   %esi
8010454f:	e8 4c 02 00 00       	call   801047a0 <acquire>
  lk->locked = 0;
80104554:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010455a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104561:	89 1c 24             	mov    %ebx,(%esp)
80104564:	e8 97 fd ff ff       	call   80104300 <wakeup>
  release(&lk->lk);
80104569:	89 75 08             	mov    %esi,0x8(%ebp)
8010456c:	83 c4 10             	add    $0x10,%esp
}
8010456f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104572:	5b                   	pop    %ebx
80104573:	5e                   	pop    %esi
80104574:	5d                   	pop    %ebp
  release(&lk->lk);
80104575:	e9 c6 01 00 00       	jmp    80104740 <release>
8010457a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104580 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	57                   	push   %edi
80104584:	31 ff                	xor    %edi,%edi
80104586:	56                   	push   %esi
80104587:	53                   	push   %ebx
80104588:	83 ec 18             	sub    $0x18,%esp
8010458b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010458e:	8d 73 04             	lea    0x4(%ebx),%esi
80104591:	56                   	push   %esi
80104592:	e8 09 02 00 00       	call   801047a0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104597:	8b 03                	mov    (%ebx),%eax
80104599:	83 c4 10             	add    $0x10,%esp
8010459c:	85 c0                	test   %eax,%eax
8010459e:	75 18                	jne    801045b8 <holdingsleep+0x38>
  release(&lk->lk);
801045a0:	83 ec 0c             	sub    $0xc,%esp
801045a3:	56                   	push   %esi
801045a4:	e8 97 01 00 00       	call   80104740 <release>
  return r;
}
801045a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045ac:	89 f8                	mov    %edi,%eax
801045ae:	5b                   	pop    %ebx
801045af:	5e                   	pop    %esi
801045b0:	5f                   	pop    %edi
801045b1:	5d                   	pop    %ebp
801045b2:	c3                   	ret    
801045b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045b7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801045b8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801045bb:	e8 b0 f5 ff ff       	call   80103b70 <myproc>
801045c0:	39 58 10             	cmp    %ebx,0x10(%eax)
801045c3:	0f 94 c0             	sete   %al
801045c6:	0f b6 c0             	movzbl %al,%eax
801045c9:	89 c7                	mov    %eax,%edi
801045cb:	eb d3                	jmp    801045a0 <holdingsleep+0x20>
801045cd:	66 90                	xchg   %ax,%ax
801045cf:	90                   	nop

801045d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801045d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801045d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801045df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801045e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801045e9:	5d                   	pop    %ebp
801045ea:	c3                   	ret    
801045eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045ef:	90                   	nop

801045f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801045f0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801045f1:	31 d2                	xor    %edx,%edx
{
801045f3:	89 e5                	mov    %esp,%ebp
801045f5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801045f6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801045f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801045fc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801045ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104600:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104606:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010460c:	77 1a                	ja     80104628 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010460e:	8b 58 04             	mov    0x4(%eax),%ebx
80104611:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104614:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104617:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104619:	83 fa 0a             	cmp    $0xa,%edx
8010461c:	75 e2                	jne    80104600 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010461e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104621:	c9                   	leave  
80104622:	c3                   	ret    
80104623:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104627:	90                   	nop
  for(; i < 10; i++)
80104628:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010462b:	8d 51 28             	lea    0x28(%ecx),%edx
8010462e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104630:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104636:	83 c0 04             	add    $0x4,%eax
80104639:	39 d0                	cmp    %edx,%eax
8010463b:	75 f3                	jne    80104630 <getcallerpcs+0x40>
}
8010463d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104640:	c9                   	leave  
80104641:	c3                   	ret    
80104642:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104650 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	53                   	push   %ebx
80104654:	83 ec 04             	sub    $0x4,%esp
80104657:	9c                   	pushf  
80104658:	5b                   	pop    %ebx
  asm volatile("cli");
80104659:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010465a:	e8 91 f4 ff ff       	call   80103af0 <mycpu>
8010465f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104665:	85 c0                	test   %eax,%eax
80104667:	74 17                	je     80104680 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104669:	e8 82 f4 ff ff       	call   80103af0 <mycpu>
8010466e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104675:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104678:	c9                   	leave  
80104679:	c3                   	ret    
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104680:	e8 6b f4 ff ff       	call   80103af0 <mycpu>
80104685:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010468b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104691:	eb d6                	jmp    80104669 <pushcli+0x19>
80104693:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010469a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046a0 <popcli>:

void
popcli(void)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046a6:	9c                   	pushf  
801046a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046a8:	f6 c4 02             	test   $0x2,%ah
801046ab:	75 35                	jne    801046e2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801046ad:	e8 3e f4 ff ff       	call   80103af0 <mycpu>
801046b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801046b9:	78 34                	js     801046ef <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046bb:	e8 30 f4 ff ff       	call   80103af0 <mycpu>
801046c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046c6:	85 d2                	test   %edx,%edx
801046c8:	74 06                	je     801046d0 <popcli+0x30>
    sti();
}
801046ca:	c9                   	leave  
801046cb:	c3                   	ret    
801046cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046d0:	e8 1b f4 ff ff       	call   80103af0 <mycpu>
801046d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046db:	85 c0                	test   %eax,%eax
801046dd:	74 eb                	je     801046ca <popcli+0x2a>
  asm volatile("sti");
801046df:	fb                   	sti    
}
801046e0:	c9                   	leave  
801046e1:	c3                   	ret    
    panic("popcli - interruptible");
801046e2:	83 ec 0c             	sub    $0xc,%esp
801046e5:	68 0f 7b 10 80       	push   $0x80107b0f
801046ea:	e8 91 bc ff ff       	call   80100380 <panic>
    panic("popcli");
801046ef:	83 ec 0c             	sub    $0xc,%esp
801046f2:	68 26 7b 10 80       	push   $0x80107b26
801046f7:	e8 84 bc ff ff       	call   80100380 <panic>
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104700 <holding>:
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	56                   	push   %esi
80104704:	53                   	push   %ebx
80104705:	8b 75 08             	mov    0x8(%ebp),%esi
80104708:	31 db                	xor    %ebx,%ebx
  pushcli();
8010470a:	e8 41 ff ff ff       	call   80104650 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010470f:	8b 06                	mov    (%esi),%eax
80104711:	85 c0                	test   %eax,%eax
80104713:	75 0b                	jne    80104720 <holding+0x20>
  popcli();
80104715:	e8 86 ff ff ff       	call   801046a0 <popcli>
}
8010471a:	89 d8                	mov    %ebx,%eax
8010471c:	5b                   	pop    %ebx
8010471d:	5e                   	pop    %esi
8010471e:	5d                   	pop    %ebp
8010471f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104720:	8b 5e 08             	mov    0x8(%esi),%ebx
80104723:	e8 c8 f3 ff ff       	call   80103af0 <mycpu>
80104728:	39 c3                	cmp    %eax,%ebx
8010472a:	0f 94 c3             	sete   %bl
  popcli();
8010472d:	e8 6e ff ff ff       	call   801046a0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104732:	0f b6 db             	movzbl %bl,%ebx
}
80104735:	89 d8                	mov    %ebx,%eax
80104737:	5b                   	pop    %ebx
80104738:	5e                   	pop    %esi
80104739:	5d                   	pop    %ebp
8010473a:	c3                   	ret    
8010473b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010473f:	90                   	nop

80104740 <release>:
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
80104745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104748:	e8 03 ff ff ff       	call   80104650 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010474d:	8b 03                	mov    (%ebx),%eax
8010474f:	85 c0                	test   %eax,%eax
80104751:	75 15                	jne    80104768 <release+0x28>
  popcli();
80104753:	e8 48 ff ff ff       	call   801046a0 <popcli>
    panic("release");
80104758:	83 ec 0c             	sub    $0xc,%esp
8010475b:	68 2d 7b 10 80       	push   $0x80107b2d
80104760:	e8 1b bc ff ff       	call   80100380 <panic>
80104765:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104768:	8b 73 08             	mov    0x8(%ebx),%esi
8010476b:	e8 80 f3 ff ff       	call   80103af0 <mycpu>
80104770:	39 c6                	cmp    %eax,%esi
80104772:	75 df                	jne    80104753 <release+0x13>
  popcli();
80104774:	e8 27 ff ff ff       	call   801046a0 <popcli>
  lk->pcs[0] = 0;
80104779:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104780:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104787:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010478c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104792:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104795:	5b                   	pop    %ebx
80104796:	5e                   	pop    %esi
80104797:	5d                   	pop    %ebp
  popcli();
80104798:	e9 03 ff ff ff       	jmp    801046a0 <popcli>
8010479d:	8d 76 00             	lea    0x0(%esi),%esi

801047a0 <acquire>:
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	53                   	push   %ebx
801047a4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801047a7:	e8 a4 fe ff ff       	call   80104650 <pushcli>
  if(holding(lk))
801047ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047af:	e8 9c fe ff ff       	call   80104650 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047b4:	8b 03                	mov    (%ebx),%eax
801047b6:	85 c0                	test   %eax,%eax
801047b8:	75 7e                	jne    80104838 <acquire+0x98>
  popcli();
801047ba:	e8 e1 fe ff ff       	call   801046a0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801047bf:	b9 01 00 00 00       	mov    $0x1,%ecx
801047c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801047c8:	8b 55 08             	mov    0x8(%ebp),%edx
801047cb:	89 c8                	mov    %ecx,%eax
801047cd:	f0 87 02             	lock xchg %eax,(%edx)
801047d0:	85 c0                	test   %eax,%eax
801047d2:	75 f4                	jne    801047c8 <acquire+0x28>
  __sync_synchronize();
801047d4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047dc:	e8 0f f3 ff ff       	call   80103af0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801047e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801047e4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801047e6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801047e9:	31 c0                	xor    %eax,%eax
801047eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047f0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801047f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047fc:	77 1a                	ja     80104818 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801047fe:	8b 5a 04             	mov    0x4(%edx),%ebx
80104801:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104805:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104808:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010480a:	83 f8 0a             	cmp    $0xa,%eax
8010480d:	75 e1                	jne    801047f0 <acquire+0x50>
}
8010480f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104812:	c9                   	leave  
80104813:	c3                   	ret    
80104814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104818:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010481c:	8d 51 34             	lea    0x34(%ecx),%edx
8010481f:	90                   	nop
    pcs[i] = 0;
80104820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104826:	83 c0 04             	add    $0x4,%eax
80104829:	39 c2                	cmp    %eax,%edx
8010482b:	75 f3                	jne    80104820 <acquire+0x80>
}
8010482d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104830:	c9                   	leave  
80104831:	c3                   	ret    
80104832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104838:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010483b:	e8 b0 f2 ff ff       	call   80103af0 <mycpu>
80104840:	39 c3                	cmp    %eax,%ebx
80104842:	0f 85 72 ff ff ff    	jne    801047ba <acquire+0x1a>
  popcli();
80104848:	e8 53 fe ff ff       	call   801046a0 <popcli>
    panic("acquire");
8010484d:	83 ec 0c             	sub    $0xc,%esp
80104850:	68 35 7b 10 80       	push   $0x80107b35
80104855:	e8 26 bb ff ff       	call   80100380 <panic>
8010485a:	66 90                	xchg   %ax,%ax
8010485c:	66 90                	xchg   %ax,%ax
8010485e:	66 90                	xchg   %ax,%ax

80104860 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	57                   	push   %edi
80104864:	8b 55 08             	mov    0x8(%ebp),%edx
80104867:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010486a:	53                   	push   %ebx
8010486b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010486e:	89 d7                	mov    %edx,%edi
80104870:	09 cf                	or     %ecx,%edi
80104872:	83 e7 03             	and    $0x3,%edi
80104875:	75 29                	jne    801048a0 <memset+0x40>
    c &= 0xFF;
80104877:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010487a:	c1 e0 18             	shl    $0x18,%eax
8010487d:	89 fb                	mov    %edi,%ebx
8010487f:	c1 e9 02             	shr    $0x2,%ecx
80104882:	c1 e3 10             	shl    $0x10,%ebx
80104885:	09 d8                	or     %ebx,%eax
80104887:	09 f8                	or     %edi,%eax
80104889:	c1 e7 08             	shl    $0x8,%edi
8010488c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010488e:	89 d7                	mov    %edx,%edi
80104890:	fc                   	cld    
80104891:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104893:	5b                   	pop    %ebx
80104894:	89 d0                	mov    %edx,%eax
80104896:	5f                   	pop    %edi
80104897:	5d                   	pop    %ebp
80104898:	c3                   	ret    
80104899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801048a0:	89 d7                	mov    %edx,%edi
801048a2:	fc                   	cld    
801048a3:	f3 aa                	rep stos %al,%es:(%edi)
801048a5:	5b                   	pop    %ebx
801048a6:	89 d0                	mov    %edx,%eax
801048a8:	5f                   	pop    %edi
801048a9:	5d                   	pop    %ebp
801048aa:	c3                   	ret    
801048ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048af:	90                   	nop

801048b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	8b 75 10             	mov    0x10(%ebp),%esi
801048b7:	8b 55 08             	mov    0x8(%ebp),%edx
801048ba:	53                   	push   %ebx
801048bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048be:	85 f6                	test   %esi,%esi
801048c0:	74 2e                	je     801048f0 <memcmp+0x40>
801048c2:	01 c6                	add    %eax,%esi
801048c4:	eb 14                	jmp    801048da <memcmp+0x2a>
801048c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048cd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801048d0:	83 c0 01             	add    $0x1,%eax
801048d3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801048d6:	39 f0                	cmp    %esi,%eax
801048d8:	74 16                	je     801048f0 <memcmp+0x40>
    if(*s1 != *s2)
801048da:	0f b6 0a             	movzbl (%edx),%ecx
801048dd:	0f b6 18             	movzbl (%eax),%ebx
801048e0:	38 d9                	cmp    %bl,%cl
801048e2:	74 ec                	je     801048d0 <memcmp+0x20>
      return *s1 - *s2;
801048e4:	0f b6 c1             	movzbl %cl,%eax
801048e7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801048e9:	5b                   	pop    %ebx
801048ea:	5e                   	pop    %esi
801048eb:	5d                   	pop    %ebp
801048ec:	c3                   	ret    
801048ed:	8d 76 00             	lea    0x0(%esi),%esi
801048f0:	5b                   	pop    %ebx
  return 0;
801048f1:	31 c0                	xor    %eax,%eax
}
801048f3:	5e                   	pop    %esi
801048f4:	5d                   	pop    %ebp
801048f5:	c3                   	ret    
801048f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fd:	8d 76 00             	lea    0x0(%esi),%esi

80104900 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	57                   	push   %edi
80104904:	8b 55 08             	mov    0x8(%ebp),%edx
80104907:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010490a:	56                   	push   %esi
8010490b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010490e:	39 d6                	cmp    %edx,%esi
80104910:	73 26                	jae    80104938 <memmove+0x38>
80104912:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104915:	39 fa                	cmp    %edi,%edx
80104917:	73 1f                	jae    80104938 <memmove+0x38>
80104919:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010491c:	85 c9                	test   %ecx,%ecx
8010491e:	74 0c                	je     8010492c <memmove+0x2c>
      *--d = *--s;
80104920:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104924:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104927:	83 e8 01             	sub    $0x1,%eax
8010492a:	73 f4                	jae    80104920 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010492c:	5e                   	pop    %esi
8010492d:	89 d0                	mov    %edx,%eax
8010492f:	5f                   	pop    %edi
80104930:	5d                   	pop    %ebp
80104931:	c3                   	ret    
80104932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104938:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010493b:	89 d7                	mov    %edx,%edi
8010493d:	85 c9                	test   %ecx,%ecx
8010493f:	74 eb                	je     8010492c <memmove+0x2c>
80104941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104948:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104949:	39 c6                	cmp    %eax,%esi
8010494b:	75 fb                	jne    80104948 <memmove+0x48>
}
8010494d:	5e                   	pop    %esi
8010494e:	89 d0                	mov    %edx,%eax
80104950:	5f                   	pop    %edi
80104951:	5d                   	pop    %ebp
80104952:	c3                   	ret    
80104953:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104960 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104960:	eb 9e                	jmp    80104900 <memmove>
80104962:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104970 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	56                   	push   %esi
80104974:	8b 75 10             	mov    0x10(%ebp),%esi
80104977:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010497a:	53                   	push   %ebx
8010497b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010497e:	85 f6                	test   %esi,%esi
80104980:	74 2e                	je     801049b0 <strncmp+0x40>
80104982:	01 d6                	add    %edx,%esi
80104984:	eb 18                	jmp    8010499e <strncmp+0x2e>
80104986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498d:	8d 76 00             	lea    0x0(%esi),%esi
80104990:	38 d8                	cmp    %bl,%al
80104992:	75 14                	jne    801049a8 <strncmp+0x38>
    n--, p++, q++;
80104994:	83 c2 01             	add    $0x1,%edx
80104997:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010499a:	39 f2                	cmp    %esi,%edx
8010499c:	74 12                	je     801049b0 <strncmp+0x40>
8010499e:	0f b6 01             	movzbl (%ecx),%eax
801049a1:	0f b6 1a             	movzbl (%edx),%ebx
801049a4:	84 c0                	test   %al,%al
801049a6:	75 e8                	jne    80104990 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801049a8:	29 d8                	sub    %ebx,%eax
}
801049aa:	5b                   	pop    %ebx
801049ab:	5e                   	pop    %esi
801049ac:	5d                   	pop    %ebp
801049ad:	c3                   	ret    
801049ae:	66 90                	xchg   %ax,%ax
801049b0:	5b                   	pop    %ebx
    return 0;
801049b1:	31 c0                	xor    %eax,%eax
}
801049b3:	5e                   	pop    %esi
801049b4:	5d                   	pop    %ebp
801049b5:	c3                   	ret    
801049b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049bd:	8d 76 00             	lea    0x0(%esi),%esi

801049c0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	57                   	push   %edi
801049c4:	56                   	push   %esi
801049c5:	8b 75 08             	mov    0x8(%ebp),%esi
801049c8:	53                   	push   %ebx
801049c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801049cc:	89 f0                	mov    %esi,%eax
801049ce:	eb 15                	jmp    801049e5 <strncpy+0x25>
801049d0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801049d4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801049d7:	83 c0 01             	add    $0x1,%eax
801049da:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
801049de:	88 50 ff             	mov    %dl,-0x1(%eax)
801049e1:	84 d2                	test   %dl,%dl
801049e3:	74 09                	je     801049ee <strncpy+0x2e>
801049e5:	89 cb                	mov    %ecx,%ebx
801049e7:	83 e9 01             	sub    $0x1,%ecx
801049ea:	85 db                	test   %ebx,%ebx
801049ec:	7f e2                	jg     801049d0 <strncpy+0x10>
    ;
  while(n-- > 0)
801049ee:	89 c2                	mov    %eax,%edx
801049f0:	85 c9                	test   %ecx,%ecx
801049f2:	7e 17                	jle    80104a0b <strncpy+0x4b>
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801049f8:	83 c2 01             	add    $0x1,%edx
801049fb:	89 c1                	mov    %eax,%ecx
801049fd:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104a01:	29 d1                	sub    %edx,%ecx
80104a03:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104a07:	85 c9                	test   %ecx,%ecx
80104a09:	7f ed                	jg     801049f8 <strncpy+0x38>
  return os;
}
80104a0b:	5b                   	pop    %ebx
80104a0c:	89 f0                	mov    %esi,%eax
80104a0e:	5e                   	pop    %esi
80104a0f:	5f                   	pop    %edi
80104a10:	5d                   	pop    %ebp
80104a11:	c3                   	ret    
80104a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	8b 55 10             	mov    0x10(%ebp),%edx
80104a27:	8b 75 08             	mov    0x8(%ebp),%esi
80104a2a:	53                   	push   %ebx
80104a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a2e:	85 d2                	test   %edx,%edx
80104a30:	7e 25                	jle    80104a57 <safestrcpy+0x37>
80104a32:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a36:	89 f2                	mov    %esi,%edx
80104a38:	eb 16                	jmp    80104a50 <safestrcpy+0x30>
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a40:	0f b6 08             	movzbl (%eax),%ecx
80104a43:	83 c0 01             	add    $0x1,%eax
80104a46:	83 c2 01             	add    $0x1,%edx
80104a49:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a4c:	84 c9                	test   %cl,%cl
80104a4e:	74 04                	je     80104a54 <safestrcpy+0x34>
80104a50:	39 d8                	cmp    %ebx,%eax
80104a52:	75 ec                	jne    80104a40 <safestrcpy+0x20>
    ;
  *s = 0;
80104a54:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a57:	89 f0                	mov    %esi,%eax
80104a59:	5b                   	pop    %ebx
80104a5a:	5e                   	pop    %esi
80104a5b:	5d                   	pop    %ebp
80104a5c:	c3                   	ret    
80104a5d:	8d 76 00             	lea    0x0(%esi),%esi

80104a60 <strlen>:

int
strlen(const char *s)
{
80104a60:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a61:	31 c0                	xor    %eax,%eax
{
80104a63:	89 e5                	mov    %esp,%ebp
80104a65:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a68:	80 3a 00             	cmpb   $0x0,(%edx)
80104a6b:	74 0c                	je     80104a79 <strlen+0x19>
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi
80104a70:	83 c0 01             	add    $0x1,%eax
80104a73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a77:	75 f7                	jne    80104a70 <strlen+0x10>
    ;
  return n;
}
80104a79:	5d                   	pop    %ebp
80104a7a:	c3                   	ret    

80104a7b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a7b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a7f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a83:	55                   	push   %ebp
  pushl %ebx
80104a84:	53                   	push   %ebx
  pushl %esi
80104a85:	56                   	push   %esi
  pushl %edi
80104a86:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a87:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a89:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a8b:	5f                   	pop    %edi
  popl %esi
80104a8c:	5e                   	pop    %esi
  popl %ebx
80104a8d:	5b                   	pop    %ebx
  popl %ebp
80104a8e:	5d                   	pop    %ebp
  ret
80104a8f:	c3                   	ret    

80104a90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 04             	sub    $0x4,%esp
80104a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a9a:	e8 d1 f0 ff ff       	call   80103b70 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a9f:	8b 00                	mov    (%eax),%eax
80104aa1:	39 d8                	cmp    %ebx,%eax
80104aa3:	76 1b                	jbe    80104ac0 <fetchint+0x30>
80104aa5:	8d 53 04             	lea    0x4(%ebx),%edx
80104aa8:	39 d0                	cmp    %edx,%eax
80104aaa:	72 14                	jb     80104ac0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104aac:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aaf:	8b 13                	mov    (%ebx),%edx
80104ab1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ab3:	31 c0                	xor    %eax,%eax
}
80104ab5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab8:	c9                   	leave  
80104ab9:	c3                   	ret    
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ac5:	eb ee                	jmp    80104ab5 <fetchint+0x25>
80104ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ace:	66 90                	xchg   %ax,%ax

80104ad0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	53                   	push   %ebx
80104ad4:	83 ec 04             	sub    $0x4,%esp
80104ad7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104ada:	e8 91 f0 ff ff       	call   80103b70 <myproc>

  if(addr >= curproc->sz)
80104adf:	39 18                	cmp    %ebx,(%eax)
80104ae1:	76 2d                	jbe    80104b10 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104ae3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ae6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ae8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104aea:	39 d3                	cmp    %edx,%ebx
80104aec:	73 22                	jae    80104b10 <fetchstr+0x40>
80104aee:	89 d8                	mov    %ebx,%eax
80104af0:	eb 0d                	jmp    80104aff <fetchstr+0x2f>
80104af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104af8:	83 c0 01             	add    $0x1,%eax
80104afb:	39 c2                	cmp    %eax,%edx
80104afd:	76 11                	jbe    80104b10 <fetchstr+0x40>
    if(*s == 0)
80104aff:	80 38 00             	cmpb   $0x0,(%eax)
80104b02:	75 f4                	jne    80104af8 <fetchstr+0x28>
      return s - *pp;
80104b04:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b09:	c9                   	leave  
80104b0a:	c3                   	ret    
80104b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b0f:	90                   	nop
80104b10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b18:	c9                   	leave  
80104b19:	c3                   	ret    
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b25:	e8 46 f0 ff ff       	call   80103b70 <myproc>
80104b2a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b2d:	8b 40 18             	mov    0x18(%eax),%eax
80104b30:	8b 40 44             	mov    0x44(%eax),%eax
80104b33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b36:	e8 35 f0 ff ff       	call   80103b70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b3b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b3e:	8b 00                	mov    (%eax),%eax
80104b40:	39 c6                	cmp    %eax,%esi
80104b42:	73 1c                	jae    80104b60 <argint+0x40>
80104b44:	8d 53 08             	lea    0x8(%ebx),%edx
80104b47:	39 d0                	cmp    %edx,%eax
80104b49:	72 15                	jb     80104b60 <argint+0x40>
  *ip = *(int*)(addr);
80104b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b4e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b51:	89 10                	mov    %edx,(%eax)
  return 0;
80104b53:	31 c0                	xor    %eax,%eax
}
80104b55:	5b                   	pop    %ebx
80104b56:	5e                   	pop    %esi
80104b57:	5d                   	pop    %ebp
80104b58:	c3                   	ret    
80104b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b65:	eb ee                	jmp    80104b55 <argint+0x35>
80104b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6e:	66 90                	xchg   %ax,%ax

80104b70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	57                   	push   %edi
80104b74:	56                   	push   %esi
80104b75:	53                   	push   %ebx
80104b76:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104b79:	e8 f2 ef ff ff       	call   80103b70 <myproc>
80104b7e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b80:	e8 eb ef ff ff       	call   80103b70 <myproc>
80104b85:	8b 55 08             	mov    0x8(%ebp),%edx
80104b88:	8b 40 18             	mov    0x18(%eax),%eax
80104b8b:	8b 40 44             	mov    0x44(%eax),%eax
80104b8e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b91:	e8 da ef ff ff       	call   80103b70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b96:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b99:	8b 00                	mov    (%eax),%eax
80104b9b:	39 c7                	cmp    %eax,%edi
80104b9d:	73 31                	jae    80104bd0 <argptr+0x60>
80104b9f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104ba2:	39 c8                	cmp    %ecx,%eax
80104ba4:	72 2a                	jb     80104bd0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ba6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104ba9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bac:	85 d2                	test   %edx,%edx
80104bae:	78 20                	js     80104bd0 <argptr+0x60>
80104bb0:	8b 16                	mov    (%esi),%edx
80104bb2:	39 c2                	cmp    %eax,%edx
80104bb4:	76 1a                	jbe    80104bd0 <argptr+0x60>
80104bb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104bb9:	01 c3                	add    %eax,%ebx
80104bbb:	39 da                	cmp    %ebx,%edx
80104bbd:	72 11                	jb     80104bd0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104bbf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bc2:	89 02                	mov    %eax,(%edx)
  return 0;
80104bc4:	31 c0                	xor    %eax,%eax
}
80104bc6:	83 c4 0c             	add    $0xc,%esp
80104bc9:	5b                   	pop    %ebx
80104bca:	5e                   	pop    %esi
80104bcb:	5f                   	pop    %edi
80104bcc:	5d                   	pop    %ebp
80104bcd:	c3                   	ret    
80104bce:	66 90                	xchg   %ax,%ax
    return -1;
80104bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bd5:	eb ef                	jmp    80104bc6 <argptr+0x56>
80104bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bde:	66 90                	xchg   %ax,%ax

80104be0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	56                   	push   %esi
80104be4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104be5:	e8 86 ef ff ff       	call   80103b70 <myproc>
80104bea:	8b 55 08             	mov    0x8(%ebp),%edx
80104bed:	8b 40 18             	mov    0x18(%eax),%eax
80104bf0:	8b 40 44             	mov    0x44(%eax),%eax
80104bf3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bf6:	e8 75 ef ff ff       	call   80103b70 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bfb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bfe:	8b 00                	mov    (%eax),%eax
80104c00:	39 c6                	cmp    %eax,%esi
80104c02:	73 44                	jae    80104c48 <argstr+0x68>
80104c04:	8d 53 08             	lea    0x8(%ebx),%edx
80104c07:	39 d0                	cmp    %edx,%eax
80104c09:	72 3d                	jb     80104c48 <argstr+0x68>
  *ip = *(int*)(addr);
80104c0b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c0e:	e8 5d ef ff ff       	call   80103b70 <myproc>
  if(addr >= curproc->sz)
80104c13:	3b 18                	cmp    (%eax),%ebx
80104c15:	73 31                	jae    80104c48 <argstr+0x68>
  *pp = (char*)addr;
80104c17:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c1a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c1c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c1e:	39 d3                	cmp    %edx,%ebx
80104c20:	73 26                	jae    80104c48 <argstr+0x68>
80104c22:	89 d8                	mov    %ebx,%eax
80104c24:	eb 11                	jmp    80104c37 <argstr+0x57>
80104c26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2d:	8d 76 00             	lea    0x0(%esi),%esi
80104c30:	83 c0 01             	add    $0x1,%eax
80104c33:	39 c2                	cmp    %eax,%edx
80104c35:	76 11                	jbe    80104c48 <argstr+0x68>
    if(*s == 0)
80104c37:	80 38 00             	cmpb   $0x0,(%eax)
80104c3a:	75 f4                	jne    80104c30 <argstr+0x50>
      return s - *pp;
80104c3c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c3e:	5b                   	pop    %ebx
80104c3f:	5e                   	pop    %esi
80104c40:	5d                   	pop    %ebp
80104c41:	c3                   	ret    
80104c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c48:	5b                   	pop    %ebx
    return -1;
80104c49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c4e:	5e                   	pop    %esi
80104c4f:	5d                   	pop    %ebp
80104c50:	c3                   	ret    
80104c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5f:	90                   	nop

80104c60 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	53                   	push   %ebx
80104c64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c67:	e8 04 ef ff ff       	call   80103b70 <myproc>
80104c6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c6e:	8b 40 18             	mov    0x18(%eax),%eax
80104c71:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c77:	83 fa 14             	cmp    $0x14,%edx
80104c7a:	77 24                	ja     80104ca0 <syscall+0x40>
80104c7c:	8b 14 85 60 7b 10 80 	mov    -0x7fef84a0(,%eax,4),%edx
80104c83:	85 d2                	test   %edx,%edx
80104c85:	74 19                	je     80104ca0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c87:	ff d2                	call   *%edx
80104c89:	89 c2                	mov    %eax,%edx
80104c8b:	8b 43 18             	mov    0x18(%ebx),%eax
80104c8e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c94:	c9                   	leave  
80104c95:	c3                   	ret    
80104c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ca0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ca1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104ca4:	50                   	push   %eax
80104ca5:	ff 73 10             	push   0x10(%ebx)
80104ca8:	68 3d 7b 10 80       	push   $0x80107b3d
80104cad:	e8 ee b9 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104cb2:	8b 43 18             	mov    0x18(%ebx),%eax
80104cb5:	83 c4 10             	add    $0x10,%esp
80104cb8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104cbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cc2:	c9                   	leave  
80104cc3:	c3                   	ret    
80104cc4:	66 90                	xchg   %ax,%ax
80104cc6:	66 90                	xchg   %ax,%ax
80104cc8:	66 90                	xchg   %ax,%ax
80104cca:	66 90                	xchg   %ax,%ax
80104ccc:	66 90                	xchg   %ax,%ax
80104cce:	66 90                	xchg   %ax,%ax

80104cd0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104cd5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104cd8:	53                   	push   %ebx
80104cd9:	83 ec 34             	sub    $0x34,%esp
80104cdc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104cdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104ce2:	57                   	push   %edi
80104ce3:	50                   	push   %eax
{
80104ce4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ce7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104cea:	e8 d1 d3 ff ff       	call   801020c0 <nameiparent>
80104cef:	83 c4 10             	add    $0x10,%esp
80104cf2:	85 c0                	test   %eax,%eax
80104cf4:	0f 84 46 01 00 00    	je     80104e40 <create+0x170>
    return 0;
  ilock(dp);
80104cfa:	83 ec 0c             	sub    $0xc,%esp
80104cfd:	89 c3                	mov    %eax,%ebx
80104cff:	50                   	push   %eax
80104d00:	e8 7b ca ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104d05:	83 c4 0c             	add    $0xc,%esp
80104d08:	6a 00                	push   $0x0
80104d0a:	57                   	push   %edi
80104d0b:	53                   	push   %ebx
80104d0c:	e8 cf cf ff ff       	call   80101ce0 <dirlookup>
80104d11:	83 c4 10             	add    $0x10,%esp
80104d14:	89 c6                	mov    %eax,%esi
80104d16:	85 c0                	test   %eax,%eax
80104d18:	74 56                	je     80104d70 <create+0xa0>
    iunlockput(dp);
80104d1a:	83 ec 0c             	sub    $0xc,%esp
80104d1d:	53                   	push   %ebx
80104d1e:	e8 ed cc ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104d23:	89 34 24             	mov    %esi,(%esp)
80104d26:	e8 55 ca ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d2b:	83 c4 10             	add    $0x10,%esp
80104d2e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d33:	75 1b                	jne    80104d50 <create+0x80>
80104d35:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d3a:	75 14                	jne    80104d50 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d3f:	89 f0                	mov    %esi,%eax
80104d41:	5b                   	pop    %ebx
80104d42:	5e                   	pop    %esi
80104d43:	5f                   	pop    %edi
80104d44:	5d                   	pop    %ebp
80104d45:	c3                   	ret    
80104d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d50:	83 ec 0c             	sub    $0xc,%esp
80104d53:	56                   	push   %esi
    return 0;
80104d54:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104d56:	e8 b5 cc ff ff       	call   80101a10 <iunlockput>
    return 0;
80104d5b:	83 c4 10             	add    $0x10,%esp
}
80104d5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d61:	89 f0                	mov    %esi,%eax
80104d63:	5b                   	pop    %ebx
80104d64:	5e                   	pop    %esi
80104d65:	5f                   	pop    %edi
80104d66:	5d                   	pop    %ebp
80104d67:	c3                   	ret    
80104d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104d70:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d74:	83 ec 08             	sub    $0x8,%esp
80104d77:	50                   	push   %eax
80104d78:	ff 33                	push   (%ebx)
80104d7a:	e8 91 c8 ff ff       	call   80101610 <ialloc>
80104d7f:	83 c4 10             	add    $0x10,%esp
80104d82:	89 c6                	mov    %eax,%esi
80104d84:	85 c0                	test   %eax,%eax
80104d86:	0f 84 cd 00 00 00    	je     80104e59 <create+0x189>
  ilock(ip);
80104d8c:	83 ec 0c             	sub    $0xc,%esp
80104d8f:	50                   	push   %eax
80104d90:	e8 eb c9 ff ff       	call   80101780 <ilock>
  ip->major = major;
80104d95:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d99:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d9d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104da1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104da5:	b8 01 00 00 00       	mov    $0x1,%eax
80104daa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104dae:	89 34 24             	mov    %esi,(%esp)
80104db1:	e8 1a c9 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104db6:	83 c4 10             	add    $0x10,%esp
80104db9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104dbe:	74 30                	je     80104df0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104dc0:	83 ec 04             	sub    $0x4,%esp
80104dc3:	ff 76 04             	push   0x4(%esi)
80104dc6:	57                   	push   %edi
80104dc7:	53                   	push   %ebx
80104dc8:	e8 13 d2 ff ff       	call   80101fe0 <dirlink>
80104dcd:	83 c4 10             	add    $0x10,%esp
80104dd0:	85 c0                	test   %eax,%eax
80104dd2:	78 78                	js     80104e4c <create+0x17c>
  iunlockput(dp);
80104dd4:	83 ec 0c             	sub    $0xc,%esp
80104dd7:	53                   	push   %ebx
80104dd8:	e8 33 cc ff ff       	call   80101a10 <iunlockput>
  return ip;
80104ddd:	83 c4 10             	add    $0x10,%esp
}
80104de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104de3:	89 f0                	mov    %esi,%eax
80104de5:	5b                   	pop    %ebx
80104de6:	5e                   	pop    %esi
80104de7:	5f                   	pop    %edi
80104de8:	5d                   	pop    %ebp
80104de9:	c3                   	ret    
80104dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104df0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104df3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104df8:	53                   	push   %ebx
80104df9:	e8 d2 c8 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dfe:	83 c4 0c             	add    $0xc,%esp
80104e01:	ff 76 04             	push   0x4(%esi)
80104e04:	68 d4 7b 10 80       	push   $0x80107bd4
80104e09:	56                   	push   %esi
80104e0a:	e8 d1 d1 ff ff       	call   80101fe0 <dirlink>
80104e0f:	83 c4 10             	add    $0x10,%esp
80104e12:	85 c0                	test   %eax,%eax
80104e14:	78 18                	js     80104e2e <create+0x15e>
80104e16:	83 ec 04             	sub    $0x4,%esp
80104e19:	ff 73 04             	push   0x4(%ebx)
80104e1c:	68 d3 7b 10 80       	push   $0x80107bd3
80104e21:	56                   	push   %esi
80104e22:	e8 b9 d1 ff ff       	call   80101fe0 <dirlink>
80104e27:	83 c4 10             	add    $0x10,%esp
80104e2a:	85 c0                	test   %eax,%eax
80104e2c:	79 92                	jns    80104dc0 <create+0xf0>
      panic("create dots");
80104e2e:	83 ec 0c             	sub    $0xc,%esp
80104e31:	68 c7 7b 10 80       	push   $0x80107bc7
80104e36:	e8 45 b5 ff ff       	call   80100380 <panic>
80104e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e3f:	90                   	nop
}
80104e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e43:	31 f6                	xor    %esi,%esi
}
80104e45:	5b                   	pop    %ebx
80104e46:	89 f0                	mov    %esi,%eax
80104e48:	5e                   	pop    %esi
80104e49:	5f                   	pop    %edi
80104e4a:	5d                   	pop    %ebp
80104e4b:	c3                   	ret    
    panic("create: dirlink");
80104e4c:	83 ec 0c             	sub    $0xc,%esp
80104e4f:	68 d6 7b 10 80       	push   $0x80107bd6
80104e54:	e8 27 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e59:	83 ec 0c             	sub    $0xc,%esp
80104e5c:	68 b8 7b 10 80       	push   $0x80107bb8
80104e61:	e8 1a b5 ff ff       	call   80100380 <panic>
80104e66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6d:	8d 76 00             	lea    0x0(%esi),%esi

80104e70 <sys_dup>:
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	56                   	push   %esi
80104e74:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e75:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e78:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e7b:	50                   	push   %eax
80104e7c:	6a 00                	push   $0x0
80104e7e:	e8 9d fc ff ff       	call   80104b20 <argint>
80104e83:	83 c4 10             	add    $0x10,%esp
80104e86:	85 c0                	test   %eax,%eax
80104e88:	78 36                	js     80104ec0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e8a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e8e:	77 30                	ja     80104ec0 <sys_dup+0x50>
80104e90:	e8 db ec ff ff       	call   80103b70 <myproc>
80104e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e98:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e9c:	85 f6                	test   %esi,%esi
80104e9e:	74 20                	je     80104ec0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104ea0:	e8 cb ec ff ff       	call   80103b70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ea5:	31 db                	xor    %ebx,%ebx
80104ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104eb0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104eb4:	85 d2                	test   %edx,%edx
80104eb6:	74 18                	je     80104ed0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104eb8:	83 c3 01             	add    $0x1,%ebx
80104ebb:	83 fb 10             	cmp    $0x10,%ebx
80104ebe:	75 f0                	jne    80104eb0 <sys_dup+0x40>
}
80104ec0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104ec3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ec8:	89 d8                	mov    %ebx,%eax
80104eca:	5b                   	pop    %ebx
80104ecb:	5e                   	pop    %esi
80104ecc:	5d                   	pop    %ebp
80104ecd:	c3                   	ret    
80104ece:	66 90                	xchg   %ax,%ax
  filedup(f);
80104ed0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104ed3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104ed7:	56                   	push   %esi
80104ed8:	e8 c3 bf ff ff       	call   80100ea0 <filedup>
  return fd;
80104edd:	83 c4 10             	add    $0x10,%esp
}
80104ee0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ee3:	89 d8                	mov    %ebx,%eax
80104ee5:	5b                   	pop    %ebx
80104ee6:	5e                   	pop    %esi
80104ee7:	5d                   	pop    %ebp
80104ee8:	c3                   	ret    
80104ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ef0 <sys_read>:
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	56                   	push   %esi
80104ef4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ef5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ef8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104efb:	53                   	push   %ebx
80104efc:	6a 00                	push   $0x0
80104efe:	e8 1d fc ff ff       	call   80104b20 <argint>
80104f03:	83 c4 10             	add    $0x10,%esp
80104f06:	85 c0                	test   %eax,%eax
80104f08:	78 5e                	js     80104f68 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f0a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f0e:	77 58                	ja     80104f68 <sys_read+0x78>
80104f10:	e8 5b ec ff ff       	call   80103b70 <myproc>
80104f15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f18:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f1c:	85 f6                	test   %esi,%esi
80104f1e:	74 48                	je     80104f68 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f20:	83 ec 08             	sub    $0x8,%esp
80104f23:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f26:	50                   	push   %eax
80104f27:	6a 02                	push   $0x2
80104f29:	e8 f2 fb ff ff       	call   80104b20 <argint>
80104f2e:	83 c4 10             	add    $0x10,%esp
80104f31:	85 c0                	test   %eax,%eax
80104f33:	78 33                	js     80104f68 <sys_read+0x78>
80104f35:	83 ec 04             	sub    $0x4,%esp
80104f38:	ff 75 f0             	push   -0x10(%ebp)
80104f3b:	53                   	push   %ebx
80104f3c:	6a 01                	push   $0x1
80104f3e:	e8 2d fc ff ff       	call   80104b70 <argptr>
80104f43:	83 c4 10             	add    $0x10,%esp
80104f46:	85 c0                	test   %eax,%eax
80104f48:	78 1e                	js     80104f68 <sys_read+0x78>
  return fileread(f, p, n);
80104f4a:	83 ec 04             	sub    $0x4,%esp
80104f4d:	ff 75 f0             	push   -0x10(%ebp)
80104f50:	ff 75 f4             	push   -0xc(%ebp)
80104f53:	56                   	push   %esi
80104f54:	e8 c7 c0 ff ff       	call   80101020 <fileread>
80104f59:	83 c4 10             	add    $0x10,%esp
}
80104f5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f5f:	5b                   	pop    %ebx
80104f60:	5e                   	pop    %esi
80104f61:	5d                   	pop    %ebp
80104f62:	c3                   	ret    
80104f63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f67:	90                   	nop
    return -1;
80104f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f6d:	eb ed                	jmp    80104f5c <sys_read+0x6c>
80104f6f:	90                   	nop

80104f70 <sys_write>:
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	56                   	push   %esi
80104f74:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f75:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f78:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f7b:	53                   	push   %ebx
80104f7c:	6a 00                	push   $0x0
80104f7e:	e8 9d fb ff ff       	call   80104b20 <argint>
80104f83:	83 c4 10             	add    $0x10,%esp
80104f86:	85 c0                	test   %eax,%eax
80104f88:	78 5e                	js     80104fe8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f8a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f8e:	77 58                	ja     80104fe8 <sys_write+0x78>
80104f90:	e8 db eb ff ff       	call   80103b70 <myproc>
80104f95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f98:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f9c:	85 f6                	test   %esi,%esi
80104f9e:	74 48                	je     80104fe8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fa0:	83 ec 08             	sub    $0x8,%esp
80104fa3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fa6:	50                   	push   %eax
80104fa7:	6a 02                	push   $0x2
80104fa9:	e8 72 fb ff ff       	call   80104b20 <argint>
80104fae:	83 c4 10             	add    $0x10,%esp
80104fb1:	85 c0                	test   %eax,%eax
80104fb3:	78 33                	js     80104fe8 <sys_write+0x78>
80104fb5:	83 ec 04             	sub    $0x4,%esp
80104fb8:	ff 75 f0             	push   -0x10(%ebp)
80104fbb:	53                   	push   %ebx
80104fbc:	6a 01                	push   $0x1
80104fbe:	e8 ad fb ff ff       	call   80104b70 <argptr>
80104fc3:	83 c4 10             	add    $0x10,%esp
80104fc6:	85 c0                	test   %eax,%eax
80104fc8:	78 1e                	js     80104fe8 <sys_write+0x78>
  return filewrite(f, p, n);
80104fca:	83 ec 04             	sub    $0x4,%esp
80104fcd:	ff 75 f0             	push   -0x10(%ebp)
80104fd0:	ff 75 f4             	push   -0xc(%ebp)
80104fd3:	56                   	push   %esi
80104fd4:	e8 d7 c0 ff ff       	call   801010b0 <filewrite>
80104fd9:	83 c4 10             	add    $0x10,%esp
}
80104fdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fdf:	5b                   	pop    %ebx
80104fe0:	5e                   	pop    %esi
80104fe1:	5d                   	pop    %ebp
80104fe2:	c3                   	ret    
80104fe3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fe7:	90                   	nop
    return -1;
80104fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fed:	eb ed                	jmp    80104fdc <sys_write+0x6c>
80104fef:	90                   	nop

80104ff0 <sys_close>:
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ff5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ff8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ffb:	50                   	push   %eax
80104ffc:	6a 00                	push   $0x0
80104ffe:	e8 1d fb ff ff       	call   80104b20 <argint>
80105003:	83 c4 10             	add    $0x10,%esp
80105006:	85 c0                	test   %eax,%eax
80105008:	78 3e                	js     80105048 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010500a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010500e:	77 38                	ja     80105048 <sys_close+0x58>
80105010:	e8 5b eb ff ff       	call   80103b70 <myproc>
80105015:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105018:	8d 5a 08             	lea    0x8(%edx),%ebx
8010501b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010501f:	85 f6                	test   %esi,%esi
80105021:	74 25                	je     80105048 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105023:	e8 48 eb ff ff       	call   80103b70 <myproc>
  fileclose(f);
80105028:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010502b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105032:	00 
  fileclose(f);
80105033:	56                   	push   %esi
80105034:	e8 b7 be ff ff       	call   80100ef0 <fileclose>
  return 0;
80105039:	83 c4 10             	add    $0x10,%esp
8010503c:	31 c0                	xor    %eax,%eax
}
8010503e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105041:	5b                   	pop    %ebx
80105042:	5e                   	pop    %esi
80105043:	5d                   	pop    %ebp
80105044:	c3                   	ret    
80105045:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010504d:	eb ef                	jmp    8010503e <sys_close+0x4e>
8010504f:	90                   	nop

80105050 <sys_fstat>:
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	56                   	push   %esi
80105054:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105055:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105058:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010505b:	53                   	push   %ebx
8010505c:	6a 00                	push   $0x0
8010505e:	e8 bd fa ff ff       	call   80104b20 <argint>
80105063:	83 c4 10             	add    $0x10,%esp
80105066:	85 c0                	test   %eax,%eax
80105068:	78 46                	js     801050b0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010506a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010506e:	77 40                	ja     801050b0 <sys_fstat+0x60>
80105070:	e8 fb ea ff ff       	call   80103b70 <myproc>
80105075:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105078:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010507c:	85 f6                	test   %esi,%esi
8010507e:	74 30                	je     801050b0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105080:	83 ec 04             	sub    $0x4,%esp
80105083:	6a 14                	push   $0x14
80105085:	53                   	push   %ebx
80105086:	6a 01                	push   $0x1
80105088:	e8 e3 fa ff ff       	call   80104b70 <argptr>
8010508d:	83 c4 10             	add    $0x10,%esp
80105090:	85 c0                	test   %eax,%eax
80105092:	78 1c                	js     801050b0 <sys_fstat+0x60>
  return filestat(f, st);
80105094:	83 ec 08             	sub    $0x8,%esp
80105097:	ff 75 f4             	push   -0xc(%ebp)
8010509a:	56                   	push   %esi
8010509b:	e8 30 bf ff ff       	call   80100fd0 <filestat>
801050a0:	83 c4 10             	add    $0x10,%esp
}
801050a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050a6:	5b                   	pop    %ebx
801050a7:	5e                   	pop    %esi
801050a8:	5d                   	pop    %ebp
801050a9:	c3                   	ret    
801050aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050b5:	eb ec                	jmp    801050a3 <sys_fstat+0x53>
801050b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050be:	66 90                	xchg   %ax,%ax

801050c0 <sys_link>:
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	57                   	push   %edi
801050c4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050c5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050c8:	53                   	push   %ebx
801050c9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050cc:	50                   	push   %eax
801050cd:	6a 00                	push   $0x0
801050cf:	e8 0c fb ff ff       	call   80104be0 <argstr>
801050d4:	83 c4 10             	add    $0x10,%esp
801050d7:	85 c0                	test   %eax,%eax
801050d9:	0f 88 fb 00 00 00    	js     801051da <sys_link+0x11a>
801050df:	83 ec 08             	sub    $0x8,%esp
801050e2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050e5:	50                   	push   %eax
801050e6:	6a 01                	push   $0x1
801050e8:	e8 f3 fa ff ff       	call   80104be0 <argstr>
801050ed:	83 c4 10             	add    $0x10,%esp
801050f0:	85 c0                	test   %eax,%eax
801050f2:	0f 88 e2 00 00 00    	js     801051da <sys_link+0x11a>
  begin_op();
801050f8:	e8 63 de ff ff       	call   80102f60 <begin_op>
  if((ip = namei(old)) == 0){
801050fd:	83 ec 0c             	sub    $0xc,%esp
80105100:	ff 75 d4             	push   -0x2c(%ebp)
80105103:	e8 98 cf ff ff       	call   801020a0 <namei>
80105108:	83 c4 10             	add    $0x10,%esp
8010510b:	89 c3                	mov    %eax,%ebx
8010510d:	85 c0                	test   %eax,%eax
8010510f:	0f 84 e4 00 00 00    	je     801051f9 <sys_link+0x139>
  ilock(ip);
80105115:	83 ec 0c             	sub    $0xc,%esp
80105118:	50                   	push   %eax
80105119:	e8 62 c6 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
8010511e:	83 c4 10             	add    $0x10,%esp
80105121:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105126:	0f 84 b5 00 00 00    	je     801051e1 <sys_link+0x121>
  iupdate(ip);
8010512c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010512f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105134:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105137:	53                   	push   %ebx
80105138:	e8 93 c5 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010513d:	89 1c 24             	mov    %ebx,(%esp)
80105140:	e8 1b c7 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105145:	58                   	pop    %eax
80105146:	5a                   	pop    %edx
80105147:	57                   	push   %edi
80105148:	ff 75 d0             	push   -0x30(%ebp)
8010514b:	e8 70 cf ff ff       	call   801020c0 <nameiparent>
80105150:	83 c4 10             	add    $0x10,%esp
80105153:	89 c6                	mov    %eax,%esi
80105155:	85 c0                	test   %eax,%eax
80105157:	74 5b                	je     801051b4 <sys_link+0xf4>
  ilock(dp);
80105159:	83 ec 0c             	sub    $0xc,%esp
8010515c:	50                   	push   %eax
8010515d:	e8 1e c6 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105162:	8b 03                	mov    (%ebx),%eax
80105164:	83 c4 10             	add    $0x10,%esp
80105167:	39 06                	cmp    %eax,(%esi)
80105169:	75 3d                	jne    801051a8 <sys_link+0xe8>
8010516b:	83 ec 04             	sub    $0x4,%esp
8010516e:	ff 73 04             	push   0x4(%ebx)
80105171:	57                   	push   %edi
80105172:	56                   	push   %esi
80105173:	e8 68 ce ff ff       	call   80101fe0 <dirlink>
80105178:	83 c4 10             	add    $0x10,%esp
8010517b:	85 c0                	test   %eax,%eax
8010517d:	78 29                	js     801051a8 <sys_link+0xe8>
  iunlockput(dp);
8010517f:	83 ec 0c             	sub    $0xc,%esp
80105182:	56                   	push   %esi
80105183:	e8 88 c8 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105188:	89 1c 24             	mov    %ebx,(%esp)
8010518b:	e8 20 c7 ff ff       	call   801018b0 <iput>
  end_op();
80105190:	e8 3b de ff ff       	call   80102fd0 <end_op>
  return 0;
80105195:	83 c4 10             	add    $0x10,%esp
80105198:	31 c0                	xor    %eax,%eax
}
8010519a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010519d:	5b                   	pop    %ebx
8010519e:	5e                   	pop    %esi
8010519f:	5f                   	pop    %edi
801051a0:	5d                   	pop    %ebp
801051a1:	c3                   	ret    
801051a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801051a8:	83 ec 0c             	sub    $0xc,%esp
801051ab:	56                   	push   %esi
801051ac:	e8 5f c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801051b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801051b4:	83 ec 0c             	sub    $0xc,%esp
801051b7:	53                   	push   %ebx
801051b8:	e8 c3 c5 ff ff       	call   80101780 <ilock>
  ip->nlink--;
801051bd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051c2:	89 1c 24             	mov    %ebx,(%esp)
801051c5:	e8 06 c5 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801051ca:	89 1c 24             	mov    %ebx,(%esp)
801051cd:	e8 3e c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
801051d2:	e8 f9 dd ff ff       	call   80102fd0 <end_op>
  return -1;
801051d7:	83 c4 10             	add    $0x10,%esp
801051da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051df:	eb b9                	jmp    8010519a <sys_link+0xda>
    iunlockput(ip);
801051e1:	83 ec 0c             	sub    $0xc,%esp
801051e4:	53                   	push   %ebx
801051e5:	e8 26 c8 ff ff       	call   80101a10 <iunlockput>
    end_op();
801051ea:	e8 e1 dd ff ff       	call   80102fd0 <end_op>
    return -1;
801051ef:	83 c4 10             	add    $0x10,%esp
801051f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f7:	eb a1                	jmp    8010519a <sys_link+0xda>
    end_op();
801051f9:	e8 d2 dd ff ff       	call   80102fd0 <end_op>
    return -1;
801051fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105203:	eb 95                	jmp    8010519a <sys_link+0xda>
80105205:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105210 <sys_unlink>:
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	57                   	push   %edi
80105214:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105215:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105218:	53                   	push   %ebx
80105219:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010521c:	50                   	push   %eax
8010521d:	6a 00                	push   $0x0
8010521f:	e8 bc f9 ff ff       	call   80104be0 <argstr>
80105224:	83 c4 10             	add    $0x10,%esp
80105227:	85 c0                	test   %eax,%eax
80105229:	0f 88 7a 01 00 00    	js     801053a9 <sys_unlink+0x199>
  begin_op();
8010522f:	e8 2c dd ff ff       	call   80102f60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105234:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105237:	83 ec 08             	sub    $0x8,%esp
8010523a:	53                   	push   %ebx
8010523b:	ff 75 c0             	push   -0x40(%ebp)
8010523e:	e8 7d ce ff ff       	call   801020c0 <nameiparent>
80105243:	83 c4 10             	add    $0x10,%esp
80105246:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105249:	85 c0                	test   %eax,%eax
8010524b:	0f 84 62 01 00 00    	je     801053b3 <sys_unlink+0x1a3>
  ilock(dp);
80105251:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105254:	83 ec 0c             	sub    $0xc,%esp
80105257:	57                   	push   %edi
80105258:	e8 23 c5 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010525d:	58                   	pop    %eax
8010525e:	5a                   	pop    %edx
8010525f:	68 d4 7b 10 80       	push   $0x80107bd4
80105264:	53                   	push   %ebx
80105265:	e8 56 ca ff ff       	call   80101cc0 <namecmp>
8010526a:	83 c4 10             	add    $0x10,%esp
8010526d:	85 c0                	test   %eax,%eax
8010526f:	0f 84 fb 00 00 00    	je     80105370 <sys_unlink+0x160>
80105275:	83 ec 08             	sub    $0x8,%esp
80105278:	68 d3 7b 10 80       	push   $0x80107bd3
8010527d:	53                   	push   %ebx
8010527e:	e8 3d ca ff ff       	call   80101cc0 <namecmp>
80105283:	83 c4 10             	add    $0x10,%esp
80105286:	85 c0                	test   %eax,%eax
80105288:	0f 84 e2 00 00 00    	je     80105370 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010528e:	83 ec 04             	sub    $0x4,%esp
80105291:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105294:	50                   	push   %eax
80105295:	53                   	push   %ebx
80105296:	57                   	push   %edi
80105297:	e8 44 ca ff ff       	call   80101ce0 <dirlookup>
8010529c:	83 c4 10             	add    $0x10,%esp
8010529f:	89 c3                	mov    %eax,%ebx
801052a1:	85 c0                	test   %eax,%eax
801052a3:	0f 84 c7 00 00 00    	je     80105370 <sys_unlink+0x160>
  ilock(ip);
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	50                   	push   %eax
801052ad:	e8 ce c4 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
801052b2:	83 c4 10             	add    $0x10,%esp
801052b5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801052ba:	0f 8e 1c 01 00 00    	jle    801053dc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801052c0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052c5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801052c8:	74 66                	je     80105330 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801052ca:	83 ec 04             	sub    $0x4,%esp
801052cd:	6a 10                	push   $0x10
801052cf:	6a 00                	push   $0x0
801052d1:	57                   	push   %edi
801052d2:	e8 89 f5 ff ff       	call   80104860 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052d7:	6a 10                	push   $0x10
801052d9:	ff 75 c4             	push   -0x3c(%ebp)
801052dc:	57                   	push   %edi
801052dd:	ff 75 b4             	push   -0x4c(%ebp)
801052e0:	e8 ab c8 ff ff       	call   80101b90 <writei>
801052e5:	83 c4 20             	add    $0x20,%esp
801052e8:	83 f8 10             	cmp    $0x10,%eax
801052eb:	0f 85 de 00 00 00    	jne    801053cf <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801052f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052f6:	0f 84 94 00 00 00    	je     80105390 <sys_unlink+0x180>
  iunlockput(dp);
801052fc:	83 ec 0c             	sub    $0xc,%esp
801052ff:	ff 75 b4             	push   -0x4c(%ebp)
80105302:	e8 09 c7 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105307:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010530c:	89 1c 24             	mov    %ebx,(%esp)
8010530f:	e8 bc c3 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105314:	89 1c 24             	mov    %ebx,(%esp)
80105317:	e8 f4 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010531c:	e8 af dc ff ff       	call   80102fd0 <end_op>
  return 0;
80105321:	83 c4 10             	add    $0x10,%esp
80105324:	31 c0                	xor    %eax,%eax
}
80105326:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105329:	5b                   	pop    %ebx
8010532a:	5e                   	pop    %esi
8010532b:	5f                   	pop    %edi
8010532c:	5d                   	pop    %ebp
8010532d:	c3                   	ret    
8010532e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105330:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105334:	76 94                	jbe    801052ca <sys_unlink+0xba>
80105336:	be 20 00 00 00       	mov    $0x20,%esi
8010533b:	eb 0b                	jmp    80105348 <sys_unlink+0x138>
8010533d:	8d 76 00             	lea    0x0(%esi),%esi
80105340:	83 c6 10             	add    $0x10,%esi
80105343:	3b 73 58             	cmp    0x58(%ebx),%esi
80105346:	73 82                	jae    801052ca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105348:	6a 10                	push   $0x10
8010534a:	56                   	push   %esi
8010534b:	57                   	push   %edi
8010534c:	53                   	push   %ebx
8010534d:	e8 3e c7 ff ff       	call   80101a90 <readi>
80105352:	83 c4 10             	add    $0x10,%esp
80105355:	83 f8 10             	cmp    $0x10,%eax
80105358:	75 68                	jne    801053c2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010535a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010535f:	74 df                	je     80105340 <sys_unlink+0x130>
    iunlockput(ip);
80105361:	83 ec 0c             	sub    $0xc,%esp
80105364:	53                   	push   %ebx
80105365:	e8 a6 c6 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010536a:	83 c4 10             	add    $0x10,%esp
8010536d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105370:	83 ec 0c             	sub    $0xc,%esp
80105373:	ff 75 b4             	push   -0x4c(%ebp)
80105376:	e8 95 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010537b:	e8 50 dc ff ff       	call   80102fd0 <end_op>
  return -1;
80105380:	83 c4 10             	add    $0x10,%esp
80105383:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105388:	eb 9c                	jmp    80105326 <sys_unlink+0x116>
8010538a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105390:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105393:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105396:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010539b:	50                   	push   %eax
8010539c:	e8 2f c3 ff ff       	call   801016d0 <iupdate>
801053a1:	83 c4 10             	add    $0x10,%esp
801053a4:	e9 53 ff ff ff       	jmp    801052fc <sys_unlink+0xec>
    return -1;
801053a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ae:	e9 73 ff ff ff       	jmp    80105326 <sys_unlink+0x116>
    end_op();
801053b3:	e8 18 dc ff ff       	call   80102fd0 <end_op>
    return -1;
801053b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053bd:	e9 64 ff ff ff       	jmp    80105326 <sys_unlink+0x116>
      panic("isdirempty: readi");
801053c2:	83 ec 0c             	sub    $0xc,%esp
801053c5:	68 f8 7b 10 80       	push   $0x80107bf8
801053ca:	e8 b1 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801053cf:	83 ec 0c             	sub    $0xc,%esp
801053d2:	68 0a 7c 10 80       	push   $0x80107c0a
801053d7:	e8 a4 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801053dc:	83 ec 0c             	sub    $0xc,%esp
801053df:	68 e6 7b 10 80       	push   $0x80107be6
801053e4:	e8 97 af ff ff       	call   80100380 <panic>
801053e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053f0 <sys_open>:

int
sys_open(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	57                   	push   %edi
801053f4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053f8:	53                   	push   %ebx
801053f9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053fc:	50                   	push   %eax
801053fd:	6a 00                	push   $0x0
801053ff:	e8 dc f7 ff ff       	call   80104be0 <argstr>
80105404:	83 c4 10             	add    $0x10,%esp
80105407:	85 c0                	test   %eax,%eax
80105409:	0f 88 8e 00 00 00    	js     8010549d <sys_open+0xad>
8010540f:	83 ec 08             	sub    $0x8,%esp
80105412:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105415:	50                   	push   %eax
80105416:	6a 01                	push   $0x1
80105418:	e8 03 f7 ff ff       	call   80104b20 <argint>
8010541d:	83 c4 10             	add    $0x10,%esp
80105420:	85 c0                	test   %eax,%eax
80105422:	78 79                	js     8010549d <sys_open+0xad>
    return -1;

  begin_op();
80105424:	e8 37 db ff ff       	call   80102f60 <begin_op>

  if(omode & O_CREATE){
80105429:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010542d:	75 79                	jne    801054a8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010542f:	83 ec 0c             	sub    $0xc,%esp
80105432:	ff 75 e0             	push   -0x20(%ebp)
80105435:	e8 66 cc ff ff       	call   801020a0 <namei>
8010543a:	83 c4 10             	add    $0x10,%esp
8010543d:	89 c6                	mov    %eax,%esi
8010543f:	85 c0                	test   %eax,%eax
80105441:	0f 84 7e 00 00 00    	je     801054c5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105447:	83 ec 0c             	sub    $0xc,%esp
8010544a:	50                   	push   %eax
8010544b:	e8 30 c3 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105450:	83 c4 10             	add    $0x10,%esp
80105453:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105458:	0f 84 c2 00 00 00    	je     80105520 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010545e:	e8 cd b9 ff ff       	call   80100e30 <filealloc>
80105463:	89 c7                	mov    %eax,%edi
80105465:	85 c0                	test   %eax,%eax
80105467:	74 23                	je     8010548c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105469:	e8 02 e7 ff ff       	call   80103b70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010546e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105470:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105474:	85 d2                	test   %edx,%edx
80105476:	74 60                	je     801054d8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105478:	83 c3 01             	add    $0x1,%ebx
8010547b:	83 fb 10             	cmp    $0x10,%ebx
8010547e:	75 f0                	jne    80105470 <sys_open+0x80>
    if(f)
      fileclose(f);
80105480:	83 ec 0c             	sub    $0xc,%esp
80105483:	57                   	push   %edi
80105484:	e8 67 ba ff ff       	call   80100ef0 <fileclose>
80105489:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	56                   	push   %esi
80105490:	e8 7b c5 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105495:	e8 36 db ff ff       	call   80102fd0 <end_op>
    return -1;
8010549a:	83 c4 10             	add    $0x10,%esp
8010549d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054a2:	eb 6d                	jmp    80105511 <sys_open+0x121>
801054a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801054a8:	83 ec 0c             	sub    $0xc,%esp
801054ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054ae:	31 c9                	xor    %ecx,%ecx
801054b0:	ba 02 00 00 00       	mov    $0x2,%edx
801054b5:	6a 00                	push   $0x0
801054b7:	e8 14 f8 ff ff       	call   80104cd0 <create>
    if(ip == 0){
801054bc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801054bf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801054c1:	85 c0                	test   %eax,%eax
801054c3:	75 99                	jne    8010545e <sys_open+0x6e>
      end_op();
801054c5:	e8 06 db ff ff       	call   80102fd0 <end_op>
      return -1;
801054ca:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054cf:	eb 40                	jmp    80105511 <sys_open+0x121>
801054d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801054d8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054db:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801054df:	56                   	push   %esi
801054e0:	e8 7b c3 ff ff       	call   80101860 <iunlock>
  end_op();
801054e5:	e8 e6 da ff ff       	call   80102fd0 <end_op>

  f->type = FD_INODE;
801054ea:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801054f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054f3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801054f6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801054f9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801054fb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105502:	f7 d0                	not    %eax
80105504:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105507:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010550a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010550d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105511:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105514:	89 d8                	mov    %ebx,%eax
80105516:	5b                   	pop    %ebx
80105517:	5e                   	pop    %esi
80105518:	5f                   	pop    %edi
80105519:	5d                   	pop    %ebp
8010551a:	c3                   	ret    
8010551b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010551f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105520:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105523:	85 c9                	test   %ecx,%ecx
80105525:	0f 84 33 ff ff ff    	je     8010545e <sys_open+0x6e>
8010552b:	e9 5c ff ff ff       	jmp    8010548c <sys_open+0x9c>

80105530 <sys_mkdir>:

int
sys_mkdir(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105536:	e8 25 da ff ff       	call   80102f60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010553b:	83 ec 08             	sub    $0x8,%esp
8010553e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105541:	50                   	push   %eax
80105542:	6a 00                	push   $0x0
80105544:	e8 97 f6 ff ff       	call   80104be0 <argstr>
80105549:	83 c4 10             	add    $0x10,%esp
8010554c:	85 c0                	test   %eax,%eax
8010554e:	78 30                	js     80105580 <sys_mkdir+0x50>
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105556:	31 c9                	xor    %ecx,%ecx
80105558:	ba 01 00 00 00       	mov    $0x1,%edx
8010555d:	6a 00                	push   $0x0
8010555f:	e8 6c f7 ff ff       	call   80104cd0 <create>
80105564:	83 c4 10             	add    $0x10,%esp
80105567:	85 c0                	test   %eax,%eax
80105569:	74 15                	je     80105580 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010556b:	83 ec 0c             	sub    $0xc,%esp
8010556e:	50                   	push   %eax
8010556f:	e8 9c c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105574:	e8 57 da ff ff       	call   80102fd0 <end_op>
  return 0;
80105579:	83 c4 10             	add    $0x10,%esp
8010557c:	31 c0                	xor    %eax,%eax
}
8010557e:	c9                   	leave  
8010557f:	c3                   	ret    
    end_op();
80105580:	e8 4b da ff ff       	call   80102fd0 <end_op>
    return -1;
80105585:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010558a:	c9                   	leave  
8010558b:	c3                   	ret    
8010558c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105590 <sys_mknod>:

int
sys_mknod(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105596:	e8 c5 d9 ff ff       	call   80102f60 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010559b:	83 ec 08             	sub    $0x8,%esp
8010559e:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055a1:	50                   	push   %eax
801055a2:	6a 00                	push   $0x0
801055a4:	e8 37 f6 ff ff       	call   80104be0 <argstr>
801055a9:	83 c4 10             	add    $0x10,%esp
801055ac:	85 c0                	test   %eax,%eax
801055ae:	78 60                	js     80105610 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801055b0:	83 ec 08             	sub    $0x8,%esp
801055b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055b6:	50                   	push   %eax
801055b7:	6a 01                	push   $0x1
801055b9:	e8 62 f5 ff ff       	call   80104b20 <argint>
  if((argstr(0, &path)) < 0 ||
801055be:	83 c4 10             	add    $0x10,%esp
801055c1:	85 c0                	test   %eax,%eax
801055c3:	78 4b                	js     80105610 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801055c5:	83 ec 08             	sub    $0x8,%esp
801055c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055cb:	50                   	push   %eax
801055cc:	6a 02                	push   $0x2
801055ce:	e8 4d f5 ff ff       	call   80104b20 <argint>
     argint(1, &major) < 0 ||
801055d3:	83 c4 10             	add    $0x10,%esp
801055d6:	85 c0                	test   %eax,%eax
801055d8:	78 36                	js     80105610 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801055da:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801055de:	83 ec 0c             	sub    $0xc,%esp
801055e1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801055e5:	ba 03 00 00 00       	mov    $0x3,%edx
801055ea:	50                   	push   %eax
801055eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801055ee:	e8 dd f6 ff ff       	call   80104cd0 <create>
     argint(2, &minor) < 0 ||
801055f3:	83 c4 10             	add    $0x10,%esp
801055f6:	85 c0                	test   %eax,%eax
801055f8:	74 16                	je     80105610 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055fa:	83 ec 0c             	sub    $0xc,%esp
801055fd:	50                   	push   %eax
801055fe:	e8 0d c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105603:	e8 c8 d9 ff ff       	call   80102fd0 <end_op>
  return 0;
80105608:	83 c4 10             	add    $0x10,%esp
8010560b:	31 c0                	xor    %eax,%eax
}
8010560d:	c9                   	leave  
8010560e:	c3                   	ret    
8010560f:	90                   	nop
    end_op();
80105610:	e8 bb d9 ff ff       	call   80102fd0 <end_op>
    return -1;
80105615:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010561a:	c9                   	leave  
8010561b:	c3                   	ret    
8010561c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105620 <sys_chdir>:

int
sys_chdir(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	56                   	push   %esi
80105624:	53                   	push   %ebx
80105625:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105628:	e8 43 e5 ff ff       	call   80103b70 <myproc>
8010562d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010562f:	e8 2c d9 ff ff       	call   80102f60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105634:	83 ec 08             	sub    $0x8,%esp
80105637:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010563a:	50                   	push   %eax
8010563b:	6a 00                	push   $0x0
8010563d:	e8 9e f5 ff ff       	call   80104be0 <argstr>
80105642:	83 c4 10             	add    $0x10,%esp
80105645:	85 c0                	test   %eax,%eax
80105647:	78 77                	js     801056c0 <sys_chdir+0xa0>
80105649:	83 ec 0c             	sub    $0xc,%esp
8010564c:	ff 75 f4             	push   -0xc(%ebp)
8010564f:	e8 4c ca ff ff       	call   801020a0 <namei>
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	89 c3                	mov    %eax,%ebx
80105659:	85 c0                	test   %eax,%eax
8010565b:	74 63                	je     801056c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010565d:	83 ec 0c             	sub    $0xc,%esp
80105660:	50                   	push   %eax
80105661:	e8 1a c1 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105666:	83 c4 10             	add    $0x10,%esp
80105669:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010566e:	75 30                	jne    801056a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	53                   	push   %ebx
80105674:	e8 e7 c1 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105679:	58                   	pop    %eax
8010567a:	ff 76 68             	push   0x68(%esi)
8010567d:	e8 2e c2 ff ff       	call   801018b0 <iput>
  end_op();
80105682:	e8 49 d9 ff ff       	call   80102fd0 <end_op>
  curproc->cwd = ip;
80105687:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010568a:	83 c4 10             	add    $0x10,%esp
8010568d:	31 c0                	xor    %eax,%eax
}
8010568f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105692:	5b                   	pop    %ebx
80105693:	5e                   	pop    %esi
80105694:	5d                   	pop    %ebp
80105695:	c3                   	ret    
80105696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	53                   	push   %ebx
801056a4:	e8 67 c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
801056a9:	e8 22 d9 ff ff       	call   80102fd0 <end_op>
    return -1;
801056ae:	83 c4 10             	add    $0x10,%esp
801056b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056b6:	eb d7                	jmp    8010568f <sys_chdir+0x6f>
801056b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056bf:	90                   	nop
    end_op();
801056c0:	e8 0b d9 ff ff       	call   80102fd0 <end_op>
    return -1;
801056c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ca:	eb c3                	jmp    8010568f <sys_chdir+0x6f>
801056cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056d0 <sys_exec>:

int
sys_exec(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	57                   	push   %edi
801056d4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056d5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801056db:	53                   	push   %ebx
801056dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056e2:	50                   	push   %eax
801056e3:	6a 00                	push   $0x0
801056e5:	e8 f6 f4 ff ff       	call   80104be0 <argstr>
801056ea:	83 c4 10             	add    $0x10,%esp
801056ed:	85 c0                	test   %eax,%eax
801056ef:	0f 88 87 00 00 00    	js     8010577c <sys_exec+0xac>
801056f5:	83 ec 08             	sub    $0x8,%esp
801056f8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801056fe:	50                   	push   %eax
801056ff:	6a 01                	push   $0x1
80105701:	e8 1a f4 ff ff       	call   80104b20 <argint>
80105706:	83 c4 10             	add    $0x10,%esp
80105709:	85 c0                	test   %eax,%eax
8010570b:	78 6f                	js     8010577c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010570d:	83 ec 04             	sub    $0x4,%esp
80105710:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105716:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105718:	68 80 00 00 00       	push   $0x80
8010571d:	6a 00                	push   $0x0
8010571f:	56                   	push   %esi
80105720:	e8 3b f1 ff ff       	call   80104860 <memset>
80105725:	83 c4 10             	add    $0x10,%esp
80105728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010572f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105730:	83 ec 08             	sub    $0x8,%esp
80105733:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105739:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105740:	50                   	push   %eax
80105741:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105747:	01 f8                	add    %edi,%eax
80105749:	50                   	push   %eax
8010574a:	e8 41 f3 ff ff       	call   80104a90 <fetchint>
8010574f:	83 c4 10             	add    $0x10,%esp
80105752:	85 c0                	test   %eax,%eax
80105754:	78 26                	js     8010577c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105756:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010575c:	85 c0                	test   %eax,%eax
8010575e:	74 30                	je     80105790 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105760:	83 ec 08             	sub    $0x8,%esp
80105763:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105766:	52                   	push   %edx
80105767:	50                   	push   %eax
80105768:	e8 63 f3 ff ff       	call   80104ad0 <fetchstr>
8010576d:	83 c4 10             	add    $0x10,%esp
80105770:	85 c0                	test   %eax,%eax
80105772:	78 08                	js     8010577c <sys_exec+0xac>
  for(i=0;; i++){
80105774:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105777:	83 fb 20             	cmp    $0x20,%ebx
8010577a:	75 b4                	jne    80105730 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010577c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010577f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105784:	5b                   	pop    %ebx
80105785:	5e                   	pop    %esi
80105786:	5f                   	pop    %edi
80105787:	5d                   	pop    %ebp
80105788:	c3                   	ret    
80105789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105790:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105797:	00 00 00 00 
  return exec(path, argv);
8010579b:	83 ec 08             	sub    $0x8,%esp
8010579e:	56                   	push   %esi
8010579f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801057a5:	e8 06 b3 ff ff       	call   80100ab0 <exec>
801057aa:	83 c4 10             	add    $0x10,%esp
}
801057ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b0:	5b                   	pop    %ebx
801057b1:	5e                   	pop    %esi
801057b2:	5f                   	pop    %edi
801057b3:	5d                   	pop    %ebp
801057b4:	c3                   	ret    
801057b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057c0 <sys_pipe>:

int
sys_pipe(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	57                   	push   %edi
801057c4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057c5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801057c8:	53                   	push   %ebx
801057c9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057cc:	6a 08                	push   $0x8
801057ce:	50                   	push   %eax
801057cf:	6a 00                	push   $0x0
801057d1:	e8 9a f3 ff ff       	call   80104b70 <argptr>
801057d6:	83 c4 10             	add    $0x10,%esp
801057d9:	85 c0                	test   %eax,%eax
801057db:	78 4a                	js     80105827 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801057dd:	83 ec 08             	sub    $0x8,%esp
801057e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057e3:	50                   	push   %eax
801057e4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057e7:	50                   	push   %eax
801057e8:	e8 43 de ff ff       	call   80103630 <pipealloc>
801057ed:	83 c4 10             	add    $0x10,%esp
801057f0:	85 c0                	test   %eax,%eax
801057f2:	78 33                	js     80105827 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801057f7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057f9:	e8 72 e3 ff ff       	call   80103b70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057fe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105800:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105804:	85 f6                	test   %esi,%esi
80105806:	74 28                	je     80105830 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105808:	83 c3 01             	add    $0x1,%ebx
8010580b:	83 fb 10             	cmp    $0x10,%ebx
8010580e:	75 f0                	jne    80105800 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105810:	83 ec 0c             	sub    $0xc,%esp
80105813:	ff 75 e0             	push   -0x20(%ebp)
80105816:	e8 d5 b6 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010581b:	58                   	pop    %eax
8010581c:	ff 75 e4             	push   -0x1c(%ebp)
8010581f:	e8 cc b6 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105824:	83 c4 10             	add    $0x10,%esp
80105827:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010582c:	eb 53                	jmp    80105881 <sys_pipe+0xc1>
8010582e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105830:	8d 73 08             	lea    0x8(%ebx),%esi
80105833:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105837:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010583a:	e8 31 e3 ff ff       	call   80103b70 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010583f:	31 d2                	xor    %edx,%edx
80105841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105848:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010584c:	85 c9                	test   %ecx,%ecx
8010584e:	74 20                	je     80105870 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105850:	83 c2 01             	add    $0x1,%edx
80105853:	83 fa 10             	cmp    $0x10,%edx
80105856:	75 f0                	jne    80105848 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105858:	e8 13 e3 ff ff       	call   80103b70 <myproc>
8010585d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105864:	00 
80105865:	eb a9                	jmp    80105810 <sys_pipe+0x50>
80105867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105870:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105874:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105877:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105879:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010587c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010587f:	31 c0                	xor    %eax,%eax
}
80105881:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105884:	5b                   	pop    %ebx
80105885:	5e                   	pop    %esi
80105886:	5f                   	pop    %edi
80105887:	5d                   	pop    %ebp
80105888:	c3                   	ret    
80105889:	66 90                	xchg   %ax,%ax
8010588b:	66 90                	xchg   %ax,%ax
8010588d:	66 90                	xchg   %ax,%ax
8010588f:	90                   	nop

80105890 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105890:	e9 7b e4 ff ff       	jmp    80103d10 <fork>
80105895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058a0 <sys_exit>:
}

int
sys_exit(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801058a6:	e8 e5 e6 ff ff       	call   80103f90 <exit>
  return 0;  // not reached
}
801058ab:	31 c0                	xor    %eax,%eax
801058ad:	c9                   	leave  
801058ae:	c3                   	ret    
801058af:	90                   	nop

801058b0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801058b0:	e9 0b e8 ff ff       	jmp    801040c0 <wait>
801058b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058c0 <sys_kill>:
}

int
sys_kill(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058c9:	50                   	push   %eax
801058ca:	6a 00                	push   $0x0
801058cc:	e8 4f f2 ff ff       	call   80104b20 <argint>
801058d1:	83 c4 10             	add    $0x10,%esp
801058d4:	85 c0                	test   %eax,%eax
801058d6:	78 18                	js     801058f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801058d8:	83 ec 0c             	sub    $0xc,%esp
801058db:	ff 75 f4             	push   -0xc(%ebp)
801058de:	e8 7d ea ff ff       	call   80104360 <kill>
801058e3:	83 c4 10             	add    $0x10,%esp
}
801058e6:	c9                   	leave  
801058e7:	c3                   	ret    
801058e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ef:	90                   	nop
801058f0:	c9                   	leave  
    return -1;
801058f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058f6:	c3                   	ret    
801058f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058fe:	66 90                	xchg   %ax,%ax

80105900 <sys_getpid>:

int
sys_getpid(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105906:	e8 65 e2 ff ff       	call   80103b70 <myproc>
8010590b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010590e:	c9                   	leave  
8010590f:	c3                   	ret    

80105910 <sys_sbrk>:

int
sys_sbrk(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105914:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105917:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010591a:	50                   	push   %eax
8010591b:	6a 00                	push   $0x0
8010591d:	e8 fe f1 ff ff       	call   80104b20 <argint>
80105922:	83 c4 10             	add    $0x10,%esp
80105925:	85 c0                	test   %eax,%eax
80105927:	78 27                	js     80105950 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105929:	e8 42 e2 ff ff       	call   80103b70 <myproc>
  if(growproc(n) < 0)
8010592e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105931:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105933:	ff 75 f4             	push   -0xc(%ebp)
80105936:	e8 55 e3 ff ff       	call   80103c90 <growproc>
8010593b:	83 c4 10             	add    $0x10,%esp
8010593e:	85 c0                	test   %eax,%eax
80105940:	78 0e                	js     80105950 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105942:	89 d8                	mov    %ebx,%eax
80105944:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105947:	c9                   	leave  
80105948:	c3                   	ret    
80105949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105950:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105955:	eb eb                	jmp    80105942 <sys_sbrk+0x32>
80105957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595e:	66 90                	xchg   %ax,%ax

80105960 <sys_sleep>:

int
sys_sleep(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105964:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105967:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010596a:	50                   	push   %eax
8010596b:	6a 00                	push   $0x0
8010596d:	e8 ae f1 ff ff       	call   80104b20 <argint>
80105972:	83 c4 10             	add    $0x10,%esp
80105975:	85 c0                	test   %eax,%eax
80105977:	0f 88 8a 00 00 00    	js     80105a07 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010597d:	83 ec 0c             	sub    $0xc,%esp
80105980:	68 80 bc 14 80       	push   $0x8014bc80
80105985:	e8 16 ee ff ff       	call   801047a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010598a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010598d:	8b 1d 60 bc 14 80    	mov    0x8014bc60,%ebx
  while(ticks - ticks0 < n){
80105993:	83 c4 10             	add    $0x10,%esp
80105996:	85 d2                	test   %edx,%edx
80105998:	75 27                	jne    801059c1 <sys_sleep+0x61>
8010599a:	eb 54                	jmp    801059f0 <sys_sleep+0x90>
8010599c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801059a0:	83 ec 08             	sub    $0x8,%esp
801059a3:	68 80 bc 14 80       	push   $0x8014bc80
801059a8:	68 60 bc 14 80       	push   $0x8014bc60
801059ad:	e8 8e e8 ff ff       	call   80104240 <sleep>
  while(ticks - ticks0 < n){
801059b2:	a1 60 bc 14 80       	mov    0x8014bc60,%eax
801059b7:	83 c4 10             	add    $0x10,%esp
801059ba:	29 d8                	sub    %ebx,%eax
801059bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801059bf:	73 2f                	jae    801059f0 <sys_sleep+0x90>
    if(myproc()->killed){
801059c1:	e8 aa e1 ff ff       	call   80103b70 <myproc>
801059c6:	8b 40 24             	mov    0x24(%eax),%eax
801059c9:	85 c0                	test   %eax,%eax
801059cb:	74 d3                	je     801059a0 <sys_sleep+0x40>
      release(&tickslock);
801059cd:	83 ec 0c             	sub    $0xc,%esp
801059d0:	68 80 bc 14 80       	push   $0x8014bc80
801059d5:	e8 66 ed ff ff       	call   80104740 <release>
  }
  release(&tickslock);
  return 0;
}
801059da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801059dd:	83 c4 10             	add    $0x10,%esp
801059e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059e5:	c9                   	leave  
801059e6:	c3                   	ret    
801059e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ee:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801059f0:	83 ec 0c             	sub    $0xc,%esp
801059f3:	68 80 bc 14 80       	push   $0x8014bc80
801059f8:	e8 43 ed ff ff       	call   80104740 <release>
  return 0;
801059fd:	83 c4 10             	add    $0x10,%esp
80105a00:	31 c0                	xor    %eax,%eax
}
80105a02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a05:	c9                   	leave  
80105a06:	c3                   	ret    
    return -1;
80105a07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a0c:	eb f4                	jmp    80105a02 <sys_sleep+0xa2>
80105a0e:	66 90                	xchg   %ax,%ax

80105a10 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	53                   	push   %ebx
80105a14:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a17:	68 80 bc 14 80       	push   $0x8014bc80
80105a1c:	e8 7f ed ff ff       	call   801047a0 <acquire>
  xticks = ticks;
80105a21:	8b 1d 60 bc 14 80    	mov    0x8014bc60,%ebx
  release(&tickslock);
80105a27:	c7 04 24 80 bc 14 80 	movl   $0x8014bc80,(%esp)
80105a2e:	e8 0d ed ff ff       	call   80104740 <release>
  return xticks;
}
80105a33:	89 d8                	mov    %ebx,%eax
80105a35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a38:	c9                   	leave  
80105a39:	c3                   	ret    

80105a3a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105a3a:	1e                   	push   %ds
  pushl %es
80105a3b:	06                   	push   %es
  pushl %fs
80105a3c:	0f a0                	push   %fs
  pushl %gs
80105a3e:	0f a8                	push   %gs
  pushal
80105a40:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a41:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a45:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a47:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a49:	54                   	push   %esp
  call trap
80105a4a:	e8 c1 00 00 00       	call   80105b10 <trap>
  addl $4, %esp
80105a4f:	83 c4 04             	add    $0x4,%esp

80105a52 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a52:	61                   	popa   
  popl %gs
80105a53:	0f a9                	pop    %gs
  popl %fs
80105a55:	0f a1                	pop    %fs
  popl %es
80105a57:	07                   	pop    %es
  popl %ds
80105a58:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105a59:	83 c4 08             	add    $0x8,%esp
  iret
80105a5c:	cf                   	iret   
80105a5d:	66 90                	xchg   %ax,%ax
80105a5f:	90                   	nop

80105a60 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105a60:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105a61:	31 c0                	xor    %eax,%eax
{
80105a63:	89 e5                	mov    %esp,%ebp
80105a65:	83 ec 08             	sub    $0x8,%esp
80105a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a70:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105a77:	c7 04 c5 c2 bc 14 80 	movl   $0x8e000008,-0x7feb433e(,%eax,8)
80105a7e:	08 00 00 8e 
80105a82:	66 89 14 c5 c0 bc 14 	mov    %dx,-0x7feb4340(,%eax,8)
80105a89:	80 
80105a8a:	c1 ea 10             	shr    $0x10,%edx
80105a8d:	66 89 14 c5 c6 bc 14 	mov    %dx,-0x7feb433a(,%eax,8)
80105a94:	80 
  for(i = 0; i < 256; i++)
80105a95:	83 c0 01             	add    $0x1,%eax
80105a98:	3d 00 01 00 00       	cmp    $0x100,%eax
80105a9d:	75 d1                	jne    80105a70 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105a9f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105aa2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105aa7:	c7 05 c2 be 14 80 08 	movl   $0xef000008,0x8014bec2
80105aae:	00 00 ef 
  initlock(&tickslock, "time");
80105ab1:	68 19 7c 10 80       	push   $0x80107c19
80105ab6:	68 80 bc 14 80       	push   $0x8014bc80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105abb:	66 a3 c0 be 14 80    	mov    %ax,0x8014bec0
80105ac1:	c1 e8 10             	shr    $0x10,%eax
80105ac4:	66 a3 c6 be 14 80    	mov    %ax,0x8014bec6
  initlock(&tickslock, "time");
80105aca:	e8 01 eb ff ff       	call   801045d0 <initlock>
}
80105acf:	83 c4 10             	add    $0x10,%esp
80105ad2:	c9                   	leave  
80105ad3:	c3                   	ret    
80105ad4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105adf:	90                   	nop

80105ae0 <idtinit>:

void
idtinit(void)
{
80105ae0:	55                   	push   %ebp
  pd[0] = size-1;
80105ae1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ae6:	89 e5                	mov    %esp,%ebp
80105ae8:	83 ec 10             	sub    $0x10,%esp
80105aeb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105aef:	b8 c0 bc 14 80       	mov    $0x8014bcc0,%eax
80105af4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105af8:	c1 e8 10             	shr    $0x10,%eax
80105afb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105aff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b02:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b05:	c9                   	leave  
80105b06:	c3                   	ret    
80105b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0e:	66 90                	xchg   %ax,%ax

80105b10 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	57                   	push   %edi
80105b14:	56                   	push   %esi
80105b15:	53                   	push   %ebx
80105b16:	83 ec 1c             	sub    $0x1c,%esp
80105b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105b1c:	8b 43 30             	mov    0x30(%ebx),%eax
80105b1f:	83 f8 40             	cmp    $0x40,%eax
80105b22:	0f 84 30 01 00 00    	je     80105c58 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b28:	83 e8 0e             	sub    $0xe,%eax
80105b2b:	83 f8 31             	cmp    $0x31,%eax
80105b2e:	0f 87 8c 00 00 00    	ja     80105bc0 <trap+0xb0>
80105b34:	ff 24 85 c0 7c 10 80 	jmp    *-0x7fef8340(,%eax,4)
80105b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b3f:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105b40:	e8 0b e0 ff ff       	call   80103b50 <cpuid>
80105b45:	85 c0                	test   %eax,%eax
80105b47:	0f 84 13 02 00 00    	je     80105d60 <trap+0x250>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105b4d:	e8 be cf ff ff       	call   80102b10 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b52:	e8 19 e0 ff ff       	call   80103b70 <myproc>
80105b57:	85 c0                	test   %eax,%eax
80105b59:	74 1d                	je     80105b78 <trap+0x68>
80105b5b:	e8 10 e0 ff ff       	call   80103b70 <myproc>
80105b60:	8b 50 24             	mov    0x24(%eax),%edx
80105b63:	85 d2                	test   %edx,%edx
80105b65:	74 11                	je     80105b78 <trap+0x68>
80105b67:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b6b:	83 e0 03             	and    $0x3,%eax
80105b6e:	66 83 f8 03          	cmp    $0x3,%ax
80105b72:	0f 84 c8 01 00 00    	je     80105d40 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105b78:	e8 f3 df ff ff       	call   80103b70 <myproc>
80105b7d:	85 c0                	test   %eax,%eax
80105b7f:	74 0f                	je     80105b90 <trap+0x80>
80105b81:	e8 ea df ff ff       	call   80103b70 <myproc>
80105b86:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105b8a:	0f 84 b0 00 00 00    	je     80105c40 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b90:	e8 db df ff ff       	call   80103b70 <myproc>
80105b95:	85 c0                	test   %eax,%eax
80105b97:	74 1d                	je     80105bb6 <trap+0xa6>
80105b99:	e8 d2 df ff ff       	call   80103b70 <myproc>
80105b9e:	8b 40 24             	mov    0x24(%eax),%eax
80105ba1:	85 c0                	test   %eax,%eax
80105ba3:	74 11                	je     80105bb6 <trap+0xa6>
80105ba5:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ba9:	83 e0 03             	and    $0x3,%eax
80105bac:	66 83 f8 03          	cmp    $0x3,%ax
80105bb0:	0f 84 cf 00 00 00    	je     80105c85 <trap+0x175>
    exit();
}
80105bb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bb9:	5b                   	pop    %ebx
80105bba:	5e                   	pop    %esi
80105bbb:	5f                   	pop    %edi
80105bbc:	5d                   	pop    %ebp
80105bbd:	c3                   	ret    
80105bbe:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105bc0:	e8 ab df ff ff       	call   80103b70 <myproc>
80105bc5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105bc8:	85 c0                	test   %eax,%eax
80105bca:	0f 84 c4 01 00 00    	je     80105d94 <trap+0x284>
80105bd0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105bd4:	0f 84 ba 01 00 00    	je     80105d94 <trap+0x284>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105bda:	0f 20 d1             	mov    %cr2,%ecx
80105bdd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105be0:	e8 6b df ff ff       	call   80103b50 <cpuid>
80105be5:	8b 73 30             	mov    0x30(%ebx),%esi
80105be8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105beb:	8b 43 34             	mov    0x34(%ebx),%eax
80105bee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105bf1:	e8 7a df ff ff       	call   80103b70 <myproc>
80105bf6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105bf9:	e8 72 df ff ff       	call   80103b70 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bfe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c01:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c04:	51                   	push   %ecx
80105c05:	57                   	push   %edi
80105c06:	52                   	push   %edx
80105c07:	ff 75 e4             	push   -0x1c(%ebp)
80105c0a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105c0b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105c0e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c11:	56                   	push   %esi
80105c12:	ff 70 10             	push   0x10(%eax)
80105c15:	68 7c 7c 10 80       	push   $0x80107c7c
80105c1a:	e8 81 aa ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105c1f:	83 c4 20             	add    $0x20,%esp
80105c22:	e8 49 df ff ff       	call   80103b70 <myproc>
80105c27:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c2e:	e8 3d df ff ff       	call   80103b70 <myproc>
80105c33:	85 c0                	test   %eax,%eax
80105c35:	0f 85 20 ff ff ff    	jne    80105b5b <trap+0x4b>
80105c3b:	e9 38 ff ff ff       	jmp    80105b78 <trap+0x68>
  if(myproc() && myproc()->state == RUNNING &&
80105c40:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105c44:	0f 85 46 ff ff ff    	jne    80105b90 <trap+0x80>
    yield();
80105c4a:	e8 a1 e5 ff ff       	call   801041f0 <yield>
80105c4f:	e9 3c ff ff ff       	jmp    80105b90 <trap+0x80>
80105c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105c58:	e8 13 df ff ff       	call   80103b70 <myproc>
80105c5d:	8b 70 24             	mov    0x24(%eax),%esi
80105c60:	85 f6                	test   %esi,%esi
80105c62:	0f 85 e8 00 00 00    	jne    80105d50 <trap+0x240>
    myproc()->tf = tf;
80105c68:	e8 03 df ff ff       	call   80103b70 <myproc>
80105c6d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105c70:	e8 eb ef ff ff       	call   80104c60 <syscall>
    if(myproc()->killed)
80105c75:	e8 f6 de ff ff       	call   80103b70 <myproc>
80105c7a:	8b 48 24             	mov    0x24(%eax),%ecx
80105c7d:	85 c9                	test   %ecx,%ecx
80105c7f:	0f 84 31 ff ff ff    	je     80105bb6 <trap+0xa6>
}
80105c85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c88:	5b                   	pop    %ebx
80105c89:	5e                   	pop    %esi
80105c8a:	5f                   	pop    %edi
80105c8b:	5d                   	pop    %ebp
      exit();
80105c8c:	e9 ff e2 ff ff       	jmp    80103f90 <exit>
80105c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105c98:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c9b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105c9f:	e8 ac de ff ff       	call   80103b50 <cpuid>
80105ca4:	57                   	push   %edi
80105ca5:	56                   	push   %esi
80105ca6:	50                   	push   %eax
80105ca7:	68 24 7c 10 80       	push   $0x80107c24
80105cac:	e8 ef a9 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105cb1:	e8 5a ce ff ff       	call   80102b10 <lapiceoi>
    break;
80105cb6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cb9:	e8 b2 de ff ff       	call   80103b70 <myproc>
80105cbe:	85 c0                	test   %eax,%eax
80105cc0:	0f 85 95 fe ff ff    	jne    80105b5b <trap+0x4b>
80105cc6:	e9 ad fe ff ff       	jmp    80105b78 <trap+0x68>
80105ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ccf:	90                   	nop
    kbdintr();
80105cd0:	e8 fb cc ff ff       	call   801029d0 <kbdintr>
    lapiceoi();
80105cd5:	e8 36 ce ff ff       	call   80102b10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cda:	e8 91 de ff ff       	call   80103b70 <myproc>
80105cdf:	85 c0                	test   %eax,%eax
80105ce1:	0f 85 74 fe ff ff    	jne    80105b5b <trap+0x4b>
80105ce7:	e9 8c fe ff ff       	jmp    80105b78 <trap+0x68>
80105cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105cf0:	e8 3b 02 00 00       	call   80105f30 <uartintr>
    lapiceoi();
80105cf5:	e8 16 ce ff ff       	call   80102b10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cfa:	e8 71 de ff ff       	call   80103b70 <myproc>
80105cff:	85 c0                	test   %eax,%eax
80105d01:	0f 85 54 fe ff ff    	jne    80105b5b <trap+0x4b>
80105d07:	e9 6c fe ff ff       	jmp    80105b78 <trap+0x68>
80105d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105d10:	e8 2b c5 ff ff       	call   80102240 <ideintr>
80105d15:	e9 33 fe ff ff       	jmp    80105b4d <trap+0x3d>
80105d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	CoW_handler();
80105d20:	e8 5b 16 00 00       	call   80107380 <CoW_handler>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d25:	e8 46 de ff ff       	call   80103b70 <myproc>
80105d2a:	85 c0                	test   %eax,%eax
80105d2c:	0f 85 29 fe ff ff    	jne    80105b5b <trap+0x4b>
80105d32:	e9 41 fe ff ff       	jmp    80105b78 <trap+0x68>
80105d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d3e:	66 90                	xchg   %ax,%ax
    exit();
80105d40:	e8 4b e2 ff ff       	call   80103f90 <exit>
80105d45:	e9 2e fe ff ff       	jmp    80105b78 <trap+0x68>
80105d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105d50:	e8 3b e2 ff ff       	call   80103f90 <exit>
80105d55:	e9 0e ff ff ff       	jmp    80105c68 <trap+0x158>
80105d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105d60:	83 ec 0c             	sub    $0xc,%esp
80105d63:	68 80 bc 14 80       	push   $0x8014bc80
80105d68:	e8 33 ea ff ff       	call   801047a0 <acquire>
      wakeup(&ticks);
80105d6d:	c7 04 24 60 bc 14 80 	movl   $0x8014bc60,(%esp)
      ticks++;
80105d74:	83 05 60 bc 14 80 01 	addl   $0x1,0x8014bc60
      wakeup(&ticks);
80105d7b:	e8 80 e5 ff ff       	call   80104300 <wakeup>
      release(&tickslock);
80105d80:	c7 04 24 80 bc 14 80 	movl   $0x8014bc80,(%esp)
80105d87:	e8 b4 e9 ff ff       	call   80104740 <release>
80105d8c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105d8f:	e9 b9 fd ff ff       	jmp    80105b4d <trap+0x3d>
80105d94:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d97:	e8 b4 dd ff ff       	call   80103b50 <cpuid>
80105d9c:	83 ec 0c             	sub    $0xc,%esp
80105d9f:	56                   	push   %esi
80105da0:	57                   	push   %edi
80105da1:	50                   	push   %eax
80105da2:	ff 73 30             	push   0x30(%ebx)
80105da5:	68 48 7c 10 80       	push   $0x80107c48
80105daa:	e8 f1 a8 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105daf:	83 c4 14             	add    $0x14,%esp
80105db2:	68 1e 7c 10 80       	push   $0x80107c1e
80105db7:	e8 c4 a5 ff ff       	call   80100380 <panic>
80105dbc:	66 90                	xchg   %ax,%ax
80105dbe:	66 90                	xchg   %ax,%ax

80105dc0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105dc0:	a1 c0 c4 14 80       	mov    0x8014c4c0,%eax
80105dc5:	85 c0                	test   %eax,%eax
80105dc7:	74 17                	je     80105de0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105dc9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105dce:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105dcf:	a8 01                	test   $0x1,%al
80105dd1:	74 0d                	je     80105de0 <uartgetc+0x20>
80105dd3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dd8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105dd9:	0f b6 c0             	movzbl %al,%eax
80105ddc:	c3                   	ret    
80105ddd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105de5:	c3                   	ret    
80105de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ded:	8d 76 00             	lea    0x0(%esi),%esi

80105df0 <uartinit>:
{
80105df0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105df1:	31 c9                	xor    %ecx,%ecx
80105df3:	89 c8                	mov    %ecx,%eax
80105df5:	89 e5                	mov    %esp,%ebp
80105df7:	57                   	push   %edi
80105df8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105dfd:	56                   	push   %esi
80105dfe:	89 fa                	mov    %edi,%edx
80105e00:	53                   	push   %ebx
80105e01:	83 ec 1c             	sub    $0x1c,%esp
80105e04:	ee                   	out    %al,(%dx)
80105e05:	be fb 03 00 00       	mov    $0x3fb,%esi
80105e0a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e0f:	89 f2                	mov    %esi,%edx
80105e11:	ee                   	out    %al,(%dx)
80105e12:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e17:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e1c:	ee                   	out    %al,(%dx)
80105e1d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105e22:	89 c8                	mov    %ecx,%eax
80105e24:	89 da                	mov    %ebx,%edx
80105e26:	ee                   	out    %al,(%dx)
80105e27:	b8 03 00 00 00       	mov    $0x3,%eax
80105e2c:	89 f2                	mov    %esi,%edx
80105e2e:	ee                   	out    %al,(%dx)
80105e2f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e34:	89 c8                	mov    %ecx,%eax
80105e36:	ee                   	out    %al,(%dx)
80105e37:	b8 01 00 00 00       	mov    $0x1,%eax
80105e3c:	89 da                	mov    %ebx,%edx
80105e3e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e3f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e44:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e45:	3c ff                	cmp    $0xff,%al
80105e47:	74 78                	je     80105ec1 <uartinit+0xd1>
  uart = 1;
80105e49:	c7 05 c0 c4 14 80 01 	movl   $0x1,0x8014c4c0
80105e50:	00 00 00 
80105e53:	89 fa                	mov    %edi,%edx
80105e55:	ec                   	in     (%dx),%al
80105e56:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e5b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105e5c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105e5f:	bf 88 7d 10 80       	mov    $0x80107d88,%edi
80105e64:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105e69:	6a 00                	push   $0x0
80105e6b:	6a 04                	push   $0x4
80105e6d:	e8 0e c6 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105e72:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105e76:	83 c4 10             	add    $0x10,%esp
80105e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105e80:	a1 c0 c4 14 80       	mov    0x8014c4c0,%eax
80105e85:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e8a:	85 c0                	test   %eax,%eax
80105e8c:	75 14                	jne    80105ea2 <uartinit+0xb2>
80105e8e:	eb 23                	jmp    80105eb3 <uartinit+0xc3>
    microdelay(10);
80105e90:	83 ec 0c             	sub    $0xc,%esp
80105e93:	6a 0a                	push   $0xa
80105e95:	e8 96 cc ff ff       	call   80102b30 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e9a:	83 c4 10             	add    $0x10,%esp
80105e9d:	83 eb 01             	sub    $0x1,%ebx
80105ea0:	74 07                	je     80105ea9 <uartinit+0xb9>
80105ea2:	89 f2                	mov    %esi,%edx
80105ea4:	ec                   	in     (%dx),%al
80105ea5:	a8 20                	test   $0x20,%al
80105ea7:	74 e7                	je     80105e90 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ea9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105ead:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105eb2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105eb3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105eb7:	83 c7 01             	add    $0x1,%edi
80105eba:	88 45 e7             	mov    %al,-0x19(%ebp)
80105ebd:	84 c0                	test   %al,%al
80105ebf:	75 bf                	jne    80105e80 <uartinit+0x90>
}
80105ec1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ec4:	5b                   	pop    %ebx
80105ec5:	5e                   	pop    %esi
80105ec6:	5f                   	pop    %edi
80105ec7:	5d                   	pop    %ebp
80105ec8:	c3                   	ret    
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ed0 <uartputc>:
  if(!uart)
80105ed0:	a1 c0 c4 14 80       	mov    0x8014c4c0,%eax
80105ed5:	85 c0                	test   %eax,%eax
80105ed7:	74 47                	je     80105f20 <uartputc+0x50>
{
80105ed9:	55                   	push   %ebp
80105eda:	89 e5                	mov    %esp,%ebp
80105edc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105edd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ee2:	53                   	push   %ebx
80105ee3:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ee8:	eb 18                	jmp    80105f02 <uartputc+0x32>
80105eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105ef0:	83 ec 0c             	sub    $0xc,%esp
80105ef3:	6a 0a                	push   $0xa
80105ef5:	e8 36 cc ff ff       	call   80102b30 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105efa:	83 c4 10             	add    $0x10,%esp
80105efd:	83 eb 01             	sub    $0x1,%ebx
80105f00:	74 07                	je     80105f09 <uartputc+0x39>
80105f02:	89 f2                	mov    %esi,%edx
80105f04:	ec                   	in     (%dx),%al
80105f05:	a8 20                	test   $0x20,%al
80105f07:	74 e7                	je     80105ef0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f09:	8b 45 08             	mov    0x8(%ebp),%eax
80105f0c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f11:	ee                   	out    %al,(%dx)
}
80105f12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f15:	5b                   	pop    %ebx
80105f16:	5e                   	pop    %esi
80105f17:	5d                   	pop    %ebp
80105f18:	c3                   	ret    
80105f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f20:	c3                   	ret    
80105f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2f:	90                   	nop

80105f30 <uartintr>:

void
uartintr(void)
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105f36:	68 c0 5d 10 80       	push   $0x80105dc0
80105f3b:	e8 40 a9 ff ff       	call   80100880 <consoleintr>
}
80105f40:	83 c4 10             	add    $0x10,%esp
80105f43:	c9                   	leave  
80105f44:	c3                   	ret    

80105f45 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105f45:	6a 00                	push   $0x0
  pushl $0
80105f47:	6a 00                	push   $0x0
  jmp alltraps
80105f49:	e9 ec fa ff ff       	jmp    80105a3a <alltraps>

80105f4e <vector1>:
.globl vector1
vector1:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $1
80105f50:	6a 01                	push   $0x1
  jmp alltraps
80105f52:	e9 e3 fa ff ff       	jmp    80105a3a <alltraps>

80105f57 <vector2>:
.globl vector2
vector2:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $2
80105f59:	6a 02                	push   $0x2
  jmp alltraps
80105f5b:	e9 da fa ff ff       	jmp    80105a3a <alltraps>

80105f60 <vector3>:
.globl vector3
vector3:
  pushl $0
80105f60:	6a 00                	push   $0x0
  pushl $3
80105f62:	6a 03                	push   $0x3
  jmp alltraps
80105f64:	e9 d1 fa ff ff       	jmp    80105a3a <alltraps>

80105f69 <vector4>:
.globl vector4
vector4:
  pushl $0
80105f69:	6a 00                	push   $0x0
  pushl $4
80105f6b:	6a 04                	push   $0x4
  jmp alltraps
80105f6d:	e9 c8 fa ff ff       	jmp    80105a3a <alltraps>

80105f72 <vector5>:
.globl vector5
vector5:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $5
80105f74:	6a 05                	push   $0x5
  jmp alltraps
80105f76:	e9 bf fa ff ff       	jmp    80105a3a <alltraps>

80105f7b <vector6>:
.globl vector6
vector6:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $6
80105f7d:	6a 06                	push   $0x6
  jmp alltraps
80105f7f:	e9 b6 fa ff ff       	jmp    80105a3a <alltraps>

80105f84 <vector7>:
.globl vector7
vector7:
  pushl $0
80105f84:	6a 00                	push   $0x0
  pushl $7
80105f86:	6a 07                	push   $0x7
  jmp alltraps
80105f88:	e9 ad fa ff ff       	jmp    80105a3a <alltraps>

80105f8d <vector8>:
.globl vector8
vector8:
  pushl $8
80105f8d:	6a 08                	push   $0x8
  jmp alltraps
80105f8f:	e9 a6 fa ff ff       	jmp    80105a3a <alltraps>

80105f94 <vector9>:
.globl vector9
vector9:
  pushl $0
80105f94:	6a 00                	push   $0x0
  pushl $9
80105f96:	6a 09                	push   $0x9
  jmp alltraps
80105f98:	e9 9d fa ff ff       	jmp    80105a3a <alltraps>

80105f9d <vector10>:
.globl vector10
vector10:
  pushl $10
80105f9d:	6a 0a                	push   $0xa
  jmp alltraps
80105f9f:	e9 96 fa ff ff       	jmp    80105a3a <alltraps>

80105fa4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105fa4:	6a 0b                	push   $0xb
  jmp alltraps
80105fa6:	e9 8f fa ff ff       	jmp    80105a3a <alltraps>

80105fab <vector12>:
.globl vector12
vector12:
  pushl $12
80105fab:	6a 0c                	push   $0xc
  jmp alltraps
80105fad:	e9 88 fa ff ff       	jmp    80105a3a <alltraps>

80105fb2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105fb2:	6a 0d                	push   $0xd
  jmp alltraps
80105fb4:	e9 81 fa ff ff       	jmp    80105a3a <alltraps>

80105fb9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105fb9:	6a 0e                	push   $0xe
  jmp alltraps
80105fbb:	e9 7a fa ff ff       	jmp    80105a3a <alltraps>

80105fc0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $15
80105fc2:	6a 0f                	push   $0xf
  jmp alltraps
80105fc4:	e9 71 fa ff ff       	jmp    80105a3a <alltraps>

80105fc9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $16
80105fcb:	6a 10                	push   $0x10
  jmp alltraps
80105fcd:	e9 68 fa ff ff       	jmp    80105a3a <alltraps>

80105fd2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105fd2:	6a 11                	push   $0x11
  jmp alltraps
80105fd4:	e9 61 fa ff ff       	jmp    80105a3a <alltraps>

80105fd9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105fd9:	6a 00                	push   $0x0
  pushl $18
80105fdb:	6a 12                	push   $0x12
  jmp alltraps
80105fdd:	e9 58 fa ff ff       	jmp    80105a3a <alltraps>

80105fe2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $19
80105fe4:	6a 13                	push   $0x13
  jmp alltraps
80105fe6:	e9 4f fa ff ff       	jmp    80105a3a <alltraps>

80105feb <vector20>:
.globl vector20
vector20:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $20
80105fed:	6a 14                	push   $0x14
  jmp alltraps
80105fef:	e9 46 fa ff ff       	jmp    80105a3a <alltraps>

80105ff4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ff4:	6a 00                	push   $0x0
  pushl $21
80105ff6:	6a 15                	push   $0x15
  jmp alltraps
80105ff8:	e9 3d fa ff ff       	jmp    80105a3a <alltraps>

80105ffd <vector22>:
.globl vector22
vector22:
  pushl $0
80105ffd:	6a 00                	push   $0x0
  pushl $22
80105fff:	6a 16                	push   $0x16
  jmp alltraps
80106001:	e9 34 fa ff ff       	jmp    80105a3a <alltraps>

80106006 <vector23>:
.globl vector23
vector23:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $23
80106008:	6a 17                	push   $0x17
  jmp alltraps
8010600a:	e9 2b fa ff ff       	jmp    80105a3a <alltraps>

8010600f <vector24>:
.globl vector24
vector24:
  pushl $0
8010600f:	6a 00                	push   $0x0
  pushl $24
80106011:	6a 18                	push   $0x18
  jmp alltraps
80106013:	e9 22 fa ff ff       	jmp    80105a3a <alltraps>

80106018 <vector25>:
.globl vector25
vector25:
  pushl $0
80106018:	6a 00                	push   $0x0
  pushl $25
8010601a:	6a 19                	push   $0x19
  jmp alltraps
8010601c:	e9 19 fa ff ff       	jmp    80105a3a <alltraps>

80106021 <vector26>:
.globl vector26
vector26:
  pushl $0
80106021:	6a 00                	push   $0x0
  pushl $26
80106023:	6a 1a                	push   $0x1a
  jmp alltraps
80106025:	e9 10 fa ff ff       	jmp    80105a3a <alltraps>

8010602a <vector27>:
.globl vector27
vector27:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $27
8010602c:	6a 1b                	push   $0x1b
  jmp alltraps
8010602e:	e9 07 fa ff ff       	jmp    80105a3a <alltraps>

80106033 <vector28>:
.globl vector28
vector28:
  pushl $0
80106033:	6a 00                	push   $0x0
  pushl $28
80106035:	6a 1c                	push   $0x1c
  jmp alltraps
80106037:	e9 fe f9 ff ff       	jmp    80105a3a <alltraps>

8010603c <vector29>:
.globl vector29
vector29:
  pushl $0
8010603c:	6a 00                	push   $0x0
  pushl $29
8010603e:	6a 1d                	push   $0x1d
  jmp alltraps
80106040:	e9 f5 f9 ff ff       	jmp    80105a3a <alltraps>

80106045 <vector30>:
.globl vector30
vector30:
  pushl $0
80106045:	6a 00                	push   $0x0
  pushl $30
80106047:	6a 1e                	push   $0x1e
  jmp alltraps
80106049:	e9 ec f9 ff ff       	jmp    80105a3a <alltraps>

8010604e <vector31>:
.globl vector31
vector31:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $31
80106050:	6a 1f                	push   $0x1f
  jmp alltraps
80106052:	e9 e3 f9 ff ff       	jmp    80105a3a <alltraps>

80106057 <vector32>:
.globl vector32
vector32:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $32
80106059:	6a 20                	push   $0x20
  jmp alltraps
8010605b:	e9 da f9 ff ff       	jmp    80105a3a <alltraps>

80106060 <vector33>:
.globl vector33
vector33:
  pushl $0
80106060:	6a 00                	push   $0x0
  pushl $33
80106062:	6a 21                	push   $0x21
  jmp alltraps
80106064:	e9 d1 f9 ff ff       	jmp    80105a3a <alltraps>

80106069 <vector34>:
.globl vector34
vector34:
  pushl $0
80106069:	6a 00                	push   $0x0
  pushl $34
8010606b:	6a 22                	push   $0x22
  jmp alltraps
8010606d:	e9 c8 f9 ff ff       	jmp    80105a3a <alltraps>

80106072 <vector35>:
.globl vector35
vector35:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $35
80106074:	6a 23                	push   $0x23
  jmp alltraps
80106076:	e9 bf f9 ff ff       	jmp    80105a3a <alltraps>

8010607b <vector36>:
.globl vector36
vector36:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $36
8010607d:	6a 24                	push   $0x24
  jmp alltraps
8010607f:	e9 b6 f9 ff ff       	jmp    80105a3a <alltraps>

80106084 <vector37>:
.globl vector37
vector37:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $37
80106086:	6a 25                	push   $0x25
  jmp alltraps
80106088:	e9 ad f9 ff ff       	jmp    80105a3a <alltraps>

8010608d <vector38>:
.globl vector38
vector38:
  pushl $0
8010608d:	6a 00                	push   $0x0
  pushl $38
8010608f:	6a 26                	push   $0x26
  jmp alltraps
80106091:	e9 a4 f9 ff ff       	jmp    80105a3a <alltraps>

80106096 <vector39>:
.globl vector39
vector39:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $39
80106098:	6a 27                	push   $0x27
  jmp alltraps
8010609a:	e9 9b f9 ff ff       	jmp    80105a3a <alltraps>

8010609f <vector40>:
.globl vector40
vector40:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $40
801060a1:	6a 28                	push   $0x28
  jmp alltraps
801060a3:	e9 92 f9 ff ff       	jmp    80105a3a <alltraps>

801060a8 <vector41>:
.globl vector41
vector41:
  pushl $0
801060a8:	6a 00                	push   $0x0
  pushl $41
801060aa:	6a 29                	push   $0x29
  jmp alltraps
801060ac:	e9 89 f9 ff ff       	jmp    80105a3a <alltraps>

801060b1 <vector42>:
.globl vector42
vector42:
  pushl $0
801060b1:	6a 00                	push   $0x0
  pushl $42
801060b3:	6a 2a                	push   $0x2a
  jmp alltraps
801060b5:	e9 80 f9 ff ff       	jmp    80105a3a <alltraps>

801060ba <vector43>:
.globl vector43
vector43:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $43
801060bc:	6a 2b                	push   $0x2b
  jmp alltraps
801060be:	e9 77 f9 ff ff       	jmp    80105a3a <alltraps>

801060c3 <vector44>:
.globl vector44
vector44:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $44
801060c5:	6a 2c                	push   $0x2c
  jmp alltraps
801060c7:	e9 6e f9 ff ff       	jmp    80105a3a <alltraps>

801060cc <vector45>:
.globl vector45
vector45:
  pushl $0
801060cc:	6a 00                	push   $0x0
  pushl $45
801060ce:	6a 2d                	push   $0x2d
  jmp alltraps
801060d0:	e9 65 f9 ff ff       	jmp    80105a3a <alltraps>

801060d5 <vector46>:
.globl vector46
vector46:
  pushl $0
801060d5:	6a 00                	push   $0x0
  pushl $46
801060d7:	6a 2e                	push   $0x2e
  jmp alltraps
801060d9:	e9 5c f9 ff ff       	jmp    80105a3a <alltraps>

801060de <vector47>:
.globl vector47
vector47:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $47
801060e0:	6a 2f                	push   $0x2f
  jmp alltraps
801060e2:	e9 53 f9 ff ff       	jmp    80105a3a <alltraps>

801060e7 <vector48>:
.globl vector48
vector48:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $48
801060e9:	6a 30                	push   $0x30
  jmp alltraps
801060eb:	e9 4a f9 ff ff       	jmp    80105a3a <alltraps>

801060f0 <vector49>:
.globl vector49
vector49:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $49
801060f2:	6a 31                	push   $0x31
  jmp alltraps
801060f4:	e9 41 f9 ff ff       	jmp    80105a3a <alltraps>

801060f9 <vector50>:
.globl vector50
vector50:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $50
801060fb:	6a 32                	push   $0x32
  jmp alltraps
801060fd:	e9 38 f9 ff ff       	jmp    80105a3a <alltraps>

80106102 <vector51>:
.globl vector51
vector51:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $51
80106104:	6a 33                	push   $0x33
  jmp alltraps
80106106:	e9 2f f9 ff ff       	jmp    80105a3a <alltraps>

8010610b <vector52>:
.globl vector52
vector52:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $52
8010610d:	6a 34                	push   $0x34
  jmp alltraps
8010610f:	e9 26 f9 ff ff       	jmp    80105a3a <alltraps>

80106114 <vector53>:
.globl vector53
vector53:
  pushl $0
80106114:	6a 00                	push   $0x0
  pushl $53
80106116:	6a 35                	push   $0x35
  jmp alltraps
80106118:	e9 1d f9 ff ff       	jmp    80105a3a <alltraps>

8010611d <vector54>:
.globl vector54
vector54:
  pushl $0
8010611d:	6a 00                	push   $0x0
  pushl $54
8010611f:	6a 36                	push   $0x36
  jmp alltraps
80106121:	e9 14 f9 ff ff       	jmp    80105a3a <alltraps>

80106126 <vector55>:
.globl vector55
vector55:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $55
80106128:	6a 37                	push   $0x37
  jmp alltraps
8010612a:	e9 0b f9 ff ff       	jmp    80105a3a <alltraps>

8010612f <vector56>:
.globl vector56
vector56:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $56
80106131:	6a 38                	push   $0x38
  jmp alltraps
80106133:	e9 02 f9 ff ff       	jmp    80105a3a <alltraps>

80106138 <vector57>:
.globl vector57
vector57:
  pushl $0
80106138:	6a 00                	push   $0x0
  pushl $57
8010613a:	6a 39                	push   $0x39
  jmp alltraps
8010613c:	e9 f9 f8 ff ff       	jmp    80105a3a <alltraps>

80106141 <vector58>:
.globl vector58
vector58:
  pushl $0
80106141:	6a 00                	push   $0x0
  pushl $58
80106143:	6a 3a                	push   $0x3a
  jmp alltraps
80106145:	e9 f0 f8 ff ff       	jmp    80105a3a <alltraps>

8010614a <vector59>:
.globl vector59
vector59:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $59
8010614c:	6a 3b                	push   $0x3b
  jmp alltraps
8010614e:	e9 e7 f8 ff ff       	jmp    80105a3a <alltraps>

80106153 <vector60>:
.globl vector60
vector60:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $60
80106155:	6a 3c                	push   $0x3c
  jmp alltraps
80106157:	e9 de f8 ff ff       	jmp    80105a3a <alltraps>

8010615c <vector61>:
.globl vector61
vector61:
  pushl $0
8010615c:	6a 00                	push   $0x0
  pushl $61
8010615e:	6a 3d                	push   $0x3d
  jmp alltraps
80106160:	e9 d5 f8 ff ff       	jmp    80105a3a <alltraps>

80106165 <vector62>:
.globl vector62
vector62:
  pushl $0
80106165:	6a 00                	push   $0x0
  pushl $62
80106167:	6a 3e                	push   $0x3e
  jmp alltraps
80106169:	e9 cc f8 ff ff       	jmp    80105a3a <alltraps>

8010616e <vector63>:
.globl vector63
vector63:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $63
80106170:	6a 3f                	push   $0x3f
  jmp alltraps
80106172:	e9 c3 f8 ff ff       	jmp    80105a3a <alltraps>

80106177 <vector64>:
.globl vector64
vector64:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $64
80106179:	6a 40                	push   $0x40
  jmp alltraps
8010617b:	e9 ba f8 ff ff       	jmp    80105a3a <alltraps>

80106180 <vector65>:
.globl vector65
vector65:
  pushl $0
80106180:	6a 00                	push   $0x0
  pushl $65
80106182:	6a 41                	push   $0x41
  jmp alltraps
80106184:	e9 b1 f8 ff ff       	jmp    80105a3a <alltraps>

80106189 <vector66>:
.globl vector66
vector66:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $66
8010618b:	6a 42                	push   $0x42
  jmp alltraps
8010618d:	e9 a8 f8 ff ff       	jmp    80105a3a <alltraps>

80106192 <vector67>:
.globl vector67
vector67:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $67
80106194:	6a 43                	push   $0x43
  jmp alltraps
80106196:	e9 9f f8 ff ff       	jmp    80105a3a <alltraps>

8010619b <vector68>:
.globl vector68
vector68:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $68
8010619d:	6a 44                	push   $0x44
  jmp alltraps
8010619f:	e9 96 f8 ff ff       	jmp    80105a3a <alltraps>

801061a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $69
801061a6:	6a 45                	push   $0x45
  jmp alltraps
801061a8:	e9 8d f8 ff ff       	jmp    80105a3a <alltraps>

801061ad <vector70>:
.globl vector70
vector70:
  pushl $0
801061ad:	6a 00                	push   $0x0
  pushl $70
801061af:	6a 46                	push   $0x46
  jmp alltraps
801061b1:	e9 84 f8 ff ff       	jmp    80105a3a <alltraps>

801061b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $71
801061b8:	6a 47                	push   $0x47
  jmp alltraps
801061ba:	e9 7b f8 ff ff       	jmp    80105a3a <alltraps>

801061bf <vector72>:
.globl vector72
vector72:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $72
801061c1:	6a 48                	push   $0x48
  jmp alltraps
801061c3:	e9 72 f8 ff ff       	jmp    80105a3a <alltraps>

801061c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801061c8:	6a 00                	push   $0x0
  pushl $73
801061ca:	6a 49                	push   $0x49
  jmp alltraps
801061cc:	e9 69 f8 ff ff       	jmp    80105a3a <alltraps>

801061d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801061d1:	6a 00                	push   $0x0
  pushl $74
801061d3:	6a 4a                	push   $0x4a
  jmp alltraps
801061d5:	e9 60 f8 ff ff       	jmp    80105a3a <alltraps>

801061da <vector75>:
.globl vector75
vector75:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $75
801061dc:	6a 4b                	push   $0x4b
  jmp alltraps
801061de:	e9 57 f8 ff ff       	jmp    80105a3a <alltraps>

801061e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $76
801061e5:	6a 4c                	push   $0x4c
  jmp alltraps
801061e7:	e9 4e f8 ff ff       	jmp    80105a3a <alltraps>

801061ec <vector77>:
.globl vector77
vector77:
  pushl $0
801061ec:	6a 00                	push   $0x0
  pushl $77
801061ee:	6a 4d                	push   $0x4d
  jmp alltraps
801061f0:	e9 45 f8 ff ff       	jmp    80105a3a <alltraps>

801061f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $78
801061f7:	6a 4e                	push   $0x4e
  jmp alltraps
801061f9:	e9 3c f8 ff ff       	jmp    80105a3a <alltraps>

801061fe <vector79>:
.globl vector79
vector79:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $79
80106200:	6a 4f                	push   $0x4f
  jmp alltraps
80106202:	e9 33 f8 ff ff       	jmp    80105a3a <alltraps>

80106207 <vector80>:
.globl vector80
vector80:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $80
80106209:	6a 50                	push   $0x50
  jmp alltraps
8010620b:	e9 2a f8 ff ff       	jmp    80105a3a <alltraps>

80106210 <vector81>:
.globl vector81
vector81:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $81
80106212:	6a 51                	push   $0x51
  jmp alltraps
80106214:	e9 21 f8 ff ff       	jmp    80105a3a <alltraps>

80106219 <vector82>:
.globl vector82
vector82:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $82
8010621b:	6a 52                	push   $0x52
  jmp alltraps
8010621d:	e9 18 f8 ff ff       	jmp    80105a3a <alltraps>

80106222 <vector83>:
.globl vector83
vector83:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $83
80106224:	6a 53                	push   $0x53
  jmp alltraps
80106226:	e9 0f f8 ff ff       	jmp    80105a3a <alltraps>

8010622b <vector84>:
.globl vector84
vector84:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $84
8010622d:	6a 54                	push   $0x54
  jmp alltraps
8010622f:	e9 06 f8 ff ff       	jmp    80105a3a <alltraps>

80106234 <vector85>:
.globl vector85
vector85:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $85
80106236:	6a 55                	push   $0x55
  jmp alltraps
80106238:	e9 fd f7 ff ff       	jmp    80105a3a <alltraps>

8010623d <vector86>:
.globl vector86
vector86:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $86
8010623f:	6a 56                	push   $0x56
  jmp alltraps
80106241:	e9 f4 f7 ff ff       	jmp    80105a3a <alltraps>

80106246 <vector87>:
.globl vector87
vector87:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $87
80106248:	6a 57                	push   $0x57
  jmp alltraps
8010624a:	e9 eb f7 ff ff       	jmp    80105a3a <alltraps>

8010624f <vector88>:
.globl vector88
vector88:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $88
80106251:	6a 58                	push   $0x58
  jmp alltraps
80106253:	e9 e2 f7 ff ff       	jmp    80105a3a <alltraps>

80106258 <vector89>:
.globl vector89
vector89:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $89
8010625a:	6a 59                	push   $0x59
  jmp alltraps
8010625c:	e9 d9 f7 ff ff       	jmp    80105a3a <alltraps>

80106261 <vector90>:
.globl vector90
vector90:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $90
80106263:	6a 5a                	push   $0x5a
  jmp alltraps
80106265:	e9 d0 f7 ff ff       	jmp    80105a3a <alltraps>

8010626a <vector91>:
.globl vector91
vector91:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $91
8010626c:	6a 5b                	push   $0x5b
  jmp alltraps
8010626e:	e9 c7 f7 ff ff       	jmp    80105a3a <alltraps>

80106273 <vector92>:
.globl vector92
vector92:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $92
80106275:	6a 5c                	push   $0x5c
  jmp alltraps
80106277:	e9 be f7 ff ff       	jmp    80105a3a <alltraps>

8010627c <vector93>:
.globl vector93
vector93:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $93
8010627e:	6a 5d                	push   $0x5d
  jmp alltraps
80106280:	e9 b5 f7 ff ff       	jmp    80105a3a <alltraps>

80106285 <vector94>:
.globl vector94
vector94:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $94
80106287:	6a 5e                	push   $0x5e
  jmp alltraps
80106289:	e9 ac f7 ff ff       	jmp    80105a3a <alltraps>

8010628e <vector95>:
.globl vector95
vector95:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $95
80106290:	6a 5f                	push   $0x5f
  jmp alltraps
80106292:	e9 a3 f7 ff ff       	jmp    80105a3a <alltraps>

80106297 <vector96>:
.globl vector96
vector96:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $96
80106299:	6a 60                	push   $0x60
  jmp alltraps
8010629b:	e9 9a f7 ff ff       	jmp    80105a3a <alltraps>

801062a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $97
801062a2:	6a 61                	push   $0x61
  jmp alltraps
801062a4:	e9 91 f7 ff ff       	jmp    80105a3a <alltraps>

801062a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $98
801062ab:	6a 62                	push   $0x62
  jmp alltraps
801062ad:	e9 88 f7 ff ff       	jmp    80105a3a <alltraps>

801062b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $99
801062b4:	6a 63                	push   $0x63
  jmp alltraps
801062b6:	e9 7f f7 ff ff       	jmp    80105a3a <alltraps>

801062bb <vector100>:
.globl vector100
vector100:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $100
801062bd:	6a 64                	push   $0x64
  jmp alltraps
801062bf:	e9 76 f7 ff ff       	jmp    80105a3a <alltraps>

801062c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $101
801062c6:	6a 65                	push   $0x65
  jmp alltraps
801062c8:	e9 6d f7 ff ff       	jmp    80105a3a <alltraps>

801062cd <vector102>:
.globl vector102
vector102:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $102
801062cf:	6a 66                	push   $0x66
  jmp alltraps
801062d1:	e9 64 f7 ff ff       	jmp    80105a3a <alltraps>

801062d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $103
801062d8:	6a 67                	push   $0x67
  jmp alltraps
801062da:	e9 5b f7 ff ff       	jmp    80105a3a <alltraps>

801062df <vector104>:
.globl vector104
vector104:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $104
801062e1:	6a 68                	push   $0x68
  jmp alltraps
801062e3:	e9 52 f7 ff ff       	jmp    80105a3a <alltraps>

801062e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $105
801062ea:	6a 69                	push   $0x69
  jmp alltraps
801062ec:	e9 49 f7 ff ff       	jmp    80105a3a <alltraps>

801062f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $106
801062f3:	6a 6a                	push   $0x6a
  jmp alltraps
801062f5:	e9 40 f7 ff ff       	jmp    80105a3a <alltraps>

801062fa <vector107>:
.globl vector107
vector107:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $107
801062fc:	6a 6b                	push   $0x6b
  jmp alltraps
801062fe:	e9 37 f7 ff ff       	jmp    80105a3a <alltraps>

80106303 <vector108>:
.globl vector108
vector108:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $108
80106305:	6a 6c                	push   $0x6c
  jmp alltraps
80106307:	e9 2e f7 ff ff       	jmp    80105a3a <alltraps>

8010630c <vector109>:
.globl vector109
vector109:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $109
8010630e:	6a 6d                	push   $0x6d
  jmp alltraps
80106310:	e9 25 f7 ff ff       	jmp    80105a3a <alltraps>

80106315 <vector110>:
.globl vector110
vector110:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $110
80106317:	6a 6e                	push   $0x6e
  jmp alltraps
80106319:	e9 1c f7 ff ff       	jmp    80105a3a <alltraps>

8010631e <vector111>:
.globl vector111
vector111:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $111
80106320:	6a 6f                	push   $0x6f
  jmp alltraps
80106322:	e9 13 f7 ff ff       	jmp    80105a3a <alltraps>

80106327 <vector112>:
.globl vector112
vector112:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $112
80106329:	6a 70                	push   $0x70
  jmp alltraps
8010632b:	e9 0a f7 ff ff       	jmp    80105a3a <alltraps>

80106330 <vector113>:
.globl vector113
vector113:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $113
80106332:	6a 71                	push   $0x71
  jmp alltraps
80106334:	e9 01 f7 ff ff       	jmp    80105a3a <alltraps>

80106339 <vector114>:
.globl vector114
vector114:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $114
8010633b:	6a 72                	push   $0x72
  jmp alltraps
8010633d:	e9 f8 f6 ff ff       	jmp    80105a3a <alltraps>

80106342 <vector115>:
.globl vector115
vector115:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $115
80106344:	6a 73                	push   $0x73
  jmp alltraps
80106346:	e9 ef f6 ff ff       	jmp    80105a3a <alltraps>

8010634b <vector116>:
.globl vector116
vector116:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $116
8010634d:	6a 74                	push   $0x74
  jmp alltraps
8010634f:	e9 e6 f6 ff ff       	jmp    80105a3a <alltraps>

80106354 <vector117>:
.globl vector117
vector117:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $117
80106356:	6a 75                	push   $0x75
  jmp alltraps
80106358:	e9 dd f6 ff ff       	jmp    80105a3a <alltraps>

8010635d <vector118>:
.globl vector118
vector118:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $118
8010635f:	6a 76                	push   $0x76
  jmp alltraps
80106361:	e9 d4 f6 ff ff       	jmp    80105a3a <alltraps>

80106366 <vector119>:
.globl vector119
vector119:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $119
80106368:	6a 77                	push   $0x77
  jmp alltraps
8010636a:	e9 cb f6 ff ff       	jmp    80105a3a <alltraps>

8010636f <vector120>:
.globl vector120
vector120:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $120
80106371:	6a 78                	push   $0x78
  jmp alltraps
80106373:	e9 c2 f6 ff ff       	jmp    80105a3a <alltraps>

80106378 <vector121>:
.globl vector121
vector121:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $121
8010637a:	6a 79                	push   $0x79
  jmp alltraps
8010637c:	e9 b9 f6 ff ff       	jmp    80105a3a <alltraps>

80106381 <vector122>:
.globl vector122
vector122:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $122
80106383:	6a 7a                	push   $0x7a
  jmp alltraps
80106385:	e9 b0 f6 ff ff       	jmp    80105a3a <alltraps>

8010638a <vector123>:
.globl vector123
vector123:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $123
8010638c:	6a 7b                	push   $0x7b
  jmp alltraps
8010638e:	e9 a7 f6 ff ff       	jmp    80105a3a <alltraps>

80106393 <vector124>:
.globl vector124
vector124:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $124
80106395:	6a 7c                	push   $0x7c
  jmp alltraps
80106397:	e9 9e f6 ff ff       	jmp    80105a3a <alltraps>

8010639c <vector125>:
.globl vector125
vector125:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $125
8010639e:	6a 7d                	push   $0x7d
  jmp alltraps
801063a0:	e9 95 f6 ff ff       	jmp    80105a3a <alltraps>

801063a5 <vector126>:
.globl vector126
vector126:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $126
801063a7:	6a 7e                	push   $0x7e
  jmp alltraps
801063a9:	e9 8c f6 ff ff       	jmp    80105a3a <alltraps>

801063ae <vector127>:
.globl vector127
vector127:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $127
801063b0:	6a 7f                	push   $0x7f
  jmp alltraps
801063b2:	e9 83 f6 ff ff       	jmp    80105a3a <alltraps>

801063b7 <vector128>:
.globl vector128
vector128:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $128
801063b9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801063be:	e9 77 f6 ff ff       	jmp    80105a3a <alltraps>

801063c3 <vector129>:
.globl vector129
vector129:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $129
801063c5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801063ca:	e9 6b f6 ff ff       	jmp    80105a3a <alltraps>

801063cf <vector130>:
.globl vector130
vector130:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $130
801063d1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801063d6:	e9 5f f6 ff ff       	jmp    80105a3a <alltraps>

801063db <vector131>:
.globl vector131
vector131:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $131
801063dd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801063e2:	e9 53 f6 ff ff       	jmp    80105a3a <alltraps>

801063e7 <vector132>:
.globl vector132
vector132:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $132
801063e9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801063ee:	e9 47 f6 ff ff       	jmp    80105a3a <alltraps>

801063f3 <vector133>:
.globl vector133
vector133:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $133
801063f5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801063fa:	e9 3b f6 ff ff       	jmp    80105a3a <alltraps>

801063ff <vector134>:
.globl vector134
vector134:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $134
80106401:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106406:	e9 2f f6 ff ff       	jmp    80105a3a <alltraps>

8010640b <vector135>:
.globl vector135
vector135:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $135
8010640d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106412:	e9 23 f6 ff ff       	jmp    80105a3a <alltraps>

80106417 <vector136>:
.globl vector136
vector136:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $136
80106419:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010641e:	e9 17 f6 ff ff       	jmp    80105a3a <alltraps>

80106423 <vector137>:
.globl vector137
vector137:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $137
80106425:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010642a:	e9 0b f6 ff ff       	jmp    80105a3a <alltraps>

8010642f <vector138>:
.globl vector138
vector138:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $138
80106431:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106436:	e9 ff f5 ff ff       	jmp    80105a3a <alltraps>

8010643b <vector139>:
.globl vector139
vector139:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $139
8010643d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106442:	e9 f3 f5 ff ff       	jmp    80105a3a <alltraps>

80106447 <vector140>:
.globl vector140
vector140:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $140
80106449:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010644e:	e9 e7 f5 ff ff       	jmp    80105a3a <alltraps>

80106453 <vector141>:
.globl vector141
vector141:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $141
80106455:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010645a:	e9 db f5 ff ff       	jmp    80105a3a <alltraps>

8010645f <vector142>:
.globl vector142
vector142:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $142
80106461:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106466:	e9 cf f5 ff ff       	jmp    80105a3a <alltraps>

8010646b <vector143>:
.globl vector143
vector143:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $143
8010646d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106472:	e9 c3 f5 ff ff       	jmp    80105a3a <alltraps>

80106477 <vector144>:
.globl vector144
vector144:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $144
80106479:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010647e:	e9 b7 f5 ff ff       	jmp    80105a3a <alltraps>

80106483 <vector145>:
.globl vector145
vector145:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $145
80106485:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010648a:	e9 ab f5 ff ff       	jmp    80105a3a <alltraps>

8010648f <vector146>:
.globl vector146
vector146:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $146
80106491:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106496:	e9 9f f5 ff ff       	jmp    80105a3a <alltraps>

8010649b <vector147>:
.globl vector147
vector147:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $147
8010649d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801064a2:	e9 93 f5 ff ff       	jmp    80105a3a <alltraps>

801064a7 <vector148>:
.globl vector148
vector148:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $148
801064a9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801064ae:	e9 87 f5 ff ff       	jmp    80105a3a <alltraps>

801064b3 <vector149>:
.globl vector149
vector149:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $149
801064b5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801064ba:	e9 7b f5 ff ff       	jmp    80105a3a <alltraps>

801064bf <vector150>:
.globl vector150
vector150:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $150
801064c1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801064c6:	e9 6f f5 ff ff       	jmp    80105a3a <alltraps>

801064cb <vector151>:
.globl vector151
vector151:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $151
801064cd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801064d2:	e9 63 f5 ff ff       	jmp    80105a3a <alltraps>

801064d7 <vector152>:
.globl vector152
vector152:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $152
801064d9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801064de:	e9 57 f5 ff ff       	jmp    80105a3a <alltraps>

801064e3 <vector153>:
.globl vector153
vector153:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $153
801064e5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801064ea:	e9 4b f5 ff ff       	jmp    80105a3a <alltraps>

801064ef <vector154>:
.globl vector154
vector154:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $154
801064f1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801064f6:	e9 3f f5 ff ff       	jmp    80105a3a <alltraps>

801064fb <vector155>:
.globl vector155
vector155:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $155
801064fd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106502:	e9 33 f5 ff ff       	jmp    80105a3a <alltraps>

80106507 <vector156>:
.globl vector156
vector156:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $156
80106509:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010650e:	e9 27 f5 ff ff       	jmp    80105a3a <alltraps>

80106513 <vector157>:
.globl vector157
vector157:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $157
80106515:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010651a:	e9 1b f5 ff ff       	jmp    80105a3a <alltraps>

8010651f <vector158>:
.globl vector158
vector158:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $158
80106521:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106526:	e9 0f f5 ff ff       	jmp    80105a3a <alltraps>

8010652b <vector159>:
.globl vector159
vector159:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $159
8010652d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106532:	e9 03 f5 ff ff       	jmp    80105a3a <alltraps>

80106537 <vector160>:
.globl vector160
vector160:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $160
80106539:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010653e:	e9 f7 f4 ff ff       	jmp    80105a3a <alltraps>

80106543 <vector161>:
.globl vector161
vector161:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $161
80106545:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010654a:	e9 eb f4 ff ff       	jmp    80105a3a <alltraps>

8010654f <vector162>:
.globl vector162
vector162:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $162
80106551:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106556:	e9 df f4 ff ff       	jmp    80105a3a <alltraps>

8010655b <vector163>:
.globl vector163
vector163:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $163
8010655d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106562:	e9 d3 f4 ff ff       	jmp    80105a3a <alltraps>

80106567 <vector164>:
.globl vector164
vector164:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $164
80106569:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010656e:	e9 c7 f4 ff ff       	jmp    80105a3a <alltraps>

80106573 <vector165>:
.globl vector165
vector165:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $165
80106575:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010657a:	e9 bb f4 ff ff       	jmp    80105a3a <alltraps>

8010657f <vector166>:
.globl vector166
vector166:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $166
80106581:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106586:	e9 af f4 ff ff       	jmp    80105a3a <alltraps>

8010658b <vector167>:
.globl vector167
vector167:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $167
8010658d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106592:	e9 a3 f4 ff ff       	jmp    80105a3a <alltraps>

80106597 <vector168>:
.globl vector168
vector168:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $168
80106599:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010659e:	e9 97 f4 ff ff       	jmp    80105a3a <alltraps>

801065a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $169
801065a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801065aa:	e9 8b f4 ff ff       	jmp    80105a3a <alltraps>

801065af <vector170>:
.globl vector170
vector170:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $170
801065b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801065b6:	e9 7f f4 ff ff       	jmp    80105a3a <alltraps>

801065bb <vector171>:
.globl vector171
vector171:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $171
801065bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801065c2:	e9 73 f4 ff ff       	jmp    80105a3a <alltraps>

801065c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $172
801065c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801065ce:	e9 67 f4 ff ff       	jmp    80105a3a <alltraps>

801065d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $173
801065d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801065da:	e9 5b f4 ff ff       	jmp    80105a3a <alltraps>

801065df <vector174>:
.globl vector174
vector174:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $174
801065e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801065e6:	e9 4f f4 ff ff       	jmp    80105a3a <alltraps>

801065eb <vector175>:
.globl vector175
vector175:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $175
801065ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801065f2:	e9 43 f4 ff ff       	jmp    80105a3a <alltraps>

801065f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $176
801065f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801065fe:	e9 37 f4 ff ff       	jmp    80105a3a <alltraps>

80106603 <vector177>:
.globl vector177
vector177:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $177
80106605:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010660a:	e9 2b f4 ff ff       	jmp    80105a3a <alltraps>

8010660f <vector178>:
.globl vector178
vector178:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $178
80106611:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106616:	e9 1f f4 ff ff       	jmp    80105a3a <alltraps>

8010661b <vector179>:
.globl vector179
vector179:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $179
8010661d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106622:	e9 13 f4 ff ff       	jmp    80105a3a <alltraps>

80106627 <vector180>:
.globl vector180
vector180:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $180
80106629:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010662e:	e9 07 f4 ff ff       	jmp    80105a3a <alltraps>

80106633 <vector181>:
.globl vector181
vector181:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $181
80106635:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010663a:	e9 fb f3 ff ff       	jmp    80105a3a <alltraps>

8010663f <vector182>:
.globl vector182
vector182:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $182
80106641:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106646:	e9 ef f3 ff ff       	jmp    80105a3a <alltraps>

8010664b <vector183>:
.globl vector183
vector183:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $183
8010664d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106652:	e9 e3 f3 ff ff       	jmp    80105a3a <alltraps>

80106657 <vector184>:
.globl vector184
vector184:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $184
80106659:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010665e:	e9 d7 f3 ff ff       	jmp    80105a3a <alltraps>

80106663 <vector185>:
.globl vector185
vector185:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $185
80106665:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010666a:	e9 cb f3 ff ff       	jmp    80105a3a <alltraps>

8010666f <vector186>:
.globl vector186
vector186:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $186
80106671:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106676:	e9 bf f3 ff ff       	jmp    80105a3a <alltraps>

8010667b <vector187>:
.globl vector187
vector187:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $187
8010667d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106682:	e9 b3 f3 ff ff       	jmp    80105a3a <alltraps>

80106687 <vector188>:
.globl vector188
vector188:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $188
80106689:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010668e:	e9 a7 f3 ff ff       	jmp    80105a3a <alltraps>

80106693 <vector189>:
.globl vector189
vector189:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $189
80106695:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010669a:	e9 9b f3 ff ff       	jmp    80105a3a <alltraps>

8010669f <vector190>:
.globl vector190
vector190:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $190
801066a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801066a6:	e9 8f f3 ff ff       	jmp    80105a3a <alltraps>

801066ab <vector191>:
.globl vector191
vector191:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $191
801066ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801066b2:	e9 83 f3 ff ff       	jmp    80105a3a <alltraps>

801066b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $192
801066b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801066be:	e9 77 f3 ff ff       	jmp    80105a3a <alltraps>

801066c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $193
801066c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801066ca:	e9 6b f3 ff ff       	jmp    80105a3a <alltraps>

801066cf <vector194>:
.globl vector194
vector194:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $194
801066d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801066d6:	e9 5f f3 ff ff       	jmp    80105a3a <alltraps>

801066db <vector195>:
.globl vector195
vector195:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $195
801066dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801066e2:	e9 53 f3 ff ff       	jmp    80105a3a <alltraps>

801066e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $196
801066e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801066ee:	e9 47 f3 ff ff       	jmp    80105a3a <alltraps>

801066f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $197
801066f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801066fa:	e9 3b f3 ff ff       	jmp    80105a3a <alltraps>

801066ff <vector198>:
.globl vector198
vector198:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $198
80106701:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106706:	e9 2f f3 ff ff       	jmp    80105a3a <alltraps>

8010670b <vector199>:
.globl vector199
vector199:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $199
8010670d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106712:	e9 23 f3 ff ff       	jmp    80105a3a <alltraps>

80106717 <vector200>:
.globl vector200
vector200:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $200
80106719:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010671e:	e9 17 f3 ff ff       	jmp    80105a3a <alltraps>

80106723 <vector201>:
.globl vector201
vector201:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $201
80106725:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010672a:	e9 0b f3 ff ff       	jmp    80105a3a <alltraps>

8010672f <vector202>:
.globl vector202
vector202:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $202
80106731:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106736:	e9 ff f2 ff ff       	jmp    80105a3a <alltraps>

8010673b <vector203>:
.globl vector203
vector203:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $203
8010673d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106742:	e9 f3 f2 ff ff       	jmp    80105a3a <alltraps>

80106747 <vector204>:
.globl vector204
vector204:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $204
80106749:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010674e:	e9 e7 f2 ff ff       	jmp    80105a3a <alltraps>

80106753 <vector205>:
.globl vector205
vector205:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $205
80106755:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010675a:	e9 db f2 ff ff       	jmp    80105a3a <alltraps>

8010675f <vector206>:
.globl vector206
vector206:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $206
80106761:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106766:	e9 cf f2 ff ff       	jmp    80105a3a <alltraps>

8010676b <vector207>:
.globl vector207
vector207:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $207
8010676d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106772:	e9 c3 f2 ff ff       	jmp    80105a3a <alltraps>

80106777 <vector208>:
.globl vector208
vector208:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $208
80106779:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010677e:	e9 b7 f2 ff ff       	jmp    80105a3a <alltraps>

80106783 <vector209>:
.globl vector209
vector209:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $209
80106785:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010678a:	e9 ab f2 ff ff       	jmp    80105a3a <alltraps>

8010678f <vector210>:
.globl vector210
vector210:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $210
80106791:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106796:	e9 9f f2 ff ff       	jmp    80105a3a <alltraps>

8010679b <vector211>:
.globl vector211
vector211:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $211
8010679d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801067a2:	e9 93 f2 ff ff       	jmp    80105a3a <alltraps>

801067a7 <vector212>:
.globl vector212
vector212:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $212
801067a9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801067ae:	e9 87 f2 ff ff       	jmp    80105a3a <alltraps>

801067b3 <vector213>:
.globl vector213
vector213:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $213
801067b5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801067ba:	e9 7b f2 ff ff       	jmp    80105a3a <alltraps>

801067bf <vector214>:
.globl vector214
vector214:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $214
801067c1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801067c6:	e9 6f f2 ff ff       	jmp    80105a3a <alltraps>

801067cb <vector215>:
.globl vector215
vector215:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $215
801067cd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801067d2:	e9 63 f2 ff ff       	jmp    80105a3a <alltraps>

801067d7 <vector216>:
.globl vector216
vector216:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $216
801067d9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801067de:	e9 57 f2 ff ff       	jmp    80105a3a <alltraps>

801067e3 <vector217>:
.globl vector217
vector217:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $217
801067e5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801067ea:	e9 4b f2 ff ff       	jmp    80105a3a <alltraps>

801067ef <vector218>:
.globl vector218
vector218:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $218
801067f1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801067f6:	e9 3f f2 ff ff       	jmp    80105a3a <alltraps>

801067fb <vector219>:
.globl vector219
vector219:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $219
801067fd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106802:	e9 33 f2 ff ff       	jmp    80105a3a <alltraps>

80106807 <vector220>:
.globl vector220
vector220:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $220
80106809:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010680e:	e9 27 f2 ff ff       	jmp    80105a3a <alltraps>

80106813 <vector221>:
.globl vector221
vector221:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $221
80106815:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010681a:	e9 1b f2 ff ff       	jmp    80105a3a <alltraps>

8010681f <vector222>:
.globl vector222
vector222:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $222
80106821:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106826:	e9 0f f2 ff ff       	jmp    80105a3a <alltraps>

8010682b <vector223>:
.globl vector223
vector223:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $223
8010682d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106832:	e9 03 f2 ff ff       	jmp    80105a3a <alltraps>

80106837 <vector224>:
.globl vector224
vector224:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $224
80106839:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010683e:	e9 f7 f1 ff ff       	jmp    80105a3a <alltraps>

80106843 <vector225>:
.globl vector225
vector225:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $225
80106845:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010684a:	e9 eb f1 ff ff       	jmp    80105a3a <alltraps>

8010684f <vector226>:
.globl vector226
vector226:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $226
80106851:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106856:	e9 df f1 ff ff       	jmp    80105a3a <alltraps>

8010685b <vector227>:
.globl vector227
vector227:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $227
8010685d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106862:	e9 d3 f1 ff ff       	jmp    80105a3a <alltraps>

80106867 <vector228>:
.globl vector228
vector228:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $228
80106869:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010686e:	e9 c7 f1 ff ff       	jmp    80105a3a <alltraps>

80106873 <vector229>:
.globl vector229
vector229:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $229
80106875:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010687a:	e9 bb f1 ff ff       	jmp    80105a3a <alltraps>

8010687f <vector230>:
.globl vector230
vector230:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $230
80106881:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106886:	e9 af f1 ff ff       	jmp    80105a3a <alltraps>

8010688b <vector231>:
.globl vector231
vector231:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $231
8010688d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106892:	e9 a3 f1 ff ff       	jmp    80105a3a <alltraps>

80106897 <vector232>:
.globl vector232
vector232:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $232
80106899:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010689e:	e9 97 f1 ff ff       	jmp    80105a3a <alltraps>

801068a3 <vector233>:
.globl vector233
vector233:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $233
801068a5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801068aa:	e9 8b f1 ff ff       	jmp    80105a3a <alltraps>

801068af <vector234>:
.globl vector234
vector234:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $234
801068b1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801068b6:	e9 7f f1 ff ff       	jmp    80105a3a <alltraps>

801068bb <vector235>:
.globl vector235
vector235:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $235
801068bd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801068c2:	e9 73 f1 ff ff       	jmp    80105a3a <alltraps>

801068c7 <vector236>:
.globl vector236
vector236:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $236
801068c9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801068ce:	e9 67 f1 ff ff       	jmp    80105a3a <alltraps>

801068d3 <vector237>:
.globl vector237
vector237:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $237
801068d5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801068da:	e9 5b f1 ff ff       	jmp    80105a3a <alltraps>

801068df <vector238>:
.globl vector238
vector238:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $238
801068e1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801068e6:	e9 4f f1 ff ff       	jmp    80105a3a <alltraps>

801068eb <vector239>:
.globl vector239
vector239:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $239
801068ed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801068f2:	e9 43 f1 ff ff       	jmp    80105a3a <alltraps>

801068f7 <vector240>:
.globl vector240
vector240:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $240
801068f9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801068fe:	e9 37 f1 ff ff       	jmp    80105a3a <alltraps>

80106903 <vector241>:
.globl vector241
vector241:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $241
80106905:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010690a:	e9 2b f1 ff ff       	jmp    80105a3a <alltraps>

8010690f <vector242>:
.globl vector242
vector242:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $242
80106911:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106916:	e9 1f f1 ff ff       	jmp    80105a3a <alltraps>

8010691b <vector243>:
.globl vector243
vector243:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $243
8010691d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106922:	e9 13 f1 ff ff       	jmp    80105a3a <alltraps>

80106927 <vector244>:
.globl vector244
vector244:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $244
80106929:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010692e:	e9 07 f1 ff ff       	jmp    80105a3a <alltraps>

80106933 <vector245>:
.globl vector245
vector245:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $245
80106935:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010693a:	e9 fb f0 ff ff       	jmp    80105a3a <alltraps>

8010693f <vector246>:
.globl vector246
vector246:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $246
80106941:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106946:	e9 ef f0 ff ff       	jmp    80105a3a <alltraps>

8010694b <vector247>:
.globl vector247
vector247:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $247
8010694d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106952:	e9 e3 f0 ff ff       	jmp    80105a3a <alltraps>

80106957 <vector248>:
.globl vector248
vector248:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $248
80106959:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010695e:	e9 d7 f0 ff ff       	jmp    80105a3a <alltraps>

80106963 <vector249>:
.globl vector249
vector249:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $249
80106965:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010696a:	e9 cb f0 ff ff       	jmp    80105a3a <alltraps>

8010696f <vector250>:
.globl vector250
vector250:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $250
80106971:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106976:	e9 bf f0 ff ff       	jmp    80105a3a <alltraps>

8010697b <vector251>:
.globl vector251
vector251:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $251
8010697d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106982:	e9 b3 f0 ff ff       	jmp    80105a3a <alltraps>

80106987 <vector252>:
.globl vector252
vector252:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $252
80106989:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010698e:	e9 a7 f0 ff ff       	jmp    80105a3a <alltraps>

80106993 <vector253>:
.globl vector253
vector253:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $253
80106995:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010699a:	e9 9b f0 ff ff       	jmp    80105a3a <alltraps>

8010699f <vector254>:
.globl vector254
vector254:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $254
801069a1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801069a6:	e9 8f f0 ff ff       	jmp    80105a3a <alltraps>

801069ab <vector255>:
.globl vector255
vector255:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $255
801069ad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801069b2:	e9 83 f0 ff ff       	jmp    80105a3a <alltraps>
801069b7:	66 90                	xchg   %ax,%ax
801069b9:	66 90                	xchg   %ax,%ax
801069bb:	66 90                	xchg   %ax,%ax
801069bd:	66 90                	xchg   %ax,%ax
801069bf:	90                   	nop

801069c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	57                   	push   %edi
801069c4:	56                   	push   %esi
801069c5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801069c6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801069cc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069d2:	83 ec 1c             	sub    $0x1c,%esp
801069d5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801069d8:	39 d3                	cmp    %edx,%ebx
801069da:	73 49                	jae    80106a25 <deallocuvm.part.0+0x65>
801069dc:	89 c7                	mov    %eax,%edi
801069de:	eb 0c                	jmp    801069ec <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801069e0:	83 c0 01             	add    $0x1,%eax
801069e3:	c1 e0 16             	shl    $0x16,%eax
801069e6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
801069e8:	39 da                	cmp    %ebx,%edx
801069ea:	76 39                	jbe    80106a25 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
801069ec:	89 d8                	mov    %ebx,%eax
801069ee:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801069f1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
801069f4:	f6 c1 01             	test   $0x1,%cl
801069f7:	74 e7                	je     801069e0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
801069f9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801069fb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106a01:	c1 ee 0a             	shr    $0xa,%esi
80106a04:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106a0a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106a11:	85 f6                	test   %esi,%esi
80106a13:	74 cb                	je     801069e0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106a15:	8b 06                	mov    (%esi),%eax
80106a17:	a8 01                	test   $0x1,%al
80106a19:	75 15                	jne    80106a30 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106a1b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a21:	39 da                	cmp    %ebx,%edx
80106a23:	77 c7                	ja     801069ec <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106a25:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a2b:	5b                   	pop    %ebx
80106a2c:	5e                   	pop    %esi
80106a2d:	5f                   	pop    %edi
80106a2e:	5d                   	pop    %ebp
80106a2f:	c3                   	ret    
      if(pa == 0)
80106a30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a35:	74 25                	je     80106a5c <deallocuvm.part.0+0x9c>
      kfree(v);
80106a37:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106a3a:	05 00 00 00 80       	add    $0x80000000,%eax
80106a3f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a42:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106a48:	50                   	push   %eax
80106a49:	e8 72 ba ff ff       	call   801024c0 <kfree>
      *pte = 0;
80106a4e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106a54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106a57:	83 c4 10             	add    $0x10,%esp
80106a5a:	eb 8c                	jmp    801069e8 <deallocuvm.part.0+0x28>
        panic("kfree");
80106a5c:	83 ec 0c             	sub    $0xc,%esp
80106a5f:	68 06 77 10 80       	push   $0x80107706
80106a64:	e8 17 99 ff ff       	call   80100380 <panic>
80106a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a70 <mappages>:
{
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	57                   	push   %edi
80106a74:	56                   	push   %esi
80106a75:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106a76:	89 d3                	mov    %edx,%ebx
80106a78:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106a7e:	83 ec 1c             	sub    $0x1c,%esp
80106a81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a84:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106a88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a8d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106a90:	8b 45 08             	mov    0x8(%ebp),%eax
80106a93:	29 d8                	sub    %ebx,%eax
80106a95:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a98:	eb 3d                	jmp    80106ad7 <mappages+0x67>
80106a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106aa0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106aa2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106aa7:	c1 ea 0a             	shr    $0xa,%edx
80106aaa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ab0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ab7:	85 c0                	test   %eax,%eax
80106ab9:	74 75                	je     80106b30 <mappages+0xc0>
    if(*pte & PTE_P)
80106abb:	f6 00 01             	testb  $0x1,(%eax)
80106abe:	0f 85 86 00 00 00    	jne    80106b4a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106ac4:	0b 75 0c             	or     0xc(%ebp),%esi
80106ac7:	83 ce 01             	or     $0x1,%esi
80106aca:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106acc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106acf:	74 6f                	je     80106b40 <mappages+0xd0>
    a += PGSIZE;
80106ad1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106ad7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106ada:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106add:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106ae0:	89 d8                	mov    %ebx,%eax
80106ae2:	c1 e8 16             	shr    $0x16,%eax
80106ae5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106ae8:	8b 07                	mov    (%edi),%eax
80106aea:	a8 01                	test   $0x1,%al
80106aec:	75 b2                	jne    80106aa0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106aee:	e8 0d bc ff ff       	call   80102700 <kalloc>
80106af3:	85 c0                	test   %eax,%eax
80106af5:	74 39                	je     80106b30 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106af7:	83 ec 04             	sub    $0x4,%esp
80106afa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106afd:	68 00 10 00 00       	push   $0x1000
80106b02:	6a 00                	push   $0x0
80106b04:	50                   	push   %eax
80106b05:	e8 56 dd ff ff       	call   80104860 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b0a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106b0d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b10:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106b16:	83 c8 07             	or     $0x7,%eax
80106b19:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106b1b:	89 d8                	mov    %ebx,%eax
80106b1d:	c1 e8 0a             	shr    $0xa,%eax
80106b20:	25 fc 0f 00 00       	and    $0xffc,%eax
80106b25:	01 d0                	add    %edx,%eax
80106b27:	eb 92                	jmp    80106abb <mappages+0x4b>
80106b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b38:	5b                   	pop    %ebx
80106b39:	5e                   	pop    %esi
80106b3a:	5f                   	pop    %edi
80106b3b:	5d                   	pop    %ebp
80106b3c:	c3                   	ret    
80106b3d:	8d 76 00             	lea    0x0(%esi),%esi
80106b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b43:	31 c0                	xor    %eax,%eax
}
80106b45:	5b                   	pop    %ebx
80106b46:	5e                   	pop    %esi
80106b47:	5f                   	pop    %edi
80106b48:	5d                   	pop    %ebp
80106b49:	c3                   	ret    
      panic("remap");
80106b4a:	83 ec 0c             	sub    $0xc,%esp
80106b4d:	68 90 7d 10 80       	push   $0x80107d90
80106b52:	e8 29 98 ff ff       	call   80100380 <panic>
80106b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b5e:	66 90                	xchg   %ax,%ax

80106b60 <seginit>:
{
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106b66:	e8 e5 cf ff ff       	call   80103b50 <cpuid>
  pd[0] = size-1;
80106b6b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106b70:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106b76:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b7a:	c7 80 18 98 14 80 ff 	movl   $0xffff,-0x7feb67e8(%eax)
80106b81:	ff 00 00 
80106b84:	c7 80 1c 98 14 80 00 	movl   $0xcf9a00,-0x7feb67e4(%eax)
80106b8b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b8e:	c7 80 20 98 14 80 ff 	movl   $0xffff,-0x7feb67e0(%eax)
80106b95:	ff 00 00 
80106b98:	c7 80 24 98 14 80 00 	movl   $0xcf9200,-0x7feb67dc(%eax)
80106b9f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ba2:	c7 80 28 98 14 80 ff 	movl   $0xffff,-0x7feb67d8(%eax)
80106ba9:	ff 00 00 
80106bac:	c7 80 2c 98 14 80 00 	movl   $0xcffa00,-0x7feb67d4(%eax)
80106bb3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106bb6:	c7 80 30 98 14 80 ff 	movl   $0xffff,-0x7feb67d0(%eax)
80106bbd:	ff 00 00 
80106bc0:	c7 80 34 98 14 80 00 	movl   $0xcff200,-0x7feb67cc(%eax)
80106bc7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106bca:	05 10 98 14 80       	add    $0x80149810,%eax
  pd[1] = (uint)p;
80106bcf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106bd3:	c1 e8 10             	shr    $0x10,%eax
80106bd6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106bda:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106bdd:	0f 01 10             	lgdtl  (%eax)
}
80106be0:	c9                   	leave  
80106be1:	c3                   	ret    
80106be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106bf0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bf0:	a1 c4 c4 14 80       	mov    0x8014c4c4,%eax
80106bf5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106bfa:	0f 22 d8             	mov    %eax,%cr3
}
80106bfd:	c3                   	ret    
80106bfe:	66 90                	xchg   %ax,%ax

80106c00 <switchuvm>:
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	53                   	push   %ebx
80106c06:	83 ec 1c             	sub    $0x1c,%esp
80106c09:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106c0c:	85 f6                	test   %esi,%esi
80106c0e:	0f 84 cb 00 00 00    	je     80106cdf <switchuvm+0xdf>
  if(p->kstack == 0)
80106c14:	8b 46 08             	mov    0x8(%esi),%eax
80106c17:	85 c0                	test   %eax,%eax
80106c19:	0f 84 da 00 00 00    	je     80106cf9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106c1f:	8b 46 04             	mov    0x4(%esi),%eax
80106c22:	85 c0                	test   %eax,%eax
80106c24:	0f 84 c2 00 00 00    	je     80106cec <switchuvm+0xec>
  pushcli();
80106c2a:	e8 21 da ff ff       	call   80104650 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c2f:	e8 bc ce ff ff       	call   80103af0 <mycpu>
80106c34:	89 c3                	mov    %eax,%ebx
80106c36:	e8 b5 ce ff ff       	call   80103af0 <mycpu>
80106c3b:	89 c7                	mov    %eax,%edi
80106c3d:	e8 ae ce ff ff       	call   80103af0 <mycpu>
80106c42:	83 c7 08             	add    $0x8,%edi
80106c45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c48:	e8 a3 ce ff ff       	call   80103af0 <mycpu>
80106c4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c50:	ba 67 00 00 00       	mov    $0x67,%edx
80106c55:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106c5c:	83 c0 08             	add    $0x8,%eax
80106c5f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c66:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c6b:	83 c1 08             	add    $0x8,%ecx
80106c6e:	c1 e8 18             	shr    $0x18,%eax
80106c71:	c1 e9 10             	shr    $0x10,%ecx
80106c74:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106c7a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106c80:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106c85:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c8c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106c91:	e8 5a ce ff ff       	call   80103af0 <mycpu>
80106c96:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c9d:	e8 4e ce ff ff       	call   80103af0 <mycpu>
80106ca2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ca6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106ca9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106caf:	e8 3c ce ff ff       	call   80103af0 <mycpu>
80106cb4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106cb7:	e8 34 ce ff ff       	call   80103af0 <mycpu>
80106cbc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106cc0:	b8 28 00 00 00       	mov    $0x28,%eax
80106cc5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106cc8:	8b 46 04             	mov    0x4(%esi),%eax
80106ccb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cd0:	0f 22 d8             	mov    %eax,%cr3
}
80106cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cd6:	5b                   	pop    %ebx
80106cd7:	5e                   	pop    %esi
80106cd8:	5f                   	pop    %edi
80106cd9:	5d                   	pop    %ebp
  popcli();
80106cda:	e9 c1 d9 ff ff       	jmp    801046a0 <popcli>
    panic("switchuvm: no process");
80106cdf:	83 ec 0c             	sub    $0xc,%esp
80106ce2:	68 96 7d 10 80       	push   $0x80107d96
80106ce7:	e8 94 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106cec:	83 ec 0c             	sub    $0xc,%esp
80106cef:	68 c1 7d 10 80       	push   $0x80107dc1
80106cf4:	e8 87 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106cf9:	83 ec 0c             	sub    $0xc,%esp
80106cfc:	68 ac 7d 10 80       	push   $0x80107dac
80106d01:	e8 7a 96 ff ff       	call   80100380 <panic>
80106d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d0d:	8d 76 00             	lea    0x0(%esi),%esi

80106d10 <inituvm>:
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
80106d16:	83 ec 1c             	sub    $0x1c,%esp
80106d19:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d1c:	8b 75 10             	mov    0x10(%ebp),%esi
80106d1f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d25:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d2b:	77 4b                	ja     80106d78 <inituvm+0x68>
  mem = kalloc();
80106d2d:	e8 ce b9 ff ff       	call   80102700 <kalloc>
  memset(mem, 0, PGSIZE);
80106d32:	83 ec 04             	sub    $0x4,%esp
80106d35:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106d3a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d3c:	6a 00                	push   $0x0
80106d3e:	50                   	push   %eax
80106d3f:	e8 1c db ff ff       	call   80104860 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d44:	58                   	pop    %eax
80106d45:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d4b:	5a                   	pop    %edx
80106d4c:	6a 06                	push   $0x6
80106d4e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d53:	31 d2                	xor    %edx,%edx
80106d55:	50                   	push   %eax
80106d56:	89 f8                	mov    %edi,%eax
80106d58:	e8 13 fd ff ff       	call   80106a70 <mappages>
  memmove(mem, init, sz);
80106d5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d60:	89 75 10             	mov    %esi,0x10(%ebp)
80106d63:	83 c4 10             	add    $0x10,%esp
80106d66:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106d69:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d6f:	5b                   	pop    %ebx
80106d70:	5e                   	pop    %esi
80106d71:	5f                   	pop    %edi
80106d72:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106d73:	e9 88 db ff ff       	jmp    80104900 <memmove>
    panic("inituvm: more than a page");
80106d78:	83 ec 0c             	sub    $0xc,%esp
80106d7b:	68 d5 7d 10 80       	push   $0x80107dd5
80106d80:	e8 fb 95 ff ff       	call   80100380 <panic>
80106d85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d90 <loaduvm>:
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	57                   	push   %edi
80106d94:	56                   	push   %esi
80106d95:	53                   	push   %ebx
80106d96:	83 ec 1c             	sub    $0x1c,%esp
80106d99:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d9c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106d9f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106da4:	0f 85 bb 00 00 00    	jne    80106e65 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106daa:	01 f0                	add    %esi,%eax
80106dac:	89 f3                	mov    %esi,%ebx
80106dae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106db1:	8b 45 14             	mov    0x14(%ebp),%eax
80106db4:	01 f0                	add    %esi,%eax
80106db6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106db9:	85 f6                	test   %esi,%esi
80106dbb:	0f 84 87 00 00 00    	je     80106e48 <loaduvm+0xb8>
80106dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106dcb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106dce:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106dd0:	89 c2                	mov    %eax,%edx
80106dd2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106dd5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106dd8:	f6 c2 01             	test   $0x1,%dl
80106ddb:	75 13                	jne    80106df0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106ddd:	83 ec 0c             	sub    $0xc,%esp
80106de0:	68 ef 7d 10 80       	push   $0x80107def
80106de5:	e8 96 95 ff ff       	call   80100380 <panic>
80106dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106df0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106df3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106df9:	25 fc 0f 00 00       	and    $0xffc,%eax
80106dfe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e05:	85 c0                	test   %eax,%eax
80106e07:	74 d4                	je     80106ddd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106e09:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e0b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106e0e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106e13:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106e18:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106e1e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e21:	29 d9                	sub    %ebx,%ecx
80106e23:	05 00 00 00 80       	add    $0x80000000,%eax
80106e28:	57                   	push   %edi
80106e29:	51                   	push   %ecx
80106e2a:	50                   	push   %eax
80106e2b:	ff 75 10             	push   0x10(%ebp)
80106e2e:	e8 5d ac ff ff       	call   80101a90 <readi>
80106e33:	83 c4 10             	add    $0x10,%esp
80106e36:	39 f8                	cmp    %edi,%eax
80106e38:	75 1e                	jne    80106e58 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106e3a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106e40:	89 f0                	mov    %esi,%eax
80106e42:	29 d8                	sub    %ebx,%eax
80106e44:	39 c6                	cmp    %eax,%esi
80106e46:	77 80                	ja     80106dc8 <loaduvm+0x38>
}
80106e48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e4b:	31 c0                	xor    %eax,%eax
}
80106e4d:	5b                   	pop    %ebx
80106e4e:	5e                   	pop    %esi
80106e4f:	5f                   	pop    %edi
80106e50:	5d                   	pop    %ebp
80106e51:	c3                   	ret    
80106e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e58:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e60:	5b                   	pop    %ebx
80106e61:	5e                   	pop    %esi
80106e62:	5f                   	pop    %edi
80106e63:	5d                   	pop    %ebp
80106e64:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106e65:	83 ec 0c             	sub    $0xc,%esp
80106e68:	68 0c 7f 10 80       	push   $0x80107f0c
80106e6d:	e8 0e 95 ff ff       	call   80100380 <panic>
80106e72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e80 <allocuvm>:
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	57                   	push   %edi
80106e84:	56                   	push   %esi
80106e85:	53                   	push   %ebx
80106e86:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106e89:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106e8c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106e8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e92:	85 c0                	test   %eax,%eax
80106e94:	0f 88 b6 00 00 00    	js     80106f50 <allocuvm+0xd0>
  if(newsz < oldsz)
80106e9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106ea0:	0f 82 9a 00 00 00    	jb     80106f40 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106ea6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106eac:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106eb2:	39 75 10             	cmp    %esi,0x10(%ebp)
80106eb5:	77 44                	ja     80106efb <allocuvm+0x7b>
80106eb7:	e9 87 00 00 00       	jmp    80106f43 <allocuvm+0xc3>
80106ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106ec0:	83 ec 04             	sub    $0x4,%esp
80106ec3:	68 00 10 00 00       	push   $0x1000
80106ec8:	6a 00                	push   $0x0
80106eca:	50                   	push   %eax
80106ecb:	e8 90 d9 ff ff       	call   80104860 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ed0:	58                   	pop    %eax
80106ed1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ed7:	5a                   	pop    %edx
80106ed8:	6a 06                	push   $0x6
80106eda:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106edf:	89 f2                	mov    %esi,%edx
80106ee1:	50                   	push   %eax
80106ee2:	89 f8                	mov    %edi,%eax
80106ee4:	e8 87 fb ff ff       	call   80106a70 <mappages>
80106ee9:	83 c4 10             	add    $0x10,%esp
80106eec:	85 c0                	test   %eax,%eax
80106eee:	78 78                	js     80106f68 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106ef0:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ef6:	39 75 10             	cmp    %esi,0x10(%ebp)
80106ef9:	76 48                	jbe    80106f43 <allocuvm+0xc3>
    mem = kalloc();
80106efb:	e8 00 b8 ff ff       	call   80102700 <kalloc>
80106f00:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106f02:	85 c0                	test   %eax,%eax
80106f04:	75 ba                	jne    80106ec0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106f06:	83 ec 0c             	sub    $0xc,%esp
80106f09:	68 0d 7e 10 80       	push   $0x80107e0d
80106f0e:	e8 8d 97 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106f13:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f16:	83 c4 10             	add    $0x10,%esp
80106f19:	39 45 10             	cmp    %eax,0x10(%ebp)
80106f1c:	74 32                	je     80106f50 <allocuvm+0xd0>
80106f1e:	8b 55 10             	mov    0x10(%ebp),%edx
80106f21:	89 c1                	mov    %eax,%ecx
80106f23:	89 f8                	mov    %edi,%eax
80106f25:	e8 96 fa ff ff       	call   801069c0 <deallocuvm.part.0>
      return 0;
80106f2a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106f31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f37:	5b                   	pop    %ebx
80106f38:	5e                   	pop    %esi
80106f39:	5f                   	pop    %edi
80106f3a:	5d                   	pop    %ebp
80106f3b:	c3                   	ret    
80106f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106f40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106f43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f49:	5b                   	pop    %ebx
80106f4a:	5e                   	pop    %esi
80106f4b:	5f                   	pop    %edi
80106f4c:	5d                   	pop    %ebp
80106f4d:	c3                   	ret    
80106f4e:	66 90                	xchg   %ax,%ax
    return 0;
80106f50:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106f57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f5d:	5b                   	pop    %ebx
80106f5e:	5e                   	pop    %esi
80106f5f:	5f                   	pop    %edi
80106f60:	5d                   	pop    %ebp
80106f61:	c3                   	ret    
80106f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106f68:	83 ec 0c             	sub    $0xc,%esp
80106f6b:	68 25 7e 10 80       	push   $0x80107e25
80106f70:	e8 2b 97 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106f75:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f78:	83 c4 10             	add    $0x10,%esp
80106f7b:	39 45 10             	cmp    %eax,0x10(%ebp)
80106f7e:	74 0c                	je     80106f8c <allocuvm+0x10c>
80106f80:	8b 55 10             	mov    0x10(%ebp),%edx
80106f83:	89 c1                	mov    %eax,%ecx
80106f85:	89 f8                	mov    %edi,%eax
80106f87:	e8 34 fa ff ff       	call   801069c0 <deallocuvm.part.0>
      kfree(mem);
80106f8c:	83 ec 0c             	sub    $0xc,%esp
80106f8f:	53                   	push   %ebx
80106f90:	e8 2b b5 ff ff       	call   801024c0 <kfree>
      return 0;
80106f95:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106f9c:	83 c4 10             	add    $0x10,%esp
}
80106f9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fa2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fa5:	5b                   	pop    %ebx
80106fa6:	5e                   	pop    %esi
80106fa7:	5f                   	pop    %edi
80106fa8:	5d                   	pop    %ebp
80106fa9:	c3                   	ret    
80106faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fb0 <deallocuvm>:
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fb6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106fbc:	39 d1                	cmp    %edx,%ecx
80106fbe:	73 10                	jae    80106fd0 <deallocuvm+0x20>
}
80106fc0:	5d                   	pop    %ebp
80106fc1:	e9 fa f9 ff ff       	jmp    801069c0 <deallocuvm.part.0>
80106fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fcd:	8d 76 00             	lea    0x0(%esi),%esi
80106fd0:	89 d0                	mov    %edx,%eax
80106fd2:	5d                   	pop    %ebp
80106fd3:	c3                   	ret    
80106fd4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fdf:	90                   	nop

80106fe0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	57                   	push   %edi
80106fe4:	56                   	push   %esi
80106fe5:	53                   	push   %ebx
80106fe6:	83 ec 0c             	sub    $0xc,%esp
80106fe9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106fec:	85 f6                	test   %esi,%esi
80106fee:	74 59                	je     80107049 <freevm+0x69>
  if(newsz >= oldsz)
80106ff0:	31 c9                	xor    %ecx,%ecx
80106ff2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ff7:	89 f0                	mov    %esi,%eax
80106ff9:	89 f3                	mov    %esi,%ebx
80106ffb:	e8 c0 f9 ff ff       	call   801069c0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107000:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107006:	eb 0f                	jmp    80107017 <freevm+0x37>
80107008:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010700f:	90                   	nop
80107010:	83 c3 04             	add    $0x4,%ebx
80107013:	39 df                	cmp    %ebx,%edi
80107015:	74 23                	je     8010703a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107017:	8b 03                	mov    (%ebx),%eax
80107019:	a8 01                	test   $0x1,%al
8010701b:	74 f3                	je     80107010 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010701d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107022:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107025:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107028:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010702d:	50                   	push   %eax
8010702e:	e8 8d b4 ff ff       	call   801024c0 <kfree>
80107033:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107036:	39 df                	cmp    %ebx,%edi
80107038:	75 dd                	jne    80107017 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010703a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010703d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107040:	5b                   	pop    %ebx
80107041:	5e                   	pop    %esi
80107042:	5f                   	pop    %edi
80107043:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107044:	e9 77 b4 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107049:	83 ec 0c             	sub    $0xc,%esp
8010704c:	68 41 7e 10 80       	push   $0x80107e41
80107051:	e8 2a 93 ff ff       	call   80100380 <panic>
80107056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010705d:	8d 76 00             	lea    0x0(%esi),%esi

80107060 <setupkvm>:
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	56                   	push   %esi
80107064:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107065:	e8 96 b6 ff ff       	call   80102700 <kalloc>
8010706a:	89 c6                	mov    %eax,%esi
8010706c:	85 c0                	test   %eax,%eax
8010706e:	74 42                	je     801070b2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107070:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107073:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107078:	68 00 10 00 00       	push   $0x1000
8010707d:	6a 00                	push   $0x0
8010707f:	50                   	push   %eax
80107080:	e8 db d7 ff ff       	call   80104860 <memset>
80107085:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107088:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010708b:	83 ec 08             	sub    $0x8,%esp
8010708e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107091:	ff 73 0c             	push   0xc(%ebx)
80107094:	8b 13                	mov    (%ebx),%edx
80107096:	50                   	push   %eax
80107097:	29 c1                	sub    %eax,%ecx
80107099:	89 f0                	mov    %esi,%eax
8010709b:	e8 d0 f9 ff ff       	call   80106a70 <mappages>
801070a0:	83 c4 10             	add    $0x10,%esp
801070a3:	85 c0                	test   %eax,%eax
801070a5:	78 19                	js     801070c0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070a7:	83 c3 10             	add    $0x10,%ebx
801070aa:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801070b0:	75 d6                	jne    80107088 <setupkvm+0x28>
}
801070b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801070b5:	89 f0                	mov    %esi,%eax
801070b7:	5b                   	pop    %ebx
801070b8:	5e                   	pop    %esi
801070b9:	5d                   	pop    %ebp
801070ba:	c3                   	ret    
801070bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070bf:	90                   	nop
      freevm(pgdir);
801070c0:	83 ec 0c             	sub    $0xc,%esp
801070c3:	56                   	push   %esi
      return 0;
801070c4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801070c6:	e8 15 ff ff ff       	call   80106fe0 <freevm>
      return 0;
801070cb:	83 c4 10             	add    $0x10,%esp
}
801070ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801070d1:	89 f0                	mov    %esi,%eax
801070d3:	5b                   	pop    %ebx
801070d4:	5e                   	pop    %esi
801070d5:	5d                   	pop    %ebp
801070d6:	c3                   	ret    
801070d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070de:	66 90                	xchg   %ax,%ax

801070e0 <kvmalloc>:
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801070e6:	e8 75 ff ff ff       	call   80107060 <setupkvm>
801070eb:	a3 c4 c4 14 80       	mov    %eax,0x8014c4c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070f0:	05 00 00 00 80       	add    $0x80000000,%eax
801070f5:	0f 22 d8             	mov    %eax,%cr3
}
801070f8:	c9                   	leave  
801070f9:	c3                   	ret    
801070fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107100 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	83 ec 08             	sub    $0x8,%esp
80107106:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107109:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010710c:	89 c1                	mov    %eax,%ecx
8010710e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107111:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107114:	f6 c2 01             	test   $0x1,%dl
80107117:	75 17                	jne    80107130 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107119:	83 ec 0c             	sub    $0xc,%esp
8010711c:	68 52 7e 10 80       	push   $0x80107e52
80107121:	e8 5a 92 ff ff       	call   80100380 <panic>
80107126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010712d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107130:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107133:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107139:	25 fc 0f 00 00       	and    $0xffc,%eax
8010713e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107145:	85 c0                	test   %eax,%eax
80107147:	74 d0                	je     80107119 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107149:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010714c:	c9                   	leave  
8010714d:	c3                   	ret    
8010714e:	66 90                	xchg   %ax,%ax

80107150 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	57                   	push   %edi
80107154:	56                   	push   %esi
80107155:	53                   	push   %ebx
80107156:	83 ec 0c             	sub    $0xc,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  //char *mem;

  if((d = setupkvm()) == 0)
80107159:	e8 02 ff ff ff       	call   80107060 <setupkvm>
8010715e:	89 c6                	mov    %eax,%esi
80107160:	85 c0                	test   %eax,%eax
80107162:	0f 84 aa 00 00 00    	je     80107212 <copyuvm+0xc2>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107168:	8b 45 0c             	mov    0xc(%ebp),%eax
8010716b:	85 c0                	test   %eax,%eax
8010716d:	0f 84 93 00 00 00    	je     80107206 <copyuvm+0xb6>
80107173:	31 ff                	xor    %edi,%edi
80107175:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107178:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010717b:	89 f8                	mov    %edi,%eax
8010717d:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107180:	8b 04 82             	mov    (%edx,%eax,4),%eax
80107183:	a8 01                	test   $0x1,%al
80107185:	75 11                	jne    80107198 <copyuvm+0x48>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107187:	83 ec 0c             	sub    $0xc,%esp
8010718a:	68 5c 7e 10 80       	push   $0x80107e5c
8010718f:	e8 ec 91 ff ff       	call   80100380 <panic>
80107194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107198:	89 f9                	mov    %edi,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010719a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
8010719f:	c1 e9 0a             	shr    $0xa,%ecx
801071a2:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801071a8:	8d 8c 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%ecx
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801071af:	85 c9                	test   %ecx,%ecx
801071b1:	74 d4                	je     80107187 <copyuvm+0x37>
    if(!(*pte & PTE_P))
801071b3:	8b 01                	mov    (%ecx),%eax
801071b5:	a8 01                	test   $0x1,%al
801071b7:	0f 84 93 00 00 00    	je     80107250 <copyuvm+0x100>
      panic("copyuvm: page not present");
	*pte &= ~PTE_W;
801071bd:	89 c3                	mov    %eax,%ebx
	/*
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
	*/
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) {
801071bf:	83 ec 08             	sub    $0x8,%esp
801071c2:	89 fa                	mov    %edi,%edx
	*pte &= ~PTE_W;
801071c4:	83 e3 fd             	and    $0xfffffffd,%ebx
801071c7:	89 19                	mov    %ebx,(%ecx)
    pa = PTE_ADDR(*pte);
801071c9:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801071cb:	25 fd 0f 00 00       	and    $0xffd,%eax
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) {
801071d0:	b9 00 10 00 00       	mov    $0x1000,%ecx
    pa = PTE_ADDR(*pte);
801071d5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) {
801071db:	50                   	push   %eax
801071dc:	89 f0                	mov    %esi,%eax
801071de:	53                   	push   %ebx
801071df:	e8 8c f8 ff ff       	call   80106a70 <mappages>
801071e4:	83 c4 10             	add    $0x10,%esp
801071e7:	85 c0                	test   %eax,%eax
801071e9:	78 35                	js     80107220 <copyuvm+0xd0>
      //kfree(mem);
	  cprintf("copyuvm(): mappages fail\n");
      goto bad;
    }
	incr_refc(pa);
801071eb:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < sz; i += PGSIZE){
801071ee:	81 c7 00 10 00 00    	add    $0x1000,%edi
	incr_refc(pa);
801071f4:	53                   	push   %ebx
801071f5:	e8 a6 b5 ff ff       	call   801027a0 <incr_refc>
  for(i = 0; i < sz; i += PGSIZE){
801071fa:	83 c4 10             	add    $0x10,%esp
801071fd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107200:	0f 87 72 ff ff ff    	ja     80107178 <copyuvm+0x28>
  }
  lcr3(V2P(pgdir));
80107206:	8b 45 08             	mov    0x8(%ebp),%eax
80107209:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
8010720f:	0f 22 df             	mov    %edi,%cr3

bad:
  freevm(d);
  lcr3(V2P(pgdir));
  return 0;
}
80107212:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107215:	89 f0                	mov    %esi,%eax
80107217:	5b                   	pop    %ebx
80107218:	5e                   	pop    %esi
80107219:	5f                   	pop    %edi
8010721a:	5d                   	pop    %ebp
8010721b:	c3                   	ret    
8010721c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	  cprintf("copyuvm(): mappages fail\n");
80107220:	83 ec 0c             	sub    $0xc,%esp
80107223:	68 90 7e 10 80       	push   $0x80107e90
80107228:	e8 73 94 ff ff       	call   801006a0 <cprintf>
  freevm(d);
8010722d:	89 34 24             	mov    %esi,(%esp)
80107230:	e8 ab fd ff ff       	call   80106fe0 <freevm>
  lcr3(V2P(pgdir));
80107235:	8b 45 08             	mov    0x8(%ebp),%eax
80107238:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
8010723e:	0f 22 df             	mov    %edi,%cr3
  return 0;
80107241:	31 f6                	xor    %esi,%esi
80107243:	83 c4 10             	add    $0x10,%esp
}
80107246:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107249:	5b                   	pop    %ebx
8010724a:	89 f0                	mov    %esi,%eax
8010724c:	5e                   	pop    %esi
8010724d:	5f                   	pop    %edi
8010724e:	5d                   	pop    %ebp
8010724f:	c3                   	ret    
      panic("copyuvm: page not present");
80107250:	83 ec 0c             	sub    $0xc,%esp
80107253:	68 76 7e 10 80       	push   $0x80107e76
80107258:	e8 23 91 ff ff       	call   80100380 <panic>
8010725d:	8d 76 00             	lea    0x0(%esi),%esi

80107260 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107266:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107269:	89 c1                	mov    %eax,%ecx
8010726b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010726e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107271:	f6 c2 01             	test   $0x1,%dl
80107274:	0f 84 14 02 00 00    	je     8010748e <uva2ka.cold>
  return &pgtab[PTX(va)];
8010727a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010727d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107283:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107284:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107289:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107290:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107292:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107297:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010729a:	05 00 00 00 80       	add    $0x80000000,%eax
8010729f:	83 fa 05             	cmp    $0x5,%edx
801072a2:	ba 00 00 00 00       	mov    $0x0,%edx
801072a7:	0f 45 c2             	cmovne %edx,%eax
}
801072aa:	c3                   	ret    
801072ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072af:	90                   	nop

801072b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	57                   	push   %edi
801072b4:	56                   	push   %esi
801072b5:	53                   	push   %ebx
801072b6:	83 ec 0c             	sub    $0xc,%esp
801072b9:	8b 75 14             	mov    0x14(%ebp),%esi
801072bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801072bf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801072c2:	85 f6                	test   %esi,%esi
801072c4:	75 51                	jne    80107317 <copyout+0x67>
801072c6:	e9 a5 00 00 00       	jmp    80107370 <copyout+0xc0>
801072cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072cf:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801072d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801072d6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801072dc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801072e2:	74 75                	je     80107359 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801072e4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801072e6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801072e9:	29 c3                	sub    %eax,%ebx
801072eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072f1:	39 f3                	cmp    %esi,%ebx
801072f3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801072f6:	29 f8                	sub    %edi,%eax
801072f8:	83 ec 04             	sub    $0x4,%esp
801072fb:	01 c1                	add    %eax,%ecx
801072fd:	53                   	push   %ebx
801072fe:	52                   	push   %edx
801072ff:	51                   	push   %ecx
80107300:	e8 fb d5 ff ff       	call   80104900 <memmove>
    len -= n;
    buf += n;
80107305:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107308:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010730e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107311:	01 da                	add    %ebx,%edx
  while(len > 0){
80107313:	29 de                	sub    %ebx,%esi
80107315:	74 59                	je     80107370 <copyout+0xc0>
  if(*pde & PTE_P){
80107317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010731a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010731c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010731e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107321:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107327:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010732a:	f6 c1 01             	test   $0x1,%cl
8010732d:	0f 84 62 01 00 00    	je     80107495 <copyout.cold>
  return &pgtab[PTX(va)];
80107333:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107335:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010733b:	c1 eb 0c             	shr    $0xc,%ebx
8010733e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107344:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010734b:	89 d9                	mov    %ebx,%ecx
8010734d:	83 e1 05             	and    $0x5,%ecx
80107350:	83 f9 05             	cmp    $0x5,%ecx
80107353:	0f 84 77 ff ff ff    	je     801072d0 <copyout+0x20>
  }
  return 0;
}
80107359:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010735c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107361:	5b                   	pop    %ebx
80107362:	5e                   	pop    %esi
80107363:	5f                   	pop    %edi
80107364:	5d                   	pop    %ebp
80107365:	c3                   	ret    
80107366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010736d:	8d 76 00             	lea    0x0(%esi),%esi
80107370:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107373:	31 c0                	xor    %eax,%eax
}
80107375:	5b                   	pop    %ebx
80107376:	5e                   	pop    %esi
80107377:	5f                   	pop    %edi
80107378:	5d                   	pop    %ebp
80107379:	c3                   	ret    
8010737a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107380 <CoW_handler>:

void
CoW_handler()
{
80107380:	55                   	push   %ebp
80107381:	89 e5                	mov    %esp,%ebp
80107383:	57                   	push   %edi
80107384:	56                   	push   %esi
80107385:	53                   	push   %ebx
80107386:	83 ec 1c             	sub    $0x1c,%esp
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107389:	0f 20 d6             	mov    %cr2,%esi
  uint fva = rcr2();
  pte_t *pte;
  uint pa;
  char *mem;
  struct proc *p = myproc();
8010738c:	e8 df c7 ff ff       	call   80103b70 <myproc>
  
  if(p == 0)
80107391:	85 c0                	test   %eax,%eax
80107393:	0f 84 ca 00 00 00    	je     80107463 <CoW_handler+0xe3>
80107399:	89 c3                	mov    %eax,%ebx
  pde = &pgdir[PDX(va)];
8010739b:	89 f2                	mov    %esi,%edx
  if(*pde & PTE_P){
8010739d:	8b 40 04             	mov    0x4(%eax),%eax
  pde = &pgdir[PDX(va)];
801073a0:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801073a3:	8b 04 90             	mov    (%eax,%edx,4),%eax
801073a6:	a8 01                	test   $0x1,%al
801073a8:	0f 84 a8 00 00 00    	je     80107456 <CoW_handler+0xd6>
  return &pgtab[PTX(va)];
801073ae:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801073b5:	c1 ea 0a             	shr    $0xa,%edx
801073b8:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801073be:	8d bc 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edi
	panic("CoW_handler: No proc");

  if((pte = walkpgdir(p->pgdir, (void*)fva, 0)) == 0)
801073c5:	85 ff                	test   %edi,%edi
801073c7:	0f 84 89 00 00 00    	je     80107456 <CoW_handler+0xd6>
	panic("CoW_handler: pte should exist");
  if(!(*pte & PTE_P)){
801073cd:	f6 07 01             	testb  $0x1,(%edi)
801073d0:	0f 84 9a 00 00 00    	je     80107470 <CoW_handler+0xf0>
	cprintf("Cur proc: %s %d\n", p->name, p->pid);
	panic("CoW_handler: page not present");
  }

  int refc = get_refc(V2P(fva));
801073d6:	83 ec 0c             	sub    $0xc,%esp
801073d9:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801073df:	56                   	push   %esi
801073e0:	e8 9b b4 ff ff       	call   80102880 <get_refc>
  if(refc == 1){ // cause: parent try to write on read-only page
801073e5:	83 c4 10             	add    $0x10,%esp
801073e8:	83 f8 01             	cmp    $0x1,%eax
801073eb:	74 1b                	je     80107408 <CoW_handler+0x88>
	*pte |= PTE_W;
  }
  else if(refc > 1){ // cause: child needs copy page
801073ed:	7f 21                	jg     80107410 <CoW_handler+0x90>
	*pte = V2P(mem) | PTE_P | PTE_U | PTE_W;
	
	// now out from origin page, decr ref count of page
	decr_refc(pa);
  }
  lcr3(V2P(p->pgdir));
801073ef:	8b 43 04             	mov    0x4(%ebx),%eax
801073f2:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073f7:	0f 22 d8             	mov    %eax,%cr3
}
801073fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073fd:	5b                   	pop    %ebx
801073fe:	5e                   	pop    %esi
801073ff:	5f                   	pop    %edi
80107400:	5d                   	pop    %ebp
80107401:	c3                   	ret    
80107402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	*pte |= PTE_W;
80107408:	83 0f 02             	orl    $0x2,(%edi)
8010740b:	eb e2                	jmp    801073ef <CoW_handler+0x6f>
8010740d:	8d 76 00             	lea    0x0(%esi),%esi
	pa = PTE_ADDR(*pte);
80107410:	8b 37                	mov    (%edi),%esi
	if((mem = kalloc()) == 0)
80107412:	e8 e9 b2 ff ff       	call   80102700 <kalloc>
80107417:	89 c2                	mov    %eax,%edx
80107419:	85 c0                	test   %eax,%eax
8010741b:	74 dd                	je     801073fa <CoW_handler+0x7a>
	pa = PTE_ADDR(*pte);
8010741d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	memmove(mem, (char*)P2V(pa), PGSIZE);
80107423:	83 ec 04             	sub    $0x4,%esp
80107426:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107429:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010742f:	68 00 10 00 00       	push   $0x1000
80107434:	50                   	push   %eax
80107435:	52                   	push   %edx
80107436:	e8 c5 d4 ff ff       	call   80104900 <memmove>
	*pte = V2P(mem) | PTE_P | PTE_U | PTE_W;
8010743b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010743e:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107444:	83 ca 07             	or     $0x7,%edx
80107447:	89 17                	mov    %edx,(%edi)
	decr_refc(pa);
80107449:	89 34 24             	mov    %esi,(%esp)
8010744c:	e8 bf b3 ff ff       	call   80102810 <decr_refc>
80107451:	83 c4 10             	add    $0x10,%esp
80107454:	eb 99                	jmp    801073ef <CoW_handler+0x6f>
	panic("CoW_handler: pte should exist");
80107456:	83 ec 0c             	sub    $0xc,%esp
80107459:	68 bf 7e 10 80       	push   $0x80107ebf
8010745e:	e8 1d 8f ff ff       	call   80100380 <panic>
	panic("CoW_handler: No proc");
80107463:	83 ec 0c             	sub    $0xc,%esp
80107466:	68 aa 7e 10 80       	push   $0x80107eaa
8010746b:	e8 10 8f ff ff       	call   80100380 <panic>
	cprintf("Cur proc: %s %d\n", p->name, p->pid);
80107470:	83 c3 6c             	add    $0x6c,%ebx
80107473:	50                   	push   %eax
80107474:	ff 73 a4             	push   -0x5c(%ebx)
80107477:	53                   	push   %ebx
80107478:	68 dd 7e 10 80       	push   $0x80107edd
8010747d:	e8 1e 92 ff ff       	call   801006a0 <cprintf>
	panic("CoW_handler: page not present");
80107482:	c7 04 24 ee 7e 10 80 	movl   $0x80107eee,(%esp)
80107489:	e8 f2 8e ff ff       	call   80100380 <panic>

8010748e <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010748e:	a1 00 00 00 00       	mov    0x0,%eax
80107493:	0f 0b                	ud2    

80107495 <copyout.cold>:
80107495:	a1 00 00 00 00       	mov    0x0,%eax
8010749a:	0f 0b                	ud2    
