
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
8010004c:	68 20 7e 10 80       	push   $0x80107e20
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 05 4a 00 00       	call   80104a60 <initlock>
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
80100092:	68 27 7e 10 80       	push   $0x80107e27
80100097:	50                   	push   %eax
80100098:	e8 93 48 00 00       	call   80104930 <initsleeplock>
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
801000e4:	e8 47 4b 00 00       	call   80104c30 <acquire>
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
80100162:	e8 69 4a 00 00       	call   80104bd0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 47 00 00       	call   80104970 <acquiresleep>
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
801001a1:	68 2e 7e 10 80       	push   $0x80107e2e
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
801001be:	e8 4d 48 00 00       	call   80104a10 <holdingsleep>
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
801001dc:	68 3f 7e 10 80       	push   $0x80107e3f
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
801001ff:	e8 0c 48 00 00       	call   80104a10 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 bc 47 00 00       	call   801049d0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 10 4a 00 00       	call   80104c30 <acquire>
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
8010026c:	e9 5f 49 00 00       	jmp    80104bd0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 46 7e 10 80       	push   $0x80107e46
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
801002a0:	e8 8b 49 00 00       	call   80104c30 <acquire>
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
801002cd:	e8 ae 43 00 00       	call   80104680 <sleep>
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
801002f6:	e8 d5 48 00 00       	call   80104bd0 <release>
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
8010034c:	e8 7f 48 00 00       	call   80104bd0 <release>
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
801003a2:	68 4d 7e 10 80       	push   $0x80107e4d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 af 88 10 80 	movl   $0x801088af,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 b3 46 00 00       	call   80104a80 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 61 7e 10 80       	push   $0x80107e61
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
8010041a:	e8 11 65 00 00       	call   80106930 <uartputc>
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
80100505:	e8 26 64 00 00       	call   80106930 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 1a 64 00 00       	call   80106930 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 0e 64 00 00       	call   80106930 <uartputc>
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
80100551:	e8 3a 48 00 00       	call   80104d90 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 85 47 00 00       	call   80104cf0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 65 7e 10 80       	push   $0x80107e65
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
801005ab:	e8 80 46 00 00       	call   80104c30 <acquire>
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
801005e4:	e8 e7 45 00 00       	call   80104bd0 <release>
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
80100636:	0f b6 92 90 7e 10 80 	movzbl -0x7fef8170(%edx),%edx
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
801007e8:	e8 43 44 00 00       	call   80104c30 <acquire>
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
80100838:	bf 78 7e 10 80       	mov    $0x80107e78,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 70 43 00 00       	call   80104bd0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 7f 7e 10 80       	push   $0x80107e7f
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
80100893:	e8 98 43 00 00       	call   80104c30 <acquire>
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
801009d0:	e8 fb 41 00 00       	call   80104bd0 <release>
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
80100a0e:	e9 0d 3e 00 00       	jmp    80104820 <procdump>
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
80100a44:	e8 f7 3c 00 00       	call   80104740 <wakeup>
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
80100a66:	68 88 7e 10 80       	push   $0x80107e88
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 eb 3f 00 00       	call   80104a60 <initlock>

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
80100b34:	e8 87 6f 00 00       	call   80107ac0 <setupkvm>
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
80100ba3:	e8 38 6d 00 00       	call   801078e0 <allocuvm>
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
80100bd9:	e8 12 6c 00 00       	call   801077f0 <loaduvm>
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
80100c1b:	e8 20 6e 00 00       	call   80107a40 <freevm>
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
80100c62:	e8 79 6c 00 00       	call   801078e0 <allocuvm>
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
80100c83:	e8 d8 6e 00 00       	call   80107b60 <clearpteu>
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
80100cd3:	e8 18 42 00 00       	call   80104ef0 <strlen>
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
80100ce7:	e8 04 42 00 00       	call   80104ef0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 33 70 00 00       	call   80107d30 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 2a 6d 00 00       	call   80107a40 <freevm>
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
80100d63:	e8 c8 6f 00 00       	call   80107d30 <copyout>
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
80100da1:	e8 0a 41 00 00       	call   80104eb0 <safestrcpy>
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
80100dcd:	e8 8e 68 00 00       	call   80107660 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 66 6c 00 00       	call   80107a40 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 a1 7e 10 80       	push   $0x80107ea1
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
80100e16:	68 ad 7e 10 80       	push   $0x80107ead
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 3b 3c 00 00       	call   80104a60 <initlock>
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
80100e41:	e8 ea 3d 00 00       	call   80104c30 <acquire>
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
80100e71:	e8 5a 3d 00 00       	call   80104bd0 <release>
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
80100e8a:	e8 41 3d 00 00       	call   80104bd0 <release>
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
80100eaf:	e8 7c 3d 00 00       	call   80104c30 <acquire>
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
80100ecc:	e8 ff 3c 00 00       	call   80104bd0 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 b4 7e 10 80       	push   $0x80107eb4
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
80100f01:	e8 2a 3d 00 00       	call   80104c30 <acquire>
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
80100f3c:	e8 8f 3c 00 00       	call   80104bd0 <release>

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
80100f6e:	e9 5d 3c 00 00       	jmp    80104bd0 <release>
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
80100fbc:	68 bc 7e 10 80       	push   $0x80107ebc
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
801010a2:	68 c6 7e 10 80       	push   $0x80107ec6
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
80101177:	68 cf 7e 10 80       	push   $0x80107ecf
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
801011b1:	68 d5 7e 10 80       	push   $0x80107ed5
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
80101227:	68 df 7e 10 80       	push   $0x80107edf
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
801012e4:	68 f2 7e 10 80       	push   $0x80107ef2
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
80101325:	e8 c6 39 00 00       	call   80104cf0 <memset>
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
8010136a:	e8 c1 38 00 00       	call   80104c30 <acquire>
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
801013d7:	e8 f4 37 00 00       	call   80104bd0 <release>

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
80101405:	e8 c6 37 00 00       	call   80104bd0 <release>
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
80101438:	68 08 7f 10 80       	push   $0x80107f08
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
80101515:	68 18 7f 10 80       	push   $0x80107f18
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
80101541:	e8 4a 38 00 00       	call   80104d90 <memmove>
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
8010156c:	68 2b 7f 10 80       	push   $0x80107f2b
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 e5 34 00 00       	call   80104a60 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 32 7f 10 80       	push   $0x80107f32
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 9c 33 00 00       	call   80104930 <initsleeplock>
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
801015bc:	e8 cf 37 00 00       	call   80104d90 <memmove>
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
801015f3:	68 98 7f 10 80       	push   $0x80107f98
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
8010168e:	e8 5d 36 00 00       	call   80104cf0 <memset>
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
801016c3:	68 38 7f 10 80       	push   $0x80107f38
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
80101731:	e8 5a 36 00 00       	call   80104d90 <memmove>
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
8010175f:	e8 cc 34 00 00       	call   80104c30 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 5c 34 00 00       	call   80104bd0 <release>
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
801017a2:	e8 c9 31 00 00       	call   80104970 <acquiresleep>
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
80101818:	e8 73 35 00 00       	call   80104d90 <memmove>
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
8010183d:	68 50 7f 10 80       	push   $0x80107f50
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 4a 7f 10 80       	push   $0x80107f4a
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
80101873:	e8 98 31 00 00       	call   80104a10 <holdingsleep>
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
8010188f:	e9 3c 31 00 00       	jmp    801049d0 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 5f 7f 10 80       	push   $0x80107f5f
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
801018c0:	e8 ab 30 00 00       	call   80104970 <acquiresleep>
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
801018da:	e8 f1 30 00 00       	call   801049d0 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 45 33 00 00       	call   80104c30 <acquire>
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
80101900:	e9 cb 32 00 00       	jmp    80104bd0 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 1b 33 00 00       	call   80104c30 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 ac 32 00 00       	call   80104bd0 <release>
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
80101a23:	e8 e8 2f 00 00       	call   80104a10 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 91 2f 00 00       	call   801049d0 <releasesleep>
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
80101a53:	68 5f 7f 10 80       	push   $0x80107f5f
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
80101b37:	e8 54 32 00 00       	call   80104d90 <memmove>
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
80101c33:	e8 58 31 00 00       	call   80104d90 <memmove>
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
80101cce:	e8 2d 31 00 00       	call   80104e00 <strncmp>
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
80101d2d:	e8 ce 30 00 00       	call   80104e00 <strncmp>
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
80101d72:	68 79 7f 10 80       	push   $0x80107f79
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 67 7f 10 80       	push   $0x80107f67
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
80101dba:	e8 71 2e 00 00       	call   80104c30 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 01 2e 00 00       	call   80104bd0 <release>
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
80101e27:	e8 64 2f 00 00       	call   80104d90 <memmove>
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
80101e8c:	e8 7f 2b 00 00       	call   80104a10 <holdingsleep>
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
80101eae:	e8 1d 2b 00 00       	call   801049d0 <releasesleep>
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
80101edb:	e8 b0 2e 00 00       	call   80104d90 <memmove>
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
80101f2b:	e8 e0 2a 00 00       	call   80104a10 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 81 2a 00 00       	call   801049d0 <releasesleep>
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
80101f6d:	e8 9e 2a 00 00       	call   80104a10 <holdingsleep>
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
80101f90:	e8 7b 2a 00 00       	call   80104a10 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 24 2a 00 00       	call   801049d0 <releasesleep>
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
80101fcf:	68 5f 7f 10 80       	push   $0x80107f5f
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
8010203d:	e8 0e 2e 00 00       	call   80104e50 <strncpy>
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
8010207b:	68 88 7f 10 80       	push   $0x80107f88
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 6a 86 10 80       	push   $0x8010866a
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
8010219b:	68 f4 7f 10 80       	push   $0x80107ff4
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 eb 7f 10 80       	push   $0x80107feb
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 06 80 10 80       	push   $0x80108006
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 8b 28 00 00       	call   80104a60 <initlock>
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
8010224e:	e8 dd 29 00 00       	call   80104c30 <acquire>

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
801022ad:	e8 8e 24 00 00       	call   80104740 <wakeup>

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
801022cb:	e8 00 29 00 00       	call   80104bd0 <release>

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
801022ee:	e8 1d 27 00 00       	call   80104a10 <holdingsleep>
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
80102328:	e8 03 29 00 00       	call   80104c30 <acquire>

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
80102369:	e8 12 23 00 00       	call   80104680 <sleep>
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
80102386:	e9 45 28 00 00       	jmp    80104bd0 <release>
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
801023aa:	68 35 80 10 80       	push   $0x80108035
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 20 80 10 80       	push   $0x80108020
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 0a 80 10 80       	push   $0x8010800a
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
8010241a:	68 54 80 10 80       	push   $0x80108054
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
801024f2:	e8 f9 27 00 00       	call   80104cf0 <memset>

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
80102528:	e8 03 27 00 00       	call   80104c30 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 88 26 00 00       	jmp    80104bd0 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 86 80 10 80       	push   $0x80108086
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
8010261b:	68 8c 80 10 80       	push   $0x8010808c
80102620:	68 40 26 11 80       	push   $0x80112640
80102625:	e8 36 24 00 00       	call   80104a60 <initlock>
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
801026b3:	e8 78 25 00 00       	call   80104c30 <acquire>
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
801026e1:	e8 ea 24 00 00       	call   80104bd0 <release>
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
8010272b:	0f b6 91 c0 81 10 80 	movzbl -0x7fef7e40(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 c0 80 10 80 	movzbl -0x7fef7f40(%ecx),%eax
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
8010274b:	8b 04 85 a0 80 10 80 	mov    -0x7fef7f60(,%eax,4),%eax
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
80102788:	0f b6 81 c0 81 10 80 	movzbl -0x7fef7e40(%ecx),%eax
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
80102af7:	e8 44 22 00 00       	call   80104d40 <memcmp>
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
80102c24:	e8 67 21 00 00       	call   80104d90 <memmove>
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
80102cca:	68 c0 82 10 80       	push   $0x801082c0
80102ccf:	68 a0 26 11 80       	push   $0x801126a0
80102cd4:	e8 87 1d 00 00       	call   80104a60 <initlock>
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
80102d6b:	e8 c0 1e 00 00       	call   80104c30 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 26 11 80       	push   $0x801126a0
80102d80:	68 a0 26 11 80       	push   $0x801126a0
80102d85:	e8 f6 18 00 00       	call   80104680 <sleep>
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
80102dbc:	e8 0f 1e 00 00       	call   80104bd0 <release>
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
80102dde:	e8 4d 1e 00 00       	call   80104c30 <acquire>
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
80102e1c:	e8 af 1d 00 00       	call   80104bd0 <release>
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
80102e36:	e8 f5 1d 00 00       	call   80104c30 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102e42:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 ef 18 00 00       	call   80104740 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e58:	e8 73 1d 00 00       	call   80104bd0 <release>
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
80102eb4:	e8 d7 1e 00 00       	call   80104d90 <memmove>
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
80102f08:	e8 33 18 00 00       	call   80104740 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f14:	e8 b7 1c 00 00       	call   80104bd0 <release>
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
80102f27:	68 c4 82 10 80       	push   $0x801082c4
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
80102f76:	e8 b5 1c 00 00       	call   80104c30 <acquire>
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
80102fb5:	e9 16 1c 00 00       	jmp    80104bd0 <release>
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
80102fe1:	68 d3 82 10 80       	push   $0x801082d3
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 e9 82 10 80       	push   $0x801082e9
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
80103018:	68 04 83 10 80       	push   $0x80108304
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 39 35 00 00       	call   80106560 <idtinit>
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
80103046:	e8 05 46 00 00       	call   80107650 <switchkvm>
  seginit();
8010304b:	e8 70 45 00 00       	call   801075c0 <seginit>
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
80103081:	e8 ba 4a 00 00       	call   80107b40 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 2b 45 00 00       	call   801075c0 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 a7 37 00 00       	call   80106850 <uartinit>
  pinit();         // process table
801030a9:	e8 62 08 00 00       	call   80103910 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 2d 34 00 00       	call   801064e0 <tvinit>
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
801030d4:	e8 b7 1c 00 00       	call   80104d90 <memmove>

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
801031be:	68 18 83 10 80       	push   $0x80108318
801031c3:	56                   	push   %esi
801031c4:	e8 77 1b 00 00       	call   80104d40 <memcmp>
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
80103276:	68 1d 83 10 80       	push   $0x8010831d
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 bc 1a 00 00       	call   80104d40 <memcmp>
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
80103393:	68 22 83 10 80       	push   $0x80108322
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
801033c2:	68 18 83 10 80       	push   $0x80108318
801033c7:	53                   	push   %ebx
801033c8:	e8 73 19 00 00       	call   80104d40 <memcmp>
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
801033f8:	68 3c 83 10 80       	push   $0x8010833c
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
801034a3:	68 5b 83 10 80       	push   $0x8010835b
801034a8:	50                   	push   %eax
801034a9:	e8 b2 15 00 00       	call   80104a60 <initlock>
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
8010353f:	e8 ec 16 00 00       	call   80104c30 <acquire>
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
8010355f:	e8 dc 11 00 00       	call   80104740 <wakeup>
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
80103584:	e9 47 16 00 00       	jmp    80104bd0 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 37 16 00 00       	call   80104bd0 <release>
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
801035c4:	e8 77 11 00 00       	call   80104740 <wakeup>
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
801035dd:	e8 4e 16 00 00       	call   80104c30 <acquire>
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
80103638:	e8 03 11 00 00       	call   80104740 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 3a 10 00 00       	call   80104680 <sleep>
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
8010366c:	e8 5f 15 00 00       	call   80104bd0 <release>
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
801036ba:	e8 81 10 00 00       	call   80104740 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 09 15 00 00       	call   80104bd0 <release>
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
801036e6:	e8 45 15 00 00       	call   80104c30 <acquire>
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
80103715:	e8 66 0f 00 00       	call   80104680 <sleep>
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
80103776:	e8 c5 0f 00 00       	call   80104740 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 4d 14 00 00       	call   80104bd0 <release>
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
80103799:	e8 32 14 00 00       	call   80104bd0 <release>
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
801037c1:	e8 6a 14 00 00       	call   80104c30 <acquire>
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
8010383a:	e8 91 13 00 00       	call   80104bd0 <release>

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
8010385f:	c7 40 14 c7 64 10 80 	movl   $0x801064c7,0x14(%eax)
  p->context = (struct context *)sp;
80103866:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103869:	6a 14                	push   $0x14
8010386b:	6a 00                	push   $0x0
8010386d:	50                   	push   %eax
8010386e:	e8 7d 14 00 00       	call   80104cf0 <memset>
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
8010389a:	e8 31 13 00 00       	call   80104bd0 <release>
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
801038cb:	e8 00 13 00 00       	call   80104bd0 <release>

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
80103916:	68 60 83 10 80       	push   $0x80108360
8010391b:	68 20 2d 11 80       	push   $0x80112d20
80103920:	e8 3b 11 00 00       	call   80104a60 <initlock>
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
80103978:	68 67 83 10 80       	push   $0x80108367
8010397d:	e8 fe c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103982:	83 ec 0c             	sub    $0xc,%esp
80103985:	68 98 84 10 80       	push   $0x80108498
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
801039cd:	e8 5e 12 00 00       	call   80104c30 <acquire>
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
80103a27:	e9 a4 11 00 00       	jmp    80104bd0 <release>
80103a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a30 <myproc>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	53                   	push   %ebx
80103a34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a37:	e8 a4 10 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80103a3c:	e8 ef fe ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103a41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a47:	e8 e4 10 00 00       	call   80104b30 <popcli>
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
80103a73:	e8 48 40 00 00       	call   80107ac0 <setupkvm>
80103a78:	89 43 04             	mov    %eax,0x4(%ebx)
80103a7b:	85 c0                	test   %eax,%eax
80103a7d:	0f 84 bd 00 00 00    	je     80103b40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a83:	83 ec 04             	sub    $0x4,%esp
80103a86:	68 2c 00 00 00       	push   $0x2c
80103a8b:	68 60 b4 10 80       	push   $0x8010b460
80103a90:	50                   	push   %eax
80103a91:	e8 da 3c 00 00       	call   80107770 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a9f:	6a 4c                	push   $0x4c
80103aa1:	6a 00                	push   $0x0
80103aa3:	ff 73 18             	push   0x18(%ebx)
80103aa6:	e8 45 12 00 00       	call   80104cf0 <memset>
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
80103aff:	68 90 83 10 80       	push   $0x80108390
80103b04:	50                   	push   %eax
80103b05:	e8 a6 13 00 00       	call   80104eb0 <safestrcpy>
  p->cwd = namei("/");
80103b0a:	c7 04 24 99 83 10 80 	movl   $0x80108399,(%esp)
80103b11:	e8 8a e5 ff ff       	call   801020a0 <namei>
80103b16:	89 43 74             	mov    %eax,0x74(%ebx)
  acquire(&ptable.lock);
80103b19:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b20:	e8 0b 11 00 00       	call   80104c30 <acquire>
  p->state = RUNNABLE;
80103b25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b2c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b33:	e8 98 10 00 00       	call   80104bd0 <release>
}
80103b38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b3b:	83 c4 10             	add    $0x10,%esp
80103b3e:	c9                   	leave  
80103b3f:	c3                   	ret    
    panic("userinit: out of memory?");
80103b40:	83 ec 0c             	sub    $0xc,%esp
80103b43:	68 77 83 10 80       	push   $0x80108377
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
80103b66:	e8 85 11 00 00       	call   80104cf0 <memset>
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
80103b86:	e8 65 13 00 00       	call   80104ef0 <strlen>
80103b8b:	83 c4 10             	add    $0x10,%esp
80103b8e:	39 d8                	cmp    %ebx,%eax
80103b90:	7f e6                	jg     80103b78 <print_name+0x28>
  cprintf("%s", buf);
80103b92:	83 ec 08             	sub    $0x8,%esp
80103b95:	57                   	push   %edi
80103b96:	68 68 84 10 80       	push   $0x80108468
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
80103bc5:	e8 66 10 00 00       	call   80104c30 <acquire>
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
80103beb:	e8 e0 0f 00 00       	call   80104bd0 <release>
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
80103c0b:	ff 24 85 30 85 10 80 	jmp    *-0x7fef7ad0(,%eax,4)
80103c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("RUNNING ");
80103c18:	c7 45 08 bf 83 10 80 	movl   $0x801083bf,0x8(%ebp)
}
80103c1f:	5d                   	pop    %ebp
    cprintf("RUNNING ");
80103c20:	e9 7b ca ff ff       	jmp    801006a0 <cprintf>
80103c25:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("ZOMBIE ");
80103c28:	c7 45 08 c8 83 10 80 	movl   $0x801083c8,0x8(%ebp)
}
80103c2f:	5d                   	pop    %ebp
    cprintf("ZOMBIE ");
80103c30:	e9 6b ca ff ff       	jmp    801006a0 <cprintf>
80103c35:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("UNUSED ");
80103c38:	c7 45 08 9b 83 10 80 	movl   $0x8010839b,0x8(%ebp)
}
80103c3f:	5d                   	pop    %ebp
    cprintf("UNUSED ");
80103c40:	e9 5b ca ff ff       	jmp    801006a0 <cprintf>
80103c45:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("EMBRYO ");
80103c48:	c7 45 08 a3 83 10 80 	movl   $0x801083a3,0x8(%ebp)
}
80103c4f:	5d                   	pop    %ebp
    cprintf("EMBRYO ");
80103c50:	e9 4b ca ff ff       	jmp    801006a0 <cprintf>
80103c55:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("SLEEPING ");
80103c58:	c7 45 08 ab 83 10 80 	movl   $0x801083ab,0x8(%ebp)
}
80103c5f:	5d                   	pop    %ebp
    cprintf("SLEEPING ");
80103c60:	e9 3b ca ff ff       	jmp    801006a0 <cprintf>
80103c65:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("RUNNABLE ");
80103c68:	c7 45 08 b5 83 10 80 	movl   $0x801083b5,0x8(%ebp)
}
80103c6f:	5d                   	pop    %ebp
    cprintf("RUNNABLE ");
80103c70:	e9 2b ca ff ff       	jmp    801006a0 <cprintf>
    cprintf("damn ways to die");
80103c75:	c7 45 08 d0 83 10 80 	movl   $0x801083d0,0x8(%ebp)
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
80103ca1:	e8 8a 0f 00 00       	call   80104c30 <acquire>
  cprintf("process_name    PID    State    Queue    Cycle    Arrival    Priority    R_prty    R_Arvl    R_exec    Rank\n");
80103ca6:	c7 04 24 c0 84 10 80 	movl   $0x801084c0,(%esp)
80103cad:	e8 ee c9 ff ff       	call   801006a0 <cprintf>
80103cb2:	83 c4 10             	add    $0x10,%esp
80103cb5:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("-");
80103cb8:	83 ec 0c             	sub    $0xc,%esp
80103cbb:	68 e1 83 10 80       	push   $0x801083e1
80103cc0:	e8 db c9 ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < 80; i++)
80103cc5:	83 c4 10             	add    $0x10,%esp
80103cc8:	83 eb 01             	sub    $0x1,%ebx
80103ccb:	75 eb                	jne    80103cb8 <print_bitches+0x28>
  cprintf("\n");
80103ccd:	83 ec 0c             	sub    $0xc,%esp
80103cd0:	bb cc 2d 11 80       	mov    $0x80112dcc,%ebx
80103cd5:	68 af 88 10 80       	push   $0x801088af
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
80103d01:	68 e3 83 10 80       	push   $0x801083e3
80103d06:	e8 95 c9 ff ff       	call   801006a0 <cprintf>
    print_state((*p).state);
80103d0b:	59                   	pop    %ecx
80103d0c:	ff 73 94             	push   -0x6c(%ebx)
80103d0f:	e8 ec fe ff ff       	call   80103c00 <print_state>
    cprintf("%d   ", p->que_id);
80103d14:	58                   	pop    %eax
80103d15:	5a                   	pop    %edx
80103d16:	ff 73 b0             	push   -0x50(%ebx)
80103d19:	68 e8 83 10 80       	push   $0x801083e8
80103d1e:	e8 7d c9 ff ff       	call   801006a0 <cprintf>
    cprintf("%d   ", p->executed_cycle);
80103d23:	d9 43 1c             	flds   0x1c(%ebx)
80103d26:	c7 04 24 e8 83 10 80 	movl   $0x801083e8,(%esp)
80103d2d:	dd 5c 24 04          	fstpl  0x4(%esp)
80103d31:	e8 6a c9 ff ff       	call   801006a0 <cprintf>
    cprintf("%d   ", p->creation_time);
80103d36:	59                   	pop    %ecx
80103d37:	58                   	pop    %eax
80103d38:	ff 73 a8             	push   -0x58(%ebx)
80103d3b:	68 e8 83 10 80       	push   $0x801083e8
80103d40:	e8 5b c9 ff ff       	call   801006a0 <cprintf>
    cprintf("%d   ", p->priority);
80103d45:	58                   	pop    %eax
80103d46:	5a                   	pop    %edx
80103d47:	ff 73 10             	push   0x10(%ebx)
80103d4a:	68 e8 83 10 80       	push   $0x801083e8
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
80103d74:	68 e8 83 10 80       	push   $0x801083e8
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
80103d9e:	68 e8 83 10 80       	push   $0x801083e8
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
80103dc8:	68 14 83 10 80       	push   $0x80108314
80103dcd:	e8 ce c8 ff ff       	call   801006a0 <cprintf>
80103dd2:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dd5:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103ddb:	81 fb cc 55 11 80    	cmp    $0x801155cc,%ebx
80103de1:	0f 85 01 ff ff ff    	jne    80103ce8 <print_bitches+0x58>
  release(&ptable.lock);
80103de7:	83 ec 0c             	sub    $0xc,%esp
80103dea:	68 20 2d 11 80       	push   $0x80112d20
80103def:	e8 dc 0d 00 00       	call   80104bd0 <release>
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
80103e0e:	e8 1d 0e 00 00       	call   80104c30 <acquire>
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
80103e4a:	e8 81 0d 00 00       	call   80104bd0 <release>
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
80103e68:	e8 73 0c 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80103e6d:	e8 be fa ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103e72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e78:	e8 b3 0c 00 00       	call   80104b30 <popcli>
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
80103e8b:	e8 d0 37 00 00       	call   80107660 <switchuvm>
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
80103eaa:	e8 31 3a 00 00       	call   801078e0 <allocuvm>
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
80103eca:	e8 41 3b 00 00       	call   80107a10 <deallocuvm>
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
80103ee9:	e8 f2 0b 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80103eee:	e8 3d fa ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103ef3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ef9:	e8 32 0c 00 00       	call   80104b30 <popcli>
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
80103f18:	e8 93 3c 00 00       	call   80107bb0 <copyuvm>
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
80103f91:	e8 1a 0f 00 00       	call   80104eb0 <safestrcpy>
  pid = np->pid;
80103f96:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103f99:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fa0:	e8 8b 0c 00 00       	call   80104c30 <acquire>
  np->state = RUNNABLE;
80103fa5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  acquire(&tickslock);
80103fac:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)
80103fb3:	e8 78 0c 00 00       	call   80104c30 <acquire>
  np->creation_time = ticks;
80103fb8:	a1 60 55 11 80       	mov    0x80115560,%eax
80103fbd:	89 47 20             	mov    %eax,0x20(%edi)
  np->preemption_time = ticks;
80103fc0:	89 47 24             	mov    %eax,0x24(%edi)
  release(&tickslock);
80103fc3:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)
80103fca:	e8 01 0c 00 00       	call   80104bd0 <release>
  release(&ptable.lock);
80103fcf:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fd6:	e8 f5 0b 00 00       	call   80104bd0 <release>
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
80104023:	57                   	push   %edi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104024:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
{
80104029:	56                   	push   %esi
8010402a:	53                   	push   %ebx
  int max_diff = MIN_INT;
8010402b:	bb f0 d8 ff ff       	mov    $0xffffd8f0,%ebx
{
80104030:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *res = 0;
80104033:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  int now = ticks;
8010403a:	8b 35 60 55 11 80    	mov    0x80115560,%esi
    cprintf("%d\n", p->state);
80104040:	83 ec 08             	sub    $0x8,%esp
80104043:	ff 77 0c             	push   0xc(%edi)
80104046:	68 14 83 10 80       	push   $0x80108314
8010404b:	e8 50 c6 ff ff       	call   801006a0 <cprintf>
    if (p->state != RUNNABLE || p->que_id != RR)
80104050:	83 c4 10             	add    $0x10,%esp
80104053:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80104057:	75 17                	jne    80104070 <round_robin+0x50>
80104059:	83 7f 28 01          	cmpl   $0x1,0x28(%edi)
8010405d:	75 11                	jne    80104070 <round_robin+0x50>
    if (now - p->preemption_time > max_diff)
8010405f:	89 f2                	mov    %esi,%edx
80104061:	2b 57 24             	sub    0x24(%edi),%edx
80104064:	39 da                	cmp    %ebx,%edx
80104066:	76 08                	jbe    80104070 <round_robin+0x50>
      max_diff = now - p->preemption_time;
80104068:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010406b:	89 d3                	mov    %edx,%ebx
      res = p;
8010406d:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104070:	81 c7 a0 00 00 00    	add    $0xa0,%edi
80104076:	81 ff 54 55 11 80    	cmp    $0x80115554,%edi
8010407c:	75 c2                	jne    80104040 <round_robin+0x20>
}
8010407e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104081:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104084:	5b                   	pop    %ebx
80104085:	5e                   	pop    %esi
80104086:	5f                   	pop    %edi
80104087:	5d                   	pop    %ebp
80104088:	c3                   	ret    
80104089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104090 <last_come_first_serve>:
{
80104090:	55                   	push   %ebp
  int latest_time = MIN_INT;
80104091:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
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
80104140:	d9 05 60 85 10 80    	flds   0x80108560
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
80104238:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
8010423a:	8d 70 04             	lea    0x4(%eax),%esi
8010423d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104240:	fb                   	sti    
    acquire(&ptable.lock);
80104241:	83 ec 0c             	sub    $0xc,%esp
80104244:	68 20 2d 11 80       	push   $0x80112d20
80104249:	e8 e2 09 00 00       	call   80104c30 <acquire>
    p = round_robin();
8010424e:	e8 cd fd ff ff       	call   80104020 <round_robin>
    if (p == 0)
80104253:	83 c4 10             	add    $0x10,%esp
    p = round_robin();
80104256:	89 c7                	mov    %eax,%edi
    if (p == 0)
80104258:	85 c0                	test   %eax,%eax
8010425a:	74 44                	je     801042a0 <scheduler+0x80>
    switchuvm(p);
8010425c:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
8010425f:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
    switchuvm(p);
80104265:	57                   	push   %edi
80104266:	e8 f5 33 00 00       	call   80107660 <switchuvm>
    p->state = RUNNING;
8010426b:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
    swtch(&(c->scheduler), p->context);
80104272:	58                   	pop    %eax
80104273:	5a                   	pop    %edx
80104274:	ff 77 1c             	push   0x1c(%edi)
80104277:	56                   	push   %esi
80104278:	e8 8e 0c 00 00       	call   80104f0b <swtch>
    switchkvm();
8010427d:	e8 ce 33 00 00       	call   80107650 <switchkvm>
    c->proc = 0;
80104282:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104289:	00 00 00 
    release(&ptable.lock);
8010428c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104293:	e8 38 09 00 00       	call   80104bd0 <release>
80104298:	83 c4 10             	add    $0x10,%esp
8010429b:	eb a3                	jmp    80104240 <scheduler+0x20>
8010429d:	8d 76 00             	lea    0x0(%esi),%esi
  int latest_time = MIN_INT;
801042a0:	b8 f0 d8 ff ff       	mov    $0xffffd8f0,%eax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042a5:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801042aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (p->state != RUNNABLE || p->que_id != LCFS)
801042b0:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801042b4:	75 1a                	jne    801042d0 <scheduler+0xb0>
801042b6:	83 7a 28 02          	cmpl   $0x2,0x28(%edx)
801042ba:	75 14                	jne    801042d0 <scheduler+0xb0>
    if (p->creation_time > latest_time)
801042bc:	8b 4a 20             	mov    0x20(%edx),%ecx
801042bf:	39 c1                	cmp    %eax,%ecx
801042c1:	76 0d                	jbe    801042d0 <scheduler+0xb0>
      latest_time = p->creation_time;
801042c3:	89 c8                	mov    %ecx,%eax
801042c5:	89 d7                	mov    %edx,%edi
801042c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ce:	66 90                	xchg   %ax,%ax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042d0:	81 c2 a0 00 00 00    	add    $0xa0,%edx
801042d6:	81 fa 54 55 11 80    	cmp    $0x80115554,%edx
801042dc:	75 d2                	jne    801042b0 <scheduler+0x90>
    if (p == 0)
801042de:	85 ff                	test   %edi,%edi
801042e0:	0f 85 76 ff ff ff    	jne    8010425c <scheduler+0x3c>
      p = best_job_first();
801042e6:	e8 55 fe ff ff       	call   80104140 <best_job_first>
801042eb:	89 c7                	mov    %eax,%edi
    if (p == 0)
801042ed:	85 c0                	test   %eax,%eax
801042ef:	0f 85 67 ff ff ff    	jne    8010425c <scheduler+0x3c>
      release(&ptable.lock);
801042f5:	83 ec 0c             	sub    $0xc,%esp
801042f8:	68 20 2d 11 80       	push   $0x80112d20
801042fd:	e8 ce 08 00 00       	call   80104bd0 <release>
      continue;
80104302:	83 c4 10             	add    $0x10,%esp
80104305:	e9 36 ff ff ff       	jmp    80104240 <scheduler+0x20>
8010430a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104310 <sched>:
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	56                   	push   %esi
80104314:	53                   	push   %ebx
  pushcli();
80104315:	e8 c6 07 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
8010431a:	e8 11 f6 ff ff       	call   80103930 <mycpu>
  p = c->proc;
8010431f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104325:	e8 06 08 00 00       	call   80104b30 <popcli>
  if (!holding(&ptable.lock))
8010432a:	83 ec 0c             	sub    $0xc,%esp
8010432d:	68 20 2d 11 80       	push   $0x80112d20
80104332:	e8 59 08 00 00       	call   80104b90 <holding>
80104337:	83 c4 10             	add    $0x10,%esp
8010433a:	85 c0                	test   %eax,%eax
8010433c:	74 4f                	je     8010438d <sched+0x7d>
  if (mycpu()->ncli != 1)
8010433e:	e8 ed f5 ff ff       	call   80103930 <mycpu>
80104343:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010434a:	75 68                	jne    801043b4 <sched+0xa4>
  if (p->state == RUNNING)
8010434c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104350:	74 55                	je     801043a7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104352:	9c                   	pushf  
80104353:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80104354:	f6 c4 02             	test   $0x2,%ah
80104357:	75 41                	jne    8010439a <sched+0x8a>
  intena = mycpu()->intena;
80104359:	e8 d2 f5 ff ff       	call   80103930 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010435e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104361:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104367:	e8 c4 f5 ff ff       	call   80103930 <mycpu>
8010436c:	83 ec 08             	sub    $0x8,%esp
8010436f:	ff 70 04             	push   0x4(%eax)
80104372:	53                   	push   %ebx
80104373:	e8 93 0b 00 00       	call   80104f0b <swtch>
  mycpu()->intena = intena;
80104378:	e8 b3 f5 ff ff       	call   80103930 <mycpu>
}
8010437d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104380:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104386:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104389:	5b                   	pop    %ebx
8010438a:	5e                   	pop    %esi
8010438b:	5d                   	pop    %ebp
8010438c:	c3                   	ret    
    panic("sched ptable.lock");
8010438d:	83 ec 0c             	sub    $0xc,%esp
80104390:	68 ee 83 10 80       	push   $0x801083ee
80104395:	e8 e6 bf ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010439a:	83 ec 0c             	sub    $0xc,%esp
8010439d:	68 1a 84 10 80       	push   $0x8010841a
801043a2:	e8 d9 bf ff ff       	call   80100380 <panic>
    panic("sched running");
801043a7:	83 ec 0c             	sub    $0xc,%esp
801043aa:	68 0c 84 10 80       	push   $0x8010840c
801043af:	e8 cc bf ff ff       	call   80100380 <panic>
    panic("sched locks");
801043b4:	83 ec 0c             	sub    $0xc,%esp
801043b7:	68 00 84 10 80       	push   $0x80108400
801043bc:	e8 bf bf ff ff       	call   80100380 <panic>
801043c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043cf:	90                   	nop

801043d0 <exit>:
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	57                   	push   %edi
801043d4:	56                   	push   %esi
801043d5:	53                   	push   %ebx
801043d6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801043d9:	e8 52 f6 ff ff       	call   80103a30 <myproc>
  if (curproc == initproc)
801043de:	39 05 54 55 11 80    	cmp    %eax,0x80115554
801043e4:	0f 84 07 01 00 00    	je     801044f1 <exit+0x121>
801043ea:	89 c3                	mov    %eax,%ebx
801043ec:	8d 70 34             	lea    0x34(%eax),%esi
801043ef:	8d 78 74             	lea    0x74(%eax),%edi
801043f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd])
801043f8:	8b 06                	mov    (%esi),%eax
801043fa:	85 c0                	test   %eax,%eax
801043fc:	74 12                	je     80104410 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801043fe:	83 ec 0c             	sub    $0xc,%esp
80104401:	50                   	push   %eax
80104402:	e8 e9 ca ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80104407:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010440d:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
80104410:	83 c6 04             	add    $0x4,%esi
80104413:	39 f7                	cmp    %esi,%edi
80104415:	75 e1                	jne    801043f8 <exit+0x28>
  begin_op();
