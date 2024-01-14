
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
80100028:	bc 50 70 11 80       	mov    $0x80117050,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
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
8010004c:	68 40 82 10 80       	push   $0x80108240
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 15 4e 00 00       	call   80104e70 <initlock>
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
80100092:	68 47 82 10 80       	push   $0x80108247
80100097:	50                   	push   %eax
80100098:	e8 a3 4c 00 00       	call   80104d40 <initsleeplock>
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
801000e4:	e8 57 4f 00 00       	call   80105040 <acquire>
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
80100162:	e8 79 4e 00 00       	call   80104fe0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 4c 00 00       	call   80104d80 <acquiresleep>
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
801001a1:	68 4e 82 10 80       	push   $0x8010824e
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
801001be:	e8 5d 4c 00 00       	call   80104e20 <holdingsleep>
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
801001dc:	68 5f 82 10 80       	push   $0x8010825f
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
801001ff:	e8 1c 4c 00 00       	call   80104e20 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 cc 4b 00 00       	call   80104de0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 20 4e 00 00       	call   80105040 <acquire>
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
8010026c:	e9 6f 4d 00 00       	jmp    80104fe0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 66 82 10 80       	push   $0x80108266
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
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 9b 4d 00 00       	call   80105040 <acquire>
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
801002cd:	e8 5e 47 00 00       	call   80104a30 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 09 38 00 00       	call   80103af0 <myproc>
801002e7:	8b 48 30             	mov    0x30(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 e5 4c 00 00       	call   80104fe0 <release>
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
8010034c:	e8 8f 4c 00 00       	call   80104fe0 <release>
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
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 82 10 80       	push   $0x8010826d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 f3 8c 10 80 	movl   $0x80108cf3,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 c3 4a 00 00       	call   80104e90 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 81 82 10 80       	push   $0x80108281
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
8010041a:	e8 41 69 00 00       	call   80106d60 <uartputc>
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
80100505:	e8 56 68 00 00       	call   80106d60 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 4a 68 00 00       	call   80106d60 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 3e 68 00 00       	call   80106d60 <uartputc>
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
80100551:	e8 4a 4c 00 00       	call   801051a0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 95 4b 00 00       	call   80105100 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 85 82 10 80       	push   $0x80108285
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
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 90 4a 00 00       	call   80105040 <acquire>
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
801005e4:	e8 f7 49 00 00       	call   80104fe0 <release>
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
80100636:	0f b6 92 b0 82 10 80 	movzbl -0x7fef7d50(%edx),%edx
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
801007e8:	e8 53 48 00 00       	call   80105040 <acquire>
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
80100838:	bf 98 82 10 80       	mov    $0x80108298,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 80 47 00 00       	call   80104fe0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 9f 82 10 80       	push   $0x8010829f
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
80100893:	e8 a8 47 00 00       	call   80105040 <acquire>
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
801009d0:	e8 0b 46 00 00       	call   80104fe0 <release>
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
80100a0e:	e9 bd 41 00 00       	jmp    80104bd0 <procdump>
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
80100a44:	e8 a7 40 00 00       	call   80104af0 <wakeup>
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
80100a66:	68 a8 82 10 80       	push   $0x801082a8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 fb 43 00 00       	call   80104e70 <initlock>

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
80100abc:	e8 2f 30 00 00       	call   80103af0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 94 22 00 00       	call   80102d60 <begin_op>

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
80100b0f:	e8 bc 22 00 00       	call   80102dd0 <end_op>
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
80100b34:	e8 b7 73 00 00       	call   80107ef0 <setupkvm>
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
80100ba3:	e8 68 71 00 00       	call   80107d10 <allocuvm>
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
80100bd9:	e8 42 70 00 00       	call   80107c20 <loaduvm>
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
80100c1b:	e8 50 72 00 00       	call   80107e70 <freevm>
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
80100c51:	e8 7a 21 00 00       	call   80102dd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 a9 70 00 00       	call   80107d10 <allocuvm>
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
80100c83:	e8 08 73 00 00       	call   80107f90 <clearpteu>
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
80100cd3:	e8 28 46 00 00       	call   80105300 <strlen>
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
80100ce7:	e8 14 46 00 00       	call   80105300 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 63 74 00 00       	call   80108160 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 5a 71 00 00       	call   80107e70 <freevm>
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
80100d63:	e8 f8 73 00 00       	call   80108160 <copyout>
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
80100d9d:	83 c0 78             	add    $0x78,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 1a 45 00 00       	call   801052c0 <safestrcpy>
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
80100dcd:	e8 be 6c 00 00       	call   80107a90 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 96 70 00 00       	call   80107e70 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 c1 82 10 80       	push   $0x801082c1
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
80100e16:	68 cd 82 10 80       	push   $0x801082cd
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 4b 40 00 00       	call   80104e70 <initlock>
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
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 fa 41 00 00       	call   80105040 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
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
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 6a 41 00 00       	call   80104fe0 <release>
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
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 51 41 00 00       	call   80104fe0 <release>
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
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 8c 41 00 00       	call   80105040 <acquire>
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
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 0f 41 00 00       	call   80104fe0 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 d4 82 10 80       	push   $0x801082d4
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
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 3a 41 00 00       	call   80105040 <acquire>
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
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 9f 40 00 00       	call   80104fe0 <release>

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
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 6d 40 00 00       	jmp    80104fe0 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 e3 1d 00 00       	call   80102d60 <begin_op>
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
80100f92:	e9 39 1e 00 00       	jmp    80102dd0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 82 25 00 00       	call   80103530 <pipeclose>
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
80100fbc:	68 dc 82 10 80       	push   $0x801082dc
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
8010108d:	e9 3e 26 00 00       	jmp    801036d0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 e6 82 10 80       	push   $0x801082e6
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
80101109:	e8 c2 1c 00 00       	call   80102dd0 <end_op>

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
8010112e:	e8 2d 1c 00 00       	call   80102d60 <begin_op>
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
80101165:	e8 66 1c 00 00       	call   80102dd0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 ef 82 10 80       	push   $0x801082ef
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
801011a9:	e9 22 24 00 00       	jmp    801035d0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 f5 82 10 80       	push   $0x801082f5
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
801011c8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
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
8010120d:	e8 2e 1d 00 00       	call   80102f40 <log_write>
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
80101227:	68 ff 82 10 80       	push   $0x801082ff
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
80101249:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
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
8010126c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 25 11 80       	mov    0x801125b4,%eax
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
801012d9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 12 83 10 80       	push   $0x80108312
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
801012fd:	e8 3e 1c 00 00       	call   80102f40 <log_write>
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
80101325:	e8 d6 3d 00 00       	call   80105100 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 0e 1c 00 00       	call   80102f40 <log_write>
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
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 d1 3c 00 00       	call   80105040 <acquire>
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
8010138a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
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
801013a9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
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
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 04 3c 00 00       	call   80104fe0 <release>

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
801013fd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 d6 3b 00 00       	call   80104fe0 <release>
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
8010141d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 28 83 10 80       	push   $0x80108328
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
801014c5:	e8 76 1a 00 00       	call   80102f40 <log_write>
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
80101515:	68 38 83 10 80       	push   $0x80108338
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
80101541:	e8 5a 3c 00 00       	call   801051a0 <memmove>
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
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 4b 83 10 80       	push   $0x8010834b
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 f5 38 00 00       	call   80104e70 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 52 83 10 80       	push   $0x80108352
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 ac 37 00 00       	call   80104d40 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
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
801015b7:	68 b4 25 11 80       	push   $0x801125b4
801015bc:	e8 df 3b 00 00       	call   801051a0 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 25 11 80    	push   0x801125cc
801015cf:	ff 35 c8 25 11 80    	push   0x801125c8
801015d5:	ff 35 c4 25 11 80    	push   0x801125c4
801015db:	ff 35 c0 25 11 80    	push   0x801125c0
801015e1:	ff 35 bc 25 11 80    	push   0x801125bc
801015e7:	ff 35 b8 25 11 80    	push   0x801125b8
801015ed:	ff 35 b4 25 11 80    	push   0x801125b4
801015f3:	68 b8 83 10 80       	push   $0x801083b8
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
8010161c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
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
8010164f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
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
8010168e:	e8 6d 3a 00 00       	call   80105100 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 18 00 00       	call   80102f40 <log_write>
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
801016c3:	68 58 83 10 80       	push   $0x80108358
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
801016e4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
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
80101731:	e8 6a 3a 00 00       	call   801051a0 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 02 18 00 00       	call   80102f40 <log_write>
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
8010175a:	68 60 09 11 80       	push   $0x80110960
8010175f:	e8 dc 38 00 00       	call   80105040 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 6c 38 00 00       	call   80104fe0 <release>
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
801017a2:	e8 d9 35 00 00       	call   80104d80 <acquiresleep>
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
801017c9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
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
80101818:	e8 83 39 00 00       	call   801051a0 <memmove>
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
8010183d:	68 70 83 10 80       	push   $0x80108370
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 6a 83 10 80       	push   $0x8010836a
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
80101873:	e8 a8 35 00 00       	call   80104e20 <holdingsleep>
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
8010188f:	e9 4c 35 00 00       	jmp    80104de0 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 7f 83 10 80       	push   $0x8010837f
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
801018c0:	e8 bb 34 00 00       	call   80104d80 <acquiresleep>
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
801018da:	e8 01 35 00 00       	call   80104de0 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 55 37 00 00       	call   80105040 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 db 36 00 00       	jmp    80104fe0 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 2b 37 00 00       	call   80105040 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 bc 36 00 00       	call   80104fe0 <release>
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
80101a23:	e8 f8 33 00 00       	call   80104e20 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 a1 33 00 00       	call   80104de0 <releasesleep>
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
80101a53:	68 7f 83 10 80       	push   $0x8010837f
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
80101b37:	e8 64 36 00 00       	call   801051a0 <memmove>
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
80101b6a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
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
80101c33:	e8 68 35 00 00       	call   801051a0 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 13 00 00       	call   80102f40 <log_write>
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
80101c7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
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
80101cce:	e8 3d 35 00 00       	call   80105210 <strncmp>
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
80101d2d:	e8 de 34 00 00       	call   80105210 <strncmp>
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
80101d72:	68 99 83 10 80       	push   $0x80108399
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 87 83 10 80       	push   $0x80108387
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
80101daa:	e8 41 1d 00 00       	call   80103af0 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 74             	mov    0x74(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 81 32 00 00       	call   80105040 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 11 32 00 00       	call   80104fe0 <release>
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
80101e27:	e8 74 33 00 00       	call   801051a0 <memmove>
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
80101e8c:	e8 8f 2f 00 00       	call   80104e20 <holdingsleep>
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
80101eae:	e8 2d 2f 00 00       	call   80104de0 <releasesleep>
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
80101edb:	e8 c0 32 00 00       	call   801051a0 <memmove>
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
80101f2b:	e8 f0 2e 00 00       	call   80104e20 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 91 2e 00 00       	call   80104de0 <releasesleep>
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
80101f6d:	e8 ae 2e 00 00       	call   80104e20 <holdingsleep>
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
80101f90:	e8 8b 2e 00 00       	call   80104e20 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 34 2e 00 00       	call   80104de0 <releasesleep>
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
80101fcf:	68 7f 83 10 80       	push   $0x8010837f
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
8010203d:	e8 1e 32 00 00       	call   80105260 <strncpy>
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
8010207b:	68 a8 83 10 80       	push   $0x801083a8
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 ae 8a 10 80       	push   $0x80108aae
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
8010219b:	68 14 84 10 80       	push   $0x80108414
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 0b 84 10 80       	push   $0x8010840b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 26 84 10 80       	push   $0x80108426
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 9b 2c 00 00       	call   80104e70 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 27 11 80       	mov    0x80112784,%eax
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
8010221a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
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
80102249:	68 00 26 11 80       	push   $0x80112600
8010224e:	e8 ed 2d 00 00       	call   80105040 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 25 11 80       	mov    %eax,0x801125e4

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
801022ad:	e8 3e 28 00 00       	call   80104af0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 26 11 80       	push   $0x80112600
801022cb:	e8 10 2d 00 00       	call   80104fe0 <release>

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
801022ee:	e8 2d 2b 00 00       	call   80104e20 <holdingsleep>
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
80102313:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 26 11 80       	push   $0x80112600
80102328:	e8 13 2d 00 00       	call   80105040 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
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
8010234e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
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
80102363:	68 00 26 11 80       	push   $0x80112600
80102368:	53                   	push   %ebx
80102369:	e8 c2 26 00 00       	call   80104a30 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 55 2c 00 00       	jmp    80104fe0 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 55 84 10 80       	push   $0x80108455
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 40 84 10 80       	push   $0x80108440
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 2a 84 10 80       	push   $0x8010842a
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
801023d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
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
8010241a:	68 74 84 10 80       	push   $0x80108474
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
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
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
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
8010245e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
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
80102481:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
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
80102495:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 26 11 80       	mov    0x80112634,%eax
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
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb 50 70 11 80    	cmp    $0x80117050,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 09 2c 00 00       	call   80105100 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 78 26 11 80       	mov    0x80112678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 26 11 80       	push   $0x80112640
80102528:	e8 13 2b 00 00       	call   80105040 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 98 2a 00 00       	jmp    80104fe0 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 a6 84 10 80       	push   $0x801084a6
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 ac 84 10 80       	push   $0x801084ac
80102620:	68 40 26 11 80       	push   $0x80112640
80102625:	e8 46 28 00 00       	call   80104e70 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 74 26 11 80       	mov    0x80112674,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 40 26 11 80       	push   $0x80112640
801026b3:	e8 88 29 00 00       	call   80105040 <acquire>
  r = kmem.freelist;
801026b8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801026bd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 26 11 80       	push   $0x80112640
801026e1:	e8 fa 28 00 00       	call   80104fe0 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
801026fe:	55                   	push   %ebp
801026ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102704:	89 e5                	mov    %esp,%ebp
80102706:	53                   	push   %ebx
80102707:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102708:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010270e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102711:	3c e0                	cmp    $0xe0,%al
80102713:	74 5b                	je     80102770 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102715:	89 da                	mov    %ebx,%edx
80102717:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010271a:	84 c0                	test   %al,%al
8010271c:	78 62                	js     80102780 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010271e:	85 d2                	test   %edx,%edx
80102720:	74 09                	je     8010272b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102722:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102725:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102728:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010272b:	0f b6 91 e0 85 10 80 	movzbl -0x7fef7a20(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 e0 84 10 80 	movzbl -0x7fef7b20(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 c0 84 10 80 	mov    -0x7fef7b40(,%eax,4),%eax
80102752:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102756:	74 0b                	je     80102763 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102758:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275b:	83 fa 19             	cmp    $0x19,%edx
8010275e:	77 48                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102760:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave  
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 e0 85 10 80 	movzbl -0x7fef7a20(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801027a1:	31 c0                	xor    %eax,%eax
}
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b1:	c9                   	leave  
      c += 'a' - 'A';
801027b2:	83 f9 1a             	cmp    $0x1a,%ecx
801027b5:	0f 42 c2             	cmovb  %edx,%eax
}
801027b8:	c3                   	ret    
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 a0 e0 ff ff       	call   80100880 <consoleintr>
}
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	c9                   	leave  
801027e4:	c3                   	ret    
801027e5:	66 90                	xchg   %ax,%ax
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	0f 84 cb 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
801027fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102804:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102811:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102817:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010281e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102838:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102845:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102848:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284b:	8b 50 30             	mov    0x30(%eax),%edx
8010284e:	c1 ea 10             	shr    $0x10,%edx
80102851:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102857:	75 77                	jne    801028d0 <lapicinit+0xe0>
  lapic[index] = value;
80102859:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102866:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102870:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102873:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102880:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102887:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
801028a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
}
801028dd:	e9 77 ff ff ff       	jmp    80102859 <lapicinit+0x69>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 07                	je     80102900 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028f9:	8b 40 20             	mov    0x20(%eax),%eax
801028fc:	c1 e8 18             	shr    $0x18,%eax
801028ff:	c3                   	ret    
    return 0;
80102900:	31 c0                	xor    %eax,%eax
}
80102902:	c3                   	ret    
80102903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102910:	a1 80 26 11 80       	mov    0x80112680,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 0d                	je     80102926 <lapiceoi+0x16>
  lapic[index] = value;
80102919:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102920:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102923:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102926:	c3                   	ret    
80102927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292e:	66 90                	xchg   %ax,%ax

80102930 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102930:	c3                   	ret    
80102931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102941:	b8 0f 00 00 00       	mov    $0xf,%eax
80102946:	ba 70 00 00 00       	mov    $0x70,%edx
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	53                   	push   %ebx
8010294e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102954:	ee                   	out    %al,(%dx)
80102955:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295a:	ba 71 00 00 00       	mov    $0x71,%edx
8010295f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102960:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102962:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102965:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010296d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102970:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102972:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102975:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102978:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010297e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102983:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102993:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102996:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102999:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cd:	c9                   	leave  
801029ce:	c3                   	ret    
801029cf:	90                   	nop

801029d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029d0:	55                   	push   %ebp
801029d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	ba 71 00 00 00       	mov    $0x71,%edx
801029e9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f5:	8d 76 00             	lea    0x0(%esi),%esi
801029f8:	31 c0                	xor    %eax,%eax
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a08:	89 da                	mov    %ebx,%edx
80102a0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	b8 08 00 00 00       	mov    $0x8,%eax
80102a39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3a:	89 ca                	mov    %ecx,%edx
80102a3c:	ec                   	in     (%dx),%al
80102a3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3f:	89 da                	mov    %ebx,%edx
80102a41:	b8 09 00 00 00       	mov    $0x9,%eax
80102a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a57:	84 c0                	test   %al,%al
80102a59:	78 9d                	js     801029f8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a5f:	89 fa                	mov    %edi,%edx
80102a61:	0f b6 fa             	movzbl %dl,%edi
80102a64:	89 f2                	mov    %esi,%edx
80102a66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a70:	89 da                	mov    %ebx,%edx
80102a72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a89:	31 c0                	xor    %eax,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a97:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
80102aa0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa3:	89 da                	mov    %ebx,%edx
80102aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab9:	b8 07 00 00 00       	mov    $0x7,%eax
80102abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
80102ac2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aca:	b8 08 00 00 00       	mov    $0x8,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102adb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae1:	89 ca                	mov    %ecx,%edx
80102ae3:	ec                   	in     (%dx),%al
80102ae4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ae7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af0:	6a 18                	push   $0x18
80102af2:	50                   	push   %eax
80102af3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af6:	50                   	push   %eax
80102af7:	e8 54 26 00 00       	call   80105150 <memcmp>
80102afc:	83 c4 10             	add    $0x10,%esp
80102aff:	85 c0                	test   %eax,%eax
80102b01:	0f 85 f1 fe ff ff    	jne    801029f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b0b:	75 78                	jne    80102b85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b85:	8b 75 08             	mov    0x8(%ebp),%esi
80102b88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b8b:	89 06                	mov    %eax,(%esi)
80102b8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b90:	89 46 04             	mov    %eax,0x4(%esi)
80102b93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b96:	89 46 08             	mov    %eax,0x8(%esi)
80102b99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba2:	89 46 10             	mov    %eax,0x10(%esi)
80102ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bb5:	5b                   	pop    %ebx
80102bb6:	5e                   	pop    %esi
80102bb7:	5f                   	pop    %edi
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd2:	31 ff                	xor    %edi,%edi
{
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102be0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 e4 26 11 80    	push   0x801126e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c04:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 77 25 00 00       	call   801051a0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 7f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 b7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 af d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
  }
}
80102c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4f:	5b                   	pop    %ebx
80102c50:	5e                   	pop    %esi
80102c51:	5f                   	pop    %edi
80102c52:	5d                   	pop    %ebp
80102c53:	c3                   	ret    
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	c3                   	ret    
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c67:	ff 35 d4 26 11 80    	push   0x801126d4
80102c6d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102c97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d0                	cmp    %edx,%eax
80102ca0:	75 ee                	jne    80102c90 <write_head+0x30>
  }
  bwrite(buf);
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	53                   	push   %ebx
80102ca6:	e8 05 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cab:	89 1c 24             	mov    %ebx,(%esp)
80102cae:	e8 3d d5 ff ff       	call   801001f0 <brelse>
}
80102cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	c9                   	leave  
80102cba:	c3                   	ret    
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <initlog>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 2c             	sub    $0x2c,%esp
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cca:	68 e0 86 10 80       	push   $0x801086e0
80102ccf:	68 a0 26 11 80       	push   $0x801126a0
80102cd4:	e8 97 21 00 00       	call   80104e70 <initlock>
  readsb(dev, &sb);
80102cd9:	58                   	pop    %eax
80102cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 3b e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ce8:	59                   	pop    %ecx
  log.dev = dev;
80102ce9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf2:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102cf7:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d0b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d24:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d3                	cmp    %edx,%ebx
80102d30:	75 ee                	jne    80102d20 <initlog+0x60>
  brelse(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	50                   	push   %eax
80102d36:	e8 b5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d3b:	e8 80 fe ff ff       	call   80102bc0 <install_trans>
  log.lh.n = 0;
80102d40:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d47:	00 00 00 
  write_head(); // clear the log
80102d4a:	e8 11 ff ff ff       	call   80102c60 <write_head>
}
80102d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c9                   	leave  
80102d56:	c3                   	ret    
80102d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d66:	68 a0 26 11 80       	push   $0x801126a0
80102d6b:	e8 d0 22 00 00       	call   80105040 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 26 11 80       	push   $0x801126a0
80102d80:	68 a0 26 11 80       	push   $0x801126a0
80102d85:	e8 a6 1c 00 00       	call   80104a30 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d9b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102da1:	83 c0 01             	add    $0x1,%eax
80102da4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102da7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102daa:	83 fa 1e             	cmp    $0x1e,%edx
80102dad:	7f c9                	jg     80102d78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102daf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102db2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102db7:	68 a0 26 11 80       	push   $0x801126a0
80102dbc:	e8 1f 22 00 00       	call   80104fe0 <release>
      break;
    }
  }
}
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    
80102dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi

80102dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	57                   	push   %edi
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dd9:	68 a0 26 11 80       	push   $0x801126a0
80102dde:	e8 5d 22 00 00       	call   80105040 <acquire>
  log.outstanding -= 1;
80102de3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102de8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 a0 26 11 80       	push   $0x801126a0
80102e1c:	e8 bf 21 00 00       	call   80104fe0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 a0 26 11 80       	push   $0x801126a0
80102e36:	e8 05 22 00 00       	call   80105040 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102e42:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 9f 1c 00 00       	call   80104af0 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e58:	e8 83 21 00 00       	call   80104fe0 <release>
80102e5d:	83 c4 10             	add    $0x10,%esp
}
80102e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e63:	5b                   	pop    %ebx
80102e64:	5e                   	pop    %esi
80102e65:	5f                   	pop    %edi
80102e66:	5d                   	pop    %ebp
80102e67:	c3                   	ret    
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e70:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 e4 26 11 80    	push   0x801126e4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102e94:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ea2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ea7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 e7 22 00 00       	call   801051a0 <memmove>
    bwrite(to);  // write the log
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 ef d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 27 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 1f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 a0 26 11 80       	push   $0x801126a0
80102f08:	e8 e3 1b 00 00       	call   80104af0 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f14:	e8 c7 20 00 00       	call   80104fe0 <release>
80102f19:	83 c4 10             	add    $0x10,%esp
}
80102f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5f                   	pop    %edi
80102f22:	5d                   	pop    %ebp
80102f23:	c3                   	ret    
    panic("log.committing");
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 e4 86 10 80       	push   $0x801086e4
80102f2c:	e8 4f d4 ff ff       	call   80100380 <panic>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f47:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f65:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 a0 26 11 80       	push   $0x801126a0
80102f76:	e8 c5 20 00 00       	call   80105040 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f7b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	85 d2                	test   %edx,%edx
80102f86:	7e 4a                	jle    80102fd2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f88:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	31 c0                	xor    %eax,%eax
80102f8d:	eb 08                	jmp    80102f97 <log_write+0x57>
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f97:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 26 20 00 00       	jmp    80104fe0 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 f3 86 10 80       	push   $0x801086f3
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 09 87 10 80       	push   $0x80108709
80102ff3:	e8 88 d3 ff ff       	call   80100380 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 e4 09 00 00       	call   801039f0 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 dd 09 00 00       	call   801039f0 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 24 87 10 80       	push   $0x80108724
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 59 39 00 00       	call   80106980 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 64 09 00 00       	call   80103990 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 91 14 00 00       	call   801044d0 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 35 4a 00 00       	call   80107a80 <switchkvm>
  seginit();
8010304b:	e8 a0 49 00 00       	call   801079f0 <seginit>
  lapicinit();
80103050:	e8 9b f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 50 70 11 80       	push   $0x80117050
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 ea 4e 00 00       	call   80107f70 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 5b 49 00 00       	call   801079f0 <seginit>
  init_shared_pages();
80103095:	e8 46 1c 00 00       	call   80104ce0 <init_shared_pages>
  picinit();       // disable pic
8010309a:	e8 71 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309f:	e8 2c f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
801030a4:	e8 b7 d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a9:	e8 d2 3b 00 00       	call   80106c80 <uartinit>
  pinit();         // process table
801030ae:	e8 6d 08 00 00       	call   80103920 <pinit>
  tvinit();        // trap vectors
801030b3:	e8 48 38 00 00       	call   80106900 <tvinit>
  binit();         // buffer cache
801030b8:	e8 83 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030bd:	e8 4e dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030c2:	e8 f9 f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c7:	83 c4 0c             	add    $0xc,%esp
801030ca:	68 8a 00 00 00       	push   $0x8a
801030cf:	68 8c b4 10 80       	push   $0x8010b48c
801030d4:	68 00 70 00 80       	push   $0x80007000
801030d9:	e8 c2 20 00 00       	call   801051a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030de:	83 c4 10             	add    $0x10,%esp
801030e1:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030e8:	00 00 00 
801030eb:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030f0:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801030f5:	76 79                	jbe    80103170 <main+0x110>
801030f7:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801030fc:	eb 1b                	jmp    80103119 <main+0xb9>
801030fe:	66 90                	xchg   %ax,%ax
80103100:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 72 08 00 00       	call   80103990 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 59 f5 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010313b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ea f7 ff ff       	call   80102940 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 2e f4 ff ff       	call   801025b0 <kinit2>
  userinit();      // first user process
80103182:	e8 d9 09 00 00       	call   80103b60 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 fb                	cmp    %edi,%ebx
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 38 87 10 80       	push   $0x80108738
801031c3:	56                   	push   %esi
801031c4:	e8 87 1f 00 00       	call   80105150 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret    
80103204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	75 1b                	jne    8010324c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103231:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103238:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010323f:	c1 e0 08             	shl    $0x8,%eax
80103242:	09 d0                	or     %edx,%eax
80103244:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103247:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324c:	ba 00 04 00 00       	mov    $0x400,%edx
80103251:	e8 3a ff ff ff       	call   80103190 <mpsearch1>
80103256:	89 c3                	mov    %eax,%ebx
80103258:	85 c0                	test   %eax,%eax
8010325a:	0f 84 40 01 00 00    	je     801033a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103260:	8b 73 04             	mov    0x4(%ebx),%esi
80103263:	85 f6                	test   %esi,%esi
80103265:	0f 84 25 01 00 00    	je     80103390 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010326e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103274:	6a 04                	push   $0x4
80103276:	68 3d 87 10 80       	push   $0x8010873d
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 cc 1e 00 00       	call   80105150 <memcmp>
80103284:	83 c4 10             	add    $0x10,%esp
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 85 01 01 00 00    	jne    80103390 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010328f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103296:	3c 01                	cmp    $0x1,%al
80103298:	74 08                	je     801032a2 <mpinit+0x92>
8010329a:	3c 04                	cmp    $0x4,%al
8010329c:	0f 85 ee 00 00 00    	jne    80103390 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032a9:	66 85 d2             	test   %dx,%dx
801032ac:	74 22                	je     801032d0 <mpinit+0xc0>
801032ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032b3:	31 d2                	xor    %edx,%edx
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032c4:	39 c7                	cmp    %eax,%edi
801032c6:	75 f0                	jne    801032b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032c8:	84 d2                	test   %dl,%dl
801032ca:	0f 85 c0 00 00 00    	jne    80103390 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032d6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801032f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032f7:	90                   	nop
801032f8:	39 d0                	cmp    %edx,%eax
801032fa:	73 15                	jae    80103311 <mpinit+0x101>
    switch(*p){
801032fc:	0f b6 08             	movzbl (%eax),%ecx
801032ff:	80 f9 02             	cmp    $0x2,%cl
80103302:	74 4c                	je     80103350 <mpinit+0x140>
80103304:	77 3a                	ja     80103340 <mpinit+0x130>
80103306:	84 c9                	test   %cl,%cl
80103308:	74 56                	je     80103360 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010330a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	39 d0                	cmp    %edx,%eax
8010330f:	72 eb                	jb     801032fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103311:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103314:	85 f6                	test   %esi,%esi
80103316:	0f 84 d9 00 00 00    	je     801033f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010331c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103320:	74 15                	je     80103337 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103322:	b8 70 00 00 00       	mov    $0x70,%eax
80103327:	ba 22 00 00 00       	mov    $0x22,%edx
8010332c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010332d:	ba 23 00 00 00       	mov    $0x23,%edx
80103332:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103333:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103336:	ee                   	out    %al,(%dx)
  }
}
80103337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333a:	5b                   	pop    %ebx
8010333b:	5e                   	pop    %esi
8010333c:	5f                   	pop    %edi
8010333d:	5d                   	pop    %ebp
8010333e:	c3                   	ret    
8010333f:	90                   	nop
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 c2                	jbe    8010330a <mpinit+0xfa>
80103348:	31 f6                	xor    %esi,%esi
8010334a:	eb ac                	jmp    801032f8 <mpinit+0xe8>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103350:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103354:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103357:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010335d:	eb 99                	jmp    801032f8 <mpinit+0xe8>
8010335f:	90                   	nop
      if(ncpu < NCPU) {
80103360:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 6c ff ff ff       	jmp    801032f8 <mpinit+0xe8>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 42 87 10 80       	push   $0x80108742
80103398:	e8 e3 cf ff ff       	call   80100380 <panic>
8010339d:	8d 76 00             	lea    0x0(%esi),%esi
{
801033a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033a5:	eb 13                	jmp    801033ba <mpinit+0x1aa>
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033b0:	89 f3                	mov    %esi,%ebx
801033b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033b8:	74 d6                	je     80103390 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ba:	83 ec 04             	sub    $0x4,%esp
801033bd:	8d 73 10             	lea    0x10(%ebx),%esi
801033c0:	6a 04                	push   $0x4
801033c2:	68 38 87 10 80       	push   $0x80108738
801033c7:	53                   	push   %ebx
801033c8:	e8 83 1d 00 00       	call   80105150 <memcmp>
801033cd:	83 c4 10             	add    $0x10,%esp
801033d0:	85 c0                	test   %eax,%eax
801033d2:	75 dc                	jne    801033b0 <mpinit+0x1a0>
801033d4:	89 da                	mov    %ebx,%edx
801033d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e8:	39 d6                	cmp    %edx,%esi
801033ea:	75 f4                	jne    801033e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ec:	84 c0                	test   %al,%al
801033ee:	75 c0                	jne    801033b0 <mpinit+0x1a0>
801033f0:	e9 6b fe ff ff       	jmp    80103260 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033f5:	83 ec 0c             	sub    $0xc,%esp
801033f8:	68 5c 87 10 80       	push   $0x8010875c
801033fd:	e8 7e cf ff ff       	call   80100380 <panic>
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <picinit>:
80103410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103415:	ba 21 00 00 00       	mov    $0x21,%edx
8010341a:	ee                   	out    %al,(%dx)
8010341b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103420:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103421:	c3                   	ret    
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010343c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010343f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010344b:	e8 e0 d9 ff ff       	call   80100e30 <filealloc>
80103450:	89 03                	mov    %eax,(%ebx)
80103452:	85 c0                	test   %eax,%eax
80103454:	0f 84 a8 00 00 00    	je     80103502 <pipealloc+0xd2>
8010345a:	e8 d1 d9 ff ff       	call   80100e30 <filealloc>
8010345f:	89 06                	mov    %eax,(%esi)
80103461:	85 c0                	test   %eax,%eax
80103463:	0f 84 87 00 00 00    	je     801034f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103469:	e8 12 f2 ff ff       	call   80102680 <kalloc>
8010346e:	89 c7                	mov    %eax,%edi
80103470:	85 c0                	test   %eax,%eax
80103472:	0f 84 b0 00 00 00    	je     80103528 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103478:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103482:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103485:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010348c:	00 00 00 
  p->nwrite = 0;
8010348f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103496:	00 00 00 
  p->nread = 0;
80103499:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034a0:	00 00 00 
  initlock(&p->lock, "pipe");
801034a3:	68 7b 87 10 80       	push   $0x8010877b
801034a8:	50                   	push   %eax
801034a9:	e8 c2 19 00 00       	call   80104e70 <initlock>
  (*f0)->type = FD_PIPE;
801034ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b9:	8b 03                	mov    (%ebx),%eax
801034bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034bf:	8b 03                	mov    (%ebx),%eax
801034c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034c5:	8b 03                	mov    (%ebx),%eax
801034c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d8:	8b 06                	mov    (%esi),%eax
801034da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034e6:	31 c0                	xor    %eax,%eax
}
801034e8:	5b                   	pop    %ebx
801034e9:	5e                   	pop    %esi
801034ea:	5f                   	pop    %edi
801034eb:	5d                   	pop    %ebp
801034ec:	c3                   	ret    
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	74 1e                	je     80103514 <pipealloc+0xe4>
    fileclose(*f0);
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	50                   	push   %eax
801034fa:	e8 f1 d9 ff ff       	call   80100ef0 <fileclose>
801034ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103502:	8b 06                	mov    (%esi),%eax
80103504:	85 c0                	test   %eax,%eax
80103506:	74 0c                	je     80103514 <pipealloc+0xe4>
    fileclose(*f1);
80103508:	83 ec 0c             	sub    $0xc,%esp
8010350b:	50                   	push   %eax
8010350c:	e8 df d9 ff ff       	call   80100ef0 <fileclose>
80103511:	83 c4 10             	add    $0x10,%esp
}
80103514:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010351c:	5b                   	pop    %ebx
8010351d:	5e                   	pop    %esi
8010351e:	5f                   	pop    %edi
8010351f:	5d                   	pop    %ebp
80103520:	c3                   	ret    
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103528:	8b 03                	mov    (%ebx),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	75 c8                	jne    801034f6 <pipealloc+0xc6>
8010352e:	eb d2                	jmp    80103502 <pipealloc+0xd2>

80103530 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	56                   	push   %esi
80103534:	53                   	push   %ebx
80103535:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103538:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	53                   	push   %ebx
8010353f:	e8 fc 1a 00 00       	call   80105040 <acquire>
  if(writable){
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 f6                	test   %esi,%esi
80103549:	74 65                	je     801035b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103554:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010355b:	00 00 00 
    wakeup(&p->nread);
8010355e:	50                   	push   %eax
8010355f:	e8 8c 15 00 00       	call   80104af0 <wakeup>
80103564:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103567:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010356d:	85 d2                	test   %edx,%edx
8010356f:	75 0a                	jne    8010357b <pipeclose+0x4b>
80103571:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	74 15                	je     80103590 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010357b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010357e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103581:	5b                   	pop    %ebx
80103582:	5e                   	pop    %esi
80103583:	5d                   	pop    %ebp
    release(&p->lock);
80103584:	e9 57 1a 00 00       	jmp    80104fe0 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 47 1a 00 00       	call   80104fe0 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 16 ef ff ff       	jmp    801024c0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 27 15 00 00       	call   80104af0 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb 99                	jmp    80103567 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 28             	sub    $0x28,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035dc:	53                   	push   %ebx
801035dd:	e8 5e 1a 00 00       	call   80105040 <acquire>
  for(i = 0; i < n; i++){
801035e2:	8b 45 10             	mov    0x10(%ebp),%eax
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	85 c0                	test   %eax,%eax
801035ea:	0f 8e c0 00 00 00    	jle    801036b0 <pipewrite+0xe0>
801035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103602:	03 45 10             	add    0x10(%ebp),%eax
80103605:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103608:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103614:	89 ca                	mov    %ecx,%edx
80103616:	05 00 02 00 00       	add    $0x200,%eax
8010361b:	39 c1                	cmp    %eax,%ecx
8010361d:	74 3f                	je     8010365e <pipewrite+0x8e>
8010361f:	eb 67                	jmp    80103688 <pipewrite+0xb8>
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103628:	e8 c3 04 00 00       	call   80103af0 <myproc>
8010362d:	8b 48 30             	mov    0x30(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 b3 14 00 00       	call   80104af0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 ea 13 00 00       	call   80104a30 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103646:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103652:	83 c4 10             	add    $0x10,%esp
80103655:	05 00 02 00 00       	add    $0x200,%eax
8010365a:	39 c2                	cmp    %eax,%edx
8010365c:	75 2a                	jne    80103688 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010365e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c0                	jne    80103628 <pipewrite+0x58>
        release(&p->lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	53                   	push   %ebx
8010366c:	e8 6f 19 00 00       	call   80104fe0 <release>
        return -1;
80103671:	83 c4 10             	add    $0x10,%esp
80103674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103688:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010368b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010368e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103694:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010369a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010369d:	83 c6 01             	add    $0x1,%esi
801036a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036aa:	0f 85 58 ff ff ff    	jne    80103608 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036b9:	50                   	push   %eax
801036ba:	e8 31 14 00 00       	call   80104af0 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 19 19 00 00       	call   80104fe0 <release>
  return n;
801036c7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	eb aa                	jmp    80103679 <pipewrite+0xa9>
801036cf:	90                   	nop

801036d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 18             	sub    $0x18,%esp
801036d9:	8b 75 08             	mov    0x8(%ebp),%esi
801036dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036df:	56                   	push   %esi
801036e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036e6:	e8 55 19 00 00       	call   80105040 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 eb 03 00 00       	call   80103af0 <myproc>
80103705:	8b 48 30             	mov    0x30(%eax),%ecx
80103708:	85 c9                	test   %ecx,%ecx
8010370a:	0f 85 80 00 00 00    	jne    80103790 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 16 13 00 00       	call   80104a30 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103720:	83 c4 10             	add    $0x10,%esp
80103723:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103729:	75 0a                	jne    80103735 <piperead+0x65>
8010372b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103731:	85 c0                	test   %eax,%eax
80103733:	75 cb                	jne    80103700 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103735:	8b 55 10             	mov    0x10(%ebp),%edx
80103738:	31 db                	xor    %ebx,%ebx
8010373a:	85 d2                	test   %edx,%edx
8010373c:	7f 20                	jg     8010375e <piperead+0x8e>
8010373e:	eb 2c                	jmp    8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010374e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010375e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103764:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 75 13 00 00       	call   80104af0 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 5d 18 00 00       	call   80104fe0 <release>
  return i;
80103783:	83 c4 10             	add    $0x10,%esp
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret    
      release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103798:	56                   	push   %esi
80103799:	e8 42 18 00 00       	call   80104fe0 <release>
      return -1;
8010379e:	83 c4 10             	add    $0x10,%esp
}
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret    
801037ab:	66 90                	xchg   %ax,%ax
801037ad:	66 90                	xchg   %ax,%ax
801037af:	90                   	nop

801037b0 <allocproc>:
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 20 2d 11 80       	push   $0x80112d20
801037c1:	e8 7a 18 00 00       	call   80105040 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 17                	jmp    801037e2 <allocproc+0x32>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
801037d6:	81 fb 54 55 11 80    	cmp    $0x80115554,%ebx
801037dc:	0f 84 b6 00 00 00    	je     80103898 <allocproc+0xe8>
    if (p->state == UNUSED)
801037e2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037e5:	85 c0                	test   %eax,%eax
801037e7:	75 e7                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->que_id = LCFS;
  if(p->pid == 2)
    p->que_id = RR;
  p->priority = PRIORITY_DEF;
  p->priority_ratio = 1.0f;
801037ee:	d9 e8                	fld1   
  p->state = EMBRYO;
801037f0:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority_ratio = 1.0f;
801037f7:	d9 93 8c 00 00 00    	fsts   0x8c(%ebx)
    p->que_id = RR;
801037fd:	83 f8 02             	cmp    $0x2,%eax
  p->pid = nextpid++;
80103800:	8d 50 01             	lea    0x1(%eax),%edx
80103803:	89 43 10             	mov    %eax,0x10(%ebx)
    p->que_id = RR;
80103806:	0f 95 c0             	setne  %al
  p->creation_time_ratio = 1.0f;
80103809:	d9 93 90 00 00 00    	fsts   0x90(%ebx)
  p->executed_cycle = 0.1f;
  p->executed_cycle_ratio = 1.0f;
  p->process_size_ratio = 1.0f;
  release(&ptable.lock);
8010380f:	83 ec 0c             	sub    $0xc,%esp
    p->que_id = RR;
80103812:	0f b6 c0             	movzbl %al,%eax
  p->executed_cycle_ratio = 1.0f;
80103815:	d9 93 98 00 00 00    	fsts   0x98(%ebx)
    p->que_id = RR;
8010381b:	83 c0 01             	add    $0x1,%eax
  p->process_size_ratio = 1.0f;
8010381e:	d9 9b 9c 00 00 00    	fstps  0x9c(%ebx)
80103824:	89 43 28             	mov    %eax,0x28(%ebx)
  p->priority = PRIORITY_DEF;
80103827:	c7 83 88 00 00 00 03 	movl   $0x3,0x88(%ebx)
8010382e:	00 00 00 
  p->executed_cycle = 0.1f;
80103831:	c7 83 94 00 00 00 cd 	movl   $0x3dcccccd,0x94(%ebx)
80103838:	cc cc 3d 
  release(&ptable.lock);
8010383b:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103840:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103846:	e8 95 17 00 00       	call   80104fe0 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
8010384b:	e8 30 ee ff ff       	call   80102680 <kalloc>
80103850:	83 c4 10             	add    $0x10,%esp
80103853:	89 43 08             	mov    %eax,0x8(%ebx)
80103856:	85 c0                	test   %eax,%eax
80103858:	74 57                	je     801038b1 <allocproc+0x101>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010385a:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
80103860:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103863:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103868:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
8010386b:	c7 40 14 f4 68 10 80 	movl   $0x801068f4,0x14(%eax)
  p->context = (struct context *)sp;
80103872:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103875:	6a 14                	push   $0x14
80103877:	6a 00                	push   $0x0
80103879:	50                   	push   %eax
8010387a:	e8 81 18 00 00       	call   80105100 <memset>
  p->context->eip = (uint)forkret;
8010387f:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103882:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103885:	c7 40 10 d0 38 10 80 	movl   $0x801038d0,0x10(%eax)
}
8010388c:	89 d8                	mov    %ebx,%eax
8010388e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103891:	c9                   	leave  
80103892:	c3                   	ret    
80103893:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103897:	90                   	nop
  release(&ptable.lock);
80103898:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010389b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010389d:	68 20 2d 11 80       	push   $0x80112d20
801038a2:	e8 39 17 00 00       	call   80104fe0 <release>
}
801038a7:	89 d8                	mov    %ebx,%eax
  return 0;
801038a9:	83 c4 10             	add    $0x10,%esp
}
801038ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038af:	c9                   	leave  
801038b0:	c3                   	ret    
    p->state = UNUSED;
801038b1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038b8:	31 db                	xor    %ebx,%ebx
}
801038ba:	89 d8                	mov    %ebx,%eax
801038bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038bf:	c9                   	leave  
801038c0:	c3                   	ret    
801038c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038cf:	90                   	nop

801038d0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038d6:	68 20 2d 11 80       	push   $0x80112d20
801038db:	e8 00 17 00 00       	call   80104fe0 <release>

  if (first)
801038e0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038e5:	83 c4 10             	add    $0x10,%esp
801038e8:	85 c0                	test   %eax,%eax
801038ea:	75 04                	jne    801038f0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038ec:	c9                   	leave  
801038ed:	c3                   	ret    
801038ee:	66 90                	xchg   %ax,%ax
    first = 0;
801038f0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038f7:	00 00 00 
    iinit(ROOTDEV);
801038fa:	83 ec 0c             	sub    $0xc,%esp
801038fd:	6a 01                	push   $0x1
801038ff:	e8 5c dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103904:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010390b:	e8 b0 f3 ff ff       	call   80102cc0 <initlog>
}
80103910:	83 c4 10             	add    $0x10,%esp
80103913:	c9                   	leave  
80103914:	c3                   	ret    
80103915:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010391c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103920 <pinit>:
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103926:	68 80 87 10 80       	push   $0x80108780
8010392b:	68 20 2d 11 80       	push   $0x80112d20
80103930:	e8 3b 15 00 00       	call   80104e70 <initlock>
}
80103935:	83 c4 10             	add    $0x10,%esp
80103938:	c9                   	leave  
80103939:	c3                   	ret    
8010393a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103940 <calculate_rank>:
{
80103940:	55                   	push   %ebp
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80103941:	31 c9                	xor    %ecx,%ecx
{
80103943:	89 e5                	mov    %esp,%ebp
80103945:	83 ec 08             	sub    $0x8,%esp
80103948:	8b 45 08             	mov    0x8(%ebp),%eax
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
8010394b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010394e:	db 80 88 00 00 00    	fildl  0x88(%eax)
80103954:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
8010395a:	db 40 20             	fildl  0x20(%eax)
8010395d:	d8 88 90 00 00 00    	fmuls  0x90(%eax)
80103963:	8b 10                	mov    (%eax),%edx
80103965:	89 55 f8             	mov    %edx,-0x8(%ebp)
80103968:	de c1                	faddp  %st,%st(1)
8010396a:	d9 80 94 00 00 00    	flds   0x94(%eax)
80103970:	d8 88 98 00 00 00    	fmuls  0x98(%eax)
80103976:	de c1                	faddp  %st,%st(1)
80103978:	df 6d f8             	fildll -0x8(%ebp)
8010397b:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
}
80103981:	c9                   	leave  
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80103982:	de c1                	faddp  %st,%st(1)
}
80103984:	c3                   	ret    
80103985:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010398c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103990 <mycpu>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	56                   	push   %esi
80103994:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103995:	9c                   	pushf  
80103996:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103997:	f6 c4 02             	test   $0x2,%ah
8010399a:	75 46                	jne    801039e2 <mycpu+0x52>
  apicid = lapicid();
8010399c:	e8 4f ef ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i)
801039a1:	8b 35 84 27 11 80    	mov    0x80112784,%esi
801039a7:	85 f6                	test   %esi,%esi
801039a9:	7e 2a                	jle    801039d5 <mycpu+0x45>
801039ab:	31 d2                	xor    %edx,%edx
801039ad:	eb 08                	jmp    801039b7 <mycpu+0x27>
801039af:	90                   	nop
801039b0:	83 c2 01             	add    $0x1,%edx
801039b3:	39 f2                	cmp    %esi,%edx
801039b5:	74 1e                	je     801039d5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801039b7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039bd:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
801039c4:	39 c3                	cmp    %eax,%ebx
801039c6:	75 e8                	jne    801039b0 <mycpu+0x20>
}
801039c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039cb:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
801039d1:	5b                   	pop    %ebx
801039d2:	5e                   	pop    %esi
801039d3:	5d                   	pop    %ebp
801039d4:	c3                   	ret    
  panic("unknown apicid\n");
801039d5:	83 ec 0c             	sub    $0xc,%esp
801039d8:	68 87 87 10 80       	push   $0x80108787
801039dd:	e8 9e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
801039e2:	83 ec 0c             	sub    $0xc,%esp
801039e5:	68 e4 88 10 80       	push   $0x801088e4
801039ea:	e8 91 c9 ff ff       	call   80100380 <panic>
801039ef:	90                   	nop

801039f0 <cpuid>:
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
801039f6:	e8 95 ff ff ff       	call   80103990 <mycpu>
}
801039fb:	c9                   	leave  
  return mycpu() - cpus;
801039fc:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103a01:	c1 f8 04             	sar    $0x4,%eax
80103a04:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a0a:	c3                   	ret    
80103a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a0f:	90                   	nop

80103a10 <aging>:
  time = ticks;
80103a10:	8b 0d e0 57 11 80    	mov    0x801157e0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a16:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103a1b:	eb 0f                	jmp    80103a2c <aging+0x1c>
80103a1d:	8d 76 00             	lea    0x0(%esi),%esi
80103a20:	05 a0 00 00 00       	add    $0xa0,%eax
80103a25:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80103a2a:	74 2c                	je     80103a58 <aging+0x48>
    if (p->state == RUNNABLE && p->que_id != RR)
80103a2c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103a30:	75 ee                	jne    80103a20 <aging+0x10>
80103a32:	83 78 28 01          	cmpl   $0x1,0x28(%eax)
80103a36:	74 e8                	je     80103a20 <aging+0x10>
      if (time - p->preemption_time > AGING_THRS)
80103a38:	89 ca                	mov    %ecx,%edx
80103a3a:	2b 50 24             	sub    0x24(%eax),%edx
80103a3d:	81 fa 40 1f 00 00    	cmp    $0x1f40,%edx
80103a43:	7e db                	jle    80103a20 <aging+0x10>
        p->que_id = RR;
80103a45:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a4c:	05 a0 00 00 00       	add    $0xa0,%eax
80103a51:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80103a56:	75 d4                	jne    80103a2c <aging+0x1c>
}
80103a58:	c3                   	ret    
80103a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a60 <reset_bjf_attributes>:
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	83 ec 24             	sub    $0x24,%esp
80103a66:	d9 45 08             	flds   0x8(%ebp)
  acquire(&ptable.lock);
80103a69:	68 20 2d 11 80       	push   $0x80112d20
{
80103a6e:	d9 5d e8             	fstps  -0x18(%ebp)
80103a71:	d9 45 0c             	flds   0xc(%ebp)
80103a74:	d9 5d ec             	fstps  -0x14(%ebp)
80103a77:	d9 45 10             	flds   0x10(%ebp)
80103a7a:	d9 5d f0             	fstps  -0x10(%ebp)
80103a7d:	d9 45 14             	flds   0x14(%ebp)
80103a80:	d9 5d f4             	fstps  -0xc(%ebp)
  acquire(&ptable.lock);
80103a83:	e8 b8 15 00 00       	call   80105040 <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a88:	d9 45 e8             	flds   -0x18(%ebp)
80103a8b:	d9 45 ec             	flds   -0x14(%ebp)
  acquire(&ptable.lock);
80103a8e:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a91:	d9 45 f0             	flds   -0x10(%ebp)
80103a94:	d9 45 f4             	flds   -0xc(%ebp)
80103a97:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != UNUSED)
80103aa0:	8b 50 0c             	mov    0xc(%eax),%edx
80103aa3:	85 d2                	test   %edx,%edx
80103aa5:	74 28                	je     80103acf <reset_bjf_attributes+0x6f>
80103aa7:	d9 cb                	fxch   %st(3)
      p->priority_ratio = priority_ratio;
80103aa9:	d9 90 8c 00 00 00    	fsts   0x8c(%eax)
80103aaf:	d9 ca                	fxch   %st(2)
      p->creation_time_ratio = creation_time_ratio;
80103ab1:	d9 90 90 00 00 00    	fsts   0x90(%eax)
80103ab7:	d9 c9                	fxch   %st(1)
      p->executed_cycle_ratio = exec_cycle_ratio;
80103ab9:	d9 90 98 00 00 00    	fsts   0x98(%eax)
80103abf:	d9 cb                	fxch   %st(3)
      p->process_size_ratio = size_ratio;
80103ac1:	d9 90 9c 00 00 00    	fsts   0x9c(%eax)
80103ac7:	d9 c9                	fxch   %st(1)
80103ac9:	d9 ca                	fxch   %st(2)
80103acb:	d9 cb                	fxch   %st(3)
80103acd:	d9 c9                	fxch   %st(1)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103acf:	05 a0 00 00 00       	add    $0xa0,%eax
80103ad4:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80103ad9:	75 c5                	jne    80103aa0 <reset_bjf_attributes+0x40>
80103adb:	dd d8                	fstp   %st(0)
80103add:	dd d8                	fstp   %st(0)
80103adf:	dd d8                	fstp   %st(0)
80103ae1:	dd d8                	fstp   %st(0)
  release(&ptable.lock);
80103ae3:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103aea:	c9                   	leave  
  release(&ptable.lock);
80103aeb:	e9 f0 14 00 00       	jmp    80104fe0 <release>

80103af0 <myproc>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	53                   	push   %ebx
80103af4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103af7:	e8 f4 13 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
80103afc:	e8 8f fe ff ff       	call   80103990 <mycpu>
  p = c->proc;
80103b01:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b07:	e8 34 14 00 00       	call   80104f40 <popcli>
}
80103b0c:	89 d8                	mov    %ebx,%eax
80103b0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b11:	c9                   	leave  
80103b12:	c3                   	ret    
80103b13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b20 <how_many_digit>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	56                   	push   %esi
80103b24:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103b27:	53                   	push   %ebx
80103b28:	bb 01 00 00 00       	mov    $0x1,%ebx
  if (num == 0)
80103b2d:	85 c9                	test   %ecx,%ecx
80103b2f:	74 24                	je     80103b55 <how_many_digit+0x35>
  int count = 0;
80103b31:	31 db                	xor    %ebx,%ebx
    num /= 10;
80103b33:	be 67 66 66 66       	mov    $0x66666667,%esi
80103b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b3f:	90                   	nop
80103b40:	89 c8                	mov    %ecx,%eax
    count++;
80103b42:	83 c3 01             	add    $0x1,%ebx
    num /= 10;
80103b45:	f7 ee                	imul   %esi
80103b47:	89 c8                	mov    %ecx,%eax
80103b49:	c1 f8 1f             	sar    $0x1f,%eax
80103b4c:	c1 fa 02             	sar    $0x2,%edx
  while (num != 0)
80103b4f:	89 d1                	mov    %edx,%ecx
80103b51:	29 c1                	sub    %eax,%ecx
80103b53:	75 eb                	jne    80103b40 <how_many_digit+0x20>
}
80103b55:	89 d8                	mov    %ebx,%eax
80103b57:	5b                   	pop    %ebx
80103b58:	5e                   	pop    %esi
80103b59:	5d                   	pop    %ebp
80103b5a:	c3                   	ret    
80103b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b5f:	90                   	nop

80103b60 <userinit>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	53                   	push   %ebx
80103b64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b67:	e8 44 fc ff ff       	call   801037b0 <allocproc>
80103b6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b6e:	a3 c4 57 11 80       	mov    %eax,0x801157c4
  if ((p->pgdir = setupkvm()) == 0)
80103b73:	e8 78 43 00 00       	call   80107ef0 <setupkvm>
80103b78:	89 43 04             	mov    %eax,0x4(%ebx)
80103b7b:	85 c0                	test   %eax,%eax
80103b7d:	0f 84 c4 00 00 00    	je     80103c47 <userinit+0xe7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b83:	83 ec 04             	sub    $0x4,%esp
80103b86:	68 2c 00 00 00       	push   $0x2c
80103b8b:	68 60 b4 10 80       	push   $0x8010b460
80103b90:	50                   	push   %eax
80103b91:	e8 0a 40 00 00       	call   80107ba0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b9f:	6a 4c                	push   $0x4c
80103ba1:	6a 00                	push   $0x0
80103ba3:	ff 73 18             	push   0x18(%ebx)
80103ba6:	e8 55 15 00 00       	call   80105100 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bab:	8b 43 18             	mov    0x18(%ebx),%eax
80103bae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bb3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bb6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bbb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bbf:	8b 43 18             	mov    0x18(%ebx),%eax
80103bc2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bc6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bc9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bcd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bd1:	8b 43 18             	mov    0x18(%ebx),%eax
80103bd4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bd8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bdc:	8b 43 18             	mov    0x18(%ebx),%eax
80103bdf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103be6:	8b 43 18             	mov    0x18(%ebx),%eax
80103be9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103bf0:	8b 43 18             	mov    0x18(%ebx),%eax
80103bf3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bfa:	8d 43 78             	lea    0x78(%ebx),%eax
80103bfd:	6a 10                	push   $0x10
80103bff:	68 b0 87 10 80       	push   $0x801087b0
80103c04:	50                   	push   %eax
80103c05:	e8 b6 16 00 00       	call   801052c0 <safestrcpy>
  p->cwd = namei("/");
80103c0a:	c7 04 24 b9 87 10 80 	movl   $0x801087b9,(%esp)
80103c11:	e8 8a e4 ff ff       	call   801020a0 <namei>
80103c16:	89 43 74             	mov    %eax,0x74(%ebx)
  acquire(&ptable.lock);
80103c19:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c20:	e8 1b 14 00 00       	call   80105040 <acquire>
  p->state = RUNNABLE;
80103c25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->que_id = RR;
80103c2c:	c7 43 28 01 00 00 00 	movl   $0x1,0x28(%ebx)
  release(&ptable.lock);
80103c33:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c3a:	e8 a1 13 00 00       	call   80104fe0 <release>
}
80103c3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c42:	83 c4 10             	add    $0x10,%esp
80103c45:	c9                   	leave  
80103c46:	c3                   	ret    
    panic("userinit: out of memory?");
80103c47:	83 ec 0c             	sub    $0xc,%esp
80103c4a:	68 97 87 10 80       	push   $0x80108797
80103c4f:	e8 2c c7 ff ff       	call   80100380 <panic>
80103c54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c5f:	90                   	nop

80103c60 <print_name>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	57                   	push   %edi
80103c64:	56                   	push   %esi
  memset(buf, ' ', 12);
80103c65:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80103c68:	53                   	push   %ebx
  for (int i = 0; i < strlen(name); i++)
80103c69:	31 db                	xor    %ebx,%ebx
{
80103c6b:	83 ec 20             	sub    $0x20,%esp
80103c6e:	8b 75 08             	mov    0x8(%ebp),%esi
  memset(buf, ' ', 12);
80103c71:	6a 0c                	push   $0xc
80103c73:	6a 20                	push   $0x20
80103c75:	57                   	push   %edi
80103c76:	e8 85 14 00 00       	call   80105100 <memset>
  buf[13] = 0;
80103c7b:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for (int i = 0; i < strlen(name); i++)
80103c7f:	83 c4 10             	add    $0x10,%esp
80103c82:	eb 0e                	jmp    80103c92 <print_name+0x32>
80103c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i] = name[i];
80103c88:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80103c8c:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for (int i = 0; i < strlen(name); i++)
80103c8f:	83 c3 01             	add    $0x1,%ebx
80103c92:	83 ec 0c             	sub    $0xc,%esp
80103c95:	56                   	push   %esi
80103c96:	e8 65 16 00 00       	call   80105300 <strlen>
80103c9b:	83 c4 10             	add    $0x10,%esp
80103c9e:	39 d8                	cmp    %ebx,%eax
80103ca0:	7f e6                	jg     80103c88 <print_name+0x28>
  cprintf("%s", buf);
80103ca2:	83 ec 08             	sub    $0x8,%esp
80103ca5:	57                   	push   %edi
80103ca6:	68 ae 88 10 80       	push   $0x801088ae
80103cab:	e8 f0 c9 ff ff       	call   801006a0 <cprintf>
}
80103cb0:	83 c4 10             	add    $0x10,%esp
80103cb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cb6:	5b                   	pop    %ebx
80103cb7:	5e                   	pop    %esi
80103cb8:	5f                   	pop    %edi
80103cb9:	5d                   	pop    %ebp
80103cba:	c3                   	ret    
80103cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cbf:	90                   	nop

80103cc0 <find_proc>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	56                   	push   %esi
80103cc4:	53                   	push   %ebx
80103cc5:	8b 75 08             	mov    0x8(%ebp),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cc8:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  acquire(&ptable.lock);
80103ccd:	83 ec 0c             	sub    $0xc,%esp
80103cd0:	68 20 2d 11 80       	push   $0x80112d20
80103cd5:	e8 66 13 00 00       	call   80105040 <acquire>
80103cda:	83 c4 10             	add    $0x10,%esp
80103cdd:	eb 0f                	jmp    80103cee <find_proc+0x2e>
80103cdf:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ce0:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103ce6:	81 fb 54 55 11 80    	cmp    $0x80115554,%ebx
80103cec:	74 05                	je     80103cf3 <find_proc+0x33>
    if (p->pid == pid)
80103cee:	39 73 10             	cmp    %esi,0x10(%ebx)
80103cf1:	75 ed                	jne    80103ce0 <find_proc+0x20>
  release(&ptable.lock);
80103cf3:	83 ec 0c             	sub    $0xc,%esp
80103cf6:	68 20 2d 11 80       	push   $0x80112d20
80103cfb:	e8 e0 12 00 00       	call   80104fe0 <release>
}
80103d00:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d03:	89 d8                	mov    %ebx,%eax
80103d05:	5b                   	pop    %ebx
80103d06:	5e                   	pop    %esi
80103d07:	5d                   	pop    %ebp
80103d08:	c3                   	ret    
80103d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d10 <print_state>:
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	8b 45 08             	mov    0x8(%ebp),%eax
  switch (state)
80103d16:	83 f8 05             	cmp    $0x5,%eax
80103d19:	77 6a                	ja     80103d85 <print_state+0x75>
80103d1b:	ff 24 85 60 89 10 80 	jmp    *-0x7fef76a0(,%eax,4)
80103d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("RUNNING   ");
80103d28:	c7 45 08 e7 87 10 80 	movl   $0x801087e7,0x8(%ebp)
}
80103d2f:	5d                   	pop    %ebp
    cprintf("RUNNING   ");
80103d30:	e9 6b c9 ff ff       	jmp    801006a0 <cprintf>
80103d35:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("ZOMBIE    ");
80103d38:	c7 45 08 f2 87 10 80 	movl   $0x801087f2,0x8(%ebp)
}
80103d3f:	5d                   	pop    %ebp
    cprintf("ZOMBIE    ");
80103d40:	e9 5b c9 ff ff       	jmp    801006a0 <cprintf>
80103d45:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("UNUSED    ");
80103d48:	c7 45 08 bb 87 10 80 	movl   $0x801087bb,0x8(%ebp)
}
80103d4f:	5d                   	pop    %ebp
    cprintf("UNUSED    ");
80103d50:	e9 4b c9 ff ff       	jmp    801006a0 <cprintf>
80103d55:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("EMBRYO    ");
80103d58:	c7 45 08 c6 87 10 80 	movl   $0x801087c6,0x8(%ebp)
}
80103d5f:	5d                   	pop    %ebp
    cprintf("EMBRYO    ");
80103d60:	e9 3b c9 ff ff       	jmp    801006a0 <cprintf>
80103d65:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("SLEEPING  ");
80103d68:	c7 45 08 d1 87 10 80 	movl   $0x801087d1,0x8(%ebp)
}
80103d6f:	5d                   	pop    %ebp
    cprintf("SLEEPING  ");
80103d70:	e9 2b c9 ff ff       	jmp    801006a0 <cprintf>
80103d75:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("RUNNABLE  ");
80103d78:	c7 45 08 dc 87 10 80 	movl   $0x801087dc,0x8(%ebp)
}
80103d7f:	5d                   	pop    %ebp
    cprintf("RUNNABLE  ");
80103d80:	e9 1b c9 ff ff       	jmp    801006a0 <cprintf>
    cprintf("damn ways to die");
80103d85:	c7 45 08 fd 87 10 80 	movl   $0x801087fd,0x8(%ebp)
}
80103d8c:	5d                   	pop    %ebp
    cprintf("damn ways to die");
80103d8d:	e9 0e c9 ff ff       	jmp    801006a0 <cprintf>
80103d92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103da0 <print_space>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	56                   	push   %esi
80103da4:	8b 75 08             	mov    0x8(%ebp),%esi
80103da7:	53                   	push   %ebx
  for (int i = 0; i < num; i++)
80103da8:	85 f6                	test   %esi,%esi
80103daa:	7e 1b                	jle    80103dc7 <print_space+0x27>
80103dac:	31 db                	xor    %ebx,%ebx
80103dae:	66 90                	xchg   %ax,%ax
    cprintf(" ");
80103db0:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < num; i++)
80103db3:	83 c3 01             	add    $0x1,%ebx
    cprintf(" ");
80103db6:	68 23 88 10 80       	push   $0x80108823
80103dbb:	e8 e0 c8 ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < num; i++)
80103dc0:	83 c4 10             	add    $0x10,%esp
80103dc3:	39 de                	cmp    %ebx,%esi
80103dc5:	75 e9                	jne    80103db0 <print_space+0x10>
}
80103dc7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103dca:	5b                   	pop    %ebx
80103dcb:	5e                   	pop    %esi
80103dcc:	5d                   	pop    %ebp
80103dcd:	c3                   	ret    
80103dce:	66 90                	xchg   %ax,%ax

80103dd0 <print_bitches>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	57                   	push   %edi
80103dd4:	56                   	push   %esi
80103dd5:	53                   	push   %ebx
  cprintf("process_name PID State   Queue Cycle Arrival Priority R_prty R_Arvl R_exec Rank\n");
80103dd6:	bb 50 00 00 00       	mov    $0x50,%ebx
{
80103ddb:	83 ec 28             	sub    $0x28,%esp
  acquire(&ptable.lock);
80103dde:	68 20 2d 11 80       	push   $0x80112d20
80103de3:	e8 58 12 00 00       	call   80105040 <acquire>
  cprintf("process_name PID State   Queue Cycle Arrival Priority R_prty R_Arvl R_exec Rank\n");
80103de8:	c7 04 24 0c 89 10 80 	movl   $0x8010890c,(%esp)
80103def:	e8 ac c8 ff ff       	call   801006a0 <cprintf>
80103df4:	83 c4 10             	add    $0x10,%esp
80103df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dfe:	66 90                	xchg   %ax,%ax
    cprintf("-");
80103e00:	83 ec 0c             	sub    $0xc,%esp
80103e03:	68 0e 88 10 80       	push   $0x8010880e
80103e08:	e8 93 c8 ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < 80; i++)
80103e0d:	83 c4 10             	add    $0x10,%esp
80103e10:	83 eb 01             	sub    $0x1,%ebx
80103e13:	75 eb                	jne    80103e00 <print_bitches+0x30>
  cprintf("\n");
80103e15:	83 ec 0c             	sub    $0xc,%esp
80103e18:	bb cc 2d 11 80       	mov    $0x80112dcc,%ebx
    num /= 10;
80103e1d:	be 67 66 66 66       	mov    $0x66666667,%esi
  cprintf("\n");
80103e22:	68 f3 8c 10 80       	push   $0x80108cf3
80103e27:	e8 74 c8 ff ff       	call   801006a0 <cprintf>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e2c:	83 c4 10             	add    $0x10,%esp
80103e2f:	eb 19                	jmp    80103e4a <print_bitches+0x7a>
80103e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e38:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103e3e:	81 fb cc 55 11 80    	cmp    $0x801155cc,%ebx
80103e44:	0f 84 9d 02 00 00    	je     801040e7 <print_bitches+0x317>
    if (p->state == UNUSED)
80103e4a:	8b 4b 94             	mov    -0x6c(%ebx),%ecx
80103e4d:	85 c9                	test   %ecx,%ecx
80103e4f:	74 e7                	je     80103e38 <print_bitches+0x68>
    print_name(p->name);
80103e51:	83 ec 0c             	sub    $0xc,%esp
80103e54:	53                   	push   %ebx
80103e55:	e8 06 fe ff ff       	call   80103c60 <print_name>
    cprintf("%d", p->pid);
80103e5a:	58                   	pop    %eax
80103e5b:	5a                   	pop    %edx
80103e5c:	ff 73 98             	push   -0x68(%ebx)
80103e5f:	68 10 88 10 80       	push   $0x80108810
80103e64:	e8 37 c8 ff ff       	call   801006a0 <cprintf>
    print_space(4-(how_many_digit(p->pid)));
80103e69:	8b 7b 98             	mov    -0x68(%ebx),%edi
  if (num == 0)
80103e6c:	83 c4 10             	add    $0x10,%esp
80103e6f:	85 ff                	test   %edi,%edi
80103e71:	0f 84 a9 02 00 00    	je     80104120 <print_bitches+0x350>
  int count = 0;
80103e77:	31 c9                	xor    %ecx,%ecx
80103e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    num /= 10;
80103e80:	89 f8                	mov    %edi,%eax
    count++;
80103e82:	83 c1 01             	add    $0x1,%ecx
    num /= 10;
80103e85:	f7 ee                	imul   %esi
80103e87:	89 f8                	mov    %edi,%eax
80103e89:	c1 f8 1f             	sar    $0x1f,%eax
80103e8c:	c1 fa 02             	sar    $0x2,%edx
  while (num != 0)
80103e8f:	29 c2                	sub    %eax,%edx
80103e91:	89 d7                	mov    %edx,%edi
80103e93:	75 eb                	jne    80103e80 <print_bitches+0xb0>
    print_space(4-(how_many_digit(p->pid)));
80103e95:	bf 04 00 00 00       	mov    $0x4,%edi
80103e9a:	29 cf                	sub    %ecx,%edi
80103e9c:	89 7d d8             	mov    %edi,-0x28(%ebp)
  for (int i = 0; i < num; i++)
80103e9f:	85 ff                	test   %edi,%edi
80103ea1:	7e 1d                	jle    80103ec0 <print_bitches+0xf0>
    print_space(4-(how_many_digit(p->pid)));
80103ea3:	31 ff                	xor    %edi,%edi
80103ea5:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf(" ");
80103ea8:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < num; i++)
80103eab:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80103eae:	68 23 88 10 80       	push   $0x80108823
80103eb3:	e8 e8 c7 ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < num; i++)
80103eb8:	83 c4 10             	add    $0x10,%esp
80103ebb:	39 7d d8             	cmp    %edi,-0x28(%ebp)
80103ebe:	7f e8                	jg     80103ea8 <print_bitches+0xd8>
    print_state((*p).state);
80103ec0:	83 ec 0c             	sub    $0xc,%esp
80103ec3:	ff 73 94             	push   -0x6c(%ebx)
80103ec6:	e8 45 fe ff ff       	call   80103d10 <print_state>
    cprintf("%d     ", p->que_id);
80103ecb:	58                   	pop    %eax
80103ecc:	5a                   	pop    %edx
80103ecd:	ff 73 b0             	push   -0x50(%ebx)
80103ed0:	68 13 88 10 80       	push   $0x80108813
80103ed5:	e8 c6 c7 ff ff       	call   801006a0 <cprintf>
    cprintf("%d", (int)p->executed_cycle);
80103eda:	d9 43 1c             	flds   0x1c(%ebx)
80103edd:	59                   	pop    %ecx
80103ede:	d9 7d e6             	fnstcw -0x1a(%ebp)
80103ee1:	5f                   	pop    %edi
80103ee2:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80103ee6:	80 cc 0c             	or     $0xc,%ah
80103ee9:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80103eed:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103ef0:	db 5d d8             	fistpl -0x28(%ebp)
80103ef3:	d9 6d e6             	fldcw  -0x1a(%ebp)
80103ef6:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103ef9:	50                   	push   %eax
80103efa:	68 10 88 10 80       	push   $0x80108810
80103eff:	e8 9c c7 ff ff       	call   801006a0 <cprintf>
    print_space(5-how_many_digit((int)p->executed_cycle));
80103f04:	d9 43 1c             	flds   0x1c(%ebx)
  if (num == 0)
80103f07:	83 c4 10             	add    $0x10,%esp
    print_space(5-how_many_digit((int)p->executed_cycle));
80103f0a:	d9 7d e6             	fnstcw -0x1a(%ebp)
80103f0d:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80103f11:	80 cc 0c             	or     $0xc,%ah
80103f14:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80103f18:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103f1b:	db 5d d8             	fistpl -0x28(%ebp)
80103f1e:	d9 6d e6             	fldcw  -0x1a(%ebp)
80103f21:	8b 7d d8             	mov    -0x28(%ebp),%edi
  if (num == 0)
80103f24:	85 ff                	test   %edi,%edi
80103f26:	0f 84 e4 01 00 00    	je     80104110 <print_bitches+0x340>
  int count = 0;
80103f2c:	31 c9                	xor    %ecx,%ecx
80103f2e:	66 90                	xchg   %ax,%ax
    num /= 10;
80103f30:	89 f8                	mov    %edi,%eax
    count++;
80103f32:	83 c1 01             	add    $0x1,%ecx
    num /= 10;
80103f35:	f7 ee                	imul   %esi
80103f37:	89 f8                	mov    %edi,%eax
80103f39:	c1 f8 1f             	sar    $0x1f,%eax
80103f3c:	c1 fa 02             	sar    $0x2,%edx
  while (num != 0)
80103f3f:	29 c2                	sub    %eax,%edx
80103f41:	89 d7                	mov    %edx,%edi
80103f43:	75 eb                	jne    80103f30 <print_bitches+0x160>
    print_space(5-how_many_digit((int)p->executed_cycle));
80103f45:	bf 05 00 00 00       	mov    $0x5,%edi
80103f4a:	29 cf                	sub    %ecx,%edi
80103f4c:	89 7d d8             	mov    %edi,-0x28(%ebp)
  for (int i = 0; i < num; i++)
80103f4f:	85 ff                	test   %edi,%edi
80103f51:	7e 1d                	jle    80103f70 <print_bitches+0x1a0>
    print_space(5-how_many_digit((int)p->executed_cycle));
80103f53:	31 ff                	xor    %edi,%edi
80103f55:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf(" ");
80103f58:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < num; i++)
80103f5b:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80103f5e:	68 23 88 10 80       	push   $0x80108823
80103f63:	e8 38 c7 ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < num; i++)
80103f68:	83 c4 10             	add    $0x10,%esp
80103f6b:	3b 7d d8             	cmp    -0x28(%ebp),%edi
80103f6e:	7c e8                	jl     80103f58 <print_bitches+0x188>
    cprintf("%d", p->creation_time);
80103f70:	83 ec 08             	sub    $0x8,%esp
80103f73:	ff 73 a8             	push   -0x58(%ebx)
80103f76:	68 10 88 10 80       	push   $0x80108810
80103f7b:	e8 20 c7 ff ff       	call   801006a0 <cprintf>
    print_space(10 - how_many_digit(p->creation_time));
80103f80:	8b 7b a8             	mov    -0x58(%ebx),%edi
  if (num == 0)
80103f83:	83 c4 10             	add    $0x10,%esp
80103f86:	85 ff                	test   %edi,%edi
80103f88:	0f 84 72 01 00 00    	je     80104100 <print_bitches+0x330>
  int count = 0;
80103f8e:	31 c9                	xor    %ecx,%ecx
    num /= 10;
80103f90:	89 f8                	mov    %edi,%eax
    count++;
80103f92:	83 c1 01             	add    $0x1,%ecx
    num /= 10;
80103f95:	f7 ee                	imul   %esi
80103f97:	89 f8                	mov    %edi,%eax
80103f99:	c1 f8 1f             	sar    $0x1f,%eax
80103f9c:	c1 fa 02             	sar    $0x2,%edx
  while (num != 0)
80103f9f:	29 c2                	sub    %eax,%edx
80103fa1:	89 d7                	mov    %edx,%edi
80103fa3:	75 eb                	jne    80103f90 <print_bitches+0x1c0>
    print_space(10 - how_many_digit(p->creation_time));
80103fa5:	bf 0a 00 00 00       	mov    $0xa,%edi
80103faa:	29 cf                	sub    %ecx,%edi
80103fac:	89 7d d8             	mov    %edi,-0x28(%ebp)
  for (int i = 0; i < num; i++)
80103faf:	85 ff                	test   %edi,%edi
80103fb1:	7e 1d                	jle    80103fd0 <print_bitches+0x200>
    print_space(10 - how_many_digit(p->creation_time));
80103fb3:	31 ff                	xor    %edi,%edi
80103fb5:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf(" ");
80103fb8:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < num; i++)
80103fbb:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80103fbe:	68 23 88 10 80       	push   $0x80108823
80103fc3:	e8 d8 c6 ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < num; i++)
80103fc8:	83 c4 10             	add    $0x10,%esp
80103fcb:	3b 7d d8             	cmp    -0x28(%ebp),%edi
80103fce:	7c e8                	jl     80103fb8 <print_bitches+0x1e8>
    cprintf("%d       ", p->priority);
80103fd0:	83 ec 08             	sub    $0x8,%esp
80103fd3:	ff 73 10             	push   0x10(%ebx)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fd6:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
    cprintf("%d       ", p->priority);
80103fdc:	68 1b 88 10 80       	push   $0x8010881b
80103fe1:	e8 ba c6 ff ff       	call   801006a0 <cprintf>
    cprintf("%d     ", (int)p->priority_ratio);
80103fe6:	d9 83 74 ff ff ff    	flds   -0x8c(%ebx)
80103fec:	58                   	pop    %eax
80103fed:	d9 7d e6             	fnstcw -0x1a(%ebp)
80103ff0:	5a                   	pop    %edx
80103ff1:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80103ff5:	80 cc 0c             	or     $0xc,%ah
80103ff8:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80103ffc:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103fff:	db 5d d8             	fistpl -0x28(%ebp)
80104002:	d9 6d e6             	fldcw  -0x1a(%ebp)
80104005:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104008:	50                   	push   %eax
80104009:	68 13 88 10 80       	push   $0x80108813
8010400e:	e8 8d c6 ff ff       	call   801006a0 <cprintf>
    cprintf("%d      ", (int)p->creation_time_ratio);
80104013:	d9 83 78 ff ff ff    	flds   -0x88(%ebx)
80104019:	59                   	pop    %ecx
8010401a:	d9 7d e6             	fnstcw -0x1a(%ebp)
8010401d:	5f                   	pop    %edi
8010401e:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80104022:	80 cc 0c             	or     $0xc,%ah
80104025:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80104029:	d9 6d e4             	fldcw  -0x1c(%ebp)
8010402c:	db 5d d8             	fistpl -0x28(%ebp)
8010402f:	d9 6d e6             	fldcw  -0x1a(%ebp)
80104032:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104035:	50                   	push   %eax
80104036:	68 25 88 10 80       	push   $0x80108825
8010403b:	e8 60 c6 ff ff       	call   801006a0 <cprintf>
    cprintf("%d   ", (int)p->executed_cycle_ratio);
80104040:	d9 43 80             	flds   -0x80(%ebx)
80104043:	58                   	pop    %eax
80104044:	d9 7d e6             	fnstcw -0x1a(%ebp)
80104047:	5a                   	pop    %edx
80104048:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
8010404c:	80 cc 0c             	or     $0xc,%ah
8010404f:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80104053:	d9 6d e4             	fldcw  -0x1c(%ebp)
80104056:	db 5d d8             	fistpl -0x28(%ebp)
80104059:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010405c:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010405f:	50                   	push   %eax
80104060:	68 2e 88 10 80       	push   $0x8010882e
80104065:	e8 36 c6 ff ff       	call   801006a0 <cprintf>
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
8010406a:	db 83 70 ff ff ff    	fildl  -0x90(%ebx)
80104070:	31 d2                	xor    %edx,%edx
    cprintf("%d", (int)rank);
80104072:	59                   	pop    %ecx
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80104073:	d8 8b 74 ff ff ff    	fmuls  -0x8c(%ebx)
80104079:	db 83 08 ff ff ff    	fildl  -0xf8(%ebx)
8010407f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80104082:	d8 8b 78 ff ff ff    	fmuls  -0x88(%ebx)
80104088:	8b 83 e8 fe ff ff    	mov    -0x118(%ebx),%eax
    cprintf("%d", (int)rank);
8010408e:	5f                   	pop    %edi
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
8010408f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104092:	de c1                	faddp  %st,%st(1)
80104094:	d9 83 7c ff ff ff    	flds   -0x84(%ebx)
8010409a:	d8 4b 80             	fmuls  -0x80(%ebx)
8010409d:	de c1                	faddp  %st,%st(1)
8010409f:	df 6d d8             	fildll -0x28(%ebp)
801040a2:	d8 4b 84             	fmuls  -0x7c(%ebx)
    cprintf("%d", (int)rank);
801040a5:	d9 7d e6             	fnstcw -0x1a(%ebp)
801040a8:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
801040ac:	de c1                	faddp  %st,%st(1)
    cprintf("%d", (int)rank);
801040ae:	80 cc 0c             	or     $0xc,%ah
801040b1:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
801040b5:	d9 6d e4             	fldcw  -0x1c(%ebp)
801040b8:	db 5d d8             	fistpl -0x28(%ebp)
801040bb:	d9 6d e6             	fldcw  -0x1a(%ebp)
801040be:	8b 45 d8             	mov    -0x28(%ebp),%eax
801040c1:	50                   	push   %eax
801040c2:	68 10 88 10 80       	push   $0x80108810
801040c7:	e8 d4 c5 ff ff       	call   801006a0 <cprintf>
    cprintf("\n");
801040cc:	c7 04 24 f3 8c 10 80 	movl   $0x80108cf3,(%esp)
801040d3:	e8 c8 c5 ff ff       	call   801006a0 <cprintf>
801040d8:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040db:	81 fb cc 55 11 80    	cmp    $0x801155cc,%ebx
801040e1:	0f 85 63 fd ff ff    	jne    80103e4a <print_bitches+0x7a>
  release(&ptable.lock);
801040e7:	83 ec 0c             	sub    $0xc,%esp
801040ea:	68 20 2d 11 80       	push   $0x80112d20
801040ef:	e8 ec 0e 00 00       	call   80104fe0 <release>
}
801040f4:	83 c4 10             	add    $0x10,%esp
801040f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040fa:	5b                   	pop    %ebx
801040fb:	5e                   	pop    %esi
801040fc:	5f                   	pop    %edi
801040fd:	5d                   	pop    %ebp
801040fe:	c3                   	ret    
801040ff:	90                   	nop
    print_space(10 - how_many_digit(p->creation_time));
80104100:	c7 45 d8 09 00 00 00 	movl   $0x9,-0x28(%ebp)
80104107:	e9 a7 fe ff ff       	jmp    80103fb3 <print_bitches+0x1e3>
8010410c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    print_space(5-how_many_digit((int)p->executed_cycle));
80104110:	c7 45 d8 04 00 00 00 	movl   $0x4,-0x28(%ebp)
80104117:	e9 37 fe ff ff       	jmp    80103f53 <print_bitches+0x183>
8010411c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    print_space(4-(how_many_digit(p->pid)));
80104120:	c7 45 d8 03 00 00 00 	movl   $0x3,-0x28(%ebp)
80104127:	e9 77 fd ff ff       	jmp    80103ea3 <print_bitches+0xd3>
8010412c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104130 <count_child>:
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
  int count = 0;
80104134:	31 db                	xor    %ebx,%ebx
{
80104136:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104139:	68 20 2d 11 80       	push   $0x80112d20
8010413e:	e8 fd 0e 00 00       	call   80105040 <acquire>
    if (p->parent->pid == father->pid)
80104143:	8b 45 08             	mov    0x8(%ebp),%eax
80104146:	83 c4 10             	add    $0x10,%esp
80104149:	8b 48 10             	mov    0x10(%eax),%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010414c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p->parent->pid == father->pid)
80104158:	8b 50 14             	mov    0x14(%eax),%edx
      count++;
8010415b:	39 4a 10             	cmp    %ecx,0x10(%edx)
8010415e:	0f 94 c2             	sete   %dl
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104161:	05 a0 00 00 00       	add    $0xa0,%eax
      count++;
80104166:	0f b6 d2             	movzbl %dl,%edx
80104169:	01 d3                	add    %edx,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010416b:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104170:	75 e6                	jne    80104158 <count_child+0x28>
  release(&ptable.lock);
80104172:	83 ec 0c             	sub    $0xc,%esp
80104175:	68 20 2d 11 80       	push   $0x80112d20
8010417a:	e8 61 0e 00 00       	call   80104fe0 <release>
}
8010417f:	89 d8                	mov    %ebx,%eax
80104181:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104184:	c9                   	leave  
80104185:	c3                   	ret    
80104186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010418d:	8d 76 00             	lea    0x0(%esi),%esi

80104190 <growproc>:
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	56                   	push   %esi
80104194:	53                   	push   %ebx
80104195:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104198:	e8 53 0d 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
8010419d:	e8 ee f7 ff ff       	call   80103990 <mycpu>
  p = c->proc;
801041a2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041a8:	e8 93 0d 00 00       	call   80104f40 <popcli>
  sz = curproc->sz;
801041ad:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
801041af:	85 f6                	test   %esi,%esi
801041b1:	7f 1d                	jg     801041d0 <growproc+0x40>
  else if (n < 0)
801041b3:	75 3b                	jne    801041f0 <growproc+0x60>
  switchuvm(curproc);
801041b5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801041b8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801041ba:	53                   	push   %ebx
801041bb:	e8 d0 38 00 00       	call   80107a90 <switchuvm>
  return 0;
801041c0:	83 c4 10             	add    $0x10,%esp
801041c3:	31 c0                	xor    %eax,%eax
}
801041c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041c8:	5b                   	pop    %ebx
801041c9:	5e                   	pop    %esi
801041ca:	5d                   	pop    %ebp
801041cb:	c3                   	ret    
801041cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801041d0:	83 ec 04             	sub    $0x4,%esp
801041d3:	01 c6                	add    %eax,%esi
801041d5:	56                   	push   %esi
801041d6:	50                   	push   %eax
801041d7:	ff 73 04             	push   0x4(%ebx)
801041da:	e8 31 3b 00 00       	call   80107d10 <allocuvm>
801041df:	83 c4 10             	add    $0x10,%esp
801041e2:	85 c0                	test   %eax,%eax
801041e4:	75 cf                	jne    801041b5 <growproc+0x25>
      return -1;
801041e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041eb:	eb d8                	jmp    801041c5 <growproc+0x35>
801041ed:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801041f0:	83 ec 04             	sub    $0x4,%esp
801041f3:	01 c6                	add    %eax,%esi
801041f5:	56                   	push   %esi
801041f6:	50                   	push   %eax
801041f7:	ff 73 04             	push   0x4(%ebx)
801041fa:	e8 41 3c 00 00       	call   80107e40 <deallocuvm>
801041ff:	83 c4 10             	add    $0x10,%esp
80104202:	85 c0                	test   %eax,%eax
80104204:	75 af                	jne    801041b5 <growproc+0x25>
80104206:	eb de                	jmp    801041e6 <growproc+0x56>
80104208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420f:	90                   	nop

80104210 <fork>:
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	57                   	push   %edi
80104214:	56                   	push   %esi
80104215:	53                   	push   %ebx
80104216:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104219:	e8 d2 0c 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
8010421e:	e8 6d f7 ff ff       	call   80103990 <mycpu>
  p = c->proc;
80104223:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104229:	e8 12 0d 00 00       	call   80104f40 <popcli>
  if ((np = allocproc()) == 0)
8010422e:	e8 7d f5 ff ff       	call   801037b0 <allocproc>
80104233:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104236:	85 c0                	test   %eax,%eax
80104238:	0f 84 da 00 00 00    	je     80104318 <fork+0x108>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
8010423e:	83 ec 08             	sub    $0x8,%esp
80104241:	ff 33                	push   (%ebx)
80104243:	89 c7                	mov    %eax,%edi
80104245:	ff 73 04             	push   0x4(%ebx)
80104248:	e8 93 3d 00 00       	call   80107fe0 <copyuvm>
8010424d:	83 c4 10             	add    $0x10,%esp
80104250:	89 47 04             	mov    %eax,0x4(%edi)
80104253:	85 c0                	test   %eax,%eax
80104255:	0f 84 c4 00 00 00    	je     8010431f <fork+0x10f>
  np->sz = curproc->sz;
8010425b:	8b 03                	mov    (%ebx),%eax
8010425d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104260:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104262:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104265:	89 c8                	mov    %ecx,%eax
80104267:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010426a:	b9 13 00 00 00       	mov    $0x13,%ecx
8010426f:	8b 73 18             	mov    0x18(%ebx),%esi
80104272:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80104274:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104276:	8b 40 18             	mov    0x18(%eax),%eax
80104279:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if (curproc->ofile[i])
80104280:	8b 44 b3 34          	mov    0x34(%ebx,%esi,4),%eax
80104284:	85 c0                	test   %eax,%eax
80104286:	74 13                	je     8010429b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104288:	83 ec 0c             	sub    $0xc,%esp
8010428b:	50                   	push   %eax
8010428c:	e8 0f cc ff ff       	call   80100ea0 <filedup>
80104291:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104294:	83 c4 10             	add    $0x10,%esp
80104297:	89 44 b2 34          	mov    %eax,0x34(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
8010429b:	83 c6 01             	add    $0x1,%esi
8010429e:	83 fe 10             	cmp    $0x10,%esi
801042a1:	75 dd                	jne    80104280 <fork+0x70>
  np->cwd = idup(curproc->cwd);
801042a3:	83 ec 0c             	sub    $0xc,%esp
801042a6:	ff 73 74             	push   0x74(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042a9:	83 c3 78             	add    $0x78,%ebx
  np->cwd = idup(curproc->cwd);
801042ac:	e8 9f d4 ff ff       	call   80101750 <idup>
801042b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042b4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801042b7:	89 47 74             	mov    %eax,0x74(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042ba:	8d 47 78             	lea    0x78(%edi),%eax
801042bd:	6a 10                	push   $0x10
801042bf:	53                   	push   %ebx
801042c0:	50                   	push   %eax
801042c1:	e8 fa 0f 00 00       	call   801052c0 <safestrcpy>
  pid = np->pid;
801042c6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801042c9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801042d0:	e8 6b 0d 00 00       	call   80105040 <acquire>
  np->state = RUNNABLE;
801042d5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  acquire(&tickslock);
801042dc:	c7 04 24 00 58 11 80 	movl   $0x80115800,(%esp)
801042e3:	e8 58 0d 00 00       	call   80105040 <acquire>
  np->creation_time = ticks;
801042e8:	a1 e0 57 11 80       	mov    0x801157e0,%eax
801042ed:	89 47 20             	mov    %eax,0x20(%edi)
  np->preemption_time = ticks;
801042f0:	89 47 24             	mov    %eax,0x24(%edi)
  release(&tickslock);
801042f3:	c7 04 24 00 58 11 80 	movl   $0x80115800,(%esp)
801042fa:	e8 e1 0c 00 00       	call   80104fe0 <release>
  release(&ptable.lock);
801042ff:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104306:	e8 d5 0c 00 00       	call   80104fe0 <release>
  return pid;
8010430b:	83 c4 10             	add    $0x10,%esp
}
8010430e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104311:	89 d8                	mov    %ebx,%eax
80104313:	5b                   	pop    %ebx
80104314:	5e                   	pop    %esi
80104315:	5f                   	pop    %edi
80104316:	5d                   	pop    %ebp
80104317:	c3                   	ret    
    return -1;
80104318:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010431d:	eb ef                	jmp    8010430e <fork+0xfe>
    kfree(np->kstack);
8010431f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104322:	83 ec 0c             	sub    $0xc,%esp
80104325:	ff 73 08             	push   0x8(%ebx)
80104328:	e8 93 e1 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
8010432d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104334:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104337:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
8010433e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104343:	eb c9                	jmp    8010430e <fork+0xfe>
80104345:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010434c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104350 <round_robin>:
{
80104350:	55                   	push   %ebp
  int max_diff = MIN_INT;
80104351:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104356:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
{
8010435b:	89 e5                	mov    %esp,%ebp
8010435d:	56                   	push   %esi
  struct proc *res = 0;
8010435e:	31 f6                	xor    %esi,%esi
{
80104360:	53                   	push   %ebx
  int now = ticks;
80104361:	8b 1d e0 57 11 80    	mov    0x801157e0,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010436e:	66 90                	xchg   %ax,%ax
    if (p->state != RUNNABLE || p->que_id != RR)
80104370:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104374:	75 1a                	jne    80104390 <round_robin+0x40>
80104376:	83 78 28 01          	cmpl   $0x1,0x28(%eax)
8010437a:	75 14                	jne    80104390 <round_robin+0x40>
    if ((now - p->preemption_time > max_diff))
8010437c:	89 da                	mov    %ebx,%edx
8010437e:	2b 50 24             	sub    0x24(%eax),%edx
80104381:	39 ca                	cmp    %ecx,%edx
80104383:	7e 0b                	jle    80104390 <round_robin+0x40>
80104385:	89 d1                	mov    %edx,%ecx
80104387:	89 c6                	mov    %eax,%esi
80104389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104390:	05 a0 00 00 00       	add    $0xa0,%eax
80104395:	3d 54 55 11 80       	cmp    $0x80115554,%eax
8010439a:	75 d4                	jne    80104370 <round_robin+0x20>
}
8010439c:	89 f0                	mov    %esi,%eax
8010439e:	5b                   	pop    %ebx
8010439f:	5e                   	pop    %esi
801043a0:	5d                   	pop    %ebp
801043a1:	c3                   	ret    
801043a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043b0 <last_come_first_serve>:
{
801043b0:	55                   	push   %ebp
  int latest_time = MIN_INT;
801043b1:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043b6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
{
801043bb:	89 e5                	mov    %esp,%ebp
801043bd:	53                   	push   %ebx
  struct proc *res = 0;
801043be:	31 db                	xor    %ebx,%ebx
    if (p->state != RUNNABLE || p->que_id != LCFS)
801043c0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801043c4:	75 1a                	jne    801043e0 <last_come_first_serve+0x30>
801043c6:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
801043ca:	75 14                	jne    801043e0 <last_come_first_serve+0x30>
    if (p->creation_time > latest_time)
801043cc:	8b 50 20             	mov    0x20(%eax),%edx
801043cf:	39 ca                	cmp    %ecx,%edx
801043d1:	7e 0d                	jle    801043e0 <last_come_first_serve+0x30>
801043d3:	89 d1                	mov    %edx,%ecx
801043d5:	89 c3                	mov    %eax,%ebx
801043d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043de:	66 90                	xchg   %ax,%ax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043e0:	05 a0 00 00 00       	add    $0xa0,%eax
801043e5:	3d 54 55 11 80       	cmp    $0x80115554,%eax
801043ea:	75 d4                	jne    801043c0 <last_come_first_serve+0x10>
}
801043ec:	89 d8                	mov    %ebx,%eax
801043ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043f1:	c9                   	leave  
801043f2:	c3                   	ret    
801043f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104400 <best_job_first>:
  float min_rank = (float)MAX_INT;
80104400:	d9 05 94 89 10 80    	flds   0x80108994
  struct proc *res = 0;
80104406:	31 d2                	xor    %edx,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104408:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010440d:	8d 76 00             	lea    0x0(%esi),%esi
    if (p->state != RUNNABLE || p->que_id != BJF)
80104410:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104414:	0f 85 96 00 00 00    	jne    801044b0 <best_job_first+0xb0>
8010441a:	83 78 28 03          	cmpl   $0x3,0x28(%eax)
8010441e:	0f 85 8c 00 00 00    	jne    801044b0 <best_job_first+0xb0>
{
80104424:	55                   	push   %ebp
80104425:	89 e5                	mov    %esp,%ebp
80104427:	53                   	push   %ebx
80104428:	83 ec 0c             	sub    $0xc,%esp
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
8010442b:	db 80 88 00 00 00    	fildl  0x88(%eax)
80104431:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
80104437:	31 db                	xor    %ebx,%ebx
80104439:	db 40 20             	fildl  0x20(%eax)
8010443c:	d8 88 90 00 00 00    	fmuls  0x90(%eax)
80104442:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80104445:	8b 08                	mov    (%eax),%ecx
80104447:	89 4d f0             	mov    %ecx,-0x10(%ebp)
8010444a:	de c1                	faddp  %st,%st(1)
8010444c:	d9 80 94 00 00 00    	flds   0x94(%eax)
80104452:	d8 88 98 00 00 00    	fmuls  0x98(%eax)
80104458:	de c1                	faddp  %st,%st(1)
8010445a:	df 6d f0             	fildll -0x10(%ebp)
8010445d:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
80104463:	de c1                	faddp  %st,%st(1)
80104465:	d9 c9                	fxch   %st(1)
    if (rank < min_rank)
80104467:	db f1                	fcomi  %st(1),%st
80104469:	76 0d                	jbe    80104478 <best_job_first+0x78>
8010446b:	dd d8                	fstp   %st(0)
8010446d:	89 c2                	mov    %eax,%edx
8010446f:	eb 09                	jmp    8010447a <best_job_first+0x7a>
80104471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104478:	dd d9                	fstp   %st(1)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010447a:	05 a0 00 00 00       	add    $0xa0,%eax
8010447f:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104484:	74 1c                	je     801044a2 <best_job_first+0xa2>
    if (p->state != RUNNABLE || p->que_id != BJF)
80104486:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010448a:	75 ee                	jne    8010447a <best_job_first+0x7a>
8010448c:	83 78 28 03          	cmpl   $0x3,0x28(%eax)
80104490:	74 99                	je     8010442b <best_job_first+0x2b>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104492:	05 a0 00 00 00       	add    $0xa0,%eax
80104497:	3d 54 55 11 80       	cmp    $0x80115554,%eax
8010449c:	75 e8                	jne    80104486 <best_job_first+0x86>
8010449e:	dd d8                	fstp   %st(0)
801044a0:	eb 02                	jmp    801044a4 <best_job_first+0xa4>
801044a2:	dd d8                	fstp   %st(0)
}
801044a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044a7:	89 d0                	mov    %edx,%eax
801044a9:	c9                   	leave  
801044aa:	c3                   	ret    
801044ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044af:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044b0:	05 a0 00 00 00       	add    $0xa0,%eax
801044b5:	3d 54 55 11 80       	cmp    $0x80115554,%eax
801044ba:	0f 85 50 ff ff ff    	jne    80104410 <best_job_first+0x10>
801044c0:	dd d8                	fstp   %st(0)
}
801044c2:	89 d0                	mov    %edx,%eax
801044c4:	c3                   	ret    
801044c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044d0 <scheduler>:
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	57                   	push   %edi
801044d4:	56                   	push   %esi
801044d5:	53                   	push   %ebx
801044d6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801044d9:	e8 b2 f4 ff ff       	call   80103990 <mycpu>
  c->proc = 0;
801044de:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801044e5:	00 00 00 
  struct cpu *c = mycpu();
801044e8:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
801044ea:	8d 40 04             	lea    0x4(%eax),%eax
801044ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  asm volatile("sti");
801044f0:	fb                   	sti    
    acquire(&ptable.lock);
801044f1:	83 ec 0c             	sub    $0xc,%esp
  struct proc *res = 0;
801044f4:	31 f6                	xor    %esi,%esi
    acquire(&ptable.lock);
801044f6:	68 20 2d 11 80       	push   $0x80112d20
801044fb:	e8 40 0b 00 00       	call   80105040 <acquire>
  int now = ticks;
80104500:	8b 3d e0 57 11 80    	mov    0x801157e0,%edi
80104506:	83 c4 10             	add    $0x10,%esp
  int max_diff = MIN_INT;
80104509:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010450e:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104513:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104517:	90                   	nop
    if (p->state != RUNNABLE || p->que_id != RR)
80104518:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010451c:	75 1a                	jne    80104538 <scheduler+0x68>
8010451e:	83 78 28 01          	cmpl   $0x1,0x28(%eax)
80104522:	75 14                	jne    80104538 <scheduler+0x68>
    if ((now - p->preemption_time > max_diff))
80104524:	89 fa                	mov    %edi,%edx
80104526:	2b 50 24             	sub    0x24(%eax),%edx
80104529:	39 ca                	cmp    %ecx,%edx
8010452b:	7e 0b                	jle    80104538 <scheduler+0x68>
8010452d:	89 d1                	mov    %edx,%ecx
8010452f:	89 c6                	mov    %eax,%esi
80104531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104538:	05 a0 00 00 00       	add    $0xa0,%eax
8010453d:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104542:	75 d4                	jne    80104518 <scheduler+0x48>
    if (p == 0)
80104544:	85 f6                	test   %esi,%esi
80104546:	74 60                	je     801045a8 <scheduler+0xd8>
    switchuvm(p);
80104548:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
8010454b:	89 b3 ac 00 00 00    	mov    %esi,0xac(%ebx)
    switchuvm(p);
80104551:	56                   	push   %esi
80104552:	e8 39 35 00 00       	call   80107a90 <switchuvm>
    p->executed_cycle += 0.1f;
80104557:	d9 05 90 89 10 80    	flds   0x80108990
8010455d:	d8 86 94 00 00 00    	fadds  0x94(%esi)
    p->state = RUNNING;
80104563:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
    p->preemption_time = ticks;
8010456a:	a1 e0 57 11 80       	mov    0x801157e0,%eax
8010456f:	89 46 24             	mov    %eax,0x24(%esi)
    p->executed_cycle += 0.1f;
80104572:	d9 9e 94 00 00 00    	fstps  0x94(%esi)
    swtch(&(c->scheduler), p->context);
80104578:	58                   	pop    %eax
80104579:	5a                   	pop    %edx
8010457a:	ff 76 1c             	push   0x1c(%esi)
8010457d:	ff 75 dc             	push   -0x24(%ebp)
80104580:	e8 96 0d 00 00       	call   8010531b <swtch>
    switchkvm();
80104585:	e8 f6 34 00 00       	call   80107a80 <switchkvm>
    c->proc = 0;
8010458a:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104591:	00 00 00 
    release(&ptable.lock);
80104594:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010459b:	e8 40 0a 00 00       	call   80104fe0 <release>
801045a0:	83 c4 10             	add    $0x10,%esp
801045a3:	e9 48 ff ff ff       	jmp    801044f0 <scheduler+0x20>
  int latest_time = MIN_INT;
801045a8:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045ad:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801045b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (p->state != RUNNABLE || p->que_id != LCFS)
801045b8:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801045bc:	75 12                	jne    801045d0 <scheduler+0x100>
801045be:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
801045c2:	75 0c                	jne    801045d0 <scheduler+0x100>
    if (p->creation_time > latest_time)
801045c4:	8b 50 20             	mov    0x20(%eax),%edx
801045c7:	39 ca                	cmp    %ecx,%edx
801045c9:	7e 05                	jle    801045d0 <scheduler+0x100>
801045cb:	89 d1                	mov    %edx,%ecx
801045cd:	89 c6                	mov    %eax,%esi
801045cf:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045d0:	05 a0 00 00 00       	add    $0xa0,%eax
801045d5:	3d 54 55 11 80       	cmp    $0x80115554,%eax
801045da:	75 dc                	jne    801045b8 <scheduler+0xe8>
    if (p == 0)
801045dc:	85 f6                	test   %esi,%esi
801045de:	0f 85 64 ff ff ff    	jne    80104548 <scheduler+0x78>
  float min_rank = (float)MAX_INT;
801045e4:	d9 05 94 89 10 80    	flds   0x80108994
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045ea:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801045ef:	90                   	nop
    if (p->state != RUNNABLE || p->que_id != BJF)
801045f0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801045f4:	75 5a                	jne    80104650 <scheduler+0x180>
801045f6:	83 78 28 03          	cmpl   $0x3,0x28(%eax)
801045fa:	75 54                	jne    80104650 <scheduler+0x180>
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
801045fc:	db 80 88 00 00 00    	fildl  0x88(%eax)
80104602:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
80104608:	31 c9                	xor    %ecx,%ecx
8010460a:	db 40 20             	fildl  0x20(%eax)
8010460d:	d8 88 90 00 00 00    	fmuls  0x90(%eax)
80104613:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80104616:	8b 10                	mov    (%eax),%edx
80104618:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010461b:	de c1                	faddp  %st,%st(1)
8010461d:	d9 80 94 00 00 00    	flds   0x94(%eax)
80104623:	d8 88 98 00 00 00    	fmuls  0x98(%eax)
80104629:	de c1                	faddp  %st,%st(1)
8010462b:	df 6d e0             	fildll -0x20(%ebp)
8010462e:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
80104634:	de c1                	faddp  %st,%st(1)
80104636:	d9 c9                	fxch   %st(1)
    if (rank < min_rank)
80104638:	db f1                	fcomi  %st(1),%st
8010463a:	76 0c                	jbe    80104648 <scheduler+0x178>
8010463c:	dd d8                	fstp   %st(0)
8010463e:	89 c6                	mov    %eax,%esi
80104640:	eb 0e                	jmp    80104650 <scheduler+0x180>
80104642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104648:	dd d9                	fstp   %st(1)
8010464a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104650:	05 a0 00 00 00       	add    $0xa0,%eax
80104655:	3d 54 55 11 80       	cmp    $0x80115554,%eax
8010465a:	75 94                	jne    801045f0 <scheduler+0x120>
8010465c:	dd d8                	fstp   %st(0)
    if (p == 0)
8010465e:	85 f6                	test   %esi,%esi
80104660:	0f 85 e2 fe ff ff    	jne    80104548 <scheduler+0x78>
      release(&ptable.lock);
80104666:	83 ec 0c             	sub    $0xc,%esp
80104669:	68 20 2d 11 80       	push   $0x80112d20
8010466e:	e8 6d 09 00 00       	call   80104fe0 <release>
      continue;
80104673:	83 c4 10             	add    $0x10,%esp
80104676:	e9 75 fe ff ff       	jmp    801044f0 <scheduler+0x20>
8010467b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010467f:	90                   	nop

80104680 <sched>:
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
  pushcli();
80104685:	e8 66 08 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
8010468a:	e8 01 f3 ff ff       	call   80103990 <mycpu>
  p = c->proc;
8010468f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104695:	e8 a6 08 00 00       	call   80104f40 <popcli>
  if (!holding(&ptable.lock))
8010469a:	83 ec 0c             	sub    $0xc,%esp
8010469d:	68 20 2d 11 80       	push   $0x80112d20
801046a2:	e8 f9 08 00 00       	call   80104fa0 <holding>
801046a7:	83 c4 10             	add    $0x10,%esp
801046aa:	85 c0                	test   %eax,%eax
801046ac:	74 4f                	je     801046fd <sched+0x7d>
  if (mycpu()->ncli != 1)
801046ae:	e8 dd f2 ff ff       	call   80103990 <mycpu>
801046b3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801046ba:	75 68                	jne    80104724 <sched+0xa4>
  if (p->state == RUNNING)
801046bc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801046c0:	74 55                	je     80104717 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046c2:	9c                   	pushf  
801046c3:	58                   	pop    %eax
  if (readeflags() & FL_IF)
801046c4:	f6 c4 02             	test   $0x2,%ah
801046c7:	75 41                	jne    8010470a <sched+0x8a>
  intena = mycpu()->intena;
801046c9:	e8 c2 f2 ff ff       	call   80103990 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801046ce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801046d1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801046d7:	e8 b4 f2 ff ff       	call   80103990 <mycpu>
801046dc:	83 ec 08             	sub    $0x8,%esp
801046df:	ff 70 04             	push   0x4(%eax)
801046e2:	53                   	push   %ebx
801046e3:	e8 33 0c 00 00       	call   8010531b <swtch>
  mycpu()->intena = intena;
801046e8:	e8 a3 f2 ff ff       	call   80103990 <mycpu>
}
801046ed:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801046f0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801046f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046f9:	5b                   	pop    %ebx
801046fa:	5e                   	pop    %esi
801046fb:	5d                   	pop    %ebp
801046fc:	c3                   	ret    
    panic("sched ptable.lock");
801046fd:	83 ec 0c             	sub    $0xc,%esp
80104700:	68 34 88 10 80       	push   $0x80108834
80104705:	e8 76 bc ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010470a:	83 ec 0c             	sub    $0xc,%esp
8010470d:	68 60 88 10 80       	push   $0x80108860
80104712:	e8 69 bc ff ff       	call   80100380 <panic>
    panic("sched running");
80104717:	83 ec 0c             	sub    $0xc,%esp
8010471a:	68 52 88 10 80       	push   $0x80108852
8010471f:	e8 5c bc ff ff       	call   80100380 <panic>
    panic("sched locks");
80104724:	83 ec 0c             	sub    $0xc,%esp
80104727:	68 46 88 10 80       	push   $0x80108846
8010472c:	e8 4f bc ff ff       	call   80100380 <panic>
80104731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010473f:	90                   	nop

80104740 <exit>:
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	57                   	push   %edi
80104744:	56                   	push   %esi
80104745:	53                   	push   %ebx
80104746:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104749:	e8 a2 f3 ff ff       	call   80103af0 <myproc>
  if (curproc == initproc)
8010474e:	39 05 c4 57 11 80    	cmp    %eax,0x801157c4
80104754:	0f 84 07 01 00 00    	je     80104861 <exit+0x121>
8010475a:	89 c3                	mov    %eax,%ebx
8010475c:	8d 70 34             	lea    0x34(%eax),%esi
8010475f:	8d 78 74             	lea    0x74(%eax),%edi
80104762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd])
80104768:	8b 06                	mov    (%esi),%eax
8010476a:	85 c0                	test   %eax,%eax
8010476c:	74 12                	je     80104780 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010476e:	83 ec 0c             	sub    $0xc,%esp
80104771:	50                   	push   %eax
80104772:	e8 79 c7 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80104777:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010477d:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
80104780:	83 c6 04             	add    $0x4,%esi
80104783:	39 f7                	cmp    %esi,%edi
80104785:	75 e1                	jne    80104768 <exit+0x28>
  begin_op();
80104787:	e8 d4 e5 ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
8010478c:	83 ec 0c             	sub    $0xc,%esp
8010478f:	ff 73 74             	push   0x74(%ebx)
80104792:	e8 19 d1 ff ff       	call   801018b0 <iput>
  end_op();
80104797:	e8 34 e6 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
8010479c:	c7 43 74 00 00 00 00 	movl   $0x0,0x74(%ebx)
  acquire(&ptable.lock);
801047a3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801047aa:	e8 91 08 00 00       	call   80105040 <acquire>
  wakeup1(curproc->parent);
801047af:	8b 53 14             	mov    0x14(%ebx),%edx
801047b2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047b5:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801047ba:	eb 10                	jmp    801047cc <exit+0x8c>
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047c0:	05 a0 00 00 00       	add    $0xa0,%eax
801047c5:	3d 54 55 11 80       	cmp    $0x80115554,%eax
801047ca:	74 1e                	je     801047ea <exit+0xaa>
    if (p->state == SLEEPING && p->chan == chan)
801047cc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801047d0:	75 ee                	jne    801047c0 <exit+0x80>
801047d2:	3b 50 2c             	cmp    0x2c(%eax),%edx
801047d5:	75 e9                	jne    801047c0 <exit+0x80>
      p->state = RUNNABLE;
801047d7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047de:	05 a0 00 00 00       	add    $0xa0,%eax
801047e3:	3d 54 55 11 80       	cmp    $0x80115554,%eax
801047e8:	75 e2                	jne    801047cc <exit+0x8c>
      p->parent = initproc;
801047ea:	8b 0d c4 57 11 80    	mov    0x801157c4,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047f0:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801047f5:	eb 17                	jmp    8010480e <exit+0xce>
801047f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047fe:	66 90                	xchg   %ax,%ax
80104800:	81 c2 a0 00 00 00    	add    $0xa0,%edx
80104806:	81 fa 54 55 11 80    	cmp    $0x80115554,%edx
8010480c:	74 3a                	je     80104848 <exit+0x108>
    if (p->parent == curproc)
8010480e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104811:	75 ed                	jne    80104800 <exit+0xc0>
      if (p->state == ZOMBIE)
80104813:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104817:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
8010481a:	75 e4                	jne    80104800 <exit+0xc0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010481c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104821:	eb 11                	jmp    80104834 <exit+0xf4>
80104823:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104827:	90                   	nop
80104828:	05 a0 00 00 00       	add    $0xa0,%eax
8010482d:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104832:	74 cc                	je     80104800 <exit+0xc0>
    if (p->state == SLEEPING && p->chan == chan)
80104834:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104838:	75 ee                	jne    80104828 <exit+0xe8>
8010483a:	3b 48 2c             	cmp    0x2c(%eax),%ecx
8010483d:	75 e9                	jne    80104828 <exit+0xe8>
      p->state = RUNNABLE;
8010483f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104846:	eb e0                	jmp    80104828 <exit+0xe8>
  curproc->state = ZOMBIE;
80104848:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010484f:	e8 2c fe ff ff       	call   80104680 <sched>
  panic("zombie exit");
80104854:	83 ec 0c             	sub    $0xc,%esp
80104857:	68 81 88 10 80       	push   $0x80108881
8010485c:	e8 1f bb ff ff       	call   80100380 <panic>
    panic("init exiting");
80104861:	83 ec 0c             	sub    $0xc,%esp
80104864:	68 74 88 10 80       	push   $0x80108874
80104869:	e8 12 bb ff ff       	call   80100380 <panic>
8010486e:	66 90                	xchg   %ax,%ax

80104870 <wait>:
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
  pushcli();
80104875:	e8 76 06 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
8010487a:	e8 11 f1 ff ff       	call   80103990 <mycpu>
  p = c->proc;
8010487f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104885:	e8 b6 06 00 00       	call   80104f40 <popcli>
  acquire(&ptable.lock);
8010488a:	83 ec 0c             	sub    $0xc,%esp
8010488d:	68 20 2d 11 80       	push   $0x80112d20
80104892:	e8 a9 07 00 00       	call   80105040 <acquire>
80104897:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010489a:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010489c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801048a1:	eb 13                	jmp    801048b6 <wait+0x46>
801048a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048a7:	90                   	nop
801048a8:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
801048ae:	81 fb 54 55 11 80    	cmp    $0x80115554,%ebx
801048b4:	74 1e                	je     801048d4 <wait+0x64>
      if (p->parent != curproc)
801048b6:	39 73 14             	cmp    %esi,0x14(%ebx)
801048b9:	75 ed                	jne    801048a8 <wait+0x38>
      if (p->state == ZOMBIE)
801048bb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801048bf:	74 5f                	je     80104920 <wait+0xb0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048c1:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
      havekids = 1;
801048c7:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048cc:	81 fb 54 55 11 80    	cmp    $0x80115554,%ebx
801048d2:	75 e2                	jne    801048b6 <wait+0x46>
    if (!havekids || curproc->killed)
801048d4:	85 c0                	test   %eax,%eax
801048d6:	0f 84 9a 00 00 00    	je     80104976 <wait+0x106>
801048dc:	8b 46 30             	mov    0x30(%esi),%eax
801048df:	85 c0                	test   %eax,%eax
801048e1:	0f 85 8f 00 00 00    	jne    80104976 <wait+0x106>
  pushcli();
801048e7:	e8 04 06 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
801048ec:	e8 9f f0 ff ff       	call   80103990 <mycpu>
  p = c->proc;
801048f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048f7:	e8 44 06 00 00       	call   80104f40 <popcli>
  if (p == 0)
801048fc:	85 db                	test   %ebx,%ebx
801048fe:	0f 84 89 00 00 00    	je     8010498d <wait+0x11d>
  p->chan = chan;
80104904:	89 73 2c             	mov    %esi,0x2c(%ebx)
  p->state = SLEEPING;
80104907:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010490e:	e8 6d fd ff ff       	call   80104680 <sched>
  p->chan = 0;
80104913:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
}
8010491a:	e9 7b ff ff ff       	jmp    8010489a <wait+0x2a>
8010491f:	90                   	nop
        kfree(p->kstack);
80104920:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104923:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104926:	ff 73 08             	push   0x8(%ebx)
80104929:	e8 92 db ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010492e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104935:	5a                   	pop    %edx
80104936:	ff 73 04             	push   0x4(%ebx)
80104939:	e8 32 35 00 00       	call   80107e70 <freevm>
        p->pid = 0;
8010493e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104945:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010494c:	c6 43 78 00          	movb   $0x0,0x78(%ebx)
        p->killed = 0;
80104950:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
        p->state = UNUSED;
80104957:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010495e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104965:	e8 76 06 00 00       	call   80104fe0 <release>
        return pid;
8010496a:	83 c4 10             	add    $0x10,%esp
}
8010496d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104970:	89 f0                	mov    %esi,%eax
80104972:	5b                   	pop    %ebx
80104973:	5e                   	pop    %esi
80104974:	5d                   	pop    %ebp
80104975:	c3                   	ret    
      release(&ptable.lock);
80104976:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104979:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010497e:	68 20 2d 11 80       	push   $0x80112d20
80104983:	e8 58 06 00 00       	call   80104fe0 <release>
      return -1;
80104988:	83 c4 10             	add    $0x10,%esp
8010498b:	eb e0                	jmp    8010496d <wait+0xfd>
    panic("sleep");
8010498d:	83 ec 0c             	sub    $0xc,%esp
80104990:	68 8d 88 10 80       	push   $0x8010888d
80104995:	e8 e6 b9 ff ff       	call   80100380 <panic>
8010499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049a0 <yield>:
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
  acquire(&ptable.lock); // DOC: yieldlock
801049a5:	83 ec 0c             	sub    $0xc,%esp
801049a8:	68 20 2d 11 80       	push   $0x80112d20
801049ad:	e8 8e 06 00 00       	call   80105040 <acquire>
  pushcli();
801049b2:	e8 39 05 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
801049b7:	e8 d4 ef ff ff       	call   80103990 <mycpu>
  p = c->proc;
801049bc:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801049c2:	e8 79 05 00 00       	call   80104f40 <popcli>
  myproc()->preemption_time = ticks;
801049c7:	8b 35 e0 57 11 80    	mov    0x801157e0,%esi
  myproc()->state = RUNNABLE;
801049cd:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pushcli();
801049d4:	e8 17 05 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
801049d9:	e8 b2 ef ff ff       	call   80103990 <mycpu>
  p = c->proc;
801049de:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801049e4:	e8 57 05 00 00       	call   80104f40 <popcli>
  myproc()->preemption_time = ticks;
801049e9:	89 73 24             	mov    %esi,0x24(%ebx)
  pushcli();
801049ec:	e8 ff 04 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
801049f1:	e8 9a ef ff ff       	call   80103990 <mycpu>
  p = c->proc;
801049f6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801049fc:	e8 3f 05 00 00       	call   80104f40 <popcli>
  myproc()->executed_cycle += 0.1;
80104a01:	dd 05 98 89 10 80    	fldl   0x80108998
80104a07:	d8 83 94 00 00 00    	fadds  0x94(%ebx)
80104a0d:	d9 9b 94 00 00 00    	fstps  0x94(%ebx)
  sched();
80104a13:	e8 68 fc ff ff       	call   80104680 <sched>
  release(&ptable.lock);
80104a18:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104a1f:	e8 bc 05 00 00       	call   80104fe0 <release>
}
80104a24:	83 c4 10             	add    $0x10,%esp
80104a27:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a2a:	5b                   	pop    %ebx
80104a2b:	5e                   	pop    %esi
80104a2c:	5d                   	pop    %ebp
80104a2d:	c3                   	ret    
80104a2e:	66 90                	xchg   %ax,%ax

80104a30 <sleep>:
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	57                   	push   %edi
80104a34:	56                   	push   %esi
80104a35:	53                   	push   %ebx
80104a36:	83 ec 0c             	sub    $0xc,%esp
80104a39:	8b 7d 08             	mov    0x8(%ebp),%edi
80104a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104a3f:	e8 ac 04 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
80104a44:	e8 47 ef ff ff       	call   80103990 <mycpu>
  p = c->proc;
80104a49:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a4f:	e8 ec 04 00 00       	call   80104f40 <popcli>
  if (p == 0)
80104a54:	85 db                	test   %ebx,%ebx
80104a56:	0f 84 87 00 00 00    	je     80104ae3 <sleep+0xb3>
  if (lk == 0)
80104a5c:	85 f6                	test   %esi,%esi
80104a5e:	74 76                	je     80104ad6 <sleep+0xa6>
  if (lk != &ptable.lock)
80104a60:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104a66:	74 50                	je     80104ab8 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
80104a68:	83 ec 0c             	sub    $0xc,%esp
80104a6b:	68 20 2d 11 80       	push   $0x80112d20
80104a70:	e8 cb 05 00 00       	call   80105040 <acquire>
    release(lk);
80104a75:	89 34 24             	mov    %esi,(%esp)
80104a78:	e8 63 05 00 00       	call   80104fe0 <release>
  p->chan = chan;
80104a7d:	89 7b 2c             	mov    %edi,0x2c(%ebx)
  p->state = SLEEPING;
80104a80:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104a87:	e8 f4 fb ff ff       	call   80104680 <sched>
  p->chan = 0;
80104a8c:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
    release(&ptable.lock);
80104a93:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104a9a:	e8 41 05 00 00       	call   80104fe0 <release>
    acquire(lk);
80104a9f:	89 75 08             	mov    %esi,0x8(%ebp)
80104aa2:	83 c4 10             	add    $0x10,%esp
}
80104aa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104aa8:	5b                   	pop    %ebx
80104aa9:	5e                   	pop    %esi
80104aaa:	5f                   	pop    %edi
80104aab:	5d                   	pop    %ebp
    acquire(lk);
80104aac:	e9 8f 05 00 00       	jmp    80105040 <acquire>
80104ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104ab8:	89 7b 2c             	mov    %edi,0x2c(%ebx)
  p->state = SLEEPING;
80104abb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104ac2:	e8 b9 fb ff ff       	call   80104680 <sched>
  p->chan = 0;
80104ac7:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
}
80104ace:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ad1:	5b                   	pop    %ebx
80104ad2:	5e                   	pop    %esi
80104ad3:	5f                   	pop    %edi
80104ad4:	5d                   	pop    %ebp
80104ad5:	c3                   	ret    
    panic("sleep without lk");
80104ad6:	83 ec 0c             	sub    $0xc,%esp
80104ad9:	68 93 88 10 80       	push   $0x80108893
80104ade:	e8 9d b8 ff ff       	call   80100380 <panic>
    panic("sleep");
80104ae3:	83 ec 0c             	sub    $0xc,%esp
80104ae6:	68 8d 88 10 80       	push   $0x8010888d
80104aeb:	e8 90 b8 ff ff       	call   80100380 <panic>

80104af0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
80104af4:	83 ec 10             	sub    $0x10,%esp
80104af7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104afa:	68 20 2d 11 80       	push   $0x80112d20
80104aff:	e8 3c 05 00 00       	call   80105040 <acquire>
80104b04:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b07:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104b0c:	eb 0e                	jmp    80104b1c <wakeup+0x2c>
80104b0e:	66 90                	xchg   %ax,%ax
80104b10:	05 a0 00 00 00       	add    $0xa0,%eax
80104b15:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104b1a:	74 1e                	je     80104b3a <wakeup+0x4a>
    if (p->state == SLEEPING && p->chan == chan)
80104b1c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104b20:	75 ee                	jne    80104b10 <wakeup+0x20>
80104b22:	3b 58 2c             	cmp    0x2c(%eax),%ebx
80104b25:	75 e9                	jne    80104b10 <wakeup+0x20>
      p->state = RUNNABLE;
80104b27:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b2e:	05 a0 00 00 00       	add    $0xa0,%eax
80104b33:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104b38:	75 e2                	jne    80104b1c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104b3a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104b41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b44:	c9                   	leave  
  release(&ptable.lock);
80104b45:	e9 96 04 00 00       	jmp    80104fe0 <release>
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b50 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	53                   	push   %ebx
80104b54:	83 ec 10             	sub    $0x10,%esp
80104b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104b5a:	68 20 2d 11 80       	push   $0x80112d20
80104b5f:	e8 dc 04 00 00       	call   80105040 <acquire>
80104b64:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b67:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104b6c:	eb 0e                	jmp    80104b7c <kill+0x2c>
80104b6e:	66 90                	xchg   %ax,%ax
80104b70:	05 a0 00 00 00       	add    $0xa0,%eax
80104b75:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104b7a:	74 34                	je     80104bb0 <kill+0x60>
  {
    if (p->pid == pid)
80104b7c:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b7f:	75 ef                	jne    80104b70 <kill+0x20>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
80104b81:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104b85:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
      if (p->state == SLEEPING)
80104b8c:	75 07                	jne    80104b95 <kill+0x45>
        p->state = RUNNABLE;
80104b8e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104b95:	83 ec 0c             	sub    $0xc,%esp
80104b98:	68 20 2d 11 80       	push   $0x80112d20
80104b9d:	e8 3e 04 00 00       	call   80104fe0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104ba2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104ba5:	83 c4 10             	add    $0x10,%esp
80104ba8:	31 c0                	xor    %eax,%eax
}
80104baa:	c9                   	leave  
80104bab:	c3                   	ret    
80104bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104bb0:	83 ec 0c             	sub    $0xc,%esp
80104bb3:	68 20 2d 11 80       	push   $0x80112d20
80104bb8:	e8 23 04 00 00       	call   80104fe0 <release>
}
80104bbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104bc0:	83 c4 10             	add    $0x10,%esp
80104bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bc8:	c9                   	leave  
80104bc9:	c3                   	ret    
80104bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bd0 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	57                   	push   %edi
80104bd4:	56                   	push   %esi
80104bd5:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104bd8:	53                   	push   %ebx
80104bd9:	bb cc 2d 11 80       	mov    $0x80112dcc,%ebx
80104bde:	83 ec 3c             	sub    $0x3c,%esp
80104be1:	eb 27                	jmp    80104c0a <procdump+0x3a>
80104be3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104be7:	90                   	nop
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104be8:	83 ec 0c             	sub    $0xc,%esp
80104beb:	68 f3 8c 10 80       	push   $0x80108cf3
80104bf0:	e8 ab ba ff ff       	call   801006a0 <cprintf>
80104bf5:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bf8:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80104bfe:	81 fb cc 55 11 80    	cmp    $0x801155cc,%ebx
80104c04:	0f 84 7e 00 00 00    	je     80104c88 <procdump+0xb8>
    if (p->state == UNUSED)
80104c0a:	8b 43 94             	mov    -0x6c(%ebx),%eax
80104c0d:	85 c0                	test   %eax,%eax
80104c0f:	74 e7                	je     80104bf8 <procdump+0x28>
      state = "???";
80104c11:	ba a4 88 10 80       	mov    $0x801088a4,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104c16:	83 f8 05             	cmp    $0x5,%eax
80104c19:	77 11                	ja     80104c2c <procdump+0x5c>
80104c1b:	8b 14 85 78 89 10 80 	mov    -0x7fef7688(,%eax,4),%edx
      state = "???";
80104c22:	b8 a4 88 10 80       	mov    $0x801088a4,%eax
80104c27:	85 d2                	test   %edx,%edx
80104c29:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104c2c:	53                   	push   %ebx
80104c2d:	52                   	push   %edx
80104c2e:	ff 73 98             	push   -0x68(%ebx)
80104c31:	68 a8 88 10 80       	push   $0x801088a8
80104c36:	e8 65 ba ff ff       	call   801006a0 <cprintf>
    if (p->state == SLEEPING)
80104c3b:	83 c4 10             	add    $0x10,%esp
80104c3e:	83 7b 94 02          	cmpl   $0x2,-0x6c(%ebx)
80104c42:	75 a4                	jne    80104be8 <procdump+0x18>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80104c44:	83 ec 08             	sub    $0x8,%esp
80104c47:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104c4a:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104c4d:	50                   	push   %eax
80104c4e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80104c51:	8b 40 0c             	mov    0xc(%eax),%eax
80104c54:	83 c0 08             	add    $0x8,%eax
80104c57:	50                   	push   %eax
80104c58:	e8 33 02 00 00       	call   80104e90 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104c5d:	83 c4 10             	add    $0x10,%esp
80104c60:	8b 17                	mov    (%edi),%edx
80104c62:	85 d2                	test   %edx,%edx
80104c64:	74 82                	je     80104be8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104c66:	83 ec 08             	sub    $0x8,%esp
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104c69:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104c6c:	52                   	push   %edx
80104c6d:	68 81 82 10 80       	push   $0x80108281
80104c72:	e8 29 ba ff ff       	call   801006a0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104c77:	83 c4 10             	add    $0x10,%esp
80104c7a:	39 fe                	cmp    %edi,%esi
80104c7c:	75 e2                	jne    80104c60 <procdump+0x90>
80104c7e:	e9 65 ff ff ff       	jmp    80104be8 <procdump+0x18>
80104c83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c87:	90                   	nop
  }
}
80104c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c8b:	5b                   	pop    %ebx
80104c8c:	5e                   	pop    %esi
80104c8d:	5f                   	pop    %edi
80104c8e:	5d                   	pop    %ebp
80104c8f:	c3                   	ret    

80104c90 <find_digital_root>:

int find_digital_root(int num)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
80104c95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while (num >= 10)
80104c98:	83 fb 09             	cmp    $0x9,%ebx
80104c9b:	7e 2e                	jle    80104ccb <find_digital_root+0x3b>
  {
    int temp = num;
    int res = 0;
    while (temp != 0)
    {
      int current_dig = temp % 10;
80104c9d:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80104ca8:	89 d9                	mov    %ebx,%ecx
    int res = 0;
80104caa:	31 db                	xor    %ebx,%ebx
80104cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      int current_dig = temp % 10;
80104cb0:	89 c8                	mov    %ecx,%eax
80104cb2:	f7 e6                	mul    %esi
80104cb4:	c1 ea 03             	shr    $0x3,%edx
80104cb7:	8d 04 92             	lea    (%edx,%edx,4),%eax
80104cba:	01 c0                	add    %eax,%eax
80104cbc:	29 c1                	sub    %eax,%ecx
      res += current_dig;
80104cbe:	01 cb                	add    %ecx,%ebx
      temp /= 10;
80104cc0:	89 d1                	mov    %edx,%ecx
    while (temp != 0)
80104cc2:	85 d2                	test   %edx,%edx
80104cc4:	75 ea                	jne    80104cb0 <find_digital_root+0x20>
  while (num >= 10)
80104cc6:	83 fb 09             	cmp    $0x9,%ebx
80104cc9:	7f dd                	jg     80104ca8 <find_digital_root+0x18>
    }
    num = res;
  }
  return num;
}
80104ccb:	89 d8                	mov    %ebx,%eax
80104ccd:	5b                   	pop    %ebx
80104cce:	5e                   	pop    %esi
80104ccf:	5d                   	pop    %ebp
80104cd0:	c3                   	ret    
80104cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cdf:	90                   	nop

80104ce0 <init_shared_pages>:


void init_shared_pages(){
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	83 ec 14             	sub    $0x14,%esp
  acquire(&SharedPages.lock);
80104ce6:	68 90 57 11 80       	push   $0x80115790
80104ceb:	e8 50 03 00 00       	call   80105040 <acquire>
  for(int i = 0 ; i < NUMBER_OF_SHARED_PAGES ; i++){
80104cf0:	b8 68 55 11 80       	mov    $0x80115568,%eax
80104cf5:	83 c4 10             	add    $0x10,%esp
80104cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cff:	90                   	nop
    SharedPages.mems[i].refference_count = 87;
80104d00:	c7 00 57 00 00 00    	movl   $0x57,(%eax)
  for(int i = 0 ; i < NUMBER_OF_SHARED_PAGES ; i++){
80104d06:	83 c0 38             	add    $0x38,%eax
80104d09:	3d 98 57 11 80       	cmp    $0x80115798,%eax
80104d0e:	75 f0                	jne    80104d00 <init_shared_pages+0x20>
  }
  release(&SharedPages.lock);
80104d10:	83 ec 0c             	sub    $0xc,%esp
80104d13:	68 90 57 11 80       	push   $0x80115790
80104d18:	e8 c3 02 00 00       	call   80104fe0 <release>
  cprintf("hereeee\n");
80104d1d:	c7 04 24 b1 88 10 80 	movl   $0x801088b1,(%esp)
80104d24:	e8 77 b9 ff ff       	call   801006a0 <cprintf>
}
80104d29:	83 c4 10             	add    $0x10,%esp
80104d2c:	c9                   	leave  
80104d2d:	c3                   	ret    
80104d2e:	66 90                	xchg   %ax,%ax

80104d30 <open_sharedmem>:


int open_sharedmem(int id){
  return SharedPages.mems[0].refference_count;
80104d30:	a1 68 55 11 80       	mov    0x80115568,%eax
80104d35:	c3                   	ret    
80104d36:	66 90                	xchg   %ax,%ax
80104d38:	66 90                	xchg   %ax,%ax
80104d3a:	66 90                	xchg   %ax,%ax
80104d3c:	66 90                	xchg   %ax,%ax
80104d3e:	66 90                	xchg   %ax,%ax

80104d40 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	53                   	push   %ebx
80104d44:	83 ec 0c             	sub    $0xc,%esp
80104d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104d4a:	68 a0 89 10 80       	push   $0x801089a0
80104d4f:	8d 43 04             	lea    0x4(%ebx),%eax
80104d52:	50                   	push   %eax
80104d53:	e8 18 01 00 00       	call   80104e70 <initlock>
  lk->name = name;
80104d58:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104d5b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104d61:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104d64:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104d6b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104d6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d71:	c9                   	leave  
80104d72:	c3                   	ret    
80104d73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d80 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	53                   	push   %ebx
80104d85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d88:	8d 73 04             	lea    0x4(%ebx),%esi
80104d8b:	83 ec 0c             	sub    $0xc,%esp
80104d8e:	56                   	push   %esi
80104d8f:	e8 ac 02 00 00       	call   80105040 <acquire>
  while (lk->locked) {
80104d94:	8b 13                	mov    (%ebx),%edx
80104d96:	83 c4 10             	add    $0x10,%esp
80104d99:	85 d2                	test   %edx,%edx
80104d9b:	74 16                	je     80104db3 <acquiresleep+0x33>
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104da0:	83 ec 08             	sub    $0x8,%esp
80104da3:	56                   	push   %esi
80104da4:	53                   	push   %ebx
80104da5:	e8 86 fc ff ff       	call   80104a30 <sleep>
  while (lk->locked) {
80104daa:	8b 03                	mov    (%ebx),%eax
80104dac:	83 c4 10             	add    $0x10,%esp
80104daf:	85 c0                	test   %eax,%eax
80104db1:	75 ed                	jne    80104da0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104db3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104db9:	e8 32 ed ff ff       	call   80103af0 <myproc>
80104dbe:	8b 40 10             	mov    0x10(%eax),%eax
80104dc1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104dc4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104dc7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dca:	5b                   	pop    %ebx
80104dcb:	5e                   	pop    %esi
80104dcc:	5d                   	pop    %ebp
  release(&lk->lk);
80104dcd:	e9 0e 02 00 00       	jmp    80104fe0 <release>
80104dd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104de0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	56                   	push   %esi
80104de4:	53                   	push   %ebx
80104de5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104de8:	8d 73 04             	lea    0x4(%ebx),%esi
80104deb:	83 ec 0c             	sub    $0xc,%esp
80104dee:	56                   	push   %esi
80104def:	e8 4c 02 00 00       	call   80105040 <acquire>
  lk->locked = 0;
80104df4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104dfa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104e01:	89 1c 24             	mov    %ebx,(%esp)
80104e04:	e8 e7 fc ff ff       	call   80104af0 <wakeup>
  release(&lk->lk);
80104e09:	89 75 08             	mov    %esi,0x8(%ebp)
80104e0c:	83 c4 10             	add    $0x10,%esp
}
80104e0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e12:	5b                   	pop    %ebx
80104e13:	5e                   	pop    %esi
80104e14:	5d                   	pop    %ebp
  release(&lk->lk);
80104e15:	e9 c6 01 00 00       	jmp    80104fe0 <release>
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e20 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	57                   	push   %edi
80104e24:	31 ff                	xor    %edi,%edi
80104e26:	56                   	push   %esi
80104e27:	53                   	push   %ebx
80104e28:	83 ec 18             	sub    $0x18,%esp
80104e2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104e2e:	8d 73 04             	lea    0x4(%ebx),%esi
80104e31:	56                   	push   %esi
80104e32:	e8 09 02 00 00       	call   80105040 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104e37:	8b 03                	mov    (%ebx),%eax
80104e39:	83 c4 10             	add    $0x10,%esp
80104e3c:	85 c0                	test   %eax,%eax
80104e3e:	75 18                	jne    80104e58 <holdingsleep+0x38>
  release(&lk->lk);
80104e40:	83 ec 0c             	sub    $0xc,%esp
80104e43:	56                   	push   %esi
80104e44:	e8 97 01 00 00       	call   80104fe0 <release>
  return r;
}
80104e49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e4c:	89 f8                	mov    %edi,%eax
80104e4e:	5b                   	pop    %ebx
80104e4f:	5e                   	pop    %esi
80104e50:	5f                   	pop    %edi
80104e51:	5d                   	pop    %ebp
80104e52:	c3                   	ret    
80104e53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e57:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104e58:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104e5b:	e8 90 ec ff ff       	call   80103af0 <myproc>
80104e60:	39 58 10             	cmp    %ebx,0x10(%eax)
80104e63:	0f 94 c0             	sete   %al
80104e66:	0f b6 c0             	movzbl %al,%eax
80104e69:	89 c7                	mov    %eax,%edi
80104e6b:	eb d3                	jmp    80104e40 <holdingsleep+0x20>
80104e6d:	66 90                	xchg   %ax,%ax
80104e6f:	90                   	nop

80104e70 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104e79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104e7f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104e82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104e89:	5d                   	pop    %ebp
80104e8a:	c3                   	ret    
80104e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e8f:	90                   	nop

80104e90 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104e90:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104e91:	31 d2                	xor    %edx,%edx
{
80104e93:	89 e5                	mov    %esp,%ebp
80104e95:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104e96:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104e99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104e9c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104e9f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ea0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104ea6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104eac:	77 1a                	ja     80104ec8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104eae:	8b 58 04             	mov    0x4(%eax),%ebx
80104eb1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104eb4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104eb7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104eb9:	83 fa 0a             	cmp    $0xa,%edx
80104ebc:	75 e2                	jne    80104ea0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104ebe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ec1:	c9                   	leave  
80104ec2:	c3                   	ret    
80104ec3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ec7:	90                   	nop
  for(; i < 10; i++)
80104ec8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104ecb:	8d 51 28             	lea    0x28(%ecx),%edx
80104ece:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ed0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ed6:	83 c0 04             	add    $0x4,%eax
80104ed9:	39 d0                	cmp    %edx,%eax
80104edb:	75 f3                	jne    80104ed0 <getcallerpcs+0x40>
}
80104edd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ee0:	c9                   	leave  
80104ee1:	c3                   	ret    
80104ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ef0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	53                   	push   %ebx
80104ef4:	83 ec 04             	sub    $0x4,%esp
80104ef7:	9c                   	pushf  
80104ef8:	5b                   	pop    %ebx
  asm volatile("cli");
80104ef9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104efa:	e8 91 ea ff ff       	call   80103990 <mycpu>
80104eff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104f05:	85 c0                	test   %eax,%eax
80104f07:	74 17                	je     80104f20 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104f09:	e8 82 ea ff ff       	call   80103990 <mycpu>
80104f0e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104f15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f18:	c9                   	leave  
80104f19:	c3                   	ret    
80104f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104f20:	e8 6b ea ff ff       	call   80103990 <mycpu>
80104f25:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104f2b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104f31:	eb d6                	jmp    80104f09 <pushcli+0x19>
80104f33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f40 <popcli>:

void
popcli(void)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f46:	9c                   	pushf  
80104f47:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104f48:	f6 c4 02             	test   $0x2,%ah
80104f4b:	75 35                	jne    80104f82 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104f4d:	e8 3e ea ff ff       	call   80103990 <mycpu>
80104f52:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104f59:	78 34                	js     80104f8f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f5b:	e8 30 ea ff ff       	call   80103990 <mycpu>
80104f60:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104f66:	85 d2                	test   %edx,%edx
80104f68:	74 06                	je     80104f70 <popcli+0x30>
    sti();
}
80104f6a:	c9                   	leave  
80104f6b:	c3                   	ret    
80104f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f70:	e8 1b ea ff ff       	call   80103990 <mycpu>
80104f75:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104f7b:	85 c0                	test   %eax,%eax
80104f7d:	74 eb                	je     80104f6a <popcli+0x2a>
  asm volatile("sti");
80104f7f:	fb                   	sti    
}
80104f80:	c9                   	leave  
80104f81:	c3                   	ret    
    panic("popcli - interruptible");
80104f82:	83 ec 0c             	sub    $0xc,%esp
80104f85:	68 ab 89 10 80       	push   $0x801089ab
80104f8a:	e8 f1 b3 ff ff       	call   80100380 <panic>
    panic("popcli");
80104f8f:	83 ec 0c             	sub    $0xc,%esp
80104f92:	68 c2 89 10 80       	push   $0x801089c2
80104f97:	e8 e4 b3 ff ff       	call   80100380 <panic>
80104f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fa0 <holding>:
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
80104fa5:	8b 75 08             	mov    0x8(%ebp),%esi
80104fa8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104faa:	e8 41 ff ff ff       	call   80104ef0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104faf:	8b 06                	mov    (%esi),%eax
80104fb1:	85 c0                	test   %eax,%eax
80104fb3:	75 0b                	jne    80104fc0 <holding+0x20>
  popcli();
80104fb5:	e8 86 ff ff ff       	call   80104f40 <popcli>
}
80104fba:	89 d8                	mov    %ebx,%eax
80104fbc:	5b                   	pop    %ebx
80104fbd:	5e                   	pop    %esi
80104fbe:	5d                   	pop    %ebp
80104fbf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104fc0:	8b 5e 08             	mov    0x8(%esi),%ebx
80104fc3:	e8 c8 e9 ff ff       	call   80103990 <mycpu>
80104fc8:	39 c3                	cmp    %eax,%ebx
80104fca:	0f 94 c3             	sete   %bl
  popcli();
80104fcd:	e8 6e ff ff ff       	call   80104f40 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104fd2:	0f b6 db             	movzbl %bl,%ebx
}
80104fd5:	89 d8                	mov    %ebx,%eax
80104fd7:	5b                   	pop    %ebx
80104fd8:	5e                   	pop    %esi
80104fd9:	5d                   	pop    %ebp
80104fda:	c3                   	ret    
80104fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fdf:	90                   	nop

80104fe0 <release>:
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
80104fe5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104fe8:	e8 03 ff ff ff       	call   80104ef0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104fed:	8b 03                	mov    (%ebx),%eax
80104fef:	85 c0                	test   %eax,%eax
80104ff1:	75 15                	jne    80105008 <release+0x28>
  popcli();
80104ff3:	e8 48 ff ff ff       	call   80104f40 <popcli>
    panic("release");
80104ff8:	83 ec 0c             	sub    $0xc,%esp
80104ffb:	68 c9 89 10 80       	push   $0x801089c9
80105000:	e8 7b b3 ff ff       	call   80100380 <panic>
80105005:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105008:	8b 73 08             	mov    0x8(%ebx),%esi
8010500b:	e8 80 e9 ff ff       	call   80103990 <mycpu>
80105010:	39 c6                	cmp    %eax,%esi
80105012:	75 df                	jne    80104ff3 <release+0x13>
  popcli();
80105014:	e8 27 ff ff ff       	call   80104f40 <popcli>
  lk->pcs[0] = 0;
80105019:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105020:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105027:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010502c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105032:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105035:	5b                   	pop    %ebx
80105036:	5e                   	pop    %esi
80105037:	5d                   	pop    %ebp
  popcli();
80105038:	e9 03 ff ff ff       	jmp    80104f40 <popcli>
8010503d:	8d 76 00             	lea    0x0(%esi),%esi

80105040 <acquire>:
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	53                   	push   %ebx
80105044:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105047:	e8 a4 fe ff ff       	call   80104ef0 <pushcli>
  if(holding(lk))
8010504c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010504f:	e8 9c fe ff ff       	call   80104ef0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105054:	8b 03                	mov    (%ebx),%eax
80105056:	85 c0                	test   %eax,%eax
80105058:	75 7e                	jne    801050d8 <acquire+0x98>
  popcli();
8010505a:	e8 e1 fe ff ff       	call   80104f40 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010505f:	b9 01 00 00 00       	mov    $0x1,%ecx
80105064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80105068:	8b 55 08             	mov    0x8(%ebp),%edx
8010506b:	89 c8                	mov    %ecx,%eax
8010506d:	f0 87 02             	lock xchg %eax,(%edx)
80105070:	85 c0                	test   %eax,%eax
80105072:	75 f4                	jne    80105068 <acquire+0x28>
  __sync_synchronize();
80105074:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105079:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010507c:	e8 0f e9 ff ff       	call   80103990 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105081:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80105084:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80105086:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80105089:	31 c0                	xor    %eax,%eax
8010508b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010508f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105090:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105096:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010509c:	77 1a                	ja     801050b8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010509e:	8b 5a 04             	mov    0x4(%edx),%ebx
801050a1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801050a5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801050a8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801050aa:	83 f8 0a             	cmp    $0xa,%eax
801050ad:	75 e1                	jne    80105090 <acquire+0x50>
}
801050af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050b2:	c9                   	leave  
801050b3:	c3                   	ret    
801050b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801050b8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801050bc:	8d 51 34             	lea    0x34(%ecx),%edx
801050bf:	90                   	nop
    pcs[i] = 0;
801050c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801050c6:	83 c0 04             	add    $0x4,%eax
801050c9:	39 c2                	cmp    %eax,%edx
801050cb:	75 f3                	jne    801050c0 <acquire+0x80>
}
801050cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050d0:	c9                   	leave  
801050d1:	c3                   	ret    
801050d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801050d8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801050db:	e8 b0 e8 ff ff       	call   80103990 <mycpu>
801050e0:	39 c3                	cmp    %eax,%ebx
801050e2:	0f 85 72 ff ff ff    	jne    8010505a <acquire+0x1a>
  popcli();
801050e8:	e8 53 fe ff ff       	call   80104f40 <popcli>
    panic("acquire");
801050ed:	83 ec 0c             	sub    $0xc,%esp
801050f0:	68 d1 89 10 80       	push   $0x801089d1
801050f5:	e8 86 b2 ff ff       	call   80100380 <panic>
801050fa:	66 90                	xchg   %ax,%ax
801050fc:	66 90                	xchg   %ax,%ax
801050fe:	66 90                	xchg   %ax,%ax

80105100 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	57                   	push   %edi
80105104:	8b 55 08             	mov    0x8(%ebp),%edx
80105107:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010510a:	53                   	push   %ebx
8010510b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010510e:	89 d7                	mov    %edx,%edi
80105110:	09 cf                	or     %ecx,%edi
80105112:	83 e7 03             	and    $0x3,%edi
80105115:	75 29                	jne    80105140 <memset+0x40>
    c &= 0xFF;
80105117:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010511a:	c1 e0 18             	shl    $0x18,%eax
8010511d:	89 fb                	mov    %edi,%ebx
8010511f:	c1 e9 02             	shr    $0x2,%ecx
80105122:	c1 e3 10             	shl    $0x10,%ebx
80105125:	09 d8                	or     %ebx,%eax
80105127:	09 f8                	or     %edi,%eax
80105129:	c1 e7 08             	shl    $0x8,%edi
8010512c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010512e:	89 d7                	mov    %edx,%edi
80105130:	fc                   	cld    
80105131:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105133:	5b                   	pop    %ebx
80105134:	89 d0                	mov    %edx,%eax
80105136:	5f                   	pop    %edi
80105137:	5d                   	pop    %ebp
80105138:	c3                   	ret    
80105139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80105140:	89 d7                	mov    %edx,%edi
80105142:	fc                   	cld    
80105143:	f3 aa                	rep stos %al,%es:(%edi)
80105145:	5b                   	pop    %ebx
80105146:	89 d0                	mov    %edx,%eax
80105148:	5f                   	pop    %edi
80105149:	5d                   	pop    %ebp
8010514a:	c3                   	ret    
8010514b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010514f:	90                   	nop

80105150 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	56                   	push   %esi
80105154:	8b 75 10             	mov    0x10(%ebp),%esi
80105157:	8b 55 08             	mov    0x8(%ebp),%edx
8010515a:	53                   	push   %ebx
8010515b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010515e:	85 f6                	test   %esi,%esi
80105160:	74 2e                	je     80105190 <memcmp+0x40>
80105162:	01 c6                	add    %eax,%esi
80105164:	eb 14                	jmp    8010517a <memcmp+0x2a>
80105166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010516d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105170:	83 c0 01             	add    $0x1,%eax
80105173:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105176:	39 f0                	cmp    %esi,%eax
80105178:	74 16                	je     80105190 <memcmp+0x40>
    if(*s1 != *s2)
8010517a:	0f b6 0a             	movzbl (%edx),%ecx
8010517d:	0f b6 18             	movzbl (%eax),%ebx
80105180:	38 d9                	cmp    %bl,%cl
80105182:	74 ec                	je     80105170 <memcmp+0x20>
      return *s1 - *s2;
80105184:	0f b6 c1             	movzbl %cl,%eax
80105187:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105189:	5b                   	pop    %ebx
8010518a:	5e                   	pop    %esi
8010518b:	5d                   	pop    %ebp
8010518c:	c3                   	ret    
8010518d:	8d 76 00             	lea    0x0(%esi),%esi
80105190:	5b                   	pop    %ebx
  return 0;
80105191:	31 c0                	xor    %eax,%eax
}
80105193:	5e                   	pop    %esi
80105194:	5d                   	pop    %ebp
80105195:	c3                   	ret    
80105196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010519d:	8d 76 00             	lea    0x0(%esi),%esi

801051a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	57                   	push   %edi
801051a4:	8b 55 08             	mov    0x8(%ebp),%edx
801051a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801051aa:	56                   	push   %esi
801051ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801051ae:	39 d6                	cmp    %edx,%esi
801051b0:	73 26                	jae    801051d8 <memmove+0x38>
801051b2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801051b5:	39 fa                	cmp    %edi,%edx
801051b7:	73 1f                	jae    801051d8 <memmove+0x38>
801051b9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801051bc:	85 c9                	test   %ecx,%ecx
801051be:	74 0c                	je     801051cc <memmove+0x2c>
      *--d = *--s;
801051c0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801051c4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801051c7:	83 e8 01             	sub    $0x1,%eax
801051ca:	73 f4                	jae    801051c0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801051cc:	5e                   	pop    %esi
801051cd:	89 d0                	mov    %edx,%eax
801051cf:	5f                   	pop    %edi
801051d0:	5d                   	pop    %ebp
801051d1:	c3                   	ret    
801051d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801051d8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801051db:	89 d7                	mov    %edx,%edi
801051dd:	85 c9                	test   %ecx,%ecx
801051df:	74 eb                	je     801051cc <memmove+0x2c>
801051e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801051e8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801051e9:	39 c6                	cmp    %eax,%esi
801051eb:	75 fb                	jne    801051e8 <memmove+0x48>
}
801051ed:	5e                   	pop    %esi
801051ee:	89 d0                	mov    %edx,%eax
801051f0:	5f                   	pop    %edi
801051f1:	5d                   	pop    %ebp
801051f2:	c3                   	ret    
801051f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105200 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105200:	eb 9e                	jmp    801051a0 <memmove>
80105202:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105210 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	56                   	push   %esi
80105214:	8b 75 10             	mov    0x10(%ebp),%esi
80105217:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010521a:	53                   	push   %ebx
8010521b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010521e:	85 f6                	test   %esi,%esi
80105220:	74 2e                	je     80105250 <strncmp+0x40>
80105222:	01 d6                	add    %edx,%esi
80105224:	eb 18                	jmp    8010523e <strncmp+0x2e>
80105226:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010522d:	8d 76 00             	lea    0x0(%esi),%esi
80105230:	38 d8                	cmp    %bl,%al
80105232:	75 14                	jne    80105248 <strncmp+0x38>
    n--, p++, q++;
80105234:	83 c2 01             	add    $0x1,%edx
80105237:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010523a:	39 f2                	cmp    %esi,%edx
8010523c:	74 12                	je     80105250 <strncmp+0x40>
8010523e:	0f b6 01             	movzbl (%ecx),%eax
80105241:	0f b6 1a             	movzbl (%edx),%ebx
80105244:	84 c0                	test   %al,%al
80105246:	75 e8                	jne    80105230 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105248:	29 d8                	sub    %ebx,%eax
}
8010524a:	5b                   	pop    %ebx
8010524b:	5e                   	pop    %esi
8010524c:	5d                   	pop    %ebp
8010524d:	c3                   	ret    
8010524e:	66 90                	xchg   %ax,%ax
80105250:	5b                   	pop    %ebx
    return 0;
80105251:	31 c0                	xor    %eax,%eax
}
80105253:	5e                   	pop    %esi
80105254:	5d                   	pop    %ebp
80105255:	c3                   	ret    
80105256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010525d:	8d 76 00             	lea    0x0(%esi),%esi

80105260 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	56                   	push   %esi
80105265:	8b 75 08             	mov    0x8(%ebp),%esi
80105268:	53                   	push   %ebx
80105269:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010526c:	89 f0                	mov    %esi,%eax
8010526e:	eb 15                	jmp    80105285 <strncpy+0x25>
80105270:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105274:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105277:	83 c0 01             	add    $0x1,%eax
8010527a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010527e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105281:	84 d2                	test   %dl,%dl
80105283:	74 09                	je     8010528e <strncpy+0x2e>
80105285:	89 cb                	mov    %ecx,%ebx
80105287:	83 e9 01             	sub    $0x1,%ecx
8010528a:	85 db                	test   %ebx,%ebx
8010528c:	7f e2                	jg     80105270 <strncpy+0x10>
    ;
  while(n-- > 0)
8010528e:	89 c2                	mov    %eax,%edx
80105290:	85 c9                	test   %ecx,%ecx
80105292:	7e 17                	jle    801052ab <strncpy+0x4b>
80105294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105298:	83 c2 01             	add    $0x1,%edx
8010529b:	89 c1                	mov    %eax,%ecx
8010529d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
801052a1:	29 d1                	sub    %edx,%ecx
801052a3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
801052a7:	85 c9                	test   %ecx,%ecx
801052a9:	7f ed                	jg     80105298 <strncpy+0x38>
  return os;
}
801052ab:	5b                   	pop    %ebx
801052ac:	89 f0                	mov    %esi,%eax
801052ae:	5e                   	pop    %esi
801052af:	5f                   	pop    %edi
801052b0:	5d                   	pop    %ebp
801052b1:	c3                   	ret    
801052b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	56                   	push   %esi
801052c4:	8b 55 10             	mov    0x10(%ebp),%edx
801052c7:	8b 75 08             	mov    0x8(%ebp),%esi
801052ca:	53                   	push   %ebx
801052cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801052ce:	85 d2                	test   %edx,%edx
801052d0:	7e 25                	jle    801052f7 <safestrcpy+0x37>
801052d2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801052d6:	89 f2                	mov    %esi,%edx
801052d8:	eb 16                	jmp    801052f0 <safestrcpy+0x30>
801052da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801052e0:	0f b6 08             	movzbl (%eax),%ecx
801052e3:	83 c0 01             	add    $0x1,%eax
801052e6:	83 c2 01             	add    $0x1,%edx
801052e9:	88 4a ff             	mov    %cl,-0x1(%edx)
801052ec:	84 c9                	test   %cl,%cl
801052ee:	74 04                	je     801052f4 <safestrcpy+0x34>
801052f0:	39 d8                	cmp    %ebx,%eax
801052f2:	75 ec                	jne    801052e0 <safestrcpy+0x20>
    ;
  *s = 0;
801052f4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801052f7:	89 f0                	mov    %esi,%eax
801052f9:	5b                   	pop    %ebx
801052fa:	5e                   	pop    %esi
801052fb:	5d                   	pop    %ebp
801052fc:	c3                   	ret    
801052fd:	8d 76 00             	lea    0x0(%esi),%esi

80105300 <strlen>:

int
strlen(const char *s)
{
80105300:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105301:	31 c0                	xor    %eax,%eax
{
80105303:	89 e5                	mov    %esp,%ebp
80105305:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105308:	80 3a 00             	cmpb   $0x0,(%edx)
8010530b:	74 0c                	je     80105319 <strlen+0x19>
8010530d:	8d 76 00             	lea    0x0(%esi),%esi
80105310:	83 c0 01             	add    $0x1,%eax
80105313:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105317:	75 f7                	jne    80105310 <strlen+0x10>
    ;
  return n;
}
80105319:	5d                   	pop    %ebp
8010531a:	c3                   	ret    

8010531b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010531b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010531f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105323:	55                   	push   %ebp
  pushl %ebx
80105324:	53                   	push   %ebx
  pushl %esi
80105325:	56                   	push   %esi
  pushl %edi
80105326:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105327:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105329:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010532b:	5f                   	pop    %edi
  popl %esi
8010532c:	5e                   	pop    %esi
  popl %ebx
8010532d:	5b                   	pop    %ebx
  popl %ebp
8010532e:	5d                   	pop    %ebp
  ret
8010532f:	c3                   	ret    

80105330 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	53                   	push   %ebx
80105334:	83 ec 04             	sub    $0x4,%esp
80105337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010533a:	e8 b1 e7 ff ff       	call   80103af0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010533f:	8b 00                	mov    (%eax),%eax
80105341:	39 d8                	cmp    %ebx,%eax
80105343:	76 1b                	jbe    80105360 <fetchint+0x30>
80105345:	8d 53 04             	lea    0x4(%ebx),%edx
80105348:	39 d0                	cmp    %edx,%eax
8010534a:	72 14                	jb     80105360 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010534c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010534f:	8b 13                	mov    (%ebx),%edx
80105351:	89 10                	mov    %edx,(%eax)
  return 0;
80105353:	31 c0                	xor    %eax,%eax
}
80105355:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105358:	c9                   	leave  
80105359:	c3                   	ret    
8010535a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105365:	eb ee                	jmp    80105355 <fetchint+0x25>
80105367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010536e:	66 90                	xchg   %ax,%ax

80105370 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	53                   	push   %ebx
80105374:	83 ec 04             	sub    $0x4,%esp
80105377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010537a:	e8 71 e7 ff ff       	call   80103af0 <myproc>

  if(addr >= curproc->sz)
8010537f:	39 18                	cmp    %ebx,(%eax)
80105381:	76 2d                	jbe    801053b0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105383:	8b 55 0c             	mov    0xc(%ebp),%edx
80105386:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105388:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010538a:	39 d3                	cmp    %edx,%ebx
8010538c:	73 22                	jae    801053b0 <fetchstr+0x40>
8010538e:	89 d8                	mov    %ebx,%eax
80105390:	eb 0d                	jmp    8010539f <fetchstr+0x2f>
80105392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105398:	83 c0 01             	add    $0x1,%eax
8010539b:	39 c2                	cmp    %eax,%edx
8010539d:	76 11                	jbe    801053b0 <fetchstr+0x40>
    if(*s == 0)
8010539f:	80 38 00             	cmpb   $0x0,(%eax)
801053a2:	75 f4                	jne    80105398 <fetchstr+0x28>
      return s - *pp;
801053a4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801053a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053a9:	c9                   	leave  
801053aa:	c3                   	ret    
801053ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053af:	90                   	nop
801053b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801053b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053b8:	c9                   	leave  
801053b9:	c3                   	ret    
801053ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801053c0 <fetchfloat>:
int
fetchfloat(uint addr, float *fp)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	53                   	push   %ebx
801053c4:	83 ec 04             	sub    $0x4,%esp
801053c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801053ca:	e8 21 e7 ff ff       	call   80103af0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801053cf:	8b 00                	mov    (%eax),%eax
801053d1:	39 d8                	cmp    %ebx,%eax
801053d3:	76 1b                	jbe    801053f0 <fetchfloat+0x30>
801053d5:	8d 53 04             	lea    0x4(%ebx),%edx
801053d8:	39 d0                	cmp    %edx,%eax
801053da:	72 14                	jb     801053f0 <fetchfloat+0x30>
    return -1;
  *fp = *(float*)(addr);
801053dc:	d9 03                	flds   (%ebx)
801053de:	8b 45 0c             	mov    0xc(%ebp),%eax
801053e1:	d9 18                	fstps  (%eax)
  return 0;
801053e3:	31 c0                	xor    %eax,%eax
}
801053e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053e8:	c9                   	leave  
801053e9:	c3                   	ret    
801053ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801053f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053f5:	eb ee                	jmp    801053e5 <fetchfloat+0x25>
801053f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053fe:	66 90                	xchg   %ax,%ax

80105400 <argint>:
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	56                   	push   %esi
80105404:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105405:	e8 e6 e6 ff ff       	call   80103af0 <myproc>
8010540a:	8b 55 08             	mov    0x8(%ebp),%edx
8010540d:	8b 40 18             	mov    0x18(%eax),%eax
80105410:	8b 40 44             	mov    0x44(%eax),%eax
80105413:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105416:	e8 d5 e6 ff ff       	call   80103af0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010541b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010541e:	8b 00                	mov    (%eax),%eax
80105420:	39 c6                	cmp    %eax,%esi
80105422:	73 1c                	jae    80105440 <argint+0x40>
80105424:	8d 53 08             	lea    0x8(%ebx),%edx
80105427:	39 d0                	cmp    %edx,%eax
80105429:	72 15                	jb     80105440 <argint+0x40>
  *ip = *(int*)(addr);
8010542b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010542e:	8b 53 04             	mov    0x4(%ebx),%edx
80105431:	89 10                	mov    %edx,(%eax)
  return 0;
80105433:	31 c0                	xor    %eax,%eax
}
80105435:	5b                   	pop    %ebx
80105436:	5e                   	pop    %esi
80105437:	5d                   	pop    %ebp
80105438:	c3                   	ret    
80105439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105445:	eb ee                	jmp    80105435 <argint+0x35>
80105447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010544e:	66 90                	xchg   %ax,%ax

80105450 <argf>:
int
argf(int n, float *fp)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	56                   	push   %esi
80105454:	53                   	push   %ebx
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105455:	e8 96 e6 ff ff       	call   80103af0 <myproc>
8010545a:	8b 55 08             	mov    0x8(%ebp),%edx
8010545d:	8b 40 18             	mov    0x18(%eax),%eax
80105460:	8b 40 44             	mov    0x44(%eax),%eax
80105463:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105466:	e8 85 e6 ff ff       	call   80103af0 <myproc>
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
8010546b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010546e:	8b 00                	mov    (%eax),%eax
80105470:	39 c6                	cmp    %eax,%esi
80105472:	73 1c                	jae    80105490 <argf+0x40>
80105474:	8d 53 08             	lea    0x8(%ebx),%edx
80105477:	39 d0                	cmp    %edx,%eax
80105479:	72 15                	jb     80105490 <argf+0x40>
  *fp = *(float*)(addr);
8010547b:	d9 43 04             	flds   0x4(%ebx)
8010547e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105481:	d9 18                	fstps  (%eax)
  return 0;
80105483:	31 c0                	xor    %eax,%eax
}
80105485:	5b                   	pop    %ebx
80105486:	5e                   	pop    %esi
80105487:	5d                   	pop    %ebp
80105488:	c3                   	ret    
80105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105495:	eb ee                	jmp    80105485 <argf+0x35>
80105497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010549e:	66 90                	xchg   %ax,%ax

801054a0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	57                   	push   %edi
801054a4:	56                   	push   %esi
801054a5:	53                   	push   %ebx
801054a6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801054a9:	e8 42 e6 ff ff       	call   80103af0 <myproc>
801054ae:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801054b0:	e8 3b e6 ff ff       	call   80103af0 <myproc>
801054b5:	8b 55 08             	mov    0x8(%ebp),%edx
801054b8:	8b 40 18             	mov    0x18(%eax),%eax
801054bb:	8b 40 44             	mov    0x44(%eax),%eax
801054be:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801054c1:	e8 2a e6 ff ff       	call   80103af0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801054c6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801054c9:	8b 00                	mov    (%eax),%eax
801054cb:	39 c7                	cmp    %eax,%edi
801054cd:	73 31                	jae    80105500 <argptr+0x60>
801054cf:	8d 4b 08             	lea    0x8(%ebx),%ecx
801054d2:	39 c8                	cmp    %ecx,%eax
801054d4:	72 2a                	jb     80105500 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801054d6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801054d9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801054dc:	85 d2                	test   %edx,%edx
801054de:	78 20                	js     80105500 <argptr+0x60>
801054e0:	8b 16                	mov    (%esi),%edx
801054e2:	39 c2                	cmp    %eax,%edx
801054e4:	76 1a                	jbe    80105500 <argptr+0x60>
801054e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801054e9:	01 c3                	add    %eax,%ebx
801054eb:	39 da                	cmp    %ebx,%edx
801054ed:	72 11                	jb     80105500 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801054ef:	8b 55 0c             	mov    0xc(%ebp),%edx
801054f2:	89 02                	mov    %eax,(%edx)
  return 0;
801054f4:	31 c0                	xor    %eax,%eax
}
801054f6:	83 c4 0c             	add    $0xc,%esp
801054f9:	5b                   	pop    %ebx
801054fa:	5e                   	pop    %esi
801054fb:	5f                   	pop    %edi
801054fc:	5d                   	pop    %ebp
801054fd:	c3                   	ret    
801054fe:	66 90                	xchg   %ax,%ax
    return -1;
80105500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105505:	eb ef                	jmp    801054f6 <argptr+0x56>
80105507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550e:	66 90                	xchg   %ax,%ax

80105510 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	56                   	push   %esi
80105514:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105515:	e8 d6 e5 ff ff       	call   80103af0 <myproc>
8010551a:	8b 55 08             	mov    0x8(%ebp),%edx
8010551d:	8b 40 18             	mov    0x18(%eax),%eax
80105520:	8b 40 44             	mov    0x44(%eax),%eax
80105523:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105526:	e8 c5 e5 ff ff       	call   80103af0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010552b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010552e:	8b 00                	mov    (%eax),%eax
80105530:	39 c6                	cmp    %eax,%esi
80105532:	73 44                	jae    80105578 <argstr+0x68>
80105534:	8d 53 08             	lea    0x8(%ebx),%edx
80105537:	39 d0                	cmp    %edx,%eax
80105539:	72 3d                	jb     80105578 <argstr+0x68>
  *ip = *(int*)(addr);
8010553b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010553e:	e8 ad e5 ff ff       	call   80103af0 <myproc>
  if(addr >= curproc->sz)
80105543:	3b 18                	cmp    (%eax),%ebx
80105545:	73 31                	jae    80105578 <argstr+0x68>
  *pp = (char*)addr;
80105547:	8b 55 0c             	mov    0xc(%ebp),%edx
8010554a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010554c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010554e:	39 d3                	cmp    %edx,%ebx
80105550:	73 26                	jae    80105578 <argstr+0x68>
80105552:	89 d8                	mov    %ebx,%eax
80105554:	eb 11                	jmp    80105567 <argstr+0x57>
80105556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010555d:	8d 76 00             	lea    0x0(%esi),%esi
80105560:	83 c0 01             	add    $0x1,%eax
80105563:	39 c2                	cmp    %eax,%edx
80105565:	76 11                	jbe    80105578 <argstr+0x68>
    if(*s == 0)
80105567:	80 38 00             	cmpb   $0x0,(%eax)
8010556a:	75 f4                	jne    80105560 <argstr+0x50>
      return s - *pp;
8010556c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010556e:	5b                   	pop    %ebx
8010556f:	5e                   	pop    %esi
80105570:	5d                   	pop    %ebp
80105571:	c3                   	ret    
80105572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105578:	5b                   	pop    %ebx
    return -1;
80105579:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010557e:	5e                   	pop    %esi
8010557f:	5d                   	pop    %ebp
80105580:	c3                   	ret    
80105581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010558f:	90                   	nop

80105590 <syscall>:
[SYS_open_sharedmem] sys_open_sharedmem
};

void
syscall(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	53                   	push   %ebx
80105594:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105597:	e8 54 e5 ff ff       	call   80103af0 <myproc>
8010559c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010559e:	8b 40 18             	mov    0x18(%eax),%eax
801055a1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801055a4:	8d 50 ff             	lea    -0x1(%eax),%edx
801055a7:	83 fa 20             	cmp    $0x20,%edx
801055aa:	77 24                	ja     801055d0 <syscall+0x40>
801055ac:	8b 14 85 00 8a 10 80 	mov    -0x7fef7600(,%eax,4),%edx
801055b3:	85 d2                	test   %edx,%edx
801055b5:	74 19                	je     801055d0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801055b7:	ff d2                	call   *%edx
801055b9:	89 c2                	mov    %eax,%edx
801055bb:	8b 43 18             	mov    0x18(%ebx),%eax
801055be:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801055c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055c4:	c9                   	leave  
801055c5:	c3                   	ret    
801055c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055cd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801055d0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801055d1:	8d 43 78             	lea    0x78(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801055d4:	50                   	push   %eax
801055d5:	ff 73 10             	push   0x10(%ebx)
801055d8:	68 d9 89 10 80       	push   $0x801089d9
801055dd:	e8 be b0 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
801055e2:	8b 43 18             	mov    0x18(%ebx),%eax
801055e5:	83 c4 10             	add    $0x10,%esp
801055e8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801055ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055f2:	c9                   	leave  
801055f3:	c3                   	ret    
801055f4:	66 90                	xchg   %ax,%ax
801055f6:	66 90                	xchg   %ax,%ax
801055f8:	66 90                	xchg   %ax,%ax
801055fa:	66 90                	xchg   %ax,%ax
801055fc:	66 90                	xchg   %ax,%ax
801055fe:	66 90                	xchg   %ax,%ax

80105600 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	57                   	push   %edi
80105604:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
80105605:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105608:	53                   	push   %ebx
80105609:	83 ec 34             	sub    $0x34,%esp
8010560c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010560f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if ((dp = nameiparent(path, name)) == 0)
80105612:	57                   	push   %edi
80105613:	50                   	push   %eax
{
80105614:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105617:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if ((dp = nameiparent(path, name)) == 0)
8010561a:	e8 a1 ca ff ff       	call   801020c0 <nameiparent>
8010561f:	83 c4 10             	add    $0x10,%esp
80105622:	85 c0                	test   %eax,%eax
80105624:	0f 84 46 01 00 00    	je     80105770 <create+0x170>
    return 0;
  ilock(dp);
8010562a:	83 ec 0c             	sub    $0xc,%esp
8010562d:	89 c3                	mov    %eax,%ebx
8010562f:	50                   	push   %eax
80105630:	e8 4b c1 ff ff       	call   80101780 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
80105635:	83 c4 0c             	add    $0xc,%esp
80105638:	6a 00                	push   $0x0
8010563a:	57                   	push   %edi
8010563b:	53                   	push   %ebx
8010563c:	e8 9f c6 ff ff       	call   80101ce0 <dirlookup>
80105641:	83 c4 10             	add    $0x10,%esp
80105644:	89 c6                	mov    %eax,%esi
80105646:	85 c0                	test   %eax,%eax
80105648:	74 56                	je     801056a0 <create+0xa0>
  {
    iunlockput(dp);
8010564a:	83 ec 0c             	sub    $0xc,%esp
8010564d:	53                   	push   %ebx
8010564e:	e8 bd c3 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80105653:	89 34 24             	mov    %esi,(%esp)
80105656:	e8 25 c1 ff ff       	call   80101780 <ilock>
    if (type == T_FILE && ip->type == T_FILE)
8010565b:	83 c4 10             	add    $0x10,%esp
8010565e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105663:	75 1b                	jne    80105680 <create+0x80>
80105665:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010566a:	75 14                	jne    80105680 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010566c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010566f:	89 f0                	mov    %esi,%eax
80105671:	5b                   	pop    %ebx
80105672:	5e                   	pop    %esi
80105673:	5f                   	pop    %edi
80105674:	5d                   	pop    %ebp
80105675:	c3                   	ret    
80105676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010567d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	56                   	push   %esi
    return 0;
80105684:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105686:	e8 85 c3 ff ff       	call   80101a10 <iunlockput>
    return 0;
8010568b:	83 c4 10             	add    $0x10,%esp
}
8010568e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105691:	89 f0                	mov    %esi,%eax
80105693:	5b                   	pop    %ebx
80105694:	5e                   	pop    %esi
80105695:	5f                   	pop    %edi
80105696:	5d                   	pop    %ebp
80105697:	c3                   	ret    
80105698:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569f:	90                   	nop
  if ((ip = ialloc(dp->dev, type)) == 0)
801056a0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801056a4:	83 ec 08             	sub    $0x8,%esp
801056a7:	50                   	push   %eax
801056a8:	ff 33                	push   (%ebx)
801056aa:	e8 61 bf ff ff       	call   80101610 <ialloc>
801056af:	83 c4 10             	add    $0x10,%esp
801056b2:	89 c6                	mov    %eax,%esi
801056b4:	85 c0                	test   %eax,%eax
801056b6:	0f 84 cd 00 00 00    	je     80105789 <create+0x189>
  ilock(ip);
801056bc:	83 ec 0c             	sub    $0xc,%esp
801056bf:	50                   	push   %eax
801056c0:	e8 bb c0 ff ff       	call   80101780 <ilock>
  ip->major = major;
801056c5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801056c9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801056cd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801056d1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801056d5:	b8 01 00 00 00       	mov    $0x1,%eax
801056da:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801056de:	89 34 24             	mov    %esi,(%esp)
801056e1:	e8 ea bf ff ff       	call   801016d0 <iupdate>
  if (type == T_DIR)
801056e6:	83 c4 10             	add    $0x10,%esp
801056e9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801056ee:	74 30                	je     80105720 <create+0x120>
  if (dirlink(dp, name, ip->inum) < 0)
801056f0:	83 ec 04             	sub    $0x4,%esp
801056f3:	ff 76 04             	push   0x4(%esi)
801056f6:	57                   	push   %edi
801056f7:	53                   	push   %ebx
801056f8:	e8 e3 c8 ff ff       	call   80101fe0 <dirlink>
801056fd:	83 c4 10             	add    $0x10,%esp
80105700:	85 c0                	test   %eax,%eax
80105702:	78 78                	js     8010577c <create+0x17c>
  iunlockput(dp);
80105704:	83 ec 0c             	sub    $0xc,%esp
80105707:	53                   	push   %ebx
80105708:	e8 03 c3 ff ff       	call   80101a10 <iunlockput>
  return ip;
8010570d:	83 c4 10             	add    $0x10,%esp
}
80105710:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105713:	89 f0                	mov    %esi,%eax
80105715:	5b                   	pop    %ebx
80105716:	5e                   	pop    %esi
80105717:	5f                   	pop    %edi
80105718:	5d                   	pop    %ebp
80105719:	c3                   	ret    
8010571a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105720:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++; // for ".."
80105723:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105728:	53                   	push   %ebx
80105729:	e8 a2 bf ff ff       	call   801016d0 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010572e:	83 c4 0c             	add    $0xc,%esp
80105731:	ff 76 04             	push   0x4(%esi)
80105734:	68 a4 8a 10 80       	push   $0x80108aa4
80105739:	56                   	push   %esi
8010573a:	e8 a1 c8 ff ff       	call   80101fe0 <dirlink>
8010573f:	83 c4 10             	add    $0x10,%esp
80105742:	85 c0                	test   %eax,%eax
80105744:	78 18                	js     8010575e <create+0x15e>
80105746:	83 ec 04             	sub    $0x4,%esp
80105749:	ff 73 04             	push   0x4(%ebx)
8010574c:	68 a3 8a 10 80       	push   $0x80108aa3
80105751:	56                   	push   %esi
80105752:	e8 89 c8 ff ff       	call   80101fe0 <dirlink>
80105757:	83 c4 10             	add    $0x10,%esp
8010575a:	85 c0                	test   %eax,%eax
8010575c:	79 92                	jns    801056f0 <create+0xf0>
      panic("create dots");
8010575e:	83 ec 0c             	sub    $0xc,%esp
80105761:	68 97 8a 10 80       	push   $0x80108a97
80105766:	e8 15 ac ff ff       	call   80100380 <panic>
8010576b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010576f:	90                   	nop
}
80105770:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105773:	31 f6                	xor    %esi,%esi
}
80105775:	5b                   	pop    %ebx
80105776:	89 f0                	mov    %esi,%eax
80105778:	5e                   	pop    %esi
80105779:	5f                   	pop    %edi
8010577a:	5d                   	pop    %ebp
8010577b:	c3                   	ret    
    panic("create: dirlink");
8010577c:	83 ec 0c             	sub    $0xc,%esp
8010577f:	68 a6 8a 10 80       	push   $0x80108aa6
80105784:	e8 f7 ab ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105789:	83 ec 0c             	sub    $0xc,%esp
8010578c:	68 88 8a 10 80       	push   $0x80108a88
80105791:	e8 ea ab ff ff       	call   80100380 <panic>
80105796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579d:	8d 76 00             	lea    0x0(%esi),%esi

801057a0 <sys_dup>:
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	56                   	push   %esi
801057a4:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
801057a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057a8:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
801057ab:	50                   	push   %eax
801057ac:	6a 00                	push   $0x0
801057ae:	e8 4d fc ff ff       	call   80105400 <argint>
801057b3:	83 c4 10             	add    $0x10,%esp
801057b6:	85 c0                	test   %eax,%eax
801057b8:	78 36                	js     801057f0 <sys_dup+0x50>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801057ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801057be:	77 30                	ja     801057f0 <sys_dup+0x50>
801057c0:	e8 2b e3 ff ff       	call   80103af0 <myproc>
801057c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057c8:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
801057cc:	85 f6                	test   %esi,%esi
801057ce:	74 20                	je     801057f0 <sys_dup+0x50>
  struct proc *curproc = myproc();
801057d0:	e8 1b e3 ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
801057d5:	31 db                	xor    %ebx,%ebx
801057d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057de:	66 90                	xchg   %ax,%ax
    if (curproc->ofile[fd] == 0)
801057e0:	8b 54 98 34          	mov    0x34(%eax,%ebx,4),%edx
801057e4:	85 d2                	test   %edx,%edx
801057e6:	74 18                	je     80105800 <sys_dup+0x60>
  for (fd = 0; fd < NOFILE; fd++)
801057e8:	83 c3 01             	add    $0x1,%ebx
801057eb:	83 fb 10             	cmp    $0x10,%ebx
801057ee:	75 f0                	jne    801057e0 <sys_dup+0x40>
}
801057f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801057f3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801057f8:	89 d8                	mov    %ebx,%eax
801057fa:	5b                   	pop    %ebx
801057fb:	5e                   	pop    %esi
801057fc:	5d                   	pop    %ebp
801057fd:	c3                   	ret    
801057fe:	66 90                	xchg   %ax,%ax
  filedup(f);
80105800:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105803:	89 74 98 34          	mov    %esi,0x34(%eax,%ebx,4)
  filedup(f);
80105807:	56                   	push   %esi
80105808:	e8 93 b6 ff ff       	call   80100ea0 <filedup>
  return fd;
8010580d:	83 c4 10             	add    $0x10,%esp
}
80105810:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105813:	89 d8                	mov    %ebx,%eax
80105815:	5b                   	pop    %ebx
80105816:	5e                   	pop    %esi
80105817:	5d                   	pop    %ebp
80105818:	c3                   	ret    
80105819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105820 <sys_read>:
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	56                   	push   %esi
80105824:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105825:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105828:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010582b:	53                   	push   %ebx
8010582c:	6a 00                	push   $0x0
8010582e:	e8 cd fb ff ff       	call   80105400 <argint>
80105833:	83 c4 10             	add    $0x10,%esp
80105836:	85 c0                	test   %eax,%eax
80105838:	78 5e                	js     80105898 <sys_read+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010583a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010583e:	77 58                	ja     80105898 <sys_read+0x78>
80105840:	e8 ab e2 ff ff       	call   80103af0 <myproc>
80105845:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105848:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
8010584c:	85 f6                	test   %esi,%esi
8010584e:	74 48                	je     80105898 <sys_read+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105850:	83 ec 08             	sub    $0x8,%esp
80105853:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105856:	50                   	push   %eax
80105857:	6a 02                	push   $0x2
80105859:	e8 a2 fb ff ff       	call   80105400 <argint>
8010585e:	83 c4 10             	add    $0x10,%esp
80105861:	85 c0                	test   %eax,%eax
80105863:	78 33                	js     80105898 <sys_read+0x78>
80105865:	83 ec 04             	sub    $0x4,%esp
80105868:	ff 75 f0             	push   -0x10(%ebp)
8010586b:	53                   	push   %ebx
8010586c:	6a 01                	push   $0x1
8010586e:	e8 2d fc ff ff       	call   801054a0 <argptr>
80105873:	83 c4 10             	add    $0x10,%esp
80105876:	85 c0                	test   %eax,%eax
80105878:	78 1e                	js     80105898 <sys_read+0x78>
  return fileread(f, p, n);
8010587a:	83 ec 04             	sub    $0x4,%esp
8010587d:	ff 75 f0             	push   -0x10(%ebp)
80105880:	ff 75 f4             	push   -0xc(%ebp)
80105883:	56                   	push   %esi
80105884:	e8 97 b7 ff ff       	call   80101020 <fileread>
80105889:	83 c4 10             	add    $0x10,%esp
}
8010588c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010588f:	5b                   	pop    %ebx
80105890:	5e                   	pop    %esi
80105891:	5d                   	pop    %ebp
80105892:	c3                   	ret    
80105893:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105897:	90                   	nop
    return -1;
80105898:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589d:	eb ed                	jmp    8010588c <sys_read+0x6c>
8010589f:	90                   	nop

801058a0 <sys_write>:
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	56                   	push   %esi
801058a4:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
801058a5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801058a8:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
801058ab:	53                   	push   %ebx
801058ac:	6a 00                	push   $0x0
801058ae:	e8 4d fb ff ff       	call   80105400 <argint>
801058b3:	83 c4 10             	add    $0x10,%esp
801058b6:	85 c0                	test   %eax,%eax
801058b8:	78 5e                	js     80105918 <sys_write+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801058ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801058be:	77 58                	ja     80105918 <sys_write+0x78>
801058c0:	e8 2b e2 ff ff       	call   80103af0 <myproc>
801058c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058c8:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
801058cc:	85 f6                	test   %esi,%esi
801058ce:	74 48                	je     80105918 <sys_write+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058d0:	83 ec 08             	sub    $0x8,%esp
801058d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058d6:	50                   	push   %eax
801058d7:	6a 02                	push   $0x2
801058d9:	e8 22 fb ff ff       	call   80105400 <argint>
801058de:	83 c4 10             	add    $0x10,%esp
801058e1:	85 c0                	test   %eax,%eax
801058e3:	78 33                	js     80105918 <sys_write+0x78>
801058e5:	83 ec 04             	sub    $0x4,%esp
801058e8:	ff 75 f0             	push   -0x10(%ebp)
801058eb:	53                   	push   %ebx
801058ec:	6a 01                	push   $0x1
801058ee:	e8 ad fb ff ff       	call   801054a0 <argptr>
801058f3:	83 c4 10             	add    $0x10,%esp
801058f6:	85 c0                	test   %eax,%eax
801058f8:	78 1e                	js     80105918 <sys_write+0x78>
  return filewrite(f, p, n);
801058fa:	83 ec 04             	sub    $0x4,%esp
801058fd:	ff 75 f0             	push   -0x10(%ebp)
80105900:	ff 75 f4             	push   -0xc(%ebp)
80105903:	56                   	push   %esi
80105904:	e8 a7 b7 ff ff       	call   801010b0 <filewrite>
80105909:	83 c4 10             	add    $0x10,%esp
}
8010590c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010590f:	5b                   	pop    %ebx
80105910:	5e                   	pop    %esi
80105911:	5d                   	pop    %ebp
80105912:	c3                   	ret    
80105913:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105917:	90                   	nop
    return -1;
80105918:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010591d:	eb ed                	jmp    8010590c <sys_write+0x6c>
8010591f:	90                   	nop

80105920 <sys_close>:
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	56                   	push   %esi
80105924:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105925:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105928:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010592b:	50                   	push   %eax
8010592c:	6a 00                	push   $0x0
8010592e:	e8 cd fa ff ff       	call   80105400 <argint>
80105933:	83 c4 10             	add    $0x10,%esp
80105936:	85 c0                	test   %eax,%eax
80105938:	78 3e                	js     80105978 <sys_close+0x58>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010593a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010593e:	77 38                	ja     80105978 <sys_close+0x58>
80105940:	e8 ab e1 ff ff       	call   80103af0 <myproc>
80105945:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105948:	8d 5a 0c             	lea    0xc(%edx),%ebx
8010594b:	8b 74 98 04          	mov    0x4(%eax,%ebx,4),%esi
8010594f:	85 f6                	test   %esi,%esi
80105951:	74 25                	je     80105978 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105953:	e8 98 e1 ff ff       	call   80103af0 <myproc>
  fileclose(f);
80105958:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010595b:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
80105962:	00 
  fileclose(f);
80105963:	56                   	push   %esi
80105964:	e8 87 b5 ff ff       	call   80100ef0 <fileclose>
  return 0;
80105969:	83 c4 10             	add    $0x10,%esp
8010596c:	31 c0                	xor    %eax,%eax
}
8010596e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105971:	5b                   	pop    %ebx
80105972:	5e                   	pop    %esi
80105973:	5d                   	pop    %ebp
80105974:	c3                   	ret    
80105975:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105978:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010597d:	eb ef                	jmp    8010596e <sys_close+0x4e>
8010597f:	90                   	nop

80105980 <sys_fstat>:
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	56                   	push   %esi
80105984:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105985:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105988:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010598b:	53                   	push   %ebx
8010598c:	6a 00                	push   $0x0
8010598e:	e8 6d fa ff ff       	call   80105400 <argint>
80105993:	83 c4 10             	add    $0x10,%esp
80105996:	85 c0                	test   %eax,%eax
80105998:	78 46                	js     801059e0 <sys_fstat+0x60>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010599a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010599e:	77 40                	ja     801059e0 <sys_fstat+0x60>
801059a0:	e8 4b e1 ff ff       	call   80103af0 <myproc>
801059a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059a8:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
801059ac:	85 f6                	test   %esi,%esi
801059ae:	74 30                	je     801059e0 <sys_fstat+0x60>
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
801059b0:	83 ec 04             	sub    $0x4,%esp
801059b3:	6a 14                	push   $0x14
801059b5:	53                   	push   %ebx
801059b6:	6a 01                	push   $0x1
801059b8:	e8 e3 fa ff ff       	call   801054a0 <argptr>
801059bd:	83 c4 10             	add    $0x10,%esp
801059c0:	85 c0                	test   %eax,%eax
801059c2:	78 1c                	js     801059e0 <sys_fstat+0x60>
  return filestat(f, st);
801059c4:	83 ec 08             	sub    $0x8,%esp
801059c7:	ff 75 f4             	push   -0xc(%ebp)
801059ca:	56                   	push   %esi
801059cb:	e8 00 b6 ff ff       	call   80100fd0 <filestat>
801059d0:	83 c4 10             	add    $0x10,%esp
}
801059d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059d6:	5b                   	pop    %ebx
801059d7:	5e                   	pop    %esi
801059d8:	5d                   	pop    %ebp
801059d9:	c3                   	ret    
801059da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801059e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059e5:	eb ec                	jmp    801059d3 <sys_fstat+0x53>
801059e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ee:	66 90                	xchg   %ax,%ax

801059f0 <sys_link>:
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059f5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801059f8:	53                   	push   %ebx
801059f9:	83 ec 34             	sub    $0x34,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059fc:	50                   	push   %eax
801059fd:	6a 00                	push   $0x0
801059ff:	e8 0c fb ff ff       	call   80105510 <argstr>
80105a04:	83 c4 10             	add    $0x10,%esp
80105a07:	85 c0                	test   %eax,%eax
80105a09:	0f 88 fb 00 00 00    	js     80105b0a <sys_link+0x11a>
80105a0f:	83 ec 08             	sub    $0x8,%esp
80105a12:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105a15:	50                   	push   %eax
80105a16:	6a 01                	push   $0x1
80105a18:	e8 f3 fa ff ff       	call   80105510 <argstr>
80105a1d:	83 c4 10             	add    $0x10,%esp
80105a20:	85 c0                	test   %eax,%eax
80105a22:	0f 88 e2 00 00 00    	js     80105b0a <sys_link+0x11a>
  begin_op();
80105a28:	e8 33 d3 ff ff       	call   80102d60 <begin_op>
  if ((ip = namei(old)) == 0)
80105a2d:	83 ec 0c             	sub    $0xc,%esp
80105a30:	ff 75 d4             	push   -0x2c(%ebp)
80105a33:	e8 68 c6 ff ff       	call   801020a0 <namei>
80105a38:	83 c4 10             	add    $0x10,%esp
80105a3b:	89 c3                	mov    %eax,%ebx
80105a3d:	85 c0                	test   %eax,%eax
80105a3f:	0f 84 e4 00 00 00    	je     80105b29 <sys_link+0x139>
  ilock(ip);
80105a45:	83 ec 0c             	sub    $0xc,%esp
80105a48:	50                   	push   %eax
80105a49:	e8 32 bd ff ff       	call   80101780 <ilock>
  if (ip->type == T_DIR)
80105a4e:	83 c4 10             	add    $0x10,%esp
80105a51:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a56:	0f 84 b5 00 00 00    	je     80105b11 <sys_link+0x121>
  iupdate(ip);
80105a5c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105a5f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if ((dp = nameiparent(new, name)) == 0)
80105a64:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105a67:	53                   	push   %ebx
80105a68:	e8 63 bc ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
80105a6d:	89 1c 24             	mov    %ebx,(%esp)
80105a70:	e8 eb bd ff ff       	call   80101860 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
80105a75:	58                   	pop    %eax
80105a76:	5a                   	pop    %edx
80105a77:	57                   	push   %edi
80105a78:	ff 75 d0             	push   -0x30(%ebp)
80105a7b:	e8 40 c6 ff ff       	call   801020c0 <nameiparent>
80105a80:	83 c4 10             	add    $0x10,%esp
80105a83:	89 c6                	mov    %eax,%esi
80105a85:	85 c0                	test   %eax,%eax
80105a87:	74 5b                	je     80105ae4 <sys_link+0xf4>
  ilock(dp);
80105a89:	83 ec 0c             	sub    $0xc,%esp
80105a8c:	50                   	push   %eax
80105a8d:	e8 ee bc ff ff       	call   80101780 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
80105a92:	8b 03                	mov    (%ebx),%eax
80105a94:	83 c4 10             	add    $0x10,%esp
80105a97:	39 06                	cmp    %eax,(%esi)
80105a99:	75 3d                	jne    80105ad8 <sys_link+0xe8>
80105a9b:	83 ec 04             	sub    $0x4,%esp
80105a9e:	ff 73 04             	push   0x4(%ebx)
80105aa1:	57                   	push   %edi
80105aa2:	56                   	push   %esi
80105aa3:	e8 38 c5 ff ff       	call   80101fe0 <dirlink>
80105aa8:	83 c4 10             	add    $0x10,%esp
80105aab:	85 c0                	test   %eax,%eax
80105aad:	78 29                	js     80105ad8 <sys_link+0xe8>
  iunlockput(dp);
80105aaf:	83 ec 0c             	sub    $0xc,%esp
80105ab2:	56                   	push   %esi
80105ab3:	e8 58 bf ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105ab8:	89 1c 24             	mov    %ebx,(%esp)
80105abb:	e8 f0 bd ff ff       	call   801018b0 <iput>
  end_op();
80105ac0:	e8 0b d3 ff ff       	call   80102dd0 <end_op>
  return 0;
80105ac5:	83 c4 10             	add    $0x10,%esp
80105ac8:	31 c0                	xor    %eax,%eax
}
80105aca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105acd:	5b                   	pop    %ebx
80105ace:	5e                   	pop    %esi
80105acf:	5f                   	pop    %edi
80105ad0:	5d                   	pop    %ebp
80105ad1:	c3                   	ret    
80105ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105ad8:	83 ec 0c             	sub    $0xc,%esp
80105adb:	56                   	push   %esi
80105adc:	e8 2f bf ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105ae1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105ae4:	83 ec 0c             	sub    $0xc,%esp
80105ae7:	53                   	push   %ebx
80105ae8:	e8 93 bc ff ff       	call   80101780 <ilock>
  ip->nlink--;
80105aed:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105af2:	89 1c 24             	mov    %ebx,(%esp)
80105af5:	e8 d6 bb ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105afa:	89 1c 24             	mov    %ebx,(%esp)
80105afd:	e8 0e bf ff ff       	call   80101a10 <iunlockput>
  end_op();
80105b02:	e8 c9 d2 ff ff       	call   80102dd0 <end_op>
  return -1;
80105b07:	83 c4 10             	add    $0x10,%esp
80105b0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b0f:	eb b9                	jmp    80105aca <sys_link+0xda>
    iunlockput(ip);
80105b11:	83 ec 0c             	sub    $0xc,%esp
80105b14:	53                   	push   %ebx
80105b15:	e8 f6 be ff ff       	call   80101a10 <iunlockput>
    end_op();
80105b1a:	e8 b1 d2 ff ff       	call   80102dd0 <end_op>
    return -1;
80105b1f:	83 c4 10             	add    $0x10,%esp
80105b22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b27:	eb a1                	jmp    80105aca <sys_link+0xda>
    end_op();
80105b29:	e8 a2 d2 ff ff       	call   80102dd0 <end_op>
    return -1;
80105b2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b33:	eb 95                	jmp    80105aca <sys_link+0xda>
80105b35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b40 <sys_unlink>:
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	57                   	push   %edi
80105b44:	56                   	push   %esi
  if (argstr(0, &path) < 0)
80105b45:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105b48:	53                   	push   %ebx
80105b49:	83 ec 54             	sub    $0x54,%esp
  if (argstr(0, &path) < 0)
80105b4c:	50                   	push   %eax
80105b4d:	6a 00                	push   $0x0
80105b4f:	e8 bc f9 ff ff       	call   80105510 <argstr>
80105b54:	83 c4 10             	add    $0x10,%esp
80105b57:	85 c0                	test   %eax,%eax
80105b59:	0f 88 7a 01 00 00    	js     80105cd9 <sys_unlink+0x199>
  begin_op();
80105b5f:	e8 fc d1 ff ff       	call   80102d60 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
80105b64:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105b67:	83 ec 08             	sub    $0x8,%esp
80105b6a:	53                   	push   %ebx
80105b6b:	ff 75 c0             	push   -0x40(%ebp)
80105b6e:	e8 4d c5 ff ff       	call   801020c0 <nameiparent>
80105b73:	83 c4 10             	add    $0x10,%esp
80105b76:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105b79:	85 c0                	test   %eax,%eax
80105b7b:	0f 84 62 01 00 00    	je     80105ce3 <sys_unlink+0x1a3>
  ilock(dp);
80105b81:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105b84:	83 ec 0c             	sub    $0xc,%esp
80105b87:	57                   	push   %edi
80105b88:	e8 f3 bb ff ff       	call   80101780 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b8d:	58                   	pop    %eax
80105b8e:	5a                   	pop    %edx
80105b8f:	68 a4 8a 10 80       	push   $0x80108aa4
80105b94:	53                   	push   %ebx
80105b95:	e8 26 c1 ff ff       	call   80101cc0 <namecmp>
80105b9a:	83 c4 10             	add    $0x10,%esp
80105b9d:	85 c0                	test   %eax,%eax
80105b9f:	0f 84 fb 00 00 00    	je     80105ca0 <sys_unlink+0x160>
80105ba5:	83 ec 08             	sub    $0x8,%esp
80105ba8:	68 a3 8a 10 80       	push   $0x80108aa3
80105bad:	53                   	push   %ebx
80105bae:	e8 0d c1 ff ff       	call   80101cc0 <namecmp>
80105bb3:	83 c4 10             	add    $0x10,%esp
80105bb6:	85 c0                	test   %eax,%eax
80105bb8:	0f 84 e2 00 00 00    	je     80105ca0 <sys_unlink+0x160>
  if ((ip = dirlookup(dp, name, &off)) == 0)
80105bbe:	83 ec 04             	sub    $0x4,%esp
80105bc1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105bc4:	50                   	push   %eax
80105bc5:	53                   	push   %ebx
80105bc6:	57                   	push   %edi
80105bc7:	e8 14 c1 ff ff       	call   80101ce0 <dirlookup>
80105bcc:	83 c4 10             	add    $0x10,%esp
80105bcf:	89 c3                	mov    %eax,%ebx
80105bd1:	85 c0                	test   %eax,%eax
80105bd3:	0f 84 c7 00 00 00    	je     80105ca0 <sys_unlink+0x160>
  ilock(ip);
80105bd9:	83 ec 0c             	sub    $0xc,%esp
80105bdc:	50                   	push   %eax
80105bdd:	e8 9e bb ff ff       	call   80101780 <ilock>
  if (ip->nlink < 1)
80105be2:	83 c4 10             	add    $0x10,%esp
80105be5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105bea:	0f 8e 1c 01 00 00    	jle    80105d0c <sys_unlink+0x1cc>
  if (ip->type == T_DIR && !isdirempty(ip))
80105bf0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105bf5:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105bf8:	74 66                	je     80105c60 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105bfa:	83 ec 04             	sub    $0x4,%esp
80105bfd:	6a 10                	push   $0x10
80105bff:	6a 00                	push   $0x0
80105c01:	57                   	push   %edi
80105c02:	e8 f9 f4 ff ff       	call   80105100 <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80105c07:	6a 10                	push   $0x10
80105c09:	ff 75 c4             	push   -0x3c(%ebp)
80105c0c:	57                   	push   %edi
80105c0d:	ff 75 b4             	push   -0x4c(%ebp)
80105c10:	e8 7b bf ff ff       	call   80101b90 <writei>
80105c15:	83 c4 20             	add    $0x20,%esp
80105c18:	83 f8 10             	cmp    $0x10,%eax
80105c1b:	0f 85 de 00 00 00    	jne    80105cff <sys_unlink+0x1bf>
  if (ip->type == T_DIR)
80105c21:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c26:	0f 84 94 00 00 00    	je     80105cc0 <sys_unlink+0x180>
  iunlockput(dp);
80105c2c:	83 ec 0c             	sub    $0xc,%esp
80105c2f:	ff 75 b4             	push   -0x4c(%ebp)
80105c32:	e8 d9 bd ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105c37:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105c3c:	89 1c 24             	mov    %ebx,(%esp)
80105c3f:	e8 8c ba ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105c44:	89 1c 24             	mov    %ebx,(%esp)
80105c47:	e8 c4 bd ff ff       	call   80101a10 <iunlockput>
  end_op();
80105c4c:	e8 7f d1 ff ff       	call   80102dd0 <end_op>
  return 0;
80105c51:	83 c4 10             	add    $0x10,%esp
80105c54:	31 c0                	xor    %eax,%eax
}
80105c56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c59:	5b                   	pop    %ebx
80105c5a:	5e                   	pop    %esi
80105c5b:	5f                   	pop    %edi
80105c5c:	5d                   	pop    %ebp
80105c5d:	c3                   	ret    
80105c5e:	66 90                	xchg   %ax,%ax
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
80105c60:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105c64:	76 94                	jbe    80105bfa <sys_unlink+0xba>
80105c66:	be 20 00 00 00       	mov    $0x20,%esi
80105c6b:	eb 0b                	jmp    80105c78 <sys_unlink+0x138>
80105c6d:	8d 76 00             	lea    0x0(%esi),%esi
80105c70:	83 c6 10             	add    $0x10,%esi
80105c73:	3b 73 58             	cmp    0x58(%ebx),%esi
80105c76:	73 82                	jae    80105bfa <sys_unlink+0xba>
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80105c78:	6a 10                	push   $0x10
80105c7a:	56                   	push   %esi
80105c7b:	57                   	push   %edi
80105c7c:	53                   	push   %ebx
80105c7d:	e8 0e be ff ff       	call   80101a90 <readi>
80105c82:	83 c4 10             	add    $0x10,%esp
80105c85:	83 f8 10             	cmp    $0x10,%eax
80105c88:	75 68                	jne    80105cf2 <sys_unlink+0x1b2>
    if (de.inum != 0)
80105c8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105c8f:	74 df                	je     80105c70 <sys_unlink+0x130>
    iunlockput(ip);
80105c91:	83 ec 0c             	sub    $0xc,%esp
80105c94:	53                   	push   %ebx
80105c95:	e8 76 bd ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105c9a:	83 c4 10             	add    $0x10,%esp
80105c9d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105ca0:	83 ec 0c             	sub    $0xc,%esp
80105ca3:	ff 75 b4             	push   -0x4c(%ebp)
80105ca6:	e8 65 bd ff ff       	call   80101a10 <iunlockput>
  end_op();
80105cab:	e8 20 d1 ff ff       	call   80102dd0 <end_op>
  return -1;
80105cb0:	83 c4 10             	add    $0x10,%esp
80105cb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cb8:	eb 9c                	jmp    80105c56 <sys_unlink+0x116>
80105cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105cc0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105cc3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105cc6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105ccb:	50                   	push   %eax
80105ccc:	e8 ff b9 ff ff       	call   801016d0 <iupdate>
80105cd1:	83 c4 10             	add    $0x10,%esp
80105cd4:	e9 53 ff ff ff       	jmp    80105c2c <sys_unlink+0xec>
    return -1;
80105cd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cde:	e9 73 ff ff ff       	jmp    80105c56 <sys_unlink+0x116>
    end_op();
80105ce3:	e8 e8 d0 ff ff       	call   80102dd0 <end_op>
    return -1;
80105ce8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ced:	e9 64 ff ff ff       	jmp    80105c56 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105cf2:	83 ec 0c             	sub    $0xc,%esp
80105cf5:	68 c8 8a 10 80       	push   $0x80108ac8
80105cfa:	e8 81 a6 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105cff:	83 ec 0c             	sub    $0xc,%esp
80105d02:	68 da 8a 10 80       	push   $0x80108ada
80105d07:	e8 74 a6 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105d0c:	83 ec 0c             	sub    $0xc,%esp
80105d0f:	68 b6 8a 10 80       	push   $0x80108ab6
80105d14:	e8 67 a6 ff ff       	call   80100380 <panic>
80105d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d20 <sys_open>:

int sys_open(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	57                   	push   %edi
80105d24:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d25:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105d28:	53                   	push   %ebx
80105d29:	83 ec 24             	sub    $0x24,%esp
  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d2c:	50                   	push   %eax
80105d2d:	6a 00                	push   $0x0
80105d2f:	e8 dc f7 ff ff       	call   80105510 <argstr>
80105d34:	83 c4 10             	add    $0x10,%esp
80105d37:	85 c0                	test   %eax,%eax
80105d39:	0f 88 8e 00 00 00    	js     80105dcd <sys_open+0xad>
80105d3f:	83 ec 08             	sub    $0x8,%esp
80105d42:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d45:	50                   	push   %eax
80105d46:	6a 01                	push   $0x1
80105d48:	e8 b3 f6 ff ff       	call   80105400 <argint>
80105d4d:	83 c4 10             	add    $0x10,%esp
80105d50:	85 c0                	test   %eax,%eax
80105d52:	78 79                	js     80105dcd <sys_open+0xad>
    return -1;

  begin_op();
80105d54:	e8 07 d0 ff ff       	call   80102d60 <begin_op>

  if (omode & O_CREATE)
80105d59:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105d5d:	75 79                	jne    80105dd8 <sys_open+0xb8>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(path)) == 0)
80105d5f:	83 ec 0c             	sub    $0xc,%esp
80105d62:	ff 75 e0             	push   -0x20(%ebp)
80105d65:	e8 36 c3 ff ff       	call   801020a0 <namei>
80105d6a:	83 c4 10             	add    $0x10,%esp
80105d6d:	89 c6                	mov    %eax,%esi
80105d6f:	85 c0                	test   %eax,%eax
80105d71:	0f 84 7e 00 00 00    	je     80105df5 <sys_open+0xd5>
    {
      end_op();
      return -1;
    }
    ilock(ip);
80105d77:	83 ec 0c             	sub    $0xc,%esp
80105d7a:	50                   	push   %eax
80105d7b:	e8 00 ba ff ff       	call   80101780 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
80105d80:	83 c4 10             	add    $0x10,%esp
80105d83:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105d88:	0f 84 c2 00 00 00    	je     80105e50 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80105d8e:	e8 9d b0 ff ff       	call   80100e30 <filealloc>
80105d93:	89 c7                	mov    %eax,%edi
80105d95:	85 c0                	test   %eax,%eax
80105d97:	74 23                	je     80105dbc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105d99:	e8 52 dd ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105d9e:	31 db                	xor    %ebx,%ebx
    if (curproc->ofile[fd] == 0)
80105da0:	8b 54 98 34          	mov    0x34(%eax,%ebx,4),%edx
80105da4:	85 d2                	test   %edx,%edx
80105da6:	74 60                	je     80105e08 <sys_open+0xe8>
  for (fd = 0; fd < NOFILE; fd++)
80105da8:	83 c3 01             	add    $0x1,%ebx
80105dab:	83 fb 10             	cmp    $0x10,%ebx
80105dae:	75 f0                	jne    80105da0 <sys_open+0x80>
  {
    if (f)
      fileclose(f);
80105db0:	83 ec 0c             	sub    $0xc,%esp
80105db3:	57                   	push   %edi
80105db4:	e8 37 b1 ff ff       	call   80100ef0 <fileclose>
80105db9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105dbc:	83 ec 0c             	sub    $0xc,%esp
80105dbf:	56                   	push   %esi
80105dc0:	e8 4b bc ff ff       	call   80101a10 <iunlockput>
    end_op();
80105dc5:	e8 06 d0 ff ff       	call   80102dd0 <end_op>
    return -1;
80105dca:	83 c4 10             	add    $0x10,%esp
80105dcd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105dd2:	eb 6d                	jmp    80105e41 <sys_open+0x121>
80105dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105dd8:	83 ec 0c             	sub    $0xc,%esp
80105ddb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105dde:	31 c9                	xor    %ecx,%ecx
80105de0:	ba 02 00 00 00       	mov    $0x2,%edx
80105de5:	6a 00                	push   $0x0
80105de7:	e8 14 f8 ff ff       	call   80105600 <create>
    if (ip == 0)
80105dec:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105def:	89 c6                	mov    %eax,%esi
    if (ip == 0)
80105df1:	85 c0                	test   %eax,%eax
80105df3:	75 99                	jne    80105d8e <sys_open+0x6e>
      end_op();
80105df5:	e8 d6 cf ff ff       	call   80102dd0 <end_op>
      return -1;
80105dfa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105dff:	eb 40                	jmp    80105e41 <sys_open+0x121>
80105e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105e08:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105e0b:	89 7c 98 34          	mov    %edi,0x34(%eax,%ebx,4)
  iunlock(ip);
80105e0f:	56                   	push   %esi
80105e10:	e8 4b ba ff ff       	call   80101860 <iunlock>
  end_op();
80105e15:	e8 b6 cf ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
80105e1a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105e20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e23:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105e26:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105e29:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105e2b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105e32:	f7 d0                	not    %eax
80105e34:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e37:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105e3a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e3d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105e41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e44:	89 d8                	mov    %ebx,%eax
80105e46:	5b                   	pop    %ebx
80105e47:	5e                   	pop    %esi
80105e48:	5f                   	pop    %edi
80105e49:	5d                   	pop    %ebp
80105e4a:	c3                   	ret    
80105e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e4f:	90                   	nop
    if (ip->type == T_DIR && omode != O_RDONLY)
80105e50:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105e53:	85 c9                	test   %ecx,%ecx
80105e55:	0f 84 33 ff ff ff    	je     80105d8e <sys_open+0x6e>
80105e5b:	e9 5c ff ff ff       	jmp    80105dbc <sys_open+0x9c>

80105e60 <sys_mkdir>:

int sys_mkdir(void)
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105e66:	e8 f5 ce ff ff       	call   80102d60 <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
80105e6b:	83 ec 08             	sub    $0x8,%esp
80105e6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e71:	50                   	push   %eax
80105e72:	6a 00                	push   $0x0
80105e74:	e8 97 f6 ff ff       	call   80105510 <argstr>
80105e79:	83 c4 10             	add    $0x10,%esp
80105e7c:	85 c0                	test   %eax,%eax
80105e7e:	78 30                	js     80105eb0 <sys_mkdir+0x50>
80105e80:	83 ec 0c             	sub    $0xc,%esp
80105e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e86:	31 c9                	xor    %ecx,%ecx
80105e88:	ba 01 00 00 00       	mov    $0x1,%edx
80105e8d:	6a 00                	push   $0x0
80105e8f:	e8 6c f7 ff ff       	call   80105600 <create>
80105e94:	83 c4 10             	add    $0x10,%esp
80105e97:	85 c0                	test   %eax,%eax
80105e99:	74 15                	je     80105eb0 <sys_mkdir+0x50>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e9b:	83 ec 0c             	sub    $0xc,%esp
80105e9e:	50                   	push   %eax
80105e9f:	e8 6c bb ff ff       	call   80101a10 <iunlockput>
  end_op();
80105ea4:	e8 27 cf ff ff       	call   80102dd0 <end_op>
  return 0;
80105ea9:	83 c4 10             	add    $0x10,%esp
80105eac:	31 c0                	xor    %eax,%eax
}
80105eae:	c9                   	leave  
80105eaf:	c3                   	ret    
    end_op();
80105eb0:	e8 1b cf ff ff       	call   80102dd0 <end_op>
    return -1;
80105eb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eba:	c9                   	leave  
80105ebb:	c3                   	ret    
80105ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ec0 <sys_mknod>:

int sys_mknod(void)
{
80105ec0:	55                   	push   %ebp
80105ec1:	89 e5                	mov    %esp,%ebp
80105ec3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105ec6:	e8 95 ce ff ff       	call   80102d60 <begin_op>
  if ((argstr(0, &path)) < 0 ||
80105ecb:	83 ec 08             	sub    $0x8,%esp
80105ece:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ed1:	50                   	push   %eax
80105ed2:	6a 00                	push   $0x0
80105ed4:	e8 37 f6 ff ff       	call   80105510 <argstr>
80105ed9:	83 c4 10             	add    $0x10,%esp
80105edc:	85 c0                	test   %eax,%eax
80105ede:	78 60                	js     80105f40 <sys_mknod+0x80>
      argint(1, &major) < 0 ||
80105ee0:	83 ec 08             	sub    $0x8,%esp
80105ee3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ee6:	50                   	push   %eax
80105ee7:	6a 01                	push   $0x1
80105ee9:	e8 12 f5 ff ff       	call   80105400 <argint>
  if ((argstr(0, &path)) < 0 ||
80105eee:	83 c4 10             	add    $0x10,%esp
80105ef1:	85 c0                	test   %eax,%eax
80105ef3:	78 4b                	js     80105f40 <sys_mknod+0x80>
      argint(2, &minor) < 0 ||
80105ef5:	83 ec 08             	sub    $0x8,%esp
80105ef8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105efb:	50                   	push   %eax
80105efc:	6a 02                	push   $0x2
80105efe:	e8 fd f4 ff ff       	call   80105400 <argint>
      argint(1, &major) < 0 ||
80105f03:	83 c4 10             	add    $0x10,%esp
80105f06:	85 c0                	test   %eax,%eax
80105f08:	78 36                	js     80105f40 <sys_mknod+0x80>
      (ip = create(path, T_DEV, major, minor)) == 0)
80105f0a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105f0e:	83 ec 0c             	sub    $0xc,%esp
80105f11:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105f15:	ba 03 00 00 00       	mov    $0x3,%edx
80105f1a:	50                   	push   %eax
80105f1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f1e:	e8 dd f6 ff ff       	call   80105600 <create>
      argint(2, &minor) < 0 ||
80105f23:	83 c4 10             	add    $0x10,%esp
80105f26:	85 c0                	test   %eax,%eax
80105f28:	74 16                	je     80105f40 <sys_mknod+0x80>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80105f2a:	83 ec 0c             	sub    $0xc,%esp
80105f2d:	50                   	push   %eax
80105f2e:	e8 dd ba ff ff       	call   80101a10 <iunlockput>
  end_op();
80105f33:	e8 98 ce ff ff       	call   80102dd0 <end_op>
  return 0;
80105f38:	83 c4 10             	add    $0x10,%esp
80105f3b:	31 c0                	xor    %eax,%eax
}
80105f3d:	c9                   	leave  
80105f3e:	c3                   	ret    
80105f3f:	90                   	nop
    end_op();
80105f40:	e8 8b ce ff ff       	call   80102dd0 <end_op>
    return -1;
80105f45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f4a:	c9                   	leave  
80105f4b:	c3                   	ret    
80105f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f50 <sys_chdir>:

int sys_chdir(void)
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	56                   	push   %esi
80105f54:	53                   	push   %ebx
80105f55:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105f58:	e8 93 db ff ff       	call   80103af0 <myproc>
80105f5d:	89 c6                	mov    %eax,%esi

  begin_op();
80105f5f:	e8 fc cd ff ff       	call   80102d60 <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105f64:	83 ec 08             	sub    $0x8,%esp
80105f67:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f6a:	50                   	push   %eax
80105f6b:	6a 00                	push   $0x0
80105f6d:	e8 9e f5 ff ff       	call   80105510 <argstr>
80105f72:	83 c4 10             	add    $0x10,%esp
80105f75:	85 c0                	test   %eax,%eax
80105f77:	78 77                	js     80105ff0 <sys_chdir+0xa0>
80105f79:	83 ec 0c             	sub    $0xc,%esp
80105f7c:	ff 75 f4             	push   -0xc(%ebp)
80105f7f:	e8 1c c1 ff ff       	call   801020a0 <namei>
80105f84:	83 c4 10             	add    $0x10,%esp
80105f87:	89 c3                	mov    %eax,%ebx
80105f89:	85 c0                	test   %eax,%eax
80105f8b:	74 63                	je     80105ff0 <sys_chdir+0xa0>
  {
    end_op();
    return -1;
  }
  ilock(ip);
80105f8d:	83 ec 0c             	sub    $0xc,%esp
80105f90:	50                   	push   %eax
80105f91:	e8 ea b7 ff ff       	call   80101780 <ilock>
  if (ip->type != T_DIR)
80105f96:	83 c4 10             	add    $0x10,%esp
80105f99:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105f9e:	75 30                	jne    80105fd0 <sys_chdir+0x80>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105fa0:	83 ec 0c             	sub    $0xc,%esp
80105fa3:	53                   	push   %ebx
80105fa4:	e8 b7 b8 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105fa9:	58                   	pop    %eax
80105faa:	ff 76 74             	push   0x74(%esi)
80105fad:	e8 fe b8 ff ff       	call   801018b0 <iput>
  end_op();
80105fb2:	e8 19 ce ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80105fb7:	89 5e 74             	mov    %ebx,0x74(%esi)
  return 0;
80105fba:	83 c4 10             	add    $0x10,%esp
80105fbd:	31 c0                	xor    %eax,%eax
}
80105fbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fc2:	5b                   	pop    %ebx
80105fc3:	5e                   	pop    %esi
80105fc4:	5d                   	pop    %ebp
80105fc5:	c3                   	ret    
80105fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fcd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105fd0:	83 ec 0c             	sub    $0xc,%esp
80105fd3:	53                   	push   %ebx
80105fd4:	e8 37 ba ff ff       	call   80101a10 <iunlockput>
    end_op();
80105fd9:	e8 f2 cd ff ff       	call   80102dd0 <end_op>
    return -1;
80105fde:	83 c4 10             	add    $0x10,%esp
80105fe1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe6:	eb d7                	jmp    80105fbf <sys_chdir+0x6f>
80105fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fef:	90                   	nop
    end_op();
80105ff0:	e8 db cd ff ff       	call   80102dd0 <end_op>
    return -1;
80105ff5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ffa:	eb c3                	jmp    80105fbf <sys_chdir+0x6f>
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106000 <sys_exec>:

int sys_exec(void)
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	57                   	push   %edi
80106004:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80106005:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010600b:	53                   	push   %ebx
8010600c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80106012:	50                   	push   %eax
80106013:	6a 00                	push   $0x0
80106015:	e8 f6 f4 ff ff       	call   80105510 <argstr>
8010601a:	83 c4 10             	add    $0x10,%esp
8010601d:	85 c0                	test   %eax,%eax
8010601f:	0f 88 87 00 00 00    	js     801060ac <sys_exec+0xac>
80106025:	83 ec 08             	sub    $0x8,%esp
80106028:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010602e:	50                   	push   %eax
8010602f:	6a 01                	push   $0x1
80106031:	e8 ca f3 ff ff       	call   80105400 <argint>
80106036:	83 c4 10             	add    $0x10,%esp
80106039:	85 c0                	test   %eax,%eax
8010603b:	78 6f                	js     801060ac <sys_exec+0xac>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010603d:	83 ec 04             	sub    $0x4,%esp
80106040:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for (i = 0;; i++)
80106046:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106048:	68 80 00 00 00       	push   $0x80
8010604d:	6a 00                	push   $0x0
8010604f:	56                   	push   %esi
80106050:	e8 ab f0 ff ff       	call   80105100 <memset>
80106055:	83 c4 10             	add    $0x10,%esp
80106058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605f:	90                   	nop
  {
    if (i >= NELEM(argv))
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80106060:	83 ec 08             	sub    $0x8,%esp
80106063:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80106069:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106070:	50                   	push   %eax
80106071:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106077:	01 f8                	add    %edi,%eax
80106079:	50                   	push   %eax
8010607a:	e8 b1 f2 ff ff       	call   80105330 <fetchint>
8010607f:	83 c4 10             	add    $0x10,%esp
80106082:	85 c0                	test   %eax,%eax
80106084:	78 26                	js     801060ac <sys_exec+0xac>
      return -1;
    if (uarg == 0)
80106086:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010608c:	85 c0                	test   %eax,%eax
8010608e:	74 30                	je     801060c0 <sys_exec+0xc0>
    {
      argv[i] = 0;
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
80106090:	83 ec 08             	sub    $0x8,%esp
80106093:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80106096:	52                   	push   %edx
80106097:	50                   	push   %eax
80106098:	e8 d3 f2 ff ff       	call   80105370 <fetchstr>
8010609d:	83 c4 10             	add    $0x10,%esp
801060a0:	85 c0                	test   %eax,%eax
801060a2:	78 08                	js     801060ac <sys_exec+0xac>
  for (i = 0;; i++)
801060a4:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
801060a7:	83 fb 20             	cmp    $0x20,%ebx
801060aa:	75 b4                	jne    80106060 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801060ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801060af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060b4:	5b                   	pop    %ebx
801060b5:	5e                   	pop    %esi
801060b6:	5f                   	pop    %edi
801060b7:	5d                   	pop    %ebp
801060b8:	c3                   	ret    
801060b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801060c0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801060c7:	00 00 00 00 
  return exec(path, argv);
801060cb:	83 ec 08             	sub    $0x8,%esp
801060ce:	56                   	push   %esi
801060cf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801060d5:	e8 d6 a9 ff ff       	call   80100ab0 <exec>
801060da:	83 c4 10             	add    $0x10,%esp
}
801060dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060e0:	5b                   	pop    %ebx
801060e1:	5e                   	pop    %esi
801060e2:	5f                   	pop    %edi
801060e3:	5d                   	pop    %ebp
801060e4:	c3                   	ret    
801060e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060f0 <sys_pipe>:

int sys_pipe(void)
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	57                   	push   %edi
801060f4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
801060f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801060f8:	53                   	push   %ebx
801060f9:	83 ec 20             	sub    $0x20,%esp
  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
801060fc:	6a 08                	push   $0x8
801060fe:	50                   	push   %eax
801060ff:	6a 00                	push   $0x0
80106101:	e8 9a f3 ff ff       	call   801054a0 <argptr>
80106106:	83 c4 10             	add    $0x10,%esp
80106109:	85 c0                	test   %eax,%eax
8010610b:	78 4a                	js     80106157 <sys_pipe+0x67>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
8010610d:	83 ec 08             	sub    $0x8,%esp
80106110:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106113:	50                   	push   %eax
80106114:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106117:	50                   	push   %eax
80106118:	e8 13 d3 ff ff       	call   80103430 <pipealloc>
8010611d:	83 c4 10             	add    $0x10,%esp
80106120:	85 c0                	test   %eax,%eax
80106122:	78 33                	js     80106157 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80106124:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (fd = 0; fd < NOFILE; fd++)
80106127:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106129:	e8 c2 d9 ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
8010612e:	66 90                	xchg   %ax,%ax
    if (curproc->ofile[fd] == 0)
80106130:	8b 74 98 34          	mov    0x34(%eax,%ebx,4),%esi
80106134:	85 f6                	test   %esi,%esi
80106136:	74 28                	je     80106160 <sys_pipe+0x70>
  for (fd = 0; fd < NOFILE; fd++)
80106138:	83 c3 01             	add    $0x1,%ebx
8010613b:	83 fb 10             	cmp    $0x10,%ebx
8010613e:	75 f0                	jne    80106130 <sys_pipe+0x40>
  {
    if (fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106140:	83 ec 0c             	sub    $0xc,%esp
80106143:	ff 75 e0             	push   -0x20(%ebp)
80106146:	e8 a5 ad ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010614b:	58                   	pop    %eax
8010614c:	ff 75 e4             	push   -0x1c(%ebp)
8010614f:	e8 9c ad ff ff       	call   80100ef0 <fileclose>
    return -1;
80106154:	83 c4 10             	add    $0x10,%esp
80106157:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010615c:	eb 53                	jmp    801061b1 <sys_pipe+0xc1>
8010615e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106160:	8d 73 0c             	lea    0xc(%ebx),%esi
80106163:	89 7c b0 04          	mov    %edi,0x4(%eax,%esi,4)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80106167:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010616a:	e8 81 d9 ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
8010616f:	31 d2                	xor    %edx,%edx
80106171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd] == 0)
80106178:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
8010617c:	85 c9                	test   %ecx,%ecx
8010617e:	74 20                	je     801061a0 <sys_pipe+0xb0>
  for (fd = 0; fd < NOFILE; fd++)
80106180:	83 c2 01             	add    $0x1,%edx
80106183:	83 fa 10             	cmp    $0x10,%edx
80106186:	75 f0                	jne    80106178 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80106188:	e8 63 d9 ff ff       	call   80103af0 <myproc>
8010618d:	c7 44 b0 04 00 00 00 	movl   $0x0,0x4(%eax,%esi,4)
80106194:	00 
80106195:	eb a9                	jmp    80106140 <sys_pipe+0x50>
80106197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010619e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801061a0:	89 7c 90 34          	mov    %edi,0x34(%eax,%edx,4)
  }
  fd[0] = fd0;
801061a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801061a7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801061a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801061ac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801061af:	31 c0                	xor    %eax,%eax
}
801061b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061b4:	5b                   	pop    %ebx
801061b5:	5e                   	pop    %esi
801061b6:	5f                   	pop    %edi
801061b7:	5d                   	pop    %ebp
801061b8:	c3                   	ret    
801061b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061c0 <sys_copy_file>:
}



int sys_copy_file(void)
{
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
801061c3:	57                   	push   %edi
801061c4:	56                   	push   %esi
801061c5:	53                   	push   %ebx
801061c6:	81 ec 00 10 00 00    	sub    $0x1000,%esp
801061cc:	83 0c 24 00          	orl    $0x0,(%esp)
801061d0:	83 ec 34             	sub    $0x34,%esp
  char *dest;
  int fd;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &src) < 0 || argstr(1, &dest) < 0)
801061d3:	8d 85 e0 ef ff ff    	lea    -0x1020(%ebp),%eax
801061d9:	50                   	push   %eax
801061da:	6a 00                	push   $0x0
801061dc:	e8 2f f3 ff ff       	call   80105510 <argstr>
801061e1:	83 c4 10             	add    $0x10,%esp
801061e4:	85 c0                	test   %eax,%eax
801061e6:	0f 88 81 01 00 00    	js     8010636d <sys_copy_file+0x1ad>
801061ec:	83 ec 08             	sub    $0x8,%esp
801061ef:	8d 85 e4 ef ff ff    	lea    -0x101c(%ebp),%eax
801061f5:	50                   	push   %eax
801061f6:	6a 01                	push   $0x1
801061f8:	e8 13 f3 ff ff       	call   80105510 <argstr>
801061fd:	83 c4 10             	add    $0x10,%esp
80106200:	85 c0                	test   %eax,%eax
80106202:	0f 88 65 01 00 00    	js     8010636d <sys_copy_file+0x1ad>
    return -1;

  begin_op();
80106208:	e8 53 cb ff ff       	call   80102d60 <begin_op>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(src)) == 0)
8010620d:	83 ec 0c             	sub    $0xc,%esp
80106210:	ff b5 e0 ef ff ff    	push   -0x1020(%ebp)
80106216:	e8 85 be ff ff       	call   801020a0 <namei>
8010621b:	83 c4 10             	add    $0x10,%esp
8010621e:	89 c6                	mov    %eax,%esi
80106220:	85 c0                	test   %eax,%eax
80106222:	0f 84 c0 01 00 00    	je     801063e8 <sys_copy_file+0x228>
    {
      end_op();
      return -1;
    }
    ilock(ip);
80106228:	83 ec 0c             	sub    $0xc,%esp
8010622b:	50                   	push   %eax
8010622c:	e8 4f b5 ff ff       	call   80101780 <ilock>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80106231:	e8 fa ab ff ff       	call   80100e30 <filealloc>
80106236:	83 c4 10             	add    $0x10,%esp
80106239:	89 c7                	mov    %eax,%edi
8010623b:	85 c0                	test   %eax,%eax
8010623d:	74 2d                	je     8010626c <sys_copy_file+0xac>
  struct proc *curproc = myproc();
8010623f:	e8 ac d8 ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80106244:	31 d2                	xor    %edx,%edx
80106246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010624d:	8d 76 00             	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
80106250:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
80106254:	85 c9                	test   %ecx,%ecx
80106256:	74 38                	je     80106290 <sys_copy_file+0xd0>
  for (fd = 0; fd < NOFILE; fd++)
80106258:	83 c2 01             	add    $0x1,%edx
8010625b:	83 fa 10             	cmp    $0x10,%edx
8010625e:	75 f0                	jne    80106250 <sys_copy_file+0x90>
  {
    if (f)
      fileclose(f);
80106260:	83 ec 0c             	sub    $0xc,%esp
80106263:	57                   	push   %edi
80106264:	e8 87 ac ff ff       	call   80100ef0 <fileclose>
80106269:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010626c:	83 ec 0c             	sub    $0xc,%esp
8010626f:	56                   	push   %esi
80106270:	e8 9b b7 ff ff       	call   80101a10 <iunlockput>
    end_op();
80106275:	e8 56 cb ff ff       	call   80102dd0 <end_op>
    return -1;
8010627a:	83 c4 10             	add    $0x10,%esp
8010627d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106282:	e9 59 01 00 00       	jmp    801063e0 <sys_copy_file+0x220>
80106287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010628e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106290:	8d 5a 0c             	lea    0xc(%edx),%ebx
  }
  iunlock(ip);
80106293:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106296:	89 7c 98 04          	mov    %edi,0x4(%eax,%ebx,4)
  iunlock(ip);
8010629a:	56                   	push   %esi
8010629b:	e8 c0 b5 ff ff       	call   80101860 <iunlock>
  end_op();
801062a0:	e8 2b cb ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(O_RDONLY & O_WRONLY);
801062a5:	b8 01 00 00 00       	mov    $0x1,%eax
  f->ip = ip;
801062aa:	89 77 10             	mov    %esi,0x10(%edi)
  f->type = FD_INODE;
801062ad:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->off = 0;
801062b3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(O_RDONLY & O_WRONLY);
801062ba:	66 89 47 08          	mov    %ax,0x8(%edi)
  if((f = myproc() -> ofile[fd]) == 0){
801062be:	e8 2d d8 ff ff       	call   80103af0 <myproc>
801062c3:	83 c4 10             	add    $0x10,%esp
801062c6:	8b 44 98 04          	mov    0x4(%eax,%ebx,4),%eax
801062ca:	85 c0                	test   %eax,%eax
801062cc:	0f 84 9b 00 00 00    	je     8010636d <sys_copy_file+0x1ad>
  f->writable = (O_RDONLY & O_WRONLY) || (O_RDONLY & O_RDWR);
  
  char p[4096];
  if (my_argfd(0, 0, &f, fd) < 0)
      return -1;
  int read_chars = fileread(f, p, 4096);
801062d2:	83 ec 04             	sub    $0x4,%esp
801062d5:	8d bd e8 ef ff ff    	lea    -0x1018(%ebp),%edi
801062db:	68 00 10 00 00       	push   $0x1000
801062e0:	57                   	push   %edi
801062e1:	50                   	push   %eax
801062e2:	e8 39 ad ff ff       	call   80101020 <fileread>
801062e7:	89 85 d4 ef ff ff    	mov    %eax,-0x102c(%ebp)
  //dest
  int fd2;
  struct file *f2;
  struct inode *ip2;
  begin_op();
801062ed:	e8 6e ca ff ff       	call   80102d60 <begin_op>
      return -1;
    }
  }
  else
  {
    if ((ip2 = namei(dest)) == 0)
801062f2:	58                   	pop    %eax
801062f3:	ff b5 e4 ef ff ff    	push   -0x101c(%ebp)
801062f9:	e8 a2 bd ff ff       	call   801020a0 <namei>
801062fe:	83 c4 10             	add    $0x10,%esp
80106301:	89 c3                	mov    %eax,%ebx
80106303:	85 c0                	test   %eax,%eax
80106305:	0f 84 dd 00 00 00    	je     801063e8 <sys_copy_file+0x228>
    {
      end_op();
      return -1;
    }
    ilock(ip2);
8010630b:	83 ec 0c             	sub    $0xc,%esp
8010630e:	50                   	push   %eax
8010630f:	e8 6c b4 ff ff       	call   80101780 <ilock>
    if (ip2->type == T_DIR && dest != O_RDONLY)
80106314:	83 c4 10             	add    $0x10,%esp
80106317:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010631c:	75 0a                	jne    80106328 <sys_copy_file+0x168>
8010631e:	8b b5 e4 ef ff ff    	mov    -0x101c(%ebp),%esi
80106324:	85 f6                	test   %esi,%esi
80106326:	75 34                	jne    8010635c <sys_copy_file+0x19c>
      end_op();
      return -1;
    }
  }

  if ((f2 = filealloc()) == 0 || (fd2 = fdalloc(f2)) < 0)
80106328:	e8 03 ab ff ff       	call   80100e30 <filealloc>
8010632d:	89 c6                	mov    %eax,%esi
8010632f:	85 c0                	test   %eax,%eax
80106331:	74 29                	je     8010635c <sys_copy_file+0x19c>
  struct proc *curproc = myproc();
80106333:	e8 b8 d7 ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80106338:	31 d2                	xor    %edx,%edx
8010633a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
80106340:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
80106344:	85 c9                	test   %ecx,%ecx
80106346:	74 30                	je     80106378 <sys_copy_file+0x1b8>
  for (fd = 0; fd < NOFILE; fd++)
80106348:	83 c2 01             	add    $0x1,%edx
8010634b:	83 fa 10             	cmp    $0x10,%edx
8010634e:	75 f0                	jne    80106340 <sys_copy_file+0x180>
  {
    if (f2)
      fileclose(f2);
80106350:	83 ec 0c             	sub    $0xc,%esp
80106353:	56                   	push   %esi
80106354:	e8 97 ab ff ff       	call   80100ef0 <fileclose>
80106359:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip2);
8010635c:	83 ec 0c             	sub    $0xc,%esp
8010635f:	53                   	push   %ebx
80106360:	e8 ab b6 ff ff       	call   80101a10 <iunlockput>
    end_op();
80106365:	e8 66 ca ff ff       	call   80102dd0 <end_op>
    return -1;
8010636a:	83 c4 10             	add    $0x10,%esp
8010636d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106372:	eb 6c                	jmp    801063e0 <sys_copy_file+0x220>
80106374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80106378:	83 c2 0c             	add    $0xc,%edx
  }
  iunlock(ip2);
8010637b:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010637e:	89 74 90 04          	mov    %esi,0x4(%eax,%edx,4)
  iunlock(ip2);
80106382:	53                   	push   %ebx
      curproc->ofile[fd] = f;
80106383:	89 95 d0 ef ff ff    	mov    %edx,-0x1030(%ebp)
  iunlock(ip2);
80106389:	e8 d2 b4 ff ff       	call   80101860 <iunlock>
  end_op();
8010638e:	e8 3d ca ff ff       	call   80102dd0 <end_op>

  f2->type = FD_INODE;
  f2->ip = ip2;
  f2->off = 0;
  f2->readable = !(O_WRONLY & O_WRONLY);
80106393:	b8 00 01 00 00       	mov    $0x100,%eax
  f2->ip = ip2;
80106398:	89 5e 10             	mov    %ebx,0x10(%esi)
  f2->type = FD_INODE;
8010639b:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f2->off = 0;
801063a1:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f2->readable = !(O_WRONLY & O_WRONLY);
801063a8:	66 89 46 08          	mov    %ax,0x8(%esi)
  if((f = myproc() -> ofile[fd]) == 0){
801063ac:	e8 3f d7 ff ff       	call   80103af0 <myproc>
801063b1:	8b 95 d0 ef ff ff    	mov    -0x1030(%ebp),%edx
801063b7:	83 c4 10             	add    $0x10,%esp
801063ba:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801063be:	85 c0                	test   %eax,%eax
801063c0:	74 ab                	je     8010636d <sys_copy_file+0x1ad>
  f2->writable = (O_WRONLY & O_WRONLY) || (O_WRONLY & O_RDWR);
  if (my_argfd(0, 0, &f2, fd2) < 0)
      return -1;   
  int written_chars = filewrite(f2, p, read_chars);
801063c2:	8b 9d d4 ef ff ff    	mov    -0x102c(%ebp),%ebx
801063c8:	83 ec 04             	sub    $0x4,%esp
801063cb:	53                   	push   %ebx
801063cc:	57                   	push   %edi
801063cd:	50                   	push   %eax
801063ce:	e8 dd ac ff ff       	call   801010b0 <filewrite>
  if(written_chars != read_chars){
801063d3:	83 c4 10             	add    $0x10,%esp
801063d6:	39 c3                	cmp    %eax,%ebx
801063d8:	0f 95 c0             	setne  %al
801063db:	0f b6 c0             	movzbl %al,%eax
801063de:	f7 d8                	neg    %eax
    return -1;
  }
  else{
    return 0;
  }
801063e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063e3:	5b                   	pop    %ebx
801063e4:	5e                   	pop    %esi
801063e5:	5f                   	pop    %edi
801063e6:	5d                   	pop    %ebp
801063e7:	c3                   	ret    
      end_op();
801063e8:	e8 e3 c9 ff ff       	call   80102dd0 <end_op>
      return -1;
801063ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063f2:	eb ec                	jmp    801063e0 <sys_copy_file+0x220>
801063f4:	66 90                	xchg   %ax,%ax
801063f6:	66 90                	xchg   %ax,%ax
801063f8:	66 90                	xchg   %ax,%ax
801063fa:	66 90                	xchg   %ax,%ax
801063fc:	66 90                	xchg   %ax,%ax
801063fe:	66 90                	xchg   %ax,%ax

80106400 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int sys_fork(void)
{
  return fork();
80106400:	e9 0b de ff ff       	jmp    80104210 <fork>
80106405:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010640c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106410 <sys_exit>:
}

int sys_exit(void)
{
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	83 ec 08             	sub    $0x8,%esp
  exit();
80106416:	e8 25 e3 ff ff       	call   80104740 <exit>
  return 0; // not reached
}
8010641b:	31 c0                	xor    %eax,%eax
8010641d:	c9                   	leave  
8010641e:	c3                   	ret    
8010641f:	90                   	nop

80106420 <sys_wait>:

int sys_wait(void)
{
  return wait();
80106420:	e9 4b e4 ff ff       	jmp    80104870 <wait>
80106425:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010642c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106430 <sys_kill>:
}

int sys_kill(void)
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80106436:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106439:	50                   	push   %eax
8010643a:	6a 00                	push   $0x0
8010643c:	e8 bf ef ff ff       	call   80105400 <argint>
80106441:	83 c4 10             	add    $0x10,%esp
80106444:	85 c0                	test   %eax,%eax
80106446:	78 18                	js     80106460 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106448:	83 ec 0c             	sub    $0xc,%esp
8010644b:	ff 75 f4             	push   -0xc(%ebp)
8010644e:	e8 fd e6 ff ff       	call   80104b50 <kill>
80106453:	83 c4 10             	add    $0x10,%esp
}
80106456:	c9                   	leave  
80106457:	c3                   	ret    
80106458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010645f:	90                   	nop
80106460:	c9                   	leave  
    return -1;
80106461:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106466:	c3                   	ret    
80106467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010646e:	66 90                	xchg   %ax,%ax

80106470 <sys_getpid>:

int sys_getpid(void)
{
80106470:	55                   	push   %ebp
80106471:	89 e5                	mov    %esp,%ebp
80106473:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106476:	e8 75 d6 ff ff       	call   80103af0 <myproc>
8010647b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010647e:	c9                   	leave  
8010647f:	c3                   	ret    

80106480 <sys_sbrk>:

int sys_sbrk(void)
{
80106480:	55                   	push   %ebp
80106481:	89 e5                	mov    %esp,%ebp
80106483:	53                   	push   %ebx
  int addr;
  int n;

  if (argint(0, &n) < 0)
80106484:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106487:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
8010648a:	50                   	push   %eax
8010648b:	6a 00                	push   $0x0
8010648d:	e8 6e ef ff ff       	call   80105400 <argint>
80106492:	83 c4 10             	add    $0x10,%esp
80106495:	85 c0                	test   %eax,%eax
80106497:	78 27                	js     801064c0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106499:	e8 52 d6 ff ff       	call   80103af0 <myproc>
  if (growproc(n) < 0)
8010649e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801064a1:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
801064a3:	ff 75 f4             	push   -0xc(%ebp)
801064a6:	e8 e5 dc ff ff       	call   80104190 <growproc>
801064ab:	83 c4 10             	add    $0x10,%esp
801064ae:	85 c0                	test   %eax,%eax
801064b0:	78 0e                	js     801064c0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801064b2:	89 d8                	mov    %ebx,%eax
801064b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064b7:	c9                   	leave  
801064b8:	c3                   	ret    
801064b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801064c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801064c5:	eb eb                	jmp    801064b2 <sys_sbrk+0x32>
801064c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ce:	66 90                	xchg   %ax,%ax

801064d0 <sys_sleep>:

int sys_sleep(void)
{
801064d0:	55                   	push   %ebp
801064d1:	89 e5                	mov    %esp,%ebp
801064d3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
801064d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801064d7:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
801064da:	50                   	push   %eax
801064db:	6a 00                	push   $0x0
801064dd:	e8 1e ef ff ff       	call   80105400 <argint>
801064e2:	83 c4 10             	add    $0x10,%esp
801064e5:	85 c0                	test   %eax,%eax
801064e7:	0f 88 8a 00 00 00    	js     80106577 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801064ed:	83 ec 0c             	sub    $0xc,%esp
801064f0:	68 00 58 11 80       	push   $0x80115800
801064f5:	e8 46 eb ff ff       	call   80105040 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
801064fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801064fd:	8b 1d e0 57 11 80    	mov    0x801157e0,%ebx
  while (ticks - ticks0 < n)
80106503:	83 c4 10             	add    $0x10,%esp
80106506:	85 d2                	test   %edx,%edx
80106508:	75 27                	jne    80106531 <sys_sleep+0x61>
8010650a:	eb 54                	jmp    80106560 <sys_sleep+0x90>
8010650c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106510:	83 ec 08             	sub    $0x8,%esp
80106513:	68 00 58 11 80       	push   $0x80115800
80106518:	68 e0 57 11 80       	push   $0x801157e0
8010651d:	e8 0e e5 ff ff       	call   80104a30 <sleep>
  while (ticks - ticks0 < n)
80106522:	a1 e0 57 11 80       	mov    0x801157e0,%eax
80106527:	83 c4 10             	add    $0x10,%esp
8010652a:	29 d8                	sub    %ebx,%eax
8010652c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010652f:	73 2f                	jae    80106560 <sys_sleep+0x90>
    if (myproc()->killed)
80106531:	e8 ba d5 ff ff       	call   80103af0 <myproc>
80106536:	8b 40 30             	mov    0x30(%eax),%eax
80106539:	85 c0                	test   %eax,%eax
8010653b:	74 d3                	je     80106510 <sys_sleep+0x40>
      release(&tickslock);
8010653d:	83 ec 0c             	sub    $0xc,%esp
80106540:	68 00 58 11 80       	push   $0x80115800
80106545:	e8 96 ea ff ff       	call   80104fe0 <release>
  }
  release(&tickslock);
  return 0;
}
8010654a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010654d:	83 c4 10             	add    $0x10,%esp
80106550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106555:	c9                   	leave  
80106556:	c3                   	ret    
80106557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010655e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106560:	83 ec 0c             	sub    $0xc,%esp
80106563:	68 00 58 11 80       	push   $0x80115800
80106568:	e8 73 ea ff ff       	call   80104fe0 <release>
  return 0;
8010656d:	83 c4 10             	add    $0x10,%esp
80106570:	31 c0                	xor    %eax,%eax
}
80106572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106575:	c9                   	leave  
80106576:	c3                   	ret    
    return -1;
80106577:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010657c:	eb f4                	jmp    80106572 <sys_sleep+0xa2>
8010657e:	66 90                	xchg   %ax,%ax

80106580 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80106580:	55                   	push   %ebp
80106581:	89 e5                	mov    %esp,%ebp
80106583:	53                   	push   %ebx
80106584:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106587:	68 00 58 11 80       	push   $0x80115800
8010658c:	e8 af ea ff ff       	call   80105040 <acquire>
  xticks = ticks;
80106591:	8b 1d e0 57 11 80    	mov    0x801157e0,%ebx
  release(&tickslock);
80106597:	c7 04 24 00 58 11 80 	movl   $0x80115800,(%esp)
8010659e:	e8 3d ea ff ff       	call   80104fe0 <release>
  return xticks;
}
801065a3:	89 d8                	mov    %ebx,%eax
801065a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801065a8:	c9                   	leave  
801065a9:	c3                   	ret    
801065aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801065b0 <sys_find_digital_root>:

int sys_find_digital_root(void)
{
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	83 ec 08             	sub    $0x8,%esp
  int number = myproc()->tf->ebx; // register after eax
801065b6:	e8 35 d5 ff ff       	call   80103af0 <myproc>
  return find_digital_root(number);
801065bb:	83 ec 0c             	sub    $0xc,%esp
  int number = myproc()->tf->ebx; // register after eax
801065be:	8b 40 18             	mov    0x18(%eax),%eax
  return find_digital_root(number);
801065c1:	ff 70 10             	push   0x10(%eax)
801065c4:	e8 c7 e6 ff ff       	call   80104c90 <find_digital_root>
}
801065c9:	c9                   	leave  
801065ca:	c3                   	ret    
801065cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065cf:	90                   	nop

801065d0 <sys_get_uncle_count>:

int sys_get_uncle_count(void)
{
801065d0:	55                   	push   %ebp
801065d1:	89 e5                	mov    %esp,%ebp
801065d3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
801065d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065d9:	50                   	push   %eax
801065da:	6a 00                	push   $0x0
801065dc:	e8 1f ee ff ff       	call   80105400 <argint>
801065e1:	83 c4 10             	add    $0x10,%esp
801065e4:	85 c0                	test   %eax,%eax
801065e6:	78 28                	js     80106610 <sys_get_uncle_count+0x40>
  {
    return -1;
  }
  struct proc *grandFather = find_proc(pid)->parent->parent;
801065e8:	83 ec 0c             	sub    $0xc,%esp
801065eb:	ff 75 f4             	push   -0xc(%ebp)
801065ee:	e8 cd d6 ff ff       	call   80103cc0 <find_proc>
  return count_child(grandFather) - 1;
801065f3:	5a                   	pop    %edx
  struct proc *grandFather = find_proc(pid)->parent->parent;
801065f4:	8b 40 14             	mov    0x14(%eax),%eax
  return count_child(grandFather) - 1;
801065f7:	ff 70 14             	push   0x14(%eax)
801065fa:	e8 31 db ff ff       	call   80104130 <count_child>
801065ff:	83 c4 10             	add    $0x10,%esp
}
80106602:	c9                   	leave  
  return count_child(grandFather) - 1;
80106603:	83 e8 01             	sub    $0x1,%eax
}
80106606:	c3                   	ret    
80106607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010660e:	66 90                	xchg   %ax,%ax
80106610:	c9                   	leave  
    return -1;
80106611:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106616:	c3                   	ret    
80106617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010661e:	66 90                	xchg   %ax,%ax

80106620 <sys_get_process_lifetime>:
int sys_get_process_lifetime(void)
{
80106620:	55                   	push   %ebp
80106621:	89 e5                	mov    %esp,%ebp
80106623:	53                   	push   %ebx
  int pid;
  if (argint(0, &pid) < 0)
80106624:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106627:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0)
8010662a:	50                   	push   %eax
8010662b:	6a 00                	push   $0x0
8010662d:	e8 ce ed ff ff       	call   80105400 <argint>
80106632:	83 c4 10             	add    $0x10,%esp
80106635:	85 c0                	test   %eax,%eax
80106637:	78 27                	js     80106660 <sys_get_process_lifetime+0x40>
  {
    return -1;
  }
  return ticks - (find_proc(pid)->creation_time);
80106639:	83 ec 0c             	sub    $0xc,%esp
8010663c:	ff 75 f4             	push   -0xc(%ebp)
8010663f:	8b 1d e0 57 11 80    	mov    0x801157e0,%ebx
80106645:	e8 76 d6 ff ff       	call   80103cc0 <find_proc>
8010664a:	83 c4 10             	add    $0x10,%esp
8010664d:	2b 58 20             	sub    0x20(%eax),%ebx
80106650:	89 d8                	mov    %ebx,%eax
}
80106652:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106655:	c9                   	leave  
80106656:	c3                   	ret    
80106657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010665e:	66 90                	xchg   %ax,%ax
    return -1;
80106660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106665:	eb eb                	jmp    80106652 <sys_get_process_lifetime+0x32>
80106667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010666e:	66 90                	xchg   %ax,%ax

80106670 <sys_set_date>:
void sys_set_date(void)
{
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *r;
  if (argptr(0, (void *)&r, sizeof(*r)) < 0)
80106676:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106679:	6a 18                	push   $0x18
8010667b:	50                   	push   %eax
8010667c:	6a 00                	push   $0x0
8010667e:	e8 1d ee ff ff       	call   801054a0 <argptr>
80106683:	83 c4 10             	add    $0x10,%esp
80106686:	85 c0                	test   %eax,%eax
80106688:	78 16                	js     801066a0 <sys_set_date+0x30>
    cprintf("Kernel: sys_set_date() has a problem.\n");

  cmostime(r);
8010668a:	83 ec 0c             	sub    $0xc,%esp
8010668d:	ff 75 f4             	push   -0xc(%ebp)
80106690:	e8 3b c3 ff ff       	call   801029d0 <cmostime>
}
80106695:	83 c4 10             	add    $0x10,%esp
80106698:	c9                   	leave  
80106699:	c3                   	ret    
8010669a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("Kernel: sys_set_date() has a problem.\n");
801066a0:	83 ec 0c             	sub    $0xc,%esp
801066a3:	68 ec 8a 10 80       	push   $0x80108aec
801066a8:	e8 f3 9f ff ff       	call   801006a0 <cprintf>
801066ad:	83 c4 10             	add    $0x10,%esp
  cmostime(r);
801066b0:	83 ec 0c             	sub    $0xc,%esp
801066b3:	ff 75 f4             	push   -0xc(%ebp)
801066b6:	e8 15 c3 ff ff       	call   801029d0 <cmostime>
}
801066bb:	83 c4 10             	add    $0x10,%esp
801066be:	c9                   	leave  
801066bf:	c3                   	ret    

801066c0 <sys_get_pid>:
801066c0:	55                   	push   %ebp
801066c1:	89 e5                	mov    %esp,%ebp
801066c3:	83 ec 08             	sub    $0x8,%esp
801066c6:	e8 25 d4 ff ff       	call   80103af0 <myproc>
801066cb:	8b 40 10             	mov    0x10(%eax),%eax
801066ce:	c9                   	leave  
801066cf:	c3                   	ret    

801066d0 <sys_get_parent>:
int sys_get_pid(void)
{
  return myproc()->pid;
}
int sys_get_parent(void)
{
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
801066d6:	e8 15 d4 ff ff       	call   80103af0 <myproc>
801066db:	8b 40 14             	mov    0x14(%eax),%eax
801066de:	8b 40 10             	mov    0x10(%eax),%eax
}
801066e1:	c9                   	leave  
801066e2:	c3                   	ret    
801066e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801066f0 <sys_change_queue>:
int sys_change_queue(void)
{
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	53                   	push   %ebx
  int pid, que_id;
  if (argint(0, &pid) < 0 || argint(1, &que_id))
801066f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
801066f7:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0 || argint(1, &que_id))
801066fa:	50                   	push   %eax
801066fb:	6a 00                	push   $0x0
801066fd:	e8 fe ec ff ff       	call   80105400 <argint>
80106702:	83 c4 10             	add    $0x10,%esp
80106705:	85 c0                	test   %eax,%eax
80106707:	78 47                	js     80106750 <sys_change_queue+0x60>
80106709:	83 ec 08             	sub    $0x8,%esp
8010670c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010670f:	50                   	push   %eax
80106710:	6a 01                	push   $0x1
80106712:	e8 e9 ec ff ff       	call   80105400 <argint>
80106717:	83 c4 10             	add    $0x10,%esp
8010671a:	89 c3                	mov    %eax,%ebx
8010671c:	85 c0                	test   %eax,%eax
8010671e:	75 30                	jne    80106750 <sys_change_queue+0x60>
    return -1;
  cprintf("%d\n", que_id);
80106720:	83 ec 08             	sub    $0x8,%esp
80106723:	ff 75 f4             	push   -0xc(%ebp)
80106726:	68 34 87 10 80       	push   $0x80108734
8010672b:	e8 70 9f ff ff       	call   801006a0 <cprintf>
  struct proc *p = find_proc(pid);
80106730:	58                   	pop    %eax
80106731:	ff 75 f0             	push   -0x10(%ebp)
80106734:	e8 87 d5 ff ff       	call   80103cc0 <find_proc>
  p->que_id = que_id;
80106739:	8b 55 f4             	mov    -0xc(%ebp),%edx
  return 0;
8010673c:	83 c4 10             	add    $0x10,%esp
  p->que_id = que_id;
8010673f:	89 50 28             	mov    %edx,0x28(%eax)
}
80106742:	89 d8                	mov    %ebx,%eax
80106744:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106747:	c9                   	leave  
80106748:	c3                   	ret    
80106749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106750:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106755:	eb eb                	jmp    80106742 <sys_change_queue+0x52>
80106757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010675e:	66 90                	xchg   %ax,%ax

80106760 <sys_bjf_validation_process>:
int sys_bjf_validation_process(void)
{
80106760:	55                   	push   %ebp
80106761:	89 e5                	mov    %esp,%ebp
80106763:	83 ec 30             	sub    $0x30,%esp
  
  int pid;
  int priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argint(0, &pid) < 0 || argint(1, &priority_ratio) < 0 || argint(2, &creation_time_ratio) < 0 || argint(3, &exec_cycle_ratio) < 0 || argint(4, &size_ratio) < 0)
80106766:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106769:	50                   	push   %eax
8010676a:	6a 00                	push   $0x0
8010676c:	e8 8f ec ff ff       	call   80105400 <argint>
80106771:	83 c4 10             	add    $0x10,%esp
80106774:	85 c0                	test   %eax,%eax
80106776:	0f 88 94 00 00 00    	js     80106810 <sys_bjf_validation_process+0xb0>
8010677c:	83 ec 08             	sub    $0x8,%esp
8010677f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106782:	50                   	push   %eax
80106783:	6a 01                	push   $0x1
80106785:	e8 76 ec ff ff       	call   80105400 <argint>
8010678a:	83 c4 10             	add    $0x10,%esp
8010678d:	85 c0                	test   %eax,%eax
8010678f:	78 7f                	js     80106810 <sys_bjf_validation_process+0xb0>
80106791:	83 ec 08             	sub    $0x8,%esp
80106794:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106797:	50                   	push   %eax
80106798:	6a 02                	push   $0x2
8010679a:	e8 61 ec ff ff       	call   80105400 <argint>
8010679f:	83 c4 10             	add    $0x10,%esp
801067a2:	85 c0                	test   %eax,%eax
801067a4:	78 6a                	js     80106810 <sys_bjf_validation_process+0xb0>
801067a6:	83 ec 08             	sub    $0x8,%esp
801067a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067ac:	50                   	push   %eax
801067ad:	6a 03                	push   $0x3
801067af:	e8 4c ec ff ff       	call   80105400 <argint>
801067b4:	83 c4 10             	add    $0x10,%esp
801067b7:	85 c0                	test   %eax,%eax
801067b9:	78 55                	js     80106810 <sys_bjf_validation_process+0xb0>
801067bb:	83 ec 08             	sub    $0x8,%esp
801067be:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067c1:	50                   	push   %eax
801067c2:	6a 04                	push   $0x4
801067c4:	e8 37 ec ff ff       	call   80105400 <argint>
801067c9:	83 c4 10             	add    $0x10,%esp
801067cc:	85 c0                	test   %eax,%eax
801067ce:	78 40                	js     80106810 <sys_bjf_validation_process+0xb0>
  {
    return -1;
  }
  struct proc *p = find_proc(pid);
801067d0:	83 ec 0c             	sub    $0xc,%esp
801067d3:	ff 75 e4             	push   -0x1c(%ebp)
801067d6:	e8 e5 d4 ff ff       	call   80103cc0 <find_proc>
  p->priority_ratio = (float)priority_ratio;
801067db:	db 45 e8             	fildl  -0x18(%ebp)
  p->creation_time_ratio = (float)creation_time_ratio;
  p->executed_cycle_ratio = (float)exec_cycle_ratio;
  p->process_size_ratio = (float)size_ratio;

  return 0;
801067de:	83 c4 10             	add    $0x10,%esp
  p->priority_ratio = (float)priority_ratio;
801067e1:	d9 98 8c 00 00 00    	fstps  0x8c(%eax)
  p->creation_time_ratio = (float)creation_time_ratio;
801067e7:	db 45 ec             	fildl  -0x14(%ebp)
801067ea:	d9 98 90 00 00 00    	fstps  0x90(%eax)
  p->executed_cycle_ratio = (float)exec_cycle_ratio;
801067f0:	db 45 f0             	fildl  -0x10(%ebp)
801067f3:	d9 98 98 00 00 00    	fstps  0x98(%eax)
  p->process_size_ratio = (float)size_ratio;
801067f9:	db 45 f4             	fildl  -0xc(%ebp)
801067fc:	d9 98 9c 00 00 00    	fstps  0x9c(%eax)
  return 0;
80106802:	31 c0                	xor    %eax,%eax
}
80106804:	c9                   	leave  
80106805:	c3                   	ret    
80106806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010680d:	8d 76 00             	lea    0x0(%esi),%esi
80106810:	c9                   	leave  
    return -1;
80106811:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106816:	c3                   	ret    
80106817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010681e:	66 90                	xchg   %ax,%ax

80106820 <sys_bjf_validation_system>:
int sys_bjf_validation_system(void)
{
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	83 ec 20             	sub    $0x20,%esp
  int priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argint(0, &priority_ratio) < 0 || argint(1, &creation_time_ratio) < 0 || argint(2, &exec_cycle_ratio) < 0 || argint(3, &size_ratio) < 0)
80106826:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106829:	50                   	push   %eax
8010682a:	6a 00                	push   $0x0
8010682c:	e8 cf eb ff ff       	call   80105400 <argint>
80106831:	83 c4 10             	add    $0x10,%esp
80106834:	85 c0                	test   %eax,%eax
80106836:	78 70                	js     801068a8 <sys_bjf_validation_system+0x88>
80106838:	83 ec 08             	sub    $0x8,%esp
8010683b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010683e:	50                   	push   %eax
8010683f:	6a 01                	push   $0x1
80106841:	e8 ba eb ff ff       	call   80105400 <argint>
80106846:	83 c4 10             	add    $0x10,%esp
80106849:	85 c0                	test   %eax,%eax
8010684b:	78 5b                	js     801068a8 <sys_bjf_validation_system+0x88>
8010684d:	83 ec 08             	sub    $0x8,%esp
80106850:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106853:	50                   	push   %eax
80106854:	6a 02                	push   $0x2
80106856:	e8 a5 eb ff ff       	call   80105400 <argint>
8010685b:	83 c4 10             	add    $0x10,%esp
8010685e:	85 c0                	test   %eax,%eax
80106860:	78 46                	js     801068a8 <sys_bjf_validation_system+0x88>
80106862:	83 ec 08             	sub    $0x8,%esp
80106865:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106868:	50                   	push   %eax
80106869:	6a 03                	push   $0x3
8010686b:	e8 90 eb ff ff       	call   80105400 <argint>
80106870:	83 c4 10             	add    $0x10,%esp
80106873:	85 c0                	test   %eax,%eax
80106875:	78 31                	js     801068a8 <sys_bjf_validation_system+0x88>
  {
    return -1;
  }
  reset_bjf_attributes((float)priority_ratio, (float)creation_time_ratio,(float) exec_cycle_ratio,(float) size_ratio);
80106877:	db 45 f4             	fildl  -0xc(%ebp)
8010687a:	83 ec 10             	sub    $0x10,%esp
8010687d:	d9 5c 24 0c          	fstps  0xc(%esp)
80106881:	db 45 f0             	fildl  -0x10(%ebp)
80106884:	d9 5c 24 08          	fstps  0x8(%esp)
80106888:	db 45 ec             	fildl  -0x14(%ebp)
8010688b:	d9 5c 24 04          	fstps  0x4(%esp)
8010688f:	db 45 e8             	fildl  -0x18(%ebp)
80106892:	d9 1c 24             	fstps  (%esp)
80106895:	e8 c6 d1 ff ff       	call   80103a60 <reset_bjf_attributes>
  return 0;
8010689a:	83 c4 10             	add    $0x10,%esp
8010689d:	31 c0                	xor    %eax,%eax
}
8010689f:	c9                   	leave  
801068a0:	c3                   	ret    
801068a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068a8:	c9                   	leave  
    return -1;
801068a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068ae:	c3                   	ret    
801068af:	90                   	nop

801068b0 <sys_print_info>:
int sys_print_info(void)
{
801068b0:	55                   	push   %ebp
801068b1:	89 e5                	mov    %esp,%ebp
801068b3:	83 ec 08             	sub    $0x8,%esp
  print_bitches();
801068b6:	e8 15 d5 ff ff       	call   80103dd0 <print_bitches>
  return 0;
}
801068bb:	31 c0                	xor    %eax,%eax
801068bd:	c9                   	leave  
801068be:	c3                   	ret    
801068bf:	90                   	nop

801068c0 <sys_open_sharedmem>:

int sys_open_sharedmem(void)
{
801068c0:	55                   	push   %ebp
801068c1:	89 e5                	mov    %esp,%ebp
801068c3:	83 ec 20             	sub    $0x20,%esp
  int id;
  argint(0, &id);
801068c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068c9:	50                   	push   %eax
801068ca:	6a 00                	push   $0x0
801068cc:	e8 2f eb ff ff       	call   80105400 <argint>
  return open_sharedmem(id);
801068d1:	58                   	pop    %eax
801068d2:	ff 75 f4             	push   -0xc(%ebp)
801068d5:	e8 56 e4 ff ff       	call   80104d30 <open_sharedmem>
  
801068da:	c9                   	leave  
801068db:	c3                   	ret    

801068dc <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801068dc:	1e                   	push   %ds
  pushl %es
801068dd:	06                   	push   %es
  pushl %fs
801068de:	0f a0                	push   %fs
  pushl %gs
801068e0:	0f a8                	push   %gs
  pushal
801068e2:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801068e3:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801068e7:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801068e9:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801068eb:	54                   	push   %esp
  call trap
801068ec:	e8 bf 00 00 00       	call   801069b0 <trap>
  addl $4, %esp
801068f1:	83 c4 04             	add    $0x4,%esp

801068f4 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801068f4:	61                   	popa   
  popl %gs
801068f5:	0f a9                	pop    %gs
  popl %fs
801068f7:	0f a1                	pop    %fs
  popl %es
801068f9:	07                   	pop    %es
  popl %ds
801068fa:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801068fb:	83 c4 08             	add    $0x8,%esp
  iret
801068fe:	cf                   	iret   
801068ff:	90                   	nop

80106900 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106900:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106901:	31 c0                	xor    %eax,%eax
{
80106903:	89 e5                	mov    %esp,%ebp
80106905:	83 ec 08             	sub    $0x8,%esp
80106908:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010690f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106910:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106917:	c7 04 c5 42 58 11 80 	movl   $0x8e000008,-0x7feea7be(,%eax,8)
8010691e:	08 00 00 8e 
80106922:	66 89 14 c5 40 58 11 	mov    %dx,-0x7feea7c0(,%eax,8)
80106929:	80 
8010692a:	c1 ea 10             	shr    $0x10,%edx
8010692d:	66 89 14 c5 46 58 11 	mov    %dx,-0x7feea7ba(,%eax,8)
80106934:	80 
  for(i = 0; i < 256; i++)
80106935:	83 c0 01             	add    $0x1,%eax
80106938:	3d 00 01 00 00       	cmp    $0x100,%eax
8010693d:	75 d1                	jne    80106910 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010693f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106942:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106947:	c7 05 42 5a 11 80 08 	movl   $0xef000008,0x80115a42
8010694e:	00 00 ef 
  initlock(&tickslock, "time");
80106951:	68 13 8b 10 80       	push   $0x80108b13
80106956:	68 00 58 11 80       	push   $0x80115800
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010695b:	66 a3 40 5a 11 80    	mov    %ax,0x80115a40
80106961:	c1 e8 10             	shr    $0x10,%eax
80106964:	66 a3 46 5a 11 80    	mov    %ax,0x80115a46
  initlock(&tickslock, "time");
8010696a:	e8 01 e5 ff ff       	call   80104e70 <initlock>
}
8010696f:	83 c4 10             	add    $0x10,%esp
80106972:	c9                   	leave  
80106973:	c3                   	ret    
80106974:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010697b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010697f:	90                   	nop

80106980 <idtinit>:

void
idtinit(void)
{
80106980:	55                   	push   %ebp
  pd[0] = size-1;
80106981:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106986:	89 e5                	mov    %esp,%ebp
80106988:	83 ec 10             	sub    $0x10,%esp
8010698b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010698f:	b8 40 58 11 80       	mov    $0x80115840,%eax
80106994:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106998:	c1 e8 10             	shr    $0x10,%eax
8010699b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010699f:	8d 45 fa             	lea    -0x6(%ebp),%eax
801069a2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801069a5:	c9                   	leave  
801069a6:	c3                   	ret    
801069a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069ae:	66 90                	xchg   %ax,%ax

801069b0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	57                   	push   %edi
801069b4:	56                   	push   %esi
801069b5:	53                   	push   %ebx
801069b6:	83 ec 1c             	sub    $0x1c,%esp
801069b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801069bc:	8b 43 30             	mov    0x30(%ebx),%eax
801069bf:	83 f8 40             	cmp    $0x40,%eax
801069c2:	0f 84 68 01 00 00    	je     80106b30 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801069c8:	83 e8 20             	sub    $0x20,%eax
801069cb:	83 f8 1f             	cmp    $0x1f,%eax
801069ce:	0f 87 8c 00 00 00    	ja     80106a60 <trap+0xb0>
801069d4:	ff 24 85 bc 8b 10 80 	jmp    *-0x7fef7444(,%eax,4)
801069db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069df:	90                   	nop
      aging();
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801069e0:	e8 5b b8 ff ff       	call   80102240 <ideintr>
    lapiceoi();
801069e5:	e8 26 bf ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801069ea:	e8 01 d1 ff ff       	call   80103af0 <myproc>
801069ef:	85 c0                	test   %eax,%eax
801069f1:	74 1d                	je     80106a10 <trap+0x60>
801069f3:	e8 f8 d0 ff ff       	call   80103af0 <myproc>
801069f8:	8b 50 30             	mov    0x30(%eax),%edx
801069fb:	85 d2                	test   %edx,%edx
801069fd:	74 11                	je     80106a10 <trap+0x60>
801069ff:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106a03:	83 e0 03             	and    $0x3,%eax
80106a06:	66 83 f8 03          	cmp    $0x3,%ax
80106a0a:	0f 84 f0 01 00 00    	je     80106c00 <trap+0x250>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106a10:	e8 db d0 ff ff       	call   80103af0 <myproc>
80106a15:	85 c0                	test   %eax,%eax
80106a17:	74 0f                	je     80106a28 <trap+0x78>
80106a19:	e8 d2 d0 ff ff       	call   80103af0 <myproc>
80106a1e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106a22:	0f 84 b8 00 00 00    	je     80106ae0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a28:	e8 c3 d0 ff ff       	call   80103af0 <myproc>
80106a2d:	85 c0                	test   %eax,%eax
80106a2f:	74 1d                	je     80106a4e <trap+0x9e>
80106a31:	e8 ba d0 ff ff       	call   80103af0 <myproc>
80106a36:	8b 40 30             	mov    0x30(%eax),%eax
80106a39:	85 c0                	test   %eax,%eax
80106a3b:	74 11                	je     80106a4e <trap+0x9e>
80106a3d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106a41:	83 e0 03             	and    $0x3,%eax
80106a44:	66 83 f8 03          	cmp    $0x3,%ax
80106a48:	0f 84 0f 01 00 00    	je     80106b5d <trap+0x1ad>
    exit();
}
80106a4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a51:	5b                   	pop    %ebx
80106a52:	5e                   	pop    %esi
80106a53:	5f                   	pop    %edi
80106a54:	5d                   	pop    %ebp
80106a55:	c3                   	ret    
80106a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106a60:	e8 8b d0 ff ff       	call   80103af0 <myproc>
80106a65:	8b 7b 38             	mov    0x38(%ebx),%edi
80106a68:	85 c0                	test   %eax,%eax
80106a6a:	0f 84 aa 01 00 00    	je     80106c1a <trap+0x26a>
80106a70:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106a74:	0f 84 a0 01 00 00    	je     80106c1a <trap+0x26a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106a7a:	0f 20 d1             	mov    %cr2,%ecx
80106a7d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a80:	e8 6b cf ff ff       	call   801039f0 <cpuid>
80106a85:	8b 73 30             	mov    0x30(%ebx),%esi
80106a88:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106a8b:	8b 43 34             	mov    0x34(%ebx),%eax
80106a8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106a91:	e8 5a d0 ff ff       	call   80103af0 <myproc>
80106a96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a99:	e8 52 d0 ff ff       	call   80103af0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a9e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106aa1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106aa4:	51                   	push   %ecx
80106aa5:	57                   	push   %edi
80106aa6:	52                   	push   %edx
80106aa7:	ff 75 e4             	push   -0x1c(%ebp)
80106aaa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106aab:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106aae:	83 c6 78             	add    $0x78,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ab1:	56                   	push   %esi
80106ab2:	ff 70 10             	push   0x10(%eax)
80106ab5:	68 78 8b 10 80       	push   $0x80108b78
80106aba:	e8 e1 9b ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80106abf:	83 c4 20             	add    $0x20,%esp
80106ac2:	e8 29 d0 ff ff       	call   80103af0 <myproc>
80106ac7:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ace:	e8 1d d0 ff ff       	call   80103af0 <myproc>
80106ad3:	85 c0                	test   %eax,%eax
80106ad5:	0f 85 18 ff ff ff    	jne    801069f3 <trap+0x43>
80106adb:	e9 30 ff ff ff       	jmp    80106a10 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106ae0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106ae4:	0f 85 3e ff ff ff    	jne    80106a28 <trap+0x78>
    yield();
80106aea:	e8 b1 de ff ff       	call   801049a0 <yield>
80106aef:	e9 34 ff ff ff       	jmp    80106a28 <trap+0x78>
80106af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106af8:	8b 7b 38             	mov    0x38(%ebx),%edi
80106afb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106aff:	e8 ec ce ff ff       	call   801039f0 <cpuid>
80106b04:	57                   	push   %edi
80106b05:	56                   	push   %esi
80106b06:	50                   	push   %eax
80106b07:	68 20 8b 10 80       	push   $0x80108b20
80106b0c:	e8 8f 9b ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106b11:	e8 fa bd ff ff       	call   80102910 <lapiceoi>
    break;
80106b16:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b19:	e8 d2 cf ff ff       	call   80103af0 <myproc>
80106b1e:	85 c0                	test   %eax,%eax
80106b20:	0f 85 cd fe ff ff    	jne    801069f3 <trap+0x43>
80106b26:	e9 e5 fe ff ff       	jmp    80106a10 <trap+0x60>
80106b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b2f:	90                   	nop
    if(myproc()->killed)
80106b30:	e8 bb cf ff ff       	call   80103af0 <myproc>
80106b35:	8b 70 30             	mov    0x30(%eax),%esi
80106b38:	85 f6                	test   %esi,%esi
80106b3a:	0f 85 d0 00 00 00    	jne    80106c10 <trap+0x260>
    myproc()->tf = tf;
80106b40:	e8 ab cf ff ff       	call   80103af0 <myproc>
80106b45:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106b48:	e8 43 ea ff ff       	call   80105590 <syscall>
    if(myproc()->killed)
80106b4d:	e8 9e cf ff ff       	call   80103af0 <myproc>
80106b52:	8b 48 30             	mov    0x30(%eax),%ecx
80106b55:	85 c9                	test   %ecx,%ecx
80106b57:	0f 84 f1 fe ff ff    	je     80106a4e <trap+0x9e>
}
80106b5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b60:	5b                   	pop    %ebx
80106b61:	5e                   	pop    %esi
80106b62:	5f                   	pop    %edi
80106b63:	5d                   	pop    %ebp
      exit();
80106b64:	e9 d7 db ff ff       	jmp    80104740 <exit>
80106b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106b70:	e8 4b 02 00 00       	call   80106dc0 <uartintr>
    lapiceoi();
80106b75:	e8 96 bd ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b7a:	e8 71 cf ff ff       	call   80103af0 <myproc>
80106b7f:	85 c0                	test   %eax,%eax
80106b81:	0f 85 6c fe ff ff    	jne    801069f3 <trap+0x43>
80106b87:	e9 84 fe ff ff       	jmp    80106a10 <trap+0x60>
80106b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106b90:	e8 3b bc ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80106b95:	e8 76 bd ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b9a:	e8 51 cf ff ff       	call   80103af0 <myproc>
80106b9f:	85 c0                	test   %eax,%eax
80106ba1:	0f 85 4c fe ff ff    	jne    801069f3 <trap+0x43>
80106ba7:	e9 64 fe ff ff       	jmp    80106a10 <trap+0x60>
80106bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106bb0:	e8 3b ce ff ff       	call   801039f0 <cpuid>
80106bb5:	85 c0                	test   %eax,%eax
80106bb7:	0f 85 28 fe ff ff    	jne    801069e5 <trap+0x35>
      acquire(&tickslock);
80106bbd:	83 ec 0c             	sub    $0xc,%esp
80106bc0:	68 00 58 11 80       	push   $0x80115800
80106bc5:	e8 76 e4 ff ff       	call   80105040 <acquire>
      wakeup(&ticks);
80106bca:	c7 04 24 e0 57 11 80 	movl   $0x801157e0,(%esp)
      ticks++;
80106bd1:	83 05 e0 57 11 80 01 	addl   $0x1,0x801157e0
      wakeup(&ticks);
80106bd8:	e8 13 df ff ff       	call   80104af0 <wakeup>
      release(&tickslock);
80106bdd:	c7 04 24 00 58 11 80 	movl   $0x80115800,(%esp)
80106be4:	e8 f7 e3 ff ff       	call   80104fe0 <release>
      aging();
80106be9:	e8 22 ce ff ff       	call   80103a10 <aging>
80106bee:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106bf1:	e9 ef fd ff ff       	jmp    801069e5 <trap+0x35>
80106bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bfd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106c00:	e8 3b db ff ff       	call   80104740 <exit>
80106c05:	e9 06 fe ff ff       	jmp    80106a10 <trap+0x60>
80106c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106c10:	e8 2b db ff ff       	call   80104740 <exit>
80106c15:	e9 26 ff ff ff       	jmp    80106b40 <trap+0x190>
80106c1a:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106c1d:	e8 ce cd ff ff       	call   801039f0 <cpuid>
80106c22:	83 ec 0c             	sub    $0xc,%esp
80106c25:	56                   	push   %esi
80106c26:	57                   	push   %edi
80106c27:	50                   	push   %eax
80106c28:	ff 73 30             	push   0x30(%ebx)
80106c2b:	68 44 8b 10 80       	push   $0x80108b44
80106c30:	e8 6b 9a ff ff       	call   801006a0 <cprintf>
      panic("trap");
80106c35:	83 c4 14             	add    $0x14,%esp
80106c38:	68 18 8b 10 80       	push   $0x80108b18
80106c3d:	e8 3e 97 ff ff       	call   80100380 <panic>
80106c42:	66 90                	xchg   %ax,%ax
80106c44:	66 90                	xchg   %ax,%ax
80106c46:	66 90                	xchg   %ax,%ax
80106c48:	66 90                	xchg   %ax,%ax
80106c4a:	66 90                	xchg   %ax,%ax
80106c4c:	66 90                	xchg   %ax,%ax
80106c4e:	66 90                	xchg   %ax,%ax

80106c50 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106c50:	a1 40 60 11 80       	mov    0x80116040,%eax
80106c55:	85 c0                	test   %eax,%eax
80106c57:	74 17                	je     80106c70 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106c59:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106c5e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106c5f:	a8 01                	test   $0x1,%al
80106c61:	74 0d                	je     80106c70 <uartgetc+0x20>
80106c63:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c68:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106c69:	0f b6 c0             	movzbl %al,%eax
80106c6c:	c3                   	ret    
80106c6d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c75:	c3                   	ret    
80106c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c7d:	8d 76 00             	lea    0x0(%esi),%esi

80106c80 <uartinit>:
{
80106c80:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106c81:	31 c9                	xor    %ecx,%ecx
80106c83:	89 c8                	mov    %ecx,%eax
80106c85:	89 e5                	mov    %esp,%ebp
80106c87:	57                   	push   %edi
80106c88:	bf fa 03 00 00       	mov    $0x3fa,%edi
80106c8d:	56                   	push   %esi
80106c8e:	89 fa                	mov    %edi,%edx
80106c90:	53                   	push   %ebx
80106c91:	83 ec 1c             	sub    $0x1c,%esp
80106c94:	ee                   	out    %al,(%dx)
80106c95:	be fb 03 00 00       	mov    $0x3fb,%esi
80106c9a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106c9f:	89 f2                	mov    %esi,%edx
80106ca1:	ee                   	out    %al,(%dx)
80106ca2:	b8 0c 00 00 00       	mov    $0xc,%eax
80106ca7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106cac:	ee                   	out    %al,(%dx)
80106cad:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106cb2:	89 c8                	mov    %ecx,%eax
80106cb4:	89 da                	mov    %ebx,%edx
80106cb6:	ee                   	out    %al,(%dx)
80106cb7:	b8 03 00 00 00       	mov    $0x3,%eax
80106cbc:	89 f2                	mov    %esi,%edx
80106cbe:	ee                   	out    %al,(%dx)
80106cbf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106cc4:	89 c8                	mov    %ecx,%eax
80106cc6:	ee                   	out    %al,(%dx)
80106cc7:	b8 01 00 00 00       	mov    $0x1,%eax
80106ccc:	89 da                	mov    %ebx,%edx
80106cce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106ccf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106cd4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106cd5:	3c ff                	cmp    $0xff,%al
80106cd7:	74 78                	je     80106d51 <uartinit+0xd1>
  uart = 1;
80106cd9:	c7 05 40 60 11 80 01 	movl   $0x1,0x80116040
80106ce0:	00 00 00 
80106ce3:	89 fa                	mov    %edi,%edx
80106ce5:	ec                   	in     (%dx),%al
80106ce6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106ceb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106cec:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106cef:	bf 3c 8c 10 80       	mov    $0x80108c3c,%edi
80106cf4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106cf9:	6a 00                	push   $0x0
80106cfb:	6a 04                	push   $0x4
80106cfd:	e8 7e b7 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106d02:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106d06:	83 c4 10             	add    $0x10,%esp
80106d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106d10:	a1 40 60 11 80       	mov    0x80116040,%eax
80106d15:	bb 80 00 00 00       	mov    $0x80,%ebx
80106d1a:	85 c0                	test   %eax,%eax
80106d1c:	75 14                	jne    80106d32 <uartinit+0xb2>
80106d1e:	eb 23                	jmp    80106d43 <uartinit+0xc3>
    microdelay(10);
80106d20:	83 ec 0c             	sub    $0xc,%esp
80106d23:	6a 0a                	push   $0xa
80106d25:	e8 06 bc ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106d2a:	83 c4 10             	add    $0x10,%esp
80106d2d:	83 eb 01             	sub    $0x1,%ebx
80106d30:	74 07                	je     80106d39 <uartinit+0xb9>
80106d32:	89 f2                	mov    %esi,%edx
80106d34:	ec                   	in     (%dx),%al
80106d35:	a8 20                	test   $0x20,%al
80106d37:	74 e7                	je     80106d20 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106d39:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106d3d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106d42:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106d43:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106d47:	83 c7 01             	add    $0x1,%edi
80106d4a:	88 45 e7             	mov    %al,-0x19(%ebp)
80106d4d:	84 c0                	test   %al,%al
80106d4f:	75 bf                	jne    80106d10 <uartinit+0x90>
}
80106d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d54:	5b                   	pop    %ebx
80106d55:	5e                   	pop    %esi
80106d56:	5f                   	pop    %edi
80106d57:	5d                   	pop    %ebp
80106d58:	c3                   	ret    
80106d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d60 <uartputc>:
  if(!uart)
80106d60:	a1 40 60 11 80       	mov    0x80116040,%eax
80106d65:	85 c0                	test   %eax,%eax
80106d67:	74 47                	je     80106db0 <uartputc+0x50>
{
80106d69:	55                   	push   %ebp
80106d6a:	89 e5                	mov    %esp,%ebp
80106d6c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106d6d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106d72:	53                   	push   %ebx
80106d73:	bb 80 00 00 00       	mov    $0x80,%ebx
80106d78:	eb 18                	jmp    80106d92 <uartputc+0x32>
80106d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106d80:	83 ec 0c             	sub    $0xc,%esp
80106d83:	6a 0a                	push   $0xa
80106d85:	e8 a6 bb ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106d8a:	83 c4 10             	add    $0x10,%esp
80106d8d:	83 eb 01             	sub    $0x1,%ebx
80106d90:	74 07                	je     80106d99 <uartputc+0x39>
80106d92:	89 f2                	mov    %esi,%edx
80106d94:	ec                   	in     (%dx),%al
80106d95:	a8 20                	test   $0x20,%al
80106d97:	74 e7                	je     80106d80 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106d99:	8b 45 08             	mov    0x8(%ebp),%eax
80106d9c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106da1:	ee                   	out    %al,(%dx)
}
80106da2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106da5:	5b                   	pop    %ebx
80106da6:	5e                   	pop    %esi
80106da7:	5d                   	pop    %ebp
80106da8:	c3                   	ret    
80106da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106db0:	c3                   	ret    
80106db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106db8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dbf:	90                   	nop

80106dc0 <uartintr>:

void
uartintr(void)
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106dc6:	68 50 6c 10 80       	push   $0x80106c50
80106dcb:	e8 b0 9a ff ff       	call   80100880 <consoleintr>
}
80106dd0:	83 c4 10             	add    $0x10,%esp
80106dd3:	c9                   	leave  
80106dd4:	c3                   	ret    

80106dd5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106dd5:	6a 00                	push   $0x0
  pushl $0
80106dd7:	6a 00                	push   $0x0
  jmp alltraps
80106dd9:	e9 fe fa ff ff       	jmp    801068dc <alltraps>

80106dde <vector1>:
.globl vector1
vector1:
  pushl $0
80106dde:	6a 00                	push   $0x0
  pushl $1
80106de0:	6a 01                	push   $0x1
  jmp alltraps
80106de2:	e9 f5 fa ff ff       	jmp    801068dc <alltraps>

80106de7 <vector2>:
.globl vector2
vector2:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $2
80106de9:	6a 02                	push   $0x2
  jmp alltraps
80106deb:	e9 ec fa ff ff       	jmp    801068dc <alltraps>

80106df0 <vector3>:
.globl vector3
vector3:
  pushl $0
80106df0:	6a 00                	push   $0x0
  pushl $3
80106df2:	6a 03                	push   $0x3
  jmp alltraps
80106df4:	e9 e3 fa ff ff       	jmp    801068dc <alltraps>

80106df9 <vector4>:
.globl vector4
vector4:
  pushl $0
80106df9:	6a 00                	push   $0x0
  pushl $4
80106dfb:	6a 04                	push   $0x4
  jmp alltraps
80106dfd:	e9 da fa ff ff       	jmp    801068dc <alltraps>

80106e02 <vector5>:
.globl vector5
vector5:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $5
80106e04:	6a 05                	push   $0x5
  jmp alltraps
80106e06:	e9 d1 fa ff ff       	jmp    801068dc <alltraps>

80106e0b <vector6>:
.globl vector6
vector6:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $6
80106e0d:	6a 06                	push   $0x6
  jmp alltraps
80106e0f:	e9 c8 fa ff ff       	jmp    801068dc <alltraps>

80106e14 <vector7>:
.globl vector7
vector7:
  pushl $0
80106e14:	6a 00                	push   $0x0
  pushl $7
80106e16:	6a 07                	push   $0x7
  jmp alltraps
80106e18:	e9 bf fa ff ff       	jmp    801068dc <alltraps>

80106e1d <vector8>:
.globl vector8
vector8:
  pushl $8
80106e1d:	6a 08                	push   $0x8
  jmp alltraps
80106e1f:	e9 b8 fa ff ff       	jmp    801068dc <alltraps>

80106e24 <vector9>:
.globl vector9
vector9:
  pushl $0
80106e24:	6a 00                	push   $0x0
  pushl $9
80106e26:	6a 09                	push   $0x9
  jmp alltraps
80106e28:	e9 af fa ff ff       	jmp    801068dc <alltraps>

80106e2d <vector10>:
.globl vector10
vector10:
  pushl $10
80106e2d:	6a 0a                	push   $0xa
  jmp alltraps
80106e2f:	e9 a8 fa ff ff       	jmp    801068dc <alltraps>

80106e34 <vector11>:
.globl vector11
vector11:
  pushl $11
80106e34:	6a 0b                	push   $0xb
  jmp alltraps
80106e36:	e9 a1 fa ff ff       	jmp    801068dc <alltraps>

80106e3b <vector12>:
.globl vector12
vector12:
  pushl $12
80106e3b:	6a 0c                	push   $0xc
  jmp alltraps
80106e3d:	e9 9a fa ff ff       	jmp    801068dc <alltraps>

80106e42 <vector13>:
.globl vector13
vector13:
  pushl $13
80106e42:	6a 0d                	push   $0xd
  jmp alltraps
80106e44:	e9 93 fa ff ff       	jmp    801068dc <alltraps>

80106e49 <vector14>:
.globl vector14
vector14:
  pushl $14
80106e49:	6a 0e                	push   $0xe
  jmp alltraps
80106e4b:	e9 8c fa ff ff       	jmp    801068dc <alltraps>

80106e50 <vector15>:
.globl vector15
vector15:
  pushl $0
80106e50:	6a 00                	push   $0x0
  pushl $15
80106e52:	6a 0f                	push   $0xf
  jmp alltraps
80106e54:	e9 83 fa ff ff       	jmp    801068dc <alltraps>

80106e59 <vector16>:
.globl vector16
vector16:
  pushl $0
80106e59:	6a 00                	push   $0x0
  pushl $16
80106e5b:	6a 10                	push   $0x10
  jmp alltraps
80106e5d:	e9 7a fa ff ff       	jmp    801068dc <alltraps>

80106e62 <vector17>:
.globl vector17
vector17:
  pushl $17
80106e62:	6a 11                	push   $0x11
  jmp alltraps
80106e64:	e9 73 fa ff ff       	jmp    801068dc <alltraps>

80106e69 <vector18>:
.globl vector18
vector18:
  pushl $0
80106e69:	6a 00                	push   $0x0
  pushl $18
80106e6b:	6a 12                	push   $0x12
  jmp alltraps
80106e6d:	e9 6a fa ff ff       	jmp    801068dc <alltraps>

80106e72 <vector19>:
.globl vector19
vector19:
  pushl $0
80106e72:	6a 00                	push   $0x0
  pushl $19
80106e74:	6a 13                	push   $0x13
  jmp alltraps
80106e76:	e9 61 fa ff ff       	jmp    801068dc <alltraps>

80106e7b <vector20>:
.globl vector20
vector20:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $20
80106e7d:	6a 14                	push   $0x14
  jmp alltraps
80106e7f:	e9 58 fa ff ff       	jmp    801068dc <alltraps>

80106e84 <vector21>:
.globl vector21
vector21:
  pushl $0
80106e84:	6a 00                	push   $0x0
  pushl $21
80106e86:	6a 15                	push   $0x15
  jmp alltraps
80106e88:	e9 4f fa ff ff       	jmp    801068dc <alltraps>

80106e8d <vector22>:
.globl vector22
vector22:
  pushl $0
80106e8d:	6a 00                	push   $0x0
  pushl $22
80106e8f:	6a 16                	push   $0x16
  jmp alltraps
80106e91:	e9 46 fa ff ff       	jmp    801068dc <alltraps>

80106e96 <vector23>:
.globl vector23
vector23:
  pushl $0
80106e96:	6a 00                	push   $0x0
  pushl $23
80106e98:	6a 17                	push   $0x17
  jmp alltraps
80106e9a:	e9 3d fa ff ff       	jmp    801068dc <alltraps>

80106e9f <vector24>:
.globl vector24
vector24:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $24
80106ea1:	6a 18                	push   $0x18
  jmp alltraps
80106ea3:	e9 34 fa ff ff       	jmp    801068dc <alltraps>

80106ea8 <vector25>:
.globl vector25
vector25:
  pushl $0
80106ea8:	6a 00                	push   $0x0
  pushl $25
80106eaa:	6a 19                	push   $0x19
  jmp alltraps
80106eac:	e9 2b fa ff ff       	jmp    801068dc <alltraps>

80106eb1 <vector26>:
.globl vector26
vector26:
  pushl $0
80106eb1:	6a 00                	push   $0x0
  pushl $26
80106eb3:	6a 1a                	push   $0x1a
  jmp alltraps
80106eb5:	e9 22 fa ff ff       	jmp    801068dc <alltraps>

80106eba <vector27>:
.globl vector27
vector27:
  pushl $0
80106eba:	6a 00                	push   $0x0
  pushl $27
80106ebc:	6a 1b                	push   $0x1b
  jmp alltraps
80106ebe:	e9 19 fa ff ff       	jmp    801068dc <alltraps>

80106ec3 <vector28>:
.globl vector28
vector28:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $28
80106ec5:	6a 1c                	push   $0x1c
  jmp alltraps
80106ec7:	e9 10 fa ff ff       	jmp    801068dc <alltraps>

80106ecc <vector29>:
.globl vector29
vector29:
  pushl $0
80106ecc:	6a 00                	push   $0x0
  pushl $29
80106ece:	6a 1d                	push   $0x1d
  jmp alltraps
80106ed0:	e9 07 fa ff ff       	jmp    801068dc <alltraps>

80106ed5 <vector30>:
.globl vector30
vector30:
  pushl $0
80106ed5:	6a 00                	push   $0x0
  pushl $30
80106ed7:	6a 1e                	push   $0x1e
  jmp alltraps
80106ed9:	e9 fe f9 ff ff       	jmp    801068dc <alltraps>

80106ede <vector31>:
.globl vector31
vector31:
  pushl $0
80106ede:	6a 00                	push   $0x0
  pushl $31
80106ee0:	6a 1f                	push   $0x1f
  jmp alltraps
80106ee2:	e9 f5 f9 ff ff       	jmp    801068dc <alltraps>

80106ee7 <vector32>:
.globl vector32
vector32:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $32
80106ee9:	6a 20                	push   $0x20
  jmp alltraps
80106eeb:	e9 ec f9 ff ff       	jmp    801068dc <alltraps>

80106ef0 <vector33>:
.globl vector33
vector33:
  pushl $0
80106ef0:	6a 00                	push   $0x0
  pushl $33
80106ef2:	6a 21                	push   $0x21
  jmp alltraps
80106ef4:	e9 e3 f9 ff ff       	jmp    801068dc <alltraps>

80106ef9 <vector34>:
.globl vector34
vector34:
  pushl $0
80106ef9:	6a 00                	push   $0x0
  pushl $34
80106efb:	6a 22                	push   $0x22
  jmp alltraps
80106efd:	e9 da f9 ff ff       	jmp    801068dc <alltraps>

80106f02 <vector35>:
.globl vector35
vector35:
  pushl $0
80106f02:	6a 00                	push   $0x0
  pushl $35
80106f04:	6a 23                	push   $0x23
  jmp alltraps
80106f06:	e9 d1 f9 ff ff       	jmp    801068dc <alltraps>

80106f0b <vector36>:
.globl vector36
vector36:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $36
80106f0d:	6a 24                	push   $0x24
  jmp alltraps
80106f0f:	e9 c8 f9 ff ff       	jmp    801068dc <alltraps>

80106f14 <vector37>:
.globl vector37
vector37:
  pushl $0
80106f14:	6a 00                	push   $0x0
  pushl $37
80106f16:	6a 25                	push   $0x25
  jmp alltraps
80106f18:	e9 bf f9 ff ff       	jmp    801068dc <alltraps>

80106f1d <vector38>:
.globl vector38
vector38:
  pushl $0
80106f1d:	6a 00                	push   $0x0
  pushl $38
80106f1f:	6a 26                	push   $0x26
  jmp alltraps
80106f21:	e9 b6 f9 ff ff       	jmp    801068dc <alltraps>

80106f26 <vector39>:
.globl vector39
vector39:
  pushl $0
80106f26:	6a 00                	push   $0x0
  pushl $39
80106f28:	6a 27                	push   $0x27
  jmp alltraps
80106f2a:	e9 ad f9 ff ff       	jmp    801068dc <alltraps>

80106f2f <vector40>:
.globl vector40
vector40:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $40
80106f31:	6a 28                	push   $0x28
  jmp alltraps
80106f33:	e9 a4 f9 ff ff       	jmp    801068dc <alltraps>

80106f38 <vector41>:
.globl vector41
vector41:
  pushl $0
80106f38:	6a 00                	push   $0x0
  pushl $41
80106f3a:	6a 29                	push   $0x29
  jmp alltraps
80106f3c:	e9 9b f9 ff ff       	jmp    801068dc <alltraps>

80106f41 <vector42>:
.globl vector42
vector42:
  pushl $0
80106f41:	6a 00                	push   $0x0
  pushl $42
80106f43:	6a 2a                	push   $0x2a
  jmp alltraps
80106f45:	e9 92 f9 ff ff       	jmp    801068dc <alltraps>

80106f4a <vector43>:
.globl vector43
vector43:
  pushl $0
80106f4a:	6a 00                	push   $0x0
  pushl $43
80106f4c:	6a 2b                	push   $0x2b
  jmp alltraps
80106f4e:	e9 89 f9 ff ff       	jmp    801068dc <alltraps>

80106f53 <vector44>:
.globl vector44
vector44:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $44
80106f55:	6a 2c                	push   $0x2c
  jmp alltraps
80106f57:	e9 80 f9 ff ff       	jmp    801068dc <alltraps>

80106f5c <vector45>:
.globl vector45
vector45:
  pushl $0
80106f5c:	6a 00                	push   $0x0
  pushl $45
80106f5e:	6a 2d                	push   $0x2d
  jmp alltraps
80106f60:	e9 77 f9 ff ff       	jmp    801068dc <alltraps>

80106f65 <vector46>:
.globl vector46
vector46:
  pushl $0
80106f65:	6a 00                	push   $0x0
  pushl $46
80106f67:	6a 2e                	push   $0x2e
  jmp alltraps
80106f69:	e9 6e f9 ff ff       	jmp    801068dc <alltraps>

80106f6e <vector47>:
.globl vector47
vector47:
  pushl $0
80106f6e:	6a 00                	push   $0x0
  pushl $47
80106f70:	6a 2f                	push   $0x2f
  jmp alltraps
80106f72:	e9 65 f9 ff ff       	jmp    801068dc <alltraps>

80106f77 <vector48>:
.globl vector48
vector48:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $48
80106f79:	6a 30                	push   $0x30
  jmp alltraps
80106f7b:	e9 5c f9 ff ff       	jmp    801068dc <alltraps>

80106f80 <vector49>:
.globl vector49
vector49:
  pushl $0
80106f80:	6a 00                	push   $0x0
  pushl $49
80106f82:	6a 31                	push   $0x31
  jmp alltraps
80106f84:	e9 53 f9 ff ff       	jmp    801068dc <alltraps>

80106f89 <vector50>:
.globl vector50
vector50:
  pushl $0
80106f89:	6a 00                	push   $0x0
  pushl $50
80106f8b:	6a 32                	push   $0x32
  jmp alltraps
80106f8d:	e9 4a f9 ff ff       	jmp    801068dc <alltraps>

80106f92 <vector51>:
.globl vector51
vector51:
  pushl $0
80106f92:	6a 00                	push   $0x0
  pushl $51
80106f94:	6a 33                	push   $0x33
  jmp alltraps
80106f96:	e9 41 f9 ff ff       	jmp    801068dc <alltraps>

80106f9b <vector52>:
.globl vector52
vector52:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $52
80106f9d:	6a 34                	push   $0x34
  jmp alltraps
80106f9f:	e9 38 f9 ff ff       	jmp    801068dc <alltraps>

80106fa4 <vector53>:
.globl vector53
vector53:
  pushl $0
80106fa4:	6a 00                	push   $0x0
  pushl $53
80106fa6:	6a 35                	push   $0x35
  jmp alltraps
80106fa8:	e9 2f f9 ff ff       	jmp    801068dc <alltraps>

80106fad <vector54>:
.globl vector54
vector54:
  pushl $0
80106fad:	6a 00                	push   $0x0
  pushl $54
80106faf:	6a 36                	push   $0x36
  jmp alltraps
80106fb1:	e9 26 f9 ff ff       	jmp    801068dc <alltraps>

80106fb6 <vector55>:
.globl vector55
vector55:
  pushl $0
80106fb6:	6a 00                	push   $0x0
  pushl $55
80106fb8:	6a 37                	push   $0x37
  jmp alltraps
80106fba:	e9 1d f9 ff ff       	jmp    801068dc <alltraps>

80106fbf <vector56>:
.globl vector56
vector56:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $56
80106fc1:	6a 38                	push   $0x38
  jmp alltraps
80106fc3:	e9 14 f9 ff ff       	jmp    801068dc <alltraps>

80106fc8 <vector57>:
.globl vector57
vector57:
  pushl $0
80106fc8:	6a 00                	push   $0x0
  pushl $57
80106fca:	6a 39                	push   $0x39
  jmp alltraps
80106fcc:	e9 0b f9 ff ff       	jmp    801068dc <alltraps>

80106fd1 <vector58>:
.globl vector58
vector58:
  pushl $0
80106fd1:	6a 00                	push   $0x0
  pushl $58
80106fd3:	6a 3a                	push   $0x3a
  jmp alltraps
80106fd5:	e9 02 f9 ff ff       	jmp    801068dc <alltraps>

80106fda <vector59>:
.globl vector59
vector59:
  pushl $0
80106fda:	6a 00                	push   $0x0
  pushl $59
80106fdc:	6a 3b                	push   $0x3b
  jmp alltraps
80106fde:	e9 f9 f8 ff ff       	jmp    801068dc <alltraps>

80106fe3 <vector60>:
.globl vector60
vector60:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $60
80106fe5:	6a 3c                	push   $0x3c
  jmp alltraps
80106fe7:	e9 f0 f8 ff ff       	jmp    801068dc <alltraps>

80106fec <vector61>:
.globl vector61
vector61:
  pushl $0
80106fec:	6a 00                	push   $0x0
  pushl $61
80106fee:	6a 3d                	push   $0x3d
  jmp alltraps
80106ff0:	e9 e7 f8 ff ff       	jmp    801068dc <alltraps>

80106ff5 <vector62>:
.globl vector62
vector62:
  pushl $0
80106ff5:	6a 00                	push   $0x0
  pushl $62
80106ff7:	6a 3e                	push   $0x3e
  jmp alltraps
80106ff9:	e9 de f8 ff ff       	jmp    801068dc <alltraps>

80106ffe <vector63>:
.globl vector63
vector63:
  pushl $0
80106ffe:	6a 00                	push   $0x0
  pushl $63
80107000:	6a 3f                	push   $0x3f
  jmp alltraps
80107002:	e9 d5 f8 ff ff       	jmp    801068dc <alltraps>

80107007 <vector64>:
.globl vector64
vector64:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $64
80107009:	6a 40                	push   $0x40
  jmp alltraps
8010700b:	e9 cc f8 ff ff       	jmp    801068dc <alltraps>

80107010 <vector65>:
.globl vector65
vector65:
  pushl $0
80107010:	6a 00                	push   $0x0
  pushl $65
80107012:	6a 41                	push   $0x41
  jmp alltraps
80107014:	e9 c3 f8 ff ff       	jmp    801068dc <alltraps>

80107019 <vector66>:
.globl vector66
vector66:
  pushl $0
80107019:	6a 00                	push   $0x0
  pushl $66
8010701b:	6a 42                	push   $0x42
  jmp alltraps
8010701d:	e9 ba f8 ff ff       	jmp    801068dc <alltraps>

80107022 <vector67>:
.globl vector67
vector67:
  pushl $0
80107022:	6a 00                	push   $0x0
  pushl $67
80107024:	6a 43                	push   $0x43
  jmp alltraps
80107026:	e9 b1 f8 ff ff       	jmp    801068dc <alltraps>

8010702b <vector68>:
.globl vector68
vector68:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $68
8010702d:	6a 44                	push   $0x44
  jmp alltraps
8010702f:	e9 a8 f8 ff ff       	jmp    801068dc <alltraps>

80107034 <vector69>:
.globl vector69
vector69:
  pushl $0
80107034:	6a 00                	push   $0x0
  pushl $69
80107036:	6a 45                	push   $0x45
  jmp alltraps
80107038:	e9 9f f8 ff ff       	jmp    801068dc <alltraps>

8010703d <vector70>:
.globl vector70
vector70:
  pushl $0
8010703d:	6a 00                	push   $0x0
  pushl $70
8010703f:	6a 46                	push   $0x46
  jmp alltraps
80107041:	e9 96 f8 ff ff       	jmp    801068dc <alltraps>

80107046 <vector71>:
.globl vector71
vector71:
  pushl $0
80107046:	6a 00                	push   $0x0
  pushl $71
80107048:	6a 47                	push   $0x47
  jmp alltraps
8010704a:	e9 8d f8 ff ff       	jmp    801068dc <alltraps>

8010704f <vector72>:
.globl vector72
vector72:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $72
80107051:	6a 48                	push   $0x48
  jmp alltraps
80107053:	e9 84 f8 ff ff       	jmp    801068dc <alltraps>

80107058 <vector73>:
.globl vector73
vector73:
  pushl $0
80107058:	6a 00                	push   $0x0
  pushl $73
8010705a:	6a 49                	push   $0x49
  jmp alltraps
8010705c:	e9 7b f8 ff ff       	jmp    801068dc <alltraps>

80107061 <vector74>:
.globl vector74
vector74:
  pushl $0
80107061:	6a 00                	push   $0x0
  pushl $74
80107063:	6a 4a                	push   $0x4a
  jmp alltraps
80107065:	e9 72 f8 ff ff       	jmp    801068dc <alltraps>

8010706a <vector75>:
.globl vector75
vector75:
  pushl $0
8010706a:	6a 00                	push   $0x0
  pushl $75
8010706c:	6a 4b                	push   $0x4b
  jmp alltraps
8010706e:	e9 69 f8 ff ff       	jmp    801068dc <alltraps>

80107073 <vector76>:
.globl vector76
vector76:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $76
80107075:	6a 4c                	push   $0x4c
  jmp alltraps
80107077:	e9 60 f8 ff ff       	jmp    801068dc <alltraps>

8010707c <vector77>:
.globl vector77
vector77:
  pushl $0
8010707c:	6a 00                	push   $0x0
  pushl $77
8010707e:	6a 4d                	push   $0x4d
  jmp alltraps
80107080:	e9 57 f8 ff ff       	jmp    801068dc <alltraps>

80107085 <vector78>:
.globl vector78
vector78:
  pushl $0
80107085:	6a 00                	push   $0x0
  pushl $78
80107087:	6a 4e                	push   $0x4e
  jmp alltraps
80107089:	e9 4e f8 ff ff       	jmp    801068dc <alltraps>

8010708e <vector79>:
.globl vector79
vector79:
  pushl $0
8010708e:	6a 00                	push   $0x0
  pushl $79
80107090:	6a 4f                	push   $0x4f
  jmp alltraps
80107092:	e9 45 f8 ff ff       	jmp    801068dc <alltraps>

80107097 <vector80>:
.globl vector80
vector80:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $80
80107099:	6a 50                	push   $0x50
  jmp alltraps
8010709b:	e9 3c f8 ff ff       	jmp    801068dc <alltraps>

801070a0 <vector81>:
.globl vector81
vector81:
  pushl $0
801070a0:	6a 00                	push   $0x0
  pushl $81
801070a2:	6a 51                	push   $0x51
  jmp alltraps
801070a4:	e9 33 f8 ff ff       	jmp    801068dc <alltraps>

801070a9 <vector82>:
.globl vector82
vector82:
  pushl $0
801070a9:	6a 00                	push   $0x0
  pushl $82
801070ab:	6a 52                	push   $0x52
  jmp alltraps
801070ad:	e9 2a f8 ff ff       	jmp    801068dc <alltraps>

801070b2 <vector83>:
.globl vector83
vector83:
  pushl $0
801070b2:	6a 00                	push   $0x0
  pushl $83
801070b4:	6a 53                	push   $0x53
  jmp alltraps
801070b6:	e9 21 f8 ff ff       	jmp    801068dc <alltraps>

801070bb <vector84>:
.globl vector84
vector84:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $84
801070bd:	6a 54                	push   $0x54
  jmp alltraps
801070bf:	e9 18 f8 ff ff       	jmp    801068dc <alltraps>

801070c4 <vector85>:
.globl vector85
vector85:
  pushl $0
801070c4:	6a 00                	push   $0x0
  pushl $85
801070c6:	6a 55                	push   $0x55
  jmp alltraps
801070c8:	e9 0f f8 ff ff       	jmp    801068dc <alltraps>

801070cd <vector86>:
.globl vector86
vector86:
  pushl $0
801070cd:	6a 00                	push   $0x0
  pushl $86
801070cf:	6a 56                	push   $0x56
  jmp alltraps
801070d1:	e9 06 f8 ff ff       	jmp    801068dc <alltraps>

801070d6 <vector87>:
.globl vector87
vector87:
  pushl $0
801070d6:	6a 00                	push   $0x0
  pushl $87
801070d8:	6a 57                	push   $0x57
  jmp alltraps
801070da:	e9 fd f7 ff ff       	jmp    801068dc <alltraps>

801070df <vector88>:
.globl vector88
vector88:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $88
801070e1:	6a 58                	push   $0x58
  jmp alltraps
801070e3:	e9 f4 f7 ff ff       	jmp    801068dc <alltraps>

801070e8 <vector89>:
.globl vector89
vector89:
  pushl $0
801070e8:	6a 00                	push   $0x0
  pushl $89
801070ea:	6a 59                	push   $0x59
  jmp alltraps
801070ec:	e9 eb f7 ff ff       	jmp    801068dc <alltraps>

801070f1 <vector90>:
.globl vector90
vector90:
  pushl $0
801070f1:	6a 00                	push   $0x0
  pushl $90
801070f3:	6a 5a                	push   $0x5a
  jmp alltraps
801070f5:	e9 e2 f7 ff ff       	jmp    801068dc <alltraps>

801070fa <vector91>:
.globl vector91
vector91:
  pushl $0
801070fa:	6a 00                	push   $0x0
  pushl $91
801070fc:	6a 5b                	push   $0x5b
  jmp alltraps
801070fe:	e9 d9 f7 ff ff       	jmp    801068dc <alltraps>

80107103 <vector92>:
.globl vector92
vector92:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $92
80107105:	6a 5c                	push   $0x5c
  jmp alltraps
80107107:	e9 d0 f7 ff ff       	jmp    801068dc <alltraps>

8010710c <vector93>:
.globl vector93
vector93:
  pushl $0
8010710c:	6a 00                	push   $0x0
  pushl $93
8010710e:	6a 5d                	push   $0x5d
  jmp alltraps
80107110:	e9 c7 f7 ff ff       	jmp    801068dc <alltraps>

80107115 <vector94>:
.globl vector94
vector94:
  pushl $0
80107115:	6a 00                	push   $0x0
  pushl $94
80107117:	6a 5e                	push   $0x5e
  jmp alltraps
80107119:	e9 be f7 ff ff       	jmp    801068dc <alltraps>

8010711e <vector95>:
.globl vector95
vector95:
  pushl $0
8010711e:	6a 00                	push   $0x0
  pushl $95
80107120:	6a 5f                	push   $0x5f
  jmp alltraps
80107122:	e9 b5 f7 ff ff       	jmp    801068dc <alltraps>

80107127 <vector96>:
.globl vector96
vector96:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $96
80107129:	6a 60                	push   $0x60
  jmp alltraps
8010712b:	e9 ac f7 ff ff       	jmp    801068dc <alltraps>

80107130 <vector97>:
.globl vector97
vector97:
  pushl $0
80107130:	6a 00                	push   $0x0
  pushl $97
80107132:	6a 61                	push   $0x61
  jmp alltraps
80107134:	e9 a3 f7 ff ff       	jmp    801068dc <alltraps>

80107139 <vector98>:
.globl vector98
vector98:
  pushl $0
80107139:	6a 00                	push   $0x0
  pushl $98
8010713b:	6a 62                	push   $0x62
  jmp alltraps
8010713d:	e9 9a f7 ff ff       	jmp    801068dc <alltraps>

80107142 <vector99>:
.globl vector99
vector99:
  pushl $0
80107142:	6a 00                	push   $0x0
  pushl $99
80107144:	6a 63                	push   $0x63
  jmp alltraps
80107146:	e9 91 f7 ff ff       	jmp    801068dc <alltraps>

8010714b <vector100>:
.globl vector100
vector100:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $100
8010714d:	6a 64                	push   $0x64
  jmp alltraps
8010714f:	e9 88 f7 ff ff       	jmp    801068dc <alltraps>

80107154 <vector101>:
.globl vector101
vector101:
  pushl $0
80107154:	6a 00                	push   $0x0
  pushl $101
80107156:	6a 65                	push   $0x65
  jmp alltraps
80107158:	e9 7f f7 ff ff       	jmp    801068dc <alltraps>

8010715d <vector102>:
.globl vector102
vector102:
  pushl $0
8010715d:	6a 00                	push   $0x0
  pushl $102
8010715f:	6a 66                	push   $0x66
  jmp alltraps
80107161:	e9 76 f7 ff ff       	jmp    801068dc <alltraps>

80107166 <vector103>:
.globl vector103
vector103:
  pushl $0
80107166:	6a 00                	push   $0x0
  pushl $103
80107168:	6a 67                	push   $0x67
  jmp alltraps
8010716a:	e9 6d f7 ff ff       	jmp    801068dc <alltraps>

8010716f <vector104>:
.globl vector104
vector104:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $104
80107171:	6a 68                	push   $0x68
  jmp alltraps
80107173:	e9 64 f7 ff ff       	jmp    801068dc <alltraps>

80107178 <vector105>:
.globl vector105
vector105:
  pushl $0
80107178:	6a 00                	push   $0x0
  pushl $105
8010717a:	6a 69                	push   $0x69
  jmp alltraps
8010717c:	e9 5b f7 ff ff       	jmp    801068dc <alltraps>

80107181 <vector106>:
.globl vector106
vector106:
  pushl $0
80107181:	6a 00                	push   $0x0
  pushl $106
80107183:	6a 6a                	push   $0x6a
  jmp alltraps
80107185:	e9 52 f7 ff ff       	jmp    801068dc <alltraps>

8010718a <vector107>:
.globl vector107
vector107:
  pushl $0
8010718a:	6a 00                	push   $0x0
  pushl $107
8010718c:	6a 6b                	push   $0x6b
  jmp alltraps
8010718e:	e9 49 f7 ff ff       	jmp    801068dc <alltraps>

80107193 <vector108>:
.globl vector108
vector108:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $108
80107195:	6a 6c                	push   $0x6c
  jmp alltraps
80107197:	e9 40 f7 ff ff       	jmp    801068dc <alltraps>

8010719c <vector109>:
.globl vector109
vector109:
  pushl $0
8010719c:	6a 00                	push   $0x0
  pushl $109
8010719e:	6a 6d                	push   $0x6d
  jmp alltraps
801071a0:	e9 37 f7 ff ff       	jmp    801068dc <alltraps>

801071a5 <vector110>:
.globl vector110
vector110:
  pushl $0
801071a5:	6a 00                	push   $0x0
  pushl $110
801071a7:	6a 6e                	push   $0x6e
  jmp alltraps
801071a9:	e9 2e f7 ff ff       	jmp    801068dc <alltraps>

801071ae <vector111>:
.globl vector111
vector111:
  pushl $0
801071ae:	6a 00                	push   $0x0
  pushl $111
801071b0:	6a 6f                	push   $0x6f
  jmp alltraps
801071b2:	e9 25 f7 ff ff       	jmp    801068dc <alltraps>

801071b7 <vector112>:
.globl vector112
vector112:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $112
801071b9:	6a 70                	push   $0x70
  jmp alltraps
801071bb:	e9 1c f7 ff ff       	jmp    801068dc <alltraps>

801071c0 <vector113>:
.globl vector113
vector113:
  pushl $0
801071c0:	6a 00                	push   $0x0
  pushl $113
801071c2:	6a 71                	push   $0x71
  jmp alltraps
801071c4:	e9 13 f7 ff ff       	jmp    801068dc <alltraps>

801071c9 <vector114>:
.globl vector114
vector114:
  pushl $0
801071c9:	6a 00                	push   $0x0
  pushl $114
801071cb:	6a 72                	push   $0x72
  jmp alltraps
801071cd:	e9 0a f7 ff ff       	jmp    801068dc <alltraps>

801071d2 <vector115>:
.globl vector115
vector115:
  pushl $0
801071d2:	6a 00                	push   $0x0
  pushl $115
801071d4:	6a 73                	push   $0x73
  jmp alltraps
801071d6:	e9 01 f7 ff ff       	jmp    801068dc <alltraps>

801071db <vector116>:
.globl vector116
vector116:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $116
801071dd:	6a 74                	push   $0x74
  jmp alltraps
801071df:	e9 f8 f6 ff ff       	jmp    801068dc <alltraps>

801071e4 <vector117>:
.globl vector117
vector117:
  pushl $0
801071e4:	6a 00                	push   $0x0
  pushl $117
801071e6:	6a 75                	push   $0x75
  jmp alltraps
801071e8:	e9 ef f6 ff ff       	jmp    801068dc <alltraps>

801071ed <vector118>:
.globl vector118
vector118:
  pushl $0
801071ed:	6a 00                	push   $0x0
  pushl $118
801071ef:	6a 76                	push   $0x76
  jmp alltraps
801071f1:	e9 e6 f6 ff ff       	jmp    801068dc <alltraps>

801071f6 <vector119>:
.globl vector119
vector119:
  pushl $0
801071f6:	6a 00                	push   $0x0
  pushl $119
801071f8:	6a 77                	push   $0x77
  jmp alltraps
801071fa:	e9 dd f6 ff ff       	jmp    801068dc <alltraps>

801071ff <vector120>:
.globl vector120
vector120:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $120
80107201:	6a 78                	push   $0x78
  jmp alltraps
80107203:	e9 d4 f6 ff ff       	jmp    801068dc <alltraps>

80107208 <vector121>:
.globl vector121
vector121:
  pushl $0
80107208:	6a 00                	push   $0x0
  pushl $121
8010720a:	6a 79                	push   $0x79
  jmp alltraps
8010720c:	e9 cb f6 ff ff       	jmp    801068dc <alltraps>

80107211 <vector122>:
.globl vector122
vector122:
  pushl $0
80107211:	6a 00                	push   $0x0
  pushl $122
80107213:	6a 7a                	push   $0x7a
  jmp alltraps
80107215:	e9 c2 f6 ff ff       	jmp    801068dc <alltraps>

8010721a <vector123>:
.globl vector123
vector123:
  pushl $0
8010721a:	6a 00                	push   $0x0
  pushl $123
8010721c:	6a 7b                	push   $0x7b
  jmp alltraps
8010721e:	e9 b9 f6 ff ff       	jmp    801068dc <alltraps>

80107223 <vector124>:
.globl vector124
vector124:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $124
80107225:	6a 7c                	push   $0x7c
  jmp alltraps
80107227:	e9 b0 f6 ff ff       	jmp    801068dc <alltraps>

8010722c <vector125>:
.globl vector125
vector125:
  pushl $0
8010722c:	6a 00                	push   $0x0
  pushl $125
8010722e:	6a 7d                	push   $0x7d
  jmp alltraps
80107230:	e9 a7 f6 ff ff       	jmp    801068dc <alltraps>

80107235 <vector126>:
.globl vector126
vector126:
  pushl $0
80107235:	6a 00                	push   $0x0
  pushl $126
80107237:	6a 7e                	push   $0x7e
  jmp alltraps
80107239:	e9 9e f6 ff ff       	jmp    801068dc <alltraps>

8010723e <vector127>:
.globl vector127
vector127:
  pushl $0
8010723e:	6a 00                	push   $0x0
  pushl $127
80107240:	6a 7f                	push   $0x7f
  jmp alltraps
80107242:	e9 95 f6 ff ff       	jmp    801068dc <alltraps>

80107247 <vector128>:
.globl vector128
vector128:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $128
80107249:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010724e:	e9 89 f6 ff ff       	jmp    801068dc <alltraps>

80107253 <vector129>:
.globl vector129
vector129:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $129
80107255:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010725a:	e9 7d f6 ff ff       	jmp    801068dc <alltraps>

8010725f <vector130>:
.globl vector130
vector130:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $130
80107261:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107266:	e9 71 f6 ff ff       	jmp    801068dc <alltraps>

8010726b <vector131>:
.globl vector131
vector131:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $131
8010726d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107272:	e9 65 f6 ff ff       	jmp    801068dc <alltraps>

80107277 <vector132>:
.globl vector132
vector132:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $132
80107279:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010727e:	e9 59 f6 ff ff       	jmp    801068dc <alltraps>

80107283 <vector133>:
.globl vector133
vector133:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $133
80107285:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010728a:	e9 4d f6 ff ff       	jmp    801068dc <alltraps>

8010728f <vector134>:
.globl vector134
vector134:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $134
80107291:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107296:	e9 41 f6 ff ff       	jmp    801068dc <alltraps>

8010729b <vector135>:
.globl vector135
vector135:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $135
8010729d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801072a2:	e9 35 f6 ff ff       	jmp    801068dc <alltraps>

801072a7 <vector136>:
.globl vector136
vector136:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $136
801072a9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801072ae:	e9 29 f6 ff ff       	jmp    801068dc <alltraps>

801072b3 <vector137>:
.globl vector137
vector137:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $137
801072b5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801072ba:	e9 1d f6 ff ff       	jmp    801068dc <alltraps>

801072bf <vector138>:
.globl vector138
vector138:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $138
801072c1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801072c6:	e9 11 f6 ff ff       	jmp    801068dc <alltraps>

801072cb <vector139>:
.globl vector139
vector139:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $139
801072cd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801072d2:	e9 05 f6 ff ff       	jmp    801068dc <alltraps>

801072d7 <vector140>:
.globl vector140
vector140:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $140
801072d9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801072de:	e9 f9 f5 ff ff       	jmp    801068dc <alltraps>

801072e3 <vector141>:
.globl vector141
vector141:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $141
801072e5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801072ea:	e9 ed f5 ff ff       	jmp    801068dc <alltraps>

801072ef <vector142>:
.globl vector142
vector142:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $142
801072f1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801072f6:	e9 e1 f5 ff ff       	jmp    801068dc <alltraps>

801072fb <vector143>:
.globl vector143
vector143:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $143
801072fd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107302:	e9 d5 f5 ff ff       	jmp    801068dc <alltraps>

80107307 <vector144>:
.globl vector144
vector144:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $144
80107309:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010730e:	e9 c9 f5 ff ff       	jmp    801068dc <alltraps>

80107313 <vector145>:
.globl vector145
vector145:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $145
80107315:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010731a:	e9 bd f5 ff ff       	jmp    801068dc <alltraps>

8010731f <vector146>:
.globl vector146
vector146:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $146
80107321:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107326:	e9 b1 f5 ff ff       	jmp    801068dc <alltraps>

8010732b <vector147>:
.globl vector147
vector147:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $147
8010732d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107332:	e9 a5 f5 ff ff       	jmp    801068dc <alltraps>

80107337 <vector148>:
.globl vector148
vector148:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $148
80107339:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010733e:	e9 99 f5 ff ff       	jmp    801068dc <alltraps>

80107343 <vector149>:
.globl vector149
vector149:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $149
80107345:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010734a:	e9 8d f5 ff ff       	jmp    801068dc <alltraps>

8010734f <vector150>:
.globl vector150
vector150:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $150
80107351:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107356:	e9 81 f5 ff ff       	jmp    801068dc <alltraps>

8010735b <vector151>:
.globl vector151
vector151:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $151
8010735d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107362:	e9 75 f5 ff ff       	jmp    801068dc <alltraps>

80107367 <vector152>:
.globl vector152
vector152:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $152
80107369:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010736e:	e9 69 f5 ff ff       	jmp    801068dc <alltraps>

80107373 <vector153>:
.globl vector153
vector153:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $153
80107375:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010737a:	e9 5d f5 ff ff       	jmp    801068dc <alltraps>

8010737f <vector154>:
.globl vector154
vector154:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $154
80107381:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107386:	e9 51 f5 ff ff       	jmp    801068dc <alltraps>

8010738b <vector155>:
.globl vector155
vector155:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $155
8010738d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107392:	e9 45 f5 ff ff       	jmp    801068dc <alltraps>

80107397 <vector156>:
.globl vector156
vector156:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $156
80107399:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010739e:	e9 39 f5 ff ff       	jmp    801068dc <alltraps>

801073a3 <vector157>:
.globl vector157
vector157:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $157
801073a5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801073aa:	e9 2d f5 ff ff       	jmp    801068dc <alltraps>

801073af <vector158>:
.globl vector158
vector158:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $158
801073b1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801073b6:	e9 21 f5 ff ff       	jmp    801068dc <alltraps>

801073bb <vector159>:
.globl vector159
vector159:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $159
801073bd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801073c2:	e9 15 f5 ff ff       	jmp    801068dc <alltraps>

801073c7 <vector160>:
.globl vector160
vector160:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $160
801073c9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801073ce:	e9 09 f5 ff ff       	jmp    801068dc <alltraps>

801073d3 <vector161>:
.globl vector161
vector161:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $161
801073d5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801073da:	e9 fd f4 ff ff       	jmp    801068dc <alltraps>

801073df <vector162>:
.globl vector162
vector162:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $162
801073e1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801073e6:	e9 f1 f4 ff ff       	jmp    801068dc <alltraps>

801073eb <vector163>:
.globl vector163
vector163:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $163
801073ed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801073f2:	e9 e5 f4 ff ff       	jmp    801068dc <alltraps>

801073f7 <vector164>:
.globl vector164
vector164:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $164
801073f9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801073fe:	e9 d9 f4 ff ff       	jmp    801068dc <alltraps>

80107403 <vector165>:
.globl vector165
vector165:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $165
80107405:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010740a:	e9 cd f4 ff ff       	jmp    801068dc <alltraps>

8010740f <vector166>:
.globl vector166
vector166:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $166
80107411:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107416:	e9 c1 f4 ff ff       	jmp    801068dc <alltraps>

8010741b <vector167>:
.globl vector167
vector167:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $167
8010741d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107422:	e9 b5 f4 ff ff       	jmp    801068dc <alltraps>

80107427 <vector168>:
.globl vector168
vector168:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $168
80107429:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010742e:	e9 a9 f4 ff ff       	jmp    801068dc <alltraps>

80107433 <vector169>:
.globl vector169
vector169:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $169
80107435:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010743a:	e9 9d f4 ff ff       	jmp    801068dc <alltraps>

8010743f <vector170>:
.globl vector170
vector170:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $170
80107441:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107446:	e9 91 f4 ff ff       	jmp    801068dc <alltraps>

8010744b <vector171>:
.globl vector171
vector171:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $171
8010744d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107452:	e9 85 f4 ff ff       	jmp    801068dc <alltraps>

80107457 <vector172>:
.globl vector172
vector172:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $172
80107459:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010745e:	e9 79 f4 ff ff       	jmp    801068dc <alltraps>

80107463 <vector173>:
.globl vector173
vector173:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $173
80107465:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010746a:	e9 6d f4 ff ff       	jmp    801068dc <alltraps>

8010746f <vector174>:
.globl vector174
vector174:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $174
80107471:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107476:	e9 61 f4 ff ff       	jmp    801068dc <alltraps>

8010747b <vector175>:
.globl vector175
vector175:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $175
8010747d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107482:	e9 55 f4 ff ff       	jmp    801068dc <alltraps>

80107487 <vector176>:
.globl vector176
vector176:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $176
80107489:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010748e:	e9 49 f4 ff ff       	jmp    801068dc <alltraps>

80107493 <vector177>:
.globl vector177
vector177:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $177
80107495:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010749a:	e9 3d f4 ff ff       	jmp    801068dc <alltraps>

8010749f <vector178>:
.globl vector178
vector178:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $178
801074a1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801074a6:	e9 31 f4 ff ff       	jmp    801068dc <alltraps>

801074ab <vector179>:
.globl vector179
vector179:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $179
801074ad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801074b2:	e9 25 f4 ff ff       	jmp    801068dc <alltraps>

801074b7 <vector180>:
.globl vector180
vector180:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $180
801074b9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801074be:	e9 19 f4 ff ff       	jmp    801068dc <alltraps>

801074c3 <vector181>:
.globl vector181
vector181:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $181
801074c5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801074ca:	e9 0d f4 ff ff       	jmp    801068dc <alltraps>

801074cf <vector182>:
.globl vector182
vector182:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $182
801074d1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801074d6:	e9 01 f4 ff ff       	jmp    801068dc <alltraps>

801074db <vector183>:
.globl vector183
vector183:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $183
801074dd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801074e2:	e9 f5 f3 ff ff       	jmp    801068dc <alltraps>

801074e7 <vector184>:
.globl vector184
vector184:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $184
801074e9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801074ee:	e9 e9 f3 ff ff       	jmp    801068dc <alltraps>

801074f3 <vector185>:
.globl vector185
vector185:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $185
801074f5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801074fa:	e9 dd f3 ff ff       	jmp    801068dc <alltraps>

801074ff <vector186>:
.globl vector186
vector186:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $186
80107501:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107506:	e9 d1 f3 ff ff       	jmp    801068dc <alltraps>

8010750b <vector187>:
.globl vector187
vector187:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $187
8010750d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107512:	e9 c5 f3 ff ff       	jmp    801068dc <alltraps>

80107517 <vector188>:
.globl vector188
vector188:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $188
80107519:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010751e:	e9 b9 f3 ff ff       	jmp    801068dc <alltraps>

80107523 <vector189>:
.globl vector189
vector189:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $189
80107525:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010752a:	e9 ad f3 ff ff       	jmp    801068dc <alltraps>

8010752f <vector190>:
.globl vector190
vector190:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $190
80107531:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107536:	e9 a1 f3 ff ff       	jmp    801068dc <alltraps>

8010753b <vector191>:
.globl vector191
vector191:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $191
8010753d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107542:	e9 95 f3 ff ff       	jmp    801068dc <alltraps>

80107547 <vector192>:
.globl vector192
vector192:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $192
80107549:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010754e:	e9 89 f3 ff ff       	jmp    801068dc <alltraps>

80107553 <vector193>:
.globl vector193
vector193:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $193
80107555:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010755a:	e9 7d f3 ff ff       	jmp    801068dc <alltraps>

8010755f <vector194>:
.globl vector194
vector194:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $194
80107561:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107566:	e9 71 f3 ff ff       	jmp    801068dc <alltraps>

8010756b <vector195>:
.globl vector195
vector195:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $195
8010756d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107572:	e9 65 f3 ff ff       	jmp    801068dc <alltraps>

80107577 <vector196>:
.globl vector196
vector196:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $196
80107579:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010757e:	e9 59 f3 ff ff       	jmp    801068dc <alltraps>

80107583 <vector197>:
.globl vector197
vector197:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $197
80107585:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010758a:	e9 4d f3 ff ff       	jmp    801068dc <alltraps>

8010758f <vector198>:
.globl vector198
vector198:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $198
80107591:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107596:	e9 41 f3 ff ff       	jmp    801068dc <alltraps>

8010759b <vector199>:
.globl vector199
vector199:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $199
8010759d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801075a2:	e9 35 f3 ff ff       	jmp    801068dc <alltraps>

801075a7 <vector200>:
.globl vector200
vector200:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $200
801075a9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801075ae:	e9 29 f3 ff ff       	jmp    801068dc <alltraps>

801075b3 <vector201>:
.globl vector201
vector201:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $201
801075b5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801075ba:	e9 1d f3 ff ff       	jmp    801068dc <alltraps>

801075bf <vector202>:
.globl vector202
vector202:
  pushl $0
801075bf:	6a 00                	push   $0x0
  pushl $202
801075c1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801075c6:	e9 11 f3 ff ff       	jmp    801068dc <alltraps>

801075cb <vector203>:
.globl vector203
vector203:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $203
801075cd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801075d2:	e9 05 f3 ff ff       	jmp    801068dc <alltraps>

801075d7 <vector204>:
.globl vector204
vector204:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $204
801075d9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801075de:	e9 f9 f2 ff ff       	jmp    801068dc <alltraps>

801075e3 <vector205>:
.globl vector205
vector205:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $205
801075e5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801075ea:	e9 ed f2 ff ff       	jmp    801068dc <alltraps>

801075ef <vector206>:
.globl vector206
vector206:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $206
801075f1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801075f6:	e9 e1 f2 ff ff       	jmp    801068dc <alltraps>

801075fb <vector207>:
.globl vector207
vector207:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $207
801075fd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107602:	e9 d5 f2 ff ff       	jmp    801068dc <alltraps>

80107607 <vector208>:
.globl vector208
vector208:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $208
80107609:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010760e:	e9 c9 f2 ff ff       	jmp    801068dc <alltraps>

80107613 <vector209>:
.globl vector209
vector209:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $209
80107615:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010761a:	e9 bd f2 ff ff       	jmp    801068dc <alltraps>

8010761f <vector210>:
.globl vector210
vector210:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $210
80107621:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107626:	e9 b1 f2 ff ff       	jmp    801068dc <alltraps>

8010762b <vector211>:
.globl vector211
vector211:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $211
8010762d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107632:	e9 a5 f2 ff ff       	jmp    801068dc <alltraps>

80107637 <vector212>:
.globl vector212
vector212:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $212
80107639:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010763e:	e9 99 f2 ff ff       	jmp    801068dc <alltraps>

80107643 <vector213>:
.globl vector213
vector213:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $213
80107645:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010764a:	e9 8d f2 ff ff       	jmp    801068dc <alltraps>

8010764f <vector214>:
.globl vector214
vector214:
  pushl $0
8010764f:	6a 00                	push   $0x0
  pushl $214
80107651:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107656:	e9 81 f2 ff ff       	jmp    801068dc <alltraps>

8010765b <vector215>:
.globl vector215
vector215:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $215
8010765d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107662:	e9 75 f2 ff ff       	jmp    801068dc <alltraps>

80107667 <vector216>:
.globl vector216
vector216:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $216
80107669:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010766e:	e9 69 f2 ff ff       	jmp    801068dc <alltraps>

80107673 <vector217>:
.globl vector217
vector217:
  pushl $0
80107673:	6a 00                	push   $0x0
  pushl $217
80107675:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010767a:	e9 5d f2 ff ff       	jmp    801068dc <alltraps>

8010767f <vector218>:
.globl vector218
vector218:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $218
80107681:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107686:	e9 51 f2 ff ff       	jmp    801068dc <alltraps>

8010768b <vector219>:
.globl vector219
vector219:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $219
8010768d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107692:	e9 45 f2 ff ff       	jmp    801068dc <alltraps>

80107697 <vector220>:
.globl vector220
vector220:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $220
80107699:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010769e:	e9 39 f2 ff ff       	jmp    801068dc <alltraps>

801076a3 <vector221>:
.globl vector221
vector221:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $221
801076a5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801076aa:	e9 2d f2 ff ff       	jmp    801068dc <alltraps>

801076af <vector222>:
.globl vector222
vector222:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $222
801076b1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801076b6:	e9 21 f2 ff ff       	jmp    801068dc <alltraps>

801076bb <vector223>:
.globl vector223
vector223:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $223
801076bd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801076c2:	e9 15 f2 ff ff       	jmp    801068dc <alltraps>

801076c7 <vector224>:
.globl vector224
vector224:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $224
801076c9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801076ce:	e9 09 f2 ff ff       	jmp    801068dc <alltraps>

801076d3 <vector225>:
.globl vector225
vector225:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $225
801076d5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801076da:	e9 fd f1 ff ff       	jmp    801068dc <alltraps>

801076df <vector226>:
.globl vector226
vector226:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $226
801076e1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801076e6:	e9 f1 f1 ff ff       	jmp    801068dc <alltraps>

801076eb <vector227>:
.globl vector227
vector227:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $227
801076ed:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801076f2:	e9 e5 f1 ff ff       	jmp    801068dc <alltraps>

801076f7 <vector228>:
.globl vector228
vector228:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $228
801076f9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801076fe:	e9 d9 f1 ff ff       	jmp    801068dc <alltraps>

80107703 <vector229>:
.globl vector229
vector229:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $229
80107705:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010770a:	e9 cd f1 ff ff       	jmp    801068dc <alltraps>

8010770f <vector230>:
.globl vector230
vector230:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $230
80107711:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107716:	e9 c1 f1 ff ff       	jmp    801068dc <alltraps>

8010771b <vector231>:
.globl vector231
vector231:
  pushl $0
8010771b:	6a 00                	push   $0x0
  pushl $231
8010771d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107722:	e9 b5 f1 ff ff       	jmp    801068dc <alltraps>

80107727 <vector232>:
.globl vector232
vector232:
  pushl $0
80107727:	6a 00                	push   $0x0
  pushl $232
80107729:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010772e:	e9 a9 f1 ff ff       	jmp    801068dc <alltraps>

80107733 <vector233>:
.globl vector233
vector233:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $233
80107735:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010773a:	e9 9d f1 ff ff       	jmp    801068dc <alltraps>

8010773f <vector234>:
.globl vector234
vector234:
  pushl $0
8010773f:	6a 00                	push   $0x0
  pushl $234
80107741:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107746:	e9 91 f1 ff ff       	jmp    801068dc <alltraps>

8010774b <vector235>:
.globl vector235
vector235:
  pushl $0
8010774b:	6a 00                	push   $0x0
  pushl $235
8010774d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107752:	e9 85 f1 ff ff       	jmp    801068dc <alltraps>

80107757 <vector236>:
.globl vector236
vector236:
  pushl $0
80107757:	6a 00                	push   $0x0
  pushl $236
80107759:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010775e:	e9 79 f1 ff ff       	jmp    801068dc <alltraps>

80107763 <vector237>:
.globl vector237
vector237:
  pushl $0
80107763:	6a 00                	push   $0x0
  pushl $237
80107765:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010776a:	e9 6d f1 ff ff       	jmp    801068dc <alltraps>

8010776f <vector238>:
.globl vector238
vector238:
  pushl $0
8010776f:	6a 00                	push   $0x0
  pushl $238
80107771:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107776:	e9 61 f1 ff ff       	jmp    801068dc <alltraps>

8010777b <vector239>:
.globl vector239
vector239:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $239
8010777d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107782:	e9 55 f1 ff ff       	jmp    801068dc <alltraps>

80107787 <vector240>:
.globl vector240
vector240:
  pushl $0
80107787:	6a 00                	push   $0x0
  pushl $240
80107789:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010778e:	e9 49 f1 ff ff       	jmp    801068dc <alltraps>

80107793 <vector241>:
.globl vector241
vector241:
  pushl $0
80107793:	6a 00                	push   $0x0
  pushl $241
80107795:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010779a:	e9 3d f1 ff ff       	jmp    801068dc <alltraps>

8010779f <vector242>:
.globl vector242
vector242:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $242
801077a1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801077a6:	e9 31 f1 ff ff       	jmp    801068dc <alltraps>

801077ab <vector243>:
.globl vector243
vector243:
  pushl $0
801077ab:	6a 00                	push   $0x0
  pushl $243
801077ad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801077b2:	e9 25 f1 ff ff       	jmp    801068dc <alltraps>

801077b7 <vector244>:
.globl vector244
vector244:
  pushl $0
801077b7:	6a 00                	push   $0x0
  pushl $244
801077b9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801077be:	e9 19 f1 ff ff       	jmp    801068dc <alltraps>

801077c3 <vector245>:
.globl vector245
vector245:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $245
801077c5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801077ca:	e9 0d f1 ff ff       	jmp    801068dc <alltraps>

801077cf <vector246>:
.globl vector246
vector246:
  pushl $0
801077cf:	6a 00                	push   $0x0
  pushl $246
801077d1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801077d6:	e9 01 f1 ff ff       	jmp    801068dc <alltraps>

801077db <vector247>:
.globl vector247
vector247:
  pushl $0
801077db:	6a 00                	push   $0x0
  pushl $247
801077dd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801077e2:	e9 f5 f0 ff ff       	jmp    801068dc <alltraps>

801077e7 <vector248>:
.globl vector248
vector248:
  pushl $0
801077e7:	6a 00                	push   $0x0
  pushl $248
801077e9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801077ee:	e9 e9 f0 ff ff       	jmp    801068dc <alltraps>

801077f3 <vector249>:
.globl vector249
vector249:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $249
801077f5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801077fa:	e9 dd f0 ff ff       	jmp    801068dc <alltraps>

801077ff <vector250>:
.globl vector250
vector250:
  pushl $0
801077ff:	6a 00                	push   $0x0
  pushl $250
80107801:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107806:	e9 d1 f0 ff ff       	jmp    801068dc <alltraps>

8010780b <vector251>:
.globl vector251
vector251:
  pushl $0
8010780b:	6a 00                	push   $0x0
  pushl $251
8010780d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107812:	e9 c5 f0 ff ff       	jmp    801068dc <alltraps>

80107817 <vector252>:
.globl vector252
vector252:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $252
80107819:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010781e:	e9 b9 f0 ff ff       	jmp    801068dc <alltraps>

80107823 <vector253>:
.globl vector253
vector253:
  pushl $0
80107823:	6a 00                	push   $0x0
  pushl $253
80107825:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010782a:	e9 ad f0 ff ff       	jmp    801068dc <alltraps>

8010782f <vector254>:
.globl vector254
vector254:
  pushl $0
8010782f:	6a 00                	push   $0x0
  pushl $254
80107831:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107836:	e9 a1 f0 ff ff       	jmp    801068dc <alltraps>

8010783b <vector255>:
.globl vector255
vector255:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $255
8010783d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107842:	e9 95 f0 ff ff       	jmp    801068dc <alltraps>
80107847:	66 90                	xchg   %ax,%ax
80107849:	66 90                	xchg   %ax,%ax
8010784b:	66 90                	xchg   %ax,%ax
8010784d:	66 90                	xchg   %ax,%ax
8010784f:	90                   	nop

80107850 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107850:	55                   	push   %ebp
80107851:	89 e5                	mov    %esp,%ebp
80107853:	57                   	push   %edi
80107854:	56                   	push   %esi
80107855:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107856:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010785c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107862:	83 ec 1c             	sub    $0x1c,%esp
80107865:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107868:	39 d3                	cmp    %edx,%ebx
8010786a:	73 49                	jae    801078b5 <deallocuvm.part.0+0x65>
8010786c:	89 c7                	mov    %eax,%edi
8010786e:	eb 0c                	jmp    8010787c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107870:	83 c0 01             	add    $0x1,%eax
80107873:	c1 e0 16             	shl    $0x16,%eax
80107876:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107878:	39 da                	cmp    %ebx,%edx
8010787a:	76 39                	jbe    801078b5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010787c:	89 d8                	mov    %ebx,%eax
8010787e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107881:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107884:	f6 c1 01             	test   $0x1,%cl
80107887:	74 e7                	je     80107870 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107889:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010788b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107891:	c1 ee 0a             	shr    $0xa,%esi
80107894:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010789a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
801078a1:	85 f6                	test   %esi,%esi
801078a3:	74 cb                	je     80107870 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
801078a5:	8b 06                	mov    (%esi),%eax
801078a7:	a8 01                	test   $0x1,%al
801078a9:	75 15                	jne    801078c0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
801078ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801078b1:	39 da                	cmp    %ebx,%edx
801078b3:	77 c7                	ja     8010787c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801078b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078bb:	5b                   	pop    %ebx
801078bc:	5e                   	pop    %esi
801078bd:	5f                   	pop    %edi
801078be:	5d                   	pop    %ebp
801078bf:	c3                   	ret    
      if(pa == 0)
801078c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801078c5:	74 25                	je     801078ec <deallocuvm.part.0+0x9c>
      kfree(v);
801078c7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801078ca:	05 00 00 00 80       	add    $0x80000000,%eax
801078cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801078d2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801078d8:	50                   	push   %eax
801078d9:	e8 e2 ab ff ff       	call   801024c0 <kfree>
      *pte = 0;
801078de:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
801078e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801078e7:	83 c4 10             	add    $0x10,%esp
801078ea:	eb 8c                	jmp    80107878 <deallocuvm.part.0+0x28>
        panic("kfree");
801078ec:	83 ec 0c             	sub    $0xc,%esp
801078ef:	68 a6 84 10 80       	push   $0x801084a6
801078f4:	e8 87 8a ff ff       	call   80100380 <panic>
801078f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107900 <mappages>:
{
80107900:	55                   	push   %ebp
80107901:	89 e5                	mov    %esp,%ebp
80107903:	57                   	push   %edi
80107904:	56                   	push   %esi
80107905:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107906:	89 d3                	mov    %edx,%ebx
80107908:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010790e:	83 ec 1c             	sub    $0x1c,%esp
80107911:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107914:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107918:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010791d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107920:	8b 45 08             	mov    0x8(%ebp),%eax
80107923:	29 d8                	sub    %ebx,%eax
80107925:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107928:	eb 3d                	jmp    80107967 <mappages+0x67>
8010792a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107930:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107932:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107937:	c1 ea 0a             	shr    $0xa,%edx
8010793a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107940:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107947:	85 c0                	test   %eax,%eax
80107949:	74 75                	je     801079c0 <mappages+0xc0>
    if(*pte & PTE_P)
8010794b:	f6 00 01             	testb  $0x1,(%eax)
8010794e:	0f 85 86 00 00 00    	jne    801079da <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107954:	0b 75 0c             	or     0xc(%ebp),%esi
80107957:	83 ce 01             	or     $0x1,%esi
8010795a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010795c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010795f:	74 6f                	je     801079d0 <mappages+0xd0>
    a += PGSIZE;
80107961:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107967:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010796a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010796d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107970:	89 d8                	mov    %ebx,%eax
80107972:	c1 e8 16             	shr    $0x16,%eax
80107975:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107978:	8b 07                	mov    (%edi),%eax
8010797a:	a8 01                	test   $0x1,%al
8010797c:	75 b2                	jne    80107930 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010797e:	e8 fd ac ff ff       	call   80102680 <kalloc>
80107983:	85 c0                	test   %eax,%eax
80107985:	74 39                	je     801079c0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107987:	83 ec 04             	sub    $0x4,%esp
8010798a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010798d:	68 00 10 00 00       	push   $0x1000
80107992:	6a 00                	push   $0x0
80107994:	50                   	push   %eax
80107995:	e8 66 d7 ff ff       	call   80105100 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010799a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010799d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801079a0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801079a6:	83 c8 07             	or     $0x7,%eax
801079a9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801079ab:	89 d8                	mov    %ebx,%eax
801079ad:	c1 e8 0a             	shr    $0xa,%eax
801079b0:	25 fc 0f 00 00       	and    $0xffc,%eax
801079b5:	01 d0                	add    %edx,%eax
801079b7:	eb 92                	jmp    8010794b <mappages+0x4b>
801079b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801079c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079c8:	5b                   	pop    %ebx
801079c9:	5e                   	pop    %esi
801079ca:	5f                   	pop    %edi
801079cb:	5d                   	pop    %ebp
801079cc:	c3                   	ret    
801079cd:	8d 76 00             	lea    0x0(%esi),%esi
801079d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079d3:	31 c0                	xor    %eax,%eax
}
801079d5:	5b                   	pop    %ebx
801079d6:	5e                   	pop    %esi
801079d7:	5f                   	pop    %edi
801079d8:	5d                   	pop    %ebp
801079d9:	c3                   	ret    
      panic("remap");
801079da:	83 ec 0c             	sub    $0xc,%esp
801079dd:	68 44 8c 10 80       	push   $0x80108c44
801079e2:	e8 99 89 ff ff       	call   80100380 <panic>
801079e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079ee:	66 90                	xchg   %ax,%ax

801079f0 <seginit>:
{
801079f0:	55                   	push   %ebp
801079f1:	89 e5                	mov    %esp,%ebp
801079f3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801079f6:	e8 f5 bf ff ff       	call   801039f0 <cpuid>
  pd[0] = size-1;
801079fb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107a00:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107a06:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107a0a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107a11:	ff 00 00 
80107a14:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80107a1b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107a1e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107a25:	ff 00 00 
80107a28:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80107a2f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107a32:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107a39:	ff 00 00 
80107a3c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80107a43:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107a46:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80107a4d:	ff 00 00 
80107a50:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80107a57:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107a5a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80107a5f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107a63:	c1 e8 10             	shr    $0x10,%eax
80107a66:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107a6a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107a6d:	0f 01 10             	lgdtl  (%eax)
}
80107a70:	c9                   	leave  
80107a71:	c3                   	ret    
80107a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a80 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107a80:	a1 44 60 11 80       	mov    0x80116044,%eax
80107a85:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107a8a:	0f 22 d8             	mov    %eax,%cr3
}
80107a8d:	c3                   	ret    
80107a8e:	66 90                	xchg   %ax,%ax

80107a90 <switchuvm>:
{
80107a90:	55                   	push   %ebp
80107a91:	89 e5                	mov    %esp,%ebp
80107a93:	57                   	push   %edi
80107a94:	56                   	push   %esi
80107a95:	53                   	push   %ebx
80107a96:	83 ec 1c             	sub    $0x1c,%esp
80107a99:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107a9c:	85 f6                	test   %esi,%esi
80107a9e:	0f 84 cb 00 00 00    	je     80107b6f <switchuvm+0xdf>
  if(p->kstack == 0)
80107aa4:	8b 46 08             	mov    0x8(%esi),%eax
80107aa7:	85 c0                	test   %eax,%eax
80107aa9:	0f 84 da 00 00 00    	je     80107b89 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107aaf:	8b 46 04             	mov    0x4(%esi),%eax
80107ab2:	85 c0                	test   %eax,%eax
80107ab4:	0f 84 c2 00 00 00    	je     80107b7c <switchuvm+0xec>
  pushcli();
80107aba:	e8 31 d4 ff ff       	call   80104ef0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107abf:	e8 cc be ff ff       	call   80103990 <mycpu>
80107ac4:	89 c3                	mov    %eax,%ebx
80107ac6:	e8 c5 be ff ff       	call   80103990 <mycpu>
80107acb:	89 c7                	mov    %eax,%edi
80107acd:	e8 be be ff ff       	call   80103990 <mycpu>
80107ad2:	83 c7 08             	add    $0x8,%edi
80107ad5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107ad8:	e8 b3 be ff ff       	call   80103990 <mycpu>
80107add:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107ae0:	ba 67 00 00 00       	mov    $0x67,%edx
80107ae5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107aec:	83 c0 08             	add    $0x8,%eax
80107aef:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107af6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107afb:	83 c1 08             	add    $0x8,%ecx
80107afe:	c1 e8 18             	shr    $0x18,%eax
80107b01:	c1 e9 10             	shr    $0x10,%ecx
80107b04:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107b0a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107b10:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107b15:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107b1c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107b21:	e8 6a be ff ff       	call   80103990 <mycpu>
80107b26:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107b2d:	e8 5e be ff ff       	call   80103990 <mycpu>
80107b32:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107b36:	8b 5e 08             	mov    0x8(%esi),%ebx
80107b39:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107b3f:	e8 4c be ff ff       	call   80103990 <mycpu>
80107b44:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107b47:	e8 44 be ff ff       	call   80103990 <mycpu>
80107b4c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107b50:	b8 28 00 00 00       	mov    $0x28,%eax
80107b55:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107b58:	8b 46 04             	mov    0x4(%esi),%eax
80107b5b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107b60:	0f 22 d8             	mov    %eax,%cr3
}
80107b63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b66:	5b                   	pop    %ebx
80107b67:	5e                   	pop    %esi
80107b68:	5f                   	pop    %edi
80107b69:	5d                   	pop    %ebp
  popcli();
80107b6a:	e9 d1 d3 ff ff       	jmp    80104f40 <popcli>
    panic("switchuvm: no process");
80107b6f:	83 ec 0c             	sub    $0xc,%esp
80107b72:	68 4a 8c 10 80       	push   $0x80108c4a
80107b77:	e8 04 88 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80107b7c:	83 ec 0c             	sub    $0xc,%esp
80107b7f:	68 75 8c 10 80       	push   $0x80108c75
80107b84:	e8 f7 87 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107b89:	83 ec 0c             	sub    $0xc,%esp
80107b8c:	68 60 8c 10 80       	push   $0x80108c60
80107b91:	e8 ea 87 ff ff       	call   80100380 <panic>
80107b96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b9d:	8d 76 00             	lea    0x0(%esi),%esi

80107ba0 <inituvm>:
{
80107ba0:	55                   	push   %ebp
80107ba1:	89 e5                	mov    %esp,%ebp
80107ba3:	57                   	push   %edi
80107ba4:	56                   	push   %esi
80107ba5:	53                   	push   %ebx
80107ba6:	83 ec 1c             	sub    $0x1c,%esp
80107ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bac:	8b 75 10             	mov    0x10(%ebp),%esi
80107baf:	8b 7d 08             	mov    0x8(%ebp),%edi
80107bb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107bb5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107bbb:	77 4b                	ja     80107c08 <inituvm+0x68>
  mem = kalloc();
80107bbd:	e8 be aa ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80107bc2:	83 ec 04             	sub    $0x4,%esp
80107bc5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107bca:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107bcc:	6a 00                	push   $0x0
80107bce:	50                   	push   %eax
80107bcf:	e8 2c d5 ff ff       	call   80105100 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107bd4:	58                   	pop    %eax
80107bd5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107bdb:	5a                   	pop    %edx
80107bdc:	6a 06                	push   $0x6
80107bde:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107be3:	31 d2                	xor    %edx,%edx
80107be5:	50                   	push   %eax
80107be6:	89 f8                	mov    %edi,%eax
80107be8:	e8 13 fd ff ff       	call   80107900 <mappages>
  memmove(mem, init, sz);
80107bed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107bf0:	89 75 10             	mov    %esi,0x10(%ebp)
80107bf3:	83 c4 10             	add    $0x10,%esp
80107bf6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107bf9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107bfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bff:	5b                   	pop    %ebx
80107c00:	5e                   	pop    %esi
80107c01:	5f                   	pop    %edi
80107c02:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107c03:	e9 98 d5 ff ff       	jmp    801051a0 <memmove>
    panic("inituvm: more than a page");
80107c08:	83 ec 0c             	sub    $0xc,%esp
80107c0b:	68 89 8c 10 80       	push   $0x80108c89
80107c10:	e8 6b 87 ff ff       	call   80100380 <panic>
80107c15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107c20 <loaduvm>:
{
80107c20:	55                   	push   %ebp
80107c21:	89 e5                	mov    %esp,%ebp
80107c23:	57                   	push   %edi
80107c24:	56                   	push   %esi
80107c25:	53                   	push   %ebx
80107c26:	83 ec 1c             	sub    $0x1c,%esp
80107c29:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c2c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107c2f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107c34:	0f 85 bb 00 00 00    	jne    80107cf5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80107c3a:	01 f0                	add    %esi,%eax
80107c3c:	89 f3                	mov    %esi,%ebx
80107c3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107c41:	8b 45 14             	mov    0x14(%ebp),%eax
80107c44:	01 f0                	add    %esi,%eax
80107c46:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107c49:	85 f6                	test   %esi,%esi
80107c4b:	0f 84 87 00 00 00    	je     80107cd8 <loaduvm+0xb8>
80107c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107c58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80107c5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107c5e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107c60:	89 c2                	mov    %eax,%edx
80107c62:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107c65:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107c68:	f6 c2 01             	test   $0x1,%dl
80107c6b:	75 13                	jne    80107c80 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80107c6d:	83 ec 0c             	sub    $0xc,%esp
80107c70:	68 a3 8c 10 80       	push   $0x80108ca3
80107c75:	e8 06 87 ff ff       	call   80100380 <panic>
80107c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107c80:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107c83:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107c89:	25 fc 0f 00 00       	and    $0xffc,%eax
80107c8e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107c95:	85 c0                	test   %eax,%eax
80107c97:	74 d4                	je     80107c6d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107c99:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107c9b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107c9e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107ca3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107ca8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107cae:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107cb1:	29 d9                	sub    %ebx,%ecx
80107cb3:	05 00 00 00 80       	add    $0x80000000,%eax
80107cb8:	57                   	push   %edi
80107cb9:	51                   	push   %ecx
80107cba:	50                   	push   %eax
80107cbb:	ff 75 10             	push   0x10(%ebp)
80107cbe:	e8 cd 9d ff ff       	call   80101a90 <readi>
80107cc3:	83 c4 10             	add    $0x10,%esp
80107cc6:	39 f8                	cmp    %edi,%eax
80107cc8:	75 1e                	jne    80107ce8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107cca:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107cd0:	89 f0                	mov    %esi,%eax
80107cd2:	29 d8                	sub    %ebx,%eax
80107cd4:	39 c6                	cmp    %eax,%esi
80107cd6:	77 80                	ja     80107c58 <loaduvm+0x38>
}
80107cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107cdb:	31 c0                	xor    %eax,%eax
}
80107cdd:	5b                   	pop    %ebx
80107cde:	5e                   	pop    %esi
80107cdf:	5f                   	pop    %edi
80107ce0:	5d                   	pop    %ebp
80107ce1:	c3                   	ret    
80107ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107ceb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107cf0:	5b                   	pop    %ebx
80107cf1:	5e                   	pop    %esi
80107cf2:	5f                   	pop    %edi
80107cf3:	5d                   	pop    %ebp
80107cf4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107cf5:	83 ec 0c             	sub    $0xc,%esp
80107cf8:	68 44 8d 10 80       	push   $0x80108d44
80107cfd:	e8 7e 86 ff ff       	call   80100380 <panic>
80107d02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107d10 <allocuvm>:
{
80107d10:	55                   	push   %ebp
80107d11:	89 e5                	mov    %esp,%ebp
80107d13:	57                   	push   %edi
80107d14:	56                   	push   %esi
80107d15:	53                   	push   %ebx
80107d16:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107d19:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107d1c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107d1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107d22:	85 c0                	test   %eax,%eax
80107d24:	0f 88 b6 00 00 00    	js     80107de0 <allocuvm+0xd0>
  if(newsz < oldsz)
80107d2a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107d30:	0f 82 9a 00 00 00    	jb     80107dd0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107d36:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107d3c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107d42:	39 75 10             	cmp    %esi,0x10(%ebp)
80107d45:	77 44                	ja     80107d8b <allocuvm+0x7b>
80107d47:	e9 87 00 00 00       	jmp    80107dd3 <allocuvm+0xc3>
80107d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107d50:	83 ec 04             	sub    $0x4,%esp
80107d53:	68 00 10 00 00       	push   $0x1000
80107d58:	6a 00                	push   $0x0
80107d5a:	50                   	push   %eax
80107d5b:	e8 a0 d3 ff ff       	call   80105100 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107d60:	58                   	pop    %eax
80107d61:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107d67:	5a                   	pop    %edx
80107d68:	6a 06                	push   $0x6
80107d6a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d6f:	89 f2                	mov    %esi,%edx
80107d71:	50                   	push   %eax
80107d72:	89 f8                	mov    %edi,%eax
80107d74:	e8 87 fb ff ff       	call   80107900 <mappages>
80107d79:	83 c4 10             	add    $0x10,%esp
80107d7c:	85 c0                	test   %eax,%eax
80107d7e:	78 78                	js     80107df8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107d80:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107d86:	39 75 10             	cmp    %esi,0x10(%ebp)
80107d89:	76 48                	jbe    80107dd3 <allocuvm+0xc3>
    mem = kalloc();
80107d8b:	e8 f0 a8 ff ff       	call   80102680 <kalloc>
80107d90:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107d92:	85 c0                	test   %eax,%eax
80107d94:	75 ba                	jne    80107d50 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107d96:	83 ec 0c             	sub    $0xc,%esp
80107d99:	68 c1 8c 10 80       	push   $0x80108cc1
80107d9e:	e8 fd 88 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107da3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107da6:	83 c4 10             	add    $0x10,%esp
80107da9:	39 45 10             	cmp    %eax,0x10(%ebp)
80107dac:	74 32                	je     80107de0 <allocuvm+0xd0>
80107dae:	8b 55 10             	mov    0x10(%ebp),%edx
80107db1:	89 c1                	mov    %eax,%ecx
80107db3:	89 f8                	mov    %edi,%eax
80107db5:	e8 96 fa ff ff       	call   80107850 <deallocuvm.part.0>
      return 0;
80107dba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107dc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107dc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107dc7:	5b                   	pop    %ebx
80107dc8:	5e                   	pop    %esi
80107dc9:	5f                   	pop    %edi
80107dca:	5d                   	pop    %ebp
80107dcb:	c3                   	ret    
80107dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107dd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107dd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107dd9:	5b                   	pop    %ebx
80107dda:	5e                   	pop    %esi
80107ddb:	5f                   	pop    %edi
80107ddc:	5d                   	pop    %ebp
80107ddd:	c3                   	ret    
80107dde:	66 90                	xchg   %ax,%ax
    return 0;
80107de0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107de7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ded:	5b                   	pop    %ebx
80107dee:	5e                   	pop    %esi
80107def:	5f                   	pop    %edi
80107df0:	5d                   	pop    %ebp
80107df1:	c3                   	ret    
80107df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107df8:	83 ec 0c             	sub    $0xc,%esp
80107dfb:	68 d9 8c 10 80       	push   $0x80108cd9
80107e00:	e8 9b 88 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107e05:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e08:	83 c4 10             	add    $0x10,%esp
80107e0b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107e0e:	74 0c                	je     80107e1c <allocuvm+0x10c>
80107e10:	8b 55 10             	mov    0x10(%ebp),%edx
80107e13:	89 c1                	mov    %eax,%ecx
80107e15:	89 f8                	mov    %edi,%eax
80107e17:	e8 34 fa ff ff       	call   80107850 <deallocuvm.part.0>
      kfree(mem);
80107e1c:	83 ec 0c             	sub    $0xc,%esp
80107e1f:	53                   	push   %ebx
80107e20:	e8 9b a6 ff ff       	call   801024c0 <kfree>
      return 0;
80107e25:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107e2c:	83 c4 10             	add    $0x10,%esp
}
80107e2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e35:	5b                   	pop    %ebx
80107e36:	5e                   	pop    %esi
80107e37:	5f                   	pop    %edi
80107e38:	5d                   	pop    %ebp
80107e39:	c3                   	ret    
80107e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107e40 <deallocuvm>:
{
80107e40:	55                   	push   %ebp
80107e41:	89 e5                	mov    %esp,%ebp
80107e43:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e46:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107e49:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107e4c:	39 d1                	cmp    %edx,%ecx
80107e4e:	73 10                	jae    80107e60 <deallocuvm+0x20>
}
80107e50:	5d                   	pop    %ebp
80107e51:	e9 fa f9 ff ff       	jmp    80107850 <deallocuvm.part.0>
80107e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e5d:	8d 76 00             	lea    0x0(%esi),%esi
80107e60:	89 d0                	mov    %edx,%eax
80107e62:	5d                   	pop    %ebp
80107e63:	c3                   	ret    
80107e64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107e6f:	90                   	nop

80107e70 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107e70:	55                   	push   %ebp
80107e71:	89 e5                	mov    %esp,%ebp
80107e73:	57                   	push   %edi
80107e74:	56                   	push   %esi
80107e75:	53                   	push   %ebx
80107e76:	83 ec 0c             	sub    $0xc,%esp
80107e79:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107e7c:	85 f6                	test   %esi,%esi
80107e7e:	74 59                	je     80107ed9 <freevm+0x69>
  if(newsz >= oldsz)
80107e80:	31 c9                	xor    %ecx,%ecx
80107e82:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107e87:	89 f0                	mov    %esi,%eax
80107e89:	89 f3                	mov    %esi,%ebx
80107e8b:	e8 c0 f9 ff ff       	call   80107850 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107e90:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107e96:	eb 0f                	jmp    80107ea7 <freevm+0x37>
80107e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e9f:	90                   	nop
80107ea0:	83 c3 04             	add    $0x4,%ebx
80107ea3:	39 df                	cmp    %ebx,%edi
80107ea5:	74 23                	je     80107eca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107ea7:	8b 03                	mov    (%ebx),%eax
80107ea9:	a8 01                	test   $0x1,%al
80107eab:	74 f3                	je     80107ea0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107ead:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107eb2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107eb5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107eb8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107ebd:	50                   	push   %eax
80107ebe:	e8 fd a5 ff ff       	call   801024c0 <kfree>
80107ec3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107ec6:	39 df                	cmp    %ebx,%edi
80107ec8:	75 dd                	jne    80107ea7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107eca:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107ecd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ed0:	5b                   	pop    %ebx
80107ed1:	5e                   	pop    %esi
80107ed2:	5f                   	pop    %edi
80107ed3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107ed4:	e9 e7 a5 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107ed9:	83 ec 0c             	sub    $0xc,%esp
80107edc:	68 f5 8c 10 80       	push   $0x80108cf5
80107ee1:	e8 9a 84 ff ff       	call   80100380 <panic>
80107ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107eed:	8d 76 00             	lea    0x0(%esi),%esi

80107ef0 <setupkvm>:
{
80107ef0:	55                   	push   %ebp
80107ef1:	89 e5                	mov    %esp,%ebp
80107ef3:	56                   	push   %esi
80107ef4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107ef5:	e8 86 a7 ff ff       	call   80102680 <kalloc>
80107efa:	89 c6                	mov    %eax,%esi
80107efc:	85 c0                	test   %eax,%eax
80107efe:	74 42                	je     80107f42 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107f00:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107f03:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107f08:	68 00 10 00 00       	push   $0x1000
80107f0d:	6a 00                	push   $0x0
80107f0f:	50                   	push   %eax
80107f10:	e8 eb d1 ff ff       	call   80105100 <memset>
80107f15:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107f18:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107f1b:	83 ec 08             	sub    $0x8,%esp
80107f1e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107f21:	ff 73 0c             	push   0xc(%ebx)
80107f24:	8b 13                	mov    (%ebx),%edx
80107f26:	50                   	push   %eax
80107f27:	29 c1                	sub    %eax,%ecx
80107f29:	89 f0                	mov    %esi,%eax
80107f2b:	e8 d0 f9 ff ff       	call   80107900 <mappages>
80107f30:	83 c4 10             	add    $0x10,%esp
80107f33:	85 c0                	test   %eax,%eax
80107f35:	78 19                	js     80107f50 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107f37:	83 c3 10             	add    $0x10,%ebx
80107f3a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107f40:	75 d6                	jne    80107f18 <setupkvm+0x28>
}
80107f42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107f45:	89 f0                	mov    %esi,%eax
80107f47:	5b                   	pop    %ebx
80107f48:	5e                   	pop    %esi
80107f49:	5d                   	pop    %ebp
80107f4a:	c3                   	ret    
80107f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107f4f:	90                   	nop
      freevm(pgdir);
80107f50:	83 ec 0c             	sub    $0xc,%esp
80107f53:	56                   	push   %esi
      return 0;
80107f54:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107f56:	e8 15 ff ff ff       	call   80107e70 <freevm>
      return 0;
80107f5b:	83 c4 10             	add    $0x10,%esp
}
80107f5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107f61:	89 f0                	mov    %esi,%eax
80107f63:	5b                   	pop    %ebx
80107f64:	5e                   	pop    %esi
80107f65:	5d                   	pop    %ebp
80107f66:	c3                   	ret    
80107f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f6e:	66 90                	xchg   %ax,%ax

80107f70 <kvmalloc>:
{
80107f70:	55                   	push   %ebp
80107f71:	89 e5                	mov    %esp,%ebp
80107f73:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107f76:	e8 75 ff ff ff       	call   80107ef0 <setupkvm>
80107f7b:	a3 44 60 11 80       	mov    %eax,0x80116044
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107f80:	05 00 00 00 80       	add    $0x80000000,%eax
80107f85:	0f 22 d8             	mov    %eax,%cr3
}
80107f88:	c9                   	leave  
80107f89:	c3                   	ret    
80107f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107f90 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107f90:	55                   	push   %ebp
80107f91:	89 e5                	mov    %esp,%ebp
80107f93:	83 ec 08             	sub    $0x8,%esp
80107f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107f99:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107f9c:	89 c1                	mov    %eax,%ecx
80107f9e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107fa1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107fa4:	f6 c2 01             	test   $0x1,%dl
80107fa7:	75 17                	jne    80107fc0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107fa9:	83 ec 0c             	sub    $0xc,%esp
80107fac:	68 06 8d 10 80       	push   $0x80108d06
80107fb1:	e8 ca 83 ff ff       	call   80100380 <panic>
80107fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fbd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107fc0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107fc3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107fc9:	25 fc 0f 00 00       	and    $0xffc,%eax
80107fce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107fd5:	85 c0                	test   %eax,%eax
80107fd7:	74 d0                	je     80107fa9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107fd9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107fdc:	c9                   	leave  
80107fdd:	c3                   	ret    
80107fde:	66 90                	xchg   %ax,%ax

80107fe0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107fe0:	55                   	push   %ebp
80107fe1:	89 e5                	mov    %esp,%ebp
80107fe3:	57                   	push   %edi
80107fe4:	56                   	push   %esi
80107fe5:	53                   	push   %ebx
80107fe6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107fe9:	e8 02 ff ff ff       	call   80107ef0 <setupkvm>
80107fee:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ff1:	85 c0                	test   %eax,%eax
80107ff3:	0f 84 bd 00 00 00    	je     801080b6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107ff9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107ffc:	85 c9                	test   %ecx,%ecx
80107ffe:	0f 84 b2 00 00 00    	je     801080b6 <copyuvm+0xd6>
80108004:	31 f6                	xor    %esi,%esi
80108006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010800d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80108010:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80108013:	89 f0                	mov    %esi,%eax
80108015:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80108018:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010801b:	a8 01                	test   $0x1,%al
8010801d:	75 11                	jne    80108030 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010801f:	83 ec 0c             	sub    $0xc,%esp
80108022:	68 10 8d 10 80       	push   $0x80108d10
80108027:	e8 54 83 ff ff       	call   80100380 <panic>
8010802c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80108030:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108032:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108037:	c1 ea 0a             	shr    $0xa,%edx
8010803a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108040:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108047:	85 c0                	test   %eax,%eax
80108049:	74 d4                	je     8010801f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010804b:	8b 00                	mov    (%eax),%eax
8010804d:	a8 01                	test   $0x1,%al
8010804f:	0f 84 9f 00 00 00    	je     801080f4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80108055:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108057:	25 ff 0f 00 00       	and    $0xfff,%eax
8010805c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010805f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108065:	e8 16 a6 ff ff       	call   80102680 <kalloc>
8010806a:	89 c3                	mov    %eax,%ebx
8010806c:	85 c0                	test   %eax,%eax
8010806e:	74 64                	je     801080d4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108070:	83 ec 04             	sub    $0x4,%esp
80108073:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108079:	68 00 10 00 00       	push   $0x1000
8010807e:	57                   	push   %edi
8010807f:	50                   	push   %eax
80108080:	e8 1b d1 ff ff       	call   801051a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108085:	58                   	pop    %eax
80108086:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010808c:	5a                   	pop    %edx
8010808d:	ff 75 e4             	push   -0x1c(%ebp)
80108090:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108095:	89 f2                	mov    %esi,%edx
80108097:	50                   	push   %eax
80108098:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010809b:	e8 60 f8 ff ff       	call   80107900 <mappages>
801080a0:	83 c4 10             	add    $0x10,%esp
801080a3:	85 c0                	test   %eax,%eax
801080a5:	78 21                	js     801080c8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801080a7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801080ad:	39 75 0c             	cmp    %esi,0xc(%ebp)
801080b0:	0f 87 5a ff ff ff    	ja     80108010 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801080b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080bc:	5b                   	pop    %ebx
801080bd:	5e                   	pop    %esi
801080be:	5f                   	pop    %edi
801080bf:	5d                   	pop    %ebp
801080c0:	c3                   	ret    
801080c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801080c8:	83 ec 0c             	sub    $0xc,%esp
801080cb:	53                   	push   %ebx
801080cc:	e8 ef a3 ff ff       	call   801024c0 <kfree>
      goto bad;
801080d1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801080d4:	83 ec 0c             	sub    $0xc,%esp
801080d7:	ff 75 e0             	push   -0x20(%ebp)
801080da:	e8 91 fd ff ff       	call   80107e70 <freevm>
  return 0;
801080df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801080e6:	83 c4 10             	add    $0x10,%esp
}
801080e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080ef:	5b                   	pop    %ebx
801080f0:	5e                   	pop    %esi
801080f1:	5f                   	pop    %edi
801080f2:	5d                   	pop    %ebp
801080f3:	c3                   	ret    
      panic("copyuvm: page not present");
801080f4:	83 ec 0c             	sub    $0xc,%esp
801080f7:	68 2a 8d 10 80       	push   $0x80108d2a
801080fc:	e8 7f 82 ff ff       	call   80100380 <panic>
80108101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108108:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010810f:	90                   	nop

80108110 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108110:	55                   	push   %ebp
80108111:	89 e5                	mov    %esp,%ebp
80108113:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108116:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80108119:	89 c1                	mov    %eax,%ecx
8010811b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010811e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108121:	f6 c2 01             	test   $0x1,%dl
80108124:	0f 84 00 01 00 00    	je     8010822a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010812a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010812d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108133:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80108134:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80108139:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80108140:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108142:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108147:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010814a:	05 00 00 00 80       	add    $0x80000000,%eax
8010814f:	83 fa 05             	cmp    $0x5,%edx
80108152:	ba 00 00 00 00       	mov    $0x0,%edx
80108157:	0f 45 c2             	cmovne %edx,%eax
}
8010815a:	c3                   	ret    
8010815b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010815f:	90                   	nop

80108160 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108160:	55                   	push   %ebp
80108161:	89 e5                	mov    %esp,%ebp
80108163:	57                   	push   %edi
80108164:	56                   	push   %esi
80108165:	53                   	push   %ebx
80108166:	83 ec 0c             	sub    $0xc,%esp
80108169:	8b 75 14             	mov    0x14(%ebp),%esi
8010816c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010816f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108172:	85 f6                	test   %esi,%esi
80108174:	75 51                	jne    801081c7 <copyout+0x67>
80108176:	e9 a5 00 00 00       	jmp    80108220 <copyout+0xc0>
8010817b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010817f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80108180:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80108186:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010818c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80108192:	74 75                	je     80108209 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80108194:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108196:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80108199:	29 c3                	sub    %eax,%ebx
8010819b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801081a1:	39 f3                	cmp    %esi,%ebx
801081a3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801081a6:	29 f8                	sub    %edi,%eax
801081a8:	83 ec 04             	sub    $0x4,%esp
801081ab:	01 c1                	add    %eax,%ecx
801081ad:	53                   	push   %ebx
801081ae:	52                   	push   %edx
801081af:	51                   	push   %ecx
801081b0:	e8 eb cf ff ff       	call   801051a0 <memmove>
    len -= n;
    buf += n;
801081b5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801081b8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801081be:	83 c4 10             	add    $0x10,%esp
    buf += n;
801081c1:	01 da                	add    %ebx,%edx
  while(len > 0){
801081c3:	29 de                	sub    %ebx,%esi
801081c5:	74 59                	je     80108220 <copyout+0xc0>
  if(*pde & PTE_P){
801081c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801081ca:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801081cc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801081ce:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801081d1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801081d7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801081da:	f6 c1 01             	test   $0x1,%cl
801081dd:	0f 84 4e 00 00 00    	je     80108231 <copyout.cold>
  return &pgtab[PTX(va)];
801081e3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801081e5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801081eb:	c1 eb 0c             	shr    $0xc,%ebx
801081ee:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801081f4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801081fb:	89 d9                	mov    %ebx,%ecx
801081fd:	83 e1 05             	and    $0x5,%ecx
80108200:	83 f9 05             	cmp    $0x5,%ecx
80108203:	0f 84 77 ff ff ff    	je     80108180 <copyout+0x20>
  }
  return 0;
}
80108209:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010820c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108211:	5b                   	pop    %ebx
80108212:	5e                   	pop    %esi
80108213:	5f                   	pop    %edi
80108214:	5d                   	pop    %ebp
80108215:	c3                   	ret    
80108216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010821d:	8d 76 00             	lea    0x0(%esi),%esi
80108220:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108223:	31 c0                	xor    %eax,%eax
}
80108225:	5b                   	pop    %ebx
80108226:	5e                   	pop    %esi
80108227:	5f                   	pop    %edi
80108228:	5d                   	pop    %ebp
80108229:	c3                   	ret    

8010822a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010822a:	a1 00 00 00 00       	mov    0x0,%eax
8010822f:	0f 0b                	ud2    

80108231 <copyout.cold>:
80108231:	a1 00 00 00 00       	mov    0x0,%eax
80108236:	0f 0b                	ud2    
