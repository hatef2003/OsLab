
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 50 80 11 80       	mov    $0x80118050,%esp

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
80100044:	bb 54 c5 10 80       	mov    $0x8010c554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 85 10 80       	push   $0x80108520
80100051:	68 20 c5 10 80       	push   $0x8010c520
80100056:	e8 85 4f 00 00       	call   80104fe0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c 0c 11 80       	mov    $0x80110c1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c 0c 11 80 1c 	movl   $0x80110c1c,0x80110c6c
8010006a:	0c 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 0c 11 80 1c 	movl   $0x80110c1c,0x80110c70
80100074:	0c 11 80 
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
8010008b:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 85 10 80       	push   $0x80108527
80100097:	50                   	push   %eax
80100098:	e8 13 4e 00 00       	call   80104eb0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 0c 11 80       	mov    0x80110c70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 09 11 80    	cmp    $0x801109c0,%ebx
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
801000df:	68 20 c5 10 80       	push   $0x8010c520
801000e4:	e8 c7 50 00 00       	call   801051b0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 0c 11 80    	mov    0x80110c70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
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
80100120:	8b 1d 6c 0c 11 80    	mov    0x80110c6c,%ebx
80100126:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
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
8010015d:	68 20 c5 10 80       	push   $0x8010c520
80100162:	e8 e9 4f 00 00       	call   80105150 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 4d 00 00       	call   80104ef0 <acquiresleep>
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
801001a1:	68 2e 85 10 80       	push   $0x8010852e
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
801001be:	e8 cd 4d 00 00       	call   80104f90 <holdingsleep>
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
801001dc:	68 3f 85 10 80       	push   $0x8010853f
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
801001ff:	e8 8c 4d 00 00       	call   80104f90 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 3c 4d 00 00       	call   80104f50 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010021b:	e8 90 4f 00 00       	call   801051b0 <acquire>
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
80100242:	a1 70 0c 11 80       	mov    0x80110c70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 0c 11 80       	mov    0x80110c70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 c5 10 80 	movl   $0x8010c520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 df 4e 00 00       	jmp    80105150 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 46 85 10 80       	push   $0x80108546
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
80100299:	c7 04 24 20 0f 11 80 	movl   $0x80110f20,(%esp)
801002a0:	e8 0b 4f 00 00       	call   801051b0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 0f 11 80       	mov    0x80110f00,%eax
801002b5:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
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
801002c3:	68 20 0f 11 80       	push   $0x80110f20
801002c8:	68 00 0f 11 80       	push   $0x80110f00
801002cd:	e8 5e 47 00 00       	call   80104a30 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 0f 11 80       	mov    0x80110f00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 09 38 00 00       	call   80103af0 <myproc>
801002e7:	8b 48 30             	mov    0x30(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 0f 11 80       	push   $0x80110f20
801002f6:	e8 55 4e 00 00       	call   80105150 <release>
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
8010031b:	89 15 00 0f 11 80    	mov    %edx,0x80110f00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 0e 11 80 	movsbl -0x7feef180(%edx),%ecx
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
80100347:	68 20 0f 11 80       	push   $0x80110f20
8010034c:	e8 ff 4d 00 00       	call   80105150 <release>
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
8010036d:	a3 00 0f 11 80       	mov    %eax,0x80110f00
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
80100389:	c7 05 54 0f 11 80 00 	movl   $0x0,0x80110f54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 4d 85 10 80       	push   $0x8010854d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 f7 8f 10 80 	movl   $0x80108ff7,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 33 4c 00 00       	call   80105000 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 61 85 10 80       	push   $0x80108561
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 0f 11 80 01 	movl   $0x1,0x80110f58
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
8010041a:	e8 e1 6a 00 00       	call   80106f00 <uartputc>
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
80100505:	e8 f6 69 00 00       	call   80106f00 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 ea 69 00 00       	call   80106f00 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 de 69 00 00       	call   80106f00 <uartputc>
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
80100551:	e8 ba 4d 00 00       	call   80105310 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 05 4d 00 00       	call   80105270 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 65 85 10 80       	push   $0x80108565
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
801005a4:	c7 04 24 20 0f 11 80 	movl   $0x80110f20,(%esp)
801005ab:	e8 00 4c 00 00       	call   801051b0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
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
801005df:	68 20 0f 11 80       	push   $0x80110f20
801005e4:	e8 67 4b 00 00       	call   80105150 <release>
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
80100636:	0f b6 92 90 85 10 80 	movzbl -0x7fef7a70(%edx),%edx
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
80100662:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
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
801006a9:	a1 54 0f 11 80       	mov    0x80110f54,%eax
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
80100760:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
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
801007a8:	8b 0d 58 0f 11 80    	mov    0x80110f58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 0f 11 80       	mov    0x80110f58,%eax
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
801007e3:	68 20 0f 11 80       	push   $0x80110f20
801007e8:	e8 c3 49 00 00       	call   801051b0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 0f 11 80    	mov    0x80110f58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
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
80100838:	bf 78 85 10 80       	mov    $0x80108578,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 0f 11 80       	push   $0x80110f20
8010085b:	e8 f0 48 00 00       	call   80105150 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 7f 85 10 80       	push   $0x8010857f
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
8010088e:	68 20 0f 11 80       	push   $0x80110f20
80100893:	e8 18 49 00 00       	call   801051b0 <acquire>
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
801008d3:	a1 08 0f 11 80       	mov    0x80110f08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 0f 11 80    	sub    0x80110f00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 0f 11 80    	mov    %ecx,0x80110f08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 0e 11 80    	mov    %bl,-0x7feef180(%eax)
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
80100927:	a1 00 0f 11 80       	mov    0x80110f00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 0f 11 80    	cmp    %eax,0x80110f08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80100945:	39 05 04 0f 11 80    	cmp    %eax,0x80110f04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 0e 11 80 0a 	cmpb   $0xa,-0x7feef180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
        input.e--;
8010096c:	a3 08 0f 11 80       	mov    %eax,0x80110f08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80100985:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 0f 11 80       	mov    %eax,0x80110f08
  if(panicked){
80100999:	a1 58 0f 11 80       	mov    0x80110f58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 0f 11 80       	mov    0x80110f08,%eax
801009b7:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 0f 11 80       	push   $0x80110f20
801009d0:	e8 7b 47 00 00       	call   80105150 <release>
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
80100a13:	c6 80 80 0e 11 80 0a 	movb   $0xa,-0x7feef180(%eax)
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
80100a32:	a1 08 0f 11 80       	mov    0x80110f08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 0f 11 80       	mov    %eax,0x80110f04
          wakeup(&input.r);
80100a3f:	68 00 0f 11 80       	push   $0x80110f00
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
80100a66:	68 88 85 10 80       	push   $0x80108588
80100a6b:	68 20 0f 11 80       	push   $0x80110f20
80100a70:	e8 6b 45 00 00       	call   80104fe0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 19 11 80 90 	movl   $0x80100590,0x8011190c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 19 11 80 80 	movl   $0x80100280,0x80111908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 0f 11 80 01 	movl   $0x1,0x80110f54
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
80100b34:	e8 87 76 00 00       	call   801081c0 <setupkvm>
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
80100ba3:	e8 08 73 00 00       	call   80107eb0 <allocuvm>
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
80100bd9:	e8 e2 71 00 00       	call   80107dc0 <loaduvm>
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
80100c1b:	e8 20 75 00 00       	call   80108140 <freevm>
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
80100c62:	e8 49 72 00 00       	call   80107eb0 <allocuvm>
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
80100c83:	e8 d8 75 00 00       	call   80108260 <clearpteu>
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
80100cd3:	e8 98 47 00 00       	call   80105470 <strlen>
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
80100ce7:	e8 84 47 00 00       	call   80105470 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 33 77 00 00       	call   80108430 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 2a 74 00 00       	call   80108140 <freevm>
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
80100d63:	e8 c8 76 00 00       	call   80108430 <copyout>
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
80100da1:	e8 8a 46 00 00       	call   80105430 <safestrcpy>
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
80100dcd:	e8 5e 6e 00 00       	call   80107c30 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 66 73 00 00       	call   80108140 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 a1 85 10 80       	push   $0x801085a1
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
80100e16:	68 ad 85 10 80       	push   $0x801085ad
80100e1b:	68 60 0f 11 80       	push   $0x80110f60
80100e20:	e8 bb 41 00 00       	call   80104fe0 <initlock>
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
80100e34:	bb 94 0f 11 80       	mov    $0x80110f94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 0f 11 80       	push   $0x80110f60
80100e41:	e8 6a 43 00 00       	call   801051b0 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 18 11 80    	cmp    $0x801118f4,%ebx
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
80100e6c:	68 60 0f 11 80       	push   $0x80110f60
80100e71:	e8 da 42 00 00       	call   80105150 <release>
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
80100e85:	68 60 0f 11 80       	push   $0x80110f60
80100e8a:	e8 c1 42 00 00       	call   80105150 <release>
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
80100eaa:	68 60 0f 11 80       	push   $0x80110f60
80100eaf:	e8 fc 42 00 00       	call   801051b0 <acquire>
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
80100ec7:	68 60 0f 11 80       	push   $0x80110f60
80100ecc:	e8 7f 42 00 00       	call   80105150 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 b4 85 10 80       	push   $0x801085b4
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
80100efc:	68 60 0f 11 80       	push   $0x80110f60
80100f01:	e8 aa 42 00 00       	call   801051b0 <acquire>
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
80100f34:	68 60 0f 11 80       	push   $0x80110f60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 0f 42 00 00       	call   80105150 <release>

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
80100f60:	c7 45 08 60 0f 11 80 	movl   $0x80110f60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 dd 41 00 00       	jmp    80105150 <release>
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
80100fbc:	68 bc 85 10 80       	push   $0x801085bc
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
801010a2:	68 c6 85 10 80       	push   $0x801085c6
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
80101177:	68 cf 85 10 80       	push   $0x801085cf
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
801011b1:	68 d5 85 10 80       	push   $0x801085d5
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
801011c8:	03 05 cc 35 11 80    	add    0x801135cc,%eax
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
80101227:	68 df 85 10 80       	push   $0x801085df
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
80101249:	8b 0d b4 35 11 80    	mov    0x801135b4,%ecx
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
8010126c:	03 05 cc 35 11 80    	add    0x801135cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 35 11 80       	mov    0x801135b4,%eax
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
801012d9:	39 05 b4 35 11 80    	cmp    %eax,0x801135b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 f2 85 10 80       	push   $0x801085f2
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
80101325:	e8 46 3f 00 00       	call   80105270 <memset>
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
8010135a:	bb 94 19 11 80       	mov    $0x80111994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 19 11 80       	push   $0x80111960
8010136a:	e8 41 3e 00 00       	call   801051b0 <acquire>
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
8010138a:	81 fb b4 35 11 80    	cmp    $0x801135b4,%ebx
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
801013a9:	81 fb b4 35 11 80    	cmp    $0x801135b4,%ebx
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
801013d2:	68 60 19 11 80       	push   $0x80111960
801013d7:	e8 74 3d 00 00       	call   80105150 <release>

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
801013fd:	68 60 19 11 80       	push   $0x80111960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 46 3d 00 00       	call   80105150 <release>
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
8010141d:	81 fb b4 35 11 80    	cmp    $0x801135b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 08 86 10 80       	push   $0x80108608
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
80101515:	68 18 86 10 80       	push   $0x80108618
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
80101541:	e8 ca 3d 00 00       	call   80105310 <memmove>
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
80101564:	bb a0 19 11 80       	mov    $0x801119a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 2b 86 10 80       	push   $0x8010862b
80101571:	68 60 19 11 80       	push   $0x80111960
80101576:	e8 65 3a 00 00       	call   80104fe0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 32 86 10 80       	push   $0x80108632
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 1c 39 00 00       	call   80104eb0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 35 11 80    	cmp    $0x801135c0,%ebx
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
801015b7:	68 b4 35 11 80       	push   $0x801135b4
801015bc:	e8 4f 3d 00 00       	call   80105310 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 35 11 80    	push   0x801135cc
801015cf:	ff 35 c8 35 11 80    	push   0x801135c8
801015d5:	ff 35 c4 35 11 80    	push   0x801135c4
801015db:	ff 35 c0 35 11 80    	push   0x801135c0
801015e1:	ff 35 bc 35 11 80    	push   0x801135bc
801015e7:	ff 35 b8 35 11 80    	push   0x801135b8
801015ed:	ff 35 b4 35 11 80    	push   0x801135b4
801015f3:	68 98 86 10 80       	push   $0x80108698
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
8010161c:	83 3d bc 35 11 80 01 	cmpl   $0x1,0x801135bc
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
8010164f:	3b 3d bc 35 11 80    	cmp    0x801135bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 35 11 80    	add    0x801135c8,%eax
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
8010168e:	e8 dd 3b 00 00       	call   80105270 <memset>
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
801016c3:	68 38 86 10 80       	push   $0x80108638
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
801016e4:	03 05 c8 35 11 80    	add    0x801135c8,%eax
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
80101731:	e8 da 3b 00 00       	call   80105310 <memmove>
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
8010175a:	68 60 19 11 80       	push   $0x80111960
8010175f:	e8 4c 3a 00 00       	call   801051b0 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
8010176f:	e8 dc 39 00 00       	call   80105150 <release>
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
801017a2:	e8 49 37 00 00       	call   80104ef0 <acquiresleep>
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
801017c9:	03 05 c8 35 11 80    	add    0x801135c8,%eax
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
80101818:	e8 f3 3a 00 00       	call   80105310 <memmove>
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
8010183d:	68 50 86 10 80       	push   $0x80108650
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 4a 86 10 80       	push   $0x8010864a
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
80101873:	e8 18 37 00 00       	call   80104f90 <holdingsleep>
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
8010188f:	e9 bc 36 00 00       	jmp    80104f50 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 5f 86 10 80       	push   $0x8010865f
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
801018c0:	e8 2b 36 00 00       	call   80104ef0 <acquiresleep>
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
801018da:	e8 71 36 00 00       	call   80104f50 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
801018e6:	e8 c5 38 00 00       	call   801051b0 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 19 11 80 	movl   $0x80111960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 4b 38 00 00       	jmp    80105150 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 19 11 80       	push   $0x80111960
80101910:	e8 9b 38 00 00       	call   801051b0 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
8010191f:	e8 2c 38 00 00       	call   80105150 <release>
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
80101a23:	e8 68 35 00 00       	call   80104f90 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 11 35 00 00       	call   80104f50 <releasesleep>
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
80101a53:	68 5f 86 10 80       	push   $0x8010865f
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
80101b37:	e8 d4 37 00 00       	call   80105310 <memmove>
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
80101b6a:	8b 04 c5 00 19 11 80 	mov    -0x7feee700(,%eax,8),%eax
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
80101c33:	e8 d8 36 00 00       	call   80105310 <memmove>
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
80101c7a:	8b 04 c5 04 19 11 80 	mov    -0x7feee6fc(,%eax,8),%eax
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
80101cce:	e8 ad 36 00 00       	call   80105380 <strncmp>
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
80101d2d:	e8 4e 36 00 00       	call   80105380 <strncmp>
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
80101d72:	68 79 86 10 80       	push   $0x80108679
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 67 86 10 80       	push   $0x80108667
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
80101db5:	68 60 19 11 80       	push   $0x80111960
80101dba:	e8 f1 33 00 00       	call   801051b0 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
80101dca:	e8 81 33 00 00       	call   80105150 <release>
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
80101e27:	e8 e4 34 00 00       	call   80105310 <memmove>
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
80101e8c:	e8 ff 30 00 00       	call   80104f90 <holdingsleep>
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
80101eae:	e8 9d 30 00 00       	call   80104f50 <releasesleep>
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
80101edb:	e8 30 34 00 00       	call   80105310 <memmove>
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
80101f2b:	e8 60 30 00 00       	call   80104f90 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 01 30 00 00       	call   80104f50 <releasesleep>
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
80101f6d:	e8 1e 30 00 00       	call   80104f90 <holdingsleep>
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
80101f90:	e8 fb 2f 00 00       	call   80104f90 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 a4 2f 00 00       	call   80104f50 <releasesleep>
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
80101fcf:	68 5f 86 10 80       	push   $0x8010865f
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
8010203d:	e8 8e 33 00 00       	call   801053d0 <strncpy>
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
8010207b:	68 88 86 10 80       	push   $0x80108688
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 b2 8d 10 80       	push   $0x80108db2
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
8010219b:	68 f4 86 10 80       	push   $0x801086f4
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 eb 86 10 80       	push   $0x801086eb
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 06 87 10 80       	push   $0x80108706
801021cb:	68 00 36 11 80       	push   $0x80113600
801021d0:	e8 0b 2e 00 00       	call   80104fe0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 37 11 80       	mov    0x80113784,%eax
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
8010221a:	c7 05 e0 35 11 80 01 	movl   $0x1,0x801135e0
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
80102249:	68 00 36 11 80       	push   $0x80113600
8010224e:	e8 5d 2f 00 00       	call   801051b0 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 35 11 80    	mov    0x801135e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 35 11 80       	mov    %eax,0x801135e4

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
801022b2:	a1 e4 35 11 80       	mov    0x801135e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 36 11 80       	push   $0x80113600
801022cb:	e8 80 2e 00 00       	call   80105150 <release>

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
801022ee:	e8 9d 2c 00 00       	call   80104f90 <holdingsleep>
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
80102313:	a1 e0 35 11 80       	mov    0x801135e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 36 11 80       	push   $0x80113600
80102328:	e8 83 2e 00 00       	call   801051b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 35 11 80       	mov    0x801135e4,%eax
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
8010234e:	39 1d e4 35 11 80    	cmp    %ebx,0x801135e4
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
80102363:	68 00 36 11 80       	push   $0x80113600
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
8010237b:	c7 45 08 00 36 11 80 	movl   $0x80113600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 c5 2d 00 00       	jmp    80105150 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 35 11 80       	mov    $0x801135e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 35 87 10 80       	push   $0x80108735
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 20 87 10 80       	push   $0x80108720
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 0a 87 10 80       	push   $0x8010870a
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
801023d1:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
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
8010241a:	68 54 87 10 80       	push   $0x80108754
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
80102444:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
8010245e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
80102481:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
80102495:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 36 11 80       	mov    0x80113634,%eax
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
801024d2:	81 fb 50 80 11 80    	cmp    $0x80118050,%ebx
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
801024f2:	e8 79 2d 00 00       	call   80105270 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 78 36 11 80       	mov    0x80113678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
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
80102523:	68 40 36 11 80       	push   $0x80113640
80102528:	e8 83 2c 00 00       	call   801051b0 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 08 2c 00 00       	jmp    80105150 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 86 87 10 80       	push   $0x80108786
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
801025f4:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
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
8010261b:	68 8c 87 10 80       	push   $0x8010878c
80102620:	68 40 36 11 80       	push   $0x80113640
80102625:	e8 b6 29 00 00       	call   80104fe0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
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
80102680:	a1 74 36 11 80       	mov    0x80113674,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 78 36 11 80    	mov    %edx,0x80113678
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
801026ae:	68 40 36 11 80       	push   $0x80113640
801026b3:	e8 f8 2a 00 00       	call   801051b0 <acquire>
  r = kmem.freelist;
801026b8:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(kmem.use_lock)
801026bd:	8b 15 74 36 11 80    	mov    0x80113674,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 36 11 80       	push   $0x80113640
801026e1:	e8 6a 2a 00 00       	call   80105150 <release>
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
80102708:	8b 1d 7c 36 11 80    	mov    0x8011367c,%ebx
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
8010272b:	0f b6 91 c0 88 10 80 	movzbl -0x7fef7740(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 c0 87 10 80 	movzbl -0x7fef7840(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 7c 36 11 80    	mov    %edx,0x8011367c
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 a0 87 10 80 	mov    -0x7fef7860(,%eax,4),%eax
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
80102775:	89 1d 7c 36 11 80    	mov    %ebx,0x8011367c
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 c0 88 10 80 	movzbl -0x7fef7740(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 7c 36 11 80       	mov    %eax,0x8011367c
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
801027f0:	a1 80 36 11 80       	mov    0x80113680,%eax
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
801028f0:	a1 80 36 11 80       	mov    0x80113680,%eax
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
80102910:	a1 80 36 11 80       	mov    0x80113680,%eax
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
8010297e:	a1 80 36 11 80       	mov    0x80113680,%eax
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
80102af7:	e8 c4 27 00 00       	call   801052c0 <memcmp>
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
80102bc0:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
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
80102be0:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 e4 36 11 80    	push   0x801136e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd ec 36 11 80 	push   -0x7feec914(,%edi,4)
80102c04:	ff 35 e4 36 11 80    	push   0x801136e4
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
80102c24:	e8 e7 26 00 00       	call   80105310 <memmove>
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
80102c44:	39 3d e8 36 11 80    	cmp    %edi,0x801136e8
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
80102c67:	ff 35 d4 36 11 80    	push   0x801136d4
80102c6d:	ff 35 e4 36 11 80    	push   0x801136e4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 e8 36 11 80       	mov    0x801136e8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 ec 36 11 80 	mov    -0x7feec914(,%edx,4),%ecx
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
80102cca:	68 c0 89 10 80       	push   $0x801089c0
80102ccf:	68 a0 36 11 80       	push   $0x801136a0
80102cd4:	e8 07 23 00 00       	call   80104fe0 <initlock>
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
80102ce9:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf2:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  log.size = sb.nlog;
80102cf7:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d0b:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d24:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
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
80102d40:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
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
80102d66:	68 a0 36 11 80       	push   $0x801136a0
80102d6b:	e8 40 24 00 00       	call   801051b0 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 36 11 80       	push   $0x801136a0
80102d80:	68 a0 36 11 80       	push   $0x801136a0
80102d85:	e8 a6 1c 00 00       	call   80104a30 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102d9b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
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
80102db2:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102db7:	68 a0 36 11 80       	push   $0x801136a0
80102dbc:	e8 8f 23 00 00       	call   80105150 <release>
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
80102dd9:	68 a0 36 11 80       	push   $0x801136a0
80102dde:	e8 cd 23 00 00       	call   801051b0 <acquire>
  log.outstanding -= 1;
80102de3:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102de8:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0a:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102e11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 a0 36 11 80       	push   $0x801136a0
80102e1c:	e8 2f 23 00 00       	call   80105150 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 a0 36 11 80       	push   $0x801136a0
80102e36:	e8 75 23 00 00       	call   801051b0 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80102e42:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 9f 1c 00 00       	call   80104af0 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102e58:	e8 f3 22 00 00       	call   80105150 <release>
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
80102e70:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 e4 36 11 80    	push   0x801136e4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d ec 36 11 80 	push   -0x7feec914(,%ebx,4)
80102e94:	ff 35 e4 36 11 80    	push   0x801136e4
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
80102eb4:	e8 57 24 00 00       	call   80105310 <memmove>
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
80102ed4:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 a0 36 11 80       	push   $0x801136a0
80102f08:	e8 e3 1b 00 00       	call   80104af0 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102f14:	e8 37 22 00 00       	call   80105150 <release>
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
80102f27:	68 c4 89 10 80       	push   $0x801089c4
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
80102f47:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f65:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 a0 36 11 80       	push   $0x801136a0
80102f76:	e8 35 22 00 00       	call   801051b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f7b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
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
80102f97:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 96 21 00 00       	jmp    80105150 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 d3 89 10 80       	push   $0x801089d3
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 e9 89 10 80       	push   $0x801089e9
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
80103018:	68 04 8a 10 80       	push   $0x80108a04
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 f9 3a 00 00       	call   80106b20 <idtinit>
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
80103046:	e8 d5 4b 00 00       	call   80107c20 <switchkvm>
  seginit();
8010304b:	e8 40 4b 00 00       	call   80107b90 <seginit>
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
80103077:	68 50 80 11 80       	push   $0x80118050
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 ba 51 00 00       	call   80108240 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 fb 4a 00 00       	call   80107b90 <seginit>
  init_shared_pages();
80103095:	e8 46 1c 00 00       	call   80104ce0 <init_shared_pages>
  picinit();       // disable pic
8010309a:	e8 71 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309f:	e8 2c f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
801030a4:	e8 b7 d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a9:	e8 72 3d 00 00       	call   80106e20 <uartinit>
  pinit();         // process table
801030ae:	e8 6d 08 00 00       	call   80103920 <pinit>
  tvinit();        // trap vectors
801030b3:	e8 e8 39 00 00       	call   80106aa0 <tvinit>
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
801030cf:	68 8c c4 10 80       	push   $0x8010c48c
801030d4:	68 00 70 00 80       	push   $0x80007000
801030d9:	e8 32 22 00 00       	call   80105310 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030de:	83 c4 10             	add    $0x10,%esp
801030e1:	69 05 84 37 11 80 b0 	imul   $0xb0,0x80113784,%eax
801030e8:	00 00 00 
801030eb:	05 a0 37 11 80       	add    $0x801137a0,%eax
801030f0:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
801030f5:	76 79                	jbe    80103170 <main+0x110>
801030f7:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
801030fc:	eb 1b                	jmp    80103119 <main+0xb9>
801030fe:	66 90                	xchg   %ax,%ax
80103100:	69 05 84 37 11 80 b0 	imul   $0xb0,0x80113784,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 a0 37 11 80       	add    $0x801137a0,%eax
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
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
8010313b:	b0 10 00 
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
801031be:	68 18 8a 10 80       	push   $0x80108a18
801031c3:	56                   	push   %esi
801031c4:	e8 f7 20 00 00       	call   801052c0 <memcmp>
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
80103276:	68 1d 8a 10 80       	push   $0x80108a1d
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 3c 20 00 00       	call   801052c0 <memcmp>
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
801032d6:	a3 80 36 11 80       	mov    %eax,0x80113680
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
80103357:	88 0d 80 37 11 80    	mov    %cl,0x80113780
      continue;
8010335d:	eb 99                	jmp    801032f8 <mpinit+0xe8>
8010335f:	90                   	nop
      if(ncpu < NCPU) {
80103360:	8b 0d 84 37 11 80    	mov    0x80113784,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 84 37 11 80    	mov    %ecx,0x80113784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f a0 37 11 80    	mov    %bl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 6c ff ff ff       	jmp    801032f8 <mpinit+0xe8>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 22 8a 10 80       	push   $0x80108a22
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
801033c2:	68 18 8a 10 80       	push   $0x80108a18
801033c7:	53                   	push   %ebx
801033c8:	e8 f3 1e 00 00       	call   801052c0 <memcmp>
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
801033f8:	68 3c 8a 10 80       	push   $0x80108a3c
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
801034a3:	68 5b 8a 10 80       	push   $0x80108a5b
801034a8:	50                   	push   %eax
801034a9:	e8 32 1b 00 00       	call   80104fe0 <initlock>
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
8010353f:	e8 6c 1c 00 00       	call   801051b0 <acquire>
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
80103584:	e9 c7 1b 00 00       	jmp    80105150 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 b7 1b 00 00       	call   80105150 <release>
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
801035dd:	e8 ce 1b 00 00       	call   801051b0 <acquire>
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
8010366c:	e8 df 1a 00 00       	call   80105150 <release>
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
801036c2:	e8 89 1a 00 00       	call   80105150 <release>
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
801036e6:	e8 c5 1a 00 00       	call   801051b0 <acquire>
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
8010377e:	e8 cd 19 00 00       	call   80105150 <release>
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
80103799:	e8 b2 19 00 00       	call   80105150 <release>
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
801037b4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 20 3d 11 80       	push   $0x80113d20
801037c1:	e8 ea 19 00 00       	call   801051b0 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 17                	jmp    801037e2 <allocproc+0x32>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
801037d6:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
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
801037e9:	a1 04 c0 10 80       	mov    0x8010c004,%eax
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
8010383b:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
80103840:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103846:	e8 05 19 00 00       	call   80105150 <release>

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
8010386b:	c7 40 14 87 6a 10 80 	movl   $0x80106a87,0x14(%eax)
  p->context = (struct context *)sp;
80103872:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103875:	6a 14                	push   $0x14
80103877:	6a 00                	push   $0x0
80103879:	50                   	push   %eax
8010387a:	e8 f1 19 00 00       	call   80105270 <memset>
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
8010389d:	68 20 3d 11 80       	push   $0x80113d20
801038a2:	e8 a9 18 00 00       	call   80105150 <release>
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
801038d6:	68 20 3d 11 80       	push   $0x80113d20
801038db:	e8 70 18 00 00       	call   80105150 <release>

  if (first)
801038e0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
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
801038f0:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
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
80103926:	68 60 8a 10 80       	push   $0x80108a60
8010392b:	68 20 3d 11 80       	push   $0x80113d20
80103930:	e8 ab 16 00 00       	call   80104fe0 <initlock>
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
801039a1:	8b 35 84 37 11 80    	mov    0x80113784,%esi
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
801039bd:	0f b6 99 a0 37 11 80 	movzbl -0x7feec860(%ecx),%ebx
801039c4:	39 c3                	cmp    %eax,%ebx
801039c6:	75 e8                	jne    801039b0 <mycpu+0x20>
}
801039c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039cb:	8d 81 a0 37 11 80    	lea    -0x7feec860(%ecx),%eax
}
801039d1:	5b                   	pop    %ebx
801039d2:	5e                   	pop    %esi
801039d3:	5d                   	pop    %ebp
801039d4:	c3                   	ret    
  panic("unknown apicid\n");
801039d5:	83 ec 0c             	sub    $0xc,%esp
801039d8:	68 67 8a 10 80       	push   $0x80108a67
801039dd:	e8 9e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
801039e2:	83 ec 0c             	sub    $0xc,%esp
801039e5:	68 d4 8b 10 80       	push   $0x80108bd4
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
801039fc:	2d a0 37 11 80       	sub    $0x801137a0,%eax
80103a01:	c1 f8 04             	sar    $0x4,%eax
80103a04:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a0a:	c3                   	ret    
80103a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a0f:	90                   	nop

80103a10 <aging>:
  time = ticks;
80103a10:	8b 0d e0 67 11 80    	mov    0x801167e0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a16:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103a1b:	eb 0f                	jmp    80103a2c <aging+0x1c>
80103a1d:	8d 76 00             	lea    0x0(%esi),%esi
80103a20:	05 a0 00 00 00       	add    $0xa0,%eax
80103a25:	3d 54 65 11 80       	cmp    $0x80116554,%eax
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
80103a51:	3d 54 65 11 80       	cmp    $0x80116554,%eax
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
80103a69:	68 20 3d 11 80       	push   $0x80113d20
{
80103a6e:	d9 5d e8             	fstps  -0x18(%ebp)
80103a71:	d9 45 0c             	flds   0xc(%ebp)
80103a74:	d9 5d ec             	fstps  -0x14(%ebp)
80103a77:	d9 45 10             	flds   0x10(%ebp)
80103a7a:	d9 5d f0             	fstps  -0x10(%ebp)
80103a7d:	d9 45 14             	flds   0x14(%ebp)
80103a80:	d9 5d f4             	fstps  -0xc(%ebp)
  acquire(&ptable.lock);
80103a83:	e8 28 17 00 00       	call   801051b0 <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a88:	d9 45 e8             	flds   -0x18(%ebp)
80103a8b:	d9 45 ec             	flds   -0x14(%ebp)
  acquire(&ptable.lock);
80103a8e:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a91:	d9 45 f0             	flds   -0x10(%ebp)
80103a94:	d9 45 f4             	flds   -0xc(%ebp)
80103a97:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
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
80103ad4:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80103ad9:	75 c5                	jne    80103aa0 <reset_bjf_attributes+0x40>
80103adb:	dd d8                	fstp   %st(0)
80103add:	dd d8                	fstp   %st(0)
80103adf:	dd d8                	fstp   %st(0)
80103ae1:	dd d8                	fstp   %st(0)
  release(&ptable.lock);
80103ae3:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80103aea:	c9                   	leave  
  release(&ptable.lock);
80103aeb:	e9 60 16 00 00       	jmp    80105150 <release>

80103af0 <myproc>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	53                   	push   %ebx
80103af4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103af7:	e8 64 15 00 00       	call   80105060 <pushcli>
  c = mycpu();
80103afc:	e8 8f fe ff ff       	call   80103990 <mycpu>
  p = c->proc;
80103b01:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b07:	e8 a4 15 00 00       	call   801050b0 <popcli>
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
80103b6e:	a3 c4 67 11 80       	mov    %eax,0x801167c4
  if ((p->pgdir = setupkvm()) == 0)
80103b73:	e8 48 46 00 00       	call   801081c0 <setupkvm>
80103b78:	89 43 04             	mov    %eax,0x4(%ebx)
80103b7b:	85 c0                	test   %eax,%eax
80103b7d:	0f 84 c4 00 00 00    	je     80103c47 <userinit+0xe7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b83:	83 ec 04             	sub    $0x4,%esp
80103b86:	68 2c 00 00 00       	push   $0x2c
80103b8b:	68 60 c4 10 80       	push   $0x8010c460
80103b90:	50                   	push   %eax
80103b91:	e8 aa 41 00 00       	call   80107d40 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b9f:	6a 4c                	push   $0x4c
80103ba1:	6a 00                	push   $0x0
80103ba3:	ff 73 18             	push   0x18(%ebx)
80103ba6:	e8 c5 16 00 00       	call   80105270 <memset>
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
80103bff:	68 90 8a 10 80       	push   $0x80108a90
80103c04:	50                   	push   %eax
80103c05:	e8 26 18 00 00       	call   80105430 <safestrcpy>
  p->cwd = namei("/");
80103c0a:	c7 04 24 99 8a 10 80 	movl   $0x80108a99,(%esp)
80103c11:	e8 8a e4 ff ff       	call   801020a0 <namei>
80103c16:	89 43 74             	mov    %eax,0x74(%ebx)
  acquire(&ptable.lock);
80103c19:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c20:	e8 8b 15 00 00       	call   801051b0 <acquire>
  p->state = RUNNABLE;
80103c25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->que_id = RR;
80103c2c:	c7 43 28 01 00 00 00 	movl   $0x1,0x28(%ebx)
  release(&ptable.lock);
80103c33:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c3a:	e8 11 15 00 00       	call   80105150 <release>
}
80103c3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c42:	83 c4 10             	add    $0x10,%esp
80103c45:	c9                   	leave  
80103c46:	c3                   	ret    
    panic("userinit: out of memory?");
80103c47:	83 ec 0c             	sub    $0xc,%esp
80103c4a:	68 77 8a 10 80       	push   $0x80108a77
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
80103c76:	e8 f5 15 00 00       	call   80105270 <memset>
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
80103c96:	e8 d5 17 00 00       	call   80105470 <strlen>
80103c9b:	83 c4 10             	add    $0x10,%esp
80103c9e:	39 d8                	cmp    %ebx,%eax
80103ca0:	7f e6                	jg     80103c88 <print_name+0x28>
  cprintf("%s", buf);
80103ca2:	83 ec 08             	sub    $0x8,%esp
80103ca5:	57                   	push   %edi
80103ca6:	68 8e 8b 10 80       	push   $0x80108b8e
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
80103cc8:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  acquire(&ptable.lock);
80103ccd:	83 ec 0c             	sub    $0xc,%esp
80103cd0:	68 20 3d 11 80       	push   $0x80113d20
80103cd5:	e8 d6 14 00 00       	call   801051b0 <acquire>
80103cda:	83 c4 10             	add    $0x10,%esp
80103cdd:	eb 0f                	jmp    80103cee <find_proc+0x2e>
80103cdf:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ce0:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103ce6:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103cec:	74 05                	je     80103cf3 <find_proc+0x33>
    if (p->pid == pid)
80103cee:	39 73 10             	cmp    %esi,0x10(%ebx)
80103cf1:	75 ed                	jne    80103ce0 <find_proc+0x20>
  release(&ptable.lock);
80103cf3:	83 ec 0c             	sub    $0xc,%esp
80103cf6:	68 20 3d 11 80       	push   $0x80113d20
80103cfb:	e8 50 14 00 00       	call   80105150 <release>
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
80103d1b:	ff 24 85 50 8c 10 80 	jmp    *-0x7fef73b0(,%eax,4)
80103d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("RUNNING   ");
80103d28:	c7 45 08 c7 8a 10 80 	movl   $0x80108ac7,0x8(%ebp)
}
80103d2f:	5d                   	pop    %ebp
    cprintf("RUNNING   ");
80103d30:	e9 6b c9 ff ff       	jmp    801006a0 <cprintf>
80103d35:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("ZOMBIE    ");
80103d38:	c7 45 08 d2 8a 10 80 	movl   $0x80108ad2,0x8(%ebp)
}
80103d3f:	5d                   	pop    %ebp
    cprintf("ZOMBIE    ");
80103d40:	e9 5b c9 ff ff       	jmp    801006a0 <cprintf>
80103d45:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("UNUSED    ");
80103d48:	c7 45 08 9b 8a 10 80 	movl   $0x80108a9b,0x8(%ebp)
}
80103d4f:	5d                   	pop    %ebp
    cprintf("UNUSED    ");
80103d50:	e9 4b c9 ff ff       	jmp    801006a0 <cprintf>
80103d55:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("EMBRYO    ");
80103d58:	c7 45 08 a6 8a 10 80 	movl   $0x80108aa6,0x8(%ebp)
}
80103d5f:	5d                   	pop    %ebp
    cprintf("EMBRYO    ");
80103d60:	e9 3b c9 ff ff       	jmp    801006a0 <cprintf>
80103d65:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("SLEEPING  ");
80103d68:	c7 45 08 b1 8a 10 80 	movl   $0x80108ab1,0x8(%ebp)
}
80103d6f:	5d                   	pop    %ebp
    cprintf("SLEEPING  ");
80103d70:	e9 2b c9 ff ff       	jmp    801006a0 <cprintf>
80103d75:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("RUNNABLE  ");
80103d78:	c7 45 08 bc 8a 10 80 	movl   $0x80108abc,0x8(%ebp)
}
80103d7f:	5d                   	pop    %ebp
    cprintf("RUNNABLE  ");
80103d80:	e9 1b c9 ff ff       	jmp    801006a0 <cprintf>
    cprintf("damn ways to die");
80103d85:	c7 45 08 dd 8a 10 80 	movl   $0x80108add,0x8(%ebp)
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
80103db6:	68 03 8b 10 80       	push   $0x80108b03
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
80103dde:	68 20 3d 11 80       	push   $0x80113d20
80103de3:	e8 c8 13 00 00       	call   801051b0 <acquire>
  cprintf("process_name PID State   Queue Cycle Arrival Priority R_prty R_Arvl R_exec Rank\n");
80103de8:	c7 04 24 fc 8b 10 80 	movl   $0x80108bfc,(%esp)
80103def:	e8 ac c8 ff ff       	call   801006a0 <cprintf>
80103df4:	83 c4 10             	add    $0x10,%esp
80103df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dfe:	66 90                	xchg   %ax,%ax
    cprintf("-");
80103e00:	83 ec 0c             	sub    $0xc,%esp
80103e03:	68 ee 8a 10 80       	push   $0x80108aee
80103e08:	e8 93 c8 ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < 80; i++)
80103e0d:	83 c4 10             	add    $0x10,%esp
80103e10:	83 eb 01             	sub    $0x1,%ebx
80103e13:	75 eb                	jne    80103e00 <print_bitches+0x30>
  cprintf("\n");
80103e15:	83 ec 0c             	sub    $0xc,%esp
80103e18:	bb cc 3d 11 80       	mov    $0x80113dcc,%ebx
    num /= 10;
80103e1d:	be 67 66 66 66       	mov    $0x66666667,%esi
  cprintf("\n");
80103e22:	68 f7 8f 10 80       	push   $0x80108ff7
80103e27:	e8 74 c8 ff ff       	call   801006a0 <cprintf>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e2c:	83 c4 10             	add    $0x10,%esp
80103e2f:	eb 19                	jmp    80103e4a <print_bitches+0x7a>
80103e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e38:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103e3e:	81 fb cc 65 11 80    	cmp    $0x801165cc,%ebx
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
80103e5f:	68 f0 8a 10 80       	push   $0x80108af0
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
80103eae:	68 03 8b 10 80       	push   $0x80108b03
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
80103ed0:	68 f3 8a 10 80       	push   $0x80108af3
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
80103efa:	68 f0 8a 10 80       	push   $0x80108af0
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
80103f5e:	68 03 8b 10 80       	push   $0x80108b03
80103f63:	e8 38 c7 ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < num; i++)
80103f68:	83 c4 10             	add    $0x10,%esp
80103f6b:	3b 7d d8             	cmp    -0x28(%ebp),%edi
80103f6e:	7c e8                	jl     80103f58 <print_bitches+0x188>
    cprintf("%d", p->creation_time);
80103f70:	83 ec 08             	sub    $0x8,%esp
80103f73:	ff 73 a8             	push   -0x58(%ebx)
80103f76:	68 f0 8a 10 80       	push   $0x80108af0
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
80103fbe:	68 03 8b 10 80       	push   $0x80108b03
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
80103fdc:	68 fb 8a 10 80       	push   $0x80108afb
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
80104009:	68 f3 8a 10 80       	push   $0x80108af3
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
80104036:	68 05 8b 10 80       	push   $0x80108b05
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
80104060:	68 0e 8b 10 80       	push   $0x80108b0e
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
801040c2:	68 f0 8a 10 80       	push   $0x80108af0
801040c7:	e8 d4 c5 ff ff       	call   801006a0 <cprintf>
    cprintf("\n");
801040cc:	c7 04 24 f7 8f 10 80 	movl   $0x80108ff7,(%esp)
801040d3:	e8 c8 c5 ff ff       	call   801006a0 <cprintf>
801040d8:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040db:	81 fb cc 65 11 80    	cmp    $0x801165cc,%ebx
801040e1:	0f 85 63 fd ff ff    	jne    80103e4a <print_bitches+0x7a>
  release(&ptable.lock);
801040e7:	83 ec 0c             	sub    $0xc,%esp
801040ea:	68 20 3d 11 80       	push   $0x80113d20
801040ef:	e8 5c 10 00 00       	call   80105150 <release>
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
80104139:	68 20 3d 11 80       	push   $0x80113d20
8010413e:	e8 6d 10 00 00       	call   801051b0 <acquire>
    if (p->parent->pid == father->pid)
80104143:	8b 45 08             	mov    0x8(%ebp),%eax
80104146:	83 c4 10             	add    $0x10,%esp
80104149:	8b 48 10             	mov    0x10(%eax),%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010414c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
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
8010416b:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80104170:	75 e6                	jne    80104158 <count_child+0x28>
  release(&ptable.lock);
80104172:	83 ec 0c             	sub    $0xc,%esp
80104175:	68 20 3d 11 80       	push   $0x80113d20
8010417a:	e8 d1 0f 00 00       	call   80105150 <release>
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
80104198:	e8 c3 0e 00 00       	call   80105060 <pushcli>
  c = mycpu();
8010419d:	e8 ee f7 ff ff       	call   80103990 <mycpu>
  p = c->proc;
801041a2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041a8:	e8 03 0f 00 00       	call   801050b0 <popcli>
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
801041bb:	e8 70 3a 00 00       	call   80107c30 <switchuvm>
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
801041da:	e8 d1 3c 00 00       	call   80107eb0 <allocuvm>
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
801041fa:	e8 11 3f 00 00       	call   80108110 <deallocuvm>
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
80104219:	e8 42 0e 00 00       	call   80105060 <pushcli>
  c = mycpu();
8010421e:	e8 6d f7 ff ff       	call   80103990 <mycpu>
  p = c->proc;
80104223:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104229:	e8 82 0e 00 00       	call   801050b0 <popcli>
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
80104248:	e8 63 40 00 00       	call   801082b0 <copyuvm>
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
801042c1:	e8 6a 11 00 00       	call   80105430 <safestrcpy>
  pid = np->pid;
801042c6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801042c9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801042d0:	e8 db 0e 00 00       	call   801051b0 <acquire>
  np->state = RUNNABLE;
801042d5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  acquire(&tickslock);
801042dc:	c7 04 24 00 68 11 80 	movl   $0x80116800,(%esp)
801042e3:	e8 c8 0e 00 00       	call   801051b0 <acquire>
  np->creation_time = ticks;
801042e8:	a1 e0 67 11 80       	mov    0x801167e0,%eax
801042ed:	89 47 20             	mov    %eax,0x20(%edi)
  np->preemption_time = ticks;
801042f0:	89 47 24             	mov    %eax,0x24(%edi)
  release(&tickslock);
801042f3:	c7 04 24 00 68 11 80 	movl   $0x80116800,(%esp)
801042fa:	e8 51 0e 00 00       	call   80105150 <release>
  release(&ptable.lock);
801042ff:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104306:	e8 45 0e 00 00       	call   80105150 <release>
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
80104356:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
{
8010435b:	89 e5                	mov    %esp,%ebp
8010435d:	56                   	push   %esi
  struct proc *res = 0;
8010435e:	31 f6                	xor    %esi,%esi
{
80104360:	53                   	push   %ebx
  int now = ticks;
80104361:	8b 1d e0 67 11 80    	mov    0x801167e0,%ebx
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
80104395:	3d 54 65 11 80       	cmp    $0x80116554,%eax
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
801043b6:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
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
801043e5:	3d 54 65 11 80       	cmp    $0x80116554,%eax
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
80104400:	d9 05 84 8c 10 80    	flds   0x80108c84
  struct proc *res = 0;
80104406:	31 d2                	xor    %edx,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104408:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
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
8010447f:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80104484:	74 1c                	je     801044a2 <best_job_first+0xa2>
    if (p->state != RUNNABLE || p->que_id != BJF)
80104486:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010448a:	75 ee                	jne    8010447a <best_job_first+0x7a>
8010448c:	83 78 28 03          	cmpl   $0x3,0x28(%eax)
80104490:	74 99                	je     8010442b <best_job_first+0x2b>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104492:	05 a0 00 00 00       	add    $0xa0,%eax
80104497:	3d 54 65 11 80       	cmp    $0x80116554,%eax
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
801044b5:	3d 54 65 11 80       	cmp    $0x80116554,%eax
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
801044f6:	68 20 3d 11 80       	push   $0x80113d20
801044fb:	e8 b0 0c 00 00       	call   801051b0 <acquire>
  int now = ticks;
80104500:	8b 3d e0 67 11 80    	mov    0x801167e0,%edi
80104506:	83 c4 10             	add    $0x10,%esp
  int max_diff = MIN_INT;
80104509:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010450e:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
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
8010453d:	3d 54 65 11 80       	cmp    $0x80116554,%eax
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
80104552:	e8 d9 36 00 00       	call   80107c30 <switchuvm>
    p->executed_cycle += 0.1f;
80104557:	d9 05 80 8c 10 80    	flds   0x80108c80
8010455d:	d8 86 94 00 00 00    	fadds  0x94(%esi)
    p->state = RUNNING;
80104563:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
    p->preemption_time = ticks;
8010456a:	a1 e0 67 11 80       	mov    0x801167e0,%eax
8010456f:	89 46 24             	mov    %eax,0x24(%esi)
    p->executed_cycle += 0.1f;
80104572:	d9 9e 94 00 00 00    	fstps  0x94(%esi)
    swtch(&(c->scheduler), p->context);
80104578:	58                   	pop    %eax
80104579:	5a                   	pop    %edx
8010457a:	ff 76 1c             	push   0x1c(%esi)
8010457d:	ff 75 dc             	push   -0x24(%ebp)
80104580:	e8 06 0f 00 00       	call   8010548b <swtch>
    switchkvm();
80104585:	e8 96 36 00 00       	call   80107c20 <switchkvm>
    c->proc = 0;
8010458a:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104591:	00 00 00 
    release(&ptable.lock);
80104594:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010459b:	e8 b0 0b 00 00       	call   80105150 <release>
801045a0:	83 c4 10             	add    $0x10,%esp
801045a3:	e9 48 ff ff ff       	jmp    801044f0 <scheduler+0x20>
  int latest_time = MIN_INT;
801045a8:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045ad:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
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
801045d5:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801045da:	75 dc                	jne    801045b8 <scheduler+0xe8>
    if (p == 0)
801045dc:	85 f6                	test   %esi,%esi
801045de:	0f 85 64 ff ff ff    	jne    80104548 <scheduler+0x78>
  float min_rank = (float)MAX_INT;
801045e4:	d9 05 84 8c 10 80    	flds   0x80108c84
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045ea:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
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
80104655:	3d 54 65 11 80       	cmp    $0x80116554,%eax
8010465a:	75 94                	jne    801045f0 <scheduler+0x120>
8010465c:	dd d8                	fstp   %st(0)
    if (p == 0)
8010465e:	85 f6                	test   %esi,%esi
80104660:	0f 85 e2 fe ff ff    	jne    80104548 <scheduler+0x78>
      release(&ptable.lock);
80104666:	83 ec 0c             	sub    $0xc,%esp
80104669:	68 20 3d 11 80       	push   $0x80113d20
8010466e:	e8 dd 0a 00 00       	call   80105150 <release>
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
80104685:	e8 d6 09 00 00       	call   80105060 <pushcli>
  c = mycpu();
8010468a:	e8 01 f3 ff ff       	call   80103990 <mycpu>
  p = c->proc;
8010468f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104695:	e8 16 0a 00 00       	call   801050b0 <popcli>
  if (!holding(&ptable.lock))
8010469a:	83 ec 0c             	sub    $0xc,%esp
8010469d:	68 20 3d 11 80       	push   $0x80113d20
801046a2:	e8 69 0a 00 00       	call   80105110 <holding>
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
801046e3:	e8 a3 0d 00 00       	call   8010548b <swtch>
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
80104700:	68 14 8b 10 80       	push   $0x80108b14
80104705:	e8 76 bc ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010470a:	83 ec 0c             	sub    $0xc,%esp
8010470d:	68 40 8b 10 80       	push   $0x80108b40
80104712:	e8 69 bc ff ff       	call   80100380 <panic>
    panic("sched running");
80104717:	83 ec 0c             	sub    $0xc,%esp
8010471a:	68 32 8b 10 80       	push   $0x80108b32
8010471f:	e8 5c bc ff ff       	call   80100380 <panic>
    panic("sched locks");
80104724:	83 ec 0c             	sub    $0xc,%esp
80104727:	68 26 8b 10 80       	push   $0x80108b26
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
8010474e:	39 05 c4 67 11 80    	cmp    %eax,0x801167c4
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
801047a3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801047aa:	e8 01 0a 00 00       	call   801051b0 <acquire>
  wakeup1(curproc->parent);
801047af:	8b 53 14             	mov    0x14(%ebx),%edx
801047b2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047b5:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801047ba:	eb 10                	jmp    801047cc <exit+0x8c>
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047c0:	05 a0 00 00 00       	add    $0xa0,%eax
801047c5:	3d 54 65 11 80       	cmp    $0x80116554,%eax
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
801047e3:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801047e8:	75 e2                	jne    801047cc <exit+0x8c>
      p->parent = initproc;
801047ea:	8b 0d c4 67 11 80    	mov    0x801167c4,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047f0:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
801047f5:	eb 17                	jmp    8010480e <exit+0xce>
801047f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047fe:	66 90                	xchg   %ax,%ax
80104800:	81 c2 a0 00 00 00    	add    $0xa0,%edx
80104806:	81 fa 54 65 11 80    	cmp    $0x80116554,%edx
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
8010481c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104821:	eb 11                	jmp    80104834 <exit+0xf4>
80104823:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104827:	90                   	nop
80104828:	05 a0 00 00 00       	add    $0xa0,%eax
8010482d:	3d 54 65 11 80       	cmp    $0x80116554,%eax
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
80104857:	68 61 8b 10 80       	push   $0x80108b61
8010485c:	e8 1f bb ff ff       	call   80100380 <panic>
    panic("init exiting");
80104861:	83 ec 0c             	sub    $0xc,%esp
80104864:	68 54 8b 10 80       	push   $0x80108b54
80104869:	e8 12 bb ff ff       	call   80100380 <panic>
8010486e:	66 90                	xchg   %ax,%ax

80104870 <wait>:
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
  pushcli();
80104875:	e8 e6 07 00 00       	call   80105060 <pushcli>
  c = mycpu();
8010487a:	e8 11 f1 ff ff       	call   80103990 <mycpu>
  p = c->proc;
8010487f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104885:	e8 26 08 00 00       	call   801050b0 <popcli>
  acquire(&ptable.lock);
8010488a:	83 ec 0c             	sub    $0xc,%esp
8010488d:	68 20 3d 11 80       	push   $0x80113d20
80104892:	e8 19 09 00 00       	call   801051b0 <acquire>
80104897:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010489a:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010489c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
801048a1:	eb 13                	jmp    801048b6 <wait+0x46>
801048a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048a7:	90                   	nop
801048a8:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
801048ae:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
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
801048cc:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
801048d2:	75 e2                	jne    801048b6 <wait+0x46>
    if (!havekids || curproc->killed)
801048d4:	85 c0                	test   %eax,%eax
801048d6:	0f 84 9a 00 00 00    	je     80104976 <wait+0x106>
801048dc:	8b 46 30             	mov    0x30(%esi),%eax
801048df:	85 c0                	test   %eax,%eax
801048e1:	0f 85 8f 00 00 00    	jne    80104976 <wait+0x106>
  pushcli();
801048e7:	e8 74 07 00 00       	call   80105060 <pushcli>
  c = mycpu();
801048ec:	e8 9f f0 ff ff       	call   80103990 <mycpu>
  p = c->proc;
801048f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048f7:	e8 b4 07 00 00       	call   801050b0 <popcli>
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
80104939:	e8 02 38 00 00       	call   80108140 <freevm>
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
8010495e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104965:	e8 e6 07 00 00       	call   80105150 <release>
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
8010497e:	68 20 3d 11 80       	push   $0x80113d20
80104983:	e8 c8 07 00 00       	call   80105150 <release>
      return -1;
80104988:	83 c4 10             	add    $0x10,%esp
8010498b:	eb e0                	jmp    8010496d <wait+0xfd>
    panic("sleep");
8010498d:	83 ec 0c             	sub    $0xc,%esp
80104990:	68 6d 8b 10 80       	push   $0x80108b6d
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
801049a8:	68 20 3d 11 80       	push   $0x80113d20
801049ad:	e8 fe 07 00 00       	call   801051b0 <acquire>
  pushcli();
801049b2:	e8 a9 06 00 00       	call   80105060 <pushcli>
  c = mycpu();
801049b7:	e8 d4 ef ff ff       	call   80103990 <mycpu>
  p = c->proc;
801049bc:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801049c2:	e8 e9 06 00 00       	call   801050b0 <popcli>
  myproc()->preemption_time = ticks;
801049c7:	8b 35 e0 67 11 80    	mov    0x801167e0,%esi
  myproc()->state = RUNNABLE;
801049cd:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pushcli();
801049d4:	e8 87 06 00 00       	call   80105060 <pushcli>
  c = mycpu();
801049d9:	e8 b2 ef ff ff       	call   80103990 <mycpu>
  p = c->proc;
801049de:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801049e4:	e8 c7 06 00 00       	call   801050b0 <popcli>
  myproc()->preemption_time = ticks;
801049e9:	89 73 24             	mov    %esi,0x24(%ebx)
  pushcli();
801049ec:	e8 6f 06 00 00       	call   80105060 <pushcli>
  c = mycpu();
801049f1:	e8 9a ef ff ff       	call   80103990 <mycpu>
  p = c->proc;
801049f6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801049fc:	e8 af 06 00 00       	call   801050b0 <popcli>
  myproc()->executed_cycle += 0.1;
80104a01:	dd 05 88 8c 10 80    	fldl   0x80108c88
80104a07:	d8 83 94 00 00 00    	fadds  0x94(%ebx)
80104a0d:	d9 9b 94 00 00 00    	fstps  0x94(%ebx)
  sched();
80104a13:	e8 68 fc ff ff       	call   80104680 <sched>
  release(&ptable.lock);
80104a18:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104a1f:	e8 2c 07 00 00       	call   80105150 <release>
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
80104a3f:	e8 1c 06 00 00       	call   80105060 <pushcli>
  c = mycpu();
80104a44:	e8 47 ef ff ff       	call   80103990 <mycpu>
  p = c->proc;
80104a49:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a4f:	e8 5c 06 00 00       	call   801050b0 <popcli>
  if (p == 0)
80104a54:	85 db                	test   %ebx,%ebx
80104a56:	0f 84 87 00 00 00    	je     80104ae3 <sleep+0xb3>
  if (lk == 0)
80104a5c:	85 f6                	test   %esi,%esi
80104a5e:	74 76                	je     80104ad6 <sleep+0xa6>
  if (lk != &ptable.lock)
80104a60:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80104a66:	74 50                	je     80104ab8 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
80104a68:	83 ec 0c             	sub    $0xc,%esp
80104a6b:	68 20 3d 11 80       	push   $0x80113d20
80104a70:	e8 3b 07 00 00       	call   801051b0 <acquire>
    release(lk);
80104a75:	89 34 24             	mov    %esi,(%esp)
80104a78:	e8 d3 06 00 00       	call   80105150 <release>
  p->chan = chan;
80104a7d:	89 7b 2c             	mov    %edi,0x2c(%ebx)
  p->state = SLEEPING;
80104a80:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104a87:	e8 f4 fb ff ff       	call   80104680 <sched>
  p->chan = 0;
80104a8c:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
    release(&ptable.lock);
80104a93:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104a9a:	e8 b1 06 00 00       	call   80105150 <release>
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
80104aac:	e9 ff 06 00 00       	jmp    801051b0 <acquire>
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
80104ad9:	68 73 8b 10 80       	push   $0x80108b73
80104ade:	e8 9d b8 ff ff       	call   80100380 <panic>
    panic("sleep");
80104ae3:	83 ec 0c             	sub    $0xc,%esp
80104ae6:	68 6d 8b 10 80       	push   $0x80108b6d
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
80104afa:	68 20 3d 11 80       	push   $0x80113d20
80104aff:	e8 ac 06 00 00       	call   801051b0 <acquire>
80104b04:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b07:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104b0c:	eb 0e                	jmp    80104b1c <wakeup+0x2c>
80104b0e:	66 90                	xchg   %ax,%ax
80104b10:	05 a0 00 00 00       	add    $0xa0,%eax
80104b15:	3d 54 65 11 80       	cmp    $0x80116554,%eax
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
80104b33:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80104b38:	75 e2                	jne    80104b1c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104b3a:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104b41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b44:	c9                   	leave  
  release(&ptable.lock);
80104b45:	e9 06 06 00 00       	jmp    80105150 <release>
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
80104b5a:	68 20 3d 11 80       	push   $0x80113d20
80104b5f:	e8 4c 06 00 00       	call   801051b0 <acquire>
80104b64:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b67:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104b6c:	eb 0e                	jmp    80104b7c <kill+0x2c>
80104b6e:	66 90                	xchg   %ax,%ax
80104b70:	05 a0 00 00 00       	add    $0xa0,%eax
80104b75:	3d 54 65 11 80       	cmp    $0x80116554,%eax
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
80104b98:	68 20 3d 11 80       	push   $0x80113d20
80104b9d:	e8 ae 05 00 00       	call   80105150 <release>
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
80104bb3:	68 20 3d 11 80       	push   $0x80113d20
80104bb8:	e8 93 05 00 00       	call   80105150 <release>
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
80104bd9:	bb cc 3d 11 80       	mov    $0x80113dcc,%ebx
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
80104beb:	68 f7 8f 10 80       	push   $0x80108ff7
80104bf0:	e8 ab ba ff ff       	call   801006a0 <cprintf>
80104bf5:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bf8:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80104bfe:	81 fb cc 65 11 80    	cmp    $0x801165cc,%ebx
80104c04:	0f 84 7e 00 00 00    	je     80104c88 <procdump+0xb8>
    if (p->state == UNUSED)
80104c0a:	8b 43 94             	mov    -0x6c(%ebx),%eax
80104c0d:	85 c0                	test   %eax,%eax
80104c0f:	74 e7                	je     80104bf8 <procdump+0x28>
      state = "???";
80104c11:	ba 84 8b 10 80       	mov    $0x80108b84,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104c16:	83 f8 05             	cmp    $0x5,%eax
80104c19:	77 11                	ja     80104c2c <procdump+0x5c>
80104c1b:	8b 14 85 68 8c 10 80 	mov    -0x7fef7398(,%eax,4),%edx
      state = "???";
80104c22:	b8 84 8b 10 80       	mov    $0x80108b84,%eax
80104c27:	85 d2                	test   %edx,%edx
80104c29:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104c2c:	53                   	push   %ebx
80104c2d:	52                   	push   %edx
80104c2e:	ff 73 98             	push   -0x68(%ebx)
80104c31:	68 88 8b 10 80       	push   $0x80108b88
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
80104c58:	e8 a3 03 00 00       	call   80105000 <getcallerpcs>
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
80104c6d:	68 61 85 10 80       	push   $0x80108561
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
80104ce6:	68 90 67 11 80       	push   $0x80116790
80104ceb:	e8 c0 04 00 00       	call   801051b0 <acquire>
  for(int i = 0 ; i < NUMBER_OF_SHARED_PAGES ; i++){
80104cf0:	b8 68 65 11 80       	mov    $0x80116568,%eax
80104cf5:	83 c4 10             	add    $0x10,%esp
80104cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cff:	90                   	nop
    SharedPages.mems[i].refference_count = 0;
80104d00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i = 0 ; i < NUMBER_OF_SHARED_PAGES ; i++){
80104d06:	83 c0 38             	add    $0x38,%eax
80104d09:	3d 98 67 11 80       	cmp    $0x80116798,%eax
80104d0e:	75 f0                	jne    80104d00 <init_shared_pages+0x20>
  }
  release(&SharedPages.lock);
80104d10:	83 ec 0c             	sub    $0xc,%esp
80104d13:	68 90 67 11 80       	push   $0x80116790
80104d18:	e8 33 04 00 00       	call   80105150 <release>
}
80104d1d:	83 c4 10             	add    $0x10,%esp
80104d20:	c9                   	leave  
80104d21:	c3                   	ret    
80104d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d30 <open_sharedmem>:


int open_sharedmem(int id){
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	57                   	push   %edi
80104d34:	56                   	push   %esi
80104d35:	53                   	push   %ebx
80104d36:	83 ec 1c             	sub    $0x1c,%esp
80104d39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104d3c:	e8 1f 03 00 00       	call   80105060 <pushcli>
  c = mycpu();
80104d41:	e8 4a ec ff ff       	call   80103990 <mycpu>
  p = c->proc;
80104d46:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80104d4c:	e8 5f 03 00 00       	call   801050b0 <popcli>
  struct proc *curproc = myproc();
  int ref;
  
  acquire(&SharedPages.lock);
80104d51:	83 ec 0c             	sub    $0xc,%esp
80104d54:	68 90 67 11 80       	push   $0x80116790
80104d59:	e8 52 04 00 00       	call   801051b0 <acquire>
  if(SharedPages.mems[id].refference_count > 0){
80104d5e:	6b c3 38             	imul   $0x38,%ebx,%eax
80104d61:	83 c4 10             	add    $0x10,%esp
80104d64:	8d 90 60 65 11 80    	lea    -0x7fee9aa0(%eax),%edx
80104d6a:	8b 80 68 65 11 80    	mov    -0x7fee9a98(%eax),%eax
80104d70:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104d73:	85 c0                	test   %eax,%eax
80104d75:	7f 59                	jg     80104dd0 <open_sharedmem+0xa0>
    SharedPages.mems[id].connected_procs[SharedPages.mems[id].refference_count-1] = curproc->pid;
    return SharedPages.mems[id].frame;
  }
  else{
    
    if((ref = allocsharedmem(curproc->pgdir, HEAPLIMIT, HEAPLIMIT + 4096))== 0){
80104d77:	83 ec 04             	sub    $0x4,%esp
80104d7a:	68 00 10 00 70       	push   $0x70001000
80104d7f:	68 00 00 00 70       	push   $0x70000000
80104d84:	ff 77 04             	push   0x4(%edi)
80104d87:	e8 54 32 00 00       	call   80107fe0 <allocsharedmem>
80104d8c:	83 c4 10             	add    $0x10,%esp
80104d8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104d92:	85 c0                	test   %eax,%eax
80104d94:	89 c6                	mov    %eax,%esi
80104d96:	74 78                	je     80104e10 <open_sharedmem+0xe0>
      cprintf("gol mano azyat nakonid\n");
      release(&SharedPages.lock);
      return 0;
    }
    SharedPages.mems[id].refference_count ++;
80104d98:	8b 42 08             	mov    0x8(%edx),%eax
    SharedPages.mems[id].connected_procs[SharedPages.mems[id].refference_count-1] = curproc->pid;
    SharedPages.mems[id].frame = ref;  
  }
  release(&SharedPages.lock);
80104d9b:	83 ec 0c             	sub    $0xc,%esp
    SharedPages.mems[id].connected_procs[SharedPages.mems[id].refference_count-1] = curproc->pid;
80104d9e:	6b db 0e             	imul   $0xe,%ebx,%ebx
    SharedPages.mems[id].refference_count ++;
80104da1:	8d 48 01             	lea    0x1(%eax),%ecx
80104da4:	89 4a 08             	mov    %ecx,0x8(%edx)
    SharedPages.mems[id].connected_procs[SharedPages.mems[id].refference_count-1] = curproc->pid;
80104da7:	8b 4f 10             	mov    0x10(%edi),%ecx
80104daa:	01 c3                	add    %eax,%ebx
    SharedPages.mems[id].frame = ref;  
80104dac:	89 72 34             	mov    %esi,0x34(%edx)
  release(&SharedPages.lock);
80104daf:	68 90 67 11 80       	push   $0x80116790
    SharedPages.mems[id].connected_procs[SharedPages.mems[id].refference_count-1] = curproc->pid;
80104db4:	89 0c 9d 6c 65 11 80 	mov    %ecx,-0x7fee9a94(,%ebx,4)
  release(&SharedPages.lock);
80104dbb:	e8 90 03 00 00       	call   80105150 <release>
  return ref;
80104dc0:	83 c4 10             	add    $0x10,%esp
}
80104dc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dc6:	89 f0                	mov    %esi,%eax
80104dc8:	5b                   	pop    %ebx
80104dc9:	5e                   	pop    %esi
80104dca:	5f                   	pop    %edi
80104dcb:	5d                   	pop    %ebp
80104dcc:	c3                   	ret    
80104dcd:	8d 76 00             	lea    0x0(%esi),%esi
    release(&SharedPages.lock);
80104dd0:	83 ec 0c             	sub    $0xc,%esp
    SharedPages.mems[id].connected_procs[SharedPages.mems[id].refference_count-1] = curproc->pid;
80104dd3:	6b db 0e             	imul   $0xe,%ebx,%ebx
    release(&SharedPages.lock);
80104dd6:	68 90 67 11 80       	push   $0x80116790
80104ddb:	e8 70 03 00 00       	call   80105150 <release>
    SharedPages.mems[id].refference_count ++;
80104de0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return SharedPages.mems[id].frame;
80104de3:	83 c4 10             	add    $0x10,%esp
    SharedPages.mems[id].refference_count ++;
80104de6:	8b 42 08             	mov    0x8(%edx),%eax
    return SharedPages.mems[id].frame;
80104de9:	8b 72 34             	mov    0x34(%edx),%esi
    SharedPages.mems[id].refference_count ++;
80104dec:	8d 48 01             	lea    0x1(%eax),%ecx
    SharedPages.mems[id].connected_procs[SharedPages.mems[id].refference_count-1] = curproc->pid;
80104def:	01 c3                	add    %eax,%ebx
}
80104df1:	89 f0                	mov    %esi,%eax
    SharedPages.mems[id].refference_count ++;
80104df3:	89 4a 08             	mov    %ecx,0x8(%edx)
    SharedPages.mems[id].connected_procs[SharedPages.mems[id].refference_count-1] = curproc->pid;
80104df6:	8b 4f 10             	mov    0x10(%edi),%ecx
80104df9:	89 0c 9d 6c 65 11 80 	mov    %ecx,-0x7fee9a94(,%ebx,4)
}
80104e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e03:	5b                   	pop    %ebx
80104e04:	5e                   	pop    %esi
80104e05:	5f                   	pop    %edi
80104e06:	5d                   	pop    %ebp
80104e07:	c3                   	ret    
80104e08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0f:	90                   	nop
      cprintf("gol mano azyat nakonid\n");
80104e10:	83 ec 0c             	sub    $0xc,%esp
80104e13:	68 91 8b 10 80       	push   $0x80108b91
80104e18:	e8 83 b8 ff ff       	call   801006a0 <cprintf>
      release(&SharedPages.lock);
80104e1d:	c7 04 24 90 67 11 80 	movl   $0x80116790,(%esp)
80104e24:	e8 27 03 00 00       	call   80105150 <release>
      return 0;
80104e29:	83 c4 10             	add    $0x10,%esp
}
80104e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e2f:	89 f0                	mov    %esi,%eax
80104e31:	5b                   	pop    %ebx
80104e32:	5e                   	pop    %esi
80104e33:	5f                   	pop    %edi
80104e34:	5d                   	pop    %ebp
80104e35:	c3                   	ret    
80104e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi

80104e40 <close_sharedmem>:



void close_sharedmem(int id){
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	57                   	push   %edi
80104e44:	56                   	push   %esi
80104e45:	53                   	push   %ebx
80104e46:	83 ec 0c             	sub    $0xc,%esp
80104e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104e4c:	e8 0f 02 00 00       	call   80105060 <pushcli>
  c = mycpu();
80104e51:	e8 3a eb ff ff       	call   80103990 <mycpu>
  struct proc* cur_proc = myproc();
  if(SharedPages.mems[id].refference_count == 1){
80104e56:	6b f3 38             	imul   $0x38,%ebx,%esi
  p = c->proc;
80104e59:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80104e5f:	e8 4c 02 00 00       	call   801050b0 <popcli>
  if(SharedPages.mems[id].refference_count == 1){
80104e64:	8b 86 68 65 11 80    	mov    -0x7fee9a98(%esi),%eax
80104e6a:	81 c6 60 65 11 80    	add    $0x80116560,%esi
80104e70:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e73:	83 f8 01             	cmp    $0x1,%eax
80104e76:	74 18                	je     80104e90 <close_sharedmem+0x50>
    SharedPages.mems[id].frame = deallocuvm(cur_proc->pgdir, HEAPLIMIT + 4096, HEAPLIMIT);
    SharedPages.mems[id].refference_count = 0;
80104e78:	6b db 38             	imul   $0x38,%ebx,%ebx
80104e7b:	89 93 68 65 11 80    	mov    %edx,-0x7fee9a98(%ebx)
  }
  else{
    SharedPages.mems[id].refference_count --;
  }
80104e81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e84:	5b                   	pop    %ebx
80104e85:	5e                   	pop    %esi
80104e86:	5f                   	pop    %edi
80104e87:	5d                   	pop    %ebp
80104e88:	c3                   	ret    
80104e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SharedPages.mems[id].frame = deallocuvm(cur_proc->pgdir, HEAPLIMIT + 4096, HEAPLIMIT);
80104e90:	83 ec 04             	sub    $0x4,%esp
80104e93:	68 00 00 00 70       	push   $0x70000000
80104e98:	68 00 10 00 70       	push   $0x70001000
80104e9d:	ff 77 04             	push   0x4(%edi)
80104ea0:	e8 6b 32 00 00       	call   80108110 <deallocuvm>
80104ea5:	83 c4 10             	add    $0x10,%esp
80104ea8:	31 d2                	xor    %edx,%edx
80104eaa:	89 46 34             	mov    %eax,0x34(%esi)
    SharedPages.mems[id].refference_count = 0;
80104ead:	eb c9                	jmp    80104e78 <close_sharedmem+0x38>
80104eaf:	90                   	nop

80104eb0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	53                   	push   %ebx
80104eb4:	83 ec 0c             	sub    $0xc,%esp
80104eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104eba:	68 90 8c 10 80       	push   $0x80108c90
80104ebf:	8d 43 04             	lea    0x4(%ebx),%eax
80104ec2:	50                   	push   %eax
80104ec3:	e8 18 01 00 00       	call   80104fe0 <initlock>
  lk->name = name;
80104ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104ecb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104ed1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104ed4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104edb:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104ede:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ee1:	c9                   	leave  
80104ee2:	c3                   	ret    
80104ee3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ef0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	56                   	push   %esi
80104ef4:	53                   	push   %ebx
80104ef5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ef8:	8d 73 04             	lea    0x4(%ebx),%esi
80104efb:	83 ec 0c             	sub    $0xc,%esp
80104efe:	56                   	push   %esi
80104eff:	e8 ac 02 00 00       	call   801051b0 <acquire>
  while (lk->locked) {
80104f04:	8b 13                	mov    (%ebx),%edx
80104f06:	83 c4 10             	add    $0x10,%esp
80104f09:	85 d2                	test   %edx,%edx
80104f0b:	74 16                	je     80104f23 <acquiresleep+0x33>
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104f10:	83 ec 08             	sub    $0x8,%esp
80104f13:	56                   	push   %esi
80104f14:	53                   	push   %ebx
80104f15:	e8 16 fb ff ff       	call   80104a30 <sleep>
  while (lk->locked) {
80104f1a:	8b 03                	mov    (%ebx),%eax
80104f1c:	83 c4 10             	add    $0x10,%esp
80104f1f:	85 c0                	test   %eax,%eax
80104f21:	75 ed                	jne    80104f10 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104f23:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104f29:	e8 c2 eb ff ff       	call   80103af0 <myproc>
80104f2e:	8b 40 10             	mov    0x10(%eax),%eax
80104f31:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104f34:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104f37:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f3a:	5b                   	pop    %ebx
80104f3b:	5e                   	pop    %esi
80104f3c:	5d                   	pop    %ebp
  release(&lk->lk);
80104f3d:	e9 0e 02 00 00       	jmp    80105150 <release>
80104f42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f50 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	53                   	push   %ebx
80104f55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104f58:	8d 73 04             	lea    0x4(%ebx),%esi
80104f5b:	83 ec 0c             	sub    $0xc,%esp
80104f5e:	56                   	push   %esi
80104f5f:	e8 4c 02 00 00       	call   801051b0 <acquire>
  lk->locked = 0;
80104f64:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104f6a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104f71:	89 1c 24             	mov    %ebx,(%esp)
80104f74:	e8 77 fb ff ff       	call   80104af0 <wakeup>
  release(&lk->lk);
80104f79:	89 75 08             	mov    %esi,0x8(%ebp)
80104f7c:	83 c4 10             	add    $0x10,%esp
}
80104f7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f82:	5b                   	pop    %ebx
80104f83:	5e                   	pop    %esi
80104f84:	5d                   	pop    %ebp
  release(&lk->lk);
80104f85:	e9 c6 01 00 00       	jmp    80105150 <release>
80104f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f90 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	57                   	push   %edi
80104f94:	31 ff                	xor    %edi,%edi
80104f96:	56                   	push   %esi
80104f97:	53                   	push   %ebx
80104f98:	83 ec 18             	sub    $0x18,%esp
80104f9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104f9e:	8d 73 04             	lea    0x4(%ebx),%esi
80104fa1:	56                   	push   %esi
80104fa2:	e8 09 02 00 00       	call   801051b0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104fa7:	8b 03                	mov    (%ebx),%eax
80104fa9:	83 c4 10             	add    $0x10,%esp
80104fac:	85 c0                	test   %eax,%eax
80104fae:	75 18                	jne    80104fc8 <holdingsleep+0x38>
  release(&lk->lk);
80104fb0:	83 ec 0c             	sub    $0xc,%esp
80104fb3:	56                   	push   %esi
80104fb4:	e8 97 01 00 00       	call   80105150 <release>
  return r;
}
80104fb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fbc:	89 f8                	mov    %edi,%eax
80104fbe:	5b                   	pop    %ebx
80104fbf:	5e                   	pop    %esi
80104fc0:	5f                   	pop    %edi
80104fc1:	5d                   	pop    %ebp
80104fc2:	c3                   	ret    
80104fc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fc7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104fc8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104fcb:	e8 20 eb ff ff       	call   80103af0 <myproc>
80104fd0:	39 58 10             	cmp    %ebx,0x10(%eax)
80104fd3:	0f 94 c0             	sete   %al
80104fd6:	0f b6 c0             	movzbl %al,%eax
80104fd9:	89 c7                	mov    %eax,%edi
80104fdb:	eb d3                	jmp    80104fb0 <holdingsleep+0x20>
80104fdd:	66 90                	xchg   %ax,%ax
80104fdf:	90                   	nop

80104fe0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104fe6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104fe9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104fef:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104ff2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104ff9:	5d                   	pop    %ebp
80104ffa:	c3                   	ret    
80104ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fff:	90                   	nop

80105000 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105000:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105001:	31 d2                	xor    %edx,%edx
{
80105003:	89 e5                	mov    %esp,%ebp
80105005:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105006:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105009:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010500c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010500f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105010:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105016:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010501c:	77 1a                	ja     80105038 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010501e:	8b 58 04             	mov    0x4(%eax),%ebx
80105021:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105024:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105027:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105029:	83 fa 0a             	cmp    $0xa,%edx
8010502c:	75 e2                	jne    80105010 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010502e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105031:	c9                   	leave  
80105032:	c3                   	ret    
80105033:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105037:	90                   	nop
  for(; i < 10; i++)
80105038:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010503b:	8d 51 28             	lea    0x28(%ecx),%edx
8010503e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105040:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105046:	83 c0 04             	add    $0x4,%eax
80105049:	39 d0                	cmp    %edx,%eax
8010504b:	75 f3                	jne    80105040 <getcallerpcs+0x40>
}
8010504d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105050:	c9                   	leave  
80105051:	c3                   	ret    
80105052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105060 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	53                   	push   %ebx
80105064:	83 ec 04             	sub    $0x4,%esp
80105067:	9c                   	pushf  
80105068:	5b                   	pop    %ebx
  asm volatile("cli");
80105069:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010506a:	e8 21 e9 ff ff       	call   80103990 <mycpu>
8010506f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105075:	85 c0                	test   %eax,%eax
80105077:	74 17                	je     80105090 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80105079:	e8 12 e9 ff ff       	call   80103990 <mycpu>
8010507e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105085:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105088:	c9                   	leave  
80105089:	c3                   	ret    
8010508a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80105090:	e8 fb e8 ff ff       	call   80103990 <mycpu>
80105095:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010509b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801050a1:	eb d6                	jmp    80105079 <pushcli+0x19>
801050a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050b0 <popcli>:

void
popcli(void)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801050b6:	9c                   	pushf  
801050b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801050b8:	f6 c4 02             	test   $0x2,%ah
801050bb:	75 35                	jne    801050f2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801050bd:	e8 ce e8 ff ff       	call   80103990 <mycpu>
801050c2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801050c9:	78 34                	js     801050ff <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801050cb:	e8 c0 e8 ff ff       	call   80103990 <mycpu>
801050d0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801050d6:	85 d2                	test   %edx,%edx
801050d8:	74 06                	je     801050e0 <popcli+0x30>
    sti();
}
801050da:	c9                   	leave  
801050db:	c3                   	ret    
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801050e0:	e8 ab e8 ff ff       	call   80103990 <mycpu>
801050e5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801050eb:	85 c0                	test   %eax,%eax
801050ed:	74 eb                	je     801050da <popcli+0x2a>
  asm volatile("sti");
801050ef:	fb                   	sti    
}
801050f0:	c9                   	leave  
801050f1:	c3                   	ret    
    panic("popcli - interruptible");
801050f2:	83 ec 0c             	sub    $0xc,%esp
801050f5:	68 9b 8c 10 80       	push   $0x80108c9b
801050fa:	e8 81 b2 ff ff       	call   80100380 <panic>
    panic("popcli");
801050ff:	83 ec 0c             	sub    $0xc,%esp
80105102:	68 b2 8c 10 80       	push   $0x80108cb2
80105107:	e8 74 b2 ff ff       	call   80100380 <panic>
8010510c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105110 <holding>:
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	56                   	push   %esi
80105114:	53                   	push   %ebx
80105115:	8b 75 08             	mov    0x8(%ebp),%esi
80105118:	31 db                	xor    %ebx,%ebx
  pushcli();
8010511a:	e8 41 ff ff ff       	call   80105060 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010511f:	8b 06                	mov    (%esi),%eax
80105121:	85 c0                	test   %eax,%eax
80105123:	75 0b                	jne    80105130 <holding+0x20>
  popcli();
80105125:	e8 86 ff ff ff       	call   801050b0 <popcli>
}
8010512a:	89 d8                	mov    %ebx,%eax
8010512c:	5b                   	pop    %ebx
8010512d:	5e                   	pop    %esi
8010512e:	5d                   	pop    %ebp
8010512f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80105130:	8b 5e 08             	mov    0x8(%esi),%ebx
80105133:	e8 58 e8 ff ff       	call   80103990 <mycpu>
80105138:	39 c3                	cmp    %eax,%ebx
8010513a:	0f 94 c3             	sete   %bl
  popcli();
8010513d:	e8 6e ff ff ff       	call   801050b0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105142:	0f b6 db             	movzbl %bl,%ebx
}
80105145:	89 d8                	mov    %ebx,%eax
80105147:	5b                   	pop    %ebx
80105148:	5e                   	pop    %esi
80105149:	5d                   	pop    %ebp
8010514a:	c3                   	ret    
8010514b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010514f:	90                   	nop

80105150 <release>:
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	56                   	push   %esi
80105154:	53                   	push   %ebx
80105155:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105158:	e8 03 ff ff ff       	call   80105060 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010515d:	8b 03                	mov    (%ebx),%eax
8010515f:	85 c0                	test   %eax,%eax
80105161:	75 15                	jne    80105178 <release+0x28>
  popcli();
80105163:	e8 48 ff ff ff       	call   801050b0 <popcli>
    panic("release");
80105168:	83 ec 0c             	sub    $0xc,%esp
8010516b:	68 b9 8c 10 80       	push   $0x80108cb9
80105170:	e8 0b b2 ff ff       	call   80100380 <panic>
80105175:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105178:	8b 73 08             	mov    0x8(%ebx),%esi
8010517b:	e8 10 e8 ff ff       	call   80103990 <mycpu>
80105180:	39 c6                	cmp    %eax,%esi
80105182:	75 df                	jne    80105163 <release+0x13>
  popcli();
80105184:	e8 27 ff ff ff       	call   801050b0 <popcli>
  lk->pcs[0] = 0;
80105189:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105190:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105197:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010519c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801051a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051a5:	5b                   	pop    %ebx
801051a6:	5e                   	pop    %esi
801051a7:	5d                   	pop    %ebp
  popcli();
801051a8:	e9 03 ff ff ff       	jmp    801050b0 <popcli>
801051ad:	8d 76 00             	lea    0x0(%esi),%esi

801051b0 <acquire>:
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	53                   	push   %ebx
801051b4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801051b7:	e8 a4 fe ff ff       	call   80105060 <pushcli>
  if(holding(lk))
801051bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801051bf:	e8 9c fe ff ff       	call   80105060 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801051c4:	8b 03                	mov    (%ebx),%eax
801051c6:	85 c0                	test   %eax,%eax
801051c8:	75 7e                	jne    80105248 <acquire+0x98>
  popcli();
801051ca:	e8 e1 fe ff ff       	call   801050b0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801051cf:	b9 01 00 00 00       	mov    $0x1,%ecx
801051d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801051d8:	8b 55 08             	mov    0x8(%ebp),%edx
801051db:	89 c8                	mov    %ecx,%eax
801051dd:	f0 87 02             	lock xchg %eax,(%edx)
801051e0:	85 c0                	test   %eax,%eax
801051e2:	75 f4                	jne    801051d8 <acquire+0x28>
  __sync_synchronize();
801051e4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801051e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801051ec:	e8 9f e7 ff ff       	call   80103990 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801051f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801051f4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801051f6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801051f9:	31 c0                	xor    %eax,%eax
801051fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105200:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105206:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010520c:	77 1a                	ja     80105228 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010520e:	8b 5a 04             	mov    0x4(%edx),%ebx
80105211:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105215:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105218:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010521a:	83 f8 0a             	cmp    $0xa,%eax
8010521d:	75 e1                	jne    80105200 <acquire+0x50>
}
8010521f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105222:	c9                   	leave  
80105223:	c3                   	ret    
80105224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105228:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010522c:	8d 51 34             	lea    0x34(%ecx),%edx
8010522f:	90                   	nop
    pcs[i] = 0;
80105230:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105236:	83 c0 04             	add    $0x4,%eax
80105239:	39 c2                	cmp    %eax,%edx
8010523b:	75 f3                	jne    80105230 <acquire+0x80>
}
8010523d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105240:	c9                   	leave  
80105241:	c3                   	ret    
80105242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105248:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010524b:	e8 40 e7 ff ff       	call   80103990 <mycpu>
80105250:	39 c3                	cmp    %eax,%ebx
80105252:	0f 85 72 ff ff ff    	jne    801051ca <acquire+0x1a>
  popcli();
80105258:	e8 53 fe ff ff       	call   801050b0 <popcli>
    panic("acquire");
8010525d:	83 ec 0c             	sub    $0xc,%esp
80105260:	68 c1 8c 10 80       	push   $0x80108cc1
80105265:	e8 16 b1 ff ff       	call   80100380 <panic>
8010526a:	66 90                	xchg   %ax,%ax
8010526c:	66 90                	xchg   %ax,%ax
8010526e:	66 90                	xchg   %ax,%ax

80105270 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	57                   	push   %edi
80105274:	8b 55 08             	mov    0x8(%ebp),%edx
80105277:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010527a:	53                   	push   %ebx
8010527b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010527e:	89 d7                	mov    %edx,%edi
80105280:	09 cf                	or     %ecx,%edi
80105282:	83 e7 03             	and    $0x3,%edi
80105285:	75 29                	jne    801052b0 <memset+0x40>
    c &= 0xFF;
80105287:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010528a:	c1 e0 18             	shl    $0x18,%eax
8010528d:	89 fb                	mov    %edi,%ebx
8010528f:	c1 e9 02             	shr    $0x2,%ecx
80105292:	c1 e3 10             	shl    $0x10,%ebx
80105295:	09 d8                	or     %ebx,%eax
80105297:	09 f8                	or     %edi,%eax
80105299:	c1 e7 08             	shl    $0x8,%edi
8010529c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010529e:	89 d7                	mov    %edx,%edi
801052a0:	fc                   	cld    
801052a1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801052a3:	5b                   	pop    %ebx
801052a4:	89 d0                	mov    %edx,%eax
801052a6:	5f                   	pop    %edi
801052a7:	5d                   	pop    %ebp
801052a8:	c3                   	ret    
801052a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801052b0:	89 d7                	mov    %edx,%edi
801052b2:	fc                   	cld    
801052b3:	f3 aa                	rep stos %al,%es:(%edi)
801052b5:	5b                   	pop    %ebx
801052b6:	89 d0                	mov    %edx,%eax
801052b8:	5f                   	pop    %edi
801052b9:	5d                   	pop    %ebp
801052ba:	c3                   	ret    
801052bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052bf:	90                   	nop

801052c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	56                   	push   %esi
801052c4:	8b 75 10             	mov    0x10(%ebp),%esi
801052c7:	8b 55 08             	mov    0x8(%ebp),%edx
801052ca:	53                   	push   %ebx
801052cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801052ce:	85 f6                	test   %esi,%esi
801052d0:	74 2e                	je     80105300 <memcmp+0x40>
801052d2:	01 c6                	add    %eax,%esi
801052d4:	eb 14                	jmp    801052ea <memcmp+0x2a>
801052d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052dd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801052e0:	83 c0 01             	add    $0x1,%eax
801052e3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801052e6:	39 f0                	cmp    %esi,%eax
801052e8:	74 16                	je     80105300 <memcmp+0x40>
    if(*s1 != *s2)
801052ea:	0f b6 0a             	movzbl (%edx),%ecx
801052ed:	0f b6 18             	movzbl (%eax),%ebx
801052f0:	38 d9                	cmp    %bl,%cl
801052f2:	74 ec                	je     801052e0 <memcmp+0x20>
      return *s1 - *s2;
801052f4:	0f b6 c1             	movzbl %cl,%eax
801052f7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801052f9:	5b                   	pop    %ebx
801052fa:	5e                   	pop    %esi
801052fb:	5d                   	pop    %ebp
801052fc:	c3                   	ret    
801052fd:	8d 76 00             	lea    0x0(%esi),%esi
80105300:	5b                   	pop    %ebx
  return 0;
80105301:	31 c0                	xor    %eax,%eax
}
80105303:	5e                   	pop    %esi
80105304:	5d                   	pop    %ebp
80105305:	c3                   	ret    
80105306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010530d:	8d 76 00             	lea    0x0(%esi),%esi

80105310 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	8b 55 08             	mov    0x8(%ebp),%edx
80105317:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010531a:	56                   	push   %esi
8010531b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010531e:	39 d6                	cmp    %edx,%esi
80105320:	73 26                	jae    80105348 <memmove+0x38>
80105322:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105325:	39 fa                	cmp    %edi,%edx
80105327:	73 1f                	jae    80105348 <memmove+0x38>
80105329:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010532c:	85 c9                	test   %ecx,%ecx
8010532e:	74 0c                	je     8010533c <memmove+0x2c>
      *--d = *--s;
80105330:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105334:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105337:	83 e8 01             	sub    $0x1,%eax
8010533a:	73 f4                	jae    80105330 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010533c:	5e                   	pop    %esi
8010533d:	89 d0                	mov    %edx,%eax
8010533f:	5f                   	pop    %edi
80105340:	5d                   	pop    %ebp
80105341:	c3                   	ret    
80105342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105348:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010534b:	89 d7                	mov    %edx,%edi
8010534d:	85 c9                	test   %ecx,%ecx
8010534f:	74 eb                	je     8010533c <memmove+0x2c>
80105351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105358:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105359:	39 c6                	cmp    %eax,%esi
8010535b:	75 fb                	jne    80105358 <memmove+0x48>
}
8010535d:	5e                   	pop    %esi
8010535e:	89 d0                	mov    %edx,%eax
80105360:	5f                   	pop    %edi
80105361:	5d                   	pop    %ebp
80105362:	c3                   	ret    
80105363:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010536a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105370 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105370:	eb 9e                	jmp    80105310 <memmove>
80105372:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105380 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	56                   	push   %esi
80105384:	8b 75 10             	mov    0x10(%ebp),%esi
80105387:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010538a:	53                   	push   %ebx
8010538b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010538e:	85 f6                	test   %esi,%esi
80105390:	74 2e                	je     801053c0 <strncmp+0x40>
80105392:	01 d6                	add    %edx,%esi
80105394:	eb 18                	jmp    801053ae <strncmp+0x2e>
80105396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010539d:	8d 76 00             	lea    0x0(%esi),%esi
801053a0:	38 d8                	cmp    %bl,%al
801053a2:	75 14                	jne    801053b8 <strncmp+0x38>
    n--, p++, q++;
801053a4:	83 c2 01             	add    $0x1,%edx
801053a7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801053aa:	39 f2                	cmp    %esi,%edx
801053ac:	74 12                	je     801053c0 <strncmp+0x40>
801053ae:	0f b6 01             	movzbl (%ecx),%eax
801053b1:	0f b6 1a             	movzbl (%edx),%ebx
801053b4:	84 c0                	test   %al,%al
801053b6:	75 e8                	jne    801053a0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801053b8:	29 d8                	sub    %ebx,%eax
}
801053ba:	5b                   	pop    %ebx
801053bb:	5e                   	pop    %esi
801053bc:	5d                   	pop    %ebp
801053bd:	c3                   	ret    
801053be:	66 90                	xchg   %ax,%ax
801053c0:	5b                   	pop    %ebx
    return 0;
801053c1:	31 c0                	xor    %eax,%eax
}
801053c3:	5e                   	pop    %esi
801053c4:	5d                   	pop    %ebp
801053c5:	c3                   	ret    
801053c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053cd:	8d 76 00             	lea    0x0(%esi),%esi

801053d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	57                   	push   %edi
801053d4:	56                   	push   %esi
801053d5:	8b 75 08             	mov    0x8(%ebp),%esi
801053d8:	53                   	push   %ebx
801053d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801053dc:	89 f0                	mov    %esi,%eax
801053de:	eb 15                	jmp    801053f5 <strncpy+0x25>
801053e0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801053e4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801053e7:	83 c0 01             	add    $0x1,%eax
801053ea:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
801053ee:	88 50 ff             	mov    %dl,-0x1(%eax)
801053f1:	84 d2                	test   %dl,%dl
801053f3:	74 09                	je     801053fe <strncpy+0x2e>
801053f5:	89 cb                	mov    %ecx,%ebx
801053f7:	83 e9 01             	sub    $0x1,%ecx
801053fa:	85 db                	test   %ebx,%ebx
801053fc:	7f e2                	jg     801053e0 <strncpy+0x10>
    ;
  while(n-- > 0)
801053fe:	89 c2                	mov    %eax,%edx
80105400:	85 c9                	test   %ecx,%ecx
80105402:	7e 17                	jle    8010541b <strncpy+0x4b>
80105404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105408:	83 c2 01             	add    $0x1,%edx
8010540b:	89 c1                	mov    %eax,%ecx
8010540d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105411:	29 d1                	sub    %edx,%ecx
80105413:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105417:	85 c9                	test   %ecx,%ecx
80105419:	7f ed                	jg     80105408 <strncpy+0x38>
  return os;
}
8010541b:	5b                   	pop    %ebx
8010541c:	89 f0                	mov    %esi,%eax
8010541e:	5e                   	pop    %esi
8010541f:	5f                   	pop    %edi
80105420:	5d                   	pop    %ebp
80105421:	c3                   	ret    
80105422:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105430 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	56                   	push   %esi
80105434:	8b 55 10             	mov    0x10(%ebp),%edx
80105437:	8b 75 08             	mov    0x8(%ebp),%esi
8010543a:	53                   	push   %ebx
8010543b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010543e:	85 d2                	test   %edx,%edx
80105440:	7e 25                	jle    80105467 <safestrcpy+0x37>
80105442:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105446:	89 f2                	mov    %esi,%edx
80105448:	eb 16                	jmp    80105460 <safestrcpy+0x30>
8010544a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105450:	0f b6 08             	movzbl (%eax),%ecx
80105453:	83 c0 01             	add    $0x1,%eax
80105456:	83 c2 01             	add    $0x1,%edx
80105459:	88 4a ff             	mov    %cl,-0x1(%edx)
8010545c:	84 c9                	test   %cl,%cl
8010545e:	74 04                	je     80105464 <safestrcpy+0x34>
80105460:	39 d8                	cmp    %ebx,%eax
80105462:	75 ec                	jne    80105450 <safestrcpy+0x20>
    ;
  *s = 0;
80105464:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105467:	89 f0                	mov    %esi,%eax
80105469:	5b                   	pop    %ebx
8010546a:	5e                   	pop    %esi
8010546b:	5d                   	pop    %ebp
8010546c:	c3                   	ret    
8010546d:	8d 76 00             	lea    0x0(%esi),%esi

80105470 <strlen>:

int
strlen(const char *s)
{
80105470:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105471:	31 c0                	xor    %eax,%eax
{
80105473:	89 e5                	mov    %esp,%ebp
80105475:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105478:	80 3a 00             	cmpb   $0x0,(%edx)
8010547b:	74 0c                	je     80105489 <strlen+0x19>
8010547d:	8d 76 00             	lea    0x0(%esi),%esi
80105480:	83 c0 01             	add    $0x1,%eax
80105483:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105487:	75 f7                	jne    80105480 <strlen+0x10>
    ;
  return n;
}
80105489:	5d                   	pop    %ebp
8010548a:	c3                   	ret    

8010548b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010548b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010548f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105493:	55                   	push   %ebp
  pushl %ebx
80105494:	53                   	push   %ebx
  pushl %esi
80105495:	56                   	push   %esi
  pushl %edi
80105496:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105497:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105499:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010549b:	5f                   	pop    %edi
  popl %esi
8010549c:	5e                   	pop    %esi
  popl %ebx
8010549d:	5b                   	pop    %ebx
  popl %ebp
8010549e:	5d                   	pop    %ebp
  ret
8010549f:	c3                   	ret    

801054a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	53                   	push   %ebx
801054a4:	83 ec 04             	sub    $0x4,%esp
801054a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801054aa:	e8 41 e6 ff ff       	call   80103af0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801054af:	8b 00                	mov    (%eax),%eax
801054b1:	39 d8                	cmp    %ebx,%eax
801054b3:	76 1b                	jbe    801054d0 <fetchint+0x30>
801054b5:	8d 53 04             	lea    0x4(%ebx),%edx
801054b8:	39 d0                	cmp    %edx,%eax
801054ba:	72 14                	jb     801054d0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801054bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801054bf:	8b 13                	mov    (%ebx),%edx
801054c1:	89 10                	mov    %edx,(%eax)
  return 0;
801054c3:	31 c0                	xor    %eax,%eax
}
801054c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054c8:	c9                   	leave  
801054c9:	c3                   	ret    
801054ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801054d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054d5:	eb ee                	jmp    801054c5 <fetchint+0x25>
801054d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054de:	66 90                	xchg   %ax,%ax

801054e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	53                   	push   %ebx
801054e4:	83 ec 04             	sub    $0x4,%esp
801054e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801054ea:	e8 01 e6 ff ff       	call   80103af0 <myproc>

  if(addr >= curproc->sz)
801054ef:	39 18                	cmp    %ebx,(%eax)
801054f1:	76 2d                	jbe    80105520 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801054f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801054f6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801054f8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801054fa:	39 d3                	cmp    %edx,%ebx
801054fc:	73 22                	jae    80105520 <fetchstr+0x40>
801054fe:	89 d8                	mov    %ebx,%eax
80105500:	eb 0d                	jmp    8010550f <fetchstr+0x2f>
80105502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105508:	83 c0 01             	add    $0x1,%eax
8010550b:	39 c2                	cmp    %eax,%edx
8010550d:	76 11                	jbe    80105520 <fetchstr+0x40>
    if(*s == 0)
8010550f:	80 38 00             	cmpb   $0x0,(%eax)
80105512:	75 f4                	jne    80105508 <fetchstr+0x28>
      return s - *pp;
80105514:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105519:	c9                   	leave  
8010551a:	c3                   	ret    
8010551b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010551f:	90                   	nop
80105520:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105523:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105528:	c9                   	leave  
80105529:	c3                   	ret    
8010552a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105530 <fetchfloat>:
int
fetchfloat(uint addr, float *fp)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	53                   	push   %ebx
80105534:	83 ec 04             	sub    $0x4,%esp
80105537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010553a:	e8 b1 e5 ff ff       	call   80103af0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010553f:	8b 00                	mov    (%eax),%eax
80105541:	39 d8                	cmp    %ebx,%eax
80105543:	76 1b                	jbe    80105560 <fetchfloat+0x30>
80105545:	8d 53 04             	lea    0x4(%ebx),%edx
80105548:	39 d0                	cmp    %edx,%eax
8010554a:	72 14                	jb     80105560 <fetchfloat+0x30>
    return -1;
  *fp = *(float*)(addr);
8010554c:	d9 03                	flds   (%ebx)
8010554e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105551:	d9 18                	fstps  (%eax)
  return 0;
80105553:	31 c0                	xor    %eax,%eax
}
80105555:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105558:	c9                   	leave  
80105559:	c3                   	ret    
8010555a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105565:	eb ee                	jmp    80105555 <fetchfloat+0x25>
80105567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010556e:	66 90                	xchg   %ax,%ax

80105570 <argint>:
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	56                   	push   %esi
80105574:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105575:	e8 76 e5 ff ff       	call   80103af0 <myproc>
8010557a:	8b 55 08             	mov    0x8(%ebp),%edx
8010557d:	8b 40 18             	mov    0x18(%eax),%eax
80105580:	8b 40 44             	mov    0x44(%eax),%eax
80105583:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105586:	e8 65 e5 ff ff       	call   80103af0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010558b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010558e:	8b 00                	mov    (%eax),%eax
80105590:	39 c6                	cmp    %eax,%esi
80105592:	73 1c                	jae    801055b0 <argint+0x40>
80105594:	8d 53 08             	lea    0x8(%ebx),%edx
80105597:	39 d0                	cmp    %edx,%eax
80105599:	72 15                	jb     801055b0 <argint+0x40>
  *ip = *(int*)(addr);
8010559b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010559e:	8b 53 04             	mov    0x4(%ebx),%edx
801055a1:	89 10                	mov    %edx,(%eax)
  return 0;
801055a3:	31 c0                	xor    %eax,%eax
}
801055a5:	5b                   	pop    %ebx
801055a6:	5e                   	pop    %esi
801055a7:	5d                   	pop    %ebp
801055a8:	c3                   	ret    
801055a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801055b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801055b5:	eb ee                	jmp    801055a5 <argint+0x35>
801055b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055be:	66 90                	xchg   %ax,%ax

801055c0 <argf>:
int
argf(int n, float *fp)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	56                   	push   %esi
801055c4:	53                   	push   %ebx
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
801055c5:	e8 26 e5 ff ff       	call   80103af0 <myproc>
801055ca:	8b 55 08             	mov    0x8(%ebp),%edx
801055cd:	8b 40 18             	mov    0x18(%eax),%eax
801055d0:	8b 40 44             	mov    0x44(%eax),%eax
801055d3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801055d6:	e8 15 e5 ff ff       	call   80103af0 <myproc>
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
801055db:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801055de:	8b 00                	mov    (%eax),%eax
801055e0:	39 c6                	cmp    %eax,%esi
801055e2:	73 1c                	jae    80105600 <argf+0x40>
801055e4:	8d 53 08             	lea    0x8(%ebx),%edx
801055e7:	39 d0                	cmp    %edx,%eax
801055e9:	72 15                	jb     80105600 <argf+0x40>
  *fp = *(float*)(addr);
801055eb:	d9 43 04             	flds   0x4(%ebx)
801055ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801055f1:	d9 18                	fstps  (%eax)
  return 0;
801055f3:	31 c0                	xor    %eax,%eax
}
801055f5:	5b                   	pop    %ebx
801055f6:	5e                   	pop    %esi
801055f7:	5d                   	pop    %ebp
801055f8:	c3                   	ret    
801055f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105605:	eb ee                	jmp    801055f5 <argf+0x35>
80105607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560e:	66 90                	xchg   %ax,%ax

80105610 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	57                   	push   %edi
80105614:	56                   	push   %esi
80105615:	53                   	push   %ebx
80105616:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105619:	e8 d2 e4 ff ff       	call   80103af0 <myproc>
8010561e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105620:	e8 cb e4 ff ff       	call   80103af0 <myproc>
80105625:	8b 55 08             	mov    0x8(%ebp),%edx
80105628:	8b 40 18             	mov    0x18(%eax),%eax
8010562b:	8b 40 44             	mov    0x44(%eax),%eax
8010562e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105631:	e8 ba e4 ff ff       	call   80103af0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105636:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105639:	8b 00                	mov    (%eax),%eax
8010563b:	39 c7                	cmp    %eax,%edi
8010563d:	73 31                	jae    80105670 <argptr+0x60>
8010563f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105642:	39 c8                	cmp    %ecx,%eax
80105644:	72 2a                	jb     80105670 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105646:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105649:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010564c:	85 d2                	test   %edx,%edx
8010564e:	78 20                	js     80105670 <argptr+0x60>
80105650:	8b 16                	mov    (%esi),%edx
80105652:	39 c2                	cmp    %eax,%edx
80105654:	76 1a                	jbe    80105670 <argptr+0x60>
80105656:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105659:	01 c3                	add    %eax,%ebx
8010565b:	39 da                	cmp    %ebx,%edx
8010565d:	72 11                	jb     80105670 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010565f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105662:	89 02                	mov    %eax,(%edx)
  return 0;
80105664:	31 c0                	xor    %eax,%eax
}
80105666:	83 c4 0c             	add    $0xc,%esp
80105669:	5b                   	pop    %ebx
8010566a:	5e                   	pop    %esi
8010566b:	5f                   	pop    %edi
8010566c:	5d                   	pop    %ebp
8010566d:	c3                   	ret    
8010566e:	66 90                	xchg   %ax,%ax
    return -1;
80105670:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105675:	eb ef                	jmp    80105666 <argptr+0x56>
80105677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010567e:	66 90                	xchg   %ax,%ax

80105680 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	56                   	push   %esi
80105684:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105685:	e8 66 e4 ff ff       	call   80103af0 <myproc>
8010568a:	8b 55 08             	mov    0x8(%ebp),%edx
8010568d:	8b 40 18             	mov    0x18(%eax),%eax
80105690:	8b 40 44             	mov    0x44(%eax),%eax
80105693:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105696:	e8 55 e4 ff ff       	call   80103af0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010569b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010569e:	8b 00                	mov    (%eax),%eax
801056a0:	39 c6                	cmp    %eax,%esi
801056a2:	73 44                	jae    801056e8 <argstr+0x68>
801056a4:	8d 53 08             	lea    0x8(%ebx),%edx
801056a7:	39 d0                	cmp    %edx,%eax
801056a9:	72 3d                	jb     801056e8 <argstr+0x68>
  *ip = *(int*)(addr);
801056ab:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801056ae:	e8 3d e4 ff ff       	call   80103af0 <myproc>
  if(addr >= curproc->sz)
801056b3:	3b 18                	cmp    (%eax),%ebx
801056b5:	73 31                	jae    801056e8 <argstr+0x68>
  *pp = (char*)addr;
801056b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801056ba:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801056bc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801056be:	39 d3                	cmp    %edx,%ebx
801056c0:	73 26                	jae    801056e8 <argstr+0x68>
801056c2:	89 d8                	mov    %ebx,%eax
801056c4:	eb 11                	jmp    801056d7 <argstr+0x57>
801056c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056cd:	8d 76 00             	lea    0x0(%esi),%esi
801056d0:	83 c0 01             	add    $0x1,%eax
801056d3:	39 c2                	cmp    %eax,%edx
801056d5:	76 11                	jbe    801056e8 <argstr+0x68>
    if(*s == 0)
801056d7:	80 38 00             	cmpb   $0x0,(%eax)
801056da:	75 f4                	jne    801056d0 <argstr+0x50>
      return s - *pp;
801056dc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801056de:	5b                   	pop    %ebx
801056df:	5e                   	pop    %esi
801056e0:	5d                   	pop    %ebp
801056e1:	c3                   	ret    
801056e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801056e8:	5b                   	pop    %ebx
    return -1;
801056e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ee:	5e                   	pop    %esi
801056ef:	5d                   	pop    %ebp
801056f0:	c3                   	ret    
801056f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ff:	90                   	nop

80105700 <syscall>:
[SYS_close_sharedmem] sys_close_sharedmem,
};

void
syscall(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	53                   	push   %ebx
80105704:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105707:	e8 e4 e3 ff ff       	call   80103af0 <myproc>
8010570c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010570e:	8b 40 18             	mov    0x18(%eax),%eax
80105711:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105714:	8d 50 ff             	lea    -0x1(%eax),%edx
80105717:	83 fa 21             	cmp    $0x21,%edx
8010571a:	77 24                	ja     80105740 <syscall+0x40>
8010571c:	8b 14 85 00 8d 10 80 	mov    -0x7fef7300(,%eax,4),%edx
80105723:	85 d2                	test   %edx,%edx
80105725:	74 19                	je     80105740 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105727:	ff d2                	call   *%edx
80105729:	89 c2                	mov    %eax,%edx
8010572b:	8b 43 18             	mov    0x18(%ebx),%eax
8010572e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105731:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105734:	c9                   	leave  
80105735:	c3                   	ret    
80105736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105740:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105741:	8d 43 78             	lea    0x78(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105744:	50                   	push   %eax
80105745:	ff 73 10             	push   0x10(%ebx)
80105748:	68 c9 8c 10 80       	push   $0x80108cc9
8010574d:	e8 4e af ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80105752:	8b 43 18             	mov    0x18(%ebx),%eax
80105755:	83 c4 10             	add    $0x10,%esp
80105758:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010575f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105762:	c9                   	leave  
80105763:	c3                   	ret    
80105764:	66 90                	xchg   %ax,%ax
80105766:	66 90                	xchg   %ax,%ax
80105768:	66 90                	xchg   %ax,%ax
8010576a:	66 90                	xchg   %ax,%ax
8010576c:	66 90                	xchg   %ax,%ax
8010576e:	66 90                	xchg   %ax,%ax

80105770 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	57                   	push   %edi
80105774:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
80105775:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105778:	53                   	push   %ebx
80105779:	83 ec 34             	sub    $0x34,%esp
8010577c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010577f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if ((dp = nameiparent(path, name)) == 0)
80105782:	57                   	push   %edi
80105783:	50                   	push   %eax
{
80105784:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105787:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if ((dp = nameiparent(path, name)) == 0)
8010578a:	e8 31 c9 ff ff       	call   801020c0 <nameiparent>
8010578f:	83 c4 10             	add    $0x10,%esp
80105792:	85 c0                	test   %eax,%eax
80105794:	0f 84 46 01 00 00    	je     801058e0 <create+0x170>
    return 0;
  ilock(dp);
8010579a:	83 ec 0c             	sub    $0xc,%esp
8010579d:	89 c3                	mov    %eax,%ebx
8010579f:	50                   	push   %eax
801057a0:	e8 db bf ff ff       	call   80101780 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
801057a5:	83 c4 0c             	add    $0xc,%esp
801057a8:	6a 00                	push   $0x0
801057aa:	57                   	push   %edi
801057ab:	53                   	push   %ebx
801057ac:	e8 2f c5 ff ff       	call   80101ce0 <dirlookup>
801057b1:	83 c4 10             	add    $0x10,%esp
801057b4:	89 c6                	mov    %eax,%esi
801057b6:	85 c0                	test   %eax,%eax
801057b8:	74 56                	je     80105810 <create+0xa0>
  {
    iunlockput(dp);
801057ba:	83 ec 0c             	sub    $0xc,%esp
801057bd:	53                   	push   %ebx
801057be:	e8 4d c2 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
801057c3:	89 34 24             	mov    %esi,(%esp)
801057c6:	e8 b5 bf ff ff       	call   80101780 <ilock>
    if (type == T_FILE && ip->type == T_FILE)
801057cb:	83 c4 10             	add    $0x10,%esp
801057ce:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801057d3:	75 1b                	jne    801057f0 <create+0x80>
801057d5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801057da:	75 14                	jne    801057f0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801057dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057df:	89 f0                	mov    %esi,%eax
801057e1:	5b                   	pop    %ebx
801057e2:	5e                   	pop    %esi
801057e3:	5f                   	pop    %edi
801057e4:	5d                   	pop    %ebp
801057e5:	c3                   	ret    
801057e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801057f0:	83 ec 0c             	sub    $0xc,%esp
801057f3:	56                   	push   %esi
    return 0;
801057f4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801057f6:	e8 15 c2 ff ff       	call   80101a10 <iunlockput>
    return 0;
801057fb:	83 c4 10             	add    $0x10,%esp
}
801057fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105801:	89 f0                	mov    %esi,%eax
80105803:	5b                   	pop    %ebx
80105804:	5e                   	pop    %esi
80105805:	5f                   	pop    %edi
80105806:	5d                   	pop    %ebp
80105807:	c3                   	ret    
80105808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010580f:	90                   	nop
  if ((ip = ialloc(dp->dev, type)) == 0)
80105810:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105814:	83 ec 08             	sub    $0x8,%esp
80105817:	50                   	push   %eax
80105818:	ff 33                	push   (%ebx)
8010581a:	e8 f1 bd ff ff       	call   80101610 <ialloc>
8010581f:	83 c4 10             	add    $0x10,%esp
80105822:	89 c6                	mov    %eax,%esi
80105824:	85 c0                	test   %eax,%eax
80105826:	0f 84 cd 00 00 00    	je     801058f9 <create+0x189>
  ilock(ip);
8010582c:	83 ec 0c             	sub    $0xc,%esp
8010582f:	50                   	push   %eax
80105830:	e8 4b bf ff ff       	call   80101780 <ilock>
  ip->major = major;
80105835:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105839:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010583d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105841:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105845:	b8 01 00 00 00       	mov    $0x1,%eax
8010584a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010584e:	89 34 24             	mov    %esi,(%esp)
80105851:	e8 7a be ff ff       	call   801016d0 <iupdate>
  if (type == T_DIR)
80105856:	83 c4 10             	add    $0x10,%esp
80105859:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010585e:	74 30                	je     80105890 <create+0x120>
  if (dirlink(dp, name, ip->inum) < 0)
80105860:	83 ec 04             	sub    $0x4,%esp
80105863:	ff 76 04             	push   0x4(%esi)
80105866:	57                   	push   %edi
80105867:	53                   	push   %ebx
80105868:	e8 73 c7 ff ff       	call   80101fe0 <dirlink>
8010586d:	83 c4 10             	add    $0x10,%esp
80105870:	85 c0                	test   %eax,%eax
80105872:	78 78                	js     801058ec <create+0x17c>
  iunlockput(dp);
80105874:	83 ec 0c             	sub    $0xc,%esp
80105877:	53                   	push   %ebx
80105878:	e8 93 c1 ff ff       	call   80101a10 <iunlockput>
  return ip;
8010587d:	83 c4 10             	add    $0x10,%esp
}
80105880:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105883:	89 f0                	mov    %esi,%eax
80105885:	5b                   	pop    %ebx
80105886:	5e                   	pop    %esi
80105887:	5f                   	pop    %edi
80105888:	5d                   	pop    %ebp
80105889:	c3                   	ret    
8010588a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105890:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++; // for ".."
80105893:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105898:	53                   	push   %ebx
80105899:	e8 32 be ff ff       	call   801016d0 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010589e:	83 c4 0c             	add    $0xc,%esp
801058a1:	ff 76 04             	push   0x4(%esi)
801058a4:	68 a8 8d 10 80       	push   $0x80108da8
801058a9:	56                   	push   %esi
801058aa:	e8 31 c7 ff ff       	call   80101fe0 <dirlink>
801058af:	83 c4 10             	add    $0x10,%esp
801058b2:	85 c0                	test   %eax,%eax
801058b4:	78 18                	js     801058ce <create+0x15e>
801058b6:	83 ec 04             	sub    $0x4,%esp
801058b9:	ff 73 04             	push   0x4(%ebx)
801058bc:	68 a7 8d 10 80       	push   $0x80108da7
801058c1:	56                   	push   %esi
801058c2:	e8 19 c7 ff ff       	call   80101fe0 <dirlink>
801058c7:	83 c4 10             	add    $0x10,%esp
801058ca:	85 c0                	test   %eax,%eax
801058cc:	79 92                	jns    80105860 <create+0xf0>
      panic("create dots");
801058ce:	83 ec 0c             	sub    $0xc,%esp
801058d1:	68 9b 8d 10 80       	push   $0x80108d9b
801058d6:	e8 a5 aa ff ff       	call   80100380 <panic>
801058db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058df:	90                   	nop
}
801058e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801058e3:	31 f6                	xor    %esi,%esi
}
801058e5:	5b                   	pop    %ebx
801058e6:	89 f0                	mov    %esi,%eax
801058e8:	5e                   	pop    %esi
801058e9:	5f                   	pop    %edi
801058ea:	5d                   	pop    %ebp
801058eb:	c3                   	ret    
    panic("create: dirlink");
801058ec:	83 ec 0c             	sub    $0xc,%esp
801058ef:	68 aa 8d 10 80       	push   $0x80108daa
801058f4:	e8 87 aa ff ff       	call   80100380 <panic>
    panic("create: ialloc");
801058f9:	83 ec 0c             	sub    $0xc,%esp
801058fc:	68 8c 8d 10 80       	push   $0x80108d8c
80105901:	e8 7a aa ff ff       	call   80100380 <panic>
80105906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590d:	8d 76 00             	lea    0x0(%esi),%esi

80105910 <sys_dup>:
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	56                   	push   %esi
80105914:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105915:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105918:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010591b:	50                   	push   %eax
8010591c:	6a 00                	push   $0x0
8010591e:	e8 4d fc ff ff       	call   80105570 <argint>
80105923:	83 c4 10             	add    $0x10,%esp
80105926:	85 c0                	test   %eax,%eax
80105928:	78 36                	js     80105960 <sys_dup+0x50>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010592a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010592e:	77 30                	ja     80105960 <sys_dup+0x50>
80105930:	e8 bb e1 ff ff       	call   80103af0 <myproc>
80105935:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105938:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
8010593c:	85 f6                	test   %esi,%esi
8010593e:	74 20                	je     80105960 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105940:	e8 ab e1 ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105945:	31 db                	xor    %ebx,%ebx
80105947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594e:	66 90                	xchg   %ax,%ax
    if (curproc->ofile[fd] == 0)
80105950:	8b 54 98 34          	mov    0x34(%eax,%ebx,4),%edx
80105954:	85 d2                	test   %edx,%edx
80105956:	74 18                	je     80105970 <sys_dup+0x60>
  for (fd = 0; fd < NOFILE; fd++)
80105958:	83 c3 01             	add    $0x1,%ebx
8010595b:	83 fb 10             	cmp    $0x10,%ebx
8010595e:	75 f0                	jne    80105950 <sys_dup+0x40>
}
80105960:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105963:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105968:	89 d8                	mov    %ebx,%eax
8010596a:	5b                   	pop    %ebx
8010596b:	5e                   	pop    %esi
8010596c:	5d                   	pop    %ebp
8010596d:	c3                   	ret    
8010596e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105970:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105973:	89 74 98 34          	mov    %esi,0x34(%eax,%ebx,4)
  filedup(f);
80105977:	56                   	push   %esi
80105978:	e8 23 b5 ff ff       	call   80100ea0 <filedup>
  return fd;
8010597d:	83 c4 10             	add    $0x10,%esp
}
80105980:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105983:	89 d8                	mov    %ebx,%eax
80105985:	5b                   	pop    %ebx
80105986:	5e                   	pop    %esi
80105987:	5d                   	pop    %ebp
80105988:	c3                   	ret    
80105989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105990 <sys_read>:
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	56                   	push   %esi
80105994:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105995:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105998:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010599b:	53                   	push   %ebx
8010599c:	6a 00                	push   $0x0
8010599e:	e8 cd fb ff ff       	call   80105570 <argint>
801059a3:	83 c4 10             	add    $0x10,%esp
801059a6:	85 c0                	test   %eax,%eax
801059a8:	78 5e                	js     80105a08 <sys_read+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801059aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801059ae:	77 58                	ja     80105a08 <sys_read+0x78>
801059b0:	e8 3b e1 ff ff       	call   80103af0 <myproc>
801059b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059b8:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
801059bc:	85 f6                	test   %esi,%esi
801059be:	74 48                	je     80105a08 <sys_read+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801059c0:	83 ec 08             	sub    $0x8,%esp
801059c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059c6:	50                   	push   %eax
801059c7:	6a 02                	push   $0x2
801059c9:	e8 a2 fb ff ff       	call   80105570 <argint>
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	85 c0                	test   %eax,%eax
801059d3:	78 33                	js     80105a08 <sys_read+0x78>
801059d5:	83 ec 04             	sub    $0x4,%esp
801059d8:	ff 75 f0             	push   -0x10(%ebp)
801059db:	53                   	push   %ebx
801059dc:	6a 01                	push   $0x1
801059de:	e8 2d fc ff ff       	call   80105610 <argptr>
801059e3:	83 c4 10             	add    $0x10,%esp
801059e6:	85 c0                	test   %eax,%eax
801059e8:	78 1e                	js     80105a08 <sys_read+0x78>
  return fileread(f, p, n);
801059ea:	83 ec 04             	sub    $0x4,%esp
801059ed:	ff 75 f0             	push   -0x10(%ebp)
801059f0:	ff 75 f4             	push   -0xc(%ebp)
801059f3:	56                   	push   %esi
801059f4:	e8 27 b6 ff ff       	call   80101020 <fileread>
801059f9:	83 c4 10             	add    $0x10,%esp
}
801059fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059ff:	5b                   	pop    %ebx
80105a00:	5e                   	pop    %esi
80105a01:	5d                   	pop    %ebp
80105a02:	c3                   	ret    
80105a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a07:	90                   	nop
    return -1;
80105a08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a0d:	eb ed                	jmp    801059fc <sys_read+0x6c>
80105a0f:	90                   	nop

80105a10 <sys_write>:
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	56                   	push   %esi
80105a14:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105a15:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105a18:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
80105a1b:	53                   	push   %ebx
80105a1c:	6a 00                	push   $0x0
80105a1e:	e8 4d fb ff ff       	call   80105570 <argint>
80105a23:	83 c4 10             	add    $0x10,%esp
80105a26:	85 c0                	test   %eax,%eax
80105a28:	78 5e                	js     80105a88 <sys_write+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
80105a2a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105a2e:	77 58                	ja     80105a88 <sys_write+0x78>
80105a30:	e8 bb e0 ff ff       	call   80103af0 <myproc>
80105a35:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a38:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
80105a3c:	85 f6                	test   %esi,%esi
80105a3e:	74 48                	je     80105a88 <sys_write+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a40:	83 ec 08             	sub    $0x8,%esp
80105a43:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a46:	50                   	push   %eax
80105a47:	6a 02                	push   $0x2
80105a49:	e8 22 fb ff ff       	call   80105570 <argint>
80105a4e:	83 c4 10             	add    $0x10,%esp
80105a51:	85 c0                	test   %eax,%eax
80105a53:	78 33                	js     80105a88 <sys_write+0x78>
80105a55:	83 ec 04             	sub    $0x4,%esp
80105a58:	ff 75 f0             	push   -0x10(%ebp)
80105a5b:	53                   	push   %ebx
80105a5c:	6a 01                	push   $0x1
80105a5e:	e8 ad fb ff ff       	call   80105610 <argptr>
80105a63:	83 c4 10             	add    $0x10,%esp
80105a66:	85 c0                	test   %eax,%eax
80105a68:	78 1e                	js     80105a88 <sys_write+0x78>
  return filewrite(f, p, n);
80105a6a:	83 ec 04             	sub    $0x4,%esp
80105a6d:	ff 75 f0             	push   -0x10(%ebp)
80105a70:	ff 75 f4             	push   -0xc(%ebp)
80105a73:	56                   	push   %esi
80105a74:	e8 37 b6 ff ff       	call   801010b0 <filewrite>
80105a79:	83 c4 10             	add    $0x10,%esp
}
80105a7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a7f:	5b                   	pop    %ebx
80105a80:	5e                   	pop    %esi
80105a81:	5d                   	pop    %ebp
80105a82:	c3                   	ret    
80105a83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a87:	90                   	nop
    return -1;
80105a88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a8d:	eb ed                	jmp    80105a7c <sys_write+0x6c>
80105a8f:	90                   	nop

80105a90 <sys_close>:
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	56                   	push   %esi
80105a94:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105a95:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a98:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
80105a9b:	50                   	push   %eax
80105a9c:	6a 00                	push   $0x0
80105a9e:	e8 cd fa ff ff       	call   80105570 <argint>
80105aa3:	83 c4 10             	add    $0x10,%esp
80105aa6:	85 c0                	test   %eax,%eax
80105aa8:	78 3e                	js     80105ae8 <sys_close+0x58>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
80105aaa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105aae:	77 38                	ja     80105ae8 <sys_close+0x58>
80105ab0:	e8 3b e0 ff ff       	call   80103af0 <myproc>
80105ab5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ab8:	8d 5a 0c             	lea    0xc(%edx),%ebx
80105abb:	8b 74 98 04          	mov    0x4(%eax,%ebx,4),%esi
80105abf:	85 f6                	test   %esi,%esi
80105ac1:	74 25                	je     80105ae8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105ac3:	e8 28 e0 ff ff       	call   80103af0 <myproc>
  fileclose(f);
80105ac8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105acb:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
80105ad2:	00 
  fileclose(f);
80105ad3:	56                   	push   %esi
80105ad4:	e8 17 b4 ff ff       	call   80100ef0 <fileclose>
  return 0;
80105ad9:	83 c4 10             	add    $0x10,%esp
80105adc:	31 c0                	xor    %eax,%eax
}
80105ade:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ae1:	5b                   	pop    %ebx
80105ae2:	5e                   	pop    %esi
80105ae3:	5d                   	pop    %ebp
80105ae4:	c3                   	ret    
80105ae5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ae8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aed:	eb ef                	jmp    80105ade <sys_close+0x4e>
80105aef:	90                   	nop

80105af0 <sys_fstat>:
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	56                   	push   %esi
80105af4:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105af5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105af8:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
80105afb:	53                   	push   %ebx
80105afc:	6a 00                	push   $0x0
80105afe:	e8 6d fa ff ff       	call   80105570 <argint>
80105b03:	83 c4 10             	add    $0x10,%esp
80105b06:	85 c0                	test   %eax,%eax
80105b08:	78 46                	js     80105b50 <sys_fstat+0x60>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
80105b0a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105b0e:	77 40                	ja     80105b50 <sys_fstat+0x60>
80105b10:	e8 db df ff ff       	call   80103af0 <myproc>
80105b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b18:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
80105b1c:	85 f6                	test   %esi,%esi
80105b1e:	74 30                	je     80105b50 <sys_fstat+0x60>
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
80105b20:	83 ec 04             	sub    $0x4,%esp
80105b23:	6a 14                	push   $0x14
80105b25:	53                   	push   %ebx
80105b26:	6a 01                	push   $0x1
80105b28:	e8 e3 fa ff ff       	call   80105610 <argptr>
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	85 c0                	test   %eax,%eax
80105b32:	78 1c                	js     80105b50 <sys_fstat+0x60>
  return filestat(f, st);
80105b34:	83 ec 08             	sub    $0x8,%esp
80105b37:	ff 75 f4             	push   -0xc(%ebp)
80105b3a:	56                   	push   %esi
80105b3b:	e8 90 b4 ff ff       	call   80100fd0 <filestat>
80105b40:	83 c4 10             	add    $0x10,%esp
}
80105b43:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b46:	5b                   	pop    %ebx
80105b47:	5e                   	pop    %esi
80105b48:	5d                   	pop    %ebp
80105b49:	c3                   	ret    
80105b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b55:	eb ec                	jmp    80105b43 <sys_fstat+0x53>
80105b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5e:	66 90                	xchg   %ax,%ax

80105b60 <sys_link>:
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105b65:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105b68:	53                   	push   %ebx
80105b69:	83 ec 34             	sub    $0x34,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105b6c:	50                   	push   %eax
80105b6d:	6a 00                	push   $0x0
80105b6f:	e8 0c fb ff ff       	call   80105680 <argstr>
80105b74:	83 c4 10             	add    $0x10,%esp
80105b77:	85 c0                	test   %eax,%eax
80105b79:	0f 88 fb 00 00 00    	js     80105c7a <sys_link+0x11a>
80105b7f:	83 ec 08             	sub    $0x8,%esp
80105b82:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105b85:	50                   	push   %eax
80105b86:	6a 01                	push   $0x1
80105b88:	e8 f3 fa ff ff       	call   80105680 <argstr>
80105b8d:	83 c4 10             	add    $0x10,%esp
80105b90:	85 c0                	test   %eax,%eax
80105b92:	0f 88 e2 00 00 00    	js     80105c7a <sys_link+0x11a>
  begin_op();
80105b98:	e8 c3 d1 ff ff       	call   80102d60 <begin_op>
  if ((ip = namei(old)) == 0)
80105b9d:	83 ec 0c             	sub    $0xc,%esp
80105ba0:	ff 75 d4             	push   -0x2c(%ebp)
80105ba3:	e8 f8 c4 ff ff       	call   801020a0 <namei>
80105ba8:	83 c4 10             	add    $0x10,%esp
80105bab:	89 c3                	mov    %eax,%ebx
80105bad:	85 c0                	test   %eax,%eax
80105baf:	0f 84 e4 00 00 00    	je     80105c99 <sys_link+0x139>
  ilock(ip);
80105bb5:	83 ec 0c             	sub    $0xc,%esp
80105bb8:	50                   	push   %eax
80105bb9:	e8 c2 bb ff ff       	call   80101780 <ilock>
  if (ip->type == T_DIR)
80105bbe:	83 c4 10             	add    $0x10,%esp
80105bc1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105bc6:	0f 84 b5 00 00 00    	je     80105c81 <sys_link+0x121>
  iupdate(ip);
80105bcc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105bcf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if ((dp = nameiparent(new, name)) == 0)
80105bd4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105bd7:	53                   	push   %ebx
80105bd8:	e8 f3 ba ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
80105bdd:	89 1c 24             	mov    %ebx,(%esp)
80105be0:	e8 7b bc ff ff       	call   80101860 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
80105be5:	58                   	pop    %eax
80105be6:	5a                   	pop    %edx
80105be7:	57                   	push   %edi
80105be8:	ff 75 d0             	push   -0x30(%ebp)
80105beb:	e8 d0 c4 ff ff       	call   801020c0 <nameiparent>
80105bf0:	83 c4 10             	add    $0x10,%esp
80105bf3:	89 c6                	mov    %eax,%esi
80105bf5:	85 c0                	test   %eax,%eax
80105bf7:	74 5b                	je     80105c54 <sys_link+0xf4>
  ilock(dp);
80105bf9:	83 ec 0c             	sub    $0xc,%esp
80105bfc:	50                   	push   %eax
80105bfd:	e8 7e bb ff ff       	call   80101780 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
80105c02:	8b 03                	mov    (%ebx),%eax
80105c04:	83 c4 10             	add    $0x10,%esp
80105c07:	39 06                	cmp    %eax,(%esi)
80105c09:	75 3d                	jne    80105c48 <sys_link+0xe8>
80105c0b:	83 ec 04             	sub    $0x4,%esp
80105c0e:	ff 73 04             	push   0x4(%ebx)
80105c11:	57                   	push   %edi
80105c12:	56                   	push   %esi
80105c13:	e8 c8 c3 ff ff       	call   80101fe0 <dirlink>
80105c18:	83 c4 10             	add    $0x10,%esp
80105c1b:	85 c0                	test   %eax,%eax
80105c1d:	78 29                	js     80105c48 <sys_link+0xe8>
  iunlockput(dp);
80105c1f:	83 ec 0c             	sub    $0xc,%esp
80105c22:	56                   	push   %esi
80105c23:	e8 e8 bd ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105c28:	89 1c 24             	mov    %ebx,(%esp)
80105c2b:	e8 80 bc ff ff       	call   801018b0 <iput>
  end_op();
80105c30:	e8 9b d1 ff ff       	call   80102dd0 <end_op>
  return 0;
80105c35:	83 c4 10             	add    $0x10,%esp
80105c38:	31 c0                	xor    %eax,%eax
}
80105c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c3d:	5b                   	pop    %ebx
80105c3e:	5e                   	pop    %esi
80105c3f:	5f                   	pop    %edi
80105c40:	5d                   	pop    %ebp
80105c41:	c3                   	ret    
80105c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105c48:	83 ec 0c             	sub    $0xc,%esp
80105c4b:	56                   	push   %esi
80105c4c:	e8 bf bd ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105c51:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105c54:	83 ec 0c             	sub    $0xc,%esp
80105c57:	53                   	push   %ebx
80105c58:	e8 23 bb ff ff       	call   80101780 <ilock>
  ip->nlink--;
80105c5d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105c62:	89 1c 24             	mov    %ebx,(%esp)
80105c65:	e8 66 ba ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105c6a:	89 1c 24             	mov    %ebx,(%esp)
80105c6d:	e8 9e bd ff ff       	call   80101a10 <iunlockput>
  end_op();
80105c72:	e8 59 d1 ff ff       	call   80102dd0 <end_op>
  return -1;
80105c77:	83 c4 10             	add    $0x10,%esp
80105c7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c7f:	eb b9                	jmp    80105c3a <sys_link+0xda>
    iunlockput(ip);
80105c81:	83 ec 0c             	sub    $0xc,%esp
80105c84:	53                   	push   %ebx
80105c85:	e8 86 bd ff ff       	call   80101a10 <iunlockput>
    end_op();
80105c8a:	e8 41 d1 ff ff       	call   80102dd0 <end_op>
    return -1;
80105c8f:	83 c4 10             	add    $0x10,%esp
80105c92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c97:	eb a1                	jmp    80105c3a <sys_link+0xda>
    end_op();
80105c99:	e8 32 d1 ff ff       	call   80102dd0 <end_op>
    return -1;
80105c9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca3:	eb 95                	jmp    80105c3a <sys_link+0xda>
80105ca5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cb0 <sys_unlink>:
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	57                   	push   %edi
80105cb4:	56                   	push   %esi
  if (argstr(0, &path) < 0)
80105cb5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105cb8:	53                   	push   %ebx
80105cb9:	83 ec 54             	sub    $0x54,%esp
  if (argstr(0, &path) < 0)
80105cbc:	50                   	push   %eax
80105cbd:	6a 00                	push   $0x0
80105cbf:	e8 bc f9 ff ff       	call   80105680 <argstr>
80105cc4:	83 c4 10             	add    $0x10,%esp
80105cc7:	85 c0                	test   %eax,%eax
80105cc9:	0f 88 7a 01 00 00    	js     80105e49 <sys_unlink+0x199>
  begin_op();
80105ccf:	e8 8c d0 ff ff       	call   80102d60 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
80105cd4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105cd7:	83 ec 08             	sub    $0x8,%esp
80105cda:	53                   	push   %ebx
80105cdb:	ff 75 c0             	push   -0x40(%ebp)
80105cde:	e8 dd c3 ff ff       	call   801020c0 <nameiparent>
80105ce3:	83 c4 10             	add    $0x10,%esp
80105ce6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105ce9:	85 c0                	test   %eax,%eax
80105ceb:	0f 84 62 01 00 00    	je     80105e53 <sys_unlink+0x1a3>
  ilock(dp);
80105cf1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105cf4:	83 ec 0c             	sub    $0xc,%esp
80105cf7:	57                   	push   %edi
80105cf8:	e8 83 ba ff ff       	call   80101780 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105cfd:	58                   	pop    %eax
80105cfe:	5a                   	pop    %edx
80105cff:	68 a8 8d 10 80       	push   $0x80108da8
80105d04:	53                   	push   %ebx
80105d05:	e8 b6 bf ff ff       	call   80101cc0 <namecmp>
80105d0a:	83 c4 10             	add    $0x10,%esp
80105d0d:	85 c0                	test   %eax,%eax
80105d0f:	0f 84 fb 00 00 00    	je     80105e10 <sys_unlink+0x160>
80105d15:	83 ec 08             	sub    $0x8,%esp
80105d18:	68 a7 8d 10 80       	push   $0x80108da7
80105d1d:	53                   	push   %ebx
80105d1e:	e8 9d bf ff ff       	call   80101cc0 <namecmp>
80105d23:	83 c4 10             	add    $0x10,%esp
80105d26:	85 c0                	test   %eax,%eax
80105d28:	0f 84 e2 00 00 00    	je     80105e10 <sys_unlink+0x160>
  if ((ip = dirlookup(dp, name, &off)) == 0)
80105d2e:	83 ec 04             	sub    $0x4,%esp
80105d31:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105d34:	50                   	push   %eax
80105d35:	53                   	push   %ebx
80105d36:	57                   	push   %edi
80105d37:	e8 a4 bf ff ff       	call   80101ce0 <dirlookup>
80105d3c:	83 c4 10             	add    $0x10,%esp
80105d3f:	89 c3                	mov    %eax,%ebx
80105d41:	85 c0                	test   %eax,%eax
80105d43:	0f 84 c7 00 00 00    	je     80105e10 <sys_unlink+0x160>
  ilock(ip);
80105d49:	83 ec 0c             	sub    $0xc,%esp
80105d4c:	50                   	push   %eax
80105d4d:	e8 2e ba ff ff       	call   80101780 <ilock>
  if (ip->nlink < 1)
80105d52:	83 c4 10             	add    $0x10,%esp
80105d55:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105d5a:	0f 8e 1c 01 00 00    	jle    80105e7c <sys_unlink+0x1cc>
  if (ip->type == T_DIR && !isdirempty(ip))
80105d60:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d65:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105d68:	74 66                	je     80105dd0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105d6a:	83 ec 04             	sub    $0x4,%esp
80105d6d:	6a 10                	push   $0x10
80105d6f:	6a 00                	push   $0x0
80105d71:	57                   	push   %edi
80105d72:	e8 f9 f4 ff ff       	call   80105270 <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80105d77:	6a 10                	push   $0x10
80105d79:	ff 75 c4             	push   -0x3c(%ebp)
80105d7c:	57                   	push   %edi
80105d7d:	ff 75 b4             	push   -0x4c(%ebp)
80105d80:	e8 0b be ff ff       	call   80101b90 <writei>
80105d85:	83 c4 20             	add    $0x20,%esp
80105d88:	83 f8 10             	cmp    $0x10,%eax
80105d8b:	0f 85 de 00 00 00    	jne    80105e6f <sys_unlink+0x1bf>
  if (ip->type == T_DIR)
80105d91:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d96:	0f 84 94 00 00 00    	je     80105e30 <sys_unlink+0x180>
  iunlockput(dp);
80105d9c:	83 ec 0c             	sub    $0xc,%esp
80105d9f:	ff 75 b4             	push   -0x4c(%ebp)
80105da2:	e8 69 bc ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105da7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105dac:	89 1c 24             	mov    %ebx,(%esp)
80105daf:	e8 1c b9 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105db4:	89 1c 24             	mov    %ebx,(%esp)
80105db7:	e8 54 bc ff ff       	call   80101a10 <iunlockput>
  end_op();
80105dbc:	e8 0f d0 ff ff       	call   80102dd0 <end_op>
  return 0;
80105dc1:	83 c4 10             	add    $0x10,%esp
80105dc4:	31 c0                	xor    %eax,%eax
}
80105dc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dc9:	5b                   	pop    %ebx
80105dca:	5e                   	pop    %esi
80105dcb:	5f                   	pop    %edi
80105dcc:	5d                   	pop    %ebp
80105dcd:	c3                   	ret    
80105dce:	66 90                	xchg   %ax,%ax
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
80105dd0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105dd4:	76 94                	jbe    80105d6a <sys_unlink+0xba>
80105dd6:	be 20 00 00 00       	mov    $0x20,%esi
80105ddb:	eb 0b                	jmp    80105de8 <sys_unlink+0x138>
80105ddd:	8d 76 00             	lea    0x0(%esi),%esi
80105de0:	83 c6 10             	add    $0x10,%esi
80105de3:	3b 73 58             	cmp    0x58(%ebx),%esi
80105de6:	73 82                	jae    80105d6a <sys_unlink+0xba>
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80105de8:	6a 10                	push   $0x10
80105dea:	56                   	push   %esi
80105deb:	57                   	push   %edi
80105dec:	53                   	push   %ebx
80105ded:	e8 9e bc ff ff       	call   80101a90 <readi>
80105df2:	83 c4 10             	add    $0x10,%esp
80105df5:	83 f8 10             	cmp    $0x10,%eax
80105df8:	75 68                	jne    80105e62 <sys_unlink+0x1b2>
    if (de.inum != 0)
80105dfa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105dff:	74 df                	je     80105de0 <sys_unlink+0x130>
    iunlockput(ip);
80105e01:	83 ec 0c             	sub    $0xc,%esp
80105e04:	53                   	push   %ebx
80105e05:	e8 06 bc ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105e0a:	83 c4 10             	add    $0x10,%esp
80105e0d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105e10:	83 ec 0c             	sub    $0xc,%esp
80105e13:	ff 75 b4             	push   -0x4c(%ebp)
80105e16:	e8 f5 bb ff ff       	call   80101a10 <iunlockput>
  end_op();
80105e1b:	e8 b0 cf ff ff       	call   80102dd0 <end_op>
  return -1;
80105e20:	83 c4 10             	add    $0x10,%esp
80105e23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e28:	eb 9c                	jmp    80105dc6 <sys_unlink+0x116>
80105e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105e30:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105e33:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105e36:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105e3b:	50                   	push   %eax
80105e3c:	e8 8f b8 ff ff       	call   801016d0 <iupdate>
80105e41:	83 c4 10             	add    $0x10,%esp
80105e44:	e9 53 ff ff ff       	jmp    80105d9c <sys_unlink+0xec>
    return -1;
80105e49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e4e:	e9 73 ff ff ff       	jmp    80105dc6 <sys_unlink+0x116>
    end_op();
80105e53:	e8 78 cf ff ff       	call   80102dd0 <end_op>
    return -1;
80105e58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e5d:	e9 64 ff ff ff       	jmp    80105dc6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105e62:	83 ec 0c             	sub    $0xc,%esp
80105e65:	68 cc 8d 10 80       	push   $0x80108dcc
80105e6a:	e8 11 a5 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105e6f:	83 ec 0c             	sub    $0xc,%esp
80105e72:	68 de 8d 10 80       	push   $0x80108dde
80105e77:	e8 04 a5 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105e7c:	83 ec 0c             	sub    $0xc,%esp
80105e7f:	68 ba 8d 10 80       	push   $0x80108dba
80105e84:	e8 f7 a4 ff ff       	call   80100380 <panic>
80105e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e90 <sys_open>:

int sys_open(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	57                   	push   %edi
80105e94:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e95:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105e98:	53                   	push   %ebx
80105e99:	83 ec 24             	sub    $0x24,%esp
  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e9c:	50                   	push   %eax
80105e9d:	6a 00                	push   $0x0
80105e9f:	e8 dc f7 ff ff       	call   80105680 <argstr>
80105ea4:	83 c4 10             	add    $0x10,%esp
80105ea7:	85 c0                	test   %eax,%eax
80105ea9:	0f 88 8e 00 00 00    	js     80105f3d <sys_open+0xad>
80105eaf:	83 ec 08             	sub    $0x8,%esp
80105eb2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105eb5:	50                   	push   %eax
80105eb6:	6a 01                	push   $0x1
80105eb8:	e8 b3 f6 ff ff       	call   80105570 <argint>
80105ebd:	83 c4 10             	add    $0x10,%esp
80105ec0:	85 c0                	test   %eax,%eax
80105ec2:	78 79                	js     80105f3d <sys_open+0xad>
    return -1;

  begin_op();
80105ec4:	e8 97 ce ff ff       	call   80102d60 <begin_op>

  if (omode & O_CREATE)
80105ec9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105ecd:	75 79                	jne    80105f48 <sys_open+0xb8>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(path)) == 0)
80105ecf:	83 ec 0c             	sub    $0xc,%esp
80105ed2:	ff 75 e0             	push   -0x20(%ebp)
80105ed5:	e8 c6 c1 ff ff       	call   801020a0 <namei>
80105eda:	83 c4 10             	add    $0x10,%esp
80105edd:	89 c6                	mov    %eax,%esi
80105edf:	85 c0                	test   %eax,%eax
80105ee1:	0f 84 7e 00 00 00    	je     80105f65 <sys_open+0xd5>
    {
      end_op();
      return -1;
    }
    ilock(ip);
80105ee7:	83 ec 0c             	sub    $0xc,%esp
80105eea:	50                   	push   %eax
80105eeb:	e8 90 b8 ff ff       	call   80101780 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
80105ef0:	83 c4 10             	add    $0x10,%esp
80105ef3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105ef8:	0f 84 c2 00 00 00    	je     80105fc0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80105efe:	e8 2d af ff ff       	call   80100e30 <filealloc>
80105f03:	89 c7                	mov    %eax,%edi
80105f05:	85 c0                	test   %eax,%eax
80105f07:	74 23                	je     80105f2c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105f09:	e8 e2 db ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105f0e:	31 db                	xor    %ebx,%ebx
    if (curproc->ofile[fd] == 0)
80105f10:	8b 54 98 34          	mov    0x34(%eax,%ebx,4),%edx
80105f14:	85 d2                	test   %edx,%edx
80105f16:	74 60                	je     80105f78 <sys_open+0xe8>
  for (fd = 0; fd < NOFILE; fd++)
80105f18:	83 c3 01             	add    $0x1,%ebx
80105f1b:	83 fb 10             	cmp    $0x10,%ebx
80105f1e:	75 f0                	jne    80105f10 <sys_open+0x80>
  {
    if (f)
      fileclose(f);
80105f20:	83 ec 0c             	sub    $0xc,%esp
80105f23:	57                   	push   %edi
80105f24:	e8 c7 af ff ff       	call   80100ef0 <fileclose>
80105f29:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105f2c:	83 ec 0c             	sub    $0xc,%esp
80105f2f:	56                   	push   %esi
80105f30:	e8 db ba ff ff       	call   80101a10 <iunlockput>
    end_op();
80105f35:	e8 96 ce ff ff       	call   80102dd0 <end_op>
    return -1;
80105f3a:	83 c4 10             	add    $0x10,%esp
80105f3d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f42:	eb 6d                	jmp    80105fb1 <sys_open+0x121>
80105f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105f48:	83 ec 0c             	sub    $0xc,%esp
80105f4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105f4e:	31 c9                	xor    %ecx,%ecx
80105f50:	ba 02 00 00 00       	mov    $0x2,%edx
80105f55:	6a 00                	push   $0x0
80105f57:	e8 14 f8 ff ff       	call   80105770 <create>
    if (ip == 0)
80105f5c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105f5f:	89 c6                	mov    %eax,%esi
    if (ip == 0)
80105f61:	85 c0                	test   %eax,%eax
80105f63:	75 99                	jne    80105efe <sys_open+0x6e>
      end_op();
80105f65:	e8 66 ce ff ff       	call   80102dd0 <end_op>
      return -1;
80105f6a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f6f:	eb 40                	jmp    80105fb1 <sys_open+0x121>
80105f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105f78:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105f7b:	89 7c 98 34          	mov    %edi,0x34(%eax,%ebx,4)
  iunlock(ip);
80105f7f:	56                   	push   %esi
80105f80:	e8 db b8 ff ff       	call   80101860 <iunlock>
  end_op();
80105f85:	e8 46 ce ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
80105f8a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105f90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f93:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105f96:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105f99:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105f9b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105fa2:	f7 d0                	not    %eax
80105fa4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105fa7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105faa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105fad:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fb4:	89 d8                	mov    %ebx,%eax
80105fb6:	5b                   	pop    %ebx
80105fb7:	5e                   	pop    %esi
80105fb8:	5f                   	pop    %edi
80105fb9:	5d                   	pop    %ebp
80105fba:	c3                   	ret    
80105fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fbf:	90                   	nop
    if (ip->type == T_DIR && omode != O_RDONLY)
80105fc0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105fc3:	85 c9                	test   %ecx,%ecx
80105fc5:	0f 84 33 ff ff ff    	je     80105efe <sys_open+0x6e>
80105fcb:	e9 5c ff ff ff       	jmp    80105f2c <sys_open+0x9c>

80105fd0 <sys_mkdir>:

int sys_mkdir(void)
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105fd6:	e8 85 cd ff ff       	call   80102d60 <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
80105fdb:	83 ec 08             	sub    $0x8,%esp
80105fde:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fe1:	50                   	push   %eax
80105fe2:	6a 00                	push   $0x0
80105fe4:	e8 97 f6 ff ff       	call   80105680 <argstr>
80105fe9:	83 c4 10             	add    $0x10,%esp
80105fec:	85 c0                	test   %eax,%eax
80105fee:	78 30                	js     80106020 <sys_mkdir+0x50>
80105ff0:	83 ec 0c             	sub    $0xc,%esp
80105ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ff6:	31 c9                	xor    %ecx,%ecx
80105ff8:	ba 01 00 00 00       	mov    $0x1,%edx
80105ffd:	6a 00                	push   $0x0
80105fff:	e8 6c f7 ff ff       	call   80105770 <create>
80106004:	83 c4 10             	add    $0x10,%esp
80106007:	85 c0                	test   %eax,%eax
80106009:	74 15                	je     80106020 <sys_mkdir+0x50>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
8010600b:	83 ec 0c             	sub    $0xc,%esp
8010600e:	50                   	push   %eax
8010600f:	e8 fc b9 ff ff       	call   80101a10 <iunlockput>
  end_op();
80106014:	e8 b7 cd ff ff       	call   80102dd0 <end_op>
  return 0;
80106019:	83 c4 10             	add    $0x10,%esp
8010601c:	31 c0                	xor    %eax,%eax
}
8010601e:	c9                   	leave  
8010601f:	c3                   	ret    
    end_op();
80106020:	e8 ab cd ff ff       	call   80102dd0 <end_op>
    return -1;
80106025:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010602a:	c9                   	leave  
8010602b:	c3                   	ret    
8010602c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106030 <sys_mknod>:

int sys_mknod(void)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106036:	e8 25 cd ff ff       	call   80102d60 <begin_op>
  if ((argstr(0, &path)) < 0 ||
8010603b:	83 ec 08             	sub    $0x8,%esp
8010603e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106041:	50                   	push   %eax
80106042:	6a 00                	push   $0x0
80106044:	e8 37 f6 ff ff       	call   80105680 <argstr>
80106049:	83 c4 10             	add    $0x10,%esp
8010604c:	85 c0                	test   %eax,%eax
8010604e:	78 60                	js     801060b0 <sys_mknod+0x80>
      argint(1, &major) < 0 ||
80106050:	83 ec 08             	sub    $0x8,%esp
80106053:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106056:	50                   	push   %eax
80106057:	6a 01                	push   $0x1
80106059:	e8 12 f5 ff ff       	call   80105570 <argint>
  if ((argstr(0, &path)) < 0 ||
8010605e:	83 c4 10             	add    $0x10,%esp
80106061:	85 c0                	test   %eax,%eax
80106063:	78 4b                	js     801060b0 <sys_mknod+0x80>
      argint(2, &minor) < 0 ||
80106065:	83 ec 08             	sub    $0x8,%esp
80106068:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010606b:	50                   	push   %eax
8010606c:	6a 02                	push   $0x2
8010606e:	e8 fd f4 ff ff       	call   80105570 <argint>
      argint(1, &major) < 0 ||
80106073:	83 c4 10             	add    $0x10,%esp
80106076:	85 c0                	test   %eax,%eax
80106078:	78 36                	js     801060b0 <sys_mknod+0x80>
      (ip = create(path, T_DEV, major, minor)) == 0)
8010607a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010607e:	83 ec 0c             	sub    $0xc,%esp
80106081:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106085:	ba 03 00 00 00       	mov    $0x3,%edx
8010608a:	50                   	push   %eax
8010608b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010608e:	e8 dd f6 ff ff       	call   80105770 <create>
      argint(2, &minor) < 0 ||
80106093:	83 c4 10             	add    $0x10,%esp
80106096:	85 c0                	test   %eax,%eax
80106098:	74 16                	je     801060b0 <sys_mknod+0x80>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
8010609a:	83 ec 0c             	sub    $0xc,%esp
8010609d:	50                   	push   %eax
8010609e:	e8 6d b9 ff ff       	call   80101a10 <iunlockput>
  end_op();
801060a3:	e8 28 cd ff ff       	call   80102dd0 <end_op>
  return 0;
801060a8:	83 c4 10             	add    $0x10,%esp
801060ab:	31 c0                	xor    %eax,%eax
}
801060ad:	c9                   	leave  
801060ae:	c3                   	ret    
801060af:	90                   	nop
    end_op();
801060b0:	e8 1b cd ff ff       	call   80102dd0 <end_op>
    return -1;
801060b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060ba:	c9                   	leave  
801060bb:	c3                   	ret    
801060bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060c0 <sys_chdir>:

int sys_chdir(void)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	56                   	push   %esi
801060c4:	53                   	push   %ebx
801060c5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801060c8:	e8 23 da ff ff       	call   80103af0 <myproc>
801060cd:	89 c6                	mov    %eax,%esi

  begin_op();
801060cf:	e8 8c cc ff ff       	call   80102d60 <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
801060d4:	83 ec 08             	sub    $0x8,%esp
801060d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060da:	50                   	push   %eax
801060db:	6a 00                	push   $0x0
801060dd:	e8 9e f5 ff ff       	call   80105680 <argstr>
801060e2:	83 c4 10             	add    $0x10,%esp
801060e5:	85 c0                	test   %eax,%eax
801060e7:	78 77                	js     80106160 <sys_chdir+0xa0>
801060e9:	83 ec 0c             	sub    $0xc,%esp
801060ec:	ff 75 f4             	push   -0xc(%ebp)
801060ef:	e8 ac bf ff ff       	call   801020a0 <namei>
801060f4:	83 c4 10             	add    $0x10,%esp
801060f7:	89 c3                	mov    %eax,%ebx
801060f9:	85 c0                	test   %eax,%eax
801060fb:	74 63                	je     80106160 <sys_chdir+0xa0>
  {
    end_op();
    return -1;
  }
  ilock(ip);
801060fd:	83 ec 0c             	sub    $0xc,%esp
80106100:	50                   	push   %eax
80106101:	e8 7a b6 ff ff       	call   80101780 <ilock>
  if (ip->type != T_DIR)
80106106:	83 c4 10             	add    $0x10,%esp
80106109:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010610e:	75 30                	jne    80106140 <sys_chdir+0x80>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106110:	83 ec 0c             	sub    $0xc,%esp
80106113:	53                   	push   %ebx
80106114:	e8 47 b7 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80106119:	58                   	pop    %eax
8010611a:	ff 76 74             	push   0x74(%esi)
8010611d:	e8 8e b7 ff ff       	call   801018b0 <iput>
  end_op();
80106122:	e8 a9 cc ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80106127:	89 5e 74             	mov    %ebx,0x74(%esi)
  return 0;
8010612a:	83 c4 10             	add    $0x10,%esp
8010612d:	31 c0                	xor    %eax,%eax
}
8010612f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106132:	5b                   	pop    %ebx
80106133:	5e                   	pop    %esi
80106134:	5d                   	pop    %ebp
80106135:	c3                   	ret    
80106136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010613d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80106140:	83 ec 0c             	sub    $0xc,%esp
80106143:	53                   	push   %ebx
80106144:	e8 c7 b8 ff ff       	call   80101a10 <iunlockput>
    end_op();
80106149:	e8 82 cc ff ff       	call   80102dd0 <end_op>
    return -1;
8010614e:	83 c4 10             	add    $0x10,%esp
80106151:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106156:	eb d7                	jmp    8010612f <sys_chdir+0x6f>
80106158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010615f:	90                   	nop
    end_op();
80106160:	e8 6b cc ff ff       	call   80102dd0 <end_op>
    return -1;
80106165:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010616a:	eb c3                	jmp    8010612f <sys_chdir+0x6f>
8010616c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106170 <sys_exec>:

int sys_exec(void)
{
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	57                   	push   %edi
80106174:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80106175:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010617b:	53                   	push   %ebx
8010617c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80106182:	50                   	push   %eax
80106183:	6a 00                	push   $0x0
80106185:	e8 f6 f4 ff ff       	call   80105680 <argstr>
8010618a:	83 c4 10             	add    $0x10,%esp
8010618d:	85 c0                	test   %eax,%eax
8010618f:	0f 88 87 00 00 00    	js     8010621c <sys_exec+0xac>
80106195:	83 ec 08             	sub    $0x8,%esp
80106198:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010619e:	50                   	push   %eax
8010619f:	6a 01                	push   $0x1
801061a1:	e8 ca f3 ff ff       	call   80105570 <argint>
801061a6:	83 c4 10             	add    $0x10,%esp
801061a9:	85 c0                	test   %eax,%eax
801061ab:	78 6f                	js     8010621c <sys_exec+0xac>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801061ad:	83 ec 04             	sub    $0x4,%esp
801061b0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for (i = 0;; i++)
801061b6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801061b8:	68 80 00 00 00       	push   $0x80
801061bd:	6a 00                	push   $0x0
801061bf:	56                   	push   %esi
801061c0:	e8 ab f0 ff ff       	call   80105270 <memset>
801061c5:	83 c4 10             	add    $0x10,%esp
801061c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061cf:	90                   	nop
  {
    if (i >= NELEM(argv))
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
801061d0:	83 ec 08             	sub    $0x8,%esp
801061d3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801061d9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801061e0:	50                   	push   %eax
801061e1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801061e7:	01 f8                	add    %edi,%eax
801061e9:	50                   	push   %eax
801061ea:	e8 b1 f2 ff ff       	call   801054a0 <fetchint>
801061ef:	83 c4 10             	add    $0x10,%esp
801061f2:	85 c0                	test   %eax,%eax
801061f4:	78 26                	js     8010621c <sys_exec+0xac>
      return -1;
    if (uarg == 0)
801061f6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801061fc:	85 c0                	test   %eax,%eax
801061fe:	74 30                	je     80106230 <sys_exec+0xc0>
    {
      argv[i] = 0;
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
80106200:	83 ec 08             	sub    $0x8,%esp
80106203:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80106206:	52                   	push   %edx
80106207:	50                   	push   %eax
80106208:	e8 d3 f2 ff ff       	call   801054e0 <fetchstr>
8010620d:	83 c4 10             	add    $0x10,%esp
80106210:	85 c0                	test   %eax,%eax
80106212:	78 08                	js     8010621c <sys_exec+0xac>
  for (i = 0;; i++)
80106214:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
80106217:	83 fb 20             	cmp    $0x20,%ebx
8010621a:	75 b4                	jne    801061d0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010621c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010621f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106224:	5b                   	pop    %ebx
80106225:	5e                   	pop    %esi
80106226:	5f                   	pop    %edi
80106227:	5d                   	pop    %ebp
80106228:	c3                   	ret    
80106229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106230:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106237:	00 00 00 00 
  return exec(path, argv);
8010623b:	83 ec 08             	sub    $0x8,%esp
8010623e:	56                   	push   %esi
8010623f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80106245:	e8 66 a8 ff ff       	call   80100ab0 <exec>
8010624a:	83 c4 10             	add    $0x10,%esp
}
8010624d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106250:	5b                   	pop    %ebx
80106251:	5e                   	pop    %esi
80106252:	5f                   	pop    %edi
80106253:	5d                   	pop    %ebp
80106254:	c3                   	ret    
80106255:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010625c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106260 <sys_pipe>:

int sys_pipe(void)
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	57                   	push   %edi
80106264:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80106265:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106268:	53                   	push   %ebx
80106269:	83 ec 20             	sub    $0x20,%esp
  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
8010626c:	6a 08                	push   $0x8
8010626e:	50                   	push   %eax
8010626f:	6a 00                	push   $0x0
80106271:	e8 9a f3 ff ff       	call   80105610 <argptr>
80106276:	83 c4 10             	add    $0x10,%esp
80106279:	85 c0                	test   %eax,%eax
8010627b:	78 4a                	js     801062c7 <sys_pipe+0x67>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
8010627d:	83 ec 08             	sub    $0x8,%esp
80106280:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106283:	50                   	push   %eax
80106284:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106287:	50                   	push   %eax
80106288:	e8 a3 d1 ff ff       	call   80103430 <pipealloc>
8010628d:	83 c4 10             	add    $0x10,%esp
80106290:	85 c0                	test   %eax,%eax
80106292:	78 33                	js     801062c7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80106294:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (fd = 0; fd < NOFILE; fd++)
80106297:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106299:	e8 52 d8 ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
8010629e:	66 90                	xchg   %ax,%ax
    if (curproc->ofile[fd] == 0)
801062a0:	8b 74 98 34          	mov    0x34(%eax,%ebx,4),%esi
801062a4:	85 f6                	test   %esi,%esi
801062a6:	74 28                	je     801062d0 <sys_pipe+0x70>
  for (fd = 0; fd < NOFILE; fd++)
801062a8:	83 c3 01             	add    $0x1,%ebx
801062ab:	83 fb 10             	cmp    $0x10,%ebx
801062ae:	75 f0                	jne    801062a0 <sys_pipe+0x40>
  {
    if (fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801062b0:	83 ec 0c             	sub    $0xc,%esp
801062b3:	ff 75 e0             	push   -0x20(%ebp)
801062b6:	e8 35 ac ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
801062bb:	58                   	pop    %eax
801062bc:	ff 75 e4             	push   -0x1c(%ebp)
801062bf:	e8 2c ac ff ff       	call   80100ef0 <fileclose>
    return -1;
801062c4:	83 c4 10             	add    $0x10,%esp
801062c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062cc:	eb 53                	jmp    80106321 <sys_pipe+0xc1>
801062ce:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801062d0:	8d 73 0c             	lea    0xc(%ebx),%esi
801062d3:	89 7c b0 04          	mov    %edi,0x4(%eax,%esi,4)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
801062d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801062da:	e8 11 d8 ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
801062df:	31 d2                	xor    %edx,%edx
801062e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd] == 0)
801062e8:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
801062ec:	85 c9                	test   %ecx,%ecx
801062ee:	74 20                	je     80106310 <sys_pipe+0xb0>
  for (fd = 0; fd < NOFILE; fd++)
801062f0:	83 c2 01             	add    $0x1,%edx
801062f3:	83 fa 10             	cmp    $0x10,%edx
801062f6:	75 f0                	jne    801062e8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801062f8:	e8 f3 d7 ff ff       	call   80103af0 <myproc>
801062fd:	c7 44 b0 04 00 00 00 	movl   $0x0,0x4(%eax,%esi,4)
80106304:	00 
80106305:	eb a9                	jmp    801062b0 <sys_pipe+0x50>
80106307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010630e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106310:	89 7c 90 34          	mov    %edi,0x34(%eax,%edx,4)
  }
  fd[0] = fd0;
80106314:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106317:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106319:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010631c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010631f:	31 c0                	xor    %eax,%eax
}
80106321:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106324:	5b                   	pop    %ebx
80106325:	5e                   	pop    %esi
80106326:	5f                   	pop    %edi
80106327:	5d                   	pop    %ebp
80106328:	c3                   	ret    
80106329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106330 <sys_copy_file>:
}



int sys_copy_file(void)
{
80106330:	55                   	push   %ebp
80106331:	89 e5                	mov    %esp,%ebp
80106333:	57                   	push   %edi
80106334:	56                   	push   %esi
80106335:	53                   	push   %ebx
80106336:	81 ec 00 10 00 00    	sub    $0x1000,%esp
8010633c:	83 0c 24 00          	orl    $0x0,(%esp)
80106340:	83 ec 34             	sub    $0x34,%esp
  char *dest;
  int fd;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &src) < 0 || argstr(1, &dest) < 0)
80106343:	8d 85 e0 ef ff ff    	lea    -0x1020(%ebp),%eax
80106349:	50                   	push   %eax
8010634a:	6a 00                	push   $0x0
8010634c:	e8 2f f3 ff ff       	call   80105680 <argstr>
80106351:	83 c4 10             	add    $0x10,%esp
80106354:	85 c0                	test   %eax,%eax
80106356:	0f 88 81 01 00 00    	js     801064dd <sys_copy_file+0x1ad>
8010635c:	83 ec 08             	sub    $0x8,%esp
8010635f:	8d 85 e4 ef ff ff    	lea    -0x101c(%ebp),%eax
80106365:	50                   	push   %eax
80106366:	6a 01                	push   $0x1
80106368:	e8 13 f3 ff ff       	call   80105680 <argstr>
8010636d:	83 c4 10             	add    $0x10,%esp
80106370:	85 c0                	test   %eax,%eax
80106372:	0f 88 65 01 00 00    	js     801064dd <sys_copy_file+0x1ad>
    return -1;

  begin_op();
80106378:	e8 e3 c9 ff ff       	call   80102d60 <begin_op>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(src)) == 0)
8010637d:	83 ec 0c             	sub    $0xc,%esp
80106380:	ff b5 e0 ef ff ff    	push   -0x1020(%ebp)
80106386:	e8 15 bd ff ff       	call   801020a0 <namei>
8010638b:	83 c4 10             	add    $0x10,%esp
8010638e:	89 c6                	mov    %eax,%esi
80106390:	85 c0                	test   %eax,%eax
80106392:	0f 84 c0 01 00 00    	je     80106558 <sys_copy_file+0x228>
    {
      end_op();
      return -1;
    }
    ilock(ip);
80106398:	83 ec 0c             	sub    $0xc,%esp
8010639b:	50                   	push   %eax
8010639c:	e8 df b3 ff ff       	call   80101780 <ilock>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
801063a1:	e8 8a aa ff ff       	call   80100e30 <filealloc>
801063a6:	83 c4 10             	add    $0x10,%esp
801063a9:	89 c7                	mov    %eax,%edi
801063ab:	85 c0                	test   %eax,%eax
801063ad:	74 2d                	je     801063dc <sys_copy_file+0xac>
  struct proc *curproc = myproc();
801063af:	e8 3c d7 ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
801063b4:	31 d2                	xor    %edx,%edx
801063b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063bd:	8d 76 00             	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
801063c0:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
801063c4:	85 c9                	test   %ecx,%ecx
801063c6:	74 38                	je     80106400 <sys_copy_file+0xd0>
  for (fd = 0; fd < NOFILE; fd++)
801063c8:	83 c2 01             	add    $0x1,%edx
801063cb:	83 fa 10             	cmp    $0x10,%edx
801063ce:	75 f0                	jne    801063c0 <sys_copy_file+0x90>
  {
    if (f)
      fileclose(f);
801063d0:	83 ec 0c             	sub    $0xc,%esp
801063d3:	57                   	push   %edi
801063d4:	e8 17 ab ff ff       	call   80100ef0 <fileclose>
801063d9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801063dc:	83 ec 0c             	sub    $0xc,%esp
801063df:	56                   	push   %esi
801063e0:	e8 2b b6 ff ff       	call   80101a10 <iunlockput>
    end_op();
801063e5:	e8 e6 c9 ff ff       	call   80102dd0 <end_op>
    return -1;
801063ea:	83 c4 10             	add    $0x10,%esp
801063ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063f2:	e9 59 01 00 00       	jmp    80106550 <sys_copy_file+0x220>
801063f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063fe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106400:	8d 5a 0c             	lea    0xc(%edx),%ebx
  }
  iunlock(ip);
80106403:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106406:	89 7c 98 04          	mov    %edi,0x4(%eax,%ebx,4)
  iunlock(ip);
8010640a:	56                   	push   %esi
8010640b:	e8 50 b4 ff ff       	call   80101860 <iunlock>
  end_op();
80106410:	e8 bb c9 ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(O_RDONLY & O_WRONLY);
80106415:	b8 01 00 00 00       	mov    $0x1,%eax
  f->ip = ip;
8010641a:	89 77 10             	mov    %esi,0x10(%edi)
  f->type = FD_INODE;
8010641d:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->off = 0;
80106423:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(O_RDONLY & O_WRONLY);
8010642a:	66 89 47 08          	mov    %ax,0x8(%edi)
  if((f = myproc() -> ofile[fd]) == 0){
8010642e:	e8 bd d6 ff ff       	call   80103af0 <myproc>
80106433:	83 c4 10             	add    $0x10,%esp
80106436:	8b 44 98 04          	mov    0x4(%eax,%ebx,4),%eax
8010643a:	85 c0                	test   %eax,%eax
8010643c:	0f 84 9b 00 00 00    	je     801064dd <sys_copy_file+0x1ad>
  f->writable = (O_RDONLY & O_WRONLY) || (O_RDONLY & O_RDWR);
  
  char p[4096];
  if (my_argfd(0, 0, &f, fd) < 0)
      return -1;
  int read_chars = fileread(f, p, 4096);
80106442:	83 ec 04             	sub    $0x4,%esp
80106445:	8d bd e8 ef ff ff    	lea    -0x1018(%ebp),%edi
8010644b:	68 00 10 00 00       	push   $0x1000
80106450:	57                   	push   %edi
80106451:	50                   	push   %eax
80106452:	e8 c9 ab ff ff       	call   80101020 <fileread>
80106457:	89 85 d4 ef ff ff    	mov    %eax,-0x102c(%ebp)
  //dest
  int fd2;
  struct file *f2;
  struct inode *ip2;
  begin_op();
8010645d:	e8 fe c8 ff ff       	call   80102d60 <begin_op>
      return -1;
    }
  }
  else
  {
    if ((ip2 = namei(dest)) == 0)
80106462:	58                   	pop    %eax
80106463:	ff b5 e4 ef ff ff    	push   -0x101c(%ebp)
80106469:	e8 32 bc ff ff       	call   801020a0 <namei>
8010646e:	83 c4 10             	add    $0x10,%esp
80106471:	89 c3                	mov    %eax,%ebx
80106473:	85 c0                	test   %eax,%eax
80106475:	0f 84 dd 00 00 00    	je     80106558 <sys_copy_file+0x228>
    {
      end_op();
      return -1;
    }
    ilock(ip2);
8010647b:	83 ec 0c             	sub    $0xc,%esp
8010647e:	50                   	push   %eax
8010647f:	e8 fc b2 ff ff       	call   80101780 <ilock>
    if (ip2->type == T_DIR && dest != O_RDONLY)
80106484:	83 c4 10             	add    $0x10,%esp
80106487:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010648c:	75 0a                	jne    80106498 <sys_copy_file+0x168>
8010648e:	8b b5 e4 ef ff ff    	mov    -0x101c(%ebp),%esi
80106494:	85 f6                	test   %esi,%esi
80106496:	75 34                	jne    801064cc <sys_copy_file+0x19c>
      end_op();
      return -1;
    }
  }

  if ((f2 = filealloc()) == 0 || (fd2 = fdalloc(f2)) < 0)
80106498:	e8 93 a9 ff ff       	call   80100e30 <filealloc>
8010649d:	89 c6                	mov    %eax,%esi
8010649f:	85 c0                	test   %eax,%eax
801064a1:	74 29                	je     801064cc <sys_copy_file+0x19c>
  struct proc *curproc = myproc();
801064a3:	e8 48 d6 ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
801064a8:	31 d2                	xor    %edx,%edx
801064aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
801064b0:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
801064b4:	85 c9                	test   %ecx,%ecx
801064b6:	74 30                	je     801064e8 <sys_copy_file+0x1b8>
  for (fd = 0; fd < NOFILE; fd++)
801064b8:	83 c2 01             	add    $0x1,%edx
801064bb:	83 fa 10             	cmp    $0x10,%edx
801064be:	75 f0                	jne    801064b0 <sys_copy_file+0x180>
  {
    if (f2)
      fileclose(f2);
801064c0:	83 ec 0c             	sub    $0xc,%esp
801064c3:	56                   	push   %esi
801064c4:	e8 27 aa ff ff       	call   80100ef0 <fileclose>
801064c9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip2);
801064cc:	83 ec 0c             	sub    $0xc,%esp
801064cf:	53                   	push   %ebx
801064d0:	e8 3b b5 ff ff       	call   80101a10 <iunlockput>
    end_op();
801064d5:	e8 f6 c8 ff ff       	call   80102dd0 <end_op>
    return -1;
801064da:	83 c4 10             	add    $0x10,%esp
801064dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064e2:	eb 6c                	jmp    80106550 <sys_copy_file+0x220>
801064e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
801064e8:	83 c2 0c             	add    $0xc,%edx
  }
  iunlock(ip2);
801064eb:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801064ee:	89 74 90 04          	mov    %esi,0x4(%eax,%edx,4)
  iunlock(ip2);
801064f2:	53                   	push   %ebx
      curproc->ofile[fd] = f;
801064f3:	89 95 d0 ef ff ff    	mov    %edx,-0x1030(%ebp)
  iunlock(ip2);
801064f9:	e8 62 b3 ff ff       	call   80101860 <iunlock>
  end_op();
801064fe:	e8 cd c8 ff ff       	call   80102dd0 <end_op>

  f2->type = FD_INODE;
  f2->ip = ip2;
  f2->off = 0;
  f2->readable = !(O_WRONLY & O_WRONLY);
80106503:	b8 00 01 00 00       	mov    $0x100,%eax
  f2->ip = ip2;
80106508:	89 5e 10             	mov    %ebx,0x10(%esi)
  f2->type = FD_INODE;
8010650b:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f2->off = 0;
80106511:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f2->readable = !(O_WRONLY & O_WRONLY);
80106518:	66 89 46 08          	mov    %ax,0x8(%esi)
  if((f = myproc() -> ofile[fd]) == 0){
8010651c:	e8 cf d5 ff ff       	call   80103af0 <myproc>
80106521:	8b 95 d0 ef ff ff    	mov    -0x1030(%ebp),%edx
80106527:	83 c4 10             	add    $0x10,%esp
8010652a:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010652e:	85 c0                	test   %eax,%eax
80106530:	74 ab                	je     801064dd <sys_copy_file+0x1ad>
  f2->writable = (O_WRONLY & O_WRONLY) || (O_WRONLY & O_RDWR);
  if (my_argfd(0, 0, &f2, fd2) < 0)
      return -1;   
  int written_chars = filewrite(f2, p, read_chars);
80106532:	8b 9d d4 ef ff ff    	mov    -0x102c(%ebp),%ebx
80106538:	83 ec 04             	sub    $0x4,%esp
8010653b:	53                   	push   %ebx
8010653c:	57                   	push   %edi
8010653d:	50                   	push   %eax
8010653e:	e8 6d ab ff ff       	call   801010b0 <filewrite>
  if(written_chars != read_chars){
80106543:	83 c4 10             	add    $0x10,%esp
80106546:	39 c3                	cmp    %eax,%ebx
80106548:	0f 95 c0             	setne  %al
8010654b:	0f b6 c0             	movzbl %al,%eax
8010654e:	f7 d8                	neg    %eax
    return -1;
  }
  else{
    return 0;
  }
80106550:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106553:	5b                   	pop    %ebx
80106554:	5e                   	pop    %esi
80106555:	5f                   	pop    %edi
80106556:	5d                   	pop    %ebp
80106557:	c3                   	ret    
      end_op();
80106558:	e8 73 c8 ff ff       	call   80102dd0 <end_op>
      return -1;
8010655d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106562:	eb ec                	jmp    80106550 <sys_copy_file+0x220>
80106564:	66 90                	xchg   %ax,%ax
80106566:	66 90                	xchg   %ax,%ax
80106568:	66 90                	xchg   %ax,%ax
8010656a:	66 90                	xchg   %ax,%ax
8010656c:	66 90                	xchg   %ax,%ax
8010656e:	66 90                	xchg   %ax,%ax

80106570 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int sys_fork(void)
{
  return fork();
80106570:	e9 9b dc ff ff       	jmp    80104210 <fork>
80106575:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010657c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106580 <sys_exit>:
}

int sys_exit(void)
{
80106580:	55                   	push   %ebp
80106581:	89 e5                	mov    %esp,%ebp
80106583:	83 ec 08             	sub    $0x8,%esp
  exit();
80106586:	e8 b5 e1 ff ff       	call   80104740 <exit>
  return 0; // not reached
}
8010658b:	31 c0                	xor    %eax,%eax
8010658d:	c9                   	leave  
8010658e:	c3                   	ret    
8010658f:	90                   	nop

80106590 <sys_wait>:

int sys_wait(void)
{
  return wait();
80106590:	e9 db e2 ff ff       	jmp    80104870 <wait>
80106595:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010659c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801065a0 <sys_kill>:
}

int sys_kill(void)
{
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
801065a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
801065a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065a9:	50                   	push   %eax
801065aa:	6a 00                	push   $0x0
801065ac:	e8 bf ef ff ff       	call   80105570 <argint>
801065b1:	83 c4 10             	add    $0x10,%esp
801065b4:	85 c0                	test   %eax,%eax
801065b6:	78 18                	js     801065d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801065b8:	83 ec 0c             	sub    $0xc,%esp
801065bb:	ff 75 f4             	push   -0xc(%ebp)
801065be:	e8 8d e5 ff ff       	call   80104b50 <kill>
801065c3:	83 c4 10             	add    $0x10,%esp
}
801065c6:	c9                   	leave  
801065c7:	c3                   	ret    
801065c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065cf:	90                   	nop
801065d0:	c9                   	leave  
    return -1;
801065d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065d6:	c3                   	ret    
801065d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065de:	66 90                	xchg   %ax,%ax

801065e0 <sys_getpid>:

int sys_getpid(void)
{
801065e0:	55                   	push   %ebp
801065e1:	89 e5                	mov    %esp,%ebp
801065e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801065e6:	e8 05 d5 ff ff       	call   80103af0 <myproc>
801065eb:	8b 40 10             	mov    0x10(%eax),%eax
}
801065ee:	c9                   	leave  
801065ef:	c3                   	ret    

801065f0 <sys_sbrk>:

int sys_sbrk(void)
{
801065f0:	55                   	push   %ebp
801065f1:	89 e5                	mov    %esp,%ebp
801065f3:	53                   	push   %ebx
  int addr;
  int n;

  if (argint(0, &n) < 0)
801065f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801065f7:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
801065fa:	50                   	push   %eax
801065fb:	6a 00                	push   $0x0
801065fd:	e8 6e ef ff ff       	call   80105570 <argint>
80106602:	83 c4 10             	add    $0x10,%esp
80106605:	85 c0                	test   %eax,%eax
80106607:	78 27                	js     80106630 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106609:	e8 e2 d4 ff ff       	call   80103af0 <myproc>
  if (growproc(n) < 0)
8010660e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106611:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80106613:	ff 75 f4             	push   -0xc(%ebp)
80106616:	e8 75 db ff ff       	call   80104190 <growproc>
8010661b:	83 c4 10             	add    $0x10,%esp
8010661e:	85 c0                	test   %eax,%eax
80106620:	78 0e                	js     80106630 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106622:	89 d8                	mov    %ebx,%eax
80106624:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106627:	c9                   	leave  
80106628:	c3                   	ret    
80106629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106630:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106635:	eb eb                	jmp    80106622 <sys_sbrk+0x32>
80106637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010663e:	66 90                	xchg   %ax,%ax

80106640 <sys_sleep>:

int sys_sleep(void)
{
80106640:	55                   	push   %ebp
80106641:	89 e5                	mov    %esp,%ebp
80106643:	53                   	push   %ebx
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80106644:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106647:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
8010664a:	50                   	push   %eax
8010664b:	6a 00                	push   $0x0
8010664d:	e8 1e ef ff ff       	call   80105570 <argint>
80106652:	83 c4 10             	add    $0x10,%esp
80106655:	85 c0                	test   %eax,%eax
80106657:	0f 88 8a 00 00 00    	js     801066e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010665d:	83 ec 0c             	sub    $0xc,%esp
80106660:	68 00 68 11 80       	push   $0x80116800
80106665:	e8 46 eb ff ff       	call   801051b0 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
8010666a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010666d:	8b 1d e0 67 11 80    	mov    0x801167e0,%ebx
  while (ticks - ticks0 < n)
80106673:	83 c4 10             	add    $0x10,%esp
80106676:	85 d2                	test   %edx,%edx
80106678:	75 27                	jne    801066a1 <sys_sleep+0x61>
8010667a:	eb 54                	jmp    801066d0 <sys_sleep+0x90>
8010667c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106680:	83 ec 08             	sub    $0x8,%esp
80106683:	68 00 68 11 80       	push   $0x80116800
80106688:	68 e0 67 11 80       	push   $0x801167e0
8010668d:	e8 9e e3 ff ff       	call   80104a30 <sleep>
  while (ticks - ticks0 < n)
80106692:	a1 e0 67 11 80       	mov    0x801167e0,%eax
80106697:	83 c4 10             	add    $0x10,%esp
8010669a:	29 d8                	sub    %ebx,%eax
8010669c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010669f:	73 2f                	jae    801066d0 <sys_sleep+0x90>
    if (myproc()->killed)
801066a1:	e8 4a d4 ff ff       	call   80103af0 <myproc>
801066a6:	8b 40 30             	mov    0x30(%eax),%eax
801066a9:	85 c0                	test   %eax,%eax
801066ab:	74 d3                	je     80106680 <sys_sleep+0x40>
      release(&tickslock);
801066ad:	83 ec 0c             	sub    $0xc,%esp
801066b0:	68 00 68 11 80       	push   $0x80116800
801066b5:	e8 96 ea ff ff       	call   80105150 <release>
  }
  release(&tickslock);
  return 0;
}
801066ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801066bd:	83 c4 10             	add    $0x10,%esp
801066c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066c5:	c9                   	leave  
801066c6:	c3                   	ret    
801066c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ce:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801066d0:	83 ec 0c             	sub    $0xc,%esp
801066d3:	68 00 68 11 80       	push   $0x80116800
801066d8:	e8 73 ea ff ff       	call   80105150 <release>
  return 0;
801066dd:	83 c4 10             	add    $0x10,%esp
801066e0:	31 c0                	xor    %eax,%eax
}
801066e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066e5:	c9                   	leave  
801066e6:	c3                   	ret    
    return -1;
801066e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ec:	eb f4                	jmp    801066e2 <sys_sleep+0xa2>
801066ee:	66 90                	xchg   %ax,%ax

801066f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	53                   	push   %ebx
801066f4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801066f7:	68 00 68 11 80       	push   $0x80116800
801066fc:	e8 af ea ff ff       	call   801051b0 <acquire>
  xticks = ticks;
80106701:	8b 1d e0 67 11 80    	mov    0x801167e0,%ebx
  release(&tickslock);
80106707:	c7 04 24 00 68 11 80 	movl   $0x80116800,(%esp)
8010670e:	e8 3d ea ff ff       	call   80105150 <release>
  return xticks;
}
80106713:	89 d8                	mov    %ebx,%eax
80106715:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106718:	c9                   	leave  
80106719:	c3                   	ret    
8010671a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106720 <sys_find_digital_root>:

int sys_find_digital_root(void)
{
80106720:	55                   	push   %ebp
80106721:	89 e5                	mov    %esp,%ebp
80106723:	83 ec 08             	sub    $0x8,%esp
  int number = myproc()->tf->ebx; // register after eax
80106726:	e8 c5 d3 ff ff       	call   80103af0 <myproc>
  return find_digital_root(number);
8010672b:	83 ec 0c             	sub    $0xc,%esp
  int number = myproc()->tf->ebx; // register after eax
8010672e:	8b 40 18             	mov    0x18(%eax),%eax
  return find_digital_root(number);
80106731:	ff 70 10             	push   0x10(%eax)
80106734:	e8 57 e5 ff ff       	call   80104c90 <find_digital_root>
}
80106739:	c9                   	leave  
8010673a:	c3                   	ret    
8010673b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010673f:	90                   	nop

80106740 <sys_get_uncle_count>:

int sys_get_uncle_count(void)
{
80106740:	55                   	push   %ebp
80106741:	89 e5                	mov    %esp,%ebp
80106743:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80106746:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106749:	50                   	push   %eax
8010674a:	6a 00                	push   $0x0
8010674c:	e8 1f ee ff ff       	call   80105570 <argint>
80106751:	83 c4 10             	add    $0x10,%esp
80106754:	85 c0                	test   %eax,%eax
80106756:	78 28                	js     80106780 <sys_get_uncle_count+0x40>
  {
    return -1;
  }
  struct proc *grandFather = find_proc(pid)->parent->parent;
80106758:	83 ec 0c             	sub    $0xc,%esp
8010675b:	ff 75 f4             	push   -0xc(%ebp)
8010675e:	e8 5d d5 ff ff       	call   80103cc0 <find_proc>
  return count_child(grandFather) - 1;
80106763:	5a                   	pop    %edx
  struct proc *grandFather = find_proc(pid)->parent->parent;
80106764:	8b 40 14             	mov    0x14(%eax),%eax
  return count_child(grandFather) - 1;
80106767:	ff 70 14             	push   0x14(%eax)
8010676a:	e8 c1 d9 ff ff       	call   80104130 <count_child>
8010676f:	83 c4 10             	add    $0x10,%esp
}
80106772:	c9                   	leave  
  return count_child(grandFather) - 1;
80106773:	83 e8 01             	sub    $0x1,%eax
}
80106776:	c3                   	ret    
80106777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010677e:	66 90                	xchg   %ax,%ax
80106780:	c9                   	leave  
    return -1;
80106781:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106786:	c3                   	ret    
80106787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010678e:	66 90                	xchg   %ax,%ax

80106790 <sys_get_process_lifetime>:
int sys_get_process_lifetime(void)
{
80106790:	55                   	push   %ebp
80106791:	89 e5                	mov    %esp,%ebp
80106793:	53                   	push   %ebx
  int pid;
  if (argint(0, &pid) < 0)
80106794:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106797:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0)
8010679a:	50                   	push   %eax
8010679b:	6a 00                	push   $0x0
8010679d:	e8 ce ed ff ff       	call   80105570 <argint>
801067a2:	83 c4 10             	add    $0x10,%esp
801067a5:	85 c0                	test   %eax,%eax
801067a7:	78 27                	js     801067d0 <sys_get_process_lifetime+0x40>
  {
    return -1;
  }
  return ticks - (find_proc(pid)->creation_time);
801067a9:	83 ec 0c             	sub    $0xc,%esp
801067ac:	ff 75 f4             	push   -0xc(%ebp)
801067af:	8b 1d e0 67 11 80    	mov    0x801167e0,%ebx
801067b5:	e8 06 d5 ff ff       	call   80103cc0 <find_proc>
801067ba:	83 c4 10             	add    $0x10,%esp
801067bd:	2b 58 20             	sub    0x20(%eax),%ebx
801067c0:	89 d8                	mov    %ebx,%eax
}
801067c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801067c5:	c9                   	leave  
801067c6:	c3                   	ret    
801067c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067ce:	66 90                	xchg   %ax,%ax
    return -1;
801067d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067d5:	eb eb                	jmp    801067c2 <sys_get_process_lifetime+0x32>
801067d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067de:	66 90                	xchg   %ax,%ax

801067e0 <sys_set_date>:
void sys_set_date(void)
{
801067e0:	55                   	push   %ebp
801067e1:	89 e5                	mov    %esp,%ebp
801067e3:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *r;
  if (argptr(0, (void *)&r, sizeof(*r)) < 0)
801067e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067e9:	6a 18                	push   $0x18
801067eb:	50                   	push   %eax
801067ec:	6a 00                	push   $0x0
801067ee:	e8 1d ee ff ff       	call   80105610 <argptr>
801067f3:	83 c4 10             	add    $0x10,%esp
801067f6:	85 c0                	test   %eax,%eax
801067f8:	78 16                	js     80106810 <sys_set_date+0x30>
    cprintf("Kernel: sys_set_date() has a problem.\n");

  cmostime(r);
801067fa:	83 ec 0c             	sub    $0xc,%esp
801067fd:	ff 75 f4             	push   -0xc(%ebp)
80106800:	e8 cb c1 ff ff       	call   801029d0 <cmostime>
}
80106805:	83 c4 10             	add    $0x10,%esp
80106808:	c9                   	leave  
80106809:	c3                   	ret    
8010680a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("Kernel: sys_set_date() has a problem.\n");
80106810:	83 ec 0c             	sub    $0xc,%esp
80106813:	68 f0 8d 10 80       	push   $0x80108df0
80106818:	e8 83 9e ff ff       	call   801006a0 <cprintf>
8010681d:	83 c4 10             	add    $0x10,%esp
  cmostime(r);
80106820:	83 ec 0c             	sub    $0xc,%esp
80106823:	ff 75 f4             	push   -0xc(%ebp)
80106826:	e8 a5 c1 ff ff       	call   801029d0 <cmostime>
}
8010682b:	83 c4 10             	add    $0x10,%esp
8010682e:	c9                   	leave  
8010682f:	c3                   	ret    

80106830 <sys_get_pid>:
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	83 ec 08             	sub    $0x8,%esp
80106836:	e8 b5 d2 ff ff       	call   80103af0 <myproc>
8010683b:	8b 40 10             	mov    0x10(%eax),%eax
8010683e:	c9                   	leave  
8010683f:	c3                   	ret    

80106840 <sys_get_parent>:
int sys_get_pid(void)
{
  return myproc()->pid;
}
int sys_get_parent(void)
{
80106840:	55                   	push   %ebp
80106841:	89 e5                	mov    %esp,%ebp
80106843:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
80106846:	e8 a5 d2 ff ff       	call   80103af0 <myproc>
8010684b:	8b 40 14             	mov    0x14(%eax),%eax
8010684e:	8b 40 10             	mov    0x10(%eax),%eax
}
80106851:	c9                   	leave  
80106852:	c3                   	ret    
80106853:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010685a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106860 <sys_change_queue>:
int sys_change_queue(void)
{
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	53                   	push   %ebx
  int pid, que_id;
  if (argint(0, &pid) < 0 || argint(1, &que_id))
80106864:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
80106867:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0 || argint(1, &que_id))
8010686a:	50                   	push   %eax
8010686b:	6a 00                	push   $0x0
8010686d:	e8 fe ec ff ff       	call   80105570 <argint>
80106872:	83 c4 10             	add    $0x10,%esp
80106875:	85 c0                	test   %eax,%eax
80106877:	78 47                	js     801068c0 <sys_change_queue+0x60>
80106879:	83 ec 08             	sub    $0x8,%esp
8010687c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010687f:	50                   	push   %eax
80106880:	6a 01                	push   $0x1
80106882:	e8 e9 ec ff ff       	call   80105570 <argint>
80106887:	83 c4 10             	add    $0x10,%esp
8010688a:	89 c3                	mov    %eax,%ebx
8010688c:	85 c0                	test   %eax,%eax
8010688e:	75 30                	jne    801068c0 <sys_change_queue+0x60>
    return -1;
  cprintf("%d\n", que_id);
80106890:	83 ec 08             	sub    $0x8,%esp
80106893:	ff 75 f4             	push   -0xc(%ebp)
80106896:	68 14 8a 10 80       	push   $0x80108a14
8010689b:	e8 00 9e ff ff       	call   801006a0 <cprintf>
  struct proc *p = find_proc(pid);
801068a0:	58                   	pop    %eax
801068a1:	ff 75 f0             	push   -0x10(%ebp)
801068a4:	e8 17 d4 ff ff       	call   80103cc0 <find_proc>
  p->que_id = que_id;
801068a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  return 0;
801068ac:	83 c4 10             	add    $0x10,%esp
  p->que_id = que_id;
801068af:	89 50 28             	mov    %edx,0x28(%eax)
}
801068b2:	89 d8                	mov    %ebx,%eax
801068b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801068b7:	c9                   	leave  
801068b8:	c3                   	ret    
801068b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801068c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801068c5:	eb eb                	jmp    801068b2 <sys_change_queue+0x52>
801068c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068ce:	66 90                	xchg   %ax,%ax

801068d0 <sys_bjf_validation_process>:
int sys_bjf_validation_process(void)
{
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	83 ec 30             	sub    $0x30,%esp
  
  int pid;
  int priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argint(0, &pid) < 0 || argint(1, &priority_ratio) < 0 || argint(2, &creation_time_ratio) < 0 || argint(3, &exec_cycle_ratio) < 0 || argint(4, &size_ratio) < 0)
801068d6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801068d9:	50                   	push   %eax
801068da:	6a 00                	push   $0x0
801068dc:	e8 8f ec ff ff       	call   80105570 <argint>
801068e1:	83 c4 10             	add    $0x10,%esp
801068e4:	85 c0                	test   %eax,%eax
801068e6:	0f 88 94 00 00 00    	js     80106980 <sys_bjf_validation_process+0xb0>
801068ec:	83 ec 08             	sub    $0x8,%esp
801068ef:	8d 45 e8             	lea    -0x18(%ebp),%eax
801068f2:	50                   	push   %eax
801068f3:	6a 01                	push   $0x1
801068f5:	e8 76 ec ff ff       	call   80105570 <argint>
801068fa:	83 c4 10             	add    $0x10,%esp
801068fd:	85 c0                	test   %eax,%eax
801068ff:	78 7f                	js     80106980 <sys_bjf_validation_process+0xb0>
80106901:	83 ec 08             	sub    $0x8,%esp
80106904:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106907:	50                   	push   %eax
80106908:	6a 02                	push   $0x2
8010690a:	e8 61 ec ff ff       	call   80105570 <argint>
8010690f:	83 c4 10             	add    $0x10,%esp
80106912:	85 c0                	test   %eax,%eax
80106914:	78 6a                	js     80106980 <sys_bjf_validation_process+0xb0>
80106916:	83 ec 08             	sub    $0x8,%esp
80106919:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010691c:	50                   	push   %eax
8010691d:	6a 03                	push   $0x3
8010691f:	e8 4c ec ff ff       	call   80105570 <argint>
80106924:	83 c4 10             	add    $0x10,%esp
80106927:	85 c0                	test   %eax,%eax
80106929:	78 55                	js     80106980 <sys_bjf_validation_process+0xb0>
8010692b:	83 ec 08             	sub    $0x8,%esp
8010692e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106931:	50                   	push   %eax
80106932:	6a 04                	push   $0x4
80106934:	e8 37 ec ff ff       	call   80105570 <argint>
80106939:	83 c4 10             	add    $0x10,%esp
8010693c:	85 c0                	test   %eax,%eax
8010693e:	78 40                	js     80106980 <sys_bjf_validation_process+0xb0>
  {
    return -1;
  }
  struct proc *p = find_proc(pid);
80106940:	83 ec 0c             	sub    $0xc,%esp
80106943:	ff 75 e4             	push   -0x1c(%ebp)
80106946:	e8 75 d3 ff ff       	call   80103cc0 <find_proc>
  p->priority_ratio = (float)priority_ratio;
8010694b:	db 45 e8             	fildl  -0x18(%ebp)
  p->creation_time_ratio = (float)creation_time_ratio;
  p->executed_cycle_ratio = (float)exec_cycle_ratio;
  p->process_size_ratio = (float)size_ratio;

  return 0;
8010694e:	83 c4 10             	add    $0x10,%esp
  p->priority_ratio = (float)priority_ratio;
80106951:	d9 98 8c 00 00 00    	fstps  0x8c(%eax)
  p->creation_time_ratio = (float)creation_time_ratio;
80106957:	db 45 ec             	fildl  -0x14(%ebp)
8010695a:	d9 98 90 00 00 00    	fstps  0x90(%eax)
  p->executed_cycle_ratio = (float)exec_cycle_ratio;
80106960:	db 45 f0             	fildl  -0x10(%ebp)
80106963:	d9 98 98 00 00 00    	fstps  0x98(%eax)
  p->process_size_ratio = (float)size_ratio;
80106969:	db 45 f4             	fildl  -0xc(%ebp)
8010696c:	d9 98 9c 00 00 00    	fstps  0x9c(%eax)
  return 0;
80106972:	31 c0                	xor    %eax,%eax
}
80106974:	c9                   	leave  
80106975:	c3                   	ret    
80106976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010697d:	8d 76 00             	lea    0x0(%esi),%esi
80106980:	c9                   	leave  
    return -1;
80106981:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106986:	c3                   	ret    
80106987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010698e:	66 90                	xchg   %ax,%ax

80106990 <sys_bjf_validation_system>:
int sys_bjf_validation_system(void)
{
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
80106993:	83 ec 20             	sub    $0x20,%esp
  int priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argint(0, &priority_ratio) < 0 || argint(1, &creation_time_ratio) < 0 || argint(2, &exec_cycle_ratio) < 0 || argint(3, &size_ratio) < 0)
80106996:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106999:	50                   	push   %eax
8010699a:	6a 00                	push   $0x0
8010699c:	e8 cf eb ff ff       	call   80105570 <argint>
801069a1:	83 c4 10             	add    $0x10,%esp
801069a4:	85 c0                	test   %eax,%eax
801069a6:	78 70                	js     80106a18 <sys_bjf_validation_system+0x88>
801069a8:	83 ec 08             	sub    $0x8,%esp
801069ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
801069ae:	50                   	push   %eax
801069af:	6a 01                	push   $0x1
801069b1:	e8 ba eb ff ff       	call   80105570 <argint>
801069b6:	83 c4 10             	add    $0x10,%esp
801069b9:	85 c0                	test   %eax,%eax
801069bb:	78 5b                	js     80106a18 <sys_bjf_validation_system+0x88>
801069bd:	83 ec 08             	sub    $0x8,%esp
801069c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069c3:	50                   	push   %eax
801069c4:	6a 02                	push   $0x2
801069c6:	e8 a5 eb ff ff       	call   80105570 <argint>
801069cb:	83 c4 10             	add    $0x10,%esp
801069ce:	85 c0                	test   %eax,%eax
801069d0:	78 46                	js     80106a18 <sys_bjf_validation_system+0x88>
801069d2:	83 ec 08             	sub    $0x8,%esp
801069d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069d8:	50                   	push   %eax
801069d9:	6a 03                	push   $0x3
801069db:	e8 90 eb ff ff       	call   80105570 <argint>
801069e0:	83 c4 10             	add    $0x10,%esp
801069e3:	85 c0                	test   %eax,%eax
801069e5:	78 31                	js     80106a18 <sys_bjf_validation_system+0x88>
  {
    return -1;
  }
  reset_bjf_attributes((float)priority_ratio, (float)creation_time_ratio,(float) exec_cycle_ratio,(float) size_ratio);
801069e7:	db 45 f4             	fildl  -0xc(%ebp)
801069ea:	83 ec 10             	sub    $0x10,%esp
801069ed:	d9 5c 24 0c          	fstps  0xc(%esp)
801069f1:	db 45 f0             	fildl  -0x10(%ebp)
801069f4:	d9 5c 24 08          	fstps  0x8(%esp)
801069f8:	db 45 ec             	fildl  -0x14(%ebp)
801069fb:	d9 5c 24 04          	fstps  0x4(%esp)
801069ff:	db 45 e8             	fildl  -0x18(%ebp)
80106a02:	d9 1c 24             	fstps  (%esp)
80106a05:	e8 56 d0 ff ff       	call   80103a60 <reset_bjf_attributes>
  return 0;
80106a0a:	83 c4 10             	add    $0x10,%esp
80106a0d:	31 c0                	xor    %eax,%eax
}
80106a0f:	c9                   	leave  
80106a10:	c3                   	ret    
80106a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a18:	c9                   	leave  
    return -1;
80106a19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a1e:	c3                   	ret    
80106a1f:	90                   	nop

80106a20 <sys_print_info>:
int sys_print_info(void)
{
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	83 ec 08             	sub    $0x8,%esp
  print_bitches();
80106a26:	e8 a5 d3 ff ff       	call   80103dd0 <print_bitches>
  return 0;
}
80106a2b:	31 c0                	xor    %eax,%eax
80106a2d:	c9                   	leave  
80106a2e:	c3                   	ret    
80106a2f:	90                   	nop

80106a30 <sys_open_sharedmem>:

int sys_open_sharedmem(void)
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	83 ec 20             	sub    $0x20,%esp
  int id;
  argint(0, &id);
80106a36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a39:	50                   	push   %eax
80106a3a:	6a 00                	push   $0x0
80106a3c:	e8 2f eb ff ff       	call   80105570 <argint>
  return open_sharedmem(id);
80106a41:	58                   	pop    %eax
80106a42:	ff 75 f4             	push   -0xc(%ebp)
80106a45:	e8 e6 e2 ff ff       	call   80104d30 <open_sharedmem>
  
}
80106a4a:	c9                   	leave  
80106a4b:	c3                   	ret    
80106a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a50 <sys_close_sharedmem>:


void sys_close_sharedmem(void)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	83 ec 20             	sub    $0x20,%esp
  int id;
  argint(0, &id);
80106a56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a59:	50                   	push   %eax
80106a5a:	6a 00                	push   $0x0
80106a5c:	e8 0f eb ff ff       	call   80105570 <argint>
  return close_sharedmem(id);
80106a61:	58                   	pop    %eax
80106a62:	ff 75 f4             	push   -0xc(%ebp)
80106a65:	e8 d6 e3 ff ff       	call   80104e40 <close_sharedmem>
80106a6a:	83 c4 10             	add    $0x10,%esp
80106a6d:	c9                   	leave  
80106a6e:	c3                   	ret    

80106a6f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106a6f:	1e                   	push   %ds
  pushl %es
80106a70:	06                   	push   %es
  pushl %fs
80106a71:	0f a0                	push   %fs
  pushl %gs
80106a73:	0f a8                	push   %gs
  pushal
80106a75:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106a76:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106a7a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106a7c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106a7e:	54                   	push   %esp
  call trap
80106a7f:	e8 cc 00 00 00       	call   80106b50 <trap>
  addl $4, %esp
80106a84:	83 c4 04             	add    $0x4,%esp

80106a87 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106a87:	61                   	popa   
  popl %gs
80106a88:	0f a9                	pop    %gs
  popl %fs
80106a8a:	0f a1                	pop    %fs
  popl %es
80106a8c:	07                   	pop    %es
  popl %ds
80106a8d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106a8e:	83 c4 08             	add    $0x8,%esp
  iret
80106a91:	cf                   	iret   
80106a92:	66 90                	xchg   %ax,%ax
80106a94:	66 90                	xchg   %ax,%ax
80106a96:	66 90                	xchg   %ax,%ax
80106a98:	66 90                	xchg   %ax,%ax
80106a9a:	66 90                	xchg   %ax,%ax
80106a9c:	66 90                	xchg   %ax,%ax
80106a9e:	66 90                	xchg   %ax,%ax

80106aa0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106aa0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106aa1:	31 c0                	xor    %eax,%eax
{
80106aa3:	89 e5                	mov    %esp,%ebp
80106aa5:	83 ec 08             	sub    $0x8,%esp
80106aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106aaf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106ab0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106ab7:	c7 04 c5 42 68 11 80 	movl   $0x8e000008,-0x7fee97be(,%eax,8)
80106abe:	08 00 00 8e 
80106ac2:	66 89 14 c5 40 68 11 	mov    %dx,-0x7fee97c0(,%eax,8)
80106ac9:	80 
80106aca:	c1 ea 10             	shr    $0x10,%edx
80106acd:	66 89 14 c5 46 68 11 	mov    %dx,-0x7fee97ba(,%eax,8)
80106ad4:	80 
  for(i = 0; i < 256; i++)
80106ad5:	83 c0 01             	add    $0x1,%eax
80106ad8:	3d 00 01 00 00       	cmp    $0x100,%eax
80106add:	75 d1                	jne    80106ab0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80106adf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106ae2:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80106ae7:	c7 05 42 6a 11 80 08 	movl   $0xef000008,0x80116a42
80106aee:	00 00 ef 
  initlock(&tickslock, "time");
80106af1:	68 17 8e 10 80       	push   $0x80108e17
80106af6:	68 00 68 11 80       	push   $0x80116800
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106afb:	66 a3 40 6a 11 80    	mov    %ax,0x80116a40
80106b01:	c1 e8 10             	shr    $0x10,%eax
80106b04:	66 a3 46 6a 11 80    	mov    %ax,0x80116a46
  initlock(&tickslock, "time");
80106b0a:	e8 d1 e4 ff ff       	call   80104fe0 <initlock>
}
80106b0f:	83 c4 10             	add    $0x10,%esp
80106b12:	c9                   	leave  
80106b13:	c3                   	ret    
80106b14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b1f:	90                   	nop

80106b20 <idtinit>:

void
idtinit(void)
{
80106b20:	55                   	push   %ebp
  pd[0] = size-1;
80106b21:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106b26:	89 e5                	mov    %esp,%ebp
80106b28:	83 ec 10             	sub    $0x10,%esp
80106b2b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106b2f:	b8 40 68 11 80       	mov    $0x80116840,%eax
80106b34:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106b38:	c1 e8 10             	shr    $0x10,%eax
80106b3b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106b3f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106b42:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106b45:	c9                   	leave  
80106b46:	c3                   	ret    
80106b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b4e:	66 90                	xchg   %ax,%ax

80106b50 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	57                   	push   %edi
80106b54:	56                   	push   %esi
80106b55:	53                   	push   %ebx
80106b56:	83 ec 1c             	sub    $0x1c,%esp
80106b59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106b5c:	8b 43 30             	mov    0x30(%ebx),%eax
80106b5f:	83 f8 40             	cmp    $0x40,%eax
80106b62:	0f 84 68 01 00 00    	je     80106cd0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106b68:	83 e8 20             	sub    $0x20,%eax
80106b6b:	83 f8 1f             	cmp    $0x1f,%eax
80106b6e:	0f 87 8c 00 00 00    	ja     80106c00 <trap+0xb0>
80106b74:	ff 24 85 c0 8e 10 80 	jmp    *-0x7fef7140(,%eax,4)
80106b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b7f:	90                   	nop
      aging();
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106b80:	e8 bb b6 ff ff       	call   80102240 <ideintr>
    lapiceoi();
80106b85:	e8 86 bd ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b8a:	e8 61 cf ff ff       	call   80103af0 <myproc>
80106b8f:	85 c0                	test   %eax,%eax
80106b91:	74 1d                	je     80106bb0 <trap+0x60>
80106b93:	e8 58 cf ff ff       	call   80103af0 <myproc>
80106b98:	8b 50 30             	mov    0x30(%eax),%edx
80106b9b:	85 d2                	test   %edx,%edx
80106b9d:	74 11                	je     80106bb0 <trap+0x60>
80106b9f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106ba3:	83 e0 03             	and    $0x3,%eax
80106ba6:	66 83 f8 03          	cmp    $0x3,%ax
80106baa:	0f 84 f0 01 00 00    	je     80106da0 <trap+0x250>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106bb0:	e8 3b cf ff ff       	call   80103af0 <myproc>
80106bb5:	85 c0                	test   %eax,%eax
80106bb7:	74 0f                	je     80106bc8 <trap+0x78>
80106bb9:	e8 32 cf ff ff       	call   80103af0 <myproc>
80106bbe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106bc2:	0f 84 b8 00 00 00    	je     80106c80 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106bc8:	e8 23 cf ff ff       	call   80103af0 <myproc>
80106bcd:	85 c0                	test   %eax,%eax
80106bcf:	74 1d                	je     80106bee <trap+0x9e>
80106bd1:	e8 1a cf ff ff       	call   80103af0 <myproc>
80106bd6:	8b 40 30             	mov    0x30(%eax),%eax
80106bd9:	85 c0                	test   %eax,%eax
80106bdb:	74 11                	je     80106bee <trap+0x9e>
80106bdd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106be1:	83 e0 03             	and    $0x3,%eax
80106be4:	66 83 f8 03          	cmp    $0x3,%ax
80106be8:	0f 84 0f 01 00 00    	je     80106cfd <trap+0x1ad>
    exit();
}
80106bee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bf1:	5b                   	pop    %ebx
80106bf2:	5e                   	pop    %esi
80106bf3:	5f                   	pop    %edi
80106bf4:	5d                   	pop    %ebp
80106bf5:	c3                   	ret    
80106bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bfd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106c00:	e8 eb ce ff ff       	call   80103af0 <myproc>
80106c05:	8b 7b 38             	mov    0x38(%ebx),%edi
80106c08:	85 c0                	test   %eax,%eax
80106c0a:	0f 84 aa 01 00 00    	je     80106dba <trap+0x26a>
80106c10:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106c14:	0f 84 a0 01 00 00    	je     80106dba <trap+0x26a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106c1a:	0f 20 d1             	mov    %cr2,%ecx
80106c1d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c20:	e8 cb cd ff ff       	call   801039f0 <cpuid>
80106c25:	8b 73 30             	mov    0x30(%ebx),%esi
80106c28:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c2b:	8b 43 34             	mov    0x34(%ebx),%eax
80106c2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106c31:	e8 ba ce ff ff       	call   80103af0 <myproc>
80106c36:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c39:	e8 b2 ce ff ff       	call   80103af0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c3e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106c41:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106c44:	51                   	push   %ecx
80106c45:	57                   	push   %edi
80106c46:	52                   	push   %edx
80106c47:	ff 75 e4             	push   -0x1c(%ebp)
80106c4a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106c4b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106c4e:	83 c6 78             	add    $0x78,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c51:	56                   	push   %esi
80106c52:	ff 70 10             	push   0x10(%eax)
80106c55:	68 7c 8e 10 80       	push   $0x80108e7c
80106c5a:	e8 41 9a ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80106c5f:	83 c4 20             	add    $0x20,%esp
80106c62:	e8 89 ce ff ff       	call   80103af0 <myproc>
80106c67:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c6e:	e8 7d ce ff ff       	call   80103af0 <myproc>
80106c73:	85 c0                	test   %eax,%eax
80106c75:	0f 85 18 ff ff ff    	jne    80106b93 <trap+0x43>
80106c7b:	e9 30 ff ff ff       	jmp    80106bb0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106c80:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106c84:	0f 85 3e ff ff ff    	jne    80106bc8 <trap+0x78>
    yield();
80106c8a:	e8 11 dd ff ff       	call   801049a0 <yield>
80106c8f:	e9 34 ff ff ff       	jmp    80106bc8 <trap+0x78>
80106c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106c98:	8b 7b 38             	mov    0x38(%ebx),%edi
80106c9b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106c9f:	e8 4c cd ff ff       	call   801039f0 <cpuid>
80106ca4:	57                   	push   %edi
80106ca5:	56                   	push   %esi
80106ca6:	50                   	push   %eax
80106ca7:	68 24 8e 10 80       	push   $0x80108e24
80106cac:	e8 ef 99 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106cb1:	e8 5a bc ff ff       	call   80102910 <lapiceoi>
    break;
80106cb6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106cb9:	e8 32 ce ff ff       	call   80103af0 <myproc>
80106cbe:	85 c0                	test   %eax,%eax
80106cc0:	0f 85 cd fe ff ff    	jne    80106b93 <trap+0x43>
80106cc6:	e9 e5 fe ff ff       	jmp    80106bb0 <trap+0x60>
80106ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ccf:	90                   	nop
    if(myproc()->killed)
80106cd0:	e8 1b ce ff ff       	call   80103af0 <myproc>
80106cd5:	8b 70 30             	mov    0x30(%eax),%esi
80106cd8:	85 f6                	test   %esi,%esi
80106cda:	0f 85 d0 00 00 00    	jne    80106db0 <trap+0x260>
    myproc()->tf = tf;
80106ce0:	e8 0b ce ff ff       	call   80103af0 <myproc>
80106ce5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106ce8:	e8 13 ea ff ff       	call   80105700 <syscall>
    if(myproc()->killed)
80106ced:	e8 fe cd ff ff       	call   80103af0 <myproc>
80106cf2:	8b 48 30             	mov    0x30(%eax),%ecx
80106cf5:	85 c9                	test   %ecx,%ecx
80106cf7:	0f 84 f1 fe ff ff    	je     80106bee <trap+0x9e>
}
80106cfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d00:	5b                   	pop    %ebx
80106d01:	5e                   	pop    %esi
80106d02:	5f                   	pop    %edi
80106d03:	5d                   	pop    %ebp
      exit();
80106d04:	e9 37 da ff ff       	jmp    80104740 <exit>
80106d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106d10:	e8 4b 02 00 00       	call   80106f60 <uartintr>
    lapiceoi();
80106d15:	e8 f6 bb ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d1a:	e8 d1 cd ff ff       	call   80103af0 <myproc>
80106d1f:	85 c0                	test   %eax,%eax
80106d21:	0f 85 6c fe ff ff    	jne    80106b93 <trap+0x43>
80106d27:	e9 84 fe ff ff       	jmp    80106bb0 <trap+0x60>
80106d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106d30:	e8 9b ba ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80106d35:	e8 d6 bb ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d3a:	e8 b1 cd ff ff       	call   80103af0 <myproc>
80106d3f:	85 c0                	test   %eax,%eax
80106d41:	0f 85 4c fe ff ff    	jne    80106b93 <trap+0x43>
80106d47:	e9 64 fe ff ff       	jmp    80106bb0 <trap+0x60>
80106d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106d50:	e8 9b cc ff ff       	call   801039f0 <cpuid>
80106d55:	85 c0                	test   %eax,%eax
80106d57:	0f 85 28 fe ff ff    	jne    80106b85 <trap+0x35>
      acquire(&tickslock);
80106d5d:	83 ec 0c             	sub    $0xc,%esp
80106d60:	68 00 68 11 80       	push   $0x80116800
80106d65:	e8 46 e4 ff ff       	call   801051b0 <acquire>
      wakeup(&ticks);
80106d6a:	c7 04 24 e0 67 11 80 	movl   $0x801167e0,(%esp)
      ticks++;
80106d71:	83 05 e0 67 11 80 01 	addl   $0x1,0x801167e0
      wakeup(&ticks);
80106d78:	e8 73 dd ff ff       	call   80104af0 <wakeup>
      release(&tickslock);
80106d7d:	c7 04 24 00 68 11 80 	movl   $0x80116800,(%esp)
80106d84:	e8 c7 e3 ff ff       	call   80105150 <release>
      aging();
80106d89:	e8 82 cc ff ff       	call   80103a10 <aging>
80106d8e:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106d91:	e9 ef fd ff ff       	jmp    80106b85 <trap+0x35>
80106d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d9d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106da0:	e8 9b d9 ff ff       	call   80104740 <exit>
80106da5:	e9 06 fe ff ff       	jmp    80106bb0 <trap+0x60>
80106daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106db0:	e8 8b d9 ff ff       	call   80104740 <exit>
80106db5:	e9 26 ff ff ff       	jmp    80106ce0 <trap+0x190>
80106dba:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106dbd:	e8 2e cc ff ff       	call   801039f0 <cpuid>
80106dc2:	83 ec 0c             	sub    $0xc,%esp
80106dc5:	56                   	push   %esi
80106dc6:	57                   	push   %edi
80106dc7:	50                   	push   %eax
80106dc8:	ff 73 30             	push   0x30(%ebx)
80106dcb:	68 48 8e 10 80       	push   $0x80108e48
80106dd0:	e8 cb 98 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80106dd5:	83 c4 14             	add    $0x14,%esp
80106dd8:	68 1c 8e 10 80       	push   $0x80108e1c
80106ddd:	e8 9e 95 ff ff       	call   80100380 <panic>
80106de2:	66 90                	xchg   %ax,%ax
80106de4:	66 90                	xchg   %ax,%ax
80106de6:	66 90                	xchg   %ax,%ax
80106de8:	66 90                	xchg   %ax,%ax
80106dea:	66 90                	xchg   %ax,%ax
80106dec:	66 90                	xchg   %ax,%ax
80106dee:	66 90                	xchg   %ax,%ax

80106df0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106df0:	a1 40 70 11 80       	mov    0x80117040,%eax
80106df5:	85 c0                	test   %eax,%eax
80106df7:	74 17                	je     80106e10 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106df9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106dfe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106dff:	a8 01                	test   $0x1,%al
80106e01:	74 0d                	je     80106e10 <uartgetc+0x20>
80106e03:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106e08:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106e09:	0f b6 c0             	movzbl %al,%eax
80106e0c:	c3                   	ret    
80106e0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e15:	c3                   	ret    
80106e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e1d:	8d 76 00             	lea    0x0(%esi),%esi

80106e20 <uartinit>:
{
80106e20:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106e21:	31 c9                	xor    %ecx,%ecx
80106e23:	89 c8                	mov    %ecx,%eax
80106e25:	89 e5                	mov    %esp,%ebp
80106e27:	57                   	push   %edi
80106e28:	bf fa 03 00 00       	mov    $0x3fa,%edi
80106e2d:	56                   	push   %esi
80106e2e:	89 fa                	mov    %edi,%edx
80106e30:	53                   	push   %ebx
80106e31:	83 ec 1c             	sub    $0x1c,%esp
80106e34:	ee                   	out    %al,(%dx)
80106e35:	be fb 03 00 00       	mov    $0x3fb,%esi
80106e3a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106e3f:	89 f2                	mov    %esi,%edx
80106e41:	ee                   	out    %al,(%dx)
80106e42:	b8 0c 00 00 00       	mov    $0xc,%eax
80106e47:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106e4c:	ee                   	out    %al,(%dx)
80106e4d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106e52:	89 c8                	mov    %ecx,%eax
80106e54:	89 da                	mov    %ebx,%edx
80106e56:	ee                   	out    %al,(%dx)
80106e57:	b8 03 00 00 00       	mov    $0x3,%eax
80106e5c:	89 f2                	mov    %esi,%edx
80106e5e:	ee                   	out    %al,(%dx)
80106e5f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106e64:	89 c8                	mov    %ecx,%eax
80106e66:	ee                   	out    %al,(%dx)
80106e67:	b8 01 00 00 00       	mov    $0x1,%eax
80106e6c:	89 da                	mov    %ebx,%edx
80106e6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106e6f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106e74:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106e75:	3c ff                	cmp    $0xff,%al
80106e77:	74 78                	je     80106ef1 <uartinit+0xd1>
  uart = 1;
80106e79:	c7 05 40 70 11 80 01 	movl   $0x1,0x80117040
80106e80:	00 00 00 
80106e83:	89 fa                	mov    %edi,%edx
80106e85:	ec                   	in     (%dx),%al
80106e86:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106e8b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106e8c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106e8f:	bf 40 8f 10 80       	mov    $0x80108f40,%edi
80106e94:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106e99:	6a 00                	push   $0x0
80106e9b:	6a 04                	push   $0x4
80106e9d:	e8 de b5 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106ea2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106ea6:	83 c4 10             	add    $0x10,%esp
80106ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106eb0:	a1 40 70 11 80       	mov    0x80117040,%eax
80106eb5:	bb 80 00 00 00       	mov    $0x80,%ebx
80106eba:	85 c0                	test   %eax,%eax
80106ebc:	75 14                	jne    80106ed2 <uartinit+0xb2>
80106ebe:	eb 23                	jmp    80106ee3 <uartinit+0xc3>
    microdelay(10);
80106ec0:	83 ec 0c             	sub    $0xc,%esp
80106ec3:	6a 0a                	push   $0xa
80106ec5:	e8 66 ba ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106eca:	83 c4 10             	add    $0x10,%esp
80106ecd:	83 eb 01             	sub    $0x1,%ebx
80106ed0:	74 07                	je     80106ed9 <uartinit+0xb9>
80106ed2:	89 f2                	mov    %esi,%edx
80106ed4:	ec                   	in     (%dx),%al
80106ed5:	a8 20                	test   $0x20,%al
80106ed7:	74 e7                	je     80106ec0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106ed9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106edd:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106ee2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106ee3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106ee7:	83 c7 01             	add    $0x1,%edi
80106eea:	88 45 e7             	mov    %al,-0x19(%ebp)
80106eed:	84 c0                	test   %al,%al
80106eef:	75 bf                	jne    80106eb0 <uartinit+0x90>
}
80106ef1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ef4:	5b                   	pop    %ebx
80106ef5:	5e                   	pop    %esi
80106ef6:	5f                   	pop    %edi
80106ef7:	5d                   	pop    %ebp
80106ef8:	c3                   	ret    
80106ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f00 <uartputc>:
  if(!uart)
80106f00:	a1 40 70 11 80       	mov    0x80117040,%eax
80106f05:	85 c0                	test   %eax,%eax
80106f07:	74 47                	je     80106f50 <uartputc+0x50>
{
80106f09:	55                   	push   %ebp
80106f0a:	89 e5                	mov    %esp,%ebp
80106f0c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106f0d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106f12:	53                   	push   %ebx
80106f13:	bb 80 00 00 00       	mov    $0x80,%ebx
80106f18:	eb 18                	jmp    80106f32 <uartputc+0x32>
80106f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106f20:	83 ec 0c             	sub    $0xc,%esp
80106f23:	6a 0a                	push   $0xa
80106f25:	e8 06 ba ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106f2a:	83 c4 10             	add    $0x10,%esp
80106f2d:	83 eb 01             	sub    $0x1,%ebx
80106f30:	74 07                	je     80106f39 <uartputc+0x39>
80106f32:	89 f2                	mov    %esi,%edx
80106f34:	ec                   	in     (%dx),%al
80106f35:	a8 20                	test   $0x20,%al
80106f37:	74 e7                	je     80106f20 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106f39:	8b 45 08             	mov    0x8(%ebp),%eax
80106f3c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106f41:	ee                   	out    %al,(%dx)
}
80106f42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f45:	5b                   	pop    %ebx
80106f46:	5e                   	pop    %esi
80106f47:	5d                   	pop    %ebp
80106f48:	c3                   	ret    
80106f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f50:	c3                   	ret    
80106f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f5f:	90                   	nop

80106f60 <uartintr>:

void
uartintr(void)
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106f66:	68 f0 6d 10 80       	push   $0x80106df0
80106f6b:	e8 10 99 ff ff       	call   80100880 <consoleintr>
}
80106f70:	83 c4 10             	add    $0x10,%esp
80106f73:	c9                   	leave  
80106f74:	c3                   	ret    

80106f75 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106f75:	6a 00                	push   $0x0
  pushl $0
80106f77:	6a 00                	push   $0x0
  jmp alltraps
80106f79:	e9 f1 fa ff ff       	jmp    80106a6f <alltraps>

80106f7e <vector1>:
.globl vector1
vector1:
  pushl $0
80106f7e:	6a 00                	push   $0x0
  pushl $1
80106f80:	6a 01                	push   $0x1
  jmp alltraps
80106f82:	e9 e8 fa ff ff       	jmp    80106a6f <alltraps>

80106f87 <vector2>:
.globl vector2
vector2:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $2
80106f89:	6a 02                	push   $0x2
  jmp alltraps
80106f8b:	e9 df fa ff ff       	jmp    80106a6f <alltraps>

80106f90 <vector3>:
.globl vector3
vector3:
  pushl $0
80106f90:	6a 00                	push   $0x0
  pushl $3
80106f92:	6a 03                	push   $0x3
  jmp alltraps
80106f94:	e9 d6 fa ff ff       	jmp    80106a6f <alltraps>

80106f99 <vector4>:
.globl vector4
vector4:
  pushl $0
80106f99:	6a 00                	push   $0x0
  pushl $4
80106f9b:	6a 04                	push   $0x4
  jmp alltraps
80106f9d:	e9 cd fa ff ff       	jmp    80106a6f <alltraps>

80106fa2 <vector5>:
.globl vector5
vector5:
  pushl $0
80106fa2:	6a 00                	push   $0x0
  pushl $5
80106fa4:	6a 05                	push   $0x5
  jmp alltraps
80106fa6:	e9 c4 fa ff ff       	jmp    80106a6f <alltraps>

80106fab <vector6>:
.globl vector6
vector6:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $6
80106fad:	6a 06                	push   $0x6
  jmp alltraps
80106faf:	e9 bb fa ff ff       	jmp    80106a6f <alltraps>

80106fb4 <vector7>:
.globl vector7
vector7:
  pushl $0
80106fb4:	6a 00                	push   $0x0
  pushl $7
80106fb6:	6a 07                	push   $0x7
  jmp alltraps
80106fb8:	e9 b2 fa ff ff       	jmp    80106a6f <alltraps>

80106fbd <vector8>:
.globl vector8
vector8:
  pushl $8
80106fbd:	6a 08                	push   $0x8
  jmp alltraps
80106fbf:	e9 ab fa ff ff       	jmp    80106a6f <alltraps>

80106fc4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106fc4:	6a 00                	push   $0x0
  pushl $9
80106fc6:	6a 09                	push   $0x9
  jmp alltraps
80106fc8:	e9 a2 fa ff ff       	jmp    80106a6f <alltraps>

80106fcd <vector10>:
.globl vector10
vector10:
  pushl $10
80106fcd:	6a 0a                	push   $0xa
  jmp alltraps
80106fcf:	e9 9b fa ff ff       	jmp    80106a6f <alltraps>

80106fd4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106fd4:	6a 0b                	push   $0xb
  jmp alltraps
80106fd6:	e9 94 fa ff ff       	jmp    80106a6f <alltraps>

80106fdb <vector12>:
.globl vector12
vector12:
  pushl $12
80106fdb:	6a 0c                	push   $0xc
  jmp alltraps
80106fdd:	e9 8d fa ff ff       	jmp    80106a6f <alltraps>

80106fe2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106fe2:	6a 0d                	push   $0xd
  jmp alltraps
80106fe4:	e9 86 fa ff ff       	jmp    80106a6f <alltraps>

80106fe9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106fe9:	6a 0e                	push   $0xe
  jmp alltraps
80106feb:	e9 7f fa ff ff       	jmp    80106a6f <alltraps>

80106ff0 <vector15>:
.globl vector15
vector15:
  pushl $0
80106ff0:	6a 00                	push   $0x0
  pushl $15
80106ff2:	6a 0f                	push   $0xf
  jmp alltraps
80106ff4:	e9 76 fa ff ff       	jmp    80106a6f <alltraps>

80106ff9 <vector16>:
.globl vector16
vector16:
  pushl $0
80106ff9:	6a 00                	push   $0x0
  pushl $16
80106ffb:	6a 10                	push   $0x10
  jmp alltraps
80106ffd:	e9 6d fa ff ff       	jmp    80106a6f <alltraps>

80107002 <vector17>:
.globl vector17
vector17:
  pushl $17
80107002:	6a 11                	push   $0x11
  jmp alltraps
80107004:	e9 66 fa ff ff       	jmp    80106a6f <alltraps>

80107009 <vector18>:
.globl vector18
vector18:
  pushl $0
80107009:	6a 00                	push   $0x0
  pushl $18
8010700b:	6a 12                	push   $0x12
  jmp alltraps
8010700d:	e9 5d fa ff ff       	jmp    80106a6f <alltraps>

80107012 <vector19>:
.globl vector19
vector19:
  pushl $0
80107012:	6a 00                	push   $0x0
  pushl $19
80107014:	6a 13                	push   $0x13
  jmp alltraps
80107016:	e9 54 fa ff ff       	jmp    80106a6f <alltraps>

8010701b <vector20>:
.globl vector20
vector20:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $20
8010701d:	6a 14                	push   $0x14
  jmp alltraps
8010701f:	e9 4b fa ff ff       	jmp    80106a6f <alltraps>

80107024 <vector21>:
.globl vector21
vector21:
  pushl $0
80107024:	6a 00                	push   $0x0
  pushl $21
80107026:	6a 15                	push   $0x15
  jmp alltraps
80107028:	e9 42 fa ff ff       	jmp    80106a6f <alltraps>

8010702d <vector22>:
.globl vector22
vector22:
  pushl $0
8010702d:	6a 00                	push   $0x0
  pushl $22
8010702f:	6a 16                	push   $0x16
  jmp alltraps
80107031:	e9 39 fa ff ff       	jmp    80106a6f <alltraps>

80107036 <vector23>:
.globl vector23
vector23:
  pushl $0
80107036:	6a 00                	push   $0x0
  pushl $23
80107038:	6a 17                	push   $0x17
  jmp alltraps
8010703a:	e9 30 fa ff ff       	jmp    80106a6f <alltraps>

8010703f <vector24>:
.globl vector24
vector24:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $24
80107041:	6a 18                	push   $0x18
  jmp alltraps
80107043:	e9 27 fa ff ff       	jmp    80106a6f <alltraps>

80107048 <vector25>:
.globl vector25
vector25:
  pushl $0
80107048:	6a 00                	push   $0x0
  pushl $25
8010704a:	6a 19                	push   $0x19
  jmp alltraps
8010704c:	e9 1e fa ff ff       	jmp    80106a6f <alltraps>

80107051 <vector26>:
.globl vector26
vector26:
  pushl $0
80107051:	6a 00                	push   $0x0
  pushl $26
80107053:	6a 1a                	push   $0x1a
  jmp alltraps
80107055:	e9 15 fa ff ff       	jmp    80106a6f <alltraps>

8010705a <vector27>:
.globl vector27
vector27:
  pushl $0
8010705a:	6a 00                	push   $0x0
  pushl $27
8010705c:	6a 1b                	push   $0x1b
  jmp alltraps
8010705e:	e9 0c fa ff ff       	jmp    80106a6f <alltraps>

80107063 <vector28>:
.globl vector28
vector28:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $28
80107065:	6a 1c                	push   $0x1c
  jmp alltraps
80107067:	e9 03 fa ff ff       	jmp    80106a6f <alltraps>

8010706c <vector29>:
.globl vector29
vector29:
  pushl $0
8010706c:	6a 00                	push   $0x0
  pushl $29
8010706e:	6a 1d                	push   $0x1d
  jmp alltraps
80107070:	e9 fa f9 ff ff       	jmp    80106a6f <alltraps>

80107075 <vector30>:
.globl vector30
vector30:
  pushl $0
80107075:	6a 00                	push   $0x0
  pushl $30
80107077:	6a 1e                	push   $0x1e
  jmp alltraps
80107079:	e9 f1 f9 ff ff       	jmp    80106a6f <alltraps>

8010707e <vector31>:
.globl vector31
vector31:
  pushl $0
8010707e:	6a 00                	push   $0x0
  pushl $31
80107080:	6a 1f                	push   $0x1f
  jmp alltraps
80107082:	e9 e8 f9 ff ff       	jmp    80106a6f <alltraps>

80107087 <vector32>:
.globl vector32
vector32:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $32
80107089:	6a 20                	push   $0x20
  jmp alltraps
8010708b:	e9 df f9 ff ff       	jmp    80106a6f <alltraps>

80107090 <vector33>:
.globl vector33
vector33:
  pushl $0
80107090:	6a 00                	push   $0x0
  pushl $33
80107092:	6a 21                	push   $0x21
  jmp alltraps
80107094:	e9 d6 f9 ff ff       	jmp    80106a6f <alltraps>

80107099 <vector34>:
.globl vector34
vector34:
  pushl $0
80107099:	6a 00                	push   $0x0
  pushl $34
8010709b:	6a 22                	push   $0x22
  jmp alltraps
8010709d:	e9 cd f9 ff ff       	jmp    80106a6f <alltraps>

801070a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801070a2:	6a 00                	push   $0x0
  pushl $35
801070a4:	6a 23                	push   $0x23
  jmp alltraps
801070a6:	e9 c4 f9 ff ff       	jmp    80106a6f <alltraps>

801070ab <vector36>:
.globl vector36
vector36:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $36
801070ad:	6a 24                	push   $0x24
  jmp alltraps
801070af:	e9 bb f9 ff ff       	jmp    80106a6f <alltraps>

801070b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801070b4:	6a 00                	push   $0x0
  pushl $37
801070b6:	6a 25                	push   $0x25
  jmp alltraps
801070b8:	e9 b2 f9 ff ff       	jmp    80106a6f <alltraps>

801070bd <vector38>:
.globl vector38
vector38:
  pushl $0
801070bd:	6a 00                	push   $0x0
  pushl $38
801070bf:	6a 26                	push   $0x26
  jmp alltraps
801070c1:	e9 a9 f9 ff ff       	jmp    80106a6f <alltraps>

801070c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801070c6:	6a 00                	push   $0x0
  pushl $39
801070c8:	6a 27                	push   $0x27
  jmp alltraps
801070ca:	e9 a0 f9 ff ff       	jmp    80106a6f <alltraps>

801070cf <vector40>:
.globl vector40
vector40:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $40
801070d1:	6a 28                	push   $0x28
  jmp alltraps
801070d3:	e9 97 f9 ff ff       	jmp    80106a6f <alltraps>

801070d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801070d8:	6a 00                	push   $0x0
  pushl $41
801070da:	6a 29                	push   $0x29
  jmp alltraps
801070dc:	e9 8e f9 ff ff       	jmp    80106a6f <alltraps>

801070e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801070e1:	6a 00                	push   $0x0
  pushl $42
801070e3:	6a 2a                	push   $0x2a
  jmp alltraps
801070e5:	e9 85 f9 ff ff       	jmp    80106a6f <alltraps>

801070ea <vector43>:
.globl vector43
vector43:
  pushl $0
801070ea:	6a 00                	push   $0x0
  pushl $43
801070ec:	6a 2b                	push   $0x2b
  jmp alltraps
801070ee:	e9 7c f9 ff ff       	jmp    80106a6f <alltraps>

801070f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $44
801070f5:	6a 2c                	push   $0x2c
  jmp alltraps
801070f7:	e9 73 f9 ff ff       	jmp    80106a6f <alltraps>

801070fc <vector45>:
.globl vector45
vector45:
  pushl $0
801070fc:	6a 00                	push   $0x0
  pushl $45
801070fe:	6a 2d                	push   $0x2d
  jmp alltraps
80107100:	e9 6a f9 ff ff       	jmp    80106a6f <alltraps>

80107105 <vector46>:
.globl vector46
vector46:
  pushl $0
80107105:	6a 00                	push   $0x0
  pushl $46
80107107:	6a 2e                	push   $0x2e
  jmp alltraps
80107109:	e9 61 f9 ff ff       	jmp    80106a6f <alltraps>

8010710e <vector47>:
.globl vector47
vector47:
  pushl $0
8010710e:	6a 00                	push   $0x0
  pushl $47
80107110:	6a 2f                	push   $0x2f
  jmp alltraps
80107112:	e9 58 f9 ff ff       	jmp    80106a6f <alltraps>

80107117 <vector48>:
.globl vector48
vector48:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $48
80107119:	6a 30                	push   $0x30
  jmp alltraps
8010711b:	e9 4f f9 ff ff       	jmp    80106a6f <alltraps>

80107120 <vector49>:
.globl vector49
vector49:
  pushl $0
80107120:	6a 00                	push   $0x0
  pushl $49
80107122:	6a 31                	push   $0x31
  jmp alltraps
80107124:	e9 46 f9 ff ff       	jmp    80106a6f <alltraps>

80107129 <vector50>:
.globl vector50
vector50:
  pushl $0
80107129:	6a 00                	push   $0x0
  pushl $50
8010712b:	6a 32                	push   $0x32
  jmp alltraps
8010712d:	e9 3d f9 ff ff       	jmp    80106a6f <alltraps>

80107132 <vector51>:
.globl vector51
vector51:
  pushl $0
80107132:	6a 00                	push   $0x0
  pushl $51
80107134:	6a 33                	push   $0x33
  jmp alltraps
80107136:	e9 34 f9 ff ff       	jmp    80106a6f <alltraps>

8010713b <vector52>:
.globl vector52
vector52:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $52
8010713d:	6a 34                	push   $0x34
  jmp alltraps
8010713f:	e9 2b f9 ff ff       	jmp    80106a6f <alltraps>

80107144 <vector53>:
.globl vector53
vector53:
  pushl $0
80107144:	6a 00                	push   $0x0
  pushl $53
80107146:	6a 35                	push   $0x35
  jmp alltraps
80107148:	e9 22 f9 ff ff       	jmp    80106a6f <alltraps>

8010714d <vector54>:
.globl vector54
vector54:
  pushl $0
8010714d:	6a 00                	push   $0x0
  pushl $54
8010714f:	6a 36                	push   $0x36
  jmp alltraps
80107151:	e9 19 f9 ff ff       	jmp    80106a6f <alltraps>

80107156 <vector55>:
.globl vector55
vector55:
  pushl $0
80107156:	6a 00                	push   $0x0
  pushl $55
80107158:	6a 37                	push   $0x37
  jmp alltraps
8010715a:	e9 10 f9 ff ff       	jmp    80106a6f <alltraps>

8010715f <vector56>:
.globl vector56
vector56:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $56
80107161:	6a 38                	push   $0x38
  jmp alltraps
80107163:	e9 07 f9 ff ff       	jmp    80106a6f <alltraps>

80107168 <vector57>:
.globl vector57
vector57:
  pushl $0
80107168:	6a 00                	push   $0x0
  pushl $57
8010716a:	6a 39                	push   $0x39
  jmp alltraps
8010716c:	e9 fe f8 ff ff       	jmp    80106a6f <alltraps>

80107171 <vector58>:
.globl vector58
vector58:
  pushl $0
80107171:	6a 00                	push   $0x0
  pushl $58
80107173:	6a 3a                	push   $0x3a
  jmp alltraps
80107175:	e9 f5 f8 ff ff       	jmp    80106a6f <alltraps>

8010717a <vector59>:
.globl vector59
vector59:
  pushl $0
8010717a:	6a 00                	push   $0x0
  pushl $59
8010717c:	6a 3b                	push   $0x3b
  jmp alltraps
8010717e:	e9 ec f8 ff ff       	jmp    80106a6f <alltraps>

80107183 <vector60>:
.globl vector60
vector60:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $60
80107185:	6a 3c                	push   $0x3c
  jmp alltraps
80107187:	e9 e3 f8 ff ff       	jmp    80106a6f <alltraps>

8010718c <vector61>:
.globl vector61
vector61:
  pushl $0
8010718c:	6a 00                	push   $0x0
  pushl $61
8010718e:	6a 3d                	push   $0x3d
  jmp alltraps
80107190:	e9 da f8 ff ff       	jmp    80106a6f <alltraps>

80107195 <vector62>:
.globl vector62
vector62:
  pushl $0
80107195:	6a 00                	push   $0x0
  pushl $62
80107197:	6a 3e                	push   $0x3e
  jmp alltraps
80107199:	e9 d1 f8 ff ff       	jmp    80106a6f <alltraps>

8010719e <vector63>:
.globl vector63
vector63:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $63
801071a0:	6a 3f                	push   $0x3f
  jmp alltraps
801071a2:	e9 c8 f8 ff ff       	jmp    80106a6f <alltraps>

801071a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $64
801071a9:	6a 40                	push   $0x40
  jmp alltraps
801071ab:	e9 bf f8 ff ff       	jmp    80106a6f <alltraps>

801071b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801071b0:	6a 00                	push   $0x0
  pushl $65
801071b2:	6a 41                	push   $0x41
  jmp alltraps
801071b4:	e9 b6 f8 ff ff       	jmp    80106a6f <alltraps>

801071b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801071b9:	6a 00                	push   $0x0
  pushl $66
801071bb:	6a 42                	push   $0x42
  jmp alltraps
801071bd:	e9 ad f8 ff ff       	jmp    80106a6f <alltraps>

801071c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $67
801071c4:	6a 43                	push   $0x43
  jmp alltraps
801071c6:	e9 a4 f8 ff ff       	jmp    80106a6f <alltraps>

801071cb <vector68>:
.globl vector68
vector68:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $68
801071cd:	6a 44                	push   $0x44
  jmp alltraps
801071cf:	e9 9b f8 ff ff       	jmp    80106a6f <alltraps>

801071d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801071d4:	6a 00                	push   $0x0
  pushl $69
801071d6:	6a 45                	push   $0x45
  jmp alltraps
801071d8:	e9 92 f8 ff ff       	jmp    80106a6f <alltraps>

801071dd <vector70>:
.globl vector70
vector70:
  pushl $0
801071dd:	6a 00                	push   $0x0
  pushl $70
801071df:	6a 46                	push   $0x46
  jmp alltraps
801071e1:	e9 89 f8 ff ff       	jmp    80106a6f <alltraps>

801071e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $71
801071e8:	6a 47                	push   $0x47
  jmp alltraps
801071ea:	e9 80 f8 ff ff       	jmp    80106a6f <alltraps>

801071ef <vector72>:
.globl vector72
vector72:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $72
801071f1:	6a 48                	push   $0x48
  jmp alltraps
801071f3:	e9 77 f8 ff ff       	jmp    80106a6f <alltraps>

801071f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801071f8:	6a 00                	push   $0x0
  pushl $73
801071fa:	6a 49                	push   $0x49
  jmp alltraps
801071fc:	e9 6e f8 ff ff       	jmp    80106a6f <alltraps>

80107201 <vector74>:
.globl vector74
vector74:
  pushl $0
80107201:	6a 00                	push   $0x0
  pushl $74
80107203:	6a 4a                	push   $0x4a
  jmp alltraps
80107205:	e9 65 f8 ff ff       	jmp    80106a6f <alltraps>

8010720a <vector75>:
.globl vector75
vector75:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $75
8010720c:	6a 4b                	push   $0x4b
  jmp alltraps
8010720e:	e9 5c f8 ff ff       	jmp    80106a6f <alltraps>

80107213 <vector76>:
.globl vector76
vector76:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $76
80107215:	6a 4c                	push   $0x4c
  jmp alltraps
80107217:	e9 53 f8 ff ff       	jmp    80106a6f <alltraps>

8010721c <vector77>:
.globl vector77
vector77:
  pushl $0
8010721c:	6a 00                	push   $0x0
  pushl $77
8010721e:	6a 4d                	push   $0x4d
  jmp alltraps
80107220:	e9 4a f8 ff ff       	jmp    80106a6f <alltraps>

80107225 <vector78>:
.globl vector78
vector78:
  pushl $0
80107225:	6a 00                	push   $0x0
  pushl $78
80107227:	6a 4e                	push   $0x4e
  jmp alltraps
80107229:	e9 41 f8 ff ff       	jmp    80106a6f <alltraps>

8010722e <vector79>:
.globl vector79
vector79:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $79
80107230:	6a 4f                	push   $0x4f
  jmp alltraps
80107232:	e9 38 f8 ff ff       	jmp    80106a6f <alltraps>

80107237 <vector80>:
.globl vector80
vector80:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $80
80107239:	6a 50                	push   $0x50
  jmp alltraps
8010723b:	e9 2f f8 ff ff       	jmp    80106a6f <alltraps>

80107240 <vector81>:
.globl vector81
vector81:
  pushl $0
80107240:	6a 00                	push   $0x0
  pushl $81
80107242:	6a 51                	push   $0x51
  jmp alltraps
80107244:	e9 26 f8 ff ff       	jmp    80106a6f <alltraps>

80107249 <vector82>:
.globl vector82
vector82:
  pushl $0
80107249:	6a 00                	push   $0x0
  pushl $82
8010724b:	6a 52                	push   $0x52
  jmp alltraps
8010724d:	e9 1d f8 ff ff       	jmp    80106a6f <alltraps>

80107252 <vector83>:
.globl vector83
vector83:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $83
80107254:	6a 53                	push   $0x53
  jmp alltraps
80107256:	e9 14 f8 ff ff       	jmp    80106a6f <alltraps>

8010725b <vector84>:
.globl vector84
vector84:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $84
8010725d:	6a 54                	push   $0x54
  jmp alltraps
8010725f:	e9 0b f8 ff ff       	jmp    80106a6f <alltraps>

80107264 <vector85>:
.globl vector85
vector85:
  pushl $0
80107264:	6a 00                	push   $0x0
  pushl $85
80107266:	6a 55                	push   $0x55
  jmp alltraps
80107268:	e9 02 f8 ff ff       	jmp    80106a6f <alltraps>

8010726d <vector86>:
.globl vector86
vector86:
  pushl $0
8010726d:	6a 00                	push   $0x0
  pushl $86
8010726f:	6a 56                	push   $0x56
  jmp alltraps
80107271:	e9 f9 f7 ff ff       	jmp    80106a6f <alltraps>

80107276 <vector87>:
.globl vector87
vector87:
  pushl $0
80107276:	6a 00                	push   $0x0
  pushl $87
80107278:	6a 57                	push   $0x57
  jmp alltraps
8010727a:	e9 f0 f7 ff ff       	jmp    80106a6f <alltraps>

8010727f <vector88>:
.globl vector88
vector88:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $88
80107281:	6a 58                	push   $0x58
  jmp alltraps
80107283:	e9 e7 f7 ff ff       	jmp    80106a6f <alltraps>

80107288 <vector89>:
.globl vector89
vector89:
  pushl $0
80107288:	6a 00                	push   $0x0
  pushl $89
8010728a:	6a 59                	push   $0x59
  jmp alltraps
8010728c:	e9 de f7 ff ff       	jmp    80106a6f <alltraps>

80107291 <vector90>:
.globl vector90
vector90:
  pushl $0
80107291:	6a 00                	push   $0x0
  pushl $90
80107293:	6a 5a                	push   $0x5a
  jmp alltraps
80107295:	e9 d5 f7 ff ff       	jmp    80106a6f <alltraps>

8010729a <vector91>:
.globl vector91
vector91:
  pushl $0
8010729a:	6a 00                	push   $0x0
  pushl $91
8010729c:	6a 5b                	push   $0x5b
  jmp alltraps
8010729e:	e9 cc f7 ff ff       	jmp    80106a6f <alltraps>

801072a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $92
801072a5:	6a 5c                	push   $0x5c
  jmp alltraps
801072a7:	e9 c3 f7 ff ff       	jmp    80106a6f <alltraps>

801072ac <vector93>:
.globl vector93
vector93:
  pushl $0
801072ac:	6a 00                	push   $0x0
  pushl $93
801072ae:	6a 5d                	push   $0x5d
  jmp alltraps
801072b0:	e9 ba f7 ff ff       	jmp    80106a6f <alltraps>

801072b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801072b5:	6a 00                	push   $0x0
  pushl $94
801072b7:	6a 5e                	push   $0x5e
  jmp alltraps
801072b9:	e9 b1 f7 ff ff       	jmp    80106a6f <alltraps>

801072be <vector95>:
.globl vector95
vector95:
  pushl $0
801072be:	6a 00                	push   $0x0
  pushl $95
801072c0:	6a 5f                	push   $0x5f
  jmp alltraps
801072c2:	e9 a8 f7 ff ff       	jmp    80106a6f <alltraps>

801072c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $96
801072c9:	6a 60                	push   $0x60
  jmp alltraps
801072cb:	e9 9f f7 ff ff       	jmp    80106a6f <alltraps>

801072d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801072d0:	6a 00                	push   $0x0
  pushl $97
801072d2:	6a 61                	push   $0x61
  jmp alltraps
801072d4:	e9 96 f7 ff ff       	jmp    80106a6f <alltraps>

801072d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801072d9:	6a 00                	push   $0x0
  pushl $98
801072db:	6a 62                	push   $0x62
  jmp alltraps
801072dd:	e9 8d f7 ff ff       	jmp    80106a6f <alltraps>

801072e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801072e2:	6a 00                	push   $0x0
  pushl $99
801072e4:	6a 63                	push   $0x63
  jmp alltraps
801072e6:	e9 84 f7 ff ff       	jmp    80106a6f <alltraps>

801072eb <vector100>:
.globl vector100
vector100:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $100
801072ed:	6a 64                	push   $0x64
  jmp alltraps
801072ef:	e9 7b f7 ff ff       	jmp    80106a6f <alltraps>

801072f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801072f4:	6a 00                	push   $0x0
  pushl $101
801072f6:	6a 65                	push   $0x65
  jmp alltraps
801072f8:	e9 72 f7 ff ff       	jmp    80106a6f <alltraps>

801072fd <vector102>:
.globl vector102
vector102:
  pushl $0
801072fd:	6a 00                	push   $0x0
  pushl $102
801072ff:	6a 66                	push   $0x66
  jmp alltraps
80107301:	e9 69 f7 ff ff       	jmp    80106a6f <alltraps>

80107306 <vector103>:
.globl vector103
vector103:
  pushl $0
80107306:	6a 00                	push   $0x0
  pushl $103
80107308:	6a 67                	push   $0x67
  jmp alltraps
8010730a:	e9 60 f7 ff ff       	jmp    80106a6f <alltraps>

8010730f <vector104>:
.globl vector104
vector104:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $104
80107311:	6a 68                	push   $0x68
  jmp alltraps
80107313:	e9 57 f7 ff ff       	jmp    80106a6f <alltraps>

80107318 <vector105>:
.globl vector105
vector105:
  pushl $0
80107318:	6a 00                	push   $0x0
  pushl $105
8010731a:	6a 69                	push   $0x69
  jmp alltraps
8010731c:	e9 4e f7 ff ff       	jmp    80106a6f <alltraps>

80107321 <vector106>:
.globl vector106
vector106:
  pushl $0
80107321:	6a 00                	push   $0x0
  pushl $106
80107323:	6a 6a                	push   $0x6a
  jmp alltraps
80107325:	e9 45 f7 ff ff       	jmp    80106a6f <alltraps>

8010732a <vector107>:
.globl vector107
vector107:
  pushl $0
8010732a:	6a 00                	push   $0x0
  pushl $107
8010732c:	6a 6b                	push   $0x6b
  jmp alltraps
8010732e:	e9 3c f7 ff ff       	jmp    80106a6f <alltraps>

80107333 <vector108>:
.globl vector108
vector108:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $108
80107335:	6a 6c                	push   $0x6c
  jmp alltraps
80107337:	e9 33 f7 ff ff       	jmp    80106a6f <alltraps>

8010733c <vector109>:
.globl vector109
vector109:
  pushl $0
8010733c:	6a 00                	push   $0x0
  pushl $109
8010733e:	6a 6d                	push   $0x6d
  jmp alltraps
80107340:	e9 2a f7 ff ff       	jmp    80106a6f <alltraps>

80107345 <vector110>:
.globl vector110
vector110:
  pushl $0
80107345:	6a 00                	push   $0x0
  pushl $110
80107347:	6a 6e                	push   $0x6e
  jmp alltraps
80107349:	e9 21 f7 ff ff       	jmp    80106a6f <alltraps>

8010734e <vector111>:
.globl vector111
vector111:
  pushl $0
8010734e:	6a 00                	push   $0x0
  pushl $111
80107350:	6a 6f                	push   $0x6f
  jmp alltraps
80107352:	e9 18 f7 ff ff       	jmp    80106a6f <alltraps>

80107357 <vector112>:
.globl vector112
vector112:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $112
80107359:	6a 70                	push   $0x70
  jmp alltraps
8010735b:	e9 0f f7 ff ff       	jmp    80106a6f <alltraps>

80107360 <vector113>:
.globl vector113
vector113:
  pushl $0
80107360:	6a 00                	push   $0x0
  pushl $113
80107362:	6a 71                	push   $0x71
  jmp alltraps
80107364:	e9 06 f7 ff ff       	jmp    80106a6f <alltraps>

80107369 <vector114>:
.globl vector114
vector114:
  pushl $0
80107369:	6a 00                	push   $0x0
  pushl $114
8010736b:	6a 72                	push   $0x72
  jmp alltraps
8010736d:	e9 fd f6 ff ff       	jmp    80106a6f <alltraps>

80107372 <vector115>:
.globl vector115
vector115:
  pushl $0
80107372:	6a 00                	push   $0x0
  pushl $115
80107374:	6a 73                	push   $0x73
  jmp alltraps
80107376:	e9 f4 f6 ff ff       	jmp    80106a6f <alltraps>

8010737b <vector116>:
.globl vector116
vector116:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $116
8010737d:	6a 74                	push   $0x74
  jmp alltraps
8010737f:	e9 eb f6 ff ff       	jmp    80106a6f <alltraps>

80107384 <vector117>:
.globl vector117
vector117:
  pushl $0
80107384:	6a 00                	push   $0x0
  pushl $117
80107386:	6a 75                	push   $0x75
  jmp alltraps
80107388:	e9 e2 f6 ff ff       	jmp    80106a6f <alltraps>

8010738d <vector118>:
.globl vector118
vector118:
  pushl $0
8010738d:	6a 00                	push   $0x0
  pushl $118
8010738f:	6a 76                	push   $0x76
  jmp alltraps
80107391:	e9 d9 f6 ff ff       	jmp    80106a6f <alltraps>

80107396 <vector119>:
.globl vector119
vector119:
  pushl $0
80107396:	6a 00                	push   $0x0
  pushl $119
80107398:	6a 77                	push   $0x77
  jmp alltraps
8010739a:	e9 d0 f6 ff ff       	jmp    80106a6f <alltraps>

8010739f <vector120>:
.globl vector120
vector120:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $120
801073a1:	6a 78                	push   $0x78
  jmp alltraps
801073a3:	e9 c7 f6 ff ff       	jmp    80106a6f <alltraps>

801073a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801073a8:	6a 00                	push   $0x0
  pushl $121
801073aa:	6a 79                	push   $0x79
  jmp alltraps
801073ac:	e9 be f6 ff ff       	jmp    80106a6f <alltraps>

801073b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801073b1:	6a 00                	push   $0x0
  pushl $122
801073b3:	6a 7a                	push   $0x7a
  jmp alltraps
801073b5:	e9 b5 f6 ff ff       	jmp    80106a6f <alltraps>

801073ba <vector123>:
.globl vector123
vector123:
  pushl $0
801073ba:	6a 00                	push   $0x0
  pushl $123
801073bc:	6a 7b                	push   $0x7b
  jmp alltraps
801073be:	e9 ac f6 ff ff       	jmp    80106a6f <alltraps>

801073c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $124
801073c5:	6a 7c                	push   $0x7c
  jmp alltraps
801073c7:	e9 a3 f6 ff ff       	jmp    80106a6f <alltraps>

801073cc <vector125>:
.globl vector125
vector125:
  pushl $0
801073cc:	6a 00                	push   $0x0
  pushl $125
801073ce:	6a 7d                	push   $0x7d
  jmp alltraps
801073d0:	e9 9a f6 ff ff       	jmp    80106a6f <alltraps>

801073d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801073d5:	6a 00                	push   $0x0
  pushl $126
801073d7:	6a 7e                	push   $0x7e
  jmp alltraps
801073d9:	e9 91 f6 ff ff       	jmp    80106a6f <alltraps>

801073de <vector127>:
.globl vector127
vector127:
  pushl $0
801073de:	6a 00                	push   $0x0
  pushl $127
801073e0:	6a 7f                	push   $0x7f
  jmp alltraps
801073e2:	e9 88 f6 ff ff       	jmp    80106a6f <alltraps>

801073e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $128
801073e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801073ee:	e9 7c f6 ff ff       	jmp    80106a6f <alltraps>

801073f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $129
801073f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801073fa:	e9 70 f6 ff ff       	jmp    80106a6f <alltraps>

801073ff <vector130>:
.globl vector130
vector130:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $130
80107401:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107406:	e9 64 f6 ff ff       	jmp    80106a6f <alltraps>

8010740b <vector131>:
.globl vector131
vector131:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $131
8010740d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107412:	e9 58 f6 ff ff       	jmp    80106a6f <alltraps>

80107417 <vector132>:
.globl vector132
vector132:
  pushl $0
80107417:	6a 00                	push   $0x0
  pushl $132
80107419:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010741e:	e9 4c f6 ff ff       	jmp    80106a6f <alltraps>

80107423 <vector133>:
.globl vector133
vector133:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $133
80107425:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010742a:	e9 40 f6 ff ff       	jmp    80106a6f <alltraps>

8010742f <vector134>:
.globl vector134
vector134:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $134
80107431:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107436:	e9 34 f6 ff ff       	jmp    80106a6f <alltraps>

8010743b <vector135>:
.globl vector135
vector135:
  pushl $0
8010743b:	6a 00                	push   $0x0
  pushl $135
8010743d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107442:	e9 28 f6 ff ff       	jmp    80106a6f <alltraps>

80107447 <vector136>:
.globl vector136
vector136:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $136
80107449:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010744e:	e9 1c f6 ff ff       	jmp    80106a6f <alltraps>

80107453 <vector137>:
.globl vector137
vector137:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $137
80107455:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010745a:	e9 10 f6 ff ff       	jmp    80106a6f <alltraps>

8010745f <vector138>:
.globl vector138
vector138:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $138
80107461:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107466:	e9 04 f6 ff ff       	jmp    80106a6f <alltraps>

8010746b <vector139>:
.globl vector139
vector139:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $139
8010746d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107472:	e9 f8 f5 ff ff       	jmp    80106a6f <alltraps>

80107477 <vector140>:
.globl vector140
vector140:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $140
80107479:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010747e:	e9 ec f5 ff ff       	jmp    80106a6f <alltraps>

80107483 <vector141>:
.globl vector141
vector141:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $141
80107485:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010748a:	e9 e0 f5 ff ff       	jmp    80106a6f <alltraps>

8010748f <vector142>:
.globl vector142
vector142:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $142
80107491:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107496:	e9 d4 f5 ff ff       	jmp    80106a6f <alltraps>

8010749b <vector143>:
.globl vector143
vector143:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $143
8010749d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801074a2:	e9 c8 f5 ff ff       	jmp    80106a6f <alltraps>

801074a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801074a7:	6a 00                	push   $0x0
  pushl $144
801074a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801074ae:	e9 bc f5 ff ff       	jmp    80106a6f <alltraps>

801074b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $145
801074b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801074ba:	e9 b0 f5 ff ff       	jmp    80106a6f <alltraps>

801074bf <vector146>:
.globl vector146
vector146:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $146
801074c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801074c6:	e9 a4 f5 ff ff       	jmp    80106a6f <alltraps>

801074cb <vector147>:
.globl vector147
vector147:
  pushl $0
801074cb:	6a 00                	push   $0x0
  pushl $147
801074cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801074d2:	e9 98 f5 ff ff       	jmp    80106a6f <alltraps>

801074d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $148
801074d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801074de:	e9 8c f5 ff ff       	jmp    80106a6f <alltraps>

801074e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $149
801074e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801074ea:	e9 80 f5 ff ff       	jmp    80106a6f <alltraps>

801074ef <vector150>:
.globl vector150
vector150:
  pushl $0
801074ef:	6a 00                	push   $0x0
  pushl $150
801074f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801074f6:	e9 74 f5 ff ff       	jmp    80106a6f <alltraps>

801074fb <vector151>:
.globl vector151
vector151:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $151
801074fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107502:	e9 68 f5 ff ff       	jmp    80106a6f <alltraps>

80107507 <vector152>:
.globl vector152
vector152:
  pushl $0
80107507:	6a 00                	push   $0x0
  pushl $152
80107509:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010750e:	e9 5c f5 ff ff       	jmp    80106a6f <alltraps>

80107513 <vector153>:
.globl vector153
vector153:
  pushl $0
80107513:	6a 00                	push   $0x0
  pushl $153
80107515:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010751a:	e9 50 f5 ff ff       	jmp    80106a6f <alltraps>

8010751f <vector154>:
.globl vector154
vector154:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $154
80107521:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107526:	e9 44 f5 ff ff       	jmp    80106a6f <alltraps>

8010752b <vector155>:
.globl vector155
vector155:
  pushl $0
8010752b:	6a 00                	push   $0x0
  pushl $155
8010752d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107532:	e9 38 f5 ff ff       	jmp    80106a6f <alltraps>

80107537 <vector156>:
.globl vector156
vector156:
  pushl $0
80107537:	6a 00                	push   $0x0
  pushl $156
80107539:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010753e:	e9 2c f5 ff ff       	jmp    80106a6f <alltraps>

80107543 <vector157>:
.globl vector157
vector157:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $157
80107545:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010754a:	e9 20 f5 ff ff       	jmp    80106a6f <alltraps>

8010754f <vector158>:
.globl vector158
vector158:
  pushl $0
8010754f:	6a 00                	push   $0x0
  pushl $158
80107551:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107556:	e9 14 f5 ff ff       	jmp    80106a6f <alltraps>

8010755b <vector159>:
.globl vector159
vector159:
  pushl $0
8010755b:	6a 00                	push   $0x0
  pushl $159
8010755d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107562:	e9 08 f5 ff ff       	jmp    80106a6f <alltraps>

80107567 <vector160>:
.globl vector160
vector160:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $160
80107569:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010756e:	e9 fc f4 ff ff       	jmp    80106a6f <alltraps>

80107573 <vector161>:
.globl vector161
vector161:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $161
80107575:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010757a:	e9 f0 f4 ff ff       	jmp    80106a6f <alltraps>

8010757f <vector162>:
.globl vector162
vector162:
  pushl $0
8010757f:	6a 00                	push   $0x0
  pushl $162
80107581:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107586:	e9 e4 f4 ff ff       	jmp    80106a6f <alltraps>

8010758b <vector163>:
.globl vector163
vector163:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $163
8010758d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107592:	e9 d8 f4 ff ff       	jmp    80106a6f <alltraps>

80107597 <vector164>:
.globl vector164
vector164:
  pushl $0
80107597:	6a 00                	push   $0x0
  pushl $164
80107599:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010759e:	e9 cc f4 ff ff       	jmp    80106a6f <alltraps>

801075a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801075a3:	6a 00                	push   $0x0
  pushl $165
801075a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801075aa:	e9 c0 f4 ff ff       	jmp    80106a6f <alltraps>

801075af <vector166>:
.globl vector166
vector166:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $166
801075b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801075b6:	e9 b4 f4 ff ff       	jmp    80106a6f <alltraps>

801075bb <vector167>:
.globl vector167
vector167:
  pushl $0
801075bb:	6a 00                	push   $0x0
  pushl $167
801075bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801075c2:	e9 a8 f4 ff ff       	jmp    80106a6f <alltraps>

801075c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801075c7:	6a 00                	push   $0x0
  pushl $168
801075c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801075ce:	e9 9c f4 ff ff       	jmp    80106a6f <alltraps>

801075d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $169
801075d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801075da:	e9 90 f4 ff ff       	jmp    80106a6f <alltraps>

801075df <vector170>:
.globl vector170
vector170:
  pushl $0
801075df:	6a 00                	push   $0x0
  pushl $170
801075e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801075e6:	e9 84 f4 ff ff       	jmp    80106a6f <alltraps>

801075eb <vector171>:
.globl vector171
vector171:
  pushl $0
801075eb:	6a 00                	push   $0x0
  pushl $171
801075ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801075f2:	e9 78 f4 ff ff       	jmp    80106a6f <alltraps>

801075f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $172
801075f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801075fe:	e9 6c f4 ff ff       	jmp    80106a6f <alltraps>

80107603 <vector173>:
.globl vector173
vector173:
  pushl $0
80107603:	6a 00                	push   $0x0
  pushl $173
80107605:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010760a:	e9 60 f4 ff ff       	jmp    80106a6f <alltraps>

8010760f <vector174>:
.globl vector174
vector174:
  pushl $0
8010760f:	6a 00                	push   $0x0
  pushl $174
80107611:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107616:	e9 54 f4 ff ff       	jmp    80106a6f <alltraps>

8010761b <vector175>:
.globl vector175
vector175:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $175
8010761d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107622:	e9 48 f4 ff ff       	jmp    80106a6f <alltraps>

80107627 <vector176>:
.globl vector176
vector176:
  pushl $0
80107627:	6a 00                	push   $0x0
  pushl $176
80107629:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010762e:	e9 3c f4 ff ff       	jmp    80106a6f <alltraps>

80107633 <vector177>:
.globl vector177
vector177:
  pushl $0
80107633:	6a 00                	push   $0x0
  pushl $177
80107635:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010763a:	e9 30 f4 ff ff       	jmp    80106a6f <alltraps>

8010763f <vector178>:
.globl vector178
vector178:
  pushl $0
8010763f:	6a 00                	push   $0x0
  pushl $178
80107641:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107646:	e9 24 f4 ff ff       	jmp    80106a6f <alltraps>

8010764b <vector179>:
.globl vector179
vector179:
  pushl $0
8010764b:	6a 00                	push   $0x0
  pushl $179
8010764d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107652:	e9 18 f4 ff ff       	jmp    80106a6f <alltraps>

80107657 <vector180>:
.globl vector180
vector180:
  pushl $0
80107657:	6a 00                	push   $0x0
  pushl $180
80107659:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010765e:	e9 0c f4 ff ff       	jmp    80106a6f <alltraps>

80107663 <vector181>:
.globl vector181
vector181:
  pushl $0
80107663:	6a 00                	push   $0x0
  pushl $181
80107665:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010766a:	e9 00 f4 ff ff       	jmp    80106a6f <alltraps>

8010766f <vector182>:
.globl vector182
vector182:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $182
80107671:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107676:	e9 f4 f3 ff ff       	jmp    80106a6f <alltraps>

8010767b <vector183>:
.globl vector183
vector183:
  pushl $0
8010767b:	6a 00                	push   $0x0
  pushl $183
8010767d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107682:	e9 e8 f3 ff ff       	jmp    80106a6f <alltraps>

80107687 <vector184>:
.globl vector184
vector184:
  pushl $0
80107687:	6a 00                	push   $0x0
  pushl $184
80107689:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010768e:	e9 dc f3 ff ff       	jmp    80106a6f <alltraps>

80107693 <vector185>:
.globl vector185
vector185:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $185
80107695:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010769a:	e9 d0 f3 ff ff       	jmp    80106a6f <alltraps>

8010769f <vector186>:
.globl vector186
vector186:
  pushl $0
8010769f:	6a 00                	push   $0x0
  pushl $186
801076a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801076a6:	e9 c4 f3 ff ff       	jmp    80106a6f <alltraps>

801076ab <vector187>:
.globl vector187
vector187:
  pushl $0
801076ab:	6a 00                	push   $0x0
  pushl $187
801076ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801076b2:	e9 b8 f3 ff ff       	jmp    80106a6f <alltraps>

801076b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $188
801076b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801076be:	e9 ac f3 ff ff       	jmp    80106a6f <alltraps>

801076c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801076c3:	6a 00                	push   $0x0
  pushl $189
801076c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801076ca:	e9 a0 f3 ff ff       	jmp    80106a6f <alltraps>

801076cf <vector190>:
.globl vector190
vector190:
  pushl $0
801076cf:	6a 00                	push   $0x0
  pushl $190
801076d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801076d6:	e9 94 f3 ff ff       	jmp    80106a6f <alltraps>

801076db <vector191>:
.globl vector191
vector191:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $191
801076dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801076e2:	e9 88 f3 ff ff       	jmp    80106a6f <alltraps>

801076e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801076e7:	6a 00                	push   $0x0
  pushl $192
801076e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801076ee:	e9 7c f3 ff ff       	jmp    80106a6f <alltraps>

801076f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801076f3:	6a 00                	push   $0x0
  pushl $193
801076f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801076fa:	e9 70 f3 ff ff       	jmp    80106a6f <alltraps>

801076ff <vector194>:
.globl vector194
vector194:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $194
80107701:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107706:	e9 64 f3 ff ff       	jmp    80106a6f <alltraps>

8010770b <vector195>:
.globl vector195
vector195:
  pushl $0
8010770b:	6a 00                	push   $0x0
  pushl $195
8010770d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107712:	e9 58 f3 ff ff       	jmp    80106a6f <alltraps>

80107717 <vector196>:
.globl vector196
vector196:
  pushl $0
80107717:	6a 00                	push   $0x0
  pushl $196
80107719:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010771e:	e9 4c f3 ff ff       	jmp    80106a6f <alltraps>

80107723 <vector197>:
.globl vector197
vector197:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $197
80107725:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010772a:	e9 40 f3 ff ff       	jmp    80106a6f <alltraps>

8010772f <vector198>:
.globl vector198
vector198:
  pushl $0
8010772f:	6a 00                	push   $0x0
  pushl $198
80107731:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107736:	e9 34 f3 ff ff       	jmp    80106a6f <alltraps>

8010773b <vector199>:
.globl vector199
vector199:
  pushl $0
8010773b:	6a 00                	push   $0x0
  pushl $199
8010773d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107742:	e9 28 f3 ff ff       	jmp    80106a6f <alltraps>

80107747 <vector200>:
.globl vector200
vector200:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $200
80107749:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010774e:	e9 1c f3 ff ff       	jmp    80106a6f <alltraps>

80107753 <vector201>:
.globl vector201
vector201:
  pushl $0
80107753:	6a 00                	push   $0x0
  pushl $201
80107755:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010775a:	e9 10 f3 ff ff       	jmp    80106a6f <alltraps>

8010775f <vector202>:
.globl vector202
vector202:
  pushl $0
8010775f:	6a 00                	push   $0x0
  pushl $202
80107761:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107766:	e9 04 f3 ff ff       	jmp    80106a6f <alltraps>

8010776b <vector203>:
.globl vector203
vector203:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $203
8010776d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107772:	e9 f8 f2 ff ff       	jmp    80106a6f <alltraps>

80107777 <vector204>:
.globl vector204
vector204:
  pushl $0
80107777:	6a 00                	push   $0x0
  pushl $204
80107779:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010777e:	e9 ec f2 ff ff       	jmp    80106a6f <alltraps>

80107783 <vector205>:
.globl vector205
vector205:
  pushl $0
80107783:	6a 00                	push   $0x0
  pushl $205
80107785:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010778a:	e9 e0 f2 ff ff       	jmp    80106a6f <alltraps>

8010778f <vector206>:
.globl vector206
vector206:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $206
80107791:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107796:	e9 d4 f2 ff ff       	jmp    80106a6f <alltraps>

8010779b <vector207>:
.globl vector207
vector207:
  pushl $0
8010779b:	6a 00                	push   $0x0
  pushl $207
8010779d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801077a2:	e9 c8 f2 ff ff       	jmp    80106a6f <alltraps>

801077a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801077a7:	6a 00                	push   $0x0
  pushl $208
801077a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801077ae:	e9 bc f2 ff ff       	jmp    80106a6f <alltraps>

801077b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $209
801077b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801077ba:	e9 b0 f2 ff ff       	jmp    80106a6f <alltraps>

801077bf <vector210>:
.globl vector210
vector210:
  pushl $0
801077bf:	6a 00                	push   $0x0
  pushl $210
801077c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801077c6:	e9 a4 f2 ff ff       	jmp    80106a6f <alltraps>

801077cb <vector211>:
.globl vector211
vector211:
  pushl $0
801077cb:	6a 00                	push   $0x0
  pushl $211
801077cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801077d2:	e9 98 f2 ff ff       	jmp    80106a6f <alltraps>

801077d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801077d7:	6a 00                	push   $0x0
  pushl $212
801077d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801077de:	e9 8c f2 ff ff       	jmp    80106a6f <alltraps>

801077e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801077e3:	6a 00                	push   $0x0
  pushl $213
801077e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801077ea:	e9 80 f2 ff ff       	jmp    80106a6f <alltraps>

801077ef <vector214>:
.globl vector214
vector214:
  pushl $0
801077ef:	6a 00                	push   $0x0
  pushl $214
801077f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801077f6:	e9 74 f2 ff ff       	jmp    80106a6f <alltraps>

801077fb <vector215>:
.globl vector215
vector215:
  pushl $0
801077fb:	6a 00                	push   $0x0
  pushl $215
801077fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107802:	e9 68 f2 ff ff       	jmp    80106a6f <alltraps>

80107807 <vector216>:
.globl vector216
vector216:
  pushl $0
80107807:	6a 00                	push   $0x0
  pushl $216
80107809:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010780e:	e9 5c f2 ff ff       	jmp    80106a6f <alltraps>

80107813 <vector217>:
.globl vector217
vector217:
  pushl $0
80107813:	6a 00                	push   $0x0
  pushl $217
80107815:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010781a:	e9 50 f2 ff ff       	jmp    80106a6f <alltraps>

8010781f <vector218>:
.globl vector218
vector218:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $218
80107821:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107826:	e9 44 f2 ff ff       	jmp    80106a6f <alltraps>

8010782b <vector219>:
.globl vector219
vector219:
  pushl $0
8010782b:	6a 00                	push   $0x0
  pushl $219
8010782d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107832:	e9 38 f2 ff ff       	jmp    80106a6f <alltraps>

80107837 <vector220>:
.globl vector220
vector220:
  pushl $0
80107837:	6a 00                	push   $0x0
  pushl $220
80107839:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010783e:	e9 2c f2 ff ff       	jmp    80106a6f <alltraps>

80107843 <vector221>:
.globl vector221
vector221:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $221
80107845:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010784a:	e9 20 f2 ff ff       	jmp    80106a6f <alltraps>

8010784f <vector222>:
.globl vector222
vector222:
  pushl $0
8010784f:	6a 00                	push   $0x0
  pushl $222
80107851:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107856:	e9 14 f2 ff ff       	jmp    80106a6f <alltraps>

8010785b <vector223>:
.globl vector223
vector223:
  pushl $0
8010785b:	6a 00                	push   $0x0
  pushl $223
8010785d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107862:	e9 08 f2 ff ff       	jmp    80106a6f <alltraps>

80107867 <vector224>:
.globl vector224
vector224:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $224
80107869:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010786e:	e9 fc f1 ff ff       	jmp    80106a6f <alltraps>

80107873 <vector225>:
.globl vector225
vector225:
  pushl $0
80107873:	6a 00                	push   $0x0
  pushl $225
80107875:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010787a:	e9 f0 f1 ff ff       	jmp    80106a6f <alltraps>

8010787f <vector226>:
.globl vector226
vector226:
  pushl $0
8010787f:	6a 00                	push   $0x0
  pushl $226
80107881:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107886:	e9 e4 f1 ff ff       	jmp    80106a6f <alltraps>

8010788b <vector227>:
.globl vector227
vector227:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $227
8010788d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107892:	e9 d8 f1 ff ff       	jmp    80106a6f <alltraps>

80107897 <vector228>:
.globl vector228
vector228:
  pushl $0
80107897:	6a 00                	push   $0x0
  pushl $228
80107899:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010789e:	e9 cc f1 ff ff       	jmp    80106a6f <alltraps>

801078a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801078a3:	6a 00                	push   $0x0
  pushl $229
801078a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801078aa:	e9 c0 f1 ff ff       	jmp    80106a6f <alltraps>

801078af <vector230>:
.globl vector230
vector230:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $230
801078b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801078b6:	e9 b4 f1 ff ff       	jmp    80106a6f <alltraps>

801078bb <vector231>:
.globl vector231
vector231:
  pushl $0
801078bb:	6a 00                	push   $0x0
  pushl $231
801078bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801078c2:	e9 a8 f1 ff ff       	jmp    80106a6f <alltraps>

801078c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801078c7:	6a 00                	push   $0x0
  pushl $232
801078c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801078ce:	e9 9c f1 ff ff       	jmp    80106a6f <alltraps>

801078d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801078d3:	6a 00                	push   $0x0
  pushl $233
801078d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801078da:	e9 90 f1 ff ff       	jmp    80106a6f <alltraps>

801078df <vector234>:
.globl vector234
vector234:
  pushl $0
801078df:	6a 00                	push   $0x0
  pushl $234
801078e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801078e6:	e9 84 f1 ff ff       	jmp    80106a6f <alltraps>

801078eb <vector235>:
.globl vector235
vector235:
  pushl $0
801078eb:	6a 00                	push   $0x0
  pushl $235
801078ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801078f2:	e9 78 f1 ff ff       	jmp    80106a6f <alltraps>

801078f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801078f7:	6a 00                	push   $0x0
  pushl $236
801078f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801078fe:	e9 6c f1 ff ff       	jmp    80106a6f <alltraps>

80107903 <vector237>:
.globl vector237
vector237:
  pushl $0
80107903:	6a 00                	push   $0x0
  pushl $237
80107905:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010790a:	e9 60 f1 ff ff       	jmp    80106a6f <alltraps>

8010790f <vector238>:
.globl vector238
vector238:
  pushl $0
8010790f:	6a 00                	push   $0x0
  pushl $238
80107911:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107916:	e9 54 f1 ff ff       	jmp    80106a6f <alltraps>

8010791b <vector239>:
.globl vector239
vector239:
  pushl $0
8010791b:	6a 00                	push   $0x0
  pushl $239
8010791d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107922:	e9 48 f1 ff ff       	jmp    80106a6f <alltraps>

80107927 <vector240>:
.globl vector240
vector240:
  pushl $0
80107927:	6a 00                	push   $0x0
  pushl $240
80107929:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010792e:	e9 3c f1 ff ff       	jmp    80106a6f <alltraps>

80107933 <vector241>:
.globl vector241
vector241:
  pushl $0
80107933:	6a 00                	push   $0x0
  pushl $241
80107935:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010793a:	e9 30 f1 ff ff       	jmp    80106a6f <alltraps>

8010793f <vector242>:
.globl vector242
vector242:
  pushl $0
8010793f:	6a 00                	push   $0x0
  pushl $242
80107941:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107946:	e9 24 f1 ff ff       	jmp    80106a6f <alltraps>

8010794b <vector243>:
.globl vector243
vector243:
  pushl $0
8010794b:	6a 00                	push   $0x0
  pushl $243
8010794d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107952:	e9 18 f1 ff ff       	jmp    80106a6f <alltraps>

80107957 <vector244>:
.globl vector244
vector244:
  pushl $0
80107957:	6a 00                	push   $0x0
  pushl $244
80107959:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010795e:	e9 0c f1 ff ff       	jmp    80106a6f <alltraps>

80107963 <vector245>:
.globl vector245
vector245:
  pushl $0
80107963:	6a 00                	push   $0x0
  pushl $245
80107965:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010796a:	e9 00 f1 ff ff       	jmp    80106a6f <alltraps>

8010796f <vector246>:
.globl vector246
vector246:
  pushl $0
8010796f:	6a 00                	push   $0x0
  pushl $246
80107971:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107976:	e9 f4 f0 ff ff       	jmp    80106a6f <alltraps>

8010797b <vector247>:
.globl vector247
vector247:
  pushl $0
8010797b:	6a 00                	push   $0x0
  pushl $247
8010797d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107982:	e9 e8 f0 ff ff       	jmp    80106a6f <alltraps>

80107987 <vector248>:
.globl vector248
vector248:
  pushl $0
80107987:	6a 00                	push   $0x0
  pushl $248
80107989:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010798e:	e9 dc f0 ff ff       	jmp    80106a6f <alltraps>

80107993 <vector249>:
.globl vector249
vector249:
  pushl $0
80107993:	6a 00                	push   $0x0
  pushl $249
80107995:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010799a:	e9 d0 f0 ff ff       	jmp    80106a6f <alltraps>

8010799f <vector250>:
.globl vector250
vector250:
  pushl $0
8010799f:	6a 00                	push   $0x0
  pushl $250
801079a1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801079a6:	e9 c4 f0 ff ff       	jmp    80106a6f <alltraps>

801079ab <vector251>:
.globl vector251
vector251:
  pushl $0
801079ab:	6a 00                	push   $0x0
  pushl $251
801079ad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801079b2:	e9 b8 f0 ff ff       	jmp    80106a6f <alltraps>

801079b7 <vector252>:
.globl vector252
vector252:
  pushl $0
801079b7:	6a 00                	push   $0x0
  pushl $252
801079b9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801079be:	e9 ac f0 ff ff       	jmp    80106a6f <alltraps>

801079c3 <vector253>:
.globl vector253
vector253:
  pushl $0
801079c3:	6a 00                	push   $0x0
  pushl $253
801079c5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801079ca:	e9 a0 f0 ff ff       	jmp    80106a6f <alltraps>

801079cf <vector254>:
.globl vector254
vector254:
  pushl $0
801079cf:	6a 00                	push   $0x0
  pushl $254
801079d1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801079d6:	e9 94 f0 ff ff       	jmp    80106a6f <alltraps>

801079db <vector255>:
.globl vector255
vector255:
  pushl $0
801079db:	6a 00                	push   $0x0
  pushl $255
801079dd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801079e2:	e9 88 f0 ff ff       	jmp    80106a6f <alltraps>
801079e7:	66 90                	xchg   %ax,%ax
801079e9:	66 90                	xchg   %ax,%ax
801079eb:	66 90                	xchg   %ax,%ax
801079ed:	66 90                	xchg   %ax,%ax
801079ef:	90                   	nop

801079f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801079f0:	55                   	push   %ebp
801079f1:	89 e5                	mov    %esp,%ebp
801079f3:	57                   	push   %edi
801079f4:	56                   	push   %esi
801079f5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801079f6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801079fc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107a02:	83 ec 1c             	sub    $0x1c,%esp
80107a05:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107a08:	39 d3                	cmp    %edx,%ebx
80107a0a:	73 49                	jae    80107a55 <deallocuvm.part.0+0x65>
80107a0c:	89 c7                	mov    %eax,%edi
80107a0e:	eb 0c                	jmp    80107a1c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107a10:	83 c0 01             	add    $0x1,%eax
80107a13:	c1 e0 16             	shl    $0x16,%eax
80107a16:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107a18:	39 da                	cmp    %ebx,%edx
80107a1a:	76 39                	jbe    80107a55 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80107a1c:	89 d8                	mov    %ebx,%eax
80107a1e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107a21:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107a24:	f6 c1 01             	test   $0x1,%cl
80107a27:	74 e7                	je     80107a10 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107a29:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a2b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107a31:	c1 ee 0a             	shr    $0xa,%esi
80107a34:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80107a3a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107a41:	85 f6                	test   %esi,%esi
80107a43:	74 cb                	je     80107a10 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107a45:	8b 06                	mov    (%esi),%eax
80107a47:	a8 01                	test   $0x1,%al
80107a49:	75 15                	jne    80107a60 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80107a4b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a51:	39 da                	cmp    %ebx,%edx
80107a53:	77 c7                	ja     80107a1c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107a55:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a5b:	5b                   	pop    %ebx
80107a5c:	5e                   	pop    %esi
80107a5d:	5f                   	pop    %edi
80107a5e:	5d                   	pop    %ebp
80107a5f:	c3                   	ret    
      if(pa == 0)
80107a60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a65:	74 25                	je     80107a8c <deallocuvm.part.0+0x9c>
      kfree(v);
80107a67:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107a6a:	05 00 00 00 80       	add    $0x80000000,%eax
80107a6f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107a72:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107a78:	50                   	push   %eax
80107a79:	e8 42 aa ff ff       	call   801024c0 <kfree>
      *pte = 0;
80107a7e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107a84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107a87:	83 c4 10             	add    $0x10,%esp
80107a8a:	eb 8c                	jmp    80107a18 <deallocuvm.part.0+0x28>
        panic("kfree");
80107a8c:	83 ec 0c             	sub    $0xc,%esp
80107a8f:	68 86 87 10 80       	push   $0x80108786
80107a94:	e8 e7 88 ff ff       	call   80100380 <panic>
80107a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107aa0 <mappages>:
{
80107aa0:	55                   	push   %ebp
80107aa1:	89 e5                	mov    %esp,%ebp
80107aa3:	57                   	push   %edi
80107aa4:	56                   	push   %esi
80107aa5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107aa6:	89 d3                	mov    %edx,%ebx
80107aa8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80107aae:	83 ec 1c             	sub    $0x1c,%esp
80107ab1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107ab4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107ab8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107abd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107ac0:	8b 45 08             	mov    0x8(%ebp),%eax
80107ac3:	29 d8                	sub    %ebx,%eax
80107ac5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ac8:	eb 3d                	jmp    80107b07 <mappages+0x67>
80107aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107ad0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107ad2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107ad7:	c1 ea 0a             	shr    $0xa,%edx
80107ada:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107ae0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107ae7:	85 c0                	test   %eax,%eax
80107ae9:	74 75                	je     80107b60 <mappages+0xc0>
    if(*pte & PTE_P)
80107aeb:	f6 00 01             	testb  $0x1,(%eax)
80107aee:	0f 85 86 00 00 00    	jne    80107b7a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107af4:	0b 75 0c             	or     0xc(%ebp),%esi
80107af7:	83 ce 01             	or     $0x1,%esi
80107afa:	89 30                	mov    %esi,(%eax)
    if(a == last)
80107afc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80107aff:	74 6f                	je     80107b70 <mappages+0xd0>
    a += PGSIZE;
80107b01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107b07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80107b0a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107b0d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107b10:	89 d8                	mov    %ebx,%eax
80107b12:	c1 e8 16             	shr    $0x16,%eax
80107b15:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107b18:	8b 07                	mov    (%edi),%eax
80107b1a:	a8 01                	test   $0x1,%al
80107b1c:	75 b2                	jne    80107ad0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107b1e:	e8 5d ab ff ff       	call   80102680 <kalloc>
80107b23:	85 c0                	test   %eax,%eax
80107b25:	74 39                	je     80107b60 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107b27:	83 ec 04             	sub    $0x4,%esp
80107b2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107b2d:	68 00 10 00 00       	push   $0x1000
80107b32:	6a 00                	push   $0x0
80107b34:	50                   	push   %eax
80107b35:	e8 36 d7 ff ff       	call   80105270 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107b3a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80107b3d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107b40:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107b46:	83 c8 07             	or     $0x7,%eax
80107b49:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80107b4b:	89 d8                	mov    %ebx,%eax
80107b4d:	c1 e8 0a             	shr    $0xa,%eax
80107b50:	25 fc 0f 00 00       	and    $0xffc,%eax
80107b55:	01 d0                	add    %edx,%eax
80107b57:	eb 92                	jmp    80107aeb <mappages+0x4b>
80107b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107b63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b68:	5b                   	pop    %ebx
80107b69:	5e                   	pop    %esi
80107b6a:	5f                   	pop    %edi
80107b6b:	5d                   	pop    %ebp
80107b6c:	c3                   	ret    
80107b6d:	8d 76 00             	lea    0x0(%esi),%esi
80107b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b73:	31 c0                	xor    %eax,%eax
}
80107b75:	5b                   	pop    %ebx
80107b76:	5e                   	pop    %esi
80107b77:	5f                   	pop    %edi
80107b78:	5d                   	pop    %ebp
80107b79:	c3                   	ret    
      panic("remap");
80107b7a:	83 ec 0c             	sub    $0xc,%esp
80107b7d:	68 48 8f 10 80       	push   $0x80108f48
80107b82:	e8 f9 87 ff ff       	call   80100380 <panic>
80107b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b8e:	66 90                	xchg   %ax,%ax

80107b90 <seginit>:
{
80107b90:	55                   	push   %ebp
80107b91:	89 e5                	mov    %esp,%ebp
80107b93:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107b96:	e8 55 be ff ff       	call   801039f0 <cpuid>
  pd[0] = size-1;
80107b9b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107ba0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107ba6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107baa:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
80107bb1:	ff 00 00 
80107bb4:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
80107bbb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107bbe:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
80107bc5:	ff 00 00 
80107bc8:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
80107bcf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107bd2:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80107bd9:	ff 00 00 
80107bdc:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80107be3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107be6:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
80107bed:	ff 00 00 
80107bf0:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80107bf7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107bfa:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
80107bff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107c03:	c1 e8 10             	shr    $0x10,%eax
80107c06:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107c0a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107c0d:	0f 01 10             	lgdtl  (%eax)
}
80107c10:	c9                   	leave  
80107c11:	c3                   	ret    
80107c12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107c20 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107c20:	a1 44 70 11 80       	mov    0x80117044,%eax
80107c25:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107c2a:	0f 22 d8             	mov    %eax,%cr3
}
80107c2d:	c3                   	ret    
80107c2e:	66 90                	xchg   %ax,%ax

80107c30 <switchuvm>:
{
80107c30:	55                   	push   %ebp
80107c31:	89 e5                	mov    %esp,%ebp
80107c33:	57                   	push   %edi
80107c34:	56                   	push   %esi
80107c35:	53                   	push   %ebx
80107c36:	83 ec 1c             	sub    $0x1c,%esp
80107c39:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107c3c:	85 f6                	test   %esi,%esi
80107c3e:	0f 84 cb 00 00 00    	je     80107d0f <switchuvm+0xdf>
  if(p->kstack == 0)
80107c44:	8b 46 08             	mov    0x8(%esi),%eax
80107c47:	85 c0                	test   %eax,%eax
80107c49:	0f 84 da 00 00 00    	je     80107d29 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107c4f:	8b 46 04             	mov    0x4(%esi),%eax
80107c52:	85 c0                	test   %eax,%eax
80107c54:	0f 84 c2 00 00 00    	je     80107d1c <switchuvm+0xec>
  pushcli();
80107c5a:	e8 01 d4 ff ff       	call   80105060 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107c5f:	e8 2c bd ff ff       	call   80103990 <mycpu>
80107c64:	89 c3                	mov    %eax,%ebx
80107c66:	e8 25 bd ff ff       	call   80103990 <mycpu>
80107c6b:	89 c7                	mov    %eax,%edi
80107c6d:	e8 1e bd ff ff       	call   80103990 <mycpu>
80107c72:	83 c7 08             	add    $0x8,%edi
80107c75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c78:	e8 13 bd ff ff       	call   80103990 <mycpu>
80107c7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107c80:	ba 67 00 00 00       	mov    $0x67,%edx
80107c85:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107c8c:	83 c0 08             	add    $0x8,%eax
80107c8f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107c96:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107c9b:	83 c1 08             	add    $0x8,%ecx
80107c9e:	c1 e8 18             	shr    $0x18,%eax
80107ca1:	c1 e9 10             	shr    $0x10,%ecx
80107ca4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107caa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107cb0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107cb5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107cbc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107cc1:	e8 ca bc ff ff       	call   80103990 <mycpu>
80107cc6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107ccd:	e8 be bc ff ff       	call   80103990 <mycpu>
80107cd2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107cd6:	8b 5e 08             	mov    0x8(%esi),%ebx
80107cd9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107cdf:	e8 ac bc ff ff       	call   80103990 <mycpu>
80107ce4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107ce7:	e8 a4 bc ff ff       	call   80103990 <mycpu>
80107cec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107cf0:	b8 28 00 00 00       	mov    $0x28,%eax
80107cf5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107cf8:	8b 46 04             	mov    0x4(%esi),%eax
80107cfb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107d00:	0f 22 d8             	mov    %eax,%cr3
}
80107d03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d06:	5b                   	pop    %ebx
80107d07:	5e                   	pop    %esi
80107d08:	5f                   	pop    %edi
80107d09:	5d                   	pop    %ebp
  popcli();
80107d0a:	e9 a1 d3 ff ff       	jmp    801050b0 <popcli>
    panic("switchuvm: no process");
80107d0f:	83 ec 0c             	sub    $0xc,%esp
80107d12:	68 4e 8f 10 80       	push   $0x80108f4e
80107d17:	e8 64 86 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80107d1c:	83 ec 0c             	sub    $0xc,%esp
80107d1f:	68 79 8f 10 80       	push   $0x80108f79
80107d24:	e8 57 86 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107d29:	83 ec 0c             	sub    $0xc,%esp
80107d2c:	68 64 8f 10 80       	push   $0x80108f64
80107d31:	e8 4a 86 ff ff       	call   80100380 <panic>
80107d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d3d:	8d 76 00             	lea    0x0(%esi),%esi

80107d40 <inituvm>:
{
80107d40:	55                   	push   %ebp
80107d41:	89 e5                	mov    %esp,%ebp
80107d43:	57                   	push   %edi
80107d44:	56                   	push   %esi
80107d45:	53                   	push   %ebx
80107d46:	83 ec 1c             	sub    $0x1c,%esp
80107d49:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d4c:	8b 75 10             	mov    0x10(%ebp),%esi
80107d4f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107d52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107d55:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107d5b:	77 4b                	ja     80107da8 <inituvm+0x68>
  mem = kalloc();
80107d5d:	e8 1e a9 ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80107d62:	83 ec 04             	sub    $0x4,%esp
80107d65:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107d6a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107d6c:	6a 00                	push   $0x0
80107d6e:	50                   	push   %eax
80107d6f:	e8 fc d4 ff ff       	call   80105270 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107d74:	58                   	pop    %eax
80107d75:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107d7b:	5a                   	pop    %edx
80107d7c:	6a 06                	push   $0x6
80107d7e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d83:	31 d2                	xor    %edx,%edx
80107d85:	50                   	push   %eax
80107d86:	89 f8                	mov    %edi,%eax
80107d88:	e8 13 fd ff ff       	call   80107aa0 <mappages>
  memmove(mem, init, sz);
80107d8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d90:	89 75 10             	mov    %esi,0x10(%ebp)
80107d93:	83 c4 10             	add    $0x10,%esp
80107d96:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107d99:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d9f:	5b                   	pop    %ebx
80107da0:	5e                   	pop    %esi
80107da1:	5f                   	pop    %edi
80107da2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107da3:	e9 68 d5 ff ff       	jmp    80105310 <memmove>
    panic("inituvm: more than a page");
80107da8:	83 ec 0c             	sub    $0xc,%esp
80107dab:	68 8d 8f 10 80       	push   $0x80108f8d
80107db0:	e8 cb 85 ff ff       	call   80100380 <panic>
80107db5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107dc0 <loaduvm>:
{
80107dc0:	55                   	push   %ebp
80107dc1:	89 e5                	mov    %esp,%ebp
80107dc3:	57                   	push   %edi
80107dc4:	56                   	push   %esi
80107dc5:	53                   	push   %ebx
80107dc6:	83 ec 1c             	sub    $0x1c,%esp
80107dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dcc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107dcf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107dd4:	0f 85 bb 00 00 00    	jne    80107e95 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80107dda:	01 f0                	add    %esi,%eax
80107ddc:	89 f3                	mov    %esi,%ebx
80107dde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107de1:	8b 45 14             	mov    0x14(%ebp),%eax
80107de4:	01 f0                	add    %esi,%eax
80107de6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107de9:	85 f6                	test   %esi,%esi
80107deb:	0f 84 87 00 00 00    	je     80107e78 <loaduvm+0xb8>
80107df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107df8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80107dfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107dfe:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107e00:	89 c2                	mov    %eax,%edx
80107e02:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107e05:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107e08:	f6 c2 01             	test   $0x1,%dl
80107e0b:	75 13                	jne    80107e20 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80107e0d:	83 ec 0c             	sub    $0xc,%esp
80107e10:	68 a7 8f 10 80       	push   $0x80108fa7
80107e15:	e8 66 85 ff ff       	call   80100380 <panic>
80107e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107e20:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107e23:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107e29:	25 fc 0f 00 00       	and    $0xffc,%eax
80107e2e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107e35:	85 c0                	test   %eax,%eax
80107e37:	74 d4                	je     80107e0d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107e39:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107e3b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107e3e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107e43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107e48:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107e4e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107e51:	29 d9                	sub    %ebx,%ecx
80107e53:	05 00 00 00 80       	add    $0x80000000,%eax
80107e58:	57                   	push   %edi
80107e59:	51                   	push   %ecx
80107e5a:	50                   	push   %eax
80107e5b:	ff 75 10             	push   0x10(%ebp)
80107e5e:	e8 2d 9c ff ff       	call   80101a90 <readi>
80107e63:	83 c4 10             	add    $0x10,%esp
80107e66:	39 f8                	cmp    %edi,%eax
80107e68:	75 1e                	jne    80107e88 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107e6a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107e70:	89 f0                	mov    %esi,%eax
80107e72:	29 d8                	sub    %ebx,%eax
80107e74:	39 c6                	cmp    %eax,%esi
80107e76:	77 80                	ja     80107df8 <loaduvm+0x38>
}
80107e78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107e7b:	31 c0                	xor    %eax,%eax
}
80107e7d:	5b                   	pop    %ebx
80107e7e:	5e                   	pop    %esi
80107e7f:	5f                   	pop    %edi
80107e80:	5d                   	pop    %ebp
80107e81:	c3                   	ret    
80107e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107e88:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107e8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107e90:	5b                   	pop    %ebx
80107e91:	5e                   	pop    %esi
80107e92:	5f                   	pop    %edi
80107e93:	5d                   	pop    %ebp
80107e94:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107e95:	83 ec 0c             	sub    $0xc,%esp
80107e98:	68 48 90 10 80       	push   $0x80109048
80107e9d:	e8 de 84 ff ff       	call   80100380 <panic>
80107ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107eb0 <allocuvm>:
{
80107eb0:	55                   	push   %ebp
80107eb1:	89 e5                	mov    %esp,%ebp
80107eb3:	57                   	push   %edi
80107eb4:	56                   	push   %esi
80107eb5:	53                   	push   %ebx
80107eb6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= HEAPLIMIT)
80107eb9:	81 7d 10 ff ff ff 6f 	cmpl   $0x6fffffff,0x10(%ebp)
{
80107ec0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= HEAPLIMIT)
80107ec3:	0f 87 b7 00 00 00    	ja     80107f80 <allocuvm+0xd0>
  if(newsz < oldsz)
80107ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ecc:	39 45 10             	cmp    %eax,0x10(%ebp)
80107ecf:	0f 82 ad 00 00 00    	jb     80107f82 <allocuvm+0xd2>
  a = PGROUNDUP(oldsz);
80107ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ed8:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107ede:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107ee4:	39 75 10             	cmp    %esi,0x10(%ebp)
80107ee7:	0f 86 a3 00 00 00    	jbe    80107f90 <allocuvm+0xe0>
80107eed:	8b 45 10             	mov    0x10(%ebp),%eax
80107ef0:	83 e8 01             	sub    $0x1,%eax
80107ef3:	29 f0                	sub    %esi,%eax
80107ef5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107efa:	8d 84 06 00 10 00 00 	lea    0x1000(%esi,%eax,1),%eax
80107f01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107f04:	eb 45                	jmp    80107f4b <allocuvm+0x9b>
80107f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f0d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107f10:	83 ec 04             	sub    $0x4,%esp
80107f13:	68 00 10 00 00       	push   $0x1000
80107f18:	6a 00                	push   $0x0
80107f1a:	50                   	push   %eax
80107f1b:	e8 50 d3 ff ff       	call   80105270 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107f20:	58                   	pop    %eax
80107f21:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107f27:	5a                   	pop    %edx
80107f28:	6a 06                	push   $0x6
80107f2a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f2f:	89 f2                	mov    %esi,%edx
80107f31:	50                   	push   %eax
80107f32:	89 f8                	mov    %edi,%eax
80107f34:	e8 67 fb ff ff       	call   80107aa0 <mappages>
80107f39:	83 c4 10             	add    $0x10,%esp
80107f3c:	85 c0                	test   %eax,%eax
80107f3e:	78 60                	js     80107fa0 <allocuvm+0xf0>
  for(; a < newsz; a += PGSIZE){
80107f40:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107f46:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
80107f49:	74 45                	je     80107f90 <allocuvm+0xe0>
    mem = kalloc();
80107f4b:	e8 30 a7 ff ff       	call   80102680 <kalloc>
80107f50:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107f52:	85 c0                	test   %eax,%eax
80107f54:	75 ba                	jne    80107f10 <allocuvm+0x60>
      cprintf("allocuvm out of memory\n");
80107f56:	83 ec 0c             	sub    $0xc,%esp
80107f59:	68 c5 8f 10 80       	push   $0x80108fc5
80107f5e:	e8 3d 87 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107f63:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f66:	83 c4 10             	add    $0x10,%esp
80107f69:	39 45 10             	cmp    %eax,0x10(%ebp)
80107f6c:	74 12                	je     80107f80 <allocuvm+0xd0>
80107f6e:	8b 55 10             	mov    0x10(%ebp),%edx
80107f71:	89 c1                	mov    %eax,%ecx
80107f73:	89 f8                	mov    %edi,%eax
80107f75:	e8 76 fa ff ff       	call   801079f0 <deallocuvm.part.0>
80107f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return 0;
80107f80:	31 c0                	xor    %eax,%eax
}
80107f82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f85:	5b                   	pop    %ebx
80107f86:	5e                   	pop    %esi
80107f87:	5f                   	pop    %edi
80107f88:	5d                   	pop    %ebp
80107f89:	c3                   	ret    
80107f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return newsz;
80107f90:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107f93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f96:	5b                   	pop    %ebx
80107f97:	5e                   	pop    %esi
80107f98:	5f                   	pop    %edi
80107f99:	5d                   	pop    %ebp
80107f9a:	c3                   	ret    
80107f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107f9f:	90                   	nop
      cprintf("allocuvm out of memory (2)\n");
80107fa0:	83 ec 0c             	sub    $0xc,%esp
80107fa3:	68 dd 8f 10 80       	push   $0x80108fdd
80107fa8:	e8 f3 86 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107fad:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fb0:	83 c4 10             	add    $0x10,%esp
80107fb3:	39 45 10             	cmp    %eax,0x10(%ebp)
80107fb6:	74 0c                	je     80107fc4 <allocuvm+0x114>
80107fb8:	8b 55 10             	mov    0x10(%ebp),%edx
80107fbb:	89 c1                	mov    %eax,%ecx
80107fbd:	89 f8                	mov    %edi,%eax
80107fbf:	e8 2c fa ff ff       	call   801079f0 <deallocuvm.part.0>
      kfree(mem);
80107fc4:	83 ec 0c             	sub    $0xc,%esp
80107fc7:	53                   	push   %ebx
80107fc8:	e8 f3 a4 ff ff       	call   801024c0 <kfree>
      return 0;
80107fcd:	83 c4 10             	add    $0x10,%esp
}
80107fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107fd3:	31 c0                	xor    %eax,%eax
}
80107fd5:	5b                   	pop    %ebx
80107fd6:	5e                   	pop    %esi
80107fd7:	5f                   	pop    %edi
80107fd8:	5d                   	pop    %ebp
80107fd9:	c3                   	ret    
80107fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107fe0 <allocsharedmem>:
{
80107fe0:	55                   	push   %ebp
80107fe1:	89 e5                	mov    %esp,%ebp
80107fe3:	57                   	push   %edi
80107fe4:	56                   	push   %esi
80107fe5:	53                   	push   %ebx
80107fe6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107fe9:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107fec:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107fef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107ff2:	85 c0                	test   %eax,%eax
80107ff4:	0f 88 b6 00 00 00    	js     801080b0 <allocsharedmem+0xd0>
  if(newsz < oldsz)
80107ffa:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80108000:	0f 82 9a 00 00 00    	jb     801080a0 <allocsharedmem+0xc0>
  a = PGROUNDUP(oldsz);
80108006:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010800c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80108012:	39 75 10             	cmp    %esi,0x10(%ebp)
80108015:	77 44                	ja     8010805b <allocsharedmem+0x7b>
80108017:	e9 87 00 00 00       	jmp    801080a3 <allocsharedmem+0xc3>
8010801c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80108020:	83 ec 04             	sub    $0x4,%esp
80108023:	68 00 10 00 00       	push   $0x1000
80108028:	6a 00                	push   $0x0
8010802a:	50                   	push   %eax
8010802b:	e8 40 d2 ff ff       	call   80105270 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108030:	58                   	pop    %eax
80108031:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108037:	5a                   	pop    %edx
80108038:	6a 06                	push   $0x6
8010803a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010803f:	89 f2                	mov    %esi,%edx
80108041:	50                   	push   %eax
80108042:	89 f8                	mov    %edi,%eax
80108044:	e8 57 fa ff ff       	call   80107aa0 <mappages>
80108049:	83 c4 10             	add    $0x10,%esp
8010804c:	85 c0                	test   %eax,%eax
8010804e:	78 78                	js     801080c8 <allocsharedmem+0xe8>
  for(; a < newsz; a += PGSIZE){
80108050:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108056:	39 75 10             	cmp    %esi,0x10(%ebp)
80108059:	76 48                	jbe    801080a3 <allocsharedmem+0xc3>
    mem = kalloc();
8010805b:	e8 20 a6 ff ff       	call   80102680 <kalloc>
80108060:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80108062:	85 c0                	test   %eax,%eax
80108064:	75 ba                	jne    80108020 <allocsharedmem+0x40>
      cprintf("allocuvm out of memory\n");
80108066:	83 ec 0c             	sub    $0xc,%esp
80108069:	68 c5 8f 10 80       	push   $0x80108fc5
8010806e:	e8 2d 86 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80108073:	8b 45 0c             	mov    0xc(%ebp),%eax
80108076:	83 c4 10             	add    $0x10,%esp
80108079:	39 45 10             	cmp    %eax,0x10(%ebp)
8010807c:	74 32                	je     801080b0 <allocsharedmem+0xd0>
8010807e:	8b 55 10             	mov    0x10(%ebp),%edx
80108081:	89 c1                	mov    %eax,%ecx
80108083:	89 f8                	mov    %edi,%eax
80108085:	e8 66 f9 ff ff       	call   801079f0 <deallocuvm.part.0>
      return 0;
8010808a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108091:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108094:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108097:	5b                   	pop    %ebx
80108098:	5e                   	pop    %esi
80108099:	5f                   	pop    %edi
8010809a:	5d                   	pop    %ebp
8010809b:	c3                   	ret    
8010809c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801080a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801080a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080a9:	5b                   	pop    %ebx
801080aa:	5e                   	pop    %esi
801080ab:	5f                   	pop    %edi
801080ac:	5d                   	pop    %ebp
801080ad:	c3                   	ret    
801080ae:	66 90                	xchg   %ax,%ax
    return 0;
801080b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801080b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080bd:	5b                   	pop    %ebx
801080be:	5e                   	pop    %esi
801080bf:	5f                   	pop    %edi
801080c0:	5d                   	pop    %ebp
801080c1:	c3                   	ret    
801080c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801080c8:	83 ec 0c             	sub    $0xc,%esp
801080cb:	68 dd 8f 10 80       	push   $0x80108fdd
801080d0:	e8 cb 85 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801080d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801080d8:	83 c4 10             	add    $0x10,%esp
801080db:	39 45 10             	cmp    %eax,0x10(%ebp)
801080de:	74 0c                	je     801080ec <allocsharedmem+0x10c>
801080e0:	8b 55 10             	mov    0x10(%ebp),%edx
801080e3:	89 c1                	mov    %eax,%ecx
801080e5:	89 f8                	mov    %edi,%eax
801080e7:	e8 04 f9 ff ff       	call   801079f0 <deallocuvm.part.0>
      kfree(mem);
801080ec:	83 ec 0c             	sub    $0xc,%esp
801080ef:	53                   	push   %ebx
801080f0:	e8 cb a3 ff ff       	call   801024c0 <kfree>
      return 0;
801080f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801080fc:	83 c4 10             	add    $0x10,%esp
}
801080ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108102:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108105:	5b                   	pop    %ebx
80108106:	5e                   	pop    %esi
80108107:	5f                   	pop    %edi
80108108:	5d                   	pop    %ebp
80108109:	c3                   	ret    
8010810a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108110 <deallocuvm>:
{
80108110:	55                   	push   %ebp
80108111:	89 e5                	mov    %esp,%ebp
80108113:	8b 55 0c             	mov    0xc(%ebp),%edx
80108116:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108119:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010811c:	39 d1                	cmp    %edx,%ecx
8010811e:	73 10                	jae    80108130 <deallocuvm+0x20>
}
80108120:	5d                   	pop    %ebp
80108121:	e9 ca f8 ff ff       	jmp    801079f0 <deallocuvm.part.0>
80108126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010812d:	8d 76 00             	lea    0x0(%esi),%esi
80108130:	89 d0                	mov    %edx,%eax
80108132:	5d                   	pop    %ebp
80108133:	c3                   	ret    
80108134:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010813b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010813f:	90                   	nop

80108140 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108140:	55                   	push   %ebp
80108141:	89 e5                	mov    %esp,%ebp
80108143:	57                   	push   %edi
80108144:	56                   	push   %esi
80108145:	53                   	push   %ebx
80108146:	83 ec 0c             	sub    $0xc,%esp
80108149:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010814c:	85 f6                	test   %esi,%esi
8010814e:	74 59                	je     801081a9 <freevm+0x69>
  if(newsz >= oldsz)
80108150:	31 c9                	xor    %ecx,%ecx
80108152:	ba 00 00 00 80       	mov    $0x80000000,%edx
80108157:	89 f0                	mov    %esi,%eax
80108159:	89 f3                	mov    %esi,%ebx
8010815b:	e8 90 f8 ff ff       	call   801079f0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108160:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80108166:	eb 0f                	jmp    80108177 <freevm+0x37>
80108168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010816f:	90                   	nop
80108170:	83 c3 04             	add    $0x4,%ebx
80108173:	39 df                	cmp    %ebx,%edi
80108175:	74 23                	je     8010819a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80108177:	8b 03                	mov    (%ebx),%eax
80108179:	a8 01                	test   $0x1,%al
8010817b:	74 f3                	je     80108170 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010817d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108182:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108185:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108188:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010818d:	50                   	push   %eax
8010818e:	e8 2d a3 ff ff       	call   801024c0 <kfree>
80108193:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108196:	39 df                	cmp    %ebx,%edi
80108198:	75 dd                	jne    80108177 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010819a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010819d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081a0:	5b                   	pop    %ebx
801081a1:	5e                   	pop    %esi
801081a2:	5f                   	pop    %edi
801081a3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801081a4:	e9 17 a3 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
801081a9:	83 ec 0c             	sub    $0xc,%esp
801081ac:	68 f9 8f 10 80       	push   $0x80108ff9
801081b1:	e8 ca 81 ff ff       	call   80100380 <panic>
801081b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081bd:	8d 76 00             	lea    0x0(%esi),%esi

801081c0 <setupkvm>:
{
801081c0:	55                   	push   %ebp
801081c1:	89 e5                	mov    %esp,%ebp
801081c3:	56                   	push   %esi
801081c4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801081c5:	e8 b6 a4 ff ff       	call   80102680 <kalloc>
801081ca:	89 c6                	mov    %eax,%esi
801081cc:	85 c0                	test   %eax,%eax
801081ce:	74 42                	je     80108212 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801081d0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801081d3:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
801081d8:	68 00 10 00 00       	push   $0x1000
801081dd:	6a 00                	push   $0x0
801081df:	50                   	push   %eax
801081e0:	e8 8b d0 ff ff       	call   80105270 <memset>
801081e5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801081e8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801081eb:	83 ec 08             	sub    $0x8,%esp
801081ee:	8b 4b 08             	mov    0x8(%ebx),%ecx
801081f1:	ff 73 0c             	push   0xc(%ebx)
801081f4:	8b 13                	mov    (%ebx),%edx
801081f6:	50                   	push   %eax
801081f7:	29 c1                	sub    %eax,%ecx
801081f9:	89 f0                	mov    %esi,%eax
801081fb:	e8 a0 f8 ff ff       	call   80107aa0 <mappages>
80108200:	83 c4 10             	add    $0x10,%esp
80108203:	85 c0                	test   %eax,%eax
80108205:	78 19                	js     80108220 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108207:	83 c3 10             	add    $0x10,%ebx
8010820a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80108210:	75 d6                	jne    801081e8 <setupkvm+0x28>
}
80108212:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108215:	89 f0                	mov    %esi,%eax
80108217:	5b                   	pop    %ebx
80108218:	5e                   	pop    %esi
80108219:	5d                   	pop    %ebp
8010821a:	c3                   	ret    
8010821b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010821f:	90                   	nop
      freevm(pgdir);
80108220:	83 ec 0c             	sub    $0xc,%esp
80108223:	56                   	push   %esi
      return 0;
80108224:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108226:	e8 15 ff ff ff       	call   80108140 <freevm>
      return 0;
8010822b:	83 c4 10             	add    $0x10,%esp
}
8010822e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108231:	89 f0                	mov    %esi,%eax
80108233:	5b                   	pop    %ebx
80108234:	5e                   	pop    %esi
80108235:	5d                   	pop    %ebp
80108236:	c3                   	ret    
80108237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010823e:	66 90                	xchg   %ax,%ax

80108240 <kvmalloc>:
{
80108240:	55                   	push   %ebp
80108241:	89 e5                	mov    %esp,%ebp
80108243:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108246:	e8 75 ff ff ff       	call   801081c0 <setupkvm>
8010824b:	a3 44 70 11 80       	mov    %eax,0x80117044
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108250:	05 00 00 00 80       	add    $0x80000000,%eax
80108255:	0f 22 d8             	mov    %eax,%cr3
}
80108258:	c9                   	leave  
80108259:	c3                   	ret    
8010825a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108260 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108260:	55                   	push   %ebp
80108261:	89 e5                	mov    %esp,%ebp
80108263:	83 ec 08             	sub    $0x8,%esp
80108266:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108269:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010826c:	89 c1                	mov    %eax,%ecx
8010826e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80108271:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108274:	f6 c2 01             	test   $0x1,%dl
80108277:	75 17                	jne    80108290 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80108279:	83 ec 0c             	sub    $0xc,%esp
8010827c:	68 0a 90 10 80       	push   $0x8010900a
80108281:	e8 fa 80 ff ff       	call   80100380 <panic>
80108286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010828d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108290:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108293:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80108299:	25 fc 0f 00 00       	and    $0xffc,%eax
8010829e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801082a5:	85 c0                	test   %eax,%eax
801082a7:	74 d0                	je     80108279 <clearpteu+0x19>
  *pte &= ~PTE_U;
801082a9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801082ac:	c9                   	leave  
801082ad:	c3                   	ret    
801082ae:	66 90                	xchg   %ax,%ax

801082b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801082b0:	55                   	push   %ebp
801082b1:	89 e5                	mov    %esp,%ebp
801082b3:	57                   	push   %edi
801082b4:	56                   	push   %esi
801082b5:	53                   	push   %ebx
801082b6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801082b9:	e8 02 ff ff ff       	call   801081c0 <setupkvm>
801082be:	89 45 e0             	mov    %eax,-0x20(%ebp)
801082c1:	85 c0                	test   %eax,%eax
801082c3:	0f 84 bd 00 00 00    	je     80108386 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801082c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801082cc:	85 c9                	test   %ecx,%ecx
801082ce:	0f 84 b2 00 00 00    	je     80108386 <copyuvm+0xd6>
801082d4:	31 f6                	xor    %esi,%esi
801082d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082dd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801082e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801082e3:	89 f0                	mov    %esi,%eax
801082e5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801082e8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801082eb:	a8 01                	test   $0x1,%al
801082ed:	75 11                	jne    80108300 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801082ef:	83 ec 0c             	sub    $0xc,%esp
801082f2:	68 14 90 10 80       	push   $0x80109014
801082f7:	e8 84 80 ff ff       	call   80100380 <panic>
801082fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80108300:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108302:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108307:	c1 ea 0a             	shr    $0xa,%edx
8010830a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108310:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108317:	85 c0                	test   %eax,%eax
80108319:	74 d4                	je     801082ef <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010831b:	8b 00                	mov    (%eax),%eax
8010831d:	a8 01                	test   $0x1,%al
8010831f:	0f 84 9f 00 00 00    	je     801083c4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80108325:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108327:	25 ff 0f 00 00       	and    $0xfff,%eax
8010832c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010832f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108335:	e8 46 a3 ff ff       	call   80102680 <kalloc>
8010833a:	89 c3                	mov    %eax,%ebx
8010833c:	85 c0                	test   %eax,%eax
8010833e:	74 64                	je     801083a4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108340:	83 ec 04             	sub    $0x4,%esp
80108343:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108349:	68 00 10 00 00       	push   $0x1000
8010834e:	57                   	push   %edi
8010834f:	50                   	push   %eax
80108350:	e8 bb cf ff ff       	call   80105310 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108355:	58                   	pop    %eax
80108356:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010835c:	5a                   	pop    %edx
8010835d:	ff 75 e4             	push   -0x1c(%ebp)
80108360:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108365:	89 f2                	mov    %esi,%edx
80108367:	50                   	push   %eax
80108368:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010836b:	e8 30 f7 ff ff       	call   80107aa0 <mappages>
80108370:	83 c4 10             	add    $0x10,%esp
80108373:	85 c0                	test   %eax,%eax
80108375:	78 21                	js     80108398 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108377:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010837d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108380:	0f 87 5a ff ff ff    	ja     801082e0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80108386:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108389:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010838c:	5b                   	pop    %ebx
8010838d:	5e                   	pop    %esi
8010838e:	5f                   	pop    %edi
8010838f:	5d                   	pop    %ebp
80108390:	c3                   	ret    
80108391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80108398:	83 ec 0c             	sub    $0xc,%esp
8010839b:	53                   	push   %ebx
8010839c:	e8 1f a1 ff ff       	call   801024c0 <kfree>
      goto bad;
801083a1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801083a4:	83 ec 0c             	sub    $0xc,%esp
801083a7:	ff 75 e0             	push   -0x20(%ebp)
801083aa:	e8 91 fd ff ff       	call   80108140 <freevm>
  return 0;
801083af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801083b6:	83 c4 10             	add    $0x10,%esp
}
801083b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801083bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083bf:	5b                   	pop    %ebx
801083c0:	5e                   	pop    %esi
801083c1:	5f                   	pop    %edi
801083c2:	5d                   	pop    %ebp
801083c3:	c3                   	ret    
      panic("copyuvm: page not present");
801083c4:	83 ec 0c             	sub    $0xc,%esp
801083c7:	68 2e 90 10 80       	push   $0x8010902e
801083cc:	e8 af 7f ff ff       	call   80100380 <panic>
801083d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083df:	90                   	nop

801083e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801083e0:	55                   	push   %ebp
801083e1:	89 e5                	mov    %esp,%ebp
801083e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801083e6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801083e9:	89 c1                	mov    %eax,%ecx
801083eb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801083ee:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801083f1:	f6 c2 01             	test   $0x1,%dl
801083f4:	0f 84 00 01 00 00    	je     801084fa <uva2ka.cold>
  return &pgtab[PTX(va)];
801083fa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801083fd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108403:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80108404:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80108409:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80108410:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108412:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108417:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010841a:	05 00 00 00 80       	add    $0x80000000,%eax
8010841f:	83 fa 05             	cmp    $0x5,%edx
80108422:	ba 00 00 00 00       	mov    $0x0,%edx
80108427:	0f 45 c2             	cmovne %edx,%eax
}
8010842a:	c3                   	ret    
8010842b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010842f:	90                   	nop

80108430 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108430:	55                   	push   %ebp
80108431:	89 e5                	mov    %esp,%ebp
80108433:	57                   	push   %edi
80108434:	56                   	push   %esi
80108435:	53                   	push   %ebx
80108436:	83 ec 0c             	sub    $0xc,%esp
80108439:	8b 75 14             	mov    0x14(%ebp),%esi
8010843c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010843f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108442:	85 f6                	test   %esi,%esi
80108444:	75 51                	jne    80108497 <copyout+0x67>
80108446:	e9 a5 00 00 00       	jmp    801084f0 <copyout+0xc0>
8010844b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010844f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80108450:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80108456:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010845c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80108462:	74 75                	je     801084d9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80108464:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108466:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80108469:	29 c3                	sub    %eax,%ebx
8010846b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108471:	39 f3                	cmp    %esi,%ebx
80108473:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80108476:	29 f8                	sub    %edi,%eax
80108478:	83 ec 04             	sub    $0x4,%esp
8010847b:	01 c1                	add    %eax,%ecx
8010847d:	53                   	push   %ebx
8010847e:	52                   	push   %edx
8010847f:	51                   	push   %ecx
80108480:	e8 8b ce ff ff       	call   80105310 <memmove>
    len -= n;
    buf += n;
80108485:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80108488:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010848e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80108491:	01 da                	add    %ebx,%edx
  while(len > 0){
80108493:	29 de                	sub    %ebx,%esi
80108495:	74 59                	je     801084f0 <copyout+0xc0>
  if(*pde & PTE_P){
80108497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010849a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010849c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010849e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801084a1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801084a7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801084aa:	f6 c1 01             	test   $0x1,%cl
801084ad:	0f 84 4e 00 00 00    	je     80108501 <copyout.cold>
  return &pgtab[PTX(va)];
801084b3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801084b5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801084bb:	c1 eb 0c             	shr    $0xc,%ebx
801084be:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801084c4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801084cb:	89 d9                	mov    %ebx,%ecx
801084cd:	83 e1 05             	and    $0x5,%ecx
801084d0:	83 f9 05             	cmp    $0x5,%ecx
801084d3:	0f 84 77 ff ff ff    	je     80108450 <copyout+0x20>
  }
  return 0;
}
801084d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801084dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801084e1:	5b                   	pop    %ebx
801084e2:	5e                   	pop    %esi
801084e3:	5f                   	pop    %edi
801084e4:	5d                   	pop    %ebp
801084e5:	c3                   	ret    
801084e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801084ed:	8d 76 00             	lea    0x0(%esi),%esi
801084f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801084f3:	31 c0                	xor    %eax,%eax
}
801084f5:	5b                   	pop    %ebx
801084f6:	5e                   	pop    %esi
801084f7:	5f                   	pop    %edi
801084f8:	5d                   	pop    %ebp
801084f9:	c3                   	ret    

801084fa <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801084fa:	a1 00 00 00 00       	mov    0x0,%eax
801084ff:	0f 0b                	ud2    

80108501 <copyout.cold>:
80108501:	a1 00 00 00 00       	mov    0x0,%eax
80108506:	0f 0b                	ud2    