80104417:	e8 44 e9 ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
8010441c:	83 ec 0c             	sub    $0xc,%esp
8010441f:	ff 73 74             	push   0x74(%ebx)
80104422:	e8 89 d4 ff ff       	call   801018b0 <iput>
  end_op();
80104427:	e8 a4 e9 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
8010442c:	c7 43 74 00 00 00 00 	movl   $0x0,0x74(%ebx)
  acquire(&ptable.lock);
80104433:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010443a:	e8 f1 07 00 00       	call   80104c30 <acquire>
  wakeup1(curproc->parent);
8010443f:	8b 53 14             	mov    0x14(%ebx),%edx
80104442:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104445:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010444a:	eb 10                	jmp    8010445c <exit+0x8c>
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104450:	05 a0 00 00 00       	add    $0xa0,%eax
80104455:	3d 54 55 11 80       	cmp    $0x80115554,%eax
8010445a:	74 1e                	je     8010447a <exit+0xaa>
    if (p->state == SLEEPING && p->chan == chan)
8010445c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104460:	75 ee                	jne    80104450 <exit+0x80>
80104462:	3b 50 2c             	cmp    0x2c(%eax),%edx
80104465:	75 e9                	jne    80104450 <exit+0x80>
      p->state = RUNNABLE;
80104467:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010446e:	05 a0 00 00 00       	add    $0xa0,%eax
80104473:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104478:	75 e2                	jne    8010445c <exit+0x8c>
      p->parent = initproc;
8010447a:	8b 0d 54 55 11 80    	mov    0x80115554,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104480:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80104485:	eb 17                	jmp    8010449e <exit+0xce>
80104487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010448e:	66 90                	xchg   %ax,%ax
80104490:	81 c2 a0 00 00 00    	add    $0xa0,%edx
80104496:	81 fa 54 55 11 80    	cmp    $0x80115554,%edx
8010449c:	74 3a                	je     801044d8 <exit+0x108>
    if (p->parent == curproc)
8010449e:	39 5a 14             	cmp    %ebx,0x14(%edx)
801044a1:	75 ed                	jne    80104490 <exit+0xc0>
      if (p->state == ZOMBIE)
801044a3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801044a7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
801044aa:	75 e4                	jne    80104490 <exit+0xc0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044ac:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801044b1:	eb 11                	jmp    801044c4 <exit+0xf4>
801044b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044b7:	90                   	nop
801044b8:	05 a0 00 00 00       	add    $0xa0,%eax
801044bd:	3d 54 55 11 80       	cmp    $0x80115554,%eax
801044c2:	74 cc                	je     80104490 <exit+0xc0>
    if (p->state == SLEEPING && p->chan == chan)
801044c4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044c8:	75 ee                	jne    801044b8 <exit+0xe8>
801044ca:	3b 48 2c             	cmp    0x2c(%eax),%ecx
801044cd:	75 e9                	jne    801044b8 <exit+0xe8>
      p->state = RUNNABLE;
801044cf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801044d6:	eb e0                	jmp    801044b8 <exit+0xe8>
  curproc->state = ZOMBIE;
801044d8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801044df:	e8 2c fe ff ff       	call   80104310 <sched>
  panic("zombie exit");
801044e4:	83 ec 0c             	sub    $0xc,%esp
801044e7:	68 3b 84 10 80       	push   $0x8010843b
801044ec:	e8 8f be ff ff       	call   80100380 <panic>
    panic("init exiting");
801044f1:	83 ec 0c             	sub    $0xc,%esp
801044f4:	68 2e 84 10 80       	push   $0x8010842e
801044f9:	e8 82 be ff ff       	call   80100380 <panic>
801044fe:	66 90                	xchg   %ax,%ax

80104500 <wait>:
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	56                   	push   %esi
80104504:	53                   	push   %ebx
  pushcli();
80104505:	e8 d6 05 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
8010450a:	e8 21 f4 ff ff       	call   80103930 <mycpu>
  p = c->proc;
8010450f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104515:	e8 16 06 00 00       	call   80104b30 <popcli>
  acquire(&ptable.lock);
8010451a:	83 ec 0c             	sub    $0xc,%esp
8010451d:	68 20 2d 11 80       	push   $0x80112d20
80104522:	e8 09 07 00 00       	call   80104c30 <acquire>
80104527:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010452a:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010452c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104531:	eb 13                	jmp    80104546 <wait+0x46>
80104533:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104537:	90                   	nop
80104538:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
8010453e:	81 fb 54 55 11 80    	cmp    $0x80115554,%ebx
80104544:	74 1e                	je     80104564 <wait+0x64>
      if (p->parent != curproc)
80104546:	39 73 14             	cmp    %esi,0x14(%ebx)
80104549:	75 ed                	jne    80104538 <wait+0x38>
      if (p->state == ZOMBIE)
8010454b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010454f:	74 5f                	je     801045b0 <wait+0xb0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104551:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
      havekids = 1;
80104557:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010455c:	81 fb 54 55 11 80    	cmp    $0x80115554,%ebx
80104562:	75 e2                	jne    80104546 <wait+0x46>
    if (!havekids || curproc->killed)
80104564:	85 c0                	test   %eax,%eax
80104566:	0f 84 9a 00 00 00    	je     80104606 <wait+0x106>
8010456c:	8b 46 30             	mov    0x30(%esi),%eax
8010456f:	85 c0                	test   %eax,%eax
80104571:	0f 85 8f 00 00 00    	jne    80104606 <wait+0x106>
  pushcli();
80104577:	e8 64 05 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
8010457c:	e8 af f3 ff ff       	call   80103930 <mycpu>
  p = c->proc;
80104581:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104587:	e8 a4 05 00 00       	call   80104b30 <popcli>
  if (p == 0)
8010458c:	85 db                	test   %ebx,%ebx
8010458e:	0f 84 89 00 00 00    	je     8010461d <wait+0x11d>
  p->chan = chan;
80104594:	89 73 2c             	mov    %esi,0x2c(%ebx)
  p->state = SLEEPING;
80104597:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010459e:	e8 6d fd ff ff       	call   80104310 <sched>
  p->chan = 0;
801045a3:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
}
801045aa:	e9 7b ff ff ff       	jmp    8010452a <wait+0x2a>
801045af:	90                   	nop
        kfree(p->kstack);
801045b0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801045b3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801045b6:	ff 73 08             	push   0x8(%ebx)
801045b9:	e8 02 df ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
801045be:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801045c5:	5a                   	pop    %edx
801045c6:	ff 73 04             	push   0x4(%ebx)
801045c9:	e8 72 34 00 00       	call   80107a40 <freevm>
        p->pid = 0;
801045ce:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801045d5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801045dc:	c6 43 78 00          	movb   $0x0,0x78(%ebx)
        p->killed = 0;
801045e0:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
        p->state = UNUSED;
801045e7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801045ee:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801045f5:	e8 d6 05 00 00       	call   80104bd0 <release>
        return pid;
801045fa:	83 c4 10             	add    $0x10,%esp
}
801045fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104600:	89 f0                	mov    %esi,%eax
80104602:	5b                   	pop    %ebx
80104603:	5e                   	pop    %esi
80104604:	5d                   	pop    %ebp
80104605:	c3                   	ret    
      release(&ptable.lock);
80104606:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104609:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010460e:	68 20 2d 11 80       	push   $0x80112d20
80104613:	e8 b8 05 00 00       	call   80104bd0 <release>
      return -1;
80104618:	83 c4 10             	add    $0x10,%esp
8010461b:	eb e0                	jmp    801045fd <wait+0xfd>
    panic("sleep");
8010461d:	83 ec 0c             	sub    $0xc,%esp
80104620:	68 47 84 10 80       	push   $0x80108447
80104625:	e8 56 bd ff ff       	call   80100380 <panic>
8010462a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104630 <yield>:
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	53                   	push   %ebx
80104634:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); // DOC: yieldlock
80104637:	68 20 2d 11 80       	push   $0x80112d20
8010463c:	e8 ef 05 00 00       	call   80104c30 <acquire>
  pushcli();
80104641:	e8 9a 04 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80104646:	e8 e5 f2 ff ff       	call   80103930 <mycpu>
  p = c->proc;
8010464b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104651:	e8 da 04 00 00       	call   80104b30 <popcli>
  myproc()->state = RUNNABLE;
80104656:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010465d:	e8 ae fc ff ff       	call   80104310 <sched>
  release(&ptable.lock);
80104662:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104669:	e8 62 05 00 00       	call   80104bd0 <release>
}
8010466e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104671:	83 c4 10             	add    $0x10,%esp
80104674:	c9                   	leave  
80104675:	c3                   	ret    
80104676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010467d:	8d 76 00             	lea    0x0(%esi),%esi

80104680 <sleep>:
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	57                   	push   %edi
80104684:	56                   	push   %esi
80104685:	53                   	push   %ebx
80104686:	83 ec 0c             	sub    $0xc,%esp
80104689:	8b 7d 08             	mov    0x8(%ebp),%edi
8010468c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010468f:	e8 4c 04 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80104694:	e8 97 f2 ff ff       	call   80103930 <mycpu>
  p = c->proc;
80104699:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010469f:	e8 8c 04 00 00       	call   80104b30 <popcli>
  if (p == 0)
801046a4:	85 db                	test   %ebx,%ebx
801046a6:	0f 84 87 00 00 00    	je     80104733 <sleep+0xb3>
  if (lk == 0)
801046ac:	85 f6                	test   %esi,%esi
801046ae:	74 76                	je     80104726 <sleep+0xa6>
  if (lk != &ptable.lock)
801046b0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801046b6:	74 50                	je     80104708 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
801046b8:	83 ec 0c             	sub    $0xc,%esp
801046bb:	68 20 2d 11 80       	push   $0x80112d20
801046c0:	e8 6b 05 00 00       	call   80104c30 <acquire>
    release(lk);
801046c5:	89 34 24             	mov    %esi,(%esp)
801046c8:	e8 03 05 00 00       	call   80104bd0 <release>
  p->chan = chan;
801046cd:	89 7b 2c             	mov    %edi,0x2c(%ebx)
  p->state = SLEEPING;
801046d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801046d7:	e8 34 fc ff ff       	call   80104310 <sched>
  p->chan = 0;
801046dc:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
    release(&ptable.lock);
801046e3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801046ea:	e8 e1 04 00 00       	call   80104bd0 <release>
    acquire(lk);
801046ef:	89 75 08             	mov    %esi,0x8(%ebp)
801046f2:	83 c4 10             	add    $0x10,%esp
}
801046f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046f8:	5b                   	pop    %ebx
801046f9:	5e                   	pop    %esi
801046fa:	5f                   	pop    %edi
801046fb:	5d                   	pop    %ebp
    acquire(lk);
801046fc:	e9 2f 05 00 00       	jmp    80104c30 <acquire>
80104701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104708:	89 7b 2c             	mov    %edi,0x2c(%ebx)
  p->state = SLEEPING;
8010470b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104712:	e8 f9 fb ff ff       	call   80104310 <sched>
  p->chan = 0;
80104717:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
}
8010471e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104721:	5b                   	pop    %ebx
80104722:	5e                   	pop    %esi
80104723:	5f                   	pop    %edi
80104724:	5d                   	pop    %ebp
80104725:	c3                   	ret    
    panic("sleep without lk");
80104726:	83 ec 0c             	sub    $0xc,%esp
80104729:	68 4d 84 10 80       	push   $0x8010844d
8010472e:	e8 4d bc ff ff       	call   80100380 <panic>
    panic("sleep");
80104733:	83 ec 0c             	sub    $0xc,%esp
80104736:	68 47 84 10 80       	push   $0x80108447
8010473b:	e8 40 bc ff ff       	call   80100380 <panic>

80104740 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	53                   	push   %ebx
80104744:	83 ec 10             	sub    $0x10,%esp
80104747:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010474a:	68 20 2d 11 80       	push   $0x80112d20
8010474f:	e8 dc 04 00 00       	call   80104c30 <acquire>
80104754:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104757:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010475c:	eb 0e                	jmp    8010476c <wakeup+0x2c>
8010475e:	66 90                	xchg   %ax,%ax
80104760:	05 a0 00 00 00       	add    $0xa0,%eax
80104765:	3d 54 55 11 80       	cmp    $0x80115554,%eax
8010476a:	74 1e                	je     8010478a <wakeup+0x4a>
    if (p->state == SLEEPING && p->chan == chan)
8010476c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104770:	75 ee                	jne    80104760 <wakeup+0x20>
80104772:	3b 58 2c             	cmp    0x2c(%eax),%ebx
80104775:	75 e9                	jne    80104760 <wakeup+0x20>
      p->state = RUNNABLE;
80104777:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010477e:	05 a0 00 00 00       	add    $0xa0,%eax
80104783:	3d 54 55 11 80       	cmp    $0x80115554,%eax
80104788:	75 e2                	jne    8010476c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010478a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104791:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104794:	c9                   	leave  
  release(&ptable.lock);
80104795:	e9 36 04 00 00       	jmp    80104bd0 <release>
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047a0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	53                   	push   %ebx
801047a4:	83 ec 10             	sub    $0x10,%esp
801047a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801047aa:	68 20 2d 11 80       	push   $0x80112d20
801047af:	e8 7c 04 00 00       	call   80104c30 <acquire>
801047b4:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047b7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801047bc:	eb 0e                	jmp    801047cc <kill+0x2c>
801047be:	66 90                	xchg   %ax,%ax
801047c0:	05 a0 00 00 00       	add    $0xa0,%eax
801047c5:	3d 54 55 11 80       	cmp    $0x80115554,%eax
801047ca:	74 34                	je     80104800 <kill+0x60>
  {
    if (p->pid == pid)
801047cc:	39 58 10             	cmp    %ebx,0x10(%eax)
801047cf:	75 ef                	jne    801047c0 <kill+0x20>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
801047d1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801047d5:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
      if (p->state == SLEEPING)
801047dc:	75 07                	jne    801047e5 <kill+0x45>
        p->state = RUNNABLE;
801047de:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801047e5:	83 ec 0c             	sub    $0xc,%esp
801047e8:	68 20 2d 11 80       	push   $0x80112d20
801047ed:	e8 de 03 00 00       	call   80104bd0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801047f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801047f5:	83 c4 10             	add    $0x10,%esp
801047f8:	31 c0                	xor    %eax,%eax
}
801047fa:	c9                   	leave  
801047fb:	c3                   	ret    
801047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104800:	83 ec 0c             	sub    $0xc,%esp
80104803:	68 20 2d 11 80       	push   $0x80112d20
80104808:	e8 c3 03 00 00       	call   80104bd0 <release>
}
8010480d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104810:	83 c4 10             	add    $0x10,%esp
80104813:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104818:	c9                   	leave  
80104819:	c3                   	ret    
8010481a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104820 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	56                   	push   %esi
80104825:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104828:	53                   	push   %ebx
80104829:	bb cc 2d 11 80       	mov    $0x80112dcc,%ebx
8010482e:	83 ec 3c             	sub    $0x3c,%esp
80104831:	eb 27                	jmp    8010485a <procdump+0x3a>
80104833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104837:	90                   	nop
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104838:	83 ec 0c             	sub    $0xc,%esp
8010483b:	68 af 88 10 80       	push   $0x801088af
80104840:	e8 5b be ff ff       	call   801006a0 <cprintf>
80104845:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104848:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
8010484e:	81 fb cc 55 11 80    	cmp    $0x801155cc,%ebx
80104854:	0f 84 7e 00 00 00    	je     801048d8 <procdump+0xb8>
    if (p->state == UNUSED)
8010485a:	8b 43 94             	mov    -0x6c(%ebx),%eax
8010485d:	85 c0                	test   %eax,%eax
8010485f:	74 e7                	je     80104848 <procdump+0x28>
      state = "???";
80104861:	ba 5e 84 10 80       	mov    $0x8010845e,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104866:	83 f8 05             	cmp    $0x5,%eax
80104869:	77 11                	ja     8010487c <procdump+0x5c>
8010486b:	8b 14 85 48 85 10 80 	mov    -0x7fef7ab8(,%eax,4),%edx
      state = "???";
80104872:	b8 5e 84 10 80       	mov    $0x8010845e,%eax
80104877:	85 d2                	test   %edx,%edx
80104879:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010487c:	53                   	push   %ebx
8010487d:	52                   	push   %edx
8010487e:	ff 73 98             	push   -0x68(%ebx)
80104881:	68 62 84 10 80       	push   $0x80108462
80104886:	e8 15 be ff ff       	call   801006a0 <cprintf>
    if (p->state == SLEEPING)
8010488b:	83 c4 10             	add    $0x10,%esp
8010488e:	83 7b 94 02          	cmpl   $0x2,-0x6c(%ebx)
80104892:	75 a4                	jne    80104838 <procdump+0x18>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80104894:	83 ec 08             	sub    $0x8,%esp
80104897:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010489a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010489d:	50                   	push   %eax
8010489e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801048a1:	8b 40 0c             	mov    0xc(%eax),%eax
801048a4:	83 c0 08             	add    $0x8,%eax
801048a7:	50                   	push   %eax
801048a8:	e8 d3 01 00 00       	call   80104a80 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
801048ad:	83 c4 10             	add    $0x10,%esp
801048b0:	8b 17                	mov    (%edi),%edx
801048b2:	85 d2                	test   %edx,%edx
801048b4:	74 82                	je     80104838 <procdump+0x18>
        cprintf(" %p", pc[i]);
801048b6:	83 ec 08             	sub    $0x8,%esp
      for (i = 0; i < 10 && pc[i] != 0; i++)
801048b9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801048bc:	52                   	push   %edx
801048bd:	68 61 7e 10 80       	push   $0x80107e61
801048c2:	e8 d9 bd ff ff       	call   801006a0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
801048c7:	83 c4 10             	add    $0x10,%esp
801048ca:	39 fe                	cmp    %edi,%esi
801048cc:	75 e2                	jne    801048b0 <procdump+0x90>
801048ce:	e9 65 ff ff ff       	jmp    80104838 <procdump+0x18>
801048d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048d7:	90                   	nop
  }
}
801048d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048db:	5b                   	pop    %ebx
801048dc:	5e                   	pop    %esi
801048dd:	5f                   	pop    %edi
801048de:	5d                   	pop    %ebp
801048df:	c3                   	ret    

801048e0 <find_digital_root>:

int find_digital_root(int num)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
801048e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while (num >= 10)
801048e8:	83 fb 09             	cmp    $0x9,%ebx
801048eb:	7e 2e                	jle    8010491b <find_digital_root+0x3b>
  {
    int temp = num;
    int res = 0;
    while (temp != 0)
    {
      int current_dig = temp % 10;
801048ed:	be cd cc cc cc       	mov    $0xcccccccd,%esi
801048f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801048f8:	89 d9                	mov    %ebx,%ecx
    int res = 0;
801048fa:	31 db                	xor    %ebx,%ebx
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      int current_dig = temp % 10;
80104900:	89 c8                	mov    %ecx,%eax
80104902:	f7 e6                	mul    %esi
80104904:	c1 ea 03             	shr    $0x3,%edx
80104907:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010490a:	01 c0                	add    %eax,%eax
8010490c:	29 c1                	sub    %eax,%ecx
      res += current_dig;
8010490e:	01 cb                	add    %ecx,%ebx
      temp /= 10;
80104910:	89 d1                	mov    %edx,%ecx
    while (temp != 0)
80104912:	85 d2                	test   %edx,%edx
80104914:	75 ea                	jne    80104900 <find_digital_root+0x20>
  while (num >= 10)
80104916:	83 fb 09             	cmp    $0x9,%ebx
80104919:	7f dd                	jg     801048f8 <find_digital_root+0x18>
    }
    num = res;
  }
  return num;
8010491b:	89 d8                	mov    %ebx,%eax
8010491d:	5b                   	pop    %ebx
8010491e:	5e                   	pop    %esi
8010491f:	5d                   	pop    %ebp
80104920:	c3                   	ret    
80104921:	66 90                	xchg   %ax,%ax
80104923:	66 90                	xchg   %ax,%ax
80104925:	66 90                	xchg   %ax,%ax
80104927:	66 90                	xchg   %ax,%ax
80104929:	66 90                	xchg   %ax,%ax
8010492b:	66 90                	xchg   %ax,%ax
8010492d:	66 90                	xchg   %ax,%ax
8010492f:	90                   	nop

80104930 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	53                   	push   %ebx
80104934:	83 ec 0c             	sub    $0xc,%esp
80104937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010493a:	68 64 85 10 80       	push   $0x80108564
8010493f:	8d 43 04             	lea    0x4(%ebx),%eax
80104942:	50                   	push   %eax
80104943:	e8 18 01 00 00       	call   80104a60 <initlock>
  lk->name = name;
80104948:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010494b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104951:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104954:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010495b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010495e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104961:	c9                   	leave  
80104962:	c3                   	ret    
80104963:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104970 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	56                   	push   %esi
80104974:	53                   	push   %ebx
80104975:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104978:	8d 73 04             	lea    0x4(%ebx),%esi
8010497b:	83 ec 0c             	sub    $0xc,%esp
8010497e:	56                   	push   %esi
8010497f:	e8 ac 02 00 00       	call   80104c30 <acquire>
  while (lk->locked) {
80104984:	8b 13                	mov    (%ebx),%edx
80104986:	83 c4 10             	add    $0x10,%esp
80104989:	85 d2                	test   %edx,%edx
8010498b:	74 16                	je     801049a3 <acquiresleep+0x33>
8010498d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104990:	83 ec 08             	sub    $0x8,%esp
80104993:	56                   	push   %esi
80104994:	53                   	push   %ebx
80104995:	e8 e6 fc ff ff       	call   80104680 <sleep>
  while (lk->locked) {
8010499a:	8b 03                	mov    (%ebx),%eax
8010499c:	83 c4 10             	add    $0x10,%esp
8010499f:	85 c0                	test   %eax,%eax
801049a1:	75 ed                	jne    80104990 <acquiresleep+0x20>
  }
  lk->locked = 1;
801049a3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801049a9:	e8 82 f0 ff ff       	call   80103a30 <myproc>
801049ae:	8b 40 10             	mov    0x10(%eax),%eax
801049b1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801049b4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801049b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049ba:	5b                   	pop    %ebx
801049bb:	5e                   	pop    %esi
801049bc:	5d                   	pop    %ebp
  release(&lk->lk);
801049bd:	e9 0e 02 00 00       	jmp    80104bd0 <release>
801049c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049d0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
801049d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049d8:	8d 73 04             	lea    0x4(%ebx),%esi
801049db:	83 ec 0c             	sub    $0xc,%esp
801049de:	56                   	push   %esi
801049df:	e8 4c 02 00 00       	call   80104c30 <acquire>
  lk->locked = 0;
801049e4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801049ea:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801049f1:	89 1c 24             	mov    %ebx,(%esp)
801049f4:	e8 47 fd ff ff       	call   80104740 <wakeup>
  release(&lk->lk);
801049f9:	89 75 08             	mov    %esi,0x8(%ebp)
801049fc:	83 c4 10             	add    $0x10,%esp
}
801049ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a02:	5b                   	pop    %ebx
80104a03:	5e                   	pop    %esi
80104a04:	5d                   	pop    %ebp
  release(&lk->lk);
80104a05:	e9 c6 01 00 00       	jmp    80104bd0 <release>
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a10 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	57                   	push   %edi
80104a14:	31 ff                	xor    %edi,%edi
80104a16:	56                   	push   %esi
80104a17:	53                   	push   %ebx
80104a18:	83 ec 18             	sub    $0x18,%esp
80104a1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104a1e:	8d 73 04             	lea    0x4(%ebx),%esi
80104a21:	56                   	push   %esi
80104a22:	e8 09 02 00 00       	call   80104c30 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a27:	8b 03                	mov    (%ebx),%eax
80104a29:	83 c4 10             	add    $0x10,%esp
80104a2c:	85 c0                	test   %eax,%eax
80104a2e:	75 18                	jne    80104a48 <holdingsleep+0x38>
  release(&lk->lk);
80104a30:	83 ec 0c             	sub    $0xc,%esp
80104a33:	56                   	push   %esi
80104a34:	e8 97 01 00 00       	call   80104bd0 <release>
  return r;
}
80104a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a3c:	89 f8                	mov    %edi,%eax
80104a3e:	5b                   	pop    %ebx
80104a3f:	5e                   	pop    %esi
80104a40:	5f                   	pop    %edi
80104a41:	5d                   	pop    %ebp
80104a42:	c3                   	ret    
80104a43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a47:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104a48:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a4b:	e8 e0 ef ff ff       	call   80103a30 <myproc>
80104a50:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a53:	0f 94 c0             	sete   %al
80104a56:	0f b6 c0             	movzbl %al,%eax
80104a59:	89 c7                	mov    %eax,%edi
80104a5b:	eb d3                	jmp    80104a30 <holdingsleep+0x20>
80104a5d:	66 90                	xchg   %ax,%ax
80104a5f:	90                   	nop

80104a60 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a66:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a6f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a72:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a79:	5d                   	pop    %ebp
80104a7a:	c3                   	ret    
80104a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a7f:	90                   	nop

80104a80 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a80:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a81:	31 d2                	xor    %edx,%edx
{
80104a83:	89 e5                	mov    %esp,%ebp
80104a85:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104a86:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104a89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104a8c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104a8f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a90:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a96:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a9c:	77 1a                	ja     80104ab8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a9e:	8b 58 04             	mov    0x4(%eax),%ebx
80104aa1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104aa4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104aa7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104aa9:	83 fa 0a             	cmp    $0xa,%edx
80104aac:	75 e2                	jne    80104a90 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104aae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab1:	c9                   	leave  
80104ab2:	c3                   	ret    
80104ab3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ab7:	90                   	nop
  for(; i < 10; i++)
80104ab8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104abb:	8d 51 28             	lea    0x28(%ecx),%edx
80104abe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ac0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ac6:	83 c0 04             	add    $0x4,%eax
80104ac9:	39 d0                	cmp    %edx,%eax
80104acb:	75 f3                	jne    80104ac0 <getcallerpcs+0x40>
}
80104acd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad0:	c9                   	leave  
80104ad1:	c3                   	ret    
80104ad2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ae0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 04             	sub    $0x4,%esp
80104ae7:	9c                   	pushf  
80104ae8:	5b                   	pop    %ebx
  asm volatile("cli");
80104ae9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104aea:	e8 41 ee ff ff       	call   80103930 <mycpu>
80104aef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104af5:	85 c0                	test   %eax,%eax
80104af7:	74 17                	je     80104b10 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104af9:	e8 32 ee ff ff       	call   80103930 <mycpu>
80104afe:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b08:	c9                   	leave  
80104b09:	c3                   	ret    
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104b10:	e8 1b ee ff ff       	call   80103930 <mycpu>
80104b15:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b1b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104b21:	eb d6                	jmp    80104af9 <pushcli+0x19>
80104b23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b30 <popcli>:

void
popcli(void)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b36:	9c                   	pushf  
80104b37:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b38:	f6 c4 02             	test   $0x2,%ah
80104b3b:	75 35                	jne    80104b72 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b3d:	e8 ee ed ff ff       	call   80103930 <mycpu>
80104b42:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b49:	78 34                	js     80104b7f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b4b:	e8 e0 ed ff ff       	call   80103930 <mycpu>
80104b50:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b56:	85 d2                	test   %edx,%edx
80104b58:	74 06                	je     80104b60 <popcli+0x30>
    sti();
}
80104b5a:	c9                   	leave  
80104b5b:	c3                   	ret    
80104b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b60:	e8 cb ed ff ff       	call   80103930 <mycpu>
80104b65:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b6b:	85 c0                	test   %eax,%eax
80104b6d:	74 eb                	je     80104b5a <popcli+0x2a>
  asm volatile("sti");
80104b6f:	fb                   	sti    
}
80104b70:	c9                   	leave  
80104b71:	c3                   	ret    
    panic("popcli - interruptible");
80104b72:	83 ec 0c             	sub    $0xc,%esp
80104b75:	68 6f 85 10 80       	push   $0x8010856f
80104b7a:	e8 01 b8 ff ff       	call   80100380 <panic>
    panic("popcli");
80104b7f:	83 ec 0c             	sub    $0xc,%esp
80104b82:	68 86 85 10 80       	push   $0x80108586
80104b87:	e8 f4 b7 ff ff       	call   80100380 <panic>
80104b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b90 <holding>:
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	56                   	push   %esi
80104b94:	53                   	push   %ebx
80104b95:	8b 75 08             	mov    0x8(%ebp),%esi
80104b98:	31 db                	xor    %ebx,%ebx
  pushcli();
80104b9a:	e8 41 ff ff ff       	call   80104ae0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104b9f:	8b 06                	mov    (%esi),%eax
80104ba1:	85 c0                	test   %eax,%eax
80104ba3:	75 0b                	jne    80104bb0 <holding+0x20>
  popcli();
80104ba5:	e8 86 ff ff ff       	call   80104b30 <popcli>
}
80104baa:	89 d8                	mov    %ebx,%eax
80104bac:	5b                   	pop    %ebx
80104bad:	5e                   	pop    %esi
80104bae:	5d                   	pop    %ebp
80104baf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104bb0:	8b 5e 08             	mov    0x8(%esi),%ebx
80104bb3:	e8 78 ed ff ff       	call   80103930 <mycpu>
80104bb8:	39 c3                	cmp    %eax,%ebx
80104bba:	0f 94 c3             	sete   %bl
  popcli();
80104bbd:	e8 6e ff ff ff       	call   80104b30 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104bc2:	0f b6 db             	movzbl %bl,%ebx
}
80104bc5:	89 d8                	mov    %ebx,%eax
80104bc7:	5b                   	pop    %ebx
80104bc8:	5e                   	pop    %esi
80104bc9:	5d                   	pop    %ebp
80104bca:	c3                   	ret    
80104bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bcf:	90                   	nop

80104bd0 <release>:
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	53                   	push   %ebx
80104bd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104bd8:	e8 03 ff ff ff       	call   80104ae0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104bdd:	8b 03                	mov    (%ebx),%eax
80104bdf:	85 c0                	test   %eax,%eax
80104be1:	75 15                	jne    80104bf8 <release+0x28>
  popcli();
80104be3:	e8 48 ff ff ff       	call   80104b30 <popcli>
    panic("release");
80104be8:	83 ec 0c             	sub    $0xc,%esp
80104beb:	68 8d 85 10 80       	push   $0x8010858d
80104bf0:	e8 8b b7 ff ff       	call   80100380 <panic>
80104bf5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104bf8:	8b 73 08             	mov    0x8(%ebx),%esi
80104bfb:	e8 30 ed ff ff       	call   80103930 <mycpu>
80104c00:	39 c6                	cmp    %eax,%esi
80104c02:	75 df                	jne    80104be3 <release+0x13>
  popcli();
80104c04:	e8 27 ff ff ff       	call   80104b30 <popcli>
  lk->pcs[0] = 0;
80104c09:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104c10:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104c17:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104c1c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104c22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c25:	5b                   	pop    %ebx
80104c26:	5e                   	pop    %esi
80104c27:	5d                   	pop    %ebp
  popcli();
80104c28:	e9 03 ff ff ff       	jmp    80104b30 <popcli>
80104c2d:	8d 76 00             	lea    0x0(%esi),%esi

80104c30 <acquire>:
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	53                   	push   %ebx
80104c34:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104c37:	e8 a4 fe ff ff       	call   80104ae0 <pushcli>
  if(holding(lk))
80104c3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104c3f:	e8 9c fe ff ff       	call   80104ae0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104c44:	8b 03                	mov    (%ebx),%eax
80104c46:	85 c0                	test   %eax,%eax
80104c48:	75 7e                	jne    80104cc8 <acquire+0x98>
  popcli();
80104c4a:	e8 e1 fe ff ff       	call   80104b30 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104c4f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104c58:	8b 55 08             	mov    0x8(%ebp),%edx
80104c5b:	89 c8                	mov    %ecx,%eax
80104c5d:	f0 87 02             	lock xchg %eax,(%edx)
80104c60:	85 c0                	test   %eax,%eax
80104c62:	75 f4                	jne    80104c58 <acquire+0x28>
  __sync_synchronize();
80104c64:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104c69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c6c:	e8 bf ec ff ff       	call   80103930 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104c71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c74:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104c76:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104c79:	31 c0                	xor    %eax,%eax
80104c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c7f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c80:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104c86:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c8c:	77 1a                	ja     80104ca8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104c8e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104c91:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104c95:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104c98:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104c9a:	83 f8 0a             	cmp    $0xa,%eax
80104c9d:	75 e1                	jne    80104c80 <acquire+0x50>
}
80104c9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca2:	c9                   	leave  
80104ca3:	c3                   	ret    
80104ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104ca8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104cac:	8d 51 34             	lea    0x34(%ecx),%edx
80104caf:	90                   	nop
    pcs[i] = 0;
80104cb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104cb6:	83 c0 04             	add    $0x4,%eax
80104cb9:	39 c2                	cmp    %eax,%edx
80104cbb:	75 f3                	jne    80104cb0 <acquire+0x80>
}
80104cbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cc0:	c9                   	leave  
80104cc1:	c3                   	ret    
80104cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104cc8:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104ccb:	e8 60 ec ff ff       	call   80103930 <mycpu>
80104cd0:	39 c3                	cmp    %eax,%ebx
80104cd2:	0f 85 72 ff ff ff    	jne    80104c4a <acquire+0x1a>
  popcli();
80104cd8:	e8 53 fe ff ff       	call   80104b30 <popcli>
    panic("acquire");
80104cdd:	83 ec 0c             	sub    $0xc,%esp
80104ce0:	68 95 85 10 80       	push   $0x80108595
80104ce5:	e8 96 b6 ff ff       	call   80100380 <panic>
80104cea:	66 90                	xchg   %ax,%ax
80104cec:	66 90                	xchg   %ax,%ax
80104cee:	66 90                	xchg   %ax,%ax

80104cf0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	8b 55 08             	mov    0x8(%ebp),%edx
80104cf7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104cfa:	53                   	push   %ebx
80104cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104cfe:	89 d7                	mov    %edx,%edi
80104d00:	09 cf                	or     %ecx,%edi
80104d02:	83 e7 03             	and    $0x3,%edi
80104d05:	75 29                	jne    80104d30 <memset+0x40>
    c &= 0xFF;
80104d07:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104d0a:	c1 e0 18             	shl    $0x18,%eax
80104d0d:	89 fb                	mov    %edi,%ebx
80104d0f:	c1 e9 02             	shr    $0x2,%ecx
80104d12:	c1 e3 10             	shl    $0x10,%ebx
80104d15:	09 d8                	or     %ebx,%eax
80104d17:	09 f8                	or     %edi,%eax
80104d19:	c1 e7 08             	shl    $0x8,%edi
80104d1c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104d1e:	89 d7                	mov    %edx,%edi
80104d20:	fc                   	cld    
80104d21:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104d23:	5b                   	pop    %ebx
80104d24:	89 d0                	mov    %edx,%eax
80104d26:	5f                   	pop    %edi
80104d27:	5d                   	pop    %ebp
80104d28:	c3                   	ret    
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104d30:	89 d7                	mov    %edx,%edi
80104d32:	fc                   	cld    
80104d33:	f3 aa                	rep stos %al,%es:(%edi)
80104d35:	5b                   	pop    %ebx
80104d36:	89 d0                	mov    %edx,%eax
80104d38:	5f                   	pop    %edi
80104d39:	5d                   	pop    %ebp
80104d3a:	c3                   	ret    
80104d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d3f:	90                   	nop

