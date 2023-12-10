
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
8010004c:	68 c0 7d 10 80       	push   $0x80107dc0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 b5 49 00 00       	call   80104a10 <initlock>
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
80100092:	68 c7 7d 10 80       	push   $0x80107dc7
80100097:	50                   	push   %eax
80100098:	e8 43 48 00 00       	call   801048e0 <initsleeplock>
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
801000e4:	e8 f7 4a 00 00       	call   80104be0 <acquire>
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
80100162:	e8 19 4a 00 00       	call   80104b80 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 47 00 00       	call   80104920 <acquiresleep>
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
801001a1:	68 ce 7d 10 80       	push   $0x80107dce
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
801001be:	e8 fd 47 00 00       	call   801049c0 <holdingsleep>
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
801001dc:	68 df 7d 10 80       	push   $0x80107ddf
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
801001ff:	e8 bc 47 00 00       	call   801049c0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 6c 47 00 00       	call   80104980 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 c0 49 00 00       	call   80104be0 <acquire>
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
8010026c:	e9 0f 49 00 00       	jmp    80104b80 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 e6 7d 10 80       	push   $0x80107de6
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
801002a0:	e8 3b 49 00 00       	call   80104be0 <acquire>
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
801002cd:	e8 5e 43 00 00       	call   80104630 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 49 37 00 00       	call   80103a30 <myproc>
801002e7:	8b 48 30             	mov    0x30(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 85 48 00 00       	call   80104b80 <release>
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
8010034c:	e8 2f 48 00 00       	call   80104b80 <release>
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
801003a2:	68 ed 7d 10 80       	push   $0x80107ded
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 4f 88 10 80 	movl   $0x8010884f,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 63 46 00 00       	call   80104a30 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 01 7e 10 80       	push   $0x80107e01
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
8010041a:	e8 c1 64 00 00       	call   801068e0 <uartputc>
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
80100505:	e8 d6 63 00 00       	call   801068e0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 ca 63 00 00       	call   801068e0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 be 63 00 00       	call   801068e0 <uartputc>
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
80100551:	e8 ea 47 00 00       	call   80104d40 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 35 47 00 00       	call   80104ca0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 05 7e 10 80       	push   $0x80107e05
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
801005ab:	e8 30 46 00 00       	call   80104be0 <acquire>
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
801005e4:	e8 97 45 00 00       	call   80104b80 <release>
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
80100636:	0f b6 92 30 7e 10 80 	movzbl -0x7fef81d0(%edx),%edx
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
801007e8:	e8 f3 43 00 00       	call   80104be0 <acquire>
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
80100838:	bf 18 7e 10 80       	mov    $0x80107e18,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 20 43 00 00       	call   80104b80 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 1f 7e 10 80       	push   $0x80107e1f
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
80100893:	e8 48 43 00 00       	call   80104be0 <acquire>
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
801009d0:	e8 ab 41 00 00       	call   80104b80 <release>
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
80100a0e:	e9 bd 3d 00 00       	jmp    801047d0 <procdump>
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
80100a44:	e8 a7 3c 00 00       	call   801046f0 <wakeup>
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
80100a66:	68 28 7e 10 80       	push   $0x80107e28
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 9b 3f 00 00       	call   80104a10 <initlock>

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
80100abc:	e8 6f 2f 00 00       	call   80103a30 <myproc>
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
80100b34:	e8 37 6f 00 00       	call   80107a70 <setupkvm>
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
80100ba3:	e8 e8 6c 00 00       	call   80107890 <allocuvm>
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
80100bd9:	e8 c2 6b 00 00       	call   801077a0 <loaduvm>
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
80100c1b:	e8 d0 6d 00 00       	call   801079f0 <freevm>
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
80100c62:	e8 29 6c 00 00       	call   80107890 <allocuvm>
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
80100c83:	e8 88 6e 00 00       	call   80107b10 <clearpteu>
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
80100cd3:	e8 c8 41 00 00       	call   80104ea0 <strlen>
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
80100ce7:	e8 b4 41 00 00       	call   80104ea0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 e3 6f 00 00       	call   80107ce0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 da 6c 00 00       	call   801079f0 <freevm>
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
80100d63:	e8 78 6f 00 00       	call   80107ce0 <copyout>
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
80100da1:	e8 ba 40 00 00       	call   80104e60 <safestrcpy>
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
80100dcd:	e8 3e 68 00 00       	call   80107610 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 16 6c 00 00       	call   801079f0 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 41 7e 10 80       	push   $0x80107e41
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
80100e16:	68 4d 7e 10 80       	push   $0x80107e4d
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 eb 3b 00 00       	call   80104a10 <initlock>
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
80100e41:	e8 9a 3d 00 00       	call   80104be0 <acquire>
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
80100e71:	e8 0a 3d 00 00       	call   80104b80 <release>
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
80100e8a:	e8 f1 3c 00 00       	call   80104b80 <release>
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
80100eaf:	e8 2c 3d 00 00       	call   80104be0 <acquire>
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
80100ecc:	e8 af 3c 00 00       	call   80104b80 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 54 7e 10 80       	push   $0x80107e54
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
80100f01:	e8 da 3c 00 00       	call   80104be0 <acquire>
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
80100f3c:	e8 3f 3c 00 00       	call   80104b80 <release>

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
80100f6e:	e9 0d 3c 00 00       	jmp    80104b80 <release>
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
80100fbc:	68 5c 7e 10 80       	push   $0x80107e5c
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
801010a2:	68 66 7e 10 80       	push   $0x80107e66
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
80101177:	68 6f 7e 10 80       	push   $0x80107e6f
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
801011b1:	68 75 7e 10 80       	push   $0x80107e75
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
80101227:	68 7f 7e 10 80       	push   $0x80107e7f
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
801012e4:	68 92 7e 10 80       	push   $0x80107e92
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
80101325:	e8 76 39 00 00       	call   80104ca0 <memset>
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
8010136a:	e8 71 38 00 00       	call   80104be0 <acquire>
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
801013d7:	e8 a4 37 00 00       	call   80104b80 <release>

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
80101405:	e8 76 37 00 00       	call   80104b80 <release>
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
80101438:	68 a8 7e 10 80       	push   $0x80107ea8
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
80101515:	68 b8 7e 10 80       	push   $0x80107eb8
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
80101541:	e8 fa 37 00 00       	call   80104d40 <memmove>
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
8010156c:	68 cb 7e 10 80       	push   $0x80107ecb
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 95 34 00 00       	call   80104a10 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 d2 7e 10 80       	push   $0x80107ed2
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 4c 33 00 00       	call   801048e0 <initsleeplock>
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
801015bc:	e8 7f 37 00 00       	call   80104d40 <memmove>
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
801015f3:	68 38 7f 10 80       	push   $0x80107f38
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
8010168e:	e8 0d 36 00 00       	call   80104ca0 <memset>
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
801016c3:	68 d8 7e 10 80       	push   $0x80107ed8
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
80101731:	e8 0a 36 00 00       	call   80104d40 <memmove>
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
8010175f:	e8 7c 34 00 00       	call   80104be0 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 0c 34 00 00       	call   80104b80 <release>
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
801017a2:	e8 79 31 00 00       	call   80104920 <acquiresleep>
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
80101818:	e8 23 35 00 00       	call   80104d40 <memmove>
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
8010183d:	68 f0 7e 10 80       	push   $0x80107ef0
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 ea 7e 10 80       	push   $0x80107eea
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
80101873:	e8 48 31 00 00       	call   801049c0 <holdingsleep>
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
8010188f:	e9 ec 30 00 00       	jmp    80104980 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 ff 7e 10 80       	push   $0x80107eff
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
801018c0:	e8 5b 30 00 00       	call   80104920 <acquiresleep>
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
801018da:	e8 a1 30 00 00       	call   80104980 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 f5 32 00 00       	call   80104be0 <acquire>
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
80101900:	e9 7b 32 00 00       	jmp    80104b80 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 cb 32 00 00       	call   80104be0 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 5c 32 00 00       	call   80104b80 <release>
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
80101a23:	e8 98 2f 00 00       	call   801049c0 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 41 2f 00 00       	call   80104980 <releasesleep>
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
80101a53:	68 ff 7e 10 80       	push   $0x80107eff
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
80101b37:	e8 04 32 00 00       	call   80104d40 <memmove>
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
80101c33:	e8 08 31 00 00       	call   80104d40 <memmove>
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
80101cce:	e8 dd 30 00 00       	call   80104db0 <strncmp>
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
80101d2d:	e8 7e 30 00 00       	call   80104db0 <strncmp>
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
80101d72:	68 19 7f 10 80       	push   $0x80107f19
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 07 7f 10 80       	push   $0x80107f07
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
80101daa:	e8 81 1c 00 00       	call   80103a30 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 74             	mov    0x74(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 21 2e 00 00       	call   80104be0 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 b1 2d 00 00       	call   80104b80 <release>
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
80101e27:	e8 14 2f 00 00       	call   80104d40 <memmove>
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
80101e8c:	e8 2f 2b 00 00       	call   801049c0 <holdingsleep>
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
80101eae:	e8 cd 2a 00 00       	call   80104980 <releasesleep>
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
80101edb:	e8 60 2e 00 00       	call   80104d40 <memmove>
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
80101f2b:	e8 90 2a 00 00       	call   801049c0 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 31 2a 00 00       	call   80104980 <releasesleep>
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
80101f6d:	e8 4e 2a 00 00       	call   801049c0 <holdingsleep>
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
80101f90:	e8 2b 2a 00 00       	call   801049c0 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 d4 29 00 00       	call   80104980 <releasesleep>
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
80101fcf:	68 ff 7e 10 80       	push   $0x80107eff
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
8010203d:	e8 be 2d 00 00       	call   80104e00 <strncpy>
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
8010207b:	68 28 7f 10 80       	push   $0x80107f28
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 0a 86 10 80       	push   $0x8010860a
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
8010219b:	68 94 7f 10 80       	push   $0x80107f94
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 8b 7f 10 80       	push   $0x80107f8b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 a6 7f 10 80       	push   $0x80107fa6
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 3b 28 00 00       	call   80104a10 <initlock>
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
8010224e:	e8 8d 29 00 00       	call   80104be0 <acquire>

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
801022ad:	e8 3e 24 00 00       	call   801046f0 <wakeup>

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
801022cb:	e8 b0 28 00 00       	call   80104b80 <release>

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
801022ee:	e8 cd 26 00 00       	call   801049c0 <holdingsleep>
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
80102328:	e8 b3 28 00 00       	call   80104be0 <acquire>

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
80102369:	e8 c2 22 00 00       	call   80104630 <sleep>
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
80102386:	e9 f5 27 00 00       	jmp    80104b80 <release>
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
801023aa:	68 d5 7f 10 80       	push   $0x80107fd5
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 c0 7f 10 80       	push   $0x80107fc0
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 aa 7f 10 80       	push   $0x80107faa
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
8010241a:	68 f4 7f 10 80       	push   $0x80107ff4
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
801024f2:	e8 a9 27 00 00       	call   80104ca0 <memset>

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
80102528:	e8 b3 26 00 00       	call   80104be0 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 38 26 00 00       	jmp    80104b80 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 26 80 10 80       	push   $0x80108026
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
8010261b:	68 2c 80 10 80       	push   $0x8010802c
80102620:	68 40 26 11 80       	push   $0x80112640
80102625:	e8 e6 23 00 00       	call   80104a10 <initlock>
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
801026b3:	e8 28 25 00 00       	call   80104be0 <acquire>
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
801026e1:	e8 9a 24 00 00       	call   80104b80 <release>
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
8010272b:	0f b6 91 60 81 10 80 	movzbl -0x7fef7ea0(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 60 80 10 80 	movzbl -0x7fef7fa0(%ecx),%eax
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
8010274b:	8b 04 85 40 80 10 80 	mov    -0x7fef7fc0(,%eax,4),%eax
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
80102788:	0f b6 81 60 81 10 80 	movzbl -0x7fef7ea0(%ecx),%eax
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
80102af7:	e8 f4 21 00 00       	call   80104cf0 <memcmp>
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
80102c24:	e8 17 21 00 00       	call   80104d40 <memmove>
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
80102cca:	68 60 82 10 80       	push   $0x80108260
80102ccf:	68 a0 26 11 80       	push   $0x801126a0
80102cd4:	e8 37 1d 00 00       	call   80104a10 <initlock>
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
80102d6b:	e8 70 1e 00 00       	call   80104be0 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 26 11 80       	push   $0x801126a0
80102d80:	68 a0 26 11 80       	push   $0x801126a0
80102d85:	e8 a6 18 00 00       	call   80104630 <sleep>
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
80102dbc:	e8 bf 1d 00 00       	call   80104b80 <release>
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
80102dde:	e8 fd 1d 00 00       	call   80104be0 <acquire>
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
80102e1c:	e8 5f 1d 00 00       	call   80104b80 <release>
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
80102e36:	e8 a5 1d 00 00       	call   80104be0 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102e42:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 9f 18 00 00       	call   801046f0 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e58:	e8 23 1d 00 00       	call   80104b80 <release>
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
80102eb4:	e8 87 1e 00 00       	call   80104d40 <memmove>
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
80102f08:	e8 e3 17 00 00       	call   801046f0 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f14:	e8 67 1c 00 00       	call   80104b80 <release>
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
80102f27:	68 64 82 10 80       	push   $0x80108264
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
80102f76:	e8 65 1c 00 00       	call   80104be0 <acquire>
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
80102fb5:	e9 c6 1b 00 00       	jmp    80104b80 <release>
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
80102fe1:	68 73 82 10 80       	push   $0x80108273
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 89 82 10 80       	push   $0x80108289
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
80103007:	e8 84 09 00 00       	call   80103990 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 7d 09 00 00       	call   80103990 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 a4 82 10 80       	push   $0x801082a4
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 e9 34 00 00       	call   80106510 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 04 09 00 00       	call   80103930 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 e1 11 00 00       	call   80104220 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 b5 45 00 00       	call   80107600 <switchkvm>
  seginit();
8010304b:	e8 20 45 00 00       	call   80107570 <seginit>
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
80103081:	e8 6a 4a 00 00       	call   80107af0 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 db 44 00 00       	call   80107570 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 57 37 00 00       	call   80106800 <uartinit>
  pinit();         // process table
801030a9:	e8 62 08 00 00       	call   80103910 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 dd 33 00 00       	call   80106490 <tvinit>
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
801030d4:	e8 67 1c 00 00       	call   80104d40 <memmove>

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
80103119:	e8 12 08 00 00       	call   80103930 <mycpu>
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
80103182:	e8 d9 08 00 00       	call   80103a60 <userinit>
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
801031be:	68 b8 82 10 80       	push   $0x801082b8
801031c3:	56                   	push   %esi
801031c4:	e8 27 1b 00 00       	call   80104cf0 <memcmp>
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
80103276:	68 bd 82 10 80       	push   $0x801082bd
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 6c 1a 00 00       	call   80104cf0 <memcmp>
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
80103393:	68 c2 82 10 80       	push   $0x801082c2
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
801033c2:	68 b8 82 10 80       	push   $0x801082b8
801033c7:	53                   	push   %ebx
801033c8:	e8 23 19 00 00       	call   80104cf0 <memcmp>
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
801033f8:	68 dc 82 10 80       	push   $0x801082dc
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
801034a3:	68 fb 82 10 80       	push   $0x801082fb
801034a8:	50                   	push   %eax
801034a9:	e8 62 15 00 00       	call   80104a10 <initlock>
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
8010353f:	e8 9c 16 00 00       	call   80104be0 <acquire>
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
8010355f:	e8 8c 11 00 00       	call   801046f0 <wakeup>
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
80103584:	e9 f7 15 00 00       	jmp    80104b80 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 e7 15 00 00       	call   80104b80 <release>
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
801035c4:	e8 27 11 00 00       	call   801046f0 <wakeup>
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
801035dd:	e8 fe 15 00 00       	call   80104be0 <acquire>
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
80103628:	e8 03 04 00 00       	call   80103a30 <myproc>
8010362d:	8b 48 30             	mov    0x30(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 b3 10 00 00       	call   801046f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 ea 0f 00 00       	call   80104630 <sleep>
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
8010366c:	e8 0f 15 00 00       	call   80104b80 <release>
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
801036ba:	e8 31 10 00 00       	call   801046f0 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 b9 14 00 00       	call   80104b80 <release>
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
801036e6:	e8 f5 14 00 00       	call   80104be0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 2b 03 00 00       	call   80103a30 <myproc>
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
80103715:	e8 16 0f 00 00       	call   80104630 <sleep>
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
80103776:	e8 75 0f 00 00       	call   801046f0 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 fd 13 00 00       	call   80104b80 <release>
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
80103799:	e8 e2 13 00 00       	call   80104b80 <release>
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
801037c1:	e8 1a 14 00 00       	call   80104be0 <acquire>
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
  p->executed_cycle = 1.0f;
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
  p->executed_cycle = 1.0f;
80103809:	d9 93 94 00 00 00    	fsts   0x94(%ebx)
  p->executed_cycle_ratio = 1.0f;
8010380f:	d9 93 98 00 00 00    	fsts   0x98(%ebx)
  p->pid = nextpid++;
80103815:	89 43 10             	mov    %eax,0x10(%ebx)
  p->process_size_ratio = 1.0f;
80103818:	d9 9b 9c 00 00 00    	fstps  0x9c(%ebx)
  p->que_id = LCFS;
8010381e:	c7 43 28 02 00 00 00 	movl   $0x2,0x28(%ebx)
  p->priority = PRIORITY_DEF;
80103825:	c7 83 88 00 00 00 03 	movl   $0x3,0x88(%ebx)
8010382c:	00 00 00 
  release(&ptable.lock);
8010382f:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103834:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
8010383a:	e8 41 13 00 00       	call   80104b80 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
8010383f:	e8 3c ee ff ff       	call   80102680 <kalloc>
80103844:	83 c4 10             	add    $0x10,%esp
80103847:	89 43 08             	mov    %eax,0x8(%ebx)
8010384a:	85 c0                	test   %eax,%eax
8010384c:	74 5b                	je     801038a9 <allocproc+0xf9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010384e:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
80103854:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103857:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010385c:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
8010385f:	c7 40 14 77 64 10 80 	movl   $0x80106477,0x14(%eax)
  p->context = (struct context *)sp;
80103866:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103869:	6a 14                	push   $0x14
8010386b:	6a 00                	push   $0x0
8010386d:	50                   	push   %eax
8010386e:	e8 2d 14 00 00       	call   80104ca0 <memset>
  p->context->eip = (uint)forkret;
80103873:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103876:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103879:	c7 40 10 c0 38 10 80 	movl   $0x801038c0,0x10(%eax)
}
80103880:	89 d8                	mov    %ebx,%eax
80103882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103885:	c9                   	leave  
80103886:	c3                   	ret    
80103887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010388e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103890:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103893:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103895:	68 20 2d 11 80       	push   $0x80112d20
8010389a:	e8 e1 12 00 00       	call   80104b80 <release>
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
801038cb:	e8 b0 12 00 00       	call   80104b80 <release>

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
80103916:	68 00 83 10 80       	push   $0x80108300
8010391b:	68 20 2d 11 80       	push   $0x80112d20
80103920:	e8 eb 10 00 00       	call   80104a10 <initlock>
}
80103925:	83 c4 10             	add    $0x10,%esp
80103928:	c9                   	leave  
80103929:	c3                   	ret    
8010392a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103930 <mycpu>:
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	56                   	push   %esi
80103934:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103935:	9c                   	pushf  
80103936:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103937:	f6 c4 02             	test   $0x2,%ah
8010393a:	75 46                	jne    80103982 <mycpu+0x52>
  apicid = lapicid();
8010393c:	e8 af ef ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i)
80103941:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103947:	85 f6                	test   %esi,%esi
80103949:	7e 2a                	jle    80103975 <mycpu+0x45>
8010394b:	31 d2                	xor    %edx,%edx
8010394d:	eb 08                	jmp    80103957 <mycpu+0x27>
8010394f:	90                   	nop
80103950:	83 c2 01             	add    $0x1,%edx
80103953:	39 f2                	cmp    %esi,%edx
80103955:	74 1e                	je     80103975 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103957:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010395d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103964:	39 c3                	cmp    %eax,%ebx
80103966:	75 e8                	jne    80103950 <mycpu+0x20>
}
80103968:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010396b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103971:	5b                   	pop    %ebx
80103972:	5e                   	pop    %esi
80103973:	5d                   	pop    %ebp
80103974:	c3                   	ret    
  panic("unknown apicid\n");
80103975:	83 ec 0c             	sub    $0xc,%esp
80103978:	68 07 83 10 80       	push   $0x80108307
8010397d:	e8 fe c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103982:	83 ec 0c             	sub    $0xc,%esp
80103985:	68 38 84 10 80       	push   $0x80108438
8010398a:	e8 f1 c9 ff ff       	call   80100380 <panic>
8010398f:	90                   	nop

80103990 <cpuid>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
80103996:	e8 95 ff ff ff       	call   80103930 <mycpu>
}
8010399b:	c9                   	leave  
  return mycpu() - cpus;
8010399c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
801039a1:	c1 f8 04             	sar    $0x4,%eax
801039a4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039aa:	c3                   	ret    
801039ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039af:	90                   	nop

801039b0 <reset_bjf_attributes>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	83 ec 24             	sub    $0x24,%esp
801039b6:	d9 45 0c             	flds   0xc(%ebp)
  acquire(&ptable.lock);
801039b9:	68 20 2d 11 80       	push   $0x80112d20
{
801039be:	d9 5d ec             	fstps  -0x14(%ebp)
801039c1:	d9 45 10             	flds   0x10(%ebp)
801039c4:	d9 5d f0             	fstps  -0x10(%ebp)
801039c7:	d9 45 14             	flds   0x14(%ebp)
801039ca:	d9 5d f4             	fstps  -0xc(%ebp)
  acquire(&ptable.lock);
801039cd:	e8 0e 12 00 00       	call   80104be0 <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039d2:	d9 45 ec             	flds   -0x14(%ebp)
801039d5:	d9 45 f0             	flds   -0x10(%ebp)
  acquire(&ptable.lock);
801039d8:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039db:	d9 45 f4             	flds   -0xc(%ebp)
801039de:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801039e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039e7:	90                   	nop
    if (p->state != UNUSED)
801039e8:	8b 50 0c             	mov    0xc(%eax),%edx
801039eb:	85 d2                	test   %edx,%edx
801039ed:	74 1e                	je     80103a0d <reset_bjf_attributes+0x5d>
801039ef:	d9 ca                	fxch   %st(2)
      p->creation_time_ratio = creation_time_ratio;
801039f1:	d9 90 90 00 00 00    	fsts   0x90(%eax)
801039f7:	d9 c9                	fxch   %st(1)
      p->executed_cycle_ratio = exec_cycle_ratio;
801039f9:	d9 90 98 00 00 00    	fsts   0x98(%eax)
801039ff:	d9 ca                	fxch   %st(2)
      p->priority_ratio = size_ratio;
80103a01:	d9 90 8c 00 00 00    	fsts   0x8c(%eax)
80103a07:	d9 c9                	fxch   %st(1)
80103a09:	d9 ca                	fxch   %st(2)
80103a0b:	d9 c9                	fxch   %st(1)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a0d:	05 a0 00 00 00       	add    $0xa0,%eax
80103a12:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80103a17:	75 cf                	jne    801039e8 <reset_bjf_attributes+0x38>
80103a19:	dd d8                	fstp   %st(0)
80103a1b:	dd d8                	fstp   %st(0)
80103a1d:	dd d8                	fstp   %st(0)
  release(&ptable.lock);
80103a1f:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103a26:	c9                   	leave  
  release(&ptable.lock);
80103a27:	e9 54 11 00 00       	jmp    80104b80 <release>
80103a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a30 <myproc>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	53                   	push   %ebx
80103a34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a37:	e8 54 10 00 00       	call   80104a90 <pushcli>
  c = mycpu();
80103a3c:	e8 ef fe ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103a41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a47:	e8 94 10 00 00       	call   80104ae0 <popcli>
}
80103a4c:	89 d8                	mov    %ebx,%eax
80103a4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a51:	c9                   	leave  
80103a52:	c3                   	ret    
80103a53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a60 <userinit>:
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	53                   	push   %ebx
80103a64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a67:	e8 44 fd ff ff       	call   801037b0 <allocproc>
80103a6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a6e:	a3 54 55 11 80       	mov    %eax,0x80115554
  if ((p->pgdir = setupkvm()) == 0)
80103a73:	e8 f8 3f 00 00       	call   80107a70 <setupkvm>
80103a78:	89 43 04             	mov    %eax,0x4(%ebx)
80103a7b:	85 c0                	test   %eax,%eax
80103a7d:	0f 84 bd 00 00 00    	je     80103b40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a83:	83 ec 04             	sub    $0x4,%esp
80103a86:	68 2c 00 00 00       	push   $0x2c
80103a8b:	68 60 b4 10 80       	push   $0x8010b460
80103a90:	50                   	push   %eax
80103a91:	e8 8a 3c 00 00       	call   80107720 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a9f:	6a 4c                	push   $0x4c
80103aa1:	6a 00                	push   $0x0
80103aa3:	ff 73 18             	push   0x18(%ebx)
80103aa6:	e8 f5 11 00 00       	call   80104ca0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103aab:	8b 43 18             	mov    0x18(%ebx),%eax
80103aae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ab3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ab6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103abb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103abf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ac6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103acd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ad1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ad4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ad8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103adc:	8b 43 18             	mov    0x18(%ebx),%eax
80103adf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ae6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103af0:	8b 43 18             	mov    0x18(%ebx),%eax
80103af3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103afa:	8d 43 78             	lea    0x78(%ebx),%eax
80103afd:	6a 10                	push   $0x10
80103aff:	68 30 83 10 80       	push   $0x80108330
80103b04:	50                   	push   %eax
80103b05:	e8 56 13 00 00       	call   80104e60 <safestrcpy>
  p->cwd = namei("/");
80103b0a:	c7 04 24 39 83 10 80 	movl   $0x80108339,(%esp)
80103b11:	e8 8a e5 ff ff       	call   801020a0 <namei>
80103b16:	89 43 74             	mov    %eax,0x74(%ebx)
  acquire(&ptable.lock);
80103b19:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b20:	e8 bb 10 00 00       	call   80104be0 <acquire>
  p->state = RUNNABLE;
80103b25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b2c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b33:	e8 48 10 00 00       	call   80104b80 <release>
}
80103b38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b3b:	83 c4 10             	add    $0x10,%esp
80103b3e:	c9                   	leave  
80103b3f:	c3                   	ret    
    panic("userinit: out of memory?");
80103b40:	83 ec 0c             	sub    $0xc,%esp
80103b43:	68 17 83 10 80       	push   $0x80108317
80103b48:	e8 33 c8 ff ff       	call   80100380 <panic>
80103b4d:	8d 76 00             	lea    0x0(%esi),%esi

80103b50 <print_name>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	57                   	push   %edi
80103b54:	56                   	push   %esi
  memset(buf, ' ', 16);
80103b55:	8d 7d d7             	lea    -0x29(%ebp),%edi
{
80103b58:	53                   	push   %ebx
  for (int i = 0; i < strlen(name); i++)
80103b59:	31 db                	xor    %ebx,%ebx
{
80103b5b:	83 ec 30             	sub    $0x30,%esp
80103b5e:	8b 75 08             	mov    0x8(%ebp),%esi
  memset(buf, ' ', 16);
80103b61:	6a 10                	push   $0x10
80103b63:	6a 20                	push   $0x20
80103b65:	57                   	push   %edi
80103b66:	e8 35 11 00 00       	call   80104ca0 <memset>
  buf[16] = 0;
80103b6b:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for (int i = 0; i < strlen(name); i++)
80103b6f:	83 c4 10             	add    $0x10,%esp
80103b72:	eb 0e                	jmp    80103b82 <print_name+0x32>
80103b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i] = name[i];
80103b78:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80103b7c:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for (int i = 0; i < strlen(name); i++)
80103b7f:	83 c3 01             	add    $0x1,%ebx
80103b82:	83 ec 0c             	sub    $0xc,%esp
80103b85:	56                   	push   %esi
80103b86:	e8 15 13 00 00       	call   80104ea0 <strlen>
80103b8b:	83 c4 10             	add    $0x10,%esp
80103b8e:	39 d8                	cmp    %ebx,%eax
80103b90:	7f e6                	jg     80103b78 <print_name+0x28>
  cprintf("%s", buf);
80103b92:	83 ec 08             	sub    $0x8,%esp
80103b95:	57                   	push   %edi
80103b96:	68 08 84 10 80       	push   $0x80108408
80103b9b:	e8 00 cb ff ff       	call   801006a0 <cprintf>
}
80103ba0:	83 c4 10             	add    $0x10,%esp
80103ba3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ba6:	5b                   	pop    %ebx
80103ba7:	5e                   	pop    %esi
80103ba8:	5f                   	pop    %edi
80103ba9:	5d                   	pop    %ebp
80103baa:	c3                   	ret    
80103bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103baf:	90                   	nop

80103bb0 <find_proc>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	56                   	push   %esi
80103bb4:	53                   	push   %ebx
80103bb5:	8b 75 08             	mov    0x8(%ebp),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bb8:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  acquire(&ptable.lock);
80103bbd:	83 ec 0c             	sub    $0xc,%esp
80103bc0:	68 20 2d 11 80       	push   $0x80112d20
80103bc5:	e8 16 10 00 00       	call   80104be0 <acquire>
80103bca:	83 c4 10             	add    $0x10,%esp
80103bcd:	eb 0f                	jmp    80103bde <find_proc+0x2e>
80103bcf:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bd0:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103bd6:	81 fb 54 55 11 80    	cmp    $0x80115554,%ebx
80103bdc:	74 05                	je     80103be3 <find_proc+0x33>
    if (p->pid == pid)
80103bde:	39 73 10             	cmp    %esi,0x10(%ebx)
80103be1:	75 ed                	jne    80103bd0 <find_proc+0x20>
  release(&ptable.lock);
80103be3:	83 ec 0c             	sub    $0xc,%esp
80103be6:	68 20 2d 11 80       	push   $0x80112d20
80103beb:	e8 90 0f 00 00       	call   80104b80 <release>
}
80103bf0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bf3:	89 d8                	mov    %ebx,%eax
80103bf5:	5b                   	pop    %ebx
80103bf6:	5e                   	pop    %esi
80103bf7:	5d                   	pop    %ebp
80103bf8:	c3                   	ret    
80103bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c00 <print_state>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	8b 45 08             	mov    0x8(%ebp),%eax
  switch (state)
80103c06:	83 f8 05             	cmp    $0x5,%eax
80103c09:	77 6a                	ja     80103c75 <print_state+0x75>
80103c0b:	ff 24 85 d0 84 10 80 	jmp    *-0x7fef7b30(,%eax,4)
80103c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("RUNNING ");
80103c18:	c7 45 08 5f 83 10 80 	movl   $0x8010835f,0x8(%ebp)
}
80103c1f:	5d                   	pop    %ebp
    cprintf("RUNNING ");
80103c20:	e9 7b ca ff ff       	jmp    801006a0 <cprintf>
80103c25:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("ZOMBIE ");
80103c28:	c7 45 08 68 83 10 80 	movl   $0x80108368,0x8(%ebp)
}
80103c2f:	5d                   	pop    %ebp
    cprintf("ZOMBIE ");
80103c30:	e9 6b ca ff ff       	jmp    801006a0 <cprintf>
80103c35:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("UNUSED ");
80103c38:	c7 45 08 3b 83 10 80 	movl   $0x8010833b,0x8(%ebp)
}
80103c3f:	5d                   	pop    %ebp
    cprintf("UNUSED ");
80103c40:	e9 5b ca ff ff       	jmp    801006a0 <cprintf>
80103c45:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("EMBRYO ");
80103c48:	c7 45 08 43 83 10 80 	movl   $0x80108343,0x8(%ebp)
}
80103c4f:	5d                   	pop    %ebp
    cprintf("EMBRYO ");
80103c50:	e9 4b ca ff ff       	jmp    801006a0 <cprintf>
80103c55:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("SLEEPING ");
80103c58:	c7 45 08 4b 83 10 80 	movl   $0x8010834b,0x8(%ebp)
}
80103c5f:	5d                   	pop    %ebp
    cprintf("SLEEPING ");
80103c60:	e9 3b ca ff ff       	jmp    801006a0 <cprintf>
80103c65:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("RUNNABLE ");
80103c68:	c7 45 08 55 83 10 80 	movl   $0x80108355,0x8(%ebp)
}
80103c6f:	5d                   	pop    %ebp
    cprintf("RUNNABLE ");
80103c70:	e9 2b ca ff ff       	jmp    801006a0 <cprintf>
    cprintf("damn ways to die");
80103c75:	c7 45 08 70 83 10 80 	movl   $0x80108370,0x8(%ebp)
}
80103c7c:	5d                   	pop    %ebp
    cprintf("damn ways to die");
80103c7d:	e9 1e ca ff ff       	jmp    801006a0 <cprintf>
80103c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c90 <print_bitches>:
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	53                   	push   %ebx
  cprintf("process_name    PID    State    Queue    Cycle    Arrival    Priority    R_prty    R_Arvl    R_exec    Rank\n");
80103c94:	bb 50 00 00 00       	mov    $0x50,%ebx
{
80103c99:	83 ec 20             	sub    $0x20,%esp
  acquire(&ptable.lock);
80103c9c:	68 20 2d 11 80       	push   $0x80112d20
80103ca1:	e8 3a 0f 00 00       	call   80104be0 <acquire>
  cprintf("process_name    PID    State    Queue    Cycle    Arrival    Priority    R_prty    R_Arvl    R_exec    Rank\n");
80103ca6:	c7 04 24 60 84 10 80 	movl   $0x80108460,(%esp)
80103cad:	e8 ee c9 ff ff       	call   801006a0 <cprintf>
80103cb2:	83 c4 10             	add    $0x10,%esp
80103cb5:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("-");
80103cb8:	83 ec 0c             	sub    $0xc,%esp
80103cbb:	68 81 83 10 80       	push   $0x80108381
80103cc0:	e8 db c9 ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < 80; i++)
80103cc5:	83 c4 10             	add    $0x10,%esp
80103cc8:	83 eb 01             	sub    $0x1,%ebx
80103ccb:	75 eb                	jne    80103cb8 <print_bitches+0x28>
  cprintf("\n");
80103ccd:	83 ec 0c             	sub    $0xc,%esp
80103cd0:	bb cc 2d 11 80       	mov    $0x80112dcc,%ebx
80103cd5:	68 4f 88 10 80       	push   $0x8010884f
80103cda:	e8 c1 c9 ff ff       	call   801006a0 <cprintf>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cdf:	83 c4 10             	add    $0x10,%esp
80103ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (p->state == UNUSED)
80103ce8:	8b 43 94             	mov    -0x6c(%ebx),%eax
80103ceb:	85 c0                	test   %eax,%eax
80103ced:	0f 84 e2 00 00 00    	je     80103dd5 <print_bitches+0x145>
    print_name(p->name);
80103cf3:	83 ec 0c             	sub    $0xc,%esp
80103cf6:	53                   	push   %ebx
80103cf7:	e8 54 fe ff ff       	call   80103b50 <print_name>
    cprintf("%d  ", p->pid);
80103cfc:	58                   	pop    %eax
80103cfd:	5a                   	pop    %edx
80103cfe:	ff 73 98             	push   -0x68(%ebx)
80103d01:	68 83 83 10 80       	push   $0x80108383
80103d06:	e8 95 c9 ff ff       	call   801006a0 <cprintf>
    print_state((*p).state);
80103d0b:	59                   	pop    %ecx
80103d0c:	ff 73 94             	push   -0x6c(%ebx)
80103d0f:	e8 ec fe ff ff       	call   80103c00 <print_state>
    cprintf("%d   ", p->que_id);
80103d14:	58                   	pop    %eax
80103d15:	5a                   	pop    %edx
80103d16:	ff 73 b0             	push   -0x50(%ebx)
80103d19:	68 88 83 10 80       	push   $0x80108388
80103d1e:	e8 7d c9 ff ff       	call   801006a0 <cprintf>
    cprintf("%d   ", p->executed_cycle);
80103d23:	d9 43 1c             	flds   0x1c(%ebx)
80103d26:	c7 04 24 88 83 10 80 	movl   $0x80108388,(%esp)
80103d2d:	dd 5c 24 04          	fstpl  0x4(%esp)
80103d31:	e8 6a c9 ff ff       	call   801006a0 <cprintf>
    cprintf("%d   ", p->creation_time);
80103d36:	59                   	pop    %ecx
80103d37:	58                   	pop    %eax
80103d38:	ff 73 a8             	push   -0x58(%ebx)
80103d3b:	68 88 83 10 80       	push   $0x80108388
80103d40:	e8 5b c9 ff ff       	call   801006a0 <cprintf>
    cprintf("%d   ", p->priority);
80103d45:	58                   	pop    %eax
80103d46:	5a                   	pop    %edx
80103d47:	ff 73 10             	push   0x10(%ebx)
80103d4a:	68 88 83 10 80       	push   $0x80108388
80103d4f:	e8 4c c9 ff ff       	call   801006a0 <cprintf>
    cprintf("%d   ", (int)p->priority_ratio);
80103d54:	d9 43 14             	flds   0x14(%ebx)
80103d57:	59                   	pop    %ecx
80103d58:	d9 7d f6             	fnstcw -0xa(%ebp)
80103d5b:	58                   	pop    %eax
80103d5c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80103d60:	80 cc 0c             	or     $0xc,%ah
80103d63:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80103d67:	d9 6d f4             	fldcw  -0xc(%ebp)
80103d6a:	db 5d f0             	fistpl -0x10(%ebp)
80103d6d:	d9 6d f6             	fldcw  -0xa(%ebp)
80103d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d73:	50                   	push   %eax
80103d74:	68 88 83 10 80       	push   $0x80108388
80103d79:	e8 22 c9 ff ff       	call   801006a0 <cprintf>
    cprintf("%d   ", (int)p->creation_time_ratio);
80103d7e:	d9 43 18             	flds   0x18(%ebx)
80103d81:	58                   	pop    %eax
80103d82:	d9 7d f6             	fnstcw -0xa(%ebp)
80103d85:	5a                   	pop    %edx
80103d86:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80103d8a:	80 cc 0c             	or     $0xc,%ah
80103d8d:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80103d91:	d9 6d f4             	fldcw  -0xc(%ebp)
80103d94:	db 5d f0             	fistpl -0x10(%ebp)
80103d97:	d9 6d f6             	fldcw  -0xa(%ebp)
80103d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d9d:	50                   	push   %eax
80103d9e:	68 88 83 10 80       	push   $0x80108388
80103da3:	e8 f8 c8 ff ff       	call   801006a0 <cprintf>
    cprintf("%d\n", (int)p->executed_cycle_ratio);
80103da8:	d9 43 20             	flds   0x20(%ebx)
80103dab:	59                   	pop    %ecx
80103dac:	d9 7d f6             	fnstcw -0xa(%ebp)
80103daf:	58                   	pop    %eax
80103db0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80103db4:	80 cc 0c             	or     $0xc,%ah
80103db7:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80103dbb:	d9 6d f4             	fldcw  -0xc(%ebp)
80103dbe:	db 5d f0             	fistpl -0x10(%ebp)
80103dc1:	d9 6d f6             	fldcw  -0xa(%ebp)
80103dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dc7:	50                   	push   %eax
80103dc8:	68 b4 82 10 80       	push   $0x801082b4
80103dcd:	e8 ce c8 ff ff       	call   801006a0 <cprintf>
80103dd2:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dd5:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103ddb:	81 fb cc 55 11 80    	cmp    $0x801155cc,%ebx
80103de1:	0f 85 01 ff ff ff    	jne    80103ce8 <print_bitches+0x58>
  release(&ptable.lock);
80103de7:	83 ec 0c             	sub    $0xc,%esp
80103dea:	68 20 2d 11 80       	push   $0x80112d20
80103def:	e8 8c 0d 00 00       	call   80104b80 <release>
}
80103df4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103df7:	83 c4 10             	add    $0x10,%esp
80103dfa:	c9                   	leave  
80103dfb:	c3                   	ret    
80103dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e00 <count_child>:
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	53                   	push   %ebx
  int count = 0;
80103e04:	31 db                	xor    %ebx,%ebx
{
80103e06:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103e09:	68 20 2d 11 80       	push   $0x80112d20
80103e0e:	e8 cd 0d 00 00       	call   80104be0 <acquire>
    if (p->parent->pid == father->pid)
80103e13:	8b 45 08             	mov    0x8(%ebp),%eax
80103e16:	83 c4 10             	add    $0x10,%esp
80103e19:	8b 48 10             	mov    0x10(%eax),%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e1c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p->parent->pid == father->pid)
80103e28:	8b 50 14             	mov    0x14(%eax),%edx
      count++;
80103e2b:	39 4a 10             	cmp    %ecx,0x10(%edx)
80103e2e:	0f 94 c2             	sete   %dl
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e31:	05 a0 00 00 00       	add    $0xa0,%eax
      count++;
80103e36:	0f b6 d2             	movzbl %dl,%edx
80103e39:	01 d3                	add    %edx,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e3b:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80103e40:	75 e6                	jne    80103e28 <count_child+0x28>
  release(&ptable.lock);
80103e42:	83 ec 0c             	sub    $0xc,%esp
80103e45:	68 20 2d 11 80       	push   $0x80112d20
80103e4a:	e8 31 0d 00 00       	call   80104b80 <release>
}
80103e4f:	89 d8                	mov    %ebx,%eax
80103e51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e54:	c9                   	leave  
80103e55:	c3                   	ret    
80103e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e5d:	8d 76 00             	lea    0x0(%esi),%esi

80103e60 <growproc>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	56                   	push   %esi
80103e64:	53                   	push   %ebx
80103e65:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103e68:	e8 23 0c 00 00       	call   80104a90 <pushcli>
  c = mycpu();
80103e6d:	e8 be fa ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103e72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e78:	e8 63 0c 00 00       	call   80104ae0 <popcli>
  sz = curproc->sz;
80103e7d:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
80103e7f:	85 f6                	test   %esi,%esi
80103e81:	7f 1d                	jg     80103ea0 <growproc+0x40>
  else if (n < 0)
80103e83:	75 3b                	jne    80103ec0 <growproc+0x60>
  switchuvm(curproc);
80103e85:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103e88:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103e8a:	53                   	push   %ebx
80103e8b:	e8 80 37 00 00       	call   80107610 <switchuvm>
  return 0;
80103e90:	83 c4 10             	add    $0x10,%esp
80103e93:	31 c0                	xor    %eax,%eax
}
80103e95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e98:	5b                   	pop    %ebx
80103e99:	5e                   	pop    %esi
80103e9a:	5d                   	pop    %ebp
80103e9b:	c3                   	ret    
80103e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ea0:	83 ec 04             	sub    $0x4,%esp
80103ea3:	01 c6                	add    %eax,%esi
80103ea5:	56                   	push   %esi
80103ea6:	50                   	push   %eax
80103ea7:	ff 73 04             	push   0x4(%ebx)
80103eaa:	e8 e1 39 00 00       	call   80107890 <allocuvm>
80103eaf:	83 c4 10             	add    $0x10,%esp
80103eb2:	85 c0                	test   %eax,%eax
80103eb4:	75 cf                	jne    80103e85 <growproc+0x25>
      return -1;
80103eb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ebb:	eb d8                	jmp    80103e95 <growproc+0x35>
80103ebd:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ec0:	83 ec 04             	sub    $0x4,%esp
80103ec3:	01 c6                	add    %eax,%esi
80103ec5:	56                   	push   %esi
80103ec6:	50                   	push   %eax
80103ec7:	ff 73 04             	push   0x4(%ebx)
80103eca:	e8 f1 3a 00 00       	call   801079c0 <deallocuvm>
80103ecf:	83 c4 10             	add    $0x10,%esp
80103ed2:	85 c0                	test   %eax,%eax
80103ed4:	75 af                	jne    80103e85 <growproc+0x25>
80103ed6:	eb de                	jmp    80103eb6 <growproc+0x56>
80103ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edf:	90                   	nop

80103ee0 <fork>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	57                   	push   %edi
80103ee4:	56                   	push   %esi
80103ee5:	53                   	push   %ebx
80103ee6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ee9:	e8 a2 0b 00 00       	call   80104a90 <pushcli>
  c = mycpu();
80103eee:	e8 3d fa ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103ef3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ef9:	e8 e2 0b 00 00       	call   80104ae0 <popcli>
  if ((np = allocproc()) == 0)
80103efe:	e8 ad f8 ff ff       	call   801037b0 <allocproc>
80103f03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103f06:	85 c0                	test   %eax,%eax
80103f08:	0f 84 da 00 00 00    	je     80103fe8 <fork+0x108>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80103f0e:	83 ec 08             	sub    $0x8,%esp
80103f11:	ff 33                	push   (%ebx)
80103f13:	89 c7                	mov    %eax,%edi
80103f15:	ff 73 04             	push   0x4(%ebx)
80103f18:	e8 43 3c 00 00       	call   80107b60 <copyuvm>
80103f1d:	83 c4 10             	add    $0x10,%esp
80103f20:	89 47 04             	mov    %eax,0x4(%edi)
80103f23:	85 c0                	test   %eax,%eax
80103f25:	0f 84 c4 00 00 00    	je     80103fef <fork+0x10f>
  np->sz = curproc->sz;
80103f2b:	8b 03                	mov    (%ebx),%eax
80103f2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103f30:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103f32:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103f35:	89 c8                	mov    %ecx,%eax
80103f37:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103f3a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103f3f:	8b 73 18             	mov    0x18(%ebx),%esi
80103f42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80103f44:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103f46:	8b 40 18             	mov    0x18(%eax),%eax
80103f49:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if (curproc->ofile[i])
80103f50:	8b 44 b3 34          	mov    0x34(%ebx,%esi,4),%eax
80103f54:	85 c0                	test   %eax,%eax
80103f56:	74 13                	je     80103f6b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f58:	83 ec 0c             	sub    $0xc,%esp
80103f5b:	50                   	push   %eax
80103f5c:	e8 3f cf ff ff       	call   80100ea0 <filedup>
80103f61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f64:	83 c4 10             	add    $0x10,%esp
80103f67:	89 44 b2 34          	mov    %eax,0x34(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
80103f6b:	83 c6 01             	add    $0x1,%esi
80103f6e:	83 fe 10             	cmp    $0x10,%esi
80103f71:	75 dd                	jne    80103f50 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103f73:	83 ec 0c             	sub    $0xc,%esp
80103f76:	ff 73 74             	push   0x74(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f79:	83 c3 78             	add    $0x78,%ebx
  np->cwd = idup(curproc->cwd);
80103f7c:	e8 cf d7 ff ff       	call   80101750 <idup>
80103f81:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f84:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103f87:	89 47 74             	mov    %eax,0x74(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f8a:	8d 47 78             	lea    0x78(%edi),%eax
80103f8d:	6a 10                	push   $0x10
80103f8f:	53                   	push   %ebx
80103f90:	50                   	push   %eax
80103f91:	e8 ca 0e 00 00       	call   80104e60 <safestrcpy>
  pid = np->pid;
80103f96:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103f99:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fa0:	e8 3b 0c 00 00       	call   80104be0 <acquire>
  np->state = RUNNABLE;
80103fa5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  acquire(&tickslock);
80103fac:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)
80103fb3:	e8 28 0c 00 00       	call   80104be0 <acquire>
  np->creation_time = ticks;
80103fb8:	a1 60 55 11 80       	mov    0x80115560,%eax
80103fbd:	89 47 20             	mov    %eax,0x20(%edi)
  np->preemption_time = ticks;
80103fc0:	89 47 24             	mov    %eax,0x24(%edi)
  release(&tickslock);
80103fc3:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)
80103fca:	e8 b1 0b 00 00       	call   80104b80 <release>
  release(&ptable.lock);
80103fcf:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fd6:	e8 a5 0b 00 00       	call   80104b80 <release>
  return pid;
80103fdb:	83 c4 10             	add    $0x10,%esp
}
80103fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fe1:	89 d8                	mov    %ebx,%eax
80103fe3:	5b                   	pop    %ebx
80103fe4:	5e                   	pop    %esi
80103fe5:	5f                   	pop    %edi
80103fe6:	5d                   	pop    %ebp
80103fe7:	c3                   	ret    
    return -1;
80103fe8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103fed:	eb ef                	jmp    80103fde <fork+0xfe>
    kfree(np->kstack);
80103fef:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ff2:	83 ec 0c             	sub    $0xc,%esp
80103ff5:	ff 73 08             	push   0x8(%ebx)
80103ff8:	e8 c3 e4 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103ffd:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104004:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104007:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
8010400e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104013:	eb c9                	jmp    80103fde <fork+0xfe>
80104015:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010401c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104020 <round_robin>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	56                   	push   %esi
  struct proc *res = 0;
80104024:	31 f6                	xor    %esi,%esi
{
80104026:	53                   	push   %ebx
  acquire(&tickslock);
80104027:	83 ec 0c             	sub    $0xc,%esp
8010402a:	68 80 55 11 80       	push   $0x80115580
8010402f:	e8 ac 0b 00 00       	call   80104be0 <acquire>
  release(&tickslock);
80104034:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)
  time = ticks;
8010403b:	8b 1d 60 55 11 80    	mov    0x80115560,%ebx
  release(&tickslock);
80104041:	e8 3a 0b 00 00       	call   80104b80 <release>
80104046:	83 c4 10             	add    $0x10,%esp
  int max_diff = MIN_INT;
80104049:	b9 00 00 00 80       	mov    $0x80000000,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010404e:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104053:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104057:	90                   	nop
    if (p->state != RUNNABLE || p->que_id != RR)
80104058:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010405c:	75 1a                	jne    80104078 <round_robin+0x58>
8010405e:	83 78 28 01          	cmpl   $0x1,0x28(%eax)
80104062:	75 14                	jne    80104078 <round_robin+0x58>
    if (time - p->preemption_time > max_diff)
80104064:	89 da                	mov    %ebx,%edx
80104066:	2b 50 24             	sub    0x24(%eax),%edx
80104069:	39 ca                	cmp    %ecx,%edx
8010406b:	76 0b                	jbe    80104078 <round_robin+0x58>
      max_diff = time - p->preemption_time;
8010406d:	89 d1                	mov    %edx,%ecx
8010406f:	89 c6                	mov    %eax,%esi
80104071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104078:	05 a0 00 00 00       	add    $0xa0,%eax
8010407d:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104082:	75 d4                	jne    80104058 <round_robin+0x38>
}
80104084:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104087:	89 f0                	mov    %esi,%eax
80104089:	5b                   	pop    %ebx
8010408a:	5e                   	pop    %esi
8010408b:	5d                   	pop    %ebp
8010408c:	c3                   	ret    
8010408d:	8d 76 00             	lea    0x0(%esi),%esi

80104090 <last_come_first_serve>:
{
80104090:	55                   	push   %ebp
  int latest_time = MIN_INT;
80104091:	b9 00 00 00 80       	mov    $0x80000000,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104096:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
{
8010409b:	89 e5                	mov    %esp,%ebp
8010409d:	53                   	push   %ebx
  struct proc *res = 0;
8010409e:	31 db                	xor    %ebx,%ebx
    if (p->state != RUNNABLE || p->que_id != LCFS)
801040a0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801040a4:	75 1a                	jne    801040c0 <last_come_first_serve+0x30>
801040a6:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
801040aa:	75 14                	jne    801040c0 <last_come_first_serve+0x30>
    if (p->creation_time > latest_time)
801040ac:	8b 50 20             	mov    0x20(%eax),%edx
801040af:	39 ca                	cmp    %ecx,%edx
801040b1:	76 0d                	jbe    801040c0 <last_come_first_serve+0x30>
      latest_time = p->creation_time;
801040b3:	89 d1                	mov    %edx,%ecx
801040b5:	89 c3                	mov    %eax,%ebx
801040b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040be:	66 90                	xchg   %ax,%ax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040c0:	05 a0 00 00 00       	add    $0xa0,%eax
801040c5:	3d 54 55 11 80       	cmp    $0x80115554,%eax
801040ca:	75 d4                	jne    801040a0 <last_come_first_serve+0x10>
}
801040cc:	89 d8                	mov    %ebx,%eax
801040ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040d1:	c9                   	leave  
801040d2:	c3                   	ret    
801040d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040e0 <calculate_rank>:
{
801040e0:	55                   	push   %ebp
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
801040e1:	31 c9                	xor    %ecx,%ecx
{
801040e3:	89 e5                	mov    %esp,%ebp
801040e5:	83 ec 08             	sub    $0x8,%esp
801040e8:	8b 45 08             	mov    0x8(%ebp),%eax
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
801040eb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801040ee:	31 c9                	xor    %ecx,%ecx
801040f0:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
801040f6:	89 55 f8             	mov    %edx,-0x8(%ebp)
801040f9:	8b 50 20             	mov    0x20(%eax),%edx
801040fc:	df 6d f8             	fildll -0x8(%ebp)
801040ff:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
80104105:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80104108:	31 c9                	xor    %ecx,%ecx
8010410a:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010410d:	df 6d f8             	fildll -0x8(%ebp)
80104110:	d8 88 90 00 00 00    	fmuls  0x90(%eax)
80104116:	8b 10                	mov    (%eax),%edx
80104118:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010411b:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010411e:	de c1                	faddp  %st,%st(1)
80104120:	d9 80 94 00 00 00    	flds   0x94(%eax)
80104126:	d8 88 98 00 00 00    	fmuls  0x98(%eax)
8010412c:	de c1                	faddp  %st,%st(1)
8010412e:	df 6d f8             	fildll -0x8(%ebp)
80104131:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
}
80104137:	c9                   	leave  
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80104138:	de c1                	faddp  %st,%st(1)
}
8010413a:	c3                   	ret    
8010413b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010413f:	90                   	nop

80104140 <best_job_first>:
  float min_rank = (float)MAX_INT;
80104140:	d9 05 00 85 10 80    	flds   0x80108500
  struct proc *res = 0;
80104146:	31 d2                	xor    %edx,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104148:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010414d:	8d 76 00             	lea    0x0(%esi),%esi
    if (p->state != RUNNABLE || p->que_id != BJF)
80104150:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104154:	0f 85 ae 00 00 00    	jne    80104208 <best_job_first+0xc8>
8010415a:	83 78 28 03          	cmpl   $0x3,0x28(%eax)
8010415e:	0f 85 a4 00 00 00    	jne    80104208 <best_job_first+0xc8>
{
80104164:	55                   	push   %ebp
80104165:	89 e5                	mov    %esp,%ebp
80104167:	53                   	push   %ebx
80104168:	83 ec 0c             	sub    $0xc,%esp
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
8010416b:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
80104171:	31 db                	xor    %ebx,%ebx
80104173:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80104176:	31 db                	xor    %ebx,%ebx
80104178:	89 4d f0             	mov    %ecx,-0x10(%ebp)
8010417b:	8b 48 20             	mov    0x20(%eax),%ecx
8010417e:	df 6d f0             	fildll -0x10(%ebp)
80104181:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
80104187:	89 5d f4             	mov    %ebx,-0xc(%ebp)
8010418a:	31 db                	xor    %ebx,%ebx
8010418c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
8010418f:	df 6d f0             	fildll -0x10(%ebp)
80104192:	d8 88 90 00 00 00    	fmuls  0x90(%eax)
80104198:	8b 08                	mov    (%eax),%ecx
8010419a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
8010419d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
801041a0:	de c1                	faddp  %st,%st(1)
801041a2:	d9 80 94 00 00 00    	flds   0x94(%eax)
801041a8:	d8 88 98 00 00 00    	fmuls  0x98(%eax)
801041ae:	de c1                	faddp  %st,%st(1)
801041b0:	df 6d f0             	fildll -0x10(%ebp)
801041b3:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
801041b9:	de c1                	faddp  %st,%st(1)
801041bb:	d9 c9                	fxch   %st(1)
    if (rank < min_rank)
801041bd:	db f1                	fcomi  %st(1),%st
801041bf:	76 0f                	jbe    801041d0 <best_job_first+0x90>
801041c1:	dd d8                	fstp   %st(0)
801041c3:	89 c2                	mov    %eax,%edx
801041c5:	eb 0b                	jmp    801041d2 <best_job_first+0x92>
801041c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ce:	66 90                	xchg   %ax,%ax
801041d0:	dd d9                	fstp   %st(1)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041d2:	05 a0 00 00 00       	add    $0xa0,%eax
801041d7:	3d 54 55 11 80       	cmp    $0x80115554,%eax
801041dc:	74 1c                	je     801041fa <best_job_first+0xba>
    if (p->state != RUNNABLE || p->que_id != BJF)
801041de:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801041e2:	75 ee                	jne    801041d2 <best_job_first+0x92>
801041e4:	83 78 28 03          	cmpl   $0x3,0x28(%eax)
801041e8:	74 81                	je     8010416b <best_job_first+0x2b>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041ea:	05 a0 00 00 00       	add    $0xa0,%eax
801041ef:	3d 54 55 11 80       	cmp    $0x80115554,%eax
801041f4:	75 e8                	jne    801041de <best_job_first+0x9e>
801041f6:	dd d8                	fstp   %st(0)
801041f8:	eb 02                	jmp    801041fc <best_job_first+0xbc>
801041fa:	dd d8                	fstp   %st(0)
}
801041fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041ff:	89 d0                	mov    %edx,%eax
80104201:	c9                   	leave  
80104202:	c3                   	ret    
80104203:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104207:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104208:	05 a0 00 00 00       	add    $0xa0,%eax
8010420d:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104212:	0f 85 38 ff ff ff    	jne    80104150 <best_job_first+0x10>
80104218:	dd d8                	fstp   %st(0)
}
8010421a:	89 d0                	mov    %edx,%eax
8010421c:	c3                   	ret    
8010421d:	8d 76 00             	lea    0x0(%esi),%esi

80104220 <scheduler>:
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	57                   	push   %edi
80104224:	56                   	push   %esi
80104225:	53                   	push   %ebx
80104226:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104229:	e8 02 f7 ff ff       	call   80103930 <mycpu>
  c->proc = 0;
8010422e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104235:	00 00 00 
  struct cpu *c = mycpu();
80104238:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010423a:	8d 78 04             	lea    0x4(%eax),%edi
8010423d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104240:	fb                   	sti    
    acquire(&ptable.lock);
80104241:	83 ec 0c             	sub    $0xc,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104244:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80104249:	68 20 2d 11 80       	push   $0x80112d20
8010424e:	e8 8d 09 00 00       	call   80104be0 <acquire>
80104253:	83 c4 10             	add    $0x10,%esp
80104256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010425d:	8d 76 00             	lea    0x0(%esi),%esi
      if (p->state != RUNNABLE)
80104260:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104264:	75 33                	jne    80104299 <scheduler+0x79>
      switchuvm(p);
80104266:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104269:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010426f:	53                   	push   %ebx
80104270:	e8 9b 33 00 00       	call   80107610 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104275:	58                   	pop    %eax
80104276:	5a                   	pop    %edx
80104277:	ff 73 1c             	push   0x1c(%ebx)
8010427a:	57                   	push   %edi
      p->state = RUNNING;
8010427b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104282:	e8 34 0c 00 00       	call   80104ebb <swtch>
      switchkvm();
80104287:	e8 74 33 00 00       	call   80107600 <switchkvm>
      c->proc = 0;
8010428c:	83 c4 10             	add    $0x10,%esp
8010428f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104296:	00 00 00 
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104299:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
8010429f:	81 fb 54 55 11 80    	cmp    $0x80115554,%ebx
801042a5:	75 b9                	jne    80104260 <scheduler+0x40>
    release(&ptable.lock);
801042a7:	83 ec 0c             	sub    $0xc,%esp
801042aa:	68 20 2d 11 80       	push   $0x80112d20
801042af:	e8 cc 08 00 00       	call   80104b80 <release>
    sti();
801042b4:	83 c4 10             	add    $0x10,%esp
801042b7:	eb 87                	jmp    80104240 <scheduler+0x20>
801042b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042c0 <sched>:
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	56                   	push   %esi
801042c4:	53                   	push   %ebx
  pushcli();
801042c5:	e8 c6 07 00 00       	call   80104a90 <pushcli>
  c = mycpu();
801042ca:	e8 61 f6 ff ff       	call   80103930 <mycpu>
  p = c->proc;
801042cf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042d5:	e8 06 08 00 00       	call   80104ae0 <popcli>
  if (!holding(&ptable.lock))
801042da:	83 ec 0c             	sub    $0xc,%esp
801042dd:	68 20 2d 11 80       	push   $0x80112d20
801042e2:	e8 59 08 00 00       	call   80104b40 <holding>
801042e7:	83 c4 10             	add    $0x10,%esp
801042ea:	85 c0                	test   %eax,%eax
801042ec:	74 4f                	je     8010433d <sched+0x7d>
  if (mycpu()->ncli != 1)
801042ee:	e8 3d f6 ff ff       	call   80103930 <mycpu>
801042f3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801042fa:	75 68                	jne    80104364 <sched+0xa4>
  if (p->state == RUNNING)
801042fc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104300:	74 55                	je     80104357 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104302:	9c                   	pushf  
80104303:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80104304:	f6 c4 02             	test   $0x2,%ah
80104307:	75 41                	jne    8010434a <sched+0x8a>
  intena = mycpu()->intena;
80104309:	e8 22 f6 ff ff       	call   80103930 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010430e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104311:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104317:	e8 14 f6 ff ff       	call   80103930 <mycpu>
8010431c:	83 ec 08             	sub    $0x8,%esp
8010431f:	ff 70 04             	push   0x4(%eax)
80104322:	53                   	push   %ebx
80104323:	e8 93 0b 00 00       	call   80104ebb <swtch>
  mycpu()->intena = intena;
80104328:	e8 03 f6 ff ff       	call   80103930 <mycpu>
}
8010432d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104330:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104336:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104339:	5b                   	pop    %ebx
8010433a:	5e                   	pop    %esi
8010433b:	5d                   	pop    %ebp
8010433c:	c3                   	ret    
    panic("sched ptable.lock");
8010433d:	83 ec 0c             	sub    $0xc,%esp
80104340:	68 8e 83 10 80       	push   $0x8010838e
80104345:	e8 36 c0 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010434a:	83 ec 0c             	sub    $0xc,%esp
8010434d:	68 ba 83 10 80       	push   $0x801083ba
80104352:	e8 29 c0 ff ff       	call   80100380 <panic>
    panic("sched running");
80104357:	83 ec 0c             	sub    $0xc,%esp
8010435a:	68 ac 83 10 80       	push   $0x801083ac
8010435f:	e8 1c c0 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104364:	83 ec 0c             	sub    $0xc,%esp
80104367:	68 a0 83 10 80       	push   $0x801083a0
8010436c:	e8 0f c0 ff ff       	call   80100380 <panic>
80104371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010437f:	90                   	nop

80104380 <exit>:
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	57                   	push   %edi
80104384:	56                   	push   %esi
80104385:	53                   	push   %ebx
80104386:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104389:	e8 a2 f6 ff ff       	call   80103a30 <myproc>
  if (curproc == initproc)
8010438e:	39 05 54 55 11 80    	cmp    %eax,0x80115554
80104394:	0f 84 07 01 00 00    	je     801044a1 <exit+0x121>
8010439a:	89 c3                	mov    %eax,%ebx
8010439c:	8d 70 34             	lea    0x34(%eax),%esi
8010439f:	8d 78 74             	lea    0x74(%eax),%edi
801043a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd])
801043a8:	8b 06                	mov    (%esi),%eax
801043aa:	85 c0                	test   %eax,%eax
801043ac:	74 12                	je     801043c0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801043ae:	83 ec 0c             	sub    $0xc,%esp
801043b1:	50                   	push   %eax
801043b2:	e8 39 cb ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
801043b7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801043bd:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
801043c0:	83 c6 04             	add    $0x4,%esi
801043c3:	39 f7                	cmp    %esi,%edi
801043c5:	75 e1                	jne    801043a8 <exit+0x28>
  begin_op();
801043c7:	e8 94 e9 ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
801043cc:	83 ec 0c             	sub    $0xc,%esp
801043cf:	ff 73 74             	push   0x74(%ebx)
801043d2:	e8 d9 d4 ff ff       	call   801018b0 <iput>
  end_op();
801043d7:	e8 f4 e9 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
801043dc:	c7 43 74 00 00 00 00 	movl   $0x0,0x74(%ebx)
  acquire(&ptable.lock);
801043e3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801043ea:	e8 f1 07 00 00       	call   80104be0 <acquire>
  wakeup1(curproc->parent);
801043ef:	8b 53 14             	mov    0x14(%ebx),%edx
801043f2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043f5:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801043fa:	eb 10                	jmp    8010440c <exit+0x8c>
801043fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104400:	05 a0 00 00 00       	add    $0xa0,%eax
80104405:	3d 54 55 11 80       	cmp    $0x80115554,%eax
8010440a:	74 1e                	je     8010442a <exit+0xaa>
    if (p->state == SLEEPING && p->chan == chan)
8010440c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104410:	75 ee                	jne    80104400 <exit+0x80>
80104412:	3b 50 2c             	cmp    0x2c(%eax),%edx
80104415:	75 e9                	jne    80104400 <exit+0x80>
      p->state = RUNNABLE;
80104417:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010441e:	05 a0 00 00 00       	add    $0xa0,%eax
80104423:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104428:	75 e2                	jne    8010440c <exit+0x8c>
      p->parent = initproc;
8010442a:	8b 0d 54 55 11 80    	mov    0x80115554,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104430:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80104435:	eb 17                	jmp    8010444e <exit+0xce>
80104437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010443e:	66 90                	xchg   %ax,%ax
80104440:	81 c2 a0 00 00 00    	add    $0xa0,%edx
80104446:	81 fa 54 55 11 80    	cmp    $0x80115554,%edx
8010444c:	74 3a                	je     80104488 <exit+0x108>
    if (p->parent == curproc)
8010444e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104451:	75 ed                	jne    80104440 <exit+0xc0>
      if (p->state == ZOMBIE)
80104453:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104457:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
8010445a:	75 e4                	jne    80104440 <exit+0xc0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010445c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104461:	eb 11                	jmp    80104474 <exit+0xf4>
80104463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104467:	90                   	nop
80104468:	05 a0 00 00 00       	add    $0xa0,%eax
8010446d:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104472:	74 cc                	je     80104440 <exit+0xc0>
    if (p->state == SLEEPING && p->chan == chan)
80104474:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104478:	75 ee                	jne    80104468 <exit+0xe8>
8010447a:	3b 48 2c             	cmp    0x2c(%eax),%ecx
8010447d:	75 e9                	jne    80104468 <exit+0xe8>
      p->state = RUNNABLE;
8010447f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104486:	eb e0                	jmp    80104468 <exit+0xe8>
  curproc->state = ZOMBIE;
80104488:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010448f:	e8 2c fe ff ff       	call   801042c0 <sched>
  panic("zombie exit");
80104494:	83 ec 0c             	sub    $0xc,%esp
80104497:	68 db 83 10 80       	push   $0x801083db
8010449c:	e8 df be ff ff       	call   80100380 <panic>
    panic("init exiting");
801044a1:	83 ec 0c             	sub    $0xc,%esp
801044a4:	68 ce 83 10 80       	push   $0x801083ce
801044a9:	e8 d2 be ff ff       	call   80100380 <panic>
801044ae:	66 90                	xchg   %ax,%ax

801044b0 <wait>:
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	56                   	push   %esi
801044b4:	53                   	push   %ebx
  pushcli();
801044b5:	e8 d6 05 00 00       	call   80104a90 <pushcli>
  c = mycpu();
801044ba:	e8 71 f4 ff ff       	call   80103930 <mycpu>
  p = c->proc;
801044bf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801044c5:	e8 16 06 00 00       	call   80104ae0 <popcli>
  acquire(&ptable.lock);
801044ca:	83 ec 0c             	sub    $0xc,%esp
801044cd:	68 20 2d 11 80       	push   $0x80112d20
801044d2:	e8 09 07 00 00       	call   80104be0 <acquire>
801044d7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801044da:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044dc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801044e1:	eb 13                	jmp    801044f6 <wait+0x46>
801044e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e7:	90                   	nop
801044e8:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
801044ee:	81 fb 54 55 11 80    	cmp    $0x80115554,%ebx
801044f4:	74 1e                	je     80104514 <wait+0x64>
      if (p->parent != curproc)
801044f6:	39 73 14             	cmp    %esi,0x14(%ebx)
801044f9:	75 ed                	jne    801044e8 <wait+0x38>
      if (p->state == ZOMBIE)
801044fb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801044ff:	74 5f                	je     80104560 <wait+0xb0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104501:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
      havekids = 1;
80104507:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010450c:	81 fb 54 55 11 80    	cmp    $0x80115554,%ebx
80104512:	75 e2                	jne    801044f6 <wait+0x46>
    if (!havekids || curproc->killed)
80104514:	85 c0                	test   %eax,%eax
80104516:	0f 84 9a 00 00 00    	je     801045b6 <wait+0x106>
8010451c:	8b 46 30             	mov    0x30(%esi),%eax
8010451f:	85 c0                	test   %eax,%eax
80104521:	0f 85 8f 00 00 00    	jne    801045b6 <wait+0x106>
  pushcli();
80104527:	e8 64 05 00 00       	call   80104a90 <pushcli>
  c = mycpu();
8010452c:	e8 ff f3 ff ff       	call   80103930 <mycpu>
  p = c->proc;
80104531:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104537:	e8 a4 05 00 00       	call   80104ae0 <popcli>
  if (p == 0)
8010453c:	85 db                	test   %ebx,%ebx
8010453e:	0f 84 89 00 00 00    	je     801045cd <wait+0x11d>
  p->chan = chan;
80104544:	89 73 2c             	mov    %esi,0x2c(%ebx)
  p->state = SLEEPING;
80104547:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010454e:	e8 6d fd ff ff       	call   801042c0 <sched>
  p->chan = 0;
80104553:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
}
8010455a:	e9 7b ff ff ff       	jmp    801044da <wait+0x2a>
8010455f:	90                   	nop
        kfree(p->kstack);
80104560:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104563:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104566:	ff 73 08             	push   0x8(%ebx)
80104569:	e8 52 df ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010456e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104575:	5a                   	pop    %edx
80104576:	ff 73 04             	push   0x4(%ebx)
80104579:	e8 72 34 00 00       	call   801079f0 <freevm>
        p->pid = 0;
8010457e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104585:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010458c:	c6 43 78 00          	movb   $0x0,0x78(%ebx)
        p->killed = 0;
80104590:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
        p->state = UNUSED;
80104597:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010459e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801045a5:	e8 d6 05 00 00       	call   80104b80 <release>
        return pid;
801045aa:	83 c4 10             	add    $0x10,%esp
}
801045ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045b0:	89 f0                	mov    %esi,%eax
801045b2:	5b                   	pop    %ebx
801045b3:	5e                   	pop    %esi
801045b4:	5d                   	pop    %ebp
801045b5:	c3                   	ret    
      release(&ptable.lock);
801045b6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801045b9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801045be:	68 20 2d 11 80       	push   $0x80112d20
801045c3:	e8 b8 05 00 00       	call   80104b80 <release>
      return -1;
801045c8:	83 c4 10             	add    $0x10,%esp
801045cb:	eb e0                	jmp    801045ad <wait+0xfd>
    panic("sleep");
801045cd:	83 ec 0c             	sub    $0xc,%esp
801045d0:	68 e7 83 10 80       	push   $0x801083e7
801045d5:	e8 a6 bd ff ff       	call   80100380 <panic>
801045da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045e0 <yield>:
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	53                   	push   %ebx
801045e4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); // DOC: yieldlock
801045e7:	68 20 2d 11 80       	push   $0x80112d20
801045ec:	e8 ef 05 00 00       	call   80104be0 <acquire>
  pushcli();
801045f1:	e8 9a 04 00 00       	call   80104a90 <pushcli>
  c = mycpu();
801045f6:	e8 35 f3 ff ff       	call   80103930 <mycpu>
  p = c->proc;
801045fb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104601:	e8 da 04 00 00       	call   80104ae0 <popcli>
  myproc()->state = RUNNABLE;
80104606:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010460d:	e8 ae fc ff ff       	call   801042c0 <sched>
  release(&ptable.lock);
80104612:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104619:	e8 62 05 00 00       	call   80104b80 <release>
}
8010461e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104621:	83 c4 10             	add    $0x10,%esp
80104624:	c9                   	leave  
80104625:	c3                   	ret    
80104626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010462d:	8d 76 00             	lea    0x0(%esi),%esi

80104630 <sleep>:
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	57                   	push   %edi
80104634:	56                   	push   %esi
80104635:	53                   	push   %ebx
80104636:	83 ec 0c             	sub    $0xc,%esp
80104639:	8b 7d 08             	mov    0x8(%ebp),%edi
8010463c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010463f:	e8 4c 04 00 00       	call   80104a90 <pushcli>
  c = mycpu();
80104644:	e8 e7 f2 ff ff       	call   80103930 <mycpu>
  p = c->proc;
80104649:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010464f:	e8 8c 04 00 00       	call   80104ae0 <popcli>
  if (p == 0)
80104654:	85 db                	test   %ebx,%ebx
80104656:	0f 84 87 00 00 00    	je     801046e3 <sleep+0xb3>
  if (lk == 0)
8010465c:	85 f6                	test   %esi,%esi
8010465e:	74 76                	je     801046d6 <sleep+0xa6>
  if (lk != &ptable.lock)
80104660:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104666:	74 50                	je     801046b8 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
80104668:	83 ec 0c             	sub    $0xc,%esp
8010466b:	68 20 2d 11 80       	push   $0x80112d20
80104670:	e8 6b 05 00 00       	call   80104be0 <acquire>
    release(lk);
80104675:	89 34 24             	mov    %esi,(%esp)
80104678:	e8 03 05 00 00       	call   80104b80 <release>
  p->chan = chan;
8010467d:	89 7b 2c             	mov    %edi,0x2c(%ebx)
  p->state = SLEEPING;
80104680:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104687:	e8 34 fc ff ff       	call   801042c0 <sched>
  p->chan = 0;
8010468c:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
    release(&ptable.lock);
80104693:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010469a:	e8 e1 04 00 00       	call   80104b80 <release>
    acquire(lk);
8010469f:	89 75 08             	mov    %esi,0x8(%ebp)
801046a2:	83 c4 10             	add    $0x10,%esp
}
801046a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046a8:	5b                   	pop    %ebx
801046a9:	5e                   	pop    %esi
801046aa:	5f                   	pop    %edi
801046ab:	5d                   	pop    %ebp
    acquire(lk);
801046ac:	e9 2f 05 00 00       	jmp    80104be0 <acquire>
801046b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801046b8:	89 7b 2c             	mov    %edi,0x2c(%ebx)
  p->state = SLEEPING;
801046bb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801046c2:	e8 f9 fb ff ff       	call   801042c0 <sched>
  p->chan = 0;
801046c7:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
}
801046ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046d1:	5b                   	pop    %ebx
801046d2:	5e                   	pop    %esi
801046d3:	5f                   	pop    %edi
801046d4:	5d                   	pop    %ebp
801046d5:	c3                   	ret    
    panic("sleep without lk");
801046d6:	83 ec 0c             	sub    $0xc,%esp
801046d9:	68 ed 83 10 80       	push   $0x801083ed
801046de:	e8 9d bc ff ff       	call   80100380 <panic>
    panic("sleep");
801046e3:	83 ec 0c             	sub    $0xc,%esp
801046e6:	68 e7 83 10 80       	push   $0x801083e7
801046eb:	e8 90 bc ff ff       	call   80100380 <panic>

801046f0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	83 ec 10             	sub    $0x10,%esp
801046f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801046fa:	68 20 2d 11 80       	push   $0x80112d20
801046ff:	e8 dc 04 00 00       	call   80104be0 <acquire>
80104704:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104707:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010470c:	eb 0e                	jmp    8010471c <wakeup+0x2c>
8010470e:	66 90                	xchg   %ax,%ax
80104710:	05 a0 00 00 00       	add    $0xa0,%eax
80104715:	3d 54 55 11 80       	cmp    $0x80115554,%eax
8010471a:	74 1e                	je     8010473a <wakeup+0x4a>
    if (p->state == SLEEPING && p->chan == chan)
8010471c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104720:	75 ee                	jne    80104710 <wakeup+0x20>
80104722:	3b 58 2c             	cmp    0x2c(%eax),%ebx
80104725:	75 e9                	jne    80104710 <wakeup+0x20>
      p->state = RUNNABLE;
80104727:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010472e:	05 a0 00 00 00       	add    $0xa0,%eax
80104733:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104738:	75 e2                	jne    8010471c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010473a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104741:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104744:	c9                   	leave  
  release(&ptable.lock);
80104745:	e9 36 04 00 00       	jmp    80104b80 <release>
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104750 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
80104754:	83 ec 10             	sub    $0x10,%esp
80104757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010475a:	68 20 2d 11 80       	push   $0x80112d20
8010475f:	e8 7c 04 00 00       	call   80104be0 <acquire>
80104764:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104767:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010476c:	eb 0e                	jmp    8010477c <kill+0x2c>
8010476e:	66 90                	xchg   %ax,%ax
80104770:	05 a0 00 00 00       	add    $0xa0,%eax
80104775:	3d 54 55 11 80       	cmp    $0x80115554,%eax
8010477a:	74 34                	je     801047b0 <kill+0x60>
  {
    if (p->pid == pid)
8010477c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010477f:	75 ef                	jne    80104770 <kill+0x20>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
80104781:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104785:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
      if (p->state == SLEEPING)
8010478c:	75 07                	jne    80104795 <kill+0x45>
        p->state = RUNNABLE;
8010478e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104795:	83 ec 0c             	sub    $0xc,%esp
80104798:	68 20 2d 11 80       	push   $0x80112d20
8010479d:	e8 de 03 00 00       	call   80104b80 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801047a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801047a5:	83 c4 10             	add    $0x10,%esp
801047a8:	31 c0                	xor    %eax,%eax
}
801047aa:	c9                   	leave  
801047ab:	c3                   	ret    
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801047b0:	83 ec 0c             	sub    $0xc,%esp
801047b3:	68 20 2d 11 80       	push   $0x80112d20
801047b8:	e8 c3 03 00 00       	call   80104b80 <release>
}
801047bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801047c0:	83 c4 10             	add    $0x10,%esp
801047c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801047c8:	c9                   	leave  
801047c9:	c3                   	ret    
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047d0 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	57                   	push   %edi
801047d4:	56                   	push   %esi
801047d5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801047d8:	53                   	push   %ebx
801047d9:	bb cc 2d 11 80       	mov    $0x80112dcc,%ebx
801047de:	83 ec 3c             	sub    $0x3c,%esp
801047e1:	eb 27                	jmp    8010480a <procdump+0x3a>
801047e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047e7:	90                   	nop
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801047e8:	83 ec 0c             	sub    $0xc,%esp
801047eb:	68 4f 88 10 80       	push   $0x8010884f
801047f0:	e8 ab be ff ff       	call   801006a0 <cprintf>
801047f5:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047f8:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
801047fe:	81 fb cc 55 11 80    	cmp    $0x801155cc,%ebx
80104804:	0f 84 7e 00 00 00    	je     80104888 <procdump+0xb8>
    if (p->state == UNUSED)
8010480a:	8b 43 94             	mov    -0x6c(%ebx),%eax
8010480d:	85 c0                	test   %eax,%eax
8010480f:	74 e7                	je     801047f8 <procdump+0x28>
      state = "???";
80104811:	ba fe 83 10 80       	mov    $0x801083fe,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104816:	83 f8 05             	cmp    $0x5,%eax
80104819:	77 11                	ja     8010482c <procdump+0x5c>
8010481b:	8b 14 85 e8 84 10 80 	mov    -0x7fef7b18(,%eax,4),%edx
      state = "???";
80104822:	b8 fe 83 10 80       	mov    $0x801083fe,%eax
80104827:	85 d2                	test   %edx,%edx
80104829:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010482c:	53                   	push   %ebx
8010482d:	52                   	push   %edx
8010482e:	ff 73 98             	push   -0x68(%ebx)
80104831:	68 02 84 10 80       	push   $0x80108402
80104836:	e8 65 be ff ff       	call   801006a0 <cprintf>
    if (p->state == SLEEPING)
8010483b:	83 c4 10             	add    $0x10,%esp
8010483e:	83 7b 94 02          	cmpl   $0x2,-0x6c(%ebx)
80104842:	75 a4                	jne    801047e8 <procdump+0x18>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80104844:	83 ec 08             	sub    $0x8,%esp
80104847:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010484a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010484d:	50                   	push   %eax
8010484e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80104851:	8b 40 0c             	mov    0xc(%eax),%eax
80104854:	83 c0 08             	add    $0x8,%eax
80104857:	50                   	push   %eax
80104858:	e8 d3 01 00 00       	call   80104a30 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
8010485d:	83 c4 10             	add    $0x10,%esp
80104860:	8b 17                	mov    (%edi),%edx
80104862:	85 d2                	test   %edx,%edx
80104864:	74 82                	je     801047e8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104866:	83 ec 08             	sub    $0x8,%esp
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104869:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010486c:	52                   	push   %edx
8010486d:	68 01 7e 10 80       	push   $0x80107e01
80104872:	e8 29 be ff ff       	call   801006a0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104877:	83 c4 10             	add    $0x10,%esp
8010487a:	39 fe                	cmp    %edi,%esi
8010487c:	75 e2                	jne    80104860 <procdump+0x90>
8010487e:	e9 65 ff ff ff       	jmp    801047e8 <procdump+0x18>
80104883:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104887:	90                   	nop
  }
}
80104888:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010488b:	5b                   	pop    %ebx
8010488c:	5e                   	pop    %esi
8010488d:	5f                   	pop    %edi
8010488e:	5d                   	pop    %ebp
8010488f:	c3                   	ret    

80104890 <find_digital_root>:

int find_digital_root(int num)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
80104895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while (num >= 10)
80104898:	83 fb 09             	cmp    $0x9,%ebx
8010489b:	7e 2e                	jle    801048cb <find_digital_root+0x3b>
  {
    int temp = num;
    int res = 0;
    while (temp != 0)
    {
      int current_dig = temp % 10;
8010489d:	be cd cc cc cc       	mov    $0xcccccccd,%esi
801048a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801048a8:	89 d9                	mov    %ebx,%ecx
    int res = 0;
801048aa:	31 db                	xor    %ebx,%ebx
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      int current_dig = temp % 10;
801048b0:	89 c8                	mov    %ecx,%eax
801048b2:	f7 e6                	mul    %esi
801048b4:	c1 ea 03             	shr    $0x3,%edx
801048b7:	8d 04 92             	lea    (%edx,%edx,4),%eax
801048ba:	01 c0                	add    %eax,%eax
801048bc:	29 c1                	sub    %eax,%ecx
      res += current_dig;
801048be:	01 cb                	add    %ecx,%ebx
      temp /= 10;
801048c0:	89 d1                	mov    %edx,%ecx
    while (temp != 0)
801048c2:	85 d2                	test   %edx,%edx
801048c4:	75 ea                	jne    801048b0 <find_digital_root+0x20>
  while (num >= 10)
801048c6:	83 fb 09             	cmp    $0x9,%ebx
801048c9:	7f dd                	jg     801048a8 <find_digital_root+0x18>
    }
    num = res;
  }
  return num;
801048cb:	89 d8                	mov    %ebx,%eax
801048cd:	5b                   	pop    %ebx
801048ce:	5e                   	pop    %esi
801048cf:	5d                   	pop    %ebp
801048d0:	c3                   	ret    
801048d1:	66 90                	xchg   %ax,%ax
801048d3:	66 90                	xchg   %ax,%ax
801048d5:	66 90                	xchg   %ax,%ax
801048d7:	66 90                	xchg   %ax,%ax
801048d9:	66 90                	xchg   %ax,%ax
801048db:	66 90                	xchg   %ax,%ax
801048dd:	66 90                	xchg   %ax,%ax
801048df:	90                   	nop

801048e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	53                   	push   %ebx
801048e4:	83 ec 0c             	sub    $0xc,%esp
801048e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801048ea:	68 04 85 10 80       	push   $0x80108504
801048ef:	8d 43 04             	lea    0x4(%ebx),%eax
801048f2:	50                   	push   %eax
801048f3:	e8 18 01 00 00       	call   80104a10 <initlock>
  lk->name = name;
801048f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801048fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104901:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104904:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010490b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010490e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104911:	c9                   	leave  
80104912:	c3                   	ret    
80104913:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010491a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104920 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	56                   	push   %esi
80104924:	53                   	push   %ebx
80104925:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104928:	8d 73 04             	lea    0x4(%ebx),%esi
8010492b:	83 ec 0c             	sub    $0xc,%esp
8010492e:	56                   	push   %esi
8010492f:	e8 ac 02 00 00       	call   80104be0 <acquire>
  while (lk->locked) {
80104934:	8b 13                	mov    (%ebx),%edx
80104936:	83 c4 10             	add    $0x10,%esp
80104939:	85 d2                	test   %edx,%edx
8010493b:	74 16                	je     80104953 <acquiresleep+0x33>
8010493d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104940:	83 ec 08             	sub    $0x8,%esp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	e8 e6 fc ff ff       	call   80104630 <sleep>
  while (lk->locked) {
8010494a:	8b 03                	mov    (%ebx),%eax
8010494c:	83 c4 10             	add    $0x10,%esp
8010494f:	85 c0                	test   %eax,%eax
80104951:	75 ed                	jne    80104940 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104953:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104959:	e8 d2 f0 ff ff       	call   80103a30 <myproc>
8010495e:	8b 40 10             	mov    0x10(%eax),%eax
80104961:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104964:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104967:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010496a:	5b                   	pop    %ebx
8010496b:	5e                   	pop    %esi
8010496c:	5d                   	pop    %ebp
  release(&lk->lk);
8010496d:	e9 0e 02 00 00       	jmp    80104b80 <release>
80104972:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104980 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
80104985:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104988:	8d 73 04             	lea    0x4(%ebx),%esi
8010498b:	83 ec 0c             	sub    $0xc,%esp
8010498e:	56                   	push   %esi
8010498f:	e8 4c 02 00 00       	call   80104be0 <acquire>
  lk->locked = 0;
80104994:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010499a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801049a1:	89 1c 24             	mov    %ebx,(%esp)
801049a4:	e8 47 fd ff ff       	call   801046f0 <wakeup>
  release(&lk->lk);
801049a9:	89 75 08             	mov    %esi,0x8(%ebp)
801049ac:	83 c4 10             	add    $0x10,%esp
}
801049af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049b2:	5b                   	pop    %ebx
801049b3:	5e                   	pop    %esi
801049b4:	5d                   	pop    %ebp
  release(&lk->lk);
801049b5:	e9 c6 01 00 00       	jmp    80104b80 <release>
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	57                   	push   %edi
801049c4:	31 ff                	xor    %edi,%edi
801049c6:	56                   	push   %esi
801049c7:	53                   	push   %ebx
801049c8:	83 ec 18             	sub    $0x18,%esp
801049cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801049ce:	8d 73 04             	lea    0x4(%ebx),%esi
801049d1:	56                   	push   %esi
801049d2:	e8 09 02 00 00       	call   80104be0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801049d7:	8b 03                	mov    (%ebx),%eax
801049d9:	83 c4 10             	add    $0x10,%esp
801049dc:	85 c0                	test   %eax,%eax
801049de:	75 18                	jne    801049f8 <holdingsleep+0x38>
  release(&lk->lk);
801049e0:	83 ec 0c             	sub    $0xc,%esp
801049e3:	56                   	push   %esi
801049e4:	e8 97 01 00 00       	call   80104b80 <release>
  return r;
}
801049e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049ec:	89 f8                	mov    %edi,%eax
801049ee:	5b                   	pop    %ebx
801049ef:	5e                   	pop    %esi
801049f0:	5f                   	pop    %edi
801049f1:	5d                   	pop    %ebp
801049f2:	c3                   	ret    
801049f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049f7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801049f8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801049fb:	e8 30 f0 ff ff       	call   80103a30 <myproc>
80104a00:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a03:	0f 94 c0             	sete   %al
80104a06:	0f b6 c0             	movzbl %al,%eax
80104a09:	89 c7                	mov    %eax,%edi
80104a0b:	eb d3                	jmp    801049e0 <holdingsleep+0x20>
80104a0d:	66 90                	xchg   %ax,%ax
80104a0f:	90                   	nop

80104a10 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a16:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a1f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a29:	5d                   	pop    %ebp
80104a2a:	c3                   	ret    
80104a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a2f:	90                   	nop

80104a30 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a30:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a31:	31 d2                	xor    %edx,%edx
{
80104a33:	89 e5                	mov    %esp,%ebp
80104a35:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104a36:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104a39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104a3c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104a3f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a40:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a46:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a4c:	77 1a                	ja     80104a68 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a4e:	8b 58 04             	mov    0x4(%eax),%ebx
80104a51:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a54:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a57:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a59:	83 fa 0a             	cmp    $0xa,%edx
80104a5c:	75 e2                	jne    80104a40 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104a5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a61:	c9                   	leave  
80104a62:	c3                   	ret    
80104a63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a67:	90                   	nop
  for(; i < 10; i++)
80104a68:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104a6b:	8d 51 28             	lea    0x28(%ecx),%edx
80104a6e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104a70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104a76:	83 c0 04             	add    $0x4,%eax
80104a79:	39 d0                	cmp    %edx,%eax
80104a7b:	75 f3                	jne    80104a70 <getcallerpcs+0x40>
}
80104a7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a80:	c9                   	leave  
80104a81:	c3                   	ret    
80104a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a90 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 04             	sub    $0x4,%esp
80104a97:	9c                   	pushf  
80104a98:	5b                   	pop    %ebx
  asm volatile("cli");
80104a99:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104a9a:	e8 91 ee ff ff       	call   80103930 <mycpu>
80104a9f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104aa5:	85 c0                	test   %eax,%eax
80104aa7:	74 17                	je     80104ac0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104aa9:	e8 82 ee ff ff       	call   80103930 <mycpu>
80104aae:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ab5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab8:	c9                   	leave  
80104ab9:	c3                   	ret    
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104ac0:	e8 6b ee ff ff       	call   80103930 <mycpu>
80104ac5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104acb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104ad1:	eb d6                	jmp    80104aa9 <pushcli+0x19>
80104ad3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ae0 <popcli>:

void
popcli(void)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ae6:	9c                   	pushf  
80104ae7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104ae8:	f6 c4 02             	test   $0x2,%ah
80104aeb:	75 35                	jne    80104b22 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104aed:	e8 3e ee ff ff       	call   80103930 <mycpu>
80104af2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104af9:	78 34                	js     80104b2f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104afb:	e8 30 ee ff ff       	call   80103930 <mycpu>
80104b00:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b06:	85 d2                	test   %edx,%edx
80104b08:	74 06                	je     80104b10 <popcli+0x30>
    sti();
}
80104b0a:	c9                   	leave  
80104b0b:	c3                   	ret    
80104b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b10:	e8 1b ee ff ff       	call   80103930 <mycpu>
80104b15:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b1b:	85 c0                	test   %eax,%eax
80104b1d:	74 eb                	je     80104b0a <popcli+0x2a>
  asm volatile("sti");
80104b1f:	fb                   	sti    
}
80104b20:	c9                   	leave  
80104b21:	c3                   	ret    
    panic("popcli - interruptible");
80104b22:	83 ec 0c             	sub    $0xc,%esp
80104b25:	68 0f 85 10 80       	push   $0x8010850f
80104b2a:	e8 51 b8 ff ff       	call   80100380 <panic>
    panic("popcli");
80104b2f:	83 ec 0c             	sub    $0xc,%esp
80104b32:	68 26 85 10 80       	push   $0x80108526
80104b37:	e8 44 b8 ff ff       	call   80100380 <panic>
80104b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b40 <holding>:
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	56                   	push   %esi
80104b44:	53                   	push   %ebx
80104b45:	8b 75 08             	mov    0x8(%ebp),%esi
80104b48:	31 db                	xor    %ebx,%ebx
  pushcli();
80104b4a:	e8 41 ff ff ff       	call   80104a90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104b4f:	8b 06                	mov    (%esi),%eax
80104b51:	85 c0                	test   %eax,%eax
80104b53:	75 0b                	jne    80104b60 <holding+0x20>
  popcli();
80104b55:	e8 86 ff ff ff       	call   80104ae0 <popcli>
}
80104b5a:	89 d8                	mov    %ebx,%eax
80104b5c:	5b                   	pop    %ebx
80104b5d:	5e                   	pop    %esi
80104b5e:	5d                   	pop    %ebp
80104b5f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104b60:	8b 5e 08             	mov    0x8(%esi),%ebx
80104b63:	e8 c8 ed ff ff       	call   80103930 <mycpu>
80104b68:	39 c3                	cmp    %eax,%ebx
80104b6a:	0f 94 c3             	sete   %bl
  popcli();
80104b6d:	e8 6e ff ff ff       	call   80104ae0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104b72:	0f b6 db             	movzbl %bl,%ebx
}
80104b75:	89 d8                	mov    %ebx,%eax
80104b77:	5b                   	pop    %ebx
80104b78:	5e                   	pop    %esi
80104b79:	5d                   	pop    %ebp
80104b7a:	c3                   	ret    
80104b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b7f:	90                   	nop

80104b80 <release>:
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
80104b85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104b88:	e8 03 ff ff ff       	call   80104a90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104b8d:	8b 03                	mov    (%ebx),%eax
80104b8f:	85 c0                	test   %eax,%eax
80104b91:	75 15                	jne    80104ba8 <release+0x28>
  popcli();
80104b93:	e8 48 ff ff ff       	call   80104ae0 <popcli>
    panic("release");
80104b98:	83 ec 0c             	sub    $0xc,%esp
80104b9b:	68 2d 85 10 80       	push   $0x8010852d
80104ba0:	e8 db b7 ff ff       	call   80100380 <panic>
80104ba5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ba8:	8b 73 08             	mov    0x8(%ebx),%esi
80104bab:	e8 80 ed ff ff       	call   80103930 <mycpu>
80104bb0:	39 c6                	cmp    %eax,%esi
80104bb2:	75 df                	jne    80104b93 <release+0x13>
  popcli();
80104bb4:	e8 27 ff ff ff       	call   80104ae0 <popcli>
  lk->pcs[0] = 0;
80104bb9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104bc0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104bc7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104bcc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104bd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bd5:	5b                   	pop    %ebx
80104bd6:	5e                   	pop    %esi
80104bd7:	5d                   	pop    %ebp
  popcli();
80104bd8:	e9 03 ff ff ff       	jmp    80104ae0 <popcli>
80104bdd:	8d 76 00             	lea    0x0(%esi),%esi

80104be0 <acquire>:
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	53                   	push   %ebx
80104be4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104be7:	e8 a4 fe ff ff       	call   80104a90 <pushcli>
  if(holding(lk))
80104bec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104bef:	e8 9c fe ff ff       	call   80104a90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104bf4:	8b 03                	mov    (%ebx),%eax
80104bf6:	85 c0                	test   %eax,%eax
80104bf8:	75 7e                	jne    80104c78 <acquire+0x98>
  popcli();
80104bfa:	e8 e1 fe ff ff       	call   80104ae0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104bff:	b9 01 00 00 00       	mov    $0x1,%ecx
80104c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104c08:	8b 55 08             	mov    0x8(%ebp),%edx
80104c0b:	89 c8                	mov    %ecx,%eax
80104c0d:	f0 87 02             	lock xchg %eax,(%edx)
80104c10:	85 c0                	test   %eax,%eax
80104c12:	75 f4                	jne    80104c08 <acquire+0x28>
  __sync_synchronize();
80104c14:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104c19:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c1c:	e8 0f ed ff ff       	call   80103930 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104c21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c24:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104c26:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104c29:	31 c0                	xor    %eax,%eax
80104c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c2f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c30:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104c36:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c3c:	77 1a                	ja     80104c58 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104c3e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104c41:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104c45:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104c48:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104c4a:	83 f8 0a             	cmp    $0xa,%eax
80104c4d:	75 e1                	jne    80104c30 <acquire+0x50>
}
80104c4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c52:	c9                   	leave  
80104c53:	c3                   	ret    
80104c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104c58:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104c5c:	8d 51 34             	lea    0x34(%ecx),%edx
80104c5f:	90                   	nop
    pcs[i] = 0;
80104c60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c66:	83 c0 04             	add    $0x4,%eax
80104c69:	39 c2                	cmp    %eax,%edx
80104c6b:	75 f3                	jne    80104c60 <acquire+0x80>
}
80104c6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c70:	c9                   	leave  
80104c71:	c3                   	ret    
80104c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104c78:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104c7b:	e8 b0 ec ff ff       	call   80103930 <mycpu>
80104c80:	39 c3                	cmp    %eax,%ebx
80104c82:	0f 85 72 ff ff ff    	jne    80104bfa <acquire+0x1a>
  popcli();
80104c88:	e8 53 fe ff ff       	call   80104ae0 <popcli>
    panic("acquire");
80104c8d:	83 ec 0c             	sub    $0xc,%esp
80104c90:	68 35 85 10 80       	push   $0x80108535
80104c95:	e8 e6 b6 ff ff       	call   80100380 <panic>
80104c9a:	66 90                	xchg   %ax,%ax
80104c9c:	66 90                	xchg   %ax,%ax
80104c9e:	66 90                	xchg   %ax,%ax

80104ca0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	57                   	push   %edi
80104ca4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ca7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104caa:	53                   	push   %ebx
80104cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104cae:	89 d7                	mov    %edx,%edi
80104cb0:	09 cf                	or     %ecx,%edi
80104cb2:	83 e7 03             	and    $0x3,%edi
80104cb5:	75 29                	jne    80104ce0 <memset+0x40>
    c &= 0xFF;
80104cb7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104cba:	c1 e0 18             	shl    $0x18,%eax
80104cbd:	89 fb                	mov    %edi,%ebx
80104cbf:	c1 e9 02             	shr    $0x2,%ecx
80104cc2:	c1 e3 10             	shl    $0x10,%ebx
80104cc5:	09 d8                	or     %ebx,%eax
80104cc7:	09 f8                	or     %edi,%eax
80104cc9:	c1 e7 08             	shl    $0x8,%edi
80104ccc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104cce:	89 d7                	mov    %edx,%edi
80104cd0:	fc                   	cld    
80104cd1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104cd3:	5b                   	pop    %ebx
80104cd4:	89 d0                	mov    %edx,%eax
80104cd6:	5f                   	pop    %edi
80104cd7:	5d                   	pop    %ebp
80104cd8:	c3                   	ret    
80104cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104ce0:	89 d7                	mov    %edx,%edi
80104ce2:	fc                   	cld    
80104ce3:	f3 aa                	rep stos %al,%es:(%edi)
80104ce5:	5b                   	pop    %ebx
80104ce6:	89 d0                	mov    %edx,%eax
80104ce8:	5f                   	pop    %edi
80104ce9:	5d                   	pop    %ebp
80104cea:	c3                   	ret    
80104ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cef:	90                   	nop

80104cf0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	56                   	push   %esi
80104cf4:	8b 75 10             	mov    0x10(%ebp),%esi
80104cf7:	8b 55 08             	mov    0x8(%ebp),%edx
80104cfa:	53                   	push   %ebx
80104cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104cfe:	85 f6                	test   %esi,%esi
80104d00:	74 2e                	je     80104d30 <memcmp+0x40>
80104d02:	01 c6                	add    %eax,%esi
80104d04:	eb 14                	jmp    80104d1a <memcmp+0x2a>
80104d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104d10:	83 c0 01             	add    $0x1,%eax
80104d13:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104d16:	39 f0                	cmp    %esi,%eax
80104d18:	74 16                	je     80104d30 <memcmp+0x40>
    if(*s1 != *s2)
80104d1a:	0f b6 0a             	movzbl (%edx),%ecx
80104d1d:	0f b6 18             	movzbl (%eax),%ebx
80104d20:	38 d9                	cmp    %bl,%cl
80104d22:	74 ec                	je     80104d10 <memcmp+0x20>
      return *s1 - *s2;
80104d24:	0f b6 c1             	movzbl %cl,%eax
80104d27:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104d29:	5b                   	pop    %ebx
80104d2a:	5e                   	pop    %esi
80104d2b:	5d                   	pop    %ebp
80104d2c:	c3                   	ret    
80104d2d:	8d 76 00             	lea    0x0(%esi),%esi
80104d30:	5b                   	pop    %ebx
  return 0;
80104d31:	31 c0                	xor    %eax,%eax
}
80104d33:	5e                   	pop    %esi
80104d34:	5d                   	pop    %ebp
80104d35:	c3                   	ret    
80104d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3d:	8d 76 00             	lea    0x0(%esi),%esi

80104d40 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	57                   	push   %edi
80104d44:	8b 55 08             	mov    0x8(%ebp),%edx
80104d47:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d4a:	56                   	push   %esi
80104d4b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d4e:	39 d6                	cmp    %edx,%esi
80104d50:	73 26                	jae    80104d78 <memmove+0x38>
80104d52:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104d55:	39 fa                	cmp    %edi,%edx
80104d57:	73 1f                	jae    80104d78 <memmove+0x38>
80104d59:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104d5c:	85 c9                	test   %ecx,%ecx
80104d5e:	74 0c                	je     80104d6c <memmove+0x2c>
      *--d = *--s;
80104d60:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104d64:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104d67:	83 e8 01             	sub    $0x1,%eax
80104d6a:	73 f4                	jae    80104d60 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104d6c:	5e                   	pop    %esi
80104d6d:	89 d0                	mov    %edx,%eax
80104d6f:	5f                   	pop    %edi
80104d70:	5d                   	pop    %ebp
80104d71:	c3                   	ret    
80104d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104d78:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104d7b:	89 d7                	mov    %edx,%edi
80104d7d:	85 c9                	test   %ecx,%ecx
80104d7f:	74 eb                	je     80104d6c <memmove+0x2c>
80104d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104d88:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104d89:	39 c6                	cmp    %eax,%esi
80104d8b:	75 fb                	jne    80104d88 <memmove+0x48>
}
80104d8d:	5e                   	pop    %esi
80104d8e:	89 d0                	mov    %edx,%eax
80104d90:	5f                   	pop    %edi
80104d91:	5d                   	pop    %ebp
80104d92:	c3                   	ret    
80104d93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104da0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104da0:	eb 9e                	jmp    80104d40 <memmove>
80104da2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104db0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	56                   	push   %esi
80104db4:	8b 75 10             	mov    0x10(%ebp),%esi
80104db7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dba:	53                   	push   %ebx
80104dbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104dbe:	85 f6                	test   %esi,%esi
80104dc0:	74 2e                	je     80104df0 <strncmp+0x40>
80104dc2:	01 d6                	add    %edx,%esi
80104dc4:	eb 18                	jmp    80104dde <strncmp+0x2e>
80104dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dcd:	8d 76 00             	lea    0x0(%esi),%esi
80104dd0:	38 d8                	cmp    %bl,%al
80104dd2:	75 14                	jne    80104de8 <strncmp+0x38>
    n--, p++, q++;
80104dd4:	83 c2 01             	add    $0x1,%edx
80104dd7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104dda:	39 f2                	cmp    %esi,%edx
80104ddc:	74 12                	je     80104df0 <strncmp+0x40>
80104dde:	0f b6 01             	movzbl (%ecx),%eax
80104de1:	0f b6 1a             	movzbl (%edx),%ebx
80104de4:	84 c0                	test   %al,%al
80104de6:	75 e8                	jne    80104dd0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104de8:	29 d8                	sub    %ebx,%eax
}
80104dea:	5b                   	pop    %ebx
80104deb:	5e                   	pop    %esi
80104dec:	5d                   	pop    %ebp
80104ded:	c3                   	ret    
80104dee:	66 90                	xchg   %ax,%ax
80104df0:	5b                   	pop    %ebx
    return 0;
80104df1:	31 c0                	xor    %eax,%eax
}
80104df3:	5e                   	pop    %esi
80104df4:	5d                   	pop    %ebp
80104df5:	c3                   	ret    
80104df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dfd:	8d 76 00             	lea    0x0(%esi),%esi

80104e00 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	57                   	push   %edi
80104e04:	56                   	push   %esi
80104e05:	8b 75 08             	mov    0x8(%ebp),%esi
80104e08:	53                   	push   %ebx
80104e09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e0c:	89 f0                	mov    %esi,%eax
80104e0e:	eb 15                	jmp    80104e25 <strncpy+0x25>
80104e10:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104e14:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104e17:	83 c0 01             	add    $0x1,%eax
80104e1a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104e1e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104e21:	84 d2                	test   %dl,%dl
80104e23:	74 09                	je     80104e2e <strncpy+0x2e>
80104e25:	89 cb                	mov    %ecx,%ebx
80104e27:	83 e9 01             	sub    $0x1,%ecx
80104e2a:	85 db                	test   %ebx,%ebx
80104e2c:	7f e2                	jg     80104e10 <strncpy+0x10>
    ;
  while(n-- > 0)
80104e2e:	89 c2                	mov    %eax,%edx
80104e30:	85 c9                	test   %ecx,%ecx
80104e32:	7e 17                	jle    80104e4b <strncpy+0x4b>
80104e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104e38:	83 c2 01             	add    $0x1,%edx
80104e3b:	89 c1                	mov    %eax,%ecx
80104e3d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104e41:	29 d1                	sub    %edx,%ecx
80104e43:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104e47:	85 c9                	test   %ecx,%ecx
80104e49:	7f ed                	jg     80104e38 <strncpy+0x38>
  return os;
}
80104e4b:	5b                   	pop    %ebx
80104e4c:	89 f0                	mov    %esi,%eax
80104e4e:	5e                   	pop    %esi
80104e4f:	5f                   	pop    %edi
80104e50:	5d                   	pop    %ebp
80104e51:	c3                   	ret    
80104e52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e60 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	8b 55 10             	mov    0x10(%ebp),%edx
80104e67:	8b 75 08             	mov    0x8(%ebp),%esi
80104e6a:	53                   	push   %ebx
80104e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104e6e:	85 d2                	test   %edx,%edx
80104e70:	7e 25                	jle    80104e97 <safestrcpy+0x37>
80104e72:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104e76:	89 f2                	mov    %esi,%edx
80104e78:	eb 16                	jmp    80104e90 <safestrcpy+0x30>
80104e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104e80:	0f b6 08             	movzbl (%eax),%ecx
80104e83:	83 c0 01             	add    $0x1,%eax
80104e86:	83 c2 01             	add    $0x1,%edx
80104e89:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e8c:	84 c9                	test   %cl,%cl
80104e8e:	74 04                	je     80104e94 <safestrcpy+0x34>
80104e90:	39 d8                	cmp    %ebx,%eax
80104e92:	75 ec                	jne    80104e80 <safestrcpy+0x20>
    ;
  *s = 0;
80104e94:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104e97:	89 f0                	mov    %esi,%eax
80104e99:	5b                   	pop    %ebx
80104e9a:	5e                   	pop    %esi
80104e9b:	5d                   	pop    %ebp
80104e9c:	c3                   	ret    
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ea0 <strlen>:

int
strlen(const char *s)
{
80104ea0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ea1:	31 c0                	xor    %eax,%eax
{
80104ea3:	89 e5                	mov    %esp,%ebp
80104ea5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ea8:	80 3a 00             	cmpb   $0x0,(%edx)
80104eab:	74 0c                	je     80104eb9 <strlen+0x19>
80104ead:	8d 76 00             	lea    0x0(%esi),%esi
80104eb0:	83 c0 01             	add    $0x1,%eax
80104eb3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104eb7:	75 f7                	jne    80104eb0 <strlen+0x10>
    ;
  return n;
}
80104eb9:	5d                   	pop    %ebp
80104eba:	c3                   	ret    

80104ebb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104ebb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104ebf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ec3:	55                   	push   %ebp
  pushl %ebx
80104ec4:	53                   	push   %ebx
  pushl %esi
80104ec5:	56                   	push   %esi
  pushl %edi
80104ec6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ec7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ec9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104ecb:	5f                   	pop    %edi
  popl %esi
80104ecc:	5e                   	pop    %esi
  popl %ebx
80104ecd:	5b                   	pop    %ebx
  popl %ebp
80104ece:	5d                   	pop    %ebp
  ret
80104ecf:	c3                   	ret    

80104ed0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	53                   	push   %ebx
80104ed4:	83 ec 04             	sub    $0x4,%esp
80104ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104eda:	e8 51 eb ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104edf:	8b 00                	mov    (%eax),%eax
80104ee1:	39 d8                	cmp    %ebx,%eax
80104ee3:	76 1b                	jbe    80104f00 <fetchint+0x30>
80104ee5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ee8:	39 d0                	cmp    %edx,%eax
80104eea:	72 14                	jb     80104f00 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104eec:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eef:	8b 13                	mov    (%ebx),%edx
80104ef1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ef3:	31 c0                	xor    %eax,%eax
}
80104ef5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ef8:	c9                   	leave  
80104ef9:	c3                   	ret    
80104efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f05:	eb ee                	jmp    80104ef5 <fetchint+0x25>
80104f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0e:	66 90                	xchg   %ax,%ax

80104f10 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	53                   	push   %ebx
80104f14:	83 ec 04             	sub    $0x4,%esp
80104f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f1a:	e8 11 eb ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz)
80104f1f:	39 18                	cmp    %ebx,(%eax)
80104f21:	76 2d                	jbe    80104f50 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104f23:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f26:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104f28:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104f2a:	39 d3                	cmp    %edx,%ebx
80104f2c:	73 22                	jae    80104f50 <fetchstr+0x40>
80104f2e:	89 d8                	mov    %ebx,%eax
80104f30:	eb 0d                	jmp    80104f3f <fetchstr+0x2f>
80104f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f38:	83 c0 01             	add    $0x1,%eax
80104f3b:	39 c2                	cmp    %eax,%edx
80104f3d:	76 11                	jbe    80104f50 <fetchstr+0x40>
    if(*s == 0)
80104f3f:	80 38 00             	cmpb   $0x0,(%eax)
80104f42:	75 f4                	jne    80104f38 <fetchstr+0x28>
      return s - *pp;
80104f44:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104f46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f49:	c9                   	leave  
80104f4a:	c3                   	ret    
80104f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f4f:	90                   	nop
80104f50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104f53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f58:	c9                   	leave  
80104f59:	c3                   	ret    
80104f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f60 <fetchfloat>:
int
fetchfloat(uint addr, float *fp)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	53                   	push   %ebx
80104f64:	83 ec 04             	sub    $0x4,%esp
80104f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f6a:	e8 c1 ea ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f6f:	8b 00                	mov    (%eax),%eax
80104f71:	39 d8                	cmp    %ebx,%eax
80104f73:	76 1b                	jbe    80104f90 <fetchfloat+0x30>
80104f75:	8d 53 04             	lea    0x4(%ebx),%edx
80104f78:	39 d0                	cmp    %edx,%eax
80104f7a:	72 14                	jb     80104f90 <fetchfloat+0x30>
    return -1;
  *fp = *(float*)(addr);
80104f7c:	d9 03                	flds   (%ebx)
80104f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f81:	d9 18                	fstps  (%eax)
  return 0;
80104f83:	31 c0                	xor    %eax,%eax
}
80104f85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f88:	c9                   	leave  
80104f89:	c3                   	ret    
80104f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f95:	eb ee                	jmp    80104f85 <fetchfloat+0x25>
80104f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9e:	66 90                	xchg   %ax,%ax

80104fa0 <argint>:
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fa5:	e8 86 ea ff ff       	call   80103a30 <myproc>
80104faa:	8b 55 08             	mov    0x8(%ebp),%edx
80104fad:	8b 40 18             	mov    0x18(%eax),%eax
80104fb0:	8b 40 44             	mov    0x44(%eax),%eax
80104fb3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104fb6:	e8 75 ea ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fbb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fbe:	8b 00                	mov    (%eax),%eax
80104fc0:	39 c6                	cmp    %eax,%esi
80104fc2:	73 1c                	jae    80104fe0 <argint+0x40>
80104fc4:	8d 53 08             	lea    0x8(%ebx),%edx
80104fc7:	39 d0                	cmp    %edx,%eax
80104fc9:	72 15                	jb     80104fe0 <argint+0x40>
  *ip = *(int*)(addr);
80104fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fce:	8b 53 04             	mov    0x4(%ebx),%edx
80104fd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104fd3:	31 c0                	xor    %eax,%eax
}
80104fd5:	5b                   	pop    %ebx
80104fd6:	5e                   	pop    %esi
80104fd7:	5d                   	pop    %ebp
80104fd8:	c3                   	ret    
80104fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fe5:	eb ee                	jmp    80104fd5 <argint+0x35>
80104fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fee:	66 90                	xchg   %ax,%ax

80104ff0 <argf>:
int
argf(int n, float *fp)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80104ff5:	e8 36 ea ff ff       	call   80103a30 <myproc>
80104ffa:	8b 55 08             	mov    0x8(%ebp),%edx
80104ffd:	8b 40 18             	mov    0x18(%eax),%eax
80105000:	8b 40 44             	mov    0x44(%eax),%eax
80105003:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105006:	e8 25 ea ff ff       	call   80103a30 <myproc>
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
8010500b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010500e:	8b 00                	mov    (%eax),%eax
80105010:	39 c6                	cmp    %eax,%esi
80105012:	73 1c                	jae    80105030 <argf+0x40>
80105014:	8d 53 08             	lea    0x8(%ebx),%edx
80105017:	39 d0                	cmp    %edx,%eax
80105019:	72 15                	jb     80105030 <argf+0x40>
  *fp = *(float*)(addr);
8010501b:	d9 43 04             	flds   0x4(%ebx)
8010501e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105021:	d9 18                	fstps  (%eax)
  return 0;
80105023:	31 c0                	xor    %eax,%eax
}
80105025:	5b                   	pop    %ebx
80105026:	5e                   	pop    %esi
80105027:	5d                   	pop    %ebp
80105028:	c3                   	ret    
80105029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105035:	eb ee                	jmp    80105025 <argf+0x35>
80105037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503e:	66 90                	xchg   %ax,%ax

80105040 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	57                   	push   %edi
80105044:	56                   	push   %esi
80105045:	53                   	push   %ebx
80105046:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105049:	e8 e2 e9 ff ff       	call   80103a30 <myproc>
8010504e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105050:	e8 db e9 ff ff       	call   80103a30 <myproc>
80105055:	8b 55 08             	mov    0x8(%ebp),%edx
80105058:	8b 40 18             	mov    0x18(%eax),%eax
8010505b:	8b 40 44             	mov    0x44(%eax),%eax
8010505e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105061:	e8 ca e9 ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105066:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105069:	8b 00                	mov    (%eax),%eax
8010506b:	39 c7                	cmp    %eax,%edi
8010506d:	73 31                	jae    801050a0 <argptr+0x60>
8010506f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105072:	39 c8                	cmp    %ecx,%eax
80105074:	72 2a                	jb     801050a0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105076:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105079:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010507c:	85 d2                	test   %edx,%edx
8010507e:	78 20                	js     801050a0 <argptr+0x60>
80105080:	8b 16                	mov    (%esi),%edx
80105082:	39 c2                	cmp    %eax,%edx
80105084:	76 1a                	jbe    801050a0 <argptr+0x60>
80105086:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105089:	01 c3                	add    %eax,%ebx
8010508b:	39 da                	cmp    %ebx,%edx
8010508d:	72 11                	jb     801050a0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010508f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105092:	89 02                	mov    %eax,(%edx)
  return 0;
80105094:	31 c0                	xor    %eax,%eax
}
80105096:	83 c4 0c             	add    $0xc,%esp
80105099:	5b                   	pop    %ebx
8010509a:	5e                   	pop    %esi
8010509b:	5f                   	pop    %edi
8010509c:	5d                   	pop    %ebp
8010509d:	c3                   	ret    
8010509e:	66 90                	xchg   %ax,%ax
    return -1;
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a5:	eb ef                	jmp    80105096 <argptr+0x56>
801050a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ae:	66 90                	xchg   %ax,%ax

801050b0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	56                   	push   %esi
801050b4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050b5:	e8 76 e9 ff ff       	call   80103a30 <myproc>
801050ba:	8b 55 08             	mov    0x8(%ebp),%edx
801050bd:	8b 40 18             	mov    0x18(%eax),%eax
801050c0:	8b 40 44             	mov    0x44(%eax),%eax
801050c3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801050c6:	e8 65 e9 ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050cb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050ce:	8b 00                	mov    (%eax),%eax
801050d0:	39 c6                	cmp    %eax,%esi
801050d2:	73 44                	jae    80105118 <argstr+0x68>
801050d4:	8d 53 08             	lea    0x8(%ebx),%edx
801050d7:	39 d0                	cmp    %edx,%eax
801050d9:	72 3d                	jb     80105118 <argstr+0x68>
  *ip = *(int*)(addr);
801050db:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801050de:	e8 4d e9 ff ff       	call   80103a30 <myproc>
  if(addr >= curproc->sz)
801050e3:	3b 18                	cmp    (%eax),%ebx
801050e5:	73 31                	jae    80105118 <argstr+0x68>
  *pp = (char*)addr;
801050e7:	8b 55 0c             	mov    0xc(%ebp),%edx
801050ea:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801050ec:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801050ee:	39 d3                	cmp    %edx,%ebx
801050f0:	73 26                	jae    80105118 <argstr+0x68>
801050f2:	89 d8                	mov    %ebx,%eax
801050f4:	eb 11                	jmp    80105107 <argstr+0x57>
801050f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050fd:	8d 76 00             	lea    0x0(%esi),%esi
80105100:	83 c0 01             	add    $0x1,%eax
80105103:	39 c2                	cmp    %eax,%edx
80105105:	76 11                	jbe    80105118 <argstr+0x68>
    if(*s == 0)
80105107:	80 38 00             	cmpb   $0x0,(%eax)
8010510a:	75 f4                	jne    80105100 <argstr+0x50>
      return s - *pp;
8010510c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010510e:	5b                   	pop    %ebx
8010510f:	5e                   	pop    %esi
80105110:	5d                   	pop    %ebp
80105111:	c3                   	ret    
80105112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105118:	5b                   	pop    %ebx
    return -1;
80105119:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010511e:	5e                   	pop    %esi
8010511f:	5d                   	pop    %ebp
80105120:	c3                   	ret    
80105121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010512f:	90                   	nop

80105130 <syscall>:
[SYS_print_info] sys_print_info
};

void
syscall(void)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	53                   	push   %ebx
80105134:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105137:	e8 f4 e8 ff ff       	call   80103a30 <myproc>
8010513c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010513e:	8b 40 18             	mov    0x18(%eax),%eax
80105141:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105144:	8d 50 ff             	lea    -0x1(%eax),%edx
80105147:	83 fa 1f             	cmp    $0x1f,%edx
8010514a:	77 24                	ja     80105170 <syscall+0x40>
8010514c:	8b 14 85 60 85 10 80 	mov    -0x7fef7aa0(,%eax,4),%edx
80105153:	85 d2                	test   %edx,%edx
80105155:	74 19                	je     80105170 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105157:	ff d2                	call   *%edx
80105159:	89 c2                	mov    %eax,%edx
8010515b:	8b 43 18             	mov    0x18(%ebx),%eax
8010515e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105161:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105164:	c9                   	leave  
80105165:	c3                   	ret    
80105166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010516d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105170:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105171:	8d 43 78             	lea    0x78(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105174:	50                   	push   %eax
80105175:	ff 73 10             	push   0x10(%ebx)
80105178:	68 3d 85 10 80       	push   $0x8010853d
8010517d:	e8 1e b5 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80105182:	8b 43 18             	mov    0x18(%ebx),%eax
80105185:	83 c4 10             	add    $0x10,%esp
80105188:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010518f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105192:	c9                   	leave  
80105193:	c3                   	ret    
80105194:	66 90                	xchg   %ax,%ax
80105196:	66 90                	xchg   %ax,%ax
80105198:	66 90                	xchg   %ax,%ax
8010519a:	66 90                	xchg   %ax,%ax
8010519c:	66 90                	xchg   %ax,%ax
8010519e:	66 90                	xchg   %ax,%ax

801051a0 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	57                   	push   %edi
801051a4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
801051a5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801051a8:	53                   	push   %ebx
801051a9:	83 ec 34             	sub    $0x34,%esp
801051ac:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801051af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if ((dp = nameiparent(path, name)) == 0)
801051b2:	57                   	push   %edi
801051b3:	50                   	push   %eax
{
801051b4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801051b7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if ((dp = nameiparent(path, name)) == 0)
801051ba:	e8 01 cf ff ff       	call   801020c0 <nameiparent>
801051bf:	83 c4 10             	add    $0x10,%esp
801051c2:	85 c0                	test   %eax,%eax
801051c4:	0f 84 46 01 00 00    	je     80105310 <create+0x170>
    return 0;
  ilock(dp);
801051ca:	83 ec 0c             	sub    $0xc,%esp
801051cd:	89 c3                	mov    %eax,%ebx
801051cf:	50                   	push   %eax
801051d0:	e8 ab c5 ff ff       	call   80101780 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
801051d5:	83 c4 0c             	add    $0xc,%esp
801051d8:	6a 00                	push   $0x0
801051da:	57                   	push   %edi
801051db:	53                   	push   %ebx
801051dc:	e8 ff ca ff ff       	call   80101ce0 <dirlookup>
801051e1:	83 c4 10             	add    $0x10,%esp
801051e4:	89 c6                	mov    %eax,%esi
801051e6:	85 c0                	test   %eax,%eax
801051e8:	74 56                	je     80105240 <create+0xa0>
  {
    iunlockput(dp);
801051ea:	83 ec 0c             	sub    $0xc,%esp
801051ed:	53                   	push   %ebx
801051ee:	e8 1d c8 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
801051f3:	89 34 24             	mov    %esi,(%esp)
801051f6:	e8 85 c5 ff ff       	call   80101780 <ilock>
    if (type == T_FILE && ip->type == T_FILE)
801051fb:	83 c4 10             	add    $0x10,%esp
801051fe:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105203:	75 1b                	jne    80105220 <create+0x80>
80105205:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010520a:	75 14                	jne    80105220 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010520c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010520f:	89 f0                	mov    %esi,%eax
80105211:	5b                   	pop    %ebx
80105212:	5e                   	pop    %esi
80105213:	5f                   	pop    %edi
80105214:	5d                   	pop    %ebp
80105215:	c3                   	ret    
80105216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105220:	83 ec 0c             	sub    $0xc,%esp
80105223:	56                   	push   %esi
    return 0;
80105224:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105226:	e8 e5 c7 ff ff       	call   80101a10 <iunlockput>
    return 0;
8010522b:	83 c4 10             	add    $0x10,%esp
}
8010522e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105231:	89 f0                	mov    %esi,%eax
80105233:	5b                   	pop    %ebx
80105234:	5e                   	pop    %esi
80105235:	5f                   	pop    %edi
80105236:	5d                   	pop    %ebp
80105237:	c3                   	ret    
80105238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010523f:	90                   	nop
  if ((ip = ialloc(dp->dev, type)) == 0)
80105240:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105244:	83 ec 08             	sub    $0x8,%esp
80105247:	50                   	push   %eax
80105248:	ff 33                	push   (%ebx)
8010524a:	e8 c1 c3 ff ff       	call   80101610 <ialloc>
8010524f:	83 c4 10             	add    $0x10,%esp
80105252:	89 c6                	mov    %eax,%esi
80105254:	85 c0                	test   %eax,%eax
80105256:	0f 84 cd 00 00 00    	je     80105329 <create+0x189>
  ilock(ip);
8010525c:	83 ec 0c             	sub    $0xc,%esp
8010525f:	50                   	push   %eax
80105260:	e8 1b c5 ff ff       	call   80101780 <ilock>
  ip->major = major;
80105265:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105269:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010526d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105271:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105275:	b8 01 00 00 00       	mov    $0x1,%eax
8010527a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010527e:	89 34 24             	mov    %esi,(%esp)
80105281:	e8 4a c4 ff ff       	call   801016d0 <iupdate>
  if (type == T_DIR)
80105286:	83 c4 10             	add    $0x10,%esp
80105289:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010528e:	74 30                	je     801052c0 <create+0x120>
  if (dirlink(dp, name, ip->inum) < 0)
80105290:	83 ec 04             	sub    $0x4,%esp
80105293:	ff 76 04             	push   0x4(%esi)
80105296:	57                   	push   %edi
80105297:	53                   	push   %ebx
80105298:	e8 43 cd ff ff       	call   80101fe0 <dirlink>
8010529d:	83 c4 10             	add    $0x10,%esp
801052a0:	85 c0                	test   %eax,%eax
801052a2:	78 78                	js     8010531c <create+0x17c>
  iunlockput(dp);
801052a4:	83 ec 0c             	sub    $0xc,%esp
801052a7:	53                   	push   %ebx
801052a8:	e8 63 c7 ff ff       	call   80101a10 <iunlockput>
  return ip;
801052ad:	83 c4 10             	add    $0x10,%esp
}
801052b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052b3:	89 f0                	mov    %esi,%eax
801052b5:	5b                   	pop    %ebx
801052b6:	5e                   	pop    %esi
801052b7:	5f                   	pop    %edi
801052b8:	5d                   	pop    %ebp
801052b9:	c3                   	ret    
801052ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801052c0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++; // for ".."
801052c3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801052c8:	53                   	push   %ebx
801052c9:	e8 02 c4 ff ff       	call   801016d0 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801052ce:	83 c4 0c             	add    $0xc,%esp
801052d1:	ff 76 04             	push   0x4(%esi)
801052d4:	68 00 86 10 80       	push   $0x80108600
801052d9:	56                   	push   %esi
801052da:	e8 01 cd ff ff       	call   80101fe0 <dirlink>
801052df:	83 c4 10             	add    $0x10,%esp
801052e2:	85 c0                	test   %eax,%eax
801052e4:	78 18                	js     801052fe <create+0x15e>
801052e6:	83 ec 04             	sub    $0x4,%esp
801052e9:	ff 73 04             	push   0x4(%ebx)
801052ec:	68 ff 85 10 80       	push   $0x801085ff
801052f1:	56                   	push   %esi
801052f2:	e8 e9 cc ff ff       	call   80101fe0 <dirlink>
801052f7:	83 c4 10             	add    $0x10,%esp
801052fa:	85 c0                	test   %eax,%eax
801052fc:	79 92                	jns    80105290 <create+0xf0>
      panic("create dots");
801052fe:	83 ec 0c             	sub    $0xc,%esp
80105301:	68 f3 85 10 80       	push   $0x801085f3
80105306:	e8 75 b0 ff ff       	call   80100380 <panic>
8010530b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010530f:	90                   	nop
}
80105310:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105313:	31 f6                	xor    %esi,%esi
}
80105315:	5b                   	pop    %ebx
80105316:	89 f0                	mov    %esi,%eax
80105318:	5e                   	pop    %esi
80105319:	5f                   	pop    %edi
8010531a:	5d                   	pop    %ebp
8010531b:	c3                   	ret    
    panic("create: dirlink");
8010531c:	83 ec 0c             	sub    $0xc,%esp
8010531f:	68 02 86 10 80       	push   $0x80108602
80105324:	e8 57 b0 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105329:	83 ec 0c             	sub    $0xc,%esp
8010532c:	68 e4 85 10 80       	push   $0x801085e4
80105331:	e8 4a b0 ff ff       	call   80100380 <panic>
80105336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010533d:	8d 76 00             	lea    0x0(%esi),%esi

80105340 <sys_dup>:
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	56                   	push   %esi
80105344:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105345:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105348:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010534b:	50                   	push   %eax
8010534c:	6a 00                	push   $0x0
8010534e:	e8 4d fc ff ff       	call   80104fa0 <argint>
80105353:	83 c4 10             	add    $0x10,%esp
80105356:	85 c0                	test   %eax,%eax
80105358:	78 36                	js     80105390 <sys_dup+0x50>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010535a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010535e:	77 30                	ja     80105390 <sys_dup+0x50>
80105360:	e8 cb e6 ff ff       	call   80103a30 <myproc>
80105365:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105368:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
8010536c:	85 f6                	test   %esi,%esi
8010536e:	74 20                	je     80105390 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105370:	e8 bb e6 ff ff       	call   80103a30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105375:	31 db                	xor    %ebx,%ebx
80105377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010537e:	66 90                	xchg   %ax,%ax
    if (curproc->ofile[fd] == 0)
80105380:	8b 54 98 34          	mov    0x34(%eax,%ebx,4),%edx
80105384:	85 d2                	test   %edx,%edx
80105386:	74 18                	je     801053a0 <sys_dup+0x60>
  for (fd = 0; fd < NOFILE; fd++)
80105388:	83 c3 01             	add    $0x1,%ebx
8010538b:	83 fb 10             	cmp    $0x10,%ebx
8010538e:	75 f0                	jne    80105380 <sys_dup+0x40>
}
80105390:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105393:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105398:	89 d8                	mov    %ebx,%eax
8010539a:	5b                   	pop    %ebx
8010539b:	5e                   	pop    %esi
8010539c:	5d                   	pop    %ebp
8010539d:	c3                   	ret    
8010539e:	66 90                	xchg   %ax,%ax
  filedup(f);
801053a0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801053a3:	89 74 98 34          	mov    %esi,0x34(%eax,%ebx,4)
  filedup(f);
801053a7:	56                   	push   %esi
801053a8:	e8 f3 ba ff ff       	call   80100ea0 <filedup>
  return fd;
801053ad:	83 c4 10             	add    $0x10,%esp
}
801053b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053b3:	89 d8                	mov    %ebx,%eax
801053b5:	5b                   	pop    %ebx
801053b6:	5e                   	pop    %esi
801053b7:	5d                   	pop    %ebp
801053b8:	c3                   	ret    
801053b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053c0 <sys_read>:
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	56                   	push   %esi
801053c4:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
801053c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801053c8:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
801053cb:	53                   	push   %ebx
801053cc:	6a 00                	push   $0x0
801053ce:	e8 cd fb ff ff       	call   80104fa0 <argint>
801053d3:	83 c4 10             	add    $0x10,%esp
801053d6:	85 c0                	test   %eax,%eax
801053d8:	78 5e                	js     80105438 <sys_read+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801053da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053de:	77 58                	ja     80105438 <sys_read+0x78>
801053e0:	e8 4b e6 ff ff       	call   80103a30 <myproc>
801053e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053e8:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
801053ec:	85 f6                	test   %esi,%esi
801053ee:	74 48                	je     80105438 <sys_read+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053f0:	83 ec 08             	sub    $0x8,%esp
801053f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053f6:	50                   	push   %eax
801053f7:	6a 02                	push   $0x2
801053f9:	e8 a2 fb ff ff       	call   80104fa0 <argint>
801053fe:	83 c4 10             	add    $0x10,%esp
80105401:	85 c0                	test   %eax,%eax
80105403:	78 33                	js     80105438 <sys_read+0x78>
80105405:	83 ec 04             	sub    $0x4,%esp
80105408:	ff 75 f0             	push   -0x10(%ebp)
8010540b:	53                   	push   %ebx
8010540c:	6a 01                	push   $0x1
8010540e:	e8 2d fc ff ff       	call   80105040 <argptr>
80105413:	83 c4 10             	add    $0x10,%esp
80105416:	85 c0                	test   %eax,%eax
80105418:	78 1e                	js     80105438 <sys_read+0x78>
  return fileread(f, p, n);
8010541a:	83 ec 04             	sub    $0x4,%esp
8010541d:	ff 75 f0             	push   -0x10(%ebp)
80105420:	ff 75 f4             	push   -0xc(%ebp)
80105423:	56                   	push   %esi
80105424:	e8 f7 bb ff ff       	call   80101020 <fileread>
80105429:	83 c4 10             	add    $0x10,%esp
}
8010542c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010542f:	5b                   	pop    %ebx
80105430:	5e                   	pop    %esi
80105431:	5d                   	pop    %ebp
80105432:	c3                   	ret    
80105433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105437:	90                   	nop
    return -1;
80105438:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543d:	eb ed                	jmp    8010542c <sys_read+0x6c>
8010543f:	90                   	nop

80105440 <sys_write>:
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	56                   	push   %esi
80105444:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105445:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105448:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010544b:	53                   	push   %ebx
8010544c:	6a 00                	push   $0x0
8010544e:	e8 4d fb ff ff       	call   80104fa0 <argint>
80105453:	83 c4 10             	add    $0x10,%esp
80105456:	85 c0                	test   %eax,%eax
80105458:	78 5e                	js     801054b8 <sys_write+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010545a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010545e:	77 58                	ja     801054b8 <sys_write+0x78>
80105460:	e8 cb e5 ff ff       	call   80103a30 <myproc>
80105465:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105468:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
8010546c:	85 f6                	test   %esi,%esi
8010546e:	74 48                	je     801054b8 <sys_write+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105470:	83 ec 08             	sub    $0x8,%esp
80105473:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105476:	50                   	push   %eax
80105477:	6a 02                	push   $0x2
80105479:	e8 22 fb ff ff       	call   80104fa0 <argint>
8010547e:	83 c4 10             	add    $0x10,%esp
80105481:	85 c0                	test   %eax,%eax
80105483:	78 33                	js     801054b8 <sys_write+0x78>
80105485:	83 ec 04             	sub    $0x4,%esp
80105488:	ff 75 f0             	push   -0x10(%ebp)
8010548b:	53                   	push   %ebx
8010548c:	6a 01                	push   $0x1
8010548e:	e8 ad fb ff ff       	call   80105040 <argptr>
80105493:	83 c4 10             	add    $0x10,%esp
80105496:	85 c0                	test   %eax,%eax
80105498:	78 1e                	js     801054b8 <sys_write+0x78>
  return filewrite(f, p, n);
8010549a:	83 ec 04             	sub    $0x4,%esp
8010549d:	ff 75 f0             	push   -0x10(%ebp)
801054a0:	ff 75 f4             	push   -0xc(%ebp)
801054a3:	56                   	push   %esi
801054a4:	e8 07 bc ff ff       	call   801010b0 <filewrite>
801054a9:	83 c4 10             	add    $0x10,%esp
}
801054ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054af:	5b                   	pop    %ebx
801054b0:	5e                   	pop    %esi
801054b1:	5d                   	pop    %ebp
801054b2:	c3                   	ret    
801054b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054b7:	90                   	nop
    return -1;
801054b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054bd:	eb ed                	jmp    801054ac <sys_write+0x6c>
801054bf:	90                   	nop

801054c0 <sys_close>:
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	56                   	push   %esi
801054c4:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
801054c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801054c8:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
801054cb:	50                   	push   %eax
801054cc:	6a 00                	push   $0x0
801054ce:	e8 cd fa ff ff       	call   80104fa0 <argint>
801054d3:	83 c4 10             	add    $0x10,%esp
801054d6:	85 c0                	test   %eax,%eax
801054d8:	78 3e                	js     80105518 <sys_close+0x58>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801054da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054de:	77 38                	ja     80105518 <sys_close+0x58>
801054e0:	e8 4b e5 ff ff       	call   80103a30 <myproc>
801054e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054e8:	8d 5a 0c             	lea    0xc(%edx),%ebx
801054eb:	8b 74 98 04          	mov    0x4(%eax,%ebx,4),%esi
801054ef:	85 f6                	test   %esi,%esi
801054f1:	74 25                	je     80105518 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801054f3:	e8 38 e5 ff ff       	call   80103a30 <myproc>
  fileclose(f);
801054f8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801054fb:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
80105502:	00 
  fileclose(f);
80105503:	56                   	push   %esi
80105504:	e8 e7 b9 ff ff       	call   80100ef0 <fileclose>
  return 0;
80105509:	83 c4 10             	add    $0x10,%esp
8010550c:	31 c0                	xor    %eax,%eax
}
8010550e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105511:	5b                   	pop    %ebx
80105512:	5e                   	pop    %esi
80105513:	5d                   	pop    %ebp
80105514:	c3                   	ret    
80105515:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105518:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010551d:	eb ef                	jmp    8010550e <sys_close+0x4e>
8010551f:	90                   	nop

80105520 <sys_fstat>:
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	56                   	push   %esi
80105524:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105525:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105528:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010552b:	53                   	push   %ebx
8010552c:	6a 00                	push   $0x0
8010552e:	e8 6d fa ff ff       	call   80104fa0 <argint>
80105533:	83 c4 10             	add    $0x10,%esp
80105536:	85 c0                	test   %eax,%eax
80105538:	78 46                	js     80105580 <sys_fstat+0x60>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010553a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010553e:	77 40                	ja     80105580 <sys_fstat+0x60>
80105540:	e8 eb e4 ff ff       	call   80103a30 <myproc>
80105545:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105548:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
8010554c:	85 f6                	test   %esi,%esi
8010554e:	74 30                	je     80105580 <sys_fstat+0x60>
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
80105550:	83 ec 04             	sub    $0x4,%esp
80105553:	6a 14                	push   $0x14
80105555:	53                   	push   %ebx
80105556:	6a 01                	push   $0x1
80105558:	e8 e3 fa ff ff       	call   80105040 <argptr>
8010555d:	83 c4 10             	add    $0x10,%esp
80105560:	85 c0                	test   %eax,%eax
80105562:	78 1c                	js     80105580 <sys_fstat+0x60>
  return filestat(f, st);
80105564:	83 ec 08             	sub    $0x8,%esp
80105567:	ff 75 f4             	push   -0xc(%ebp)
8010556a:	56                   	push   %esi
8010556b:	e8 60 ba ff ff       	call   80100fd0 <filestat>
80105570:	83 c4 10             	add    $0x10,%esp
}
80105573:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105576:	5b                   	pop    %ebx
80105577:	5e                   	pop    %esi
80105578:	5d                   	pop    %ebp
80105579:	c3                   	ret    
8010557a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105585:	eb ec                	jmp    80105573 <sys_fstat+0x53>
80105587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010558e:	66 90                	xchg   %ax,%ax

80105590 <sys_link>:
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	57                   	push   %edi
80105594:	56                   	push   %esi
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105595:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105598:	53                   	push   %ebx
80105599:	83 ec 34             	sub    $0x34,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010559c:	50                   	push   %eax
8010559d:	6a 00                	push   $0x0
8010559f:	e8 0c fb ff ff       	call   801050b0 <argstr>
801055a4:	83 c4 10             	add    $0x10,%esp
801055a7:	85 c0                	test   %eax,%eax
801055a9:	0f 88 fb 00 00 00    	js     801056aa <sys_link+0x11a>
801055af:	83 ec 08             	sub    $0x8,%esp
801055b2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801055b5:	50                   	push   %eax
801055b6:	6a 01                	push   $0x1
801055b8:	e8 f3 fa ff ff       	call   801050b0 <argstr>
801055bd:	83 c4 10             	add    $0x10,%esp
801055c0:	85 c0                	test   %eax,%eax
801055c2:	0f 88 e2 00 00 00    	js     801056aa <sys_link+0x11a>
  begin_op();
801055c8:	e8 93 d7 ff ff       	call   80102d60 <begin_op>
  if ((ip = namei(old)) == 0)
801055cd:	83 ec 0c             	sub    $0xc,%esp
801055d0:	ff 75 d4             	push   -0x2c(%ebp)
801055d3:	e8 c8 ca ff ff       	call   801020a0 <namei>
801055d8:	83 c4 10             	add    $0x10,%esp
801055db:	89 c3                	mov    %eax,%ebx
801055dd:	85 c0                	test   %eax,%eax
801055df:	0f 84 e4 00 00 00    	je     801056c9 <sys_link+0x139>
  ilock(ip);
801055e5:	83 ec 0c             	sub    $0xc,%esp
801055e8:	50                   	push   %eax
801055e9:	e8 92 c1 ff ff       	call   80101780 <ilock>
  if (ip->type == T_DIR)
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055f6:	0f 84 b5 00 00 00    	je     801056b1 <sys_link+0x121>
  iupdate(ip);
801055fc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801055ff:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if ((dp = nameiparent(new, name)) == 0)
80105604:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105607:	53                   	push   %ebx
80105608:	e8 c3 c0 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010560d:	89 1c 24             	mov    %ebx,(%esp)
80105610:	e8 4b c2 ff ff       	call   80101860 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
80105615:	58                   	pop    %eax
80105616:	5a                   	pop    %edx
80105617:	57                   	push   %edi
80105618:	ff 75 d0             	push   -0x30(%ebp)
8010561b:	e8 a0 ca ff ff       	call   801020c0 <nameiparent>
80105620:	83 c4 10             	add    $0x10,%esp
80105623:	89 c6                	mov    %eax,%esi
80105625:	85 c0                	test   %eax,%eax
80105627:	74 5b                	je     80105684 <sys_link+0xf4>
  ilock(dp);
80105629:	83 ec 0c             	sub    $0xc,%esp
8010562c:	50                   	push   %eax
8010562d:	e8 4e c1 ff ff       	call   80101780 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
80105632:	8b 03                	mov    (%ebx),%eax
80105634:	83 c4 10             	add    $0x10,%esp
80105637:	39 06                	cmp    %eax,(%esi)
80105639:	75 3d                	jne    80105678 <sys_link+0xe8>
8010563b:	83 ec 04             	sub    $0x4,%esp
8010563e:	ff 73 04             	push   0x4(%ebx)
80105641:	57                   	push   %edi
80105642:	56                   	push   %esi
80105643:	e8 98 c9 ff ff       	call   80101fe0 <dirlink>
80105648:	83 c4 10             	add    $0x10,%esp
8010564b:	85 c0                	test   %eax,%eax
8010564d:	78 29                	js     80105678 <sys_link+0xe8>
  iunlockput(dp);
8010564f:	83 ec 0c             	sub    $0xc,%esp
80105652:	56                   	push   %esi
80105653:	e8 b8 c3 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105658:	89 1c 24             	mov    %ebx,(%esp)
8010565b:	e8 50 c2 ff ff       	call   801018b0 <iput>
  end_op();
80105660:	e8 6b d7 ff ff       	call   80102dd0 <end_op>
  return 0;
80105665:	83 c4 10             	add    $0x10,%esp
80105668:	31 c0                	xor    %eax,%eax
}
8010566a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010566d:	5b                   	pop    %ebx
8010566e:	5e                   	pop    %esi
8010566f:	5f                   	pop    %edi
80105670:	5d                   	pop    %ebp
80105671:	c3                   	ret    
80105672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105678:	83 ec 0c             	sub    $0xc,%esp
8010567b:	56                   	push   %esi
8010567c:	e8 8f c3 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105681:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105684:	83 ec 0c             	sub    $0xc,%esp
80105687:	53                   	push   %ebx
80105688:	e8 f3 c0 ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010568d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105692:	89 1c 24             	mov    %ebx,(%esp)
80105695:	e8 36 c0 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010569a:	89 1c 24             	mov    %ebx,(%esp)
8010569d:	e8 6e c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
801056a2:	e8 29 d7 ff ff       	call   80102dd0 <end_op>
  return -1;
801056a7:	83 c4 10             	add    $0x10,%esp
801056aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056af:	eb b9                	jmp    8010566a <sys_link+0xda>
    iunlockput(ip);
801056b1:	83 ec 0c             	sub    $0xc,%esp
801056b4:	53                   	push   %ebx
801056b5:	e8 56 c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
801056ba:	e8 11 d7 ff ff       	call   80102dd0 <end_op>
    return -1;
801056bf:	83 c4 10             	add    $0x10,%esp
801056c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056c7:	eb a1                	jmp    8010566a <sys_link+0xda>
    end_op();
801056c9:	e8 02 d7 ff ff       	call   80102dd0 <end_op>
    return -1;
801056ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d3:	eb 95                	jmp    8010566a <sys_link+0xda>
801056d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056e0 <sys_unlink>:
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	57                   	push   %edi
801056e4:	56                   	push   %esi
  if (argstr(0, &path) < 0)
801056e5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801056e8:	53                   	push   %ebx
801056e9:	83 ec 54             	sub    $0x54,%esp
  if (argstr(0, &path) < 0)
801056ec:	50                   	push   %eax
801056ed:	6a 00                	push   $0x0
801056ef:	e8 bc f9 ff ff       	call   801050b0 <argstr>
801056f4:	83 c4 10             	add    $0x10,%esp
801056f7:	85 c0                	test   %eax,%eax
801056f9:	0f 88 7a 01 00 00    	js     80105879 <sys_unlink+0x199>
  begin_op();
801056ff:	e8 5c d6 ff ff       	call   80102d60 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
80105704:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105707:	83 ec 08             	sub    $0x8,%esp
8010570a:	53                   	push   %ebx
8010570b:	ff 75 c0             	push   -0x40(%ebp)
8010570e:	e8 ad c9 ff ff       	call   801020c0 <nameiparent>
80105713:	83 c4 10             	add    $0x10,%esp
80105716:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105719:	85 c0                	test   %eax,%eax
8010571b:	0f 84 62 01 00 00    	je     80105883 <sys_unlink+0x1a3>
  ilock(dp);
80105721:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105724:	83 ec 0c             	sub    $0xc,%esp
80105727:	57                   	push   %edi
80105728:	e8 53 c0 ff ff       	call   80101780 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010572d:	58                   	pop    %eax
8010572e:	5a                   	pop    %edx
8010572f:	68 00 86 10 80       	push   $0x80108600
80105734:	53                   	push   %ebx
80105735:	e8 86 c5 ff ff       	call   80101cc0 <namecmp>
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	85 c0                	test   %eax,%eax
8010573f:	0f 84 fb 00 00 00    	je     80105840 <sys_unlink+0x160>
80105745:	83 ec 08             	sub    $0x8,%esp
80105748:	68 ff 85 10 80       	push   $0x801085ff
8010574d:	53                   	push   %ebx
8010574e:	e8 6d c5 ff ff       	call   80101cc0 <namecmp>
80105753:	83 c4 10             	add    $0x10,%esp
80105756:	85 c0                	test   %eax,%eax
80105758:	0f 84 e2 00 00 00    	je     80105840 <sys_unlink+0x160>
  if ((ip = dirlookup(dp, name, &off)) == 0)
8010575e:	83 ec 04             	sub    $0x4,%esp
80105761:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105764:	50                   	push   %eax
80105765:	53                   	push   %ebx
80105766:	57                   	push   %edi
80105767:	e8 74 c5 ff ff       	call   80101ce0 <dirlookup>
8010576c:	83 c4 10             	add    $0x10,%esp
8010576f:	89 c3                	mov    %eax,%ebx
80105771:	85 c0                	test   %eax,%eax
80105773:	0f 84 c7 00 00 00    	je     80105840 <sys_unlink+0x160>
  ilock(ip);
80105779:	83 ec 0c             	sub    $0xc,%esp
8010577c:	50                   	push   %eax
8010577d:	e8 fe bf ff ff       	call   80101780 <ilock>
  if (ip->nlink < 1)
80105782:	83 c4 10             	add    $0x10,%esp
80105785:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010578a:	0f 8e 1c 01 00 00    	jle    801058ac <sys_unlink+0x1cc>
  if (ip->type == T_DIR && !isdirempty(ip))
80105790:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105795:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105798:	74 66                	je     80105800 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010579a:	83 ec 04             	sub    $0x4,%esp
8010579d:	6a 10                	push   $0x10
8010579f:	6a 00                	push   $0x0
801057a1:	57                   	push   %edi
801057a2:	e8 f9 f4 ff ff       	call   80104ca0 <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
801057a7:	6a 10                	push   $0x10
801057a9:	ff 75 c4             	push   -0x3c(%ebp)
801057ac:	57                   	push   %edi
801057ad:	ff 75 b4             	push   -0x4c(%ebp)
801057b0:	e8 db c3 ff ff       	call   80101b90 <writei>
801057b5:	83 c4 20             	add    $0x20,%esp
801057b8:	83 f8 10             	cmp    $0x10,%eax
801057bb:	0f 85 de 00 00 00    	jne    8010589f <sys_unlink+0x1bf>
  if (ip->type == T_DIR)
801057c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057c6:	0f 84 94 00 00 00    	je     80105860 <sys_unlink+0x180>
  iunlockput(dp);
801057cc:	83 ec 0c             	sub    $0xc,%esp
801057cf:	ff 75 b4             	push   -0x4c(%ebp)
801057d2:	e8 39 c2 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
801057d7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057dc:	89 1c 24             	mov    %ebx,(%esp)
801057df:	e8 ec be ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801057e4:	89 1c 24             	mov    %ebx,(%esp)
801057e7:	e8 24 c2 ff ff       	call   80101a10 <iunlockput>
  end_op();
801057ec:	e8 df d5 ff ff       	call   80102dd0 <end_op>
  return 0;
801057f1:	83 c4 10             	add    $0x10,%esp
801057f4:	31 c0                	xor    %eax,%eax
}
801057f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057f9:	5b                   	pop    %ebx
801057fa:	5e                   	pop    %esi
801057fb:	5f                   	pop    %edi
801057fc:	5d                   	pop    %ebp
801057fd:	c3                   	ret    
801057fe:	66 90                	xchg   %ax,%ax
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
80105800:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105804:	76 94                	jbe    8010579a <sys_unlink+0xba>
80105806:	be 20 00 00 00       	mov    $0x20,%esi
8010580b:	eb 0b                	jmp    80105818 <sys_unlink+0x138>
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
80105810:	83 c6 10             	add    $0x10,%esi
80105813:	3b 73 58             	cmp    0x58(%ebx),%esi
80105816:	73 82                	jae    8010579a <sys_unlink+0xba>
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80105818:	6a 10                	push   $0x10
8010581a:	56                   	push   %esi
8010581b:	57                   	push   %edi
8010581c:	53                   	push   %ebx
8010581d:	e8 6e c2 ff ff       	call   80101a90 <readi>
80105822:	83 c4 10             	add    $0x10,%esp
80105825:	83 f8 10             	cmp    $0x10,%eax
80105828:	75 68                	jne    80105892 <sys_unlink+0x1b2>
    if (de.inum != 0)
8010582a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010582f:	74 df                	je     80105810 <sys_unlink+0x130>
    iunlockput(ip);
80105831:	83 ec 0c             	sub    $0xc,%esp
80105834:	53                   	push   %ebx
80105835:	e8 d6 c1 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010583a:	83 c4 10             	add    $0x10,%esp
8010583d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105840:	83 ec 0c             	sub    $0xc,%esp
80105843:	ff 75 b4             	push   -0x4c(%ebp)
80105846:	e8 c5 c1 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010584b:	e8 80 d5 ff ff       	call   80102dd0 <end_op>
  return -1;
80105850:	83 c4 10             	add    $0x10,%esp
80105853:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105858:	eb 9c                	jmp    801057f6 <sys_unlink+0x116>
8010585a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105860:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105863:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105866:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010586b:	50                   	push   %eax
8010586c:	e8 5f be ff ff       	call   801016d0 <iupdate>
80105871:	83 c4 10             	add    $0x10,%esp
80105874:	e9 53 ff ff ff       	jmp    801057cc <sys_unlink+0xec>
    return -1;
80105879:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010587e:	e9 73 ff ff ff       	jmp    801057f6 <sys_unlink+0x116>
    end_op();
80105883:	e8 48 d5 ff ff       	call   80102dd0 <end_op>
    return -1;
80105888:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010588d:	e9 64 ff ff ff       	jmp    801057f6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105892:	83 ec 0c             	sub    $0xc,%esp
80105895:	68 24 86 10 80       	push   $0x80108624
8010589a:	e8 e1 aa ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010589f:	83 ec 0c             	sub    $0xc,%esp
801058a2:	68 36 86 10 80       	push   $0x80108636
801058a7:	e8 d4 aa ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801058ac:	83 ec 0c             	sub    $0xc,%esp
801058af:	68 12 86 10 80       	push   $0x80108612
801058b4:	e8 c7 aa ff ff       	call   80100380 <panic>
801058b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058c0 <sys_open>:

int sys_open(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	57                   	push   %edi
801058c4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801058c8:	53                   	push   %ebx
801058c9:	83 ec 24             	sub    $0x24,%esp
  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058cc:	50                   	push   %eax
801058cd:	6a 00                	push   $0x0
801058cf:	e8 dc f7 ff ff       	call   801050b0 <argstr>
801058d4:	83 c4 10             	add    $0x10,%esp
801058d7:	85 c0                	test   %eax,%eax
801058d9:	0f 88 8e 00 00 00    	js     8010596d <sys_open+0xad>
801058df:	83 ec 08             	sub    $0x8,%esp
801058e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058e5:	50                   	push   %eax
801058e6:	6a 01                	push   $0x1
801058e8:	e8 b3 f6 ff ff       	call   80104fa0 <argint>
801058ed:	83 c4 10             	add    $0x10,%esp
801058f0:	85 c0                	test   %eax,%eax
801058f2:	78 79                	js     8010596d <sys_open+0xad>
    return -1;

  begin_op();
801058f4:	e8 67 d4 ff ff       	call   80102d60 <begin_op>

  if (omode & O_CREATE)
801058f9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801058fd:	75 79                	jne    80105978 <sys_open+0xb8>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(path)) == 0)
801058ff:	83 ec 0c             	sub    $0xc,%esp
80105902:	ff 75 e0             	push   -0x20(%ebp)
80105905:	e8 96 c7 ff ff       	call   801020a0 <namei>
8010590a:	83 c4 10             	add    $0x10,%esp
8010590d:	89 c6                	mov    %eax,%esi
8010590f:	85 c0                	test   %eax,%eax
80105911:	0f 84 7e 00 00 00    	je     80105995 <sys_open+0xd5>
    {
      end_op();
      return -1;
    }
    ilock(ip);
80105917:	83 ec 0c             	sub    $0xc,%esp
8010591a:	50                   	push   %eax
8010591b:	e8 60 be ff ff       	call   80101780 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
80105920:	83 c4 10             	add    $0x10,%esp
80105923:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105928:	0f 84 c2 00 00 00    	je     801059f0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
8010592e:	e8 fd b4 ff ff       	call   80100e30 <filealloc>
80105933:	89 c7                	mov    %eax,%edi
80105935:	85 c0                	test   %eax,%eax
80105937:	74 23                	je     8010595c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105939:	e8 f2 e0 ff ff       	call   80103a30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
8010593e:	31 db                	xor    %ebx,%ebx
    if (curproc->ofile[fd] == 0)
80105940:	8b 54 98 34          	mov    0x34(%eax,%ebx,4),%edx
80105944:	85 d2                	test   %edx,%edx
80105946:	74 60                	je     801059a8 <sys_open+0xe8>
  for (fd = 0; fd < NOFILE; fd++)
80105948:	83 c3 01             	add    $0x1,%ebx
8010594b:	83 fb 10             	cmp    $0x10,%ebx
8010594e:	75 f0                	jne    80105940 <sys_open+0x80>
  {
    if (f)
      fileclose(f);
80105950:	83 ec 0c             	sub    $0xc,%esp
80105953:	57                   	push   %edi
80105954:	e8 97 b5 ff ff       	call   80100ef0 <fileclose>
80105959:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010595c:	83 ec 0c             	sub    $0xc,%esp
8010595f:	56                   	push   %esi
80105960:	e8 ab c0 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105965:	e8 66 d4 ff ff       	call   80102dd0 <end_op>
    return -1;
8010596a:	83 c4 10             	add    $0x10,%esp
8010596d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105972:	eb 6d                	jmp    801059e1 <sys_open+0x121>
80105974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105978:	83 ec 0c             	sub    $0xc,%esp
8010597b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010597e:	31 c9                	xor    %ecx,%ecx
80105980:	ba 02 00 00 00       	mov    $0x2,%edx
80105985:	6a 00                	push   $0x0
80105987:	e8 14 f8 ff ff       	call   801051a0 <create>
    if (ip == 0)
8010598c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010598f:	89 c6                	mov    %eax,%esi
    if (ip == 0)
80105991:	85 c0                	test   %eax,%eax
80105993:	75 99                	jne    8010592e <sys_open+0x6e>
      end_op();
80105995:	e8 36 d4 ff ff       	call   80102dd0 <end_op>
      return -1;
8010599a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010599f:	eb 40                	jmp    801059e1 <sys_open+0x121>
801059a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801059a8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801059ab:	89 7c 98 34          	mov    %edi,0x34(%eax,%ebx,4)
  iunlock(ip);
801059af:	56                   	push   %esi
801059b0:	e8 ab be ff ff       	call   80101860 <iunlock>
  end_op();
801059b5:	e8 16 d4 ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
801059ba:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801059c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059c3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801059c6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801059c9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801059cb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801059d2:	f7 d0                	not    %eax
801059d4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059d7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801059da:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059dd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801059e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059e4:	89 d8                	mov    %ebx,%eax
801059e6:	5b                   	pop    %ebx
801059e7:	5e                   	pop    %esi
801059e8:	5f                   	pop    %edi
801059e9:	5d                   	pop    %ebp
801059ea:	c3                   	ret    
801059eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059ef:	90                   	nop
    if (ip->type == T_DIR && omode != O_RDONLY)
801059f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801059f3:	85 c9                	test   %ecx,%ecx
801059f5:	0f 84 33 ff ff ff    	je     8010592e <sys_open+0x6e>
801059fb:	e9 5c ff ff ff       	jmp    8010595c <sys_open+0x9c>

80105a00 <sys_mkdir>:

int sys_mkdir(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a06:	e8 55 d3 ff ff       	call   80102d60 <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
80105a0b:	83 ec 08             	sub    $0x8,%esp
80105a0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a11:	50                   	push   %eax
80105a12:	6a 00                	push   $0x0
80105a14:	e8 97 f6 ff ff       	call   801050b0 <argstr>
80105a19:	83 c4 10             	add    $0x10,%esp
80105a1c:	85 c0                	test   %eax,%eax
80105a1e:	78 30                	js     80105a50 <sys_mkdir+0x50>
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a26:	31 c9                	xor    %ecx,%ecx
80105a28:	ba 01 00 00 00       	mov    $0x1,%edx
80105a2d:	6a 00                	push   $0x0
80105a2f:	e8 6c f7 ff ff       	call   801051a0 <create>
80105a34:	83 c4 10             	add    $0x10,%esp
80105a37:	85 c0                	test   %eax,%eax
80105a39:	74 15                	je     80105a50 <sys_mkdir+0x50>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a3b:	83 ec 0c             	sub    $0xc,%esp
80105a3e:	50                   	push   %eax
80105a3f:	e8 cc bf ff ff       	call   80101a10 <iunlockput>
  end_op();
80105a44:	e8 87 d3 ff ff       	call   80102dd0 <end_op>
  return 0;
80105a49:	83 c4 10             	add    $0x10,%esp
80105a4c:	31 c0                	xor    %eax,%eax
}
80105a4e:	c9                   	leave  
80105a4f:	c3                   	ret    
    end_op();
80105a50:	e8 7b d3 ff ff       	call   80102dd0 <end_op>
    return -1;
80105a55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a5a:	c9                   	leave  
80105a5b:	c3                   	ret    
80105a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a60 <sys_mknod>:

int sys_mknod(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a66:	e8 f5 d2 ff ff       	call   80102d60 <begin_op>
  if ((argstr(0, &path)) < 0 ||
80105a6b:	83 ec 08             	sub    $0x8,%esp
80105a6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a71:	50                   	push   %eax
80105a72:	6a 00                	push   $0x0
80105a74:	e8 37 f6 ff ff       	call   801050b0 <argstr>
80105a79:	83 c4 10             	add    $0x10,%esp
80105a7c:	85 c0                	test   %eax,%eax
80105a7e:	78 60                	js     80105ae0 <sys_mknod+0x80>
      argint(1, &major) < 0 ||
80105a80:	83 ec 08             	sub    $0x8,%esp
80105a83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a86:	50                   	push   %eax
80105a87:	6a 01                	push   $0x1
80105a89:	e8 12 f5 ff ff       	call   80104fa0 <argint>
  if ((argstr(0, &path)) < 0 ||
80105a8e:	83 c4 10             	add    $0x10,%esp
80105a91:	85 c0                	test   %eax,%eax
80105a93:	78 4b                	js     80105ae0 <sys_mknod+0x80>
      argint(2, &minor) < 0 ||
80105a95:	83 ec 08             	sub    $0x8,%esp
80105a98:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a9b:	50                   	push   %eax
80105a9c:	6a 02                	push   $0x2
80105a9e:	e8 fd f4 ff ff       	call   80104fa0 <argint>
      argint(1, &major) < 0 ||
80105aa3:	83 c4 10             	add    $0x10,%esp
80105aa6:	85 c0                	test   %eax,%eax
80105aa8:	78 36                	js     80105ae0 <sys_mknod+0x80>
      (ip = create(path, T_DEV, major, minor)) == 0)
80105aaa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105aae:	83 ec 0c             	sub    $0xc,%esp
80105ab1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105ab5:	ba 03 00 00 00       	mov    $0x3,%edx
80105aba:	50                   	push   %eax
80105abb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105abe:	e8 dd f6 ff ff       	call   801051a0 <create>
      argint(2, &minor) < 0 ||
80105ac3:	83 c4 10             	add    $0x10,%esp
80105ac6:	85 c0                	test   %eax,%eax
80105ac8:	74 16                	je     80105ae0 <sys_mknod+0x80>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80105aca:	83 ec 0c             	sub    $0xc,%esp
80105acd:	50                   	push   %eax
80105ace:	e8 3d bf ff ff       	call   80101a10 <iunlockput>
  end_op();
80105ad3:	e8 f8 d2 ff ff       	call   80102dd0 <end_op>
  return 0;
80105ad8:	83 c4 10             	add    $0x10,%esp
80105adb:	31 c0                	xor    %eax,%eax
}
80105add:	c9                   	leave  
80105ade:	c3                   	ret    
80105adf:	90                   	nop
    end_op();
80105ae0:	e8 eb d2 ff ff       	call   80102dd0 <end_op>
    return -1;
80105ae5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aea:	c9                   	leave  
80105aeb:	c3                   	ret    
80105aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105af0 <sys_chdir>:

int sys_chdir(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	56                   	push   %esi
80105af4:	53                   	push   %ebx
80105af5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105af8:	e8 33 df ff ff       	call   80103a30 <myproc>
80105afd:	89 c6                	mov    %eax,%esi

  begin_op();
80105aff:	e8 5c d2 ff ff       	call   80102d60 <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105b04:	83 ec 08             	sub    $0x8,%esp
80105b07:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b0a:	50                   	push   %eax
80105b0b:	6a 00                	push   $0x0
80105b0d:	e8 9e f5 ff ff       	call   801050b0 <argstr>
80105b12:	83 c4 10             	add    $0x10,%esp
80105b15:	85 c0                	test   %eax,%eax
80105b17:	78 77                	js     80105b90 <sys_chdir+0xa0>
80105b19:	83 ec 0c             	sub    $0xc,%esp
80105b1c:	ff 75 f4             	push   -0xc(%ebp)
80105b1f:	e8 7c c5 ff ff       	call   801020a0 <namei>
80105b24:	83 c4 10             	add    $0x10,%esp
80105b27:	89 c3                	mov    %eax,%ebx
80105b29:	85 c0                	test   %eax,%eax
80105b2b:	74 63                	je     80105b90 <sys_chdir+0xa0>
  {
    end_op();
    return -1;
  }
  ilock(ip);
80105b2d:	83 ec 0c             	sub    $0xc,%esp
80105b30:	50                   	push   %eax
80105b31:	e8 4a bc ff ff       	call   80101780 <ilock>
  if (ip->type != T_DIR)
80105b36:	83 c4 10             	add    $0x10,%esp
80105b39:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b3e:	75 30                	jne    80105b70 <sys_chdir+0x80>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b40:	83 ec 0c             	sub    $0xc,%esp
80105b43:	53                   	push   %ebx
80105b44:	e8 17 bd ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105b49:	58                   	pop    %eax
80105b4a:	ff 76 74             	push   0x74(%esi)
80105b4d:	e8 5e bd ff ff       	call   801018b0 <iput>
  end_op();
80105b52:	e8 79 d2 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80105b57:	89 5e 74             	mov    %ebx,0x74(%esi)
  return 0;
80105b5a:	83 c4 10             	add    $0x10,%esp
80105b5d:	31 c0                	xor    %eax,%eax
}
80105b5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b62:	5b                   	pop    %ebx
80105b63:	5e                   	pop    %esi
80105b64:	5d                   	pop    %ebp
80105b65:	c3                   	ret    
80105b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b6d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105b70:	83 ec 0c             	sub    $0xc,%esp
80105b73:	53                   	push   %ebx
80105b74:	e8 97 be ff ff       	call   80101a10 <iunlockput>
    end_op();
80105b79:	e8 52 d2 ff ff       	call   80102dd0 <end_op>
    return -1;
80105b7e:	83 c4 10             	add    $0x10,%esp
80105b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b86:	eb d7                	jmp    80105b5f <sys_chdir+0x6f>
80105b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8f:	90                   	nop
    end_op();
80105b90:	e8 3b d2 ff ff       	call   80102dd0 <end_op>
    return -1;
80105b95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9a:	eb c3                	jmp    80105b5f <sys_chdir+0x6f>
80105b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ba0 <sys_exec>:

int sys_exec(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	57                   	push   %edi
80105ba4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80105ba5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105bab:	53                   	push   %ebx
80105bac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80105bb2:	50                   	push   %eax
80105bb3:	6a 00                	push   $0x0
80105bb5:	e8 f6 f4 ff ff       	call   801050b0 <argstr>
80105bba:	83 c4 10             	add    $0x10,%esp
80105bbd:	85 c0                	test   %eax,%eax
80105bbf:	0f 88 87 00 00 00    	js     80105c4c <sys_exec+0xac>
80105bc5:	83 ec 08             	sub    $0x8,%esp
80105bc8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105bce:	50                   	push   %eax
80105bcf:	6a 01                	push   $0x1
80105bd1:	e8 ca f3 ff ff       	call   80104fa0 <argint>
80105bd6:	83 c4 10             	add    $0x10,%esp
80105bd9:	85 c0                	test   %eax,%eax
80105bdb:	78 6f                	js     80105c4c <sys_exec+0xac>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105bdd:	83 ec 04             	sub    $0x4,%esp
80105be0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for (i = 0;; i++)
80105be6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105be8:	68 80 00 00 00       	push   $0x80
80105bed:	6a 00                	push   $0x0
80105bef:	56                   	push   %esi
80105bf0:	e8 ab f0 ff ff       	call   80104ca0 <memset>
80105bf5:	83 c4 10             	add    $0x10,%esp
80105bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bff:	90                   	nop
  {
    if (i >= NELEM(argv))
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80105c00:	83 ec 08             	sub    $0x8,%esp
80105c03:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105c09:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105c10:	50                   	push   %eax
80105c11:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c17:	01 f8                	add    %edi,%eax
80105c19:	50                   	push   %eax
80105c1a:	e8 b1 f2 ff ff       	call   80104ed0 <fetchint>
80105c1f:	83 c4 10             	add    $0x10,%esp
80105c22:	85 c0                	test   %eax,%eax
80105c24:	78 26                	js     80105c4c <sys_exec+0xac>
      return -1;
    if (uarg == 0)
80105c26:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105c2c:	85 c0                	test   %eax,%eax
80105c2e:	74 30                	je     80105c60 <sys_exec+0xc0>
    {
      argv[i] = 0;
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
80105c30:	83 ec 08             	sub    $0x8,%esp
80105c33:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105c36:	52                   	push   %edx
80105c37:	50                   	push   %eax
80105c38:	e8 d3 f2 ff ff       	call   80104f10 <fetchstr>
80105c3d:	83 c4 10             	add    $0x10,%esp
80105c40:	85 c0                	test   %eax,%eax
80105c42:	78 08                	js     80105c4c <sys_exec+0xac>
  for (i = 0;; i++)
80105c44:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
80105c47:	83 fb 20             	cmp    $0x20,%ebx
80105c4a:	75 b4                	jne    80105c00 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c54:	5b                   	pop    %ebx
80105c55:	5e                   	pop    %esi
80105c56:	5f                   	pop    %edi
80105c57:	5d                   	pop    %ebp
80105c58:	c3                   	ret    
80105c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105c60:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c67:	00 00 00 00 
  return exec(path, argv);
80105c6b:	83 ec 08             	sub    $0x8,%esp
80105c6e:	56                   	push   %esi
80105c6f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105c75:	e8 36 ae ff ff       	call   80100ab0 <exec>
80105c7a:	83 c4 10             	add    $0x10,%esp
}
80105c7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c80:	5b                   	pop    %ebx
80105c81:	5e                   	pop    %esi
80105c82:	5f                   	pop    %edi
80105c83:	5d                   	pop    %ebp
80105c84:	c3                   	ret    
80105c85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c90 <sys_pipe>:

int sys_pipe(void)
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	57                   	push   %edi
80105c94:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80105c95:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c98:	53                   	push   %ebx
80105c99:	83 ec 20             	sub    $0x20,%esp
  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80105c9c:	6a 08                	push   $0x8
80105c9e:	50                   	push   %eax
80105c9f:	6a 00                	push   $0x0
80105ca1:	e8 9a f3 ff ff       	call   80105040 <argptr>
80105ca6:	83 c4 10             	add    $0x10,%esp
80105ca9:	85 c0                	test   %eax,%eax
80105cab:	78 4a                	js     80105cf7 <sys_pipe+0x67>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
80105cad:	83 ec 08             	sub    $0x8,%esp
80105cb0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105cb3:	50                   	push   %eax
80105cb4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105cb7:	50                   	push   %eax
80105cb8:	e8 73 d7 ff ff       	call   80103430 <pipealloc>
80105cbd:	83 c4 10             	add    $0x10,%esp
80105cc0:	85 c0                	test   %eax,%eax
80105cc2:	78 33                	js     80105cf7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80105cc4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (fd = 0; fd < NOFILE; fd++)
80105cc7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105cc9:	e8 62 dd ff ff       	call   80103a30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105cce:	66 90                	xchg   %ax,%ax
    if (curproc->ofile[fd] == 0)
80105cd0:	8b 74 98 34          	mov    0x34(%eax,%ebx,4),%esi
80105cd4:	85 f6                	test   %esi,%esi
80105cd6:	74 28                	je     80105d00 <sys_pipe+0x70>
  for (fd = 0; fd < NOFILE; fd++)
80105cd8:	83 c3 01             	add    $0x1,%ebx
80105cdb:	83 fb 10             	cmp    $0x10,%ebx
80105cde:	75 f0                	jne    80105cd0 <sys_pipe+0x40>
  {
    if (fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105ce0:	83 ec 0c             	sub    $0xc,%esp
80105ce3:	ff 75 e0             	push   -0x20(%ebp)
80105ce6:	e8 05 b2 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
80105ceb:	58                   	pop    %eax
80105cec:	ff 75 e4             	push   -0x1c(%ebp)
80105cef:	e8 fc b1 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105cf4:	83 c4 10             	add    $0x10,%esp
80105cf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cfc:	eb 53                	jmp    80105d51 <sys_pipe+0xc1>
80105cfe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105d00:	8d 73 0c             	lea    0xc(%ebx),%esi
80105d03:	89 7c b0 04          	mov    %edi,0x4(%eax,%esi,4)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80105d07:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105d0a:	e8 21 dd ff ff       	call   80103a30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105d0f:	31 d2                	xor    %edx,%edx
80105d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd] == 0)
80105d18:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
80105d1c:	85 c9                	test   %ecx,%ecx
80105d1e:	74 20                	je     80105d40 <sys_pipe+0xb0>
  for (fd = 0; fd < NOFILE; fd++)
80105d20:	83 c2 01             	add    $0x1,%edx
80105d23:	83 fa 10             	cmp    $0x10,%edx
80105d26:	75 f0                	jne    80105d18 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105d28:	e8 03 dd ff ff       	call   80103a30 <myproc>
80105d2d:	c7 44 b0 04 00 00 00 	movl   $0x0,0x4(%eax,%esi,4)
80105d34:	00 
80105d35:	eb a9                	jmp    80105ce0 <sys_pipe+0x50>
80105d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d3e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105d40:	89 7c 90 34          	mov    %edi,0x34(%eax,%edx,4)
  }
  fd[0] = fd0;
80105d44:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d47:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d49:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d4c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105d4f:	31 c0                	xor    %eax,%eax
}
80105d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d54:	5b                   	pop    %ebx
80105d55:	5e                   	pop    %esi
80105d56:	5f                   	pop    %edi
80105d57:	5d                   	pop    %ebp
80105d58:	c3                   	ret    
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d60 <sys_copy_file>:
}



int sys_copy_file(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	57                   	push   %edi
80105d64:	56                   	push   %esi
80105d65:	53                   	push   %ebx
80105d66:	81 ec 00 10 00 00    	sub    $0x1000,%esp
80105d6c:	83 0c 24 00          	orl    $0x0,(%esp)
80105d70:	83 ec 34             	sub    $0x34,%esp
  char *dest;
  int fd;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &src) < 0 || argstr(1, &dest) < 0)
80105d73:	8d 85 e0 ef ff ff    	lea    -0x1020(%ebp),%eax
80105d79:	50                   	push   %eax
80105d7a:	6a 00                	push   $0x0
80105d7c:	e8 2f f3 ff ff       	call   801050b0 <argstr>
80105d81:	83 c4 10             	add    $0x10,%esp
80105d84:	85 c0                	test   %eax,%eax
80105d86:	0f 88 81 01 00 00    	js     80105f0d <sys_copy_file+0x1ad>
80105d8c:	83 ec 08             	sub    $0x8,%esp
80105d8f:	8d 85 e4 ef ff ff    	lea    -0x101c(%ebp),%eax
80105d95:	50                   	push   %eax
80105d96:	6a 01                	push   $0x1
80105d98:	e8 13 f3 ff ff       	call   801050b0 <argstr>
80105d9d:	83 c4 10             	add    $0x10,%esp
80105da0:	85 c0                	test   %eax,%eax
80105da2:	0f 88 65 01 00 00    	js     80105f0d <sys_copy_file+0x1ad>
    return -1;

  begin_op();
80105da8:	e8 b3 cf ff ff       	call   80102d60 <begin_op>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(src)) == 0)
80105dad:	83 ec 0c             	sub    $0xc,%esp
80105db0:	ff b5 e0 ef ff ff    	push   -0x1020(%ebp)
80105db6:	e8 e5 c2 ff ff       	call   801020a0 <namei>
80105dbb:	83 c4 10             	add    $0x10,%esp
80105dbe:	89 c6                	mov    %eax,%esi
80105dc0:	85 c0                	test   %eax,%eax
80105dc2:	0f 84 c0 01 00 00    	je     80105f88 <sys_copy_file+0x228>
    {
      end_op();
      return -1;
    }
    ilock(ip);
80105dc8:	83 ec 0c             	sub    $0xc,%esp
80105dcb:	50                   	push   %eax
80105dcc:	e8 af b9 ff ff       	call   80101780 <ilock>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80105dd1:	e8 5a b0 ff ff       	call   80100e30 <filealloc>
80105dd6:	83 c4 10             	add    $0x10,%esp
80105dd9:	89 c7                	mov    %eax,%edi
80105ddb:	85 c0                	test   %eax,%eax
80105ddd:	74 2d                	je     80105e0c <sys_copy_file+0xac>
  struct proc *curproc = myproc();
80105ddf:	e8 4c dc ff ff       	call   80103a30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105de4:	31 d2                	xor    %edx,%edx
80105de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ded:	8d 76 00             	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
80105df0:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
80105df4:	85 c9                	test   %ecx,%ecx
80105df6:	74 38                	je     80105e30 <sys_copy_file+0xd0>
  for (fd = 0; fd < NOFILE; fd++)
80105df8:	83 c2 01             	add    $0x1,%edx
80105dfb:	83 fa 10             	cmp    $0x10,%edx
80105dfe:	75 f0                	jne    80105df0 <sys_copy_file+0x90>
  {
    if (f)
      fileclose(f);
80105e00:	83 ec 0c             	sub    $0xc,%esp
80105e03:	57                   	push   %edi
80105e04:	e8 e7 b0 ff ff       	call   80100ef0 <fileclose>
80105e09:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105e0c:	83 ec 0c             	sub    $0xc,%esp
80105e0f:	56                   	push   %esi
80105e10:	e8 fb bb ff ff       	call   80101a10 <iunlockput>
    end_op();
80105e15:	e8 b6 cf ff ff       	call   80102dd0 <end_op>
    return -1;
80105e1a:	83 c4 10             	add    $0x10,%esp
80105e1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e22:	e9 59 01 00 00       	jmp    80105f80 <sys_copy_file+0x220>
80105e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e2e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e30:	8d 5a 0c             	lea    0xc(%edx),%ebx
  }
  iunlock(ip);
80105e33:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105e36:	89 7c 98 04          	mov    %edi,0x4(%eax,%ebx,4)
  iunlock(ip);
80105e3a:	56                   	push   %esi
80105e3b:	e8 20 ba ff ff       	call   80101860 <iunlock>
  end_op();
80105e40:	e8 8b cf ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(O_RDONLY & O_WRONLY);
80105e45:	b8 01 00 00 00       	mov    $0x1,%eax
  f->ip = ip;
80105e4a:	89 77 10             	mov    %esi,0x10(%edi)
  f->type = FD_INODE;
80105e4d:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->off = 0;
80105e53:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(O_RDONLY & O_WRONLY);
80105e5a:	66 89 47 08          	mov    %ax,0x8(%edi)
  if((f = myproc() -> ofile[fd]) == 0){
80105e5e:	e8 cd db ff ff       	call   80103a30 <myproc>
80105e63:	83 c4 10             	add    $0x10,%esp
80105e66:	8b 44 98 04          	mov    0x4(%eax,%ebx,4),%eax
80105e6a:	85 c0                	test   %eax,%eax
80105e6c:	0f 84 9b 00 00 00    	je     80105f0d <sys_copy_file+0x1ad>
  f->writable = (O_RDONLY & O_WRONLY) || (O_RDONLY & O_RDWR);
  
  char p[4096];
  if (my_argfd(0, 0, &f, fd) < 0)
      return -1;
  int read_chars = fileread(f, p, 4096);
80105e72:	83 ec 04             	sub    $0x4,%esp
80105e75:	8d bd e8 ef ff ff    	lea    -0x1018(%ebp),%edi
80105e7b:	68 00 10 00 00       	push   $0x1000
80105e80:	57                   	push   %edi
80105e81:	50                   	push   %eax
80105e82:	e8 99 b1 ff ff       	call   80101020 <fileread>
80105e87:	89 85 d4 ef ff ff    	mov    %eax,-0x102c(%ebp)
  //dest
  int fd2;
  struct file *f2;
  struct inode *ip2;
  begin_op();
80105e8d:	e8 ce ce ff ff       	call   80102d60 <begin_op>
      return -1;
    }
  }
  else
  {
    if ((ip2 = namei(dest)) == 0)
80105e92:	58                   	pop    %eax
80105e93:	ff b5 e4 ef ff ff    	push   -0x101c(%ebp)
80105e99:	e8 02 c2 ff ff       	call   801020a0 <namei>
80105e9e:	83 c4 10             	add    $0x10,%esp
80105ea1:	89 c3                	mov    %eax,%ebx
80105ea3:	85 c0                	test   %eax,%eax
80105ea5:	0f 84 dd 00 00 00    	je     80105f88 <sys_copy_file+0x228>
    {
      end_op();
      return -1;
    }
    ilock(ip2);
80105eab:	83 ec 0c             	sub    $0xc,%esp
80105eae:	50                   	push   %eax
80105eaf:	e8 cc b8 ff ff       	call   80101780 <ilock>
    if (ip2->type == T_DIR && dest != O_RDONLY)
80105eb4:	83 c4 10             	add    $0x10,%esp
80105eb7:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ebc:	75 0a                	jne    80105ec8 <sys_copy_file+0x168>
80105ebe:	8b b5 e4 ef ff ff    	mov    -0x101c(%ebp),%esi
80105ec4:	85 f6                	test   %esi,%esi
80105ec6:	75 34                	jne    80105efc <sys_copy_file+0x19c>
      end_op();
      return -1;
    }
  }

  if ((f2 = filealloc()) == 0 || (fd2 = fdalloc(f2)) < 0)
80105ec8:	e8 63 af ff ff       	call   80100e30 <filealloc>
80105ecd:	89 c6                	mov    %eax,%esi
80105ecf:	85 c0                	test   %eax,%eax
80105ed1:	74 29                	je     80105efc <sys_copy_file+0x19c>
  struct proc *curproc = myproc();
80105ed3:	e8 58 db ff ff       	call   80103a30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105ed8:	31 d2                	xor    %edx,%edx
80105eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
80105ee0:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
80105ee4:	85 c9                	test   %ecx,%ecx
80105ee6:	74 30                	je     80105f18 <sys_copy_file+0x1b8>
  for (fd = 0; fd < NOFILE; fd++)
80105ee8:	83 c2 01             	add    $0x1,%edx
80105eeb:	83 fa 10             	cmp    $0x10,%edx
80105eee:	75 f0                	jne    80105ee0 <sys_copy_file+0x180>
  {
    if (f2)
      fileclose(f2);
80105ef0:	83 ec 0c             	sub    $0xc,%esp
80105ef3:	56                   	push   %esi
80105ef4:	e8 f7 af ff ff       	call   80100ef0 <fileclose>
80105ef9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip2);
80105efc:	83 ec 0c             	sub    $0xc,%esp
80105eff:	53                   	push   %ebx
80105f00:	e8 0b bb ff ff       	call   80101a10 <iunlockput>
    end_op();
80105f05:	e8 c6 ce ff ff       	call   80102dd0 <end_op>
    return -1;
80105f0a:	83 c4 10             	add    $0x10,%esp
80105f0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f12:	eb 6c                	jmp    80105f80 <sys_copy_file+0x220>
80105f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105f18:	83 c2 0c             	add    $0xc,%edx
  }
  iunlock(ip2);
80105f1b:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105f1e:	89 74 90 04          	mov    %esi,0x4(%eax,%edx,4)
  iunlock(ip2);
80105f22:	53                   	push   %ebx
      curproc->ofile[fd] = f;
80105f23:	89 95 d0 ef ff ff    	mov    %edx,-0x1030(%ebp)
  iunlock(ip2);
80105f29:	e8 32 b9 ff ff       	call   80101860 <iunlock>
  end_op();
80105f2e:	e8 9d ce ff ff       	call   80102dd0 <end_op>

  f2->type = FD_INODE;
  f2->ip = ip2;
  f2->off = 0;
  f2->readable = !(O_WRONLY & O_WRONLY);
80105f33:	b8 00 01 00 00       	mov    $0x100,%eax
  f2->ip = ip2;
80105f38:	89 5e 10             	mov    %ebx,0x10(%esi)
  f2->type = FD_INODE;
80105f3b:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f2->off = 0;
80105f41:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f2->readable = !(O_WRONLY & O_WRONLY);
80105f48:	66 89 46 08          	mov    %ax,0x8(%esi)
  if((f = myproc() -> ofile[fd]) == 0){
80105f4c:	e8 df da ff ff       	call   80103a30 <myproc>
80105f51:	8b 95 d0 ef ff ff    	mov    -0x1030(%ebp),%edx
80105f57:	83 c4 10             	add    $0x10,%esp
80105f5a:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80105f5e:	85 c0                	test   %eax,%eax
80105f60:	74 ab                	je     80105f0d <sys_copy_file+0x1ad>
  f2->writable = (O_WRONLY & O_WRONLY) || (O_WRONLY & O_RDWR);
  if (my_argfd(0, 0, &f2, fd2) < 0)
      return -1;   
  int written_chars = filewrite(f2, p, read_chars);
80105f62:	8b 9d d4 ef ff ff    	mov    -0x102c(%ebp),%ebx
80105f68:	83 ec 04             	sub    $0x4,%esp
80105f6b:	53                   	push   %ebx
80105f6c:	57                   	push   %edi
80105f6d:	50                   	push   %eax
80105f6e:	e8 3d b1 ff ff       	call   801010b0 <filewrite>
  if(written_chars != read_chars){
80105f73:	83 c4 10             	add    $0x10,%esp
80105f76:	39 c3                	cmp    %eax,%ebx
80105f78:	0f 95 c0             	setne  %al
80105f7b:	0f b6 c0             	movzbl %al,%eax
80105f7e:	f7 d8                	neg    %eax
    return -1;
  }
  else{
    return 0;
  }
80105f80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f83:	5b                   	pop    %ebx
80105f84:	5e                   	pop    %esi
80105f85:	5f                   	pop    %edi
80105f86:	5d                   	pop    %ebp
80105f87:	c3                   	ret    
      end_op();
80105f88:	e8 43 ce ff ff       	call   80102dd0 <end_op>
      return -1;
80105f8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f92:	eb ec                	jmp    80105f80 <sys_copy_file+0x220>
80105f94:	66 90                	xchg   %ax,%ax
80105f96:	66 90                	xchg   %ax,%ax
80105f98:	66 90                	xchg   %ax,%ax
80105f9a:	66 90                	xchg   %ax,%ax
80105f9c:	66 90                	xchg   %ax,%ax
80105f9e:	66 90                	xchg   %ax,%ax

80105fa0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int sys_fork(void)
{
  return fork();
80105fa0:	e9 3b df ff ff       	jmp    80103ee0 <fork>
80105fa5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fb0 <sys_exit>:
}

int sys_exit(void)
{
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105fb6:	e8 c5 e3 ff ff       	call   80104380 <exit>
  return 0; // not reached
}
80105fbb:	31 c0                	xor    %eax,%eax
80105fbd:	c9                   	leave  
80105fbe:	c3                   	ret    
80105fbf:	90                   	nop

80105fc0 <sys_wait>:

int sys_wait(void)
{
  return wait();
80105fc0:	e9 eb e4 ff ff       	jmp    801044b0 <wait>
80105fc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fd0 <sys_kill>:
}

int sys_kill(void)
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80105fd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fd9:	50                   	push   %eax
80105fda:	6a 00                	push   $0x0
80105fdc:	e8 bf ef ff ff       	call   80104fa0 <argint>
80105fe1:	83 c4 10             	add    $0x10,%esp
80105fe4:	85 c0                	test   %eax,%eax
80105fe6:	78 18                	js     80106000 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105fe8:	83 ec 0c             	sub    $0xc,%esp
80105feb:	ff 75 f4             	push   -0xc(%ebp)
80105fee:	e8 5d e7 ff ff       	call   80104750 <kill>
80105ff3:	83 c4 10             	add    $0x10,%esp
}
80105ff6:	c9                   	leave  
80105ff7:	c3                   	ret    
80105ff8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fff:	90                   	nop
80106000:	c9                   	leave  
    return -1;
80106001:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106006:	c3                   	ret    
80106007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010600e:	66 90                	xchg   %ax,%ax

80106010 <sys_getpid>:

int sys_getpid(void)
{
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106016:	e8 15 da ff ff       	call   80103a30 <myproc>
8010601b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010601e:	c9                   	leave  
8010601f:	c3                   	ret    

80106020 <sys_sbrk>:

int sys_sbrk(void)
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	53                   	push   %ebx
  int addr;
  int n;

  if (argint(0, &n) < 0)
80106024:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106027:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
8010602a:	50                   	push   %eax
8010602b:	6a 00                	push   $0x0
8010602d:	e8 6e ef ff ff       	call   80104fa0 <argint>
80106032:	83 c4 10             	add    $0x10,%esp
80106035:	85 c0                	test   %eax,%eax
80106037:	78 27                	js     80106060 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106039:	e8 f2 d9 ff ff       	call   80103a30 <myproc>
  if (growproc(n) < 0)
8010603e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106041:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80106043:	ff 75 f4             	push   -0xc(%ebp)
80106046:	e8 15 de ff ff       	call   80103e60 <growproc>
8010604b:	83 c4 10             	add    $0x10,%esp
8010604e:	85 c0                	test   %eax,%eax
80106050:	78 0e                	js     80106060 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106052:	89 d8                	mov    %ebx,%eax
80106054:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106057:	c9                   	leave  
80106058:	c3                   	ret    
80106059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106060:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106065:	eb eb                	jmp    80106052 <sys_sbrk+0x32>
80106067:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010606e:	66 90                	xchg   %ax,%ax

80106070 <sys_sleep>:

int sys_sleep(void)
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	53                   	push   %ebx
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80106074:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106077:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
8010607a:	50                   	push   %eax
8010607b:	6a 00                	push   $0x0
8010607d:	e8 1e ef ff ff       	call   80104fa0 <argint>
80106082:	83 c4 10             	add    $0x10,%esp
80106085:	85 c0                	test   %eax,%eax
80106087:	0f 88 8a 00 00 00    	js     80106117 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010608d:	83 ec 0c             	sub    $0xc,%esp
80106090:	68 80 55 11 80       	push   $0x80115580
80106095:	e8 46 eb ff ff       	call   80104be0 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
8010609a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010609d:	8b 1d 60 55 11 80    	mov    0x80115560,%ebx
  while (ticks - ticks0 < n)
801060a3:	83 c4 10             	add    $0x10,%esp
801060a6:	85 d2                	test   %edx,%edx
801060a8:	75 27                	jne    801060d1 <sys_sleep+0x61>
801060aa:	eb 54                	jmp    80106100 <sys_sleep+0x90>
801060ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801060b0:	83 ec 08             	sub    $0x8,%esp
801060b3:	68 80 55 11 80       	push   $0x80115580
801060b8:	68 60 55 11 80       	push   $0x80115560
801060bd:	e8 6e e5 ff ff       	call   80104630 <sleep>
  while (ticks - ticks0 < n)
801060c2:	a1 60 55 11 80       	mov    0x80115560,%eax
801060c7:	83 c4 10             	add    $0x10,%esp
801060ca:	29 d8                	sub    %ebx,%eax
801060cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801060cf:	73 2f                	jae    80106100 <sys_sleep+0x90>
    if (myproc()->killed)
801060d1:	e8 5a d9 ff ff       	call   80103a30 <myproc>
801060d6:	8b 40 30             	mov    0x30(%eax),%eax
801060d9:	85 c0                	test   %eax,%eax
801060db:	74 d3                	je     801060b0 <sys_sleep+0x40>
      release(&tickslock);
801060dd:	83 ec 0c             	sub    $0xc,%esp
801060e0:	68 80 55 11 80       	push   $0x80115580
801060e5:	e8 96 ea ff ff       	call   80104b80 <release>
  }
  release(&tickslock);
  return 0;
}
801060ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801060ed:	83 c4 10             	add    $0x10,%esp
801060f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060f5:	c9                   	leave  
801060f6:	c3                   	ret    
801060f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060fe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106100:	83 ec 0c             	sub    $0xc,%esp
80106103:	68 80 55 11 80       	push   $0x80115580
80106108:	e8 73 ea ff ff       	call   80104b80 <release>
  return 0;
8010610d:	83 c4 10             	add    $0x10,%esp
80106110:	31 c0                	xor    %eax,%eax
}
80106112:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106115:	c9                   	leave  
80106116:	c3                   	ret    
    return -1;
80106117:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010611c:	eb f4                	jmp    80106112 <sys_sleep+0xa2>
8010611e:	66 90                	xchg   %ax,%ax

80106120 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	53                   	push   %ebx
80106124:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106127:	68 80 55 11 80       	push   $0x80115580
8010612c:	e8 af ea ff ff       	call   80104be0 <acquire>
  xticks = ticks;
80106131:	8b 1d 60 55 11 80    	mov    0x80115560,%ebx
  release(&tickslock);
80106137:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)
8010613e:	e8 3d ea ff ff       	call   80104b80 <release>
  return xticks;
}
80106143:	89 d8                	mov    %ebx,%eax
80106145:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106148:	c9                   	leave  
80106149:	c3                   	ret    
8010614a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106150 <sys_find_digital_root>:

int sys_find_digital_root(void)
{
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	83 ec 08             	sub    $0x8,%esp
  int number = myproc()->tf->ebx; // register after eax
80106156:	e8 d5 d8 ff ff       	call   80103a30 <myproc>
  return find_digital_root(number);
8010615b:	83 ec 0c             	sub    $0xc,%esp
  int number = myproc()->tf->ebx; // register after eax
8010615e:	8b 40 18             	mov    0x18(%eax),%eax
  return find_digital_root(number);
80106161:	ff 70 10             	push   0x10(%eax)
80106164:	e8 27 e7 ff ff       	call   80104890 <find_digital_root>
}
80106169:	c9                   	leave  
8010616a:	c3                   	ret    
8010616b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010616f:	90                   	nop

80106170 <sys_get_uncle_count>:

int sys_get_uncle_count(void)
{
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80106176:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106179:	50                   	push   %eax
8010617a:	6a 00                	push   $0x0
8010617c:	e8 1f ee ff ff       	call   80104fa0 <argint>
80106181:	83 c4 10             	add    $0x10,%esp
80106184:	85 c0                	test   %eax,%eax
80106186:	78 28                	js     801061b0 <sys_get_uncle_count+0x40>
  {
    return -1;
  }
  struct proc *grandFather = find_proc(pid)->parent->parent;
80106188:	83 ec 0c             	sub    $0xc,%esp
8010618b:	ff 75 f4             	push   -0xc(%ebp)
8010618e:	e8 1d da ff ff       	call   80103bb0 <find_proc>
  return count_child(grandFather) - 1;
80106193:	5a                   	pop    %edx
  struct proc *grandFather = find_proc(pid)->parent->parent;
80106194:	8b 40 14             	mov    0x14(%eax),%eax
  return count_child(grandFather) - 1;
80106197:	ff 70 14             	push   0x14(%eax)
8010619a:	e8 61 dc ff ff       	call   80103e00 <count_child>
8010619f:	83 c4 10             	add    $0x10,%esp
}
801061a2:	c9                   	leave  
  return count_child(grandFather) - 1;
801061a3:	83 e8 01             	sub    $0x1,%eax
}
801061a6:	c3                   	ret    
801061a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ae:	66 90                	xchg   %ax,%ax
801061b0:	c9                   	leave  
    return -1;
801061b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061b6:	c3                   	ret    
801061b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061be:	66 90                	xchg   %ax,%ax

801061c0 <sys_get_process_lifetime>:
int sys_get_process_lifetime(void)
{
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
801061c3:	53                   	push   %ebx
  int pid;
  if (argint(0, &pid) < 0)
801061c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801061c7:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0)
801061ca:	50                   	push   %eax
801061cb:	6a 00                	push   $0x0
801061cd:	e8 ce ed ff ff       	call   80104fa0 <argint>
801061d2:	83 c4 10             	add    $0x10,%esp
801061d5:	85 c0                	test   %eax,%eax
801061d7:	78 27                	js     80106200 <sys_get_process_lifetime+0x40>
  {
    return -1;
  }
  return ticks - (find_proc(pid)->creation_time);
801061d9:	83 ec 0c             	sub    $0xc,%esp
801061dc:	ff 75 f4             	push   -0xc(%ebp)
801061df:	8b 1d 60 55 11 80    	mov    0x80115560,%ebx
801061e5:	e8 c6 d9 ff ff       	call   80103bb0 <find_proc>
801061ea:	83 c4 10             	add    $0x10,%esp
801061ed:	2b 58 20             	sub    0x20(%eax),%ebx
801061f0:	89 d8                	mov    %ebx,%eax
}
801061f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061f5:	c9                   	leave  
801061f6:	c3                   	ret    
801061f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061fe:	66 90                	xchg   %ax,%ax
    return -1;
80106200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106205:	eb eb                	jmp    801061f2 <sys_get_process_lifetime+0x32>
80106207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620e:	66 90                	xchg   %ax,%ax

80106210 <sys_set_date>:
void sys_set_date(void)
{
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *r;
  if (argptr(0, (void *)&r, sizeof(*r)) < 0)
80106216:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106219:	6a 18                	push   $0x18
8010621b:	50                   	push   %eax
8010621c:	6a 00                	push   $0x0
8010621e:	e8 1d ee ff ff       	call   80105040 <argptr>
80106223:	83 c4 10             	add    $0x10,%esp
80106226:	85 c0                	test   %eax,%eax
80106228:	78 16                	js     80106240 <sys_set_date+0x30>
    cprintf("Kernel: sys_set_date() has a problem.\n");

  cmostime(r);
8010622a:	83 ec 0c             	sub    $0xc,%esp
8010622d:	ff 75 f4             	push   -0xc(%ebp)
80106230:	e8 9b c7 ff ff       	call   801029d0 <cmostime>
}
80106235:	83 c4 10             	add    $0x10,%esp
80106238:	c9                   	leave  
80106239:	c3                   	ret    
8010623a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("Kernel: sys_set_date() has a problem.\n");
80106240:	83 ec 0c             	sub    $0xc,%esp
80106243:	68 48 86 10 80       	push   $0x80108648
80106248:	e8 53 a4 ff ff       	call   801006a0 <cprintf>
8010624d:	83 c4 10             	add    $0x10,%esp
  cmostime(r);
80106250:	83 ec 0c             	sub    $0xc,%esp
80106253:	ff 75 f4             	push   -0xc(%ebp)
80106256:	e8 75 c7 ff ff       	call   801029d0 <cmostime>
}
8010625b:	83 c4 10             	add    $0x10,%esp
8010625e:	c9                   	leave  
8010625f:	c3                   	ret    

80106260 <sys_get_pid>:
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	83 ec 08             	sub    $0x8,%esp
80106266:	e8 c5 d7 ff ff       	call   80103a30 <myproc>
8010626b:	8b 40 10             	mov    0x10(%eax),%eax
8010626e:	c9                   	leave  
8010626f:	c3                   	ret    

80106270 <sys_get_parent>:
int sys_get_pid(void)
{
  return myproc()->pid;
}
int sys_get_parent(void)
{
80106270:	55                   	push   %ebp
80106271:	89 e5                	mov    %esp,%ebp
80106273:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
80106276:	e8 b5 d7 ff ff       	call   80103a30 <myproc>
8010627b:	8b 40 14             	mov    0x14(%eax),%eax
8010627e:	8b 40 10             	mov    0x10(%eax),%eax
}
80106281:	c9                   	leave  
80106282:	c3                   	ret    
80106283:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010628a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106290 <sys_change_queue>:
int sys_change_queue(void)
{
80106290:	55                   	push   %ebp
80106291:	89 e5                	mov    %esp,%ebp
80106293:	53                   	push   %ebx
  int pid, que_id;
  if (argint(0, &pid) < 0 || argint(1, &que_id))
80106294:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
80106297:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0 || argint(1, &que_id))
8010629a:	50                   	push   %eax
8010629b:	6a 00                	push   $0x0
8010629d:	e8 fe ec ff ff       	call   80104fa0 <argint>
801062a2:	83 c4 10             	add    $0x10,%esp
801062a5:	85 c0                	test   %eax,%eax
801062a7:	78 47                	js     801062f0 <sys_change_queue+0x60>
801062a9:	83 ec 08             	sub    $0x8,%esp
801062ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062af:	50                   	push   %eax
801062b0:	6a 01                	push   $0x1
801062b2:	e8 e9 ec ff ff       	call   80104fa0 <argint>
801062b7:	83 c4 10             	add    $0x10,%esp
801062ba:	89 c3                	mov    %eax,%ebx
801062bc:	85 c0                	test   %eax,%eax
801062be:	75 30                	jne    801062f0 <sys_change_queue+0x60>
    return -1;
  cprintf("%d\n", pid);
801062c0:	83 ec 08             	sub    $0x8,%esp
801062c3:	ff 75 f0             	push   -0x10(%ebp)
801062c6:	68 b4 82 10 80       	push   $0x801082b4
801062cb:	e8 d0 a3 ff ff       	call   801006a0 <cprintf>
  struct proc *p = find_proc(pid);
801062d0:	58                   	pop    %eax
801062d1:	ff 75 f0             	push   -0x10(%ebp)
801062d4:	e8 d7 d8 ff ff       	call   80103bb0 <find_proc>
  p->que_id = que_id;
801062d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  return 0;
801062dc:	83 c4 10             	add    $0x10,%esp
  p->que_id = que_id;
801062df:	89 50 28             	mov    %edx,0x28(%eax)
}
801062e2:	89 d8                	mov    %ebx,%eax
801062e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062e7:	c9                   	leave  
801062e8:	c3                   	ret    
801062e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801062f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801062f5:	eb eb                	jmp    801062e2 <sys_change_queue+0x52>
801062f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062fe:	66 90                	xchg   %ax,%ax

80106300 <sys_bjf_validation_process>:
int sys_bjf_validation_process(void)
{
80106300:	55                   	push   %ebp
80106301:	89 e5                	mov    %esp,%ebp
80106303:	83 ec 30             	sub    $0x30,%esp
  
  int pid;
  float priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argint(0, &pid) < 0 || argf(1, &priority_ratio) < 0 || argf(2, &creation_time_ratio) < 0 || argf(3, &exec_cycle_ratio) < 0 || argf(4, &size_ratio) < 0)
80106306:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106309:	50                   	push   %eax
8010630a:	6a 00                	push   $0x0
8010630c:	e8 8f ec ff ff       	call   80104fa0 <argint>
80106311:	83 c4 10             	add    $0x10,%esp
80106314:	85 c0                	test   %eax,%eax
80106316:	0f 88 94 00 00 00    	js     801063b0 <sys_bjf_validation_process+0xb0>
8010631c:	83 ec 08             	sub    $0x8,%esp
8010631f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106322:	50                   	push   %eax
80106323:	6a 01                	push   $0x1
80106325:	e8 c6 ec ff ff       	call   80104ff0 <argf>
8010632a:	83 c4 10             	add    $0x10,%esp
8010632d:	85 c0                	test   %eax,%eax
8010632f:	78 7f                	js     801063b0 <sys_bjf_validation_process+0xb0>
80106331:	83 ec 08             	sub    $0x8,%esp
80106334:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106337:	50                   	push   %eax
80106338:	6a 02                	push   $0x2
8010633a:	e8 b1 ec ff ff       	call   80104ff0 <argf>
8010633f:	83 c4 10             	add    $0x10,%esp
80106342:	85 c0                	test   %eax,%eax
80106344:	78 6a                	js     801063b0 <sys_bjf_validation_process+0xb0>
80106346:	83 ec 08             	sub    $0x8,%esp
80106349:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010634c:	50                   	push   %eax
8010634d:	6a 03                	push   $0x3
8010634f:	e8 9c ec ff ff       	call   80104ff0 <argf>
80106354:	83 c4 10             	add    $0x10,%esp
80106357:	85 c0                	test   %eax,%eax
80106359:	78 55                	js     801063b0 <sys_bjf_validation_process+0xb0>
8010635b:	83 ec 08             	sub    $0x8,%esp
8010635e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106361:	50                   	push   %eax
80106362:	6a 04                	push   $0x4
80106364:	e8 87 ec ff ff       	call   80104ff0 <argf>
80106369:	83 c4 10             	add    $0x10,%esp
8010636c:	85 c0                	test   %eax,%eax
8010636e:	78 40                	js     801063b0 <sys_bjf_validation_process+0xb0>
  {
    return -1;
  }
  struct proc *p = find_proc(pid);
80106370:	83 ec 0c             	sub    $0xc,%esp
80106373:	ff 75 e4             	push   -0x1c(%ebp)
80106376:	e8 35 d8 ff ff       	call   80103bb0 <find_proc>
  p->priority_ratio = priority_ratio;
8010637b:	d9 45 e8             	flds   -0x18(%ebp)
  p->creation_time_ratio = creation_time_ratio;
  p->executed_cycle_ratio = exec_cycle_ratio;
  p->process_size_ratio = size_ratio;

  return 0;
8010637e:	83 c4 10             	add    $0x10,%esp
  p->priority_ratio = priority_ratio;
80106381:	d9 98 8c 00 00 00    	fstps  0x8c(%eax)
  p->creation_time_ratio = creation_time_ratio;
80106387:	d9 45 ec             	flds   -0x14(%ebp)
8010638a:	d9 98 90 00 00 00    	fstps  0x90(%eax)
  p->executed_cycle_ratio = exec_cycle_ratio;
80106390:	d9 45 f0             	flds   -0x10(%ebp)
80106393:	d9 98 98 00 00 00    	fstps  0x98(%eax)
  p->process_size_ratio = size_ratio;
80106399:	d9 45 f4             	flds   -0xc(%ebp)
8010639c:	d9 98 9c 00 00 00    	fstps  0x9c(%eax)
  return 0;
801063a2:	31 c0                	xor    %eax,%eax
}
801063a4:	c9                   	leave  
801063a5:	c3                   	ret    
801063a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063ad:	8d 76 00             	lea    0x0(%esi),%esi
801063b0:	c9                   	leave  
    return -1;
801063b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063b6:	c3                   	ret    
801063b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063be:	66 90                	xchg   %ax,%ax

801063c0 <sys_bjf_validation_system>:
int sys_bjf_validation_system(void)
{
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	83 ec 20             	sub    $0x20,%esp
  float priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argf(0, &priority_ratio) < 0 || argf(1, &creation_time_ratio) < 0 || argf(2, &exec_cycle_ratio) < 0 || argf(3, &size_ratio) < 0)
801063c6:	8d 45 e8             	lea    -0x18(%ebp),%eax
801063c9:	50                   	push   %eax
801063ca:	6a 00                	push   $0x0
801063cc:	e8 1f ec ff ff       	call   80104ff0 <argf>
801063d1:	83 c4 10             	add    $0x10,%esp
801063d4:	85 c0                	test   %eax,%eax
801063d6:	78 70                	js     80106448 <sys_bjf_validation_system+0x88>
801063d8:	83 ec 08             	sub    $0x8,%esp
801063db:	8d 45 ec             	lea    -0x14(%ebp),%eax
801063de:	50                   	push   %eax
801063df:	6a 01                	push   $0x1
801063e1:	e8 0a ec ff ff       	call   80104ff0 <argf>
801063e6:	83 c4 10             	add    $0x10,%esp
801063e9:	85 c0                	test   %eax,%eax
801063eb:	78 5b                	js     80106448 <sys_bjf_validation_system+0x88>
801063ed:	83 ec 08             	sub    $0x8,%esp
801063f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063f3:	50                   	push   %eax
801063f4:	6a 02                	push   $0x2
801063f6:	e8 f5 eb ff ff       	call   80104ff0 <argf>
801063fb:	83 c4 10             	add    $0x10,%esp
801063fe:	85 c0                	test   %eax,%eax
80106400:	78 46                	js     80106448 <sys_bjf_validation_system+0x88>
80106402:	83 ec 08             	sub    $0x8,%esp
80106405:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106408:	50                   	push   %eax
80106409:	6a 03                	push   $0x3
8010640b:	e8 e0 eb ff ff       	call   80104ff0 <argf>
80106410:	83 c4 10             	add    $0x10,%esp
80106413:	85 c0                	test   %eax,%eax
80106415:	78 31                	js     80106448 <sys_bjf_validation_system+0x88>
  {
    return -1;
  }
  cprintf("%d\n", priority_ratio);
80106417:	d9 45 e8             	flds   -0x18(%ebp)
8010641a:	83 ec 0c             	sub    $0xc,%esp
8010641d:	dd 1c 24             	fstpl  (%esp)
80106420:	68 b4 82 10 80       	push   $0x801082b4
80106425:	e8 76 a2 ff ff       	call   801006a0 <cprintf>
  reset_bjf_attributes(priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio);
8010642a:	ff 75 f4             	push   -0xc(%ebp)
8010642d:	ff 75 f0             	push   -0x10(%ebp)
80106430:	ff 75 ec             	push   -0x14(%ebp)
80106433:	ff 75 e8             	push   -0x18(%ebp)
80106436:	e8 75 d5 ff ff       	call   801039b0 <reset_bjf_attributes>
  return 0;
8010643b:	83 c4 20             	add    $0x20,%esp
8010643e:	31 c0                	xor    %eax,%eax
}
80106440:	c9                   	leave  
80106441:	c3                   	ret    
80106442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106448:	c9                   	leave  
    return -1;
80106449:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010644e:	c3                   	ret    
8010644f:	90                   	nop

80106450 <sys_print_info>:
int sys_print_info(void)
{
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
80106453:	83 ec 08             	sub    $0x8,%esp
  print_bitches();
80106456:	e8 35 d8 ff ff       	call   80103c90 <print_bitches>
  return 0;
8010645b:	31 c0                	xor    %eax,%eax
8010645d:	c9                   	leave  
8010645e:	c3                   	ret    

8010645f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010645f:	1e                   	push   %ds
  pushl %es
80106460:	06                   	push   %es
  pushl %fs
80106461:	0f a0                	push   %fs
  pushl %gs
80106463:	0f a8                	push   %gs
  pushal
80106465:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106466:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010646a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010646c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010646e:	54                   	push   %esp
  call trap
8010646f:	e8 cc 00 00 00       	call   80106540 <trap>
  addl $4, %esp
80106474:	83 c4 04             	add    $0x4,%esp

80106477 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106477:	61                   	popa   
  popl %gs
80106478:	0f a9                	pop    %gs
  popl %fs
8010647a:	0f a1                	pop    %fs
  popl %es
8010647c:	07                   	pop    %es
  popl %ds
8010647d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010647e:	83 c4 08             	add    $0x8,%esp
  iret
80106481:	cf                   	iret   
80106482:	66 90                	xchg   %ax,%ax
80106484:	66 90                	xchg   %ax,%ax
80106486:	66 90                	xchg   %ax,%ax
80106488:	66 90                	xchg   %ax,%ax
8010648a:	66 90                	xchg   %ax,%ax
8010648c:	66 90                	xchg   %ax,%ax
8010648e:	66 90                	xchg   %ax,%ax

80106490 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106490:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106491:	31 c0                	xor    %eax,%eax
{
80106493:	89 e5                	mov    %esp,%ebp
80106495:	83 ec 08             	sub    $0x8,%esp
80106498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010649f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801064a0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801064a7:	c7 04 c5 c2 55 11 80 	movl   $0x8e000008,-0x7feeaa3e(,%eax,8)
801064ae:	08 00 00 8e 
801064b2:	66 89 14 c5 c0 55 11 	mov    %dx,-0x7feeaa40(,%eax,8)
801064b9:	80 
801064ba:	c1 ea 10             	shr    $0x10,%edx
801064bd:	66 89 14 c5 c6 55 11 	mov    %dx,-0x7feeaa3a(,%eax,8)
801064c4:	80 
  for(i = 0; i < 256; i++)
801064c5:	83 c0 01             	add    $0x1,%eax
801064c8:	3d 00 01 00 00       	cmp    $0x100,%eax
801064cd:	75 d1                	jne    801064a0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801064cf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801064d2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801064d7:	c7 05 c2 57 11 80 08 	movl   $0xef000008,0x801157c2
801064de:	00 00 ef 
  initlock(&tickslock, "time");
801064e1:	68 6f 86 10 80       	push   $0x8010866f
801064e6:	68 80 55 11 80       	push   $0x80115580
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801064eb:	66 a3 c0 57 11 80    	mov    %ax,0x801157c0
801064f1:	c1 e8 10             	shr    $0x10,%eax
801064f4:	66 a3 c6 57 11 80    	mov    %ax,0x801157c6
  initlock(&tickslock, "time");
801064fa:	e8 11 e5 ff ff       	call   80104a10 <initlock>
}
801064ff:	83 c4 10             	add    $0x10,%esp
80106502:	c9                   	leave  
80106503:	c3                   	ret    
80106504:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010650b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010650f:	90                   	nop

80106510 <idtinit>:

void
idtinit(void)
{
80106510:	55                   	push   %ebp
  pd[0] = size-1;
80106511:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106516:	89 e5                	mov    %esp,%ebp
80106518:	83 ec 10             	sub    $0x10,%esp
8010651b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010651f:	b8 c0 55 11 80       	mov    $0x801155c0,%eax
80106524:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106528:	c1 e8 10             	shr    $0x10,%eax
8010652b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010652f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106532:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106535:	c9                   	leave  
80106536:	c3                   	ret    
80106537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010653e:	66 90                	xchg   %ax,%ax

80106540 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106540:	55                   	push   %ebp
80106541:	89 e5                	mov    %esp,%ebp
80106543:	57                   	push   %edi
80106544:	56                   	push   %esi
80106545:	53                   	push   %ebx
80106546:	83 ec 1c             	sub    $0x1c,%esp
80106549:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010654c:	8b 43 30             	mov    0x30(%ebx),%eax
8010654f:	83 f8 40             	cmp    $0x40,%eax
80106552:	0f 84 68 01 00 00    	je     801066c0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106558:	83 e8 20             	sub    $0x20,%eax
8010655b:	83 f8 1f             	cmp    $0x1f,%eax
8010655e:	0f 87 8c 00 00 00    	ja     801065f0 <trap+0xb0>
80106564:	ff 24 85 18 87 10 80 	jmp    *-0x7fef78e8(,%eax,4)
8010656b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010656f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106570:	e8 cb bc ff ff       	call   80102240 <ideintr>
    lapiceoi();
80106575:	e8 96 c3 ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010657a:	e8 b1 d4 ff ff       	call   80103a30 <myproc>
8010657f:	85 c0                	test   %eax,%eax
80106581:	74 1d                	je     801065a0 <trap+0x60>
80106583:	e8 a8 d4 ff ff       	call   80103a30 <myproc>
80106588:	8b 50 30             	mov    0x30(%eax),%edx
8010658b:	85 d2                	test   %edx,%edx
8010658d:	74 11                	je     801065a0 <trap+0x60>
8010658f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106593:	83 e0 03             	and    $0x3,%eax
80106596:	66 83 f8 03          	cmp    $0x3,%ax
8010659a:	0f 84 e8 01 00 00    	je     80106788 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801065a0:	e8 8b d4 ff ff       	call   80103a30 <myproc>
801065a5:	85 c0                	test   %eax,%eax
801065a7:	74 0f                	je     801065b8 <trap+0x78>
801065a9:	e8 82 d4 ff ff       	call   80103a30 <myproc>
801065ae:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801065b2:	0f 84 b8 00 00 00    	je     80106670 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801065b8:	e8 73 d4 ff ff       	call   80103a30 <myproc>
801065bd:	85 c0                	test   %eax,%eax
801065bf:	74 1d                	je     801065de <trap+0x9e>
801065c1:	e8 6a d4 ff ff       	call   80103a30 <myproc>
801065c6:	8b 40 30             	mov    0x30(%eax),%eax
801065c9:	85 c0                	test   %eax,%eax
801065cb:	74 11                	je     801065de <trap+0x9e>
801065cd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801065d1:	83 e0 03             	and    $0x3,%eax
801065d4:	66 83 f8 03          	cmp    $0x3,%ax
801065d8:	0f 84 0f 01 00 00    	je     801066ed <trap+0x1ad>
    exit();
}
801065de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065e1:	5b                   	pop    %ebx
801065e2:	5e                   	pop    %esi
801065e3:	5f                   	pop    %edi
801065e4:	5d                   	pop    %ebp
801065e5:	c3                   	ret    
801065e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
801065f0:	e8 3b d4 ff ff       	call   80103a30 <myproc>
801065f5:	8b 7b 38             	mov    0x38(%ebx),%edi
801065f8:	85 c0                	test   %eax,%eax
801065fa:	0f 84 a2 01 00 00    	je     801067a2 <trap+0x262>
80106600:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106604:	0f 84 98 01 00 00    	je     801067a2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010660a:	0f 20 d1             	mov    %cr2,%ecx
8010660d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106610:	e8 7b d3 ff ff       	call   80103990 <cpuid>
80106615:	8b 73 30             	mov    0x30(%ebx),%esi
80106618:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010661b:	8b 43 34             	mov    0x34(%ebx),%eax
8010661e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106621:	e8 0a d4 ff ff       	call   80103a30 <myproc>
80106626:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106629:	e8 02 d4 ff ff       	call   80103a30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010662e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106631:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106634:	51                   	push   %ecx
80106635:	57                   	push   %edi
80106636:	52                   	push   %edx
80106637:	ff 75 e4             	push   -0x1c(%ebp)
8010663a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010663b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010663e:	83 c6 78             	add    $0x78,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106641:	56                   	push   %esi
80106642:	ff 70 10             	push   0x10(%eax)
80106645:	68 d4 86 10 80       	push   $0x801086d4
8010664a:	e8 51 a0 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
8010664f:	83 c4 20             	add    $0x20,%esp
80106652:	e8 d9 d3 ff ff       	call   80103a30 <myproc>
80106657:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010665e:	e8 cd d3 ff ff       	call   80103a30 <myproc>
80106663:	85 c0                	test   %eax,%eax
80106665:	0f 85 18 ff ff ff    	jne    80106583 <trap+0x43>
8010666b:	e9 30 ff ff ff       	jmp    801065a0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106670:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106674:	0f 85 3e ff ff ff    	jne    801065b8 <trap+0x78>
    yield();
8010667a:	e8 61 df ff ff       	call   801045e0 <yield>
8010667f:	e9 34 ff ff ff       	jmp    801065b8 <trap+0x78>
80106684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106688:	8b 7b 38             	mov    0x38(%ebx),%edi
8010668b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010668f:	e8 fc d2 ff ff       	call   80103990 <cpuid>
80106694:	57                   	push   %edi
80106695:	56                   	push   %esi
80106696:	50                   	push   %eax
80106697:	68 7c 86 10 80       	push   $0x8010867c
8010669c:	e8 ff 9f ff ff       	call   801006a0 <cprintf>
    lapiceoi();
801066a1:	e8 6a c2 ff ff       	call   80102910 <lapiceoi>
    break;
801066a6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066a9:	e8 82 d3 ff ff       	call   80103a30 <myproc>
801066ae:	85 c0                	test   %eax,%eax
801066b0:	0f 85 cd fe ff ff    	jne    80106583 <trap+0x43>
801066b6:	e9 e5 fe ff ff       	jmp    801065a0 <trap+0x60>
801066bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066bf:	90                   	nop
    if(myproc()->killed)
801066c0:	e8 6b d3 ff ff       	call   80103a30 <myproc>
801066c5:	8b 70 30             	mov    0x30(%eax),%esi
801066c8:	85 f6                	test   %esi,%esi
801066ca:	0f 85 c8 00 00 00    	jne    80106798 <trap+0x258>
    myproc()->tf = tf;
801066d0:	e8 5b d3 ff ff       	call   80103a30 <myproc>
801066d5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801066d8:	e8 53 ea ff ff       	call   80105130 <syscall>
    if(myproc()->killed)
801066dd:	e8 4e d3 ff ff       	call   80103a30 <myproc>
801066e2:	8b 48 30             	mov    0x30(%eax),%ecx
801066e5:	85 c9                	test   %ecx,%ecx
801066e7:	0f 84 f1 fe ff ff    	je     801065de <trap+0x9e>
}
801066ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066f0:	5b                   	pop    %ebx
801066f1:	5e                   	pop    %esi
801066f2:	5f                   	pop    %edi
801066f3:	5d                   	pop    %ebp
      exit();
801066f4:	e9 87 dc ff ff       	jmp    80104380 <exit>
801066f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106700:	e8 3b 02 00 00       	call   80106940 <uartintr>
    lapiceoi();
80106705:	e8 06 c2 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010670a:	e8 21 d3 ff ff       	call   80103a30 <myproc>
8010670f:	85 c0                	test   %eax,%eax
80106711:	0f 85 6c fe ff ff    	jne    80106583 <trap+0x43>
80106717:	e9 84 fe ff ff       	jmp    801065a0 <trap+0x60>
8010671c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106720:	e8 ab c0 ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80106725:	e8 e6 c1 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010672a:	e8 01 d3 ff ff       	call   80103a30 <myproc>
8010672f:	85 c0                	test   %eax,%eax
80106731:	0f 85 4c fe ff ff    	jne    80106583 <trap+0x43>
80106737:	e9 64 fe ff ff       	jmp    801065a0 <trap+0x60>
8010673c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106740:	e8 4b d2 ff ff       	call   80103990 <cpuid>
80106745:	85 c0                	test   %eax,%eax
80106747:	0f 85 28 fe ff ff    	jne    80106575 <trap+0x35>
      acquire(&tickslock);
8010674d:	83 ec 0c             	sub    $0xc,%esp
80106750:	68 80 55 11 80       	push   $0x80115580
80106755:	e8 86 e4 ff ff       	call   80104be0 <acquire>
      wakeup(&ticks);
8010675a:	c7 04 24 60 55 11 80 	movl   $0x80115560,(%esp)
      ticks++;
80106761:	83 05 60 55 11 80 01 	addl   $0x1,0x80115560
      wakeup(&ticks);
80106768:	e8 83 df ff ff       	call   801046f0 <wakeup>
      release(&tickslock);
8010676d:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)
80106774:	e8 07 e4 ff ff       	call   80104b80 <release>
80106779:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010677c:	e9 f4 fd ff ff       	jmp    80106575 <trap+0x35>
80106781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106788:	e8 f3 db ff ff       	call   80104380 <exit>
8010678d:	e9 0e fe ff ff       	jmp    801065a0 <trap+0x60>
80106792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106798:	e8 e3 db ff ff       	call   80104380 <exit>
8010679d:	e9 2e ff ff ff       	jmp    801066d0 <trap+0x190>
801067a2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801067a5:	e8 e6 d1 ff ff       	call   80103990 <cpuid>
801067aa:	83 ec 0c             	sub    $0xc,%esp
801067ad:	56                   	push   %esi
801067ae:	57                   	push   %edi
801067af:	50                   	push   %eax
801067b0:	ff 73 30             	push   0x30(%ebx)
801067b3:	68 a0 86 10 80       	push   $0x801086a0
801067b8:	e8 e3 9e ff ff       	call   801006a0 <cprintf>
      panic("trap");
801067bd:	83 c4 14             	add    $0x14,%esp
801067c0:	68 74 86 10 80       	push   $0x80108674
801067c5:	e8 b6 9b ff ff       	call   80100380 <panic>
801067ca:	66 90                	xchg   %ax,%ax
801067cc:	66 90                	xchg   %ax,%ax
801067ce:	66 90                	xchg   %ax,%ax

801067d0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801067d0:	a1 c0 5d 11 80       	mov    0x80115dc0,%eax
801067d5:	85 c0                	test   %eax,%eax
801067d7:	74 17                	je     801067f0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801067d9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801067de:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801067df:	a8 01                	test   $0x1,%al
801067e1:	74 0d                	je     801067f0 <uartgetc+0x20>
801067e3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801067e8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801067e9:	0f b6 c0             	movzbl %al,%eax
801067ec:	c3                   	ret    
801067ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801067f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067f5:	c3                   	ret    
801067f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067fd:	8d 76 00             	lea    0x0(%esi),%esi

80106800 <uartinit>:
{
80106800:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106801:	31 c9                	xor    %ecx,%ecx
80106803:	89 c8                	mov    %ecx,%eax
80106805:	89 e5                	mov    %esp,%ebp
80106807:	57                   	push   %edi
80106808:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010680d:	56                   	push   %esi
8010680e:	89 fa                	mov    %edi,%edx
80106810:	53                   	push   %ebx
80106811:	83 ec 1c             	sub    $0x1c,%esp
80106814:	ee                   	out    %al,(%dx)
80106815:	be fb 03 00 00       	mov    $0x3fb,%esi
8010681a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010681f:	89 f2                	mov    %esi,%edx
80106821:	ee                   	out    %al,(%dx)
80106822:	b8 0c 00 00 00       	mov    $0xc,%eax
80106827:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010682c:	ee                   	out    %al,(%dx)
8010682d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106832:	89 c8                	mov    %ecx,%eax
80106834:	89 da                	mov    %ebx,%edx
80106836:	ee                   	out    %al,(%dx)
80106837:	b8 03 00 00 00       	mov    $0x3,%eax
8010683c:	89 f2                	mov    %esi,%edx
8010683e:	ee                   	out    %al,(%dx)
8010683f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106844:	89 c8                	mov    %ecx,%eax
80106846:	ee                   	out    %al,(%dx)
80106847:	b8 01 00 00 00       	mov    $0x1,%eax
8010684c:	89 da                	mov    %ebx,%edx
8010684e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010684f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106854:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106855:	3c ff                	cmp    $0xff,%al
80106857:	74 78                	je     801068d1 <uartinit+0xd1>
  uart = 1;
80106859:	c7 05 c0 5d 11 80 01 	movl   $0x1,0x80115dc0
80106860:	00 00 00 
80106863:	89 fa                	mov    %edi,%edx
80106865:	ec                   	in     (%dx),%al
80106866:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010686b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010686c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010686f:	bf 98 87 10 80       	mov    $0x80108798,%edi
80106874:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106879:	6a 00                	push   $0x0
8010687b:	6a 04                	push   $0x4
8010687d:	e8 fe bb ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106882:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106886:	83 c4 10             	add    $0x10,%esp
80106889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106890:	a1 c0 5d 11 80       	mov    0x80115dc0,%eax
80106895:	bb 80 00 00 00       	mov    $0x80,%ebx
8010689a:	85 c0                	test   %eax,%eax
8010689c:	75 14                	jne    801068b2 <uartinit+0xb2>
8010689e:	eb 23                	jmp    801068c3 <uartinit+0xc3>
    microdelay(10);
801068a0:	83 ec 0c             	sub    $0xc,%esp
801068a3:	6a 0a                	push   $0xa
801068a5:	e8 86 c0 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801068aa:	83 c4 10             	add    $0x10,%esp
801068ad:	83 eb 01             	sub    $0x1,%ebx
801068b0:	74 07                	je     801068b9 <uartinit+0xb9>
801068b2:	89 f2                	mov    %esi,%edx
801068b4:	ec                   	in     (%dx),%al
801068b5:	a8 20                	test   $0x20,%al
801068b7:	74 e7                	je     801068a0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801068b9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801068bd:	ba f8 03 00 00       	mov    $0x3f8,%edx
801068c2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801068c3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801068c7:	83 c7 01             	add    $0x1,%edi
801068ca:	88 45 e7             	mov    %al,-0x19(%ebp)
801068cd:	84 c0                	test   %al,%al
801068cf:	75 bf                	jne    80106890 <uartinit+0x90>
}
801068d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068d4:	5b                   	pop    %ebx
801068d5:	5e                   	pop    %esi
801068d6:	5f                   	pop    %edi
801068d7:	5d                   	pop    %ebp
801068d8:	c3                   	ret    
801068d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801068e0 <uartputc>:
  if(!uart)
801068e0:	a1 c0 5d 11 80       	mov    0x80115dc0,%eax
801068e5:	85 c0                	test   %eax,%eax
801068e7:	74 47                	je     80106930 <uartputc+0x50>
{
801068e9:	55                   	push   %ebp
801068ea:	89 e5                	mov    %esp,%ebp
801068ec:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801068ed:	be fd 03 00 00       	mov    $0x3fd,%esi
801068f2:	53                   	push   %ebx
801068f3:	bb 80 00 00 00       	mov    $0x80,%ebx
801068f8:	eb 18                	jmp    80106912 <uartputc+0x32>
801068fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106900:	83 ec 0c             	sub    $0xc,%esp
80106903:	6a 0a                	push   $0xa
80106905:	e8 26 c0 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010690a:	83 c4 10             	add    $0x10,%esp
8010690d:	83 eb 01             	sub    $0x1,%ebx
80106910:	74 07                	je     80106919 <uartputc+0x39>
80106912:	89 f2                	mov    %esi,%edx
80106914:	ec                   	in     (%dx),%al
80106915:	a8 20                	test   $0x20,%al
80106917:	74 e7                	je     80106900 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106919:	8b 45 08             	mov    0x8(%ebp),%eax
8010691c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106921:	ee                   	out    %al,(%dx)
}
80106922:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106925:	5b                   	pop    %ebx
80106926:	5e                   	pop    %esi
80106927:	5d                   	pop    %ebp
80106928:	c3                   	ret    
80106929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106930:	c3                   	ret    
80106931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010693f:	90                   	nop

80106940 <uartintr>:

void
uartintr(void)
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106946:	68 d0 67 10 80       	push   $0x801067d0
8010694b:	e8 30 9f ff ff       	call   80100880 <consoleintr>
}
80106950:	83 c4 10             	add    $0x10,%esp
80106953:	c9                   	leave  
80106954:	c3                   	ret    

80106955 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106955:	6a 00                	push   $0x0
  pushl $0
80106957:	6a 00                	push   $0x0
  jmp alltraps
80106959:	e9 01 fb ff ff       	jmp    8010645f <alltraps>

8010695e <vector1>:
.globl vector1
vector1:
  pushl $0
8010695e:	6a 00                	push   $0x0
  pushl $1
80106960:	6a 01                	push   $0x1
  jmp alltraps
80106962:	e9 f8 fa ff ff       	jmp    8010645f <alltraps>

80106967 <vector2>:
.globl vector2
vector2:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $2
80106969:	6a 02                	push   $0x2
  jmp alltraps
8010696b:	e9 ef fa ff ff       	jmp    8010645f <alltraps>

80106970 <vector3>:
.globl vector3
vector3:
  pushl $0
80106970:	6a 00                	push   $0x0
  pushl $3
80106972:	6a 03                	push   $0x3
  jmp alltraps
80106974:	e9 e6 fa ff ff       	jmp    8010645f <alltraps>

80106979 <vector4>:
.globl vector4
vector4:
  pushl $0
80106979:	6a 00                	push   $0x0
  pushl $4
8010697b:	6a 04                	push   $0x4
  jmp alltraps
8010697d:	e9 dd fa ff ff       	jmp    8010645f <alltraps>

80106982 <vector5>:
.globl vector5
vector5:
  pushl $0
80106982:	6a 00                	push   $0x0
  pushl $5
80106984:	6a 05                	push   $0x5
  jmp alltraps
80106986:	e9 d4 fa ff ff       	jmp    8010645f <alltraps>

8010698b <vector6>:
.globl vector6
vector6:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $6
8010698d:	6a 06                	push   $0x6
  jmp alltraps
8010698f:	e9 cb fa ff ff       	jmp    8010645f <alltraps>

80106994 <vector7>:
.globl vector7
vector7:
  pushl $0
80106994:	6a 00                	push   $0x0
  pushl $7
80106996:	6a 07                	push   $0x7
  jmp alltraps
80106998:	e9 c2 fa ff ff       	jmp    8010645f <alltraps>

8010699d <vector8>:
.globl vector8
vector8:
  pushl $8
8010699d:	6a 08                	push   $0x8
  jmp alltraps
8010699f:	e9 bb fa ff ff       	jmp    8010645f <alltraps>

801069a4 <vector9>:
.globl vector9
vector9:
  pushl $0
801069a4:	6a 00                	push   $0x0
  pushl $9
801069a6:	6a 09                	push   $0x9
  jmp alltraps
801069a8:	e9 b2 fa ff ff       	jmp    8010645f <alltraps>

801069ad <vector10>:
.globl vector10
vector10:
  pushl $10
801069ad:	6a 0a                	push   $0xa
  jmp alltraps
801069af:	e9 ab fa ff ff       	jmp    8010645f <alltraps>

801069b4 <vector11>:
.globl vector11
vector11:
  pushl $11
801069b4:	6a 0b                	push   $0xb
  jmp alltraps
801069b6:	e9 a4 fa ff ff       	jmp    8010645f <alltraps>

801069bb <vector12>:
.globl vector12
vector12:
  pushl $12
801069bb:	6a 0c                	push   $0xc
  jmp alltraps
801069bd:	e9 9d fa ff ff       	jmp    8010645f <alltraps>

801069c2 <vector13>:
.globl vector13
vector13:
  pushl $13
801069c2:	6a 0d                	push   $0xd
  jmp alltraps
801069c4:	e9 96 fa ff ff       	jmp    8010645f <alltraps>

801069c9 <vector14>:
.globl vector14
vector14:
  pushl $14
801069c9:	6a 0e                	push   $0xe
  jmp alltraps
801069cb:	e9 8f fa ff ff       	jmp    8010645f <alltraps>

801069d0 <vector15>:
.globl vector15
vector15:
  pushl $0
801069d0:	6a 00                	push   $0x0
  pushl $15
801069d2:	6a 0f                	push   $0xf
  jmp alltraps
801069d4:	e9 86 fa ff ff       	jmp    8010645f <alltraps>

801069d9 <vector16>:
.globl vector16
vector16:
  pushl $0
801069d9:	6a 00                	push   $0x0
  pushl $16
801069db:	6a 10                	push   $0x10
  jmp alltraps
801069dd:	e9 7d fa ff ff       	jmp    8010645f <alltraps>

801069e2 <vector17>:
.globl vector17
vector17:
  pushl $17
801069e2:	6a 11                	push   $0x11
  jmp alltraps
801069e4:	e9 76 fa ff ff       	jmp    8010645f <alltraps>

801069e9 <vector18>:
.globl vector18
vector18:
  pushl $0
801069e9:	6a 00                	push   $0x0
  pushl $18
801069eb:	6a 12                	push   $0x12
  jmp alltraps
801069ed:	e9 6d fa ff ff       	jmp    8010645f <alltraps>

801069f2 <vector19>:
.globl vector19
vector19:
  pushl $0
801069f2:	6a 00                	push   $0x0
  pushl $19
801069f4:	6a 13                	push   $0x13
  jmp alltraps
801069f6:	e9 64 fa ff ff       	jmp    8010645f <alltraps>

801069fb <vector20>:
.globl vector20
vector20:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $20
801069fd:	6a 14                	push   $0x14
  jmp alltraps
801069ff:	e9 5b fa ff ff       	jmp    8010645f <alltraps>

80106a04 <vector21>:
.globl vector21
vector21:
  pushl $0
80106a04:	6a 00                	push   $0x0
  pushl $21
80106a06:	6a 15                	push   $0x15
  jmp alltraps
80106a08:	e9 52 fa ff ff       	jmp    8010645f <alltraps>

80106a0d <vector22>:
.globl vector22
vector22:
  pushl $0
80106a0d:	6a 00                	push   $0x0
  pushl $22
80106a0f:	6a 16                	push   $0x16
  jmp alltraps
80106a11:	e9 49 fa ff ff       	jmp    8010645f <alltraps>

80106a16 <vector23>:
.globl vector23
vector23:
  pushl $0
80106a16:	6a 00                	push   $0x0
  pushl $23
80106a18:	6a 17                	push   $0x17
  jmp alltraps
80106a1a:	e9 40 fa ff ff       	jmp    8010645f <alltraps>

80106a1f <vector24>:
.globl vector24
vector24:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $24
80106a21:	6a 18                	push   $0x18
  jmp alltraps
80106a23:	e9 37 fa ff ff       	jmp    8010645f <alltraps>

80106a28 <vector25>:
.globl vector25
vector25:
  pushl $0
80106a28:	6a 00                	push   $0x0
  pushl $25
80106a2a:	6a 19                	push   $0x19
  jmp alltraps
80106a2c:	e9 2e fa ff ff       	jmp    8010645f <alltraps>

80106a31 <vector26>:
.globl vector26
vector26:
  pushl $0
80106a31:	6a 00                	push   $0x0
  pushl $26
80106a33:	6a 1a                	push   $0x1a
  jmp alltraps
80106a35:	e9 25 fa ff ff       	jmp    8010645f <alltraps>

80106a3a <vector27>:
.globl vector27
vector27:
  pushl $0
80106a3a:	6a 00                	push   $0x0
  pushl $27
80106a3c:	6a 1b                	push   $0x1b
  jmp alltraps
80106a3e:	e9 1c fa ff ff       	jmp    8010645f <alltraps>

80106a43 <vector28>:
.globl vector28
vector28:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $28
80106a45:	6a 1c                	push   $0x1c
  jmp alltraps
80106a47:	e9 13 fa ff ff       	jmp    8010645f <alltraps>

80106a4c <vector29>:
.globl vector29
vector29:
  pushl $0
80106a4c:	6a 00                	push   $0x0
  pushl $29
80106a4e:	6a 1d                	push   $0x1d
  jmp alltraps
80106a50:	e9 0a fa ff ff       	jmp    8010645f <alltraps>

80106a55 <vector30>:
.globl vector30
vector30:
  pushl $0
80106a55:	6a 00                	push   $0x0
  pushl $30
80106a57:	6a 1e                	push   $0x1e
  jmp alltraps
80106a59:	e9 01 fa ff ff       	jmp    8010645f <alltraps>

80106a5e <vector31>:
.globl vector31
vector31:
  pushl $0
80106a5e:	6a 00                	push   $0x0
  pushl $31
80106a60:	6a 1f                	push   $0x1f
  jmp alltraps
80106a62:	e9 f8 f9 ff ff       	jmp    8010645f <alltraps>

80106a67 <vector32>:
.globl vector32
vector32:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $32
80106a69:	6a 20                	push   $0x20
  jmp alltraps
80106a6b:	e9 ef f9 ff ff       	jmp    8010645f <alltraps>

80106a70 <vector33>:
.globl vector33
vector33:
  pushl $0
80106a70:	6a 00                	push   $0x0
  pushl $33
80106a72:	6a 21                	push   $0x21
  jmp alltraps
80106a74:	e9 e6 f9 ff ff       	jmp    8010645f <alltraps>

80106a79 <vector34>:
.globl vector34
vector34:
  pushl $0
80106a79:	6a 00                	push   $0x0
  pushl $34
80106a7b:	6a 22                	push   $0x22
  jmp alltraps
80106a7d:	e9 dd f9 ff ff       	jmp    8010645f <alltraps>

80106a82 <vector35>:
.globl vector35
vector35:
  pushl $0
80106a82:	6a 00                	push   $0x0
  pushl $35
80106a84:	6a 23                	push   $0x23
  jmp alltraps
80106a86:	e9 d4 f9 ff ff       	jmp    8010645f <alltraps>

80106a8b <vector36>:
.globl vector36
vector36:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $36
80106a8d:	6a 24                	push   $0x24
  jmp alltraps
80106a8f:	e9 cb f9 ff ff       	jmp    8010645f <alltraps>

80106a94 <vector37>:
.globl vector37
vector37:
  pushl $0
80106a94:	6a 00                	push   $0x0
  pushl $37
80106a96:	6a 25                	push   $0x25
  jmp alltraps
80106a98:	e9 c2 f9 ff ff       	jmp    8010645f <alltraps>

80106a9d <vector38>:
.globl vector38
vector38:
  pushl $0
80106a9d:	6a 00                	push   $0x0
  pushl $38
80106a9f:	6a 26                	push   $0x26
  jmp alltraps
80106aa1:	e9 b9 f9 ff ff       	jmp    8010645f <alltraps>

80106aa6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106aa6:	6a 00                	push   $0x0
  pushl $39
80106aa8:	6a 27                	push   $0x27
  jmp alltraps
80106aaa:	e9 b0 f9 ff ff       	jmp    8010645f <alltraps>

80106aaf <vector40>:
.globl vector40
vector40:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $40
80106ab1:	6a 28                	push   $0x28
  jmp alltraps
80106ab3:	e9 a7 f9 ff ff       	jmp    8010645f <alltraps>

80106ab8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106ab8:	6a 00                	push   $0x0
  pushl $41
80106aba:	6a 29                	push   $0x29
  jmp alltraps
80106abc:	e9 9e f9 ff ff       	jmp    8010645f <alltraps>

80106ac1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106ac1:	6a 00                	push   $0x0
  pushl $42
80106ac3:	6a 2a                	push   $0x2a
  jmp alltraps
80106ac5:	e9 95 f9 ff ff       	jmp    8010645f <alltraps>

80106aca <vector43>:
.globl vector43
vector43:
  pushl $0
80106aca:	6a 00                	push   $0x0
  pushl $43
80106acc:	6a 2b                	push   $0x2b
  jmp alltraps
80106ace:	e9 8c f9 ff ff       	jmp    8010645f <alltraps>

80106ad3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $44
80106ad5:	6a 2c                	push   $0x2c
  jmp alltraps
80106ad7:	e9 83 f9 ff ff       	jmp    8010645f <alltraps>

80106adc <vector45>:
.globl vector45
vector45:
  pushl $0
80106adc:	6a 00                	push   $0x0
  pushl $45
80106ade:	6a 2d                	push   $0x2d
  jmp alltraps
80106ae0:	e9 7a f9 ff ff       	jmp    8010645f <alltraps>

80106ae5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106ae5:	6a 00                	push   $0x0
  pushl $46
80106ae7:	6a 2e                	push   $0x2e
  jmp alltraps
80106ae9:	e9 71 f9 ff ff       	jmp    8010645f <alltraps>

80106aee <vector47>:
.globl vector47
vector47:
  pushl $0
80106aee:	6a 00                	push   $0x0
  pushl $47
80106af0:	6a 2f                	push   $0x2f
  jmp alltraps
80106af2:	e9 68 f9 ff ff       	jmp    8010645f <alltraps>

80106af7 <vector48>:
.globl vector48
vector48:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $48
80106af9:	6a 30                	push   $0x30
  jmp alltraps
80106afb:	e9 5f f9 ff ff       	jmp    8010645f <alltraps>

80106b00 <vector49>:
.globl vector49
vector49:
  pushl $0
80106b00:	6a 00                	push   $0x0
  pushl $49
80106b02:	6a 31                	push   $0x31
  jmp alltraps
80106b04:	e9 56 f9 ff ff       	jmp    8010645f <alltraps>

80106b09 <vector50>:
.globl vector50
vector50:
  pushl $0
80106b09:	6a 00                	push   $0x0
  pushl $50
80106b0b:	6a 32                	push   $0x32
  jmp alltraps
80106b0d:	e9 4d f9 ff ff       	jmp    8010645f <alltraps>

80106b12 <vector51>:
.globl vector51
vector51:
  pushl $0
80106b12:	6a 00                	push   $0x0
  pushl $51
80106b14:	6a 33                	push   $0x33
  jmp alltraps
80106b16:	e9 44 f9 ff ff       	jmp    8010645f <alltraps>

80106b1b <vector52>:
.globl vector52
vector52:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $52
80106b1d:	6a 34                	push   $0x34
  jmp alltraps
80106b1f:	e9 3b f9 ff ff       	jmp    8010645f <alltraps>

80106b24 <vector53>:
.globl vector53
vector53:
  pushl $0
80106b24:	6a 00                	push   $0x0
  pushl $53
80106b26:	6a 35                	push   $0x35
  jmp alltraps
80106b28:	e9 32 f9 ff ff       	jmp    8010645f <alltraps>

80106b2d <vector54>:
.globl vector54
vector54:
  pushl $0
80106b2d:	6a 00                	push   $0x0
  pushl $54
80106b2f:	6a 36                	push   $0x36
  jmp alltraps
80106b31:	e9 29 f9 ff ff       	jmp    8010645f <alltraps>

80106b36 <vector55>:
.globl vector55
vector55:
  pushl $0
80106b36:	6a 00                	push   $0x0
  pushl $55
80106b38:	6a 37                	push   $0x37
  jmp alltraps
80106b3a:	e9 20 f9 ff ff       	jmp    8010645f <alltraps>

80106b3f <vector56>:
.globl vector56
vector56:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $56
80106b41:	6a 38                	push   $0x38
  jmp alltraps
80106b43:	e9 17 f9 ff ff       	jmp    8010645f <alltraps>

80106b48 <vector57>:
.globl vector57
vector57:
  pushl $0
80106b48:	6a 00                	push   $0x0
  pushl $57
80106b4a:	6a 39                	push   $0x39
  jmp alltraps
80106b4c:	e9 0e f9 ff ff       	jmp    8010645f <alltraps>

80106b51 <vector58>:
.globl vector58
vector58:
  pushl $0
80106b51:	6a 00                	push   $0x0
  pushl $58
80106b53:	6a 3a                	push   $0x3a
  jmp alltraps
80106b55:	e9 05 f9 ff ff       	jmp    8010645f <alltraps>

80106b5a <vector59>:
.globl vector59
vector59:
  pushl $0
80106b5a:	6a 00                	push   $0x0
  pushl $59
80106b5c:	6a 3b                	push   $0x3b
  jmp alltraps
80106b5e:	e9 fc f8 ff ff       	jmp    8010645f <alltraps>

80106b63 <vector60>:
.globl vector60
vector60:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $60
80106b65:	6a 3c                	push   $0x3c
  jmp alltraps
80106b67:	e9 f3 f8 ff ff       	jmp    8010645f <alltraps>

80106b6c <vector61>:
.globl vector61
vector61:
  pushl $0
80106b6c:	6a 00                	push   $0x0
  pushl $61
80106b6e:	6a 3d                	push   $0x3d
  jmp alltraps
80106b70:	e9 ea f8 ff ff       	jmp    8010645f <alltraps>

80106b75 <vector62>:
.globl vector62
vector62:
  pushl $0
80106b75:	6a 00                	push   $0x0
  pushl $62
80106b77:	6a 3e                	push   $0x3e
  jmp alltraps
80106b79:	e9 e1 f8 ff ff       	jmp    8010645f <alltraps>

80106b7e <vector63>:
.globl vector63
vector63:
  pushl $0
80106b7e:	6a 00                	push   $0x0
  pushl $63
80106b80:	6a 3f                	push   $0x3f
  jmp alltraps
80106b82:	e9 d8 f8 ff ff       	jmp    8010645f <alltraps>

80106b87 <vector64>:
.globl vector64
vector64:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $64
80106b89:	6a 40                	push   $0x40
  jmp alltraps
80106b8b:	e9 cf f8 ff ff       	jmp    8010645f <alltraps>

80106b90 <vector65>:
.globl vector65
vector65:
  pushl $0
80106b90:	6a 00                	push   $0x0
  pushl $65
80106b92:	6a 41                	push   $0x41
  jmp alltraps
80106b94:	e9 c6 f8 ff ff       	jmp    8010645f <alltraps>

80106b99 <vector66>:
.globl vector66
vector66:
  pushl $0
80106b99:	6a 00                	push   $0x0
  pushl $66
80106b9b:	6a 42                	push   $0x42
  jmp alltraps
80106b9d:	e9 bd f8 ff ff       	jmp    8010645f <alltraps>

80106ba2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106ba2:	6a 00                	push   $0x0
  pushl $67
80106ba4:	6a 43                	push   $0x43
  jmp alltraps
80106ba6:	e9 b4 f8 ff ff       	jmp    8010645f <alltraps>

80106bab <vector68>:
.globl vector68
vector68:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $68
80106bad:	6a 44                	push   $0x44
  jmp alltraps
80106baf:	e9 ab f8 ff ff       	jmp    8010645f <alltraps>

80106bb4 <vector69>:
.globl vector69
vector69:
  pushl $0
80106bb4:	6a 00                	push   $0x0
  pushl $69
80106bb6:	6a 45                	push   $0x45
  jmp alltraps
80106bb8:	e9 a2 f8 ff ff       	jmp    8010645f <alltraps>

80106bbd <vector70>:
.globl vector70
vector70:
  pushl $0
80106bbd:	6a 00                	push   $0x0
  pushl $70
80106bbf:	6a 46                	push   $0x46
  jmp alltraps
80106bc1:	e9 99 f8 ff ff       	jmp    8010645f <alltraps>

80106bc6 <vector71>:
.globl vector71
vector71:
  pushl $0
80106bc6:	6a 00                	push   $0x0
  pushl $71
80106bc8:	6a 47                	push   $0x47
  jmp alltraps
80106bca:	e9 90 f8 ff ff       	jmp    8010645f <alltraps>

80106bcf <vector72>:
.globl vector72
vector72:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $72
80106bd1:	6a 48                	push   $0x48
  jmp alltraps
80106bd3:	e9 87 f8 ff ff       	jmp    8010645f <alltraps>

80106bd8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106bd8:	6a 00                	push   $0x0
  pushl $73
80106bda:	6a 49                	push   $0x49
  jmp alltraps
80106bdc:	e9 7e f8 ff ff       	jmp    8010645f <alltraps>

80106be1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106be1:	6a 00                	push   $0x0
  pushl $74
80106be3:	6a 4a                	push   $0x4a
  jmp alltraps
80106be5:	e9 75 f8 ff ff       	jmp    8010645f <alltraps>

80106bea <vector75>:
.globl vector75
vector75:
  pushl $0
80106bea:	6a 00                	push   $0x0
  pushl $75
80106bec:	6a 4b                	push   $0x4b
  jmp alltraps
80106bee:	e9 6c f8 ff ff       	jmp    8010645f <alltraps>

80106bf3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $76
80106bf5:	6a 4c                	push   $0x4c
  jmp alltraps
80106bf7:	e9 63 f8 ff ff       	jmp    8010645f <alltraps>

80106bfc <vector77>:
.globl vector77
vector77:
  pushl $0
80106bfc:	6a 00                	push   $0x0
  pushl $77
80106bfe:	6a 4d                	push   $0x4d
  jmp alltraps
80106c00:	e9 5a f8 ff ff       	jmp    8010645f <alltraps>

80106c05 <vector78>:
.globl vector78
vector78:
  pushl $0
80106c05:	6a 00                	push   $0x0
  pushl $78
80106c07:	6a 4e                	push   $0x4e
  jmp alltraps
80106c09:	e9 51 f8 ff ff       	jmp    8010645f <alltraps>

80106c0e <vector79>:
.globl vector79
vector79:
  pushl $0
80106c0e:	6a 00                	push   $0x0
  pushl $79
80106c10:	6a 4f                	push   $0x4f
  jmp alltraps
80106c12:	e9 48 f8 ff ff       	jmp    8010645f <alltraps>

80106c17 <vector80>:
.globl vector80
vector80:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $80
80106c19:	6a 50                	push   $0x50
  jmp alltraps
80106c1b:	e9 3f f8 ff ff       	jmp    8010645f <alltraps>

80106c20 <vector81>:
.globl vector81
vector81:
  pushl $0
80106c20:	6a 00                	push   $0x0
  pushl $81
80106c22:	6a 51                	push   $0x51
  jmp alltraps
80106c24:	e9 36 f8 ff ff       	jmp    8010645f <alltraps>

80106c29 <vector82>:
.globl vector82
vector82:
  pushl $0
80106c29:	6a 00                	push   $0x0
  pushl $82
80106c2b:	6a 52                	push   $0x52
  jmp alltraps
80106c2d:	e9 2d f8 ff ff       	jmp    8010645f <alltraps>

80106c32 <vector83>:
.globl vector83
vector83:
  pushl $0
80106c32:	6a 00                	push   $0x0
  pushl $83
80106c34:	6a 53                	push   $0x53
  jmp alltraps
80106c36:	e9 24 f8 ff ff       	jmp    8010645f <alltraps>

80106c3b <vector84>:
.globl vector84
vector84:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $84
80106c3d:	6a 54                	push   $0x54
  jmp alltraps
80106c3f:	e9 1b f8 ff ff       	jmp    8010645f <alltraps>

80106c44 <vector85>:
.globl vector85
vector85:
  pushl $0
80106c44:	6a 00                	push   $0x0
  pushl $85
80106c46:	6a 55                	push   $0x55
  jmp alltraps
80106c48:	e9 12 f8 ff ff       	jmp    8010645f <alltraps>

80106c4d <vector86>:
.globl vector86
vector86:
  pushl $0
80106c4d:	6a 00                	push   $0x0
  pushl $86
80106c4f:	6a 56                	push   $0x56
  jmp alltraps
80106c51:	e9 09 f8 ff ff       	jmp    8010645f <alltraps>

80106c56 <vector87>:
.globl vector87
vector87:
  pushl $0
80106c56:	6a 00                	push   $0x0
  pushl $87
80106c58:	6a 57                	push   $0x57
  jmp alltraps
80106c5a:	e9 00 f8 ff ff       	jmp    8010645f <alltraps>

80106c5f <vector88>:
.globl vector88
vector88:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $88
80106c61:	6a 58                	push   $0x58
  jmp alltraps
80106c63:	e9 f7 f7 ff ff       	jmp    8010645f <alltraps>

80106c68 <vector89>:
.globl vector89
vector89:
  pushl $0
80106c68:	6a 00                	push   $0x0
  pushl $89
80106c6a:	6a 59                	push   $0x59
  jmp alltraps
80106c6c:	e9 ee f7 ff ff       	jmp    8010645f <alltraps>

80106c71 <vector90>:
.globl vector90
vector90:
  pushl $0
80106c71:	6a 00                	push   $0x0
  pushl $90
80106c73:	6a 5a                	push   $0x5a
  jmp alltraps
80106c75:	e9 e5 f7 ff ff       	jmp    8010645f <alltraps>

80106c7a <vector91>:
.globl vector91
vector91:
  pushl $0
80106c7a:	6a 00                	push   $0x0
  pushl $91
80106c7c:	6a 5b                	push   $0x5b
  jmp alltraps
80106c7e:	e9 dc f7 ff ff       	jmp    8010645f <alltraps>

80106c83 <vector92>:
.globl vector92
vector92:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $92
80106c85:	6a 5c                	push   $0x5c
  jmp alltraps
80106c87:	e9 d3 f7 ff ff       	jmp    8010645f <alltraps>

80106c8c <vector93>:
.globl vector93
vector93:
  pushl $0
80106c8c:	6a 00                	push   $0x0
  pushl $93
80106c8e:	6a 5d                	push   $0x5d
  jmp alltraps
80106c90:	e9 ca f7 ff ff       	jmp    8010645f <alltraps>

80106c95 <vector94>:
.globl vector94
vector94:
  pushl $0
80106c95:	6a 00                	push   $0x0
  pushl $94
80106c97:	6a 5e                	push   $0x5e
  jmp alltraps
80106c99:	e9 c1 f7 ff ff       	jmp    8010645f <alltraps>

80106c9e <vector95>:
.globl vector95
vector95:
  pushl $0
80106c9e:	6a 00                	push   $0x0
  pushl $95
80106ca0:	6a 5f                	push   $0x5f
  jmp alltraps
80106ca2:	e9 b8 f7 ff ff       	jmp    8010645f <alltraps>

80106ca7 <vector96>:
.globl vector96
vector96:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $96
80106ca9:	6a 60                	push   $0x60
  jmp alltraps
80106cab:	e9 af f7 ff ff       	jmp    8010645f <alltraps>

80106cb0 <vector97>:
.globl vector97
vector97:
  pushl $0
80106cb0:	6a 00                	push   $0x0
  pushl $97
80106cb2:	6a 61                	push   $0x61
  jmp alltraps
80106cb4:	e9 a6 f7 ff ff       	jmp    8010645f <alltraps>

80106cb9 <vector98>:
.globl vector98
vector98:
  pushl $0
80106cb9:	6a 00                	push   $0x0
  pushl $98
80106cbb:	6a 62                	push   $0x62
  jmp alltraps
80106cbd:	e9 9d f7 ff ff       	jmp    8010645f <alltraps>

80106cc2 <vector99>:
.globl vector99
vector99:
  pushl $0
80106cc2:	6a 00                	push   $0x0
  pushl $99
80106cc4:	6a 63                	push   $0x63
  jmp alltraps
80106cc6:	e9 94 f7 ff ff       	jmp    8010645f <alltraps>

80106ccb <vector100>:
.globl vector100
vector100:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $100
80106ccd:	6a 64                	push   $0x64
  jmp alltraps
80106ccf:	e9 8b f7 ff ff       	jmp    8010645f <alltraps>

80106cd4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106cd4:	6a 00                	push   $0x0
  pushl $101
80106cd6:	6a 65                	push   $0x65
  jmp alltraps
80106cd8:	e9 82 f7 ff ff       	jmp    8010645f <alltraps>

80106cdd <vector102>:
.globl vector102
vector102:
  pushl $0
80106cdd:	6a 00                	push   $0x0
  pushl $102
80106cdf:	6a 66                	push   $0x66
  jmp alltraps
80106ce1:	e9 79 f7 ff ff       	jmp    8010645f <alltraps>

80106ce6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106ce6:	6a 00                	push   $0x0
  pushl $103
80106ce8:	6a 67                	push   $0x67
  jmp alltraps
80106cea:	e9 70 f7 ff ff       	jmp    8010645f <alltraps>

80106cef <vector104>:
.globl vector104
vector104:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $104
80106cf1:	6a 68                	push   $0x68
  jmp alltraps
80106cf3:	e9 67 f7 ff ff       	jmp    8010645f <alltraps>

80106cf8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106cf8:	6a 00                	push   $0x0
  pushl $105
80106cfa:	6a 69                	push   $0x69
  jmp alltraps
80106cfc:	e9 5e f7 ff ff       	jmp    8010645f <alltraps>

80106d01 <vector106>:
.globl vector106
vector106:
  pushl $0
80106d01:	6a 00                	push   $0x0
  pushl $106
80106d03:	6a 6a                	push   $0x6a
  jmp alltraps
80106d05:	e9 55 f7 ff ff       	jmp    8010645f <alltraps>

80106d0a <vector107>:
.globl vector107
vector107:
  pushl $0
80106d0a:	6a 00                	push   $0x0
  pushl $107
80106d0c:	6a 6b                	push   $0x6b
  jmp alltraps
80106d0e:	e9 4c f7 ff ff       	jmp    8010645f <alltraps>

80106d13 <vector108>:
.globl vector108
vector108:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $108
80106d15:	6a 6c                	push   $0x6c
  jmp alltraps
80106d17:	e9 43 f7 ff ff       	jmp    8010645f <alltraps>

80106d1c <vector109>:
.globl vector109
vector109:
  pushl $0
80106d1c:	6a 00                	push   $0x0
  pushl $109
80106d1e:	6a 6d                	push   $0x6d
  jmp alltraps
80106d20:	e9 3a f7 ff ff       	jmp    8010645f <alltraps>

80106d25 <vector110>:
.globl vector110
vector110:
  pushl $0
80106d25:	6a 00                	push   $0x0
  pushl $110
80106d27:	6a 6e                	push   $0x6e
  jmp alltraps
80106d29:	e9 31 f7 ff ff       	jmp    8010645f <alltraps>

80106d2e <vector111>:
.globl vector111
vector111:
  pushl $0
80106d2e:	6a 00                	push   $0x0
  pushl $111
80106d30:	6a 6f                	push   $0x6f
  jmp alltraps
80106d32:	e9 28 f7 ff ff       	jmp    8010645f <alltraps>

80106d37 <vector112>:
.globl vector112
vector112:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $112
80106d39:	6a 70                	push   $0x70
  jmp alltraps
80106d3b:	e9 1f f7 ff ff       	jmp    8010645f <alltraps>

80106d40 <vector113>:
.globl vector113
vector113:
  pushl $0
80106d40:	6a 00                	push   $0x0
  pushl $113
80106d42:	6a 71                	push   $0x71
  jmp alltraps
80106d44:	e9 16 f7 ff ff       	jmp    8010645f <alltraps>

80106d49 <vector114>:
.globl vector114
vector114:
  pushl $0
80106d49:	6a 00                	push   $0x0
  pushl $114
80106d4b:	6a 72                	push   $0x72
  jmp alltraps
80106d4d:	e9 0d f7 ff ff       	jmp    8010645f <alltraps>

80106d52 <vector115>:
.globl vector115
vector115:
  pushl $0
80106d52:	6a 00                	push   $0x0
  pushl $115
80106d54:	6a 73                	push   $0x73
  jmp alltraps
80106d56:	e9 04 f7 ff ff       	jmp    8010645f <alltraps>

80106d5b <vector116>:
.globl vector116
vector116:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $116
80106d5d:	6a 74                	push   $0x74
  jmp alltraps
80106d5f:	e9 fb f6 ff ff       	jmp    8010645f <alltraps>

80106d64 <vector117>:
.globl vector117
vector117:
  pushl $0
80106d64:	6a 00                	push   $0x0
  pushl $117
80106d66:	6a 75                	push   $0x75
  jmp alltraps
80106d68:	e9 f2 f6 ff ff       	jmp    8010645f <alltraps>

80106d6d <vector118>:
.globl vector118
vector118:
  pushl $0
80106d6d:	6a 00                	push   $0x0
  pushl $118
80106d6f:	6a 76                	push   $0x76
  jmp alltraps
80106d71:	e9 e9 f6 ff ff       	jmp    8010645f <alltraps>

80106d76 <vector119>:
.globl vector119
vector119:
  pushl $0
80106d76:	6a 00                	push   $0x0
  pushl $119
80106d78:	6a 77                	push   $0x77
  jmp alltraps
80106d7a:	e9 e0 f6 ff ff       	jmp    8010645f <alltraps>

80106d7f <vector120>:
.globl vector120
vector120:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $120
80106d81:	6a 78                	push   $0x78
  jmp alltraps
80106d83:	e9 d7 f6 ff ff       	jmp    8010645f <alltraps>

80106d88 <vector121>:
.globl vector121
vector121:
  pushl $0
80106d88:	6a 00                	push   $0x0
  pushl $121
80106d8a:	6a 79                	push   $0x79
  jmp alltraps
80106d8c:	e9 ce f6 ff ff       	jmp    8010645f <alltraps>

80106d91 <vector122>:
.globl vector122
vector122:
  pushl $0
80106d91:	6a 00                	push   $0x0
  pushl $122
80106d93:	6a 7a                	push   $0x7a
  jmp alltraps
80106d95:	e9 c5 f6 ff ff       	jmp    8010645f <alltraps>

80106d9a <vector123>:
.globl vector123
vector123:
  pushl $0
80106d9a:	6a 00                	push   $0x0
  pushl $123
80106d9c:	6a 7b                	push   $0x7b
  jmp alltraps
80106d9e:	e9 bc f6 ff ff       	jmp    8010645f <alltraps>

80106da3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $124
80106da5:	6a 7c                	push   $0x7c
  jmp alltraps
80106da7:	e9 b3 f6 ff ff       	jmp    8010645f <alltraps>

80106dac <vector125>:
.globl vector125
vector125:
  pushl $0
80106dac:	6a 00                	push   $0x0
  pushl $125
80106dae:	6a 7d                	push   $0x7d
  jmp alltraps
80106db0:	e9 aa f6 ff ff       	jmp    8010645f <alltraps>

80106db5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106db5:	6a 00                	push   $0x0
  pushl $126
80106db7:	6a 7e                	push   $0x7e
  jmp alltraps
80106db9:	e9 a1 f6 ff ff       	jmp    8010645f <alltraps>

80106dbe <vector127>:
.globl vector127
vector127:
  pushl $0
80106dbe:	6a 00                	push   $0x0
  pushl $127
80106dc0:	6a 7f                	push   $0x7f
  jmp alltraps
80106dc2:	e9 98 f6 ff ff       	jmp    8010645f <alltraps>

80106dc7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $128
80106dc9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106dce:	e9 8c f6 ff ff       	jmp    8010645f <alltraps>

80106dd3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $129
80106dd5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106dda:	e9 80 f6 ff ff       	jmp    8010645f <alltraps>

80106ddf <vector130>:
.globl vector130
vector130:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $130
80106de1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106de6:	e9 74 f6 ff ff       	jmp    8010645f <alltraps>

80106deb <vector131>:
.globl vector131
vector131:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $131
80106ded:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106df2:	e9 68 f6 ff ff       	jmp    8010645f <alltraps>

80106df7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $132
80106df9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106dfe:	e9 5c f6 ff ff       	jmp    8010645f <alltraps>

80106e03 <vector133>:
.globl vector133
vector133:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $133
80106e05:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106e0a:	e9 50 f6 ff ff       	jmp    8010645f <alltraps>

80106e0f <vector134>:
.globl vector134
vector134:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $134
80106e11:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106e16:	e9 44 f6 ff ff       	jmp    8010645f <alltraps>

80106e1b <vector135>:
.globl vector135
vector135:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $135
80106e1d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106e22:	e9 38 f6 ff ff       	jmp    8010645f <alltraps>

80106e27 <vector136>:
.globl vector136
vector136:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $136
80106e29:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106e2e:	e9 2c f6 ff ff       	jmp    8010645f <alltraps>

80106e33 <vector137>:
.globl vector137
vector137:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $137
80106e35:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106e3a:	e9 20 f6 ff ff       	jmp    8010645f <alltraps>

80106e3f <vector138>:
.globl vector138
vector138:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $138
80106e41:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106e46:	e9 14 f6 ff ff       	jmp    8010645f <alltraps>

80106e4b <vector139>:
.globl vector139
vector139:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $139
80106e4d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106e52:	e9 08 f6 ff ff       	jmp    8010645f <alltraps>

80106e57 <vector140>:
.globl vector140
vector140:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $140
80106e59:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106e5e:	e9 fc f5 ff ff       	jmp    8010645f <alltraps>

80106e63 <vector141>:
.globl vector141
vector141:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $141
80106e65:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106e6a:	e9 f0 f5 ff ff       	jmp    8010645f <alltraps>

80106e6f <vector142>:
.globl vector142
vector142:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $142
80106e71:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106e76:	e9 e4 f5 ff ff       	jmp    8010645f <alltraps>

80106e7b <vector143>:
.globl vector143
vector143:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $143
80106e7d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106e82:	e9 d8 f5 ff ff       	jmp    8010645f <alltraps>

80106e87 <vector144>:
.globl vector144
vector144:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $144
80106e89:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106e8e:	e9 cc f5 ff ff       	jmp    8010645f <alltraps>

80106e93 <vector145>:
.globl vector145
vector145:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $145
80106e95:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106e9a:	e9 c0 f5 ff ff       	jmp    8010645f <alltraps>

80106e9f <vector146>:
.globl vector146
vector146:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $146
80106ea1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106ea6:	e9 b4 f5 ff ff       	jmp    8010645f <alltraps>

80106eab <vector147>:
.globl vector147
vector147:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $147
80106ead:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106eb2:	e9 a8 f5 ff ff       	jmp    8010645f <alltraps>

80106eb7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $148
80106eb9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106ebe:	e9 9c f5 ff ff       	jmp    8010645f <alltraps>

80106ec3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $149
80106ec5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106eca:	e9 90 f5 ff ff       	jmp    8010645f <alltraps>

80106ecf <vector150>:
.globl vector150
vector150:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $150
80106ed1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106ed6:	e9 84 f5 ff ff       	jmp    8010645f <alltraps>

80106edb <vector151>:
.globl vector151
vector151:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $151
80106edd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106ee2:	e9 78 f5 ff ff       	jmp    8010645f <alltraps>

80106ee7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $152
80106ee9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106eee:	e9 6c f5 ff ff       	jmp    8010645f <alltraps>

80106ef3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $153
80106ef5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106efa:	e9 60 f5 ff ff       	jmp    8010645f <alltraps>

80106eff <vector154>:
.globl vector154
vector154:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $154
80106f01:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106f06:	e9 54 f5 ff ff       	jmp    8010645f <alltraps>

80106f0b <vector155>:
.globl vector155
vector155:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $155
80106f0d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106f12:	e9 48 f5 ff ff       	jmp    8010645f <alltraps>

80106f17 <vector156>:
.globl vector156
vector156:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $156
80106f19:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106f1e:	e9 3c f5 ff ff       	jmp    8010645f <alltraps>

80106f23 <vector157>:
.globl vector157
vector157:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $157
80106f25:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106f2a:	e9 30 f5 ff ff       	jmp    8010645f <alltraps>

80106f2f <vector158>:
.globl vector158
vector158:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $158
80106f31:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106f36:	e9 24 f5 ff ff       	jmp    8010645f <alltraps>

80106f3b <vector159>:
.globl vector159
vector159:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $159
80106f3d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106f42:	e9 18 f5 ff ff       	jmp    8010645f <alltraps>

80106f47 <vector160>:
.globl vector160
vector160:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $160
80106f49:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106f4e:	e9 0c f5 ff ff       	jmp    8010645f <alltraps>

80106f53 <vector161>:
.globl vector161
vector161:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $161
80106f55:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106f5a:	e9 00 f5 ff ff       	jmp    8010645f <alltraps>

80106f5f <vector162>:
.globl vector162
vector162:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $162
80106f61:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106f66:	e9 f4 f4 ff ff       	jmp    8010645f <alltraps>

80106f6b <vector163>:
.globl vector163
vector163:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $163
80106f6d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106f72:	e9 e8 f4 ff ff       	jmp    8010645f <alltraps>

80106f77 <vector164>:
.globl vector164
vector164:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $164
80106f79:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106f7e:	e9 dc f4 ff ff       	jmp    8010645f <alltraps>

80106f83 <vector165>:
.globl vector165
vector165:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $165
80106f85:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106f8a:	e9 d0 f4 ff ff       	jmp    8010645f <alltraps>

80106f8f <vector166>:
.globl vector166
vector166:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $166
80106f91:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106f96:	e9 c4 f4 ff ff       	jmp    8010645f <alltraps>

80106f9b <vector167>:
.globl vector167
vector167:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $167
80106f9d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106fa2:	e9 b8 f4 ff ff       	jmp    8010645f <alltraps>

80106fa7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $168
80106fa9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106fae:	e9 ac f4 ff ff       	jmp    8010645f <alltraps>

80106fb3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $169
80106fb5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106fba:	e9 a0 f4 ff ff       	jmp    8010645f <alltraps>

80106fbf <vector170>:
.globl vector170
vector170:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $170
80106fc1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106fc6:	e9 94 f4 ff ff       	jmp    8010645f <alltraps>

80106fcb <vector171>:
.globl vector171
vector171:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $171
80106fcd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106fd2:	e9 88 f4 ff ff       	jmp    8010645f <alltraps>

80106fd7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $172
80106fd9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106fde:	e9 7c f4 ff ff       	jmp    8010645f <alltraps>

80106fe3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $173
80106fe5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106fea:	e9 70 f4 ff ff       	jmp    8010645f <alltraps>

80106fef <vector174>:
.globl vector174
vector174:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $174
80106ff1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106ff6:	e9 64 f4 ff ff       	jmp    8010645f <alltraps>

80106ffb <vector175>:
.globl vector175
vector175:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $175
80106ffd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107002:	e9 58 f4 ff ff       	jmp    8010645f <alltraps>

80107007 <vector176>:
.globl vector176
vector176:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $176
80107009:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010700e:	e9 4c f4 ff ff       	jmp    8010645f <alltraps>

80107013 <vector177>:
.globl vector177
vector177:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $177
80107015:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010701a:	e9 40 f4 ff ff       	jmp    8010645f <alltraps>

8010701f <vector178>:
.globl vector178
vector178:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $178
80107021:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107026:	e9 34 f4 ff ff       	jmp    8010645f <alltraps>

8010702b <vector179>:
.globl vector179
vector179:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $179
8010702d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107032:	e9 28 f4 ff ff       	jmp    8010645f <alltraps>

80107037 <vector180>:
.globl vector180
vector180:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $180
80107039:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010703e:	e9 1c f4 ff ff       	jmp    8010645f <alltraps>

80107043 <vector181>:
.globl vector181
vector181:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $181
80107045:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010704a:	e9 10 f4 ff ff       	jmp    8010645f <alltraps>

8010704f <vector182>:
.globl vector182
vector182:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $182
80107051:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107056:	e9 04 f4 ff ff       	jmp    8010645f <alltraps>

8010705b <vector183>:
.globl vector183
vector183:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $183
8010705d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107062:	e9 f8 f3 ff ff       	jmp    8010645f <alltraps>

80107067 <vector184>:
.globl vector184
vector184:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $184
80107069:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010706e:	e9 ec f3 ff ff       	jmp    8010645f <alltraps>

80107073 <vector185>:
.globl vector185
vector185:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $185
80107075:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010707a:	e9 e0 f3 ff ff       	jmp    8010645f <alltraps>

8010707f <vector186>:
.globl vector186
vector186:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $186
80107081:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107086:	e9 d4 f3 ff ff       	jmp    8010645f <alltraps>

8010708b <vector187>:
.globl vector187
vector187:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $187
8010708d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107092:	e9 c8 f3 ff ff       	jmp    8010645f <alltraps>

80107097 <vector188>:
.globl vector188
vector188:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $188
80107099:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010709e:	e9 bc f3 ff ff       	jmp    8010645f <alltraps>

801070a3 <vector189>:
.globl vector189
vector189:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $189
801070a5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801070aa:	e9 b0 f3 ff ff       	jmp    8010645f <alltraps>

801070af <vector190>:
.globl vector190
vector190:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $190
801070b1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801070b6:	e9 a4 f3 ff ff       	jmp    8010645f <alltraps>

801070bb <vector191>:
.globl vector191
vector191:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $191
801070bd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801070c2:	e9 98 f3 ff ff       	jmp    8010645f <alltraps>

801070c7 <vector192>:
.globl vector192
vector192:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $192
801070c9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801070ce:	e9 8c f3 ff ff       	jmp    8010645f <alltraps>

801070d3 <vector193>:
.globl vector193
vector193:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $193
801070d5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801070da:	e9 80 f3 ff ff       	jmp    8010645f <alltraps>

801070df <vector194>:
.globl vector194
vector194:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $194
801070e1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801070e6:	e9 74 f3 ff ff       	jmp    8010645f <alltraps>

801070eb <vector195>:
.globl vector195
vector195:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $195
801070ed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801070f2:	e9 68 f3 ff ff       	jmp    8010645f <alltraps>

801070f7 <vector196>:
.globl vector196
vector196:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $196
801070f9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801070fe:	e9 5c f3 ff ff       	jmp    8010645f <alltraps>

80107103 <vector197>:
.globl vector197
vector197:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $197
80107105:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010710a:	e9 50 f3 ff ff       	jmp    8010645f <alltraps>

8010710f <vector198>:
.globl vector198
vector198:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $198
80107111:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107116:	e9 44 f3 ff ff       	jmp    8010645f <alltraps>

8010711b <vector199>:
.globl vector199
vector199:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $199
8010711d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107122:	e9 38 f3 ff ff       	jmp    8010645f <alltraps>

80107127 <vector200>:
.globl vector200
vector200:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $200
80107129:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010712e:	e9 2c f3 ff ff       	jmp    8010645f <alltraps>

80107133 <vector201>:
.globl vector201
vector201:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $201
80107135:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010713a:	e9 20 f3 ff ff       	jmp    8010645f <alltraps>

8010713f <vector202>:
.globl vector202
vector202:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $202
80107141:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107146:	e9 14 f3 ff ff       	jmp    8010645f <alltraps>

8010714b <vector203>:
.globl vector203
vector203:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $203
8010714d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107152:	e9 08 f3 ff ff       	jmp    8010645f <alltraps>

80107157 <vector204>:
.globl vector204
vector204:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $204
80107159:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010715e:	e9 fc f2 ff ff       	jmp    8010645f <alltraps>

80107163 <vector205>:
.globl vector205
vector205:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $205
80107165:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010716a:	e9 f0 f2 ff ff       	jmp    8010645f <alltraps>

8010716f <vector206>:
.globl vector206
vector206:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $206
80107171:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107176:	e9 e4 f2 ff ff       	jmp    8010645f <alltraps>

8010717b <vector207>:
.globl vector207
vector207:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $207
8010717d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107182:	e9 d8 f2 ff ff       	jmp    8010645f <alltraps>

80107187 <vector208>:
.globl vector208
vector208:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $208
80107189:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010718e:	e9 cc f2 ff ff       	jmp    8010645f <alltraps>

80107193 <vector209>:
.globl vector209
vector209:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $209
80107195:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010719a:	e9 c0 f2 ff ff       	jmp    8010645f <alltraps>

8010719f <vector210>:
.globl vector210
vector210:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $210
801071a1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801071a6:	e9 b4 f2 ff ff       	jmp    8010645f <alltraps>

801071ab <vector211>:
.globl vector211
vector211:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $211
801071ad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801071b2:	e9 a8 f2 ff ff       	jmp    8010645f <alltraps>

801071b7 <vector212>:
.globl vector212
vector212:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $212
801071b9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801071be:	e9 9c f2 ff ff       	jmp    8010645f <alltraps>

801071c3 <vector213>:
.globl vector213
vector213:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $213
801071c5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801071ca:	e9 90 f2 ff ff       	jmp    8010645f <alltraps>

801071cf <vector214>:
.globl vector214
vector214:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $214
801071d1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801071d6:	e9 84 f2 ff ff       	jmp    8010645f <alltraps>

801071db <vector215>:
.globl vector215
vector215:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $215
801071dd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801071e2:	e9 78 f2 ff ff       	jmp    8010645f <alltraps>

801071e7 <vector216>:
.globl vector216
vector216:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $216
801071e9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801071ee:	e9 6c f2 ff ff       	jmp    8010645f <alltraps>

801071f3 <vector217>:
.globl vector217
vector217:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $217
801071f5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801071fa:	e9 60 f2 ff ff       	jmp    8010645f <alltraps>

801071ff <vector218>:
.globl vector218
vector218:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $218
80107201:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107206:	e9 54 f2 ff ff       	jmp    8010645f <alltraps>

8010720b <vector219>:
.globl vector219
vector219:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $219
8010720d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107212:	e9 48 f2 ff ff       	jmp    8010645f <alltraps>

80107217 <vector220>:
.globl vector220
vector220:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $220
80107219:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010721e:	e9 3c f2 ff ff       	jmp    8010645f <alltraps>

80107223 <vector221>:
.globl vector221
vector221:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $221
80107225:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010722a:	e9 30 f2 ff ff       	jmp    8010645f <alltraps>

8010722f <vector222>:
.globl vector222
vector222:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $222
80107231:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107236:	e9 24 f2 ff ff       	jmp    8010645f <alltraps>

8010723b <vector223>:
.globl vector223
vector223:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $223
8010723d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107242:	e9 18 f2 ff ff       	jmp    8010645f <alltraps>

80107247 <vector224>:
.globl vector224
vector224:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $224
80107249:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010724e:	e9 0c f2 ff ff       	jmp    8010645f <alltraps>

80107253 <vector225>:
.globl vector225
vector225:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $225
80107255:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010725a:	e9 00 f2 ff ff       	jmp    8010645f <alltraps>

8010725f <vector226>:
.globl vector226
vector226:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $226
80107261:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107266:	e9 f4 f1 ff ff       	jmp    8010645f <alltraps>

8010726b <vector227>:
.globl vector227
vector227:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $227
8010726d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107272:	e9 e8 f1 ff ff       	jmp    8010645f <alltraps>

80107277 <vector228>:
.globl vector228
vector228:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $228
80107279:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010727e:	e9 dc f1 ff ff       	jmp    8010645f <alltraps>

80107283 <vector229>:
.globl vector229
vector229:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $229
80107285:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010728a:	e9 d0 f1 ff ff       	jmp    8010645f <alltraps>

8010728f <vector230>:
.globl vector230
vector230:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $230
80107291:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107296:	e9 c4 f1 ff ff       	jmp    8010645f <alltraps>

8010729b <vector231>:
.globl vector231
vector231:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $231
8010729d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801072a2:	e9 b8 f1 ff ff       	jmp    8010645f <alltraps>

801072a7 <vector232>:
.globl vector232
vector232:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $232
801072a9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801072ae:	e9 ac f1 ff ff       	jmp    8010645f <alltraps>

801072b3 <vector233>:
.globl vector233
vector233:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $233
801072b5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801072ba:	e9 a0 f1 ff ff       	jmp    8010645f <alltraps>

801072bf <vector234>:
.globl vector234
vector234:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $234
801072c1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801072c6:	e9 94 f1 ff ff       	jmp    8010645f <alltraps>

801072cb <vector235>:
.globl vector235
vector235:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $235
801072cd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801072d2:	e9 88 f1 ff ff       	jmp    8010645f <alltraps>

801072d7 <vector236>:
.globl vector236
vector236:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $236
801072d9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801072de:	e9 7c f1 ff ff       	jmp    8010645f <alltraps>

801072e3 <vector237>:
.globl vector237
vector237:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $237
801072e5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801072ea:	e9 70 f1 ff ff       	jmp    8010645f <alltraps>

801072ef <vector238>:
.globl vector238
vector238:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $238
801072f1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801072f6:	e9 64 f1 ff ff       	jmp    8010645f <alltraps>

801072fb <vector239>:
.globl vector239
vector239:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $239
801072fd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107302:	e9 58 f1 ff ff       	jmp    8010645f <alltraps>

80107307 <vector240>:
.globl vector240
vector240:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $240
80107309:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010730e:	e9 4c f1 ff ff       	jmp    8010645f <alltraps>

80107313 <vector241>:
.globl vector241
vector241:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $241
80107315:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010731a:	e9 40 f1 ff ff       	jmp    8010645f <alltraps>

8010731f <vector242>:
.globl vector242
vector242:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $242
80107321:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107326:	e9 34 f1 ff ff       	jmp    8010645f <alltraps>

8010732b <vector243>:
.globl vector243
vector243:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $243
8010732d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107332:	e9 28 f1 ff ff       	jmp    8010645f <alltraps>

80107337 <vector244>:
.globl vector244
vector244:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $244
80107339:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010733e:	e9 1c f1 ff ff       	jmp    8010645f <alltraps>

80107343 <vector245>:
.globl vector245
vector245:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $245
80107345:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010734a:	e9 10 f1 ff ff       	jmp    8010645f <alltraps>

8010734f <vector246>:
.globl vector246
vector246:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $246
80107351:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107356:	e9 04 f1 ff ff       	jmp    8010645f <alltraps>

8010735b <vector247>:
.globl vector247
vector247:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $247
8010735d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107362:	e9 f8 f0 ff ff       	jmp    8010645f <alltraps>

80107367 <vector248>:
.globl vector248
vector248:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $248
80107369:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010736e:	e9 ec f0 ff ff       	jmp    8010645f <alltraps>

80107373 <vector249>:
.globl vector249
vector249:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $249
80107375:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010737a:	e9 e0 f0 ff ff       	jmp    8010645f <alltraps>

8010737f <vector250>:
.globl vector250
vector250:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $250
80107381:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107386:	e9 d4 f0 ff ff       	jmp    8010645f <alltraps>

8010738b <vector251>:
.globl vector251
vector251:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $251
8010738d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107392:	e9 c8 f0 ff ff       	jmp    8010645f <alltraps>

80107397 <vector252>:
.globl vector252
vector252:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $252
80107399:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010739e:	e9 bc f0 ff ff       	jmp    8010645f <alltraps>

801073a3 <vector253>:
.globl vector253
vector253:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $253
801073a5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801073aa:	e9 b0 f0 ff ff       	jmp    8010645f <alltraps>

801073af <vector254>:
.globl vector254
vector254:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $254
801073b1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801073b6:	e9 a4 f0 ff ff       	jmp    8010645f <alltraps>

801073bb <vector255>:
.globl vector255
vector255:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $255
801073bd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801073c2:	e9 98 f0 ff ff       	jmp    8010645f <alltraps>
801073c7:	66 90                	xchg   %ax,%ax
801073c9:	66 90                	xchg   %ax,%ax
801073cb:	66 90                	xchg   %ax,%ax
801073cd:	66 90                	xchg   %ax,%ax
801073cf:	90                   	nop

801073d0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	57                   	push   %edi
801073d4:	56                   	push   %esi
801073d5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801073d6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801073dc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801073e2:	83 ec 1c             	sub    $0x1c,%esp
801073e5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801073e8:	39 d3                	cmp    %edx,%ebx
801073ea:	73 49                	jae    80107435 <deallocuvm.part.0+0x65>
801073ec:	89 c7                	mov    %eax,%edi
801073ee:	eb 0c                	jmp    801073fc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801073f0:	83 c0 01             	add    $0x1,%eax
801073f3:	c1 e0 16             	shl    $0x16,%eax
801073f6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
801073f8:	39 da                	cmp    %ebx,%edx
801073fa:	76 39                	jbe    80107435 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
801073fc:	89 d8                	mov    %ebx,%eax
801073fe:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107401:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107404:	f6 c1 01             	test   $0x1,%cl
80107407:	74 e7                	je     801073f0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107409:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010740b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107411:	c1 ee 0a             	shr    $0xa,%esi
80107414:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010741a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107421:	85 f6                	test   %esi,%esi
80107423:	74 cb                	je     801073f0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107425:	8b 06                	mov    (%esi),%eax
80107427:	a8 01                	test   $0x1,%al
80107429:	75 15                	jne    80107440 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010742b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107431:	39 da                	cmp    %ebx,%edx
80107433:	77 c7                	ja     801073fc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107435:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107438:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010743b:	5b                   	pop    %ebx
8010743c:	5e                   	pop    %esi
8010743d:	5f                   	pop    %edi
8010743e:	5d                   	pop    %ebp
8010743f:	c3                   	ret    
      if(pa == 0)
80107440:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107445:	74 25                	je     8010746c <deallocuvm.part.0+0x9c>
      kfree(v);
80107447:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010744a:	05 00 00 00 80       	add    $0x80000000,%eax
8010744f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107452:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107458:	50                   	push   %eax
80107459:	e8 62 b0 ff ff       	call   801024c0 <kfree>
      *pte = 0;
8010745e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107464:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107467:	83 c4 10             	add    $0x10,%esp
8010746a:	eb 8c                	jmp    801073f8 <deallocuvm.part.0+0x28>
        panic("kfree");
8010746c:	83 ec 0c             	sub    $0xc,%esp
8010746f:	68 26 80 10 80       	push   $0x80108026
80107474:	e8 07 8f ff ff       	call   80100380 <panic>
80107479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107480 <mappages>:
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	57                   	push   %edi
80107484:	56                   	push   %esi
80107485:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107486:	89 d3                	mov    %edx,%ebx
80107488:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010748e:	83 ec 1c             	sub    $0x1c,%esp
80107491:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107494:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107498:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010749d:	89 45 dc             	mov    %eax,-0x24(%ebp)
801074a0:	8b 45 08             	mov    0x8(%ebp),%eax
801074a3:	29 d8                	sub    %ebx,%eax
801074a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074a8:	eb 3d                	jmp    801074e7 <mappages+0x67>
801074aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801074b0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801074b7:	c1 ea 0a             	shr    $0xa,%edx
801074ba:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801074c0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801074c7:	85 c0                	test   %eax,%eax
801074c9:	74 75                	je     80107540 <mappages+0xc0>
    if(*pte & PTE_P)
801074cb:	f6 00 01             	testb  $0x1,(%eax)
801074ce:	0f 85 86 00 00 00    	jne    8010755a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801074d4:	0b 75 0c             	or     0xc(%ebp),%esi
801074d7:	83 ce 01             	or     $0x1,%esi
801074da:	89 30                	mov    %esi,(%eax)
    if(a == last)
801074dc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801074df:	74 6f                	je     80107550 <mappages+0xd0>
    a += PGSIZE;
801074e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801074e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
801074ea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801074ed:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801074f0:	89 d8                	mov    %ebx,%eax
801074f2:	c1 e8 16             	shr    $0x16,%eax
801074f5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801074f8:	8b 07                	mov    (%edi),%eax
801074fa:	a8 01                	test   $0x1,%al
801074fc:	75 b2                	jne    801074b0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801074fe:	e8 7d b1 ff ff       	call   80102680 <kalloc>
80107503:	85 c0                	test   %eax,%eax
80107505:	74 39                	je     80107540 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107507:	83 ec 04             	sub    $0x4,%esp
8010750a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010750d:	68 00 10 00 00       	push   $0x1000
80107512:	6a 00                	push   $0x0
80107514:	50                   	push   %eax
80107515:	e8 86 d7 ff ff       	call   80104ca0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010751a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010751d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107520:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107526:	83 c8 07             	or     $0x7,%eax
80107529:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010752b:	89 d8                	mov    %ebx,%eax
8010752d:	c1 e8 0a             	shr    $0xa,%eax
80107530:	25 fc 0f 00 00       	and    $0xffc,%eax
80107535:	01 d0                	add    %edx,%eax
80107537:	eb 92                	jmp    801074cb <mappages+0x4b>
80107539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107540:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107543:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107548:	5b                   	pop    %ebx
80107549:	5e                   	pop    %esi
8010754a:	5f                   	pop    %edi
8010754b:	5d                   	pop    %ebp
8010754c:	c3                   	ret    
8010754d:	8d 76 00             	lea    0x0(%esi),%esi
80107550:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107553:	31 c0                	xor    %eax,%eax
}
80107555:	5b                   	pop    %ebx
80107556:	5e                   	pop    %esi
80107557:	5f                   	pop    %edi
80107558:	5d                   	pop    %ebp
80107559:	c3                   	ret    
      panic("remap");
8010755a:	83 ec 0c             	sub    $0xc,%esp
8010755d:	68 a0 87 10 80       	push   $0x801087a0
80107562:	e8 19 8e ff ff       	call   80100380 <panic>
80107567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010756e:	66 90                	xchg   %ax,%ax

80107570 <seginit>:
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107576:	e8 15 c4 ff ff       	call   80103990 <cpuid>
  pd[0] = size-1;
8010757b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107580:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107586:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010758a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107591:	ff 00 00 
80107594:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
8010759b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010759e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
801075a5:	ff 00 00 
801075a8:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
801075af:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801075b2:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
801075b9:	ff 00 00 
801075bc:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
801075c3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801075c6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
801075cd:	ff 00 00 
801075d0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
801075d7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801075da:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
801075df:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801075e3:	c1 e8 10             	shr    $0x10,%eax
801075e6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801075ea:	8d 45 f2             	lea    -0xe(%ebp),%eax
801075ed:	0f 01 10             	lgdtl  (%eax)
}
801075f0:	c9                   	leave  
801075f1:	c3                   	ret    
801075f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107600 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107600:	a1 c4 5d 11 80       	mov    0x80115dc4,%eax
80107605:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010760a:	0f 22 d8             	mov    %eax,%cr3
}
8010760d:	c3                   	ret    
8010760e:	66 90                	xchg   %ax,%ax

80107610 <switchuvm>:
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	57                   	push   %edi
80107614:	56                   	push   %esi
80107615:	53                   	push   %ebx
80107616:	83 ec 1c             	sub    $0x1c,%esp
80107619:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010761c:	85 f6                	test   %esi,%esi
8010761e:	0f 84 cb 00 00 00    	je     801076ef <switchuvm+0xdf>
  if(p->kstack == 0)
80107624:	8b 46 08             	mov    0x8(%esi),%eax
80107627:	85 c0                	test   %eax,%eax
80107629:	0f 84 da 00 00 00    	je     80107709 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010762f:	8b 46 04             	mov    0x4(%esi),%eax
80107632:	85 c0                	test   %eax,%eax
80107634:	0f 84 c2 00 00 00    	je     801076fc <switchuvm+0xec>
  pushcli();
8010763a:	e8 51 d4 ff ff       	call   80104a90 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010763f:	e8 ec c2 ff ff       	call   80103930 <mycpu>
80107644:	89 c3                	mov    %eax,%ebx
80107646:	e8 e5 c2 ff ff       	call   80103930 <mycpu>
8010764b:	89 c7                	mov    %eax,%edi
8010764d:	e8 de c2 ff ff       	call   80103930 <mycpu>
80107652:	83 c7 08             	add    $0x8,%edi
80107655:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107658:	e8 d3 c2 ff ff       	call   80103930 <mycpu>
8010765d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107660:	ba 67 00 00 00       	mov    $0x67,%edx
80107665:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010766c:	83 c0 08             	add    $0x8,%eax
8010766f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107676:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010767b:	83 c1 08             	add    $0x8,%ecx
8010767e:	c1 e8 18             	shr    $0x18,%eax
80107681:	c1 e9 10             	shr    $0x10,%ecx
80107684:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010768a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107690:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107695:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010769c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801076a1:	e8 8a c2 ff ff       	call   80103930 <mycpu>
801076a6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801076ad:	e8 7e c2 ff ff       	call   80103930 <mycpu>
801076b2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801076b6:	8b 5e 08             	mov    0x8(%esi),%ebx
801076b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076bf:	e8 6c c2 ff ff       	call   80103930 <mycpu>
801076c4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801076c7:	e8 64 c2 ff ff       	call   80103930 <mycpu>
801076cc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801076d0:	b8 28 00 00 00       	mov    $0x28,%eax
801076d5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801076d8:	8b 46 04             	mov    0x4(%esi),%eax
801076db:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801076e0:	0f 22 d8             	mov    %eax,%cr3
}
801076e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076e6:	5b                   	pop    %ebx
801076e7:	5e                   	pop    %esi
801076e8:	5f                   	pop    %edi
801076e9:	5d                   	pop    %ebp
  popcli();
801076ea:	e9 f1 d3 ff ff       	jmp    80104ae0 <popcli>
    panic("switchuvm: no process");
801076ef:	83 ec 0c             	sub    $0xc,%esp
801076f2:	68 a6 87 10 80       	push   $0x801087a6
801076f7:	e8 84 8c ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
801076fc:	83 ec 0c             	sub    $0xc,%esp
801076ff:	68 d1 87 10 80       	push   $0x801087d1
80107704:	e8 77 8c ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107709:	83 ec 0c             	sub    $0xc,%esp
8010770c:	68 bc 87 10 80       	push   $0x801087bc
80107711:	e8 6a 8c ff ff       	call   80100380 <panic>
80107716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010771d:	8d 76 00             	lea    0x0(%esi),%esi

80107720 <inituvm>:
{
80107720:	55                   	push   %ebp
80107721:	89 e5                	mov    %esp,%ebp
80107723:	57                   	push   %edi
80107724:	56                   	push   %esi
80107725:	53                   	push   %ebx
80107726:	83 ec 1c             	sub    $0x1c,%esp
80107729:	8b 45 0c             	mov    0xc(%ebp),%eax
8010772c:	8b 75 10             	mov    0x10(%ebp),%esi
8010772f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107735:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010773b:	77 4b                	ja     80107788 <inituvm+0x68>
  mem = kalloc();
8010773d:	e8 3e af ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80107742:	83 ec 04             	sub    $0x4,%esp
80107745:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010774a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010774c:	6a 00                	push   $0x0
8010774e:	50                   	push   %eax
8010774f:	e8 4c d5 ff ff       	call   80104ca0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107754:	58                   	pop    %eax
80107755:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010775b:	5a                   	pop    %edx
8010775c:	6a 06                	push   $0x6
8010775e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107763:	31 d2                	xor    %edx,%edx
80107765:	50                   	push   %eax
80107766:	89 f8                	mov    %edi,%eax
80107768:	e8 13 fd ff ff       	call   80107480 <mappages>
  memmove(mem, init, sz);
8010776d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107770:	89 75 10             	mov    %esi,0x10(%ebp)
80107773:	83 c4 10             	add    $0x10,%esp
80107776:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107779:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010777c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010777f:	5b                   	pop    %ebx
80107780:	5e                   	pop    %esi
80107781:	5f                   	pop    %edi
80107782:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107783:	e9 b8 d5 ff ff       	jmp    80104d40 <memmove>
    panic("inituvm: more than a page");
80107788:	83 ec 0c             	sub    $0xc,%esp
8010778b:	68 e5 87 10 80       	push   $0x801087e5
80107790:	e8 eb 8b ff ff       	call   80100380 <panic>
80107795:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010779c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801077a0 <loaduvm>:
{
801077a0:	55                   	push   %ebp
801077a1:	89 e5                	mov    %esp,%ebp
801077a3:	57                   	push   %edi
801077a4:	56                   	push   %esi
801077a5:	53                   	push   %ebx
801077a6:	83 ec 1c             	sub    $0x1c,%esp
801077a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801077ac:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801077af:	a9 ff 0f 00 00       	test   $0xfff,%eax
801077b4:	0f 85 bb 00 00 00    	jne    80107875 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801077ba:	01 f0                	add    %esi,%eax
801077bc:	89 f3                	mov    %esi,%ebx
801077be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801077c1:	8b 45 14             	mov    0x14(%ebp),%eax
801077c4:	01 f0                	add    %esi,%eax
801077c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801077c9:	85 f6                	test   %esi,%esi
801077cb:	0f 84 87 00 00 00    	je     80107858 <loaduvm+0xb8>
801077d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801077d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801077db:	8b 4d 08             	mov    0x8(%ebp),%ecx
801077de:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801077e0:	89 c2                	mov    %eax,%edx
801077e2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801077e5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801077e8:	f6 c2 01             	test   $0x1,%dl
801077eb:	75 13                	jne    80107800 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801077ed:	83 ec 0c             	sub    $0xc,%esp
801077f0:	68 ff 87 10 80       	push   $0x801087ff
801077f5:	e8 86 8b ff ff       	call   80100380 <panic>
801077fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107800:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107803:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107809:	25 fc 0f 00 00       	and    $0xffc,%eax
8010780e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107815:	85 c0                	test   %eax,%eax
80107817:	74 d4                	je     801077ed <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107819:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010781b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010781e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107823:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107828:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010782e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107831:	29 d9                	sub    %ebx,%ecx
80107833:	05 00 00 00 80       	add    $0x80000000,%eax
80107838:	57                   	push   %edi
80107839:	51                   	push   %ecx
8010783a:	50                   	push   %eax
8010783b:	ff 75 10             	push   0x10(%ebp)
8010783e:	e8 4d a2 ff ff       	call   80101a90 <readi>
80107843:	83 c4 10             	add    $0x10,%esp
80107846:	39 f8                	cmp    %edi,%eax
80107848:	75 1e                	jne    80107868 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010784a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107850:	89 f0                	mov    %esi,%eax
80107852:	29 d8                	sub    %ebx,%eax
80107854:	39 c6                	cmp    %eax,%esi
80107856:	77 80                	ja     801077d8 <loaduvm+0x38>
}
80107858:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010785b:	31 c0                	xor    %eax,%eax
}
8010785d:	5b                   	pop    %ebx
8010785e:	5e                   	pop    %esi
8010785f:	5f                   	pop    %edi
80107860:	5d                   	pop    %ebp
80107861:	c3                   	ret    
80107862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107868:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010786b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107870:	5b                   	pop    %ebx
80107871:	5e                   	pop    %esi
80107872:	5f                   	pop    %edi
80107873:	5d                   	pop    %ebp
80107874:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107875:	83 ec 0c             	sub    $0xc,%esp
80107878:	68 a0 88 10 80       	push   $0x801088a0
8010787d:	e8 fe 8a ff ff       	call   80100380 <panic>
80107882:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107890 <allocuvm>:
{
80107890:	55                   	push   %ebp
80107891:	89 e5                	mov    %esp,%ebp
80107893:	57                   	push   %edi
80107894:	56                   	push   %esi
80107895:	53                   	push   %ebx
80107896:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107899:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010789c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010789f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801078a2:	85 c0                	test   %eax,%eax
801078a4:	0f 88 b6 00 00 00    	js     80107960 <allocuvm+0xd0>
  if(newsz < oldsz)
801078aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801078ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801078b0:	0f 82 9a 00 00 00    	jb     80107950 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801078b6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801078bc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801078c2:	39 75 10             	cmp    %esi,0x10(%ebp)
801078c5:	77 44                	ja     8010790b <allocuvm+0x7b>
801078c7:	e9 87 00 00 00       	jmp    80107953 <allocuvm+0xc3>
801078cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801078d0:	83 ec 04             	sub    $0x4,%esp
801078d3:	68 00 10 00 00       	push   $0x1000
801078d8:	6a 00                	push   $0x0
801078da:	50                   	push   %eax
801078db:	e8 c0 d3 ff ff       	call   80104ca0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801078e0:	58                   	pop    %eax
801078e1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801078e7:	5a                   	pop    %edx
801078e8:	6a 06                	push   $0x6
801078ea:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078ef:	89 f2                	mov    %esi,%edx
801078f1:	50                   	push   %eax
801078f2:	89 f8                	mov    %edi,%eax
801078f4:	e8 87 fb ff ff       	call   80107480 <mappages>
801078f9:	83 c4 10             	add    $0x10,%esp
801078fc:	85 c0                	test   %eax,%eax
801078fe:	78 78                	js     80107978 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107900:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107906:	39 75 10             	cmp    %esi,0x10(%ebp)
80107909:	76 48                	jbe    80107953 <allocuvm+0xc3>
    mem = kalloc();
8010790b:	e8 70 ad ff ff       	call   80102680 <kalloc>
80107910:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107912:	85 c0                	test   %eax,%eax
80107914:	75 ba                	jne    801078d0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107916:	83 ec 0c             	sub    $0xc,%esp
80107919:	68 1d 88 10 80       	push   $0x8010881d
8010791e:	e8 7d 8d ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107923:	8b 45 0c             	mov    0xc(%ebp),%eax
80107926:	83 c4 10             	add    $0x10,%esp
80107929:	39 45 10             	cmp    %eax,0x10(%ebp)
8010792c:	74 32                	je     80107960 <allocuvm+0xd0>
8010792e:	8b 55 10             	mov    0x10(%ebp),%edx
80107931:	89 c1                	mov    %eax,%ecx
80107933:	89 f8                	mov    %edi,%eax
80107935:	e8 96 fa ff ff       	call   801073d0 <deallocuvm.part.0>
      return 0;
8010793a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107941:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107944:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107947:	5b                   	pop    %ebx
80107948:	5e                   	pop    %esi
80107949:	5f                   	pop    %edi
8010794a:	5d                   	pop    %ebp
8010794b:	c3                   	ret    
8010794c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107950:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107953:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107956:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107959:	5b                   	pop    %ebx
8010795a:	5e                   	pop    %esi
8010795b:	5f                   	pop    %edi
8010795c:	5d                   	pop    %ebp
8010795d:	c3                   	ret    
8010795e:	66 90                	xchg   %ax,%ax
    return 0;
80107960:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010796a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010796d:	5b                   	pop    %ebx
8010796e:	5e                   	pop    %esi
8010796f:	5f                   	pop    %edi
80107970:	5d                   	pop    %ebp
80107971:	c3                   	ret    
80107972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107978:	83 ec 0c             	sub    $0xc,%esp
8010797b:	68 35 88 10 80       	push   $0x80108835
80107980:	e8 1b 8d ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107985:	8b 45 0c             	mov    0xc(%ebp),%eax
80107988:	83 c4 10             	add    $0x10,%esp
8010798b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010798e:	74 0c                	je     8010799c <allocuvm+0x10c>
80107990:	8b 55 10             	mov    0x10(%ebp),%edx
80107993:	89 c1                	mov    %eax,%ecx
80107995:	89 f8                	mov    %edi,%eax
80107997:	e8 34 fa ff ff       	call   801073d0 <deallocuvm.part.0>
      kfree(mem);
8010799c:	83 ec 0c             	sub    $0xc,%esp
8010799f:	53                   	push   %ebx
801079a0:	e8 1b ab ff ff       	call   801024c0 <kfree>
      return 0;
801079a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801079ac:	83 c4 10             	add    $0x10,%esp
}
801079af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079b5:	5b                   	pop    %ebx
801079b6:	5e                   	pop    %esi
801079b7:	5f                   	pop    %edi
801079b8:	5d                   	pop    %ebp
801079b9:	c3                   	ret    
801079ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801079c0 <deallocuvm>:
{
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	8b 55 0c             	mov    0xc(%ebp),%edx
801079c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801079c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801079cc:	39 d1                	cmp    %edx,%ecx
801079ce:	73 10                	jae    801079e0 <deallocuvm+0x20>
}
801079d0:	5d                   	pop    %ebp
801079d1:	e9 fa f9 ff ff       	jmp    801073d0 <deallocuvm.part.0>
801079d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079dd:	8d 76 00             	lea    0x0(%esi),%esi
801079e0:	89 d0                	mov    %edx,%eax
801079e2:	5d                   	pop    %ebp
801079e3:	c3                   	ret    
801079e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079ef:	90                   	nop

801079f0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801079f0:	55                   	push   %ebp
801079f1:	89 e5                	mov    %esp,%ebp
801079f3:	57                   	push   %edi
801079f4:	56                   	push   %esi
801079f5:	53                   	push   %ebx
801079f6:	83 ec 0c             	sub    $0xc,%esp
801079f9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801079fc:	85 f6                	test   %esi,%esi
801079fe:	74 59                	je     80107a59 <freevm+0x69>
  if(newsz >= oldsz)
80107a00:	31 c9                	xor    %ecx,%ecx
80107a02:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107a07:	89 f0                	mov    %esi,%eax
80107a09:	89 f3                	mov    %esi,%ebx
80107a0b:	e8 c0 f9 ff ff       	call   801073d0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107a10:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107a16:	eb 0f                	jmp    80107a27 <freevm+0x37>
80107a18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a1f:	90                   	nop
80107a20:	83 c3 04             	add    $0x4,%ebx
80107a23:	39 df                	cmp    %ebx,%edi
80107a25:	74 23                	je     80107a4a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107a27:	8b 03                	mov    (%ebx),%eax
80107a29:	a8 01                	test   $0x1,%al
80107a2b:	74 f3                	je     80107a20 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107a2d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107a32:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107a35:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107a38:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107a3d:	50                   	push   %eax
80107a3e:	e8 7d aa ff ff       	call   801024c0 <kfree>
80107a43:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107a46:	39 df                	cmp    %ebx,%edi
80107a48:	75 dd                	jne    80107a27 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107a4a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107a4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a50:	5b                   	pop    %ebx
80107a51:	5e                   	pop    %esi
80107a52:	5f                   	pop    %edi
80107a53:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107a54:	e9 67 aa ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107a59:	83 ec 0c             	sub    $0xc,%esp
80107a5c:	68 51 88 10 80       	push   $0x80108851
80107a61:	e8 1a 89 ff ff       	call   80100380 <panic>
80107a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a6d:	8d 76 00             	lea    0x0(%esi),%esi

80107a70 <setupkvm>:
{
80107a70:	55                   	push   %ebp
80107a71:	89 e5                	mov    %esp,%ebp
80107a73:	56                   	push   %esi
80107a74:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107a75:	e8 06 ac ff ff       	call   80102680 <kalloc>
80107a7a:	89 c6                	mov    %eax,%esi
80107a7c:	85 c0                	test   %eax,%eax
80107a7e:	74 42                	je     80107ac2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107a80:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a83:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107a88:	68 00 10 00 00       	push   $0x1000
80107a8d:	6a 00                	push   $0x0
80107a8f:	50                   	push   %eax
80107a90:	e8 0b d2 ff ff       	call   80104ca0 <memset>
80107a95:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107a98:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107a9b:	83 ec 08             	sub    $0x8,%esp
80107a9e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107aa1:	ff 73 0c             	push   0xc(%ebx)
80107aa4:	8b 13                	mov    (%ebx),%edx
80107aa6:	50                   	push   %eax
80107aa7:	29 c1                	sub    %eax,%ecx
80107aa9:	89 f0                	mov    %esi,%eax
80107aab:	e8 d0 f9 ff ff       	call   80107480 <mappages>
80107ab0:	83 c4 10             	add    $0x10,%esp
80107ab3:	85 c0                	test   %eax,%eax
80107ab5:	78 19                	js     80107ad0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ab7:	83 c3 10             	add    $0x10,%ebx
80107aba:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107ac0:	75 d6                	jne    80107a98 <setupkvm+0x28>
}
80107ac2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ac5:	89 f0                	mov    %esi,%eax
80107ac7:	5b                   	pop    %ebx
80107ac8:	5e                   	pop    %esi
80107ac9:	5d                   	pop    %ebp
80107aca:	c3                   	ret    
80107acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107acf:	90                   	nop
      freevm(pgdir);
80107ad0:	83 ec 0c             	sub    $0xc,%esp
80107ad3:	56                   	push   %esi
      return 0;
80107ad4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107ad6:	e8 15 ff ff ff       	call   801079f0 <freevm>
      return 0;
80107adb:	83 c4 10             	add    $0x10,%esp
}
80107ade:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ae1:	89 f0                	mov    %esi,%eax
80107ae3:	5b                   	pop    %ebx
80107ae4:	5e                   	pop    %esi
80107ae5:	5d                   	pop    %ebp
80107ae6:	c3                   	ret    
80107ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107aee:	66 90                	xchg   %ax,%ax

80107af0 <kvmalloc>:
{
80107af0:	55                   	push   %ebp
80107af1:	89 e5                	mov    %esp,%ebp
80107af3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107af6:	e8 75 ff ff ff       	call   80107a70 <setupkvm>
80107afb:	a3 c4 5d 11 80       	mov    %eax,0x80115dc4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107b00:	05 00 00 00 80       	add    $0x80000000,%eax
80107b05:	0f 22 d8             	mov    %eax,%cr3
}
80107b08:	c9                   	leave  
80107b09:	c3                   	ret    
80107b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b10 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107b10:	55                   	push   %ebp
80107b11:	89 e5                	mov    %esp,%ebp
80107b13:	83 ec 08             	sub    $0x8,%esp
80107b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107b19:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107b1c:	89 c1                	mov    %eax,%ecx
80107b1e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107b21:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107b24:	f6 c2 01             	test   $0x1,%dl
80107b27:	75 17                	jne    80107b40 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107b29:	83 ec 0c             	sub    $0xc,%esp
80107b2c:	68 62 88 10 80       	push   $0x80108862
80107b31:	e8 4a 88 ff ff       	call   80100380 <panic>
80107b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b3d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107b40:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b43:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107b49:	25 fc 0f 00 00       	and    $0xffc,%eax
80107b4e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107b55:	85 c0                	test   %eax,%eax
80107b57:	74 d0                	je     80107b29 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107b59:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107b5c:	c9                   	leave  
80107b5d:	c3                   	ret    
80107b5e:	66 90                	xchg   %ax,%ax

80107b60 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107b60:	55                   	push   %ebp
80107b61:	89 e5                	mov    %esp,%ebp
80107b63:	57                   	push   %edi
80107b64:	56                   	push   %esi
80107b65:	53                   	push   %ebx
80107b66:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107b69:	e8 02 ff ff ff       	call   80107a70 <setupkvm>
80107b6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107b71:	85 c0                	test   %eax,%eax
80107b73:	0f 84 bd 00 00 00    	je     80107c36 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107b79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107b7c:	85 c9                	test   %ecx,%ecx
80107b7e:	0f 84 b2 00 00 00    	je     80107c36 <copyuvm+0xd6>
80107b84:	31 f6                	xor    %esi,%esi
80107b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b8d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107b90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107b93:	89 f0                	mov    %esi,%eax
80107b95:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107b98:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80107b9b:	a8 01                	test   $0x1,%al
80107b9d:	75 11                	jne    80107bb0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107b9f:	83 ec 0c             	sub    $0xc,%esp
80107ba2:	68 6c 88 10 80       	push   $0x8010886c
80107ba7:	e8 d4 87 ff ff       	call   80100380 <panic>
80107bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107bb0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107bb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107bb7:	c1 ea 0a             	shr    $0xa,%edx
80107bba:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107bc0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107bc7:	85 c0                	test   %eax,%eax
80107bc9:	74 d4                	je     80107b9f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
80107bcb:	8b 00                	mov    (%eax),%eax
80107bcd:	a8 01                	test   $0x1,%al
80107bcf:	0f 84 9f 00 00 00    	je     80107c74 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107bd5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107bd7:	25 ff 0f 00 00       	and    $0xfff,%eax
80107bdc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107bdf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107be5:	e8 96 aa ff ff       	call   80102680 <kalloc>
80107bea:	89 c3                	mov    %eax,%ebx
80107bec:	85 c0                	test   %eax,%eax
80107bee:	74 64                	je     80107c54 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107bf0:	83 ec 04             	sub    $0x4,%esp
80107bf3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107bf9:	68 00 10 00 00       	push   $0x1000
80107bfe:	57                   	push   %edi
80107bff:	50                   	push   %eax
80107c00:	e8 3b d1 ff ff       	call   80104d40 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107c05:	58                   	pop    %eax
80107c06:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107c0c:	5a                   	pop    %edx
80107c0d:	ff 75 e4             	push   -0x1c(%ebp)
80107c10:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c15:	89 f2                	mov    %esi,%edx
80107c17:	50                   	push   %eax
80107c18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c1b:	e8 60 f8 ff ff       	call   80107480 <mappages>
80107c20:	83 c4 10             	add    $0x10,%esp
80107c23:	85 c0                	test   %eax,%eax
80107c25:	78 21                	js     80107c48 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107c27:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107c2d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107c30:	0f 87 5a ff ff ff    	ja     80107b90 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107c36:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c3c:	5b                   	pop    %ebx
80107c3d:	5e                   	pop    %esi
80107c3e:	5f                   	pop    %edi
80107c3f:	5d                   	pop    %ebp
80107c40:	c3                   	ret    
80107c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107c48:	83 ec 0c             	sub    $0xc,%esp
80107c4b:	53                   	push   %ebx
80107c4c:	e8 6f a8 ff ff       	call   801024c0 <kfree>
      goto bad;
80107c51:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107c54:	83 ec 0c             	sub    $0xc,%esp
80107c57:	ff 75 e0             	push   -0x20(%ebp)
80107c5a:	e8 91 fd ff ff       	call   801079f0 <freevm>
  return 0;
80107c5f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107c66:	83 c4 10             	add    $0x10,%esp
}
80107c69:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c6f:	5b                   	pop    %ebx
80107c70:	5e                   	pop    %esi
80107c71:	5f                   	pop    %edi
80107c72:	5d                   	pop    %ebp
80107c73:	c3                   	ret    
      panic("copyuvm: page not present");
80107c74:	83 ec 0c             	sub    $0xc,%esp
80107c77:	68 86 88 10 80       	push   $0x80108886
80107c7c:	e8 ff 86 ff ff       	call   80100380 <panic>
80107c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c8f:	90                   	nop

80107c90 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107c90:	55                   	push   %ebp
80107c91:	89 e5                	mov    %esp,%ebp
80107c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107c96:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107c99:	89 c1                	mov    %eax,%ecx
80107c9b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107c9e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107ca1:	f6 c2 01             	test   $0x1,%dl
80107ca4:	0f 84 00 01 00 00    	je     80107daa <uva2ka.cold>
  return &pgtab[PTX(va)];
80107caa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107cad:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107cb3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107cb4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107cb9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107cc0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107cc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107cc7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107cca:	05 00 00 00 80       	add    $0x80000000,%eax
80107ccf:	83 fa 05             	cmp    $0x5,%edx
80107cd2:	ba 00 00 00 00       	mov    $0x0,%edx
80107cd7:	0f 45 c2             	cmovne %edx,%eax
}
80107cda:	c3                   	ret    
80107cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107cdf:	90                   	nop

80107ce0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107ce0:	55                   	push   %ebp
80107ce1:	89 e5                	mov    %esp,%ebp
80107ce3:	57                   	push   %edi
80107ce4:	56                   	push   %esi
80107ce5:	53                   	push   %ebx
80107ce6:	83 ec 0c             	sub    $0xc,%esp
80107ce9:	8b 75 14             	mov    0x14(%ebp),%esi
80107cec:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cef:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107cf2:	85 f6                	test   %esi,%esi
80107cf4:	75 51                	jne    80107d47 <copyout+0x67>
80107cf6:	e9 a5 00 00 00       	jmp    80107da0 <copyout+0xc0>
80107cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107cff:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107d00:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107d06:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107d0c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107d12:	74 75                	je     80107d89 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107d14:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107d16:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107d19:	29 c3                	sub    %eax,%ebx
80107d1b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107d21:	39 f3                	cmp    %esi,%ebx
80107d23:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107d26:	29 f8                	sub    %edi,%eax
80107d28:	83 ec 04             	sub    $0x4,%esp
80107d2b:	01 c1                	add    %eax,%ecx
80107d2d:	53                   	push   %ebx
80107d2e:	52                   	push   %edx
80107d2f:	51                   	push   %ecx
80107d30:	e8 0b d0 ff ff       	call   80104d40 <memmove>
    len -= n;
    buf += n;
80107d35:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107d38:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107d3e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107d41:	01 da                	add    %ebx,%edx
  while(len > 0){
80107d43:	29 de                	sub    %ebx,%esi
80107d45:	74 59                	je     80107da0 <copyout+0xc0>
  if(*pde & PTE_P){
80107d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107d4a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107d4c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107d4e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107d51:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107d57:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107d5a:	f6 c1 01             	test   $0x1,%cl
80107d5d:	0f 84 4e 00 00 00    	je     80107db1 <copyout.cold>
  return &pgtab[PTX(va)];
80107d63:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107d65:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107d6b:	c1 eb 0c             	shr    $0xc,%ebx
80107d6e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107d74:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107d7b:	89 d9                	mov    %ebx,%ecx
80107d7d:	83 e1 05             	and    $0x5,%ecx
80107d80:	83 f9 05             	cmp    $0x5,%ecx
80107d83:	0f 84 77 ff ff ff    	je     80107d00 <copyout+0x20>
  }
  return 0;
}
80107d89:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107d8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d91:	5b                   	pop    %ebx
80107d92:	5e                   	pop    %esi
80107d93:	5f                   	pop    %edi
80107d94:	5d                   	pop    %ebp
80107d95:	c3                   	ret    
80107d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d9d:	8d 76 00             	lea    0x0(%esi),%esi
80107da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107da3:	31 c0                	xor    %eax,%eax
}
80107da5:	5b                   	pop    %ebx
80107da6:	5e                   	pop    %esi
80107da7:	5f                   	pop    %edi
80107da8:	5d                   	pop    %ebp
80107da9:	c3                   	ret    

80107daa <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107daa:	a1 00 00 00 00       	mov    0x0,%eax
80107daf:	0f 0b                	ud2    

80107db1 <copyout.cold>:
80107db1:	a1 00 00 00 00       	mov    0x0,%eax
80107db6:	0f 0b                	ud2    
