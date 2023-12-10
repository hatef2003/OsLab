
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
80100028:	bc d0 6d 11 80       	mov    $0x80116dd0,%esp

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
8010004c:	68 20 81 10 80       	push   $0x80108120
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 f5 4c 00 00       	call   80104d50 <initlock>
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
80100092:	68 27 81 10 80       	push   $0x80108127
80100097:	50                   	push   %eax
80100098:	e8 83 4b 00 00       	call   80104c20 <initsleeplock>
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
801000e4:	e8 37 4e 00 00       	call   80104f20 <acquire>
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
80100162:	e8 59 4d 00 00       	call   80104ec0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 4a 00 00       	call   80104c60 <acquiresleep>
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
801001a1:	68 2e 81 10 80       	push   $0x8010812e
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
801001be:	e8 3d 4b 00 00       	call   80104d00 <holdingsleep>
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
801001dc:	68 3f 81 10 80       	push   $0x8010813f
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
801001ff:	e8 fc 4a 00 00       	call   80104d00 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 ac 4a 00 00       	call   80104cc0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 00 4d 00 00       	call   80104f20 <acquire>
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
8010026c:	e9 4f 4c 00 00       	jmp    80104ec0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 46 81 10 80       	push   $0x80108146
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
801002a0:	e8 7b 4c 00 00       	call   80104f20 <acquire>
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
801002cd:	e8 9e 46 00 00       	call   80104970 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 29 38 00 00       	call   80103b10 <myproc>
801002e7:	8b 48 30             	mov    0x30(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 c5 4b 00 00       	call   80104ec0 <release>
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
8010034c:	e8 6f 4b 00 00       	call   80104ec0 <release>
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
801003a2:	68 4d 81 10 80       	push   $0x8010814d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 cf 8b 10 80 	movl   $0x80108bcf,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 a3 49 00 00       	call   80104d70 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 61 81 10 80       	push   $0x80108161
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
8010041a:	e8 11 68 00 00       	call   80106c30 <uartputc>
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
80100505:	e8 26 67 00 00       	call   80106c30 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 1a 67 00 00       	call   80106c30 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 0e 67 00 00       	call   80106c30 <uartputc>
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
80100551:	e8 2a 4b 00 00       	call   80105080 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 75 4a 00 00       	call   80104fe0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 65 81 10 80       	push   $0x80108165
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
801005ab:	e8 70 49 00 00       	call   80104f20 <acquire>
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
801005e4:	e8 d7 48 00 00       	call   80104ec0 <release>
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
80100636:	0f b6 92 90 81 10 80 	movzbl -0x7fef7e70(%edx),%edx
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
801007e8:	e8 33 47 00 00       	call   80104f20 <acquire>
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
80100838:	bf 78 81 10 80       	mov    $0x80108178,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 60 46 00 00       	call   80104ec0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 7f 81 10 80       	push   $0x8010817f
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
80100893:	e8 88 46 00 00       	call   80104f20 <acquire>
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
801009d0:	e8 eb 44 00 00       	call   80104ec0 <release>
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
80100a0e:	e9 fd 40 00 00       	jmp    80104b10 <procdump>
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
80100a44:	e8 e7 3f 00 00       	call   80104a30 <wakeup>
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
80100a66:	68 88 81 10 80       	push   $0x80108188
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 db 42 00 00       	call   80104d50 <initlock>

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
80100abc:	e8 4f 30 00 00       	call   80103b10 <myproc>
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
80100b34:	e8 87 72 00 00       	call   80107dc0 <setupkvm>
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
80100ba3:	e8 38 70 00 00       	call   80107be0 <allocuvm>
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
80100bd9:	e8 12 6f 00 00       	call   80107af0 <loaduvm>
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
80100c1b:	e8 20 71 00 00       	call   80107d40 <freevm>
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
80100c62:	e8 79 6f 00 00       	call   80107be0 <allocuvm>
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
80100c83:	e8 d8 71 00 00       	call   80107e60 <clearpteu>
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
80100cd3:	e8 08 45 00 00       	call   801051e0 <strlen>
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
80100ce7:	e8 f4 44 00 00       	call   801051e0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 33 73 00 00       	call   80108030 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 2a 70 00 00       	call   80107d40 <freevm>
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
80100d63:	e8 c8 72 00 00       	call   80108030 <copyout>
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
80100da1:	e8 fa 43 00 00       	call   801051a0 <safestrcpy>
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
80100dcd:	e8 8e 6b 00 00       	call   80107960 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 66 6f 00 00       	call   80107d40 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 a1 81 10 80       	push   $0x801081a1
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
80100e16:	68 ad 81 10 80       	push   $0x801081ad
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 2b 3f 00 00       	call   80104d50 <initlock>
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
80100e41:	e8 da 40 00 00       	call   80104f20 <acquire>
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
80100e71:	e8 4a 40 00 00       	call   80104ec0 <release>
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
80100e8a:	e8 31 40 00 00       	call   80104ec0 <release>
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
80100eaf:	e8 6c 40 00 00       	call   80104f20 <acquire>
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
80100ecc:	e8 ef 3f 00 00       	call   80104ec0 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 b4 81 10 80       	push   $0x801081b4
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
80100f01:	e8 1a 40 00 00       	call   80104f20 <acquire>
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
80100f3c:	e8 7f 3f 00 00       	call   80104ec0 <release>

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
80100f6e:	e9 4d 3f 00 00       	jmp    80104ec0 <release>
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
80100fbc:	68 bc 81 10 80       	push   $0x801081bc
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
801010a2:	68 c6 81 10 80       	push   $0x801081c6
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
80101177:	68 cf 81 10 80       	push   $0x801081cf
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
801011b1:	68 d5 81 10 80       	push   $0x801081d5
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
80101227:	68 df 81 10 80       	push   $0x801081df
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
801012e4:	68 f2 81 10 80       	push   $0x801081f2
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
80101325:	e8 b6 3c 00 00       	call   80104fe0 <memset>
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
8010136a:	e8 b1 3b 00 00       	call   80104f20 <acquire>
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
801013d7:	e8 e4 3a 00 00       	call   80104ec0 <release>

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
80101405:	e8 b6 3a 00 00       	call   80104ec0 <release>
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
80101438:	68 08 82 10 80       	push   $0x80108208
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
80101515:	68 18 82 10 80       	push   $0x80108218
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
80101541:	e8 3a 3b 00 00       	call   80105080 <memmove>
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
8010156c:	68 2b 82 10 80       	push   $0x8010822b
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 d5 37 00 00       	call   80104d50 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 32 82 10 80       	push   $0x80108232
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 8c 36 00 00       	call   80104c20 <initsleeplock>
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
801015bc:	e8 bf 3a 00 00       	call   80105080 <memmove>
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
801015f3:	68 98 82 10 80       	push   $0x80108298
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
8010168e:	e8 4d 39 00 00       	call   80104fe0 <memset>
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
801016c3:	68 38 82 10 80       	push   $0x80108238
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
80101731:	e8 4a 39 00 00       	call   80105080 <memmove>
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
8010175f:	e8 bc 37 00 00       	call   80104f20 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 4c 37 00 00       	call   80104ec0 <release>
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
801017a2:	e8 b9 34 00 00       	call   80104c60 <acquiresleep>
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
80101818:	e8 63 38 00 00       	call   80105080 <memmove>
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
8010183d:	68 50 82 10 80       	push   $0x80108250
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 4a 82 10 80       	push   $0x8010824a
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
80101873:	e8 88 34 00 00       	call   80104d00 <holdingsleep>
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
8010188f:	e9 2c 34 00 00       	jmp    80104cc0 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 5f 82 10 80       	push   $0x8010825f
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
801018c0:	e8 9b 33 00 00       	call   80104c60 <acquiresleep>
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
801018da:	e8 e1 33 00 00       	call   80104cc0 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 35 36 00 00       	call   80104f20 <acquire>
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
80101900:	e9 bb 35 00 00       	jmp    80104ec0 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 0b 36 00 00       	call   80104f20 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 9c 35 00 00       	call   80104ec0 <release>
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
80101a23:	e8 d8 32 00 00       	call   80104d00 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 81 32 00 00       	call   80104cc0 <releasesleep>
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
80101a53:	68 5f 82 10 80       	push   $0x8010825f
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
80101b37:	e8 44 35 00 00       	call   80105080 <memmove>
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
80101c33:	e8 48 34 00 00       	call   80105080 <memmove>
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
80101cce:	e8 1d 34 00 00       	call   801050f0 <strncmp>
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
80101d2d:	e8 be 33 00 00       	call   801050f0 <strncmp>
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
80101d72:	68 79 82 10 80       	push   $0x80108279
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 67 82 10 80       	push   $0x80108267
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
80101daa:	e8 61 1d 00 00       	call   80103b10 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 74             	mov    0x74(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 61 31 00 00       	call   80104f20 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 f1 30 00 00       	call   80104ec0 <release>
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
80101e27:	e8 54 32 00 00       	call   80105080 <memmove>
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
80101e8c:	e8 6f 2e 00 00       	call   80104d00 <holdingsleep>
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
80101eae:	e8 0d 2e 00 00       	call   80104cc0 <releasesleep>
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
80101edb:	e8 a0 31 00 00       	call   80105080 <memmove>
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
80101f2b:	e8 d0 2d 00 00       	call   80104d00 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 71 2d 00 00       	call   80104cc0 <releasesleep>
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
80101f6d:	e8 8e 2d 00 00       	call   80104d00 <holdingsleep>
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
80101f90:	e8 6b 2d 00 00       	call   80104d00 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 14 2d 00 00       	call   80104cc0 <releasesleep>
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
80101fcf:	68 5f 82 10 80       	push   $0x8010825f
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
8010203d:	e8 fe 30 00 00       	call   80105140 <strncpy>
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
8010207b:	68 88 82 10 80       	push   $0x80108288
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 8a 89 10 80       	push   $0x8010898a
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
8010219b:	68 f4 82 10 80       	push   $0x801082f4
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 eb 82 10 80       	push   $0x801082eb
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 06 83 10 80       	push   $0x80108306
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 7b 2b 00 00       	call   80104d50 <initlock>
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
8010224e:	e8 cd 2c 00 00       	call   80104f20 <acquire>

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
801022ad:	e8 7e 27 00 00       	call   80104a30 <wakeup>

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
801022cb:	e8 f0 2b 00 00       	call   80104ec0 <release>

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
801022ee:	e8 0d 2a 00 00       	call   80104d00 <holdingsleep>
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
80102328:	e8 f3 2b 00 00       	call   80104f20 <acquire>

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
80102369:	e8 02 26 00 00       	call   80104970 <sleep>
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
80102386:	e9 35 2b 00 00       	jmp    80104ec0 <release>
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
801023aa:	68 35 83 10 80       	push   $0x80108335
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 20 83 10 80       	push   $0x80108320
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 0a 83 10 80       	push   $0x8010830a
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
8010241a:	68 54 83 10 80       	push   $0x80108354
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
801024d2:	81 fb d0 6d 11 80    	cmp    $0x80116dd0,%ebx
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
801024f2:	e8 e9 2a 00 00       	call   80104fe0 <memset>

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
80102528:	e8 f3 29 00 00       	call   80104f20 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 78 29 00 00       	jmp    80104ec0 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 86 83 10 80       	push   $0x80108386
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
8010261b:	68 8c 83 10 80       	push   $0x8010838c
80102620:	68 40 26 11 80       	push   $0x80112640
80102625:	e8 26 27 00 00       	call   80104d50 <initlock>
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
801026b3:	e8 68 28 00 00       	call   80104f20 <acquire>
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
801026e1:	e8 da 27 00 00       	call   80104ec0 <release>
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
8010272b:	0f b6 91 c0 84 10 80 	movzbl -0x7fef7b40(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 c0 83 10 80 	movzbl -0x7fef7c40(%ecx),%eax
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
8010274b:	8b 04 85 a0 83 10 80 	mov    -0x7fef7c60(,%eax,4),%eax
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
80102788:	0f b6 81 c0 84 10 80 	movzbl -0x7fef7b40(%ecx),%eax
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
80102af7:	e8 34 25 00 00       	call   80105030 <memcmp>
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
80102c24:	e8 57 24 00 00       	call   80105080 <memmove>
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
80102cca:	68 c0 85 10 80       	push   $0x801085c0
80102ccf:	68 a0 26 11 80       	push   $0x801126a0
80102cd4:	e8 77 20 00 00       	call   80104d50 <initlock>
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
80102d6b:	e8 b0 21 00 00       	call   80104f20 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 26 11 80       	push   $0x801126a0
80102d80:	68 a0 26 11 80       	push   $0x801126a0
80102d85:	e8 e6 1b 00 00       	call   80104970 <sleep>
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
80102dbc:	e8 ff 20 00 00       	call   80104ec0 <release>
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
80102dde:	e8 3d 21 00 00       	call   80104f20 <acquire>
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
80102e1c:	e8 9f 20 00 00       	call   80104ec0 <release>
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
80102e36:	e8 e5 20 00 00       	call   80104f20 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102e42:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 df 1b 00 00       	call   80104a30 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e58:	e8 63 20 00 00       	call   80104ec0 <release>
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
80102eb4:	e8 c7 21 00 00       	call   80105080 <memmove>
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
80102f08:	e8 23 1b 00 00       	call   80104a30 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f14:	e8 a7 1f 00 00       	call   80104ec0 <release>
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
80102f27:	68 c4 85 10 80       	push   $0x801085c4
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
80102f76:	e8 a5 1f 00 00       	call   80104f20 <acquire>
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
80102fb5:	e9 06 1f 00 00       	jmp    80104ec0 <release>
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
80102fe1:	68 d3 85 10 80       	push   $0x801085d3
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 e9 85 10 80       	push   $0x801085e9
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
80103007:	e8 d4 09 00 00       	call   801039e0 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 cd 09 00 00       	call   801039e0 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 04 86 10 80       	push   $0x80108604
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 29 38 00 00       	call   80106850 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 54 09 00 00       	call   80103980 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 d1 13 00 00       	call   80104410 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 05 49 00 00       	call   80107950 <switchkvm>
  seginit();
8010304b:	e8 70 48 00 00       	call   801078c0 <seginit>
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
80103077:	68 d0 6d 11 80       	push   $0x80116dd0
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 ba 4d 00 00       	call   80107e40 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 2b 48 00 00       	call   801078c0 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 a7 3a 00 00       	call   80106b50 <uartinit>
  pinit();         // process table
801030a9:	e8 62 08 00 00       	call   80103910 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 1d 37 00 00       	call   801067d0 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 53 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030bd:	e8 fe f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 8c b4 10 80       	push   $0x8010b48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 a7 1f 00 00       	call   80105080 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030e3:	00 00 00 
801030e6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030eb:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 62 08 00 00       	call   80103980 <mycpu>
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
80103182:	e8 f9 09 00 00       	call   80103b80 <userinit>
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
801031be:	68 18 86 10 80       	push   $0x80108618
801031c3:	56                   	push   %esi
801031c4:	e8 67 1e 00 00       	call   80105030 <memcmp>
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
80103276:	68 1d 86 10 80       	push   $0x8010861d
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 ac 1d 00 00       	call   80105030 <memcmp>
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
80103393:	68 22 86 10 80       	push   $0x80108622
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
801033c2:	68 18 86 10 80       	push   $0x80108618
801033c7:	53                   	push   %ebx
801033c8:	e8 63 1c 00 00       	call   80105030 <memcmp>
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
801033f8:	68 3c 86 10 80       	push   $0x8010863c
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
801034a3:	68 5b 86 10 80       	push   $0x8010865b
801034a8:	50                   	push   %eax
801034a9:	e8 a2 18 00 00       	call   80104d50 <initlock>
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
8010353f:	e8 dc 19 00 00       	call   80104f20 <acquire>
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
8010355f:	e8 cc 14 00 00       	call   80104a30 <wakeup>
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
80103584:	e9 37 19 00 00       	jmp    80104ec0 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 27 19 00 00       	call   80104ec0 <release>
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
801035c4:	e8 67 14 00 00       	call   80104a30 <wakeup>
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
801035dd:	e8 3e 19 00 00       	call   80104f20 <acquire>
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
80103628:	e8 e3 04 00 00       	call   80103b10 <myproc>
8010362d:	8b 48 30             	mov    0x30(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 f3 13 00 00       	call   80104a30 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 2a 13 00 00       	call   80104970 <sleep>
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
8010366c:	e8 4f 18 00 00       	call   80104ec0 <release>
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
801036ba:	e8 71 13 00 00       	call   80104a30 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 f9 17 00 00       	call   80104ec0 <release>
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
801036e6:	e8 35 18 00 00       	call   80104f20 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 0b 04 00 00       	call   80103b10 <myproc>
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
80103715:	e8 56 12 00 00       	call   80104970 <sleep>
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
80103776:	e8 b5 12 00 00       	call   80104a30 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 3d 17 00 00       	call   80104ec0 <release>
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
80103799:	e8 22 17 00 00       	call   80104ec0 <release>
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
801037c1:	e8 5a 17 00 00       	call   80104f20 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 17                	jmp    801037e2 <allocproc+0x32>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
801037d6:	81 fb 54 55 11 80    	cmp    $0x80115554,%ebx
801037dc:	0f 84 ae 00 00 00    	je     80103890 <allocproc+0xe0>
    if (p->state == UNUSED)
801037e2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037e5:	85 c0                	test   %eax,%eax
801037e7:	75 e7                	jne    801037d0 <allocproc+0x20>
found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->que_id = LCFS;
  p->priority = PRIORITY_DEF;
  p->priority_ratio = 1.0f;
801037e9:	d9 e8                	fld1   
  p->pid = nextpid++;
801037eb:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->creation_time_ratio = 1.0f;
  p->executed_cycle = 0.1f;
  p->executed_cycle_ratio = 1.0f;
  p->process_size_ratio = 1.0f;
  release(&ptable.lock);
801037f0:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037f3:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority_ratio = 1.0f;
801037fa:	d9 93 8c 00 00 00    	fsts   0x8c(%ebx)
  p->creation_time_ratio = 1.0f;
80103800:	d9 93 90 00 00 00    	fsts   0x90(%ebx)
  p->pid = nextpid++;
80103806:	8d 50 01             	lea    0x1(%eax),%edx
  p->executed_cycle_ratio = 1.0f;
80103809:	d9 93 98 00 00 00    	fsts   0x98(%ebx)
  p->pid = nextpid++;
8010380f:	89 43 10             	mov    %eax,0x10(%ebx)
  p->process_size_ratio = 1.0f;
80103812:	d9 9b 9c 00 00 00    	fstps  0x9c(%ebx)
  p->que_id = LCFS;
80103818:	c7 43 28 02 00 00 00 	movl   $0x2,0x28(%ebx)
  p->priority = PRIORITY_DEF;
8010381f:	c7 83 88 00 00 00 03 	movl   $0x3,0x88(%ebx)
80103826:	00 00 00 
  p->executed_cycle = 0.1f;
80103829:	c7 83 94 00 00 00 cd 	movl   $0x3dcccccd,0x94(%ebx)
80103830:	cc cc 3d 
  release(&ptable.lock);
80103833:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103838:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
8010383e:	e8 7d 16 00 00       	call   80104ec0 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
80103843:	e8 38 ee ff ff       	call   80102680 <kalloc>
80103848:	83 c4 10             	add    $0x10,%esp
8010384b:	89 43 08             	mov    %eax,0x8(%ebx)
8010384e:	85 c0                	test   %eax,%eax
80103850:	74 57                	je     801038a9 <allocproc+0xf9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103852:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
80103858:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010385b:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103860:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
80103863:	c7 40 14 b7 67 10 80 	movl   $0x801067b7,0x14(%eax)
  p->context = (struct context *)sp;
8010386a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010386d:	6a 14                	push   $0x14
8010386f:	6a 00                	push   $0x0
80103871:	50                   	push   %eax
80103872:	e8 69 17 00 00       	call   80104fe0 <memset>
  p->context->eip = (uint)forkret;
80103877:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010387a:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010387d:	c7 40 10 c0 38 10 80 	movl   $0x801038c0,0x10(%eax)
}
80103884:	89 d8                	mov    %ebx,%eax
80103886:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103889:	c9                   	leave  
8010388a:	c3                   	ret    
8010388b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010388f:	90                   	nop
  release(&ptable.lock);
80103890:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103893:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103895:	68 20 2d 11 80       	push   $0x80112d20
8010389a:	e8 21 16 00 00       	call   80104ec0 <release>
}
8010389f:	89 d8                	mov    %ebx,%eax
  return 0;
801038a1:	83 c4 10             	add    $0x10,%esp
}
801038a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a7:	c9                   	leave  
801038a8:	c3                   	ret    
    p->state = UNUSED;
801038a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038b0:	31 db                	xor    %ebx,%ebx
}
801038b2:	89 d8                	mov    %ebx,%eax
801038b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038b7:	c9                   	leave  
801038b8:	c3                   	ret    
801038b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038c0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038c6:	68 20 2d 11 80       	push   $0x80112d20
801038cb:	e8 f0 15 00 00       	call   80104ec0 <release>

  if (first)
801038d0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038d5:	83 c4 10             	add    $0x10,%esp
801038d8:	85 c0                	test   %eax,%eax
801038da:	75 04                	jne    801038e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038dc:	c9                   	leave  
801038dd:	c3                   	ret    
801038de:	66 90                	xchg   %ax,%ax
    first = 0;
801038e0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038e7:	00 00 00 
    iinit(ROOTDEV);
801038ea:	83 ec 0c             	sub    $0xc,%esp
801038ed:	6a 01                	push   $0x1
801038ef:	e8 6c dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801038f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038fb:	e8 c0 f3 ff ff       	call   80102cc0 <initlog>
}
80103900:	83 c4 10             	add    $0x10,%esp
80103903:	c9                   	leave  
80103904:	c3                   	ret    
80103905:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010390c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103910 <pinit>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103916:	68 60 86 10 80       	push   $0x80108660
8010391b:	68 20 2d 11 80       	push   $0x80112d20
80103920:	e8 2b 14 00 00       	call   80104d50 <initlock>
}
80103925:	83 c4 10             	add    $0x10,%esp
80103928:	c9                   	leave  
80103929:	c3                   	ret    
8010392a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103930 <calculate_rank>:
{
80103930:	55                   	push   %ebp
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80103931:	31 c9                	xor    %ecx,%ecx
{
80103933:	89 e5                	mov    %esp,%ebp
80103935:	83 ec 08             	sub    $0x8,%esp
80103938:	8b 45 08             	mov    0x8(%ebp),%eax
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
8010393b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010393e:	db 80 88 00 00 00    	fildl  0x88(%eax)
80103944:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
8010394a:	db 40 20             	fildl  0x20(%eax)
8010394d:	d8 88 90 00 00 00    	fmuls  0x90(%eax)
80103953:	8b 10                	mov    (%eax),%edx
80103955:	89 55 f8             	mov    %edx,-0x8(%ebp)
80103958:	de c1                	faddp  %st,%st(1)
8010395a:	d9 80 94 00 00 00    	flds   0x94(%eax)
80103960:	d8 88 98 00 00 00    	fmuls  0x98(%eax)
80103966:	de c1                	faddp  %st,%st(1)
80103968:	df 6d f8             	fildll -0x8(%ebp)
8010396b:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
}
80103971:	c9                   	leave  
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80103972:	de c1                	faddp  %st,%st(1)
}
80103974:	c3                   	ret    
80103975:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010397c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103980 <mycpu>:
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	56                   	push   %esi
80103984:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103985:	9c                   	pushf  
80103986:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103987:	f6 c4 02             	test   $0x2,%ah
8010398a:	75 46                	jne    801039d2 <mycpu+0x52>
  apicid = lapicid();
8010398c:	e8 5f ef ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i)
80103991:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103997:	85 f6                	test   %esi,%esi
80103999:	7e 2a                	jle    801039c5 <mycpu+0x45>
8010399b:	31 d2                	xor    %edx,%edx
8010399d:	eb 08                	jmp    801039a7 <mycpu+0x27>
8010399f:	90                   	nop
801039a0:	83 c2 01             	add    $0x1,%edx
801039a3:	39 f2                	cmp    %esi,%edx
801039a5:	74 1e                	je     801039c5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801039a7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039ad:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
801039b4:	39 c3                	cmp    %eax,%ebx
801039b6:	75 e8                	jne    801039a0 <mycpu+0x20>
}
801039b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039bb:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
801039c1:	5b                   	pop    %ebx
801039c2:	5e                   	pop    %esi
801039c3:	5d                   	pop    %ebp
801039c4:	c3                   	ret    
  panic("unknown apicid\n");
801039c5:	83 ec 0c             	sub    $0xc,%esp
801039c8:	68 67 86 10 80       	push   $0x80108667
801039cd:	e8 ae c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
801039d2:	83 ec 0c             	sub    $0xc,%esp
801039d5:	68 c0 87 10 80       	push   $0x801087c0
801039da:	e8 a1 c9 ff ff       	call   80100380 <panic>
801039df:	90                   	nop

801039e0 <cpuid>:
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
801039e6:	e8 95 ff ff ff       	call   80103980 <mycpu>
}
801039eb:	c9                   	leave  
  return mycpu() - cpus;
801039ec:	2d a0 27 11 80       	sub    $0x801127a0,%eax
801039f1:	c1 f8 04             	sar    $0x4,%eax
801039f4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039fa:	c3                   	ret    
801039fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039ff:	90                   	nop

80103a00 <aging>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	56                   	push   %esi
  time = ticks;
80103a04:	8b 35 60 55 11 80    	mov    0x80115560,%esi
{
80103a0a:	53                   	push   %ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a0b:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103a10:	eb 14                	jmp    80103a26 <aging+0x26>
80103a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a18:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103a1e:	81 fb 54 55 11 80    	cmp    $0x80115554,%ebx
80103a24:	74 49                	je     80103a6f <aging+0x6f>
    if (p->state == RUNNABLE && p->que_id != RR)
80103a26:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a2a:	75 ec                	jne    80103a18 <aging+0x18>
80103a2c:	83 7b 28 01          	cmpl   $0x1,0x28(%ebx)
80103a30:	74 e6                	je     80103a18 <aging+0x18>
      if (time - p->preemption_time > AGING_THRS)
80103a32:	89 f0                	mov    %esi,%eax
80103a34:	2b 43 24             	sub    0x24(%ebx),%eax
80103a37:	3d 40 1f 00 00       	cmp    $0x1f40,%eax
80103a3c:	7e da                	jle    80103a18 <aging+0x18>
        release(&ptable.lock);
80103a3e:	83 ec 0c             	sub    $0xc,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a41:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
        release(&ptable.lock);
80103a47:	68 20 2d 11 80       	push   $0x80112d20
80103a4c:	e8 6f 14 00 00       	call   80104ec0 <release>
        acquire(&ptable.lock);
80103a51:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->que_id = RR;
80103a58:	c7 43 88 01 00 00 00 	movl   $0x1,-0x78(%ebx)
        acquire(&ptable.lock);
80103a5f:	e8 bc 14 00 00       	call   80104f20 <acquire>
80103a64:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a67:	81 fb 54 55 11 80    	cmp    $0x80115554,%ebx
80103a6d:	75 b7                	jne    80103a26 <aging+0x26>
}
80103a6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a72:	5b                   	pop    %ebx
80103a73:	5e                   	pop    %esi
80103a74:	5d                   	pop    %ebp
80103a75:	c3                   	ret    
80103a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a7d:	8d 76 00             	lea    0x0(%esi),%esi

80103a80 <reset_bjf_attributes>:
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 24             	sub    $0x24,%esp
80103a86:	d9 45 08             	flds   0x8(%ebp)
  acquire(&ptable.lock);
80103a89:	68 20 2d 11 80       	push   $0x80112d20
{
80103a8e:	d9 5d e8             	fstps  -0x18(%ebp)
80103a91:	d9 45 0c             	flds   0xc(%ebp)
80103a94:	d9 5d ec             	fstps  -0x14(%ebp)
80103a97:	d9 45 10             	flds   0x10(%ebp)
80103a9a:	d9 5d f0             	fstps  -0x10(%ebp)
80103a9d:	d9 45 14             	flds   0x14(%ebp)
80103aa0:	d9 5d f4             	fstps  -0xc(%ebp)
  acquire(&ptable.lock);
80103aa3:	e8 78 14 00 00       	call   80104f20 <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103aa8:	d9 45 e8             	flds   -0x18(%ebp)
80103aab:	d9 45 ec             	flds   -0x14(%ebp)
  acquire(&ptable.lock);
80103aae:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ab1:	d9 45 f0             	flds   -0x10(%ebp)
80103ab4:	d9 45 f4             	flds   -0xc(%ebp)
80103ab7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != UNUSED)
80103ac0:	8b 50 0c             	mov    0xc(%eax),%edx
80103ac3:	85 d2                	test   %edx,%edx
80103ac5:	74 28                	je     80103aef <reset_bjf_attributes+0x6f>
80103ac7:	d9 cb                	fxch   %st(3)
      p->priority_ratio = priority_ratio;
80103ac9:	d9 90 8c 00 00 00    	fsts   0x8c(%eax)
80103acf:	d9 ca                	fxch   %st(2)
      p->creation_time_ratio = creation_time_ratio;
80103ad1:	d9 90 90 00 00 00    	fsts   0x90(%eax)
80103ad7:	d9 c9                	fxch   %st(1)
      p->executed_cycle_ratio = exec_cycle_ratio;
80103ad9:	d9 90 98 00 00 00    	fsts   0x98(%eax)
80103adf:	d9 cb                	fxch   %st(3)
      p->process_size_ratio = size_ratio;
80103ae1:	d9 90 9c 00 00 00    	fsts   0x9c(%eax)
80103ae7:	d9 c9                	fxch   %st(1)
80103ae9:	d9 ca                	fxch   %st(2)
80103aeb:	d9 cb                	fxch   %st(3)
80103aed:	d9 c9                	fxch   %st(1)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103aef:	05 a0 00 00 00       	add    $0xa0,%eax
80103af4:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80103af9:	75 c5                	jne    80103ac0 <reset_bjf_attributes+0x40>
80103afb:	dd d8                	fstp   %st(0)
80103afd:	dd d8                	fstp   %st(0)
80103aff:	dd d8                	fstp   %st(0)
80103b01:	dd d8                	fstp   %st(0)
  release(&ptable.lock);
80103b03:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103b0a:	c9                   	leave  
  release(&ptable.lock);
80103b0b:	e9 b0 13 00 00       	jmp    80104ec0 <release>

80103b10 <myproc>:
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	53                   	push   %ebx
80103b14:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b17:	e8 b4 12 00 00       	call   80104dd0 <pushcli>
  c = mycpu();
80103b1c:	e8 5f fe ff ff       	call   80103980 <mycpu>
  p = c->proc;
80103b21:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b27:	e8 f4 12 00 00       	call   80104e20 <popcli>
}
80103b2c:	89 d8                	mov    %ebx,%eax
80103b2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b31:	c9                   	leave  
80103b32:	c3                   	ret    
80103b33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b40 <how_many_digit>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	56                   	push   %esi
80103b44:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103b47:	53                   	push   %ebx
80103b48:	bb 01 00 00 00       	mov    $0x1,%ebx
  if(num==0)
80103b4d:	85 c9                	test   %ecx,%ecx
80103b4f:	74 24                	je     80103b75 <how_many_digit+0x35>
  int count = 0 ; 
80103b51:	31 db                	xor    %ebx,%ebx
    num/=10;
80103b53:	be 67 66 66 66       	mov    $0x66666667,%esi
80103b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5f:	90                   	nop
80103b60:	89 c8                	mov    %ecx,%eax
    count++ ;
80103b62:	83 c3 01             	add    $0x1,%ebx
    num/=10;
80103b65:	f7 ee                	imul   %esi
80103b67:	89 c8                	mov    %ecx,%eax
80103b69:	c1 f8 1f             	sar    $0x1f,%eax
80103b6c:	c1 fa 02             	sar    $0x2,%edx
  while (num!=0)
80103b6f:	89 d1                	mov    %edx,%ecx
80103b71:	29 c1                	sub    %eax,%ecx
80103b73:	75 eb                	jne    80103b60 <how_many_digit+0x20>
}
80103b75:	89 d8                	mov    %ebx,%eax
80103b77:	5b                   	pop    %ebx
80103b78:	5e                   	pop    %esi
80103b79:	5d                   	pop    %ebp
80103b7a:	c3                   	ret    
80103b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b7f:	90                   	nop

80103b80 <userinit>:
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	53                   	push   %ebx
80103b84:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b87:	e8 24 fc ff ff       	call   801037b0 <allocproc>
80103b8c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b8e:	a3 54 55 11 80       	mov    %eax,0x80115554
  if ((p->pgdir = setupkvm()) == 0)
80103b93:	e8 28 42 00 00       	call   80107dc0 <setupkvm>
80103b98:	89 43 04             	mov    %eax,0x4(%ebx)
80103b9b:	85 c0                	test   %eax,%eax
80103b9d:	0f 84 c4 00 00 00    	je     80103c67 <userinit+0xe7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ba3:	83 ec 04             	sub    $0x4,%esp
80103ba6:	68 2c 00 00 00       	push   $0x2c
80103bab:	68 60 b4 10 80       	push   $0x8010b460
80103bb0:	50                   	push   %eax
80103bb1:	e8 ba 3e 00 00       	call   80107a70 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103bb6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103bb9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bbf:	6a 4c                	push   $0x4c
80103bc1:	6a 00                	push   $0x0
80103bc3:	ff 73 18             	push   0x18(%ebx)
80103bc6:	e8 15 14 00 00       	call   80104fe0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bcb:	8b 43 18             	mov    0x18(%ebx),%eax
80103bce:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bd3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bd6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bdb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bdf:	8b 43 18             	mov    0x18(%ebx),%eax
80103be2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103be6:	8b 43 18             	mov    0x18(%ebx),%eax
80103be9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bed:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bf1:	8b 43 18             	mov    0x18(%ebx),%eax
80103bf4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bf8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bfc:	8b 43 18             	mov    0x18(%ebx),%eax
80103bff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c06:	8b 43 18             	mov    0x18(%ebx),%eax
80103c09:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103c10:	8b 43 18             	mov    0x18(%ebx),%eax
80103c13:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c1a:	8d 43 78             	lea    0x78(%ebx),%eax
80103c1d:	6a 10                	push   $0x10
80103c1f:	68 90 86 10 80       	push   $0x80108690
80103c24:	50                   	push   %eax
80103c25:	e8 76 15 00 00       	call   801051a0 <safestrcpy>
  p->cwd = namei("/");
80103c2a:	c7 04 24 99 86 10 80 	movl   $0x80108699,(%esp)
80103c31:	e8 6a e4 ff ff       	call   801020a0 <namei>
80103c36:	89 43 74             	mov    %eax,0x74(%ebx)
  acquire(&ptable.lock);
80103c39:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c40:	e8 db 12 00 00       	call   80104f20 <acquire>
  p->state = RUNNABLE;
80103c45:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->que_id = RR;
80103c4c:	c7 43 28 01 00 00 00 	movl   $0x1,0x28(%ebx)
  release(&ptable.lock);
80103c53:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c5a:	e8 61 12 00 00       	call   80104ec0 <release>
}
80103c5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c62:	83 c4 10             	add    $0x10,%esp
80103c65:	c9                   	leave  
80103c66:	c3                   	ret    
    panic("userinit: out of memory?");
80103c67:	83 ec 0c             	sub    $0xc,%esp
80103c6a:	68 77 86 10 80       	push   $0x80108677
80103c6f:	e8 0c c7 ff ff       	call   80100380 <panic>
80103c74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c7f:	90                   	nop

80103c80 <print_name>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
  memset(buf, ' ', 14);
80103c85:	8d 7d d9             	lea    -0x27(%ebp),%edi
{
80103c88:	53                   	push   %ebx
  for (int i = 0; i < strlen(name); i++)
80103c89:	31 db                	xor    %ebx,%ebx
{
80103c8b:	83 ec 20             	sub    $0x20,%esp
80103c8e:	8b 75 08             	mov    0x8(%ebp),%esi
  memset(buf, ' ', 14);
80103c91:	6a 0e                	push   $0xe
80103c93:	6a 20                	push   $0x20
80103c95:	57                   	push   %edi
80103c96:	e8 45 13 00 00       	call   80104fe0 <memset>
  buf[14] = 0;
80103c9b:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for (int i = 0; i < strlen(name); i++)
80103c9f:	83 c4 10             	add    $0x10,%esp
80103ca2:	eb 0e                	jmp    80103cb2 <print_name+0x32>
80103ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i] = name[i];
80103ca8:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80103cac:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for (int i = 0; i < strlen(name); i++)
80103caf:	83 c3 01             	add    $0x1,%ebx
80103cb2:	83 ec 0c             	sub    $0xc,%esp
80103cb5:	56                   	push   %esi
80103cb6:	e8 25 15 00 00       	call   801051e0 <strlen>
80103cbb:	83 c4 10             	add    $0x10,%esp
80103cbe:	39 d8                	cmp    %ebx,%eax
80103cc0:	7f e6                	jg     80103ca8 <print_name+0x28>
  cprintf("%s", buf);
80103cc2:	83 ec 08             	sub    $0x8,%esp
80103cc5:	57                   	push   %edi
80103cc6:	68 93 87 10 80       	push   $0x80108793
80103ccb:	e8 d0 c9 ff ff       	call   801006a0 <cprintf>
}
80103cd0:	83 c4 10             	add    $0x10,%esp
80103cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cd6:	5b                   	pop    %ebx
80103cd7:	5e                   	pop    %esi
80103cd8:	5f                   	pop    %edi
80103cd9:	5d                   	pop    %ebp
80103cda:	c3                   	ret    
80103cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cdf:	90                   	nop

80103ce0 <find_proc>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	56                   	push   %esi
80103ce4:	53                   	push   %ebx
80103ce5:	8b 75 08             	mov    0x8(%ebp),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ce8:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  acquire(&ptable.lock);
80103ced:	83 ec 0c             	sub    $0xc,%esp
80103cf0:	68 20 2d 11 80       	push   $0x80112d20
80103cf5:	e8 26 12 00 00       	call   80104f20 <acquire>
80103cfa:	83 c4 10             	add    $0x10,%esp
80103cfd:	eb 0f                	jmp    80103d0e <find_proc+0x2e>
80103cff:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d00:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103d06:	81 fb 54 55 11 80    	cmp    $0x80115554,%ebx
80103d0c:	74 05                	je     80103d13 <find_proc+0x33>
    if (p->pid == pid)
80103d0e:	39 73 10             	cmp    %esi,0x10(%ebx)
80103d11:	75 ed                	jne    80103d00 <find_proc+0x20>
  release(&ptable.lock);
80103d13:	83 ec 0c             	sub    $0xc,%esp
80103d16:	68 20 2d 11 80       	push   $0x80112d20
80103d1b:	e8 a0 11 00 00       	call   80104ec0 <release>
}
80103d20:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d23:	89 d8                	mov    %ebx,%eax
80103d25:	5b                   	pop    %ebx
80103d26:	5e                   	pop    %esi
80103d27:	5d                   	pop    %ebp
80103d28:	c3                   	ret    
80103d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d30 <print_state>:
{
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	8b 45 08             	mov    0x8(%ebp),%eax
  switch (state)
80103d36:	83 f8 05             	cmp    $0x5,%eax
80103d39:	77 6a                	ja     80103da5 <print_state+0x75>
80103d3b:	ff 24 85 3c 88 10 80 	jmp    *-0x7fef77c4(,%eax,4)
80103d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("RUNNING   ");
80103d48:	c7 45 08 c7 86 10 80 	movl   $0x801086c7,0x8(%ebp)
}
80103d4f:	5d                   	pop    %ebp
    cprintf("RUNNING   ");
80103d50:	e9 4b c9 ff ff       	jmp    801006a0 <cprintf>
80103d55:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("ZOMBIE    ");
80103d58:	c7 45 08 d2 86 10 80 	movl   $0x801086d2,0x8(%ebp)
}
80103d5f:	5d                   	pop    %ebp
    cprintf("ZOMBIE    ");
80103d60:	e9 3b c9 ff ff       	jmp    801006a0 <cprintf>
80103d65:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("UNUSED    ");
80103d68:	c7 45 08 9b 86 10 80 	movl   $0x8010869b,0x8(%ebp)
}
80103d6f:	5d                   	pop    %ebp
    cprintf("UNUSED    ");
80103d70:	e9 2b c9 ff ff       	jmp    801006a0 <cprintf>
80103d75:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("EMBRYO    ");
80103d78:	c7 45 08 a6 86 10 80 	movl   $0x801086a6,0x8(%ebp)
}
80103d7f:	5d                   	pop    %ebp
    cprintf("EMBRYO    ");
80103d80:	e9 1b c9 ff ff       	jmp    801006a0 <cprintf>
80103d85:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("SLEEPING  ");
80103d88:	c7 45 08 b1 86 10 80 	movl   $0x801086b1,0x8(%ebp)
}
80103d8f:	5d                   	pop    %ebp
    cprintf("SLEEPING  ");
80103d90:	e9 0b c9 ff ff       	jmp    801006a0 <cprintf>
80103d95:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("RUNNABLE  ");
80103d98:	c7 45 08 bc 86 10 80 	movl   $0x801086bc,0x8(%ebp)
}
80103d9f:	5d                   	pop    %ebp
    cprintf("RUNNABLE  ");
80103da0:	e9 fb c8 ff ff       	jmp    801006a0 <cprintf>
    cprintf("damn ways to die");
80103da5:	c7 45 08 dd 86 10 80 	movl   $0x801086dd,0x8(%ebp)
}
80103dac:	5d                   	pop    %ebp
    cprintf("damn ways to die");
80103dad:	e9 ee c8 ff ff       	jmp    801006a0 <cprintf>
80103db2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103dc0 <print_space>:
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	56                   	push   %esi
80103dc4:	8b 75 08             	mov    0x8(%ebp),%esi
80103dc7:	53                   	push   %ebx
  for (int i =0 ; i < num ; i++)
80103dc8:	85 f6                	test   %esi,%esi
80103dca:	7e 1b                	jle    80103de7 <print_space+0x27>
80103dcc:	31 db                	xor    %ebx,%ebx
80103dce:	66 90                	xchg   %ax,%ax
    cprintf(" ");
80103dd0:	83 ec 0c             	sub    $0xc,%esp
  for (int i =0 ; i < num ; i++)
80103dd3:	83 c3 01             	add    $0x1,%ebx
    cprintf(" ");
80103dd6:	68 08 87 10 80       	push   $0x80108708
80103ddb:	e8 c0 c8 ff ff       	call   801006a0 <cprintf>
  for (int i =0 ; i < num ; i++)
80103de0:	83 c4 10             	add    $0x10,%esp
80103de3:	39 de                	cmp    %ebx,%esi
80103de5:	75 e9                	jne    80103dd0 <print_space+0x10>
}
80103de7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103dea:	5b                   	pop    %ebx
80103deb:	5e                   	pop    %esi
80103dec:	5d                   	pop    %ebp
80103ded:	c3                   	ret    
80103dee:	66 90                	xchg   %ax,%ax

80103df0 <print_bitches>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	57                   	push   %edi
80103df4:	56                   	push   %esi
80103df5:	53                   	push   %ebx
  cprintf("process_name PID State   Queue Cycle Arrival Priority R_prty R_Arvl R_exec Rank\n");
80103df6:	bb 50 00 00 00       	mov    $0x50,%ebx
{
80103dfb:	83 ec 28             	sub    $0x28,%esp
  acquire(&ptable.lock);
80103dfe:	68 20 2d 11 80       	push   $0x80112d20
80103e03:	e8 18 11 00 00       	call   80104f20 <acquire>
  cprintf("process_name PID State   Queue Cycle Arrival Priority R_prty R_Arvl R_exec Rank\n");
80103e08:	c7 04 24 e8 87 10 80 	movl   $0x801087e8,(%esp)
80103e0f:	e8 8c c8 ff ff       	call   801006a0 <cprintf>
80103e14:	83 c4 10             	add    $0x10,%esp
80103e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e1e:	66 90                	xchg   %ax,%ax
    cprintf("-");
80103e20:	83 ec 0c             	sub    $0xc,%esp
80103e23:	68 ee 86 10 80       	push   $0x801086ee
80103e28:	e8 73 c8 ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < 80; i++)
80103e2d:	83 c4 10             	add    $0x10,%esp
80103e30:	83 eb 01             	sub    $0x1,%ebx
80103e33:	75 eb                	jne    80103e20 <print_bitches+0x30>
  cprintf("\n");
80103e35:	83 ec 0c             	sub    $0xc,%esp
80103e38:	bb cc 2d 11 80       	mov    $0x80112dcc,%ebx
80103e3d:	68 cf 8b 10 80       	push   $0x80108bcf
80103e42:	e8 59 c8 ff ff       	call   801006a0 <cprintf>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e47:	83 c4 10             	add    $0x10,%esp
80103e4a:	eb 16                	jmp    80103e62 <print_bitches+0x72>
80103e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e50:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103e56:	81 fb cc 55 11 80    	cmp    $0x801155cc,%ebx
80103e5c:	0f 84 dc 01 00 00    	je     8010403e <print_bitches+0x24e>
    if (p->state == UNUSED)
80103e62:	8b 43 94             	mov    -0x6c(%ebx),%eax
80103e65:	85 c0                	test   %eax,%eax
80103e67:	74 e7                	je     80103e50 <print_bitches+0x60>
    print_name(p->name);
80103e69:	83 ec 0c             	sub    $0xc,%esp
80103e6c:	53                   	push   %ebx
80103e6d:	e8 0e fe ff ff       	call   80103c80 <print_name>
    cprintf("%d  ", p->pid);
80103e72:	59                   	pop    %ecx
80103e73:	5e                   	pop    %esi
80103e74:	ff 73 98             	push   -0x68(%ebx)
80103e77:	68 f0 86 10 80       	push   $0x801086f0
80103e7c:	e8 1f c8 ff ff       	call   801006a0 <cprintf>
    print_state((*p).state);
80103e81:	5f                   	pop    %edi
80103e82:	ff 73 94             	push   -0x6c(%ebx)
80103e85:	e8 a6 fe ff ff       	call   80103d30 <print_state>
    cprintf("%d     ", p->que_id);
80103e8a:	58                   	pop    %eax
80103e8b:	5a                   	pop    %edx
80103e8c:	ff 73 b0             	push   -0x50(%ebx)
80103e8f:	68 f5 86 10 80       	push   $0x801086f5
80103e94:	e8 07 c8 ff ff       	call   801006a0 <cprintf>
    cprintf("%d     ", (int)p->executed_cycle);
80103e99:	d9 43 1c             	flds   0x1c(%ebx)
80103e9c:	59                   	pop    %ecx
80103e9d:	d9 7d e6             	fnstcw -0x1a(%ebp)
80103ea0:	5e                   	pop    %esi
80103ea1:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80103ea5:	80 cc 0c             	or     $0xc,%ah
80103ea8:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80103eac:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103eaf:	db 5d d8             	fistpl -0x28(%ebp)
80103eb2:	d9 6d e6             	fldcw  -0x1a(%ebp)
80103eb5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103eb8:	50                   	push   %eax
80103eb9:	68 f5 86 10 80       	push   $0x801086f5
80103ebe:	e8 dd c7 ff ff       	call   801006a0 <cprintf>
    cprintf("%d", p->creation_time);
80103ec3:	5f                   	pop    %edi
80103ec4:	58                   	pop    %eax
80103ec5:	ff 73 a8             	push   -0x58(%ebx)
80103ec8:	68 fd 86 10 80       	push   $0x801086fd
80103ecd:	e8 ce c7 ff ff       	call   801006a0 <cprintf>
    print_space(10-how_many_digit(p->creation_time));
80103ed2:	8b 73 a8             	mov    -0x58(%ebx),%esi
  if(num==0)
80103ed5:	83 c4 10             	add    $0x10,%esp
80103ed8:	85 f6                	test   %esi,%esi
80103eda:	0f 84 80 01 00 00    	je     80104060 <print_bitches+0x270>
  int count = 0 ; 
80103ee0:	31 c9                	xor    %ecx,%ecx
80103ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    num/=10;
80103ee8:	b8 67 66 66 66       	mov    $0x66666667,%eax
    count++ ;
80103eed:	83 c1 01             	add    $0x1,%ecx
    num/=10;
80103ef0:	f7 ee                	imul   %esi
80103ef2:	89 f0                	mov    %esi,%eax
80103ef4:	c1 f8 1f             	sar    $0x1f,%eax
80103ef7:	c1 fa 02             	sar    $0x2,%edx
  while (num!=0)
80103efa:	29 c2                	sub    %eax,%edx
80103efc:	89 d6                	mov    %edx,%esi
80103efe:	75 e8                	jne    80103ee8 <print_bitches+0xf8>
    print_space(10-how_many_digit(p->creation_time));
80103f00:	be 0a 00 00 00       	mov    $0xa,%esi
80103f05:	29 ce                	sub    %ecx,%esi
  for (int i =0 ; i < num ; i++)
80103f07:	85 f6                	test   %esi,%esi
80103f09:	7e 1c                	jle    80103f27 <print_bitches+0x137>
    print_space(10-how_many_digit(p->creation_time));
80103f0b:	31 ff                	xor    %edi,%edi
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf(" ");
80103f10:	83 ec 0c             	sub    $0xc,%esp
  for (int i =0 ; i < num ; i++)
80103f13:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80103f16:	68 08 87 10 80       	push   $0x80108708
80103f1b:	e8 80 c7 ff ff       	call   801006a0 <cprintf>
  for (int i =0 ; i < num ; i++)
80103f20:	83 c4 10             	add    $0x10,%esp
80103f23:	39 f7                	cmp    %esi,%edi
80103f25:	7c e9                	jl     80103f10 <print_bitches+0x120>
    cprintf("%d       ", p->priority);
80103f27:	83 ec 08             	sub    $0x8,%esp
80103f2a:	ff 73 10             	push   0x10(%ebx)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f2d:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
    cprintf("%d       ", p->priority);
80103f33:	68 00 87 10 80       	push   $0x80108700
80103f38:	e8 63 c7 ff ff       	call   801006a0 <cprintf>
    cprintf("%d     ", (int)p->priority_ratio);
80103f3d:	d9 83 74 ff ff ff    	flds   -0x8c(%ebx)
80103f43:	58                   	pop    %eax
80103f44:	d9 7d e6             	fnstcw -0x1a(%ebp)
80103f47:	5a                   	pop    %edx
80103f48:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80103f4c:	80 cc 0c             	or     $0xc,%ah
80103f4f:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80103f53:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103f56:	db 5d d8             	fistpl -0x28(%ebp)
80103f59:	d9 6d e6             	fldcw  -0x1a(%ebp)
80103f5c:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103f5f:	50                   	push   %eax
80103f60:	68 f5 86 10 80       	push   $0x801086f5
80103f65:	e8 36 c7 ff ff       	call   801006a0 <cprintf>
    cprintf("%d      ", (int)p->creation_time_ratio);
80103f6a:	d9 83 78 ff ff ff    	flds   -0x88(%ebx)
80103f70:	59                   	pop    %ecx
80103f71:	d9 7d e6             	fnstcw -0x1a(%ebp)
80103f74:	5e                   	pop    %esi
80103f75:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80103f79:	80 cc 0c             	or     $0xc,%ah
80103f7c:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80103f80:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103f83:	db 5d d8             	fistpl -0x28(%ebp)
80103f86:	d9 6d e6             	fldcw  -0x1a(%ebp)
80103f89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103f8c:	50                   	push   %eax
80103f8d:	68 0a 87 10 80       	push   $0x8010870a
80103f92:	e8 09 c7 ff ff       	call   801006a0 <cprintf>
    cprintf("%d   ",  (int)p->executed_cycle_ratio);
80103f97:	d9 43 80             	flds   -0x80(%ebx)
80103f9a:	5f                   	pop    %edi
80103f9b:	d9 7d e6             	fnstcw -0x1a(%ebp)
80103f9e:	58                   	pop    %eax
80103f9f:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80103fa3:	80 cc 0c             	or     $0xc,%ah
80103fa6:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80103faa:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103fad:	db 5d d8             	fistpl -0x28(%ebp)
80103fb0:	d9 6d e6             	fldcw  -0x1a(%ebp)
80103fb3:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103fb6:	50                   	push   %eax
80103fb7:	68 13 87 10 80       	push   $0x80108713
80103fbc:	e8 df c6 ff ff       	call   801006a0 <cprintf>
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80103fc1:	db 83 70 ff ff ff    	fildl  -0x90(%ebx)
    cprintf("%d",(int )rank);
80103fc7:	58                   	pop    %eax
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80103fc8:	d8 8b 74 ff ff ff    	fmuls  -0x8c(%ebx)
80103fce:	db 83 08 ff ff ff    	fildl  -0xf8(%ebx)
80103fd4:	d8 8b 78 ff ff ff    	fmuls  -0x88(%ebx)
80103fda:	8b 83 e8 fe ff ff    	mov    -0x118(%ebx),%eax
    cprintf("%d",(int )rank);
80103fe0:	5a                   	pop    %edx
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80103fe1:	31 d2                	xor    %edx,%edx
80103fe3:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103fe6:	89 55 dc             	mov    %edx,-0x24(%ebp)
80103fe9:	de c1                	faddp  %st,%st(1)
80103feb:	d9 83 7c ff ff ff    	flds   -0x84(%ebx)
80103ff1:	d8 4b 80             	fmuls  -0x80(%ebx)
80103ff4:	de c1                	faddp  %st,%st(1)
80103ff6:	df 6d d8             	fildll -0x28(%ebp)
80103ff9:	d8 4b 84             	fmuls  -0x7c(%ebx)
    cprintf("%d",(int )rank);
80103ffc:	d9 7d e6             	fnstcw -0x1a(%ebp)
80103fff:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80104003:	de c1                	faddp  %st,%st(1)
    cprintf("%d",(int )rank);
80104005:	80 cc 0c             	or     $0xc,%ah
80104008:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
8010400c:	d9 6d e4             	fldcw  -0x1c(%ebp)
8010400f:	db 5d d8             	fistpl -0x28(%ebp)
80104012:	d9 6d e6             	fldcw  -0x1a(%ebp)
80104015:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104018:	50                   	push   %eax
80104019:	68 fd 86 10 80       	push   $0x801086fd
8010401e:	e8 7d c6 ff ff       	call   801006a0 <cprintf>
    cprintf("\n");
80104023:	c7 04 24 cf 8b 10 80 	movl   $0x80108bcf,(%esp)
8010402a:	e8 71 c6 ff ff       	call   801006a0 <cprintf>
8010402f:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104032:	81 fb cc 55 11 80    	cmp    $0x801155cc,%ebx
80104038:	0f 85 24 fe ff ff    	jne    80103e62 <print_bitches+0x72>
  release(&ptable.lock);
8010403e:	83 ec 0c             	sub    $0xc,%esp
80104041:	68 20 2d 11 80       	push   $0x80112d20
80104046:	e8 75 0e 00 00       	call   80104ec0 <release>
}
8010404b:	83 c4 10             	add    $0x10,%esp
8010404e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104051:	5b                   	pop    %ebx
80104052:	5e                   	pop    %esi
80104053:	5f                   	pop    %edi
80104054:	5d                   	pop    %ebp
80104055:	c3                   	ret    
80104056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010405d:	8d 76 00             	lea    0x0(%esi),%esi
    print_space(10-how_many_digit(p->creation_time));
80104060:	be 09 00 00 00       	mov    $0x9,%esi
80104065:	e9 a1 fe ff ff       	jmp    80103f0b <print_bitches+0x11b>
8010406a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104070 <count_child>:
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	53                   	push   %ebx
  int count = 0;
80104074:	31 db                	xor    %ebx,%ebx
{
80104076:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104079:	68 20 2d 11 80       	push   $0x80112d20
8010407e:	e8 9d 0e 00 00       	call   80104f20 <acquire>
    if (p->parent->pid == father->pid)
80104083:	8b 45 08             	mov    0x8(%ebp),%eax
80104086:	83 c4 10             	add    $0x10,%esp
80104089:	8b 48 10             	mov    0x10(%eax),%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010408c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p->parent->pid == father->pid)
80104098:	8b 50 14             	mov    0x14(%eax),%edx
      count++;
8010409b:	39 4a 10             	cmp    %ecx,0x10(%edx)
8010409e:	0f 94 c2             	sete   %dl
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040a1:	05 a0 00 00 00       	add    $0xa0,%eax
      count++;
801040a6:	0f b6 d2             	movzbl %dl,%edx
801040a9:	01 d3                	add    %edx,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040ab:	3d 54 55 11 80       	cmp    $0x80115554,%eax
801040b0:	75 e6                	jne    80104098 <count_child+0x28>
  release(&ptable.lock);
801040b2:	83 ec 0c             	sub    $0xc,%esp
801040b5:	68 20 2d 11 80       	push   $0x80112d20
801040ba:	e8 01 0e 00 00       	call   80104ec0 <release>
}
801040bf:	89 d8                	mov    %ebx,%eax
801040c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040c4:	c9                   	leave  
801040c5:	c3                   	ret    
801040c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040cd:	8d 76 00             	lea    0x0(%esi),%esi

801040d0 <growproc>:
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	56                   	push   %esi
801040d4:	53                   	push   %ebx
801040d5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801040d8:	e8 f3 0c 00 00       	call   80104dd0 <pushcli>
  c = mycpu();
801040dd:	e8 9e f8 ff ff       	call   80103980 <mycpu>
  p = c->proc;
801040e2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040e8:	e8 33 0d 00 00       	call   80104e20 <popcli>
  sz = curproc->sz;
801040ed:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
801040ef:	85 f6                	test   %esi,%esi
801040f1:	7f 1d                	jg     80104110 <growproc+0x40>
  else if (n < 0)
801040f3:	75 3b                	jne    80104130 <growproc+0x60>
  switchuvm(curproc);
801040f5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801040f8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801040fa:	53                   	push   %ebx
801040fb:	e8 60 38 00 00       	call   80107960 <switchuvm>
  return 0;
80104100:	83 c4 10             	add    $0x10,%esp
80104103:	31 c0                	xor    %eax,%eax
}
80104105:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104108:	5b                   	pop    %ebx
80104109:	5e                   	pop    %esi
8010410a:	5d                   	pop    %ebp
8010410b:	c3                   	ret    
8010410c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104110:	83 ec 04             	sub    $0x4,%esp
80104113:	01 c6                	add    %eax,%esi
80104115:	56                   	push   %esi
80104116:	50                   	push   %eax
80104117:	ff 73 04             	push   0x4(%ebx)
8010411a:	e8 c1 3a 00 00       	call   80107be0 <allocuvm>
8010411f:	83 c4 10             	add    $0x10,%esp
80104122:	85 c0                	test   %eax,%eax
80104124:	75 cf                	jne    801040f5 <growproc+0x25>
      return -1;
80104126:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010412b:	eb d8                	jmp    80104105 <growproc+0x35>
8010412d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104130:	83 ec 04             	sub    $0x4,%esp
80104133:	01 c6                	add    %eax,%esi
80104135:	56                   	push   %esi
80104136:	50                   	push   %eax
80104137:	ff 73 04             	push   0x4(%ebx)
8010413a:	e8 d1 3b 00 00       	call   80107d10 <deallocuvm>
8010413f:	83 c4 10             	add    $0x10,%esp
80104142:	85 c0                	test   %eax,%eax
80104144:	75 af                	jne    801040f5 <growproc+0x25>
80104146:	eb de                	jmp    80104126 <growproc+0x56>
80104148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010414f:	90                   	nop

80104150 <fork>:
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	57                   	push   %edi
80104154:	56                   	push   %esi
80104155:	53                   	push   %ebx
80104156:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104159:	e8 72 0c 00 00       	call   80104dd0 <pushcli>
  c = mycpu();
8010415e:	e8 1d f8 ff ff       	call   80103980 <mycpu>
  p = c->proc;
80104163:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104169:	e8 b2 0c 00 00       	call   80104e20 <popcli>
  if ((np = allocproc()) == 0)
8010416e:	e8 3d f6 ff ff       	call   801037b0 <allocproc>
80104173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104176:	85 c0                	test   %eax,%eax
80104178:	0f 84 da 00 00 00    	je     80104258 <fork+0x108>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
8010417e:	83 ec 08             	sub    $0x8,%esp
80104181:	ff 33                	push   (%ebx)
80104183:	89 c7                	mov    %eax,%edi
80104185:	ff 73 04             	push   0x4(%ebx)
80104188:	e8 23 3d 00 00       	call   80107eb0 <copyuvm>
8010418d:	83 c4 10             	add    $0x10,%esp
80104190:	89 47 04             	mov    %eax,0x4(%edi)
80104193:	85 c0                	test   %eax,%eax
80104195:	0f 84 c4 00 00 00    	je     8010425f <fork+0x10f>
  np->sz = curproc->sz;
8010419b:	8b 03                	mov    (%ebx),%eax
8010419d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801041a0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801041a2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801041a5:	89 c8                	mov    %ecx,%eax
801041a7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801041aa:	b9 13 00 00 00       	mov    $0x13,%ecx
801041af:	8b 73 18             	mov    0x18(%ebx),%esi
801041b2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
801041b4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801041b6:	8b 40 18             	mov    0x18(%eax),%eax
801041b9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if (curproc->ofile[i])
801041c0:	8b 44 b3 34          	mov    0x34(%ebx,%esi,4),%eax
801041c4:	85 c0                	test   %eax,%eax
801041c6:	74 13                	je     801041db <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801041c8:	83 ec 0c             	sub    $0xc,%esp
801041cb:	50                   	push   %eax
801041cc:	e8 cf cc ff ff       	call   80100ea0 <filedup>
801041d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801041d4:	83 c4 10             	add    $0x10,%esp
801041d7:	89 44 b2 34          	mov    %eax,0x34(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
801041db:	83 c6 01             	add    $0x1,%esi
801041de:	83 fe 10             	cmp    $0x10,%esi
801041e1:	75 dd                	jne    801041c0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
801041e3:	83 ec 0c             	sub    $0xc,%esp
801041e6:	ff 73 74             	push   0x74(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801041e9:	83 c3 78             	add    $0x78,%ebx
  np->cwd = idup(curproc->cwd);
801041ec:	e8 5f d5 ff ff       	call   80101750 <idup>
801041f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801041f4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801041f7:	89 47 74             	mov    %eax,0x74(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801041fa:	8d 47 78             	lea    0x78(%edi),%eax
801041fd:	6a 10                	push   $0x10
801041ff:	53                   	push   %ebx
80104200:	50                   	push   %eax
80104201:	e8 9a 0f 00 00       	call   801051a0 <safestrcpy>
  pid = np->pid;
80104206:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104209:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104210:	e8 0b 0d 00 00       	call   80104f20 <acquire>
  np->state = RUNNABLE;
80104215:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  acquire(&tickslock);
8010421c:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)
80104223:	e8 f8 0c 00 00       	call   80104f20 <acquire>
  np->creation_time = ticks;
80104228:	a1 60 55 11 80       	mov    0x80115560,%eax
8010422d:	89 47 20             	mov    %eax,0x20(%edi)
  np->preemption_time = ticks;
80104230:	89 47 24             	mov    %eax,0x24(%edi)
  release(&tickslock);
80104233:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)
8010423a:	e8 81 0c 00 00       	call   80104ec0 <release>
  release(&ptable.lock);
8010423f:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104246:	e8 75 0c 00 00       	call   80104ec0 <release>
  return pid;
8010424b:	83 c4 10             	add    $0x10,%esp
}
8010424e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104251:	89 d8                	mov    %ebx,%eax
80104253:	5b                   	pop    %ebx
80104254:	5e                   	pop    %esi
80104255:	5f                   	pop    %edi
80104256:	5d                   	pop    %ebp
80104257:	c3                   	ret    
    return -1;
80104258:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010425d:	eb ef                	jmp    8010424e <fork+0xfe>
    kfree(np->kstack);
8010425f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104262:	83 ec 0c             	sub    $0xc,%esp
80104265:	ff 73 08             	push   0x8(%ebx)
80104268:	e8 53 e2 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
8010426d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104274:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104277:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
8010427e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104283:	eb c9                	jmp    8010424e <fork+0xfe>
80104285:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010428c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104290 <round_robin>:
{
80104290:	55                   	push   %ebp
  int max_diff = MIN_INT;
80104291:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104296:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
{
8010429b:	89 e5                	mov    %esp,%ebp
8010429d:	56                   	push   %esi
  struct proc *res = 0;
8010429e:	31 f6                	xor    %esi,%esi
{
801042a0:	53                   	push   %ebx
  int now = ticks;
801042a1:	8b 1d 60 55 11 80    	mov    0x80115560,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ae:	66 90                	xchg   %ax,%ax
    if (p->state != RUNNABLE || p->que_id != RR)
801042b0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801042b4:	75 1a                	jne    801042d0 <round_robin+0x40>
801042b6:	83 78 28 01          	cmpl   $0x1,0x28(%eax)
801042ba:	75 14                	jne    801042d0 <round_robin+0x40>
    if ((now - p->preemption_time > max_diff))
801042bc:	89 da                	mov    %ebx,%edx
801042be:	2b 50 24             	sub    0x24(%eax),%edx
801042c1:	39 ca                	cmp    %ecx,%edx
801042c3:	7e 0b                	jle    801042d0 <round_robin+0x40>
801042c5:	89 d1                	mov    %edx,%ecx
801042c7:	89 c6                	mov    %eax,%esi
801042c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042d0:	05 a0 00 00 00       	add    $0xa0,%eax
801042d5:	3d 54 55 11 80       	cmp    $0x80115554,%eax
801042da:	75 d4                	jne    801042b0 <round_robin+0x20>
}
801042dc:	89 f0                	mov    %esi,%eax
801042de:	5b                   	pop    %ebx
801042df:	5e                   	pop    %esi
801042e0:	5d                   	pop    %ebp
801042e1:	c3                   	ret    
801042e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042f0 <last_come_first_serve>:
{
801042f0:	55                   	push   %ebp
  int latest_time = MIN_INT;
801042f1:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042f6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
{
801042fb:	89 e5                	mov    %esp,%ebp
801042fd:	53                   	push   %ebx
  struct proc *res = 0;
801042fe:	31 db                	xor    %ebx,%ebx
    if (p->state != RUNNABLE || p->que_id != LCFS)
80104300:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104304:	75 1a                	jne    80104320 <last_come_first_serve+0x30>
80104306:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
8010430a:	75 14                	jne    80104320 <last_come_first_serve+0x30>
    if (p->creation_time > latest_time)
8010430c:	8b 50 20             	mov    0x20(%eax),%edx
8010430f:	39 ca                	cmp    %ecx,%edx
80104311:	7e 0d                	jle    80104320 <last_come_first_serve+0x30>
80104313:	89 d1                	mov    %edx,%ecx
80104315:	89 c3                	mov    %eax,%ebx
80104317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010431e:	66 90                	xchg   %ax,%ax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104320:	05 a0 00 00 00       	add    $0xa0,%eax
80104325:	3d 54 55 11 80       	cmp    $0x80115554,%eax
8010432a:	75 d4                	jne    80104300 <last_come_first_serve+0x10>
}
8010432c:	89 d8                	mov    %ebx,%eax
8010432e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104331:	c9                   	leave  
80104332:	c3                   	ret    
80104333:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104340 <best_job_first>:
  float min_rank = (float)MAX_INT;
80104340:	d9 05 70 88 10 80    	flds   0x80108870
  struct proc *res = 0;
80104346:	31 d2                	xor    %edx,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104348:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010434d:	8d 76 00             	lea    0x0(%esi),%esi
    if (p->state != RUNNABLE || p->que_id != BJF)
80104350:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104354:	0f 85 96 00 00 00    	jne    801043f0 <best_job_first+0xb0>
8010435a:	83 78 28 03          	cmpl   $0x3,0x28(%eax)
8010435e:	0f 85 8c 00 00 00    	jne    801043f0 <best_job_first+0xb0>
{
80104364:	55                   	push   %ebp
80104365:	89 e5                	mov    %esp,%ebp
80104367:	53                   	push   %ebx
80104368:	83 ec 0c             	sub    $0xc,%esp
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
8010436b:	db 80 88 00 00 00    	fildl  0x88(%eax)
80104371:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
80104377:	31 db                	xor    %ebx,%ebx
80104379:	db 40 20             	fildl  0x20(%eax)
8010437c:	d8 88 90 00 00 00    	fmuls  0x90(%eax)
80104382:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80104385:	8b 08                	mov    (%eax),%ecx
80104387:	89 4d f0             	mov    %ecx,-0x10(%ebp)
8010438a:	de c1                	faddp  %st,%st(1)
8010438c:	d9 80 94 00 00 00    	flds   0x94(%eax)
80104392:	d8 88 98 00 00 00    	fmuls  0x98(%eax)
80104398:	de c1                	faddp  %st,%st(1)
8010439a:	df 6d f0             	fildll -0x10(%ebp)
8010439d:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
801043a3:	de c1                	faddp  %st,%st(1)
801043a5:	d9 c9                	fxch   %st(1)
    if (rank < min_rank)
801043a7:	db f1                	fcomi  %st(1),%st
801043a9:	76 0d                	jbe    801043b8 <best_job_first+0x78>
801043ab:	dd d8                	fstp   %st(0)
801043ad:	89 c2                	mov    %eax,%edx
801043af:	eb 09                	jmp    801043ba <best_job_first+0x7a>
801043b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043b8:	dd d9                	fstp   %st(1)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ba:	05 a0 00 00 00       	add    $0xa0,%eax
801043bf:	3d 54 55 11 80       	cmp    $0x80115554,%eax
801043c4:	74 1c                	je     801043e2 <best_job_first+0xa2>
    if (p->state != RUNNABLE || p->que_id != BJF)
801043c6:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801043ca:	75 ee                	jne    801043ba <best_job_first+0x7a>
801043cc:	83 78 28 03          	cmpl   $0x3,0x28(%eax)
801043d0:	74 99                	je     8010436b <best_job_first+0x2b>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043d2:	05 a0 00 00 00       	add    $0xa0,%eax
801043d7:	3d 54 55 11 80       	cmp    $0x80115554,%eax
801043dc:	75 e8                	jne    801043c6 <best_job_first+0x86>
801043de:	dd d8                	fstp   %st(0)
801043e0:	eb 02                	jmp    801043e4 <best_job_first+0xa4>
801043e2:	dd d8                	fstp   %st(0)
}
801043e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043e7:	89 d0                	mov    %edx,%eax
801043e9:	c9                   	leave  
801043ea:	c3                   	ret    
801043eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043ef:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043f0:	05 a0 00 00 00       	add    $0xa0,%eax
801043f5:	3d 54 55 11 80       	cmp    $0x80115554,%eax
801043fa:	0f 85 50 ff ff ff    	jne    80104350 <best_job_first+0x10>
80104400:	dd d8                	fstp   %st(0)
}
80104402:	89 d0                	mov    %edx,%eax
80104404:	c3                   	ret    
80104405:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010440c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104410 <scheduler>:
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	57                   	push   %edi
80104414:	56                   	push   %esi
80104415:	53                   	push   %ebx
80104416:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80104419:	e8 62 f5 ff ff       	call   80103980 <mycpu>
  c->proc = 0;
8010441e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104425:	00 00 00 
  struct cpu *c = mycpu();
80104428:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
8010442a:	8d 40 04             	lea    0x4(%eax),%eax
8010442d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  asm volatile("sti");
80104430:	fb                   	sti    
    acquire(&ptable.lock);
80104431:	83 ec 0c             	sub    $0xc,%esp
  struct proc *res = 0;
80104434:	31 f6                	xor    %esi,%esi
    acquire(&ptable.lock);
80104436:	68 20 2d 11 80       	push   $0x80112d20
8010443b:	e8 e0 0a 00 00       	call   80104f20 <acquire>
  int now = ticks;
80104440:	8b 3d 60 55 11 80    	mov    0x80115560,%edi
80104446:	83 c4 10             	add    $0x10,%esp
  int max_diff = MIN_INT;
80104449:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010444e:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104457:	90                   	nop
    if (p->state != RUNNABLE || p->que_id != RR)
80104458:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010445c:	75 1a                	jne    80104478 <scheduler+0x68>
8010445e:	83 78 28 01          	cmpl   $0x1,0x28(%eax)
80104462:	75 14                	jne    80104478 <scheduler+0x68>
    if ((now - p->preemption_time > max_diff))
80104464:	89 fa                	mov    %edi,%edx
80104466:	2b 50 24             	sub    0x24(%eax),%edx
80104469:	39 ca                	cmp    %ecx,%edx
8010446b:	7e 0b                	jle    80104478 <scheduler+0x68>
8010446d:	89 d1                	mov    %edx,%ecx
8010446f:	89 c6                	mov    %eax,%esi
80104471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104478:	05 a0 00 00 00       	add    $0xa0,%eax
8010447d:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104482:	75 d4                	jne    80104458 <scheduler+0x48>
    if (p == 0)
80104484:	85 f6                	test   %esi,%esi
80104486:	74 60                	je     801044e8 <scheduler+0xd8>
    switchuvm(p);
80104488:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
8010448b:	89 b3 ac 00 00 00    	mov    %esi,0xac(%ebx)
    switchuvm(p);
80104491:	56                   	push   %esi
80104492:	e8 c9 34 00 00       	call   80107960 <switchuvm>
    p->executed_cycle += 0.1f;
80104497:	d9 05 6c 88 10 80    	flds   0x8010886c
8010449d:	d8 86 94 00 00 00    	fadds  0x94(%esi)
    p->state = RUNNING;
801044a3:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
    p->preemption_time = ticks;
801044aa:	a1 60 55 11 80       	mov    0x80115560,%eax
801044af:	89 46 24             	mov    %eax,0x24(%esi)
    p->executed_cycle += 0.1f;
801044b2:	d9 9e 94 00 00 00    	fstps  0x94(%esi)
    swtch(&(c->scheduler), p->context);
801044b8:	58                   	pop    %eax
801044b9:	5a                   	pop    %edx
801044ba:	ff 76 1c             	push   0x1c(%esi)
801044bd:	ff 75 dc             	push   -0x24(%ebp)
801044c0:	e8 36 0d 00 00       	call   801051fb <swtch>
    switchkvm();
801044c5:	e8 86 34 00 00       	call   80107950 <switchkvm>
    c->proc = 0;
801044ca:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
801044d1:	00 00 00 
    release(&ptable.lock);
801044d4:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801044db:	e8 e0 09 00 00       	call   80104ec0 <release>
801044e0:	83 c4 10             	add    $0x10,%esp
801044e3:	e9 48 ff ff ff       	jmp    80104430 <scheduler+0x20>
  int latest_time = MIN_INT;
801044e8:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044ed:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801044f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (p->state != RUNNABLE || p->que_id != LCFS)
801044f8:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801044fc:	75 12                	jne    80104510 <scheduler+0x100>
801044fe:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
80104502:	75 0c                	jne    80104510 <scheduler+0x100>
    if (p->creation_time > latest_time)
80104504:	8b 50 20             	mov    0x20(%eax),%edx
80104507:	39 ca                	cmp    %ecx,%edx
80104509:	7e 05                	jle    80104510 <scheduler+0x100>
8010450b:	89 d1                	mov    %edx,%ecx
8010450d:	89 c6                	mov    %eax,%esi
8010450f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104510:	05 a0 00 00 00       	add    $0xa0,%eax
80104515:	3d 54 55 11 80       	cmp    $0x80115554,%eax
8010451a:	75 dc                	jne    801044f8 <scheduler+0xe8>
    if (p == 0)
8010451c:	85 f6                	test   %esi,%esi
8010451e:	0f 85 64 ff ff ff    	jne    80104488 <scheduler+0x78>
  float min_rank = (float)MAX_INT;
80104524:	d9 05 70 88 10 80    	flds   0x80108870
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010452a:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010452f:	90                   	nop
    if (p->state != RUNNABLE || p->que_id != BJF)
80104530:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104534:	75 5a                	jne    80104590 <scheduler+0x180>
80104536:	83 78 28 03          	cmpl   $0x3,0x28(%eax)
8010453a:	75 54                	jne    80104590 <scheduler+0x180>
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
8010453c:	db 80 88 00 00 00    	fildl  0x88(%eax)
80104542:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
80104548:	31 c9                	xor    %ecx,%ecx
8010454a:	db 40 20             	fildl  0x20(%eax)
8010454d:	d8 88 90 00 00 00    	fmuls  0x90(%eax)
80104553:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80104556:	8b 10                	mov    (%eax),%edx
80104558:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010455b:	de c1                	faddp  %st,%st(1)
8010455d:	d9 80 94 00 00 00    	flds   0x94(%eax)
80104563:	d8 88 98 00 00 00    	fmuls  0x98(%eax)
80104569:	de c1                	faddp  %st,%st(1)
8010456b:	df 6d e0             	fildll -0x20(%ebp)
8010456e:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
80104574:	de c1                	faddp  %st,%st(1)
80104576:	d9 c9                	fxch   %st(1)
    if (rank < min_rank)
80104578:	db f1                	fcomi  %st(1),%st
8010457a:	76 0c                	jbe    80104588 <scheduler+0x178>
8010457c:	dd d8                	fstp   %st(0)
8010457e:	89 c6                	mov    %eax,%esi
80104580:	eb 0e                	jmp    80104590 <scheduler+0x180>
80104582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104588:	dd d9                	fstp   %st(1)
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104590:	05 a0 00 00 00       	add    $0xa0,%eax
80104595:	3d 54 55 11 80       	cmp    $0x80115554,%eax
8010459a:	75 94                	jne    80104530 <scheduler+0x120>
8010459c:	dd d8                	fstp   %st(0)
    if (p == 0)
8010459e:	85 f6                	test   %esi,%esi
801045a0:	0f 85 e2 fe ff ff    	jne    80104488 <scheduler+0x78>
      release(&ptable.lock);
801045a6:	83 ec 0c             	sub    $0xc,%esp
801045a9:	68 20 2d 11 80       	push   $0x80112d20
801045ae:	e8 0d 09 00 00       	call   80104ec0 <release>
      continue;
801045b3:	83 c4 10             	add    $0x10,%esp
801045b6:	e9 75 fe ff ff       	jmp    80104430 <scheduler+0x20>
801045bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045bf:	90                   	nop

801045c0 <sched>:
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
  pushcli();
801045c5:	e8 06 08 00 00       	call   80104dd0 <pushcli>
  c = mycpu();
801045ca:	e8 b1 f3 ff ff       	call   80103980 <mycpu>
  p = c->proc;
801045cf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045d5:	e8 46 08 00 00       	call   80104e20 <popcli>
  if (!holding(&ptable.lock))
801045da:	83 ec 0c             	sub    $0xc,%esp
801045dd:	68 20 2d 11 80       	push   $0x80112d20
801045e2:	e8 99 08 00 00       	call   80104e80 <holding>
801045e7:	83 c4 10             	add    $0x10,%esp
801045ea:	85 c0                	test   %eax,%eax
801045ec:	74 4f                	je     8010463d <sched+0x7d>
  if (mycpu()->ncli != 1)
801045ee:	e8 8d f3 ff ff       	call   80103980 <mycpu>
801045f3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801045fa:	75 68                	jne    80104664 <sched+0xa4>
  if (p->state == RUNNING)
801045fc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104600:	74 55                	je     80104657 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104602:	9c                   	pushf  
80104603:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80104604:	f6 c4 02             	test   $0x2,%ah
80104607:	75 41                	jne    8010464a <sched+0x8a>
  intena = mycpu()->intena;
80104609:	e8 72 f3 ff ff       	call   80103980 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010460e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104611:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104617:	e8 64 f3 ff ff       	call   80103980 <mycpu>
8010461c:	83 ec 08             	sub    $0x8,%esp
8010461f:	ff 70 04             	push   0x4(%eax)
80104622:	53                   	push   %ebx
80104623:	e8 d3 0b 00 00       	call   801051fb <swtch>
  mycpu()->intena = intena;
80104628:	e8 53 f3 ff ff       	call   80103980 <mycpu>
}
8010462d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104630:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104636:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104639:	5b                   	pop    %ebx
8010463a:	5e                   	pop    %esi
8010463b:	5d                   	pop    %ebp
8010463c:	c3                   	ret    
    panic("sched ptable.lock");
8010463d:	83 ec 0c             	sub    $0xc,%esp
80104640:	68 19 87 10 80       	push   $0x80108719
80104645:	e8 36 bd ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010464a:	83 ec 0c             	sub    $0xc,%esp
8010464d:	68 45 87 10 80       	push   $0x80108745
80104652:	e8 29 bd ff ff       	call   80100380 <panic>
    panic("sched running");
80104657:	83 ec 0c             	sub    $0xc,%esp
8010465a:	68 37 87 10 80       	push   $0x80108737
8010465f:	e8 1c bd ff ff       	call   80100380 <panic>
    panic("sched locks");
80104664:	83 ec 0c             	sub    $0xc,%esp
80104667:	68 2b 87 10 80       	push   $0x8010872b
8010466c:	e8 0f bd ff ff       	call   80100380 <panic>
80104671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010467f:	90                   	nop

80104680 <exit>:
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	57                   	push   %edi
80104684:	56                   	push   %esi
80104685:	53                   	push   %ebx
80104686:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104689:	e8 82 f4 ff ff       	call   80103b10 <myproc>
  if (curproc == initproc)
8010468e:	39 05 54 55 11 80    	cmp    %eax,0x80115554
80104694:	0f 84 07 01 00 00    	je     801047a1 <exit+0x121>
8010469a:	89 c3                	mov    %eax,%ebx
8010469c:	8d 70 34             	lea    0x34(%eax),%esi
8010469f:	8d 78 74             	lea    0x74(%eax),%edi
801046a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd])
801046a8:	8b 06                	mov    (%esi),%eax
801046aa:	85 c0                	test   %eax,%eax
801046ac:	74 12                	je     801046c0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801046ae:	83 ec 0c             	sub    $0xc,%esp
801046b1:	50                   	push   %eax
801046b2:	e8 39 c8 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
801046b7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801046bd:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
801046c0:	83 c6 04             	add    $0x4,%esi
801046c3:	39 f7                	cmp    %esi,%edi
801046c5:	75 e1                	jne    801046a8 <exit+0x28>
  begin_op();
801046c7:	e8 94 e6 ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
801046cc:	83 ec 0c             	sub    $0xc,%esp
801046cf:	ff 73 74             	push   0x74(%ebx)
801046d2:	e8 d9 d1 ff ff       	call   801018b0 <iput>
  end_op();
801046d7:	e8 f4 e6 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
801046dc:	c7 43 74 00 00 00 00 	movl   $0x0,0x74(%ebx)
  acquire(&ptable.lock);
801046e3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801046ea:	e8 31 08 00 00       	call   80104f20 <acquire>
  wakeup1(curproc->parent);
801046ef:	8b 53 14             	mov    0x14(%ebx),%edx
801046f2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046f5:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801046fa:	eb 10                	jmp    8010470c <exit+0x8c>
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104700:	05 a0 00 00 00       	add    $0xa0,%eax
80104705:	3d 54 55 11 80       	cmp    $0x80115554,%eax
8010470a:	74 1e                	je     8010472a <exit+0xaa>
    if (p->state == SLEEPING && p->chan == chan)
8010470c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104710:	75 ee                	jne    80104700 <exit+0x80>
80104712:	3b 50 2c             	cmp    0x2c(%eax),%edx
80104715:	75 e9                	jne    80104700 <exit+0x80>
      p->state = RUNNABLE;
80104717:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010471e:	05 a0 00 00 00       	add    $0xa0,%eax
80104723:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104728:	75 e2                	jne    8010470c <exit+0x8c>
      p->parent = initproc;
8010472a:	8b 0d 54 55 11 80    	mov    0x80115554,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104730:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80104735:	eb 17                	jmp    8010474e <exit+0xce>
80104737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010473e:	66 90                	xchg   %ax,%ax
80104740:	81 c2 a0 00 00 00    	add    $0xa0,%edx
80104746:	81 fa 54 55 11 80    	cmp    $0x80115554,%edx
8010474c:	74 3a                	je     80104788 <exit+0x108>
    if (p->parent == curproc)
8010474e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104751:	75 ed                	jne    80104740 <exit+0xc0>
      if (p->state == ZOMBIE)
80104753:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104757:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
8010475a:	75 e4                	jne    80104740 <exit+0xc0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010475c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104761:	eb 11                	jmp    80104774 <exit+0xf4>
80104763:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104767:	90                   	nop
80104768:	05 a0 00 00 00       	add    $0xa0,%eax
8010476d:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104772:	74 cc                	je     80104740 <exit+0xc0>
    if (p->state == SLEEPING && p->chan == chan)
80104774:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104778:	75 ee                	jne    80104768 <exit+0xe8>
8010477a:	3b 48 2c             	cmp    0x2c(%eax),%ecx
8010477d:	75 e9                	jne    80104768 <exit+0xe8>
      p->state = RUNNABLE;
8010477f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104786:	eb e0                	jmp    80104768 <exit+0xe8>
  curproc->state = ZOMBIE;
80104788:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010478f:	e8 2c fe ff ff       	call   801045c0 <sched>
  panic("zombie exit");
80104794:	83 ec 0c             	sub    $0xc,%esp
80104797:	68 66 87 10 80       	push   $0x80108766
8010479c:	e8 df bb ff ff       	call   80100380 <panic>
    panic("init exiting");
801047a1:	83 ec 0c             	sub    $0xc,%esp
801047a4:	68 59 87 10 80       	push   $0x80108759
801047a9:	e8 d2 bb ff ff       	call   80100380 <panic>
801047ae:	66 90                	xchg   %ax,%ax

801047b0 <wait>:
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
  pushcli();
801047b5:	e8 16 06 00 00       	call   80104dd0 <pushcli>
  c = mycpu();
801047ba:	e8 c1 f1 ff ff       	call   80103980 <mycpu>
  p = c->proc;
801047bf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801047c5:	e8 56 06 00 00       	call   80104e20 <popcli>
  acquire(&ptable.lock);
801047ca:	83 ec 0c             	sub    $0xc,%esp
801047cd:	68 20 2d 11 80       	push   $0x80112d20
801047d2:	e8 49 07 00 00       	call   80104f20 <acquire>
801047d7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801047da:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047dc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801047e1:	eb 13                	jmp    801047f6 <wait+0x46>
801047e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047e7:	90                   	nop
801047e8:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
801047ee:	81 fb 54 55 11 80    	cmp    $0x80115554,%ebx
801047f4:	74 1e                	je     80104814 <wait+0x64>
      if (p->parent != curproc)
801047f6:	39 73 14             	cmp    %esi,0x14(%ebx)
801047f9:	75 ed                	jne    801047e8 <wait+0x38>
      if (p->state == ZOMBIE)
801047fb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801047ff:	74 5f                	je     80104860 <wait+0xb0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104801:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
      havekids = 1;
80104807:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010480c:	81 fb 54 55 11 80    	cmp    $0x80115554,%ebx
80104812:	75 e2                	jne    801047f6 <wait+0x46>
    if (!havekids || curproc->killed)
80104814:	85 c0                	test   %eax,%eax
80104816:	0f 84 9a 00 00 00    	je     801048b6 <wait+0x106>
8010481c:	8b 46 30             	mov    0x30(%esi),%eax
8010481f:	85 c0                	test   %eax,%eax
80104821:	0f 85 8f 00 00 00    	jne    801048b6 <wait+0x106>
  pushcli();
80104827:	e8 a4 05 00 00       	call   80104dd0 <pushcli>
  c = mycpu();
8010482c:	e8 4f f1 ff ff       	call   80103980 <mycpu>
  p = c->proc;
80104831:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104837:	e8 e4 05 00 00       	call   80104e20 <popcli>
  if (p == 0)
8010483c:	85 db                	test   %ebx,%ebx
8010483e:	0f 84 89 00 00 00    	je     801048cd <wait+0x11d>
  p->chan = chan;
80104844:	89 73 2c             	mov    %esi,0x2c(%ebx)
  p->state = SLEEPING;
80104847:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010484e:	e8 6d fd ff ff       	call   801045c0 <sched>
  p->chan = 0;
80104853:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
}
8010485a:	e9 7b ff ff ff       	jmp    801047da <wait+0x2a>
8010485f:	90                   	nop
        kfree(p->kstack);
80104860:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104863:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104866:	ff 73 08             	push   0x8(%ebx)
80104869:	e8 52 dc ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010486e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104875:	5a                   	pop    %edx
80104876:	ff 73 04             	push   0x4(%ebx)
80104879:	e8 c2 34 00 00       	call   80107d40 <freevm>
        p->pid = 0;
8010487e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104885:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010488c:	c6 43 78 00          	movb   $0x0,0x78(%ebx)
        p->killed = 0;
80104890:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
        p->state = UNUSED;
80104897:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010489e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801048a5:	e8 16 06 00 00       	call   80104ec0 <release>
        return pid;
801048aa:	83 c4 10             	add    $0x10,%esp
}
801048ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048b0:	89 f0                	mov    %esi,%eax
801048b2:	5b                   	pop    %ebx
801048b3:	5e                   	pop    %esi
801048b4:	5d                   	pop    %ebp
801048b5:	c3                   	ret    
      release(&ptable.lock);
801048b6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801048b9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801048be:	68 20 2d 11 80       	push   $0x80112d20
801048c3:	e8 f8 05 00 00       	call   80104ec0 <release>
      return -1;
801048c8:	83 c4 10             	add    $0x10,%esp
801048cb:	eb e0                	jmp    801048ad <wait+0xfd>
    panic("sleep");
801048cd:	83 ec 0c             	sub    $0xc,%esp
801048d0:	68 72 87 10 80       	push   $0x80108772
801048d5:	e8 a6 ba ff ff       	call   80100380 <panic>
801048da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048e0 <yield>:
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
  acquire(&ptable.lock); // DOC: yieldlock
801048e5:	83 ec 0c             	sub    $0xc,%esp
801048e8:	68 20 2d 11 80       	push   $0x80112d20
801048ed:	e8 2e 06 00 00       	call   80104f20 <acquire>
  pushcli();
801048f2:	e8 d9 04 00 00       	call   80104dd0 <pushcli>
  c = mycpu();
801048f7:	e8 84 f0 ff ff       	call   80103980 <mycpu>
  p = c->proc;
801048fc:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104902:	e8 19 05 00 00       	call   80104e20 <popcli>
  myproc()->preemption_time = ticks;
80104907:	8b 35 60 55 11 80    	mov    0x80115560,%esi
  myproc()->state = RUNNABLE;
8010490d:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pushcli();
80104914:	e8 b7 04 00 00       	call   80104dd0 <pushcli>
  c = mycpu();
80104919:	e8 62 f0 ff ff       	call   80103980 <mycpu>
  p = c->proc;
8010491e:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104924:	e8 f7 04 00 00       	call   80104e20 <popcli>
  myproc()->preemption_time = ticks;
80104929:	89 73 24             	mov    %esi,0x24(%ebx)
  pushcli();
8010492c:	e8 9f 04 00 00       	call   80104dd0 <pushcli>
  c = mycpu();
80104931:	e8 4a f0 ff ff       	call   80103980 <mycpu>
  p = c->proc;
80104936:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010493c:	e8 df 04 00 00       	call   80104e20 <popcli>
  myproc()->executed_cycle += 0.1;
80104941:	dd 05 78 88 10 80    	fldl   0x80108878
80104947:	d8 83 94 00 00 00    	fadds  0x94(%ebx)
8010494d:	d9 9b 94 00 00 00    	fstps  0x94(%ebx)
  sched();
80104953:	e8 68 fc ff ff       	call   801045c0 <sched>
  release(&ptable.lock);
80104958:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010495f:	e8 5c 05 00 00       	call   80104ec0 <release>
}
80104964:	83 c4 10             	add    $0x10,%esp
80104967:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010496a:	5b                   	pop    %ebx
8010496b:	5e                   	pop    %esi
8010496c:	5d                   	pop    %ebp
8010496d:	c3                   	ret    
8010496e:	66 90                	xchg   %ax,%ax

80104970 <sleep>:
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	57                   	push   %edi
80104974:	56                   	push   %esi
80104975:	53                   	push   %ebx
80104976:	83 ec 0c             	sub    $0xc,%esp
80104979:	8b 7d 08             	mov    0x8(%ebp),%edi
8010497c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010497f:	e8 4c 04 00 00       	call   80104dd0 <pushcli>
  c = mycpu();
80104984:	e8 f7 ef ff ff       	call   80103980 <mycpu>
  p = c->proc;
80104989:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010498f:	e8 8c 04 00 00       	call   80104e20 <popcli>
  if (p == 0)
80104994:	85 db                	test   %ebx,%ebx
80104996:	0f 84 87 00 00 00    	je     80104a23 <sleep+0xb3>
  if (lk == 0)
8010499c:	85 f6                	test   %esi,%esi
8010499e:	74 76                	je     80104a16 <sleep+0xa6>
  if (lk != &ptable.lock)
801049a0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801049a6:	74 50                	je     801049f8 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
801049a8:	83 ec 0c             	sub    $0xc,%esp
801049ab:	68 20 2d 11 80       	push   $0x80112d20
801049b0:	e8 6b 05 00 00       	call   80104f20 <acquire>
    release(lk);
801049b5:	89 34 24             	mov    %esi,(%esp)
801049b8:	e8 03 05 00 00       	call   80104ec0 <release>
  p->chan = chan;
801049bd:	89 7b 2c             	mov    %edi,0x2c(%ebx)
  p->state = SLEEPING;
801049c0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801049c7:	e8 f4 fb ff ff       	call   801045c0 <sched>
  p->chan = 0;
801049cc:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
    release(&ptable.lock);
801049d3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801049da:	e8 e1 04 00 00       	call   80104ec0 <release>
    acquire(lk);
801049df:	89 75 08             	mov    %esi,0x8(%ebp)
801049e2:	83 c4 10             	add    $0x10,%esp
}
801049e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049e8:	5b                   	pop    %ebx
801049e9:	5e                   	pop    %esi
801049ea:	5f                   	pop    %edi
801049eb:	5d                   	pop    %ebp
    acquire(lk);
801049ec:	e9 2f 05 00 00       	jmp    80104f20 <acquire>
801049f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801049f8:	89 7b 2c             	mov    %edi,0x2c(%ebx)
  p->state = SLEEPING;
801049fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104a02:	e8 b9 fb ff ff       	call   801045c0 <sched>
  p->chan = 0;
80104a07:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
}
80104a0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a11:	5b                   	pop    %ebx
80104a12:	5e                   	pop    %esi
80104a13:	5f                   	pop    %edi
80104a14:	5d                   	pop    %ebp
80104a15:	c3                   	ret    
    panic("sleep without lk");
80104a16:	83 ec 0c             	sub    $0xc,%esp
80104a19:	68 78 87 10 80       	push   $0x80108778
80104a1e:	e8 5d b9 ff ff       	call   80100380 <panic>
    panic("sleep");
80104a23:	83 ec 0c             	sub    $0xc,%esp
80104a26:	68 72 87 10 80       	push   $0x80108772
80104a2b:	e8 50 b9 ff ff       	call   80100380 <panic>

80104a30 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	53                   	push   %ebx
80104a34:	83 ec 10             	sub    $0x10,%esp
80104a37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104a3a:	68 20 2d 11 80       	push   $0x80112d20
80104a3f:	e8 dc 04 00 00       	call   80104f20 <acquire>
80104a44:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a47:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104a4c:	eb 0e                	jmp    80104a5c <wakeup+0x2c>
80104a4e:	66 90                	xchg   %ax,%ax
80104a50:	05 a0 00 00 00       	add    $0xa0,%eax
80104a55:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104a5a:	74 1e                	je     80104a7a <wakeup+0x4a>
    if (p->state == SLEEPING && p->chan == chan)
80104a5c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104a60:	75 ee                	jne    80104a50 <wakeup+0x20>
80104a62:	3b 58 2c             	cmp    0x2c(%eax),%ebx
80104a65:	75 e9                	jne    80104a50 <wakeup+0x20>
      p->state = RUNNABLE;
80104a67:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a6e:	05 a0 00 00 00       	add    $0xa0,%eax
80104a73:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104a78:	75 e2                	jne    80104a5c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104a7a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104a81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a84:	c9                   	leave  
  release(&ptable.lock);
80104a85:	e9 36 04 00 00       	jmp    80104ec0 <release>
80104a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a90 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 10             	sub    $0x10,%esp
80104a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104a9a:	68 20 2d 11 80       	push   $0x80112d20
80104a9f:	e8 7c 04 00 00       	call   80104f20 <acquire>
80104aa4:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104aa7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104aac:	eb 0e                	jmp    80104abc <kill+0x2c>
80104aae:	66 90                	xchg   %ax,%ax
80104ab0:	05 a0 00 00 00       	add    $0xa0,%eax
80104ab5:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104aba:	74 34                	je     80104af0 <kill+0x60>
  {
    if (p->pid == pid)
80104abc:	39 58 10             	cmp    %ebx,0x10(%eax)
80104abf:	75 ef                	jne    80104ab0 <kill+0x20>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
80104ac1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104ac5:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
      if (p->state == SLEEPING)
80104acc:	75 07                	jne    80104ad5 <kill+0x45>
        p->state = RUNNABLE;
80104ace:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104ad5:	83 ec 0c             	sub    $0xc,%esp
80104ad8:	68 20 2d 11 80       	push   $0x80112d20
80104add:	e8 de 03 00 00       	call   80104ec0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104ae2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104ae5:	83 c4 10             	add    $0x10,%esp
80104ae8:	31 c0                	xor    %eax,%eax
}
80104aea:	c9                   	leave  
80104aeb:	c3                   	ret    
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104af0:	83 ec 0c             	sub    $0xc,%esp
80104af3:	68 20 2d 11 80       	push   $0x80112d20
80104af8:	e8 c3 03 00 00       	call   80104ec0 <release>
}
80104afd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104b00:	83 c4 10             	add    $0x10,%esp
80104b03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b08:	c9                   	leave  
80104b09:	c3                   	ret    
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b10 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	56                   	push   %esi
80104b15:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104b18:	53                   	push   %ebx
80104b19:	bb cc 2d 11 80       	mov    $0x80112dcc,%ebx
80104b1e:	83 ec 3c             	sub    $0x3c,%esp
80104b21:	eb 27                	jmp    80104b4a <procdump+0x3a>
80104b23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b27:	90                   	nop
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104b28:	83 ec 0c             	sub    $0xc,%esp
80104b2b:	68 cf 8b 10 80       	push   $0x80108bcf
80104b30:	e8 6b bb ff ff       	call   801006a0 <cprintf>
80104b35:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b38:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80104b3e:	81 fb cc 55 11 80    	cmp    $0x801155cc,%ebx
80104b44:	0f 84 7e 00 00 00    	je     80104bc8 <procdump+0xb8>
    if (p->state == UNUSED)
80104b4a:	8b 43 94             	mov    -0x6c(%ebx),%eax
80104b4d:	85 c0                	test   %eax,%eax
80104b4f:	74 e7                	je     80104b38 <procdump+0x28>
      state = "???";
80104b51:	ba 89 87 10 80       	mov    $0x80108789,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104b56:	83 f8 05             	cmp    $0x5,%eax
80104b59:	77 11                	ja     80104b6c <procdump+0x5c>
80104b5b:	8b 14 85 54 88 10 80 	mov    -0x7fef77ac(,%eax,4),%edx
      state = "???";
80104b62:	b8 89 87 10 80       	mov    $0x80108789,%eax
80104b67:	85 d2                	test   %edx,%edx
80104b69:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104b6c:	53                   	push   %ebx
80104b6d:	52                   	push   %edx
80104b6e:	ff 73 98             	push   -0x68(%ebx)
80104b71:	68 8d 87 10 80       	push   $0x8010878d
80104b76:	e8 25 bb ff ff       	call   801006a0 <cprintf>
    if (p->state == SLEEPING)
80104b7b:	83 c4 10             	add    $0x10,%esp
80104b7e:	83 7b 94 02          	cmpl   $0x2,-0x6c(%ebx)
80104b82:	75 a4                	jne    80104b28 <procdump+0x18>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80104b84:	83 ec 08             	sub    $0x8,%esp
80104b87:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b8a:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104b8d:	50                   	push   %eax
80104b8e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80104b91:	8b 40 0c             	mov    0xc(%eax),%eax
80104b94:	83 c0 08             	add    $0x8,%eax
80104b97:	50                   	push   %eax
80104b98:	e8 d3 01 00 00       	call   80104d70 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104b9d:	83 c4 10             	add    $0x10,%esp
80104ba0:	8b 17                	mov    (%edi),%edx
80104ba2:	85 d2                	test   %edx,%edx
80104ba4:	74 82                	je     80104b28 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104ba6:	83 ec 08             	sub    $0x8,%esp
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104ba9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104bac:	52                   	push   %edx
80104bad:	68 61 81 10 80       	push   $0x80108161
80104bb2:	e8 e9 ba ff ff       	call   801006a0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104bb7:	83 c4 10             	add    $0x10,%esp
80104bba:	39 fe                	cmp    %edi,%esi
80104bbc:	75 e2                	jne    80104ba0 <procdump+0x90>
80104bbe:	e9 65 ff ff ff       	jmp    80104b28 <procdump+0x18>
80104bc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bc7:	90                   	nop
  }
}
80104bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bcb:	5b                   	pop    %ebx
80104bcc:	5e                   	pop    %esi
80104bcd:	5f                   	pop    %edi
80104bce:	5d                   	pop    %ebp
80104bcf:	c3                   	ret    

80104bd0 <find_digital_root>:

int find_digital_root(int num)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	53                   	push   %ebx
80104bd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while (num >= 10)
80104bd8:	83 fb 09             	cmp    $0x9,%ebx
80104bdb:	7e 2e                	jle    80104c0b <find_digital_root+0x3b>
  {
    int temp = num;
    int res = 0;
    while (temp != 0)
    {
      int current_dig = temp % 10;
80104bdd:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80104be8:	89 d9                	mov    %ebx,%ecx
    int res = 0;
80104bea:	31 db                	xor    %ebx,%ebx
80104bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      int current_dig = temp % 10;
80104bf0:	89 c8                	mov    %ecx,%eax
80104bf2:	f7 e6                	mul    %esi
80104bf4:	c1 ea 03             	shr    $0x3,%edx
80104bf7:	8d 04 92             	lea    (%edx,%edx,4),%eax
80104bfa:	01 c0                	add    %eax,%eax
80104bfc:	29 c1                	sub    %eax,%ecx
      res += current_dig;
80104bfe:	01 cb                	add    %ecx,%ebx
      temp /= 10;
80104c00:	89 d1                	mov    %edx,%ecx
    while (temp != 0)
80104c02:	85 d2                	test   %edx,%edx
80104c04:	75 ea                	jne    80104bf0 <find_digital_root+0x20>
  while (num >= 10)
80104c06:	83 fb 09             	cmp    $0x9,%ebx
80104c09:	7f dd                	jg     80104be8 <find_digital_root+0x18>
    }
    num = res;
  }
  return num;
80104c0b:	89 d8                	mov    %ebx,%eax
80104c0d:	5b                   	pop    %ebx
80104c0e:	5e                   	pop    %esi
80104c0f:	5d                   	pop    %ebp
80104c10:	c3                   	ret    
80104c11:	66 90                	xchg   %ax,%ax
80104c13:	66 90                	xchg   %ax,%ax
80104c15:	66 90                	xchg   %ax,%ax
80104c17:	66 90                	xchg   %ax,%ax
80104c19:	66 90                	xchg   %ax,%ax
80104c1b:	66 90                	xchg   %ax,%ax
80104c1d:	66 90                	xchg   %ax,%ax
80104c1f:	90                   	nop

80104c20 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	53                   	push   %ebx
80104c24:	83 ec 0c             	sub    $0xc,%esp
80104c27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104c2a:	68 80 88 10 80       	push   $0x80108880
80104c2f:	8d 43 04             	lea    0x4(%ebx),%eax
80104c32:	50                   	push   %eax
80104c33:	e8 18 01 00 00       	call   80104d50 <initlock>
  lk->name = name;
80104c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104c3b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104c41:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104c44:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104c4b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104c4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c51:	c9                   	leave  
80104c52:	c3                   	ret    
80104c53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c60 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	56                   	push   %esi
80104c64:	53                   	push   %ebx
80104c65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c68:	8d 73 04             	lea    0x4(%ebx),%esi
80104c6b:	83 ec 0c             	sub    $0xc,%esp
80104c6e:	56                   	push   %esi
80104c6f:	e8 ac 02 00 00       	call   80104f20 <acquire>
  while (lk->locked) {
80104c74:	8b 13                	mov    (%ebx),%edx
80104c76:	83 c4 10             	add    $0x10,%esp
80104c79:	85 d2                	test   %edx,%edx
80104c7b:	74 16                	je     80104c93 <acquiresleep+0x33>
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104c80:	83 ec 08             	sub    $0x8,%esp
80104c83:	56                   	push   %esi
80104c84:	53                   	push   %ebx
80104c85:	e8 e6 fc ff ff       	call   80104970 <sleep>
  while (lk->locked) {
80104c8a:	8b 03                	mov    (%ebx),%eax
80104c8c:	83 c4 10             	add    $0x10,%esp
80104c8f:	85 c0                	test   %eax,%eax
80104c91:	75 ed                	jne    80104c80 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104c93:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104c99:	e8 72 ee ff ff       	call   80103b10 <myproc>
80104c9e:	8b 40 10             	mov    0x10(%eax),%eax
80104ca1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104ca4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104ca7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104caa:	5b                   	pop    %ebx
80104cab:	5e                   	pop    %esi
80104cac:	5d                   	pop    %ebp
  release(&lk->lk);
80104cad:	e9 0e 02 00 00       	jmp    80104ec0 <release>
80104cb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104cc0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	56                   	push   %esi
80104cc4:	53                   	push   %ebx
80104cc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104cc8:	8d 73 04             	lea    0x4(%ebx),%esi
80104ccb:	83 ec 0c             	sub    $0xc,%esp
80104cce:	56                   	push   %esi
80104ccf:	e8 4c 02 00 00       	call   80104f20 <acquire>
  lk->locked = 0;
80104cd4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104cda:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104ce1:	89 1c 24             	mov    %ebx,(%esp)
80104ce4:	e8 47 fd ff ff       	call   80104a30 <wakeup>
  release(&lk->lk);
80104ce9:	89 75 08             	mov    %esi,0x8(%ebp)
80104cec:	83 c4 10             	add    $0x10,%esp
}
80104cef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cf2:	5b                   	pop    %ebx
80104cf3:	5e                   	pop    %esi
80104cf4:	5d                   	pop    %ebp
  release(&lk->lk);
80104cf5:	e9 c6 01 00 00       	jmp    80104ec0 <release>
80104cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d00 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	57                   	push   %edi
80104d04:	31 ff                	xor    %edi,%edi
80104d06:	56                   	push   %esi
80104d07:	53                   	push   %ebx
80104d08:	83 ec 18             	sub    $0x18,%esp
80104d0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104d0e:	8d 73 04             	lea    0x4(%ebx),%esi
80104d11:	56                   	push   %esi
80104d12:	e8 09 02 00 00       	call   80104f20 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104d17:	8b 03                	mov    (%ebx),%eax
80104d19:	83 c4 10             	add    $0x10,%esp
80104d1c:	85 c0                	test   %eax,%eax
80104d1e:	75 18                	jne    80104d38 <holdingsleep+0x38>
  release(&lk->lk);
80104d20:	83 ec 0c             	sub    $0xc,%esp
80104d23:	56                   	push   %esi
80104d24:	e8 97 01 00 00       	call   80104ec0 <release>
  return r;
}
80104d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d2c:	89 f8                	mov    %edi,%eax
80104d2e:	5b                   	pop    %ebx
80104d2f:	5e                   	pop    %esi
80104d30:	5f                   	pop    %edi
80104d31:	5d                   	pop    %ebp
80104d32:	c3                   	ret    
80104d33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d37:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104d38:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104d3b:	e8 d0 ed ff ff       	call   80103b10 <myproc>
80104d40:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d43:	0f 94 c0             	sete   %al
80104d46:	0f b6 c0             	movzbl %al,%eax
80104d49:	89 c7                	mov    %eax,%edi
80104d4b:	eb d3                	jmp    80104d20 <holdingsleep+0x20>
80104d4d:	66 90                	xchg   %ax,%ax
80104d4f:	90                   	nop

80104d50 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104d59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104d5f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104d62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104d69:	5d                   	pop    %ebp
80104d6a:	c3                   	ret    
80104d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d6f:	90                   	nop

80104d70 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104d70:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104d71:	31 d2                	xor    %edx,%edx
{
80104d73:	89 e5                	mov    %esp,%ebp
80104d75:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104d76:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104d7c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104d7f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d80:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104d86:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104d8c:	77 1a                	ja     80104da8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d8e:	8b 58 04             	mov    0x4(%eax),%ebx
80104d91:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104d94:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104d97:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d99:	83 fa 0a             	cmp    $0xa,%edx
80104d9c:	75 e2                	jne    80104d80 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104d9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104da1:	c9                   	leave  
80104da2:	c3                   	ret    
80104da3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104da7:	90                   	nop
  for(; i < 10; i++)
80104da8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104dab:	8d 51 28             	lea    0x28(%ecx),%edx
80104dae:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104db0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104db6:	83 c0 04             	add    $0x4,%eax
80104db9:	39 d0                	cmp    %edx,%eax
80104dbb:	75 f3                	jne    80104db0 <getcallerpcs+0x40>
}
80104dbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc0:	c9                   	leave  
80104dc1:	c3                   	ret    
80104dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104dd0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	53                   	push   %ebx
80104dd4:	83 ec 04             	sub    $0x4,%esp
80104dd7:	9c                   	pushf  
80104dd8:	5b                   	pop    %ebx
  asm volatile("cli");
80104dd9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104dda:	e8 a1 eb ff ff       	call   80103980 <mycpu>
80104ddf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104de5:	85 c0                	test   %eax,%eax
80104de7:	74 17                	je     80104e00 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104de9:	e8 92 eb ff ff       	call   80103980 <mycpu>
80104dee:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104df5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104df8:	c9                   	leave  
80104df9:	c3                   	ret    
80104dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104e00:	e8 7b eb ff ff       	call   80103980 <mycpu>
80104e05:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104e0b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104e11:	eb d6                	jmp    80104de9 <pushcli+0x19>
80104e13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e20 <popcli>:

void
popcli(void)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e26:	9c                   	pushf  
80104e27:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104e28:	f6 c4 02             	test   $0x2,%ah
80104e2b:	75 35                	jne    80104e62 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104e2d:	e8 4e eb ff ff       	call   80103980 <mycpu>
80104e32:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104e39:	78 34                	js     80104e6f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e3b:	e8 40 eb ff ff       	call   80103980 <mycpu>
80104e40:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104e46:	85 d2                	test   %edx,%edx
80104e48:	74 06                	je     80104e50 <popcli+0x30>
    sti();
}
80104e4a:	c9                   	leave  
80104e4b:	c3                   	ret    
80104e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e50:	e8 2b eb ff ff       	call   80103980 <mycpu>
80104e55:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104e5b:	85 c0                	test   %eax,%eax
80104e5d:	74 eb                	je     80104e4a <popcli+0x2a>
  asm volatile("sti");
80104e5f:	fb                   	sti    
}
80104e60:	c9                   	leave  
80104e61:	c3                   	ret    
    panic("popcli - interruptible");
80104e62:	83 ec 0c             	sub    $0xc,%esp
80104e65:	68 8b 88 10 80       	push   $0x8010888b
80104e6a:	e8 11 b5 ff ff       	call   80100380 <panic>
    panic("popcli");
80104e6f:	83 ec 0c             	sub    $0xc,%esp
80104e72:	68 a2 88 10 80       	push   $0x801088a2
80104e77:	e8 04 b5 ff ff       	call   80100380 <panic>
80104e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e80 <holding>:
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	53                   	push   %ebx
80104e85:	8b 75 08             	mov    0x8(%ebp),%esi
80104e88:	31 db                	xor    %ebx,%ebx
  pushcli();
80104e8a:	e8 41 ff ff ff       	call   80104dd0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e8f:	8b 06                	mov    (%esi),%eax
80104e91:	85 c0                	test   %eax,%eax
80104e93:	75 0b                	jne    80104ea0 <holding+0x20>
  popcli();
80104e95:	e8 86 ff ff ff       	call   80104e20 <popcli>
}
80104e9a:	89 d8                	mov    %ebx,%eax
80104e9c:	5b                   	pop    %ebx
80104e9d:	5e                   	pop    %esi
80104e9e:	5d                   	pop    %ebp
80104e9f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104ea0:	8b 5e 08             	mov    0x8(%esi),%ebx
80104ea3:	e8 d8 ea ff ff       	call   80103980 <mycpu>
80104ea8:	39 c3                	cmp    %eax,%ebx
80104eaa:	0f 94 c3             	sete   %bl
  popcli();
80104ead:	e8 6e ff ff ff       	call   80104e20 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104eb2:	0f b6 db             	movzbl %bl,%ebx
}
80104eb5:	89 d8                	mov    %ebx,%eax
80104eb7:	5b                   	pop    %ebx
80104eb8:	5e                   	pop    %esi
80104eb9:	5d                   	pop    %ebp
80104eba:	c3                   	ret    
80104ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ebf:	90                   	nop

80104ec0 <release>:
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	56                   	push   %esi
80104ec4:	53                   	push   %ebx
80104ec5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104ec8:	e8 03 ff ff ff       	call   80104dd0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104ecd:	8b 03                	mov    (%ebx),%eax
80104ecf:	85 c0                	test   %eax,%eax
80104ed1:	75 15                	jne    80104ee8 <release+0x28>
  popcli();
80104ed3:	e8 48 ff ff ff       	call   80104e20 <popcli>
    panic("release");
80104ed8:	83 ec 0c             	sub    $0xc,%esp
80104edb:	68 a9 88 10 80       	push   $0x801088a9
80104ee0:	e8 9b b4 ff ff       	call   80100380 <panic>
80104ee5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ee8:	8b 73 08             	mov    0x8(%ebx),%esi
80104eeb:	e8 90 ea ff ff       	call   80103980 <mycpu>
80104ef0:	39 c6                	cmp    %eax,%esi
80104ef2:	75 df                	jne    80104ed3 <release+0x13>
  popcli();
80104ef4:	e8 27 ff ff ff       	call   80104e20 <popcli>
  lk->pcs[0] = 0;
80104ef9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104f00:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104f07:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104f0c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104f12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f15:	5b                   	pop    %ebx
80104f16:	5e                   	pop    %esi
80104f17:	5d                   	pop    %ebp
  popcli();
80104f18:	e9 03 ff ff ff       	jmp    80104e20 <popcli>
80104f1d:	8d 76 00             	lea    0x0(%esi),%esi

80104f20 <acquire>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	53                   	push   %ebx
80104f24:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104f27:	e8 a4 fe ff ff       	call   80104dd0 <pushcli>
  if(holding(lk))
80104f2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104f2f:	e8 9c fe ff ff       	call   80104dd0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104f34:	8b 03                	mov    (%ebx),%eax
80104f36:	85 c0                	test   %eax,%eax
80104f38:	75 7e                	jne    80104fb8 <acquire+0x98>
  popcli();
80104f3a:	e8 e1 fe ff ff       	call   80104e20 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104f3f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104f48:	8b 55 08             	mov    0x8(%ebp),%edx
80104f4b:	89 c8                	mov    %ecx,%eax
80104f4d:	f0 87 02             	lock xchg %eax,(%edx)
80104f50:	85 c0                	test   %eax,%eax
80104f52:	75 f4                	jne    80104f48 <acquire+0x28>
  __sync_synchronize();
80104f54:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f5c:	e8 1f ea ff ff       	call   80103980 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104f61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104f64:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104f66:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104f69:	31 c0                	xor    %eax,%eax
80104f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f6f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f70:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104f76:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104f7c:	77 1a                	ja     80104f98 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104f7e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104f81:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104f85:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104f88:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104f8a:	83 f8 0a             	cmp    $0xa,%eax
80104f8d:	75 e1                	jne    80104f70 <acquire+0x50>
}
80104f8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f92:	c9                   	leave  
80104f93:	c3                   	ret    
80104f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104f98:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104f9c:	8d 51 34             	lea    0x34(%ecx),%edx
80104f9f:	90                   	nop
    pcs[i] = 0;
80104fa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104fa6:	83 c0 04             	add    $0x4,%eax
80104fa9:	39 c2                	cmp    %eax,%edx
80104fab:	75 f3                	jne    80104fa0 <acquire+0x80>
}
80104fad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fb0:	c9                   	leave  
80104fb1:	c3                   	ret    
80104fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104fb8:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104fbb:	e8 c0 e9 ff ff       	call   80103980 <mycpu>
80104fc0:	39 c3                	cmp    %eax,%ebx
80104fc2:	0f 85 72 ff ff ff    	jne    80104f3a <acquire+0x1a>
  popcli();
80104fc8:	e8 53 fe ff ff       	call   80104e20 <popcli>
    panic("acquire");
80104fcd:	83 ec 0c             	sub    $0xc,%esp
80104fd0:	68 b1 88 10 80       	push   $0x801088b1
80104fd5:	e8 a6 b3 ff ff       	call   80100380 <panic>
80104fda:	66 90                	xchg   %ax,%ax
80104fdc:	66 90                	xchg   %ax,%ax
80104fde:	66 90                	xchg   %ax,%ax

80104fe0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	57                   	push   %edi
80104fe4:	8b 55 08             	mov    0x8(%ebp),%edx
80104fe7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104fea:	53                   	push   %ebx
80104feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104fee:	89 d7                	mov    %edx,%edi
80104ff0:	09 cf                	or     %ecx,%edi
80104ff2:	83 e7 03             	and    $0x3,%edi
80104ff5:	75 29                	jne    80105020 <memset+0x40>
    c &= 0xFF;
80104ff7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104ffa:	c1 e0 18             	shl    $0x18,%eax
80104ffd:	89 fb                	mov    %edi,%ebx
80104fff:	c1 e9 02             	shr    $0x2,%ecx
80105002:	c1 e3 10             	shl    $0x10,%ebx
80105005:	09 d8                	or     %ebx,%eax
80105007:	09 f8                	or     %edi,%eax
80105009:	c1 e7 08             	shl    $0x8,%edi
8010500c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010500e:	89 d7                	mov    %edx,%edi
80105010:	fc                   	cld    
80105011:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105013:	5b                   	pop    %ebx
80105014:	89 d0                	mov    %edx,%eax
80105016:	5f                   	pop    %edi
80105017:	5d                   	pop    %ebp
80105018:	c3                   	ret    
80105019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80105020:	89 d7                	mov    %edx,%edi
80105022:	fc                   	cld    
80105023:	f3 aa                	rep stos %al,%es:(%edi)
80105025:	5b                   	pop    %ebx
80105026:	89 d0                	mov    %edx,%eax
80105028:	5f                   	pop    %edi
80105029:	5d                   	pop    %ebp
8010502a:	c3                   	ret    
8010502b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010502f:	90                   	nop

80105030 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	56                   	push   %esi
80105034:	8b 75 10             	mov    0x10(%ebp),%esi
80105037:	8b 55 08             	mov    0x8(%ebp),%edx
8010503a:	53                   	push   %ebx
8010503b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010503e:	85 f6                	test   %esi,%esi
80105040:	74 2e                	je     80105070 <memcmp+0x40>
80105042:	01 c6                	add    %eax,%esi
80105044:	eb 14                	jmp    8010505a <memcmp+0x2a>
80105046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010504d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105050:	83 c0 01             	add    $0x1,%eax
80105053:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105056:	39 f0                	cmp    %esi,%eax
80105058:	74 16                	je     80105070 <memcmp+0x40>
    if(*s1 != *s2)
8010505a:	0f b6 0a             	movzbl (%edx),%ecx
8010505d:	0f b6 18             	movzbl (%eax),%ebx
80105060:	38 d9                	cmp    %bl,%cl
80105062:	74 ec                	je     80105050 <memcmp+0x20>
      return *s1 - *s2;
80105064:	0f b6 c1             	movzbl %cl,%eax
80105067:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105069:	5b                   	pop    %ebx
8010506a:	5e                   	pop    %esi
8010506b:	5d                   	pop    %ebp
8010506c:	c3                   	ret    
8010506d:	8d 76 00             	lea    0x0(%esi),%esi
80105070:	5b                   	pop    %ebx
  return 0;
80105071:	31 c0                	xor    %eax,%eax
}
80105073:	5e                   	pop    %esi
80105074:	5d                   	pop    %ebp
80105075:	c3                   	ret    
80105076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507d:	8d 76 00             	lea    0x0(%esi),%esi

80105080 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	57                   	push   %edi
80105084:	8b 55 08             	mov    0x8(%ebp),%edx
80105087:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010508a:	56                   	push   %esi
8010508b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010508e:	39 d6                	cmp    %edx,%esi
80105090:	73 26                	jae    801050b8 <memmove+0x38>
80105092:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105095:	39 fa                	cmp    %edi,%edx
80105097:	73 1f                	jae    801050b8 <memmove+0x38>
80105099:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010509c:	85 c9                	test   %ecx,%ecx
8010509e:	74 0c                	je     801050ac <memmove+0x2c>
      *--d = *--s;
801050a0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801050a4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801050a7:	83 e8 01             	sub    $0x1,%eax
801050aa:	73 f4                	jae    801050a0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801050ac:	5e                   	pop    %esi
801050ad:	89 d0                	mov    %edx,%eax
801050af:	5f                   	pop    %edi
801050b0:	5d                   	pop    %ebp
801050b1:	c3                   	ret    
801050b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801050b8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801050bb:	89 d7                	mov    %edx,%edi
801050bd:	85 c9                	test   %ecx,%ecx
801050bf:	74 eb                	je     801050ac <memmove+0x2c>
801050c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801050c8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801050c9:	39 c6                	cmp    %eax,%esi
801050cb:	75 fb                	jne    801050c8 <memmove+0x48>
}
801050cd:	5e                   	pop    %esi
801050ce:	89 d0                	mov    %edx,%eax
801050d0:	5f                   	pop    %edi
801050d1:	5d                   	pop    %ebp
801050d2:	c3                   	ret    
801050d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801050e0:	eb 9e                	jmp    80105080 <memmove>
801050e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801050f0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	56                   	push   %esi
801050f4:	8b 75 10             	mov    0x10(%ebp),%esi
801050f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801050fa:	53                   	push   %ebx
801050fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801050fe:	85 f6                	test   %esi,%esi
80105100:	74 2e                	je     80105130 <strncmp+0x40>
80105102:	01 d6                	add    %edx,%esi
80105104:	eb 18                	jmp    8010511e <strncmp+0x2e>
80105106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010510d:	8d 76 00             	lea    0x0(%esi),%esi
80105110:	38 d8                	cmp    %bl,%al
80105112:	75 14                	jne    80105128 <strncmp+0x38>
    n--, p++, q++;
80105114:	83 c2 01             	add    $0x1,%edx
80105117:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010511a:	39 f2                	cmp    %esi,%edx
8010511c:	74 12                	je     80105130 <strncmp+0x40>
8010511e:	0f b6 01             	movzbl (%ecx),%eax
80105121:	0f b6 1a             	movzbl (%edx),%ebx
80105124:	84 c0                	test   %al,%al
80105126:	75 e8                	jne    80105110 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105128:	29 d8                	sub    %ebx,%eax
}
8010512a:	5b                   	pop    %ebx
8010512b:	5e                   	pop    %esi
8010512c:	5d                   	pop    %ebp
8010512d:	c3                   	ret    
8010512e:	66 90                	xchg   %ax,%ax
80105130:	5b                   	pop    %ebx
    return 0;
80105131:	31 c0                	xor    %eax,%eax
}
80105133:	5e                   	pop    %esi
80105134:	5d                   	pop    %ebp
80105135:	c3                   	ret    
80105136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010513d:	8d 76 00             	lea    0x0(%esi),%esi

80105140 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	57                   	push   %edi
80105144:	56                   	push   %esi
80105145:	8b 75 08             	mov    0x8(%ebp),%esi
80105148:	53                   	push   %ebx
80105149:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010514c:	89 f0                	mov    %esi,%eax
8010514e:	eb 15                	jmp    80105165 <strncpy+0x25>
80105150:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105154:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105157:	83 c0 01             	add    $0x1,%eax
8010515a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010515e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105161:	84 d2                	test   %dl,%dl
80105163:	74 09                	je     8010516e <strncpy+0x2e>
80105165:	89 cb                	mov    %ecx,%ebx
80105167:	83 e9 01             	sub    $0x1,%ecx
8010516a:	85 db                	test   %ebx,%ebx
8010516c:	7f e2                	jg     80105150 <strncpy+0x10>
    ;
  while(n-- > 0)
8010516e:	89 c2                	mov    %eax,%edx
80105170:	85 c9                	test   %ecx,%ecx
80105172:	7e 17                	jle    8010518b <strncpy+0x4b>
80105174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105178:	83 c2 01             	add    $0x1,%edx
8010517b:	89 c1                	mov    %eax,%ecx
8010517d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105181:	29 d1                	sub    %edx,%ecx
80105183:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105187:	85 c9                	test   %ecx,%ecx
80105189:	7f ed                	jg     80105178 <strncpy+0x38>
  return os;
}
8010518b:	5b                   	pop    %ebx
8010518c:	89 f0                	mov    %esi,%eax
8010518e:	5e                   	pop    %esi
8010518f:	5f                   	pop    %edi
80105190:	5d                   	pop    %ebp
80105191:	c3                   	ret    
80105192:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801051a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	56                   	push   %esi
801051a4:	8b 55 10             	mov    0x10(%ebp),%edx
801051a7:	8b 75 08             	mov    0x8(%ebp),%esi
801051aa:	53                   	push   %ebx
801051ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801051ae:	85 d2                	test   %edx,%edx
801051b0:	7e 25                	jle    801051d7 <safestrcpy+0x37>
801051b2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801051b6:	89 f2                	mov    %esi,%edx
801051b8:	eb 16                	jmp    801051d0 <safestrcpy+0x30>
801051ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801051c0:	0f b6 08             	movzbl (%eax),%ecx
801051c3:	83 c0 01             	add    $0x1,%eax
801051c6:	83 c2 01             	add    $0x1,%edx
801051c9:	88 4a ff             	mov    %cl,-0x1(%edx)
801051cc:	84 c9                	test   %cl,%cl
801051ce:	74 04                	je     801051d4 <safestrcpy+0x34>
801051d0:	39 d8                	cmp    %ebx,%eax
801051d2:	75 ec                	jne    801051c0 <safestrcpy+0x20>
    ;
  *s = 0;
801051d4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801051d7:	89 f0                	mov    %esi,%eax
801051d9:	5b                   	pop    %ebx
801051da:	5e                   	pop    %esi
801051db:	5d                   	pop    %ebp
801051dc:	c3                   	ret    
801051dd:	8d 76 00             	lea    0x0(%esi),%esi

801051e0 <strlen>:

int
strlen(const char *s)
{
801051e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801051e1:	31 c0                	xor    %eax,%eax
{
801051e3:	89 e5                	mov    %esp,%ebp
801051e5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801051e8:	80 3a 00             	cmpb   $0x0,(%edx)
801051eb:	74 0c                	je     801051f9 <strlen+0x19>
801051ed:	8d 76 00             	lea    0x0(%esi),%esi
801051f0:	83 c0 01             	add    $0x1,%eax
801051f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801051f7:	75 f7                	jne    801051f0 <strlen+0x10>
    ;
  return n;
}
801051f9:	5d                   	pop    %ebp
801051fa:	c3                   	ret    

801051fb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801051fb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801051ff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105203:	55                   	push   %ebp
  pushl %ebx
80105204:	53                   	push   %ebx
  pushl %esi
80105205:	56                   	push   %esi
  pushl %edi
80105206:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105207:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105209:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010520b:	5f                   	pop    %edi
  popl %esi
8010520c:	5e                   	pop    %esi
  popl %ebx
8010520d:	5b                   	pop    %ebx
  popl %ebp
8010520e:	5d                   	pop    %ebp
  ret
8010520f:	c3                   	ret    

80105210 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	53                   	push   %ebx
80105214:	83 ec 04             	sub    $0x4,%esp
80105217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010521a:	e8 f1 e8 ff ff       	call   80103b10 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010521f:	8b 00                	mov    (%eax),%eax
80105221:	39 d8                	cmp    %ebx,%eax
80105223:	76 1b                	jbe    80105240 <fetchint+0x30>
80105225:	8d 53 04             	lea    0x4(%ebx),%edx
80105228:	39 d0                	cmp    %edx,%eax
8010522a:	72 14                	jb     80105240 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010522c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010522f:	8b 13                	mov    (%ebx),%edx
80105231:	89 10                	mov    %edx,(%eax)
  return 0;
80105233:	31 c0                	xor    %eax,%eax
}
80105235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105238:	c9                   	leave  
80105239:	c3                   	ret    
8010523a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105245:	eb ee                	jmp    80105235 <fetchint+0x25>
80105247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524e:	66 90                	xchg   %ax,%ax

80105250 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	53                   	push   %ebx
80105254:	83 ec 04             	sub    $0x4,%esp
80105257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010525a:	e8 b1 e8 ff ff       	call   80103b10 <myproc>

  if(addr >= curproc->sz)
8010525f:	39 18                	cmp    %ebx,(%eax)
80105261:	76 2d                	jbe    80105290 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105263:	8b 55 0c             	mov    0xc(%ebp),%edx
80105266:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105268:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010526a:	39 d3                	cmp    %edx,%ebx
8010526c:	73 22                	jae    80105290 <fetchstr+0x40>
8010526e:	89 d8                	mov    %ebx,%eax
80105270:	eb 0d                	jmp    8010527f <fetchstr+0x2f>
80105272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105278:	83 c0 01             	add    $0x1,%eax
8010527b:	39 c2                	cmp    %eax,%edx
8010527d:	76 11                	jbe    80105290 <fetchstr+0x40>
    if(*s == 0)
8010527f:	80 38 00             	cmpb   $0x0,(%eax)
80105282:	75 f4                	jne    80105278 <fetchstr+0x28>
      return s - *pp;
80105284:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105286:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105289:	c9                   	leave  
8010528a:	c3                   	ret    
8010528b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010528f:	90                   	nop
80105290:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105293:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105298:	c9                   	leave  
80105299:	c3                   	ret    
8010529a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801052a0 <fetchfloat>:
int
fetchfloat(uint addr, float *fp)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	53                   	push   %ebx
801052a4:	83 ec 04             	sub    $0x4,%esp
801052a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801052aa:	e8 61 e8 ff ff       	call   80103b10 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801052af:	8b 00                	mov    (%eax),%eax
801052b1:	39 d8                	cmp    %ebx,%eax
801052b3:	76 1b                	jbe    801052d0 <fetchfloat+0x30>
801052b5:	8d 53 04             	lea    0x4(%ebx),%edx
801052b8:	39 d0                	cmp    %edx,%eax
801052ba:	72 14                	jb     801052d0 <fetchfloat+0x30>
    return -1;
  *fp = *(float*)(addr);
801052bc:	d9 03                	flds   (%ebx)
801052be:	8b 45 0c             	mov    0xc(%ebp),%eax
801052c1:	d9 18                	fstps  (%eax)
  return 0;
801052c3:	31 c0                	xor    %eax,%eax
}
801052c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052c8:	c9                   	leave  
801052c9:	c3                   	ret    
801052ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052d5:	eb ee                	jmp    801052c5 <fetchfloat+0x25>
801052d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052de:	66 90                	xchg   %ax,%ax

801052e0 <argint>:
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	56                   	push   %esi
801052e4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052e5:	e8 26 e8 ff ff       	call   80103b10 <myproc>
801052ea:	8b 55 08             	mov    0x8(%ebp),%edx
801052ed:	8b 40 18             	mov    0x18(%eax),%eax
801052f0:	8b 40 44             	mov    0x44(%eax),%eax
801052f3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801052f6:	e8 15 e8 ff ff       	call   80103b10 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052fb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801052fe:	8b 00                	mov    (%eax),%eax
80105300:	39 c6                	cmp    %eax,%esi
80105302:	73 1c                	jae    80105320 <argint+0x40>
80105304:	8d 53 08             	lea    0x8(%ebx),%edx
80105307:	39 d0                	cmp    %edx,%eax
80105309:	72 15                	jb     80105320 <argint+0x40>
  *ip = *(int*)(addr);
8010530b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010530e:	8b 53 04             	mov    0x4(%ebx),%edx
80105311:	89 10                	mov    %edx,(%eax)
  return 0;
80105313:	31 c0                	xor    %eax,%eax
}
80105315:	5b                   	pop    %ebx
80105316:	5e                   	pop    %esi
80105317:	5d                   	pop    %ebp
80105318:	c3                   	ret    
80105319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105325:	eb ee                	jmp    80105315 <argint+0x35>
80105327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532e:	66 90                	xchg   %ax,%ax

80105330 <argf>:
int
argf(int n, float *fp)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	56                   	push   %esi
80105334:	53                   	push   %ebx
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105335:	e8 d6 e7 ff ff       	call   80103b10 <myproc>
8010533a:	8b 55 08             	mov    0x8(%ebp),%edx
8010533d:	8b 40 18             	mov    0x18(%eax),%eax
80105340:	8b 40 44             	mov    0x44(%eax),%eax
80105343:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105346:	e8 c5 e7 ff ff       	call   80103b10 <myproc>
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
8010534b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010534e:	8b 00                	mov    (%eax),%eax
80105350:	39 c6                	cmp    %eax,%esi
80105352:	73 1c                	jae    80105370 <argf+0x40>
80105354:	8d 53 08             	lea    0x8(%ebx),%edx
80105357:	39 d0                	cmp    %edx,%eax
80105359:	72 15                	jb     80105370 <argf+0x40>
  *fp = *(float*)(addr);
8010535b:	d9 43 04             	flds   0x4(%ebx)
8010535e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105361:	d9 18                	fstps  (%eax)
  return 0;
80105363:	31 c0                	xor    %eax,%eax
}
80105365:	5b                   	pop    %ebx
80105366:	5e                   	pop    %esi
80105367:	5d                   	pop    %ebp
80105368:	c3                   	ret    
80105369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105375:	eb ee                	jmp    80105365 <argf+0x35>
80105377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010537e:	66 90                	xchg   %ax,%ax

80105380 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	57                   	push   %edi
80105384:	56                   	push   %esi
80105385:	53                   	push   %ebx
80105386:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105389:	e8 82 e7 ff ff       	call   80103b10 <myproc>
8010538e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105390:	e8 7b e7 ff ff       	call   80103b10 <myproc>
80105395:	8b 55 08             	mov    0x8(%ebp),%edx
80105398:	8b 40 18             	mov    0x18(%eax),%eax
8010539b:	8b 40 44             	mov    0x44(%eax),%eax
8010539e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801053a1:	e8 6a e7 ff ff       	call   80103b10 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053a6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801053a9:	8b 00                	mov    (%eax),%eax
801053ab:	39 c7                	cmp    %eax,%edi
801053ad:	73 31                	jae    801053e0 <argptr+0x60>
801053af:	8d 4b 08             	lea    0x8(%ebx),%ecx
801053b2:	39 c8                	cmp    %ecx,%eax
801053b4:	72 2a                	jb     801053e0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801053b6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801053b9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801053bc:	85 d2                	test   %edx,%edx
801053be:	78 20                	js     801053e0 <argptr+0x60>
801053c0:	8b 16                	mov    (%esi),%edx
801053c2:	39 c2                	cmp    %eax,%edx
801053c4:	76 1a                	jbe    801053e0 <argptr+0x60>
801053c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801053c9:	01 c3                	add    %eax,%ebx
801053cb:	39 da                	cmp    %ebx,%edx
801053cd:	72 11                	jb     801053e0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801053cf:	8b 55 0c             	mov    0xc(%ebp),%edx
801053d2:	89 02                	mov    %eax,(%edx)
  return 0;
801053d4:	31 c0                	xor    %eax,%eax
}
801053d6:	83 c4 0c             	add    $0xc,%esp
801053d9:	5b                   	pop    %ebx
801053da:	5e                   	pop    %esi
801053db:	5f                   	pop    %edi
801053dc:	5d                   	pop    %ebp
801053dd:	c3                   	ret    
801053de:	66 90                	xchg   %ax,%ax
    return -1;
801053e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e5:	eb ef                	jmp    801053d6 <argptr+0x56>
801053e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ee:	66 90                	xchg   %ax,%ax

801053f0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	56                   	push   %esi
801053f4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053f5:	e8 16 e7 ff ff       	call   80103b10 <myproc>
801053fa:	8b 55 08             	mov    0x8(%ebp),%edx
801053fd:	8b 40 18             	mov    0x18(%eax),%eax
80105400:	8b 40 44             	mov    0x44(%eax),%eax
80105403:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105406:	e8 05 e7 ff ff       	call   80103b10 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010540b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010540e:	8b 00                	mov    (%eax),%eax
80105410:	39 c6                	cmp    %eax,%esi
80105412:	73 44                	jae    80105458 <argstr+0x68>
80105414:	8d 53 08             	lea    0x8(%ebx),%edx
80105417:	39 d0                	cmp    %edx,%eax
80105419:	72 3d                	jb     80105458 <argstr+0x68>
  *ip = *(int*)(addr);
8010541b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010541e:	e8 ed e6 ff ff       	call   80103b10 <myproc>
  if(addr >= curproc->sz)
80105423:	3b 18                	cmp    (%eax),%ebx
80105425:	73 31                	jae    80105458 <argstr+0x68>
  *pp = (char*)addr;
80105427:	8b 55 0c             	mov    0xc(%ebp),%edx
8010542a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010542c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010542e:	39 d3                	cmp    %edx,%ebx
80105430:	73 26                	jae    80105458 <argstr+0x68>
80105432:	89 d8                	mov    %ebx,%eax
80105434:	eb 11                	jmp    80105447 <argstr+0x57>
80105436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010543d:	8d 76 00             	lea    0x0(%esi),%esi
80105440:	83 c0 01             	add    $0x1,%eax
80105443:	39 c2                	cmp    %eax,%edx
80105445:	76 11                	jbe    80105458 <argstr+0x68>
    if(*s == 0)
80105447:	80 38 00             	cmpb   $0x0,(%eax)
8010544a:	75 f4                	jne    80105440 <argstr+0x50>
      return s - *pp;
8010544c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010544e:	5b                   	pop    %ebx
8010544f:	5e                   	pop    %esi
80105450:	5d                   	pop    %ebp
80105451:	c3                   	ret    
80105452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105458:	5b                   	pop    %ebx
    return -1;
80105459:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010545e:	5e                   	pop    %esi
8010545f:	5d                   	pop    %ebp
80105460:	c3                   	ret    
80105461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105468:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010546f:	90                   	nop

80105470 <syscall>:
[SYS_print_info] sys_print_info
};

void
syscall(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	53                   	push   %ebx
80105474:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105477:	e8 94 e6 ff ff       	call   80103b10 <myproc>
8010547c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010547e:	8b 40 18             	mov    0x18(%eax),%eax
80105481:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105484:	8d 50 ff             	lea    -0x1(%eax),%edx
80105487:	83 fa 1f             	cmp    $0x1f,%edx
8010548a:	77 24                	ja     801054b0 <syscall+0x40>
8010548c:	8b 14 85 e0 88 10 80 	mov    -0x7fef7720(,%eax,4),%edx
80105493:	85 d2                	test   %edx,%edx
80105495:	74 19                	je     801054b0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105497:	ff d2                	call   *%edx
80105499:	89 c2                	mov    %eax,%edx
8010549b:	8b 43 18             	mov    0x18(%ebx),%eax
8010549e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801054a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054a4:	c9                   	leave  
801054a5:	c3                   	ret    
801054a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ad:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801054b0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801054b1:	8d 43 78             	lea    0x78(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801054b4:	50                   	push   %eax
801054b5:	ff 73 10             	push   0x10(%ebx)
801054b8:	68 b9 88 10 80       	push   $0x801088b9
801054bd:	e8 de b1 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
801054c2:	8b 43 18             	mov    0x18(%ebx),%eax
801054c5:	83 c4 10             	add    $0x10,%esp
801054c8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801054cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054d2:	c9                   	leave  
801054d3:	c3                   	ret    
801054d4:	66 90                	xchg   %ax,%ax
801054d6:	66 90                	xchg   %ax,%ax
801054d8:	66 90                	xchg   %ax,%ax
801054da:	66 90                	xchg   %ax,%ax
801054dc:	66 90                	xchg   %ax,%ax
801054de:	66 90                	xchg   %ax,%ax

801054e0 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	57                   	push   %edi
801054e4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
801054e5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801054e8:	53                   	push   %ebx
801054e9:	83 ec 34             	sub    $0x34,%esp
801054ec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801054ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if ((dp = nameiparent(path, name)) == 0)
801054f2:	57                   	push   %edi
801054f3:	50                   	push   %eax
{
801054f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801054f7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if ((dp = nameiparent(path, name)) == 0)
801054fa:	e8 c1 cb ff ff       	call   801020c0 <nameiparent>
801054ff:	83 c4 10             	add    $0x10,%esp
80105502:	85 c0                	test   %eax,%eax
80105504:	0f 84 46 01 00 00    	je     80105650 <create+0x170>
    return 0;
  ilock(dp);
8010550a:	83 ec 0c             	sub    $0xc,%esp
8010550d:	89 c3                	mov    %eax,%ebx
8010550f:	50                   	push   %eax
80105510:	e8 6b c2 ff ff       	call   80101780 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
80105515:	83 c4 0c             	add    $0xc,%esp
80105518:	6a 00                	push   $0x0
8010551a:	57                   	push   %edi
8010551b:	53                   	push   %ebx
8010551c:	e8 bf c7 ff ff       	call   80101ce0 <dirlookup>
80105521:	83 c4 10             	add    $0x10,%esp
80105524:	89 c6                	mov    %eax,%esi
80105526:	85 c0                	test   %eax,%eax
80105528:	74 56                	je     80105580 <create+0xa0>
  {
    iunlockput(dp);
8010552a:	83 ec 0c             	sub    $0xc,%esp
8010552d:	53                   	push   %ebx
8010552e:	e8 dd c4 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80105533:	89 34 24             	mov    %esi,(%esp)
80105536:	e8 45 c2 ff ff       	call   80101780 <ilock>
    if (type == T_FILE && ip->type == T_FILE)
8010553b:	83 c4 10             	add    $0x10,%esp
8010553e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105543:	75 1b                	jne    80105560 <create+0x80>
80105545:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010554a:	75 14                	jne    80105560 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010554c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010554f:	89 f0                	mov    %esi,%eax
80105551:	5b                   	pop    %ebx
80105552:	5e                   	pop    %esi
80105553:	5f                   	pop    %edi
80105554:	5d                   	pop    %ebp
80105555:	c3                   	ret    
80105556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010555d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105560:	83 ec 0c             	sub    $0xc,%esp
80105563:	56                   	push   %esi
    return 0;
80105564:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105566:	e8 a5 c4 ff ff       	call   80101a10 <iunlockput>
    return 0;
8010556b:	83 c4 10             	add    $0x10,%esp
}
8010556e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105571:	89 f0                	mov    %esi,%eax
80105573:	5b                   	pop    %ebx
80105574:	5e                   	pop    %esi
80105575:	5f                   	pop    %edi
80105576:	5d                   	pop    %ebp
80105577:	c3                   	ret    
80105578:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010557f:	90                   	nop
  if ((ip = ialloc(dp->dev, type)) == 0)
80105580:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105584:	83 ec 08             	sub    $0x8,%esp
80105587:	50                   	push   %eax
80105588:	ff 33                	push   (%ebx)
8010558a:	e8 81 c0 ff ff       	call   80101610 <ialloc>
8010558f:	83 c4 10             	add    $0x10,%esp
80105592:	89 c6                	mov    %eax,%esi
80105594:	85 c0                	test   %eax,%eax
80105596:	0f 84 cd 00 00 00    	je     80105669 <create+0x189>
  ilock(ip);
8010559c:	83 ec 0c             	sub    $0xc,%esp
8010559f:	50                   	push   %eax
801055a0:	e8 db c1 ff ff       	call   80101780 <ilock>
  ip->major = major;
801055a5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801055a9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801055ad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801055b1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801055b5:	b8 01 00 00 00       	mov    $0x1,%eax
801055ba:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801055be:	89 34 24             	mov    %esi,(%esp)
801055c1:	e8 0a c1 ff ff       	call   801016d0 <iupdate>
  if (type == T_DIR)
801055c6:	83 c4 10             	add    $0x10,%esp
801055c9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801055ce:	74 30                	je     80105600 <create+0x120>
  if (dirlink(dp, name, ip->inum) < 0)
801055d0:	83 ec 04             	sub    $0x4,%esp
801055d3:	ff 76 04             	push   0x4(%esi)
801055d6:	57                   	push   %edi
801055d7:	53                   	push   %ebx
801055d8:	e8 03 ca ff ff       	call   80101fe0 <dirlink>
801055dd:	83 c4 10             	add    $0x10,%esp
801055e0:	85 c0                	test   %eax,%eax
801055e2:	78 78                	js     8010565c <create+0x17c>
  iunlockput(dp);
801055e4:	83 ec 0c             	sub    $0xc,%esp
801055e7:	53                   	push   %ebx
801055e8:	e8 23 c4 ff ff       	call   80101a10 <iunlockput>
  return ip;
801055ed:	83 c4 10             	add    $0x10,%esp
}
801055f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055f3:	89 f0                	mov    %esi,%eax
801055f5:	5b                   	pop    %ebx
801055f6:	5e                   	pop    %esi
801055f7:	5f                   	pop    %edi
801055f8:	5d                   	pop    %ebp
801055f9:	c3                   	ret    
801055fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105600:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++; // for ".."
80105603:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105608:	53                   	push   %ebx
80105609:	e8 c2 c0 ff ff       	call   801016d0 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010560e:	83 c4 0c             	add    $0xc,%esp
80105611:	ff 76 04             	push   0x4(%esi)
80105614:	68 80 89 10 80       	push   $0x80108980
80105619:	56                   	push   %esi
8010561a:	e8 c1 c9 ff ff       	call   80101fe0 <dirlink>
8010561f:	83 c4 10             	add    $0x10,%esp
80105622:	85 c0                	test   %eax,%eax
80105624:	78 18                	js     8010563e <create+0x15e>
80105626:	83 ec 04             	sub    $0x4,%esp
80105629:	ff 73 04             	push   0x4(%ebx)
8010562c:	68 7f 89 10 80       	push   $0x8010897f
80105631:	56                   	push   %esi
80105632:	e8 a9 c9 ff ff       	call   80101fe0 <dirlink>
80105637:	83 c4 10             	add    $0x10,%esp
8010563a:	85 c0                	test   %eax,%eax
8010563c:	79 92                	jns    801055d0 <create+0xf0>
      panic("create dots");
8010563e:	83 ec 0c             	sub    $0xc,%esp
80105641:	68 73 89 10 80       	push   $0x80108973
80105646:	e8 35 ad ff ff       	call   80100380 <panic>
8010564b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010564f:	90                   	nop
}
80105650:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105653:	31 f6                	xor    %esi,%esi
}
80105655:	5b                   	pop    %ebx
80105656:	89 f0                	mov    %esi,%eax
80105658:	5e                   	pop    %esi
80105659:	5f                   	pop    %edi
8010565a:	5d                   	pop    %ebp
8010565b:	c3                   	ret    
    panic("create: dirlink");
8010565c:	83 ec 0c             	sub    $0xc,%esp
8010565f:	68 82 89 10 80       	push   $0x80108982
80105664:	e8 17 ad ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105669:	83 ec 0c             	sub    $0xc,%esp
8010566c:	68 64 89 10 80       	push   $0x80108964
80105671:	e8 0a ad ff ff       	call   80100380 <panic>
80105676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010567d:	8d 76 00             	lea    0x0(%esi),%esi

80105680 <sys_dup>:
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	56                   	push   %esi
80105684:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105685:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105688:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010568b:	50                   	push   %eax
8010568c:	6a 00                	push   $0x0
8010568e:	e8 4d fc ff ff       	call   801052e0 <argint>
80105693:	83 c4 10             	add    $0x10,%esp
80105696:	85 c0                	test   %eax,%eax
80105698:	78 36                	js     801056d0 <sys_dup+0x50>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010569a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010569e:	77 30                	ja     801056d0 <sys_dup+0x50>
801056a0:	e8 6b e4 ff ff       	call   80103b10 <myproc>
801056a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056a8:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
801056ac:	85 f6                	test   %esi,%esi
801056ae:	74 20                	je     801056d0 <sys_dup+0x50>
  struct proc *curproc = myproc();
801056b0:	e8 5b e4 ff ff       	call   80103b10 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
801056b5:	31 db                	xor    %ebx,%ebx
801056b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056be:	66 90                	xchg   %ax,%ax
    if (curproc->ofile[fd] == 0)
801056c0:	8b 54 98 34          	mov    0x34(%eax,%ebx,4),%edx
801056c4:	85 d2                	test   %edx,%edx
801056c6:	74 18                	je     801056e0 <sys_dup+0x60>
  for (fd = 0; fd < NOFILE; fd++)
801056c8:	83 c3 01             	add    $0x1,%ebx
801056cb:	83 fb 10             	cmp    $0x10,%ebx
801056ce:	75 f0                	jne    801056c0 <sys_dup+0x40>
}
801056d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801056d3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801056d8:	89 d8                	mov    %ebx,%eax
801056da:	5b                   	pop    %ebx
801056db:	5e                   	pop    %esi
801056dc:	5d                   	pop    %ebp
801056dd:	c3                   	ret    
801056de:	66 90                	xchg   %ax,%ax
  filedup(f);
801056e0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801056e3:	89 74 98 34          	mov    %esi,0x34(%eax,%ebx,4)
  filedup(f);
801056e7:	56                   	push   %esi
801056e8:	e8 b3 b7 ff ff       	call   80100ea0 <filedup>
  return fd;
801056ed:	83 c4 10             	add    $0x10,%esp
}
801056f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056f3:	89 d8                	mov    %ebx,%eax
801056f5:	5b                   	pop    %ebx
801056f6:	5e                   	pop    %esi
801056f7:	5d                   	pop    %ebp
801056f8:	c3                   	ret    
801056f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_read>:
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	56                   	push   %esi
80105704:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105705:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105708:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010570b:	53                   	push   %ebx
8010570c:	6a 00                	push   $0x0
8010570e:	e8 cd fb ff ff       	call   801052e0 <argint>
80105713:	83 c4 10             	add    $0x10,%esp
80105716:	85 c0                	test   %eax,%eax
80105718:	78 5e                	js     80105778 <sys_read+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010571a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010571e:	77 58                	ja     80105778 <sys_read+0x78>
80105720:	e8 eb e3 ff ff       	call   80103b10 <myproc>
80105725:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105728:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
8010572c:	85 f6                	test   %esi,%esi
8010572e:	74 48                	je     80105778 <sys_read+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105730:	83 ec 08             	sub    $0x8,%esp
80105733:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105736:	50                   	push   %eax
80105737:	6a 02                	push   $0x2
80105739:	e8 a2 fb ff ff       	call   801052e0 <argint>
8010573e:	83 c4 10             	add    $0x10,%esp
80105741:	85 c0                	test   %eax,%eax
80105743:	78 33                	js     80105778 <sys_read+0x78>
80105745:	83 ec 04             	sub    $0x4,%esp
80105748:	ff 75 f0             	push   -0x10(%ebp)
8010574b:	53                   	push   %ebx
8010574c:	6a 01                	push   $0x1
8010574e:	e8 2d fc ff ff       	call   80105380 <argptr>
80105753:	83 c4 10             	add    $0x10,%esp
80105756:	85 c0                	test   %eax,%eax
80105758:	78 1e                	js     80105778 <sys_read+0x78>
  return fileread(f, p, n);
8010575a:	83 ec 04             	sub    $0x4,%esp
8010575d:	ff 75 f0             	push   -0x10(%ebp)
80105760:	ff 75 f4             	push   -0xc(%ebp)
80105763:	56                   	push   %esi
80105764:	e8 b7 b8 ff ff       	call   80101020 <fileread>
80105769:	83 c4 10             	add    $0x10,%esp
}
8010576c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010576f:	5b                   	pop    %ebx
80105770:	5e                   	pop    %esi
80105771:	5d                   	pop    %ebp
80105772:	c3                   	ret    
80105773:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105777:	90                   	nop
    return -1;
80105778:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577d:	eb ed                	jmp    8010576c <sys_read+0x6c>
8010577f:	90                   	nop

80105780 <sys_write>:
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	56                   	push   %esi
80105784:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105785:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105788:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010578b:	53                   	push   %ebx
8010578c:	6a 00                	push   $0x0
8010578e:	e8 4d fb ff ff       	call   801052e0 <argint>
80105793:	83 c4 10             	add    $0x10,%esp
80105796:	85 c0                	test   %eax,%eax
80105798:	78 5e                	js     801057f8 <sys_write+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010579a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010579e:	77 58                	ja     801057f8 <sys_write+0x78>
801057a0:	e8 6b e3 ff ff       	call   80103b10 <myproc>
801057a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057a8:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
801057ac:	85 f6                	test   %esi,%esi
801057ae:	74 48                	je     801057f8 <sys_write+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057b0:	83 ec 08             	sub    $0x8,%esp
801057b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057b6:	50                   	push   %eax
801057b7:	6a 02                	push   $0x2
801057b9:	e8 22 fb ff ff       	call   801052e0 <argint>
801057be:	83 c4 10             	add    $0x10,%esp
801057c1:	85 c0                	test   %eax,%eax
801057c3:	78 33                	js     801057f8 <sys_write+0x78>
801057c5:	83 ec 04             	sub    $0x4,%esp
801057c8:	ff 75 f0             	push   -0x10(%ebp)
801057cb:	53                   	push   %ebx
801057cc:	6a 01                	push   $0x1
801057ce:	e8 ad fb ff ff       	call   80105380 <argptr>
801057d3:	83 c4 10             	add    $0x10,%esp
801057d6:	85 c0                	test   %eax,%eax
801057d8:	78 1e                	js     801057f8 <sys_write+0x78>
  return filewrite(f, p, n);
801057da:	83 ec 04             	sub    $0x4,%esp
801057dd:	ff 75 f0             	push   -0x10(%ebp)
801057e0:	ff 75 f4             	push   -0xc(%ebp)
801057e3:	56                   	push   %esi
801057e4:	e8 c7 b8 ff ff       	call   801010b0 <filewrite>
801057e9:	83 c4 10             	add    $0x10,%esp
}
801057ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057ef:	5b                   	pop    %ebx
801057f0:	5e                   	pop    %esi
801057f1:	5d                   	pop    %ebp
801057f2:	c3                   	ret    
801057f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057f7:	90                   	nop
    return -1;
801057f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057fd:	eb ed                	jmp    801057ec <sys_write+0x6c>
801057ff:	90                   	nop

80105800 <sys_close>:
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	56                   	push   %esi
80105804:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105805:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105808:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010580b:	50                   	push   %eax
8010580c:	6a 00                	push   $0x0
8010580e:	e8 cd fa ff ff       	call   801052e0 <argint>
80105813:	83 c4 10             	add    $0x10,%esp
80105816:	85 c0                	test   %eax,%eax
80105818:	78 3e                	js     80105858 <sys_close+0x58>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010581a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010581e:	77 38                	ja     80105858 <sys_close+0x58>
80105820:	e8 eb e2 ff ff       	call   80103b10 <myproc>
80105825:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105828:	8d 5a 0c             	lea    0xc(%edx),%ebx
8010582b:	8b 74 98 04          	mov    0x4(%eax,%ebx,4),%esi
8010582f:	85 f6                	test   %esi,%esi
80105831:	74 25                	je     80105858 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105833:	e8 d8 e2 ff ff       	call   80103b10 <myproc>
  fileclose(f);
80105838:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010583b:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
80105842:	00 
  fileclose(f);
80105843:	56                   	push   %esi
80105844:	e8 a7 b6 ff ff       	call   80100ef0 <fileclose>
  return 0;
80105849:	83 c4 10             	add    $0x10,%esp
8010584c:	31 c0                	xor    %eax,%eax
}
8010584e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105851:	5b                   	pop    %ebx
80105852:	5e                   	pop    %esi
80105853:	5d                   	pop    %ebp
80105854:	c3                   	ret    
80105855:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105858:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585d:	eb ef                	jmp    8010584e <sys_close+0x4e>
8010585f:	90                   	nop

80105860 <sys_fstat>:
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	56                   	push   %esi
80105864:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105865:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105868:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010586b:	53                   	push   %ebx
8010586c:	6a 00                	push   $0x0
8010586e:	e8 6d fa ff ff       	call   801052e0 <argint>
80105873:	83 c4 10             	add    $0x10,%esp
80105876:	85 c0                	test   %eax,%eax
80105878:	78 46                	js     801058c0 <sys_fstat+0x60>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010587a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010587e:	77 40                	ja     801058c0 <sys_fstat+0x60>
80105880:	e8 8b e2 ff ff       	call   80103b10 <myproc>
80105885:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105888:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
8010588c:	85 f6                	test   %esi,%esi
8010588e:	74 30                	je     801058c0 <sys_fstat+0x60>
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
80105890:	83 ec 04             	sub    $0x4,%esp
80105893:	6a 14                	push   $0x14
80105895:	53                   	push   %ebx
80105896:	6a 01                	push   $0x1
80105898:	e8 e3 fa ff ff       	call   80105380 <argptr>
8010589d:	83 c4 10             	add    $0x10,%esp
801058a0:	85 c0                	test   %eax,%eax
801058a2:	78 1c                	js     801058c0 <sys_fstat+0x60>
  return filestat(f, st);
801058a4:	83 ec 08             	sub    $0x8,%esp
801058a7:	ff 75 f4             	push   -0xc(%ebp)
801058aa:	56                   	push   %esi
801058ab:	e8 20 b7 ff ff       	call   80100fd0 <filestat>
801058b0:	83 c4 10             	add    $0x10,%esp
}
801058b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058b6:	5b                   	pop    %ebx
801058b7:	5e                   	pop    %esi
801058b8:	5d                   	pop    %ebp
801058b9:	c3                   	ret    
801058ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801058c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c5:	eb ec                	jmp    801058b3 <sys_fstat+0x53>
801058c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ce:	66 90                	xchg   %ax,%ax

801058d0 <sys_link>:
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	57                   	push   %edi
801058d4:	56                   	push   %esi
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
801058d5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801058d8:	53                   	push   %ebx
801058d9:	83 ec 34             	sub    $0x34,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
801058dc:	50                   	push   %eax
801058dd:	6a 00                	push   $0x0
801058df:	e8 0c fb ff ff       	call   801053f0 <argstr>
801058e4:	83 c4 10             	add    $0x10,%esp
801058e7:	85 c0                	test   %eax,%eax
801058e9:	0f 88 fb 00 00 00    	js     801059ea <sys_link+0x11a>
801058ef:	83 ec 08             	sub    $0x8,%esp
801058f2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801058f5:	50                   	push   %eax
801058f6:	6a 01                	push   $0x1
801058f8:	e8 f3 fa ff ff       	call   801053f0 <argstr>
801058fd:	83 c4 10             	add    $0x10,%esp
80105900:	85 c0                	test   %eax,%eax
80105902:	0f 88 e2 00 00 00    	js     801059ea <sys_link+0x11a>
  begin_op();
80105908:	e8 53 d4 ff ff       	call   80102d60 <begin_op>
  if ((ip = namei(old)) == 0)
8010590d:	83 ec 0c             	sub    $0xc,%esp
80105910:	ff 75 d4             	push   -0x2c(%ebp)
80105913:	e8 88 c7 ff ff       	call   801020a0 <namei>
80105918:	83 c4 10             	add    $0x10,%esp
8010591b:	89 c3                	mov    %eax,%ebx
8010591d:	85 c0                	test   %eax,%eax
8010591f:	0f 84 e4 00 00 00    	je     80105a09 <sys_link+0x139>
  ilock(ip);
80105925:	83 ec 0c             	sub    $0xc,%esp
80105928:	50                   	push   %eax
80105929:	e8 52 be ff ff       	call   80101780 <ilock>
  if (ip->type == T_DIR)
8010592e:	83 c4 10             	add    $0x10,%esp
80105931:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105936:	0f 84 b5 00 00 00    	je     801059f1 <sys_link+0x121>
  iupdate(ip);
8010593c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010593f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if ((dp = nameiparent(new, name)) == 0)
80105944:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105947:	53                   	push   %ebx
80105948:	e8 83 bd ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010594d:	89 1c 24             	mov    %ebx,(%esp)
80105950:	e8 0b bf ff ff       	call   80101860 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
80105955:	58                   	pop    %eax
80105956:	5a                   	pop    %edx
80105957:	57                   	push   %edi
80105958:	ff 75 d0             	push   -0x30(%ebp)
8010595b:	e8 60 c7 ff ff       	call   801020c0 <nameiparent>
80105960:	83 c4 10             	add    $0x10,%esp
80105963:	89 c6                	mov    %eax,%esi
80105965:	85 c0                	test   %eax,%eax
80105967:	74 5b                	je     801059c4 <sys_link+0xf4>
  ilock(dp);
80105969:	83 ec 0c             	sub    $0xc,%esp
8010596c:	50                   	push   %eax
8010596d:	e8 0e be ff ff       	call   80101780 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
80105972:	8b 03                	mov    (%ebx),%eax
80105974:	83 c4 10             	add    $0x10,%esp
80105977:	39 06                	cmp    %eax,(%esi)
80105979:	75 3d                	jne    801059b8 <sys_link+0xe8>
8010597b:	83 ec 04             	sub    $0x4,%esp
8010597e:	ff 73 04             	push   0x4(%ebx)
80105981:	57                   	push   %edi
80105982:	56                   	push   %esi
80105983:	e8 58 c6 ff ff       	call   80101fe0 <dirlink>
80105988:	83 c4 10             	add    $0x10,%esp
8010598b:	85 c0                	test   %eax,%eax
8010598d:	78 29                	js     801059b8 <sys_link+0xe8>
  iunlockput(dp);
8010598f:	83 ec 0c             	sub    $0xc,%esp
80105992:	56                   	push   %esi
80105993:	e8 78 c0 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105998:	89 1c 24             	mov    %ebx,(%esp)
8010599b:	e8 10 bf ff ff       	call   801018b0 <iput>
  end_op();
801059a0:	e8 2b d4 ff ff       	call   80102dd0 <end_op>
  return 0;
801059a5:	83 c4 10             	add    $0x10,%esp
801059a8:	31 c0                	xor    %eax,%eax
}
801059aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059ad:	5b                   	pop    %ebx
801059ae:	5e                   	pop    %esi
801059af:	5f                   	pop    %edi
801059b0:	5d                   	pop    %ebp
801059b1:	c3                   	ret    
801059b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801059b8:	83 ec 0c             	sub    $0xc,%esp
801059bb:	56                   	push   %esi
801059bc:	e8 4f c0 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801059c1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801059c4:	83 ec 0c             	sub    $0xc,%esp
801059c7:	53                   	push   %ebx
801059c8:	e8 b3 bd ff ff       	call   80101780 <ilock>
  ip->nlink--;
801059cd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801059d2:	89 1c 24             	mov    %ebx,(%esp)
801059d5:	e8 f6 bc ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801059da:	89 1c 24             	mov    %ebx,(%esp)
801059dd:	e8 2e c0 ff ff       	call   80101a10 <iunlockput>
  end_op();
801059e2:	e8 e9 d3 ff ff       	call   80102dd0 <end_op>
  return -1;
801059e7:	83 c4 10             	add    $0x10,%esp
801059ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ef:	eb b9                	jmp    801059aa <sys_link+0xda>
    iunlockput(ip);
801059f1:	83 ec 0c             	sub    $0xc,%esp
801059f4:	53                   	push   %ebx
801059f5:	e8 16 c0 ff ff       	call   80101a10 <iunlockput>
    end_op();
801059fa:	e8 d1 d3 ff ff       	call   80102dd0 <end_op>
    return -1;
801059ff:	83 c4 10             	add    $0x10,%esp
80105a02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a07:	eb a1                	jmp    801059aa <sys_link+0xda>
    end_op();
80105a09:	e8 c2 d3 ff ff       	call   80102dd0 <end_op>
    return -1;
80105a0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a13:	eb 95                	jmp    801059aa <sys_link+0xda>
80105a15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_unlink>:
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	57                   	push   %edi
80105a24:	56                   	push   %esi
  if (argstr(0, &path) < 0)
80105a25:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105a28:	53                   	push   %ebx
80105a29:	83 ec 54             	sub    $0x54,%esp
  if (argstr(0, &path) < 0)
80105a2c:	50                   	push   %eax
80105a2d:	6a 00                	push   $0x0
80105a2f:	e8 bc f9 ff ff       	call   801053f0 <argstr>
80105a34:	83 c4 10             	add    $0x10,%esp
80105a37:	85 c0                	test   %eax,%eax
80105a39:	0f 88 7a 01 00 00    	js     80105bb9 <sys_unlink+0x199>
  begin_op();
80105a3f:	e8 1c d3 ff ff       	call   80102d60 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
80105a44:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105a47:	83 ec 08             	sub    $0x8,%esp
80105a4a:	53                   	push   %ebx
80105a4b:	ff 75 c0             	push   -0x40(%ebp)
80105a4e:	e8 6d c6 ff ff       	call   801020c0 <nameiparent>
80105a53:	83 c4 10             	add    $0x10,%esp
80105a56:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105a59:	85 c0                	test   %eax,%eax
80105a5b:	0f 84 62 01 00 00    	je     80105bc3 <sys_unlink+0x1a3>
  ilock(dp);
80105a61:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105a64:	83 ec 0c             	sub    $0xc,%esp
80105a67:	57                   	push   %edi
80105a68:	e8 13 bd ff ff       	call   80101780 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105a6d:	58                   	pop    %eax
80105a6e:	5a                   	pop    %edx
80105a6f:	68 80 89 10 80       	push   $0x80108980
80105a74:	53                   	push   %ebx
80105a75:	e8 46 c2 ff ff       	call   80101cc0 <namecmp>
80105a7a:	83 c4 10             	add    $0x10,%esp
80105a7d:	85 c0                	test   %eax,%eax
80105a7f:	0f 84 fb 00 00 00    	je     80105b80 <sys_unlink+0x160>
80105a85:	83 ec 08             	sub    $0x8,%esp
80105a88:	68 7f 89 10 80       	push   $0x8010897f
80105a8d:	53                   	push   %ebx
80105a8e:	e8 2d c2 ff ff       	call   80101cc0 <namecmp>
80105a93:	83 c4 10             	add    $0x10,%esp
80105a96:	85 c0                	test   %eax,%eax
80105a98:	0f 84 e2 00 00 00    	je     80105b80 <sys_unlink+0x160>
  if ((ip = dirlookup(dp, name, &off)) == 0)
80105a9e:	83 ec 04             	sub    $0x4,%esp
80105aa1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105aa4:	50                   	push   %eax
80105aa5:	53                   	push   %ebx
80105aa6:	57                   	push   %edi
80105aa7:	e8 34 c2 ff ff       	call   80101ce0 <dirlookup>
80105aac:	83 c4 10             	add    $0x10,%esp
80105aaf:	89 c3                	mov    %eax,%ebx
80105ab1:	85 c0                	test   %eax,%eax
80105ab3:	0f 84 c7 00 00 00    	je     80105b80 <sys_unlink+0x160>
  ilock(ip);
80105ab9:	83 ec 0c             	sub    $0xc,%esp
80105abc:	50                   	push   %eax
80105abd:	e8 be bc ff ff       	call   80101780 <ilock>
  if (ip->nlink < 1)
80105ac2:	83 c4 10             	add    $0x10,%esp
80105ac5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105aca:	0f 8e 1c 01 00 00    	jle    80105bec <sys_unlink+0x1cc>
  if (ip->type == T_DIR && !isdirempty(ip))
80105ad0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ad5:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105ad8:	74 66                	je     80105b40 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105ada:	83 ec 04             	sub    $0x4,%esp
80105add:	6a 10                	push   $0x10
80105adf:	6a 00                	push   $0x0
80105ae1:	57                   	push   %edi
80105ae2:	e8 f9 f4 ff ff       	call   80104fe0 <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80105ae7:	6a 10                	push   $0x10
80105ae9:	ff 75 c4             	push   -0x3c(%ebp)
80105aec:	57                   	push   %edi
80105aed:	ff 75 b4             	push   -0x4c(%ebp)
80105af0:	e8 9b c0 ff ff       	call   80101b90 <writei>
80105af5:	83 c4 20             	add    $0x20,%esp
80105af8:	83 f8 10             	cmp    $0x10,%eax
80105afb:	0f 85 de 00 00 00    	jne    80105bdf <sys_unlink+0x1bf>
  if (ip->type == T_DIR)
80105b01:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b06:	0f 84 94 00 00 00    	je     80105ba0 <sys_unlink+0x180>
  iunlockput(dp);
80105b0c:	83 ec 0c             	sub    $0xc,%esp
80105b0f:	ff 75 b4             	push   -0x4c(%ebp)
80105b12:	e8 f9 be ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105b17:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105b1c:	89 1c 24             	mov    %ebx,(%esp)
80105b1f:	e8 ac bb ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105b24:	89 1c 24             	mov    %ebx,(%esp)
80105b27:	e8 e4 be ff ff       	call   80101a10 <iunlockput>
  end_op();
80105b2c:	e8 9f d2 ff ff       	call   80102dd0 <end_op>
  return 0;
80105b31:	83 c4 10             	add    $0x10,%esp
80105b34:	31 c0                	xor    %eax,%eax
}
80105b36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b39:	5b                   	pop    %ebx
80105b3a:	5e                   	pop    %esi
80105b3b:	5f                   	pop    %edi
80105b3c:	5d                   	pop    %ebp
80105b3d:	c3                   	ret    
80105b3e:	66 90                	xchg   %ax,%ax
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
80105b40:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105b44:	76 94                	jbe    80105ada <sys_unlink+0xba>
80105b46:	be 20 00 00 00       	mov    $0x20,%esi
80105b4b:	eb 0b                	jmp    80105b58 <sys_unlink+0x138>
80105b4d:	8d 76 00             	lea    0x0(%esi),%esi
80105b50:	83 c6 10             	add    $0x10,%esi
80105b53:	3b 73 58             	cmp    0x58(%ebx),%esi
80105b56:	73 82                	jae    80105ada <sys_unlink+0xba>
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80105b58:	6a 10                	push   $0x10
80105b5a:	56                   	push   %esi
80105b5b:	57                   	push   %edi
80105b5c:	53                   	push   %ebx
80105b5d:	e8 2e bf ff ff       	call   80101a90 <readi>
80105b62:	83 c4 10             	add    $0x10,%esp
80105b65:	83 f8 10             	cmp    $0x10,%eax
80105b68:	75 68                	jne    80105bd2 <sys_unlink+0x1b2>
    if (de.inum != 0)
80105b6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105b6f:	74 df                	je     80105b50 <sys_unlink+0x130>
    iunlockput(ip);
80105b71:	83 ec 0c             	sub    $0xc,%esp
80105b74:	53                   	push   %ebx
80105b75:	e8 96 be ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105b7a:	83 c4 10             	add    $0x10,%esp
80105b7d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105b80:	83 ec 0c             	sub    $0xc,%esp
80105b83:	ff 75 b4             	push   -0x4c(%ebp)
80105b86:	e8 85 be ff ff       	call   80101a10 <iunlockput>
  end_op();
80105b8b:	e8 40 d2 ff ff       	call   80102dd0 <end_op>
  return -1;
80105b90:	83 c4 10             	add    $0x10,%esp
80105b93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b98:	eb 9c                	jmp    80105b36 <sys_unlink+0x116>
80105b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105ba0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105ba3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105ba6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105bab:	50                   	push   %eax
80105bac:	e8 1f bb ff ff       	call   801016d0 <iupdate>
80105bb1:	83 c4 10             	add    $0x10,%esp
80105bb4:	e9 53 ff ff ff       	jmp    80105b0c <sys_unlink+0xec>
    return -1;
80105bb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bbe:	e9 73 ff ff ff       	jmp    80105b36 <sys_unlink+0x116>
    end_op();
80105bc3:	e8 08 d2 ff ff       	call   80102dd0 <end_op>
    return -1;
80105bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bcd:	e9 64 ff ff ff       	jmp    80105b36 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105bd2:	83 ec 0c             	sub    $0xc,%esp
80105bd5:	68 a4 89 10 80       	push   $0x801089a4
80105bda:	e8 a1 a7 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105bdf:	83 ec 0c             	sub    $0xc,%esp
80105be2:	68 b6 89 10 80       	push   $0x801089b6
80105be7:	e8 94 a7 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105bec:	83 ec 0c             	sub    $0xc,%esp
80105bef:	68 92 89 10 80       	push   $0x80108992
80105bf4:	e8 87 a7 ff ff       	call   80100380 <panic>
80105bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c00 <sys_open>:

int sys_open(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	57                   	push   %edi
80105c04:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c05:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105c08:	53                   	push   %ebx
80105c09:	83 ec 24             	sub    $0x24,%esp
  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c0c:	50                   	push   %eax
80105c0d:	6a 00                	push   $0x0
80105c0f:	e8 dc f7 ff ff       	call   801053f0 <argstr>
80105c14:	83 c4 10             	add    $0x10,%esp
80105c17:	85 c0                	test   %eax,%eax
80105c19:	0f 88 8e 00 00 00    	js     80105cad <sys_open+0xad>
80105c1f:	83 ec 08             	sub    $0x8,%esp
80105c22:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c25:	50                   	push   %eax
80105c26:	6a 01                	push   $0x1
80105c28:	e8 b3 f6 ff ff       	call   801052e0 <argint>
80105c2d:	83 c4 10             	add    $0x10,%esp
80105c30:	85 c0                	test   %eax,%eax
80105c32:	78 79                	js     80105cad <sys_open+0xad>
    return -1;

  begin_op();
80105c34:	e8 27 d1 ff ff       	call   80102d60 <begin_op>

  if (omode & O_CREATE)
80105c39:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105c3d:	75 79                	jne    80105cb8 <sys_open+0xb8>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(path)) == 0)
80105c3f:	83 ec 0c             	sub    $0xc,%esp
80105c42:	ff 75 e0             	push   -0x20(%ebp)
80105c45:	e8 56 c4 ff ff       	call   801020a0 <namei>
80105c4a:	83 c4 10             	add    $0x10,%esp
80105c4d:	89 c6                	mov    %eax,%esi
80105c4f:	85 c0                	test   %eax,%eax
80105c51:	0f 84 7e 00 00 00    	je     80105cd5 <sys_open+0xd5>
    {
      end_op();
      return -1;
    }
    ilock(ip);
80105c57:	83 ec 0c             	sub    $0xc,%esp
80105c5a:	50                   	push   %eax
80105c5b:	e8 20 bb ff ff       	call   80101780 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
80105c60:	83 c4 10             	add    $0x10,%esp
80105c63:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105c68:	0f 84 c2 00 00 00    	je     80105d30 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80105c6e:	e8 bd b1 ff ff       	call   80100e30 <filealloc>
80105c73:	89 c7                	mov    %eax,%edi
80105c75:	85 c0                	test   %eax,%eax
80105c77:	74 23                	je     80105c9c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105c79:	e8 92 de ff ff       	call   80103b10 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105c7e:	31 db                	xor    %ebx,%ebx
    if (curproc->ofile[fd] == 0)
80105c80:	8b 54 98 34          	mov    0x34(%eax,%ebx,4),%edx
80105c84:	85 d2                	test   %edx,%edx
80105c86:	74 60                	je     80105ce8 <sys_open+0xe8>
  for (fd = 0; fd < NOFILE; fd++)
80105c88:	83 c3 01             	add    $0x1,%ebx
80105c8b:	83 fb 10             	cmp    $0x10,%ebx
80105c8e:	75 f0                	jne    80105c80 <sys_open+0x80>
  {
    if (f)
      fileclose(f);
80105c90:	83 ec 0c             	sub    $0xc,%esp
80105c93:	57                   	push   %edi
80105c94:	e8 57 b2 ff ff       	call   80100ef0 <fileclose>
80105c99:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105c9c:	83 ec 0c             	sub    $0xc,%esp
80105c9f:	56                   	push   %esi
80105ca0:	e8 6b bd ff ff       	call   80101a10 <iunlockput>
    end_op();
80105ca5:	e8 26 d1 ff ff       	call   80102dd0 <end_op>
    return -1;
80105caa:	83 c4 10             	add    $0x10,%esp
80105cad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105cb2:	eb 6d                	jmp    80105d21 <sys_open+0x121>
80105cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105cb8:	83 ec 0c             	sub    $0xc,%esp
80105cbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105cbe:	31 c9                	xor    %ecx,%ecx
80105cc0:	ba 02 00 00 00       	mov    $0x2,%edx
80105cc5:	6a 00                	push   $0x0
80105cc7:	e8 14 f8 ff ff       	call   801054e0 <create>
    if (ip == 0)
80105ccc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105ccf:	89 c6                	mov    %eax,%esi
    if (ip == 0)
80105cd1:	85 c0                	test   %eax,%eax
80105cd3:	75 99                	jne    80105c6e <sys_open+0x6e>
      end_op();
80105cd5:	e8 f6 d0 ff ff       	call   80102dd0 <end_op>
      return -1;
80105cda:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105cdf:	eb 40                	jmp    80105d21 <sys_open+0x121>
80105ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105ce8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105ceb:	89 7c 98 34          	mov    %edi,0x34(%eax,%ebx,4)
  iunlock(ip);
80105cef:	56                   	push   %esi
80105cf0:	e8 6b bb ff ff       	call   80101860 <iunlock>
  end_op();
80105cf5:	e8 d6 d0 ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
80105cfa:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105d00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d03:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105d06:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105d09:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105d0b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105d12:	f7 d0                	not    %eax
80105d14:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d17:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105d1a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d1d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d24:	89 d8                	mov    %ebx,%eax
80105d26:	5b                   	pop    %ebx
80105d27:	5e                   	pop    %esi
80105d28:	5f                   	pop    %edi
80105d29:	5d                   	pop    %ebp
80105d2a:	c3                   	ret    
80105d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d2f:	90                   	nop
    if (ip->type == T_DIR && omode != O_RDONLY)
80105d30:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105d33:	85 c9                	test   %ecx,%ecx
80105d35:	0f 84 33 ff ff ff    	je     80105c6e <sys_open+0x6e>
80105d3b:	e9 5c ff ff ff       	jmp    80105c9c <sys_open+0x9c>

80105d40 <sys_mkdir>:

int sys_mkdir(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105d46:	e8 15 d0 ff ff       	call   80102d60 <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
80105d4b:	83 ec 08             	sub    $0x8,%esp
80105d4e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d51:	50                   	push   %eax
80105d52:	6a 00                	push   $0x0
80105d54:	e8 97 f6 ff ff       	call   801053f0 <argstr>
80105d59:	83 c4 10             	add    $0x10,%esp
80105d5c:	85 c0                	test   %eax,%eax
80105d5e:	78 30                	js     80105d90 <sys_mkdir+0x50>
80105d60:	83 ec 0c             	sub    $0xc,%esp
80105d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d66:	31 c9                	xor    %ecx,%ecx
80105d68:	ba 01 00 00 00       	mov    $0x1,%edx
80105d6d:	6a 00                	push   $0x0
80105d6f:	e8 6c f7 ff ff       	call   801054e0 <create>
80105d74:	83 c4 10             	add    $0x10,%esp
80105d77:	85 c0                	test   %eax,%eax
80105d79:	74 15                	je     80105d90 <sys_mkdir+0x50>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80105d7b:	83 ec 0c             	sub    $0xc,%esp
80105d7e:	50                   	push   %eax
80105d7f:	e8 8c bc ff ff       	call   80101a10 <iunlockput>
  end_op();
80105d84:	e8 47 d0 ff ff       	call   80102dd0 <end_op>
  return 0;
80105d89:	83 c4 10             	add    $0x10,%esp
80105d8c:	31 c0                	xor    %eax,%eax
}
80105d8e:	c9                   	leave  
80105d8f:	c3                   	ret    
    end_op();
80105d90:	e8 3b d0 ff ff       	call   80102dd0 <end_op>
    return -1;
80105d95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d9a:	c9                   	leave  
80105d9b:	c3                   	ret    
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105da0 <sys_mknod>:

int sys_mknod(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105da6:	e8 b5 cf ff ff       	call   80102d60 <begin_op>
  if ((argstr(0, &path)) < 0 ||
80105dab:	83 ec 08             	sub    $0x8,%esp
80105dae:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105db1:	50                   	push   %eax
80105db2:	6a 00                	push   $0x0
80105db4:	e8 37 f6 ff ff       	call   801053f0 <argstr>
80105db9:	83 c4 10             	add    $0x10,%esp
80105dbc:	85 c0                	test   %eax,%eax
80105dbe:	78 60                	js     80105e20 <sys_mknod+0x80>
      argint(1, &major) < 0 ||
80105dc0:	83 ec 08             	sub    $0x8,%esp
80105dc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105dc6:	50                   	push   %eax
80105dc7:	6a 01                	push   $0x1
80105dc9:	e8 12 f5 ff ff       	call   801052e0 <argint>
  if ((argstr(0, &path)) < 0 ||
80105dce:	83 c4 10             	add    $0x10,%esp
80105dd1:	85 c0                	test   %eax,%eax
80105dd3:	78 4b                	js     80105e20 <sys_mknod+0x80>
      argint(2, &minor) < 0 ||
80105dd5:	83 ec 08             	sub    $0x8,%esp
80105dd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ddb:	50                   	push   %eax
80105ddc:	6a 02                	push   $0x2
80105dde:	e8 fd f4 ff ff       	call   801052e0 <argint>
      argint(1, &major) < 0 ||
80105de3:	83 c4 10             	add    $0x10,%esp
80105de6:	85 c0                	test   %eax,%eax
80105de8:	78 36                	js     80105e20 <sys_mknod+0x80>
      (ip = create(path, T_DEV, major, minor)) == 0)
80105dea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105dee:	83 ec 0c             	sub    $0xc,%esp
80105df1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105df5:	ba 03 00 00 00       	mov    $0x3,%edx
80105dfa:	50                   	push   %eax
80105dfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105dfe:	e8 dd f6 ff ff       	call   801054e0 <create>
      argint(2, &minor) < 0 ||
80105e03:	83 c4 10             	add    $0x10,%esp
80105e06:	85 c0                	test   %eax,%eax
80105e08:	74 16                	je     80105e20 <sys_mknod+0x80>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e0a:	83 ec 0c             	sub    $0xc,%esp
80105e0d:	50                   	push   %eax
80105e0e:	e8 fd bb ff ff       	call   80101a10 <iunlockput>
  end_op();
80105e13:	e8 b8 cf ff ff       	call   80102dd0 <end_op>
  return 0;
80105e18:	83 c4 10             	add    $0x10,%esp
80105e1b:	31 c0                	xor    %eax,%eax
}
80105e1d:	c9                   	leave  
80105e1e:	c3                   	ret    
80105e1f:	90                   	nop
    end_op();
80105e20:	e8 ab cf ff ff       	call   80102dd0 <end_op>
    return -1;
80105e25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e2a:	c9                   	leave  
80105e2b:	c3                   	ret    
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e30 <sys_chdir>:

int sys_chdir(void)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	56                   	push   %esi
80105e34:	53                   	push   %ebx
80105e35:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105e38:	e8 d3 dc ff ff       	call   80103b10 <myproc>
80105e3d:	89 c6                	mov    %eax,%esi

  begin_op();
80105e3f:	e8 1c cf ff ff       	call   80102d60 <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105e44:	83 ec 08             	sub    $0x8,%esp
80105e47:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e4a:	50                   	push   %eax
80105e4b:	6a 00                	push   $0x0
80105e4d:	e8 9e f5 ff ff       	call   801053f0 <argstr>
80105e52:	83 c4 10             	add    $0x10,%esp
80105e55:	85 c0                	test   %eax,%eax
80105e57:	78 77                	js     80105ed0 <sys_chdir+0xa0>
80105e59:	83 ec 0c             	sub    $0xc,%esp
80105e5c:	ff 75 f4             	push   -0xc(%ebp)
80105e5f:	e8 3c c2 ff ff       	call   801020a0 <namei>
80105e64:	83 c4 10             	add    $0x10,%esp
80105e67:	89 c3                	mov    %eax,%ebx
80105e69:	85 c0                	test   %eax,%eax
80105e6b:	74 63                	je     80105ed0 <sys_chdir+0xa0>
  {
    end_op();
    return -1;
  }
  ilock(ip);
80105e6d:	83 ec 0c             	sub    $0xc,%esp
80105e70:	50                   	push   %eax
80105e71:	e8 0a b9 ff ff       	call   80101780 <ilock>
  if (ip->type != T_DIR)
80105e76:	83 c4 10             	add    $0x10,%esp
80105e79:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105e7e:	75 30                	jne    80105eb0 <sys_chdir+0x80>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105e80:	83 ec 0c             	sub    $0xc,%esp
80105e83:	53                   	push   %ebx
80105e84:	e8 d7 b9 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105e89:	58                   	pop    %eax
80105e8a:	ff 76 74             	push   0x74(%esi)
80105e8d:	e8 1e ba ff ff       	call   801018b0 <iput>
  end_op();
80105e92:	e8 39 cf ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80105e97:	89 5e 74             	mov    %ebx,0x74(%esi)
  return 0;
80105e9a:	83 c4 10             	add    $0x10,%esp
80105e9d:	31 c0                	xor    %eax,%eax
}
80105e9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ea2:	5b                   	pop    %ebx
80105ea3:	5e                   	pop    %esi
80105ea4:	5d                   	pop    %ebp
80105ea5:	c3                   	ret    
80105ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ead:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105eb0:	83 ec 0c             	sub    $0xc,%esp
80105eb3:	53                   	push   %ebx
80105eb4:	e8 57 bb ff ff       	call   80101a10 <iunlockput>
    end_op();
80105eb9:	e8 12 cf ff ff       	call   80102dd0 <end_op>
    return -1;
80105ebe:	83 c4 10             	add    $0x10,%esp
80105ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ec6:	eb d7                	jmp    80105e9f <sys_chdir+0x6f>
80105ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ecf:	90                   	nop
    end_op();
80105ed0:	e8 fb ce ff ff       	call   80102dd0 <end_op>
    return -1;
80105ed5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eda:	eb c3                	jmp    80105e9f <sys_chdir+0x6f>
80105edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ee0 <sys_exec>:

int sys_exec(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	57                   	push   %edi
80105ee4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80105ee5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105eeb:	53                   	push   %ebx
80105eec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80105ef2:	50                   	push   %eax
80105ef3:	6a 00                	push   $0x0
80105ef5:	e8 f6 f4 ff ff       	call   801053f0 <argstr>
80105efa:	83 c4 10             	add    $0x10,%esp
80105efd:	85 c0                	test   %eax,%eax
80105eff:	0f 88 87 00 00 00    	js     80105f8c <sys_exec+0xac>
80105f05:	83 ec 08             	sub    $0x8,%esp
80105f08:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105f0e:	50                   	push   %eax
80105f0f:	6a 01                	push   $0x1
80105f11:	e8 ca f3 ff ff       	call   801052e0 <argint>
80105f16:	83 c4 10             	add    $0x10,%esp
80105f19:	85 c0                	test   %eax,%eax
80105f1b:	78 6f                	js     80105f8c <sys_exec+0xac>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105f1d:	83 ec 04             	sub    $0x4,%esp
80105f20:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for (i = 0;; i++)
80105f26:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105f28:	68 80 00 00 00       	push   $0x80
80105f2d:	6a 00                	push   $0x0
80105f2f:	56                   	push   %esi
80105f30:	e8 ab f0 ff ff       	call   80104fe0 <memset>
80105f35:	83 c4 10             	add    $0x10,%esp
80105f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3f:	90                   	nop
  {
    if (i >= NELEM(argv))
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80105f40:	83 ec 08             	sub    $0x8,%esp
80105f43:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105f49:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105f50:	50                   	push   %eax
80105f51:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105f57:	01 f8                	add    %edi,%eax
80105f59:	50                   	push   %eax
80105f5a:	e8 b1 f2 ff ff       	call   80105210 <fetchint>
80105f5f:	83 c4 10             	add    $0x10,%esp
80105f62:	85 c0                	test   %eax,%eax
80105f64:	78 26                	js     80105f8c <sys_exec+0xac>
      return -1;
    if (uarg == 0)
80105f66:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105f6c:	85 c0                	test   %eax,%eax
80105f6e:	74 30                	je     80105fa0 <sys_exec+0xc0>
    {
      argv[i] = 0;
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
80105f70:	83 ec 08             	sub    $0x8,%esp
80105f73:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105f76:	52                   	push   %edx
80105f77:	50                   	push   %eax
80105f78:	e8 d3 f2 ff ff       	call   80105250 <fetchstr>
80105f7d:	83 c4 10             	add    $0x10,%esp
80105f80:	85 c0                	test   %eax,%eax
80105f82:	78 08                	js     80105f8c <sys_exec+0xac>
  for (i = 0;; i++)
80105f84:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
80105f87:	83 fb 20             	cmp    $0x20,%ebx
80105f8a:	75 b4                	jne    80105f40 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105f8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105f8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f94:	5b                   	pop    %ebx
80105f95:	5e                   	pop    %esi
80105f96:	5f                   	pop    %edi
80105f97:	5d                   	pop    %ebp
80105f98:	c3                   	ret    
80105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105fa0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105fa7:	00 00 00 00 
  return exec(path, argv);
80105fab:	83 ec 08             	sub    $0x8,%esp
80105fae:	56                   	push   %esi
80105faf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105fb5:	e8 f6 aa ff ff       	call   80100ab0 <exec>
80105fba:	83 c4 10             	add    $0x10,%esp
}
80105fbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fc0:	5b                   	pop    %ebx
80105fc1:	5e                   	pop    %esi
80105fc2:	5f                   	pop    %edi
80105fc3:	5d                   	pop    %ebp
80105fc4:	c3                   	ret    
80105fc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fd0 <sys_pipe>:

int sys_pipe(void)
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	57                   	push   %edi
80105fd4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80105fd5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105fd8:	53                   	push   %ebx
80105fd9:	83 ec 20             	sub    $0x20,%esp
  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80105fdc:	6a 08                	push   $0x8
80105fde:	50                   	push   %eax
80105fdf:	6a 00                	push   $0x0
80105fe1:	e8 9a f3 ff ff       	call   80105380 <argptr>
80105fe6:	83 c4 10             	add    $0x10,%esp
80105fe9:	85 c0                	test   %eax,%eax
80105feb:	78 4a                	js     80106037 <sys_pipe+0x67>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
80105fed:	83 ec 08             	sub    $0x8,%esp
80105ff0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ff3:	50                   	push   %eax
80105ff4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ff7:	50                   	push   %eax
80105ff8:	e8 33 d4 ff ff       	call   80103430 <pipealloc>
80105ffd:	83 c4 10             	add    $0x10,%esp
80106000:	85 c0                	test   %eax,%eax
80106002:	78 33                	js     80106037 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80106004:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (fd = 0; fd < NOFILE; fd++)
80106007:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106009:	e8 02 db ff ff       	call   80103b10 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
8010600e:	66 90                	xchg   %ax,%ax
    if (curproc->ofile[fd] == 0)
80106010:	8b 74 98 34          	mov    0x34(%eax,%ebx,4),%esi
80106014:	85 f6                	test   %esi,%esi
80106016:	74 28                	je     80106040 <sys_pipe+0x70>
  for (fd = 0; fd < NOFILE; fd++)
80106018:	83 c3 01             	add    $0x1,%ebx
8010601b:	83 fb 10             	cmp    $0x10,%ebx
8010601e:	75 f0                	jne    80106010 <sys_pipe+0x40>
  {
    if (fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106020:	83 ec 0c             	sub    $0xc,%esp
80106023:	ff 75 e0             	push   -0x20(%ebp)
80106026:	e8 c5 ae ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010602b:	58                   	pop    %eax
8010602c:	ff 75 e4             	push   -0x1c(%ebp)
8010602f:	e8 bc ae ff ff       	call   80100ef0 <fileclose>
    return -1;
80106034:	83 c4 10             	add    $0x10,%esp
80106037:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010603c:	eb 53                	jmp    80106091 <sys_pipe+0xc1>
8010603e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106040:	8d 73 0c             	lea    0xc(%ebx),%esi
80106043:	89 7c b0 04          	mov    %edi,0x4(%eax,%esi,4)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80106047:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010604a:	e8 c1 da ff ff       	call   80103b10 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
8010604f:	31 d2                	xor    %edx,%edx
80106051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd] == 0)
80106058:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
8010605c:	85 c9                	test   %ecx,%ecx
8010605e:	74 20                	je     80106080 <sys_pipe+0xb0>
  for (fd = 0; fd < NOFILE; fd++)
80106060:	83 c2 01             	add    $0x1,%edx
80106063:	83 fa 10             	cmp    $0x10,%edx
80106066:	75 f0                	jne    80106058 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80106068:	e8 a3 da ff ff       	call   80103b10 <myproc>
8010606d:	c7 44 b0 04 00 00 00 	movl   $0x0,0x4(%eax,%esi,4)
80106074:	00 
80106075:	eb a9                	jmp    80106020 <sys_pipe+0x50>
80106077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010607e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106080:	89 7c 90 34          	mov    %edi,0x34(%eax,%edx,4)
  }
  fd[0] = fd0;
80106084:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106087:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106089:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010608c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010608f:	31 c0                	xor    %eax,%eax
}
80106091:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106094:	5b                   	pop    %ebx
80106095:	5e                   	pop    %esi
80106096:	5f                   	pop    %edi
80106097:	5d                   	pop    %ebp
80106098:	c3                   	ret    
80106099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060a0 <sys_copy_file>:
}



int sys_copy_file(void)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	57                   	push   %edi
801060a4:	56                   	push   %esi
801060a5:	53                   	push   %ebx
801060a6:	81 ec 00 10 00 00    	sub    $0x1000,%esp
801060ac:	83 0c 24 00          	orl    $0x0,(%esp)
801060b0:	83 ec 34             	sub    $0x34,%esp
  char *dest;
  int fd;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &src) < 0 || argstr(1, &dest) < 0)
801060b3:	8d 85 e0 ef ff ff    	lea    -0x1020(%ebp),%eax
801060b9:	50                   	push   %eax
801060ba:	6a 00                	push   $0x0
801060bc:	e8 2f f3 ff ff       	call   801053f0 <argstr>
801060c1:	83 c4 10             	add    $0x10,%esp
801060c4:	85 c0                	test   %eax,%eax
801060c6:	0f 88 81 01 00 00    	js     8010624d <sys_copy_file+0x1ad>
801060cc:	83 ec 08             	sub    $0x8,%esp
801060cf:	8d 85 e4 ef ff ff    	lea    -0x101c(%ebp),%eax
801060d5:	50                   	push   %eax
801060d6:	6a 01                	push   $0x1
801060d8:	e8 13 f3 ff ff       	call   801053f0 <argstr>
801060dd:	83 c4 10             	add    $0x10,%esp
801060e0:	85 c0                	test   %eax,%eax
801060e2:	0f 88 65 01 00 00    	js     8010624d <sys_copy_file+0x1ad>
    return -1;

  begin_op();
801060e8:	e8 73 cc ff ff       	call   80102d60 <begin_op>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(src)) == 0)
801060ed:	83 ec 0c             	sub    $0xc,%esp
801060f0:	ff b5 e0 ef ff ff    	push   -0x1020(%ebp)
801060f6:	e8 a5 bf ff ff       	call   801020a0 <namei>
801060fb:	83 c4 10             	add    $0x10,%esp
801060fe:	89 c6                	mov    %eax,%esi
80106100:	85 c0                	test   %eax,%eax
80106102:	0f 84 c0 01 00 00    	je     801062c8 <sys_copy_file+0x228>
    {
      end_op();
      return -1;
    }
    ilock(ip);
80106108:	83 ec 0c             	sub    $0xc,%esp
8010610b:	50                   	push   %eax
8010610c:	e8 6f b6 ff ff       	call   80101780 <ilock>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80106111:	e8 1a ad ff ff       	call   80100e30 <filealloc>
80106116:	83 c4 10             	add    $0x10,%esp
80106119:	89 c7                	mov    %eax,%edi
8010611b:	85 c0                	test   %eax,%eax
8010611d:	74 2d                	je     8010614c <sys_copy_file+0xac>
  struct proc *curproc = myproc();
8010611f:	e8 ec d9 ff ff       	call   80103b10 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80106124:	31 d2                	xor    %edx,%edx
80106126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010612d:	8d 76 00             	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
80106130:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
80106134:	85 c9                	test   %ecx,%ecx
80106136:	74 38                	je     80106170 <sys_copy_file+0xd0>
  for (fd = 0; fd < NOFILE; fd++)
80106138:	83 c2 01             	add    $0x1,%edx
8010613b:	83 fa 10             	cmp    $0x10,%edx
8010613e:	75 f0                	jne    80106130 <sys_copy_file+0x90>
  {
    if (f)
      fileclose(f);
80106140:	83 ec 0c             	sub    $0xc,%esp
80106143:	57                   	push   %edi
80106144:	e8 a7 ad ff ff       	call   80100ef0 <fileclose>
80106149:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010614c:	83 ec 0c             	sub    $0xc,%esp
8010614f:	56                   	push   %esi
80106150:	e8 bb b8 ff ff       	call   80101a10 <iunlockput>
    end_op();
80106155:	e8 76 cc ff ff       	call   80102dd0 <end_op>
    return -1;
8010615a:	83 c4 10             	add    $0x10,%esp
8010615d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106162:	e9 59 01 00 00       	jmp    801062c0 <sys_copy_file+0x220>
80106167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010616e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106170:	8d 5a 0c             	lea    0xc(%edx),%ebx
  }
  iunlock(ip);
80106173:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106176:	89 7c 98 04          	mov    %edi,0x4(%eax,%ebx,4)
  iunlock(ip);
8010617a:	56                   	push   %esi
8010617b:	e8 e0 b6 ff ff       	call   80101860 <iunlock>
  end_op();
80106180:	e8 4b cc ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(O_RDONLY & O_WRONLY);
80106185:	b8 01 00 00 00       	mov    $0x1,%eax
  f->ip = ip;
8010618a:	89 77 10             	mov    %esi,0x10(%edi)
  f->type = FD_INODE;
8010618d:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->off = 0;
80106193:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(O_RDONLY & O_WRONLY);
8010619a:	66 89 47 08          	mov    %ax,0x8(%edi)
  if((f = myproc() -> ofile[fd]) == 0){
8010619e:	e8 6d d9 ff ff       	call   80103b10 <myproc>
801061a3:	83 c4 10             	add    $0x10,%esp
801061a6:	8b 44 98 04          	mov    0x4(%eax,%ebx,4),%eax
801061aa:	85 c0                	test   %eax,%eax
801061ac:	0f 84 9b 00 00 00    	je     8010624d <sys_copy_file+0x1ad>
  f->writable = (O_RDONLY & O_WRONLY) || (O_RDONLY & O_RDWR);
  
  char p[4096];
  if (my_argfd(0, 0, &f, fd) < 0)
      return -1;
  int read_chars = fileread(f, p, 4096);
801061b2:	83 ec 04             	sub    $0x4,%esp
801061b5:	8d bd e8 ef ff ff    	lea    -0x1018(%ebp),%edi
801061bb:	68 00 10 00 00       	push   $0x1000
801061c0:	57                   	push   %edi
801061c1:	50                   	push   %eax
801061c2:	e8 59 ae ff ff       	call   80101020 <fileread>
801061c7:	89 85 d4 ef ff ff    	mov    %eax,-0x102c(%ebp)
  //dest
  int fd2;
  struct file *f2;
  struct inode *ip2;
  begin_op();
801061cd:	e8 8e cb ff ff       	call   80102d60 <begin_op>
      return -1;
    }
  }
  else
  {
    if ((ip2 = namei(dest)) == 0)
801061d2:	58                   	pop    %eax
801061d3:	ff b5 e4 ef ff ff    	push   -0x101c(%ebp)
801061d9:	e8 c2 be ff ff       	call   801020a0 <namei>
801061de:	83 c4 10             	add    $0x10,%esp
801061e1:	89 c3                	mov    %eax,%ebx
801061e3:	85 c0                	test   %eax,%eax
801061e5:	0f 84 dd 00 00 00    	je     801062c8 <sys_copy_file+0x228>
    {
      end_op();
      return -1;
    }
    ilock(ip2);
801061eb:	83 ec 0c             	sub    $0xc,%esp
801061ee:	50                   	push   %eax
801061ef:	e8 8c b5 ff ff       	call   80101780 <ilock>
    if (ip2->type == T_DIR && dest != O_RDONLY)
801061f4:	83 c4 10             	add    $0x10,%esp
801061f7:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801061fc:	75 0a                	jne    80106208 <sys_copy_file+0x168>
801061fe:	8b b5 e4 ef ff ff    	mov    -0x101c(%ebp),%esi
80106204:	85 f6                	test   %esi,%esi
80106206:	75 34                	jne    8010623c <sys_copy_file+0x19c>
      end_op();
      return -1;
    }
  }

  if ((f2 = filealloc()) == 0 || (fd2 = fdalloc(f2)) < 0)
80106208:	e8 23 ac ff ff       	call   80100e30 <filealloc>
8010620d:	89 c6                	mov    %eax,%esi
8010620f:	85 c0                	test   %eax,%eax
80106211:	74 29                	je     8010623c <sys_copy_file+0x19c>
  struct proc *curproc = myproc();
80106213:	e8 f8 d8 ff ff       	call   80103b10 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80106218:	31 d2                	xor    %edx,%edx
8010621a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
80106220:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
80106224:	85 c9                	test   %ecx,%ecx
80106226:	74 30                	je     80106258 <sys_copy_file+0x1b8>
  for (fd = 0; fd < NOFILE; fd++)
80106228:	83 c2 01             	add    $0x1,%edx
8010622b:	83 fa 10             	cmp    $0x10,%edx
8010622e:	75 f0                	jne    80106220 <sys_copy_file+0x180>
  {
    if (f2)
      fileclose(f2);
80106230:	83 ec 0c             	sub    $0xc,%esp
80106233:	56                   	push   %esi
80106234:	e8 b7 ac ff ff       	call   80100ef0 <fileclose>
80106239:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip2);
8010623c:	83 ec 0c             	sub    $0xc,%esp
8010623f:	53                   	push   %ebx
80106240:	e8 cb b7 ff ff       	call   80101a10 <iunlockput>
    end_op();
80106245:	e8 86 cb ff ff       	call   80102dd0 <end_op>
    return -1;
8010624a:	83 c4 10             	add    $0x10,%esp
8010624d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106252:	eb 6c                	jmp    801062c0 <sys_copy_file+0x220>
80106254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80106258:	83 c2 0c             	add    $0xc,%edx
  }
  iunlock(ip2);
8010625b:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010625e:	89 74 90 04          	mov    %esi,0x4(%eax,%edx,4)
  iunlock(ip2);
80106262:	53                   	push   %ebx
      curproc->ofile[fd] = f;
80106263:	89 95 d0 ef ff ff    	mov    %edx,-0x1030(%ebp)
  iunlock(ip2);
80106269:	e8 f2 b5 ff ff       	call   80101860 <iunlock>
  end_op();
8010626e:	e8 5d cb ff ff       	call   80102dd0 <end_op>

  f2->type = FD_INODE;
  f2->ip = ip2;
  f2->off = 0;
  f2->readable = !(O_WRONLY & O_WRONLY);
80106273:	b8 00 01 00 00       	mov    $0x100,%eax
  f2->ip = ip2;
80106278:	89 5e 10             	mov    %ebx,0x10(%esi)
  f2->type = FD_INODE;
8010627b:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f2->off = 0;
80106281:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f2->readable = !(O_WRONLY & O_WRONLY);
80106288:	66 89 46 08          	mov    %ax,0x8(%esi)
  if((f = myproc() -> ofile[fd]) == 0){
8010628c:	e8 7f d8 ff ff       	call   80103b10 <myproc>
80106291:	8b 95 d0 ef ff ff    	mov    -0x1030(%ebp),%edx
80106297:	83 c4 10             	add    $0x10,%esp
8010629a:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010629e:	85 c0                	test   %eax,%eax
801062a0:	74 ab                	je     8010624d <sys_copy_file+0x1ad>
  f2->writable = (O_WRONLY & O_WRONLY) || (O_WRONLY & O_RDWR);
  if (my_argfd(0, 0, &f2, fd2) < 0)
      return -1;   
  int written_chars = filewrite(f2, p, read_chars);
801062a2:	8b 9d d4 ef ff ff    	mov    -0x102c(%ebp),%ebx
801062a8:	83 ec 04             	sub    $0x4,%esp
801062ab:	53                   	push   %ebx
801062ac:	57                   	push   %edi
801062ad:	50                   	push   %eax
801062ae:	e8 fd ad ff ff       	call   801010b0 <filewrite>
  if(written_chars != read_chars){
801062b3:	83 c4 10             	add    $0x10,%esp
801062b6:	39 c3                	cmp    %eax,%ebx
801062b8:	0f 95 c0             	setne  %al
801062bb:	0f b6 c0             	movzbl %al,%eax
801062be:	f7 d8                	neg    %eax
    return -1;
  }
  else{
    return 0;
  }
801062c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062c3:	5b                   	pop    %ebx
801062c4:	5e                   	pop    %esi
801062c5:	5f                   	pop    %edi
801062c6:	5d                   	pop    %ebp
801062c7:	c3                   	ret    
      end_op();
801062c8:	e8 03 cb ff ff       	call   80102dd0 <end_op>
      return -1;
801062cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062d2:	eb ec                	jmp    801062c0 <sys_copy_file+0x220>
801062d4:	66 90                	xchg   %ax,%ax
801062d6:	66 90                	xchg   %ax,%ax
801062d8:	66 90                	xchg   %ax,%ax
801062da:	66 90                	xchg   %ax,%ax
801062dc:	66 90                	xchg   %ax,%ax
801062de:	66 90                	xchg   %ax,%ax

801062e0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int sys_fork(void)
{
  return fork();
801062e0:	e9 6b de ff ff       	jmp    80104150 <fork>
801062e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062f0 <sys_exit>:
}

int sys_exit(void)
{
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801062f6:	e8 85 e3 ff ff       	call   80104680 <exit>
  return 0; // not reached
}
801062fb:	31 c0                	xor    %eax,%eax
801062fd:	c9                   	leave  
801062fe:	c3                   	ret    
801062ff:	90                   	nop

80106300 <sys_wait>:

int sys_wait(void)
{
  return wait();
80106300:	e9 ab e4 ff ff       	jmp    801047b0 <wait>
80106305:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010630c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106310 <sys_kill>:
}

int sys_kill(void)
{
80106310:	55                   	push   %ebp
80106311:	89 e5                	mov    %esp,%ebp
80106313:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80106316:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106319:	50                   	push   %eax
8010631a:	6a 00                	push   $0x0
8010631c:	e8 bf ef ff ff       	call   801052e0 <argint>
80106321:	83 c4 10             	add    $0x10,%esp
80106324:	85 c0                	test   %eax,%eax
80106326:	78 18                	js     80106340 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106328:	83 ec 0c             	sub    $0xc,%esp
8010632b:	ff 75 f4             	push   -0xc(%ebp)
8010632e:	e8 5d e7 ff ff       	call   80104a90 <kill>
80106333:	83 c4 10             	add    $0x10,%esp
}
80106336:	c9                   	leave  
80106337:	c3                   	ret    
80106338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010633f:	90                   	nop
80106340:	c9                   	leave  
    return -1;
80106341:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106346:	c3                   	ret    
80106347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010634e:	66 90                	xchg   %ax,%ax

80106350 <sys_getpid>:

int sys_getpid(void)
{
80106350:	55                   	push   %ebp
80106351:	89 e5                	mov    %esp,%ebp
80106353:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106356:	e8 b5 d7 ff ff       	call   80103b10 <myproc>
8010635b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010635e:	c9                   	leave  
8010635f:	c3                   	ret    

80106360 <sys_sbrk>:

int sys_sbrk(void)
{
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	53                   	push   %ebx
  int addr;
  int n;

  if (argint(0, &n) < 0)
80106364:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106367:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
8010636a:	50                   	push   %eax
8010636b:	6a 00                	push   $0x0
8010636d:	e8 6e ef ff ff       	call   801052e0 <argint>
80106372:	83 c4 10             	add    $0x10,%esp
80106375:	85 c0                	test   %eax,%eax
80106377:	78 27                	js     801063a0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106379:	e8 92 d7 ff ff       	call   80103b10 <myproc>
  if (growproc(n) < 0)
8010637e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106381:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80106383:	ff 75 f4             	push   -0xc(%ebp)
80106386:	e8 45 dd ff ff       	call   801040d0 <growproc>
8010638b:	83 c4 10             	add    $0x10,%esp
8010638e:	85 c0                	test   %eax,%eax
80106390:	78 0e                	js     801063a0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106392:	89 d8                	mov    %ebx,%eax
80106394:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106397:	c9                   	leave  
80106398:	c3                   	ret    
80106399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801063a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801063a5:	eb eb                	jmp    80106392 <sys_sbrk+0x32>
801063a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063ae:	66 90                	xchg   %ax,%ax

801063b0 <sys_sleep>:

int sys_sleep(void)
{
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
801063b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801063b7:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
801063ba:	50                   	push   %eax
801063bb:	6a 00                	push   $0x0
801063bd:	e8 1e ef ff ff       	call   801052e0 <argint>
801063c2:	83 c4 10             	add    $0x10,%esp
801063c5:	85 c0                	test   %eax,%eax
801063c7:	0f 88 8a 00 00 00    	js     80106457 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801063cd:	83 ec 0c             	sub    $0xc,%esp
801063d0:	68 80 55 11 80       	push   $0x80115580
801063d5:	e8 46 eb ff ff       	call   80104f20 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
801063da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801063dd:	8b 1d 60 55 11 80    	mov    0x80115560,%ebx
  while (ticks - ticks0 < n)
801063e3:	83 c4 10             	add    $0x10,%esp
801063e6:	85 d2                	test   %edx,%edx
801063e8:	75 27                	jne    80106411 <sys_sleep+0x61>
801063ea:	eb 54                	jmp    80106440 <sys_sleep+0x90>
801063ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801063f0:	83 ec 08             	sub    $0x8,%esp
801063f3:	68 80 55 11 80       	push   $0x80115580
801063f8:	68 60 55 11 80       	push   $0x80115560
801063fd:	e8 6e e5 ff ff       	call   80104970 <sleep>
  while (ticks - ticks0 < n)
80106402:	a1 60 55 11 80       	mov    0x80115560,%eax
80106407:	83 c4 10             	add    $0x10,%esp
8010640a:	29 d8                	sub    %ebx,%eax
8010640c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010640f:	73 2f                	jae    80106440 <sys_sleep+0x90>
    if (myproc()->killed)
80106411:	e8 fa d6 ff ff       	call   80103b10 <myproc>
80106416:	8b 40 30             	mov    0x30(%eax),%eax
80106419:	85 c0                	test   %eax,%eax
8010641b:	74 d3                	je     801063f0 <sys_sleep+0x40>
      release(&tickslock);
8010641d:	83 ec 0c             	sub    $0xc,%esp
80106420:	68 80 55 11 80       	push   $0x80115580
80106425:	e8 96 ea ff ff       	call   80104ec0 <release>
  }
  release(&tickslock);
  return 0;
}
8010642a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010642d:	83 c4 10             	add    $0x10,%esp
80106430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106435:	c9                   	leave  
80106436:	c3                   	ret    
80106437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010643e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106440:	83 ec 0c             	sub    $0xc,%esp
80106443:	68 80 55 11 80       	push   $0x80115580
80106448:	e8 73 ea ff ff       	call   80104ec0 <release>
  return 0;
8010644d:	83 c4 10             	add    $0x10,%esp
80106450:	31 c0                	xor    %eax,%eax
}
80106452:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106455:	c9                   	leave  
80106456:	c3                   	ret    
    return -1;
80106457:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010645c:	eb f4                	jmp    80106452 <sys_sleep+0xa2>
8010645e:	66 90                	xchg   %ax,%ax

80106460 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
80106463:	53                   	push   %ebx
80106464:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106467:	68 80 55 11 80       	push   $0x80115580
8010646c:	e8 af ea ff ff       	call   80104f20 <acquire>
  xticks = ticks;
80106471:	8b 1d 60 55 11 80    	mov    0x80115560,%ebx
  release(&tickslock);
80106477:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)
8010647e:	e8 3d ea ff ff       	call   80104ec0 <release>
  return xticks;
}
80106483:	89 d8                	mov    %ebx,%eax
80106485:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106488:	c9                   	leave  
80106489:	c3                   	ret    
8010648a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106490 <sys_find_digital_root>:

int sys_find_digital_root(void)
{
80106490:	55                   	push   %ebp
80106491:	89 e5                	mov    %esp,%ebp
80106493:	83 ec 08             	sub    $0x8,%esp
  int number = myproc()->tf->ebx; // register after eax
80106496:	e8 75 d6 ff ff       	call   80103b10 <myproc>
  return find_digital_root(number);
8010649b:	83 ec 0c             	sub    $0xc,%esp
  int number = myproc()->tf->ebx; // register after eax
8010649e:	8b 40 18             	mov    0x18(%eax),%eax
  return find_digital_root(number);
801064a1:	ff 70 10             	push   0x10(%eax)
801064a4:	e8 27 e7 ff ff       	call   80104bd0 <find_digital_root>
}
801064a9:	c9                   	leave  
801064aa:	c3                   	ret    
801064ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801064af:	90                   	nop

801064b0 <sys_get_uncle_count>:

int sys_get_uncle_count(void)
{
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
801064b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064b9:	50                   	push   %eax
801064ba:	6a 00                	push   $0x0
801064bc:	e8 1f ee ff ff       	call   801052e0 <argint>
801064c1:	83 c4 10             	add    $0x10,%esp
801064c4:	85 c0                	test   %eax,%eax
801064c6:	78 28                	js     801064f0 <sys_get_uncle_count+0x40>
  {
    return -1;
  }
  struct proc *grandFather = find_proc(pid)->parent->parent;
801064c8:	83 ec 0c             	sub    $0xc,%esp
801064cb:	ff 75 f4             	push   -0xc(%ebp)
801064ce:	e8 0d d8 ff ff       	call   80103ce0 <find_proc>
  return count_child(grandFather) - 1;
801064d3:	5a                   	pop    %edx
  struct proc *grandFather = find_proc(pid)->parent->parent;
801064d4:	8b 40 14             	mov    0x14(%eax),%eax
  return count_child(grandFather) - 1;
801064d7:	ff 70 14             	push   0x14(%eax)
801064da:	e8 91 db ff ff       	call   80104070 <count_child>
801064df:	83 c4 10             	add    $0x10,%esp
}
801064e2:	c9                   	leave  
  return count_child(grandFather) - 1;
801064e3:	83 e8 01             	sub    $0x1,%eax
}
801064e6:	c3                   	ret    
801064e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ee:	66 90                	xchg   %ax,%ax
801064f0:	c9                   	leave  
    return -1;
801064f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064f6:	c3                   	ret    
801064f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064fe:	66 90                	xchg   %ax,%ax

80106500 <sys_get_process_lifetime>:
int sys_get_process_lifetime(void)
{
80106500:	55                   	push   %ebp
80106501:	89 e5                	mov    %esp,%ebp
80106503:	53                   	push   %ebx
  int pid;
  if (argint(0, &pid) < 0)
80106504:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106507:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0)
8010650a:	50                   	push   %eax
8010650b:	6a 00                	push   $0x0
8010650d:	e8 ce ed ff ff       	call   801052e0 <argint>
80106512:	83 c4 10             	add    $0x10,%esp
80106515:	85 c0                	test   %eax,%eax
80106517:	78 27                	js     80106540 <sys_get_process_lifetime+0x40>
  {
    return -1;
  }
  return ticks - (find_proc(pid)->creation_time);
80106519:	83 ec 0c             	sub    $0xc,%esp
8010651c:	ff 75 f4             	push   -0xc(%ebp)
8010651f:	8b 1d 60 55 11 80    	mov    0x80115560,%ebx
80106525:	e8 b6 d7 ff ff       	call   80103ce0 <find_proc>
8010652a:	83 c4 10             	add    $0x10,%esp
8010652d:	2b 58 20             	sub    0x20(%eax),%ebx
80106530:	89 d8                	mov    %ebx,%eax
}
80106532:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106535:	c9                   	leave  
80106536:	c3                   	ret    
80106537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010653e:	66 90                	xchg   %ax,%ax
    return -1;
80106540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106545:	eb eb                	jmp    80106532 <sys_get_process_lifetime+0x32>
80106547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010654e:	66 90                	xchg   %ax,%ax

80106550 <sys_set_date>:
void sys_set_date(void)
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *r;
  if (argptr(0, (void *)&r, sizeof(*r)) < 0)
80106556:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106559:	6a 18                	push   $0x18
8010655b:	50                   	push   %eax
8010655c:	6a 00                	push   $0x0
8010655e:	e8 1d ee ff ff       	call   80105380 <argptr>
80106563:	83 c4 10             	add    $0x10,%esp
80106566:	85 c0                	test   %eax,%eax
80106568:	78 16                	js     80106580 <sys_set_date+0x30>
    cprintf("Kernel: sys_set_date() has a problem.\n");

  cmostime(r);
8010656a:	83 ec 0c             	sub    $0xc,%esp
8010656d:	ff 75 f4             	push   -0xc(%ebp)
80106570:	e8 5b c4 ff ff       	call   801029d0 <cmostime>
}
80106575:	83 c4 10             	add    $0x10,%esp
80106578:	c9                   	leave  
80106579:	c3                   	ret    
8010657a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("Kernel: sys_set_date() has a problem.\n");
80106580:	83 ec 0c             	sub    $0xc,%esp
80106583:	68 c8 89 10 80       	push   $0x801089c8
80106588:	e8 13 a1 ff ff       	call   801006a0 <cprintf>
8010658d:	83 c4 10             	add    $0x10,%esp
  cmostime(r);
80106590:	83 ec 0c             	sub    $0xc,%esp
80106593:	ff 75 f4             	push   -0xc(%ebp)
80106596:	e8 35 c4 ff ff       	call   801029d0 <cmostime>
}
8010659b:	83 c4 10             	add    $0x10,%esp
8010659e:	c9                   	leave  
8010659f:	c3                   	ret    

801065a0 <sys_get_pid>:
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
801065a3:	83 ec 08             	sub    $0x8,%esp
801065a6:	e8 65 d5 ff ff       	call   80103b10 <myproc>
801065ab:	8b 40 10             	mov    0x10(%eax),%eax
801065ae:	c9                   	leave  
801065af:	c3                   	ret    

801065b0 <sys_get_parent>:
int sys_get_pid(void)
{
  return myproc()->pid;
}
int sys_get_parent(void)
{
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
801065b6:	e8 55 d5 ff ff       	call   80103b10 <myproc>
801065bb:	8b 40 14             	mov    0x14(%eax),%eax
801065be:	8b 40 10             	mov    0x10(%eax),%eax
}
801065c1:	c9                   	leave  
801065c2:	c3                   	ret    
801065c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801065d0 <sys_change_queue>:
int sys_change_queue(void)
{
801065d0:	55                   	push   %ebp
801065d1:	89 e5                	mov    %esp,%ebp
801065d3:	53                   	push   %ebx
  int pid, que_id;
  if (argint(0, &pid) < 0 || argint(1, &que_id))
801065d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
801065d7:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0 || argint(1, &que_id))
801065da:	50                   	push   %eax
801065db:	6a 00                	push   $0x0
801065dd:	e8 fe ec ff ff       	call   801052e0 <argint>
801065e2:	83 c4 10             	add    $0x10,%esp
801065e5:	85 c0                	test   %eax,%eax
801065e7:	78 47                	js     80106630 <sys_change_queue+0x60>
801065e9:	83 ec 08             	sub    $0x8,%esp
801065ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065ef:	50                   	push   %eax
801065f0:	6a 01                	push   $0x1
801065f2:	e8 e9 ec ff ff       	call   801052e0 <argint>
801065f7:	83 c4 10             	add    $0x10,%esp
801065fa:	89 c3                	mov    %eax,%ebx
801065fc:	85 c0                	test   %eax,%eax
801065fe:	75 30                	jne    80106630 <sys_change_queue+0x60>
    return -1;
  cprintf("%d\n", pid);
80106600:	83 ec 08             	sub    $0x8,%esp
80106603:	ff 75 f0             	push   -0x10(%ebp)
80106606:	68 14 86 10 80       	push   $0x80108614
8010660b:	e8 90 a0 ff ff       	call   801006a0 <cprintf>
  struct proc *p = find_proc(pid);
80106610:	58                   	pop    %eax
80106611:	ff 75 f0             	push   -0x10(%ebp)
80106614:	e8 c7 d6 ff ff       	call   80103ce0 <find_proc>
  p->que_id = que_id;
80106619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  return 0;
8010661c:	83 c4 10             	add    $0x10,%esp
  p->que_id = que_id;
8010661f:	89 50 28             	mov    %edx,0x28(%eax)
}
80106622:	89 d8                	mov    %ebx,%eax
80106624:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106627:	c9                   	leave  
80106628:	c3                   	ret    
80106629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106630:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106635:	eb eb                	jmp    80106622 <sys_change_queue+0x52>
80106637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010663e:	66 90                	xchg   %ax,%ax

80106640 <sys_bjf_validation_process>:
int sys_bjf_validation_process(void)
{
80106640:	55                   	push   %ebp
80106641:	89 e5                	mov    %esp,%ebp
80106643:	83 ec 30             	sub    $0x30,%esp
  
  int pid;
  int priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argint(0, &pid) < 0 || argint(1, &priority_ratio) < 0 || argint(2, &creation_time_ratio) < 0 || argint(3, &exec_cycle_ratio) < 0 || argint(4, &size_ratio) < 0)
80106646:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106649:	50                   	push   %eax
8010664a:	6a 00                	push   $0x0
8010664c:	e8 8f ec ff ff       	call   801052e0 <argint>
80106651:	83 c4 10             	add    $0x10,%esp
80106654:	85 c0                	test   %eax,%eax
80106656:	0f 88 94 00 00 00    	js     801066f0 <sys_bjf_validation_process+0xb0>
8010665c:	83 ec 08             	sub    $0x8,%esp
8010665f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106662:	50                   	push   %eax
80106663:	6a 01                	push   $0x1
80106665:	e8 76 ec ff ff       	call   801052e0 <argint>
8010666a:	83 c4 10             	add    $0x10,%esp
8010666d:	85 c0                	test   %eax,%eax
8010666f:	78 7f                	js     801066f0 <sys_bjf_validation_process+0xb0>
80106671:	83 ec 08             	sub    $0x8,%esp
80106674:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106677:	50                   	push   %eax
80106678:	6a 02                	push   $0x2
8010667a:	e8 61 ec ff ff       	call   801052e0 <argint>
8010667f:	83 c4 10             	add    $0x10,%esp
80106682:	85 c0                	test   %eax,%eax
80106684:	78 6a                	js     801066f0 <sys_bjf_validation_process+0xb0>
80106686:	83 ec 08             	sub    $0x8,%esp
80106689:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010668c:	50                   	push   %eax
8010668d:	6a 03                	push   $0x3
8010668f:	e8 4c ec ff ff       	call   801052e0 <argint>
80106694:	83 c4 10             	add    $0x10,%esp
80106697:	85 c0                	test   %eax,%eax
80106699:	78 55                	js     801066f0 <sys_bjf_validation_process+0xb0>
8010669b:	83 ec 08             	sub    $0x8,%esp
8010669e:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066a1:	50                   	push   %eax
801066a2:	6a 04                	push   $0x4
801066a4:	e8 37 ec ff ff       	call   801052e0 <argint>
801066a9:	83 c4 10             	add    $0x10,%esp
801066ac:	85 c0                	test   %eax,%eax
801066ae:	78 40                	js     801066f0 <sys_bjf_validation_process+0xb0>
  {
    return -1;
  }
  struct proc *p = find_proc(pid);
801066b0:	83 ec 0c             	sub    $0xc,%esp
801066b3:	ff 75 e4             	push   -0x1c(%ebp)
801066b6:	e8 25 d6 ff ff       	call   80103ce0 <find_proc>
  p->priority_ratio = (float)priority_ratio;
801066bb:	db 45 e8             	fildl  -0x18(%ebp)
  p->creation_time_ratio = (float)creation_time_ratio;
  p->executed_cycle_ratio = (float)exec_cycle_ratio;
  p->process_size_ratio = (float)size_ratio;

  return 0;
801066be:	83 c4 10             	add    $0x10,%esp
  p->priority_ratio = (float)priority_ratio;
801066c1:	d9 98 8c 00 00 00    	fstps  0x8c(%eax)
  p->creation_time_ratio = (float)creation_time_ratio;
801066c7:	db 45 ec             	fildl  -0x14(%ebp)
801066ca:	d9 98 90 00 00 00    	fstps  0x90(%eax)
  p->executed_cycle_ratio = (float)exec_cycle_ratio;
801066d0:	db 45 f0             	fildl  -0x10(%ebp)
801066d3:	d9 98 98 00 00 00    	fstps  0x98(%eax)
  p->process_size_ratio = (float)size_ratio;
801066d9:	db 45 f4             	fildl  -0xc(%ebp)
801066dc:	d9 98 9c 00 00 00    	fstps  0x9c(%eax)
  return 0;
801066e2:	31 c0                	xor    %eax,%eax
}
801066e4:	c9                   	leave  
801066e5:	c3                   	ret    
801066e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ed:	8d 76 00             	lea    0x0(%esi),%esi
801066f0:	c9                   	leave  
    return -1;
801066f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066f6:	c3                   	ret    
801066f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066fe:	66 90                	xchg   %ax,%ax

80106700 <sys_bjf_validation_system>:
int sys_bjf_validation_system(void)
{
80106700:	55                   	push   %ebp
80106701:	89 e5                	mov    %esp,%ebp
80106703:	83 ec 20             	sub    $0x20,%esp
  int priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argint(0, &priority_ratio) < 0 || argint(1, &creation_time_ratio) < 0 || argint(2, &exec_cycle_ratio) < 0 || argint(3, &size_ratio) < 0)
80106706:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106709:	50                   	push   %eax
8010670a:	6a 00                	push   $0x0
8010670c:	e8 cf eb ff ff       	call   801052e0 <argint>
80106711:	83 c4 10             	add    $0x10,%esp
80106714:	85 c0                	test   %eax,%eax
80106716:	78 70                	js     80106788 <sys_bjf_validation_system+0x88>
80106718:	83 ec 08             	sub    $0x8,%esp
8010671b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010671e:	50                   	push   %eax
8010671f:	6a 01                	push   $0x1
80106721:	e8 ba eb ff ff       	call   801052e0 <argint>
80106726:	83 c4 10             	add    $0x10,%esp
80106729:	85 c0                	test   %eax,%eax
8010672b:	78 5b                	js     80106788 <sys_bjf_validation_system+0x88>
8010672d:	83 ec 08             	sub    $0x8,%esp
80106730:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106733:	50                   	push   %eax
80106734:	6a 02                	push   $0x2
80106736:	e8 a5 eb ff ff       	call   801052e0 <argint>
8010673b:	83 c4 10             	add    $0x10,%esp
8010673e:	85 c0                	test   %eax,%eax
80106740:	78 46                	js     80106788 <sys_bjf_validation_system+0x88>
80106742:	83 ec 08             	sub    $0x8,%esp
80106745:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106748:	50                   	push   %eax
80106749:	6a 03                	push   $0x3
8010674b:	e8 90 eb ff ff       	call   801052e0 <argint>
80106750:	83 c4 10             	add    $0x10,%esp
80106753:	85 c0                	test   %eax,%eax
80106755:	78 31                	js     80106788 <sys_bjf_validation_system+0x88>
  {
    return -1;
  }
  reset_bjf_attributes((float)priority_ratio, (float)creation_time_ratio,(float) exec_cycle_ratio,(float) size_ratio);
80106757:	db 45 f4             	fildl  -0xc(%ebp)
8010675a:	83 ec 10             	sub    $0x10,%esp
8010675d:	d9 5c 24 0c          	fstps  0xc(%esp)
80106761:	db 45 f0             	fildl  -0x10(%ebp)
80106764:	d9 5c 24 08          	fstps  0x8(%esp)
80106768:	db 45 ec             	fildl  -0x14(%ebp)
8010676b:	d9 5c 24 04          	fstps  0x4(%esp)
8010676f:	db 45 e8             	fildl  -0x18(%ebp)
80106772:	d9 1c 24             	fstps  (%esp)
80106775:	e8 06 d3 ff ff       	call   80103a80 <reset_bjf_attributes>
  return 0;
8010677a:	83 c4 10             	add    $0x10,%esp
8010677d:	31 c0                	xor    %eax,%eax
}
8010677f:	c9                   	leave  
80106780:	c3                   	ret    
80106781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106788:	c9                   	leave  
    return -1;
80106789:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010678e:	c3                   	ret    
8010678f:	90                   	nop

80106790 <sys_print_info>:
int sys_print_info(void)
{
80106790:	55                   	push   %ebp
80106791:	89 e5                	mov    %esp,%ebp
80106793:	83 ec 08             	sub    $0x8,%esp
  print_bitches();
80106796:	e8 55 d6 ff ff       	call   80103df0 <print_bitches>
  return 0;
8010679b:	31 c0                	xor    %eax,%eax
8010679d:	c9                   	leave  
8010679e:	c3                   	ret    

8010679f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010679f:	1e                   	push   %ds
  pushl %es
801067a0:	06                   	push   %es
  pushl %fs
801067a1:	0f a0                	push   %fs
  pushl %gs
801067a3:	0f a8                	push   %gs
  pushal
801067a5:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801067a6:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801067aa:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801067ac:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801067ae:	54                   	push   %esp
  call trap
801067af:	e8 cc 00 00 00       	call   80106880 <trap>
  addl $4, %esp
801067b4:	83 c4 04             	add    $0x4,%esp

801067b7 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801067b7:	61                   	popa   
  popl %gs
801067b8:	0f a9                	pop    %gs
  popl %fs
801067ba:	0f a1                	pop    %fs
  popl %es
801067bc:	07                   	pop    %es
  popl %ds
801067bd:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801067be:	83 c4 08             	add    $0x8,%esp
  iret
801067c1:	cf                   	iret   
801067c2:	66 90                	xchg   %ax,%ax
801067c4:	66 90                	xchg   %ax,%ax
801067c6:	66 90                	xchg   %ax,%ax
801067c8:	66 90                	xchg   %ax,%ax
801067ca:	66 90                	xchg   %ax,%ax
801067cc:	66 90                	xchg   %ax,%ax
801067ce:	66 90                	xchg   %ax,%ax

801067d0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801067d0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801067d1:	31 c0                	xor    %eax,%eax
{
801067d3:	89 e5                	mov    %esp,%ebp
801067d5:	83 ec 08             	sub    $0x8,%esp
801067d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067df:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801067e0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801067e7:	c7 04 c5 c2 55 11 80 	movl   $0x8e000008,-0x7feeaa3e(,%eax,8)
801067ee:	08 00 00 8e 
801067f2:	66 89 14 c5 c0 55 11 	mov    %dx,-0x7feeaa40(,%eax,8)
801067f9:	80 
801067fa:	c1 ea 10             	shr    $0x10,%edx
801067fd:	66 89 14 c5 c6 55 11 	mov    %dx,-0x7feeaa3a(,%eax,8)
80106804:	80 
  for(i = 0; i < 256; i++)
80106805:	83 c0 01             	add    $0x1,%eax
80106808:	3d 00 01 00 00       	cmp    $0x100,%eax
8010680d:	75 d1                	jne    801067e0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010680f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106812:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106817:	c7 05 c2 57 11 80 08 	movl   $0xef000008,0x801157c2
8010681e:	00 00 ef 
  initlock(&tickslock, "time");
80106821:	68 ef 89 10 80       	push   $0x801089ef
80106826:	68 80 55 11 80       	push   $0x80115580
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010682b:	66 a3 c0 57 11 80    	mov    %ax,0x801157c0
80106831:	c1 e8 10             	shr    $0x10,%eax
80106834:	66 a3 c6 57 11 80    	mov    %ax,0x801157c6
  initlock(&tickslock, "time");
8010683a:	e8 11 e5 ff ff       	call   80104d50 <initlock>
}
8010683f:	83 c4 10             	add    $0x10,%esp
80106842:	c9                   	leave  
80106843:	c3                   	ret    
80106844:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010684b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010684f:	90                   	nop

80106850 <idtinit>:

void
idtinit(void)
{
80106850:	55                   	push   %ebp
  pd[0] = size-1;
80106851:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106856:	89 e5                	mov    %esp,%ebp
80106858:	83 ec 10             	sub    $0x10,%esp
8010685b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010685f:	b8 c0 55 11 80       	mov    $0x801155c0,%eax
80106864:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106868:	c1 e8 10             	shr    $0x10,%eax
8010686b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010686f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106872:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106875:	c9                   	leave  
80106876:	c3                   	ret    
80106877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010687e:	66 90                	xchg   %ax,%ax

80106880 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	57                   	push   %edi
80106884:	56                   	push   %esi
80106885:	53                   	push   %ebx
80106886:	83 ec 1c             	sub    $0x1c,%esp
80106889:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010688c:	8b 43 30             	mov    0x30(%ebx),%eax
8010688f:	83 f8 40             	cmp    $0x40,%eax
80106892:	0f 84 68 01 00 00    	je     80106a00 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106898:	83 e8 20             	sub    $0x20,%eax
8010689b:	83 f8 1f             	cmp    $0x1f,%eax
8010689e:	0f 87 8c 00 00 00    	ja     80106930 <trap+0xb0>
801068a4:	ff 24 85 98 8a 10 80 	jmp    *-0x7fef7568(,%eax,4)
801068ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068af:	90                   	nop
      aging();
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801068b0:	e8 8b b9 ff ff       	call   80102240 <ideintr>
    lapiceoi();
801068b5:	e8 56 c0 ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801068ba:	e8 51 d2 ff ff       	call   80103b10 <myproc>
801068bf:	85 c0                	test   %eax,%eax
801068c1:	74 1d                	je     801068e0 <trap+0x60>
801068c3:	e8 48 d2 ff ff       	call   80103b10 <myproc>
801068c8:	8b 50 30             	mov    0x30(%eax),%edx
801068cb:	85 d2                	test   %edx,%edx
801068cd:	74 11                	je     801068e0 <trap+0x60>
801068cf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801068d3:	83 e0 03             	and    $0x3,%eax
801068d6:	66 83 f8 03          	cmp    $0x3,%ax
801068da:	0f 84 f0 01 00 00    	je     80106ad0 <trap+0x250>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801068e0:	e8 2b d2 ff ff       	call   80103b10 <myproc>
801068e5:	85 c0                	test   %eax,%eax
801068e7:	74 0f                	je     801068f8 <trap+0x78>
801068e9:	e8 22 d2 ff ff       	call   80103b10 <myproc>
801068ee:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801068f2:	0f 84 b8 00 00 00    	je     801069b0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801068f8:	e8 13 d2 ff ff       	call   80103b10 <myproc>
801068fd:	85 c0                	test   %eax,%eax
801068ff:	74 1d                	je     8010691e <trap+0x9e>
80106901:	e8 0a d2 ff ff       	call   80103b10 <myproc>
80106906:	8b 40 30             	mov    0x30(%eax),%eax
80106909:	85 c0                	test   %eax,%eax
8010690b:	74 11                	je     8010691e <trap+0x9e>
8010690d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106911:	83 e0 03             	and    $0x3,%eax
80106914:	66 83 f8 03          	cmp    $0x3,%ax
80106918:	0f 84 0f 01 00 00    	je     80106a2d <trap+0x1ad>
    exit();
}
8010691e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106921:	5b                   	pop    %ebx
80106922:	5e                   	pop    %esi
80106923:	5f                   	pop    %edi
80106924:	5d                   	pop    %ebp
80106925:	c3                   	ret    
80106926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010692d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106930:	e8 db d1 ff ff       	call   80103b10 <myproc>
80106935:	8b 7b 38             	mov    0x38(%ebx),%edi
80106938:	85 c0                	test   %eax,%eax
8010693a:	0f 84 aa 01 00 00    	je     80106aea <trap+0x26a>
80106940:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106944:	0f 84 a0 01 00 00    	je     80106aea <trap+0x26a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010694a:	0f 20 d1             	mov    %cr2,%ecx
8010694d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106950:	e8 8b d0 ff ff       	call   801039e0 <cpuid>
80106955:	8b 73 30             	mov    0x30(%ebx),%esi
80106958:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010695b:	8b 43 34             	mov    0x34(%ebx),%eax
8010695e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106961:	e8 aa d1 ff ff       	call   80103b10 <myproc>
80106966:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106969:	e8 a2 d1 ff ff       	call   80103b10 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010696e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106971:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106974:	51                   	push   %ecx
80106975:	57                   	push   %edi
80106976:	52                   	push   %edx
80106977:	ff 75 e4             	push   -0x1c(%ebp)
8010697a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010697b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010697e:	83 c6 78             	add    $0x78,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106981:	56                   	push   %esi
80106982:	ff 70 10             	push   0x10(%eax)
80106985:	68 54 8a 10 80       	push   $0x80108a54
8010698a:	e8 11 9d ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
8010698f:	83 c4 20             	add    $0x20,%esp
80106992:	e8 79 d1 ff ff       	call   80103b10 <myproc>
80106997:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010699e:	e8 6d d1 ff ff       	call   80103b10 <myproc>
801069a3:	85 c0                	test   %eax,%eax
801069a5:	0f 85 18 ff ff ff    	jne    801068c3 <trap+0x43>
801069ab:	e9 30 ff ff ff       	jmp    801068e0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
801069b0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801069b4:	0f 85 3e ff ff ff    	jne    801068f8 <trap+0x78>
    yield();
801069ba:	e8 21 df ff ff       	call   801048e0 <yield>
801069bf:	e9 34 ff ff ff       	jmp    801068f8 <trap+0x78>
801069c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801069c8:	8b 7b 38             	mov    0x38(%ebx),%edi
801069cb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801069cf:	e8 0c d0 ff ff       	call   801039e0 <cpuid>
801069d4:	57                   	push   %edi
801069d5:	56                   	push   %esi
801069d6:	50                   	push   %eax
801069d7:	68 fc 89 10 80       	push   $0x801089fc
801069dc:	e8 bf 9c ff ff       	call   801006a0 <cprintf>
    lapiceoi();
801069e1:	e8 2a bf ff ff       	call   80102910 <lapiceoi>
    break;
801069e6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801069e9:	e8 22 d1 ff ff       	call   80103b10 <myproc>
801069ee:	85 c0                	test   %eax,%eax
801069f0:	0f 85 cd fe ff ff    	jne    801068c3 <trap+0x43>
801069f6:	e9 e5 fe ff ff       	jmp    801068e0 <trap+0x60>
801069fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069ff:	90                   	nop
    if(myproc()->killed)
80106a00:	e8 0b d1 ff ff       	call   80103b10 <myproc>
80106a05:	8b 70 30             	mov    0x30(%eax),%esi
80106a08:	85 f6                	test   %esi,%esi
80106a0a:	0f 85 d0 00 00 00    	jne    80106ae0 <trap+0x260>
    myproc()->tf = tf;
80106a10:	e8 fb d0 ff ff       	call   80103b10 <myproc>
80106a15:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106a18:	e8 53 ea ff ff       	call   80105470 <syscall>
    if(myproc()->killed)
80106a1d:	e8 ee d0 ff ff       	call   80103b10 <myproc>
80106a22:	8b 48 30             	mov    0x30(%eax),%ecx
80106a25:	85 c9                	test   %ecx,%ecx
80106a27:	0f 84 f1 fe ff ff    	je     8010691e <trap+0x9e>
}
80106a2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a30:	5b                   	pop    %ebx
80106a31:	5e                   	pop    %esi
80106a32:	5f                   	pop    %edi
80106a33:	5d                   	pop    %ebp
      exit();
80106a34:	e9 47 dc ff ff       	jmp    80104680 <exit>
80106a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106a40:	e8 4b 02 00 00       	call   80106c90 <uartintr>
    lapiceoi();
80106a45:	e8 c6 be ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a4a:	e8 c1 d0 ff ff       	call   80103b10 <myproc>
80106a4f:	85 c0                	test   %eax,%eax
80106a51:	0f 85 6c fe ff ff    	jne    801068c3 <trap+0x43>
80106a57:	e9 84 fe ff ff       	jmp    801068e0 <trap+0x60>
80106a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106a60:	e8 6b bd ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80106a65:	e8 a6 be ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a6a:	e8 a1 d0 ff ff       	call   80103b10 <myproc>
80106a6f:	85 c0                	test   %eax,%eax
80106a71:	0f 85 4c fe ff ff    	jne    801068c3 <trap+0x43>
80106a77:	e9 64 fe ff ff       	jmp    801068e0 <trap+0x60>
80106a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106a80:	e8 5b cf ff ff       	call   801039e0 <cpuid>
80106a85:	85 c0                	test   %eax,%eax
80106a87:	0f 85 28 fe ff ff    	jne    801068b5 <trap+0x35>
      acquire(&tickslock);
80106a8d:	83 ec 0c             	sub    $0xc,%esp
80106a90:	68 80 55 11 80       	push   $0x80115580
80106a95:	e8 86 e4 ff ff       	call   80104f20 <acquire>
      wakeup(&ticks);
80106a9a:	c7 04 24 60 55 11 80 	movl   $0x80115560,(%esp)
      ticks++;
80106aa1:	83 05 60 55 11 80 01 	addl   $0x1,0x80115560
      wakeup(&ticks);
80106aa8:	e8 83 df ff ff       	call   80104a30 <wakeup>
      release(&tickslock);
80106aad:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)
80106ab4:	e8 07 e4 ff ff       	call   80104ec0 <release>
      aging();
80106ab9:	e8 42 cf ff ff       	call   80103a00 <aging>
80106abe:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106ac1:	e9 ef fd ff ff       	jmp    801068b5 <trap+0x35>
80106ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106acd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106ad0:	e8 ab db ff ff       	call   80104680 <exit>
80106ad5:	e9 06 fe ff ff       	jmp    801068e0 <trap+0x60>
80106ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106ae0:	e8 9b db ff ff       	call   80104680 <exit>
80106ae5:	e9 26 ff ff ff       	jmp    80106a10 <trap+0x190>
80106aea:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106aed:	e8 ee ce ff ff       	call   801039e0 <cpuid>
80106af2:	83 ec 0c             	sub    $0xc,%esp
80106af5:	56                   	push   %esi
80106af6:	57                   	push   %edi
80106af7:	50                   	push   %eax
80106af8:	ff 73 30             	push   0x30(%ebx)
80106afb:	68 20 8a 10 80       	push   $0x80108a20
80106b00:	e8 9b 9b ff ff       	call   801006a0 <cprintf>
      panic("trap");
80106b05:	83 c4 14             	add    $0x14,%esp
80106b08:	68 f4 89 10 80       	push   $0x801089f4
80106b0d:	e8 6e 98 ff ff       	call   80100380 <panic>
80106b12:	66 90                	xchg   %ax,%ax
80106b14:	66 90                	xchg   %ax,%ax
80106b16:	66 90                	xchg   %ax,%ax
80106b18:	66 90                	xchg   %ax,%ax
80106b1a:	66 90                	xchg   %ax,%ax
80106b1c:	66 90                	xchg   %ax,%ax
80106b1e:	66 90                	xchg   %ax,%ax

80106b20 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106b20:	a1 c0 5d 11 80       	mov    0x80115dc0,%eax
80106b25:	85 c0                	test   %eax,%eax
80106b27:	74 17                	je     80106b40 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b29:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106b2e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106b2f:	a8 01                	test   $0x1,%al
80106b31:	74 0d                	je     80106b40 <uartgetc+0x20>
80106b33:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b38:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106b39:	0f b6 c0             	movzbl %al,%eax
80106b3c:	c3                   	ret    
80106b3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b45:	c3                   	ret    
80106b46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b4d:	8d 76 00             	lea    0x0(%esi),%esi

80106b50 <uartinit>:
{
80106b50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b51:	31 c9                	xor    %ecx,%ecx
80106b53:	89 c8                	mov    %ecx,%eax
80106b55:	89 e5                	mov    %esp,%ebp
80106b57:	57                   	push   %edi
80106b58:	bf fa 03 00 00       	mov    $0x3fa,%edi
80106b5d:	56                   	push   %esi
80106b5e:	89 fa                	mov    %edi,%edx
80106b60:	53                   	push   %ebx
80106b61:	83 ec 1c             	sub    $0x1c,%esp
80106b64:	ee                   	out    %al,(%dx)
80106b65:	be fb 03 00 00       	mov    $0x3fb,%esi
80106b6a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106b6f:	89 f2                	mov    %esi,%edx
80106b71:	ee                   	out    %al,(%dx)
80106b72:	b8 0c 00 00 00       	mov    $0xc,%eax
80106b77:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b7c:	ee                   	out    %al,(%dx)
80106b7d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106b82:	89 c8                	mov    %ecx,%eax
80106b84:	89 da                	mov    %ebx,%edx
80106b86:	ee                   	out    %al,(%dx)
80106b87:	b8 03 00 00 00       	mov    $0x3,%eax
80106b8c:	89 f2                	mov    %esi,%edx
80106b8e:	ee                   	out    %al,(%dx)
80106b8f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106b94:	89 c8                	mov    %ecx,%eax
80106b96:	ee                   	out    %al,(%dx)
80106b97:	b8 01 00 00 00       	mov    $0x1,%eax
80106b9c:	89 da                	mov    %ebx,%edx
80106b9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b9f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106ba4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106ba5:	3c ff                	cmp    $0xff,%al
80106ba7:	74 78                	je     80106c21 <uartinit+0xd1>
  uart = 1;
80106ba9:	c7 05 c0 5d 11 80 01 	movl   $0x1,0x80115dc0
80106bb0:	00 00 00 
80106bb3:	89 fa                	mov    %edi,%edx
80106bb5:	ec                   	in     (%dx),%al
80106bb6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106bbb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106bbc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106bbf:	bf 18 8b 10 80       	mov    $0x80108b18,%edi
80106bc4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106bc9:	6a 00                	push   $0x0
80106bcb:	6a 04                	push   $0x4
80106bcd:	e8 ae b8 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106bd2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106bd6:	83 c4 10             	add    $0x10,%esp
80106bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106be0:	a1 c0 5d 11 80       	mov    0x80115dc0,%eax
80106be5:	bb 80 00 00 00       	mov    $0x80,%ebx
80106bea:	85 c0                	test   %eax,%eax
80106bec:	75 14                	jne    80106c02 <uartinit+0xb2>
80106bee:	eb 23                	jmp    80106c13 <uartinit+0xc3>
    microdelay(10);
80106bf0:	83 ec 0c             	sub    $0xc,%esp
80106bf3:	6a 0a                	push   $0xa
80106bf5:	e8 36 bd ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106bfa:	83 c4 10             	add    $0x10,%esp
80106bfd:	83 eb 01             	sub    $0x1,%ebx
80106c00:	74 07                	je     80106c09 <uartinit+0xb9>
80106c02:	89 f2                	mov    %esi,%edx
80106c04:	ec                   	in     (%dx),%al
80106c05:	a8 20                	test   $0x20,%al
80106c07:	74 e7                	je     80106bf0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106c09:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106c0d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c12:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106c13:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106c17:	83 c7 01             	add    $0x1,%edi
80106c1a:	88 45 e7             	mov    %al,-0x19(%ebp)
80106c1d:	84 c0                	test   %al,%al
80106c1f:	75 bf                	jne    80106be0 <uartinit+0x90>
}
80106c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c24:	5b                   	pop    %ebx
80106c25:	5e                   	pop    %esi
80106c26:	5f                   	pop    %edi
80106c27:	5d                   	pop    %ebp
80106c28:	c3                   	ret    
80106c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c30 <uartputc>:
  if(!uart)
80106c30:	a1 c0 5d 11 80       	mov    0x80115dc0,%eax
80106c35:	85 c0                	test   %eax,%eax
80106c37:	74 47                	je     80106c80 <uartputc+0x50>
{
80106c39:	55                   	push   %ebp
80106c3a:	89 e5                	mov    %esp,%ebp
80106c3c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106c3d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106c42:	53                   	push   %ebx
80106c43:	bb 80 00 00 00       	mov    $0x80,%ebx
80106c48:	eb 18                	jmp    80106c62 <uartputc+0x32>
80106c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106c50:	83 ec 0c             	sub    $0xc,%esp
80106c53:	6a 0a                	push   $0xa
80106c55:	e8 d6 bc ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c5a:	83 c4 10             	add    $0x10,%esp
80106c5d:	83 eb 01             	sub    $0x1,%ebx
80106c60:	74 07                	je     80106c69 <uartputc+0x39>
80106c62:	89 f2                	mov    %esi,%edx
80106c64:	ec                   	in     (%dx),%al
80106c65:	a8 20                	test   $0x20,%al
80106c67:	74 e7                	je     80106c50 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106c69:	8b 45 08             	mov    0x8(%ebp),%eax
80106c6c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c71:	ee                   	out    %al,(%dx)
}
80106c72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106c75:	5b                   	pop    %ebx
80106c76:	5e                   	pop    %esi
80106c77:	5d                   	pop    %ebp
80106c78:	c3                   	ret    
80106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c80:	c3                   	ret    
80106c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c8f:	90                   	nop

80106c90 <uartintr>:

void
uartintr(void)
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106c96:	68 20 6b 10 80       	push   $0x80106b20
80106c9b:	e8 e0 9b ff ff       	call   80100880 <consoleintr>
}
80106ca0:	83 c4 10             	add    $0x10,%esp
80106ca3:	c9                   	leave  
80106ca4:	c3                   	ret    

80106ca5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106ca5:	6a 00                	push   $0x0
  pushl $0
80106ca7:	6a 00                	push   $0x0
  jmp alltraps
80106ca9:	e9 f1 fa ff ff       	jmp    8010679f <alltraps>

80106cae <vector1>:
.globl vector1
vector1:
  pushl $0
80106cae:	6a 00                	push   $0x0
  pushl $1
80106cb0:	6a 01                	push   $0x1
  jmp alltraps
80106cb2:	e9 e8 fa ff ff       	jmp    8010679f <alltraps>

80106cb7 <vector2>:
.globl vector2
vector2:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $2
80106cb9:	6a 02                	push   $0x2
  jmp alltraps
80106cbb:	e9 df fa ff ff       	jmp    8010679f <alltraps>

80106cc0 <vector3>:
.globl vector3
vector3:
  pushl $0
80106cc0:	6a 00                	push   $0x0
  pushl $3
80106cc2:	6a 03                	push   $0x3
  jmp alltraps
80106cc4:	e9 d6 fa ff ff       	jmp    8010679f <alltraps>

80106cc9 <vector4>:
.globl vector4
vector4:
  pushl $0
80106cc9:	6a 00                	push   $0x0
  pushl $4
80106ccb:	6a 04                	push   $0x4
  jmp alltraps
80106ccd:	e9 cd fa ff ff       	jmp    8010679f <alltraps>

80106cd2 <vector5>:
.globl vector5
vector5:
  pushl $0
80106cd2:	6a 00                	push   $0x0
  pushl $5
80106cd4:	6a 05                	push   $0x5
  jmp alltraps
80106cd6:	e9 c4 fa ff ff       	jmp    8010679f <alltraps>

80106cdb <vector6>:
.globl vector6
vector6:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $6
80106cdd:	6a 06                	push   $0x6
  jmp alltraps
80106cdf:	e9 bb fa ff ff       	jmp    8010679f <alltraps>

80106ce4 <vector7>:
.globl vector7
vector7:
  pushl $0
80106ce4:	6a 00                	push   $0x0
  pushl $7
80106ce6:	6a 07                	push   $0x7
  jmp alltraps
80106ce8:	e9 b2 fa ff ff       	jmp    8010679f <alltraps>

80106ced <vector8>:
.globl vector8
vector8:
  pushl $8
80106ced:	6a 08                	push   $0x8
  jmp alltraps
80106cef:	e9 ab fa ff ff       	jmp    8010679f <alltraps>

80106cf4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106cf4:	6a 00                	push   $0x0
  pushl $9
80106cf6:	6a 09                	push   $0x9
  jmp alltraps
80106cf8:	e9 a2 fa ff ff       	jmp    8010679f <alltraps>

80106cfd <vector10>:
.globl vector10
vector10:
  pushl $10
80106cfd:	6a 0a                	push   $0xa
  jmp alltraps
80106cff:	e9 9b fa ff ff       	jmp    8010679f <alltraps>

80106d04 <vector11>:
.globl vector11
vector11:
  pushl $11
80106d04:	6a 0b                	push   $0xb
  jmp alltraps
80106d06:	e9 94 fa ff ff       	jmp    8010679f <alltraps>

80106d0b <vector12>:
.globl vector12
vector12:
  pushl $12
80106d0b:	6a 0c                	push   $0xc
  jmp alltraps
80106d0d:	e9 8d fa ff ff       	jmp    8010679f <alltraps>

80106d12 <vector13>:
.globl vector13
vector13:
  pushl $13
80106d12:	6a 0d                	push   $0xd
  jmp alltraps
80106d14:	e9 86 fa ff ff       	jmp    8010679f <alltraps>

80106d19 <vector14>:
.globl vector14
vector14:
  pushl $14
80106d19:	6a 0e                	push   $0xe
  jmp alltraps
80106d1b:	e9 7f fa ff ff       	jmp    8010679f <alltraps>

80106d20 <vector15>:
.globl vector15
vector15:
  pushl $0
80106d20:	6a 00                	push   $0x0
  pushl $15
80106d22:	6a 0f                	push   $0xf
  jmp alltraps
80106d24:	e9 76 fa ff ff       	jmp    8010679f <alltraps>

80106d29 <vector16>:
.globl vector16
vector16:
  pushl $0
80106d29:	6a 00                	push   $0x0
  pushl $16
80106d2b:	6a 10                	push   $0x10
  jmp alltraps
80106d2d:	e9 6d fa ff ff       	jmp    8010679f <alltraps>

80106d32 <vector17>:
.globl vector17
vector17:
  pushl $17
80106d32:	6a 11                	push   $0x11
  jmp alltraps
80106d34:	e9 66 fa ff ff       	jmp    8010679f <alltraps>

80106d39 <vector18>:
.globl vector18
vector18:
  pushl $0
80106d39:	6a 00                	push   $0x0
  pushl $18
80106d3b:	6a 12                	push   $0x12
  jmp alltraps
80106d3d:	e9 5d fa ff ff       	jmp    8010679f <alltraps>

80106d42 <vector19>:
.globl vector19
vector19:
  pushl $0
80106d42:	6a 00                	push   $0x0
  pushl $19
80106d44:	6a 13                	push   $0x13
  jmp alltraps
80106d46:	e9 54 fa ff ff       	jmp    8010679f <alltraps>

80106d4b <vector20>:
.globl vector20
vector20:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $20
80106d4d:	6a 14                	push   $0x14
  jmp alltraps
80106d4f:	e9 4b fa ff ff       	jmp    8010679f <alltraps>

80106d54 <vector21>:
.globl vector21
vector21:
  pushl $0
80106d54:	6a 00                	push   $0x0
  pushl $21
80106d56:	6a 15                	push   $0x15
  jmp alltraps
80106d58:	e9 42 fa ff ff       	jmp    8010679f <alltraps>

80106d5d <vector22>:
.globl vector22
vector22:
  pushl $0
80106d5d:	6a 00                	push   $0x0
  pushl $22
80106d5f:	6a 16                	push   $0x16
  jmp alltraps
80106d61:	e9 39 fa ff ff       	jmp    8010679f <alltraps>

80106d66 <vector23>:
.globl vector23
vector23:
  pushl $0
80106d66:	6a 00                	push   $0x0
  pushl $23
80106d68:	6a 17                	push   $0x17
  jmp alltraps
80106d6a:	e9 30 fa ff ff       	jmp    8010679f <alltraps>

80106d6f <vector24>:
.globl vector24
vector24:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $24
80106d71:	6a 18                	push   $0x18
  jmp alltraps
80106d73:	e9 27 fa ff ff       	jmp    8010679f <alltraps>

80106d78 <vector25>:
.globl vector25
vector25:
  pushl $0
80106d78:	6a 00                	push   $0x0
  pushl $25
80106d7a:	6a 19                	push   $0x19
  jmp alltraps
80106d7c:	e9 1e fa ff ff       	jmp    8010679f <alltraps>

80106d81 <vector26>:
.globl vector26
vector26:
  pushl $0
80106d81:	6a 00                	push   $0x0
  pushl $26
80106d83:	6a 1a                	push   $0x1a
  jmp alltraps
80106d85:	e9 15 fa ff ff       	jmp    8010679f <alltraps>

80106d8a <vector27>:
.globl vector27
vector27:
  pushl $0
80106d8a:	6a 00                	push   $0x0
  pushl $27
80106d8c:	6a 1b                	push   $0x1b
  jmp alltraps
80106d8e:	e9 0c fa ff ff       	jmp    8010679f <alltraps>

80106d93 <vector28>:
.globl vector28
vector28:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $28
80106d95:	6a 1c                	push   $0x1c
  jmp alltraps
80106d97:	e9 03 fa ff ff       	jmp    8010679f <alltraps>

80106d9c <vector29>:
.globl vector29
vector29:
  pushl $0
80106d9c:	6a 00                	push   $0x0
  pushl $29
80106d9e:	6a 1d                	push   $0x1d
  jmp alltraps
80106da0:	e9 fa f9 ff ff       	jmp    8010679f <alltraps>

80106da5 <vector30>:
.globl vector30
vector30:
  pushl $0
80106da5:	6a 00                	push   $0x0
  pushl $30
80106da7:	6a 1e                	push   $0x1e
  jmp alltraps
80106da9:	e9 f1 f9 ff ff       	jmp    8010679f <alltraps>

80106dae <vector31>:
.globl vector31
vector31:
  pushl $0
80106dae:	6a 00                	push   $0x0
  pushl $31
80106db0:	6a 1f                	push   $0x1f
  jmp alltraps
80106db2:	e9 e8 f9 ff ff       	jmp    8010679f <alltraps>

80106db7 <vector32>:
.globl vector32
vector32:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $32
80106db9:	6a 20                	push   $0x20
  jmp alltraps
80106dbb:	e9 df f9 ff ff       	jmp    8010679f <alltraps>

80106dc0 <vector33>:
.globl vector33
vector33:
  pushl $0
80106dc0:	6a 00                	push   $0x0
  pushl $33
80106dc2:	6a 21                	push   $0x21
  jmp alltraps
80106dc4:	e9 d6 f9 ff ff       	jmp    8010679f <alltraps>

80106dc9 <vector34>:
.globl vector34
vector34:
  pushl $0
80106dc9:	6a 00                	push   $0x0
  pushl $34
80106dcb:	6a 22                	push   $0x22
  jmp alltraps
80106dcd:	e9 cd f9 ff ff       	jmp    8010679f <alltraps>

80106dd2 <vector35>:
.globl vector35
vector35:
  pushl $0
80106dd2:	6a 00                	push   $0x0
  pushl $35
80106dd4:	6a 23                	push   $0x23
  jmp alltraps
80106dd6:	e9 c4 f9 ff ff       	jmp    8010679f <alltraps>

80106ddb <vector36>:
.globl vector36
vector36:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $36
80106ddd:	6a 24                	push   $0x24
  jmp alltraps
80106ddf:	e9 bb f9 ff ff       	jmp    8010679f <alltraps>

80106de4 <vector37>:
.globl vector37
vector37:
  pushl $0
80106de4:	6a 00                	push   $0x0
  pushl $37
80106de6:	6a 25                	push   $0x25
  jmp alltraps
80106de8:	e9 b2 f9 ff ff       	jmp    8010679f <alltraps>

80106ded <vector38>:
.globl vector38
vector38:
  pushl $0
80106ded:	6a 00                	push   $0x0
  pushl $38
80106def:	6a 26                	push   $0x26
  jmp alltraps
80106df1:	e9 a9 f9 ff ff       	jmp    8010679f <alltraps>

80106df6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106df6:	6a 00                	push   $0x0
  pushl $39
80106df8:	6a 27                	push   $0x27
  jmp alltraps
80106dfa:	e9 a0 f9 ff ff       	jmp    8010679f <alltraps>

80106dff <vector40>:
.globl vector40
vector40:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $40
80106e01:	6a 28                	push   $0x28
  jmp alltraps
80106e03:	e9 97 f9 ff ff       	jmp    8010679f <alltraps>

80106e08 <vector41>:
.globl vector41
vector41:
  pushl $0
80106e08:	6a 00                	push   $0x0
  pushl $41
80106e0a:	6a 29                	push   $0x29
  jmp alltraps
80106e0c:	e9 8e f9 ff ff       	jmp    8010679f <alltraps>

80106e11 <vector42>:
.globl vector42
vector42:
  pushl $0
80106e11:	6a 00                	push   $0x0
  pushl $42
80106e13:	6a 2a                	push   $0x2a
  jmp alltraps
80106e15:	e9 85 f9 ff ff       	jmp    8010679f <alltraps>

80106e1a <vector43>:
.globl vector43
vector43:
  pushl $0
80106e1a:	6a 00                	push   $0x0
  pushl $43
80106e1c:	6a 2b                	push   $0x2b
  jmp alltraps
80106e1e:	e9 7c f9 ff ff       	jmp    8010679f <alltraps>

80106e23 <vector44>:
.globl vector44
vector44:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $44
80106e25:	6a 2c                	push   $0x2c
  jmp alltraps
80106e27:	e9 73 f9 ff ff       	jmp    8010679f <alltraps>

80106e2c <vector45>:
.globl vector45
vector45:
  pushl $0
80106e2c:	6a 00                	push   $0x0
  pushl $45
80106e2e:	6a 2d                	push   $0x2d
  jmp alltraps
80106e30:	e9 6a f9 ff ff       	jmp    8010679f <alltraps>

80106e35 <vector46>:
.globl vector46
vector46:
  pushl $0
80106e35:	6a 00                	push   $0x0
  pushl $46
80106e37:	6a 2e                	push   $0x2e
  jmp alltraps
80106e39:	e9 61 f9 ff ff       	jmp    8010679f <alltraps>

80106e3e <vector47>:
.globl vector47
vector47:
  pushl $0
80106e3e:	6a 00                	push   $0x0
  pushl $47
80106e40:	6a 2f                	push   $0x2f
  jmp alltraps
80106e42:	e9 58 f9 ff ff       	jmp    8010679f <alltraps>

80106e47 <vector48>:
.globl vector48
vector48:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $48
80106e49:	6a 30                	push   $0x30
  jmp alltraps
80106e4b:	e9 4f f9 ff ff       	jmp    8010679f <alltraps>

80106e50 <vector49>:
.globl vector49
vector49:
  pushl $0
80106e50:	6a 00                	push   $0x0
  pushl $49
80106e52:	6a 31                	push   $0x31
  jmp alltraps
80106e54:	e9 46 f9 ff ff       	jmp    8010679f <alltraps>

80106e59 <vector50>:
.globl vector50
vector50:
  pushl $0
80106e59:	6a 00                	push   $0x0
  pushl $50
80106e5b:	6a 32                	push   $0x32
  jmp alltraps
80106e5d:	e9 3d f9 ff ff       	jmp    8010679f <alltraps>

80106e62 <vector51>:
.globl vector51
vector51:
  pushl $0
80106e62:	6a 00                	push   $0x0
  pushl $51
80106e64:	6a 33                	push   $0x33
  jmp alltraps
80106e66:	e9 34 f9 ff ff       	jmp    8010679f <alltraps>

80106e6b <vector52>:
.globl vector52
vector52:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $52
80106e6d:	6a 34                	push   $0x34
  jmp alltraps
80106e6f:	e9 2b f9 ff ff       	jmp    8010679f <alltraps>

80106e74 <vector53>:
.globl vector53
vector53:
  pushl $0
80106e74:	6a 00                	push   $0x0
  pushl $53
80106e76:	6a 35                	push   $0x35
  jmp alltraps
80106e78:	e9 22 f9 ff ff       	jmp    8010679f <alltraps>

80106e7d <vector54>:
.globl vector54
vector54:
  pushl $0
80106e7d:	6a 00                	push   $0x0
  pushl $54
80106e7f:	6a 36                	push   $0x36
  jmp alltraps
80106e81:	e9 19 f9 ff ff       	jmp    8010679f <alltraps>

80106e86 <vector55>:
.globl vector55
vector55:
  pushl $0
80106e86:	6a 00                	push   $0x0
  pushl $55
80106e88:	6a 37                	push   $0x37
  jmp alltraps
80106e8a:	e9 10 f9 ff ff       	jmp    8010679f <alltraps>

80106e8f <vector56>:
.globl vector56
vector56:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $56
80106e91:	6a 38                	push   $0x38
  jmp alltraps
80106e93:	e9 07 f9 ff ff       	jmp    8010679f <alltraps>

80106e98 <vector57>:
.globl vector57
vector57:
  pushl $0
80106e98:	6a 00                	push   $0x0
  pushl $57
80106e9a:	6a 39                	push   $0x39
  jmp alltraps
80106e9c:	e9 fe f8 ff ff       	jmp    8010679f <alltraps>

80106ea1 <vector58>:
.globl vector58
vector58:
  pushl $0
80106ea1:	6a 00                	push   $0x0
  pushl $58
80106ea3:	6a 3a                	push   $0x3a
  jmp alltraps
80106ea5:	e9 f5 f8 ff ff       	jmp    8010679f <alltraps>

80106eaa <vector59>:
.globl vector59
vector59:
  pushl $0
80106eaa:	6a 00                	push   $0x0
  pushl $59
80106eac:	6a 3b                	push   $0x3b
  jmp alltraps
80106eae:	e9 ec f8 ff ff       	jmp    8010679f <alltraps>

80106eb3 <vector60>:
.globl vector60
vector60:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $60
80106eb5:	6a 3c                	push   $0x3c
  jmp alltraps
80106eb7:	e9 e3 f8 ff ff       	jmp    8010679f <alltraps>

80106ebc <vector61>:
.globl vector61
vector61:
  pushl $0
80106ebc:	6a 00                	push   $0x0
  pushl $61
80106ebe:	6a 3d                	push   $0x3d
  jmp alltraps
80106ec0:	e9 da f8 ff ff       	jmp    8010679f <alltraps>

80106ec5 <vector62>:
.globl vector62
vector62:
  pushl $0
80106ec5:	6a 00                	push   $0x0
  pushl $62
80106ec7:	6a 3e                	push   $0x3e
  jmp alltraps
80106ec9:	e9 d1 f8 ff ff       	jmp    8010679f <alltraps>

80106ece <vector63>:
.globl vector63
vector63:
  pushl $0
80106ece:	6a 00                	push   $0x0
  pushl $63
80106ed0:	6a 3f                	push   $0x3f
  jmp alltraps
80106ed2:	e9 c8 f8 ff ff       	jmp    8010679f <alltraps>

80106ed7 <vector64>:
.globl vector64
vector64:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $64
80106ed9:	6a 40                	push   $0x40
  jmp alltraps
80106edb:	e9 bf f8 ff ff       	jmp    8010679f <alltraps>

80106ee0 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ee0:	6a 00                	push   $0x0
  pushl $65
80106ee2:	6a 41                	push   $0x41
  jmp alltraps
80106ee4:	e9 b6 f8 ff ff       	jmp    8010679f <alltraps>

80106ee9 <vector66>:
.globl vector66
vector66:
  pushl $0
80106ee9:	6a 00                	push   $0x0
  pushl $66
80106eeb:	6a 42                	push   $0x42
  jmp alltraps
80106eed:	e9 ad f8 ff ff       	jmp    8010679f <alltraps>

80106ef2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106ef2:	6a 00                	push   $0x0
  pushl $67
80106ef4:	6a 43                	push   $0x43
  jmp alltraps
80106ef6:	e9 a4 f8 ff ff       	jmp    8010679f <alltraps>

80106efb <vector68>:
.globl vector68
vector68:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $68
80106efd:	6a 44                	push   $0x44
  jmp alltraps
80106eff:	e9 9b f8 ff ff       	jmp    8010679f <alltraps>

80106f04 <vector69>:
.globl vector69
vector69:
  pushl $0
80106f04:	6a 00                	push   $0x0
  pushl $69
80106f06:	6a 45                	push   $0x45
  jmp alltraps
80106f08:	e9 92 f8 ff ff       	jmp    8010679f <alltraps>

80106f0d <vector70>:
.globl vector70
vector70:
  pushl $0
80106f0d:	6a 00                	push   $0x0
  pushl $70
80106f0f:	6a 46                	push   $0x46
  jmp alltraps
80106f11:	e9 89 f8 ff ff       	jmp    8010679f <alltraps>

80106f16 <vector71>:
.globl vector71
vector71:
  pushl $0
80106f16:	6a 00                	push   $0x0
  pushl $71
80106f18:	6a 47                	push   $0x47
  jmp alltraps
80106f1a:	e9 80 f8 ff ff       	jmp    8010679f <alltraps>

80106f1f <vector72>:
.globl vector72
vector72:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $72
80106f21:	6a 48                	push   $0x48
  jmp alltraps
80106f23:	e9 77 f8 ff ff       	jmp    8010679f <alltraps>

80106f28 <vector73>:
.globl vector73
vector73:
  pushl $0
80106f28:	6a 00                	push   $0x0
  pushl $73
80106f2a:	6a 49                	push   $0x49
  jmp alltraps
80106f2c:	e9 6e f8 ff ff       	jmp    8010679f <alltraps>

80106f31 <vector74>:
.globl vector74
vector74:
  pushl $0
80106f31:	6a 00                	push   $0x0
  pushl $74
80106f33:	6a 4a                	push   $0x4a
  jmp alltraps
80106f35:	e9 65 f8 ff ff       	jmp    8010679f <alltraps>

80106f3a <vector75>:
.globl vector75
vector75:
  pushl $0
80106f3a:	6a 00                	push   $0x0
  pushl $75
80106f3c:	6a 4b                	push   $0x4b
  jmp alltraps
80106f3e:	e9 5c f8 ff ff       	jmp    8010679f <alltraps>

80106f43 <vector76>:
.globl vector76
vector76:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $76
80106f45:	6a 4c                	push   $0x4c
  jmp alltraps
80106f47:	e9 53 f8 ff ff       	jmp    8010679f <alltraps>

80106f4c <vector77>:
.globl vector77
vector77:
  pushl $0
80106f4c:	6a 00                	push   $0x0
  pushl $77
80106f4e:	6a 4d                	push   $0x4d
  jmp alltraps
80106f50:	e9 4a f8 ff ff       	jmp    8010679f <alltraps>

80106f55 <vector78>:
.globl vector78
vector78:
  pushl $0
80106f55:	6a 00                	push   $0x0
  pushl $78
80106f57:	6a 4e                	push   $0x4e
  jmp alltraps
80106f59:	e9 41 f8 ff ff       	jmp    8010679f <alltraps>

80106f5e <vector79>:
.globl vector79
vector79:
  pushl $0
80106f5e:	6a 00                	push   $0x0
  pushl $79
80106f60:	6a 4f                	push   $0x4f
  jmp alltraps
80106f62:	e9 38 f8 ff ff       	jmp    8010679f <alltraps>

80106f67 <vector80>:
.globl vector80
vector80:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $80
80106f69:	6a 50                	push   $0x50
  jmp alltraps
80106f6b:	e9 2f f8 ff ff       	jmp    8010679f <alltraps>

80106f70 <vector81>:
.globl vector81
vector81:
  pushl $0
80106f70:	6a 00                	push   $0x0
  pushl $81
80106f72:	6a 51                	push   $0x51
  jmp alltraps
80106f74:	e9 26 f8 ff ff       	jmp    8010679f <alltraps>

80106f79 <vector82>:
.globl vector82
vector82:
  pushl $0
80106f79:	6a 00                	push   $0x0
  pushl $82
80106f7b:	6a 52                	push   $0x52
  jmp alltraps
80106f7d:	e9 1d f8 ff ff       	jmp    8010679f <alltraps>

80106f82 <vector83>:
.globl vector83
vector83:
  pushl $0
80106f82:	6a 00                	push   $0x0
  pushl $83
80106f84:	6a 53                	push   $0x53
  jmp alltraps
80106f86:	e9 14 f8 ff ff       	jmp    8010679f <alltraps>

80106f8b <vector84>:
.globl vector84
vector84:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $84
80106f8d:	6a 54                	push   $0x54
  jmp alltraps
80106f8f:	e9 0b f8 ff ff       	jmp    8010679f <alltraps>

80106f94 <vector85>:
.globl vector85
vector85:
  pushl $0
80106f94:	6a 00                	push   $0x0
  pushl $85
80106f96:	6a 55                	push   $0x55
  jmp alltraps
80106f98:	e9 02 f8 ff ff       	jmp    8010679f <alltraps>

80106f9d <vector86>:
.globl vector86
vector86:
  pushl $0
80106f9d:	6a 00                	push   $0x0
  pushl $86
80106f9f:	6a 56                	push   $0x56
  jmp alltraps
80106fa1:	e9 f9 f7 ff ff       	jmp    8010679f <alltraps>

80106fa6 <vector87>:
.globl vector87
vector87:
  pushl $0
80106fa6:	6a 00                	push   $0x0
  pushl $87
80106fa8:	6a 57                	push   $0x57
  jmp alltraps
80106faa:	e9 f0 f7 ff ff       	jmp    8010679f <alltraps>

80106faf <vector88>:
.globl vector88
vector88:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $88
80106fb1:	6a 58                	push   $0x58
  jmp alltraps
80106fb3:	e9 e7 f7 ff ff       	jmp    8010679f <alltraps>

80106fb8 <vector89>:
.globl vector89
vector89:
  pushl $0
80106fb8:	6a 00                	push   $0x0
  pushl $89
80106fba:	6a 59                	push   $0x59
  jmp alltraps
80106fbc:	e9 de f7 ff ff       	jmp    8010679f <alltraps>

80106fc1 <vector90>:
.globl vector90
vector90:
  pushl $0
80106fc1:	6a 00                	push   $0x0
  pushl $90
80106fc3:	6a 5a                	push   $0x5a
  jmp alltraps
80106fc5:	e9 d5 f7 ff ff       	jmp    8010679f <alltraps>

80106fca <vector91>:
.globl vector91
vector91:
  pushl $0
80106fca:	6a 00                	push   $0x0
  pushl $91
80106fcc:	6a 5b                	push   $0x5b
  jmp alltraps
80106fce:	e9 cc f7 ff ff       	jmp    8010679f <alltraps>

80106fd3 <vector92>:
.globl vector92
vector92:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $92
80106fd5:	6a 5c                	push   $0x5c
  jmp alltraps
80106fd7:	e9 c3 f7 ff ff       	jmp    8010679f <alltraps>

80106fdc <vector93>:
.globl vector93
vector93:
  pushl $0
80106fdc:	6a 00                	push   $0x0
  pushl $93
80106fde:	6a 5d                	push   $0x5d
  jmp alltraps
80106fe0:	e9 ba f7 ff ff       	jmp    8010679f <alltraps>

80106fe5 <vector94>:
.globl vector94
vector94:
  pushl $0
80106fe5:	6a 00                	push   $0x0
  pushl $94
80106fe7:	6a 5e                	push   $0x5e
  jmp alltraps
80106fe9:	e9 b1 f7 ff ff       	jmp    8010679f <alltraps>

80106fee <vector95>:
.globl vector95
vector95:
  pushl $0
80106fee:	6a 00                	push   $0x0
  pushl $95
80106ff0:	6a 5f                	push   $0x5f
  jmp alltraps
80106ff2:	e9 a8 f7 ff ff       	jmp    8010679f <alltraps>

80106ff7 <vector96>:
.globl vector96
vector96:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $96
80106ff9:	6a 60                	push   $0x60
  jmp alltraps
80106ffb:	e9 9f f7 ff ff       	jmp    8010679f <alltraps>

80107000 <vector97>:
.globl vector97
vector97:
  pushl $0
80107000:	6a 00                	push   $0x0
  pushl $97
80107002:	6a 61                	push   $0x61
  jmp alltraps
80107004:	e9 96 f7 ff ff       	jmp    8010679f <alltraps>

80107009 <vector98>:
.globl vector98
vector98:
  pushl $0
80107009:	6a 00                	push   $0x0
  pushl $98
8010700b:	6a 62                	push   $0x62
  jmp alltraps
8010700d:	e9 8d f7 ff ff       	jmp    8010679f <alltraps>

80107012 <vector99>:
.globl vector99
vector99:
  pushl $0
80107012:	6a 00                	push   $0x0
  pushl $99
80107014:	6a 63                	push   $0x63
  jmp alltraps
80107016:	e9 84 f7 ff ff       	jmp    8010679f <alltraps>

8010701b <vector100>:
.globl vector100
vector100:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $100
8010701d:	6a 64                	push   $0x64
  jmp alltraps
8010701f:	e9 7b f7 ff ff       	jmp    8010679f <alltraps>

80107024 <vector101>:
.globl vector101
vector101:
  pushl $0
80107024:	6a 00                	push   $0x0
  pushl $101
80107026:	6a 65                	push   $0x65
  jmp alltraps
80107028:	e9 72 f7 ff ff       	jmp    8010679f <alltraps>

8010702d <vector102>:
.globl vector102
vector102:
  pushl $0
8010702d:	6a 00                	push   $0x0
  pushl $102
8010702f:	6a 66                	push   $0x66
  jmp alltraps
80107031:	e9 69 f7 ff ff       	jmp    8010679f <alltraps>

80107036 <vector103>:
.globl vector103
vector103:
  pushl $0
80107036:	6a 00                	push   $0x0
  pushl $103
80107038:	6a 67                	push   $0x67
  jmp alltraps
8010703a:	e9 60 f7 ff ff       	jmp    8010679f <alltraps>

8010703f <vector104>:
.globl vector104
vector104:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $104
80107041:	6a 68                	push   $0x68
  jmp alltraps
80107043:	e9 57 f7 ff ff       	jmp    8010679f <alltraps>

80107048 <vector105>:
.globl vector105
vector105:
  pushl $0
80107048:	6a 00                	push   $0x0
  pushl $105
8010704a:	6a 69                	push   $0x69
  jmp alltraps
8010704c:	e9 4e f7 ff ff       	jmp    8010679f <alltraps>

80107051 <vector106>:
.globl vector106
vector106:
  pushl $0
80107051:	6a 00                	push   $0x0
  pushl $106
80107053:	6a 6a                	push   $0x6a
  jmp alltraps
80107055:	e9 45 f7 ff ff       	jmp    8010679f <alltraps>

8010705a <vector107>:
.globl vector107
vector107:
  pushl $0
8010705a:	6a 00                	push   $0x0
  pushl $107
8010705c:	6a 6b                	push   $0x6b
  jmp alltraps
8010705e:	e9 3c f7 ff ff       	jmp    8010679f <alltraps>

80107063 <vector108>:
.globl vector108
vector108:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $108
80107065:	6a 6c                	push   $0x6c
  jmp alltraps
80107067:	e9 33 f7 ff ff       	jmp    8010679f <alltraps>

8010706c <vector109>:
.globl vector109
vector109:
  pushl $0
8010706c:	6a 00                	push   $0x0
  pushl $109
8010706e:	6a 6d                	push   $0x6d
  jmp alltraps
80107070:	e9 2a f7 ff ff       	jmp    8010679f <alltraps>

80107075 <vector110>:
.globl vector110
vector110:
  pushl $0
80107075:	6a 00                	push   $0x0
  pushl $110
80107077:	6a 6e                	push   $0x6e
  jmp alltraps
80107079:	e9 21 f7 ff ff       	jmp    8010679f <alltraps>

8010707e <vector111>:
.globl vector111
vector111:
  pushl $0
8010707e:	6a 00                	push   $0x0
  pushl $111
80107080:	6a 6f                	push   $0x6f
  jmp alltraps
80107082:	e9 18 f7 ff ff       	jmp    8010679f <alltraps>

80107087 <vector112>:
.globl vector112
vector112:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $112
80107089:	6a 70                	push   $0x70
  jmp alltraps
8010708b:	e9 0f f7 ff ff       	jmp    8010679f <alltraps>

80107090 <vector113>:
.globl vector113
vector113:
  pushl $0
80107090:	6a 00                	push   $0x0
  pushl $113
80107092:	6a 71                	push   $0x71
  jmp alltraps
80107094:	e9 06 f7 ff ff       	jmp    8010679f <alltraps>

80107099 <vector114>:
.globl vector114
vector114:
  pushl $0
80107099:	6a 00                	push   $0x0
  pushl $114
8010709b:	6a 72                	push   $0x72
  jmp alltraps
8010709d:	e9 fd f6 ff ff       	jmp    8010679f <alltraps>

801070a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801070a2:	6a 00                	push   $0x0
  pushl $115
801070a4:	6a 73                	push   $0x73
  jmp alltraps
801070a6:	e9 f4 f6 ff ff       	jmp    8010679f <alltraps>

801070ab <vector116>:
.globl vector116
vector116:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $116
801070ad:	6a 74                	push   $0x74
  jmp alltraps
801070af:	e9 eb f6 ff ff       	jmp    8010679f <alltraps>

801070b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801070b4:	6a 00                	push   $0x0
  pushl $117
801070b6:	6a 75                	push   $0x75
  jmp alltraps
801070b8:	e9 e2 f6 ff ff       	jmp    8010679f <alltraps>

801070bd <vector118>:
.globl vector118
vector118:
  pushl $0
801070bd:	6a 00                	push   $0x0
  pushl $118
801070bf:	6a 76                	push   $0x76
  jmp alltraps
801070c1:	e9 d9 f6 ff ff       	jmp    8010679f <alltraps>

801070c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801070c6:	6a 00                	push   $0x0
  pushl $119
801070c8:	6a 77                	push   $0x77
  jmp alltraps
801070ca:	e9 d0 f6 ff ff       	jmp    8010679f <alltraps>

801070cf <vector120>:
.globl vector120
vector120:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $120
801070d1:	6a 78                	push   $0x78
  jmp alltraps
801070d3:	e9 c7 f6 ff ff       	jmp    8010679f <alltraps>

801070d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801070d8:	6a 00                	push   $0x0
  pushl $121
801070da:	6a 79                	push   $0x79
  jmp alltraps
801070dc:	e9 be f6 ff ff       	jmp    8010679f <alltraps>

801070e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801070e1:	6a 00                	push   $0x0
  pushl $122
801070e3:	6a 7a                	push   $0x7a
  jmp alltraps
801070e5:	e9 b5 f6 ff ff       	jmp    8010679f <alltraps>

801070ea <vector123>:
.globl vector123
vector123:
  pushl $0
801070ea:	6a 00                	push   $0x0
  pushl $123
801070ec:	6a 7b                	push   $0x7b
  jmp alltraps
801070ee:	e9 ac f6 ff ff       	jmp    8010679f <alltraps>

801070f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $124
801070f5:	6a 7c                	push   $0x7c
  jmp alltraps
801070f7:	e9 a3 f6 ff ff       	jmp    8010679f <alltraps>

801070fc <vector125>:
.globl vector125
vector125:
  pushl $0
801070fc:	6a 00                	push   $0x0
  pushl $125
801070fe:	6a 7d                	push   $0x7d
  jmp alltraps
80107100:	e9 9a f6 ff ff       	jmp    8010679f <alltraps>

80107105 <vector126>:
.globl vector126
vector126:
  pushl $0
80107105:	6a 00                	push   $0x0
  pushl $126
80107107:	6a 7e                	push   $0x7e
  jmp alltraps
80107109:	e9 91 f6 ff ff       	jmp    8010679f <alltraps>

8010710e <vector127>:
.globl vector127
vector127:
  pushl $0
8010710e:	6a 00                	push   $0x0
  pushl $127
80107110:	6a 7f                	push   $0x7f
  jmp alltraps
80107112:	e9 88 f6 ff ff       	jmp    8010679f <alltraps>

80107117 <vector128>:
.globl vector128
vector128:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $128
80107119:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010711e:	e9 7c f6 ff ff       	jmp    8010679f <alltraps>

80107123 <vector129>:
.globl vector129
vector129:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $129
80107125:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010712a:	e9 70 f6 ff ff       	jmp    8010679f <alltraps>

8010712f <vector130>:
.globl vector130
vector130:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $130
80107131:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107136:	e9 64 f6 ff ff       	jmp    8010679f <alltraps>

8010713b <vector131>:
.globl vector131
vector131:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $131
8010713d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107142:	e9 58 f6 ff ff       	jmp    8010679f <alltraps>

80107147 <vector132>:
.globl vector132
vector132:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $132
80107149:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010714e:	e9 4c f6 ff ff       	jmp    8010679f <alltraps>

80107153 <vector133>:
.globl vector133
vector133:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $133
80107155:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010715a:	e9 40 f6 ff ff       	jmp    8010679f <alltraps>

8010715f <vector134>:
.globl vector134
vector134:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $134
80107161:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107166:	e9 34 f6 ff ff       	jmp    8010679f <alltraps>

8010716b <vector135>:
.globl vector135
vector135:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $135
8010716d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107172:	e9 28 f6 ff ff       	jmp    8010679f <alltraps>

80107177 <vector136>:
.globl vector136
vector136:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $136
80107179:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010717e:	e9 1c f6 ff ff       	jmp    8010679f <alltraps>

80107183 <vector137>:
.globl vector137
vector137:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $137
80107185:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010718a:	e9 10 f6 ff ff       	jmp    8010679f <alltraps>

8010718f <vector138>:
.globl vector138
vector138:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $138
80107191:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107196:	e9 04 f6 ff ff       	jmp    8010679f <alltraps>

8010719b <vector139>:
.globl vector139
vector139:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $139
8010719d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801071a2:	e9 f8 f5 ff ff       	jmp    8010679f <alltraps>

801071a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $140
801071a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801071ae:	e9 ec f5 ff ff       	jmp    8010679f <alltraps>

801071b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $141
801071b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801071ba:	e9 e0 f5 ff ff       	jmp    8010679f <alltraps>

801071bf <vector142>:
.globl vector142
vector142:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $142
801071c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801071c6:	e9 d4 f5 ff ff       	jmp    8010679f <alltraps>

801071cb <vector143>:
.globl vector143
vector143:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $143
801071cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801071d2:	e9 c8 f5 ff ff       	jmp    8010679f <alltraps>

801071d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $144
801071d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801071de:	e9 bc f5 ff ff       	jmp    8010679f <alltraps>

801071e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $145
801071e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801071ea:	e9 b0 f5 ff ff       	jmp    8010679f <alltraps>

801071ef <vector146>:
.globl vector146
vector146:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $146
801071f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801071f6:	e9 a4 f5 ff ff       	jmp    8010679f <alltraps>

801071fb <vector147>:
.globl vector147
vector147:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $147
801071fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107202:	e9 98 f5 ff ff       	jmp    8010679f <alltraps>

80107207 <vector148>:
.globl vector148
vector148:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $148
80107209:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010720e:	e9 8c f5 ff ff       	jmp    8010679f <alltraps>

80107213 <vector149>:
.globl vector149
vector149:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $149
80107215:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010721a:	e9 80 f5 ff ff       	jmp    8010679f <alltraps>

8010721f <vector150>:
.globl vector150
vector150:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $150
80107221:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107226:	e9 74 f5 ff ff       	jmp    8010679f <alltraps>

8010722b <vector151>:
.globl vector151
vector151:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $151
8010722d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107232:	e9 68 f5 ff ff       	jmp    8010679f <alltraps>

80107237 <vector152>:
.globl vector152
vector152:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $152
80107239:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010723e:	e9 5c f5 ff ff       	jmp    8010679f <alltraps>

80107243 <vector153>:
.globl vector153
vector153:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $153
80107245:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010724a:	e9 50 f5 ff ff       	jmp    8010679f <alltraps>

8010724f <vector154>:
.globl vector154
vector154:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $154
80107251:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107256:	e9 44 f5 ff ff       	jmp    8010679f <alltraps>

8010725b <vector155>:
.globl vector155
vector155:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $155
8010725d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107262:	e9 38 f5 ff ff       	jmp    8010679f <alltraps>

80107267 <vector156>:
.globl vector156
vector156:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $156
80107269:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010726e:	e9 2c f5 ff ff       	jmp    8010679f <alltraps>

80107273 <vector157>:
.globl vector157
vector157:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $157
80107275:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010727a:	e9 20 f5 ff ff       	jmp    8010679f <alltraps>

8010727f <vector158>:
.globl vector158
vector158:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $158
80107281:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107286:	e9 14 f5 ff ff       	jmp    8010679f <alltraps>

8010728b <vector159>:
.globl vector159
vector159:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $159
8010728d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107292:	e9 08 f5 ff ff       	jmp    8010679f <alltraps>

80107297 <vector160>:
.globl vector160
vector160:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $160
80107299:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010729e:	e9 fc f4 ff ff       	jmp    8010679f <alltraps>

801072a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $161
801072a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801072aa:	e9 f0 f4 ff ff       	jmp    8010679f <alltraps>

801072af <vector162>:
.globl vector162
vector162:
  pushl $0
801072af:	6a 00                	push   $0x0
  pushl $162
801072b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801072b6:	e9 e4 f4 ff ff       	jmp    8010679f <alltraps>

801072bb <vector163>:
.globl vector163
vector163:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $163
801072bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801072c2:	e9 d8 f4 ff ff       	jmp    8010679f <alltraps>

801072c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $164
801072c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801072ce:	e9 cc f4 ff ff       	jmp    8010679f <alltraps>

801072d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801072d3:	6a 00                	push   $0x0
  pushl $165
801072d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801072da:	e9 c0 f4 ff ff       	jmp    8010679f <alltraps>

801072df <vector166>:
.globl vector166
vector166:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $166
801072e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801072e6:	e9 b4 f4 ff ff       	jmp    8010679f <alltraps>

801072eb <vector167>:
.globl vector167
vector167:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $167
801072ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801072f2:	e9 a8 f4 ff ff       	jmp    8010679f <alltraps>

801072f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801072f7:	6a 00                	push   $0x0
  pushl $168
801072f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801072fe:	e9 9c f4 ff ff       	jmp    8010679f <alltraps>

80107303 <vector169>:
.globl vector169
vector169:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $169
80107305:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010730a:	e9 90 f4 ff ff       	jmp    8010679f <alltraps>

8010730f <vector170>:
.globl vector170
vector170:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $170
80107311:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107316:	e9 84 f4 ff ff       	jmp    8010679f <alltraps>

8010731b <vector171>:
.globl vector171
vector171:
  pushl $0
8010731b:	6a 00                	push   $0x0
  pushl $171
8010731d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107322:	e9 78 f4 ff ff       	jmp    8010679f <alltraps>

80107327 <vector172>:
.globl vector172
vector172:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $172
80107329:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010732e:	e9 6c f4 ff ff       	jmp    8010679f <alltraps>

80107333 <vector173>:
.globl vector173
vector173:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $173
80107335:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010733a:	e9 60 f4 ff ff       	jmp    8010679f <alltraps>

8010733f <vector174>:
.globl vector174
vector174:
  pushl $0
8010733f:	6a 00                	push   $0x0
  pushl $174
80107341:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107346:	e9 54 f4 ff ff       	jmp    8010679f <alltraps>

8010734b <vector175>:
.globl vector175
vector175:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $175
8010734d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107352:	e9 48 f4 ff ff       	jmp    8010679f <alltraps>

80107357 <vector176>:
.globl vector176
vector176:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $176
80107359:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010735e:	e9 3c f4 ff ff       	jmp    8010679f <alltraps>

80107363 <vector177>:
.globl vector177
vector177:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $177
80107365:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010736a:	e9 30 f4 ff ff       	jmp    8010679f <alltraps>

8010736f <vector178>:
.globl vector178
vector178:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $178
80107371:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107376:	e9 24 f4 ff ff       	jmp    8010679f <alltraps>

8010737b <vector179>:
.globl vector179
vector179:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $179
8010737d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107382:	e9 18 f4 ff ff       	jmp    8010679f <alltraps>

80107387 <vector180>:
.globl vector180
vector180:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $180
80107389:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010738e:	e9 0c f4 ff ff       	jmp    8010679f <alltraps>

80107393 <vector181>:
.globl vector181
vector181:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $181
80107395:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010739a:	e9 00 f4 ff ff       	jmp    8010679f <alltraps>

8010739f <vector182>:
.globl vector182
vector182:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $182
801073a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801073a6:	e9 f4 f3 ff ff       	jmp    8010679f <alltraps>

801073ab <vector183>:
.globl vector183
vector183:
  pushl $0
801073ab:	6a 00                	push   $0x0
  pushl $183
801073ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801073b2:	e9 e8 f3 ff ff       	jmp    8010679f <alltraps>

801073b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $184
801073b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801073be:	e9 dc f3 ff ff       	jmp    8010679f <alltraps>

801073c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $185
801073c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801073ca:	e9 d0 f3 ff ff       	jmp    8010679f <alltraps>

801073cf <vector186>:
.globl vector186
vector186:
  pushl $0
801073cf:	6a 00                	push   $0x0
  pushl $186
801073d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801073d6:	e9 c4 f3 ff ff       	jmp    8010679f <alltraps>

801073db <vector187>:
.globl vector187
vector187:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $187
801073dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801073e2:	e9 b8 f3 ff ff       	jmp    8010679f <alltraps>

801073e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $188
801073e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801073ee:	e9 ac f3 ff ff       	jmp    8010679f <alltraps>

801073f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $189
801073f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801073fa:	e9 a0 f3 ff ff       	jmp    8010679f <alltraps>

801073ff <vector190>:
.globl vector190
vector190:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $190
80107401:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107406:	e9 94 f3 ff ff       	jmp    8010679f <alltraps>

8010740b <vector191>:
.globl vector191
vector191:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $191
8010740d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107412:	e9 88 f3 ff ff       	jmp    8010679f <alltraps>

80107417 <vector192>:
.globl vector192
vector192:
  pushl $0
80107417:	6a 00                	push   $0x0
  pushl $192
80107419:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010741e:	e9 7c f3 ff ff       	jmp    8010679f <alltraps>

80107423 <vector193>:
.globl vector193
vector193:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $193
80107425:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010742a:	e9 70 f3 ff ff       	jmp    8010679f <alltraps>

8010742f <vector194>:
.globl vector194
vector194:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $194
80107431:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107436:	e9 64 f3 ff ff       	jmp    8010679f <alltraps>

8010743b <vector195>:
.globl vector195
vector195:
  pushl $0
8010743b:	6a 00                	push   $0x0
  pushl $195
8010743d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107442:	e9 58 f3 ff ff       	jmp    8010679f <alltraps>

80107447 <vector196>:
.globl vector196
vector196:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $196
80107449:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010744e:	e9 4c f3 ff ff       	jmp    8010679f <alltraps>

80107453 <vector197>:
.globl vector197
vector197:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $197
80107455:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010745a:	e9 40 f3 ff ff       	jmp    8010679f <alltraps>

8010745f <vector198>:
.globl vector198
vector198:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $198
80107461:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107466:	e9 34 f3 ff ff       	jmp    8010679f <alltraps>

8010746b <vector199>:
.globl vector199
vector199:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $199
8010746d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107472:	e9 28 f3 ff ff       	jmp    8010679f <alltraps>

80107477 <vector200>:
.globl vector200
vector200:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $200
80107479:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010747e:	e9 1c f3 ff ff       	jmp    8010679f <alltraps>

80107483 <vector201>:
.globl vector201
vector201:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $201
80107485:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010748a:	e9 10 f3 ff ff       	jmp    8010679f <alltraps>

8010748f <vector202>:
.globl vector202
vector202:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $202
80107491:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107496:	e9 04 f3 ff ff       	jmp    8010679f <alltraps>

8010749b <vector203>:
.globl vector203
vector203:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $203
8010749d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801074a2:	e9 f8 f2 ff ff       	jmp    8010679f <alltraps>

801074a7 <vector204>:
.globl vector204
vector204:
  pushl $0
801074a7:	6a 00                	push   $0x0
  pushl $204
801074a9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801074ae:	e9 ec f2 ff ff       	jmp    8010679f <alltraps>

801074b3 <vector205>:
.globl vector205
vector205:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $205
801074b5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801074ba:	e9 e0 f2 ff ff       	jmp    8010679f <alltraps>

801074bf <vector206>:
.globl vector206
vector206:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $206
801074c1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801074c6:	e9 d4 f2 ff ff       	jmp    8010679f <alltraps>

801074cb <vector207>:
.globl vector207
vector207:
  pushl $0
801074cb:	6a 00                	push   $0x0
  pushl $207
801074cd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801074d2:	e9 c8 f2 ff ff       	jmp    8010679f <alltraps>

801074d7 <vector208>:
.globl vector208
vector208:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $208
801074d9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801074de:	e9 bc f2 ff ff       	jmp    8010679f <alltraps>

801074e3 <vector209>:
.globl vector209
vector209:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $209
801074e5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801074ea:	e9 b0 f2 ff ff       	jmp    8010679f <alltraps>

801074ef <vector210>:
.globl vector210
vector210:
  pushl $0
801074ef:	6a 00                	push   $0x0
  pushl $210
801074f1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801074f6:	e9 a4 f2 ff ff       	jmp    8010679f <alltraps>

801074fb <vector211>:
.globl vector211
vector211:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $211
801074fd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107502:	e9 98 f2 ff ff       	jmp    8010679f <alltraps>

80107507 <vector212>:
.globl vector212
vector212:
  pushl $0
80107507:	6a 00                	push   $0x0
  pushl $212
80107509:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010750e:	e9 8c f2 ff ff       	jmp    8010679f <alltraps>

80107513 <vector213>:
.globl vector213
vector213:
  pushl $0
80107513:	6a 00                	push   $0x0
  pushl $213
80107515:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010751a:	e9 80 f2 ff ff       	jmp    8010679f <alltraps>

8010751f <vector214>:
.globl vector214
vector214:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $214
80107521:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107526:	e9 74 f2 ff ff       	jmp    8010679f <alltraps>

8010752b <vector215>:
.globl vector215
vector215:
  pushl $0
8010752b:	6a 00                	push   $0x0
  pushl $215
8010752d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107532:	e9 68 f2 ff ff       	jmp    8010679f <alltraps>

80107537 <vector216>:
.globl vector216
vector216:
  pushl $0
80107537:	6a 00                	push   $0x0
  pushl $216
80107539:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010753e:	e9 5c f2 ff ff       	jmp    8010679f <alltraps>

80107543 <vector217>:
.globl vector217
vector217:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $217
80107545:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010754a:	e9 50 f2 ff ff       	jmp    8010679f <alltraps>

8010754f <vector218>:
.globl vector218
vector218:
  pushl $0
8010754f:	6a 00                	push   $0x0
  pushl $218
80107551:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107556:	e9 44 f2 ff ff       	jmp    8010679f <alltraps>

8010755b <vector219>:
.globl vector219
vector219:
  pushl $0
8010755b:	6a 00                	push   $0x0
  pushl $219
8010755d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107562:	e9 38 f2 ff ff       	jmp    8010679f <alltraps>

80107567 <vector220>:
.globl vector220
vector220:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $220
80107569:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010756e:	e9 2c f2 ff ff       	jmp    8010679f <alltraps>

80107573 <vector221>:
.globl vector221
vector221:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $221
80107575:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010757a:	e9 20 f2 ff ff       	jmp    8010679f <alltraps>

8010757f <vector222>:
.globl vector222
vector222:
  pushl $0
8010757f:	6a 00                	push   $0x0
  pushl $222
80107581:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107586:	e9 14 f2 ff ff       	jmp    8010679f <alltraps>

8010758b <vector223>:
.globl vector223
vector223:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $223
8010758d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107592:	e9 08 f2 ff ff       	jmp    8010679f <alltraps>

80107597 <vector224>:
.globl vector224
vector224:
  pushl $0
80107597:	6a 00                	push   $0x0
  pushl $224
80107599:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010759e:	e9 fc f1 ff ff       	jmp    8010679f <alltraps>

801075a3 <vector225>:
.globl vector225
vector225:
  pushl $0
801075a3:	6a 00                	push   $0x0
  pushl $225
801075a5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801075aa:	e9 f0 f1 ff ff       	jmp    8010679f <alltraps>

801075af <vector226>:
.globl vector226
vector226:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $226
801075b1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801075b6:	e9 e4 f1 ff ff       	jmp    8010679f <alltraps>

801075bb <vector227>:
.globl vector227
vector227:
  pushl $0
801075bb:	6a 00                	push   $0x0
  pushl $227
801075bd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801075c2:	e9 d8 f1 ff ff       	jmp    8010679f <alltraps>

801075c7 <vector228>:
.globl vector228
vector228:
  pushl $0
801075c7:	6a 00                	push   $0x0
  pushl $228
801075c9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801075ce:	e9 cc f1 ff ff       	jmp    8010679f <alltraps>

801075d3 <vector229>:
.globl vector229
vector229:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $229
801075d5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801075da:	e9 c0 f1 ff ff       	jmp    8010679f <alltraps>

801075df <vector230>:
.globl vector230
vector230:
  pushl $0
801075df:	6a 00                	push   $0x0
  pushl $230
801075e1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801075e6:	e9 b4 f1 ff ff       	jmp    8010679f <alltraps>

801075eb <vector231>:
.globl vector231
vector231:
  pushl $0
801075eb:	6a 00                	push   $0x0
  pushl $231
801075ed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801075f2:	e9 a8 f1 ff ff       	jmp    8010679f <alltraps>

801075f7 <vector232>:
.globl vector232
vector232:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $232
801075f9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801075fe:	e9 9c f1 ff ff       	jmp    8010679f <alltraps>

80107603 <vector233>:
.globl vector233
vector233:
  pushl $0
80107603:	6a 00                	push   $0x0
  pushl $233
80107605:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010760a:	e9 90 f1 ff ff       	jmp    8010679f <alltraps>

8010760f <vector234>:
.globl vector234
vector234:
  pushl $0
8010760f:	6a 00                	push   $0x0
  pushl $234
80107611:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107616:	e9 84 f1 ff ff       	jmp    8010679f <alltraps>

8010761b <vector235>:
.globl vector235
vector235:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $235
8010761d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107622:	e9 78 f1 ff ff       	jmp    8010679f <alltraps>

80107627 <vector236>:
.globl vector236
vector236:
  pushl $0
80107627:	6a 00                	push   $0x0
  pushl $236
80107629:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010762e:	e9 6c f1 ff ff       	jmp    8010679f <alltraps>

80107633 <vector237>:
.globl vector237
vector237:
  pushl $0
80107633:	6a 00                	push   $0x0
  pushl $237
80107635:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010763a:	e9 60 f1 ff ff       	jmp    8010679f <alltraps>

8010763f <vector238>:
.globl vector238
vector238:
  pushl $0
8010763f:	6a 00                	push   $0x0
  pushl $238
80107641:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107646:	e9 54 f1 ff ff       	jmp    8010679f <alltraps>

8010764b <vector239>:
.globl vector239
vector239:
  pushl $0
8010764b:	6a 00                	push   $0x0
  pushl $239
8010764d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107652:	e9 48 f1 ff ff       	jmp    8010679f <alltraps>

80107657 <vector240>:
.globl vector240
vector240:
  pushl $0
80107657:	6a 00                	push   $0x0
  pushl $240
80107659:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010765e:	e9 3c f1 ff ff       	jmp    8010679f <alltraps>

80107663 <vector241>:
.globl vector241
vector241:
  pushl $0
80107663:	6a 00                	push   $0x0
  pushl $241
80107665:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010766a:	e9 30 f1 ff ff       	jmp    8010679f <alltraps>

8010766f <vector242>:
.globl vector242
vector242:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $242
80107671:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107676:	e9 24 f1 ff ff       	jmp    8010679f <alltraps>

8010767b <vector243>:
.globl vector243
vector243:
  pushl $0
8010767b:	6a 00                	push   $0x0
  pushl $243
8010767d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107682:	e9 18 f1 ff ff       	jmp    8010679f <alltraps>

80107687 <vector244>:
.globl vector244
vector244:
  pushl $0
80107687:	6a 00                	push   $0x0
  pushl $244
80107689:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010768e:	e9 0c f1 ff ff       	jmp    8010679f <alltraps>

80107693 <vector245>:
.globl vector245
vector245:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $245
80107695:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010769a:	e9 00 f1 ff ff       	jmp    8010679f <alltraps>

8010769f <vector246>:
.globl vector246
vector246:
  pushl $0
8010769f:	6a 00                	push   $0x0
  pushl $246
801076a1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801076a6:	e9 f4 f0 ff ff       	jmp    8010679f <alltraps>

801076ab <vector247>:
.globl vector247
vector247:
  pushl $0
801076ab:	6a 00                	push   $0x0
  pushl $247
801076ad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801076b2:	e9 e8 f0 ff ff       	jmp    8010679f <alltraps>

801076b7 <vector248>:
.globl vector248
vector248:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $248
801076b9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801076be:	e9 dc f0 ff ff       	jmp    8010679f <alltraps>

801076c3 <vector249>:
.globl vector249
vector249:
  pushl $0
801076c3:	6a 00                	push   $0x0
  pushl $249
801076c5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801076ca:	e9 d0 f0 ff ff       	jmp    8010679f <alltraps>

801076cf <vector250>:
.globl vector250
vector250:
  pushl $0
801076cf:	6a 00                	push   $0x0
  pushl $250
801076d1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801076d6:	e9 c4 f0 ff ff       	jmp    8010679f <alltraps>

801076db <vector251>:
.globl vector251
vector251:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $251
801076dd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801076e2:	e9 b8 f0 ff ff       	jmp    8010679f <alltraps>

801076e7 <vector252>:
.globl vector252
vector252:
  pushl $0
801076e7:	6a 00                	push   $0x0
  pushl $252
801076e9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801076ee:	e9 ac f0 ff ff       	jmp    8010679f <alltraps>

801076f3 <vector253>:
.globl vector253
vector253:
  pushl $0
801076f3:	6a 00                	push   $0x0
  pushl $253
801076f5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801076fa:	e9 a0 f0 ff ff       	jmp    8010679f <alltraps>

801076ff <vector254>:
.globl vector254
vector254:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $254
80107701:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107706:	e9 94 f0 ff ff       	jmp    8010679f <alltraps>

8010770b <vector255>:
.globl vector255
vector255:
  pushl $0
8010770b:	6a 00                	push   $0x0
  pushl $255
8010770d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107712:	e9 88 f0 ff ff       	jmp    8010679f <alltraps>
80107717:	66 90                	xchg   %ax,%ax
80107719:	66 90                	xchg   %ax,%ax
8010771b:	66 90                	xchg   %ax,%ax
8010771d:	66 90                	xchg   %ax,%ax
8010771f:	90                   	nop

80107720 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107720:	55                   	push   %ebp
80107721:	89 e5                	mov    %esp,%ebp
80107723:	57                   	push   %edi
80107724:	56                   	push   %esi
80107725:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107726:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010772c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107732:	83 ec 1c             	sub    $0x1c,%esp
80107735:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107738:	39 d3                	cmp    %edx,%ebx
8010773a:	73 49                	jae    80107785 <deallocuvm.part.0+0x65>
8010773c:	89 c7                	mov    %eax,%edi
8010773e:	eb 0c                	jmp    8010774c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107740:	83 c0 01             	add    $0x1,%eax
80107743:	c1 e0 16             	shl    $0x16,%eax
80107746:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107748:	39 da                	cmp    %ebx,%edx
8010774a:	76 39                	jbe    80107785 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010774c:	89 d8                	mov    %ebx,%eax
8010774e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107751:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107754:	f6 c1 01             	test   $0x1,%cl
80107757:	74 e7                	je     80107740 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107759:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010775b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107761:	c1 ee 0a             	shr    $0xa,%esi
80107764:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010776a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107771:	85 f6                	test   %esi,%esi
80107773:	74 cb                	je     80107740 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107775:	8b 06                	mov    (%esi),%eax
80107777:	a8 01                	test   $0x1,%al
80107779:	75 15                	jne    80107790 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010777b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107781:	39 da                	cmp    %ebx,%edx
80107783:	77 c7                	ja     8010774c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107785:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107788:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010778b:	5b                   	pop    %ebx
8010778c:	5e                   	pop    %esi
8010778d:	5f                   	pop    %edi
8010778e:	5d                   	pop    %ebp
8010778f:	c3                   	ret    
      if(pa == 0)
80107790:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107795:	74 25                	je     801077bc <deallocuvm.part.0+0x9c>
      kfree(v);
80107797:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010779a:	05 00 00 00 80       	add    $0x80000000,%eax
8010779f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801077a2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801077a8:	50                   	push   %eax
801077a9:	e8 12 ad ff ff       	call   801024c0 <kfree>
      *pte = 0;
801077ae:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
801077b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801077b7:	83 c4 10             	add    $0x10,%esp
801077ba:	eb 8c                	jmp    80107748 <deallocuvm.part.0+0x28>
        panic("kfree");
801077bc:	83 ec 0c             	sub    $0xc,%esp
801077bf:	68 86 83 10 80       	push   $0x80108386
801077c4:	e8 b7 8b ff ff       	call   80100380 <panic>
801077c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801077d0 <mappages>:
{
801077d0:	55                   	push   %ebp
801077d1:	89 e5                	mov    %esp,%ebp
801077d3:	57                   	push   %edi
801077d4:	56                   	push   %esi
801077d5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801077d6:	89 d3                	mov    %edx,%ebx
801077d8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801077de:	83 ec 1c             	sub    $0x1c,%esp
801077e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801077e4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801077e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801077ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
801077f0:	8b 45 08             	mov    0x8(%ebp),%eax
801077f3:	29 d8                	sub    %ebx,%eax
801077f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801077f8:	eb 3d                	jmp    80107837 <mappages+0x67>
801077fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107800:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107802:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107807:	c1 ea 0a             	shr    $0xa,%edx
8010780a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107810:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107817:	85 c0                	test   %eax,%eax
80107819:	74 75                	je     80107890 <mappages+0xc0>
    if(*pte & PTE_P)
8010781b:	f6 00 01             	testb  $0x1,(%eax)
8010781e:	0f 85 86 00 00 00    	jne    801078aa <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107824:	0b 75 0c             	or     0xc(%ebp),%esi
80107827:	83 ce 01             	or     $0x1,%esi
8010782a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010782c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010782f:	74 6f                	je     801078a0 <mappages+0xd0>
    a += PGSIZE;
80107831:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107837:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010783a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010783d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107840:	89 d8                	mov    %ebx,%eax
80107842:	c1 e8 16             	shr    $0x16,%eax
80107845:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107848:	8b 07                	mov    (%edi),%eax
8010784a:	a8 01                	test   $0x1,%al
8010784c:	75 b2                	jne    80107800 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010784e:	e8 2d ae ff ff       	call   80102680 <kalloc>
80107853:	85 c0                	test   %eax,%eax
80107855:	74 39                	je     80107890 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107857:	83 ec 04             	sub    $0x4,%esp
8010785a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010785d:	68 00 10 00 00       	push   $0x1000
80107862:	6a 00                	push   $0x0
80107864:	50                   	push   %eax
80107865:	e8 76 d7 ff ff       	call   80104fe0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010786a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010786d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107870:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107876:	83 c8 07             	or     $0x7,%eax
80107879:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010787b:	89 d8                	mov    %ebx,%eax
8010787d:	c1 e8 0a             	shr    $0xa,%eax
80107880:	25 fc 0f 00 00       	and    $0xffc,%eax
80107885:	01 d0                	add    %edx,%eax
80107887:	eb 92                	jmp    8010781b <mappages+0x4b>
80107889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107890:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107893:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107898:	5b                   	pop    %ebx
80107899:	5e                   	pop    %esi
8010789a:	5f                   	pop    %edi
8010789b:	5d                   	pop    %ebp
8010789c:	c3                   	ret    
8010789d:	8d 76 00             	lea    0x0(%esi),%esi
801078a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801078a3:	31 c0                	xor    %eax,%eax
}
801078a5:	5b                   	pop    %ebx
801078a6:	5e                   	pop    %esi
801078a7:	5f                   	pop    %edi
801078a8:	5d                   	pop    %ebp
801078a9:	c3                   	ret    
      panic("remap");
801078aa:	83 ec 0c             	sub    $0xc,%esp
801078ad:	68 20 8b 10 80       	push   $0x80108b20
801078b2:	e8 c9 8a ff ff       	call   80100380 <panic>
801078b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078be:	66 90                	xchg   %ax,%ax

801078c0 <seginit>:
{
801078c0:	55                   	push   %ebp
801078c1:	89 e5                	mov    %esp,%ebp
801078c3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801078c6:	e8 15 c1 ff ff       	call   801039e0 <cpuid>
  pd[0] = size-1;
801078cb:	ba 2f 00 00 00       	mov    $0x2f,%edx
801078d0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801078d6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801078da:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
801078e1:	ff 00 00 
801078e4:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
801078eb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801078ee:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
801078f5:	ff 00 00 
801078f8:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
801078ff:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107902:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107909:	ff 00 00 
8010790c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80107913:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107916:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
8010791d:	ff 00 00 
80107920:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80107927:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010792a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
8010792f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107933:	c1 e8 10             	shr    $0x10,%eax
80107936:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010793a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010793d:	0f 01 10             	lgdtl  (%eax)
}
80107940:	c9                   	leave  
80107941:	c3                   	ret    
80107942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107950 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107950:	a1 c4 5d 11 80       	mov    0x80115dc4,%eax
80107955:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010795a:	0f 22 d8             	mov    %eax,%cr3
}
8010795d:	c3                   	ret    
8010795e:	66 90                	xchg   %ax,%ax

80107960 <switchuvm>:
{
80107960:	55                   	push   %ebp
80107961:	89 e5                	mov    %esp,%ebp
80107963:	57                   	push   %edi
80107964:	56                   	push   %esi
80107965:	53                   	push   %ebx
80107966:	83 ec 1c             	sub    $0x1c,%esp
80107969:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010796c:	85 f6                	test   %esi,%esi
8010796e:	0f 84 cb 00 00 00    	je     80107a3f <switchuvm+0xdf>
  if(p->kstack == 0)
80107974:	8b 46 08             	mov    0x8(%esi),%eax
80107977:	85 c0                	test   %eax,%eax
80107979:	0f 84 da 00 00 00    	je     80107a59 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010797f:	8b 46 04             	mov    0x4(%esi),%eax
80107982:	85 c0                	test   %eax,%eax
80107984:	0f 84 c2 00 00 00    	je     80107a4c <switchuvm+0xec>
  pushcli();
8010798a:	e8 41 d4 ff ff       	call   80104dd0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010798f:	e8 ec bf ff ff       	call   80103980 <mycpu>
80107994:	89 c3                	mov    %eax,%ebx
80107996:	e8 e5 bf ff ff       	call   80103980 <mycpu>
8010799b:	89 c7                	mov    %eax,%edi
8010799d:	e8 de bf ff ff       	call   80103980 <mycpu>
801079a2:	83 c7 08             	add    $0x8,%edi
801079a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801079a8:	e8 d3 bf ff ff       	call   80103980 <mycpu>
801079ad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801079b0:	ba 67 00 00 00       	mov    $0x67,%edx
801079b5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801079bc:	83 c0 08             	add    $0x8,%eax
801079bf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801079c6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801079cb:	83 c1 08             	add    $0x8,%ecx
801079ce:	c1 e8 18             	shr    $0x18,%eax
801079d1:	c1 e9 10             	shr    $0x10,%ecx
801079d4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801079da:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801079e0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801079e5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801079ec:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801079f1:	e8 8a bf ff ff       	call   80103980 <mycpu>
801079f6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801079fd:	e8 7e bf ff ff       	call   80103980 <mycpu>
80107a02:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107a06:	8b 5e 08             	mov    0x8(%esi),%ebx
80107a09:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a0f:	e8 6c bf ff ff       	call   80103980 <mycpu>
80107a14:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107a17:	e8 64 bf ff ff       	call   80103980 <mycpu>
80107a1c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107a20:	b8 28 00 00 00       	mov    $0x28,%eax
80107a25:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107a28:	8b 46 04             	mov    0x4(%esi),%eax
80107a2b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107a30:	0f 22 d8             	mov    %eax,%cr3
}
80107a33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a36:	5b                   	pop    %ebx
80107a37:	5e                   	pop    %esi
80107a38:	5f                   	pop    %edi
80107a39:	5d                   	pop    %ebp
  popcli();
80107a3a:	e9 e1 d3 ff ff       	jmp    80104e20 <popcli>
    panic("switchuvm: no process");
80107a3f:	83 ec 0c             	sub    $0xc,%esp
80107a42:	68 26 8b 10 80       	push   $0x80108b26
80107a47:	e8 34 89 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80107a4c:	83 ec 0c             	sub    $0xc,%esp
80107a4f:	68 51 8b 10 80       	push   $0x80108b51
80107a54:	e8 27 89 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107a59:	83 ec 0c             	sub    $0xc,%esp
80107a5c:	68 3c 8b 10 80       	push   $0x80108b3c
80107a61:	e8 1a 89 ff ff       	call   80100380 <panic>
80107a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a6d:	8d 76 00             	lea    0x0(%esi),%esi

80107a70 <inituvm>:
{
80107a70:	55                   	push   %ebp
80107a71:	89 e5                	mov    %esp,%ebp
80107a73:	57                   	push   %edi
80107a74:	56                   	push   %esi
80107a75:	53                   	push   %ebx
80107a76:	83 ec 1c             	sub    $0x1c,%esp
80107a79:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a7c:	8b 75 10             	mov    0x10(%ebp),%esi
80107a7f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107a82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107a85:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107a8b:	77 4b                	ja     80107ad8 <inituvm+0x68>
  mem = kalloc();
80107a8d:	e8 ee ab ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80107a92:	83 ec 04             	sub    $0x4,%esp
80107a95:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107a9a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107a9c:	6a 00                	push   $0x0
80107a9e:	50                   	push   %eax
80107a9f:	e8 3c d5 ff ff       	call   80104fe0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107aa4:	58                   	pop    %eax
80107aa5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107aab:	5a                   	pop    %edx
80107aac:	6a 06                	push   $0x6
80107aae:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ab3:	31 d2                	xor    %edx,%edx
80107ab5:	50                   	push   %eax
80107ab6:	89 f8                	mov    %edi,%eax
80107ab8:	e8 13 fd ff ff       	call   801077d0 <mappages>
  memmove(mem, init, sz);
80107abd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ac0:	89 75 10             	mov    %esi,0x10(%ebp)
80107ac3:	83 c4 10             	add    $0x10,%esp
80107ac6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107ac9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107acf:	5b                   	pop    %ebx
80107ad0:	5e                   	pop    %esi
80107ad1:	5f                   	pop    %edi
80107ad2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107ad3:	e9 a8 d5 ff ff       	jmp    80105080 <memmove>
    panic("inituvm: more than a page");
80107ad8:	83 ec 0c             	sub    $0xc,%esp
80107adb:	68 65 8b 10 80       	push   $0x80108b65
80107ae0:	e8 9b 88 ff ff       	call   80100380 <panic>
80107ae5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107af0 <loaduvm>:
{
80107af0:	55                   	push   %ebp
80107af1:	89 e5                	mov    %esp,%ebp
80107af3:	57                   	push   %edi
80107af4:	56                   	push   %esi
80107af5:	53                   	push   %ebx
80107af6:	83 ec 1c             	sub    $0x1c,%esp
80107af9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107afc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107aff:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107b04:	0f 85 bb 00 00 00    	jne    80107bc5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80107b0a:	01 f0                	add    %esi,%eax
80107b0c:	89 f3                	mov    %esi,%ebx
80107b0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107b11:	8b 45 14             	mov    0x14(%ebp),%eax
80107b14:	01 f0                	add    %esi,%eax
80107b16:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107b19:	85 f6                	test   %esi,%esi
80107b1b:	0f 84 87 00 00 00    	je     80107ba8 <loaduvm+0xb8>
80107b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107b28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80107b2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107b2e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107b30:	89 c2                	mov    %eax,%edx
80107b32:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107b35:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107b38:	f6 c2 01             	test   $0x1,%dl
80107b3b:	75 13                	jne    80107b50 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80107b3d:	83 ec 0c             	sub    $0xc,%esp
80107b40:	68 7f 8b 10 80       	push   $0x80108b7f
80107b45:	e8 36 88 ff ff       	call   80100380 <panic>
80107b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107b50:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b53:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107b59:	25 fc 0f 00 00       	and    $0xffc,%eax
80107b5e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107b65:	85 c0                	test   %eax,%eax
80107b67:	74 d4                	je     80107b3d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107b69:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107b6b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107b6e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107b73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107b78:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107b7e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107b81:	29 d9                	sub    %ebx,%ecx
80107b83:	05 00 00 00 80       	add    $0x80000000,%eax
80107b88:	57                   	push   %edi
80107b89:	51                   	push   %ecx
80107b8a:	50                   	push   %eax
80107b8b:	ff 75 10             	push   0x10(%ebp)
80107b8e:	e8 fd 9e ff ff       	call   80101a90 <readi>
80107b93:	83 c4 10             	add    $0x10,%esp
80107b96:	39 f8                	cmp    %edi,%eax
80107b98:	75 1e                	jne    80107bb8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107b9a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107ba0:	89 f0                	mov    %esi,%eax
80107ba2:	29 d8                	sub    %ebx,%eax
80107ba4:	39 c6                	cmp    %eax,%esi
80107ba6:	77 80                	ja     80107b28 <loaduvm+0x38>
}
80107ba8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107bab:	31 c0                	xor    %eax,%eax
}
80107bad:	5b                   	pop    %ebx
80107bae:	5e                   	pop    %esi
80107baf:	5f                   	pop    %edi
80107bb0:	5d                   	pop    %ebp
80107bb1:	c3                   	ret    
80107bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107bbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bc0:	5b                   	pop    %ebx
80107bc1:	5e                   	pop    %esi
80107bc2:	5f                   	pop    %edi
80107bc3:	5d                   	pop    %ebp
80107bc4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107bc5:	83 ec 0c             	sub    $0xc,%esp
80107bc8:	68 20 8c 10 80       	push   $0x80108c20
80107bcd:	e8 ae 87 ff ff       	call   80100380 <panic>
80107bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107be0 <allocuvm>:
{
80107be0:	55                   	push   %ebp
80107be1:	89 e5                	mov    %esp,%ebp
80107be3:	57                   	push   %edi
80107be4:	56                   	push   %esi
80107be5:	53                   	push   %ebx
80107be6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107be9:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107bec:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107bef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107bf2:	85 c0                	test   %eax,%eax
80107bf4:	0f 88 b6 00 00 00    	js     80107cb0 <allocuvm+0xd0>
  if(newsz < oldsz)
80107bfa:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107c00:	0f 82 9a 00 00 00    	jb     80107ca0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107c06:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107c0c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107c12:	39 75 10             	cmp    %esi,0x10(%ebp)
80107c15:	77 44                	ja     80107c5b <allocuvm+0x7b>
80107c17:	e9 87 00 00 00       	jmp    80107ca3 <allocuvm+0xc3>
80107c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107c20:	83 ec 04             	sub    $0x4,%esp
80107c23:	68 00 10 00 00       	push   $0x1000
80107c28:	6a 00                	push   $0x0
80107c2a:	50                   	push   %eax
80107c2b:	e8 b0 d3 ff ff       	call   80104fe0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107c30:	58                   	pop    %eax
80107c31:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107c37:	5a                   	pop    %edx
80107c38:	6a 06                	push   $0x6
80107c3a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c3f:	89 f2                	mov    %esi,%edx
80107c41:	50                   	push   %eax
80107c42:	89 f8                	mov    %edi,%eax
80107c44:	e8 87 fb ff ff       	call   801077d0 <mappages>
80107c49:	83 c4 10             	add    $0x10,%esp
80107c4c:	85 c0                	test   %eax,%eax
80107c4e:	78 78                	js     80107cc8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107c50:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107c56:	39 75 10             	cmp    %esi,0x10(%ebp)
80107c59:	76 48                	jbe    80107ca3 <allocuvm+0xc3>
    mem = kalloc();
80107c5b:	e8 20 aa ff ff       	call   80102680 <kalloc>
80107c60:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107c62:	85 c0                	test   %eax,%eax
80107c64:	75 ba                	jne    80107c20 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107c66:	83 ec 0c             	sub    $0xc,%esp
80107c69:	68 9d 8b 10 80       	push   $0x80108b9d
80107c6e:	e8 2d 8a ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107c73:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c76:	83 c4 10             	add    $0x10,%esp
80107c79:	39 45 10             	cmp    %eax,0x10(%ebp)
80107c7c:	74 32                	je     80107cb0 <allocuvm+0xd0>
80107c7e:	8b 55 10             	mov    0x10(%ebp),%edx
80107c81:	89 c1                	mov    %eax,%ecx
80107c83:	89 f8                	mov    %edi,%eax
80107c85:	e8 96 fa ff ff       	call   80107720 <deallocuvm.part.0>
      return 0;
80107c8a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107c91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c97:	5b                   	pop    %ebx
80107c98:	5e                   	pop    %esi
80107c99:	5f                   	pop    %edi
80107c9a:	5d                   	pop    %ebp
80107c9b:	c3                   	ret    
80107c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107ca0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107ca3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ca9:	5b                   	pop    %ebx
80107caa:	5e                   	pop    %esi
80107cab:	5f                   	pop    %edi
80107cac:	5d                   	pop    %ebp
80107cad:	c3                   	ret    
80107cae:	66 90                	xchg   %ax,%ax
    return 0;
80107cb0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107cb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107cba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cbd:	5b                   	pop    %ebx
80107cbe:	5e                   	pop    %esi
80107cbf:	5f                   	pop    %edi
80107cc0:	5d                   	pop    %ebp
80107cc1:	c3                   	ret    
80107cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107cc8:	83 ec 0c             	sub    $0xc,%esp
80107ccb:	68 b5 8b 10 80       	push   $0x80108bb5
80107cd0:	e8 cb 89 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cd8:	83 c4 10             	add    $0x10,%esp
80107cdb:	39 45 10             	cmp    %eax,0x10(%ebp)
80107cde:	74 0c                	je     80107cec <allocuvm+0x10c>
80107ce0:	8b 55 10             	mov    0x10(%ebp),%edx
80107ce3:	89 c1                	mov    %eax,%ecx
80107ce5:	89 f8                	mov    %edi,%eax
80107ce7:	e8 34 fa ff ff       	call   80107720 <deallocuvm.part.0>
      kfree(mem);
80107cec:	83 ec 0c             	sub    $0xc,%esp
80107cef:	53                   	push   %ebx
80107cf0:	e8 cb a7 ff ff       	call   801024c0 <kfree>
      return 0;
80107cf5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107cfc:	83 c4 10             	add    $0x10,%esp
}
80107cff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d05:	5b                   	pop    %ebx
80107d06:	5e                   	pop    %esi
80107d07:	5f                   	pop    %edi
80107d08:	5d                   	pop    %ebp
80107d09:	c3                   	ret    
80107d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107d10 <deallocuvm>:
{
80107d10:	55                   	push   %ebp
80107d11:	89 e5                	mov    %esp,%ebp
80107d13:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d16:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107d19:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107d1c:	39 d1                	cmp    %edx,%ecx
80107d1e:	73 10                	jae    80107d30 <deallocuvm+0x20>
}
80107d20:	5d                   	pop    %ebp
80107d21:	e9 fa f9 ff ff       	jmp    80107720 <deallocuvm.part.0>
80107d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d2d:	8d 76 00             	lea    0x0(%esi),%esi
80107d30:	89 d0                	mov    %edx,%eax
80107d32:	5d                   	pop    %ebp
80107d33:	c3                   	ret    
80107d34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d3f:	90                   	nop

80107d40 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107d40:	55                   	push   %ebp
80107d41:	89 e5                	mov    %esp,%ebp
80107d43:	57                   	push   %edi
80107d44:	56                   	push   %esi
80107d45:	53                   	push   %ebx
80107d46:	83 ec 0c             	sub    $0xc,%esp
80107d49:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107d4c:	85 f6                	test   %esi,%esi
80107d4e:	74 59                	je     80107da9 <freevm+0x69>
  if(newsz >= oldsz)
80107d50:	31 c9                	xor    %ecx,%ecx
80107d52:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107d57:	89 f0                	mov    %esi,%eax
80107d59:	89 f3                	mov    %esi,%ebx
80107d5b:	e8 c0 f9 ff ff       	call   80107720 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107d60:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107d66:	eb 0f                	jmp    80107d77 <freevm+0x37>
80107d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d6f:	90                   	nop
80107d70:	83 c3 04             	add    $0x4,%ebx
80107d73:	39 df                	cmp    %ebx,%edi
80107d75:	74 23                	je     80107d9a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107d77:	8b 03                	mov    (%ebx),%eax
80107d79:	a8 01                	test   $0x1,%al
80107d7b:	74 f3                	je     80107d70 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107d7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107d82:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107d85:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107d88:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107d8d:	50                   	push   %eax
80107d8e:	e8 2d a7 ff ff       	call   801024c0 <kfree>
80107d93:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107d96:	39 df                	cmp    %ebx,%edi
80107d98:	75 dd                	jne    80107d77 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107d9a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107da0:	5b                   	pop    %ebx
80107da1:	5e                   	pop    %esi
80107da2:	5f                   	pop    %edi
80107da3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107da4:	e9 17 a7 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107da9:	83 ec 0c             	sub    $0xc,%esp
80107dac:	68 d1 8b 10 80       	push   $0x80108bd1
80107db1:	e8 ca 85 ff ff       	call   80100380 <panic>
80107db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dbd:	8d 76 00             	lea    0x0(%esi),%esi

80107dc0 <setupkvm>:
{
80107dc0:	55                   	push   %ebp
80107dc1:	89 e5                	mov    %esp,%ebp
80107dc3:	56                   	push   %esi
80107dc4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107dc5:	e8 b6 a8 ff ff       	call   80102680 <kalloc>
80107dca:	89 c6                	mov    %eax,%esi
80107dcc:	85 c0                	test   %eax,%eax
80107dce:	74 42                	je     80107e12 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107dd0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107dd3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107dd8:	68 00 10 00 00       	push   $0x1000
80107ddd:	6a 00                	push   $0x0
80107ddf:	50                   	push   %eax
80107de0:	e8 fb d1 ff ff       	call   80104fe0 <memset>
80107de5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107de8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107deb:	83 ec 08             	sub    $0x8,%esp
80107dee:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107df1:	ff 73 0c             	push   0xc(%ebx)
80107df4:	8b 13                	mov    (%ebx),%edx
80107df6:	50                   	push   %eax
80107df7:	29 c1                	sub    %eax,%ecx
80107df9:	89 f0                	mov    %esi,%eax
80107dfb:	e8 d0 f9 ff ff       	call   801077d0 <mappages>
80107e00:	83 c4 10             	add    $0x10,%esp
80107e03:	85 c0                	test   %eax,%eax
80107e05:	78 19                	js     80107e20 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e07:	83 c3 10             	add    $0x10,%ebx
80107e0a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107e10:	75 d6                	jne    80107de8 <setupkvm+0x28>
}
80107e12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e15:	89 f0                	mov    %esi,%eax
80107e17:	5b                   	pop    %ebx
80107e18:	5e                   	pop    %esi
80107e19:	5d                   	pop    %ebp
80107e1a:	c3                   	ret    
80107e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107e1f:	90                   	nop
      freevm(pgdir);
80107e20:	83 ec 0c             	sub    $0xc,%esp
80107e23:	56                   	push   %esi
      return 0;
80107e24:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107e26:	e8 15 ff ff ff       	call   80107d40 <freevm>
      return 0;
80107e2b:	83 c4 10             	add    $0x10,%esp
}
80107e2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e31:	89 f0                	mov    %esi,%eax
80107e33:	5b                   	pop    %ebx
80107e34:	5e                   	pop    %esi
80107e35:	5d                   	pop    %ebp
80107e36:	c3                   	ret    
80107e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e3e:	66 90                	xchg   %ax,%ax

80107e40 <kvmalloc>:
{
80107e40:	55                   	push   %ebp
80107e41:	89 e5                	mov    %esp,%ebp
80107e43:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107e46:	e8 75 ff ff ff       	call   80107dc0 <setupkvm>
80107e4b:	a3 c4 5d 11 80       	mov    %eax,0x80115dc4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107e50:	05 00 00 00 80       	add    $0x80000000,%eax
80107e55:	0f 22 d8             	mov    %eax,%cr3
}
80107e58:	c9                   	leave  
80107e59:	c3                   	ret    
80107e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107e60 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107e60:	55                   	push   %ebp
80107e61:	89 e5                	mov    %esp,%ebp
80107e63:	83 ec 08             	sub    $0x8,%esp
80107e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107e69:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107e6c:	89 c1                	mov    %eax,%ecx
80107e6e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107e71:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107e74:	f6 c2 01             	test   $0x1,%dl
80107e77:	75 17                	jne    80107e90 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107e79:	83 ec 0c             	sub    $0xc,%esp
80107e7c:	68 e2 8b 10 80       	push   $0x80108be2
80107e81:	e8 fa 84 ff ff       	call   80100380 <panic>
80107e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e8d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107e90:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107e93:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107e99:	25 fc 0f 00 00       	and    $0xffc,%eax
80107e9e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107ea5:	85 c0                	test   %eax,%eax
80107ea7:	74 d0                	je     80107e79 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107ea9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107eac:	c9                   	leave  
80107ead:	c3                   	ret    
80107eae:	66 90                	xchg   %ax,%ax

80107eb0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107eb0:	55                   	push   %ebp
80107eb1:	89 e5                	mov    %esp,%ebp
80107eb3:	57                   	push   %edi
80107eb4:	56                   	push   %esi
80107eb5:	53                   	push   %ebx
80107eb6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107eb9:	e8 02 ff ff ff       	call   80107dc0 <setupkvm>
80107ebe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ec1:	85 c0                	test   %eax,%eax
80107ec3:	0f 84 bd 00 00 00    	je     80107f86 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107ec9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107ecc:	85 c9                	test   %ecx,%ecx
80107ece:	0f 84 b2 00 00 00    	je     80107f86 <copyuvm+0xd6>
80107ed4:	31 f6                	xor    %esi,%esi
80107ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107edd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107ee0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107ee3:	89 f0                	mov    %esi,%eax
80107ee5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107ee8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80107eeb:	a8 01                	test   $0x1,%al
80107eed:	75 11                	jne    80107f00 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107eef:	83 ec 0c             	sub    $0xc,%esp
80107ef2:	68 ec 8b 10 80       	push   $0x80108bec
80107ef7:	e8 84 84 ff ff       	call   80100380 <panic>
80107efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107f00:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107f02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107f07:	c1 ea 0a             	shr    $0xa,%edx
80107f0a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107f10:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107f17:	85 c0                	test   %eax,%eax
80107f19:	74 d4                	je     80107eef <copyuvm+0x3f>
    if(!(*pte & PTE_P))
80107f1b:	8b 00                	mov    (%eax),%eax
80107f1d:	a8 01                	test   $0x1,%al
80107f1f:	0f 84 9f 00 00 00    	je     80107fc4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107f25:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107f27:	25 ff 0f 00 00       	and    $0xfff,%eax
80107f2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107f2f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107f35:	e8 46 a7 ff ff       	call   80102680 <kalloc>
80107f3a:	89 c3                	mov    %eax,%ebx
80107f3c:	85 c0                	test   %eax,%eax
80107f3e:	74 64                	je     80107fa4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107f40:	83 ec 04             	sub    $0x4,%esp
80107f43:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107f49:	68 00 10 00 00       	push   $0x1000
80107f4e:	57                   	push   %edi
80107f4f:	50                   	push   %eax
80107f50:	e8 2b d1 ff ff       	call   80105080 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107f55:	58                   	pop    %eax
80107f56:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107f5c:	5a                   	pop    %edx
80107f5d:	ff 75 e4             	push   -0x1c(%ebp)
80107f60:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f65:	89 f2                	mov    %esi,%edx
80107f67:	50                   	push   %eax
80107f68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f6b:	e8 60 f8 ff ff       	call   801077d0 <mappages>
80107f70:	83 c4 10             	add    $0x10,%esp
80107f73:	85 c0                	test   %eax,%eax
80107f75:	78 21                	js     80107f98 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107f77:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107f7d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107f80:	0f 87 5a ff ff ff    	ja     80107ee0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107f86:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f8c:	5b                   	pop    %ebx
80107f8d:	5e                   	pop    %esi
80107f8e:	5f                   	pop    %edi
80107f8f:	5d                   	pop    %ebp
80107f90:	c3                   	ret    
80107f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107f98:	83 ec 0c             	sub    $0xc,%esp
80107f9b:	53                   	push   %ebx
80107f9c:	e8 1f a5 ff ff       	call   801024c0 <kfree>
      goto bad;
80107fa1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107fa4:	83 ec 0c             	sub    $0xc,%esp
80107fa7:	ff 75 e0             	push   -0x20(%ebp)
80107faa:	e8 91 fd ff ff       	call   80107d40 <freevm>
  return 0;
80107faf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107fb6:	83 c4 10             	add    $0x10,%esp
}
80107fb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107fbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fbf:	5b                   	pop    %ebx
80107fc0:	5e                   	pop    %esi
80107fc1:	5f                   	pop    %edi
80107fc2:	5d                   	pop    %ebp
80107fc3:	c3                   	ret    
      panic("copyuvm: page not present");
80107fc4:	83 ec 0c             	sub    $0xc,%esp
80107fc7:	68 06 8c 10 80       	push   $0x80108c06
80107fcc:	e8 af 83 ff ff       	call   80100380 <panic>
80107fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fdf:	90                   	nop

80107fe0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107fe0:	55                   	push   %ebp
80107fe1:	89 e5                	mov    %esp,%ebp
80107fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107fe9:	89 c1                	mov    %eax,%ecx
80107feb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107fee:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107ff1:	f6 c2 01             	test   $0x1,%dl
80107ff4:	0f 84 00 01 00 00    	je     801080fa <uva2ka.cold>
  return &pgtab[PTX(va)];
80107ffa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107ffd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108003:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80108004:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80108009:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80108010:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108012:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108017:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010801a:	05 00 00 00 80       	add    $0x80000000,%eax
8010801f:	83 fa 05             	cmp    $0x5,%edx
80108022:	ba 00 00 00 00       	mov    $0x0,%edx
80108027:	0f 45 c2             	cmovne %edx,%eax
}
8010802a:	c3                   	ret    
8010802b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010802f:	90                   	nop

80108030 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108030:	55                   	push   %ebp
80108031:	89 e5                	mov    %esp,%ebp
80108033:	57                   	push   %edi
80108034:	56                   	push   %esi
80108035:	53                   	push   %ebx
80108036:	83 ec 0c             	sub    $0xc,%esp
80108039:	8b 75 14             	mov    0x14(%ebp),%esi
8010803c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010803f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108042:	85 f6                	test   %esi,%esi
80108044:	75 51                	jne    80108097 <copyout+0x67>
80108046:	e9 a5 00 00 00       	jmp    801080f0 <copyout+0xc0>
8010804b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010804f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80108050:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80108056:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010805c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80108062:	74 75                	je     801080d9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80108064:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108066:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80108069:	29 c3                	sub    %eax,%ebx
8010806b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108071:	39 f3                	cmp    %esi,%ebx
80108073:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80108076:	29 f8                	sub    %edi,%eax
80108078:	83 ec 04             	sub    $0x4,%esp
8010807b:	01 c1                	add    %eax,%ecx
8010807d:	53                   	push   %ebx
8010807e:	52                   	push   %edx
8010807f:	51                   	push   %ecx
80108080:	e8 fb cf ff ff       	call   80105080 <memmove>
    len -= n;
    buf += n;
80108085:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80108088:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010808e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80108091:	01 da                	add    %ebx,%edx
  while(len > 0){
80108093:	29 de                	sub    %ebx,%esi
80108095:	74 59                	je     801080f0 <copyout+0xc0>
  if(*pde & PTE_P){
80108097:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010809a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010809c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010809e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801080a1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801080a7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801080aa:	f6 c1 01             	test   $0x1,%cl
801080ad:	0f 84 4e 00 00 00    	je     80108101 <copyout.cold>
  return &pgtab[PTX(va)];
801080b3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801080b5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801080bb:	c1 eb 0c             	shr    $0xc,%ebx
801080be:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801080c4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801080cb:	89 d9                	mov    %ebx,%ecx
801080cd:	83 e1 05             	and    $0x5,%ecx
801080d0:	83 f9 05             	cmp    $0x5,%ecx
801080d3:	0f 84 77 ff ff ff    	je     80108050 <copyout+0x20>
  }
  return 0;
}
801080d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801080dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801080e1:	5b                   	pop    %ebx
801080e2:	5e                   	pop    %esi
801080e3:	5f                   	pop    %edi
801080e4:	5d                   	pop    %ebp
801080e5:	c3                   	ret    
801080e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801080ed:	8d 76 00             	lea    0x0(%esi),%esi
801080f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801080f3:	31 c0                	xor    %eax,%eax
}
801080f5:	5b                   	pop    %ebx
801080f6:	5e                   	pop    %esi
801080f7:	5f                   	pop    %edi
801080f8:	5d                   	pop    %ebp
801080f9:	c3                   	ret    

801080fa <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801080fa:	a1 00 00 00 00       	mov    0x0,%eax
801080ff:	0f 0b                	ud2    

80108101 <copyout.cold>:
80108101:	a1 00 00 00 00       	mov    0x0,%eax
80108106:	0f 0b                	ud2    