80104d40 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	8b 75 10             	mov    0x10(%ebp),%esi
80104d47:	8b 55 08             	mov    0x8(%ebp),%edx
80104d4a:	53                   	push   %ebx
80104d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d4e:	85 f6                	test   %esi,%esi
80104d50:	74 2e                	je     80104d80 <memcmp+0x40>
80104d52:	01 c6                	add    %eax,%esi
80104d54:	eb 14                	jmp    80104d6a <memcmp+0x2a>
80104d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104d60:	83 c0 01             	add    $0x1,%eax
80104d63:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104d66:	39 f0                	cmp    %esi,%eax
80104d68:	74 16                	je     80104d80 <memcmp+0x40>
    if(*s1 != *s2)
80104d6a:	0f b6 0a             	movzbl (%edx),%ecx
80104d6d:	0f b6 18             	movzbl (%eax),%ebx
80104d70:	38 d9                	cmp    %bl,%cl
80104d72:	74 ec                	je     80104d60 <memcmp+0x20>
      return *s1 - *s2;
80104d74:	0f b6 c1             	movzbl %cl,%eax
80104d77:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104d79:	5b                   	pop    %ebx
80104d7a:	5e                   	pop    %esi
80104d7b:	5d                   	pop    %ebp
80104d7c:	c3                   	ret    
80104d7d:	8d 76 00             	lea    0x0(%esi),%esi
80104d80:	5b                   	pop    %ebx
  return 0;
80104d81:	31 c0                	xor    %eax,%eax
}
80104d83:	5e                   	pop    %esi
80104d84:	5d                   	pop    %ebp
80104d85:	c3                   	ret    
80104d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi

80104d90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	57                   	push   %edi
80104d94:	8b 55 08             	mov    0x8(%ebp),%edx
80104d97:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d9a:	56                   	push   %esi
80104d9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d9e:	39 d6                	cmp    %edx,%esi
80104da0:	73 26                	jae    80104dc8 <memmove+0x38>
80104da2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104da5:	39 fa                	cmp    %edi,%edx
80104da7:	73 1f                	jae    80104dc8 <memmove+0x38>
80104da9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104dac:	85 c9                	test   %ecx,%ecx
80104dae:	74 0c                	je     80104dbc <memmove+0x2c>
      *--d = *--s;
80104db0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104db4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104db7:	83 e8 01             	sub    $0x1,%eax
80104dba:	73 f4                	jae    80104db0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104dbc:	5e                   	pop    %esi
80104dbd:	89 d0                	mov    %edx,%eax
80104dbf:	5f                   	pop    %edi
80104dc0:	5d                   	pop    %ebp
80104dc1:	c3                   	ret    
80104dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104dc8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104dcb:	89 d7                	mov    %edx,%edi
80104dcd:	85 c9                	test   %ecx,%ecx
80104dcf:	74 eb                	je     80104dbc <memmove+0x2c>
80104dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104dd8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104dd9:	39 c6                	cmp    %eax,%esi
80104ddb:	75 fb                	jne    80104dd8 <memmove+0x48>
}
80104ddd:	5e                   	pop    %esi
80104dde:	89 d0                	mov    %edx,%eax
80104de0:	5f                   	pop    %edi
80104de1:	5d                   	pop    %ebp
80104de2:	c3                   	ret    
80104de3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104df0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104df0:	eb 9e                	jmp    80104d90 <memmove>
80104df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e00 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	56                   	push   %esi
80104e04:	8b 75 10             	mov    0x10(%ebp),%esi
80104e07:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e0a:	53                   	push   %ebx
80104e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104e0e:	85 f6                	test   %esi,%esi
80104e10:	74 2e                	je     80104e40 <strncmp+0x40>
80104e12:	01 d6                	add    %edx,%esi
80104e14:	eb 18                	jmp    80104e2e <strncmp+0x2e>
80104e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi
80104e20:	38 d8                	cmp    %bl,%al
80104e22:	75 14                	jne    80104e38 <strncmp+0x38>
    n--, p++, q++;
80104e24:	83 c2 01             	add    $0x1,%edx
80104e27:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e2a:	39 f2                	cmp    %esi,%edx
80104e2c:	74 12                	je     80104e40 <strncmp+0x40>
80104e2e:	0f b6 01             	movzbl (%ecx),%eax
80104e31:	0f b6 1a             	movzbl (%edx),%ebx
80104e34:	84 c0                	test   %al,%al
80104e36:	75 e8                	jne    80104e20 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104e38:	29 d8                	sub    %ebx,%eax
}
80104e3a:	5b                   	pop    %ebx
80104e3b:	5e                   	pop    %esi
80104e3c:	5d                   	pop    %ebp
80104e3d:	c3                   	ret    
80104e3e:	66 90                	xchg   %ax,%ax
80104e40:	5b                   	pop    %ebx
    return 0;
80104e41:	31 c0                	xor    %eax,%eax
}
80104e43:	5e                   	pop    %esi
80104e44:	5d                   	pop    %ebp
80104e45:	c3                   	ret    
80104e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4d:	8d 76 00             	lea    0x0(%esi),%esi

80104e50 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	57                   	push   %edi
80104e54:	56                   	push   %esi
80104e55:	8b 75 08             	mov    0x8(%ebp),%esi
80104e58:	53                   	push   %ebx
80104e59:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e5c:	89 f0                	mov    %esi,%eax
80104e5e:	eb 15                	jmp    80104e75 <strncpy+0x25>
80104e60:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104e64:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104e67:	83 c0 01             	add    $0x1,%eax
80104e6a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104e6e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104e71:	84 d2                	test   %dl,%dl
80104e73:	74 09                	je     80104e7e <strncpy+0x2e>
80104e75:	89 cb                	mov    %ecx,%ebx
80104e77:	83 e9 01             	sub    $0x1,%ecx
80104e7a:	85 db                	test   %ebx,%ebx
80104e7c:	7f e2                	jg     80104e60 <strncpy+0x10>
    ;
  while(n-- > 0)
80104e7e:	89 c2                	mov    %eax,%edx
80104e80:	85 c9                	test   %ecx,%ecx
80104e82:	7e 17                	jle    80104e9b <strncpy+0x4b>
80104e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104e88:	83 c2 01             	add    $0x1,%edx
80104e8b:	89 c1                	mov    %eax,%ecx
80104e8d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104e91:	29 d1                	sub    %edx,%ecx
80104e93:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104e97:	85 c9                	test   %ecx,%ecx
80104e99:	7f ed                	jg     80104e88 <strncpy+0x38>
  return os;
}
80104e9b:	5b                   	pop    %ebx
80104e9c:	89 f0                	mov    %esi,%eax
80104e9e:	5e                   	pop    %esi
80104e9f:	5f                   	pop    %edi
80104ea0:	5d                   	pop    %ebp
80104ea1:	c3                   	ret    
80104ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104eb0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	56                   	push   %esi
80104eb4:	8b 55 10             	mov    0x10(%ebp),%edx
80104eb7:	8b 75 08             	mov    0x8(%ebp),%esi
80104eba:	53                   	push   %ebx
80104ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104ebe:	85 d2                	test   %edx,%edx
80104ec0:	7e 25                	jle    80104ee7 <safestrcpy+0x37>
80104ec2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104ec6:	89 f2                	mov    %esi,%edx
80104ec8:	eb 16                	jmp    80104ee0 <safestrcpy+0x30>
80104eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ed0:	0f b6 08             	movzbl (%eax),%ecx
80104ed3:	83 c0 01             	add    $0x1,%eax
80104ed6:	83 c2 01             	add    $0x1,%edx
80104ed9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104edc:	84 c9                	test   %cl,%cl
80104ede:	74 04                	je     80104ee4 <safestrcpy+0x34>
80104ee0:	39 d8                	cmp    %ebx,%eax
80104ee2:	75 ec                	jne    80104ed0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ee4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104ee7:	89 f0                	mov    %esi,%eax
80104ee9:	5b                   	pop    %ebx
80104eea:	5e                   	pop    %esi
80104eeb:	5d                   	pop    %ebp
80104eec:	c3                   	ret    
80104eed:	8d 76 00             	lea    0x0(%esi),%esi

80104ef0 <strlen>:

int
strlen(const char *s)
{
80104ef0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ef1:	31 c0                	xor    %eax,%eax
{
80104ef3:	89 e5                	mov    %esp,%ebp
80104ef5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ef8:	80 3a 00             	cmpb   $0x0,(%edx)
80104efb:	74 0c                	je     80104f09 <strlen+0x19>
80104efd:	8d 76 00             	lea    0x0(%esi),%esi
80104f00:	83 c0 01             	add    $0x1,%eax
80104f03:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f07:	75 f7                	jne    80104f00 <strlen+0x10>
    ;
  return n;
}
80104f09:	5d                   	pop    %ebp
80104f0a:	c3                   	ret    

80104f0b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f0b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f0f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104f13:	55                   	push   %ebp
  pushl %ebx
80104f14:	53                   	push   %ebx
  pushl %esi
80104f15:	56                   	push   %esi
  pushl %edi
80104f16:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f17:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f19:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f1b:	5f                   	pop    %edi
  popl %esi
80104f1c:	5e                   	pop    %esi
  popl %ebx
80104f1d:	5b                   	pop    %ebx
  popl %ebp
80104f1e:	5d                   	pop    %ebp
  ret
80104f1f:	c3                   	ret    

80104f20 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	53                   	push   %ebx
80104f24:	83 ec 04             	sub    $0x4,%esp
80104f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f2a:	e8 01 eb ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f2f:	8b 00                	mov    (%eax),%eax
80104f31:	39 d8                	cmp    %ebx,%eax
80104f33:	76 1b                	jbe    80104f50 <fetchint+0x30>
80104f35:	8d 53 04             	lea    0x4(%ebx),%edx
80104f38:	39 d0                	cmp    %edx,%eax
80104f3a:	72 14                	jb     80104f50 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f3f:	8b 13                	mov    (%ebx),%edx
80104f41:	89 10                	mov    %edx,(%eax)
  return 0;
80104f43:	31 c0                	xor    %eax,%eax
}
80104f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f48:	c9                   	leave  
80104f49:	c3                   	ret    
80104f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f55:	eb ee                	jmp    80104f45 <fetchint+0x25>
80104f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5e:	66 90                	xchg   %ax,%ax

80104f60 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	53                   	push   %ebx
80104f64:	83 ec 04             	sub    $0x4,%esp
80104f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f6a:	e8 c1 ea ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz)
80104f6f:	39 18                	cmp    %ebx,(%eax)
80104f71:	76 2d                	jbe    80104fa0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104f73:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f76:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104f78:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104f7a:	39 d3                	cmp    %edx,%ebx
80104f7c:	73 22                	jae    80104fa0 <fetchstr+0x40>
80104f7e:	89 d8                	mov    %ebx,%eax
80104f80:	eb 0d                	jmp    80104f8f <fetchstr+0x2f>
80104f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f88:	83 c0 01             	add    $0x1,%eax
80104f8b:	39 c2                	cmp    %eax,%edx
80104f8d:	76 11                	jbe    80104fa0 <fetchstr+0x40>
    if(*s == 0)
80104f8f:	80 38 00             	cmpb   $0x0,(%eax)
80104f92:	75 f4                	jne    80104f88 <fetchstr+0x28>
      return s - *pp;
80104f94:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104f96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f99:	c9                   	leave  
80104f9a:	c3                   	ret    
80104f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f9f:	90                   	nop
80104fa0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104fa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fa8:	c9                   	leave  
80104fa9:	c3                   	ret    
80104faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fb0 <fetchfloat>:
int
fetchfloat(uint addr, float *fp)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	53                   	push   %ebx
80104fb4:	83 ec 04             	sub    $0x4,%esp
80104fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104fba:	e8 71 ea ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fbf:	8b 00                	mov    (%eax),%eax
80104fc1:	39 d8                	cmp    %ebx,%eax
80104fc3:	76 1b                	jbe    80104fe0 <fetchfloat+0x30>
80104fc5:	8d 53 04             	lea    0x4(%ebx),%edx
80104fc8:	39 d0                	cmp    %edx,%eax
80104fca:	72 14                	jb     80104fe0 <fetchfloat+0x30>
    return -1;
  *fp = *(float*)(addr);
80104fcc:	d9 03                	flds   (%ebx)
80104fce:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fd1:	d9 18                	fstps  (%eax)
  return 0;
80104fd3:	31 c0                	xor    %eax,%eax
}
80104fd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fd8:	c9                   	leave  
80104fd9:	c3                   	ret    
80104fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fe5:	eb ee                	jmp    80104fd5 <fetchfloat+0x25>
80104fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fee:	66 90                	xchg   %ax,%ax

80104ff0 <argint>:
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ff5:	e8 36 ea ff ff       	call   80103a30 <myproc>
80104ffa:	8b 55 08             	mov    0x8(%ebp),%edx
80104ffd:	8b 40 18             	mov    0x18(%eax),%eax
80105000:	8b 40 44             	mov    0x44(%eax),%eax
80105003:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105006:	e8 25 ea ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010500b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010500e:	8b 00                	mov    (%eax),%eax
80105010:	39 c6                	cmp    %eax,%esi
80105012:	73 1c                	jae    80105030 <argint+0x40>
80105014:	8d 53 08             	lea    0x8(%ebx),%edx
80105017:	39 d0                	cmp    %edx,%eax
80105019:	72 15                	jb     80105030 <argint+0x40>
  *ip = *(int*)(addr);
8010501b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010501e:	8b 53 04             	mov    0x4(%ebx),%edx
80105021:	89 10                	mov    %edx,(%eax)
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
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105035:	eb ee                	jmp    80105025 <argint+0x35>
80105037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503e:	66 90                	xchg   %ax,%ax

80105040 <argf>:
int
argf(int n, float *fp)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	56                   	push   %esi
80105044:	53                   	push   %ebx
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105045:	e8 e6 e9 ff ff       	call   80103a30 <myproc>
8010504a:	8b 55 08             	mov    0x8(%ebp),%edx
8010504d:	8b 40 18             	mov    0x18(%eax),%eax
80105050:	8b 40 44             	mov    0x44(%eax),%eax
80105053:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105056:	e8 d5 e9 ff ff       	call   80103a30 <myproc>
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
8010505b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010505e:	8b 00                	mov    (%eax),%eax
80105060:	39 c6                	cmp    %eax,%esi
80105062:	73 1c                	jae    80105080 <argf+0x40>
80105064:	8d 53 08             	lea    0x8(%ebx),%edx
80105067:	39 d0                	cmp    %edx,%eax
80105069:	72 15                	jb     80105080 <argf+0x40>
  *fp = *(float*)(addr);
8010506b:	d9 43 04             	flds   0x4(%ebx)
8010506e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105071:	d9 18                	fstps  (%eax)
  return 0;
80105073:	31 c0                	xor    %eax,%eax
}
80105075:	5b                   	pop    %ebx
80105076:	5e                   	pop    %esi
80105077:	5d                   	pop    %ebp
80105078:	c3                   	ret    
80105079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105085:	eb ee                	jmp    80105075 <argf+0x35>
80105087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508e:	66 90                	xchg   %ax,%ax

80105090 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	57                   	push   %edi
80105094:	56                   	push   %esi
80105095:	53                   	push   %ebx
80105096:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105099:	e8 92 e9 ff ff       	call   80103a30 <myproc>
8010509e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050a0:	e8 8b e9 ff ff       	call   80103a30 <myproc>
801050a5:	8b 55 08             	mov    0x8(%ebp),%edx
801050a8:	8b 40 18             	mov    0x18(%eax),%eax
801050ab:	8b 40 44             	mov    0x44(%eax),%eax
801050ae:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801050b1:	e8 7a e9 ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050b6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050b9:	8b 00                	mov    (%eax),%eax
801050bb:	39 c7                	cmp    %eax,%edi
801050bd:	73 31                	jae    801050f0 <argptr+0x60>
801050bf:	8d 4b 08             	lea    0x8(%ebx),%ecx
801050c2:	39 c8                	cmp    %ecx,%eax
801050c4:	72 2a                	jb     801050f0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801050c6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801050c9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801050cc:	85 d2                	test   %edx,%edx
801050ce:	78 20                	js     801050f0 <argptr+0x60>
801050d0:	8b 16                	mov    (%esi),%edx
801050d2:	39 c2                	cmp    %eax,%edx
801050d4:	76 1a                	jbe    801050f0 <argptr+0x60>
801050d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801050d9:	01 c3                	add    %eax,%ebx
801050db:	39 da                	cmp    %ebx,%edx
801050dd:	72 11                	jb     801050f0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801050df:	8b 55 0c             	mov    0xc(%ebp),%edx
801050e2:	89 02                	mov    %eax,(%edx)
  return 0;
801050e4:	31 c0                	xor    %eax,%eax
}
801050e6:	83 c4 0c             	add    $0xc,%esp
801050e9:	5b                   	pop    %ebx
801050ea:	5e                   	pop    %esi
801050eb:	5f                   	pop    %edi
801050ec:	5d                   	pop    %ebp
801050ed:	c3                   	ret    
801050ee:	66 90                	xchg   %ax,%ax
    return -1;
801050f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f5:	eb ef                	jmp    801050e6 <argptr+0x56>
801050f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050fe:	66 90                	xchg   %ax,%ax

80105100 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105105:	e8 26 e9 ff ff       	call   80103a30 <myproc>
8010510a:	8b 55 08             	mov    0x8(%ebp),%edx
8010510d:	8b 40 18             	mov    0x18(%eax),%eax
80105110:	8b 40 44             	mov    0x44(%eax),%eax
80105113:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105116:	e8 15 e9 ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010511b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010511e:	8b 00                	mov    (%eax),%eax
80105120:	39 c6                	cmp    %eax,%esi
80105122:	73 44                	jae    80105168 <argstr+0x68>
80105124:	8d 53 08             	lea    0x8(%ebx),%edx
80105127:	39 d0                	cmp    %edx,%eax
80105129:	72 3d                	jb     80105168 <argstr+0x68>
  *ip = *(int*)(addr);
8010512b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010512e:	e8 fd e8 ff ff       	call   80103a30 <myproc>
  if(addr >= curproc->sz)
80105133:	3b 18                	cmp    (%eax),%ebx
80105135:	73 31                	jae    80105168 <argstr+0x68>
  *pp = (char*)addr;
80105137:	8b 55 0c             	mov    0xc(%ebp),%edx
8010513a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010513c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010513e:	39 d3                	cmp    %edx,%ebx
80105140:	73 26                	jae    80105168 <argstr+0x68>
80105142:	89 d8                	mov    %ebx,%eax
80105144:	eb 11                	jmp    80105157 <argstr+0x57>
80105146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010514d:	8d 76 00             	lea    0x0(%esi),%esi
80105150:	83 c0 01             	add    $0x1,%eax
80105153:	39 c2                	cmp    %eax,%edx
80105155:	76 11                	jbe    80105168 <argstr+0x68>
    if(*s == 0)
80105157:	80 38 00             	cmpb   $0x0,(%eax)
8010515a:	75 f4                	jne    80105150 <argstr+0x50>
      return s - *pp;
8010515c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010515e:	5b                   	pop    %ebx
8010515f:	5e                   	pop    %esi
80105160:	5d                   	pop    %ebp
80105161:	c3                   	ret    
80105162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105168:	5b                   	pop    %ebx
    return -1;
80105169:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010516e:	5e                   	pop    %esi
8010516f:	5d                   	pop    %ebp
80105170:	c3                   	ret    
80105171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105178:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010517f:	90                   	nop

80105180 <syscall>:
[SYS_print_info] sys_print_info
};

void
syscall(void)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	53                   	push   %ebx
80105184:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105187:	e8 a4 e8 ff ff       	call   80103a30 <myproc>
8010518c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010518e:	8b 40 18             	mov    0x18(%eax),%eax
80105191:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105194:	8d 50 ff             	lea    -0x1(%eax),%edx
80105197:	83 fa 1f             	cmp    $0x1f,%edx
8010519a:	77 24                	ja     801051c0 <syscall+0x40>
8010519c:	8b 14 85 c0 85 10 80 	mov    -0x7fef7a40(,%eax,4),%edx
801051a3:	85 d2                	test   %edx,%edx
801051a5:	74 19                	je     801051c0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801051a7:	ff d2                	call   *%edx
801051a9:	89 c2                	mov    %eax,%edx
801051ab:	8b 43 18             	mov    0x18(%ebx),%eax
801051ae:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801051b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051b4:	c9                   	leave  
801051b5:	c3                   	ret    
801051b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051bd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801051c0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801051c1:	8d 43 78             	lea    0x78(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801051c4:	50                   	push   %eax
801051c5:	ff 73 10             	push   0x10(%ebx)
801051c8:	68 9d 85 10 80       	push   $0x8010859d
801051cd:	e8 ce b4 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
801051d2:	8b 43 18             	mov    0x18(%ebx),%eax
801051d5:	83 c4 10             	add    $0x10,%esp
801051d8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801051df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051e2:	c9                   	leave  
801051e3:	c3                   	ret    
801051e4:	66 90                	xchg   %ax,%ax
801051e6:	66 90                	xchg   %ax,%ax
801051e8:	66 90                	xchg   %ax,%ax
801051ea:	66 90                	xchg   %ax,%ax
801051ec:	66 90                	xchg   %ax,%ax
801051ee:	66 90                	xchg   %ax,%ax

801051f0 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	57                   	push   %edi
801051f4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
801051f5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801051f8:	53                   	push   %ebx
801051f9:	83 ec 34             	sub    $0x34,%esp
801051fc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801051ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if ((dp = nameiparent(path, name)) == 0)
80105202:	57                   	push   %edi
80105203:	50                   	push   %eax
{
80105204:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105207:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if ((dp = nameiparent(path, name)) == 0)
8010520a:	e8 b1 ce ff ff       	call   801020c0 <nameiparent>
8010520f:	83 c4 10             	add    $0x10,%esp
80105212:	85 c0                	test   %eax,%eax
80105214:	0f 84 46 01 00 00    	je     80105360 <create+0x170>
    return 0;
  ilock(dp);
8010521a:	83 ec 0c             	sub    $0xc,%esp
8010521d:	89 c3                	mov    %eax,%ebx
8010521f:	50                   	push   %eax
80105220:	e8 5b c5 ff ff       	call   80101780 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
80105225:	83 c4 0c             	add    $0xc,%esp
80105228:	6a 00                	push   $0x0
8010522a:	57                   	push   %edi
8010522b:	53                   	push   %ebx
8010522c:	e8 af ca ff ff       	call   80101ce0 <dirlookup>
80105231:	83 c4 10             	add    $0x10,%esp
80105234:	89 c6                	mov    %eax,%esi
80105236:	85 c0                	test   %eax,%eax
80105238:	74 56                	je     80105290 <create+0xa0>
  {
    iunlockput(dp);
8010523a:	83 ec 0c             	sub    $0xc,%esp
8010523d:	53                   	push   %ebx
8010523e:	e8 cd c7 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80105243:	89 34 24             	mov    %esi,(%esp)
80105246:	e8 35 c5 ff ff       	call   80101780 <ilock>
    if (type == T_FILE && ip->type == T_FILE)
8010524b:	83 c4 10             	add    $0x10,%esp
8010524e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105253:	75 1b                	jne    80105270 <create+0x80>
80105255:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010525a:	75 14                	jne    80105270 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010525c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010525f:	89 f0                	mov    %esi,%eax
80105261:	5b                   	pop    %ebx
80105262:	5e                   	pop    %esi
80105263:	5f                   	pop    %edi
80105264:	5d                   	pop    %ebp
80105265:	c3                   	ret    
80105266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105270:	83 ec 0c             	sub    $0xc,%esp
80105273:	56                   	push   %esi
    return 0;
80105274:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105276:	e8 95 c7 ff ff       	call   80101a10 <iunlockput>
    return 0;
8010527b:	83 c4 10             	add    $0x10,%esp
}
8010527e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105281:	89 f0                	mov    %esi,%eax
80105283:	5b                   	pop    %ebx
80105284:	5e                   	pop    %esi
80105285:	5f                   	pop    %edi
80105286:	5d                   	pop    %ebp
80105287:	c3                   	ret    
80105288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010528f:	90                   	nop
  if ((ip = ialloc(dp->dev, type)) == 0)
80105290:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105294:	83 ec 08             	sub    $0x8,%esp
80105297:	50                   	push   %eax
80105298:	ff 33                	push   (%ebx)
8010529a:	e8 71 c3 ff ff       	call   80101610 <ialloc>
8010529f:	83 c4 10             	add    $0x10,%esp
801052a2:	89 c6                	mov    %eax,%esi
801052a4:	85 c0                	test   %eax,%eax
801052a6:	0f 84 cd 00 00 00    	je     80105379 <create+0x189>
  ilock(ip);
801052ac:	83 ec 0c             	sub    $0xc,%esp
801052af:	50                   	push   %eax
801052b0:	e8 cb c4 ff ff       	call   80101780 <ilock>
  ip->major = major;
801052b5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801052b9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801052bd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801052c1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801052c5:	b8 01 00 00 00       	mov    $0x1,%eax
801052ca:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801052ce:	89 34 24             	mov    %esi,(%esp)
801052d1:	e8 fa c3 ff ff       	call   801016d0 <iupdate>
  if (type == T_DIR)
801052d6:	83 c4 10             	add    $0x10,%esp
801052d9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801052de:	74 30                	je     80105310 <create+0x120>
  if (dirlink(dp, name, ip->inum) < 0)
801052e0:	83 ec 04             	sub    $0x4,%esp
801052e3:	ff 76 04             	push   0x4(%esi)
801052e6:	57                   	push   %edi
801052e7:	53                   	push   %ebx
801052e8:	e8 f3 cc ff ff       	call   80101fe0 <dirlink>
801052ed:	83 c4 10             	add    $0x10,%esp
801052f0:	85 c0                	test   %eax,%eax
801052f2:	78 78                	js     8010536c <create+0x17c>
  iunlockput(dp);
801052f4:	83 ec 0c             	sub    $0xc,%esp
801052f7:	53                   	push   %ebx
801052f8:	e8 13 c7 ff ff       	call   80101a10 <iunlockput>
  return ip;
801052fd:	83 c4 10             	add    $0x10,%esp
}
80105300:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105303:	89 f0                	mov    %esi,%eax
80105305:	5b                   	pop    %ebx
80105306:	5e                   	pop    %esi
80105307:	5f                   	pop    %edi
80105308:	5d                   	pop    %ebp
80105309:	c3                   	ret    
8010530a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105310:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++; // for ".."
80105313:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105318:	53                   	push   %ebx
80105319:	e8 b2 c3 ff ff       	call   801016d0 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010531e:	83 c4 0c             	add    $0xc,%esp
80105321:	ff 76 04             	push   0x4(%esi)
80105324:	68 60 86 10 80       	push   $0x80108660
80105329:	56                   	push   %esi
8010532a:	e8 b1 cc ff ff       	call   80101fe0 <dirlink>
8010532f:	83 c4 10             	add    $0x10,%esp
80105332:	85 c0                	test   %eax,%eax
80105334:	78 18                	js     8010534e <create+0x15e>
80105336:	83 ec 04             	sub    $0x4,%esp
80105339:	ff 73 04             	push   0x4(%ebx)
8010533c:	68 5f 86 10 80       	push   $0x8010865f
80105341:	56                   	push   %esi
80105342:	e8 99 cc ff ff       	call   80101fe0 <dirlink>
80105347:	83 c4 10             	add    $0x10,%esp
8010534a:	85 c0                	test   %eax,%eax
8010534c:	79 92                	jns    801052e0 <create+0xf0>
      panic("create dots");
8010534e:	83 ec 0c             	sub    $0xc,%esp
80105351:	68 53 86 10 80       	push   $0x80108653
80105356:	e8 25 b0 ff ff       	call   80100380 <panic>
8010535b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010535f:	90                   	nop
}
80105360:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105363:	31 f6                	xor    %esi,%esi
}
80105365:	5b                   	pop    %ebx
80105366:	89 f0                	mov    %esi,%eax
80105368:	5e                   	pop    %esi
80105369:	5f                   	pop    %edi
8010536a:	5d                   	pop    %ebp
8010536b:	c3                   	ret    
    panic("create: dirlink");
8010536c:	83 ec 0c             	sub    $0xc,%esp
8010536f:	68 62 86 10 80       	push   $0x80108662
80105374:	e8 07 b0 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105379:	83 ec 0c             	sub    $0xc,%esp
8010537c:	68 44 86 10 80       	push   $0x80108644
80105381:	e8 fa af ff ff       	call   80100380 <panic>
80105386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538d:	8d 76 00             	lea    0x0(%esi),%esi

80105390 <sys_dup>:
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	56                   	push   %esi
80105394:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105395:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105398:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010539b:	50                   	push   %eax
8010539c:	6a 00                	push   $0x0
8010539e:	e8 4d fc ff ff       	call   80104ff0 <argint>
801053a3:	83 c4 10             	add    $0x10,%esp
801053a6:	85 c0                	test   %eax,%eax
801053a8:	78 36                	js     801053e0 <sys_dup+0x50>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801053aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053ae:	77 30                	ja     801053e0 <sys_dup+0x50>
801053b0:	e8 7b e6 ff ff       	call   80103a30 <myproc>
801053b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053b8:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
801053bc:	85 f6                	test   %esi,%esi
801053be:	74 20                	je     801053e0 <sys_dup+0x50>
  struct proc *curproc = myproc();
801053c0:	e8 6b e6 ff ff       	call   80103a30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
801053c5:	31 db                	xor    %ebx,%ebx
801053c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ce:	66 90                	xchg   %ax,%ax
    if (curproc->ofile[fd] == 0)
801053d0:	8b 54 98 34          	mov    0x34(%eax,%ebx,4),%edx
801053d4:	85 d2                	test   %edx,%edx
801053d6:	74 18                	je     801053f0 <sys_dup+0x60>
  for (fd = 0; fd < NOFILE; fd++)
801053d8:	83 c3 01             	add    $0x1,%ebx
801053db:	83 fb 10             	cmp    $0x10,%ebx
801053de:	75 f0                	jne    801053d0 <sys_dup+0x40>
}
801053e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801053e3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801053e8:	89 d8                	mov    %ebx,%eax
801053ea:	5b                   	pop    %ebx
801053eb:	5e                   	pop    %esi
801053ec:	5d                   	pop    %ebp
801053ed:	c3                   	ret    
801053ee:	66 90                	xchg   %ax,%ax
  filedup(f);
801053f0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801053f3:	89 74 98 34          	mov    %esi,0x34(%eax,%ebx,4)
  filedup(f);
801053f7:	56                   	push   %esi
801053f8:	e8 a3 ba ff ff       	call   80100ea0 <filedup>
  return fd;
801053fd:	83 c4 10             	add    $0x10,%esp
}
80105400:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105403:	89 d8                	mov    %ebx,%eax
80105405:	5b                   	pop    %ebx
80105406:	5e                   	pop    %esi
80105407:	5d                   	pop    %ebp
80105408:	c3                   	ret    
80105409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105410 <sys_read>:
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	56                   	push   %esi
80105414:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105415:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105418:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010541b:	53                   	push   %ebx
8010541c:	6a 00                	push   $0x0
8010541e:	e8 cd fb ff ff       	call   80104ff0 <argint>
80105423:	83 c4 10             	add    $0x10,%esp
80105426:	85 c0                	test   %eax,%eax
80105428:	78 5e                	js     80105488 <sys_read+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010542a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010542e:	77 58                	ja     80105488 <sys_read+0x78>
80105430:	e8 fb e5 ff ff       	call   80103a30 <myproc>
80105435:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105438:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
8010543c:	85 f6                	test   %esi,%esi
8010543e:	74 48                	je     80105488 <sys_read+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105440:	83 ec 08             	sub    $0x8,%esp
80105443:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105446:	50                   	push   %eax
80105447:	6a 02                	push   $0x2
80105449:	e8 a2 fb ff ff       	call   80104ff0 <argint>
8010544e:	83 c4 10             	add    $0x10,%esp
80105451:	85 c0                	test   %eax,%eax
80105453:	78 33                	js     80105488 <sys_read+0x78>
80105455:	83 ec 04             	sub    $0x4,%esp
80105458:	ff 75 f0             	push   -0x10(%ebp)
8010545b:	53                   	push   %ebx
8010545c:	6a 01                	push   $0x1
8010545e:	e8 2d fc ff ff       	call   80105090 <argptr>
80105463:	83 c4 10             	add    $0x10,%esp
80105466:	85 c0                	test   %eax,%eax
80105468:	78 1e                	js     80105488 <sys_read+0x78>
  return fileread(f, p, n);
8010546a:	83 ec 04             	sub    $0x4,%esp
8010546d:	ff 75 f0             	push   -0x10(%ebp)
80105470:	ff 75 f4             	push   -0xc(%ebp)
80105473:	56                   	push   %esi
80105474:	e8 a7 bb ff ff       	call   80101020 <fileread>
80105479:	83 c4 10             	add    $0x10,%esp
}
8010547c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010547f:	5b                   	pop    %ebx
80105480:	5e                   	pop    %esi
80105481:	5d                   	pop    %ebp
80105482:	c3                   	ret    
80105483:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105487:	90                   	nop
    return -1;
80105488:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010548d:	eb ed                	jmp    8010547c <sys_read+0x6c>
8010548f:	90                   	nop

80105490 <sys_write>:
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	56                   	push   %esi
80105494:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105495:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105498:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010549b:	53                   	push   %ebx
8010549c:	6a 00                	push   $0x0
8010549e:	e8 4d fb ff ff       	call   80104ff0 <argint>
801054a3:	83 c4 10             	add    $0x10,%esp
801054a6:	85 c0                	test   %eax,%eax
801054a8:	78 5e                	js     80105508 <sys_write+0x78>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
801054aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054ae:	77 58                	ja     80105508 <sys_write+0x78>
801054b0:	e8 7b e5 ff ff       	call   80103a30 <myproc>
801054b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054b8:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
801054bc:	85 f6                	test   %esi,%esi
801054be:	74 48                	je     80105508 <sys_write+0x78>
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054c0:	83 ec 08             	sub    $0x8,%esp
801054c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054c6:	50                   	push   %eax
801054c7:	6a 02                	push   $0x2
801054c9:	e8 22 fb ff ff       	call   80104ff0 <argint>
801054ce:	83 c4 10             	add    $0x10,%esp
801054d1:	85 c0                	test   %eax,%eax
801054d3:	78 33                	js     80105508 <sys_write+0x78>
801054d5:	83 ec 04             	sub    $0x4,%esp
801054d8:	ff 75 f0             	push   -0x10(%ebp)
801054db:	53                   	push   %ebx
801054dc:	6a 01                	push   $0x1
801054de:	e8 ad fb ff ff       	call   80105090 <argptr>
801054e3:	83 c4 10             	add    $0x10,%esp
801054e6:	85 c0                	test   %eax,%eax
801054e8:	78 1e                	js     80105508 <sys_write+0x78>
  return filewrite(f, p, n);
801054ea:	83 ec 04             	sub    $0x4,%esp
801054ed:	ff 75 f0             	push   -0x10(%ebp)
801054f0:	ff 75 f4             	push   -0xc(%ebp)
801054f3:	56                   	push   %esi
801054f4:	e8 b7 bb ff ff       	call   801010b0 <filewrite>
801054f9:	83 c4 10             	add    $0x10,%esp
}
801054fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054ff:	5b                   	pop    %ebx
80105500:	5e                   	pop    %esi
80105501:	5d                   	pop    %ebp
80105502:	c3                   	ret    
80105503:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105507:	90                   	nop
    return -1;
80105508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010550d:	eb ed                	jmp    801054fc <sys_write+0x6c>
8010550f:	90                   	nop

80105510 <sys_close>:
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	56                   	push   %esi
80105514:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105515:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105518:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010551b:	50                   	push   %eax
8010551c:	6a 00                	push   $0x0
8010551e:	e8 cd fa ff ff       	call   80104ff0 <argint>
80105523:	83 c4 10             	add    $0x10,%esp
80105526:	85 c0                	test   %eax,%eax
80105528:	78 3e                	js     80105568 <sys_close+0x58>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010552a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010552e:	77 38                	ja     80105568 <sys_close+0x58>
80105530:	e8 fb e4 ff ff       	call   80103a30 <myproc>
80105535:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105538:	8d 5a 0c             	lea    0xc(%edx),%ebx
8010553b:	8b 74 98 04          	mov    0x4(%eax,%ebx,4),%esi
8010553f:	85 f6                	test   %esi,%esi
80105541:	74 25                	je     80105568 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105543:	e8 e8 e4 ff ff       	call   80103a30 <myproc>
  fileclose(f);
