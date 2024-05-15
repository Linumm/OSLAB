
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
8010002d:	b8 50 31 10 80       	mov    $0x80103150,%eax
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
8010004c:	68 40 79 10 80       	push   $0x80107940
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 35 4b 00 00       	call   80104b90 <initlock>
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
80100092:	68 47 79 10 80       	push   $0x80107947
80100097:	50                   	push   %eax
80100098:	e8 c3 49 00 00       	call   80104a60 <initsleeplock>
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
801000e4:	e8 77 4c 00 00       	call   80104d60 <acquire>
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
80100162:	e8 99 4b 00 00       	call   80104d00 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 49 00 00       	call   80104aa0 <acquiresleep>
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
8010018c:	e8 3f 22 00 00       	call   801023d0 <iderw>
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
801001a1:	68 4e 79 10 80       	push   $0x8010794e
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
801001be:	e8 7d 49 00 00       	call   80104b40 <holdingsleep>
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
801001d4:	e9 f7 21 00 00       	jmp    801023d0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 79 10 80       	push   $0x8010795f
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
801001ff:	e8 3c 49 00 00       	call   80104b40 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 ec 48 00 00       	call   80104b00 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 40 4b 00 00       	call   80104d60 <acquire>
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
8010026c:	e9 8f 4a 00 00       	jmp    80104d00 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 66 79 10 80       	push   $0x80107966
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
80100294:	e8 b7 16 00 00       	call   80101950 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 bb 4a 00 00       	call   80104d60 <acquire>
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
801002cd:	e8 6e 3e 00 00       	call   80104140 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 39 38 00 00       	call   80103b20 <myproc>
801002e7:	8b 48 14             	mov    0x14(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 05 4a 00 00       	call   80104d00 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 6c 15 00 00       	call   80101870 <ilock>
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
8010034c:	e8 af 49 00 00       	call   80104d00 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 16 15 00 00       	call   80101870 <ilock>
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
80100399:	e8 42 26 00 00       	call   801029e0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 79 10 80       	push   $0x8010796d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 41 83 10 80 	movl   $0x80108341,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 e3 47 00 00       	call   80104bb0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 81 79 10 80       	push   $0x80107981
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
8010041a:	e8 31 60 00 00       	call   80106450 <uartputc>
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
80100505:	e8 46 5f 00 00       	call   80106450 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 3a 5f 00 00       	call   80106450 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 2e 5f 00 00       	call   80106450 <uartputc>
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
80100551:	e8 6a 49 00 00       	call   80104ec0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 b5 48 00 00       	call   80104e20 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 85 79 10 80       	push   $0x80107985
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
8010059f:	e8 ac 13 00 00       	call   80101950 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 b0 47 00 00       	call   80104d60 <acquire>
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
801005e4:	e8 17 47 00 00       	call   80104d00 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 7e 12 00 00       	call   80101870 <ilock>

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
80100636:	0f b6 92 b0 79 10 80 	movzbl -0x7fef8650(%edx),%edx
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
801007e8:	e8 73 45 00 00       	call   80104d60 <acquire>
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
80100838:	bf 98 79 10 80       	mov    $0x80107998,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 a0 44 00 00       	call   80104d00 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 9f 79 10 80       	push   $0x8010799f
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
80100893:	e8 c8 44 00 00       	call   80104d60 <acquire>
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
801009d0:	e8 2b 43 00 00       	call   80104d00 <release>
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
80100a0e:	e9 4d 3a 00 00       	jmp    80104460 <procdump>
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
80100a44:	e8 47 39 00 00       	call   80104390 <wakeup>
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
80100a66:	68 a8 79 10 80       	push   $0x801079a8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 1b 41 00 00       	call   80104b90 <initlock>

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
80100a99:	e8 d2 1a 00 00       	call   80102570 <ioapicenable>
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
80100abc:	e8 5f 30 00 00       	call   80103b20 <myproc>
  struct thread *t;
  struct thread *dt;
  int tidcopy = -1;
  enum procstate statecopy = UNUSED;
80100ac1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100ac8:	00 00 00 

  // Clear every other thread first and copy current thread tid
  // to assign it to default-thread
  for(t = curproc->threads; t < &curproc->threads[NTHREAD]; t++){
80100acb:	8d 70 6c             	lea    0x6c(%eax),%esi
  struct proc *curproc = myproc();
80100ace:	89 c7                	mov    %eax,%edi
  for(t = curproc->threads; t < &curproc->threads[NTHREAD]; t++){
80100ad0:	8d 98 6c 08 00 00    	lea    0x86c(%eax),%ebx
  int tidcopy = -1;
80100ad6:	c7 85 f4 fe ff ff ff 	movl   $0xffffffff,-0x10c(%ebp)
80100add:	ff ff ff 
80100ae0:	89 f0                	mov    %esi,%eax
80100ae2:	89 fe                	mov    %edi,%esi
80100ae4:	89 c7                	mov    %eax,%edi
80100ae6:	eb 47                	jmp    80100b2f <exec+0x7f>
80100ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aef:	90                   	nop
	if(t == &curproc->threads[curproc->curtidx]){
	  tidcopy = t->tid;
	  statecopy = t->state;
	}
	// user stacks will be cleared with freevm(pgdir)
	t->ustackp = -1;
80100af0:	c7 47 14 ff ff ff ff 	movl   $0xffffffff,0x14(%edi)
	kfree(t->kstack);
80100af7:	83 ec 0c             	sub    $0xc,%esp
  for(t = curproc->threads; t < &curproc->threads[NTHREAD]; t++){
80100afa:	83 c7 20             	add    $0x20,%edi
	kfree(t->kstack);
80100afd:	ff 77 e8             	push   -0x18(%edi)
80100b00:	e8 ab 1a 00 00       	call   801025b0 <kfree>
	t->kstack = 0;
80100b05:	c7 47 e8 00 00 00 00 	movl   $0x0,-0x18(%edi)
  for(t = curproc->threads; t < &curproc->threads[NTHREAD]; t++){
80100b0c:	83 c4 10             	add    $0x10,%esp
	t->tf = 0;
80100b0f:	c7 47 ec 00 00 00 00 	movl   $0x0,-0x14(%edi)
	t->context = 0;
80100b16:	c7 47 f0 00 00 00 00 	movl   $0x0,-0x10(%edi)
	t->state = UNUSED;
80100b1d:	c7 47 e0 00 00 00 00 	movl   $0x0,-0x20(%edi)
	t->chan = 0;
80100b24:	c7 47 f8 00 00 00 00 	movl   $0x0,-0x8(%edi)
  for(t = curproc->threads; t < &curproc->threads[NTHREAD]; t++){
80100b2b:	39 df                	cmp    %ebx,%edi
80100b2d:	74 29                	je     80100b58 <exec+0xa8>
	if(t == &curproc->threads[curproc->curtidx]){
80100b2f:	8b 96 6c 08 00 00    	mov    0x86c(%esi),%edx
80100b35:	c1 e2 05             	shl    $0x5,%edx
80100b38:	8d 54 16 6c          	lea    0x6c(%esi,%edx,1),%edx
80100b3c:	39 d7                	cmp    %edx,%edi
80100b3e:	75 b0                	jne    80100af0 <exec+0x40>
	  tidcopy = t->tid;
80100b40:	8b 47 04             	mov    0x4(%edi),%eax
80100b43:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
	  statecopy = t->state;
80100b49:	8b 07                	mov    (%edi),%eax
80100b4b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b51:	eb 9d                	jmp    80100af0 <exec+0x40>
80100b53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b57:	90                   	nop
  }
  // dt: curproc's default-thread
  dt = &curproc->threads[0];
  dt->tid = tidcopy;
80100b58:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b5e:	89 f7                	mov    %esi,%edi
80100b60:	89 46 70             	mov    %eax,0x70(%esi)
  dt->state = statecopy;
80100b63:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b69:	89 46 6c             	mov    %eax,0x6c(%esi)
  // re-init default-thread
  if((dt->kstack = kalloc()) == 0){
80100b6c:	e8 ff 1b 00 00       	call   80102770 <kalloc>
80100b71:	89 46 74             	mov    %eax,0x74(%esi)
80100b74:	85 c0                	test   %eax,%eax
80100b76:	0f 84 93 02 00 00    	je     80100e0f <exec+0x35f>
	cprintf("exec: fail by kalloc fail\n");
	return -1;
  }
  dt->chan = 0;
80100b7c:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
80100b83:	00 00 00 
  dt->ret = 0;
80100b86:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
80100b8d:	00 00 00 


  begin_op();
80100b90:	e8 bb 22 00 00       	call   80102e50 <begin_op>

  if((ip = namei(path)) == 0){
80100b95:	83 ec 0c             	sub    $0xc,%esp
80100b98:	ff 75 08             	push   0x8(%ebp)
80100b9b:	e8 f0 15 00 00       	call   80102190 <namei>
80100ba0:	83 c4 10             	add    $0x10,%esp
80100ba3:	89 c3                	mov    %eax,%ebx
80100ba5:	85 c0                	test   %eax,%eax
80100ba7:	0f 84 43 02 00 00    	je     80100df0 <exec+0x340>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100bad:	83 ec 0c             	sub    $0xc,%esp
80100bb0:	50                   	push   %eax
80100bb1:	e8 ba 0c 00 00       	call   80101870 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100bb6:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100bbc:	6a 34                	push   $0x34
80100bbe:	6a 00                	push   $0x0
80100bc0:	50                   	push   %eax
80100bc1:	53                   	push   %ebx
80100bc2:	e8 b9 0f 00 00       	call   80101b80 <readi>
80100bc7:	83 c4 20             	add    $0x20,%esp
80100bca:	83 f8 34             	cmp    $0x34,%eax
80100bcd:	74 1e                	je     80100bed <exec+0x13d>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100bcf:	83 ec 0c             	sub    $0xc,%esp
80100bd2:	53                   	push   %ebx
80100bd3:	e8 28 0f 00 00       	call   80101b00 <iunlockput>
    end_op();
80100bd8:	e8 e3 22 00 00       	call   80102ec0 <end_op>
80100bdd:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100be5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100be8:	5b                   	pop    %ebx
80100be9:	5e                   	pop    %esi
80100bea:	5f                   	pop    %edi
80100beb:	5d                   	pop    %ebp
80100bec:	c3                   	ret    
  if(elf.magic != ELF_MAGIC)
80100bed:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100bf4:	45 4c 46 
80100bf7:	75 d6                	jne    80100bcf <exec+0x11f>
  if((pgdir = setupkvm()) == 0)
80100bf9:	e8 e2 69 00 00       	call   801075e0 <setupkvm>
80100bfe:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100c04:	85 c0                	test   %eax,%eax
80100c06:	74 c7                	je     80100bcf <exec+0x11f>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c08:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100c0f:	00 
80100c10:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100c16:	0f 84 cf 02 00 00    	je     80100eeb <exec+0x43b>
80100c1c:	31 c0                	xor    %eax,%eax
80100c1e:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
  sz = 0;
80100c24:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100c2b:	00 00 00 
80100c2e:	89 c7                	mov    %eax,%edi
80100c30:	e9 89 00 00 00       	jmp    80100cbe <exec+0x20e>
80100c35:	8d 76 00             	lea    0x0(%esi),%esi
    if(ph.type != ELF_PROG_LOAD)
80100c38:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100c3f:	75 6c                	jne    80100cad <exec+0x1fd>
    if(ph.memsz < ph.filesz)
80100c41:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100c47:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100c4d:	0f 82 87 00 00 00    	jb     80100cda <exec+0x22a>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c53:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100c59:	72 7f                	jb     80100cda <exec+0x22a>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c5b:	83 ec 04             	sub    $0x4,%esp
80100c5e:	50                   	push   %eax
80100c5f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100c65:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c6b:	e8 90 67 00 00       	call   80107400 <allocuvm>
80100c70:	83 c4 10             	add    $0x10,%esp
80100c73:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c79:	85 c0                	test   %eax,%eax
80100c7b:	74 5d                	je     80100cda <exec+0x22a>
    if(ph.vaddr % PGSIZE != 0)
80100c7d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c83:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c88:	75 50                	jne    80100cda <exec+0x22a>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c8a:	83 ec 0c             	sub    $0xc,%esp
80100c8d:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100c93:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100c99:	53                   	push   %ebx
80100c9a:	50                   	push   %eax
80100c9b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ca1:	e8 6a 66 00 00       	call   80107310 <loaduvm>
80100ca6:	83 c4 20             	add    $0x20,%esp
80100ca9:	85 c0                	test   %eax,%eax
80100cab:	78 2d                	js     80100cda <exec+0x22a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cad:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100cb4:	83 c7 01             	add    $0x1,%edi
80100cb7:	83 c6 20             	add    $0x20,%esi
80100cba:	39 f8                	cmp    %edi,%eax
80100cbc:	7e 32                	jle    80100cf0 <exec+0x240>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100cbe:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100cc4:	6a 20                	push   $0x20
80100cc6:	56                   	push   %esi
80100cc7:	50                   	push   %eax
80100cc8:	53                   	push   %ebx
80100cc9:	e8 b2 0e 00 00       	call   80101b80 <readi>
80100cce:	83 c4 10             	add    $0x10,%esp
80100cd1:	83 f8 20             	cmp    $0x20,%eax
80100cd4:	0f 84 5e ff ff ff    	je     80100c38 <exec+0x188>
    freevm(pgdir);
80100cda:	83 ec 0c             	sub    $0xc,%esp
80100cdd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ce3:	e8 78 68 00 00       	call   80107560 <freevm>
  if(ip){
80100ce8:	83 c4 10             	add    $0x10,%esp
80100ceb:	e9 df fe ff ff       	jmp    80100bcf <exec+0x11f>
  sz = PGROUNDUP(sz);
80100cf0:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100cf6:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100cfc:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100d02:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d08:	8d 86 00 20 00 00    	lea    0x2000(%esi),%eax
  iunlockput(ip);
80100d0e:	83 ec 0c             	sub    $0xc,%esp
80100d11:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d17:	53                   	push   %ebx
80100d18:	e8 e3 0d 00 00       	call   80101b00 <iunlockput>
  end_op();
80100d1d:	e8 9e 21 00 00       	call   80102ec0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d22:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d28:	83 c4 0c             	add    $0xc,%esp
80100d2b:	50                   	push   %eax
80100d2c:	56                   	push   %esi
80100d2d:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100d33:	56                   	push   %esi
80100d34:	e8 c7 66 00 00       	call   80107400 <allocuvm>
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d42:	89 c3                	mov    %eax,%ebx
80100d44:	85 c0                	test   %eax,%eax
80100d46:	0f 84 89 00 00 00    	je     80100dd5 <exec+0x325>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d4c:	83 ec 08             	sub    $0x8,%esp
80100d4f:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100d55:	50                   	push   %eax
80100d56:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100d57:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d59:	e8 22 69 00 00       	call   80107680 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d61:	83 c4 10             	add    $0x10,%esp
80100d64:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d6a:	8b 00                	mov    (%eax),%eax
80100d6c:	85 c0                	test   %eax,%eax
80100d6e:	75 2b                	jne    80100d9b <exec+0x2eb>
80100d70:	e9 b4 00 00 00       	jmp    80100e29 <exec+0x379>
80100d75:	8d 76 00             	lea    0x0(%esi),%esi
80100d78:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100d7b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100d82:	83 c6 01             	add    $0x1,%esi
    ustack[3+argc] = sp;
80100d85:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100d8b:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100d8e:	85 c0                	test   %eax,%eax
80100d90:	0f 84 93 00 00 00    	je     80100e29 <exec+0x379>
    if(argc >= MAXARG)
80100d96:	83 fe 20             	cmp    $0x20,%esi
80100d99:	74 3a                	je     80100dd5 <exec+0x325>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d9b:	83 ec 0c             	sub    $0xc,%esp
80100d9e:	50                   	push   %eax
80100d9f:	e8 7c 42 00 00       	call   80105020 <strlen>
80100da4:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100da6:	58                   	pop    %eax
80100da7:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100daa:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dad:	ff 34 b0             	push   (%eax,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100db0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100db3:	e8 68 42 00 00       	call   80105020 <strlen>
80100db8:	83 c0 01             	add    $0x1,%eax
80100dbb:	50                   	push   %eax
80100dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dbf:	ff 34 b0             	push   (%eax,%esi,4)
80100dc2:	53                   	push   %ebx
80100dc3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100dc9:	e8 82 6a 00 00       	call   80107850 <copyout>
80100dce:	83 c4 20             	add    $0x20,%esp
80100dd1:	85 c0                	test   %eax,%eax
80100dd3:	79 a3                	jns    80100d78 <exec+0x2c8>
    freevm(pgdir);
80100dd5:	83 ec 0c             	sub    $0xc,%esp
80100dd8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100dde:	e8 7d 67 00 00       	call   80107560 <freevm>
80100de3:	83 c4 10             	add    $0x10,%esp
  return -1;
80100de6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100deb:	e9 f5 fd ff ff       	jmp    80100be5 <exec+0x135>
    end_op();
80100df0:	e8 cb 20 00 00       	call   80102ec0 <end_op>
    cprintf("exec: fail\n");
80100df5:	83 ec 0c             	sub    $0xc,%esp
80100df8:	68 dc 79 10 80       	push   $0x801079dc
80100dfd:	e8 9e f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100e02:	83 c4 10             	add    $0x10,%esp
80100e05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e0a:	e9 d6 fd ff ff       	jmp    80100be5 <exec+0x135>
	cprintf("exec: fail by kalloc fail\n");
80100e0f:	83 ec 0c             	sub    $0xc,%esp
80100e12:	68 c1 79 10 80       	push   $0x801079c1
80100e17:	e8 84 f8 ff ff       	call   801006a0 <cprintf>
	return -1;
80100e1c:	83 c4 10             	add    $0x10,%esp
80100e1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e24:	e9 bc fd ff ff       	jmp    80100be5 <exec+0x135>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e29:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100e30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100e32:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100e39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100e3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100e42:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100e48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e4a:	50                   	push   %eax
80100e4b:	52                   	push   %edx
80100e4c:	53                   	push   %ebx
80100e4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100e53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100e5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e63:	e8 e8 69 00 00       	call   80107850 <copyout>
80100e68:	83 c4 10             	add    $0x10,%esp
80100e6b:	85 c0                	test   %eax,%eax
80100e6d:	0f 88 62 ff ff ff    	js     80100dd5 <exec+0x325>
  for(last=s=path; *s; s++)
80100e73:	8b 45 08             	mov    0x8(%ebp),%eax
80100e76:	0f b6 00             	movzbl (%eax),%eax
80100e79:	84 c0                	test   %al,%al
80100e7b:	74 17                	je     80100e94 <exec+0x3e4>
80100e7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100e80:	89 ca                	mov    %ecx,%edx
      last = s+1;
80100e82:	83 c2 01             	add    $0x1,%edx
80100e85:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100e87:	0f b6 02             	movzbl (%edx),%eax
      last = s+1;
80100e8a:	0f 44 ca             	cmove  %edx,%ecx
  for(last=s=path; *s; s++)
80100e8d:	84 c0                	test   %al,%al
80100e8f:	75 f1                	jne    80100e82 <exec+0x3d2>
80100e91:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100e94:	83 ec 04             	sub    $0x4,%esp
80100e97:	8d 47 5c             	lea    0x5c(%edi),%eax
80100e9a:	6a 10                	push   $0x10
80100e9c:	ff 75 08             	push   0x8(%ebp)
80100e9f:	50                   	push   %eax
80100ea0:	e8 3b 41 00 00       	call   80104fe0 <safestrcpy>
  curproc->pgdir = pgdir;
80100ea5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100eab:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
80100eae:	89 47 04             	mov    %eax,0x4(%edi)
  curproc->sz = sz;
80100eb1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100eb7:	89 07                	mov    %eax,(%edi)
  dt->tf->eip = elf.entry;  // main
80100eb9:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  dt->ustackp = sz;
80100ebf:	89 87 80 00 00 00    	mov    %eax,0x80(%edi)
  dt->tf->eip = elf.entry;  // main
80100ec5:	8b 47 78             	mov    0x78(%edi),%eax
80100ec8:	89 48 38             	mov    %ecx,0x38(%eax)
  dt->tf->esp = sp;
80100ecb:	8b 47 78             	mov    0x78(%edi),%eax
80100ece:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100ed1:	89 3c 24             	mov    %edi,(%esp)
80100ed4:	e8 a7 62 00 00       	call   80107180 <switchuvm>
  freevm(oldpgdir);
80100ed9:	89 34 24             	mov    %esi,(%esp)
80100edc:	e8 7f 66 00 00       	call   80107560 <freevm>
  return 0;
80100ee1:	83 c4 10             	add    $0x10,%esp
80100ee4:	31 c0                	xor    %eax,%eax
80100ee6:	e9 fa fc ff ff       	jmp    80100be5 <exec+0x135>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100eeb:	b8 00 20 00 00       	mov    $0x2000,%eax
80100ef0:	31 f6                	xor    %esi,%esi
80100ef2:	e9 17 fe ff ff       	jmp    80100d0e <exec+0x25e>
80100ef7:	66 90                	xchg   %ax,%ax
80100ef9:	66 90                	xchg   %ax,%ax
80100efb:	66 90                	xchg   %ax,%ax
80100efd:	66 90                	xchg   %ax,%ax
80100eff:	90                   	nop

80100f00 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f06:	68 e8 79 10 80       	push   $0x801079e8
80100f0b:	68 60 ff 10 80       	push   $0x8010ff60
80100f10:	e8 7b 3c 00 00       	call   80104b90 <initlock>
}
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	c9                   	leave  
80100f19:	c3                   	ret    
80100f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f20 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f24:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100f29:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f2c:	68 60 ff 10 80       	push   $0x8010ff60
80100f31:	e8 2a 3e 00 00       	call   80104d60 <acquire>
80100f36:	83 c4 10             	add    $0x10,%esp
80100f39:	eb 10                	jmp    80100f4b <filealloc+0x2b>
80100f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f3f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f40:	83 c3 18             	add    $0x18,%ebx
80100f43:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100f49:	74 25                	je     80100f70 <filealloc+0x50>
    if(f->ref == 0){
80100f4b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f4e:	85 c0                	test   %eax,%eax
80100f50:	75 ee                	jne    80100f40 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f52:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100f55:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f5c:	68 60 ff 10 80       	push   $0x8010ff60
80100f61:	e8 9a 3d 00 00       	call   80104d00 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f66:	89 d8                	mov    %ebx,%eax
      return f;
80100f68:	83 c4 10             	add    $0x10,%esp
}
80100f6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f6e:	c9                   	leave  
80100f6f:	c3                   	ret    
  release(&ftable.lock);
80100f70:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f73:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f75:	68 60 ff 10 80       	push   $0x8010ff60
80100f7a:	e8 81 3d 00 00       	call   80104d00 <release>
}
80100f7f:	89 d8                	mov    %ebx,%eax
  return 0;
80100f81:	83 c4 10             	add    $0x10,%esp
}
80100f84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f87:	c9                   	leave  
80100f88:	c3                   	ret    
80100f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f90 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	53                   	push   %ebx
80100f94:	83 ec 10             	sub    $0x10,%esp
80100f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f9a:	68 60 ff 10 80       	push   $0x8010ff60
80100f9f:	e8 bc 3d 00 00       	call   80104d60 <acquire>
  if(f->ref < 1)
80100fa4:	8b 43 04             	mov    0x4(%ebx),%eax
80100fa7:	83 c4 10             	add    $0x10,%esp
80100faa:	85 c0                	test   %eax,%eax
80100fac:	7e 1a                	jle    80100fc8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100fae:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100fb1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100fb4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100fb7:	68 60 ff 10 80       	push   $0x8010ff60
80100fbc:	e8 3f 3d 00 00       	call   80104d00 <release>
  return f;
}
80100fc1:	89 d8                	mov    %ebx,%eax
80100fc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fc6:	c9                   	leave  
80100fc7:	c3                   	ret    
    panic("filedup");
80100fc8:	83 ec 0c             	sub    $0xc,%esp
80100fcb:	68 ef 79 10 80       	push   $0x801079ef
80100fd0:	e8 ab f3 ff ff       	call   80100380 <panic>
80100fd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 28             	sub    $0x28,%esp
80100fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100fec:	68 60 ff 10 80       	push   $0x8010ff60
80100ff1:	e8 6a 3d 00 00       	call   80104d60 <acquire>
  if(f->ref < 1)
80100ff6:	8b 53 04             	mov    0x4(%ebx),%edx
80100ff9:	83 c4 10             	add    $0x10,%esp
80100ffc:	85 d2                	test   %edx,%edx
80100ffe:	0f 8e a5 00 00 00    	jle    801010a9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101004:	83 ea 01             	sub    $0x1,%edx
80101007:	89 53 04             	mov    %edx,0x4(%ebx)
8010100a:	75 44                	jne    80101050 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010100c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101010:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101013:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101015:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010101b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010101e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101021:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101024:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80101029:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010102c:	e8 cf 3c 00 00       	call   80104d00 <release>

  if(ff.type == FD_PIPE)
80101031:	83 c4 10             	add    $0x10,%esp
80101034:	83 ff 01             	cmp    $0x1,%edi
80101037:	74 57                	je     80101090 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101039:	83 ff 02             	cmp    $0x2,%edi
8010103c:	74 2a                	je     80101068 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010103e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101041:	5b                   	pop    %ebx
80101042:	5e                   	pop    %esi
80101043:	5f                   	pop    %edi
80101044:	5d                   	pop    %ebp
80101045:	c3                   	ret    
80101046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010104d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101050:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80101057:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010105a:	5b                   	pop    %ebx
8010105b:	5e                   	pop    %esi
8010105c:	5f                   	pop    %edi
8010105d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010105e:	e9 9d 3c 00 00       	jmp    80104d00 <release>
80101063:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101067:	90                   	nop
    begin_op();
80101068:	e8 e3 1d 00 00       	call   80102e50 <begin_op>
    iput(ff.ip);
8010106d:	83 ec 0c             	sub    $0xc,%esp
80101070:	ff 75 e0             	push   -0x20(%ebp)
80101073:	e8 28 09 00 00       	call   801019a0 <iput>
    end_op();
80101078:	83 c4 10             	add    $0x10,%esp
}
8010107b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010107e:	5b                   	pop    %ebx
8010107f:	5e                   	pop    %esi
80101080:	5f                   	pop    %edi
80101081:	5d                   	pop    %ebp
    end_op();
80101082:	e9 39 1e 00 00       	jmp    80102ec0 <end_op>
80101087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101090:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101094:	83 ec 08             	sub    $0x8,%esp
80101097:	53                   	push   %ebx
80101098:	56                   	push   %esi
80101099:	e8 82 25 00 00       	call   80103620 <pipeclose>
8010109e:	83 c4 10             	add    $0x10,%esp
}
801010a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a4:	5b                   	pop    %ebx
801010a5:	5e                   	pop    %esi
801010a6:	5f                   	pop    %edi
801010a7:	5d                   	pop    %ebp
801010a8:	c3                   	ret    
    panic("fileclose");
801010a9:	83 ec 0c             	sub    $0xc,%esp
801010ac:	68 f7 79 10 80       	push   $0x801079f7
801010b1:	e8 ca f2 ff ff       	call   80100380 <panic>
801010b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010bd:	8d 76 00             	lea    0x0(%esi),%esi

801010c0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	53                   	push   %ebx
801010c4:	83 ec 04             	sub    $0x4,%esp
801010c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801010ca:	83 3b 02             	cmpl   $0x2,(%ebx)
801010cd:	75 31                	jne    80101100 <filestat+0x40>
    ilock(f->ip);
801010cf:	83 ec 0c             	sub    $0xc,%esp
801010d2:	ff 73 10             	push   0x10(%ebx)
801010d5:	e8 96 07 00 00       	call   80101870 <ilock>
    stati(f->ip, st);
801010da:	58                   	pop    %eax
801010db:	5a                   	pop    %edx
801010dc:	ff 75 0c             	push   0xc(%ebp)
801010df:	ff 73 10             	push   0x10(%ebx)
801010e2:	e8 69 0a 00 00       	call   80101b50 <stati>
    iunlock(f->ip);
801010e7:	59                   	pop    %ecx
801010e8:	ff 73 10             	push   0x10(%ebx)
801010eb:	e8 60 08 00 00       	call   80101950 <iunlock>
    return 0;
  }
  return -1;
}
801010f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801010f3:	83 c4 10             	add    $0x10,%esp
801010f6:	31 c0                	xor    %eax,%eax
}
801010f8:	c9                   	leave  
801010f9:	c3                   	ret    
801010fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101100:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101103:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101108:	c9                   	leave  
80101109:	c3                   	ret    
8010110a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101110 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 0c             	sub    $0xc,%esp
80101119:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010111c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010111f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101122:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101126:	74 60                	je     80101188 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101128:	8b 03                	mov    (%ebx),%eax
8010112a:	83 f8 01             	cmp    $0x1,%eax
8010112d:	74 41                	je     80101170 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010112f:	83 f8 02             	cmp    $0x2,%eax
80101132:	75 5b                	jne    8010118f <fileread+0x7f>
    ilock(f->ip);
80101134:	83 ec 0c             	sub    $0xc,%esp
80101137:	ff 73 10             	push   0x10(%ebx)
8010113a:	e8 31 07 00 00       	call   80101870 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010113f:	57                   	push   %edi
80101140:	ff 73 14             	push   0x14(%ebx)
80101143:	56                   	push   %esi
80101144:	ff 73 10             	push   0x10(%ebx)
80101147:	e8 34 0a 00 00       	call   80101b80 <readi>
8010114c:	83 c4 20             	add    $0x20,%esp
8010114f:	89 c6                	mov    %eax,%esi
80101151:	85 c0                	test   %eax,%eax
80101153:	7e 03                	jle    80101158 <fileread+0x48>
      f->off += r;
80101155:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101158:	83 ec 0c             	sub    $0xc,%esp
8010115b:	ff 73 10             	push   0x10(%ebx)
8010115e:	e8 ed 07 00 00       	call   80101950 <iunlock>
    return r;
80101163:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101166:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101169:	89 f0                	mov    %esi,%eax
8010116b:	5b                   	pop    %ebx
8010116c:	5e                   	pop    %esi
8010116d:	5f                   	pop    %edi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101170:	8b 43 0c             	mov    0xc(%ebx),%eax
80101173:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101176:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101179:	5b                   	pop    %ebx
8010117a:	5e                   	pop    %esi
8010117b:	5f                   	pop    %edi
8010117c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010117d:	e9 3e 26 00 00       	jmp    801037c0 <piperead>
80101182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101188:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010118d:	eb d7                	jmp    80101166 <fileread+0x56>
  panic("fileread");
8010118f:	83 ec 0c             	sub    $0xc,%esp
80101192:	68 01 7a 10 80       	push   $0x80107a01
80101197:	e8 e4 f1 ff ff       	call   80100380 <panic>
8010119c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011a0:	55                   	push   %ebp
801011a1:	89 e5                	mov    %esp,%ebp
801011a3:	57                   	push   %edi
801011a4:	56                   	push   %esi
801011a5:	53                   	push   %ebx
801011a6:	83 ec 1c             	sub    $0x1c,%esp
801011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801011ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
801011af:	89 45 dc             	mov    %eax,-0x24(%ebp)
801011b2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801011b5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801011b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801011bc:	0f 84 bd 00 00 00    	je     8010127f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801011c2:	8b 03                	mov    (%ebx),%eax
801011c4:	83 f8 01             	cmp    $0x1,%eax
801011c7:	0f 84 bf 00 00 00    	je     8010128c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801011cd:	83 f8 02             	cmp    $0x2,%eax
801011d0:	0f 85 c8 00 00 00    	jne    8010129e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801011d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801011d9:	31 f6                	xor    %esi,%esi
    while(i < n){
801011db:	85 c0                	test   %eax,%eax
801011dd:	7f 30                	jg     8010120f <filewrite+0x6f>
801011df:	e9 94 00 00 00       	jmp    80101278 <filewrite+0xd8>
801011e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801011e8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801011eb:	83 ec 0c             	sub    $0xc,%esp
801011ee:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
801011f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011f4:	e8 57 07 00 00       	call   80101950 <iunlock>
      end_op();
801011f9:	e8 c2 1c 00 00       	call   80102ec0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801011fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101201:	83 c4 10             	add    $0x10,%esp
80101204:	39 c7                	cmp    %eax,%edi
80101206:	75 5c                	jne    80101264 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101208:	01 fe                	add    %edi,%esi
    while(i < n){
8010120a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010120d:	7e 69                	jle    80101278 <filewrite+0xd8>
      int n1 = n - i;
8010120f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101212:	b8 00 06 00 00       	mov    $0x600,%eax
80101217:	29 f7                	sub    %esi,%edi
80101219:	39 c7                	cmp    %eax,%edi
8010121b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010121e:	e8 2d 1c 00 00       	call   80102e50 <begin_op>
      ilock(f->ip);
80101223:	83 ec 0c             	sub    $0xc,%esp
80101226:	ff 73 10             	push   0x10(%ebx)
80101229:	e8 42 06 00 00       	call   80101870 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010122e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101231:	57                   	push   %edi
80101232:	ff 73 14             	push   0x14(%ebx)
80101235:	01 f0                	add    %esi,%eax
80101237:	50                   	push   %eax
80101238:	ff 73 10             	push   0x10(%ebx)
8010123b:	e8 40 0a 00 00       	call   80101c80 <writei>
80101240:	83 c4 20             	add    $0x20,%esp
80101243:	85 c0                	test   %eax,%eax
80101245:	7f a1                	jg     801011e8 <filewrite+0x48>
      iunlock(f->ip);
80101247:	83 ec 0c             	sub    $0xc,%esp
8010124a:	ff 73 10             	push   0x10(%ebx)
8010124d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101250:	e8 fb 06 00 00       	call   80101950 <iunlock>
      end_op();
80101255:	e8 66 1c 00 00       	call   80102ec0 <end_op>
      if(r < 0)
8010125a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010125d:	83 c4 10             	add    $0x10,%esp
80101260:	85 c0                	test   %eax,%eax
80101262:	75 1b                	jne    8010127f <filewrite+0xdf>
        panic("short filewrite");
80101264:	83 ec 0c             	sub    $0xc,%esp
80101267:	68 0a 7a 10 80       	push   $0x80107a0a
8010126c:	e8 0f f1 ff ff       	call   80100380 <panic>
80101271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101278:	89 f0                	mov    %esi,%eax
8010127a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010127d:	74 05                	je     80101284 <filewrite+0xe4>
8010127f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101284:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101287:	5b                   	pop    %ebx
80101288:	5e                   	pop    %esi
80101289:	5f                   	pop    %edi
8010128a:	5d                   	pop    %ebp
8010128b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010128c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010128f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101292:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101295:	5b                   	pop    %ebx
80101296:	5e                   	pop    %esi
80101297:	5f                   	pop    %edi
80101298:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101299:	e9 22 24 00 00       	jmp    801036c0 <pipewrite>
  panic("filewrite");
8010129e:	83 ec 0c             	sub    $0xc,%esp
801012a1:	68 10 7a 10 80       	push   $0x80107a10
801012a6:	e8 d5 f0 ff ff       	call   80100380 <panic>
801012ab:	66 90                	xchg   %ax,%ax
801012ad:	66 90                	xchg   %ax,%ax
801012af:	90                   	nop

801012b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801012b0:	55                   	push   %ebp
801012b1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801012b3:	89 d0                	mov    %edx,%eax
801012b5:	c1 e8 0c             	shr    $0xc,%eax
801012b8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801012be:	89 e5                	mov    %esp,%ebp
801012c0:	56                   	push   %esi
801012c1:	53                   	push   %ebx
801012c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801012c4:	83 ec 08             	sub    $0x8,%esp
801012c7:	50                   	push   %eax
801012c8:	51                   	push   %ecx
801012c9:	e8 02 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801012ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801012d0:	c1 fb 03             	sar    $0x3,%ebx
801012d3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801012d6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801012d8:	83 e1 07             	and    $0x7,%ecx
801012db:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801012e0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801012e6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801012e8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801012ed:	85 c1                	test   %eax,%ecx
801012ef:	74 23                	je     80101314 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801012f1:	f7 d0                	not    %eax
  log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801012f6:	21 c8                	and    %ecx,%eax
801012f8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801012fc:	56                   	push   %esi
801012fd:	e8 2e 1d 00 00       	call   80103030 <log_write>
  brelse(bp);
80101302:	89 34 24             	mov    %esi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
}
8010130a:	83 c4 10             	add    $0x10,%esp
8010130d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101310:	5b                   	pop    %ebx
80101311:	5e                   	pop    %esi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
    panic("freeing free block");
80101314:	83 ec 0c             	sub    $0xc,%esp
80101317:	68 1a 7a 10 80       	push   $0x80107a1a
8010131c:	e8 5f f0 ff ff       	call   80100380 <panic>
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010132f:	90                   	nop

80101330 <balloc>:
{
80101330:	55                   	push   %ebp
80101331:	89 e5                	mov    %esp,%ebp
80101333:	57                   	push   %edi
80101334:	56                   	push   %esi
80101335:	53                   	push   %ebx
80101336:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101339:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010133f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101342:	85 c9                	test   %ecx,%ecx
80101344:	0f 84 87 00 00 00    	je     801013d1 <balloc+0xa1>
8010134a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101351:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101354:	83 ec 08             	sub    $0x8,%esp
80101357:	89 f0                	mov    %esi,%eax
80101359:	c1 f8 0c             	sar    $0xc,%eax
8010135c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101362:	50                   	push   %eax
80101363:	ff 75 d8             	push   -0x28(%ebp)
80101366:	e8 65 ed ff ff       	call   801000d0 <bread>
8010136b:	83 c4 10             	add    $0x10,%esp
8010136e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101371:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101376:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101379:	31 c0                	xor    %eax,%eax
8010137b:	eb 2f                	jmp    801013ac <balloc+0x7c>
8010137d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101380:	89 c1                	mov    %eax,%ecx
80101382:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101387:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010138a:	83 e1 07             	and    $0x7,%ecx
8010138d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010138f:	89 c1                	mov    %eax,%ecx
80101391:	c1 f9 03             	sar    $0x3,%ecx
80101394:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101399:	89 fa                	mov    %edi,%edx
8010139b:	85 df                	test   %ebx,%edi
8010139d:	74 41                	je     801013e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010139f:	83 c0 01             	add    $0x1,%eax
801013a2:	83 c6 01             	add    $0x1,%esi
801013a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801013aa:	74 05                	je     801013b1 <balloc+0x81>
801013ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801013af:	77 cf                	ja     80101380 <balloc+0x50>
    brelse(bp);
801013b1:	83 ec 0c             	sub    $0xc,%esp
801013b4:	ff 75 e4             	push   -0x1c(%ebp)
801013b7:	e8 34 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801013bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801013c3:	83 c4 10             	add    $0x10,%esp
801013c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801013c9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801013cf:	77 80                	ja     80101351 <balloc+0x21>
  panic("balloc: out of blocks");
801013d1:	83 ec 0c             	sub    $0xc,%esp
801013d4:	68 2d 7a 10 80       	push   $0x80107a2d
801013d9:	e8 a2 ef ff ff       	call   80100380 <panic>
801013de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801013e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801013e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801013e6:	09 da                	or     %ebx,%edx
801013e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801013ec:	57                   	push   %edi
801013ed:	e8 3e 1c 00 00       	call   80103030 <log_write>
        brelse(bp);
801013f2:	89 3c 24             	mov    %edi,(%esp)
801013f5:	e8 f6 ed ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801013fa:	58                   	pop    %eax
801013fb:	5a                   	pop    %edx
801013fc:	56                   	push   %esi
801013fd:	ff 75 d8             	push   -0x28(%ebp)
80101400:	e8 cb ec ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101405:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101408:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010140a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010140d:	68 00 02 00 00       	push   $0x200
80101412:	6a 00                	push   $0x0
80101414:	50                   	push   %eax
80101415:	e8 06 3a 00 00       	call   80104e20 <memset>
  log_write(bp);
8010141a:	89 1c 24             	mov    %ebx,(%esp)
8010141d:	e8 0e 1c 00 00       	call   80103030 <log_write>
  brelse(bp);
80101422:	89 1c 24             	mov    %ebx,(%esp)
80101425:	e8 c6 ed ff ff       	call   801001f0 <brelse>
}
8010142a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010142d:	89 f0                	mov    %esi,%eax
8010142f:	5b                   	pop    %ebx
80101430:	5e                   	pop    %esi
80101431:	5f                   	pop    %edi
80101432:	5d                   	pop    %ebp
80101433:	c3                   	ret    
80101434:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010143b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010143f:	90                   	nop

80101440 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	57                   	push   %edi
80101444:	89 c7                	mov    %eax,%edi
80101446:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101447:	31 f6                	xor    %esi,%esi
{
80101449:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010144a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010144f:	83 ec 28             	sub    $0x28,%esp
80101452:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101455:	68 60 09 11 80       	push   $0x80110960
8010145a:	e8 01 39 00 00       	call   80104d60 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010145f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101462:	83 c4 10             	add    $0x10,%esp
80101465:	eb 1b                	jmp    80101482 <iget+0x42>
80101467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010146e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101470:	39 3b                	cmp    %edi,(%ebx)
80101472:	74 6c                	je     801014e0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101474:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010147a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101480:	73 26                	jae    801014a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101482:	8b 43 08             	mov    0x8(%ebx),%eax
80101485:	85 c0                	test   %eax,%eax
80101487:	7f e7                	jg     80101470 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101489:	85 f6                	test   %esi,%esi
8010148b:	75 e7                	jne    80101474 <iget+0x34>
8010148d:	85 c0                	test   %eax,%eax
8010148f:	75 76                	jne    80101507 <iget+0xc7>
80101491:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101493:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101499:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010149f:	72 e1                	jb     80101482 <iget+0x42>
801014a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801014a8:	85 f6                	test   %esi,%esi
801014aa:	74 79                	je     80101525 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801014ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801014af:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801014b1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801014b4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801014bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801014c2:	68 60 09 11 80       	push   $0x80110960
801014c7:	e8 34 38 00 00       	call   80104d00 <release>

  return ip;
801014cc:	83 c4 10             	add    $0x10,%esp
}
801014cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014d2:	89 f0                	mov    %esi,%eax
801014d4:	5b                   	pop    %ebx
801014d5:	5e                   	pop    %esi
801014d6:	5f                   	pop    %edi
801014d7:	5d                   	pop    %ebp
801014d8:	c3                   	ret    
801014d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801014e3:	75 8f                	jne    80101474 <iget+0x34>
      release(&icache.lock);
801014e5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801014e8:	83 c0 01             	add    $0x1,%eax
      return ip;
801014eb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801014ed:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
801014f2:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801014f5:	e8 06 38 00 00       	call   80104d00 <release>
      return ip;
801014fa:	83 c4 10             	add    $0x10,%esp
}
801014fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101500:	89 f0                	mov    %esi,%eax
80101502:	5b                   	pop    %ebx
80101503:	5e                   	pop    %esi
80101504:	5f                   	pop    %edi
80101505:	5d                   	pop    %ebp
80101506:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101507:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010150d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101513:	73 10                	jae    80101525 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101515:	8b 43 08             	mov    0x8(%ebx),%eax
80101518:	85 c0                	test   %eax,%eax
8010151a:	0f 8f 50 ff ff ff    	jg     80101470 <iget+0x30>
80101520:	e9 68 ff ff ff       	jmp    8010148d <iget+0x4d>
    panic("iget: no inodes");
80101525:	83 ec 0c             	sub    $0xc,%esp
80101528:	68 43 7a 10 80       	push   $0x80107a43
8010152d:	e8 4e ee ff ff       	call   80100380 <panic>
80101532:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101540 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	89 c6                	mov    %eax,%esi
80101547:	53                   	push   %ebx
80101548:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010154b:	83 fa 0b             	cmp    $0xb,%edx
8010154e:	0f 86 8c 00 00 00    	jbe    801015e0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101554:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101557:	83 fb 7f             	cmp    $0x7f,%ebx
8010155a:	0f 87 a2 00 00 00    	ja     80101602 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101560:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101566:	85 c0                	test   %eax,%eax
80101568:	74 5e                	je     801015c8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010156a:	83 ec 08             	sub    $0x8,%esp
8010156d:	50                   	push   %eax
8010156e:	ff 36                	push   (%esi)
80101570:	e8 5b eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101575:	83 c4 10             	add    $0x10,%esp
80101578:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010157c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010157e:	8b 3b                	mov    (%ebx),%edi
80101580:	85 ff                	test   %edi,%edi
80101582:	74 1c                	je     801015a0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101584:	83 ec 0c             	sub    $0xc,%esp
80101587:	52                   	push   %edx
80101588:	e8 63 ec ff ff       	call   801001f0 <brelse>
8010158d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101590:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101593:	89 f8                	mov    %edi,%eax
80101595:	5b                   	pop    %ebx
80101596:	5e                   	pop    %esi
80101597:	5f                   	pop    %edi
80101598:	5d                   	pop    %ebp
80101599:	c3                   	ret    
8010159a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801015a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801015a3:	8b 06                	mov    (%esi),%eax
801015a5:	e8 86 fd ff ff       	call   80101330 <balloc>
      log_write(bp);
801015aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015ad:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801015b0:	89 03                	mov    %eax,(%ebx)
801015b2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801015b4:	52                   	push   %edx
801015b5:	e8 76 1a 00 00       	call   80103030 <log_write>
801015ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015bd:	83 c4 10             	add    $0x10,%esp
801015c0:	eb c2                	jmp    80101584 <bmap+0x44>
801015c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801015c8:	8b 06                	mov    (%esi),%eax
801015ca:	e8 61 fd ff ff       	call   80101330 <balloc>
801015cf:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801015d5:	eb 93                	jmp    8010156a <bmap+0x2a>
801015d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015de:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801015e0:	8d 5a 14             	lea    0x14(%edx),%ebx
801015e3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801015e7:	85 ff                	test   %edi,%edi
801015e9:	75 a5                	jne    80101590 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801015eb:	8b 00                	mov    (%eax),%eax
801015ed:	e8 3e fd ff ff       	call   80101330 <balloc>
801015f2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801015f6:	89 c7                	mov    %eax,%edi
}
801015f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015fb:	5b                   	pop    %ebx
801015fc:	89 f8                	mov    %edi,%eax
801015fe:	5e                   	pop    %esi
801015ff:	5f                   	pop    %edi
80101600:	5d                   	pop    %ebp
80101601:	c3                   	ret    
  panic("bmap: out of range");
80101602:	83 ec 0c             	sub    $0xc,%esp
80101605:	68 53 7a 10 80       	push   $0x80107a53
8010160a:	e8 71 ed ff ff       	call   80100380 <panic>
8010160f:	90                   	nop

80101610 <readsb>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	56                   	push   %esi
80101614:	53                   	push   %ebx
80101615:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101618:	83 ec 08             	sub    $0x8,%esp
8010161b:	6a 01                	push   $0x1
8010161d:	ff 75 08             	push   0x8(%ebp)
80101620:	e8 ab ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101625:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101628:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010162a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010162d:	6a 1c                	push   $0x1c
8010162f:	50                   	push   %eax
80101630:	56                   	push   %esi
80101631:	e8 8a 38 00 00       	call   80104ec0 <memmove>
  brelse(bp);
80101636:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101639:	83 c4 10             	add    $0x10,%esp
}
8010163c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010163f:	5b                   	pop    %ebx
80101640:	5e                   	pop    %esi
80101641:	5d                   	pop    %ebp
  brelse(bp);
80101642:	e9 a9 eb ff ff       	jmp    801001f0 <brelse>
80101647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010164e:	66 90                	xchg   %ax,%ax

80101650 <iinit>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101659:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010165c:	68 66 7a 10 80       	push   $0x80107a66
80101661:	68 60 09 11 80       	push   $0x80110960
80101666:	e8 25 35 00 00       	call   80104b90 <initlock>
  for(i = 0; i < NINODE; i++) {
8010166b:	83 c4 10             	add    $0x10,%esp
8010166e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101670:	83 ec 08             	sub    $0x8,%esp
80101673:	68 6d 7a 10 80       	push   $0x80107a6d
80101678:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101679:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010167f:	e8 dc 33 00 00       	call   80104a60 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101684:	83 c4 10             	add    $0x10,%esp
80101687:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010168d:	75 e1                	jne    80101670 <iinit+0x20>
  bp = bread(dev, 1);
8010168f:	83 ec 08             	sub    $0x8,%esp
80101692:	6a 01                	push   $0x1
80101694:	ff 75 08             	push   0x8(%ebp)
80101697:	e8 34 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010169c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010169f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801016a1:	8d 40 5c             	lea    0x5c(%eax),%eax
801016a4:	6a 1c                	push   $0x1c
801016a6:	50                   	push   %eax
801016a7:	68 b4 25 11 80       	push   $0x801125b4
801016ac:	e8 0f 38 00 00       	call   80104ec0 <memmove>
  brelse(bp);
801016b1:	89 1c 24             	mov    %ebx,(%esp)
801016b4:	e8 37 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016b9:	ff 35 cc 25 11 80    	push   0x801125cc
801016bf:	ff 35 c8 25 11 80    	push   0x801125c8
801016c5:	ff 35 c4 25 11 80    	push   0x801125c4
801016cb:	ff 35 c0 25 11 80    	push   0x801125c0
801016d1:	ff 35 bc 25 11 80    	push   0x801125bc
801016d7:	ff 35 b8 25 11 80    	push   0x801125b8
801016dd:	ff 35 b4 25 11 80    	push   0x801125b4
801016e3:	68 d0 7a 10 80       	push   $0x80107ad0
801016e8:	e8 b3 ef ff ff       	call   801006a0 <cprintf>
}
801016ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016f0:	83 c4 30             	add    $0x30,%esp
801016f3:	c9                   	leave  
801016f4:	c3                   	ret    
801016f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101700 <ialloc>:
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	57                   	push   %edi
80101704:	56                   	push   %esi
80101705:	53                   	push   %ebx
80101706:	83 ec 1c             	sub    $0x1c,%esp
80101709:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010170c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101713:	8b 75 08             	mov    0x8(%ebp),%esi
80101716:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101719:	0f 86 91 00 00 00    	jbe    801017b0 <ialloc+0xb0>
8010171f:	bf 01 00 00 00       	mov    $0x1,%edi
80101724:	eb 21                	jmp    80101747 <ialloc+0x47>
80101726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101730:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101733:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101736:	53                   	push   %ebx
80101737:	e8 b4 ea ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010173c:	83 c4 10             	add    $0x10,%esp
8010173f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101745:	73 69                	jae    801017b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101747:	89 f8                	mov    %edi,%eax
80101749:	83 ec 08             	sub    $0x8,%esp
8010174c:	c1 e8 03             	shr    $0x3,%eax
8010174f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101755:	50                   	push   %eax
80101756:	56                   	push   %esi
80101757:	e8 74 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010175c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010175f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101761:	89 f8                	mov    %edi,%eax
80101763:	83 e0 07             	and    $0x7,%eax
80101766:	c1 e0 06             	shl    $0x6,%eax
80101769:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010176d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101771:	75 bd                	jne    80101730 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101773:	83 ec 04             	sub    $0x4,%esp
80101776:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101779:	6a 40                	push   $0x40
8010177b:	6a 00                	push   $0x0
8010177d:	51                   	push   %ecx
8010177e:	e8 9d 36 00 00       	call   80104e20 <memset>
      dip->type = type;
80101783:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101787:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010178a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010178d:	89 1c 24             	mov    %ebx,(%esp)
80101790:	e8 9b 18 00 00       	call   80103030 <log_write>
      brelse(bp);
80101795:	89 1c 24             	mov    %ebx,(%esp)
80101798:	e8 53 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010179d:	83 c4 10             	add    $0x10,%esp
}
801017a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801017a3:	89 fa                	mov    %edi,%edx
}
801017a5:	5b                   	pop    %ebx
      return iget(dev, inum);
801017a6:	89 f0                	mov    %esi,%eax
}
801017a8:	5e                   	pop    %esi
801017a9:	5f                   	pop    %edi
801017aa:	5d                   	pop    %ebp
      return iget(dev, inum);
801017ab:	e9 90 fc ff ff       	jmp    80101440 <iget>
  panic("ialloc: no inodes");
801017b0:	83 ec 0c             	sub    $0xc,%esp
801017b3:	68 73 7a 10 80       	push   $0x80107a73
801017b8:	e8 c3 eb ff ff       	call   80100380 <panic>
801017bd:	8d 76 00             	lea    0x0(%esi),%esi

801017c0 <iupdate>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	56                   	push   %esi
801017c4:	53                   	push   %ebx
801017c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017cb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ce:	83 ec 08             	sub    $0x8,%esp
801017d1:	c1 e8 03             	shr    $0x3,%eax
801017d4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017da:	50                   	push   %eax
801017db:	ff 73 a4             	push   -0x5c(%ebx)
801017de:	e8 ed e8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801017e3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017e7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ea:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017ec:	8b 43 a8             	mov    -0x58(%ebx),%eax
801017ef:	83 e0 07             	and    $0x7,%eax
801017f2:	c1 e0 06             	shl    $0x6,%eax
801017f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801017f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017fc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101800:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101803:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101807:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010180b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010180f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101813:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101817:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010181a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010181d:	6a 34                	push   $0x34
8010181f:	53                   	push   %ebx
80101820:	50                   	push   %eax
80101821:	e8 9a 36 00 00       	call   80104ec0 <memmove>
  log_write(bp);
80101826:	89 34 24             	mov    %esi,(%esp)
80101829:	e8 02 18 00 00       	call   80103030 <log_write>
  brelse(bp);
8010182e:	89 75 08             	mov    %esi,0x8(%ebp)
80101831:	83 c4 10             	add    $0x10,%esp
}
80101834:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101837:	5b                   	pop    %ebx
80101838:	5e                   	pop    %esi
80101839:	5d                   	pop    %ebp
  brelse(bp);
8010183a:	e9 b1 e9 ff ff       	jmp    801001f0 <brelse>
8010183f:	90                   	nop

80101840 <idup>:
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	53                   	push   %ebx
80101844:	83 ec 10             	sub    $0x10,%esp
80101847:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010184a:	68 60 09 11 80       	push   $0x80110960
8010184f:	e8 0c 35 00 00       	call   80104d60 <acquire>
  ip->ref++;
80101854:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101858:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010185f:	e8 9c 34 00 00       	call   80104d00 <release>
}
80101864:	89 d8                	mov    %ebx,%eax
80101866:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101869:	c9                   	leave  
8010186a:	c3                   	ret    
8010186b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010186f:	90                   	nop

80101870 <ilock>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	56                   	push   %esi
80101874:	53                   	push   %ebx
80101875:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101878:	85 db                	test   %ebx,%ebx
8010187a:	0f 84 b7 00 00 00    	je     80101937 <ilock+0xc7>
80101880:	8b 53 08             	mov    0x8(%ebx),%edx
80101883:	85 d2                	test   %edx,%edx
80101885:	0f 8e ac 00 00 00    	jle    80101937 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010188b:	83 ec 0c             	sub    $0xc,%esp
8010188e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101891:	50                   	push   %eax
80101892:	e8 09 32 00 00       	call   80104aa0 <acquiresleep>
  if(ip->valid == 0){
80101897:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010189a:	83 c4 10             	add    $0x10,%esp
8010189d:	85 c0                	test   %eax,%eax
8010189f:	74 0f                	je     801018b0 <ilock+0x40>
}
801018a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018a4:	5b                   	pop    %ebx
801018a5:	5e                   	pop    %esi
801018a6:	5d                   	pop    %ebp
801018a7:	c3                   	ret    
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018b0:	8b 43 04             	mov    0x4(%ebx),%eax
801018b3:	83 ec 08             	sub    $0x8,%esp
801018b6:	c1 e8 03             	shr    $0x3,%eax
801018b9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801018bf:	50                   	push   %eax
801018c0:	ff 33                	push   (%ebx)
801018c2:	e8 09 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018c7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018ca:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018cc:	8b 43 04             	mov    0x4(%ebx),%eax
801018cf:	83 e0 07             	and    $0x7,%eax
801018d2:	c1 e0 06             	shl    $0x6,%eax
801018d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801018d9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018dc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801018df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801018e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801018e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801018eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801018ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801018f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801018f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801018fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801018fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101901:	6a 34                	push   $0x34
80101903:	50                   	push   %eax
80101904:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101907:	50                   	push   %eax
80101908:	e8 b3 35 00 00       	call   80104ec0 <memmove>
    brelse(bp);
8010190d:	89 34 24             	mov    %esi,(%esp)
80101910:	e8 db e8 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101915:	83 c4 10             	add    $0x10,%esp
80101918:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010191d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101924:	0f 85 77 ff ff ff    	jne    801018a1 <ilock+0x31>
      panic("ilock: no type");
8010192a:	83 ec 0c             	sub    $0xc,%esp
8010192d:	68 8b 7a 10 80       	push   $0x80107a8b
80101932:	e8 49 ea ff ff       	call   80100380 <panic>
    panic("ilock");
80101937:	83 ec 0c             	sub    $0xc,%esp
8010193a:	68 85 7a 10 80       	push   $0x80107a85
8010193f:	e8 3c ea ff ff       	call   80100380 <panic>
80101944:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010194b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010194f:	90                   	nop

80101950 <iunlock>:
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	56                   	push   %esi
80101954:	53                   	push   %ebx
80101955:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101958:	85 db                	test   %ebx,%ebx
8010195a:	74 28                	je     80101984 <iunlock+0x34>
8010195c:	83 ec 0c             	sub    $0xc,%esp
8010195f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101962:	56                   	push   %esi
80101963:	e8 d8 31 00 00       	call   80104b40 <holdingsleep>
80101968:	83 c4 10             	add    $0x10,%esp
8010196b:	85 c0                	test   %eax,%eax
8010196d:	74 15                	je     80101984 <iunlock+0x34>
8010196f:	8b 43 08             	mov    0x8(%ebx),%eax
80101972:	85 c0                	test   %eax,%eax
80101974:	7e 0e                	jle    80101984 <iunlock+0x34>
  releasesleep(&ip->lock);
80101976:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101979:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010197c:	5b                   	pop    %ebx
8010197d:	5e                   	pop    %esi
8010197e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010197f:	e9 7c 31 00 00       	jmp    80104b00 <releasesleep>
    panic("iunlock");
80101984:	83 ec 0c             	sub    $0xc,%esp
80101987:	68 9a 7a 10 80       	push   $0x80107a9a
8010198c:	e8 ef e9 ff ff       	call   80100380 <panic>
80101991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010199f:	90                   	nop

801019a0 <iput>:
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	57                   	push   %edi
801019a4:	56                   	push   %esi
801019a5:	53                   	push   %ebx
801019a6:	83 ec 28             	sub    $0x28,%esp
801019a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801019ac:	8d 7b 0c             	lea    0xc(%ebx),%edi
801019af:	57                   	push   %edi
801019b0:	e8 eb 30 00 00       	call   80104aa0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801019b5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801019b8:	83 c4 10             	add    $0x10,%esp
801019bb:	85 d2                	test   %edx,%edx
801019bd:	74 07                	je     801019c6 <iput+0x26>
801019bf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801019c4:	74 32                	je     801019f8 <iput+0x58>
  releasesleep(&ip->lock);
801019c6:	83 ec 0c             	sub    $0xc,%esp
801019c9:	57                   	push   %edi
801019ca:	e8 31 31 00 00       	call   80104b00 <releasesleep>
  acquire(&icache.lock);
801019cf:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801019d6:	e8 85 33 00 00       	call   80104d60 <acquire>
  ip->ref--;
801019db:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019df:	83 c4 10             	add    $0x10,%esp
801019e2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801019e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019ec:	5b                   	pop    %ebx
801019ed:	5e                   	pop    %esi
801019ee:	5f                   	pop    %edi
801019ef:	5d                   	pop    %ebp
  release(&icache.lock);
801019f0:	e9 0b 33 00 00       	jmp    80104d00 <release>
801019f5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801019f8:	83 ec 0c             	sub    $0xc,%esp
801019fb:	68 60 09 11 80       	push   $0x80110960
80101a00:	e8 5b 33 00 00       	call   80104d60 <acquire>
    int r = ip->ref;
80101a05:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a08:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101a0f:	e8 ec 32 00 00       	call   80104d00 <release>
    if(r == 1){
80101a14:	83 c4 10             	add    $0x10,%esp
80101a17:	83 fe 01             	cmp    $0x1,%esi
80101a1a:	75 aa                	jne    801019c6 <iput+0x26>
80101a1c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a22:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a25:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a28:	89 cf                	mov    %ecx,%edi
80101a2a:	eb 0b                	jmp    80101a37 <iput+0x97>
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a30:	83 c6 04             	add    $0x4,%esi
80101a33:	39 fe                	cmp    %edi,%esi
80101a35:	74 19                	je     80101a50 <iput+0xb0>
    if(ip->addrs[i]){
80101a37:	8b 16                	mov    (%esi),%edx
80101a39:	85 d2                	test   %edx,%edx
80101a3b:	74 f3                	je     80101a30 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a3d:	8b 03                	mov    (%ebx),%eax
80101a3f:	e8 6c f8 ff ff       	call   801012b0 <bfree>
      ip->addrs[i] = 0;
80101a44:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a4a:	eb e4                	jmp    80101a30 <iput+0x90>
80101a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a50:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a56:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a59:	85 c0                	test   %eax,%eax
80101a5b:	75 2d                	jne    80101a8a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a5d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a60:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a67:	53                   	push   %ebx
80101a68:	e8 53 fd ff ff       	call   801017c0 <iupdate>
      ip->type = 0;
80101a6d:	31 c0                	xor    %eax,%eax
80101a6f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a73:	89 1c 24             	mov    %ebx,(%esp)
80101a76:	e8 45 fd ff ff       	call   801017c0 <iupdate>
      ip->valid = 0;
80101a7b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a82:	83 c4 10             	add    $0x10,%esp
80101a85:	e9 3c ff ff ff       	jmp    801019c6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a8a:	83 ec 08             	sub    $0x8,%esp
80101a8d:	50                   	push   %eax
80101a8e:	ff 33                	push   (%ebx)
80101a90:	e8 3b e6 ff ff       	call   801000d0 <bread>
80101a95:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a98:	83 c4 10             	add    $0x10,%esp
80101a9b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101aa1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101aa4:	8d 70 5c             	lea    0x5c(%eax),%esi
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	eb 0c                	jmp    80101ab7 <iput+0x117>
80101aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aaf:	90                   	nop
80101ab0:	83 c6 04             	add    $0x4,%esi
80101ab3:	39 f7                	cmp    %esi,%edi
80101ab5:	74 0f                	je     80101ac6 <iput+0x126>
      if(a[j])
80101ab7:	8b 16                	mov    (%esi),%edx
80101ab9:	85 d2                	test   %edx,%edx
80101abb:	74 f3                	je     80101ab0 <iput+0x110>
        bfree(ip->dev, a[j]);
80101abd:	8b 03                	mov    (%ebx),%eax
80101abf:	e8 ec f7 ff ff       	call   801012b0 <bfree>
80101ac4:	eb ea                	jmp    80101ab0 <iput+0x110>
    brelse(bp);
80101ac6:	83 ec 0c             	sub    $0xc,%esp
80101ac9:	ff 75 e4             	push   -0x1c(%ebp)
80101acc:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101acf:	e8 1c e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ad4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101ada:	8b 03                	mov    (%ebx),%eax
80101adc:	e8 cf f7 ff ff       	call   801012b0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101ae1:	83 c4 10             	add    $0x10,%esp
80101ae4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101aeb:	00 00 00 
80101aee:	e9 6a ff ff ff       	jmp    80101a5d <iput+0xbd>
80101af3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101b00 <iunlockput>:
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	56                   	push   %esi
80101b04:	53                   	push   %ebx
80101b05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b08:	85 db                	test   %ebx,%ebx
80101b0a:	74 34                	je     80101b40 <iunlockput+0x40>
80101b0c:	83 ec 0c             	sub    $0xc,%esp
80101b0f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b12:	56                   	push   %esi
80101b13:	e8 28 30 00 00       	call   80104b40 <holdingsleep>
80101b18:	83 c4 10             	add    $0x10,%esp
80101b1b:	85 c0                	test   %eax,%eax
80101b1d:	74 21                	je     80101b40 <iunlockput+0x40>
80101b1f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b22:	85 c0                	test   %eax,%eax
80101b24:	7e 1a                	jle    80101b40 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101b26:	83 ec 0c             	sub    $0xc,%esp
80101b29:	56                   	push   %esi
80101b2a:	e8 d1 2f 00 00       	call   80104b00 <releasesleep>
  iput(ip);
80101b2f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b32:	83 c4 10             	add    $0x10,%esp
}
80101b35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b38:	5b                   	pop    %ebx
80101b39:	5e                   	pop    %esi
80101b3a:	5d                   	pop    %ebp
  iput(ip);
80101b3b:	e9 60 fe ff ff       	jmp    801019a0 <iput>
    panic("iunlock");
80101b40:	83 ec 0c             	sub    $0xc,%esp
80101b43:	68 9a 7a 10 80       	push   $0x80107a9a
80101b48:	e8 33 e8 ff ff       	call   80100380 <panic>
80101b4d:	8d 76 00             	lea    0x0(%esi),%esi

80101b50 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	8b 55 08             	mov    0x8(%ebp),%edx
80101b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b59:	8b 0a                	mov    (%edx),%ecx
80101b5b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b5e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b61:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b64:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b68:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b6b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b6f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b73:	8b 52 58             	mov    0x58(%edx),%edx
80101b76:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b79:	5d                   	pop    %ebp
80101b7a:	c3                   	ret    
80101b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b7f:	90                   	nop

80101b80 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	57                   	push   %edi
80101b84:	56                   	push   %esi
80101b85:	53                   	push   %ebx
80101b86:	83 ec 1c             	sub    $0x1c,%esp
80101b89:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8f:	8b 75 10             	mov    0x10(%ebp),%esi
80101b92:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b95:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b98:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b9d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ba0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ba3:	0f 84 a7 00 00 00    	je     80101c50 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ba9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bac:	8b 40 58             	mov    0x58(%eax),%eax
80101baf:	39 c6                	cmp    %eax,%esi
80101bb1:	0f 87 ba 00 00 00    	ja     80101c71 <readi+0xf1>
80101bb7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bba:	31 c9                	xor    %ecx,%ecx
80101bbc:	89 da                	mov    %ebx,%edx
80101bbe:	01 f2                	add    %esi,%edx
80101bc0:	0f 92 c1             	setb   %cl
80101bc3:	89 cf                	mov    %ecx,%edi
80101bc5:	0f 82 a6 00 00 00    	jb     80101c71 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101bcb:	89 c1                	mov    %eax,%ecx
80101bcd:	29 f1                	sub    %esi,%ecx
80101bcf:	39 d0                	cmp    %edx,%eax
80101bd1:	0f 43 cb             	cmovae %ebx,%ecx
80101bd4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bd7:	85 c9                	test   %ecx,%ecx
80101bd9:	74 67                	je     80101c42 <readi+0xc2>
80101bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bdf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101be3:	89 f2                	mov    %esi,%edx
80101be5:	c1 ea 09             	shr    $0x9,%edx
80101be8:	89 d8                	mov    %ebx,%eax
80101bea:	e8 51 f9 ff ff       	call   80101540 <bmap>
80101bef:	83 ec 08             	sub    $0x8,%esp
80101bf2:	50                   	push   %eax
80101bf3:	ff 33                	push   (%ebx)
80101bf5:	e8 d6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bfa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bfd:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c02:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c04:	89 f0                	mov    %esi,%eax
80101c06:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c0b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c0d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c10:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c12:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c16:	39 d9                	cmp    %ebx,%ecx
80101c18:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c1b:	83 c4 0c             	add    $0xc,%esp
80101c1e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c1f:	01 df                	add    %ebx,%edi
80101c21:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101c23:	50                   	push   %eax
80101c24:	ff 75 e0             	push   -0x20(%ebp)
80101c27:	e8 94 32 00 00       	call   80104ec0 <memmove>
    brelse(bp);
80101c2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c2f:	89 14 24             	mov    %edx,(%esp)
80101c32:	e8 b9 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c37:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c3a:	83 c4 10             	add    $0x10,%esp
80101c3d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c40:	77 9e                	ja     80101be0 <readi+0x60>
  }
  return n;
80101c42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c48:	5b                   	pop    %ebx
80101c49:	5e                   	pop    %esi
80101c4a:	5f                   	pop    %edi
80101c4b:	5d                   	pop    %ebp
80101c4c:	c3                   	ret    
80101c4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c54:	66 83 f8 09          	cmp    $0x9,%ax
80101c58:	77 17                	ja     80101c71 <readi+0xf1>
80101c5a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101c61:	85 c0                	test   %eax,%eax
80101c63:	74 0c                	je     80101c71 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6b:	5b                   	pop    %ebx
80101c6c:	5e                   	pop    %esi
80101c6d:	5f                   	pop    %edi
80101c6e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c6f:	ff e0                	jmp    *%eax
      return -1;
80101c71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c76:	eb cd                	jmp    80101c45 <readi+0xc5>
80101c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c7f:	90                   	nop

80101c80 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	56                   	push   %esi
80101c85:	53                   	push   %ebx
80101c86:	83 ec 1c             	sub    $0x1c,%esp
80101c89:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c8f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c92:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c97:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c9d:	8b 75 10             	mov    0x10(%ebp),%esi
80101ca0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ca3:	0f 84 b7 00 00 00    	je     80101d60 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ca9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cac:	3b 70 58             	cmp    0x58(%eax),%esi
80101caf:	0f 87 e7 00 00 00    	ja     80101d9c <writei+0x11c>
80101cb5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101cb8:	31 d2                	xor    %edx,%edx
80101cba:	89 f8                	mov    %edi,%eax
80101cbc:	01 f0                	add    %esi,%eax
80101cbe:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101cc1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101cc6:	0f 87 d0 00 00 00    	ja     80101d9c <writei+0x11c>
80101ccc:	85 d2                	test   %edx,%edx
80101cce:	0f 85 c8 00 00 00    	jne    80101d9c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cd4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101cdb:	85 ff                	test   %edi,%edi
80101cdd:	74 72                	je     80101d51 <writei+0xd1>
80101cdf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ce0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ce3:	89 f2                	mov    %esi,%edx
80101ce5:	c1 ea 09             	shr    $0x9,%edx
80101ce8:	89 f8                	mov    %edi,%eax
80101cea:	e8 51 f8 ff ff       	call   80101540 <bmap>
80101cef:	83 ec 08             	sub    $0x8,%esp
80101cf2:	50                   	push   %eax
80101cf3:	ff 37                	push   (%edi)
80101cf5:	e8 d6 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101cfa:	b9 00 02 00 00       	mov    $0x200,%ecx
80101cff:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d02:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d05:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d07:	89 f0                	mov    %esi,%eax
80101d09:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d0e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d10:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d14:	39 d9                	cmp    %ebx,%ecx
80101d16:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d19:	83 c4 0c             	add    $0xc,%esp
80101d1c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d1d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101d1f:	ff 75 dc             	push   -0x24(%ebp)
80101d22:	50                   	push   %eax
80101d23:	e8 98 31 00 00       	call   80104ec0 <memmove>
    log_write(bp);
80101d28:	89 3c 24             	mov    %edi,(%esp)
80101d2b:	e8 00 13 00 00       	call   80103030 <log_write>
    brelse(bp);
80101d30:	89 3c 24             	mov    %edi,(%esp)
80101d33:	e8 b8 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d38:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d3b:	83 c4 10             	add    $0x10,%esp
80101d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d41:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d44:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101d47:	77 97                	ja     80101ce0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d4c:	3b 70 58             	cmp    0x58(%eax),%esi
80101d4f:	77 37                	ja     80101d88 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d51:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d57:	5b                   	pop    %ebx
80101d58:	5e                   	pop    %esi
80101d59:	5f                   	pop    %edi
80101d5a:	5d                   	pop    %ebp
80101d5b:	c3                   	ret    
80101d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d64:	66 83 f8 09          	cmp    $0x9,%ax
80101d68:	77 32                	ja     80101d9c <writei+0x11c>
80101d6a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101d71:	85 c0                	test   %eax,%eax
80101d73:	74 27                	je     80101d9c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101d75:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7b:	5b                   	pop    %ebx
80101d7c:	5e                   	pop    %esi
80101d7d:	5f                   	pop    %edi
80101d7e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d7f:	ff e0                	jmp    *%eax
80101d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101d88:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101d8b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d8e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d91:	50                   	push   %eax
80101d92:	e8 29 fa ff ff       	call   801017c0 <iupdate>
80101d97:	83 c4 10             	add    $0x10,%esp
80101d9a:	eb b5                	jmp    80101d51 <writei+0xd1>
      return -1;
80101d9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101da1:	eb b1                	jmp    80101d54 <writei+0xd4>
80101da3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101db0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101db6:	6a 0e                	push   $0xe
80101db8:	ff 75 0c             	push   0xc(%ebp)
80101dbb:	ff 75 08             	push   0x8(%ebp)
80101dbe:	e8 6d 31 00 00       	call   80104f30 <strncmp>
}
80101dc3:	c9                   	leave  
80101dc4:	c3                   	ret    
80101dc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101dd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	57                   	push   %edi
80101dd4:	56                   	push   %esi
80101dd5:	53                   	push   %ebx
80101dd6:	83 ec 1c             	sub    $0x1c,%esp
80101dd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101ddc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101de1:	0f 85 85 00 00 00    	jne    80101e6c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101de7:	8b 53 58             	mov    0x58(%ebx),%edx
80101dea:	31 ff                	xor    %edi,%edi
80101dec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101def:	85 d2                	test   %edx,%edx
80101df1:	74 3e                	je     80101e31 <dirlookup+0x61>
80101df3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101df7:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101df8:	6a 10                	push   $0x10
80101dfa:	57                   	push   %edi
80101dfb:	56                   	push   %esi
80101dfc:	53                   	push   %ebx
80101dfd:	e8 7e fd ff ff       	call   80101b80 <readi>
80101e02:	83 c4 10             	add    $0x10,%esp
80101e05:	83 f8 10             	cmp    $0x10,%eax
80101e08:	75 55                	jne    80101e5f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101e0a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e0f:	74 18                	je     80101e29 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101e11:	83 ec 04             	sub    $0x4,%esp
80101e14:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e17:	6a 0e                	push   $0xe
80101e19:	50                   	push   %eax
80101e1a:	ff 75 0c             	push   0xc(%ebp)
80101e1d:	e8 0e 31 00 00       	call   80104f30 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e22:	83 c4 10             	add    $0x10,%esp
80101e25:	85 c0                	test   %eax,%eax
80101e27:	74 17                	je     80101e40 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e29:	83 c7 10             	add    $0x10,%edi
80101e2c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e2f:	72 c7                	jb     80101df8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e34:	31 c0                	xor    %eax,%eax
}
80101e36:	5b                   	pop    %ebx
80101e37:	5e                   	pop    %esi
80101e38:	5f                   	pop    %edi
80101e39:	5d                   	pop    %ebp
80101e3a:	c3                   	ret    
80101e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e3f:	90                   	nop
      if(poff)
80101e40:	8b 45 10             	mov    0x10(%ebp),%eax
80101e43:	85 c0                	test   %eax,%eax
80101e45:	74 05                	je     80101e4c <dirlookup+0x7c>
        *poff = off;
80101e47:	8b 45 10             	mov    0x10(%ebp),%eax
80101e4a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e4c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e50:	8b 03                	mov    (%ebx),%eax
80101e52:	e8 e9 f5 ff ff       	call   80101440 <iget>
}
80101e57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e5a:	5b                   	pop    %ebx
80101e5b:	5e                   	pop    %esi
80101e5c:	5f                   	pop    %edi
80101e5d:	5d                   	pop    %ebp
80101e5e:	c3                   	ret    
      panic("dirlookup read");
80101e5f:	83 ec 0c             	sub    $0xc,%esp
80101e62:	68 b4 7a 10 80       	push   $0x80107ab4
80101e67:	e8 14 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101e6c:	83 ec 0c             	sub    $0xc,%esp
80101e6f:	68 a2 7a 10 80       	push   $0x80107aa2
80101e74:	e8 07 e5 ff ff       	call   80100380 <panic>
80101e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e80:	55                   	push   %ebp
80101e81:	89 e5                	mov    %esp,%ebp
80101e83:	57                   	push   %edi
80101e84:	56                   	push   %esi
80101e85:	53                   	push   %ebx
80101e86:	89 c3                	mov    %eax,%ebx
80101e88:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e8b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e8e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e91:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e94:	0f 84 64 01 00 00    	je     80101ffe <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e9a:	e8 81 1c 00 00       	call   80103b20 <myproc>
  acquire(&icache.lock);
80101e9f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101ea2:	8b 70 58             	mov    0x58(%eax),%esi
  acquire(&icache.lock);
80101ea5:	68 60 09 11 80       	push   $0x80110960
80101eaa:	e8 b1 2e 00 00       	call   80104d60 <acquire>
  ip->ref++;
80101eaf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101eb3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101eba:	e8 41 2e 00 00       	call   80104d00 <release>
80101ebf:	83 c4 10             	add    $0x10,%esp
80101ec2:	eb 07                	jmp    80101ecb <namex+0x4b>
80101ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ec8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ecb:	0f b6 03             	movzbl (%ebx),%eax
80101ece:	3c 2f                	cmp    $0x2f,%al
80101ed0:	74 f6                	je     80101ec8 <namex+0x48>
  if(*path == 0)
80101ed2:	84 c0                	test   %al,%al
80101ed4:	0f 84 06 01 00 00    	je     80101fe0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101eda:	0f b6 03             	movzbl (%ebx),%eax
80101edd:	84 c0                	test   %al,%al
80101edf:	0f 84 10 01 00 00    	je     80101ff5 <namex+0x175>
80101ee5:	89 df                	mov    %ebx,%edi
80101ee7:	3c 2f                	cmp    $0x2f,%al
80101ee9:	0f 84 06 01 00 00    	je     80101ff5 <namex+0x175>
80101eef:	90                   	nop
80101ef0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101ef4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101ef7:	3c 2f                	cmp    $0x2f,%al
80101ef9:	74 04                	je     80101eff <namex+0x7f>
80101efb:	84 c0                	test   %al,%al
80101efd:	75 f1                	jne    80101ef0 <namex+0x70>
  len = path - s;
80101eff:	89 f8                	mov    %edi,%eax
80101f01:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101f03:	83 f8 0d             	cmp    $0xd,%eax
80101f06:	0f 8e ac 00 00 00    	jle    80101fb8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101f0c:	83 ec 04             	sub    $0x4,%esp
80101f0f:	6a 0e                	push   $0xe
80101f11:	53                   	push   %ebx
    path++;
80101f12:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101f14:	ff 75 e4             	push   -0x1c(%ebp)
80101f17:	e8 a4 2f 00 00       	call   80104ec0 <memmove>
80101f1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f1f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f22:	75 0c                	jne    80101f30 <namex+0xb0>
80101f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f28:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f2b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f2e:	74 f8                	je     80101f28 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 37 f9 ff ff       	call   80101870 <ilock>
    if(ip->type != T_DIR){
80101f39:	83 c4 10             	add    $0x10,%esp
80101f3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f41:	0f 85 cd 00 00 00    	jne    80102014 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f47:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f4a:	85 c0                	test   %eax,%eax
80101f4c:	74 09                	je     80101f57 <namex+0xd7>
80101f4e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f51:	0f 84 22 01 00 00    	je     80102079 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f57:	83 ec 04             	sub    $0x4,%esp
80101f5a:	6a 00                	push   $0x0
80101f5c:	ff 75 e4             	push   -0x1c(%ebp)
80101f5f:	56                   	push   %esi
80101f60:	e8 6b fe ff ff       	call   80101dd0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f65:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101f68:	83 c4 10             	add    $0x10,%esp
80101f6b:	89 c7                	mov    %eax,%edi
80101f6d:	85 c0                	test   %eax,%eax
80101f6f:	0f 84 e1 00 00 00    	je     80102056 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f75:	83 ec 0c             	sub    $0xc,%esp
80101f78:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f7b:	52                   	push   %edx
80101f7c:	e8 bf 2b 00 00       	call   80104b40 <holdingsleep>
80101f81:	83 c4 10             	add    $0x10,%esp
80101f84:	85 c0                	test   %eax,%eax
80101f86:	0f 84 30 01 00 00    	je     801020bc <namex+0x23c>
80101f8c:	8b 56 08             	mov    0x8(%esi),%edx
80101f8f:	85 d2                	test   %edx,%edx
80101f91:	0f 8e 25 01 00 00    	jle    801020bc <namex+0x23c>
  releasesleep(&ip->lock);
80101f97:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f9a:	83 ec 0c             	sub    $0xc,%esp
80101f9d:	52                   	push   %edx
80101f9e:	e8 5d 2b 00 00       	call   80104b00 <releasesleep>
  iput(ip);
80101fa3:	89 34 24             	mov    %esi,(%esp)
80101fa6:	89 fe                	mov    %edi,%esi
80101fa8:	e8 f3 f9 ff ff       	call   801019a0 <iput>
80101fad:	83 c4 10             	add    $0x10,%esp
80101fb0:	e9 16 ff ff ff       	jmp    80101ecb <namex+0x4b>
80101fb5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101fb8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101fbb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101fbe:	83 ec 04             	sub    $0x4,%esp
80101fc1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101fc4:	50                   	push   %eax
80101fc5:	53                   	push   %ebx
    name[len] = 0;
80101fc6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101fc8:	ff 75 e4             	push   -0x1c(%ebp)
80101fcb:	e8 f0 2e 00 00       	call   80104ec0 <memmove>
    name[len] = 0;
80101fd0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101fd3:	83 c4 10             	add    $0x10,%esp
80101fd6:	c6 02 00             	movb   $0x0,(%edx)
80101fd9:	e9 41 ff ff ff       	jmp    80101f1f <namex+0x9f>
80101fde:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101fe0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101fe3:	85 c0                	test   %eax,%eax
80101fe5:	0f 85 be 00 00 00    	jne    801020a9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101feb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fee:	89 f0                	mov    %esi,%eax
80101ff0:	5b                   	pop    %ebx
80101ff1:	5e                   	pop    %esi
80101ff2:	5f                   	pop    %edi
80101ff3:	5d                   	pop    %ebp
80101ff4:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101ff5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ff8:	89 df                	mov    %ebx,%edi
80101ffa:	31 c0                	xor    %eax,%eax
80101ffc:	eb c0                	jmp    80101fbe <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101ffe:	ba 01 00 00 00       	mov    $0x1,%edx
80102003:	b8 01 00 00 00       	mov    $0x1,%eax
80102008:	e8 33 f4 ff ff       	call   80101440 <iget>
8010200d:	89 c6                	mov    %eax,%esi
8010200f:	e9 b7 fe ff ff       	jmp    80101ecb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102014:	83 ec 0c             	sub    $0xc,%esp
80102017:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010201a:	53                   	push   %ebx
8010201b:	e8 20 2b 00 00       	call   80104b40 <holdingsleep>
80102020:	83 c4 10             	add    $0x10,%esp
80102023:	85 c0                	test   %eax,%eax
80102025:	0f 84 91 00 00 00    	je     801020bc <namex+0x23c>
8010202b:	8b 46 08             	mov    0x8(%esi),%eax
8010202e:	85 c0                	test   %eax,%eax
80102030:	0f 8e 86 00 00 00    	jle    801020bc <namex+0x23c>
  releasesleep(&ip->lock);
80102036:	83 ec 0c             	sub    $0xc,%esp
80102039:	53                   	push   %ebx
8010203a:	e8 c1 2a 00 00       	call   80104b00 <releasesleep>
  iput(ip);
8010203f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102042:	31 f6                	xor    %esi,%esi
  iput(ip);
80102044:	e8 57 f9 ff ff       	call   801019a0 <iput>
      return 0;
80102049:	83 c4 10             	add    $0x10,%esp
}
8010204c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010204f:	89 f0                	mov    %esi,%eax
80102051:	5b                   	pop    %ebx
80102052:	5e                   	pop    %esi
80102053:	5f                   	pop    %edi
80102054:	5d                   	pop    %ebp
80102055:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102056:	83 ec 0c             	sub    $0xc,%esp
80102059:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010205c:	52                   	push   %edx
8010205d:	e8 de 2a 00 00       	call   80104b40 <holdingsleep>
80102062:	83 c4 10             	add    $0x10,%esp
80102065:	85 c0                	test   %eax,%eax
80102067:	74 53                	je     801020bc <namex+0x23c>
80102069:	8b 4e 08             	mov    0x8(%esi),%ecx
8010206c:	85 c9                	test   %ecx,%ecx
8010206e:	7e 4c                	jle    801020bc <namex+0x23c>
  releasesleep(&ip->lock);
80102070:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102073:	83 ec 0c             	sub    $0xc,%esp
80102076:	52                   	push   %edx
80102077:	eb c1                	jmp    8010203a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102079:	83 ec 0c             	sub    $0xc,%esp
8010207c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010207f:	53                   	push   %ebx
80102080:	e8 bb 2a 00 00       	call   80104b40 <holdingsleep>
80102085:	83 c4 10             	add    $0x10,%esp
80102088:	85 c0                	test   %eax,%eax
8010208a:	74 30                	je     801020bc <namex+0x23c>
8010208c:	8b 7e 08             	mov    0x8(%esi),%edi
8010208f:	85 ff                	test   %edi,%edi
80102091:	7e 29                	jle    801020bc <namex+0x23c>
  releasesleep(&ip->lock);
80102093:	83 ec 0c             	sub    $0xc,%esp
80102096:	53                   	push   %ebx
80102097:	e8 64 2a 00 00       	call   80104b00 <releasesleep>
}
8010209c:	83 c4 10             	add    $0x10,%esp
}
8010209f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a2:	89 f0                	mov    %esi,%eax
801020a4:	5b                   	pop    %ebx
801020a5:	5e                   	pop    %esi
801020a6:	5f                   	pop    %edi
801020a7:	5d                   	pop    %ebp
801020a8:	c3                   	ret    
    iput(ip);
801020a9:	83 ec 0c             	sub    $0xc,%esp
801020ac:	56                   	push   %esi
    return 0;
801020ad:	31 f6                	xor    %esi,%esi
    iput(ip);
801020af:	e8 ec f8 ff ff       	call   801019a0 <iput>
    return 0;
801020b4:	83 c4 10             	add    $0x10,%esp
801020b7:	e9 2f ff ff ff       	jmp    80101feb <namex+0x16b>
    panic("iunlock");
801020bc:	83 ec 0c             	sub    $0xc,%esp
801020bf:	68 9a 7a 10 80       	push   $0x80107a9a
801020c4:	e8 b7 e2 ff ff       	call   80100380 <panic>
801020c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020d0 <dirlink>:
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	57                   	push   %edi
801020d4:	56                   	push   %esi
801020d5:	53                   	push   %ebx
801020d6:	83 ec 20             	sub    $0x20,%esp
801020d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801020dc:	6a 00                	push   $0x0
801020de:	ff 75 0c             	push   0xc(%ebp)
801020e1:	53                   	push   %ebx
801020e2:	e8 e9 fc ff ff       	call   80101dd0 <dirlookup>
801020e7:	83 c4 10             	add    $0x10,%esp
801020ea:	85 c0                	test   %eax,%eax
801020ec:	75 67                	jne    80102155 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020ee:	8b 7b 58             	mov    0x58(%ebx),%edi
801020f1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020f4:	85 ff                	test   %edi,%edi
801020f6:	74 29                	je     80102121 <dirlink+0x51>
801020f8:	31 ff                	xor    %edi,%edi
801020fa:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020fd:	eb 09                	jmp    80102108 <dirlink+0x38>
801020ff:	90                   	nop
80102100:	83 c7 10             	add    $0x10,%edi
80102103:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102106:	73 19                	jae    80102121 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102108:	6a 10                	push   $0x10
8010210a:	57                   	push   %edi
8010210b:	56                   	push   %esi
8010210c:	53                   	push   %ebx
8010210d:	e8 6e fa ff ff       	call   80101b80 <readi>
80102112:	83 c4 10             	add    $0x10,%esp
80102115:	83 f8 10             	cmp    $0x10,%eax
80102118:	75 4e                	jne    80102168 <dirlink+0x98>
    if(de.inum == 0)
8010211a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010211f:	75 df                	jne    80102100 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102121:	83 ec 04             	sub    $0x4,%esp
80102124:	8d 45 da             	lea    -0x26(%ebp),%eax
80102127:	6a 0e                	push   $0xe
80102129:	ff 75 0c             	push   0xc(%ebp)
8010212c:	50                   	push   %eax
8010212d:	e8 4e 2e 00 00       	call   80104f80 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102132:	6a 10                	push   $0x10
  de.inum = inum;
80102134:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102137:	57                   	push   %edi
80102138:	56                   	push   %esi
80102139:	53                   	push   %ebx
  de.inum = inum;
8010213a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010213e:	e8 3d fb ff ff       	call   80101c80 <writei>
80102143:	83 c4 20             	add    $0x20,%esp
80102146:	83 f8 10             	cmp    $0x10,%eax
80102149:	75 2a                	jne    80102175 <dirlink+0xa5>
  return 0;
8010214b:	31 c0                	xor    %eax,%eax
}
8010214d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102150:	5b                   	pop    %ebx
80102151:	5e                   	pop    %esi
80102152:	5f                   	pop    %edi
80102153:	5d                   	pop    %ebp
80102154:	c3                   	ret    
    iput(ip);
80102155:	83 ec 0c             	sub    $0xc,%esp
80102158:	50                   	push   %eax
80102159:	e8 42 f8 ff ff       	call   801019a0 <iput>
    return -1;
8010215e:	83 c4 10             	add    $0x10,%esp
80102161:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102166:	eb e5                	jmp    8010214d <dirlink+0x7d>
      panic("dirlink read");
80102168:	83 ec 0c             	sub    $0xc,%esp
8010216b:	68 c3 7a 10 80       	push   $0x80107ac3
80102170:	e8 0b e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102175:	83 ec 0c             	sub    $0xc,%esp
80102178:	68 3e 81 10 80       	push   $0x8010813e
8010217d:	e8 fe e1 ff ff       	call   80100380 <panic>
80102182:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102190 <namei>:

struct inode*
namei(char *path)
{
80102190:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102191:	31 d2                	xor    %edx,%edx
{
80102193:	89 e5                	mov    %esp,%ebp
80102195:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102198:	8b 45 08             	mov    0x8(%ebp),%eax
8010219b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010219e:	e8 dd fc ff ff       	call   80101e80 <namex>
}
801021a3:	c9                   	leave  
801021a4:	c3                   	ret    
801021a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021b0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021b0:	55                   	push   %ebp
  return namex(path, 1, name);
801021b1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021b6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021be:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021bf:	e9 bc fc ff ff       	jmp    80101e80 <namex>
801021c4:	66 90                	xchg   %ax,%ax
801021c6:	66 90                	xchg   %ax,%ax
801021c8:	66 90                	xchg   %ax,%ax
801021ca:	66 90                	xchg   %ax,%ax
801021cc:	66 90                	xchg   %ax,%ax
801021ce:	66 90                	xchg   %ax,%ax

801021d0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	57                   	push   %edi
801021d4:	56                   	push   %esi
801021d5:	53                   	push   %ebx
801021d6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801021d9:	85 c0                	test   %eax,%eax
801021db:	0f 84 b4 00 00 00    	je     80102295 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801021e1:	8b 70 08             	mov    0x8(%eax),%esi
801021e4:	89 c3                	mov    %eax,%ebx
801021e6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801021ec:	0f 87 96 00 00 00    	ja     80102288 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021f2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021fe:	66 90                	xchg   %ax,%ax
80102200:	89 ca                	mov    %ecx,%edx
80102202:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102203:	83 e0 c0             	and    $0xffffffc0,%eax
80102206:	3c 40                	cmp    $0x40,%al
80102208:	75 f6                	jne    80102200 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010220a:	31 ff                	xor    %edi,%edi
8010220c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102211:	89 f8                	mov    %edi,%eax
80102213:	ee                   	out    %al,(%dx)
80102214:	b8 01 00 00 00       	mov    $0x1,%eax
80102219:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010221e:	ee                   	out    %al,(%dx)
8010221f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102224:	89 f0                	mov    %esi,%eax
80102226:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102227:	89 f0                	mov    %esi,%eax
80102229:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010222e:	c1 f8 08             	sar    $0x8,%eax
80102231:	ee                   	out    %al,(%dx)
80102232:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102237:	89 f8                	mov    %edi,%eax
80102239:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010223a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010223e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102243:	c1 e0 04             	shl    $0x4,%eax
80102246:	83 e0 10             	and    $0x10,%eax
80102249:	83 c8 e0             	or     $0xffffffe0,%eax
8010224c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010224d:	f6 03 04             	testb  $0x4,(%ebx)
80102250:	75 16                	jne    80102268 <idestart+0x98>
80102252:	b8 20 00 00 00       	mov    $0x20,%eax
80102257:	89 ca                	mov    %ecx,%edx
80102259:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010225a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010225d:	5b                   	pop    %ebx
8010225e:	5e                   	pop    %esi
8010225f:	5f                   	pop    %edi
80102260:	5d                   	pop    %ebp
80102261:	c3                   	ret    
80102262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102268:	b8 30 00 00 00       	mov    $0x30,%eax
8010226d:	89 ca                	mov    %ecx,%edx
8010226f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102270:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102275:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102278:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010227d:	fc                   	cld    
8010227e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102280:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102283:	5b                   	pop    %ebx
80102284:	5e                   	pop    %esi
80102285:	5f                   	pop    %edi
80102286:	5d                   	pop    %ebp
80102287:	c3                   	ret    
    panic("incorrect blockno");
80102288:	83 ec 0c             	sub    $0xc,%esp
8010228b:	68 2c 7b 10 80       	push   $0x80107b2c
80102290:	e8 eb e0 ff ff       	call   80100380 <panic>
    panic("idestart");
80102295:	83 ec 0c             	sub    $0xc,%esp
80102298:	68 23 7b 10 80       	push   $0x80107b23
8010229d:	e8 de e0 ff ff       	call   80100380 <panic>
801022a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022b0 <ideinit>:
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022b6:	68 3e 7b 10 80       	push   $0x80107b3e
801022bb:	68 00 26 11 80       	push   $0x80112600
801022c0:	e8 cb 28 00 00       	call   80104b90 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801022c5:	58                   	pop    %eax
801022c6:	a1 84 27 11 80       	mov    0x80112784,%eax
801022cb:	5a                   	pop    %edx
801022cc:	83 e8 01             	sub    $0x1,%eax
801022cf:	50                   	push   %eax
801022d0:	6a 0e                	push   $0xe
801022d2:	e8 99 02 00 00       	call   80102570 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022d7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022da:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022df:	90                   	nop
801022e0:	ec                   	in     (%dx),%al
801022e1:	83 e0 c0             	and    $0xffffffc0,%eax
801022e4:	3c 40                	cmp    $0x40,%al
801022e6:	75 f8                	jne    801022e0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022e8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801022ed:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022f2:	ee                   	out    %al,(%dx)
801022f3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022f8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022fd:	eb 06                	jmp    80102305 <ideinit+0x55>
801022ff:	90                   	nop
  for(i=0; i<1000; i++){
80102300:	83 e9 01             	sub    $0x1,%ecx
80102303:	74 0f                	je     80102314 <ideinit+0x64>
80102305:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102306:	84 c0                	test   %al,%al
80102308:	74 f6                	je     80102300 <ideinit+0x50>
      havedisk1 = 1;
8010230a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102311:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102314:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102319:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010231e:	ee                   	out    %al,(%dx)
}
8010231f:	c9                   	leave  
80102320:	c3                   	ret    
80102321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010232f:	90                   	nop

80102330 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	57                   	push   %edi
80102334:	56                   	push   %esi
80102335:	53                   	push   %ebx
80102336:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102339:	68 00 26 11 80       	push   $0x80112600
8010233e:	e8 1d 2a 00 00       	call   80104d60 <acquire>

  if((b = idequeue) == 0){
80102343:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102349:	83 c4 10             	add    $0x10,%esp
8010234c:	85 db                	test   %ebx,%ebx
8010234e:	74 63                	je     801023b3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102350:	8b 43 58             	mov    0x58(%ebx),%eax
80102353:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102358:	8b 33                	mov    (%ebx),%esi
8010235a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102360:	75 2f                	jne    80102391 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102362:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010236e:	66 90                	xchg   %ax,%ax
80102370:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102371:	89 c1                	mov    %eax,%ecx
80102373:	83 e1 c0             	and    $0xffffffc0,%ecx
80102376:	80 f9 40             	cmp    $0x40,%cl
80102379:	75 f5                	jne    80102370 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010237b:	a8 21                	test   $0x21,%al
8010237d:	75 12                	jne    80102391 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010237f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102382:	b9 80 00 00 00       	mov    $0x80,%ecx
80102387:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010238c:	fc                   	cld    
8010238d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010238f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102391:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102394:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102397:	83 ce 02             	or     $0x2,%esi
8010239a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010239c:	53                   	push   %ebx
8010239d:	e8 ee 1f 00 00       	call   80104390 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801023a2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801023a7:	83 c4 10             	add    $0x10,%esp
801023aa:	85 c0                	test   %eax,%eax
801023ac:	74 05                	je     801023b3 <ideintr+0x83>
    idestart(idequeue);
801023ae:	e8 1d fe ff ff       	call   801021d0 <idestart>
    release(&idelock);
801023b3:	83 ec 0c             	sub    $0xc,%esp
801023b6:	68 00 26 11 80       	push   $0x80112600
801023bb:	e8 40 29 00 00       	call   80104d00 <release>

  release(&idelock);
}
801023c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023c3:	5b                   	pop    %ebx
801023c4:	5e                   	pop    %esi
801023c5:	5f                   	pop    %edi
801023c6:	5d                   	pop    %ebp
801023c7:	c3                   	ret    
801023c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023cf:	90                   	nop

801023d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	53                   	push   %ebx
801023d4:	83 ec 10             	sub    $0x10,%esp
801023d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023da:	8d 43 0c             	lea    0xc(%ebx),%eax
801023dd:	50                   	push   %eax
801023de:	e8 5d 27 00 00       	call   80104b40 <holdingsleep>
801023e3:	83 c4 10             	add    $0x10,%esp
801023e6:	85 c0                	test   %eax,%eax
801023e8:	0f 84 c3 00 00 00    	je     801024b1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023ee:	8b 03                	mov    (%ebx),%eax
801023f0:	83 e0 06             	and    $0x6,%eax
801023f3:	83 f8 02             	cmp    $0x2,%eax
801023f6:	0f 84 a8 00 00 00    	je     801024a4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023fc:	8b 53 04             	mov    0x4(%ebx),%edx
801023ff:	85 d2                	test   %edx,%edx
80102401:	74 0d                	je     80102410 <iderw+0x40>
80102403:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102408:	85 c0                	test   %eax,%eax
8010240a:	0f 84 87 00 00 00    	je     80102497 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102410:	83 ec 0c             	sub    $0xc,%esp
80102413:	68 00 26 11 80       	push   $0x80112600
80102418:	e8 43 29 00 00       	call   80104d60 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010241d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102422:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102429:	83 c4 10             	add    $0x10,%esp
8010242c:	85 c0                	test   %eax,%eax
8010242e:	74 60                	je     80102490 <iderw+0xc0>
80102430:	89 c2                	mov    %eax,%edx
80102432:	8b 40 58             	mov    0x58(%eax),%eax
80102435:	85 c0                	test   %eax,%eax
80102437:	75 f7                	jne    80102430 <iderw+0x60>
80102439:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010243c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010243e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102444:	74 3a                	je     80102480 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102446:	8b 03                	mov    (%ebx),%eax
80102448:	83 e0 06             	and    $0x6,%eax
8010244b:	83 f8 02             	cmp    $0x2,%eax
8010244e:	74 1b                	je     8010246b <iderw+0x9b>
    sleep(b, &idelock);
80102450:	83 ec 08             	sub    $0x8,%esp
80102453:	68 00 26 11 80       	push   $0x80112600
80102458:	53                   	push   %ebx
80102459:	e8 e2 1c 00 00       	call   80104140 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010245e:	8b 03                	mov    (%ebx),%eax
80102460:	83 c4 10             	add    $0x10,%esp
80102463:	83 e0 06             	and    $0x6,%eax
80102466:	83 f8 02             	cmp    $0x2,%eax
80102469:	75 e5                	jne    80102450 <iderw+0x80>
  }


  release(&idelock);
8010246b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102472:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102475:	c9                   	leave  
  release(&idelock);
80102476:	e9 85 28 00 00       	jmp    80104d00 <release>
8010247b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010247f:	90                   	nop
    idestart(b);
80102480:	89 d8                	mov    %ebx,%eax
80102482:	e8 49 fd ff ff       	call   801021d0 <idestart>
80102487:	eb bd                	jmp    80102446 <iderw+0x76>
80102489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102490:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102495:	eb a5                	jmp    8010243c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102497:	83 ec 0c             	sub    $0xc,%esp
8010249a:	68 6d 7b 10 80       	push   $0x80107b6d
8010249f:	e8 dc de ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801024a4:	83 ec 0c             	sub    $0xc,%esp
801024a7:	68 58 7b 10 80       	push   $0x80107b58
801024ac:	e8 cf de ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801024b1:	83 ec 0c             	sub    $0xc,%esp
801024b4:	68 42 7b 10 80       	push   $0x80107b42
801024b9:	e8 c2 de ff ff       	call   80100380 <panic>
801024be:	66 90                	xchg   %ax,%ax

801024c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801024c0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801024c1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801024c8:	00 c0 fe 
{
801024cb:	89 e5                	mov    %esp,%ebp
801024cd:	56                   	push   %esi
801024ce:	53                   	push   %ebx
  ioapic->reg = reg;
801024cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024d6:	00 00 00 
  return ioapic->data;
801024d9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801024df:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801024e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024e8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024ee:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024f5:	c1 ee 10             	shr    $0x10,%esi
801024f8:	89 f0                	mov    %esi,%eax
801024fa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801024fd:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102500:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102503:	39 c2                	cmp    %eax,%edx
80102505:	74 16                	je     8010251d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102507:	83 ec 0c             	sub    $0xc,%esp
8010250a:	68 8c 7b 10 80       	push   $0x80107b8c
8010250f:	e8 8c e1 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102514:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010251a:	83 c4 10             	add    $0x10,%esp
8010251d:	83 c6 21             	add    $0x21,%esi
{
80102520:	ba 10 00 00 00       	mov    $0x10,%edx
80102525:	b8 20 00 00 00       	mov    $0x20,%eax
8010252a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102530:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102532:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102534:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010253a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010253d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102543:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102546:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102549:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010254c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010254e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102554:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010255b:	39 f0                	cmp    %esi,%eax
8010255d:	75 d1                	jne    80102530 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010255f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102562:	5b                   	pop    %ebx
80102563:	5e                   	pop    %esi
80102564:	5d                   	pop    %ebp
80102565:	c3                   	ret    
80102566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010256d:	8d 76 00             	lea    0x0(%esi),%esi

80102570 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102570:	55                   	push   %ebp
  ioapic->reg = reg;
80102571:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102577:	89 e5                	mov    %esp,%ebp
80102579:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010257c:	8d 50 20             	lea    0x20(%eax),%edx
8010257f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102583:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102585:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010258b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010258e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102591:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102594:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102596:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010259b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010259e:	89 50 10             	mov    %edx,0x10(%eax)
}
801025a1:	5d                   	pop    %ebp
801025a2:	c3                   	ret    
801025a3:	66 90                	xchg   %ax,%ax
801025a5:	66 90                	xchg   %ax,%ax
801025a7:	66 90                	xchg   %ax,%ax
801025a9:	66 90                	xchg   %ax,%ax
801025ab:	66 90                	xchg   %ax,%ax
801025ad:	66 90                	xchg   %ax,%ax
801025af:	90                   	nop

801025b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	53                   	push   %ebx
801025b4:	83 ec 04             	sub    $0x4,%esp
801025b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801025ba:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801025c0:	75 76                	jne    80102638 <kfree+0x88>
801025c2:	81 fb d0 61 13 80    	cmp    $0x801361d0,%ebx
801025c8:	72 6e                	jb     80102638 <kfree+0x88>
801025ca:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025d0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801025d5:	77 61                	ja     80102638 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025d7:	83 ec 04             	sub    $0x4,%esp
801025da:	68 00 10 00 00       	push   $0x1000
801025df:	6a 01                	push   $0x1
801025e1:	53                   	push   %ebx
801025e2:	e8 39 28 00 00       	call   80104e20 <memset>

  if(kmem.use_lock)
801025e7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	85 d2                	test   %edx,%edx
801025f2:	75 1c                	jne    80102610 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801025f4:	a1 78 26 11 80       	mov    0x80112678,%eax
801025f9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801025fb:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102600:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102606:	85 c0                	test   %eax,%eax
80102608:	75 1e                	jne    80102628 <kfree+0x78>
    release(&kmem.lock);
}
8010260a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010260d:	c9                   	leave  
8010260e:	c3                   	ret    
8010260f:	90                   	nop
    acquire(&kmem.lock);
80102610:	83 ec 0c             	sub    $0xc,%esp
80102613:	68 40 26 11 80       	push   $0x80112640
80102618:	e8 43 27 00 00       	call   80104d60 <acquire>
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	eb d2                	jmp    801025f4 <kfree+0x44>
80102622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102628:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010262f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102632:	c9                   	leave  
    release(&kmem.lock);
80102633:	e9 c8 26 00 00       	jmp    80104d00 <release>
    panic("kfree");
80102638:	83 ec 0c             	sub    $0xc,%esp
8010263b:	68 be 7b 10 80       	push   $0x80107bbe
80102640:	e8 3b dd ff ff       	call   80100380 <panic>
80102645:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010264c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102650 <freerange>:
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102654:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102657:	8b 75 0c             	mov    0xc(%ebp),%esi
8010265a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010265b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102661:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102667:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010266d:	39 de                	cmp    %ebx,%esi
8010266f:	72 23                	jb     80102694 <freerange+0x44>
80102671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102678:	83 ec 0c             	sub    $0xc,%esp
8010267b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102681:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102687:	50                   	push   %eax
80102688:	e8 23 ff ff ff       	call   801025b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010268d:	83 c4 10             	add    $0x10,%esp
80102690:	39 f3                	cmp    %esi,%ebx
80102692:	76 e4                	jbe    80102678 <freerange+0x28>
}
80102694:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102697:	5b                   	pop    %ebx
80102698:	5e                   	pop    %esi
80102699:	5d                   	pop    %ebp
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop

801026a0 <kinit2>:
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801026a4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026a7:	8b 75 0c             	mov    0xc(%ebp),%esi
801026aa:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026bd:	39 de                	cmp    %ebx,%esi
801026bf:	72 23                	jb     801026e4 <kinit2+0x44>
801026c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026c8:	83 ec 0c             	sub    $0xc,%esp
801026cb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026d7:	50                   	push   %eax
801026d8:	e8 d3 fe ff ff       	call   801025b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026dd:	83 c4 10             	add    $0x10,%esp
801026e0:	39 de                	cmp    %ebx,%esi
801026e2:	73 e4                	jae    801026c8 <kinit2+0x28>
  kmem.use_lock = 1;
801026e4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801026eb:	00 00 00 
}
801026ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026f1:	5b                   	pop    %ebx
801026f2:	5e                   	pop    %esi
801026f3:	5d                   	pop    %ebp
801026f4:	c3                   	ret    
801026f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102700 <kinit1>:
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	56                   	push   %esi
80102704:	53                   	push   %ebx
80102705:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102708:	83 ec 08             	sub    $0x8,%esp
8010270b:	68 c4 7b 10 80       	push   $0x80107bc4
80102710:	68 40 26 11 80       	push   $0x80112640
80102715:	e8 76 24 00 00       	call   80104b90 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010271a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010271d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102720:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102727:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010272a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102730:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102736:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010273c:	39 de                	cmp    %ebx,%esi
8010273e:	72 1c                	jb     8010275c <kinit1+0x5c>
    kfree(p);
80102740:	83 ec 0c             	sub    $0xc,%esp
80102743:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102749:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010274f:	50                   	push   %eax
80102750:	e8 5b fe ff ff       	call   801025b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102755:	83 c4 10             	add    $0x10,%esp
80102758:	39 de                	cmp    %ebx,%esi
8010275a:	73 e4                	jae    80102740 <kinit1+0x40>
}
8010275c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010275f:	5b                   	pop    %ebx
80102760:	5e                   	pop    %esi
80102761:	5d                   	pop    %ebp
80102762:	c3                   	ret    
80102763:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102770 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102770:	a1 74 26 11 80       	mov    0x80112674,%eax
80102775:	85 c0                	test   %eax,%eax
80102777:	75 1f                	jne    80102798 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102779:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010277e:	85 c0                	test   %eax,%eax
80102780:	74 0e                	je     80102790 <kalloc+0x20>
    kmem.freelist = r->next;
80102782:	8b 10                	mov    (%eax),%edx
80102784:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010278a:	c3                   	ret    
8010278b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010278f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102790:	c3                   	ret    
80102791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102798:	55                   	push   %ebp
80102799:	89 e5                	mov    %esp,%ebp
8010279b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010279e:	68 40 26 11 80       	push   $0x80112640
801027a3:	e8 b8 25 00 00       	call   80104d60 <acquire>
  r = kmem.freelist;
801027a8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801027ad:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801027b3:	83 c4 10             	add    $0x10,%esp
801027b6:	85 c0                	test   %eax,%eax
801027b8:	74 08                	je     801027c2 <kalloc+0x52>
    kmem.freelist = r->next;
801027ba:	8b 08                	mov    (%eax),%ecx
801027bc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801027c2:	85 d2                	test   %edx,%edx
801027c4:	74 16                	je     801027dc <kalloc+0x6c>
    release(&kmem.lock);
801027c6:	83 ec 0c             	sub    $0xc,%esp
801027c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027cc:	68 40 26 11 80       	push   $0x80112640
801027d1:	e8 2a 25 00 00       	call   80104d00 <release>
  return (char*)r;
801027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801027d9:	83 c4 10             	add    $0x10,%esp
}
801027dc:	c9                   	leave  
801027dd:	c3                   	ret    
801027de:	66 90                	xchg   %ax,%ax

801027e0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027e0:	ba 64 00 00 00       	mov    $0x64,%edx
801027e5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801027e6:	a8 01                	test   $0x1,%al
801027e8:	0f 84 c2 00 00 00    	je     801028b0 <kbdgetc+0xd0>
{
801027ee:	55                   	push   %ebp
801027ef:	ba 60 00 00 00       	mov    $0x60,%edx
801027f4:	89 e5                	mov    %esp,%ebp
801027f6:	53                   	push   %ebx
801027f7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801027f8:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
801027fe:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102801:	3c e0                	cmp    $0xe0,%al
80102803:	74 5b                	je     80102860 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102805:	89 da                	mov    %ebx,%edx
80102807:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010280a:	84 c0                	test   %al,%al
8010280c:	78 62                	js     80102870 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010280e:	85 d2                	test   %edx,%edx
80102810:	74 09                	je     8010281b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102812:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102815:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102818:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010281b:	0f b6 91 00 7d 10 80 	movzbl -0x7fef8300(%ecx),%edx
  shift ^= togglecode[data];
80102822:	0f b6 81 00 7c 10 80 	movzbl -0x7fef8400(%ecx),%eax
  shift |= shiftcode[data];
80102829:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010282b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010282d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010282f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102835:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102838:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010283b:	8b 04 85 e0 7b 10 80 	mov    -0x7fef8420(,%eax,4),%eax
80102842:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102846:	74 0b                	je     80102853 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102848:	8d 50 9f             	lea    -0x61(%eax),%edx
8010284b:	83 fa 19             	cmp    $0x19,%edx
8010284e:	77 48                	ja     80102898 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102850:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102853:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102856:	c9                   	leave  
80102857:	c3                   	ret    
80102858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010285f:	90                   	nop
    shift |= E0ESC;
80102860:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102863:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102865:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010286b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010286e:	c9                   	leave  
8010286f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102870:	83 e0 7f             	and    $0x7f,%eax
80102873:	85 d2                	test   %edx,%edx
80102875:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102878:	0f b6 81 00 7d 10 80 	movzbl -0x7fef8300(%ecx),%eax
8010287f:	83 c8 40             	or     $0x40,%eax
80102882:	0f b6 c0             	movzbl %al,%eax
80102885:	f7 d0                	not    %eax
80102887:	21 d8                	and    %ebx,%eax
}
80102889:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010288c:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
80102891:	31 c0                	xor    %eax,%eax
}
80102893:	c9                   	leave  
80102894:	c3                   	ret    
80102895:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102898:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010289b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010289e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028a1:	c9                   	leave  
      c += 'a' - 'A';
801028a2:	83 f9 1a             	cmp    $0x1a,%ecx
801028a5:	0f 42 c2             	cmovb  %edx,%eax
}
801028a8:	c3                   	ret    
801028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801028b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028b5:	c3                   	ret    
801028b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028bd:	8d 76 00             	lea    0x0(%esi),%esi

801028c0 <kbdintr>:

void
kbdintr(void)
{
801028c0:	55                   	push   %ebp
801028c1:	89 e5                	mov    %esp,%ebp
801028c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801028c6:	68 e0 27 10 80       	push   $0x801027e0
801028cb:	e8 b0 df ff ff       	call   80100880 <consoleintr>
}
801028d0:	83 c4 10             	add    $0x10,%esp
801028d3:	c9                   	leave  
801028d4:	c3                   	ret    
801028d5:	66 90                	xchg   %ax,%ax
801028d7:	66 90                	xchg   %ax,%ax
801028d9:	66 90                	xchg   %ax,%ax
801028db:	66 90                	xchg   %ax,%ax
801028dd:	66 90                	xchg   %ax,%ax
801028df:	90                   	nop

801028e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801028e0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028e5:	85 c0                	test   %eax,%eax
801028e7:	0f 84 cb 00 00 00    	je     801029b8 <lapicinit+0xd8>
  lapic[index] = value;
801028ed:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801028f4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028fa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102901:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102904:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102907:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010290e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102911:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102914:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010291b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010291e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102921:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102928:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010292b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010292e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102935:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102938:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010293b:	8b 50 30             	mov    0x30(%eax),%edx
8010293e:	c1 ea 10             	shr    $0x10,%edx
80102941:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102947:	75 77                	jne    801029c0 <lapicinit+0xe0>
  lapic[index] = value;
80102949:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102950:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102953:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102956:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010295d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102960:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102963:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010296a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010296d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102970:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102977:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010297a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010297d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102984:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102987:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010298a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102991:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102994:	8b 50 20             	mov    0x20(%eax),%edx
80102997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801029a0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801029a6:	80 e6 10             	and    $0x10,%dh
801029a9:	75 f5                	jne    801029a0 <lapicinit+0xc0>
  lapic[index] = value;
801029ab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801029b2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801029b8:	c3                   	ret    
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801029c0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801029c7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029ca:	8b 50 20             	mov    0x20(%eax),%edx
}
801029cd:	e9 77 ff ff ff       	jmp    80102949 <lapicinit+0x69>
801029d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801029e0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801029e0:	a1 80 26 11 80       	mov    0x80112680,%eax
801029e5:	85 c0                	test   %eax,%eax
801029e7:	74 07                	je     801029f0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801029e9:	8b 40 20             	mov    0x20(%eax),%eax
801029ec:	c1 e8 18             	shr    $0x18,%eax
801029ef:	c3                   	ret    
    return 0;
801029f0:	31 c0                	xor    %eax,%eax
}
801029f2:	c3                   	ret    
801029f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a00 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a00:	a1 80 26 11 80       	mov    0x80112680,%eax
80102a05:	85 c0                	test   %eax,%eax
80102a07:	74 0d                	je     80102a16 <lapiceoi+0x16>
  lapic[index] = value;
80102a09:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a10:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a13:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a16:	c3                   	ret    
80102a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a1e:	66 90                	xchg   %ax,%ax

80102a20 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a20:	c3                   	ret    
80102a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a2f:	90                   	nop

80102a30 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a30:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a31:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a36:	ba 70 00 00 00       	mov    $0x70,%edx
80102a3b:	89 e5                	mov    %esp,%ebp
80102a3d:	53                   	push   %ebx
80102a3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a41:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a44:	ee                   	out    %al,(%dx)
80102a45:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a4a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a4f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a50:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a52:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a55:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a5b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a5d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102a60:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a62:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a65:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a68:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a6e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102a73:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a79:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a7c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a83:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a86:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a89:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a90:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a93:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a96:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a9c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a9f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102aa5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102aa8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102aae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ab1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ab7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102aba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102abd:	c9                   	leave  
80102abe:	c3                   	ret    
80102abf:	90                   	nop

80102ac0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102ac0:	55                   	push   %ebp
80102ac1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ac6:	ba 70 00 00 00       	mov    $0x70,%edx
80102acb:	89 e5                	mov    %esp,%ebp
80102acd:	57                   	push   %edi
80102ace:	56                   	push   %esi
80102acf:	53                   	push   %ebx
80102ad0:	83 ec 4c             	sub    $0x4c,%esp
80102ad3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ad9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102ada:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102add:	bb 70 00 00 00       	mov    $0x70,%ebx
80102ae2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ae5:	8d 76 00             	lea    0x0(%esi),%esi
80102ae8:	31 c0                	xor    %eax,%eax
80102aea:	89 da                	mov    %ebx,%edx
80102aec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aed:	b9 71 00 00 00       	mov    $0x71,%ecx
80102af2:	89 ca                	mov    %ecx,%edx
80102af4:	ec                   	in     (%dx),%al
80102af5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af8:	89 da                	mov    %ebx,%edx
80102afa:	b8 02 00 00 00       	mov    $0x2,%eax
80102aff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b00:	89 ca                	mov    %ecx,%edx
80102b02:	ec                   	in     (%dx),%al
80102b03:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b06:	89 da                	mov    %ebx,%edx
80102b08:	b8 04 00 00 00       	mov    $0x4,%eax
80102b0d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0e:	89 ca                	mov    %ecx,%edx
80102b10:	ec                   	in     (%dx),%al
80102b11:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b14:	89 da                	mov    %ebx,%edx
80102b16:	b8 07 00 00 00       	mov    $0x7,%eax
80102b1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1c:	89 ca                	mov    %ecx,%edx
80102b1e:	ec                   	in     (%dx),%al
80102b1f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b22:	89 da                	mov    %ebx,%edx
80102b24:	b8 08 00 00 00       	mov    $0x8,%eax
80102b29:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2a:	89 ca                	mov    %ecx,%edx
80102b2c:	ec                   	in     (%dx),%al
80102b2d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b2f:	89 da                	mov    %ebx,%edx
80102b31:	b8 09 00 00 00       	mov    $0x9,%eax
80102b36:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b37:	89 ca                	mov    %ecx,%edx
80102b39:	ec                   	in     (%dx),%al
80102b3a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b3c:	89 da                	mov    %ebx,%edx
80102b3e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b44:	89 ca                	mov    %ecx,%edx
80102b46:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b47:	84 c0                	test   %al,%al
80102b49:	78 9d                	js     80102ae8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b4b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b4f:	89 fa                	mov    %edi,%edx
80102b51:	0f b6 fa             	movzbl %dl,%edi
80102b54:	89 f2                	mov    %esi,%edx
80102b56:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b59:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b5d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b60:	89 da                	mov    %ebx,%edx
80102b62:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102b65:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b68:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b6c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102b6f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b72:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b76:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b79:	31 c0                	xor    %eax,%eax
80102b7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b7c:	89 ca                	mov    %ecx,%edx
80102b7e:	ec                   	in     (%dx),%al
80102b7f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b82:	89 da                	mov    %ebx,%edx
80102b84:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b87:	b8 02 00 00 00       	mov    $0x2,%eax
80102b8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b8d:	89 ca                	mov    %ecx,%edx
80102b8f:	ec                   	in     (%dx),%al
80102b90:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b93:	89 da                	mov    %ebx,%edx
80102b95:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b98:	b8 04 00 00 00       	mov    $0x4,%eax
80102b9d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9e:	89 ca                	mov    %ecx,%edx
80102ba0:	ec                   	in     (%dx),%al
80102ba1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba4:	89 da                	mov    %ebx,%edx
80102ba6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ba9:	b8 07 00 00 00       	mov    $0x7,%eax
80102bae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102baf:	89 ca                	mov    %ecx,%edx
80102bb1:	ec                   	in     (%dx),%al
80102bb2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb5:	89 da                	mov    %ebx,%edx
80102bb7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102bba:	b8 08 00 00 00       	mov    $0x8,%eax
80102bbf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc0:	89 ca                	mov    %ecx,%edx
80102bc2:	ec                   	in     (%dx),%al
80102bc3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc6:	89 da                	mov    %ebx,%edx
80102bc8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102bcb:	b8 09 00 00 00       	mov    $0x9,%eax
80102bd0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bd1:	89 ca                	mov    %ecx,%edx
80102bd3:	ec                   	in     (%dx),%al
80102bd4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bd7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102bda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bdd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102be0:	6a 18                	push   $0x18
80102be2:	50                   	push   %eax
80102be3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102be6:	50                   	push   %eax
80102be7:	e8 84 22 00 00       	call   80104e70 <memcmp>
80102bec:	83 c4 10             	add    $0x10,%esp
80102bef:	85 c0                	test   %eax,%eax
80102bf1:	0f 85 f1 fe ff ff    	jne    80102ae8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102bf7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102bfb:	75 78                	jne    80102c75 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102bfd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c00:	89 c2                	mov    %eax,%edx
80102c02:	83 e0 0f             	and    $0xf,%eax
80102c05:	c1 ea 04             	shr    $0x4,%edx
80102c08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c0e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c11:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c14:	89 c2                	mov    %eax,%edx
80102c16:	83 e0 0f             	and    $0xf,%eax
80102c19:	c1 ea 04             	shr    $0x4,%edx
80102c1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c22:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c25:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c28:	89 c2                	mov    %eax,%edx
80102c2a:	83 e0 0f             	and    $0xf,%eax
80102c2d:	c1 ea 04             	shr    $0x4,%edx
80102c30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c36:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c3c:	89 c2                	mov    %eax,%edx
80102c3e:	83 e0 0f             	and    $0xf,%eax
80102c41:	c1 ea 04             	shr    $0x4,%edx
80102c44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c4a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c4d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c50:	89 c2                	mov    %eax,%edx
80102c52:	83 e0 0f             	and    $0xf,%eax
80102c55:	c1 ea 04             	shr    $0x4,%edx
80102c58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c61:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c64:	89 c2                	mov    %eax,%edx
80102c66:	83 e0 0f             	and    $0xf,%eax
80102c69:	c1 ea 04             	shr    $0x4,%edx
80102c6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c72:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c75:	8b 75 08             	mov    0x8(%ebp),%esi
80102c78:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c7b:	89 06                	mov    %eax,(%esi)
80102c7d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c80:	89 46 04             	mov    %eax,0x4(%esi)
80102c83:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c86:	89 46 08             	mov    %eax,0x8(%esi)
80102c89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c8c:	89 46 0c             	mov    %eax,0xc(%esi)
80102c8f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c92:	89 46 10             	mov    %eax,0x10(%esi)
80102c95:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c98:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c9b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ca2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ca5:	5b                   	pop    %ebx
80102ca6:	5e                   	pop    %esi
80102ca7:	5f                   	pop    %edi
80102ca8:	5d                   	pop    %ebp
80102ca9:	c3                   	ret    
80102caa:	66 90                	xchg   %ax,%ax
80102cac:	66 90                	xchg   %ax,%ax
80102cae:	66 90                	xchg   %ax,%ax

80102cb0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cb0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102cb6:	85 c9                	test   %ecx,%ecx
80102cb8:	0f 8e 8a 00 00 00    	jle    80102d48 <install_trans+0x98>
{
80102cbe:	55                   	push   %ebp
80102cbf:	89 e5                	mov    %esp,%ebp
80102cc1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102cc2:	31 ff                	xor    %edi,%edi
{
80102cc4:	56                   	push   %esi
80102cc5:	53                   	push   %ebx
80102cc6:	83 ec 0c             	sub    $0xc,%esp
80102cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102cd0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102cd5:	83 ec 08             	sub    $0x8,%esp
80102cd8:	01 f8                	add    %edi,%eax
80102cda:	83 c0 01             	add    $0x1,%eax
80102cdd:	50                   	push   %eax
80102cde:	ff 35 e4 26 11 80    	push   0x801126e4
80102ce4:	e8 e7 d3 ff ff       	call   801000d0 <bread>
80102ce9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ceb:	58                   	pop    %eax
80102cec:	5a                   	pop    %edx
80102ced:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102cf4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cfa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cfd:	e8 ce d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d02:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d05:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d07:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d0a:	68 00 02 00 00       	push   $0x200
80102d0f:	50                   	push   %eax
80102d10:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102d13:	50                   	push   %eax
80102d14:	e8 a7 21 00 00       	call   80104ec0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d19:	89 1c 24             	mov    %ebx,(%esp)
80102d1c:	e8 8f d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102d21:	89 34 24             	mov    %esi,(%esp)
80102d24:	e8 c7 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102d29:	89 1c 24             	mov    %ebx,(%esp)
80102d2c:	e8 bf d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d31:	83 c4 10             	add    $0x10,%esp
80102d34:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102d3a:	7f 94                	jg     80102cd0 <install_trans+0x20>
  }
}
80102d3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d3f:	5b                   	pop    %ebx
80102d40:	5e                   	pop    %esi
80102d41:	5f                   	pop    %edi
80102d42:	5d                   	pop    %ebp
80102d43:	c3                   	ret    
80102d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d48:	c3                   	ret    
80102d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d50:	55                   	push   %ebp
80102d51:	89 e5                	mov    %esp,%ebp
80102d53:	53                   	push   %ebx
80102d54:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d57:	ff 35 d4 26 11 80    	push   0x801126d4
80102d5d:	ff 35 e4 26 11 80    	push   0x801126e4
80102d63:	e8 68 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d68:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d6b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d6d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102d72:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d75:	85 c0                	test   %eax,%eax
80102d77:	7e 19                	jle    80102d92 <write_head+0x42>
80102d79:	31 d2                	xor    %edx,%edx
80102d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d7f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102d80:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102d87:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d8b:	83 c2 01             	add    $0x1,%edx
80102d8e:	39 d0                	cmp    %edx,%eax
80102d90:	75 ee                	jne    80102d80 <write_head+0x30>
  }
  bwrite(buf);
80102d92:	83 ec 0c             	sub    $0xc,%esp
80102d95:	53                   	push   %ebx
80102d96:	e8 15 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d9b:	89 1c 24             	mov    %ebx,(%esp)
80102d9e:	e8 4d d4 ff ff       	call   801001f0 <brelse>
}
80102da3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102da6:	83 c4 10             	add    $0x10,%esp
80102da9:	c9                   	leave  
80102daa:	c3                   	ret    
80102dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102daf:	90                   	nop

80102db0 <initlog>:
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	53                   	push   %ebx
80102db4:	83 ec 2c             	sub    $0x2c,%esp
80102db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102dba:	68 00 7e 10 80       	push   $0x80107e00
80102dbf:	68 a0 26 11 80       	push   $0x801126a0
80102dc4:	e8 c7 1d 00 00       	call   80104b90 <initlock>
  readsb(dev, &sb);
80102dc9:	58                   	pop    %eax
80102dca:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102dcd:	5a                   	pop    %edx
80102dce:	50                   	push   %eax
80102dcf:	53                   	push   %ebx
80102dd0:	e8 3b e8 ff ff       	call   80101610 <readsb>
  log.start = sb.logstart;
80102dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102dd8:	59                   	pop    %ecx
  log.dev = dev;
80102dd9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102ddf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102de2:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102de7:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102ded:	5a                   	pop    %edx
80102dee:	50                   	push   %eax
80102def:	53                   	push   %ebx
80102df0:	e8 db d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102df5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102df8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102dfb:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102e01:	85 db                	test   %ebx,%ebx
80102e03:	7e 1d                	jle    80102e22 <initlog+0x72>
80102e05:	31 d2                	xor    %edx,%edx
80102e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e0e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102e10:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102e14:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e1b:	83 c2 01             	add    $0x1,%edx
80102e1e:	39 d3                	cmp    %edx,%ebx
80102e20:	75 ee                	jne    80102e10 <initlog+0x60>
  brelse(buf);
80102e22:	83 ec 0c             	sub    $0xc,%esp
80102e25:	50                   	push   %eax
80102e26:	e8 c5 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e2b:	e8 80 fe ff ff       	call   80102cb0 <install_trans>
  log.lh.n = 0;
80102e30:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102e37:	00 00 00 
  write_head(); // clear the log
80102e3a:	e8 11 ff ff ff       	call   80102d50 <write_head>
}
80102e3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e42:	83 c4 10             	add    $0x10,%esp
80102e45:	c9                   	leave  
80102e46:	c3                   	ret    
80102e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e4e:	66 90                	xchg   %ax,%ax

80102e50 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e56:	68 a0 26 11 80       	push   $0x801126a0
80102e5b:	e8 00 1f 00 00       	call   80104d60 <acquire>
80102e60:	83 c4 10             	add    $0x10,%esp
80102e63:	eb 18                	jmp    80102e7d <begin_op+0x2d>
80102e65:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e68:	83 ec 08             	sub    $0x8,%esp
80102e6b:	68 a0 26 11 80       	push   $0x801126a0
80102e70:	68 a0 26 11 80       	push   $0x801126a0
80102e75:	e8 c6 12 00 00       	call   80104140 <sleep>
80102e7a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e7d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102e82:	85 c0                	test   %eax,%eax
80102e84:	75 e2                	jne    80102e68 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e86:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102e8b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102e91:	83 c0 01             	add    $0x1,%eax
80102e94:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e97:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e9a:	83 fa 1e             	cmp    $0x1e,%edx
80102e9d:	7f c9                	jg     80102e68 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e9f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ea2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102ea7:	68 a0 26 11 80       	push   $0x801126a0
80102eac:	e8 4f 1e 00 00       	call   80104d00 <release>
      break;
    }
  }
}
80102eb1:	83 c4 10             	add    $0x10,%esp
80102eb4:	c9                   	leave  
80102eb5:	c3                   	ret    
80102eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ebd:	8d 76 00             	lea    0x0(%esi),%esi

80102ec0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	57                   	push   %edi
80102ec4:	56                   	push   %esi
80102ec5:	53                   	push   %ebx
80102ec6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ec9:	68 a0 26 11 80       	push   $0x801126a0
80102ece:	e8 8d 1e 00 00       	call   80104d60 <acquire>
  log.outstanding -= 1;
80102ed3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102ed8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102ede:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ee1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102ee4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102eea:	85 f6                	test   %esi,%esi
80102eec:	0f 85 22 01 00 00    	jne    80103014 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102ef2:	85 db                	test   %ebx,%ebx
80102ef4:	0f 85 f6 00 00 00    	jne    80102ff0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102efa:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102f01:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f04:	83 ec 0c             	sub    $0xc,%esp
80102f07:	68 a0 26 11 80       	push   $0x801126a0
80102f0c:	e8 ef 1d 00 00       	call   80104d00 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f11:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102f17:	83 c4 10             	add    $0x10,%esp
80102f1a:	85 c9                	test   %ecx,%ecx
80102f1c:	7f 42                	jg     80102f60 <end_op+0xa0>
    acquire(&log.lock);
80102f1e:	83 ec 0c             	sub    $0xc,%esp
80102f21:	68 a0 26 11 80       	push   $0x801126a0
80102f26:	e8 35 1e 00 00       	call   80104d60 <acquire>
    wakeup(&log);
80102f2b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102f32:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102f39:	00 00 00 
    wakeup(&log);
80102f3c:	e8 4f 14 00 00       	call   80104390 <wakeup>
    release(&log.lock);
80102f41:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f48:	e8 b3 1d 00 00       	call   80104d00 <release>
80102f4d:	83 c4 10             	add    $0x10,%esp
}
80102f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f53:	5b                   	pop    %ebx
80102f54:	5e                   	pop    %esi
80102f55:	5f                   	pop    %edi
80102f56:	5d                   	pop    %ebp
80102f57:	c3                   	ret    
80102f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f5f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f60:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102f65:	83 ec 08             	sub    $0x8,%esp
80102f68:	01 d8                	add    %ebx,%eax
80102f6a:	83 c0 01             	add    $0x1,%eax
80102f6d:	50                   	push   %eax
80102f6e:	ff 35 e4 26 11 80    	push   0x801126e4
80102f74:	e8 57 d1 ff ff       	call   801000d0 <bread>
80102f79:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f7b:	58                   	pop    %eax
80102f7c:	5a                   	pop    %edx
80102f7d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102f84:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f8a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f8d:	e8 3e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f92:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f95:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f97:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f9a:	68 00 02 00 00       	push   $0x200
80102f9f:	50                   	push   %eax
80102fa0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102fa3:	50                   	push   %eax
80102fa4:	e8 17 1f 00 00       	call   80104ec0 <memmove>
    bwrite(to);  // write the log
80102fa9:	89 34 24             	mov    %esi,(%esp)
80102fac:	e8 ff d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102fb1:	89 3c 24             	mov    %edi,(%esp)
80102fb4:	e8 37 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102fb9:	89 34 24             	mov    %esi,(%esp)
80102fbc:	e8 2f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102fc1:	83 c4 10             	add    $0x10,%esp
80102fc4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102fca:	7c 94                	jl     80102f60 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102fcc:	e8 7f fd ff ff       	call   80102d50 <write_head>
    install_trans(); // Now install writes to home locations
80102fd1:	e8 da fc ff ff       	call   80102cb0 <install_trans>
    log.lh.n = 0;
80102fd6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102fdd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102fe0:	e8 6b fd ff ff       	call   80102d50 <write_head>
80102fe5:	e9 34 ff ff ff       	jmp    80102f1e <end_op+0x5e>
80102fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ff0:	83 ec 0c             	sub    $0xc,%esp
80102ff3:	68 a0 26 11 80       	push   $0x801126a0
80102ff8:	e8 93 13 00 00       	call   80104390 <wakeup>
  release(&log.lock);
80102ffd:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80103004:	e8 f7 1c 00 00       	call   80104d00 <release>
80103009:	83 c4 10             	add    $0x10,%esp
}
8010300c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010300f:	5b                   	pop    %ebx
80103010:	5e                   	pop    %esi
80103011:	5f                   	pop    %edi
80103012:	5d                   	pop    %ebp
80103013:	c3                   	ret    
    panic("log.committing");
80103014:	83 ec 0c             	sub    $0xc,%esp
80103017:	68 04 7e 10 80       	push   $0x80107e04
8010301c:	e8 5f d3 ff ff       	call   80100380 <panic>
80103021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103028:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010302f:	90                   	nop

80103030 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	53                   	push   %ebx
80103034:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103037:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
8010303d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103040:	83 fa 1d             	cmp    $0x1d,%edx
80103043:	0f 8f 85 00 00 00    	jg     801030ce <log_write+0x9e>
80103049:	a1 d8 26 11 80       	mov    0x801126d8,%eax
8010304e:	83 e8 01             	sub    $0x1,%eax
80103051:	39 c2                	cmp    %eax,%edx
80103053:	7d 79                	jge    801030ce <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103055:	a1 dc 26 11 80       	mov    0x801126dc,%eax
8010305a:	85 c0                	test   %eax,%eax
8010305c:	7e 7d                	jle    801030db <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010305e:	83 ec 0c             	sub    $0xc,%esp
80103061:	68 a0 26 11 80       	push   $0x801126a0
80103066:	e8 f5 1c 00 00       	call   80104d60 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010306b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80103071:	83 c4 10             	add    $0x10,%esp
80103074:	85 d2                	test   %edx,%edx
80103076:	7e 4a                	jle    801030c2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103078:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010307b:	31 c0                	xor    %eax,%eax
8010307d:	eb 08                	jmp    80103087 <log_write+0x57>
8010307f:	90                   	nop
80103080:	83 c0 01             	add    $0x1,%eax
80103083:	39 c2                	cmp    %eax,%edx
80103085:	74 29                	je     801030b0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103087:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
8010308e:	75 f0                	jne    80103080 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103090:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103097:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010309a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010309d:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
801030a4:	c9                   	leave  
  release(&log.lock);
801030a5:	e9 56 1c 00 00       	jmp    80104d00 <release>
801030aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801030b0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
801030b7:	83 c2 01             	add    $0x1,%edx
801030ba:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
801030c0:	eb d5                	jmp    80103097 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801030c2:	8b 43 08             	mov    0x8(%ebx),%eax
801030c5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
801030ca:	75 cb                	jne    80103097 <log_write+0x67>
801030cc:	eb e9                	jmp    801030b7 <log_write+0x87>
    panic("too big a transaction");
801030ce:	83 ec 0c             	sub    $0xc,%esp
801030d1:	68 13 7e 10 80       	push   $0x80107e13
801030d6:	e8 a5 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801030db:	83 ec 0c             	sub    $0xc,%esp
801030de:	68 29 7e 10 80       	push   $0x80107e29
801030e3:	e8 98 d2 ff ff       	call   80100380 <panic>
801030e8:	66 90                	xchg   %ax,%ax
801030ea:	66 90                	xchg   %ax,%ax
801030ec:	66 90                	xchg   %ax,%ax
801030ee:	66 90                	xchg   %ax,%ax

801030f0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	53                   	push   %ebx
801030f4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801030f7:	e8 04 0a 00 00       	call   80103b00 <cpuid>
801030fc:	89 c3                	mov    %eax,%ebx
801030fe:	e8 fd 09 00 00       	call   80103b00 <cpuid>
80103103:	83 ec 04             	sub    $0x4,%esp
80103106:	53                   	push   %ebx
80103107:	50                   	push   %eax
80103108:	68 44 7e 10 80       	push   $0x80107e44
8010310d:	e8 8e d5 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103112:	e8 59 2f 00 00       	call   80106070 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103117:	e8 84 09 00 00       	call   80103aa0 <mycpu>
8010311c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010311e:	b8 01 00 00 00       	mov    $0x1,%eax
80103123:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010312a:	e8 d1 0c 00 00       	call   80103e00 <scheduler>
8010312f:	90                   	nop

80103130 <mpenter>:
{
80103130:	55                   	push   %ebp
80103131:	89 e5                	mov    %esp,%ebp
80103133:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103136:	e8 35 40 00 00       	call   80107170 <switchkvm>
  seginit();
8010313b:	e8 a0 3f 00 00       	call   801070e0 <seginit>
  lapicinit();
80103140:	e8 9b f7 ff ff       	call   801028e0 <lapicinit>
  mpmain();
80103145:	e8 a6 ff ff ff       	call   801030f0 <mpmain>
8010314a:	66 90                	xchg   %ax,%ax
8010314c:	66 90                	xchg   %ax,%ax
8010314e:	66 90                	xchg   %ax,%ax

80103150 <main>:
{
80103150:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103154:	83 e4 f0             	and    $0xfffffff0,%esp
80103157:	ff 71 fc             	push   -0x4(%ecx)
8010315a:	55                   	push   %ebp
8010315b:	89 e5                	mov    %esp,%ebp
8010315d:	53                   	push   %ebx
8010315e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010315f:	83 ec 08             	sub    $0x8,%esp
80103162:	68 00 00 40 80       	push   $0x80400000
80103167:	68 d0 61 13 80       	push   $0x801361d0
8010316c:	e8 8f f5 ff ff       	call   80102700 <kinit1>
  kvmalloc();      // kernel page table
80103171:	e8 ea 44 00 00       	call   80107660 <kvmalloc>
  mpinit();        // detect other processors
80103176:	e8 85 01 00 00       	call   80103300 <mpinit>
  lapicinit();     // interrupt controller
8010317b:	e8 60 f7 ff ff       	call   801028e0 <lapicinit>
  seginit();       // segment descriptors
80103180:	e8 5b 3f 00 00       	call   801070e0 <seginit>
  picinit();       // disable pic
80103185:	e8 76 03 00 00       	call   80103500 <picinit>
  ioapicinit();    // another interrupt controller
8010318a:	e8 31 f3 ff ff       	call   801024c0 <ioapicinit>
  consoleinit();   // console hardware
8010318f:	e8 cc d8 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103194:	e8 d7 31 00 00       	call   80106370 <uartinit>
  pinit();         // process table
80103199:	e8 e2 08 00 00       	call   80103a80 <pinit>
  tvinit();        // trap vectors
8010319e:	e8 4d 2e 00 00       	call   80105ff0 <tvinit>
  binit();         // buffer cache
801031a3:	e8 98 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
801031a8:	e8 53 dd ff ff       	call   80100f00 <fileinit>
  ideinit();       // disk 
801031ad:	e8 fe f0 ff ff       	call   801022b0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801031b2:	83 c4 0c             	add    $0xc,%esp
801031b5:	68 8a 00 00 00       	push   $0x8a
801031ba:	68 8c b4 10 80       	push   $0x8010b48c
801031bf:	68 00 70 00 80       	push   $0x80007000
801031c4:	e8 f7 1c 00 00       	call   80104ec0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801031d3:	00 00 00 
801031d6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801031db:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801031e0:	76 7e                	jbe    80103260 <main+0x110>
801031e2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801031e7:	eb 20                	jmp    80103209 <main+0xb9>
801031e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031f0:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801031f7:	00 00 00 
801031fa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103200:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103205:	39 c3                	cmp    %eax,%ebx
80103207:	73 57                	jae    80103260 <main+0x110>
    if(c == mycpu())  // We've started already.
80103209:	e8 92 08 00 00       	call   80103aa0 <mycpu>
8010320e:	39 c3                	cmp    %eax,%ebx
80103210:	74 de                	je     801031f0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103212:	e8 59 f5 ff ff       	call   80102770 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103217:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010321a:	c7 05 f8 6f 00 80 30 	movl   $0x80103130,0x80006ff8
80103221:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103224:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010322b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010322e:	05 00 10 00 00       	add    $0x1000,%eax
80103233:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103238:	0f b6 03             	movzbl (%ebx),%eax
8010323b:	68 00 70 00 00       	push   $0x7000
80103240:	50                   	push   %eax
80103241:	e8 ea f7 ff ff       	call   80102a30 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103246:	83 c4 10             	add    $0x10,%esp
80103249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103250:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103256:	85 c0                	test   %eax,%eax
80103258:	74 f6                	je     80103250 <main+0x100>
8010325a:	eb 94                	jmp    801031f0 <main+0xa0>
8010325c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103260:	83 ec 08             	sub    $0x8,%esp
80103263:	68 00 00 00 8e       	push   $0x8e000000
80103268:	68 00 00 40 80       	push   $0x80400000
8010326d:	e8 2e f4 ff ff       	call   801026a0 <kinit2>
  userinit();      // first user process
80103272:	e8 d9 08 00 00       	call   80103b50 <userinit>
  mpmain();        // finish this processor's setup
80103277:	e8 74 fe ff ff       	call   801030f0 <mpmain>
8010327c:	66 90                	xchg   %ax,%ax
8010327e:	66 90                	xchg   %ax,%ax

80103280 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	57                   	push   %edi
80103284:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103285:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010328b:	53                   	push   %ebx
  e = addr+len;
8010328c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010328f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103292:	39 de                	cmp    %ebx,%esi
80103294:	72 10                	jb     801032a6 <mpsearch1+0x26>
80103296:	eb 50                	jmp    801032e8 <mpsearch1+0x68>
80103298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010329f:	90                   	nop
801032a0:	89 fe                	mov    %edi,%esi
801032a2:	39 fb                	cmp    %edi,%ebx
801032a4:	76 42                	jbe    801032e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032a6:	83 ec 04             	sub    $0x4,%esp
801032a9:	8d 7e 10             	lea    0x10(%esi),%edi
801032ac:	6a 04                	push   $0x4
801032ae:	68 58 7e 10 80       	push   $0x80107e58
801032b3:	56                   	push   %esi
801032b4:	e8 b7 1b 00 00       	call   80104e70 <memcmp>
801032b9:	83 c4 10             	add    $0x10,%esp
801032bc:	85 c0                	test   %eax,%eax
801032be:	75 e0                	jne    801032a0 <mpsearch1+0x20>
801032c0:	89 f2                	mov    %esi,%edx
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801032c8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801032cb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801032ce:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801032d0:	39 fa                	cmp    %edi,%edx
801032d2:	75 f4                	jne    801032c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032d4:	84 c0                	test   %al,%al
801032d6:	75 c8                	jne    801032a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801032d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032db:	89 f0                	mov    %esi,%eax
801032dd:	5b                   	pop    %ebx
801032de:	5e                   	pop    %esi
801032df:	5f                   	pop    %edi
801032e0:	5d                   	pop    %ebp
801032e1:	c3                   	ret    
801032e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801032eb:	31 f6                	xor    %esi,%esi
}
801032ed:	5b                   	pop    %ebx
801032ee:	89 f0                	mov    %esi,%eax
801032f0:	5e                   	pop    %esi
801032f1:	5f                   	pop    %edi
801032f2:	5d                   	pop    %ebp
801032f3:	c3                   	ret    
801032f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ff:	90                   	nop

80103300 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	57                   	push   %edi
80103304:	56                   	push   %esi
80103305:	53                   	push   %ebx
80103306:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103309:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103310:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103317:	c1 e0 08             	shl    $0x8,%eax
8010331a:	09 d0                	or     %edx,%eax
8010331c:	c1 e0 04             	shl    $0x4,%eax
8010331f:	75 1b                	jne    8010333c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103321:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103328:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010332f:	c1 e0 08             	shl    $0x8,%eax
80103332:	09 d0                	or     %edx,%eax
80103334:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103337:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010333c:	ba 00 04 00 00       	mov    $0x400,%edx
80103341:	e8 3a ff ff ff       	call   80103280 <mpsearch1>
80103346:	89 c3                	mov    %eax,%ebx
80103348:	85 c0                	test   %eax,%eax
8010334a:	0f 84 40 01 00 00    	je     80103490 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103350:	8b 73 04             	mov    0x4(%ebx),%esi
80103353:	85 f6                	test   %esi,%esi
80103355:	0f 84 25 01 00 00    	je     80103480 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010335b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010335e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103364:	6a 04                	push   $0x4
80103366:	68 5d 7e 10 80       	push   $0x80107e5d
8010336b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010336c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010336f:	e8 fc 1a 00 00       	call   80104e70 <memcmp>
80103374:	83 c4 10             	add    $0x10,%esp
80103377:	85 c0                	test   %eax,%eax
80103379:	0f 85 01 01 00 00    	jne    80103480 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010337f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103386:	3c 01                	cmp    $0x1,%al
80103388:	74 08                	je     80103392 <mpinit+0x92>
8010338a:	3c 04                	cmp    $0x4,%al
8010338c:	0f 85 ee 00 00 00    	jne    80103480 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103392:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103399:	66 85 d2             	test   %dx,%dx
8010339c:	74 22                	je     801033c0 <mpinit+0xc0>
8010339e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801033a1:	89 f0                	mov    %esi,%eax
  sum = 0;
801033a3:	31 d2                	xor    %edx,%edx
801033a5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033a8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801033af:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801033b2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033b4:	39 c7                	cmp    %eax,%edi
801033b6:	75 f0                	jne    801033a8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801033b8:	84 d2                	test   %dl,%dl
801033ba:	0f 85 c0 00 00 00    	jne    80103480 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801033c0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801033c6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033cb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801033d2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801033d8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033dd:	03 55 e4             	add    -0x1c(%ebp),%edx
801033e0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801033e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033e7:	90                   	nop
801033e8:	39 d0                	cmp    %edx,%eax
801033ea:	73 15                	jae    80103401 <mpinit+0x101>
    switch(*p){
801033ec:	0f b6 08             	movzbl (%eax),%ecx
801033ef:	80 f9 02             	cmp    $0x2,%cl
801033f2:	74 4c                	je     80103440 <mpinit+0x140>
801033f4:	77 3a                	ja     80103430 <mpinit+0x130>
801033f6:	84 c9                	test   %cl,%cl
801033f8:	74 56                	je     80103450 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801033fa:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033fd:	39 d0                	cmp    %edx,%eax
801033ff:	72 eb                	jb     801033ec <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103401:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103404:	85 f6                	test   %esi,%esi
80103406:	0f 84 d9 00 00 00    	je     801034e5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010340c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103410:	74 15                	je     80103427 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103412:	b8 70 00 00 00       	mov    $0x70,%eax
80103417:	ba 22 00 00 00       	mov    $0x22,%edx
8010341c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010341d:	ba 23 00 00 00       	mov    $0x23,%edx
80103422:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103423:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103426:	ee                   	out    %al,(%dx)
  }
}
80103427:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010342a:	5b                   	pop    %ebx
8010342b:	5e                   	pop    %esi
8010342c:	5f                   	pop    %edi
8010342d:	5d                   	pop    %ebp
8010342e:	c3                   	ret    
8010342f:	90                   	nop
    switch(*p){
80103430:	83 e9 03             	sub    $0x3,%ecx
80103433:	80 f9 01             	cmp    $0x1,%cl
80103436:	76 c2                	jbe    801033fa <mpinit+0xfa>
80103438:	31 f6                	xor    %esi,%esi
8010343a:	eb ac                	jmp    801033e8 <mpinit+0xe8>
8010343c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103440:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103444:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103447:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010344d:	eb 99                	jmp    801033e8 <mpinit+0xe8>
8010344f:	90                   	nop
      if(ncpu < NCPU) {
80103450:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103456:	83 f9 07             	cmp    $0x7,%ecx
80103459:	7f 19                	jg     80103474 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010345b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103461:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103465:	83 c1 01             	add    $0x1,%ecx
80103468:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010346e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103474:	83 c0 14             	add    $0x14,%eax
      continue;
80103477:	e9 6c ff ff ff       	jmp    801033e8 <mpinit+0xe8>
8010347c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103480:	83 ec 0c             	sub    $0xc,%esp
80103483:	68 62 7e 10 80       	push   $0x80107e62
80103488:	e8 f3 ce ff ff       	call   80100380 <panic>
8010348d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103490:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103495:	eb 13                	jmp    801034aa <mpinit+0x1aa>
80103497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010349e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801034a0:	89 f3                	mov    %esi,%ebx
801034a2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801034a8:	74 d6                	je     80103480 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034aa:	83 ec 04             	sub    $0x4,%esp
801034ad:	8d 73 10             	lea    0x10(%ebx),%esi
801034b0:	6a 04                	push   $0x4
801034b2:	68 58 7e 10 80       	push   $0x80107e58
801034b7:	53                   	push   %ebx
801034b8:	e8 b3 19 00 00       	call   80104e70 <memcmp>
801034bd:	83 c4 10             	add    $0x10,%esp
801034c0:	85 c0                	test   %eax,%eax
801034c2:	75 dc                	jne    801034a0 <mpinit+0x1a0>
801034c4:	89 da                	mov    %ebx,%edx
801034c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034cd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801034d0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801034d3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801034d6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801034d8:	39 d6                	cmp    %edx,%esi
801034da:	75 f4                	jne    801034d0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034dc:	84 c0                	test   %al,%al
801034de:	75 c0                	jne    801034a0 <mpinit+0x1a0>
801034e0:	e9 6b fe ff ff       	jmp    80103350 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801034e5:	83 ec 0c             	sub    $0xc,%esp
801034e8:	68 7c 7e 10 80       	push   $0x80107e7c
801034ed:	e8 8e ce ff ff       	call   80100380 <panic>
801034f2:	66 90                	xchg   %ax,%ax
801034f4:	66 90                	xchg   %ax,%ax
801034f6:	66 90                	xchg   %ax,%ax
801034f8:	66 90                	xchg   %ax,%ax
801034fa:	66 90                	xchg   %ax,%ax
801034fc:	66 90                	xchg   %ax,%ax
801034fe:	66 90                	xchg   %ax,%ax

80103500 <picinit>:
80103500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103505:	ba 21 00 00 00       	mov    $0x21,%edx
8010350a:	ee                   	out    %al,(%dx)
8010350b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103510:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103511:	c3                   	ret    
80103512:	66 90                	xchg   %ax,%ax
80103514:	66 90                	xchg   %ax,%ax
80103516:	66 90                	xchg   %ax,%ax
80103518:	66 90                	xchg   %ax,%ax
8010351a:	66 90                	xchg   %ax,%ax
8010351c:	66 90                	xchg   %ax,%ax
8010351e:	66 90                	xchg   %ax,%ax

80103520 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103520:	55                   	push   %ebp
80103521:	89 e5                	mov    %esp,%ebp
80103523:	57                   	push   %edi
80103524:	56                   	push   %esi
80103525:	53                   	push   %ebx
80103526:	83 ec 0c             	sub    $0xc,%esp
80103529:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010352c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010352f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103535:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010353b:	e8 e0 d9 ff ff       	call   80100f20 <filealloc>
80103540:	89 03                	mov    %eax,(%ebx)
80103542:	85 c0                	test   %eax,%eax
80103544:	0f 84 a8 00 00 00    	je     801035f2 <pipealloc+0xd2>
8010354a:	e8 d1 d9 ff ff       	call   80100f20 <filealloc>
8010354f:	89 06                	mov    %eax,(%esi)
80103551:	85 c0                	test   %eax,%eax
80103553:	0f 84 87 00 00 00    	je     801035e0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103559:	e8 12 f2 ff ff       	call   80102770 <kalloc>
8010355e:	89 c7                	mov    %eax,%edi
80103560:	85 c0                	test   %eax,%eax
80103562:	0f 84 b0 00 00 00    	je     80103618 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103568:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010356f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103572:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103575:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010357c:	00 00 00 
  p->nwrite = 0;
8010357f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103586:	00 00 00 
  p->nread = 0;
80103589:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103590:	00 00 00 
  initlock(&p->lock, "pipe");
80103593:	68 9b 7e 10 80       	push   $0x80107e9b
80103598:	50                   	push   %eax
80103599:	e8 f2 15 00 00       	call   80104b90 <initlock>
  (*f0)->type = FD_PIPE;
8010359e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801035a0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035a3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035a9:	8b 03                	mov    (%ebx),%eax
801035ab:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035af:	8b 03                	mov    (%ebx),%eax
801035b1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035b5:	8b 03                	mov    (%ebx),%eax
801035b7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035ba:	8b 06                	mov    (%esi),%eax
801035bc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035c2:	8b 06                	mov    (%esi),%eax
801035c4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035c8:	8b 06                	mov    (%esi),%eax
801035ca:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035ce:	8b 06                	mov    (%esi),%eax
801035d0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801035d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035d6:	31 c0                	xor    %eax,%eax
}
801035d8:	5b                   	pop    %ebx
801035d9:	5e                   	pop    %esi
801035da:	5f                   	pop    %edi
801035db:	5d                   	pop    %ebp
801035dc:	c3                   	ret    
801035dd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801035e0:	8b 03                	mov    (%ebx),%eax
801035e2:	85 c0                	test   %eax,%eax
801035e4:	74 1e                	je     80103604 <pipealloc+0xe4>
    fileclose(*f0);
801035e6:	83 ec 0c             	sub    $0xc,%esp
801035e9:	50                   	push   %eax
801035ea:	e8 f1 d9 ff ff       	call   80100fe0 <fileclose>
801035ef:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801035f2:	8b 06                	mov    (%esi),%eax
801035f4:	85 c0                	test   %eax,%eax
801035f6:	74 0c                	je     80103604 <pipealloc+0xe4>
    fileclose(*f1);
801035f8:	83 ec 0c             	sub    $0xc,%esp
801035fb:	50                   	push   %eax
801035fc:	e8 df d9 ff ff       	call   80100fe0 <fileclose>
80103601:	83 c4 10             	add    $0x10,%esp
}
80103604:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103607:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010360c:	5b                   	pop    %ebx
8010360d:	5e                   	pop    %esi
8010360e:	5f                   	pop    %edi
8010360f:	5d                   	pop    %ebp
80103610:	c3                   	ret    
80103611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103618:	8b 03                	mov    (%ebx),%eax
8010361a:	85 c0                	test   %eax,%eax
8010361c:	75 c8                	jne    801035e6 <pipealloc+0xc6>
8010361e:	eb d2                	jmp    801035f2 <pipealloc+0xd2>

80103620 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	56                   	push   %esi
80103624:	53                   	push   %ebx
80103625:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103628:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010362b:	83 ec 0c             	sub    $0xc,%esp
8010362e:	53                   	push   %ebx
8010362f:	e8 2c 17 00 00       	call   80104d60 <acquire>
  if(writable){
80103634:	83 c4 10             	add    $0x10,%esp
80103637:	85 f6                	test   %esi,%esi
80103639:	74 65                	je     801036a0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010363b:	83 ec 0c             	sub    $0xc,%esp
8010363e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103644:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010364b:	00 00 00 
    wakeup(&p->nread);
8010364e:	50                   	push   %eax
8010364f:	e8 3c 0d 00 00       	call   80104390 <wakeup>
80103654:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103657:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010365d:	85 d2                	test   %edx,%edx
8010365f:	75 0a                	jne    8010366b <pipeclose+0x4b>
80103661:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103667:	85 c0                	test   %eax,%eax
80103669:	74 15                	je     80103680 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010366b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010366e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103671:	5b                   	pop    %ebx
80103672:	5e                   	pop    %esi
80103673:	5d                   	pop    %ebp
    release(&p->lock);
80103674:	e9 87 16 00 00       	jmp    80104d00 <release>
80103679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103680:	83 ec 0c             	sub    $0xc,%esp
80103683:	53                   	push   %ebx
80103684:	e8 77 16 00 00       	call   80104d00 <release>
    kfree((char*)p);
80103689:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010368c:	83 c4 10             	add    $0x10,%esp
}
8010368f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103692:	5b                   	pop    %ebx
80103693:	5e                   	pop    %esi
80103694:	5d                   	pop    %ebp
    kfree((char*)p);
80103695:	e9 16 ef ff ff       	jmp    801025b0 <kfree>
8010369a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801036a0:	83 ec 0c             	sub    $0xc,%esp
801036a3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801036a9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036b0:	00 00 00 
    wakeup(&p->nwrite);
801036b3:	50                   	push   %eax
801036b4:	e8 d7 0c 00 00       	call   80104390 <wakeup>
801036b9:	83 c4 10             	add    $0x10,%esp
801036bc:	eb 99                	jmp    80103657 <pipeclose+0x37>
801036be:	66 90                	xchg   %ax,%ax

801036c0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	57                   	push   %edi
801036c4:	56                   	push   %esi
801036c5:	53                   	push   %ebx
801036c6:	83 ec 28             	sub    $0x28,%esp
801036c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801036cc:	53                   	push   %ebx
801036cd:	e8 8e 16 00 00       	call   80104d60 <acquire>
  for(i = 0; i < n; i++){
801036d2:	8b 45 10             	mov    0x10(%ebp),%eax
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	85 c0                	test   %eax,%eax
801036da:	0f 8e c0 00 00 00    	jle    801037a0 <pipewrite+0xe0>
801036e0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036e3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801036e9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801036ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036f2:	03 45 10             	add    0x10(%ebp),%eax
801036f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036f8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036fe:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103704:	89 ca                	mov    %ecx,%edx
80103706:	05 00 02 00 00       	add    $0x200,%eax
8010370b:	39 c1                	cmp    %eax,%ecx
8010370d:	74 3f                	je     8010374e <pipewrite+0x8e>
8010370f:	eb 67                	jmp    80103778 <pipewrite+0xb8>
80103711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103718:	e8 03 04 00 00       	call   80103b20 <myproc>
8010371d:	8b 48 14             	mov    0x14(%eax),%ecx
80103720:	85 c9                	test   %ecx,%ecx
80103722:	75 34                	jne    80103758 <pipewrite+0x98>
      wakeup(&p->nread);
80103724:	83 ec 0c             	sub    $0xc,%esp
80103727:	57                   	push   %edi
80103728:	e8 63 0c 00 00       	call   80104390 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010372d:	58                   	pop    %eax
8010372e:	5a                   	pop    %edx
8010372f:	53                   	push   %ebx
80103730:	56                   	push   %esi
80103731:	e8 0a 0a 00 00       	call   80104140 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103736:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010373c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103742:	83 c4 10             	add    $0x10,%esp
80103745:	05 00 02 00 00       	add    $0x200,%eax
8010374a:	39 c2                	cmp    %eax,%edx
8010374c:	75 2a                	jne    80103778 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010374e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103754:	85 c0                	test   %eax,%eax
80103756:	75 c0                	jne    80103718 <pipewrite+0x58>
        release(&p->lock);
80103758:	83 ec 0c             	sub    $0xc,%esp
8010375b:	53                   	push   %ebx
8010375c:	e8 9f 15 00 00       	call   80104d00 <release>
        return -1;
80103761:	83 c4 10             	add    $0x10,%esp
80103764:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103769:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010376c:	5b                   	pop    %ebx
8010376d:	5e                   	pop    %esi
8010376e:	5f                   	pop    %edi
8010376f:	5d                   	pop    %ebp
80103770:	c3                   	ret    
80103771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103778:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010377b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010377e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103784:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010378a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010378d:	83 c6 01             	add    $0x1,%esi
80103790:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103793:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103797:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010379a:	0f 85 58 ff ff ff    	jne    801036f8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037a0:	83 ec 0c             	sub    $0xc,%esp
801037a3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037a9:	50                   	push   %eax
801037aa:	e8 e1 0b 00 00       	call   80104390 <wakeup>
  release(&p->lock);
801037af:	89 1c 24             	mov    %ebx,(%esp)
801037b2:	e8 49 15 00 00       	call   80104d00 <release>
  return n;
801037b7:	8b 45 10             	mov    0x10(%ebp),%eax
801037ba:	83 c4 10             	add    $0x10,%esp
801037bd:	eb aa                	jmp    80103769 <pipewrite+0xa9>
801037bf:	90                   	nop

801037c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	57                   	push   %edi
801037c4:	56                   	push   %esi
801037c5:	53                   	push   %ebx
801037c6:	83 ec 18             	sub    $0x18,%esp
801037c9:	8b 75 08             	mov    0x8(%ebp),%esi
801037cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037cf:	56                   	push   %esi
801037d0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037d6:	e8 85 15 00 00       	call   80104d60 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037db:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037e1:	83 c4 10             	add    $0x10,%esp
801037e4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801037ea:	74 2f                	je     8010381b <piperead+0x5b>
801037ec:	eb 37                	jmp    80103825 <piperead+0x65>
801037ee:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801037f0:	e8 2b 03 00 00       	call   80103b20 <myproc>
801037f5:	8b 48 14             	mov    0x14(%eax),%ecx
801037f8:	85 c9                	test   %ecx,%ecx
801037fa:	0f 85 80 00 00 00    	jne    80103880 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103800:	83 ec 08             	sub    $0x8,%esp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
80103805:	e8 36 09 00 00       	call   80104140 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010380a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103810:	83 c4 10             	add    $0x10,%esp
80103813:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103819:	75 0a                	jne    80103825 <piperead+0x65>
8010381b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103821:	85 c0                	test   %eax,%eax
80103823:	75 cb                	jne    801037f0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103825:	8b 55 10             	mov    0x10(%ebp),%edx
80103828:	31 db                	xor    %ebx,%ebx
8010382a:	85 d2                	test   %edx,%edx
8010382c:	7f 20                	jg     8010384e <piperead+0x8e>
8010382e:	eb 2c                	jmp    8010385c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103830:	8d 48 01             	lea    0x1(%eax),%ecx
80103833:	25 ff 01 00 00       	and    $0x1ff,%eax
80103838:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010383e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103843:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103846:	83 c3 01             	add    $0x1,%ebx
80103849:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010384c:	74 0e                	je     8010385c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010384e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103854:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010385a:	75 d4                	jne    80103830 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010385c:	83 ec 0c             	sub    $0xc,%esp
8010385f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103865:	50                   	push   %eax
80103866:	e8 25 0b 00 00       	call   80104390 <wakeup>
  release(&p->lock);
8010386b:	89 34 24             	mov    %esi,(%esp)
8010386e:	e8 8d 14 00 00       	call   80104d00 <release>
  return i;
80103873:	83 c4 10             	add    $0x10,%esp
}
80103876:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103879:	89 d8                	mov    %ebx,%eax
8010387b:	5b                   	pop    %ebx
8010387c:	5e                   	pop    %esi
8010387d:	5f                   	pop    %edi
8010387e:	5d                   	pop    %ebp
8010387f:	c3                   	ret    
      release(&p->lock);
80103880:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103883:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103888:	56                   	push   %esi
80103889:	e8 72 14 00 00       	call   80104d00 <release>
      return -1;
8010388e:	83 c4 10             	add    $0x10,%esp
}
80103891:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103894:	89 d8                	mov    %ebx,%eax
80103896:	5b                   	pop    %ebx
80103897:	5e                   	pop    %esi
80103898:	5f                   	pop    %edi
80103899:	5d                   	pop    %ebp
8010389a:	c3                   	ret    
8010389b:	66 90                	xchg   %ax,%ax
8010389d:	66 90                	xchg   %ax,%ax
8010389f:	90                   	nop

801038a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	53                   	push   %ebx
  struct thread *t;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038a4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801038a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801038ac:	68 20 2d 11 80       	push   $0x80112d20
801038b1:	e8 aa 14 00 00       	call   80104d60 <acquire>
801038b6:	83 c4 10             	add    $0x10,%esp
801038b9:	eb 17                	jmp    801038d2 <allocproc+0x32>
801038bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038bf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038c0:	81 c3 70 08 00 00    	add    $0x870,%ebx
801038c6:	81 fb 54 49 13 80    	cmp    $0x80134954,%ebx
801038cc:	0f 84 ba 00 00 00    	je     8010398c <allocproc+0xec>
    if(p->state == UNUSED)
801038d2:	8b 43 08             	mov    0x8(%ebx),%eax
801038d5:	85 c0                	test   %eax,%eax
801038d7:	75 e7                	jne    801038c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801038d9:	a1 08 b0 10 80       	mov    0x8010b008,%eax
  p->state = EMBRYO;
801038de:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
  p->curtidx = 0;
801038e5:	c7 83 6c 08 00 00 00 	movl   $0x0,0x86c(%ebx)
801038ec:	00 00 00 
  p->pid = nextpid++;
801038ef:	8d 50 01             	lea    0x1(%eax),%edx
801038f2:	89 43 0c             	mov    %eax,0xc(%ebx)

  // Thread pool init
  for(int i = 0; i < NTHREAD; i++)
801038f5:	8d 43 6c             	lea    0x6c(%ebx),%eax
  p->pid = nextpid++;
801038f8:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
801038fe:	8d 93 6c 08 00 00    	lea    0x86c(%ebx),%edx
80103904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	p->threads[i].state = UNUSED;
80103908:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i = 0; i < NTHREAD; i++)
8010390e:	83 c0 20             	add    $0x20,%eax
80103911:	39 c2                	cmp    %eax,%edx
80103913:	75 f3                	jne    80103908 <allocproc+0x68>

  // Default-thread init
  t = &p->threads[0];
  t->state = EMBRYO;
  t->tid = nexttid++;
80103915:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  t->ret = 0;

  release(&ptable.lock);
8010391a:	83 ec 0c             	sub    $0xc,%esp
  t->state = EMBRYO;
8010391d:	c7 43 6c 01 00 00 00 	movl   $0x1,0x6c(%ebx)
  t->ret = 0;
80103924:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
8010392b:	00 00 00 
  t->tid = nexttid++;
8010392e:	89 43 70             	mov    %eax,0x70(%ebx)
80103931:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103934:	68 20 2d 11 80       	push   $0x80112d20
  t->tid = nexttid++;
80103939:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
8010393f:	e8 bc 13 00 00       	call   80104d00 <release>

  // Allocate kernel stack to Default-thread
  if((t->kstack = kalloc()) == 0){
80103944:	e8 27 ee ff ff       	call   80102770 <kalloc>
80103949:	83 c4 10             	add    $0x10,%esp
8010394c:	89 43 74             	mov    %eax,0x74(%ebx)
8010394f:	85 c0                	test   %eax,%eax
80103951:	74 52                	je     801039a5 <allocproc+0x105>
    return 0;
  }
  sp = t->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *t->tf;
80103953:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *t->context;
  t->context = (struct context*)sp;
  memset(t->context, 0, sizeof *t->context);
80103959:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *t->context;
8010395c:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *t->tf;
80103961:	89 53 78             	mov    %edx,0x78(%ebx)
  *(uint*)sp = (uint)trapret;
80103964:	c7 40 14 e2 5f 10 80 	movl   $0x80105fe2,0x14(%eax)
  t->context = (struct context*)sp;
8010396b:	89 43 7c             	mov    %eax,0x7c(%ebx)
  memset(t->context, 0, sizeof *t->context);
8010396e:	6a 14                	push   $0x14
80103970:	6a 00                	push   $0x0
80103972:	50                   	push   %eax
80103973:	e8 a8 14 00 00       	call   80104e20 <memset>
  t->context->eip = (uint)forkret;
80103978:	8b 43 7c             	mov    0x7c(%ebx),%eax

  return p;
8010397b:	83 c4 10             	add    $0x10,%esp
  t->context->eip = (uint)forkret;
8010397e:	c7 40 10 c0 39 10 80 	movl   $0x801039c0,0x10(%eax)
}
80103985:	89 d8                	mov    %ebx,%eax
80103987:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010398a:	c9                   	leave  
8010398b:	c3                   	ret    
  release(&ptable.lock);
8010398c:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010398f:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103991:	68 20 2d 11 80       	push   $0x80112d20
80103996:	e8 65 13 00 00       	call   80104d00 <release>
}
8010399b:	89 d8                	mov    %ebx,%eax
  return 0;
8010399d:	83 c4 10             	add    $0x10,%esp
}
801039a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a3:	c9                   	leave  
801039a4:	c3                   	ret    
    p->state = UNUSED;
801039a5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	t->state = UNUSED;
801039ac:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
    return 0;
801039b3:	31 db                	xor    %ebx,%ebx
}
801039b5:	89 d8                	mov    %ebx,%eax
801039b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039ba:	c9                   	leave  
801039bb:	c3                   	ret    
801039bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801039c6:	68 20 2d 11 80       	push   $0x80112d20
801039cb:	e8 30 13 00 00       	call   80104d00 <release>

  if (first) {
801039d0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801039d5:	83 c4 10             	add    $0x10,%esp
801039d8:	85 c0                	test   %eax,%eax
801039da:	75 04                	jne    801039e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039dc:	c9                   	leave  
801039dd:	c3                   	ret    
801039de:	66 90                	xchg   %ax,%ax
    first = 0;
801039e0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801039e7:	00 00 00 
    iinit(ROOTDEV);
801039ea:	83 ec 0c             	sub    $0xc,%esp
801039ed:	6a 01                	push   $0x1
801039ef:	e8 5c dc ff ff       	call   80101650 <iinit>
    initlog(ROOTDEV);
801039f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039fb:	e8 b0 f3 ff ff       	call   80102db0 <initlog>
}
80103a00:	83 c4 10             	add    $0x10,%esp
80103a03:	c9                   	leave  
80103a04:	c3                   	ret    
80103a05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a10 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103a10:	55                   	push   %ebp
80103a11:	ba c0 35 11 80       	mov    $0x801135c0,%edx
80103a16:	89 e5                	mov    %esp,%ebp
80103a18:	53                   	push   %ebx
80103a19:	89 c3                	mov    %eax,%ebx
80103a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a1f:	90                   	nop
  struct proc *p;
  struct thread *t;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80103a20:	8d 8a 00 f8 ff ff    	lea    -0x800(%edx),%ecx
80103a26:	89 c8                	mov    %ecx,%eax
80103a28:	eb 0d                	jmp    80103a37 <wakeup1+0x27>
80103a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a30:	83 c0 20             	add    $0x20,%eax
80103a33:	39 d0                	cmp    %edx,%eax
80103a35:	74 20                	je     80103a57 <wakeup1+0x47>
      if(t->state == SLEEPING && t->chan == chan){
80103a37:	83 38 02             	cmpl   $0x2,(%eax)
80103a3a:	75 f4                	jne    80103a30 <wakeup1+0x20>
80103a3c:	39 58 18             	cmp    %ebx,0x18(%eax)
80103a3f:	75 ef                	jne    80103a30 <wakeup1+0x20>
      	t->state = RUNNABLE;
80103a41:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
80103a47:	eb e7                	jmp    80103a30 <wakeup1+0x20>
80103a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	p->state = ZOMBIE;
  return;
 
ISRUNNABLE: // if any threads are runnable, change p states: RUNNABLE
  flag = 0;
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80103a50:	83 c1 20             	add    $0x20,%ecx
80103a53:	39 ca                	cmp    %ecx,%edx
80103a55:	74 0f                	je     80103a66 <wakeup1+0x56>
	if(t->state == RUNNABLE){
80103a57:	83 39 03             	cmpl   $0x3,(%ecx)
80103a5a:	75 f4                	jne    80103a50 <wakeup1+0x40>
	  flag = 1;
	  break;
	}
  if(flag)
	p->state = RUNNABLE;
80103a5c:	c7 82 9c f7 ff ff 03 	movl   $0x3,-0x864(%edx)
80103a63:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a66:	81 c2 70 08 00 00    	add    $0x870,%edx
80103a6c:	81 fa c0 51 13 80    	cmp    $0x801351c0,%edx
80103a72:	75 ac                	jne    80103a20 <wakeup1+0x10>
}
80103a74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a77:	c9                   	leave  
80103a78:	c3                   	ret    
80103a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a80 <pinit>:
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a86:	68 a0 7e 10 80       	push   $0x80107ea0
80103a8b:	68 20 2d 11 80       	push   $0x80112d20
80103a90:	e8 fb 10 00 00       	call   80104b90 <initlock>
}
80103a95:	83 c4 10             	add    $0x10,%esp
80103a98:	c9                   	leave  
80103a99:	c3                   	ret    
80103a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103aa0 <mycpu>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
80103aa4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103aa5:	9c                   	pushf  
80103aa6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103aa7:	f6 c4 02             	test   $0x2,%ah
80103aaa:	75 46                	jne    80103af2 <mycpu+0x52>
  apicid = lapicid();
80103aac:	e8 2f ef ff ff       	call   801029e0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ab1:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103ab7:	85 f6                	test   %esi,%esi
80103ab9:	7e 2a                	jle    80103ae5 <mycpu+0x45>
80103abb:	31 d2                	xor    %edx,%edx
80103abd:	eb 08                	jmp    80103ac7 <mycpu+0x27>
80103abf:	90                   	nop
80103ac0:	83 c2 01             	add    $0x1,%edx
80103ac3:	39 f2                	cmp    %esi,%edx
80103ac5:	74 1e                	je     80103ae5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103ac7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103acd:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103ad4:	39 c3                	cmp    %eax,%ebx
80103ad6:	75 e8                	jne    80103ac0 <mycpu+0x20>
}
80103ad8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103adb:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103ae1:	5b                   	pop    %ebx
80103ae2:	5e                   	pop    %esi
80103ae3:	5d                   	pop    %ebp
80103ae4:	c3                   	ret    
  panic("unknown apicid\n");
80103ae5:	83 ec 0c             	sub    $0xc,%esp
80103ae8:	68 a7 7e 10 80       	push   $0x80107ea7
80103aed:	e8 8e c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103af2:	83 ec 0c             	sub    $0xc,%esp
80103af5:	68 a8 7f 10 80       	push   $0x80107fa8
80103afa:	e8 81 c8 ff ff       	call   80100380 <panic>
80103aff:	90                   	nop

80103b00 <cpuid>:
cpuid() {
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b06:	e8 95 ff ff ff       	call   80103aa0 <mycpu>
}
80103b0b:	c9                   	leave  
  return mycpu()-cpus;
80103b0c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103b11:	c1 f8 04             	sar    $0x4,%eax
80103b14:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b1a:	c3                   	ret    
80103b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop

80103b20 <myproc>:
myproc(void) {
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	53                   	push   %ebx
80103b24:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b27:	e8 e4 10 00 00       	call   80104c10 <pushcli>
  c = mycpu();
80103b2c:	e8 6f ff ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103b31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b37:	e8 24 11 00 00       	call   80104c60 <popcli>
}
80103b3c:	89 d8                	mov    %ebx,%eax
80103b3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b41:	c9                   	leave  
80103b42:	c3                   	ret    
80103b43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b50 <userinit>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	53                   	push   %ebx
80103b54:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b57:	e8 44 fd ff ff       	call   801038a0 <allocproc>
80103b5c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b5e:	a3 54 49 13 80       	mov    %eax,0x80134954
  if((p->pgdir = setupkvm()) == 0)
80103b63:	e8 78 3a 00 00       	call   801075e0 <setupkvm>
80103b68:	89 43 04             	mov    %eax,0x4(%ebx)
80103b6b:	85 c0                	test   %eax,%eax
80103b6d:	0f 84 c4 00 00 00    	je     80103c37 <userinit+0xe7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b73:	83 ec 04             	sub    $0x4,%esp
80103b76:	68 2c 00 00 00       	push   $0x2c
80103b7b:	68 60 b4 10 80       	push   $0x8010b460
80103b80:	50                   	push   %eax
80103b81:	e8 0a 37 00 00       	call   80107290 <inituvm>
  memset(t->tf, 0, sizeof(*t->tf));
80103b86:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b89:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(t->tf, 0, sizeof(*t->tf));
80103b8f:	6a 4c                	push   $0x4c
80103b91:	6a 00                	push   $0x0
80103b93:	ff 73 78             	push   0x78(%ebx)
80103b96:	e8 85 12 00 00       	call   80104e20 <memset>
  t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b9b:	8b 43 78             	mov    0x78(%ebx),%eax
80103b9e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ba3:	83 c4 0c             	add    $0xc,%esp
  t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ba6:	b9 23 00 00 00       	mov    $0x23,%ecx
  t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103baf:	8b 43 78             	mov    0x78(%ebx),%eax
80103bb2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  t->tf->es = t->tf->ds;
80103bb6:	8b 43 78             	mov    0x78(%ebx),%eax
80103bb9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bbd:	66 89 50 28          	mov    %dx,0x28(%eax)
  t->tf->ss = t->tf->ds;
80103bc1:	8b 43 78             	mov    0x78(%ebx),%eax
80103bc4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bc8:	66 89 50 48          	mov    %dx,0x48(%eax)
  t->tf->eflags = FL_IF;
80103bcc:	8b 43 78             	mov    0x78(%ebx),%eax
80103bcf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  t->tf->esp = PGSIZE;
80103bd6:	8b 43 78             	mov    0x78(%ebx),%eax
80103bd9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  t->tf->eip = 0;  // beginning of initcode.S
80103be0:	8b 43 78             	mov    0x78(%ebx),%eax
80103be3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bea:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103bed:	6a 10                	push   $0x10
80103bef:	68 d0 7e 10 80       	push   $0x80107ed0
80103bf4:	50                   	push   %eax
80103bf5:	e8 e6 13 00 00       	call   80104fe0 <safestrcpy>
  p->cwd = namei("/");
80103bfa:	c7 04 24 d9 7e 10 80 	movl   $0x80107ed9,(%esp)
80103c01:	e8 8a e5 ff ff       	call   80102190 <namei>
80103c06:	89 43 58             	mov    %eax,0x58(%ebx)
  acquire(&ptable.lock);
80103c09:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c10:	e8 4b 11 00 00       	call   80104d60 <acquire>
  t->state = RUNNABLE;
80103c15:	c7 43 6c 03 00 00 00 	movl   $0x3,0x6c(%ebx)
  p->state = RUNNABLE;
80103c1c:	c7 43 08 03 00 00 00 	movl   $0x3,0x8(%ebx)
  release(&ptable.lock);
80103c23:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c2a:	e8 d1 10 00 00       	call   80104d00 <release>
}
80103c2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c32:	83 c4 10             	add    $0x10,%esp
80103c35:	c9                   	leave  
80103c36:	c3                   	ret    
    panic("userinit: out of memory?");
80103c37:	83 ec 0c             	sub    $0xc,%esp
80103c3a:	68 b7 7e 10 80       	push   $0x80107eb7
80103c3f:	e8 3c c7 ff ff       	call   80100380 <panic>
80103c44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c4f:	90                   	nop

80103c50 <growproc>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	56                   	push   %esi
80103c54:	53                   	push   %ebx
80103c55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c58:	e8 b3 0f 00 00       	call   80104c10 <pushcli>
  c = mycpu();
80103c5d:	e8 3e fe ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103c62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c68:	e8 f3 0f 00 00       	call   80104c60 <popcli>
  sz = curproc->sz;
80103c6d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c6f:	85 f6                	test   %esi,%esi
80103c71:	7f 1d                	jg     80103c90 <growproc+0x40>
  } else if(n < 0){
80103c73:	75 3b                	jne    80103cb0 <growproc+0x60>
  switchuvm(curproc);
80103c75:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c78:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c7a:	53                   	push   %ebx
80103c7b:	e8 00 35 00 00       	call   80107180 <switchuvm>
  return 0;
80103c80:	83 c4 10             	add    $0x10,%esp
80103c83:	31 c0                	xor    %eax,%eax
}
80103c85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c88:	5b                   	pop    %ebx
80103c89:	5e                   	pop    %esi
80103c8a:	5d                   	pop    %ebp
80103c8b:	c3                   	ret    
80103c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c90:	83 ec 04             	sub    $0x4,%esp
80103c93:	01 c6                	add    %eax,%esi
80103c95:	56                   	push   %esi
80103c96:	50                   	push   %eax
80103c97:	ff 73 04             	push   0x4(%ebx)
80103c9a:	e8 61 37 00 00       	call   80107400 <allocuvm>
80103c9f:	83 c4 10             	add    $0x10,%esp
80103ca2:	85 c0                	test   %eax,%eax
80103ca4:	75 cf                	jne    80103c75 <growproc+0x25>
      return -1;
80103ca6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cab:	eb d8                	jmp    80103c85 <growproc+0x35>
80103cad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cb0:	83 ec 04             	sub    $0x4,%esp
80103cb3:	01 c6                	add    %eax,%esi
80103cb5:	56                   	push   %esi
80103cb6:	50                   	push   %eax
80103cb7:	ff 73 04             	push   0x4(%ebx)
80103cba:	e8 71 38 00 00       	call   80107530 <deallocuvm>
80103cbf:	83 c4 10             	add    $0x10,%esp
80103cc2:	85 c0                	test   %eax,%eax
80103cc4:	75 af                	jne    80103c75 <growproc+0x25>
80103cc6:	eb de                	jmp    80103ca6 <growproc+0x56>
80103cc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ccf:	90                   	nop

80103cd0 <fork>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	57                   	push   %edi
80103cd4:	56                   	push   %esi
80103cd5:	53                   	push   %ebx
80103cd6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103cd9:	e8 32 0f 00 00       	call   80104c10 <pushcli>
  c = mycpu();
80103cde:	e8 bd fd ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103ce3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ce9:	e8 72 0f 00 00       	call   80104c60 <popcli>
  struct thread *curt = &curproc->threads[curproc->curtidx];
80103cee:	8b b3 6c 08 00 00    	mov    0x86c(%ebx),%esi
  if((np = allocproc()) == 0){
80103cf4:	e8 a7 fb ff ff       	call   801038a0 <allocproc>
80103cf9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103cfc:	85 c0                	test   %eax,%eax
80103cfe:	0f 84 c8 00 00 00    	je     80103dcc <fork+0xfc>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d04:	83 ec 08             	sub    $0x8,%esp
80103d07:	ff 33                	push   (%ebx)
80103d09:	89 c7                	mov    %eax,%edi
80103d0b:	ff 73 04             	push   0x4(%ebx)
80103d0e:	e8 bd 39 00 00       	call   801076d0 <copyuvm>
80103d13:	83 c4 10             	add    $0x10,%esp
80103d16:	89 47 04             	mov    %eax,0x4(%edi)
80103d19:	85 c0                	test   %eax,%eax
80103d1b:	0f 84 b2 00 00 00    	je     80103dd3 <fork+0x103>
  np->sz = curproc->sz;
80103d21:	8b 03                	mov    (%ebx),%eax
80103d23:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  *ndt->tf = *curt->tf;
80103d26:	c1 e6 05             	shl    $0x5,%esi
  np->sz = curproc->sz;
80103d29:	89 01                	mov    %eax,(%ecx)
  *ndt->tf = *curt->tf;
80103d2b:	8b 79 78             	mov    0x78(%ecx),%edi
  np->parent = curproc;
80103d2e:	89 c8                	mov    %ecx,%eax
80103d30:	89 59 10             	mov    %ebx,0x10(%ecx)
  *ndt->tf = *curt->tf;
80103d33:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d38:	8b 74 1e 78          	mov    0x78(%esi,%ebx,1),%esi
80103d3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d3e:	31 f6                	xor    %esi,%esi
  ndt->tf->eax = 0;
80103d40:	8b 40 78             	mov    0x78(%eax),%eax
80103d43:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80103d50:	8b 44 b3 18          	mov    0x18(%ebx,%esi,4),%eax
80103d54:	85 c0                	test   %eax,%eax
80103d56:	74 13                	je     80103d6b <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d58:	83 ec 0c             	sub    $0xc,%esp
80103d5b:	50                   	push   %eax
80103d5c:	e8 2f d2 ff ff       	call   80100f90 <filedup>
80103d61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d64:	83 c4 10             	add    $0x10,%esp
80103d67:	89 44 b2 18          	mov    %eax,0x18(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d6b:	83 c6 01             	add    $0x1,%esi
80103d6e:	83 fe 10             	cmp    $0x10,%esi
80103d71:	75 dd                	jne    80103d50 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103d73:	83 ec 0c             	sub    $0xc,%esp
80103d76:	ff 73 58             	push   0x58(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d79:	83 c3 5c             	add    $0x5c,%ebx
  np->cwd = idup(curproc->cwd);
80103d7c:	e8 bf da ff ff       	call   80101840 <idup>
80103d81:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d84:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d87:	89 47 58             	mov    %eax,0x58(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d8a:	8d 47 5c             	lea    0x5c(%edi),%eax
80103d8d:	6a 10                	push   $0x10
80103d8f:	53                   	push   %ebx
80103d90:	50                   	push   %eax
80103d91:	e8 4a 12 00 00       	call   80104fe0 <safestrcpy>
  pid = np->pid;
80103d96:	8b 5f 0c             	mov    0xc(%edi),%ebx
  acquire(&ptable.lock);
80103d99:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103da0:	e8 bb 0f 00 00       	call   80104d60 <acquire>
  np->state = RUNNABLE;
80103da5:	c7 47 08 03 00 00 00 	movl   $0x3,0x8(%edi)
  ndt->state = RUNNABLE;
80103dac:	c7 47 6c 03 00 00 00 	movl   $0x3,0x6c(%edi)
  release(&ptable.lock);
80103db3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dba:	e8 41 0f 00 00       	call   80104d00 <release>
  return pid;
80103dbf:	83 c4 10             	add    $0x10,%esp
}
80103dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dc5:	89 d8                	mov    %ebx,%eax
80103dc7:	5b                   	pop    %ebx
80103dc8:	5e                   	pop    %esi
80103dc9:	5f                   	pop    %edi
80103dca:	5d                   	pop    %ebp
80103dcb:	c3                   	ret    
    return -1;
80103dcc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103dd1:	eb ef                	jmp    80103dc2 <fork+0xf2>
    kfree(ndt->kstack);
80103dd3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103dd6:	83 ec 0c             	sub    $0xc,%esp
80103dd9:	ff 73 74             	push   0x74(%ebx)
80103ddc:	e8 cf e7 ff ff       	call   801025b0 <kfree>
    ndt->kstack = 0;
80103de1:	c7 43 74 00 00 00 00 	movl   $0x0,0x74(%ebx)
    return -1;
80103de8:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103deb:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	ndt->state = UNUSED;
80103df2:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
    return -1;
80103df9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103dfe:	eb c2                	jmp    80103dc2 <fork+0xf2>

80103e00 <scheduler>:
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	56                   	push   %esi
80103e05:	53                   	push   %ebx
80103e06:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103e09:	e8 92 fc ff ff       	call   80103aa0 <mycpu>
  c->proc = 0;
80103e0e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e15:	00 00 00 
  struct cpu *c = mycpu();
80103e18:	89 c7                	mov    %eax,%edi
  c->proc = 0;
80103e1a:	8d 40 04             	lea    0x4(%eax),%eax
80103e1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103e20:	fb                   	sti    
    acquire(&ptable.lock);
80103e21:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e24:	be 54 2d 11 80       	mov    $0x80112d54,%esi
    acquire(&ptable.lock);
80103e29:	68 20 2d 11 80       	push   $0x80112d20
80103e2e:	e8 2d 0f 00 00       	call   80104d60 <acquire>
80103e33:	83 c4 10             	add    $0x10,%esp
80103e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e3d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103e40:	83 7e 08 03          	cmpl   $0x3,0x8(%esi)
80103e44:	0f 85 84 00 00 00    	jne    80103ece <scheduler+0xce>
      c->proc = p;
80103e4a:	89 b7 ac 00 00 00    	mov    %esi,0xac(%edi)
  for(i = next + 1; i < NTHREAD; i++){
80103e50:	31 c0                	xor    %eax,%eax
80103e52:	eb 0c                	jmp    80103e60 <scheduler+0x60>
80103e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e58:	83 c0 01             	add    $0x1,%eax
80103e5b:	83 f8 40             	cmp    $0x40,%eax
80103e5e:	74 6e                	je     80103ece <scheduler+0xce>
	if(p->threads[i].state == RUNNABLE){
80103e60:	89 c2                	mov    %eax,%edx
80103e62:	c1 e2 05             	shl    $0x5,%edx
80103e65:	83 7c 16 6c 03       	cmpl   $0x3,0x6c(%esi,%edx,1)
80103e6a:	75 ec                	jne    80103e58 <scheduler+0x58>
80103e6c:	8d 48 01             	lea    0x1(%eax),%ecx
  for(i = 0; i < next + 1; i++){
80103e6f:	31 db                	xor    %ebx,%ebx
80103e71:	eb 0c                	jmp    80103e7f <scheduler+0x7f>
80103e73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e77:	90                   	nop
80103e78:	83 c3 01             	add    $0x1,%ebx
80103e7b:	39 cb                	cmp    %ecx,%ebx
80103e7d:	74 79                	je     80103ef8 <scheduler+0xf8>
	if(p->threads[i].state == RUNNABLE){
80103e7f:	89 da                	mov    %ebx,%edx
80103e81:	c1 e2 05             	shl    $0x5,%edx
80103e84:	83 7c 16 6c 03       	cmpl   $0x3,0x6c(%esi,%edx,1)
80103e89:	75 ed                	jne    80103e78 <scheduler+0x78>
      switchuvm(p);
80103e8b:	83 ec 0c             	sub    $0xc,%esp
	  p->curtidx = next;
80103e8e:	89 9e 6c 08 00 00    	mov    %ebx,0x86c(%esi)
      switchuvm(p);
80103e94:	56                   	push   %esi
80103e95:	e8 e6 32 00 00       	call   80107180 <switchuvm>
	  t->state = RUNNING;
80103e9a:	89 d8                	mov    %ebx,%eax
      swtch(&(c->scheduler), t->context);
80103e9c:	5a                   	pop    %edx
      p->state = RUNNING;
80103e9d:	c7 46 08 04 00 00 00 	movl   $0x4,0x8(%esi)
	  t->state = RUNNING;
80103ea4:	c1 e0 05             	shl    $0x5,%eax
      swtch(&(c->scheduler), t->context);
80103ea7:	59                   	pop    %ecx
80103ea8:	ff 74 06 7c          	push   0x7c(%esi,%eax,1)
80103eac:	ff 75 e4             	push   -0x1c(%ebp)
	  t->state = RUNNING;
80103eaf:	c7 44 30 6c 04 00 00 	movl   $0x4,0x6c(%eax,%esi,1)
80103eb6:	00 
      swtch(&(c->scheduler), t->context);
80103eb7:	e8 7f 11 00 00       	call   8010503b <swtch>
      switchkvm();
80103ebc:	e8 af 32 00 00       	call   80107170 <switchkvm>
      c->proc = 0;
80103ec1:	83 c4 10             	add    $0x10,%esp
80103ec4:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80103ecb:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ece:	81 c6 70 08 00 00    	add    $0x870,%esi
80103ed4:	81 fe 54 49 13 80    	cmp    $0x80134954,%esi
80103eda:	0f 85 60 ff ff ff    	jne    80103e40 <scheduler+0x40>
    release(&ptable.lock);
80103ee0:	83 ec 0c             	sub    $0xc,%esp
80103ee3:	68 20 2d 11 80       	push   $0x80112d20
80103ee8:	e8 13 0e 00 00       	call   80104d00 <release>
    sti();
80103eed:	83 c4 10             	add    $0x10,%esp
80103ef0:	e9 2b ff ff ff       	jmp    80103e20 <scheduler+0x20>
80103ef5:	8d 76 00             	lea    0x0(%esi),%esi
80103ef8:	89 c3                	mov    %eax,%ebx
80103efa:	eb 8f                	jmp    80103e8b <scheduler+0x8b>
80103efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f00 <sched>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	57                   	push   %edi
80103f04:	56                   	push   %esi
80103f05:	53                   	push   %ebx
80103f06:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103f09:	e8 02 0d 00 00       	call   80104c10 <pushcli>
  c = mycpu();
80103f0e:	e8 8d fb ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103f13:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f19:	e8 42 0d 00 00       	call   80104c60 <popcli>
  if(!holding(&ptable.lock))
80103f1e:	83 ec 0c             	sub    $0xc,%esp
  struct thread *t = &p->threads[p->curtidx];
80103f21:	8b 9e 6c 08 00 00    	mov    0x86c(%esi),%ebx
  if(!holding(&ptable.lock))
80103f27:	68 20 2d 11 80       	push   $0x80112d20
80103f2c:	e8 8f 0d 00 00       	call   80104cc0 <holding>
80103f31:	83 c4 10             	add    $0x10,%esp
80103f34:	85 c0                	test   %eax,%eax
80103f36:	74 5a                	je     80103f92 <sched+0x92>
  if(mycpu()->ncli != 1)
80103f38:	e8 63 fb ff ff       	call   80103aa0 <mycpu>
80103f3d:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f44:	75 73                	jne    80103fb9 <sched+0xb9>
  if(t->state == RUNNING)
80103f46:	89 d8                	mov    %ebx,%eax
80103f48:	c1 e0 05             	shl    $0x5,%eax
80103f4b:	83 7c 30 6c 04       	cmpl   $0x4,0x6c(%eax,%esi,1)
80103f50:	74 5a                	je     80103fac <sched+0xac>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f52:	9c                   	pushf  
80103f53:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f54:	f6 c4 02             	test   $0x2,%ah
80103f57:	75 46                	jne    80103f9f <sched+0x9f>
  intena = mycpu()->intena;
80103f59:	e8 42 fb ff ff       	call   80103aa0 <mycpu>
  swtch(&t->context, mycpu()->scheduler);
80103f5e:	c1 e3 05             	shl    $0x5,%ebx
  intena = mycpu()->intena;
80103f61:	8b b8 a8 00 00 00    	mov    0xa8(%eax),%edi
  swtch(&t->context, mycpu()->scheduler);
80103f67:	e8 34 fb ff ff       	call   80103aa0 <mycpu>
80103f6c:	83 ec 08             	sub    $0x8,%esp
80103f6f:	ff 70 04             	push   0x4(%eax)
80103f72:	8d 44 1e 7c          	lea    0x7c(%esi,%ebx,1),%eax
80103f76:	50                   	push   %eax
80103f77:	e8 bf 10 00 00       	call   8010503b <swtch>
  mycpu()->intena = intena;
80103f7c:	e8 1f fb ff ff       	call   80103aa0 <mycpu>
}
80103f81:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f84:	89 b8 a8 00 00 00    	mov    %edi,0xa8(%eax)
}
80103f8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f8d:	5b                   	pop    %ebx
80103f8e:	5e                   	pop    %esi
80103f8f:	5f                   	pop    %edi
80103f90:	5d                   	pop    %ebp
80103f91:	c3                   	ret    
    panic("sched ptable.lock");
80103f92:	83 ec 0c             	sub    $0xc,%esp
80103f95:	68 db 7e 10 80       	push   $0x80107edb
80103f9a:	e8 e1 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103f9f:	83 ec 0c             	sub    $0xc,%esp
80103fa2:	68 07 7f 10 80       	push   $0x80107f07
80103fa7:	e8 d4 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80103fac:	83 ec 0c             	sub    $0xc,%esp
80103faf:	68 f9 7e 10 80       	push   $0x80107ef9
80103fb4:	e8 c7 c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103fb9:	83 ec 0c             	sub    $0xc,%esp
80103fbc:	68 ed 7e 10 80       	push   $0x80107eed
80103fc1:	e8 ba c3 ff ff       	call   80100380 <panic>
80103fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fcd:	8d 76 00             	lea    0x0(%esi),%esi

80103fd0 <exit>:
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	57                   	push   %edi
80103fd4:	56                   	push   %esi
80103fd5:	53                   	push   %ebx
80103fd6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103fd9:	e8 42 fb ff ff       	call   80103b20 <myproc>
  if(curproc == initproc)
80103fde:	39 05 54 49 13 80    	cmp    %eax,0x80134954
80103fe4:	0f 84 d7 00 00 00    	je     801040c1 <exit+0xf1>
80103fea:	89 c6                	mov    %eax,%esi
80103fec:	8d 58 18             	lea    0x18(%eax),%ebx
80103fef:	8d 78 58             	lea    0x58(%eax),%edi
80103ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103ff8:	8b 03                	mov    (%ebx),%eax
80103ffa:	85 c0                	test   %eax,%eax
80103ffc:	74 12                	je     80104010 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103ffe:	83 ec 0c             	sub    $0xc,%esp
80104001:	50                   	push   %eax
80104002:	e8 d9 cf ff ff       	call   80100fe0 <fileclose>
      curproc->ofile[fd] = 0;
80104007:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010400d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104010:	83 c3 04             	add    $0x4,%ebx
80104013:	39 fb                	cmp    %edi,%ebx
80104015:	75 e1                	jne    80103ff8 <exit+0x28>
  begin_op();
80104017:	e8 34 ee ff ff       	call   80102e50 <begin_op>
  iput(curproc->cwd);
8010401c:	83 ec 0c             	sub    $0xc,%esp
8010401f:	ff 76 58             	push   0x58(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104022:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  iput(curproc->cwd);
80104027:	e8 74 d9 ff ff       	call   801019a0 <iput>
  end_op();
8010402c:	e8 8f ee ff ff       	call   80102ec0 <end_op>
  curproc->cwd = 0;
80104031:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  acquire(&ptable.lock);
80104038:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010403f:	e8 1c 0d 00 00       	call   80104d60 <acquire>
  wakeup1(curproc->parent);
80104044:	8b 46 10             	mov    0x10(%esi),%eax
80104047:	e8 c4 f9 ff ff       	call   80103a10 <wakeup1>
8010404c:	83 c4 10             	add    $0x10,%esp
8010404f:	eb 15                	jmp    80104066 <exit+0x96>
80104051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104058:	81 c3 70 08 00 00    	add    $0x870,%ebx
8010405e:	81 fb 54 49 13 80    	cmp    $0x80134954,%ebx
80104064:	74 2a                	je     80104090 <exit+0xc0>
    if(p->parent == curproc){
80104066:	39 73 10             	cmp    %esi,0x10(%ebx)
80104069:	75 ed                	jne    80104058 <exit+0x88>
      p->parent = initproc;
8010406b:	a1 54 49 13 80       	mov    0x80134954,%eax
      if(p->state == ZOMBIE)
80104070:	83 7b 08 05          	cmpl   $0x5,0x8(%ebx)
      p->parent = initproc;
80104074:	89 43 10             	mov    %eax,0x10(%ebx)
      if(p->state == ZOMBIE)
80104077:	75 df                	jne    80104058 <exit+0x88>
        wakeup1(initproc);
80104079:	e8 92 f9 ff ff       	call   80103a10 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010407e:	81 c3 70 08 00 00    	add    $0x870,%ebx
80104084:	81 fb 54 49 13 80    	cmp    $0x80134954,%ebx
8010408a:	75 da                	jne    80104066 <exit+0x96>
8010408c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80104090:	b8 c0 49 13 80       	mov    $0x801349c0,%eax
80104095:	8d 76 00             	lea    0x0(%esi),%esi
	t->state = ZOMBIE;
80104098:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
8010409e:	83 c0 20             	add    $0x20,%eax
801040a1:	3d c0 51 13 80       	cmp    $0x801351c0,%eax
801040a6:	75 f0                	jne    80104098 <exit+0xc8>
  curproc->state = ZOMBIE;
801040a8:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%esi)
  sched();
801040af:	e8 4c fe ff ff       	call   80103f00 <sched>
  panic("zombie exit");
801040b4:	83 ec 0c             	sub    $0xc,%esp
801040b7:	68 28 7f 10 80       	push   $0x80107f28
801040bc:	e8 bf c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
801040c1:	83 ec 0c             	sub    $0xc,%esp
801040c4:	68 1b 7f 10 80       	push   $0x80107f1b
801040c9:	e8 b2 c2 ff ff       	call   80100380 <panic>
801040ce:	66 90                	xchg   %ax,%ax

801040d0 <yield>:
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	56                   	push   %esi
801040d4:	53                   	push   %ebx
  acquire(&ptable.lock);  //DOC: yieldlock
801040d5:	83 ec 0c             	sub    $0xc,%esp
801040d8:	68 20 2d 11 80       	push   $0x80112d20
801040dd:	e8 7e 0c 00 00       	call   80104d60 <acquire>
  pushcli();
801040e2:	e8 29 0b 00 00       	call   80104c10 <pushcli>
  c = mycpu();
801040e7:	e8 b4 f9 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
801040ec:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040f2:	e8 69 0b 00 00       	call   80104c60 <popcli>
  pushcli();
801040f7:	e8 14 0b 00 00       	call   80104c10 <pushcli>
  c = mycpu();
801040fc:	e8 9f f9 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80104101:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104107:	e8 54 0b 00 00       	call   80104c60 <popcli>
  struct thread *t = &myproc()->threads[myproc()->curtidx];
8010410c:	8b 86 6c 08 00 00    	mov    0x86c(%esi),%eax
  t->state = RUNNABLE;
80104112:	c1 e0 05             	shl    $0x5,%eax
80104115:	c7 44 18 6c 03 00 00 	movl   $0x3,0x6c(%eax,%ebx,1)
8010411c:	00 
  sched();
8010411d:	e8 de fd ff ff       	call   80103f00 <sched>
  release(&ptable.lock);
80104122:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104129:	e8 d2 0b 00 00       	call   80104d00 <release>
}
8010412e:	83 c4 10             	add    $0x10,%esp
80104131:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104134:	5b                   	pop    %ebx
80104135:	5e                   	pop    %esi
80104136:	5d                   	pop    %ebp
80104137:	c3                   	ret    
80104138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010413f:	90                   	nop

80104140 <sleep>:
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	57                   	push   %edi
80104144:	56                   	push   %esi
80104145:	53                   	push   %ebx
80104146:	83 ec 1c             	sub    $0x1c,%esp
80104149:	8b 45 08             	mov    0x8(%ebp),%eax
8010414c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010414f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pushcli();
80104152:	e8 b9 0a 00 00       	call   80104c10 <pushcli>
  c = mycpu();
80104157:	e8 44 f9 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
8010415c:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104162:	e8 f9 0a 00 00       	call   80104c60 <popcli>
  if(p == 0)
80104167:	85 f6                	test   %esi,%esi
80104169:	0f 84 ce 00 00 00    	je     8010423d <sleep+0xfd>
  struct thread *t = &p->threads[p->curtidx];
8010416f:	8b be 6c 08 00 00    	mov    0x86c(%esi),%edi
  if(lk == 0)
80104175:	85 db                	test   %ebx,%ebx
80104177:	0f 84 b3 00 00 00    	je     80104230 <sleep+0xf0>
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010417d:	81 fb 20 2d 11 80    	cmp    $0x80112d20,%ebx
80104183:	74 18                	je     8010419d <sleep+0x5d>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104185:	83 ec 0c             	sub    $0xc,%esp
80104188:	68 20 2d 11 80       	push   $0x80112d20
8010418d:	e8 ce 0b 00 00       	call   80104d60 <acquire>
    release(lk);
80104192:	89 1c 24             	mov    %ebx,(%esp)
80104195:	e8 66 0b 00 00       	call   80104d00 <release>
8010419a:	83 c4 10             	add    $0x10,%esp
  t->chan = chan;
8010419d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801041a0:	89 f8                	mov    %edi,%eax
801041a2:	8d 96 6c 08 00 00    	lea    0x86c(%esi),%edx
801041a8:	c1 e0 05             	shl    $0x5,%eax
801041ab:	89 8c 06 84 00 00 00 	mov    %ecx,0x84(%esi,%eax,1)
  t->state = SLEEPING;
801041b2:	89 f8                	mov    %edi,%eax
801041b4:	c1 e0 05             	shl    $0x5,%eax
801041b7:	c7 44 30 6c 02 00 00 	movl   $0x2,0x6c(%eax,%esi,1)
801041be:	00 
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
801041bf:	8d 46 6c             	lea    0x6c(%esi),%eax
801041c2:	eb 0b                	jmp    801041cf <sleep+0x8f>
801041c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041c8:	83 c0 20             	add    $0x20,%eax
801041cb:	39 c2                	cmp    %eax,%edx
801041cd:	74 49                	je     80104218 <sleep+0xd8>
	if(t->state != UNUSED && t->state != SLEEPING){
801041cf:	f7 00 fd ff ff ff    	testl  $0xfffffffd,(%eax)
801041d5:	74 f1                	je     801041c8 <sleep+0x88>
  sched();
801041d7:	e8 24 fd ff ff       	call   80103f00 <sched>
  t->chan = 0;
801041dc:	89 f9                	mov    %edi,%ecx
801041de:	c1 e1 05             	shl    $0x5,%ecx
801041e1:	c7 84 0e 84 00 00 00 	movl   $0x0,0x84(%esi,%ecx,1)
801041e8:	00 00 00 00 
  if(lk != &ptable.lock){  //DOC: sleeplock2
801041ec:	81 fb 20 2d 11 80    	cmp    $0x80112d20,%ebx
801041f2:	74 34                	je     80104228 <sleep+0xe8>
    release(&ptable.lock);
801041f4:	83 ec 0c             	sub    $0xc,%esp
801041f7:	68 20 2d 11 80       	push   $0x80112d20
801041fc:	e8 ff 0a 00 00       	call   80104d00 <release>
    acquire(lk);
80104201:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104204:	83 c4 10             	add    $0x10,%esp
}
80104207:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010420a:	5b                   	pop    %ebx
8010420b:	5e                   	pop    %esi
8010420c:	5f                   	pop    %edi
8010420d:	5d                   	pop    %ebp
    acquire(lk);
8010420e:	e9 4d 0b 00 00       	jmp    80104d60 <acquire>
80104213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104217:	90                   	nop
	p->state = SLEEPING;
80104218:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)
8010421f:	eb b6                	jmp    801041d7 <sleep+0x97>
80104221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80104228:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010422b:	5b                   	pop    %ebx
8010422c:	5e                   	pop    %esi
8010422d:	5f                   	pop    %edi
8010422e:	5d                   	pop    %ebp
8010422f:	c3                   	ret    
    panic("sleep without lk");
80104230:	83 ec 0c             	sub    $0xc,%esp
80104233:	68 3e 7f 10 80       	push   $0x80107f3e
80104238:	e8 43 c1 ff ff       	call   80100380 <panic>
    panic("sleep (p)");
8010423d:	83 ec 0c             	sub    $0xc,%esp
80104240:	68 34 7f 10 80       	push   $0x80107f34
80104245:	e8 36 c1 ff ff       	call   80100380 <panic>
8010424a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104250 <wait>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	57                   	push   %edi
80104254:	56                   	push   %esi
80104255:	53                   	push   %ebx
80104256:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104259:	e8 b2 09 00 00       	call   80104c10 <pushcli>
  c = mycpu();
8010425e:	e8 3d f8 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80104263:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104269:	e8 f2 09 00 00       	call   80104c60 <popcli>
  acquire(&ptable.lock);
8010426e:	83 ec 0c             	sub    $0xc,%esp
80104271:	68 20 2d 11 80       	push   $0x80112d20
80104276:	e8 e5 0a 00 00       	call   80104d60 <acquire>
8010427b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010427e:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104280:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
80104285:	eb 17                	jmp    8010429e <wait+0x4e>
80104287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010428e:	66 90                	xchg   %ax,%ax
80104290:	81 c7 70 08 00 00    	add    $0x870,%edi
80104296:	81 ff 54 49 13 80    	cmp    $0x80134954,%edi
8010429c:	74 1e                	je     801042bc <wait+0x6c>
      if(p->parent != curproc)
8010429e:	39 5f 10             	cmp    %ebx,0x10(%edi)
801042a1:	75 ed                	jne    80104290 <wait+0x40>
      if(p->state == ZOMBIE){
801042a3:	83 7f 08 05          	cmpl   $0x5,0x8(%edi)
801042a7:	74 3f                	je     801042e8 <wait+0x98>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042a9:	81 c7 70 08 00 00    	add    $0x870,%edi
      havekids = 1;
801042af:	ba 01 00 00 00       	mov    $0x1,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b4:	81 ff 54 49 13 80    	cmp    $0x80134954,%edi
801042ba:	75 e2                	jne    8010429e <wait+0x4e>
    if(!havekids || curproc->killed){
801042bc:	85 d2                	test   %edx,%edx
801042be:	0f 84 b2 00 00 00    	je     80104376 <wait+0x126>
801042c4:	8b 43 14             	mov    0x14(%ebx),%eax
801042c7:	85 c0                	test   %eax,%eax
801042c9:	0f 85 a7 00 00 00    	jne    80104376 <wait+0x126>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801042cf:	83 ec 08             	sub    $0x8,%esp
801042d2:	68 20 2d 11 80       	push   $0x80112d20
801042d7:	53                   	push   %ebx
801042d8:	e8 63 fe ff ff       	call   80104140 <sleep>
    havekids = 0;
801042dd:	83 c4 10             	add    $0x10,%esp
801042e0:	eb 9c                	jmp    8010427e <wait+0x2e>
801042e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        pid = p->pid;
801042e8:	8b 47 0c             	mov    0xc(%edi),%eax
801042eb:	8d 5f 6c             	lea    0x6c(%edi),%ebx
801042ee:	8d b7 6c 08 00 00    	lea    0x86c(%edi),%esi
801042f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(int i = 0; i < NTHREAD; i++){
801042f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042fe:	66 90                	xchg   %ax,%ax
			kfree(t->kstack);
80104300:	83 ec 0c             	sub    $0xc,%esp
80104303:	ff 73 08             	push   0x8(%ebx)
		for(int i = 0; i < NTHREAD; i++){
80104306:	83 c3 20             	add    $0x20,%ebx
			kfree(t->kstack);
80104309:	e8 a2 e2 ff ff       	call   801025b0 <kfree>
			t->kstack = 0;
8010430e:	c7 43 e8 00 00 00 00 	movl   $0x0,-0x18(%ebx)
		for(int i = 0; i < NTHREAD; i++){
80104315:	83 c4 10             	add    $0x10,%esp
			t->tid = 0;
80104318:	c7 43 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebx)
			t->ret = 0;
8010431f:	c7 43 fc 00 00 00 00 	movl   $0x0,-0x4(%ebx)
			t->state = UNUSED;
80104326:	c7 43 e0 00 00 00 00 	movl   $0x0,-0x20(%ebx)
		for(int i = 0; i < NTHREAD; i++){
8010432d:	39 f3                	cmp    %esi,%ebx
8010432f:	75 cf                	jne    80104300 <wait+0xb0>
        freevm(p->pgdir); // t->ustack are also freed
80104331:	83 ec 0c             	sub    $0xc,%esp
80104334:	ff 77 04             	push   0x4(%edi)
80104337:	e8 24 32 00 00       	call   80107560 <freevm>
        release(&ptable.lock);
8010433c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80104343:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
        p->parent = 0;
8010434a:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
        p->name[0] = 0;
80104351:	c6 47 5c 00          	movb   $0x0,0x5c(%edi)
        p->killed = 0;
80104355:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
        p->state = UNUSED;
8010435c:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
        release(&ptable.lock);
80104363:	e8 98 09 00 00       	call   80104d00 <release>
        return pid;
80104368:	83 c4 10             	add    $0x10,%esp
}
8010436b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010436e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104371:	5b                   	pop    %ebx
80104372:	5e                   	pop    %esi
80104373:	5f                   	pop    %edi
80104374:	5d                   	pop    %ebp
80104375:	c3                   	ret    
      release(&ptable.lock);
80104376:	83 ec 0c             	sub    $0xc,%esp
80104379:	68 20 2d 11 80       	push   $0x80112d20
8010437e:	e8 7d 09 00 00       	call   80104d00 <release>
      return -1;
80104383:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
8010438a:	83 c4 10             	add    $0x10,%esp
8010438d:	eb dc                	jmp    8010436b <wait+0x11b>
8010438f:	90                   	nop

80104390 <wakeup>:
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	53                   	push   %ebx
80104394:	83 ec 10             	sub    $0x10,%esp
80104397:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010439a:	68 20 2d 11 80       	push   $0x80112d20
8010439f:	e8 bc 09 00 00       	call   80104d60 <acquire>
  wakeup1(chan);
801043a4:	89 d8                	mov    %ebx,%eax
801043a6:	e8 65 f6 ff ff       	call   80103a10 <wakeup1>
  release(&ptable.lock);
801043ab:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801043b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&ptable.lock);
801043b5:	83 c4 10             	add    $0x10,%esp
}
801043b8:	c9                   	leave  
  release(&ptable.lock);
801043b9:	e9 42 09 00 00       	jmp    80104d00 <release>
801043be:	66 90                	xchg   %ax,%ax

801043c0 <kill>:
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	53                   	push   %ebx
801043c4:	83 ec 10             	sub    $0x10,%esp
801043c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043ca:	68 20 2d 11 80       	push   $0x80112d20
801043cf:	e8 8c 09 00 00       	call   80104d60 <acquire>
801043d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d7:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801043dc:	eb 10                	jmp    801043ee <kill+0x2e>
801043de:	66 90                	xchg   %ax,%ax
801043e0:	81 c2 70 08 00 00    	add    $0x870,%edx
801043e6:	81 fa 54 49 13 80    	cmp    $0x80134954,%edx
801043ec:	74 50                	je     8010443e <kill+0x7e>
    if(p->pid == pid){
801043ee:	39 5a 0c             	cmp    %ebx,0xc(%edx)
801043f1:	75 ed                	jne    801043e0 <kill+0x20>
      p->killed = 1;
801043f3:	c7 42 14 01 00 00 00 	movl   $0x1,0x14(%edx)
	  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
801043fa:	8d 42 6c             	lea    0x6c(%edx),%eax
801043fd:	8d 8a 6c 08 00 00    	lea    0x86c(%edx),%ecx
80104403:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104407:	90                   	nop
		if(t->state == SLEEPING)
80104408:	83 38 02             	cmpl   $0x2,(%eax)
8010440b:	75 06                	jne    80104413 <kill+0x53>
		  t->state = RUNNABLE;
8010440d:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
	  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
80104413:	83 c0 20             	add    $0x20,%eax
80104416:	39 c1                	cmp    %eax,%ecx
80104418:	75 ee                	jne    80104408 <kill+0x48>
      if(p->state == SLEEPING)
8010441a:	83 7a 08 02          	cmpl   $0x2,0x8(%edx)
8010441e:	75 07                	jne    80104427 <kill+0x67>
        p->state = RUNNABLE;
80104420:	c7 42 08 03 00 00 00 	movl   $0x3,0x8(%edx)
      release(&ptable.lock);
80104427:	83 ec 0c             	sub    $0xc,%esp
8010442a:	68 20 2d 11 80       	push   $0x80112d20
8010442f:	e8 cc 08 00 00       	call   80104d00 <release>
}
80104434:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104437:	83 c4 10             	add    $0x10,%esp
8010443a:	31 c0                	xor    %eax,%eax
}
8010443c:	c9                   	leave  
8010443d:	c3                   	ret    
  release(&ptable.lock);
8010443e:	83 ec 0c             	sub    $0xc,%esp
80104441:	68 20 2d 11 80       	push   $0x80112d20
80104446:	e8 b5 08 00 00       	call   80104d00 <release>
}
8010444b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
8010444e:	83 c4 10             	add    $0x10,%esp
80104451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104456:	c9                   	leave  
80104457:	c3                   	ret    
80104458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010445f:	90                   	nop

80104460 <procdump>:
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	57                   	push   %edi
80104464:	56                   	push   %esi
80104465:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104466:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
8010446b:	83 ec 3c             	sub    $0x3c,%esp
8010446e:	eb 22                	jmp    80104492 <procdump+0x32>
    cprintf("\n");
80104470:	83 ec 0c             	sub    $0xc,%esp
80104473:	68 41 83 10 80       	push   $0x80108341
80104478:	e8 23 c2 ff ff       	call   801006a0 <cprintf>
8010447d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104480:	81 c3 70 08 00 00    	add    $0x870,%ebx
80104486:	81 fb 54 49 13 80    	cmp    $0x80134954,%ebx
8010448c:	0f 84 9e 00 00 00    	je     80104530 <procdump+0xd0>
    if(p->state == UNUSED)
80104492:	8b 43 08             	mov    0x8(%ebx),%eax
80104495:	85 c0                	test   %eax,%eax
80104497:	74 e7                	je     80104480 <procdump+0x20>
	t = &p->threads[p->curtidx];
80104499:	8b bb 6c 08 00 00    	mov    0x86c(%ebx),%edi
      state = "???";
8010449f:	b8 4f 7f 10 80       	mov    $0x80107f4f,%eax
801044a4:	89 fe                	mov    %edi,%esi
801044a6:	c1 e6 05             	shl    $0x5,%esi
801044a9:	01 de                	add    %ebx,%esi
    if(t->state >= 0 && t->state < NELEM(states) && states[t->state])
801044ab:	8b 56 6c             	mov    0x6c(%esi),%edx
801044ae:	83 fa 05             	cmp    $0x5,%edx
801044b1:	77 11                	ja     801044c4 <procdump+0x64>
801044b3:	8b 04 95 4c 80 10 80 	mov    -0x7fef7fb4(,%edx,4),%eax
      state = "???";
801044ba:	ba 4f 7f 10 80       	mov    $0x80107f4f,%edx
801044bf:	85 c0                	test   %eax,%eax
801044c1:	0f 44 c2             	cmove  %edx,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
801044c4:	8d 53 5c             	lea    0x5c(%ebx),%edx
801044c7:	52                   	push   %edx
801044c8:	50                   	push   %eax
801044c9:	ff 73 0c             	push   0xc(%ebx)
801044cc:	68 53 7f 10 80       	push   $0x80107f53
801044d1:	e8 ca c1 ff ff       	call   801006a0 <cprintf>
    if(t->state == SLEEPING){
801044d6:	83 c4 10             	add    $0x10,%esp
801044d9:	83 7e 6c 02          	cmpl   $0x2,0x6c(%esi)
801044dd:	75 91                	jne    80104470 <procdump+0x10>
      getcallerpcs((uint*)t->context->ebp+2, pc);
801044df:	83 ec 08             	sub    $0x8,%esp
801044e2:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044e5:	c1 e7 05             	shl    $0x5,%edi
801044e8:	8d 75 c0             	lea    -0x40(%ebp),%esi
801044eb:	50                   	push   %eax
801044ec:	8b 44 3b 7c          	mov    0x7c(%ebx,%edi,1),%eax
801044f0:	8b 40 0c             	mov    0xc(%eax),%eax
801044f3:	83 c0 08             	add    $0x8,%eax
801044f6:	50                   	push   %eax
801044f7:	e8 b4 06 00 00       	call   80104bb0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801044fc:	83 c4 10             	add    $0x10,%esp
801044ff:	90                   	nop
80104500:	8b 06                	mov    (%esi),%eax
80104502:	85 c0                	test   %eax,%eax
80104504:	0f 84 66 ff ff ff    	je     80104470 <procdump+0x10>
        cprintf(" %p", pc[i]);
8010450a:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010450d:	83 c6 04             	add    $0x4,%esi
        cprintf(" %p", pc[i]);
80104510:	50                   	push   %eax
80104511:	68 81 79 10 80       	push   $0x80107981
80104516:	e8 85 c1 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010451b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010451e:	83 c4 10             	add    $0x10,%esp
80104521:	39 f0                	cmp    %esi,%eax
80104523:	75 db                	jne    80104500 <procdump+0xa0>
80104525:	e9 46 ff ff ff       	jmp    80104470 <procdump+0x10>
8010452a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80104530:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104533:	5b                   	pop    %ebx
80104534:	5e                   	pop    %esi
80104535:	5f                   	pop    %edi
80104536:	5d                   	pop    %ebp
80104537:	c3                   	ret    
80104538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010453f:	90                   	nop

80104540 <thread_create>:
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	57                   	push   %edi
80104544:	56                   	push   %esi
80104545:	53                   	push   %ebx
80104546:	81 ec ac 00 00 00    	sub    $0xac,%esp
  pushcli();
8010454c:	e8 bf 06 00 00       	call   80104c10 <pushcli>
  c = mycpu();
80104551:	e8 4a f5 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80104556:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010455c:	e8 ff 06 00 00       	call   80104c60 <popcli>
  acquire(&ptable.lock);
80104561:	83 ec 0c             	sub    $0xc,%esp
80104564:	68 20 2d 11 80       	push   $0x80112d20
  for(nt = p->threads; nt < &p->threads[NTHREAD]; nt++){
80104569:	8d 5e 6c             	lea    0x6c(%esi),%ebx
  acquire(&ptable.lock);
8010456c:	e8 ef 07 00 00       	call   80104d60 <acquire>
  for(nt = p->threads; nt < &p->threads[NTHREAD]; nt++){
80104571:	8d 86 6c 08 00 00    	lea    0x86c(%esi),%eax
80104577:	83 c4 10             	add    $0x10,%esp
8010457a:	eb 0f                	jmp    8010458b <thread_create+0x4b>
8010457c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104580:	83 c3 20             	add    $0x20,%ebx
80104583:	39 c3                	cmp    %eax,%ebx
80104585:	0f 84 75 01 00 00    	je     80104700 <thread_create+0x1c0>
	if(nt->state == UNUSED)
8010458b:	8b 0b                	mov    (%ebx),%ecx
8010458d:	85 c9                	test   %ecx,%ecx
8010458f:	75 ef                	jne    80104580 <thread_create+0x40>
  nt->state = EMBRYO;
80104591:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  nt->tid = nexttid++;
80104597:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  release(&ptable.lock);
8010459c:	83 ec 0c             	sub    $0xc,%esp
  nt->tid = nexttid++;
8010459f:	89 43 04             	mov    %eax,0x4(%ebx)
801045a2:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801045a5:	68 20 2d 11 80       	push   $0x80112d20
  nt->tid = nexttid++;
801045aa:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801045b0:	e8 4b 07 00 00       	call   80104d00 <release>
  if((nt->kstack = kalloc()) == 0){
801045b5:	e8 b6 e1 ff ff       	call   80102770 <kalloc>
801045ba:	83 c4 10             	add    $0x10,%esp
801045bd:	89 43 08             	mov    %eax,0x8(%ebx)
801045c0:	85 c0                	test   %eax,%eax
801045c2:	0f 84 6c 01 00 00    	je     80104734 <thread_create+0x1f4>
  sp -= sizeof *nt->tf;
801045c8:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(nt->context, 0, sizeof *nt->context);
801045ce:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *nt->context;
801045d1:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *nt->tf;
801045d6:	89 53 0c             	mov    %edx,0xc(%ebx)
  *(uint*)sp = (uint)trapret;
801045d9:	c7 40 14 e2 5f 10 80 	movl   $0x80105fe2,0x14(%eax)
  nt->context = (struct context*)sp;
801045e0:	89 43 10             	mov    %eax,0x10(%ebx)
  memset(nt->context, 0, sizeof *nt->context);
801045e3:	6a 14                	push   $0x14
801045e5:	6a 00                	push   $0x0
801045e7:	50                   	push   %eax
801045e8:	e8 33 08 00 00       	call   80104e20 <memset>
  nt->context->eip = (uint)forkret;
801045ed:	8b 43 10             	mov    0x10(%ebx),%eax
  if((sz = allocuvm(p->pgdir, sz, sz + 2*PGSIZE)) == 0){
801045f0:	83 c4 0c             	add    $0xc,%esp
  nt->context->eip = (uint)forkret;
801045f3:	c7 40 10 c0 39 10 80 	movl   $0x801039c0,0x10(%eax)
  uint sz = PGROUNDUP(p->sz);
801045fa:	8b 06                	mov    (%esi),%eax
801045fc:	05 ff 0f 00 00       	add    $0xfff,%eax
80104601:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(p->pgdir, sz, sz + 2*PGSIZE)) == 0){
80104606:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
8010460c:	52                   	push   %edx
8010460d:	50                   	push   %eax
8010460e:	ff 76 04             	push   0x4(%esi)
80104611:	e8 ea 2d 00 00       	call   80107400 <allocuvm>
80104616:	83 c4 10             	add    $0x10,%esp
80104619:	89 c7                	mov    %eax,%edi
8010461b:	85 c0                	test   %eax,%eax
8010461d:	0f 84 fa 00 00 00    	je     8010471d <thread_create+0x1dd>
  clearpteu(p->pgdir, (char*)(sz - 2*PGSIZE));
80104623:	83 ec 08             	sub    $0x8,%esp
80104626:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
8010462c:	50                   	push   %eax
8010462d:	ff 76 04             	push   0x4(%esi)
80104630:	e8 4b 30 00 00       	call   80107680 <clearpteu>
  usp = (usp - (strlen(arg) + 1)) & ~3;
80104635:	58                   	pop    %eax
80104636:	ff 75 10             	push   0x10(%ebp)
80104639:	e8 e2 09 00 00       	call   80105020 <strlen>
8010463e:	8d 57 ff             	lea    -0x1(%edi),%edx
80104641:	29 c2                	sub    %eax,%edx
80104643:	83 e2 fc             	and    $0xfffffffc,%edx
80104646:	89 95 54 ff ff ff    	mov    %edx,-0xac(%ebp)
  if(copyout(p->pgdir, usp, arg, strlen(arg) + 1) < 0){
8010464c:	5a                   	pop    %edx
8010464d:	ff 75 10             	push   0x10(%ebp)
80104650:	e8 cb 09 00 00       	call   80105020 <strlen>
80104655:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
8010465b:	83 c0 01             	add    $0x1,%eax
8010465e:	50                   	push   %eax
8010465f:	ff 75 10             	push   0x10(%ebp)
80104662:	52                   	push   %edx
80104663:	ff 76 04             	push   0x4(%esi)
80104666:	e8 e5 31 00 00       	call   80107850 <copyout>
8010466b:	83 c4 20             	add    $0x20,%esp
8010466e:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
80104674:	85 c0                	test   %eax,%eax
80104676:	0f 88 c5 00 00 00    	js     80104741 <thread_create+0x201>
  ustack[2] = usp - (argc+1)*4; // arg pointer
8010467c:	8d 42 f8             	lea    -0x8(%edx),%eax
  usp -= (3+argc+1) * 4;
8010467f:	8d 4a ec             	lea    -0x14(%edx),%ecx
  if(copyout(p->pgdir, usp, ustack, (3+argc+1)*4) < 0){
80104682:	6a 14                	push   $0x14
  ustack[2] = usp - (argc+1)*4; // arg pointer
80104684:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(p->pgdir, usp, ustack, (3+argc+1)*4) < 0){
8010468a:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80104690:	50                   	push   %eax
  ustack[3] = usp;
80104691:	89 95 64 ff ff ff    	mov    %edx,-0x9c(%ebp)
  if(copyout(p->pgdir, usp, ustack, (3+argc+1)*4) < 0){
80104697:	51                   	push   %ecx
  ustack[3+argc] = 0;
80104698:	c7 85 68 ff ff ff 00 	movl   $0x0,-0x98(%ebp)
8010469f:	00 00 00 
  ustack[1] = 1;
801046a2:	c7 85 5c ff ff ff 01 	movl   $0x1,-0xa4(%ebp)
801046a9:	00 00 00 
  if(copyout(p->pgdir, usp, ustack, (3+argc+1)*4) < 0){
801046ac:	ff 76 04             	push   0x4(%esi)
801046af:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
  ustack[0] = 0xFFFFFFFF;	// fake return PC
801046b5:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801046bc:	ff ff ff 
  if(copyout(p->pgdir, usp, ustack, (3+argc+1)*4) < 0){
801046bf:	e8 8c 31 00 00       	call   80107850 <copyout>
801046c4:	83 c4 10             	add    $0x10,%esp
801046c7:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
801046cd:	85 c0                	test   %eax,%eax
801046cf:	0f 88 83 00 00 00    	js     80104758 <thread_create+0x218>
  p->sz = sz;
801046d5:	89 3e                	mov    %edi,(%esi)
  nt->tf->eip = (uint)start_routine;	// start_routine
801046d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801046da:	8b 43 0c             	mov    0xc(%ebx),%eax
  nt->ustackp = sz;
801046dd:	89 7b 14             	mov    %edi,0x14(%ebx)
  nt->tf->eip = (uint)start_routine;	// start_routine
801046e0:	89 50 38             	mov    %edx,0x38(%eax)
  nt->tf->esp = usp;
801046e3:	8b 43 0c             	mov    0xc(%ebx),%eax
801046e6:	89 48 44             	mov    %ecx,0x44(%eax)
  *thread = nt->tid;
801046e9:	8b 45 08             	mov    0x8(%ebp),%eax
801046ec:	8b 53 04             	mov    0x4(%ebx),%edx
801046ef:	89 10                	mov    %edx,(%eax)
  return 0;
801046f1:	31 c0                	xor    %eax,%eax
}
801046f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046f6:	5b                   	pop    %ebx
801046f7:	5e                   	pop    %esi
801046f8:	5f                   	pop    %edi
801046f9:	5d                   	pop    %ebp
801046fa:	c3                   	ret    
801046fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046ff:	90                   	nop
  release(&ptable.lock);
80104700:	83 ec 0c             	sub    $0xc,%esp
80104703:	68 20 2d 11 80       	push   $0x80112d20
80104708:	e8 f3 05 00 00       	call   80104d00 <release>
  return -1;
8010470d:	83 c4 10             	add    $0x10,%esp
}
80104710:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104713:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104718:	5b                   	pop    %ebx
80104719:	5e                   	pop    %esi
8010471a:	5f                   	pop    %edi
8010471b:	5d                   	pop    %ebp
8010471c:	c3                   	ret    
	cprintf("thread_create() fail\n");
8010471d:	83 ec 0c             	sub    $0xc,%esp
80104720:	68 5c 7f 10 80       	push   $0x80107f5c
80104725:	e8 76 bf ff ff       	call   801006a0 <cprintf>
	return -1;
8010472a:	83 c4 10             	add    $0x10,%esp
8010472d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104732:	eb bf                	jmp    801046f3 <thread_create+0x1b3>
	nt->state = UNUSED;
80104734:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -1;
8010473a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010473f:	eb b2                	jmp    801046f3 <thread_create+0x1b3>
	cprintf("thread_create() fail: arg copy fail\n");
80104741:	83 ec 0c             	sub    $0xc,%esp
80104744:	68 d0 7f 10 80       	push   $0x80107fd0
80104749:	e8 52 bf ff ff       	call   801006a0 <cprintf>
	return -1;
8010474e:	83 c4 10             	add    $0x10,%esp
80104751:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104756:	eb 9b                	jmp    801046f3 <thread_create+0x1b3>
	cprintf("thread_create() fail: ustack->vm copy fail\n");
80104758:	83 ec 0c             	sub    $0xc,%esp
8010475b:	68 f8 7f 10 80       	push   $0x80107ff8
80104760:	e8 3b bf ff ff       	call   801006a0 <cprintf>
	return -1;
80104765:	83 c4 10             	add    $0x10,%esp
80104768:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010476d:	eb 84                	jmp    801046f3 <thread_create+0x1b3>
8010476f:	90                   	nop

80104770 <thread_exit>:
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	56                   	push   %esi
80104774:	53                   	push   %ebx
80104775:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104778:	e8 93 04 00 00       	call   80104c10 <pushcli>
  c = mycpu();
8010477d:	e8 1e f3 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80104782:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104788:	e8 d3 04 00 00       	call   80104c60 <popcli>
  acquire(&ptable.lock);
8010478d:	83 ec 0c             	sub    $0xc,%esp
80104790:	68 20 2d 11 80       	push   $0x80112d20
80104795:	e8 c6 05 00 00       	call   80104d60 <acquire>
  t->state = ZOMBIE;
8010479a:	8b 83 6c 08 00 00    	mov    0x86c(%ebx),%eax
801047a0:	c1 e0 05             	shl    $0x5,%eax
801047a3:	01 d8                	add    %ebx,%eax
  t->ret = retval;
801047a5:	89 b0 88 00 00 00    	mov    %esi,0x88(%eax)
  t->state = ZOMBIE;
801047ab:	c7 40 6c 05 00 00 00 	movl   $0x5,0x6c(%eax)
  wakeup1((void*)t->tid);
801047b2:	8b 40 70             	mov    0x70(%eax),%eax
801047b5:	e8 56 f2 ff ff       	call   80103a10 <wakeup1>
  sched();
801047ba:	83 c4 10             	add    $0x10,%esp
}
801047bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047c0:	5b                   	pop    %ebx
801047c1:	5e                   	pop    %esi
801047c2:	5d                   	pop    %ebp
  sched();
801047c3:	e9 38 f7 ff ff       	jmp    80103f00 <sched>
801047c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047cf:	90                   	nop

801047d0 <thread_join>:
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	57                   	push   %edi
801047d4:	56                   	push   %esi
801047d5:	53                   	push   %ebx
801047d6:	83 ec 28             	sub    $0x28,%esp
801047d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&ptable.lock);
801047dc:	68 20 2d 11 80       	push   $0x80112d20
801047e1:	e8 7a 05 00 00       	call   80104d60 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047e6:	b8 c0 35 11 80       	mov    $0x801135c0,%eax
801047eb:	ba c0 51 13 80       	mov    $0x801351c0,%edx
801047f0:	83 c4 10             	add    $0x10,%esp
	for(t = p->threads; t < &p->threads[NTHREAD]; t++)
801047f3:	8d 98 00 f8 ff ff    	lea    -0x800(%eax),%ebx
801047f9:	eb 10                	jmp    8010480b <thread_join+0x3b>
801047fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047ff:	90                   	nop
80104800:	83 c3 20             	add    $0x20,%ebx
80104803:	39 c3                	cmp    %eax,%ebx
80104805:	0f 84 c8 00 00 00    	je     801048d3 <thread_join+0x103>
	  if(t->tid == tid)
8010480b:	8b 7b 04             	mov    0x4(%ebx),%edi
8010480e:	39 f7                	cmp    %esi,%edi
80104810:	75 ee                	jne    80104800 <thread_join+0x30>
  while(t->state != ZOMBIE)
80104812:	83 3b 05             	cmpl   $0x5,(%ebx)
80104815:	0f 84 96 00 00 00    	je     801048b1 <thread_join+0xe1>
8010481b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010481f:	90                   	nop
  pushcli();
80104820:	e8 eb 03 00 00       	call   80104c10 <pushcli>
  c = mycpu();
80104825:	e8 76 f2 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
8010482a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104830:	e8 2b 04 00 00       	call   80104c60 <popcli>
  if(p == 0)
80104835:	85 f6                	test   %esi,%esi
80104837:	0f 84 c7 00 00 00    	je     80104904 <thread_join+0x134>
  struct thread *t = &p->threads[p->curtidx];
8010483d:	8b 8e 6c 08 00 00    	mov    0x86c(%esi),%ecx
  t->chan = chan;
80104843:	8d 96 6c 08 00 00    	lea    0x86c(%esi),%edx
80104849:	89 c8                	mov    %ecx,%eax
8010484b:	c1 e0 05             	shl    $0x5,%eax
8010484e:	89 bc 06 84 00 00 00 	mov    %edi,0x84(%esi,%eax,1)
  t->state = SLEEPING;
80104855:	89 c8                	mov    %ecx,%eax
80104857:	c1 e0 05             	shl    $0x5,%eax
8010485a:	c7 44 30 6c 02 00 00 	movl   $0x2,0x6c(%eax,%esi,1)
80104861:	00 
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80104862:	8d 46 6c             	lea    0x6c(%esi),%eax
80104865:	eb 10                	jmp    80104877 <thread_join+0xa7>
80104867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010486e:	66 90                	xchg   %ax,%ax
80104870:	83 c0 20             	add    $0x20,%eax
80104873:	39 d0                	cmp    %edx,%eax
80104875:	74 31                	je     801048a8 <thread_join+0xd8>
	if(t->state != UNUSED && t->state != SLEEPING){
80104877:	f7 00 fd ff ff ff    	testl  $0xfffffffd,(%eax)
8010487d:	74 f1                	je     80104870 <thread_join+0xa0>
8010487f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  sched();
80104882:	e8 79 f6 ff ff       	call   80103f00 <sched>
  t->chan = 0;
80104887:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010488a:	c1 e1 05             	shl    $0x5,%ecx
8010488d:	c7 84 0e 84 00 00 00 	movl   $0x0,0x84(%esi,%ecx,1)
80104894:	00 00 00 00 
  while(t->state != ZOMBIE)
80104898:	83 3b 05             	cmpl   $0x5,(%ebx)
8010489b:	74 14                	je     801048b1 <thread_join+0xe1>
	sleep((void*)t->tid, &ptable.lock);
8010489d:	8b 7b 04             	mov    0x4(%ebx),%edi
801048a0:	e9 7b ff ff ff       	jmp    80104820 <thread_join+0x50>
801048a5:	8d 76 00             	lea    0x0(%esi),%esi
	p->state = SLEEPING;
801048a8:	c7 46 08 02 00 00 00 	movl   $0x2,0x8(%esi)
801048af:	eb ce                	jmp    8010487f <thread_join+0xaf>
  *retval = t->ret;
801048b1:	8b 53 1c             	mov    0x1c(%ebx),%edx
801048b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  release(&ptable.lock);
801048b7:	83 ec 0c             	sub    $0xc,%esp
  *retval = t->ret;
801048ba:	89 10                	mov    %edx,(%eax)
  release(&ptable.lock);
801048bc:	68 20 2d 11 80       	push   $0x80112d20
801048c1:	e8 3a 04 00 00       	call   80104d00 <release>
  return 0;
801048c6:	83 c4 10             	add    $0x10,%esp
801048c9:	31 c0                	xor    %eax,%eax
}
801048cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048ce:	5b                   	pop    %ebx
801048cf:	5e                   	pop    %esi
801048d0:	5f                   	pop    %edi
801048d1:	5d                   	pop    %ebp
801048d2:	c3                   	ret    
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048d3:	8d 83 70 08 00 00    	lea    0x870(%ebx),%eax
801048d9:	39 c2                	cmp    %eax,%edx
801048db:	0f 85 12 ff ff ff    	jne    801047f3 <thread_join+0x23>
  release(&ptable.lock);
801048e1:	83 ec 0c             	sub    $0xc,%esp
801048e4:	68 20 2d 11 80       	push   $0x80112d20
801048e9:	e8 12 04 00 00       	call   80104d00 <release>
  cprintf("thread_join() failed: tid not found\n");
801048ee:	c7 04 24 24 80 10 80 	movl   $0x80108024,(%esp)
801048f5:	e8 a6 bd ff ff       	call   801006a0 <cprintf>
  return -1;
801048fa:	83 c4 10             	add    $0x10,%esp
801048fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104902:	eb c7                	jmp    801048cb <thread_join+0xfb>
    panic("sleep (p)");
80104904:	83 ec 0c             	sub    $0xc,%esp
80104907:	68 34 7f 10 80       	push   $0x80107f34
8010490c:	e8 6f ba ff ff       	call   80100380 <panic>
80104911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010491f:	90                   	nop

80104920 <tscheduler>:
{
80104920:	55                   	push   %ebp
  for(i = next + 1; i < NTHREAD; i++){
80104921:	31 c0                	xor    %eax,%eax
{
80104923:	89 e5                	mov    %esp,%ebp
80104925:	56                   	push   %esi
80104926:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104929:	53                   	push   %ebx
8010492a:	eb 0c                	jmp    80104938 <tscheduler+0x18>
8010492c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = next + 1; i < NTHREAD; i++){
80104930:	83 c0 01             	add    $0x1,%eax
80104933:	83 f8 40             	cmp    $0x40,%eax
80104936:	74 48                	je     80104980 <tscheduler+0x60>
	if(p->threads[i].state == RUNNABLE){
80104938:	89 c2                	mov    %eax,%edx
8010493a:	c1 e2 05             	shl    $0x5,%edx
8010493d:	83 7c 11 6c 03       	cmpl   $0x3,0x6c(%ecx,%edx,1)
80104942:	75 ec                	jne    80104930 <tscheduler+0x10>
80104944:	8d 70 01             	lea    0x1(%eax),%esi
  for(i = 0; i < next + 1; i++){
80104947:	31 d2                	xor    %edx,%edx
80104949:	eb 0c                	jmp    80104957 <tscheduler+0x37>
8010494b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010494f:	90                   	nop
80104950:	83 c2 01             	add    $0x1,%edx
80104953:	39 f2                	cmp    %esi,%edx
80104955:	74 19                	je     80104970 <tscheduler+0x50>
	if(p->threads[i].state == RUNNABLE){
80104957:	89 d3                	mov    %edx,%ebx
80104959:	c1 e3 05             	shl    $0x5,%ebx
8010495c:	83 7c 19 6c 03       	cmpl   $0x3,0x6c(%ecx,%ebx,1)
80104961:	75 ed                	jne    80104950 <tscheduler+0x30>
}
80104963:	5b                   	pop    %ebx
80104964:	89 d0                	mov    %edx,%eax
80104966:	5e                   	pop    %esi
80104967:	5d                   	pop    %ebp
80104968:	c3                   	ret    
80104969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104970:	89 c2                	mov    %eax,%edx
80104972:	5b                   	pop    %ebx
80104973:	5e                   	pop    %esi
80104974:	89 d0                	mov    %edx,%eax
80104976:	5d                   	pop    %ebp
80104977:	c3                   	ret    
80104978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497f:	90                   	nop
  int next = -1;
80104980:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
80104985:	5b                   	pop    %ebx
80104986:	5e                   	pop    %esi
80104987:	89 d0                	mov    %edx,%eax
80104989:	5d                   	pop    %ebp
8010498a:	c3                   	ret    
8010498b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010498f:	90                   	nop

80104990 <setpstate>:
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	53                   	push   %ebx
80104994:	83 ec 04             	sub    $0x4,%esp
80104997:	8b 45 0c             	mov    0xc(%ebp),%eax
8010499a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  switch(check){
8010499d:	83 f8 03             	cmp    $0x3,%eax
801049a0:	74 1e                	je     801049c0 <setpstate+0x30>
801049a2:	83 f8 05             	cmp    $0x5,%eax
801049a5:	74 71                	je     80104a18 <setpstate+0x88>
801049a7:	83 f8 02             	cmp    $0x2,%eax
801049aa:	74 44                	je     801049f0 <setpstate+0x60>
	  panic("setpstate");
801049ac:	83 ec 0c             	sub    $0xc,%esp
801049af:	68 72 7f 10 80       	push   $0x80107f72
801049b4:	e8 c7 b9 ff ff       	call   80100380 <panic>
801049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
801049c0:	8d 41 6c             	lea    0x6c(%ecx),%eax
801049c3:	8d 91 6c 08 00 00    	lea    0x86c(%ecx),%edx
801049c9:	eb 0c                	jmp    801049d7 <setpstate+0x47>
801049cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049cf:	90                   	nop
801049d0:	83 c0 20             	add    $0x20,%eax
801049d3:	39 c2                	cmp    %eax,%edx
801049d5:	74 0c                	je     801049e3 <setpstate+0x53>
	if(t->state == RUNNABLE){
801049d7:	83 38 03             	cmpl   $0x3,(%eax)
801049da:	75 f4                	jne    801049d0 <setpstate+0x40>
	p->state = RUNNABLE;
801049dc:	c7 41 08 03 00 00 00 	movl   $0x3,0x8(%ecx)
  return;
}
801049e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049e6:	c9                   	leave  
801049e7:	c3                   	ret    
801049e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ef:	90                   	nop
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
801049f0:	8d 41 6c             	lea    0x6c(%ecx),%eax
801049f3:	8d 91 6c 08 00 00    	lea    0x86c(%ecx),%edx
801049f9:	eb 0c                	jmp    80104a07 <setpstate+0x77>
801049fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049ff:	90                   	nop
80104a00:	83 c0 20             	add    $0x20,%eax
80104a03:	39 c2                	cmp    %eax,%edx
80104a05:	74 49                	je     80104a50 <setpstate+0xc0>
	if(t->state != UNUSED && t->state != SLEEPING){
80104a07:	f7 00 fd ff ff ff    	testl  $0xfffffffd,(%eax)
80104a0d:	74 f1                	je     80104a00 <setpstate+0x70>
}
80104a0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a12:	c9                   	leave  
80104a13:	c3                   	ret    
80104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80104a18:	8d 41 6c             	lea    0x6c(%ecx),%eax
80104a1b:	8d 99 6c 08 00 00    	lea    0x86c(%ecx),%ebx
80104a21:	eb 0c                	jmp    80104a2f <setpstate+0x9f>
80104a23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a27:	90                   	nop
80104a28:	83 c0 20             	add    $0x20,%eax
80104a2b:	39 c3                	cmp    %eax,%ebx
80104a2d:	74 11                	je     80104a40 <setpstate+0xb0>
	if(t->state != UNUSED && t->state != ZOMBIE){
80104a2f:	8b 10                	mov    (%eax),%edx
80104a31:	85 d2                	test   %edx,%edx
80104a33:	74 f3                	je     80104a28 <setpstate+0x98>
80104a35:	83 fa 05             	cmp    $0x5,%edx
80104a38:	74 ee                	je     80104a28 <setpstate+0x98>
}
80104a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a3d:	c9                   	leave  
80104a3e:	c3                   	ret    
80104a3f:	90                   	nop
	p->state = ZOMBIE;
80104a40:	c7 41 08 05 00 00 00 	movl   $0x5,0x8(%ecx)
}
80104a47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a4a:	c9                   	leave  
80104a4b:	c3                   	ret    
80104a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	p->state = SLEEPING;
80104a50:	c7 41 08 02 00 00 00 	movl   $0x2,0x8(%ecx)
}
80104a57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a5a:	c9                   	leave  
80104a5b:	c3                   	ret    
80104a5c:	66 90                	xchg   %ax,%ax
80104a5e:	66 90                	xchg   %ax,%ax

80104a60 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	53                   	push   %ebx
80104a64:	83 ec 0c             	sub    $0xc,%esp
80104a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104a6a:	68 64 80 10 80       	push   $0x80108064
80104a6f:	8d 43 04             	lea    0x4(%ebx),%eax
80104a72:	50                   	push   %eax
80104a73:	e8 18 01 00 00       	call   80104b90 <initlock>
  lk->name = name;
80104a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104a7b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104a81:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104a84:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104a8b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104a8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a91:	c9                   	leave  
80104a92:	c3                   	ret    
80104a93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104aa0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	56                   	push   %esi
80104aa4:	53                   	push   %ebx
80104aa5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104aa8:	8d 73 04             	lea    0x4(%ebx),%esi
80104aab:	83 ec 0c             	sub    $0xc,%esp
80104aae:	56                   	push   %esi
80104aaf:	e8 ac 02 00 00       	call   80104d60 <acquire>
  while (lk->locked) {
80104ab4:	8b 13                	mov    (%ebx),%edx
80104ab6:	83 c4 10             	add    $0x10,%esp
80104ab9:	85 d2                	test   %edx,%edx
80104abb:	74 16                	je     80104ad3 <acquiresleep+0x33>
80104abd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104ac0:	83 ec 08             	sub    $0x8,%esp
80104ac3:	56                   	push   %esi
80104ac4:	53                   	push   %ebx
80104ac5:	e8 76 f6 ff ff       	call   80104140 <sleep>
  while (lk->locked) {
80104aca:	8b 03                	mov    (%ebx),%eax
80104acc:	83 c4 10             	add    $0x10,%esp
80104acf:	85 c0                	test   %eax,%eax
80104ad1:	75 ed                	jne    80104ac0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104ad3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104ad9:	e8 42 f0 ff ff       	call   80103b20 <myproc>
80104ade:	8b 40 0c             	mov    0xc(%eax),%eax
80104ae1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104ae4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104ae7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104aea:	5b                   	pop    %ebx
80104aeb:	5e                   	pop    %esi
80104aec:	5d                   	pop    %ebp
  release(&lk->lk);
80104aed:	e9 0e 02 00 00       	jmp    80104d00 <release>
80104af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b00 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	53                   	push   %ebx
80104b05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b08:	8d 73 04             	lea    0x4(%ebx),%esi
80104b0b:	83 ec 0c             	sub    $0xc,%esp
80104b0e:	56                   	push   %esi
80104b0f:	e8 4c 02 00 00       	call   80104d60 <acquire>
  lk->locked = 0;
80104b14:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b1a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104b21:	89 1c 24             	mov    %ebx,(%esp)
80104b24:	e8 67 f8 ff ff       	call   80104390 <wakeup>
  release(&lk->lk);
80104b29:	89 75 08             	mov    %esi,0x8(%ebp)
80104b2c:	83 c4 10             	add    $0x10,%esp
}
80104b2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b32:	5b                   	pop    %ebx
80104b33:	5e                   	pop    %esi
80104b34:	5d                   	pop    %ebp
  release(&lk->lk);
80104b35:	e9 c6 01 00 00       	jmp    80104d00 <release>
80104b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b40 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	31 ff                	xor    %edi,%edi
80104b46:	56                   	push   %esi
80104b47:	53                   	push   %ebx
80104b48:	83 ec 18             	sub    $0x18,%esp
80104b4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104b4e:	8d 73 04             	lea    0x4(%ebx),%esi
80104b51:	56                   	push   %esi
80104b52:	e8 09 02 00 00       	call   80104d60 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104b57:	8b 03                	mov    (%ebx),%eax
80104b59:	83 c4 10             	add    $0x10,%esp
80104b5c:	85 c0                	test   %eax,%eax
80104b5e:	75 18                	jne    80104b78 <holdingsleep+0x38>
  release(&lk->lk);
80104b60:	83 ec 0c             	sub    $0xc,%esp
80104b63:	56                   	push   %esi
80104b64:	e8 97 01 00 00       	call   80104d00 <release>
  return r;
}
80104b69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b6c:	89 f8                	mov    %edi,%eax
80104b6e:	5b                   	pop    %ebx
80104b6f:	5e                   	pop    %esi
80104b70:	5f                   	pop    %edi
80104b71:	5d                   	pop    %ebp
80104b72:	c3                   	ret    
80104b73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b77:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104b78:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104b7b:	e8 a0 ef ff ff       	call   80103b20 <myproc>
80104b80:	39 58 0c             	cmp    %ebx,0xc(%eax)
80104b83:	0f 94 c0             	sete   %al
80104b86:	0f b6 c0             	movzbl %al,%eax
80104b89:	89 c7                	mov    %eax,%edi
80104b8b:	eb d3                	jmp    80104b60 <holdingsleep+0x20>
80104b8d:	66 90                	xchg   %ax,%ax
80104b8f:	90                   	nop

80104b90 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104b96:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104b99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104b9f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104ba2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104ba9:	5d                   	pop    %ebp
80104baa:	c3                   	ret    
80104bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104baf:	90                   	nop

80104bb0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104bb0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104bb1:	31 d2                	xor    %edx,%edx
{
80104bb3:	89 e5                	mov    %esp,%ebp
80104bb5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104bb6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104bb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104bbc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104bbf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104bc0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104bc6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104bcc:	77 1a                	ja     80104be8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104bce:	8b 58 04             	mov    0x4(%eax),%ebx
80104bd1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104bd4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104bd7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104bd9:	83 fa 0a             	cmp    $0xa,%edx
80104bdc:	75 e2                	jne    80104bc0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104bde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104be1:	c9                   	leave  
80104be2:	c3                   	ret    
80104be3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104be7:	90                   	nop
  for(; i < 10; i++)
80104be8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104beb:	8d 51 28             	lea    0x28(%ecx),%edx
80104bee:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104bf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104bf6:	83 c0 04             	add    $0x4,%eax
80104bf9:	39 d0                	cmp    %edx,%eax
80104bfb:	75 f3                	jne    80104bf0 <getcallerpcs+0x40>
}
80104bfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c00:	c9                   	leave  
80104c01:	c3                   	ret    
80104c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c10 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	53                   	push   %ebx
80104c14:	83 ec 04             	sub    $0x4,%esp
80104c17:	9c                   	pushf  
80104c18:	5b                   	pop    %ebx
  asm volatile("cli");
80104c19:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104c1a:	e8 81 ee ff ff       	call   80103aa0 <mycpu>
80104c1f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c25:	85 c0                	test   %eax,%eax
80104c27:	74 17                	je     80104c40 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104c29:	e8 72 ee ff ff       	call   80103aa0 <mycpu>
80104c2e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104c35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c38:	c9                   	leave  
80104c39:	c3                   	ret    
80104c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104c40:	e8 5b ee ff ff       	call   80103aa0 <mycpu>
80104c45:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104c4b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104c51:	eb d6                	jmp    80104c29 <pushcli+0x19>
80104c53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c60 <popcli>:

void
popcli(void)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c66:	9c                   	pushf  
80104c67:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104c68:	f6 c4 02             	test   $0x2,%ah
80104c6b:	75 35                	jne    80104ca2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104c6d:	e8 2e ee ff ff       	call   80103aa0 <mycpu>
80104c72:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104c79:	78 34                	js     80104caf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c7b:	e8 20 ee ff ff       	call   80103aa0 <mycpu>
80104c80:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c86:	85 d2                	test   %edx,%edx
80104c88:	74 06                	je     80104c90 <popcli+0x30>
    sti();
}
80104c8a:	c9                   	leave  
80104c8b:	c3                   	ret    
80104c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c90:	e8 0b ee ff ff       	call   80103aa0 <mycpu>
80104c95:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c9b:	85 c0                	test   %eax,%eax
80104c9d:	74 eb                	je     80104c8a <popcli+0x2a>
  asm volatile("sti");
80104c9f:	fb                   	sti    
}
80104ca0:	c9                   	leave  
80104ca1:	c3                   	ret    
    panic("popcli - interruptible");
80104ca2:	83 ec 0c             	sub    $0xc,%esp
80104ca5:	68 6f 80 10 80       	push   $0x8010806f
80104caa:	e8 d1 b6 ff ff       	call   80100380 <panic>
    panic("popcli");
80104caf:	83 ec 0c             	sub    $0xc,%esp
80104cb2:	68 86 80 10 80       	push   $0x80108086
80104cb7:	e8 c4 b6 ff ff       	call   80100380 <panic>
80104cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cc0 <holding>:
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	56                   	push   %esi
80104cc4:	53                   	push   %ebx
80104cc5:	8b 75 08             	mov    0x8(%ebp),%esi
80104cc8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104cca:	e8 41 ff ff ff       	call   80104c10 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104ccf:	8b 06                	mov    (%esi),%eax
80104cd1:	85 c0                	test   %eax,%eax
80104cd3:	75 0b                	jne    80104ce0 <holding+0x20>
  popcli();
80104cd5:	e8 86 ff ff ff       	call   80104c60 <popcli>
}
80104cda:	89 d8                	mov    %ebx,%eax
80104cdc:	5b                   	pop    %ebx
80104cdd:	5e                   	pop    %esi
80104cde:	5d                   	pop    %ebp
80104cdf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104ce0:	8b 5e 08             	mov    0x8(%esi),%ebx
80104ce3:	e8 b8 ed ff ff       	call   80103aa0 <mycpu>
80104ce8:	39 c3                	cmp    %eax,%ebx
80104cea:	0f 94 c3             	sete   %bl
  popcli();
80104ced:	e8 6e ff ff ff       	call   80104c60 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104cf2:	0f b6 db             	movzbl %bl,%ebx
}
80104cf5:	89 d8                	mov    %ebx,%eax
80104cf7:	5b                   	pop    %ebx
80104cf8:	5e                   	pop    %esi
80104cf9:	5d                   	pop    %ebp
80104cfa:	c3                   	ret    
80104cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cff:	90                   	nop

80104d00 <release>:
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	56                   	push   %esi
80104d04:	53                   	push   %ebx
80104d05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104d08:	e8 03 ff ff ff       	call   80104c10 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d0d:	8b 03                	mov    (%ebx),%eax
80104d0f:	85 c0                	test   %eax,%eax
80104d11:	75 15                	jne    80104d28 <release+0x28>
  popcli();
80104d13:	e8 48 ff ff ff       	call   80104c60 <popcli>
    panic("release");
80104d18:	83 ec 0c             	sub    $0xc,%esp
80104d1b:	68 8d 80 10 80       	push   $0x8010808d
80104d20:	e8 5b b6 ff ff       	call   80100380 <panic>
80104d25:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104d28:	8b 73 08             	mov    0x8(%ebx),%esi
80104d2b:	e8 70 ed ff ff       	call   80103aa0 <mycpu>
80104d30:	39 c6                	cmp    %eax,%esi
80104d32:	75 df                	jne    80104d13 <release+0x13>
  popcli();
80104d34:	e8 27 ff ff ff       	call   80104c60 <popcli>
  lk->pcs[0] = 0;
80104d39:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104d40:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104d47:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104d4c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104d52:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d55:	5b                   	pop    %ebx
80104d56:	5e                   	pop    %esi
80104d57:	5d                   	pop    %ebp
  popcli();
80104d58:	e9 03 ff ff ff       	jmp    80104c60 <popcli>
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi

80104d60 <acquire>:
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	53                   	push   %ebx
80104d64:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104d67:	e8 a4 fe ff ff       	call   80104c10 <pushcli>
  if(holding(lk))
80104d6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104d6f:	e8 9c fe ff ff       	call   80104c10 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d74:	8b 03                	mov    (%ebx),%eax
80104d76:	85 c0                	test   %eax,%eax
80104d78:	75 7e                	jne    80104df8 <acquire+0x98>
  popcli();
80104d7a:	e8 e1 fe ff ff       	call   80104c60 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104d7f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104d88:	8b 55 08             	mov    0x8(%ebp),%edx
80104d8b:	89 c8                	mov    %ecx,%eax
80104d8d:	f0 87 02             	lock xchg %eax,(%edx)
80104d90:	85 c0                	test   %eax,%eax
80104d92:	75 f4                	jne    80104d88 <acquire+0x28>
  __sync_synchronize();
80104d94:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104d99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d9c:	e8 ff ec ff ff       	call   80103aa0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104da1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104da4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104da6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104da9:	31 c0                	xor    %eax,%eax
80104dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104daf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104db0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104db6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104dbc:	77 1a                	ja     80104dd8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104dbe:	8b 5a 04             	mov    0x4(%edx),%ebx
80104dc1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104dc5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104dc8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104dca:	83 f8 0a             	cmp    $0xa,%eax
80104dcd:	75 e1                	jne    80104db0 <acquire+0x50>
}
80104dcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dd2:	c9                   	leave  
80104dd3:	c3                   	ret    
80104dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104dd8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104ddc:	8d 51 34             	lea    0x34(%ecx),%edx
80104ddf:	90                   	nop
    pcs[i] = 0;
80104de0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104de6:	83 c0 04             	add    $0x4,%eax
80104de9:	39 c2                	cmp    %eax,%edx
80104deb:	75 f3                	jne    80104de0 <acquire+0x80>
}
80104ded:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104df0:	c9                   	leave  
80104df1:	c3                   	ret    
80104df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104df8:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104dfb:	e8 a0 ec ff ff       	call   80103aa0 <mycpu>
80104e00:	39 c3                	cmp    %eax,%ebx
80104e02:	0f 85 72 ff ff ff    	jne    80104d7a <acquire+0x1a>
  popcli();
80104e08:	e8 53 fe ff ff       	call   80104c60 <popcli>
    panic("acquire");
80104e0d:	83 ec 0c             	sub    $0xc,%esp
80104e10:	68 95 80 10 80       	push   $0x80108095
80104e15:	e8 66 b5 ff ff       	call   80100380 <panic>
80104e1a:	66 90                	xchg   %ax,%ax
80104e1c:	66 90                	xchg   %ax,%ax
80104e1e:	66 90                	xchg   %ax,%ax

80104e20 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	57                   	push   %edi
80104e24:	8b 55 08             	mov    0x8(%ebp),%edx
80104e27:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e2a:	53                   	push   %ebx
80104e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104e2e:	89 d7                	mov    %edx,%edi
80104e30:	09 cf                	or     %ecx,%edi
80104e32:	83 e7 03             	and    $0x3,%edi
80104e35:	75 29                	jne    80104e60 <memset+0x40>
    c &= 0xFF;
80104e37:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104e3a:	c1 e0 18             	shl    $0x18,%eax
80104e3d:	89 fb                	mov    %edi,%ebx
80104e3f:	c1 e9 02             	shr    $0x2,%ecx
80104e42:	c1 e3 10             	shl    $0x10,%ebx
80104e45:	09 d8                	or     %ebx,%eax
80104e47:	09 f8                	or     %edi,%eax
80104e49:	c1 e7 08             	shl    $0x8,%edi
80104e4c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104e4e:	89 d7                	mov    %edx,%edi
80104e50:	fc                   	cld    
80104e51:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104e53:	5b                   	pop    %ebx
80104e54:	89 d0                	mov    %edx,%eax
80104e56:	5f                   	pop    %edi
80104e57:	5d                   	pop    %ebp
80104e58:	c3                   	ret    
80104e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104e60:	89 d7                	mov    %edx,%edi
80104e62:	fc                   	cld    
80104e63:	f3 aa                	rep stos %al,%es:(%edi)
80104e65:	5b                   	pop    %ebx
80104e66:	89 d0                	mov    %edx,%eax
80104e68:	5f                   	pop    %edi
80104e69:	5d                   	pop    %ebp
80104e6a:	c3                   	ret    
80104e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e6f:	90                   	nop

80104e70 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	56                   	push   %esi
80104e74:	8b 75 10             	mov    0x10(%ebp),%esi
80104e77:	8b 55 08             	mov    0x8(%ebp),%edx
80104e7a:	53                   	push   %ebx
80104e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104e7e:	85 f6                	test   %esi,%esi
80104e80:	74 2e                	je     80104eb0 <memcmp+0x40>
80104e82:	01 c6                	add    %eax,%esi
80104e84:	eb 14                	jmp    80104e9a <memcmp+0x2a>
80104e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104e90:	83 c0 01             	add    $0x1,%eax
80104e93:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104e96:	39 f0                	cmp    %esi,%eax
80104e98:	74 16                	je     80104eb0 <memcmp+0x40>
    if(*s1 != *s2)
80104e9a:	0f b6 0a             	movzbl (%edx),%ecx
80104e9d:	0f b6 18             	movzbl (%eax),%ebx
80104ea0:	38 d9                	cmp    %bl,%cl
80104ea2:	74 ec                	je     80104e90 <memcmp+0x20>
      return *s1 - *s2;
80104ea4:	0f b6 c1             	movzbl %cl,%eax
80104ea7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104ea9:	5b                   	pop    %ebx
80104eaa:	5e                   	pop    %esi
80104eab:	5d                   	pop    %ebp
80104eac:	c3                   	ret    
80104ead:	8d 76 00             	lea    0x0(%esi),%esi
80104eb0:	5b                   	pop    %ebx
  return 0;
80104eb1:	31 c0                	xor    %eax,%eax
}
80104eb3:	5e                   	pop    %esi
80104eb4:	5d                   	pop    %ebp
80104eb5:	c3                   	ret    
80104eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi

80104ec0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	57                   	push   %edi
80104ec4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ec7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104eca:	56                   	push   %esi
80104ecb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104ece:	39 d6                	cmp    %edx,%esi
80104ed0:	73 26                	jae    80104ef8 <memmove+0x38>
80104ed2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104ed5:	39 fa                	cmp    %edi,%edx
80104ed7:	73 1f                	jae    80104ef8 <memmove+0x38>
80104ed9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104edc:	85 c9                	test   %ecx,%ecx
80104ede:	74 0c                	je     80104eec <memmove+0x2c>
      *--d = *--s;
80104ee0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104ee4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104ee7:	83 e8 01             	sub    $0x1,%eax
80104eea:	73 f4                	jae    80104ee0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104eec:	5e                   	pop    %esi
80104eed:	89 d0                	mov    %edx,%eax
80104eef:	5f                   	pop    %edi
80104ef0:	5d                   	pop    %ebp
80104ef1:	c3                   	ret    
80104ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104ef8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104efb:	89 d7                	mov    %edx,%edi
80104efd:	85 c9                	test   %ecx,%ecx
80104eff:	74 eb                	je     80104eec <memmove+0x2c>
80104f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104f08:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104f09:	39 c6                	cmp    %eax,%esi
80104f0b:	75 fb                	jne    80104f08 <memmove+0x48>
}
80104f0d:	5e                   	pop    %esi
80104f0e:	89 d0                	mov    %edx,%eax
80104f10:	5f                   	pop    %edi
80104f11:	5d                   	pop    %ebp
80104f12:	c3                   	ret    
80104f13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f20 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104f20:	eb 9e                	jmp    80104ec0 <memmove>
80104f22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f30 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	56                   	push   %esi
80104f34:	8b 75 10             	mov    0x10(%ebp),%esi
80104f37:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f3a:	53                   	push   %ebx
80104f3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104f3e:	85 f6                	test   %esi,%esi
80104f40:	74 2e                	je     80104f70 <strncmp+0x40>
80104f42:	01 d6                	add    %edx,%esi
80104f44:	eb 18                	jmp    80104f5e <strncmp+0x2e>
80104f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi
80104f50:	38 d8                	cmp    %bl,%al
80104f52:	75 14                	jne    80104f68 <strncmp+0x38>
    n--, p++, q++;
80104f54:	83 c2 01             	add    $0x1,%edx
80104f57:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104f5a:	39 f2                	cmp    %esi,%edx
80104f5c:	74 12                	je     80104f70 <strncmp+0x40>
80104f5e:	0f b6 01             	movzbl (%ecx),%eax
80104f61:	0f b6 1a             	movzbl (%edx),%ebx
80104f64:	84 c0                	test   %al,%al
80104f66:	75 e8                	jne    80104f50 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104f68:	29 d8                	sub    %ebx,%eax
}
80104f6a:	5b                   	pop    %ebx
80104f6b:	5e                   	pop    %esi
80104f6c:	5d                   	pop    %ebp
80104f6d:	c3                   	ret    
80104f6e:	66 90                	xchg   %ax,%ax
80104f70:	5b                   	pop    %ebx
    return 0;
80104f71:	31 c0                	xor    %eax,%eax
}
80104f73:	5e                   	pop    %esi
80104f74:	5d                   	pop    %ebp
80104f75:	c3                   	ret    
80104f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f7d:	8d 76 00             	lea    0x0(%esi),%esi

80104f80 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	57                   	push   %edi
80104f84:	56                   	push   %esi
80104f85:	8b 75 08             	mov    0x8(%ebp),%esi
80104f88:	53                   	push   %ebx
80104f89:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f8c:	89 f0                	mov    %esi,%eax
80104f8e:	eb 15                	jmp    80104fa5 <strncpy+0x25>
80104f90:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104f94:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104f97:	83 c0 01             	add    $0x1,%eax
80104f9a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104f9e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104fa1:	84 d2                	test   %dl,%dl
80104fa3:	74 09                	je     80104fae <strncpy+0x2e>
80104fa5:	89 cb                	mov    %ecx,%ebx
80104fa7:	83 e9 01             	sub    $0x1,%ecx
80104faa:	85 db                	test   %ebx,%ebx
80104fac:	7f e2                	jg     80104f90 <strncpy+0x10>
    ;
  while(n-- > 0)
80104fae:	89 c2                	mov    %eax,%edx
80104fb0:	85 c9                	test   %ecx,%ecx
80104fb2:	7e 17                	jle    80104fcb <strncpy+0x4b>
80104fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104fb8:	83 c2 01             	add    $0x1,%edx
80104fbb:	89 c1                	mov    %eax,%ecx
80104fbd:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104fc1:	29 d1                	sub    %edx,%ecx
80104fc3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104fc7:	85 c9                	test   %ecx,%ecx
80104fc9:	7f ed                	jg     80104fb8 <strncpy+0x38>
  return os;
}
80104fcb:	5b                   	pop    %ebx
80104fcc:	89 f0                	mov    %esi,%eax
80104fce:	5e                   	pop    %esi
80104fcf:	5f                   	pop    %edi
80104fd0:	5d                   	pop    %ebp
80104fd1:	c3                   	ret    
80104fd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fe0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	8b 55 10             	mov    0x10(%ebp),%edx
80104fe7:	8b 75 08             	mov    0x8(%ebp),%esi
80104fea:	53                   	push   %ebx
80104feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104fee:	85 d2                	test   %edx,%edx
80104ff0:	7e 25                	jle    80105017 <safestrcpy+0x37>
80104ff2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104ff6:	89 f2                	mov    %esi,%edx
80104ff8:	eb 16                	jmp    80105010 <safestrcpy+0x30>
80104ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105000:	0f b6 08             	movzbl (%eax),%ecx
80105003:	83 c0 01             	add    $0x1,%eax
80105006:	83 c2 01             	add    $0x1,%edx
80105009:	88 4a ff             	mov    %cl,-0x1(%edx)
8010500c:	84 c9                	test   %cl,%cl
8010500e:	74 04                	je     80105014 <safestrcpy+0x34>
80105010:	39 d8                	cmp    %ebx,%eax
80105012:	75 ec                	jne    80105000 <safestrcpy+0x20>
    ;
  *s = 0;
80105014:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105017:	89 f0                	mov    %esi,%eax
80105019:	5b                   	pop    %ebx
8010501a:	5e                   	pop    %esi
8010501b:	5d                   	pop    %ebp
8010501c:	c3                   	ret    
8010501d:	8d 76 00             	lea    0x0(%esi),%esi

80105020 <strlen>:

int
strlen(const char *s)
{
80105020:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105021:	31 c0                	xor    %eax,%eax
{
80105023:	89 e5                	mov    %esp,%ebp
80105025:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105028:	80 3a 00             	cmpb   $0x0,(%edx)
8010502b:	74 0c                	je     80105039 <strlen+0x19>
8010502d:	8d 76 00             	lea    0x0(%esi),%esi
80105030:	83 c0 01             	add    $0x1,%eax
80105033:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105037:	75 f7                	jne    80105030 <strlen+0x10>
    ;
  return n;
}
80105039:	5d                   	pop    %ebp
8010503a:	c3                   	ret    

8010503b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010503b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010503f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105043:	55                   	push   %ebp
  pushl %ebx
80105044:	53                   	push   %ebx
  pushl %esi
80105045:	56                   	push   %esi
  pushl %edi
80105046:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105047:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105049:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010504b:	5f                   	pop    %edi
  popl %esi
8010504c:	5e                   	pop    %esi
  popl %ebx
8010504d:	5b                   	pop    %ebx
  popl %ebp
8010504e:	5d                   	pop    %ebp
  ret
8010504f:	c3                   	ret    

80105050 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	53                   	push   %ebx
80105054:	83 ec 04             	sub    $0x4,%esp
80105057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010505a:	e8 c1 ea ff ff       	call   80103b20 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010505f:	8b 00                	mov    (%eax),%eax
80105061:	39 d8                	cmp    %ebx,%eax
80105063:	76 1b                	jbe    80105080 <fetchint+0x30>
80105065:	8d 53 04             	lea    0x4(%ebx),%edx
80105068:	39 d0                	cmp    %edx,%eax
8010506a:	72 14                	jb     80105080 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010506c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010506f:	8b 13                	mov    (%ebx),%edx
80105071:	89 10                	mov    %edx,(%eax)
  return 0;
80105073:	31 c0                	xor    %eax,%eax
}
80105075:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105078:	c9                   	leave  
80105079:	c3                   	ret    
8010507a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105085:	eb ee                	jmp    80105075 <fetchint+0x25>
80105087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508e:	66 90                	xchg   %ax,%ax

80105090 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	53                   	push   %ebx
80105094:	83 ec 04             	sub    $0x4,%esp
80105097:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010509a:	e8 81 ea ff ff       	call   80103b20 <myproc>

  if(addr >= curproc->sz)
8010509f:	39 18                	cmp    %ebx,(%eax)
801050a1:	76 2d                	jbe    801050d0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801050a3:	8b 55 0c             	mov    0xc(%ebp),%edx
801050a6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801050a8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801050aa:	39 d3                	cmp    %edx,%ebx
801050ac:	73 22                	jae    801050d0 <fetchstr+0x40>
801050ae:	89 d8                	mov    %ebx,%eax
801050b0:	eb 0d                	jmp    801050bf <fetchstr+0x2f>
801050b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050b8:	83 c0 01             	add    $0x1,%eax
801050bb:	39 c2                	cmp    %eax,%edx
801050bd:	76 11                	jbe    801050d0 <fetchstr+0x40>
    if(*s == 0)
801050bf:	80 38 00             	cmpb   $0x0,(%eax)
801050c2:	75 f4                	jne    801050b8 <fetchstr+0x28>
      return s - *pp;
801050c4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801050c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050c9:	c9                   	leave  
801050ca:	c3                   	ret    
801050cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050cf:	90                   	nop
801050d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801050d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050d8:	c9                   	leave  
801050d9:	c3                   	ret    
801050da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	56                   	push   %esi
801050e4:	53                   	push   %ebx
  struct thread *curt = &myproc()->threads[myproc()->curtidx];
801050e5:	e8 36 ea ff ff       	call   80103b20 <myproc>
801050ea:	89 c3                	mov    %eax,%ebx
801050ec:	e8 2f ea ff ff       	call   80103b20 <myproc>
  return fetchint((curt->tf->esp) + 4 + 4*n, ip);
801050f1:	8b 55 08             	mov    0x8(%ebp),%edx
801050f4:	8b 80 6c 08 00 00    	mov    0x86c(%eax),%eax
801050fa:	c1 e0 05             	shl    $0x5,%eax
801050fd:	8b 44 18 78          	mov    0x78(%eax,%ebx,1),%eax
80105101:	8b 40 44             	mov    0x44(%eax),%eax
80105104:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105107:	e8 14 ea ff ff       	call   80103b20 <myproc>
  return fetchint((curt->tf->esp) + 4 + 4*n, ip);
8010510c:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010510f:	8b 00                	mov    (%eax),%eax
80105111:	39 c6                	cmp    %eax,%esi
80105113:	73 1b                	jae    80105130 <argint+0x50>
80105115:	8d 53 08             	lea    0x8(%ebx),%edx
80105118:	39 d0                	cmp    %edx,%eax
8010511a:	72 14                	jb     80105130 <argint+0x50>
  *ip = *(int*)(addr);
8010511c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010511f:	8b 53 04             	mov    0x4(%ebx),%edx
80105122:	89 10                	mov    %edx,(%eax)
  return 0;
80105124:	31 c0                	xor    %eax,%eax
}
80105126:	5b                   	pop    %ebx
80105127:	5e                   	pop    %esi
80105128:	5d                   	pop    %ebp
80105129:	c3                   	ret    
8010512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((curt->tf->esp) + 4 + 4*n, ip);
80105135:	eb ef                	jmp    80105126 <argint+0x46>
80105137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010513e:	66 90                	xchg   %ax,%ax

80105140 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	56                   	push   %esi
80105144:	53                   	push   %ebx
80105145:	83 ec 10             	sub    $0x10,%esp
80105148:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010514b:	e8 d0 e9 ff ff       	call   80103b20 <myproc>
 
  if(argint(n, &i) < 0)
80105150:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105153:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105155:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105158:	50                   	push   %eax
80105159:	ff 75 08             	push   0x8(%ebp)
8010515c:	e8 7f ff ff ff       	call   801050e0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105161:	83 c4 10             	add    $0x10,%esp
80105164:	09 d8                	or     %ebx,%eax
80105166:	78 20                	js     80105188 <argptr+0x48>
80105168:	8b 16                	mov    (%esi),%edx
8010516a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010516d:	39 c2                	cmp    %eax,%edx
8010516f:	76 17                	jbe    80105188 <argptr+0x48>
80105171:	01 c3                	add    %eax,%ebx
80105173:	39 da                	cmp    %ebx,%edx
80105175:	72 11                	jb     80105188 <argptr+0x48>
    return -1;
  *pp = (char*)i;
80105177:	8b 55 0c             	mov    0xc(%ebp),%edx
8010517a:	89 02                	mov    %eax,(%edx)
  return 0;
8010517c:	31 c0                	xor    %eax,%eax
}
8010517e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105181:	5b                   	pop    %ebx
80105182:	5e                   	pop    %esi
80105183:	5d                   	pop    %ebp
80105184:	c3                   	ret    
80105185:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105188:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010518d:	eb ef                	jmp    8010517e <argptr+0x3e>
8010518f:	90                   	nop

80105190 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	53                   	push   %ebx
  int addr;
  if(argint(n, &addr) < 0)
80105194:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105197:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(n, &addr) < 0)
8010519a:	50                   	push   %eax
8010519b:	ff 75 08             	push   0x8(%ebp)
8010519e:	e8 3d ff ff ff       	call   801050e0 <argint>
801051a3:	83 c4 10             	add    $0x10,%esp
801051a6:	85 c0                	test   %eax,%eax
801051a8:	78 36                	js     801051e0 <argstr+0x50>
    return -1;
  return fetchstr(addr, pp);
801051aa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  struct proc *curproc = myproc();
801051ad:	e8 6e e9 ff ff       	call   80103b20 <myproc>
  if(addr >= curproc->sz)
801051b2:	3b 18                	cmp    (%eax),%ebx
801051b4:	73 2a                	jae    801051e0 <argstr+0x50>
  *pp = (char*)addr;
801051b6:	8b 55 0c             	mov    0xc(%ebp),%edx
801051b9:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801051bb:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801051bd:	39 d3                	cmp    %edx,%ebx
801051bf:	73 1f                	jae    801051e0 <argstr+0x50>
801051c1:	89 d8                	mov    %ebx,%eax
801051c3:	eb 0a                	jmp    801051cf <argstr+0x3f>
801051c5:	8d 76 00             	lea    0x0(%esi),%esi
801051c8:	83 c0 01             	add    $0x1,%eax
801051cb:	39 c2                	cmp    %eax,%edx
801051cd:	76 11                	jbe    801051e0 <argstr+0x50>
    if(*s == 0)
801051cf:	80 38 00             	cmpb   $0x0,(%eax)
801051d2:	75 f4                	jne    801051c8 <argstr+0x38>
      return s - *pp;
801051d4:	29 d8                	sub    %ebx,%eax
}
801051d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051d9:	c9                   	leave  
801051da:	c3                   	ret    
801051db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051df:	90                   	nop
801051e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801051e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051e8:	c9                   	leave  
801051e9:	c3                   	ret    
801051ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801051f0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	53                   	push   %ebx
801051f4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801051f7:	e8 24 e9 ff ff       	call   80103b20 <myproc>
  struct thread *curt = &curproc->threads[curproc->curtidx];

  num = curt->tf->eax;
801051fc:	8b 98 6c 08 00 00    	mov    0x86c(%eax),%ebx
80105202:	c1 e3 05             	shl    $0x5,%ebx
80105205:	01 c3                	add    %eax,%ebx
80105207:	8b 53 78             	mov    0x78(%ebx),%edx
8010520a:	8b 52 1c             	mov    0x1c(%edx),%edx
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010520d:	8d 4a ff             	lea    -0x1(%edx),%ecx
80105210:	83 f9 14             	cmp    $0x14,%ecx
80105213:	77 1b                	ja     80105230 <syscall+0x40>
80105215:	8b 0c 95 c0 80 10 80 	mov    -0x7fef7f40(,%edx,4),%ecx
8010521c:	85 c9                	test   %ecx,%ecx
8010521e:	74 10                	je     80105230 <syscall+0x40>
    curt->tf->eax = syscalls[num]();
80105220:	ff d1                	call   *%ecx
80105222:	89 c2                	mov    %eax,%edx
80105224:	8b 43 78             	mov    0x78(%ebx),%eax
80105227:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %d %s: unknown sys call %d\n",
            curproc->pid, curt->tid, curproc->name, num);
    curt->tf->eax = -1;
  }
}
8010522a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010522d:	c9                   	leave  
8010522e:	c3                   	ret    
8010522f:	90                   	nop
    cprintf("%d %d %s: unknown sys call %d\n",
80105230:	83 ec 0c             	sub    $0xc,%esp
80105233:	52                   	push   %edx
            curproc->pid, curt->tid, curproc->name, num);
80105234:	8d 50 5c             	lea    0x5c(%eax),%edx
    cprintf("%d %d %s: unknown sys call %d\n",
80105237:	52                   	push   %edx
80105238:	ff 73 70             	push   0x70(%ebx)
8010523b:	ff 70 0c             	push   0xc(%eax)
8010523e:	68 a0 80 10 80       	push   $0x801080a0
80105243:	e8 58 b4 ff ff       	call   801006a0 <cprintf>
    curt->tf->eax = -1;
80105248:	8b 43 78             	mov    0x78(%ebx),%eax
8010524b:	83 c4 20             	add    $0x20,%esp
8010524e:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105255:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105258:	c9                   	leave  
80105259:	c3                   	ret    
8010525a:	66 90                	xchg   %ax,%ax
8010525c:	66 90                	xchg   %ax,%ax
8010525e:	66 90                	xchg   %ax,%ax

80105260 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105265:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105268:	53                   	push   %ebx
80105269:	83 ec 34             	sub    $0x34,%esp
8010526c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010526f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105272:	57                   	push   %edi
80105273:	50                   	push   %eax
{
80105274:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105277:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010527a:	e8 31 cf ff ff       	call   801021b0 <nameiparent>
8010527f:	83 c4 10             	add    $0x10,%esp
80105282:	85 c0                	test   %eax,%eax
80105284:	0f 84 46 01 00 00    	je     801053d0 <create+0x170>
    return 0;
  ilock(dp);
8010528a:	83 ec 0c             	sub    $0xc,%esp
8010528d:	89 c3                	mov    %eax,%ebx
8010528f:	50                   	push   %eax
80105290:	e8 db c5 ff ff       	call   80101870 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105295:	83 c4 0c             	add    $0xc,%esp
80105298:	6a 00                	push   $0x0
8010529a:	57                   	push   %edi
8010529b:	53                   	push   %ebx
8010529c:	e8 2f cb ff ff       	call   80101dd0 <dirlookup>
801052a1:	83 c4 10             	add    $0x10,%esp
801052a4:	89 c6                	mov    %eax,%esi
801052a6:	85 c0                	test   %eax,%eax
801052a8:	74 56                	je     80105300 <create+0xa0>
    iunlockput(dp);
801052aa:	83 ec 0c             	sub    $0xc,%esp
801052ad:	53                   	push   %ebx
801052ae:	e8 4d c8 ff ff       	call   80101b00 <iunlockput>
    ilock(ip);
801052b3:	89 34 24             	mov    %esi,(%esp)
801052b6:	e8 b5 c5 ff ff       	call   80101870 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801052bb:	83 c4 10             	add    $0x10,%esp
801052be:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801052c3:	75 1b                	jne    801052e0 <create+0x80>
801052c5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801052ca:	75 14                	jne    801052e0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801052cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052cf:	89 f0                	mov    %esi,%eax
801052d1:	5b                   	pop    %ebx
801052d2:	5e                   	pop    %esi
801052d3:	5f                   	pop    %edi
801052d4:	5d                   	pop    %ebp
801052d5:	c3                   	ret    
801052d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052dd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801052e0:	83 ec 0c             	sub    $0xc,%esp
801052e3:	56                   	push   %esi
    return 0;
801052e4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801052e6:	e8 15 c8 ff ff       	call   80101b00 <iunlockput>
    return 0;
801052eb:	83 c4 10             	add    $0x10,%esp
}
801052ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052f1:	89 f0                	mov    %esi,%eax
801052f3:	5b                   	pop    %ebx
801052f4:	5e                   	pop    %esi
801052f5:	5f                   	pop    %edi
801052f6:	5d                   	pop    %ebp
801052f7:	c3                   	ret    
801052f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ff:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105300:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105304:	83 ec 08             	sub    $0x8,%esp
80105307:	50                   	push   %eax
80105308:	ff 33                	push   (%ebx)
8010530a:	e8 f1 c3 ff ff       	call   80101700 <ialloc>
8010530f:	83 c4 10             	add    $0x10,%esp
80105312:	89 c6                	mov    %eax,%esi
80105314:	85 c0                	test   %eax,%eax
80105316:	0f 84 cd 00 00 00    	je     801053e9 <create+0x189>
  ilock(ip);
8010531c:	83 ec 0c             	sub    $0xc,%esp
8010531f:	50                   	push   %eax
80105320:	e8 4b c5 ff ff       	call   80101870 <ilock>
  ip->major = major;
80105325:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105329:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010532d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105331:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105335:	b8 01 00 00 00       	mov    $0x1,%eax
8010533a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010533e:	89 34 24             	mov    %esi,(%esp)
80105341:	e8 7a c4 ff ff       	call   801017c0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105346:	83 c4 10             	add    $0x10,%esp
80105349:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010534e:	74 30                	je     80105380 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105350:	83 ec 04             	sub    $0x4,%esp
80105353:	ff 76 04             	push   0x4(%esi)
80105356:	57                   	push   %edi
80105357:	53                   	push   %ebx
80105358:	e8 73 cd ff ff       	call   801020d0 <dirlink>
8010535d:	83 c4 10             	add    $0x10,%esp
80105360:	85 c0                	test   %eax,%eax
80105362:	78 78                	js     801053dc <create+0x17c>
  iunlockput(dp);
80105364:	83 ec 0c             	sub    $0xc,%esp
80105367:	53                   	push   %ebx
80105368:	e8 93 c7 ff ff       	call   80101b00 <iunlockput>
  return ip;
8010536d:	83 c4 10             	add    $0x10,%esp
}
80105370:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105373:	89 f0                	mov    %esi,%eax
80105375:	5b                   	pop    %ebx
80105376:	5e                   	pop    %esi
80105377:	5f                   	pop    %edi
80105378:	5d                   	pop    %ebp
80105379:	c3                   	ret    
8010537a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105380:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105383:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105388:	53                   	push   %ebx
80105389:	e8 32 c4 ff ff       	call   801017c0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010538e:	83 c4 0c             	add    $0xc,%esp
80105391:	ff 76 04             	push   0x4(%esi)
80105394:	68 34 81 10 80       	push   $0x80108134
80105399:	56                   	push   %esi
8010539a:	e8 31 cd ff ff       	call   801020d0 <dirlink>
8010539f:	83 c4 10             	add    $0x10,%esp
801053a2:	85 c0                	test   %eax,%eax
801053a4:	78 18                	js     801053be <create+0x15e>
801053a6:	83 ec 04             	sub    $0x4,%esp
801053a9:	ff 73 04             	push   0x4(%ebx)
801053ac:	68 33 81 10 80       	push   $0x80108133
801053b1:	56                   	push   %esi
801053b2:	e8 19 cd ff ff       	call   801020d0 <dirlink>
801053b7:	83 c4 10             	add    $0x10,%esp
801053ba:	85 c0                	test   %eax,%eax
801053bc:	79 92                	jns    80105350 <create+0xf0>
      panic("create dots");
801053be:	83 ec 0c             	sub    $0xc,%esp
801053c1:	68 27 81 10 80       	push   $0x80108127
801053c6:	e8 b5 af ff ff       	call   80100380 <panic>
801053cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053cf:	90                   	nop
}
801053d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801053d3:	31 f6                	xor    %esi,%esi
}
801053d5:	5b                   	pop    %ebx
801053d6:	89 f0                	mov    %esi,%eax
801053d8:	5e                   	pop    %esi
801053d9:	5f                   	pop    %edi
801053da:	5d                   	pop    %ebp
801053db:	c3                   	ret    
    panic("create: dirlink");
801053dc:	83 ec 0c             	sub    $0xc,%esp
801053df:	68 36 81 10 80       	push   $0x80108136
801053e4:	e8 97 af ff ff       	call   80100380 <panic>
    panic("create: ialloc");
801053e9:	83 ec 0c             	sub    $0xc,%esp
801053ec:	68 18 81 10 80       	push   $0x80108118
801053f1:	e8 8a af ff ff       	call   80100380 <panic>
801053f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053fd:	8d 76 00             	lea    0x0(%esi),%esi

80105400 <sys_dup>:
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	56                   	push   %esi
80105404:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105405:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105408:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010540b:	50                   	push   %eax
8010540c:	6a 00                	push   $0x0
8010540e:	e8 cd fc ff ff       	call   801050e0 <argint>
80105413:	83 c4 10             	add    $0x10,%esp
80105416:	85 c0                	test   %eax,%eax
80105418:	78 36                	js     80105450 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010541a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010541e:	77 30                	ja     80105450 <sys_dup+0x50>
80105420:	e8 fb e6 ff ff       	call   80103b20 <myproc>
80105425:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105428:	8b 74 90 18          	mov    0x18(%eax,%edx,4),%esi
8010542c:	85 f6                	test   %esi,%esi
8010542e:	74 20                	je     80105450 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105430:	e8 eb e6 ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105435:	31 db                	xor    %ebx,%ebx
80105437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010543e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105440:	8b 54 98 18          	mov    0x18(%eax,%ebx,4),%edx
80105444:	85 d2                	test   %edx,%edx
80105446:	74 18                	je     80105460 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105448:	83 c3 01             	add    $0x1,%ebx
8010544b:	83 fb 10             	cmp    $0x10,%ebx
8010544e:	75 f0                	jne    80105440 <sys_dup+0x40>
}
80105450:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105453:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105458:	89 d8                	mov    %ebx,%eax
8010545a:	5b                   	pop    %ebx
8010545b:	5e                   	pop    %esi
8010545c:	5d                   	pop    %ebp
8010545d:	c3                   	ret    
8010545e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105460:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105463:	89 74 98 18          	mov    %esi,0x18(%eax,%ebx,4)
  filedup(f);
80105467:	56                   	push   %esi
80105468:	e8 23 bb ff ff       	call   80100f90 <filedup>
  return fd;
8010546d:	83 c4 10             	add    $0x10,%esp
}
80105470:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105473:	89 d8                	mov    %ebx,%eax
80105475:	5b                   	pop    %ebx
80105476:	5e                   	pop    %esi
80105477:	5d                   	pop    %ebp
80105478:	c3                   	ret    
80105479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105480 <sys_read>:
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	56                   	push   %esi
80105484:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105485:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105488:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010548b:	53                   	push   %ebx
8010548c:	6a 00                	push   $0x0
8010548e:	e8 4d fc ff ff       	call   801050e0 <argint>
80105493:	83 c4 10             	add    $0x10,%esp
80105496:	85 c0                	test   %eax,%eax
80105498:	78 5e                	js     801054f8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010549a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010549e:	77 58                	ja     801054f8 <sys_read+0x78>
801054a0:	e8 7b e6 ff ff       	call   80103b20 <myproc>
801054a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054a8:	8b 74 90 18          	mov    0x18(%eax,%edx,4),%esi
801054ac:	85 f6                	test   %esi,%esi
801054ae:	74 48                	je     801054f8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054b0:	83 ec 08             	sub    $0x8,%esp
801054b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054b6:	50                   	push   %eax
801054b7:	6a 02                	push   $0x2
801054b9:	e8 22 fc ff ff       	call   801050e0 <argint>
801054be:	83 c4 10             	add    $0x10,%esp
801054c1:	85 c0                	test   %eax,%eax
801054c3:	78 33                	js     801054f8 <sys_read+0x78>
801054c5:	83 ec 04             	sub    $0x4,%esp
801054c8:	ff 75 f0             	push   -0x10(%ebp)
801054cb:	53                   	push   %ebx
801054cc:	6a 01                	push   $0x1
801054ce:	e8 6d fc ff ff       	call   80105140 <argptr>
801054d3:	83 c4 10             	add    $0x10,%esp
801054d6:	85 c0                	test   %eax,%eax
801054d8:	78 1e                	js     801054f8 <sys_read+0x78>
  return fileread(f, p, n);
801054da:	83 ec 04             	sub    $0x4,%esp
801054dd:	ff 75 f0             	push   -0x10(%ebp)
801054e0:	ff 75 f4             	push   -0xc(%ebp)
801054e3:	56                   	push   %esi
801054e4:	e8 27 bc ff ff       	call   80101110 <fileread>
801054e9:	83 c4 10             	add    $0x10,%esp
}
801054ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054ef:	5b                   	pop    %ebx
801054f0:	5e                   	pop    %esi
801054f1:	5d                   	pop    %ebp
801054f2:	c3                   	ret    
801054f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054f7:	90                   	nop
    return -1;
801054f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054fd:	eb ed                	jmp    801054ec <sys_read+0x6c>
801054ff:	90                   	nop

80105500 <sys_write>:
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	56                   	push   %esi
80105504:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105505:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105508:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010550b:	53                   	push   %ebx
8010550c:	6a 00                	push   $0x0
8010550e:	e8 cd fb ff ff       	call   801050e0 <argint>
80105513:	83 c4 10             	add    $0x10,%esp
80105516:	85 c0                	test   %eax,%eax
80105518:	78 5e                	js     80105578 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010551a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010551e:	77 58                	ja     80105578 <sys_write+0x78>
80105520:	e8 fb e5 ff ff       	call   80103b20 <myproc>
80105525:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105528:	8b 74 90 18          	mov    0x18(%eax,%edx,4),%esi
8010552c:	85 f6                	test   %esi,%esi
8010552e:	74 48                	je     80105578 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105530:	83 ec 08             	sub    $0x8,%esp
80105533:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105536:	50                   	push   %eax
80105537:	6a 02                	push   $0x2
80105539:	e8 a2 fb ff ff       	call   801050e0 <argint>
8010553e:	83 c4 10             	add    $0x10,%esp
80105541:	85 c0                	test   %eax,%eax
80105543:	78 33                	js     80105578 <sys_write+0x78>
80105545:	83 ec 04             	sub    $0x4,%esp
80105548:	ff 75 f0             	push   -0x10(%ebp)
8010554b:	53                   	push   %ebx
8010554c:	6a 01                	push   $0x1
8010554e:	e8 ed fb ff ff       	call   80105140 <argptr>
80105553:	83 c4 10             	add    $0x10,%esp
80105556:	85 c0                	test   %eax,%eax
80105558:	78 1e                	js     80105578 <sys_write+0x78>
  return filewrite(f, p, n);
8010555a:	83 ec 04             	sub    $0x4,%esp
8010555d:	ff 75 f0             	push   -0x10(%ebp)
80105560:	ff 75 f4             	push   -0xc(%ebp)
80105563:	56                   	push   %esi
80105564:	e8 37 bc ff ff       	call   801011a0 <filewrite>
80105569:	83 c4 10             	add    $0x10,%esp
}
8010556c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010556f:	5b                   	pop    %ebx
80105570:	5e                   	pop    %esi
80105571:	5d                   	pop    %ebp
80105572:	c3                   	ret    
80105573:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105577:	90                   	nop
    return -1;
80105578:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557d:	eb ed                	jmp    8010556c <sys_write+0x6c>
8010557f:	90                   	nop

80105580 <sys_close>:
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	56                   	push   %esi
80105584:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105585:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105588:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010558b:	50                   	push   %eax
8010558c:	6a 00                	push   $0x0
8010558e:	e8 4d fb ff ff       	call   801050e0 <argint>
80105593:	83 c4 10             	add    $0x10,%esp
80105596:	85 c0                	test   %eax,%eax
80105598:	78 3e                	js     801055d8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010559a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010559e:	77 38                	ja     801055d8 <sys_close+0x58>
801055a0:	e8 7b e5 ff ff       	call   80103b20 <myproc>
801055a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055a8:	8d 5a 04             	lea    0x4(%edx),%ebx
801055ab:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801055af:	85 f6                	test   %esi,%esi
801055b1:	74 25                	je     801055d8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801055b3:	e8 68 e5 ff ff       	call   80103b20 <myproc>
  fileclose(f);
801055b8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801055bb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801055c2:	00 
  fileclose(f);
801055c3:	56                   	push   %esi
801055c4:	e8 17 ba ff ff       	call   80100fe0 <fileclose>
  return 0;
801055c9:	83 c4 10             	add    $0x10,%esp
801055cc:	31 c0                	xor    %eax,%eax
}
801055ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055d1:	5b                   	pop    %ebx
801055d2:	5e                   	pop    %esi
801055d3:	5d                   	pop    %ebp
801055d4:	c3                   	ret    
801055d5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801055d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055dd:	eb ef                	jmp    801055ce <sys_close+0x4e>
801055df:	90                   	nop

801055e0 <sys_fstat>:
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	56                   	push   %esi
801055e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801055e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801055e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801055eb:	53                   	push   %ebx
801055ec:	6a 00                	push   $0x0
801055ee:	e8 ed fa ff ff       	call   801050e0 <argint>
801055f3:	83 c4 10             	add    $0x10,%esp
801055f6:	85 c0                	test   %eax,%eax
801055f8:	78 46                	js     80105640 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055fe:	77 40                	ja     80105640 <sys_fstat+0x60>
80105600:	e8 1b e5 ff ff       	call   80103b20 <myproc>
80105605:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105608:	8b 74 90 18          	mov    0x18(%eax,%edx,4),%esi
8010560c:	85 f6                	test   %esi,%esi
8010560e:	74 30                	je     80105640 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105610:	83 ec 04             	sub    $0x4,%esp
80105613:	6a 14                	push   $0x14
80105615:	53                   	push   %ebx
80105616:	6a 01                	push   $0x1
80105618:	e8 23 fb ff ff       	call   80105140 <argptr>
8010561d:	83 c4 10             	add    $0x10,%esp
80105620:	85 c0                	test   %eax,%eax
80105622:	78 1c                	js     80105640 <sys_fstat+0x60>
  return filestat(f, st);
80105624:	83 ec 08             	sub    $0x8,%esp
80105627:	ff 75 f4             	push   -0xc(%ebp)
8010562a:	56                   	push   %esi
8010562b:	e8 90 ba ff ff       	call   801010c0 <filestat>
80105630:	83 c4 10             	add    $0x10,%esp
}
80105633:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105636:	5b                   	pop    %ebx
80105637:	5e                   	pop    %esi
80105638:	5d                   	pop    %ebp
80105639:	c3                   	ret    
8010563a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105645:	eb ec                	jmp    80105633 <sys_fstat+0x53>
80105647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010564e:	66 90                	xchg   %ax,%ax

80105650 <sys_link>:
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	57                   	push   %edi
80105654:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105655:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105658:	53                   	push   %ebx
80105659:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010565c:	50                   	push   %eax
8010565d:	6a 00                	push   $0x0
8010565f:	e8 2c fb ff ff       	call   80105190 <argstr>
80105664:	83 c4 10             	add    $0x10,%esp
80105667:	85 c0                	test   %eax,%eax
80105669:	0f 88 fb 00 00 00    	js     8010576a <sys_link+0x11a>
8010566f:	83 ec 08             	sub    $0x8,%esp
80105672:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105675:	50                   	push   %eax
80105676:	6a 01                	push   $0x1
80105678:	e8 13 fb ff ff       	call   80105190 <argstr>
8010567d:	83 c4 10             	add    $0x10,%esp
80105680:	85 c0                	test   %eax,%eax
80105682:	0f 88 e2 00 00 00    	js     8010576a <sys_link+0x11a>
  begin_op();
80105688:	e8 c3 d7 ff ff       	call   80102e50 <begin_op>
  if((ip = namei(old)) == 0){
8010568d:	83 ec 0c             	sub    $0xc,%esp
80105690:	ff 75 d4             	push   -0x2c(%ebp)
80105693:	e8 f8 ca ff ff       	call   80102190 <namei>
80105698:	83 c4 10             	add    $0x10,%esp
8010569b:	89 c3                	mov    %eax,%ebx
8010569d:	85 c0                	test   %eax,%eax
8010569f:	0f 84 e4 00 00 00    	je     80105789 <sys_link+0x139>
  ilock(ip);
801056a5:	83 ec 0c             	sub    $0xc,%esp
801056a8:	50                   	push   %eax
801056a9:	e8 c2 c1 ff ff       	call   80101870 <ilock>
  if(ip->type == T_DIR){
801056ae:	83 c4 10             	add    $0x10,%esp
801056b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056b6:	0f 84 b5 00 00 00    	je     80105771 <sys_link+0x121>
  iupdate(ip);
801056bc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801056bf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801056c4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801056c7:	53                   	push   %ebx
801056c8:	e8 f3 c0 ff ff       	call   801017c0 <iupdate>
  iunlock(ip);
801056cd:	89 1c 24             	mov    %ebx,(%esp)
801056d0:	e8 7b c2 ff ff       	call   80101950 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801056d5:	58                   	pop    %eax
801056d6:	5a                   	pop    %edx
801056d7:	57                   	push   %edi
801056d8:	ff 75 d0             	push   -0x30(%ebp)
801056db:	e8 d0 ca ff ff       	call   801021b0 <nameiparent>
801056e0:	83 c4 10             	add    $0x10,%esp
801056e3:	89 c6                	mov    %eax,%esi
801056e5:	85 c0                	test   %eax,%eax
801056e7:	74 5b                	je     80105744 <sys_link+0xf4>
  ilock(dp);
801056e9:	83 ec 0c             	sub    $0xc,%esp
801056ec:	50                   	push   %eax
801056ed:	e8 7e c1 ff ff       	call   80101870 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801056f2:	8b 03                	mov    (%ebx),%eax
801056f4:	83 c4 10             	add    $0x10,%esp
801056f7:	39 06                	cmp    %eax,(%esi)
801056f9:	75 3d                	jne    80105738 <sys_link+0xe8>
801056fb:	83 ec 04             	sub    $0x4,%esp
801056fe:	ff 73 04             	push   0x4(%ebx)
80105701:	57                   	push   %edi
80105702:	56                   	push   %esi
80105703:	e8 c8 c9 ff ff       	call   801020d0 <dirlink>
80105708:	83 c4 10             	add    $0x10,%esp
8010570b:	85 c0                	test   %eax,%eax
8010570d:	78 29                	js     80105738 <sys_link+0xe8>
  iunlockput(dp);
8010570f:	83 ec 0c             	sub    $0xc,%esp
80105712:	56                   	push   %esi
80105713:	e8 e8 c3 ff ff       	call   80101b00 <iunlockput>
  iput(ip);
80105718:	89 1c 24             	mov    %ebx,(%esp)
8010571b:	e8 80 c2 ff ff       	call   801019a0 <iput>
  end_op();
80105720:	e8 9b d7 ff ff       	call   80102ec0 <end_op>
  return 0;
80105725:	83 c4 10             	add    $0x10,%esp
80105728:	31 c0                	xor    %eax,%eax
}
8010572a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010572d:	5b                   	pop    %ebx
8010572e:	5e                   	pop    %esi
8010572f:	5f                   	pop    %edi
80105730:	5d                   	pop    %ebp
80105731:	c3                   	ret    
80105732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105738:	83 ec 0c             	sub    $0xc,%esp
8010573b:	56                   	push   %esi
8010573c:	e8 bf c3 ff ff       	call   80101b00 <iunlockput>
    goto bad;
80105741:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105744:	83 ec 0c             	sub    $0xc,%esp
80105747:	53                   	push   %ebx
80105748:	e8 23 c1 ff ff       	call   80101870 <ilock>
  ip->nlink--;
8010574d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105752:	89 1c 24             	mov    %ebx,(%esp)
80105755:	e8 66 c0 ff ff       	call   801017c0 <iupdate>
  iunlockput(ip);
8010575a:	89 1c 24             	mov    %ebx,(%esp)
8010575d:	e8 9e c3 ff ff       	call   80101b00 <iunlockput>
  end_op();
80105762:	e8 59 d7 ff ff       	call   80102ec0 <end_op>
  return -1;
80105767:	83 c4 10             	add    $0x10,%esp
8010576a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010576f:	eb b9                	jmp    8010572a <sys_link+0xda>
    iunlockput(ip);
80105771:	83 ec 0c             	sub    $0xc,%esp
80105774:	53                   	push   %ebx
80105775:	e8 86 c3 ff ff       	call   80101b00 <iunlockput>
    end_op();
8010577a:	e8 41 d7 ff ff       	call   80102ec0 <end_op>
    return -1;
8010577f:	83 c4 10             	add    $0x10,%esp
80105782:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105787:	eb a1                	jmp    8010572a <sys_link+0xda>
    end_op();
80105789:	e8 32 d7 ff ff       	call   80102ec0 <end_op>
    return -1;
8010578e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105793:	eb 95                	jmp    8010572a <sys_link+0xda>
80105795:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057a0 <sys_unlink>:
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	57                   	push   %edi
801057a4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801057a5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801057a8:	53                   	push   %ebx
801057a9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801057ac:	50                   	push   %eax
801057ad:	6a 00                	push   $0x0
801057af:	e8 dc f9 ff ff       	call   80105190 <argstr>
801057b4:	83 c4 10             	add    $0x10,%esp
801057b7:	85 c0                	test   %eax,%eax
801057b9:	0f 88 7a 01 00 00    	js     80105939 <sys_unlink+0x199>
  begin_op();
801057bf:	e8 8c d6 ff ff       	call   80102e50 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801057c4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801057c7:	83 ec 08             	sub    $0x8,%esp
801057ca:	53                   	push   %ebx
801057cb:	ff 75 c0             	push   -0x40(%ebp)
801057ce:	e8 dd c9 ff ff       	call   801021b0 <nameiparent>
801057d3:	83 c4 10             	add    $0x10,%esp
801057d6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801057d9:	85 c0                	test   %eax,%eax
801057db:	0f 84 62 01 00 00    	je     80105943 <sys_unlink+0x1a3>
  ilock(dp);
801057e1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801057e4:	83 ec 0c             	sub    $0xc,%esp
801057e7:	57                   	push   %edi
801057e8:	e8 83 c0 ff ff       	call   80101870 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801057ed:	58                   	pop    %eax
801057ee:	5a                   	pop    %edx
801057ef:	68 34 81 10 80       	push   $0x80108134
801057f4:	53                   	push   %ebx
801057f5:	e8 b6 c5 ff ff       	call   80101db0 <namecmp>
801057fa:	83 c4 10             	add    $0x10,%esp
801057fd:	85 c0                	test   %eax,%eax
801057ff:	0f 84 fb 00 00 00    	je     80105900 <sys_unlink+0x160>
80105805:	83 ec 08             	sub    $0x8,%esp
80105808:	68 33 81 10 80       	push   $0x80108133
8010580d:	53                   	push   %ebx
8010580e:	e8 9d c5 ff ff       	call   80101db0 <namecmp>
80105813:	83 c4 10             	add    $0x10,%esp
80105816:	85 c0                	test   %eax,%eax
80105818:	0f 84 e2 00 00 00    	je     80105900 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010581e:	83 ec 04             	sub    $0x4,%esp
80105821:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105824:	50                   	push   %eax
80105825:	53                   	push   %ebx
80105826:	57                   	push   %edi
80105827:	e8 a4 c5 ff ff       	call   80101dd0 <dirlookup>
8010582c:	83 c4 10             	add    $0x10,%esp
8010582f:	89 c3                	mov    %eax,%ebx
80105831:	85 c0                	test   %eax,%eax
80105833:	0f 84 c7 00 00 00    	je     80105900 <sys_unlink+0x160>
  ilock(ip);
80105839:	83 ec 0c             	sub    $0xc,%esp
8010583c:	50                   	push   %eax
8010583d:	e8 2e c0 ff ff       	call   80101870 <ilock>
  if(ip->nlink < 1)
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010584a:	0f 8e 1c 01 00 00    	jle    8010596c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105850:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105855:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105858:	74 66                	je     801058c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010585a:	83 ec 04             	sub    $0x4,%esp
8010585d:	6a 10                	push   $0x10
8010585f:	6a 00                	push   $0x0
80105861:	57                   	push   %edi
80105862:	e8 b9 f5 ff ff       	call   80104e20 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105867:	6a 10                	push   $0x10
80105869:	ff 75 c4             	push   -0x3c(%ebp)
8010586c:	57                   	push   %edi
8010586d:	ff 75 b4             	push   -0x4c(%ebp)
80105870:	e8 0b c4 ff ff       	call   80101c80 <writei>
80105875:	83 c4 20             	add    $0x20,%esp
80105878:	83 f8 10             	cmp    $0x10,%eax
8010587b:	0f 85 de 00 00 00    	jne    8010595f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105881:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105886:	0f 84 94 00 00 00    	je     80105920 <sys_unlink+0x180>
  iunlockput(dp);
8010588c:	83 ec 0c             	sub    $0xc,%esp
8010588f:	ff 75 b4             	push   -0x4c(%ebp)
80105892:	e8 69 c2 ff ff       	call   80101b00 <iunlockput>
  ip->nlink--;
80105897:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010589c:	89 1c 24             	mov    %ebx,(%esp)
8010589f:	e8 1c bf ff ff       	call   801017c0 <iupdate>
  iunlockput(ip);
801058a4:	89 1c 24             	mov    %ebx,(%esp)
801058a7:	e8 54 c2 ff ff       	call   80101b00 <iunlockput>
  end_op();
801058ac:	e8 0f d6 ff ff       	call   80102ec0 <end_op>
  return 0;
801058b1:	83 c4 10             	add    $0x10,%esp
801058b4:	31 c0                	xor    %eax,%eax
}
801058b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058b9:	5b                   	pop    %ebx
801058ba:	5e                   	pop    %esi
801058bb:	5f                   	pop    %edi
801058bc:	5d                   	pop    %ebp
801058bd:	c3                   	ret    
801058be:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801058c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801058c4:	76 94                	jbe    8010585a <sys_unlink+0xba>
801058c6:	be 20 00 00 00       	mov    $0x20,%esi
801058cb:	eb 0b                	jmp    801058d8 <sys_unlink+0x138>
801058cd:	8d 76 00             	lea    0x0(%esi),%esi
801058d0:	83 c6 10             	add    $0x10,%esi
801058d3:	3b 73 58             	cmp    0x58(%ebx),%esi
801058d6:	73 82                	jae    8010585a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058d8:	6a 10                	push   $0x10
801058da:	56                   	push   %esi
801058db:	57                   	push   %edi
801058dc:	53                   	push   %ebx
801058dd:	e8 9e c2 ff ff       	call   80101b80 <readi>
801058e2:	83 c4 10             	add    $0x10,%esp
801058e5:	83 f8 10             	cmp    $0x10,%eax
801058e8:	75 68                	jne    80105952 <sys_unlink+0x1b2>
    if(de.inum != 0)
801058ea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801058ef:	74 df                	je     801058d0 <sys_unlink+0x130>
    iunlockput(ip);
801058f1:	83 ec 0c             	sub    $0xc,%esp
801058f4:	53                   	push   %ebx
801058f5:	e8 06 c2 ff ff       	call   80101b00 <iunlockput>
    goto bad;
801058fa:	83 c4 10             	add    $0x10,%esp
801058fd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	ff 75 b4             	push   -0x4c(%ebp)
80105906:	e8 f5 c1 ff ff       	call   80101b00 <iunlockput>
  end_op();
8010590b:	e8 b0 d5 ff ff       	call   80102ec0 <end_op>
  return -1;
80105910:	83 c4 10             	add    $0x10,%esp
80105913:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105918:	eb 9c                	jmp    801058b6 <sys_unlink+0x116>
8010591a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105920:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105923:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105926:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010592b:	50                   	push   %eax
8010592c:	e8 8f be ff ff       	call   801017c0 <iupdate>
80105931:	83 c4 10             	add    $0x10,%esp
80105934:	e9 53 ff ff ff       	jmp    8010588c <sys_unlink+0xec>
    return -1;
80105939:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010593e:	e9 73 ff ff ff       	jmp    801058b6 <sys_unlink+0x116>
    end_op();
80105943:	e8 78 d5 ff ff       	call   80102ec0 <end_op>
    return -1;
80105948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010594d:	e9 64 ff ff ff       	jmp    801058b6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105952:	83 ec 0c             	sub    $0xc,%esp
80105955:	68 58 81 10 80       	push   $0x80108158
8010595a:	e8 21 aa ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010595f:	83 ec 0c             	sub    $0xc,%esp
80105962:	68 6a 81 10 80       	push   $0x8010816a
80105967:	e8 14 aa ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010596c:	83 ec 0c             	sub    $0xc,%esp
8010596f:	68 46 81 10 80       	push   $0x80108146
80105974:	e8 07 aa ff ff       	call   80100380 <panic>
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105980 <sys_open>:

int
sys_open(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	57                   	push   %edi
80105984:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105985:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105988:	53                   	push   %ebx
80105989:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010598c:	50                   	push   %eax
8010598d:	6a 00                	push   $0x0
8010598f:	e8 fc f7 ff ff       	call   80105190 <argstr>
80105994:	83 c4 10             	add    $0x10,%esp
80105997:	85 c0                	test   %eax,%eax
80105999:	0f 88 8e 00 00 00    	js     80105a2d <sys_open+0xad>
8010599f:	83 ec 08             	sub    $0x8,%esp
801059a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059a5:	50                   	push   %eax
801059a6:	6a 01                	push   $0x1
801059a8:	e8 33 f7 ff ff       	call   801050e0 <argint>
801059ad:	83 c4 10             	add    $0x10,%esp
801059b0:	85 c0                	test   %eax,%eax
801059b2:	78 79                	js     80105a2d <sys_open+0xad>
    return -1;

  begin_op();
801059b4:	e8 97 d4 ff ff       	call   80102e50 <begin_op>

  if(omode & O_CREATE){
801059b9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801059bd:	75 79                	jne    80105a38 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801059bf:	83 ec 0c             	sub    $0xc,%esp
801059c2:	ff 75 e0             	push   -0x20(%ebp)
801059c5:	e8 c6 c7 ff ff       	call   80102190 <namei>
801059ca:	83 c4 10             	add    $0x10,%esp
801059cd:	89 c6                	mov    %eax,%esi
801059cf:	85 c0                	test   %eax,%eax
801059d1:	0f 84 7e 00 00 00    	je     80105a55 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801059d7:	83 ec 0c             	sub    $0xc,%esp
801059da:	50                   	push   %eax
801059db:	e8 90 be ff ff       	call   80101870 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801059e0:	83 c4 10             	add    $0x10,%esp
801059e3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801059e8:	0f 84 c2 00 00 00    	je     80105ab0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801059ee:	e8 2d b5 ff ff       	call   80100f20 <filealloc>
801059f3:	89 c7                	mov    %eax,%edi
801059f5:	85 c0                	test   %eax,%eax
801059f7:	74 23                	je     80105a1c <sys_open+0x9c>
  struct proc *curproc = myproc();
801059f9:	e8 22 e1 ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801059fe:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105a00:	8b 54 98 18          	mov    0x18(%eax,%ebx,4),%edx
80105a04:	85 d2                	test   %edx,%edx
80105a06:	74 60                	je     80105a68 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105a08:	83 c3 01             	add    $0x1,%ebx
80105a0b:	83 fb 10             	cmp    $0x10,%ebx
80105a0e:	75 f0                	jne    80105a00 <sys_open+0x80>
    if(f)
      fileclose(f);
80105a10:	83 ec 0c             	sub    $0xc,%esp
80105a13:	57                   	push   %edi
80105a14:	e8 c7 b5 ff ff       	call   80100fe0 <fileclose>
80105a19:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105a1c:	83 ec 0c             	sub    $0xc,%esp
80105a1f:	56                   	push   %esi
80105a20:	e8 db c0 ff ff       	call   80101b00 <iunlockput>
    end_op();
80105a25:	e8 96 d4 ff ff       	call   80102ec0 <end_op>
    return -1;
80105a2a:	83 c4 10             	add    $0x10,%esp
80105a2d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a32:	eb 6d                	jmp    80105aa1 <sys_open+0x121>
80105a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105a38:	83 ec 0c             	sub    $0xc,%esp
80105a3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105a3e:	31 c9                	xor    %ecx,%ecx
80105a40:	ba 02 00 00 00       	mov    $0x2,%edx
80105a45:	6a 00                	push   $0x0
80105a47:	e8 14 f8 ff ff       	call   80105260 <create>
    if(ip == 0){
80105a4c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105a4f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105a51:	85 c0                	test   %eax,%eax
80105a53:	75 99                	jne    801059ee <sys_open+0x6e>
      end_op();
80105a55:	e8 66 d4 ff ff       	call   80102ec0 <end_op>
      return -1;
80105a5a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a5f:	eb 40                	jmp    80105aa1 <sys_open+0x121>
80105a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105a68:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105a6b:	89 7c 98 18          	mov    %edi,0x18(%eax,%ebx,4)
  iunlock(ip);
80105a6f:	56                   	push   %esi
80105a70:	e8 db be ff ff       	call   80101950 <iunlock>
  end_op();
80105a75:	e8 46 d4 ff ff       	call   80102ec0 <end_op>

  f->type = FD_INODE;
80105a7a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105a80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a83:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105a86:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105a89:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105a8b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105a92:	f7 d0                	not    %eax
80105a94:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a97:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105a9a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a9d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105aa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aa4:	89 d8                	mov    %ebx,%eax
80105aa6:	5b                   	pop    %ebx
80105aa7:	5e                   	pop    %esi
80105aa8:	5f                   	pop    %edi
80105aa9:	5d                   	pop    %ebp
80105aaa:	c3                   	ret    
80105aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aaf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ab0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105ab3:	85 c9                	test   %ecx,%ecx
80105ab5:	0f 84 33 ff ff ff    	je     801059ee <sys_open+0x6e>
80105abb:	e9 5c ff ff ff       	jmp    80105a1c <sys_open+0x9c>

80105ac0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105ac6:	e8 85 d3 ff ff       	call   80102e50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105acb:	83 ec 08             	sub    $0x8,%esp
80105ace:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ad1:	50                   	push   %eax
80105ad2:	6a 00                	push   $0x0
80105ad4:	e8 b7 f6 ff ff       	call   80105190 <argstr>
80105ad9:	83 c4 10             	add    $0x10,%esp
80105adc:	85 c0                	test   %eax,%eax
80105ade:	78 30                	js     80105b10 <sys_mkdir+0x50>
80105ae0:	83 ec 0c             	sub    $0xc,%esp
80105ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae6:	31 c9                	xor    %ecx,%ecx
80105ae8:	ba 01 00 00 00       	mov    $0x1,%edx
80105aed:	6a 00                	push   $0x0
80105aef:	e8 6c f7 ff ff       	call   80105260 <create>
80105af4:	83 c4 10             	add    $0x10,%esp
80105af7:	85 c0                	test   %eax,%eax
80105af9:	74 15                	je     80105b10 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105afb:	83 ec 0c             	sub    $0xc,%esp
80105afe:	50                   	push   %eax
80105aff:	e8 fc bf ff ff       	call   80101b00 <iunlockput>
  end_op();
80105b04:	e8 b7 d3 ff ff       	call   80102ec0 <end_op>
  return 0;
80105b09:	83 c4 10             	add    $0x10,%esp
80105b0c:	31 c0                	xor    %eax,%eax
}
80105b0e:	c9                   	leave  
80105b0f:	c3                   	ret    
    end_op();
80105b10:	e8 ab d3 ff ff       	call   80102ec0 <end_op>
    return -1;
80105b15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b1a:	c9                   	leave  
80105b1b:	c3                   	ret    
80105b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b20 <sys_mknod>:

int
sys_mknod(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105b26:	e8 25 d3 ff ff       	call   80102e50 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105b2b:	83 ec 08             	sub    $0x8,%esp
80105b2e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b31:	50                   	push   %eax
80105b32:	6a 00                	push   $0x0
80105b34:	e8 57 f6 ff ff       	call   80105190 <argstr>
80105b39:	83 c4 10             	add    $0x10,%esp
80105b3c:	85 c0                	test   %eax,%eax
80105b3e:	78 60                	js     80105ba0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105b40:	83 ec 08             	sub    $0x8,%esp
80105b43:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b46:	50                   	push   %eax
80105b47:	6a 01                	push   $0x1
80105b49:	e8 92 f5 ff ff       	call   801050e0 <argint>
  if((argstr(0, &path)) < 0 ||
80105b4e:	83 c4 10             	add    $0x10,%esp
80105b51:	85 c0                	test   %eax,%eax
80105b53:	78 4b                	js     80105ba0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105b55:	83 ec 08             	sub    $0x8,%esp
80105b58:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b5b:	50                   	push   %eax
80105b5c:	6a 02                	push   $0x2
80105b5e:	e8 7d f5 ff ff       	call   801050e0 <argint>
     argint(1, &major) < 0 ||
80105b63:	83 c4 10             	add    $0x10,%esp
80105b66:	85 c0                	test   %eax,%eax
80105b68:	78 36                	js     80105ba0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105b6a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105b6e:	83 ec 0c             	sub    $0xc,%esp
80105b71:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105b75:	ba 03 00 00 00       	mov    $0x3,%edx
80105b7a:	50                   	push   %eax
80105b7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b7e:	e8 dd f6 ff ff       	call   80105260 <create>
     argint(2, &minor) < 0 ||
80105b83:	83 c4 10             	add    $0x10,%esp
80105b86:	85 c0                	test   %eax,%eax
80105b88:	74 16                	je     80105ba0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b8a:	83 ec 0c             	sub    $0xc,%esp
80105b8d:	50                   	push   %eax
80105b8e:	e8 6d bf ff ff       	call   80101b00 <iunlockput>
  end_op();
80105b93:	e8 28 d3 ff ff       	call   80102ec0 <end_op>
  return 0;
80105b98:	83 c4 10             	add    $0x10,%esp
80105b9b:	31 c0                	xor    %eax,%eax
}
80105b9d:	c9                   	leave  
80105b9e:	c3                   	ret    
80105b9f:	90                   	nop
    end_op();
80105ba0:	e8 1b d3 ff ff       	call   80102ec0 <end_op>
    return -1;
80105ba5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105baa:	c9                   	leave  
80105bab:	c3                   	ret    
80105bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bb0 <sys_chdir>:

int
sys_chdir(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	56                   	push   %esi
80105bb4:	53                   	push   %ebx
80105bb5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105bb8:	e8 63 df ff ff       	call   80103b20 <myproc>
80105bbd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105bbf:	e8 8c d2 ff ff       	call   80102e50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105bc4:	83 ec 08             	sub    $0x8,%esp
80105bc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bca:	50                   	push   %eax
80105bcb:	6a 00                	push   $0x0
80105bcd:	e8 be f5 ff ff       	call   80105190 <argstr>
80105bd2:	83 c4 10             	add    $0x10,%esp
80105bd5:	85 c0                	test   %eax,%eax
80105bd7:	78 77                	js     80105c50 <sys_chdir+0xa0>
80105bd9:	83 ec 0c             	sub    $0xc,%esp
80105bdc:	ff 75 f4             	push   -0xc(%ebp)
80105bdf:	e8 ac c5 ff ff       	call   80102190 <namei>
80105be4:	83 c4 10             	add    $0x10,%esp
80105be7:	89 c3                	mov    %eax,%ebx
80105be9:	85 c0                	test   %eax,%eax
80105beb:	74 63                	je     80105c50 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105bed:	83 ec 0c             	sub    $0xc,%esp
80105bf0:	50                   	push   %eax
80105bf1:	e8 7a bc ff ff       	call   80101870 <ilock>
  if(ip->type != T_DIR){
80105bf6:	83 c4 10             	add    $0x10,%esp
80105bf9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105bfe:	75 30                	jne    80105c30 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105c00:	83 ec 0c             	sub    $0xc,%esp
80105c03:	53                   	push   %ebx
80105c04:	e8 47 bd ff ff       	call   80101950 <iunlock>
  iput(curproc->cwd);
80105c09:	58                   	pop    %eax
80105c0a:	ff 76 58             	push   0x58(%esi)
80105c0d:	e8 8e bd ff ff       	call   801019a0 <iput>
  end_op();
80105c12:	e8 a9 d2 ff ff       	call   80102ec0 <end_op>
  curproc->cwd = ip;
80105c17:	89 5e 58             	mov    %ebx,0x58(%esi)
  return 0;
80105c1a:	83 c4 10             	add    $0x10,%esp
80105c1d:	31 c0                	xor    %eax,%eax
}
80105c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c22:	5b                   	pop    %ebx
80105c23:	5e                   	pop    %esi
80105c24:	5d                   	pop    %ebp
80105c25:	c3                   	ret    
80105c26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105c30:	83 ec 0c             	sub    $0xc,%esp
80105c33:	53                   	push   %ebx
80105c34:	e8 c7 be ff ff       	call   80101b00 <iunlockput>
    end_op();
80105c39:	e8 82 d2 ff ff       	call   80102ec0 <end_op>
    return -1;
80105c3e:	83 c4 10             	add    $0x10,%esp
80105c41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c46:	eb d7                	jmp    80105c1f <sys_chdir+0x6f>
80105c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4f:	90                   	nop
    end_op();
80105c50:	e8 6b d2 ff ff       	call   80102ec0 <end_op>
    return -1;
80105c55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c5a:	eb c3                	jmp    80105c1f <sys_chdir+0x6f>
80105c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c60 <sys_exec>:

int
sys_exec(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	57                   	push   %edi
80105c64:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c65:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105c6b:	53                   	push   %ebx
80105c6c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c72:	50                   	push   %eax
80105c73:	6a 00                	push   $0x0
80105c75:	e8 16 f5 ff ff       	call   80105190 <argstr>
80105c7a:	83 c4 10             	add    $0x10,%esp
80105c7d:	85 c0                	test   %eax,%eax
80105c7f:	0f 88 87 00 00 00    	js     80105d0c <sys_exec+0xac>
80105c85:	83 ec 08             	sub    $0x8,%esp
80105c88:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105c8e:	50                   	push   %eax
80105c8f:	6a 01                	push   $0x1
80105c91:	e8 4a f4 ff ff       	call   801050e0 <argint>
80105c96:	83 c4 10             	add    $0x10,%esp
80105c99:	85 c0                	test   %eax,%eax
80105c9b:	78 6f                	js     80105d0c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105c9d:	83 ec 04             	sub    $0x4,%esp
80105ca0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105ca6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105ca8:	68 80 00 00 00       	push   $0x80
80105cad:	6a 00                	push   $0x0
80105caf:	56                   	push   %esi
80105cb0:	e8 6b f1 ff ff       	call   80104e20 <memset>
80105cb5:	83 c4 10             	add    $0x10,%esp
80105cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbf:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105cc0:	83 ec 08             	sub    $0x8,%esp
80105cc3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105cc9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105cd0:	50                   	push   %eax
80105cd1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105cd7:	01 f8                	add    %edi,%eax
80105cd9:	50                   	push   %eax
80105cda:	e8 71 f3 ff ff       	call   80105050 <fetchint>
80105cdf:	83 c4 10             	add    $0x10,%esp
80105ce2:	85 c0                	test   %eax,%eax
80105ce4:	78 26                	js     80105d0c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105ce6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105cec:	85 c0                	test   %eax,%eax
80105cee:	74 30                	je     80105d20 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105cf0:	83 ec 08             	sub    $0x8,%esp
80105cf3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105cf6:	52                   	push   %edx
80105cf7:	50                   	push   %eax
80105cf8:	e8 93 f3 ff ff       	call   80105090 <fetchstr>
80105cfd:	83 c4 10             	add    $0x10,%esp
80105d00:	85 c0                	test   %eax,%eax
80105d02:	78 08                	js     80105d0c <sys_exec+0xac>
  for(i=0;; i++){
80105d04:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105d07:	83 fb 20             	cmp    $0x20,%ebx
80105d0a:	75 b4                	jne    80105cc0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105d0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d14:	5b                   	pop    %ebx
80105d15:	5e                   	pop    %esi
80105d16:	5f                   	pop    %edi
80105d17:	5d                   	pop    %ebp
80105d18:	c3                   	ret    
80105d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105d20:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105d27:	00 00 00 00 
  return exec(path, argv);
80105d2b:	83 ec 08             	sub    $0x8,%esp
80105d2e:	56                   	push   %esi
80105d2f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105d35:	e8 76 ad ff ff       	call   80100ab0 <exec>
80105d3a:	83 c4 10             	add    $0x10,%esp
}
80105d3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d40:	5b                   	pop    %ebx
80105d41:	5e                   	pop    %esi
80105d42:	5f                   	pop    %edi
80105d43:	5d                   	pop    %ebp
80105d44:	c3                   	ret    
80105d45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d50 <sys_pipe>:

int
sys_pipe(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	57                   	push   %edi
80105d54:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d55:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105d58:	53                   	push   %ebx
80105d59:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d5c:	6a 08                	push   $0x8
80105d5e:	50                   	push   %eax
80105d5f:	6a 00                	push   $0x0
80105d61:	e8 da f3 ff ff       	call   80105140 <argptr>
80105d66:	83 c4 10             	add    $0x10,%esp
80105d69:	85 c0                	test   %eax,%eax
80105d6b:	78 4a                	js     80105db7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105d6d:	83 ec 08             	sub    $0x8,%esp
80105d70:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d73:	50                   	push   %eax
80105d74:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d77:	50                   	push   %eax
80105d78:	e8 a3 d7 ff ff       	call   80103520 <pipealloc>
80105d7d:	83 c4 10             	add    $0x10,%esp
80105d80:	85 c0                	test   %eax,%eax
80105d82:	78 33                	js     80105db7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d84:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105d87:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105d89:	e8 92 dd ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d8e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105d90:	8b 74 98 18          	mov    0x18(%eax,%ebx,4),%esi
80105d94:	85 f6                	test   %esi,%esi
80105d96:	74 28                	je     80105dc0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105d98:	83 c3 01             	add    $0x1,%ebx
80105d9b:	83 fb 10             	cmp    $0x10,%ebx
80105d9e:	75 f0                	jne    80105d90 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105da0:	83 ec 0c             	sub    $0xc,%esp
80105da3:	ff 75 e0             	push   -0x20(%ebp)
80105da6:	e8 35 b2 ff ff       	call   80100fe0 <fileclose>
    fileclose(wf);
80105dab:	58                   	pop    %eax
80105dac:	ff 75 e4             	push   -0x1c(%ebp)
80105daf:	e8 2c b2 ff ff       	call   80100fe0 <fileclose>
    return -1;
80105db4:	83 c4 10             	add    $0x10,%esp
80105db7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dbc:	eb 53                	jmp    80105e11 <sys_pipe+0xc1>
80105dbe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105dc0:	8d 73 04             	lea    0x4(%ebx),%esi
80105dc3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105dc7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105dca:	e8 51 dd ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105dcf:	31 d2                	xor    %edx,%edx
80105dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105dd8:	8b 4c 90 18          	mov    0x18(%eax,%edx,4),%ecx
80105ddc:	85 c9                	test   %ecx,%ecx
80105dde:	74 20                	je     80105e00 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105de0:	83 c2 01             	add    $0x1,%edx
80105de3:	83 fa 10             	cmp    $0x10,%edx
80105de6:	75 f0                	jne    80105dd8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105de8:	e8 33 dd ff ff       	call   80103b20 <myproc>
80105ded:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105df4:	00 
80105df5:	eb a9                	jmp    80105da0 <sys_pipe+0x50>
80105df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dfe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e00:	89 7c 90 18          	mov    %edi,0x18(%eax,%edx,4)
  }
  fd[0] = fd0;
80105e04:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e07:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105e09:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e0c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105e0f:	31 c0                	xor    %eax,%eax
}
80105e11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e14:	5b                   	pop    %ebx
80105e15:	5e                   	pop    %esi
80105e16:	5f                   	pop    %edi
80105e17:	5d                   	pop    %ebp
80105e18:	c3                   	ret    
80105e19:	66 90                	xchg   %ax,%ax
80105e1b:	66 90                	xchg   %ax,%ax
80105e1d:	66 90                	xchg   %ax,%ax
80105e1f:	90                   	nop

80105e20 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105e20:	e9 ab de ff ff       	jmp    80103cd0 <fork>
80105e25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e30 <sys_exit>:
}

int
sys_exit(void)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e36:	e8 95 e1 ff ff       	call   80103fd0 <exit>
  return 0;  // not reached
}
80105e3b:	31 c0                	xor    %eax,%eax
80105e3d:	c9                   	leave  
80105e3e:	c3                   	ret    
80105e3f:	90                   	nop

80105e40 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105e40:	e9 0b e4 ff ff       	jmp    80104250 <wait>
80105e45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e50 <sys_kill>:
}

int
sys_kill(void)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105e56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e59:	50                   	push   %eax
80105e5a:	6a 00                	push   $0x0
80105e5c:	e8 7f f2 ff ff       	call   801050e0 <argint>
80105e61:	83 c4 10             	add    $0x10,%esp
80105e64:	85 c0                	test   %eax,%eax
80105e66:	78 18                	js     80105e80 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105e68:	83 ec 0c             	sub    $0xc,%esp
80105e6b:	ff 75 f4             	push   -0xc(%ebp)
80105e6e:	e8 4d e5 ff ff       	call   801043c0 <kill>
80105e73:	83 c4 10             	add    $0x10,%esp
}
80105e76:	c9                   	leave  
80105e77:	c3                   	ret    
80105e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e7f:	90                   	nop
80105e80:	c9                   	leave  
    return -1;
80105e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e86:	c3                   	ret    
80105e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e8e:	66 90                	xchg   %ax,%ax

80105e90 <sys_getpid>:

int
sys_getpid(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105e96:	e8 85 dc ff ff       	call   80103b20 <myproc>
80105e9b:	8b 40 0c             	mov    0xc(%eax),%eax
}
80105e9e:	c9                   	leave  
80105e9f:	c3                   	ret    

80105ea0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ea4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ea7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105eaa:	50                   	push   %eax
80105eab:	6a 00                	push   $0x0
80105ead:	e8 2e f2 ff ff       	call   801050e0 <argint>
80105eb2:	83 c4 10             	add    $0x10,%esp
80105eb5:	85 c0                	test   %eax,%eax
80105eb7:	78 27                	js     80105ee0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105eb9:	e8 62 dc ff ff       	call   80103b20 <myproc>
  if(growproc(n) < 0)
80105ebe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ec1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ec3:	ff 75 f4             	push   -0xc(%ebp)
80105ec6:	e8 85 dd ff ff       	call   80103c50 <growproc>
80105ecb:	83 c4 10             	add    $0x10,%esp
80105ece:	85 c0                	test   %eax,%eax
80105ed0:	78 0e                	js     80105ee0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ed2:	89 d8                	mov    %ebx,%eax
80105ed4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ed7:	c9                   	leave  
80105ed8:	c3                   	ret    
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ee0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ee5:	eb eb                	jmp    80105ed2 <sys_sbrk+0x32>
80105ee7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eee:	66 90                	xchg   %ax,%ax

80105ef0 <sys_sleep>:

int
sys_sleep(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ef4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ef7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105efa:	50                   	push   %eax
80105efb:	6a 00                	push   $0x0
80105efd:	e8 de f1 ff ff       	call   801050e0 <argint>
80105f02:	83 c4 10             	add    $0x10,%esp
80105f05:	85 c0                	test   %eax,%eax
80105f07:	0f 88 8a 00 00 00    	js     80105f97 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105f0d:	83 ec 0c             	sub    $0xc,%esp
80105f10:	68 80 49 13 80       	push   $0x80134980
80105f15:	e8 46 ee ff ff       	call   80104d60 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105f1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105f1d:	8b 1d 60 49 13 80    	mov    0x80134960,%ebx
  while(ticks - ticks0 < n){
80105f23:	83 c4 10             	add    $0x10,%esp
80105f26:	85 d2                	test   %edx,%edx
80105f28:	75 27                	jne    80105f51 <sys_sleep+0x61>
80105f2a:	eb 54                	jmp    80105f80 <sys_sleep+0x90>
80105f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105f30:	83 ec 08             	sub    $0x8,%esp
80105f33:	68 80 49 13 80       	push   $0x80134980
80105f38:	68 60 49 13 80       	push   $0x80134960
80105f3d:	e8 fe e1 ff ff       	call   80104140 <sleep>
  while(ticks - ticks0 < n){
80105f42:	a1 60 49 13 80       	mov    0x80134960,%eax
80105f47:	83 c4 10             	add    $0x10,%esp
80105f4a:	29 d8                	sub    %ebx,%eax
80105f4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105f4f:	73 2f                	jae    80105f80 <sys_sleep+0x90>
    if(myproc()->killed){
80105f51:	e8 ca db ff ff       	call   80103b20 <myproc>
80105f56:	8b 40 14             	mov    0x14(%eax),%eax
80105f59:	85 c0                	test   %eax,%eax
80105f5b:	74 d3                	je     80105f30 <sys_sleep+0x40>
      release(&tickslock);
80105f5d:	83 ec 0c             	sub    $0xc,%esp
80105f60:	68 80 49 13 80       	push   $0x80134980
80105f65:	e8 96 ed ff ff       	call   80104d00 <release>
  }
  release(&tickslock);
  return 0;
}
80105f6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105f6d:	83 c4 10             	add    $0x10,%esp
80105f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f75:	c9                   	leave  
80105f76:	c3                   	ret    
80105f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105f80:	83 ec 0c             	sub    $0xc,%esp
80105f83:	68 80 49 13 80       	push   $0x80134980
80105f88:	e8 73 ed ff ff       	call   80104d00 <release>
  return 0;
80105f8d:	83 c4 10             	add    $0x10,%esp
80105f90:	31 c0                	xor    %eax,%eax
}
80105f92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f95:	c9                   	leave  
80105f96:	c3                   	ret    
    return -1;
80105f97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f9c:	eb f4                	jmp    80105f92 <sys_sleep+0xa2>
80105f9e:	66 90                	xchg   %ax,%ax

80105fa0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	53                   	push   %ebx
80105fa4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105fa7:	68 80 49 13 80       	push   $0x80134980
80105fac:	e8 af ed ff ff       	call   80104d60 <acquire>
  xticks = ticks;
80105fb1:	8b 1d 60 49 13 80    	mov    0x80134960,%ebx
  release(&tickslock);
80105fb7:	c7 04 24 80 49 13 80 	movl   $0x80134980,(%esp)
80105fbe:	e8 3d ed ff ff       	call   80104d00 <release>
  return xticks;
}
80105fc3:	89 d8                	mov    %ebx,%eax
80105fc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fc8:	c9                   	leave  
80105fc9:	c3                   	ret    

80105fca <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105fca:	1e                   	push   %ds
  pushl %es
80105fcb:	06                   	push   %es
  pushl %fs
80105fcc:	0f a0                	push   %fs
  pushl %gs
80105fce:	0f a8                	push   %gs
  pushal
80105fd0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105fd1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105fd5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105fd7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105fd9:	54                   	push   %esp
  call trap
80105fda:	e8 c1 00 00 00       	call   801060a0 <trap>
  addl $4, %esp
80105fdf:	83 c4 04             	add    $0x4,%esp

80105fe2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105fe2:	61                   	popa   
  popl %gs
80105fe3:	0f a9                	pop    %gs
  popl %fs
80105fe5:	0f a1                	pop    %fs
  popl %es
80105fe7:	07                   	pop    %es
  popl %ds
80105fe8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105fe9:	83 c4 08             	add    $0x8,%esp
  iret
80105fec:	cf                   	iret   
80105fed:	66 90                	xchg   %ax,%ax
80105fef:	90                   	nop

80105ff0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ff0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105ff1:	31 c0                	xor    %eax,%eax
{
80105ff3:	89 e5                	mov    %esp,%ebp
80105ff5:	83 ec 08             	sub    $0x8,%esp
80105ff8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fff:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106000:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80106007:	c7 04 c5 c2 49 13 80 	movl   $0x8e000008,-0x7fecb63e(,%eax,8)
8010600e:	08 00 00 8e 
80106012:	66 89 14 c5 c0 49 13 	mov    %dx,-0x7fecb640(,%eax,8)
80106019:	80 
8010601a:	c1 ea 10             	shr    $0x10,%edx
8010601d:	66 89 14 c5 c6 49 13 	mov    %dx,-0x7fecb63a(,%eax,8)
80106024:	80 
  for(i = 0; i < 256; i++)
80106025:	83 c0 01             	add    $0x1,%eax
80106028:	3d 00 01 00 00       	cmp    $0x100,%eax
8010602d:	75 d1                	jne    80106000 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010602f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106032:	a1 0c b1 10 80       	mov    0x8010b10c,%eax
80106037:	c7 05 c2 4b 13 80 08 	movl   $0xef000008,0x80134bc2
8010603e:	00 00 ef 
  initlock(&tickslock, "time");
80106041:	68 79 81 10 80       	push   $0x80108179
80106046:	68 80 49 13 80       	push   $0x80134980
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010604b:	66 a3 c0 4b 13 80    	mov    %ax,0x80134bc0
80106051:	c1 e8 10             	shr    $0x10,%eax
80106054:	66 a3 c6 4b 13 80    	mov    %ax,0x80134bc6
  initlock(&tickslock, "time");
8010605a:	e8 31 eb ff ff       	call   80104b90 <initlock>
}
8010605f:	83 c4 10             	add    $0x10,%esp
80106062:	c9                   	leave  
80106063:	c3                   	ret    
80106064:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010606b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010606f:	90                   	nop

80106070 <idtinit>:

void
idtinit(void)
{
80106070:	55                   	push   %ebp
  pd[0] = size-1;
80106071:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106076:	89 e5                	mov    %esp,%ebp
80106078:	83 ec 10             	sub    $0x10,%esp
8010607b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010607f:	b8 c0 49 13 80       	mov    $0x801349c0,%eax
80106084:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106088:	c1 e8 10             	shr    $0x10,%eax
8010608b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010608f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106092:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106095:	c9                   	leave  
80106096:	c3                   	ret    
80106097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010609e:	66 90                	xchg   %ax,%ax

801060a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	57                   	push   %edi
801060a4:	56                   	push   %esi
801060a5:	53                   	push   %ebx
801060a6:	83 ec 1c             	sub    $0x1c,%esp
801060a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801060ac:	8b 43 30             	mov    0x30(%ebx),%eax
801060af:	83 f8 40             	cmp    $0x40,%eax
801060b2:	0f 84 68 01 00 00    	je     80106220 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801060b8:	83 e8 20             	sub    $0x20,%eax
801060bb:	83 f8 1f             	cmp    $0x1f,%eax
801060be:	0f 87 8c 00 00 00    	ja     80106150 <trap+0xb0>
801060c4:	ff 24 85 20 82 10 80 	jmp    *-0x7fef7de0(,%eax,4)
801060cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060cf:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801060d0:	e8 5b c2 ff ff       	call   80102330 <ideintr>
    lapiceoi();
801060d5:	e8 26 c9 ff ff       	call   80102a00 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060da:	e8 41 da ff ff       	call   80103b20 <myproc>
801060df:	85 c0                	test   %eax,%eax
801060e1:	74 1d                	je     80106100 <trap+0x60>
801060e3:	e8 38 da ff ff       	call   80103b20 <myproc>
801060e8:	8b 50 14             	mov    0x14(%eax),%edx
801060eb:	85 d2                	test   %edx,%edx
801060ed:	74 11                	je     80106100 <trap+0x60>
801060ef:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801060f3:	83 e0 03             	and    $0x3,%eax
801060f6:	66 83 f8 03          	cmp    $0x3,%ax
801060fa:	0f 84 f8 01 00 00    	je     801062f8 <trap+0x258>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106100:	e8 1b da ff ff       	call   80103b20 <myproc>
80106105:	85 c0                	test   %eax,%eax
80106107:	74 0f                	je     80106118 <trap+0x78>
80106109:	e8 12 da ff ff       	call   80103b20 <myproc>
8010610e:	83 78 08 04          	cmpl   $0x4,0x8(%eax)
80106112:	0f 84 b8 00 00 00    	je     801061d0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106118:	e8 03 da ff ff       	call   80103b20 <myproc>
8010611d:	85 c0                	test   %eax,%eax
8010611f:	74 1d                	je     8010613e <trap+0x9e>
80106121:	e8 fa d9 ff ff       	call   80103b20 <myproc>
80106126:	8b 40 14             	mov    0x14(%eax),%eax
80106129:	85 c0                	test   %eax,%eax
8010612b:	74 11                	je     8010613e <trap+0x9e>
8010612d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106131:	83 e0 03             	and    $0x3,%eax
80106134:	66 83 f8 03          	cmp    $0x3,%ax
80106138:	0f 84 20 01 00 00    	je     8010625e <trap+0x1be>
    exit();
}
8010613e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106141:	5b                   	pop    %ebx
80106142:	5e                   	pop    %esi
80106143:	5f                   	pop    %edi
80106144:	5d                   	pop    %ebp
80106145:	c3                   	ret    
80106146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106150:	e8 cb d9 ff ff       	call   80103b20 <myproc>
80106155:	8b 7b 38             	mov    0x38(%ebx),%edi
80106158:	85 c0                	test   %eax,%eax
8010615a:	0f 84 b2 01 00 00    	je     80106312 <trap+0x272>
80106160:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106164:	0f 84 a8 01 00 00    	je     80106312 <trap+0x272>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010616a:	0f 20 d1             	mov    %cr2,%ecx
8010616d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106170:	e8 8b d9 ff ff       	call   80103b00 <cpuid>
80106175:	8b 73 30             	mov    0x30(%ebx),%esi
80106178:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010617b:	8b 43 34             	mov    0x34(%ebx),%eax
8010617e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106181:	e8 9a d9 ff ff       	call   80103b20 <myproc>
80106186:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106189:	e8 92 d9 ff ff       	call   80103b20 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010618e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106191:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106194:	51                   	push   %ecx
80106195:	57                   	push   %edi
80106196:	52                   	push   %edx
80106197:	ff 75 e4             	push   -0x1c(%ebp)
8010619a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010619b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010619e:	83 c6 5c             	add    $0x5c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061a1:	56                   	push   %esi
801061a2:	ff 70 0c             	push   0xc(%eax)
801061a5:	68 dc 81 10 80       	push   $0x801081dc
801061aa:	e8 f1 a4 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
801061af:	83 c4 20             	add    $0x20,%esp
801061b2:	e8 69 d9 ff ff       	call   80103b20 <myproc>
801061b7:	c7 40 14 01 00 00 00 	movl   $0x1,0x14(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061be:	e8 5d d9 ff ff       	call   80103b20 <myproc>
801061c3:	85 c0                	test   %eax,%eax
801061c5:	0f 85 18 ff ff ff    	jne    801060e3 <trap+0x43>
801061cb:	e9 30 ff ff ff       	jmp    80106100 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
801061d0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801061d4:	0f 85 3e ff ff ff    	jne    80106118 <trap+0x78>
    yield();
801061da:	e8 f1 de ff ff       	call   801040d0 <yield>
801061df:	e9 34 ff ff ff       	jmp    80106118 <trap+0x78>
801061e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801061e8:	8b 7b 38             	mov    0x38(%ebx),%edi
801061eb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801061ef:	e8 0c d9 ff ff       	call   80103b00 <cpuid>
801061f4:	57                   	push   %edi
801061f5:	56                   	push   %esi
801061f6:	50                   	push   %eax
801061f7:	68 84 81 10 80       	push   $0x80108184
801061fc:	e8 9f a4 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106201:	e8 fa c7 ff ff       	call   80102a00 <lapiceoi>
    break;
80106206:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106209:	e8 12 d9 ff ff       	call   80103b20 <myproc>
8010620e:	85 c0                	test   %eax,%eax
80106210:	0f 85 cd fe ff ff    	jne    801060e3 <trap+0x43>
80106216:	e9 e5 fe ff ff       	jmp    80106100 <trap+0x60>
8010621b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010621f:	90                   	nop
    if(myproc()->killed)
80106220:	e8 fb d8 ff ff       	call   80103b20 <myproc>
80106225:	8b 70 14             	mov    0x14(%eax),%esi
80106228:	85 f6                	test   %esi,%esi
8010622a:	0f 85 d8 00 00 00    	jne    80106308 <trap+0x268>
	struct thread *t = &myproc()->threads[myproc()->curtidx];
80106230:	e8 eb d8 ff ff       	call   80103b20 <myproc>
80106235:	89 c6                	mov    %eax,%esi
80106237:	e8 e4 d8 ff ff       	call   80103b20 <myproc>
8010623c:	8b 80 6c 08 00 00    	mov    0x86c(%eax),%eax
    t->tf = tf;
80106242:	c1 e0 05             	shl    $0x5,%eax
80106245:	89 5c 30 78          	mov    %ebx,0x78(%eax,%esi,1)
    syscall();
80106249:	e8 a2 ef ff ff       	call   801051f0 <syscall>
    if(myproc()->killed)
8010624e:	e8 cd d8 ff ff       	call   80103b20 <myproc>
80106253:	8b 48 14             	mov    0x14(%eax),%ecx
80106256:	85 c9                	test   %ecx,%ecx
80106258:	0f 84 e0 fe ff ff    	je     8010613e <trap+0x9e>
}
8010625e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106261:	5b                   	pop    %ebx
80106262:	5e                   	pop    %esi
80106263:	5f                   	pop    %edi
80106264:	5d                   	pop    %ebp
      exit();
80106265:	e9 66 dd ff ff       	jmp    80103fd0 <exit>
8010626a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartintr();
80106270:	e8 3b 02 00 00       	call   801064b0 <uartintr>
    lapiceoi();
80106275:	e8 86 c7 ff ff       	call   80102a00 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010627a:	e8 a1 d8 ff ff       	call   80103b20 <myproc>
8010627f:	85 c0                	test   %eax,%eax
80106281:	0f 85 5c fe ff ff    	jne    801060e3 <trap+0x43>
80106287:	e9 74 fe ff ff       	jmp    80106100 <trap+0x60>
8010628c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106290:	e8 2b c6 ff ff       	call   801028c0 <kbdintr>
    lapiceoi();
80106295:	e8 66 c7 ff ff       	call   80102a00 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010629a:	e8 81 d8 ff ff       	call   80103b20 <myproc>
8010629f:	85 c0                	test   %eax,%eax
801062a1:	0f 85 3c fe ff ff    	jne    801060e3 <trap+0x43>
801062a7:	e9 54 fe ff ff       	jmp    80106100 <trap+0x60>
801062ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801062b0:	e8 4b d8 ff ff       	call   80103b00 <cpuid>
801062b5:	85 c0                	test   %eax,%eax
801062b7:	0f 85 18 fe ff ff    	jne    801060d5 <trap+0x35>
      acquire(&tickslock);
801062bd:	83 ec 0c             	sub    $0xc,%esp
801062c0:	68 80 49 13 80       	push   $0x80134980
801062c5:	e8 96 ea ff ff       	call   80104d60 <acquire>
      wakeup(&ticks);
801062ca:	c7 04 24 60 49 13 80 	movl   $0x80134960,(%esp)
      ticks++;
801062d1:	83 05 60 49 13 80 01 	addl   $0x1,0x80134960
      wakeup(&ticks);
801062d8:	e8 b3 e0 ff ff       	call   80104390 <wakeup>
      release(&tickslock);
801062dd:	c7 04 24 80 49 13 80 	movl   $0x80134980,(%esp)
801062e4:	e8 17 ea ff ff       	call   80104d00 <release>
801062e9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801062ec:	e9 e4 fd ff ff       	jmp    801060d5 <trap+0x35>
801062f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
801062f8:	e8 d3 dc ff ff       	call   80103fd0 <exit>
801062fd:	e9 fe fd ff ff       	jmp    80106100 <trap+0x60>
80106302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106308:	e8 c3 dc ff ff       	call   80103fd0 <exit>
8010630d:	e9 1e ff ff ff       	jmp    80106230 <trap+0x190>
80106312:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106315:	e8 e6 d7 ff ff       	call   80103b00 <cpuid>
8010631a:	83 ec 0c             	sub    $0xc,%esp
8010631d:	56                   	push   %esi
8010631e:	57                   	push   %edi
8010631f:	50                   	push   %eax
80106320:	ff 73 30             	push   0x30(%ebx)
80106323:	68 a8 81 10 80       	push   $0x801081a8
80106328:	e8 73 a3 ff ff       	call   801006a0 <cprintf>
      panic("trap");
8010632d:	83 c4 14             	add    $0x14,%esp
80106330:	68 7e 81 10 80       	push   $0x8010817e
80106335:	e8 46 a0 ff ff       	call   80100380 <panic>
8010633a:	66 90                	xchg   %ax,%ax
8010633c:	66 90                	xchg   %ax,%ax
8010633e:	66 90                	xchg   %ax,%ax

80106340 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106340:	a1 c0 51 13 80       	mov    0x801351c0,%eax
80106345:	85 c0                	test   %eax,%eax
80106347:	74 17                	je     80106360 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106349:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010634e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010634f:	a8 01                	test   $0x1,%al
80106351:	74 0d                	je     80106360 <uartgetc+0x20>
80106353:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106358:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106359:	0f b6 c0             	movzbl %al,%eax
8010635c:	c3                   	ret    
8010635d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106365:	c3                   	ret    
80106366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010636d:	8d 76 00             	lea    0x0(%esi),%esi

80106370 <uartinit>:
{
80106370:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106371:	31 c9                	xor    %ecx,%ecx
80106373:	89 c8                	mov    %ecx,%eax
80106375:	89 e5                	mov    %esp,%ebp
80106377:	57                   	push   %edi
80106378:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010637d:	56                   	push   %esi
8010637e:	89 fa                	mov    %edi,%edx
80106380:	53                   	push   %ebx
80106381:	83 ec 1c             	sub    $0x1c,%esp
80106384:	ee                   	out    %al,(%dx)
80106385:	be fb 03 00 00       	mov    $0x3fb,%esi
8010638a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010638f:	89 f2                	mov    %esi,%edx
80106391:	ee                   	out    %al,(%dx)
80106392:	b8 0c 00 00 00       	mov    $0xc,%eax
80106397:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010639c:	ee                   	out    %al,(%dx)
8010639d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801063a2:	89 c8                	mov    %ecx,%eax
801063a4:	89 da                	mov    %ebx,%edx
801063a6:	ee                   	out    %al,(%dx)
801063a7:	b8 03 00 00 00       	mov    $0x3,%eax
801063ac:	89 f2                	mov    %esi,%edx
801063ae:	ee                   	out    %al,(%dx)
801063af:	ba fc 03 00 00       	mov    $0x3fc,%edx
801063b4:	89 c8                	mov    %ecx,%eax
801063b6:	ee                   	out    %al,(%dx)
801063b7:	b8 01 00 00 00       	mov    $0x1,%eax
801063bc:	89 da                	mov    %ebx,%edx
801063be:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063bf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063c4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801063c5:	3c ff                	cmp    $0xff,%al
801063c7:	74 78                	je     80106441 <uartinit+0xd1>
  uart = 1;
801063c9:	c7 05 c0 51 13 80 01 	movl   $0x1,0x801351c0
801063d0:	00 00 00 
801063d3:	89 fa                	mov    %edi,%edx
801063d5:	ec                   	in     (%dx),%al
801063d6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063db:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801063dc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801063df:	bf a0 82 10 80       	mov    $0x801082a0,%edi
801063e4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801063e9:	6a 00                	push   $0x0
801063eb:	6a 04                	push   $0x4
801063ed:	e8 7e c1 ff ff       	call   80102570 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801063f2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801063f6:	83 c4 10             	add    $0x10,%esp
801063f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106400:	a1 c0 51 13 80       	mov    0x801351c0,%eax
80106405:	bb 80 00 00 00       	mov    $0x80,%ebx
8010640a:	85 c0                	test   %eax,%eax
8010640c:	75 14                	jne    80106422 <uartinit+0xb2>
8010640e:	eb 23                	jmp    80106433 <uartinit+0xc3>
    microdelay(10);
80106410:	83 ec 0c             	sub    $0xc,%esp
80106413:	6a 0a                	push   $0xa
80106415:	e8 06 c6 ff ff       	call   80102a20 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010641a:	83 c4 10             	add    $0x10,%esp
8010641d:	83 eb 01             	sub    $0x1,%ebx
80106420:	74 07                	je     80106429 <uartinit+0xb9>
80106422:	89 f2                	mov    %esi,%edx
80106424:	ec                   	in     (%dx),%al
80106425:	a8 20                	test   $0x20,%al
80106427:	74 e7                	je     80106410 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106429:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010642d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106432:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106433:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106437:	83 c7 01             	add    $0x1,%edi
8010643a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010643d:	84 c0                	test   %al,%al
8010643f:	75 bf                	jne    80106400 <uartinit+0x90>
}
80106441:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106444:	5b                   	pop    %ebx
80106445:	5e                   	pop    %esi
80106446:	5f                   	pop    %edi
80106447:	5d                   	pop    %ebp
80106448:	c3                   	ret    
80106449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106450 <uartputc>:
  if(!uart)
80106450:	a1 c0 51 13 80       	mov    0x801351c0,%eax
80106455:	85 c0                	test   %eax,%eax
80106457:	74 47                	je     801064a0 <uartputc+0x50>
{
80106459:	55                   	push   %ebp
8010645a:	89 e5                	mov    %esp,%ebp
8010645c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010645d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106462:	53                   	push   %ebx
80106463:	bb 80 00 00 00       	mov    $0x80,%ebx
80106468:	eb 18                	jmp    80106482 <uartputc+0x32>
8010646a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106470:	83 ec 0c             	sub    $0xc,%esp
80106473:	6a 0a                	push   $0xa
80106475:	e8 a6 c5 ff ff       	call   80102a20 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010647a:	83 c4 10             	add    $0x10,%esp
8010647d:	83 eb 01             	sub    $0x1,%ebx
80106480:	74 07                	je     80106489 <uartputc+0x39>
80106482:	89 f2                	mov    %esi,%edx
80106484:	ec                   	in     (%dx),%al
80106485:	a8 20                	test   $0x20,%al
80106487:	74 e7                	je     80106470 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106489:	8b 45 08             	mov    0x8(%ebp),%eax
8010648c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106491:	ee                   	out    %al,(%dx)
}
80106492:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106495:	5b                   	pop    %ebx
80106496:	5e                   	pop    %esi
80106497:	5d                   	pop    %ebp
80106498:	c3                   	ret    
80106499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064a0:	c3                   	ret    
801064a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064af:	90                   	nop

801064b0 <uartintr>:

void
uartintr(void)
{
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801064b6:	68 40 63 10 80       	push   $0x80106340
801064bb:	e8 c0 a3 ff ff       	call   80100880 <consoleintr>
}
801064c0:	83 c4 10             	add    $0x10,%esp
801064c3:	c9                   	leave  
801064c4:	c3                   	ret    

801064c5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $0
801064c7:	6a 00                	push   $0x0
  jmp alltraps
801064c9:	e9 fc fa ff ff       	jmp    80105fca <alltraps>

801064ce <vector1>:
.globl vector1
vector1:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $1
801064d0:	6a 01                	push   $0x1
  jmp alltraps
801064d2:	e9 f3 fa ff ff       	jmp    80105fca <alltraps>

801064d7 <vector2>:
.globl vector2
vector2:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $2
801064d9:	6a 02                	push   $0x2
  jmp alltraps
801064db:	e9 ea fa ff ff       	jmp    80105fca <alltraps>

801064e0 <vector3>:
.globl vector3
vector3:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $3
801064e2:	6a 03                	push   $0x3
  jmp alltraps
801064e4:	e9 e1 fa ff ff       	jmp    80105fca <alltraps>

801064e9 <vector4>:
.globl vector4
vector4:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $4
801064eb:	6a 04                	push   $0x4
  jmp alltraps
801064ed:	e9 d8 fa ff ff       	jmp    80105fca <alltraps>

801064f2 <vector5>:
.globl vector5
vector5:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $5
801064f4:	6a 05                	push   $0x5
  jmp alltraps
801064f6:	e9 cf fa ff ff       	jmp    80105fca <alltraps>

801064fb <vector6>:
.globl vector6
vector6:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $6
801064fd:	6a 06                	push   $0x6
  jmp alltraps
801064ff:	e9 c6 fa ff ff       	jmp    80105fca <alltraps>

80106504 <vector7>:
.globl vector7
vector7:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $7
80106506:	6a 07                	push   $0x7
  jmp alltraps
80106508:	e9 bd fa ff ff       	jmp    80105fca <alltraps>

8010650d <vector8>:
.globl vector8
vector8:
  pushl $8
8010650d:	6a 08                	push   $0x8
  jmp alltraps
8010650f:	e9 b6 fa ff ff       	jmp    80105fca <alltraps>

80106514 <vector9>:
.globl vector9
vector9:
  pushl $0
80106514:	6a 00                	push   $0x0
  pushl $9
80106516:	6a 09                	push   $0x9
  jmp alltraps
80106518:	e9 ad fa ff ff       	jmp    80105fca <alltraps>

8010651d <vector10>:
.globl vector10
vector10:
  pushl $10
8010651d:	6a 0a                	push   $0xa
  jmp alltraps
8010651f:	e9 a6 fa ff ff       	jmp    80105fca <alltraps>

80106524 <vector11>:
.globl vector11
vector11:
  pushl $11
80106524:	6a 0b                	push   $0xb
  jmp alltraps
80106526:	e9 9f fa ff ff       	jmp    80105fca <alltraps>

8010652b <vector12>:
.globl vector12
vector12:
  pushl $12
8010652b:	6a 0c                	push   $0xc
  jmp alltraps
8010652d:	e9 98 fa ff ff       	jmp    80105fca <alltraps>

80106532 <vector13>:
.globl vector13
vector13:
  pushl $13
80106532:	6a 0d                	push   $0xd
  jmp alltraps
80106534:	e9 91 fa ff ff       	jmp    80105fca <alltraps>

80106539 <vector14>:
.globl vector14
vector14:
  pushl $14
80106539:	6a 0e                	push   $0xe
  jmp alltraps
8010653b:	e9 8a fa ff ff       	jmp    80105fca <alltraps>

80106540 <vector15>:
.globl vector15
vector15:
  pushl $0
80106540:	6a 00                	push   $0x0
  pushl $15
80106542:	6a 0f                	push   $0xf
  jmp alltraps
80106544:	e9 81 fa ff ff       	jmp    80105fca <alltraps>

80106549 <vector16>:
.globl vector16
vector16:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $16
8010654b:	6a 10                	push   $0x10
  jmp alltraps
8010654d:	e9 78 fa ff ff       	jmp    80105fca <alltraps>

80106552 <vector17>:
.globl vector17
vector17:
  pushl $17
80106552:	6a 11                	push   $0x11
  jmp alltraps
80106554:	e9 71 fa ff ff       	jmp    80105fca <alltraps>

80106559 <vector18>:
.globl vector18
vector18:
  pushl $0
80106559:	6a 00                	push   $0x0
  pushl $18
8010655b:	6a 12                	push   $0x12
  jmp alltraps
8010655d:	e9 68 fa ff ff       	jmp    80105fca <alltraps>

80106562 <vector19>:
.globl vector19
vector19:
  pushl $0
80106562:	6a 00                	push   $0x0
  pushl $19
80106564:	6a 13                	push   $0x13
  jmp alltraps
80106566:	e9 5f fa ff ff       	jmp    80105fca <alltraps>

8010656b <vector20>:
.globl vector20
vector20:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $20
8010656d:	6a 14                	push   $0x14
  jmp alltraps
8010656f:	e9 56 fa ff ff       	jmp    80105fca <alltraps>

80106574 <vector21>:
.globl vector21
vector21:
  pushl $0
80106574:	6a 00                	push   $0x0
  pushl $21
80106576:	6a 15                	push   $0x15
  jmp alltraps
80106578:	e9 4d fa ff ff       	jmp    80105fca <alltraps>

8010657d <vector22>:
.globl vector22
vector22:
  pushl $0
8010657d:	6a 00                	push   $0x0
  pushl $22
8010657f:	6a 16                	push   $0x16
  jmp alltraps
80106581:	e9 44 fa ff ff       	jmp    80105fca <alltraps>

80106586 <vector23>:
.globl vector23
vector23:
  pushl $0
80106586:	6a 00                	push   $0x0
  pushl $23
80106588:	6a 17                	push   $0x17
  jmp alltraps
8010658a:	e9 3b fa ff ff       	jmp    80105fca <alltraps>

8010658f <vector24>:
.globl vector24
vector24:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $24
80106591:	6a 18                	push   $0x18
  jmp alltraps
80106593:	e9 32 fa ff ff       	jmp    80105fca <alltraps>

80106598 <vector25>:
.globl vector25
vector25:
  pushl $0
80106598:	6a 00                	push   $0x0
  pushl $25
8010659a:	6a 19                	push   $0x19
  jmp alltraps
8010659c:	e9 29 fa ff ff       	jmp    80105fca <alltraps>

801065a1 <vector26>:
.globl vector26
vector26:
  pushl $0
801065a1:	6a 00                	push   $0x0
  pushl $26
801065a3:	6a 1a                	push   $0x1a
  jmp alltraps
801065a5:	e9 20 fa ff ff       	jmp    80105fca <alltraps>

801065aa <vector27>:
.globl vector27
vector27:
  pushl $0
801065aa:	6a 00                	push   $0x0
  pushl $27
801065ac:	6a 1b                	push   $0x1b
  jmp alltraps
801065ae:	e9 17 fa ff ff       	jmp    80105fca <alltraps>

801065b3 <vector28>:
.globl vector28
vector28:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $28
801065b5:	6a 1c                	push   $0x1c
  jmp alltraps
801065b7:	e9 0e fa ff ff       	jmp    80105fca <alltraps>

801065bc <vector29>:
.globl vector29
vector29:
  pushl $0
801065bc:	6a 00                	push   $0x0
  pushl $29
801065be:	6a 1d                	push   $0x1d
  jmp alltraps
801065c0:	e9 05 fa ff ff       	jmp    80105fca <alltraps>

801065c5 <vector30>:
.globl vector30
vector30:
  pushl $0
801065c5:	6a 00                	push   $0x0
  pushl $30
801065c7:	6a 1e                	push   $0x1e
  jmp alltraps
801065c9:	e9 fc f9 ff ff       	jmp    80105fca <alltraps>

801065ce <vector31>:
.globl vector31
vector31:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $31
801065d0:	6a 1f                	push   $0x1f
  jmp alltraps
801065d2:	e9 f3 f9 ff ff       	jmp    80105fca <alltraps>

801065d7 <vector32>:
.globl vector32
vector32:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $32
801065d9:	6a 20                	push   $0x20
  jmp alltraps
801065db:	e9 ea f9 ff ff       	jmp    80105fca <alltraps>

801065e0 <vector33>:
.globl vector33
vector33:
  pushl $0
801065e0:	6a 00                	push   $0x0
  pushl $33
801065e2:	6a 21                	push   $0x21
  jmp alltraps
801065e4:	e9 e1 f9 ff ff       	jmp    80105fca <alltraps>

801065e9 <vector34>:
.globl vector34
vector34:
  pushl $0
801065e9:	6a 00                	push   $0x0
  pushl $34
801065eb:	6a 22                	push   $0x22
  jmp alltraps
801065ed:	e9 d8 f9 ff ff       	jmp    80105fca <alltraps>

801065f2 <vector35>:
.globl vector35
vector35:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $35
801065f4:	6a 23                	push   $0x23
  jmp alltraps
801065f6:	e9 cf f9 ff ff       	jmp    80105fca <alltraps>

801065fb <vector36>:
.globl vector36
vector36:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $36
801065fd:	6a 24                	push   $0x24
  jmp alltraps
801065ff:	e9 c6 f9 ff ff       	jmp    80105fca <alltraps>

80106604 <vector37>:
.globl vector37
vector37:
  pushl $0
80106604:	6a 00                	push   $0x0
  pushl $37
80106606:	6a 25                	push   $0x25
  jmp alltraps
80106608:	e9 bd f9 ff ff       	jmp    80105fca <alltraps>

8010660d <vector38>:
.globl vector38
vector38:
  pushl $0
8010660d:	6a 00                	push   $0x0
  pushl $38
8010660f:	6a 26                	push   $0x26
  jmp alltraps
80106611:	e9 b4 f9 ff ff       	jmp    80105fca <alltraps>

80106616 <vector39>:
.globl vector39
vector39:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $39
80106618:	6a 27                	push   $0x27
  jmp alltraps
8010661a:	e9 ab f9 ff ff       	jmp    80105fca <alltraps>

8010661f <vector40>:
.globl vector40
vector40:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $40
80106621:	6a 28                	push   $0x28
  jmp alltraps
80106623:	e9 a2 f9 ff ff       	jmp    80105fca <alltraps>

80106628 <vector41>:
.globl vector41
vector41:
  pushl $0
80106628:	6a 00                	push   $0x0
  pushl $41
8010662a:	6a 29                	push   $0x29
  jmp alltraps
8010662c:	e9 99 f9 ff ff       	jmp    80105fca <alltraps>

80106631 <vector42>:
.globl vector42
vector42:
  pushl $0
80106631:	6a 00                	push   $0x0
  pushl $42
80106633:	6a 2a                	push   $0x2a
  jmp alltraps
80106635:	e9 90 f9 ff ff       	jmp    80105fca <alltraps>

8010663a <vector43>:
.globl vector43
vector43:
  pushl $0
8010663a:	6a 00                	push   $0x0
  pushl $43
8010663c:	6a 2b                	push   $0x2b
  jmp alltraps
8010663e:	e9 87 f9 ff ff       	jmp    80105fca <alltraps>

80106643 <vector44>:
.globl vector44
vector44:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $44
80106645:	6a 2c                	push   $0x2c
  jmp alltraps
80106647:	e9 7e f9 ff ff       	jmp    80105fca <alltraps>

8010664c <vector45>:
.globl vector45
vector45:
  pushl $0
8010664c:	6a 00                	push   $0x0
  pushl $45
8010664e:	6a 2d                	push   $0x2d
  jmp alltraps
80106650:	e9 75 f9 ff ff       	jmp    80105fca <alltraps>

80106655 <vector46>:
.globl vector46
vector46:
  pushl $0
80106655:	6a 00                	push   $0x0
  pushl $46
80106657:	6a 2e                	push   $0x2e
  jmp alltraps
80106659:	e9 6c f9 ff ff       	jmp    80105fca <alltraps>

8010665e <vector47>:
.globl vector47
vector47:
  pushl $0
8010665e:	6a 00                	push   $0x0
  pushl $47
80106660:	6a 2f                	push   $0x2f
  jmp alltraps
80106662:	e9 63 f9 ff ff       	jmp    80105fca <alltraps>

80106667 <vector48>:
.globl vector48
vector48:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $48
80106669:	6a 30                	push   $0x30
  jmp alltraps
8010666b:	e9 5a f9 ff ff       	jmp    80105fca <alltraps>

80106670 <vector49>:
.globl vector49
vector49:
  pushl $0
80106670:	6a 00                	push   $0x0
  pushl $49
80106672:	6a 31                	push   $0x31
  jmp alltraps
80106674:	e9 51 f9 ff ff       	jmp    80105fca <alltraps>

80106679 <vector50>:
.globl vector50
vector50:
  pushl $0
80106679:	6a 00                	push   $0x0
  pushl $50
8010667b:	6a 32                	push   $0x32
  jmp alltraps
8010667d:	e9 48 f9 ff ff       	jmp    80105fca <alltraps>

80106682 <vector51>:
.globl vector51
vector51:
  pushl $0
80106682:	6a 00                	push   $0x0
  pushl $51
80106684:	6a 33                	push   $0x33
  jmp alltraps
80106686:	e9 3f f9 ff ff       	jmp    80105fca <alltraps>

8010668b <vector52>:
.globl vector52
vector52:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $52
8010668d:	6a 34                	push   $0x34
  jmp alltraps
8010668f:	e9 36 f9 ff ff       	jmp    80105fca <alltraps>

80106694 <vector53>:
.globl vector53
vector53:
  pushl $0
80106694:	6a 00                	push   $0x0
  pushl $53
80106696:	6a 35                	push   $0x35
  jmp alltraps
80106698:	e9 2d f9 ff ff       	jmp    80105fca <alltraps>

8010669d <vector54>:
.globl vector54
vector54:
  pushl $0
8010669d:	6a 00                	push   $0x0
  pushl $54
8010669f:	6a 36                	push   $0x36
  jmp alltraps
801066a1:	e9 24 f9 ff ff       	jmp    80105fca <alltraps>

801066a6 <vector55>:
.globl vector55
vector55:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $55
801066a8:	6a 37                	push   $0x37
  jmp alltraps
801066aa:	e9 1b f9 ff ff       	jmp    80105fca <alltraps>

801066af <vector56>:
.globl vector56
vector56:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $56
801066b1:	6a 38                	push   $0x38
  jmp alltraps
801066b3:	e9 12 f9 ff ff       	jmp    80105fca <alltraps>

801066b8 <vector57>:
.globl vector57
vector57:
  pushl $0
801066b8:	6a 00                	push   $0x0
  pushl $57
801066ba:	6a 39                	push   $0x39
  jmp alltraps
801066bc:	e9 09 f9 ff ff       	jmp    80105fca <alltraps>

801066c1 <vector58>:
.globl vector58
vector58:
  pushl $0
801066c1:	6a 00                	push   $0x0
  pushl $58
801066c3:	6a 3a                	push   $0x3a
  jmp alltraps
801066c5:	e9 00 f9 ff ff       	jmp    80105fca <alltraps>

801066ca <vector59>:
.globl vector59
vector59:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $59
801066cc:	6a 3b                	push   $0x3b
  jmp alltraps
801066ce:	e9 f7 f8 ff ff       	jmp    80105fca <alltraps>

801066d3 <vector60>:
.globl vector60
vector60:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $60
801066d5:	6a 3c                	push   $0x3c
  jmp alltraps
801066d7:	e9 ee f8 ff ff       	jmp    80105fca <alltraps>

801066dc <vector61>:
.globl vector61
vector61:
  pushl $0
801066dc:	6a 00                	push   $0x0
  pushl $61
801066de:	6a 3d                	push   $0x3d
  jmp alltraps
801066e0:	e9 e5 f8 ff ff       	jmp    80105fca <alltraps>

801066e5 <vector62>:
.globl vector62
vector62:
  pushl $0
801066e5:	6a 00                	push   $0x0
  pushl $62
801066e7:	6a 3e                	push   $0x3e
  jmp alltraps
801066e9:	e9 dc f8 ff ff       	jmp    80105fca <alltraps>

801066ee <vector63>:
.globl vector63
vector63:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $63
801066f0:	6a 3f                	push   $0x3f
  jmp alltraps
801066f2:	e9 d3 f8 ff ff       	jmp    80105fca <alltraps>

801066f7 <vector64>:
.globl vector64
vector64:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $64
801066f9:	6a 40                	push   $0x40
  jmp alltraps
801066fb:	e9 ca f8 ff ff       	jmp    80105fca <alltraps>

80106700 <vector65>:
.globl vector65
vector65:
  pushl $0
80106700:	6a 00                	push   $0x0
  pushl $65
80106702:	6a 41                	push   $0x41
  jmp alltraps
80106704:	e9 c1 f8 ff ff       	jmp    80105fca <alltraps>

80106709 <vector66>:
.globl vector66
vector66:
  pushl $0
80106709:	6a 00                	push   $0x0
  pushl $66
8010670b:	6a 42                	push   $0x42
  jmp alltraps
8010670d:	e9 b8 f8 ff ff       	jmp    80105fca <alltraps>

80106712 <vector67>:
.globl vector67
vector67:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $67
80106714:	6a 43                	push   $0x43
  jmp alltraps
80106716:	e9 af f8 ff ff       	jmp    80105fca <alltraps>

8010671b <vector68>:
.globl vector68
vector68:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $68
8010671d:	6a 44                	push   $0x44
  jmp alltraps
8010671f:	e9 a6 f8 ff ff       	jmp    80105fca <alltraps>

80106724 <vector69>:
.globl vector69
vector69:
  pushl $0
80106724:	6a 00                	push   $0x0
  pushl $69
80106726:	6a 45                	push   $0x45
  jmp alltraps
80106728:	e9 9d f8 ff ff       	jmp    80105fca <alltraps>

8010672d <vector70>:
.globl vector70
vector70:
  pushl $0
8010672d:	6a 00                	push   $0x0
  pushl $70
8010672f:	6a 46                	push   $0x46
  jmp alltraps
80106731:	e9 94 f8 ff ff       	jmp    80105fca <alltraps>

80106736 <vector71>:
.globl vector71
vector71:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $71
80106738:	6a 47                	push   $0x47
  jmp alltraps
8010673a:	e9 8b f8 ff ff       	jmp    80105fca <alltraps>

8010673f <vector72>:
.globl vector72
vector72:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $72
80106741:	6a 48                	push   $0x48
  jmp alltraps
80106743:	e9 82 f8 ff ff       	jmp    80105fca <alltraps>

80106748 <vector73>:
.globl vector73
vector73:
  pushl $0
80106748:	6a 00                	push   $0x0
  pushl $73
8010674a:	6a 49                	push   $0x49
  jmp alltraps
8010674c:	e9 79 f8 ff ff       	jmp    80105fca <alltraps>

80106751 <vector74>:
.globl vector74
vector74:
  pushl $0
80106751:	6a 00                	push   $0x0
  pushl $74
80106753:	6a 4a                	push   $0x4a
  jmp alltraps
80106755:	e9 70 f8 ff ff       	jmp    80105fca <alltraps>

8010675a <vector75>:
.globl vector75
vector75:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $75
8010675c:	6a 4b                	push   $0x4b
  jmp alltraps
8010675e:	e9 67 f8 ff ff       	jmp    80105fca <alltraps>

80106763 <vector76>:
.globl vector76
vector76:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $76
80106765:	6a 4c                	push   $0x4c
  jmp alltraps
80106767:	e9 5e f8 ff ff       	jmp    80105fca <alltraps>

8010676c <vector77>:
.globl vector77
vector77:
  pushl $0
8010676c:	6a 00                	push   $0x0
  pushl $77
8010676e:	6a 4d                	push   $0x4d
  jmp alltraps
80106770:	e9 55 f8 ff ff       	jmp    80105fca <alltraps>

80106775 <vector78>:
.globl vector78
vector78:
  pushl $0
80106775:	6a 00                	push   $0x0
  pushl $78
80106777:	6a 4e                	push   $0x4e
  jmp alltraps
80106779:	e9 4c f8 ff ff       	jmp    80105fca <alltraps>

8010677e <vector79>:
.globl vector79
vector79:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $79
80106780:	6a 4f                	push   $0x4f
  jmp alltraps
80106782:	e9 43 f8 ff ff       	jmp    80105fca <alltraps>

80106787 <vector80>:
.globl vector80
vector80:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $80
80106789:	6a 50                	push   $0x50
  jmp alltraps
8010678b:	e9 3a f8 ff ff       	jmp    80105fca <alltraps>

80106790 <vector81>:
.globl vector81
vector81:
  pushl $0
80106790:	6a 00                	push   $0x0
  pushl $81
80106792:	6a 51                	push   $0x51
  jmp alltraps
80106794:	e9 31 f8 ff ff       	jmp    80105fca <alltraps>

80106799 <vector82>:
.globl vector82
vector82:
  pushl $0
80106799:	6a 00                	push   $0x0
  pushl $82
8010679b:	6a 52                	push   $0x52
  jmp alltraps
8010679d:	e9 28 f8 ff ff       	jmp    80105fca <alltraps>

801067a2 <vector83>:
.globl vector83
vector83:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $83
801067a4:	6a 53                	push   $0x53
  jmp alltraps
801067a6:	e9 1f f8 ff ff       	jmp    80105fca <alltraps>

801067ab <vector84>:
.globl vector84
vector84:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $84
801067ad:	6a 54                	push   $0x54
  jmp alltraps
801067af:	e9 16 f8 ff ff       	jmp    80105fca <alltraps>

801067b4 <vector85>:
.globl vector85
vector85:
  pushl $0
801067b4:	6a 00                	push   $0x0
  pushl $85
801067b6:	6a 55                	push   $0x55
  jmp alltraps
801067b8:	e9 0d f8 ff ff       	jmp    80105fca <alltraps>

801067bd <vector86>:
.globl vector86
vector86:
  pushl $0
801067bd:	6a 00                	push   $0x0
  pushl $86
801067bf:	6a 56                	push   $0x56
  jmp alltraps
801067c1:	e9 04 f8 ff ff       	jmp    80105fca <alltraps>

801067c6 <vector87>:
.globl vector87
vector87:
  pushl $0
801067c6:	6a 00                	push   $0x0
  pushl $87
801067c8:	6a 57                	push   $0x57
  jmp alltraps
801067ca:	e9 fb f7 ff ff       	jmp    80105fca <alltraps>

801067cf <vector88>:
.globl vector88
vector88:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $88
801067d1:	6a 58                	push   $0x58
  jmp alltraps
801067d3:	e9 f2 f7 ff ff       	jmp    80105fca <alltraps>

801067d8 <vector89>:
.globl vector89
vector89:
  pushl $0
801067d8:	6a 00                	push   $0x0
  pushl $89
801067da:	6a 59                	push   $0x59
  jmp alltraps
801067dc:	e9 e9 f7 ff ff       	jmp    80105fca <alltraps>

801067e1 <vector90>:
.globl vector90
vector90:
  pushl $0
801067e1:	6a 00                	push   $0x0
  pushl $90
801067e3:	6a 5a                	push   $0x5a
  jmp alltraps
801067e5:	e9 e0 f7 ff ff       	jmp    80105fca <alltraps>

801067ea <vector91>:
.globl vector91
vector91:
  pushl $0
801067ea:	6a 00                	push   $0x0
  pushl $91
801067ec:	6a 5b                	push   $0x5b
  jmp alltraps
801067ee:	e9 d7 f7 ff ff       	jmp    80105fca <alltraps>

801067f3 <vector92>:
.globl vector92
vector92:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $92
801067f5:	6a 5c                	push   $0x5c
  jmp alltraps
801067f7:	e9 ce f7 ff ff       	jmp    80105fca <alltraps>

801067fc <vector93>:
.globl vector93
vector93:
  pushl $0
801067fc:	6a 00                	push   $0x0
  pushl $93
801067fe:	6a 5d                	push   $0x5d
  jmp alltraps
80106800:	e9 c5 f7 ff ff       	jmp    80105fca <alltraps>

80106805 <vector94>:
.globl vector94
vector94:
  pushl $0
80106805:	6a 00                	push   $0x0
  pushl $94
80106807:	6a 5e                	push   $0x5e
  jmp alltraps
80106809:	e9 bc f7 ff ff       	jmp    80105fca <alltraps>

8010680e <vector95>:
.globl vector95
vector95:
  pushl $0
8010680e:	6a 00                	push   $0x0
  pushl $95
80106810:	6a 5f                	push   $0x5f
  jmp alltraps
80106812:	e9 b3 f7 ff ff       	jmp    80105fca <alltraps>

80106817 <vector96>:
.globl vector96
vector96:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $96
80106819:	6a 60                	push   $0x60
  jmp alltraps
8010681b:	e9 aa f7 ff ff       	jmp    80105fca <alltraps>

80106820 <vector97>:
.globl vector97
vector97:
  pushl $0
80106820:	6a 00                	push   $0x0
  pushl $97
80106822:	6a 61                	push   $0x61
  jmp alltraps
80106824:	e9 a1 f7 ff ff       	jmp    80105fca <alltraps>

80106829 <vector98>:
.globl vector98
vector98:
  pushl $0
80106829:	6a 00                	push   $0x0
  pushl $98
8010682b:	6a 62                	push   $0x62
  jmp alltraps
8010682d:	e9 98 f7 ff ff       	jmp    80105fca <alltraps>

80106832 <vector99>:
.globl vector99
vector99:
  pushl $0
80106832:	6a 00                	push   $0x0
  pushl $99
80106834:	6a 63                	push   $0x63
  jmp alltraps
80106836:	e9 8f f7 ff ff       	jmp    80105fca <alltraps>

8010683b <vector100>:
.globl vector100
vector100:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $100
8010683d:	6a 64                	push   $0x64
  jmp alltraps
8010683f:	e9 86 f7 ff ff       	jmp    80105fca <alltraps>

80106844 <vector101>:
.globl vector101
vector101:
  pushl $0
80106844:	6a 00                	push   $0x0
  pushl $101
80106846:	6a 65                	push   $0x65
  jmp alltraps
80106848:	e9 7d f7 ff ff       	jmp    80105fca <alltraps>

8010684d <vector102>:
.globl vector102
vector102:
  pushl $0
8010684d:	6a 00                	push   $0x0
  pushl $102
8010684f:	6a 66                	push   $0x66
  jmp alltraps
80106851:	e9 74 f7 ff ff       	jmp    80105fca <alltraps>

80106856 <vector103>:
.globl vector103
vector103:
  pushl $0
80106856:	6a 00                	push   $0x0
  pushl $103
80106858:	6a 67                	push   $0x67
  jmp alltraps
8010685a:	e9 6b f7 ff ff       	jmp    80105fca <alltraps>

8010685f <vector104>:
.globl vector104
vector104:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $104
80106861:	6a 68                	push   $0x68
  jmp alltraps
80106863:	e9 62 f7 ff ff       	jmp    80105fca <alltraps>

80106868 <vector105>:
.globl vector105
vector105:
  pushl $0
80106868:	6a 00                	push   $0x0
  pushl $105
8010686a:	6a 69                	push   $0x69
  jmp alltraps
8010686c:	e9 59 f7 ff ff       	jmp    80105fca <alltraps>

80106871 <vector106>:
.globl vector106
vector106:
  pushl $0
80106871:	6a 00                	push   $0x0
  pushl $106
80106873:	6a 6a                	push   $0x6a
  jmp alltraps
80106875:	e9 50 f7 ff ff       	jmp    80105fca <alltraps>

8010687a <vector107>:
.globl vector107
vector107:
  pushl $0
8010687a:	6a 00                	push   $0x0
  pushl $107
8010687c:	6a 6b                	push   $0x6b
  jmp alltraps
8010687e:	e9 47 f7 ff ff       	jmp    80105fca <alltraps>

80106883 <vector108>:
.globl vector108
vector108:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $108
80106885:	6a 6c                	push   $0x6c
  jmp alltraps
80106887:	e9 3e f7 ff ff       	jmp    80105fca <alltraps>

8010688c <vector109>:
.globl vector109
vector109:
  pushl $0
8010688c:	6a 00                	push   $0x0
  pushl $109
8010688e:	6a 6d                	push   $0x6d
  jmp alltraps
80106890:	e9 35 f7 ff ff       	jmp    80105fca <alltraps>

80106895 <vector110>:
.globl vector110
vector110:
  pushl $0
80106895:	6a 00                	push   $0x0
  pushl $110
80106897:	6a 6e                	push   $0x6e
  jmp alltraps
80106899:	e9 2c f7 ff ff       	jmp    80105fca <alltraps>

8010689e <vector111>:
.globl vector111
vector111:
  pushl $0
8010689e:	6a 00                	push   $0x0
  pushl $111
801068a0:	6a 6f                	push   $0x6f
  jmp alltraps
801068a2:	e9 23 f7 ff ff       	jmp    80105fca <alltraps>

801068a7 <vector112>:
.globl vector112
vector112:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $112
801068a9:	6a 70                	push   $0x70
  jmp alltraps
801068ab:	e9 1a f7 ff ff       	jmp    80105fca <alltraps>

801068b0 <vector113>:
.globl vector113
vector113:
  pushl $0
801068b0:	6a 00                	push   $0x0
  pushl $113
801068b2:	6a 71                	push   $0x71
  jmp alltraps
801068b4:	e9 11 f7 ff ff       	jmp    80105fca <alltraps>

801068b9 <vector114>:
.globl vector114
vector114:
  pushl $0
801068b9:	6a 00                	push   $0x0
  pushl $114
801068bb:	6a 72                	push   $0x72
  jmp alltraps
801068bd:	e9 08 f7 ff ff       	jmp    80105fca <alltraps>

801068c2 <vector115>:
.globl vector115
vector115:
  pushl $0
801068c2:	6a 00                	push   $0x0
  pushl $115
801068c4:	6a 73                	push   $0x73
  jmp alltraps
801068c6:	e9 ff f6 ff ff       	jmp    80105fca <alltraps>

801068cb <vector116>:
.globl vector116
vector116:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $116
801068cd:	6a 74                	push   $0x74
  jmp alltraps
801068cf:	e9 f6 f6 ff ff       	jmp    80105fca <alltraps>

801068d4 <vector117>:
.globl vector117
vector117:
  pushl $0
801068d4:	6a 00                	push   $0x0
  pushl $117
801068d6:	6a 75                	push   $0x75
  jmp alltraps
801068d8:	e9 ed f6 ff ff       	jmp    80105fca <alltraps>

801068dd <vector118>:
.globl vector118
vector118:
  pushl $0
801068dd:	6a 00                	push   $0x0
  pushl $118
801068df:	6a 76                	push   $0x76
  jmp alltraps
801068e1:	e9 e4 f6 ff ff       	jmp    80105fca <alltraps>

801068e6 <vector119>:
.globl vector119
vector119:
  pushl $0
801068e6:	6a 00                	push   $0x0
  pushl $119
801068e8:	6a 77                	push   $0x77
  jmp alltraps
801068ea:	e9 db f6 ff ff       	jmp    80105fca <alltraps>

801068ef <vector120>:
.globl vector120
vector120:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $120
801068f1:	6a 78                	push   $0x78
  jmp alltraps
801068f3:	e9 d2 f6 ff ff       	jmp    80105fca <alltraps>

801068f8 <vector121>:
.globl vector121
vector121:
  pushl $0
801068f8:	6a 00                	push   $0x0
  pushl $121
801068fa:	6a 79                	push   $0x79
  jmp alltraps
801068fc:	e9 c9 f6 ff ff       	jmp    80105fca <alltraps>

80106901 <vector122>:
.globl vector122
vector122:
  pushl $0
80106901:	6a 00                	push   $0x0
  pushl $122
80106903:	6a 7a                	push   $0x7a
  jmp alltraps
80106905:	e9 c0 f6 ff ff       	jmp    80105fca <alltraps>

8010690a <vector123>:
.globl vector123
vector123:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $123
8010690c:	6a 7b                	push   $0x7b
  jmp alltraps
8010690e:	e9 b7 f6 ff ff       	jmp    80105fca <alltraps>

80106913 <vector124>:
.globl vector124
vector124:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $124
80106915:	6a 7c                	push   $0x7c
  jmp alltraps
80106917:	e9 ae f6 ff ff       	jmp    80105fca <alltraps>

8010691c <vector125>:
.globl vector125
vector125:
  pushl $0
8010691c:	6a 00                	push   $0x0
  pushl $125
8010691e:	6a 7d                	push   $0x7d
  jmp alltraps
80106920:	e9 a5 f6 ff ff       	jmp    80105fca <alltraps>

80106925 <vector126>:
.globl vector126
vector126:
  pushl $0
80106925:	6a 00                	push   $0x0
  pushl $126
80106927:	6a 7e                	push   $0x7e
  jmp alltraps
80106929:	e9 9c f6 ff ff       	jmp    80105fca <alltraps>

8010692e <vector127>:
.globl vector127
vector127:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $127
80106930:	6a 7f                	push   $0x7f
  jmp alltraps
80106932:	e9 93 f6 ff ff       	jmp    80105fca <alltraps>

80106937 <vector128>:
.globl vector128
vector128:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $128
80106939:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010693e:	e9 87 f6 ff ff       	jmp    80105fca <alltraps>

80106943 <vector129>:
.globl vector129
vector129:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $129
80106945:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010694a:	e9 7b f6 ff ff       	jmp    80105fca <alltraps>

8010694f <vector130>:
.globl vector130
vector130:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $130
80106951:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106956:	e9 6f f6 ff ff       	jmp    80105fca <alltraps>

8010695b <vector131>:
.globl vector131
vector131:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $131
8010695d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106962:	e9 63 f6 ff ff       	jmp    80105fca <alltraps>

80106967 <vector132>:
.globl vector132
vector132:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $132
80106969:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010696e:	e9 57 f6 ff ff       	jmp    80105fca <alltraps>

80106973 <vector133>:
.globl vector133
vector133:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $133
80106975:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010697a:	e9 4b f6 ff ff       	jmp    80105fca <alltraps>

8010697f <vector134>:
.globl vector134
vector134:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $134
80106981:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106986:	e9 3f f6 ff ff       	jmp    80105fca <alltraps>

8010698b <vector135>:
.globl vector135
vector135:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $135
8010698d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106992:	e9 33 f6 ff ff       	jmp    80105fca <alltraps>

80106997 <vector136>:
.globl vector136
vector136:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $136
80106999:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010699e:	e9 27 f6 ff ff       	jmp    80105fca <alltraps>

801069a3 <vector137>:
.globl vector137
vector137:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $137
801069a5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801069aa:	e9 1b f6 ff ff       	jmp    80105fca <alltraps>

801069af <vector138>:
.globl vector138
vector138:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $138
801069b1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801069b6:	e9 0f f6 ff ff       	jmp    80105fca <alltraps>

801069bb <vector139>:
.globl vector139
vector139:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $139
801069bd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801069c2:	e9 03 f6 ff ff       	jmp    80105fca <alltraps>

801069c7 <vector140>:
.globl vector140
vector140:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $140
801069c9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801069ce:	e9 f7 f5 ff ff       	jmp    80105fca <alltraps>

801069d3 <vector141>:
.globl vector141
vector141:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $141
801069d5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801069da:	e9 eb f5 ff ff       	jmp    80105fca <alltraps>

801069df <vector142>:
.globl vector142
vector142:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $142
801069e1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801069e6:	e9 df f5 ff ff       	jmp    80105fca <alltraps>

801069eb <vector143>:
.globl vector143
vector143:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $143
801069ed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801069f2:	e9 d3 f5 ff ff       	jmp    80105fca <alltraps>

801069f7 <vector144>:
.globl vector144
vector144:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $144
801069f9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801069fe:	e9 c7 f5 ff ff       	jmp    80105fca <alltraps>

80106a03 <vector145>:
.globl vector145
vector145:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $145
80106a05:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106a0a:	e9 bb f5 ff ff       	jmp    80105fca <alltraps>

80106a0f <vector146>:
.globl vector146
vector146:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $146
80106a11:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106a16:	e9 af f5 ff ff       	jmp    80105fca <alltraps>

80106a1b <vector147>:
.globl vector147
vector147:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $147
80106a1d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106a22:	e9 a3 f5 ff ff       	jmp    80105fca <alltraps>

80106a27 <vector148>:
.globl vector148
vector148:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $148
80106a29:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106a2e:	e9 97 f5 ff ff       	jmp    80105fca <alltraps>

80106a33 <vector149>:
.globl vector149
vector149:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $149
80106a35:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106a3a:	e9 8b f5 ff ff       	jmp    80105fca <alltraps>

80106a3f <vector150>:
.globl vector150
vector150:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $150
80106a41:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106a46:	e9 7f f5 ff ff       	jmp    80105fca <alltraps>

80106a4b <vector151>:
.globl vector151
vector151:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $151
80106a4d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106a52:	e9 73 f5 ff ff       	jmp    80105fca <alltraps>

80106a57 <vector152>:
.globl vector152
vector152:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $152
80106a59:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106a5e:	e9 67 f5 ff ff       	jmp    80105fca <alltraps>

80106a63 <vector153>:
.globl vector153
vector153:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $153
80106a65:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106a6a:	e9 5b f5 ff ff       	jmp    80105fca <alltraps>

80106a6f <vector154>:
.globl vector154
vector154:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $154
80106a71:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106a76:	e9 4f f5 ff ff       	jmp    80105fca <alltraps>

80106a7b <vector155>:
.globl vector155
vector155:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $155
80106a7d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106a82:	e9 43 f5 ff ff       	jmp    80105fca <alltraps>

80106a87 <vector156>:
.globl vector156
vector156:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $156
80106a89:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106a8e:	e9 37 f5 ff ff       	jmp    80105fca <alltraps>

80106a93 <vector157>:
.globl vector157
vector157:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $157
80106a95:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106a9a:	e9 2b f5 ff ff       	jmp    80105fca <alltraps>

80106a9f <vector158>:
.globl vector158
vector158:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $158
80106aa1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106aa6:	e9 1f f5 ff ff       	jmp    80105fca <alltraps>

80106aab <vector159>:
.globl vector159
vector159:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $159
80106aad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106ab2:	e9 13 f5 ff ff       	jmp    80105fca <alltraps>

80106ab7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $160
80106ab9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106abe:	e9 07 f5 ff ff       	jmp    80105fca <alltraps>

80106ac3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $161
80106ac5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106aca:	e9 fb f4 ff ff       	jmp    80105fca <alltraps>

80106acf <vector162>:
.globl vector162
vector162:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $162
80106ad1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106ad6:	e9 ef f4 ff ff       	jmp    80105fca <alltraps>

80106adb <vector163>:
.globl vector163
vector163:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $163
80106add:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106ae2:	e9 e3 f4 ff ff       	jmp    80105fca <alltraps>

80106ae7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $164
80106ae9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106aee:	e9 d7 f4 ff ff       	jmp    80105fca <alltraps>

80106af3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $165
80106af5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106afa:	e9 cb f4 ff ff       	jmp    80105fca <alltraps>

80106aff <vector166>:
.globl vector166
vector166:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $166
80106b01:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106b06:	e9 bf f4 ff ff       	jmp    80105fca <alltraps>

80106b0b <vector167>:
.globl vector167
vector167:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $167
80106b0d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106b12:	e9 b3 f4 ff ff       	jmp    80105fca <alltraps>

80106b17 <vector168>:
.globl vector168
vector168:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $168
80106b19:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106b1e:	e9 a7 f4 ff ff       	jmp    80105fca <alltraps>

80106b23 <vector169>:
.globl vector169
vector169:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $169
80106b25:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106b2a:	e9 9b f4 ff ff       	jmp    80105fca <alltraps>

80106b2f <vector170>:
.globl vector170
vector170:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $170
80106b31:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106b36:	e9 8f f4 ff ff       	jmp    80105fca <alltraps>

80106b3b <vector171>:
.globl vector171
vector171:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $171
80106b3d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106b42:	e9 83 f4 ff ff       	jmp    80105fca <alltraps>

80106b47 <vector172>:
.globl vector172
vector172:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $172
80106b49:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106b4e:	e9 77 f4 ff ff       	jmp    80105fca <alltraps>

80106b53 <vector173>:
.globl vector173
vector173:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $173
80106b55:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106b5a:	e9 6b f4 ff ff       	jmp    80105fca <alltraps>

80106b5f <vector174>:
.globl vector174
vector174:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $174
80106b61:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106b66:	e9 5f f4 ff ff       	jmp    80105fca <alltraps>

80106b6b <vector175>:
.globl vector175
vector175:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $175
80106b6d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106b72:	e9 53 f4 ff ff       	jmp    80105fca <alltraps>

80106b77 <vector176>:
.globl vector176
vector176:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $176
80106b79:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106b7e:	e9 47 f4 ff ff       	jmp    80105fca <alltraps>

80106b83 <vector177>:
.globl vector177
vector177:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $177
80106b85:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106b8a:	e9 3b f4 ff ff       	jmp    80105fca <alltraps>

80106b8f <vector178>:
.globl vector178
vector178:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $178
80106b91:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106b96:	e9 2f f4 ff ff       	jmp    80105fca <alltraps>

80106b9b <vector179>:
.globl vector179
vector179:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $179
80106b9d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ba2:	e9 23 f4 ff ff       	jmp    80105fca <alltraps>

80106ba7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $180
80106ba9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106bae:	e9 17 f4 ff ff       	jmp    80105fca <alltraps>

80106bb3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $181
80106bb5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106bba:	e9 0b f4 ff ff       	jmp    80105fca <alltraps>

80106bbf <vector182>:
.globl vector182
vector182:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $182
80106bc1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106bc6:	e9 ff f3 ff ff       	jmp    80105fca <alltraps>

80106bcb <vector183>:
.globl vector183
vector183:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $183
80106bcd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106bd2:	e9 f3 f3 ff ff       	jmp    80105fca <alltraps>

80106bd7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $184
80106bd9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106bde:	e9 e7 f3 ff ff       	jmp    80105fca <alltraps>

80106be3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $185
80106be5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106bea:	e9 db f3 ff ff       	jmp    80105fca <alltraps>

80106bef <vector186>:
.globl vector186
vector186:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $186
80106bf1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106bf6:	e9 cf f3 ff ff       	jmp    80105fca <alltraps>

80106bfb <vector187>:
.globl vector187
vector187:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $187
80106bfd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106c02:	e9 c3 f3 ff ff       	jmp    80105fca <alltraps>

80106c07 <vector188>:
.globl vector188
vector188:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $188
80106c09:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106c0e:	e9 b7 f3 ff ff       	jmp    80105fca <alltraps>

80106c13 <vector189>:
.globl vector189
vector189:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $189
80106c15:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106c1a:	e9 ab f3 ff ff       	jmp    80105fca <alltraps>

80106c1f <vector190>:
.globl vector190
vector190:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $190
80106c21:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106c26:	e9 9f f3 ff ff       	jmp    80105fca <alltraps>

80106c2b <vector191>:
.globl vector191
vector191:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $191
80106c2d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106c32:	e9 93 f3 ff ff       	jmp    80105fca <alltraps>

80106c37 <vector192>:
.globl vector192
vector192:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $192
80106c39:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106c3e:	e9 87 f3 ff ff       	jmp    80105fca <alltraps>

80106c43 <vector193>:
.globl vector193
vector193:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $193
80106c45:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106c4a:	e9 7b f3 ff ff       	jmp    80105fca <alltraps>

80106c4f <vector194>:
.globl vector194
vector194:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $194
80106c51:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106c56:	e9 6f f3 ff ff       	jmp    80105fca <alltraps>

80106c5b <vector195>:
.globl vector195
vector195:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $195
80106c5d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106c62:	e9 63 f3 ff ff       	jmp    80105fca <alltraps>

80106c67 <vector196>:
.globl vector196
vector196:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $196
80106c69:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106c6e:	e9 57 f3 ff ff       	jmp    80105fca <alltraps>

80106c73 <vector197>:
.globl vector197
vector197:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $197
80106c75:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106c7a:	e9 4b f3 ff ff       	jmp    80105fca <alltraps>

80106c7f <vector198>:
.globl vector198
vector198:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $198
80106c81:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106c86:	e9 3f f3 ff ff       	jmp    80105fca <alltraps>

80106c8b <vector199>:
.globl vector199
vector199:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $199
80106c8d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106c92:	e9 33 f3 ff ff       	jmp    80105fca <alltraps>

80106c97 <vector200>:
.globl vector200
vector200:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $200
80106c99:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106c9e:	e9 27 f3 ff ff       	jmp    80105fca <alltraps>

80106ca3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $201
80106ca5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106caa:	e9 1b f3 ff ff       	jmp    80105fca <alltraps>

80106caf <vector202>:
.globl vector202
vector202:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $202
80106cb1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106cb6:	e9 0f f3 ff ff       	jmp    80105fca <alltraps>

80106cbb <vector203>:
.globl vector203
vector203:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $203
80106cbd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106cc2:	e9 03 f3 ff ff       	jmp    80105fca <alltraps>

80106cc7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $204
80106cc9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106cce:	e9 f7 f2 ff ff       	jmp    80105fca <alltraps>

80106cd3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $205
80106cd5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106cda:	e9 eb f2 ff ff       	jmp    80105fca <alltraps>

80106cdf <vector206>:
.globl vector206
vector206:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $206
80106ce1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ce6:	e9 df f2 ff ff       	jmp    80105fca <alltraps>

80106ceb <vector207>:
.globl vector207
vector207:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $207
80106ced:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106cf2:	e9 d3 f2 ff ff       	jmp    80105fca <alltraps>

80106cf7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $208
80106cf9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106cfe:	e9 c7 f2 ff ff       	jmp    80105fca <alltraps>

80106d03 <vector209>:
.globl vector209
vector209:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $209
80106d05:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106d0a:	e9 bb f2 ff ff       	jmp    80105fca <alltraps>

80106d0f <vector210>:
.globl vector210
vector210:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $210
80106d11:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106d16:	e9 af f2 ff ff       	jmp    80105fca <alltraps>

80106d1b <vector211>:
.globl vector211
vector211:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $211
80106d1d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106d22:	e9 a3 f2 ff ff       	jmp    80105fca <alltraps>

80106d27 <vector212>:
.globl vector212
vector212:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $212
80106d29:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106d2e:	e9 97 f2 ff ff       	jmp    80105fca <alltraps>

80106d33 <vector213>:
.globl vector213
vector213:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $213
80106d35:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106d3a:	e9 8b f2 ff ff       	jmp    80105fca <alltraps>

80106d3f <vector214>:
.globl vector214
vector214:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $214
80106d41:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106d46:	e9 7f f2 ff ff       	jmp    80105fca <alltraps>

80106d4b <vector215>:
.globl vector215
vector215:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $215
80106d4d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106d52:	e9 73 f2 ff ff       	jmp    80105fca <alltraps>

80106d57 <vector216>:
.globl vector216
vector216:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $216
80106d59:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106d5e:	e9 67 f2 ff ff       	jmp    80105fca <alltraps>

80106d63 <vector217>:
.globl vector217
vector217:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $217
80106d65:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106d6a:	e9 5b f2 ff ff       	jmp    80105fca <alltraps>

80106d6f <vector218>:
.globl vector218
vector218:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $218
80106d71:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106d76:	e9 4f f2 ff ff       	jmp    80105fca <alltraps>

80106d7b <vector219>:
.globl vector219
vector219:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $219
80106d7d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106d82:	e9 43 f2 ff ff       	jmp    80105fca <alltraps>

80106d87 <vector220>:
.globl vector220
vector220:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $220
80106d89:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106d8e:	e9 37 f2 ff ff       	jmp    80105fca <alltraps>

80106d93 <vector221>:
.globl vector221
vector221:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $221
80106d95:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106d9a:	e9 2b f2 ff ff       	jmp    80105fca <alltraps>

80106d9f <vector222>:
.globl vector222
vector222:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $222
80106da1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106da6:	e9 1f f2 ff ff       	jmp    80105fca <alltraps>

80106dab <vector223>:
.globl vector223
vector223:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $223
80106dad:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106db2:	e9 13 f2 ff ff       	jmp    80105fca <alltraps>

80106db7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $224
80106db9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106dbe:	e9 07 f2 ff ff       	jmp    80105fca <alltraps>

80106dc3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $225
80106dc5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106dca:	e9 fb f1 ff ff       	jmp    80105fca <alltraps>

80106dcf <vector226>:
.globl vector226
vector226:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $226
80106dd1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106dd6:	e9 ef f1 ff ff       	jmp    80105fca <alltraps>

80106ddb <vector227>:
.globl vector227
vector227:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $227
80106ddd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106de2:	e9 e3 f1 ff ff       	jmp    80105fca <alltraps>

80106de7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $228
80106de9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106dee:	e9 d7 f1 ff ff       	jmp    80105fca <alltraps>

80106df3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $229
80106df5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106dfa:	e9 cb f1 ff ff       	jmp    80105fca <alltraps>

80106dff <vector230>:
.globl vector230
vector230:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $230
80106e01:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106e06:	e9 bf f1 ff ff       	jmp    80105fca <alltraps>

80106e0b <vector231>:
.globl vector231
vector231:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $231
80106e0d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106e12:	e9 b3 f1 ff ff       	jmp    80105fca <alltraps>

80106e17 <vector232>:
.globl vector232
vector232:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $232
80106e19:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106e1e:	e9 a7 f1 ff ff       	jmp    80105fca <alltraps>

80106e23 <vector233>:
.globl vector233
vector233:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $233
80106e25:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106e2a:	e9 9b f1 ff ff       	jmp    80105fca <alltraps>

80106e2f <vector234>:
.globl vector234
vector234:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $234
80106e31:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106e36:	e9 8f f1 ff ff       	jmp    80105fca <alltraps>

80106e3b <vector235>:
.globl vector235
vector235:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $235
80106e3d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106e42:	e9 83 f1 ff ff       	jmp    80105fca <alltraps>

80106e47 <vector236>:
.globl vector236
vector236:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $236
80106e49:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106e4e:	e9 77 f1 ff ff       	jmp    80105fca <alltraps>

80106e53 <vector237>:
.globl vector237
vector237:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $237
80106e55:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106e5a:	e9 6b f1 ff ff       	jmp    80105fca <alltraps>

80106e5f <vector238>:
.globl vector238
vector238:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $238
80106e61:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106e66:	e9 5f f1 ff ff       	jmp    80105fca <alltraps>

80106e6b <vector239>:
.globl vector239
vector239:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $239
80106e6d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106e72:	e9 53 f1 ff ff       	jmp    80105fca <alltraps>

80106e77 <vector240>:
.globl vector240
vector240:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $240
80106e79:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106e7e:	e9 47 f1 ff ff       	jmp    80105fca <alltraps>

80106e83 <vector241>:
.globl vector241
vector241:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $241
80106e85:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106e8a:	e9 3b f1 ff ff       	jmp    80105fca <alltraps>

80106e8f <vector242>:
.globl vector242
vector242:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $242
80106e91:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106e96:	e9 2f f1 ff ff       	jmp    80105fca <alltraps>

80106e9b <vector243>:
.globl vector243
vector243:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $243
80106e9d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ea2:	e9 23 f1 ff ff       	jmp    80105fca <alltraps>

80106ea7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $244
80106ea9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106eae:	e9 17 f1 ff ff       	jmp    80105fca <alltraps>

80106eb3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $245
80106eb5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106eba:	e9 0b f1 ff ff       	jmp    80105fca <alltraps>

80106ebf <vector246>:
.globl vector246
vector246:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $246
80106ec1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ec6:	e9 ff f0 ff ff       	jmp    80105fca <alltraps>

80106ecb <vector247>:
.globl vector247
vector247:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $247
80106ecd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106ed2:	e9 f3 f0 ff ff       	jmp    80105fca <alltraps>

80106ed7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $248
80106ed9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106ede:	e9 e7 f0 ff ff       	jmp    80105fca <alltraps>

80106ee3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $249
80106ee5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106eea:	e9 db f0 ff ff       	jmp    80105fca <alltraps>

80106eef <vector250>:
.globl vector250
vector250:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $250
80106ef1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106ef6:	e9 cf f0 ff ff       	jmp    80105fca <alltraps>

80106efb <vector251>:
.globl vector251
vector251:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $251
80106efd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106f02:	e9 c3 f0 ff ff       	jmp    80105fca <alltraps>

80106f07 <vector252>:
.globl vector252
vector252:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $252
80106f09:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106f0e:	e9 b7 f0 ff ff       	jmp    80105fca <alltraps>

80106f13 <vector253>:
.globl vector253
vector253:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $253
80106f15:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106f1a:	e9 ab f0 ff ff       	jmp    80105fca <alltraps>

80106f1f <vector254>:
.globl vector254
vector254:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $254
80106f21:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106f26:	e9 9f f0 ff ff       	jmp    80105fca <alltraps>

80106f2b <vector255>:
.globl vector255
vector255:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $255
80106f2d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106f32:	e9 93 f0 ff ff       	jmp    80105fca <alltraps>
80106f37:	66 90                	xchg   %ax,%ax
80106f39:	66 90                	xchg   %ax,%ax
80106f3b:	66 90                	xchg   %ax,%ax
80106f3d:	66 90                	xchg   %ax,%ax
80106f3f:	90                   	nop

80106f40 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	57                   	push   %edi
80106f44:	56                   	push   %esi
80106f45:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106f46:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106f4c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f52:	83 ec 1c             	sub    $0x1c,%esp
80106f55:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106f58:	39 d3                	cmp    %edx,%ebx
80106f5a:	73 49                	jae    80106fa5 <deallocuvm.part.0+0x65>
80106f5c:	89 c7                	mov    %eax,%edi
80106f5e:	eb 0c                	jmp    80106f6c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106f60:	83 c0 01             	add    $0x1,%eax
80106f63:	c1 e0 16             	shl    $0x16,%eax
80106f66:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106f68:	39 da                	cmp    %ebx,%edx
80106f6a:	76 39                	jbe    80106fa5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106f6c:	89 d8                	mov    %ebx,%eax
80106f6e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106f71:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106f74:	f6 c1 01             	test   $0x1,%cl
80106f77:	74 e7                	je     80106f60 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106f79:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f7b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106f81:	c1 ee 0a             	shr    $0xa,%esi
80106f84:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106f8a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106f91:	85 f6                	test   %esi,%esi
80106f93:	74 cb                	je     80106f60 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106f95:	8b 06                	mov    (%esi),%eax
80106f97:	a8 01                	test   $0x1,%al
80106f99:	75 15                	jne    80106fb0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106f9b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fa1:	39 da                	cmp    %ebx,%edx
80106fa3:	77 c7                	ja     80106f6c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106fa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fab:	5b                   	pop    %ebx
80106fac:	5e                   	pop    %esi
80106fad:	5f                   	pop    %edi
80106fae:	5d                   	pop    %ebp
80106faf:	c3                   	ret    
      if(pa == 0)
80106fb0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fb5:	74 25                	je     80106fdc <deallocuvm.part.0+0x9c>
      kfree(v);
80106fb7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106fba:	05 00 00 00 80       	add    $0x80000000,%eax
80106fbf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106fc2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106fc8:	50                   	push   %eax
80106fc9:	e8 e2 b5 ff ff       	call   801025b0 <kfree>
      *pte = 0;
80106fce:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106fd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106fd7:	83 c4 10             	add    $0x10,%esp
80106fda:	eb 8c                	jmp    80106f68 <deallocuvm.part.0+0x28>
        panic("kfree");
80106fdc:	83 ec 0c             	sub    $0xc,%esp
80106fdf:	68 be 7b 10 80       	push   $0x80107bbe
80106fe4:	e8 97 93 ff ff       	call   80100380 <panic>
80106fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ff0 <mappages>:
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106ff6:	89 d3                	mov    %edx,%ebx
80106ff8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106ffe:	83 ec 1c             	sub    $0x1c,%esp
80107001:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107004:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107008:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010700d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107010:	8b 45 08             	mov    0x8(%ebp),%eax
80107013:	29 d8                	sub    %ebx,%eax
80107015:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107018:	eb 3d                	jmp    80107057 <mappages+0x67>
8010701a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107020:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107022:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107027:	c1 ea 0a             	shr    $0xa,%edx
8010702a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107030:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107037:	85 c0                	test   %eax,%eax
80107039:	74 75                	je     801070b0 <mappages+0xc0>
    if(*pte & PTE_P)
8010703b:	f6 00 01             	testb  $0x1,(%eax)
8010703e:	0f 85 86 00 00 00    	jne    801070ca <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107044:	0b 75 0c             	or     0xc(%ebp),%esi
80107047:	83 ce 01             	or     $0x1,%esi
8010704a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010704c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010704f:	74 6f                	je     801070c0 <mappages+0xd0>
    a += PGSIZE;
80107051:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107057:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010705a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010705d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107060:	89 d8                	mov    %ebx,%eax
80107062:	c1 e8 16             	shr    $0x16,%eax
80107065:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107068:	8b 07                	mov    (%edi),%eax
8010706a:	a8 01                	test   $0x1,%al
8010706c:	75 b2                	jne    80107020 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010706e:	e8 fd b6 ff ff       	call   80102770 <kalloc>
80107073:	85 c0                	test   %eax,%eax
80107075:	74 39                	je     801070b0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107077:	83 ec 04             	sub    $0x4,%esp
8010707a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010707d:	68 00 10 00 00       	push   $0x1000
80107082:	6a 00                	push   $0x0
80107084:	50                   	push   %eax
80107085:	e8 96 dd ff ff       	call   80104e20 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010708a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010708d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107090:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107096:	83 c8 07             	or     $0x7,%eax
80107099:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010709b:	89 d8                	mov    %ebx,%eax
8010709d:	c1 e8 0a             	shr    $0xa,%eax
801070a0:	25 fc 0f 00 00       	and    $0xffc,%eax
801070a5:	01 d0                	add    %edx,%eax
801070a7:	eb 92                	jmp    8010703b <mappages+0x4b>
801070a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801070b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070b8:	5b                   	pop    %ebx
801070b9:	5e                   	pop    %esi
801070ba:	5f                   	pop    %edi
801070bb:	5d                   	pop    %ebp
801070bc:	c3                   	ret    
801070bd:	8d 76 00             	lea    0x0(%esi),%esi
801070c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070c3:	31 c0                	xor    %eax,%eax
}
801070c5:	5b                   	pop    %ebx
801070c6:	5e                   	pop    %esi
801070c7:	5f                   	pop    %edi
801070c8:	5d                   	pop    %ebp
801070c9:	c3                   	ret    
      panic("remap");
801070ca:	83 ec 0c             	sub    $0xc,%esp
801070cd:	68 a8 82 10 80       	push   $0x801082a8
801070d2:	e8 a9 92 ff ff       	call   80100380 <panic>
801070d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070de:	66 90                	xchg   %ax,%ax

801070e0 <seginit>:
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801070e6:	e8 15 ca ff ff       	call   80103b00 <cpuid>
  pd[0] = size-1;
801070eb:	ba 2f 00 00 00       	mov    $0x2f,%edx
801070f0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801070f6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801070fa:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107101:	ff 00 00 
80107104:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
8010710b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010710e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107115:	ff 00 00 
80107118:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
8010711f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107122:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107129:	ff 00 00 
8010712c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80107133:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107136:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
8010713d:	ff 00 00 
80107140:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80107147:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010714a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
8010714f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107153:	c1 e8 10             	shr    $0x10,%eax
80107156:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010715a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010715d:	0f 01 10             	lgdtl  (%eax)
}
80107160:	c9                   	leave  
80107161:	c3                   	ret    
80107162:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107170 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107170:	a1 c4 51 13 80       	mov    0x801351c4,%eax
80107175:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010717a:	0f 22 d8             	mov    %eax,%cr3
}
8010717d:	c3                   	ret    
8010717e:	66 90                	xchg   %ax,%ax

80107180 <switchuvm>:
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	57                   	push   %edi
80107184:	56                   	push   %esi
80107185:	53                   	push   %ebx
80107186:	83 ec 1c             	sub    $0x1c,%esp
80107189:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(t->kstack == 0)
8010718c:	8b 91 6c 08 00 00    	mov    0x86c(%ecx),%edx
80107192:	c1 e2 05             	shl    $0x5,%edx
80107195:	01 ca                	add    %ecx,%edx
80107197:	8b 42 74             	mov    0x74(%edx),%eax
8010719a:	85 c0                	test   %eax,%eax
8010719c:	0f 84 ca 00 00 00    	je     8010726c <switchuvm+0xec>
  if(p->pgdir == 0)
801071a2:	8b 79 04             	mov    0x4(%ecx),%edi
801071a5:	85 ff                	test   %edi,%edi
801071a7:	0f 84 cc 00 00 00    	je     80107279 <switchuvm+0xf9>
801071ad:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801071b0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  pushcli();
801071b3:	e8 58 da ff ff       	call   80104c10 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071b8:	e8 e3 c8 ff ff       	call   80103aa0 <mycpu>
801071bd:	89 c3                	mov    %eax,%ebx
801071bf:	e8 dc c8 ff ff       	call   80103aa0 <mycpu>
801071c4:	89 c7                	mov    %eax,%edi
801071c6:	e8 d5 c8 ff ff       	call   80103aa0 <mycpu>
801071cb:	83 c7 08             	add    $0x8,%edi
801071ce:	89 c6                	mov    %eax,%esi
801071d0:	e8 cb c8 ff ff       	call   80103aa0 <mycpu>
801071d5:	83 c6 08             	add    $0x8,%esi
801071d8:	ba 67 00 00 00       	mov    $0x67,%edx
801071dd:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801071e4:	c1 ee 10             	shr    $0x10,%esi
801071e7:	83 c0 08             	add    $0x8,%eax
801071ea:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
801071f1:	89 f1                	mov    %esi,%ecx
801071f3:	c1 e8 18             	shr    $0x18,%eax
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071f6:	be ff ff ff ff       	mov    $0xffffffff,%esi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071fb:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107201:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107206:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
8010720d:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107213:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107218:	e8 83 c8 ff ff       	call   80103aa0 <mycpu>
8010721d:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107224:	e8 77 c8 ff ff       	call   80103aa0 <mycpu>
  mycpu()->ts.esp0 = (uint)t->kstack + KSTACKSIZE;
80107229:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010722c:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)t->kstack + KSTACKSIZE;
80107230:	8b 5a 74             	mov    0x74(%edx),%ebx
80107233:	e8 68 c8 ff ff       	call   80103aa0 <mycpu>
80107238:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010723e:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107241:	e8 5a c8 ff ff       	call   80103aa0 <mycpu>
80107246:	66 89 70 6e          	mov    %si,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
8010724a:	b8 28 00 00 00       	mov    $0x28,%eax
8010724f:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107252:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80107255:	8b 41 04             	mov    0x4(%ecx),%eax
80107258:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010725d:	0f 22 d8             	mov    %eax,%cr3
}
80107260:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107263:	5b                   	pop    %ebx
80107264:	5e                   	pop    %esi
80107265:	5f                   	pop    %edi
80107266:	5d                   	pop    %ebp
  popcli();
80107267:	e9 f4 d9 ff ff       	jmp    80104c60 <popcli>
    panic("switchuvm: no kstack");
8010726c:	83 ec 0c             	sub    $0xc,%esp
8010726f:	68 ae 82 10 80       	push   $0x801082ae
80107274:	e8 07 91 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80107279:	83 ec 0c             	sub    $0xc,%esp
8010727c:	68 c3 82 10 80       	push   $0x801082c3
80107281:	e8 fa 90 ff ff       	call   80100380 <panic>
80107286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010728d:	8d 76 00             	lea    0x0(%esi),%esi

80107290 <inituvm>:
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	57                   	push   %edi
80107294:	56                   	push   %esi
80107295:	53                   	push   %ebx
80107296:	83 ec 1c             	sub    $0x1c,%esp
80107299:	8b 45 0c             	mov    0xc(%ebp),%eax
8010729c:	8b 75 10             	mov    0x10(%ebp),%esi
8010729f:	8b 7d 08             	mov    0x8(%ebp),%edi
801072a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801072a5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801072ab:	77 4b                	ja     801072f8 <inituvm+0x68>
  mem = kalloc();
801072ad:	e8 be b4 ff ff       	call   80102770 <kalloc>
  memset(mem, 0, PGSIZE);
801072b2:	83 ec 04             	sub    $0x4,%esp
801072b5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801072ba:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801072bc:	6a 00                	push   $0x0
801072be:	50                   	push   %eax
801072bf:	e8 5c db ff ff       	call   80104e20 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801072c4:	58                   	pop    %eax
801072c5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072cb:	5a                   	pop    %edx
801072cc:	6a 06                	push   $0x6
801072ce:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072d3:	31 d2                	xor    %edx,%edx
801072d5:	50                   	push   %eax
801072d6:	89 f8                	mov    %edi,%eax
801072d8:	e8 13 fd ff ff       	call   80106ff0 <mappages>
  memmove(mem, init, sz);
801072dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072e0:	89 75 10             	mov    %esi,0x10(%ebp)
801072e3:	83 c4 10             	add    $0x10,%esp
801072e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801072e9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801072ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ef:	5b                   	pop    %ebx
801072f0:	5e                   	pop    %esi
801072f1:	5f                   	pop    %edi
801072f2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801072f3:	e9 c8 db ff ff       	jmp    80104ec0 <memmove>
    panic("inituvm: more than a page");
801072f8:	83 ec 0c             	sub    $0xc,%esp
801072fb:	68 d7 82 10 80       	push   $0x801082d7
80107300:	e8 7b 90 ff ff       	call   80100380 <panic>
80107305:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010730c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107310 <loaduvm>:
{
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	57                   	push   %edi
80107314:	56                   	push   %esi
80107315:	53                   	push   %ebx
80107316:	83 ec 1c             	sub    $0x1c,%esp
80107319:	8b 45 0c             	mov    0xc(%ebp),%eax
8010731c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010731f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107324:	0f 85 bb 00 00 00    	jne    801073e5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010732a:	01 f0                	add    %esi,%eax
8010732c:	89 f3                	mov    %esi,%ebx
8010732e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107331:	8b 45 14             	mov    0x14(%ebp),%eax
80107334:	01 f0                	add    %esi,%eax
80107336:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107339:	85 f6                	test   %esi,%esi
8010733b:	0f 84 87 00 00 00    	je     801073c8 <loaduvm+0xb8>
80107341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107348:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010734b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010734e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107350:	89 c2                	mov    %eax,%edx
80107352:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107355:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107358:	f6 c2 01             	test   $0x1,%dl
8010735b:	75 13                	jne    80107370 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010735d:	83 ec 0c             	sub    $0xc,%esp
80107360:	68 f1 82 10 80       	push   $0x801082f1
80107365:	e8 16 90 ff ff       	call   80100380 <panic>
8010736a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107370:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107373:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107379:	25 fc 0f 00 00       	and    $0xffc,%eax
8010737e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107385:	85 c0                	test   %eax,%eax
80107387:	74 d4                	je     8010735d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107389:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010738b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010738e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107398:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010739e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801073a1:	29 d9                	sub    %ebx,%ecx
801073a3:	05 00 00 00 80       	add    $0x80000000,%eax
801073a8:	57                   	push   %edi
801073a9:	51                   	push   %ecx
801073aa:	50                   	push   %eax
801073ab:	ff 75 10             	push   0x10(%ebp)
801073ae:	e8 cd a7 ff ff       	call   80101b80 <readi>
801073b3:	83 c4 10             	add    $0x10,%esp
801073b6:	39 f8                	cmp    %edi,%eax
801073b8:	75 1e                	jne    801073d8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801073ba:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801073c0:	89 f0                	mov    %esi,%eax
801073c2:	29 d8                	sub    %ebx,%eax
801073c4:	39 c6                	cmp    %eax,%esi
801073c6:	77 80                	ja     80107348 <loaduvm+0x38>
}
801073c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073cb:	31 c0                	xor    %eax,%eax
}
801073cd:	5b                   	pop    %ebx
801073ce:	5e                   	pop    %esi
801073cf:	5f                   	pop    %edi
801073d0:	5d                   	pop    %ebp
801073d1:	c3                   	ret    
801073d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073e0:	5b                   	pop    %ebx
801073e1:	5e                   	pop    %esi
801073e2:	5f                   	pop    %edi
801073e3:	5d                   	pop    %ebp
801073e4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801073e5:	83 ec 0c             	sub    $0xc,%esp
801073e8:	68 94 83 10 80       	push   $0x80108394
801073ed:	e8 8e 8f ff ff       	call   80100380 <panic>
801073f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107400 <allocuvm>:
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	57                   	push   %edi
80107404:	56                   	push   %esi
80107405:	53                   	push   %ebx
80107406:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107409:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010740c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010740f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107412:	85 c0                	test   %eax,%eax
80107414:	0f 88 b6 00 00 00    	js     801074d0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010741a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010741d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107420:	0f 82 9a 00 00 00    	jb     801074c0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107426:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010742c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107432:	39 75 10             	cmp    %esi,0x10(%ebp)
80107435:	77 44                	ja     8010747b <allocuvm+0x7b>
80107437:	e9 87 00 00 00       	jmp    801074c3 <allocuvm+0xc3>
8010743c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107440:	83 ec 04             	sub    $0x4,%esp
80107443:	68 00 10 00 00       	push   $0x1000
80107448:	6a 00                	push   $0x0
8010744a:	50                   	push   %eax
8010744b:	e8 d0 d9 ff ff       	call   80104e20 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107450:	58                   	pop    %eax
80107451:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107457:	5a                   	pop    %edx
80107458:	6a 06                	push   $0x6
8010745a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010745f:	89 f2                	mov    %esi,%edx
80107461:	50                   	push   %eax
80107462:	89 f8                	mov    %edi,%eax
80107464:	e8 87 fb ff ff       	call   80106ff0 <mappages>
80107469:	83 c4 10             	add    $0x10,%esp
8010746c:	85 c0                	test   %eax,%eax
8010746e:	78 78                	js     801074e8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107470:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107476:	39 75 10             	cmp    %esi,0x10(%ebp)
80107479:	76 48                	jbe    801074c3 <allocuvm+0xc3>
    mem = kalloc();
8010747b:	e8 f0 b2 ff ff       	call   80102770 <kalloc>
80107480:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107482:	85 c0                	test   %eax,%eax
80107484:	75 ba                	jne    80107440 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107486:	83 ec 0c             	sub    $0xc,%esp
80107489:	68 0f 83 10 80       	push   $0x8010830f
8010748e:	e8 0d 92 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107493:	8b 45 0c             	mov    0xc(%ebp),%eax
80107496:	83 c4 10             	add    $0x10,%esp
80107499:	39 45 10             	cmp    %eax,0x10(%ebp)
8010749c:	74 32                	je     801074d0 <allocuvm+0xd0>
8010749e:	8b 55 10             	mov    0x10(%ebp),%edx
801074a1:	89 c1                	mov    %eax,%ecx
801074a3:	89 f8                	mov    %edi,%eax
801074a5:	e8 96 fa ff ff       	call   80106f40 <deallocuvm.part.0>
      return 0;
801074aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801074b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074b7:	5b                   	pop    %ebx
801074b8:	5e                   	pop    %esi
801074b9:	5f                   	pop    %edi
801074ba:	5d                   	pop    %ebp
801074bb:	c3                   	ret    
801074bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801074c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801074c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074c9:	5b                   	pop    %ebx
801074ca:	5e                   	pop    %esi
801074cb:	5f                   	pop    %edi
801074cc:	5d                   	pop    %ebp
801074cd:	c3                   	ret    
801074ce:	66 90                	xchg   %ax,%ax
    return 0;
801074d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801074d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074dd:	5b                   	pop    %ebx
801074de:	5e                   	pop    %esi
801074df:	5f                   	pop    %edi
801074e0:	5d                   	pop    %ebp
801074e1:	c3                   	ret    
801074e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801074e8:	83 ec 0c             	sub    $0xc,%esp
801074eb:	68 27 83 10 80       	push   $0x80108327
801074f0:	e8 ab 91 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801074f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801074f8:	83 c4 10             	add    $0x10,%esp
801074fb:	39 45 10             	cmp    %eax,0x10(%ebp)
801074fe:	74 0c                	je     8010750c <allocuvm+0x10c>
80107500:	8b 55 10             	mov    0x10(%ebp),%edx
80107503:	89 c1                	mov    %eax,%ecx
80107505:	89 f8                	mov    %edi,%eax
80107507:	e8 34 fa ff ff       	call   80106f40 <deallocuvm.part.0>
      kfree(mem);
8010750c:	83 ec 0c             	sub    $0xc,%esp
8010750f:	53                   	push   %ebx
80107510:	e8 9b b0 ff ff       	call   801025b0 <kfree>
      return 0;
80107515:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010751c:	83 c4 10             	add    $0x10,%esp
}
8010751f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107522:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107525:	5b                   	pop    %ebx
80107526:	5e                   	pop    %esi
80107527:	5f                   	pop    %edi
80107528:	5d                   	pop    %ebp
80107529:	c3                   	ret    
8010752a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107530 <deallocuvm>:
{
80107530:	55                   	push   %ebp
80107531:	89 e5                	mov    %esp,%ebp
80107533:	8b 55 0c             	mov    0xc(%ebp),%edx
80107536:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107539:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010753c:	39 d1                	cmp    %edx,%ecx
8010753e:	73 10                	jae    80107550 <deallocuvm+0x20>
}
80107540:	5d                   	pop    %ebp
80107541:	e9 fa f9 ff ff       	jmp    80106f40 <deallocuvm.part.0>
80107546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010754d:	8d 76 00             	lea    0x0(%esi),%esi
80107550:	89 d0                	mov    %edx,%eax
80107552:	5d                   	pop    %ebp
80107553:	c3                   	ret    
80107554:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010755b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010755f:	90                   	nop

80107560 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107560:	55                   	push   %ebp
80107561:	89 e5                	mov    %esp,%ebp
80107563:	57                   	push   %edi
80107564:	56                   	push   %esi
80107565:	53                   	push   %ebx
80107566:	83 ec 0c             	sub    $0xc,%esp
80107569:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010756c:	85 f6                	test   %esi,%esi
8010756e:	74 59                	je     801075c9 <freevm+0x69>
  if(newsz >= oldsz)
80107570:	31 c9                	xor    %ecx,%ecx
80107572:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107577:	89 f0                	mov    %esi,%eax
80107579:	89 f3                	mov    %esi,%ebx
8010757b:	e8 c0 f9 ff ff       	call   80106f40 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107580:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107586:	eb 0f                	jmp    80107597 <freevm+0x37>
80107588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010758f:	90                   	nop
80107590:	83 c3 04             	add    $0x4,%ebx
80107593:	39 df                	cmp    %ebx,%edi
80107595:	74 23                	je     801075ba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107597:	8b 03                	mov    (%ebx),%eax
80107599:	a8 01                	test   $0x1,%al
8010759b:	74 f3                	je     80107590 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010759d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801075a2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801075a5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801075a8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801075ad:	50                   	push   %eax
801075ae:	e8 fd af ff ff       	call   801025b0 <kfree>
801075b3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801075b6:	39 df                	cmp    %ebx,%edi
801075b8:	75 dd                	jne    80107597 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801075ba:	89 75 08             	mov    %esi,0x8(%ebp)
}
801075bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075c0:	5b                   	pop    %ebx
801075c1:	5e                   	pop    %esi
801075c2:	5f                   	pop    %edi
801075c3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801075c4:	e9 e7 af ff ff       	jmp    801025b0 <kfree>
    panic("freevm: no pgdir");
801075c9:	83 ec 0c             	sub    $0xc,%esp
801075cc:	68 43 83 10 80       	push   $0x80108343
801075d1:	e8 aa 8d ff ff       	call   80100380 <panic>
801075d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075dd:	8d 76 00             	lea    0x0(%esi),%esi

801075e0 <setupkvm>:
{
801075e0:	55                   	push   %ebp
801075e1:	89 e5                	mov    %esp,%ebp
801075e3:	56                   	push   %esi
801075e4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801075e5:	e8 86 b1 ff ff       	call   80102770 <kalloc>
801075ea:	89 c6                	mov    %eax,%esi
801075ec:	85 c0                	test   %eax,%eax
801075ee:	74 42                	je     80107632 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801075f0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075f3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801075f8:	68 00 10 00 00       	push   $0x1000
801075fd:	6a 00                	push   $0x0
801075ff:	50                   	push   %eax
80107600:	e8 1b d8 ff ff       	call   80104e20 <memset>
80107605:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107608:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010760b:	83 ec 08             	sub    $0x8,%esp
8010760e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107611:	ff 73 0c             	push   0xc(%ebx)
80107614:	8b 13                	mov    (%ebx),%edx
80107616:	50                   	push   %eax
80107617:	29 c1                	sub    %eax,%ecx
80107619:	89 f0                	mov    %esi,%eax
8010761b:	e8 d0 f9 ff ff       	call   80106ff0 <mappages>
80107620:	83 c4 10             	add    $0x10,%esp
80107623:	85 c0                	test   %eax,%eax
80107625:	78 19                	js     80107640 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107627:	83 c3 10             	add    $0x10,%ebx
8010762a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107630:	75 d6                	jne    80107608 <setupkvm+0x28>
}
80107632:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107635:	89 f0                	mov    %esi,%eax
80107637:	5b                   	pop    %ebx
80107638:	5e                   	pop    %esi
80107639:	5d                   	pop    %ebp
8010763a:	c3                   	ret    
8010763b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010763f:	90                   	nop
      freevm(pgdir);
80107640:	83 ec 0c             	sub    $0xc,%esp
80107643:	56                   	push   %esi
      return 0;
80107644:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107646:	e8 15 ff ff ff       	call   80107560 <freevm>
      return 0;
8010764b:	83 c4 10             	add    $0x10,%esp
}
8010764e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107651:	89 f0                	mov    %esi,%eax
80107653:	5b                   	pop    %ebx
80107654:	5e                   	pop    %esi
80107655:	5d                   	pop    %ebp
80107656:	c3                   	ret    
80107657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010765e:	66 90                	xchg   %ax,%ax

80107660 <kvmalloc>:
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107666:	e8 75 ff ff ff       	call   801075e0 <setupkvm>
8010766b:	a3 c4 51 13 80       	mov    %eax,0x801351c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107670:	05 00 00 00 80       	add    $0x80000000,%eax
80107675:	0f 22 d8             	mov    %eax,%cr3
}
80107678:	c9                   	leave  
80107679:	c3                   	ret    
8010767a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107680 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107680:	55                   	push   %ebp
80107681:	89 e5                	mov    %esp,%ebp
80107683:	83 ec 08             	sub    $0x8,%esp
80107686:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107689:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010768c:	89 c1                	mov    %eax,%ecx
8010768e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107691:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107694:	f6 c2 01             	test   $0x1,%dl
80107697:	75 17                	jne    801076b0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107699:	83 ec 0c             	sub    $0xc,%esp
8010769c:	68 54 83 10 80       	push   $0x80108354
801076a1:	e8 da 8c ff ff       	call   80100380 <panic>
801076a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ad:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801076b0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076b3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801076b9:	25 fc 0f 00 00       	and    $0xffc,%eax
801076be:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801076c5:	85 c0                	test   %eax,%eax
801076c7:	74 d0                	je     80107699 <clearpteu+0x19>
  *pte &= ~PTE_U;
801076c9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801076cc:	c9                   	leave  
801076cd:	c3                   	ret    
801076ce:	66 90                	xchg   %ax,%ax

801076d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801076d0:	55                   	push   %ebp
801076d1:	89 e5                	mov    %esp,%ebp
801076d3:	57                   	push   %edi
801076d4:	56                   	push   %esi
801076d5:	53                   	push   %ebx
801076d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801076d9:	e8 02 ff ff ff       	call   801075e0 <setupkvm>
801076de:	89 45 e0             	mov    %eax,-0x20(%ebp)
801076e1:	85 c0                	test   %eax,%eax
801076e3:	0f 84 bd 00 00 00    	je     801077a6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801076e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801076ec:	85 c9                	test   %ecx,%ecx
801076ee:	0f 84 b2 00 00 00    	je     801077a6 <copyuvm+0xd6>
801076f4:	31 f6                	xor    %esi,%esi
801076f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107700:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107703:	89 f0                	mov    %esi,%eax
80107705:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107708:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010770b:	a8 01                	test   $0x1,%al
8010770d:	75 11                	jne    80107720 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010770f:	83 ec 0c             	sub    $0xc,%esp
80107712:	68 5e 83 10 80       	push   $0x8010835e
80107717:	e8 64 8c ff ff       	call   80100380 <panic>
8010771c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107720:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107722:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107727:	c1 ea 0a             	shr    $0xa,%edx
8010772a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107730:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107737:	85 c0                	test   %eax,%eax
80107739:	74 d4                	je     8010770f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010773b:	8b 00                	mov    (%eax),%eax
8010773d:	a8 01                	test   $0x1,%al
8010773f:	0f 84 9f 00 00 00    	je     801077e4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107745:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107747:	25 ff 0f 00 00       	and    $0xfff,%eax
8010774c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010774f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107755:	e8 16 b0 ff ff       	call   80102770 <kalloc>
8010775a:	89 c3                	mov    %eax,%ebx
8010775c:	85 c0                	test   %eax,%eax
8010775e:	74 64                	je     801077c4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107760:	83 ec 04             	sub    $0x4,%esp
80107763:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107769:	68 00 10 00 00       	push   $0x1000
8010776e:	57                   	push   %edi
8010776f:	50                   	push   %eax
80107770:	e8 4b d7 ff ff       	call   80104ec0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107775:	58                   	pop    %eax
80107776:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010777c:	5a                   	pop    %edx
8010777d:	ff 75 e4             	push   -0x1c(%ebp)
80107780:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107785:	89 f2                	mov    %esi,%edx
80107787:	50                   	push   %eax
80107788:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010778b:	e8 60 f8 ff ff       	call   80106ff0 <mappages>
80107790:	83 c4 10             	add    $0x10,%esp
80107793:	85 c0                	test   %eax,%eax
80107795:	78 21                	js     801077b8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107797:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010779d:	39 75 0c             	cmp    %esi,0xc(%ebp)
801077a0:	0f 87 5a ff ff ff    	ja     80107700 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801077a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077ac:	5b                   	pop    %ebx
801077ad:	5e                   	pop    %esi
801077ae:	5f                   	pop    %edi
801077af:	5d                   	pop    %ebp
801077b0:	c3                   	ret    
801077b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801077b8:	83 ec 0c             	sub    $0xc,%esp
801077bb:	53                   	push   %ebx
801077bc:	e8 ef ad ff ff       	call   801025b0 <kfree>
      goto bad;
801077c1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801077c4:	83 ec 0c             	sub    $0xc,%esp
801077c7:	ff 75 e0             	push   -0x20(%ebp)
801077ca:	e8 91 fd ff ff       	call   80107560 <freevm>
  return 0;
801077cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801077d6:	83 c4 10             	add    $0x10,%esp
}
801077d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077df:	5b                   	pop    %ebx
801077e0:	5e                   	pop    %esi
801077e1:	5f                   	pop    %edi
801077e2:	5d                   	pop    %ebp
801077e3:	c3                   	ret    
      panic("copyuvm: page not present");
801077e4:	83 ec 0c             	sub    $0xc,%esp
801077e7:	68 78 83 10 80       	push   $0x80108378
801077ec:	e8 8f 8b ff ff       	call   80100380 <panic>
801077f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ff:	90                   	nop

80107800 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107806:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107809:	89 c1                	mov    %eax,%ecx
8010780b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010780e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107811:	f6 c2 01             	test   $0x1,%dl
80107814:	0f 84 00 01 00 00    	je     8010791a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010781a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010781d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107823:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107824:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107829:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107830:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107832:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107837:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010783a:	05 00 00 00 80       	add    $0x80000000,%eax
8010783f:	83 fa 05             	cmp    $0x5,%edx
80107842:	ba 00 00 00 00       	mov    $0x0,%edx
80107847:	0f 45 c2             	cmovne %edx,%eax
}
8010784a:	c3                   	ret    
8010784b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010784f:	90                   	nop

80107850 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107850:	55                   	push   %ebp
80107851:	89 e5                	mov    %esp,%ebp
80107853:	57                   	push   %edi
80107854:	56                   	push   %esi
80107855:	53                   	push   %ebx
80107856:	83 ec 0c             	sub    $0xc,%esp
80107859:	8b 75 14             	mov    0x14(%ebp),%esi
8010785c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010785f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107862:	85 f6                	test   %esi,%esi
80107864:	75 51                	jne    801078b7 <copyout+0x67>
80107866:	e9 a5 00 00 00       	jmp    80107910 <copyout+0xc0>
8010786b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010786f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107870:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107876:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010787c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107882:	74 75                	je     801078f9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107884:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107886:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107889:	29 c3                	sub    %eax,%ebx
8010788b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107891:	39 f3                	cmp    %esi,%ebx
80107893:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107896:	29 f8                	sub    %edi,%eax
80107898:	83 ec 04             	sub    $0x4,%esp
8010789b:	01 c1                	add    %eax,%ecx
8010789d:	53                   	push   %ebx
8010789e:	52                   	push   %edx
8010789f:	51                   	push   %ecx
801078a0:	e8 1b d6 ff ff       	call   80104ec0 <memmove>
    len -= n;
    buf += n;
801078a5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801078a8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801078ae:	83 c4 10             	add    $0x10,%esp
    buf += n;
801078b1:	01 da                	add    %ebx,%edx
  while(len > 0){
801078b3:	29 de                	sub    %ebx,%esi
801078b5:	74 59                	je     80107910 <copyout+0xc0>
  if(*pde & PTE_P){
801078b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801078ba:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801078bc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801078be:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801078c1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801078c7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801078ca:	f6 c1 01             	test   $0x1,%cl
801078cd:	0f 84 4e 00 00 00    	je     80107921 <copyout.cold>
  return &pgtab[PTX(va)];
801078d3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078d5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801078db:	c1 eb 0c             	shr    $0xc,%ebx
801078de:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801078e4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801078eb:	89 d9                	mov    %ebx,%ecx
801078ed:	83 e1 05             	and    $0x5,%ecx
801078f0:	83 f9 05             	cmp    $0x5,%ecx
801078f3:	0f 84 77 ff ff ff    	je     80107870 <copyout+0x20>
  }
  return 0;
}
801078f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801078fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107901:	5b                   	pop    %ebx
80107902:	5e                   	pop    %esi
80107903:	5f                   	pop    %edi
80107904:	5d                   	pop    %ebp
80107905:	c3                   	ret    
80107906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010790d:	8d 76 00             	lea    0x0(%esi),%esi
80107910:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107913:	31 c0                	xor    %eax,%eax
}
80107915:	5b                   	pop    %ebx
80107916:	5e                   	pop    %esi
80107917:	5f                   	pop    %edi
80107918:	5d                   	pop    %ebp
80107919:	c3                   	ret    

8010791a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010791a:	a1 00 00 00 00       	mov    0x0,%eax
8010791f:	0f 0b                	ud2    

80107921 <copyout.cold>:
80107921:	a1 00 00 00 00       	mov    0x0,%eax
80107926:	0f 0b                	ud2    
