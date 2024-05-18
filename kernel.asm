
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc d0 61 13 80       	mov    $0x801361d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 30 10 80       	mov    $0x801030c0,%eax
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
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 7a 10 80       	push   $0x80107ac0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 85 4b 00 00       	call   80104be0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
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
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 7a 10 80       	push   $0x80107ac7
80100097:	50                   	push   %eax
80100098:	e8 13 4a 00 00       	call   80104ab0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
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
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 c7 4c 00 00       	call   80104db0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
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
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
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
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 e9 4b 00 00       	call   80104d50 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 49 00 00       	call   80104af0 <acquiresleep>
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
8010018c:	e8 af 21 00 00       	call   80102340 <iderw>
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
801001a1:	68 ce 7a 10 80       	push   $0x80107ace
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
801001be:	e8 cd 49 00 00       	call   80104b90 <holdingsleep>
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
801001d4:	e9 67 21 00 00       	jmp    80102340 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 df 7a 10 80       	push   $0x80107adf
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
801001ff:	e8 8c 49 00 00       	call   80104b90 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 3c 49 00 00       	call   80104b50 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 90 4b 00 00       	call   80104db0 <acquire>
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
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 df 4a 00 00       	jmp    80104d50 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 e6 7a 10 80       	push   $0x80107ae6
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
80100294:	e8 27 16 00 00       	call   801018c0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 0b 4b 00 00       	call   80104db0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
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
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 0e 40 00 00       	call   801042e0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 59 37 00 00       	call   80103a40 <myproc>
801002e7:	8b 48 14             	mov    0x14(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 55 4a 00 00       	call   80104d50 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 dc 14 00 00       	call   801017e0 <ilock>
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
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
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
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 ff 49 00 00       	call   80104d50 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 86 14 00 00       	call   801017e0 <ilock>
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
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
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
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 b2 25 00 00       	call   80102950 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ed 7a 10 80       	push   $0x80107aed
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 ad 84 10 80 	movl   $0x801084ad,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 33 48 00 00       	call   80104c00 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 01 7b 10 80       	push   $0x80107b01
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
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
8010041a:	e8 b1 61 00 00       	call   801065d0 <uartputc>
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
80100505:	e8 c6 60 00 00       	call   801065d0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 ba 60 00 00       	call   801065d0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 ae 60 00 00       	call   801065d0 <uartputc>
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
80100551:	e8 ba 49 00 00       	call   80104f10 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 05 49 00 00       	call   80104e70 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 05 7b 10 80       	push   $0x80107b05
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
8010059f:	e8 1c 13 00 00       	call   801018c0 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 00 48 00 00       	call   80104db0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
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
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 67 47 00 00       	call   80104d50 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 ee 11 00 00       	call   801017e0 <ilock>

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
80100636:	0f b6 92 30 7b 10 80 	movzbl -0x7fef84d0(%edx),%edx
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
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
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
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
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
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
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
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
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
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 c3 45 00 00       	call   80104db0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
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
80100838:	bf 18 7b 10 80       	mov    $0x80107b18,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 f0 44 00 00       	call   80104d50 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 1f 7b 10 80       	push   $0x80107b1f
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
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 18 45 00 00       	call   80104db0 <acquire>
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
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
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
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 7b 43 00 00       	call   80104d50 <release>
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
80100a0e:	e9 cd 3a 00 00       	jmp    801044e0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
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
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 97 39 00 00       	call   801043e0 <wakeup>
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
80100a66:	68 28 7b 10 80       	push   $0x80107b28
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 6b 41 00 00       	call   80104be0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 42 1a 00 00       	call   801024e0 <ioapicenable>
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
80100abc:	e8 7f 2f 00 00       	call   80103a40 <myproc>
80100ac1:	89 c1                	mov    %eax,%ecx
80100ac3:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
  struct thread *t;
  struct thread *curt = &curproc->threads[curproc->curtidx];
80100ac9:	8b 80 6c 08 00 00    	mov    0x86c(%eax),%eax

  // Clear every other thread first and copy current thread tid
  // to assign it to default-thread
  for(t = curproc->threads; t < &curproc->threads[NTHREAD]; t++){
80100acf:	8d 71 6c             	lea    0x6c(%ecx),%esi
80100ad2:	8d 99 6c 08 00 00    	lea    0x86c(%ecx),%ebx
  struct thread *curt = &curproc->threads[curproc->curtidx];
80100ad8:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ade:	c1 e0 05             	shl    $0x5,%eax
80100ae1:	8d 7c 01 6c          	lea    0x6c(%ecx,%eax,1),%edi
  for(t = curproc->threads; t < &curproc->threads[NTHREAD]; t++){
80100ae5:	8d 76 00             	lea    0x0(%esi),%esi
	// clear every thread except current thread
	if(t == curt)
80100ae8:	39 f7                	cmp    %esi,%edi
80100aea:	74 14                	je     80100b00 <exec+0x50>
	  continue;
	if(tclear(t) == 0)
80100aec:	83 ec 0c             	sub    $0xc,%esp
80100aef:	56                   	push   %esi
80100af0:	e8 3b 3f 00 00       	call   80104a30 <tclear>
80100af5:	83 c4 10             	add    $0x10,%esp
80100af8:	85 c0                	test   %eax,%eax
80100afa:	0f 84 58 02 00 00    	je     80100d58 <exec+0x2a8>
  for(t = curproc->threads; t < &curproc->threads[NTHREAD]; t++){
80100b00:	83 c6 20             	add    $0x20,%esi
80100b03:	39 f3                	cmp    %esi,%ebx
80100b05:	75 e1                	jne    80100ae8 <exec+0x38>
	  panic("exec(): tclear error\n");
  }

  begin_op();
80100b07:	e8 b4 22 00 00       	call   80102dc0 <begin_op>

  if((ip = namei(path)) == 0){
80100b0c:	83 ec 0c             	sub    $0xc,%esp
80100b0f:	ff 75 08             	push   0x8(%ebp)
80100b12:	e8 e9 15 00 00       	call   80102100 <namei>
80100b17:	83 c4 10             	add    $0x10,%esp
80100b1a:	89 c3                	mov    %eax,%ebx
80100b1c:	85 c0                	test   %eax,%eax
80100b1e:	0f 84 41 02 00 00    	je     80100d65 <exec+0x2b5>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b24:	83 ec 0c             	sub    $0xc,%esp
80100b27:	50                   	push   %eax
80100b28:	e8 b3 0c 00 00       	call   801017e0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b33:	6a 34                	push   $0x34
80100b35:	6a 00                	push   $0x0
80100b37:	50                   	push   %eax
80100b38:	53                   	push   %ebx
80100b39:	e8 b2 0f 00 00       	call   80101af0 <readi>
80100b3e:	83 c4 20             	add    $0x20,%esp
80100b41:	83 f8 34             	cmp    $0x34,%eax
80100b44:	74 1e                	je     80100b64 <exec+0xb4>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b46:	83 ec 0c             	sub    $0xc,%esp
80100b49:	53                   	push   %ebx
80100b4a:	e8 21 0f 00 00       	call   80101a70 <iunlockput>
    end_op();
80100b4f:	e8 dc 22 00 00       	call   80102e30 <end_op>
80100b54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b5f:	5b                   	pop    %ebx
80100b60:	5e                   	pop    %esi
80100b61:	5f                   	pop    %edi
80100b62:	5d                   	pop    %ebp
80100b63:	c3                   	ret    
  if(elf.magic != ELF_MAGIC)
80100b64:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b6b:	45 4c 46 
80100b6e:	75 d6                	jne    80100b46 <exec+0x96>
  if((pgdir = setupkvm()) == 0)
80100b70:	e8 eb 6b 00 00       	call   80107760 <setupkvm>
80100b75:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b7b:	85 c0                	test   %eax,%eax
80100b7d:	74 c7                	je     80100b46 <exec+0x96>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b7f:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b86:	00 
80100b87:	8b bd 40 ff ff ff    	mov    -0xc0(%ebp),%edi
80100b8d:	0f 84 cc 02 00 00    	je     80100e5f <exec+0x3af>
  sz = 0;
80100b93:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b9a:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b9d:	31 f6                	xor    %esi,%esi
80100b9f:	e9 8a 00 00 00       	jmp    80100c2e <exec+0x17e>
80100ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ba8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100baf:	75 6c                	jne    80100c1d <exec+0x16d>
    if(ph.memsz < ph.filesz)
80100bb1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100bb7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100bbd:	0f 82 87 00 00 00    	jb     80100c4a <exec+0x19a>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100bc3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100bc9:	72 7f                	jb     80100c4a <exec+0x19a>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bcb:	83 ec 04             	sub    $0x4,%esp
80100bce:	50                   	push   %eax
80100bcf:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100bd5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bdb:	e8 a0 69 00 00       	call   80107580 <allocuvm>
80100be0:	83 c4 10             	add    $0x10,%esp
80100be3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100be9:	85 c0                	test   %eax,%eax
80100beb:	74 5d                	je     80100c4a <exec+0x19a>
    if(ph.vaddr % PGSIZE != 0)
80100bed:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bf3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bf8:	75 50                	jne    80100c4a <exec+0x19a>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bfa:	83 ec 0c             	sub    $0xc,%esp
80100bfd:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100c03:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100c09:	53                   	push   %ebx
80100c0a:	50                   	push   %eax
80100c0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c11:	e8 7a 68 00 00       	call   80107490 <loaduvm>
80100c16:	83 c4 20             	add    $0x20,%esp
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	78 2d                	js     80100c4a <exec+0x19a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c1d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c24:	83 c6 01             	add    $0x1,%esi
80100c27:	83 c7 20             	add    $0x20,%edi
80100c2a:	39 f0                	cmp    %esi,%eax
80100c2c:	7e 32                	jle    80100c60 <exec+0x1b0>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c2e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c34:	6a 20                	push   $0x20
80100c36:	57                   	push   %edi
80100c37:	50                   	push   %eax
80100c38:	53                   	push   %ebx
80100c39:	e8 b2 0e 00 00       	call   80101af0 <readi>
80100c3e:	83 c4 10             	add    $0x10,%esp
80100c41:	83 f8 20             	cmp    $0x20,%eax
80100c44:	0f 84 5e ff ff ff    	je     80100ba8 <exec+0xf8>
    freevm(pgdir);
80100c4a:	83 ec 0c             	sub    $0xc,%esp
80100c4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c53:	e8 88 6a 00 00       	call   801076e0 <freevm>
  if(ip){
80100c58:	83 c4 10             	add    $0x10,%esp
80100c5b:	e9 e6 fe ff ff       	jmp    80100b46 <exec+0x96>
  sz = PGROUNDUP(sz);
80100c60:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c66:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c6c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c72:	8d 87 00 20 00 00    	lea    0x2000(%edi),%eax
  iunlockput(ip);
80100c78:	83 ec 0c             	sub    $0xc,%esp
80100c7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c81:	53                   	push   %ebx
80100c82:	e8 e9 0d 00 00       	call   80101a70 <iunlockput>
  end_op();
80100c87:	e8 a4 21 00 00       	call   80102e30 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c8c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c92:	83 c4 0c             	add    $0xc,%esp
80100c95:	50                   	push   %eax
80100c96:	57                   	push   %edi
80100c97:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c9d:	57                   	push   %edi
80100c9e:	e8 dd 68 00 00       	call   80107580 <allocuvm>
80100ca3:	83 c4 10             	add    $0x10,%esp
80100ca6:	89 c6                	mov    %eax,%esi
80100ca8:	85 c0                	test   %eax,%eax
80100caa:	0f 84 8d 00 00 00    	je     80100d3d <exec+0x28d>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cb0:	83 ec 08             	sub    $0x8,%esp
80100cb3:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100cb9:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cbb:	50                   	push   %eax
80100cbc:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100cbd:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cbf:	e8 3c 6b 00 00       	call   80107800 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc7:	83 c4 10             	add    $0x10,%esp
80100cca:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100cd0:	8b 00                	mov    (%eax),%eax
80100cd2:	85 c0                	test   %eax,%eax
80100cd4:	75 2d                	jne    80100d03 <exec+0x253>
80100cd6:	e9 a9 00 00 00       	jmp    80100d84 <exec+0x2d4>
80100cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cdf:	90                   	nop
80100ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100ce3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cea:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100ced:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cf3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cf6:	85 c0                	test   %eax,%eax
80100cf8:	0f 84 86 00 00 00    	je     80100d84 <exec+0x2d4>
    if(argc >= MAXARG)
80100cfe:	83 ff 20             	cmp    $0x20,%edi
80100d01:	74 3a                	je     80100d3d <exec+0x28d>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d03:	83 ec 0c             	sub    $0xc,%esp
80100d06:	50                   	push   %eax
80100d07:	e8 64 43 00 00       	call   80105070 <strlen>
80100d0c:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d0e:	58                   	pop    %eax
80100d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d12:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d15:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d18:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d1b:	e8 50 43 00 00       	call   80105070 <strlen>
80100d20:	83 c0 01             	add    $0x1,%eax
80100d23:	50                   	push   %eax
80100d24:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d27:	ff 34 b8             	push   (%eax,%edi,4)
80100d2a:	53                   	push   %ebx
80100d2b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d31:	e8 9a 6c 00 00       	call   801079d0 <copyout>
80100d36:	83 c4 20             	add    $0x20,%esp
80100d39:	85 c0                	test   %eax,%eax
80100d3b:	79 a3                	jns    80100ce0 <exec+0x230>
    freevm(pgdir);
80100d3d:	83 ec 0c             	sub    $0xc,%esp
80100d40:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d46:	e8 95 69 00 00       	call   801076e0 <freevm>
80100d4b:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d53:	e9 04 fe ff ff       	jmp    80100b5c <exec+0xac>
	  panic("exec(): tclear error\n");
80100d58:	83 ec 0c             	sub    $0xc,%esp
80100d5b:	68 41 7b 10 80       	push   $0x80107b41
80100d60:	e8 1b f6 ff ff       	call   80100380 <panic>
    end_op();
80100d65:	e8 c6 20 00 00       	call   80102e30 <end_op>
    cprintf("exec: fail\n");
80100d6a:	83 ec 0c             	sub    $0xc,%esp
80100d6d:	68 57 7b 10 80       	push   $0x80107b57
80100d72:	e8 29 f9 ff ff       	call   801006a0 <cprintf>
    return -1;
80100d77:	83 c4 10             	add    $0x10,%esp
80100d7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d7f:	e9 d8 fd ff ff       	jmp    80100b5c <exec+0xac>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d84:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d8b:	89 da                	mov    %ebx,%edx
  ustack[3+argc] = 0;
80100d8d:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d94:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d98:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100d9a:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d9d:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100da3:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100da5:	50                   	push   %eax
80100da6:	51                   	push   %ecx
80100da7:	53                   	push   %ebx
80100da8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100dae:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100db5:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100db8:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dbe:	e8 0d 6c 00 00       	call   801079d0 <copyout>
80100dc3:	83 c4 10             	add    $0x10,%esp
80100dc6:	85 c0                	test   %eax,%eax
80100dc8:	0f 88 6f ff ff ff    	js     80100d3d <exec+0x28d>
  for(last=s=path; *s; s++)
80100dce:	8b 45 08             	mov    0x8(%ebp),%eax
80100dd1:	0f b6 00             	movzbl (%eax),%eax
80100dd4:	84 c0                	test   %al,%al
80100dd6:	74 17                	je     80100def <exec+0x33f>
80100dd8:	8b 55 08             	mov    0x8(%ebp),%edx
80100ddb:	89 d1                	mov    %edx,%ecx
      last = s+1;
80100ddd:	83 c1 01             	add    $0x1,%ecx
80100de0:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100de2:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100de5:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100de8:	84 c0                	test   %al,%al
80100dea:	75 f1                	jne    80100ddd <exec+0x32d>
80100dec:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100def:	8b bd e8 fe ff ff    	mov    -0x118(%ebp),%edi
80100df5:	83 ec 04             	sub    $0x4,%esp
80100df8:	6a 10                	push   $0x10
80100dfa:	8d 47 5c             	lea    0x5c(%edi),%eax
80100dfd:	ff 75 08             	push   0x8(%ebp)
80100e00:	50                   	push   %eax
80100e01:	e8 2a 42 00 00       	call   80105030 <safestrcpy>
  curproc->pgdir = pgdir;
80100e06:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100e0c:	8b 57 04             	mov    0x4(%edi),%edx
  curproc->sz = sz;
80100e0f:	89 37                	mov    %esi,(%edi)
  curproc->pgdir = pgdir;
80100e11:	89 47 04             	mov    %eax,0x4(%edi)
  curt->ustackp = sz;
80100e14:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100e1a:	89 95 f0 fe ff ff    	mov    %edx,-0x110(%ebp)
  curproc->pgdir = pgdir;
80100e20:	89 fa                	mov    %edi,%edx
  curt->ustackp = sz;
80100e22:	c1 e0 05             	shl    $0x5,%eax
80100e25:	01 f8                	add    %edi,%eax
  curt->tf->eip = elf.entry;  // main
80100e27:	8b bd 3c ff ff ff    	mov    -0xc4(%ebp),%edi
80100e2d:	8b 48 78             	mov    0x78(%eax),%ecx
  curt->ustackp = sz;
80100e30:	89 b0 80 00 00 00    	mov    %esi,0x80(%eax)
  curt->tf->eip = elf.entry;  // main
80100e36:	89 79 38             	mov    %edi,0x38(%ecx)
  curt->tf->esp = sp;
80100e39:	8b 40 78             	mov    0x78(%eax),%eax
80100e3c:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e3f:	89 14 24             	mov    %edx,(%esp)
80100e42:	e8 b9 64 00 00       	call   80107300 <switchuvm>
  freevm(oldpgdir);
80100e47:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100e4d:	89 14 24             	mov    %edx,(%esp)
80100e50:	e8 8b 68 00 00       	call   801076e0 <freevm>
  return 0;
80100e55:	83 c4 10             	add    $0x10,%esp
80100e58:	31 c0                	xor    %eax,%eax
80100e5a:	e9 fd fc ff ff       	jmp    80100b5c <exec+0xac>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e5f:	b8 00 20 00 00       	mov    $0x2000,%eax
80100e64:	31 ff                	xor    %edi,%edi
80100e66:	e9 0d fe ff ff       	jmp    80100c78 <exec+0x1c8>
80100e6b:	66 90                	xchg   %ax,%ax
80100e6d:	66 90                	xchg   %ax,%ax
80100e6f:	90                   	nop

80100e70 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e76:	68 63 7b 10 80       	push   $0x80107b63
80100e7b:	68 60 ff 10 80       	push   $0x8010ff60
80100e80:	e8 5b 3d 00 00       	call   80104be0 <initlock>
}
80100e85:	83 c4 10             	add    $0x10,%esp
80100e88:	c9                   	leave  
80100e89:	c3                   	ret    
80100e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e90 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e90:	55                   	push   %ebp
80100e91:	89 e5                	mov    %esp,%ebp
80100e93:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e94:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e99:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e9c:	68 60 ff 10 80       	push   $0x8010ff60
80100ea1:	e8 0a 3f 00 00       	call   80104db0 <acquire>
80100ea6:	83 c4 10             	add    $0x10,%esp
80100ea9:	eb 10                	jmp    80100ebb <filealloc+0x2b>
80100eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100eaf:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100eb0:	83 c3 18             	add    $0x18,%ebx
80100eb3:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100eb9:	74 25                	je     80100ee0 <filealloc+0x50>
    if(f->ref == 0){
80100ebb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ebe:	85 c0                	test   %eax,%eax
80100ec0:	75 ee                	jne    80100eb0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ec2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ec5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ecc:	68 60 ff 10 80       	push   $0x8010ff60
80100ed1:	e8 7a 3e 00 00       	call   80104d50 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ed6:	89 d8                	mov    %ebx,%eax
      return f;
80100ed8:	83 c4 10             	add    $0x10,%esp
}
80100edb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ede:	c9                   	leave  
80100edf:	c3                   	ret    
  release(&ftable.lock);
80100ee0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ee3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ee5:	68 60 ff 10 80       	push   $0x8010ff60
80100eea:	e8 61 3e 00 00       	call   80104d50 <release>
}
80100eef:	89 d8                	mov    %ebx,%eax
  return 0;
80100ef1:	83 c4 10             	add    $0x10,%esp
}
80100ef4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef7:	c9                   	leave  
80100ef8:	c3                   	ret    
80100ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 10             	sub    $0x10,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f0a:	68 60 ff 10 80       	push   $0x8010ff60
80100f0f:	e8 9c 3e 00 00       	call   80104db0 <acquire>
  if(f->ref < 1)
80100f14:	8b 43 04             	mov    0x4(%ebx),%eax
80100f17:	83 c4 10             	add    $0x10,%esp
80100f1a:	85 c0                	test   %eax,%eax
80100f1c:	7e 1a                	jle    80100f38 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f1e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f21:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f24:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f27:	68 60 ff 10 80       	push   $0x8010ff60
80100f2c:	e8 1f 3e 00 00       	call   80104d50 <release>
  return f;
}
80100f31:	89 d8                	mov    %ebx,%eax
80100f33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f36:	c9                   	leave  
80100f37:	c3                   	ret    
    panic("filedup");
80100f38:	83 ec 0c             	sub    $0xc,%esp
80100f3b:	68 6a 7b 10 80       	push   $0x80107b6a
80100f40:	e8 3b f4 ff ff       	call   80100380 <panic>
80100f45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f50 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 28             	sub    $0x28,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f5c:	68 60 ff 10 80       	push   $0x8010ff60
80100f61:	e8 4a 3e 00 00       	call   80104db0 <acquire>
  if(f->ref < 1)
80100f66:	8b 53 04             	mov    0x4(%ebx),%edx
80100f69:	83 c4 10             	add    $0x10,%esp
80100f6c:	85 d2                	test   %edx,%edx
80100f6e:	0f 8e a5 00 00 00    	jle    80101019 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f74:	83 ea 01             	sub    $0x1,%edx
80100f77:	89 53 04             	mov    %edx,0x4(%ebx)
80100f7a:	75 44                	jne    80100fc0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f7c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f80:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f83:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f85:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f8b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f8e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f91:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f94:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f99:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f9c:	e8 af 3d 00 00       	call   80104d50 <release>

  if(ff.type == FD_PIPE)
80100fa1:	83 c4 10             	add    $0x10,%esp
80100fa4:	83 ff 01             	cmp    $0x1,%edi
80100fa7:	74 57                	je     80101000 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fa9:	83 ff 02             	cmp    $0x2,%edi
80100fac:	74 2a                	je     80100fd8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb1:	5b                   	pop    %ebx
80100fb2:	5e                   	pop    %esi
80100fb3:	5f                   	pop    %edi
80100fb4:	5d                   	pop    %ebp
80100fb5:	c3                   	ret    
80100fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fbd:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100fc0:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100fc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fca:	5b                   	pop    %ebx
80100fcb:	5e                   	pop    %esi
80100fcc:	5f                   	pop    %edi
80100fcd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fce:	e9 7d 3d 00 00       	jmp    80104d50 <release>
80100fd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fd7:	90                   	nop
    begin_op();
80100fd8:	e8 e3 1d 00 00       	call   80102dc0 <begin_op>
    iput(ff.ip);
80100fdd:	83 ec 0c             	sub    $0xc,%esp
80100fe0:	ff 75 e0             	push   -0x20(%ebp)
80100fe3:	e8 28 09 00 00       	call   80101910 <iput>
    end_op();
80100fe8:	83 c4 10             	add    $0x10,%esp
}
80100feb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fee:	5b                   	pop    %ebx
80100fef:	5e                   	pop    %esi
80100ff0:	5f                   	pop    %edi
80100ff1:	5d                   	pop    %ebp
    end_op();
80100ff2:	e9 39 1e 00 00       	jmp    80102e30 <end_op>
80100ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ffe:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101000:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101004:	83 ec 08             	sub    $0x8,%esp
80101007:	53                   	push   %ebx
80101008:	56                   	push   %esi
80101009:	e8 82 25 00 00       	call   80103590 <pipeclose>
8010100e:	83 c4 10             	add    $0x10,%esp
}
80101011:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101014:	5b                   	pop    %ebx
80101015:	5e                   	pop    %esi
80101016:	5f                   	pop    %edi
80101017:	5d                   	pop    %ebp
80101018:	c3                   	ret    
    panic("fileclose");
80101019:	83 ec 0c             	sub    $0xc,%esp
8010101c:	68 72 7b 10 80       	push   $0x80107b72
80101021:	e8 5a f3 ff ff       	call   80100380 <panic>
80101026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010102d:	8d 76 00             	lea    0x0(%esi),%esi

80101030 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	53                   	push   %ebx
80101034:	83 ec 04             	sub    $0x4,%esp
80101037:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010103a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010103d:	75 31                	jne    80101070 <filestat+0x40>
    ilock(f->ip);
8010103f:	83 ec 0c             	sub    $0xc,%esp
80101042:	ff 73 10             	push   0x10(%ebx)
80101045:	e8 96 07 00 00       	call   801017e0 <ilock>
    stati(f->ip, st);
8010104a:	58                   	pop    %eax
8010104b:	5a                   	pop    %edx
8010104c:	ff 75 0c             	push   0xc(%ebp)
8010104f:	ff 73 10             	push   0x10(%ebx)
80101052:	e8 69 0a 00 00       	call   80101ac0 <stati>
    iunlock(f->ip);
80101057:	59                   	pop    %ecx
80101058:	ff 73 10             	push   0x10(%ebx)
8010105b:	e8 60 08 00 00       	call   801018c0 <iunlock>
    return 0;
  }
  return -1;
}
80101060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101063:	83 c4 10             	add    $0x10,%esp
80101066:	31 c0                	xor    %eax,%eax
}
80101068:	c9                   	leave  
80101069:	c3                   	ret    
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101070:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101073:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101078:	c9                   	leave  
80101079:	c3                   	ret    
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101080 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101080:	55                   	push   %ebp
80101081:	89 e5                	mov    %esp,%ebp
80101083:	57                   	push   %edi
80101084:	56                   	push   %esi
80101085:	53                   	push   %ebx
80101086:	83 ec 0c             	sub    $0xc,%esp
80101089:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010108c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010108f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101092:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101096:	74 60                	je     801010f8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101098:	8b 03                	mov    (%ebx),%eax
8010109a:	83 f8 01             	cmp    $0x1,%eax
8010109d:	74 41                	je     801010e0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010109f:	83 f8 02             	cmp    $0x2,%eax
801010a2:	75 5b                	jne    801010ff <fileread+0x7f>
    ilock(f->ip);
801010a4:	83 ec 0c             	sub    $0xc,%esp
801010a7:	ff 73 10             	push   0x10(%ebx)
801010aa:	e8 31 07 00 00       	call   801017e0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010af:	57                   	push   %edi
801010b0:	ff 73 14             	push   0x14(%ebx)
801010b3:	56                   	push   %esi
801010b4:	ff 73 10             	push   0x10(%ebx)
801010b7:	e8 34 0a 00 00       	call   80101af0 <readi>
801010bc:	83 c4 20             	add    $0x20,%esp
801010bf:	89 c6                	mov    %eax,%esi
801010c1:	85 c0                	test   %eax,%eax
801010c3:	7e 03                	jle    801010c8 <fileread+0x48>
      f->off += r;
801010c5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010c8:	83 ec 0c             	sub    $0xc,%esp
801010cb:	ff 73 10             	push   0x10(%ebx)
801010ce:	e8 ed 07 00 00       	call   801018c0 <iunlock>
    return r;
801010d3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d9:	89 f0                	mov    %esi,%eax
801010db:	5b                   	pop    %ebx
801010dc:	5e                   	pop    %esi
801010dd:	5f                   	pop    %edi
801010de:	5d                   	pop    %ebp
801010df:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801010e0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010ed:	e9 3e 26 00 00       	jmp    80103730 <piperead>
801010f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010f8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010fd:	eb d7                	jmp    801010d6 <fileread+0x56>
  panic("fileread");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 7c 7b 10 80       	push   $0x80107b7c
80101107:	e8 74 f2 ff ff       	call   80100380 <panic>
8010110c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101110 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
80101119:	8b 45 0c             	mov    0xc(%ebp),%eax
8010111c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010111f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101122:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101125:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101129:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010112c:	0f 84 bd 00 00 00    	je     801011ef <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101132:	8b 03                	mov    (%ebx),%eax
80101134:	83 f8 01             	cmp    $0x1,%eax
80101137:	0f 84 bf 00 00 00    	je     801011fc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010113d:	83 f8 02             	cmp    $0x2,%eax
80101140:	0f 85 c8 00 00 00    	jne    8010120e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101146:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101149:	31 f6                	xor    %esi,%esi
    while(i < n){
8010114b:	85 c0                	test   %eax,%eax
8010114d:	7f 30                	jg     8010117f <filewrite+0x6f>
8010114f:	e9 94 00 00 00       	jmp    801011e8 <filewrite+0xd8>
80101154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101158:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010115b:	83 ec 0c             	sub    $0xc,%esp
8010115e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101161:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101164:	e8 57 07 00 00       	call   801018c0 <iunlock>
      end_op();
80101169:	e8 c2 1c 00 00       	call   80102e30 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010116e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101171:	83 c4 10             	add    $0x10,%esp
80101174:	39 c7                	cmp    %eax,%edi
80101176:	75 5c                	jne    801011d4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101178:	01 fe                	add    %edi,%esi
    while(i < n){
8010117a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010117d:	7e 69                	jle    801011e8 <filewrite+0xd8>
      int n1 = n - i;
8010117f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101182:	b8 00 06 00 00       	mov    $0x600,%eax
80101187:	29 f7                	sub    %esi,%edi
80101189:	39 c7                	cmp    %eax,%edi
8010118b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010118e:	e8 2d 1c 00 00       	call   80102dc0 <begin_op>
      ilock(f->ip);
80101193:	83 ec 0c             	sub    $0xc,%esp
80101196:	ff 73 10             	push   0x10(%ebx)
80101199:	e8 42 06 00 00       	call   801017e0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010119e:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a1:	57                   	push   %edi
801011a2:	ff 73 14             	push   0x14(%ebx)
801011a5:	01 f0                	add    %esi,%eax
801011a7:	50                   	push   %eax
801011a8:	ff 73 10             	push   0x10(%ebx)
801011ab:	e8 40 0a 00 00       	call   80101bf0 <writei>
801011b0:	83 c4 20             	add    $0x20,%esp
801011b3:	85 c0                	test   %eax,%eax
801011b5:	7f a1                	jg     80101158 <filewrite+0x48>
      iunlock(f->ip);
801011b7:	83 ec 0c             	sub    $0xc,%esp
801011ba:	ff 73 10             	push   0x10(%ebx)
801011bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011c0:	e8 fb 06 00 00       	call   801018c0 <iunlock>
      end_op();
801011c5:	e8 66 1c 00 00       	call   80102e30 <end_op>
      if(r < 0)
801011ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011cd:	83 c4 10             	add    $0x10,%esp
801011d0:	85 c0                	test   %eax,%eax
801011d2:	75 1b                	jne    801011ef <filewrite+0xdf>
        panic("short filewrite");
801011d4:	83 ec 0c             	sub    $0xc,%esp
801011d7:	68 85 7b 10 80       	push   $0x80107b85
801011dc:	e8 9f f1 ff ff       	call   80100380 <panic>
801011e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011e8:	89 f0                	mov    %esi,%eax
801011ea:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801011ed:	74 05                	je     801011f4 <filewrite+0xe4>
801011ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f7:	5b                   	pop    %ebx
801011f8:	5e                   	pop    %esi
801011f9:	5f                   	pop    %edi
801011fa:	5d                   	pop    %ebp
801011fb:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011fc:	8b 43 0c             	mov    0xc(%ebx),%eax
801011ff:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101202:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101205:	5b                   	pop    %ebx
80101206:	5e                   	pop    %esi
80101207:	5f                   	pop    %edi
80101208:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101209:	e9 22 24 00 00       	jmp    80103630 <pipewrite>
  panic("filewrite");
8010120e:	83 ec 0c             	sub    $0xc,%esp
80101211:	68 8b 7b 10 80       	push   $0x80107b8b
80101216:	e8 65 f1 ff ff       	call   80100380 <panic>
8010121b:	66 90                	xchg   %ax,%ax
8010121d:	66 90                	xchg   %ax,%ax
8010121f:	90                   	nop

80101220 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101220:	55                   	push   %ebp
80101221:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101223:	89 d0                	mov    %edx,%eax
80101225:	c1 e8 0c             	shr    $0xc,%eax
80101228:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
8010122e:	89 e5                	mov    %esp,%ebp
80101230:	56                   	push   %esi
80101231:	53                   	push   %ebx
80101232:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101234:	83 ec 08             	sub    $0x8,%esp
80101237:	50                   	push   %eax
80101238:	51                   	push   %ecx
80101239:	e8 92 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010123e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101240:	c1 fb 03             	sar    $0x3,%ebx
80101243:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101246:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101248:	83 e1 07             	and    $0x7,%ecx
8010124b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101250:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101256:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101258:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010125d:	85 c1                	test   %eax,%ecx
8010125f:	74 23                	je     80101284 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101261:	f7 d0                	not    %eax
  log_write(bp);
80101263:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101266:	21 c8                	and    %ecx,%eax
80101268:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010126c:	56                   	push   %esi
8010126d:	e8 2e 1d 00 00       	call   80102fa0 <log_write>
  brelse(bp);
80101272:	89 34 24             	mov    %esi,(%esp)
80101275:	e8 76 ef ff ff       	call   801001f0 <brelse>
}
8010127a:	83 c4 10             	add    $0x10,%esp
8010127d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101280:	5b                   	pop    %ebx
80101281:	5e                   	pop    %esi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
    panic("freeing free block");
80101284:	83 ec 0c             	sub    $0xc,%esp
80101287:	68 95 7b 10 80       	push   $0x80107b95
8010128c:	e8 ef f0 ff ff       	call   80100380 <panic>
80101291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010129f:	90                   	nop

801012a0 <balloc>:
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	56                   	push   %esi
801012a5:	53                   	push   %ebx
801012a6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801012a9:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
801012af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012b2:	85 c9                	test   %ecx,%ecx
801012b4:	0f 84 87 00 00 00    	je     80101341 <balloc+0xa1>
801012ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012c1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012c4:	83 ec 08             	sub    $0x8,%esp
801012c7:	89 f0                	mov    %esi,%eax
801012c9:	c1 f8 0c             	sar    $0xc,%eax
801012cc:	03 05 cc 25 11 80    	add    0x801125cc,%eax
801012d2:	50                   	push   %eax
801012d3:	ff 75 d8             	push   -0x28(%ebp)
801012d6:	e8 f5 ed ff ff       	call   801000d0 <bread>
801012db:	83 c4 10             	add    $0x10,%esp
801012de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012e1:	a1 b4 25 11 80       	mov    0x801125b4,%eax
801012e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012e9:	31 c0                	xor    %eax,%eax
801012eb:	eb 2f                	jmp    8010131c <balloc+0x7c>
801012ed:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012f0:	89 c1                	mov    %eax,%ecx
801012f2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012fa:	83 e1 07             	and    $0x7,%ecx
801012fd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012ff:	89 c1                	mov    %eax,%ecx
80101301:	c1 f9 03             	sar    $0x3,%ecx
80101304:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101309:	89 fa                	mov    %edi,%edx
8010130b:	85 df                	test   %ebx,%edi
8010130d:	74 41                	je     80101350 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010130f:	83 c0 01             	add    $0x1,%eax
80101312:	83 c6 01             	add    $0x1,%esi
80101315:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010131a:	74 05                	je     80101321 <balloc+0x81>
8010131c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010131f:	77 cf                	ja     801012f0 <balloc+0x50>
    brelse(bp);
80101321:	83 ec 0c             	sub    $0xc,%esp
80101324:	ff 75 e4             	push   -0x1c(%ebp)
80101327:	e8 c4 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010132c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101333:	83 c4 10             	add    $0x10,%esp
80101336:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101339:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
8010133f:	77 80                	ja     801012c1 <balloc+0x21>
  panic("balloc: out of blocks");
80101341:	83 ec 0c             	sub    $0xc,%esp
80101344:	68 a8 7b 10 80       	push   $0x80107ba8
80101349:	e8 32 f0 ff ff       	call   80100380 <panic>
8010134e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101350:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101353:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101356:	09 da                	or     %ebx,%edx
80101358:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010135c:	57                   	push   %edi
8010135d:	e8 3e 1c 00 00       	call   80102fa0 <log_write>
        brelse(bp);
80101362:	89 3c 24             	mov    %edi,(%esp)
80101365:	e8 86 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010136a:	58                   	pop    %eax
8010136b:	5a                   	pop    %edx
8010136c:	56                   	push   %esi
8010136d:	ff 75 d8             	push   -0x28(%ebp)
80101370:	e8 5b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101375:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101378:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010137a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010137d:	68 00 02 00 00       	push   $0x200
80101382:	6a 00                	push   $0x0
80101384:	50                   	push   %eax
80101385:	e8 e6 3a 00 00       	call   80104e70 <memset>
  log_write(bp);
8010138a:	89 1c 24             	mov    %ebx,(%esp)
8010138d:	e8 0e 1c 00 00       	call   80102fa0 <log_write>
  brelse(bp);
80101392:	89 1c 24             	mov    %ebx,(%esp)
80101395:	e8 56 ee ff ff       	call   801001f0 <brelse>
}
8010139a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010139d:	89 f0                	mov    %esi,%eax
8010139f:	5b                   	pop    %ebx
801013a0:	5e                   	pop    %esi
801013a1:	5f                   	pop    %edi
801013a2:	5d                   	pop    %ebp
801013a3:	c3                   	ret    
801013a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013af:	90                   	nop

801013b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	57                   	push   %edi
801013b4:	89 c7                	mov    %eax,%edi
801013b6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013b7:	31 f6                	xor    %esi,%esi
{
801013b9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ba:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
801013bf:	83 ec 28             	sub    $0x28,%esp
801013c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013c5:	68 60 09 11 80       	push   $0x80110960
801013ca:	e8 e1 39 00 00       	call   80104db0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801013d2:	83 c4 10             	add    $0x10,%esp
801013d5:	eb 1b                	jmp    801013f2 <iget+0x42>
801013d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013de:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 3b                	cmp    %edi,(%ebx)
801013e2:	74 6c                	je     80101450 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013ea:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013f0:	73 26                	jae    80101418 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f2:	8b 43 08             	mov    0x8(%ebx),%eax
801013f5:	85 c0                	test   %eax,%eax
801013f7:	7f e7                	jg     801013e0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013f9:	85 f6                	test   %esi,%esi
801013fb:	75 e7                	jne    801013e4 <iget+0x34>
801013fd:	85 c0                	test   %eax,%eax
801013ff:	75 76                	jne    80101477 <iget+0xc7>
80101401:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101403:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101409:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010140f:	72 e1                	jb     801013f2 <iget+0x42>
80101411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101418:	85 f6                	test   %esi,%esi
8010141a:	74 79                	je     80101495 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010141c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010141f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101421:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101424:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010142b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101432:	68 60 09 11 80       	push   $0x80110960
80101437:	e8 14 39 00 00       	call   80104d50 <release>

  return ip;
8010143c:	83 c4 10             	add    $0x10,%esp
}
8010143f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101442:	89 f0                	mov    %esi,%eax
80101444:	5b                   	pop    %ebx
80101445:	5e                   	pop    %esi
80101446:	5f                   	pop    %edi
80101447:	5d                   	pop    %ebp
80101448:	c3                   	ret    
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101450:	39 53 04             	cmp    %edx,0x4(%ebx)
80101453:	75 8f                	jne    801013e4 <iget+0x34>
      release(&icache.lock);
80101455:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101458:	83 c0 01             	add    $0x1,%eax
      return ip;
8010145b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010145d:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101462:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101465:	e8 e6 38 00 00       	call   80104d50 <release>
      return ip;
8010146a:	83 c4 10             	add    $0x10,%esp
}
8010146d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101470:	89 f0                	mov    %esi,%eax
80101472:	5b                   	pop    %ebx
80101473:	5e                   	pop    %esi
80101474:	5f                   	pop    %edi
80101475:	5d                   	pop    %ebp
80101476:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101477:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010147d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101483:	73 10                	jae    80101495 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101485:	8b 43 08             	mov    0x8(%ebx),%eax
80101488:	85 c0                	test   %eax,%eax
8010148a:	0f 8f 50 ff ff ff    	jg     801013e0 <iget+0x30>
80101490:	e9 68 ff ff ff       	jmp    801013fd <iget+0x4d>
    panic("iget: no inodes");
80101495:	83 ec 0c             	sub    $0xc,%esp
80101498:	68 be 7b 10 80       	push   $0x80107bbe
8010149d:	e8 de ee ff ff       	call   80100380 <panic>
801014a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	57                   	push   %edi
801014b4:	56                   	push   %esi
801014b5:	89 c6                	mov    %eax,%esi
801014b7:	53                   	push   %ebx
801014b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014bb:	83 fa 0b             	cmp    $0xb,%edx
801014be:	0f 86 8c 00 00 00    	jbe    80101550 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014c4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014c7:	83 fb 7f             	cmp    $0x7f,%ebx
801014ca:	0f 87 a2 00 00 00    	ja     80101572 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014d0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014d6:	85 c0                	test   %eax,%eax
801014d8:	74 5e                	je     80101538 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014da:	83 ec 08             	sub    $0x8,%esp
801014dd:	50                   	push   %eax
801014de:	ff 36                	push   (%esi)
801014e0:	e8 eb eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014e5:	83 c4 10             	add    $0x10,%esp
801014e8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014ec:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014ee:	8b 3b                	mov    (%ebx),%edi
801014f0:	85 ff                	test   %edi,%edi
801014f2:	74 1c                	je     80101510 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014f4:	83 ec 0c             	sub    $0xc,%esp
801014f7:	52                   	push   %edx
801014f8:	e8 f3 ec ff ff       	call   801001f0 <brelse>
801014fd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101500:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101503:	89 f8                	mov    %edi,%eax
80101505:	5b                   	pop    %ebx
80101506:	5e                   	pop    %esi
80101507:	5f                   	pop    %edi
80101508:	5d                   	pop    %ebp
80101509:	c3                   	ret    
8010150a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101510:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101513:	8b 06                	mov    (%esi),%eax
80101515:	e8 86 fd ff ff       	call   801012a0 <balloc>
      log_write(bp);
8010151a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010151d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101520:	89 03                	mov    %eax,(%ebx)
80101522:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101524:	52                   	push   %edx
80101525:	e8 76 1a 00 00       	call   80102fa0 <log_write>
8010152a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010152d:	83 c4 10             	add    $0x10,%esp
80101530:	eb c2                	jmp    801014f4 <bmap+0x44>
80101532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101538:	8b 06                	mov    (%esi),%eax
8010153a:	e8 61 fd ff ff       	call   801012a0 <balloc>
8010153f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101545:	eb 93                	jmp    801014da <bmap+0x2a>
80101547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010154e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101550:	8d 5a 14             	lea    0x14(%edx),%ebx
80101553:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101557:	85 ff                	test   %edi,%edi
80101559:	75 a5                	jne    80101500 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010155b:	8b 00                	mov    (%eax),%eax
8010155d:	e8 3e fd ff ff       	call   801012a0 <balloc>
80101562:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101566:	89 c7                	mov    %eax,%edi
}
80101568:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010156b:	5b                   	pop    %ebx
8010156c:	89 f8                	mov    %edi,%eax
8010156e:	5e                   	pop    %esi
8010156f:	5f                   	pop    %edi
80101570:	5d                   	pop    %ebp
80101571:	c3                   	ret    
  panic("bmap: out of range");
80101572:	83 ec 0c             	sub    $0xc,%esp
80101575:	68 ce 7b 10 80       	push   $0x80107bce
8010157a:	e8 01 ee ff ff       	call   80100380 <panic>
8010157f:	90                   	nop

80101580 <readsb>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	56                   	push   %esi
80101584:	53                   	push   %ebx
80101585:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101588:	83 ec 08             	sub    $0x8,%esp
8010158b:	6a 01                	push   $0x1
8010158d:	ff 75 08             	push   0x8(%ebp)
80101590:	e8 3b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101595:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101598:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010159a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010159d:	6a 1c                	push   $0x1c
8010159f:	50                   	push   %eax
801015a0:	56                   	push   %esi
801015a1:	e8 6a 39 00 00       	call   80104f10 <memmove>
  brelse(bp);
801015a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801015a9:	83 c4 10             	add    $0x10,%esp
}
801015ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015af:	5b                   	pop    %ebx
801015b0:	5e                   	pop    %esi
801015b1:	5d                   	pop    %ebp
  brelse(bp);
801015b2:	e9 39 ec ff ff       	jmp    801001f0 <brelse>
801015b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015be:	66 90                	xchg   %ax,%ax

801015c0 <iinit>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	53                   	push   %ebx
801015c4:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
801015c9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015cc:	68 e1 7b 10 80       	push   $0x80107be1
801015d1:	68 60 09 11 80       	push   $0x80110960
801015d6:	e8 05 36 00 00       	call   80104be0 <initlock>
  for(i = 0; i < NINODE; i++) {
801015db:	83 c4 10             	add    $0x10,%esp
801015de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015e0:	83 ec 08             	sub    $0x8,%esp
801015e3:	68 e8 7b 10 80       	push   $0x80107be8
801015e8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015ef:	e8 bc 34 00 00       	call   80104ab0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015f4:	83 c4 10             	add    $0x10,%esp
801015f7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801015fd:	75 e1                	jne    801015e0 <iinit+0x20>
  bp = bread(dev, 1);
801015ff:	83 ec 08             	sub    $0x8,%esp
80101602:	6a 01                	push   $0x1
80101604:	ff 75 08             	push   0x8(%ebp)
80101607:	e8 c4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010160c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010160f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101611:	8d 40 5c             	lea    0x5c(%eax),%eax
80101614:	6a 1c                	push   $0x1c
80101616:	50                   	push   %eax
80101617:	68 b4 25 11 80       	push   $0x801125b4
8010161c:	e8 ef 38 00 00       	call   80104f10 <memmove>
  brelse(bp);
80101621:	89 1c 24             	mov    %ebx,(%esp)
80101624:	e8 c7 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101629:	ff 35 cc 25 11 80    	push   0x801125cc
8010162f:	ff 35 c8 25 11 80    	push   0x801125c8
80101635:	ff 35 c4 25 11 80    	push   0x801125c4
8010163b:	ff 35 c0 25 11 80    	push   0x801125c0
80101641:	ff 35 bc 25 11 80    	push   0x801125bc
80101647:	ff 35 b8 25 11 80    	push   0x801125b8
8010164d:	ff 35 b4 25 11 80    	push   0x801125b4
80101653:	68 4c 7c 10 80       	push   $0x80107c4c
80101658:	e8 43 f0 ff ff       	call   801006a0 <cprintf>
}
8010165d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101660:	83 c4 30             	add    $0x30,%esp
80101663:	c9                   	leave  
80101664:	c3                   	ret    
80101665:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010166c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101670 <ialloc>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	57                   	push   %edi
80101674:	56                   	push   %esi
80101675:	53                   	push   %ebx
80101676:	83 ec 1c             	sub    $0x1c,%esp
80101679:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010167c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101683:	8b 75 08             	mov    0x8(%ebp),%esi
80101686:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101689:	0f 86 91 00 00 00    	jbe    80101720 <ialloc+0xb0>
8010168f:	bf 01 00 00 00       	mov    $0x1,%edi
80101694:	eb 21                	jmp    801016b7 <ialloc+0x47>
80101696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010169d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801016a0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016a3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016a6:	53                   	push   %ebx
801016a7:	e8 44 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016ac:	83 c4 10             	add    $0x10,%esp
801016af:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
801016b5:	73 69                	jae    80101720 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016b7:	89 f8                	mov    %edi,%eax
801016b9:	83 ec 08             	sub    $0x8,%esp
801016bc:	c1 e8 03             	shr    $0x3,%eax
801016bf:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016c5:	50                   	push   %eax
801016c6:	56                   	push   %esi
801016c7:	e8 04 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016cc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016cf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016d1:	89 f8                	mov    %edi,%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016dd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016e1:	75 bd                	jne    801016a0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016e3:	83 ec 04             	sub    $0x4,%esp
801016e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016e9:	6a 40                	push   $0x40
801016eb:	6a 00                	push   $0x0
801016ed:	51                   	push   %ecx
801016ee:	e8 7d 37 00 00       	call   80104e70 <memset>
      dip->type = type;
801016f3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016f7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016fa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016fd:	89 1c 24             	mov    %ebx,(%esp)
80101700:	e8 9b 18 00 00       	call   80102fa0 <log_write>
      brelse(bp);
80101705:	89 1c 24             	mov    %ebx,(%esp)
80101708:	e8 e3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010170d:	83 c4 10             	add    $0x10,%esp
}
80101710:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101713:	89 fa                	mov    %edi,%edx
}
80101715:	5b                   	pop    %ebx
      return iget(dev, inum);
80101716:	89 f0                	mov    %esi,%eax
}
80101718:	5e                   	pop    %esi
80101719:	5f                   	pop    %edi
8010171a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010171b:	e9 90 fc ff ff       	jmp    801013b0 <iget>
  panic("ialloc: no inodes");
80101720:	83 ec 0c             	sub    $0xc,%esp
80101723:	68 ee 7b 10 80       	push   $0x80107bee
80101728:	e8 53 ec ff ff       	call   80100380 <panic>
8010172d:	8d 76 00             	lea    0x0(%esi),%esi

80101730 <iupdate>:
{
80101730:	55                   	push   %ebp
80101731:	89 e5                	mov    %esp,%ebp
80101733:	56                   	push   %esi
80101734:	53                   	push   %ebx
80101735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101738:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010173b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010173e:	83 ec 08             	sub    $0x8,%esp
80101741:	c1 e8 03             	shr    $0x3,%eax
80101744:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010174a:	50                   	push   %eax
8010174b:	ff 73 a4             	push   -0x5c(%ebx)
8010174e:	e8 7d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101753:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101757:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010175a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010175c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010175f:	83 e0 07             	and    $0x7,%eax
80101762:	c1 e0 06             	shl    $0x6,%eax
80101765:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101769:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010176c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101770:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101773:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101777:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010177b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010177f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101783:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101787:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010178a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010178d:	6a 34                	push   $0x34
8010178f:	53                   	push   %ebx
80101790:	50                   	push   %eax
80101791:	e8 7a 37 00 00       	call   80104f10 <memmove>
  log_write(bp);
80101796:	89 34 24             	mov    %esi,(%esp)
80101799:	e8 02 18 00 00       	call   80102fa0 <log_write>
  brelse(bp);
8010179e:	89 75 08             	mov    %esi,0x8(%ebp)
801017a1:	83 c4 10             	add    $0x10,%esp
}
801017a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017a7:	5b                   	pop    %ebx
801017a8:	5e                   	pop    %esi
801017a9:	5d                   	pop    %ebp
  brelse(bp);
801017aa:	e9 41 ea ff ff       	jmp    801001f0 <brelse>
801017af:	90                   	nop

801017b0 <idup>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	53                   	push   %ebx
801017b4:	83 ec 10             	sub    $0x10,%esp
801017b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017ba:	68 60 09 11 80       	push   $0x80110960
801017bf:	e8 ec 35 00 00       	call   80104db0 <acquire>
  ip->ref++;
801017c4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017c8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801017cf:	e8 7c 35 00 00       	call   80104d50 <release>
}
801017d4:	89 d8                	mov    %ebx,%eax
801017d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017d9:	c9                   	leave  
801017da:	c3                   	ret    
801017db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017df:	90                   	nop

801017e0 <ilock>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	56                   	push   %esi
801017e4:	53                   	push   %ebx
801017e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017e8:	85 db                	test   %ebx,%ebx
801017ea:	0f 84 b7 00 00 00    	je     801018a7 <ilock+0xc7>
801017f0:	8b 53 08             	mov    0x8(%ebx),%edx
801017f3:	85 d2                	test   %edx,%edx
801017f5:	0f 8e ac 00 00 00    	jle    801018a7 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017fb:	83 ec 0c             	sub    $0xc,%esp
801017fe:	8d 43 0c             	lea    0xc(%ebx),%eax
80101801:	50                   	push   %eax
80101802:	e8 e9 32 00 00       	call   80104af0 <acquiresleep>
  if(ip->valid == 0){
80101807:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010180a:	83 c4 10             	add    $0x10,%esp
8010180d:	85 c0                	test   %eax,%eax
8010180f:	74 0f                	je     80101820 <ilock+0x40>
}
80101811:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101814:	5b                   	pop    %ebx
80101815:	5e                   	pop    %esi
80101816:	5d                   	pop    %ebp
80101817:	c3                   	ret    
80101818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010181f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101820:	8b 43 04             	mov    0x4(%ebx),%eax
80101823:	83 ec 08             	sub    $0x8,%esp
80101826:	c1 e8 03             	shr    $0x3,%eax
80101829:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010182f:	50                   	push   %eax
80101830:	ff 33                	push   (%ebx)
80101832:	e8 99 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101837:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010183a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010183c:	8b 43 04             	mov    0x4(%ebx),%eax
8010183f:	83 e0 07             	and    $0x7,%eax
80101842:	c1 e0 06             	shl    $0x6,%eax
80101845:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101849:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010184c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010184f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101853:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101857:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010185b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010185f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101863:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101867:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010186b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010186e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101871:	6a 34                	push   $0x34
80101873:	50                   	push   %eax
80101874:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101877:	50                   	push   %eax
80101878:	e8 93 36 00 00       	call   80104f10 <memmove>
    brelse(bp);
8010187d:	89 34 24             	mov    %esi,(%esp)
80101880:	e8 6b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101885:	83 c4 10             	add    $0x10,%esp
80101888:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010188d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101894:	0f 85 77 ff ff ff    	jne    80101811 <ilock+0x31>
      panic("ilock: no type");
8010189a:	83 ec 0c             	sub    $0xc,%esp
8010189d:	68 06 7c 10 80       	push   $0x80107c06
801018a2:	e8 d9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
801018a7:	83 ec 0c             	sub    $0xc,%esp
801018aa:	68 00 7c 10 80       	push   $0x80107c00
801018af:	e8 cc ea ff ff       	call   80100380 <panic>
801018b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018bf:	90                   	nop

801018c0 <iunlock>:
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	56                   	push   %esi
801018c4:	53                   	push   %ebx
801018c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018c8:	85 db                	test   %ebx,%ebx
801018ca:	74 28                	je     801018f4 <iunlock+0x34>
801018cc:	83 ec 0c             	sub    $0xc,%esp
801018cf:	8d 73 0c             	lea    0xc(%ebx),%esi
801018d2:	56                   	push   %esi
801018d3:	e8 b8 32 00 00       	call   80104b90 <holdingsleep>
801018d8:	83 c4 10             	add    $0x10,%esp
801018db:	85 c0                	test   %eax,%eax
801018dd:	74 15                	je     801018f4 <iunlock+0x34>
801018df:	8b 43 08             	mov    0x8(%ebx),%eax
801018e2:	85 c0                	test   %eax,%eax
801018e4:	7e 0e                	jle    801018f4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018e6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ec:	5b                   	pop    %ebx
801018ed:	5e                   	pop    %esi
801018ee:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018ef:	e9 5c 32 00 00       	jmp    80104b50 <releasesleep>
    panic("iunlock");
801018f4:	83 ec 0c             	sub    $0xc,%esp
801018f7:	68 15 7c 10 80       	push   $0x80107c15
801018fc:	e8 7f ea ff ff       	call   80100380 <panic>
80101901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101908:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010190f:	90                   	nop

80101910 <iput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	57                   	push   %edi
80101914:	56                   	push   %esi
80101915:	53                   	push   %ebx
80101916:	83 ec 28             	sub    $0x28,%esp
80101919:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010191c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010191f:	57                   	push   %edi
80101920:	e8 cb 31 00 00       	call   80104af0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101925:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101928:	83 c4 10             	add    $0x10,%esp
8010192b:	85 d2                	test   %edx,%edx
8010192d:	74 07                	je     80101936 <iput+0x26>
8010192f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101934:	74 32                	je     80101968 <iput+0x58>
  releasesleep(&ip->lock);
80101936:	83 ec 0c             	sub    $0xc,%esp
80101939:	57                   	push   %edi
8010193a:	e8 11 32 00 00       	call   80104b50 <releasesleep>
  acquire(&icache.lock);
8010193f:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101946:	e8 65 34 00 00       	call   80104db0 <acquire>
  ip->ref--;
8010194b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010194f:	83 c4 10             	add    $0x10,%esp
80101952:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101959:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010195c:	5b                   	pop    %ebx
8010195d:	5e                   	pop    %esi
8010195e:	5f                   	pop    %edi
8010195f:	5d                   	pop    %ebp
  release(&icache.lock);
80101960:	e9 eb 33 00 00       	jmp    80104d50 <release>
80101965:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101968:	83 ec 0c             	sub    $0xc,%esp
8010196b:	68 60 09 11 80       	push   $0x80110960
80101970:	e8 3b 34 00 00       	call   80104db0 <acquire>
    int r = ip->ref;
80101975:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101978:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010197f:	e8 cc 33 00 00       	call   80104d50 <release>
    if(r == 1){
80101984:	83 c4 10             	add    $0x10,%esp
80101987:	83 fe 01             	cmp    $0x1,%esi
8010198a:	75 aa                	jne    80101936 <iput+0x26>
8010198c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101992:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101995:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101998:	89 cf                	mov    %ecx,%edi
8010199a:	eb 0b                	jmp    801019a7 <iput+0x97>
8010199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019a0:	83 c6 04             	add    $0x4,%esi
801019a3:	39 fe                	cmp    %edi,%esi
801019a5:	74 19                	je     801019c0 <iput+0xb0>
    if(ip->addrs[i]){
801019a7:	8b 16                	mov    (%esi),%edx
801019a9:	85 d2                	test   %edx,%edx
801019ab:	74 f3                	je     801019a0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019ad:	8b 03                	mov    (%ebx),%eax
801019af:	e8 6c f8 ff ff       	call   80101220 <bfree>
      ip->addrs[i] = 0;
801019b4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019ba:	eb e4                	jmp    801019a0 <iput+0x90>
801019bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019c0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019c9:	85 c0                	test   %eax,%eax
801019cb:	75 2d                	jne    801019fa <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019cd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019d0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019d7:	53                   	push   %ebx
801019d8:	e8 53 fd ff ff       	call   80101730 <iupdate>
      ip->type = 0;
801019dd:	31 c0                	xor    %eax,%eax
801019df:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019e3:	89 1c 24             	mov    %ebx,(%esp)
801019e6:	e8 45 fd ff ff       	call   80101730 <iupdate>
      ip->valid = 0;
801019eb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019f2:	83 c4 10             	add    $0x10,%esp
801019f5:	e9 3c ff ff ff       	jmp    80101936 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019fa:	83 ec 08             	sub    $0x8,%esp
801019fd:	50                   	push   %eax
801019fe:	ff 33                	push   (%ebx)
80101a00:	e8 cb e6 ff ff       	call   801000d0 <bread>
80101a05:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a08:	83 c4 10             	add    $0x10,%esp
80101a0b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101a14:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a17:	89 cf                	mov    %ecx,%edi
80101a19:	eb 0c                	jmp    80101a27 <iput+0x117>
80101a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a1f:	90                   	nop
80101a20:	83 c6 04             	add    $0x4,%esi
80101a23:	39 f7                	cmp    %esi,%edi
80101a25:	74 0f                	je     80101a36 <iput+0x126>
      if(a[j])
80101a27:	8b 16                	mov    (%esi),%edx
80101a29:	85 d2                	test   %edx,%edx
80101a2b:	74 f3                	je     80101a20 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a2d:	8b 03                	mov    (%ebx),%eax
80101a2f:	e8 ec f7 ff ff       	call   80101220 <bfree>
80101a34:	eb ea                	jmp    80101a20 <iput+0x110>
    brelse(bp);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	ff 75 e4             	push   -0x1c(%ebp)
80101a3c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a3f:	e8 ac e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a44:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a4a:	8b 03                	mov    (%ebx),%eax
80101a4c:	e8 cf f7 ff ff       	call   80101220 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a51:	83 c4 10             	add    $0x10,%esp
80101a54:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a5b:	00 00 00 
80101a5e:	e9 6a ff ff ff       	jmp    801019cd <iput+0xbd>
80101a63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a70 <iunlockput>:
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	56                   	push   %esi
80101a74:	53                   	push   %ebx
80101a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a78:	85 db                	test   %ebx,%ebx
80101a7a:	74 34                	je     80101ab0 <iunlockput+0x40>
80101a7c:	83 ec 0c             	sub    $0xc,%esp
80101a7f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a82:	56                   	push   %esi
80101a83:	e8 08 31 00 00       	call   80104b90 <holdingsleep>
80101a88:	83 c4 10             	add    $0x10,%esp
80101a8b:	85 c0                	test   %eax,%eax
80101a8d:	74 21                	je     80101ab0 <iunlockput+0x40>
80101a8f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a92:	85 c0                	test   %eax,%eax
80101a94:	7e 1a                	jle    80101ab0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a96:	83 ec 0c             	sub    $0xc,%esp
80101a99:	56                   	push   %esi
80101a9a:	e8 b1 30 00 00       	call   80104b50 <releasesleep>
  iput(ip);
80101a9f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101aa2:	83 c4 10             	add    $0x10,%esp
}
80101aa5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101aa8:	5b                   	pop    %ebx
80101aa9:	5e                   	pop    %esi
80101aaa:	5d                   	pop    %ebp
  iput(ip);
80101aab:	e9 60 fe ff ff       	jmp    80101910 <iput>
    panic("iunlock");
80101ab0:	83 ec 0c             	sub    $0xc,%esp
80101ab3:	68 15 7c 10 80       	push   $0x80107c15
80101ab8:	e8 c3 e8 ff ff       	call   80100380 <panic>
80101abd:	8d 76 00             	lea    0x0(%esi),%esi

80101ac0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ac9:	8b 0a                	mov    (%edx),%ecx
80101acb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ace:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ad1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ad4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ad8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101adb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101adf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ae3:	8b 52 58             	mov    0x58(%edx),%edx
80101ae6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ae9:	5d                   	pop    %ebp
80101aea:	c3                   	ret    
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop

80101af0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	57                   	push   %edi
80101af4:	56                   	push   %esi
80101af5:	53                   	push   %ebx
80101af6:	83 ec 1c             	sub    $0x1c,%esp
80101af9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101afc:	8b 45 08             	mov    0x8(%ebp),%eax
80101aff:	8b 75 10             	mov    0x10(%ebp),%esi
80101b02:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b05:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b08:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b10:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b13:	0f 84 a7 00 00 00    	je     80101bc0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1c:	8b 40 58             	mov    0x58(%eax),%eax
80101b1f:	39 c6                	cmp    %eax,%esi
80101b21:	0f 87 ba 00 00 00    	ja     80101be1 <readi+0xf1>
80101b27:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2a:	31 c9                	xor    %ecx,%ecx
80101b2c:	89 da                	mov    %ebx,%edx
80101b2e:	01 f2                	add    %esi,%edx
80101b30:	0f 92 c1             	setb   %cl
80101b33:	89 cf                	mov    %ecx,%edi
80101b35:	0f 82 a6 00 00 00    	jb     80101be1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b3b:	89 c1                	mov    %eax,%ecx
80101b3d:	29 f1                	sub    %esi,%ecx
80101b3f:	39 d0                	cmp    %edx,%eax
80101b41:	0f 43 cb             	cmovae %ebx,%ecx
80101b44:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	85 c9                	test   %ecx,%ecx
80101b49:	74 67                	je     80101bb2 <readi+0xc2>
80101b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b4f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b50:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b53:	89 f2                	mov    %esi,%edx
80101b55:	c1 ea 09             	shr    $0x9,%edx
80101b58:	89 d8                	mov    %ebx,%eax
80101b5a:	e8 51 f9 ff ff       	call   801014b0 <bmap>
80101b5f:	83 ec 08             	sub    $0x8,%esp
80101b62:	50                   	push   %eax
80101b63:	ff 33                	push   (%ebx)
80101b65:	e8 66 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b6d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b72:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b74:	89 f0                	mov    %esi,%eax
80101b76:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b7b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b7d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b80:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b82:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b86:	39 d9                	cmp    %ebx,%ecx
80101b88:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b8b:	83 c4 0c             	add    $0xc,%esp
80101b8e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b8f:	01 df                	add    %ebx,%edi
80101b91:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b93:	50                   	push   %eax
80101b94:	ff 75 e0             	push   -0x20(%ebp)
80101b97:	e8 74 33 00 00       	call   80104f10 <memmove>
    brelse(bp);
80101b9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b9f:	89 14 24             	mov    %edx,(%esp)
80101ba2:	e8 49 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ba7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101baa:	83 c4 10             	add    $0x10,%esp
80101bad:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101bb0:	77 9e                	ja     80101b50 <readi+0x60>
  }
  return n;
80101bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101bb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bb8:	5b                   	pop    %ebx
80101bb9:	5e                   	pop    %esi
80101bba:	5f                   	pop    %edi
80101bbb:	5d                   	pop    %ebp
80101bbc:	c3                   	ret    
80101bbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bc0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bc4:	66 83 f8 09          	cmp    $0x9,%ax
80101bc8:	77 17                	ja     80101be1 <readi+0xf1>
80101bca:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101bd1:	85 c0                	test   %eax,%eax
80101bd3:	74 0c                	je     80101be1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101bd5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bdb:	5b                   	pop    %ebx
80101bdc:	5e                   	pop    %esi
80101bdd:	5f                   	pop    %edi
80101bde:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bdf:	ff e0                	jmp    *%eax
      return -1;
80101be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101be6:	eb cd                	jmp    80101bb5 <readi+0xc5>
80101be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bef:	90                   	nop

80101bf0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 1c             	sub    $0x1c,%esp
80101bf9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bff:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c02:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c07:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c0d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c10:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c13:	0f 84 b7 00 00 00    	je     80101cd0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c1c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c1f:	0f 87 e7 00 00 00    	ja     80101d0c <writei+0x11c>
80101c25:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c28:	31 d2                	xor    %edx,%edx
80101c2a:	89 f8                	mov    %edi,%eax
80101c2c:	01 f0                	add    %esi,%eax
80101c2e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c31:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c36:	0f 87 d0 00 00 00    	ja     80101d0c <writei+0x11c>
80101c3c:	85 d2                	test   %edx,%edx
80101c3e:	0f 85 c8 00 00 00    	jne    80101d0c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c4b:	85 ff                	test   %edi,%edi
80101c4d:	74 72                	je     80101cc1 <writei+0xd1>
80101c4f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c50:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c53:	89 f2                	mov    %esi,%edx
80101c55:	c1 ea 09             	shr    $0x9,%edx
80101c58:	89 f8                	mov    %edi,%eax
80101c5a:	e8 51 f8 ff ff       	call   801014b0 <bmap>
80101c5f:	83 ec 08             	sub    $0x8,%esp
80101c62:	50                   	push   %eax
80101c63:	ff 37                	push   (%edi)
80101c65:	e8 66 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c6a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c6f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c72:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c75:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c77:	89 f0                	mov    %esi,%eax
80101c79:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c7e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c80:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c84:	39 d9                	cmp    %ebx,%ecx
80101c86:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c89:	83 c4 0c             	add    $0xc,%esp
80101c8c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c8d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c8f:	ff 75 dc             	push   -0x24(%ebp)
80101c92:	50                   	push   %eax
80101c93:	e8 78 32 00 00       	call   80104f10 <memmove>
    log_write(bp);
80101c98:	89 3c 24             	mov    %edi,(%esp)
80101c9b:	e8 00 13 00 00       	call   80102fa0 <log_write>
    brelse(bp);
80101ca0:	89 3c 24             	mov    %edi,(%esp)
80101ca3:	e8 48 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ca8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cab:	83 c4 10             	add    $0x10,%esp
80101cae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cb1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cb4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101cb7:	77 97                	ja     80101c50 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101cb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101cbf:	77 37                	ja     80101cf8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cc7:	5b                   	pop    %ebx
80101cc8:	5e                   	pop    %esi
80101cc9:	5f                   	pop    %edi
80101cca:	5d                   	pop    %ebp
80101ccb:	c3                   	ret    
80101ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cd4:	66 83 f8 09          	cmp    $0x9,%ax
80101cd8:	77 32                	ja     80101d0c <writei+0x11c>
80101cda:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101ce1:	85 c0                	test   %eax,%eax
80101ce3:	74 27                	je     80101d0c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101ce5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ceb:	5b                   	pop    %ebx
80101cec:	5e                   	pop    %esi
80101ced:	5f                   	pop    %edi
80101cee:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101cef:	ff e0                	jmp    *%eax
80101cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101cf8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cfb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cfe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d01:	50                   	push   %eax
80101d02:	e8 29 fa ff ff       	call   80101730 <iupdate>
80101d07:	83 c4 10             	add    $0x10,%esp
80101d0a:	eb b5                	jmp    80101cc1 <writei+0xd1>
      return -1;
80101d0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d11:	eb b1                	jmp    80101cc4 <writei+0xd4>
80101d13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101d20 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d26:	6a 0e                	push   $0xe
80101d28:	ff 75 0c             	push   0xc(%ebp)
80101d2b:	ff 75 08             	push   0x8(%ebp)
80101d2e:	e8 4d 32 00 00       	call   80104f80 <strncmp>
}
80101d33:	c9                   	leave  
80101d34:	c3                   	ret    
80101d35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d40 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	57                   	push   %edi
80101d44:	56                   	push   %esi
80101d45:	53                   	push   %ebx
80101d46:	83 ec 1c             	sub    $0x1c,%esp
80101d49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d4c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d51:	0f 85 85 00 00 00    	jne    80101ddc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d57:	8b 53 58             	mov    0x58(%ebx),%edx
80101d5a:	31 ff                	xor    %edi,%edi
80101d5c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d5f:	85 d2                	test   %edx,%edx
80101d61:	74 3e                	je     80101da1 <dirlookup+0x61>
80101d63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d67:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d68:	6a 10                	push   $0x10
80101d6a:	57                   	push   %edi
80101d6b:	56                   	push   %esi
80101d6c:	53                   	push   %ebx
80101d6d:	e8 7e fd ff ff       	call   80101af0 <readi>
80101d72:	83 c4 10             	add    $0x10,%esp
80101d75:	83 f8 10             	cmp    $0x10,%eax
80101d78:	75 55                	jne    80101dcf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d7f:	74 18                	je     80101d99 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d81:	83 ec 04             	sub    $0x4,%esp
80101d84:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d87:	6a 0e                	push   $0xe
80101d89:	50                   	push   %eax
80101d8a:	ff 75 0c             	push   0xc(%ebp)
80101d8d:	e8 ee 31 00 00       	call   80104f80 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d92:	83 c4 10             	add    $0x10,%esp
80101d95:	85 c0                	test   %eax,%eax
80101d97:	74 17                	je     80101db0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d99:	83 c7 10             	add    $0x10,%edi
80101d9c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d9f:	72 c7                	jb     80101d68 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101da4:	31 c0                	xor    %eax,%eax
}
80101da6:	5b                   	pop    %ebx
80101da7:	5e                   	pop    %esi
80101da8:	5f                   	pop    %edi
80101da9:	5d                   	pop    %ebp
80101daa:	c3                   	ret    
80101dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101daf:	90                   	nop
      if(poff)
80101db0:	8b 45 10             	mov    0x10(%ebp),%eax
80101db3:	85 c0                	test   %eax,%eax
80101db5:	74 05                	je     80101dbc <dirlookup+0x7c>
        *poff = off;
80101db7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dba:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dbc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101dc0:	8b 03                	mov    (%ebx),%eax
80101dc2:	e8 e9 f5 ff ff       	call   801013b0 <iget>
}
80101dc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dca:	5b                   	pop    %ebx
80101dcb:	5e                   	pop    %esi
80101dcc:	5f                   	pop    %edi
80101dcd:	5d                   	pop    %ebp
80101dce:	c3                   	ret    
      panic("dirlookup read");
80101dcf:	83 ec 0c             	sub    $0xc,%esp
80101dd2:	68 2f 7c 10 80       	push   $0x80107c2f
80101dd7:	e8 a4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101ddc:	83 ec 0c             	sub    $0xc,%esp
80101ddf:	68 1d 7c 10 80       	push   $0x80107c1d
80101de4:	e8 97 e5 ff ff       	call   80100380 <panic>
80101de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101df0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	89 c3                	mov    %eax,%ebx
80101df8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dfb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dfe:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e01:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e04:	0f 84 64 01 00 00    	je     80101f6e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e0a:	e8 31 1c 00 00       	call   80103a40 <myproc>
  acquire(&icache.lock);
80101e0f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e12:	8b 70 58             	mov    0x58(%eax),%esi
  acquire(&icache.lock);
80101e15:	68 60 09 11 80       	push   $0x80110960
80101e1a:	e8 91 2f 00 00       	call   80104db0 <acquire>
  ip->ref++;
80101e1f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e23:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101e2a:	e8 21 2f 00 00       	call   80104d50 <release>
80101e2f:	83 c4 10             	add    $0x10,%esp
80101e32:	eb 07                	jmp    80101e3b <namex+0x4b>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	0f b6 03             	movzbl (%ebx),%eax
80101e3e:	3c 2f                	cmp    $0x2f,%al
80101e40:	74 f6                	je     80101e38 <namex+0x48>
  if(*path == 0)
80101e42:	84 c0                	test   %al,%al
80101e44:	0f 84 06 01 00 00    	je     80101f50 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e4a:	0f b6 03             	movzbl (%ebx),%eax
80101e4d:	84 c0                	test   %al,%al
80101e4f:	0f 84 10 01 00 00    	je     80101f65 <namex+0x175>
80101e55:	89 df                	mov    %ebx,%edi
80101e57:	3c 2f                	cmp    $0x2f,%al
80101e59:	0f 84 06 01 00 00    	je     80101f65 <namex+0x175>
80101e5f:	90                   	nop
80101e60:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e64:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e67:	3c 2f                	cmp    $0x2f,%al
80101e69:	74 04                	je     80101e6f <namex+0x7f>
80101e6b:	84 c0                	test   %al,%al
80101e6d:	75 f1                	jne    80101e60 <namex+0x70>
  len = path - s;
80101e6f:	89 f8                	mov    %edi,%eax
80101e71:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e73:	83 f8 0d             	cmp    $0xd,%eax
80101e76:	0f 8e ac 00 00 00    	jle    80101f28 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e7c:	83 ec 04             	sub    $0x4,%esp
80101e7f:	6a 0e                	push   $0xe
80101e81:	53                   	push   %ebx
    path++;
80101e82:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e84:	ff 75 e4             	push   -0x1c(%ebp)
80101e87:	e8 84 30 00 00       	call   80104f10 <memmove>
80101e8c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e8f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e92:	75 0c                	jne    80101ea0 <namex+0xb0>
80101e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e98:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e9b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e9e:	74 f8                	je     80101e98 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ea0:	83 ec 0c             	sub    $0xc,%esp
80101ea3:	56                   	push   %esi
80101ea4:	e8 37 f9 ff ff       	call   801017e0 <ilock>
    if(ip->type != T_DIR){
80101ea9:	83 c4 10             	add    $0x10,%esp
80101eac:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101eb1:	0f 85 cd 00 00 00    	jne    80101f84 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101eb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eba:	85 c0                	test   %eax,%eax
80101ebc:	74 09                	je     80101ec7 <namex+0xd7>
80101ebe:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ec1:	0f 84 22 01 00 00    	je     80101fe9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ec7:	83 ec 04             	sub    $0x4,%esp
80101eca:	6a 00                	push   $0x0
80101ecc:	ff 75 e4             	push   -0x1c(%ebp)
80101ecf:	56                   	push   %esi
80101ed0:	e8 6b fe ff ff       	call   80101d40 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ed5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101ed8:	83 c4 10             	add    $0x10,%esp
80101edb:	89 c7                	mov    %eax,%edi
80101edd:	85 c0                	test   %eax,%eax
80101edf:	0f 84 e1 00 00 00    	je     80101fc6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101eeb:	52                   	push   %edx
80101eec:	e8 9f 2c 00 00       	call   80104b90 <holdingsleep>
80101ef1:	83 c4 10             	add    $0x10,%esp
80101ef4:	85 c0                	test   %eax,%eax
80101ef6:	0f 84 30 01 00 00    	je     8010202c <namex+0x23c>
80101efc:	8b 56 08             	mov    0x8(%esi),%edx
80101eff:	85 d2                	test   %edx,%edx
80101f01:	0f 8e 25 01 00 00    	jle    8010202c <namex+0x23c>
  releasesleep(&ip->lock);
80101f07:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f0a:	83 ec 0c             	sub    $0xc,%esp
80101f0d:	52                   	push   %edx
80101f0e:	e8 3d 2c 00 00       	call   80104b50 <releasesleep>
  iput(ip);
80101f13:	89 34 24             	mov    %esi,(%esp)
80101f16:	89 fe                	mov    %edi,%esi
80101f18:	e8 f3 f9 ff ff       	call   80101910 <iput>
80101f1d:	83 c4 10             	add    $0x10,%esp
80101f20:	e9 16 ff ff ff       	jmp    80101e3b <namex+0x4b>
80101f25:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f28:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f2b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101f2e:	83 ec 04             	sub    $0x4,%esp
80101f31:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f34:	50                   	push   %eax
80101f35:	53                   	push   %ebx
    name[len] = 0;
80101f36:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f38:	ff 75 e4             	push   -0x1c(%ebp)
80101f3b:	e8 d0 2f 00 00       	call   80104f10 <memmove>
    name[len] = 0;
80101f40:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f43:	83 c4 10             	add    $0x10,%esp
80101f46:	c6 02 00             	movb   $0x0,(%edx)
80101f49:	e9 41 ff ff ff       	jmp    80101e8f <namex+0x9f>
80101f4e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f50:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f53:	85 c0                	test   %eax,%eax
80101f55:	0f 85 be 00 00 00    	jne    80102019 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5e:	89 f0                	mov    %esi,%eax
80101f60:	5b                   	pop    %ebx
80101f61:	5e                   	pop    %esi
80101f62:	5f                   	pop    %edi
80101f63:	5d                   	pop    %ebp
80101f64:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f68:	89 df                	mov    %ebx,%edi
80101f6a:	31 c0                	xor    %eax,%eax
80101f6c:	eb c0                	jmp    80101f2e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f6e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f73:	b8 01 00 00 00       	mov    $0x1,%eax
80101f78:	e8 33 f4 ff ff       	call   801013b0 <iget>
80101f7d:	89 c6                	mov    %eax,%esi
80101f7f:	e9 b7 fe ff ff       	jmp    80101e3b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f84:	83 ec 0c             	sub    $0xc,%esp
80101f87:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8a:	53                   	push   %ebx
80101f8b:	e8 00 2c 00 00       	call   80104b90 <holdingsleep>
80101f90:	83 c4 10             	add    $0x10,%esp
80101f93:	85 c0                	test   %eax,%eax
80101f95:	0f 84 91 00 00 00    	je     8010202c <namex+0x23c>
80101f9b:	8b 46 08             	mov    0x8(%esi),%eax
80101f9e:	85 c0                	test   %eax,%eax
80101fa0:	0f 8e 86 00 00 00    	jle    8010202c <namex+0x23c>
  releasesleep(&ip->lock);
80101fa6:	83 ec 0c             	sub    $0xc,%esp
80101fa9:	53                   	push   %ebx
80101faa:	e8 a1 2b 00 00       	call   80104b50 <releasesleep>
  iput(ip);
80101faf:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fb2:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fb4:	e8 57 f9 ff ff       	call   80101910 <iput>
      return 0;
80101fb9:	83 c4 10             	add    $0x10,%esp
}
80101fbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fbf:	89 f0                	mov    %esi,%eax
80101fc1:	5b                   	pop    %ebx
80101fc2:	5e                   	pop    %esi
80101fc3:	5f                   	pop    %edi
80101fc4:	5d                   	pop    %ebp
80101fc5:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fc6:	83 ec 0c             	sub    $0xc,%esp
80101fc9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101fcc:	52                   	push   %edx
80101fcd:	e8 be 2b 00 00       	call   80104b90 <holdingsleep>
80101fd2:	83 c4 10             	add    $0x10,%esp
80101fd5:	85 c0                	test   %eax,%eax
80101fd7:	74 53                	je     8010202c <namex+0x23c>
80101fd9:	8b 4e 08             	mov    0x8(%esi),%ecx
80101fdc:	85 c9                	test   %ecx,%ecx
80101fde:	7e 4c                	jle    8010202c <namex+0x23c>
  releasesleep(&ip->lock);
80101fe0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fe3:	83 ec 0c             	sub    $0xc,%esp
80101fe6:	52                   	push   %edx
80101fe7:	eb c1                	jmp    80101faa <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fe9:	83 ec 0c             	sub    $0xc,%esp
80101fec:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101fef:	53                   	push   %ebx
80101ff0:	e8 9b 2b 00 00       	call   80104b90 <holdingsleep>
80101ff5:	83 c4 10             	add    $0x10,%esp
80101ff8:	85 c0                	test   %eax,%eax
80101ffa:	74 30                	je     8010202c <namex+0x23c>
80101ffc:	8b 7e 08             	mov    0x8(%esi),%edi
80101fff:	85 ff                	test   %edi,%edi
80102001:	7e 29                	jle    8010202c <namex+0x23c>
  releasesleep(&ip->lock);
80102003:	83 ec 0c             	sub    $0xc,%esp
80102006:	53                   	push   %ebx
80102007:	e8 44 2b 00 00       	call   80104b50 <releasesleep>
}
8010200c:	83 c4 10             	add    $0x10,%esp
}
8010200f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102012:	89 f0                	mov    %esi,%eax
80102014:	5b                   	pop    %ebx
80102015:	5e                   	pop    %esi
80102016:	5f                   	pop    %edi
80102017:	5d                   	pop    %ebp
80102018:	c3                   	ret    
    iput(ip);
80102019:	83 ec 0c             	sub    $0xc,%esp
8010201c:	56                   	push   %esi
    return 0;
8010201d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010201f:	e8 ec f8 ff ff       	call   80101910 <iput>
    return 0;
80102024:	83 c4 10             	add    $0x10,%esp
80102027:	e9 2f ff ff ff       	jmp    80101f5b <namex+0x16b>
    panic("iunlock");
8010202c:	83 ec 0c             	sub    $0xc,%esp
8010202f:	68 15 7c 10 80       	push   $0x80107c15
80102034:	e8 47 e3 ff ff       	call   80100380 <panic>
80102039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102040 <dirlink>:
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	57                   	push   %edi
80102044:	56                   	push   %esi
80102045:	53                   	push   %ebx
80102046:	83 ec 20             	sub    $0x20,%esp
80102049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010204c:	6a 00                	push   $0x0
8010204e:	ff 75 0c             	push   0xc(%ebp)
80102051:	53                   	push   %ebx
80102052:	e8 e9 fc ff ff       	call   80101d40 <dirlookup>
80102057:	83 c4 10             	add    $0x10,%esp
8010205a:	85 c0                	test   %eax,%eax
8010205c:	75 67                	jne    801020c5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010205e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102061:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102064:	85 ff                	test   %edi,%edi
80102066:	74 29                	je     80102091 <dirlink+0x51>
80102068:	31 ff                	xor    %edi,%edi
8010206a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010206d:	eb 09                	jmp    80102078 <dirlink+0x38>
8010206f:	90                   	nop
80102070:	83 c7 10             	add    $0x10,%edi
80102073:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102076:	73 19                	jae    80102091 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102078:	6a 10                	push   $0x10
8010207a:	57                   	push   %edi
8010207b:	56                   	push   %esi
8010207c:	53                   	push   %ebx
8010207d:	e8 6e fa ff ff       	call   80101af0 <readi>
80102082:	83 c4 10             	add    $0x10,%esp
80102085:	83 f8 10             	cmp    $0x10,%eax
80102088:	75 4e                	jne    801020d8 <dirlink+0x98>
    if(de.inum == 0)
8010208a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010208f:	75 df                	jne    80102070 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102091:	83 ec 04             	sub    $0x4,%esp
80102094:	8d 45 da             	lea    -0x26(%ebp),%eax
80102097:	6a 0e                	push   $0xe
80102099:	ff 75 0c             	push   0xc(%ebp)
8010209c:	50                   	push   %eax
8010209d:	e8 2e 2f 00 00       	call   80104fd0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020a2:	6a 10                	push   $0x10
  de.inum = inum;
801020a4:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020a7:	57                   	push   %edi
801020a8:	56                   	push   %esi
801020a9:	53                   	push   %ebx
  de.inum = inum;
801020aa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020ae:	e8 3d fb ff ff       	call   80101bf0 <writei>
801020b3:	83 c4 20             	add    $0x20,%esp
801020b6:	83 f8 10             	cmp    $0x10,%eax
801020b9:	75 2a                	jne    801020e5 <dirlink+0xa5>
  return 0;
801020bb:	31 c0                	xor    %eax,%eax
}
801020bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c0:	5b                   	pop    %ebx
801020c1:	5e                   	pop    %esi
801020c2:	5f                   	pop    %edi
801020c3:	5d                   	pop    %ebp
801020c4:	c3                   	ret    
    iput(ip);
801020c5:	83 ec 0c             	sub    $0xc,%esp
801020c8:	50                   	push   %eax
801020c9:	e8 42 f8 ff ff       	call   80101910 <iput>
    return -1;
801020ce:	83 c4 10             	add    $0x10,%esp
801020d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d6:	eb e5                	jmp    801020bd <dirlink+0x7d>
      panic("dirlink read");
801020d8:	83 ec 0c             	sub    $0xc,%esp
801020db:	68 3e 7c 10 80       	push   $0x80107c3e
801020e0:	e8 9b e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020e5:	83 ec 0c             	sub    $0xc,%esp
801020e8:	68 aa 82 10 80       	push   $0x801082aa
801020ed:	e8 8e e2 ff ff       	call   80100380 <panic>
801020f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102100 <namei>:

struct inode*
namei(char *path)
{
80102100:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102101:	31 d2                	xor    %edx,%edx
{
80102103:	89 e5                	mov    %esp,%ebp
80102105:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102108:	8b 45 08             	mov    0x8(%ebp),%eax
8010210b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010210e:	e8 dd fc ff ff       	call   80101df0 <namex>
}
80102113:	c9                   	leave  
80102114:	c3                   	ret    
80102115:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102120:	55                   	push   %ebp
  return namex(path, 1, name);
80102121:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102126:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102128:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010212b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010212e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010212f:	e9 bc fc ff ff       	jmp    80101df0 <namex>
80102134:	66 90                	xchg   %ax,%ax
80102136:	66 90                	xchg   %ax,%ax
80102138:	66 90                	xchg   %ax,%ax
8010213a:	66 90                	xchg   %ax,%ax
8010213c:	66 90                	xchg   %ax,%ax
8010213e:	66 90                	xchg   %ax,%ax

80102140 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	57                   	push   %edi
80102144:	56                   	push   %esi
80102145:	53                   	push   %ebx
80102146:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102149:	85 c0                	test   %eax,%eax
8010214b:	0f 84 b4 00 00 00    	je     80102205 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102151:	8b 70 08             	mov    0x8(%eax),%esi
80102154:	89 c3                	mov    %eax,%ebx
80102156:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010215c:	0f 87 96 00 00 00    	ja     801021f8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102162:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010216e:	66 90                	xchg   %ax,%ax
80102170:	89 ca                	mov    %ecx,%edx
80102172:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102173:	83 e0 c0             	and    $0xffffffc0,%eax
80102176:	3c 40                	cmp    $0x40,%al
80102178:	75 f6                	jne    80102170 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010217a:	31 ff                	xor    %edi,%edi
8010217c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102181:	89 f8                	mov    %edi,%eax
80102183:	ee                   	out    %al,(%dx)
80102184:	b8 01 00 00 00       	mov    $0x1,%eax
80102189:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010218e:	ee                   	out    %al,(%dx)
8010218f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102194:	89 f0                	mov    %esi,%eax
80102196:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102197:	89 f0                	mov    %esi,%eax
80102199:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010219e:	c1 f8 08             	sar    $0x8,%eax
801021a1:	ee                   	out    %al,(%dx)
801021a2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021a7:	89 f8                	mov    %edi,%eax
801021a9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021aa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801021ae:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021b3:	c1 e0 04             	shl    $0x4,%eax
801021b6:	83 e0 10             	and    $0x10,%eax
801021b9:	83 c8 e0             	or     $0xffffffe0,%eax
801021bc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021bd:	f6 03 04             	testb  $0x4,(%ebx)
801021c0:	75 16                	jne    801021d8 <idestart+0x98>
801021c2:	b8 20 00 00 00       	mov    $0x20,%eax
801021c7:	89 ca                	mov    %ecx,%edx
801021c9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021cd:	5b                   	pop    %ebx
801021ce:	5e                   	pop    %esi
801021cf:	5f                   	pop    %edi
801021d0:	5d                   	pop    %ebp
801021d1:	c3                   	ret    
801021d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021d8:	b8 30 00 00 00       	mov    $0x30,%eax
801021dd:	89 ca                	mov    %ecx,%edx
801021df:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021e0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021e8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ed:	fc                   	cld    
801021ee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021f3:	5b                   	pop    %ebx
801021f4:	5e                   	pop    %esi
801021f5:	5f                   	pop    %edi
801021f6:	5d                   	pop    %ebp
801021f7:	c3                   	ret    
    panic("incorrect blockno");
801021f8:	83 ec 0c             	sub    $0xc,%esp
801021fb:	68 a8 7c 10 80       	push   $0x80107ca8
80102200:	e8 7b e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102205:	83 ec 0c             	sub    $0xc,%esp
80102208:	68 9f 7c 10 80       	push   $0x80107c9f
8010220d:	e8 6e e1 ff ff       	call   80100380 <panic>
80102212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102220 <ideinit>:
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102226:	68 ba 7c 10 80       	push   $0x80107cba
8010222b:	68 00 26 11 80       	push   $0x80112600
80102230:	e8 ab 29 00 00       	call   80104be0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102235:	58                   	pop    %eax
80102236:	a1 84 27 11 80       	mov    0x80112784,%eax
8010223b:	5a                   	pop    %edx
8010223c:	83 e8 01             	sub    $0x1,%eax
8010223f:	50                   	push   %eax
80102240:	6a 0e                	push   $0xe
80102242:	e8 99 02 00 00       	call   801024e0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102247:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010224a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010224f:	90                   	nop
80102250:	ec                   	in     (%dx),%al
80102251:	83 e0 c0             	and    $0xffffffc0,%eax
80102254:	3c 40                	cmp    $0x40,%al
80102256:	75 f8                	jne    80102250 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102258:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010225d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102262:	ee                   	out    %al,(%dx)
80102263:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102268:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010226d:	eb 06                	jmp    80102275 <ideinit+0x55>
8010226f:	90                   	nop
  for(i=0; i<1000; i++){
80102270:	83 e9 01             	sub    $0x1,%ecx
80102273:	74 0f                	je     80102284 <ideinit+0x64>
80102275:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102276:	84 c0                	test   %al,%al
80102278:	74 f6                	je     80102270 <ideinit+0x50>
      havedisk1 = 1;
8010227a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102281:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102284:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102289:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010228e:	ee                   	out    %al,(%dx)
}
8010228f:	c9                   	leave  
80102290:	c3                   	ret    
80102291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010229f:	90                   	nop

801022a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	57                   	push   %edi
801022a4:	56                   	push   %esi
801022a5:	53                   	push   %ebx
801022a6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022a9:	68 00 26 11 80       	push   $0x80112600
801022ae:	e8 fd 2a 00 00       	call   80104db0 <acquire>

  if((b = idequeue) == 0){
801022b3:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
801022b9:	83 c4 10             	add    $0x10,%esp
801022bc:	85 db                	test   %ebx,%ebx
801022be:	74 63                	je     80102323 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022c0:	8b 43 58             	mov    0x58(%ebx),%eax
801022c3:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022c8:	8b 33                	mov    (%ebx),%esi
801022ca:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022d0:	75 2f                	jne    80102301 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022d2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022de:	66 90                	xchg   %ax,%ax
801022e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022e1:	89 c1                	mov    %eax,%ecx
801022e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022e6:	80 f9 40             	cmp    $0x40,%cl
801022e9:	75 f5                	jne    801022e0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022eb:	a8 21                	test   $0x21,%al
801022ed:	75 12                	jne    80102301 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022fc:	fc                   	cld    
801022fd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022ff:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102301:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102304:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102307:	83 ce 02             	or     $0x2,%esi
8010230a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010230c:	53                   	push   %ebx
8010230d:	e8 ce 20 00 00       	call   801043e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102312:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80102317:	83 c4 10             	add    $0x10,%esp
8010231a:	85 c0                	test   %eax,%eax
8010231c:	74 05                	je     80102323 <ideintr+0x83>
    idestart(idequeue);
8010231e:	e8 1d fe ff ff       	call   80102140 <idestart>
    release(&idelock);
80102323:	83 ec 0c             	sub    $0xc,%esp
80102326:	68 00 26 11 80       	push   $0x80112600
8010232b:	e8 20 2a 00 00       	call   80104d50 <release>

  release(&idelock);
}
80102330:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102333:	5b                   	pop    %ebx
80102334:	5e                   	pop    %esi
80102335:	5f                   	pop    %edi
80102336:	5d                   	pop    %ebp
80102337:	c3                   	ret    
80102338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop

80102340 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	53                   	push   %ebx
80102344:	83 ec 10             	sub    $0x10,%esp
80102347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010234a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010234d:	50                   	push   %eax
8010234e:	e8 3d 28 00 00       	call   80104b90 <holdingsleep>
80102353:	83 c4 10             	add    $0x10,%esp
80102356:	85 c0                	test   %eax,%eax
80102358:	0f 84 c3 00 00 00    	je     80102421 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 e0 06             	and    $0x6,%eax
80102363:	83 f8 02             	cmp    $0x2,%eax
80102366:	0f 84 a8 00 00 00    	je     80102414 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010236c:	8b 53 04             	mov    0x4(%ebx),%edx
8010236f:	85 d2                	test   %edx,%edx
80102371:	74 0d                	je     80102380 <iderw+0x40>
80102373:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102378:	85 c0                	test   %eax,%eax
8010237a:	0f 84 87 00 00 00    	je     80102407 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 00 26 11 80       	push   $0x80112600
80102388:	e8 23 2a 00 00       	call   80104db0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010238d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102392:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102399:	83 c4 10             	add    $0x10,%esp
8010239c:	85 c0                	test   %eax,%eax
8010239e:	74 60                	je     80102400 <iderw+0xc0>
801023a0:	89 c2                	mov    %eax,%edx
801023a2:	8b 40 58             	mov    0x58(%eax),%eax
801023a5:	85 c0                	test   %eax,%eax
801023a7:	75 f7                	jne    801023a0 <iderw+0x60>
801023a9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023ac:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023ae:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
801023b4:	74 3a                	je     801023f0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023b6:	8b 03                	mov    (%ebx),%eax
801023b8:	83 e0 06             	and    $0x6,%eax
801023bb:	83 f8 02             	cmp    $0x2,%eax
801023be:	74 1b                	je     801023db <iderw+0x9b>
    sleep(b, &idelock);
801023c0:	83 ec 08             	sub    $0x8,%esp
801023c3:	68 00 26 11 80       	push   $0x80112600
801023c8:	53                   	push   %ebx
801023c9:	e8 12 1f 00 00       	call   801042e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023ce:	8b 03                	mov    (%ebx),%eax
801023d0:	83 c4 10             	add    $0x10,%esp
801023d3:	83 e0 06             	and    $0x6,%eax
801023d6:	83 f8 02             	cmp    $0x2,%eax
801023d9:	75 e5                	jne    801023c0 <iderw+0x80>
  }


  release(&idelock);
801023db:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
801023e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023e5:	c9                   	leave  
  release(&idelock);
801023e6:	e9 65 29 00 00       	jmp    80104d50 <release>
801023eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023ef:	90                   	nop
    idestart(b);
801023f0:	89 d8                	mov    %ebx,%eax
801023f2:	e8 49 fd ff ff       	call   80102140 <idestart>
801023f7:	eb bd                	jmp    801023b6 <iderw+0x76>
801023f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102400:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102405:	eb a5                	jmp    801023ac <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102407:	83 ec 0c             	sub    $0xc,%esp
8010240a:	68 e9 7c 10 80       	push   $0x80107ce9
8010240f:	e8 6c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102414:	83 ec 0c             	sub    $0xc,%esp
80102417:	68 d4 7c 10 80       	push   $0x80107cd4
8010241c:	e8 5f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102421:	83 ec 0c             	sub    $0xc,%esp
80102424:	68 be 7c 10 80       	push   $0x80107cbe
80102429:	e8 52 df ff ff       	call   80100380 <panic>
8010242e:	66 90                	xchg   %ax,%ax

80102430 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102430:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102431:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102438:	00 c0 fe 
{
8010243b:	89 e5                	mov    %esp,%ebp
8010243d:	56                   	push   %esi
8010243e:	53                   	push   %ebx
  ioapic->reg = reg;
8010243f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102446:	00 00 00 
  return ioapic->data;
80102449:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010244f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102452:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102458:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010245e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102465:	c1 ee 10             	shr    $0x10,%esi
80102468:	89 f0                	mov    %esi,%eax
8010246a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010246d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102470:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102473:	39 c2                	cmp    %eax,%edx
80102475:	74 16                	je     8010248d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102477:	83 ec 0c             	sub    $0xc,%esp
8010247a:	68 08 7d 10 80       	push   $0x80107d08
8010247f:	e8 1c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102484:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010248a:	83 c4 10             	add    $0x10,%esp
8010248d:	83 c6 21             	add    $0x21,%esi
{
80102490:	ba 10 00 00 00       	mov    $0x10,%edx
80102495:	b8 20 00 00 00       	mov    $0x20,%eax
8010249a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
801024a0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801024a2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801024a4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
801024aa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801024ad:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801024b3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801024b6:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
801024b9:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801024bc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801024be:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801024c4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801024cb:	39 f0                	cmp    %esi,%eax
801024cd:	75 d1                	jne    801024a0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024d2:	5b                   	pop    %ebx
801024d3:	5e                   	pop    %esi
801024d4:	5d                   	pop    %ebp
801024d5:	c3                   	ret    
801024d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024dd:	8d 76 00             	lea    0x0(%esi),%esi

801024e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024e0:	55                   	push   %ebp
  ioapic->reg = reg;
801024e1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801024e7:	89 e5                	mov    %esp,%ebp
801024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024ec:	8d 50 20             	lea    0x20(%eax),%edx
801024ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024f5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102501:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102504:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102506:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010250b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010250e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102511:	5d                   	pop    %ebp
80102512:	c3                   	ret    
80102513:	66 90                	xchg   %ax,%ax
80102515:	66 90                	xchg   %ax,%ax
80102517:	66 90                	xchg   %ax,%ax
80102519:	66 90                	xchg   %ax,%ax
8010251b:	66 90                	xchg   %ax,%ax
8010251d:	66 90                	xchg   %ax,%ax
8010251f:	90                   	nop

80102520 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	53                   	push   %ebx
80102524:	83 ec 04             	sub    $0x4,%esp
80102527:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010252a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102530:	75 76                	jne    801025a8 <kfree+0x88>
80102532:	81 fb d0 61 13 80    	cmp    $0x801361d0,%ebx
80102538:	72 6e                	jb     801025a8 <kfree+0x88>
8010253a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102540:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102545:	77 61                	ja     801025a8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102547:	83 ec 04             	sub    $0x4,%esp
8010254a:	68 00 10 00 00       	push   $0x1000
8010254f:	6a 01                	push   $0x1
80102551:	53                   	push   %ebx
80102552:	e8 19 29 00 00       	call   80104e70 <memset>

  if(kmem.use_lock)
80102557:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	85 d2                	test   %edx,%edx
80102562:	75 1c                	jne    80102580 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102564:	a1 78 26 11 80       	mov    0x80112678,%eax
80102569:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010256b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102570:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102576:	85 c0                	test   %eax,%eax
80102578:	75 1e                	jne    80102598 <kfree+0x78>
    release(&kmem.lock);
}
8010257a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010257d:	c9                   	leave  
8010257e:	c3                   	ret    
8010257f:	90                   	nop
    acquire(&kmem.lock);
80102580:	83 ec 0c             	sub    $0xc,%esp
80102583:	68 40 26 11 80       	push   $0x80112640
80102588:	e8 23 28 00 00       	call   80104db0 <acquire>
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	eb d2                	jmp    80102564 <kfree+0x44>
80102592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102598:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010259f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025a2:	c9                   	leave  
    release(&kmem.lock);
801025a3:	e9 a8 27 00 00       	jmp    80104d50 <release>
    panic("kfree");
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	68 3a 7d 10 80       	push   $0x80107d3a
801025b0:	e8 cb dd ff ff       	call   80100380 <panic>
801025b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025c0 <freerange>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025c4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ca:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <freerange+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 23 ff ff ff       	call   80102520 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 f3                	cmp    %esi,%ebx
80102602:	76 e4                	jbe    801025e8 <freerange+0x28>
}
80102604:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102607:	5b                   	pop    %ebx
80102608:	5e                   	pop    %esi
80102609:	5d                   	pop    %ebp
8010260a:	c3                   	ret    
8010260b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010260f:	90                   	nop

80102610 <kinit2>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102614:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102617:	8b 75 0c             	mov    0xc(%ebp),%esi
8010261a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010261b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102621:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102627:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262d:	39 de                	cmp    %ebx,%esi
8010262f:	72 23                	jb     80102654 <kinit2+0x44>
80102631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102638:	83 ec 0c             	sub    $0xc,%esp
8010263b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102641:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102647:	50                   	push   %eax
80102648:	e8 d3 fe ff ff       	call   80102520 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
80102650:	39 de                	cmp    %ebx,%esi
80102652:	73 e4                	jae    80102638 <kinit2+0x28>
  kmem.use_lock = 1;
80102654:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010265b:	00 00 00 
}
8010265e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102661:	5b                   	pop    %ebx
80102662:	5e                   	pop    %esi
80102663:	5d                   	pop    %ebp
80102664:	c3                   	ret    
80102665:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102670 <kinit1>:
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	56                   	push   %esi
80102674:	53                   	push   %ebx
80102675:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102678:	83 ec 08             	sub    $0x8,%esp
8010267b:	68 40 7d 10 80       	push   $0x80107d40
80102680:	68 40 26 11 80       	push   $0x80112640
80102685:	e8 56 25 00 00       	call   80104be0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010268a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010268d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102690:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102697:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010269a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026ac:	39 de                	cmp    %ebx,%esi
801026ae:	72 1c                	jb     801026cc <kinit1+0x5c>
    kfree(p);
801026b0:	83 ec 0c             	sub    $0xc,%esp
801026b3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026bf:	50                   	push   %eax
801026c0:	e8 5b fe ff ff       	call   80102520 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c5:	83 c4 10             	add    $0x10,%esp
801026c8:	39 de                	cmp    %ebx,%esi
801026ca:	73 e4                	jae    801026b0 <kinit1+0x40>
}
801026cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026cf:	5b                   	pop    %ebx
801026d0:	5e                   	pop    %esi
801026d1:	5d                   	pop    %ebp
801026d2:	c3                   	ret    
801026d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026e0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801026e0:	a1 74 26 11 80       	mov    0x80112674,%eax
801026e5:	85 c0                	test   %eax,%eax
801026e7:	75 1f                	jne    80102708 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026e9:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801026ee:	85 c0                	test   %eax,%eax
801026f0:	74 0e                	je     80102700 <kalloc+0x20>
    kmem.freelist = r->next;
801026f2:	8b 10                	mov    (%eax),%edx
801026f4:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801026fa:	c3                   	ret    
801026fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026ff:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102700:	c3                   	ret    
80102701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102708:	55                   	push   %ebp
80102709:	89 e5                	mov    %esp,%ebp
8010270b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010270e:	68 40 26 11 80       	push   $0x80112640
80102713:	e8 98 26 00 00       	call   80104db0 <acquire>
  r = kmem.freelist;
80102718:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
8010271d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
80102723:	83 c4 10             	add    $0x10,%esp
80102726:	85 c0                	test   %eax,%eax
80102728:	74 08                	je     80102732 <kalloc+0x52>
    kmem.freelist = r->next;
8010272a:	8b 08                	mov    (%eax),%ecx
8010272c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102732:	85 d2                	test   %edx,%edx
80102734:	74 16                	je     8010274c <kalloc+0x6c>
    release(&kmem.lock);
80102736:	83 ec 0c             	sub    $0xc,%esp
80102739:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010273c:	68 40 26 11 80       	push   $0x80112640
80102741:	e8 0a 26 00 00       	call   80104d50 <release>
  return (char*)r;
80102746:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102749:	83 c4 10             	add    $0x10,%esp
}
8010274c:	c9                   	leave  
8010274d:	c3                   	ret    
8010274e:	66 90                	xchg   %ax,%ax

80102750 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102750:	ba 64 00 00 00       	mov    $0x64,%edx
80102755:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102756:	a8 01                	test   $0x1,%al
80102758:	0f 84 c2 00 00 00    	je     80102820 <kbdgetc+0xd0>
{
8010275e:	55                   	push   %ebp
8010275f:	ba 60 00 00 00       	mov    $0x60,%edx
80102764:	89 e5                	mov    %esp,%ebp
80102766:	53                   	push   %ebx
80102767:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102768:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010276e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102771:	3c e0                	cmp    $0xe0,%al
80102773:	74 5b                	je     801027d0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102775:	89 da                	mov    %ebx,%edx
80102777:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010277a:	84 c0                	test   %al,%al
8010277c:	78 62                	js     801027e0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010277e:	85 d2                	test   %edx,%edx
80102780:	74 09                	je     8010278b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102782:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102785:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102788:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010278b:	0f b6 91 80 7e 10 80 	movzbl -0x7fef8180(%ecx),%edx
  shift ^= togglecode[data];
80102792:	0f b6 81 80 7d 10 80 	movzbl -0x7fef8280(%ecx),%eax
  shift |= shiftcode[data];
80102799:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010279b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010279d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010279f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
801027a5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027a8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027ab:	8b 04 85 60 7d 10 80 	mov    -0x7fef82a0(,%eax,4),%eax
801027b2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801027b6:	74 0b                	je     801027c3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801027b8:	8d 50 9f             	lea    -0x61(%eax),%edx
801027bb:	83 fa 19             	cmp    $0x19,%edx
801027be:	77 48                	ja     80102808 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027c0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027c6:	c9                   	leave  
801027c7:	c3                   	ret    
801027c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cf:	90                   	nop
    shift |= E0ESC;
801027d0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801027d3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027d5:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
801027db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027de:	c9                   	leave  
801027df:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801027e0:	83 e0 7f             	and    $0x7f,%eax
801027e3:	85 d2                	test   %edx,%edx
801027e5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027e8:	0f b6 81 80 7e 10 80 	movzbl -0x7fef8180(%ecx),%eax
801027ef:	83 c8 40             	or     $0x40,%eax
801027f2:	0f b6 c0             	movzbl %al,%eax
801027f5:	f7 d0                	not    %eax
801027f7:	21 d8                	and    %ebx,%eax
}
801027f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801027fc:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
80102801:	31 c0                	xor    %eax,%eax
}
80102803:	c9                   	leave  
80102804:	c3                   	ret    
80102805:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102808:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010280b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010280e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102811:	c9                   	leave  
      c += 'a' - 'A';
80102812:	83 f9 1a             	cmp    $0x1a,%ecx
80102815:	0f 42 c2             	cmovb  %edx,%eax
}
80102818:	c3                   	ret    
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102825:	c3                   	ret    
80102826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010282d:	8d 76 00             	lea    0x0(%esi),%esi

80102830 <kbdintr>:

void
kbdintr(void)
{
80102830:	55                   	push   %ebp
80102831:	89 e5                	mov    %esp,%ebp
80102833:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102836:	68 50 27 10 80       	push   $0x80102750
8010283b:	e8 40 e0 ff ff       	call   80100880 <consoleintr>
}
80102840:	83 c4 10             	add    $0x10,%esp
80102843:	c9                   	leave  
80102844:	c3                   	ret    
80102845:	66 90                	xchg   %ax,%ax
80102847:	66 90                	xchg   %ax,%ax
80102849:	66 90                	xchg   %ax,%ax
8010284b:	66 90                	xchg   %ax,%ax
8010284d:	66 90                	xchg   %ax,%ax
8010284f:	90                   	nop

80102850 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102850:	a1 80 26 11 80       	mov    0x80112680,%eax
80102855:	85 c0                	test   %eax,%eax
80102857:	0f 84 cb 00 00 00    	je     80102928 <lapicinit+0xd8>
  lapic[index] = value;
8010285d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102864:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102867:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102871:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102874:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102877:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010287e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102881:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102884:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010288b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010288e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102891:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102898:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028a5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028a8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028ab:	8b 50 30             	mov    0x30(%eax),%edx
801028ae:	c1 ea 10             	shr    $0x10,%edx
801028b1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801028b7:	75 77                	jne    80102930 <lapicinit+0xe0>
  lapic[index] = value;
801028b9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028c0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028cd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028dd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ed:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028fa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102901:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102904:	8b 50 20             	mov    0x20(%eax),%edx
80102907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102910:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102916:	80 e6 10             	and    $0x10,%dh
80102919:	75 f5                	jne    80102910 <lapicinit+0xc0>
  lapic[index] = value;
8010291b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102922:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102925:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102928:	c3                   	ret    
80102929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102930:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102937:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010293a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010293d:	e9 77 ff ff ff       	jmp    801028b9 <lapicinit+0x69>
80102942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102950 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102950:	a1 80 26 11 80       	mov    0x80112680,%eax
80102955:	85 c0                	test   %eax,%eax
80102957:	74 07                	je     80102960 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102959:	8b 40 20             	mov    0x20(%eax),%eax
8010295c:	c1 e8 18             	shr    $0x18,%eax
8010295f:	c3                   	ret    
    return 0;
80102960:	31 c0                	xor    %eax,%eax
}
80102962:	c3                   	ret    
80102963:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010296a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102970 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102970:	a1 80 26 11 80       	mov    0x80112680,%eax
80102975:	85 c0                	test   %eax,%eax
80102977:	74 0d                	je     80102986 <lapiceoi+0x16>
  lapic[index] = value;
80102979:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102980:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102983:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102986:	c3                   	ret    
80102987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298e:	66 90                	xchg   %ax,%ax

80102990 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102990:	c3                   	ret    
80102991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299f:	90                   	nop

801029a0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029a6:	ba 70 00 00 00       	mov    $0x70,%edx
801029ab:	89 e5                	mov    %esp,%ebp
801029ad:	53                   	push   %ebx
801029ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029b4:	ee                   	out    %al,(%dx)
801029b5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029ba:	ba 71 00 00 00       	mov    $0x71,%edx
801029bf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029c0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801029c2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029c5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029cb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029cd:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801029d0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801029d2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801029d5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029d8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029de:	a1 80 26 11 80       	mov    0x80112680,%eax
801029e3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029e9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029f3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029f9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a00:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a03:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a06:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a0c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a0f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a15:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a18:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a1e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a21:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a27:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a2d:	c9                   	leave  
80102a2e:	c3                   	ret    
80102a2f:	90                   	nop

80102a30 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a30:	55                   	push   %ebp
80102a31:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a36:	ba 70 00 00 00       	mov    $0x70,%edx
80102a3b:	89 e5                	mov    %esp,%ebp
80102a3d:	57                   	push   %edi
80102a3e:	56                   	push   %esi
80102a3f:	53                   	push   %ebx
80102a40:	83 ec 4c             	sub    $0x4c,%esp
80102a43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a44:	ba 71 00 00 00       	mov    $0x71,%edx
80102a49:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a4a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a52:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a55:	8d 76 00             	lea    0x0(%esi),%esi
80102a58:	31 c0                	xor    %eax,%eax
80102a5a:	89 da                	mov    %ebx,%edx
80102a5c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a62:	89 ca                	mov    %ecx,%edx
80102a64:	ec                   	in     (%dx),%al
80102a65:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a68:	89 da                	mov    %ebx,%edx
80102a6a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a6f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a70:	89 ca                	mov    %ecx,%edx
80102a72:	ec                   	in     (%dx),%al
80102a73:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a76:	89 da                	mov    %ebx,%edx
80102a78:	b8 04 00 00 00       	mov    $0x4,%eax
80102a7d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7e:	89 ca                	mov    %ecx,%edx
80102a80:	ec                   	in     (%dx),%al
80102a81:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a84:	89 da                	mov    %ebx,%edx
80102a86:	b8 07 00 00 00       	mov    $0x7,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	b8 08 00 00 00       	mov    $0x8,%eax
80102a99:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9a:	89 ca                	mov    %ecx,%edx
80102a9c:	ec                   	in     (%dx),%al
80102a9d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9f:	89 da                	mov    %ebx,%edx
80102aa1:	b8 09 00 00 00       	mov    $0x9,%eax
80102aa6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa7:	89 ca                	mov    %ecx,%edx
80102aa9:	ec                   	in     (%dx),%al
80102aaa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aac:	89 da                	mov    %ebx,%edx
80102aae:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ab3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab4:	89 ca                	mov    %ecx,%edx
80102ab6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ab7:	84 c0                	test   %al,%al
80102ab9:	78 9d                	js     80102a58 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102abb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102abf:	89 fa                	mov    %edi,%edx
80102ac1:	0f b6 fa             	movzbl %dl,%edi
80102ac4:	89 f2                	mov    %esi,%edx
80102ac6:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ac9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102acd:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad0:	89 da                	mov    %ebx,%edx
80102ad2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102ad5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ad8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102adc:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102adf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ae2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ae6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ae9:	31 c0                	xor    %eax,%eax
80102aeb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aec:	89 ca                	mov    %ecx,%edx
80102aee:	ec                   	in     (%dx),%al
80102aef:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af2:	89 da                	mov    %ebx,%edx
80102af4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102af7:	b8 02 00 00 00       	mov    $0x2,%eax
80102afc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afd:	89 ca                	mov    %ecx,%edx
80102aff:	ec                   	in     (%dx),%al
80102b00:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b03:	89 da                	mov    %ebx,%edx
80102b05:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b08:	b8 04 00 00 00       	mov    $0x4,%eax
80102b0d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0e:	89 ca                	mov    %ecx,%edx
80102b10:	ec                   	in     (%dx),%al
80102b11:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b14:	89 da                	mov    %ebx,%edx
80102b16:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b19:	b8 07 00 00 00       	mov    $0x7,%eax
80102b1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1f:	89 ca                	mov    %ecx,%edx
80102b21:	ec                   	in     (%dx),%al
80102b22:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b25:	89 da                	mov    %ebx,%edx
80102b27:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b2a:	b8 08 00 00 00       	mov    $0x8,%eax
80102b2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b30:	89 ca                	mov    %ecx,%edx
80102b32:	ec                   	in     (%dx),%al
80102b33:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b36:	89 da                	mov    %ebx,%edx
80102b38:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b3b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b40:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b41:	89 ca                	mov    %ecx,%edx
80102b43:	ec                   	in     (%dx),%al
80102b44:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b47:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b4d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b50:	6a 18                	push   $0x18
80102b52:	50                   	push   %eax
80102b53:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b56:	50                   	push   %eax
80102b57:	e8 64 23 00 00       	call   80104ec0 <memcmp>
80102b5c:	83 c4 10             	add    $0x10,%esp
80102b5f:	85 c0                	test   %eax,%eax
80102b61:	0f 85 f1 fe ff ff    	jne    80102a58 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b67:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b6b:	75 78                	jne    80102be5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b6d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b70:	89 c2                	mov    %eax,%edx
80102b72:	83 e0 0f             	and    $0xf,%eax
80102b75:	c1 ea 04             	shr    $0x4,%edx
80102b78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b81:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b84:	89 c2                	mov    %eax,%edx
80102b86:	83 e0 0f             	and    $0xf,%eax
80102b89:	c1 ea 04             	shr    $0x4,%edx
80102b8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b92:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b95:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b98:	89 c2                	mov    %eax,%edx
80102b9a:	83 e0 0f             	and    $0xf,%eax
80102b9d:	c1 ea 04             	shr    $0x4,%edx
80102ba0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ba3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ba6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ba9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bac:	89 c2                	mov    %eax,%edx
80102bae:	83 e0 0f             	and    $0xf,%eax
80102bb1:	c1 ea 04             	shr    $0x4,%edx
80102bb4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bb7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bbd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bc0:	89 c2                	mov    %eax,%edx
80102bc2:	83 e0 0f             	and    $0xf,%eax
80102bc5:	c1 ea 04             	shr    $0x4,%edx
80102bc8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bcb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bce:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102bd1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bd4:	89 c2                	mov    %eax,%edx
80102bd6:	83 e0 0f             	and    $0xf,%eax
80102bd9:	c1 ea 04             	shr    $0x4,%edx
80102bdc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bdf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102be2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102be5:	8b 75 08             	mov    0x8(%ebp),%esi
80102be8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102beb:	89 06                	mov    %eax,(%esi)
80102bed:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bf0:	89 46 04             	mov    %eax,0x4(%esi)
80102bf3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bf6:	89 46 08             	mov    %eax,0x8(%esi)
80102bf9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bfc:	89 46 0c             	mov    %eax,0xc(%esi)
80102bff:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c02:	89 46 10             	mov    %eax,0x10(%esi)
80102c05:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c08:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c0b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102c12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c15:	5b                   	pop    %ebx
80102c16:	5e                   	pop    %esi
80102c17:	5f                   	pop    %edi
80102c18:	5d                   	pop    %ebp
80102c19:	c3                   	ret    
80102c1a:	66 90                	xchg   %ax,%ax
80102c1c:	66 90                	xchg   %ax,%ax
80102c1e:	66 90                	xchg   %ax,%ax

80102c20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c20:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102c26:	85 c9                	test   %ecx,%ecx
80102c28:	0f 8e 8a 00 00 00    	jle    80102cb8 <install_trans+0x98>
{
80102c2e:	55                   	push   %ebp
80102c2f:	89 e5                	mov    %esp,%ebp
80102c31:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c32:	31 ff                	xor    %edi,%edi
{
80102c34:	56                   	push   %esi
80102c35:	53                   	push   %ebx
80102c36:	83 ec 0c             	sub    $0xc,%esp
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c40:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c45:	83 ec 08             	sub    $0x8,%esp
80102c48:	01 f8                	add    %edi,%eax
80102c4a:	83 c0 01             	add    $0x1,%eax
80102c4d:	50                   	push   %eax
80102c4e:	ff 35 e4 26 11 80    	push   0x801126e4
80102c54:	e8 77 d4 ff ff       	call   801000d0 <bread>
80102c59:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c5b:	58                   	pop    %eax
80102c5c:	5a                   	pop    %edx
80102c5d:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c64:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c6a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c6d:	e8 5e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c72:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c75:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c77:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c7a:	68 00 02 00 00       	push   $0x200
80102c7f:	50                   	push   %eax
80102c80:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c83:	50                   	push   %eax
80102c84:	e8 87 22 00 00       	call   80104f10 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c89:	89 1c 24             	mov    %ebx,(%esp)
80102c8c:	e8 1f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c91:	89 34 24             	mov    %esi,(%esp)
80102c94:	e8 57 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c99:	89 1c 24             	mov    %ebx,(%esp)
80102c9c:	e8 4f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ca1:	83 c4 10             	add    $0x10,%esp
80102ca4:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102caa:	7f 94                	jg     80102c40 <install_trans+0x20>
  }
}
80102cac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102caf:	5b                   	pop    %ebx
80102cb0:	5e                   	pop    %esi
80102cb1:	5f                   	pop    %edi
80102cb2:	5d                   	pop    %ebp
80102cb3:	c3                   	ret    
80102cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cb8:	c3                   	ret    
80102cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cc0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cc7:	ff 35 d4 26 11 80    	push   0x801126d4
80102ccd:	ff 35 e4 26 11 80    	push   0x801126e4
80102cd3:	e8 f8 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102cd8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cdb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102cdd:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102ce2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	85 c0                	test   %eax,%eax
80102ce7:	7e 19                	jle    80102d02 <write_head+0x42>
80102ce9:	31 d2                	xor    %edx,%edx
80102ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cef:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102cf0:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102cf7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cfb:	83 c2 01             	add    $0x1,%edx
80102cfe:	39 d0                	cmp    %edx,%eax
80102d00:	75 ee                	jne    80102cf0 <write_head+0x30>
  }
  bwrite(buf);
80102d02:	83 ec 0c             	sub    $0xc,%esp
80102d05:	53                   	push   %ebx
80102d06:	e8 a5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d0b:	89 1c 24             	mov    %ebx,(%esp)
80102d0e:	e8 dd d4 ff ff       	call   801001f0 <brelse>
}
80102d13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d16:	83 c4 10             	add    $0x10,%esp
80102d19:	c9                   	leave  
80102d1a:	c3                   	ret    
80102d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d1f:	90                   	nop

80102d20 <initlog>:
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 2c             	sub    $0x2c,%esp
80102d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d2a:	68 80 7f 10 80       	push   $0x80107f80
80102d2f:	68 a0 26 11 80       	push   $0x801126a0
80102d34:	e8 a7 1e 00 00       	call   80104be0 <initlock>
  readsb(dev, &sb);
80102d39:	58                   	pop    %eax
80102d3a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d3d:	5a                   	pop    %edx
80102d3e:	50                   	push   %eax
80102d3f:	53                   	push   %ebx
80102d40:	e8 3b e8 ff ff       	call   80101580 <readsb>
  log.start = sb.logstart;
80102d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d48:	59                   	pop    %ecx
  log.dev = dev;
80102d49:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102d4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d52:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102d57:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102d5d:	5a                   	pop    %edx
80102d5e:	50                   	push   %eax
80102d5f:	53                   	push   %ebx
80102d60:	e8 6b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d65:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d68:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d6b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d71:	85 db                	test   %ebx,%ebx
80102d73:	7e 1d                	jle    80102d92 <initlog+0x72>
80102d75:	31 d2                	xor    %edx,%edx
80102d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d7e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d80:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d84:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d8b:	83 c2 01             	add    $0x1,%edx
80102d8e:	39 d3                	cmp    %edx,%ebx
80102d90:	75 ee                	jne    80102d80 <initlog+0x60>
  brelse(buf);
80102d92:	83 ec 0c             	sub    $0xc,%esp
80102d95:	50                   	push   %eax
80102d96:	e8 55 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d9b:	e8 80 fe ff ff       	call   80102c20 <install_trans>
  log.lh.n = 0;
80102da0:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102da7:	00 00 00 
  write_head(); // clear the log
80102daa:	e8 11 ff ff ff       	call   80102cc0 <write_head>
}
80102daf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102db2:	83 c4 10             	add    $0x10,%esp
80102db5:	c9                   	leave  
80102db6:	c3                   	ret    
80102db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dbe:	66 90                	xchg   %ax,%ax

80102dc0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102dc6:	68 a0 26 11 80       	push   $0x801126a0
80102dcb:	e8 e0 1f 00 00       	call   80104db0 <acquire>
80102dd0:	83 c4 10             	add    $0x10,%esp
80102dd3:	eb 18                	jmp    80102ded <begin_op+0x2d>
80102dd5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102dd8:	83 ec 08             	sub    $0x8,%esp
80102ddb:	68 a0 26 11 80       	push   $0x801126a0
80102de0:	68 a0 26 11 80       	push   $0x801126a0
80102de5:	e8 f6 14 00 00       	call   801042e0 <sleep>
80102dea:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102ded:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102df2:	85 c0                	test   %eax,%eax
80102df4:	75 e2                	jne    80102dd8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102df6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102dfb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102e01:	83 c0 01             	add    $0x1,%eax
80102e04:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e07:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e0a:	83 fa 1e             	cmp    $0x1e,%edx
80102e0d:	7f c9                	jg     80102dd8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e0f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e12:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102e17:	68 a0 26 11 80       	push   $0x801126a0
80102e1c:	e8 2f 1f 00 00       	call   80104d50 <release>
      break;
    }
  }
}
80102e21:	83 c4 10             	add    $0x10,%esp
80102e24:	c9                   	leave  
80102e25:	c3                   	ret    
80102e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e2d:	8d 76 00             	lea    0x0(%esi),%esi

80102e30 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	57                   	push   %edi
80102e34:	56                   	push   %esi
80102e35:	53                   	push   %ebx
80102e36:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e39:	68 a0 26 11 80       	push   $0x801126a0
80102e3e:	e8 6d 1f 00 00       	call   80104db0 <acquire>
  log.outstanding -= 1;
80102e43:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102e48:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102e4e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e51:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e54:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102e5a:	85 f6                	test   %esi,%esi
80102e5c:	0f 85 22 01 00 00    	jne    80102f84 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e62:	85 db                	test   %ebx,%ebx
80102e64:	0f 85 f6 00 00 00    	jne    80102f60 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e6a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e71:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e74:	83 ec 0c             	sub    $0xc,%esp
80102e77:	68 a0 26 11 80       	push   $0x801126a0
80102e7c:	e8 cf 1e 00 00       	call   80104d50 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e81:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e87:	83 c4 10             	add    $0x10,%esp
80102e8a:	85 c9                	test   %ecx,%ecx
80102e8c:	7f 42                	jg     80102ed0 <end_op+0xa0>
    acquire(&log.lock);
80102e8e:	83 ec 0c             	sub    $0xc,%esp
80102e91:	68 a0 26 11 80       	push   $0x801126a0
80102e96:	e8 15 1f 00 00       	call   80104db0 <acquire>
    wakeup(&log);
80102e9b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102ea2:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102ea9:	00 00 00 
    wakeup(&log);
80102eac:	e8 2f 15 00 00       	call   801043e0 <wakeup>
    release(&log.lock);
80102eb1:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102eb8:	e8 93 1e 00 00       	call   80104d50 <release>
80102ebd:	83 c4 10             	add    $0x10,%esp
}
80102ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ec3:	5b                   	pop    %ebx
80102ec4:	5e                   	pop    %esi
80102ec5:	5f                   	pop    %edi
80102ec6:	5d                   	pop    %ebp
80102ec7:	c3                   	ret    
80102ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ecf:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ed0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102ed5:	83 ec 08             	sub    $0x8,%esp
80102ed8:	01 d8                	add    %ebx,%eax
80102eda:	83 c0 01             	add    $0x1,%eax
80102edd:	50                   	push   %eax
80102ede:	ff 35 e4 26 11 80    	push   0x801126e4
80102ee4:	e8 e7 d1 ff ff       	call   801000d0 <bread>
80102ee9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eeb:	58                   	pop    %eax
80102eec:	5a                   	pop    %edx
80102eed:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102ef4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102efa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102efd:	e8 ce d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f02:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f05:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f07:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f0a:	68 00 02 00 00       	push   $0x200
80102f0f:	50                   	push   %eax
80102f10:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f13:	50                   	push   %eax
80102f14:	e8 f7 1f 00 00       	call   80104f10 <memmove>
    bwrite(to);  // write the log
80102f19:	89 34 24             	mov    %esi,(%esp)
80102f1c:	e8 8f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f21:	89 3c 24             	mov    %edi,(%esp)
80102f24:	e8 c7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f29:	89 34 24             	mov    %esi,(%esp)
80102f2c:	e8 bf d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f31:	83 c4 10             	add    $0x10,%esp
80102f34:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102f3a:	7c 94                	jl     80102ed0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f3c:	e8 7f fd ff ff       	call   80102cc0 <write_head>
    install_trans(); // Now install writes to home locations
80102f41:	e8 da fc ff ff       	call   80102c20 <install_trans>
    log.lh.n = 0;
80102f46:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102f4d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f50:	e8 6b fd ff ff       	call   80102cc0 <write_head>
80102f55:	e9 34 ff ff ff       	jmp    80102e8e <end_op+0x5e>
80102f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f60:	83 ec 0c             	sub    $0xc,%esp
80102f63:	68 a0 26 11 80       	push   $0x801126a0
80102f68:	e8 73 14 00 00       	call   801043e0 <wakeup>
  release(&log.lock);
80102f6d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f74:	e8 d7 1d 00 00       	call   80104d50 <release>
80102f79:	83 c4 10             	add    $0x10,%esp
}
80102f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f7f:	5b                   	pop    %ebx
80102f80:	5e                   	pop    %esi
80102f81:	5f                   	pop    %edi
80102f82:	5d                   	pop    %ebp
80102f83:	c3                   	ret    
    panic("log.committing");
80102f84:	83 ec 0c             	sub    $0xc,%esp
80102f87:	68 84 7f 10 80       	push   $0x80107f84
80102f8c:	e8 ef d3 ff ff       	call   80100380 <panic>
80102f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f9f:	90                   	nop

80102fa0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	53                   	push   %ebx
80102fa4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fa7:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102fad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fb0:	83 fa 1d             	cmp    $0x1d,%edx
80102fb3:	0f 8f 85 00 00 00    	jg     8010303e <log_write+0x9e>
80102fb9:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102fbe:	83 e8 01             	sub    $0x1,%eax
80102fc1:	39 c2                	cmp    %eax,%edx
80102fc3:	7d 79                	jge    8010303e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fc5:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102fca:	85 c0                	test   %eax,%eax
80102fcc:	7e 7d                	jle    8010304b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fce:	83 ec 0c             	sub    $0xc,%esp
80102fd1:	68 a0 26 11 80       	push   $0x801126a0
80102fd6:	e8 d5 1d 00 00       	call   80104db0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fdb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102fe1:	83 c4 10             	add    $0x10,%esp
80102fe4:	85 d2                	test   %edx,%edx
80102fe6:	7e 4a                	jle    80103032 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fe8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102feb:	31 c0                	xor    %eax,%eax
80102fed:	eb 08                	jmp    80102ff7 <log_write+0x57>
80102fef:	90                   	nop
80102ff0:	83 c0 01             	add    $0x1,%eax
80102ff3:	39 c2                	cmp    %eax,%edx
80102ff5:	74 29                	je     80103020 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ff7:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102ffe:	75 f0                	jne    80102ff0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103000:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103007:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010300a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010300d:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80103014:	c9                   	leave  
  release(&log.lock);
80103015:	e9 36 1d 00 00       	jmp    80104d50 <release>
8010301a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103020:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80103027:	83 c2 01             	add    $0x1,%edx
8010302a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80103030:	eb d5                	jmp    80103007 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103032:	8b 43 08             	mov    0x8(%ebx),%eax
80103035:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
8010303a:	75 cb                	jne    80103007 <log_write+0x67>
8010303c:	eb e9                	jmp    80103027 <log_write+0x87>
    panic("too big a transaction");
8010303e:	83 ec 0c             	sub    $0xc,%esp
80103041:	68 93 7f 10 80       	push   $0x80107f93
80103046:	e8 35 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010304b:	83 ec 0c             	sub    $0xc,%esp
8010304e:	68 a9 7f 10 80       	push   $0x80107fa9
80103053:	e8 28 d3 ff ff       	call   80100380 <panic>
80103058:	66 90                	xchg   %ax,%ax
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	53                   	push   %ebx
80103064:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103067:	e8 b4 09 00 00       	call   80103a20 <cpuid>
8010306c:	89 c3                	mov    %eax,%ebx
8010306e:	e8 ad 09 00 00       	call   80103a20 <cpuid>
80103073:	83 ec 04             	sub    $0x4,%esp
80103076:	53                   	push   %ebx
80103077:	50                   	push   %eax
80103078:	68 c4 7f 10 80       	push   $0x80107fc4
8010307d:	e8 1e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103082:	e8 49 31 00 00       	call   801061d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103087:	e8 34 09 00 00       	call   801039c0 <mycpu>
8010308c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010308e:	b8 01 00 00 00       	mov    $0x1,%eax
80103093:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010309a:	e8 a1 0c 00 00       	call   80103d40 <scheduler>
8010309f:	90                   	nop

801030a0 <mpenter>:
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030a6:	e8 45 42 00 00       	call   801072f0 <switchkvm>
  seginit();
801030ab:	e8 b0 41 00 00       	call   80107260 <seginit>
  lapicinit();
801030b0:	e8 9b f7 ff ff       	call   80102850 <lapicinit>
  mpmain();
801030b5:	e8 a6 ff ff ff       	call   80103060 <mpmain>
801030ba:	66 90                	xchg   %ax,%ax
801030bc:	66 90                	xchg   %ax,%ax
801030be:	66 90                	xchg   %ax,%ax

801030c0 <main>:
{
801030c0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030c4:	83 e4 f0             	and    $0xfffffff0,%esp
801030c7:	ff 71 fc             	push   -0x4(%ecx)
801030ca:	55                   	push   %ebp
801030cb:	89 e5                	mov    %esp,%ebp
801030cd:	53                   	push   %ebx
801030ce:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030cf:	83 ec 08             	sub    $0x8,%esp
801030d2:	68 00 00 40 80       	push   $0x80400000
801030d7:	68 d0 61 13 80       	push   $0x801361d0
801030dc:	e8 8f f5 ff ff       	call   80102670 <kinit1>
  kvmalloc();      // kernel page table
801030e1:	e8 fa 46 00 00       	call   801077e0 <kvmalloc>
  mpinit();        // detect other processors
801030e6:	e8 85 01 00 00       	call   80103270 <mpinit>
  lapicinit();     // interrupt controller
801030eb:	e8 60 f7 ff ff       	call   80102850 <lapicinit>
  seginit();       // segment descriptors
801030f0:	e8 6b 41 00 00       	call   80107260 <seginit>
  picinit();       // disable pic
801030f5:	e8 76 03 00 00       	call   80103470 <picinit>
  ioapicinit();    // another interrupt controller
801030fa:	e8 31 f3 ff ff       	call   80102430 <ioapicinit>
  consoleinit();   // console hardware
801030ff:	e8 5c d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103104:	e8 e7 33 00 00       	call   801064f0 <uartinit>
  pinit();         // process table
80103109:	e8 92 08 00 00       	call   801039a0 <pinit>
  tvinit();        // trap vectors
8010310e:	e8 3d 30 00 00       	call   80106150 <tvinit>
  binit();         // buffer cache
80103113:	e8 28 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103118:	e8 53 dd ff ff       	call   80100e70 <fileinit>
  ideinit();       // disk 
8010311d:	e8 fe f0 ff ff       	call   80102220 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103122:	83 c4 0c             	add    $0xc,%esp
80103125:	68 8a 00 00 00       	push   $0x8a
8010312a:	68 8c b4 10 80       	push   $0x8010b48c
8010312f:	68 00 70 00 80       	push   $0x80007000
80103134:	e8 d7 1d 00 00       	call   80104f10 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103139:	83 c4 10             	add    $0x10,%esp
8010313c:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103143:	00 00 00 
80103146:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010314b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103150:	76 7e                	jbe    801031d0 <main+0x110>
80103152:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103157:	eb 20                	jmp    80103179 <main+0xb9>
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103167:	00 00 00 
8010316a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103170:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103175:	39 c3                	cmp    %eax,%ebx
80103177:	73 57                	jae    801031d0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103179:	e8 42 08 00 00       	call   801039c0 <mycpu>
8010317e:	39 c3                	cmp    %eax,%ebx
80103180:	74 de                	je     80103160 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103182:	e8 59 f5 ff ff       	call   801026e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103187:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010318a:	c7 05 f8 6f 00 80 a0 	movl   $0x801030a0,0x80006ff8
80103191:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103194:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010319b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010319e:	05 00 10 00 00       	add    $0x1000,%eax
801031a3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801031a8:	0f b6 03             	movzbl (%ebx),%eax
801031ab:	68 00 70 00 00       	push   $0x7000
801031b0:	50                   	push   %eax
801031b1:	e8 ea f7 ff ff       	call   801029a0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031b6:	83 c4 10             	add    $0x10,%esp
801031b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031c6:	85 c0                	test   %eax,%eax
801031c8:	74 f6                	je     801031c0 <main+0x100>
801031ca:	eb 94                	jmp    80103160 <main+0xa0>
801031cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031d0:	83 ec 08             	sub    $0x8,%esp
801031d3:	68 00 00 00 8e       	push   $0x8e000000
801031d8:	68 00 00 40 80       	push   $0x80400000
801031dd:	e8 2e f4 ff ff       	call   80102610 <kinit2>
  userinit();      // first user process
801031e2:	e8 89 08 00 00       	call   80103a70 <userinit>
  mpmain();        // finish this processor's setup
801031e7:	e8 74 fe ff ff       	call   80103060 <mpmain>
801031ec:	66 90                	xchg   %ax,%ax
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	57                   	push   %edi
801031f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031fb:	53                   	push   %ebx
  e = addr+len;
801031fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031ff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103202:	39 de                	cmp    %ebx,%esi
80103204:	72 10                	jb     80103216 <mpsearch1+0x26>
80103206:	eb 50                	jmp    80103258 <mpsearch1+0x68>
80103208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop
80103210:	89 fe                	mov    %edi,%esi
80103212:	39 fb                	cmp    %edi,%ebx
80103214:	76 42                	jbe    80103258 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103216:	83 ec 04             	sub    $0x4,%esp
80103219:	8d 7e 10             	lea    0x10(%esi),%edi
8010321c:	6a 04                	push   $0x4
8010321e:	68 d8 7f 10 80       	push   $0x80107fd8
80103223:	56                   	push   %esi
80103224:	e8 97 1c 00 00       	call   80104ec0 <memcmp>
80103229:	83 c4 10             	add    $0x10,%esp
8010322c:	85 c0                	test   %eax,%eax
8010322e:	75 e0                	jne    80103210 <mpsearch1+0x20>
80103230:	89 f2                	mov    %esi,%edx
80103232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103238:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010323b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010323e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103240:	39 fa                	cmp    %edi,%edx
80103242:	75 f4                	jne    80103238 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103244:	84 c0                	test   %al,%al
80103246:	75 c8                	jne    80103210 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103248:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010324b:	89 f0                	mov    %esi,%eax
8010324d:	5b                   	pop    %ebx
8010324e:	5e                   	pop    %esi
8010324f:	5f                   	pop    %edi
80103250:	5d                   	pop    %ebp
80103251:	c3                   	ret    
80103252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103258:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010325b:	31 f6                	xor    %esi,%esi
}
8010325d:	5b                   	pop    %ebx
8010325e:	89 f0                	mov    %esi,%eax
80103260:	5e                   	pop    %esi
80103261:	5f                   	pop    %edi
80103262:	5d                   	pop    %ebp
80103263:	c3                   	ret    
80103264:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010326b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010326f:	90                   	nop

80103270 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	57                   	push   %edi
80103274:	56                   	push   %esi
80103275:	53                   	push   %ebx
80103276:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103279:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103280:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103287:	c1 e0 08             	shl    $0x8,%eax
8010328a:	09 d0                	or     %edx,%eax
8010328c:	c1 e0 04             	shl    $0x4,%eax
8010328f:	75 1b                	jne    801032ac <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103291:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103298:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010329f:	c1 e0 08             	shl    $0x8,%eax
801032a2:	09 d0                	or     %edx,%eax
801032a4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032a7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032ac:	ba 00 04 00 00       	mov    $0x400,%edx
801032b1:	e8 3a ff ff ff       	call   801031f0 <mpsearch1>
801032b6:	89 c3                	mov    %eax,%ebx
801032b8:	85 c0                	test   %eax,%eax
801032ba:	0f 84 40 01 00 00    	je     80103400 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032c0:	8b 73 04             	mov    0x4(%ebx),%esi
801032c3:	85 f6                	test   %esi,%esi
801032c5:	0f 84 25 01 00 00    	je     801033f0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
801032cb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032ce:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801032d4:	6a 04                	push   $0x4
801032d6:	68 dd 7f 10 80       	push   $0x80107fdd
801032db:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032df:	e8 dc 1b 00 00       	call   80104ec0 <memcmp>
801032e4:	83 c4 10             	add    $0x10,%esp
801032e7:	85 c0                	test   %eax,%eax
801032e9:	0f 85 01 01 00 00    	jne    801033f0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801032ef:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032f6:	3c 01                	cmp    $0x1,%al
801032f8:	74 08                	je     80103302 <mpinit+0x92>
801032fa:	3c 04                	cmp    $0x4,%al
801032fc:	0f 85 ee 00 00 00    	jne    801033f0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103302:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103309:	66 85 d2             	test   %dx,%dx
8010330c:	74 22                	je     80103330 <mpinit+0xc0>
8010330e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103311:	89 f0                	mov    %esi,%eax
  sum = 0;
80103313:	31 d2                	xor    %edx,%edx
80103315:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103318:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010331f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103322:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103324:	39 c7                	cmp    %eax,%edi
80103326:	75 f0                	jne    80103318 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103328:	84 d2                	test   %dl,%dl
8010332a:	0f 85 c0 00 00 00    	jne    801033f0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103330:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103336:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010333b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103342:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103348:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010334d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103350:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103357:	90                   	nop
80103358:	39 d0                	cmp    %edx,%eax
8010335a:	73 15                	jae    80103371 <mpinit+0x101>
    switch(*p){
8010335c:	0f b6 08             	movzbl (%eax),%ecx
8010335f:	80 f9 02             	cmp    $0x2,%cl
80103362:	74 4c                	je     801033b0 <mpinit+0x140>
80103364:	77 3a                	ja     801033a0 <mpinit+0x130>
80103366:	84 c9                	test   %cl,%cl
80103368:	74 56                	je     801033c0 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010336a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010336d:	39 d0                	cmp    %edx,%eax
8010336f:	72 eb                	jb     8010335c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103371:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103374:	85 f6                	test   %esi,%esi
80103376:	0f 84 d9 00 00 00    	je     80103455 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010337c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103380:	74 15                	je     80103397 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103382:	b8 70 00 00 00       	mov    $0x70,%eax
80103387:	ba 22 00 00 00       	mov    $0x22,%edx
8010338c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010338d:	ba 23 00 00 00       	mov    $0x23,%edx
80103392:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103393:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103396:	ee                   	out    %al,(%dx)
  }
}
80103397:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010339a:	5b                   	pop    %ebx
8010339b:	5e                   	pop    %esi
8010339c:	5f                   	pop    %edi
8010339d:	5d                   	pop    %ebp
8010339e:	c3                   	ret    
8010339f:	90                   	nop
    switch(*p){
801033a0:	83 e9 03             	sub    $0x3,%ecx
801033a3:	80 f9 01             	cmp    $0x1,%cl
801033a6:	76 c2                	jbe    8010336a <mpinit+0xfa>
801033a8:	31 f6                	xor    %esi,%esi
801033aa:	eb ac                	jmp    80103358 <mpinit+0xe8>
801033ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033b0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033b4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033b7:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
801033bd:	eb 99                	jmp    80103358 <mpinit+0xe8>
801033bf:	90                   	nop
      if(ncpu < NCPU) {
801033c0:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
801033c6:	83 f9 07             	cmp    $0x7,%ecx
801033c9:	7f 19                	jg     801033e4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033cb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033d1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033d5:	83 c1 01             	add    $0x1,%ecx
801033d8:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033de:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
801033e4:	83 c0 14             	add    $0x14,%eax
      continue;
801033e7:	e9 6c ff ff ff       	jmp    80103358 <mpinit+0xe8>
801033ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033f0:	83 ec 0c             	sub    $0xc,%esp
801033f3:	68 e2 7f 10 80       	push   $0x80107fe2
801033f8:	e8 83 cf ff ff       	call   80100380 <panic>
801033fd:	8d 76 00             	lea    0x0(%esi),%esi
{
80103400:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103405:	eb 13                	jmp    8010341a <mpinit+0x1aa>
80103407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010340e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103410:	89 f3                	mov    %esi,%ebx
80103412:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103418:	74 d6                	je     801033f0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010341a:	83 ec 04             	sub    $0x4,%esp
8010341d:	8d 73 10             	lea    0x10(%ebx),%esi
80103420:	6a 04                	push   $0x4
80103422:	68 d8 7f 10 80       	push   $0x80107fd8
80103427:	53                   	push   %ebx
80103428:	e8 93 1a 00 00       	call   80104ec0 <memcmp>
8010342d:	83 c4 10             	add    $0x10,%esp
80103430:	85 c0                	test   %eax,%eax
80103432:	75 dc                	jne    80103410 <mpinit+0x1a0>
80103434:	89 da                	mov    %ebx,%edx
80103436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010343d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103440:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103443:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103446:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103448:	39 d6                	cmp    %edx,%esi
8010344a:	75 f4                	jne    80103440 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010344c:	84 c0                	test   %al,%al
8010344e:	75 c0                	jne    80103410 <mpinit+0x1a0>
80103450:	e9 6b fe ff ff       	jmp    801032c0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103455:	83 ec 0c             	sub    $0xc,%esp
80103458:	68 fc 7f 10 80       	push   $0x80107ffc
8010345d:	e8 1e cf ff ff       	call   80100380 <panic>
80103462:	66 90                	xchg   %ax,%ax
80103464:	66 90                	xchg   %ax,%ax
80103466:	66 90                	xchg   %ax,%ax
80103468:	66 90                	xchg   %ax,%ax
8010346a:	66 90                	xchg   %ax,%ax
8010346c:	66 90                	xchg   %ax,%ax
8010346e:	66 90                	xchg   %ax,%ax

80103470 <picinit>:
80103470:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103475:	ba 21 00 00 00       	mov    $0x21,%edx
8010347a:	ee                   	out    %al,(%dx)
8010347b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103480:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103481:	c3                   	ret    
80103482:	66 90                	xchg   %ax,%ax
80103484:	66 90                	xchg   %ax,%ax
80103486:	66 90                	xchg   %ax,%ax
80103488:	66 90                	xchg   %ax,%ax
8010348a:	66 90                	xchg   %ax,%ax
8010348c:	66 90                	xchg   %ax,%ax
8010348e:	66 90                	xchg   %ax,%ax

80103490 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	57                   	push   %edi
80103494:	56                   	push   %esi
80103495:	53                   	push   %ebx
80103496:	83 ec 0c             	sub    $0xc,%esp
80103499:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010349c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010349f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801034a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034ab:	e8 e0 d9 ff ff       	call   80100e90 <filealloc>
801034b0:	89 03                	mov    %eax,(%ebx)
801034b2:	85 c0                	test   %eax,%eax
801034b4:	0f 84 a8 00 00 00    	je     80103562 <pipealloc+0xd2>
801034ba:	e8 d1 d9 ff ff       	call   80100e90 <filealloc>
801034bf:	89 06                	mov    %eax,(%esi)
801034c1:	85 c0                	test   %eax,%eax
801034c3:	0f 84 87 00 00 00    	je     80103550 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034c9:	e8 12 f2 ff ff       	call   801026e0 <kalloc>
801034ce:	89 c7                	mov    %eax,%edi
801034d0:	85 c0                	test   %eax,%eax
801034d2:	0f 84 b0 00 00 00    	je     80103588 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801034d8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034df:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034e2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034e5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034ec:	00 00 00 
  p->nwrite = 0;
801034ef:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034f6:	00 00 00 
  p->nread = 0;
801034f9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103500:	00 00 00 
  initlock(&p->lock, "pipe");
80103503:	68 1b 80 10 80       	push   $0x8010801b
80103508:	50                   	push   %eax
80103509:	e8 d2 16 00 00       	call   80104be0 <initlock>
  (*f0)->type = FD_PIPE;
8010350e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103510:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103513:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103519:	8b 03                	mov    (%ebx),%eax
8010351b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010351f:	8b 03                	mov    (%ebx),%eax
80103521:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103525:	8b 03                	mov    (%ebx),%eax
80103527:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010352a:	8b 06                	mov    (%esi),%eax
8010352c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103532:	8b 06                	mov    (%esi),%eax
80103534:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103538:	8b 06                	mov    (%esi),%eax
8010353a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010353e:	8b 06                	mov    (%esi),%eax
80103540:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103543:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103546:	31 c0                	xor    %eax,%eax
}
80103548:	5b                   	pop    %ebx
80103549:	5e                   	pop    %esi
8010354a:	5f                   	pop    %edi
8010354b:	5d                   	pop    %ebp
8010354c:	c3                   	ret    
8010354d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103550:	8b 03                	mov    (%ebx),%eax
80103552:	85 c0                	test   %eax,%eax
80103554:	74 1e                	je     80103574 <pipealloc+0xe4>
    fileclose(*f0);
80103556:	83 ec 0c             	sub    $0xc,%esp
80103559:	50                   	push   %eax
8010355a:	e8 f1 d9 ff ff       	call   80100f50 <fileclose>
8010355f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103562:	8b 06                	mov    (%esi),%eax
80103564:	85 c0                	test   %eax,%eax
80103566:	74 0c                	je     80103574 <pipealloc+0xe4>
    fileclose(*f1);
80103568:	83 ec 0c             	sub    $0xc,%esp
8010356b:	50                   	push   %eax
8010356c:	e8 df d9 ff ff       	call   80100f50 <fileclose>
80103571:	83 c4 10             	add    $0x10,%esp
}
80103574:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103577:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010357c:	5b                   	pop    %ebx
8010357d:	5e                   	pop    %esi
8010357e:	5f                   	pop    %edi
8010357f:	5d                   	pop    %ebp
80103580:	c3                   	ret    
80103581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103588:	8b 03                	mov    (%ebx),%eax
8010358a:	85 c0                	test   %eax,%eax
8010358c:	75 c8                	jne    80103556 <pipealloc+0xc6>
8010358e:	eb d2                	jmp    80103562 <pipealloc+0xd2>

80103590 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	56                   	push   %esi
80103594:	53                   	push   %ebx
80103595:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103598:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010359b:	83 ec 0c             	sub    $0xc,%esp
8010359e:	53                   	push   %ebx
8010359f:	e8 0c 18 00 00       	call   80104db0 <acquire>
  if(writable){
801035a4:	83 c4 10             	add    $0x10,%esp
801035a7:	85 f6                	test   %esi,%esi
801035a9:	74 65                	je     80103610 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801035ab:	83 ec 0c             	sub    $0xc,%esp
801035ae:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801035b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035bb:	00 00 00 
    wakeup(&p->nread);
801035be:	50                   	push   %eax
801035bf:	e8 1c 0e 00 00       	call   801043e0 <wakeup>
801035c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035cd:	85 d2                	test   %edx,%edx
801035cf:	75 0a                	jne    801035db <pipeclose+0x4b>
801035d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035d7:	85 c0                	test   %eax,%eax
801035d9:	74 15                	je     801035f0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035e1:	5b                   	pop    %ebx
801035e2:	5e                   	pop    %esi
801035e3:	5d                   	pop    %ebp
    release(&p->lock);
801035e4:	e9 67 17 00 00       	jmp    80104d50 <release>
801035e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	53                   	push   %ebx
801035f4:	e8 57 17 00 00       	call   80104d50 <release>
    kfree((char*)p);
801035f9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035fc:	83 c4 10             	add    $0x10,%esp
}
801035ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103602:	5b                   	pop    %ebx
80103603:	5e                   	pop    %esi
80103604:	5d                   	pop    %ebp
    kfree((char*)p);
80103605:	e9 16 ef ff ff       	jmp    80102520 <kfree>
8010360a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103610:	83 ec 0c             	sub    $0xc,%esp
80103613:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103619:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103620:	00 00 00 
    wakeup(&p->nwrite);
80103623:	50                   	push   %eax
80103624:	e8 b7 0d 00 00       	call   801043e0 <wakeup>
80103629:	83 c4 10             	add    $0x10,%esp
8010362c:	eb 99                	jmp    801035c7 <pipeclose+0x37>
8010362e:	66 90                	xchg   %ax,%ax

80103630 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
80103635:	53                   	push   %ebx
80103636:	83 ec 28             	sub    $0x28,%esp
80103639:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010363c:	53                   	push   %ebx
8010363d:	e8 6e 17 00 00       	call   80104db0 <acquire>
  for(i = 0; i < n; i++){
80103642:	8b 45 10             	mov    0x10(%ebp),%eax
80103645:	83 c4 10             	add    $0x10,%esp
80103648:	85 c0                	test   %eax,%eax
8010364a:	0f 8e c0 00 00 00    	jle    80103710 <pipewrite+0xe0>
80103650:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103653:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103659:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010365f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103662:	03 45 10             	add    0x10(%ebp),%eax
80103665:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103668:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010366e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103674:	89 ca                	mov    %ecx,%edx
80103676:	05 00 02 00 00       	add    $0x200,%eax
8010367b:	39 c1                	cmp    %eax,%ecx
8010367d:	74 3f                	je     801036be <pipewrite+0x8e>
8010367f:	eb 67                	jmp    801036e8 <pipewrite+0xb8>
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103688:	e8 b3 03 00 00       	call   80103a40 <myproc>
8010368d:	8b 48 14             	mov    0x14(%eax),%ecx
80103690:	85 c9                	test   %ecx,%ecx
80103692:	75 34                	jne    801036c8 <pipewrite+0x98>
      wakeup(&p->nread);
80103694:	83 ec 0c             	sub    $0xc,%esp
80103697:	57                   	push   %edi
80103698:	e8 43 0d 00 00       	call   801043e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010369d:	58                   	pop    %eax
8010369e:	5a                   	pop    %edx
8010369f:	53                   	push   %ebx
801036a0:	56                   	push   %esi
801036a1:	e8 3a 0c 00 00       	call   801042e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036a6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036ac:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036b2:	83 c4 10             	add    $0x10,%esp
801036b5:	05 00 02 00 00       	add    $0x200,%eax
801036ba:	39 c2                	cmp    %eax,%edx
801036bc:	75 2a                	jne    801036e8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801036be:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036c4:	85 c0                	test   %eax,%eax
801036c6:	75 c0                	jne    80103688 <pipewrite+0x58>
        release(&p->lock);
801036c8:	83 ec 0c             	sub    $0xc,%esp
801036cb:	53                   	push   %ebx
801036cc:	e8 7f 16 00 00       	call   80104d50 <release>
        return -1;
801036d1:	83 c4 10             	add    $0x10,%esp
801036d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036dc:	5b                   	pop    %ebx
801036dd:	5e                   	pop    %esi
801036de:	5f                   	pop    %edi
801036df:	5d                   	pop    %ebp
801036e0:	c3                   	ret    
801036e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036e8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036eb:	8d 4a 01             	lea    0x1(%edx),%ecx
801036ee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036f4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036fa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801036fd:	83 c6 01             	add    $0x1,%esi
80103700:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103703:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103707:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010370a:	0f 85 58 ff ff ff    	jne    80103668 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103710:	83 ec 0c             	sub    $0xc,%esp
80103713:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103719:	50                   	push   %eax
8010371a:	e8 c1 0c 00 00       	call   801043e0 <wakeup>
  release(&p->lock);
8010371f:	89 1c 24             	mov    %ebx,(%esp)
80103722:	e8 29 16 00 00       	call   80104d50 <release>
  return n;
80103727:	8b 45 10             	mov    0x10(%ebp),%eax
8010372a:	83 c4 10             	add    $0x10,%esp
8010372d:	eb aa                	jmp    801036d9 <pipewrite+0xa9>
8010372f:	90                   	nop

80103730 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	57                   	push   %edi
80103734:	56                   	push   %esi
80103735:	53                   	push   %ebx
80103736:	83 ec 18             	sub    $0x18,%esp
80103739:	8b 75 08             	mov    0x8(%ebp),%esi
8010373c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010373f:	56                   	push   %esi
80103740:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103746:	e8 65 16 00 00       	call   80104db0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010374b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103751:	83 c4 10             	add    $0x10,%esp
80103754:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010375a:	74 2f                	je     8010378b <piperead+0x5b>
8010375c:	eb 37                	jmp    80103795 <piperead+0x65>
8010375e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103760:	e8 db 02 00 00       	call   80103a40 <myproc>
80103765:	8b 48 14             	mov    0x14(%eax),%ecx
80103768:	85 c9                	test   %ecx,%ecx
8010376a:	0f 85 80 00 00 00    	jne    801037f0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103770:	83 ec 08             	sub    $0x8,%esp
80103773:	56                   	push   %esi
80103774:	53                   	push   %ebx
80103775:	e8 66 0b 00 00       	call   801042e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010377a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103780:	83 c4 10             	add    $0x10,%esp
80103783:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103789:	75 0a                	jne    80103795 <piperead+0x65>
8010378b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103791:	85 c0                	test   %eax,%eax
80103793:	75 cb                	jne    80103760 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103795:	8b 55 10             	mov    0x10(%ebp),%edx
80103798:	31 db                	xor    %ebx,%ebx
8010379a:	85 d2                	test   %edx,%edx
8010379c:	7f 20                	jg     801037be <piperead+0x8e>
8010379e:	eb 2c                	jmp    801037cc <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037a0:	8d 48 01             	lea    0x1(%eax),%ecx
801037a3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037a8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037ae:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037b3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037b6:	83 c3 01             	add    $0x1,%ebx
801037b9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037bc:	74 0e                	je     801037cc <piperead+0x9c>
    if(p->nread == p->nwrite)
801037be:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037c4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037ca:	75 d4                	jne    801037a0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037cc:	83 ec 0c             	sub    $0xc,%esp
801037cf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037d5:	50                   	push   %eax
801037d6:	e8 05 0c 00 00       	call   801043e0 <wakeup>
  release(&p->lock);
801037db:	89 34 24             	mov    %esi,(%esp)
801037de:	e8 6d 15 00 00       	call   80104d50 <release>
  return i;
801037e3:	83 c4 10             	add    $0x10,%esp
}
801037e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037e9:	89 d8                	mov    %ebx,%eax
801037eb:	5b                   	pop    %ebx
801037ec:	5e                   	pop    %esi
801037ed:	5f                   	pop    %edi
801037ee:	5d                   	pop    %ebp
801037ef:	c3                   	ret    
      release(&p->lock);
801037f0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037f3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037f8:	56                   	push   %esi
801037f9:	e8 52 15 00 00       	call   80104d50 <release>
      return -1;
801037fe:	83 c4 10             	add    $0x10,%esp
}
80103801:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103804:	89 d8                	mov    %ebx,%eax
80103806:	5b                   	pop    %ebx
80103807:	5e                   	pop    %esi
80103808:	5f                   	pop    %edi
80103809:	5d                   	pop    %ebp
8010380a:	c3                   	ret    
8010380b:	66 90                	xchg   %ax,%ax
8010380d:	66 90                	xchg   %ax,%ax
8010380f:	90                   	nop

80103810 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	53                   	push   %ebx
  struct thread *t;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103814:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103819:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010381c:	68 20 2d 11 80       	push   $0x80112d20
80103821:	e8 8a 15 00 00       	call   80104db0 <acquire>
80103826:	83 c4 10             	add    $0x10,%esp
80103829:	eb 17                	jmp    80103842 <allocproc+0x32>
8010382b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010382f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103830:	81 c3 70 08 00 00    	add    $0x870,%ebx
80103836:	81 fb 54 49 13 80    	cmp    $0x80134954,%ebx
8010383c:	0f 84 d3 00 00 00    	je     80103915 <allocproc+0x105>
    if(p->state == UNUSED)
80103842:	8b 43 08             	mov    0x8(%ebx),%eax
80103845:	85 c0                	test   %eax,%eax
80103847:	75 e7                	jne    80103830 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103849:	a1 08 b0 10 80       	mov    0x8010b008,%eax
  p->state = EMBRYO;
8010384e:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
  p->curtidx = 0; // new process always start with 0th thread
80103855:	c7 83 6c 08 00 00 00 	movl   $0x0,0x86c(%ebx)
8010385c:	00 00 00 
  p->pid = nextpid++;
8010385f:	8d 50 01             	lea    0x1(%eax),%edx
80103862:	89 43 0c             	mov    %eax,0xc(%ebx)
  // In initial proc state, Default-thread: 0th thread

  // Thread pool init
  for(int i = 0; i < NTHREAD; i++){
80103865:	8d 43 6c             	lea    0x6c(%ebx),%eax
  p->pid = nextpid++;
80103868:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
8010386e:	8d 93 6c 08 00 00    	lea    0x86c(%ebx),%edx
80103874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	p->threads[i].state = UNUSED;
80103878:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i = 0; i < NTHREAD; i++){
8010387e:	83 c0 20             	add    $0x20,%eax
	p->threads[i].tid = 0;
80103881:	c7 40 e4 00 00 00 00 	movl   $0x0,-0x1c(%eax)
	p->threads[i].kstack = 0;
80103888:	c7 40 e8 00 00 00 00 	movl   $0x0,-0x18(%eax)
	p->threads[i].ustackp = 0;
8010388f:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
	p->threads[i].chan = 0;
80103896:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
	p->threads[i].ret = 0;
8010389d:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(int i = 0; i < NTHREAD; i++){
801038a4:	39 d0                	cmp    %edx,%eax
801038a6:	75 d0                	jne    80103878 <allocproc+0x68>
  }

  // Default-thread init
  t = &p->threads[0];
  t->state = EMBRYO;
  t->tid = nexttid++;
801038a8:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801038ad:	83 ec 0c             	sub    $0xc,%esp
  t->state = EMBRYO;
801038b0:	c7 43 6c 01 00 00 00 	movl   $0x1,0x6c(%ebx)
  t->tid = nexttid++;
801038b7:	89 43 70             	mov    %eax,0x70(%ebx)
801038ba:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801038bd:	68 20 2d 11 80       	push   $0x80112d20
  t->tid = nexttid++;
801038c2:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801038c8:	e8 83 14 00 00       	call   80104d50 <release>

  // Allocate kernel stack to Default-thread
  if((t->kstack = kalloc()) == 0){
801038cd:	e8 0e ee ff ff       	call   801026e0 <kalloc>
801038d2:	83 c4 10             	add    $0x10,%esp
801038d5:	89 43 74             	mov    %eax,0x74(%ebx)
801038d8:	85 c0                	test   %eax,%eax
801038da:	74 52                	je     8010392e <allocproc+0x11e>
    return 0;
  }
  sp = t->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *t->tf;
801038dc:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *t->context;
  t->context = (struct context*)sp;
  memset(t->context, 0, sizeof *t->context);
801038e2:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *t->context;
801038e5:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *t->tf;
801038ea:	89 53 78             	mov    %edx,0x78(%ebx)
  *(uint*)sp = (uint)trapret;
801038ed:	c7 40 14 37 61 10 80 	movl   $0x80106137,0x14(%eax)
  t->context = (struct context*)sp;
801038f4:	89 43 7c             	mov    %eax,0x7c(%ebx)
  memset(t->context, 0, sizeof *t->context);
801038f7:	6a 14                	push   $0x14
801038f9:	6a 00                	push   $0x0
801038fb:	50                   	push   %eax
801038fc:	e8 6f 15 00 00       	call   80104e70 <memset>
  t->context->eip = (uint)forkret;
80103901:	8b 43 7c             	mov    0x7c(%ebx),%eax

  return p;
80103904:	83 c4 10             	add    $0x10,%esp
  t->context->eip = (uint)forkret;
80103907:	c7 40 10 50 39 10 80 	movl   $0x80103950,0x10(%eax)
}
8010390e:	89 d8                	mov    %ebx,%eax
80103910:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103913:	c9                   	leave  
80103914:	c3                   	ret    
  release(&ptable.lock);
80103915:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103918:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010391a:	68 20 2d 11 80       	push   $0x80112d20
8010391f:	e8 2c 14 00 00       	call   80104d50 <release>
}
80103924:	89 d8                	mov    %ebx,%eax
  return 0;
80103926:	83 c4 10             	add    $0x10,%esp
}
80103929:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010392c:	c9                   	leave  
8010392d:	c3                   	ret    
    p->state = UNUSED;
8010392e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	t->state = UNUSED;
80103935:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
    return 0;
8010393c:	31 db                	xor    %ebx,%ebx
}
8010393e:	89 d8                	mov    %ebx,%eax
80103940:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103943:	c9                   	leave  
80103944:	c3                   	ret    
80103945:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010394c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103950 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103956:	68 20 2d 11 80       	push   $0x80112d20
8010395b:	e8 f0 13 00 00       	call   80104d50 <release>

  if (first) {
80103960:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103965:	83 c4 10             	add    $0x10,%esp
80103968:	85 c0                	test   %eax,%eax
8010396a:	75 04                	jne    80103970 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010396c:	c9                   	leave  
8010396d:	c3                   	ret    
8010396e:	66 90                	xchg   %ax,%ax
    first = 0;
80103970:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103977:	00 00 00 
    iinit(ROOTDEV);
8010397a:	83 ec 0c             	sub    $0xc,%esp
8010397d:	6a 01                	push   $0x1
8010397f:	e8 3c dc ff ff       	call   801015c0 <iinit>
    initlog(ROOTDEV);
80103984:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010398b:	e8 90 f3 ff ff       	call   80102d20 <initlog>
}
80103990:	83 c4 10             	add    $0x10,%esp
80103993:	c9                   	leave  
80103994:	c3                   	ret    
80103995:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010399c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039a0 <pinit>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039a6:	68 20 80 10 80       	push   $0x80108020
801039ab:	68 20 2d 11 80       	push   $0x80112d20
801039b0:	e8 2b 12 00 00       	call   80104be0 <initlock>
}
801039b5:	83 c4 10             	add    $0x10,%esp
801039b8:	c9                   	leave  
801039b9:	c3                   	ret    
801039ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039c0 <mycpu>:
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	56                   	push   %esi
801039c4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039c5:	9c                   	pushf  
801039c6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039c7:	f6 c4 02             	test   $0x2,%ah
801039ca:	75 46                	jne    80103a12 <mycpu+0x52>
  apicid = lapicid();
801039cc:	e8 7f ef ff ff       	call   80102950 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039d1:	8b 35 84 27 11 80    	mov    0x80112784,%esi
801039d7:	85 f6                	test   %esi,%esi
801039d9:	7e 2a                	jle    80103a05 <mycpu+0x45>
801039db:	31 d2                	xor    %edx,%edx
801039dd:	eb 08                	jmp    801039e7 <mycpu+0x27>
801039df:	90                   	nop
801039e0:	83 c2 01             	add    $0x1,%edx
801039e3:	39 f2                	cmp    %esi,%edx
801039e5:	74 1e                	je     80103a05 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801039e7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039ed:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
801039f4:	39 c3                	cmp    %eax,%ebx
801039f6:	75 e8                	jne    801039e0 <mycpu+0x20>
}
801039f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039fb:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103a01:	5b                   	pop    %ebx
80103a02:	5e                   	pop    %esi
80103a03:	5d                   	pop    %ebp
80103a04:	c3                   	ret    
  panic("unknown apicid\n");
80103a05:	83 ec 0c             	sub    $0xc,%esp
80103a08:	68 27 80 10 80       	push   $0x80108027
80103a0d:	e8 6e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a12:	83 ec 0c             	sub    $0xc,%esp
80103a15:	68 50 81 10 80       	push   $0x80108150
80103a1a:	e8 61 c9 ff ff       	call   80100380 <panic>
80103a1f:	90                   	nop

80103a20 <cpuid>:
cpuid() {
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a26:	e8 95 ff ff ff       	call   801039c0 <mycpu>
}
80103a2b:	c9                   	leave  
  return mycpu()-cpus;
80103a2c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103a31:	c1 f8 04             	sar    $0x4,%eax
80103a34:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a3a:	c3                   	ret    
80103a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a3f:	90                   	nop

80103a40 <myproc>:
myproc(void) {
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	53                   	push   %ebx
80103a44:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a47:	e8 14 12 00 00       	call   80104c60 <pushcli>
  c = mycpu();
80103a4c:	e8 6f ff ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103a51:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a57:	e8 54 12 00 00       	call   80104cb0 <popcli>
}
80103a5c:	89 d8                	mov    %ebx,%eax
80103a5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a61:	c9                   	leave  
80103a62:	c3                   	ret    
80103a63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a70 <userinit>:
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	53                   	push   %ebx
80103a74:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a77:	e8 94 fd ff ff       	call   80103810 <allocproc>
80103a7c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a7e:	a3 54 49 13 80       	mov    %eax,0x80134954
  if((p->pgdir = setupkvm()) == 0)
80103a83:	e8 d8 3c 00 00       	call   80107760 <setupkvm>
80103a88:	89 43 04             	mov    %eax,0x4(%ebx)
80103a8b:	85 c0                	test   %eax,%eax
80103a8d:	0f 84 c4 00 00 00    	je     80103b57 <userinit+0xe7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a93:	83 ec 04             	sub    $0x4,%esp
80103a96:	68 2c 00 00 00       	push   $0x2c
80103a9b:	68 60 b4 10 80       	push   $0x8010b460
80103aa0:	50                   	push   %eax
80103aa1:	e8 6a 39 00 00       	call   80107410 <inituvm>
  memset(t->tf, 0, sizeof(*t->tf));
80103aa6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103aa9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(t->tf, 0, sizeof(*t->tf));
80103aaf:	6a 4c                	push   $0x4c
80103ab1:	6a 00                	push   $0x0
80103ab3:	ff 73 78             	push   0x78(%ebx)
80103ab6:	e8 b5 13 00 00       	call   80104e70 <memset>
  t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103abb:	8b 43 78             	mov    0x78(%ebx),%eax
80103abe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ac3:	83 c4 0c             	add    $0xc,%esp
  t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ac6:	b9 23 00 00 00       	mov    $0x23,%ecx
  t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103acb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103acf:	8b 43 78             	mov    0x78(%ebx),%eax
80103ad2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  t->tf->es = t->tf->ds;
80103ad6:	8b 43 78             	mov    0x78(%ebx),%eax
80103ad9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103add:	66 89 50 28          	mov    %dx,0x28(%eax)
  t->tf->ss = t->tf->ds;
80103ae1:	8b 43 78             	mov    0x78(%ebx),%eax
80103ae4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ae8:	66 89 50 48          	mov    %dx,0x48(%eax)
  t->tf->eflags = FL_IF;
80103aec:	8b 43 78             	mov    0x78(%ebx),%eax
80103aef:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  t->tf->esp = PGSIZE;
80103af6:	8b 43 78             	mov    0x78(%ebx),%eax
80103af9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  t->tf->eip = 0;  // beginning of initcode.S
80103b00:	8b 43 78             	mov    0x78(%ebx),%eax
80103b03:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b0a:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103b0d:	6a 10                	push   $0x10
80103b0f:	68 50 80 10 80       	push   $0x80108050
80103b14:	50                   	push   %eax
80103b15:	e8 16 15 00 00       	call   80105030 <safestrcpy>
  p->cwd = namei("/");
80103b1a:	c7 04 24 59 80 10 80 	movl   $0x80108059,(%esp)
80103b21:	e8 da e5 ff ff       	call   80102100 <namei>
80103b26:	89 43 58             	mov    %eax,0x58(%ebx)
  acquire(&ptable.lock);
80103b29:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b30:	e8 7b 12 00 00       	call   80104db0 <acquire>
  t->state = RUNNABLE;
80103b35:	c7 43 6c 03 00 00 00 	movl   $0x3,0x6c(%ebx)
  p->state = RUNNABLE;
80103b3c:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
  release(&ptable.lock);
80103b43:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b4a:	e8 01 12 00 00       	call   80104d50 <release>
}
80103b4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b52:	83 c4 10             	add    $0x10,%esp
80103b55:	c9                   	leave  
80103b56:	c3                   	ret    
    panic("userinit: out of memory?");
80103b57:	83 ec 0c             	sub    $0xc,%esp
80103b5a:	68 37 80 10 80       	push   $0x80108037
80103b5f:	e8 1c c8 ff ff       	call   80100380 <panic>
80103b64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b6f:	90                   	nop

80103b70 <growproc>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	56                   	push   %esi
80103b74:	53                   	push   %ebx
80103b75:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b78:	e8 e3 10 00 00       	call   80104c60 <pushcli>
  c = mycpu();
80103b7d:	e8 3e fe ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103b82:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b88:	e8 23 11 00 00       	call   80104cb0 <popcli>
  sz = curproc->sz;
80103b8d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b8f:	85 f6                	test   %esi,%esi
80103b91:	7f 1d                	jg     80103bb0 <growproc+0x40>
  } else if(n < 0){
80103b93:	75 3b                	jne    80103bd0 <growproc+0x60>
  switchuvm(curproc);
80103b95:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b98:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b9a:	53                   	push   %ebx
80103b9b:	e8 60 37 00 00       	call   80107300 <switchuvm>
  return 0;
80103ba0:	83 c4 10             	add    $0x10,%esp
80103ba3:	31 c0                	xor    %eax,%eax
}
80103ba5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ba8:	5b                   	pop    %ebx
80103ba9:	5e                   	pop    %esi
80103baa:	5d                   	pop    %ebp
80103bab:	c3                   	ret    
80103bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bb0:	83 ec 04             	sub    $0x4,%esp
80103bb3:	01 c6                	add    %eax,%esi
80103bb5:	56                   	push   %esi
80103bb6:	50                   	push   %eax
80103bb7:	ff 73 04             	push   0x4(%ebx)
80103bba:	e8 c1 39 00 00       	call   80107580 <allocuvm>
80103bbf:	83 c4 10             	add    $0x10,%esp
80103bc2:	85 c0                	test   %eax,%eax
80103bc4:	75 cf                	jne    80103b95 <growproc+0x25>
      return -1;
80103bc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bcb:	eb d8                	jmp    80103ba5 <growproc+0x35>
80103bcd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bd0:	83 ec 04             	sub    $0x4,%esp
80103bd3:	01 c6                	add    %eax,%esi
80103bd5:	56                   	push   %esi
80103bd6:	50                   	push   %eax
80103bd7:	ff 73 04             	push   0x4(%ebx)
80103bda:	e8 d1 3a 00 00       	call   801076b0 <deallocuvm>
80103bdf:	83 c4 10             	add    $0x10,%esp
80103be2:	85 c0                	test   %eax,%eax
80103be4:	75 af                	jne    80103b95 <growproc+0x25>
80103be6:	eb de                	jmp    80103bc6 <growproc+0x56>
80103be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bef:	90                   	nop

80103bf0 <fork>:
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	57                   	push   %edi
80103bf4:	56                   	push   %esi
80103bf5:	53                   	push   %ebx
80103bf6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103bf9:	e8 62 10 00 00       	call   80104c60 <pushcli>
  c = mycpu();
80103bfe:	e8 bd fd ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103c03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c09:	e8 a2 10 00 00       	call   80104cb0 <popcli>
  struct thread *curt = &curproc->threads[curproc->curtidx];
80103c0e:	8b 83 6c 08 00 00    	mov    0x86c(%ebx),%eax
80103c14:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((np = allocproc()) == 0){
80103c17:	e8 f4 fb ff ff       	call   80103810 <allocproc>
80103c1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c1f:	85 c0                	test   %eax,%eax
80103c21:	0f 84 da 00 00 00    	je     80103d01 <fork+0x111>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c27:	83 ec 08             	sub    $0x8,%esp
80103c2a:	ff 33                	push   (%ebx)
80103c2c:	89 c7                	mov    %eax,%edi
80103c2e:	ff 73 04             	push   0x4(%ebx)
80103c31:	e8 1a 3c 00 00       	call   80107850 <copyuvm>
80103c36:	83 c4 10             	add    $0x10,%esp
80103c39:	89 47 04             	mov    %eax,0x4(%edi)
80103c3c:	85 c0                	test   %eax,%eax
80103c3e:	0f 84 c4 00 00 00    	je     80103d08 <fork+0x118>
  np->sz = curproc->sz;
80103c44:	8b 03                	mov    (%ebx),%eax
80103c46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *ndt->tf = *curt->tf;
80103c49:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103c4e:	89 02                	mov    %eax,(%edx)
  *ndt->tf = *curt->tf;
80103c50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  np->parent = curproc;
80103c53:	89 5a 10             	mov    %ebx,0x10(%edx)
  *ndt->tf = *curt->tf;
80103c56:	8b 7a 78             	mov    0x78(%edx),%edi
80103c59:	c1 e0 05             	shl    $0x5,%eax
80103c5c:	8b 74 18 78          	mov    0x78(%eax,%ebx,1),%esi
  ndt->ustackp = curt->ustackp;
80103c60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  *ndt->tf = *curt->tf;
80103c63:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  ndt->tf->eax = 0;
80103c65:	89 d7                	mov    %edx,%edi
  for(i = 0; i < NOFILE; i++)
80103c67:	31 f6                	xor    %esi,%esi
  ndt->ustackp = curt->ustackp;
80103c69:	c1 e0 05             	shl    $0x5,%eax
80103c6c:	8b 84 03 80 00 00 00 	mov    0x80(%ebx,%eax,1),%eax
80103c73:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
  ndt->tf->eax = 0;
80103c79:	8b 42 78             	mov    0x78(%edx),%eax
80103c7c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103c83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c87:	90                   	nop
    if(curproc->ofile[i])
80103c88:	8b 44 b3 18          	mov    0x18(%ebx,%esi,4),%eax
80103c8c:	85 c0                	test   %eax,%eax
80103c8e:	74 10                	je     80103ca0 <fork+0xb0>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c90:	83 ec 0c             	sub    $0xc,%esp
80103c93:	50                   	push   %eax
80103c94:	e8 67 d2 ff ff       	call   80100f00 <filedup>
80103c99:	83 c4 10             	add    $0x10,%esp
80103c9c:	89 44 b7 18          	mov    %eax,0x18(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103ca0:	83 c6 01             	add    $0x1,%esi
80103ca3:	83 fe 10             	cmp    $0x10,%esi
80103ca6:	75 e0                	jne    80103c88 <fork+0x98>
  np->cwd = idup(curproc->cwd);
80103ca8:	83 ec 0c             	sub    $0xc,%esp
80103cab:	ff 73 58             	push   0x58(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cae:	83 c3 5c             	add    $0x5c,%ebx
  np->cwd = idup(curproc->cwd);
80103cb1:	e8 fa da ff ff       	call   801017b0 <idup>
80103cb6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cb9:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103cbc:	89 47 58             	mov    %eax,0x58(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cbf:	8d 47 5c             	lea    0x5c(%edi),%eax
80103cc2:	6a 10                	push   $0x10
80103cc4:	53                   	push   %ebx
80103cc5:	50                   	push   %eax
80103cc6:	e8 65 13 00 00       	call   80105030 <safestrcpy>
  pid = np->pid;
80103ccb:	8b 5f 0c             	mov    0xc(%edi),%ebx
  acquire(&ptable.lock);
80103cce:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cd5:	e8 d6 10 00 00       	call   80104db0 <acquire>
  np->state = RUNNABLE;
80103cda:	c7 47 08 03 00 00 00 	movl   $0x3,0x8(%edi)
  ndt->state = RUNNABLE;
80103ce1:	c7 47 6c 03 00 00 00 	movl   $0x3,0x6c(%edi)
  release(&ptable.lock);
80103ce8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cef:	e8 5c 10 00 00       	call   80104d50 <release>
  return pid;
80103cf4:	83 c4 10             	add    $0x10,%esp
}
80103cf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cfa:	89 d8                	mov    %ebx,%eax
80103cfc:	5b                   	pop    %ebx
80103cfd:	5e                   	pop    %esi
80103cfe:	5f                   	pop    %edi
80103cff:	5d                   	pop    %ebp
80103d00:	c3                   	ret    
    return -1;
80103d01:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d06:	eb ef                	jmp    80103cf7 <fork+0x107>
    kfree(ndt->kstack);
80103d08:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d0b:	83 ec 0c             	sub    $0xc,%esp
80103d0e:	ff 73 74             	push   0x74(%ebx)
80103d11:	e8 0a e8 ff ff       	call   80102520 <kfree>
    ndt->kstack = 0;
80103d16:	c7 43 74 00 00 00 00 	movl   $0x0,0x74(%ebx)
    return -1;
80103d1d:	83 c4 10             	add    $0x10,%esp
	ndt->ustackp = 0;
80103d20:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103d27:	00 00 00 
    np->state = UNUSED;
80103d2a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	ndt->state = UNUSED;
80103d31:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
    return -1;
80103d38:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d3d:	eb b8                	jmp    80103cf7 <fork+0x107>
80103d3f:	90                   	nop

80103d40 <scheduler>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	57                   	push   %edi
80103d44:	56                   	push   %esi
80103d45:	53                   	push   %ebx
80103d46:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103d49:	e8 72 fc ff ff       	call   801039c0 <mycpu>
  c->proc = 0;
80103d4e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d55:	00 00 00 
  struct cpu *c = mycpu();
80103d58:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d5a:	8d 40 04             	lea    0x4(%eax),%eax
80103d5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103d60:	fb                   	sti    
    acquire(&ptable.lock);
80103d61:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d64:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
    acquire(&ptable.lock);
80103d69:	68 20 2d 11 80       	push   $0x80112d20
80103d6e:	e8 3d 10 00 00       	call   80104db0 <acquire>
80103d73:	83 c4 10             	add    $0x10,%esp
80103d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d7d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103d80:	83 7f 08 03          	cmpl   $0x3,0x8(%edi)
80103d84:	75 6f                	jne    80103df5 <scheduler+0xb5>
      c->proc = p;
80103d86:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
int
tscheduler(struct proc* p)
{
  int next = -1;
  int i;
  for(i= p->curtidx + 1; i < NTHREAD; i++){
80103d8c:	8b 8f 6c 08 00 00    	mov    0x86c(%edi),%ecx
80103d92:	8d 59 01             	lea    0x1(%ecx),%ebx
80103d95:	83 fb 3f             	cmp    $0x3f,%ebx
80103d98:	7e 0e                	jle    80103da8 <scheduler+0x68>
80103d9a:	e9 81 00 00 00       	jmp    80103e20 <scheduler+0xe0>
80103d9f:	90                   	nop
80103da0:	83 c3 01             	add    $0x1,%ebx
80103da3:	83 fb 40             	cmp    $0x40,%ebx
80103da6:	74 78                	je     80103e20 <scheduler+0xe0>
	if(p->threads[i].state == RUNNABLE){
80103da8:	89 d8                	mov    %ebx,%eax
80103daa:	c1 e0 05             	shl    $0x5,%eax
80103dad:	83 7c 07 6c 03       	cmpl   $0x3,0x6c(%edi,%eax,1)
80103db2:	75 ec                	jne    80103da0 <scheduler+0x60>
	  break;
	}
  }

  // still not found
  if(next == -1){
80103db4:	83 fb ff             	cmp    $0xffffffff,%ebx
80103db7:	74 67                	je     80103e20 <scheduler+0xe0>
      switchuvm(p);
80103db9:	83 ec 0c             	sub    $0xc,%esp
	  p->curtidx = next;
80103dbc:	89 9f 6c 08 00 00    	mov    %ebx,0x86c(%edi)
      switchuvm(p);
80103dc2:	57                   	push   %edi
80103dc3:	e8 38 35 00 00       	call   80107300 <switchuvm>
	  t->state = RUNNING;
80103dc8:	89 d8                	mov    %ebx,%eax
      swtch(&(c->scheduler), t->context);
80103dca:	5a                   	pop    %edx
80103dcb:	59                   	pop    %ecx
	  t->state = RUNNING;
80103dcc:	c1 e0 05             	shl    $0x5,%eax
      swtch(&(c->scheduler), t->context);
80103dcf:	ff 74 07 7c          	push   0x7c(%edi,%eax,1)
80103dd3:	ff 75 e4             	push   -0x1c(%ebp)
	  t->state = RUNNING;
80103dd6:	c7 44 38 6c 04 00 00 	movl   $0x4,0x6c(%eax,%edi,1)
80103ddd:	00 
      swtch(&(c->scheduler), t->context);
80103dde:	e8 a8 12 00 00       	call   8010508b <swtch>
      switchkvm();
80103de3:	e8 08 35 00 00       	call   801072f0 <switchkvm>
      c->proc = 0;
80103de8:	83 c4 10             	add    $0x10,%esp
80103deb:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103df2:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df5:	81 c7 70 08 00 00    	add    $0x870,%edi
80103dfb:	81 ff 54 49 13 80    	cmp    $0x80134954,%edi
80103e01:	0f 85 79 ff ff ff    	jne    80103d80 <scheduler+0x40>
    release(&ptable.lock);
80103e07:	83 ec 0c             	sub    $0xc,%esp
80103e0a:	68 20 2d 11 80       	push   $0x80112d20
80103e0f:	e8 3c 0f 00 00       	call   80104d50 <release>
    sti();
80103e14:	83 c4 10             	add    $0x10,%esp
80103e17:	e9 44 ff ff ff       	jmp    80103d60 <scheduler+0x20>
80103e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for(i = 0; i < p->curtidx + 1; i++){
80103e20:	85 c9                	test   %ecx,%ecx
80103e22:	78 d1                	js     80103df5 <scheduler+0xb5>
80103e24:	31 db                	xor    %ebx,%ebx
80103e26:	eb 0f                	jmp    80103e37 <scheduler+0xf7>
80103e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e2f:	90                   	nop
80103e30:	83 c3 01             	add    $0x1,%ebx
80103e33:	39 d9                	cmp    %ebx,%ecx
80103e35:	7c be                	jl     80103df5 <scheduler+0xb5>
	  if(p->threads[i].state == RUNNABLE){
80103e37:	89 d8                	mov    %ebx,%eax
80103e39:	c1 e0 05             	shl    $0x5,%eax
80103e3c:	83 7c 07 6c 03       	cmpl   $0x3,0x6c(%edi,%eax,1)
80103e41:	75 ed                	jne    80103e30 <scheduler+0xf0>
80103e43:	e9 71 ff ff ff       	jmp    80103db9 <scheduler+0x79>
80103e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e4f:	90                   	nop

80103e50 <sched>:
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	57                   	push   %edi
80103e54:	56                   	push   %esi
80103e55:	53                   	push   %ebx
80103e56:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103e59:	e8 02 0e 00 00       	call   80104c60 <pushcli>
  c = mycpu();
80103e5e:	e8 5d fb ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103e63:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e69:	e8 42 0e 00 00       	call   80104cb0 <popcli>
  if(!holding(&ptable.lock))
80103e6e:	83 ec 0c             	sub    $0xc,%esp
  struct thread *t = &p->threads[p->curtidx];
80103e71:	8b 9e 6c 08 00 00    	mov    0x86c(%esi),%ebx
  if(!holding(&ptable.lock))
80103e77:	68 20 2d 11 80       	push   $0x80112d20
80103e7c:	e8 8f 0e 00 00       	call   80104d10 <holding>
80103e81:	83 c4 10             	add    $0x10,%esp
80103e84:	85 c0                	test   %eax,%eax
80103e86:	74 5a                	je     80103ee2 <sched+0x92>
  if(mycpu()->ncli != 1)
80103e88:	e8 33 fb ff ff       	call   801039c0 <mycpu>
80103e8d:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e94:	75 73                	jne    80103f09 <sched+0xb9>
  if(t->state == RUNNING){
80103e96:	89 d8                	mov    %ebx,%eax
80103e98:	c1 e0 05             	shl    $0x5,%eax
80103e9b:	83 7c 30 6c 04       	cmpl   $0x4,0x6c(%eax,%esi,1)
80103ea0:	74 5a                	je     80103efc <sched+0xac>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ea2:	9c                   	pushf  
80103ea3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ea4:	f6 c4 02             	test   $0x2,%ah
80103ea7:	75 46                	jne    80103eef <sched+0x9f>
  intena = mycpu()->intena;
80103ea9:	e8 12 fb ff ff       	call   801039c0 <mycpu>
  swtch(&t->context, mycpu()->scheduler);
80103eae:	c1 e3 05             	shl    $0x5,%ebx
  intena = mycpu()->intena;
80103eb1:	8b b8 a8 00 00 00    	mov    0xa8(%eax),%edi
  swtch(&t->context, mycpu()->scheduler);
80103eb7:	e8 04 fb ff ff       	call   801039c0 <mycpu>
80103ebc:	83 ec 08             	sub    $0x8,%esp
80103ebf:	ff 70 04             	push   0x4(%eax)
80103ec2:	8d 44 1e 7c          	lea    0x7c(%esi,%ebx,1),%eax
80103ec6:	50                   	push   %eax
80103ec7:	e8 bf 11 00 00       	call   8010508b <swtch>
  mycpu()->intena = intena;
80103ecc:	e8 ef fa ff ff       	call   801039c0 <mycpu>
}
80103ed1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ed4:	89 b8 a8 00 00 00    	mov    %edi,0xa8(%eax)
}
80103eda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103edd:	5b                   	pop    %ebx
80103ede:	5e                   	pop    %esi
80103edf:	5f                   	pop    %edi
80103ee0:	5d                   	pop    %ebp
80103ee1:	c3                   	ret    
    panic("sched ptable.lock");
80103ee2:	83 ec 0c             	sub    $0xc,%esp
80103ee5:	68 5b 80 10 80       	push   $0x8010805b
80103eea:	e8 91 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103eef:	83 ec 0c             	sub    $0xc,%esp
80103ef2:	68 87 80 10 80       	push   $0x80108087
80103ef7:	e8 84 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103efc:	83 ec 0c             	sub    $0xc,%esp
80103eff:	68 79 80 10 80       	push   $0x80108079
80103f04:	e8 77 c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103f09:	83 ec 0c             	sub    $0xc,%esp
80103f0c:	68 6d 80 10 80       	push   $0x8010806d
80103f11:	e8 6a c4 ff ff       	call   80100380 <panic>
80103f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f1d:	8d 76 00             	lea    0x0(%esi),%esi

80103f20 <exit>:
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	57                   	push   %edi
80103f24:	56                   	push   %esi
80103f25:	53                   	push   %ebx
80103f26:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103f29:	e8 12 fb ff ff       	call   80103a40 <myproc>
  if(curproc == initproc)
80103f2e:	39 05 54 49 13 80    	cmp    %eax,0x80134954
80103f34:	0f 84 47 01 00 00    	je     80104081 <exit+0x161>
80103f3a:	89 c3                	mov    %eax,%ebx
80103f3c:	8d 70 18             	lea    0x18(%eax),%esi
80103f3f:	8d 78 58             	lea    0x58(%eax),%edi
    if(curproc->ofile[fd]){
80103f42:	8b 06                	mov    (%esi),%eax
80103f44:	85 c0                	test   %eax,%eax
80103f46:	74 12                	je     80103f5a <exit+0x3a>
      fileclose(curproc->ofile[fd]);
80103f48:	83 ec 0c             	sub    $0xc,%esp
80103f4b:	50                   	push   %eax
80103f4c:	e8 ff cf ff ff       	call   80100f50 <fileclose>
      curproc->ofile[fd] = 0;
80103f51:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f57:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f5a:	83 c6 04             	add    $0x4,%esi
80103f5d:	39 fe                	cmp    %edi,%esi
80103f5f:	75 e1                	jne    80103f42 <exit+0x22>
  begin_op();
80103f61:	e8 5a ee ff ff       	call   80102dc0 <begin_op>
  iput(curproc->cwd);
80103f66:	83 ec 0c             	sub    $0xc,%esp
80103f69:	ff 73 58             	push   0x58(%ebx)
80103f6c:	e8 9f d9 ff ff       	call   80101910 <iput>
  end_op();
80103f71:	e8 ba ee ff ff       	call   80102e30 <end_op>
  curproc->cwd = 0;
80103f76:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  acquire(&ptable.lock);
80103f7d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f84:	e8 27 0e 00 00       	call   80104db0 <acquire>
  wakeup1(curproc->parent);
80103f89:	8b 4b 10             	mov    0x10(%ebx),%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f8c:	83 c4 10             	add    $0x10,%esp
  wakeup1(curproc->parent);
80103f8f:	ba c0 35 11 80       	mov    $0x801135c0,%edx
	for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80103f94:	8d 82 00 f8 ff ff    	lea    -0x800(%edx),%eax
80103f9a:	eb 0b                	jmp    80103fa7 <exit+0x87>
80103f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fa0:	83 c0 20             	add    $0x20,%eax
80103fa3:	39 d0                	cmp    %edx,%eax
80103fa5:	74 17                	je     80103fbe <exit+0x9e>
      if(t->state == SLEEPING && t->chan == chan){
80103fa7:	83 38 02             	cmpl   $0x2,(%eax)
80103faa:	75 f4                	jne    80103fa0 <exit+0x80>
80103fac:	3b 48 18             	cmp    0x18(%eax),%ecx
80103faf:	75 ef                	jne    80103fa0 <exit+0x80>
      	t->state = RUNNABLE;
80103fb1:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
	for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80103fb7:	83 c0 20             	add    $0x20,%eax
80103fba:	39 d0                	cmp    %edx,%eax
80103fbc:	75 e9                	jne    80103fa7 <exit+0x87>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fbe:	8d 90 70 08 00 00    	lea    0x870(%eax),%edx
80103fc4:	3d 50 49 13 80       	cmp    $0x80134950,%eax
80103fc9:	75 c9                	jne    80103f94 <exit+0x74>
      p->parent = initproc;
80103fcb:	8b 0d 54 49 13 80    	mov    0x80134954,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fd1:	be 54 2d 11 80       	mov    $0x80112d54,%esi
80103fd6:	eb 0e                	jmp    80103fe6 <exit+0xc6>
80103fd8:	81 c6 70 08 00 00    	add    $0x870,%esi
80103fde:	81 fe 54 49 13 80    	cmp    $0x80134954,%esi
80103fe4:	74 66                	je     8010404c <exit+0x12c>
    if(p->parent == curproc){
80103fe6:	39 5e 10             	cmp    %ebx,0x10(%esi)
80103fe9:	75 ed                	jne    80103fd8 <exit+0xb8>
      if(p->state == ZOMBIE)
80103feb:	83 7e 08 05          	cmpl   $0x5,0x8(%esi)
      p->parent = initproc;
80103fef:	89 4e 10             	mov    %ecx,0x10(%esi)
      if(p->state == ZOMBIE)
80103ff2:	75 e4                	jne    80103fd8 <exit+0xb8>
80103ff4:	ba c0 35 11 80       	mov    $0x801135c0,%edx
80103ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80104000:	8d 82 00 f8 ff ff    	lea    -0x800(%edx),%eax
80104006:	eb 0f                	jmp    80104017 <exit+0xf7>
80104008:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010400f:	90                   	nop
80104010:	83 c0 20             	add    $0x20,%eax
80104013:	39 d0                	cmp    %edx,%eax
80104015:	74 19                	je     80104030 <exit+0x110>
      if(t->state == SLEEPING && t->chan == chan){
80104017:	83 38 02             	cmpl   $0x2,(%eax)
8010401a:	75 f4                	jne    80104010 <exit+0xf0>
8010401c:	3b 48 18             	cmp    0x18(%eax),%ecx
8010401f:	75 ef                	jne    80104010 <exit+0xf0>
      	t->state = RUNNABLE;
80104021:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
	for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80104027:	83 c0 20             	add    $0x20,%eax
8010402a:	39 d0                	cmp    %edx,%eax
8010402c:	75 e9                	jne    80104017 <exit+0xf7>
8010402e:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104030:	81 c2 70 08 00 00    	add    $0x870,%edx
80104036:	81 fa c0 51 13 80    	cmp    $0x801351c0,%edx
8010403c:	75 c2                	jne    80104000 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010403e:	81 c6 70 08 00 00    	add    $0x870,%esi
80104044:	81 fe 54 49 13 80    	cmp    $0x80134954,%esi
8010404a:	75 9a                	jne    80103fe6 <exit+0xc6>
  for(t = curproc->threads; t < &curproc->threads[NTHREAD]; t++){
8010404c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010404f:	8d 93 6c 08 00 00    	lea    0x86c(%ebx),%edx
	if(t->state != UNUSED)
80104055:	8b 08                	mov    (%eax),%ecx
80104057:	85 c9                	test   %ecx,%ecx
80104059:	74 06                	je     80104061 <exit+0x141>
	  t->state = ZOMBIE;
8010405b:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  for(t = curproc->threads; t < &curproc->threads[NTHREAD]; t++){
80104061:	83 c0 20             	add    $0x20,%eax
80104064:	39 d0                	cmp    %edx,%eax
80104066:	75 ed                	jne    80104055 <exit+0x135>
  curproc->state = ZOMBIE;
80104068:	c7 43 08 05 00 00 00 	movl   $0x5,0x8(%ebx)
  sched();
8010406f:	e8 dc fd ff ff       	call   80103e50 <sched>
  panic("zombie exit");
80104074:	83 ec 0c             	sub    $0xc,%esp
80104077:	68 a8 80 10 80       	push   $0x801080a8
8010407c:	e8 ff c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104081:	83 ec 0c             	sub    $0xc,%esp
80104084:	68 9b 80 10 80       	push   $0x8010809b
80104089:	e8 f2 c2 ff ff       	call   80100380 <panic>
8010408e:	66 90                	xchg   %ax,%ax

80104090 <wait>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104099:	e8 c2 0b 00 00       	call   80104c60 <pushcli>
  c = mycpu();
8010409e:	e8 1d f9 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
801040a3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040a9:	e8 02 0c 00 00       	call   80104cb0 <popcli>
  acquire(&ptable.lock);
801040ae:	83 ec 0c             	sub    $0xc,%esp
801040b1:	68 20 2d 11 80       	push   $0x80112d20
801040b6:	e8 f5 0c 00 00       	call   80104db0 <acquire>
801040bb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040be:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040c0:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
801040c5:	eb 17                	jmp    801040de <wait+0x4e>
801040c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ce:	66 90                	xchg   %ax,%ax
801040d0:	81 c7 70 08 00 00    	add    $0x870,%edi
801040d6:	81 ff 54 49 13 80    	cmp    $0x80134954,%edi
801040dc:	74 1e                	je     801040fc <wait+0x6c>
      if(p->parent != curproc)
801040de:	39 5f 10             	cmp    %ebx,0x10(%edi)
801040e1:	75 ed                	jne    801040d0 <wait+0x40>
      if(p->state == ZOMBIE){
801040e3:	83 7f 08 05          	cmpl   $0x5,0x8(%edi)
801040e7:	74 77                	je     80104160 <wait+0xd0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040e9:	81 c7 70 08 00 00    	add    $0x870,%edi
      havekids = 1;
801040ef:	ba 01 00 00 00       	mov    $0x1,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040f4:	81 ff 54 49 13 80    	cmp    $0x80134954,%edi
801040fa:	75 e2                	jne    801040de <wait+0x4e>
    if(!havekids || curproc->killed){
801040fc:	85 d2                	test   %edx,%edx
801040fe:	0f 84 21 01 00 00    	je     80104225 <wait+0x195>
80104104:	8b 43 14             	mov    0x14(%ebx),%eax
80104107:	85 c0                	test   %eax,%eax
80104109:	0f 85 16 01 00 00    	jne    80104225 <wait+0x195>
  pushcli();
8010410f:	e8 4c 0b 00 00       	call   80104c60 <pushcli>
  c = mycpu();
80104114:	e8 a7 f8 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80104119:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
8010411f:	e8 8c 0b 00 00       	call   80104cb0 <popcli>
  if(p == 0)
80104124:	85 ff                	test   %edi,%edi
80104126:	0f 84 12 01 00 00    	je     8010423e <wait+0x1ae>
  struct thread *t = &p->threads[p->curtidx];
8010412c:	8b 87 6c 08 00 00    	mov    0x86c(%edi),%eax
  t->chan = chan;
80104132:	89 c6                	mov    %eax,%esi
  t->state = SLEEPING;
80104134:	c1 e0 05             	shl    $0x5,%eax
  t->chan = chan;
80104137:	c1 e6 05             	shl    $0x5,%esi
8010413a:	01 fe                	add    %edi,%esi
8010413c:	89 9e 84 00 00 00    	mov    %ebx,0x84(%esi)
  t->state = SLEEPING;
80104142:	c7 44 38 6c 02 00 00 	movl   $0x2,0x6c(%eax,%edi,1)
80104149:	00 
  sched();
8010414a:	e8 01 fd ff ff       	call   80103e50 <sched>
  t->chan = 0;
8010414f:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
80104156:	00 00 00 
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104159:	e9 60 ff ff ff       	jmp    801040be <wait+0x2e>
8010415e:	66 90                	xchg   %ax,%ax
        pid = p->pid;
80104160:	8b 47 0c             	mov    0xc(%edi),%eax
80104163:	8d 5f 6c             	lea    0x6c(%edi),%ebx
80104166:	8d b7 6c 08 00 00    	lea    0x86c(%edi),%esi
8010416c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(int i = 0; i < NTHREAD; i++){
8010416f:	eb 43                	jmp    801041b4 <wait+0x124>
80104171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(t->kstack == 0){
	cprintf("tclear(): kstack not found\n");
	return 0;
  }

  kfree(t->kstack);
80104178:	83 ec 0c             	sub    $0xc,%esp
8010417b:	52                   	push   %edx
8010417c:	e8 9f e3 ff ff       	call   80102520 <kfree>
  t->kstack = 0;
80104181:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  t->ustackp = 0;
  t->tid = 0;
  t->state = UNUSED;
  t->chan = 0;
  t->ret = 0;
80104188:	83 c4 10             	add    $0x10,%esp
  t->ustackp = 0;
8010418b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  t->tid = 0;
80104192:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  t->state = UNUSED;
80104199:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  t->chan = 0;
8010419f:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
  t->ret = 0;
801041a6:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
		for(int i = 0; i < NTHREAD; i++){
801041ad:	83 c3 20             	add    $0x20,%ebx
801041b0:	39 f3                	cmp    %esi,%ebx
801041b2:	74 2c                	je     801041e0 <wait+0x150>
  if(t->state == UNUSED)
801041b4:	8b 13                	mov    (%ebx),%edx
801041b6:	85 d2                	test   %edx,%edx
801041b8:	74 f3                	je     801041ad <wait+0x11d>
  if(t->kstack == 0){
801041ba:	8b 53 08             	mov    0x8(%ebx),%edx
801041bd:	85 d2                	test   %edx,%edx
801041bf:	75 b7                	jne    80104178 <wait+0xe8>
	cprintf("tclear(): kstack not found\n");
801041c1:	83 ec 0c             	sub    $0xc,%esp
801041c4:	68 b4 80 10 80       	push   $0x801080b4
801041c9:	e8 d2 c4 ff ff       	call   801006a0 <cprintf>
			  panic("wait(): tclear error\n");
801041ce:	c7 04 24 d0 80 10 80 	movl   $0x801080d0,(%esp)
801041d5:	e8 a6 c1 ff ff       	call   80100380 <panic>
801041da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        freevm(p->pgdir); // t->ustack are also freed
801041e0:	83 ec 0c             	sub    $0xc,%esp
801041e3:	ff 77 04             	push   0x4(%edi)
801041e6:	e8 f5 34 00 00       	call   801076e0 <freevm>
        p->pid = 0;
801041eb:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
        p->parent = 0;
801041f2:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
        p->name[0] = 0;
801041f9:	c6 47 5c 00          	movb   $0x0,0x5c(%edi)
        p->killed = 0;
801041fd:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
        p->state = UNUSED;
80104204:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
        release(&ptable.lock);
8010420b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104212:	e8 39 0b 00 00       	call   80104d50 <release>
        return pid;
80104217:	83 c4 10             	add    $0x10,%esp
}
8010421a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010421d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104220:	5b                   	pop    %ebx
80104221:	5e                   	pop    %esi
80104222:	5f                   	pop    %edi
80104223:	5d                   	pop    %ebp
80104224:	c3                   	ret    
      release(&ptable.lock);
80104225:	83 ec 0c             	sub    $0xc,%esp
80104228:	68 20 2d 11 80       	push   $0x80112d20
8010422d:	e8 1e 0b 00 00       	call   80104d50 <release>
      return -1;
80104232:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80104239:	83 c4 10             	add    $0x10,%esp
8010423c:	eb dc                	jmp    8010421a <wait+0x18a>
    panic("sleep (p)");
8010423e:	83 ec 0c             	sub    $0xc,%esp
80104241:	68 e6 80 10 80       	push   $0x801080e6
80104246:	e8 35 c1 ff ff       	call   80100380 <panic>
8010424b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010424f:	90                   	nop

80104250 <yield>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	56                   	push   %esi
80104254:	53                   	push   %ebx
  acquire(&ptable.lock);  //DOC: yieldlock
80104255:	83 ec 0c             	sub    $0xc,%esp
80104258:	68 20 2d 11 80       	push   $0x80112d20
8010425d:	e8 4e 0b 00 00       	call   80104db0 <acquire>
  pushcli();
80104262:	e8 f9 09 00 00       	call   80104c60 <pushcli>
  c = mycpu();
80104267:	e8 54 f7 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
8010426c:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104272:	e8 39 0a 00 00       	call   80104cb0 <popcli>
  pushcli();
80104277:	e8 e4 09 00 00       	call   80104c60 <pushcli>
  c = mycpu();
8010427c:	e8 3f f7 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80104281:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104287:	e8 24 0a 00 00       	call   80104cb0 <popcli>
  struct thread *t = &myproc()->threads[myproc()->curtidx];
8010428c:	8b 86 6c 08 00 00    	mov    0x86c(%esi),%eax
  t->state = RUNNABLE;
80104292:	c1 e0 05             	shl    $0x5,%eax
80104295:	c7 44 18 6c 03 00 00 	movl   $0x3,0x6c(%eax,%ebx,1)
8010429c:	00 
  pushcli();
8010429d:	e8 be 09 00 00       	call   80104c60 <pushcli>
  c = mycpu();
801042a2:	e8 19 f7 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
801042a7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042ad:	e8 fe 09 00 00       	call   80104cb0 <popcli>
  myproc()->state = RUNNABLE;
801042b2:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
  sched();
801042b9:	e8 92 fb ff ff       	call   80103e50 <sched>
  release(&ptable.lock);
801042be:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801042c5:	e8 86 0a 00 00       	call   80104d50 <release>
}
801042ca:	83 c4 10             	add    $0x10,%esp
801042cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042d0:	5b                   	pop    %ebx
801042d1:	5e                   	pop    %esi
801042d2:	5d                   	pop    %ebp
801042d3:	c3                   	ret    
801042d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042df:	90                   	nop

801042e0 <sleep>:
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	57                   	push   %edi
801042e4:	56                   	push   %esi
801042e5:	53                   	push   %ebx
801042e6:	83 ec 1c             	sub    $0x1c,%esp
801042e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801042ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801042ef:	e8 6c 09 00 00       	call   80104c60 <pushcli>
  c = mycpu();
801042f4:	e8 c7 f6 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
801042f9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042ff:	e8 ac 09 00 00       	call   80104cb0 <popcli>
  if(p == 0)
80104304:	85 db                	test   %ebx,%ebx
80104306:	0f 84 c0 00 00 00    	je     801043cc <sleep+0xec>
  struct thread *t = &p->threads[p->curtidx];
8010430c:	8b 83 6c 08 00 00    	mov    0x86c(%ebx),%eax
  if(lk == 0)
80104312:	85 f6                	test   %esi,%esi
80104314:	0f 84 a5 00 00 00    	je     801043bf <sleep+0xdf>
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010431a:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104320:	74 6e                	je     80104390 <sleep+0xb0>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104322:	83 ec 0c             	sub    $0xc,%esp
80104325:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104328:	68 20 2d 11 80       	push   $0x80112d20
8010432d:	e8 7e 0a 00 00       	call   80104db0 <acquire>
    release(lk);
80104332:	89 34 24             	mov    %esi,(%esp)
80104335:	e8 16 0a 00 00       	call   80104d50 <release>
  t->chan = chan;
8010433a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010433d:	89 c2                	mov    %eax,%edx
  t->state = SLEEPING;
8010433f:	c1 e0 05             	shl    $0x5,%eax
  t->chan = chan;
80104342:	c1 e2 05             	shl    $0x5,%edx
80104345:	01 da                	add    %ebx,%edx
80104347:	89 ba 84 00 00 00    	mov    %edi,0x84(%edx)
  t->state = SLEEPING;
8010434d:	c7 44 18 6c 02 00 00 	movl   $0x2,0x6c(%eax,%ebx,1)
80104354:	00 
  t->chan = chan;
80104355:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  sched();
80104358:	e8 f3 fa ff ff       	call   80103e50 <sched>
  t->chan = 0;
8010435d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104360:	c7 82 84 00 00 00 00 	movl   $0x0,0x84(%edx)
80104367:	00 00 00 
    release(&ptable.lock);
8010436a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104371:	e8 da 09 00 00       	call   80104d50 <release>
    acquire(lk);
80104376:	89 75 08             	mov    %esi,0x8(%ebp)
80104379:	83 c4 10             	add    $0x10,%esp
}
8010437c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010437f:	5b                   	pop    %ebx
80104380:	5e                   	pop    %esi
80104381:	5f                   	pop    %edi
80104382:	5d                   	pop    %ebp
    acquire(lk);
80104383:	e9 28 0a 00 00       	jmp    80104db0 <acquire>
80104388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010438f:	90                   	nop
  t->chan = chan;
80104390:	89 c6                	mov    %eax,%esi
  t->state = SLEEPING;
80104392:	c1 e0 05             	shl    $0x5,%eax
  t->chan = chan;
80104395:	c1 e6 05             	shl    $0x5,%esi
80104398:	01 de                	add    %ebx,%esi
8010439a:	89 be 84 00 00 00    	mov    %edi,0x84(%esi)
  t->state = SLEEPING;
801043a0:	c7 44 18 6c 02 00 00 	movl   $0x2,0x6c(%eax,%ebx,1)
801043a7:	00 
  sched();
801043a8:	e8 a3 fa ff ff       	call   80103e50 <sched>
  t->chan = 0;
801043ad:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
801043b4:	00 00 00 
}
801043b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043ba:	5b                   	pop    %ebx
801043bb:	5e                   	pop    %esi
801043bc:	5f                   	pop    %edi
801043bd:	5d                   	pop    %ebp
801043be:	c3                   	ret    
    panic("sleep without lk");
801043bf:	83 ec 0c             	sub    $0xc,%esp
801043c2:	68 f0 80 10 80       	push   $0x801080f0
801043c7:	e8 b4 bf ff ff       	call   80100380 <panic>
    panic("sleep (p)");
801043cc:	83 ec 0c             	sub    $0xc,%esp
801043cf:	68 e6 80 10 80       	push   $0x801080e6
801043d4:	e8 a7 bf ff ff       	call   80100380 <panic>
801043d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043e0 <wakeup>:
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	53                   	push   %ebx
801043e4:	83 ec 10             	sub    $0x10,%esp
801043e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043ea:	68 20 2d 11 80       	push   $0x80112d20
801043ef:	e8 bc 09 00 00       	call   80104db0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043f4:	ba c0 35 11 80       	mov    $0x801135c0,%edx
801043f9:	83 c4 10             	add    $0x10,%esp
801043fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80104400:	8d 82 00 f8 ff ff    	lea    -0x800(%edx),%eax
80104406:	eb 0f                	jmp    80104417 <wakeup+0x37>
80104408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010440f:	90                   	nop
80104410:	83 c0 20             	add    $0x20,%eax
80104413:	39 d0                	cmp    %edx,%eax
80104415:	74 19                	je     80104430 <wakeup+0x50>
      if(t->state == SLEEPING && t->chan == chan){
80104417:	83 38 02             	cmpl   $0x2,(%eax)
8010441a:	75 f4                	jne    80104410 <wakeup+0x30>
8010441c:	3b 58 18             	cmp    0x18(%eax),%ebx
8010441f:	75 ef                	jne    80104410 <wakeup+0x30>
      	t->state = RUNNABLE;
80104421:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
	for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80104427:	83 c0 20             	add    $0x20,%eax
8010442a:	39 d0                	cmp    %edx,%eax
8010442c:	75 e9                	jne    80104417 <wakeup+0x37>
8010442e:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104430:	8d 90 70 08 00 00    	lea    0x870(%eax),%edx
80104436:	3d 50 49 13 80       	cmp    $0x80134950,%eax
8010443b:	75 c3                	jne    80104400 <wakeup+0x20>
  release(&ptable.lock);
8010443d:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104444:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104447:	c9                   	leave  
  release(&ptable.lock);
80104448:	e9 03 09 00 00       	jmp    80104d50 <release>
8010444d:	8d 76 00             	lea    0x0(%esi),%esi

80104450 <kill>:
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	53                   	push   %ebx
80104454:	83 ec 10             	sub    $0x10,%esp
80104457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010445a:	68 20 2d 11 80       	push   $0x80112d20
8010445f:	e8 4c 09 00 00       	call   80104db0 <acquire>
80104464:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104467:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
8010446c:	eb 10                	jmp    8010447e <kill+0x2e>
8010446e:	66 90                	xchg   %ax,%ax
80104470:	81 c2 70 08 00 00    	add    $0x870,%edx
80104476:	81 fa 54 49 13 80    	cmp    $0x80134954,%edx
8010447c:	74 43                	je     801044c1 <kill+0x71>
    if(p->pid == pid){
8010447e:	39 5a 0c             	cmp    %ebx,0xc(%edx)
80104481:	75 ed                	jne    80104470 <kill+0x20>
      p->killed = 1;
80104483:	c7 42 14 01 00 00 00 	movl   $0x1,0x14(%edx)
	  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
8010448a:	8d 42 6c             	lea    0x6c(%edx),%eax
8010448d:	81 c2 6c 08 00 00    	add    $0x86c,%edx
80104493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104497:	90                   	nop
		if(t->state == SLEEPING)
80104498:	83 38 02             	cmpl   $0x2,(%eax)
8010449b:	75 06                	jne    801044a3 <kill+0x53>
		  t->state = RUNNABLE;
8010449d:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
	  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
801044a3:	83 c0 20             	add    $0x20,%eax
801044a6:	39 c2                	cmp    %eax,%edx
801044a8:	75 ee                	jne    80104498 <kill+0x48>
      release(&ptable.lock);
801044aa:	83 ec 0c             	sub    $0xc,%esp
801044ad:	68 20 2d 11 80       	push   $0x80112d20
801044b2:	e8 99 08 00 00       	call   80104d50 <release>
}
801044b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801044ba:	83 c4 10             	add    $0x10,%esp
801044bd:	31 c0                	xor    %eax,%eax
}
801044bf:	c9                   	leave  
801044c0:	c3                   	ret    
  release(&ptable.lock);
801044c1:	83 ec 0c             	sub    $0xc,%esp
801044c4:	68 20 2d 11 80       	push   $0x80112d20
801044c9:	e8 82 08 00 00       	call   80104d50 <release>
}
801044ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801044d1:	83 c4 10             	add    $0x10,%esp
801044d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044d9:	c9                   	leave  
801044da:	c3                   	ret    
801044db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044df:	90                   	nop

801044e0 <procdump>:
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	57                   	push   %edi
801044e4:	56                   	push   %esi
801044e5:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044e6:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801044eb:	83 ec 3c             	sub    $0x3c,%esp
801044ee:	eb 22                	jmp    80104512 <procdump+0x32>
    cprintf("\n");
801044f0:	83 ec 0c             	sub    $0xc,%esp
801044f3:	68 ad 84 10 80       	push   $0x801084ad
801044f8:	e8 a3 c1 ff ff       	call   801006a0 <cprintf>
801044fd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104500:	81 c3 70 08 00 00    	add    $0x870,%ebx
80104506:	81 fb 54 49 13 80    	cmp    $0x80134954,%ebx
8010450c:	0f 84 9e 00 00 00    	je     801045b0 <procdump+0xd0>
    if(p->state == UNUSED)
80104512:	8b 43 08             	mov    0x8(%ebx),%eax
80104515:	85 c0                	test   %eax,%eax
80104517:	74 e7                	je     80104500 <procdump+0x20>
	t = &p->threads[p->curtidx];
80104519:	8b bb 6c 08 00 00    	mov    0x86c(%ebx),%edi
      state = "???";
8010451f:	b8 01 81 10 80       	mov    $0x80108101,%eax
80104524:	89 fe                	mov    %edi,%esi
80104526:	c1 e6 05             	shl    $0x5,%esi
80104529:	01 de                	add    %ebx,%esi
    if(t->state >= 0 && t->state < NELEM(states) && states[t->state])
8010452b:	8b 56 6c             	mov    0x6c(%esi),%edx
8010452e:	83 fa 05             	cmp    $0x5,%edx
80104531:	77 11                	ja     80104544 <procdump+0x64>
80104533:	8b 04 95 a0 81 10 80 	mov    -0x7fef7e60(,%edx,4),%eax
      state = "???";
8010453a:	ba 01 81 10 80       	mov    $0x80108101,%edx
8010453f:	85 c0                	test   %eax,%eax
80104541:	0f 44 c2             	cmove  %edx,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
80104544:	8d 53 5c             	lea    0x5c(%ebx),%edx
80104547:	52                   	push   %edx
80104548:	50                   	push   %eax
80104549:	ff 73 0c             	push   0xc(%ebx)
8010454c:	68 05 81 10 80       	push   $0x80108105
80104551:	e8 4a c1 ff ff       	call   801006a0 <cprintf>
    if(t->state == SLEEPING){
80104556:	83 c4 10             	add    $0x10,%esp
80104559:	83 7e 6c 02          	cmpl   $0x2,0x6c(%esi)
8010455d:	75 91                	jne    801044f0 <procdump+0x10>
      getcallerpcs((uint*)t->context->ebp+2, pc);
8010455f:	83 ec 08             	sub    $0x8,%esp
80104562:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104565:	c1 e7 05             	shl    $0x5,%edi
80104568:	8d 75 c0             	lea    -0x40(%ebp),%esi
8010456b:	50                   	push   %eax
8010456c:	8b 44 3b 7c          	mov    0x7c(%ebx,%edi,1),%eax
80104570:	8b 40 0c             	mov    0xc(%eax),%eax
80104573:	83 c0 08             	add    $0x8,%eax
80104576:	50                   	push   %eax
80104577:	e8 84 06 00 00       	call   80104c00 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010457c:	83 c4 10             	add    $0x10,%esp
8010457f:	90                   	nop
80104580:	8b 06                	mov    (%esi),%eax
80104582:	85 c0                	test   %eax,%eax
80104584:	0f 84 66 ff ff ff    	je     801044f0 <procdump+0x10>
        cprintf(" %p", pc[i]);
8010458a:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010458d:	83 c6 04             	add    $0x4,%esi
        cprintf(" %p", pc[i]);
80104590:	50                   	push   %eax
80104591:	68 01 7b 10 80       	push   $0x80107b01
80104596:	e8 05 c1 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010459b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010459e:	83 c4 10             	add    $0x10,%esp
801045a1:	39 f0                	cmp    %esi,%eax
801045a3:	75 db                	jne    80104580 <procdump+0xa0>
801045a5:	e9 46 ff ff ff       	jmp    801044f0 <procdump+0x10>
801045aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
801045b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045b3:	5b                   	pop    %ebx
801045b4:	5e                   	pop    %esi
801045b5:	5f                   	pop    %edi
801045b6:	5d                   	pop    %ebp
801045b7:	c3                   	ret    
801045b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045bf:	90                   	nop

801045c0 <thread_create>:
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	57                   	push   %edi
801045c4:	56                   	push   %esi
801045c5:	53                   	push   %ebx
801045c6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801045c9:	e8 92 06 00 00       	call   80104c60 <pushcli>
  c = mycpu();
801045ce:	e8 ed f3 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
801045d3:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
801045d9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  for(nt = p->threads; nt < &p->threads[NTHREAD]; nt++){
801045dc:	8d 5f 6c             	lea    0x6c(%edi),%ebx
  popcli();
801045df:	e8 cc 06 00 00       	call   80104cb0 <popcli>
  acquire(&ptable.lock);
801045e4:	83 ec 0c             	sub    $0xc,%esp
801045e7:	68 20 2d 11 80       	push   $0x80112d20
801045ec:	e8 bf 07 00 00       	call   80104db0 <acquire>
  for(nt = p->threads; nt < &p->threads[NTHREAD]; nt++){
801045f1:	89 f8                	mov    %edi,%eax
801045f3:	83 c4 10             	add    $0x10,%esp
801045f6:	05 6c 08 00 00       	add    $0x86c,%eax
801045fb:	eb 0e                	jmp    8010460b <thread_create+0x4b>
801045fd:	8d 76 00             	lea    0x0(%esi),%esi
80104600:	83 c3 20             	add    $0x20,%ebx
80104603:	39 c3                	cmp    %eax,%ebx
80104605:	0f 84 5c 01 00 00    	je     80104767 <thread_create+0x1a7>
	if(nt->state == UNUSED)
8010460b:	8b 13                	mov    (%ebx),%edx
8010460d:	85 d2                	test   %edx,%edx
8010460f:	75 ef                	jne    80104600 <thread_create+0x40>
  nt->state = EMBRYO;
80104611:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  nt->tid = nexttid++;
80104617:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  release(&ptable.lock);
8010461c:	83 ec 0c             	sub    $0xc,%esp
  nt->tid = nexttid++;
8010461f:	89 43 04             	mov    %eax,0x4(%ebx)
80104622:	8d 48 01             	lea    0x1(%eax),%ecx
  release(&ptable.lock);
80104625:	68 20 2d 11 80       	push   $0x80112d20
  nt->tid = nexttid++;
8010462a:	89 0d 04 b0 10 80    	mov    %ecx,0x8010b004
  release(&ptable.lock);
80104630:	e8 1b 07 00 00       	call   80104d50 <release>
  if((nt->kstack = kalloc()) == 0){
80104635:	e8 a6 e0 ff ff       	call   801026e0 <kalloc>
8010463a:	83 c4 10             	add    $0x10,%esp
8010463d:	89 43 08             	mov    %eax,0x8(%ebx)
80104640:	85 c0                	test   %eax,%eax
80104642:	0f 84 3c 01 00 00    	je     80104784 <thread_create+0x1c4>
  *nt->tf = *p->threads[p->curtidx].tf;
80104648:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  sp -= sizeof *nt->tf;
8010464b:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(nt->context, 0, sizeof *nt->context);
80104651:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *nt->context;
80104654:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *nt->tf;
80104659:	89 53 0c             	mov    %edx,0xc(%ebx)
  *nt->tf = *p->threads[p->curtidx].tf;
8010465c:	8b 8f 6c 08 00 00    	mov    0x86c(%edi),%ecx
80104662:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80104665:	c1 e1 05             	shl    $0x5,%ecx
80104668:	8b 74 39 78          	mov    0x78(%ecx,%edi,1),%esi
8010466c:	89 d7                	mov    %edx,%edi
8010466e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104673:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  *(uint*)sp = (uint)trapret;
80104675:	c7 40 14 37 61 10 80 	movl   $0x80106137,0x14(%eax)
  nt->context = (struct context*)sp;
8010467c:	89 43 10             	mov    %eax,0x10(%ebx)
  memset(nt->context, 0, sizeof *nt->context);
8010467f:	6a 14                	push   $0x14
80104681:	6a 00                	push   $0x0
80104683:	50                   	push   %eax
80104684:	e8 e7 07 00 00       	call   80104e70 <memset>
  nt->context->eip = (uint)forkret;
80104689:	8b 43 10             	mov    0x10(%ebx),%eax
  uint sz = PGROUNDUP(p->sz);
8010468c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if((sz = allocuvm(p->pgdir, sz, sz + 2*PGSIZE)) == 0){
8010468f:	83 c4 0c             	add    $0xc,%esp
  nt->context->eip = (uint)forkret;
80104692:	c7 40 10 50 39 10 80 	movl   $0x80103950,0x10(%eax)
  uint sz = PGROUNDUP(p->sz);
80104699:	8b 07                	mov    (%edi),%eax
8010469b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010469e:	05 ff 0f 00 00       	add    $0xfff,%eax
801046a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(p->pgdir, sz, sz + 2*PGSIZE)) == 0){
801046a8:	8d 88 00 20 00 00    	lea    0x2000(%eax),%ecx
801046ae:	51                   	push   %ecx
801046af:	50                   	push   %eax
801046b0:	ff 77 04             	push   0x4(%edi)
801046b3:	e8 c8 2e 00 00       	call   80107580 <allocuvm>
801046b8:	83 c4 10             	add    $0x10,%esp
801046bb:	89 c6                	mov    %eax,%esi
801046bd:	85 c0                	test   %eax,%eax
801046bf:	74 54                	je     80104715 <thread_create+0x155>
  clearpteu(p->pgdir, (char*)(sz - 2*PGSIZE));
801046c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801046c4:	83 ec 08             	sub    $0x8,%esp
801046c7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
801046cd:	50                   	push   %eax
801046ce:	ff 77 04             	push   0x4(%edi)
801046d1:	e8 2a 31 00 00       	call   80107800 <clearpteu>
  *(uint*)sp = (uint)arg;
801046d6:	8b 45 10             	mov    0x10(%ebp),%eax
  nt->tf->eip = (uint)start_routine;
801046d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  return 0;
801046dc:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = 0xFFFFFFFF; // fake value
801046df:	c7 46 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%esi)
  *(uint*)sp = (uint)arg;
801046e6:	89 46 fc             	mov    %eax,-0x4(%esi)
  p->sz = sz;
801046e9:	89 37                	mov    %esi,(%edi)
  nt->tf->eip = (uint)start_routine;
801046eb:	8b 43 0c             	mov    0xc(%ebx),%eax
  nt->ustackp = sz;
801046ee:	89 73 14             	mov    %esi,0x14(%ebx)
  sp -= 4;
801046f1:	83 ee 08             	sub    $0x8,%esi
  nt->tf->eip = (uint)start_routine;
801046f4:	89 50 38             	mov    %edx,0x38(%eax)
  nt->tf->esp = (uint)sp;
801046f7:	8b 43 0c             	mov    0xc(%ebx),%eax
  sp -= 4;
801046fa:	89 70 44             	mov    %esi,0x44(%eax)
  *thread = nt->tid;
801046fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104700:	8b 53 04             	mov    0x4(%ebx),%edx
  nt->state = RUNNABLE;
80104703:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  *thread = nt->tid;
80104709:	89 10                	mov    %edx,(%eax)
}
8010470b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010470e:	31 c0                	xor    %eax,%eax
}
80104710:	5b                   	pop    %ebx
80104711:	5e                   	pop    %esi
80104712:	5f                   	pop    %edi
80104713:	5d                   	pop    %ebp
80104714:	c3                   	ret    
	cprintf("thread_create() fail\n");
80104715:	83 ec 0c             	sub    $0xc,%esp
80104718:	68 0e 81 10 80       	push   $0x8010810e
8010471d:	e8 7e bf ff ff       	call   801006a0 <cprintf>
  if(t->state == UNUSED)
80104722:	8b 03                	mov    (%ebx),%eax
80104724:	83 c4 10             	add    $0x10,%esp
80104727:	85 c0                	test   %eax,%eax
80104729:	74 3c                	je     80104767 <thread_create+0x1a7>
  if(t->kstack == 0){
8010472b:	8b 43 08             	mov    0x8(%ebx),%eax
8010472e:	85 c0                	test   %eax,%eax
80104730:	74 61                	je     80104793 <thread_create+0x1d3>
  kfree(t->kstack);
80104732:	83 ec 0c             	sub    $0xc,%esp
80104735:	50                   	push   %eax
80104736:	e8 e5 dd ff ff       	call   80102520 <kfree>
  t->kstack = 0;
8010473b:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)

  return 1;
80104742:	83 c4 10             	add    $0x10,%esp
  t->ustackp = 0;
80104745:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  t->tid = 0;
8010474c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  t->state = UNUSED;
80104753:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  t->chan = 0;
80104759:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
  t->ret = 0;
80104760:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
	release(&ptable.lock);
80104767:	83 ec 0c             	sub    $0xc,%esp
8010476a:	68 20 2d 11 80       	push   $0x80112d20
8010476f:	e8 dc 05 00 00       	call   80104d50 <release>
	return -1;
80104774:	83 c4 10             	add    $0x10,%esp
}
80104777:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return -1;
8010477a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010477f:	5b                   	pop    %ebx
80104780:	5e                   	pop    %esi
80104781:	5f                   	pop    %edi
80104782:	5d                   	pop    %ebp
80104783:	c3                   	ret    
	nt->tid = 0;
80104784:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	nt->state = UNUSED;
8010478b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104791:	eb d4                	jmp    80104767 <thread_create+0x1a7>
	cprintf("tclear(): kstack not found\n");
80104793:	83 ec 0c             	sub    $0xc,%esp
80104796:	68 b4 80 10 80       	push   $0x801080b4
8010479b:	e8 00 bf ff ff       	call   801006a0 <cprintf>
	return 0;
801047a0:	83 c4 10             	add    $0x10,%esp
801047a3:	eb c2                	jmp    80104767 <thread_create+0x1a7>
801047a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047b0 <thread_exit>:
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
801047b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801047b8:	e8 a3 04 00 00       	call   80104c60 <pushcli>
  c = mycpu();
801047bd:	e8 fe f1 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
801047c2:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801047c8:	e8 e3 04 00 00       	call   80104cb0 <popcli>
  acquire(&ptable.lock);
801047cd:	83 ec 0c             	sub    $0xc,%esp
801047d0:	68 20 2d 11 80       	push   $0x80112d20
801047d5:	e8 d6 05 00 00       	call   80104db0 <acquire>
  t->state = ZOMBIE;
801047da:	8b 96 6c 08 00 00    	mov    0x86c(%esi),%edx
801047e0:	83 c4 10             	add    $0x10,%esp
801047e3:	c1 e2 05             	shl    $0x5,%edx
801047e6:	8d 04 16             	lea    (%esi,%edx,1),%eax
801047e9:	ba c0 35 11 80       	mov    $0x801135c0,%edx
801047ee:	c7 40 6c 05 00 00 00 	movl   $0x5,0x6c(%eax)
  wakeup1((void*)t->tid);
801047f5:	8b 48 70             	mov    0x70(%eax),%ecx
  t->ret = retval;
801047f8:	89 98 88 00 00 00    	mov    %ebx,0x88(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047fe:	66 90                	xchg   %ax,%ax
	for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80104800:	8d 82 00 f8 ff ff    	lea    -0x800(%edx),%eax
80104806:	eb 0f                	jmp    80104817 <thread_exit+0x67>
80104808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010480f:	90                   	nop
80104810:	83 c0 20             	add    $0x20,%eax
80104813:	39 d0                	cmp    %edx,%eax
80104815:	74 19                	je     80104830 <thread_exit+0x80>
      if(t->state == SLEEPING && t->chan == chan){
80104817:	83 38 02             	cmpl   $0x2,(%eax)
8010481a:	75 f4                	jne    80104810 <thread_exit+0x60>
8010481c:	3b 48 18             	cmp    0x18(%eax),%ecx
8010481f:	75 ef                	jne    80104810 <thread_exit+0x60>
      	t->state = RUNNABLE;
80104821:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
	for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80104827:	83 c0 20             	add    $0x20,%eax
8010482a:	39 d0                	cmp    %edx,%eax
8010482c:	75 e9                	jne    80104817 <thread_exit+0x67>
8010482e:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104830:	8d 90 70 08 00 00    	lea    0x870(%eax),%edx
80104836:	3d 50 49 13 80       	cmp    $0x80134950,%eax
8010483b:	75 c3                	jne    80104800 <thread_exit+0x50>
}
8010483d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104840:	5b                   	pop    %ebx
80104841:	5e                   	pop    %esi
80104842:	5d                   	pop    %ebp
  sched();
80104843:	e9 08 f6 ff ff       	jmp    80103e50 <sched>
80104848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484f:	90                   	nop

80104850 <thread_join>:
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	57                   	push   %edi
80104854:	56                   	push   %esi
80104855:	53                   	push   %ebx
80104856:	83 ec 28             	sub    $0x28,%esp
80104859:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&ptable.lock);
8010485c:	68 20 2d 11 80       	push   $0x80112d20
80104861:	e8 4a 05 00 00       	call   80104db0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104866:	b8 c0 35 11 80       	mov    $0x801135c0,%eax
8010486b:	83 c4 10             	add    $0x10,%esp
	for(t = p->threads; t < &p->threads[NTHREAD]; t++)
8010486e:	8d 98 00 f8 ff ff    	lea    -0x800(%eax),%ebx
80104874:	eb 15                	jmp    8010488b <thread_join+0x3b>
80104876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010487d:	8d 76 00             	lea    0x0(%esi),%esi
80104880:	83 c3 20             	add    $0x20,%ebx
80104883:	39 c3                	cmp    %eax,%ebx
80104885:	0f 84 d5 00 00 00    	je     80104960 <thread_join+0x110>
	  if(t->tid == tid)
8010488b:	8b 73 04             	mov    0x4(%ebx),%esi
8010488e:	39 fe                	cmp    %edi,%esi
80104890:	75 ee                	jne    80104880 <thread_join+0x30>
  while(t->state != ZOMBIE)
80104892:	83 3b 05             	cmpl   $0x5,(%ebx)
80104895:	75 0c                	jne    801048a3 <thread_join+0x53>
80104897:	eb 5f                	jmp    801048f8 <thread_join+0xa8>
80104899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	sleep((void*)t->tid, &ptable.lock);
801048a0:	8b 73 04             	mov    0x4(%ebx),%esi
  pushcli();
801048a3:	e8 b8 03 00 00       	call   80104c60 <pushcli>
  c = mycpu();
801048a8:	e8 13 f1 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
801048ad:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801048b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  popcli();
801048b6:	e8 f5 03 00 00       	call   80104cb0 <popcli>
  if(p == 0)
801048bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801048be:	85 c0                	test   %eax,%eax
801048c0:	0f 84 e1 00 00 00    	je     801049a7 <thread_join+0x157>
  struct thread *t = &p->threads[p->curtidx];
801048c6:	8b 90 6c 08 00 00    	mov    0x86c(%eax),%edx
  t->chan = chan;
801048cc:	89 d7                	mov    %edx,%edi
  t->state = SLEEPING;
801048ce:	c1 e2 05             	shl    $0x5,%edx
  t->chan = chan;
801048d1:	c1 e7 05             	shl    $0x5,%edi
801048d4:	01 c7                	add    %eax,%edi
801048d6:	89 b7 84 00 00 00    	mov    %esi,0x84(%edi)
  t->state = SLEEPING;
801048dc:	c7 44 02 6c 02 00 00 	movl   $0x2,0x6c(%edx,%eax,1)
801048e3:	00 
  sched();
801048e4:	e8 67 f5 ff ff       	call   80103e50 <sched>
  t->chan = 0;
801048e9:	c7 87 84 00 00 00 00 	movl   $0x0,0x84(%edi)
801048f0:	00 00 00 
  while(t->state != ZOMBIE)
801048f3:	83 3b 05             	cmpl   $0x5,(%ebx)
801048f6:	75 a8                	jne    801048a0 <thread_join+0x50>
  *retval = t->ret;
801048f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801048fb:	8b 53 1c             	mov    0x1c(%ebx),%edx
801048fe:	89 10                	mov    %edx,(%eax)
  if(t->state == UNUSED)
80104900:	8b 03                	mov    (%ebx),%eax
80104902:	85 c0                	test   %eax,%eax
80104904:	74 40                	je     80104946 <thread_join+0xf6>
  if(t->kstack == 0){
80104906:	8b 43 08             	mov    0x8(%ebx),%eax
80104909:	85 c0                	test   %eax,%eax
8010490b:	0f 84 84 00 00 00    	je     80104995 <thread_join+0x145>
  kfree(t->kstack);
80104911:	83 ec 0c             	sub    $0xc,%esp
80104914:	50                   	push   %eax
80104915:	e8 06 dc ff ff       	call   80102520 <kfree>
  t->kstack = 0;
8010491a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  return 1;
80104921:	83 c4 10             	add    $0x10,%esp
  t->ustackp = 0;
80104924:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  t->tid = 0;
8010492b:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  t->state = UNUSED;
80104932:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  t->chan = 0;
80104938:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
  t->ret = 0;
8010493f:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
  release(&ptable.lock);
80104946:	83 ec 0c             	sub    $0xc,%esp
80104949:	68 20 2d 11 80       	push   $0x80112d20
8010494e:	e8 fd 03 00 00       	call   80104d50 <release>
  return 0;
80104953:	83 c4 10             	add    $0x10,%esp
80104956:	31 c0                	xor    %eax,%eax
}
80104958:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010495b:	5b                   	pop    %ebx
8010495c:	5e                   	pop    %esi
8010495d:	5f                   	pop    %edi
8010495e:	5d                   	pop    %ebp
8010495f:	c3                   	ret    
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104960:	8d 83 70 08 00 00    	lea    0x870(%ebx),%eax
80104966:	81 fb 50 49 13 80    	cmp    $0x80134950,%ebx
8010496c:	0f 85 fc fe ff ff    	jne    8010486e <thread_join+0x1e>
  release(&ptable.lock);
80104972:	83 ec 0c             	sub    $0xc,%esp
80104975:	68 20 2d 11 80       	push   $0x80112d20
8010497a:	e8 d1 03 00 00       	call   80104d50 <release>
  cprintf("thread_join() failed: tid not found\n");
8010497f:	c7 04 24 78 81 10 80 	movl   $0x80108178,(%esp)
80104986:	e8 15 bd ff ff       	call   801006a0 <cprintf>
  return -1;
8010498b:	83 c4 10             	add    $0x10,%esp
8010498e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104993:	eb c3                	jmp    80104958 <thread_join+0x108>
	cprintf("tclear(): kstack not found\n");
80104995:	83 ec 0c             	sub    $0xc,%esp
80104998:	68 b4 80 10 80       	push   $0x801080b4
8010499d:	e8 fe bc ff ff       	call   801006a0 <cprintf>
	return 0;
801049a2:	83 c4 10             	add    $0x10,%esp
801049a5:	eb 9f                	jmp    80104946 <thread_join+0xf6>
    panic("sleep (p)");
801049a7:	83 ec 0c             	sub    $0xc,%esp
801049aa:	68 e6 80 10 80       	push   $0x801080e6
801049af:	e8 cc b9 ff ff       	call   80100380 <panic>
801049b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049bf:	90                   	nop

801049c0 <tscheduler>:
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	53                   	push   %ebx
801049c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i= p->curtidx + 1; i < NTHREAD; i++){
801049c7:	8b 99 6c 08 00 00    	mov    0x86c(%ecx),%ebx
801049cd:	8d 43 01             	lea    0x1(%ebx),%eax
801049d0:	83 f8 3f             	cmp    $0x3f,%eax
801049d3:	7e 13                	jle    801049e8 <tscheduler+0x28>
801049d5:	eb 29                	jmp    80104a00 <tscheduler+0x40>
801049d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049de:	66 90                	xchg   %ax,%ax
801049e0:	83 c0 01             	add    $0x1,%eax
801049e3:	83 f8 40             	cmp    $0x40,%eax
801049e6:	74 18                	je     80104a00 <tscheduler+0x40>
	if(p->threads[i].state == RUNNABLE){
801049e8:	89 c2                	mov    %eax,%edx
801049ea:	c1 e2 05             	shl    $0x5,%edx
801049ed:	83 7c 11 6c 03       	cmpl   $0x3,0x6c(%ecx,%edx,1)
801049f2:	75 ec                	jne    801049e0 <tscheduler+0x20>
  if(next == -1){
801049f4:	83 f8 ff             	cmp    $0xffffffff,%eax
801049f7:	74 07                	je     80104a00 <tscheduler+0x40>
}
801049f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049fc:	c9                   	leave  
801049fd:	c3                   	ret    
801049fe:	66 90                	xchg   %ax,%ax
	for(i = 0; i < p->curtidx + 1; i++){
80104a00:	85 db                	test   %ebx,%ebx
80104a02:	78 1f                	js     80104a23 <tscheduler+0x63>
80104a04:	31 c0                	xor    %eax,%eax
80104a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi
	  if(p->threads[i].state == RUNNABLE){
80104a10:	89 c2                	mov    %eax,%edx
80104a12:	c1 e2 05             	shl    $0x5,%edx
80104a15:	83 7c 11 6c 03       	cmpl   $0x3,0x6c(%ecx,%edx,1)
80104a1a:	74 dd                	je     801049f9 <tscheduler+0x39>
	for(i = 0; i < p->curtidx + 1; i++){
80104a1c:	83 c0 01             	add    $0x1,%eax
80104a1f:	39 c3                	cmp    %eax,%ebx
80104a21:	7d ed                	jge    80104a10 <tscheduler+0x50>
}
80104a23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
	for(i = 0; i < p->curtidx + 1; i++){
80104a26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a2b:	c9                   	leave  
80104a2c:	c3                   	ret    
80104a2d:	8d 76 00             	lea    0x0(%esi),%esi

80104a30 <tclear>:
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
	return 1;
80104a34:	be 01 00 00 00       	mov    $0x1,%esi
{
80104a39:	53                   	push   %ebx
80104a3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(t->state == UNUSED)
80104a3d:	8b 03                	mov    (%ebx),%eax
80104a3f:	85 c0                	test   %eax,%eax
80104a41:	74 3c                	je     80104a7f <tclear+0x4f>
  if(t->kstack == 0){
80104a43:	8b 43 08             	mov    0x8(%ebx),%eax
80104a46:	85 c0                	test   %eax,%eax
80104a48:	74 46                	je     80104a90 <tclear+0x60>
  kfree(t->kstack);
80104a4a:	83 ec 0c             	sub    $0xc,%esp
80104a4d:	50                   	push   %eax
80104a4e:	e8 cd da ff ff       	call   80102520 <kfree>
  t->kstack = 0;
80104a53:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  return 1;
80104a5a:	83 c4 10             	add    $0x10,%esp
  t->ustackp = 0;
80104a5d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  t->tid = 0;
80104a64:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  t->state = UNUSED;
80104a6b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  t->chan = 0;
80104a71:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
  t->ret = 0;
80104a78:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
}
80104a7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a82:	89 f0                	mov    %esi,%eax
80104a84:	5b                   	pop    %ebx
80104a85:	5e                   	pop    %esi
80104a86:	5d                   	pop    %ebp
80104a87:	c3                   	ret    
80104a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8f:	90                   	nop
	cprintf("tclear(): kstack not found\n");
80104a90:	83 ec 0c             	sub    $0xc,%esp
	return 0;
80104a93:	31 f6                	xor    %esi,%esi
	cprintf("tclear(): kstack not found\n");
80104a95:	68 b4 80 10 80       	push   $0x801080b4
80104a9a:	e8 01 bc ff ff       	call   801006a0 <cprintf>
	return 0;
80104a9f:	83 c4 10             	add    $0x10,%esp
}
80104aa2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104aa5:	89 f0                	mov    %esi,%eax
80104aa7:	5b                   	pop    %ebx
80104aa8:	5e                   	pop    %esi
80104aa9:	5d                   	pop    %ebp
80104aaa:	c3                   	ret    
80104aab:	66 90                	xchg   %ax,%ax
80104aad:	66 90                	xchg   %ax,%ax
80104aaf:	90                   	nop

80104ab0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	53                   	push   %ebx
80104ab4:	83 ec 0c             	sub    $0xc,%esp
80104ab7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104aba:	68 b8 81 10 80       	push   $0x801081b8
80104abf:	8d 43 04             	lea    0x4(%ebx),%eax
80104ac2:	50                   	push   %eax
80104ac3:	e8 18 01 00 00       	call   80104be0 <initlock>
  lk->name = name;
80104ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104acb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104ad1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104ad4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104adb:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104ade:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ae1:	c9                   	leave  
80104ae2:	c3                   	ret    
80104ae3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104af0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
80104af5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104af8:	8d 73 04             	lea    0x4(%ebx),%esi
80104afb:	83 ec 0c             	sub    $0xc,%esp
80104afe:	56                   	push   %esi
80104aff:	e8 ac 02 00 00       	call   80104db0 <acquire>
  while (lk->locked) {
80104b04:	8b 13                	mov    (%ebx),%edx
80104b06:	83 c4 10             	add    $0x10,%esp
80104b09:	85 d2                	test   %edx,%edx
80104b0b:	74 16                	je     80104b23 <acquiresleep+0x33>
80104b0d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104b10:	83 ec 08             	sub    $0x8,%esp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
80104b15:	e8 c6 f7 ff ff       	call   801042e0 <sleep>
  while (lk->locked) {
80104b1a:	8b 03                	mov    (%ebx),%eax
80104b1c:	83 c4 10             	add    $0x10,%esp
80104b1f:	85 c0                	test   %eax,%eax
80104b21:	75 ed                	jne    80104b10 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104b23:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104b29:	e8 12 ef ff ff       	call   80103a40 <myproc>
80104b2e:	8b 40 0c             	mov    0xc(%eax),%eax
80104b31:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104b34:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104b37:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b3a:	5b                   	pop    %ebx
80104b3b:	5e                   	pop    %esi
80104b3c:	5d                   	pop    %ebp
  release(&lk->lk);
80104b3d:	e9 0e 02 00 00       	jmp    80104d50 <release>
80104b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b50 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	56                   	push   %esi
80104b54:	53                   	push   %ebx
80104b55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b58:	8d 73 04             	lea    0x4(%ebx),%esi
80104b5b:	83 ec 0c             	sub    $0xc,%esp
80104b5e:	56                   	push   %esi
80104b5f:	e8 4c 02 00 00       	call   80104db0 <acquire>
  lk->locked = 0;
80104b64:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b6a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104b71:	89 1c 24             	mov    %ebx,(%esp)
80104b74:	e8 67 f8 ff ff       	call   801043e0 <wakeup>
  release(&lk->lk);
80104b79:	89 75 08             	mov    %esi,0x8(%ebp)
80104b7c:	83 c4 10             	add    $0x10,%esp
}
80104b7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b82:	5b                   	pop    %ebx
80104b83:	5e                   	pop    %esi
80104b84:	5d                   	pop    %ebp
  release(&lk->lk);
80104b85:	e9 c6 01 00 00       	jmp    80104d50 <release>
80104b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b90 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	57                   	push   %edi
80104b94:	31 ff                	xor    %edi,%edi
80104b96:	56                   	push   %esi
80104b97:	53                   	push   %ebx
80104b98:	83 ec 18             	sub    $0x18,%esp
80104b9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104b9e:	8d 73 04             	lea    0x4(%ebx),%esi
80104ba1:	56                   	push   %esi
80104ba2:	e8 09 02 00 00       	call   80104db0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104ba7:	8b 03                	mov    (%ebx),%eax
80104ba9:	83 c4 10             	add    $0x10,%esp
80104bac:	85 c0                	test   %eax,%eax
80104bae:	75 18                	jne    80104bc8 <holdingsleep+0x38>
  release(&lk->lk);
80104bb0:	83 ec 0c             	sub    $0xc,%esp
80104bb3:	56                   	push   %esi
80104bb4:	e8 97 01 00 00       	call   80104d50 <release>
  return r;
}
80104bb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bbc:	89 f8                	mov    %edi,%eax
80104bbe:	5b                   	pop    %ebx
80104bbf:	5e                   	pop    %esi
80104bc0:	5f                   	pop    %edi
80104bc1:	5d                   	pop    %ebp
80104bc2:	c3                   	ret    
80104bc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bc7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104bc8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104bcb:	e8 70 ee ff ff       	call   80103a40 <myproc>
80104bd0:	39 58 0c             	cmp    %ebx,0xc(%eax)
80104bd3:	0f 94 c0             	sete   %al
80104bd6:	0f b6 c0             	movzbl %al,%eax
80104bd9:	89 c7                	mov    %eax,%edi
80104bdb:	eb d3                	jmp    80104bb0 <holdingsleep+0x20>
80104bdd:	66 90                	xchg   %ax,%ax
80104bdf:	90                   	nop

80104be0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104be6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104be9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104bef:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104bf2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104bf9:	5d                   	pop    %ebp
80104bfa:	c3                   	ret    
80104bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bff:	90                   	nop

80104c00 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c00:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c01:	31 d2                	xor    %edx,%edx
{
80104c03:	89 e5                	mov    %esp,%ebp
80104c05:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104c06:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104c09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c0c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104c0f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c10:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104c16:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c1c:	77 1a                	ja     80104c38 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104c1e:	8b 58 04             	mov    0x4(%eax),%ebx
80104c21:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104c24:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104c27:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c29:	83 fa 0a             	cmp    $0xa,%edx
80104c2c:	75 e2                	jne    80104c10 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104c2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c31:	c9                   	leave  
80104c32:	c3                   	ret    
80104c33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c37:	90                   	nop
  for(; i < 10; i++)
80104c38:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104c3b:	8d 51 28             	lea    0x28(%ecx),%edx
80104c3e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104c40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c46:	83 c0 04             	add    $0x4,%eax
80104c49:	39 d0                	cmp    %edx,%eax
80104c4b:	75 f3                	jne    80104c40 <getcallerpcs+0x40>
}
80104c4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c50:	c9                   	leave  
80104c51:	c3                   	ret    
80104c52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c60 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	53                   	push   %ebx
80104c64:	83 ec 04             	sub    $0x4,%esp
80104c67:	9c                   	pushf  
80104c68:	5b                   	pop    %ebx
  asm volatile("cli");
80104c69:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104c6a:	e8 51 ed ff ff       	call   801039c0 <mycpu>
80104c6f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c75:	85 c0                	test   %eax,%eax
80104c77:	74 17                	je     80104c90 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104c79:	e8 42 ed ff ff       	call   801039c0 <mycpu>
80104c7e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104c85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c88:	c9                   	leave  
80104c89:	c3                   	ret    
80104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104c90:	e8 2b ed ff ff       	call   801039c0 <mycpu>
80104c95:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104c9b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104ca1:	eb d6                	jmp    80104c79 <pushcli+0x19>
80104ca3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104cb0 <popcli>:

void
popcli(void)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104cb6:	9c                   	pushf  
80104cb7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104cb8:	f6 c4 02             	test   $0x2,%ah
80104cbb:	75 35                	jne    80104cf2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104cbd:	e8 fe ec ff ff       	call   801039c0 <mycpu>
80104cc2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104cc9:	78 34                	js     80104cff <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ccb:	e8 f0 ec ff ff       	call   801039c0 <mycpu>
80104cd0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104cd6:	85 d2                	test   %edx,%edx
80104cd8:	74 06                	je     80104ce0 <popcli+0x30>
    sti();
}
80104cda:	c9                   	leave  
80104cdb:	c3                   	ret    
80104cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ce0:	e8 db ec ff ff       	call   801039c0 <mycpu>
80104ce5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104ceb:	85 c0                	test   %eax,%eax
80104ced:	74 eb                	je     80104cda <popcli+0x2a>
  asm volatile("sti");
80104cef:	fb                   	sti    
}
80104cf0:	c9                   	leave  
80104cf1:	c3                   	ret    
    panic("popcli - interruptible");
80104cf2:	83 ec 0c             	sub    $0xc,%esp
80104cf5:	68 c3 81 10 80       	push   $0x801081c3
80104cfa:	e8 81 b6 ff ff       	call   80100380 <panic>
    panic("popcli");
80104cff:	83 ec 0c             	sub    $0xc,%esp
80104d02:	68 da 81 10 80       	push   $0x801081da
80104d07:	e8 74 b6 ff ff       	call   80100380 <panic>
80104d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d10 <holding>:
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	56                   	push   %esi
80104d14:	53                   	push   %ebx
80104d15:	8b 75 08             	mov    0x8(%ebp),%esi
80104d18:	31 db                	xor    %ebx,%ebx
  pushcli();
80104d1a:	e8 41 ff ff ff       	call   80104c60 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d1f:	8b 06                	mov    (%esi),%eax
80104d21:	85 c0                	test   %eax,%eax
80104d23:	75 0b                	jne    80104d30 <holding+0x20>
  popcli();
80104d25:	e8 86 ff ff ff       	call   80104cb0 <popcli>
}
80104d2a:	89 d8                	mov    %ebx,%eax
80104d2c:	5b                   	pop    %ebx
80104d2d:	5e                   	pop    %esi
80104d2e:	5d                   	pop    %ebp
80104d2f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104d30:	8b 5e 08             	mov    0x8(%esi),%ebx
80104d33:	e8 88 ec ff ff       	call   801039c0 <mycpu>
80104d38:	39 c3                	cmp    %eax,%ebx
80104d3a:	0f 94 c3             	sete   %bl
  popcli();
80104d3d:	e8 6e ff ff ff       	call   80104cb0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104d42:	0f b6 db             	movzbl %bl,%ebx
}
80104d45:	89 d8                	mov    %ebx,%eax
80104d47:	5b                   	pop    %ebx
80104d48:	5e                   	pop    %esi
80104d49:	5d                   	pop    %ebp
80104d4a:	c3                   	ret    
80104d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d4f:	90                   	nop

80104d50 <release>:
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	56                   	push   %esi
80104d54:	53                   	push   %ebx
80104d55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104d58:	e8 03 ff ff ff       	call   80104c60 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d5d:	8b 03                	mov    (%ebx),%eax
80104d5f:	85 c0                	test   %eax,%eax
80104d61:	75 15                	jne    80104d78 <release+0x28>
  popcli();
80104d63:	e8 48 ff ff ff       	call   80104cb0 <popcli>
    panic("release");
80104d68:	83 ec 0c             	sub    $0xc,%esp
80104d6b:	68 e1 81 10 80       	push   $0x801081e1
80104d70:	e8 0b b6 ff ff       	call   80100380 <panic>
80104d75:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104d78:	8b 73 08             	mov    0x8(%ebx),%esi
80104d7b:	e8 40 ec ff ff       	call   801039c0 <mycpu>
80104d80:	39 c6                	cmp    %eax,%esi
80104d82:	75 df                	jne    80104d63 <release+0x13>
  popcli();
80104d84:	e8 27 ff ff ff       	call   80104cb0 <popcli>
  lk->pcs[0] = 0;
80104d89:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104d90:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104d97:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104d9c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104da2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104da5:	5b                   	pop    %ebx
80104da6:	5e                   	pop    %esi
80104da7:	5d                   	pop    %ebp
  popcli();
80104da8:	e9 03 ff ff ff       	jmp    80104cb0 <popcli>
80104dad:	8d 76 00             	lea    0x0(%esi),%esi

80104db0 <acquire>:
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	53                   	push   %ebx
80104db4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104db7:	e8 a4 fe ff ff       	call   80104c60 <pushcli>
  if(holding(lk))
80104dbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104dbf:	e8 9c fe ff ff       	call   80104c60 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104dc4:	8b 03                	mov    (%ebx),%eax
80104dc6:	85 c0                	test   %eax,%eax
80104dc8:	75 7e                	jne    80104e48 <acquire+0x98>
  popcli();
80104dca:	e8 e1 fe ff ff       	call   80104cb0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104dcf:	b9 01 00 00 00       	mov    $0x1,%ecx
80104dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104dd8:	8b 55 08             	mov    0x8(%ebp),%edx
80104ddb:	89 c8                	mov    %ecx,%eax
80104ddd:	f0 87 02             	lock xchg %eax,(%edx)
80104de0:	85 c0                	test   %eax,%eax
80104de2:	75 f4                	jne    80104dd8 <acquire+0x28>
  __sync_synchronize();
80104de4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104de9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104dec:	e8 cf eb ff ff       	call   801039c0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104df1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104df4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104df6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104df9:	31 c0                	xor    %eax,%eax
80104dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e00:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104e06:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104e0c:	77 1a                	ja     80104e28 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104e0e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104e11:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104e15:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104e18:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104e1a:	83 f8 0a             	cmp    $0xa,%eax
80104e1d:	75 e1                	jne    80104e00 <acquire+0x50>
}
80104e1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e22:	c9                   	leave  
80104e23:	c3                   	ret    
80104e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104e28:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104e2c:	8d 51 34             	lea    0x34(%ecx),%edx
80104e2f:	90                   	nop
    pcs[i] = 0;
80104e30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e36:	83 c0 04             	add    $0x4,%eax
80104e39:	39 c2                	cmp    %eax,%edx
80104e3b:	75 f3                	jne    80104e30 <acquire+0x80>
}
80104e3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e40:	c9                   	leave  
80104e41:	c3                   	ret    
80104e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104e48:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104e4b:	e8 70 eb ff ff       	call   801039c0 <mycpu>
80104e50:	39 c3                	cmp    %eax,%ebx
80104e52:	0f 85 72 ff ff ff    	jne    80104dca <acquire+0x1a>
  popcli();
80104e58:	e8 53 fe ff ff       	call   80104cb0 <popcli>
    panic("acquire");
80104e5d:	83 ec 0c             	sub    $0xc,%esp
80104e60:	68 e9 81 10 80       	push   $0x801081e9
80104e65:	e8 16 b5 ff ff       	call   80100380 <panic>
80104e6a:	66 90                	xchg   %ax,%ax
80104e6c:	66 90                	xchg   %ax,%ax
80104e6e:	66 90                	xchg   %ax,%ax

80104e70 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	57                   	push   %edi
80104e74:	8b 55 08             	mov    0x8(%ebp),%edx
80104e77:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e7a:	53                   	push   %ebx
80104e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104e7e:	89 d7                	mov    %edx,%edi
80104e80:	09 cf                	or     %ecx,%edi
80104e82:	83 e7 03             	and    $0x3,%edi
80104e85:	75 29                	jne    80104eb0 <memset+0x40>
    c &= 0xFF;
80104e87:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104e8a:	c1 e0 18             	shl    $0x18,%eax
80104e8d:	89 fb                	mov    %edi,%ebx
80104e8f:	c1 e9 02             	shr    $0x2,%ecx
80104e92:	c1 e3 10             	shl    $0x10,%ebx
80104e95:	09 d8                	or     %ebx,%eax
80104e97:	09 f8                	or     %edi,%eax
80104e99:	c1 e7 08             	shl    $0x8,%edi
80104e9c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104e9e:	89 d7                	mov    %edx,%edi
80104ea0:	fc                   	cld    
80104ea1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104ea3:	5b                   	pop    %ebx
80104ea4:	89 d0                	mov    %edx,%eax
80104ea6:	5f                   	pop    %edi
80104ea7:	5d                   	pop    %ebp
80104ea8:	c3                   	ret    
80104ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104eb0:	89 d7                	mov    %edx,%edi
80104eb2:	fc                   	cld    
80104eb3:	f3 aa                	rep stos %al,%es:(%edi)
80104eb5:	5b                   	pop    %ebx
80104eb6:	89 d0                	mov    %edx,%eax
80104eb8:	5f                   	pop    %edi
80104eb9:	5d                   	pop    %ebp
80104eba:	c3                   	ret    
80104ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ebf:	90                   	nop

80104ec0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	56                   	push   %esi
80104ec4:	8b 75 10             	mov    0x10(%ebp),%esi
80104ec7:	8b 55 08             	mov    0x8(%ebp),%edx
80104eca:	53                   	push   %ebx
80104ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104ece:	85 f6                	test   %esi,%esi
80104ed0:	74 2e                	je     80104f00 <memcmp+0x40>
80104ed2:	01 c6                	add    %eax,%esi
80104ed4:	eb 14                	jmp    80104eea <memcmp+0x2a>
80104ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104edd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104ee0:	83 c0 01             	add    $0x1,%eax
80104ee3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104ee6:	39 f0                	cmp    %esi,%eax
80104ee8:	74 16                	je     80104f00 <memcmp+0x40>
    if(*s1 != *s2)
80104eea:	0f b6 0a             	movzbl (%edx),%ecx
80104eed:	0f b6 18             	movzbl (%eax),%ebx
80104ef0:	38 d9                	cmp    %bl,%cl
80104ef2:	74 ec                	je     80104ee0 <memcmp+0x20>
      return *s1 - *s2;
80104ef4:	0f b6 c1             	movzbl %cl,%eax
80104ef7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104ef9:	5b                   	pop    %ebx
80104efa:	5e                   	pop    %esi
80104efb:	5d                   	pop    %ebp
80104efc:	c3                   	ret    
80104efd:	8d 76 00             	lea    0x0(%esi),%esi
80104f00:	5b                   	pop    %ebx
  return 0;
80104f01:	31 c0                	xor    %eax,%eax
}
80104f03:	5e                   	pop    %esi
80104f04:	5d                   	pop    %ebp
80104f05:	c3                   	ret    
80104f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi

80104f10 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	57                   	push   %edi
80104f14:	8b 55 08             	mov    0x8(%ebp),%edx
80104f17:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f1a:	56                   	push   %esi
80104f1b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104f1e:	39 d6                	cmp    %edx,%esi
80104f20:	73 26                	jae    80104f48 <memmove+0x38>
80104f22:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104f25:	39 fa                	cmp    %edi,%edx
80104f27:	73 1f                	jae    80104f48 <memmove+0x38>
80104f29:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104f2c:	85 c9                	test   %ecx,%ecx
80104f2e:	74 0c                	je     80104f3c <memmove+0x2c>
      *--d = *--s;
80104f30:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104f34:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104f37:	83 e8 01             	sub    $0x1,%eax
80104f3a:	73 f4                	jae    80104f30 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104f3c:	5e                   	pop    %esi
80104f3d:	89 d0                	mov    %edx,%eax
80104f3f:	5f                   	pop    %edi
80104f40:	5d                   	pop    %ebp
80104f41:	c3                   	ret    
80104f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104f48:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104f4b:	89 d7                	mov    %edx,%edi
80104f4d:	85 c9                	test   %ecx,%ecx
80104f4f:	74 eb                	je     80104f3c <memmove+0x2c>
80104f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104f58:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104f59:	39 c6                	cmp    %eax,%esi
80104f5b:	75 fb                	jne    80104f58 <memmove+0x48>
}
80104f5d:	5e                   	pop    %esi
80104f5e:	89 d0                	mov    %edx,%eax
80104f60:	5f                   	pop    %edi
80104f61:	5d                   	pop    %ebp
80104f62:	c3                   	ret    
80104f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f70 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104f70:	eb 9e                	jmp    80104f10 <memmove>
80104f72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f80 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	8b 75 10             	mov    0x10(%ebp),%esi
80104f87:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f8a:	53                   	push   %ebx
80104f8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104f8e:	85 f6                	test   %esi,%esi
80104f90:	74 2e                	je     80104fc0 <strncmp+0x40>
80104f92:	01 d6                	add    %edx,%esi
80104f94:	eb 18                	jmp    80104fae <strncmp+0x2e>
80104f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi
80104fa0:	38 d8                	cmp    %bl,%al
80104fa2:	75 14                	jne    80104fb8 <strncmp+0x38>
    n--, p++, q++;
80104fa4:	83 c2 01             	add    $0x1,%edx
80104fa7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104faa:	39 f2                	cmp    %esi,%edx
80104fac:	74 12                	je     80104fc0 <strncmp+0x40>
80104fae:	0f b6 01             	movzbl (%ecx),%eax
80104fb1:	0f b6 1a             	movzbl (%edx),%ebx
80104fb4:	84 c0                	test   %al,%al
80104fb6:	75 e8                	jne    80104fa0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104fb8:	29 d8                	sub    %ebx,%eax
}
80104fba:	5b                   	pop    %ebx
80104fbb:	5e                   	pop    %esi
80104fbc:	5d                   	pop    %ebp
80104fbd:	c3                   	ret    
80104fbe:	66 90                	xchg   %ax,%ax
80104fc0:	5b                   	pop    %ebx
    return 0;
80104fc1:	31 c0                	xor    %eax,%eax
}
80104fc3:	5e                   	pop    %esi
80104fc4:	5d                   	pop    %ebp
80104fc5:	c3                   	ret    
80104fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fcd:	8d 76 00             	lea    0x0(%esi),%esi

80104fd0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	57                   	push   %edi
80104fd4:	56                   	push   %esi
80104fd5:	8b 75 08             	mov    0x8(%ebp),%esi
80104fd8:	53                   	push   %ebx
80104fd9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104fdc:	89 f0                	mov    %esi,%eax
80104fde:	eb 15                	jmp    80104ff5 <strncpy+0x25>
80104fe0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104fe4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104fe7:	83 c0 01             	add    $0x1,%eax
80104fea:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104fee:	88 50 ff             	mov    %dl,-0x1(%eax)
80104ff1:	84 d2                	test   %dl,%dl
80104ff3:	74 09                	je     80104ffe <strncpy+0x2e>
80104ff5:	89 cb                	mov    %ecx,%ebx
80104ff7:	83 e9 01             	sub    $0x1,%ecx
80104ffa:	85 db                	test   %ebx,%ebx
80104ffc:	7f e2                	jg     80104fe0 <strncpy+0x10>
    ;
  while(n-- > 0)
80104ffe:	89 c2                	mov    %eax,%edx
80105000:	85 c9                	test   %ecx,%ecx
80105002:	7e 17                	jle    8010501b <strncpy+0x4b>
80105004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105008:	83 c2 01             	add    $0x1,%edx
8010500b:	89 c1                	mov    %eax,%ecx
8010500d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105011:	29 d1                	sub    %edx,%ecx
80105013:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105017:	85 c9                	test   %ecx,%ecx
80105019:	7f ed                	jg     80105008 <strncpy+0x38>
  return os;
}
8010501b:	5b                   	pop    %ebx
8010501c:	89 f0                	mov    %esi,%eax
8010501e:	5e                   	pop    %esi
8010501f:	5f                   	pop    %edi
80105020:	5d                   	pop    %ebp
80105021:	c3                   	ret    
80105022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105030 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	56                   	push   %esi
80105034:	8b 55 10             	mov    0x10(%ebp),%edx
80105037:	8b 75 08             	mov    0x8(%ebp),%esi
8010503a:	53                   	push   %ebx
8010503b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010503e:	85 d2                	test   %edx,%edx
80105040:	7e 25                	jle    80105067 <safestrcpy+0x37>
80105042:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105046:	89 f2                	mov    %esi,%edx
80105048:	eb 16                	jmp    80105060 <safestrcpy+0x30>
8010504a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105050:	0f b6 08             	movzbl (%eax),%ecx
80105053:	83 c0 01             	add    $0x1,%eax
80105056:	83 c2 01             	add    $0x1,%edx
80105059:	88 4a ff             	mov    %cl,-0x1(%edx)
8010505c:	84 c9                	test   %cl,%cl
8010505e:	74 04                	je     80105064 <safestrcpy+0x34>
80105060:	39 d8                	cmp    %ebx,%eax
80105062:	75 ec                	jne    80105050 <safestrcpy+0x20>
    ;
  *s = 0;
80105064:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105067:	89 f0                	mov    %esi,%eax
80105069:	5b                   	pop    %ebx
8010506a:	5e                   	pop    %esi
8010506b:	5d                   	pop    %ebp
8010506c:	c3                   	ret    
8010506d:	8d 76 00             	lea    0x0(%esi),%esi

80105070 <strlen>:

int
strlen(const char *s)
{
80105070:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105071:	31 c0                	xor    %eax,%eax
{
80105073:	89 e5                	mov    %esp,%ebp
80105075:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105078:	80 3a 00             	cmpb   $0x0,(%edx)
8010507b:	74 0c                	je     80105089 <strlen+0x19>
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
80105080:	83 c0 01             	add    $0x1,%eax
80105083:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105087:	75 f7                	jne    80105080 <strlen+0x10>
    ;
  return n;
}
80105089:	5d                   	pop    %ebp
8010508a:	c3                   	ret    

8010508b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010508b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010508f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105093:	55                   	push   %ebp
  pushl %ebx
80105094:	53                   	push   %ebx
  pushl %esi
80105095:	56                   	push   %esi
  pushl %edi
80105096:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105097:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105099:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010509b:	5f                   	pop    %edi
  popl %esi
8010509c:	5e                   	pop    %esi
  popl %ebx
8010509d:	5b                   	pop    %ebx
  popl %ebp
8010509e:	5d                   	pop    %ebp
  ret
8010509f:	c3                   	ret    

801050a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	53                   	push   %ebx
801050a4:	83 ec 04             	sub    $0x4,%esp
801050a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801050aa:	e8 91 e9 ff ff       	call   80103a40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050af:	8b 00                	mov    (%eax),%eax
801050b1:	39 d8                	cmp    %ebx,%eax
801050b3:	76 1b                	jbe    801050d0 <fetchint+0x30>
801050b5:	8d 53 04             	lea    0x4(%ebx),%edx
801050b8:	39 d0                	cmp    %edx,%eax
801050ba:	72 14                	jb     801050d0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801050bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801050bf:	8b 13                	mov    (%ebx),%edx
801050c1:	89 10                	mov    %edx,(%eax)
  return 0;
801050c3:	31 c0                	xor    %eax,%eax
}
801050c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050c8:	c9                   	leave  
801050c9:	c3                   	ret    
801050ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801050d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050d5:	eb ee                	jmp    801050c5 <fetchint+0x25>
801050d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050de:	66 90                	xchg   %ax,%ax

801050e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	53                   	push   %ebx
801050e4:	83 ec 04             	sub    $0x4,%esp
801050e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801050ea:	e8 51 e9 ff ff       	call   80103a40 <myproc>

  if(addr >= curproc->sz)
801050ef:	39 18                	cmp    %ebx,(%eax)
801050f1:	76 2d                	jbe    80105120 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801050f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801050f6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801050f8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801050fa:	39 d3                	cmp    %edx,%ebx
801050fc:	73 22                	jae    80105120 <fetchstr+0x40>
801050fe:	89 d8                	mov    %ebx,%eax
80105100:	eb 0d                	jmp    8010510f <fetchstr+0x2f>
80105102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105108:	83 c0 01             	add    $0x1,%eax
8010510b:	39 c2                	cmp    %eax,%edx
8010510d:	76 11                	jbe    80105120 <fetchstr+0x40>
    if(*s == 0)
8010510f:	80 38 00             	cmpb   $0x0,(%eax)
80105112:	75 f4                	jne    80105108 <fetchstr+0x28>
      return s - *pp;
80105114:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105116:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105119:	c9                   	leave  
8010511a:	c3                   	ret    
8010511b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010511f:	90                   	nop
80105120:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105123:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105128:	c9                   	leave  
80105129:	c3                   	ret    
8010512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105130 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	56                   	push   %esi
80105134:	53                   	push   %ebx
  struct thread *curt = &myproc()->threads[myproc()->curtidx];
80105135:	e8 06 e9 ff ff       	call   80103a40 <myproc>
8010513a:	89 c3                	mov    %eax,%ebx
8010513c:	e8 ff e8 ff ff       	call   80103a40 <myproc>
  return fetchint((curt->tf->esp) + 4 + 4*n, ip);
80105141:	8b 55 08             	mov    0x8(%ebp),%edx
80105144:	8b 80 6c 08 00 00    	mov    0x86c(%eax),%eax
8010514a:	c1 e0 05             	shl    $0x5,%eax
8010514d:	8b 44 18 78          	mov    0x78(%eax,%ebx,1),%eax
80105151:	8b 40 44             	mov    0x44(%eax),%eax
80105154:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105157:	e8 e4 e8 ff ff       	call   80103a40 <myproc>
  return fetchint((curt->tf->esp) + 4 + 4*n, ip);
8010515c:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010515f:	8b 00                	mov    (%eax),%eax
80105161:	39 c6                	cmp    %eax,%esi
80105163:	73 1b                	jae    80105180 <argint+0x50>
80105165:	8d 53 08             	lea    0x8(%ebx),%edx
80105168:	39 d0                	cmp    %edx,%eax
8010516a:	72 14                	jb     80105180 <argint+0x50>
  *ip = *(int*)(addr);
8010516c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010516f:	8b 53 04             	mov    0x4(%ebx),%edx
80105172:	89 10                	mov    %edx,(%eax)
  return 0;
80105174:	31 c0                	xor    %eax,%eax
}
80105176:	5b                   	pop    %ebx
80105177:	5e                   	pop    %esi
80105178:	5d                   	pop    %ebp
80105179:	c3                   	ret    
8010517a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((curt->tf->esp) + 4 + 4*n, ip);
80105185:	eb ef                	jmp    80105176 <argint+0x46>
80105187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010518e:	66 90                	xchg   %ax,%ax

80105190 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	56                   	push   %esi
80105194:	53                   	push   %ebx
80105195:	83 ec 10             	sub    $0x10,%esp
80105198:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010519b:	e8 a0 e8 ff ff       	call   80103a40 <myproc>
 
  if(argint(n, &i) < 0)
801051a0:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801051a3:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801051a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051a8:	50                   	push   %eax
801051a9:	ff 75 08             	push   0x8(%ebp)
801051ac:	e8 7f ff ff ff       	call   80105130 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801051b1:	83 c4 10             	add    $0x10,%esp
801051b4:	09 d8                	or     %ebx,%eax
801051b6:	78 20                	js     801051d8 <argptr+0x48>
801051b8:	8b 16                	mov    (%esi),%edx
801051ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051bd:	39 c2                	cmp    %eax,%edx
801051bf:	76 17                	jbe    801051d8 <argptr+0x48>
801051c1:	01 c3                	add    %eax,%ebx
801051c3:	39 da                	cmp    %ebx,%edx
801051c5:	72 11                	jb     801051d8 <argptr+0x48>
    return -1;
  *pp = (char*)i;
801051c7:	8b 55 0c             	mov    0xc(%ebp),%edx
801051ca:	89 02                	mov    %eax,(%edx)
  return 0;
801051cc:	31 c0                	xor    %eax,%eax
}
801051ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051d1:	5b                   	pop    %ebx
801051d2:	5e                   	pop    %esi
801051d3:	5d                   	pop    %ebp
801051d4:	c3                   	ret    
801051d5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051dd:	eb ef                	jmp    801051ce <argptr+0x3e>
801051df:	90                   	nop

801051e0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	53                   	push   %ebx
  int addr;
  if(argint(n, &addr) < 0)
801051e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801051e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(n, &addr) < 0)
801051ea:	50                   	push   %eax
801051eb:	ff 75 08             	push   0x8(%ebp)
801051ee:	e8 3d ff ff ff       	call   80105130 <argint>
801051f3:	83 c4 10             	add    $0x10,%esp
801051f6:	85 c0                	test   %eax,%eax
801051f8:	78 36                	js     80105230 <argstr+0x50>
    return -1;
  return fetchstr(addr, pp);
801051fa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  struct proc *curproc = myproc();
801051fd:	e8 3e e8 ff ff       	call   80103a40 <myproc>
  if(addr >= curproc->sz)
80105202:	3b 18                	cmp    (%eax),%ebx
80105204:	73 2a                	jae    80105230 <argstr+0x50>
  *pp = (char*)addr;
80105206:	8b 55 0c             	mov    0xc(%ebp),%edx
80105209:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010520b:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010520d:	39 d3                	cmp    %edx,%ebx
8010520f:	73 1f                	jae    80105230 <argstr+0x50>
80105211:	89 d8                	mov    %ebx,%eax
80105213:	eb 0a                	jmp    8010521f <argstr+0x3f>
80105215:	8d 76 00             	lea    0x0(%esi),%esi
80105218:	83 c0 01             	add    $0x1,%eax
8010521b:	39 c2                	cmp    %eax,%edx
8010521d:	76 11                	jbe    80105230 <argstr+0x50>
    if(*s == 0)
8010521f:	80 38 00             	cmpb   $0x0,(%eax)
80105222:	75 f4                	jne    80105218 <argstr+0x38>
      return s - *pp;
80105224:	29 d8                	sub    %ebx,%eax
}
80105226:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105229:	c9                   	leave  
8010522a:	c3                   	ret    
8010522b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010522f:	90                   	nop
80105230:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105233:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105238:	c9                   	leave  
80105239:	c3                   	ret    
8010523a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105240 <syscall>:
[SYS_thread_join]		sys_thread_join,
};

void
syscall(void)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	53                   	push   %ebx
80105244:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105247:	e8 f4 e7 ff ff       	call   80103a40 <myproc>
  struct thread *curt = &curproc->threads[curproc->curtidx];

  num = curt->tf->eax;
8010524c:	8b 98 6c 08 00 00    	mov    0x86c(%eax),%ebx
80105252:	c1 e3 05             	shl    $0x5,%ebx
80105255:	01 c3                	add    %eax,%ebx
80105257:	8b 53 78             	mov    0x78(%ebx),%edx
8010525a:	8b 52 1c             	mov    0x1c(%edx),%edx
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010525d:	8d 4a ff             	lea    -0x1(%edx),%ecx
80105260:	83 f9 17             	cmp    $0x17,%ecx
80105263:	77 1b                	ja     80105280 <syscall+0x40>
80105265:	8b 0c 95 20 82 10 80 	mov    -0x7fef7de0(,%edx,4),%ecx
8010526c:	85 c9                	test   %ecx,%ecx
8010526e:	74 10                	je     80105280 <syscall+0x40>
    curt->tf->eax = syscalls[num]();
80105270:	ff d1                	call   *%ecx
80105272:	89 c2                	mov    %eax,%edx
80105274:	8b 43 78             	mov    0x78(%ebx),%eax
80105277:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %d %s: unknown sys call %d\n",
            curproc->pid, curt->tid, curproc->name, num);
    curt->tf->eax = -1;
  }
}
8010527a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010527d:	c9                   	leave  
8010527e:	c3                   	ret    
8010527f:	90                   	nop
    cprintf("%d %d %s: unknown sys call %d\n",
80105280:	83 ec 0c             	sub    $0xc,%esp
80105283:	52                   	push   %edx
            curproc->pid, curt->tid, curproc->name, num);
80105284:	8d 50 5c             	lea    0x5c(%eax),%edx
    cprintf("%d %d %s: unknown sys call %d\n",
80105287:	52                   	push   %edx
80105288:	ff 73 70             	push   0x70(%ebx)
8010528b:	ff 70 0c             	push   0xc(%eax)
8010528e:	68 f4 81 10 80       	push   $0x801081f4
80105293:	e8 08 b4 ff ff       	call   801006a0 <cprintf>
    curt->tf->eax = -1;
80105298:	8b 43 78             	mov    0x78(%ebx),%eax
8010529b:	83 c4 20             	add    $0x20,%esp
8010529e:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801052a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052a8:	c9                   	leave  
801052a9:	c3                   	ret    
801052aa:	66 90                	xchg   %ax,%ax
801052ac:	66 90                	xchg   %ax,%ax
801052ae:	66 90                	xchg   %ax,%ax

801052b0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	57                   	push   %edi
801052b4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801052b5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801052b8:	53                   	push   %ebx
801052b9:	83 ec 34             	sub    $0x34,%esp
801052bc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801052bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801052c2:	57                   	push   %edi
801052c3:	50                   	push   %eax
{
801052c4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801052c7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801052ca:	e8 51 ce ff ff       	call   80102120 <nameiparent>
801052cf:	83 c4 10             	add    $0x10,%esp
801052d2:	85 c0                	test   %eax,%eax
801052d4:	0f 84 46 01 00 00    	je     80105420 <create+0x170>
    return 0;
  ilock(dp);
801052da:	83 ec 0c             	sub    $0xc,%esp
801052dd:	89 c3                	mov    %eax,%ebx
801052df:	50                   	push   %eax
801052e0:	e8 fb c4 ff ff       	call   801017e0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801052e5:	83 c4 0c             	add    $0xc,%esp
801052e8:	6a 00                	push   $0x0
801052ea:	57                   	push   %edi
801052eb:	53                   	push   %ebx
801052ec:	e8 4f ca ff ff       	call   80101d40 <dirlookup>
801052f1:	83 c4 10             	add    $0x10,%esp
801052f4:	89 c6                	mov    %eax,%esi
801052f6:	85 c0                	test   %eax,%eax
801052f8:	74 56                	je     80105350 <create+0xa0>
    iunlockput(dp);
801052fa:	83 ec 0c             	sub    $0xc,%esp
801052fd:	53                   	push   %ebx
801052fe:	e8 6d c7 ff ff       	call   80101a70 <iunlockput>
    ilock(ip);
80105303:	89 34 24             	mov    %esi,(%esp)
80105306:	e8 d5 c4 ff ff       	call   801017e0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010530b:	83 c4 10             	add    $0x10,%esp
8010530e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105313:	75 1b                	jne    80105330 <create+0x80>
80105315:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010531a:	75 14                	jne    80105330 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010531c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010531f:	89 f0                	mov    %esi,%eax
80105321:	5b                   	pop    %ebx
80105322:	5e                   	pop    %esi
80105323:	5f                   	pop    %edi
80105324:	5d                   	pop    %ebp
80105325:	c3                   	ret    
80105326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105330:	83 ec 0c             	sub    $0xc,%esp
80105333:	56                   	push   %esi
    return 0;
80105334:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105336:	e8 35 c7 ff ff       	call   80101a70 <iunlockput>
    return 0;
8010533b:	83 c4 10             	add    $0x10,%esp
}
8010533e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105341:	89 f0                	mov    %esi,%eax
80105343:	5b                   	pop    %ebx
80105344:	5e                   	pop    %esi
80105345:	5f                   	pop    %edi
80105346:	5d                   	pop    %ebp
80105347:	c3                   	ret    
80105348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010534f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105350:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105354:	83 ec 08             	sub    $0x8,%esp
80105357:	50                   	push   %eax
80105358:	ff 33                	push   (%ebx)
8010535a:	e8 11 c3 ff ff       	call   80101670 <ialloc>
8010535f:	83 c4 10             	add    $0x10,%esp
80105362:	89 c6                	mov    %eax,%esi
80105364:	85 c0                	test   %eax,%eax
80105366:	0f 84 cd 00 00 00    	je     80105439 <create+0x189>
  ilock(ip);
8010536c:	83 ec 0c             	sub    $0xc,%esp
8010536f:	50                   	push   %eax
80105370:	e8 6b c4 ff ff       	call   801017e0 <ilock>
  ip->major = major;
80105375:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105379:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010537d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105381:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105385:	b8 01 00 00 00       	mov    $0x1,%eax
8010538a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010538e:	89 34 24             	mov    %esi,(%esp)
80105391:	e8 9a c3 ff ff       	call   80101730 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105396:	83 c4 10             	add    $0x10,%esp
80105399:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010539e:	74 30                	je     801053d0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801053a0:	83 ec 04             	sub    $0x4,%esp
801053a3:	ff 76 04             	push   0x4(%esi)
801053a6:	57                   	push   %edi
801053a7:	53                   	push   %ebx
801053a8:	e8 93 cc ff ff       	call   80102040 <dirlink>
801053ad:	83 c4 10             	add    $0x10,%esp
801053b0:	85 c0                	test   %eax,%eax
801053b2:	78 78                	js     8010542c <create+0x17c>
  iunlockput(dp);
801053b4:	83 ec 0c             	sub    $0xc,%esp
801053b7:	53                   	push   %ebx
801053b8:	e8 b3 c6 ff ff       	call   80101a70 <iunlockput>
  return ip;
801053bd:	83 c4 10             	add    $0x10,%esp
}
801053c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053c3:	89 f0                	mov    %esi,%eax
801053c5:	5b                   	pop    %ebx
801053c6:	5e                   	pop    %esi
801053c7:	5f                   	pop    %edi
801053c8:	5d                   	pop    %ebp
801053c9:	c3                   	ret    
801053ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801053d0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801053d3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801053d8:	53                   	push   %ebx
801053d9:	e8 52 c3 ff ff       	call   80101730 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801053de:	83 c4 0c             	add    $0xc,%esp
801053e1:	ff 76 04             	push   0x4(%esi)
801053e4:	68 a0 82 10 80       	push   $0x801082a0
801053e9:	56                   	push   %esi
801053ea:	e8 51 cc ff ff       	call   80102040 <dirlink>
801053ef:	83 c4 10             	add    $0x10,%esp
801053f2:	85 c0                	test   %eax,%eax
801053f4:	78 18                	js     8010540e <create+0x15e>
801053f6:	83 ec 04             	sub    $0x4,%esp
801053f9:	ff 73 04             	push   0x4(%ebx)
801053fc:	68 9f 82 10 80       	push   $0x8010829f
80105401:	56                   	push   %esi
80105402:	e8 39 cc ff ff       	call   80102040 <dirlink>
80105407:	83 c4 10             	add    $0x10,%esp
8010540a:	85 c0                	test   %eax,%eax
8010540c:	79 92                	jns    801053a0 <create+0xf0>
      panic("create dots");
8010540e:	83 ec 0c             	sub    $0xc,%esp
80105411:	68 93 82 10 80       	push   $0x80108293
80105416:	e8 65 af ff ff       	call   80100380 <panic>
8010541b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010541f:	90                   	nop
}
80105420:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105423:	31 f6                	xor    %esi,%esi
}
80105425:	5b                   	pop    %ebx
80105426:	89 f0                	mov    %esi,%eax
80105428:	5e                   	pop    %esi
80105429:	5f                   	pop    %edi
8010542a:	5d                   	pop    %ebp
8010542b:	c3                   	ret    
    panic("create: dirlink");
8010542c:	83 ec 0c             	sub    $0xc,%esp
8010542f:	68 a2 82 10 80       	push   $0x801082a2
80105434:	e8 47 af ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105439:	83 ec 0c             	sub    $0xc,%esp
8010543c:	68 84 82 10 80       	push   $0x80108284
80105441:	e8 3a af ff ff       	call   80100380 <panic>
80105446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010544d:	8d 76 00             	lea    0x0(%esi),%esi

80105450 <sys_dup>:
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	56                   	push   %esi
80105454:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105455:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105458:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010545b:	50                   	push   %eax
8010545c:	6a 00                	push   $0x0
8010545e:	e8 cd fc ff ff       	call   80105130 <argint>
80105463:	83 c4 10             	add    $0x10,%esp
80105466:	85 c0                	test   %eax,%eax
80105468:	78 36                	js     801054a0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010546a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010546e:	77 30                	ja     801054a0 <sys_dup+0x50>
80105470:	e8 cb e5 ff ff       	call   80103a40 <myproc>
80105475:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105478:	8b 74 90 18          	mov    0x18(%eax,%edx,4),%esi
8010547c:	85 f6                	test   %esi,%esi
8010547e:	74 20                	je     801054a0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105480:	e8 bb e5 ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105485:	31 db                	xor    %ebx,%ebx
80105487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010548e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105490:	8b 54 98 18          	mov    0x18(%eax,%ebx,4),%edx
80105494:	85 d2                	test   %edx,%edx
80105496:	74 18                	je     801054b0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105498:	83 c3 01             	add    $0x1,%ebx
8010549b:	83 fb 10             	cmp    $0x10,%ebx
8010549e:	75 f0                	jne    80105490 <sys_dup+0x40>
}
801054a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801054a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801054a8:	89 d8                	mov    %ebx,%eax
801054aa:	5b                   	pop    %ebx
801054ab:	5e                   	pop    %esi
801054ac:	5d                   	pop    %ebp
801054ad:	c3                   	ret    
801054ae:	66 90                	xchg   %ax,%ax
  filedup(f);
801054b0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054b3:	89 74 98 18          	mov    %esi,0x18(%eax,%ebx,4)
  filedup(f);
801054b7:	56                   	push   %esi
801054b8:	e8 43 ba ff ff       	call   80100f00 <filedup>
  return fd;
801054bd:	83 c4 10             	add    $0x10,%esp
}
801054c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054c3:	89 d8                	mov    %ebx,%eax
801054c5:	5b                   	pop    %ebx
801054c6:	5e                   	pop    %esi
801054c7:	5d                   	pop    %ebp
801054c8:	c3                   	ret    
801054c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054d0 <sys_read>:
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	56                   	push   %esi
801054d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801054d5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801054d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054db:	53                   	push   %ebx
801054dc:	6a 00                	push   $0x0
801054de:	e8 4d fc ff ff       	call   80105130 <argint>
801054e3:	83 c4 10             	add    $0x10,%esp
801054e6:	85 c0                	test   %eax,%eax
801054e8:	78 5e                	js     80105548 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054ee:	77 58                	ja     80105548 <sys_read+0x78>
801054f0:	e8 4b e5 ff ff       	call   80103a40 <myproc>
801054f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054f8:	8b 74 90 18          	mov    0x18(%eax,%edx,4),%esi
801054fc:	85 f6                	test   %esi,%esi
801054fe:	74 48                	je     80105548 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105500:	83 ec 08             	sub    $0x8,%esp
80105503:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105506:	50                   	push   %eax
80105507:	6a 02                	push   $0x2
80105509:	e8 22 fc ff ff       	call   80105130 <argint>
8010550e:	83 c4 10             	add    $0x10,%esp
80105511:	85 c0                	test   %eax,%eax
80105513:	78 33                	js     80105548 <sys_read+0x78>
80105515:	83 ec 04             	sub    $0x4,%esp
80105518:	ff 75 f0             	push   -0x10(%ebp)
8010551b:	53                   	push   %ebx
8010551c:	6a 01                	push   $0x1
8010551e:	e8 6d fc ff ff       	call   80105190 <argptr>
80105523:	83 c4 10             	add    $0x10,%esp
80105526:	85 c0                	test   %eax,%eax
80105528:	78 1e                	js     80105548 <sys_read+0x78>
  return fileread(f, p, n);
8010552a:	83 ec 04             	sub    $0x4,%esp
8010552d:	ff 75 f0             	push   -0x10(%ebp)
80105530:	ff 75 f4             	push   -0xc(%ebp)
80105533:	56                   	push   %esi
80105534:	e8 47 bb ff ff       	call   80101080 <fileread>
80105539:	83 c4 10             	add    $0x10,%esp
}
8010553c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010553f:	5b                   	pop    %ebx
80105540:	5e                   	pop    %esi
80105541:	5d                   	pop    %ebp
80105542:	c3                   	ret    
80105543:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105547:	90                   	nop
    return -1;
80105548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010554d:	eb ed                	jmp    8010553c <sys_read+0x6c>
8010554f:	90                   	nop

80105550 <sys_write>:
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	56                   	push   %esi
80105554:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105555:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105558:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010555b:	53                   	push   %ebx
8010555c:	6a 00                	push   $0x0
8010555e:	e8 cd fb ff ff       	call   80105130 <argint>
80105563:	83 c4 10             	add    $0x10,%esp
80105566:	85 c0                	test   %eax,%eax
80105568:	78 5e                	js     801055c8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010556a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010556e:	77 58                	ja     801055c8 <sys_write+0x78>
80105570:	e8 cb e4 ff ff       	call   80103a40 <myproc>
80105575:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105578:	8b 74 90 18          	mov    0x18(%eax,%edx,4),%esi
8010557c:	85 f6                	test   %esi,%esi
8010557e:	74 48                	je     801055c8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105580:	83 ec 08             	sub    $0x8,%esp
80105583:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105586:	50                   	push   %eax
80105587:	6a 02                	push   $0x2
80105589:	e8 a2 fb ff ff       	call   80105130 <argint>
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	85 c0                	test   %eax,%eax
80105593:	78 33                	js     801055c8 <sys_write+0x78>
80105595:	83 ec 04             	sub    $0x4,%esp
80105598:	ff 75 f0             	push   -0x10(%ebp)
8010559b:	53                   	push   %ebx
8010559c:	6a 01                	push   $0x1
8010559e:	e8 ed fb ff ff       	call   80105190 <argptr>
801055a3:	83 c4 10             	add    $0x10,%esp
801055a6:	85 c0                	test   %eax,%eax
801055a8:	78 1e                	js     801055c8 <sys_write+0x78>
  return filewrite(f, p, n);
801055aa:	83 ec 04             	sub    $0x4,%esp
801055ad:	ff 75 f0             	push   -0x10(%ebp)
801055b0:	ff 75 f4             	push   -0xc(%ebp)
801055b3:	56                   	push   %esi
801055b4:	e8 57 bb ff ff       	call   80101110 <filewrite>
801055b9:	83 c4 10             	add    $0x10,%esp
}
801055bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055bf:	5b                   	pop    %ebx
801055c0:	5e                   	pop    %esi
801055c1:	5d                   	pop    %ebp
801055c2:	c3                   	ret    
801055c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055c7:	90                   	nop
    return -1;
801055c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055cd:	eb ed                	jmp    801055bc <sys_write+0x6c>
801055cf:	90                   	nop

801055d0 <sys_close>:
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	56                   	push   %esi
801055d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801055d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801055d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801055db:	50                   	push   %eax
801055dc:	6a 00                	push   $0x0
801055de:	e8 4d fb ff ff       	call   80105130 <argint>
801055e3:	83 c4 10             	add    $0x10,%esp
801055e6:	85 c0                	test   %eax,%eax
801055e8:	78 3e                	js     80105628 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055ee:	77 38                	ja     80105628 <sys_close+0x58>
801055f0:	e8 4b e4 ff ff       	call   80103a40 <myproc>
801055f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055f8:	8d 5a 04             	lea    0x4(%edx),%ebx
801055fb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801055ff:	85 f6                	test   %esi,%esi
80105601:	74 25                	je     80105628 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105603:	e8 38 e4 ff ff       	call   80103a40 <myproc>
  fileclose(f);
80105608:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010560b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105612:	00 
  fileclose(f);
80105613:	56                   	push   %esi
80105614:	e8 37 b9 ff ff       	call   80100f50 <fileclose>
  return 0;
80105619:	83 c4 10             	add    $0x10,%esp
8010561c:	31 c0                	xor    %eax,%eax
}
8010561e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105621:	5b                   	pop    %ebx
80105622:	5e                   	pop    %esi
80105623:	5d                   	pop    %ebp
80105624:	c3                   	ret    
80105625:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010562d:	eb ef                	jmp    8010561e <sys_close+0x4e>
8010562f:	90                   	nop

80105630 <sys_fstat>:
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	56                   	push   %esi
80105634:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105635:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105638:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010563b:	53                   	push   %ebx
8010563c:	6a 00                	push   $0x0
8010563e:	e8 ed fa ff ff       	call   80105130 <argint>
80105643:	83 c4 10             	add    $0x10,%esp
80105646:	85 c0                	test   %eax,%eax
80105648:	78 46                	js     80105690 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010564a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010564e:	77 40                	ja     80105690 <sys_fstat+0x60>
80105650:	e8 eb e3 ff ff       	call   80103a40 <myproc>
80105655:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105658:	8b 74 90 18          	mov    0x18(%eax,%edx,4),%esi
8010565c:	85 f6                	test   %esi,%esi
8010565e:	74 30                	je     80105690 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105660:	83 ec 04             	sub    $0x4,%esp
80105663:	6a 14                	push   $0x14
80105665:	53                   	push   %ebx
80105666:	6a 01                	push   $0x1
80105668:	e8 23 fb ff ff       	call   80105190 <argptr>
8010566d:	83 c4 10             	add    $0x10,%esp
80105670:	85 c0                	test   %eax,%eax
80105672:	78 1c                	js     80105690 <sys_fstat+0x60>
  return filestat(f, st);
80105674:	83 ec 08             	sub    $0x8,%esp
80105677:	ff 75 f4             	push   -0xc(%ebp)
8010567a:	56                   	push   %esi
8010567b:	e8 b0 b9 ff ff       	call   80101030 <filestat>
80105680:	83 c4 10             	add    $0x10,%esp
}
80105683:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105686:	5b                   	pop    %ebx
80105687:	5e                   	pop    %esi
80105688:	5d                   	pop    %ebp
80105689:	c3                   	ret    
8010568a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105695:	eb ec                	jmp    80105683 <sys_fstat+0x53>
80105697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569e:	66 90                	xchg   %ax,%ax

801056a0 <sys_link>:
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	57                   	push   %edi
801056a4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056a5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801056a8:	53                   	push   %ebx
801056a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056ac:	50                   	push   %eax
801056ad:	6a 00                	push   $0x0
801056af:	e8 2c fb ff ff       	call   801051e0 <argstr>
801056b4:	83 c4 10             	add    $0x10,%esp
801056b7:	85 c0                	test   %eax,%eax
801056b9:	0f 88 fb 00 00 00    	js     801057ba <sys_link+0x11a>
801056bf:	83 ec 08             	sub    $0x8,%esp
801056c2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801056c5:	50                   	push   %eax
801056c6:	6a 01                	push   $0x1
801056c8:	e8 13 fb ff ff       	call   801051e0 <argstr>
801056cd:	83 c4 10             	add    $0x10,%esp
801056d0:	85 c0                	test   %eax,%eax
801056d2:	0f 88 e2 00 00 00    	js     801057ba <sys_link+0x11a>
  begin_op();
801056d8:	e8 e3 d6 ff ff       	call   80102dc0 <begin_op>
  if((ip = namei(old)) == 0){
801056dd:	83 ec 0c             	sub    $0xc,%esp
801056e0:	ff 75 d4             	push   -0x2c(%ebp)
801056e3:	e8 18 ca ff ff       	call   80102100 <namei>
801056e8:	83 c4 10             	add    $0x10,%esp
801056eb:	89 c3                	mov    %eax,%ebx
801056ed:	85 c0                	test   %eax,%eax
801056ef:	0f 84 e4 00 00 00    	je     801057d9 <sys_link+0x139>
  ilock(ip);
801056f5:	83 ec 0c             	sub    $0xc,%esp
801056f8:	50                   	push   %eax
801056f9:	e8 e2 c0 ff ff       	call   801017e0 <ilock>
  if(ip->type == T_DIR){
801056fe:	83 c4 10             	add    $0x10,%esp
80105701:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105706:	0f 84 b5 00 00 00    	je     801057c1 <sys_link+0x121>
  iupdate(ip);
8010570c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010570f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105714:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105717:	53                   	push   %ebx
80105718:	e8 13 c0 ff ff       	call   80101730 <iupdate>
  iunlock(ip);
8010571d:	89 1c 24             	mov    %ebx,(%esp)
80105720:	e8 9b c1 ff ff       	call   801018c0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105725:	58                   	pop    %eax
80105726:	5a                   	pop    %edx
80105727:	57                   	push   %edi
80105728:	ff 75 d0             	push   -0x30(%ebp)
8010572b:	e8 f0 c9 ff ff       	call   80102120 <nameiparent>
80105730:	83 c4 10             	add    $0x10,%esp
80105733:	89 c6                	mov    %eax,%esi
80105735:	85 c0                	test   %eax,%eax
80105737:	74 5b                	je     80105794 <sys_link+0xf4>
  ilock(dp);
80105739:	83 ec 0c             	sub    $0xc,%esp
8010573c:	50                   	push   %eax
8010573d:	e8 9e c0 ff ff       	call   801017e0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105742:	8b 03                	mov    (%ebx),%eax
80105744:	83 c4 10             	add    $0x10,%esp
80105747:	39 06                	cmp    %eax,(%esi)
80105749:	75 3d                	jne    80105788 <sys_link+0xe8>
8010574b:	83 ec 04             	sub    $0x4,%esp
8010574e:	ff 73 04             	push   0x4(%ebx)
80105751:	57                   	push   %edi
80105752:	56                   	push   %esi
80105753:	e8 e8 c8 ff ff       	call   80102040 <dirlink>
80105758:	83 c4 10             	add    $0x10,%esp
8010575b:	85 c0                	test   %eax,%eax
8010575d:	78 29                	js     80105788 <sys_link+0xe8>
  iunlockput(dp);
8010575f:	83 ec 0c             	sub    $0xc,%esp
80105762:	56                   	push   %esi
80105763:	e8 08 c3 ff ff       	call   80101a70 <iunlockput>
  iput(ip);
80105768:	89 1c 24             	mov    %ebx,(%esp)
8010576b:	e8 a0 c1 ff ff       	call   80101910 <iput>
  end_op();
80105770:	e8 bb d6 ff ff       	call   80102e30 <end_op>
  return 0;
80105775:	83 c4 10             	add    $0x10,%esp
80105778:	31 c0                	xor    %eax,%eax
}
8010577a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010577d:	5b                   	pop    %ebx
8010577e:	5e                   	pop    %esi
8010577f:	5f                   	pop    %edi
80105780:	5d                   	pop    %ebp
80105781:	c3                   	ret    
80105782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105788:	83 ec 0c             	sub    $0xc,%esp
8010578b:	56                   	push   %esi
8010578c:	e8 df c2 ff ff       	call   80101a70 <iunlockput>
    goto bad;
80105791:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105794:	83 ec 0c             	sub    $0xc,%esp
80105797:	53                   	push   %ebx
80105798:	e8 43 c0 ff ff       	call   801017e0 <ilock>
  ip->nlink--;
8010579d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057a2:	89 1c 24             	mov    %ebx,(%esp)
801057a5:	e8 86 bf ff ff       	call   80101730 <iupdate>
  iunlockput(ip);
801057aa:	89 1c 24             	mov    %ebx,(%esp)
801057ad:	e8 be c2 ff ff       	call   80101a70 <iunlockput>
  end_op();
801057b2:	e8 79 d6 ff ff       	call   80102e30 <end_op>
  return -1;
801057b7:	83 c4 10             	add    $0x10,%esp
801057ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057bf:	eb b9                	jmp    8010577a <sys_link+0xda>
    iunlockput(ip);
801057c1:	83 ec 0c             	sub    $0xc,%esp
801057c4:	53                   	push   %ebx
801057c5:	e8 a6 c2 ff ff       	call   80101a70 <iunlockput>
    end_op();
801057ca:	e8 61 d6 ff ff       	call   80102e30 <end_op>
    return -1;
801057cf:	83 c4 10             	add    $0x10,%esp
801057d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d7:	eb a1                	jmp    8010577a <sys_link+0xda>
    end_op();
801057d9:	e8 52 d6 ff ff       	call   80102e30 <end_op>
    return -1;
801057de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e3:	eb 95                	jmp    8010577a <sys_link+0xda>
801057e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_unlink>:
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	57                   	push   %edi
801057f4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801057f5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801057f8:	53                   	push   %ebx
801057f9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801057fc:	50                   	push   %eax
801057fd:	6a 00                	push   $0x0
801057ff:	e8 dc f9 ff ff       	call   801051e0 <argstr>
80105804:	83 c4 10             	add    $0x10,%esp
80105807:	85 c0                	test   %eax,%eax
80105809:	0f 88 7a 01 00 00    	js     80105989 <sys_unlink+0x199>
  begin_op();
8010580f:	e8 ac d5 ff ff       	call   80102dc0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105814:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105817:	83 ec 08             	sub    $0x8,%esp
8010581a:	53                   	push   %ebx
8010581b:	ff 75 c0             	push   -0x40(%ebp)
8010581e:	e8 fd c8 ff ff       	call   80102120 <nameiparent>
80105823:	83 c4 10             	add    $0x10,%esp
80105826:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105829:	85 c0                	test   %eax,%eax
8010582b:	0f 84 62 01 00 00    	je     80105993 <sys_unlink+0x1a3>
  ilock(dp);
80105831:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105834:	83 ec 0c             	sub    $0xc,%esp
80105837:	57                   	push   %edi
80105838:	e8 a3 bf ff ff       	call   801017e0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010583d:	58                   	pop    %eax
8010583e:	5a                   	pop    %edx
8010583f:	68 a0 82 10 80       	push   $0x801082a0
80105844:	53                   	push   %ebx
80105845:	e8 d6 c4 ff ff       	call   80101d20 <namecmp>
8010584a:	83 c4 10             	add    $0x10,%esp
8010584d:	85 c0                	test   %eax,%eax
8010584f:	0f 84 fb 00 00 00    	je     80105950 <sys_unlink+0x160>
80105855:	83 ec 08             	sub    $0x8,%esp
80105858:	68 9f 82 10 80       	push   $0x8010829f
8010585d:	53                   	push   %ebx
8010585e:	e8 bd c4 ff ff       	call   80101d20 <namecmp>
80105863:	83 c4 10             	add    $0x10,%esp
80105866:	85 c0                	test   %eax,%eax
80105868:	0f 84 e2 00 00 00    	je     80105950 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010586e:	83 ec 04             	sub    $0x4,%esp
80105871:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105874:	50                   	push   %eax
80105875:	53                   	push   %ebx
80105876:	57                   	push   %edi
80105877:	e8 c4 c4 ff ff       	call   80101d40 <dirlookup>
8010587c:	83 c4 10             	add    $0x10,%esp
8010587f:	89 c3                	mov    %eax,%ebx
80105881:	85 c0                	test   %eax,%eax
80105883:	0f 84 c7 00 00 00    	je     80105950 <sys_unlink+0x160>
  ilock(ip);
80105889:	83 ec 0c             	sub    $0xc,%esp
8010588c:	50                   	push   %eax
8010588d:	e8 4e bf ff ff       	call   801017e0 <ilock>
  if(ip->nlink < 1)
80105892:	83 c4 10             	add    $0x10,%esp
80105895:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010589a:	0f 8e 1c 01 00 00    	jle    801059bc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801058a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058a5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801058a8:	74 66                	je     80105910 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801058aa:	83 ec 04             	sub    $0x4,%esp
801058ad:	6a 10                	push   $0x10
801058af:	6a 00                	push   $0x0
801058b1:	57                   	push   %edi
801058b2:	e8 b9 f5 ff ff       	call   80104e70 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058b7:	6a 10                	push   $0x10
801058b9:	ff 75 c4             	push   -0x3c(%ebp)
801058bc:	57                   	push   %edi
801058bd:	ff 75 b4             	push   -0x4c(%ebp)
801058c0:	e8 2b c3 ff ff       	call   80101bf0 <writei>
801058c5:	83 c4 20             	add    $0x20,%esp
801058c8:	83 f8 10             	cmp    $0x10,%eax
801058cb:	0f 85 de 00 00 00    	jne    801059af <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801058d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058d6:	0f 84 94 00 00 00    	je     80105970 <sys_unlink+0x180>
  iunlockput(dp);
801058dc:	83 ec 0c             	sub    $0xc,%esp
801058df:	ff 75 b4             	push   -0x4c(%ebp)
801058e2:	e8 89 c1 ff ff       	call   80101a70 <iunlockput>
  ip->nlink--;
801058e7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801058ec:	89 1c 24             	mov    %ebx,(%esp)
801058ef:	e8 3c be ff ff       	call   80101730 <iupdate>
  iunlockput(ip);
801058f4:	89 1c 24             	mov    %ebx,(%esp)
801058f7:	e8 74 c1 ff ff       	call   80101a70 <iunlockput>
  end_op();
801058fc:	e8 2f d5 ff ff       	call   80102e30 <end_op>
  return 0;
80105901:	83 c4 10             	add    $0x10,%esp
80105904:	31 c0                	xor    %eax,%eax
}
80105906:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105909:	5b                   	pop    %ebx
8010590a:	5e                   	pop    %esi
8010590b:	5f                   	pop    %edi
8010590c:	5d                   	pop    %ebp
8010590d:	c3                   	ret    
8010590e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105910:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105914:	76 94                	jbe    801058aa <sys_unlink+0xba>
80105916:	be 20 00 00 00       	mov    $0x20,%esi
8010591b:	eb 0b                	jmp    80105928 <sys_unlink+0x138>
8010591d:	8d 76 00             	lea    0x0(%esi),%esi
80105920:	83 c6 10             	add    $0x10,%esi
80105923:	3b 73 58             	cmp    0x58(%ebx),%esi
80105926:	73 82                	jae    801058aa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105928:	6a 10                	push   $0x10
8010592a:	56                   	push   %esi
8010592b:	57                   	push   %edi
8010592c:	53                   	push   %ebx
8010592d:	e8 be c1 ff ff       	call   80101af0 <readi>
80105932:	83 c4 10             	add    $0x10,%esp
80105935:	83 f8 10             	cmp    $0x10,%eax
80105938:	75 68                	jne    801059a2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010593a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010593f:	74 df                	je     80105920 <sys_unlink+0x130>
    iunlockput(ip);
80105941:	83 ec 0c             	sub    $0xc,%esp
80105944:	53                   	push   %ebx
80105945:	e8 26 c1 ff ff       	call   80101a70 <iunlockput>
    goto bad;
8010594a:	83 c4 10             	add    $0x10,%esp
8010594d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105950:	83 ec 0c             	sub    $0xc,%esp
80105953:	ff 75 b4             	push   -0x4c(%ebp)
80105956:	e8 15 c1 ff ff       	call   80101a70 <iunlockput>
  end_op();
8010595b:	e8 d0 d4 ff ff       	call   80102e30 <end_op>
  return -1;
80105960:	83 c4 10             	add    $0x10,%esp
80105963:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105968:	eb 9c                	jmp    80105906 <sys_unlink+0x116>
8010596a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105970:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105973:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105976:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010597b:	50                   	push   %eax
8010597c:	e8 af bd ff ff       	call   80101730 <iupdate>
80105981:	83 c4 10             	add    $0x10,%esp
80105984:	e9 53 ff ff ff       	jmp    801058dc <sys_unlink+0xec>
    return -1;
80105989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010598e:	e9 73 ff ff ff       	jmp    80105906 <sys_unlink+0x116>
    end_op();
80105993:	e8 98 d4 ff ff       	call   80102e30 <end_op>
    return -1;
80105998:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010599d:	e9 64 ff ff ff       	jmp    80105906 <sys_unlink+0x116>
      panic("isdirempty: readi");
801059a2:	83 ec 0c             	sub    $0xc,%esp
801059a5:	68 c4 82 10 80       	push   $0x801082c4
801059aa:	e8 d1 a9 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801059af:	83 ec 0c             	sub    $0xc,%esp
801059b2:	68 d6 82 10 80       	push   $0x801082d6
801059b7:	e8 c4 a9 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801059bc:	83 ec 0c             	sub    $0xc,%esp
801059bf:	68 b2 82 10 80       	push   $0x801082b2
801059c4:	e8 b7 a9 ff ff       	call   80100380 <panic>
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059d0 <sys_open>:

int
sys_open(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	57                   	push   %edi
801059d4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801059d8:	53                   	push   %ebx
801059d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059dc:	50                   	push   %eax
801059dd:	6a 00                	push   $0x0
801059df:	e8 fc f7 ff ff       	call   801051e0 <argstr>
801059e4:	83 c4 10             	add    $0x10,%esp
801059e7:	85 c0                	test   %eax,%eax
801059e9:	0f 88 8e 00 00 00    	js     80105a7d <sys_open+0xad>
801059ef:	83 ec 08             	sub    $0x8,%esp
801059f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059f5:	50                   	push   %eax
801059f6:	6a 01                	push   $0x1
801059f8:	e8 33 f7 ff ff       	call   80105130 <argint>
801059fd:	83 c4 10             	add    $0x10,%esp
80105a00:	85 c0                	test   %eax,%eax
80105a02:	78 79                	js     80105a7d <sys_open+0xad>
    return -1;

  begin_op();
80105a04:	e8 b7 d3 ff ff       	call   80102dc0 <begin_op>

  if(omode & O_CREATE){
80105a09:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a0d:	75 79                	jne    80105a88 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a0f:	83 ec 0c             	sub    $0xc,%esp
80105a12:	ff 75 e0             	push   -0x20(%ebp)
80105a15:	e8 e6 c6 ff ff       	call   80102100 <namei>
80105a1a:	83 c4 10             	add    $0x10,%esp
80105a1d:	89 c6                	mov    %eax,%esi
80105a1f:	85 c0                	test   %eax,%eax
80105a21:	0f 84 7e 00 00 00    	je     80105aa5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105a27:	83 ec 0c             	sub    $0xc,%esp
80105a2a:	50                   	push   %eax
80105a2b:	e8 b0 bd ff ff       	call   801017e0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a30:	83 c4 10             	add    $0x10,%esp
80105a33:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105a38:	0f 84 c2 00 00 00    	je     80105b00 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105a3e:	e8 4d b4 ff ff       	call   80100e90 <filealloc>
80105a43:	89 c7                	mov    %eax,%edi
80105a45:	85 c0                	test   %eax,%eax
80105a47:	74 23                	je     80105a6c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105a49:	e8 f2 df ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a4e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105a50:	8b 54 98 18          	mov    0x18(%eax,%ebx,4),%edx
80105a54:	85 d2                	test   %edx,%edx
80105a56:	74 60                	je     80105ab8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105a58:	83 c3 01             	add    $0x1,%ebx
80105a5b:	83 fb 10             	cmp    $0x10,%ebx
80105a5e:	75 f0                	jne    80105a50 <sys_open+0x80>
    if(f)
      fileclose(f);
80105a60:	83 ec 0c             	sub    $0xc,%esp
80105a63:	57                   	push   %edi
80105a64:	e8 e7 b4 ff ff       	call   80100f50 <fileclose>
80105a69:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105a6c:	83 ec 0c             	sub    $0xc,%esp
80105a6f:	56                   	push   %esi
80105a70:	e8 fb bf ff ff       	call   80101a70 <iunlockput>
    end_op();
80105a75:	e8 b6 d3 ff ff       	call   80102e30 <end_op>
    return -1;
80105a7a:	83 c4 10             	add    $0x10,%esp
80105a7d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a82:	eb 6d                	jmp    80105af1 <sys_open+0x121>
80105a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105a88:	83 ec 0c             	sub    $0xc,%esp
80105a8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105a8e:	31 c9                	xor    %ecx,%ecx
80105a90:	ba 02 00 00 00       	mov    $0x2,%edx
80105a95:	6a 00                	push   $0x0
80105a97:	e8 14 f8 ff ff       	call   801052b0 <create>
    if(ip == 0){
80105a9c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105a9f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105aa1:	85 c0                	test   %eax,%eax
80105aa3:	75 99                	jne    80105a3e <sys_open+0x6e>
      end_op();
80105aa5:	e8 86 d3 ff ff       	call   80102e30 <end_op>
      return -1;
80105aaa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105aaf:	eb 40                	jmp    80105af1 <sys_open+0x121>
80105ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105ab8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105abb:	89 7c 98 18          	mov    %edi,0x18(%eax,%ebx,4)
  iunlock(ip);
80105abf:	56                   	push   %esi
80105ac0:	e8 fb bd ff ff       	call   801018c0 <iunlock>
  end_op();
80105ac5:	e8 66 d3 ff ff       	call   80102e30 <end_op>

  f->type = FD_INODE;
80105aca:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105ad0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ad3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105ad6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105ad9:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105adb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105ae2:	f7 d0                	not    %eax
80105ae4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ae7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105aea:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105aed:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105af1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105af4:	89 d8                	mov    %ebx,%eax
80105af6:	5b                   	pop    %ebx
80105af7:	5e                   	pop    %esi
80105af8:	5f                   	pop    %edi
80105af9:	5d                   	pop    %ebp
80105afa:	c3                   	ret    
80105afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aff:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b00:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b03:	85 c9                	test   %ecx,%ecx
80105b05:	0f 84 33 ff ff ff    	je     80105a3e <sys_open+0x6e>
80105b0b:	e9 5c ff ff ff       	jmp    80105a6c <sys_open+0x9c>

80105b10 <sys_mkdir>:

int
sys_mkdir(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b16:	e8 a5 d2 ff ff       	call   80102dc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b1b:	83 ec 08             	sub    $0x8,%esp
80105b1e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b21:	50                   	push   %eax
80105b22:	6a 00                	push   $0x0
80105b24:	e8 b7 f6 ff ff       	call   801051e0 <argstr>
80105b29:	83 c4 10             	add    $0x10,%esp
80105b2c:	85 c0                	test   %eax,%eax
80105b2e:	78 30                	js     80105b60 <sys_mkdir+0x50>
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b36:	31 c9                	xor    %ecx,%ecx
80105b38:	ba 01 00 00 00       	mov    $0x1,%edx
80105b3d:	6a 00                	push   $0x0
80105b3f:	e8 6c f7 ff ff       	call   801052b0 <create>
80105b44:	83 c4 10             	add    $0x10,%esp
80105b47:	85 c0                	test   %eax,%eax
80105b49:	74 15                	je     80105b60 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b4b:	83 ec 0c             	sub    $0xc,%esp
80105b4e:	50                   	push   %eax
80105b4f:	e8 1c bf ff ff       	call   80101a70 <iunlockput>
  end_op();
80105b54:	e8 d7 d2 ff ff       	call   80102e30 <end_op>
  return 0;
80105b59:	83 c4 10             	add    $0x10,%esp
80105b5c:	31 c0                	xor    %eax,%eax
}
80105b5e:	c9                   	leave  
80105b5f:	c3                   	ret    
    end_op();
80105b60:	e8 cb d2 ff ff       	call   80102e30 <end_op>
    return -1;
80105b65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b6a:	c9                   	leave  
80105b6b:	c3                   	ret    
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b70 <sys_mknod>:

int
sys_mknod(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105b76:	e8 45 d2 ff ff       	call   80102dc0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105b7b:	83 ec 08             	sub    $0x8,%esp
80105b7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b81:	50                   	push   %eax
80105b82:	6a 00                	push   $0x0
80105b84:	e8 57 f6 ff ff       	call   801051e0 <argstr>
80105b89:	83 c4 10             	add    $0x10,%esp
80105b8c:	85 c0                	test   %eax,%eax
80105b8e:	78 60                	js     80105bf0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105b90:	83 ec 08             	sub    $0x8,%esp
80105b93:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b96:	50                   	push   %eax
80105b97:	6a 01                	push   $0x1
80105b99:	e8 92 f5 ff ff       	call   80105130 <argint>
  if((argstr(0, &path)) < 0 ||
80105b9e:	83 c4 10             	add    $0x10,%esp
80105ba1:	85 c0                	test   %eax,%eax
80105ba3:	78 4b                	js     80105bf0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105ba5:	83 ec 08             	sub    $0x8,%esp
80105ba8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bab:	50                   	push   %eax
80105bac:	6a 02                	push   $0x2
80105bae:	e8 7d f5 ff ff       	call   80105130 <argint>
     argint(1, &major) < 0 ||
80105bb3:	83 c4 10             	add    $0x10,%esp
80105bb6:	85 c0                	test   %eax,%eax
80105bb8:	78 36                	js     80105bf0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105bba:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105bbe:	83 ec 0c             	sub    $0xc,%esp
80105bc1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105bc5:	ba 03 00 00 00       	mov    $0x3,%edx
80105bca:	50                   	push   %eax
80105bcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105bce:	e8 dd f6 ff ff       	call   801052b0 <create>
     argint(2, &minor) < 0 ||
80105bd3:	83 c4 10             	add    $0x10,%esp
80105bd6:	85 c0                	test   %eax,%eax
80105bd8:	74 16                	je     80105bf0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bda:	83 ec 0c             	sub    $0xc,%esp
80105bdd:	50                   	push   %eax
80105bde:	e8 8d be ff ff       	call   80101a70 <iunlockput>
  end_op();
80105be3:	e8 48 d2 ff ff       	call   80102e30 <end_op>
  return 0;
80105be8:	83 c4 10             	add    $0x10,%esp
80105beb:	31 c0                	xor    %eax,%eax
}
80105bed:	c9                   	leave  
80105bee:	c3                   	ret    
80105bef:	90                   	nop
    end_op();
80105bf0:	e8 3b d2 ff ff       	call   80102e30 <end_op>
    return -1;
80105bf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bfa:	c9                   	leave  
80105bfb:	c3                   	ret    
80105bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c00 <sys_chdir>:

int
sys_chdir(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	56                   	push   %esi
80105c04:	53                   	push   %ebx
80105c05:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c08:	e8 33 de ff ff       	call   80103a40 <myproc>
80105c0d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105c0f:	e8 ac d1 ff ff       	call   80102dc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105c14:	83 ec 08             	sub    $0x8,%esp
80105c17:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c1a:	50                   	push   %eax
80105c1b:	6a 00                	push   $0x0
80105c1d:	e8 be f5 ff ff       	call   801051e0 <argstr>
80105c22:	83 c4 10             	add    $0x10,%esp
80105c25:	85 c0                	test   %eax,%eax
80105c27:	78 77                	js     80105ca0 <sys_chdir+0xa0>
80105c29:	83 ec 0c             	sub    $0xc,%esp
80105c2c:	ff 75 f4             	push   -0xc(%ebp)
80105c2f:	e8 cc c4 ff ff       	call   80102100 <namei>
80105c34:	83 c4 10             	add    $0x10,%esp
80105c37:	89 c3                	mov    %eax,%ebx
80105c39:	85 c0                	test   %eax,%eax
80105c3b:	74 63                	je     80105ca0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105c3d:	83 ec 0c             	sub    $0xc,%esp
80105c40:	50                   	push   %eax
80105c41:	e8 9a bb ff ff       	call   801017e0 <ilock>
  if(ip->type != T_DIR){
80105c46:	83 c4 10             	add    $0x10,%esp
80105c49:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c4e:	75 30                	jne    80105c80 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105c50:	83 ec 0c             	sub    $0xc,%esp
80105c53:	53                   	push   %ebx
80105c54:	e8 67 bc ff ff       	call   801018c0 <iunlock>
  iput(curproc->cwd);
80105c59:	58                   	pop    %eax
80105c5a:	ff 76 58             	push   0x58(%esi)
80105c5d:	e8 ae bc ff ff       	call   80101910 <iput>
  end_op();
80105c62:	e8 c9 d1 ff ff       	call   80102e30 <end_op>
  curproc->cwd = ip;
80105c67:	89 5e 58             	mov    %ebx,0x58(%esi)
  return 0;
80105c6a:	83 c4 10             	add    $0x10,%esp
80105c6d:	31 c0                	xor    %eax,%eax
}
80105c6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c72:	5b                   	pop    %ebx
80105c73:	5e                   	pop    %esi
80105c74:	5d                   	pop    %ebp
80105c75:	c3                   	ret    
80105c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105c80:	83 ec 0c             	sub    $0xc,%esp
80105c83:	53                   	push   %ebx
80105c84:	e8 e7 bd ff ff       	call   80101a70 <iunlockput>
    end_op();
80105c89:	e8 a2 d1 ff ff       	call   80102e30 <end_op>
    return -1;
80105c8e:	83 c4 10             	add    $0x10,%esp
80105c91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c96:	eb d7                	jmp    80105c6f <sys_chdir+0x6f>
80105c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9f:	90                   	nop
    end_op();
80105ca0:	e8 8b d1 ff ff       	call   80102e30 <end_op>
    return -1;
80105ca5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105caa:	eb c3                	jmp    80105c6f <sys_chdir+0x6f>
80105cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cb0 <sys_exec>:

int
sys_exec(void)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	57                   	push   %edi
80105cb4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105cb5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105cbb:	53                   	push   %ebx
80105cbc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105cc2:	50                   	push   %eax
80105cc3:	6a 00                	push   $0x0
80105cc5:	e8 16 f5 ff ff       	call   801051e0 <argstr>
80105cca:	83 c4 10             	add    $0x10,%esp
80105ccd:	85 c0                	test   %eax,%eax
80105ccf:	0f 88 87 00 00 00    	js     80105d5c <sys_exec+0xac>
80105cd5:	83 ec 08             	sub    $0x8,%esp
80105cd8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105cde:	50                   	push   %eax
80105cdf:	6a 01                	push   $0x1
80105ce1:	e8 4a f4 ff ff       	call   80105130 <argint>
80105ce6:	83 c4 10             	add    $0x10,%esp
80105ce9:	85 c0                	test   %eax,%eax
80105ceb:	78 6f                	js     80105d5c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105ced:	83 ec 04             	sub    $0x4,%esp
80105cf0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105cf6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105cf8:	68 80 00 00 00       	push   $0x80
80105cfd:	6a 00                	push   $0x0
80105cff:	56                   	push   %esi
80105d00:	e8 6b f1 ff ff       	call   80104e70 <memset>
80105d05:	83 c4 10             	add    $0x10,%esp
80105d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d10:	83 ec 08             	sub    $0x8,%esp
80105d13:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105d19:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105d20:	50                   	push   %eax
80105d21:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d27:	01 f8                	add    %edi,%eax
80105d29:	50                   	push   %eax
80105d2a:	e8 71 f3 ff ff       	call   801050a0 <fetchint>
80105d2f:	83 c4 10             	add    $0x10,%esp
80105d32:	85 c0                	test   %eax,%eax
80105d34:	78 26                	js     80105d5c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105d36:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105d3c:	85 c0                	test   %eax,%eax
80105d3e:	74 30                	je     80105d70 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105d40:	83 ec 08             	sub    $0x8,%esp
80105d43:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105d46:	52                   	push   %edx
80105d47:	50                   	push   %eax
80105d48:	e8 93 f3 ff ff       	call   801050e0 <fetchstr>
80105d4d:	83 c4 10             	add    $0x10,%esp
80105d50:	85 c0                	test   %eax,%eax
80105d52:	78 08                	js     80105d5c <sys_exec+0xac>
  for(i=0;; i++){
80105d54:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105d57:	83 fb 20             	cmp    $0x20,%ebx
80105d5a:	75 b4                	jne    80105d10 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105d5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d64:	5b                   	pop    %ebx
80105d65:	5e                   	pop    %esi
80105d66:	5f                   	pop    %edi
80105d67:	5d                   	pop    %ebp
80105d68:	c3                   	ret    
80105d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105d70:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105d77:	00 00 00 00 
  return exec(path, argv);
80105d7b:	83 ec 08             	sub    $0x8,%esp
80105d7e:	56                   	push   %esi
80105d7f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105d85:	e8 26 ad ff ff       	call   80100ab0 <exec>
80105d8a:	83 c4 10             	add    $0x10,%esp
}
80105d8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d90:	5b                   	pop    %ebx
80105d91:	5e                   	pop    %esi
80105d92:	5f                   	pop    %edi
80105d93:	5d                   	pop    %ebp
80105d94:	c3                   	ret    
80105d95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105da0 <sys_pipe>:

int
sys_pipe(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	57                   	push   %edi
80105da4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105da5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105da8:	53                   	push   %ebx
80105da9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105dac:	6a 08                	push   $0x8
80105dae:	50                   	push   %eax
80105daf:	6a 00                	push   $0x0
80105db1:	e8 da f3 ff ff       	call   80105190 <argptr>
80105db6:	83 c4 10             	add    $0x10,%esp
80105db9:	85 c0                	test   %eax,%eax
80105dbb:	78 4a                	js     80105e07 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105dbd:	83 ec 08             	sub    $0x8,%esp
80105dc0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105dc3:	50                   	push   %eax
80105dc4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105dc7:	50                   	push   %eax
80105dc8:	e8 c3 d6 ff ff       	call   80103490 <pipealloc>
80105dcd:	83 c4 10             	add    $0x10,%esp
80105dd0:	85 c0                	test   %eax,%eax
80105dd2:	78 33                	js     80105e07 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105dd4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105dd7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105dd9:	e8 62 dc ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105dde:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105de0:	8b 74 98 18          	mov    0x18(%eax,%ebx,4),%esi
80105de4:	85 f6                	test   %esi,%esi
80105de6:	74 28                	je     80105e10 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105de8:	83 c3 01             	add    $0x1,%ebx
80105deb:	83 fb 10             	cmp    $0x10,%ebx
80105dee:	75 f0                	jne    80105de0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105df0:	83 ec 0c             	sub    $0xc,%esp
80105df3:	ff 75 e0             	push   -0x20(%ebp)
80105df6:	e8 55 b1 ff ff       	call   80100f50 <fileclose>
    fileclose(wf);
80105dfb:	58                   	pop    %eax
80105dfc:	ff 75 e4             	push   -0x1c(%ebp)
80105dff:	e8 4c b1 ff ff       	call   80100f50 <fileclose>
    return -1;
80105e04:	83 c4 10             	add    $0x10,%esp
80105e07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e0c:	eb 53                	jmp    80105e61 <sys_pipe+0xc1>
80105e0e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e10:	8d 73 04             	lea    0x4(%ebx),%esi
80105e13:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105e1a:	e8 21 dc ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e1f:	31 d2                	xor    %edx,%edx
80105e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105e28:	8b 4c 90 18          	mov    0x18(%eax,%edx,4),%ecx
80105e2c:	85 c9                	test   %ecx,%ecx
80105e2e:	74 20                	je     80105e50 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105e30:	83 c2 01             	add    $0x1,%edx
80105e33:	83 fa 10             	cmp    $0x10,%edx
80105e36:	75 f0                	jne    80105e28 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105e38:	e8 03 dc ff ff       	call   80103a40 <myproc>
80105e3d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105e44:	00 
80105e45:	eb a9                	jmp    80105df0 <sys_pipe+0x50>
80105e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e50:	89 7c 90 18          	mov    %edi,0x18(%eax,%edx,4)
  }
  fd[0] = fd0;
80105e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e57:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105e59:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e5c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105e5f:	31 c0                	xor    %eax,%eax
}
80105e61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e64:	5b                   	pop    %ebx
80105e65:	5e                   	pop    %esi
80105e66:	5f                   	pop    %edi
80105e67:	5d                   	pop    %ebp
80105e68:	c3                   	ret    
80105e69:	66 90                	xchg   %ax,%ax
80105e6b:	66 90                	xchg   %ax,%ax
80105e6d:	66 90                	xchg   %ax,%ax
80105e6f:	90                   	nop

80105e70 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105e70:	e9 7b dd ff ff       	jmp    80103bf0 <fork>
80105e75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e80 <sys_exit>:
}

int
sys_exit(void)
{
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
80105e83:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e86:	e8 95 e0 ff ff       	call   80103f20 <exit>
  return 0;  // not reached
}
80105e8b:	31 c0                	xor    %eax,%eax
80105e8d:	c9                   	leave  
80105e8e:	c3                   	ret    
80105e8f:	90                   	nop

80105e90 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105e90:	e9 fb e1 ff ff       	jmp    80104090 <wait>
80105e95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ea0 <sys_kill>:
}

int
sys_kill(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ea6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ea9:	50                   	push   %eax
80105eaa:	6a 00                	push   $0x0
80105eac:	e8 7f f2 ff ff       	call   80105130 <argint>
80105eb1:	83 c4 10             	add    $0x10,%esp
80105eb4:	85 c0                	test   %eax,%eax
80105eb6:	78 18                	js     80105ed0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105eb8:	83 ec 0c             	sub    $0xc,%esp
80105ebb:	ff 75 f4             	push   -0xc(%ebp)
80105ebe:	e8 8d e5 ff ff       	call   80104450 <kill>
80105ec3:	83 c4 10             	add    $0x10,%esp
}
80105ec6:	c9                   	leave  
80105ec7:	c3                   	ret    
80105ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ecf:	90                   	nop
80105ed0:	c9                   	leave  
    return -1;
80105ed1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ed6:	c3                   	ret    
80105ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ede:	66 90                	xchg   %ax,%ax

80105ee0 <sys_getpid>:

int
sys_getpid(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105ee6:	e8 55 db ff ff       	call   80103a40 <myproc>
80105eeb:	8b 40 0c             	mov    0xc(%eax),%eax
}
80105eee:	c9                   	leave  
80105eef:	c3                   	ret    

80105ef0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ef4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ef7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105efa:	50                   	push   %eax
80105efb:	6a 00                	push   $0x0
80105efd:	e8 2e f2 ff ff       	call   80105130 <argint>
80105f02:	83 c4 10             	add    $0x10,%esp
80105f05:	85 c0                	test   %eax,%eax
80105f07:	78 27                	js     80105f30 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f09:	e8 32 db ff ff       	call   80103a40 <myproc>
  if(growproc(n) < 0)
80105f0e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105f11:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105f13:	ff 75 f4             	push   -0xc(%ebp)
80105f16:	e8 55 dc ff ff       	call   80103b70 <growproc>
80105f1b:	83 c4 10             	add    $0x10,%esp
80105f1e:	85 c0                	test   %eax,%eax
80105f20:	78 0e                	js     80105f30 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105f22:	89 d8                	mov    %ebx,%eax
80105f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f27:	c9                   	leave  
80105f28:	c3                   	ret    
80105f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f35:	eb eb                	jmp    80105f22 <sys_sbrk+0x32>
80105f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3e:	66 90                	xchg   %ax,%ax

80105f40 <sys_sleep>:

int
sys_sleep(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105f44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f4a:	50                   	push   %eax
80105f4b:	6a 00                	push   $0x0
80105f4d:	e8 de f1 ff ff       	call   80105130 <argint>
80105f52:	83 c4 10             	add    $0x10,%esp
80105f55:	85 c0                	test   %eax,%eax
80105f57:	0f 88 8a 00 00 00    	js     80105fe7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105f5d:	83 ec 0c             	sub    $0xc,%esp
80105f60:	68 80 49 13 80       	push   $0x80134980
80105f65:	e8 46 ee ff ff       	call   80104db0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105f6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105f6d:	8b 1d 60 49 13 80    	mov    0x80134960,%ebx
  while(ticks - ticks0 < n){
80105f73:	83 c4 10             	add    $0x10,%esp
80105f76:	85 d2                	test   %edx,%edx
80105f78:	75 27                	jne    80105fa1 <sys_sleep+0x61>
80105f7a:	eb 54                	jmp    80105fd0 <sys_sleep+0x90>
80105f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105f80:	83 ec 08             	sub    $0x8,%esp
80105f83:	68 80 49 13 80       	push   $0x80134980
80105f88:	68 60 49 13 80       	push   $0x80134960
80105f8d:	e8 4e e3 ff ff       	call   801042e0 <sleep>
  while(ticks - ticks0 < n){
80105f92:	a1 60 49 13 80       	mov    0x80134960,%eax
80105f97:	83 c4 10             	add    $0x10,%esp
80105f9a:	29 d8                	sub    %ebx,%eax
80105f9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105f9f:	73 2f                	jae    80105fd0 <sys_sleep+0x90>
    if(myproc()->killed){
80105fa1:	e8 9a da ff ff       	call   80103a40 <myproc>
80105fa6:	8b 40 14             	mov    0x14(%eax),%eax
80105fa9:	85 c0                	test   %eax,%eax
80105fab:	74 d3                	je     80105f80 <sys_sleep+0x40>
      release(&tickslock);
80105fad:	83 ec 0c             	sub    $0xc,%esp
80105fb0:	68 80 49 13 80       	push   $0x80134980
80105fb5:	e8 96 ed ff ff       	call   80104d50 <release>
  }
  release(&tickslock);
  return 0;
}
80105fba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105fbd:	83 c4 10             	add    $0x10,%esp
80105fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fc5:	c9                   	leave  
80105fc6:	c3                   	ret    
80105fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fce:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105fd0:	83 ec 0c             	sub    $0xc,%esp
80105fd3:	68 80 49 13 80       	push   $0x80134980
80105fd8:	e8 73 ed ff ff       	call   80104d50 <release>
  return 0;
80105fdd:	83 c4 10             	add    $0x10,%esp
80105fe0:	31 c0                	xor    %eax,%eax
}
80105fe2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fe5:	c9                   	leave  
80105fe6:	c3                   	ret    
    return -1;
80105fe7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fec:	eb f4                	jmp    80105fe2 <sys_sleep+0xa2>
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	53                   	push   %ebx
80105ff4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ff7:	68 80 49 13 80       	push   $0x80134980
80105ffc:	e8 af ed ff ff       	call   80104db0 <acquire>
  xticks = ticks;
80106001:	8b 1d 60 49 13 80    	mov    0x80134960,%ebx
  release(&tickslock);
80106007:	c7 04 24 80 49 13 80 	movl   $0x80134980,(%esp)
8010600e:	e8 3d ed ff ff       	call   80104d50 <release>
  return xticks;
}
80106013:	89 d8                	mov    %ebx,%eax
80106015:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106018:	c9                   	leave  
80106019:	c3                   	ret    
8010601a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106020 <sys_thread_create>:

int
sys_thread_create(void)
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	83 ec 1c             	sub    $0x1c,%esp
  thread_t *t;
  void*(*func)(void*);
  void *arg;
  if(argptr(0, (char**)&t, sizeof t) < 0)
80106026:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106029:	6a 04                	push   $0x4
8010602b:	50                   	push   %eax
8010602c:	6a 00                	push   $0x0
8010602e:	e8 5d f1 ff ff       	call   80105190 <argptr>
80106033:	83 c4 10             	add    $0x10,%esp
80106036:	85 c0                	test   %eax,%eax
80106038:	78 46                	js     80106080 <sys_thread_create+0x60>
	return -1;
  if(argptr(1, (char**)&func, sizeof func) < 0)
8010603a:	83 ec 04             	sub    $0x4,%esp
8010603d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106040:	6a 04                	push   $0x4
80106042:	50                   	push   %eax
80106043:	6a 01                	push   $0x1
80106045:	e8 46 f1 ff ff       	call   80105190 <argptr>
8010604a:	83 c4 10             	add    $0x10,%esp
8010604d:	85 c0                	test   %eax,%eax
8010604f:	78 2f                	js     80106080 <sys_thread_create+0x60>
	return -1;
  if(argptr(2, (char**)&arg, sizeof arg) < 0)
80106051:	83 ec 04             	sub    $0x4,%esp
80106054:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106057:	6a 04                	push   $0x4
80106059:	50                   	push   %eax
8010605a:	6a 02                	push   $0x2
8010605c:	e8 2f f1 ff ff       	call   80105190 <argptr>
80106061:	83 c4 10             	add    $0x10,%esp
80106064:	85 c0                	test   %eax,%eax
80106066:	78 18                	js     80106080 <sys_thread_create+0x60>
	return -1;
  return thread_create(t, func, arg);
80106068:	83 ec 04             	sub    $0x4,%esp
8010606b:	ff 75 f4             	push   -0xc(%ebp)
8010606e:	ff 75 f0             	push   -0x10(%ebp)
80106071:	ff 75 ec             	push   -0x14(%ebp)
80106074:	e8 47 e5 ff ff       	call   801045c0 <thread_create>
80106079:	83 c4 10             	add    $0x10,%esp
}
8010607c:	c9                   	leave  
8010607d:	c3                   	ret    
8010607e:	66 90                	xchg   %ax,%ax
80106080:	c9                   	leave  
	return -1;
80106081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106086:	c3                   	ret    
80106087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010608e:	66 90                	xchg   %ax,%ax

80106090 <sys_thread_exit>:

int
sys_thread_exit(void)
{
80106090:	55                   	push   %ebp
80106091:	89 e5                	mov    %esp,%ebp
80106093:	83 ec 1c             	sub    $0x1c,%esp
  void* ret;
  if(argptr(0, (char**)&ret, sizeof ret) < 0)
80106096:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106099:	6a 04                	push   $0x4
8010609b:	50                   	push   %eax
8010609c:	6a 00                	push   $0x0
8010609e:	e8 ed f0 ff ff       	call   80105190 <argptr>
801060a3:	83 c4 10             	add    $0x10,%esp
801060a6:	89 c2                	mov    %eax,%edx
801060a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ad:	85 d2                	test   %edx,%edx
801060af:	78 13                	js     801060c4 <sys_thread_exit+0x34>
	return -1;
  thread_exit(ret);
801060b1:	83 ec 0c             	sub    $0xc,%esp
801060b4:	ff 75 f4             	push   -0xc(%ebp)
801060b7:	e8 f4 e6 ff ff       	call   801047b0 <thread_exit>
  return 1;
801060bc:	83 c4 10             	add    $0x10,%esp
801060bf:	b8 01 00 00 00       	mov    $0x1,%eax
}
801060c4:	c9                   	leave  
801060c5:	c3                   	ret    
801060c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060cd:	8d 76 00             	lea    0x0(%esi),%esi

801060d0 <sys_thread_join>:

int
sys_thread_join(void)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	83 ec 20             	sub    $0x20,%esp
  thread_t tid;
  void **ret;
  if(argint(0, &tid) < 0)
801060d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060d9:	50                   	push   %eax
801060da:	6a 00                	push   $0x0
801060dc:	e8 4f f0 ff ff       	call   80105130 <argint>
801060e1:	83 c4 10             	add    $0x10,%esp
801060e4:	85 c0                	test   %eax,%eax
801060e6:	78 30                	js     80106118 <sys_thread_join+0x48>
	return -1;
  if(argptr(1, (char**)&ret, sizeof ret) < 0)
801060e8:	83 ec 04             	sub    $0x4,%esp
801060eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060ee:	6a 04                	push   $0x4
801060f0:	50                   	push   %eax
801060f1:	6a 01                	push   $0x1
801060f3:	e8 98 f0 ff ff       	call   80105190 <argptr>
801060f8:	83 c4 10             	add    $0x10,%esp
801060fb:	85 c0                	test   %eax,%eax
801060fd:	78 19                	js     80106118 <sys_thread_join+0x48>
	return -1;
  return thread_join(tid, ret);
801060ff:	83 ec 08             	sub    $0x8,%esp
80106102:	ff 75 f4             	push   -0xc(%ebp)
80106105:	ff 75 f0             	push   -0x10(%ebp)
80106108:	e8 43 e7 ff ff       	call   80104850 <thread_join>
8010610d:	83 c4 10             	add    $0x10,%esp
}
80106110:	c9                   	leave  
80106111:	c3                   	ret    
80106112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106118:	c9                   	leave  
	return -1;
80106119:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010611e:	c3                   	ret    

8010611f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010611f:	1e                   	push   %ds
  pushl %es
80106120:	06                   	push   %es
  pushl %fs
80106121:	0f a0                	push   %fs
  pushl %gs
80106123:	0f a8                	push   %gs
  pushal
80106125:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106126:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010612a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010612c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010612e:	54                   	push   %esp
  call trap
8010612f:	e8 cc 00 00 00       	call   80106200 <trap>
  addl $4, %esp
80106134:	83 c4 04             	add    $0x4,%esp

80106137 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106137:	61                   	popa   
  popl %gs
80106138:	0f a9                	pop    %gs
  popl %fs
8010613a:	0f a1                	pop    %fs
  popl %es
8010613c:	07                   	pop    %es
  popl %ds
8010613d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010613e:	83 c4 08             	add    $0x8,%esp
  iret
80106141:	cf                   	iret   
80106142:	66 90                	xchg   %ax,%ax
80106144:	66 90                	xchg   %ax,%ax
80106146:	66 90                	xchg   %ax,%ax
80106148:	66 90                	xchg   %ax,%ax
8010614a:	66 90                	xchg   %ax,%ax
8010614c:	66 90                	xchg   %ax,%ax
8010614e:	66 90                	xchg   %ax,%ax

80106150 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106150:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106151:	31 c0                	xor    %eax,%eax
{
80106153:	89 e5                	mov    %esp,%ebp
80106155:	83 ec 08             	sub    $0x8,%esp
80106158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010615f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106160:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80106167:	c7 04 c5 c2 49 13 80 	movl   $0x8e000008,-0x7fecb63e(,%eax,8)
8010616e:	08 00 00 8e 
80106172:	66 89 14 c5 c0 49 13 	mov    %dx,-0x7fecb640(,%eax,8)
80106179:	80 
8010617a:	c1 ea 10             	shr    $0x10,%edx
8010617d:	66 89 14 c5 c6 49 13 	mov    %dx,-0x7fecb63a(,%eax,8)
80106184:	80 
  for(i = 0; i < 256; i++)
80106185:	83 c0 01             	add    $0x1,%eax
80106188:	3d 00 01 00 00       	cmp    $0x100,%eax
8010618d:	75 d1                	jne    80106160 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010618f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106192:	a1 0c b1 10 80       	mov    0x8010b10c,%eax
80106197:	c7 05 c2 4b 13 80 08 	movl   $0xef000008,0x80134bc2
8010619e:	00 00 ef 
  initlock(&tickslock, "time");
801061a1:	68 e5 82 10 80       	push   $0x801082e5
801061a6:	68 80 49 13 80       	push   $0x80134980
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061ab:	66 a3 c0 4b 13 80    	mov    %ax,0x80134bc0
801061b1:	c1 e8 10             	shr    $0x10,%eax
801061b4:	66 a3 c6 4b 13 80    	mov    %ax,0x80134bc6
  initlock(&tickslock, "time");
801061ba:	e8 21 ea ff ff       	call   80104be0 <initlock>
}
801061bf:	83 c4 10             	add    $0x10,%esp
801061c2:	c9                   	leave  
801061c3:	c3                   	ret    
801061c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061cf:	90                   	nop

801061d0 <idtinit>:

void
idtinit(void)
{
801061d0:	55                   	push   %ebp
  pd[0] = size-1;
801061d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061d6:	89 e5                	mov    %esp,%ebp
801061d8:	83 ec 10             	sub    $0x10,%esp
801061db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801061df:	b8 c0 49 13 80       	mov    $0x801349c0,%eax
801061e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801061e8:	c1 e8 10             	shr    $0x10,%eax
801061eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801061ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801061f2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801061f5:	c9                   	leave  
801061f6:	c3                   	ret    
801061f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061fe:	66 90                	xchg   %ax,%ax

80106200 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106200:	55                   	push   %ebp
80106201:	89 e5                	mov    %esp,%ebp
80106203:	57                   	push   %edi
80106204:	56                   	push   %esi
80106205:	53                   	push   %ebx
80106206:	83 ec 1c             	sub    $0x1c,%esp
80106209:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010620c:	8b 43 30             	mov    0x30(%ebx),%eax
8010620f:	83 f8 40             	cmp    $0x40,%eax
80106212:	0f 84 78 01 00 00    	je     80106390 <trap+0x190>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106218:	83 e8 20             	sub    $0x20,%eax
8010621b:	83 f8 1f             	cmp    $0x1f,%eax
8010621e:	0f 87 9c 00 00 00    	ja     801062c0 <trap+0xc0>
80106224:	ff 24 85 8c 83 10 80 	jmp    *-0x7fef7c74(,%eax,4)
8010622b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010622f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106230:	e8 6b c0 ff ff       	call   801022a0 <ideintr>
    lapiceoi();
80106235:	e8 36 c7 ff ff       	call   80102970 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010623a:	e8 01 d8 ff ff       	call   80103a40 <myproc>
8010623f:	85 c0                	test   %eax,%eax
80106241:	74 1d                	je     80106260 <trap+0x60>
80106243:	e8 f8 d7 ff ff       	call   80103a40 <myproc>
80106248:	8b 50 14             	mov    0x14(%eax),%edx
8010624b:	85 d2                	test   %edx,%edx
8010624d:	74 11                	je     80106260 <trap+0x60>
8010624f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106253:	83 e0 03             	and    $0x3,%eax
80106256:	66 83 f8 03          	cmp    $0x3,%ax
8010625a:	0f 84 10 02 00 00    	je     80106470 <trap+0x270>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->threads[myproc()->curtidx].state == RUNNING &&
80106260:	e8 db d7 ff ff       	call   80103a40 <myproc>
80106265:	85 c0                	test   %eax,%eax
80106267:	74 20                	je     80106289 <trap+0x89>
80106269:	e8 d2 d7 ff ff       	call   80103a40 <myproc>
8010626e:	89 c6                	mov    %eax,%esi
80106270:	e8 cb d7 ff ff       	call   80103a40 <myproc>
80106275:	8b 80 6c 08 00 00    	mov    0x86c(%eax),%eax
8010627b:	c1 e0 05             	shl    $0x5,%eax
8010627e:	83 7c 30 6c 04       	cmpl   $0x4,0x6c(%eax,%esi,1)
80106283:	0f 84 b7 00 00 00    	je     80106340 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106289:	e8 b2 d7 ff ff       	call   80103a40 <myproc>
8010628e:	85 c0                	test   %eax,%eax
80106290:	74 1d                	je     801062af <trap+0xaf>
80106292:	e8 a9 d7 ff ff       	call   80103a40 <myproc>
80106297:	8b 40 14             	mov    0x14(%eax),%eax
8010629a:	85 c0                	test   %eax,%eax
8010629c:	74 11                	je     801062af <trap+0xaf>
8010629e:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062a2:	83 e0 03             	and    $0x3,%eax
801062a5:	66 83 f8 03          	cmp    $0x3,%ax
801062a9:	0f 84 28 01 00 00    	je     801063d7 <trap+0x1d7>
    exit();
}
801062af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062b2:	5b                   	pop    %ebx
801062b3:	5e                   	pop    %esi
801062b4:	5f                   	pop    %edi
801062b5:	5d                   	pop    %ebp
801062b6:	c3                   	ret    
801062b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062be:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
801062c0:	e8 7b d7 ff ff       	call   80103a40 <myproc>
801062c5:	8b 7b 38             	mov    0x38(%ebx),%edi
801062c8:	85 c0                	test   %eax,%eax
801062ca:	0f 84 ba 01 00 00    	je     8010648a <trap+0x28a>
801062d0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801062d4:	0f 84 b0 01 00 00    	je     8010648a <trap+0x28a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801062da:	0f 20 d1             	mov    %cr2,%ecx
801062dd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062e0:	e8 3b d7 ff ff       	call   80103a20 <cpuid>
801062e5:	8b 73 30             	mov    0x30(%ebx),%esi
801062e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801062eb:	8b 43 34             	mov    0x34(%ebx),%eax
801062ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801062f1:	e8 4a d7 ff ff       	call   80103a40 <myproc>
801062f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801062f9:	e8 42 d7 ff ff       	call   80103a40 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062fe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106301:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106304:	51                   	push   %ecx
80106305:	57                   	push   %edi
80106306:	52                   	push   %edx
80106307:	ff 75 e4             	push   -0x1c(%ebp)
8010630a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010630b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010630e:	83 c6 5c             	add    $0x5c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106311:	56                   	push   %esi
80106312:	ff 70 0c             	push   0xc(%eax)
80106315:	68 48 83 10 80       	push   $0x80108348
8010631a:	e8 81 a3 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
8010631f:	83 c4 20             	add    $0x20,%esp
80106322:	e8 19 d7 ff ff       	call   80103a40 <myproc>
80106327:	c7 40 14 01 00 00 00 	movl   $0x1,0x14(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010632e:	e8 0d d7 ff ff       	call   80103a40 <myproc>
80106333:	85 c0                	test   %eax,%eax
80106335:	0f 85 08 ff ff ff    	jne    80106243 <trap+0x43>
8010633b:	e9 20 ff ff ff       	jmp    80106260 <trap+0x60>
  if(myproc() && myproc()->threads[myproc()->curtidx].state == RUNNING &&
80106340:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106344:	0f 85 3f ff ff ff    	jne    80106289 <trap+0x89>
    yield();
8010634a:	e8 01 df ff ff       	call   80104250 <yield>
8010634f:	e9 35 ff ff ff       	jmp    80106289 <trap+0x89>
80106354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106358:	8b 7b 38             	mov    0x38(%ebx),%edi
8010635b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010635f:	e8 bc d6 ff ff       	call   80103a20 <cpuid>
80106364:	57                   	push   %edi
80106365:	56                   	push   %esi
80106366:	50                   	push   %eax
80106367:	68 f0 82 10 80       	push   $0x801082f0
8010636c:	e8 2f a3 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106371:	e8 fa c5 ff ff       	call   80102970 <lapiceoi>
    break;
80106376:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106379:	e8 c2 d6 ff ff       	call   80103a40 <myproc>
8010637e:	85 c0                	test   %eax,%eax
80106380:	0f 85 bd fe ff ff    	jne    80106243 <trap+0x43>
80106386:	e9 d5 fe ff ff       	jmp    80106260 <trap+0x60>
8010638b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010638f:	90                   	nop
    if(myproc()->killed)
80106390:	e8 ab d6 ff ff       	call   80103a40 <myproc>
80106395:	8b 70 14             	mov    0x14(%eax),%esi
80106398:	85 f6                	test   %esi,%esi
8010639a:	0f 85 e0 00 00 00    	jne    80106480 <trap+0x280>
    if(myproc() != 0){
801063a0:	e8 9b d6 ff ff       	call   80103a40 <myproc>
801063a5:	85 c0                	test   %eax,%eax
801063a7:	74 19                	je     801063c2 <trap+0x1c2>
	  struct thread *t = &myproc()->threads[myproc()->curtidx];
801063a9:	e8 92 d6 ff ff       	call   80103a40 <myproc>
801063ae:	89 c6                	mov    %eax,%esi
801063b0:	e8 8b d6 ff ff       	call   80103a40 <myproc>
801063b5:	8b 80 6c 08 00 00    	mov    0x86c(%eax),%eax
	  t->tf = tf;
801063bb:	c1 e0 05             	shl    $0x5,%eax
801063be:	89 5c 30 78          	mov    %ebx,0x78(%eax,%esi,1)
    syscall();
801063c2:	e8 79 ee ff ff       	call   80105240 <syscall>
    if(myproc()->killed)
801063c7:	e8 74 d6 ff ff       	call   80103a40 <myproc>
801063cc:	8b 48 14             	mov    0x14(%eax),%ecx
801063cf:	85 c9                	test   %ecx,%ecx
801063d1:	0f 84 d8 fe ff ff    	je     801062af <trap+0xaf>
}
801063d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063da:	5b                   	pop    %ebx
801063db:	5e                   	pop    %esi
801063dc:	5f                   	pop    %edi
801063dd:	5d                   	pop    %ebp
      exit();
801063de:	e9 3d db ff ff       	jmp    80103f20 <exit>
801063e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063e7:	90                   	nop
    uartintr();
801063e8:	e8 43 02 00 00       	call   80106630 <uartintr>
    lapiceoi();
801063ed:	e8 7e c5 ff ff       	call   80102970 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063f2:	e8 49 d6 ff ff       	call   80103a40 <myproc>
801063f7:	85 c0                	test   %eax,%eax
801063f9:	0f 85 44 fe ff ff    	jne    80106243 <trap+0x43>
801063ff:	e9 5c fe ff ff       	jmp    80106260 <trap+0x60>
80106404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106408:	e8 23 c4 ff ff       	call   80102830 <kbdintr>
    lapiceoi();
8010640d:	e8 5e c5 ff ff       	call   80102970 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106412:	e8 29 d6 ff ff       	call   80103a40 <myproc>
80106417:	85 c0                	test   %eax,%eax
80106419:	0f 85 24 fe ff ff    	jne    80106243 <trap+0x43>
8010641f:	e9 3c fe ff ff       	jmp    80106260 <trap+0x60>
80106424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106428:	e8 f3 d5 ff ff       	call   80103a20 <cpuid>
8010642d:	85 c0                	test   %eax,%eax
8010642f:	0f 85 00 fe ff ff    	jne    80106235 <trap+0x35>
      acquire(&tickslock);
80106435:	83 ec 0c             	sub    $0xc,%esp
80106438:	68 80 49 13 80       	push   $0x80134980
8010643d:	e8 6e e9 ff ff       	call   80104db0 <acquire>
      wakeup(&ticks);
80106442:	c7 04 24 60 49 13 80 	movl   $0x80134960,(%esp)
      ticks++;
80106449:	83 05 60 49 13 80 01 	addl   $0x1,0x80134960
      wakeup(&ticks);
80106450:	e8 8b df ff ff       	call   801043e0 <wakeup>
      release(&tickslock);
80106455:	c7 04 24 80 49 13 80 	movl   $0x80134980,(%esp)
8010645c:	e8 ef e8 ff ff       	call   80104d50 <release>
80106461:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106464:	e9 cc fd ff ff       	jmp    80106235 <trap+0x35>
80106469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106470:	e8 ab da ff ff       	call   80103f20 <exit>
80106475:	e9 e6 fd ff ff       	jmp    80106260 <trap+0x60>
8010647a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106480:	e8 9b da ff ff       	call   80103f20 <exit>
80106485:	e9 16 ff ff ff       	jmp    801063a0 <trap+0x1a0>
8010648a:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010648d:	e8 8e d5 ff ff       	call   80103a20 <cpuid>
80106492:	83 ec 0c             	sub    $0xc,%esp
80106495:	56                   	push   %esi
80106496:	57                   	push   %edi
80106497:	50                   	push   %eax
80106498:	ff 73 30             	push   0x30(%ebx)
8010649b:	68 14 83 10 80       	push   $0x80108314
801064a0:	e8 fb a1 ff ff       	call   801006a0 <cprintf>
      panic("trap");
801064a5:	83 c4 14             	add    $0x14,%esp
801064a8:	68 ea 82 10 80       	push   $0x801082ea
801064ad:	e8 ce 9e ff ff       	call   80100380 <panic>
801064b2:	66 90                	xchg   %ax,%ax
801064b4:	66 90                	xchg   %ax,%ax
801064b6:	66 90                	xchg   %ax,%ax
801064b8:	66 90                	xchg   %ax,%ax
801064ba:	66 90                	xchg   %ax,%ax
801064bc:	66 90                	xchg   %ax,%ax
801064be:	66 90                	xchg   %ax,%ax

801064c0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801064c0:	a1 c0 51 13 80       	mov    0x801351c0,%eax
801064c5:	85 c0                	test   %eax,%eax
801064c7:	74 17                	je     801064e0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064c9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064ce:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801064cf:	a8 01                	test   $0x1,%al
801064d1:	74 0d                	je     801064e0 <uartgetc+0x20>
801064d3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064d8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801064d9:	0f b6 c0             	movzbl %al,%eax
801064dc:	c3                   	ret    
801064dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801064e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064e5:	c3                   	ret    
801064e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ed:	8d 76 00             	lea    0x0(%esi),%esi

801064f0 <uartinit>:
{
801064f0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064f1:	31 c9                	xor    %ecx,%ecx
801064f3:	89 c8                	mov    %ecx,%eax
801064f5:	89 e5                	mov    %esp,%ebp
801064f7:	57                   	push   %edi
801064f8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801064fd:	56                   	push   %esi
801064fe:	89 fa                	mov    %edi,%edx
80106500:	53                   	push   %ebx
80106501:	83 ec 1c             	sub    $0x1c,%esp
80106504:	ee                   	out    %al,(%dx)
80106505:	be fb 03 00 00       	mov    $0x3fb,%esi
8010650a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010650f:	89 f2                	mov    %esi,%edx
80106511:	ee                   	out    %al,(%dx)
80106512:	b8 0c 00 00 00       	mov    $0xc,%eax
80106517:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010651c:	ee                   	out    %al,(%dx)
8010651d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106522:	89 c8                	mov    %ecx,%eax
80106524:	89 da                	mov    %ebx,%edx
80106526:	ee                   	out    %al,(%dx)
80106527:	b8 03 00 00 00       	mov    $0x3,%eax
8010652c:	89 f2                	mov    %esi,%edx
8010652e:	ee                   	out    %al,(%dx)
8010652f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106534:	89 c8                	mov    %ecx,%eax
80106536:	ee                   	out    %al,(%dx)
80106537:	b8 01 00 00 00       	mov    $0x1,%eax
8010653c:	89 da                	mov    %ebx,%edx
8010653e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010653f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106544:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106545:	3c ff                	cmp    $0xff,%al
80106547:	74 78                	je     801065c1 <uartinit+0xd1>
  uart = 1;
80106549:	c7 05 c0 51 13 80 01 	movl   $0x1,0x801351c0
80106550:	00 00 00 
80106553:	89 fa                	mov    %edi,%edx
80106555:	ec                   	in     (%dx),%al
80106556:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010655b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010655c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010655f:	bf 0c 84 10 80       	mov    $0x8010840c,%edi
80106564:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106569:	6a 00                	push   $0x0
8010656b:	6a 04                	push   $0x4
8010656d:	e8 6e bf ff ff       	call   801024e0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106572:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106576:	83 c4 10             	add    $0x10,%esp
80106579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106580:	a1 c0 51 13 80       	mov    0x801351c0,%eax
80106585:	bb 80 00 00 00       	mov    $0x80,%ebx
8010658a:	85 c0                	test   %eax,%eax
8010658c:	75 14                	jne    801065a2 <uartinit+0xb2>
8010658e:	eb 23                	jmp    801065b3 <uartinit+0xc3>
    microdelay(10);
80106590:	83 ec 0c             	sub    $0xc,%esp
80106593:	6a 0a                	push   $0xa
80106595:	e8 f6 c3 ff ff       	call   80102990 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010659a:	83 c4 10             	add    $0x10,%esp
8010659d:	83 eb 01             	sub    $0x1,%ebx
801065a0:	74 07                	je     801065a9 <uartinit+0xb9>
801065a2:	89 f2                	mov    %esi,%edx
801065a4:	ec                   	in     (%dx),%al
801065a5:	a8 20                	test   $0x20,%al
801065a7:	74 e7                	je     80106590 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065a9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801065ad:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065b2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801065b3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801065b7:	83 c7 01             	add    $0x1,%edi
801065ba:	88 45 e7             	mov    %al,-0x19(%ebp)
801065bd:	84 c0                	test   %al,%al
801065bf:	75 bf                	jne    80106580 <uartinit+0x90>
}
801065c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065c4:	5b                   	pop    %ebx
801065c5:	5e                   	pop    %esi
801065c6:	5f                   	pop    %edi
801065c7:	5d                   	pop    %ebp
801065c8:	c3                   	ret    
801065c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065d0 <uartputc>:
  if(!uart)
801065d0:	a1 c0 51 13 80       	mov    0x801351c0,%eax
801065d5:	85 c0                	test   %eax,%eax
801065d7:	74 47                	je     80106620 <uartputc+0x50>
{
801065d9:	55                   	push   %ebp
801065da:	89 e5                	mov    %esp,%ebp
801065dc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065dd:	be fd 03 00 00       	mov    $0x3fd,%esi
801065e2:	53                   	push   %ebx
801065e3:	bb 80 00 00 00       	mov    $0x80,%ebx
801065e8:	eb 18                	jmp    80106602 <uartputc+0x32>
801065ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801065f0:	83 ec 0c             	sub    $0xc,%esp
801065f3:	6a 0a                	push   $0xa
801065f5:	e8 96 c3 ff ff       	call   80102990 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065fa:	83 c4 10             	add    $0x10,%esp
801065fd:	83 eb 01             	sub    $0x1,%ebx
80106600:	74 07                	je     80106609 <uartputc+0x39>
80106602:	89 f2                	mov    %esi,%edx
80106604:	ec                   	in     (%dx),%al
80106605:	a8 20                	test   $0x20,%al
80106607:	74 e7                	je     801065f0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106609:	8b 45 08             	mov    0x8(%ebp),%eax
8010660c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106611:	ee                   	out    %al,(%dx)
}
80106612:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106615:	5b                   	pop    %ebx
80106616:	5e                   	pop    %esi
80106617:	5d                   	pop    %ebp
80106618:	c3                   	ret    
80106619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106620:	c3                   	ret    
80106621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010662f:	90                   	nop

80106630 <uartintr>:

void
uartintr(void)
{
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106636:	68 c0 64 10 80       	push   $0x801064c0
8010663b:	e8 40 a2 ff ff       	call   80100880 <consoleintr>
}
80106640:	83 c4 10             	add    $0x10,%esp
80106643:	c9                   	leave  
80106644:	c3                   	ret    

80106645 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $0
80106647:	6a 00                	push   $0x0
  jmp alltraps
80106649:	e9 d1 fa ff ff       	jmp    8010611f <alltraps>

8010664e <vector1>:
.globl vector1
vector1:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $1
80106650:	6a 01                	push   $0x1
  jmp alltraps
80106652:	e9 c8 fa ff ff       	jmp    8010611f <alltraps>

80106657 <vector2>:
.globl vector2
vector2:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $2
80106659:	6a 02                	push   $0x2
  jmp alltraps
8010665b:	e9 bf fa ff ff       	jmp    8010611f <alltraps>

80106660 <vector3>:
.globl vector3
vector3:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $3
80106662:	6a 03                	push   $0x3
  jmp alltraps
80106664:	e9 b6 fa ff ff       	jmp    8010611f <alltraps>

80106669 <vector4>:
.globl vector4
vector4:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $4
8010666b:	6a 04                	push   $0x4
  jmp alltraps
8010666d:	e9 ad fa ff ff       	jmp    8010611f <alltraps>

80106672 <vector5>:
.globl vector5
vector5:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $5
80106674:	6a 05                	push   $0x5
  jmp alltraps
80106676:	e9 a4 fa ff ff       	jmp    8010611f <alltraps>

8010667b <vector6>:
.globl vector6
vector6:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $6
8010667d:	6a 06                	push   $0x6
  jmp alltraps
8010667f:	e9 9b fa ff ff       	jmp    8010611f <alltraps>

80106684 <vector7>:
.globl vector7
vector7:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $7
80106686:	6a 07                	push   $0x7
  jmp alltraps
80106688:	e9 92 fa ff ff       	jmp    8010611f <alltraps>

8010668d <vector8>:
.globl vector8
vector8:
  pushl $8
8010668d:	6a 08                	push   $0x8
  jmp alltraps
8010668f:	e9 8b fa ff ff       	jmp    8010611f <alltraps>

80106694 <vector9>:
.globl vector9
vector9:
  pushl $0
80106694:	6a 00                	push   $0x0
  pushl $9
80106696:	6a 09                	push   $0x9
  jmp alltraps
80106698:	e9 82 fa ff ff       	jmp    8010611f <alltraps>

8010669d <vector10>:
.globl vector10
vector10:
  pushl $10
8010669d:	6a 0a                	push   $0xa
  jmp alltraps
8010669f:	e9 7b fa ff ff       	jmp    8010611f <alltraps>

801066a4 <vector11>:
.globl vector11
vector11:
  pushl $11
801066a4:	6a 0b                	push   $0xb
  jmp alltraps
801066a6:	e9 74 fa ff ff       	jmp    8010611f <alltraps>

801066ab <vector12>:
.globl vector12
vector12:
  pushl $12
801066ab:	6a 0c                	push   $0xc
  jmp alltraps
801066ad:	e9 6d fa ff ff       	jmp    8010611f <alltraps>

801066b2 <vector13>:
.globl vector13
vector13:
  pushl $13
801066b2:	6a 0d                	push   $0xd
  jmp alltraps
801066b4:	e9 66 fa ff ff       	jmp    8010611f <alltraps>

801066b9 <vector14>:
.globl vector14
vector14:
  pushl $14
801066b9:	6a 0e                	push   $0xe
  jmp alltraps
801066bb:	e9 5f fa ff ff       	jmp    8010611f <alltraps>

801066c0 <vector15>:
.globl vector15
vector15:
  pushl $0
801066c0:	6a 00                	push   $0x0
  pushl $15
801066c2:	6a 0f                	push   $0xf
  jmp alltraps
801066c4:	e9 56 fa ff ff       	jmp    8010611f <alltraps>

801066c9 <vector16>:
.globl vector16
vector16:
  pushl $0
801066c9:	6a 00                	push   $0x0
  pushl $16
801066cb:	6a 10                	push   $0x10
  jmp alltraps
801066cd:	e9 4d fa ff ff       	jmp    8010611f <alltraps>

801066d2 <vector17>:
.globl vector17
vector17:
  pushl $17
801066d2:	6a 11                	push   $0x11
  jmp alltraps
801066d4:	e9 46 fa ff ff       	jmp    8010611f <alltraps>

801066d9 <vector18>:
.globl vector18
vector18:
  pushl $0
801066d9:	6a 00                	push   $0x0
  pushl $18
801066db:	6a 12                	push   $0x12
  jmp alltraps
801066dd:	e9 3d fa ff ff       	jmp    8010611f <alltraps>

801066e2 <vector19>:
.globl vector19
vector19:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $19
801066e4:	6a 13                	push   $0x13
  jmp alltraps
801066e6:	e9 34 fa ff ff       	jmp    8010611f <alltraps>

801066eb <vector20>:
.globl vector20
vector20:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $20
801066ed:	6a 14                	push   $0x14
  jmp alltraps
801066ef:	e9 2b fa ff ff       	jmp    8010611f <alltraps>

801066f4 <vector21>:
.globl vector21
vector21:
  pushl $0
801066f4:	6a 00                	push   $0x0
  pushl $21
801066f6:	6a 15                	push   $0x15
  jmp alltraps
801066f8:	e9 22 fa ff ff       	jmp    8010611f <alltraps>

801066fd <vector22>:
.globl vector22
vector22:
  pushl $0
801066fd:	6a 00                	push   $0x0
  pushl $22
801066ff:	6a 16                	push   $0x16
  jmp alltraps
80106701:	e9 19 fa ff ff       	jmp    8010611f <alltraps>

80106706 <vector23>:
.globl vector23
vector23:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $23
80106708:	6a 17                	push   $0x17
  jmp alltraps
8010670a:	e9 10 fa ff ff       	jmp    8010611f <alltraps>

8010670f <vector24>:
.globl vector24
vector24:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $24
80106711:	6a 18                	push   $0x18
  jmp alltraps
80106713:	e9 07 fa ff ff       	jmp    8010611f <alltraps>

80106718 <vector25>:
.globl vector25
vector25:
  pushl $0
80106718:	6a 00                	push   $0x0
  pushl $25
8010671a:	6a 19                	push   $0x19
  jmp alltraps
8010671c:	e9 fe f9 ff ff       	jmp    8010611f <alltraps>

80106721 <vector26>:
.globl vector26
vector26:
  pushl $0
80106721:	6a 00                	push   $0x0
  pushl $26
80106723:	6a 1a                	push   $0x1a
  jmp alltraps
80106725:	e9 f5 f9 ff ff       	jmp    8010611f <alltraps>

8010672a <vector27>:
.globl vector27
vector27:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $27
8010672c:	6a 1b                	push   $0x1b
  jmp alltraps
8010672e:	e9 ec f9 ff ff       	jmp    8010611f <alltraps>

80106733 <vector28>:
.globl vector28
vector28:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $28
80106735:	6a 1c                	push   $0x1c
  jmp alltraps
80106737:	e9 e3 f9 ff ff       	jmp    8010611f <alltraps>

8010673c <vector29>:
.globl vector29
vector29:
  pushl $0
8010673c:	6a 00                	push   $0x0
  pushl $29
8010673e:	6a 1d                	push   $0x1d
  jmp alltraps
80106740:	e9 da f9 ff ff       	jmp    8010611f <alltraps>

80106745 <vector30>:
.globl vector30
vector30:
  pushl $0
80106745:	6a 00                	push   $0x0
  pushl $30
80106747:	6a 1e                	push   $0x1e
  jmp alltraps
80106749:	e9 d1 f9 ff ff       	jmp    8010611f <alltraps>

8010674e <vector31>:
.globl vector31
vector31:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $31
80106750:	6a 1f                	push   $0x1f
  jmp alltraps
80106752:	e9 c8 f9 ff ff       	jmp    8010611f <alltraps>

80106757 <vector32>:
.globl vector32
vector32:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $32
80106759:	6a 20                	push   $0x20
  jmp alltraps
8010675b:	e9 bf f9 ff ff       	jmp    8010611f <alltraps>

80106760 <vector33>:
.globl vector33
vector33:
  pushl $0
80106760:	6a 00                	push   $0x0
  pushl $33
80106762:	6a 21                	push   $0x21
  jmp alltraps
80106764:	e9 b6 f9 ff ff       	jmp    8010611f <alltraps>

80106769 <vector34>:
.globl vector34
vector34:
  pushl $0
80106769:	6a 00                	push   $0x0
  pushl $34
8010676b:	6a 22                	push   $0x22
  jmp alltraps
8010676d:	e9 ad f9 ff ff       	jmp    8010611f <alltraps>

80106772 <vector35>:
.globl vector35
vector35:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $35
80106774:	6a 23                	push   $0x23
  jmp alltraps
80106776:	e9 a4 f9 ff ff       	jmp    8010611f <alltraps>

8010677b <vector36>:
.globl vector36
vector36:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $36
8010677d:	6a 24                	push   $0x24
  jmp alltraps
8010677f:	e9 9b f9 ff ff       	jmp    8010611f <alltraps>

80106784 <vector37>:
.globl vector37
vector37:
  pushl $0
80106784:	6a 00                	push   $0x0
  pushl $37
80106786:	6a 25                	push   $0x25
  jmp alltraps
80106788:	e9 92 f9 ff ff       	jmp    8010611f <alltraps>

8010678d <vector38>:
.globl vector38
vector38:
  pushl $0
8010678d:	6a 00                	push   $0x0
  pushl $38
8010678f:	6a 26                	push   $0x26
  jmp alltraps
80106791:	e9 89 f9 ff ff       	jmp    8010611f <alltraps>

80106796 <vector39>:
.globl vector39
vector39:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $39
80106798:	6a 27                	push   $0x27
  jmp alltraps
8010679a:	e9 80 f9 ff ff       	jmp    8010611f <alltraps>

8010679f <vector40>:
.globl vector40
vector40:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $40
801067a1:	6a 28                	push   $0x28
  jmp alltraps
801067a3:	e9 77 f9 ff ff       	jmp    8010611f <alltraps>

801067a8 <vector41>:
.globl vector41
vector41:
  pushl $0
801067a8:	6a 00                	push   $0x0
  pushl $41
801067aa:	6a 29                	push   $0x29
  jmp alltraps
801067ac:	e9 6e f9 ff ff       	jmp    8010611f <alltraps>

801067b1 <vector42>:
.globl vector42
vector42:
  pushl $0
801067b1:	6a 00                	push   $0x0
  pushl $42
801067b3:	6a 2a                	push   $0x2a
  jmp alltraps
801067b5:	e9 65 f9 ff ff       	jmp    8010611f <alltraps>

801067ba <vector43>:
.globl vector43
vector43:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $43
801067bc:	6a 2b                	push   $0x2b
  jmp alltraps
801067be:	e9 5c f9 ff ff       	jmp    8010611f <alltraps>

801067c3 <vector44>:
.globl vector44
vector44:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $44
801067c5:	6a 2c                	push   $0x2c
  jmp alltraps
801067c7:	e9 53 f9 ff ff       	jmp    8010611f <alltraps>

801067cc <vector45>:
.globl vector45
vector45:
  pushl $0
801067cc:	6a 00                	push   $0x0
  pushl $45
801067ce:	6a 2d                	push   $0x2d
  jmp alltraps
801067d0:	e9 4a f9 ff ff       	jmp    8010611f <alltraps>

801067d5 <vector46>:
.globl vector46
vector46:
  pushl $0
801067d5:	6a 00                	push   $0x0
  pushl $46
801067d7:	6a 2e                	push   $0x2e
  jmp alltraps
801067d9:	e9 41 f9 ff ff       	jmp    8010611f <alltraps>

801067de <vector47>:
.globl vector47
vector47:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $47
801067e0:	6a 2f                	push   $0x2f
  jmp alltraps
801067e2:	e9 38 f9 ff ff       	jmp    8010611f <alltraps>

801067e7 <vector48>:
.globl vector48
vector48:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $48
801067e9:	6a 30                	push   $0x30
  jmp alltraps
801067eb:	e9 2f f9 ff ff       	jmp    8010611f <alltraps>

801067f0 <vector49>:
.globl vector49
vector49:
  pushl $0
801067f0:	6a 00                	push   $0x0
  pushl $49
801067f2:	6a 31                	push   $0x31
  jmp alltraps
801067f4:	e9 26 f9 ff ff       	jmp    8010611f <alltraps>

801067f9 <vector50>:
.globl vector50
vector50:
  pushl $0
801067f9:	6a 00                	push   $0x0
  pushl $50
801067fb:	6a 32                	push   $0x32
  jmp alltraps
801067fd:	e9 1d f9 ff ff       	jmp    8010611f <alltraps>

80106802 <vector51>:
.globl vector51
vector51:
  pushl $0
80106802:	6a 00                	push   $0x0
  pushl $51
80106804:	6a 33                	push   $0x33
  jmp alltraps
80106806:	e9 14 f9 ff ff       	jmp    8010611f <alltraps>

8010680b <vector52>:
.globl vector52
vector52:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $52
8010680d:	6a 34                	push   $0x34
  jmp alltraps
8010680f:	e9 0b f9 ff ff       	jmp    8010611f <alltraps>

80106814 <vector53>:
.globl vector53
vector53:
  pushl $0
80106814:	6a 00                	push   $0x0
  pushl $53
80106816:	6a 35                	push   $0x35
  jmp alltraps
80106818:	e9 02 f9 ff ff       	jmp    8010611f <alltraps>

8010681d <vector54>:
.globl vector54
vector54:
  pushl $0
8010681d:	6a 00                	push   $0x0
  pushl $54
8010681f:	6a 36                	push   $0x36
  jmp alltraps
80106821:	e9 f9 f8 ff ff       	jmp    8010611f <alltraps>

80106826 <vector55>:
.globl vector55
vector55:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $55
80106828:	6a 37                	push   $0x37
  jmp alltraps
8010682a:	e9 f0 f8 ff ff       	jmp    8010611f <alltraps>

8010682f <vector56>:
.globl vector56
vector56:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $56
80106831:	6a 38                	push   $0x38
  jmp alltraps
80106833:	e9 e7 f8 ff ff       	jmp    8010611f <alltraps>

80106838 <vector57>:
.globl vector57
vector57:
  pushl $0
80106838:	6a 00                	push   $0x0
  pushl $57
8010683a:	6a 39                	push   $0x39
  jmp alltraps
8010683c:	e9 de f8 ff ff       	jmp    8010611f <alltraps>

80106841 <vector58>:
.globl vector58
vector58:
  pushl $0
80106841:	6a 00                	push   $0x0
  pushl $58
80106843:	6a 3a                	push   $0x3a
  jmp alltraps
80106845:	e9 d5 f8 ff ff       	jmp    8010611f <alltraps>

8010684a <vector59>:
.globl vector59
vector59:
  pushl $0
8010684a:	6a 00                	push   $0x0
  pushl $59
8010684c:	6a 3b                	push   $0x3b
  jmp alltraps
8010684e:	e9 cc f8 ff ff       	jmp    8010611f <alltraps>

80106853 <vector60>:
.globl vector60
vector60:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $60
80106855:	6a 3c                	push   $0x3c
  jmp alltraps
80106857:	e9 c3 f8 ff ff       	jmp    8010611f <alltraps>

8010685c <vector61>:
.globl vector61
vector61:
  pushl $0
8010685c:	6a 00                	push   $0x0
  pushl $61
8010685e:	6a 3d                	push   $0x3d
  jmp alltraps
80106860:	e9 ba f8 ff ff       	jmp    8010611f <alltraps>

80106865 <vector62>:
.globl vector62
vector62:
  pushl $0
80106865:	6a 00                	push   $0x0
  pushl $62
80106867:	6a 3e                	push   $0x3e
  jmp alltraps
80106869:	e9 b1 f8 ff ff       	jmp    8010611f <alltraps>

8010686e <vector63>:
.globl vector63
vector63:
  pushl $0
8010686e:	6a 00                	push   $0x0
  pushl $63
80106870:	6a 3f                	push   $0x3f
  jmp alltraps
80106872:	e9 a8 f8 ff ff       	jmp    8010611f <alltraps>

80106877 <vector64>:
.globl vector64
vector64:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $64
80106879:	6a 40                	push   $0x40
  jmp alltraps
8010687b:	e9 9f f8 ff ff       	jmp    8010611f <alltraps>

80106880 <vector65>:
.globl vector65
vector65:
  pushl $0
80106880:	6a 00                	push   $0x0
  pushl $65
80106882:	6a 41                	push   $0x41
  jmp alltraps
80106884:	e9 96 f8 ff ff       	jmp    8010611f <alltraps>

80106889 <vector66>:
.globl vector66
vector66:
  pushl $0
80106889:	6a 00                	push   $0x0
  pushl $66
8010688b:	6a 42                	push   $0x42
  jmp alltraps
8010688d:	e9 8d f8 ff ff       	jmp    8010611f <alltraps>

80106892 <vector67>:
.globl vector67
vector67:
  pushl $0
80106892:	6a 00                	push   $0x0
  pushl $67
80106894:	6a 43                	push   $0x43
  jmp alltraps
80106896:	e9 84 f8 ff ff       	jmp    8010611f <alltraps>

8010689b <vector68>:
.globl vector68
vector68:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $68
8010689d:	6a 44                	push   $0x44
  jmp alltraps
8010689f:	e9 7b f8 ff ff       	jmp    8010611f <alltraps>

801068a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801068a4:	6a 00                	push   $0x0
  pushl $69
801068a6:	6a 45                	push   $0x45
  jmp alltraps
801068a8:	e9 72 f8 ff ff       	jmp    8010611f <alltraps>

801068ad <vector70>:
.globl vector70
vector70:
  pushl $0
801068ad:	6a 00                	push   $0x0
  pushl $70
801068af:	6a 46                	push   $0x46
  jmp alltraps
801068b1:	e9 69 f8 ff ff       	jmp    8010611f <alltraps>

801068b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801068b6:	6a 00                	push   $0x0
  pushl $71
801068b8:	6a 47                	push   $0x47
  jmp alltraps
801068ba:	e9 60 f8 ff ff       	jmp    8010611f <alltraps>

801068bf <vector72>:
.globl vector72
vector72:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $72
801068c1:	6a 48                	push   $0x48
  jmp alltraps
801068c3:	e9 57 f8 ff ff       	jmp    8010611f <alltraps>

801068c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801068c8:	6a 00                	push   $0x0
  pushl $73
801068ca:	6a 49                	push   $0x49
  jmp alltraps
801068cc:	e9 4e f8 ff ff       	jmp    8010611f <alltraps>

801068d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801068d1:	6a 00                	push   $0x0
  pushl $74
801068d3:	6a 4a                	push   $0x4a
  jmp alltraps
801068d5:	e9 45 f8 ff ff       	jmp    8010611f <alltraps>

801068da <vector75>:
.globl vector75
vector75:
  pushl $0
801068da:	6a 00                	push   $0x0
  pushl $75
801068dc:	6a 4b                	push   $0x4b
  jmp alltraps
801068de:	e9 3c f8 ff ff       	jmp    8010611f <alltraps>

801068e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $76
801068e5:	6a 4c                	push   $0x4c
  jmp alltraps
801068e7:	e9 33 f8 ff ff       	jmp    8010611f <alltraps>

801068ec <vector77>:
.globl vector77
vector77:
  pushl $0
801068ec:	6a 00                	push   $0x0
  pushl $77
801068ee:	6a 4d                	push   $0x4d
  jmp alltraps
801068f0:	e9 2a f8 ff ff       	jmp    8010611f <alltraps>

801068f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801068f5:	6a 00                	push   $0x0
  pushl $78
801068f7:	6a 4e                	push   $0x4e
  jmp alltraps
801068f9:	e9 21 f8 ff ff       	jmp    8010611f <alltraps>

801068fe <vector79>:
.globl vector79
vector79:
  pushl $0
801068fe:	6a 00                	push   $0x0
  pushl $79
80106900:	6a 4f                	push   $0x4f
  jmp alltraps
80106902:	e9 18 f8 ff ff       	jmp    8010611f <alltraps>

80106907 <vector80>:
.globl vector80
vector80:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $80
80106909:	6a 50                	push   $0x50
  jmp alltraps
8010690b:	e9 0f f8 ff ff       	jmp    8010611f <alltraps>

80106910 <vector81>:
.globl vector81
vector81:
  pushl $0
80106910:	6a 00                	push   $0x0
  pushl $81
80106912:	6a 51                	push   $0x51
  jmp alltraps
80106914:	e9 06 f8 ff ff       	jmp    8010611f <alltraps>

80106919 <vector82>:
.globl vector82
vector82:
  pushl $0
80106919:	6a 00                	push   $0x0
  pushl $82
8010691b:	6a 52                	push   $0x52
  jmp alltraps
8010691d:	e9 fd f7 ff ff       	jmp    8010611f <alltraps>

80106922 <vector83>:
.globl vector83
vector83:
  pushl $0
80106922:	6a 00                	push   $0x0
  pushl $83
80106924:	6a 53                	push   $0x53
  jmp alltraps
80106926:	e9 f4 f7 ff ff       	jmp    8010611f <alltraps>

8010692b <vector84>:
.globl vector84
vector84:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $84
8010692d:	6a 54                	push   $0x54
  jmp alltraps
8010692f:	e9 eb f7 ff ff       	jmp    8010611f <alltraps>

80106934 <vector85>:
.globl vector85
vector85:
  pushl $0
80106934:	6a 00                	push   $0x0
  pushl $85
80106936:	6a 55                	push   $0x55
  jmp alltraps
80106938:	e9 e2 f7 ff ff       	jmp    8010611f <alltraps>

8010693d <vector86>:
.globl vector86
vector86:
  pushl $0
8010693d:	6a 00                	push   $0x0
  pushl $86
8010693f:	6a 56                	push   $0x56
  jmp alltraps
80106941:	e9 d9 f7 ff ff       	jmp    8010611f <alltraps>

80106946 <vector87>:
.globl vector87
vector87:
  pushl $0
80106946:	6a 00                	push   $0x0
  pushl $87
80106948:	6a 57                	push   $0x57
  jmp alltraps
8010694a:	e9 d0 f7 ff ff       	jmp    8010611f <alltraps>

8010694f <vector88>:
.globl vector88
vector88:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $88
80106951:	6a 58                	push   $0x58
  jmp alltraps
80106953:	e9 c7 f7 ff ff       	jmp    8010611f <alltraps>

80106958 <vector89>:
.globl vector89
vector89:
  pushl $0
80106958:	6a 00                	push   $0x0
  pushl $89
8010695a:	6a 59                	push   $0x59
  jmp alltraps
8010695c:	e9 be f7 ff ff       	jmp    8010611f <alltraps>

80106961 <vector90>:
.globl vector90
vector90:
  pushl $0
80106961:	6a 00                	push   $0x0
  pushl $90
80106963:	6a 5a                	push   $0x5a
  jmp alltraps
80106965:	e9 b5 f7 ff ff       	jmp    8010611f <alltraps>

8010696a <vector91>:
.globl vector91
vector91:
  pushl $0
8010696a:	6a 00                	push   $0x0
  pushl $91
8010696c:	6a 5b                	push   $0x5b
  jmp alltraps
8010696e:	e9 ac f7 ff ff       	jmp    8010611f <alltraps>

80106973 <vector92>:
.globl vector92
vector92:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $92
80106975:	6a 5c                	push   $0x5c
  jmp alltraps
80106977:	e9 a3 f7 ff ff       	jmp    8010611f <alltraps>

8010697c <vector93>:
.globl vector93
vector93:
  pushl $0
8010697c:	6a 00                	push   $0x0
  pushl $93
8010697e:	6a 5d                	push   $0x5d
  jmp alltraps
80106980:	e9 9a f7 ff ff       	jmp    8010611f <alltraps>

80106985 <vector94>:
.globl vector94
vector94:
  pushl $0
80106985:	6a 00                	push   $0x0
  pushl $94
80106987:	6a 5e                	push   $0x5e
  jmp alltraps
80106989:	e9 91 f7 ff ff       	jmp    8010611f <alltraps>

8010698e <vector95>:
.globl vector95
vector95:
  pushl $0
8010698e:	6a 00                	push   $0x0
  pushl $95
80106990:	6a 5f                	push   $0x5f
  jmp alltraps
80106992:	e9 88 f7 ff ff       	jmp    8010611f <alltraps>

80106997 <vector96>:
.globl vector96
vector96:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $96
80106999:	6a 60                	push   $0x60
  jmp alltraps
8010699b:	e9 7f f7 ff ff       	jmp    8010611f <alltraps>

801069a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801069a0:	6a 00                	push   $0x0
  pushl $97
801069a2:	6a 61                	push   $0x61
  jmp alltraps
801069a4:	e9 76 f7 ff ff       	jmp    8010611f <alltraps>

801069a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801069a9:	6a 00                	push   $0x0
  pushl $98
801069ab:	6a 62                	push   $0x62
  jmp alltraps
801069ad:	e9 6d f7 ff ff       	jmp    8010611f <alltraps>

801069b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801069b2:	6a 00                	push   $0x0
  pushl $99
801069b4:	6a 63                	push   $0x63
  jmp alltraps
801069b6:	e9 64 f7 ff ff       	jmp    8010611f <alltraps>

801069bb <vector100>:
.globl vector100
vector100:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $100
801069bd:	6a 64                	push   $0x64
  jmp alltraps
801069bf:	e9 5b f7 ff ff       	jmp    8010611f <alltraps>

801069c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801069c4:	6a 00                	push   $0x0
  pushl $101
801069c6:	6a 65                	push   $0x65
  jmp alltraps
801069c8:	e9 52 f7 ff ff       	jmp    8010611f <alltraps>

801069cd <vector102>:
.globl vector102
vector102:
  pushl $0
801069cd:	6a 00                	push   $0x0
  pushl $102
801069cf:	6a 66                	push   $0x66
  jmp alltraps
801069d1:	e9 49 f7 ff ff       	jmp    8010611f <alltraps>

801069d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801069d6:	6a 00                	push   $0x0
  pushl $103
801069d8:	6a 67                	push   $0x67
  jmp alltraps
801069da:	e9 40 f7 ff ff       	jmp    8010611f <alltraps>

801069df <vector104>:
.globl vector104
vector104:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $104
801069e1:	6a 68                	push   $0x68
  jmp alltraps
801069e3:	e9 37 f7 ff ff       	jmp    8010611f <alltraps>

801069e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801069e8:	6a 00                	push   $0x0
  pushl $105
801069ea:	6a 69                	push   $0x69
  jmp alltraps
801069ec:	e9 2e f7 ff ff       	jmp    8010611f <alltraps>

801069f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801069f1:	6a 00                	push   $0x0
  pushl $106
801069f3:	6a 6a                	push   $0x6a
  jmp alltraps
801069f5:	e9 25 f7 ff ff       	jmp    8010611f <alltraps>

801069fa <vector107>:
.globl vector107
vector107:
  pushl $0
801069fa:	6a 00                	push   $0x0
  pushl $107
801069fc:	6a 6b                	push   $0x6b
  jmp alltraps
801069fe:	e9 1c f7 ff ff       	jmp    8010611f <alltraps>

80106a03 <vector108>:
.globl vector108
vector108:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $108
80106a05:	6a 6c                	push   $0x6c
  jmp alltraps
80106a07:	e9 13 f7 ff ff       	jmp    8010611f <alltraps>

80106a0c <vector109>:
.globl vector109
vector109:
  pushl $0
80106a0c:	6a 00                	push   $0x0
  pushl $109
80106a0e:	6a 6d                	push   $0x6d
  jmp alltraps
80106a10:	e9 0a f7 ff ff       	jmp    8010611f <alltraps>

80106a15 <vector110>:
.globl vector110
vector110:
  pushl $0
80106a15:	6a 00                	push   $0x0
  pushl $110
80106a17:	6a 6e                	push   $0x6e
  jmp alltraps
80106a19:	e9 01 f7 ff ff       	jmp    8010611f <alltraps>

80106a1e <vector111>:
.globl vector111
vector111:
  pushl $0
80106a1e:	6a 00                	push   $0x0
  pushl $111
80106a20:	6a 6f                	push   $0x6f
  jmp alltraps
80106a22:	e9 f8 f6 ff ff       	jmp    8010611f <alltraps>

80106a27 <vector112>:
.globl vector112
vector112:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $112
80106a29:	6a 70                	push   $0x70
  jmp alltraps
80106a2b:	e9 ef f6 ff ff       	jmp    8010611f <alltraps>

80106a30 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a30:	6a 00                	push   $0x0
  pushl $113
80106a32:	6a 71                	push   $0x71
  jmp alltraps
80106a34:	e9 e6 f6 ff ff       	jmp    8010611f <alltraps>

80106a39 <vector114>:
.globl vector114
vector114:
  pushl $0
80106a39:	6a 00                	push   $0x0
  pushl $114
80106a3b:	6a 72                	push   $0x72
  jmp alltraps
80106a3d:	e9 dd f6 ff ff       	jmp    8010611f <alltraps>

80106a42 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a42:	6a 00                	push   $0x0
  pushl $115
80106a44:	6a 73                	push   $0x73
  jmp alltraps
80106a46:	e9 d4 f6 ff ff       	jmp    8010611f <alltraps>

80106a4b <vector116>:
.globl vector116
vector116:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $116
80106a4d:	6a 74                	push   $0x74
  jmp alltraps
80106a4f:	e9 cb f6 ff ff       	jmp    8010611f <alltraps>

80106a54 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a54:	6a 00                	push   $0x0
  pushl $117
80106a56:	6a 75                	push   $0x75
  jmp alltraps
80106a58:	e9 c2 f6 ff ff       	jmp    8010611f <alltraps>

80106a5d <vector118>:
.globl vector118
vector118:
  pushl $0
80106a5d:	6a 00                	push   $0x0
  pushl $118
80106a5f:	6a 76                	push   $0x76
  jmp alltraps
80106a61:	e9 b9 f6 ff ff       	jmp    8010611f <alltraps>

80106a66 <vector119>:
.globl vector119
vector119:
  pushl $0
80106a66:	6a 00                	push   $0x0
  pushl $119
80106a68:	6a 77                	push   $0x77
  jmp alltraps
80106a6a:	e9 b0 f6 ff ff       	jmp    8010611f <alltraps>

80106a6f <vector120>:
.globl vector120
vector120:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $120
80106a71:	6a 78                	push   $0x78
  jmp alltraps
80106a73:	e9 a7 f6 ff ff       	jmp    8010611f <alltraps>

80106a78 <vector121>:
.globl vector121
vector121:
  pushl $0
80106a78:	6a 00                	push   $0x0
  pushl $121
80106a7a:	6a 79                	push   $0x79
  jmp alltraps
80106a7c:	e9 9e f6 ff ff       	jmp    8010611f <alltraps>

80106a81 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a81:	6a 00                	push   $0x0
  pushl $122
80106a83:	6a 7a                	push   $0x7a
  jmp alltraps
80106a85:	e9 95 f6 ff ff       	jmp    8010611f <alltraps>

80106a8a <vector123>:
.globl vector123
vector123:
  pushl $0
80106a8a:	6a 00                	push   $0x0
  pushl $123
80106a8c:	6a 7b                	push   $0x7b
  jmp alltraps
80106a8e:	e9 8c f6 ff ff       	jmp    8010611f <alltraps>

80106a93 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $124
80106a95:	6a 7c                	push   $0x7c
  jmp alltraps
80106a97:	e9 83 f6 ff ff       	jmp    8010611f <alltraps>

80106a9c <vector125>:
.globl vector125
vector125:
  pushl $0
80106a9c:	6a 00                	push   $0x0
  pushl $125
80106a9e:	6a 7d                	push   $0x7d
  jmp alltraps
80106aa0:	e9 7a f6 ff ff       	jmp    8010611f <alltraps>

80106aa5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106aa5:	6a 00                	push   $0x0
  pushl $126
80106aa7:	6a 7e                	push   $0x7e
  jmp alltraps
80106aa9:	e9 71 f6 ff ff       	jmp    8010611f <alltraps>

80106aae <vector127>:
.globl vector127
vector127:
  pushl $0
80106aae:	6a 00                	push   $0x0
  pushl $127
80106ab0:	6a 7f                	push   $0x7f
  jmp alltraps
80106ab2:	e9 68 f6 ff ff       	jmp    8010611f <alltraps>

80106ab7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $128
80106ab9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106abe:	e9 5c f6 ff ff       	jmp    8010611f <alltraps>

80106ac3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $129
80106ac5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106aca:	e9 50 f6 ff ff       	jmp    8010611f <alltraps>

80106acf <vector130>:
.globl vector130
vector130:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $130
80106ad1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106ad6:	e9 44 f6 ff ff       	jmp    8010611f <alltraps>

80106adb <vector131>:
.globl vector131
vector131:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $131
80106add:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106ae2:	e9 38 f6 ff ff       	jmp    8010611f <alltraps>

80106ae7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $132
80106ae9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106aee:	e9 2c f6 ff ff       	jmp    8010611f <alltraps>

80106af3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $133
80106af5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106afa:	e9 20 f6 ff ff       	jmp    8010611f <alltraps>

80106aff <vector134>:
.globl vector134
vector134:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $134
80106b01:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106b06:	e9 14 f6 ff ff       	jmp    8010611f <alltraps>

80106b0b <vector135>:
.globl vector135
vector135:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $135
80106b0d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106b12:	e9 08 f6 ff ff       	jmp    8010611f <alltraps>

80106b17 <vector136>:
.globl vector136
vector136:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $136
80106b19:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106b1e:	e9 fc f5 ff ff       	jmp    8010611f <alltraps>

80106b23 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $137
80106b25:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b2a:	e9 f0 f5 ff ff       	jmp    8010611f <alltraps>

80106b2f <vector138>:
.globl vector138
vector138:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $138
80106b31:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b36:	e9 e4 f5 ff ff       	jmp    8010611f <alltraps>

80106b3b <vector139>:
.globl vector139
vector139:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $139
80106b3d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b42:	e9 d8 f5 ff ff       	jmp    8010611f <alltraps>

80106b47 <vector140>:
.globl vector140
vector140:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $140
80106b49:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b4e:	e9 cc f5 ff ff       	jmp    8010611f <alltraps>

80106b53 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $141
80106b55:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b5a:	e9 c0 f5 ff ff       	jmp    8010611f <alltraps>

80106b5f <vector142>:
.globl vector142
vector142:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $142
80106b61:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b66:	e9 b4 f5 ff ff       	jmp    8010611f <alltraps>

80106b6b <vector143>:
.globl vector143
vector143:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $143
80106b6d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b72:	e9 a8 f5 ff ff       	jmp    8010611f <alltraps>

80106b77 <vector144>:
.globl vector144
vector144:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $144
80106b79:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b7e:	e9 9c f5 ff ff       	jmp    8010611f <alltraps>

80106b83 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $145
80106b85:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b8a:	e9 90 f5 ff ff       	jmp    8010611f <alltraps>

80106b8f <vector146>:
.globl vector146
vector146:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $146
80106b91:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b96:	e9 84 f5 ff ff       	jmp    8010611f <alltraps>

80106b9b <vector147>:
.globl vector147
vector147:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $147
80106b9d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ba2:	e9 78 f5 ff ff       	jmp    8010611f <alltraps>

80106ba7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $148
80106ba9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106bae:	e9 6c f5 ff ff       	jmp    8010611f <alltraps>

80106bb3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $149
80106bb5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106bba:	e9 60 f5 ff ff       	jmp    8010611f <alltraps>

80106bbf <vector150>:
.globl vector150
vector150:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $150
80106bc1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106bc6:	e9 54 f5 ff ff       	jmp    8010611f <alltraps>

80106bcb <vector151>:
.globl vector151
vector151:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $151
80106bcd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106bd2:	e9 48 f5 ff ff       	jmp    8010611f <alltraps>

80106bd7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $152
80106bd9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106bde:	e9 3c f5 ff ff       	jmp    8010611f <alltraps>

80106be3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $153
80106be5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106bea:	e9 30 f5 ff ff       	jmp    8010611f <alltraps>

80106bef <vector154>:
.globl vector154
vector154:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $154
80106bf1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106bf6:	e9 24 f5 ff ff       	jmp    8010611f <alltraps>

80106bfb <vector155>:
.globl vector155
vector155:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $155
80106bfd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106c02:	e9 18 f5 ff ff       	jmp    8010611f <alltraps>

80106c07 <vector156>:
.globl vector156
vector156:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $156
80106c09:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106c0e:	e9 0c f5 ff ff       	jmp    8010611f <alltraps>

80106c13 <vector157>:
.globl vector157
vector157:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $157
80106c15:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106c1a:	e9 00 f5 ff ff       	jmp    8010611f <alltraps>

80106c1f <vector158>:
.globl vector158
vector158:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $158
80106c21:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c26:	e9 f4 f4 ff ff       	jmp    8010611f <alltraps>

80106c2b <vector159>:
.globl vector159
vector159:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $159
80106c2d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c32:	e9 e8 f4 ff ff       	jmp    8010611f <alltraps>

80106c37 <vector160>:
.globl vector160
vector160:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $160
80106c39:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c3e:	e9 dc f4 ff ff       	jmp    8010611f <alltraps>

80106c43 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $161
80106c45:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c4a:	e9 d0 f4 ff ff       	jmp    8010611f <alltraps>

80106c4f <vector162>:
.globl vector162
vector162:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $162
80106c51:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c56:	e9 c4 f4 ff ff       	jmp    8010611f <alltraps>

80106c5b <vector163>:
.globl vector163
vector163:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $163
80106c5d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c62:	e9 b8 f4 ff ff       	jmp    8010611f <alltraps>

80106c67 <vector164>:
.globl vector164
vector164:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $164
80106c69:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c6e:	e9 ac f4 ff ff       	jmp    8010611f <alltraps>

80106c73 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $165
80106c75:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c7a:	e9 a0 f4 ff ff       	jmp    8010611f <alltraps>

80106c7f <vector166>:
.globl vector166
vector166:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $166
80106c81:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c86:	e9 94 f4 ff ff       	jmp    8010611f <alltraps>

80106c8b <vector167>:
.globl vector167
vector167:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $167
80106c8d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c92:	e9 88 f4 ff ff       	jmp    8010611f <alltraps>

80106c97 <vector168>:
.globl vector168
vector168:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $168
80106c99:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c9e:	e9 7c f4 ff ff       	jmp    8010611f <alltraps>

80106ca3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $169
80106ca5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106caa:	e9 70 f4 ff ff       	jmp    8010611f <alltraps>

80106caf <vector170>:
.globl vector170
vector170:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $170
80106cb1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106cb6:	e9 64 f4 ff ff       	jmp    8010611f <alltraps>

80106cbb <vector171>:
.globl vector171
vector171:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $171
80106cbd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106cc2:	e9 58 f4 ff ff       	jmp    8010611f <alltraps>

80106cc7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $172
80106cc9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106cce:	e9 4c f4 ff ff       	jmp    8010611f <alltraps>

80106cd3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $173
80106cd5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106cda:	e9 40 f4 ff ff       	jmp    8010611f <alltraps>

80106cdf <vector174>:
.globl vector174
vector174:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $174
80106ce1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106ce6:	e9 34 f4 ff ff       	jmp    8010611f <alltraps>

80106ceb <vector175>:
.globl vector175
vector175:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $175
80106ced:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106cf2:	e9 28 f4 ff ff       	jmp    8010611f <alltraps>

80106cf7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $176
80106cf9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106cfe:	e9 1c f4 ff ff       	jmp    8010611f <alltraps>

80106d03 <vector177>:
.globl vector177
vector177:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $177
80106d05:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106d0a:	e9 10 f4 ff ff       	jmp    8010611f <alltraps>

80106d0f <vector178>:
.globl vector178
vector178:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $178
80106d11:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106d16:	e9 04 f4 ff ff       	jmp    8010611f <alltraps>

80106d1b <vector179>:
.globl vector179
vector179:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $179
80106d1d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d22:	e9 f8 f3 ff ff       	jmp    8010611f <alltraps>

80106d27 <vector180>:
.globl vector180
vector180:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $180
80106d29:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106d2e:	e9 ec f3 ff ff       	jmp    8010611f <alltraps>

80106d33 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $181
80106d35:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d3a:	e9 e0 f3 ff ff       	jmp    8010611f <alltraps>

80106d3f <vector182>:
.globl vector182
vector182:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $182
80106d41:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d46:	e9 d4 f3 ff ff       	jmp    8010611f <alltraps>

80106d4b <vector183>:
.globl vector183
vector183:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $183
80106d4d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d52:	e9 c8 f3 ff ff       	jmp    8010611f <alltraps>

80106d57 <vector184>:
.globl vector184
vector184:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $184
80106d59:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d5e:	e9 bc f3 ff ff       	jmp    8010611f <alltraps>

80106d63 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $185
80106d65:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d6a:	e9 b0 f3 ff ff       	jmp    8010611f <alltraps>

80106d6f <vector186>:
.globl vector186
vector186:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $186
80106d71:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d76:	e9 a4 f3 ff ff       	jmp    8010611f <alltraps>

80106d7b <vector187>:
.globl vector187
vector187:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $187
80106d7d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d82:	e9 98 f3 ff ff       	jmp    8010611f <alltraps>

80106d87 <vector188>:
.globl vector188
vector188:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $188
80106d89:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d8e:	e9 8c f3 ff ff       	jmp    8010611f <alltraps>

80106d93 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $189
80106d95:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d9a:	e9 80 f3 ff ff       	jmp    8010611f <alltraps>

80106d9f <vector190>:
.globl vector190
vector190:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $190
80106da1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106da6:	e9 74 f3 ff ff       	jmp    8010611f <alltraps>

80106dab <vector191>:
.globl vector191
vector191:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $191
80106dad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106db2:	e9 68 f3 ff ff       	jmp    8010611f <alltraps>

80106db7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $192
80106db9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106dbe:	e9 5c f3 ff ff       	jmp    8010611f <alltraps>

80106dc3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $193
80106dc5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106dca:	e9 50 f3 ff ff       	jmp    8010611f <alltraps>

80106dcf <vector194>:
.globl vector194
vector194:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $194
80106dd1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106dd6:	e9 44 f3 ff ff       	jmp    8010611f <alltraps>

80106ddb <vector195>:
.globl vector195
vector195:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $195
80106ddd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106de2:	e9 38 f3 ff ff       	jmp    8010611f <alltraps>

80106de7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $196
80106de9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106dee:	e9 2c f3 ff ff       	jmp    8010611f <alltraps>

80106df3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $197
80106df5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106dfa:	e9 20 f3 ff ff       	jmp    8010611f <alltraps>

80106dff <vector198>:
.globl vector198
vector198:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $198
80106e01:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106e06:	e9 14 f3 ff ff       	jmp    8010611f <alltraps>

80106e0b <vector199>:
.globl vector199
vector199:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $199
80106e0d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106e12:	e9 08 f3 ff ff       	jmp    8010611f <alltraps>

80106e17 <vector200>:
.globl vector200
vector200:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $200
80106e19:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106e1e:	e9 fc f2 ff ff       	jmp    8010611f <alltraps>

80106e23 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $201
80106e25:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e2a:	e9 f0 f2 ff ff       	jmp    8010611f <alltraps>

80106e2f <vector202>:
.globl vector202
vector202:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $202
80106e31:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e36:	e9 e4 f2 ff ff       	jmp    8010611f <alltraps>

80106e3b <vector203>:
.globl vector203
vector203:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $203
80106e3d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e42:	e9 d8 f2 ff ff       	jmp    8010611f <alltraps>

80106e47 <vector204>:
.globl vector204
vector204:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $204
80106e49:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e4e:	e9 cc f2 ff ff       	jmp    8010611f <alltraps>

80106e53 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $205
80106e55:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e5a:	e9 c0 f2 ff ff       	jmp    8010611f <alltraps>

80106e5f <vector206>:
.globl vector206
vector206:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $206
80106e61:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e66:	e9 b4 f2 ff ff       	jmp    8010611f <alltraps>

80106e6b <vector207>:
.globl vector207
vector207:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $207
80106e6d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e72:	e9 a8 f2 ff ff       	jmp    8010611f <alltraps>

80106e77 <vector208>:
.globl vector208
vector208:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $208
80106e79:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e7e:	e9 9c f2 ff ff       	jmp    8010611f <alltraps>

80106e83 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $209
80106e85:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e8a:	e9 90 f2 ff ff       	jmp    8010611f <alltraps>

80106e8f <vector210>:
.globl vector210
vector210:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $210
80106e91:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e96:	e9 84 f2 ff ff       	jmp    8010611f <alltraps>

80106e9b <vector211>:
.globl vector211
vector211:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $211
80106e9d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ea2:	e9 78 f2 ff ff       	jmp    8010611f <alltraps>

80106ea7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $212
80106ea9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106eae:	e9 6c f2 ff ff       	jmp    8010611f <alltraps>

80106eb3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $213
80106eb5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106eba:	e9 60 f2 ff ff       	jmp    8010611f <alltraps>

80106ebf <vector214>:
.globl vector214
vector214:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $214
80106ec1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ec6:	e9 54 f2 ff ff       	jmp    8010611f <alltraps>

80106ecb <vector215>:
.globl vector215
vector215:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $215
80106ecd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ed2:	e9 48 f2 ff ff       	jmp    8010611f <alltraps>

80106ed7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $216
80106ed9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ede:	e9 3c f2 ff ff       	jmp    8010611f <alltraps>

80106ee3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $217
80106ee5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106eea:	e9 30 f2 ff ff       	jmp    8010611f <alltraps>

80106eef <vector218>:
.globl vector218
vector218:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $218
80106ef1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ef6:	e9 24 f2 ff ff       	jmp    8010611f <alltraps>

80106efb <vector219>:
.globl vector219
vector219:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $219
80106efd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106f02:	e9 18 f2 ff ff       	jmp    8010611f <alltraps>

80106f07 <vector220>:
.globl vector220
vector220:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $220
80106f09:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106f0e:	e9 0c f2 ff ff       	jmp    8010611f <alltraps>

80106f13 <vector221>:
.globl vector221
vector221:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $221
80106f15:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106f1a:	e9 00 f2 ff ff       	jmp    8010611f <alltraps>

80106f1f <vector222>:
.globl vector222
vector222:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $222
80106f21:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f26:	e9 f4 f1 ff ff       	jmp    8010611f <alltraps>

80106f2b <vector223>:
.globl vector223
vector223:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $223
80106f2d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f32:	e9 e8 f1 ff ff       	jmp    8010611f <alltraps>

80106f37 <vector224>:
.globl vector224
vector224:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $224
80106f39:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f3e:	e9 dc f1 ff ff       	jmp    8010611f <alltraps>

80106f43 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $225
80106f45:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f4a:	e9 d0 f1 ff ff       	jmp    8010611f <alltraps>

80106f4f <vector226>:
.globl vector226
vector226:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $226
80106f51:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f56:	e9 c4 f1 ff ff       	jmp    8010611f <alltraps>

80106f5b <vector227>:
.globl vector227
vector227:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $227
80106f5d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f62:	e9 b8 f1 ff ff       	jmp    8010611f <alltraps>

80106f67 <vector228>:
.globl vector228
vector228:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $228
80106f69:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f6e:	e9 ac f1 ff ff       	jmp    8010611f <alltraps>

80106f73 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $229
80106f75:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f7a:	e9 a0 f1 ff ff       	jmp    8010611f <alltraps>

80106f7f <vector230>:
.globl vector230
vector230:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $230
80106f81:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f86:	e9 94 f1 ff ff       	jmp    8010611f <alltraps>

80106f8b <vector231>:
.globl vector231
vector231:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $231
80106f8d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f92:	e9 88 f1 ff ff       	jmp    8010611f <alltraps>

80106f97 <vector232>:
.globl vector232
vector232:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $232
80106f99:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f9e:	e9 7c f1 ff ff       	jmp    8010611f <alltraps>

80106fa3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $233
80106fa5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106faa:	e9 70 f1 ff ff       	jmp    8010611f <alltraps>

80106faf <vector234>:
.globl vector234
vector234:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $234
80106fb1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106fb6:	e9 64 f1 ff ff       	jmp    8010611f <alltraps>

80106fbb <vector235>:
.globl vector235
vector235:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $235
80106fbd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106fc2:	e9 58 f1 ff ff       	jmp    8010611f <alltraps>

80106fc7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $236
80106fc9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106fce:	e9 4c f1 ff ff       	jmp    8010611f <alltraps>

80106fd3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $237
80106fd5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106fda:	e9 40 f1 ff ff       	jmp    8010611f <alltraps>

80106fdf <vector238>:
.globl vector238
vector238:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $238
80106fe1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106fe6:	e9 34 f1 ff ff       	jmp    8010611f <alltraps>

80106feb <vector239>:
.globl vector239
vector239:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $239
80106fed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ff2:	e9 28 f1 ff ff       	jmp    8010611f <alltraps>

80106ff7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $240
80106ff9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106ffe:	e9 1c f1 ff ff       	jmp    8010611f <alltraps>

80107003 <vector241>:
.globl vector241
vector241:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $241
80107005:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010700a:	e9 10 f1 ff ff       	jmp    8010611f <alltraps>

8010700f <vector242>:
.globl vector242
vector242:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $242
80107011:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107016:	e9 04 f1 ff ff       	jmp    8010611f <alltraps>

8010701b <vector243>:
.globl vector243
vector243:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $243
8010701d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107022:	e9 f8 f0 ff ff       	jmp    8010611f <alltraps>

80107027 <vector244>:
.globl vector244
vector244:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $244
80107029:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010702e:	e9 ec f0 ff ff       	jmp    8010611f <alltraps>

80107033 <vector245>:
.globl vector245
vector245:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $245
80107035:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010703a:	e9 e0 f0 ff ff       	jmp    8010611f <alltraps>

8010703f <vector246>:
.globl vector246
vector246:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $246
80107041:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107046:	e9 d4 f0 ff ff       	jmp    8010611f <alltraps>

8010704b <vector247>:
.globl vector247
vector247:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $247
8010704d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107052:	e9 c8 f0 ff ff       	jmp    8010611f <alltraps>

80107057 <vector248>:
.globl vector248
vector248:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $248
80107059:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010705e:	e9 bc f0 ff ff       	jmp    8010611f <alltraps>

80107063 <vector249>:
.globl vector249
vector249:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $249
80107065:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010706a:	e9 b0 f0 ff ff       	jmp    8010611f <alltraps>

8010706f <vector250>:
.globl vector250
vector250:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $250
80107071:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107076:	e9 a4 f0 ff ff       	jmp    8010611f <alltraps>

8010707b <vector251>:
.globl vector251
vector251:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $251
8010707d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107082:	e9 98 f0 ff ff       	jmp    8010611f <alltraps>

80107087 <vector252>:
.globl vector252
vector252:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $252
80107089:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010708e:	e9 8c f0 ff ff       	jmp    8010611f <alltraps>

80107093 <vector253>:
.globl vector253
vector253:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $253
80107095:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010709a:	e9 80 f0 ff ff       	jmp    8010611f <alltraps>

8010709f <vector254>:
.globl vector254
vector254:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $254
801070a1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801070a6:	e9 74 f0 ff ff       	jmp    8010611f <alltraps>

801070ab <vector255>:
.globl vector255
vector255:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $255
801070ad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801070b2:	e9 68 f0 ff ff       	jmp    8010611f <alltraps>
801070b7:	66 90                	xchg   %ax,%ax
801070b9:	66 90                	xchg   %ax,%ax
801070bb:	66 90                	xchg   %ax,%ax
801070bd:	66 90                	xchg   %ax,%ax
801070bf:	90                   	nop

801070c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801070c6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801070cc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070d2:	83 ec 1c             	sub    $0x1c,%esp
801070d5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801070d8:	39 d3                	cmp    %edx,%ebx
801070da:	73 49                	jae    80107125 <deallocuvm.part.0+0x65>
801070dc:	89 c7                	mov    %eax,%edi
801070de:	eb 0c                	jmp    801070ec <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801070e0:	83 c0 01             	add    $0x1,%eax
801070e3:	c1 e0 16             	shl    $0x16,%eax
801070e6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
801070e8:	39 da                	cmp    %ebx,%edx
801070ea:	76 39                	jbe    80107125 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
801070ec:	89 d8                	mov    %ebx,%eax
801070ee:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801070f1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
801070f4:	f6 c1 01             	test   $0x1,%cl
801070f7:	74 e7                	je     801070e0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
801070f9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070fb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107101:	c1 ee 0a             	shr    $0xa,%esi
80107104:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010710a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107111:	85 f6                	test   %esi,%esi
80107113:	74 cb                	je     801070e0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107115:	8b 06                	mov    (%esi),%eax
80107117:	a8 01                	test   $0x1,%al
80107119:	75 15                	jne    80107130 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010711b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107121:	39 da                	cmp    %ebx,%edx
80107123:	77 c7                	ja     801070ec <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107125:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107128:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010712b:	5b                   	pop    %ebx
8010712c:	5e                   	pop    %esi
8010712d:	5f                   	pop    %edi
8010712e:	5d                   	pop    %ebp
8010712f:	c3                   	ret    
      if(pa == 0)
80107130:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107135:	74 25                	je     8010715c <deallocuvm.part.0+0x9c>
      kfree(v);
80107137:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010713a:	05 00 00 00 80       	add    $0x80000000,%eax
8010713f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107142:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107148:	50                   	push   %eax
80107149:	e8 d2 b3 ff ff       	call   80102520 <kfree>
      *pte = 0;
8010714e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107154:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107157:	83 c4 10             	add    $0x10,%esp
8010715a:	eb 8c                	jmp    801070e8 <deallocuvm.part.0+0x28>
        panic("kfree");
8010715c:	83 ec 0c             	sub    $0xc,%esp
8010715f:	68 3a 7d 10 80       	push   $0x80107d3a
80107164:	e8 17 92 ff ff       	call   80100380 <panic>
80107169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107170 <mappages>:
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	57                   	push   %edi
80107174:	56                   	push   %esi
80107175:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107176:	89 d3                	mov    %edx,%ebx
80107178:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010717e:	83 ec 1c             	sub    $0x1c,%esp
80107181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107184:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107188:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010718d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107190:	8b 45 08             	mov    0x8(%ebp),%eax
80107193:	29 d8                	sub    %ebx,%eax
80107195:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107198:	eb 3d                	jmp    801071d7 <mappages+0x67>
8010719a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801071a0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801071a7:	c1 ea 0a             	shr    $0xa,%edx
801071aa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801071b0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801071b7:	85 c0                	test   %eax,%eax
801071b9:	74 75                	je     80107230 <mappages+0xc0>
    if(*pte & PTE_P)
801071bb:	f6 00 01             	testb  $0x1,(%eax)
801071be:	0f 85 86 00 00 00    	jne    8010724a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801071c4:	0b 75 0c             	or     0xc(%ebp),%esi
801071c7:	83 ce 01             	or     $0x1,%esi
801071ca:	89 30                	mov    %esi,(%eax)
    if(a == last)
801071cc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801071cf:	74 6f                	je     80107240 <mappages+0xd0>
    a += PGSIZE;
801071d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801071d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
801071da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071dd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801071e0:	89 d8                	mov    %ebx,%eax
801071e2:	c1 e8 16             	shr    $0x16,%eax
801071e5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801071e8:	8b 07                	mov    (%edi),%eax
801071ea:	a8 01                	test   $0x1,%al
801071ec:	75 b2                	jne    801071a0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801071ee:	e8 ed b4 ff ff       	call   801026e0 <kalloc>
801071f3:	85 c0                	test   %eax,%eax
801071f5:	74 39                	je     80107230 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801071f7:	83 ec 04             	sub    $0x4,%esp
801071fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801071fd:	68 00 10 00 00       	push   $0x1000
80107202:	6a 00                	push   $0x0
80107204:	50                   	push   %eax
80107205:	e8 66 dc ff ff       	call   80104e70 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010720a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010720d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107210:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107216:	83 c8 07             	or     $0x7,%eax
80107219:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010721b:	89 d8                	mov    %ebx,%eax
8010721d:	c1 e8 0a             	shr    $0xa,%eax
80107220:	25 fc 0f 00 00       	and    $0xffc,%eax
80107225:	01 d0                	add    %edx,%eax
80107227:	eb 92                	jmp    801071bb <mappages+0x4b>
80107229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107230:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107233:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107238:	5b                   	pop    %ebx
80107239:	5e                   	pop    %esi
8010723a:	5f                   	pop    %edi
8010723b:	5d                   	pop    %ebp
8010723c:	c3                   	ret    
8010723d:	8d 76 00             	lea    0x0(%esi),%esi
80107240:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107243:	31 c0                	xor    %eax,%eax
}
80107245:	5b                   	pop    %ebx
80107246:	5e                   	pop    %esi
80107247:	5f                   	pop    %edi
80107248:	5d                   	pop    %ebp
80107249:	c3                   	ret    
      panic("remap");
8010724a:	83 ec 0c             	sub    $0xc,%esp
8010724d:	68 14 84 10 80       	push   $0x80108414
80107252:	e8 29 91 ff ff       	call   80100380 <panic>
80107257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010725e:	66 90                	xchg   %ax,%ax

80107260 <seginit>:
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107266:	e8 b5 c7 ff ff       	call   80103a20 <cpuid>
  pd[0] = size-1;
8010726b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107270:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107276:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010727a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107281:	ff 00 00 
80107284:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
8010728b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010728e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107295:	ff 00 00 
80107298:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
8010729f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801072a2:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
801072a9:	ff 00 00 
801072ac:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
801072b3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801072b6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
801072bd:	ff 00 00 
801072c0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
801072c7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801072ca:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
801072cf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801072d3:	c1 e8 10             	shr    $0x10,%eax
801072d6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801072da:	8d 45 f2             	lea    -0xe(%ebp),%eax
801072dd:	0f 01 10             	lgdtl  (%eax)
}
801072e0:	c9                   	leave  
801072e1:	c3                   	ret    
801072e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072f0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072f0:	a1 c4 51 13 80       	mov    0x801351c4,%eax
801072f5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072fa:	0f 22 d8             	mov    %eax,%cr3
}
801072fd:	c3                   	ret    
801072fe:	66 90                	xchg   %ax,%ax

80107300 <switchuvm>:
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	57                   	push   %edi
80107304:	56                   	push   %esi
80107305:	53                   	push   %ebx
80107306:	83 ec 1c             	sub    $0x1c,%esp
80107309:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(t->kstack == 0)
8010730c:	8b 91 6c 08 00 00    	mov    0x86c(%ecx),%edx
80107312:	c1 e2 05             	shl    $0x5,%edx
80107315:	01 ca                	add    %ecx,%edx
80107317:	8b 42 74             	mov    0x74(%edx),%eax
8010731a:	85 c0                	test   %eax,%eax
8010731c:	0f 84 ca 00 00 00    	je     801073ec <switchuvm+0xec>
  if(p->pgdir == 0)
80107322:	8b 79 04             	mov    0x4(%ecx),%edi
80107325:	85 ff                	test   %edi,%edi
80107327:	0f 84 cc 00 00 00    	je     801073f9 <switchuvm+0xf9>
8010732d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80107330:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  pushcli();
80107333:	e8 28 d9 ff ff       	call   80104c60 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107338:	e8 83 c6 ff ff       	call   801039c0 <mycpu>
8010733d:	89 c3                	mov    %eax,%ebx
8010733f:	e8 7c c6 ff ff       	call   801039c0 <mycpu>
80107344:	89 c7                	mov    %eax,%edi
80107346:	e8 75 c6 ff ff       	call   801039c0 <mycpu>
8010734b:	83 c7 08             	add    $0x8,%edi
8010734e:	89 c6                	mov    %eax,%esi
80107350:	e8 6b c6 ff ff       	call   801039c0 <mycpu>
80107355:	83 c6 08             	add    $0x8,%esi
80107358:	ba 67 00 00 00       	mov    $0x67,%edx
8010735d:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107364:	c1 ee 10             	shr    $0x10,%esi
80107367:	83 c0 08             	add    $0x8,%eax
8010736a:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107371:	89 f1                	mov    %esi,%ecx
80107373:	c1 e8 18             	shr    $0x18,%eax
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107376:	be ff ff ff ff       	mov    $0xffffffff,%esi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010737b:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107381:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107386:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
8010738d:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107393:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107398:	e8 23 c6 ff ff       	call   801039c0 <mycpu>
8010739d:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073a4:	e8 17 c6 ff ff       	call   801039c0 <mycpu>
  mycpu()->ts.esp0 = (uint)t->kstack + KSTACKSIZE;
801073a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073ac:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)t->kstack + KSTACKSIZE;
801073b0:	8b 5a 74             	mov    0x74(%edx),%ebx
801073b3:	e8 08 c6 ff ff       	call   801039c0 <mycpu>
801073b8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073be:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073c1:	e8 fa c5 ff ff       	call   801039c0 <mycpu>
801073c6:	66 89 70 6e          	mov    %si,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801073ca:	b8 28 00 00 00       	mov    $0x28,%eax
801073cf:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801073d2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801073d5:	8b 41 04             	mov    0x4(%ecx),%eax
801073d8:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073dd:	0f 22 d8             	mov    %eax,%cr3
}
801073e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073e3:	5b                   	pop    %ebx
801073e4:	5e                   	pop    %esi
801073e5:	5f                   	pop    %edi
801073e6:	5d                   	pop    %ebp
  popcli();
801073e7:	e9 c4 d8 ff ff       	jmp    80104cb0 <popcli>
    panic("switchuvm: no kstack");
801073ec:	83 ec 0c             	sub    $0xc,%esp
801073ef:	68 1a 84 10 80       	push   $0x8010841a
801073f4:	e8 87 8f ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
801073f9:	83 ec 0c             	sub    $0xc,%esp
801073fc:	68 2f 84 10 80       	push   $0x8010842f
80107401:	e8 7a 8f ff ff       	call   80100380 <panic>
80107406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010740d:	8d 76 00             	lea    0x0(%esi),%esi

80107410 <inituvm>:
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	57                   	push   %edi
80107414:	56                   	push   %esi
80107415:	53                   	push   %ebx
80107416:	83 ec 1c             	sub    $0x1c,%esp
80107419:	8b 45 0c             	mov    0xc(%ebp),%eax
8010741c:	8b 75 10             	mov    0x10(%ebp),%esi
8010741f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107422:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107425:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010742b:	77 4b                	ja     80107478 <inituvm+0x68>
  mem = kalloc();
8010742d:	e8 ae b2 ff ff       	call   801026e0 <kalloc>
  memset(mem, 0, PGSIZE);
80107432:	83 ec 04             	sub    $0x4,%esp
80107435:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010743a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010743c:	6a 00                	push   $0x0
8010743e:	50                   	push   %eax
8010743f:	e8 2c da ff ff       	call   80104e70 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107444:	58                   	pop    %eax
80107445:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010744b:	5a                   	pop    %edx
8010744c:	6a 06                	push   $0x6
8010744e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107453:	31 d2                	xor    %edx,%edx
80107455:	50                   	push   %eax
80107456:	89 f8                	mov    %edi,%eax
80107458:	e8 13 fd ff ff       	call   80107170 <mappages>
  memmove(mem, init, sz);
8010745d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107460:	89 75 10             	mov    %esi,0x10(%ebp)
80107463:	83 c4 10             	add    $0x10,%esp
80107466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107469:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010746c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010746f:	5b                   	pop    %ebx
80107470:	5e                   	pop    %esi
80107471:	5f                   	pop    %edi
80107472:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107473:	e9 98 da ff ff       	jmp    80104f10 <memmove>
    panic("inituvm: more than a page");
80107478:	83 ec 0c             	sub    $0xc,%esp
8010747b:	68 43 84 10 80       	push   $0x80108443
80107480:	e8 fb 8e ff ff       	call   80100380 <panic>
80107485:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010748c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107490 <loaduvm>:
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	57                   	push   %edi
80107494:	56                   	push   %esi
80107495:	53                   	push   %ebx
80107496:	83 ec 1c             	sub    $0x1c,%esp
80107499:	8b 45 0c             	mov    0xc(%ebp),%eax
8010749c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010749f:	a9 ff 0f 00 00       	test   $0xfff,%eax
801074a4:	0f 85 bb 00 00 00    	jne    80107565 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801074aa:	01 f0                	add    %esi,%eax
801074ac:	89 f3                	mov    %esi,%ebx
801074ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074b1:	8b 45 14             	mov    0x14(%ebp),%eax
801074b4:	01 f0                	add    %esi,%eax
801074b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801074b9:	85 f6                	test   %esi,%esi
801074bb:	0f 84 87 00 00 00    	je     80107548 <loaduvm+0xb8>
801074c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801074c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801074cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801074ce:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801074d0:	89 c2                	mov    %eax,%edx
801074d2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801074d5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801074d8:	f6 c2 01             	test   $0x1,%dl
801074db:	75 13                	jne    801074f0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801074dd:	83 ec 0c             	sub    $0xc,%esp
801074e0:	68 5d 84 10 80       	push   $0x8010845d
801074e5:	e8 96 8e ff ff       	call   80100380 <panic>
801074ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801074f0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074f3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801074f9:	25 fc 0f 00 00       	and    $0xffc,%eax
801074fe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107505:	85 c0                	test   %eax,%eax
80107507:	74 d4                	je     801074dd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107509:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010750b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010750e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107513:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107518:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010751e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107521:	29 d9                	sub    %ebx,%ecx
80107523:	05 00 00 00 80       	add    $0x80000000,%eax
80107528:	57                   	push   %edi
80107529:	51                   	push   %ecx
8010752a:	50                   	push   %eax
8010752b:	ff 75 10             	push   0x10(%ebp)
8010752e:	e8 bd a5 ff ff       	call   80101af0 <readi>
80107533:	83 c4 10             	add    $0x10,%esp
80107536:	39 f8                	cmp    %edi,%eax
80107538:	75 1e                	jne    80107558 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010753a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107540:	89 f0                	mov    %esi,%eax
80107542:	29 d8                	sub    %ebx,%eax
80107544:	39 c6                	cmp    %eax,%esi
80107546:	77 80                	ja     801074c8 <loaduvm+0x38>
}
80107548:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010754b:	31 c0                	xor    %eax,%eax
}
8010754d:	5b                   	pop    %ebx
8010754e:	5e                   	pop    %esi
8010754f:	5f                   	pop    %edi
80107550:	5d                   	pop    %ebp
80107551:	c3                   	ret    
80107552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107558:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010755b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107560:	5b                   	pop    %ebx
80107561:	5e                   	pop    %esi
80107562:	5f                   	pop    %edi
80107563:	5d                   	pop    %ebp
80107564:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107565:	83 ec 0c             	sub    $0xc,%esp
80107568:	68 00 85 10 80       	push   $0x80108500
8010756d:	e8 0e 8e ff ff       	call   80100380 <panic>
80107572:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107580 <allocuvm>:
{
80107580:	55                   	push   %ebp
80107581:	89 e5                	mov    %esp,%ebp
80107583:	57                   	push   %edi
80107584:	56                   	push   %esi
80107585:	53                   	push   %ebx
80107586:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107589:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010758c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010758f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107592:	85 c0                	test   %eax,%eax
80107594:	0f 88 b6 00 00 00    	js     80107650 <allocuvm+0xd0>
  if(newsz < oldsz)
8010759a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010759d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801075a0:	0f 82 9a 00 00 00    	jb     80107640 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801075a6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801075ac:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801075b2:	39 75 10             	cmp    %esi,0x10(%ebp)
801075b5:	77 44                	ja     801075fb <allocuvm+0x7b>
801075b7:	e9 87 00 00 00       	jmp    80107643 <allocuvm+0xc3>
801075bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801075c0:	83 ec 04             	sub    $0x4,%esp
801075c3:	68 00 10 00 00       	push   $0x1000
801075c8:	6a 00                	push   $0x0
801075ca:	50                   	push   %eax
801075cb:	e8 a0 d8 ff ff       	call   80104e70 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801075d0:	58                   	pop    %eax
801075d1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075d7:	5a                   	pop    %edx
801075d8:	6a 06                	push   $0x6
801075da:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075df:	89 f2                	mov    %esi,%edx
801075e1:	50                   	push   %eax
801075e2:	89 f8                	mov    %edi,%eax
801075e4:	e8 87 fb ff ff       	call   80107170 <mappages>
801075e9:	83 c4 10             	add    $0x10,%esp
801075ec:	85 c0                	test   %eax,%eax
801075ee:	78 78                	js     80107668 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801075f0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801075f6:	39 75 10             	cmp    %esi,0x10(%ebp)
801075f9:	76 48                	jbe    80107643 <allocuvm+0xc3>
    mem = kalloc();
801075fb:	e8 e0 b0 ff ff       	call   801026e0 <kalloc>
80107600:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107602:	85 c0                	test   %eax,%eax
80107604:	75 ba                	jne    801075c0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107606:	83 ec 0c             	sub    $0xc,%esp
80107609:	68 7b 84 10 80       	push   $0x8010847b
8010760e:	e8 8d 90 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107613:	8b 45 0c             	mov    0xc(%ebp),%eax
80107616:	83 c4 10             	add    $0x10,%esp
80107619:	39 45 10             	cmp    %eax,0x10(%ebp)
8010761c:	74 32                	je     80107650 <allocuvm+0xd0>
8010761e:	8b 55 10             	mov    0x10(%ebp),%edx
80107621:	89 c1                	mov    %eax,%ecx
80107623:	89 f8                	mov    %edi,%eax
80107625:	e8 96 fa ff ff       	call   801070c0 <deallocuvm.part.0>
      return 0;
8010762a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107634:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107637:	5b                   	pop    %ebx
80107638:	5e                   	pop    %esi
80107639:	5f                   	pop    %edi
8010763a:	5d                   	pop    %ebp
8010763b:	c3                   	ret    
8010763c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107640:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107646:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107649:	5b                   	pop    %ebx
8010764a:	5e                   	pop    %esi
8010764b:	5f                   	pop    %edi
8010764c:	5d                   	pop    %ebp
8010764d:	c3                   	ret    
8010764e:	66 90                	xchg   %ax,%ax
    return 0;
80107650:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010765a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010765d:	5b                   	pop    %ebx
8010765e:	5e                   	pop    %esi
8010765f:	5f                   	pop    %edi
80107660:	5d                   	pop    %ebp
80107661:	c3                   	ret    
80107662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107668:	83 ec 0c             	sub    $0xc,%esp
8010766b:	68 93 84 10 80       	push   $0x80108493
80107670:	e8 2b 90 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107675:	8b 45 0c             	mov    0xc(%ebp),%eax
80107678:	83 c4 10             	add    $0x10,%esp
8010767b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010767e:	74 0c                	je     8010768c <allocuvm+0x10c>
80107680:	8b 55 10             	mov    0x10(%ebp),%edx
80107683:	89 c1                	mov    %eax,%ecx
80107685:	89 f8                	mov    %edi,%eax
80107687:	e8 34 fa ff ff       	call   801070c0 <deallocuvm.part.0>
      kfree(mem);
8010768c:	83 ec 0c             	sub    $0xc,%esp
8010768f:	53                   	push   %ebx
80107690:	e8 8b ae ff ff       	call   80102520 <kfree>
      return 0;
80107695:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010769c:	83 c4 10             	add    $0x10,%esp
}
8010769f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076a5:	5b                   	pop    %ebx
801076a6:	5e                   	pop    %esi
801076a7:	5f                   	pop    %edi
801076a8:	5d                   	pop    %ebp
801076a9:	c3                   	ret    
801076aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076b0 <deallocuvm>:
{
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801076b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801076b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801076bc:	39 d1                	cmp    %edx,%ecx
801076be:	73 10                	jae    801076d0 <deallocuvm+0x20>
}
801076c0:	5d                   	pop    %ebp
801076c1:	e9 fa f9 ff ff       	jmp    801070c0 <deallocuvm.part.0>
801076c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076cd:	8d 76 00             	lea    0x0(%esi),%esi
801076d0:	89 d0                	mov    %edx,%eax
801076d2:	5d                   	pop    %ebp
801076d3:	c3                   	ret    
801076d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076df:	90                   	nop

801076e0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801076e0:	55                   	push   %ebp
801076e1:	89 e5                	mov    %esp,%ebp
801076e3:	57                   	push   %edi
801076e4:	56                   	push   %esi
801076e5:	53                   	push   %ebx
801076e6:	83 ec 0c             	sub    $0xc,%esp
801076e9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801076ec:	85 f6                	test   %esi,%esi
801076ee:	74 59                	je     80107749 <freevm+0x69>
  if(newsz >= oldsz)
801076f0:	31 c9                	xor    %ecx,%ecx
801076f2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801076f7:	89 f0                	mov    %esi,%eax
801076f9:	89 f3                	mov    %esi,%ebx
801076fb:	e8 c0 f9 ff ff       	call   801070c0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107700:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107706:	eb 0f                	jmp    80107717 <freevm+0x37>
80107708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770f:	90                   	nop
80107710:	83 c3 04             	add    $0x4,%ebx
80107713:	39 df                	cmp    %ebx,%edi
80107715:	74 23                	je     8010773a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107717:	8b 03                	mov    (%ebx),%eax
80107719:	a8 01                	test   $0x1,%al
8010771b:	74 f3                	je     80107710 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010771d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107722:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107725:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107728:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010772d:	50                   	push   %eax
8010772e:	e8 ed ad ff ff       	call   80102520 <kfree>
80107733:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107736:	39 df                	cmp    %ebx,%edi
80107738:	75 dd                	jne    80107717 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010773a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010773d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107740:	5b                   	pop    %ebx
80107741:	5e                   	pop    %esi
80107742:	5f                   	pop    %edi
80107743:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107744:	e9 d7 ad ff ff       	jmp    80102520 <kfree>
    panic("freevm: no pgdir");
80107749:	83 ec 0c             	sub    $0xc,%esp
8010774c:	68 af 84 10 80       	push   $0x801084af
80107751:	e8 2a 8c ff ff       	call   80100380 <panic>
80107756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010775d:	8d 76 00             	lea    0x0(%esi),%esi

80107760 <setupkvm>:
{
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	56                   	push   %esi
80107764:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107765:	e8 76 af ff ff       	call   801026e0 <kalloc>
8010776a:	89 c6                	mov    %eax,%esi
8010776c:	85 c0                	test   %eax,%eax
8010776e:	74 42                	je     801077b2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107770:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107773:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107778:	68 00 10 00 00       	push   $0x1000
8010777d:	6a 00                	push   $0x0
8010777f:	50                   	push   %eax
80107780:	e8 eb d6 ff ff       	call   80104e70 <memset>
80107785:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107788:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010778b:	83 ec 08             	sub    $0x8,%esp
8010778e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107791:	ff 73 0c             	push   0xc(%ebx)
80107794:	8b 13                	mov    (%ebx),%edx
80107796:	50                   	push   %eax
80107797:	29 c1                	sub    %eax,%ecx
80107799:	89 f0                	mov    %esi,%eax
8010779b:	e8 d0 f9 ff ff       	call   80107170 <mappages>
801077a0:	83 c4 10             	add    $0x10,%esp
801077a3:	85 c0                	test   %eax,%eax
801077a5:	78 19                	js     801077c0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077a7:	83 c3 10             	add    $0x10,%ebx
801077aa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801077b0:	75 d6                	jne    80107788 <setupkvm+0x28>
}
801077b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077b5:	89 f0                	mov    %esi,%eax
801077b7:	5b                   	pop    %ebx
801077b8:	5e                   	pop    %esi
801077b9:	5d                   	pop    %ebp
801077ba:	c3                   	ret    
801077bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077bf:	90                   	nop
      freevm(pgdir);
801077c0:	83 ec 0c             	sub    $0xc,%esp
801077c3:	56                   	push   %esi
      return 0;
801077c4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801077c6:	e8 15 ff ff ff       	call   801076e0 <freevm>
      return 0;
801077cb:	83 c4 10             	add    $0x10,%esp
}
801077ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077d1:	89 f0                	mov    %esi,%eax
801077d3:	5b                   	pop    %ebx
801077d4:	5e                   	pop    %esi
801077d5:	5d                   	pop    %ebp
801077d6:	c3                   	ret    
801077d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077de:	66 90                	xchg   %ax,%ax

801077e0 <kvmalloc>:
{
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801077e6:	e8 75 ff ff ff       	call   80107760 <setupkvm>
801077eb:	a3 c4 51 13 80       	mov    %eax,0x801351c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077f0:	05 00 00 00 80       	add    $0x80000000,%eax
801077f5:	0f 22 d8             	mov    %eax,%cr3
}
801077f8:	c9                   	leave  
801077f9:	c3                   	ret    
801077fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107800 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	83 ec 08             	sub    $0x8,%esp
80107806:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107809:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010780c:	89 c1                	mov    %eax,%ecx
8010780e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107811:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107814:	f6 c2 01             	test   $0x1,%dl
80107817:	75 17                	jne    80107830 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107819:	83 ec 0c             	sub    $0xc,%esp
8010781c:	68 c0 84 10 80       	push   $0x801084c0
80107821:	e8 5a 8b ff ff       	call   80100380 <panic>
80107826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010782d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107830:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107833:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107839:	25 fc 0f 00 00       	and    $0xffc,%eax
8010783e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107845:	85 c0                	test   %eax,%eax
80107847:	74 d0                	je     80107819 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107849:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010784c:	c9                   	leave  
8010784d:	c3                   	ret    
8010784e:	66 90                	xchg   %ax,%ax

80107850 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107850:	55                   	push   %ebp
80107851:	89 e5                	mov    %esp,%ebp
80107853:	57                   	push   %edi
80107854:	56                   	push   %esi
80107855:	53                   	push   %ebx
80107856:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107859:	e8 02 ff ff ff       	call   80107760 <setupkvm>
8010785e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107861:	85 c0                	test   %eax,%eax
80107863:	0f 84 bd 00 00 00    	je     80107926 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107869:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010786c:	85 c9                	test   %ecx,%ecx
8010786e:	0f 84 b2 00 00 00    	je     80107926 <copyuvm+0xd6>
80107874:	31 f6                	xor    %esi,%esi
80107876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010787d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107880:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107883:	89 f0                	mov    %esi,%eax
80107885:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107888:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010788b:	a8 01                	test   $0x1,%al
8010788d:	75 11                	jne    801078a0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010788f:	83 ec 0c             	sub    $0xc,%esp
80107892:	68 ca 84 10 80       	push   $0x801084ca
80107897:	e8 e4 8a ff ff       	call   80100380 <panic>
8010789c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801078a0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801078a7:	c1 ea 0a             	shr    $0xa,%edx
801078aa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801078b0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801078b7:	85 c0                	test   %eax,%eax
801078b9:	74 d4                	je     8010788f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801078bb:	8b 00                	mov    (%eax),%eax
801078bd:	a8 01                	test   $0x1,%al
801078bf:	0f 84 9f 00 00 00    	je     80107964 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801078c5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801078c7:	25 ff 0f 00 00       	and    $0xfff,%eax
801078cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801078cf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801078d5:	e8 06 ae ff ff       	call   801026e0 <kalloc>
801078da:	89 c3                	mov    %eax,%ebx
801078dc:	85 c0                	test   %eax,%eax
801078de:	74 64                	je     80107944 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801078e0:	83 ec 04             	sub    $0x4,%esp
801078e3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801078e9:	68 00 10 00 00       	push   $0x1000
801078ee:	57                   	push   %edi
801078ef:	50                   	push   %eax
801078f0:	e8 1b d6 ff ff       	call   80104f10 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801078f5:	58                   	pop    %eax
801078f6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801078fc:	5a                   	pop    %edx
801078fd:	ff 75 e4             	push   -0x1c(%ebp)
80107900:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107905:	89 f2                	mov    %esi,%edx
80107907:	50                   	push   %eax
80107908:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010790b:	e8 60 f8 ff ff       	call   80107170 <mappages>
80107910:	83 c4 10             	add    $0x10,%esp
80107913:	85 c0                	test   %eax,%eax
80107915:	78 21                	js     80107938 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107917:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010791d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107920:	0f 87 5a ff ff ff    	ja     80107880 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107926:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107929:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010792c:	5b                   	pop    %ebx
8010792d:	5e                   	pop    %esi
8010792e:	5f                   	pop    %edi
8010792f:	5d                   	pop    %ebp
80107930:	c3                   	ret    
80107931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107938:	83 ec 0c             	sub    $0xc,%esp
8010793b:	53                   	push   %ebx
8010793c:	e8 df ab ff ff       	call   80102520 <kfree>
      goto bad;
80107941:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107944:	83 ec 0c             	sub    $0xc,%esp
80107947:	ff 75 e0             	push   -0x20(%ebp)
8010794a:	e8 91 fd ff ff       	call   801076e0 <freevm>
  return 0;
8010794f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107956:	83 c4 10             	add    $0x10,%esp
}
80107959:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010795c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010795f:	5b                   	pop    %ebx
80107960:	5e                   	pop    %esi
80107961:	5f                   	pop    %edi
80107962:	5d                   	pop    %ebp
80107963:	c3                   	ret    
      panic("copyuvm: page not present");
80107964:	83 ec 0c             	sub    $0xc,%esp
80107967:	68 e4 84 10 80       	push   $0x801084e4
8010796c:	e8 0f 8a ff ff       	call   80100380 <panic>
80107971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010797f:	90                   	nop

80107980 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107980:	55                   	push   %ebp
80107981:	89 e5                	mov    %esp,%ebp
80107983:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107986:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107989:	89 c1                	mov    %eax,%ecx
8010798b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010798e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107991:	f6 c2 01             	test   $0x1,%dl
80107994:	0f 84 00 01 00 00    	je     80107a9a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010799a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010799d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801079a3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801079a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801079a9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801079b0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801079b7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079ba:	05 00 00 00 80       	add    $0x80000000,%eax
801079bf:	83 fa 05             	cmp    $0x5,%edx
801079c2:	ba 00 00 00 00       	mov    $0x0,%edx
801079c7:	0f 45 c2             	cmovne %edx,%eax
}
801079ca:	c3                   	ret    
801079cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079cf:	90                   	nop

801079d0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801079d0:	55                   	push   %ebp
801079d1:	89 e5                	mov    %esp,%ebp
801079d3:	57                   	push   %edi
801079d4:	56                   	push   %esi
801079d5:	53                   	push   %ebx
801079d6:	83 ec 0c             	sub    $0xc,%esp
801079d9:	8b 75 14             	mov    0x14(%ebp),%esi
801079dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801079df:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801079e2:	85 f6                	test   %esi,%esi
801079e4:	75 51                	jne    80107a37 <copyout+0x67>
801079e6:	e9 a5 00 00 00       	jmp    80107a90 <copyout+0xc0>
801079eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079ef:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801079f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801079f6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801079fc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107a02:	74 75                	je     80107a79 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107a04:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107a06:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107a09:	29 c3                	sub    %eax,%ebx
80107a0b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a11:	39 f3                	cmp    %esi,%ebx
80107a13:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107a16:	29 f8                	sub    %edi,%eax
80107a18:	83 ec 04             	sub    $0x4,%esp
80107a1b:	01 c1                	add    %eax,%ecx
80107a1d:	53                   	push   %ebx
80107a1e:	52                   	push   %edx
80107a1f:	51                   	push   %ecx
80107a20:	e8 eb d4 ff ff       	call   80104f10 <memmove>
    len -= n;
    buf += n;
80107a25:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107a28:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107a2e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107a31:	01 da                	add    %ebx,%edx
  while(len > 0){
80107a33:	29 de                	sub    %ebx,%esi
80107a35:	74 59                	je     80107a90 <copyout+0xc0>
  if(*pde & PTE_P){
80107a37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107a3a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a3c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107a3e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a41:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107a47:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107a4a:	f6 c1 01             	test   $0x1,%cl
80107a4d:	0f 84 4e 00 00 00    	je     80107aa1 <copyout.cold>
  return &pgtab[PTX(va)];
80107a53:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a55:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107a5b:	c1 eb 0c             	shr    $0xc,%ebx
80107a5e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107a64:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107a6b:	89 d9                	mov    %ebx,%ecx
80107a6d:	83 e1 05             	and    $0x5,%ecx
80107a70:	83 f9 05             	cmp    $0x5,%ecx
80107a73:	0f 84 77 ff ff ff    	je     801079f0 <copyout+0x20>
  }
  return 0;
}
80107a79:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a81:	5b                   	pop    %ebx
80107a82:	5e                   	pop    %esi
80107a83:	5f                   	pop    %edi
80107a84:	5d                   	pop    %ebp
80107a85:	c3                   	ret    
80107a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a8d:	8d 76 00             	lea    0x0(%esi),%esi
80107a90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a93:	31 c0                	xor    %eax,%eax
}
80107a95:	5b                   	pop    %ebx
80107a96:	5e                   	pop    %esi
80107a97:	5f                   	pop    %edi
80107a98:	5d                   	pop    %ebp
80107a99:	c3                   	ret    

80107a9a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107a9a:	a1 00 00 00 00       	mov    0x0,%eax
80107a9f:	0f 0b                	ud2    

80107aa1 <copyout.cold>:
80107aa1:	a1 00 00 00 00       	mov    0x0,%eax
80107aa6:	0f 0b                	ud2    