80105548:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010554b:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
80105552:	00 
  fileclose(f);
80105553:	56                   	push   %esi
80105554:	e8 97 b9 ff ff       	call   80100ef0 <fileclose>
  return 0;
80105559:	83 c4 10             	add    $0x10,%esp
8010555c:	31 c0                	xor    %eax,%eax
}
8010555e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105561:	5b                   	pop    %ebx
80105562:	5e                   	pop    %esi
80105563:	5d                   	pop    %ebp
80105564:	c3                   	ret    
80105565:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105568:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010556d:	eb ef                	jmp    8010555e <sys_close+0x4e>
8010556f:	90                   	nop

80105570 <sys_fstat>:
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	56                   	push   %esi
80105574:	53                   	push   %ebx
  if (argint(n, &fd) < 0)
80105575:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105578:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010557b:	53                   	push   %ebx
8010557c:	6a 00                	push   $0x0
8010557e:	e8 6d fa ff ff       	call   80104ff0 <argint>
80105583:	83 c4 10             	add    $0x10,%esp
80105586:	85 c0                	test   %eax,%eax
80105588:	78 46                	js     801055d0 <sys_fstat+0x60>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010558a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010558e:	77 40                	ja     801055d0 <sys_fstat+0x60>
80105590:	e8 9b e4 ff ff       	call   80103a30 <myproc>
80105595:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105598:	8b 74 90 34          	mov    0x34(%eax,%edx,4),%esi
8010559c:	85 f6                	test   %esi,%esi
8010559e:	74 30                	je     801055d0 <sys_fstat+0x60>
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
801055a0:	83 ec 04             	sub    $0x4,%esp
801055a3:	6a 14                	push   $0x14
801055a5:	53                   	push   %ebx
801055a6:	6a 01                	push   $0x1
801055a8:	e8 e3 fa ff ff       	call   80105090 <argptr>
801055ad:	83 c4 10             	add    $0x10,%esp
801055b0:	85 c0                	test   %eax,%eax
801055b2:	78 1c                	js     801055d0 <sys_fstat+0x60>
  return filestat(f, st);
801055b4:	83 ec 08             	sub    $0x8,%esp
801055b7:	ff 75 f4             	push   -0xc(%ebp)
801055ba:	56                   	push   %esi
801055bb:	e8 10 ba ff ff       	call   80100fd0 <filestat>
801055c0:	83 c4 10             	add    $0x10,%esp
}
801055c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055c6:	5b                   	pop    %ebx
801055c7:	5e                   	pop    %esi
801055c8:	5d                   	pop    %ebp
801055c9:	c3                   	ret    
801055ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801055d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055d5:	eb ec                	jmp    801055c3 <sys_fstat+0x53>
801055d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055de:	66 90                	xchg   %ax,%ax

801055e0 <sys_link>:
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	57                   	push   %edi
801055e4:	56                   	push   %esi
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055e5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801055e8:	53                   	push   %ebx
801055e9:	83 ec 34             	sub    $0x34,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055ec:	50                   	push   %eax
801055ed:	6a 00                	push   $0x0
801055ef:	e8 0c fb ff ff       	call   80105100 <argstr>
801055f4:	83 c4 10             	add    $0x10,%esp
801055f7:	85 c0                	test   %eax,%eax
801055f9:	0f 88 fb 00 00 00    	js     801056fa <sys_link+0x11a>
801055ff:	83 ec 08             	sub    $0x8,%esp
80105602:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105605:	50                   	push   %eax
80105606:	6a 01                	push   $0x1
80105608:	e8 f3 fa ff ff       	call   80105100 <argstr>
8010560d:	83 c4 10             	add    $0x10,%esp
80105610:	85 c0                	test   %eax,%eax
80105612:	0f 88 e2 00 00 00    	js     801056fa <sys_link+0x11a>
  begin_op();
80105618:	e8 43 d7 ff ff       	call   80102d60 <begin_op>
  if ((ip = namei(old)) == 0)
8010561d:	83 ec 0c             	sub    $0xc,%esp
80105620:	ff 75 d4             	push   -0x2c(%ebp)
80105623:	e8 78 ca ff ff       	call   801020a0 <namei>
80105628:	83 c4 10             	add    $0x10,%esp
8010562b:	89 c3                	mov    %eax,%ebx
8010562d:	85 c0                	test   %eax,%eax
8010562f:	0f 84 e4 00 00 00    	je     80105719 <sys_link+0x139>
  ilock(ip);
80105635:	83 ec 0c             	sub    $0xc,%esp
80105638:	50                   	push   %eax
80105639:	e8 42 c1 ff ff       	call   80101780 <ilock>
  if (ip->type == T_DIR)
8010563e:	83 c4 10             	add    $0x10,%esp
80105641:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105646:	0f 84 b5 00 00 00    	je     80105701 <sys_link+0x121>
  iupdate(ip);
8010564c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010564f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if ((dp = nameiparent(new, name)) == 0)
80105654:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105657:	53                   	push   %ebx
80105658:	e8 73 c0 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010565d:	89 1c 24             	mov    %ebx,(%esp)
80105660:	e8 fb c1 ff ff       	call   80101860 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
80105665:	58                   	pop    %eax
80105666:	5a                   	pop    %edx
80105667:	57                   	push   %edi
80105668:	ff 75 d0             	push   -0x30(%ebp)
8010566b:	e8 50 ca ff ff       	call   801020c0 <nameiparent>
80105670:	83 c4 10             	add    $0x10,%esp
80105673:	89 c6                	mov    %eax,%esi
80105675:	85 c0                	test   %eax,%eax
80105677:	74 5b                	je     801056d4 <sys_link+0xf4>
  ilock(dp);
80105679:	83 ec 0c             	sub    $0xc,%esp
8010567c:	50                   	push   %eax
8010567d:	e8 fe c0 ff ff       	call   80101780 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
80105682:	8b 03                	mov    (%ebx),%eax
80105684:	83 c4 10             	add    $0x10,%esp
80105687:	39 06                	cmp    %eax,(%esi)
80105689:	75 3d                	jne    801056c8 <sys_link+0xe8>
8010568b:	83 ec 04             	sub    $0x4,%esp
8010568e:	ff 73 04             	push   0x4(%ebx)
80105691:	57                   	push   %edi
80105692:	56                   	push   %esi
80105693:	e8 48 c9 ff ff       	call   80101fe0 <dirlink>
80105698:	83 c4 10             	add    $0x10,%esp
8010569b:	85 c0                	test   %eax,%eax
8010569d:	78 29                	js     801056c8 <sys_link+0xe8>
  iunlockput(dp);
8010569f:	83 ec 0c             	sub    $0xc,%esp
801056a2:	56                   	push   %esi
801056a3:	e8 68 c3 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
801056a8:	89 1c 24             	mov    %ebx,(%esp)
801056ab:	e8 00 c2 ff ff       	call   801018b0 <iput>
  end_op();
801056b0:	e8 1b d7 ff ff       	call   80102dd0 <end_op>
  return 0;
801056b5:	83 c4 10             	add    $0x10,%esp
801056b8:	31 c0                	xor    %eax,%eax
}
801056ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056bd:	5b                   	pop    %ebx
801056be:	5e                   	pop    %esi
801056bf:	5f                   	pop    %edi
801056c0:	5d                   	pop    %ebp
801056c1:	c3                   	ret    
801056c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801056c8:	83 ec 0c             	sub    $0xc,%esp
801056cb:	56                   	push   %esi
801056cc:	e8 3f c3 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801056d1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801056d4:	83 ec 0c             	sub    $0xc,%esp
801056d7:	53                   	push   %ebx
801056d8:	e8 a3 c0 ff ff       	call   80101780 <ilock>
  ip->nlink--;
801056dd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801056e2:	89 1c 24             	mov    %ebx,(%esp)
801056e5:	e8 e6 bf ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801056ea:	89 1c 24             	mov    %ebx,(%esp)
801056ed:	e8 1e c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
801056f2:	e8 d9 d6 ff ff       	call   80102dd0 <end_op>
  return -1;
801056f7:	83 c4 10             	add    $0x10,%esp
801056fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ff:	eb b9                	jmp    801056ba <sys_link+0xda>
    iunlockput(ip);
80105701:	83 ec 0c             	sub    $0xc,%esp
80105704:	53                   	push   %ebx
80105705:	e8 06 c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010570a:	e8 c1 d6 ff ff       	call   80102dd0 <end_op>
    return -1;
8010570f:	83 c4 10             	add    $0x10,%esp
80105712:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105717:	eb a1                	jmp    801056ba <sys_link+0xda>
    end_op();
80105719:	e8 b2 d6 ff ff       	call   80102dd0 <end_op>
    return -1;
8010571e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105723:	eb 95                	jmp    801056ba <sys_link+0xda>
80105725:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_unlink>:
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	57                   	push   %edi
80105734:	56                   	push   %esi
  if (argstr(0, &path) < 0)
80105735:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105738:	53                   	push   %ebx
80105739:	83 ec 54             	sub    $0x54,%esp
  if (argstr(0, &path) < 0)
8010573c:	50                   	push   %eax
8010573d:	6a 00                	push   $0x0
8010573f:	e8 bc f9 ff ff       	call   80105100 <argstr>
80105744:	83 c4 10             	add    $0x10,%esp
80105747:	85 c0                	test   %eax,%eax
80105749:	0f 88 7a 01 00 00    	js     801058c9 <sys_unlink+0x199>
  begin_op();
8010574f:	e8 0c d6 ff ff       	call   80102d60 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
80105754:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105757:	83 ec 08             	sub    $0x8,%esp
8010575a:	53                   	push   %ebx
8010575b:	ff 75 c0             	push   -0x40(%ebp)
8010575e:	e8 5d c9 ff ff       	call   801020c0 <nameiparent>
80105763:	83 c4 10             	add    $0x10,%esp
80105766:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105769:	85 c0                	test   %eax,%eax
8010576b:	0f 84 62 01 00 00    	je     801058d3 <sys_unlink+0x1a3>
  ilock(dp);
80105771:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105774:	83 ec 0c             	sub    $0xc,%esp
80105777:	57                   	push   %edi
80105778:	e8 03 c0 ff ff       	call   80101780 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010577d:	58                   	pop    %eax
8010577e:	5a                   	pop    %edx
8010577f:	68 60 86 10 80       	push   $0x80108660
80105784:	53                   	push   %ebx
80105785:	e8 36 c5 ff ff       	call   80101cc0 <namecmp>
8010578a:	83 c4 10             	add    $0x10,%esp
8010578d:	85 c0                	test   %eax,%eax
8010578f:	0f 84 fb 00 00 00    	je     80105890 <sys_unlink+0x160>
80105795:	83 ec 08             	sub    $0x8,%esp
80105798:	68 5f 86 10 80       	push   $0x8010865f
8010579d:	53                   	push   %ebx
8010579e:	e8 1d c5 ff ff       	call   80101cc0 <namecmp>
801057a3:	83 c4 10             	add    $0x10,%esp
801057a6:	85 c0                	test   %eax,%eax
801057a8:	0f 84 e2 00 00 00    	je     80105890 <sys_unlink+0x160>
  if ((ip = dirlookup(dp, name, &off)) == 0)
801057ae:	83 ec 04             	sub    $0x4,%esp
801057b1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801057b4:	50                   	push   %eax
801057b5:	53                   	push   %ebx
801057b6:	57                   	push   %edi
801057b7:	e8 24 c5 ff ff       	call   80101ce0 <dirlookup>
801057bc:	83 c4 10             	add    $0x10,%esp
801057bf:	89 c3                	mov    %eax,%ebx
801057c1:	85 c0                	test   %eax,%eax
801057c3:	0f 84 c7 00 00 00    	je     80105890 <sys_unlink+0x160>
  ilock(ip);
801057c9:	83 ec 0c             	sub    $0xc,%esp
801057cc:	50                   	push   %eax
801057cd:	e8 ae bf ff ff       	call   80101780 <ilock>
  if (ip->nlink < 1)
801057d2:	83 c4 10             	add    $0x10,%esp
801057d5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801057da:	0f 8e 1c 01 00 00    	jle    801058fc <sys_unlink+0x1cc>
  if (ip->type == T_DIR && !isdirempty(ip))
801057e0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057e5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801057e8:	74 66                	je     80105850 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801057ea:	83 ec 04             	sub    $0x4,%esp
801057ed:	6a 10                	push   $0x10
801057ef:	6a 00                	push   $0x0
801057f1:	57                   	push   %edi
801057f2:	e8 f9 f4 ff ff       	call   80104cf0 <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
801057f7:	6a 10                	push   $0x10
801057f9:	ff 75 c4             	push   -0x3c(%ebp)
801057fc:	57                   	push   %edi
801057fd:	ff 75 b4             	push   -0x4c(%ebp)
80105800:	e8 8b c3 ff ff       	call   80101b90 <writei>
80105805:	83 c4 20             	add    $0x20,%esp
80105808:	83 f8 10             	cmp    $0x10,%eax
8010580b:	0f 85 de 00 00 00    	jne    801058ef <sys_unlink+0x1bf>
  if (ip->type == T_DIR)
80105811:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105816:	0f 84 94 00 00 00    	je     801058b0 <sys_unlink+0x180>
  iunlockput(dp);
8010581c:	83 ec 0c             	sub    $0xc,%esp
8010581f:	ff 75 b4             	push   -0x4c(%ebp)
80105822:	e8 e9 c1 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105827:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010582c:	89 1c 24             	mov    %ebx,(%esp)
8010582f:	e8 9c be ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105834:	89 1c 24             	mov    %ebx,(%esp)
80105837:	e8 d4 c1 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010583c:	e8 8f d5 ff ff       	call   80102dd0 <end_op>
  return 0;
80105841:	83 c4 10             	add    $0x10,%esp
80105844:	31 c0                	xor    %eax,%eax
}
80105846:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105849:	5b                   	pop    %ebx
8010584a:	5e                   	pop    %esi
8010584b:	5f                   	pop    %edi
8010584c:	5d                   	pop    %ebp
8010584d:	c3                   	ret    
8010584e:	66 90                	xchg   %ax,%ax
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
80105850:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105854:	76 94                	jbe    801057ea <sys_unlink+0xba>
80105856:	be 20 00 00 00       	mov    $0x20,%esi
8010585b:	eb 0b                	jmp    80105868 <sys_unlink+0x138>
8010585d:	8d 76 00             	lea    0x0(%esi),%esi
80105860:	83 c6 10             	add    $0x10,%esi
80105863:	3b 73 58             	cmp    0x58(%ebx),%esi
80105866:	73 82                	jae    801057ea <sys_unlink+0xba>
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80105868:	6a 10                	push   $0x10
8010586a:	56                   	push   %esi
8010586b:	57                   	push   %edi
8010586c:	53                   	push   %ebx
8010586d:	e8 1e c2 ff ff       	call   80101a90 <readi>
80105872:	83 c4 10             	add    $0x10,%esp
80105875:	83 f8 10             	cmp    $0x10,%eax
80105878:	75 68                	jne    801058e2 <sys_unlink+0x1b2>
    if (de.inum != 0)
8010587a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010587f:	74 df                	je     80105860 <sys_unlink+0x130>
    iunlockput(ip);
80105881:	83 ec 0c             	sub    $0xc,%esp
80105884:	53                   	push   %ebx
80105885:	e8 86 c1 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010588a:	83 c4 10             	add    $0x10,%esp
8010588d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105890:	83 ec 0c             	sub    $0xc,%esp
80105893:	ff 75 b4             	push   -0x4c(%ebp)
80105896:	e8 75 c1 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010589b:	e8 30 d5 ff ff       	call   80102dd0 <end_op>
  return -1;
801058a0:	83 c4 10             	add    $0x10,%esp
801058a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a8:	eb 9c                	jmp    80105846 <sys_unlink+0x116>
801058aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801058b0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801058b3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801058b6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801058bb:	50                   	push   %eax
801058bc:	e8 0f be ff ff       	call   801016d0 <iupdate>
801058c1:	83 c4 10             	add    $0x10,%esp
801058c4:	e9 53 ff ff ff       	jmp    8010581c <sys_unlink+0xec>
    return -1;
801058c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ce:	e9 73 ff ff ff       	jmp    80105846 <sys_unlink+0x116>
    end_op();
801058d3:	e8 f8 d4 ff ff       	call   80102dd0 <end_op>
    return -1;
801058d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058dd:	e9 64 ff ff ff       	jmp    80105846 <sys_unlink+0x116>
      panic("isdirempty: readi");
801058e2:	83 ec 0c             	sub    $0xc,%esp
801058e5:	68 84 86 10 80       	push   $0x80108684
801058ea:	e8 91 aa ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801058ef:	83 ec 0c             	sub    $0xc,%esp
801058f2:	68 96 86 10 80       	push   $0x80108696
801058f7:	e8 84 aa ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801058fc:	83 ec 0c             	sub    $0xc,%esp
801058ff:	68 72 86 10 80       	push   $0x80108672
80105904:	e8 77 aa ff ff       	call   80100380 <panic>
80105909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105910 <sys_open>:

int sys_open(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	57                   	push   %edi
80105914:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105915:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105918:	53                   	push   %ebx
80105919:	83 ec 24             	sub    $0x24,%esp
  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010591c:	50                   	push   %eax
8010591d:	6a 00                	push   $0x0
8010591f:	e8 dc f7 ff ff       	call   80105100 <argstr>
80105924:	83 c4 10             	add    $0x10,%esp
80105927:	85 c0                	test   %eax,%eax
80105929:	0f 88 8e 00 00 00    	js     801059bd <sys_open+0xad>
8010592f:	83 ec 08             	sub    $0x8,%esp
80105932:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105935:	50                   	push   %eax
80105936:	6a 01                	push   $0x1
80105938:	e8 b3 f6 ff ff       	call   80104ff0 <argint>
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	85 c0                	test   %eax,%eax
80105942:	78 79                	js     801059bd <sys_open+0xad>
    return -1;

  begin_op();
80105944:	e8 17 d4 ff ff       	call   80102d60 <begin_op>

  if (omode & O_CREATE)
80105949:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010594d:	75 79                	jne    801059c8 <sys_open+0xb8>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(path)) == 0)
8010594f:	83 ec 0c             	sub    $0xc,%esp
80105952:	ff 75 e0             	push   -0x20(%ebp)
80105955:	e8 46 c7 ff ff       	call   801020a0 <namei>
8010595a:	83 c4 10             	add    $0x10,%esp
8010595d:	89 c6                	mov    %eax,%esi
8010595f:	85 c0                	test   %eax,%eax
80105961:	0f 84 7e 00 00 00    	je     801059e5 <sys_open+0xd5>
    {
      end_op();
      return -1;
    }
    ilock(ip);
80105967:	83 ec 0c             	sub    $0xc,%esp
8010596a:	50                   	push   %eax
8010596b:	e8 10 be ff ff       	call   80101780 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
80105970:	83 c4 10             	add    $0x10,%esp
80105973:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105978:	0f 84 c2 00 00 00    	je     80105a40 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
8010597e:	e8 ad b4 ff ff       	call   80100e30 <filealloc>
80105983:	89 c7                	mov    %eax,%edi
80105985:	85 c0                	test   %eax,%eax
80105987:	74 23                	je     801059ac <sys_open+0x9c>
  struct proc *curproc = myproc();
80105989:	e8 a2 e0 ff ff       	call   80103a30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
8010598e:	31 db                	xor    %ebx,%ebx
    if (curproc->ofile[fd] == 0)
80105990:	8b 54 98 34          	mov    0x34(%eax,%ebx,4),%edx
80105994:	85 d2                	test   %edx,%edx
80105996:	74 60                	je     801059f8 <sys_open+0xe8>
  for (fd = 0; fd < NOFILE; fd++)
80105998:	83 c3 01             	add    $0x1,%ebx
8010599b:	83 fb 10             	cmp    $0x10,%ebx
8010599e:	75 f0                	jne    80105990 <sys_open+0x80>
  {
    if (f)
      fileclose(f);
801059a0:	83 ec 0c             	sub    $0xc,%esp
801059a3:	57                   	push   %edi
801059a4:	e8 47 b5 ff ff       	call   80100ef0 <fileclose>
801059a9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801059ac:	83 ec 0c             	sub    $0xc,%esp
801059af:	56                   	push   %esi
801059b0:	e8 5b c0 ff ff       	call   80101a10 <iunlockput>
    end_op();
801059b5:	e8 16 d4 ff ff       	call   80102dd0 <end_op>
    return -1;
801059ba:	83 c4 10             	add    $0x10,%esp
801059bd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059c2:	eb 6d                	jmp    80105a31 <sys_open+0x121>
801059c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801059c8:	83 ec 0c             	sub    $0xc,%esp
801059cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801059ce:	31 c9                	xor    %ecx,%ecx
801059d0:	ba 02 00 00 00       	mov    $0x2,%edx
801059d5:	6a 00                	push   $0x0
801059d7:	e8 14 f8 ff ff       	call   801051f0 <create>
    if (ip == 0)
801059dc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801059df:	89 c6                	mov    %eax,%esi
    if (ip == 0)
801059e1:	85 c0                	test   %eax,%eax
801059e3:	75 99                	jne    8010597e <sys_open+0x6e>
      end_op();
801059e5:	e8 e6 d3 ff ff       	call   80102dd0 <end_op>
      return -1;
801059ea:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059ef:	eb 40                	jmp    80105a31 <sys_open+0x121>
801059f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801059f8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801059fb:	89 7c 98 34          	mov    %edi,0x34(%eax,%ebx,4)
  iunlock(ip);
801059ff:	56                   	push   %esi
80105a00:	e8 5b be ff ff       	call   80101860 <iunlock>
  end_op();
80105a05:	e8 c6 d3 ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
80105a0a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105a10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a13:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105a16:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105a19:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105a1b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105a22:	f7 d0                	not    %eax
80105a24:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a27:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105a2a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a2d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105a31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a34:	89 d8                	mov    %ebx,%eax
80105a36:	5b                   	pop    %ebx
80105a37:	5e                   	pop    %esi
80105a38:	5f                   	pop    %edi
80105a39:	5d                   	pop    %ebp
80105a3a:	c3                   	ret    
80105a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a3f:	90                   	nop
    if (ip->type == T_DIR && omode != O_RDONLY)
80105a40:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105a43:	85 c9                	test   %ecx,%ecx
80105a45:	0f 84 33 ff ff ff    	je     8010597e <sys_open+0x6e>
80105a4b:	e9 5c ff ff ff       	jmp    801059ac <sys_open+0x9c>

80105a50 <sys_mkdir>:

int sys_mkdir(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a56:	e8 05 d3 ff ff       	call   80102d60 <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
80105a5b:	83 ec 08             	sub    $0x8,%esp
80105a5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a61:	50                   	push   %eax
80105a62:	6a 00                	push   $0x0
80105a64:	e8 97 f6 ff ff       	call   80105100 <argstr>
80105a69:	83 c4 10             	add    $0x10,%esp
80105a6c:	85 c0                	test   %eax,%eax
80105a6e:	78 30                	js     80105aa0 <sys_mkdir+0x50>
80105a70:	83 ec 0c             	sub    $0xc,%esp
80105a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a76:	31 c9                	xor    %ecx,%ecx
80105a78:	ba 01 00 00 00       	mov    $0x1,%edx
80105a7d:	6a 00                	push   $0x0
80105a7f:	e8 6c f7 ff ff       	call   801051f0 <create>
80105a84:	83 c4 10             	add    $0x10,%esp
80105a87:	85 c0                	test   %eax,%eax
80105a89:	74 15                	je     80105aa0 <sys_mkdir+0x50>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a8b:	83 ec 0c             	sub    $0xc,%esp
80105a8e:	50                   	push   %eax
80105a8f:	e8 7c bf ff ff       	call   80101a10 <iunlockput>
  end_op();
80105a94:	e8 37 d3 ff ff       	call   80102dd0 <end_op>
  return 0;
80105a99:	83 c4 10             	add    $0x10,%esp
80105a9c:	31 c0                	xor    %eax,%eax
}
80105a9e:	c9                   	leave  
80105a9f:	c3                   	ret    
    end_op();
80105aa0:	e8 2b d3 ff ff       	call   80102dd0 <end_op>
    return -1;
80105aa5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aaa:	c9                   	leave  
80105aab:	c3                   	ret    
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <sys_mknod>:

int sys_mknod(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105ab6:	e8 a5 d2 ff ff       	call   80102d60 <begin_op>
  if ((argstr(0, &path)) < 0 ||
80105abb:	83 ec 08             	sub    $0x8,%esp
80105abe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ac1:	50                   	push   %eax
80105ac2:	6a 00                	push   $0x0
80105ac4:	e8 37 f6 ff ff       	call   80105100 <argstr>
80105ac9:	83 c4 10             	add    $0x10,%esp
80105acc:	85 c0                	test   %eax,%eax
80105ace:	78 60                	js     80105b30 <sys_mknod+0x80>
      argint(1, &major) < 0 ||
80105ad0:	83 ec 08             	sub    $0x8,%esp
80105ad3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ad6:	50                   	push   %eax
80105ad7:	6a 01                	push   $0x1
80105ad9:	e8 12 f5 ff ff       	call   80104ff0 <argint>
  if ((argstr(0, &path)) < 0 ||
80105ade:	83 c4 10             	add    $0x10,%esp
80105ae1:	85 c0                	test   %eax,%eax
80105ae3:	78 4b                	js     80105b30 <sys_mknod+0x80>
      argint(2, &minor) < 0 ||
80105ae5:	83 ec 08             	sub    $0x8,%esp
80105ae8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aeb:	50                   	push   %eax
80105aec:	6a 02                	push   $0x2
80105aee:	e8 fd f4 ff ff       	call   80104ff0 <argint>
      argint(1, &major) < 0 ||
80105af3:	83 c4 10             	add    $0x10,%esp
80105af6:	85 c0                	test   %eax,%eax
80105af8:	78 36                	js     80105b30 <sys_mknod+0x80>
      (ip = create(path, T_DEV, major, minor)) == 0)
80105afa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105afe:	83 ec 0c             	sub    $0xc,%esp
80105b01:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105b05:	ba 03 00 00 00       	mov    $0x3,%edx
80105b0a:	50                   	push   %eax
80105b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b0e:	e8 dd f6 ff ff       	call   801051f0 <create>
      argint(2, &minor) < 0 ||
80105b13:	83 c4 10             	add    $0x10,%esp
80105b16:	85 c0                	test   %eax,%eax
80105b18:	74 16                	je     80105b30 <sys_mknod+0x80>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b1a:	83 ec 0c             	sub    $0xc,%esp
80105b1d:	50                   	push   %eax
80105b1e:	e8 ed be ff ff       	call   80101a10 <iunlockput>
  end_op();
80105b23:	e8 a8 d2 ff ff       	call   80102dd0 <end_op>
  return 0;
80105b28:	83 c4 10             	add    $0x10,%esp
80105b2b:	31 c0                	xor    %eax,%eax
}
80105b2d:	c9                   	leave  
80105b2e:	c3                   	ret    
80105b2f:	90                   	nop
    end_op();
80105b30:	e8 9b d2 ff ff       	call   80102dd0 <end_op>
    return -1;
80105b35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b3a:	c9                   	leave  
80105b3b:	c3                   	ret    
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b40 <sys_chdir>:

int sys_chdir(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	56                   	push   %esi
80105b44:	53                   	push   %ebx
80105b45:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b48:	e8 e3 de ff ff       	call   80103a30 <myproc>
80105b4d:	89 c6                	mov    %eax,%esi

  begin_op();
80105b4f:	e8 0c d2 ff ff       	call   80102d60 <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105b54:	83 ec 08             	sub    $0x8,%esp
80105b57:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b5a:	50                   	push   %eax
80105b5b:	6a 00                	push   $0x0
80105b5d:	e8 9e f5 ff ff       	call   80105100 <argstr>
80105b62:	83 c4 10             	add    $0x10,%esp
80105b65:	85 c0                	test   %eax,%eax
80105b67:	78 77                	js     80105be0 <sys_chdir+0xa0>
80105b69:	83 ec 0c             	sub    $0xc,%esp
80105b6c:	ff 75 f4             	push   -0xc(%ebp)
80105b6f:	e8 2c c5 ff ff       	call   801020a0 <namei>
80105b74:	83 c4 10             	add    $0x10,%esp
80105b77:	89 c3                	mov    %eax,%ebx
80105b79:	85 c0                	test   %eax,%eax
80105b7b:	74 63                	je     80105be0 <sys_chdir+0xa0>
  {
    end_op();
    return -1;
  }
  ilock(ip);
80105b7d:	83 ec 0c             	sub    $0xc,%esp
80105b80:	50                   	push   %eax
80105b81:	e8 fa bb ff ff       	call   80101780 <ilock>
  if (ip->type != T_DIR)
80105b86:	83 c4 10             	add    $0x10,%esp
80105b89:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b8e:	75 30                	jne    80105bc0 <sys_chdir+0x80>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b90:	83 ec 0c             	sub    $0xc,%esp
80105b93:	53                   	push   %ebx
80105b94:	e8 c7 bc ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105b99:	58                   	pop    %eax
80105b9a:	ff 76 74             	push   0x74(%esi)
80105b9d:	e8 0e bd ff ff       	call   801018b0 <iput>
  end_op();
80105ba2:	e8 29 d2 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80105ba7:	89 5e 74             	mov    %ebx,0x74(%esi)
  return 0;
80105baa:	83 c4 10             	add    $0x10,%esp
80105bad:	31 c0                	xor    %eax,%eax
}
80105baf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105bb2:	5b                   	pop    %ebx
80105bb3:	5e                   	pop    %esi
80105bb4:	5d                   	pop    %ebp
80105bb5:	c3                   	ret    
80105bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bbd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105bc0:	83 ec 0c             	sub    $0xc,%esp
80105bc3:	53                   	push   %ebx
80105bc4:	e8 47 be ff ff       	call   80101a10 <iunlockput>
    end_op();
80105bc9:	e8 02 d2 ff ff       	call   80102dd0 <end_op>
    return -1;
80105bce:	83 c4 10             	add    $0x10,%esp
80105bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd6:	eb d7                	jmp    80105baf <sys_chdir+0x6f>
80105bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bdf:	90                   	nop
    end_op();
80105be0:	e8 eb d1 ff ff       	call   80102dd0 <end_op>
    return -1;
80105be5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bea:	eb c3                	jmp    80105baf <sys_chdir+0x6f>
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bf0 <sys_exec>:

int sys_exec(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	57                   	push   %edi
80105bf4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80105bf5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105bfb:	53                   	push   %ebx
80105bfc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80105c02:	50                   	push   %eax
80105c03:	6a 00                	push   $0x0
80105c05:	e8 f6 f4 ff ff       	call   80105100 <argstr>
80105c0a:	83 c4 10             	add    $0x10,%esp
80105c0d:	85 c0                	test   %eax,%eax
80105c0f:	0f 88 87 00 00 00    	js     80105c9c <sys_exec+0xac>
80105c15:	83 ec 08             	sub    $0x8,%esp
80105c18:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105c1e:	50                   	push   %eax
80105c1f:	6a 01                	push   $0x1
80105c21:	e8 ca f3 ff ff       	call   80104ff0 <argint>
80105c26:	83 c4 10             	add    $0x10,%esp
80105c29:	85 c0                	test   %eax,%eax
80105c2b:	78 6f                	js     80105c9c <sys_exec+0xac>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105c2d:	83 ec 04             	sub    $0x4,%esp
80105c30:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for (i = 0;; i++)
80105c36:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105c38:	68 80 00 00 00       	push   $0x80
80105c3d:	6a 00                	push   $0x0
80105c3f:	56                   	push   %esi
80105c40:	e8 ab f0 ff ff       	call   80104cf0 <memset>
80105c45:	83 c4 10             	add    $0x10,%esp
80105c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4f:	90                   	nop
  {
    if (i >= NELEM(argv))
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80105c50:	83 ec 08             	sub    $0x8,%esp
80105c53:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105c59:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105c60:	50                   	push   %eax
80105c61:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c67:	01 f8                	add    %edi,%eax
80105c69:	50                   	push   %eax
80105c6a:	e8 b1 f2 ff ff       	call   80104f20 <fetchint>
80105c6f:	83 c4 10             	add    $0x10,%esp
80105c72:	85 c0                	test   %eax,%eax
80105c74:	78 26                	js     80105c9c <sys_exec+0xac>
      return -1;
    if (uarg == 0)
80105c76:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105c7c:	85 c0                	test   %eax,%eax
80105c7e:	74 30                	je     80105cb0 <sys_exec+0xc0>
    {
      argv[i] = 0;
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
80105c80:	83 ec 08             	sub    $0x8,%esp
80105c83:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105c86:	52                   	push   %edx
80105c87:	50                   	push   %eax
80105c88:	e8 d3 f2 ff ff       	call   80104f60 <fetchstr>
80105c8d:	83 c4 10             	add    $0x10,%esp
80105c90:	85 c0                	test   %eax,%eax
80105c92:	78 08                	js     80105c9c <sys_exec+0xac>
  for (i = 0;; i++)
80105c94:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
80105c97:	83 fb 20             	cmp    $0x20,%ebx
80105c9a:	75 b4                	jne    80105c50 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105c9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ca4:	5b                   	pop    %ebx
80105ca5:	5e                   	pop    %esi
80105ca6:	5f                   	pop    %edi
80105ca7:	5d                   	pop    %ebp
80105ca8:	c3                   	ret    
80105ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105cb0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105cb7:	00 00 00 00 
  return exec(path, argv);
80105cbb:	83 ec 08             	sub    $0x8,%esp
80105cbe:	56                   	push   %esi
80105cbf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105cc5:	e8 e6 ad ff ff       	call   80100ab0 <exec>
80105cca:	83 c4 10             	add    $0x10,%esp
}
80105ccd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cd0:	5b                   	pop    %ebx
80105cd1:	5e                   	pop    %esi
80105cd2:	5f                   	pop    %edi
80105cd3:	5d                   	pop    %ebp
80105cd4:	c3                   	ret    
80105cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ce0 <sys_pipe>:

int sys_pipe(void)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	57                   	push   %edi
80105ce4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80105ce5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105ce8:	53                   	push   %ebx
80105ce9:	83 ec 20             	sub    $0x20,%esp
  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80105cec:	6a 08                	push   $0x8
80105cee:	50                   	push   %eax
80105cef:	6a 00                	push   $0x0
80105cf1:	e8 9a f3 ff ff       	call   80105090 <argptr>
80105cf6:	83 c4 10             	add    $0x10,%esp
80105cf9:	85 c0                	test   %eax,%eax
80105cfb:	78 4a                	js     80105d47 <sys_pipe+0x67>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
80105cfd:	83 ec 08             	sub    $0x8,%esp
80105d00:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d03:	50                   	push   %eax
80105d04:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d07:	50                   	push   %eax
80105d08:	e8 23 d7 ff ff       	call   80103430 <pipealloc>
80105d0d:	83 c4 10             	add    $0x10,%esp
80105d10:	85 c0                	test   %eax,%eax
80105d12:	78 33                	js     80105d47 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80105d14:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (fd = 0; fd < NOFILE; fd++)
80105d17:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105d19:	e8 12 dd ff ff       	call   80103a30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105d1e:	66 90                	xchg   %ax,%ax
    if (curproc->ofile[fd] == 0)
80105d20:	8b 74 98 34          	mov    0x34(%eax,%ebx,4),%esi
80105d24:	85 f6                	test   %esi,%esi
80105d26:	74 28                	je     80105d50 <sys_pipe+0x70>
  for (fd = 0; fd < NOFILE; fd++)
80105d28:	83 c3 01             	add    $0x1,%ebx
80105d2b:	83 fb 10             	cmp    $0x10,%ebx
80105d2e:	75 f0                	jne    80105d20 <sys_pipe+0x40>
  {
    if (fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105d30:	83 ec 0c             	sub    $0xc,%esp
80105d33:	ff 75 e0             	push   -0x20(%ebp)
80105d36:	e8 b5 b1 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
80105d3b:	58                   	pop    %eax
80105d3c:	ff 75 e4             	push   -0x1c(%ebp)
80105d3f:	e8 ac b1 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105d44:	83 c4 10             	add    $0x10,%esp
80105d47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d4c:	eb 53                	jmp    80105da1 <sys_pipe+0xc1>
80105d4e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105d50:	8d 73 0c             	lea    0xc(%ebx),%esi
80105d53:	89 7c b0 04          	mov    %edi,0x4(%eax,%esi,4)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80105d57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105d5a:	e8 d1 dc ff ff       	call   80103a30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105d5f:	31 d2                	xor    %edx,%edx
80105d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd] == 0)
80105d68:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
80105d6c:	85 c9                	test   %ecx,%ecx
80105d6e:	74 20                	je     80105d90 <sys_pipe+0xb0>
  for (fd = 0; fd < NOFILE; fd++)
80105d70:	83 c2 01             	add    $0x1,%edx
80105d73:	83 fa 10             	cmp    $0x10,%edx
80105d76:	75 f0                	jne    80105d68 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105d78:	e8 b3 dc ff ff       	call   80103a30 <myproc>
80105d7d:	c7 44 b0 04 00 00 00 	movl   $0x0,0x4(%eax,%esi,4)
80105d84:	00 
80105d85:	eb a9                	jmp    80105d30 <sys_pipe+0x50>
80105d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d8e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105d90:	89 7c 90 34          	mov    %edi,0x34(%eax,%edx,4)
  }
  fd[0] = fd0;
80105d94:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d97:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d99:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d9c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105d9f:	31 c0                	xor    %eax,%eax
}
80105da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105da4:	5b                   	pop    %ebx
80105da5:	5e                   	pop    %esi
80105da6:	5f                   	pop    %edi
80105da7:	5d                   	pop    %ebp
80105da8:	c3                   	ret    
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105db0 <sys_copy_file>:
}



int sys_copy_file(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	57                   	push   %edi
80105db4:	56                   	push   %esi
80105db5:	53                   	push   %ebx
80105db6:	81 ec 00 10 00 00    	sub    $0x1000,%esp
80105dbc:	83 0c 24 00          	orl    $0x0,(%esp)
80105dc0:	83 ec 34             	sub    $0x34,%esp
  char *dest;
  int fd;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &src) < 0 || argstr(1, &dest) < 0)
