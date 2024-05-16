
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
80100028:	bc d0 62 13 80       	mov    $0x801362d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 30 10 80       	mov    $0x801030e0,%eax
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
8010004c:	68 80 7a 10 80       	push   $0x80107a80
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 65 4c 00 00       	call   80104cc0 <initlock>
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
80100092:	68 87 7a 10 80       	push   $0x80107a87
80100097:	50                   	push   %eax
80100098:	e8 f3 4a 00 00       	call   80104b90 <initsleeplock>
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
801000e4:	e8 a7 4d 00 00       	call   80104e90 <acquire>
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
80100162:	e8 c9 4c 00 00       	call   80104e30 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 4a 00 00       	call   80104bd0 <acquiresleep>
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
8010018c:	e8 cf 21 00 00       	call   80102360 <iderw>
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
801001a1:	68 8e 7a 10 80       	push   $0x80107a8e
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
801001be:	e8 ad 4a 00 00       	call   80104c70 <holdingsleep>
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
801001d4:	e9 87 21 00 00       	jmp    80102360 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 9f 7a 10 80       	push   $0x80107a9f
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
801001ff:	e8 6c 4a 00 00       	call   80104c70 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 1c 4a 00 00       	call   80104c30 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 70 4c 00 00       	call   80104e90 <acquire>
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
8010026c:	e9 bf 4b 00 00       	jmp    80104e30 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 a6 7a 10 80       	push   $0x80107aa6
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
80100294:	e8 47 16 00 00       	call   801018e0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 eb 4b 00 00       	call   80104e90 <acquire>
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
801002cd:	e8 de 3e 00 00       	call   801041b0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 e9 37 00 00       	call   80103ad0 <myproc>
801002e7:	8b 48 18             	mov    0x18(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 35 4b 00 00       	call   80104e30 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 fc 14 00 00       	call   80101800 <ilock>
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
8010034c:	e8 df 4a 00 00       	call   80104e30 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 a6 14 00 00       	call   80101800 <ilock>
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
80100399:	e8 d2 25 00 00       	call   80102970 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ad 7a 10 80       	push   $0x80107aad
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 41 85 10 80 	movl   $0x80108541,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 13 49 00 00       	call   80104ce0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 c1 7a 10 80       	push   $0x80107ac1
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
8010041a:	e8 81 61 00 00       	call   801065a0 <uartputc>
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
80100505:	e8 96 60 00 00       	call   801065a0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 8a 60 00 00       	call   801065a0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 7e 60 00 00       	call   801065a0 <uartputc>
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
80100551:	e8 9a 4a 00 00       	call   80104ff0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 e5 49 00 00       	call   80104f50 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 c5 7a 10 80       	push   $0x80107ac5
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
8010059f:	e8 3c 13 00 00       	call   801018e0 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 e0 48 00 00       	call   80104e90 <acquire>
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
801005e4:	e8 47 48 00 00       	call   80104e30 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 0e 12 00 00       	call   80101800 <ilock>

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
80100636:	0f b6 92 f0 7a 10 80 	movzbl -0x7fef8510(%edx),%edx
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
801007e8:	e8 a3 46 00 00       	call   80104e90 <acquire>
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
80100838:	bf d8 7a 10 80       	mov    $0x80107ad8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 d0 45 00 00       	call   80104e30 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 df 7a 10 80       	push   $0x80107adf
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
80100893:	e8 f8 45 00 00       	call   80104e90 <acquire>
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
801009d0:	e8 5b 44 00 00       	call   80104e30 <release>
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
80100a0e:	e9 fd 3a 00 00       	jmp    80104510 <procdump>
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
80100a44:	e8 f7 39 00 00       	call   80104440 <wakeup>
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
80100a66:	68 e8 7a 10 80       	push   $0x80107ae8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 4b 42 00 00       	call   80104cc0 <initlock>

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
80100a99:	e8 62 1a 00 00       	call   80102500 <ioapicenable>
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
80100abc:	e8 0f 30 00 00       	call   80103ad0 <myproc>
80100ac1:	89 c1                	mov    %eax,%ecx
80100ac3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  struct thread *t;
  struct thread *curt = &curproc->threads[curproc->curtidx];
80100ac9:	8b 80 70 08 00 00    	mov    0x870(%eax),%eax

  // Clear every other thread first and copy current thread tid
  // to assign it to default-thread
  for(t = curproc->threads; t < &curproc->threads[NTHREAD]; t++){
80100acf:	8d 71 70             	lea    0x70(%ecx),%esi
80100ad2:	8d 99 70 08 00 00    	lea    0x870(%ecx),%ebx
  struct thread *curt = &curproc->threads[curproc->curtidx];
80100ad8:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100ade:	c1 e0 05             	shl    $0x5,%eax
80100ae1:	8d 7c 01 70          	lea    0x70(%ecx,%eax,1),%edi
  for(t = curproc->threads; t < &curproc->threads[NTHREAD]; t++){
80100ae5:	8d 76 00             	lea    0x0(%esi),%esi
	if(t->state == UNUSED)
	  continue;
	if(t == curt)
80100ae8:	8b 16                	mov    (%esi),%edx
80100aea:	85 d2                	test   %edx,%edx
80100aec:	74 18                	je     80100b06 <exec+0x56>
80100aee:	39 f7                	cmp    %esi,%edi
80100af0:	74 14                	je     80100b06 <exec+0x56>
	  continue;

	// clear every other threads
	if(tclear(t) == 0)
80100af2:	83 ec 0c             	sub    $0xc,%esp
80100af5:	56                   	push   %esi
80100af6:	e8 15 40 00 00       	call   80104b10 <tclear>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	0f 84 62 02 00 00    	je     80100d68 <exec+0x2b8>
  for(t = curproc->threads; t < &curproc->threads[NTHREAD]; t++){
80100b06:	83 c6 20             	add    $0x20,%esi
80100b09:	39 de                	cmp    %ebx,%esi
80100b0b:	75 db                	jne    80100ae8 <exec+0x38>
  dt->kstack = curt->kstack;
  dt->chan = curt->chan;
  dt->ret = curt->ret;
  */

  begin_op();
80100b0d:	e8 ce 22 00 00       	call   80102de0 <begin_op>

  if((ip = namei(path)) == 0){
80100b12:	83 ec 0c             	sub    $0xc,%esp
80100b15:	ff 75 08             	push   0x8(%ebp)
80100b18:	e8 03 16 00 00       	call   80102120 <namei>
80100b1d:	83 c4 10             	add    $0x10,%esp
80100b20:	89 c3                	mov    %eax,%ebx
80100b22:	85 c0                	test   %eax,%eax
80100b24:	0f 84 4b 02 00 00    	je     80100d75 <exec+0x2c5>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b2a:	83 ec 0c             	sub    $0xc,%esp
80100b2d:	50                   	push   %eax
80100b2e:	e8 cd 0c 00 00       	call   80101800 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b33:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b39:	6a 34                	push   $0x34
80100b3b:	6a 00                	push   $0x0
80100b3d:	50                   	push   %eax
80100b3e:	53                   	push   %ebx
80100b3f:	e8 cc 0f 00 00       	call   80101b10 <readi>
80100b44:	83 c4 20             	add    $0x20,%esp
80100b47:	83 f8 34             	cmp    $0x34,%eax
80100b4a:	74 1e                	je     80100b6a <exec+0xba>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b4c:	83 ec 0c             	sub    $0xc,%esp
80100b4f:	53                   	push   %ebx
80100b50:	e8 3b 0f 00 00       	call   80101a90 <iunlockput>
    end_op();
80100b55:	e8 f6 22 00 00       	call   80102e50 <end_op>
80100b5a:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b65:	5b                   	pop    %ebx
80100b66:	5e                   	pop    %esi
80100b67:	5f                   	pop    %edi
80100b68:	5d                   	pop    %ebp
80100b69:	c3                   	ret    
  if(elf.magic != ELF_MAGIC)
80100b6a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b71:	45 4c 46 
80100b74:	75 d6                	jne    80100b4c <exec+0x9c>
  if((pgdir = setupkvm()) == 0)
80100b76:	e8 b5 6b 00 00       	call   80107730 <setupkvm>
80100b7b:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 c7                	je     80100b4c <exec+0x9c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b85:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b8c:	00 
80100b8d:	8b bd 40 ff ff ff    	mov    -0xc0(%ebp),%edi
80100b93:	0f 84 ea 02 00 00    	je     80100e83 <exec+0x3d3>
  sz = 0;
80100b99:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100ba0:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ba3:	31 f6                	xor    %esi,%esi
80100ba5:	e9 8c 00 00 00       	jmp    80100c36 <exec+0x186>
80100baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ph.type != ELF_PROG_LOAD)
80100bb0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100bb7:	75 6c                	jne    80100c25 <exec+0x175>
    if(ph.memsz < ph.filesz)
80100bb9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100bbf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100bc5:	0f 82 87 00 00 00    	jb     80100c52 <exec+0x1a2>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100bcb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100bd1:	72 7f                	jb     80100c52 <exec+0x1a2>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bd3:	83 ec 04             	sub    $0x4,%esp
80100bd6:	50                   	push   %eax
80100bd7:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100bdd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100be3:	e8 68 69 00 00       	call   80107550 <allocuvm>
80100be8:	83 c4 10             	add    $0x10,%esp
80100beb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bf1:	85 c0                	test   %eax,%eax
80100bf3:	74 5d                	je     80100c52 <exec+0x1a2>
    if(ph.vaddr % PGSIZE != 0)
80100bf5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bfb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c00:	75 50                	jne    80100c52 <exec+0x1a2>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c02:	83 ec 0c             	sub    $0xc,%esp
80100c05:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100c0b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100c11:	53                   	push   %ebx
80100c12:	50                   	push   %eax
80100c13:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c19:	e8 42 68 00 00       	call   80107460 <loaduvm>
80100c1e:	83 c4 20             	add    $0x20,%esp
80100c21:	85 c0                	test   %eax,%eax
80100c23:	78 2d                	js     80100c52 <exec+0x1a2>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c25:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c2c:	83 c6 01             	add    $0x1,%esi
80100c2f:	83 c7 20             	add    $0x20,%edi
80100c32:	39 f0                	cmp    %esi,%eax
80100c34:	7e 32                	jle    80100c68 <exec+0x1b8>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c36:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c3c:	6a 20                	push   $0x20
80100c3e:	57                   	push   %edi
80100c3f:	50                   	push   %eax
80100c40:	53                   	push   %ebx
80100c41:	e8 ca 0e 00 00       	call   80101b10 <readi>
80100c46:	83 c4 10             	add    $0x10,%esp
80100c49:	83 f8 20             	cmp    $0x20,%eax
80100c4c:	0f 84 5e ff ff ff    	je     80100bb0 <exec+0x100>
    freevm(pgdir);
80100c52:	83 ec 0c             	sub    $0xc,%esp
80100c55:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c5b:	e8 50 6a 00 00       	call   801076b0 <freevm>
  if(ip){
80100c60:	83 c4 10             	add    $0x10,%esp
80100c63:	e9 e4 fe ff ff       	jmp    80100b4c <exec+0x9c>
  sz = PGROUNDUP(sz);
80100c68:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c6e:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c74:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c7a:	8d 87 00 20 00 00    	lea    0x2000(%edi),%eax
  iunlockput(ip);
80100c80:	83 ec 0c             	sub    $0xc,%esp
80100c83:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c89:	53                   	push   %ebx
80100c8a:	e8 01 0e 00 00       	call   80101a90 <iunlockput>
  end_op();
80100c8f:	e8 bc 21 00 00       	call   80102e50 <end_op>
  curproc->tdsz = sz;
80100c94:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c9a:	83 c4 0c             	add    $0xc,%esp
  curproc->tdsz = sz;
80100c9d:	89 78 04             	mov    %edi,0x4(%eax)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca0:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ca6:	50                   	push   %eax
80100ca7:	57                   	push   %edi
80100ca8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cae:	57                   	push   %edi
80100caf:	e8 9c 68 00 00       	call   80107550 <allocuvm>
80100cb4:	83 c4 10             	add    $0x10,%esp
80100cb7:	89 c6                	mov    %eax,%esi
80100cb9:	85 c0                	test   %eax,%eax
80100cbb:	0f 84 8c 00 00 00    	je     80100d4d <exec+0x29d>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cc1:	83 ec 08             	sub    $0x8,%esp
80100cc4:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100cca:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ccc:	50                   	push   %eax
80100ccd:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100cce:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd0:	e8 fb 6a 00 00       	call   801077d0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cd8:	83 c4 10             	add    $0x10,%esp
80100cdb:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100ce1:	8b 00                	mov    (%eax),%eax
80100ce3:	85 c0                	test   %eax,%eax
80100ce5:	75 2c                	jne    80100d13 <exec+0x263>
80100ce7:	e9 a8 00 00 00       	jmp    80100d94 <exec+0x2e4>
80100cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cf3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cfa:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cfd:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100d03:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100d06:	85 c0                	test   %eax,%eax
80100d08:	0f 84 86 00 00 00    	je     80100d94 <exec+0x2e4>
    if(argc >= MAXARG)
80100d0e:	83 ff 20             	cmp    $0x20,%edi
80100d11:	74 3a                	je     80100d4d <exec+0x29d>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d13:	83 ec 0c             	sub    $0xc,%esp
80100d16:	50                   	push   %eax
80100d17:	e8 34 44 00 00       	call   80105150 <strlen>
80100d1c:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d1e:	58                   	pop    %eax
80100d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d22:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d25:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d28:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d2b:	e8 20 44 00 00       	call   80105150 <strlen>
80100d30:	83 c0 01             	add    $0x1,%eax
80100d33:	50                   	push   %eax
80100d34:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d37:	ff 34 b8             	push   (%eax,%edi,4)
80100d3a:	53                   	push   %ebx
80100d3b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d41:	e8 5a 6c 00 00       	call   801079a0 <copyout>
80100d46:	83 c4 20             	add    $0x20,%esp
80100d49:	85 c0                	test   %eax,%eax
80100d4b:	79 a3                	jns    80100cf0 <exec+0x240>
    freevm(pgdir);
80100d4d:	83 ec 0c             	sub    $0xc,%esp
80100d50:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d56:	e8 55 69 00 00       	call   801076b0 <freevm>
80100d5b:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d63:	e9 fa fd ff ff       	jmp    80100b62 <exec+0xb2>
	  panic("exec(): tclear error\n");
80100d68:	83 ec 0c             	sub    $0xc,%esp
80100d6b:	68 01 7b 10 80       	push   $0x80107b01
80100d70:	e8 0b f6 ff ff       	call   80100380 <panic>
    end_op();
80100d75:	e8 d6 20 00 00       	call   80102e50 <end_op>
    cprintf("exec: fail\n");
80100d7a:	83 ec 0c             	sub    $0xc,%esp
80100d7d:	68 17 7b 10 80       	push   $0x80107b17
80100d82:	e8 19 f9 ff ff       	call   801006a0 <cprintf>
    return -1;
80100d87:	83 c4 10             	add    $0x10,%esp
80100d8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d8f:	e9 ce fd ff ff       	jmp    80100b62 <exec+0xb2>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d94:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d9b:	89 da                	mov    %ebx,%edx
  ustack[3+argc] = 0;
80100d9d:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100da4:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100da8:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100daa:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100dad:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100db3:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100db5:	50                   	push   %eax
80100db6:	51                   	push   %ecx
80100db7:	53                   	push   %ebx
80100db8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100dbe:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100dc5:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dc8:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dce:	e8 cd 6b 00 00       	call   801079a0 <copyout>
80100dd3:	83 c4 10             	add    $0x10,%esp
80100dd6:	85 c0                	test   %eax,%eax
80100dd8:	0f 88 6f ff ff ff    	js     80100d4d <exec+0x29d>
  for(last=s=path; *s; s++)
80100dde:	8b 45 08             	mov    0x8(%ebp),%eax
80100de1:	0f b6 00             	movzbl (%eax),%eax
80100de4:	84 c0                	test   %al,%al
80100de6:	74 17                	je     80100dff <exec+0x34f>
80100de8:	8b 55 08             	mov    0x8(%ebp),%edx
80100deb:	89 d1                	mov    %edx,%ecx
      last = s+1;
80100ded:	83 c1 01             	add    $0x1,%ecx
80100df0:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100df2:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100df5:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100df8:	84 c0                	test   %al,%al
80100dfa:	75 f1                	jne    80100ded <exec+0x33d>
80100dfc:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100dff:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100e05:	83 ec 04             	sub    $0x4,%esp
80100e08:	6a 10                	push   $0x10
80100e0a:	8d 47 60             	lea    0x60(%edi),%eax
80100e0d:	ff 75 08             	push   0x8(%ebp)
80100e10:	50                   	push   %eax
80100e11:	e8 fa 42 00 00       	call   80105110 <safestrcpy>
  curt->ustackp = sz;
80100e16:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100e1c:	8b 57 08             	mov    0x8(%edi),%edx
  curproc->sz = sz;
80100e1f:	89 37                	mov    %esi,(%edi)
  curproc->pgdir = pgdir;
80100e21:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100e27:	89 95 f0 fe ff ff    	mov    %edx,-0x110(%ebp)
  curproc->pgdir = pgdir;
80100e2d:	89 fa                	mov    %edi,%edx
80100e2f:	89 47 08             	mov    %eax,0x8(%edi)
  curt->ustackp = sz;
80100e32:	89 c8                	mov    %ecx,%eax
80100e34:	c1 e0 05             	shl    $0x5,%eax
80100e37:	89 b4 38 84 00 00 00 	mov    %esi,0x84(%eax,%edi,1)
  curt->tf->eip = elf.entry;  // main
80100e3e:	89 c8                	mov    %ecx,%eax
80100e40:	c1 e0 05             	shl    $0x5,%eax
80100e43:	01 f8                	add    %edi,%eax
80100e45:	8b bd 3c ff ff ff    	mov    -0xc4(%ebp),%edi
80100e4b:	8b 48 7c             	mov    0x7c(%eax),%ecx
80100e4e:	89 79 38             	mov    %edi,0x38(%ecx)
  curt->tf->esp = sp;
80100e51:	8b 40 7c             	mov    0x7c(%eax),%eax
80100e54:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e57:	89 14 24             	mov    %edx,(%esp)
80100e5a:	e8 71 64 00 00       	call   801072d0 <switchuvm>
  freevm(oldpgdir);
80100e5f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100e65:	89 14 24             	mov    %edx,(%esp)
80100e68:	e8 43 68 00 00       	call   801076b0 <freevm>
  cprintf("exec(): finished\n");
80100e6d:	c7 04 24 23 7b 10 80 	movl   $0x80107b23,(%esp)
80100e74:	e8 27 f8 ff ff       	call   801006a0 <cprintf>
  return 0;
80100e79:	83 c4 10             	add    $0x10,%esp
80100e7c:	31 c0                	xor    %eax,%eax
80100e7e:	e9 df fc ff ff       	jmp    80100b62 <exec+0xb2>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e83:	b8 00 20 00 00       	mov    $0x2000,%eax
80100e88:	31 ff                	xor    %edi,%edi
80100e8a:	e9 f1 fd ff ff       	jmp    80100c80 <exec+0x1d0>
80100e8f:	90                   	nop

80100e90 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e90:	55                   	push   %ebp
80100e91:	89 e5                	mov    %esp,%ebp
80100e93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e96:	68 35 7b 10 80       	push   $0x80107b35
80100e9b:	68 60 ff 10 80       	push   $0x8010ff60
80100ea0:	e8 1b 3e 00 00       	call   80104cc0 <initlock>
}
80100ea5:	83 c4 10             	add    $0x10,%esp
80100ea8:	c9                   	leave  
80100ea9:	c3                   	ret    
80100eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100eb0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100eb4:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100eb9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100ebc:	68 60 ff 10 80       	push   $0x8010ff60
80100ec1:	e8 ca 3f 00 00       	call   80104e90 <acquire>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb 10                	jmp    80100edb <filealloc+0x2b>
80100ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ecf:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ed0:	83 c3 18             	add    $0x18,%ebx
80100ed3:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100ed9:	74 25                	je     80100f00 <filealloc+0x50>
    if(f->ref == 0){
80100edb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ede:	85 c0                	test   %eax,%eax
80100ee0:	75 ee                	jne    80100ed0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ee2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ee5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100eec:	68 60 ff 10 80       	push   $0x8010ff60
80100ef1:	e8 3a 3f 00 00       	call   80104e30 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ef6:	89 d8                	mov    %ebx,%eax
      return f;
80100ef8:	83 c4 10             	add    $0x10,%esp
}
80100efb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100efe:	c9                   	leave  
80100eff:	c3                   	ret    
  release(&ftable.lock);
80100f00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f03:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f05:	68 60 ff 10 80       	push   $0x8010ff60
80100f0a:	e8 21 3f 00 00       	call   80104e30 <release>
}
80100f0f:	89 d8                	mov    %ebx,%eax
  return 0;
80100f11:	83 c4 10             	add    $0x10,%esp
}
80100f14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f17:	c9                   	leave  
80100f18:	c3                   	ret    
80100f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	53                   	push   %ebx
80100f24:	83 ec 10             	sub    $0x10,%esp
80100f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f2a:	68 60 ff 10 80       	push   $0x8010ff60
80100f2f:	e8 5c 3f 00 00       	call   80104e90 <acquire>
  if(f->ref < 1)
80100f34:	8b 43 04             	mov    0x4(%ebx),%eax
80100f37:	83 c4 10             	add    $0x10,%esp
80100f3a:	85 c0                	test   %eax,%eax
80100f3c:	7e 1a                	jle    80100f58 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f3e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f41:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f44:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f47:	68 60 ff 10 80       	push   $0x8010ff60
80100f4c:	e8 df 3e 00 00       	call   80104e30 <release>
  return f;
}
80100f51:	89 d8                	mov    %ebx,%eax
80100f53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f56:	c9                   	leave  
80100f57:	c3                   	ret    
    panic("filedup");
80100f58:	83 ec 0c             	sub    $0xc,%esp
80100f5b:	68 3c 7b 10 80       	push   $0x80107b3c
80100f60:	e8 1b f4 ff ff       	call   80100380 <panic>
80100f65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f70 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	57                   	push   %edi
80100f74:	56                   	push   %esi
80100f75:	53                   	push   %ebx
80100f76:	83 ec 28             	sub    $0x28,%esp
80100f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f7c:	68 60 ff 10 80       	push   $0x8010ff60
80100f81:	e8 0a 3f 00 00       	call   80104e90 <acquire>
  if(f->ref < 1)
80100f86:	8b 53 04             	mov    0x4(%ebx),%edx
80100f89:	83 c4 10             	add    $0x10,%esp
80100f8c:	85 d2                	test   %edx,%edx
80100f8e:	0f 8e a5 00 00 00    	jle    80101039 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f94:	83 ea 01             	sub    $0x1,%edx
80100f97:	89 53 04             	mov    %edx,0x4(%ebx)
80100f9a:	75 44                	jne    80100fe0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f9c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100fa0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100fa3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100fa5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100fab:	8b 73 0c             	mov    0xc(%ebx),%esi
80100fae:	88 45 e7             	mov    %al,-0x19(%ebp)
80100fb1:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100fb4:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100fb9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fbc:	e8 6f 3e 00 00       	call   80104e30 <release>

  if(ff.type == FD_PIPE)
80100fc1:	83 c4 10             	add    $0x10,%esp
80100fc4:	83 ff 01             	cmp    $0x1,%edi
80100fc7:	74 57                	je     80101020 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fc9:	83 ff 02             	cmp    $0x2,%edi
80100fcc:	74 2a                	je     80100ff8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd1:	5b                   	pop    %ebx
80100fd2:	5e                   	pop    %esi
80100fd3:	5f                   	pop    %edi
80100fd4:	5d                   	pop    %ebp
80100fd5:	c3                   	ret    
80100fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fdd:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100fe0:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100fe7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fea:	5b                   	pop    %ebx
80100feb:	5e                   	pop    %esi
80100fec:	5f                   	pop    %edi
80100fed:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fee:	e9 3d 3e 00 00       	jmp    80104e30 <release>
80100ff3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ff7:	90                   	nop
    begin_op();
80100ff8:	e8 e3 1d 00 00       	call   80102de0 <begin_op>
    iput(ff.ip);
80100ffd:	83 ec 0c             	sub    $0xc,%esp
80101000:	ff 75 e0             	push   -0x20(%ebp)
80101003:	e8 28 09 00 00       	call   80101930 <iput>
    end_op();
80101008:	83 c4 10             	add    $0x10,%esp
}
8010100b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010100e:	5b                   	pop    %ebx
8010100f:	5e                   	pop    %esi
80101010:	5f                   	pop    %edi
80101011:	5d                   	pop    %ebp
    end_op();
80101012:	e9 39 1e 00 00       	jmp    80102e50 <end_op>
80101017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010101e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101020:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101024:	83 ec 08             	sub    $0x8,%esp
80101027:	53                   	push   %ebx
80101028:	56                   	push   %esi
80101029:	e8 82 25 00 00       	call   801035b0 <pipeclose>
8010102e:	83 c4 10             	add    $0x10,%esp
}
80101031:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101034:	5b                   	pop    %ebx
80101035:	5e                   	pop    %esi
80101036:	5f                   	pop    %edi
80101037:	5d                   	pop    %ebp
80101038:	c3                   	ret    
    panic("fileclose");
80101039:	83 ec 0c             	sub    $0xc,%esp
8010103c:	68 44 7b 10 80       	push   $0x80107b44
80101041:	e8 3a f3 ff ff       	call   80100380 <panic>
80101046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010104d:	8d 76 00             	lea    0x0(%esi),%esi

80101050 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101050:	55                   	push   %ebp
80101051:	89 e5                	mov    %esp,%ebp
80101053:	53                   	push   %ebx
80101054:	83 ec 04             	sub    $0x4,%esp
80101057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010105a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010105d:	75 31                	jne    80101090 <filestat+0x40>
    ilock(f->ip);
8010105f:	83 ec 0c             	sub    $0xc,%esp
80101062:	ff 73 10             	push   0x10(%ebx)
80101065:	e8 96 07 00 00       	call   80101800 <ilock>
    stati(f->ip, st);
8010106a:	58                   	pop    %eax
8010106b:	5a                   	pop    %edx
8010106c:	ff 75 0c             	push   0xc(%ebp)
8010106f:	ff 73 10             	push   0x10(%ebx)
80101072:	e8 69 0a 00 00       	call   80101ae0 <stati>
    iunlock(f->ip);
80101077:	59                   	pop    %ecx
80101078:	ff 73 10             	push   0x10(%ebx)
8010107b:	e8 60 08 00 00       	call   801018e0 <iunlock>
    return 0;
  }
  return -1;
}
80101080:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101083:	83 c4 10             	add    $0x10,%esp
80101086:	31 c0                	xor    %eax,%eax
}
80101088:	c9                   	leave  
80101089:	c3                   	ret    
8010108a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101090:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101093:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101098:	c9                   	leave  
80101099:	c3                   	ret    
8010109a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801010a0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010a0:	55                   	push   %ebp
801010a1:	89 e5                	mov    %esp,%ebp
801010a3:	57                   	push   %edi
801010a4:	56                   	push   %esi
801010a5:	53                   	push   %ebx
801010a6:	83 ec 0c             	sub    $0xc,%esp
801010a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010ac:	8b 75 0c             	mov    0xc(%ebp),%esi
801010af:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010b2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010b6:	74 60                	je     80101118 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801010b8:	8b 03                	mov    (%ebx),%eax
801010ba:	83 f8 01             	cmp    $0x1,%eax
801010bd:	74 41                	je     80101100 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010bf:	83 f8 02             	cmp    $0x2,%eax
801010c2:	75 5b                	jne    8010111f <fileread+0x7f>
    ilock(f->ip);
801010c4:	83 ec 0c             	sub    $0xc,%esp
801010c7:	ff 73 10             	push   0x10(%ebx)
801010ca:	e8 31 07 00 00       	call   80101800 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010cf:	57                   	push   %edi
801010d0:	ff 73 14             	push   0x14(%ebx)
801010d3:	56                   	push   %esi
801010d4:	ff 73 10             	push   0x10(%ebx)
801010d7:	e8 34 0a 00 00       	call   80101b10 <readi>
801010dc:	83 c4 20             	add    $0x20,%esp
801010df:	89 c6                	mov    %eax,%esi
801010e1:	85 c0                	test   %eax,%eax
801010e3:	7e 03                	jle    801010e8 <fileread+0x48>
      f->off += r;
801010e5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010e8:	83 ec 0c             	sub    $0xc,%esp
801010eb:	ff 73 10             	push   0x10(%ebx)
801010ee:	e8 ed 07 00 00       	call   801018e0 <iunlock>
    return r;
801010f3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f9:	89 f0                	mov    %esi,%eax
801010fb:	5b                   	pop    %ebx
801010fc:	5e                   	pop    %esi
801010fd:	5f                   	pop    %edi
801010fe:	5d                   	pop    %ebp
801010ff:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101100:	8b 43 0c             	mov    0xc(%ebx),%eax
80101103:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101106:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101109:	5b                   	pop    %ebx
8010110a:	5e                   	pop    %esi
8010110b:	5f                   	pop    %edi
8010110c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010110d:	e9 3e 26 00 00       	jmp    80103750 <piperead>
80101112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101118:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010111d:	eb d7                	jmp    801010f6 <fileread+0x56>
  panic("fileread");
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	68 4e 7b 10 80       	push   $0x80107b4e
80101127:	e8 54 f2 ff ff       	call   80100380 <panic>
8010112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101130 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	57                   	push   %edi
80101134:	56                   	push   %esi
80101135:	53                   	push   %ebx
80101136:	83 ec 1c             	sub    $0x1c,%esp
80101139:	8b 45 0c             	mov    0xc(%ebp),%eax
8010113c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010113f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101142:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101145:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010114c:	0f 84 bd 00 00 00    	je     8010120f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101152:	8b 03                	mov    (%ebx),%eax
80101154:	83 f8 01             	cmp    $0x1,%eax
80101157:	0f 84 bf 00 00 00    	je     8010121c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010115d:	83 f8 02             	cmp    $0x2,%eax
80101160:	0f 85 c8 00 00 00    	jne    8010122e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101169:	31 f6                	xor    %esi,%esi
    while(i < n){
8010116b:	85 c0                	test   %eax,%eax
8010116d:	7f 30                	jg     8010119f <filewrite+0x6f>
8010116f:	e9 94 00 00 00       	jmp    80101208 <filewrite+0xd8>
80101174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101178:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010117b:	83 ec 0c             	sub    $0xc,%esp
8010117e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101181:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101184:	e8 57 07 00 00       	call   801018e0 <iunlock>
      end_op();
80101189:	e8 c2 1c 00 00       	call   80102e50 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010118e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101191:	83 c4 10             	add    $0x10,%esp
80101194:	39 c7                	cmp    %eax,%edi
80101196:	75 5c                	jne    801011f4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101198:	01 fe                	add    %edi,%esi
    while(i < n){
8010119a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010119d:	7e 69                	jle    80101208 <filewrite+0xd8>
      int n1 = n - i;
8010119f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801011a2:	b8 00 06 00 00       	mov    $0x600,%eax
801011a7:	29 f7                	sub    %esi,%edi
801011a9:	39 c7                	cmp    %eax,%edi
801011ab:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
801011ae:	e8 2d 1c 00 00       	call   80102de0 <begin_op>
      ilock(f->ip);
801011b3:	83 ec 0c             	sub    $0xc,%esp
801011b6:	ff 73 10             	push   0x10(%ebx)
801011b9:	e8 42 06 00 00       	call   80101800 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011be:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011c1:	57                   	push   %edi
801011c2:	ff 73 14             	push   0x14(%ebx)
801011c5:	01 f0                	add    %esi,%eax
801011c7:	50                   	push   %eax
801011c8:	ff 73 10             	push   0x10(%ebx)
801011cb:	e8 40 0a 00 00       	call   80101c10 <writei>
801011d0:	83 c4 20             	add    $0x20,%esp
801011d3:	85 c0                	test   %eax,%eax
801011d5:	7f a1                	jg     80101178 <filewrite+0x48>
      iunlock(f->ip);
801011d7:	83 ec 0c             	sub    $0xc,%esp
801011da:	ff 73 10             	push   0x10(%ebx)
801011dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011e0:	e8 fb 06 00 00       	call   801018e0 <iunlock>
      end_op();
801011e5:	e8 66 1c 00 00       	call   80102e50 <end_op>
      if(r < 0)
801011ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011ed:	83 c4 10             	add    $0x10,%esp
801011f0:	85 c0                	test   %eax,%eax
801011f2:	75 1b                	jne    8010120f <filewrite+0xdf>
        panic("short filewrite");
801011f4:	83 ec 0c             	sub    $0xc,%esp
801011f7:	68 57 7b 10 80       	push   $0x80107b57
801011fc:	e8 7f f1 ff ff       	call   80100380 <panic>
80101201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101208:	89 f0                	mov    %esi,%eax
8010120a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010120d:	74 05                	je     80101214 <filewrite+0xe4>
8010120f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101214:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101217:	5b                   	pop    %ebx
80101218:	5e                   	pop    %esi
80101219:	5f                   	pop    %edi
8010121a:	5d                   	pop    %ebp
8010121b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010121c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010121f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101222:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101225:	5b                   	pop    %ebx
80101226:	5e                   	pop    %esi
80101227:	5f                   	pop    %edi
80101228:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101229:	e9 22 24 00 00       	jmp    80103650 <pipewrite>
  panic("filewrite");
8010122e:	83 ec 0c             	sub    $0xc,%esp
80101231:	68 5d 7b 10 80       	push   $0x80107b5d
80101236:	e8 45 f1 ff ff       	call   80100380 <panic>
8010123b:	66 90                	xchg   %ax,%ax
8010123d:	66 90                	xchg   %ax,%ax
8010123f:	90                   	nop

80101240 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101240:	55                   	push   %ebp
80101241:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101243:	89 d0                	mov    %edx,%eax
80101245:	c1 e8 0c             	shr    $0xc,%eax
80101248:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
8010124e:	89 e5                	mov    %esp,%ebp
80101250:	56                   	push   %esi
80101251:	53                   	push   %ebx
80101252:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	50                   	push   %eax
80101258:	51                   	push   %ecx
80101259:	e8 72 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010125e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101260:	c1 fb 03             	sar    $0x3,%ebx
80101263:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101266:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101268:	83 e1 07             	and    $0x7,%ecx
8010126b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101270:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101276:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101278:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010127d:	85 c1                	test   %eax,%ecx
8010127f:	74 23                	je     801012a4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101281:	f7 d0                	not    %eax
  log_write(bp);
80101283:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101286:	21 c8                	and    %ecx,%eax
80101288:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010128c:	56                   	push   %esi
8010128d:	e8 2e 1d 00 00       	call   80102fc0 <log_write>
  brelse(bp);
80101292:	89 34 24             	mov    %esi,(%esp)
80101295:	e8 56 ef ff ff       	call   801001f0 <brelse>
}
8010129a:	83 c4 10             	add    $0x10,%esp
8010129d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801012a0:	5b                   	pop    %ebx
801012a1:	5e                   	pop    %esi
801012a2:	5d                   	pop    %ebp
801012a3:	c3                   	ret    
    panic("freeing free block");
801012a4:	83 ec 0c             	sub    $0xc,%esp
801012a7:	68 67 7b 10 80       	push   $0x80107b67
801012ac:	e8 cf f0 ff ff       	call   80100380 <panic>
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012bf:	90                   	nop

801012c0 <balloc>:
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801012c9:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
801012cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012d2:	85 c9                	test   %ecx,%ecx
801012d4:	0f 84 87 00 00 00    	je     80101361 <balloc+0xa1>
801012da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012e1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012e4:	83 ec 08             	sub    $0x8,%esp
801012e7:	89 f0                	mov    %esi,%eax
801012e9:	c1 f8 0c             	sar    $0xc,%eax
801012ec:	03 05 cc 25 11 80    	add    0x801125cc,%eax
801012f2:	50                   	push   %eax
801012f3:	ff 75 d8             	push   -0x28(%ebp)
801012f6:	e8 d5 ed ff ff       	call   801000d0 <bread>
801012fb:	83 c4 10             	add    $0x10,%esp
801012fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101301:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101306:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101309:	31 c0                	xor    %eax,%eax
8010130b:	eb 2f                	jmp    8010133c <balloc+0x7c>
8010130d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101310:	89 c1                	mov    %eax,%ecx
80101312:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101317:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010131a:	83 e1 07             	and    $0x7,%ecx
8010131d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010131f:	89 c1                	mov    %eax,%ecx
80101321:	c1 f9 03             	sar    $0x3,%ecx
80101324:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101329:	89 fa                	mov    %edi,%edx
8010132b:	85 df                	test   %ebx,%edi
8010132d:	74 41                	je     80101370 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010132f:	83 c0 01             	add    $0x1,%eax
80101332:	83 c6 01             	add    $0x1,%esi
80101335:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010133a:	74 05                	je     80101341 <balloc+0x81>
8010133c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010133f:	77 cf                	ja     80101310 <balloc+0x50>
    brelse(bp);
80101341:	83 ec 0c             	sub    $0xc,%esp
80101344:	ff 75 e4             	push   -0x1c(%ebp)
80101347:	e8 a4 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010134c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101353:	83 c4 10             	add    $0x10,%esp
80101356:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101359:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
8010135f:	77 80                	ja     801012e1 <balloc+0x21>
  panic("balloc: out of blocks");
80101361:	83 ec 0c             	sub    $0xc,%esp
80101364:	68 7a 7b 10 80       	push   $0x80107b7a
80101369:	e8 12 f0 ff ff       	call   80100380 <panic>
8010136e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101373:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101376:	09 da                	or     %ebx,%edx
80101378:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010137c:	57                   	push   %edi
8010137d:	e8 3e 1c 00 00       	call   80102fc0 <log_write>
        brelse(bp);
80101382:	89 3c 24             	mov    %edi,(%esp)
80101385:	e8 66 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010138a:	58                   	pop    %eax
8010138b:	5a                   	pop    %edx
8010138c:	56                   	push   %esi
8010138d:	ff 75 d8             	push   -0x28(%ebp)
80101390:	e8 3b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101395:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101398:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010139a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010139d:	68 00 02 00 00       	push   $0x200
801013a2:	6a 00                	push   $0x0
801013a4:	50                   	push   %eax
801013a5:	e8 a6 3b 00 00       	call   80104f50 <memset>
  log_write(bp);
801013aa:	89 1c 24             	mov    %ebx,(%esp)
801013ad:	e8 0e 1c 00 00       	call   80102fc0 <log_write>
  brelse(bp);
801013b2:	89 1c 24             	mov    %ebx,(%esp)
801013b5:	e8 36 ee ff ff       	call   801001f0 <brelse>
}
801013ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013bd:	89 f0                	mov    %esi,%eax
801013bf:	5b                   	pop    %ebx
801013c0:	5e                   	pop    %esi
801013c1:	5f                   	pop    %edi
801013c2:	5d                   	pop    %ebp
801013c3:	c3                   	ret    
801013c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013cf:	90                   	nop

801013d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	57                   	push   %edi
801013d4:	89 c7                	mov    %eax,%edi
801013d6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013d7:	31 f6                	xor    %esi,%esi
{
801013d9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013da:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
801013df:	83 ec 28             	sub    $0x28,%esp
801013e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013e5:	68 60 09 11 80       	push   $0x80110960
801013ea:	e8 a1 3a 00 00       	call   80104e90 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801013f2:	83 c4 10             	add    $0x10,%esp
801013f5:	eb 1b                	jmp    80101412 <iget+0x42>
801013f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013fe:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101400:	39 3b                	cmp    %edi,(%ebx)
80101402:	74 6c                	je     80101470 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101404:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010140a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101410:	73 26                	jae    80101438 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101412:	8b 43 08             	mov    0x8(%ebx),%eax
80101415:	85 c0                	test   %eax,%eax
80101417:	7f e7                	jg     80101400 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101419:	85 f6                	test   %esi,%esi
8010141b:	75 e7                	jne    80101404 <iget+0x34>
8010141d:	85 c0                	test   %eax,%eax
8010141f:	75 76                	jne    80101497 <iget+0xc7>
80101421:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101423:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101429:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010142f:	72 e1                	jb     80101412 <iget+0x42>
80101431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101438:	85 f6                	test   %esi,%esi
8010143a:	74 79                	je     801014b5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010143c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010143f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101441:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101444:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010144b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101452:	68 60 09 11 80       	push   $0x80110960
80101457:	e8 d4 39 00 00       	call   80104e30 <release>

  return ip;
8010145c:	83 c4 10             	add    $0x10,%esp
}
8010145f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101462:	89 f0                	mov    %esi,%eax
80101464:	5b                   	pop    %ebx
80101465:	5e                   	pop    %esi
80101466:	5f                   	pop    %edi
80101467:	5d                   	pop    %ebp
80101468:	c3                   	ret    
80101469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101470:	39 53 04             	cmp    %edx,0x4(%ebx)
80101473:	75 8f                	jne    80101404 <iget+0x34>
      release(&icache.lock);
80101475:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101478:	83 c0 01             	add    $0x1,%eax
      return ip;
8010147b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010147d:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101482:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101485:	e8 a6 39 00 00       	call   80104e30 <release>
      return ip;
8010148a:	83 c4 10             	add    $0x10,%esp
}
8010148d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101490:	89 f0                	mov    %esi,%eax
80101492:	5b                   	pop    %ebx
80101493:	5e                   	pop    %esi
80101494:	5f                   	pop    %edi
80101495:	5d                   	pop    %ebp
80101496:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101497:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010149d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801014a3:	73 10                	jae    801014b5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014a5:	8b 43 08             	mov    0x8(%ebx),%eax
801014a8:	85 c0                	test   %eax,%eax
801014aa:	0f 8f 50 ff ff ff    	jg     80101400 <iget+0x30>
801014b0:	e9 68 ff ff ff       	jmp    8010141d <iget+0x4d>
    panic("iget: no inodes");
801014b5:	83 ec 0c             	sub    $0xc,%esp
801014b8:	68 90 7b 10 80       	push   $0x80107b90
801014bd:	e8 be ee ff ff       	call   80100380 <panic>
801014c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014d0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014d0:	55                   	push   %ebp
801014d1:	89 e5                	mov    %esp,%ebp
801014d3:	57                   	push   %edi
801014d4:	56                   	push   %esi
801014d5:	89 c6                	mov    %eax,%esi
801014d7:	53                   	push   %ebx
801014d8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014db:	83 fa 0b             	cmp    $0xb,%edx
801014de:	0f 86 8c 00 00 00    	jbe    80101570 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014e4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014e7:	83 fb 7f             	cmp    $0x7f,%ebx
801014ea:	0f 87 a2 00 00 00    	ja     80101592 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014f0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014f6:	85 c0                	test   %eax,%eax
801014f8:	74 5e                	je     80101558 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014fa:	83 ec 08             	sub    $0x8,%esp
801014fd:	50                   	push   %eax
801014fe:	ff 36                	push   (%esi)
80101500:	e8 cb eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101505:	83 c4 10             	add    $0x10,%esp
80101508:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010150c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010150e:	8b 3b                	mov    (%ebx),%edi
80101510:	85 ff                	test   %edi,%edi
80101512:	74 1c                	je     80101530 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101514:	83 ec 0c             	sub    $0xc,%esp
80101517:	52                   	push   %edx
80101518:	e8 d3 ec ff ff       	call   801001f0 <brelse>
8010151d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101520:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101523:	89 f8                	mov    %edi,%eax
80101525:	5b                   	pop    %ebx
80101526:	5e                   	pop    %esi
80101527:	5f                   	pop    %edi
80101528:	5d                   	pop    %ebp
80101529:	c3                   	ret    
8010152a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101530:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101533:	8b 06                	mov    (%esi),%eax
80101535:	e8 86 fd ff ff       	call   801012c0 <balloc>
      log_write(bp);
8010153a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010153d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101540:	89 03                	mov    %eax,(%ebx)
80101542:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101544:	52                   	push   %edx
80101545:	e8 76 1a 00 00       	call   80102fc0 <log_write>
8010154a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010154d:	83 c4 10             	add    $0x10,%esp
80101550:	eb c2                	jmp    80101514 <bmap+0x44>
80101552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101558:	8b 06                	mov    (%esi),%eax
8010155a:	e8 61 fd ff ff       	call   801012c0 <balloc>
8010155f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101565:	eb 93                	jmp    801014fa <bmap+0x2a>
80101567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010156e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101570:	8d 5a 14             	lea    0x14(%edx),%ebx
80101573:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101577:	85 ff                	test   %edi,%edi
80101579:	75 a5                	jne    80101520 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010157b:	8b 00                	mov    (%eax),%eax
8010157d:	e8 3e fd ff ff       	call   801012c0 <balloc>
80101582:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101586:	89 c7                	mov    %eax,%edi
}
80101588:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010158b:	5b                   	pop    %ebx
8010158c:	89 f8                	mov    %edi,%eax
8010158e:	5e                   	pop    %esi
8010158f:	5f                   	pop    %edi
80101590:	5d                   	pop    %ebp
80101591:	c3                   	ret    
  panic("bmap: out of range");
80101592:	83 ec 0c             	sub    $0xc,%esp
80101595:	68 a0 7b 10 80       	push   $0x80107ba0
8010159a:	e8 e1 ed ff ff       	call   80100380 <panic>
8010159f:	90                   	nop

801015a0 <readsb>:
{
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	56                   	push   %esi
801015a4:	53                   	push   %ebx
801015a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801015a8:	83 ec 08             	sub    $0x8,%esp
801015ab:	6a 01                	push   $0x1
801015ad:	ff 75 08             	push   0x8(%ebp)
801015b0:	e8 1b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015b5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015b8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015ba:	8d 40 5c             	lea    0x5c(%eax),%eax
801015bd:	6a 1c                	push   $0x1c
801015bf:	50                   	push   %eax
801015c0:	56                   	push   %esi
801015c1:	e8 2a 3a 00 00       	call   80104ff0 <memmove>
  brelse(bp);
801015c6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801015c9:	83 c4 10             	add    $0x10,%esp
}
801015cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015cf:	5b                   	pop    %ebx
801015d0:	5e                   	pop    %esi
801015d1:	5d                   	pop    %ebp
  brelse(bp);
801015d2:	e9 19 ec ff ff       	jmp    801001f0 <brelse>
801015d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015de:	66 90                	xchg   %ax,%ax

801015e0 <iinit>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	53                   	push   %ebx
801015e4:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
801015e9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015ec:	68 b3 7b 10 80       	push   $0x80107bb3
801015f1:	68 60 09 11 80       	push   $0x80110960
801015f6:	e8 c5 36 00 00       	call   80104cc0 <initlock>
  for(i = 0; i < NINODE; i++) {
801015fb:	83 c4 10             	add    $0x10,%esp
801015fe:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101600:	83 ec 08             	sub    $0x8,%esp
80101603:	68 ba 7b 10 80       	push   $0x80107bba
80101608:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101609:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010160f:	e8 7c 35 00 00       	call   80104b90 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101614:	83 c4 10             	add    $0x10,%esp
80101617:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010161d:	75 e1                	jne    80101600 <iinit+0x20>
  bp = bread(dev, 1);
8010161f:	83 ec 08             	sub    $0x8,%esp
80101622:	6a 01                	push   $0x1
80101624:	ff 75 08             	push   0x8(%ebp)
80101627:	e8 a4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010162c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010162f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101631:	8d 40 5c             	lea    0x5c(%eax),%eax
80101634:	6a 1c                	push   $0x1c
80101636:	50                   	push   %eax
80101637:	68 b4 25 11 80       	push   $0x801125b4
8010163c:	e8 af 39 00 00       	call   80104ff0 <memmove>
  brelse(bp);
80101641:	89 1c 24             	mov    %ebx,(%esp)
80101644:	e8 a7 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101649:	ff 35 cc 25 11 80    	push   0x801125cc
8010164f:	ff 35 c8 25 11 80    	push   0x801125c8
80101655:	ff 35 c4 25 11 80    	push   0x801125c4
8010165b:	ff 35 c0 25 11 80    	push   0x801125c0
80101661:	ff 35 bc 25 11 80    	push   0x801125bc
80101667:	ff 35 b8 25 11 80    	push   0x801125b8
8010166d:	ff 35 b4 25 11 80    	push   0x801125b4
80101673:	68 20 7c 10 80       	push   $0x80107c20
80101678:	e8 23 f0 ff ff       	call   801006a0 <cprintf>
}
8010167d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101680:	83 c4 30             	add    $0x30,%esp
80101683:	c9                   	leave  
80101684:	c3                   	ret    
80101685:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ialloc>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	57                   	push   %edi
80101694:	56                   	push   %esi
80101695:	53                   	push   %ebx
80101696:	83 ec 1c             	sub    $0x1c,%esp
80101699:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010169c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
801016a3:	8b 75 08             	mov    0x8(%ebp),%esi
801016a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801016a9:	0f 86 91 00 00 00    	jbe    80101740 <ialloc+0xb0>
801016af:	bf 01 00 00 00       	mov    $0x1,%edi
801016b4:	eb 21                	jmp    801016d7 <ialloc+0x47>
801016b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016bd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801016c0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016c3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016c6:	53                   	push   %ebx
801016c7:	e8 24 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016cc:	83 c4 10             	add    $0x10,%esp
801016cf:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
801016d5:	73 69                	jae    80101740 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016d7:	89 f8                	mov    %edi,%eax
801016d9:	83 ec 08             	sub    $0x8,%esp
801016dc:	c1 e8 03             	shr    $0x3,%eax
801016df:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016e5:	50                   	push   %eax
801016e6:	56                   	push   %esi
801016e7:	e8 e4 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016ec:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016ef:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016f1:	89 f8                	mov    %edi,%eax
801016f3:	83 e0 07             	and    $0x7,%eax
801016f6:	c1 e0 06             	shl    $0x6,%eax
801016f9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016fd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101701:	75 bd                	jne    801016c0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101703:	83 ec 04             	sub    $0x4,%esp
80101706:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101709:	6a 40                	push   $0x40
8010170b:	6a 00                	push   $0x0
8010170d:	51                   	push   %ecx
8010170e:	e8 3d 38 00 00       	call   80104f50 <memset>
      dip->type = type;
80101713:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101717:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010171a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010171d:	89 1c 24             	mov    %ebx,(%esp)
80101720:	e8 9b 18 00 00       	call   80102fc0 <log_write>
      brelse(bp);
80101725:	89 1c 24             	mov    %ebx,(%esp)
80101728:	e8 c3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010172d:	83 c4 10             	add    $0x10,%esp
}
80101730:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101733:	89 fa                	mov    %edi,%edx
}
80101735:	5b                   	pop    %ebx
      return iget(dev, inum);
80101736:	89 f0                	mov    %esi,%eax
}
80101738:	5e                   	pop    %esi
80101739:	5f                   	pop    %edi
8010173a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010173b:	e9 90 fc ff ff       	jmp    801013d0 <iget>
  panic("ialloc: no inodes");
80101740:	83 ec 0c             	sub    $0xc,%esp
80101743:	68 c0 7b 10 80       	push   $0x80107bc0
80101748:	e8 33 ec ff ff       	call   80100380 <panic>
8010174d:	8d 76 00             	lea    0x0(%esi),%esi

80101750 <iupdate>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	56                   	push   %esi
80101754:	53                   	push   %ebx
80101755:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101758:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010175b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010175e:	83 ec 08             	sub    $0x8,%esp
80101761:	c1 e8 03             	shr    $0x3,%eax
80101764:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010176a:	50                   	push   %eax
8010176b:	ff 73 a4             	push   -0x5c(%ebx)
8010176e:	e8 5d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101773:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101777:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010177a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010177c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010177f:	83 e0 07             	and    $0x7,%eax
80101782:	c1 e0 06             	shl    $0x6,%eax
80101785:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101789:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010178c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101790:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101793:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101797:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010179b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010179f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801017a3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801017a7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801017aa:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017ad:	6a 34                	push   $0x34
801017af:	53                   	push   %ebx
801017b0:	50                   	push   %eax
801017b1:	e8 3a 38 00 00       	call   80104ff0 <memmove>
  log_write(bp);
801017b6:	89 34 24             	mov    %esi,(%esp)
801017b9:	e8 02 18 00 00       	call   80102fc0 <log_write>
  brelse(bp);
801017be:	89 75 08             	mov    %esi,0x8(%ebp)
801017c1:	83 c4 10             	add    $0x10,%esp
}
801017c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017c7:	5b                   	pop    %ebx
801017c8:	5e                   	pop    %esi
801017c9:	5d                   	pop    %ebp
  brelse(bp);
801017ca:	e9 21 ea ff ff       	jmp    801001f0 <brelse>
801017cf:	90                   	nop

801017d0 <idup>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	53                   	push   %ebx
801017d4:	83 ec 10             	sub    $0x10,%esp
801017d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017da:	68 60 09 11 80       	push   $0x80110960
801017df:	e8 ac 36 00 00       	call   80104e90 <acquire>
  ip->ref++;
801017e4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017e8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801017ef:	e8 3c 36 00 00       	call   80104e30 <release>
}
801017f4:	89 d8                	mov    %ebx,%eax
801017f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017f9:	c9                   	leave  
801017fa:	c3                   	ret    
801017fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ff:	90                   	nop

80101800 <ilock>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	56                   	push   %esi
80101804:	53                   	push   %ebx
80101805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101808:	85 db                	test   %ebx,%ebx
8010180a:	0f 84 b7 00 00 00    	je     801018c7 <ilock+0xc7>
80101810:	8b 53 08             	mov    0x8(%ebx),%edx
80101813:	85 d2                	test   %edx,%edx
80101815:	0f 8e ac 00 00 00    	jle    801018c7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010181b:	83 ec 0c             	sub    $0xc,%esp
8010181e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101821:	50                   	push   %eax
80101822:	e8 a9 33 00 00       	call   80104bd0 <acquiresleep>
  if(ip->valid == 0){
80101827:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010182a:	83 c4 10             	add    $0x10,%esp
8010182d:	85 c0                	test   %eax,%eax
8010182f:	74 0f                	je     80101840 <ilock+0x40>
}
80101831:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101834:	5b                   	pop    %ebx
80101835:	5e                   	pop    %esi
80101836:	5d                   	pop    %ebp
80101837:	c3                   	ret    
80101838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101840:	8b 43 04             	mov    0x4(%ebx),%eax
80101843:	83 ec 08             	sub    $0x8,%esp
80101846:	c1 e8 03             	shr    $0x3,%eax
80101849:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010184f:	50                   	push   %eax
80101850:	ff 33                	push   (%ebx)
80101852:	e8 79 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101857:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010185a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010185c:	8b 43 04             	mov    0x4(%ebx),%eax
8010185f:	83 e0 07             	and    $0x7,%eax
80101862:	c1 e0 06             	shl    $0x6,%eax
80101865:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101869:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010186c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010186f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101873:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101877:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010187b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010187f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101883:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101887:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010188b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010188e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101891:	6a 34                	push   $0x34
80101893:	50                   	push   %eax
80101894:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101897:	50                   	push   %eax
80101898:	e8 53 37 00 00       	call   80104ff0 <memmove>
    brelse(bp);
8010189d:	89 34 24             	mov    %esi,(%esp)
801018a0:	e8 4b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801018a5:	83 c4 10             	add    $0x10,%esp
801018a8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801018ad:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018b4:	0f 85 77 ff ff ff    	jne    80101831 <ilock+0x31>
      panic("ilock: no type");
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	68 d8 7b 10 80       	push   $0x80107bd8
801018c2:	e8 b9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
801018c7:	83 ec 0c             	sub    $0xc,%esp
801018ca:	68 d2 7b 10 80       	push   $0x80107bd2
801018cf:	e8 ac ea ff ff       	call   80100380 <panic>
801018d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018df:	90                   	nop

801018e0 <iunlock>:
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	56                   	push   %esi
801018e4:	53                   	push   %ebx
801018e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018e8:	85 db                	test   %ebx,%ebx
801018ea:	74 28                	je     80101914 <iunlock+0x34>
801018ec:	83 ec 0c             	sub    $0xc,%esp
801018ef:	8d 73 0c             	lea    0xc(%ebx),%esi
801018f2:	56                   	push   %esi
801018f3:	e8 78 33 00 00       	call   80104c70 <holdingsleep>
801018f8:	83 c4 10             	add    $0x10,%esp
801018fb:	85 c0                	test   %eax,%eax
801018fd:	74 15                	je     80101914 <iunlock+0x34>
801018ff:	8b 43 08             	mov    0x8(%ebx),%eax
80101902:	85 c0                	test   %eax,%eax
80101904:	7e 0e                	jle    80101914 <iunlock+0x34>
  releasesleep(&ip->lock);
80101906:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101909:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010190c:	5b                   	pop    %ebx
8010190d:	5e                   	pop    %esi
8010190e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010190f:	e9 1c 33 00 00       	jmp    80104c30 <releasesleep>
    panic("iunlock");
80101914:	83 ec 0c             	sub    $0xc,%esp
80101917:	68 e7 7b 10 80       	push   $0x80107be7
8010191c:	e8 5f ea ff ff       	call   80100380 <panic>
80101921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010192f:	90                   	nop

80101930 <iput>:
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	57                   	push   %edi
80101934:	56                   	push   %esi
80101935:	53                   	push   %ebx
80101936:	83 ec 28             	sub    $0x28,%esp
80101939:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010193c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010193f:	57                   	push   %edi
80101940:	e8 8b 32 00 00       	call   80104bd0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101945:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101948:	83 c4 10             	add    $0x10,%esp
8010194b:	85 d2                	test   %edx,%edx
8010194d:	74 07                	je     80101956 <iput+0x26>
8010194f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101954:	74 32                	je     80101988 <iput+0x58>
  releasesleep(&ip->lock);
80101956:	83 ec 0c             	sub    $0xc,%esp
80101959:	57                   	push   %edi
8010195a:	e8 d1 32 00 00       	call   80104c30 <releasesleep>
  acquire(&icache.lock);
8010195f:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101966:	e8 25 35 00 00       	call   80104e90 <acquire>
  ip->ref--;
8010196b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010196f:	83 c4 10             	add    $0x10,%esp
80101972:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101979:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010197c:	5b                   	pop    %ebx
8010197d:	5e                   	pop    %esi
8010197e:	5f                   	pop    %edi
8010197f:	5d                   	pop    %ebp
  release(&icache.lock);
80101980:	e9 ab 34 00 00       	jmp    80104e30 <release>
80101985:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101988:	83 ec 0c             	sub    $0xc,%esp
8010198b:	68 60 09 11 80       	push   $0x80110960
80101990:	e8 fb 34 00 00       	call   80104e90 <acquire>
    int r = ip->ref;
80101995:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101998:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010199f:	e8 8c 34 00 00       	call   80104e30 <release>
    if(r == 1){
801019a4:	83 c4 10             	add    $0x10,%esp
801019a7:	83 fe 01             	cmp    $0x1,%esi
801019aa:	75 aa                	jne    80101956 <iput+0x26>
801019ac:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019b2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019b5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019b8:	89 cf                	mov    %ecx,%edi
801019ba:	eb 0b                	jmp    801019c7 <iput+0x97>
801019bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 fe                	cmp    %edi,%esi
801019c5:	74 19                	je     801019e0 <iput+0xb0>
    if(ip->addrs[i]){
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 6c f8 ff ff       	call   80101240 <bfree>
      ip->addrs[i] = 0;
801019d4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019da:	eb e4                	jmp    801019c0 <iput+0x90>
801019dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019e0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019e9:	85 c0                	test   %eax,%eax
801019eb:	75 2d                	jne    80101a1a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019ed:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019f0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019f7:	53                   	push   %ebx
801019f8:	e8 53 fd ff ff       	call   80101750 <iupdate>
      ip->type = 0;
801019fd:	31 c0                	xor    %eax,%eax
801019ff:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a03:	89 1c 24             	mov    %ebx,(%esp)
80101a06:	e8 45 fd ff ff       	call   80101750 <iupdate>
      ip->valid = 0;
80101a0b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a12:	83 c4 10             	add    $0x10,%esp
80101a15:	e9 3c ff ff ff       	jmp    80101956 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a1a:	83 ec 08             	sub    $0x8,%esp
80101a1d:	50                   	push   %eax
80101a1e:	ff 33                	push   (%ebx)
80101a20:	e8 ab e6 ff ff       	call   801000d0 <bread>
80101a25:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101a34:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a37:	89 cf                	mov    %ecx,%edi
80101a39:	eb 0c                	jmp    80101a47 <iput+0x117>
80101a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a3f:	90                   	nop
80101a40:	83 c6 04             	add    $0x4,%esi
80101a43:	39 f7                	cmp    %esi,%edi
80101a45:	74 0f                	je     80101a56 <iput+0x126>
      if(a[j])
80101a47:	8b 16                	mov    (%esi),%edx
80101a49:	85 d2                	test   %edx,%edx
80101a4b:	74 f3                	je     80101a40 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a4d:	8b 03                	mov    (%ebx),%eax
80101a4f:	e8 ec f7 ff ff       	call   80101240 <bfree>
80101a54:	eb ea                	jmp    80101a40 <iput+0x110>
    brelse(bp);
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	ff 75 e4             	push   -0x1c(%ebp)
80101a5c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a5f:	e8 8c e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a64:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a6a:	8b 03                	mov    (%ebx),%eax
80101a6c:	e8 cf f7 ff ff       	call   80101240 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a71:	83 c4 10             	add    $0x10,%esp
80101a74:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a7b:	00 00 00 
80101a7e:	e9 6a ff ff ff       	jmp    801019ed <iput+0xbd>
80101a83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a90 <iunlockput>:
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	56                   	push   %esi
80101a94:	53                   	push   %ebx
80101a95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a98:	85 db                	test   %ebx,%ebx
80101a9a:	74 34                	je     80101ad0 <iunlockput+0x40>
80101a9c:	83 ec 0c             	sub    $0xc,%esp
80101a9f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101aa2:	56                   	push   %esi
80101aa3:	e8 c8 31 00 00       	call   80104c70 <holdingsleep>
80101aa8:	83 c4 10             	add    $0x10,%esp
80101aab:	85 c0                	test   %eax,%eax
80101aad:	74 21                	je     80101ad0 <iunlockput+0x40>
80101aaf:	8b 43 08             	mov    0x8(%ebx),%eax
80101ab2:	85 c0                	test   %eax,%eax
80101ab4:	7e 1a                	jle    80101ad0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101ab6:	83 ec 0c             	sub    $0xc,%esp
80101ab9:	56                   	push   %esi
80101aba:	e8 71 31 00 00       	call   80104c30 <releasesleep>
  iput(ip);
80101abf:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ac2:	83 c4 10             	add    $0x10,%esp
}
80101ac5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ac8:	5b                   	pop    %ebx
80101ac9:	5e                   	pop    %esi
80101aca:	5d                   	pop    %ebp
  iput(ip);
80101acb:	e9 60 fe ff ff       	jmp    80101930 <iput>
    panic("iunlock");
80101ad0:	83 ec 0c             	sub    $0xc,%esp
80101ad3:	68 e7 7b 10 80       	push   $0x80107be7
80101ad8:	e8 a3 e8 ff ff       	call   80100380 <panic>
80101add:	8d 76 00             	lea    0x0(%esi),%esi

80101ae0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ae9:	8b 0a                	mov    (%edx),%ecx
80101aeb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101aee:	8b 4a 04             	mov    0x4(%edx),%ecx
80101af1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101af4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101af8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101afb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101aff:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b03:	8b 52 58             	mov    0x58(%edx),%edx
80101b06:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b09:	5d                   	pop    %ebp
80101b0a:	c3                   	ret    
80101b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b0f:	90                   	nop

80101b10 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	57                   	push   %edi
80101b14:	56                   	push   %esi
80101b15:	53                   	push   %ebx
80101b16:	83 ec 1c             	sub    $0x1c,%esp
80101b19:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101b1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1f:	8b 75 10             	mov    0x10(%ebp),%esi
80101b22:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b25:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b28:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b2d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b30:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b33:	0f 84 a7 00 00 00    	je     80101be0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	8b 40 58             	mov    0x58(%eax),%eax
80101b3f:	39 c6                	cmp    %eax,%esi
80101b41:	0f 87 ba 00 00 00    	ja     80101c01 <readi+0xf1>
80101b47:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b4a:	31 c9                	xor    %ecx,%ecx
80101b4c:	89 da                	mov    %ebx,%edx
80101b4e:	01 f2                	add    %esi,%edx
80101b50:	0f 92 c1             	setb   %cl
80101b53:	89 cf                	mov    %ecx,%edi
80101b55:	0f 82 a6 00 00 00    	jb     80101c01 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b5b:	89 c1                	mov    %eax,%ecx
80101b5d:	29 f1                	sub    %esi,%ecx
80101b5f:	39 d0                	cmp    %edx,%eax
80101b61:	0f 43 cb             	cmovae %ebx,%ecx
80101b64:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b67:	85 c9                	test   %ecx,%ecx
80101b69:	74 67                	je     80101bd2 <readi+0xc2>
80101b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b6f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b70:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b73:	89 f2                	mov    %esi,%edx
80101b75:	c1 ea 09             	shr    $0x9,%edx
80101b78:	89 d8                	mov    %ebx,%eax
80101b7a:	e8 51 f9 ff ff       	call   801014d0 <bmap>
80101b7f:	83 ec 08             	sub    $0x8,%esp
80101b82:	50                   	push   %eax
80101b83:	ff 33                	push   (%ebx)
80101b85:	e8 46 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b8a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b8d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b92:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b94:	89 f0                	mov    %esi,%eax
80101b96:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b9b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b9d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba0:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101ba2:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba6:	39 d9                	cmp    %ebx,%ecx
80101ba8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101bab:	83 c4 0c             	add    $0xc,%esp
80101bae:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101baf:	01 df                	add    %ebx,%edi
80101bb1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101bb3:	50                   	push   %eax
80101bb4:	ff 75 e0             	push   -0x20(%ebp)
80101bb7:	e8 34 34 00 00       	call   80104ff0 <memmove>
    brelse(bp);
80101bbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bbf:	89 14 24             	mov    %edx,(%esp)
80101bc2:	e8 29 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bc7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bca:	83 c4 10             	add    $0x10,%esp
80101bcd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101bd0:	77 9e                	ja     80101b70 <readi+0x60>
  }
  return n;
80101bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101bd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd8:	5b                   	pop    %ebx
80101bd9:	5e                   	pop    %esi
80101bda:	5f                   	pop    %edi
80101bdb:	5d                   	pop    %ebp
80101bdc:	c3                   	ret    
80101bdd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101be0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101be4:	66 83 f8 09          	cmp    $0x9,%ax
80101be8:	77 17                	ja     80101c01 <readi+0xf1>
80101bea:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101bf1:	85 c0                	test   %eax,%eax
80101bf3:	74 0c                	je     80101c01 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101bf5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfb:	5b                   	pop    %ebx
80101bfc:	5e                   	pop    %esi
80101bfd:	5f                   	pop    %edi
80101bfe:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bff:	ff e0                	jmp    *%eax
      return -1;
80101c01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c06:	eb cd                	jmp    80101bd5 <readi+0xc5>
80101c08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c0f:	90                   	nop

80101c10 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	57                   	push   %edi
80101c14:	56                   	push   %esi
80101c15:	53                   	push   %ebx
80101c16:	83 ec 1c             	sub    $0x1c,%esp
80101c19:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c1f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c27:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c30:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c33:	0f 84 b7 00 00 00    	je     80101cf0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c3f:	0f 87 e7 00 00 00    	ja     80101d2c <writei+0x11c>
80101c45:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c48:	31 d2                	xor    %edx,%edx
80101c4a:	89 f8                	mov    %edi,%eax
80101c4c:	01 f0                	add    %esi,%eax
80101c4e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c51:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c56:	0f 87 d0 00 00 00    	ja     80101d2c <writei+0x11c>
80101c5c:	85 d2                	test   %edx,%edx
80101c5e:	0f 85 c8 00 00 00    	jne    80101d2c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c6b:	85 ff                	test   %edi,%edi
80101c6d:	74 72                	je     80101ce1 <writei+0xd1>
80101c6f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c70:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c73:	89 f2                	mov    %esi,%edx
80101c75:	c1 ea 09             	shr    $0x9,%edx
80101c78:	89 f8                	mov    %edi,%eax
80101c7a:	e8 51 f8 ff ff       	call   801014d0 <bmap>
80101c7f:	83 ec 08             	sub    $0x8,%esp
80101c82:	50                   	push   %eax
80101c83:	ff 37                	push   (%edi)
80101c85:	e8 46 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c8a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c8f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c92:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c95:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c97:	89 f0                	mov    %esi,%eax
80101c99:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c9e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ca0:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ca4:	39 d9                	cmp    %ebx,%ecx
80101ca6:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ca9:	83 c4 0c             	add    $0xc,%esp
80101cac:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cad:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101caf:	ff 75 dc             	push   -0x24(%ebp)
80101cb2:	50                   	push   %eax
80101cb3:	e8 38 33 00 00       	call   80104ff0 <memmove>
    log_write(bp);
80101cb8:	89 3c 24             	mov    %edi,(%esp)
80101cbb:	e8 00 13 00 00       	call   80102fc0 <log_write>
    brelse(bp);
80101cc0:	89 3c 24             	mov    %edi,(%esp)
80101cc3:	e8 28 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cc8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ccb:	83 c4 10             	add    $0x10,%esp
80101cce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cd1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cd4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101cd7:	77 97                	ja     80101c70 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101cd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cdc:	3b 70 58             	cmp    0x58(%eax),%esi
80101cdf:	77 37                	ja     80101d18 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ce1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ce4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ce7:	5b                   	pop    %ebx
80101ce8:	5e                   	pop    %esi
80101ce9:	5f                   	pop    %edi
80101cea:	5d                   	pop    %ebp
80101ceb:	c3                   	ret    
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cf0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cf4:	66 83 f8 09          	cmp    $0x9,%ax
80101cf8:	77 32                	ja     80101d2c <writei+0x11c>
80101cfa:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101d01:	85 c0                	test   %eax,%eax
80101d03:	74 27                	je     80101d2c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101d05:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d0b:	5b                   	pop    %ebx
80101d0c:	5e                   	pop    %esi
80101d0d:	5f                   	pop    %edi
80101d0e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d0f:	ff e0                	jmp    *%eax
80101d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101d18:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101d1b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d1e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d21:	50                   	push   %eax
80101d22:	e8 29 fa ff ff       	call   80101750 <iupdate>
80101d27:	83 c4 10             	add    $0x10,%esp
80101d2a:	eb b5                	jmp    80101ce1 <writei+0xd1>
      return -1;
80101d2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d31:	eb b1                	jmp    80101ce4 <writei+0xd4>
80101d33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101d40 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d46:	6a 0e                	push   $0xe
80101d48:	ff 75 0c             	push   0xc(%ebp)
80101d4b:	ff 75 08             	push   0x8(%ebp)
80101d4e:	e8 0d 33 00 00       	call   80105060 <strncmp>
}
80101d53:	c9                   	leave  
80101d54:	c3                   	ret    
80101d55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d60 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	57                   	push   %edi
80101d64:	56                   	push   %esi
80101d65:	53                   	push   %ebx
80101d66:	83 ec 1c             	sub    $0x1c,%esp
80101d69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d6c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d71:	0f 85 85 00 00 00    	jne    80101dfc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d77:	8b 53 58             	mov    0x58(%ebx),%edx
80101d7a:	31 ff                	xor    %edi,%edi
80101d7c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d7f:	85 d2                	test   %edx,%edx
80101d81:	74 3e                	je     80101dc1 <dirlookup+0x61>
80101d83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d87:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d88:	6a 10                	push   $0x10
80101d8a:	57                   	push   %edi
80101d8b:	56                   	push   %esi
80101d8c:	53                   	push   %ebx
80101d8d:	e8 7e fd ff ff       	call   80101b10 <readi>
80101d92:	83 c4 10             	add    $0x10,%esp
80101d95:	83 f8 10             	cmp    $0x10,%eax
80101d98:	75 55                	jne    80101def <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d9f:	74 18                	je     80101db9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101da1:	83 ec 04             	sub    $0x4,%esp
80101da4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101da7:	6a 0e                	push   $0xe
80101da9:	50                   	push   %eax
80101daa:	ff 75 0c             	push   0xc(%ebp)
80101dad:	e8 ae 32 00 00       	call   80105060 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101db2:	83 c4 10             	add    $0x10,%esp
80101db5:	85 c0                	test   %eax,%eax
80101db7:	74 17                	je     80101dd0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101db9:	83 c7 10             	add    $0x10,%edi
80101dbc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101dbf:	72 c7                	jb     80101d88 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101dc4:	31 c0                	xor    %eax,%eax
}
80101dc6:	5b                   	pop    %ebx
80101dc7:	5e                   	pop    %esi
80101dc8:	5f                   	pop    %edi
80101dc9:	5d                   	pop    %ebp
80101dca:	c3                   	ret    
80101dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101dcf:	90                   	nop
      if(poff)
80101dd0:	8b 45 10             	mov    0x10(%ebp),%eax
80101dd3:	85 c0                	test   %eax,%eax
80101dd5:	74 05                	je     80101ddc <dirlookup+0x7c>
        *poff = off;
80101dd7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dda:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ddc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101de0:	8b 03                	mov    (%ebx),%eax
80101de2:	e8 e9 f5 ff ff       	call   801013d0 <iget>
}
80101de7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dea:	5b                   	pop    %ebx
80101deb:	5e                   	pop    %esi
80101dec:	5f                   	pop    %edi
80101ded:	5d                   	pop    %ebp
80101dee:	c3                   	ret    
      panic("dirlookup read");
80101def:	83 ec 0c             	sub    $0xc,%esp
80101df2:	68 01 7c 10 80       	push   $0x80107c01
80101df7:	e8 84 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101dfc:	83 ec 0c             	sub    $0xc,%esp
80101dff:	68 ef 7b 10 80       	push   $0x80107bef
80101e04:	e8 77 e5 ff ff       	call   80100380 <panic>
80101e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e10 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	89 c3                	mov    %eax,%ebx
80101e18:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e1b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e1e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e21:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e24:	0f 84 64 01 00 00    	je     80101f8e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e2a:	e8 a1 1c 00 00       	call   80103ad0 <myproc>
  acquire(&icache.lock);
80101e2f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e32:	8b 70 5c             	mov    0x5c(%eax),%esi
  acquire(&icache.lock);
80101e35:	68 60 09 11 80       	push   $0x80110960
80101e3a:	e8 51 30 00 00       	call   80104e90 <acquire>
  ip->ref++;
80101e3f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e43:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101e4a:	e8 e1 2f 00 00       	call   80104e30 <release>
80101e4f:	83 c4 10             	add    $0x10,%esp
80101e52:	eb 07                	jmp    80101e5b <namex+0x4b>
80101e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e58:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e5b:	0f b6 03             	movzbl (%ebx),%eax
80101e5e:	3c 2f                	cmp    $0x2f,%al
80101e60:	74 f6                	je     80101e58 <namex+0x48>
  if(*path == 0)
80101e62:	84 c0                	test   %al,%al
80101e64:	0f 84 06 01 00 00    	je     80101f70 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e6a:	0f b6 03             	movzbl (%ebx),%eax
80101e6d:	84 c0                	test   %al,%al
80101e6f:	0f 84 10 01 00 00    	je     80101f85 <namex+0x175>
80101e75:	89 df                	mov    %ebx,%edi
80101e77:	3c 2f                	cmp    $0x2f,%al
80101e79:	0f 84 06 01 00 00    	je     80101f85 <namex+0x175>
80101e7f:	90                   	nop
80101e80:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e84:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e87:	3c 2f                	cmp    $0x2f,%al
80101e89:	74 04                	je     80101e8f <namex+0x7f>
80101e8b:	84 c0                	test   %al,%al
80101e8d:	75 f1                	jne    80101e80 <namex+0x70>
  len = path - s;
80101e8f:	89 f8                	mov    %edi,%eax
80101e91:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e93:	83 f8 0d             	cmp    $0xd,%eax
80101e96:	0f 8e ac 00 00 00    	jle    80101f48 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e9c:	83 ec 04             	sub    $0x4,%esp
80101e9f:	6a 0e                	push   $0xe
80101ea1:	53                   	push   %ebx
    path++;
80101ea2:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101ea4:	ff 75 e4             	push   -0x1c(%ebp)
80101ea7:	e8 44 31 00 00       	call   80104ff0 <memmove>
80101eac:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101eaf:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101eb2:	75 0c                	jne    80101ec0 <namex+0xb0>
80101eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101eb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ebb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ebe:	74 f8                	je     80101eb8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ec0:	83 ec 0c             	sub    $0xc,%esp
80101ec3:	56                   	push   %esi
80101ec4:	e8 37 f9 ff ff       	call   80101800 <ilock>
    if(ip->type != T_DIR){
80101ec9:	83 c4 10             	add    $0x10,%esp
80101ecc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ed1:	0f 85 cd 00 00 00    	jne    80101fa4 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ed7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eda:	85 c0                	test   %eax,%eax
80101edc:	74 09                	je     80101ee7 <namex+0xd7>
80101ede:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ee1:	0f 84 22 01 00 00    	je     80102009 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ee7:	83 ec 04             	sub    $0x4,%esp
80101eea:	6a 00                	push   $0x0
80101eec:	ff 75 e4             	push   -0x1c(%ebp)
80101eef:	56                   	push   %esi
80101ef0:	e8 6b fe ff ff       	call   80101d60 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ef5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101ef8:	83 c4 10             	add    $0x10,%esp
80101efb:	89 c7                	mov    %eax,%edi
80101efd:	85 c0                	test   %eax,%eax
80101eff:	0f 84 e1 00 00 00    	je     80101fe6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f0b:	52                   	push   %edx
80101f0c:	e8 5f 2d 00 00       	call   80104c70 <holdingsleep>
80101f11:	83 c4 10             	add    $0x10,%esp
80101f14:	85 c0                	test   %eax,%eax
80101f16:	0f 84 30 01 00 00    	je     8010204c <namex+0x23c>
80101f1c:	8b 56 08             	mov    0x8(%esi),%edx
80101f1f:	85 d2                	test   %edx,%edx
80101f21:	0f 8e 25 01 00 00    	jle    8010204c <namex+0x23c>
  releasesleep(&ip->lock);
80101f27:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f2a:	83 ec 0c             	sub    $0xc,%esp
80101f2d:	52                   	push   %edx
80101f2e:	e8 fd 2c 00 00       	call   80104c30 <releasesleep>
  iput(ip);
80101f33:	89 34 24             	mov    %esi,(%esp)
80101f36:	89 fe                	mov    %edi,%esi
80101f38:	e8 f3 f9 ff ff       	call   80101930 <iput>
80101f3d:	83 c4 10             	add    $0x10,%esp
80101f40:	e9 16 ff ff ff       	jmp    80101e5b <namex+0x4b>
80101f45:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f48:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f4b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101f4e:	83 ec 04             	sub    $0x4,%esp
80101f51:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f54:	50                   	push   %eax
80101f55:	53                   	push   %ebx
    name[len] = 0;
80101f56:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f58:	ff 75 e4             	push   -0x1c(%ebp)
80101f5b:	e8 90 30 00 00       	call   80104ff0 <memmove>
    name[len] = 0;
80101f60:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f63:	83 c4 10             	add    $0x10,%esp
80101f66:	c6 02 00             	movb   $0x0,(%edx)
80101f69:	e9 41 ff ff ff       	jmp    80101eaf <namex+0x9f>
80101f6e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f70:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f73:	85 c0                	test   %eax,%eax
80101f75:	0f 85 be 00 00 00    	jne    80102039 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f7e:	89 f0                	mov    %esi,%eax
80101f80:	5b                   	pop    %ebx
80101f81:	5e                   	pop    %esi
80101f82:	5f                   	pop    %edi
80101f83:	5d                   	pop    %ebp
80101f84:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f85:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f88:	89 df                	mov    %ebx,%edi
80101f8a:	31 c0                	xor    %eax,%eax
80101f8c:	eb c0                	jmp    80101f4e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f8e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f93:	b8 01 00 00 00       	mov    $0x1,%eax
80101f98:	e8 33 f4 ff ff       	call   801013d0 <iget>
80101f9d:	89 c6                	mov    %eax,%esi
80101f9f:	e9 b7 fe ff ff       	jmp    80101e5b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fa4:	83 ec 0c             	sub    $0xc,%esp
80101fa7:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101faa:	53                   	push   %ebx
80101fab:	e8 c0 2c 00 00       	call   80104c70 <holdingsleep>
80101fb0:	83 c4 10             	add    $0x10,%esp
80101fb3:	85 c0                	test   %eax,%eax
80101fb5:	0f 84 91 00 00 00    	je     8010204c <namex+0x23c>
80101fbb:	8b 46 08             	mov    0x8(%esi),%eax
80101fbe:	85 c0                	test   %eax,%eax
80101fc0:	0f 8e 86 00 00 00    	jle    8010204c <namex+0x23c>
  releasesleep(&ip->lock);
80101fc6:	83 ec 0c             	sub    $0xc,%esp
80101fc9:	53                   	push   %ebx
80101fca:	e8 61 2c 00 00       	call   80104c30 <releasesleep>
  iput(ip);
80101fcf:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fd2:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fd4:	e8 57 f9 ff ff       	call   80101930 <iput>
      return 0;
80101fd9:	83 c4 10             	add    $0x10,%esp
}
80101fdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fdf:	89 f0                	mov    %esi,%eax
80101fe1:	5b                   	pop    %ebx
80101fe2:	5e                   	pop    %esi
80101fe3:	5f                   	pop    %edi
80101fe4:	5d                   	pop    %ebp
80101fe5:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fe6:	83 ec 0c             	sub    $0xc,%esp
80101fe9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101fec:	52                   	push   %edx
80101fed:	e8 7e 2c 00 00       	call   80104c70 <holdingsleep>
80101ff2:	83 c4 10             	add    $0x10,%esp
80101ff5:	85 c0                	test   %eax,%eax
80101ff7:	74 53                	je     8010204c <namex+0x23c>
80101ff9:	8b 4e 08             	mov    0x8(%esi),%ecx
80101ffc:	85 c9                	test   %ecx,%ecx
80101ffe:	7e 4c                	jle    8010204c <namex+0x23c>
  releasesleep(&ip->lock);
80102000:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102003:	83 ec 0c             	sub    $0xc,%esp
80102006:	52                   	push   %edx
80102007:	eb c1                	jmp    80101fca <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102009:	83 ec 0c             	sub    $0xc,%esp
8010200c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010200f:	53                   	push   %ebx
80102010:	e8 5b 2c 00 00       	call   80104c70 <holdingsleep>
80102015:	83 c4 10             	add    $0x10,%esp
80102018:	85 c0                	test   %eax,%eax
8010201a:	74 30                	je     8010204c <namex+0x23c>
8010201c:	8b 7e 08             	mov    0x8(%esi),%edi
8010201f:	85 ff                	test   %edi,%edi
80102021:	7e 29                	jle    8010204c <namex+0x23c>
  releasesleep(&ip->lock);
80102023:	83 ec 0c             	sub    $0xc,%esp
80102026:	53                   	push   %ebx
80102027:	e8 04 2c 00 00       	call   80104c30 <releasesleep>
}
8010202c:	83 c4 10             	add    $0x10,%esp
}
8010202f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102032:	89 f0                	mov    %esi,%eax
80102034:	5b                   	pop    %ebx
80102035:	5e                   	pop    %esi
80102036:	5f                   	pop    %edi
80102037:	5d                   	pop    %ebp
80102038:	c3                   	ret    
    iput(ip);
80102039:	83 ec 0c             	sub    $0xc,%esp
8010203c:	56                   	push   %esi
    return 0;
8010203d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010203f:	e8 ec f8 ff ff       	call   80101930 <iput>
    return 0;
80102044:	83 c4 10             	add    $0x10,%esp
80102047:	e9 2f ff ff ff       	jmp    80101f7b <namex+0x16b>
    panic("iunlock");
8010204c:	83 ec 0c             	sub    $0xc,%esp
8010204f:	68 e7 7b 10 80       	push   $0x80107be7
80102054:	e8 27 e3 ff ff       	call   80100380 <panic>
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102060 <dirlink>:
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	57                   	push   %edi
80102064:	56                   	push   %esi
80102065:	53                   	push   %ebx
80102066:	83 ec 20             	sub    $0x20,%esp
80102069:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010206c:	6a 00                	push   $0x0
8010206e:	ff 75 0c             	push   0xc(%ebp)
80102071:	53                   	push   %ebx
80102072:	e8 e9 fc ff ff       	call   80101d60 <dirlookup>
80102077:	83 c4 10             	add    $0x10,%esp
8010207a:	85 c0                	test   %eax,%eax
8010207c:	75 67                	jne    801020e5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010207e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102081:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102084:	85 ff                	test   %edi,%edi
80102086:	74 29                	je     801020b1 <dirlink+0x51>
80102088:	31 ff                	xor    %edi,%edi
8010208a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010208d:	eb 09                	jmp    80102098 <dirlink+0x38>
8010208f:	90                   	nop
80102090:	83 c7 10             	add    $0x10,%edi
80102093:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102096:	73 19                	jae    801020b1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102098:	6a 10                	push   $0x10
8010209a:	57                   	push   %edi
8010209b:	56                   	push   %esi
8010209c:	53                   	push   %ebx
8010209d:	e8 6e fa ff ff       	call   80101b10 <readi>
801020a2:	83 c4 10             	add    $0x10,%esp
801020a5:	83 f8 10             	cmp    $0x10,%eax
801020a8:	75 4e                	jne    801020f8 <dirlink+0x98>
    if(de.inum == 0)
801020aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020af:	75 df                	jne    80102090 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801020b1:	83 ec 04             	sub    $0x4,%esp
801020b4:	8d 45 da             	lea    -0x26(%ebp),%eax
801020b7:	6a 0e                	push   $0xe
801020b9:	ff 75 0c             	push   0xc(%ebp)
801020bc:	50                   	push   %eax
801020bd:	e8 ee 2f 00 00       	call   801050b0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020c2:	6a 10                	push   $0x10
  de.inum = inum;
801020c4:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020c7:	57                   	push   %edi
801020c8:	56                   	push   %esi
801020c9:	53                   	push   %ebx
  de.inum = inum;
801020ca:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020ce:	e8 3d fb ff ff       	call   80101c10 <writei>
801020d3:	83 c4 20             	add    $0x20,%esp
801020d6:	83 f8 10             	cmp    $0x10,%eax
801020d9:	75 2a                	jne    80102105 <dirlink+0xa5>
  return 0;
801020db:	31 c0                	xor    %eax,%eax
}
801020dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e0:	5b                   	pop    %ebx
801020e1:	5e                   	pop    %esi
801020e2:	5f                   	pop    %edi
801020e3:	5d                   	pop    %ebp
801020e4:	c3                   	ret    
    iput(ip);
801020e5:	83 ec 0c             	sub    $0xc,%esp
801020e8:	50                   	push   %eax
801020e9:	e8 42 f8 ff ff       	call   80101930 <iput>
    return -1;
801020ee:	83 c4 10             	add    $0x10,%esp
801020f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020f6:	eb e5                	jmp    801020dd <dirlink+0x7d>
      panic("dirlink read");
801020f8:	83 ec 0c             	sub    $0xc,%esp
801020fb:	68 10 7c 10 80       	push   $0x80107c10
80102100:	e8 7b e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102105:	83 ec 0c             	sub    $0xc,%esp
80102108:	68 3e 83 10 80       	push   $0x8010833e
8010210d:	e8 6e e2 ff ff       	call   80100380 <panic>
80102112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102120 <namei>:

struct inode*
namei(char *path)
{
80102120:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102121:	31 d2                	xor    %edx,%edx
{
80102123:	89 e5                	mov    %esp,%ebp
80102125:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102128:	8b 45 08             	mov    0x8(%ebp),%eax
8010212b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010212e:	e8 dd fc ff ff       	call   80101e10 <namex>
}
80102133:	c9                   	leave  
80102134:	c3                   	ret    
80102135:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010213c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102140 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102140:	55                   	push   %ebp
  return namex(path, 1, name);
80102141:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102146:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102148:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010214b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010214e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010214f:	e9 bc fc ff ff       	jmp    80101e10 <namex>
80102154:	66 90                	xchg   %ax,%ax
80102156:	66 90                	xchg   %ax,%ax
80102158:	66 90                	xchg   %ax,%ax
8010215a:	66 90                	xchg   %ax,%ax
8010215c:	66 90                	xchg   %ax,%ax
8010215e:	66 90                	xchg   %ax,%ax

80102160 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	57                   	push   %edi
80102164:	56                   	push   %esi
80102165:	53                   	push   %ebx
80102166:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102169:	85 c0                	test   %eax,%eax
8010216b:	0f 84 b4 00 00 00    	je     80102225 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102171:	8b 70 08             	mov    0x8(%eax),%esi
80102174:	89 c3                	mov    %eax,%ebx
80102176:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010217c:	0f 87 96 00 00 00    	ja     80102218 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102182:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010218e:	66 90                	xchg   %ax,%ax
80102190:	89 ca                	mov    %ecx,%edx
80102192:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102193:	83 e0 c0             	and    $0xffffffc0,%eax
80102196:	3c 40                	cmp    $0x40,%al
80102198:	75 f6                	jne    80102190 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010219a:	31 ff                	xor    %edi,%edi
8010219c:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021a1:	89 f8                	mov    %edi,%eax
801021a3:	ee                   	out    %al,(%dx)
801021a4:	b8 01 00 00 00       	mov    $0x1,%eax
801021a9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021ae:	ee                   	out    %al,(%dx)
801021af:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021b4:	89 f0                	mov    %esi,%eax
801021b6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801021b7:	89 f0                	mov    %esi,%eax
801021b9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021be:	c1 f8 08             	sar    $0x8,%eax
801021c1:	ee                   	out    %al,(%dx)
801021c2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021c7:	89 f8                	mov    %edi,%eax
801021c9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021ca:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801021ce:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021d3:	c1 e0 04             	shl    $0x4,%eax
801021d6:	83 e0 10             	and    $0x10,%eax
801021d9:	83 c8 e0             	or     $0xffffffe0,%eax
801021dc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021dd:	f6 03 04             	testb  $0x4,(%ebx)
801021e0:	75 16                	jne    801021f8 <idestart+0x98>
801021e2:	b8 20 00 00 00       	mov    $0x20,%eax
801021e7:	89 ca                	mov    %ecx,%edx
801021e9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021ed:	5b                   	pop    %ebx
801021ee:	5e                   	pop    %esi
801021ef:	5f                   	pop    %edi
801021f0:	5d                   	pop    %ebp
801021f1:	c3                   	ret    
801021f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021f8:	b8 30 00 00 00       	mov    $0x30,%eax
801021fd:	89 ca                	mov    %ecx,%edx
801021ff:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102200:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102205:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102208:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010220d:	fc                   	cld    
8010220e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102210:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102213:	5b                   	pop    %ebx
80102214:	5e                   	pop    %esi
80102215:	5f                   	pop    %edi
80102216:	5d                   	pop    %ebp
80102217:	c3                   	ret    
    panic("incorrect blockno");
80102218:	83 ec 0c             	sub    $0xc,%esp
8010221b:	68 7c 7c 10 80       	push   $0x80107c7c
80102220:	e8 5b e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102225:	83 ec 0c             	sub    $0xc,%esp
80102228:	68 73 7c 10 80       	push   $0x80107c73
8010222d:	e8 4e e1 ff ff       	call   80100380 <panic>
80102232:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102240 <ideinit>:
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102246:	68 8e 7c 10 80       	push   $0x80107c8e
8010224b:	68 00 26 11 80       	push   $0x80112600
80102250:	e8 6b 2a 00 00       	call   80104cc0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102255:	58                   	pop    %eax
80102256:	a1 84 27 11 80       	mov    0x80112784,%eax
8010225b:	5a                   	pop    %edx
8010225c:	83 e8 01             	sub    $0x1,%eax
8010225f:	50                   	push   %eax
80102260:	6a 0e                	push   $0xe
80102262:	e8 99 02 00 00       	call   80102500 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102267:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010226a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010226f:	90                   	nop
80102270:	ec                   	in     (%dx),%al
80102271:	83 e0 c0             	and    $0xffffffc0,%eax
80102274:	3c 40                	cmp    $0x40,%al
80102276:	75 f8                	jne    80102270 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102278:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010227d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102282:	ee                   	out    %al,(%dx)
80102283:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102288:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010228d:	eb 06                	jmp    80102295 <ideinit+0x55>
8010228f:	90                   	nop
  for(i=0; i<1000; i++){
80102290:	83 e9 01             	sub    $0x1,%ecx
80102293:	74 0f                	je     801022a4 <ideinit+0x64>
80102295:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102296:	84 c0                	test   %al,%al
80102298:	74 f6                	je     80102290 <ideinit+0x50>
      havedisk1 = 1;
8010229a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
801022a1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022a4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801022a9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022ae:	ee                   	out    %al,(%dx)
}
801022af:	c9                   	leave  
801022b0:	c3                   	ret    
801022b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022bf:	90                   	nop

801022c0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	57                   	push   %edi
801022c4:	56                   	push   %esi
801022c5:	53                   	push   %ebx
801022c6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022c9:	68 00 26 11 80       	push   $0x80112600
801022ce:	e8 bd 2b 00 00       	call   80104e90 <acquire>

  if((b = idequeue) == 0){
801022d3:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
801022d9:	83 c4 10             	add    $0x10,%esp
801022dc:	85 db                	test   %ebx,%ebx
801022de:	74 63                	je     80102343 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022e0:	8b 43 58             	mov    0x58(%ebx),%eax
801022e3:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022e8:	8b 33                	mov    (%ebx),%esi
801022ea:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022f0:	75 2f                	jne    80102321 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022f2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022fe:	66 90                	xchg   %ax,%ax
80102300:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102301:	89 c1                	mov    %eax,%ecx
80102303:	83 e1 c0             	and    $0xffffffc0,%ecx
80102306:	80 f9 40             	cmp    $0x40,%cl
80102309:	75 f5                	jne    80102300 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010230b:	a8 21                	test   $0x21,%al
8010230d:	75 12                	jne    80102321 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010230f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102312:	b9 80 00 00 00       	mov    $0x80,%ecx
80102317:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010231c:	fc                   	cld    
8010231d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010231f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102321:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102324:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102327:	83 ce 02             	or     $0x2,%esi
8010232a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010232c:	53                   	push   %ebx
8010232d:	e8 0e 21 00 00       	call   80104440 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102332:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80102337:	83 c4 10             	add    $0x10,%esp
8010233a:	85 c0                	test   %eax,%eax
8010233c:	74 05                	je     80102343 <ideintr+0x83>
    idestart(idequeue);
8010233e:	e8 1d fe ff ff       	call   80102160 <idestart>
    release(&idelock);
80102343:	83 ec 0c             	sub    $0xc,%esp
80102346:	68 00 26 11 80       	push   $0x80112600
8010234b:	e8 e0 2a 00 00       	call   80104e30 <release>

  release(&idelock);
}
80102350:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102353:	5b                   	pop    %ebx
80102354:	5e                   	pop    %esi
80102355:	5f                   	pop    %edi
80102356:	5d                   	pop    %ebp
80102357:	c3                   	ret    
80102358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010235f:	90                   	nop

80102360 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	53                   	push   %ebx
80102364:	83 ec 10             	sub    $0x10,%esp
80102367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010236a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010236d:	50                   	push   %eax
8010236e:	e8 fd 28 00 00       	call   80104c70 <holdingsleep>
80102373:	83 c4 10             	add    $0x10,%esp
80102376:	85 c0                	test   %eax,%eax
80102378:	0f 84 c3 00 00 00    	je     80102441 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010237e:	8b 03                	mov    (%ebx),%eax
80102380:	83 e0 06             	and    $0x6,%eax
80102383:	83 f8 02             	cmp    $0x2,%eax
80102386:	0f 84 a8 00 00 00    	je     80102434 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010238c:	8b 53 04             	mov    0x4(%ebx),%edx
8010238f:	85 d2                	test   %edx,%edx
80102391:	74 0d                	je     801023a0 <iderw+0x40>
80102393:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102398:	85 c0                	test   %eax,%eax
8010239a:	0f 84 87 00 00 00    	je     80102427 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023a0:	83 ec 0c             	sub    $0xc,%esp
801023a3:	68 00 26 11 80       	push   $0x80112600
801023a8:	e8 e3 2a 00 00       	call   80104e90 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023ad:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
801023b2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023b9:	83 c4 10             	add    $0x10,%esp
801023bc:	85 c0                	test   %eax,%eax
801023be:	74 60                	je     80102420 <iderw+0xc0>
801023c0:	89 c2                	mov    %eax,%edx
801023c2:	8b 40 58             	mov    0x58(%eax),%eax
801023c5:	85 c0                	test   %eax,%eax
801023c7:	75 f7                	jne    801023c0 <iderw+0x60>
801023c9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023cc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023ce:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
801023d4:	74 3a                	je     80102410 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023d6:	8b 03                	mov    (%ebx),%eax
801023d8:	83 e0 06             	and    $0x6,%eax
801023db:	83 f8 02             	cmp    $0x2,%eax
801023de:	74 1b                	je     801023fb <iderw+0x9b>
    sleep(b, &idelock);
801023e0:	83 ec 08             	sub    $0x8,%esp
801023e3:	68 00 26 11 80       	push   $0x80112600
801023e8:	53                   	push   %ebx
801023e9:	e8 c2 1d 00 00       	call   801041b0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023ee:	8b 03                	mov    (%ebx),%eax
801023f0:	83 c4 10             	add    $0x10,%esp
801023f3:	83 e0 06             	and    $0x6,%eax
801023f6:	83 f8 02             	cmp    $0x2,%eax
801023f9:	75 e5                	jne    801023e0 <iderw+0x80>
  }


  release(&idelock);
801023fb:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102402:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102405:	c9                   	leave  
  release(&idelock);
80102406:	e9 25 2a 00 00       	jmp    80104e30 <release>
8010240b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010240f:	90                   	nop
    idestart(b);
80102410:	89 d8                	mov    %ebx,%eax
80102412:	e8 49 fd ff ff       	call   80102160 <idestart>
80102417:	eb bd                	jmp    801023d6 <iderw+0x76>
80102419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102420:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102425:	eb a5                	jmp    801023cc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102427:	83 ec 0c             	sub    $0xc,%esp
8010242a:	68 bd 7c 10 80       	push   $0x80107cbd
8010242f:	e8 4c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102434:	83 ec 0c             	sub    $0xc,%esp
80102437:	68 a8 7c 10 80       	push   $0x80107ca8
8010243c:	e8 3f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102441:	83 ec 0c             	sub    $0xc,%esp
80102444:	68 92 7c 10 80       	push   $0x80107c92
80102449:	e8 32 df ff ff       	call   80100380 <panic>
8010244e:	66 90                	xchg   %ax,%ax

80102450 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102450:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102451:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102458:	00 c0 fe 
{
8010245b:	89 e5                	mov    %esp,%ebp
8010245d:	56                   	push   %esi
8010245e:	53                   	push   %ebx
  ioapic->reg = reg;
8010245f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102466:	00 00 00 
  return ioapic->data;
80102469:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010246f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102472:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102478:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010247e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102485:	c1 ee 10             	shr    $0x10,%esi
80102488:	89 f0                	mov    %esi,%eax
8010248a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010248d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102490:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102493:	39 c2                	cmp    %eax,%edx
80102495:	74 16                	je     801024ad <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102497:	83 ec 0c             	sub    $0xc,%esp
8010249a:	68 dc 7c 10 80       	push   $0x80107cdc
8010249f:	e8 fc e1 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
801024a4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801024aa:	83 c4 10             	add    $0x10,%esp
801024ad:	83 c6 21             	add    $0x21,%esi
{
801024b0:	ba 10 00 00 00       	mov    $0x10,%edx
801024b5:	b8 20 00 00 00       	mov    $0x20,%eax
801024ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
801024c0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801024c2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801024c4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
801024ca:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801024cd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801024d3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801024d6:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
801024d9:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801024dc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801024de:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801024e4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801024eb:	39 f0                	cmp    %esi,%eax
801024ed:	75 d1                	jne    801024c0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024f2:	5b                   	pop    %ebx
801024f3:	5e                   	pop    %esi
801024f4:	5d                   	pop    %ebp
801024f5:	c3                   	ret    
801024f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024fd:	8d 76 00             	lea    0x0(%esi),%esi

80102500 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102500:	55                   	push   %ebp
  ioapic->reg = reg;
80102501:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102507:	89 e5                	mov    %esp,%ebp
80102509:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010250c:	8d 50 20             	lea    0x20(%eax),%edx
8010250f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102513:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102515:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010251b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010251e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102521:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102524:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102526:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010252b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010252e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102531:	5d                   	pop    %ebp
80102532:	c3                   	ret    
80102533:	66 90                	xchg   %ax,%ax
80102535:	66 90                	xchg   %ax,%ax
80102537:	66 90                	xchg   %ax,%ax
80102539:	66 90                	xchg   %ax,%ax
8010253b:	66 90                	xchg   %ax,%ax
8010253d:	66 90                	xchg   %ax,%ax
8010253f:	90                   	nop

80102540 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	53                   	push   %ebx
80102544:	83 ec 04             	sub    $0x4,%esp
80102547:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010254a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102550:	75 76                	jne    801025c8 <kfree+0x88>
80102552:	81 fb d0 62 13 80    	cmp    $0x801362d0,%ebx
80102558:	72 6e                	jb     801025c8 <kfree+0x88>
8010255a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102560:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102565:	77 61                	ja     801025c8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102567:	83 ec 04             	sub    $0x4,%esp
8010256a:	68 00 10 00 00       	push   $0x1000
8010256f:	6a 01                	push   $0x1
80102571:	53                   	push   %ebx
80102572:	e8 d9 29 00 00       	call   80104f50 <memset>

  if(kmem.use_lock)
80102577:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	85 d2                	test   %edx,%edx
80102582:	75 1c                	jne    801025a0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102584:	a1 78 26 11 80       	mov    0x80112678,%eax
80102589:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010258b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102590:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102596:	85 c0                	test   %eax,%eax
80102598:	75 1e                	jne    801025b8 <kfree+0x78>
    release(&kmem.lock);
}
8010259a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010259d:	c9                   	leave  
8010259e:	c3                   	ret    
8010259f:	90                   	nop
    acquire(&kmem.lock);
801025a0:	83 ec 0c             	sub    $0xc,%esp
801025a3:	68 40 26 11 80       	push   $0x80112640
801025a8:	e8 e3 28 00 00       	call   80104e90 <acquire>
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	eb d2                	jmp    80102584 <kfree+0x44>
801025b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801025b8:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801025bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025c2:	c9                   	leave  
    release(&kmem.lock);
801025c3:	e9 68 28 00 00       	jmp    80104e30 <release>
    panic("kfree");
801025c8:	83 ec 0c             	sub    $0xc,%esp
801025cb:	68 0e 7d 10 80       	push   $0x80107d0e
801025d0:	e8 ab dd ff ff       	call   80100380 <panic>
801025d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025e0 <freerange>:
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025e4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025e7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ea:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025fd:	39 de                	cmp    %ebx,%esi
801025ff:	72 23                	jb     80102624 <freerange+0x44>
80102601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 23 ff ff ff       	call   80102540 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 f3                	cmp    %esi,%ebx
80102622:	76 e4                	jbe    80102608 <freerange+0x28>
}
80102624:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102627:	5b                   	pop    %ebx
80102628:	5e                   	pop    %esi
80102629:	5d                   	pop    %ebp
8010262a:	c3                   	ret    
8010262b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010262f:	90                   	nop

80102630 <kinit2>:
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102634:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102637:	8b 75 0c             	mov    0xc(%ebp),%esi
8010263a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010263b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102641:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102647:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264d:	39 de                	cmp    %ebx,%esi
8010264f:	72 23                	jb     80102674 <kinit2+0x44>
80102651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102658:	83 ec 0c             	sub    $0xc,%esp
8010265b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102661:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102667:	50                   	push   %eax
80102668:	e8 d3 fe ff ff       	call   80102540 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010266d:	83 c4 10             	add    $0x10,%esp
80102670:	39 de                	cmp    %ebx,%esi
80102672:	73 e4                	jae    80102658 <kinit2+0x28>
  kmem.use_lock = 1;
80102674:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010267b:	00 00 00 
}
8010267e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102681:	5b                   	pop    %ebx
80102682:	5e                   	pop    %esi
80102683:	5d                   	pop    %ebp
80102684:	c3                   	ret    
80102685:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102690 <kinit1>:
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	56                   	push   %esi
80102694:	53                   	push   %ebx
80102695:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102698:	83 ec 08             	sub    $0x8,%esp
8010269b:	68 14 7d 10 80       	push   $0x80107d14
801026a0:	68 40 26 11 80       	push   $0x80112640
801026a5:	e8 16 26 00 00       	call   80104cc0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801026aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ad:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801026b0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801026b7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026ba:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026cc:	39 de                	cmp    %ebx,%esi
801026ce:	72 1c                	jb     801026ec <kinit1+0x5c>
    kfree(p);
801026d0:	83 ec 0c             	sub    $0xc,%esp
801026d3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026df:	50                   	push   %eax
801026e0:	e8 5b fe ff ff       	call   80102540 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e5:	83 c4 10             	add    $0x10,%esp
801026e8:	39 de                	cmp    %ebx,%esi
801026ea:	73 e4                	jae    801026d0 <kinit1+0x40>
}
801026ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026ef:	5b                   	pop    %ebx
801026f0:	5e                   	pop    %esi
801026f1:	5d                   	pop    %ebp
801026f2:	c3                   	ret    
801026f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102700 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102700:	a1 74 26 11 80       	mov    0x80112674,%eax
80102705:	85 c0                	test   %eax,%eax
80102707:	75 1f                	jne    80102728 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102709:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010270e:	85 c0                	test   %eax,%eax
80102710:	74 0e                	je     80102720 <kalloc+0x20>
    kmem.freelist = r->next;
80102712:	8b 10                	mov    (%eax),%edx
80102714:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010271a:	c3                   	ret    
8010271b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010271f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102720:	c3                   	ret    
80102721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102728:	55                   	push   %ebp
80102729:	89 e5                	mov    %esp,%ebp
8010272b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010272e:	68 40 26 11 80       	push   $0x80112640
80102733:	e8 58 27 00 00       	call   80104e90 <acquire>
  r = kmem.freelist;
80102738:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
8010273d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
80102743:	83 c4 10             	add    $0x10,%esp
80102746:	85 c0                	test   %eax,%eax
80102748:	74 08                	je     80102752 <kalloc+0x52>
    kmem.freelist = r->next;
8010274a:	8b 08                	mov    (%eax),%ecx
8010274c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102752:	85 d2                	test   %edx,%edx
80102754:	74 16                	je     8010276c <kalloc+0x6c>
    release(&kmem.lock);
80102756:	83 ec 0c             	sub    $0xc,%esp
80102759:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010275c:	68 40 26 11 80       	push   $0x80112640
80102761:	e8 ca 26 00 00       	call   80104e30 <release>
  return (char*)r;
80102766:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102769:	83 c4 10             	add    $0x10,%esp
}
8010276c:	c9                   	leave  
8010276d:	c3                   	ret    
8010276e:	66 90                	xchg   %ax,%ax

80102770 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102770:	ba 64 00 00 00       	mov    $0x64,%edx
80102775:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102776:	a8 01                	test   $0x1,%al
80102778:	0f 84 c2 00 00 00    	je     80102840 <kbdgetc+0xd0>
{
8010277e:	55                   	push   %ebp
8010277f:	ba 60 00 00 00       	mov    $0x60,%edx
80102784:	89 e5                	mov    %esp,%ebp
80102786:	53                   	push   %ebx
80102787:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102788:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010278e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102791:	3c e0                	cmp    $0xe0,%al
80102793:	74 5b                	je     801027f0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102795:	89 da                	mov    %ebx,%edx
80102797:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010279a:	84 c0                	test   %al,%al
8010279c:	78 62                	js     80102800 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010279e:	85 d2                	test   %edx,%edx
801027a0:	74 09                	je     801027ab <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027a2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801027a5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801027a8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801027ab:	0f b6 91 40 7e 10 80 	movzbl -0x7fef81c0(%ecx),%edx
  shift ^= togglecode[data];
801027b2:	0f b6 81 40 7d 10 80 	movzbl -0x7fef82c0(%ecx),%eax
  shift |= shiftcode[data];
801027b9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801027bb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027bd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801027bf:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
801027c5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027c8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027cb:	8b 04 85 20 7d 10 80 	mov    -0x7fef82e0(,%eax,4),%eax
801027d2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801027d6:	74 0b                	je     801027e3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801027d8:	8d 50 9f             	lea    -0x61(%eax),%edx
801027db:	83 fa 19             	cmp    $0x19,%edx
801027de:	77 48                	ja     80102828 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027e0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027e6:	c9                   	leave  
801027e7:	c3                   	ret    
801027e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ef:	90                   	nop
    shift |= E0ESC;
801027f0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801027f3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027f5:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
801027fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027fe:	c9                   	leave  
801027ff:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102800:	83 e0 7f             	and    $0x7f,%eax
80102803:	85 d2                	test   %edx,%edx
80102805:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102808:	0f b6 81 40 7e 10 80 	movzbl -0x7fef81c0(%ecx),%eax
8010280f:	83 c8 40             	or     $0x40,%eax
80102812:	0f b6 c0             	movzbl %al,%eax
80102815:	f7 d0                	not    %eax
80102817:	21 d8                	and    %ebx,%eax
}
80102819:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010281c:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
80102821:	31 c0                	xor    %eax,%eax
}
80102823:	c9                   	leave  
80102824:	c3                   	ret    
80102825:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102828:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010282b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010282e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102831:	c9                   	leave  
      c += 'a' - 'A';
80102832:	83 f9 1a             	cmp    $0x1a,%ecx
80102835:	0f 42 c2             	cmovb  %edx,%eax
}
80102838:	c3                   	ret    
80102839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102840:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102845:	c3                   	ret    
80102846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010284d:	8d 76 00             	lea    0x0(%esi),%esi

80102850 <kbdintr>:

void
kbdintr(void)
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
80102853:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102856:	68 70 27 10 80       	push   $0x80102770
8010285b:	e8 20 e0 ff ff       	call   80100880 <consoleintr>
}
80102860:	83 c4 10             	add    $0x10,%esp
80102863:	c9                   	leave  
80102864:	c3                   	ret    
80102865:	66 90                	xchg   %ax,%ax
80102867:	66 90                	xchg   %ax,%ax
80102869:	66 90                	xchg   %ax,%ax
8010286b:	66 90                	xchg   %ax,%ax
8010286d:	66 90                	xchg   %ax,%ax
8010286f:	90                   	nop

80102870 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102870:	a1 80 26 11 80       	mov    0x80112680,%eax
80102875:	85 c0                	test   %eax,%eax
80102877:	0f 84 cb 00 00 00    	je     80102948 <lapicinit+0xd8>
  lapic[index] = value;
8010287d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102884:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102887:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102891:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102894:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102897:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010289e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801028a1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801028ab:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801028ae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028b8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028be:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028c5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028c8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028cb:	8b 50 30             	mov    0x30(%eax),%edx
801028ce:	c1 ea 10             	shr    $0x10,%edx
801028d1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801028d7:	75 77                	jne    80102950 <lapicinit+0xe0>
  lapic[index] = value;
801028d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028ed:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028fd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102900:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102907:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010290a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010290d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102914:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102917:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010291a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102921:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102924:	8b 50 20             	mov    0x20(%eax),%edx
80102927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102930:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102936:	80 e6 10             	and    $0x10,%dh
80102939:	75 f5                	jne    80102930 <lapicinit+0xc0>
  lapic[index] = value;
8010293b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102942:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102945:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102948:	c3                   	ret    
80102949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102950:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102957:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010295a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010295d:	e9 77 ff ff ff       	jmp    801028d9 <lapicinit+0x69>
80102962:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102970 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102970:	a1 80 26 11 80       	mov    0x80112680,%eax
80102975:	85 c0                	test   %eax,%eax
80102977:	74 07                	je     80102980 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102979:	8b 40 20             	mov    0x20(%eax),%eax
8010297c:	c1 e8 18             	shr    $0x18,%eax
8010297f:	c3                   	ret    
    return 0;
80102980:	31 c0                	xor    %eax,%eax
}
80102982:	c3                   	ret    
80102983:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102990 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102990:	a1 80 26 11 80       	mov    0x80112680,%eax
80102995:	85 c0                	test   %eax,%eax
80102997:	74 0d                	je     801029a6 <lapiceoi+0x16>
  lapic[index] = value;
80102999:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801029a6:	c3                   	ret    
801029a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ae:	66 90                	xchg   %ax,%ax

801029b0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801029b0:	c3                   	ret    
801029b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029bf:	90                   	nop

801029c0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029c6:	ba 70 00 00 00       	mov    $0x70,%edx
801029cb:	89 e5                	mov    %esp,%ebp
801029cd:	53                   	push   %ebx
801029ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029d4:	ee                   	out    %al,(%dx)
801029d5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029da:	ba 71 00 00 00       	mov    $0x71,%edx
801029df:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029e0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801029e2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029e5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029eb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029ed:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801029f0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801029f2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801029f5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029f8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029fe:	a1 80 26 11 80       	mov    0x80112680,%eax
80102a03:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a09:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a0c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a13:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a16:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a19:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a20:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a23:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a26:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a2c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a2f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a35:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a38:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a3e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a41:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a47:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a4d:	c9                   	leave  
80102a4e:	c3                   	ret    
80102a4f:	90                   	nop

80102a50 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a50:	55                   	push   %ebp
80102a51:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a56:	ba 70 00 00 00       	mov    $0x70,%edx
80102a5b:	89 e5                	mov    %esp,%ebp
80102a5d:	57                   	push   %edi
80102a5e:	56                   	push   %esi
80102a5f:	53                   	push   %ebx
80102a60:	83 ec 4c             	sub    $0x4c,%esp
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	ba 71 00 00 00       	mov    $0x71,%edx
80102a69:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a6a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a72:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a75:	8d 76 00             	lea    0x0(%esi),%esi
80102a78:	31 c0                	xor    %eax,%eax
80102a7a:	89 da                	mov    %ebx,%edx
80102a7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a82:	89 ca                	mov    %ecx,%edx
80102a84:	ec                   	in     (%dx),%al
80102a85:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a88:	89 da                	mov    %ebx,%edx
80102a8a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a8f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a90:	89 ca                	mov    %ecx,%edx
80102a92:	ec                   	in     (%dx),%al
80102a93:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a96:	89 da                	mov    %ebx,%edx
80102a98:	b8 04 00 00 00       	mov    $0x4,%eax
80102a9d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9e:	89 ca                	mov    %ecx,%edx
80102aa0:	ec                   	in     (%dx),%al
80102aa1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa4:	89 da                	mov    %ebx,%edx
80102aa6:	b8 07 00 00 00       	mov    $0x7,%eax
80102aab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aac:	89 ca                	mov    %ecx,%edx
80102aae:	ec                   	in     (%dx),%al
80102aaf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab2:	89 da                	mov    %ebx,%edx
80102ab4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ab9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aba:	89 ca                	mov    %ecx,%edx
80102abc:	ec                   	in     (%dx),%al
80102abd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102abf:	89 da                	mov    %ebx,%edx
80102ac1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ac6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac7:	89 ca                	mov    %ecx,%edx
80102ac9:	ec                   	in     (%dx),%al
80102aca:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102acc:	89 da                	mov    %ebx,%edx
80102ace:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ad3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad4:	89 ca                	mov    %ecx,%edx
80102ad6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ad7:	84 c0                	test   %al,%al
80102ad9:	78 9d                	js     80102a78 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102adb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102adf:	89 fa                	mov    %edi,%edx
80102ae1:	0f b6 fa             	movzbl %dl,%edi
80102ae4:	89 f2                	mov    %esi,%edx
80102ae6:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ae9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102aed:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af0:	89 da                	mov    %ebx,%edx
80102af2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102af5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102af8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102afc:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102aff:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b02:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b06:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b09:	31 c0                	xor    %eax,%eax
80102b0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0c:	89 ca                	mov    %ecx,%edx
80102b0e:	ec                   	in     (%dx),%al
80102b0f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b12:	89 da                	mov    %ebx,%edx
80102b14:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b17:	b8 02 00 00 00       	mov    $0x2,%eax
80102b1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1d:	89 ca                	mov    %ecx,%edx
80102b1f:	ec                   	in     (%dx),%al
80102b20:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b23:	89 da                	mov    %ebx,%edx
80102b25:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b28:	b8 04 00 00 00       	mov    $0x4,%eax
80102b2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2e:	89 ca                	mov    %ecx,%edx
80102b30:	ec                   	in     (%dx),%al
80102b31:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b34:	89 da                	mov    %ebx,%edx
80102b36:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b39:	b8 07 00 00 00       	mov    $0x7,%eax
80102b3e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3f:	89 ca                	mov    %ecx,%edx
80102b41:	ec                   	in     (%dx),%al
80102b42:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b45:	89 da                	mov    %ebx,%edx
80102b47:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b4a:	b8 08 00 00 00       	mov    $0x8,%eax
80102b4f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b50:	89 ca                	mov    %ecx,%edx
80102b52:	ec                   	in     (%dx),%al
80102b53:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b56:	89 da                	mov    %ebx,%edx
80102b58:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b5b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b60:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b61:	89 ca                	mov    %ecx,%edx
80102b63:	ec                   	in     (%dx),%al
80102b64:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b67:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b6d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b70:	6a 18                	push   $0x18
80102b72:	50                   	push   %eax
80102b73:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b76:	50                   	push   %eax
80102b77:	e8 24 24 00 00       	call   80104fa0 <memcmp>
80102b7c:	83 c4 10             	add    $0x10,%esp
80102b7f:	85 c0                	test   %eax,%eax
80102b81:	0f 85 f1 fe ff ff    	jne    80102a78 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b87:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b8b:	75 78                	jne    80102c05 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b8d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b90:	89 c2                	mov    %eax,%edx
80102b92:	83 e0 0f             	and    $0xf,%eax
80102b95:	c1 ea 04             	shr    $0x4,%edx
80102b98:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b9b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b9e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ba1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ba4:	89 c2                	mov    %eax,%edx
80102ba6:	83 e0 0f             	and    $0xf,%eax
80102ba9:	c1 ea 04             	shr    $0x4,%edx
80102bac:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102baf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bb2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102bb5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bb8:	89 c2                	mov    %eax,%edx
80102bba:	83 e0 0f             	and    $0xf,%eax
80102bbd:	c1 ea 04             	shr    $0x4,%edx
80102bc0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bc3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bc6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102bc9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bcc:	89 c2                	mov    %eax,%edx
80102bce:	83 e0 0f             	and    $0xf,%eax
80102bd1:	c1 ea 04             	shr    $0x4,%edx
80102bd4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bd7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bda:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bdd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102be0:	89 c2                	mov    %eax,%edx
80102be2:	83 e0 0f             	and    $0xf,%eax
80102be5:	c1 ea 04             	shr    $0x4,%edx
80102be8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102beb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bee:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102bf1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bf4:	89 c2                	mov    %eax,%edx
80102bf6:	83 e0 0f             	and    $0xf,%eax
80102bf9:	c1 ea 04             	shr    $0x4,%edx
80102bfc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c02:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c05:	8b 75 08             	mov    0x8(%ebp),%esi
80102c08:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c0b:	89 06                	mov    %eax,(%esi)
80102c0d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c10:	89 46 04             	mov    %eax,0x4(%esi)
80102c13:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c16:	89 46 08             	mov    %eax,0x8(%esi)
80102c19:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c1c:	89 46 0c             	mov    %eax,0xc(%esi)
80102c1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c22:	89 46 10             	mov    %eax,0x10(%esi)
80102c25:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c28:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c2b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c35:	5b                   	pop    %ebx
80102c36:	5e                   	pop    %esi
80102c37:	5f                   	pop    %edi
80102c38:	5d                   	pop    %ebp
80102c39:	c3                   	ret    
80102c3a:	66 90                	xchg   %ax,%ax
80102c3c:	66 90                	xchg   %ax,%ax
80102c3e:	66 90                	xchg   %ax,%ax

80102c40 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c40:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102c46:	85 c9                	test   %ecx,%ecx
80102c48:	0f 8e 8a 00 00 00    	jle    80102cd8 <install_trans+0x98>
{
80102c4e:	55                   	push   %ebp
80102c4f:	89 e5                	mov    %esp,%ebp
80102c51:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c52:	31 ff                	xor    %edi,%edi
{
80102c54:	56                   	push   %esi
80102c55:	53                   	push   %ebx
80102c56:	83 ec 0c             	sub    $0xc,%esp
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c60:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c65:	83 ec 08             	sub    $0x8,%esp
80102c68:	01 f8                	add    %edi,%eax
80102c6a:	83 c0 01             	add    $0x1,%eax
80102c6d:	50                   	push   %eax
80102c6e:	ff 35 e4 26 11 80    	push   0x801126e4
80102c74:	e8 57 d4 ff ff       	call   801000d0 <bread>
80102c79:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c7b:	58                   	pop    %eax
80102c7c:	5a                   	pop    %edx
80102c7d:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c84:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c8a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c8d:	e8 3e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c92:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c95:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c97:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c9a:	68 00 02 00 00       	push   $0x200
80102c9f:	50                   	push   %eax
80102ca0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102ca3:	50                   	push   %eax
80102ca4:	e8 47 23 00 00       	call   80104ff0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ca9:	89 1c 24             	mov    %ebx,(%esp)
80102cac:	e8 ff d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102cb1:	89 34 24             	mov    %esi,(%esp)
80102cb4:	e8 37 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102cb9:	89 1c 24             	mov    %ebx,(%esp)
80102cbc:	e8 2f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cc1:	83 c4 10             	add    $0x10,%esp
80102cc4:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102cca:	7f 94                	jg     80102c60 <install_trans+0x20>
  }
}
80102ccc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ccf:	5b                   	pop    %ebx
80102cd0:	5e                   	pop    %esi
80102cd1:	5f                   	pop    %edi
80102cd2:	5d                   	pop    %ebp
80102cd3:	c3                   	ret    
80102cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cd8:	c3                   	ret    
80102cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ce0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ce0:	55                   	push   %ebp
80102ce1:	89 e5                	mov    %esp,%ebp
80102ce3:	53                   	push   %ebx
80102ce4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ce7:	ff 35 d4 26 11 80    	push   0x801126d4
80102ced:	ff 35 e4 26 11 80    	push   0x801126e4
80102cf3:	e8 d8 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102cf8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cfb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102cfd:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102d02:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d05:	85 c0                	test   %eax,%eax
80102d07:	7e 19                	jle    80102d22 <write_head+0x42>
80102d09:	31 d2                	xor    %edx,%edx
80102d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d0f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102d10:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102d17:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d1b:	83 c2 01             	add    $0x1,%edx
80102d1e:	39 d0                	cmp    %edx,%eax
80102d20:	75 ee                	jne    80102d10 <write_head+0x30>
  }
  bwrite(buf);
80102d22:	83 ec 0c             	sub    $0xc,%esp
80102d25:	53                   	push   %ebx
80102d26:	e8 85 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d2b:	89 1c 24             	mov    %ebx,(%esp)
80102d2e:	e8 bd d4 ff ff       	call   801001f0 <brelse>
}
80102d33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d36:	83 c4 10             	add    $0x10,%esp
80102d39:	c9                   	leave  
80102d3a:	c3                   	ret    
80102d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d3f:	90                   	nop

80102d40 <initlog>:
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	53                   	push   %ebx
80102d44:	83 ec 2c             	sub    $0x2c,%esp
80102d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d4a:	68 40 7f 10 80       	push   $0x80107f40
80102d4f:	68 a0 26 11 80       	push   $0x801126a0
80102d54:	e8 67 1f 00 00       	call   80104cc0 <initlock>
  readsb(dev, &sb);
80102d59:	58                   	pop    %eax
80102d5a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d5d:	5a                   	pop    %edx
80102d5e:	50                   	push   %eax
80102d5f:	53                   	push   %ebx
80102d60:	e8 3b e8 ff ff       	call   801015a0 <readsb>
  log.start = sb.logstart;
80102d65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d68:	59                   	pop    %ecx
  log.dev = dev;
80102d69:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102d6f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d72:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102d77:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102d7d:	5a                   	pop    %edx
80102d7e:	50                   	push   %eax
80102d7f:	53                   	push   %ebx
80102d80:	e8 4b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d85:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d88:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d8b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d91:	85 db                	test   %ebx,%ebx
80102d93:	7e 1d                	jle    80102db2 <initlog+0x72>
80102d95:	31 d2                	xor    %edx,%edx
80102d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d9e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102da0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102da4:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102dab:	83 c2 01             	add    $0x1,%edx
80102dae:	39 d3                	cmp    %edx,%ebx
80102db0:	75 ee                	jne    80102da0 <initlog+0x60>
  brelse(buf);
80102db2:	83 ec 0c             	sub    $0xc,%esp
80102db5:	50                   	push   %eax
80102db6:	e8 35 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102dbb:	e8 80 fe ff ff       	call   80102c40 <install_trans>
  log.lh.n = 0;
80102dc0:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102dc7:	00 00 00 
  write_head(); // clear the log
80102dca:	e8 11 ff ff ff       	call   80102ce0 <write_head>
}
80102dcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dd2:	83 c4 10             	add    $0x10,%esp
80102dd5:	c9                   	leave  
80102dd6:	c3                   	ret    
80102dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dde:	66 90                	xchg   %ax,%ax

80102de0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102de6:	68 a0 26 11 80       	push   $0x801126a0
80102deb:	e8 a0 20 00 00       	call   80104e90 <acquire>
80102df0:	83 c4 10             	add    $0x10,%esp
80102df3:	eb 18                	jmp    80102e0d <begin_op+0x2d>
80102df5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102df8:	83 ec 08             	sub    $0x8,%esp
80102dfb:	68 a0 26 11 80       	push   $0x801126a0
80102e00:	68 a0 26 11 80       	push   $0x801126a0
80102e05:	e8 a6 13 00 00       	call   801041b0 <sleep>
80102e0a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e0d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102e12:	85 c0                	test   %eax,%eax
80102e14:	75 e2                	jne    80102df8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e16:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102e1b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102e21:	83 c0 01             	add    $0x1,%eax
80102e24:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e27:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e2a:	83 fa 1e             	cmp    $0x1e,%edx
80102e2d:	7f c9                	jg     80102df8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e2f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e32:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102e37:	68 a0 26 11 80       	push   $0x801126a0
80102e3c:	e8 ef 1f 00 00       	call   80104e30 <release>
      break;
    }
  }
}
80102e41:	83 c4 10             	add    $0x10,%esp
80102e44:	c9                   	leave  
80102e45:	c3                   	ret    
80102e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e4d:	8d 76 00             	lea    0x0(%esi),%esi

80102e50 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	57                   	push   %edi
80102e54:	56                   	push   %esi
80102e55:	53                   	push   %ebx
80102e56:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e59:	68 a0 26 11 80       	push   $0x801126a0
80102e5e:	e8 2d 20 00 00       	call   80104e90 <acquire>
  log.outstanding -= 1;
80102e63:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102e68:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102e6e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e71:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e74:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102e7a:	85 f6                	test   %esi,%esi
80102e7c:	0f 85 22 01 00 00    	jne    80102fa4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e82:	85 db                	test   %ebx,%ebx
80102e84:	0f 85 f6 00 00 00    	jne    80102f80 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e8a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e91:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e94:	83 ec 0c             	sub    $0xc,%esp
80102e97:	68 a0 26 11 80       	push   $0x801126a0
80102e9c:	e8 8f 1f 00 00       	call   80104e30 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ea1:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102ea7:	83 c4 10             	add    $0x10,%esp
80102eaa:	85 c9                	test   %ecx,%ecx
80102eac:	7f 42                	jg     80102ef0 <end_op+0xa0>
    acquire(&log.lock);
80102eae:	83 ec 0c             	sub    $0xc,%esp
80102eb1:	68 a0 26 11 80       	push   $0x801126a0
80102eb6:	e8 d5 1f 00 00       	call   80104e90 <acquire>
    wakeup(&log);
80102ebb:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102ec2:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102ec9:	00 00 00 
    wakeup(&log);
80102ecc:	e8 6f 15 00 00       	call   80104440 <wakeup>
    release(&log.lock);
80102ed1:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102ed8:	e8 53 1f 00 00       	call   80104e30 <release>
80102edd:	83 c4 10             	add    $0x10,%esp
}
80102ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ee3:	5b                   	pop    %ebx
80102ee4:	5e                   	pop    %esi
80102ee5:	5f                   	pop    %edi
80102ee6:	5d                   	pop    %ebp
80102ee7:	c3                   	ret    
80102ee8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eef:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ef0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102ef5:	83 ec 08             	sub    $0x8,%esp
80102ef8:	01 d8                	add    %ebx,%eax
80102efa:	83 c0 01             	add    $0x1,%eax
80102efd:	50                   	push   %eax
80102efe:	ff 35 e4 26 11 80    	push   0x801126e4
80102f04:	e8 c7 d1 ff ff       	call   801000d0 <bread>
80102f09:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f0b:	58                   	pop    %eax
80102f0c:	5a                   	pop    %edx
80102f0d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102f14:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f1a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f1d:	e8 ae d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f22:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f25:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f27:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f2a:	68 00 02 00 00       	push   $0x200
80102f2f:	50                   	push   %eax
80102f30:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f33:	50                   	push   %eax
80102f34:	e8 b7 20 00 00       	call   80104ff0 <memmove>
    bwrite(to);  // write the log
80102f39:	89 34 24             	mov    %esi,(%esp)
80102f3c:	e8 6f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f41:	89 3c 24             	mov    %edi,(%esp)
80102f44:	e8 a7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f49:	89 34 24             	mov    %esi,(%esp)
80102f4c:	e8 9f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f51:	83 c4 10             	add    $0x10,%esp
80102f54:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102f5a:	7c 94                	jl     80102ef0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f5c:	e8 7f fd ff ff       	call   80102ce0 <write_head>
    install_trans(); // Now install writes to home locations
80102f61:	e8 da fc ff ff       	call   80102c40 <install_trans>
    log.lh.n = 0;
80102f66:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102f6d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f70:	e8 6b fd ff ff       	call   80102ce0 <write_head>
80102f75:	e9 34 ff ff ff       	jmp    80102eae <end_op+0x5e>
80102f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f80:	83 ec 0c             	sub    $0xc,%esp
80102f83:	68 a0 26 11 80       	push   $0x801126a0
80102f88:	e8 b3 14 00 00       	call   80104440 <wakeup>
  release(&log.lock);
80102f8d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f94:	e8 97 1e 00 00       	call   80104e30 <release>
80102f99:	83 c4 10             	add    $0x10,%esp
}
80102f9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f9f:	5b                   	pop    %ebx
80102fa0:	5e                   	pop    %esi
80102fa1:	5f                   	pop    %edi
80102fa2:	5d                   	pop    %ebp
80102fa3:	c3                   	ret    
    panic("log.committing");
80102fa4:	83 ec 0c             	sub    $0xc,%esp
80102fa7:	68 44 7f 10 80       	push   $0x80107f44
80102fac:	e8 cf d3 ff ff       	call   80100380 <panic>
80102fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fbf:	90                   	nop

80102fc0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	53                   	push   %ebx
80102fc4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fc7:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102fcd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fd0:	83 fa 1d             	cmp    $0x1d,%edx
80102fd3:	0f 8f 85 00 00 00    	jg     8010305e <log_write+0x9e>
80102fd9:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102fde:	83 e8 01             	sub    $0x1,%eax
80102fe1:	39 c2                	cmp    %eax,%edx
80102fe3:	7d 79                	jge    8010305e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fe5:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102fea:	85 c0                	test   %eax,%eax
80102fec:	7e 7d                	jle    8010306b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fee:	83 ec 0c             	sub    $0xc,%esp
80102ff1:	68 a0 26 11 80       	push   $0x801126a0
80102ff6:	e8 95 1e 00 00       	call   80104e90 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102ffb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80103001:	83 c4 10             	add    $0x10,%esp
80103004:	85 d2                	test   %edx,%edx
80103006:	7e 4a                	jle    80103052 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103008:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010300b:	31 c0                	xor    %eax,%eax
8010300d:	eb 08                	jmp    80103017 <log_write+0x57>
8010300f:	90                   	nop
80103010:	83 c0 01             	add    $0x1,%eax
80103013:	39 c2                	cmp    %eax,%edx
80103015:	74 29                	je     80103040 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103017:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
8010301e:	75 f0                	jne    80103010 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103020:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103027:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010302a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010302d:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80103034:	c9                   	leave  
  release(&log.lock);
80103035:	e9 f6 1d 00 00       	jmp    80104e30 <release>
8010303a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103040:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80103047:	83 c2 01             	add    $0x1,%edx
8010304a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80103050:	eb d5                	jmp    80103027 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103052:	8b 43 08             	mov    0x8(%ebx),%eax
80103055:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
8010305a:	75 cb                	jne    80103027 <log_write+0x67>
8010305c:	eb e9                	jmp    80103047 <log_write+0x87>
    panic("too big a transaction");
8010305e:	83 ec 0c             	sub    $0xc,%esp
80103061:	68 53 7f 10 80       	push   $0x80107f53
80103066:	e8 15 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010306b:	83 ec 0c             	sub    $0xc,%esp
8010306e:	68 69 7f 10 80       	push   $0x80107f69
80103073:	e8 08 d3 ff ff       	call   80100380 <panic>
80103078:	66 90                	xchg   %ax,%ax
8010307a:	66 90                	xchg   %ax,%ax
8010307c:	66 90                	xchg   %ax,%ax
8010307e:	66 90                	xchg   %ax,%ax

80103080 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	53                   	push   %ebx
80103084:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103087:	e8 24 0a 00 00       	call   80103ab0 <cpuid>
8010308c:	89 c3                	mov    %eax,%ebx
8010308e:	e8 1d 0a 00 00       	call   80103ab0 <cpuid>
80103093:	83 ec 04             	sub    $0x4,%esp
80103096:	53                   	push   %ebx
80103097:	50                   	push   %eax
80103098:	68 84 7f 10 80       	push   $0x80107f84
8010309d:	e8 fe d5 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
801030a2:	e8 09 31 00 00       	call   801061b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801030a7:	e8 a4 09 00 00       	call   80103a50 <mycpu>
801030ac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801030ae:	b8 01 00 00 00       	mov    $0x1,%eax
801030b3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801030ba:	e8 21 0d 00 00       	call   80103de0 <scheduler>
801030bf:	90                   	nop

801030c0 <mpenter>:
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030c6:	e8 f5 41 00 00       	call   801072c0 <switchkvm>
  seginit();
801030cb:	e8 60 41 00 00       	call   80107230 <seginit>
  lapicinit();
801030d0:	e8 9b f7 ff ff       	call   80102870 <lapicinit>
  mpmain();
801030d5:	e8 a6 ff ff ff       	call   80103080 <mpmain>
801030da:	66 90                	xchg   %ax,%ax
801030dc:	66 90                	xchg   %ax,%ax
801030de:	66 90                	xchg   %ax,%ax

801030e0 <main>:
{
801030e0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030e4:	83 e4 f0             	and    $0xfffffff0,%esp
801030e7:	ff 71 fc             	push   -0x4(%ecx)
801030ea:	55                   	push   %ebp
801030eb:	89 e5                	mov    %esp,%ebp
801030ed:	53                   	push   %ebx
801030ee:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030ef:	83 ec 08             	sub    $0x8,%esp
801030f2:	68 00 00 40 80       	push   $0x80400000
801030f7:	68 d0 62 13 80       	push   $0x801362d0
801030fc:	e8 8f f5 ff ff       	call   80102690 <kinit1>
  kvmalloc();      // kernel page table
80103101:	e8 aa 46 00 00       	call   801077b0 <kvmalloc>
  mpinit();        // detect other processors
80103106:	e8 85 01 00 00       	call   80103290 <mpinit>
  lapicinit();     // interrupt controller
8010310b:	e8 60 f7 ff ff       	call   80102870 <lapicinit>
  seginit();       // segment descriptors
80103110:	e8 1b 41 00 00       	call   80107230 <seginit>
  picinit();       // disable pic
80103115:	e8 76 03 00 00       	call   80103490 <picinit>
  ioapicinit();    // another interrupt controller
8010311a:	e8 31 f3 ff ff       	call   80102450 <ioapicinit>
  consoleinit();   // console hardware
8010311f:	e8 3c d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103124:	e8 97 33 00 00       	call   801064c0 <uartinit>
  pinit();         // process table
80103129:	e8 02 09 00 00       	call   80103a30 <pinit>
  tvinit();        // trap vectors
8010312e:	e8 fd 2f 00 00       	call   80106130 <tvinit>
  binit();         // buffer cache
80103133:	e8 08 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103138:	e8 53 dd ff ff       	call   80100e90 <fileinit>
  ideinit();       // disk 
8010313d:	e8 fe f0 ff ff       	call   80102240 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103142:	83 c4 0c             	add    $0xc,%esp
80103145:	68 8a 00 00 00       	push   $0x8a
8010314a:	68 8c b4 10 80       	push   $0x8010b48c
8010314f:	68 00 70 00 80       	push   $0x80007000
80103154:	e8 97 1e 00 00       	call   80104ff0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103159:	83 c4 10             	add    $0x10,%esp
8010315c:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103163:	00 00 00 
80103166:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010316b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103170:	76 7e                	jbe    801031f0 <main+0x110>
80103172:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103177:	eb 20                	jmp    80103199 <main+0xb9>
80103179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103180:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103187:	00 00 00 
8010318a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103190:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103195:	39 c3                	cmp    %eax,%ebx
80103197:	73 57                	jae    801031f0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103199:	e8 b2 08 00 00       	call   80103a50 <mycpu>
8010319e:	39 c3                	cmp    %eax,%ebx
801031a0:	74 de                	je     80103180 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801031a2:	e8 59 f5 ff ff       	call   80102700 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801031a7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801031aa:	c7 05 f8 6f 00 80 c0 	movl   $0x801030c0,0x80006ff8
801031b1:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031b4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801031bb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801031be:	05 00 10 00 00       	add    $0x1000,%eax
801031c3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801031c8:	0f b6 03             	movzbl (%ebx),%eax
801031cb:	68 00 70 00 00       	push   $0x7000
801031d0:	50                   	push   %eax
801031d1:	e8 ea f7 ff ff       	call   801029c0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031d6:	83 c4 10             	add    $0x10,%esp
801031d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031e0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031e6:	85 c0                	test   %eax,%eax
801031e8:	74 f6                	je     801031e0 <main+0x100>
801031ea:	eb 94                	jmp    80103180 <main+0xa0>
801031ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031f0:	83 ec 08             	sub    $0x8,%esp
801031f3:	68 00 00 00 8e       	push   $0x8e000000
801031f8:	68 00 00 40 80       	push   $0x80400000
801031fd:	e8 2e f4 ff ff       	call   80102630 <kinit2>
  userinit();      // first user process
80103202:	e8 f9 08 00 00       	call   80103b00 <userinit>
  mpmain();        // finish this processor's setup
80103207:	e8 74 fe ff ff       	call   80103080 <mpmain>
8010320c:	66 90                	xchg   %ax,%ax
8010320e:	66 90                	xchg   %ax,%ax

80103210 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103215:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010321b:	53                   	push   %ebx
  e = addr+len;
8010321c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010321f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103222:	39 de                	cmp    %ebx,%esi
80103224:	72 10                	jb     80103236 <mpsearch1+0x26>
80103226:	eb 50                	jmp    80103278 <mpsearch1+0x68>
80103228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010322f:	90                   	nop
80103230:	89 fe                	mov    %edi,%esi
80103232:	39 fb                	cmp    %edi,%ebx
80103234:	76 42                	jbe    80103278 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103236:	83 ec 04             	sub    $0x4,%esp
80103239:	8d 7e 10             	lea    0x10(%esi),%edi
8010323c:	6a 04                	push   $0x4
8010323e:	68 98 7f 10 80       	push   $0x80107f98
80103243:	56                   	push   %esi
80103244:	e8 57 1d 00 00       	call   80104fa0 <memcmp>
80103249:	83 c4 10             	add    $0x10,%esp
8010324c:	85 c0                	test   %eax,%eax
8010324e:	75 e0                	jne    80103230 <mpsearch1+0x20>
80103250:	89 f2                	mov    %esi,%edx
80103252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103258:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010325b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010325e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103260:	39 fa                	cmp    %edi,%edx
80103262:	75 f4                	jne    80103258 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103264:	84 c0                	test   %al,%al
80103266:	75 c8                	jne    80103230 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103268:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010326b:	89 f0                	mov    %esi,%eax
8010326d:	5b                   	pop    %ebx
8010326e:	5e                   	pop    %esi
8010326f:	5f                   	pop    %edi
80103270:	5d                   	pop    %ebp
80103271:	c3                   	ret    
80103272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103278:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010327b:	31 f6                	xor    %esi,%esi
}
8010327d:	5b                   	pop    %ebx
8010327e:	89 f0                	mov    %esi,%eax
80103280:	5e                   	pop    %esi
80103281:	5f                   	pop    %edi
80103282:	5d                   	pop    %ebp
80103283:	c3                   	ret    
80103284:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010328b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010328f:	90                   	nop

80103290 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	57                   	push   %edi
80103294:	56                   	push   %esi
80103295:	53                   	push   %ebx
80103296:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103299:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801032a0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801032a7:	c1 e0 08             	shl    $0x8,%eax
801032aa:	09 d0                	or     %edx,%eax
801032ac:	c1 e0 04             	shl    $0x4,%eax
801032af:	75 1b                	jne    801032cc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801032b1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801032b8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032bf:	c1 e0 08             	shl    $0x8,%eax
801032c2:	09 d0                	or     %edx,%eax
801032c4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032c7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032cc:	ba 00 04 00 00       	mov    $0x400,%edx
801032d1:	e8 3a ff ff ff       	call   80103210 <mpsearch1>
801032d6:	89 c3                	mov    %eax,%ebx
801032d8:	85 c0                	test   %eax,%eax
801032da:	0f 84 40 01 00 00    	je     80103420 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032e0:	8b 73 04             	mov    0x4(%ebx),%esi
801032e3:	85 f6                	test   %esi,%esi
801032e5:	0f 84 25 01 00 00    	je     80103410 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
801032eb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032ee:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801032f4:	6a 04                	push   $0x4
801032f6:	68 9d 7f 10 80       	push   $0x80107f9d
801032fb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032ff:	e8 9c 1c 00 00       	call   80104fa0 <memcmp>
80103304:	83 c4 10             	add    $0x10,%esp
80103307:	85 c0                	test   %eax,%eax
80103309:	0f 85 01 01 00 00    	jne    80103410 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010330f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103316:	3c 01                	cmp    $0x1,%al
80103318:	74 08                	je     80103322 <mpinit+0x92>
8010331a:	3c 04                	cmp    $0x4,%al
8010331c:	0f 85 ee 00 00 00    	jne    80103410 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103322:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103329:	66 85 d2             	test   %dx,%dx
8010332c:	74 22                	je     80103350 <mpinit+0xc0>
8010332e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103331:	89 f0                	mov    %esi,%eax
  sum = 0;
80103333:	31 d2                	xor    %edx,%edx
80103335:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103338:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010333f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103342:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103344:	39 c7                	cmp    %eax,%edi
80103346:	75 f0                	jne    80103338 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103348:	84 d2                	test   %dl,%dl
8010334a:	0f 85 c0 00 00 00    	jne    80103410 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103350:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103356:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010335b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103362:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103368:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010336d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103370:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103373:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103377:	90                   	nop
80103378:	39 d0                	cmp    %edx,%eax
8010337a:	73 15                	jae    80103391 <mpinit+0x101>
    switch(*p){
8010337c:	0f b6 08             	movzbl (%eax),%ecx
8010337f:	80 f9 02             	cmp    $0x2,%cl
80103382:	74 4c                	je     801033d0 <mpinit+0x140>
80103384:	77 3a                	ja     801033c0 <mpinit+0x130>
80103386:	84 c9                	test   %cl,%cl
80103388:	74 56                	je     801033e0 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010338a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010338d:	39 d0                	cmp    %edx,%eax
8010338f:	72 eb                	jb     8010337c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103391:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103394:	85 f6                	test   %esi,%esi
80103396:	0f 84 d9 00 00 00    	je     80103475 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010339c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801033a0:	74 15                	je     801033b7 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033a2:	b8 70 00 00 00       	mov    $0x70,%eax
801033a7:	ba 22 00 00 00       	mov    $0x22,%edx
801033ac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033ad:	ba 23 00 00 00       	mov    $0x23,%edx
801033b2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033b3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033b6:	ee                   	out    %al,(%dx)
  }
}
801033b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033ba:	5b                   	pop    %ebx
801033bb:	5e                   	pop    %esi
801033bc:	5f                   	pop    %edi
801033bd:	5d                   	pop    %ebp
801033be:	c3                   	ret    
801033bf:	90                   	nop
    switch(*p){
801033c0:	83 e9 03             	sub    $0x3,%ecx
801033c3:	80 f9 01             	cmp    $0x1,%cl
801033c6:	76 c2                	jbe    8010338a <mpinit+0xfa>
801033c8:	31 f6                	xor    %esi,%esi
801033ca:	eb ac                	jmp    80103378 <mpinit+0xe8>
801033cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033d0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033d4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033d7:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
801033dd:	eb 99                	jmp    80103378 <mpinit+0xe8>
801033df:	90                   	nop
      if(ncpu < NCPU) {
801033e0:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
801033e6:	83 f9 07             	cmp    $0x7,%ecx
801033e9:	7f 19                	jg     80103404 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033eb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033f1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033f5:	83 c1 01             	add    $0x1,%ecx
801033f8:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033fe:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103404:	83 c0 14             	add    $0x14,%eax
      continue;
80103407:	e9 6c ff ff ff       	jmp    80103378 <mpinit+0xe8>
8010340c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	68 a2 7f 10 80       	push   $0x80107fa2
80103418:	e8 63 cf ff ff       	call   80100380 <panic>
8010341d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103420:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103425:	eb 13                	jmp    8010343a <mpinit+0x1aa>
80103427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010342e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103430:	89 f3                	mov    %esi,%ebx
80103432:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103438:	74 d6                	je     80103410 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010343a:	83 ec 04             	sub    $0x4,%esp
8010343d:	8d 73 10             	lea    0x10(%ebx),%esi
80103440:	6a 04                	push   $0x4
80103442:	68 98 7f 10 80       	push   $0x80107f98
80103447:	53                   	push   %ebx
80103448:	e8 53 1b 00 00       	call   80104fa0 <memcmp>
8010344d:	83 c4 10             	add    $0x10,%esp
80103450:	85 c0                	test   %eax,%eax
80103452:	75 dc                	jne    80103430 <mpinit+0x1a0>
80103454:	89 da                	mov    %ebx,%edx
80103456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010345d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103460:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103463:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103466:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103468:	39 d6                	cmp    %edx,%esi
8010346a:	75 f4                	jne    80103460 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010346c:	84 c0                	test   %al,%al
8010346e:	75 c0                	jne    80103430 <mpinit+0x1a0>
80103470:	e9 6b fe ff ff       	jmp    801032e0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103475:	83 ec 0c             	sub    $0xc,%esp
80103478:	68 bc 7f 10 80       	push   $0x80107fbc
8010347d:	e8 fe ce ff ff       	call   80100380 <panic>
80103482:	66 90                	xchg   %ax,%ax
80103484:	66 90                	xchg   %ax,%ax
80103486:	66 90                	xchg   %ax,%ax
80103488:	66 90                	xchg   %ax,%ax
8010348a:	66 90                	xchg   %ax,%ax
8010348c:	66 90                	xchg   %ax,%ax
8010348e:	66 90                	xchg   %ax,%ax

80103490 <picinit>:
80103490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103495:	ba 21 00 00 00       	mov    $0x21,%edx
8010349a:	ee                   	out    %al,(%dx)
8010349b:	ba a1 00 00 00       	mov    $0xa1,%edx
801034a0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801034a1:	c3                   	ret    
801034a2:	66 90                	xchg   %ax,%ax
801034a4:	66 90                	xchg   %ax,%ax
801034a6:	66 90                	xchg   %ax,%ax
801034a8:	66 90                	xchg   %ax,%ax
801034aa:	66 90                	xchg   %ax,%ax
801034ac:	66 90                	xchg   %ax,%ax
801034ae:	66 90                	xchg   %ax,%ax

801034b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	57                   	push   %edi
801034b4:	56                   	push   %esi
801034b5:	53                   	push   %ebx
801034b6:	83 ec 0c             	sub    $0xc,%esp
801034b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034bf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801034c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034cb:	e8 e0 d9 ff ff       	call   80100eb0 <filealloc>
801034d0:	89 03                	mov    %eax,(%ebx)
801034d2:	85 c0                	test   %eax,%eax
801034d4:	0f 84 a8 00 00 00    	je     80103582 <pipealloc+0xd2>
801034da:	e8 d1 d9 ff ff       	call   80100eb0 <filealloc>
801034df:	89 06                	mov    %eax,(%esi)
801034e1:	85 c0                	test   %eax,%eax
801034e3:	0f 84 87 00 00 00    	je     80103570 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034e9:	e8 12 f2 ff ff       	call   80102700 <kalloc>
801034ee:	89 c7                	mov    %eax,%edi
801034f0:	85 c0                	test   %eax,%eax
801034f2:	0f 84 b0 00 00 00    	je     801035a8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801034f8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034ff:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103502:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103505:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010350c:	00 00 00 
  p->nwrite = 0;
8010350f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103516:	00 00 00 
  p->nread = 0;
80103519:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103520:	00 00 00 
  initlock(&p->lock, "pipe");
80103523:	68 db 7f 10 80       	push   $0x80107fdb
80103528:	50                   	push   %eax
80103529:	e8 92 17 00 00       	call   80104cc0 <initlock>
  (*f0)->type = FD_PIPE;
8010352e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103530:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103533:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103539:	8b 03                	mov    (%ebx),%eax
8010353b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010353f:	8b 03                	mov    (%ebx),%eax
80103541:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103545:	8b 03                	mov    (%ebx),%eax
80103547:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010354a:	8b 06                	mov    (%esi),%eax
8010354c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103552:	8b 06                	mov    (%esi),%eax
80103554:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103558:	8b 06                	mov    (%esi),%eax
8010355a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010355e:	8b 06                	mov    (%esi),%eax
80103560:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103563:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103566:	31 c0                	xor    %eax,%eax
}
80103568:	5b                   	pop    %ebx
80103569:	5e                   	pop    %esi
8010356a:	5f                   	pop    %edi
8010356b:	5d                   	pop    %ebp
8010356c:	c3                   	ret    
8010356d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103570:	8b 03                	mov    (%ebx),%eax
80103572:	85 c0                	test   %eax,%eax
80103574:	74 1e                	je     80103594 <pipealloc+0xe4>
    fileclose(*f0);
80103576:	83 ec 0c             	sub    $0xc,%esp
80103579:	50                   	push   %eax
8010357a:	e8 f1 d9 ff ff       	call   80100f70 <fileclose>
8010357f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103582:	8b 06                	mov    (%esi),%eax
80103584:	85 c0                	test   %eax,%eax
80103586:	74 0c                	je     80103594 <pipealloc+0xe4>
    fileclose(*f1);
80103588:	83 ec 0c             	sub    $0xc,%esp
8010358b:	50                   	push   %eax
8010358c:	e8 df d9 ff ff       	call   80100f70 <fileclose>
80103591:	83 c4 10             	add    $0x10,%esp
}
80103594:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103597:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010359c:	5b                   	pop    %ebx
8010359d:	5e                   	pop    %esi
8010359e:	5f                   	pop    %edi
8010359f:	5d                   	pop    %ebp
801035a0:	c3                   	ret    
801035a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801035a8:	8b 03                	mov    (%ebx),%eax
801035aa:	85 c0                	test   %eax,%eax
801035ac:	75 c8                	jne    80103576 <pipealloc+0xc6>
801035ae:	eb d2                	jmp    80103582 <pipealloc+0xd2>

801035b0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	56                   	push   %esi
801035b4:	53                   	push   %ebx
801035b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035bb:	83 ec 0c             	sub    $0xc,%esp
801035be:	53                   	push   %ebx
801035bf:	e8 cc 18 00 00       	call   80104e90 <acquire>
  if(writable){
801035c4:	83 c4 10             	add    $0x10,%esp
801035c7:	85 f6                	test   %esi,%esi
801035c9:	74 65                	je     80103630 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801035cb:	83 ec 0c             	sub    $0xc,%esp
801035ce:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801035d4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035db:	00 00 00 
    wakeup(&p->nread);
801035de:	50                   	push   %eax
801035df:	e8 5c 0e 00 00       	call   80104440 <wakeup>
801035e4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035e7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035ed:	85 d2                	test   %edx,%edx
801035ef:	75 0a                	jne    801035fb <pipeclose+0x4b>
801035f1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035f7:	85 c0                	test   %eax,%eax
801035f9:	74 15                	je     80103610 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103601:	5b                   	pop    %ebx
80103602:	5e                   	pop    %esi
80103603:	5d                   	pop    %ebp
    release(&p->lock);
80103604:	e9 27 18 00 00       	jmp    80104e30 <release>
80103609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103610:	83 ec 0c             	sub    $0xc,%esp
80103613:	53                   	push   %ebx
80103614:	e8 17 18 00 00       	call   80104e30 <release>
    kfree((char*)p);
80103619:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010361c:	83 c4 10             	add    $0x10,%esp
}
8010361f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103622:	5b                   	pop    %ebx
80103623:	5e                   	pop    %esi
80103624:	5d                   	pop    %ebp
    kfree((char*)p);
80103625:	e9 16 ef ff ff       	jmp    80102540 <kfree>
8010362a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103630:	83 ec 0c             	sub    $0xc,%esp
80103633:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103639:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103640:	00 00 00 
    wakeup(&p->nwrite);
80103643:	50                   	push   %eax
80103644:	e8 f7 0d 00 00       	call   80104440 <wakeup>
80103649:	83 c4 10             	add    $0x10,%esp
8010364c:	eb 99                	jmp    801035e7 <pipeclose+0x37>
8010364e:	66 90                	xchg   %ax,%ax

80103650 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	57                   	push   %edi
80103654:	56                   	push   %esi
80103655:	53                   	push   %ebx
80103656:	83 ec 28             	sub    $0x28,%esp
80103659:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010365c:	53                   	push   %ebx
8010365d:	e8 2e 18 00 00       	call   80104e90 <acquire>
  for(i = 0; i < n; i++){
80103662:	8b 45 10             	mov    0x10(%ebp),%eax
80103665:	83 c4 10             	add    $0x10,%esp
80103668:	85 c0                	test   %eax,%eax
8010366a:	0f 8e c0 00 00 00    	jle    80103730 <pipewrite+0xe0>
80103670:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103673:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103679:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010367f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103682:	03 45 10             	add    0x10(%ebp),%eax
80103685:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103688:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010368e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103694:	89 ca                	mov    %ecx,%edx
80103696:	05 00 02 00 00       	add    $0x200,%eax
8010369b:	39 c1                	cmp    %eax,%ecx
8010369d:	74 3f                	je     801036de <pipewrite+0x8e>
8010369f:	eb 67                	jmp    80103708 <pipewrite+0xb8>
801036a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801036a8:	e8 23 04 00 00       	call   80103ad0 <myproc>
801036ad:	8b 48 18             	mov    0x18(%eax),%ecx
801036b0:	85 c9                	test   %ecx,%ecx
801036b2:	75 34                	jne    801036e8 <pipewrite+0x98>
      wakeup(&p->nread);
801036b4:	83 ec 0c             	sub    $0xc,%esp
801036b7:	57                   	push   %edi
801036b8:	e8 83 0d 00 00       	call   80104440 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036bd:	58                   	pop    %eax
801036be:	5a                   	pop    %edx
801036bf:	53                   	push   %ebx
801036c0:	56                   	push   %esi
801036c1:	e8 ea 0a 00 00       	call   801041b0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036c6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036cc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036d2:	83 c4 10             	add    $0x10,%esp
801036d5:	05 00 02 00 00       	add    $0x200,%eax
801036da:	39 c2                	cmp    %eax,%edx
801036dc:	75 2a                	jne    80103708 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801036de:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036e4:	85 c0                	test   %eax,%eax
801036e6:	75 c0                	jne    801036a8 <pipewrite+0x58>
        release(&p->lock);
801036e8:	83 ec 0c             	sub    $0xc,%esp
801036eb:	53                   	push   %ebx
801036ec:	e8 3f 17 00 00       	call   80104e30 <release>
        return -1;
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036fc:	5b                   	pop    %ebx
801036fd:	5e                   	pop    %esi
801036fe:	5f                   	pop    %edi
801036ff:	5d                   	pop    %ebp
80103700:	c3                   	ret    
80103701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103708:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010370b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010370e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103714:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010371a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010371d:	83 c6 01             	add    $0x1,%esi
80103720:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103723:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103727:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010372a:	0f 85 58 ff ff ff    	jne    80103688 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103739:	50                   	push   %eax
8010373a:	e8 01 0d 00 00       	call   80104440 <wakeup>
  release(&p->lock);
8010373f:	89 1c 24             	mov    %ebx,(%esp)
80103742:	e8 e9 16 00 00       	call   80104e30 <release>
  return n;
80103747:	8b 45 10             	mov    0x10(%ebp),%eax
8010374a:	83 c4 10             	add    $0x10,%esp
8010374d:	eb aa                	jmp    801036f9 <pipewrite+0xa9>
8010374f:	90                   	nop

80103750 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	57                   	push   %edi
80103754:	56                   	push   %esi
80103755:	53                   	push   %ebx
80103756:	83 ec 18             	sub    $0x18,%esp
80103759:	8b 75 08             	mov    0x8(%ebp),%esi
8010375c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010375f:	56                   	push   %esi
80103760:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103766:	e8 25 17 00 00       	call   80104e90 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010376b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103771:	83 c4 10             	add    $0x10,%esp
80103774:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010377a:	74 2f                	je     801037ab <piperead+0x5b>
8010377c:	eb 37                	jmp    801037b5 <piperead+0x65>
8010377e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103780:	e8 4b 03 00 00       	call   80103ad0 <myproc>
80103785:	8b 48 18             	mov    0x18(%eax),%ecx
80103788:	85 c9                	test   %ecx,%ecx
8010378a:	0f 85 80 00 00 00    	jne    80103810 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103790:	83 ec 08             	sub    $0x8,%esp
80103793:	56                   	push   %esi
80103794:	53                   	push   %ebx
80103795:	e8 16 0a 00 00       	call   801041b0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010379a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801037a0:	83 c4 10             	add    $0x10,%esp
801037a3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801037a9:	75 0a                	jne    801037b5 <piperead+0x65>
801037ab:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801037b1:	85 c0                	test   %eax,%eax
801037b3:	75 cb                	jne    80103780 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037b5:	8b 55 10             	mov    0x10(%ebp),%edx
801037b8:	31 db                	xor    %ebx,%ebx
801037ba:	85 d2                	test   %edx,%edx
801037bc:	7f 20                	jg     801037de <piperead+0x8e>
801037be:	eb 2c                	jmp    801037ec <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037c0:	8d 48 01             	lea    0x1(%eax),%ecx
801037c3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037c8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037ce:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037d3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037d6:	83 c3 01             	add    $0x1,%ebx
801037d9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037dc:	74 0e                	je     801037ec <piperead+0x9c>
    if(p->nread == p->nwrite)
801037de:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037e4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037ea:	75 d4                	jne    801037c0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037ec:	83 ec 0c             	sub    $0xc,%esp
801037ef:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037f5:	50                   	push   %eax
801037f6:	e8 45 0c 00 00       	call   80104440 <wakeup>
  release(&p->lock);
801037fb:	89 34 24             	mov    %esi,(%esp)
801037fe:	e8 2d 16 00 00       	call   80104e30 <release>
  return i;
80103803:	83 c4 10             	add    $0x10,%esp
}
80103806:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103809:	89 d8                	mov    %ebx,%eax
8010380b:	5b                   	pop    %ebx
8010380c:	5e                   	pop    %esi
8010380d:	5f                   	pop    %edi
8010380e:	5d                   	pop    %ebp
8010380f:	c3                   	ret    
      release(&p->lock);
80103810:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103813:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103818:	56                   	push   %esi
80103819:	e8 12 16 00 00       	call   80104e30 <release>
      return -1;
8010381e:	83 c4 10             	add    $0x10,%esp
}
80103821:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103824:	89 d8                	mov    %ebx,%eax
80103826:	5b                   	pop    %ebx
80103827:	5e                   	pop    %esi
80103828:	5f                   	pop    %edi
80103829:	5d                   	pop    %ebp
8010382a:	c3                   	ret    
8010382b:	66 90                	xchg   %ax,%ax
8010382d:	66 90                	xchg   %ax,%ax
8010382f:	90                   	nop

80103830 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	53                   	push   %ebx
  struct thread *t;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103834:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103839:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010383c:	68 20 2d 11 80       	push   $0x80112d20
80103841:	e8 4a 16 00 00       	call   80104e90 <acquire>
80103846:	83 c4 10             	add    $0x10,%esp
80103849:	eb 17                	jmp    80103862 <allocproc+0x32>
8010384b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010384f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103850:	81 c3 74 08 00 00    	add    $0x874,%ebx
80103856:	81 fb 54 4a 13 80    	cmp    $0x80134a54,%ebx
8010385c:	0f 84 d7 00 00 00    	je     80103939 <allocproc+0x109>
    if(p->state == UNUSED)
80103862:	8b 43 0c             	mov    0xc(%ebx),%eax
80103865:	85 c0                	test   %eax,%eax
80103867:	75 e7                	jne    80103850 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103869:	a1 08 b0 10 80       	mov    0x8010b008,%eax
  p->state = EMBRYO;
8010386e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->curtidx = 0;
80103875:	c7 83 70 08 00 00 00 	movl   $0x0,0x870(%ebx)
8010387c:	00 00 00 
  p->pid = nextpid++;
8010387f:	8d 50 01             	lea    0x1(%eax),%edx
80103882:	89 43 10             	mov    %eax,0x10(%ebx)

  // Thread pool init
  for(int i = 0; i < NTHREAD; i++){
80103885:	8d 43 70             	lea    0x70(%ebx),%eax
  p->pid = nextpid++;
80103888:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
8010388e:	8d 93 70 08 00 00    	lea    0x870(%ebx),%edx
80103894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	p->threads[i].state = UNUSED;
80103898:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i = 0; i < NTHREAD; i++){
8010389e:	83 c0 20             	add    $0x20,%eax
	p->threads[i].tid = 0;
801038a1:	c7 40 e4 00 00 00 00 	movl   $0x0,-0x1c(%eax)
	p->threads[i].kstack = 0;
801038a8:	c7 40 e8 00 00 00 00 	movl   $0x0,-0x18(%eax)
	p->threads[i].ustackp = 0;
801038af:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
  for(int i = 0; i < NTHREAD; i++){
801038b6:	39 d0                	cmp    %edx,%eax
801038b8:	75 de                	jne    80103898 <allocproc+0x68>
  }

  // Default-thread init
  t = &p->threads[0];
  t->state = EMBRYO;
  t->tid = nexttid++;
801038ba:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801038bf:	83 ec 0c             	sub    $0xc,%esp
  t->state = EMBRYO;
801038c2:	c7 43 70 01 00 00 00 	movl   $0x1,0x70(%ebx)
  t->tid = nexttid++;
801038c9:	89 43 74             	mov    %eax,0x74(%ebx)
801038cc:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801038cf:	68 20 2d 11 80       	push   $0x80112d20
  t->tid = nexttid++;
801038d4:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801038da:	e8 51 15 00 00       	call   80104e30 <release>

  // Allocate kernel stack to Default-thread
  if((t->kstack = kalloc()) == 0){
801038df:	e8 1c ee ff ff       	call   80102700 <kalloc>
801038e4:	83 c4 10             	add    $0x10,%esp
801038e7:	89 43 78             	mov    %eax,0x78(%ebx)
801038ea:	85 c0                	test   %eax,%eax
801038ec:	74 64                	je     80103952 <allocproc+0x122>
    return 0;
  }
  sp = t->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *t->tf;
801038ee:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *t->context;
  t->context = (struct context*)sp;
  memset(t->context, 0, sizeof *t->context);
801038f4:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *t->context;
801038f7:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *t->tf;
801038fc:	89 53 7c             	mov    %edx,0x7c(%ebx)
  *(uint*)sp = (uint)trapret;
801038ff:	c7 40 14 22 61 10 80 	movl   $0x80106122,0x14(%eax)
  t->context = (struct context*)sp;
80103906:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  memset(t->context, 0, sizeof *t->context);
8010390c:	6a 14                	push   $0x14
8010390e:	6a 00                	push   $0x0
80103910:	50                   	push   %eax
80103911:	e8 3a 16 00 00       	call   80104f50 <memset>
  t->context->eip = (uint)forkret;
80103916:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
8010391c:	c7 40 10 70 39 10 80 	movl   $0x80103970,0x10(%eax)

  cprintf("Allocproc(): finished\n");
80103923:	c7 04 24 e0 7f 10 80 	movl   $0x80107fe0,(%esp)
8010392a:	e8 71 cd ff ff       	call   801006a0 <cprintf>

  return p;
}
8010392f:	89 d8                	mov    %ebx,%eax
  return p;
80103931:	83 c4 10             	add    $0x10,%esp
}
80103934:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103937:	c9                   	leave  
80103938:	c3                   	ret    
  release(&ptable.lock);
80103939:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010393c:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010393e:	68 20 2d 11 80       	push   $0x80112d20
80103943:	e8 e8 14 00 00       	call   80104e30 <release>
}
80103948:	89 d8                	mov    %ebx,%eax
  return 0;
8010394a:	83 c4 10             	add    $0x10,%esp
}
8010394d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103950:	c9                   	leave  
80103951:	c3                   	ret    
    p->state = UNUSED;
80103952:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
	t->state = UNUSED;
80103959:	c7 43 70 00 00 00 00 	movl   $0x0,0x70(%ebx)
    return 0;
80103960:	31 db                	xor    %ebx,%ebx
}
80103962:	89 d8                	mov    %ebx,%eax
80103964:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103967:	c9                   	leave  
80103968:	c3                   	ret    
80103969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103970 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103976:	68 20 2d 11 80       	push   $0x80112d20
8010397b:	e8 b0 14 00 00       	call   80104e30 <release>

  if (first) {
80103980:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103985:	83 c4 10             	add    $0x10,%esp
80103988:	85 c0                	test   %eax,%eax
8010398a:	75 04                	jne    80103990 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010398c:	c9                   	leave  
8010398d:	c3                   	ret    
8010398e:	66 90                	xchg   %ax,%ax
    first = 0;
80103990:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103997:	00 00 00 
    iinit(ROOTDEV);
8010399a:	83 ec 0c             	sub    $0xc,%esp
8010399d:	6a 01                	push   $0x1
8010399f:	e8 3c dc ff ff       	call   801015e0 <iinit>
    initlog(ROOTDEV);
801039a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039ab:	e8 90 f3 ff ff       	call   80102d40 <initlog>
}
801039b0:	83 c4 10             	add    $0x10,%esp
801039b3:	c9                   	leave  
801039b4:	c3                   	ret    
801039b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039c0 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801039c0:	55                   	push   %ebp
801039c1:	ba c4 35 11 80       	mov    $0x801135c4,%edx
801039c6:	89 e5                	mov    %esp,%ebp
801039c8:	53                   	push   %ebx
801039c9:	89 c3                	mov    %eax,%ebx
801039cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039cf:	90                   	nop
  struct proc *p;
  struct thread *t;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	for(t = p->threads; t < &p->threads[NTHREAD]; t++)
801039d0:	8d 8a 00 f8 ff ff    	lea    -0x800(%edx),%ecx
801039d6:	89 c8                	mov    %ecx,%eax
801039d8:	eb 0d                	jmp    801039e7 <wakeup1+0x27>
801039da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039e0:	83 c0 20             	add    $0x20,%eax
801039e3:	39 d0                	cmp    %edx,%eax
801039e5:	74 20                	je     80103a07 <wakeup1+0x47>
      if(t->state == SLEEPING && t->chan == chan){
801039e7:	83 38 02             	cmpl   $0x2,(%eax)
801039ea:	75 f4                	jne    801039e0 <wakeup1+0x20>
801039ec:	39 58 18             	cmp    %ebx,0x18(%eax)
801039ef:	75 ef                	jne    801039e0 <wakeup1+0x20>
      	t->state = RUNNABLE;
801039f1:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
801039f7:	eb e7                	jmp    801039e0 <wakeup1+0x20>
801039f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	p->state = ZOMBIE;
  return;
 
ISRUNNABLE: // if any threads are runnable, change p states: RUNNABLE
  flag = 0;
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80103a00:	83 c1 20             	add    $0x20,%ecx
80103a03:	39 ca                	cmp    %ecx,%edx
80103a05:	74 0f                	je     80103a16 <wakeup1+0x56>
	if(t->state == RUNNABLE){
80103a07:	83 39 03             	cmpl   $0x3,(%ecx)
80103a0a:	75 f4                	jne    80103a00 <wakeup1+0x40>
	  flag = 1;
	  break;
	}
  if(flag)
	p->state = RUNNABLE;
80103a0c:	c7 82 9c f7 ff ff 03 	movl   $0x3,-0x864(%edx)
80103a13:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a16:	81 c2 74 08 00 00    	add    $0x874,%edx
80103a1c:	81 fa c4 52 13 80    	cmp    $0x801352c4,%edx
80103a22:	75 ac                	jne    801039d0 <wakeup1+0x10>
}
80103a24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a27:	c9                   	leave  
80103a28:	c3                   	ret    
80103a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a30 <pinit>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a36:	68 f7 7f 10 80       	push   $0x80107ff7
80103a3b:	68 20 2d 11 80       	push   $0x80112d20
80103a40:	e8 7b 12 00 00       	call   80104cc0 <initlock>
}
80103a45:	83 c4 10             	add    $0x10,%esp
80103a48:	c9                   	leave  
80103a49:	c3                   	ret    
80103a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a50 <mycpu>:
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	56                   	push   %esi
80103a54:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a55:	9c                   	pushf  
80103a56:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a57:	f6 c4 02             	test   $0x2,%ah
80103a5a:	75 46                	jne    80103aa2 <mycpu+0x52>
  apicid = lapicid();
80103a5c:	e8 0f ef ff ff       	call   80102970 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a61:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103a67:	85 f6                	test   %esi,%esi
80103a69:	7e 2a                	jle    80103a95 <mycpu+0x45>
80103a6b:	31 d2                	xor    %edx,%edx
80103a6d:	eb 08                	jmp    80103a77 <mycpu+0x27>
80103a6f:	90                   	nop
80103a70:	83 c2 01             	add    $0x1,%edx
80103a73:	39 f2                	cmp    %esi,%edx
80103a75:	74 1e                	je     80103a95 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103a77:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a7d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103a84:	39 c3                	cmp    %eax,%ebx
80103a86:	75 e8                	jne    80103a70 <mycpu+0x20>
}
80103a88:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a8b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103a91:	5b                   	pop    %ebx
80103a92:	5e                   	pop    %esi
80103a93:	5d                   	pop    %ebp
80103a94:	c3                   	ret    
  panic("unknown apicid\n");
80103a95:	83 ec 0c             	sub    $0xc,%esp
80103a98:	68 fe 7f 10 80       	push   $0x80107ffe
80103a9d:	e8 de c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103aa2:	83 ec 0c             	sub    $0xc,%esp
80103aa5:	68 a8 81 10 80       	push   $0x801081a8
80103aaa:	e8 d1 c8 ff ff       	call   80100380 <panic>
80103aaf:	90                   	nop

80103ab0 <cpuid>:
cpuid() {
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103ab6:	e8 95 ff ff ff       	call   80103a50 <mycpu>
}
80103abb:	c9                   	leave  
  return mycpu()-cpus;
80103abc:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103ac1:	c1 f8 04             	sar    $0x4,%eax
80103ac4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103aca:	c3                   	ret    
80103acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103acf:	90                   	nop

80103ad0 <myproc>:
myproc(void) {
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	53                   	push   %ebx
80103ad4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ad7:	e8 64 12 00 00       	call   80104d40 <pushcli>
  c = mycpu();
80103adc:	e8 6f ff ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80103ae1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ae7:	e8 a4 12 00 00       	call   80104d90 <popcli>
}
80103aec:	89 d8                	mov    %ebx,%eax
80103aee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103af1:	c9                   	leave  
80103af2:	c3                   	ret    
80103af3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b00 <userinit>:
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	53                   	push   %ebx
80103b04:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b07:	e8 24 fd ff ff       	call   80103830 <allocproc>
80103b0c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b0e:	a3 54 4a 13 80       	mov    %eax,0x80134a54
  if((p->pgdir = setupkvm()) == 0)
80103b13:	e8 18 3c 00 00       	call   80107730 <setupkvm>
80103b18:	89 43 08             	mov    %eax,0x8(%ebx)
80103b1b:	85 c0                	test   %eax,%eax
80103b1d:	0f 84 d0 00 00 00    	je     80103bf3 <userinit+0xf3>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b23:	83 ec 04             	sub    $0x4,%esp
80103b26:	68 2c 00 00 00       	push   $0x2c
80103b2b:	68 60 b4 10 80       	push   $0x8010b460
80103b30:	50                   	push   %eax
80103b31:	e8 aa 38 00 00       	call   801073e0 <inituvm>
  memset(t->tf, 0, sizeof(*t->tf));
80103b36:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b39:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(t->tf, 0, sizeof(*t->tf));
80103b3f:	6a 4c                	push   $0x4c
80103b41:	6a 00                	push   $0x0
80103b43:	ff 73 7c             	push   0x7c(%ebx)
80103b46:	e8 05 14 00 00       	call   80104f50 <memset>
  t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b4b:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103b4e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b53:	83 c4 0c             	add    $0xc,%esp
  t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b56:	b9 23 00 00 00       	mov    $0x23,%ecx
  t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b5b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b5f:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103b62:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  t->tf->es = t->tf->ds;
80103b66:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103b69:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b6d:	66 89 50 28          	mov    %dx,0x28(%eax)
  t->tf->ss = t->tf->ds;
80103b71:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103b74:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b78:	66 89 50 48          	mov    %dx,0x48(%eax)
  t->tf->eflags = FL_IF;
80103b7c:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103b7f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  t->tf->esp = PGSIZE;
80103b86:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103b89:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  t->tf->eip = 0;  // beginning of initcode.S
80103b90:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103b93:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b9a:	8d 43 60             	lea    0x60(%ebx),%eax
80103b9d:	6a 10                	push   $0x10
80103b9f:	68 27 80 10 80       	push   $0x80108027
80103ba4:	50                   	push   %eax
80103ba5:	e8 66 15 00 00       	call   80105110 <safestrcpy>
  p->cwd = namei("/");
80103baa:	c7 04 24 30 80 10 80 	movl   $0x80108030,(%esp)
80103bb1:	e8 6a e5 ff ff       	call   80102120 <namei>
80103bb6:	89 43 5c             	mov    %eax,0x5c(%ebx)
  acquire(&ptable.lock);
80103bb9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bc0:	e8 cb 12 00 00       	call   80104e90 <acquire>
  t->state = RUNNABLE;
80103bc5:	c7 43 70 03 00 00 00 	movl   $0x3,0x70(%ebx)
  p->state = RUNNABLE;
80103bcc:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  cprintf("userinit(): finished\n");
80103bd3:	c7 04 24 32 80 10 80 	movl   $0x80108032,(%esp)
80103bda:	e8 c1 ca ff ff       	call   801006a0 <cprintf>
  release(&ptable.lock);
80103bdf:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103be6:	e8 45 12 00 00       	call   80104e30 <release>
}
80103beb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bee:	83 c4 10             	add    $0x10,%esp
80103bf1:	c9                   	leave  
80103bf2:	c3                   	ret    
    panic("userinit: out of memory?");
80103bf3:	83 ec 0c             	sub    $0xc,%esp
80103bf6:	68 0e 80 10 80       	push   $0x8010800e
80103bfb:	e8 80 c7 ff ff       	call   80100380 <panic>

80103c00 <growproc>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	56                   	push   %esi
80103c04:	53                   	push   %ebx
80103c05:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c08:	e8 33 11 00 00       	call   80104d40 <pushcli>
  c = mycpu();
80103c0d:	e8 3e fe ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80103c12:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c18:	e8 73 11 00 00       	call   80104d90 <popcli>
  sz = curproc->sz;
80103c1d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c1f:	85 f6                	test   %esi,%esi
80103c21:	7f 1d                	jg     80103c40 <growproc+0x40>
  } else if(n < 0){
80103c23:	75 3b                	jne    80103c60 <growproc+0x60>
  switchuvm(curproc);
80103c25:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c28:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c2a:	53                   	push   %ebx
80103c2b:	e8 a0 36 00 00       	call   801072d0 <switchuvm>
  return 0;
80103c30:	83 c4 10             	add    $0x10,%esp
80103c33:	31 c0                	xor    %eax,%eax
}
80103c35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c38:	5b                   	pop    %ebx
80103c39:	5e                   	pop    %esi
80103c3a:	5d                   	pop    %ebp
80103c3b:	c3                   	ret    
80103c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c40:	83 ec 04             	sub    $0x4,%esp
80103c43:	01 c6                	add    %eax,%esi
80103c45:	56                   	push   %esi
80103c46:	50                   	push   %eax
80103c47:	ff 73 08             	push   0x8(%ebx)
80103c4a:	e8 01 39 00 00       	call   80107550 <allocuvm>
80103c4f:	83 c4 10             	add    $0x10,%esp
80103c52:	85 c0                	test   %eax,%eax
80103c54:	75 cf                	jne    80103c25 <growproc+0x25>
      return -1;
80103c56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c5b:	eb d8                	jmp    80103c35 <growproc+0x35>
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c60:	83 ec 04             	sub    $0x4,%esp
80103c63:	01 c6                	add    %eax,%esi
80103c65:	56                   	push   %esi
80103c66:	50                   	push   %eax
80103c67:	ff 73 08             	push   0x8(%ebx)
80103c6a:	e8 11 3a 00 00       	call   80107680 <deallocuvm>
80103c6f:	83 c4 10             	add    $0x10,%esp
80103c72:	85 c0                	test   %eax,%eax
80103c74:	75 af                	jne    80103c25 <growproc+0x25>
80103c76:	eb de                	jmp    80103c56 <growproc+0x56>
80103c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c7f:	90                   	nop

80103c80 <fork>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
80103c85:	53                   	push   %ebx
80103c86:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c89:	e8 b2 10 00 00       	call   80104d40 <pushcli>
  c = mycpu();
80103c8e:	e8 bd fd ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80103c93:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c99:	e8 f2 10 00 00       	call   80104d90 <popcli>
  struct thread *curt = &curproc->threads[curproc->curtidx];
80103c9e:	8b 83 70 08 00 00    	mov    0x870(%ebx),%eax
80103ca4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((np = allocproc()) == 0){
80103ca7:	e8 84 fb ff ff       	call   80103830 <allocproc>
80103cac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103caf:	85 c0                	test   %eax,%eax
80103cb1:	0f 84 e2 00 00 00    	je     80103d99 <fork+0x119>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103cb7:	83 ec 08             	sub    $0x8,%esp
80103cba:	ff 33                	push   (%ebx)
80103cbc:	89 c7                	mov    %eax,%edi
80103cbe:	ff 73 08             	push   0x8(%ebx)
80103cc1:	e8 5a 3b 00 00       	call   80107820 <copyuvm>
80103cc6:	83 c4 10             	add    $0x10,%esp
80103cc9:	89 47 08             	mov    %eax,0x8(%edi)
80103ccc:	85 c0                	test   %eax,%eax
80103cce:	0f 84 cc 00 00 00    	je     80103da0 <fork+0x120>
  np->sz = curproc->sz;
80103cd4:	8b 03                	mov    (%ebx),%eax
80103cd6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *ndt->tf = *curt->tf;
80103cd9:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103cde:	89 02                	mov    %eax,(%edx)
  *ndt->tf = *curt->tf;
80103ce0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  np->parent = curproc;
80103ce3:	89 5a 14             	mov    %ebx,0x14(%edx)
  *ndt->tf = *curt->tf;
80103ce6:	8b 7a 7c             	mov    0x7c(%edx),%edi
  np->curtidx = 0;
80103ce9:	c7 82 70 08 00 00 00 	movl   $0x0,0x870(%edx)
80103cf0:	00 00 00 
  *ndt->tf = *curt->tf;
80103cf3:	c1 e0 05             	shl    $0x5,%eax
80103cf6:	8b 74 03 7c          	mov    0x7c(%ebx,%eax,1),%esi
  ndt->ustackp = curt->ustackp;
80103cfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  *ndt->tf = *curt->tf;
80103cfd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  ndt->tf->eax = 0;
80103cff:	89 d7                	mov    %edx,%edi
  for(i = 0; i < NOFILE; i++)
80103d01:	31 f6                	xor    %esi,%esi
  ndt->ustackp = curt->ustackp;
80103d03:	c1 e0 05             	shl    $0x5,%eax
80103d06:	8b 84 18 84 00 00 00 	mov    0x84(%eax,%ebx,1),%eax
80103d0d:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  ndt->tf->eax = 0;
80103d13:	8b 42 7c             	mov    0x7c(%edx),%eax
80103d16:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80103d20:	8b 44 b3 1c          	mov    0x1c(%ebx,%esi,4),%eax
80103d24:	85 c0                	test   %eax,%eax
80103d26:	74 10                	je     80103d38 <fork+0xb8>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d28:	83 ec 0c             	sub    $0xc,%esp
80103d2b:	50                   	push   %eax
80103d2c:	e8 ef d1 ff ff       	call   80100f20 <filedup>
80103d31:	83 c4 10             	add    $0x10,%esp
80103d34:	89 44 b7 1c          	mov    %eax,0x1c(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d38:	83 c6 01             	add    $0x1,%esi
80103d3b:	83 fe 10             	cmp    $0x10,%esi
80103d3e:	75 e0                	jne    80103d20 <fork+0xa0>
  np->cwd = idup(curproc->cwd);
80103d40:	83 ec 0c             	sub    $0xc,%esp
80103d43:	ff 73 5c             	push   0x5c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d46:	83 c3 60             	add    $0x60,%ebx
  np->cwd = idup(curproc->cwd);
80103d49:	e8 82 da ff ff       	call   801017d0 <idup>
80103d4e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d51:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d54:	89 47 5c             	mov    %eax,0x5c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d57:	8d 47 60             	lea    0x60(%edi),%eax
80103d5a:	6a 10                	push   $0x10
80103d5c:	53                   	push   %ebx
80103d5d:	50                   	push   %eax
80103d5e:	e8 ad 13 00 00       	call   80105110 <safestrcpy>
  pid = np->pid;
80103d63:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d66:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d6d:	e8 1e 11 00 00       	call   80104e90 <acquire>
  np->state = RUNNABLE;
80103d72:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  ndt->state = RUNNABLE;
80103d79:	c7 47 70 03 00 00 00 	movl   $0x3,0x70(%edi)
  release(&ptable.lock);
80103d80:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d87:	e8 a4 10 00 00       	call   80104e30 <release>
  return pid;
80103d8c:	83 c4 10             	add    $0x10,%esp
}
80103d8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d92:	89 d8                	mov    %ebx,%eax
80103d94:	5b                   	pop    %ebx
80103d95:	5e                   	pop    %esi
80103d96:	5f                   	pop    %edi
80103d97:	5d                   	pop    %ebp
80103d98:	c3                   	ret    
    return -1;
80103d99:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d9e:	eb ef                	jmp    80103d8f <fork+0x10f>
    kfree(ndt->kstack);
80103da0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103da3:	83 ec 0c             	sub    $0xc,%esp
80103da6:	ff 73 78             	push   0x78(%ebx)
80103da9:	e8 92 e7 ff ff       	call   80102540 <kfree>
    ndt->kstack = 0;
80103dae:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
    return -1;
80103db5:	83 c4 10             	add    $0x10,%esp
	ndt->ustackp = 0;
80103db8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103dbf:	00 00 00 
    np->state = UNUSED;
80103dc2:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
	ndt->state = UNUSED;
80103dc9:	c7 43 70 00 00 00 00 	movl   $0x0,0x70(%ebx)
    return -1;
80103dd0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103dd5:	eb b8                	jmp    80103d8f <fork+0x10f>
80103dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dde:	66 90                	xchg   %ax,%ax

80103de0 <scheduler>:
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	57                   	push   %edi
80103de4:	56                   	push   %esi
80103de5:	53                   	push   %ebx
80103de6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103de9:	e8 62 fc ff ff       	call   80103a50 <mycpu>
  c->proc = 0;
80103dee:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103df5:	00 00 00 
  struct cpu *c = mycpu();
80103df8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103dfa:	8d 40 04             	lea    0x4(%eax),%eax
80103dfd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103e00:	fb                   	sti    
    acquire(&ptable.lock);
80103e01:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e04:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
    acquire(&ptable.lock);
80103e09:	68 20 2d 11 80       	push   $0x80112d20
80103e0e:	e8 7d 10 00 00       	call   80104e90 <acquire>
80103e13:	83 c4 10             	add    $0x10,%esp
80103e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e1d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103e20:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103e24:	0f 85 a1 00 00 00    	jne    80103ecb <scheduler+0xeb>
      c->proc = p;
80103e2a:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
  for(i= p->curtidx + 1; i < NTHREAD; i++){
80103e30:	8b 8f 70 08 00 00    	mov    0x870(%edi),%ecx
80103e36:	8d 59 01             	lea    0x1(%ecx),%ebx
80103e39:	83 fb 3f             	cmp    $0x3f,%ebx
80103e3c:	7e 16                	jle    80103e54 <scheduler+0x74>
80103e3e:	e9 b5 00 00 00       	jmp    80103ef8 <scheduler+0x118>
80103e43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e47:	90                   	nop
80103e48:	83 c3 01             	add    $0x1,%ebx
80103e4b:	83 fb 40             	cmp    $0x40,%ebx
80103e4e:	0f 84 a4 00 00 00    	je     80103ef8 <scheduler+0x118>
	if(p->threads[i].state == RUNNABLE){
80103e54:	89 d8                	mov    %ebx,%eax
80103e56:	c1 e0 05             	shl    $0x5,%eax
80103e59:	83 7c 07 70 03       	cmpl   $0x3,0x70(%edi,%eax,1)
80103e5e:	75 e8                	jne    80103e48 <scheduler+0x68>
  if(next == -1){
80103e60:	83 fb ff             	cmp    $0xffffffff,%ebx
80103e63:	0f 84 8f 00 00 00    	je     80103ef8 <scheduler+0x118>
      switchuvm(p);
80103e69:	83 ec 0c             	sub    $0xc,%esp
	  p->curtidx = next;
80103e6c:	89 9f 70 08 00 00    	mov    %ebx,0x870(%edi)
      switchuvm(p);
80103e72:	57                   	push   %edi
80103e73:	e8 58 34 00 00       	call   801072d0 <switchuvm>
	  t->state = RUNNING;
80103e78:	89 d8                	mov    %ebx,%eax
	  cprintf("scheduled p:%d, t:%d\n", p->pid, t->tid);
80103e7a:	83 c4 0c             	add    $0xc,%esp
      swtch(&(c->scheduler), t->context);
80103e7d:	c1 e3 05             	shl    $0x5,%ebx
	  t->state = RUNNING;
80103e80:	c1 e0 05             	shl    $0x5,%eax
80103e83:	01 f8                	add    %edi,%eax
80103e85:	c7 40 70 04 00 00 00 	movl   $0x4,0x70(%eax)
	  cprintf("scheduled p:%d, t:%d\n", p->pid, t->tid);
80103e8c:	ff 70 74             	push   0x74(%eax)
80103e8f:	ff 77 10             	push   0x10(%edi)
80103e92:	68 48 80 10 80       	push   $0x80108048
80103e97:	e8 04 c8 ff ff       	call   801006a0 <cprintf>
      swtch(&(c->scheduler), t->context);
80103e9c:	58                   	pop    %eax
80103e9d:	5a                   	pop    %edx
80103e9e:	ff b4 3b 80 00 00 00 	push   0x80(%ebx,%edi,1)
80103ea5:	ff 75 e4             	push   -0x1c(%ebp)
80103ea8:	e8 be 12 00 00       	call   8010516b <swtch>
      switchkvm();
80103ead:	e8 0e 34 00 00       	call   801072c0 <switchkvm>
	  cprintf("switchkvm() succeed\n");
80103eb2:	c7 04 24 5e 80 10 80 	movl   $0x8010805e,(%esp)
80103eb9:	e8 e2 c7 ff ff       	call   801006a0 <cprintf>
      c->proc = 0;
80103ebe:	83 c4 10             	add    $0x10,%esp
80103ec1:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ec8:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ecb:	81 c7 74 08 00 00    	add    $0x874,%edi
80103ed1:	81 ff 54 4a 13 80    	cmp    $0x80134a54,%edi
80103ed7:	0f 85 43 ff ff ff    	jne    80103e20 <scheduler+0x40>
    release(&ptable.lock);
80103edd:	83 ec 0c             	sub    $0xc,%esp
80103ee0:	68 20 2d 11 80       	push   $0x80112d20
80103ee5:	e8 46 0f 00 00       	call   80104e30 <release>
    sti();
80103eea:	83 c4 10             	add    $0x10,%esp
80103eed:	e9 0e ff ff ff       	jmp    80103e00 <scheduler+0x20>
80103ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	for(i = 0; i < p->curtidx + 1; i++){
80103ef8:	85 c9                	test   %ecx,%ecx
80103efa:	78 cf                	js     80103ecb <scheduler+0xeb>
80103efc:	31 db                	xor    %ebx,%ebx
80103efe:	eb 07                	jmp    80103f07 <scheduler+0x127>
80103f00:	83 c3 01             	add    $0x1,%ebx
80103f03:	39 d9                	cmp    %ebx,%ecx
80103f05:	7c c4                	jl     80103ecb <scheduler+0xeb>
	  if(p->threads[i].state == RUNNABLE){
80103f07:	89 d8                	mov    %ebx,%eax
80103f09:	c1 e0 05             	shl    $0x5,%eax
80103f0c:	83 7c 07 70 03       	cmpl   $0x3,0x70(%edi,%eax,1)
80103f11:	75 ed                	jne    80103f00 <scheduler+0x120>
80103f13:	e9 51 ff ff ff       	jmp    80103e69 <scheduler+0x89>
80103f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f1f:	90                   	nop

80103f20 <sched>:
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	57                   	push   %edi
80103f24:	56                   	push   %esi
80103f25:	53                   	push   %ebx
80103f26:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103f29:	e8 12 0e 00 00       	call   80104d40 <pushcli>
  c = mycpu();
80103f2e:	e8 1d fb ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80103f33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f39:	e8 52 0e 00 00       	call   80104d90 <popcli>
  if(!holding(&ptable.lock))
80103f3e:	83 ec 0c             	sub    $0xc,%esp
  struct thread *t = &p->threads[p->curtidx];
80103f41:	8b b3 70 08 00 00    	mov    0x870(%ebx),%esi
  if(!holding(&ptable.lock))
80103f47:	68 20 2d 11 80       	push   $0x80112d20
80103f4c:	e8 9f 0e 00 00       	call   80104df0 <holding>
80103f51:	83 c4 10             	add    $0x10,%esp
80103f54:	85 c0                	test   %eax,%eax
80103f56:	74 59                	je     80103fb1 <sched+0x91>
  if(mycpu()->ncli != 1)
80103f58:	e8 f3 fa ff ff       	call   80103a50 <mycpu>
80103f5d:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f64:	0f 85 82 00 00 00    	jne    80103fec <sched+0xcc>
  if(p->state == RUNNING){
80103f6a:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f6e:	74 5b                	je     80103fcb <sched+0xab>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f70:	9c                   	pushf  
80103f71:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f72:	f6 c4 02             	test   $0x2,%ah
80103f75:	75 47                	jne    80103fbe <sched+0x9e>
  intena = mycpu()->intena;
80103f77:	e8 d4 fa ff ff       	call   80103a50 <mycpu>
  swtch(&t->context, mycpu()->scheduler);
80103f7c:	83 c6 04             	add    $0x4,%esi
80103f7f:	c1 e6 05             	shl    $0x5,%esi
  intena = mycpu()->intena;
80103f82:	8b b8 a8 00 00 00    	mov    0xa8(%eax),%edi
  swtch(&t->context, mycpu()->scheduler);
80103f88:	e8 c3 fa ff ff       	call   80103a50 <mycpu>
80103f8d:	01 f3                	add    %esi,%ebx
80103f8f:	83 ec 08             	sub    $0x8,%esp
80103f92:	ff 70 04             	push   0x4(%eax)
80103f95:	53                   	push   %ebx
80103f96:	e8 d0 11 00 00       	call   8010516b <swtch>
  mycpu()->intena = intena;
80103f9b:	e8 b0 fa ff ff       	call   80103a50 <mycpu>
}
80103fa0:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103fa3:	89 b8 a8 00 00 00    	mov    %edi,0xa8(%eax)
}
80103fa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fac:	5b                   	pop    %ebx
80103fad:	5e                   	pop    %esi
80103fae:	5f                   	pop    %edi
80103faf:	5d                   	pop    %ebp
80103fb0:	c3                   	ret    
    panic("sched ptable.lock");
80103fb1:	83 ec 0c             	sub    $0xc,%esp
80103fb4:	68 73 80 10 80       	push   $0x80108073
80103fb9:	e8 c2 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103fbe:	83 ec 0c             	sub    $0xc,%esp
80103fc1:	68 ad 80 10 80       	push   $0x801080ad
80103fc6:	e8 b5 c3 ff ff       	call   80100380 <panic>
	cprintf("p: %d, t: %d\n", p->pid, t->tid);
80103fcb:	c1 e6 05             	shl    $0x5,%esi
80103fce:	50                   	push   %eax
80103fcf:	ff 74 33 74          	push   0x74(%ebx,%esi,1)
80103fd3:	ff 73 10             	push   0x10(%ebx)
80103fd6:	68 91 80 10 80       	push   $0x80108091
80103fdb:	e8 c0 c6 ff ff       	call   801006a0 <cprintf>
    panic("sched running");
80103fe0:	c7 04 24 9f 80 10 80 	movl   $0x8010809f,(%esp)
80103fe7:	e8 94 c3 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103fec:	83 ec 0c             	sub    $0xc,%esp
80103fef:	68 85 80 10 80       	push   $0x80108085
80103ff4:	e8 87 c3 ff ff       	call   80100380 <panic>
80103ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104000 <exit>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	57                   	push   %edi
80104004:	56                   	push   %esi
80104005:	53                   	push   %ebx
80104006:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104009:	e8 c2 fa ff ff       	call   80103ad0 <myproc>
  if(curproc == initproc)
8010400e:	39 05 54 4a 13 80    	cmp    %eax,0x80134a54
80104014:	0f 84 ec 00 00 00    	je     80104106 <exit+0x106>
8010401a:	89 c6                	mov    %eax,%esi
8010401c:	8d 58 1c             	lea    0x1c(%eax),%ebx
8010401f:	8d 78 5c             	lea    0x5c(%eax),%edi
80104022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104028:	8b 03                	mov    (%ebx),%eax
8010402a:	85 c0                	test   %eax,%eax
8010402c:	74 12                	je     80104040 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010402e:	83 ec 0c             	sub    $0xc,%esp
80104031:	50                   	push   %eax
80104032:	e8 39 cf ff ff       	call   80100f70 <fileclose>
      curproc->ofile[fd] = 0;
80104037:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010403d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104040:	83 c3 04             	add    $0x4,%ebx
80104043:	39 fb                	cmp    %edi,%ebx
80104045:	75 e1                	jne    80104028 <exit+0x28>
  begin_op();
80104047:	e8 94 ed ff ff       	call   80102de0 <begin_op>
  iput(curproc->cwd);
8010404c:	83 ec 0c             	sub    $0xc,%esp
8010404f:	ff 76 5c             	push   0x5c(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104052:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  iput(curproc->cwd);
80104057:	e8 d4 d8 ff ff       	call   80101930 <iput>
  end_op();
8010405c:	e8 ef ed ff ff       	call   80102e50 <end_op>
  curproc->cwd = 0;
80104061:	c7 46 5c 00 00 00 00 	movl   $0x0,0x5c(%esi)
  acquire(&ptable.lock);
80104068:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010406f:	e8 1c 0e 00 00       	call   80104e90 <acquire>
  wakeup1(curproc->parent);
80104074:	8b 46 14             	mov    0x14(%esi),%eax
80104077:	e8 44 f9 ff ff       	call   801039c0 <wakeup1>
8010407c:	83 c4 10             	add    $0x10,%esp
8010407f:	eb 15                	jmp    80104096 <exit+0x96>
80104081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104088:	81 c3 74 08 00 00    	add    $0x874,%ebx
8010408e:	81 fb 54 4a 13 80    	cmp    $0x80134a54,%ebx
80104094:	74 2a                	je     801040c0 <exit+0xc0>
    if(p->parent == curproc){
80104096:	39 73 14             	cmp    %esi,0x14(%ebx)
80104099:	75 ed                	jne    80104088 <exit+0x88>
      p->parent = initproc;
8010409b:	a1 54 4a 13 80       	mov    0x80134a54,%eax
      if(p->state == ZOMBIE)
801040a0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
      p->parent = initproc;
801040a4:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
801040a7:	75 df                	jne    80104088 <exit+0x88>
        wakeup1(initproc);
801040a9:	e8 12 f9 ff ff       	call   801039c0 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040ae:	81 c3 74 08 00 00    	add    $0x874,%ebx
801040b4:	81 fb 54 4a 13 80    	cmp    $0x80134a54,%ebx
801040ba:	75 da                	jne    80104096 <exit+0x96>
801040bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
801040c0:	b8 c4 4a 13 80       	mov    $0x80134ac4,%eax
801040c5:	8d 76 00             	lea    0x0(%esi),%esi
	if(t->state != UNUSED)
801040c8:	8b 10                	mov    (%eax),%edx
801040ca:	85 d2                	test   %edx,%edx
801040cc:	74 06                	je     801040d4 <exit+0xd4>
	  t->state = ZOMBIE;
801040ce:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
801040d4:	83 c0 20             	add    $0x20,%eax
801040d7:	3d c4 52 13 80       	cmp    $0x801352c4,%eax
801040dc:	75 ea                	jne    801040c8 <exit+0xc8>
  cprintf("exit(): p%d\n", curproc->pid);
801040de:	83 ec 08             	sub    $0x8,%esp
  curproc->state = ZOMBIE;
801040e1:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  cprintf("exit(): p%d\n", curproc->pid);
801040e8:	ff 76 10             	push   0x10(%esi)
801040eb:	68 ce 80 10 80       	push   $0x801080ce
801040f0:	e8 ab c5 ff ff       	call   801006a0 <cprintf>
  sched();
801040f5:	e8 26 fe ff ff       	call   80103f20 <sched>
  panic("zombie exit");
801040fa:	c7 04 24 db 80 10 80 	movl   $0x801080db,(%esp)
80104101:	e8 7a c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104106:	83 ec 0c             	sub    $0xc,%esp
80104109:	68 c1 80 10 80       	push   $0x801080c1
8010410e:	e8 6d c2 ff ff       	call   80100380 <panic>
80104113:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010411a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104120 <yield>:
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	56                   	push   %esi
80104124:	53                   	push   %ebx
  acquire(&ptable.lock);  //DOC: yieldlock
80104125:	83 ec 0c             	sub    $0xc,%esp
80104128:	68 20 2d 11 80       	push   $0x80112d20
8010412d:	e8 5e 0d 00 00       	call   80104e90 <acquire>
  pushcli();
80104132:	e8 09 0c 00 00       	call   80104d40 <pushcli>
  c = mycpu();
80104137:	e8 14 f9 ff ff       	call   80103a50 <mycpu>
  p = c->proc;
8010413c:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104142:	e8 49 0c 00 00       	call   80104d90 <popcli>
  pushcli();
80104147:	e8 f4 0b 00 00       	call   80104d40 <pushcli>
  c = mycpu();
8010414c:	e8 ff f8 ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80104151:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104157:	e8 34 0c 00 00       	call   80104d90 <popcli>
  struct thread *t = &myproc()->threads[myproc()->curtidx];
8010415c:	8b 86 70 08 00 00    	mov    0x870(%esi),%eax
  t->state = RUNNABLE;
80104162:	c1 e0 05             	shl    $0x5,%eax
80104165:	c7 44 03 70 03 00 00 	movl   $0x3,0x70(%ebx,%eax,1)
8010416c:	00 
  pushcli();
8010416d:	e8 ce 0b 00 00       	call   80104d40 <pushcli>
  c = mycpu();
80104172:	e8 d9 f8 ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80104177:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010417d:	e8 0e 0c 00 00       	call   80104d90 <popcli>
  myproc()->state = RUNNABLE;
80104182:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104189:	e8 92 fd ff ff       	call   80103f20 <sched>
  release(&ptable.lock);
8010418e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104195:	e8 96 0c 00 00       	call   80104e30 <release>
}
8010419a:	83 c4 10             	add    $0x10,%esp
8010419d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041a0:	5b                   	pop    %ebx
801041a1:	5e                   	pop    %esi
801041a2:	5d                   	pop    %ebp
801041a3:	c3                   	ret    
801041a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041af:	90                   	nop

801041b0 <sleep>:
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	57                   	push   %edi
801041b4:	56                   	push   %esi
801041b5:	53                   	push   %ebx
801041b6:	83 ec 1c             	sub    $0x1c,%esp
801041b9:	8b 45 08             	mov    0x8(%ebp),%eax
801041bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801041bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pushcli();
801041c2:	e8 79 0b 00 00       	call   80104d40 <pushcli>
  c = mycpu();
801041c7:	e8 84 f8 ff ff       	call   80103a50 <mycpu>
  p = c->proc;
801041cc:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
801041d2:	e8 b9 0b 00 00       	call   80104d90 <popcli>
  if(p == 0)
801041d7:	85 ff                	test   %edi,%edi
801041d9:	0f 84 be 00 00 00    	je     8010429d <sleep+0xed>
  struct thread *t = &p->threads[p->curtidx];
801041df:	8b b7 70 08 00 00    	mov    0x870(%edi),%esi
  if(lk == 0)
801041e5:	85 db                	test   %ebx,%ebx
801041e7:	0f 84 a3 00 00 00    	je     80104290 <sleep+0xe0>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041ed:	81 fb 20 2d 11 80    	cmp    $0x80112d20,%ebx
801041f3:	74 18                	je     8010420d <sleep+0x5d>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041f5:	83 ec 0c             	sub    $0xc,%esp
801041f8:	68 20 2d 11 80       	push   $0x80112d20
801041fd:	e8 8e 0c 00 00       	call   80104e90 <acquire>
    release(lk);
80104202:	89 1c 24             	mov    %ebx,(%esp)
80104205:	e8 26 0c 00 00       	call   80104e30 <release>
8010420a:	83 c4 10             	add    $0x10,%esp
  t->chan = chan;
8010420d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104210:	c1 e6 05             	shl    $0x5,%esi
80104213:	8d 97 70 08 00 00    	lea    0x870(%edi),%edx
80104219:	01 fe                	add    %edi,%esi
8010421b:	89 86 88 00 00 00    	mov    %eax,0x88(%esi)
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80104221:	8d 47 70             	lea    0x70(%edi),%eax
  t->state = SLEEPING;
80104224:	c7 46 70 02 00 00 00 	movl   $0x2,0x70(%esi)
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
8010422b:	eb 0a                	jmp    80104237 <sleep+0x87>
8010422d:	8d 76 00             	lea    0x0(%esi),%esi
80104230:	83 c0 20             	add    $0x20,%eax
80104233:	39 c2                	cmp    %eax,%edx
80104235:	74 41                	je     80104278 <sleep+0xc8>
	if(t->state != UNUSED && t->state != SLEEPING){
80104237:	f7 00 fd ff ff ff    	testl  $0xfffffffd,(%eax)
8010423d:	74 f1                	je     80104230 <sleep+0x80>
  sched();
8010423f:	e8 dc fc ff ff       	call   80103f20 <sched>
  t->chan = 0;
80104244:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
8010424b:	00 00 00 
  if(lk != &ptable.lock){  //DOC: sleeplock2
8010424e:	81 fb 20 2d 11 80    	cmp    $0x80112d20,%ebx
80104254:	74 32                	je     80104288 <sleep+0xd8>
    release(&ptable.lock);
80104256:	83 ec 0c             	sub    $0xc,%esp
80104259:	68 20 2d 11 80       	push   $0x80112d20
8010425e:	e8 cd 0b 00 00       	call   80104e30 <release>
    acquire(lk);
80104263:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104266:	83 c4 10             	add    $0x10,%esp
}
80104269:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010426c:	5b                   	pop    %ebx
8010426d:	5e                   	pop    %esi
8010426e:	5f                   	pop    %edi
8010426f:	5d                   	pop    %ebp
    acquire(lk);
80104270:	e9 1b 0c 00 00       	jmp    80104e90 <acquire>
80104275:	8d 76 00             	lea    0x0(%esi),%esi
	p->state = SLEEPING;
80104278:	c7 47 0c 02 00 00 00 	movl   $0x2,0xc(%edi)
8010427f:	eb be                	jmp    8010423f <sleep+0x8f>
80104281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80104288:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010428b:	5b                   	pop    %ebx
8010428c:	5e                   	pop    %esi
8010428d:	5f                   	pop    %edi
8010428e:	5d                   	pop    %ebp
8010428f:	c3                   	ret    
    panic("sleep without lk");
80104290:	83 ec 0c             	sub    $0xc,%esp
80104293:	68 f1 80 10 80       	push   $0x801080f1
80104298:	e8 e3 c0 ff ff       	call   80100380 <panic>
    panic("sleep (p)");
8010429d:	83 ec 0c             	sub    $0xc,%esp
801042a0:	68 e7 80 10 80       	push   $0x801080e7
801042a5:	e8 d6 c0 ff ff       	call   80100380 <panic>
801042aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042b0 <wait>:
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	57                   	push   %edi
801042b4:	56                   	push   %esi
801042b5:	53                   	push   %ebx
801042b6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801042b9:	e8 82 0a 00 00       	call   80104d40 <pushcli>
  c = mycpu();
801042be:	e8 8d f7 ff ff       	call   80103a50 <mycpu>
  p = c->proc;
801042c3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042c9:	e8 c2 0a 00 00       	call   80104d90 <popcli>
  acquire(&ptable.lock);
801042ce:	83 ec 0c             	sub    $0xc,%esp
801042d1:	68 20 2d 11 80       	push   $0x80112d20
801042d6:	e8 b5 0b 00 00       	call   80104e90 <acquire>
801042db:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801042de:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042e0:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
801042e5:	eb 17                	jmp    801042fe <wait+0x4e>
801042e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ee:	66 90                	xchg   %ax,%ax
801042f0:	81 c7 74 08 00 00    	add    $0x874,%edi
801042f6:	81 ff 54 4a 13 80    	cmp    $0x80134a54,%edi
801042fc:	74 1e                	je     8010431c <wait+0x6c>
      if(p->parent != curproc)
801042fe:	39 5f 14             	cmp    %ebx,0x14(%edi)
80104301:	75 ed                	jne    801042f0 <wait+0x40>
      if(p->state == ZOMBIE){
80104303:	83 7f 0c 05          	cmpl   $0x5,0xc(%edi)
80104307:	74 3f                	je     80104348 <wait+0x98>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104309:	81 c7 74 08 00 00    	add    $0x874,%edi
      havekids = 1;
8010430f:	ba 01 00 00 00       	mov    $0x1,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104314:	81 ff 54 4a 13 80    	cmp    $0x80134a54,%edi
8010431a:	75 e2                	jne    801042fe <wait+0x4e>
    if(!havekids || curproc->killed){
8010431c:	85 d2                	test   %edx,%edx
8010431e:	0f 84 03 01 00 00    	je     80104427 <wait+0x177>
80104324:	8b 43 18             	mov    0x18(%ebx),%eax
80104327:	85 c0                	test   %eax,%eax
80104329:	0f 85 f8 00 00 00    	jne    80104427 <wait+0x177>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010432f:	83 ec 08             	sub    $0x8,%esp
80104332:	68 20 2d 11 80       	push   $0x80112d20
80104337:	53                   	push   %ebx
80104338:	e8 73 fe ff ff       	call   801041b0 <sleep>
    havekids = 0;
8010433d:	83 c4 10             	add    $0x10,%esp
80104340:	eb 9c                	jmp    801042de <wait+0x2e>
80104342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        pid = p->pid;
80104348:	8b 47 10             	mov    0x10(%edi),%eax
8010434b:	8d 5f 70             	lea    0x70(%edi),%ebx
8010434e:	8d b7 70 08 00 00    	lea    0x870(%edi),%esi
80104354:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(int i = 0; i < NTHREAD; i++){
80104357:	eb 43                	jmp    8010439c <wait+0xec>
80104359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(t->kstack == 0){
	cprintf("tclear(): kstack not found\n");
	return 0;
  }

  kfree(t->kstack);
80104360:	83 ec 0c             	sub    $0xc,%esp
80104363:	52                   	push   %edx
80104364:	e8 d7 e1 ff ff       	call   80102540 <kfree>
  t->kstack = 0;
80104369:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  t->ustackp = 0;
  t->tid = 0;
  t->state = UNUSED;
  t->chan = 0;
  t->ret = 0;
80104370:	83 c4 10             	add    $0x10,%esp
  t->ustackp = 0;
80104373:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  t->tid = 0;
8010437a:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  t->state = UNUSED;
80104381:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  t->chan = 0;
80104387:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
  t->ret = 0;
8010438e:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
		for(int i = 0; i < NTHREAD; i++){
80104395:	83 c3 20             	add    $0x20,%ebx
80104398:	39 f3                	cmp    %esi,%ebx
8010439a:	74 2c                	je     801043c8 <wait+0x118>
  if(t->state == UNUSED)
8010439c:	8b 03                	mov    (%ebx),%eax
8010439e:	85 c0                	test   %eax,%eax
801043a0:	74 f3                	je     80104395 <wait+0xe5>
  if(t->kstack == 0){
801043a2:	8b 53 08             	mov    0x8(%ebx),%edx
801043a5:	85 d2                	test   %edx,%edx
801043a7:	75 b7                	jne    80104360 <wait+0xb0>
	cprintf("tclear(): kstack not found\n");
801043a9:	83 ec 0c             	sub    $0xc,%esp
801043ac:	68 02 81 10 80       	push   $0x80108102
801043b1:	e8 ea c2 ff ff       	call   801006a0 <cprintf>
			  panic("wait(): tclear error\n");
801043b6:	c7 04 24 1e 81 10 80 	movl   $0x8010811e,(%esp)
801043bd:	e8 be bf ff ff       	call   80100380 <panic>
801043c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        freevm(p->pgdir); // t->ustack are also freed
801043c8:	83 ec 0c             	sub    $0xc,%esp
801043cb:	ff 77 08             	push   0x8(%edi)
801043ce:	e8 dd 32 00 00       	call   801076b0 <freevm>
		cprintf("wait(): %d before release\n", p->pid);
801043d3:	5a                   	pop    %edx
801043d4:	59                   	pop    %ecx
801043d5:	6a 00                	push   $0x0
801043d7:	68 34 81 10 80       	push   $0x80108134
        p->pid = 0;
801043dc:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
        p->parent = 0;
801043e3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
        p->name[0] = 0;
801043ea:	c6 47 60 00          	movb   $0x0,0x60(%edi)
        p->killed = 0;
801043ee:	c7 47 18 00 00 00 00 	movl   $0x0,0x18(%edi)
        p->state = UNUSED;
801043f5:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
		cprintf("wait(): %d before release\n", p->pid);
801043fc:	e8 9f c2 ff ff       	call   801006a0 <cprintf>
        release(&ptable.lock);
80104401:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104408:	e8 23 0a 00 00       	call   80104e30 <release>
		cprintf("d\n");
8010440d:	c7 04 24 9c 80 10 80 	movl   $0x8010809c,(%esp)
80104414:	e8 87 c2 ff ff       	call   801006a0 <cprintf>
        return pid;
80104419:	83 c4 10             	add    $0x10,%esp
}
8010441c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010441f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104422:	5b                   	pop    %ebx
80104423:	5e                   	pop    %esi
80104424:	5f                   	pop    %edi
80104425:	5d                   	pop    %ebp
80104426:	c3                   	ret    
      release(&ptable.lock);
80104427:	83 ec 0c             	sub    $0xc,%esp
8010442a:	68 20 2d 11 80       	push   $0x80112d20
8010442f:	e8 fc 09 00 00       	call   80104e30 <release>
      return -1;
80104434:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
8010443b:	83 c4 10             	add    $0x10,%esp
8010443e:	eb dc                	jmp    8010441c <wait+0x16c>

80104440 <wakeup>:
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	53                   	push   %ebx
80104444:	83 ec 10             	sub    $0x10,%esp
80104447:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010444a:	68 20 2d 11 80       	push   $0x80112d20
8010444f:	e8 3c 0a 00 00       	call   80104e90 <acquire>
  wakeup1(chan);
80104454:	89 d8                	mov    %ebx,%eax
80104456:	e8 65 f5 ff ff       	call   801039c0 <wakeup1>
  release(&ptable.lock);
8010445b:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104462:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&ptable.lock);
80104465:	83 c4 10             	add    $0x10,%esp
}
80104468:	c9                   	leave  
  release(&ptable.lock);
80104469:	e9 c2 09 00 00       	jmp    80104e30 <release>
8010446e:	66 90                	xchg   %ax,%ax

80104470 <kill>:
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	53                   	push   %ebx
80104474:	83 ec 10             	sub    $0x10,%esp
80104477:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010447a:	68 20 2d 11 80       	push   $0x80112d20
8010447f:	e8 0c 0a 00 00       	call   80104e90 <acquire>
80104484:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104487:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
8010448c:	eb 10                	jmp    8010449e <kill+0x2e>
8010448e:	66 90                	xchg   %ax,%ax
80104490:	81 c2 74 08 00 00    	add    $0x874,%edx
80104496:	81 fa 54 4a 13 80    	cmp    $0x80134a54,%edx
8010449c:	74 50                	je     801044ee <kill+0x7e>
    if(p->pid == pid){
8010449e:	39 5a 10             	cmp    %ebx,0x10(%edx)
801044a1:	75 ed                	jne    80104490 <kill+0x20>
      p->killed = 1;
801044a3:	c7 42 18 01 00 00 00 	movl   $0x1,0x18(%edx)
	  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
801044aa:	8d 42 70             	lea    0x70(%edx),%eax
801044ad:	8d 8a 70 08 00 00    	lea    0x870(%edx),%ecx
801044b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044b7:	90                   	nop
		if(t->state == SLEEPING)
801044b8:	83 38 02             	cmpl   $0x2,(%eax)
801044bb:	75 06                	jne    801044c3 <kill+0x53>
		  t->state = RUNNABLE;
801044bd:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
	  for(t = p->threads; t < &p->threads[NTHREAD]; t++){
801044c3:	83 c0 20             	add    $0x20,%eax
801044c6:	39 c1                	cmp    %eax,%ecx
801044c8:	75 ee                	jne    801044b8 <kill+0x48>
      if(p->state == SLEEPING)
801044ca:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
801044ce:	75 07                	jne    801044d7 <kill+0x67>
        p->state = RUNNABLE;
801044d0:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
      release(&ptable.lock);
801044d7:	83 ec 0c             	sub    $0xc,%esp
801044da:	68 20 2d 11 80       	push   $0x80112d20
801044df:	e8 4c 09 00 00       	call   80104e30 <release>
}
801044e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801044e7:	83 c4 10             	add    $0x10,%esp
801044ea:	31 c0                	xor    %eax,%eax
}
801044ec:	c9                   	leave  
801044ed:	c3                   	ret    
  release(&ptable.lock);
801044ee:	83 ec 0c             	sub    $0xc,%esp
801044f1:	68 20 2d 11 80       	push   $0x80112d20
801044f6:	e8 35 09 00 00       	call   80104e30 <release>
}
801044fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801044fe:	83 c4 10             	add    $0x10,%esp
80104501:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104506:	c9                   	leave  
80104507:	c3                   	ret    
80104508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450f:	90                   	nop

80104510 <procdump>:
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	57                   	push   %edi
80104514:	56                   	push   %esi
80104515:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104518:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104519:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
8010451e:	83 ec 3c             	sub    $0x3c,%esp
80104521:	eb 27                	jmp    8010454a <procdump+0x3a>
80104523:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104527:	90                   	nop
    cprintf("\n");
80104528:	83 ec 0c             	sub    $0xc,%esp
8010452b:	68 41 85 10 80       	push   $0x80108541
80104530:	e8 6b c1 ff ff       	call   801006a0 <cprintf>
80104535:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104538:	81 c3 74 08 00 00    	add    $0x874,%ebx
8010453e:	81 fb 54 4a 13 80    	cmp    $0x80134a54,%ebx
80104544:	0f 84 a6 00 00 00    	je     801045f0 <procdump+0xe0>
    if(p->state == UNUSED)
8010454a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010454d:	85 c0                	test   %eax,%eax
8010454f:	74 e7                	je     80104538 <procdump+0x28>
	t = &p->threads[p->curtidx];
80104551:	8b bb 70 08 00 00    	mov    0x870(%ebx),%edi
    if(t->state >= 0 && t->state < NELEM(states) && states[t->state])
80104557:	89 f8                	mov    %edi,%eax
80104559:	c1 e0 05             	shl    $0x5,%eax
8010455c:	8b 4c 03 70          	mov    0x70(%ebx,%eax,1),%ecx
      state = "???";
80104560:	b8 4f 81 10 80       	mov    $0x8010814f,%eax
    if(t->state >= 0 && t->state < NELEM(states) && states[t->state])
80104565:	83 f9 05             	cmp    $0x5,%ecx
80104568:	77 11                	ja     8010457b <procdump+0x6b>
8010456a:	8b 04 8d 4c 82 10 80 	mov    -0x7fef7db4(,%ecx,4),%eax
      state = "???";
80104571:	b9 4f 81 10 80       	mov    $0x8010814f,%ecx
80104576:	85 c0                	test   %eax,%eax
80104578:	0f 44 c1             	cmove  %ecx,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
8010457b:	8d 4b 60             	lea    0x60(%ebx),%ecx
8010457e:	51                   	push   %ecx
8010457f:	50                   	push   %eax
80104580:	ff 73 10             	push   0x10(%ebx)
80104583:	68 53 81 10 80       	push   $0x80108153
80104588:	e8 13 c1 ff ff       	call   801006a0 <cprintf>
    if(t->state == SLEEPING){
8010458d:	89 f8                	mov    %edi,%eax
8010458f:	83 c4 10             	add    $0x10,%esp
80104592:	c1 e0 05             	shl    $0x5,%eax
80104595:	83 7c 03 70 02       	cmpl   $0x2,0x70(%ebx,%eax,1)
8010459a:	75 8c                	jne    80104528 <procdump+0x18>
      getcallerpcs((uint*)t->context->ebp+2, pc);
8010459c:	89 fa                	mov    %edi,%edx
8010459e:	8d 45 c0             	lea    -0x40(%ebp),%eax
801045a1:	8d 7d c0             	lea    -0x40(%ebp),%edi
801045a4:	83 ec 08             	sub    $0x8,%esp
801045a7:	c1 e2 05             	shl    $0x5,%edx
801045aa:	50                   	push   %eax
801045ab:	8b 84 1a 80 00 00 00 	mov    0x80(%edx,%ebx,1),%eax
801045b2:	8b 40 0c             	mov    0xc(%eax),%eax
801045b5:	83 c0 08             	add    $0x8,%eax
801045b8:	50                   	push   %eax
801045b9:	e8 22 07 00 00       	call   80104ce0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801045be:	83 c4 10             	add    $0x10,%esp
801045c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045c8:	8b 17                	mov    (%edi),%edx
801045ca:	85 d2                	test   %edx,%edx
801045cc:	0f 84 56 ff ff ff    	je     80104528 <procdump+0x18>
        cprintf(" %p", pc[i]);
801045d2:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801045d5:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801045d8:	52                   	push   %edx
801045d9:	68 c1 7a 10 80       	push   $0x80107ac1
801045de:	e8 bd c0 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801045e3:	83 c4 10             	add    $0x10,%esp
801045e6:	39 fe                	cmp    %edi,%esi
801045e8:	75 de                	jne    801045c8 <procdump+0xb8>
801045ea:	e9 39 ff ff ff       	jmp    80104528 <procdump+0x18>
801045ef:	90                   	nop
}
801045f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045f3:	5b                   	pop    %ebx
801045f4:	5e                   	pop    %esi
801045f5:	5f                   	pop    %edi
801045f6:	5d                   	pop    %ebp
801045f7:	c3                   	ret    
801045f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ff:	90                   	nop

80104600 <thread_create>:
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	57                   	push   %edi
80104604:	56                   	push   %esi
80104605:	53                   	push   %ebx
80104606:	81 ec ac 00 00 00    	sub    $0xac,%esp
  pushcli();
8010460c:	e8 2f 07 00 00       	call   80104d40 <pushcli>
  c = mycpu();
80104611:	e8 3a f4 ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80104616:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010461c:	e8 6f 07 00 00       	call   80104d90 <popcli>
  acquire(&ptable.lock);
80104621:	83 ec 0c             	sub    $0xc,%esp
80104624:	68 20 2d 11 80       	push   $0x80112d20
  for(nt = p->threads; nt < &p->threads[NTHREAD]; nt++){
80104629:	8d 5e 70             	lea    0x70(%esi),%ebx
  acquire(&ptable.lock);
8010462c:	e8 5f 08 00 00       	call   80104e90 <acquire>
  for(nt = p->threads; nt < &p->threads[NTHREAD]; nt++){
80104631:	8d 86 70 08 00 00    	lea    0x870(%esi),%eax
80104637:	83 c4 10             	add    $0x10,%esp
8010463a:	eb 0f                	jmp    8010464b <thread_create+0x4b>
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104640:	83 c3 20             	add    $0x20,%ebx
80104643:	39 c3                	cmp    %eax,%ebx
80104645:	0f 84 75 01 00 00    	je     801047c0 <thread_create+0x1c0>
	if(nt->state == UNUSED)
8010464b:	8b 0b                	mov    (%ebx),%ecx
8010464d:	85 c9                	test   %ecx,%ecx
8010464f:	75 ef                	jne    80104640 <thread_create+0x40>
  nt->state = EMBRYO;
80104651:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  nt->tid = nexttid++;
80104657:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  release(&ptable.lock);
8010465c:	83 ec 0c             	sub    $0xc,%esp
  nt->tid = nexttid++;
8010465f:	89 43 04             	mov    %eax,0x4(%ebx)
80104662:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104665:	68 20 2d 11 80       	push   $0x80112d20
  nt->tid = nexttid++;
8010466a:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80104670:	e8 bb 07 00 00       	call   80104e30 <release>
  if((nt->kstack = kalloc()) == 0){
80104675:	e8 86 e0 ff ff       	call   80102700 <kalloc>
8010467a:	83 c4 10             	add    $0x10,%esp
8010467d:	89 43 08             	mov    %eax,0x8(%ebx)
80104680:	85 c0                	test   %eax,%eax
80104682:	0f 84 6c 01 00 00    	je     801047f4 <thread_create+0x1f4>
  sp -= sizeof *nt->tf;
80104688:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(nt->context, 0, sizeof *nt->context);
8010468e:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *nt->context;
80104691:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *nt->tf;
80104696:	89 53 0c             	mov    %edx,0xc(%ebx)
  *(uint*)sp = (uint)trapret;
80104699:	c7 40 14 22 61 10 80 	movl   $0x80106122,0x14(%eax)
  nt->context = (struct context*)sp;
801046a0:	89 43 10             	mov    %eax,0x10(%ebx)
  memset(nt->context, 0, sizeof *nt->context);
801046a3:	6a 14                	push   $0x14
801046a5:	6a 00                	push   $0x0
801046a7:	50                   	push   %eax
801046a8:	e8 a3 08 00 00       	call   80104f50 <memset>
  nt->context->eip = (uint)forkret;
801046ad:	8b 43 10             	mov    0x10(%ebx),%eax
  if((sz = allocuvm(p->pgdir, sz, sz + 2*PGSIZE)) == 0){
801046b0:	83 c4 0c             	add    $0xc,%esp
  nt->context->eip = (uint)forkret;
801046b3:	c7 40 10 70 39 10 80 	movl   $0x80103970,0x10(%eax)
  uint sz = PGROUNDUP(p->sz);
801046ba:	8b 06                	mov    (%esi),%eax
801046bc:	05 ff 0f 00 00       	add    $0xfff,%eax
801046c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(p->pgdir, sz, sz + 2*PGSIZE)) == 0){
801046c6:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
801046cc:	52                   	push   %edx
801046cd:	50                   	push   %eax
801046ce:	ff 76 08             	push   0x8(%esi)
801046d1:	e8 7a 2e 00 00       	call   80107550 <allocuvm>
801046d6:	83 c4 10             	add    $0x10,%esp
801046d9:	89 c7                	mov    %eax,%edi
801046db:	85 c0                	test   %eax,%eax
801046dd:	0f 84 fa 00 00 00    	je     801047dd <thread_create+0x1dd>
  clearpteu(p->pgdir, (char*)(sz - 2*PGSIZE));
801046e3:	83 ec 08             	sub    $0x8,%esp
801046e6:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
801046ec:	50                   	push   %eax
801046ed:	ff 76 08             	push   0x8(%esi)
801046f0:	e8 db 30 00 00       	call   801077d0 <clearpteu>
  usp = (usp - (strlen(arg) + 1)) & ~3;
801046f5:	58                   	pop    %eax
801046f6:	ff 75 10             	push   0x10(%ebp)
801046f9:	e8 52 0a 00 00       	call   80105150 <strlen>
801046fe:	8d 57 ff             	lea    -0x1(%edi),%edx
80104701:	29 c2                	sub    %eax,%edx
80104703:	83 e2 fc             	and    $0xfffffffc,%edx
80104706:	89 95 54 ff ff ff    	mov    %edx,-0xac(%ebp)
  if(copyout(p->pgdir, usp, arg, strlen(arg) + 1) < 0){
8010470c:	5a                   	pop    %edx
8010470d:	ff 75 10             	push   0x10(%ebp)
80104710:	e8 3b 0a 00 00       	call   80105150 <strlen>
80104715:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
8010471b:	83 c0 01             	add    $0x1,%eax
8010471e:	50                   	push   %eax
8010471f:	ff 75 10             	push   0x10(%ebp)
80104722:	52                   	push   %edx
80104723:	ff 76 08             	push   0x8(%esi)
80104726:	e8 75 32 00 00       	call   801079a0 <copyout>
8010472b:	83 c4 20             	add    $0x20,%esp
8010472e:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
80104734:	85 c0                	test   %eax,%eax
80104736:	0f 88 c5 00 00 00    	js     80104801 <thread_create+0x201>
  ustack[2] = usp - (argc+1)*4; // arg pointer
8010473c:	8d 42 f8             	lea    -0x8(%edx),%eax
  usp -= (3+argc+1) * 4;
8010473f:	8d 4a ec             	lea    -0x14(%edx),%ecx
  if(copyout(p->pgdir, usp, ustack, (3+argc+1)*4) < 0){
80104742:	6a 14                	push   $0x14
  ustack[2] = usp - (argc+1)*4; // arg pointer
80104744:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(p->pgdir, usp, ustack, (3+argc+1)*4) < 0){
8010474a:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80104750:	50                   	push   %eax
  ustack[3] = usp;
80104751:	89 95 64 ff ff ff    	mov    %edx,-0x9c(%ebp)
  if(copyout(p->pgdir, usp, ustack, (3+argc+1)*4) < 0){
80104757:	51                   	push   %ecx
  ustack[3+argc] = 0;
80104758:	c7 85 68 ff ff ff 00 	movl   $0x0,-0x98(%ebp)
8010475f:	00 00 00 
  if(copyout(p->pgdir, usp, ustack, (3+argc+1)*4) < 0){
80104762:	ff 76 08             	push   0x8(%esi)
80104765:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
  ustack[0] = 0xFFFFFFFF;	// fake return PC
8010476b:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80104772:	ff ff ff 
  ustack[1] = 1;
80104775:	c7 85 5c ff ff ff 01 	movl   $0x1,-0xa4(%ebp)
8010477c:	00 00 00 
  if(copyout(p->pgdir, usp, ustack, (3+argc+1)*4) < 0){
8010477f:	e8 1c 32 00 00       	call   801079a0 <copyout>
80104784:	83 c4 10             	add    $0x10,%esp
80104787:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
8010478d:	85 c0                	test   %eax,%eax
8010478f:	0f 88 83 00 00 00    	js     80104818 <thread_create+0x218>
  p->sz = sz;
80104795:	89 3e                	mov    %edi,(%esi)
  nt->tf->eip = (uint)start_routine;	// start_routine
80104797:	8b 55 0c             	mov    0xc(%ebp),%edx
8010479a:	8b 43 0c             	mov    0xc(%ebx),%eax
  nt->ustackp = sz;
8010479d:	89 7b 14             	mov    %edi,0x14(%ebx)
  nt->tf->eip = (uint)start_routine;	// start_routine
801047a0:	89 50 38             	mov    %edx,0x38(%eax)
  nt->tf->esp = usp;
801047a3:	8b 43 0c             	mov    0xc(%ebx),%eax
801047a6:	89 48 44             	mov    %ecx,0x44(%eax)
  *thread = nt->tid;
801047a9:	8b 45 08             	mov    0x8(%ebp),%eax
801047ac:	8b 53 04             	mov    0x4(%ebx),%edx
801047af:	89 10                	mov    %edx,(%eax)
  return 0;
801047b1:	31 c0                	xor    %eax,%eax
}
801047b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047b6:	5b                   	pop    %ebx
801047b7:	5e                   	pop    %esi
801047b8:	5f                   	pop    %edi
801047b9:	5d                   	pop    %ebp
801047ba:	c3                   	ret    
801047bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047bf:	90                   	nop
  release(&ptable.lock);
801047c0:	83 ec 0c             	sub    $0xc,%esp
801047c3:	68 20 2d 11 80       	push   $0x80112d20
801047c8:	e8 63 06 00 00       	call   80104e30 <release>
  return -1;
801047cd:	83 c4 10             	add    $0x10,%esp
}
801047d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801047d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801047d8:	5b                   	pop    %ebx
801047d9:	5e                   	pop    %esi
801047da:	5f                   	pop    %edi
801047db:	5d                   	pop    %ebp
801047dc:	c3                   	ret    
	cprintf("thread_create() fail\n");
801047dd:	83 ec 0c             	sub    $0xc,%esp
801047e0:	68 5c 81 10 80       	push   $0x8010815c
801047e5:	e8 b6 be ff ff       	call   801006a0 <cprintf>
	return -1;
801047ea:	83 c4 10             	add    $0x10,%esp
801047ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047f2:	eb bf                	jmp    801047b3 <thread_create+0x1b3>
	nt->state = UNUSED;
801047f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -1;
801047fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047ff:	eb b2                	jmp    801047b3 <thread_create+0x1b3>
	cprintf("thread_create() fail: arg copy fail\n");
80104801:	83 ec 0c             	sub    $0xc,%esp
80104804:	68 d0 81 10 80       	push   $0x801081d0
80104809:	e8 92 be ff ff       	call   801006a0 <cprintf>
	return -1;
8010480e:	83 c4 10             	add    $0x10,%esp
80104811:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104816:	eb 9b                	jmp    801047b3 <thread_create+0x1b3>
	cprintf("thread_create() fail: ustack->vm copy fail\n");
80104818:	83 ec 0c             	sub    $0xc,%esp
8010481b:	68 f8 81 10 80       	push   $0x801081f8
80104820:	e8 7b be ff ff       	call   801006a0 <cprintf>
	return -1;
80104825:	83 c4 10             	add    $0x10,%esp
80104828:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010482d:	eb 84                	jmp    801047b3 <thread_create+0x1b3>
8010482f:	90                   	nop

80104830 <thread_exit>:
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	53                   	push   %ebx
80104835:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104838:	e8 03 05 00 00       	call   80104d40 <pushcli>
  c = mycpu();
8010483d:	e8 0e f2 ff ff       	call   80103a50 <mycpu>
  p = c->proc;
80104842:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104848:	e8 43 05 00 00       	call   80104d90 <popcli>
  acquire(&ptable.lock);
8010484d:	83 ec 0c             	sub    $0xc,%esp
80104850:	68 20 2d 11 80       	push   $0x80112d20
80104855:	e8 36 06 00 00       	call   80104e90 <acquire>
  struct thread *t = &p->threads[p->curtidx];
8010485a:	8b 96 70 08 00 00    	mov    0x870(%esi),%edx
  t->state = ZOMBIE;
80104860:	89 d0                	mov    %edx,%eax
  t->ret = retval;
80104862:	c1 e2 05             	shl    $0x5,%edx
  t->state = ZOMBIE;
80104865:	c1 e0 05             	shl    $0x5,%eax
80104868:	01 f0                	add    %esi,%eax
8010486a:	c7 40 70 05 00 00 00 	movl   $0x5,0x70(%eax)
  t->ret = retval;
80104871:	89 9c 32 8c 00 00 00 	mov    %ebx,0x8c(%edx,%esi,1)
  wakeup1((void*)t->tid);
80104878:	8b 40 74             	mov    0x74(%eax),%eax
8010487b:	e8 40 f1 ff ff       	call   801039c0 <wakeup1>
  sched();
80104880:	83 c4 10             	add    $0x10,%esp
}
80104883:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104886:	5b                   	pop    %ebx
80104887:	5e                   	pop    %esi
80104888:	5d                   	pop    %ebp
  sched();
80104889:	e9 92 f6 ff ff       	jmp    80103f20 <sched>
8010488e:	66 90                	xchg   %ax,%ax

80104890 <thread_join>:
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	57                   	push   %edi
80104894:	56                   	push   %esi
80104895:	53                   	push   %ebx
80104896:	83 ec 28             	sub    $0x28,%esp
80104899:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&ptable.lock);
8010489c:	68 20 2d 11 80       	push   $0x80112d20
801048a1:	e8 ea 05 00 00       	call   80104e90 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048a6:	b8 c4 35 11 80       	mov    $0x801135c4,%eax
801048ab:	b9 c4 52 13 80       	mov    $0x801352c4,%ecx
801048b0:	83 c4 10             	add    $0x10,%esp
	for(t = p->threads; t < &p->threads[NTHREAD]; t++)
801048b3:	8d 98 00 f8 ff ff    	lea    -0x800(%eax),%ebx
801048b9:	eb 10                	jmp    801048cb <thread_join+0x3b>
801048bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048bf:	90                   	nop
801048c0:	83 c3 20             	add    $0x20,%ebx
801048c3:	39 c3                	cmp    %eax,%ebx
801048c5:	0f 84 c0 00 00 00    	je     8010498b <thread_join+0xfb>
	  if(t->tid == tid)
801048cb:	8b 53 04             	mov    0x4(%ebx),%edx
801048ce:	39 f2                	cmp    %esi,%edx
801048d0:	75 ee                	jne    801048c0 <thread_join+0x30>
  while(t->state != ZOMBIE)
801048d2:	83 3b 05             	cmpl   $0x5,(%ebx)
801048d5:	0f 84 8e 00 00 00    	je     80104969 <thread_join+0xd9>
801048db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048df:	90                   	nop
801048e0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  pushcli();
801048e3:	e8 58 04 00 00       	call   80104d40 <pushcli>
  c = mycpu();
801048e8:	e8 63 f1 ff ff       	call   80103a50 <mycpu>
  p = c->proc;
801048ed:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
801048f3:	e8 98 04 00 00       	call   80104d90 <popcli>
  if(p == 0)
801048f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801048fb:	85 ff                	test   %edi,%edi
801048fd:	0f 84 b9 00 00 00    	je     801049bc <thread_join+0x12c>
  t->chan = chan;
80104903:	8b b7 70 08 00 00    	mov    0x870(%edi),%esi
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80104909:	8d 47 70             	lea    0x70(%edi),%eax
8010490c:	c1 e6 05             	shl    $0x5,%esi
8010490f:	01 fe                	add    %edi,%esi
  t->chan = chan;
80104911:	89 96 88 00 00 00    	mov    %edx,0x88(%esi)
  t->state = SLEEPING;
80104917:	8d 97 70 08 00 00    	lea    0x870(%edi),%edx
8010491d:	c7 46 70 02 00 00 00 	movl   $0x2,0x70(%esi)
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80104924:	eb 11                	jmp    80104937 <thread_join+0xa7>
80104926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492d:	8d 76 00             	lea    0x0(%esi),%esi
80104930:	83 c0 20             	add    $0x20,%eax
80104933:	39 d0                	cmp    %edx,%eax
80104935:	74 29                	je     80104960 <thread_join+0xd0>
	if(t->state != UNUSED && t->state != SLEEPING){
80104937:	f7 00 fd ff ff ff    	testl  $0xfffffffd,(%eax)
8010493d:	74 f1                	je     80104930 <thread_join+0xa0>
  sched();
8010493f:	e8 dc f5 ff ff       	call   80103f20 <sched>
  t->chan = 0;
80104944:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
8010494b:	00 00 00 
  while(t->state != ZOMBIE)
8010494e:	83 3b 05             	cmpl   $0x5,(%ebx)
80104951:	74 16                	je     80104969 <thread_join+0xd9>
	sleep((void*)t->tid, &ptable.lock);
80104953:	8b 53 04             	mov    0x4(%ebx),%edx
80104956:	eb 88                	jmp    801048e0 <thread_join+0x50>
80104958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495f:	90                   	nop
	p->state = SLEEPING;
80104960:	c7 47 0c 02 00 00 00 	movl   $0x2,0xc(%edi)
80104967:	eb d6                	jmp    8010493f <thread_join+0xaf>
  *retval = t->ret;
80104969:	8b 53 1c             	mov    0x1c(%ebx),%edx
8010496c:	8b 45 0c             	mov    0xc(%ebp),%eax
  release(&ptable.lock);
8010496f:	83 ec 0c             	sub    $0xc,%esp
  *retval = t->ret;
80104972:	89 10                	mov    %edx,(%eax)
  release(&ptable.lock);
80104974:	68 20 2d 11 80       	push   $0x80112d20
80104979:	e8 b2 04 00 00       	call   80104e30 <release>
  return 0;
8010497e:	83 c4 10             	add    $0x10,%esp
80104981:	31 c0                	xor    %eax,%eax
}
80104983:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104986:	5b                   	pop    %ebx
80104987:	5e                   	pop    %esi
80104988:	5f                   	pop    %edi
80104989:	5d                   	pop    %ebp
8010498a:	c3                   	ret    
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010498b:	8d 83 74 08 00 00    	lea    0x874(%ebx),%eax
80104991:	39 c1                	cmp    %eax,%ecx
80104993:	0f 85 1a ff ff ff    	jne    801048b3 <thread_join+0x23>
  release(&ptable.lock);
80104999:	83 ec 0c             	sub    $0xc,%esp
8010499c:	68 20 2d 11 80       	push   $0x80112d20
801049a1:	e8 8a 04 00 00       	call   80104e30 <release>
  cprintf("thread_join() failed: tid not found\n");
801049a6:	c7 04 24 24 82 10 80 	movl   $0x80108224,(%esp)
801049ad:	e8 ee bc ff ff       	call   801006a0 <cprintf>
  return -1;
801049b2:	83 c4 10             	add    $0x10,%esp
801049b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049ba:	eb c7                	jmp    80104983 <thread_join+0xf3>
    panic("sleep (p)");
801049bc:	83 ec 0c             	sub    $0xc,%esp
801049bf:	68 e7 80 10 80       	push   $0x801080e7
801049c4:	e8 b7 b9 ff ff       	call   80100380 <panic>
801049c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049d0 <tscheduler>:
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	53                   	push   %ebx
801049d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i= p->curtidx + 1; i < NTHREAD; i++){
801049d7:	8b 99 70 08 00 00    	mov    0x870(%ecx),%ebx
801049dd:	8d 43 01             	lea    0x1(%ebx),%eax
801049e0:	83 f8 3f             	cmp    $0x3f,%eax
801049e3:	7e 13                	jle    801049f8 <tscheduler+0x28>
801049e5:	eb 29                	jmp    80104a10 <tscheduler+0x40>
801049e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ee:	66 90                	xchg   %ax,%ax
801049f0:	83 c0 01             	add    $0x1,%eax
801049f3:	83 f8 40             	cmp    $0x40,%eax
801049f6:	74 18                	je     80104a10 <tscheduler+0x40>
	if(p->threads[i].state == RUNNABLE){
801049f8:	89 c2                	mov    %eax,%edx
801049fa:	c1 e2 05             	shl    $0x5,%edx
801049fd:	83 7c 11 70 03       	cmpl   $0x3,0x70(%ecx,%edx,1)
80104a02:	75 ec                	jne    801049f0 <tscheduler+0x20>
  if(next == -1){
80104a04:	83 f8 ff             	cmp    $0xffffffff,%eax
80104a07:	74 07                	je     80104a10 <tscheduler+0x40>
}
80104a09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a0c:	c9                   	leave  
80104a0d:	c3                   	ret    
80104a0e:	66 90                	xchg   %ax,%ax
	for(i = 0; i < p->curtidx + 1; i++){
80104a10:	85 db                	test   %ebx,%ebx
80104a12:	78 1f                	js     80104a33 <tscheduler+0x63>
80104a14:	31 c0                	xor    %eax,%eax
80104a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
	  if(p->threads[i].state == RUNNABLE){
80104a20:	89 c2                	mov    %eax,%edx
80104a22:	c1 e2 05             	shl    $0x5,%edx
80104a25:	83 7c 11 70 03       	cmpl   $0x3,0x70(%ecx,%edx,1)
80104a2a:	74 dd                	je     80104a09 <tscheduler+0x39>
	for(i = 0; i < p->curtidx + 1; i++){
80104a2c:	83 c0 01             	add    $0x1,%eax
80104a2f:	39 c3                	cmp    %eax,%ebx
80104a31:	7d ed                	jge    80104a20 <tscheduler+0x50>
}
80104a33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
	for(i = 0; i < p->curtidx + 1; i++){
80104a36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a3b:	c9                   	leave  
80104a3c:	c3                   	ret    
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi

80104a40 <setpstate>:
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 04             	sub    $0x4,%esp
80104a47:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  switch(check){
80104a4d:	83 f8 03             	cmp    $0x3,%eax
80104a50:	74 1e                	je     80104a70 <setpstate+0x30>
80104a52:	83 f8 05             	cmp    $0x5,%eax
80104a55:	74 71                	je     80104ac8 <setpstate+0x88>
80104a57:	83 f8 02             	cmp    $0x2,%eax
80104a5a:	74 44                	je     80104aa0 <setpstate+0x60>
	  panic("setpstate");
80104a5c:	83 ec 0c             	sub    $0xc,%esp
80104a5f:	68 72 81 10 80       	push   $0x80108172
80104a64:	e8 17 b9 ff ff       	call   80100380 <panic>
80104a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80104a70:	8d 41 70             	lea    0x70(%ecx),%eax
80104a73:	8d 91 70 08 00 00    	lea    0x870(%ecx),%edx
80104a79:	eb 0c                	jmp    80104a87 <setpstate+0x47>
80104a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a7f:	90                   	nop
80104a80:	83 c0 20             	add    $0x20,%eax
80104a83:	39 c2                	cmp    %eax,%edx
80104a85:	74 0c                	je     80104a93 <setpstate+0x53>
	if(t->state == RUNNABLE){
80104a87:	83 38 03             	cmpl   $0x3,(%eax)
80104a8a:	75 f4                	jne    80104a80 <setpstate+0x40>
	p->state = RUNNABLE;
80104a8c:	c7 41 0c 03 00 00 00 	movl   $0x3,0xc(%ecx)
}
80104a93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a96:	c9                   	leave  
80104a97:	c3                   	ret    
80104a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9f:	90                   	nop
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80104aa0:	8d 41 70             	lea    0x70(%ecx),%eax
80104aa3:	8d 91 70 08 00 00    	lea    0x870(%ecx),%edx
80104aa9:	eb 0c                	jmp    80104ab7 <setpstate+0x77>
80104aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aaf:	90                   	nop
80104ab0:	83 c0 20             	add    $0x20,%eax
80104ab3:	39 c2                	cmp    %eax,%edx
80104ab5:	74 49                	je     80104b00 <setpstate+0xc0>
	if(t->state != UNUSED && t->state != SLEEPING){
80104ab7:	f7 00 fd ff ff ff    	testl  $0xfffffffd,(%eax)
80104abd:	74 f1                	je     80104ab0 <setpstate+0x70>
}
80104abf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac2:	c9                   	leave  
80104ac3:	c3                   	ret    
80104ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(t = p->threads; t < &p->threads[NTHREAD]; t++)
80104ac8:	8d 41 70             	lea    0x70(%ecx),%eax
80104acb:	8d 99 70 08 00 00    	lea    0x870(%ecx),%ebx
80104ad1:	eb 0c                	jmp    80104adf <setpstate+0x9f>
80104ad3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ad7:	90                   	nop
80104ad8:	83 c0 20             	add    $0x20,%eax
80104adb:	39 c3                	cmp    %eax,%ebx
80104add:	74 11                	je     80104af0 <setpstate+0xb0>
	if(t->state != UNUSED && t->state != ZOMBIE){
80104adf:	8b 10                	mov    (%eax),%edx
80104ae1:	85 d2                	test   %edx,%edx
80104ae3:	74 f3                	je     80104ad8 <setpstate+0x98>
80104ae5:	83 fa 05             	cmp    $0x5,%edx
80104ae8:	74 ee                	je     80104ad8 <setpstate+0x98>
}
80104aea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aed:	c9                   	leave  
80104aee:	c3                   	ret    
80104aef:	90                   	nop
	p->state = ZOMBIE;
80104af0:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
}
80104af7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104afa:	c9                   	leave  
80104afb:	c3                   	ret    
80104afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	p->state = SLEEPING;
80104b00:	c7 41 0c 02 00 00 00 	movl   $0x2,0xc(%ecx)
}
80104b07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b0a:	c9                   	leave  
80104b0b:	c3                   	ret    
80104b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b10 <tclear>:
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
	return 1;
80104b14:	be 01 00 00 00       	mov    $0x1,%esi
{
80104b19:	53                   	push   %ebx
80104b1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(t->state == UNUSED)
80104b1d:	8b 03                	mov    (%ebx),%eax
80104b1f:	85 c0                	test   %eax,%eax
80104b21:	74 3c                	je     80104b5f <tclear+0x4f>
  if(t->kstack == 0){
80104b23:	8b 43 08             	mov    0x8(%ebx),%eax
80104b26:	85 c0                	test   %eax,%eax
80104b28:	74 46                	je     80104b70 <tclear+0x60>
  kfree(t->kstack);
80104b2a:	83 ec 0c             	sub    $0xc,%esp
80104b2d:	50                   	push   %eax
80104b2e:	e8 0d da ff ff       	call   80102540 <kfree>
  t->kstack = 0;
80104b33:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)

  return 1;
80104b3a:	83 c4 10             	add    $0x10,%esp
  t->ustackp = 0;
80104b3d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  t->tid = 0;
80104b44:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  t->state = UNUSED;
80104b4b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  t->chan = 0;
80104b51:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
  t->ret = 0;
80104b58:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
}
80104b5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b62:	89 f0                	mov    %esi,%eax
80104b64:	5b                   	pop    %ebx
80104b65:	5e                   	pop    %esi
80104b66:	5d                   	pop    %ebp
80104b67:	c3                   	ret    
80104b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6f:	90                   	nop
	cprintf("tclear(): kstack not found\n");
80104b70:	83 ec 0c             	sub    $0xc,%esp
	return 0;
80104b73:	31 f6                	xor    %esi,%esi
	cprintf("tclear(): kstack not found\n");
80104b75:	68 02 81 10 80       	push   $0x80108102
80104b7a:	e8 21 bb ff ff       	call   801006a0 <cprintf>
	return 0;
80104b7f:	83 c4 10             	add    $0x10,%esp
}
80104b82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b85:	89 f0                	mov    %esi,%eax
80104b87:	5b                   	pop    %ebx
80104b88:	5e                   	pop    %esi
80104b89:	5d                   	pop    %ebp
80104b8a:	c3                   	ret    
80104b8b:	66 90                	xchg   %ax,%ax
80104b8d:	66 90                	xchg   %ax,%ax
80104b8f:	90                   	nop

80104b90 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	53                   	push   %ebx
80104b94:	83 ec 0c             	sub    $0xc,%esp
80104b97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104b9a:	68 64 82 10 80       	push   $0x80108264
80104b9f:	8d 43 04             	lea    0x4(%ebx),%eax
80104ba2:	50                   	push   %eax
80104ba3:	e8 18 01 00 00       	call   80104cc0 <initlock>
  lk->name = name;
80104ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104bab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104bb1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104bb4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104bbb:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104bbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bc1:	c9                   	leave  
80104bc2:	c3                   	ret    
80104bc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bd0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	53                   	push   %ebx
80104bd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104bd8:	8d 73 04             	lea    0x4(%ebx),%esi
80104bdb:	83 ec 0c             	sub    $0xc,%esp
80104bde:	56                   	push   %esi
80104bdf:	e8 ac 02 00 00       	call   80104e90 <acquire>
  while (lk->locked) {
80104be4:	8b 13                	mov    (%ebx),%edx
80104be6:	83 c4 10             	add    $0x10,%esp
80104be9:	85 d2                	test   %edx,%edx
80104beb:	74 16                	je     80104c03 <acquiresleep+0x33>
80104bed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104bf0:	83 ec 08             	sub    $0x8,%esp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
80104bf5:	e8 b6 f5 ff ff       	call   801041b0 <sleep>
  while (lk->locked) {
80104bfa:	8b 03                	mov    (%ebx),%eax
80104bfc:	83 c4 10             	add    $0x10,%esp
80104bff:	85 c0                	test   %eax,%eax
80104c01:	75 ed                	jne    80104bf0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104c03:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104c09:	e8 c2 ee ff ff       	call   80103ad0 <myproc>
80104c0e:	8b 40 10             	mov    0x10(%eax),%eax
80104c11:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104c14:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104c17:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c1a:	5b                   	pop    %ebx
80104c1b:	5e                   	pop    %esi
80104c1c:	5d                   	pop    %ebp
  release(&lk->lk);
80104c1d:	e9 0e 02 00 00       	jmp    80104e30 <release>
80104c22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c30 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	56                   	push   %esi
80104c34:	53                   	push   %ebx
80104c35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c38:	8d 73 04             	lea    0x4(%ebx),%esi
80104c3b:	83 ec 0c             	sub    $0xc,%esp
80104c3e:	56                   	push   %esi
80104c3f:	e8 4c 02 00 00       	call   80104e90 <acquire>
  lk->locked = 0;
80104c44:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104c4a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104c51:	89 1c 24             	mov    %ebx,(%esp)
80104c54:	e8 e7 f7 ff ff       	call   80104440 <wakeup>
  release(&lk->lk);
80104c59:	89 75 08             	mov    %esi,0x8(%ebp)
80104c5c:	83 c4 10             	add    $0x10,%esp
}
80104c5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c62:	5b                   	pop    %ebx
80104c63:	5e                   	pop    %esi
80104c64:	5d                   	pop    %ebp
  release(&lk->lk);
80104c65:	e9 c6 01 00 00       	jmp    80104e30 <release>
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c70 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	57                   	push   %edi
80104c74:	31 ff                	xor    %edi,%edi
80104c76:	56                   	push   %esi
80104c77:	53                   	push   %ebx
80104c78:	83 ec 18             	sub    $0x18,%esp
80104c7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104c7e:	8d 73 04             	lea    0x4(%ebx),%esi
80104c81:	56                   	push   %esi
80104c82:	e8 09 02 00 00       	call   80104e90 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104c87:	8b 03                	mov    (%ebx),%eax
80104c89:	83 c4 10             	add    $0x10,%esp
80104c8c:	85 c0                	test   %eax,%eax
80104c8e:	75 18                	jne    80104ca8 <holdingsleep+0x38>
  release(&lk->lk);
80104c90:	83 ec 0c             	sub    $0xc,%esp
80104c93:	56                   	push   %esi
80104c94:	e8 97 01 00 00       	call   80104e30 <release>
  return r;
}
80104c99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c9c:	89 f8                	mov    %edi,%eax
80104c9e:	5b                   	pop    %ebx
80104c9f:	5e                   	pop    %esi
80104ca0:	5f                   	pop    %edi
80104ca1:	5d                   	pop    %ebp
80104ca2:	c3                   	ret    
80104ca3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ca7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104ca8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104cab:	e8 20 ee ff ff       	call   80103ad0 <myproc>
80104cb0:	39 58 10             	cmp    %ebx,0x10(%eax)
80104cb3:	0f 94 c0             	sete   %al
80104cb6:	0f b6 c0             	movzbl %al,%eax
80104cb9:	89 c7                	mov    %eax,%edi
80104cbb:	eb d3                	jmp    80104c90 <holdingsleep+0x20>
80104cbd:	66 90                	xchg   %ax,%ax
80104cbf:	90                   	nop

80104cc0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104cc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104ccf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104cd2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104cd9:	5d                   	pop    %ebp
80104cda:	c3                   	ret    
80104cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cdf:	90                   	nop

80104ce0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ce0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ce1:	31 d2                	xor    %edx,%edx
{
80104ce3:	89 e5                	mov    %esp,%ebp
80104ce5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104ce6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104ce9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104cec:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104cef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104cf0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104cf6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104cfc:	77 1a                	ja     80104d18 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104cfe:	8b 58 04             	mov    0x4(%eax),%ebx
80104d01:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104d04:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104d07:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d09:	83 fa 0a             	cmp    $0xa,%edx
80104d0c:	75 e2                	jne    80104cf0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104d0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d11:	c9                   	leave  
80104d12:	c3                   	ret    
80104d13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d17:	90                   	nop
  for(; i < 10; i++)
80104d18:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104d1b:	8d 51 28             	lea    0x28(%ecx),%edx
80104d1e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104d20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104d26:	83 c0 04             	add    $0x4,%eax
80104d29:	39 d0                	cmp    %edx,%eax
80104d2b:	75 f3                	jne    80104d20 <getcallerpcs+0x40>
}
80104d2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d30:	c9                   	leave  
80104d31:	c3                   	ret    
80104d32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d40 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	53                   	push   %ebx
80104d44:	83 ec 04             	sub    $0x4,%esp
80104d47:	9c                   	pushf  
80104d48:	5b                   	pop    %ebx
  asm volatile("cli");
80104d49:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104d4a:	e8 01 ed ff ff       	call   80103a50 <mycpu>
80104d4f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d55:	85 c0                	test   %eax,%eax
80104d57:	74 17                	je     80104d70 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104d59:	e8 f2 ec ff ff       	call   80103a50 <mycpu>
80104d5e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104d65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d68:	c9                   	leave  
80104d69:	c3                   	ret    
80104d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104d70:	e8 db ec ff ff       	call   80103a50 <mycpu>
80104d75:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104d7b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104d81:	eb d6                	jmp    80104d59 <pushcli+0x19>
80104d83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d90 <popcli>:

void
popcli(void)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d96:	9c                   	pushf  
80104d97:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104d98:	f6 c4 02             	test   $0x2,%ah
80104d9b:	75 35                	jne    80104dd2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104d9d:	e8 ae ec ff ff       	call   80103a50 <mycpu>
80104da2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104da9:	78 34                	js     80104ddf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104dab:	e8 a0 ec ff ff       	call   80103a50 <mycpu>
80104db0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104db6:	85 d2                	test   %edx,%edx
80104db8:	74 06                	je     80104dc0 <popcli+0x30>
    sti();
}
80104dba:	c9                   	leave  
80104dbb:	c3                   	ret    
80104dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104dc0:	e8 8b ec ff ff       	call   80103a50 <mycpu>
80104dc5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104dcb:	85 c0                	test   %eax,%eax
80104dcd:	74 eb                	je     80104dba <popcli+0x2a>
  asm volatile("sti");
80104dcf:	fb                   	sti    
}
80104dd0:	c9                   	leave  
80104dd1:	c3                   	ret    
    panic("popcli - interruptible");
80104dd2:	83 ec 0c             	sub    $0xc,%esp
80104dd5:	68 6f 82 10 80       	push   $0x8010826f
80104dda:	e8 a1 b5 ff ff       	call   80100380 <panic>
    panic("popcli");
80104ddf:	83 ec 0c             	sub    $0xc,%esp
80104de2:	68 86 82 10 80       	push   $0x80108286
80104de7:	e8 94 b5 ff ff       	call   80100380 <panic>
80104dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104df0 <holding>:
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	56                   	push   %esi
80104df4:	53                   	push   %ebx
80104df5:	8b 75 08             	mov    0x8(%ebp),%esi
80104df8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104dfa:	e8 41 ff ff ff       	call   80104d40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104dff:	8b 06                	mov    (%esi),%eax
80104e01:	85 c0                	test   %eax,%eax
80104e03:	75 0b                	jne    80104e10 <holding+0x20>
  popcli();
80104e05:	e8 86 ff ff ff       	call   80104d90 <popcli>
}
80104e0a:	89 d8                	mov    %ebx,%eax
80104e0c:	5b                   	pop    %ebx
80104e0d:	5e                   	pop    %esi
80104e0e:	5d                   	pop    %ebp
80104e0f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104e10:	8b 5e 08             	mov    0x8(%esi),%ebx
80104e13:	e8 38 ec ff ff       	call   80103a50 <mycpu>
80104e18:	39 c3                	cmp    %eax,%ebx
80104e1a:	0f 94 c3             	sete   %bl
  popcli();
80104e1d:	e8 6e ff ff ff       	call   80104d90 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104e22:	0f b6 db             	movzbl %bl,%ebx
}
80104e25:	89 d8                	mov    %ebx,%eax
80104e27:	5b                   	pop    %ebx
80104e28:	5e                   	pop    %esi
80104e29:	5d                   	pop    %ebp
80104e2a:	c3                   	ret    
80104e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e2f:	90                   	nop

80104e30 <release>:
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	56                   	push   %esi
80104e34:	53                   	push   %ebx
80104e35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104e38:	e8 03 ff ff ff       	call   80104d40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e3d:	8b 03                	mov    (%ebx),%eax
80104e3f:	85 c0                	test   %eax,%eax
80104e41:	75 15                	jne    80104e58 <release+0x28>
  popcli();
80104e43:	e8 48 ff ff ff       	call   80104d90 <popcli>
    panic("release");
80104e48:	83 ec 0c             	sub    $0xc,%esp
80104e4b:	68 8d 82 10 80       	push   $0x8010828d
80104e50:	e8 2b b5 ff ff       	call   80100380 <panic>
80104e55:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104e58:	8b 73 08             	mov    0x8(%ebx),%esi
80104e5b:	e8 f0 eb ff ff       	call   80103a50 <mycpu>
80104e60:	39 c6                	cmp    %eax,%esi
80104e62:	75 df                	jne    80104e43 <release+0x13>
  popcli();
80104e64:	e8 27 ff ff ff       	call   80104d90 <popcli>
  lk->pcs[0] = 0;
80104e69:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104e70:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104e77:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104e7c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104e82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e85:	5b                   	pop    %ebx
80104e86:	5e                   	pop    %esi
80104e87:	5d                   	pop    %ebp
  popcli();
80104e88:	e9 03 ff ff ff       	jmp    80104d90 <popcli>
80104e8d:	8d 76 00             	lea    0x0(%esi),%esi

80104e90 <acquire>:
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	53                   	push   %ebx
80104e94:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104e97:	e8 a4 fe ff ff       	call   80104d40 <pushcli>
  if(holding(lk))
80104e9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104e9f:	e8 9c fe ff ff       	call   80104d40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104ea4:	8b 03                	mov    (%ebx),%eax
80104ea6:	85 c0                	test   %eax,%eax
80104ea8:	75 7e                	jne    80104f28 <acquire+0x98>
  popcli();
80104eaa:	e8 e1 fe ff ff       	call   80104d90 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104eaf:	b9 01 00 00 00       	mov    $0x1,%ecx
80104eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104eb8:	8b 55 08             	mov    0x8(%ebp),%edx
80104ebb:	89 c8                	mov    %ecx,%eax
80104ebd:	f0 87 02             	lock xchg %eax,(%edx)
80104ec0:	85 c0                	test   %eax,%eax
80104ec2:	75 f4                	jne    80104eb8 <acquire+0x28>
  __sync_synchronize();
80104ec4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ecc:	e8 7f eb ff ff       	call   80103a50 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104ed1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104ed4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104ed6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104ed9:	31 c0                	xor    %eax,%eax
80104edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104edf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ee0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104ee6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104eec:	77 1a                	ja     80104f08 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104eee:	8b 5a 04             	mov    0x4(%edx),%ebx
80104ef1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104ef5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104ef8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104efa:	83 f8 0a             	cmp    $0xa,%eax
80104efd:	75 e1                	jne    80104ee0 <acquire+0x50>
}
80104eff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f02:	c9                   	leave  
80104f03:	c3                   	ret    
80104f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104f08:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104f0c:	8d 51 34             	lea    0x34(%ecx),%edx
80104f0f:	90                   	nop
    pcs[i] = 0;
80104f10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104f16:	83 c0 04             	add    $0x4,%eax
80104f19:	39 c2                	cmp    %eax,%edx
80104f1b:	75 f3                	jne    80104f10 <acquire+0x80>
}
80104f1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f20:	c9                   	leave  
80104f21:	c3                   	ret    
80104f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104f28:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104f2b:	e8 20 eb ff ff       	call   80103a50 <mycpu>
80104f30:	39 c3                	cmp    %eax,%ebx
80104f32:	0f 85 72 ff ff ff    	jne    80104eaa <acquire+0x1a>
  popcli();
80104f38:	e8 53 fe ff ff       	call   80104d90 <popcli>
    panic("acquire");
80104f3d:	83 ec 0c             	sub    $0xc,%esp
80104f40:	68 95 82 10 80       	push   $0x80108295
80104f45:	e8 36 b4 ff ff       	call   80100380 <panic>
80104f4a:	66 90                	xchg   %ax,%ax
80104f4c:	66 90                	xchg   %ax,%ax
80104f4e:	66 90                	xchg   %ax,%ax

80104f50 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	57                   	push   %edi
80104f54:	8b 55 08             	mov    0x8(%ebp),%edx
80104f57:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f5a:	53                   	push   %ebx
80104f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104f5e:	89 d7                	mov    %edx,%edi
80104f60:	09 cf                	or     %ecx,%edi
80104f62:	83 e7 03             	and    $0x3,%edi
80104f65:	75 29                	jne    80104f90 <memset+0x40>
    c &= 0xFF;
80104f67:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f6a:	c1 e0 18             	shl    $0x18,%eax
80104f6d:	89 fb                	mov    %edi,%ebx
80104f6f:	c1 e9 02             	shr    $0x2,%ecx
80104f72:	c1 e3 10             	shl    $0x10,%ebx
80104f75:	09 d8                	or     %ebx,%eax
80104f77:	09 f8                	or     %edi,%eax
80104f79:	c1 e7 08             	shl    $0x8,%edi
80104f7c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104f7e:	89 d7                	mov    %edx,%edi
80104f80:	fc                   	cld    
80104f81:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104f83:	5b                   	pop    %ebx
80104f84:	89 d0                	mov    %edx,%eax
80104f86:	5f                   	pop    %edi
80104f87:	5d                   	pop    %ebp
80104f88:	c3                   	ret    
80104f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104f90:	89 d7                	mov    %edx,%edi
80104f92:	fc                   	cld    
80104f93:	f3 aa                	rep stos %al,%es:(%edi)
80104f95:	5b                   	pop    %ebx
80104f96:	89 d0                	mov    %edx,%eax
80104f98:	5f                   	pop    %edi
80104f99:	5d                   	pop    %ebp
80104f9a:	c3                   	ret    
80104f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f9f:	90                   	nop

80104fa0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	8b 75 10             	mov    0x10(%ebp),%esi
80104fa7:	8b 55 08             	mov    0x8(%ebp),%edx
80104faa:	53                   	push   %ebx
80104fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104fae:	85 f6                	test   %esi,%esi
80104fb0:	74 2e                	je     80104fe0 <memcmp+0x40>
80104fb2:	01 c6                	add    %eax,%esi
80104fb4:	eb 14                	jmp    80104fca <memcmp+0x2a>
80104fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104fc0:	83 c0 01             	add    $0x1,%eax
80104fc3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104fc6:	39 f0                	cmp    %esi,%eax
80104fc8:	74 16                	je     80104fe0 <memcmp+0x40>
    if(*s1 != *s2)
80104fca:	0f b6 0a             	movzbl (%edx),%ecx
80104fcd:	0f b6 18             	movzbl (%eax),%ebx
80104fd0:	38 d9                	cmp    %bl,%cl
80104fd2:	74 ec                	je     80104fc0 <memcmp+0x20>
      return *s1 - *s2;
80104fd4:	0f b6 c1             	movzbl %cl,%eax
80104fd7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104fd9:	5b                   	pop    %ebx
80104fda:	5e                   	pop    %esi
80104fdb:	5d                   	pop    %ebp
80104fdc:	c3                   	ret    
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi
80104fe0:	5b                   	pop    %ebx
  return 0;
80104fe1:	31 c0                	xor    %eax,%eax
}
80104fe3:	5e                   	pop    %esi
80104fe4:	5d                   	pop    %ebp
80104fe5:	c3                   	ret    
80104fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fed:	8d 76 00             	lea    0x0(%esi),%esi

80104ff0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	57                   	push   %edi
80104ff4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ff7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ffa:	56                   	push   %esi
80104ffb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104ffe:	39 d6                	cmp    %edx,%esi
80105000:	73 26                	jae    80105028 <memmove+0x38>
80105002:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105005:	39 fa                	cmp    %edi,%edx
80105007:	73 1f                	jae    80105028 <memmove+0x38>
80105009:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010500c:	85 c9                	test   %ecx,%ecx
8010500e:	74 0c                	je     8010501c <memmove+0x2c>
      *--d = *--s;
80105010:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105014:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105017:	83 e8 01             	sub    $0x1,%eax
8010501a:	73 f4                	jae    80105010 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010501c:	5e                   	pop    %esi
8010501d:	89 d0                	mov    %edx,%eax
8010501f:	5f                   	pop    %edi
80105020:	5d                   	pop    %ebp
80105021:	c3                   	ret    
80105022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105028:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010502b:	89 d7                	mov    %edx,%edi
8010502d:	85 c9                	test   %ecx,%ecx
8010502f:	74 eb                	je     8010501c <memmove+0x2c>
80105031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105038:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105039:	39 c6                	cmp    %eax,%esi
8010503b:	75 fb                	jne    80105038 <memmove+0x48>
}
8010503d:	5e                   	pop    %esi
8010503e:	89 d0                	mov    %edx,%eax
80105040:	5f                   	pop    %edi
80105041:	5d                   	pop    %ebp
80105042:	c3                   	ret    
80105043:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010504a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105050 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105050:	eb 9e                	jmp    80104ff0 <memmove>
80105052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105060 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	8b 75 10             	mov    0x10(%ebp),%esi
80105067:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010506a:	53                   	push   %ebx
8010506b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010506e:	85 f6                	test   %esi,%esi
80105070:	74 2e                	je     801050a0 <strncmp+0x40>
80105072:	01 d6                	add    %edx,%esi
80105074:	eb 18                	jmp    8010508e <strncmp+0x2e>
80105076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
80105080:	38 d8                	cmp    %bl,%al
80105082:	75 14                	jne    80105098 <strncmp+0x38>
    n--, p++, q++;
80105084:	83 c2 01             	add    $0x1,%edx
80105087:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010508a:	39 f2                	cmp    %esi,%edx
8010508c:	74 12                	je     801050a0 <strncmp+0x40>
8010508e:	0f b6 01             	movzbl (%ecx),%eax
80105091:	0f b6 1a             	movzbl (%edx),%ebx
80105094:	84 c0                	test   %al,%al
80105096:	75 e8                	jne    80105080 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105098:	29 d8                	sub    %ebx,%eax
}
8010509a:	5b                   	pop    %ebx
8010509b:	5e                   	pop    %esi
8010509c:	5d                   	pop    %ebp
8010509d:	c3                   	ret    
8010509e:	66 90                	xchg   %ax,%ax
801050a0:	5b                   	pop    %ebx
    return 0;
801050a1:	31 c0                	xor    %eax,%eax
}
801050a3:	5e                   	pop    %esi
801050a4:	5d                   	pop    %ebp
801050a5:	c3                   	ret    
801050a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ad:	8d 76 00             	lea    0x0(%esi),%esi

801050b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	57                   	push   %edi
801050b4:	56                   	push   %esi
801050b5:	8b 75 08             	mov    0x8(%ebp),%esi
801050b8:	53                   	push   %ebx
801050b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801050bc:	89 f0                	mov    %esi,%eax
801050be:	eb 15                	jmp    801050d5 <strncpy+0x25>
801050c0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801050c4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801050c7:	83 c0 01             	add    $0x1,%eax
801050ca:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
801050ce:	88 50 ff             	mov    %dl,-0x1(%eax)
801050d1:	84 d2                	test   %dl,%dl
801050d3:	74 09                	je     801050de <strncpy+0x2e>
801050d5:	89 cb                	mov    %ecx,%ebx
801050d7:	83 e9 01             	sub    $0x1,%ecx
801050da:	85 db                	test   %ebx,%ebx
801050dc:	7f e2                	jg     801050c0 <strncpy+0x10>
    ;
  while(n-- > 0)
801050de:	89 c2                	mov    %eax,%edx
801050e0:	85 c9                	test   %ecx,%ecx
801050e2:	7e 17                	jle    801050fb <strncpy+0x4b>
801050e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801050e8:	83 c2 01             	add    $0x1,%edx
801050eb:	89 c1                	mov    %eax,%ecx
801050ed:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
801050f1:	29 d1                	sub    %edx,%ecx
801050f3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
801050f7:	85 c9                	test   %ecx,%ecx
801050f9:	7f ed                	jg     801050e8 <strncpy+0x38>
  return os;
}
801050fb:	5b                   	pop    %ebx
801050fc:	89 f0                	mov    %esi,%eax
801050fe:	5e                   	pop    %esi
801050ff:	5f                   	pop    %edi
80105100:	5d                   	pop    %ebp
80105101:	c3                   	ret    
80105102:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105110 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	56                   	push   %esi
80105114:	8b 55 10             	mov    0x10(%ebp),%edx
80105117:	8b 75 08             	mov    0x8(%ebp),%esi
8010511a:	53                   	push   %ebx
8010511b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010511e:	85 d2                	test   %edx,%edx
80105120:	7e 25                	jle    80105147 <safestrcpy+0x37>
80105122:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105126:	89 f2                	mov    %esi,%edx
80105128:	eb 16                	jmp    80105140 <safestrcpy+0x30>
8010512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105130:	0f b6 08             	movzbl (%eax),%ecx
80105133:	83 c0 01             	add    $0x1,%eax
80105136:	83 c2 01             	add    $0x1,%edx
80105139:	88 4a ff             	mov    %cl,-0x1(%edx)
8010513c:	84 c9                	test   %cl,%cl
8010513e:	74 04                	je     80105144 <safestrcpy+0x34>
80105140:	39 d8                	cmp    %ebx,%eax
80105142:	75 ec                	jne    80105130 <safestrcpy+0x20>
    ;
  *s = 0;
80105144:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105147:	89 f0                	mov    %esi,%eax
80105149:	5b                   	pop    %ebx
8010514a:	5e                   	pop    %esi
8010514b:	5d                   	pop    %ebp
8010514c:	c3                   	ret    
8010514d:	8d 76 00             	lea    0x0(%esi),%esi

80105150 <strlen>:

int
strlen(const char *s)
{
80105150:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105151:	31 c0                	xor    %eax,%eax
{
80105153:	89 e5                	mov    %esp,%ebp
80105155:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105158:	80 3a 00             	cmpb   $0x0,(%edx)
8010515b:	74 0c                	je     80105169 <strlen+0x19>
8010515d:	8d 76 00             	lea    0x0(%esi),%esi
80105160:	83 c0 01             	add    $0x1,%eax
80105163:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105167:	75 f7                	jne    80105160 <strlen+0x10>
    ;
  return n;
}
80105169:	5d                   	pop    %ebp
8010516a:	c3                   	ret    

8010516b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010516b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010516f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105173:	55                   	push   %ebp
  pushl %ebx
80105174:	53                   	push   %ebx
  pushl %esi
80105175:	56                   	push   %esi
  pushl %edi
80105176:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105177:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105179:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010517b:	5f                   	pop    %edi
  popl %esi
8010517c:	5e                   	pop    %esi
  popl %ebx
8010517d:	5b                   	pop    %ebx
  popl %ebp
8010517e:	5d                   	pop    %ebp
  ret
8010517f:	c3                   	ret    

80105180 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	53                   	push   %ebx
80105184:	83 ec 04             	sub    $0x4,%esp
80105187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010518a:	e8 41 e9 ff ff       	call   80103ad0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010518f:	8b 00                	mov    (%eax),%eax
80105191:	39 d8                	cmp    %ebx,%eax
80105193:	76 1b                	jbe    801051b0 <fetchint+0x30>
80105195:	8d 53 04             	lea    0x4(%ebx),%edx
80105198:	39 d0                	cmp    %edx,%eax
8010519a:	72 14                	jb     801051b0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010519c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010519f:	8b 13                	mov    (%ebx),%edx
801051a1:	89 10                	mov    %edx,(%eax)
  return 0;
801051a3:	31 c0                	xor    %eax,%eax
}
801051a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051a8:	c9                   	leave  
801051a9:	c3                   	ret    
801051aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801051b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051b5:	eb ee                	jmp    801051a5 <fetchint+0x25>
801051b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051be:	66 90                	xchg   %ax,%ax

801051c0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	53                   	push   %ebx
801051c4:	83 ec 04             	sub    $0x4,%esp
801051c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801051ca:	e8 01 e9 ff ff       	call   80103ad0 <myproc>

  if(addr >= curproc->sz)
801051cf:	39 18                	cmp    %ebx,(%eax)
801051d1:	76 2d                	jbe    80105200 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801051d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801051d6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801051d8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801051da:	39 d3                	cmp    %edx,%ebx
801051dc:	73 22                	jae    80105200 <fetchstr+0x40>
801051de:	89 d8                	mov    %ebx,%eax
801051e0:	eb 0d                	jmp    801051ef <fetchstr+0x2f>
801051e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801051e8:	83 c0 01             	add    $0x1,%eax
801051eb:	39 c2                	cmp    %eax,%edx
801051ed:	76 11                	jbe    80105200 <fetchstr+0x40>
    if(*s == 0)
801051ef:	80 38 00             	cmpb   $0x0,(%eax)
801051f2:	75 f4                	jne    801051e8 <fetchstr+0x28>
      return s - *pp;
801051f4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801051f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051f9:	c9                   	leave  
801051fa:	c3                   	ret    
801051fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051ff:	90                   	nop
80105200:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105208:	c9                   	leave  
80105209:	c3                   	ret    
8010520a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105210 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	56                   	push   %esi
80105214:	53                   	push   %ebx
  struct thread *curt = &myproc()->threads[myproc()->curtidx];
80105215:	e8 b6 e8 ff ff       	call   80103ad0 <myproc>
8010521a:	89 c3                	mov    %eax,%ebx
8010521c:	e8 af e8 ff ff       	call   80103ad0 <myproc>
  return fetchint((curt->tf->esp) + 4 + 4*n, ip);
80105221:	8b 90 70 08 00 00    	mov    0x870(%eax),%edx
80105227:	c1 e2 05             	shl    $0x5,%edx
8010522a:	8b 44 13 7c          	mov    0x7c(%ebx,%edx,1),%eax
8010522e:	8b 55 08             	mov    0x8(%ebp),%edx
80105231:	8b 40 44             	mov    0x44(%eax),%eax
80105234:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105237:	e8 94 e8 ff ff       	call   80103ad0 <myproc>
  return fetchint((curt->tf->esp) + 4 + 4*n, ip);
8010523c:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010523f:	8b 00                	mov    (%eax),%eax
80105241:	39 c6                	cmp    %eax,%esi
80105243:	73 1b                	jae    80105260 <argint+0x50>
80105245:	8d 53 08             	lea    0x8(%ebx),%edx
80105248:	39 d0                	cmp    %edx,%eax
8010524a:	72 14                	jb     80105260 <argint+0x50>
  *ip = *(int*)(addr);
8010524c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010524f:	8b 53 04             	mov    0x4(%ebx),%edx
80105252:	89 10                	mov    %edx,(%eax)
  return 0;
80105254:	31 c0                	xor    %eax,%eax
}
80105256:	5b                   	pop    %ebx
80105257:	5e                   	pop    %esi
80105258:	5d                   	pop    %ebp
80105259:	c3                   	ret    
8010525a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((curt->tf->esp) + 4 + 4*n, ip);
80105265:	eb ef                	jmp    80105256 <argint+0x46>
80105267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526e:	66 90                	xchg   %ax,%ax

80105270 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	56                   	push   %esi
80105274:	53                   	push   %ebx
80105275:	83 ec 10             	sub    $0x10,%esp
80105278:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010527b:	e8 50 e8 ff ff       	call   80103ad0 <myproc>
 
  if(argint(n, &i) < 0)
80105280:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105283:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105285:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105288:	50                   	push   %eax
80105289:	ff 75 08             	push   0x8(%ebp)
8010528c:	e8 7f ff ff ff       	call   80105210 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105291:	83 c4 10             	add    $0x10,%esp
80105294:	09 d8                	or     %ebx,%eax
80105296:	78 20                	js     801052b8 <argptr+0x48>
80105298:	8b 16                	mov    (%esi),%edx
8010529a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010529d:	39 c2                	cmp    %eax,%edx
8010529f:	76 17                	jbe    801052b8 <argptr+0x48>
801052a1:	01 c3                	add    %eax,%ebx
801052a3:	39 da                	cmp    %ebx,%edx
801052a5:	72 11                	jb     801052b8 <argptr+0x48>
    return -1;
  *pp = (char*)i;
801052a7:	8b 55 0c             	mov    0xc(%ebp),%edx
801052aa:	89 02                	mov    %eax,(%edx)
  return 0;
801052ac:	31 c0                	xor    %eax,%eax
}
801052ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052b1:	5b                   	pop    %ebx
801052b2:	5e                   	pop    %esi
801052b3:	5d                   	pop    %ebp
801052b4:	c3                   	ret    
801052b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052bd:	eb ef                	jmp    801052ae <argptr+0x3e>
801052bf:	90                   	nop

801052c0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	53                   	push   %ebx
  int addr;
  if(argint(n, &addr) < 0)
801052c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801052c7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(n, &addr) < 0)
801052ca:	50                   	push   %eax
801052cb:	ff 75 08             	push   0x8(%ebp)
801052ce:	e8 3d ff ff ff       	call   80105210 <argint>
801052d3:	83 c4 10             	add    $0x10,%esp
801052d6:	85 c0                	test   %eax,%eax
801052d8:	78 36                	js     80105310 <argstr+0x50>
    return -1;
  return fetchstr(addr, pp);
801052da:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  struct proc *curproc = myproc();
801052dd:	e8 ee e7 ff ff       	call   80103ad0 <myproc>
  if(addr >= curproc->sz)
801052e2:	3b 18                	cmp    (%eax),%ebx
801052e4:	73 2a                	jae    80105310 <argstr+0x50>
  *pp = (char*)addr;
801052e6:	8b 55 0c             	mov    0xc(%ebp),%edx
801052e9:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801052eb:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801052ed:	39 d3                	cmp    %edx,%ebx
801052ef:	73 1f                	jae    80105310 <argstr+0x50>
801052f1:	89 d8                	mov    %ebx,%eax
801052f3:	eb 0a                	jmp    801052ff <argstr+0x3f>
801052f5:	8d 76 00             	lea    0x0(%esi),%esi
801052f8:	83 c0 01             	add    $0x1,%eax
801052fb:	39 c2                	cmp    %eax,%edx
801052fd:	76 11                	jbe    80105310 <argstr+0x50>
    if(*s == 0)
801052ff:	80 38 00             	cmpb   $0x0,(%eax)
80105302:	75 f4                	jne    801052f8 <argstr+0x38>
      return s - *pp;
80105304:	29 d8                	sub    %ebx,%eax
}
80105306:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105309:	c9                   	leave  
8010530a:	c3                   	ret    
8010530b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010530f:	90                   	nop
80105310:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105318:	c9                   	leave  
80105319:	c3                   	ret    
8010531a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105320 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	56                   	push   %esi
80105324:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80105325:	e8 a6 e7 ff ff       	call   80103ad0 <myproc>
  struct thread *curt = &curproc->threads[curproc->curtidx];
8010532a:	8b 90 70 08 00 00    	mov    0x870(%eax),%edx

  num = curt->tf->eax;
80105330:	89 d3                	mov    %edx,%ebx
80105332:	c1 e3 05             	shl    $0x5,%ebx
80105335:	01 c3                	add    %eax,%ebx
80105337:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
8010533a:	8b 49 1c             	mov    0x1c(%ecx),%ecx
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010533d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105340:	83 fe 14             	cmp    $0x14,%esi
80105343:	77 23                	ja     80105368 <syscall+0x48>
80105345:	8b 34 8d c0 82 10 80 	mov    -0x7fef7d40(,%ecx,4),%esi
8010534c:	85 f6                	test   %esi,%esi
8010534e:	74 18                	je     80105368 <syscall+0x48>
    curt->tf->eax = syscalls[num]();
80105350:	ff d6                	call   *%esi
80105352:	89 c2                	mov    %eax,%edx
80105354:	8b 43 7c             	mov    0x7c(%ebx),%eax
80105357:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %d %s: unknown sys call %d\n",
            curproc->pid, curt->tid, curproc->name, num);
    curt->tf->eax = -1;
  }
}
8010535a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010535d:	5b                   	pop    %ebx
8010535e:	5e                   	pop    %esi
8010535f:	5d                   	pop    %ebp
80105360:	c3                   	ret    
80105361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %d %s: unknown sys call %d\n",
80105368:	83 ec 0c             	sub    $0xc,%esp
8010536b:	c1 e2 05             	shl    $0x5,%edx
8010536e:	51                   	push   %ecx
8010536f:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
            curproc->pid, curt->tid, curproc->name, num);
80105372:	8d 48 60             	lea    0x60(%eax),%ecx
    cprintf("%d %d %s: unknown sys call %d\n",
80105375:	51                   	push   %ecx
80105376:	ff 73 74             	push   0x74(%ebx)
80105379:	ff 70 10             	push   0x10(%eax)
8010537c:	68 a0 82 10 80       	push   $0x801082a0
80105381:	e8 1a b3 ff ff       	call   801006a0 <cprintf>
    curt->tf->eax = -1;
80105386:	8b 43 7c             	mov    0x7c(%ebx),%eax
80105389:	83 c4 20             	add    $0x20,%esp
8010538c:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105393:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105396:	5b                   	pop    %ebx
80105397:	5e                   	pop    %esi
80105398:	5d                   	pop    %ebp
80105399:	c3                   	ret    
8010539a:	66 90                	xchg   %ax,%ax
8010539c:	66 90                	xchg   %ax,%ax
8010539e:	66 90                	xchg   %ax,%ax

801053a0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801053a5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801053a8:	53                   	push   %ebx
801053a9:	83 ec 34             	sub    $0x34,%esp
801053ac:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801053af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801053b2:	57                   	push   %edi
801053b3:	50                   	push   %eax
{
801053b4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801053b7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801053ba:	e8 81 cd ff ff       	call   80102140 <nameiparent>
801053bf:	83 c4 10             	add    $0x10,%esp
801053c2:	85 c0                	test   %eax,%eax
801053c4:	0f 84 46 01 00 00    	je     80105510 <create+0x170>
    return 0;
  ilock(dp);
801053ca:	83 ec 0c             	sub    $0xc,%esp
801053cd:	89 c3                	mov    %eax,%ebx
801053cf:	50                   	push   %eax
801053d0:	e8 2b c4 ff ff       	call   80101800 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801053d5:	83 c4 0c             	add    $0xc,%esp
801053d8:	6a 00                	push   $0x0
801053da:	57                   	push   %edi
801053db:	53                   	push   %ebx
801053dc:	e8 7f c9 ff ff       	call   80101d60 <dirlookup>
801053e1:	83 c4 10             	add    $0x10,%esp
801053e4:	89 c6                	mov    %eax,%esi
801053e6:	85 c0                	test   %eax,%eax
801053e8:	74 56                	je     80105440 <create+0xa0>
    iunlockput(dp);
801053ea:	83 ec 0c             	sub    $0xc,%esp
801053ed:	53                   	push   %ebx
801053ee:	e8 9d c6 ff ff       	call   80101a90 <iunlockput>
    ilock(ip);
801053f3:	89 34 24             	mov    %esi,(%esp)
801053f6:	e8 05 c4 ff ff       	call   80101800 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801053fb:	83 c4 10             	add    $0x10,%esp
801053fe:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105403:	75 1b                	jne    80105420 <create+0x80>
80105405:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010540a:	75 14                	jne    80105420 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010540c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010540f:	89 f0                	mov    %esi,%eax
80105411:	5b                   	pop    %ebx
80105412:	5e                   	pop    %esi
80105413:	5f                   	pop    %edi
80105414:	5d                   	pop    %ebp
80105415:	c3                   	ret    
80105416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010541d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105420:	83 ec 0c             	sub    $0xc,%esp
80105423:	56                   	push   %esi
    return 0;
80105424:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105426:	e8 65 c6 ff ff       	call   80101a90 <iunlockput>
    return 0;
8010542b:	83 c4 10             	add    $0x10,%esp
}
8010542e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105431:	89 f0                	mov    %esi,%eax
80105433:	5b                   	pop    %ebx
80105434:	5e                   	pop    %esi
80105435:	5f                   	pop    %edi
80105436:	5d                   	pop    %ebp
80105437:	c3                   	ret    
80105438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010543f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105440:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105444:	83 ec 08             	sub    $0x8,%esp
80105447:	50                   	push   %eax
80105448:	ff 33                	push   (%ebx)
8010544a:	e8 41 c2 ff ff       	call   80101690 <ialloc>
8010544f:	83 c4 10             	add    $0x10,%esp
80105452:	89 c6                	mov    %eax,%esi
80105454:	85 c0                	test   %eax,%eax
80105456:	0f 84 cd 00 00 00    	je     80105529 <create+0x189>
  ilock(ip);
8010545c:	83 ec 0c             	sub    $0xc,%esp
8010545f:	50                   	push   %eax
80105460:	e8 9b c3 ff ff       	call   80101800 <ilock>
  ip->major = major;
80105465:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105469:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010546d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105471:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105475:	b8 01 00 00 00       	mov    $0x1,%eax
8010547a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010547e:	89 34 24             	mov    %esi,(%esp)
80105481:	e8 ca c2 ff ff       	call   80101750 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010548e:	74 30                	je     801054c0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105490:	83 ec 04             	sub    $0x4,%esp
80105493:	ff 76 04             	push   0x4(%esi)
80105496:	57                   	push   %edi
80105497:	53                   	push   %ebx
80105498:	e8 c3 cb ff ff       	call   80102060 <dirlink>
8010549d:	83 c4 10             	add    $0x10,%esp
801054a0:	85 c0                	test   %eax,%eax
801054a2:	78 78                	js     8010551c <create+0x17c>
  iunlockput(dp);
801054a4:	83 ec 0c             	sub    $0xc,%esp
801054a7:	53                   	push   %ebx
801054a8:	e8 e3 c5 ff ff       	call   80101a90 <iunlockput>
  return ip;
801054ad:	83 c4 10             	add    $0x10,%esp
}
801054b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054b3:	89 f0                	mov    %esi,%eax
801054b5:	5b                   	pop    %ebx
801054b6:	5e                   	pop    %esi
801054b7:	5f                   	pop    %edi
801054b8:	5d                   	pop    %ebp
801054b9:	c3                   	ret    
801054ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801054c0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801054c3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801054c8:	53                   	push   %ebx
801054c9:	e8 82 c2 ff ff       	call   80101750 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801054ce:	83 c4 0c             	add    $0xc,%esp
801054d1:	ff 76 04             	push   0x4(%esi)
801054d4:	68 34 83 10 80       	push   $0x80108334
801054d9:	56                   	push   %esi
801054da:	e8 81 cb ff ff       	call   80102060 <dirlink>
801054df:	83 c4 10             	add    $0x10,%esp
801054e2:	85 c0                	test   %eax,%eax
801054e4:	78 18                	js     801054fe <create+0x15e>
801054e6:	83 ec 04             	sub    $0x4,%esp
801054e9:	ff 73 04             	push   0x4(%ebx)
801054ec:	68 33 83 10 80       	push   $0x80108333
801054f1:	56                   	push   %esi
801054f2:	e8 69 cb ff ff       	call   80102060 <dirlink>
801054f7:	83 c4 10             	add    $0x10,%esp
801054fa:	85 c0                	test   %eax,%eax
801054fc:	79 92                	jns    80105490 <create+0xf0>
      panic("create dots");
801054fe:	83 ec 0c             	sub    $0xc,%esp
80105501:	68 27 83 10 80       	push   $0x80108327
80105506:	e8 75 ae ff ff       	call   80100380 <panic>
8010550b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010550f:	90                   	nop
}
80105510:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105513:	31 f6                	xor    %esi,%esi
}
80105515:	5b                   	pop    %ebx
80105516:	89 f0                	mov    %esi,%eax
80105518:	5e                   	pop    %esi
80105519:	5f                   	pop    %edi
8010551a:	5d                   	pop    %ebp
8010551b:	c3                   	ret    
    panic("create: dirlink");
8010551c:	83 ec 0c             	sub    $0xc,%esp
8010551f:	68 36 83 10 80       	push   $0x80108336
80105524:	e8 57 ae ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105529:	83 ec 0c             	sub    $0xc,%esp
8010552c:	68 18 83 10 80       	push   $0x80108318
80105531:	e8 4a ae ff ff       	call   80100380 <panic>
80105536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010553d:	8d 76 00             	lea    0x0(%esi),%esi

80105540 <sys_dup>:
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	56                   	push   %esi
80105544:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105545:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105548:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010554b:	50                   	push   %eax
8010554c:	6a 00                	push   $0x0
8010554e:	e8 bd fc ff ff       	call   80105210 <argint>
80105553:	83 c4 10             	add    $0x10,%esp
80105556:	85 c0                	test   %eax,%eax
80105558:	78 36                	js     80105590 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010555a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010555e:	77 30                	ja     80105590 <sys_dup+0x50>
80105560:	e8 6b e5 ff ff       	call   80103ad0 <myproc>
80105565:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105568:	8b 74 90 1c          	mov    0x1c(%eax,%edx,4),%esi
8010556c:	85 f6                	test   %esi,%esi
8010556e:	74 20                	je     80105590 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105570:	e8 5b e5 ff ff       	call   80103ad0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105575:	31 db                	xor    %ebx,%ebx
80105577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010557e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105580:	8b 54 98 1c          	mov    0x1c(%eax,%ebx,4),%edx
80105584:	85 d2                	test   %edx,%edx
80105586:	74 18                	je     801055a0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105588:	83 c3 01             	add    $0x1,%ebx
8010558b:	83 fb 10             	cmp    $0x10,%ebx
8010558e:	75 f0                	jne    80105580 <sys_dup+0x40>
}
80105590:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105593:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105598:	89 d8                	mov    %ebx,%eax
8010559a:	5b                   	pop    %ebx
8010559b:	5e                   	pop    %esi
8010559c:	5d                   	pop    %ebp
8010559d:	c3                   	ret    
8010559e:	66 90                	xchg   %ax,%ax
  filedup(f);
801055a0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801055a3:	89 74 98 1c          	mov    %esi,0x1c(%eax,%ebx,4)
  filedup(f);
801055a7:	56                   	push   %esi
801055a8:	e8 73 b9 ff ff       	call   80100f20 <filedup>
  return fd;
801055ad:	83 c4 10             	add    $0x10,%esp
}
801055b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055b3:	89 d8                	mov    %ebx,%eax
801055b5:	5b                   	pop    %ebx
801055b6:	5e                   	pop    %esi
801055b7:	5d                   	pop    %ebp
801055b8:	c3                   	ret    
801055b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801055c0 <sys_read>:
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	56                   	push   %esi
801055c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801055c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801055c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801055cb:	53                   	push   %ebx
801055cc:	6a 00                	push   $0x0
801055ce:	e8 3d fc ff ff       	call   80105210 <argint>
801055d3:	83 c4 10             	add    $0x10,%esp
801055d6:	85 c0                	test   %eax,%eax
801055d8:	78 5e                	js     80105638 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055de:	77 58                	ja     80105638 <sys_read+0x78>
801055e0:	e8 eb e4 ff ff       	call   80103ad0 <myproc>
801055e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055e8:	8b 74 90 1c          	mov    0x1c(%eax,%edx,4),%esi
801055ec:	85 f6                	test   %esi,%esi
801055ee:	74 48                	je     80105638 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055f0:	83 ec 08             	sub    $0x8,%esp
801055f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055f6:	50                   	push   %eax
801055f7:	6a 02                	push   $0x2
801055f9:	e8 12 fc ff ff       	call   80105210 <argint>
801055fe:	83 c4 10             	add    $0x10,%esp
80105601:	85 c0                	test   %eax,%eax
80105603:	78 33                	js     80105638 <sys_read+0x78>
80105605:	83 ec 04             	sub    $0x4,%esp
80105608:	ff 75 f0             	push   -0x10(%ebp)
8010560b:	53                   	push   %ebx
8010560c:	6a 01                	push   $0x1
8010560e:	e8 5d fc ff ff       	call   80105270 <argptr>
80105613:	83 c4 10             	add    $0x10,%esp
80105616:	85 c0                	test   %eax,%eax
80105618:	78 1e                	js     80105638 <sys_read+0x78>
  return fileread(f, p, n);
8010561a:	83 ec 04             	sub    $0x4,%esp
8010561d:	ff 75 f0             	push   -0x10(%ebp)
80105620:	ff 75 f4             	push   -0xc(%ebp)
80105623:	56                   	push   %esi
80105624:	e8 77 ba ff ff       	call   801010a0 <fileread>
80105629:	83 c4 10             	add    $0x10,%esp
}
8010562c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010562f:	5b                   	pop    %ebx
80105630:	5e                   	pop    %esi
80105631:	5d                   	pop    %ebp
80105632:	c3                   	ret    
80105633:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105637:	90                   	nop
    return -1;
80105638:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010563d:	eb ed                	jmp    8010562c <sys_read+0x6c>
8010563f:	90                   	nop

80105640 <sys_write>:
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	56                   	push   %esi
80105644:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105645:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105648:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010564b:	53                   	push   %ebx
8010564c:	6a 00                	push   $0x0
8010564e:	e8 bd fb ff ff       	call   80105210 <argint>
80105653:	83 c4 10             	add    $0x10,%esp
80105656:	85 c0                	test   %eax,%eax
80105658:	78 5e                	js     801056b8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010565a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010565e:	77 58                	ja     801056b8 <sys_write+0x78>
80105660:	e8 6b e4 ff ff       	call   80103ad0 <myproc>
80105665:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105668:	8b 74 90 1c          	mov    0x1c(%eax,%edx,4),%esi
8010566c:	85 f6                	test   %esi,%esi
8010566e:	74 48                	je     801056b8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105670:	83 ec 08             	sub    $0x8,%esp
80105673:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105676:	50                   	push   %eax
80105677:	6a 02                	push   $0x2
80105679:	e8 92 fb ff ff       	call   80105210 <argint>
8010567e:	83 c4 10             	add    $0x10,%esp
80105681:	85 c0                	test   %eax,%eax
80105683:	78 33                	js     801056b8 <sys_write+0x78>
80105685:	83 ec 04             	sub    $0x4,%esp
80105688:	ff 75 f0             	push   -0x10(%ebp)
8010568b:	53                   	push   %ebx
8010568c:	6a 01                	push   $0x1
8010568e:	e8 dd fb ff ff       	call   80105270 <argptr>
80105693:	83 c4 10             	add    $0x10,%esp
80105696:	85 c0                	test   %eax,%eax
80105698:	78 1e                	js     801056b8 <sys_write+0x78>
  return filewrite(f, p, n);
8010569a:	83 ec 04             	sub    $0x4,%esp
8010569d:	ff 75 f0             	push   -0x10(%ebp)
801056a0:	ff 75 f4             	push   -0xc(%ebp)
801056a3:	56                   	push   %esi
801056a4:	e8 87 ba ff ff       	call   80101130 <filewrite>
801056a9:	83 c4 10             	add    $0x10,%esp
}
801056ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056af:	5b                   	pop    %ebx
801056b0:	5e                   	pop    %esi
801056b1:	5d                   	pop    %ebp
801056b2:	c3                   	ret    
801056b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056b7:	90                   	nop
    return -1;
801056b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056bd:	eb ed                	jmp    801056ac <sys_write+0x6c>
801056bf:	90                   	nop

801056c0 <sys_close>:
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	56                   	push   %esi
801056c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801056c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801056c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801056cb:	50                   	push   %eax
801056cc:	6a 00                	push   $0x0
801056ce:	e8 3d fb ff ff       	call   80105210 <argint>
801056d3:	83 c4 10             	add    $0x10,%esp
801056d6:	85 c0                	test   %eax,%eax
801056d8:	78 3e                	js     80105718 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801056da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801056de:	77 38                	ja     80105718 <sys_close+0x58>
801056e0:	e8 eb e3 ff ff       	call   80103ad0 <myproc>
801056e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056e8:	8d 5a 04             	lea    0x4(%edx),%ebx
801056eb:	8b 74 98 0c          	mov    0xc(%eax,%ebx,4),%esi
801056ef:	85 f6                	test   %esi,%esi
801056f1:	74 25                	je     80105718 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801056f3:	e8 d8 e3 ff ff       	call   80103ad0 <myproc>
  fileclose(f);
801056f8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801056fb:	c7 44 98 0c 00 00 00 	movl   $0x0,0xc(%eax,%ebx,4)
80105702:	00 
  fileclose(f);
80105703:	56                   	push   %esi
80105704:	e8 67 b8 ff ff       	call   80100f70 <fileclose>
  return 0;
80105709:	83 c4 10             	add    $0x10,%esp
8010570c:	31 c0                	xor    %eax,%eax
}
8010570e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105711:	5b                   	pop    %ebx
80105712:	5e                   	pop    %esi
80105713:	5d                   	pop    %ebp
80105714:	c3                   	ret    
80105715:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105718:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010571d:	eb ef                	jmp    8010570e <sys_close+0x4e>
8010571f:	90                   	nop

80105720 <sys_fstat>:
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	56                   	push   %esi
80105724:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105725:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105728:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010572b:	53                   	push   %ebx
8010572c:	6a 00                	push   $0x0
8010572e:	e8 dd fa ff ff       	call   80105210 <argint>
80105733:	83 c4 10             	add    $0x10,%esp
80105736:	85 c0                	test   %eax,%eax
80105738:	78 46                	js     80105780 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010573a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010573e:	77 40                	ja     80105780 <sys_fstat+0x60>
80105740:	e8 8b e3 ff ff       	call   80103ad0 <myproc>
80105745:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105748:	8b 74 90 1c          	mov    0x1c(%eax,%edx,4),%esi
8010574c:	85 f6                	test   %esi,%esi
8010574e:	74 30                	je     80105780 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105750:	83 ec 04             	sub    $0x4,%esp
80105753:	6a 14                	push   $0x14
80105755:	53                   	push   %ebx
80105756:	6a 01                	push   $0x1
80105758:	e8 13 fb ff ff       	call   80105270 <argptr>
8010575d:	83 c4 10             	add    $0x10,%esp
80105760:	85 c0                	test   %eax,%eax
80105762:	78 1c                	js     80105780 <sys_fstat+0x60>
  return filestat(f, st);
80105764:	83 ec 08             	sub    $0x8,%esp
80105767:	ff 75 f4             	push   -0xc(%ebp)
8010576a:	56                   	push   %esi
8010576b:	e8 e0 b8 ff ff       	call   80101050 <filestat>
80105770:	83 c4 10             	add    $0x10,%esp
}
80105773:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105776:	5b                   	pop    %ebx
80105777:	5e                   	pop    %esi
80105778:	5d                   	pop    %ebp
80105779:	c3                   	ret    
8010577a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105785:	eb ec                	jmp    80105773 <sys_fstat+0x53>
80105787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578e:	66 90                	xchg   %ax,%ax

80105790 <sys_link>:
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	57                   	push   %edi
80105794:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105795:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105798:	53                   	push   %ebx
80105799:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010579c:	50                   	push   %eax
8010579d:	6a 00                	push   $0x0
8010579f:	e8 1c fb ff ff       	call   801052c0 <argstr>
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	85 c0                	test   %eax,%eax
801057a9:	0f 88 fb 00 00 00    	js     801058aa <sys_link+0x11a>
801057af:	83 ec 08             	sub    $0x8,%esp
801057b2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801057b5:	50                   	push   %eax
801057b6:	6a 01                	push   $0x1
801057b8:	e8 03 fb ff ff       	call   801052c0 <argstr>
801057bd:	83 c4 10             	add    $0x10,%esp
801057c0:	85 c0                	test   %eax,%eax
801057c2:	0f 88 e2 00 00 00    	js     801058aa <sys_link+0x11a>
  begin_op();
801057c8:	e8 13 d6 ff ff       	call   80102de0 <begin_op>
  if((ip = namei(old)) == 0){
801057cd:	83 ec 0c             	sub    $0xc,%esp
801057d0:	ff 75 d4             	push   -0x2c(%ebp)
801057d3:	e8 48 c9 ff ff       	call   80102120 <namei>
801057d8:	83 c4 10             	add    $0x10,%esp
801057db:	89 c3                	mov    %eax,%ebx
801057dd:	85 c0                	test   %eax,%eax
801057df:	0f 84 e4 00 00 00    	je     801058c9 <sys_link+0x139>
  ilock(ip);
801057e5:	83 ec 0c             	sub    $0xc,%esp
801057e8:	50                   	push   %eax
801057e9:	e8 12 c0 ff ff       	call   80101800 <ilock>
  if(ip->type == T_DIR){
801057ee:	83 c4 10             	add    $0x10,%esp
801057f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057f6:	0f 84 b5 00 00 00    	je     801058b1 <sys_link+0x121>
  iupdate(ip);
801057fc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801057ff:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105804:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105807:	53                   	push   %ebx
80105808:	e8 43 bf ff ff       	call   80101750 <iupdate>
  iunlock(ip);
8010580d:	89 1c 24             	mov    %ebx,(%esp)
80105810:	e8 cb c0 ff ff       	call   801018e0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105815:	58                   	pop    %eax
80105816:	5a                   	pop    %edx
80105817:	57                   	push   %edi
80105818:	ff 75 d0             	push   -0x30(%ebp)
8010581b:	e8 20 c9 ff ff       	call   80102140 <nameiparent>
80105820:	83 c4 10             	add    $0x10,%esp
80105823:	89 c6                	mov    %eax,%esi
80105825:	85 c0                	test   %eax,%eax
80105827:	74 5b                	je     80105884 <sys_link+0xf4>
  ilock(dp);
80105829:	83 ec 0c             	sub    $0xc,%esp
8010582c:	50                   	push   %eax
8010582d:	e8 ce bf ff ff       	call   80101800 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105832:	8b 03                	mov    (%ebx),%eax
80105834:	83 c4 10             	add    $0x10,%esp
80105837:	39 06                	cmp    %eax,(%esi)
80105839:	75 3d                	jne    80105878 <sys_link+0xe8>
8010583b:	83 ec 04             	sub    $0x4,%esp
8010583e:	ff 73 04             	push   0x4(%ebx)
80105841:	57                   	push   %edi
80105842:	56                   	push   %esi
80105843:	e8 18 c8 ff ff       	call   80102060 <dirlink>
80105848:	83 c4 10             	add    $0x10,%esp
8010584b:	85 c0                	test   %eax,%eax
8010584d:	78 29                	js     80105878 <sys_link+0xe8>
  iunlockput(dp);
8010584f:	83 ec 0c             	sub    $0xc,%esp
80105852:	56                   	push   %esi
80105853:	e8 38 c2 ff ff       	call   80101a90 <iunlockput>
  iput(ip);
80105858:	89 1c 24             	mov    %ebx,(%esp)
8010585b:	e8 d0 c0 ff ff       	call   80101930 <iput>
  end_op();
80105860:	e8 eb d5 ff ff       	call   80102e50 <end_op>
  return 0;
80105865:	83 c4 10             	add    $0x10,%esp
80105868:	31 c0                	xor    %eax,%eax
}
8010586a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010586d:	5b                   	pop    %ebx
8010586e:	5e                   	pop    %esi
8010586f:	5f                   	pop    %edi
80105870:	5d                   	pop    %ebp
80105871:	c3                   	ret    
80105872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105878:	83 ec 0c             	sub    $0xc,%esp
8010587b:	56                   	push   %esi
8010587c:	e8 0f c2 ff ff       	call   80101a90 <iunlockput>
    goto bad;
80105881:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105884:	83 ec 0c             	sub    $0xc,%esp
80105887:	53                   	push   %ebx
80105888:	e8 73 bf ff ff       	call   80101800 <ilock>
  ip->nlink--;
8010588d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105892:	89 1c 24             	mov    %ebx,(%esp)
80105895:	e8 b6 be ff ff       	call   80101750 <iupdate>
  iunlockput(ip);
8010589a:	89 1c 24             	mov    %ebx,(%esp)
8010589d:	e8 ee c1 ff ff       	call   80101a90 <iunlockput>
  end_op();
801058a2:	e8 a9 d5 ff ff       	call   80102e50 <end_op>
  return -1;
801058a7:	83 c4 10             	add    $0x10,%esp
801058aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058af:	eb b9                	jmp    8010586a <sys_link+0xda>
    iunlockput(ip);
801058b1:	83 ec 0c             	sub    $0xc,%esp
801058b4:	53                   	push   %ebx
801058b5:	e8 d6 c1 ff ff       	call   80101a90 <iunlockput>
    end_op();
801058ba:	e8 91 d5 ff ff       	call   80102e50 <end_op>
    return -1;
801058bf:	83 c4 10             	add    $0x10,%esp
801058c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c7:	eb a1                	jmp    8010586a <sys_link+0xda>
    end_op();
801058c9:	e8 82 d5 ff ff       	call   80102e50 <end_op>
    return -1;
801058ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d3:	eb 95                	jmp    8010586a <sys_link+0xda>
801058d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058e0 <sys_unlink>:
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	57                   	push   %edi
801058e4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801058e5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801058e8:	53                   	push   %ebx
801058e9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801058ec:	50                   	push   %eax
801058ed:	6a 00                	push   $0x0
801058ef:	e8 cc f9 ff ff       	call   801052c0 <argstr>
801058f4:	83 c4 10             	add    $0x10,%esp
801058f7:	85 c0                	test   %eax,%eax
801058f9:	0f 88 7a 01 00 00    	js     80105a79 <sys_unlink+0x199>
  begin_op();
801058ff:	e8 dc d4 ff ff       	call   80102de0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105904:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105907:	83 ec 08             	sub    $0x8,%esp
8010590a:	53                   	push   %ebx
8010590b:	ff 75 c0             	push   -0x40(%ebp)
8010590e:	e8 2d c8 ff ff       	call   80102140 <nameiparent>
80105913:	83 c4 10             	add    $0x10,%esp
80105916:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105919:	85 c0                	test   %eax,%eax
8010591b:	0f 84 62 01 00 00    	je     80105a83 <sys_unlink+0x1a3>
  ilock(dp);
80105921:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105924:	83 ec 0c             	sub    $0xc,%esp
80105927:	57                   	push   %edi
80105928:	e8 d3 be ff ff       	call   80101800 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010592d:	58                   	pop    %eax
8010592e:	5a                   	pop    %edx
8010592f:	68 34 83 10 80       	push   $0x80108334
80105934:	53                   	push   %ebx
80105935:	e8 06 c4 ff ff       	call   80101d40 <namecmp>
8010593a:	83 c4 10             	add    $0x10,%esp
8010593d:	85 c0                	test   %eax,%eax
8010593f:	0f 84 fb 00 00 00    	je     80105a40 <sys_unlink+0x160>
80105945:	83 ec 08             	sub    $0x8,%esp
80105948:	68 33 83 10 80       	push   $0x80108333
8010594d:	53                   	push   %ebx
8010594e:	e8 ed c3 ff ff       	call   80101d40 <namecmp>
80105953:	83 c4 10             	add    $0x10,%esp
80105956:	85 c0                	test   %eax,%eax
80105958:	0f 84 e2 00 00 00    	je     80105a40 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010595e:	83 ec 04             	sub    $0x4,%esp
80105961:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105964:	50                   	push   %eax
80105965:	53                   	push   %ebx
80105966:	57                   	push   %edi
80105967:	e8 f4 c3 ff ff       	call   80101d60 <dirlookup>
8010596c:	83 c4 10             	add    $0x10,%esp
8010596f:	89 c3                	mov    %eax,%ebx
80105971:	85 c0                	test   %eax,%eax
80105973:	0f 84 c7 00 00 00    	je     80105a40 <sys_unlink+0x160>
  ilock(ip);
80105979:	83 ec 0c             	sub    $0xc,%esp
8010597c:	50                   	push   %eax
8010597d:	e8 7e be ff ff       	call   80101800 <ilock>
  if(ip->nlink < 1)
80105982:	83 c4 10             	add    $0x10,%esp
80105985:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010598a:	0f 8e 1c 01 00 00    	jle    80105aac <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105990:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105995:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105998:	74 66                	je     80105a00 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010599a:	83 ec 04             	sub    $0x4,%esp
8010599d:	6a 10                	push   $0x10
8010599f:	6a 00                	push   $0x0
801059a1:	57                   	push   %edi
801059a2:	e8 a9 f5 ff ff       	call   80104f50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059a7:	6a 10                	push   $0x10
801059a9:	ff 75 c4             	push   -0x3c(%ebp)
801059ac:	57                   	push   %edi
801059ad:	ff 75 b4             	push   -0x4c(%ebp)
801059b0:	e8 5b c2 ff ff       	call   80101c10 <writei>
801059b5:	83 c4 20             	add    $0x20,%esp
801059b8:	83 f8 10             	cmp    $0x10,%eax
801059bb:	0f 85 de 00 00 00    	jne    80105a9f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801059c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059c6:	0f 84 94 00 00 00    	je     80105a60 <sys_unlink+0x180>
  iunlockput(dp);
801059cc:	83 ec 0c             	sub    $0xc,%esp
801059cf:	ff 75 b4             	push   -0x4c(%ebp)
801059d2:	e8 b9 c0 ff ff       	call   80101a90 <iunlockput>
  ip->nlink--;
801059d7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801059dc:	89 1c 24             	mov    %ebx,(%esp)
801059df:	e8 6c bd ff ff       	call   80101750 <iupdate>
  iunlockput(ip);
801059e4:	89 1c 24             	mov    %ebx,(%esp)
801059e7:	e8 a4 c0 ff ff       	call   80101a90 <iunlockput>
  end_op();
801059ec:	e8 5f d4 ff ff       	call   80102e50 <end_op>
  return 0;
801059f1:	83 c4 10             	add    $0x10,%esp
801059f4:	31 c0                	xor    %eax,%eax
}
801059f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059f9:	5b                   	pop    %ebx
801059fa:	5e                   	pop    %esi
801059fb:	5f                   	pop    %edi
801059fc:	5d                   	pop    %ebp
801059fd:	c3                   	ret    
801059fe:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a00:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105a04:	76 94                	jbe    8010599a <sys_unlink+0xba>
80105a06:	be 20 00 00 00       	mov    $0x20,%esi
80105a0b:	eb 0b                	jmp    80105a18 <sys_unlink+0x138>
80105a0d:	8d 76 00             	lea    0x0(%esi),%esi
80105a10:	83 c6 10             	add    $0x10,%esi
80105a13:	3b 73 58             	cmp    0x58(%ebx),%esi
80105a16:	73 82                	jae    8010599a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a18:	6a 10                	push   $0x10
80105a1a:	56                   	push   %esi
80105a1b:	57                   	push   %edi
80105a1c:	53                   	push   %ebx
80105a1d:	e8 ee c0 ff ff       	call   80101b10 <readi>
80105a22:	83 c4 10             	add    $0x10,%esp
80105a25:	83 f8 10             	cmp    $0x10,%eax
80105a28:	75 68                	jne    80105a92 <sys_unlink+0x1b2>
    if(de.inum != 0)
80105a2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105a2f:	74 df                	je     80105a10 <sys_unlink+0x130>
    iunlockput(ip);
80105a31:	83 ec 0c             	sub    $0xc,%esp
80105a34:	53                   	push   %ebx
80105a35:	e8 56 c0 ff ff       	call   80101a90 <iunlockput>
    goto bad;
80105a3a:	83 c4 10             	add    $0x10,%esp
80105a3d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105a40:	83 ec 0c             	sub    $0xc,%esp
80105a43:	ff 75 b4             	push   -0x4c(%ebp)
80105a46:	e8 45 c0 ff ff       	call   80101a90 <iunlockput>
  end_op();
80105a4b:	e8 00 d4 ff ff       	call   80102e50 <end_op>
  return -1;
80105a50:	83 c4 10             	add    $0x10,%esp
80105a53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a58:	eb 9c                	jmp    801059f6 <sys_unlink+0x116>
80105a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105a60:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105a63:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105a66:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105a6b:	50                   	push   %eax
80105a6c:	e8 df bc ff ff       	call   80101750 <iupdate>
80105a71:	83 c4 10             	add    $0x10,%esp
80105a74:	e9 53 ff ff ff       	jmp    801059cc <sys_unlink+0xec>
    return -1;
80105a79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a7e:	e9 73 ff ff ff       	jmp    801059f6 <sys_unlink+0x116>
    end_op();
80105a83:	e8 c8 d3 ff ff       	call   80102e50 <end_op>
    return -1;
80105a88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a8d:	e9 64 ff ff ff       	jmp    801059f6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105a92:	83 ec 0c             	sub    $0xc,%esp
80105a95:	68 58 83 10 80       	push   $0x80108358
80105a9a:	e8 e1 a8 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105a9f:	83 ec 0c             	sub    $0xc,%esp
80105aa2:	68 6a 83 10 80       	push   $0x8010836a
80105aa7:	e8 d4 a8 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105aac:	83 ec 0c             	sub    $0xc,%esp
80105aaf:	68 46 83 10 80       	push   $0x80108346
80105ab4:	e8 c7 a8 ff ff       	call   80100380 <panic>
80105ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ac0 <sys_open>:

int
sys_open(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	57                   	push   %edi
80105ac4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ac5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105ac8:	53                   	push   %ebx
80105ac9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105acc:	50                   	push   %eax
80105acd:	6a 00                	push   $0x0
80105acf:	e8 ec f7 ff ff       	call   801052c0 <argstr>
80105ad4:	83 c4 10             	add    $0x10,%esp
80105ad7:	85 c0                	test   %eax,%eax
80105ad9:	0f 88 8e 00 00 00    	js     80105b6d <sys_open+0xad>
80105adf:	83 ec 08             	sub    $0x8,%esp
80105ae2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ae5:	50                   	push   %eax
80105ae6:	6a 01                	push   $0x1
80105ae8:	e8 23 f7 ff ff       	call   80105210 <argint>
80105aed:	83 c4 10             	add    $0x10,%esp
80105af0:	85 c0                	test   %eax,%eax
80105af2:	78 79                	js     80105b6d <sys_open+0xad>
    return -1;

  begin_op();
80105af4:	e8 e7 d2 ff ff       	call   80102de0 <begin_op>

  if(omode & O_CREATE){
80105af9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105afd:	75 79                	jne    80105b78 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105aff:	83 ec 0c             	sub    $0xc,%esp
80105b02:	ff 75 e0             	push   -0x20(%ebp)
80105b05:	e8 16 c6 ff ff       	call   80102120 <namei>
80105b0a:	83 c4 10             	add    $0x10,%esp
80105b0d:	89 c6                	mov    %eax,%esi
80105b0f:	85 c0                	test   %eax,%eax
80105b11:	0f 84 7e 00 00 00    	je     80105b95 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105b17:	83 ec 0c             	sub    $0xc,%esp
80105b1a:	50                   	push   %eax
80105b1b:	e8 e0 bc ff ff       	call   80101800 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b20:	83 c4 10             	add    $0x10,%esp
80105b23:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105b28:	0f 84 c2 00 00 00    	je     80105bf0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105b2e:	e8 7d b3 ff ff       	call   80100eb0 <filealloc>
80105b33:	89 c7                	mov    %eax,%edi
80105b35:	85 c0                	test   %eax,%eax
80105b37:	74 23                	je     80105b5c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105b39:	e8 92 df ff ff       	call   80103ad0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b3e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105b40:	8b 54 98 1c          	mov    0x1c(%eax,%ebx,4),%edx
80105b44:	85 d2                	test   %edx,%edx
80105b46:	74 60                	je     80105ba8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105b48:	83 c3 01             	add    $0x1,%ebx
80105b4b:	83 fb 10             	cmp    $0x10,%ebx
80105b4e:	75 f0                	jne    80105b40 <sys_open+0x80>
    if(f)
      fileclose(f);
80105b50:	83 ec 0c             	sub    $0xc,%esp
80105b53:	57                   	push   %edi
80105b54:	e8 17 b4 ff ff       	call   80100f70 <fileclose>
80105b59:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105b5c:	83 ec 0c             	sub    $0xc,%esp
80105b5f:	56                   	push   %esi
80105b60:	e8 2b bf ff ff       	call   80101a90 <iunlockput>
    end_op();
80105b65:	e8 e6 d2 ff ff       	call   80102e50 <end_op>
    return -1;
80105b6a:	83 c4 10             	add    $0x10,%esp
80105b6d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b72:	eb 6d                	jmp    80105be1 <sys_open+0x121>
80105b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105b78:	83 ec 0c             	sub    $0xc,%esp
80105b7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105b7e:	31 c9                	xor    %ecx,%ecx
80105b80:	ba 02 00 00 00       	mov    $0x2,%edx
80105b85:	6a 00                	push   $0x0
80105b87:	e8 14 f8 ff ff       	call   801053a0 <create>
    if(ip == 0){
80105b8c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105b8f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b91:	85 c0                	test   %eax,%eax
80105b93:	75 99                	jne    80105b2e <sys_open+0x6e>
      end_op();
80105b95:	e8 b6 d2 ff ff       	call   80102e50 <end_op>
      return -1;
80105b9a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b9f:	eb 40                	jmp    80105be1 <sys_open+0x121>
80105ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105ba8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105bab:	89 7c 98 1c          	mov    %edi,0x1c(%eax,%ebx,4)
  iunlock(ip);
80105baf:	56                   	push   %esi
80105bb0:	e8 2b bd ff ff       	call   801018e0 <iunlock>
  end_op();
80105bb5:	e8 96 d2 ff ff       	call   80102e50 <end_op>

  f->type = FD_INODE;
80105bba:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105bc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bc3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105bc6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105bc9:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105bcb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105bd2:	f7 d0                	not    %eax
80105bd4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bd7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105bda:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bdd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105be1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105be4:	89 d8                	mov    %ebx,%eax
80105be6:	5b                   	pop    %ebx
80105be7:	5e                   	pop    %esi
80105be8:	5f                   	pop    %edi
80105be9:	5d                   	pop    %ebp
80105bea:	c3                   	ret    
80105beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bef:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105bf0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105bf3:	85 c9                	test   %ecx,%ecx
80105bf5:	0f 84 33 ff ff ff    	je     80105b2e <sys_open+0x6e>
80105bfb:	e9 5c ff ff ff       	jmp    80105b5c <sys_open+0x9c>

80105c00 <sys_mkdir>:

int
sys_mkdir(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105c06:	e8 d5 d1 ff ff       	call   80102de0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105c0b:	83 ec 08             	sub    $0x8,%esp
80105c0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c11:	50                   	push   %eax
80105c12:	6a 00                	push   $0x0
80105c14:	e8 a7 f6 ff ff       	call   801052c0 <argstr>
80105c19:	83 c4 10             	add    $0x10,%esp
80105c1c:	85 c0                	test   %eax,%eax
80105c1e:	78 30                	js     80105c50 <sys_mkdir+0x50>
80105c20:	83 ec 0c             	sub    $0xc,%esp
80105c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c26:	31 c9                	xor    %ecx,%ecx
80105c28:	ba 01 00 00 00       	mov    $0x1,%edx
80105c2d:	6a 00                	push   $0x0
80105c2f:	e8 6c f7 ff ff       	call   801053a0 <create>
80105c34:	83 c4 10             	add    $0x10,%esp
80105c37:	85 c0                	test   %eax,%eax
80105c39:	74 15                	je     80105c50 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c3b:	83 ec 0c             	sub    $0xc,%esp
80105c3e:	50                   	push   %eax
80105c3f:	e8 4c be ff ff       	call   80101a90 <iunlockput>
  end_op();
80105c44:	e8 07 d2 ff ff       	call   80102e50 <end_op>
  return 0;
80105c49:	83 c4 10             	add    $0x10,%esp
80105c4c:	31 c0                	xor    %eax,%eax
}
80105c4e:	c9                   	leave  
80105c4f:	c3                   	ret    
    end_op();
80105c50:	e8 fb d1 ff ff       	call   80102e50 <end_op>
    return -1;
80105c55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c5a:	c9                   	leave  
80105c5b:	c3                   	ret    
80105c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c60 <sys_mknod>:

int
sys_mknod(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105c66:	e8 75 d1 ff ff       	call   80102de0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105c6b:	83 ec 08             	sub    $0x8,%esp
80105c6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c71:	50                   	push   %eax
80105c72:	6a 00                	push   $0x0
80105c74:	e8 47 f6 ff ff       	call   801052c0 <argstr>
80105c79:	83 c4 10             	add    $0x10,%esp
80105c7c:	85 c0                	test   %eax,%eax
80105c7e:	78 60                	js     80105ce0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105c80:	83 ec 08             	sub    $0x8,%esp
80105c83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c86:	50                   	push   %eax
80105c87:	6a 01                	push   $0x1
80105c89:	e8 82 f5 ff ff       	call   80105210 <argint>
  if((argstr(0, &path)) < 0 ||
80105c8e:	83 c4 10             	add    $0x10,%esp
80105c91:	85 c0                	test   %eax,%eax
80105c93:	78 4b                	js     80105ce0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105c95:	83 ec 08             	sub    $0x8,%esp
80105c98:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c9b:	50                   	push   %eax
80105c9c:	6a 02                	push   $0x2
80105c9e:	e8 6d f5 ff ff       	call   80105210 <argint>
     argint(1, &major) < 0 ||
80105ca3:	83 c4 10             	add    $0x10,%esp
80105ca6:	85 c0                	test   %eax,%eax
80105ca8:	78 36                	js     80105ce0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105caa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105cae:	83 ec 0c             	sub    $0xc,%esp
80105cb1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105cb5:	ba 03 00 00 00       	mov    $0x3,%edx
80105cba:	50                   	push   %eax
80105cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105cbe:	e8 dd f6 ff ff       	call   801053a0 <create>
     argint(2, &minor) < 0 ||
80105cc3:	83 c4 10             	add    $0x10,%esp
80105cc6:	85 c0                	test   %eax,%eax
80105cc8:	74 16                	je     80105ce0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105cca:	83 ec 0c             	sub    $0xc,%esp
80105ccd:	50                   	push   %eax
80105cce:	e8 bd bd ff ff       	call   80101a90 <iunlockput>
  end_op();
80105cd3:	e8 78 d1 ff ff       	call   80102e50 <end_op>
  return 0;
80105cd8:	83 c4 10             	add    $0x10,%esp
80105cdb:	31 c0                	xor    %eax,%eax
}
80105cdd:	c9                   	leave  
80105cde:	c3                   	ret    
80105cdf:	90                   	nop
    end_op();
80105ce0:	e8 6b d1 ff ff       	call   80102e50 <end_op>
    return -1;
80105ce5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cea:	c9                   	leave  
80105ceb:	c3                   	ret    
80105cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cf0 <sys_chdir>:

int
sys_chdir(void)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	56                   	push   %esi
80105cf4:	53                   	push   %ebx
80105cf5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105cf8:	e8 d3 dd ff ff       	call   80103ad0 <myproc>
80105cfd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105cff:	e8 dc d0 ff ff       	call   80102de0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105d04:	83 ec 08             	sub    $0x8,%esp
80105d07:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d0a:	50                   	push   %eax
80105d0b:	6a 00                	push   $0x0
80105d0d:	e8 ae f5 ff ff       	call   801052c0 <argstr>
80105d12:	83 c4 10             	add    $0x10,%esp
80105d15:	85 c0                	test   %eax,%eax
80105d17:	78 77                	js     80105d90 <sys_chdir+0xa0>
80105d19:	83 ec 0c             	sub    $0xc,%esp
80105d1c:	ff 75 f4             	push   -0xc(%ebp)
80105d1f:	e8 fc c3 ff ff       	call   80102120 <namei>
80105d24:	83 c4 10             	add    $0x10,%esp
80105d27:	89 c3                	mov    %eax,%ebx
80105d29:	85 c0                	test   %eax,%eax
80105d2b:	74 63                	je     80105d90 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105d2d:	83 ec 0c             	sub    $0xc,%esp
80105d30:	50                   	push   %eax
80105d31:	e8 ca ba ff ff       	call   80101800 <ilock>
  if(ip->type != T_DIR){
80105d36:	83 c4 10             	add    $0x10,%esp
80105d39:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d3e:	75 30                	jne    80105d70 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105d40:	83 ec 0c             	sub    $0xc,%esp
80105d43:	53                   	push   %ebx
80105d44:	e8 97 bb ff ff       	call   801018e0 <iunlock>
  iput(curproc->cwd);
80105d49:	58                   	pop    %eax
80105d4a:	ff 76 5c             	push   0x5c(%esi)
80105d4d:	e8 de bb ff ff       	call   80101930 <iput>
  end_op();
80105d52:	e8 f9 d0 ff ff       	call   80102e50 <end_op>
  curproc->cwd = ip;
80105d57:	89 5e 5c             	mov    %ebx,0x5c(%esi)
  return 0;
80105d5a:	83 c4 10             	add    $0x10,%esp
80105d5d:	31 c0                	xor    %eax,%eax
}
80105d5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d62:	5b                   	pop    %ebx
80105d63:	5e                   	pop    %esi
80105d64:	5d                   	pop    %ebp
80105d65:	c3                   	ret    
80105d66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105d70:	83 ec 0c             	sub    $0xc,%esp
80105d73:	53                   	push   %ebx
80105d74:	e8 17 bd ff ff       	call   80101a90 <iunlockput>
    end_op();
80105d79:	e8 d2 d0 ff ff       	call   80102e50 <end_op>
    return -1;
80105d7e:	83 c4 10             	add    $0x10,%esp
80105d81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d86:	eb d7                	jmp    80105d5f <sys_chdir+0x6f>
80105d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d8f:	90                   	nop
    end_op();
80105d90:	e8 bb d0 ff ff       	call   80102e50 <end_op>
    return -1;
80105d95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d9a:	eb c3                	jmp    80105d5f <sys_chdir+0x6f>
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105da0 <sys_exec>:

int
sys_exec(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	57                   	push   %edi
80105da4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105da5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105dab:	53                   	push   %ebx
80105dac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105db2:	50                   	push   %eax
80105db3:	6a 00                	push   $0x0
80105db5:	e8 06 f5 ff ff       	call   801052c0 <argstr>
80105dba:	83 c4 10             	add    $0x10,%esp
80105dbd:	85 c0                	test   %eax,%eax
80105dbf:	0f 88 87 00 00 00    	js     80105e4c <sys_exec+0xac>
80105dc5:	83 ec 08             	sub    $0x8,%esp
80105dc8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105dce:	50                   	push   %eax
80105dcf:	6a 01                	push   $0x1
80105dd1:	e8 3a f4 ff ff       	call   80105210 <argint>
80105dd6:	83 c4 10             	add    $0x10,%esp
80105dd9:	85 c0                	test   %eax,%eax
80105ddb:	78 6f                	js     80105e4c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105ddd:	83 ec 04             	sub    $0x4,%esp
80105de0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105de6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105de8:	68 80 00 00 00       	push   $0x80
80105ded:	6a 00                	push   $0x0
80105def:	56                   	push   %esi
80105df0:	e8 5b f1 ff ff       	call   80104f50 <memset>
80105df5:	83 c4 10             	add    $0x10,%esp
80105df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dff:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105e00:	83 ec 08             	sub    $0x8,%esp
80105e03:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105e09:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105e10:	50                   	push   %eax
80105e11:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105e17:	01 f8                	add    %edi,%eax
80105e19:	50                   	push   %eax
80105e1a:	e8 61 f3 ff ff       	call   80105180 <fetchint>
80105e1f:	83 c4 10             	add    $0x10,%esp
80105e22:	85 c0                	test   %eax,%eax
80105e24:	78 26                	js     80105e4c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105e26:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105e2c:	85 c0                	test   %eax,%eax
80105e2e:	74 30                	je     80105e60 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e30:	83 ec 08             	sub    $0x8,%esp
80105e33:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105e36:	52                   	push   %edx
80105e37:	50                   	push   %eax
80105e38:	e8 83 f3 ff ff       	call   801051c0 <fetchstr>
80105e3d:	83 c4 10             	add    $0x10,%esp
80105e40:	85 c0                	test   %eax,%eax
80105e42:	78 08                	js     80105e4c <sys_exec+0xac>
  for(i=0;; i++){
80105e44:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105e47:	83 fb 20             	cmp    $0x20,%ebx
80105e4a:	75 b4                	jne    80105e00 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105e4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e54:	5b                   	pop    %ebx
80105e55:	5e                   	pop    %esi
80105e56:	5f                   	pop    %edi
80105e57:	5d                   	pop    %ebp
80105e58:	c3                   	ret    
80105e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105e60:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105e67:	00 00 00 00 
  return exec(path, argv);
80105e6b:	83 ec 08             	sub    $0x8,%esp
80105e6e:	56                   	push   %esi
80105e6f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105e75:	e8 36 ac ff ff       	call   80100ab0 <exec>
80105e7a:	83 c4 10             	add    $0x10,%esp
}
80105e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e80:	5b                   	pop    %ebx
80105e81:	5e                   	pop    %esi
80105e82:	5f                   	pop    %edi
80105e83:	5d                   	pop    %ebp
80105e84:	c3                   	ret    
80105e85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e90 <sys_pipe>:

int
sys_pipe(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	57                   	push   %edi
80105e94:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e95:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e98:	53                   	push   %ebx
80105e99:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e9c:	6a 08                	push   $0x8
80105e9e:	50                   	push   %eax
80105e9f:	6a 00                	push   $0x0
80105ea1:	e8 ca f3 ff ff       	call   80105270 <argptr>
80105ea6:	83 c4 10             	add    $0x10,%esp
80105ea9:	85 c0                	test   %eax,%eax
80105eab:	78 4a                	js     80105ef7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ead:	83 ec 08             	sub    $0x8,%esp
80105eb0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105eb3:	50                   	push   %eax
80105eb4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105eb7:	50                   	push   %eax
80105eb8:	e8 f3 d5 ff ff       	call   801034b0 <pipealloc>
80105ebd:	83 c4 10             	add    $0x10,%esp
80105ec0:	85 c0                	test   %eax,%eax
80105ec2:	78 33                	js     80105ef7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ec4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105ec7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105ec9:	e8 02 dc ff ff       	call   80103ad0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ece:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105ed0:	8b 74 98 1c          	mov    0x1c(%eax,%ebx,4),%esi
80105ed4:	85 f6                	test   %esi,%esi
80105ed6:	74 28                	je     80105f00 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105ed8:	83 c3 01             	add    $0x1,%ebx
80105edb:	83 fb 10             	cmp    $0x10,%ebx
80105ede:	75 f0                	jne    80105ed0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105ee0:	83 ec 0c             	sub    $0xc,%esp
80105ee3:	ff 75 e0             	push   -0x20(%ebp)
80105ee6:	e8 85 b0 ff ff       	call   80100f70 <fileclose>
    fileclose(wf);
80105eeb:	58                   	pop    %eax
80105eec:	ff 75 e4             	push   -0x1c(%ebp)
80105eef:	e8 7c b0 ff ff       	call   80100f70 <fileclose>
    return -1;
80105ef4:	83 c4 10             	add    $0x10,%esp
80105ef7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105efc:	eb 53                	jmp    80105f51 <sys_pipe+0xc1>
80105efe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105f00:	8d 73 04             	lea    0x4(%ebx),%esi
80105f03:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f07:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105f0a:	e8 c1 db ff ff       	call   80103ad0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f0f:	31 d2                	xor    %edx,%edx
80105f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105f18:	8b 4c 90 1c          	mov    0x1c(%eax,%edx,4),%ecx
80105f1c:	85 c9                	test   %ecx,%ecx
80105f1e:	74 20                	je     80105f40 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105f20:	83 c2 01             	add    $0x1,%edx
80105f23:	83 fa 10             	cmp    $0x10,%edx
80105f26:	75 f0                	jne    80105f18 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105f28:	e8 a3 db ff ff       	call   80103ad0 <myproc>
80105f2d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105f34:	00 
80105f35:	eb a9                	jmp    80105ee0 <sys_pipe+0x50>
80105f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105f40:	89 7c 90 1c          	mov    %edi,0x1c(%eax,%edx,4)
  }
  fd[0] = fd0;
80105f44:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f47:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105f49:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f4c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105f4f:	31 c0                	xor    %eax,%eax
}
80105f51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f54:	5b                   	pop    %ebx
80105f55:	5e                   	pop    %esi
80105f56:	5f                   	pop    %edi
80105f57:	5d                   	pop    %ebp
80105f58:	c3                   	ret    
80105f59:	66 90                	xchg   %ax,%ax
80105f5b:	66 90                	xchg   %ax,%ax
80105f5d:	66 90                	xchg   %ax,%ax
80105f5f:	90                   	nop

80105f60 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105f60:	e9 1b dd ff ff       	jmp    80103c80 <fork>
80105f65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f70 <sys_exit>:
}

int
sys_exit(void)
{
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
80105f73:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f76:	e8 85 e0 ff ff       	call   80104000 <exit>
  return 0;  // not reached
}
80105f7b:	31 c0                	xor    %eax,%eax
80105f7d:	c9                   	leave  
80105f7e:	c3                   	ret    
80105f7f:	90                   	nop

80105f80 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105f80:	e9 2b e3 ff ff       	jmp    801042b0 <wait>
80105f85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f90 <sys_kill>:
}

int
sys_kill(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f96:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f99:	50                   	push   %eax
80105f9a:	6a 00                	push   $0x0
80105f9c:	e8 6f f2 ff ff       	call   80105210 <argint>
80105fa1:	83 c4 10             	add    $0x10,%esp
80105fa4:	85 c0                	test   %eax,%eax
80105fa6:	78 18                	js     80105fc0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105fa8:	83 ec 0c             	sub    $0xc,%esp
80105fab:	ff 75 f4             	push   -0xc(%ebp)
80105fae:	e8 bd e4 ff ff       	call   80104470 <kill>
80105fb3:	83 c4 10             	add    $0x10,%esp
}
80105fb6:	c9                   	leave  
80105fb7:	c3                   	ret    
80105fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fbf:	90                   	nop
80105fc0:	c9                   	leave  
    return -1;
80105fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fc6:	c3                   	ret    
80105fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fce:	66 90                	xchg   %ax,%ax

80105fd0 <sys_getpid>:

int
sys_getpid(void)
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105fd6:	e8 f5 da ff ff       	call   80103ad0 <myproc>
80105fdb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105fde:	c9                   	leave  
80105fdf:	c3                   	ret    

80105fe0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105fe4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105fe7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105fea:	50                   	push   %eax
80105feb:	6a 00                	push   $0x0
80105fed:	e8 1e f2 ff ff       	call   80105210 <argint>
80105ff2:	83 c4 10             	add    $0x10,%esp
80105ff5:	85 c0                	test   %eax,%eax
80105ff7:	78 27                	js     80106020 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ff9:	e8 d2 da ff ff       	call   80103ad0 <myproc>
  if(growproc(n) < 0)
80105ffe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106001:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106003:	ff 75 f4             	push   -0xc(%ebp)
80106006:	e8 f5 db ff ff       	call   80103c00 <growproc>
8010600b:	83 c4 10             	add    $0x10,%esp
8010600e:	85 c0                	test   %eax,%eax
80106010:	78 0e                	js     80106020 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106012:	89 d8                	mov    %ebx,%eax
80106014:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106017:	c9                   	leave  
80106018:	c3                   	ret    
80106019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106020:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106025:	eb eb                	jmp    80106012 <sys_sbrk+0x32>
80106027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010602e:	66 90                	xchg   %ax,%ax

80106030 <sys_sleep>:

int
sys_sleep(void)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106034:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106037:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010603a:	50                   	push   %eax
8010603b:	6a 00                	push   $0x0
8010603d:	e8 ce f1 ff ff       	call   80105210 <argint>
80106042:	83 c4 10             	add    $0x10,%esp
80106045:	85 c0                	test   %eax,%eax
80106047:	0f 88 8a 00 00 00    	js     801060d7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010604d:	83 ec 0c             	sub    $0xc,%esp
80106050:	68 80 4a 13 80       	push   $0x80134a80
80106055:	e8 36 ee ff ff       	call   80104e90 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010605a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010605d:	8b 1d 60 4a 13 80    	mov    0x80134a60,%ebx
  while(ticks - ticks0 < n){
80106063:	83 c4 10             	add    $0x10,%esp
80106066:	85 d2                	test   %edx,%edx
80106068:	75 27                	jne    80106091 <sys_sleep+0x61>
8010606a:	eb 54                	jmp    801060c0 <sys_sleep+0x90>
8010606c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106070:	83 ec 08             	sub    $0x8,%esp
80106073:	68 80 4a 13 80       	push   $0x80134a80
80106078:	68 60 4a 13 80       	push   $0x80134a60
8010607d:	e8 2e e1 ff ff       	call   801041b0 <sleep>
  while(ticks - ticks0 < n){
80106082:	a1 60 4a 13 80       	mov    0x80134a60,%eax
80106087:	83 c4 10             	add    $0x10,%esp
8010608a:	29 d8                	sub    %ebx,%eax
8010608c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010608f:	73 2f                	jae    801060c0 <sys_sleep+0x90>
    if(myproc()->killed){
80106091:	e8 3a da ff ff       	call   80103ad0 <myproc>
80106096:	8b 40 18             	mov    0x18(%eax),%eax
80106099:	85 c0                	test   %eax,%eax
8010609b:	74 d3                	je     80106070 <sys_sleep+0x40>
      release(&tickslock);
8010609d:	83 ec 0c             	sub    $0xc,%esp
801060a0:	68 80 4a 13 80       	push   $0x80134a80
801060a5:	e8 86 ed ff ff       	call   80104e30 <release>
  }
  release(&tickslock);
  return 0;
}
801060aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801060ad:	83 c4 10             	add    $0x10,%esp
801060b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060b5:	c9                   	leave  
801060b6:	c3                   	ret    
801060b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060be:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801060c0:	83 ec 0c             	sub    $0xc,%esp
801060c3:	68 80 4a 13 80       	push   $0x80134a80
801060c8:	e8 63 ed ff ff       	call   80104e30 <release>
  return 0;
801060cd:	83 c4 10             	add    $0x10,%esp
801060d0:	31 c0                	xor    %eax,%eax
}
801060d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060d5:	c9                   	leave  
801060d6:	c3                   	ret    
    return -1;
801060d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060dc:	eb f4                	jmp    801060d2 <sys_sleep+0xa2>
801060de:	66 90                	xchg   %ax,%ax

801060e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801060e0:	55                   	push   %ebp
801060e1:	89 e5                	mov    %esp,%ebp
801060e3:	53                   	push   %ebx
801060e4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801060e7:	68 80 4a 13 80       	push   $0x80134a80
801060ec:	e8 9f ed ff ff       	call   80104e90 <acquire>
  xticks = ticks;
801060f1:	8b 1d 60 4a 13 80    	mov    0x80134a60,%ebx
  release(&tickslock);
801060f7:	c7 04 24 80 4a 13 80 	movl   $0x80134a80,(%esp)
801060fe:	e8 2d ed ff ff       	call   80104e30 <release>
  return xticks;
}
80106103:	89 d8                	mov    %ebx,%eax
80106105:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106108:	c9                   	leave  
80106109:	c3                   	ret    

8010610a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010610a:	1e                   	push   %ds
  pushl %es
8010610b:	06                   	push   %es
  pushl %fs
8010610c:	0f a0                	push   %fs
  pushl %gs
8010610e:	0f a8                	push   %gs
  pushal
80106110:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106111:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106115:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106117:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106119:	54                   	push   %esp
  call trap
8010611a:	e8 c1 00 00 00       	call   801061e0 <trap>
  addl $4, %esp
8010611f:	83 c4 04             	add    $0x4,%esp

80106122 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106122:	61                   	popa   
  popl %gs
80106123:	0f a9                	pop    %gs
  popl %fs
80106125:	0f a1                	pop    %fs
  popl %es
80106127:	07                   	pop    %es
  popl %ds
80106128:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106129:	83 c4 08             	add    $0x8,%esp
  iret
8010612c:	cf                   	iret   
8010612d:	66 90                	xchg   %ax,%ax
8010612f:	90                   	nop

80106130 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106130:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106131:	31 c0                	xor    %eax,%eax
{
80106133:	89 e5                	mov    %esp,%ebp
80106135:	83 ec 08             	sub    $0x8,%esp
80106138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010613f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106140:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80106147:	c7 04 c5 c2 4a 13 80 	movl   $0x8e000008,-0x7fecb53e(,%eax,8)
8010614e:	08 00 00 8e 
80106152:	66 89 14 c5 c0 4a 13 	mov    %dx,-0x7fecb540(,%eax,8)
80106159:	80 
8010615a:	c1 ea 10             	shr    $0x10,%edx
8010615d:	66 89 14 c5 c6 4a 13 	mov    %dx,-0x7fecb53a(,%eax,8)
80106164:	80 
  for(i = 0; i < 256; i++)
80106165:	83 c0 01             	add    $0x1,%eax
80106168:	3d 00 01 00 00       	cmp    $0x100,%eax
8010616d:	75 d1                	jne    80106140 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010616f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106172:	a1 0c b1 10 80       	mov    0x8010b10c,%eax
80106177:	c7 05 c2 4c 13 80 08 	movl   $0xef000008,0x80134cc2
8010617e:	00 00 ef 
  initlock(&tickslock, "time");
80106181:	68 79 83 10 80       	push   $0x80108379
80106186:	68 80 4a 13 80       	push   $0x80134a80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010618b:	66 a3 c0 4c 13 80    	mov    %ax,0x80134cc0
80106191:	c1 e8 10             	shr    $0x10,%eax
80106194:	66 a3 c6 4c 13 80    	mov    %ax,0x80134cc6
  initlock(&tickslock, "time");
8010619a:	e8 21 eb ff ff       	call   80104cc0 <initlock>
}
8010619f:	83 c4 10             	add    $0x10,%esp
801061a2:	c9                   	leave  
801061a3:	c3                   	ret    
801061a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061af:	90                   	nop

801061b0 <idtinit>:

void
idtinit(void)
{
801061b0:	55                   	push   %ebp
  pd[0] = size-1;
801061b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061b6:	89 e5                	mov    %esp,%ebp
801061b8:	83 ec 10             	sub    $0x10,%esp
801061bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801061bf:	b8 c0 4a 13 80       	mov    $0x80134ac0,%eax
801061c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801061c8:	c1 e8 10             	shr    $0x10,%eax
801061cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801061cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801061d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801061d5:	c9                   	leave  
801061d6:	c3                   	ret    
801061d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061de:	66 90                	xchg   %ax,%ax

801061e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	57                   	push   %edi
801061e4:	56                   	push   %esi
801061e5:	53                   	push   %ebx
801061e6:	83 ec 1c             	sub    $0x1c,%esp
801061e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801061ec:	8b 43 30             	mov    0x30(%ebx),%eax
801061ef:	83 f8 40             	cmp    $0x40,%eax
801061f2:	0f 84 68 01 00 00    	je     80106360 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801061f8:	83 e8 20             	sub    $0x20,%eax
801061fb:	83 f8 1f             	cmp    $0x1f,%eax
801061fe:	0f 87 8c 00 00 00    	ja     80106290 <trap+0xb0>
80106204:	ff 24 85 20 84 10 80 	jmp    *-0x7fef7be0(,%eax,4)
8010620b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010620f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106210:	e8 ab c0 ff ff       	call   801022c0 <ideintr>
    lapiceoi();
80106215:	e8 76 c7 ff ff       	call   80102990 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010621a:	e8 b1 d8 ff ff       	call   80103ad0 <myproc>
8010621f:	85 c0                	test   %eax,%eax
80106221:	74 1d                	je     80106240 <trap+0x60>
80106223:	e8 a8 d8 ff ff       	call   80103ad0 <myproc>
80106228:	8b 50 18             	mov    0x18(%eax),%edx
8010622b:	85 d2                	test   %edx,%edx
8010622d:	74 11                	je     80106240 <trap+0x60>
8010622f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106233:	83 e0 03             	and    $0x3,%eax
80106236:	66 83 f8 03          	cmp    $0x3,%ax
8010623a:	0f 84 00 02 00 00    	je     80106440 <trap+0x260>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106240:	e8 8b d8 ff ff       	call   80103ad0 <myproc>
80106245:	85 c0                	test   %eax,%eax
80106247:	74 0f                	je     80106258 <trap+0x78>
80106249:	e8 82 d8 ff ff       	call   80103ad0 <myproc>
8010624e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106252:	0f 84 b8 00 00 00    	je     80106310 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106258:	e8 73 d8 ff ff       	call   80103ad0 <myproc>
8010625d:	85 c0                	test   %eax,%eax
8010625f:	74 1d                	je     8010627e <trap+0x9e>
80106261:	e8 6a d8 ff ff       	call   80103ad0 <myproc>
80106266:	8b 40 18             	mov    0x18(%eax),%eax
80106269:	85 c0                	test   %eax,%eax
8010626b:	74 11                	je     8010627e <trap+0x9e>
8010626d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106271:	83 e0 03             	and    $0x3,%eax
80106274:	66 83 f8 03          	cmp    $0x3,%ax
80106278:	0f 84 29 01 00 00    	je     801063a7 <trap+0x1c7>
    exit();
}
8010627e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106281:	5b                   	pop    %ebx
80106282:	5e                   	pop    %esi
80106283:	5f                   	pop    %edi
80106284:	5d                   	pop    %ebp
80106285:	c3                   	ret    
80106286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010628d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106290:	e8 3b d8 ff ff       	call   80103ad0 <myproc>
80106295:	8b 7b 38             	mov    0x38(%ebx),%edi
80106298:	85 c0                	test   %eax,%eax
8010629a:	0f 84 ba 01 00 00    	je     8010645a <trap+0x27a>
801062a0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801062a4:	0f 84 b0 01 00 00    	je     8010645a <trap+0x27a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801062aa:	0f 20 d1             	mov    %cr2,%ecx
801062ad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062b0:	e8 fb d7 ff ff       	call   80103ab0 <cpuid>
801062b5:	8b 73 30             	mov    0x30(%ebx),%esi
801062b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801062bb:	8b 43 34             	mov    0x34(%ebx),%eax
801062be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801062c1:	e8 0a d8 ff ff       	call   80103ad0 <myproc>
801062c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801062c9:	e8 02 d8 ff ff       	call   80103ad0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062ce:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801062d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801062d4:	51                   	push   %ecx
801062d5:	57                   	push   %edi
801062d6:	52                   	push   %edx
801062d7:	ff 75 e4             	push   -0x1c(%ebp)
801062da:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801062db:	8b 75 e0             	mov    -0x20(%ebp),%esi
801062de:	83 c6 60             	add    $0x60,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062e1:	56                   	push   %esi
801062e2:	ff 70 10             	push   0x10(%eax)
801062e5:	68 dc 83 10 80       	push   $0x801083dc
801062ea:	e8 b1 a3 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
801062ef:	83 c4 20             	add    $0x20,%esp
801062f2:	e8 d9 d7 ff ff       	call   80103ad0 <myproc>
801062f7:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062fe:	e8 cd d7 ff ff       	call   80103ad0 <myproc>
80106303:	85 c0                	test   %eax,%eax
80106305:	0f 85 18 ff ff ff    	jne    80106223 <trap+0x43>
8010630b:	e9 30 ff ff ff       	jmp    80106240 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106310:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106314:	0f 85 3e ff ff ff    	jne    80106258 <trap+0x78>
    yield();
8010631a:	e8 01 de ff ff       	call   80104120 <yield>
8010631f:	e9 34 ff ff ff       	jmp    80106258 <trap+0x78>
80106324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106328:	8b 7b 38             	mov    0x38(%ebx),%edi
8010632b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010632f:	e8 7c d7 ff ff       	call   80103ab0 <cpuid>
80106334:	57                   	push   %edi
80106335:	56                   	push   %esi
80106336:	50                   	push   %eax
80106337:	68 84 83 10 80       	push   $0x80108384
8010633c:	e8 5f a3 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106341:	e8 4a c6 ff ff       	call   80102990 <lapiceoi>
    break;
80106346:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106349:	e8 82 d7 ff ff       	call   80103ad0 <myproc>
8010634e:	85 c0                	test   %eax,%eax
80106350:	0f 85 cd fe ff ff    	jne    80106223 <trap+0x43>
80106356:	e9 e5 fe ff ff       	jmp    80106240 <trap+0x60>
8010635b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010635f:	90                   	nop
    if(myproc()->killed)
80106360:	e8 6b d7 ff ff       	call   80103ad0 <myproc>
80106365:	8b 70 18             	mov    0x18(%eax),%esi
80106368:	85 f6                	test   %esi,%esi
8010636a:	0f 85 e0 00 00 00    	jne    80106450 <trap+0x270>
    if(myproc() != 0){
80106370:	e8 5b d7 ff ff       	call   80103ad0 <myproc>
80106375:	85 c0                	test   %eax,%eax
80106377:	74 19                	je     80106392 <trap+0x1b2>
	  struct thread *t = &myproc()->threads[myproc()->curtidx];
80106379:	e8 52 d7 ff ff       	call   80103ad0 <myproc>
8010637e:	89 c6                	mov    %eax,%esi
80106380:	e8 4b d7 ff ff       	call   80103ad0 <myproc>
80106385:	8b 80 70 08 00 00    	mov    0x870(%eax),%eax
	  t->tf = tf;
8010638b:	c1 e0 05             	shl    $0x5,%eax
8010638e:	89 5c 06 7c          	mov    %ebx,0x7c(%esi,%eax,1)
    syscall();
80106392:	e8 89 ef ff ff       	call   80105320 <syscall>
    if(myproc()->killed)
80106397:	e8 34 d7 ff ff       	call   80103ad0 <myproc>
8010639c:	8b 48 18             	mov    0x18(%eax),%ecx
8010639f:	85 c9                	test   %ecx,%ecx
801063a1:	0f 84 d7 fe ff ff    	je     8010627e <trap+0x9e>
}
801063a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063aa:	5b                   	pop    %ebx
801063ab:	5e                   	pop    %esi
801063ac:	5f                   	pop    %edi
801063ad:	5d                   	pop    %ebp
      exit();
801063ae:	e9 4d dc ff ff       	jmp    80104000 <exit>
801063b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063b7:	90                   	nop
    uartintr();
801063b8:	e8 43 02 00 00       	call   80106600 <uartintr>
    lapiceoi();
801063bd:	e8 ce c5 ff ff       	call   80102990 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063c2:	e8 09 d7 ff ff       	call   80103ad0 <myproc>
801063c7:	85 c0                	test   %eax,%eax
801063c9:	0f 85 54 fe ff ff    	jne    80106223 <trap+0x43>
801063cf:	e9 6c fe ff ff       	jmp    80106240 <trap+0x60>
801063d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801063d8:	e8 73 c4 ff ff       	call   80102850 <kbdintr>
    lapiceoi();
801063dd:	e8 ae c5 ff ff       	call   80102990 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063e2:	e8 e9 d6 ff ff       	call   80103ad0 <myproc>
801063e7:	85 c0                	test   %eax,%eax
801063e9:	0f 85 34 fe ff ff    	jne    80106223 <trap+0x43>
801063ef:	e9 4c fe ff ff       	jmp    80106240 <trap+0x60>
801063f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801063f8:	e8 b3 d6 ff ff       	call   80103ab0 <cpuid>
801063fd:	85 c0                	test   %eax,%eax
801063ff:	0f 85 10 fe ff ff    	jne    80106215 <trap+0x35>
      acquire(&tickslock);
80106405:	83 ec 0c             	sub    $0xc,%esp
80106408:	68 80 4a 13 80       	push   $0x80134a80
8010640d:	e8 7e ea ff ff       	call   80104e90 <acquire>
      wakeup(&ticks);
80106412:	c7 04 24 60 4a 13 80 	movl   $0x80134a60,(%esp)
      ticks++;
80106419:	83 05 60 4a 13 80 01 	addl   $0x1,0x80134a60
      wakeup(&ticks);
80106420:	e8 1b e0 ff ff       	call   80104440 <wakeup>
      release(&tickslock);
80106425:	c7 04 24 80 4a 13 80 	movl   $0x80134a80,(%esp)
8010642c:	e8 ff e9 ff ff       	call   80104e30 <release>
80106431:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106434:	e9 dc fd ff ff       	jmp    80106215 <trap+0x35>
80106439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106440:	e8 bb db ff ff       	call   80104000 <exit>
80106445:	e9 f6 fd ff ff       	jmp    80106240 <trap+0x60>
8010644a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106450:	e8 ab db ff ff       	call   80104000 <exit>
80106455:	e9 16 ff ff ff       	jmp    80106370 <trap+0x190>
8010645a:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010645d:	e8 4e d6 ff ff       	call   80103ab0 <cpuid>
80106462:	83 ec 0c             	sub    $0xc,%esp
80106465:	56                   	push   %esi
80106466:	57                   	push   %edi
80106467:	50                   	push   %eax
80106468:	ff 73 30             	push   0x30(%ebx)
8010646b:	68 a8 83 10 80       	push   $0x801083a8
80106470:	e8 2b a2 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80106475:	83 c4 14             	add    $0x14,%esp
80106478:	68 7e 83 10 80       	push   $0x8010837e
8010647d:	e8 fe 9e ff ff       	call   80100380 <panic>
80106482:	66 90                	xchg   %ax,%ax
80106484:	66 90                	xchg   %ax,%ax
80106486:	66 90                	xchg   %ax,%ax
80106488:	66 90                	xchg   %ax,%ax
8010648a:	66 90                	xchg   %ax,%ax
8010648c:	66 90                	xchg   %ax,%ax
8010648e:	66 90                	xchg   %ax,%ax

80106490 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106490:	a1 c0 52 13 80       	mov    0x801352c0,%eax
80106495:	85 c0                	test   %eax,%eax
80106497:	74 17                	je     801064b0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106499:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010649e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010649f:	a8 01                	test   $0x1,%al
801064a1:	74 0d                	je     801064b0 <uartgetc+0x20>
801064a3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064a8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801064a9:	0f b6 c0             	movzbl %al,%eax
801064ac:	c3                   	ret    
801064ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801064b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064b5:	c3                   	ret    
801064b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064bd:	8d 76 00             	lea    0x0(%esi),%esi

801064c0 <uartinit>:
{
801064c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064c1:	31 c9                	xor    %ecx,%ecx
801064c3:	89 c8                	mov    %ecx,%eax
801064c5:	89 e5                	mov    %esp,%ebp
801064c7:	57                   	push   %edi
801064c8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801064cd:	56                   	push   %esi
801064ce:	89 fa                	mov    %edi,%edx
801064d0:	53                   	push   %ebx
801064d1:	83 ec 1c             	sub    $0x1c,%esp
801064d4:	ee                   	out    %al,(%dx)
801064d5:	be fb 03 00 00       	mov    $0x3fb,%esi
801064da:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801064df:	89 f2                	mov    %esi,%edx
801064e1:	ee                   	out    %al,(%dx)
801064e2:	b8 0c 00 00 00       	mov    $0xc,%eax
801064e7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064ec:	ee                   	out    %al,(%dx)
801064ed:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801064f2:	89 c8                	mov    %ecx,%eax
801064f4:	89 da                	mov    %ebx,%edx
801064f6:	ee                   	out    %al,(%dx)
801064f7:	b8 03 00 00 00       	mov    $0x3,%eax
801064fc:	89 f2                	mov    %esi,%edx
801064fe:	ee                   	out    %al,(%dx)
801064ff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106504:	89 c8                	mov    %ecx,%eax
80106506:	ee                   	out    %al,(%dx)
80106507:	b8 01 00 00 00       	mov    $0x1,%eax
8010650c:	89 da                	mov    %ebx,%edx
8010650e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010650f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106514:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106515:	3c ff                	cmp    $0xff,%al
80106517:	74 78                	je     80106591 <uartinit+0xd1>
  uart = 1;
80106519:	c7 05 c0 52 13 80 01 	movl   $0x1,0x801352c0
80106520:	00 00 00 
80106523:	89 fa                	mov    %edi,%edx
80106525:	ec                   	in     (%dx),%al
80106526:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010652b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010652c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010652f:	bf a0 84 10 80       	mov    $0x801084a0,%edi
80106534:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106539:	6a 00                	push   $0x0
8010653b:	6a 04                	push   $0x4
8010653d:	e8 be bf ff ff       	call   80102500 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106542:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106546:	83 c4 10             	add    $0x10,%esp
80106549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106550:	a1 c0 52 13 80       	mov    0x801352c0,%eax
80106555:	bb 80 00 00 00       	mov    $0x80,%ebx
8010655a:	85 c0                	test   %eax,%eax
8010655c:	75 14                	jne    80106572 <uartinit+0xb2>
8010655e:	eb 23                	jmp    80106583 <uartinit+0xc3>
    microdelay(10);
80106560:	83 ec 0c             	sub    $0xc,%esp
80106563:	6a 0a                	push   $0xa
80106565:	e8 46 c4 ff ff       	call   801029b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010656a:	83 c4 10             	add    $0x10,%esp
8010656d:	83 eb 01             	sub    $0x1,%ebx
80106570:	74 07                	je     80106579 <uartinit+0xb9>
80106572:	89 f2                	mov    %esi,%edx
80106574:	ec                   	in     (%dx),%al
80106575:	a8 20                	test   $0x20,%al
80106577:	74 e7                	je     80106560 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106579:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010657d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106582:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106583:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106587:	83 c7 01             	add    $0x1,%edi
8010658a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010658d:	84 c0                	test   %al,%al
8010658f:	75 bf                	jne    80106550 <uartinit+0x90>
}
80106591:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106594:	5b                   	pop    %ebx
80106595:	5e                   	pop    %esi
80106596:	5f                   	pop    %edi
80106597:	5d                   	pop    %ebp
80106598:	c3                   	ret    
80106599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065a0 <uartputc>:
  if(!uart)
801065a0:	a1 c0 52 13 80       	mov    0x801352c0,%eax
801065a5:	85 c0                	test   %eax,%eax
801065a7:	74 47                	je     801065f0 <uartputc+0x50>
{
801065a9:	55                   	push   %ebp
801065aa:	89 e5                	mov    %esp,%ebp
801065ac:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065ad:	be fd 03 00 00       	mov    $0x3fd,%esi
801065b2:	53                   	push   %ebx
801065b3:	bb 80 00 00 00       	mov    $0x80,%ebx
801065b8:	eb 18                	jmp    801065d2 <uartputc+0x32>
801065ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801065c0:	83 ec 0c             	sub    $0xc,%esp
801065c3:	6a 0a                	push   $0xa
801065c5:	e8 e6 c3 ff ff       	call   801029b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065ca:	83 c4 10             	add    $0x10,%esp
801065cd:	83 eb 01             	sub    $0x1,%ebx
801065d0:	74 07                	je     801065d9 <uartputc+0x39>
801065d2:	89 f2                	mov    %esi,%edx
801065d4:	ec                   	in     (%dx),%al
801065d5:	a8 20                	test   $0x20,%al
801065d7:	74 e7                	je     801065c0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065d9:	8b 45 08             	mov    0x8(%ebp),%eax
801065dc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065e1:	ee                   	out    %al,(%dx)
}
801065e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801065e5:	5b                   	pop    %ebx
801065e6:	5e                   	pop    %esi
801065e7:	5d                   	pop    %ebp
801065e8:	c3                   	ret    
801065e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065f0:	c3                   	ret    
801065f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ff:	90                   	nop

80106600 <uartintr>:

void
uartintr(void)
{
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106606:	68 90 64 10 80       	push   $0x80106490
8010660b:	e8 70 a2 ff ff       	call   80100880 <consoleintr>
}
80106610:	83 c4 10             	add    $0x10,%esp
80106613:	c9                   	leave  
80106614:	c3                   	ret    

80106615 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106615:	6a 00                	push   $0x0
  pushl $0
80106617:	6a 00                	push   $0x0
  jmp alltraps
80106619:	e9 ec fa ff ff       	jmp    8010610a <alltraps>

8010661e <vector1>:
.globl vector1
vector1:
  pushl $0
8010661e:	6a 00                	push   $0x0
  pushl $1
80106620:	6a 01                	push   $0x1
  jmp alltraps
80106622:	e9 e3 fa ff ff       	jmp    8010610a <alltraps>

80106627 <vector2>:
.globl vector2
vector2:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $2
80106629:	6a 02                	push   $0x2
  jmp alltraps
8010662b:	e9 da fa ff ff       	jmp    8010610a <alltraps>

80106630 <vector3>:
.globl vector3
vector3:
  pushl $0
80106630:	6a 00                	push   $0x0
  pushl $3
80106632:	6a 03                	push   $0x3
  jmp alltraps
80106634:	e9 d1 fa ff ff       	jmp    8010610a <alltraps>

80106639 <vector4>:
.globl vector4
vector4:
  pushl $0
80106639:	6a 00                	push   $0x0
  pushl $4
8010663b:	6a 04                	push   $0x4
  jmp alltraps
8010663d:	e9 c8 fa ff ff       	jmp    8010610a <alltraps>

80106642 <vector5>:
.globl vector5
vector5:
  pushl $0
80106642:	6a 00                	push   $0x0
  pushl $5
80106644:	6a 05                	push   $0x5
  jmp alltraps
80106646:	e9 bf fa ff ff       	jmp    8010610a <alltraps>

8010664b <vector6>:
.globl vector6
vector6:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $6
8010664d:	6a 06                	push   $0x6
  jmp alltraps
8010664f:	e9 b6 fa ff ff       	jmp    8010610a <alltraps>

80106654 <vector7>:
.globl vector7
vector7:
  pushl $0
80106654:	6a 00                	push   $0x0
  pushl $7
80106656:	6a 07                	push   $0x7
  jmp alltraps
80106658:	e9 ad fa ff ff       	jmp    8010610a <alltraps>

8010665d <vector8>:
.globl vector8
vector8:
  pushl $8
8010665d:	6a 08                	push   $0x8
  jmp alltraps
8010665f:	e9 a6 fa ff ff       	jmp    8010610a <alltraps>

80106664 <vector9>:
.globl vector9
vector9:
  pushl $0
80106664:	6a 00                	push   $0x0
  pushl $9
80106666:	6a 09                	push   $0x9
  jmp alltraps
80106668:	e9 9d fa ff ff       	jmp    8010610a <alltraps>

8010666d <vector10>:
.globl vector10
vector10:
  pushl $10
8010666d:	6a 0a                	push   $0xa
  jmp alltraps
8010666f:	e9 96 fa ff ff       	jmp    8010610a <alltraps>

80106674 <vector11>:
.globl vector11
vector11:
  pushl $11
80106674:	6a 0b                	push   $0xb
  jmp alltraps
80106676:	e9 8f fa ff ff       	jmp    8010610a <alltraps>

8010667b <vector12>:
.globl vector12
vector12:
  pushl $12
8010667b:	6a 0c                	push   $0xc
  jmp alltraps
8010667d:	e9 88 fa ff ff       	jmp    8010610a <alltraps>

80106682 <vector13>:
.globl vector13
vector13:
  pushl $13
80106682:	6a 0d                	push   $0xd
  jmp alltraps
80106684:	e9 81 fa ff ff       	jmp    8010610a <alltraps>

80106689 <vector14>:
.globl vector14
vector14:
  pushl $14
80106689:	6a 0e                	push   $0xe
  jmp alltraps
8010668b:	e9 7a fa ff ff       	jmp    8010610a <alltraps>

80106690 <vector15>:
.globl vector15
vector15:
  pushl $0
80106690:	6a 00                	push   $0x0
  pushl $15
80106692:	6a 0f                	push   $0xf
  jmp alltraps
80106694:	e9 71 fa ff ff       	jmp    8010610a <alltraps>

80106699 <vector16>:
.globl vector16
vector16:
  pushl $0
80106699:	6a 00                	push   $0x0
  pushl $16
8010669b:	6a 10                	push   $0x10
  jmp alltraps
8010669d:	e9 68 fa ff ff       	jmp    8010610a <alltraps>

801066a2 <vector17>:
.globl vector17
vector17:
  pushl $17
801066a2:	6a 11                	push   $0x11
  jmp alltraps
801066a4:	e9 61 fa ff ff       	jmp    8010610a <alltraps>

801066a9 <vector18>:
.globl vector18
vector18:
  pushl $0
801066a9:	6a 00                	push   $0x0
  pushl $18
801066ab:	6a 12                	push   $0x12
  jmp alltraps
801066ad:	e9 58 fa ff ff       	jmp    8010610a <alltraps>

801066b2 <vector19>:
.globl vector19
vector19:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $19
801066b4:	6a 13                	push   $0x13
  jmp alltraps
801066b6:	e9 4f fa ff ff       	jmp    8010610a <alltraps>

801066bb <vector20>:
.globl vector20
vector20:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $20
801066bd:	6a 14                	push   $0x14
  jmp alltraps
801066bf:	e9 46 fa ff ff       	jmp    8010610a <alltraps>

801066c4 <vector21>:
.globl vector21
vector21:
  pushl $0
801066c4:	6a 00                	push   $0x0
  pushl $21
801066c6:	6a 15                	push   $0x15
  jmp alltraps
801066c8:	e9 3d fa ff ff       	jmp    8010610a <alltraps>

801066cd <vector22>:
.globl vector22
vector22:
  pushl $0
801066cd:	6a 00                	push   $0x0
  pushl $22
801066cf:	6a 16                	push   $0x16
  jmp alltraps
801066d1:	e9 34 fa ff ff       	jmp    8010610a <alltraps>

801066d6 <vector23>:
.globl vector23
vector23:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $23
801066d8:	6a 17                	push   $0x17
  jmp alltraps
801066da:	e9 2b fa ff ff       	jmp    8010610a <alltraps>

801066df <vector24>:
.globl vector24
vector24:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $24
801066e1:	6a 18                	push   $0x18
  jmp alltraps
801066e3:	e9 22 fa ff ff       	jmp    8010610a <alltraps>

801066e8 <vector25>:
.globl vector25
vector25:
  pushl $0
801066e8:	6a 00                	push   $0x0
  pushl $25
801066ea:	6a 19                	push   $0x19
  jmp alltraps
801066ec:	e9 19 fa ff ff       	jmp    8010610a <alltraps>

801066f1 <vector26>:
.globl vector26
vector26:
  pushl $0
801066f1:	6a 00                	push   $0x0
  pushl $26
801066f3:	6a 1a                	push   $0x1a
  jmp alltraps
801066f5:	e9 10 fa ff ff       	jmp    8010610a <alltraps>

801066fa <vector27>:
.globl vector27
vector27:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $27
801066fc:	6a 1b                	push   $0x1b
  jmp alltraps
801066fe:	e9 07 fa ff ff       	jmp    8010610a <alltraps>

80106703 <vector28>:
.globl vector28
vector28:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $28
80106705:	6a 1c                	push   $0x1c
  jmp alltraps
80106707:	e9 fe f9 ff ff       	jmp    8010610a <alltraps>

8010670c <vector29>:
.globl vector29
vector29:
  pushl $0
8010670c:	6a 00                	push   $0x0
  pushl $29
8010670e:	6a 1d                	push   $0x1d
  jmp alltraps
80106710:	e9 f5 f9 ff ff       	jmp    8010610a <alltraps>

80106715 <vector30>:
.globl vector30
vector30:
  pushl $0
80106715:	6a 00                	push   $0x0
  pushl $30
80106717:	6a 1e                	push   $0x1e
  jmp alltraps
80106719:	e9 ec f9 ff ff       	jmp    8010610a <alltraps>

8010671e <vector31>:
.globl vector31
vector31:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $31
80106720:	6a 1f                	push   $0x1f
  jmp alltraps
80106722:	e9 e3 f9 ff ff       	jmp    8010610a <alltraps>

80106727 <vector32>:
.globl vector32
vector32:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $32
80106729:	6a 20                	push   $0x20
  jmp alltraps
8010672b:	e9 da f9 ff ff       	jmp    8010610a <alltraps>

80106730 <vector33>:
.globl vector33
vector33:
  pushl $0
80106730:	6a 00                	push   $0x0
  pushl $33
80106732:	6a 21                	push   $0x21
  jmp alltraps
80106734:	e9 d1 f9 ff ff       	jmp    8010610a <alltraps>

80106739 <vector34>:
.globl vector34
vector34:
  pushl $0
80106739:	6a 00                	push   $0x0
  pushl $34
8010673b:	6a 22                	push   $0x22
  jmp alltraps
8010673d:	e9 c8 f9 ff ff       	jmp    8010610a <alltraps>

80106742 <vector35>:
.globl vector35
vector35:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $35
80106744:	6a 23                	push   $0x23
  jmp alltraps
80106746:	e9 bf f9 ff ff       	jmp    8010610a <alltraps>

8010674b <vector36>:
.globl vector36
vector36:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $36
8010674d:	6a 24                	push   $0x24
  jmp alltraps
8010674f:	e9 b6 f9 ff ff       	jmp    8010610a <alltraps>

80106754 <vector37>:
.globl vector37
vector37:
  pushl $0
80106754:	6a 00                	push   $0x0
  pushl $37
80106756:	6a 25                	push   $0x25
  jmp alltraps
80106758:	e9 ad f9 ff ff       	jmp    8010610a <alltraps>

8010675d <vector38>:
.globl vector38
vector38:
  pushl $0
8010675d:	6a 00                	push   $0x0
  pushl $38
8010675f:	6a 26                	push   $0x26
  jmp alltraps
80106761:	e9 a4 f9 ff ff       	jmp    8010610a <alltraps>

80106766 <vector39>:
.globl vector39
vector39:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $39
80106768:	6a 27                	push   $0x27
  jmp alltraps
8010676a:	e9 9b f9 ff ff       	jmp    8010610a <alltraps>

8010676f <vector40>:
.globl vector40
vector40:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $40
80106771:	6a 28                	push   $0x28
  jmp alltraps
80106773:	e9 92 f9 ff ff       	jmp    8010610a <alltraps>

80106778 <vector41>:
.globl vector41
vector41:
  pushl $0
80106778:	6a 00                	push   $0x0
  pushl $41
8010677a:	6a 29                	push   $0x29
  jmp alltraps
8010677c:	e9 89 f9 ff ff       	jmp    8010610a <alltraps>

80106781 <vector42>:
.globl vector42
vector42:
  pushl $0
80106781:	6a 00                	push   $0x0
  pushl $42
80106783:	6a 2a                	push   $0x2a
  jmp alltraps
80106785:	e9 80 f9 ff ff       	jmp    8010610a <alltraps>

8010678a <vector43>:
.globl vector43
vector43:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $43
8010678c:	6a 2b                	push   $0x2b
  jmp alltraps
8010678e:	e9 77 f9 ff ff       	jmp    8010610a <alltraps>

80106793 <vector44>:
.globl vector44
vector44:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $44
80106795:	6a 2c                	push   $0x2c
  jmp alltraps
80106797:	e9 6e f9 ff ff       	jmp    8010610a <alltraps>

8010679c <vector45>:
.globl vector45
vector45:
  pushl $0
8010679c:	6a 00                	push   $0x0
  pushl $45
8010679e:	6a 2d                	push   $0x2d
  jmp alltraps
801067a0:	e9 65 f9 ff ff       	jmp    8010610a <alltraps>

801067a5 <vector46>:
.globl vector46
vector46:
  pushl $0
801067a5:	6a 00                	push   $0x0
  pushl $46
801067a7:	6a 2e                	push   $0x2e
  jmp alltraps
801067a9:	e9 5c f9 ff ff       	jmp    8010610a <alltraps>

801067ae <vector47>:
.globl vector47
vector47:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $47
801067b0:	6a 2f                	push   $0x2f
  jmp alltraps
801067b2:	e9 53 f9 ff ff       	jmp    8010610a <alltraps>

801067b7 <vector48>:
.globl vector48
vector48:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $48
801067b9:	6a 30                	push   $0x30
  jmp alltraps
801067bb:	e9 4a f9 ff ff       	jmp    8010610a <alltraps>

801067c0 <vector49>:
.globl vector49
vector49:
  pushl $0
801067c0:	6a 00                	push   $0x0
  pushl $49
801067c2:	6a 31                	push   $0x31
  jmp alltraps
801067c4:	e9 41 f9 ff ff       	jmp    8010610a <alltraps>

801067c9 <vector50>:
.globl vector50
vector50:
  pushl $0
801067c9:	6a 00                	push   $0x0
  pushl $50
801067cb:	6a 32                	push   $0x32
  jmp alltraps
801067cd:	e9 38 f9 ff ff       	jmp    8010610a <alltraps>

801067d2 <vector51>:
.globl vector51
vector51:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $51
801067d4:	6a 33                	push   $0x33
  jmp alltraps
801067d6:	e9 2f f9 ff ff       	jmp    8010610a <alltraps>

801067db <vector52>:
.globl vector52
vector52:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $52
801067dd:	6a 34                	push   $0x34
  jmp alltraps
801067df:	e9 26 f9 ff ff       	jmp    8010610a <alltraps>

801067e4 <vector53>:
.globl vector53
vector53:
  pushl $0
801067e4:	6a 00                	push   $0x0
  pushl $53
801067e6:	6a 35                	push   $0x35
  jmp alltraps
801067e8:	e9 1d f9 ff ff       	jmp    8010610a <alltraps>

801067ed <vector54>:
.globl vector54
vector54:
  pushl $0
801067ed:	6a 00                	push   $0x0
  pushl $54
801067ef:	6a 36                	push   $0x36
  jmp alltraps
801067f1:	e9 14 f9 ff ff       	jmp    8010610a <alltraps>

801067f6 <vector55>:
.globl vector55
vector55:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $55
801067f8:	6a 37                	push   $0x37
  jmp alltraps
801067fa:	e9 0b f9 ff ff       	jmp    8010610a <alltraps>

801067ff <vector56>:
.globl vector56
vector56:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $56
80106801:	6a 38                	push   $0x38
  jmp alltraps
80106803:	e9 02 f9 ff ff       	jmp    8010610a <alltraps>

80106808 <vector57>:
.globl vector57
vector57:
  pushl $0
80106808:	6a 00                	push   $0x0
  pushl $57
8010680a:	6a 39                	push   $0x39
  jmp alltraps
8010680c:	e9 f9 f8 ff ff       	jmp    8010610a <alltraps>

80106811 <vector58>:
.globl vector58
vector58:
  pushl $0
80106811:	6a 00                	push   $0x0
  pushl $58
80106813:	6a 3a                	push   $0x3a
  jmp alltraps
80106815:	e9 f0 f8 ff ff       	jmp    8010610a <alltraps>

8010681a <vector59>:
.globl vector59
vector59:
  pushl $0
8010681a:	6a 00                	push   $0x0
  pushl $59
8010681c:	6a 3b                	push   $0x3b
  jmp alltraps
8010681e:	e9 e7 f8 ff ff       	jmp    8010610a <alltraps>

80106823 <vector60>:
.globl vector60
vector60:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $60
80106825:	6a 3c                	push   $0x3c
  jmp alltraps
80106827:	e9 de f8 ff ff       	jmp    8010610a <alltraps>

8010682c <vector61>:
.globl vector61
vector61:
  pushl $0
8010682c:	6a 00                	push   $0x0
  pushl $61
8010682e:	6a 3d                	push   $0x3d
  jmp alltraps
80106830:	e9 d5 f8 ff ff       	jmp    8010610a <alltraps>

80106835 <vector62>:
.globl vector62
vector62:
  pushl $0
80106835:	6a 00                	push   $0x0
  pushl $62
80106837:	6a 3e                	push   $0x3e
  jmp alltraps
80106839:	e9 cc f8 ff ff       	jmp    8010610a <alltraps>

8010683e <vector63>:
.globl vector63
vector63:
  pushl $0
8010683e:	6a 00                	push   $0x0
  pushl $63
80106840:	6a 3f                	push   $0x3f
  jmp alltraps
80106842:	e9 c3 f8 ff ff       	jmp    8010610a <alltraps>

80106847 <vector64>:
.globl vector64
vector64:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $64
80106849:	6a 40                	push   $0x40
  jmp alltraps
8010684b:	e9 ba f8 ff ff       	jmp    8010610a <alltraps>

80106850 <vector65>:
.globl vector65
vector65:
  pushl $0
80106850:	6a 00                	push   $0x0
  pushl $65
80106852:	6a 41                	push   $0x41
  jmp alltraps
80106854:	e9 b1 f8 ff ff       	jmp    8010610a <alltraps>

80106859 <vector66>:
.globl vector66
vector66:
  pushl $0
80106859:	6a 00                	push   $0x0
  pushl $66
8010685b:	6a 42                	push   $0x42
  jmp alltraps
8010685d:	e9 a8 f8 ff ff       	jmp    8010610a <alltraps>

80106862 <vector67>:
.globl vector67
vector67:
  pushl $0
80106862:	6a 00                	push   $0x0
  pushl $67
80106864:	6a 43                	push   $0x43
  jmp alltraps
80106866:	e9 9f f8 ff ff       	jmp    8010610a <alltraps>

8010686b <vector68>:
.globl vector68
vector68:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $68
8010686d:	6a 44                	push   $0x44
  jmp alltraps
8010686f:	e9 96 f8 ff ff       	jmp    8010610a <alltraps>

80106874 <vector69>:
.globl vector69
vector69:
  pushl $0
80106874:	6a 00                	push   $0x0
  pushl $69
80106876:	6a 45                	push   $0x45
  jmp alltraps
80106878:	e9 8d f8 ff ff       	jmp    8010610a <alltraps>

8010687d <vector70>:
.globl vector70
vector70:
  pushl $0
8010687d:	6a 00                	push   $0x0
  pushl $70
8010687f:	6a 46                	push   $0x46
  jmp alltraps
80106881:	e9 84 f8 ff ff       	jmp    8010610a <alltraps>

80106886 <vector71>:
.globl vector71
vector71:
  pushl $0
80106886:	6a 00                	push   $0x0
  pushl $71
80106888:	6a 47                	push   $0x47
  jmp alltraps
8010688a:	e9 7b f8 ff ff       	jmp    8010610a <alltraps>

8010688f <vector72>:
.globl vector72
vector72:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $72
80106891:	6a 48                	push   $0x48
  jmp alltraps
80106893:	e9 72 f8 ff ff       	jmp    8010610a <alltraps>

80106898 <vector73>:
.globl vector73
vector73:
  pushl $0
80106898:	6a 00                	push   $0x0
  pushl $73
8010689a:	6a 49                	push   $0x49
  jmp alltraps
8010689c:	e9 69 f8 ff ff       	jmp    8010610a <alltraps>

801068a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801068a1:	6a 00                	push   $0x0
  pushl $74
801068a3:	6a 4a                	push   $0x4a
  jmp alltraps
801068a5:	e9 60 f8 ff ff       	jmp    8010610a <alltraps>

801068aa <vector75>:
.globl vector75
vector75:
  pushl $0
801068aa:	6a 00                	push   $0x0
  pushl $75
801068ac:	6a 4b                	push   $0x4b
  jmp alltraps
801068ae:	e9 57 f8 ff ff       	jmp    8010610a <alltraps>

801068b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $76
801068b5:	6a 4c                	push   $0x4c
  jmp alltraps
801068b7:	e9 4e f8 ff ff       	jmp    8010610a <alltraps>

801068bc <vector77>:
.globl vector77
vector77:
  pushl $0
801068bc:	6a 00                	push   $0x0
  pushl $77
801068be:	6a 4d                	push   $0x4d
  jmp alltraps
801068c0:	e9 45 f8 ff ff       	jmp    8010610a <alltraps>

801068c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801068c5:	6a 00                	push   $0x0
  pushl $78
801068c7:	6a 4e                	push   $0x4e
  jmp alltraps
801068c9:	e9 3c f8 ff ff       	jmp    8010610a <alltraps>

801068ce <vector79>:
.globl vector79
vector79:
  pushl $0
801068ce:	6a 00                	push   $0x0
  pushl $79
801068d0:	6a 4f                	push   $0x4f
  jmp alltraps
801068d2:	e9 33 f8 ff ff       	jmp    8010610a <alltraps>

801068d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $80
801068d9:	6a 50                	push   $0x50
  jmp alltraps
801068db:	e9 2a f8 ff ff       	jmp    8010610a <alltraps>

801068e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801068e0:	6a 00                	push   $0x0
  pushl $81
801068e2:	6a 51                	push   $0x51
  jmp alltraps
801068e4:	e9 21 f8 ff ff       	jmp    8010610a <alltraps>

801068e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801068e9:	6a 00                	push   $0x0
  pushl $82
801068eb:	6a 52                	push   $0x52
  jmp alltraps
801068ed:	e9 18 f8 ff ff       	jmp    8010610a <alltraps>

801068f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801068f2:	6a 00                	push   $0x0
  pushl $83
801068f4:	6a 53                	push   $0x53
  jmp alltraps
801068f6:	e9 0f f8 ff ff       	jmp    8010610a <alltraps>

801068fb <vector84>:
.globl vector84
vector84:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $84
801068fd:	6a 54                	push   $0x54
  jmp alltraps
801068ff:	e9 06 f8 ff ff       	jmp    8010610a <alltraps>

80106904 <vector85>:
.globl vector85
vector85:
  pushl $0
80106904:	6a 00                	push   $0x0
  pushl $85
80106906:	6a 55                	push   $0x55
  jmp alltraps
80106908:	e9 fd f7 ff ff       	jmp    8010610a <alltraps>

8010690d <vector86>:
.globl vector86
vector86:
  pushl $0
8010690d:	6a 00                	push   $0x0
  pushl $86
8010690f:	6a 56                	push   $0x56
  jmp alltraps
80106911:	e9 f4 f7 ff ff       	jmp    8010610a <alltraps>

80106916 <vector87>:
.globl vector87
vector87:
  pushl $0
80106916:	6a 00                	push   $0x0
  pushl $87
80106918:	6a 57                	push   $0x57
  jmp alltraps
8010691a:	e9 eb f7 ff ff       	jmp    8010610a <alltraps>

8010691f <vector88>:
.globl vector88
vector88:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $88
80106921:	6a 58                	push   $0x58
  jmp alltraps
80106923:	e9 e2 f7 ff ff       	jmp    8010610a <alltraps>

80106928 <vector89>:
.globl vector89
vector89:
  pushl $0
80106928:	6a 00                	push   $0x0
  pushl $89
8010692a:	6a 59                	push   $0x59
  jmp alltraps
8010692c:	e9 d9 f7 ff ff       	jmp    8010610a <alltraps>

80106931 <vector90>:
.globl vector90
vector90:
  pushl $0
80106931:	6a 00                	push   $0x0
  pushl $90
80106933:	6a 5a                	push   $0x5a
  jmp alltraps
80106935:	e9 d0 f7 ff ff       	jmp    8010610a <alltraps>

8010693a <vector91>:
.globl vector91
vector91:
  pushl $0
8010693a:	6a 00                	push   $0x0
  pushl $91
8010693c:	6a 5b                	push   $0x5b
  jmp alltraps
8010693e:	e9 c7 f7 ff ff       	jmp    8010610a <alltraps>

80106943 <vector92>:
.globl vector92
vector92:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $92
80106945:	6a 5c                	push   $0x5c
  jmp alltraps
80106947:	e9 be f7 ff ff       	jmp    8010610a <alltraps>

8010694c <vector93>:
.globl vector93
vector93:
  pushl $0
8010694c:	6a 00                	push   $0x0
  pushl $93
8010694e:	6a 5d                	push   $0x5d
  jmp alltraps
80106950:	e9 b5 f7 ff ff       	jmp    8010610a <alltraps>

80106955 <vector94>:
.globl vector94
vector94:
  pushl $0
80106955:	6a 00                	push   $0x0
  pushl $94
80106957:	6a 5e                	push   $0x5e
  jmp alltraps
80106959:	e9 ac f7 ff ff       	jmp    8010610a <alltraps>

8010695e <vector95>:
.globl vector95
vector95:
  pushl $0
8010695e:	6a 00                	push   $0x0
  pushl $95
80106960:	6a 5f                	push   $0x5f
  jmp alltraps
80106962:	e9 a3 f7 ff ff       	jmp    8010610a <alltraps>

80106967 <vector96>:
.globl vector96
vector96:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $96
80106969:	6a 60                	push   $0x60
  jmp alltraps
8010696b:	e9 9a f7 ff ff       	jmp    8010610a <alltraps>

80106970 <vector97>:
.globl vector97
vector97:
  pushl $0
80106970:	6a 00                	push   $0x0
  pushl $97
80106972:	6a 61                	push   $0x61
  jmp alltraps
80106974:	e9 91 f7 ff ff       	jmp    8010610a <alltraps>

80106979 <vector98>:
.globl vector98
vector98:
  pushl $0
80106979:	6a 00                	push   $0x0
  pushl $98
8010697b:	6a 62                	push   $0x62
  jmp alltraps
8010697d:	e9 88 f7 ff ff       	jmp    8010610a <alltraps>

80106982 <vector99>:
.globl vector99
vector99:
  pushl $0
80106982:	6a 00                	push   $0x0
  pushl $99
80106984:	6a 63                	push   $0x63
  jmp alltraps
80106986:	e9 7f f7 ff ff       	jmp    8010610a <alltraps>

8010698b <vector100>:
.globl vector100
vector100:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $100
8010698d:	6a 64                	push   $0x64
  jmp alltraps
8010698f:	e9 76 f7 ff ff       	jmp    8010610a <alltraps>

80106994 <vector101>:
.globl vector101
vector101:
  pushl $0
80106994:	6a 00                	push   $0x0
  pushl $101
80106996:	6a 65                	push   $0x65
  jmp alltraps
80106998:	e9 6d f7 ff ff       	jmp    8010610a <alltraps>

8010699d <vector102>:
.globl vector102
vector102:
  pushl $0
8010699d:	6a 00                	push   $0x0
  pushl $102
8010699f:	6a 66                	push   $0x66
  jmp alltraps
801069a1:	e9 64 f7 ff ff       	jmp    8010610a <alltraps>

801069a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801069a6:	6a 00                	push   $0x0
  pushl $103
801069a8:	6a 67                	push   $0x67
  jmp alltraps
801069aa:	e9 5b f7 ff ff       	jmp    8010610a <alltraps>

801069af <vector104>:
.globl vector104
vector104:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $104
801069b1:	6a 68                	push   $0x68
  jmp alltraps
801069b3:	e9 52 f7 ff ff       	jmp    8010610a <alltraps>

801069b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801069b8:	6a 00                	push   $0x0
  pushl $105
801069ba:	6a 69                	push   $0x69
  jmp alltraps
801069bc:	e9 49 f7 ff ff       	jmp    8010610a <alltraps>

801069c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801069c1:	6a 00                	push   $0x0
  pushl $106
801069c3:	6a 6a                	push   $0x6a
  jmp alltraps
801069c5:	e9 40 f7 ff ff       	jmp    8010610a <alltraps>

801069ca <vector107>:
.globl vector107
vector107:
  pushl $0
801069ca:	6a 00                	push   $0x0
  pushl $107
801069cc:	6a 6b                	push   $0x6b
  jmp alltraps
801069ce:	e9 37 f7 ff ff       	jmp    8010610a <alltraps>

801069d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $108
801069d5:	6a 6c                	push   $0x6c
  jmp alltraps
801069d7:	e9 2e f7 ff ff       	jmp    8010610a <alltraps>

801069dc <vector109>:
.globl vector109
vector109:
  pushl $0
801069dc:	6a 00                	push   $0x0
  pushl $109
801069de:	6a 6d                	push   $0x6d
  jmp alltraps
801069e0:	e9 25 f7 ff ff       	jmp    8010610a <alltraps>

801069e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801069e5:	6a 00                	push   $0x0
  pushl $110
801069e7:	6a 6e                	push   $0x6e
  jmp alltraps
801069e9:	e9 1c f7 ff ff       	jmp    8010610a <alltraps>

801069ee <vector111>:
.globl vector111
vector111:
  pushl $0
801069ee:	6a 00                	push   $0x0
  pushl $111
801069f0:	6a 6f                	push   $0x6f
  jmp alltraps
801069f2:	e9 13 f7 ff ff       	jmp    8010610a <alltraps>

801069f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $112
801069f9:	6a 70                	push   $0x70
  jmp alltraps
801069fb:	e9 0a f7 ff ff       	jmp    8010610a <alltraps>

80106a00 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a00:	6a 00                	push   $0x0
  pushl $113
80106a02:	6a 71                	push   $0x71
  jmp alltraps
80106a04:	e9 01 f7 ff ff       	jmp    8010610a <alltraps>

80106a09 <vector114>:
.globl vector114
vector114:
  pushl $0
80106a09:	6a 00                	push   $0x0
  pushl $114
80106a0b:	6a 72                	push   $0x72
  jmp alltraps
80106a0d:	e9 f8 f6 ff ff       	jmp    8010610a <alltraps>

80106a12 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a12:	6a 00                	push   $0x0
  pushl $115
80106a14:	6a 73                	push   $0x73
  jmp alltraps
80106a16:	e9 ef f6 ff ff       	jmp    8010610a <alltraps>

80106a1b <vector116>:
.globl vector116
vector116:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $116
80106a1d:	6a 74                	push   $0x74
  jmp alltraps
80106a1f:	e9 e6 f6 ff ff       	jmp    8010610a <alltraps>

80106a24 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a24:	6a 00                	push   $0x0
  pushl $117
80106a26:	6a 75                	push   $0x75
  jmp alltraps
80106a28:	e9 dd f6 ff ff       	jmp    8010610a <alltraps>

80106a2d <vector118>:
.globl vector118
vector118:
  pushl $0
80106a2d:	6a 00                	push   $0x0
  pushl $118
80106a2f:	6a 76                	push   $0x76
  jmp alltraps
80106a31:	e9 d4 f6 ff ff       	jmp    8010610a <alltraps>

80106a36 <vector119>:
.globl vector119
vector119:
  pushl $0
80106a36:	6a 00                	push   $0x0
  pushl $119
80106a38:	6a 77                	push   $0x77
  jmp alltraps
80106a3a:	e9 cb f6 ff ff       	jmp    8010610a <alltraps>

80106a3f <vector120>:
.globl vector120
vector120:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $120
80106a41:	6a 78                	push   $0x78
  jmp alltraps
80106a43:	e9 c2 f6 ff ff       	jmp    8010610a <alltraps>

80106a48 <vector121>:
.globl vector121
vector121:
  pushl $0
80106a48:	6a 00                	push   $0x0
  pushl $121
80106a4a:	6a 79                	push   $0x79
  jmp alltraps
80106a4c:	e9 b9 f6 ff ff       	jmp    8010610a <alltraps>

80106a51 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a51:	6a 00                	push   $0x0
  pushl $122
80106a53:	6a 7a                	push   $0x7a
  jmp alltraps
80106a55:	e9 b0 f6 ff ff       	jmp    8010610a <alltraps>

80106a5a <vector123>:
.globl vector123
vector123:
  pushl $0
80106a5a:	6a 00                	push   $0x0
  pushl $123
80106a5c:	6a 7b                	push   $0x7b
  jmp alltraps
80106a5e:	e9 a7 f6 ff ff       	jmp    8010610a <alltraps>

80106a63 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $124
80106a65:	6a 7c                	push   $0x7c
  jmp alltraps
80106a67:	e9 9e f6 ff ff       	jmp    8010610a <alltraps>

80106a6c <vector125>:
.globl vector125
vector125:
  pushl $0
80106a6c:	6a 00                	push   $0x0
  pushl $125
80106a6e:	6a 7d                	push   $0x7d
  jmp alltraps
80106a70:	e9 95 f6 ff ff       	jmp    8010610a <alltraps>

80106a75 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a75:	6a 00                	push   $0x0
  pushl $126
80106a77:	6a 7e                	push   $0x7e
  jmp alltraps
80106a79:	e9 8c f6 ff ff       	jmp    8010610a <alltraps>

80106a7e <vector127>:
.globl vector127
vector127:
  pushl $0
80106a7e:	6a 00                	push   $0x0
  pushl $127
80106a80:	6a 7f                	push   $0x7f
  jmp alltraps
80106a82:	e9 83 f6 ff ff       	jmp    8010610a <alltraps>

80106a87 <vector128>:
.globl vector128
vector128:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $128
80106a89:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a8e:	e9 77 f6 ff ff       	jmp    8010610a <alltraps>

80106a93 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $129
80106a95:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a9a:	e9 6b f6 ff ff       	jmp    8010610a <alltraps>

80106a9f <vector130>:
.globl vector130
vector130:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $130
80106aa1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106aa6:	e9 5f f6 ff ff       	jmp    8010610a <alltraps>

80106aab <vector131>:
.globl vector131
vector131:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $131
80106aad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106ab2:	e9 53 f6 ff ff       	jmp    8010610a <alltraps>

80106ab7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $132
80106ab9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106abe:	e9 47 f6 ff ff       	jmp    8010610a <alltraps>

80106ac3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $133
80106ac5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106aca:	e9 3b f6 ff ff       	jmp    8010610a <alltraps>

80106acf <vector134>:
.globl vector134
vector134:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $134
80106ad1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106ad6:	e9 2f f6 ff ff       	jmp    8010610a <alltraps>

80106adb <vector135>:
.globl vector135
vector135:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $135
80106add:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ae2:	e9 23 f6 ff ff       	jmp    8010610a <alltraps>

80106ae7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $136
80106ae9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106aee:	e9 17 f6 ff ff       	jmp    8010610a <alltraps>

80106af3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $137
80106af5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106afa:	e9 0b f6 ff ff       	jmp    8010610a <alltraps>

80106aff <vector138>:
.globl vector138
vector138:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $138
80106b01:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b06:	e9 ff f5 ff ff       	jmp    8010610a <alltraps>

80106b0b <vector139>:
.globl vector139
vector139:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $139
80106b0d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b12:	e9 f3 f5 ff ff       	jmp    8010610a <alltraps>

80106b17 <vector140>:
.globl vector140
vector140:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $140
80106b19:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b1e:	e9 e7 f5 ff ff       	jmp    8010610a <alltraps>

80106b23 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $141
80106b25:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b2a:	e9 db f5 ff ff       	jmp    8010610a <alltraps>

80106b2f <vector142>:
.globl vector142
vector142:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $142
80106b31:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b36:	e9 cf f5 ff ff       	jmp    8010610a <alltraps>

80106b3b <vector143>:
.globl vector143
vector143:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $143
80106b3d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b42:	e9 c3 f5 ff ff       	jmp    8010610a <alltraps>

80106b47 <vector144>:
.globl vector144
vector144:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $144
80106b49:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b4e:	e9 b7 f5 ff ff       	jmp    8010610a <alltraps>

80106b53 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $145
80106b55:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b5a:	e9 ab f5 ff ff       	jmp    8010610a <alltraps>

80106b5f <vector146>:
.globl vector146
vector146:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $146
80106b61:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b66:	e9 9f f5 ff ff       	jmp    8010610a <alltraps>

80106b6b <vector147>:
.globl vector147
vector147:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $147
80106b6d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b72:	e9 93 f5 ff ff       	jmp    8010610a <alltraps>

80106b77 <vector148>:
.globl vector148
vector148:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $148
80106b79:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b7e:	e9 87 f5 ff ff       	jmp    8010610a <alltraps>

80106b83 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $149
80106b85:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b8a:	e9 7b f5 ff ff       	jmp    8010610a <alltraps>

80106b8f <vector150>:
.globl vector150
vector150:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $150
80106b91:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b96:	e9 6f f5 ff ff       	jmp    8010610a <alltraps>

80106b9b <vector151>:
.globl vector151
vector151:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $151
80106b9d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106ba2:	e9 63 f5 ff ff       	jmp    8010610a <alltraps>

80106ba7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $152
80106ba9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106bae:	e9 57 f5 ff ff       	jmp    8010610a <alltraps>

80106bb3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $153
80106bb5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106bba:	e9 4b f5 ff ff       	jmp    8010610a <alltraps>

80106bbf <vector154>:
.globl vector154
vector154:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $154
80106bc1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106bc6:	e9 3f f5 ff ff       	jmp    8010610a <alltraps>

80106bcb <vector155>:
.globl vector155
vector155:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $155
80106bcd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106bd2:	e9 33 f5 ff ff       	jmp    8010610a <alltraps>

80106bd7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $156
80106bd9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106bde:	e9 27 f5 ff ff       	jmp    8010610a <alltraps>

80106be3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $157
80106be5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106bea:	e9 1b f5 ff ff       	jmp    8010610a <alltraps>

80106bef <vector158>:
.globl vector158
vector158:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $158
80106bf1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106bf6:	e9 0f f5 ff ff       	jmp    8010610a <alltraps>

80106bfb <vector159>:
.globl vector159
vector159:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $159
80106bfd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c02:	e9 03 f5 ff ff       	jmp    8010610a <alltraps>

80106c07 <vector160>:
.globl vector160
vector160:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $160
80106c09:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c0e:	e9 f7 f4 ff ff       	jmp    8010610a <alltraps>

80106c13 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $161
80106c15:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c1a:	e9 eb f4 ff ff       	jmp    8010610a <alltraps>

80106c1f <vector162>:
.globl vector162
vector162:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $162
80106c21:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c26:	e9 df f4 ff ff       	jmp    8010610a <alltraps>

80106c2b <vector163>:
.globl vector163
vector163:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $163
80106c2d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c32:	e9 d3 f4 ff ff       	jmp    8010610a <alltraps>

80106c37 <vector164>:
.globl vector164
vector164:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $164
80106c39:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c3e:	e9 c7 f4 ff ff       	jmp    8010610a <alltraps>

80106c43 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $165
80106c45:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c4a:	e9 bb f4 ff ff       	jmp    8010610a <alltraps>

80106c4f <vector166>:
.globl vector166
vector166:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $166
80106c51:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c56:	e9 af f4 ff ff       	jmp    8010610a <alltraps>

80106c5b <vector167>:
.globl vector167
vector167:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $167
80106c5d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c62:	e9 a3 f4 ff ff       	jmp    8010610a <alltraps>

80106c67 <vector168>:
.globl vector168
vector168:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $168
80106c69:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c6e:	e9 97 f4 ff ff       	jmp    8010610a <alltraps>

80106c73 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $169
80106c75:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c7a:	e9 8b f4 ff ff       	jmp    8010610a <alltraps>

80106c7f <vector170>:
.globl vector170
vector170:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $170
80106c81:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c86:	e9 7f f4 ff ff       	jmp    8010610a <alltraps>

80106c8b <vector171>:
.globl vector171
vector171:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $171
80106c8d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c92:	e9 73 f4 ff ff       	jmp    8010610a <alltraps>

80106c97 <vector172>:
.globl vector172
vector172:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $172
80106c99:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c9e:	e9 67 f4 ff ff       	jmp    8010610a <alltraps>

80106ca3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $173
80106ca5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106caa:	e9 5b f4 ff ff       	jmp    8010610a <alltraps>

80106caf <vector174>:
.globl vector174
vector174:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $174
80106cb1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106cb6:	e9 4f f4 ff ff       	jmp    8010610a <alltraps>

80106cbb <vector175>:
.globl vector175
vector175:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $175
80106cbd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106cc2:	e9 43 f4 ff ff       	jmp    8010610a <alltraps>

80106cc7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $176
80106cc9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106cce:	e9 37 f4 ff ff       	jmp    8010610a <alltraps>

80106cd3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $177
80106cd5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106cda:	e9 2b f4 ff ff       	jmp    8010610a <alltraps>

80106cdf <vector178>:
.globl vector178
vector178:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $178
80106ce1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106ce6:	e9 1f f4 ff ff       	jmp    8010610a <alltraps>

80106ceb <vector179>:
.globl vector179
vector179:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $179
80106ced:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106cf2:	e9 13 f4 ff ff       	jmp    8010610a <alltraps>

80106cf7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $180
80106cf9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106cfe:	e9 07 f4 ff ff       	jmp    8010610a <alltraps>

80106d03 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $181
80106d05:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d0a:	e9 fb f3 ff ff       	jmp    8010610a <alltraps>

80106d0f <vector182>:
.globl vector182
vector182:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $182
80106d11:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d16:	e9 ef f3 ff ff       	jmp    8010610a <alltraps>

80106d1b <vector183>:
.globl vector183
vector183:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $183
80106d1d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d22:	e9 e3 f3 ff ff       	jmp    8010610a <alltraps>

80106d27 <vector184>:
.globl vector184
vector184:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $184
80106d29:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d2e:	e9 d7 f3 ff ff       	jmp    8010610a <alltraps>

80106d33 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $185
80106d35:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d3a:	e9 cb f3 ff ff       	jmp    8010610a <alltraps>

80106d3f <vector186>:
.globl vector186
vector186:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $186
80106d41:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d46:	e9 bf f3 ff ff       	jmp    8010610a <alltraps>

80106d4b <vector187>:
.globl vector187
vector187:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $187
80106d4d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d52:	e9 b3 f3 ff ff       	jmp    8010610a <alltraps>

80106d57 <vector188>:
.globl vector188
vector188:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $188
80106d59:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d5e:	e9 a7 f3 ff ff       	jmp    8010610a <alltraps>

80106d63 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $189
80106d65:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d6a:	e9 9b f3 ff ff       	jmp    8010610a <alltraps>

80106d6f <vector190>:
.globl vector190
vector190:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $190
80106d71:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d76:	e9 8f f3 ff ff       	jmp    8010610a <alltraps>

80106d7b <vector191>:
.globl vector191
vector191:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $191
80106d7d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d82:	e9 83 f3 ff ff       	jmp    8010610a <alltraps>

80106d87 <vector192>:
.globl vector192
vector192:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $192
80106d89:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d8e:	e9 77 f3 ff ff       	jmp    8010610a <alltraps>

80106d93 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $193
80106d95:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d9a:	e9 6b f3 ff ff       	jmp    8010610a <alltraps>

80106d9f <vector194>:
.globl vector194
vector194:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $194
80106da1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106da6:	e9 5f f3 ff ff       	jmp    8010610a <alltraps>

80106dab <vector195>:
.globl vector195
vector195:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $195
80106dad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106db2:	e9 53 f3 ff ff       	jmp    8010610a <alltraps>

80106db7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $196
80106db9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106dbe:	e9 47 f3 ff ff       	jmp    8010610a <alltraps>

80106dc3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $197
80106dc5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106dca:	e9 3b f3 ff ff       	jmp    8010610a <alltraps>

80106dcf <vector198>:
.globl vector198
vector198:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $198
80106dd1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106dd6:	e9 2f f3 ff ff       	jmp    8010610a <alltraps>

80106ddb <vector199>:
.globl vector199
vector199:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $199
80106ddd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106de2:	e9 23 f3 ff ff       	jmp    8010610a <alltraps>

80106de7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $200
80106de9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106dee:	e9 17 f3 ff ff       	jmp    8010610a <alltraps>

80106df3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $201
80106df5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106dfa:	e9 0b f3 ff ff       	jmp    8010610a <alltraps>

80106dff <vector202>:
.globl vector202
vector202:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $202
80106e01:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e06:	e9 ff f2 ff ff       	jmp    8010610a <alltraps>

80106e0b <vector203>:
.globl vector203
vector203:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $203
80106e0d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e12:	e9 f3 f2 ff ff       	jmp    8010610a <alltraps>

80106e17 <vector204>:
.globl vector204
vector204:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $204
80106e19:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e1e:	e9 e7 f2 ff ff       	jmp    8010610a <alltraps>

80106e23 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $205
80106e25:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e2a:	e9 db f2 ff ff       	jmp    8010610a <alltraps>

80106e2f <vector206>:
.globl vector206
vector206:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $206
80106e31:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e36:	e9 cf f2 ff ff       	jmp    8010610a <alltraps>

80106e3b <vector207>:
.globl vector207
vector207:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $207
80106e3d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e42:	e9 c3 f2 ff ff       	jmp    8010610a <alltraps>

80106e47 <vector208>:
.globl vector208
vector208:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $208
80106e49:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e4e:	e9 b7 f2 ff ff       	jmp    8010610a <alltraps>

80106e53 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $209
80106e55:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e5a:	e9 ab f2 ff ff       	jmp    8010610a <alltraps>

80106e5f <vector210>:
.globl vector210
vector210:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $210
80106e61:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e66:	e9 9f f2 ff ff       	jmp    8010610a <alltraps>

80106e6b <vector211>:
.globl vector211
vector211:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $211
80106e6d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e72:	e9 93 f2 ff ff       	jmp    8010610a <alltraps>

80106e77 <vector212>:
.globl vector212
vector212:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $212
80106e79:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e7e:	e9 87 f2 ff ff       	jmp    8010610a <alltraps>

80106e83 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $213
80106e85:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e8a:	e9 7b f2 ff ff       	jmp    8010610a <alltraps>

80106e8f <vector214>:
.globl vector214
vector214:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $214
80106e91:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e96:	e9 6f f2 ff ff       	jmp    8010610a <alltraps>

80106e9b <vector215>:
.globl vector215
vector215:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $215
80106e9d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ea2:	e9 63 f2 ff ff       	jmp    8010610a <alltraps>

80106ea7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $216
80106ea9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106eae:	e9 57 f2 ff ff       	jmp    8010610a <alltraps>

80106eb3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $217
80106eb5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106eba:	e9 4b f2 ff ff       	jmp    8010610a <alltraps>

80106ebf <vector218>:
.globl vector218
vector218:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $218
80106ec1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ec6:	e9 3f f2 ff ff       	jmp    8010610a <alltraps>

80106ecb <vector219>:
.globl vector219
vector219:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $219
80106ecd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ed2:	e9 33 f2 ff ff       	jmp    8010610a <alltraps>

80106ed7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $220
80106ed9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ede:	e9 27 f2 ff ff       	jmp    8010610a <alltraps>

80106ee3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $221
80106ee5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106eea:	e9 1b f2 ff ff       	jmp    8010610a <alltraps>

80106eef <vector222>:
.globl vector222
vector222:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $222
80106ef1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ef6:	e9 0f f2 ff ff       	jmp    8010610a <alltraps>

80106efb <vector223>:
.globl vector223
vector223:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $223
80106efd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f02:	e9 03 f2 ff ff       	jmp    8010610a <alltraps>

80106f07 <vector224>:
.globl vector224
vector224:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $224
80106f09:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f0e:	e9 f7 f1 ff ff       	jmp    8010610a <alltraps>

80106f13 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $225
80106f15:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f1a:	e9 eb f1 ff ff       	jmp    8010610a <alltraps>

80106f1f <vector226>:
.globl vector226
vector226:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $226
80106f21:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f26:	e9 df f1 ff ff       	jmp    8010610a <alltraps>

80106f2b <vector227>:
.globl vector227
vector227:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $227
80106f2d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f32:	e9 d3 f1 ff ff       	jmp    8010610a <alltraps>

80106f37 <vector228>:
.globl vector228
vector228:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $228
80106f39:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f3e:	e9 c7 f1 ff ff       	jmp    8010610a <alltraps>

80106f43 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $229
80106f45:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f4a:	e9 bb f1 ff ff       	jmp    8010610a <alltraps>

80106f4f <vector230>:
.globl vector230
vector230:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $230
80106f51:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f56:	e9 af f1 ff ff       	jmp    8010610a <alltraps>

80106f5b <vector231>:
.globl vector231
vector231:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $231
80106f5d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f62:	e9 a3 f1 ff ff       	jmp    8010610a <alltraps>

80106f67 <vector232>:
.globl vector232
vector232:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $232
80106f69:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f6e:	e9 97 f1 ff ff       	jmp    8010610a <alltraps>

80106f73 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $233
80106f75:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f7a:	e9 8b f1 ff ff       	jmp    8010610a <alltraps>

80106f7f <vector234>:
.globl vector234
vector234:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $234
80106f81:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f86:	e9 7f f1 ff ff       	jmp    8010610a <alltraps>

80106f8b <vector235>:
.globl vector235
vector235:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $235
80106f8d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f92:	e9 73 f1 ff ff       	jmp    8010610a <alltraps>

80106f97 <vector236>:
.globl vector236
vector236:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $236
80106f99:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f9e:	e9 67 f1 ff ff       	jmp    8010610a <alltraps>

80106fa3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $237
80106fa5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106faa:	e9 5b f1 ff ff       	jmp    8010610a <alltraps>

80106faf <vector238>:
.globl vector238
vector238:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $238
80106fb1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106fb6:	e9 4f f1 ff ff       	jmp    8010610a <alltraps>

80106fbb <vector239>:
.globl vector239
vector239:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $239
80106fbd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106fc2:	e9 43 f1 ff ff       	jmp    8010610a <alltraps>

80106fc7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $240
80106fc9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106fce:	e9 37 f1 ff ff       	jmp    8010610a <alltraps>

80106fd3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $241
80106fd5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106fda:	e9 2b f1 ff ff       	jmp    8010610a <alltraps>

80106fdf <vector242>:
.globl vector242
vector242:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $242
80106fe1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106fe6:	e9 1f f1 ff ff       	jmp    8010610a <alltraps>

80106feb <vector243>:
.globl vector243
vector243:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $243
80106fed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ff2:	e9 13 f1 ff ff       	jmp    8010610a <alltraps>

80106ff7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $244
80106ff9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106ffe:	e9 07 f1 ff ff       	jmp    8010610a <alltraps>

80107003 <vector245>:
.globl vector245
vector245:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $245
80107005:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010700a:	e9 fb f0 ff ff       	jmp    8010610a <alltraps>

8010700f <vector246>:
.globl vector246
vector246:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $246
80107011:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107016:	e9 ef f0 ff ff       	jmp    8010610a <alltraps>

8010701b <vector247>:
.globl vector247
vector247:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $247
8010701d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107022:	e9 e3 f0 ff ff       	jmp    8010610a <alltraps>

80107027 <vector248>:
.globl vector248
vector248:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $248
80107029:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010702e:	e9 d7 f0 ff ff       	jmp    8010610a <alltraps>

80107033 <vector249>:
.globl vector249
vector249:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $249
80107035:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010703a:	e9 cb f0 ff ff       	jmp    8010610a <alltraps>

8010703f <vector250>:
.globl vector250
vector250:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $250
80107041:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107046:	e9 bf f0 ff ff       	jmp    8010610a <alltraps>

8010704b <vector251>:
.globl vector251
vector251:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $251
8010704d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107052:	e9 b3 f0 ff ff       	jmp    8010610a <alltraps>

80107057 <vector252>:
.globl vector252
vector252:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $252
80107059:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010705e:	e9 a7 f0 ff ff       	jmp    8010610a <alltraps>

80107063 <vector253>:
.globl vector253
vector253:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $253
80107065:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010706a:	e9 9b f0 ff ff       	jmp    8010610a <alltraps>

8010706f <vector254>:
.globl vector254
vector254:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $254
80107071:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107076:	e9 8f f0 ff ff       	jmp    8010610a <alltraps>

8010707b <vector255>:
.globl vector255
vector255:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $255
8010707d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107082:	e9 83 f0 ff ff       	jmp    8010610a <alltraps>
80107087:	66 90                	xchg   %ax,%ax
80107089:	66 90                	xchg   %ax,%ax
8010708b:	66 90                	xchg   %ax,%ax
8010708d:	66 90                	xchg   %ax,%ax
8010708f:	90                   	nop

80107090 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	57                   	push   %edi
80107094:	56                   	push   %esi
80107095:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107096:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010709c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070a2:	83 ec 1c             	sub    $0x1c,%esp
801070a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801070a8:	39 d3                	cmp    %edx,%ebx
801070aa:	73 49                	jae    801070f5 <deallocuvm.part.0+0x65>
801070ac:	89 c7                	mov    %eax,%edi
801070ae:	eb 0c                	jmp    801070bc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801070b0:	83 c0 01             	add    $0x1,%eax
801070b3:	c1 e0 16             	shl    $0x16,%eax
801070b6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
801070b8:	39 da                	cmp    %ebx,%edx
801070ba:	76 39                	jbe    801070f5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
801070bc:	89 d8                	mov    %ebx,%eax
801070be:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801070c1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
801070c4:	f6 c1 01             	test   $0x1,%cl
801070c7:	74 e7                	je     801070b0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
801070c9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070cb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801070d1:	c1 ee 0a             	shr    $0xa,%esi
801070d4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
801070da:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
801070e1:	85 f6                	test   %esi,%esi
801070e3:	74 cb                	je     801070b0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
801070e5:	8b 06                	mov    (%esi),%eax
801070e7:	a8 01                	test   $0x1,%al
801070e9:	75 15                	jne    80107100 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
801070eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070f1:	39 da                	cmp    %ebx,%edx
801070f3:	77 c7                	ja     801070bc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801070f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070fb:	5b                   	pop    %ebx
801070fc:	5e                   	pop    %esi
801070fd:	5f                   	pop    %edi
801070fe:	5d                   	pop    %ebp
801070ff:	c3                   	ret    
      if(pa == 0)
80107100:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107105:	74 25                	je     8010712c <deallocuvm.part.0+0x9c>
      kfree(v);
80107107:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010710a:	05 00 00 00 80       	add    $0x80000000,%eax
8010710f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107112:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107118:	50                   	push   %eax
80107119:	e8 22 b4 ff ff       	call   80102540 <kfree>
      *pte = 0;
8010711e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107124:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107127:	83 c4 10             	add    $0x10,%esp
8010712a:	eb 8c                	jmp    801070b8 <deallocuvm.part.0+0x28>
        panic("kfree");
8010712c:	83 ec 0c             	sub    $0xc,%esp
8010712f:	68 0e 7d 10 80       	push   $0x80107d0e
80107134:	e8 47 92 ff ff       	call   80100380 <panic>
80107139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107140 <mappages>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107146:	89 d3                	mov    %edx,%ebx
80107148:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010714e:	83 ec 1c             	sub    $0x1c,%esp
80107151:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107154:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107158:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010715d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107160:	8b 45 08             	mov    0x8(%ebp),%eax
80107163:	29 d8                	sub    %ebx,%eax
80107165:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107168:	eb 3d                	jmp    801071a7 <mappages+0x67>
8010716a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107170:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107172:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107177:	c1 ea 0a             	shr    $0xa,%edx
8010717a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107180:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107187:	85 c0                	test   %eax,%eax
80107189:	74 75                	je     80107200 <mappages+0xc0>
    if(*pte & PTE_P)
8010718b:	f6 00 01             	testb  $0x1,(%eax)
8010718e:	0f 85 86 00 00 00    	jne    8010721a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107194:	0b 75 0c             	or     0xc(%ebp),%esi
80107197:	83 ce 01             	or     $0x1,%esi
8010719a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010719c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010719f:	74 6f                	je     80107210 <mappages+0xd0>
    a += PGSIZE;
801071a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801071a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
801071aa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071ad:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801071b0:	89 d8                	mov    %ebx,%eax
801071b2:	c1 e8 16             	shr    $0x16,%eax
801071b5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801071b8:	8b 07                	mov    (%edi),%eax
801071ba:	a8 01                	test   $0x1,%al
801071bc:	75 b2                	jne    80107170 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801071be:	e8 3d b5 ff ff       	call   80102700 <kalloc>
801071c3:	85 c0                	test   %eax,%eax
801071c5:	74 39                	je     80107200 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801071c7:	83 ec 04             	sub    $0x4,%esp
801071ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
801071cd:	68 00 10 00 00       	push   $0x1000
801071d2:	6a 00                	push   $0x0
801071d4:	50                   	push   %eax
801071d5:	e8 76 dd ff ff       	call   80104f50 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801071da:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801071dd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801071e0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801071e6:	83 c8 07             	or     $0x7,%eax
801071e9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801071eb:	89 d8                	mov    %ebx,%eax
801071ed:	c1 e8 0a             	shr    $0xa,%eax
801071f0:	25 fc 0f 00 00       	and    $0xffc,%eax
801071f5:	01 d0                	add    %edx,%eax
801071f7:	eb 92                	jmp    8010718b <mappages+0x4b>
801071f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107200:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107208:	5b                   	pop    %ebx
80107209:	5e                   	pop    %esi
8010720a:	5f                   	pop    %edi
8010720b:	5d                   	pop    %ebp
8010720c:	c3                   	ret    
8010720d:	8d 76 00             	lea    0x0(%esi),%esi
80107210:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107213:	31 c0                	xor    %eax,%eax
}
80107215:	5b                   	pop    %ebx
80107216:	5e                   	pop    %esi
80107217:	5f                   	pop    %edi
80107218:	5d                   	pop    %ebp
80107219:	c3                   	ret    
      panic("remap");
8010721a:	83 ec 0c             	sub    $0xc,%esp
8010721d:	68 a8 84 10 80       	push   $0x801084a8
80107222:	e8 59 91 ff ff       	call   80100380 <panic>
80107227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010722e:	66 90                	xchg   %ax,%ax

80107230 <seginit>:
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107236:	e8 75 c8 ff ff       	call   80103ab0 <cpuid>
  pd[0] = size-1;
8010723b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107240:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107246:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010724a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107251:	ff 00 00 
80107254:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
8010725b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010725e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107265:	ff 00 00 
80107268:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
8010726f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107272:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107279:	ff 00 00 
8010727c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80107283:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107286:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
8010728d:	ff 00 00 
80107290:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80107297:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010729a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
8010729f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801072a3:	c1 e8 10             	shr    $0x10,%eax
801072a6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801072aa:	8d 45 f2             	lea    -0xe(%ebp),%eax
801072ad:	0f 01 10             	lgdtl  (%eax)
}
801072b0:	c9                   	leave  
801072b1:	c3                   	ret    
801072b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072c0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072c0:	a1 c4 52 13 80       	mov    0x801352c4,%eax
801072c5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072ca:	0f 22 d8             	mov    %eax,%cr3
}
801072cd:	c3                   	ret    
801072ce:	66 90                	xchg   %ax,%ax

801072d0 <switchuvm>:
{
801072d0:	55                   	push   %ebp
801072d1:	89 e5                	mov    %esp,%ebp
801072d3:	57                   	push   %edi
801072d4:	56                   	push   %esi
801072d5:	53                   	push   %ebx
801072d6:	83 ec 1c             	sub    $0x1c,%esp
801072d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(t->kstack == 0)
801072dc:	8b 91 70 08 00 00    	mov    0x870(%ecx),%edx
801072e2:	c1 e2 05             	shl    $0x5,%edx
801072e5:	01 ca                	add    %ecx,%edx
801072e7:	8b 42 78             	mov    0x78(%edx),%eax
801072ea:	85 c0                	test   %eax,%eax
801072ec:	0f 84 ca 00 00 00    	je     801073bc <switchuvm+0xec>
  if(p->pgdir == 0)
801072f2:	8b 79 08             	mov    0x8(%ecx),%edi
801072f5:	85 ff                	test   %edi,%edi
801072f7:	0f 84 cc 00 00 00    	je     801073c9 <switchuvm+0xf9>
801072fd:	89 55 e0             	mov    %edx,-0x20(%ebp)
80107300:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  pushcli();
80107303:	e8 38 da ff ff       	call   80104d40 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107308:	e8 43 c7 ff ff       	call   80103a50 <mycpu>
8010730d:	89 c3                	mov    %eax,%ebx
8010730f:	e8 3c c7 ff ff       	call   80103a50 <mycpu>
80107314:	89 c7                	mov    %eax,%edi
80107316:	e8 35 c7 ff ff       	call   80103a50 <mycpu>
8010731b:	83 c7 08             	add    $0x8,%edi
8010731e:	89 c6                	mov    %eax,%esi
80107320:	e8 2b c7 ff ff       	call   80103a50 <mycpu>
80107325:	83 c6 08             	add    $0x8,%esi
80107328:	ba 67 00 00 00       	mov    $0x67,%edx
8010732d:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107334:	c1 ee 10             	shr    $0x10,%esi
80107337:	83 c0 08             	add    $0x8,%eax
8010733a:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107341:	89 f1                	mov    %esi,%ecx
80107343:	c1 e8 18             	shr    $0x18,%eax
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107346:	be ff ff ff ff       	mov    $0xffffffff,%esi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010734b:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107351:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107356:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
8010735d:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107363:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107368:	e8 e3 c6 ff ff       	call   80103a50 <mycpu>
8010736d:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107374:	e8 d7 c6 ff ff       	call   80103a50 <mycpu>
  mycpu()->ts.esp0 = (uint)t->kstack + KSTACKSIZE;
80107379:	8b 55 e0             	mov    -0x20(%ebp),%edx
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010737c:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)t->kstack + KSTACKSIZE;
80107380:	8b 5a 78             	mov    0x78(%edx),%ebx
80107383:	e8 c8 c6 ff ff       	call   80103a50 <mycpu>
80107388:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010738e:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107391:	e8 ba c6 ff ff       	call   80103a50 <mycpu>
80107396:	66 89 70 6e          	mov    %si,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
8010739a:	b8 28 00 00 00       	mov    $0x28,%eax
8010739f:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801073a2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801073a5:	8b 41 08             	mov    0x8(%ecx),%eax
801073a8:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073ad:	0f 22 d8             	mov    %eax,%cr3
}
801073b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073b3:	5b                   	pop    %ebx
801073b4:	5e                   	pop    %esi
801073b5:	5f                   	pop    %edi
801073b6:	5d                   	pop    %ebp
  popcli();
801073b7:	e9 d4 d9 ff ff       	jmp    80104d90 <popcli>
    panic("switchuvm: no kstack");
801073bc:	83 ec 0c             	sub    $0xc,%esp
801073bf:	68 ae 84 10 80       	push   $0x801084ae
801073c4:	e8 b7 8f ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
801073c9:	83 ec 0c             	sub    $0xc,%esp
801073cc:	68 c3 84 10 80       	push   $0x801084c3
801073d1:	e8 aa 8f ff ff       	call   80100380 <panic>
801073d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073dd:	8d 76 00             	lea    0x0(%esi),%esi

801073e0 <inituvm>:
{
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	57                   	push   %edi
801073e4:	56                   	push   %esi
801073e5:	53                   	push   %ebx
801073e6:	83 ec 1c             	sub    $0x1c,%esp
801073e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801073ec:	8b 75 10             	mov    0x10(%ebp),%esi
801073ef:	8b 7d 08             	mov    0x8(%ebp),%edi
801073f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801073f5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801073fb:	77 4b                	ja     80107448 <inituvm+0x68>
  mem = kalloc();
801073fd:	e8 fe b2 ff ff       	call   80102700 <kalloc>
  memset(mem, 0, PGSIZE);
80107402:	83 ec 04             	sub    $0x4,%esp
80107405:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010740a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010740c:	6a 00                	push   $0x0
8010740e:	50                   	push   %eax
8010740f:	e8 3c db ff ff       	call   80104f50 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107414:	58                   	pop    %eax
80107415:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010741b:	5a                   	pop    %edx
8010741c:	6a 06                	push   $0x6
8010741e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107423:	31 d2                	xor    %edx,%edx
80107425:	50                   	push   %eax
80107426:	89 f8                	mov    %edi,%eax
80107428:	e8 13 fd ff ff       	call   80107140 <mappages>
  memmove(mem, init, sz);
8010742d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107430:	89 75 10             	mov    %esi,0x10(%ebp)
80107433:	83 c4 10             	add    $0x10,%esp
80107436:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107439:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010743c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010743f:	5b                   	pop    %ebx
80107440:	5e                   	pop    %esi
80107441:	5f                   	pop    %edi
80107442:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107443:	e9 a8 db ff ff       	jmp    80104ff0 <memmove>
    panic("inituvm: more than a page");
80107448:	83 ec 0c             	sub    $0xc,%esp
8010744b:	68 d7 84 10 80       	push   $0x801084d7
80107450:	e8 2b 8f ff ff       	call   80100380 <panic>
80107455:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010745c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107460 <loaduvm>:
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	57                   	push   %edi
80107464:	56                   	push   %esi
80107465:	53                   	push   %ebx
80107466:	83 ec 1c             	sub    $0x1c,%esp
80107469:	8b 45 0c             	mov    0xc(%ebp),%eax
8010746c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010746f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107474:	0f 85 bb 00 00 00    	jne    80107535 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010747a:	01 f0                	add    %esi,%eax
8010747c:	89 f3                	mov    %esi,%ebx
8010747e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107481:	8b 45 14             	mov    0x14(%ebp),%eax
80107484:	01 f0                	add    %esi,%eax
80107486:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107489:	85 f6                	test   %esi,%esi
8010748b:	0f 84 87 00 00 00    	je     80107518 <loaduvm+0xb8>
80107491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010749b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010749e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801074a0:	89 c2                	mov    %eax,%edx
801074a2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801074a5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801074a8:	f6 c2 01             	test   $0x1,%dl
801074ab:	75 13                	jne    801074c0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801074ad:	83 ec 0c             	sub    $0xc,%esp
801074b0:	68 f1 84 10 80       	push   $0x801084f1
801074b5:	e8 c6 8e ff ff       	call   80100380 <panic>
801074ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801074c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801074c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801074ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801074d5:	85 c0                	test   %eax,%eax
801074d7:	74 d4                	je     801074ad <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
801074d9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801074de:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801074e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801074e8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801074ee:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074f1:	29 d9                	sub    %ebx,%ecx
801074f3:	05 00 00 00 80       	add    $0x80000000,%eax
801074f8:	57                   	push   %edi
801074f9:	51                   	push   %ecx
801074fa:	50                   	push   %eax
801074fb:	ff 75 10             	push   0x10(%ebp)
801074fe:	e8 0d a6 ff ff       	call   80101b10 <readi>
80107503:	83 c4 10             	add    $0x10,%esp
80107506:	39 f8                	cmp    %edi,%eax
80107508:	75 1e                	jne    80107528 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010750a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107510:	89 f0                	mov    %esi,%eax
80107512:	29 d8                	sub    %ebx,%eax
80107514:	39 c6                	cmp    %eax,%esi
80107516:	77 80                	ja     80107498 <loaduvm+0x38>
}
80107518:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010751b:	31 c0                	xor    %eax,%eax
}
8010751d:	5b                   	pop    %ebx
8010751e:	5e                   	pop    %esi
8010751f:	5f                   	pop    %edi
80107520:	5d                   	pop    %ebp
80107521:	c3                   	ret    
80107522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107528:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010752b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107530:	5b                   	pop    %ebx
80107531:	5e                   	pop    %esi
80107532:	5f                   	pop    %edi
80107533:	5d                   	pop    %ebp
80107534:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107535:	83 ec 0c             	sub    $0xc,%esp
80107538:	68 94 85 10 80       	push   $0x80108594
8010753d:	e8 3e 8e ff ff       	call   80100380 <panic>
80107542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107550 <allocuvm>:
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	57                   	push   %edi
80107554:	56                   	push   %esi
80107555:	53                   	push   %ebx
80107556:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107559:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010755c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010755f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107562:	85 c0                	test   %eax,%eax
80107564:	0f 88 b6 00 00 00    	js     80107620 <allocuvm+0xd0>
  if(newsz < oldsz)
8010756a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010756d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107570:	0f 82 9a 00 00 00    	jb     80107610 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107576:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010757c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107582:	39 75 10             	cmp    %esi,0x10(%ebp)
80107585:	77 44                	ja     801075cb <allocuvm+0x7b>
80107587:	e9 87 00 00 00       	jmp    80107613 <allocuvm+0xc3>
8010758c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107590:	83 ec 04             	sub    $0x4,%esp
80107593:	68 00 10 00 00       	push   $0x1000
80107598:	6a 00                	push   $0x0
8010759a:	50                   	push   %eax
8010759b:	e8 b0 d9 ff ff       	call   80104f50 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801075a0:	58                   	pop    %eax
801075a1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075a7:	5a                   	pop    %edx
801075a8:	6a 06                	push   $0x6
801075aa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075af:	89 f2                	mov    %esi,%edx
801075b1:	50                   	push   %eax
801075b2:	89 f8                	mov    %edi,%eax
801075b4:	e8 87 fb ff ff       	call   80107140 <mappages>
801075b9:	83 c4 10             	add    $0x10,%esp
801075bc:	85 c0                	test   %eax,%eax
801075be:	78 78                	js     80107638 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801075c0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801075c6:	39 75 10             	cmp    %esi,0x10(%ebp)
801075c9:	76 48                	jbe    80107613 <allocuvm+0xc3>
    mem = kalloc();
801075cb:	e8 30 b1 ff ff       	call   80102700 <kalloc>
801075d0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801075d2:	85 c0                	test   %eax,%eax
801075d4:	75 ba                	jne    80107590 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801075d6:	83 ec 0c             	sub    $0xc,%esp
801075d9:	68 0f 85 10 80       	push   $0x8010850f
801075de:	e8 bd 90 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801075e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801075e6:	83 c4 10             	add    $0x10,%esp
801075e9:	39 45 10             	cmp    %eax,0x10(%ebp)
801075ec:	74 32                	je     80107620 <allocuvm+0xd0>
801075ee:	8b 55 10             	mov    0x10(%ebp),%edx
801075f1:	89 c1                	mov    %eax,%ecx
801075f3:	89 f8                	mov    %edi,%eax
801075f5:	e8 96 fa ff ff       	call   80107090 <deallocuvm.part.0>
      return 0;
801075fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107604:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107607:	5b                   	pop    %ebx
80107608:	5e                   	pop    %esi
80107609:	5f                   	pop    %edi
8010760a:	5d                   	pop    %ebp
8010760b:	c3                   	ret    
8010760c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107610:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107616:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107619:	5b                   	pop    %ebx
8010761a:	5e                   	pop    %esi
8010761b:	5f                   	pop    %edi
8010761c:	5d                   	pop    %ebp
8010761d:	c3                   	ret    
8010761e:	66 90                	xchg   %ax,%ax
    return 0;
80107620:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010762a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010762d:	5b                   	pop    %ebx
8010762e:	5e                   	pop    %esi
8010762f:	5f                   	pop    %edi
80107630:	5d                   	pop    %ebp
80107631:	c3                   	ret    
80107632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107638:	83 ec 0c             	sub    $0xc,%esp
8010763b:	68 27 85 10 80       	push   $0x80108527
80107640:	e8 5b 90 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107645:	8b 45 0c             	mov    0xc(%ebp),%eax
80107648:	83 c4 10             	add    $0x10,%esp
8010764b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010764e:	74 0c                	je     8010765c <allocuvm+0x10c>
80107650:	8b 55 10             	mov    0x10(%ebp),%edx
80107653:	89 c1                	mov    %eax,%ecx
80107655:	89 f8                	mov    %edi,%eax
80107657:	e8 34 fa ff ff       	call   80107090 <deallocuvm.part.0>
      kfree(mem);
8010765c:	83 ec 0c             	sub    $0xc,%esp
8010765f:	53                   	push   %ebx
80107660:	e8 db ae ff ff       	call   80102540 <kfree>
      return 0;
80107665:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010766c:	83 c4 10             	add    $0x10,%esp
}
8010766f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107672:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107675:	5b                   	pop    %ebx
80107676:	5e                   	pop    %esi
80107677:	5f                   	pop    %edi
80107678:	5d                   	pop    %ebp
80107679:	c3                   	ret    
8010767a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107680 <deallocuvm>:
{
80107680:	55                   	push   %ebp
80107681:	89 e5                	mov    %esp,%ebp
80107683:	8b 55 0c             	mov    0xc(%ebp),%edx
80107686:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107689:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010768c:	39 d1                	cmp    %edx,%ecx
8010768e:	73 10                	jae    801076a0 <deallocuvm+0x20>
}
80107690:	5d                   	pop    %ebp
80107691:	e9 fa f9 ff ff       	jmp    80107090 <deallocuvm.part.0>
80107696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010769d:	8d 76 00             	lea    0x0(%esi),%esi
801076a0:	89 d0                	mov    %edx,%eax
801076a2:	5d                   	pop    %ebp
801076a3:	c3                   	ret    
801076a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076af:	90                   	nop

801076b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	57                   	push   %edi
801076b4:	56                   	push   %esi
801076b5:	53                   	push   %ebx
801076b6:	83 ec 0c             	sub    $0xc,%esp
801076b9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801076bc:	85 f6                	test   %esi,%esi
801076be:	74 59                	je     80107719 <freevm+0x69>
  if(newsz >= oldsz)
801076c0:	31 c9                	xor    %ecx,%ecx
801076c2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801076c7:	89 f0                	mov    %esi,%eax
801076c9:	89 f3                	mov    %esi,%ebx
801076cb:	e8 c0 f9 ff ff       	call   80107090 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801076d0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801076d6:	eb 0f                	jmp    801076e7 <freevm+0x37>
801076d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076df:	90                   	nop
801076e0:	83 c3 04             	add    $0x4,%ebx
801076e3:	39 df                	cmp    %ebx,%edi
801076e5:	74 23                	je     8010770a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801076e7:	8b 03                	mov    (%ebx),%eax
801076e9:	a8 01                	test   $0x1,%al
801076eb:	74 f3                	je     801076e0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801076f2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801076f5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076f8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801076fd:	50                   	push   %eax
801076fe:	e8 3d ae ff ff       	call   80102540 <kfree>
80107703:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107706:	39 df                	cmp    %ebx,%edi
80107708:	75 dd                	jne    801076e7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010770a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010770d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107710:	5b                   	pop    %ebx
80107711:	5e                   	pop    %esi
80107712:	5f                   	pop    %edi
80107713:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107714:	e9 27 ae ff ff       	jmp    80102540 <kfree>
    panic("freevm: no pgdir");
80107719:	83 ec 0c             	sub    $0xc,%esp
8010771c:	68 43 85 10 80       	push   $0x80108543
80107721:	e8 5a 8c ff ff       	call   80100380 <panic>
80107726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010772d:	8d 76 00             	lea    0x0(%esi),%esi

80107730 <setupkvm>:
{
80107730:	55                   	push   %ebp
80107731:	89 e5                	mov    %esp,%ebp
80107733:	56                   	push   %esi
80107734:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107735:	e8 c6 af ff ff       	call   80102700 <kalloc>
8010773a:	89 c6                	mov    %eax,%esi
8010773c:	85 c0                	test   %eax,%eax
8010773e:	74 42                	je     80107782 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107740:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107743:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107748:	68 00 10 00 00       	push   $0x1000
8010774d:	6a 00                	push   $0x0
8010774f:	50                   	push   %eax
80107750:	e8 fb d7 ff ff       	call   80104f50 <memset>
80107755:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107758:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010775b:	83 ec 08             	sub    $0x8,%esp
8010775e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107761:	ff 73 0c             	push   0xc(%ebx)
80107764:	8b 13                	mov    (%ebx),%edx
80107766:	50                   	push   %eax
80107767:	29 c1                	sub    %eax,%ecx
80107769:	89 f0                	mov    %esi,%eax
8010776b:	e8 d0 f9 ff ff       	call   80107140 <mappages>
80107770:	83 c4 10             	add    $0x10,%esp
80107773:	85 c0                	test   %eax,%eax
80107775:	78 19                	js     80107790 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107777:	83 c3 10             	add    $0x10,%ebx
8010777a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107780:	75 d6                	jne    80107758 <setupkvm+0x28>
}
80107782:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107785:	89 f0                	mov    %esi,%eax
80107787:	5b                   	pop    %ebx
80107788:	5e                   	pop    %esi
80107789:	5d                   	pop    %ebp
8010778a:	c3                   	ret    
8010778b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010778f:	90                   	nop
      freevm(pgdir);
80107790:	83 ec 0c             	sub    $0xc,%esp
80107793:	56                   	push   %esi
      return 0;
80107794:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107796:	e8 15 ff ff ff       	call   801076b0 <freevm>
      return 0;
8010779b:	83 c4 10             	add    $0x10,%esp
}
8010779e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077a1:	89 f0                	mov    %esi,%eax
801077a3:	5b                   	pop    %ebx
801077a4:	5e                   	pop    %esi
801077a5:	5d                   	pop    %ebp
801077a6:	c3                   	ret    
801077a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ae:	66 90                	xchg   %ax,%ax

801077b0 <kvmalloc>:
{
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801077b6:	e8 75 ff ff ff       	call   80107730 <setupkvm>
801077bb:	a3 c4 52 13 80       	mov    %eax,0x801352c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077c0:	05 00 00 00 80       	add    $0x80000000,%eax
801077c5:	0f 22 d8             	mov    %eax,%cr3
}
801077c8:	c9                   	leave  
801077c9:	c3                   	ret    
801077ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801077d0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801077d0:	55                   	push   %ebp
801077d1:	89 e5                	mov    %esp,%ebp
801077d3:	83 ec 08             	sub    $0x8,%esp
801077d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801077d9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801077dc:	89 c1                	mov    %eax,%ecx
801077de:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801077e1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801077e4:	f6 c2 01             	test   $0x1,%dl
801077e7:	75 17                	jne    80107800 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801077e9:	83 ec 0c             	sub    $0xc,%esp
801077ec:	68 54 85 10 80       	push   $0x80108554
801077f1:	e8 8a 8b ff ff       	call   80100380 <panic>
801077f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077fd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107800:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107803:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107809:	25 fc 0f 00 00       	and    $0xffc,%eax
8010780e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107815:	85 c0                	test   %eax,%eax
80107817:	74 d0                	je     801077e9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107819:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010781c:	c9                   	leave  
8010781d:	c3                   	ret    
8010781e:	66 90                	xchg   %ax,%ax

80107820 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107820:	55                   	push   %ebp
80107821:	89 e5                	mov    %esp,%ebp
80107823:	57                   	push   %edi
80107824:	56                   	push   %esi
80107825:	53                   	push   %ebx
80107826:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107829:	e8 02 ff ff ff       	call   80107730 <setupkvm>
8010782e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107831:	85 c0                	test   %eax,%eax
80107833:	0f 84 bd 00 00 00    	je     801078f6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107839:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010783c:	85 c9                	test   %ecx,%ecx
8010783e:	0f 84 b2 00 00 00    	je     801078f6 <copyuvm+0xd6>
80107844:	31 f6                	xor    %esi,%esi
80107846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010784d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107850:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107853:	89 f0                	mov    %esi,%eax
80107855:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107858:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010785b:	a8 01                	test   $0x1,%al
8010785d:	75 11                	jne    80107870 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010785f:	83 ec 0c             	sub    $0xc,%esp
80107862:	68 5e 85 10 80       	push   $0x8010855e
80107867:	e8 14 8b ff ff       	call   80100380 <panic>
8010786c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107870:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107872:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107877:	c1 ea 0a             	shr    $0xa,%edx
8010787a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107880:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107887:	85 c0                	test   %eax,%eax
80107889:	74 d4                	je     8010785f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010788b:	8b 00                	mov    (%eax),%eax
8010788d:	a8 01                	test   $0x1,%al
8010788f:	0f 84 9f 00 00 00    	je     80107934 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107895:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107897:	25 ff 0f 00 00       	and    $0xfff,%eax
8010789c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010789f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801078a5:	e8 56 ae ff ff       	call   80102700 <kalloc>
801078aa:	89 c3                	mov    %eax,%ebx
801078ac:	85 c0                	test   %eax,%eax
801078ae:	74 64                	je     80107914 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801078b0:	83 ec 04             	sub    $0x4,%esp
801078b3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801078b9:	68 00 10 00 00       	push   $0x1000
801078be:	57                   	push   %edi
801078bf:	50                   	push   %eax
801078c0:	e8 2b d7 ff ff       	call   80104ff0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801078c5:	58                   	pop    %eax
801078c6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801078cc:	5a                   	pop    %edx
801078cd:	ff 75 e4             	push   -0x1c(%ebp)
801078d0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078d5:	89 f2                	mov    %esi,%edx
801078d7:	50                   	push   %eax
801078d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078db:	e8 60 f8 ff ff       	call   80107140 <mappages>
801078e0:	83 c4 10             	add    $0x10,%esp
801078e3:	85 c0                	test   %eax,%eax
801078e5:	78 21                	js     80107908 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801078e7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801078ed:	39 75 0c             	cmp    %esi,0xc(%ebp)
801078f0:	0f 87 5a ff ff ff    	ja     80107850 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801078f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078fc:	5b                   	pop    %ebx
801078fd:	5e                   	pop    %esi
801078fe:	5f                   	pop    %edi
801078ff:	5d                   	pop    %ebp
80107900:	c3                   	ret    
80107901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107908:	83 ec 0c             	sub    $0xc,%esp
8010790b:	53                   	push   %ebx
8010790c:	e8 2f ac ff ff       	call   80102540 <kfree>
      goto bad;
80107911:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107914:	83 ec 0c             	sub    $0xc,%esp
80107917:	ff 75 e0             	push   -0x20(%ebp)
8010791a:	e8 91 fd ff ff       	call   801076b0 <freevm>
  return 0;
8010791f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107926:	83 c4 10             	add    $0x10,%esp
}
80107929:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010792c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010792f:	5b                   	pop    %ebx
80107930:	5e                   	pop    %esi
80107931:	5f                   	pop    %edi
80107932:	5d                   	pop    %ebp
80107933:	c3                   	ret    
      panic("copyuvm: page not present");
80107934:	83 ec 0c             	sub    $0xc,%esp
80107937:	68 78 85 10 80       	push   $0x80108578
8010793c:	e8 3f 8a ff ff       	call   80100380 <panic>
80107941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010794f:	90                   	nop

80107950 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107950:	55                   	push   %ebp
80107951:	89 e5                	mov    %esp,%ebp
80107953:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107956:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107959:	89 c1                	mov    %eax,%ecx
8010795b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010795e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107961:	f6 c2 01             	test   $0x1,%dl
80107964:	0f 84 00 01 00 00    	je     80107a6a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010796a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010796d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107973:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107974:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107979:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107980:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107982:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107987:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010798a:	05 00 00 00 80       	add    $0x80000000,%eax
8010798f:	83 fa 05             	cmp    $0x5,%edx
80107992:	ba 00 00 00 00       	mov    $0x0,%edx
80107997:	0f 45 c2             	cmovne %edx,%eax
}
8010799a:	c3                   	ret    
8010799b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010799f:	90                   	nop

801079a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801079a0:	55                   	push   %ebp
801079a1:	89 e5                	mov    %esp,%ebp
801079a3:	57                   	push   %edi
801079a4:	56                   	push   %esi
801079a5:	53                   	push   %ebx
801079a6:	83 ec 0c             	sub    $0xc,%esp
801079a9:	8b 75 14             	mov    0x14(%ebp),%esi
801079ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801079af:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801079b2:	85 f6                	test   %esi,%esi
801079b4:	75 51                	jne    80107a07 <copyout+0x67>
801079b6:	e9 a5 00 00 00       	jmp    80107a60 <copyout+0xc0>
801079bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079bf:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801079c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801079c6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801079cc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801079d2:	74 75                	je     80107a49 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801079d4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801079d6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801079d9:	29 c3                	sub    %eax,%ebx
801079db:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801079e1:	39 f3                	cmp    %esi,%ebx
801079e3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801079e6:	29 f8                	sub    %edi,%eax
801079e8:	83 ec 04             	sub    $0x4,%esp
801079eb:	01 c1                	add    %eax,%ecx
801079ed:	53                   	push   %ebx
801079ee:	52                   	push   %edx
801079ef:	51                   	push   %ecx
801079f0:	e8 fb d5 ff ff       	call   80104ff0 <memmove>
    len -= n;
    buf += n;
801079f5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801079f8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801079fe:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107a01:	01 da                	add    %ebx,%edx
  while(len > 0){
80107a03:	29 de                	sub    %ebx,%esi
80107a05:	74 59                	je     80107a60 <copyout+0xc0>
  if(*pde & PTE_P){
80107a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107a0a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a0c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107a0e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a11:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107a17:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107a1a:	f6 c1 01             	test   $0x1,%cl
80107a1d:	0f 84 4e 00 00 00    	je     80107a71 <copyout.cold>
  return &pgtab[PTX(va)];
80107a23:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a25:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107a2b:	c1 eb 0c             	shr    $0xc,%ebx
80107a2e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107a34:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107a3b:	89 d9                	mov    %ebx,%ecx
80107a3d:	83 e1 05             	and    $0x5,%ecx
80107a40:	83 f9 05             	cmp    $0x5,%ecx
80107a43:	0f 84 77 ff ff ff    	je     801079c0 <copyout+0x20>
  }
  return 0;
}
80107a49:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a51:	5b                   	pop    %ebx
80107a52:	5e                   	pop    %esi
80107a53:	5f                   	pop    %edi
80107a54:	5d                   	pop    %ebp
80107a55:	c3                   	ret    
80107a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a5d:	8d 76 00             	lea    0x0(%esi),%esi
80107a60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a63:	31 c0                	xor    %eax,%eax
}
80107a65:	5b                   	pop    %ebx
80107a66:	5e                   	pop    %esi
80107a67:	5f                   	pop    %edi
80107a68:	5d                   	pop    %ebp
80107a69:	c3                   	ret    

80107a6a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107a6a:	a1 00 00 00 00       	mov    0x0,%eax
80107a6f:	0f 0b                	ud2    

80107a71 <copyout.cold>:
80107a71:	a1 00 00 00 00       	mov    0x0,%eax
80107a76:	0f 0b                	ud2    