80105dc3:	8d 85 e0 ef ff ff    	lea    -0x1020(%ebp),%eax
80105dc9:	50                   	push   %eax
80105dca:	6a 00                	push   $0x0
80105dcc:	e8 2f f3 ff ff       	call   80105100 <argstr>
80105dd1:	83 c4 10             	add    $0x10,%esp
80105dd4:	85 c0                	test   %eax,%eax
80105dd6:	0f 88 81 01 00 00    	js     80105f5d <sys_copy_file+0x1ad>
80105ddc:	83 ec 08             	sub    $0x8,%esp
80105ddf:	8d 85 e4 ef ff ff    	lea    -0x101c(%ebp),%eax
80105de5:	50                   	push   %eax
80105de6:	6a 01                	push   $0x1
80105de8:	e8 13 f3 ff ff       	call   80105100 <argstr>
80105ded:	83 c4 10             	add    $0x10,%esp
80105df0:	85 c0                	test   %eax,%eax
80105df2:	0f 88 65 01 00 00    	js     80105f5d <sys_copy_file+0x1ad>
    return -1;

  begin_op();
80105df8:	e8 63 cf ff ff       	call   80102d60 <begin_op>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(src)) == 0)
80105dfd:	83 ec 0c             	sub    $0xc,%esp
80105e00:	ff b5 e0 ef ff ff    	push   -0x1020(%ebp)
80105e06:	e8 95 c2 ff ff       	call   801020a0 <namei>
80105e0b:	83 c4 10             	add    $0x10,%esp
80105e0e:	89 c6                	mov    %eax,%esi
80105e10:	85 c0                	test   %eax,%eax
80105e12:	0f 84 c0 01 00 00    	je     80105fd8 <sys_copy_file+0x228>
    {
      end_op();
      return -1;
    }
    ilock(ip);
80105e18:	83 ec 0c             	sub    $0xc,%esp
80105e1b:	50                   	push   %eax
80105e1c:	e8 5f b9 ff ff       	call   80101780 <ilock>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80105e21:	e8 0a b0 ff ff       	call   80100e30 <filealloc>
80105e26:	83 c4 10             	add    $0x10,%esp
80105e29:	89 c7                	mov    %eax,%edi
80105e2b:	85 c0                	test   %eax,%eax
80105e2d:	74 2d                	je     80105e5c <sys_copy_file+0xac>
  struct proc *curproc = myproc();
80105e2f:	e8 fc db ff ff       	call   80103a30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105e34:	31 d2                	xor    %edx,%edx
80105e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3d:	8d 76 00             	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
80105e40:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
80105e44:	85 c9                	test   %ecx,%ecx
80105e46:	74 38                	je     80105e80 <sys_copy_file+0xd0>
  for (fd = 0; fd < NOFILE; fd++)
80105e48:	83 c2 01             	add    $0x1,%edx
80105e4b:	83 fa 10             	cmp    $0x10,%edx
80105e4e:	75 f0                	jne    80105e40 <sys_copy_file+0x90>
  {
    if (f)
      fileclose(f);
80105e50:	83 ec 0c             	sub    $0xc,%esp
80105e53:	57                   	push   %edi
80105e54:	e8 97 b0 ff ff       	call   80100ef0 <fileclose>
80105e59:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105e5c:	83 ec 0c             	sub    $0xc,%esp
80105e5f:	56                   	push   %esi
80105e60:	e8 ab bb ff ff       	call   80101a10 <iunlockput>
    end_op();
80105e65:	e8 66 cf ff ff       	call   80102dd0 <end_op>
    return -1;
80105e6a:	83 c4 10             	add    $0x10,%esp
80105e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e72:	e9 59 01 00 00       	jmp    80105fd0 <sys_copy_file+0x220>
80105e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e7e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e80:	8d 5a 0c             	lea    0xc(%edx),%ebx
  }
  iunlock(ip);
80105e83:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105e86:	89 7c 98 04          	mov    %edi,0x4(%eax,%ebx,4)
  iunlock(ip);
80105e8a:	56                   	push   %esi
80105e8b:	e8 d0 b9 ff ff       	call   80101860 <iunlock>
  end_op();
80105e90:	e8 3b cf ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(O_RDONLY & O_WRONLY);
80105e95:	b8 01 00 00 00       	mov    $0x1,%eax
  f->ip = ip;
80105e9a:	89 77 10             	mov    %esi,0x10(%edi)
  f->type = FD_INODE;
80105e9d:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->off = 0;
80105ea3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(O_RDONLY & O_WRONLY);
80105eaa:	66 89 47 08          	mov    %ax,0x8(%edi)
  if((f = myproc() -> ofile[fd]) == 0){
80105eae:	e8 7d db ff ff       	call   80103a30 <myproc>
80105eb3:	83 c4 10             	add    $0x10,%esp
80105eb6:	8b 44 98 04          	mov    0x4(%eax,%ebx,4),%eax
80105eba:	85 c0                	test   %eax,%eax
80105ebc:	0f 84 9b 00 00 00    	je     80105f5d <sys_copy_file+0x1ad>
  f->writable = (O_RDONLY & O_WRONLY) || (O_RDONLY & O_RDWR);
  
  char p[4096];
  if (my_argfd(0, 0, &f, fd) < 0)
      return -1;
  int read_chars = fileread(f, p, 4096);
80105ec2:	83 ec 04             	sub    $0x4,%esp
80105ec5:	8d bd e8 ef ff ff    	lea    -0x1018(%ebp),%edi
80105ecb:	68 00 10 00 00       	push   $0x1000
80105ed0:	57                   	push   %edi
80105ed1:	50                   	push   %eax
80105ed2:	e8 49 b1 ff ff       	call   80101020 <fileread>
80105ed7:	89 85 d4 ef ff ff    	mov    %eax,-0x102c(%ebp)
  //dest
  int fd2;
  struct file *f2;
  struct inode *ip2;
  begin_op();
80105edd:	e8 7e ce ff ff       	call   80102d60 <begin_op>
      return -1;
    }
  }
  else
  {
    if ((ip2 = namei(dest)) == 0)
80105ee2:	58                   	pop    %eax
80105ee3:	ff b5 e4 ef ff ff    	push   -0x101c(%ebp)
80105ee9:	e8 b2 c1 ff ff       	call   801020a0 <namei>
80105eee:	83 c4 10             	add    $0x10,%esp
80105ef1:	89 c3                	mov    %eax,%ebx
80105ef3:	85 c0                	test   %eax,%eax
80105ef5:	0f 84 dd 00 00 00    	je     80105fd8 <sys_copy_file+0x228>
    {
      end_op();
      return -1;
    }
    ilock(ip2);
80105efb:	83 ec 0c             	sub    $0xc,%esp
80105efe:	50                   	push   %eax
80105eff:	e8 7c b8 ff ff       	call   80101780 <ilock>
    if (ip2->type == T_DIR && dest != O_RDONLY)
80105f04:	83 c4 10             	add    $0x10,%esp
80105f07:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105f0c:	75 0a                	jne    80105f18 <sys_copy_file+0x168>
80105f0e:	8b b5 e4 ef ff ff    	mov    -0x101c(%ebp),%esi
80105f14:	85 f6                	test   %esi,%esi
80105f16:	75 34                	jne    80105f4c <sys_copy_file+0x19c>
      end_op();
      return -1;
    }
  }

  if ((f2 = filealloc()) == 0 || (fd2 = fdalloc(f2)) < 0)
80105f18:	e8 13 af ff ff       	call   80100e30 <filealloc>
80105f1d:	89 c6                	mov    %eax,%esi
80105f1f:	85 c0                	test   %eax,%eax
80105f21:	74 29                	je     80105f4c <sys_copy_file+0x19c>
  struct proc *curproc = myproc();
80105f23:	e8 08 db ff ff       	call   80103a30 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105f28:	31 d2                	xor    %edx,%edx
80105f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
80105f30:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
80105f34:	85 c9                	test   %ecx,%ecx
80105f36:	74 30                	je     80105f68 <sys_copy_file+0x1b8>
  for (fd = 0; fd < NOFILE; fd++)
80105f38:	83 c2 01             	add    $0x1,%edx
80105f3b:	83 fa 10             	cmp    $0x10,%edx
80105f3e:	75 f0                	jne    80105f30 <sys_copy_file+0x180>
  {
    if (f2)
      fileclose(f2);
80105f40:	83 ec 0c             	sub    $0xc,%esp
80105f43:	56                   	push   %esi
80105f44:	e8 a7 af ff ff       	call   80100ef0 <fileclose>
80105f49:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip2);
80105f4c:	83 ec 0c             	sub    $0xc,%esp
80105f4f:	53                   	push   %ebx
80105f50:	e8 bb ba ff ff       	call   80101a10 <iunlockput>
    end_op();
80105f55:	e8 76 ce ff ff       	call   80102dd0 <end_op>
    return -1;
80105f5a:	83 c4 10             	add    $0x10,%esp
80105f5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f62:	eb 6c                	jmp    80105fd0 <sys_copy_file+0x220>
80105f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105f68:	83 c2 0c             	add    $0xc,%edx
  }
  iunlock(ip2);
80105f6b:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105f6e:	89 74 90 04          	mov    %esi,0x4(%eax,%edx,4)
  iunlock(ip2);
80105f72:	53                   	push   %ebx
      curproc->ofile[fd] = f;
80105f73:	89 95 d0 ef ff ff    	mov    %edx,-0x1030(%ebp)
  iunlock(ip2);
80105f79:	e8 e2 b8 ff ff       	call   80101860 <iunlock>
  end_op();
80105f7e:	e8 4d ce ff ff       	call   80102dd0 <end_op>

  f2->type = FD_INODE;
  f2->ip = ip2;
  f2->off = 0;
  f2->readable = !(O_WRONLY & O_WRONLY);
80105f83:	b8 00 01 00 00       	mov    $0x100,%eax
  f2->ip = ip2;
80105f88:	89 5e 10             	mov    %ebx,0x10(%esi)
  f2->type = FD_INODE;
80105f8b:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f2->off = 0;
80105f91:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f2->readable = !(O_WRONLY & O_WRONLY);
80105f98:	66 89 46 08          	mov    %ax,0x8(%esi)
  if((f = myproc() -> ofile[fd]) == 0){
80105f9c:	e8 8f da ff ff       	call   80103a30 <myproc>
80105fa1:	8b 95 d0 ef ff ff    	mov    -0x1030(%ebp),%edx
80105fa7:	83 c4 10             	add    $0x10,%esp
80105faa:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80105fae:	85 c0                	test   %eax,%eax
80105fb0:	74 ab                	je     80105f5d <sys_copy_file+0x1ad>
  f2->writable = (O_WRONLY & O_WRONLY) || (O_WRONLY & O_RDWR);
  if (my_argfd(0, 0, &f2, fd2) < 0)
      return -1;   
  int written_chars = filewrite(f2, p, read_chars);
80105fb2:	8b 9d d4 ef ff ff    	mov    -0x102c(%ebp),%ebx
80105fb8:	83 ec 04             	sub    $0x4,%esp
80105fbb:	53                   	push   %ebx
80105fbc:	57                   	push   %edi
80105fbd:	50                   	push   %eax
80105fbe:	e8 ed b0 ff ff       	call   801010b0 <filewrite>
  if(written_chars != read_chars){
80105fc3:	83 c4 10             	add    $0x10,%esp
80105fc6:	39 c3                	cmp    %eax,%ebx
80105fc8:	0f 95 c0             	setne  %al
80105fcb:	0f b6 c0             	movzbl %al,%eax
80105fce:	f7 d8                	neg    %eax
    return -1;
  }
  else{
    return 0;
  }
80105fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fd3:	5b                   	pop    %ebx
80105fd4:	5e                   	pop    %esi
80105fd5:	5f                   	pop    %edi
80105fd6:	5d                   	pop    %ebp
80105fd7:	c3                   	ret    
      end_op();
80105fd8:	e8 f3 cd ff ff       	call   80102dd0 <end_op>
      return -1;
80105fdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe2:	eb ec                	jmp    80105fd0 <sys_copy_file+0x220>
80105fe4:	66 90                	xchg   %ax,%ax
80105fe6:	66 90                	xchg   %ax,%ax
80105fe8:	66 90                	xchg   %ax,%ax
80105fea:	66 90                	xchg   %ax,%ax
80105fec:	66 90                	xchg   %ax,%ax
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int sys_fork(void)
{
  return fork();
80105ff0:	e9 eb de ff ff       	jmp    80103ee0 <fork>
80105ff5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106000 <sys_exit>:
}

int sys_exit(void)
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	83 ec 08             	sub    $0x8,%esp
  exit();
80106006:	e8 c5 e3 ff ff       	call   801043d0 <exit>
  return 0; // not reached
}
8010600b:	31 c0                	xor    %eax,%eax
8010600d:	c9                   	leave  
8010600e:	c3                   	ret    
8010600f:	90                   	nop

80106010 <sys_wait>:

int sys_wait(void)
{
  return wait();
80106010:	e9 eb e4 ff ff       	jmp    80104500 <wait>
80106015:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010601c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106020 <sys_kill>:
}

int sys_kill(void)
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80106026:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106029:	50                   	push   %eax
8010602a:	6a 00                	push   $0x0
8010602c:	e8 bf ef ff ff       	call   80104ff0 <argint>
80106031:	83 c4 10             	add    $0x10,%esp
80106034:	85 c0                	test   %eax,%eax
80106036:	78 18                	js     80106050 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106038:	83 ec 0c             	sub    $0xc,%esp
8010603b:	ff 75 f4             	push   -0xc(%ebp)
8010603e:	e8 5d e7 ff ff       	call   801047a0 <kill>
80106043:	83 c4 10             	add    $0x10,%esp
}
80106046:	c9                   	leave  
80106047:	c3                   	ret    
80106048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010604f:	90                   	nop
80106050:	c9                   	leave  
    return -1;
80106051:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106056:	c3                   	ret    
80106057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605e:	66 90                	xchg   %ax,%ax

80106060 <sys_getpid>:

int sys_getpid(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106066:	e8 c5 d9 ff ff       	call   80103a30 <myproc>
8010606b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010606e:	c9                   	leave  
8010606f:	c3                   	ret    

80106070 <sys_sbrk>:

int sys_sbrk(void)
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	53                   	push   %ebx
  int addr;
  int n;

  if (argint(0, &n) < 0)
80106074:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106077:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
8010607a:	50                   	push   %eax
8010607b:	6a 00                	push   $0x0
8010607d:	e8 6e ef ff ff       	call   80104ff0 <argint>
80106082:	83 c4 10             	add    $0x10,%esp
80106085:	85 c0                	test   %eax,%eax
80106087:	78 27                	js     801060b0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106089:	e8 a2 d9 ff ff       	call   80103a30 <myproc>
  if (growproc(n) < 0)
8010608e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106091:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80106093:	ff 75 f4             	push   -0xc(%ebp)
80106096:	e8 c5 dd ff ff       	call   80103e60 <growproc>
8010609b:	83 c4 10             	add    $0x10,%esp
8010609e:	85 c0                	test   %eax,%eax
801060a0:	78 0e                	js     801060b0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801060a2:	89 d8                	mov    %ebx,%eax
801060a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060a7:	c9                   	leave  
801060a8:	c3                   	ret    
801060a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801060b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801060b5:	eb eb                	jmp    801060a2 <sys_sbrk+0x32>
801060b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060be:	66 90                	xchg   %ax,%ax

801060c0 <sys_sleep>:

int sys_sleep(void)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
801060c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801060c7:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
801060ca:	50                   	push   %eax
801060cb:	6a 00                	push   $0x0
801060cd:	e8 1e ef ff ff       	call   80104ff0 <argint>
801060d2:	83 c4 10             	add    $0x10,%esp
801060d5:	85 c0                	test   %eax,%eax
801060d7:	0f 88 8a 00 00 00    	js     80106167 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801060dd:	83 ec 0c             	sub    $0xc,%esp
801060e0:	68 80 55 11 80       	push   $0x80115580
801060e5:	e8 46 eb ff ff       	call   80104c30 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
801060ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801060ed:	8b 1d 60 55 11 80    	mov    0x80115560,%ebx
  while (ticks - ticks0 < n)
801060f3:	83 c4 10             	add    $0x10,%esp
801060f6:	85 d2                	test   %edx,%edx
801060f8:	75 27                	jne    80106121 <sys_sleep+0x61>
801060fa:	eb 54                	jmp    80106150 <sys_sleep+0x90>
801060fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106100:	83 ec 08             	sub    $0x8,%esp
80106103:	68 80 55 11 80       	push   $0x80115580
80106108:	68 60 55 11 80       	push   $0x80115560
8010610d:	e8 6e e5 ff ff       	call   80104680 <sleep>
  while (ticks - ticks0 < n)
80106112:	a1 60 55 11 80       	mov    0x80115560,%eax
80106117:	83 c4 10             	add    $0x10,%esp
8010611a:	29 d8                	sub    %ebx,%eax
8010611c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010611f:	73 2f                	jae    80106150 <sys_sleep+0x90>
    if (myproc()->killed)
80106121:	e8 0a d9 ff ff       	call   80103a30 <myproc>
80106126:	8b 40 30             	mov    0x30(%eax),%eax
80106129:	85 c0                	test   %eax,%eax
8010612b:	74 d3                	je     80106100 <sys_sleep+0x40>
      release(&tickslock);
8010612d:	83 ec 0c             	sub    $0xc,%esp
80106130:	68 80 55 11 80       	push   $0x80115580
80106135:	e8 96 ea ff ff       	call   80104bd0 <release>
  }
  release(&tickslock);
  return 0;
}
8010613a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010613d:	83 c4 10             	add    $0x10,%esp
80106140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106145:	c9                   	leave  
80106146:	c3                   	ret    
80106147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106150:	83 ec 0c             	sub    $0xc,%esp
80106153:	68 80 55 11 80       	push   $0x80115580
80106158:	e8 73 ea ff ff       	call   80104bd0 <release>
  return 0;
8010615d:	83 c4 10             	add    $0x10,%esp
80106160:	31 c0                	xor    %eax,%eax
}
80106162:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106165:	c9                   	leave  
80106166:	c3                   	ret    
    return -1;
80106167:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010616c:	eb f4                	jmp    80106162 <sys_sleep+0xa2>
8010616e:	66 90                	xchg   %ax,%ax

80106170 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	53                   	push   %ebx
80106174:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106177:	68 80 55 11 80       	push   $0x80115580
8010617c:	e8 af ea ff ff       	call   80104c30 <acquire>
  xticks = ticks;
80106181:	8b 1d 60 55 11 80    	mov    0x80115560,%ebx
  release(&tickslock);
80106187:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)
8010618e:	e8 3d ea ff ff       	call   80104bd0 <release>
  return xticks;
}
80106193:	89 d8                	mov    %ebx,%eax
80106195:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106198:	c9                   	leave  
80106199:	c3                   	ret    
8010619a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801061a0 <sys_find_digital_root>:

int sys_find_digital_root(void)
{
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
801061a3:	83 ec 08             	sub    $0x8,%esp
  int number = myproc()->tf->ebx; // register after eax
801061a6:	e8 85 d8 ff ff       	call   80103a30 <myproc>
  return find_digital_root(number);
801061ab:	83 ec 0c             	sub    $0xc,%esp
  int number = myproc()->tf->ebx; // register after eax
801061ae:	8b 40 18             	mov    0x18(%eax),%eax
  return find_digital_root(number);
801061b1:	ff 70 10             	push   0x10(%eax)
801061b4:	e8 27 e7 ff ff       	call   801048e0 <find_digital_root>
}
801061b9:	c9                   	leave  
801061ba:	c3                   	ret    
801061bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061bf:	90                   	nop

801061c0 <sys_get_uncle_count>:

int sys_get_uncle_count(void)
{
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
801061c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
801061c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061c9:	50                   	push   %eax
801061ca:	6a 00                	push   $0x0
801061cc:	e8 1f ee ff ff       	call   80104ff0 <argint>
801061d1:	83 c4 10             	add    $0x10,%esp
801061d4:	85 c0                	test   %eax,%eax
801061d6:	78 28                	js     80106200 <sys_get_uncle_count+0x40>
  {
    return -1;
  }
  struct proc *grandFather = find_proc(pid)->parent->parent;
801061d8:	83 ec 0c             	sub    $0xc,%esp
801061db:	ff 75 f4             	push   -0xc(%ebp)
801061de:	e8 cd d9 ff ff       	call   80103bb0 <find_proc>
  return count_child(grandFather) - 1;
801061e3:	5a                   	pop    %edx
  struct proc *grandFather = find_proc(pid)->parent->parent;
801061e4:	8b 40 14             	mov    0x14(%eax),%eax
  return count_child(grandFather) - 1;
801061e7:	ff 70 14             	push   0x14(%eax)
801061ea:	e8 11 dc ff ff       	call   80103e00 <count_child>
801061ef:	83 c4 10             	add    $0x10,%esp
}
801061f2:	c9                   	leave  
  return count_child(grandFather) - 1;
801061f3:	83 e8 01             	sub    $0x1,%eax
}
801061f6:	c3                   	ret    
801061f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061fe:	66 90                	xchg   %ax,%ax
80106200:	c9                   	leave  
    return -1;
80106201:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106206:	c3                   	ret    
80106207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620e:	66 90                	xchg   %ax,%ax

80106210 <sys_get_process_lifetime>:
int sys_get_process_lifetime(void)
{
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	53                   	push   %ebx
  int pid;
  if (argint(0, &pid) < 0)
80106214:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106217:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0)
8010621a:	50                   	push   %eax
8010621b:	6a 00                	push   $0x0
8010621d:	e8 ce ed ff ff       	call   80104ff0 <argint>
80106222:	83 c4 10             	add    $0x10,%esp
80106225:	85 c0                	test   %eax,%eax
80106227:	78 27                	js     80106250 <sys_get_process_lifetime+0x40>
  {
    return -1;
  }
  return ticks - (find_proc(pid)->creation_time);
80106229:	83 ec 0c             	sub    $0xc,%esp
8010622c:	ff 75 f4             	push   -0xc(%ebp)
8010622f:	8b 1d 60 55 11 80    	mov    0x80115560,%ebx
80106235:	e8 76 d9 ff ff       	call   80103bb0 <find_proc>
8010623a:	83 c4 10             	add    $0x10,%esp
8010623d:	2b 58 20             	sub    0x20(%eax),%ebx
80106240:	89 d8                	mov    %ebx,%eax
}
80106242:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106245:	c9                   	leave  
80106246:	c3                   	ret    
80106247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010624e:	66 90                	xchg   %ax,%ax
    return -1;
80106250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106255:	eb eb                	jmp    80106242 <sys_get_process_lifetime+0x32>
80106257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010625e:	66 90                	xchg   %ax,%ax

80106260 <sys_set_date>:
void sys_set_date(void)
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *r;
  if (argptr(0, (void *)&r, sizeof(*r)) < 0)
80106266:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106269:	6a 18                	push   $0x18
8010626b:	50                   	push   %eax
8010626c:	6a 00                	push   $0x0
8010626e:	e8 1d ee ff ff       	call   80105090 <argptr>
80106273:	83 c4 10             	add    $0x10,%esp
80106276:	85 c0                	test   %eax,%eax
80106278:	78 16                	js     80106290 <sys_set_date+0x30>
    cprintf("Kernel: sys_set_date() has a problem.\n");

  cmostime(r);
8010627a:	83 ec 0c             	sub    $0xc,%esp
8010627d:	ff 75 f4             	push   -0xc(%ebp)
80106280:	e8 4b c7 ff ff       	call   801029d0 <cmostime>
}
80106285:	83 c4 10             	add    $0x10,%esp
80106288:	c9                   	leave  
80106289:	c3                   	ret    
8010628a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("Kernel: sys_set_date() has a problem.\n");
80106290:	83 ec 0c             	sub    $0xc,%esp
80106293:	68 a8 86 10 80       	push   $0x801086a8
80106298:	e8 03 a4 ff ff       	call   801006a0 <cprintf>
8010629d:	83 c4 10             	add    $0x10,%esp
  cmostime(r);
801062a0:	83 ec 0c             	sub    $0xc,%esp
801062a3:	ff 75 f4             	push   -0xc(%ebp)
801062a6:	e8 25 c7 ff ff       	call   801029d0 <cmostime>
}
801062ab:	83 c4 10             	add    $0x10,%esp
801062ae:	c9                   	leave  
801062af:	c3                   	ret    

801062b0 <sys_get_pid>:
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	83 ec 08             	sub    $0x8,%esp
801062b6:	e8 75 d7 ff ff       	call   80103a30 <myproc>
801062bb:	8b 40 10             	mov    0x10(%eax),%eax
801062be:	c9                   	leave  
801062bf:	c3                   	ret    

801062c0 <sys_get_parent>:
int sys_get_pid(void)
{
  return myproc()->pid;
}
int sys_get_parent(void)
{
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
801062c3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
801062c6:	e8 65 d7 ff ff       	call   80103a30 <myproc>
801062cb:	8b 40 14             	mov    0x14(%eax),%eax
801062ce:	8b 40 10             	mov    0x10(%eax),%eax
}
801062d1:	c9                   	leave  
801062d2:	c3                   	ret    
801062d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801062e0 <sys_change_queue>:
int sys_change_queue(void)
{
801062e0:	55                   	push   %ebp
801062e1:	89 e5                	mov    %esp,%ebp
801062e3:	53                   	push   %ebx
  int pid, que_id;
  if (argint(0, &pid) < 0 || argint(1, &que_id))
801062e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
801062e7:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0 || argint(1, &que_id))
801062ea:	50                   	push   %eax
801062eb:	6a 00                	push   $0x0
801062ed:	e8 fe ec ff ff       	call   80104ff0 <argint>
801062f2:	83 c4 10             	add    $0x10,%esp
801062f5:	85 c0                	test   %eax,%eax
801062f7:	78 47                	js     80106340 <sys_change_queue+0x60>
801062f9:	83 ec 08             	sub    $0x8,%esp
801062fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062ff:	50                   	push   %eax
80106300:	6a 01                	push   $0x1
80106302:	e8 e9 ec ff ff       	call   80104ff0 <argint>
80106307:	83 c4 10             	add    $0x10,%esp
8010630a:	89 c3                	mov    %eax,%ebx
8010630c:	85 c0                	test   %eax,%eax
8010630e:	75 30                	jne    80106340 <sys_change_queue+0x60>
    return -1;
  cprintf("%d\n", pid);
80106310:	83 ec 08             	sub    $0x8,%esp
80106313:	ff 75 f0             	push   -0x10(%ebp)
80106316:	68 14 83 10 80       	push   $0x80108314
8010631b:	e8 80 a3 ff ff       	call   801006a0 <cprintf>
  struct proc *p = find_proc(pid);
80106320:	58                   	pop    %eax
80106321:	ff 75 f0             	push   -0x10(%ebp)
80106324:	e8 87 d8 ff ff       	call   80103bb0 <find_proc>
  p->que_id = que_id;
80106329:	8b 55 f4             	mov    -0xc(%ebp),%edx
  return 0;
8010632c:	83 c4 10             	add    $0x10,%esp
  p->que_id = que_id;
8010632f:	89 50 28             	mov    %edx,0x28(%eax)
}
80106332:	89 d8                	mov    %ebx,%eax
80106334:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106337:	c9                   	leave  
80106338:	c3                   	ret    
80106339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106340:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106345:	eb eb                	jmp    80106332 <sys_change_queue+0x52>
80106347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010634e:	66 90                	xchg   %ax,%ax

80106350 <sys_bjf_validation_process>:
int sys_bjf_validation_process(void)
{
80106350:	55                   	push   %ebp
80106351:	89 e5                	mov    %esp,%ebp
80106353:	83 ec 30             	sub    $0x30,%esp
  
  int pid;
  float priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argint(0, &pid) < 0 || argf(1, &priority_ratio) < 0 || argf(2, &creation_time_ratio) < 0 || argf(3, &exec_cycle_ratio) < 0 || argf(4, &size_ratio) < 0)
80106356:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106359:	50                   	push   %eax
8010635a:	6a 00                	push   $0x0
8010635c:	e8 8f ec ff ff       	call   80104ff0 <argint>
80106361:	83 c4 10             	add    $0x10,%esp
80106364:	85 c0                	test   %eax,%eax
80106366:	0f 88 94 00 00 00    	js     80106400 <sys_bjf_validation_process+0xb0>
8010636c:	83 ec 08             	sub    $0x8,%esp
8010636f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106372:	50                   	push   %eax
80106373:	6a 01                	push   $0x1
80106375:	e8 c6 ec ff ff       	call   80105040 <argf>
8010637a:	83 c4 10             	add    $0x10,%esp
8010637d:	85 c0                	test   %eax,%eax
8010637f:	78 7f                	js     80106400 <sys_bjf_validation_process+0xb0>
80106381:	83 ec 08             	sub    $0x8,%esp
80106384:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106387:	50                   	push   %eax
80106388:	6a 02                	push   $0x2
8010638a:	e8 b1 ec ff ff       	call   80105040 <argf>
8010638f:	83 c4 10             	add    $0x10,%esp
80106392:	85 c0                	test   %eax,%eax
80106394:	78 6a                	js     80106400 <sys_bjf_validation_process+0xb0>
80106396:	83 ec 08             	sub    $0x8,%esp
80106399:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010639c:	50                   	push   %eax
8010639d:	6a 03                	push   $0x3
8010639f:	e8 9c ec ff ff       	call   80105040 <argf>
801063a4:	83 c4 10             	add    $0x10,%esp
801063a7:	85 c0                	test   %eax,%eax
801063a9:	78 55                	js     80106400 <sys_bjf_validation_process+0xb0>
801063ab:	83 ec 08             	sub    $0x8,%esp
801063ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063b1:	50                   	push   %eax
801063b2:	6a 04                	push   $0x4
801063b4:	e8 87 ec ff ff       	call   80105040 <argf>
801063b9:	83 c4 10             	add    $0x10,%esp
801063bc:	85 c0                	test   %eax,%eax
801063be:	78 40                	js     80106400 <sys_bjf_validation_process+0xb0>
  {
    return -1;
  }
  struct proc *p = find_proc(pid);
801063c0:	83 ec 0c             	sub    $0xc,%esp
801063c3:	ff 75 e4             	push   -0x1c(%ebp)
801063c6:	e8 e5 d7 ff ff       	call   80103bb0 <find_proc>
  p->priority_ratio = priority_ratio;
801063cb:	d9 45 e8             	flds   -0x18(%ebp)
  p->creation_time_ratio = creation_time_ratio;
  p->executed_cycle_ratio = exec_cycle_ratio;
  p->process_size_ratio = size_ratio;

  return 0;
801063ce:	83 c4 10             	add    $0x10,%esp
  p->priority_ratio = priority_ratio;
801063d1:	d9 98 8c 00 00 00    	fstps  0x8c(%eax)
  p->creation_time_ratio = creation_time_ratio;
801063d7:	d9 45 ec             	flds   -0x14(%ebp)
801063da:	d9 98 90 00 00 00    	fstps  0x90(%eax)
  p->executed_cycle_ratio = exec_cycle_ratio;
801063e0:	d9 45 f0             	flds   -0x10(%ebp)
801063e3:	d9 98 98 00 00 00    	fstps  0x98(%eax)
  p->process_size_ratio = size_ratio;
801063e9:	d9 45 f4             	flds   -0xc(%ebp)
801063ec:	d9 98 9c 00 00 00    	fstps  0x9c(%eax)
  return 0;
801063f2:	31 c0                	xor    %eax,%eax
}
801063f4:	c9                   	leave  
801063f5:	c3                   	ret    
801063f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063fd:	8d 76 00             	lea    0x0(%esi),%esi
80106400:	c9                   	leave  
    return -1;
80106401:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106406:	c3                   	ret    
80106407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010640e:	66 90                	xchg   %ax,%ax

80106410 <sys_bjf_validation_system>:
int sys_bjf_validation_system(void)
{
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	83 ec 20             	sub    $0x20,%esp
  float priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argf(0, &priority_ratio) < 0 || argf(1, &creation_time_ratio) < 0 || argf(2, &exec_cycle_ratio) < 0 || argf(3, &size_ratio) < 0)
80106416:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106419:	50                   	push   %eax
8010641a:	6a 00                	push   $0x0
8010641c:	e8 1f ec ff ff       	call   80105040 <argf>
80106421:	83 c4 10             	add    $0x10,%esp
80106424:	85 c0                	test   %eax,%eax
80106426:	78 70                	js     80106498 <sys_bjf_validation_system+0x88>
80106428:	83 ec 08             	sub    $0x8,%esp
8010642b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010642e:	50                   	push   %eax
8010642f:	6a 01                	push   $0x1
80106431:	e8 0a ec ff ff       	call   80105040 <argf>
80106436:	83 c4 10             	add    $0x10,%esp
80106439:	85 c0                	test   %eax,%eax
8010643b:	78 5b                	js     80106498 <sys_bjf_validation_system+0x88>
8010643d:	83 ec 08             	sub    $0x8,%esp
80106440:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106443:	50                   	push   %eax
80106444:	6a 02                	push   $0x2
80106446:	e8 f5 eb ff ff       	call   80105040 <argf>
8010644b:	83 c4 10             	add    $0x10,%esp
8010644e:	85 c0                	test   %eax,%eax
80106450:	78 46                	js     80106498 <sys_bjf_validation_system+0x88>
80106452:	83 ec 08             	sub    $0x8,%esp
80106455:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106458:	50                   	push   %eax
80106459:	6a 03                	push   $0x3
8010645b:	e8 e0 eb ff ff       	call   80105040 <argf>
80106460:	83 c4 10             	add    $0x10,%esp
80106463:	85 c0                	test   %eax,%eax
80106465:	78 31                	js     80106498 <sys_bjf_validation_system+0x88>
  {
    return -1;
  }
  cprintf("%d\n", priority_ratio);
80106467:	d9 45 e8             	flds   -0x18(%ebp)
8010646a:	83 ec 0c             	sub    $0xc,%esp
8010646d:	dd 1c 24             	fstpl  (%esp)
80106470:	68 14 83 10 80       	push   $0x80108314
80106475:	e8 26 a2 ff ff       	call   801006a0 <cprintf>
  reset_bjf_attributes(priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio);
8010647a:	ff 75 f4             	push   -0xc(%ebp)
8010647d:	ff 75 f0             	push   -0x10(%ebp)
80106480:	ff 75 ec             	push   -0x14(%ebp)
80106483:	ff 75 e8             	push   -0x18(%ebp)
80106486:	e8 25 d5 ff ff       	call   801039b0 <reset_bjf_attributes>
  return 0;
8010648b:	83 c4 20             	add    $0x20,%esp
8010648e:	31 c0                	xor    %eax,%eax
}
80106490:	c9                   	leave  
80106491:	c3                   	ret    
80106492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106498:	c9                   	leave  
    return -1;
80106499:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010649e:	c3                   	ret    
8010649f:	90                   	nop

801064a0 <sys_print_info>:
int sys_print_info(void)
{
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	83 ec 08             	sub    $0x8,%esp
  print_bitches();
801064a6:	e8 e5 d7 ff ff       	call   80103c90 <print_bitches>
  return 0;
801064ab:	31 c0                	xor    %eax,%eax
801064ad:	c9                   	leave  
801064ae:	c3                   	ret    

801064af <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801064af:	1e                   	push   %ds
  pushl %es
801064b0:	06                   	push   %es
  pushl %fs
801064b1:	0f a0                	push   %fs
  pushl %gs
801064b3:	0f a8                	push   %gs
  pushal
801064b5:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801064b6:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801064ba:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801064bc:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801064be:	54                   	push   %esp
  call trap
801064bf:	e8 cc 00 00 00       	call   80106590 <trap>
  addl $4, %esp
801064c4:	83 c4 04             	add    $0x4,%esp

801064c7 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801064c7:	61                   	popa   
  popl %gs
801064c8:	0f a9                	pop    %gs
  popl %fs
801064ca:	0f a1                	pop    %fs
  popl %es
801064cc:	07                   	pop    %es
  popl %ds
801064cd:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801064ce:	83 c4 08             	add    $0x8,%esp
  iret
801064d1:	cf                   	iret   
801064d2:	66 90                	xchg   %ax,%ax
801064d4:	66 90                	xchg   %ax,%ax
801064d6:	66 90                	xchg   %ax,%ax
801064d8:	66 90                	xchg   %ax,%ax
801064da:	66 90                	xchg   %ax,%ax
801064dc:	66 90                	xchg   %ax,%ax
801064de:	66 90                	xchg   %ax,%ax

801064e0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801064e0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801064e1:	31 c0                	xor    %eax,%eax
{
801064e3:	89 e5                	mov    %esp,%ebp
801064e5:	83 ec 08             	sub    $0x8,%esp
801064e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ef:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801064f0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801064f7:	c7 04 c5 c2 55 11 80 	movl   $0x8e000008,-0x7feeaa3e(,%eax,8)
801064fe:	08 00 00 8e 
80106502:	66 89 14 c5 c0 55 11 	mov    %dx,-0x7feeaa40(,%eax,8)
80106509:	80 
8010650a:	c1 ea 10             	shr    $0x10,%edx
8010650d:	66 89 14 c5 c6 55 11 	mov    %dx,-0x7feeaa3a(,%eax,8)
80106514:	80 
  for(i = 0; i < 256; i++)
80106515:	83 c0 01             	add    $0x1,%eax
80106518:	3d 00 01 00 00       	cmp    $0x100,%eax
8010651d:	75 d1                	jne    801064f0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010651f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106522:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106527:	c7 05 c2 57 11 80 08 	movl   $0xef000008,0x801157c2
8010652e:	00 00 ef 
  initlock(&tickslock, "time");
80106531:	68 cf 86 10 80       	push   $0x801086cf
80106536:	68 80 55 11 80       	push   $0x80115580
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010653b:	66 a3 c0 57 11 80    	mov    %ax,0x801157c0
80106541:	c1 e8 10             	shr    $0x10,%eax
80106544:	66 a3 c6 57 11 80    	mov    %ax,0x801157c6
  initlock(&tickslock, "time");
8010654a:	e8 11 e5 ff ff       	call   80104a60 <initlock>
}
8010654f:	83 c4 10             	add    $0x10,%esp
80106552:	c9                   	leave  
80106553:	c3                   	ret    
80106554:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010655b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010655f:	90                   	nop

80106560 <idtinit>:

void
idtinit(void)
{
80106560:	55                   	push   %ebp
  pd[0] = size-1;
80106561:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106566:	89 e5                	mov    %esp,%ebp
80106568:	83 ec 10             	sub    $0x10,%esp
8010656b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010656f:	b8 c0 55 11 80       	mov    $0x801155c0,%eax
80106574:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106578:	c1 e8 10             	shr    $0x10,%eax
8010657b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010657f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106582:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106585:	c9                   	leave  
80106586:	c3                   	ret    
80106587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010658e:	66 90                	xchg   %ax,%ax

80106590 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106590:	55                   	push   %ebp
80106591:	89 e5                	mov    %esp,%ebp
80106593:	57                   	push   %edi
80106594:	56                   	push   %esi
80106595:	53                   	push   %ebx
80106596:	83 ec 1c             	sub    $0x1c,%esp
80106599:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010659c:	8b 43 30             	mov    0x30(%ebx),%eax
8010659f:	83 f8 40             	cmp    $0x40,%eax
801065a2:	0f 84 68 01 00 00    	je     80106710 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801065a8:	83 e8 20             	sub    $0x20,%eax
801065ab:	83 f8 1f             	cmp    $0x1f,%eax
801065ae:	0f 87 8c 00 00 00    	ja     80106640 <trap+0xb0>
801065b4:	ff 24 85 78 87 10 80 	jmp    *-0x7fef7888(,%eax,4)
801065bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065bf:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801065c0:	e8 7b bc ff ff       	call   80102240 <ideintr>
    lapiceoi();
801065c5:	e8 46 c3 ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801065ca:	e8 61 d4 ff ff       	call   80103a30 <myproc>
801065cf:	85 c0                	test   %eax,%eax
801065d1:	74 1d                	je     801065f0 <trap+0x60>
801065d3:	e8 58 d4 ff ff       	call   80103a30 <myproc>
801065d8:	8b 50 30             	mov    0x30(%eax),%edx
801065db:	85 d2                	test   %edx,%edx
801065dd:	74 11                	je     801065f0 <trap+0x60>
801065df:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801065e3:	83 e0 03             	and    $0x3,%eax
801065e6:	66 83 f8 03          	cmp    $0x3,%ax
801065ea:	0f 84 e8 01 00 00    	je     801067d8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801065f0:	e8 3b d4 ff ff       	call   80103a30 <myproc>
801065f5:	85 c0                	test   %eax,%eax
801065f7:	74 0f                	je     80106608 <trap+0x78>
801065f9:	e8 32 d4 ff ff       	call   80103a30 <myproc>
801065fe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106602:	0f 84 b8 00 00 00    	je     801066c0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106608:	e8 23 d4 ff ff       	call   80103a30 <myproc>
8010660d:	85 c0                	test   %eax,%eax
8010660f:	74 1d                	je     8010662e <trap+0x9e>
80106611:	e8 1a d4 ff ff       	call   80103a30 <myproc>
80106616:	8b 40 30             	mov    0x30(%eax),%eax
80106619:	85 c0                	test   %eax,%eax
8010661b:	74 11                	je     8010662e <trap+0x9e>
8010661d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106621:	83 e0 03             	and    $0x3,%eax
80106624:	66 83 f8 03          	cmp    $0x3,%ax
80106628:	0f 84 0f 01 00 00    	je     8010673d <trap+0x1ad>
    exit();
}
8010662e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106631:	5b                   	pop    %ebx
80106632:	5e                   	pop    %esi
80106633:	5f                   	pop    %edi
80106634:	5d                   	pop    %ebp
80106635:	c3                   	ret    
80106636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010663d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106640:	e8 eb d3 ff ff       	call   80103a30 <myproc>
80106645:	8b 7b 38             	mov    0x38(%ebx),%edi
80106648:	85 c0                	test   %eax,%eax
8010664a:	0f 84 a2 01 00 00    	je     801067f2 <trap+0x262>
80106650:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106654:	0f 84 98 01 00 00    	je     801067f2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010665a:	0f 20 d1             	mov    %cr2,%ecx
8010665d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106660:	e8 2b d3 ff ff       	call   80103990 <cpuid>
80106665:	8b 73 30             	mov    0x30(%ebx),%esi
80106668:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010666b:	8b 43 34             	mov    0x34(%ebx),%eax
8010666e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106671:	e8 ba d3 ff ff       	call   80103a30 <myproc>
80106676:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106679:	e8 b2 d3 ff ff       	call   80103a30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010667e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106681:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106684:	51                   	push   %ecx
80106685:	57                   	push   %edi
80106686:	52                   	push   %edx
80106687:	ff 75 e4             	push   -0x1c(%ebp)
8010668a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010668b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010668e:	83 c6 78             	add    $0x78,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106691:	56                   	push   %esi
80106692:	ff 70 10             	push   0x10(%eax)
80106695:	68 34 87 10 80       	push   $0x80108734
8010669a:	e8 01 a0 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
8010669f:	83 c4 20             	add    $0x20,%esp
801066a2:	e8 89 d3 ff ff       	call   80103a30 <myproc>
801066a7:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066ae:	e8 7d d3 ff ff       	call   80103a30 <myproc>
801066b3:	85 c0                	test   %eax,%eax
801066b5:	0f 85 18 ff ff ff    	jne    801065d3 <trap+0x43>
801066bb:	e9 30 ff ff ff       	jmp    801065f0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
801066c0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801066c4:	0f 85 3e ff ff ff    	jne    80106608 <trap+0x78>
    yield();
801066ca:	e8 61 df ff ff       	call   80104630 <yield>
801066cf:	e9 34 ff ff ff       	jmp    80106608 <trap+0x78>
801066d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801066d8:	8b 7b 38             	mov    0x38(%ebx),%edi
801066db:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801066df:	e8 ac d2 ff ff       	call   80103990 <cpuid>
801066e4:	57                   	push   %edi
801066e5:	56                   	push   %esi
801066e6:	50                   	push   %eax
801066e7:	68 dc 86 10 80       	push   $0x801086dc
801066ec:	e8 af 9f ff ff       	call   801006a0 <cprintf>
    lapiceoi();
801066f1:	e8 1a c2 ff ff       	call   80102910 <lapiceoi>
    break;
801066f6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066f9:	e8 32 d3 ff ff       	call   80103a30 <myproc>
801066fe:	85 c0                	test   %eax,%eax
80106700:	0f 85 cd fe ff ff    	jne    801065d3 <trap+0x43>
80106706:	e9 e5 fe ff ff       	jmp    801065f0 <trap+0x60>
8010670b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010670f:	90                   	nop
    if(myproc()->killed)
80106710:	e8 1b d3 ff ff       	call   80103a30 <myproc>
80106715:	8b 70 30             	mov    0x30(%eax),%esi
80106718:	85 f6                	test   %esi,%esi
8010671a:	0f 85 c8 00 00 00    	jne    801067e8 <trap+0x258>
    myproc()->tf = tf;
80106720:	e8 0b d3 ff ff       	call   80103a30 <myproc>
80106725:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106728:	e8 53 ea ff ff       	call   80105180 <syscall>
    if(myproc()->killed)
8010672d:	e8 fe d2 ff ff       	call   80103a30 <myproc>
80106732:	8b 48 30             	mov    0x30(%eax),%ecx
80106735:	85 c9                	test   %ecx,%ecx
80106737:	0f 84 f1 fe ff ff    	je     8010662e <trap+0x9e>
}
8010673d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106740:	5b                   	pop    %ebx
80106741:	5e                   	pop    %esi
80106742:	5f                   	pop    %edi
80106743:	5d                   	pop    %ebp
      exit();
80106744:	e9 87 dc ff ff       	jmp    801043d0 <exit>
80106749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106750:	e8 3b 02 00 00       	call   80106990 <uartintr>
    lapiceoi();
80106755:	e8 b6 c1 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010675a:	e8 d1 d2 ff ff       	call   80103a30 <myproc>
8010675f:	85 c0                	test   %eax,%eax
80106761:	0f 85 6c fe ff ff    	jne    801065d3 <trap+0x43>
80106767:	e9 84 fe ff ff       	jmp    801065f0 <trap+0x60>
8010676c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106770:	e8 5b c0 ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80106775:	e8 96 c1 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010677a:	e8 b1 d2 ff ff       	call   80103a30 <myproc>
8010677f:	85 c0                	test   %eax,%eax
80106781:	0f 85 4c fe ff ff    	jne    801065d3 <trap+0x43>
80106787:	e9 64 fe ff ff       	jmp    801065f0 <trap+0x60>
8010678c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106790:	e8 fb d1 ff ff       	call   80103990 <cpuid>
80106795:	85 c0                	test   %eax,%eax
80106797:	0f 85 28 fe ff ff    	jne    801065c5 <trap+0x35>
      acquire(&tickslock);
8010679d:	83 ec 0c             	sub    $0xc,%esp
801067a0:	68 80 55 11 80       	push   $0x80115580
801067a5:	e8 86 e4 ff ff       	call   80104c30 <acquire>
      wakeup(&ticks);
801067aa:	c7 04 24 60 55 11 80 	movl   $0x80115560,(%esp)
      ticks++;
801067b1:	83 05 60 55 11 80 01 	addl   $0x1,0x80115560
      wakeup(&ticks);
801067b8:	e8 83 df ff ff       	call   80104740 <wakeup>
      release(&tickslock);
801067bd:	c7 04 24 80 55 11 80 	movl   $0x80115580,(%esp)
801067c4:	e8 07 e4 ff ff       	call   80104bd0 <release>
801067c9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801067cc:	e9 f4 fd ff ff       	jmp    801065c5 <trap+0x35>
801067d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
801067d8:	e8 f3 db ff ff       	call   801043d0 <exit>
801067dd:	e9 0e fe ff ff       	jmp    801065f0 <trap+0x60>
801067e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801067e8:	e8 e3 db ff ff       	call   801043d0 <exit>
801067ed:	e9 2e ff ff ff       	jmp    80106720 <trap+0x190>
801067f2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801067f5:	e8 96 d1 ff ff       	call   80103990 <cpuid>
801067fa:	83 ec 0c             	sub    $0xc,%esp
801067fd:	56                   	push   %esi
801067fe:	57                   	push   %edi
801067ff:	50                   	push   %eax
80106800:	ff 73 30             	push   0x30(%ebx)
80106803:	68 00 87 10 80       	push   $0x80108700
80106808:	e8 93 9e ff ff       	call   801006a0 <cprintf>
      panic("trap");
8010680d:	83 c4 14             	add    $0x14,%esp
80106810:	68 d4 86 10 80       	push   $0x801086d4
80106815:	e8 66 9b ff ff       	call   80100380 <panic>
8010681a:	66 90                	xchg   %ax,%ax
8010681c:	66 90                	xchg   %ax,%ax
8010681e:	66 90                	xchg   %ax,%ax

80106820 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106820:	a1 c0 5d 11 80       	mov    0x80115dc0,%eax
80106825:	85 c0                	test   %eax,%eax
80106827:	74 17                	je     80106840 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106829:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010682e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010682f:	a8 01                	test   $0x1,%al
80106831:	74 0d                	je     80106840 <uartgetc+0x20>
80106833:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106838:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106839:	0f b6 c0             	movzbl %al,%eax
8010683c:	c3                   	ret    
8010683d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106840:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106845:	c3                   	ret    
80106846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010684d:	8d 76 00             	lea    0x0(%esi),%esi

80106850 <uartinit>:
{
80106850:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106851:	31 c9                	xor    %ecx,%ecx
80106853:	89 c8                	mov    %ecx,%eax
80106855:	89 e5                	mov    %esp,%ebp
80106857:	57                   	push   %edi
80106858:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010685d:	56                   	push   %esi
8010685e:	89 fa                	mov    %edi,%edx
80106860:	53                   	push   %ebx
80106861:	83 ec 1c             	sub    $0x1c,%esp
80106864:	ee                   	out    %al,(%dx)
80106865:	be fb 03 00 00       	mov    $0x3fb,%esi
8010686a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010686f:	89 f2                	mov    %esi,%edx
80106871:	ee                   	out    %al,(%dx)
80106872:	b8 0c 00 00 00       	mov    $0xc,%eax
80106877:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010687c:	ee                   	out    %al,(%dx)
8010687d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106882:	89 c8                	mov    %ecx,%eax
80106884:	89 da                	mov    %ebx,%edx
80106886:	ee                   	out    %al,(%dx)
80106887:	b8 03 00 00 00       	mov    $0x3,%eax
8010688c:	89 f2                	mov    %esi,%edx
8010688e:	ee                   	out    %al,(%dx)
8010688f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106894:	89 c8                	mov    %ecx,%eax
80106896:	ee                   	out    %al,(%dx)
80106897:	b8 01 00 00 00       	mov    $0x1,%eax
8010689c:	89 da                	mov    %ebx,%edx
8010689e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010689f:	ba fd 03 00 00       	mov    $0x3fd,%edx
801068a4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801068a5:	3c ff                	cmp    $0xff,%al
801068a7:	74 78                	je     80106921 <uartinit+0xd1>
  uart = 1;
801068a9:	c7 05 c0 5d 11 80 01 	movl   $0x1,0x80115dc0
801068b0:	00 00 00 
801068b3:	89 fa                	mov    %edi,%edx
801068b5:	ec                   	in     (%dx),%al
801068b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801068bb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801068bc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801068bf:	bf f8 87 10 80       	mov    $0x801087f8,%edi
801068c4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801068c9:	6a 00                	push   $0x0
801068cb:	6a 04                	push   $0x4
801068cd:	e8 ae bb ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801068d2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801068d6:	83 c4 10             	add    $0x10,%esp
801068d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801068e0:	a1 c0 5d 11 80       	mov    0x80115dc0,%eax
801068e5:	bb 80 00 00 00       	mov    $0x80,%ebx
801068ea:	85 c0                	test   %eax,%eax
801068ec:	75 14                	jne    80106902 <uartinit+0xb2>
801068ee:	eb 23                	jmp    80106913 <uartinit+0xc3>
    microdelay(10);
801068f0:	83 ec 0c             	sub    $0xc,%esp
801068f3:	6a 0a                	push   $0xa
801068f5:	e8 36 c0 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801068fa:	83 c4 10             	add    $0x10,%esp
801068fd:	83 eb 01             	sub    $0x1,%ebx
80106900:	74 07                	je     80106909 <uartinit+0xb9>
80106902:	89 f2                	mov    %esi,%edx
80106904:	ec                   	in     (%dx),%al
80106905:	a8 20                	test   $0x20,%al
80106907:	74 e7                	je     801068f0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106909:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010690d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106912:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106913:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106917:	83 c7 01             	add    $0x1,%edi
8010691a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010691d:	84 c0                	test   %al,%al
8010691f:	75 bf                	jne    801068e0 <uartinit+0x90>
}
80106921:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106924:	5b                   	pop    %ebx
80106925:	5e                   	pop    %esi
80106926:	5f                   	pop    %edi
80106927:	5d                   	pop    %ebp
80106928:	c3                   	ret    
80106929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106930 <uartputc>:
  if(!uart)
80106930:	a1 c0 5d 11 80       	mov    0x80115dc0,%eax
80106935:	85 c0                	test   %eax,%eax
80106937:	74 47                	je     80106980 <uartputc+0x50>
{
80106939:	55                   	push   %ebp
8010693a:	89 e5                	mov    %esp,%ebp
8010693c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010693d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106942:	53                   	push   %ebx
80106943:	bb 80 00 00 00       	mov    $0x80,%ebx
80106948:	eb 18                	jmp    80106962 <uartputc+0x32>
8010694a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106950:	83 ec 0c             	sub    $0xc,%esp
80106953:	6a 0a                	push   $0xa
80106955:	e8 d6 bf ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010695a:	83 c4 10             	add    $0x10,%esp
8010695d:	83 eb 01             	sub    $0x1,%ebx
80106960:	74 07                	je     80106969 <uartputc+0x39>
80106962:	89 f2                	mov    %esi,%edx
80106964:	ec                   	in     (%dx),%al
80106965:	a8 20                	test   $0x20,%al
80106967:	74 e7                	je     80106950 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106969:	8b 45 08             	mov    0x8(%ebp),%eax
8010696c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106971:	ee                   	out    %al,(%dx)
}
80106972:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106975:	5b                   	pop    %ebx
80106976:	5e                   	pop    %esi
80106977:	5d                   	pop    %ebp
80106978:	c3                   	ret    
80106979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106980:	c3                   	ret    
80106981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010698f:	90                   	nop

80106990 <uartintr>:

void
uartintr(void)
{
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
80106993:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106996:	68 20 68 10 80       	push   $0x80106820
8010699b:	e8 e0 9e ff ff       	call   80100880 <consoleintr>
}
801069a0:	83 c4 10             	add    $0x10,%esp
801069a3:	c9                   	leave  
801069a4:	c3                   	ret    

801069a5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801069a5:	6a 00                	push   $0x0
  pushl $0
801069a7:	6a 00                	push   $0x0
  jmp alltraps
801069a9:	e9 01 fb ff ff       	jmp    801064af <alltraps>

801069ae <vector1>:
.globl vector1
vector1:
  pushl $0
801069ae:	6a 00                	push   $0x0
  pushl $1
801069b0:	6a 01                	push   $0x1
  jmp alltraps
801069b2:	e9 f8 fa ff ff       	jmp    801064af <alltraps>

801069b7 <vector2>:
.globl vector2
vector2:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $2
801069b9:	6a 02                	push   $0x2
  jmp alltraps
801069bb:	e9 ef fa ff ff       	jmp    801064af <alltraps>

801069c0 <vector3>:
.globl vector3
vector3:
  pushl $0
801069c0:	6a 00                	push   $0x0
  pushl $3
801069c2:	6a 03                	push   $0x3
  jmp alltraps
801069c4:	e9 e6 fa ff ff       	jmp    801064af <alltraps>

801069c9 <vector4>:
.globl vector4
vector4:
  pushl $0
801069c9:	6a 00                	push   $0x0
  pushl $4
801069cb:	6a 04                	push   $0x4
  jmp alltraps
801069cd:	e9 dd fa ff ff       	jmp    801064af <alltraps>

801069d2 <vector5>:
.globl vector5
vector5:
  pushl $0
801069d2:	6a 00                	push   $0x0
  pushl $5
801069d4:	6a 05                	push   $0x5
  jmp alltraps
801069d6:	e9 d4 fa ff ff       	jmp    801064af <alltraps>

801069db <vector6>:
.globl vector6
vector6:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $6
801069dd:	6a 06                	push   $0x6
  jmp alltraps
801069df:	e9 cb fa ff ff       	jmp    801064af <alltraps>

801069e4 <vector7>:
.globl vector7
vector7:
  pushl $0
801069e4:	6a 00                	push   $0x0
  pushl $7
801069e6:	6a 07                	push   $0x7
  jmp alltraps
801069e8:	e9 c2 fa ff ff       	jmp    801064af <alltraps>

801069ed <vector8>:
.globl vector8
vector8:
  pushl $8
801069ed:	6a 08                	push   $0x8
  jmp alltraps
801069ef:	e9 bb fa ff ff       	jmp    801064af <alltraps>

801069f4 <vector9>:
.globl vector9
vector9:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $9
801069f6:	6a 09                	push   $0x9
  jmp alltraps
801069f8:	e9 b2 fa ff ff       	jmp    801064af <alltraps>

801069fd <vector10>:
.globl vector10
vector10:
  pushl $10
801069fd:	6a 0a                	push   $0xa
  jmp alltraps
801069ff:	e9 ab fa ff ff       	jmp    801064af <alltraps>

80106a04 <vector11>:
.globl vector11
vector11:
  pushl $11
80106a04:	6a 0b                	push   $0xb
  jmp alltraps
80106a06:	e9 a4 fa ff ff       	jmp    801064af <alltraps>

80106a0b <vector12>:
.globl vector12
vector12:
  pushl $12
80106a0b:	6a 0c                	push   $0xc
  jmp alltraps
80106a0d:	e9 9d fa ff ff       	jmp    801064af <alltraps>

80106a12 <vector13>:
.globl vector13
vector13:
  pushl $13
80106a12:	6a 0d                	push   $0xd
  jmp alltraps
80106a14:	e9 96 fa ff ff       	jmp    801064af <alltraps>

80106a19 <vector14>:
.globl vector14
vector14:
  pushl $14
80106a19:	6a 0e                	push   $0xe
  jmp alltraps
80106a1b:	e9 8f fa ff ff       	jmp    801064af <alltraps>

80106a20 <vector15>:
.globl vector15
vector15:
  pushl $0
80106a20:	6a 00                	push   $0x0
  pushl $15
80106a22:	6a 0f                	push   $0xf
  jmp alltraps
80106a24:	e9 86 fa ff ff       	jmp    801064af <alltraps>

80106a29 <vector16>:
.globl vector16
vector16:
  pushl $0
80106a29:	6a 00                	push   $0x0
  pushl $16
80106a2b:	6a 10                	push   $0x10
  jmp alltraps
80106a2d:	e9 7d fa ff ff       	jmp    801064af <alltraps>

80106a32 <vector17>:
.globl vector17
vector17:
  pushl $17
80106a32:	6a 11                	push   $0x11
  jmp alltraps
80106a34:	e9 76 fa ff ff       	jmp    801064af <alltraps>

80106a39 <vector18>:
.globl vector18
vector18:
  pushl $0
80106a39:	6a 00                	push   $0x0
  pushl $18
80106a3b:	6a 12                	push   $0x12
  jmp alltraps
80106a3d:	e9 6d fa ff ff       	jmp    801064af <alltraps>

80106a42 <vector19>:
.globl vector19
vector19:
  pushl $0
80106a42:	6a 00                	push   $0x0
  pushl $19
80106a44:	6a 13                	push   $0x13
  jmp alltraps
80106a46:	e9 64 fa ff ff       	jmp    801064af <alltraps>

80106a4b <vector20>:
.globl vector20
vector20:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $20
80106a4d:	6a 14                	push   $0x14
  jmp alltraps
80106a4f:	e9 5b fa ff ff       	jmp    801064af <alltraps>

80106a54 <vector21>:
.globl vector21
vector21:
  pushl $0
80106a54:	6a 00                	push   $0x0
  pushl $21
80106a56:	6a 15                	push   $0x15
  jmp alltraps
80106a58:	e9 52 fa ff ff       	jmp    801064af <alltraps>

80106a5d <vector22>:
.globl vector22
vector22:
  pushl $0
80106a5d:	6a 00                	push   $0x0
  pushl $22
80106a5f:	6a 16                	push   $0x16
  jmp alltraps
80106a61:	e9 49 fa ff ff       	jmp    801064af <alltraps>

80106a66 <vector23>:
.globl vector23
vector23:
  pushl $0
80106a66:	6a 00                	push   $0x0
  pushl $23
80106a68:	6a 17                	push   $0x17
  jmp alltraps
80106a6a:	e9 40 fa ff ff       	jmp    801064af <alltraps>

80106a6f <vector24>:
.globl vector24
vector24:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $24
80106a71:	6a 18                	push   $0x18
  jmp alltraps
80106a73:	e9 37 fa ff ff       	jmp    801064af <alltraps>

80106a78 <vector25>:
.globl vector25
vector25:
  pushl $0
80106a78:	6a 00                	push   $0x0
  pushl $25
80106a7a:	6a 19                	push   $0x19
  jmp alltraps
80106a7c:	e9 2e fa ff ff       	jmp    801064af <alltraps>

80106a81 <vector26>:
.globl vector26
vector26:
  pushl $0
80106a81:	6a 00                	push   $0x0
  pushl $26
80106a83:	6a 1a                	push   $0x1a
  jmp alltraps
80106a85:	e9 25 fa ff ff       	jmp    801064af <alltraps>

80106a8a <vector27>:
.globl vector27
vector27:
  pushl $0
80106a8a:	6a 00                	push   $0x0
  pushl $27
80106a8c:	6a 1b                	push   $0x1b
  jmp alltraps
80106a8e:	e9 1c fa ff ff       	jmp    801064af <alltraps>

80106a93 <vector28>:
.globl vector28
vector28:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $28
80106a95:	6a 1c                	push   $0x1c
  jmp alltraps
80106a97:	e9 13 fa ff ff       	jmp    801064af <alltraps>

80106a9c <vector29>:
.globl vector29
vector29:
  pushl $0
80106a9c:	6a 00                	push   $0x0
  pushl $29
80106a9e:	6a 1d                	push   $0x1d
  jmp alltraps
80106aa0:	e9 0a fa ff ff       	jmp    801064af <alltraps>

80106aa5 <vector30>:
.globl vector30
vector30:
  pushl $0
80106aa5:	6a 00                	push   $0x0
  pushl $30
80106aa7:	6a 1e                	push   $0x1e
  jmp alltraps
80106aa9:	e9 01 fa ff ff       	jmp    801064af <alltraps>

80106aae <vector31>:
.globl vector31
vector31:
  pushl $0
80106aae:	6a 00                	push   $0x0
  pushl $31
80106ab0:	6a 1f                	push   $0x1f
  jmp alltraps
80106ab2:	e9 f8 f9 ff ff       	jmp    801064af <alltraps>

80106ab7 <vector32>:
.globl vector32
vector32:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $32
80106ab9:	6a 20                	push   $0x20
  jmp alltraps
80106abb:	e9 ef f9 ff ff       	jmp    801064af <alltraps>

80106ac0 <vector33>:
.globl vector33
vector33:
  pushl $0
80106ac0:	6a 00                	push   $0x0
  pushl $33
80106ac2:	6a 21                	push   $0x21
  jmp alltraps
80106ac4:	e9 e6 f9 ff ff       	jmp    801064af <alltraps>

80106ac9 <vector34>:
.globl vector34
vector34:
  pushl $0
80106ac9:	6a 00                	push   $0x0
  pushl $34
80106acb:	6a 22                	push   $0x22
  jmp alltraps
80106acd:	e9 dd f9 ff ff       	jmp    801064af <alltraps>

80106ad2 <vector35>:
.globl vector35
vector35:
  pushl $0
80106ad2:	6a 00                	push   $0x0
  pushl $35
80106ad4:	6a 23                	push   $0x23
  jmp alltraps
80106ad6:	e9 d4 f9 ff ff       	jmp    801064af <alltraps>

80106adb <vector36>:
.globl vector36
vector36:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $36
80106add:	6a 24                	push   $0x24
  jmp alltraps
80106adf:	e9 cb f9 ff ff       	jmp    801064af <alltraps>

80106ae4 <vector37>:
.globl vector37
vector37:
  pushl $0
80106ae4:	6a 00                	push   $0x0
  pushl $37
80106ae6:	6a 25                	push   $0x25
  jmp alltraps
80106ae8:	e9 c2 f9 ff ff       	jmp    801064af <alltraps>

80106aed <vector38>:
.globl vector38
vector38:
  pushl $0
80106aed:	6a 00                	push   $0x0
  pushl $38
80106aef:	6a 26                	push   $0x26
  jmp alltraps
80106af1:	e9 b9 f9 ff ff       	jmp    801064af <alltraps>

80106af6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106af6:	6a 00                	push   $0x0
  pushl $39
80106af8:	6a 27                	push   $0x27
  jmp alltraps
80106afa:	e9 b0 f9 ff ff       	jmp    801064af <alltraps>

80106aff <vector40>:
.globl vector40
vector40:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $40
80106b01:	6a 28                	push   $0x28
  jmp alltraps
80106b03:	e9 a7 f9 ff ff       	jmp    801064af <alltraps>

80106b08 <vector41>:
.globl vector41
vector41:
  pushl $0
80106b08:	6a 00                	push   $0x0
  pushl $41
80106b0a:	6a 29                	push   $0x29
  jmp alltraps
80106b0c:	e9 9e f9 ff ff       	jmp    801064af <alltraps>

80106b11 <vector42>:
.globl vector42
vector42:
  pushl $0
80106b11:	6a 00                	push   $0x0
  pushl $42
80106b13:	6a 2a                	push   $0x2a
  jmp alltraps
80106b15:	e9 95 f9 ff ff       	jmp    801064af <alltraps>

80106b1a <vector43>:
.globl vector43
vector43:
  pushl $0
80106b1a:	6a 00                	push   $0x0
  pushl $43
80106b1c:	6a 2b                	push   $0x2b
  jmp alltraps
80106b1e:	e9 8c f9 ff ff       	jmp    801064af <alltraps>

80106b23 <vector44>:
.globl vector44
vector44:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $44
80106b25:	6a 2c                	push   $0x2c
  jmp alltraps
80106b27:	e9 83 f9 ff ff       	jmp    801064af <alltraps>

80106b2c <vector45>:
.globl vector45
vector45:
  pushl $0
80106b2c:	6a 00                	push   $0x0
  pushl $45
80106b2e:	6a 2d                	push   $0x2d
  jmp alltraps
80106b30:	e9 7a f9 ff ff       	jmp    801064af <alltraps>

80106b35 <vector46>:
.globl vector46
vector46:
  pushl $0
80106b35:	6a 00                	push   $0x0
  pushl $46
80106b37:	6a 2e                	push   $0x2e
  jmp alltraps
80106b39:	e9 71 f9 ff ff       	jmp    801064af <alltraps>

80106b3e <vector47>:
.globl vector47
vector47:
  pushl $0
80106b3e:	6a 00                	push   $0x0
  pushl $47
80106b40:	6a 2f                	push   $0x2f
  jmp alltraps
80106b42:	e9 68 f9 ff ff       	jmp    801064af <alltraps>

80106b47 <vector48>:
.globl vector48
vector48:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $48
80106b49:	6a 30                	push   $0x30
  jmp alltraps
80106b4b:	e9 5f f9 ff ff       	jmp    801064af <alltraps>

80106b50 <vector49>:
.globl vector49
vector49:
  pushl $0
80106b50:	6a 00                	push   $0x0
  pushl $49
80106b52:	6a 31                	push   $0x31
  jmp alltraps
80106b54:	e9 56 f9 ff ff       	jmp    801064af <alltraps>

80106b59 <vector50>:
.globl vector50
vector50:
  pushl $0
80106b59:	6a 00                	push   $0x0
  pushl $50
80106b5b:	6a 32                	push   $0x32
  jmp alltraps
80106b5d:	e9 4d f9 ff ff       	jmp    801064af <alltraps>

80106b62 <vector51>:
.globl vector51
vector51:
  pushl $0
80106b62:	6a 00                	push   $0x0
  pushl $51
80106b64:	6a 33                	push   $0x33
  jmp alltraps
80106b66:	e9 44 f9 ff ff       	jmp    801064af <alltraps>

80106b6b <vector52>:
.globl vector52
vector52:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $52
80106b6d:	6a 34                	push   $0x34
  jmp alltraps
80106b6f:	e9 3b f9 ff ff       	jmp    801064af <alltraps>

80106b74 <vector53>:
.globl vector53
vector53:
  pushl $0
80106b74:	6a 00                	push   $0x0
  pushl $53
80106b76:	6a 35                	push   $0x35
  jmp alltraps
80106b78:	e9 32 f9 ff ff       	jmp    801064af <alltraps>

80106b7d <vector54>:
.globl vector54
vector54:
  pushl $0
80106b7d:	6a 00                	push   $0x0
  pushl $54
80106b7f:	6a 36                	push   $0x36
  jmp alltraps
80106b81:	e9 29 f9 ff ff       	jmp    801064af <alltraps>

80106b86 <vector55>:
.globl vector55
vector55:
  pushl $0
80106b86:	6a 00                	push   $0x0
  pushl $55
80106b88:	6a 37                	push   $0x37
  jmp alltraps
80106b8a:	e9 20 f9 ff ff       	jmp    801064af <alltraps>

80106b8f <vector56>:
.globl vector56
vector56:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $56
80106b91:	6a 38                	push   $0x38
  jmp alltraps
80106b93:	e9 17 f9 ff ff       	jmp    801064af <alltraps>

80106b98 <vector57>:
.globl vector57
vector57:
  pushl $0
80106b98:	6a 00                	push   $0x0
  pushl $57
80106b9a:	6a 39                	push   $0x39
  jmp alltraps
80106b9c:	e9 0e f9 ff ff       	jmp    801064af <alltraps>

80106ba1 <vector58>:
.globl vector58
vector58:
  pushl $0
80106ba1:	6a 00                	push   $0x0
  pushl $58
80106ba3:	6a 3a                	push   $0x3a
  jmp alltraps
80106ba5:	e9 05 f9 ff ff       	jmp    801064af <alltraps>

80106baa <vector59>:
.globl vector59
vector59:
  pushl $0
80106baa:	6a 00                	push   $0x0
  pushl $59
80106bac:	6a 3b                	push   $0x3b
  jmp alltraps
80106bae:	e9 fc f8 ff ff       	jmp    801064af <alltraps>

80106bb3 <vector60>:
.globl vector60
vector60:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $60
80106bb5:	6a 3c                	push   $0x3c
  jmp alltraps
80106bb7:	e9 f3 f8 ff ff       	jmp    801064af <alltraps>

80106bbc <vector61>:
.globl vector61
vector61:
  pushl $0
80106bbc:	6a 00                	push   $0x0
  pushl $61
80106bbe:	6a 3d                	push   $0x3d
  jmp alltraps
80106bc0:	e9 ea f8 ff ff       	jmp    801064af <alltraps>

80106bc5 <vector62>:
.globl vector62
vector62:
  pushl $0
80106bc5:	6a 00                	push   $0x0
  pushl $62
80106bc7:	6a 3e                	push   $0x3e
  jmp alltraps
80106bc9:	e9 e1 f8 ff ff       	jmp    801064af <alltraps>

80106bce <vector63>:
.globl vector63
vector63:
  pushl $0
80106bce:	6a 00                	push   $0x0
  pushl $63
80106bd0:	6a 3f                	push   $0x3f
  jmp alltraps
80106bd2:	e9 d8 f8 ff ff       	jmp    801064af <alltraps>

80106bd7 <vector64>:
.globl vector64
vector64:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $64
80106bd9:	6a 40                	push   $0x40
  jmp alltraps
80106bdb:	e9 cf f8 ff ff       	jmp    801064af <alltraps>

80106be0 <vector65>:
.globl vector65
vector65:
  pushl $0
80106be0:	6a 00                	push   $0x0
  pushl $65
80106be2:	6a 41                	push   $0x41
  jmp alltraps
80106be4:	e9 c6 f8 ff ff       	jmp    801064af <alltraps>

80106be9 <vector66>:
.globl vector66
vector66:
  pushl $0
80106be9:	6a 00                	push   $0x0
  pushl $66
80106beb:	6a 42                	push   $0x42
  jmp alltraps
80106bed:	e9 bd f8 ff ff       	jmp    801064af <alltraps>

80106bf2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106bf2:	6a 00                	push   $0x0
  pushl $67
80106bf4:	6a 43                	push   $0x43
  jmp alltraps
80106bf6:	e9 b4 f8 ff ff       	jmp    801064af <alltraps>

80106bfb <vector68>:
.globl vector68
vector68:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $68
80106bfd:	6a 44                	push   $0x44
  jmp alltraps
80106bff:	e9 ab f8 ff ff       	jmp    801064af <alltraps>

80106c04 <vector69>:
.globl vector69
vector69:
  pushl $0
80106c04:	6a 00                	push   $0x0
  pushl $69
80106c06:	6a 45                	push   $0x45
  jmp alltraps
80106c08:	e9 a2 f8 ff ff       	jmp    801064af <alltraps>

80106c0d <vector70>:
.globl vector70
vector70:
  pushl $0
80106c0d:	6a 00                	push   $0x0
  pushl $70
80106c0f:	6a 46                	push   $0x46
  jmp alltraps
80106c11:	e9 99 f8 ff ff       	jmp    801064af <alltraps>

80106c16 <vector71>:
.globl vector71
vector71:
  pushl $0
80106c16:	6a 00                	push   $0x0
  pushl $71
80106c18:	6a 47                	push   $0x47
  jmp alltraps
80106c1a:	e9 90 f8 ff ff       	jmp    801064af <alltraps>

80106c1f <vector72>:
.globl vector72
vector72:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $72
80106c21:	6a 48                	push   $0x48
  jmp alltraps
80106c23:	e9 87 f8 ff ff       	jmp    801064af <alltraps>

80106c28 <vector73>:
.globl vector73
vector73:
  pushl $0
80106c28:	6a 00                	push   $0x0
  pushl $73
80106c2a:	6a 49                	push   $0x49
  jmp alltraps
80106c2c:	e9 7e f8 ff ff       	jmp    801064af <alltraps>

80106c31 <vector74>:
.globl vector74
vector74:
  pushl $0
80106c31:	6a 00                	push   $0x0
  pushl $74
80106c33:	6a 4a                	push   $0x4a
  jmp alltraps
80106c35:	e9 75 f8 ff ff       	jmp    801064af <alltraps>

80106c3a <vector75>:
.globl vector75
vector75:
  pushl $0
80106c3a:	6a 00                	push   $0x0
  pushl $75
80106c3c:	6a 4b                	push   $0x4b
  jmp alltraps
80106c3e:	e9 6c f8 ff ff       	jmp    801064af <alltraps>

80106c43 <vector76>:
.globl vector76
vector76:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $76
80106c45:	6a 4c                	push   $0x4c
  jmp alltraps
80106c47:	e9 63 f8 ff ff       	jmp    801064af <alltraps>

80106c4c <vector77>:
.globl vector77
vector77:
  pushl $0
80106c4c:	6a 00                	push   $0x0
  pushl $77
80106c4e:	6a 4d                	push   $0x4d
  jmp alltraps
80106c50:	e9 5a f8 ff ff       	jmp    801064af <alltraps>

80106c55 <vector78>:
.globl vector78
vector78:
  pushl $0
80106c55:	6a 00                	push   $0x0
  pushl $78
80106c57:	6a 4e                	push   $0x4e
  jmp alltraps
80106c59:	e9 51 f8 ff ff       	jmp    801064af <alltraps>

80106c5e <vector79>:
.globl vector79
vector79:
  pushl $0
80106c5e:	6a 00                	push   $0x0
  pushl $79
80106c60:	6a 4f                	push   $0x4f
  jmp alltraps
80106c62:	e9 48 f8 ff ff       	jmp    801064af <alltraps>

80106c67 <vector80>:
.globl vector80
vector80:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $80
80106c69:	6a 50                	push   $0x50
  jmp alltraps
80106c6b:	e9 3f f8 ff ff       	jmp    801064af <alltraps>

80106c70 <vector81>:
.globl vector81
vector81:
  pushl $0
80106c70:	6a 00                	push   $0x0
  pushl $81
80106c72:	6a 51                	push   $0x51
  jmp alltraps
80106c74:	e9 36 f8 ff ff       	jmp    801064af <alltraps>

80106c79 <vector82>:
.globl vector82
vector82:
  pushl $0
80106c79:	6a 00                	push   $0x0
  pushl $82
80106c7b:	6a 52                	push   $0x52
  jmp alltraps
80106c7d:	e9 2d f8 ff ff       	jmp    801064af <alltraps>

80106c82 <vector83>:
.globl vector83
vector83:
  pushl $0
80106c82:	6a 00                	push   $0x0
  pushl $83
80106c84:	6a 53                	push   $0x53
  jmp alltraps
80106c86:	e9 24 f8 ff ff       	jmp    801064af <alltraps>

80106c8b <vector84>:
.globl vector84
vector84:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $84
80106c8d:	6a 54                	push   $0x54
  jmp alltraps
80106c8f:	e9 1b f8 ff ff       	jmp    801064af <alltraps>

80106c94 <vector85>:
.globl vector85
vector85:
  pushl $0
80106c94:	6a 00                	push   $0x0
  pushl $85
80106c96:	6a 55                	push   $0x55
  jmp alltraps
80106c98:	e9 12 f8 ff ff       	jmp    801064af <alltraps>

80106c9d <vector86>:
.globl vector86
vector86:
  pushl $0
80106c9d:	6a 00                	push   $0x0
  pushl $86
80106c9f:	6a 56                	push   $0x56
  jmp alltraps
80106ca1:	e9 09 f8 ff ff       	jmp    801064af <alltraps>

80106ca6 <vector87>:
.globl vector87
vector87:
  pushl $0
80106ca6:	6a 00                	push   $0x0
  pushl $87
80106ca8:	6a 57                	push   $0x57
  jmp alltraps
80106caa:	e9 00 f8 ff ff       	jmp    801064af <alltraps>

80106caf <vector88>:
.globl vector88
vector88:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $88
80106cb1:	6a 58                	push   $0x58
  jmp alltraps
80106cb3:	e9 f7 f7 ff ff       	jmp    801064af <alltraps>

80106cb8 <vector89>:
.globl vector89
vector89:
  pushl $0
80106cb8:	6a 00                	push   $0x0
  pushl $89
80106cba:	6a 59                	push   $0x59
  jmp alltraps
80106cbc:	e9 ee f7 ff ff       	jmp    801064af <alltraps>

80106cc1 <vector90>:
.globl vector90
vector90:
  pushl $0
80106cc1:	6a 00                	push   $0x0
  pushl $90
80106cc3:	6a 5a                	push   $0x5a
  jmp alltraps
80106cc5:	e9 e5 f7 ff ff       	jmp    801064af <alltraps>

80106cca <vector91>:
.globl vector91
vector91:
  pushl $0
80106cca:	6a 00                	push   $0x0
  pushl $91
80106ccc:	6a 5b                	push   $0x5b
  jmp alltraps
80106cce:	e9 dc f7 ff ff       	jmp    801064af <alltraps>

80106cd3 <vector92>:
.globl vector92
vector92:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $92
80106cd5:	6a 5c                	push   $0x5c
  jmp alltraps
80106cd7:	e9 d3 f7 ff ff       	jmp    801064af <alltraps>

80106cdc <vector93>:
.globl vector93
vector93:
  pushl $0
80106cdc:	6a 00                	push   $0x0
  pushl $93
80106cde:	6a 5d                	push   $0x5d
  jmp alltraps
80106ce0:	e9 ca f7 ff ff       	jmp    801064af <alltraps>

80106ce5 <vector94>:
.globl vector94
vector94:
  pushl $0
80106ce5:	6a 00                	push   $0x0
  pushl $94
80106ce7:	6a 5e                	push   $0x5e
  jmp alltraps
80106ce9:	e9 c1 f7 ff ff       	jmp    801064af <alltraps>

80106cee <vector95>:
.globl vector95
vector95:
  pushl $0
80106cee:	6a 00                	push   $0x0
  pushl $95
80106cf0:	6a 5f                	push   $0x5f
  jmp alltraps
80106cf2:	e9 b8 f7 ff ff       	jmp    801064af <alltraps>

80106cf7 <vector96>:
.globl vector96
vector96:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $96
80106cf9:	6a 60                	push   $0x60
  jmp alltraps
80106cfb:	e9 af f7 ff ff       	jmp    801064af <alltraps>

80106d00 <vector97>:
.globl vector97
vector97:
  pushl $0
80106d00:	6a 00                	push   $0x0
  pushl $97
80106d02:	6a 61                	push   $0x61
  jmp alltraps
80106d04:	e9 a6 f7 ff ff       	jmp    801064af <alltraps>

80106d09 <vector98>:
.globl vector98
vector98:
  pushl $0
80106d09:	6a 00                	push   $0x0
  pushl $98
80106d0b:	6a 62                	push   $0x62
  jmp alltraps
80106d0d:	e9 9d f7 ff ff       	jmp    801064af <alltraps>

80106d12 <vector99>:
.globl vector99
vector99:
  pushl $0
80106d12:	6a 00                	push   $0x0
  pushl $99
80106d14:	6a 63                	push   $0x63
  jmp alltraps
80106d16:	e9 94 f7 ff ff       	jmp    801064af <alltraps>

80106d1b <vector100>:
.globl vector100
vector100:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $100
80106d1d:	6a 64                	push   $0x64
  jmp alltraps
80106d1f:	e9 8b f7 ff ff       	jmp    801064af <alltraps>

80106d24 <vector101>:
.globl vector101
vector101:
  pushl $0
80106d24:	6a 00                	push   $0x0
  pushl $101
80106d26:	6a 65                	push   $0x65
  jmp alltraps
80106d28:	e9 82 f7 ff ff       	jmp    801064af <alltraps>

80106d2d <vector102>:
.globl vector102
vector102:
  pushl $0
80106d2d:	6a 00                	push   $0x0
  pushl $102
80106d2f:	6a 66                	push   $0x66
  jmp alltraps
80106d31:	e9 79 f7 ff ff       	jmp    801064af <alltraps>

80106d36 <vector103>:
.globl vector103
vector103:
  pushl $0
80106d36:	6a 00                	push   $0x0
  pushl $103
80106d38:	6a 67                	push   $0x67
  jmp alltraps
80106d3a:	e9 70 f7 ff ff       	jmp    801064af <alltraps>

80106d3f <vector104>:
.globl vector104
vector104:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $104
80106d41:	6a 68                	push   $0x68
  jmp alltraps
80106d43:	e9 67 f7 ff ff       	jmp    801064af <alltraps>

80106d48 <vector105>:
.globl vector105
vector105:
  pushl $0
80106d48:	6a 00                	push   $0x0
  pushl $105
80106d4a:	6a 69                	push   $0x69
  jmp alltraps
80106d4c:	e9 5e f7 ff ff       	jmp    801064af <alltraps>

80106d51 <vector106>:
.globl vector106
vector106:
  pushl $0
80106d51:	6a 00                	push   $0x0
  pushl $106
80106d53:	6a 6a                	push   $0x6a
  jmp alltraps
80106d55:	e9 55 f7 ff ff       	jmp    801064af <alltraps>

80106d5a <vector107>:
.globl vector107
vector107:
  pushl $0
80106d5a:	6a 00                	push   $0x0
  pushl $107
80106d5c:	6a 6b                	push   $0x6b
  jmp alltraps
80106d5e:	e9 4c f7 ff ff       	jmp    801064af <alltraps>

80106d63 <vector108>:
.globl vector108
vector108:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $108
80106d65:	6a 6c                	push   $0x6c
  jmp alltraps
80106d67:	e9 43 f7 ff ff       	jmp    801064af <alltraps>

80106d6c <vector109>:
.globl vector109
vector109:
  pushl $0
80106d6c:	6a 00                	push   $0x0
  pushl $109
80106d6e:	6a 6d                	push   $0x6d
  jmp alltraps
80106d70:	e9 3a f7 ff ff       	jmp    801064af <alltraps>

80106d75 <vector110>:
.globl vector110
vector110:
  pushl $0
80106d75:	6a 00                	push   $0x0
  pushl $110
80106d77:	6a 6e                	push   $0x6e
  jmp alltraps
80106d79:	e9 31 f7 ff ff       	jmp    801064af <alltraps>

80106d7e <vector111>:
.globl vector111
vector111:
  pushl $0
80106d7e:	6a 00                	push   $0x0
  pushl $111
80106d80:	6a 6f                	push   $0x6f
  jmp alltraps
80106d82:	e9 28 f7 ff ff       	jmp    801064af <alltraps>

80106d87 <vector112>:
.globl vector112
vector112:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $112
80106d89:	6a 70                	push   $0x70
  jmp alltraps
80106d8b:	e9 1f f7 ff ff       	jmp    801064af <alltraps>

80106d90 <vector113>:
.globl vector113
vector113:
  pushl $0
80106d90:	6a 00                	push   $0x0
  pushl $113
80106d92:	6a 71                	push   $0x71
  jmp alltraps
80106d94:	e9 16 f7 ff ff       	jmp    801064af <alltraps>

80106d99 <vector114>:
.globl vector114
vector114:
  pushl $0
80106d99:	6a 00                	push   $0x0
  pushl $114
80106d9b:	6a 72                	push   $0x72
  jmp alltraps
80106d9d:	e9 0d f7 ff ff       	jmp    801064af <alltraps>

80106da2 <vector115>:
.globl vector115
vector115:
  pushl $0
80106da2:	6a 00                	push   $0x0
  pushl $115
80106da4:	6a 73                	push   $0x73
  jmp alltraps
80106da6:	e9 04 f7 ff ff       	jmp    801064af <alltraps>

80106dab <vector116>:
.globl vector116
vector116:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $116
80106dad:	6a 74                	push   $0x74
  jmp alltraps
80106daf:	e9 fb f6 ff ff       	jmp    801064af <alltraps>

80106db4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106db4:	6a 00                	push   $0x0
  pushl $117
80106db6:	6a 75                	push   $0x75
  jmp alltraps
80106db8:	e9 f2 f6 ff ff       	jmp    801064af <alltraps>

80106dbd <vector118>:
.globl vector118
vector118:
  pushl $0
80106dbd:	6a 00                	push   $0x0
  pushl $118
80106dbf:	6a 76                	push   $0x76
  jmp alltraps
80106dc1:	e9 e9 f6 ff ff       	jmp    801064af <alltraps>

80106dc6 <vector119>:
.globl vector119
vector119:
  pushl $0
80106dc6:	6a 00                	push   $0x0
  pushl $119
80106dc8:	6a 77                	push   $0x77
  jmp alltraps
80106dca:	e9 e0 f6 ff ff       	jmp    801064af <alltraps>

80106dcf <vector120>:
.globl vector120
vector120:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $120
80106dd1:	6a 78                	push   $0x78
  jmp alltraps
80106dd3:	e9 d7 f6 ff ff       	jmp    801064af <alltraps>

80106dd8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106dd8:	6a 00                	push   $0x0
  pushl $121
80106dda:	6a 79                	push   $0x79
  jmp alltraps
80106ddc:	e9 ce f6 ff ff       	jmp    801064af <alltraps>

80106de1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106de1:	6a 00                	push   $0x0
  pushl $122
80106de3:	6a 7a                	push   $0x7a
  jmp alltraps
80106de5:	e9 c5 f6 ff ff       	jmp    801064af <alltraps>

80106dea <vector123>:
.globl vector123
vector123:
  pushl $0
80106dea:	6a 00                	push   $0x0
  pushl $123
80106dec:	6a 7b                	push   $0x7b
  jmp alltraps
80106dee:	e9 bc f6 ff ff       	jmp    801064af <alltraps>

80106df3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $124
80106df5:	6a 7c                	push   $0x7c
  jmp alltraps
80106df7:	e9 b3 f6 ff ff       	jmp    801064af <alltraps>

80106dfc <vector125>:
.globl vector125
vector125:
  pushl $0
80106dfc:	6a 00                	push   $0x0
  pushl $125
80106dfe:	6a 7d                	push   $0x7d
  jmp alltraps
80106e00:	e9 aa f6 ff ff       	jmp    801064af <alltraps>

80106e05 <vector126>:
.globl vector126
vector126:
  pushl $0
80106e05:	6a 00                	push   $0x0
  pushl $126
80106e07:	6a 7e                	push   $0x7e
  jmp alltraps
80106e09:	e9 a1 f6 ff ff       	jmp    801064af <alltraps>

80106e0e <vector127>:
.globl vector127
vector127:
  pushl $0
80106e0e:	6a 00                	push   $0x0
  pushl $127
80106e10:	6a 7f                	push   $0x7f
  jmp alltraps
80106e12:	e9 98 f6 ff ff       	jmp    801064af <alltraps>

80106e17 <vector128>:
.globl vector128
vector128:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $128
80106e19:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106e1e:	e9 8c f6 ff ff       	jmp    801064af <alltraps>

80106e23 <vector129>:
.globl vector129
vector129:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $129
80106e25:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106e2a:	e9 80 f6 ff ff       	jmp    801064af <alltraps>

80106e2f <vector130>:
.globl vector130
vector130:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $130
80106e31:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106e36:	e9 74 f6 ff ff       	jmp    801064af <alltraps>

80106e3b <vector131>:
.globl vector131
vector131:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $131
80106e3d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106e42:	e9 68 f6 ff ff       	jmp    801064af <alltraps>

80106e47 <vector132>:
.globl vector132
vector132:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $132
80106e49:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106e4e:	e9 5c f6 ff ff       	jmp    801064af <alltraps>

80106e53 <vector133>:
.globl vector133
vector133:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $133
80106e55:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106e5a:	e9 50 f6 ff ff       	jmp    801064af <alltraps>

80106e5f <vector134>:
.globl vector134
vector134:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $134
80106e61:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106e66:	e9 44 f6 ff ff       	jmp    801064af <alltraps>

80106e6b <vector135>:
.globl vector135
vector135:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $135
80106e6d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106e72:	e9 38 f6 ff ff       	jmp    801064af <alltraps>

80106e77 <vector136>:
.globl vector136
vector136:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $136
80106e79:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106e7e:	e9 2c f6 ff ff       	jmp    801064af <alltraps>

80106e83 <vector137>:
.globl vector137
vector137:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $137
80106e85:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106e8a:	e9 20 f6 ff ff       	jmp    801064af <alltraps>

80106e8f <vector138>:
.globl vector138
vector138:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $138
80106e91:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106e96:	e9 14 f6 ff ff       	jmp    801064af <alltraps>

80106e9b <vector139>:
.globl vector139
vector139:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $139
80106e9d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ea2:	e9 08 f6 ff ff       	jmp    801064af <alltraps>

80106ea7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $140
80106ea9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106eae:	e9 fc f5 ff ff       	jmp    801064af <alltraps>

80106eb3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $141
80106eb5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106eba:	e9 f0 f5 ff ff       	jmp    801064af <alltraps>

80106ebf <vector142>:
.globl vector142
vector142:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $142
80106ec1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106ec6:	e9 e4 f5 ff ff       	jmp    801064af <alltraps>

80106ecb <vector143>:
.globl vector143
vector143:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $143
80106ecd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ed2:	e9 d8 f5 ff ff       	jmp    801064af <alltraps>

80106ed7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $144
80106ed9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106ede:	e9 cc f5 ff ff       	jmp    801064af <alltraps>

80106ee3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $145
80106ee5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106eea:	e9 c0 f5 ff ff       	jmp    801064af <alltraps>

80106eef <vector146>:
.globl vector146
vector146:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $146
80106ef1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106ef6:	e9 b4 f5 ff ff       	jmp    801064af <alltraps>

80106efb <vector147>:
.globl vector147
vector147:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $147
80106efd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106f02:	e9 a8 f5 ff ff       	jmp    801064af <alltraps>

80106f07 <vector148>:
.globl vector148
vector148:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $148
80106f09:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106f0e:	e9 9c f5 ff ff       	jmp    801064af <alltraps>

80106f13 <vector149>:
.globl vector149
vector149:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $149
80106f15:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106f1a:	e9 90 f5 ff ff       	jmp    801064af <alltraps>

80106f1f <vector150>:
.globl vector150
vector150:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $150
80106f21:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106f26:	e9 84 f5 ff ff       	jmp    801064af <alltraps>

80106f2b <vector151>:
.globl vector151
vector151:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $151
80106f2d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106f32:	e9 78 f5 ff ff       	jmp    801064af <alltraps>

80106f37 <vector152>:
.globl vector152
vector152:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $152
80106f39:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106f3e:	e9 6c f5 ff ff       	jmp    801064af <alltraps>

80106f43 <vector153>:
.globl vector153
vector153:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $153
80106f45:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106f4a:	e9 60 f5 ff ff       	jmp    801064af <alltraps>

80106f4f <vector154>:
.globl vector154
vector154:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $154
80106f51:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106f56:	e9 54 f5 ff ff       	jmp    801064af <alltraps>

80106f5b <vector155>:
.globl vector155
vector155:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $155
80106f5d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106f62:	e9 48 f5 ff ff       	jmp    801064af <alltraps>

80106f67 <vector156>:
.globl vector156
vector156:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $156
80106f69:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106f6e:	e9 3c f5 ff ff       	jmp    801064af <alltraps>

80106f73 <vector157>:
.globl vector157
vector157:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $157
80106f75:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106f7a:	e9 30 f5 ff ff       	jmp    801064af <alltraps>

80106f7f <vector158>:
.globl vector158
vector158:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $158
80106f81:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106f86:	e9 24 f5 ff ff       	jmp    801064af <alltraps>

80106f8b <vector159>:
.globl vector159
vector159:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $159
80106f8d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106f92:	e9 18 f5 ff ff       	jmp    801064af <alltraps>

80106f97 <vector160>:
.globl vector160
vector160:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $160
80106f99:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106f9e:	e9 0c f5 ff ff       	jmp    801064af <alltraps>

80106fa3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $161
80106fa5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106faa:	e9 00 f5 ff ff       	jmp    801064af <alltraps>

80106faf <vector162>:
.globl vector162
vector162:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $162
80106fb1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106fb6:	e9 f4 f4 ff ff       	jmp    801064af <alltraps>

80106fbb <vector163>:
.globl vector163
vector163:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $163
80106fbd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106fc2:	e9 e8 f4 ff ff       	jmp    801064af <alltraps>

80106fc7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $164
80106fc9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106fce:	e9 dc f4 ff ff       	jmp    801064af <alltraps>

80106fd3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $165
80106fd5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106fda:	e9 d0 f4 ff ff       	jmp    801064af <alltraps>

80106fdf <vector166>:
.globl vector166
vector166:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $166
80106fe1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106fe6:	e9 c4 f4 ff ff       	jmp    801064af <alltraps>

80106feb <vector167>:
.globl vector167
vector167:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $167
80106fed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106ff2:	e9 b8 f4 ff ff       	jmp    801064af <alltraps>

80106ff7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $168
80106ff9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106ffe:	e9 ac f4 ff ff       	jmp    801064af <alltraps>

80107003 <vector169>:
.globl vector169
vector169:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $169
80107005:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010700a:	e9 a0 f4 ff ff       	jmp    801064af <alltraps>

8010700f <vector170>:
.globl vector170
vector170:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $170
80107011:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107016:	e9 94 f4 ff ff       	jmp    801064af <alltraps>

8010701b <vector171>:
.globl vector171
vector171:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $171
8010701d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107022:	e9 88 f4 ff ff       	jmp    801064af <alltraps>

80107027 <vector172>:
.globl vector172
vector172:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $172
80107029:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010702e:	e9 7c f4 ff ff       	jmp    801064af <alltraps>

80107033 <vector173>:
.globl vector173
vector173:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $173
80107035:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010703a:	e9 70 f4 ff ff       	jmp    801064af <alltraps>

8010703f <vector174>:
.globl vector174
vector174:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $174
80107041:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107046:	e9 64 f4 ff ff       	jmp    801064af <alltraps>

8010704b <vector175>:
.globl vector175
vector175:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $175
8010704d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107052:	e9 58 f4 ff ff       	jmp    801064af <alltraps>

80107057 <vector176>:
.globl vector176
vector176:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $176
80107059:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010705e:	e9 4c f4 ff ff       	jmp    801064af <alltraps>

80107063 <vector177>:
.globl vector177
vector177:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $177
80107065:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010706a:	e9 40 f4 ff ff       	jmp    801064af <alltraps>

8010706f <vector178>:
.globl vector178
vector178:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $178
80107071:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107076:	e9 34 f4 ff ff       	jmp    801064af <alltraps>

8010707b <vector179>:
.globl vector179
vector179:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $179
8010707d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107082:	e9 28 f4 ff ff       	jmp    801064af <alltraps>

80107087 <vector180>:
.globl vector180
vector180:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $180
80107089:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010708e:	e9 1c f4 ff ff       	jmp    801064af <alltraps>

80107093 <vector181>:
.globl vector181
vector181:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $181
80107095:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010709a:	e9 10 f4 ff ff       	jmp    801064af <alltraps>

8010709f <vector182>:
.globl vector182
vector182:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $182
801070a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801070a6:	e9 04 f4 ff ff       	jmp    801064af <alltraps>

801070ab <vector183>:
.globl vector183
vector183:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $183
801070ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801070b2:	e9 f8 f3 ff ff       	jmp    801064af <alltraps>

801070b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $184
801070b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801070be:	e9 ec f3 ff ff       	jmp    801064af <alltraps>

801070c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $185
801070c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801070ca:	e9 e0 f3 ff ff       	jmp    801064af <alltraps>

801070cf <vector186>:
.globl vector186
vector186:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $186
801070d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801070d6:	e9 d4 f3 ff ff       	jmp    801064af <alltraps>

801070db <vector187>:
.globl vector187
vector187:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $187
801070dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801070e2:	e9 c8 f3 ff ff       	jmp    801064af <alltraps>

801070e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $188
801070e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801070ee:	e9 bc f3 ff ff       	jmp    801064af <alltraps>

801070f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $189
801070f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801070fa:	e9 b0 f3 ff ff       	jmp    801064af <alltraps>

801070ff <vector190>:
.globl vector190
vector190:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $190
80107101:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107106:	e9 a4 f3 ff ff       	jmp    801064af <alltraps>

8010710b <vector191>:
.globl vector191
vector191:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $191
8010710d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107112:	e9 98 f3 ff ff       	jmp    801064af <alltraps>

80107117 <vector192>:
.globl vector192
vector192:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $192
80107119:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010711e:	e9 8c f3 ff ff       	jmp    801064af <alltraps>

80107123 <vector193>:
.globl vector193
vector193:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $193
80107125:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010712a:	e9 80 f3 ff ff       	jmp    801064af <alltraps>

8010712f <vector194>:
.globl vector194
vector194:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $194
80107131:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107136:	e9 74 f3 ff ff       	jmp    801064af <alltraps>

8010713b <vector195>:
.globl vector195
vector195:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $195
8010713d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107142:	e9 68 f3 ff ff       	jmp    801064af <alltraps>

80107147 <vector196>:
.globl vector196
vector196:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $196
80107149:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010714e:	e9 5c f3 ff ff       	jmp    801064af <alltraps>

80107153 <vector197>:
.globl vector197
vector197:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $197
80107155:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010715a:	e9 50 f3 ff ff       	jmp    801064af <alltraps>

8010715f <vector198>:
.globl vector198
vector198:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $198
80107161:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107166:	e9 44 f3 ff ff       	jmp    801064af <alltraps>

8010716b <vector199>:
.globl vector199
vector199:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $199
8010716d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107172:	e9 38 f3 ff ff       	jmp    801064af <alltraps>

80107177 <vector200>:
.globl vector200
vector200:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $200
80107179:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010717e:	e9 2c f3 ff ff       	jmp    801064af <alltraps>

80107183 <vector201>:
.globl vector201
vector201:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $201
80107185:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010718a:	e9 20 f3 ff ff       	jmp    801064af <alltraps>

8010718f <vector202>:
.globl vector202
vector202:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $202
80107191:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107196:	e9 14 f3 ff ff       	jmp    801064af <alltraps>

8010719b <vector203>:
.globl vector203
vector203:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $203
8010719d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801071a2:	e9 08 f3 ff ff       	jmp    801064af <alltraps>

801071a7 <vector204>:
.globl vector204
vector204:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $204
801071a9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801071ae:	e9 fc f2 ff ff       	jmp    801064af <alltraps>

801071b3 <vector205>:
.globl vector205
vector205:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $205
801071b5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801071ba:	e9 f0 f2 ff ff       	jmp    801064af <alltraps>

801071bf <vector206>:
.globl vector206
vector206:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $206
801071c1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801071c6:	e9 e4 f2 ff ff       	jmp    801064af <alltraps>

801071cb <vector207>:
.globl vector207
vector207:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $207
801071cd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801071d2:	e9 d8 f2 ff ff       	jmp    801064af <alltraps>

801071d7 <vector208>:
.globl vector208
vector208:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $208
801071d9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801071de:	e9 cc f2 ff ff       	jmp    801064af <alltraps>

801071e3 <vector209>:
.globl vector209
vector209:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $209
801071e5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801071ea:	e9 c0 f2 ff ff       	jmp    801064af <alltraps>

801071ef <vector210>:
.globl vector210
vector210:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $210
801071f1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801071f6:	e9 b4 f2 ff ff       	jmp    801064af <alltraps>

801071fb <vector211>:
.globl vector211
vector211:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $211
801071fd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107202:	e9 a8 f2 ff ff       	jmp    801064af <alltraps>

80107207 <vector212>:
.globl vector212
vector212:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $212
80107209:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010720e:	e9 9c f2 ff ff       	jmp    801064af <alltraps>

80107213 <vector213>:
.globl vector213
vector213:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $213
80107215:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010721a:	e9 90 f2 ff ff       	jmp    801064af <alltraps>

8010721f <vector214>:
.globl vector214
vector214:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $214
80107221:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107226:	e9 84 f2 ff ff       	jmp    801064af <alltraps>

8010722b <vector215>:
.globl vector215
vector215:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $215
8010722d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107232:	e9 78 f2 ff ff       	jmp    801064af <alltraps>

80107237 <vector216>:
.globl vector216
vector216:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $216
80107239:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010723e:	e9 6c f2 ff ff       	jmp    801064af <alltraps>

80107243 <vector217>:
.globl vector217
vector217:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $217
80107245:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010724a:	e9 60 f2 ff ff       	jmp    801064af <alltraps>

8010724f <vector218>:
.globl vector218
vector218:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $218
80107251:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107256:	e9 54 f2 ff ff       	jmp    801064af <alltraps>

8010725b <vector219>:
.globl vector219
vector219:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $219
8010725d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107262:	e9 48 f2 ff ff       	jmp    801064af <alltraps>

80107267 <vector220>:
.globl vector220
vector220:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $220
80107269:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010726e:	e9 3c f2 ff ff       	jmp    801064af <alltraps>

80107273 <vector221>:
.globl vector221
vector221:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $221
80107275:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010727a:	e9 30 f2 ff ff       	jmp    801064af <alltraps>

8010727f <vector222>:
.globl vector222
vector222:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $222
80107281:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107286:	e9 24 f2 ff ff       	jmp    801064af <alltraps>

8010728b <vector223>:
.globl vector223
vector223:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $223
8010728d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107292:	e9 18 f2 ff ff       	jmp    801064af <alltraps>

80107297 <vector224>:
.globl vector224
vector224:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $224
80107299:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010729e:	e9 0c f2 ff ff       	jmp    801064af <alltraps>

801072a3 <vector225>:
.globl vector225
vector225:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $225
801072a5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801072aa:	e9 00 f2 ff ff       	jmp    801064af <alltraps>

801072af <vector226>:
.globl vector226
vector226:
  pushl $0
801072af:	6a 00                	push   $0x0
  pushl $226
801072b1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801072b6:	e9 f4 f1 ff ff       	jmp    801064af <alltraps>

801072bb <vector227>:
.globl vector227
vector227:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $227
801072bd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801072c2:	e9 e8 f1 ff ff       	jmp    801064af <alltraps>

801072c7 <vector228>:
.globl vector228
vector228:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $228
801072c9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801072ce:	e9 dc f1 ff ff       	jmp    801064af <alltraps>

801072d3 <vector229>:
.globl vector229
vector229:
  pushl $0
801072d3:	6a 00                	push   $0x0
  pushl $229
801072d5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801072da:	e9 d0 f1 ff ff       	jmp    801064af <alltraps>

801072df <vector230>:
.globl vector230
vector230:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $230
801072e1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801072e6:	e9 c4 f1 ff ff       	jmp    801064af <alltraps>

801072eb <vector231>:
.globl vector231
vector231:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $231
801072ed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801072f2:	e9 b8 f1 ff ff       	jmp    801064af <alltraps>

801072f7 <vector232>:
.globl vector232
vector232:
  pushl $0
801072f7:	6a 00                	push   $0x0
  pushl $232
801072f9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801072fe:	e9 ac f1 ff ff       	jmp    801064af <alltraps>

80107303 <vector233>:
.globl vector233
vector233:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $233
80107305:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010730a:	e9 a0 f1 ff ff       	jmp    801064af <alltraps>

8010730f <vector234>:
.globl vector234
vector234:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $234
80107311:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107316:	e9 94 f1 ff ff       	jmp    801064af <alltraps>

8010731b <vector235>:
.globl vector235
vector235:
  pushl $0
8010731b:	6a 00                	push   $0x0
  pushl $235
8010731d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107322:	e9 88 f1 ff ff       	jmp    801064af <alltraps>

80107327 <vector236>:
.globl vector236
vector236:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $236
80107329:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010732e:	e9 7c f1 ff ff       	jmp    801064af <alltraps>

80107333 <vector237>:
.globl vector237
vector237:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $237
80107335:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010733a:	e9 70 f1 ff ff       	jmp    801064af <alltraps>

8010733f <vector238>:
.globl vector238
vector238:
  pushl $0
8010733f:	6a 00                	push   $0x0
  pushl $238
80107341:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107346:	e9 64 f1 ff ff       	jmp    801064af <alltraps>

8010734b <vector239>:
.globl vector239
vector239:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $239
8010734d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107352:	e9 58 f1 ff ff       	jmp    801064af <alltraps>

80107357 <vector240>:
.globl vector240
vector240:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $240
80107359:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010735e:	e9 4c f1 ff ff       	jmp    801064af <alltraps>

80107363 <vector241>:
.globl vector241
vector241:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $241
80107365:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010736a:	e9 40 f1 ff ff       	jmp    801064af <alltraps>

8010736f <vector242>:
.globl vector242
vector242:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $242
80107371:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107376:	e9 34 f1 ff ff       	jmp    801064af <alltraps>

8010737b <vector243>:
.globl vector243
vector243:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $243
8010737d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107382:	e9 28 f1 ff ff       	jmp    801064af <alltraps>

80107387 <vector244>:
.globl vector244
vector244:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $244
80107389:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010738e:	e9 1c f1 ff ff       	jmp    801064af <alltraps>

80107393 <vector245>:
.globl vector245
vector245:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $245
80107395:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010739a:	e9 10 f1 ff ff       	jmp    801064af <alltraps>

8010739f <vector246>:
.globl vector246
vector246:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $246
801073a1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801073a6:	e9 04 f1 ff ff       	jmp    801064af <alltraps>

801073ab <vector247>:
.globl vector247
vector247:
  pushl $0
801073ab:	6a 00                	push   $0x0
  pushl $247
801073ad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801073b2:	e9 f8 f0 ff ff       	jmp    801064af <alltraps>

801073b7 <vector248>:
.globl vector248
vector248:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $248
801073b9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801073be:	e9 ec f0 ff ff       	jmp    801064af <alltraps>

801073c3 <vector249>:
.globl vector249
vector249:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $249
801073c5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801073ca:	e9 e0 f0 ff ff       	jmp    801064af <alltraps>

801073cf <vector250>:
.globl vector250
vector250:
  pushl $0
801073cf:	6a 00                	push   $0x0
  pushl $250
801073d1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801073d6:	e9 d4 f0 ff ff       	jmp    801064af <alltraps>

801073db <vector251>:
.globl vector251
vector251:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $251
801073dd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801073e2:	e9 c8 f0 ff ff       	jmp    801064af <alltraps>

801073e7 <vector252>:
.globl vector252
vector252:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $252
801073e9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801073ee:	e9 bc f0 ff ff       	jmp    801064af <alltraps>

801073f3 <vector253>:
.globl vector253
vector253:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $253
801073f5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801073fa:	e9 b0 f0 ff ff       	jmp    801064af <alltraps>

801073ff <vector254>:
.globl vector254
vector254:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $254
80107401:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107406:	e9 a4 f0 ff ff       	jmp    801064af <alltraps>

8010740b <vector255>:
.globl vector255
vector255:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $255
8010740d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107412:	e9 98 f0 ff ff       	jmp    801064af <alltraps>
80107417:	66 90                	xchg   %ax,%ax
80107419:	66 90                	xchg   %ax,%ax
8010741b:	66 90                	xchg   %ax,%ax
8010741d:	66 90                	xchg   %ax,%ax
8010741f:	90                   	nop

80107420 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	57                   	push   %edi
80107424:	56                   	push   %esi
80107425:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107426:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010742c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107432:	83 ec 1c             	sub    $0x1c,%esp
80107435:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107438:	39 d3                	cmp    %edx,%ebx
8010743a:	73 49                	jae    80107485 <deallocuvm.part.0+0x65>
8010743c:	89 c7                	mov    %eax,%edi
8010743e:	eb 0c                	jmp    8010744c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107440:	83 c0 01             	add    $0x1,%eax
80107443:	c1 e0 16             	shl    $0x16,%eax
80107446:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107448:	39 da                	cmp    %ebx,%edx
8010744a:	76 39                	jbe    80107485 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010744c:	89 d8                	mov    %ebx,%eax
8010744e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107451:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107454:	f6 c1 01             	test   $0x1,%cl
80107457:	74 e7                	je     80107440 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107459:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010745b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107461:	c1 ee 0a             	shr    $0xa,%esi
80107464:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010746a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107471:	85 f6                	test   %esi,%esi
80107473:	74 cb                	je     80107440 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107475:	8b 06                	mov    (%esi),%eax
80107477:	a8 01                	test   $0x1,%al
80107479:	75 15                	jne    80107490 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010747b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107481:	39 da                	cmp    %ebx,%edx
80107483:	77 c7                	ja     8010744c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107485:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107488:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010748b:	5b                   	pop    %ebx
8010748c:	5e                   	pop    %esi
8010748d:	5f                   	pop    %edi
8010748e:	5d                   	pop    %ebp
8010748f:	c3                   	ret    
      if(pa == 0)
80107490:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107495:	74 25                	je     801074bc <deallocuvm.part.0+0x9c>
      kfree(v);
80107497:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010749a:	05 00 00 00 80       	add    $0x80000000,%eax
8010749f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801074a2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801074a8:	50                   	push   %eax
801074a9:	e8 12 b0 ff ff       	call   801024c0 <kfree>
      *pte = 0;
801074ae:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
801074b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074b7:	83 c4 10             	add    $0x10,%esp
801074ba:	eb 8c                	jmp    80107448 <deallocuvm.part.0+0x28>
        panic("kfree");
801074bc:	83 ec 0c             	sub    $0xc,%esp
801074bf:	68 86 80 10 80       	push   $0x80108086
801074c4:	e8 b7 8e ff ff       	call   80100380 <panic>
801074c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074d0 <mappages>:
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	57                   	push   %edi
801074d4:	56                   	push   %esi
801074d5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801074d6:	89 d3                	mov    %edx,%ebx
801074d8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801074de:	83 ec 1c             	sub    $0x1c,%esp
801074e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801074e4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801074e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
801074f0:	8b 45 08             	mov    0x8(%ebp),%eax
801074f3:	29 d8                	sub    %ebx,%eax
801074f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074f8:	eb 3d                	jmp    80107537 <mappages+0x67>
801074fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107500:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107502:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107507:	c1 ea 0a             	shr    $0xa,%edx
8010750a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107510:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107517:	85 c0                	test   %eax,%eax
80107519:	74 75                	je     80107590 <mappages+0xc0>
    if(*pte & PTE_P)
8010751b:	f6 00 01             	testb  $0x1,(%eax)
8010751e:	0f 85 86 00 00 00    	jne    801075aa <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107524:	0b 75 0c             	or     0xc(%ebp),%esi
80107527:	83 ce 01             	or     $0x1,%esi
8010752a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010752c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010752f:	74 6f                	je     801075a0 <mappages+0xd0>
    a += PGSIZE;
80107531:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107537:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010753a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010753d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107540:	89 d8                	mov    %ebx,%eax
80107542:	c1 e8 16             	shr    $0x16,%eax
80107545:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107548:	8b 07                	mov    (%edi),%eax
8010754a:	a8 01                	test   $0x1,%al
8010754c:	75 b2                	jne    80107500 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010754e:	e8 2d b1 ff ff       	call   80102680 <kalloc>
80107553:	85 c0                	test   %eax,%eax
80107555:	74 39                	je     80107590 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107557:	83 ec 04             	sub    $0x4,%esp
8010755a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010755d:	68 00 10 00 00       	push   $0x1000
80107562:	6a 00                	push   $0x0
80107564:	50                   	push   %eax
80107565:	e8 86 d7 ff ff       	call   80104cf0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010756a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010756d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107570:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107576:	83 c8 07             	or     $0x7,%eax
80107579:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010757b:	89 d8                	mov    %ebx,%eax
8010757d:	c1 e8 0a             	shr    $0xa,%eax
80107580:	25 fc 0f 00 00       	and    $0xffc,%eax
80107585:	01 d0                	add    %edx,%eax
80107587:	eb 92                	jmp    8010751b <mappages+0x4b>
80107589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107590:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107593:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107598:	5b                   	pop    %ebx
80107599:	5e                   	pop    %esi
8010759a:	5f                   	pop    %edi
8010759b:	5d                   	pop    %ebp
8010759c:	c3                   	ret    
8010759d:	8d 76 00             	lea    0x0(%esi),%esi
801075a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075a3:	31 c0                	xor    %eax,%eax
}
801075a5:	5b                   	pop    %ebx
801075a6:	5e                   	pop    %esi
801075a7:	5f                   	pop    %edi
801075a8:	5d                   	pop    %ebp
801075a9:	c3                   	ret    
      panic("remap");
801075aa:	83 ec 0c             	sub    $0xc,%esp
801075ad:	68 00 88 10 80       	push   $0x80108800
801075b2:	e8 c9 8d ff ff       	call   80100380 <panic>
801075b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075be:	66 90                	xchg   %ax,%ax

801075c0 <seginit>:
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801075c6:	e8 c5 c3 ff ff       	call   80103990 <cpuid>
  pd[0] = size-1;
801075cb:	ba 2f 00 00 00       	mov    $0x2f,%edx
801075d0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801075d6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801075da:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
801075e1:	ff 00 00 
801075e4:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
801075eb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801075ee:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
801075f5:	ff 00 00 
801075f8:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
801075ff:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107602:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107609:	ff 00 00 
8010760c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80107613:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107616:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
8010761d:	ff 00 00 
80107620:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80107627:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010762a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
8010762f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107633:	c1 e8 10             	shr    $0x10,%eax
80107636:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010763a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010763d:	0f 01 10             	lgdtl  (%eax)
}
80107640:	c9                   	leave  
80107641:	c3                   	ret    
80107642:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107650 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107650:	a1 c4 5d 11 80       	mov    0x80115dc4,%eax
80107655:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010765a:	0f 22 d8             	mov    %eax,%cr3
}
8010765d:	c3                   	ret    
8010765e:	66 90                	xchg   %ax,%ax

80107660 <switchuvm>:
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	57                   	push   %edi
80107664:	56                   	push   %esi
80107665:	53                   	push   %ebx
80107666:	83 ec 1c             	sub    $0x1c,%esp
80107669:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010766c:	85 f6                	test   %esi,%esi
8010766e:	0f 84 cb 00 00 00    	je     8010773f <switchuvm+0xdf>
  if(p->kstack == 0)
80107674:	8b 46 08             	mov    0x8(%esi),%eax
80107677:	85 c0                	test   %eax,%eax
80107679:	0f 84 da 00 00 00    	je     80107759 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010767f:	8b 46 04             	mov    0x4(%esi),%eax
80107682:	85 c0                	test   %eax,%eax
80107684:	0f 84 c2 00 00 00    	je     8010774c <switchuvm+0xec>
  pushcli();
8010768a:	e8 51 d4 ff ff       	call   80104ae0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010768f:	e8 9c c2 ff ff       	call   80103930 <mycpu>
80107694:	89 c3                	mov    %eax,%ebx
80107696:	e8 95 c2 ff ff       	call   80103930 <mycpu>
8010769b:	89 c7                	mov    %eax,%edi
8010769d:	e8 8e c2 ff ff       	call   80103930 <mycpu>
801076a2:	83 c7 08             	add    $0x8,%edi
801076a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801076a8:	e8 83 c2 ff ff       	call   80103930 <mycpu>
801076ad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801076b0:	ba 67 00 00 00       	mov    $0x67,%edx
801076b5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801076bc:	83 c0 08             	add    $0x8,%eax
801076bf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801076c6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801076cb:	83 c1 08             	add    $0x8,%ecx
801076ce:	c1 e8 18             	shr    $0x18,%eax
801076d1:	c1 e9 10             	shr    $0x10,%ecx
801076d4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801076da:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801076e0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801076e5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801076ec:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801076f1:	e8 3a c2 ff ff       	call   80103930 <mycpu>
801076f6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801076fd:	e8 2e c2 ff ff       	call   80103930 <mycpu>
80107702:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107706:	8b 5e 08             	mov    0x8(%esi),%ebx
80107709:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010770f:	e8 1c c2 ff ff       	call   80103930 <mycpu>
80107714:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107717:	e8 14 c2 ff ff       	call   80103930 <mycpu>
8010771c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107720:	b8 28 00 00 00       	mov    $0x28,%eax
80107725:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107728:	8b 46 04             	mov    0x4(%esi),%eax
8010772b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107730:	0f 22 d8             	mov    %eax,%cr3
}
80107733:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107736:	5b                   	pop    %ebx
80107737:	5e                   	pop    %esi
80107738:	5f                   	pop    %edi
80107739:	5d                   	pop    %ebp
  popcli();
8010773a:	e9 f1 d3 ff ff       	jmp    80104b30 <popcli>
    panic("switchuvm: no process");
8010773f:	83 ec 0c             	sub    $0xc,%esp
80107742:	68 06 88 10 80       	push   $0x80108806
80107747:	e8 34 8c ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010774c:	83 ec 0c             	sub    $0xc,%esp
8010774f:	68 31 88 10 80       	push   $0x80108831
80107754:	e8 27 8c ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107759:	83 ec 0c             	sub    $0xc,%esp
8010775c:	68 1c 88 10 80       	push   $0x8010881c
80107761:	e8 1a 8c ff ff       	call   80100380 <panic>
80107766:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010776d:	8d 76 00             	lea    0x0(%esi),%esi

80107770 <inituvm>:
{
80107770:	55                   	push   %ebp
80107771:	89 e5                	mov    %esp,%ebp
80107773:	57                   	push   %edi
80107774:	56                   	push   %esi
80107775:	53                   	push   %ebx
80107776:	83 ec 1c             	sub    $0x1c,%esp
80107779:	8b 45 0c             	mov    0xc(%ebp),%eax
8010777c:	8b 75 10             	mov    0x10(%ebp),%esi
8010777f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107782:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107785:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010778b:	77 4b                	ja     801077d8 <inituvm+0x68>
  mem = kalloc();
8010778d:	e8 ee ae ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80107792:	83 ec 04             	sub    $0x4,%esp
80107795:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010779a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010779c:	6a 00                	push   $0x0
8010779e:	50                   	push   %eax
8010779f:	e8 4c d5 ff ff       	call   80104cf0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801077a4:	58                   	pop    %eax
801077a5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801077ab:	5a                   	pop    %edx
801077ac:	6a 06                	push   $0x6
801077ae:	b9 00 10 00 00       	mov    $0x1000,%ecx
801077b3:	31 d2                	xor    %edx,%edx
801077b5:	50                   	push   %eax
801077b6:	89 f8                	mov    %edi,%eax
801077b8:	e8 13 fd ff ff       	call   801074d0 <mappages>
  memmove(mem, init, sz);
801077bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077c0:	89 75 10             	mov    %esi,0x10(%ebp)
801077c3:	83 c4 10             	add    $0x10,%esp
801077c6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801077c9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801077cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077cf:	5b                   	pop    %ebx
801077d0:	5e                   	pop    %esi
801077d1:	5f                   	pop    %edi
801077d2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801077d3:	e9 b8 d5 ff ff       	jmp    80104d90 <memmove>
    panic("inituvm: more than a page");
801077d8:	83 ec 0c             	sub    $0xc,%esp
801077db:	68 45 88 10 80       	push   $0x80108845
801077e0:	e8 9b 8b ff ff       	call   80100380 <panic>
801077e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801077f0 <loaduvm>:
{
801077f0:	55                   	push   %ebp
801077f1:	89 e5                	mov    %esp,%ebp
801077f3:	57                   	push   %edi
801077f4:	56                   	push   %esi
801077f5:	53                   	push   %ebx
801077f6:	83 ec 1c             	sub    $0x1c,%esp
801077f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801077fc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801077ff:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107804:	0f 85 bb 00 00 00    	jne    801078c5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010780a:	01 f0                	add    %esi,%eax
8010780c:	89 f3                	mov    %esi,%ebx
8010780e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107811:	8b 45 14             	mov    0x14(%ebp),%eax
80107814:	01 f0                	add    %esi,%eax
80107816:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107819:	85 f6                	test   %esi,%esi
8010781b:	0f 84 87 00 00 00    	je     801078a8 <loaduvm+0xb8>
80107821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010782b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010782e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107830:	89 c2                	mov    %eax,%edx
80107832:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107835:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107838:	f6 c2 01             	test   $0x1,%dl
8010783b:	75 13                	jne    80107850 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010783d:	83 ec 0c             	sub    $0xc,%esp
80107840:	68 5f 88 10 80       	push   $0x8010885f
80107845:	e8 36 8b ff ff       	call   80100380 <panic>
8010784a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107850:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107853:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107859:	25 fc 0f 00 00       	and    $0xffc,%eax
8010785e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107865:	85 c0                	test   %eax,%eax
80107867:	74 d4                	je     8010783d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107869:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010786b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010786e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107873:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107878:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010787e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107881:	29 d9                	sub    %ebx,%ecx
80107883:	05 00 00 00 80       	add    $0x80000000,%eax
80107888:	57                   	push   %edi
80107889:	51                   	push   %ecx
8010788a:	50                   	push   %eax
8010788b:	ff 75 10             	push   0x10(%ebp)
8010788e:	e8 fd a1 ff ff       	call   80101a90 <readi>
80107893:	83 c4 10             	add    $0x10,%esp
80107896:	39 f8                	cmp    %edi,%eax
80107898:	75 1e                	jne    801078b8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010789a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801078a0:	89 f0                	mov    %esi,%eax
801078a2:	29 d8                	sub    %ebx,%eax
801078a4:	39 c6                	cmp    %eax,%esi
801078a6:	77 80                	ja     80107828 <loaduvm+0x38>
}
801078a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801078ab:	31 c0                	xor    %eax,%eax
}
801078ad:	5b                   	pop    %ebx
801078ae:	5e                   	pop    %esi
801078af:	5f                   	pop    %edi
801078b0:	5d                   	pop    %ebp
801078b1:	c3                   	ret    
801078b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801078b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801078bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801078c0:	5b                   	pop    %ebx
801078c1:	5e                   	pop    %esi
801078c2:	5f                   	pop    %edi
801078c3:	5d                   	pop    %ebp
801078c4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801078c5:	83 ec 0c             	sub    $0xc,%esp
801078c8:	68 00 89 10 80       	push   $0x80108900
801078cd:	e8 ae 8a ff ff       	call   80100380 <panic>
801078d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801078e0 <allocuvm>:
{
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	57                   	push   %edi
801078e4:	56                   	push   %esi
801078e5:	53                   	push   %ebx
801078e6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801078e9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801078ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801078ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801078f2:	85 c0                	test   %eax,%eax
801078f4:	0f 88 b6 00 00 00    	js     801079b0 <allocuvm+0xd0>
  if(newsz < oldsz)
801078fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801078fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107900:	0f 82 9a 00 00 00    	jb     801079a0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107906:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010790c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107912:	39 75 10             	cmp    %esi,0x10(%ebp)
80107915:	77 44                	ja     8010795b <allocuvm+0x7b>
80107917:	e9 87 00 00 00       	jmp    801079a3 <allocuvm+0xc3>
8010791c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107920:	83 ec 04             	sub    $0x4,%esp
80107923:	68 00 10 00 00       	push   $0x1000
80107928:	6a 00                	push   $0x0
8010792a:	50                   	push   %eax
8010792b:	e8 c0 d3 ff ff       	call   80104cf0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107930:	58                   	pop    %eax
80107931:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107937:	5a                   	pop    %edx
80107938:	6a 06                	push   $0x6
8010793a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010793f:	89 f2                	mov    %esi,%edx
80107941:	50                   	push   %eax
80107942:	89 f8                	mov    %edi,%eax
80107944:	e8 87 fb ff ff       	call   801074d0 <mappages>
80107949:	83 c4 10             	add    $0x10,%esp
8010794c:	85 c0                	test   %eax,%eax
8010794e:	78 78                	js     801079c8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107950:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107956:	39 75 10             	cmp    %esi,0x10(%ebp)
80107959:	76 48                	jbe    801079a3 <allocuvm+0xc3>
    mem = kalloc();
8010795b:	e8 20 ad ff ff       	call   80102680 <kalloc>
80107960:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107962:	85 c0                	test   %eax,%eax
80107964:	75 ba                	jne    80107920 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107966:	83 ec 0c             	sub    $0xc,%esp
80107969:	68 7d 88 10 80       	push   $0x8010887d
8010796e:	e8 2d 8d ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107973:	8b 45 0c             	mov    0xc(%ebp),%eax
80107976:	83 c4 10             	add    $0x10,%esp
80107979:	39 45 10             	cmp    %eax,0x10(%ebp)
8010797c:	74 32                	je     801079b0 <allocuvm+0xd0>
8010797e:	8b 55 10             	mov    0x10(%ebp),%edx
80107981:	89 c1                	mov    %eax,%ecx
80107983:	89 f8                	mov    %edi,%eax
80107985:	e8 96 fa ff ff       	call   80107420 <deallocuvm.part.0>
      return 0;
8010798a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107991:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107994:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107997:	5b                   	pop    %ebx
80107998:	5e                   	pop    %esi
80107999:	5f                   	pop    %edi
8010799a:	5d                   	pop    %ebp
8010799b:	c3                   	ret    
8010799c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801079a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801079a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079a9:	5b                   	pop    %ebx
801079aa:	5e                   	pop    %esi
801079ab:	5f                   	pop    %edi
801079ac:	5d                   	pop    %ebp
801079ad:	c3                   	ret    
801079ae:	66 90                	xchg   %ax,%ax
    return 0;
801079b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801079b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079bd:	5b                   	pop    %ebx
801079be:	5e                   	pop    %esi
801079bf:	5f                   	pop    %edi
801079c0:	5d                   	pop    %ebp
801079c1:	c3                   	ret    
801079c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801079c8:	83 ec 0c             	sub    $0xc,%esp
801079cb:	68 95 88 10 80       	push   $0x80108895
801079d0:	e8 cb 8c ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801079d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801079d8:	83 c4 10             	add    $0x10,%esp
801079db:	39 45 10             	cmp    %eax,0x10(%ebp)
801079de:	74 0c                	je     801079ec <allocuvm+0x10c>
801079e0:	8b 55 10             	mov    0x10(%ebp),%edx
801079e3:	89 c1                	mov    %eax,%ecx
801079e5:	89 f8                	mov    %edi,%eax
801079e7:	e8 34 fa ff ff       	call   80107420 <deallocuvm.part.0>
      kfree(mem);
801079ec:	83 ec 0c             	sub    $0xc,%esp
801079ef:	53                   	push   %ebx
801079f0:	e8 cb aa ff ff       	call   801024c0 <kfree>
      return 0;
801079f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801079fc:	83 c4 10             	add    $0x10,%esp
}
801079ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a05:	5b                   	pop    %ebx
80107a06:	5e                   	pop    %esi
80107a07:	5f                   	pop    %edi
80107a08:	5d                   	pop    %ebp
80107a09:	c3                   	ret    
80107a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107a10 <deallocuvm>:
{
80107a10:	55                   	push   %ebp
80107a11:	89 e5                	mov    %esp,%ebp
80107a13:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a16:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107a19:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107a1c:	39 d1                	cmp    %edx,%ecx
80107a1e:	73 10                	jae    80107a30 <deallocuvm+0x20>
}
80107a20:	5d                   	pop    %ebp
80107a21:	e9 fa f9 ff ff       	jmp    80107420 <deallocuvm.part.0>
80107a26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a2d:	8d 76 00             	lea    0x0(%esi),%esi
80107a30:	89 d0                	mov    %edx,%eax
80107a32:	5d                   	pop    %ebp
80107a33:	c3                   	ret    
80107a34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a3f:	90                   	nop

80107a40 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107a40:	55                   	push   %ebp
80107a41:	89 e5                	mov    %esp,%ebp
80107a43:	57                   	push   %edi
80107a44:	56                   	push   %esi
80107a45:	53                   	push   %ebx
80107a46:	83 ec 0c             	sub    $0xc,%esp
80107a49:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107a4c:	85 f6                	test   %esi,%esi
80107a4e:	74 59                	je     80107aa9 <freevm+0x69>
  if(newsz >= oldsz)
80107a50:	31 c9                	xor    %ecx,%ecx
80107a52:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107a57:	89 f0                	mov    %esi,%eax
80107a59:	89 f3                	mov    %esi,%ebx
80107a5b:	e8 c0 f9 ff ff       	call   80107420 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107a60:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107a66:	eb 0f                	jmp    80107a77 <freevm+0x37>
80107a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a6f:	90                   	nop
80107a70:	83 c3 04             	add    $0x4,%ebx
80107a73:	39 df                	cmp    %ebx,%edi
80107a75:	74 23                	je     80107a9a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107a77:	8b 03                	mov    (%ebx),%eax
80107a79:	a8 01                	test   $0x1,%al
80107a7b:	74 f3                	je     80107a70 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107a7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107a82:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107a85:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107a88:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107a8d:	50                   	push   %eax
80107a8e:	e8 2d aa ff ff       	call   801024c0 <kfree>
80107a93:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107a96:	39 df                	cmp    %ebx,%edi
80107a98:	75 dd                	jne    80107a77 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107a9a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107a9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107aa0:	5b                   	pop    %ebx
80107aa1:	5e                   	pop    %esi
80107aa2:	5f                   	pop    %edi
80107aa3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107aa4:	e9 17 aa ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107aa9:	83 ec 0c             	sub    $0xc,%esp
80107aac:	68 b1 88 10 80       	push   $0x801088b1
80107ab1:	e8 ca 88 ff ff       	call   80100380 <panic>
80107ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107abd:	8d 76 00             	lea    0x0(%esi),%esi

80107ac0 <setupkvm>:
{
80107ac0:	55                   	push   %ebp
80107ac1:	89 e5                	mov    %esp,%ebp
80107ac3:	56                   	push   %esi
80107ac4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107ac5:	e8 b6 ab ff ff       	call   80102680 <kalloc>
80107aca:	89 c6                	mov    %eax,%esi
80107acc:	85 c0                	test   %eax,%eax
80107ace:	74 42                	je     80107b12 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107ad0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ad3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107ad8:	68 00 10 00 00       	push   $0x1000
80107add:	6a 00                	push   $0x0
80107adf:	50                   	push   %eax
80107ae0:	e8 0b d2 ff ff       	call   80104cf0 <memset>
80107ae5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107ae8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107aeb:	83 ec 08             	sub    $0x8,%esp
80107aee:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107af1:	ff 73 0c             	push   0xc(%ebx)
80107af4:	8b 13                	mov    (%ebx),%edx
80107af6:	50                   	push   %eax
80107af7:	29 c1                	sub    %eax,%ecx
80107af9:	89 f0                	mov    %esi,%eax
80107afb:	e8 d0 f9 ff ff       	call   801074d0 <mappages>
80107b00:	83 c4 10             	add    $0x10,%esp
80107b03:	85 c0                	test   %eax,%eax
80107b05:	78 19                	js     80107b20 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b07:	83 c3 10             	add    $0x10,%ebx
80107b0a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107b10:	75 d6                	jne    80107ae8 <setupkvm+0x28>
}
80107b12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107b15:	89 f0                	mov    %esi,%eax
80107b17:	5b                   	pop    %ebx
80107b18:	5e                   	pop    %esi
80107b19:	5d                   	pop    %ebp
80107b1a:	c3                   	ret    
80107b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107b1f:	90                   	nop
      freevm(pgdir);
80107b20:	83 ec 0c             	sub    $0xc,%esp
80107b23:	56                   	push   %esi
      return 0;
80107b24:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107b26:	e8 15 ff ff ff       	call   80107a40 <freevm>
      return 0;
80107b2b:	83 c4 10             	add    $0x10,%esp
}
80107b2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107b31:	89 f0                	mov    %esi,%eax
80107b33:	5b                   	pop    %ebx
80107b34:	5e                   	pop    %esi
80107b35:	5d                   	pop    %ebp
80107b36:	c3                   	ret    
80107b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b3e:	66 90                	xchg   %ax,%ax

80107b40 <kvmalloc>:
{
80107b40:	55                   	push   %ebp
80107b41:	89 e5                	mov    %esp,%ebp
80107b43:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107b46:	e8 75 ff ff ff       	call   80107ac0 <setupkvm>
80107b4b:	a3 c4 5d 11 80       	mov    %eax,0x80115dc4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107b50:	05 00 00 00 80       	add    $0x80000000,%eax
80107b55:	0f 22 d8             	mov    %eax,%cr3
}
80107b58:	c9                   	leave  
80107b59:	c3                   	ret    
80107b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b60 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107b60:	55                   	push   %ebp
80107b61:	89 e5                	mov    %esp,%ebp
80107b63:	83 ec 08             	sub    $0x8,%esp
80107b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107b69:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107b6c:	89 c1                	mov    %eax,%ecx
80107b6e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107b71:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107b74:	f6 c2 01             	test   $0x1,%dl
80107b77:	75 17                	jne    80107b90 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107b79:	83 ec 0c             	sub    $0xc,%esp
80107b7c:	68 c2 88 10 80       	push   $0x801088c2
80107b81:	e8 fa 87 ff ff       	call   80100380 <panic>
80107b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b8d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107b90:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b93:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107b99:	25 fc 0f 00 00       	and    $0xffc,%eax
80107b9e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107ba5:	85 c0                	test   %eax,%eax
80107ba7:	74 d0                	je     80107b79 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107ba9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107bac:	c9                   	leave  
80107bad:	c3                   	ret    
80107bae:	66 90                	xchg   %ax,%ax

80107bb0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107bb0:	55                   	push   %ebp
80107bb1:	89 e5                	mov    %esp,%ebp
80107bb3:	57                   	push   %edi
80107bb4:	56                   	push   %esi
80107bb5:	53                   	push   %ebx
80107bb6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107bb9:	e8 02 ff ff ff       	call   80107ac0 <setupkvm>
80107bbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107bc1:	85 c0                	test   %eax,%eax
80107bc3:	0f 84 bd 00 00 00    	je     80107c86 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107bc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107bcc:	85 c9                	test   %ecx,%ecx
80107bce:	0f 84 b2 00 00 00    	je     80107c86 <copyuvm+0xd6>
80107bd4:	31 f6                	xor    %esi,%esi
80107bd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bdd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107be0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107be3:	89 f0                	mov    %esi,%eax
80107be5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107be8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80107beb:	a8 01                	test   $0x1,%al
80107bed:	75 11                	jne    80107c00 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107bef:	83 ec 0c             	sub    $0xc,%esp
80107bf2:	68 cc 88 10 80       	push   $0x801088cc
80107bf7:	e8 84 87 ff ff       	call   80100380 <panic>
80107bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107c00:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107c02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107c07:	c1 ea 0a             	shr    $0xa,%edx
80107c0a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107c10:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107c17:	85 c0                	test   %eax,%eax
80107c19:	74 d4                	je     80107bef <copyuvm+0x3f>
    if(!(*pte & PTE_P))
80107c1b:	8b 00                	mov    (%eax),%eax
80107c1d:	a8 01                	test   $0x1,%al
80107c1f:	0f 84 9f 00 00 00    	je     80107cc4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107c25:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107c27:	25 ff 0f 00 00       	and    $0xfff,%eax
80107c2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107c2f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107c35:	e8 46 aa ff ff       	call   80102680 <kalloc>
80107c3a:	89 c3                	mov    %eax,%ebx
80107c3c:	85 c0                	test   %eax,%eax
80107c3e:	74 64                	je     80107ca4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107c40:	83 ec 04             	sub    $0x4,%esp
80107c43:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107c49:	68 00 10 00 00       	push   $0x1000
80107c4e:	57                   	push   %edi
80107c4f:	50                   	push   %eax
80107c50:	e8 3b d1 ff ff       	call   80104d90 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107c55:	58                   	pop    %eax
80107c56:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107c5c:	5a                   	pop    %edx
80107c5d:	ff 75 e4             	push   -0x1c(%ebp)
80107c60:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c65:	89 f2                	mov    %esi,%edx
80107c67:	50                   	push   %eax
80107c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c6b:	e8 60 f8 ff ff       	call   801074d0 <mappages>
80107c70:	83 c4 10             	add    $0x10,%esp
80107c73:	85 c0                	test   %eax,%eax
80107c75:	78 21                	js     80107c98 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107c77:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107c7d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107c80:	0f 87 5a ff ff ff    	ja     80107be0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107c86:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c8c:	5b                   	pop    %ebx
80107c8d:	5e                   	pop    %esi
80107c8e:	5f                   	pop    %edi
80107c8f:	5d                   	pop    %ebp
80107c90:	c3                   	ret    
80107c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107c98:	83 ec 0c             	sub    $0xc,%esp
80107c9b:	53                   	push   %ebx
80107c9c:	e8 1f a8 ff ff       	call   801024c0 <kfree>
      goto bad;
80107ca1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107ca4:	83 ec 0c             	sub    $0xc,%esp
80107ca7:	ff 75 e0             	push   -0x20(%ebp)
80107caa:	e8 91 fd ff ff       	call   80107a40 <freevm>
  return 0;
80107caf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107cb6:	83 c4 10             	add    $0x10,%esp
}
80107cb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107cbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cbf:	5b                   	pop    %ebx
80107cc0:	5e                   	pop    %esi
80107cc1:	5f                   	pop    %edi
80107cc2:	5d                   	pop    %ebp
80107cc3:	c3                   	ret    
      panic("copyuvm: page not present");
80107cc4:	83 ec 0c             	sub    $0xc,%esp
80107cc7:	68 e6 88 10 80       	push   $0x801088e6
80107ccc:	e8 af 86 ff ff       	call   80100380 <panic>
80107cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cdf:	90                   	nop

80107ce0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107ce0:	55                   	push   %ebp
80107ce1:	89 e5                	mov    %esp,%ebp
80107ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107ce6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107ce9:	89 c1                	mov    %eax,%ecx
80107ceb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107cee:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107cf1:	f6 c2 01             	test   $0x1,%dl
80107cf4:	0f 84 00 01 00 00    	je     80107dfa <uva2ka.cold>
  return &pgtab[PTX(va)];
80107cfa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107cfd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107d03:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107d04:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107d09:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107d10:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107d12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107d17:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107d1a:	05 00 00 00 80       	add    $0x80000000,%eax
80107d1f:	83 fa 05             	cmp    $0x5,%edx
80107d22:	ba 00 00 00 00       	mov    $0x0,%edx
80107d27:	0f 45 c2             	cmovne %edx,%eax
}
80107d2a:	c3                   	ret    
80107d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d2f:	90                   	nop

80107d30 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107d30:	55                   	push   %ebp
80107d31:	89 e5                	mov    %esp,%ebp
80107d33:	57                   	push   %edi
80107d34:	56                   	push   %esi
80107d35:	53                   	push   %ebx
80107d36:	83 ec 0c             	sub    $0xc,%esp
80107d39:	8b 75 14             	mov    0x14(%ebp),%esi
80107d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d3f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107d42:	85 f6                	test   %esi,%esi
80107d44:	75 51                	jne    80107d97 <copyout+0x67>
80107d46:	e9 a5 00 00 00       	jmp    80107df0 <copyout+0xc0>
80107d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d4f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107d50:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107d56:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107d5c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107d62:	74 75                	je     80107dd9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107d64:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107d66:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107d69:	29 c3                	sub    %eax,%ebx
80107d6b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107d71:	39 f3                	cmp    %esi,%ebx
80107d73:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107d76:	29 f8                	sub    %edi,%eax
80107d78:	83 ec 04             	sub    $0x4,%esp
80107d7b:	01 c1                	add    %eax,%ecx
80107d7d:	53                   	push   %ebx
80107d7e:	52                   	push   %edx
80107d7f:	51                   	push   %ecx
80107d80:	e8 0b d0 ff ff       	call   80104d90 <memmove>
    len -= n;
    buf += n;
80107d85:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107d88:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107d8e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107d91:	01 da                	add    %ebx,%edx
  while(len > 0){
80107d93:	29 de                	sub    %ebx,%esi
80107d95:	74 59                	je     80107df0 <copyout+0xc0>
  if(*pde & PTE_P){
80107d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107d9a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107d9c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107d9e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107da1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107da7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107daa:	f6 c1 01             	test   $0x1,%cl
80107dad:	0f 84 4e 00 00 00    	je     80107e01 <copyout.cold>
  return &pgtab[PTX(va)];
80107db3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107db5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107dbb:	c1 eb 0c             	shr    $0xc,%ebx
80107dbe:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107dc4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107dcb:	89 d9                	mov    %ebx,%ecx
80107dcd:	83 e1 05             	and    $0x5,%ecx
80107dd0:	83 f9 05             	cmp    $0x5,%ecx
80107dd3:	0f 84 77 ff ff ff    	je     80107d50 <copyout+0x20>
  }
  return 0;
}
80107dd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107ddc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107de1:	5b                   	pop    %ebx
80107de2:	5e                   	pop    %esi
80107de3:	5f                   	pop    %edi
80107de4:	5d                   	pop    %ebp
80107de5:	c3                   	ret    
80107de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ded:	8d 76 00             	lea    0x0(%esi),%esi
80107df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107df3:	31 c0                	xor    %eax,%eax
}
80107df5:	5b                   	pop    %ebx
80107df6:	5e                   	pop    %esi
80107df7:	5f                   	pop    %edi
80107df8:	5d                   	pop    %ebp
80107df9:	c3                   	ret    

80107dfa <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107dfa:	a1 00 00 00 00       	mov    0x0,%eax
80107dff:	0f 0b                	ud2    

80107e01 <copyout.cold>:
80107e01:	a1 00 00 00 00       	mov    0x0,%eax
80107e06:	0f 0b                	ud2    
