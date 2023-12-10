
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 30 10 80       	mov    $0x80103040,%eax
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
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 20 81 10 80       	push   $0x80108120
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 c1 4d 00 00       	call   80104e20 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100078:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 81 10 80       	push   $0x80108127
80100097:	50                   	push   %eax
80100098:	e8 43 4c 00 00       	call   80104ce0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 0a 11 80    	cmp    $0x80110a60,%ebx
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
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e8:	e8 b3 4e 00 00       	call   80104fa0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 f9 4e 00 00       	call   80105060 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 4b 00 00       	call   80104d20 <acquiresleep>
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
8010018c:	e8 ef 20 00 00       	call   80102280 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 2e 81 10 80       	push   $0x8010812e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 f9 4b 00 00       	call   80104dc0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 a3 20 00 00       	jmp    80102280 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 3f 81 10 80       	push   $0x8010813f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 b8 4b 00 00       	call   80104dc0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 68 4b 00 00       	call   80104d80 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 7c 4d 00 00       	call   80104fa0 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 eb 4d 00 00       	jmp    80105060 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 46 81 10 80       	push   $0x80108146
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 ea 4c 00 00       	call   80104fa0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cb:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 0f 11 80       	push   $0x80110fa0
801002e5:	e8 06 46 00 00       	call   801048f0 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 f1 37 00 00       	call   80103af0 <myproc>
801002ff:	8b 48 30             	mov    0x30(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 4d 4d 00 00       	call   80105060 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 f6 4c 00 00       	call   80105060 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 ee 24 00 00       	call   801028a0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 4d 81 10 80       	push   $0x8010814d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 cf 8b 10 80 	movl   $0x80108bcf,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 5f 4a 00 00       	call   80104e40 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 61 81 10 80       	push   $0x80108161
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 e1 68 00 00       	call   80106d10 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 f6 67 00 00       	call   80106d10 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ea 67 00 00       	call   80106d10 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 de 67 00 00       	call   80106d10 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 ea 4b 00 00       	call   80105150 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 35 4b 00 00       	call   801050b0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 65 81 10 80       	push   $0x80108165
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 90 81 10 80 	movzbl -0x7fef7e70(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 3c 49 00 00       	call   80104fa0 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 c4 49 00 00       	call   80105060 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 78 81 10 80       	mov    $0x80108178,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 de 47 00 00       	call   80104fa0 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 33 48 00 00       	call   80105060 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 7f 81 10 80       	push   $0x8010817f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 24 47 00 00       	call   80104fa0 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 0f 11 80    	mov    %bl,-0x7feef0e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100925:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010096f:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100985:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 8c 46 00 00       	call   80105060 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 ac 41 00 00       	jmp    80104bb0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100a1b:	68 a0 0f 11 80       	push   $0x80110fa0
80100a20:	e8 8b 40 00 00       	call   80104ab0 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 88 81 10 80       	push   $0x80108188
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 d7 43 00 00       	call   80104e20 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 19 11 80 40 	movl   $0x80100640,0x8011196c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 19 11 80 90 	movl   $0x80100290,0x80111968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 be 19 00 00       	call   80102430 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 5b 30 00 00       	call   80103af0 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 90 22 00 00       	call   80102d30 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 b8 22 00 00       	call   80102da0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 6f 73 00 00       	call   80107e80 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 28 71 00 00       	call   80107ca0 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 22 70 00 00       	call   80107bd0 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 10 72 00 00       	call   80107e00 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 df 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c21:	e8 7a 21 00 00       	call   80102da0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 69 70 00 00       	call   80107ca0 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 c8 72 00 00       	call   80107f20 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 08 46 00 00       	call   801052b0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 f5 45 00 00       	call   801052b0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 b4 73 00 00       	call   80108080 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 1a 71 00 00       	call   80107e00 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 48 73 00 00       	call   80108080 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 78             	add    $0x78,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 fa 44 00 00       	call   80105270 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 9e 6c 00 00       	call   80107a40 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 56 70 00 00       	call   80107e00 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 e7 1f 00 00       	call   80102da0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 a1 81 10 80       	push   $0x801081a1
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 ad 81 10 80       	push   $0x801081ad
80100def:	68 c0 0f 11 80       	push   $0x80110fc0
80100df4:	e8 27 40 00 00       	call   80104e20 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 c0 0f 11 80       	push   $0x80110fc0
80100e15:	e8 86 41 00 00       	call   80104fa0 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e41:	e8 1a 42 00 00       	call   80105060 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 0f 11 80       	push   $0x80110fc0
80100e5a:	e8 01 42 00 00       	call   80105060 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 c0 0f 11 80       	push   $0x80110fc0
80100e83:	e8 18 41 00 00       	call   80104fa0 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 c0 0f 11 80       	push   $0x80110fc0
80100ea0:	e8 bb 41 00 00       	call   80105060 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 b4 81 10 80       	push   $0x801081b4
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 c0 0f 11 80       	push   $0x80110fc0
80100ed5:	e8 c6 40 00 00       	call   80104fa0 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 4b 41 00 00       	call   80105060 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 1d 41 00 00       	jmp    80105060 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 e3 1d 00 00       	call   80102d30 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 39 1e 00 00       	jmp    80102da0 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 82 25 00 00       	call   80103500 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 bc 81 10 80       	push   $0x801081bc
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 36 26 00 00       	jmp    801036a0 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 c6 81 10 80       	push   $0x801081c6
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 aa 1c 00 00       	call   80102da0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 11 1c 00 00       	call   80102d30 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 4a 1c 00 00       	call   80102da0 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 cf 81 10 80       	push   $0x801081cf
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 0a 24 00 00       	jmp    801035a0 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 d5 81 10 80       	push   $0x801081d5
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011b0:	55                   	push   %ebp
801011b1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011b3:	89 d0                	mov    %edx,%eax
801011b5:	c1 e8 0c             	shr    $0xc,%eax
801011b8:	03 05 d8 19 11 80    	add    0x801119d8,%eax
{
801011be:	89 e5                	mov    %esp,%ebp
801011c0:	56                   	push   %esi
801011c1:	53                   	push   %ebx
801011c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	50                   	push   %eax
801011c8:	51                   	push   %ecx
801011c9:	e8 02 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011d0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011d3:	ba 01 00 00 00       	mov    $0x1,%edx
801011d8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011db:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011e1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011e4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011e6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011eb:	85 d1                	test   %edx,%ecx
801011ed:	74 25                	je     80101214 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ef:	f7 d2                	not    %edx
  log_write(bp);
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801011f6:	21 ca                	and    %ecx,%edx
801011f8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801011fc:	50                   	push   %eax
801011fd:	e8 0e 1d 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101202:	89 34 24             	mov    %esi,(%esp)
80101205:	e8 e6 ef ff ff       	call   801001f0 <brelse>
}
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101210:	5b                   	pop    %ebx
80101211:	5e                   	pop    %esi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
    panic("freeing free block");
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	68 df 81 10 80       	push   $0x801081df
8010121c:	e8 6f f1 ff ff       	call   80100390 <panic>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010122f:	90                   	nop

80101230 <balloc>:
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
8010123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 87 00 00 00    	je     801012d1 <balloc+0xa1>
8010124a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101251:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	89 f0                	mov    %esi,%eax
80101259:	c1 f8 0c             	sar    $0xc,%eax
8010125c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	83 c4 10             	add    $0x10,%esp
8010126e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101271:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101276:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101279:	31 c0                	xor    %eax,%eax
8010127b:	eb 2f                	jmp    801012ac <balloc+0x7c>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 41                	je     801012e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 05                	je     801012b1 <balloc+0x81>
801012ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012af:	77 cf                	ja     80101280 <balloc+0x50>
    brelse(bp);
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012b7:	e8 34 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012c3:	83 c4 10             	add    $0x10,%esp
801012c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012c9:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801012cf:	77 80                	ja     80101251 <balloc+0x21>
  panic("balloc: out of blocks");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 f2 81 10 80       	push   $0x801081f2
801012d9:	e8 b2 f0 ff ff       	call   80100390 <panic>
801012de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012e6:	09 da                	or     %ebx,%edx
801012e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012ec:	57                   	push   %edi
801012ed:	e8 1e 1c 00 00       	call   80102f10 <log_write>
        brelse(bp);
801012f2:	89 3c 24             	mov    %edi,(%esp)
801012f5:	e8 f6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012fa:	58                   	pop    %eax
801012fb:	5a                   	pop    %edx
801012fc:	56                   	push   %esi
801012fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101300:	e8 cb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101305:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101308:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010130a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010130d:	68 00 02 00 00       	push   $0x200
80101312:	6a 00                	push   $0x0
80101314:	50                   	push   %eax
80101315:	e8 96 3d 00 00       	call   801050b0 <memset>
  log_write(bp);
8010131a:	89 1c 24             	mov    %ebx,(%esp)
8010131d:	e8 ee 1b 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 f0                	mov    %esi,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010133f:	90                   	nop

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	89 c7                	mov    %eax,%edi
80101346:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101347:	31 f6                	xor    %esi,%esi
{
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 e0 19 11 80       	push   $0x801119e0
8010135a:	e8 41 3c 00 00       	call   80104fa0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 3b                	cmp    %edi,(%ebx)
80101372:	74 6c                	je     801013e0 <iget+0xa0>
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101380:	73 26                	jae    801013a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101385:	85 c9                	test   %ecx,%ecx
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 f6                	test   %esi,%esi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	89 d8                	mov    %ebx,%eax
8010138f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	75 6e                	jne    80101407 <iget+0xc7>
80101399:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139b:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013a1:	72 df                	jb     80101382 <iget+0x42>
801013a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013a7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a8:	85 f6                	test   %esi,%esi
801013aa:	74 73                	je     8010141f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013af:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013b1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013b4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013c2:	68 e0 19 11 80       	push   $0x801119e0
801013c7:	e8 94 3c 00 00       	call   80105060 <release>

  return ip;
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d2:	89 f0                	mov    %esi,%eax
801013d4:	5b                   	pop    %ebx
801013d5:	5e                   	pop    %esi
801013d6:	5f                   	pop    %edi
801013d7:	5d                   	pop    %ebp
801013d8:	c3                   	ret    
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013e3:	75 8f                	jne    80101374 <iget+0x34>
      release(&icache.lock);
801013e5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013e8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013eb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013ed:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
801013f2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013f5:	e8 66 3c 00 00       	call   80105060 <release>
      return ip;
801013fa:	83 c4 10             	add    $0x10,%esp
}
801013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101400:	89 f0                	mov    %esi,%eax
80101402:	5b                   	pop    %ebx
80101403:	5e                   	pop    %esi
80101404:	5f                   	pop    %edi
80101405:	5d                   	pop    %ebp
80101406:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101407:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010140d:	73 10                	jae    8010141f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010140f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101412:	85 c9                	test   %ecx,%ecx
80101414:	0f 8f 56 ff ff ff    	jg     80101370 <iget+0x30>
8010141a:	e9 6e ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 08 82 10 80       	push   $0x80108208
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101430 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	89 c6                	mov    %eax,%esi
80101437:	53                   	push   %ebx
80101438:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010143b:	83 fa 0b             	cmp    $0xb,%edx
8010143e:	0f 86 84 00 00 00    	jbe    801014c8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101444:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101447:	83 fb 7f             	cmp    $0x7f,%ebx
8010144a:	0f 87 98 00 00 00    	ja     801014e8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101450:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101456:	8b 16                	mov    (%esi),%edx
80101458:	85 c0                	test   %eax,%eax
8010145a:	74 54                	je     801014b0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010145c:	83 ec 08             	sub    $0x8,%esp
8010145f:	50                   	push   %eax
80101460:	52                   	push   %edx
80101461:	e8 6a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101466:	83 c4 10             	add    $0x10,%esp
80101469:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010146d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010146f:	8b 1a                	mov    (%edx),%ebx
80101471:	85 db                	test   %ebx,%ebx
80101473:	74 1b                	je     80101490 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101475:	83 ec 0c             	sub    $0xc,%esp
80101478:	57                   	push   %edi
80101479:	e8 72 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010147e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101484:	89 d8                	mov    %ebx,%eax
80101486:	5b                   	pop    %ebx
80101487:	5e                   	pop    %esi
80101488:	5f                   	pop    %edi
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    
8010148b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101495:	e8 96 fd ff ff       	call   80101230 <balloc>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010149d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014a0:	89 c3                	mov    %eax,%ebx
801014a2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014a4:	57                   	push   %edi
801014a5:	e8 66 1a 00 00       	call   80102f10 <log_write>
801014aa:	83 c4 10             	add    $0x10,%esp
801014ad:	eb c6                	jmp    80101475 <bmap+0x45>
801014af:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014b0:	89 d0                	mov    %edx,%eax
801014b2:	e8 79 fd ff ff       	call   80101230 <balloc>
801014b7:	8b 16                	mov    (%esi),%edx
801014b9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014bf:	eb 9b                	jmp    8010145c <bmap+0x2c>
801014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014c8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014cb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014ce:	85 db                	test   %ebx,%ebx
801014d0:	75 af                	jne    80101481 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014d2:	8b 00                	mov    (%eax),%eax
801014d4:	e8 57 fd ff ff       	call   80101230 <balloc>
801014d9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014dc:	89 c3                	mov    %eax,%ebx
}
801014de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e1:	89 d8                	mov    %ebx,%eax
801014e3:	5b                   	pop    %ebx
801014e4:	5e                   	pop    %esi
801014e5:	5f                   	pop    %edi
801014e6:	5d                   	pop    %ebp
801014e7:	c3                   	ret    
  panic("bmap: out of range");
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	68 18 82 10 80       	push   $0x80108218
801014f0:	e8 9b ee ff ff       	call   80100390 <panic>
801014f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <readsb>:
{
80101500:	f3 0f 1e fb          	endbr32 
80101504:	55                   	push   %ebp
80101505:	89 e5                	mov    %esp,%ebp
80101507:	56                   	push   %esi
80101508:	53                   	push   %ebx
80101509:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	6a 01                	push   $0x1
80101511:	ff 75 08             	pushl  0x8(%ebp)
80101514:	e8 b7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101519:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010151c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010151e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101521:	6a 1c                	push   $0x1c
80101523:	50                   	push   %eax
80101524:	56                   	push   %esi
80101525:	e8 26 3c 00 00       	call   80105150 <memmove>
  brelse(bp);
8010152a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010152d:	83 c4 10             	add    $0x10,%esp
}
80101530:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101533:	5b                   	pop    %ebx
80101534:	5e                   	pop    %esi
80101535:	5d                   	pop    %ebp
  brelse(bp);
80101536:	e9 b5 ec ff ff       	jmp    801001f0 <brelse>
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 2b 82 10 80       	push   $0x8010822b
80101555:	68 e0 19 11 80       	push   $0x801119e0
8010155a:	e8 c1 38 00 00       	call   80104e20 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 32 82 10 80       	push   $0x80108232
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 64 37 00 00       	call   80104ce0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 c0 19 11 80       	push   $0x801119c0
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 69 ff ff ff       	call   80101500 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 d8 19 11 80    	pushl  0x801119d8
8010159d:	ff 35 d4 19 11 80    	pushl  0x801119d4
801015a3:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015a9:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015af:	ff 35 c8 19 11 80    	pushl  0x801119c8
801015b5:	ff 35 c4 19 11 80    	pushl  0x801119c4
801015bb:	ff 35 c0 19 11 80    	pushl  0x801119c0
801015c1:	68 98 82 10 80       	push   $0x80108298
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d c8 19 11 80    	cmp    0x801119c8,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 4d 3a 00 00       	call   801050b0 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 9b 18 00 00       	call   80102f10 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 b0 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 38 82 10 80       	push   $0x80108238
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 46 3a 00 00       	call   80105150 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 fe 17 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 e0 19 11 80       	push   $0x801119e0
80101743:	e8 58 38 00 00       	call   80104fa0 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101753:	e8 08 39 00 00       	call   80105060 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 95 35 00 00       	call   80104d20 <acquiresleep>
  if(ip->valid == 0){
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 53 39 00 00       	call   80105150 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 50 82 10 80       	push   $0x80108250
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 4a 82 10 80       	push   $0x8010824a
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 64 35 00 00       	call   80104dc0 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 08 35 00 00       	jmp    80104d80 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 5f 82 10 80       	push   $0x8010825f
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 77 34 00 00       	call   80104d20 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 bd 34 00 00       	call   80104d80 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018ca:	e8 d1 36 00 00       	call   80104fa0 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 77 37 00 00       	jmp    80105060 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 e0 19 11 80       	push   $0x801119e0
801018f8:	e8 a3 36 00 00       	call   80104fa0 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101907:	e8 54 37 00 00       	call   80105060 <release>
    if(r == 1){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
    if(ip->addrs[i]){
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 74 f8 ff ff       	call   801011b0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if(a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 ec f7 ff ff       	call   801011b0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 c5 f7 ff ff       	call   801011b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 61 f9 ff ff       	call   80101430 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 44 36 00 00       	call   80105150 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 61 f8 ff ff       	call   80101430 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 48 35 00 00       	call   80105150 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 00 13 00 00       	call   80102f10 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 19 35 00 00       	call   801051c0 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 b6 34 00 00       	call   801051c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if(poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 01 f6 ff ff       	call   80101340 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 79 82 10 80       	push   $0x80108279
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 67 82 10 80       	push   $0x80108267
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 61 1d 00 00       	call   80103af0 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 74             	mov    0x74(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 e0 19 11 80       	push   $0x801119e0
80101d9c:	e8 ff 31 00 00       	call   80104fa0 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101dac:	e8 af 32 00 00       	call   80105060 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 34 33 00 00       	call   80105150 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 a8 32 00 00       	call   80105150 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 1f f4 ff ff       	call   80101340 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if(de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 36 32 00 00       	call   80105210 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
  return 0;
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 88 82 10 80       	push   $0x80108288
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 8a 89 10 80       	push   $0x8010898a
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode*
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	66 90                	xchg   %ax,%ax
8010206a:	66 90                	xchg   %ax,%ax
8010206c:	66 90                	xchg   %ax,%ax
8010206e:	66 90                	xchg   %ax,%ax

80102070 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102079:	85 c0                	test   %eax,%eax
8010207b:	0f 84 b4 00 00 00    	je     80102135 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102081:	8b 70 08             	mov    0x8(%eax),%esi
80102084:	89 c3                	mov    %eax,%ebx
80102086:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010208c:	0f 87 96 00 00 00    	ja     80102128 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102092:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209e:	66 90                	xchg   %ax,%ax
801020a0:	89 ca                	mov    %ecx,%edx
801020a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a3:	83 e0 c0             	and    $0xffffffc0,%eax
801020a6:	3c 40                	cmp    $0x40,%al
801020a8:	75 f6                	jne    801020a0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020aa:	31 ff                	xor    %edi,%edi
801020ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020b1:	89 f8                	mov    %edi,%eax
801020b3:	ee                   	out    %al,(%dx)
801020b4:	b8 01 00 00 00       	mov    $0x1,%eax
801020b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020be:	ee                   	out    %al,(%dx)
801020bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020c4:	89 f0                	mov    %esi,%eax
801020c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020c7:	89 f0                	mov    %esi,%eax
801020c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020ce:	c1 f8 08             	sar    $0x8,%eax
801020d1:	ee                   	out    %al,(%dx)
801020d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020d7:	89 f8                	mov    %edi,%eax
801020d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020da:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020e3:	c1 e0 04             	shl    $0x4,%eax
801020e6:	83 e0 10             	and    $0x10,%eax
801020e9:	83 c8 e0             	or     $0xffffffe0,%eax
801020ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020ed:	f6 03 04             	testb  $0x4,(%ebx)
801020f0:	75 16                	jne    80102108 <idestart+0x98>
801020f2:	b8 20 00 00 00       	mov    $0x20,%eax
801020f7:	89 ca                	mov    %ecx,%edx
801020f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020fd:	5b                   	pop    %ebx
801020fe:	5e                   	pop    %esi
801020ff:	5f                   	pop    %edi
80102100:	5d                   	pop    %ebp
80102101:	c3                   	ret    
80102102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102108:	b8 30 00 00 00       	mov    $0x30,%eax
8010210d:	89 ca                	mov    %ecx,%edx
8010210f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102110:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102115:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102118:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211d:	fc                   	cld    
8010211e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102120:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102123:	5b                   	pop    %ebx
80102124:	5e                   	pop    %esi
80102125:	5f                   	pop    %edi
80102126:	5d                   	pop    %ebp
80102127:	c3                   	ret    
    panic("incorrect blockno");
80102128:	83 ec 0c             	sub    $0xc,%esp
8010212b:	68 f4 82 10 80       	push   $0x801082f4
80102130:	e8 5b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	68 eb 82 10 80       	push   $0x801082eb
8010213d:	e8 4e e2 ff ff       	call   80100390 <panic>
80102142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102150 <ideinit>:
{
80102150:	f3 0f 1e fb          	endbr32 
80102154:	55                   	push   %ebp
80102155:	89 e5                	mov    %esp,%ebp
80102157:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010215a:	68 06 83 10 80       	push   $0x80108306
8010215f:	68 80 b5 10 80       	push   $0x8010b580
80102164:	e8 b7 2c 00 00       	call   80104e20 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102169:	58                   	pop    %eax
8010216a:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010216f:	5a                   	pop    %edx
80102170:	83 e8 01             	sub    $0x1,%eax
80102173:	50                   	push   %eax
80102174:	6a 0e                	push   $0xe
80102176:	e8 b5 02 00 00       	call   80102430 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010217b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010217e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102187:	90                   	nop
80102188:	ec                   	in     (%dx),%al
80102189:	83 e0 c0             	and    $0xffffffc0,%eax
8010218c:	3c 40                	cmp    $0x40,%al
8010218e:	75 f8                	jne    80102188 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102190:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102195:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010219a:	ee                   	out    %al,(%dx)
8010219b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021a5:	eb 0e                	jmp    801021b5 <ideinit+0x65>
801021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ae:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021b0:	83 e9 01             	sub    $0x1,%ecx
801021b3:	74 0f                	je     801021c4 <ideinit+0x74>
801021b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021b6:	84 c0                	test   %al,%al
801021b8:	74 f6                	je     801021b0 <ideinit+0x60>
      havedisk1 = 1;
801021ba:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801021c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ce:	ee                   	out    %al,(%dx)
}
801021cf:	c9                   	leave  
801021d0:	c3                   	ret    
801021d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021df:	90                   	nop

801021e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021e0:	f3 0f 1e fb          	endbr32 
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	57                   	push   %edi
801021e8:	56                   	push   %esi
801021e9:	53                   	push   %ebx
801021ea:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021ed:	68 80 b5 10 80       	push   $0x8010b580
801021f2:	e8 a9 2d 00 00       	call   80104fa0 <acquire>

  if((b = idequeue) == 0){
801021f7:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801021fd:	83 c4 10             	add    $0x10,%esp
80102200:	85 db                	test   %ebx,%ebx
80102202:	74 5f                	je     80102263 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102204:	8b 43 58             	mov    0x58(%ebx),%eax
80102207:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010220c:	8b 33                	mov    (%ebx),%esi
8010220e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102214:	75 2b                	jne    80102241 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102216:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010221f:	90                   	nop
80102220:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102221:	89 c1                	mov    %eax,%ecx
80102223:	83 e1 c0             	and    $0xffffffc0,%ecx
80102226:	80 f9 40             	cmp    $0x40,%cl
80102229:	75 f5                	jne    80102220 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010222b:	a8 21                	test   $0x21,%al
8010222d:	75 12                	jne    80102241 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010222f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102232:	b9 80 00 00 00       	mov    $0x80,%ecx
80102237:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010223c:	fc                   	cld    
8010223d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010223f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102241:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102244:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102247:	83 ce 02             	or     $0x2,%esi
8010224a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010224c:	53                   	push   %ebx
8010224d:	e8 5e 28 00 00       	call   80104ab0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102252:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	85 c0                	test   %eax,%eax
8010225c:	74 05                	je     80102263 <ideintr+0x83>
    idestart(idequeue);
8010225e:	e8 0d fe ff ff       	call   80102070 <idestart>
    release(&idelock);
80102263:	83 ec 0c             	sub    $0xc,%esp
80102266:	68 80 b5 10 80       	push   $0x8010b580
8010226b:	e8 f0 2d 00 00       	call   80105060 <release>

  release(&idelock);
}
80102270:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102273:	5b                   	pop    %ebx
80102274:	5e                   	pop    %esi
80102275:	5f                   	pop    %edi
80102276:	5d                   	pop    %ebp
80102277:	c3                   	ret    
80102278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop

80102280 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102280:	f3 0f 1e fb          	endbr32 
80102284:	55                   	push   %ebp
80102285:	89 e5                	mov    %esp,%ebp
80102287:	53                   	push   %ebx
80102288:	83 ec 10             	sub    $0x10,%esp
8010228b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010228e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102291:	50                   	push   %eax
80102292:	e8 29 2b 00 00       	call   80104dc0 <holdingsleep>
80102297:	83 c4 10             	add    $0x10,%esp
8010229a:	85 c0                	test   %eax,%eax
8010229c:	0f 84 cf 00 00 00    	je     80102371 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022a2:	8b 03                	mov    (%ebx),%eax
801022a4:	83 e0 06             	and    $0x6,%eax
801022a7:	83 f8 02             	cmp    $0x2,%eax
801022aa:	0f 84 b4 00 00 00    	je     80102364 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022b0:	8b 53 04             	mov    0x4(%ebx),%edx
801022b3:	85 d2                	test   %edx,%edx
801022b5:	74 0d                	je     801022c4 <iderw+0x44>
801022b7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801022bc:	85 c0                	test   %eax,%eax
801022be:	0f 84 93 00 00 00    	je     80102357 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	68 80 b5 10 80       	push   $0x8010b580
801022cc:	e8 cf 2c 00 00       	call   80104fa0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
801022d6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022dd:	83 c4 10             	add    $0x10,%esp
801022e0:	85 c0                	test   %eax,%eax
801022e2:	74 6c                	je     80102350 <iderw+0xd0>
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022e8:	89 c2                	mov    %eax,%edx
801022ea:	8b 40 58             	mov    0x58(%eax),%eax
801022ed:	85 c0                	test   %eax,%eax
801022ef:	75 f7                	jne    801022e8 <iderw+0x68>
801022f1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801022f4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801022f6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801022fc:	74 42                	je     80102340 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	74 23                	je     8010232b <iderw+0xab>
80102308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230f:	90                   	nop
    sleep(b, &idelock);
80102310:	83 ec 08             	sub    $0x8,%esp
80102313:	68 80 b5 10 80       	push   $0x8010b580
80102318:	53                   	push   %ebx
80102319:	e8 d2 25 00 00       	call   801048f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 c4 10             	add    $0x10,%esp
80102323:	83 e0 06             	and    $0x6,%eax
80102326:	83 f8 02             	cmp    $0x2,%eax
80102329:	75 e5                	jne    80102310 <iderw+0x90>
  }


  release(&idelock);
8010232b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102335:	c9                   	leave  
  release(&idelock);
80102336:	e9 25 2d 00 00       	jmp    80105060 <release>
8010233b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop
    idestart(b);
80102340:	89 d8                	mov    %ebx,%eax
80102342:	e8 29 fd ff ff       	call   80102070 <idestart>
80102347:	eb b5                	jmp    801022fe <iderw+0x7e>
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102350:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102355:	eb 9d                	jmp    801022f4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102357:	83 ec 0c             	sub    $0xc,%esp
8010235a:	68 35 83 10 80       	push   $0x80108335
8010235f:	e8 2c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 20 83 10 80       	push   $0x80108320
8010236c:	e8 1f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102371:	83 ec 0c             	sub    $0xc,%esp
80102374:	68 0a 83 10 80       	push   $0x8010830a
80102379:	e8 12 e0 ff ff       	call   80100390 <panic>
8010237e:	66 90                	xchg   %ax,%ax

80102380 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102380:	f3 0f 1e fb          	endbr32 
80102384:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102385:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
8010238c:	00 c0 fe 
{
8010238f:	89 e5                	mov    %esp,%ebp
80102391:	56                   	push   %esi
80102392:	53                   	push   %ebx
  ioapic->reg = reg;
80102393:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010239a:	00 00 00 
  return ioapic->data;
8010239d:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801023a3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023a6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023ac:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023b2:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023b9:	c1 ee 10             	shr    $0x10,%esi
801023bc:	89 f0                	mov    %esi,%eax
801023be:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023c1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023c4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023c7:	39 c2                	cmp    %eax,%edx
801023c9:	74 16                	je     801023e1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023cb:	83 ec 0c             	sub    $0xc,%esp
801023ce:	68 54 83 10 80       	push   $0x80108354
801023d3:	e8 d8 e2 ff ff       	call   801006b0 <cprintf>
801023d8:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	83 c6 21             	add    $0x21,%esi
{
801023e4:	ba 10 00 00 00       	mov    $0x10,%edx
801023e9:	b8 20 00 00 00       	mov    $0x20,%eax
801023ee:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801023f0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023f2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801023f4:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801023fa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023fd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102403:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102406:	8d 5a 01             	lea    0x1(%edx),%ebx
80102409:	83 c2 02             	add    $0x2,%edx
8010240c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010240e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102414:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010241b:	39 f0                	cmp    %esi,%eax
8010241d:	75 d1                	jne    801023f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010241f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102422:	5b                   	pop    %ebx
80102423:	5e                   	pop    %esi
80102424:	5d                   	pop    %ebp
80102425:	c3                   	ret    
80102426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242d:	8d 76 00             	lea    0x0(%esi),%esi

80102430 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102430:	f3 0f 1e fb          	endbr32 
80102434:	55                   	push   %ebp
  ioapic->reg = reg;
80102435:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
8010243b:	89 e5                	mov    %esp,%ebp
8010243d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102440:	8d 50 20             	lea    0x20(%eax),%edx
80102443:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102447:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102449:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010244f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102452:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102455:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102458:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010245a:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102462:	89 50 10             	mov    %edx,0x10(%eax)
}
80102465:	5d                   	pop    %ebp
80102466:	c3                   	ret    
80102467:	66 90                	xchg   %ax,%ax
80102469:	66 90                	xchg   %ax,%ax
8010246b:	66 90                	xchg   %ax,%ax
8010246d:	66 90                	xchg   %ax,%ax
8010246f:	90                   	nop

80102470 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102470:	f3 0f 1e fb          	endbr32 
80102474:	55                   	push   %ebp
80102475:	89 e5                	mov    %esp,%ebp
80102477:	53                   	push   %ebx
80102478:	83 ec 04             	sub    $0x4,%esp
8010247b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010247e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102484:	75 7a                	jne    80102500 <kfree+0x90>
80102486:	81 fb a8 6d 11 80    	cmp    $0x80116da8,%ebx
8010248c:	72 72                	jb     80102500 <kfree+0x90>
8010248e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102494:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102499:	77 65                	ja     80102500 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010249b:	83 ec 04             	sub    $0x4,%esp
8010249e:	68 00 10 00 00       	push   $0x1000
801024a3:	6a 01                	push   $0x1
801024a5:	53                   	push   %ebx
801024a6:	e8 05 2c 00 00       	call   801050b0 <memset>

  if(kmem.use_lock)
801024ab:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801024b1:	83 c4 10             	add    $0x10,%esp
801024b4:	85 d2                	test   %edx,%edx
801024b6:	75 20                	jne    801024d8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024b8:	a1 78 36 11 80       	mov    0x80113678,%eax
801024bd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024bf:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
801024c4:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801024ca:	85 c0                	test   %eax,%eax
801024cc:	75 22                	jne    801024f0 <kfree+0x80>
    release(&kmem.lock);
}
801024ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024d1:	c9                   	leave  
801024d2:	c3                   	ret    
801024d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d7:	90                   	nop
    acquire(&kmem.lock);
801024d8:	83 ec 0c             	sub    $0xc,%esp
801024db:	68 40 36 11 80       	push   $0x80113640
801024e0:	e8 bb 2a 00 00       	call   80104fa0 <acquire>
801024e5:	83 c4 10             	add    $0x10,%esp
801024e8:	eb ce                	jmp    801024b8 <kfree+0x48>
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801024f0:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801024f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fa:	c9                   	leave  
    release(&kmem.lock);
801024fb:	e9 60 2b 00 00       	jmp    80105060 <release>
    panic("kfree");
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 86 83 10 80       	push   $0x80108386
80102508:	e8 83 de ff ff       	call   80100390 <panic>
8010250d:	8d 76 00             	lea    0x0(%esi),%esi

80102510 <freerange>:
{
80102510:	f3 0f 1e fb          	endbr32 
80102514:	55                   	push   %ebp
80102515:	89 e5                	mov    %esp,%ebp
80102517:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102518:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010251b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010251e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010251f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102525:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010252b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102531:	39 de                	cmp    %ebx,%esi
80102533:	72 1f                	jb     80102554 <freerange+0x44>
80102535:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102538:	83 ec 0c             	sub    $0xc,%esp
8010253b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102541:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102547:	50                   	push   %eax
80102548:	e8 23 ff ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	39 f3                	cmp    %esi,%ebx
80102552:	76 e4                	jbe    80102538 <freerange+0x28>
}
80102554:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102557:	5b                   	pop    %ebx
80102558:	5e                   	pop    %esi
80102559:	5d                   	pop    %ebp
8010255a:	c3                   	ret    
8010255b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010255f:	90                   	nop

80102560 <kinit1>:
{
80102560:	f3 0f 1e fb          	endbr32 
80102564:	55                   	push   %ebp
80102565:	89 e5                	mov    %esp,%ebp
80102567:	56                   	push   %esi
80102568:	53                   	push   %ebx
80102569:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010256c:	83 ec 08             	sub    $0x8,%esp
8010256f:	68 8c 83 10 80       	push   $0x8010838c
80102574:	68 40 36 11 80       	push   $0x80113640
80102579:	e8 a2 28 00 00       	call   80104e20 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010257e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102581:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102584:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
8010258b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102594:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025a0:	39 de                	cmp    %ebx,%esi
801025a2:	72 20                	jb     801025c4 <kinit1+0x64>
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 b3 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 de                	cmp    %ebx,%esi
801025c2:	73 e4                	jae    801025a8 <kinit1+0x48>
}
801025c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5d                   	pop    %ebp
801025ca:	c3                   	ret    
801025cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <kinit2>:
{
801025d0:	f3 0f 1e fb          	endbr32 
801025d4:	55                   	push   %ebp
801025d5:	89 e5                	mov    %esp,%ebp
801025d7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025d8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025db:	8b 75 0c             	mov    0xc(%ebp),%esi
801025de:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025df:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025f1:	39 de                	cmp    %ebx,%esi
801025f3:	72 1f                	jb     80102614 <kinit2+0x44>
801025f5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 63 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 e4                	jae    801025f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102614:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010261b:	00 00 00 
}
8010261e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5d                   	pop    %ebp
80102624:	c3                   	ret    
80102625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102630:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102634:	a1 74 36 11 80       	mov    0x80113674,%eax
80102639:	85 c0                	test   %eax,%eax
8010263b:	75 1b                	jne    80102658 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010263d:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
80102642:	85 c0                	test   %eax,%eax
80102644:	74 0a                	je     80102650 <kalloc+0x20>
    kmem.freelist = r->next;
80102646:	8b 10                	mov    (%eax),%edx
80102648:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
8010264e:	c3                   	ret    
8010264f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102650:	c3                   	ret    
80102651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102658:	55                   	push   %ebp
80102659:	89 e5                	mov    %esp,%ebp
8010265b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010265e:	68 40 36 11 80       	push   $0x80113640
80102663:	e8 38 29 00 00       	call   80104fa0 <acquire>
  r = kmem.freelist;
80102668:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010266d:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102673:	83 c4 10             	add    $0x10,%esp
80102676:	85 c0                	test   %eax,%eax
80102678:	74 08                	je     80102682 <kalloc+0x52>
    kmem.freelist = r->next;
8010267a:	8b 08                	mov    (%eax),%ecx
8010267c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102682:	85 d2                	test   %edx,%edx
80102684:	74 16                	je     8010269c <kalloc+0x6c>
    release(&kmem.lock);
80102686:	83 ec 0c             	sub    $0xc,%esp
80102689:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010268c:	68 40 36 11 80       	push   $0x80113640
80102691:	e8 ca 29 00 00       	call   80105060 <release>
  return (char*)r;
80102696:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102699:	83 c4 10             	add    $0x10,%esp
}
8010269c:	c9                   	leave  
8010269d:	c3                   	ret    
8010269e:	66 90                	xchg   %ax,%ax

801026a0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026a0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a4:	ba 64 00 00 00       	mov    $0x64,%edx
801026a9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026aa:	a8 01                	test   $0x1,%al
801026ac:	0f 84 be 00 00 00    	je     80102770 <kbdgetc+0xd0>
{
801026b2:	55                   	push   %ebp
801026b3:	ba 60 00 00 00       	mov    $0x60,%edx
801026b8:	89 e5                	mov    %esp,%ebp
801026ba:	53                   	push   %ebx
801026bb:	ec                   	in     (%dx),%al
  return data;
801026bc:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026c2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026c5:	3c e0                	cmp    $0xe0,%al
801026c7:	74 57                	je     80102720 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026c9:	89 d9                	mov    %ebx,%ecx
801026cb:	83 e1 40             	and    $0x40,%ecx
801026ce:	84 c0                	test   %al,%al
801026d0:	78 5e                	js     80102730 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026d2:	85 c9                	test   %ecx,%ecx
801026d4:	74 09                	je     801026df <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026d6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026d9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026dc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026df:	0f b6 8a c0 84 10 80 	movzbl -0x7fef7b40(%edx),%ecx
  shift ^= togglecode[data];
801026e6:	0f b6 82 c0 83 10 80 	movzbl -0x7fef7c40(%edx),%eax
  shift |= shiftcode[data];
801026ed:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ef:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026f1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801026f3:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801026f9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801026fc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026ff:	8b 04 85 a0 83 10 80 	mov    -0x7fef7c60(,%eax,4),%eax
80102706:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010270a:	74 0b                	je     80102717 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010270c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010270f:	83 fa 19             	cmp    $0x19,%edx
80102712:	77 44                	ja     80102758 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102714:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102717:	5b                   	pop    %ebx
80102718:	5d                   	pop    %ebp
80102719:	c3                   	ret    
8010271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102720:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102723:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102725:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010272b:	5b                   	pop    %ebx
8010272c:	5d                   	pop    %ebp
8010272d:	c3                   	ret    
8010272e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102730:	83 e0 7f             	and    $0x7f,%eax
80102733:	85 c9                	test   %ecx,%ecx
80102735:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102738:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010273a:	0f b6 8a c0 84 10 80 	movzbl -0x7fef7b40(%edx),%ecx
80102741:	83 c9 40             	or     $0x40,%ecx
80102744:	0f b6 c9             	movzbl %cl,%ecx
80102747:	f7 d1                	not    %ecx
80102749:	21 d9                	and    %ebx,%ecx
}
8010274b:	5b                   	pop    %ebx
8010274c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010274d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102753:	c3                   	ret    
80102754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102758:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010275b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010275e:	5b                   	pop    %ebx
8010275f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102760:	83 f9 1a             	cmp    $0x1a,%ecx
80102763:	0f 42 c2             	cmovb  %edx,%eax
}
80102766:	c3                   	ret    
80102767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276e:	66 90                	xchg   %ax,%ax
    return -1;
80102770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102775:	c3                   	ret    
80102776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277d:	8d 76 00             	lea    0x0(%esi),%esi

80102780 <kbdintr>:

void
kbdintr(void)
{
80102780:	f3 0f 1e fb          	endbr32 
80102784:	55                   	push   %ebp
80102785:	89 e5                	mov    %esp,%ebp
80102787:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010278a:	68 a0 26 10 80       	push   $0x801026a0
8010278f:	e8 cc e0 ff ff       	call   80100860 <consoleintr>
}
80102794:	83 c4 10             	add    $0x10,%esp
80102797:	c9                   	leave  
80102798:	c3                   	ret    
80102799:	66 90                	xchg   %ax,%ax
8010279b:	66 90                	xchg   %ax,%ax
8010279d:	66 90                	xchg   %ax,%ax
8010279f:	90                   	nop

801027a0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027a0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027a4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801027a9:	85 c0                	test   %eax,%eax
801027ab:	0f 84 c7 00 00 00    	je     80102878 <lapicinit+0xd8>
  lapic[index] = value;
801027b1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027b8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027be:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027c5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027cb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027d2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027d5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027df:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027e2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027ec:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ef:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027f9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027fc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027ff:	8b 50 30             	mov    0x30(%eax),%edx
80102802:	c1 ea 10             	shr    $0x10,%edx
80102805:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010280b:	75 73                	jne    80102880 <lapicinit+0xe0>
  lapic[index] = value;
8010280d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102814:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102821:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102827:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010282e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102831:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102834:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010283b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102848:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102855:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102858:	8b 50 20             	mov    0x20(%eax),%edx
8010285b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010285f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102860:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102866:	80 e6 10             	and    $0x10,%dh
80102869:	75 f5                	jne    80102860 <lapicinit+0xc0>
  lapic[index] = value;
8010286b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102872:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102875:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102878:	c3                   	ret    
80102879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102880:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102887:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010288d:	e9 7b ff ff ff       	jmp    8010280d <lapicinit+0x6d>
80102892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028a0 <lapicid>:

int
lapicid(void)
{
801028a0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028a4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028a9:	85 c0                	test   %eax,%eax
801028ab:	74 0b                	je     801028b8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028ad:	8b 40 20             	mov    0x20(%eax),%eax
801028b0:	c1 e8 18             	shr    $0x18,%eax
801028b3:	c3                   	ret    
801028b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028b8:	31 c0                	xor    %eax,%eax
}
801028ba:	c3                   	ret    
801028bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop

801028c0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028c0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028c4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028c9:	85 c0                	test   %eax,%eax
801028cb:	74 0d                	je     801028da <lapiceoi+0x1a>
  lapic[index] = value;
801028cd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028da:	c3                   	ret    
801028db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028df:	90                   	nop

801028e0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028e0:	f3 0f 1e fb          	endbr32 
}
801028e4:	c3                   	ret    
801028e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801028f0:	f3 0f 1e fb          	endbr32 
801028f4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f5:	b8 0f 00 00 00       	mov    $0xf,%eax
801028fa:	ba 70 00 00 00       	mov    $0x70,%edx
801028ff:	89 e5                	mov    %esp,%ebp
80102901:	53                   	push   %ebx
80102902:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102905:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102908:	ee                   	out    %al,(%dx)
80102909:	b8 0a 00 00 00       	mov    $0xa,%eax
8010290e:	ba 71 00 00 00       	mov    $0x71,%edx
80102913:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102914:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102916:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102919:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010291f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102921:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102924:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102926:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102929:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010292c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102932:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102937:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010293d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102940:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102947:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010294a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010294d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102954:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102957:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102960:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102963:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102972:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102975:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010297b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010297c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010297f:	5d                   	pop    %ebp
80102980:	c3                   	ret    
80102981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298f:	90                   	nop

80102990 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102990:	f3 0f 1e fb          	endbr32 
80102994:	55                   	push   %ebp
80102995:	b8 0b 00 00 00       	mov    $0xb,%eax
8010299a:	ba 70 00 00 00       	mov    $0x70,%edx
8010299f:	89 e5                	mov    %esp,%ebp
801029a1:	57                   	push   %edi
801029a2:	56                   	push   %esi
801029a3:	53                   	push   %ebx
801029a4:	83 ec 4c             	sub    $0x4c,%esp
801029a7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a8:	ba 71 00 00 00       	mov    $0x71,%edx
801029ad:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ae:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029b6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029c0:	31 c0                	xor    %eax,%eax
801029c2:	89 da                	mov    %ebx,%edx
801029c4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029ca:	89 ca                	mov    %ecx,%edx
801029cc:	ec                   	in     (%dx),%al
801029cd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d0:	89 da                	mov    %ebx,%edx
801029d2:	b8 02 00 00 00       	mov    $0x2,%eax
801029d7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d8:	89 ca                	mov    %ecx,%edx
801029da:	ec                   	in     (%dx),%al
801029db:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029de:	89 da                	mov    %ebx,%edx
801029e0:	b8 04 00 00 00       	mov    $0x4,%eax
801029e5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e6:	89 ca                	mov    %ecx,%edx
801029e8:	ec                   	in     (%dx),%al
801029e9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ec:	89 da                	mov    %ebx,%edx
801029ee:	b8 07 00 00 00       	mov    $0x7,%eax
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	89 ca                	mov    %ecx,%edx
801029f6:	ec                   	in     (%dx),%al
801029f7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	b8 08 00 00 00       	mov    $0x8,%eax
80102a01:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a07:	89 da                	mov    %ebx,%edx
80102a09:	b8 09 00 00 00       	mov    $0x9,%eax
80102a0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0f:	89 ca                	mov    %ecx,%edx
80102a11:	ec                   	in     (%dx),%al
80102a12:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a14:	89 da                	mov    %ebx,%edx
80102a16:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1c:	89 ca                	mov    %ecx,%edx
80102a1e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a1f:	84 c0                	test   %al,%al
80102a21:	78 9d                	js     801029c0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a23:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a27:	89 fa                	mov    %edi,%edx
80102a29:	0f b6 fa             	movzbl %dl,%edi
80102a2c:	89 f2                	mov    %esi,%edx
80102a2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a31:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a35:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a38:	89 da                	mov    %ebx,%edx
80102a3a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a3d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a40:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a44:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a47:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a4a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a4e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a51:	31 c0                	xor    %eax,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al
80102a57:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5a:	89 da                	mov    %ebx,%edx
80102a5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a5f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a64:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a65:	89 ca                	mov    %ecx,%edx
80102a67:	ec                   	in     (%dx),%al
80102a68:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6b:	89 da                	mov    %ebx,%edx
80102a6d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a70:	b8 04 00 00 00       	mov    $0x4,%eax
80102a75:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a76:	89 ca                	mov    %ecx,%edx
80102a78:	ec                   	in     (%dx),%al
80102a79:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7c:	89 da                	mov    %ebx,%edx
80102a7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a81:	b8 07 00 00 00       	mov    $0x7,%eax
80102a86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a87:	89 ca                	mov    %ecx,%edx
80102a89:	ec                   	in     (%dx),%al
80102a8a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8d:	89 da                	mov    %ebx,%edx
80102a8f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a92:	b8 08 00 00 00       	mov    $0x8,%eax
80102a97:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a98:	89 ca                	mov    %ecx,%edx
80102a9a:	ec                   	in     (%dx),%al
80102a9b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9e:	89 da                	mov    %ebx,%edx
80102aa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102aa3:	b8 09 00 00 00       	mov    $0x9,%eax
80102aa8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa9:	89 ca                	mov    %ecx,%edx
80102aab:	ec                   	in     (%dx),%al
80102aac:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aaf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ab2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ab5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ab8:	6a 18                	push   $0x18
80102aba:	50                   	push   %eax
80102abb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102abe:	50                   	push   %eax
80102abf:	e8 3c 26 00 00       	call   80105100 <memcmp>
80102ac4:	83 c4 10             	add    $0x10,%esp
80102ac7:	85 c0                	test   %eax,%eax
80102ac9:	0f 85 f1 fe ff ff    	jne    801029c0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102acf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ad3:	75 78                	jne    80102b4d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ad5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ad8:	89 c2                	mov    %eax,%edx
80102ada:	83 e0 0f             	and    $0xf,%eax
80102add:	c1 ea 04             	shr    $0x4,%edx
80102ae0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ae3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ae6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ae9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102aec:	89 c2                	mov    %eax,%edx
80102aee:	83 e0 0f             	and    $0xf,%eax
80102af1:	c1 ea 04             	shr    $0x4,%edx
80102af4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102afa:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102afd:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b00:	89 c2                	mov    %eax,%edx
80102b02:	83 e0 0f             	and    $0xf,%eax
80102b05:	c1 ea 04             	shr    $0x4,%edx
80102b08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b11:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b14:	89 c2                	mov    %eax,%edx
80102b16:	83 e0 0f             	and    $0xf,%eax
80102b19:	c1 ea 04             	shr    $0x4,%edx
80102b1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b22:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b25:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b28:	89 c2                	mov    %eax,%edx
80102b2a:	83 e0 0f             	and    $0xf,%eax
80102b2d:	c1 ea 04             	shr    $0x4,%edx
80102b30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b36:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b39:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b3c:	89 c2                	mov    %eax,%edx
80102b3e:	83 e0 0f             	and    $0xf,%eax
80102b41:	c1 ea 04             	shr    $0x4,%edx
80102b44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b4d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b50:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b53:	89 06                	mov    %eax,(%esi)
80102b55:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b58:	89 46 04             	mov    %eax,0x4(%esi)
80102b5b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b5e:	89 46 08             	mov    %eax,0x8(%esi)
80102b61:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b64:	89 46 0c             	mov    %eax,0xc(%esi)
80102b67:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b6a:	89 46 10             	mov    %eax,0x10(%esi)
80102b6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b70:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b73:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b7d:	5b                   	pop    %ebx
80102b7e:	5e                   	pop    %esi
80102b7f:	5f                   	pop    %edi
80102b80:	5d                   	pop    %ebp
80102b81:	c3                   	ret    
80102b82:	66 90                	xchg   %ax,%ax
80102b84:	66 90                	xchg   %ax,%ax
80102b86:	66 90                	xchg   %ax,%ax
80102b88:	66 90                	xchg   %ax,%ax
80102b8a:	66 90                	xchg   %ax,%ax
80102b8c:	66 90                	xchg   %ax,%ax
80102b8e:	66 90                	xchg   %ax,%ax

80102b90 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b90:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102b96:	85 c9                	test   %ecx,%ecx
80102b98:	0f 8e 8a 00 00 00    	jle    80102c28 <install_trans+0x98>
{
80102b9e:	55                   	push   %ebp
80102b9f:	89 e5                	mov    %esp,%ebp
80102ba1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ba2:	31 ff                	xor    %edi,%edi
{
80102ba4:	56                   	push   %esi
80102ba5:	53                   	push   %ebx
80102ba6:	83 ec 0c             	sub    $0xc,%esp
80102ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bb0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102bb5:	83 ec 08             	sub    $0x8,%esp
80102bb8:	01 f8                	add    %edi,%eax
80102bba:	83 c0 01             	add    $0x1,%eax
80102bbd:	50                   	push   %eax
80102bbe:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102bc4:	e8 07 d5 ff ff       	call   801000d0 <bread>
80102bc9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bcb:	58                   	pop    %eax
80102bcc:	5a                   	pop    %edx
80102bcd:	ff 34 bd cc 36 11 80 	pushl  -0x7feec934(,%edi,4)
80102bd4:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bda:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdd:	e8 ee d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102be5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bea:	68 00 02 00 00       	push   $0x200
80102bef:	50                   	push   %eax
80102bf0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102bf3:	50                   	push   %eax
80102bf4:	e8 57 25 00 00       	call   80105150 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bf9:	89 1c 24             	mov    %ebx,(%esp)
80102bfc:	e8 af d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c01:	89 34 24             	mov    %esi,(%esp)
80102c04:	e8 e7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 df d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	39 3d c8 36 11 80    	cmp    %edi,0x801136c8
80102c1a:	7f 94                	jg     80102bb0 <install_trans+0x20>
  }
}
80102c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c1f:	5b                   	pop    %ebx
80102c20:	5e                   	pop    %esi
80102c21:	5f                   	pop    %edi
80102c22:	5d                   	pop    %ebp
80102c23:	c3                   	ret    
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c28:	c3                   	ret    
80102c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	53                   	push   %ebx
80102c34:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c37:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102c3d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102c43:	e8 88 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c48:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c4b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c4d:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102c52:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c55:	85 c0                	test   %eax,%eax
80102c57:	7e 19                	jle    80102c72 <write_head+0x42>
80102c59:	31 d2                	xor    %edx,%edx
80102c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c60:	8b 0c 95 cc 36 11 80 	mov    -0x7feec934(,%edx,4),%ecx
80102c67:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c6b:	83 c2 01             	add    $0x1,%edx
80102c6e:	39 d0                	cmp    %edx,%eax
80102c70:	75 ee                	jne    80102c60 <write_head+0x30>
  }
  bwrite(buf);
80102c72:	83 ec 0c             	sub    $0xc,%esp
80102c75:	53                   	push   %ebx
80102c76:	e8 35 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c7b:	89 1c 24             	mov    %ebx,(%esp)
80102c7e:	e8 6d d5 ff ff       	call   801001f0 <brelse>
}
80102c83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c86:	83 c4 10             	add    $0x10,%esp
80102c89:	c9                   	leave  
80102c8a:	c3                   	ret    
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop

80102c90 <initlog>:
{
80102c90:	f3 0f 1e fb          	endbr32 
80102c94:	55                   	push   %ebp
80102c95:	89 e5                	mov    %esp,%ebp
80102c97:	53                   	push   %ebx
80102c98:	83 ec 2c             	sub    $0x2c,%esp
80102c9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c9e:	68 c0 85 10 80       	push   $0x801085c0
80102ca3:	68 80 36 11 80       	push   $0x80113680
80102ca8:	e8 73 21 00 00       	call   80104e20 <initlock>
  readsb(dev, &sb);
80102cad:	58                   	pop    %eax
80102cae:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cb1:	5a                   	pop    %edx
80102cb2:	50                   	push   %eax
80102cb3:	53                   	push   %ebx
80102cb4:	e8 47 e8 ff ff       	call   80101500 <readsb>
  log.start = sb.logstart;
80102cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cbc:	59                   	pop    %ecx
  log.dev = dev;
80102cbd:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102cc3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cc6:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  log.size = sb.nlog;
80102ccb:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  struct buf *buf = bread(log.dev, log.start);
80102cd1:	5a                   	pop    %edx
80102cd2:	50                   	push   %eax
80102cd3:	53                   	push   %ebx
80102cd4:	e8 f7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102cd9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cdc:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cdf:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	85 c9                	test   %ecx,%ecx
80102ce7:	7e 19                	jle    80102d02 <initlog+0x72>
80102ce9:	31 d2                	xor    %edx,%edx
80102ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cef:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102cf0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102cf4:	89 1c 95 cc 36 11 80 	mov    %ebx,-0x7feec934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cfb:	83 c2 01             	add    $0x1,%edx
80102cfe:	39 d1                	cmp    %edx,%ecx
80102d00:	75 ee                	jne    80102cf0 <initlog+0x60>
  brelse(buf);
80102d02:	83 ec 0c             	sub    $0xc,%esp
80102d05:	50                   	push   %eax
80102d06:	e8 e5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d0b:	e8 80 fe ff ff       	call   80102b90 <install_trans>
  log.lh.n = 0;
80102d10:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102d17:	00 00 00 
  write_head(); // clear the log
80102d1a:	e8 11 ff ff ff       	call   80102c30 <write_head>
}
80102d1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d22:	83 c4 10             	add    $0x10,%esp
80102d25:	c9                   	leave  
80102d26:	c3                   	ret    
80102d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2e:	66 90                	xchg   %ax,%ax

80102d30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d30:	f3 0f 1e fb          	endbr32 
80102d34:	55                   	push   %ebp
80102d35:	89 e5                	mov    %esp,%ebp
80102d37:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d3a:	68 80 36 11 80       	push   $0x80113680
80102d3f:	e8 5c 22 00 00       	call   80104fa0 <acquire>
80102d44:	83 c4 10             	add    $0x10,%esp
80102d47:	eb 1c                	jmp    80102d65 <begin_op+0x35>
80102d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d50:	83 ec 08             	sub    $0x8,%esp
80102d53:	68 80 36 11 80       	push   $0x80113680
80102d58:	68 80 36 11 80       	push   $0x80113680
80102d5d:	e8 8e 1b 00 00       	call   801048f0 <sleep>
80102d62:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d65:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102d6a:	85 c0                	test   %eax,%eax
80102d6c:	75 e2                	jne    80102d50 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d6e:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102d73:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102d79:	83 c0 01             	add    $0x1,%eax
80102d7c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d7f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d82:	83 fa 1e             	cmp    $0x1e,%edx
80102d85:	7f c9                	jg     80102d50 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d87:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d8a:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102d8f:	68 80 36 11 80       	push   $0x80113680
80102d94:	e8 c7 22 00 00       	call   80105060 <release>
      break;
    }
  }
}
80102d99:	83 c4 10             	add    $0x10,%esp
80102d9c:	c9                   	leave  
80102d9d:	c3                   	ret    
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102da0:	f3 0f 1e fb          	endbr32 
80102da4:	55                   	push   %ebp
80102da5:	89 e5                	mov    %esp,%ebp
80102da7:	57                   	push   %edi
80102da8:	56                   	push   %esi
80102da9:	53                   	push   %ebx
80102daa:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dad:	68 80 36 11 80       	push   $0x80113680
80102db2:	e8 e9 21 00 00       	call   80104fa0 <acquire>
  log.outstanding -= 1;
80102db7:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102dbc:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102dc2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dc8:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102dce:	85 f6                	test   %esi,%esi
80102dd0:	0f 85 1e 01 00 00    	jne    80102ef4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102dd6:	85 db                	test   %ebx,%ebx
80102dd8:	0f 85 f2 00 00 00    	jne    80102ed0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dde:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102de5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102de8:	83 ec 0c             	sub    $0xc,%esp
80102deb:	68 80 36 11 80       	push   $0x80113680
80102df0:	e8 6b 22 00 00       	call   80105060 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102df5:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102dfb:	83 c4 10             	add    $0x10,%esp
80102dfe:	85 c9                	test   %ecx,%ecx
80102e00:	7f 3e                	jg     80102e40 <end_op+0xa0>
    acquire(&log.lock);
80102e02:	83 ec 0c             	sub    $0xc,%esp
80102e05:	68 80 36 11 80       	push   $0x80113680
80102e0a:	e8 91 21 00 00       	call   80104fa0 <acquire>
    wakeup(&log);
80102e0f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102e16:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102e1d:	00 00 00 
    wakeup(&log);
80102e20:	e8 8b 1c 00 00       	call   80104ab0 <wakeup>
    release(&log.lock);
80102e25:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102e2c:	e8 2f 22 00 00       	call   80105060 <release>
80102e31:	83 c4 10             	add    $0x10,%esp
}
80102e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e37:	5b                   	pop    %ebx
80102e38:	5e                   	pop    %esi
80102e39:	5f                   	pop    %edi
80102e3a:	5d                   	pop    %ebp
80102e3b:	c3                   	ret    
80102e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e40:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102e45:	83 ec 08             	sub    $0x8,%esp
80102e48:	01 d8                	add    %ebx,%eax
80102e4a:	83 c0 01             	add    $0x1,%eax
80102e4d:	50                   	push   %eax
80102e4e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e54:	e8 77 d2 ff ff       	call   801000d0 <bread>
80102e59:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e5b:	58                   	pop    %eax
80102e5c:	5a                   	pop    %edx
80102e5d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102e64:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6d:	e8 5e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e72:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e75:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e77:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e7a:	68 00 02 00 00       	push   $0x200
80102e7f:	50                   	push   %eax
80102e80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e83:	50                   	push   %eax
80102e84:	e8 c7 22 00 00       	call   80105150 <memmove>
    bwrite(to);  // write the log
80102e89:	89 34 24             	mov    %esi,(%esp)
80102e8c:	e8 1f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102e91:	89 3c 24             	mov    %edi,(%esp)
80102e94:	e8 57 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 4f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ea1:	83 c4 10             	add    $0x10,%esp
80102ea4:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102eaa:	7c 94                	jl     80102e40 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eac:	e8 7f fd ff ff       	call   80102c30 <write_head>
    install_trans(); // Now install writes to home locations
80102eb1:	e8 da fc ff ff       	call   80102b90 <install_trans>
    log.lh.n = 0;
80102eb6:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102ebd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ec0:	e8 6b fd ff ff       	call   80102c30 <write_head>
80102ec5:	e9 38 ff ff ff       	jmp    80102e02 <end_op+0x62>
80102eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ed0:	83 ec 0c             	sub    $0xc,%esp
80102ed3:	68 80 36 11 80       	push   $0x80113680
80102ed8:	e8 d3 1b 00 00       	call   80104ab0 <wakeup>
  release(&log.lock);
80102edd:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102ee4:	e8 77 21 00 00       	call   80105060 <release>
80102ee9:	83 c4 10             	add    $0x10,%esp
}
80102eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eef:	5b                   	pop    %ebx
80102ef0:	5e                   	pop    %esi
80102ef1:	5f                   	pop    %edi
80102ef2:	5d                   	pop    %ebp
80102ef3:	c3                   	ret    
    panic("log.committing");
80102ef4:	83 ec 0c             	sub    $0xc,%esp
80102ef7:	68 c4 85 10 80       	push   $0x801085c4
80102efc:	e8 8f d4 ff ff       	call   80100390 <panic>
80102f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f0f:	90                   	nop

80102f10 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f10:	f3 0f 1e fb          	endbr32 
80102f14:	55                   	push   %ebp
80102f15:	89 e5                	mov    %esp,%ebp
80102f17:	53                   	push   %ebx
80102f18:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f1b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102f21:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f24:	83 fa 1d             	cmp    $0x1d,%edx
80102f27:	0f 8f 91 00 00 00    	jg     80102fbe <log_write+0xae>
80102f2d:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102f32:	83 e8 01             	sub    $0x1,%eax
80102f35:	39 c2                	cmp    %eax,%edx
80102f37:	0f 8d 81 00 00 00    	jge    80102fbe <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f3d:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f42:	85 c0                	test   %eax,%eax
80102f44:	0f 8e 81 00 00 00    	jle    80102fcb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 80 36 11 80       	push   $0x80113680
80102f52:	e8 49 20 00 00       	call   80104fa0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f57:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102f5d:	83 c4 10             	add    $0x10,%esp
80102f60:	85 d2                	test   %edx,%edx
80102f62:	7e 4e                	jle    80102fb2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f64:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f67:	31 c0                	xor    %eax,%eax
80102f69:	eb 0c                	jmp    80102f77 <log_write+0x67>
80102f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f6f:	90                   	nop
80102f70:	83 c0 01             	add    $0x1,%eax
80102f73:	39 c2                	cmp    %eax,%edx
80102f75:	74 29                	je     80102fa0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f77:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80102f7e:	75 f0                	jne    80102f70 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f87:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f8d:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102f94:	c9                   	leave  
  release(&log.lock);
80102f95:	e9 c6 20 00 00       	jmp    80105060 <release>
80102f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
    log.lh.n++;
80102fa7:	83 c2 01             	add    $0x1,%edx
80102faa:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
80102fb0:	eb d5                	jmp    80102f87 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fb2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fb5:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102fba:	75 cb                	jne    80102f87 <log_write+0x77>
80102fbc:	eb e9                	jmp    80102fa7 <log_write+0x97>
    panic("too big a transaction");
80102fbe:	83 ec 0c             	sub    $0xc,%esp
80102fc1:	68 d3 85 10 80       	push   $0x801085d3
80102fc6:	e8 c5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fcb:	83 ec 0c             	sub    $0xc,%esp
80102fce:	68 e9 85 10 80       	push   $0x801085e9
80102fd3:	e8 b8 d3 ff ff       	call   80100390 <panic>
80102fd8:	66 90                	xchg   %ax,%ax
80102fda:	66 90                	xchg   %ax,%ax
80102fdc:	66 90                	xchg   %ax,%ax
80102fde:	66 90                	xchg   %ax,%ax

80102fe0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	53                   	push   %ebx
80102fe4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fe7:	e8 f4 09 00 00       	call   801039e0 <cpuid>
80102fec:	89 c3                	mov    %eax,%ebx
80102fee:	e8 ed 09 00 00       	call   801039e0 <cpuid>
80102ff3:	83 ec 04             	sub    $0x4,%esp
80102ff6:	53                   	push   %ebx
80102ff7:	50                   	push   %eax
80102ff8:	68 04 86 10 80       	push   $0x80108604
80102ffd:	e8 ae d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103002:	e8 39 39 00 00       	call   80106940 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103007:	e8 64 09 00 00       	call   80103970 <mycpu>
8010300c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010300e:	b8 01 00 00 00       	mov    $0x1,%eax
80103013:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010301a:	e8 e1 14 00 00       	call   80104500 <scheduler>
8010301f:	90                   	nop

80103020 <mpenter>:
{
80103020:	f3 0f 1e fb          	endbr32 
80103024:	55                   	push   %ebp
80103025:	89 e5                	mov    %esp,%ebp
80103027:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010302a:	e8 f1 49 00 00       	call   80107a20 <switchkvm>
  seginit();
8010302f:	e8 5c 49 00 00       	call   80107990 <seginit>
  lapicinit();
80103034:	e8 67 f7 ff ff       	call   801027a0 <lapicinit>
  mpmain();
80103039:	e8 a2 ff ff ff       	call   80102fe0 <mpmain>
8010303e:	66 90                	xchg   %ax,%ax

80103040 <main>:
{
80103040:	f3 0f 1e fb          	endbr32 
80103044:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103048:	83 e4 f0             	and    $0xfffffff0,%esp
8010304b:	ff 71 fc             	pushl  -0x4(%ecx)
8010304e:	55                   	push   %ebp
8010304f:	89 e5                	mov    %esp,%ebp
80103051:	53                   	push   %ebx
80103052:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103053:	83 ec 08             	sub    $0x8,%esp
80103056:	68 00 00 40 80       	push   $0x80400000
8010305b:	68 a8 6d 11 80       	push   $0x80116da8
80103060:	e8 fb f4 ff ff       	call   80102560 <kinit1>
  kvmalloc();      // kernel page table
80103065:	e8 96 4e 00 00       	call   80107f00 <kvmalloc>
  mpinit();        // detect other processors
8010306a:	e8 81 01 00 00       	call   801031f0 <mpinit>
  lapicinit();     // interrupt controller
8010306f:	e8 2c f7 ff ff       	call   801027a0 <lapicinit>
  seginit();       // segment descriptors
80103074:	e8 17 49 00 00       	call   80107990 <seginit>
  picinit();       // disable pic
80103079:	e8 52 03 00 00       	call   801033d0 <picinit>
  ioapicinit();    // another interrupt controller
8010307e:	e8 fd f2 ff ff       	call   80102380 <ioapicinit>
  consoleinit();   // console hardware
80103083:	e8 a8 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103088:	e8 c3 3b 00 00       	call   80106c50 <uartinit>
  pinit();         // process table
8010308d:	e8 6e 08 00 00       	call   80103900 <pinit>
  tvinit();        // trap vectors
80103092:	e8 29 38 00 00       	call   801068c0 <tvinit>
  binit();         // buffer cache
80103097:	e8 a4 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010309c:	e8 3f dd ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
801030a1:	e8 aa f0 ff ff       	call   80102150 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030a6:	83 c4 0c             	add    $0xc,%esp
801030a9:	68 8a 00 00 00       	push   $0x8a
801030ae:	68 8c b4 10 80       	push   $0x8010b48c
801030b3:	68 00 70 00 80       	push   $0x80007000
801030b8:	e8 93 20 00 00       	call   80105150 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030bd:	83 c4 10             	add    $0x10,%esp
801030c0:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801030c7:	00 00 00 
801030ca:	05 80 37 11 80       	add    $0x80113780,%eax
801030cf:	3d 80 37 11 80       	cmp    $0x80113780,%eax
801030d4:	76 7a                	jbe    80103150 <main+0x110>
801030d6:	bb 80 37 11 80       	mov    $0x80113780,%ebx
801030db:	eb 1c                	jmp    801030f9 <main+0xb9>
801030dd:	8d 76 00             	lea    0x0(%esi),%esi
801030e0:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801030e7:	00 00 00 
801030ea:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030f0:	05 80 37 11 80       	add    $0x80113780,%eax
801030f5:	39 c3                	cmp    %eax,%ebx
801030f7:	73 57                	jae    80103150 <main+0x110>
    if(c == mycpu())  // We've started already.
801030f9:	e8 72 08 00 00       	call   80103970 <mycpu>
801030fe:	39 c3                	cmp    %eax,%ebx
80103100:	74 de                	je     801030e0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103102:	e8 29 f5 ff ff       	call   80102630 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103107:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010310a:	c7 05 f8 6f 00 80 20 	movl   $0x80103020,0x80006ff8
80103111:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103114:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010311b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010311e:	05 00 10 00 00       	add    $0x1000,%eax
80103123:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103128:	0f b6 03             	movzbl (%ebx),%eax
8010312b:	68 00 70 00 00       	push   $0x7000
80103130:	50                   	push   %eax
80103131:	e8 ba f7 ff ff       	call   801028f0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103136:	83 c4 10             	add    $0x10,%esp
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103140:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103146:	85 c0                	test   %eax,%eax
80103148:	74 f6                	je     80103140 <main+0x100>
8010314a:	eb 94                	jmp    801030e0 <main+0xa0>
8010314c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103150:	83 ec 08             	sub    $0x8,%esp
80103153:	68 00 00 00 8e       	push   $0x8e000000
80103158:	68 00 00 40 80       	push   $0x80400000
8010315d:	e8 6e f4 ff ff       	call   801025d0 <kinit2>
  userinit();      // first user process
80103162:	e8 f9 09 00 00       	call   80103b60 <userinit>
  mpmain();        // finish this processor's setup
80103167:	e8 74 fe ff ff       	call   80102fe0 <mpmain>
8010316c:	66 90                	xchg   %ax,%ax
8010316e:	66 90                	xchg   %ax,%ax

80103170 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	57                   	push   %edi
80103174:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103175:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010317b:	53                   	push   %ebx
  e = addr+len;
8010317c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010317f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103182:	39 de                	cmp    %ebx,%esi
80103184:	72 10                	jb     80103196 <mpsearch1+0x26>
80103186:	eb 50                	jmp    801031d8 <mpsearch1+0x68>
80103188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010318f:	90                   	nop
80103190:	89 fe                	mov    %edi,%esi
80103192:	39 fb                	cmp    %edi,%ebx
80103194:	76 42                	jbe    801031d8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103196:	83 ec 04             	sub    $0x4,%esp
80103199:	8d 7e 10             	lea    0x10(%esi),%edi
8010319c:	6a 04                	push   $0x4
8010319e:	68 18 86 10 80       	push   $0x80108618
801031a3:	56                   	push   %esi
801031a4:	e8 57 1f 00 00       	call   80105100 <memcmp>
801031a9:	83 c4 10             	add    $0x10,%esp
801031ac:	85 c0                	test   %eax,%eax
801031ae:	75 e0                	jne    80103190 <mpsearch1+0x20>
801031b0:	89 f2                	mov    %esi,%edx
801031b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031b8:	0f b6 0a             	movzbl (%edx),%ecx
801031bb:	83 c2 01             	add    $0x1,%edx
801031be:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031c0:	39 fa                	cmp    %edi,%edx
801031c2:	75 f4                	jne    801031b8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031c4:	84 c0                	test   %al,%al
801031c6:	75 c8                	jne    80103190 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031cb:	89 f0                	mov    %esi,%eax
801031cd:	5b                   	pop    %ebx
801031ce:	5e                   	pop    %esi
801031cf:	5f                   	pop    %edi
801031d0:	5d                   	pop    %ebp
801031d1:	c3                   	ret    
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031db:	31 f6                	xor    %esi,%esi
}
801031dd:	5b                   	pop    %ebx
801031de:	89 f0                	mov    %esi,%eax
801031e0:	5e                   	pop    %esi
801031e1:	5f                   	pop    %edi
801031e2:	5d                   	pop    %ebp
801031e3:	c3                   	ret    
801031e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ef:	90                   	nop

801031f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031f0:	f3 0f 1e fb          	endbr32 
801031f4:	55                   	push   %ebp
801031f5:	89 e5                	mov    %esp,%ebp
801031f7:	57                   	push   %edi
801031f8:	56                   	push   %esi
801031f9:	53                   	push   %ebx
801031fa:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031fd:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103204:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010320b:	c1 e0 08             	shl    $0x8,%eax
8010320e:	09 d0                	or     %edx,%eax
80103210:	c1 e0 04             	shl    $0x4,%eax
80103213:	75 1b                	jne    80103230 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103215:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010321c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103223:	c1 e0 08             	shl    $0x8,%eax
80103226:	09 d0                	or     %edx,%eax
80103228:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010322b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103230:	ba 00 04 00 00       	mov    $0x400,%edx
80103235:	e8 36 ff ff ff       	call   80103170 <mpsearch1>
8010323a:	89 c6                	mov    %eax,%esi
8010323c:	85 c0                	test   %eax,%eax
8010323e:	0f 84 4c 01 00 00    	je     80103390 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103244:	8b 5e 04             	mov    0x4(%esi),%ebx
80103247:	85 db                	test   %ebx,%ebx
80103249:	0f 84 61 01 00 00    	je     801033b0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010324f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103252:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103258:	6a 04                	push   $0x4
8010325a:	68 1d 86 10 80       	push   $0x8010861d
8010325f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103260:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103263:	e8 98 1e 00 00       	call   80105100 <memcmp>
80103268:	83 c4 10             	add    $0x10,%esp
8010326b:	85 c0                	test   %eax,%eax
8010326d:	0f 85 3d 01 00 00    	jne    801033b0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103273:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010327a:	3c 01                	cmp    $0x1,%al
8010327c:	74 08                	je     80103286 <mpinit+0x96>
8010327e:	3c 04                	cmp    $0x4,%al
80103280:	0f 85 2a 01 00 00    	jne    801033b0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103286:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010328d:	66 85 d2             	test   %dx,%dx
80103290:	74 26                	je     801032b8 <mpinit+0xc8>
80103292:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103295:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103297:	31 d2                	xor    %edx,%edx
80103299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032a0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032a7:	83 c0 01             	add    $0x1,%eax
801032aa:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032ac:	39 f8                	cmp    %edi,%eax
801032ae:	75 f0                	jne    801032a0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032b0:	84 d2                	test   %dl,%dl
801032b2:	0f 85 f8 00 00 00    	jne    801033b0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032b8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032be:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032c3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032c9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032d0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032d8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032df:	90                   	nop
801032e0:	39 c2                	cmp    %eax,%edx
801032e2:	76 15                	jbe    801032f9 <mpinit+0x109>
    switch(*p){
801032e4:	0f b6 08             	movzbl (%eax),%ecx
801032e7:	80 f9 02             	cmp    $0x2,%cl
801032ea:	74 5c                	je     80103348 <mpinit+0x158>
801032ec:	77 42                	ja     80103330 <mpinit+0x140>
801032ee:	84 c9                	test   %cl,%cl
801032f0:	74 6e                	je     80103360 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032f2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032f5:	39 c2                	cmp    %eax,%edx
801032f7:	77 eb                	ja     801032e4 <mpinit+0xf4>
801032f9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032fc:	85 db                	test   %ebx,%ebx
801032fe:	0f 84 b9 00 00 00    	je     801033bd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103304:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103308:	74 15                	je     8010331f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010330a:	b8 70 00 00 00       	mov    $0x70,%eax
8010330f:	ba 22 00 00 00       	mov    $0x22,%edx
80103314:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103315:	ba 23 00 00 00       	mov    $0x23,%edx
8010331a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010331b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331e:	ee                   	out    %al,(%dx)
  }
}
8010331f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103322:	5b                   	pop    %ebx
80103323:	5e                   	pop    %esi
80103324:	5f                   	pop    %edi
80103325:	5d                   	pop    %ebp
80103326:	c3                   	ret    
80103327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010332e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103330:	83 e9 03             	sub    $0x3,%ecx
80103333:	80 f9 01             	cmp    $0x1,%cl
80103336:	76 ba                	jbe    801032f2 <mpinit+0x102>
80103338:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010333f:	eb 9f                	jmp    801032e0 <mpinit+0xf0>
80103341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103348:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010334c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010334f:	88 0d 60 37 11 80    	mov    %cl,0x80113760
      continue;
80103355:	eb 89                	jmp    801032e0 <mpinit+0xf0>
80103357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010335e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103360:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f 80 37 11 80    	mov    %bl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 54 ff ff ff       	jmp    801032e0 <mpinit+0xf0>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103390:	ba 00 00 01 00       	mov    $0x10000,%edx
80103395:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010339a:	e8 d1 fd ff ff       	call   80103170 <mpsearch1>
8010339f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033a1:	85 c0                	test   %eax,%eax
801033a3:	0f 85 9b fe ff ff    	jne    80103244 <mpinit+0x54>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033b0:	83 ec 0c             	sub    $0xc,%esp
801033b3:	68 22 86 10 80       	push   $0x80108622
801033b8:	e8 d3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033bd:	83 ec 0c             	sub    $0xc,%esp
801033c0:	68 3c 86 10 80       	push   $0x8010863c
801033c5:	e8 c6 cf ff ff       	call   80100390 <panic>
801033ca:	66 90                	xchg   %ax,%ax
801033cc:	66 90                	xchg   %ax,%ax
801033ce:	66 90                	xchg   %ax,%ax

801033d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033d0:	f3 0f 1e fb          	endbr32 
801033d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033d9:	ba 21 00 00 00       	mov    $0x21,%edx
801033de:	ee                   	out    %al,(%dx)
801033df:	ba a1 00 00 00       	mov    $0xa1,%edx
801033e4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033e5:	c3                   	ret    
801033e6:	66 90                	xchg   %ax,%ax
801033e8:	66 90                	xchg   %ax,%ax
801033ea:	66 90                	xchg   %ax,%ax
801033ec:	66 90                	xchg   %ax,%ax
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033f0:	f3 0f 1e fb          	endbr32 
801033f4:	55                   	push   %ebp
801033f5:	89 e5                	mov    %esp,%ebp
801033f7:	57                   	push   %edi
801033f8:	56                   	push   %esi
801033f9:	53                   	push   %ebx
801033fa:	83 ec 0c             	sub    $0xc,%esp
801033fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103400:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103403:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103409:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010340f:	e8 ec d9 ff ff       	call   80100e00 <filealloc>
80103414:	89 03                	mov    %eax,(%ebx)
80103416:	85 c0                	test   %eax,%eax
80103418:	0f 84 ac 00 00 00    	je     801034ca <pipealloc+0xda>
8010341e:	e8 dd d9 ff ff       	call   80100e00 <filealloc>
80103423:	89 06                	mov    %eax,(%esi)
80103425:	85 c0                	test   %eax,%eax
80103427:	0f 84 8b 00 00 00    	je     801034b8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010342d:	e8 fe f1 ff ff       	call   80102630 <kalloc>
80103432:	89 c7                	mov    %eax,%edi
80103434:	85 c0                	test   %eax,%eax
80103436:	0f 84 b4 00 00 00    	je     801034f0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010343c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103443:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103446:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103449:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103450:	00 00 00 
  p->nwrite = 0;
80103453:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010345a:	00 00 00 
  p->nread = 0;
8010345d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103464:	00 00 00 
  initlock(&p->lock, "pipe");
80103467:	68 5b 86 10 80       	push   $0x8010865b
8010346c:	50                   	push   %eax
8010346d:	e8 ae 19 00 00       	call   80104e20 <initlock>
  (*f0)->type = FD_PIPE;
80103472:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103474:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103477:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010347d:	8b 03                	mov    (%ebx),%eax
8010347f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103483:	8b 03                	mov    (%ebx),%eax
80103485:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103489:	8b 03                	mov    (%ebx),%eax
8010348b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010348e:	8b 06                	mov    (%esi),%eax
80103490:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103496:	8b 06                	mov    (%esi),%eax
80103498:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010349c:	8b 06                	mov    (%esi),%eax
8010349e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034a2:	8b 06                	mov    (%esi),%eax
801034a4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034aa:	31 c0                	xor    %eax,%eax
}
801034ac:	5b                   	pop    %ebx
801034ad:	5e                   	pop    %esi
801034ae:	5f                   	pop    %edi
801034af:	5d                   	pop    %ebp
801034b0:	c3                   	ret    
801034b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034b8:	8b 03                	mov    (%ebx),%eax
801034ba:	85 c0                	test   %eax,%eax
801034bc:	74 1e                	je     801034dc <pipealloc+0xec>
    fileclose(*f0);
801034be:	83 ec 0c             	sub    $0xc,%esp
801034c1:	50                   	push   %eax
801034c2:	e8 f9 d9 ff ff       	call   80100ec0 <fileclose>
801034c7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 0c                	je     801034dc <pipealloc+0xec>
    fileclose(*f1);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	50                   	push   %eax
801034d4:	e8 e7 d9 ff ff       	call   80100ec0 <fileclose>
801034d9:	83 c4 10             	add    $0x10,%esp
}
801034dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034e4:	5b                   	pop    %ebx
801034e5:	5e                   	pop    %esi
801034e6:	5f                   	pop    %edi
801034e7:	5d                   	pop    %ebp
801034e8:	c3                   	ret    
801034e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	75 c8                	jne    801034be <pipealloc+0xce>
801034f6:	eb d2                	jmp    801034ca <pipealloc+0xda>
801034f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ff:	90                   	nop

80103500 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103500:	f3 0f 1e fb          	endbr32 
80103504:	55                   	push   %ebp
80103505:	89 e5                	mov    %esp,%ebp
80103507:	56                   	push   %esi
80103508:	53                   	push   %ebx
80103509:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010350c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010350f:	83 ec 0c             	sub    $0xc,%esp
80103512:	53                   	push   %ebx
80103513:	e8 88 1a 00 00       	call   80104fa0 <acquire>
  if(writable){
80103518:	83 c4 10             	add    $0x10,%esp
8010351b:	85 f6                	test   %esi,%esi
8010351d:	74 41                	je     80103560 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103528:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010352f:	00 00 00 
    wakeup(&p->nread);
80103532:	50                   	push   %eax
80103533:	e8 78 15 00 00       	call   80104ab0 <wakeup>
80103538:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010353b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103541:	85 d2                	test   %edx,%edx
80103543:	75 0a                	jne    8010354f <pipeclose+0x4f>
80103545:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010354b:	85 c0                	test   %eax,%eax
8010354d:	74 31                	je     80103580 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010354f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103552:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103555:	5b                   	pop    %ebx
80103556:	5e                   	pop    %esi
80103557:	5d                   	pop    %ebp
    release(&p->lock);
80103558:	e9 03 1b 00 00       	jmp    80105060 <release>
8010355d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103569:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103570:	00 00 00 
    wakeup(&p->nwrite);
80103573:	50                   	push   %eax
80103574:	e8 37 15 00 00       	call   80104ab0 <wakeup>
80103579:	83 c4 10             	add    $0x10,%esp
8010357c:	eb bd                	jmp    8010353b <pipeclose+0x3b>
8010357e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	53                   	push   %ebx
80103584:	e8 d7 1a 00 00       	call   80105060 <release>
    kfree((char*)p);
80103589:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010358c:	83 c4 10             	add    $0x10,%esp
}
8010358f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103592:	5b                   	pop    %ebx
80103593:	5e                   	pop    %esi
80103594:	5d                   	pop    %ebp
    kfree((char*)p);
80103595:	e9 d6 ee ff ff       	jmp    80102470 <kfree>
8010359a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035a0:	f3 0f 1e fb          	endbr32 
801035a4:	55                   	push   %ebp
801035a5:	89 e5                	mov    %esp,%ebp
801035a7:	57                   	push   %edi
801035a8:	56                   	push   %esi
801035a9:	53                   	push   %ebx
801035aa:	83 ec 28             	sub    $0x28,%esp
801035ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035b0:	53                   	push   %ebx
801035b1:	e8 ea 19 00 00       	call   80104fa0 <acquire>
  for(i = 0; i < n; i++){
801035b6:	8b 45 10             	mov    0x10(%ebp),%eax
801035b9:	83 c4 10             	add    $0x10,%esp
801035bc:	85 c0                	test   %eax,%eax
801035be:	0f 8e bc 00 00 00    	jle    80103680 <pipewrite+0xe0>
801035c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035c7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035cd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035d6:	03 45 10             	add    0x10(%ebp),%eax
801035d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035dc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035e2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035e8:	89 ca                	mov    %ecx,%edx
801035ea:	05 00 02 00 00       	add    $0x200,%eax
801035ef:	39 c1                	cmp    %eax,%ecx
801035f1:	74 3b                	je     8010362e <pipewrite+0x8e>
801035f3:	eb 63                	jmp    80103658 <pipewrite+0xb8>
801035f5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
801035f8:	e8 f3 04 00 00       	call   80103af0 <myproc>
801035fd:	8b 48 30             	mov    0x30(%eax),%ecx
80103600:	85 c9                	test   %ecx,%ecx
80103602:	75 34                	jne    80103638 <pipewrite+0x98>
      wakeup(&p->nread);
80103604:	83 ec 0c             	sub    $0xc,%esp
80103607:	57                   	push   %edi
80103608:	e8 a3 14 00 00       	call   80104ab0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360d:	58                   	pop    %eax
8010360e:	5a                   	pop    %edx
8010360f:	53                   	push   %ebx
80103610:	56                   	push   %esi
80103611:	e8 da 12 00 00       	call   801048f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103616:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010361c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103622:	83 c4 10             	add    $0x10,%esp
80103625:	05 00 02 00 00       	add    $0x200,%eax
8010362a:	39 c2                	cmp    %eax,%edx
8010362c:	75 2a                	jne    80103658 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010362e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103634:	85 c0                	test   %eax,%eax
80103636:	75 c0                	jne    801035f8 <pipewrite+0x58>
        release(&p->lock);
80103638:	83 ec 0c             	sub    $0xc,%esp
8010363b:	53                   	push   %ebx
8010363c:	e8 1f 1a 00 00       	call   80105060 <release>
        return -1;
80103641:	83 c4 10             	add    $0x10,%esp
80103644:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103649:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010364c:	5b                   	pop    %ebx
8010364d:	5e                   	pop    %esi
8010364e:	5f                   	pop    %edi
8010364f:	5d                   	pop    %ebp
80103650:	c3                   	ret    
80103651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103658:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010365b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010365e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103664:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010366a:	0f b6 06             	movzbl (%esi),%eax
8010366d:	83 c6 01             	add    $0x1,%esi
80103670:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103673:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103677:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010367a:	0f 85 5c ff ff ff    	jne    801035dc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103680:	83 ec 0c             	sub    $0xc,%esp
80103683:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103689:	50                   	push   %eax
8010368a:	e8 21 14 00 00       	call   80104ab0 <wakeup>
  release(&p->lock);
8010368f:	89 1c 24             	mov    %ebx,(%esp)
80103692:	e8 c9 19 00 00       	call   80105060 <release>
  return n;
80103697:	8b 45 10             	mov    0x10(%ebp),%eax
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	eb aa                	jmp    80103649 <pipewrite+0xa9>
8010369f:	90                   	nop

801036a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036a0:	f3 0f 1e fb          	endbr32 
801036a4:	55                   	push   %ebp
801036a5:	89 e5                	mov    %esp,%ebp
801036a7:	57                   	push   %edi
801036a8:	56                   	push   %esi
801036a9:	53                   	push   %ebx
801036aa:	83 ec 18             	sub    $0x18,%esp
801036ad:	8b 75 08             	mov    0x8(%ebp),%esi
801036b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036b3:	56                   	push   %esi
801036b4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ba:	e8 e1 18 00 00       	call   80104fa0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036bf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036c5:	83 c4 10             	add    $0x10,%esp
801036c8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036ce:	74 33                	je     80103703 <piperead+0x63>
801036d0:	eb 3b                	jmp    8010370d <piperead+0x6d>
801036d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036d8:	e8 13 04 00 00       	call   80103af0 <myproc>
801036dd:	8b 48 30             	mov    0x30(%eax),%ecx
801036e0:	85 c9                	test   %ecx,%ecx
801036e2:	0f 85 88 00 00 00    	jne    80103770 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036e8:	83 ec 08             	sub    $0x8,%esp
801036eb:	56                   	push   %esi
801036ec:	53                   	push   %ebx
801036ed:	e8 fe 11 00 00       	call   801048f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036f2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801036f8:	83 c4 10             	add    $0x10,%esp
801036fb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103701:	75 0a                	jne    8010370d <piperead+0x6d>
80103703:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103709:	85 c0                	test   %eax,%eax
8010370b:	75 cb                	jne    801036d8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010370d:	8b 55 10             	mov    0x10(%ebp),%edx
80103710:	31 db                	xor    %ebx,%ebx
80103712:	85 d2                	test   %edx,%edx
80103714:	7f 28                	jg     8010373e <piperead+0x9e>
80103716:	eb 34                	jmp    8010374c <piperead+0xac>
80103718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010371f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103720:	8d 48 01             	lea    0x1(%eax),%ecx
80103723:	25 ff 01 00 00       	and    $0x1ff,%eax
80103728:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010372e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103733:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103736:	83 c3 01             	add    $0x1,%ebx
80103739:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010373c:	74 0e                	je     8010374c <piperead+0xac>
    if(p->nread == p->nwrite)
8010373e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103744:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010374a:	75 d4                	jne    80103720 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010374c:	83 ec 0c             	sub    $0xc,%esp
8010374f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103755:	50                   	push   %eax
80103756:	e8 55 13 00 00       	call   80104ab0 <wakeup>
  release(&p->lock);
8010375b:	89 34 24             	mov    %esi,(%esp)
8010375e:	e8 fd 18 00 00       	call   80105060 <release>
  return i;
80103763:	83 c4 10             	add    $0x10,%esp
}
80103766:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103769:	89 d8                	mov    %ebx,%eax
8010376b:	5b                   	pop    %ebx
8010376c:	5e                   	pop    %esi
8010376d:	5f                   	pop    %edi
8010376e:	5d                   	pop    %ebp
8010376f:	c3                   	ret    
      release(&p->lock);
80103770:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103773:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103778:	56                   	push   %esi
80103779:	e8 e2 18 00 00       	call   80105060 <release>
      return -1;
8010377e:	83 c4 10             	add    $0x10,%esp
}
80103781:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103784:	89 d8                	mov    %ebx,%eax
80103786:	5b                   	pop    %ebx
80103787:	5e                   	pop    %esi
80103788:	5f                   	pop    %edi
80103789:	5d                   	pop    %ebp
8010378a:	c3                   	ret    
8010378b:	66 90                	xchg   %ax,%ax
8010378d:	66 90                	xchg   %ax,%ax
8010378f:	90                   	nop

80103790 <allocproc>:
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *
allocproc(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103794:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
80103799:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010379c:	68 20 3d 11 80       	push   $0x80113d20
801037a1:	e8 fa 17 00 00       	call   80104fa0 <acquire>
801037a6:	83 c4 10             	add    $0x10,%esp
801037a9:	eb 17                	jmp    801037c2 <allocproc+0x32>
801037ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037af:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b0:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
801037b6:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
801037bc:	0f 84 b6 00 00 00    	je     80103878 <allocproc+0xe8>
    if (p->state == UNUSED)
801037c2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037c5:	85 c0                	test   %eax,%eax
801037c7:	75 e7                	jne    801037b0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037c9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->que_id = LCFS;
  if(p->pid == 2)
    p->que_id = RR;
  p->priority = PRIORITY_DEF;
  p->priority_ratio = 1.0f;
801037ce:	d9 e8                	fld1   
  p->state = EMBRYO;
801037d0:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority_ratio = 1.0f;
801037d7:	d9 93 8c 00 00 00    	fsts   0x8c(%ebx)
  p->que_id = LCFS;
801037dd:	83 f8 02             	cmp    $0x2,%eax
  p->pid = nextpid++;
801037e0:	8d 50 01             	lea    0x1(%eax),%edx
801037e3:	89 43 10             	mov    %eax,0x10(%ebx)
  p->que_id = LCFS;
801037e6:	0f 95 c0             	setne  %al
  p->creation_time_ratio = 1.0f;
801037e9:	d9 93 90 00 00 00    	fsts   0x90(%ebx)
  p->executed_cycle = 0.1f;
  p->executed_cycle_ratio = 1.0f;
  p->process_size_ratio = 1.0f;
  release(&ptable.lock);
801037ef:	83 ec 0c             	sub    $0xc,%esp
  p->que_id = LCFS;
801037f2:	0f b6 c0             	movzbl %al,%eax
  p->executed_cycle_ratio = 1.0f;
801037f5:	d9 93 98 00 00 00    	fsts   0x98(%ebx)
  p->que_id = LCFS;
801037fb:	83 c0 01             	add    $0x1,%eax
  p->process_size_ratio = 1.0f;
801037fe:	d9 9b 9c 00 00 00    	fstps  0x9c(%ebx)
  p->que_id = LCFS;
80103804:	89 43 28             	mov    %eax,0x28(%ebx)
  p->priority = PRIORITY_DEF;
80103807:	c7 83 88 00 00 00 03 	movl   $0x3,0x88(%ebx)
8010380e:	00 00 00 
  p->executed_cycle = 0.1f;
80103811:	c7 83 94 00 00 00 cd 	movl   $0x3dcccccd,0x94(%ebx)
80103818:	cc cc 3d 
  release(&ptable.lock);
8010381b:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
80103820:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103826:	e8 35 18 00 00       	call   80105060 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
8010382b:	e8 00 ee ff ff       	call   80102630 <kalloc>
80103830:	83 c4 10             	add    $0x10,%esp
80103833:	89 43 08             	mov    %eax,0x8(%ebx)
80103836:	85 c0                	test   %eax,%eax
80103838:	74 57                	je     80103891 <allocproc+0x101>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010383a:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
80103840:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103843:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103848:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
8010384b:	c7 40 14 ab 68 10 80 	movl   $0x801068ab,0x14(%eax)
  p->context = (struct context *)sp;
80103852:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103855:	6a 14                	push   $0x14
80103857:	6a 00                	push   $0x0
80103859:	50                   	push   %eax
8010385a:	e8 51 18 00 00       	call   801050b0 <memset>
  p->context->eip = (uint)forkret;
8010385f:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103862:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103865:	c7 40 10 b0 38 10 80 	movl   $0x801038b0,0x10(%eax)
}
8010386c:	89 d8                	mov    %ebx,%eax
8010386e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103871:	c9                   	leave  
80103872:	c3                   	ret    
80103873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103877:	90                   	nop
  release(&ptable.lock);
80103878:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010387b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010387d:	68 20 3d 11 80       	push   $0x80113d20
80103882:	e8 d9 17 00 00       	call   80105060 <release>
}
80103887:	89 d8                	mov    %ebx,%eax
  return 0;
80103889:	83 c4 10             	add    $0x10,%esp
}
8010388c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010388f:	c9                   	leave  
80103890:	c3                   	ret    
    p->state = UNUSED;
80103891:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103898:	31 db                	xor    %ebx,%ebx
}
8010389a:	89 d8                	mov    %ebx,%eax
8010389c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010389f:	c9                   	leave  
801038a0:	c3                   	ret    
801038a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038af:	90                   	nop

801038b0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
801038b0:	f3 0f 1e fb          	endbr32 
801038b4:	55                   	push   %ebp
801038b5:	89 e5                	mov    %esp,%ebp
801038b7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038ba:	68 20 3d 11 80       	push   $0x80113d20
801038bf:	e8 9c 17 00 00       	call   80105060 <release>

  if (first)
801038c4:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038c9:	83 c4 10             	add    $0x10,%esp
801038cc:	85 c0                	test   %eax,%eax
801038ce:	75 08                	jne    801038d8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038d0:	c9                   	leave  
801038d1:	c3                   	ret    
801038d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801038d8:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038df:	00 00 00 
    iinit(ROOTDEV);
801038e2:	83 ec 0c             	sub    $0xc,%esp
801038e5:	6a 01                	push   $0x1
801038e7:	e8 54 dc ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
801038ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038f3:	e8 98 f3 ff ff       	call   80102c90 <initlog>
}
801038f8:	83 c4 10             	add    $0x10,%esp
801038fb:	c9                   	leave  
801038fc:	c3                   	ret    
801038fd:	8d 76 00             	lea    0x0(%esi),%esi

80103900 <pinit>:
{
80103900:	f3 0f 1e fb          	endbr32 
80103904:	55                   	push   %ebp
80103905:	89 e5                	mov    %esp,%ebp
80103907:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010390a:	68 60 86 10 80       	push   $0x80108660
8010390f:	68 20 3d 11 80       	push   $0x80113d20
80103914:	e8 07 15 00 00       	call   80104e20 <initlock>
}
80103919:	83 c4 10             	add    $0x10,%esp
8010391c:	c9                   	leave  
8010391d:	c3                   	ret    
8010391e:	66 90                	xchg   %ax,%ax

80103920 <calculate_rank>:
{
80103920:	f3 0f 1e fb          	endbr32 
80103924:	55                   	push   %ebp
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80103925:	31 c9                	xor    %ecx,%ecx
{
80103927:	89 e5                	mov    %esp,%ebp
80103929:	83 ec 08             	sub    $0x8,%esp
8010392c:	8b 45 08             	mov    0x8(%ebp),%eax
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
8010392f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80103932:	db 80 88 00 00 00    	fildl  0x88(%eax)
80103938:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
8010393e:	db 40 20             	fildl  0x20(%eax)
80103941:	d8 88 90 00 00 00    	fmuls  0x90(%eax)
80103947:	8b 10                	mov    (%eax),%edx
80103949:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010394c:	de c1                	faddp  %st,%st(1)
8010394e:	d9 80 94 00 00 00    	flds   0x94(%eax)
80103954:	d8 88 98 00 00 00    	fmuls  0x98(%eax)
8010395a:	de c1                	faddp  %st,%st(1)
8010395c:	df 6d f8             	fildll -0x8(%ebp)
8010395f:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
}
80103965:	c9                   	leave  
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80103966:	de c1                	faddp  %st,%st(1)
}
80103968:	c3                   	ret    
80103969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103970 <mycpu>:
{
80103970:	f3 0f 1e fb          	endbr32 
80103974:	55                   	push   %ebp
80103975:	89 e5                	mov    %esp,%ebp
80103977:	56                   	push   %esi
80103978:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103979:	9c                   	pushf  
8010397a:	58                   	pop    %eax
  if (readeflags() & FL_IF)
8010397b:	f6 c4 02             	test   $0x2,%ah
8010397e:	75 4a                	jne    801039ca <mycpu+0x5a>
  apicid = lapicid();
80103980:	e8 1b ef ff ff       	call   801028a0 <lapicid>
  for (i = 0; i < ncpu; ++i)
80103985:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
  apicid = lapicid();
8010398b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i)
8010398d:	85 f6                	test   %esi,%esi
8010398f:	7e 2c                	jle    801039bd <mycpu+0x4d>
80103991:	31 d2                	xor    %edx,%edx
80103993:	eb 0a                	jmp    8010399f <mycpu+0x2f>
80103995:	8d 76 00             	lea    0x0(%esi),%esi
80103998:	83 c2 01             	add    $0x1,%edx
8010399b:	39 f2                	cmp    %esi,%edx
8010399d:	74 1e                	je     801039bd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010399f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039a5:	0f b6 81 80 37 11 80 	movzbl -0x7feec880(%ecx),%eax
801039ac:	39 d8                	cmp    %ebx,%eax
801039ae:	75 e8                	jne    80103998 <mycpu+0x28>
}
801039b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039b3:	8d 81 80 37 11 80    	lea    -0x7feec880(%ecx),%eax
}
801039b9:	5b                   	pop    %ebx
801039ba:	5e                   	pop    %esi
801039bb:	5d                   	pop    %ebp
801039bc:	c3                   	ret    
  panic("unknown apicid\n");
801039bd:	83 ec 0c             	sub    $0xc,%esp
801039c0:	68 67 86 10 80       	push   $0x80108667
801039c5:	e8 c6 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801039ca:	83 ec 0c             	sub    $0xc,%esp
801039cd:	68 bc 87 10 80       	push   $0x801087bc
801039d2:	e8 b9 c9 ff ff       	call   80100390 <panic>
801039d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039de:	66 90                	xchg   %ax,%ax

801039e0 <cpuid>:
{
801039e0:	f3 0f 1e fb          	endbr32 
801039e4:	55                   	push   %ebp
801039e5:	89 e5                	mov    %esp,%ebp
801039e7:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
801039ea:	e8 81 ff ff ff       	call   80103970 <mycpu>
}
801039ef:	c9                   	leave  
  return mycpu() - cpus;
801039f0:	2d 80 37 11 80       	sub    $0x80113780,%eax
801039f5:	c1 f8 04             	sar    $0x4,%eax
801039f8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039fe:	c3                   	ret    
801039ff:	90                   	nop

80103a00 <aging>:
{
80103a00:	f3 0f 1e fb          	endbr32 
  time = ticks;
80103a04:	8b 0d a0 6d 11 80    	mov    0x80116da0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a0a:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103a0f:	eb 13                	jmp    80103a24 <aging+0x24>
80103a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a18:	05 a0 00 00 00       	add    $0xa0,%eax
80103a1d:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80103a22:	74 2c                	je     80103a50 <aging+0x50>
    if (p->state == RUNNABLE && p->que_id != RR)
80103a24:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103a28:	75 ee                	jne    80103a18 <aging+0x18>
80103a2a:	83 78 28 01          	cmpl   $0x1,0x28(%eax)
80103a2e:	74 e8                	je     80103a18 <aging+0x18>
      if (time - p->preemption_time > AGING_THRS)
80103a30:	89 ca                	mov    %ecx,%edx
80103a32:	2b 50 24             	sub    0x24(%eax),%edx
80103a35:	81 fa 40 1f 00 00    	cmp    $0x1f40,%edx
80103a3b:	7e db                	jle    80103a18 <aging+0x18>
        p->que_id = RR;
80103a3d:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a44:	05 a0 00 00 00       	add    $0xa0,%eax
80103a49:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80103a4e:	75 d4                	jne    80103a24 <aging+0x24>
}
80103a50:	c3                   	ret    
80103a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a5f:	90                   	nop

80103a60 <reset_bjf_attributes>:
{
80103a60:	f3 0f 1e fb          	endbr32 
80103a64:	55                   	push   %ebp
80103a65:	89 e5                	mov    %esp,%ebp
80103a67:	83 ec 24             	sub    $0x24,%esp
80103a6a:	d9 45 08             	flds   0x8(%ebp)
  acquire(&ptable.lock);
80103a6d:	68 20 3d 11 80       	push   $0x80113d20
{
80103a72:	d9 5d e8             	fstps  -0x18(%ebp)
80103a75:	d9 45 0c             	flds   0xc(%ebp)
80103a78:	d9 5d ec             	fstps  -0x14(%ebp)
80103a7b:	d9 45 10             	flds   0x10(%ebp)
80103a7e:	d9 5d f0             	fstps  -0x10(%ebp)
80103a81:	d9 45 14             	flds   0x14(%ebp)
80103a84:	d9 5d f4             	fstps  -0xc(%ebp)
  acquire(&ptable.lock);
80103a87:	e8 14 15 00 00       	call   80104fa0 <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a8c:	d9 45 e8             	flds   -0x18(%ebp)
80103a8f:	d9 45 ec             	flds   -0x14(%ebp)
  acquire(&ptable.lock);
80103a92:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a95:	d9 45 f0             	flds   -0x10(%ebp)
80103a98:	d9 45 f4             	flds   -0xc(%ebp)
80103a9b:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
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
80103aeb:	e9 70 15 00 00       	jmp    80105060 <release>

80103af0 <myproc>:
{
80103af0:	f3 0f 1e fb          	endbr32 
80103af4:	55                   	push   %ebp
80103af5:	89 e5                	mov    %esp,%ebp
80103af7:	53                   	push   %ebx
80103af8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103afb:	e8 a0 13 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
80103b00:	e8 6b fe ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103b05:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b0b:	e8 e0 13 00 00       	call   80104ef0 <popcli>
}
80103b10:	83 c4 04             	add    $0x4,%esp
80103b13:	89 d8                	mov    %ebx,%eax
80103b15:	5b                   	pop    %ebx
80103b16:	5d                   	pop    %ebp
80103b17:	c3                   	ret    
80103b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop

80103b20 <how_many_digit>:
{
80103b20:	f3 0f 1e fb          	endbr32 
80103b24:	55                   	push   %ebp
80103b25:	89 e5                	mov    %esp,%ebp
80103b27:	56                   	push   %esi
80103b28:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103b2b:	53                   	push   %ebx
80103b2c:	bb 01 00 00 00       	mov    $0x1,%ebx
  if (num == 0)
80103b31:	85 c9                	test   %ecx,%ecx
80103b33:	74 1e                	je     80103b53 <how_many_digit+0x33>
  int count = 0;
80103b35:	31 db                	xor    %ebx,%ebx
    num /= 10;
80103b37:	be 67 66 66 66       	mov    $0x66666667,%esi
80103b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b40:	89 c8                	mov    %ecx,%eax
80103b42:	c1 f9 1f             	sar    $0x1f,%ecx
    count++;
80103b45:	83 c3 01             	add    $0x1,%ebx
    num /= 10;
80103b48:	f7 ee                	imul   %esi
80103b4a:	c1 fa 02             	sar    $0x2,%edx
  while (num != 0)
80103b4d:	29 ca                	sub    %ecx,%edx
80103b4f:	89 d1                	mov    %edx,%ecx
80103b51:	75 ed                	jne    80103b40 <how_many_digit+0x20>
}
80103b53:	89 d8                	mov    %ebx,%eax
80103b55:	5b                   	pop    %ebx
80103b56:	5e                   	pop    %esi
80103b57:	5d                   	pop    %ebp
80103b58:	c3                   	ret    
80103b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b60 <userinit>:
{
80103b60:	f3 0f 1e fb          	endbr32 
80103b64:	55                   	push   %ebp
80103b65:	89 e5                	mov    %esp,%ebp
80103b67:	53                   	push   %ebx
80103b68:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b6b:	e8 20 fc ff ff       	call   80103790 <allocproc>
80103b70:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b72:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if ((p->pgdir = setupkvm()) == 0)
80103b77:	e8 04 43 00 00       	call   80107e80 <setupkvm>
80103b7c:	89 43 04             	mov    %eax,0x4(%ebx)
80103b7f:	85 c0                	test   %eax,%eax
80103b81:	0f 84 c4 00 00 00    	je     80103c4b <userinit+0xeb>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b87:	83 ec 04             	sub    $0x4,%esp
80103b8a:	68 2c 00 00 00       	push   $0x2c
80103b8f:	68 60 b4 10 80       	push   $0x8010b460
80103b94:	50                   	push   %eax
80103b95:	e8 b6 3f 00 00       	call   80107b50 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b9a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b9d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103ba3:	6a 4c                	push   $0x4c
80103ba5:	6a 00                	push   $0x0
80103ba7:	ff 73 18             	pushl  0x18(%ebx)
80103baa:	e8 01 15 00 00       	call   801050b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103baf:	8b 43 18             	mov    0x18(%ebx),%eax
80103bb2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bb7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bba:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bbf:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bc3:	8b 43 18             	mov    0x18(%ebx),%eax
80103bc6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bca:	8b 43 18             	mov    0x18(%ebx),%eax
80103bcd:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bd1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bd5:	8b 43 18             	mov    0x18(%ebx),%eax
80103bd8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bdc:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103be0:	8b 43 18             	mov    0x18(%ebx),%eax
80103be3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103bea:	8b 43 18             	mov    0x18(%ebx),%eax
80103bed:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103bf4:	8b 43 18             	mov    0x18(%ebx),%eax
80103bf7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bfe:	8d 43 78             	lea    0x78(%ebx),%eax
80103c01:	6a 10                	push   $0x10
80103c03:	68 90 86 10 80       	push   $0x80108690
80103c08:	50                   	push   %eax
80103c09:	e8 62 16 00 00       	call   80105270 <safestrcpy>
  p->cwd = namei("/");
80103c0e:	c7 04 24 99 86 10 80 	movl   $0x80108699,(%esp)
80103c15:	e8 16 e4 ff ff       	call   80102030 <namei>
80103c1a:	89 43 74             	mov    %eax,0x74(%ebx)
  acquire(&ptable.lock);
80103c1d:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c24:	e8 77 13 00 00       	call   80104fa0 <acquire>
  p->state = RUNNABLE;
80103c29:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->que_id = RR;
80103c30:	c7 43 28 01 00 00 00 	movl   $0x1,0x28(%ebx)
  release(&ptable.lock);
80103c37:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c3e:	e8 1d 14 00 00       	call   80105060 <release>
}
80103c43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c46:	83 c4 10             	add    $0x10,%esp
80103c49:	c9                   	leave  
80103c4a:	c3                   	ret    
    panic("userinit: out of memory?");
80103c4b:	83 ec 0c             	sub    $0xc,%esp
80103c4e:	68 77 86 10 80       	push   $0x80108677
80103c53:	e8 38 c7 ff ff       	call   80100390 <panic>
80103c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c5f:	90                   	nop

80103c60 <print_name>:
{
80103c60:	f3 0f 1e fb          	endbr32 
80103c64:	55                   	push   %ebp
80103c65:	89 e5                	mov    %esp,%ebp
80103c67:	57                   	push   %edi
80103c68:	56                   	push   %esi
  memset(buf, ' ', 12);
80103c69:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80103c6c:	53                   	push   %ebx
  for (int i = 0; i < strlen(name); i++)
80103c6d:	31 db                	xor    %ebx,%ebx
{
80103c6f:	83 ec 20             	sub    $0x20,%esp
80103c72:	8b 75 08             	mov    0x8(%ebp),%esi
  memset(buf, ' ', 12);
80103c75:	6a 0c                	push   $0xc
80103c77:	6a 20                	push   $0x20
80103c79:	57                   	push   %edi
80103c7a:	e8 31 14 00 00       	call   801050b0 <memset>
  buf[13] = 0;
80103c7f:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for (int i = 0; i < strlen(name); i++)
80103c83:	83 c4 10             	add    $0x10,%esp
80103c86:	eb 12                	jmp    80103c9a <print_name+0x3a>
80103c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c8f:	90                   	nop
    buf[i] = name[i];
80103c90:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80103c94:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for (int i = 0; i < strlen(name); i++)
80103c97:	83 c3 01             	add    $0x1,%ebx
80103c9a:	83 ec 0c             	sub    $0xc,%esp
80103c9d:	56                   	push   %esi
80103c9e:	e8 0d 16 00 00       	call   801052b0 <strlen>
80103ca3:	83 c4 10             	add    $0x10,%esp
80103ca6:	39 d8                	cmp    %ebx,%eax
80103ca8:	7f e6                	jg     80103c90 <print_name+0x30>
  cprintf("%s", buf);
80103caa:	83 ec 08             	sub    $0x8,%esp
80103cad:	57                   	push   %edi
80103cae:	68 8e 87 10 80       	push   $0x8010878e
80103cb3:	e8 f8 c9 ff ff       	call   801006b0 <cprintf>
}
80103cb8:	83 c4 10             	add    $0x10,%esp
80103cbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cbe:	5b                   	pop    %ebx
80103cbf:	5e                   	pop    %esi
80103cc0:	5f                   	pop    %edi
80103cc1:	5d                   	pop    %ebp
80103cc2:	c3                   	ret    
80103cc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103cd0 <find_proc>:
{
80103cd0:	f3 0f 1e fb          	endbr32 
80103cd4:	55                   	push   %ebp
80103cd5:	89 e5                	mov    %esp,%ebp
80103cd7:	56                   	push   %esi
80103cd8:	53                   	push   %ebx
80103cd9:	8b 75 08             	mov    0x8(%ebp),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cdc:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  acquire(&ptable.lock);
80103ce1:	83 ec 0c             	sub    $0xc,%esp
80103ce4:	68 20 3d 11 80       	push   $0x80113d20
80103ce9:	e8 b2 12 00 00       	call   80104fa0 <acquire>
80103cee:	83 c4 10             	add    $0x10,%esp
80103cf1:	eb 13                	jmp    80103d06 <find_proc+0x36>
80103cf3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cf7:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cf8:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103cfe:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103d04:	74 05                	je     80103d0b <find_proc+0x3b>
    if (p->pid == pid)
80103d06:	39 73 10             	cmp    %esi,0x10(%ebx)
80103d09:	75 ed                	jne    80103cf8 <find_proc+0x28>
  release(&ptable.lock);
80103d0b:	83 ec 0c             	sub    $0xc,%esp
80103d0e:	68 20 3d 11 80       	push   $0x80113d20
80103d13:	e8 48 13 00 00       	call   80105060 <release>
}
80103d18:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d1b:	89 d8                	mov    %ebx,%eax
80103d1d:	5b                   	pop    %ebx
80103d1e:	5e                   	pop    %esi
80103d1f:	5d                   	pop    %ebp
80103d20:	c3                   	ret    
80103d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d2f:	90                   	nop

80103d30 <print_state>:
{
80103d30:	f3 0f 1e fb          	endbr32 
80103d34:	55                   	push   %ebp
80103d35:	89 e5                	mov    %esp,%ebp
80103d37:	8b 45 08             	mov    0x8(%ebp),%eax
80103d3a:	83 f8 05             	cmp    $0x5,%eax
80103d3d:	77 6e                	ja     80103dad <print_state+0x7d>
80103d3f:	3e ff 24 85 38 88 10 	notrack jmp *-0x7fef77c8(,%eax,4)
80103d46:	80 
80103d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d4e:	66 90                	xchg   %ax,%ax
    cprintf("RUNNING   ");
80103d50:	c7 45 08 c7 86 10 80 	movl   $0x801086c7,0x8(%ebp)
}
80103d57:	5d                   	pop    %ebp
    cprintf("RUNNING   ");
80103d58:	e9 53 c9 ff ff       	jmp    801006b0 <cprintf>
80103d5d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("ZOMBIE    ");
80103d60:	c7 45 08 d2 86 10 80 	movl   $0x801086d2,0x8(%ebp)
}
80103d67:	5d                   	pop    %ebp
    cprintf("ZOMBIE    ");
80103d68:	e9 43 c9 ff ff       	jmp    801006b0 <cprintf>
80103d6d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("UNUSED    ");
80103d70:	c7 45 08 9b 86 10 80 	movl   $0x8010869b,0x8(%ebp)
}
80103d77:	5d                   	pop    %ebp
    cprintf("UNUSED    ");
80103d78:	e9 33 c9 ff ff       	jmp    801006b0 <cprintf>
80103d7d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("EMBRYO    ");
80103d80:	c7 45 08 a6 86 10 80 	movl   $0x801086a6,0x8(%ebp)
}
80103d87:	5d                   	pop    %ebp
    cprintf("EMBRYO    ");
80103d88:	e9 23 c9 ff ff       	jmp    801006b0 <cprintf>
80103d8d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("SLEEPING  ");
80103d90:	c7 45 08 b1 86 10 80 	movl   $0x801086b1,0x8(%ebp)
}
80103d97:	5d                   	pop    %ebp
    cprintf("SLEEPING  ");
80103d98:	e9 13 c9 ff ff       	jmp    801006b0 <cprintf>
80103d9d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("RUNNABLE  ");
80103da0:	c7 45 08 bc 86 10 80 	movl   $0x801086bc,0x8(%ebp)
}
80103da7:	5d                   	pop    %ebp
    cprintf("RUNNABLE  ");
80103da8:	e9 03 c9 ff ff       	jmp    801006b0 <cprintf>
    cprintf("damn ways to die");
80103dad:	c7 45 08 dd 86 10 80 	movl   $0x801086dd,0x8(%ebp)
}
80103db4:	5d                   	pop    %ebp
    cprintf("damn ways to die");
80103db5:	e9 f6 c8 ff ff       	jmp    801006b0 <cprintf>
80103dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103dc0 <print_space>:
{
80103dc0:	f3 0f 1e fb          	endbr32 
80103dc4:	55                   	push   %ebp
80103dc5:	89 e5                	mov    %esp,%ebp
80103dc7:	56                   	push   %esi
80103dc8:	8b 75 08             	mov    0x8(%ebp),%esi
80103dcb:	53                   	push   %ebx
  for (int i = 0; i < num; i++)
80103dcc:	85 f6                	test   %esi,%esi
80103dce:	7e 1f                	jle    80103def <print_space+0x2f>
80103dd0:	31 db                	xor    %ebx,%ebx
80103dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" ");
80103dd8:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < num; i++)
80103ddb:	83 c3 01             	add    $0x1,%ebx
    cprintf(" ");
80103dde:	68 03 87 10 80       	push   $0x80108703
80103de3:	e8 c8 c8 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < num; i++)
80103de8:	83 c4 10             	add    $0x10,%esp
80103deb:	39 de                	cmp    %ebx,%esi
80103ded:	75 e9                	jne    80103dd8 <print_space+0x18>
}
80103def:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103df2:	5b                   	pop    %ebx
80103df3:	5e                   	pop    %esi
80103df4:	5d                   	pop    %ebp
80103df5:	c3                   	ret    
80103df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dfd:	8d 76 00             	lea    0x0(%esi),%esi

80103e00 <print_bitches>:
{
80103e00:	f3 0f 1e fb          	endbr32 
80103e04:	55                   	push   %ebp
80103e05:	89 e5                	mov    %esp,%ebp
80103e07:	57                   	push   %edi
80103e08:	56                   	push   %esi
80103e09:	53                   	push   %ebx
  cprintf("process_name PID State   Queue Cycle Arrival Priority R_prty R_Arvl R_exec Rank\n");
80103e0a:	bb 50 00 00 00       	mov    $0x50,%ebx
{
80103e0f:	83 ec 28             	sub    $0x28,%esp
  acquire(&ptable.lock);
80103e12:	68 20 3d 11 80       	push   $0x80113d20
80103e17:	e8 84 11 00 00       	call   80104fa0 <acquire>
  cprintf("process_name PID State   Queue Cycle Arrival Priority R_prty R_Arvl R_exec Rank\n");
80103e1c:	c7 04 24 e4 87 10 80 	movl   $0x801087e4,(%esp)
80103e23:	e8 88 c8 ff ff       	call   801006b0 <cprintf>
80103e28:	83 c4 10             	add    $0x10,%esp
80103e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e2f:	90                   	nop
    cprintf("-");
80103e30:	83 ec 0c             	sub    $0xc,%esp
80103e33:	68 ee 86 10 80       	push   $0x801086ee
80103e38:	e8 73 c8 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < 80; i++)
80103e3d:	83 c4 10             	add    $0x10,%esp
80103e40:	83 eb 01             	sub    $0x1,%ebx
80103e43:	75 eb                	jne    80103e30 <print_bitches+0x30>
  cprintf("\n");
80103e45:	83 ec 0c             	sub    $0xc,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e48:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
    num /= 10;
80103e4d:	be 67 66 66 66       	mov    $0x66666667,%esi
  cprintf("\n");
80103e52:	68 cf 8b 10 80       	push   $0x80108bcf
80103e57:	e8 54 c8 ff ff       	call   801006b0 <cprintf>
80103e5c:	83 c4 10             	add    $0x10,%esp
80103e5f:	eb 19                	jmp    80103e7a <print_bitches+0x7a>
80103e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e68:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103e6e:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103e74:	0f 84 9b 02 00 00    	je     80104115 <print_bitches+0x315>
    if (p->state == UNUSED)
80103e7a:	8b 4b 0c             	mov    0xc(%ebx),%ecx
80103e7d:	85 c9                	test   %ecx,%ecx
80103e7f:	74 e7                	je     80103e68 <print_bitches+0x68>
    print_name(p->name);
80103e81:	83 ec 0c             	sub    $0xc,%esp
80103e84:	8d 43 78             	lea    0x78(%ebx),%eax
80103e87:	50                   	push   %eax
80103e88:	e8 d3 fd ff ff       	call   80103c60 <print_name>
    cprintf("%d", p->pid);
80103e8d:	58                   	pop    %eax
80103e8e:	5a                   	pop    %edx
80103e8f:	ff 73 10             	pushl  0x10(%ebx)
80103e92:	68 f0 86 10 80       	push   $0x801086f0
80103e97:	e8 14 c8 ff ff       	call   801006b0 <cprintf>
    print_space(4-(how_many_digit(p->pid)));
80103e9c:	8b 4b 10             	mov    0x10(%ebx),%ecx
  if (num == 0)
80103e9f:	83 c4 10             	add    $0x10,%esp
80103ea2:	85 c9                	test   %ecx,%ecx
80103ea4:	0f 84 a6 02 00 00    	je     80104150 <print_bitches+0x350>
  int count = 0;
80103eaa:	31 ff                	xor    %edi,%edi
80103eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    num /= 10;
80103eb0:	89 c8                	mov    %ecx,%eax
80103eb2:	c1 f9 1f             	sar    $0x1f,%ecx
    count++;
80103eb5:	83 c7 01             	add    $0x1,%edi
    num /= 10;
80103eb8:	f7 ee                	imul   %esi
80103eba:	c1 fa 02             	sar    $0x2,%edx
  while (num != 0)
80103ebd:	29 ca                	sub    %ecx,%edx
80103ebf:	89 d1                	mov    %edx,%ecx
80103ec1:	75 ed                	jne    80103eb0 <print_bitches+0xb0>
    print_space(4-(how_many_digit(p->pid)));
80103ec3:	b8 04 00 00 00       	mov    $0x4,%eax
80103ec8:	29 f8                	sub    %edi,%eax
80103eca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (int i = 0; i < num; i++)
80103ecd:	85 c0                	test   %eax,%eax
80103ecf:	7e 1f                	jle    80103ef0 <print_bitches+0xf0>
    print_space(4-(how_many_digit(p->pid)));
80103ed1:	31 ff                	xor    %edi,%edi
80103ed3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ed7:	90                   	nop
    cprintf(" ");
80103ed8:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < num; i++)
80103edb:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80103ede:	68 03 87 10 80       	push   $0x80108703
80103ee3:	e8 c8 c7 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < num; i++)
80103ee8:	83 c4 10             	add    $0x10,%esp
80103eeb:	39 7d d8             	cmp    %edi,-0x28(%ebp)
80103eee:	7f e8                	jg     80103ed8 <print_bitches+0xd8>
    print_state((*p).state);
80103ef0:	83 ec 0c             	sub    $0xc,%esp
80103ef3:	ff 73 0c             	pushl  0xc(%ebx)
80103ef6:	e8 35 fe ff ff       	call   80103d30 <print_state>
    cprintf("%d     ", p->que_id);
80103efb:	58                   	pop    %eax
80103efc:	5a                   	pop    %edx
80103efd:	ff 73 28             	pushl  0x28(%ebx)
80103f00:	68 f3 86 10 80       	push   $0x801086f3
80103f05:	e8 a6 c7 ff ff       	call   801006b0 <cprintf>
    cprintf("%d", (int)p->executed_cycle);
80103f0a:	d9 83 94 00 00 00    	flds   0x94(%ebx)
80103f10:	59                   	pop    %ecx
80103f11:	d9 7d e6             	fnstcw -0x1a(%ebp)
80103f14:	5f                   	pop    %edi
80103f15:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80103f19:	80 cc 0c             	or     $0xc,%ah
80103f1c:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80103f20:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103f23:	db 5d d8             	fistpl -0x28(%ebp)
80103f26:	d9 6d e6             	fldcw  -0x1a(%ebp)
80103f29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103f2c:	50                   	push   %eax
80103f2d:	68 f0 86 10 80       	push   $0x801086f0
80103f32:	e8 79 c7 ff ff       	call   801006b0 <cprintf>
    print_space(5-how_many_digit((int)p->executed_cycle));
80103f37:	d9 83 94 00 00 00    	flds   0x94(%ebx)
  if (num == 0)
80103f3d:	83 c4 10             	add    $0x10,%esp
    print_space(5-how_many_digit((int)p->executed_cycle));
80103f40:	d9 7d e6             	fnstcw -0x1a(%ebp)
80103f43:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80103f47:	80 cc 0c             	or     $0xc,%ah
80103f4a:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80103f4e:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103f51:	db 5d d8             	fistpl -0x28(%ebp)
80103f54:	d9 6d e6             	fldcw  -0x1a(%ebp)
80103f57:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  if (num == 0)
80103f5a:	85 c9                	test   %ecx,%ecx
80103f5c:	0f 84 de 01 00 00    	je     80104140 <print_bitches+0x340>
  int count = 0;
80103f62:	31 ff                	xor    %edi,%edi
80103f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    num /= 10;
80103f68:	89 c8                	mov    %ecx,%eax
80103f6a:	c1 f9 1f             	sar    $0x1f,%ecx
    count++;
80103f6d:	83 c7 01             	add    $0x1,%edi
    num /= 10;
80103f70:	f7 ee                	imul   %esi
80103f72:	c1 fa 02             	sar    $0x2,%edx
  while (num != 0)
80103f75:	29 ca                	sub    %ecx,%edx
80103f77:	89 d1                	mov    %edx,%ecx
80103f79:	75 ed                	jne    80103f68 <print_bitches+0x168>
    print_space(5-how_many_digit((int)p->executed_cycle));
80103f7b:	b8 05 00 00 00       	mov    $0x5,%eax
80103f80:	29 f8                	sub    %edi,%eax
80103f82:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (int i = 0; i < num; i++)
80103f85:	85 c0                	test   %eax,%eax
80103f87:	7e 1f                	jle    80103fa8 <print_bitches+0x1a8>
    print_space(5-how_many_digit((int)p->executed_cycle));
80103f89:	31 ff                	xor    %edi,%edi
80103f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f8f:	90                   	nop
    cprintf(" ");
80103f90:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < num; i++)
80103f93:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80103f96:	68 03 87 10 80       	push   $0x80108703
80103f9b:	e8 10 c7 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < num; i++)
80103fa0:	83 c4 10             	add    $0x10,%esp
80103fa3:	3b 7d d8             	cmp    -0x28(%ebp),%edi
80103fa6:	7c e8                	jl     80103f90 <print_bitches+0x190>
    cprintf("%d", p->creation_time);
80103fa8:	83 ec 08             	sub    $0x8,%esp
80103fab:	ff 73 20             	pushl  0x20(%ebx)
80103fae:	68 f0 86 10 80       	push   $0x801086f0
80103fb3:	e8 f8 c6 ff ff       	call   801006b0 <cprintf>
    print_space(10 - how_many_digit(p->creation_time));
80103fb8:	8b 4b 20             	mov    0x20(%ebx),%ecx
  if (num == 0)
80103fbb:	83 c4 10             	add    $0x10,%esp
80103fbe:	85 c9                	test   %ecx,%ecx
80103fc0:	0f 84 6a 01 00 00    	je     80104130 <print_bitches+0x330>
  int count = 0;
80103fc6:	31 ff                	xor    %edi,%edi
80103fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fcf:	90                   	nop
    num /= 10;
80103fd0:	89 c8                	mov    %ecx,%eax
80103fd2:	c1 f9 1f             	sar    $0x1f,%ecx
    count++;
80103fd5:	83 c7 01             	add    $0x1,%edi
    num /= 10;
80103fd8:	f7 ee                	imul   %esi
80103fda:	c1 fa 02             	sar    $0x2,%edx
  while (num != 0)
80103fdd:	29 ca                	sub    %ecx,%edx
80103fdf:	89 d1                	mov    %edx,%ecx
80103fe1:	75 ed                	jne    80103fd0 <print_bitches+0x1d0>
    print_space(10 - how_many_digit(p->creation_time));
80103fe3:	b8 0a 00 00 00       	mov    $0xa,%eax
80103fe8:	29 f8                	sub    %edi,%eax
80103fea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for (int i = 0; i < num; i++)
80103fed:	85 c0                	test   %eax,%eax
80103fef:	7e 1f                	jle    80104010 <print_bitches+0x210>
    print_space(10 - how_many_digit(p->creation_time));
80103ff1:	31 ff                	xor    %edi,%edi
80103ff3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ff7:	90                   	nop
    cprintf(" ");
80103ff8:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < num; i++)
80103ffb:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80103ffe:	68 03 87 10 80       	push   $0x80108703
80104003:	e8 a8 c6 ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < num; i++)
80104008:	83 c4 10             	add    $0x10,%esp
8010400b:	3b 7d d8             	cmp    -0x28(%ebp),%edi
8010400e:	7c e8                	jl     80103ff8 <print_bitches+0x1f8>
    cprintf("%d       ", p->priority);
80104010:	83 ec 08             	sub    $0x8,%esp
80104013:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104019:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
    cprintf("%d       ", p->priority);
8010401f:	68 fb 86 10 80       	push   $0x801086fb
80104024:	e8 87 c6 ff ff       	call   801006b0 <cprintf>
    cprintf("%d     ", (int)p->priority_ratio);
80104029:	d9 43 ec             	flds   -0x14(%ebx)
8010402c:	58                   	pop    %eax
8010402d:	d9 7d e6             	fnstcw -0x1a(%ebp)
80104030:	5a                   	pop    %edx
80104031:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80104035:	80 cc 0c             	or     $0xc,%ah
80104038:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
8010403c:	d9 6d e4             	fldcw  -0x1c(%ebp)
8010403f:	db 5d d8             	fistpl -0x28(%ebp)
80104042:	d9 6d e6             	fldcw  -0x1a(%ebp)
80104045:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104048:	50                   	push   %eax
80104049:	68 f3 86 10 80       	push   $0x801086f3
8010404e:	e8 5d c6 ff ff       	call   801006b0 <cprintf>
    cprintf("%d      ", (int)p->creation_time_ratio);
80104053:	d9 43 f0             	flds   -0x10(%ebx)
80104056:	59                   	pop    %ecx
80104057:	d9 7d e6             	fnstcw -0x1a(%ebp)
8010405a:	5f                   	pop    %edi
8010405b:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
8010405f:	80 cc 0c             	or     $0xc,%ah
80104062:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80104066:	d9 6d e4             	fldcw  -0x1c(%ebp)
80104069:	db 5d d8             	fistpl -0x28(%ebp)
8010406c:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010406f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104072:	50                   	push   %eax
80104073:	68 05 87 10 80       	push   $0x80108705
80104078:	e8 33 c6 ff ff       	call   801006b0 <cprintf>
    cprintf("%d   ", (int)p->executed_cycle_ratio);
8010407d:	d9 43 f8             	flds   -0x8(%ebx)
80104080:	58                   	pop    %eax
80104081:	d9 7d e6             	fnstcw -0x1a(%ebp)
80104084:	5a                   	pop    %edx
80104085:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80104089:	80 cc 0c             	or     $0xc,%ah
8010408c:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80104090:	d9 6d e4             	fldcw  -0x1c(%ebp)
80104093:	db 5d d8             	fistpl -0x28(%ebp)
80104096:	d9 6d e6             	fldcw  -0x1a(%ebp)
80104099:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010409c:	50                   	push   %eax
8010409d:	68 0e 87 10 80       	push   $0x8010870e
801040a2:	e8 09 c6 ff ff       	call   801006b0 <cprintf>
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
801040a7:	db 43 e8             	fildl  -0x18(%ebx)
801040aa:	d8 4b ec             	fmuls  -0x14(%ebx)
801040ad:	31 d2                	xor    %edx,%edx
801040af:	db 43 80             	fildl  -0x80(%ebx)
801040b2:	d8 4b f0             	fmuls  -0x10(%ebx)
801040b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
801040b8:	8b 83 60 ff ff ff    	mov    -0xa0(%ebx),%eax
    cprintf("%d", (int)rank);
801040be:	59                   	pop    %ecx
801040bf:	5f                   	pop    %edi
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
801040c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
801040c3:	de c1                	faddp  %st,%st(1)
801040c5:	d9 43 f4             	flds   -0xc(%ebx)
801040c8:	d8 4b f8             	fmuls  -0x8(%ebx)
801040cb:	de c1                	faddp  %st,%st(1)
801040cd:	df 6d d8             	fildll -0x28(%ebp)
801040d0:	d8 4b fc             	fmuls  -0x4(%ebx)
    cprintf("%d", (int)rank);
801040d3:	d9 7d e6             	fnstcw -0x1a(%ebp)
801040d6:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
801040da:	de c1                	faddp  %st,%st(1)
    cprintf("%d", (int)rank);
801040dc:	80 cc 0c             	or     $0xc,%ah
801040df:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
801040e3:	d9 6d e4             	fldcw  -0x1c(%ebp)
801040e6:	db 5d d8             	fistpl -0x28(%ebp)
801040e9:	d9 6d e6             	fldcw  -0x1a(%ebp)
801040ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
801040ef:	50                   	push   %eax
801040f0:	68 f0 86 10 80       	push   $0x801086f0
801040f5:	e8 b6 c5 ff ff       	call   801006b0 <cprintf>
    cprintf("\n");
801040fa:	c7 04 24 cf 8b 10 80 	movl   $0x80108bcf,(%esp)
80104101:	e8 aa c5 ff ff       	call   801006b0 <cprintf>
80104106:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104109:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
8010410f:	0f 85 65 fd ff ff    	jne    80103e7a <print_bitches+0x7a>
  release(&ptable.lock);
80104115:	83 ec 0c             	sub    $0xc,%esp
80104118:	68 20 3d 11 80       	push   $0x80113d20
8010411d:	e8 3e 0f 00 00       	call   80105060 <release>
}
80104122:	83 c4 10             	add    $0x10,%esp
80104125:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104128:	5b                   	pop    %ebx
80104129:	5e                   	pop    %esi
8010412a:	5f                   	pop    %edi
8010412b:	5d                   	pop    %ebp
8010412c:	c3                   	ret    
8010412d:	8d 76 00             	lea    0x0(%esi),%esi
    print_space(10 - how_many_digit(p->creation_time));
80104130:	c7 45 d8 09 00 00 00 	movl   $0x9,-0x28(%ebp)
80104137:	e9 b5 fe ff ff       	jmp    80103ff1 <print_bitches+0x1f1>
8010413c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    print_space(5-how_many_digit((int)p->executed_cycle));
80104140:	c7 45 d8 04 00 00 00 	movl   $0x4,-0x28(%ebp)
80104147:	e9 3d fe ff ff       	jmp    80103f89 <print_bitches+0x189>
8010414c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    print_space(4-(how_many_digit(p->pid)));
80104150:	c7 45 d8 03 00 00 00 	movl   $0x3,-0x28(%ebp)
80104157:	e9 75 fd ff ff       	jmp    80103ed1 <print_bitches+0xd1>
8010415c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104160 <count_child>:
{
80104160:	f3 0f 1e fb          	endbr32 
80104164:	55                   	push   %ebp
80104165:	89 e5                	mov    %esp,%ebp
80104167:	53                   	push   %ebx
  int count = 0;
80104168:	31 db                	xor    %ebx,%ebx
{
8010416a:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010416d:	68 20 3d 11 80       	push   $0x80113d20
80104172:	e8 29 0e 00 00       	call   80104fa0 <acquire>
    if (p->parent->pid == father->pid)
80104177:	8b 45 08             	mov    0x8(%ebp),%eax
8010417a:	83 c4 10             	add    $0x10,%esp
8010417d:	8b 48 10             	mov    0x10(%eax),%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104180:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104185:	8d 76 00             	lea    0x0(%esi),%esi
    if (p->parent->pid == father->pid)
80104188:	8b 50 14             	mov    0x14(%eax),%edx
      count++;
8010418b:	39 4a 10             	cmp    %ecx,0x10(%edx)
8010418e:	0f 94 c2             	sete   %dl
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104191:	05 a0 00 00 00       	add    $0xa0,%eax
      count++;
80104196:	0f b6 d2             	movzbl %dl,%edx
80104199:	01 d3                	add    %edx,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010419b:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801041a0:	75 e6                	jne    80104188 <count_child+0x28>
  release(&ptable.lock);
801041a2:	83 ec 0c             	sub    $0xc,%esp
801041a5:	68 20 3d 11 80       	push   $0x80113d20
801041aa:	e8 b1 0e 00 00       	call   80105060 <release>
}
801041af:	89 d8                	mov    %ebx,%eax
801041b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041b4:	c9                   	leave  
801041b5:	c3                   	ret    
801041b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041bd:	8d 76 00             	lea    0x0(%esi),%esi

801041c0 <growproc>:
{
801041c0:	f3 0f 1e fb          	endbr32 
801041c4:	55                   	push   %ebp
801041c5:	89 e5                	mov    %esp,%ebp
801041c7:	56                   	push   %esi
801041c8:	53                   	push   %ebx
801041c9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801041cc:	e8 cf 0c 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
801041d1:	e8 9a f7 ff ff       	call   80103970 <mycpu>
  p = c->proc;
801041d6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041dc:	e8 0f 0d 00 00       	call   80104ef0 <popcli>
  sz = curproc->sz;
801041e1:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
801041e3:	85 f6                	test   %esi,%esi
801041e5:	7f 19                	jg     80104200 <growproc+0x40>
  else if (n < 0)
801041e7:	75 37                	jne    80104220 <growproc+0x60>
  switchuvm(curproc);
801041e9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801041ec:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801041ee:	53                   	push   %ebx
801041ef:	e8 4c 38 00 00       	call   80107a40 <switchuvm>
  return 0;
801041f4:	83 c4 10             	add    $0x10,%esp
801041f7:	31 c0                	xor    %eax,%eax
}
801041f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041fc:	5b                   	pop    %ebx
801041fd:	5e                   	pop    %esi
801041fe:	5d                   	pop    %ebp
801041ff:	c3                   	ret    
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104200:	83 ec 04             	sub    $0x4,%esp
80104203:	01 c6                	add    %eax,%esi
80104205:	56                   	push   %esi
80104206:	50                   	push   %eax
80104207:	ff 73 04             	pushl  0x4(%ebx)
8010420a:	e8 91 3a 00 00       	call   80107ca0 <allocuvm>
8010420f:	83 c4 10             	add    $0x10,%esp
80104212:	85 c0                	test   %eax,%eax
80104214:	75 d3                	jne    801041e9 <growproc+0x29>
      return -1;
80104216:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010421b:	eb dc                	jmp    801041f9 <growproc+0x39>
8010421d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104220:	83 ec 04             	sub    $0x4,%esp
80104223:	01 c6                	add    %eax,%esi
80104225:	56                   	push   %esi
80104226:	50                   	push   %eax
80104227:	ff 73 04             	pushl  0x4(%ebx)
8010422a:	e8 a1 3b 00 00       	call   80107dd0 <deallocuvm>
8010422f:	83 c4 10             	add    $0x10,%esp
80104232:	85 c0                	test   %eax,%eax
80104234:	75 b3                	jne    801041e9 <growproc+0x29>
80104236:	eb de                	jmp    80104216 <growproc+0x56>
80104238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010423f:	90                   	nop

80104240 <fork>:
{
80104240:	f3 0f 1e fb          	endbr32 
80104244:	55                   	push   %ebp
80104245:	89 e5                	mov    %esp,%ebp
80104247:	57                   	push   %edi
80104248:	56                   	push   %esi
80104249:	53                   	push   %ebx
8010424a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010424d:	e8 4e 0c 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
80104252:	e8 19 f7 ff ff       	call   80103970 <mycpu>
  p = c->proc;
80104257:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010425d:	e8 8e 0c 00 00       	call   80104ef0 <popcli>
  if ((np = allocproc()) == 0)
80104262:	e8 29 f5 ff ff       	call   80103790 <allocproc>
80104267:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010426a:	85 c0                	test   %eax,%eax
8010426c:	0f 84 de 00 00 00    	je     80104350 <fork+0x110>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80104272:	83 ec 08             	sub    $0x8,%esp
80104275:	ff 33                	pushl  (%ebx)
80104277:	89 c7                	mov    %eax,%edi
80104279:	ff 73 04             	pushl  0x4(%ebx)
8010427c:	e8 cf 3c 00 00       	call   80107f50 <copyuvm>
80104281:	83 c4 10             	add    $0x10,%esp
80104284:	89 47 04             	mov    %eax,0x4(%edi)
80104287:	85 c0                	test   %eax,%eax
80104289:	0f 84 c8 00 00 00    	je     80104357 <fork+0x117>
  np->sz = curproc->sz;
8010428f:	8b 03                	mov    (%ebx),%eax
80104291:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104294:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104296:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104299:	89 c8                	mov    %ecx,%eax
8010429b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010429e:	b9 13 00 00 00       	mov    $0x13,%ecx
801042a3:	8b 73 18             	mov    0x18(%ebx),%esi
801042a6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
801042a8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801042aa:	8b 40 18             	mov    0x18(%eax),%eax
801042ad:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for (i = 0; i < NOFILE; i++)
801042b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[i])
801042b8:	8b 44 b3 34          	mov    0x34(%ebx,%esi,4),%eax
801042bc:	85 c0                	test   %eax,%eax
801042be:	74 13                	je     801042d3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
801042c0:	83 ec 0c             	sub    $0xc,%esp
801042c3:	50                   	push   %eax
801042c4:	e8 a7 cb ff ff       	call   80100e70 <filedup>
801042c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042cc:	83 c4 10             	add    $0x10,%esp
801042cf:	89 44 b2 34          	mov    %eax,0x34(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
801042d3:	83 c6 01             	add    $0x1,%esi
801042d6:	83 fe 10             	cmp    $0x10,%esi
801042d9:	75 dd                	jne    801042b8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
801042db:	83 ec 0c             	sub    $0xc,%esp
801042de:	ff 73 74             	pushl  0x74(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042e1:	83 c3 78             	add    $0x78,%ebx
  np->cwd = idup(curproc->cwd);
801042e4:	e8 47 d4 ff ff       	call   80101730 <idup>
801042e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042ec:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801042ef:	89 47 74             	mov    %eax,0x74(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042f2:	8d 47 78             	lea    0x78(%edi),%eax
801042f5:	6a 10                	push   $0x10
801042f7:	53                   	push   %ebx
801042f8:	50                   	push   %eax
801042f9:	e8 72 0f 00 00       	call   80105270 <safestrcpy>
  pid = np->pid;
801042fe:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104301:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104308:	e8 93 0c 00 00       	call   80104fa0 <acquire>
  np->state = RUNNABLE;
8010430d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  acquire(&tickslock);
80104314:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
8010431b:	e8 80 0c 00 00       	call   80104fa0 <acquire>
  np->creation_time = ticks;
80104320:	a1 a0 6d 11 80       	mov    0x80116da0,%eax
80104325:	89 47 20             	mov    %eax,0x20(%edi)
  np->preemption_time = ticks;
80104328:	89 47 24             	mov    %eax,0x24(%edi)
  release(&tickslock);
8010432b:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
80104332:	e8 29 0d 00 00       	call   80105060 <release>
  release(&ptable.lock);
80104337:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010433e:	e8 1d 0d 00 00       	call   80105060 <release>
  return pid;
80104343:	83 c4 10             	add    $0x10,%esp
}
80104346:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104349:	89 d8                	mov    %ebx,%eax
8010434b:	5b                   	pop    %ebx
8010434c:	5e                   	pop    %esi
8010434d:	5f                   	pop    %edi
8010434e:	5d                   	pop    %ebp
8010434f:	c3                   	ret    
    return -1;
80104350:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104355:	eb ef                	jmp    80104346 <fork+0x106>
    kfree(np->kstack);
80104357:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010435a:	83 ec 0c             	sub    $0xc,%esp
8010435d:	ff 73 08             	pushl  0x8(%ebx)
80104360:	e8 0b e1 ff ff       	call   80102470 <kfree>
    np->kstack = 0;
80104365:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
8010436c:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010436f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104376:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010437b:	eb c9                	jmp    80104346 <fork+0x106>
8010437d:	8d 76 00             	lea    0x0(%esi),%esi

80104380 <round_robin>:
{
80104380:	f3 0f 1e fb          	endbr32 
80104384:	55                   	push   %ebp
  int max_diff = MIN_INT;
80104385:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010438a:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
{
8010438f:	89 e5                	mov    %esp,%ebp
80104391:	56                   	push   %esi
  struct proc *res = 0;
80104392:	31 f6                	xor    %esi,%esi
{
80104394:	53                   	push   %ebx
  int now = ticks;
80104395:	8b 1d a0 6d 11 80    	mov    0x80116da0,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010439b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010439f:	90                   	nop
    if (p->state != RUNNABLE || p->que_id != RR)
801043a0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801043a4:	75 1a                	jne    801043c0 <round_robin+0x40>
801043a6:	83 78 28 01          	cmpl   $0x1,0x28(%eax)
801043aa:	75 14                	jne    801043c0 <round_robin+0x40>
    if ((now - p->preemption_time > max_diff))
801043ac:	89 da                	mov    %ebx,%edx
801043ae:	2b 50 24             	sub    0x24(%eax),%edx
801043b1:	39 ca                	cmp    %ecx,%edx
801043b3:	7e 0b                	jle    801043c0 <round_robin+0x40>
801043b5:	89 d1                	mov    %edx,%ecx
801043b7:	89 c6                	mov    %eax,%esi
801043b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043c0:	05 a0 00 00 00       	add    $0xa0,%eax
801043c5:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801043ca:	75 d4                	jne    801043a0 <round_robin+0x20>
}
801043cc:	89 f0                	mov    %esi,%eax
801043ce:	5b                   	pop    %ebx
801043cf:	5e                   	pop    %esi
801043d0:	5d                   	pop    %ebp
801043d1:	c3                   	ret    
801043d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043e0 <last_come_first_serve>:
{
801043e0:	f3 0f 1e fb          	endbr32 
801043e4:	55                   	push   %ebp
  int latest_time = MIN_INT;
801043e5:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ea:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
{
801043ef:	89 e5                	mov    %esp,%ebp
801043f1:	53                   	push   %ebx
  struct proc *res = 0;
801043f2:	31 db                	xor    %ebx,%ebx
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != RUNNABLE || p->que_id != LCFS)
801043f8:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801043fc:	75 12                	jne    80104410 <last_come_first_serve+0x30>
801043fe:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
80104402:	75 0c                	jne    80104410 <last_come_first_serve+0x30>
    if (p->creation_time > latest_time)
80104404:	8b 50 20             	mov    0x20(%eax),%edx
80104407:	39 ca                	cmp    %ecx,%edx
80104409:	7e 05                	jle    80104410 <last_come_first_serve+0x30>
8010440b:	89 d1                	mov    %edx,%ecx
8010440d:	89 c3                	mov    %eax,%ebx
8010440f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104410:	05 a0 00 00 00       	add    $0xa0,%eax
80104415:	3d 54 65 11 80       	cmp    $0x80116554,%eax
8010441a:	75 dc                	jne    801043f8 <last_come_first_serve+0x18>
}
8010441c:	89 d8                	mov    %ebx,%eax
8010441e:	5b                   	pop    %ebx
8010441f:	5d                   	pop    %ebp
80104420:	c3                   	ret    
80104421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010442f:	90                   	nop

80104430 <best_job_first>:
{
80104430:	f3 0f 1e fb          	endbr32 
  float min_rank = (float)MAX_INT;
80104434:	d9 05 6c 88 10 80    	flds   0x8010886c
  struct proc *res = 0;
8010443a:	31 d2                	xor    %edx,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010443c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != RUNNABLE || p->que_id != BJF)
80104448:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010444c:	0f 85 96 00 00 00    	jne    801044e8 <best_job_first+0xb8>
80104452:	83 78 28 03          	cmpl   $0x3,0x28(%eax)
80104456:	0f 85 8c 00 00 00    	jne    801044e8 <best_job_first+0xb8>
{
8010445c:	55                   	push   %ebp
8010445d:	89 e5                	mov    %esp,%ebp
8010445f:	53                   	push   %ebx
80104460:	83 ec 0c             	sub    $0xc,%esp
  return (((float)p->priority) * p->priority_ratio) + (((float)p->creation_time) * p->creation_time_ratio) + ((((float)p->executed_cycle)) * p->executed_cycle_ratio) + (((float)p->sz) * p->process_size_ratio);
80104463:	db 80 88 00 00 00    	fildl  0x88(%eax)
80104469:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
8010446f:	31 db                	xor    %ebx,%ebx
80104471:	db 40 20             	fildl  0x20(%eax)
80104474:	d8 88 90 00 00 00    	fmuls  0x90(%eax)
8010447a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
8010447d:	8b 08                	mov    (%eax),%ecx
8010447f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
80104482:	de c1                	faddp  %st,%st(1)
80104484:	d9 80 94 00 00 00    	flds   0x94(%eax)
8010448a:	d8 88 98 00 00 00    	fmuls  0x98(%eax)
80104490:	de c1                	faddp  %st,%st(1)
80104492:	df 6d f0             	fildll -0x10(%ebp)
80104495:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
8010449b:	de c1                	faddp  %st,%st(1)
8010449d:	d9 c9                	fxch   %st(1)
    if (rank < min_rank)
8010449f:	db f1                	fcomi  %st(1),%st
801044a1:	76 0d                	jbe    801044b0 <best_job_first+0x80>
801044a3:	dd d8                	fstp   %st(0)
801044a5:	89 c2                	mov    %eax,%edx
801044a7:	eb 09                	jmp    801044b2 <best_job_first+0x82>
801044a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044b0:	dd d9                	fstp   %st(1)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044b2:	05 a0 00 00 00       	add    $0xa0,%eax
801044b7:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801044bc:	74 1c                	je     801044da <best_job_first+0xaa>
    if (p->state != RUNNABLE || p->que_id != BJF)
801044be:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801044c2:	75 ee                	jne    801044b2 <best_job_first+0x82>
801044c4:	83 78 28 03          	cmpl   $0x3,0x28(%eax)
801044c8:	74 99                	je     80104463 <best_job_first+0x33>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044ca:	05 a0 00 00 00       	add    $0xa0,%eax
801044cf:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801044d4:	75 e8                	jne    801044be <best_job_first+0x8e>
801044d6:	dd d8                	fstp   %st(0)
801044d8:	eb 02                	jmp    801044dc <best_job_first+0xac>
801044da:	dd d8                	fstp   %st(0)
}
801044dc:	83 c4 0c             	add    $0xc,%esp
801044df:	89 d0                	mov    %edx,%eax
801044e1:	5b                   	pop    %ebx
801044e2:	5d                   	pop    %ebp
801044e3:	c3                   	ret    
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044e8:	05 a0 00 00 00       	add    $0xa0,%eax
801044ed:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801044f2:	0f 85 50 ff ff ff    	jne    80104448 <best_job_first+0x18>
801044f8:	dd d8                	fstp   %st(0)
}
801044fa:	89 d0                	mov    %edx,%eax
801044fc:	c3                   	ret    
801044fd:	8d 76 00             	lea    0x0(%esi),%esi

80104500 <scheduler>:
{
80104500:	f3 0f 1e fb          	endbr32 
80104504:	55                   	push   %ebp
80104505:	89 e5                	mov    %esp,%ebp
80104507:	57                   	push   %edi
80104508:	56                   	push   %esi
80104509:	53                   	push   %ebx
8010450a:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
8010450d:	e8 5e f4 ff ff       	call   80103970 <mycpu>
  c->proc = 0;
80104512:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104519:	00 00 00 
  struct cpu *c = mycpu();
8010451c:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
8010451e:	8d 40 04             	lea    0x4(%eax),%eax
80104521:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104528:	fb                   	sti    
    acquire(&ptable.lock);
80104529:	83 ec 0c             	sub    $0xc,%esp
  struct proc *res = 0;
8010452c:	31 f6                	xor    %esi,%esi
    acquire(&ptable.lock);
8010452e:	68 20 3d 11 80       	push   $0x80113d20
80104533:	e8 68 0a 00 00       	call   80104fa0 <acquire>
  int now = ticks;
80104538:	8b 3d a0 6d 11 80    	mov    0x80116da0,%edi
8010453e:	83 c4 10             	add    $0x10,%esp
  int max_diff = MIN_INT;
80104541:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104546:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010454b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010454f:	90                   	nop
    if (p->state != RUNNABLE || p->que_id != RR)
80104550:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104554:	75 1a                	jne    80104570 <scheduler+0x70>
80104556:	83 78 28 01          	cmpl   $0x1,0x28(%eax)
8010455a:	75 14                	jne    80104570 <scheduler+0x70>
    if ((now - p->preemption_time > max_diff))
8010455c:	89 fa                	mov    %edi,%edx
8010455e:	2b 50 24             	sub    0x24(%eax),%edx
80104561:	39 ca                	cmp    %ecx,%edx
80104563:	7e 0b                	jle    80104570 <scheduler+0x70>
80104565:	89 d1                	mov    %edx,%ecx
80104567:	89 c6                	mov    %eax,%esi
80104569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104570:	05 a0 00 00 00       	add    $0xa0,%eax
80104575:	3d 54 65 11 80       	cmp    $0x80116554,%eax
8010457a:	75 d4                	jne    80104550 <scheduler+0x50>
    if (p == 0)
8010457c:	85 f6                	test   %esi,%esi
8010457e:	74 60                	je     801045e0 <scheduler+0xe0>
    switchuvm(p);
80104580:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
80104583:	89 b3 ac 00 00 00    	mov    %esi,0xac(%ebx)
    switchuvm(p);
80104589:	56                   	push   %esi
8010458a:	e8 b1 34 00 00       	call   80107a40 <switchuvm>
    p->executed_cycle += 0.1f;
8010458f:	d9 05 68 88 10 80    	flds   0x80108868
80104595:	d8 86 94 00 00 00    	fadds  0x94(%esi)
    p->state = RUNNING;
8010459b:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
    p->preemption_time = ticks;
801045a2:	a1 a0 6d 11 80       	mov    0x80116da0,%eax
801045a7:	89 46 24             	mov    %eax,0x24(%esi)
    p->executed_cycle += 0.1f;
801045aa:	d9 9e 94 00 00 00    	fstps  0x94(%esi)
    swtch(&(c->scheduler), p->context);
801045b0:	58                   	pop    %eax
801045b1:	5a                   	pop    %edx
801045b2:	ff 76 1c             	pushl  0x1c(%esi)
801045b5:	ff 75 e4             	pushl  -0x1c(%ebp)
801045b8:	e8 16 0d 00 00       	call   801052d3 <swtch>
    switchkvm();
801045bd:	e8 5e 34 00 00       	call   80107a20 <switchkvm>
    c->proc = 0;
801045c2:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
801045c9:	00 00 00 
    release(&ptable.lock);
801045cc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801045d3:	e8 88 0a 00 00       	call   80105060 <release>
801045d8:	83 c4 10             	add    $0x10,%esp
801045db:	e9 48 ff ff ff       	jmp    80104528 <scheduler+0x28>
  int latest_time = MIN_INT;
801045e0:	b9 f0 d8 ff ff       	mov    $0xffffd8f0,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045e5:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (p->state != RUNNABLE || p->que_id != LCFS)
801045f0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801045f4:	75 1a                	jne    80104610 <scheduler+0x110>
801045f6:	83 78 28 02          	cmpl   $0x2,0x28(%eax)
801045fa:	75 14                	jne    80104610 <scheduler+0x110>
    if (p->creation_time > latest_time)
801045fc:	8b 50 20             	mov    0x20(%eax),%edx
801045ff:	39 ca                	cmp    %ecx,%edx
80104601:	7e 0d                	jle    80104610 <scheduler+0x110>
80104603:	89 d1                	mov    %edx,%ecx
80104605:	89 c6                	mov    %eax,%esi
80104607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010460e:	66 90                	xchg   %ax,%ax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104610:	05 a0 00 00 00       	add    $0xa0,%eax
80104615:	3d 54 65 11 80       	cmp    $0x80116554,%eax
8010461a:	75 d4                	jne    801045f0 <scheduler+0xf0>
    if (p == 0)
8010461c:	85 f6                	test   %esi,%esi
8010461e:	0f 85 5c ff ff ff    	jne    80104580 <scheduler+0x80>
      p = best_job_first();
80104624:	e8 07 fe ff ff       	call   80104430 <best_job_first>
80104629:	89 c6                	mov    %eax,%esi
    if (p == 0)
8010462b:	85 c0                	test   %eax,%eax
8010462d:	0f 85 4d ff ff ff    	jne    80104580 <scheduler+0x80>
      release(&ptable.lock);
80104633:	83 ec 0c             	sub    $0xc,%esp
80104636:	68 20 3d 11 80       	push   $0x80113d20
8010463b:	e8 20 0a 00 00       	call   80105060 <release>
      continue;
80104640:	83 c4 10             	add    $0x10,%esp
80104643:	e9 e0 fe ff ff       	jmp    80104528 <scheduler+0x28>
80104648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010464f:	90                   	nop

80104650 <sched>:
{
80104650:	f3 0f 1e fb          	endbr32 
80104654:	55                   	push   %ebp
80104655:	89 e5                	mov    %esp,%ebp
80104657:	56                   	push   %esi
80104658:	53                   	push   %ebx
  pushcli();
80104659:	e8 42 08 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
8010465e:	e8 0d f3 ff ff       	call   80103970 <mycpu>
  p = c->proc;
80104663:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104669:	e8 82 08 00 00       	call   80104ef0 <popcli>
  if (!holding(&ptable.lock))
8010466e:	83 ec 0c             	sub    $0xc,%esp
80104671:	68 20 3d 11 80       	push   $0x80113d20
80104676:	e8 d5 08 00 00       	call   80104f50 <holding>
8010467b:	83 c4 10             	add    $0x10,%esp
8010467e:	85 c0                	test   %eax,%eax
80104680:	74 4f                	je     801046d1 <sched+0x81>
  if (mycpu()->ncli != 1)
80104682:	e8 e9 f2 ff ff       	call   80103970 <mycpu>
80104687:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010468e:	75 68                	jne    801046f8 <sched+0xa8>
  if (p->state == RUNNING)
80104690:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104694:	74 55                	je     801046eb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104696:	9c                   	pushf  
80104697:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80104698:	f6 c4 02             	test   $0x2,%ah
8010469b:	75 41                	jne    801046de <sched+0x8e>
  intena = mycpu()->intena;
8010469d:	e8 ce f2 ff ff       	call   80103970 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801046a2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801046a5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801046ab:	e8 c0 f2 ff ff       	call   80103970 <mycpu>
801046b0:	83 ec 08             	sub    $0x8,%esp
801046b3:	ff 70 04             	pushl  0x4(%eax)
801046b6:	53                   	push   %ebx
801046b7:	e8 17 0c 00 00       	call   801052d3 <swtch>
  mycpu()->intena = intena;
801046bc:	e8 af f2 ff ff       	call   80103970 <mycpu>
}
801046c1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801046c4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801046ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046cd:	5b                   	pop    %ebx
801046ce:	5e                   	pop    %esi
801046cf:	5d                   	pop    %ebp
801046d0:	c3                   	ret    
    panic("sched ptable.lock");
801046d1:	83 ec 0c             	sub    $0xc,%esp
801046d4:	68 14 87 10 80       	push   $0x80108714
801046d9:	e8 b2 bc ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801046de:	83 ec 0c             	sub    $0xc,%esp
801046e1:	68 40 87 10 80       	push   $0x80108740
801046e6:	e8 a5 bc ff ff       	call   80100390 <panic>
    panic("sched running");
801046eb:	83 ec 0c             	sub    $0xc,%esp
801046ee:	68 32 87 10 80       	push   $0x80108732
801046f3:	e8 98 bc ff ff       	call   80100390 <panic>
    panic("sched locks");
801046f8:	83 ec 0c             	sub    $0xc,%esp
801046fb:	68 26 87 10 80       	push   $0x80108726
80104700:	e8 8b bc ff ff       	call   80100390 <panic>
80104705:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104710 <exit>:
{
80104710:	f3 0f 1e fb          	endbr32 
80104714:	55                   	push   %ebp
80104715:	89 e5                	mov    %esp,%ebp
80104717:	57                   	push   %edi
80104718:	56                   	push   %esi
80104719:	53                   	push   %ebx
8010471a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010471d:	e8 7e 07 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
80104722:	e8 49 f2 ff ff       	call   80103970 <mycpu>
  p = c->proc;
80104727:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010472d:	e8 be 07 00 00       	call   80104ef0 <popcli>
  if (curproc == initproc)
80104732:	8d 5e 34             	lea    0x34(%esi),%ebx
80104735:	8d 7e 74             	lea    0x74(%esi),%edi
80104738:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
8010473e:	0f 84 fd 00 00 00    	je     80104841 <exit+0x131>
80104744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd])
80104748:	8b 03                	mov    (%ebx),%eax
8010474a:	85 c0                	test   %eax,%eax
8010474c:	74 12                	je     80104760 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010474e:	83 ec 0c             	sub    $0xc,%esp
80104751:	50                   	push   %eax
80104752:	e8 69 c7 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80104757:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010475d:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
80104760:	83 c3 04             	add    $0x4,%ebx
80104763:	39 df                	cmp    %ebx,%edi
80104765:	75 e1                	jne    80104748 <exit+0x38>
  begin_op();
80104767:	e8 c4 e5 ff ff       	call   80102d30 <begin_op>
  iput(curproc->cwd);
8010476c:	83 ec 0c             	sub    $0xc,%esp
8010476f:	ff 76 74             	pushl  0x74(%esi)
80104772:	e8 19 d1 ff ff       	call   80101890 <iput>
  end_op();
80104777:	e8 24 e6 ff ff       	call   80102da0 <end_op>
  curproc->cwd = 0;
8010477c:	c7 46 74 00 00 00 00 	movl   $0x0,0x74(%esi)
  acquire(&ptable.lock);
80104783:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010478a:	e8 11 08 00 00       	call   80104fa0 <acquire>
  wakeup1(curproc->parent);
8010478f:	8b 56 14             	mov    0x14(%esi),%edx
80104792:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104795:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010479a:	eb 10                	jmp    801047ac <exit+0x9c>
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047a0:	05 a0 00 00 00       	add    $0xa0,%eax
801047a5:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801047aa:	74 1e                	je     801047ca <exit+0xba>
    if (p->state == SLEEPING && p->chan == chan)
801047ac:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801047b0:	75 ee                	jne    801047a0 <exit+0x90>
801047b2:	3b 50 2c             	cmp    0x2c(%eax),%edx
801047b5:	75 e9                	jne    801047a0 <exit+0x90>
      p->state = RUNNABLE;
801047b7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047be:	05 a0 00 00 00       	add    $0xa0,%eax
801047c3:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801047c8:	75 e2                	jne    801047ac <exit+0x9c>
      p->parent = initproc;
801047ca:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047d0:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
801047d5:	eb 17                	jmp    801047ee <exit+0xde>
801047d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047de:	66 90                	xchg   %ax,%ax
801047e0:	81 c2 a0 00 00 00    	add    $0xa0,%edx
801047e6:	81 fa 54 65 11 80    	cmp    $0x80116554,%edx
801047ec:	74 3a                	je     80104828 <exit+0x118>
    if (p->parent == curproc)
801047ee:	39 72 14             	cmp    %esi,0x14(%edx)
801047f1:	75 ed                	jne    801047e0 <exit+0xd0>
      if (p->state == ZOMBIE)
801047f3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801047f7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
801047fa:	75 e4                	jne    801047e0 <exit+0xd0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047fc:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104801:	eb 11                	jmp    80104814 <exit+0x104>
80104803:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104807:	90                   	nop
80104808:	05 a0 00 00 00       	add    $0xa0,%eax
8010480d:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80104812:	74 cc                	je     801047e0 <exit+0xd0>
    if (p->state == SLEEPING && p->chan == chan)
80104814:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104818:	75 ee                	jne    80104808 <exit+0xf8>
8010481a:	3b 48 2c             	cmp    0x2c(%eax),%ecx
8010481d:	75 e9                	jne    80104808 <exit+0xf8>
      p->state = RUNNABLE;
8010481f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104826:	eb e0                	jmp    80104808 <exit+0xf8>
  curproc->state = ZOMBIE;
80104828:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010482f:	e8 1c fe ff ff       	call   80104650 <sched>
  panic("zombie exit");
80104834:	83 ec 0c             	sub    $0xc,%esp
80104837:	68 61 87 10 80       	push   $0x80108761
8010483c:	e8 4f bb ff ff       	call   80100390 <panic>
    panic("init exiting");
80104841:	83 ec 0c             	sub    $0xc,%esp
80104844:	68 54 87 10 80       	push   $0x80108754
80104849:	e8 42 bb ff ff       	call   80100390 <panic>
8010484e:	66 90                	xchg   %ax,%ax

80104850 <yield>:
{
80104850:	f3 0f 1e fb          	endbr32 
80104854:	55                   	push   %ebp
80104855:	89 e5                	mov    %esp,%ebp
80104857:	56                   	push   %esi
80104858:	53                   	push   %ebx
  acquire(&ptable.lock); // DOC: yieldlock
80104859:	83 ec 0c             	sub    $0xc,%esp
8010485c:	68 20 3d 11 80       	push   $0x80113d20
80104861:	e8 3a 07 00 00       	call   80104fa0 <acquire>
  pushcli();
80104866:	e8 35 06 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
8010486b:	e8 00 f1 ff ff       	call   80103970 <mycpu>
  p = c->proc;
80104870:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104876:	e8 75 06 00 00       	call   80104ef0 <popcli>
  myproc()->preemption_time = ticks;
8010487b:	8b 35 a0 6d 11 80    	mov    0x80116da0,%esi
  myproc()->state = RUNNABLE;
80104881:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pushcli();
80104888:	e8 13 06 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
8010488d:	e8 de f0 ff ff       	call   80103970 <mycpu>
  p = c->proc;
80104892:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104898:	e8 53 06 00 00       	call   80104ef0 <popcli>
  myproc()->preemption_time = ticks;
8010489d:	89 73 24             	mov    %esi,0x24(%ebx)
  pushcli();
801048a0:	e8 fb 05 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
801048a5:	e8 c6 f0 ff ff       	call   80103970 <mycpu>
  p = c->proc;
801048aa:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048b0:	e8 3b 06 00 00       	call   80104ef0 <popcli>
  myproc()->executed_cycle += 0.1;
801048b5:	dd 05 70 88 10 80    	fldl   0x80108870
801048bb:	d8 83 94 00 00 00    	fadds  0x94(%ebx)
801048c1:	d9 9b 94 00 00 00    	fstps  0x94(%ebx)
  sched();
801048c7:	e8 84 fd ff ff       	call   80104650 <sched>
  release(&ptable.lock);
801048cc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801048d3:	e8 88 07 00 00       	call   80105060 <release>
}
801048d8:	83 c4 10             	add    $0x10,%esp
801048db:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048de:	5b                   	pop    %ebx
801048df:	5e                   	pop    %esi
801048e0:	5d                   	pop    %ebp
801048e1:	c3                   	ret    
801048e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048f0 <sleep>:
{
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	57                   	push   %edi
801048f8:	56                   	push   %esi
801048f9:	53                   	push   %ebx
801048fa:	83 ec 0c             	sub    $0xc,%esp
801048fd:	8b 7d 08             	mov    0x8(%ebp),%edi
80104900:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104903:	e8 98 05 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
80104908:	e8 63 f0 ff ff       	call   80103970 <mycpu>
  p = c->proc;
8010490d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104913:	e8 d8 05 00 00       	call   80104ef0 <popcli>
  if (p == 0)
80104918:	85 db                	test   %ebx,%ebx
8010491a:	0f 84 83 00 00 00    	je     801049a3 <sleep+0xb3>
  if (lk == 0)
80104920:	85 f6                	test   %esi,%esi
80104922:	74 72                	je     80104996 <sleep+0xa6>
  if (lk != &ptable.lock)
80104924:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
8010492a:	74 4c                	je     80104978 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
8010492c:	83 ec 0c             	sub    $0xc,%esp
8010492f:	68 20 3d 11 80       	push   $0x80113d20
80104934:	e8 67 06 00 00       	call   80104fa0 <acquire>
    release(lk);
80104939:	89 34 24             	mov    %esi,(%esp)
8010493c:	e8 1f 07 00 00       	call   80105060 <release>
  p->chan = chan;
80104941:	89 7b 2c             	mov    %edi,0x2c(%ebx)
  p->state = SLEEPING;
80104944:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010494b:	e8 00 fd ff ff       	call   80104650 <sched>
  p->chan = 0;
80104950:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
    release(&ptable.lock);
80104957:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010495e:	e8 fd 06 00 00       	call   80105060 <release>
    acquire(lk);
80104963:	89 75 08             	mov    %esi,0x8(%ebp)
80104966:	83 c4 10             	add    $0x10,%esp
}
80104969:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010496c:	5b                   	pop    %ebx
8010496d:	5e                   	pop    %esi
8010496e:	5f                   	pop    %edi
8010496f:	5d                   	pop    %ebp
    acquire(lk);
80104970:	e9 2b 06 00 00       	jmp    80104fa0 <acquire>
80104975:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104978:	89 7b 2c             	mov    %edi,0x2c(%ebx)
  p->state = SLEEPING;
8010497b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104982:	e8 c9 fc ff ff       	call   80104650 <sched>
  p->chan = 0;
80104987:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
}
8010498e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104991:	5b                   	pop    %ebx
80104992:	5e                   	pop    %esi
80104993:	5f                   	pop    %edi
80104994:	5d                   	pop    %ebp
80104995:	c3                   	ret    
    panic("sleep without lk");
80104996:	83 ec 0c             	sub    $0xc,%esp
80104999:	68 73 87 10 80       	push   $0x80108773
8010499e:	e8 ed b9 ff ff       	call   80100390 <panic>
    panic("sleep");
801049a3:	83 ec 0c             	sub    $0xc,%esp
801049a6:	68 6d 87 10 80       	push   $0x8010876d
801049ab:	e8 e0 b9 ff ff       	call   80100390 <panic>

801049b0 <wait>:
{
801049b0:	f3 0f 1e fb          	endbr32 
801049b4:	55                   	push   %ebp
801049b5:	89 e5                	mov    %esp,%ebp
801049b7:	56                   	push   %esi
801049b8:	53                   	push   %ebx
  pushcli();
801049b9:	e8 e2 04 00 00       	call   80104ea0 <pushcli>
  c = mycpu();
801049be:	e8 ad ef ff ff       	call   80103970 <mycpu>
  p = c->proc;
801049c3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801049c9:	e8 22 05 00 00       	call   80104ef0 <popcli>
  acquire(&ptable.lock);
801049ce:	83 ec 0c             	sub    $0xc,%esp
801049d1:	68 20 3d 11 80       	push   $0x80113d20
801049d6:	e8 c5 05 00 00       	call   80104fa0 <acquire>
801049db:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801049de:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049e0:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
801049e5:	eb 17                	jmp    801049fe <wait+0x4e>
801049e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ee:	66 90                	xchg   %ax,%ax
801049f0:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
801049f6:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
801049fc:	74 1e                	je     80104a1c <wait+0x6c>
      if (p->parent != curproc)
801049fe:	39 73 14             	cmp    %esi,0x14(%ebx)
80104a01:	75 ed                	jne    801049f0 <wait+0x40>
      if (p->state == ZOMBIE)
80104a03:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104a07:	74 37                	je     80104a40 <wait+0x90>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a09:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
      havekids = 1;
80104a0f:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a14:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80104a1a:	75 e2                	jne    801049fe <wait+0x4e>
    if (!havekids || curproc->killed)
80104a1c:	85 c0                	test   %eax,%eax
80104a1e:	74 76                	je     80104a96 <wait+0xe6>
80104a20:	8b 46 30             	mov    0x30(%esi),%eax
80104a23:	85 c0                	test   %eax,%eax
80104a25:	75 6f                	jne    80104a96 <wait+0xe6>
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
80104a27:	83 ec 08             	sub    $0x8,%esp
80104a2a:	68 20 3d 11 80       	push   $0x80113d20
80104a2f:	56                   	push   %esi
80104a30:	e8 bb fe ff ff       	call   801048f0 <sleep>
    havekids = 0;
80104a35:	83 c4 10             	add    $0x10,%esp
80104a38:	eb a4                	jmp    801049de <wait+0x2e>
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104a40:	83 ec 0c             	sub    $0xc,%esp
80104a43:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104a46:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104a49:	e8 22 da ff ff       	call   80102470 <kfree>
        freevm(p->pgdir);
80104a4e:	5a                   	pop    %edx
80104a4f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104a52:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104a59:	e8 a2 33 00 00       	call   80107e00 <freevm>
        release(&ptable.lock);
80104a5e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
80104a65:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104a6c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104a73:	c6 43 78 00          	movb   $0x0,0x78(%ebx)
        p->killed = 0;
80104a77:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
        p->state = UNUSED;
80104a7e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104a85:	e8 d6 05 00 00       	call   80105060 <release>
        return pid;
80104a8a:	83 c4 10             	add    $0x10,%esp
}
80104a8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a90:	89 f0                	mov    %esi,%eax
80104a92:	5b                   	pop    %ebx
80104a93:	5e                   	pop    %esi
80104a94:	5d                   	pop    %ebp
80104a95:	c3                   	ret    
      release(&ptable.lock);
80104a96:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104a99:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104a9e:	68 20 3d 11 80       	push   $0x80113d20
80104aa3:	e8 b8 05 00 00       	call   80105060 <release>
      return -1;
80104aa8:	83 c4 10             	add    $0x10,%esp
80104aab:	eb e0                	jmp    80104a8d <wait+0xdd>
80104aad:	8d 76 00             	lea    0x0(%esi),%esi

80104ab0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104ab0:	f3 0f 1e fb          	endbr32 
80104ab4:	55                   	push   %ebp
80104ab5:	89 e5                	mov    %esp,%ebp
80104ab7:	53                   	push   %ebx
80104ab8:	83 ec 10             	sub    $0x10,%esp
80104abb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104abe:	68 20 3d 11 80       	push   $0x80113d20
80104ac3:	e8 d8 04 00 00       	call   80104fa0 <acquire>
80104ac8:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104acb:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104ad0:	eb 12                	jmp    80104ae4 <wakeup+0x34>
80104ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ad8:	05 a0 00 00 00       	add    $0xa0,%eax
80104add:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80104ae2:	74 1e                	je     80104b02 <wakeup+0x52>
    if (p->state == SLEEPING && p->chan == chan)
80104ae4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104ae8:	75 ee                	jne    80104ad8 <wakeup+0x28>
80104aea:	3b 58 2c             	cmp    0x2c(%eax),%ebx
80104aed:	75 e9                	jne    80104ad8 <wakeup+0x28>
      p->state = RUNNABLE;
80104aef:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104af6:	05 a0 00 00 00       	add    $0xa0,%eax
80104afb:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80104b00:	75 e2                	jne    80104ae4 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104b02:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104b09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b0c:	c9                   	leave  
  release(&ptable.lock);
80104b0d:	e9 4e 05 00 00       	jmp    80105060 <release>
80104b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b20 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80104b20:	f3 0f 1e fb          	endbr32 
80104b24:	55                   	push   %ebp
80104b25:	89 e5                	mov    %esp,%ebp
80104b27:	53                   	push   %ebx
80104b28:	83 ec 10             	sub    $0x10,%esp
80104b2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104b2e:	68 20 3d 11 80       	push   $0x80113d20
80104b33:	e8 68 04 00 00       	call   80104fa0 <acquire>
80104b38:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b3b:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104b40:	eb 12                	jmp    80104b54 <kill+0x34>
80104b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b48:	05 a0 00 00 00       	add    $0xa0,%eax
80104b4d:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80104b52:	74 34                	je     80104b88 <kill+0x68>
  {
    if (p->pid == pid)
80104b54:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b57:	75 ef                	jne    80104b48 <kill+0x28>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
80104b59:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104b5d:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
      if (p->state == SLEEPING)
80104b64:	75 07                	jne    80104b6d <kill+0x4d>
        p->state = RUNNABLE;
80104b66:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104b6d:	83 ec 0c             	sub    $0xc,%esp
80104b70:	68 20 3d 11 80       	push   $0x80113d20
80104b75:	e8 e6 04 00 00       	call   80105060 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104b7d:	83 c4 10             	add    $0x10,%esp
80104b80:	31 c0                	xor    %eax,%eax
}
80104b82:	c9                   	leave  
80104b83:	c3                   	ret    
80104b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104b88:	83 ec 0c             	sub    $0xc,%esp
80104b8b:	68 20 3d 11 80       	push   $0x80113d20
80104b90:	e8 cb 04 00 00       	call   80105060 <release>
}
80104b95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104b98:	83 c4 10             	add    $0x10,%esp
80104b9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ba0:	c9                   	leave  
80104ba1:	c3                   	ret    
80104ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104bb0 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104bb0:	f3 0f 1e fb          	endbr32 
80104bb4:	55                   	push   %ebp
80104bb5:	89 e5                	mov    %esp,%ebp
80104bb7:	57                   	push   %edi
80104bb8:	56                   	push   %esi
80104bb9:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104bbc:	53                   	push   %ebx
80104bbd:	bb cc 3d 11 80       	mov    $0x80113dcc,%ebx
80104bc2:	83 ec 3c             	sub    $0x3c,%esp
80104bc5:	eb 2b                	jmp    80104bf2 <procdump+0x42>
80104bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bce:	66 90                	xchg   %ax,%ax
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104bd0:	83 ec 0c             	sub    $0xc,%esp
80104bd3:	68 cf 8b 10 80       	push   $0x80108bcf
80104bd8:	e8 d3 ba ff ff       	call   801006b0 <cprintf>
80104bdd:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104be0:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80104be6:	81 fb cc 65 11 80    	cmp    $0x801165cc,%ebx
80104bec:	0f 84 8e 00 00 00    	je     80104c80 <procdump+0xd0>
    if (p->state == UNUSED)
80104bf2:	8b 43 94             	mov    -0x6c(%ebx),%eax
80104bf5:	85 c0                	test   %eax,%eax
80104bf7:	74 e7                	je     80104be0 <procdump+0x30>
      state = "???";
80104bf9:	ba 84 87 10 80       	mov    $0x80108784,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104bfe:	83 f8 05             	cmp    $0x5,%eax
80104c01:	77 11                	ja     80104c14 <procdump+0x64>
80104c03:	8b 14 85 50 88 10 80 	mov    -0x7fef77b0(,%eax,4),%edx
      state = "???";
80104c0a:	b8 84 87 10 80       	mov    $0x80108784,%eax
80104c0f:	85 d2                	test   %edx,%edx
80104c11:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104c14:	53                   	push   %ebx
80104c15:	52                   	push   %edx
80104c16:	ff 73 98             	pushl  -0x68(%ebx)
80104c19:	68 88 87 10 80       	push   $0x80108788
80104c1e:	e8 8d ba ff ff       	call   801006b0 <cprintf>
    if (p->state == SLEEPING)
80104c23:	83 c4 10             	add    $0x10,%esp
80104c26:	83 7b 94 02          	cmpl   $0x2,-0x6c(%ebx)
80104c2a:	75 a4                	jne    80104bd0 <procdump+0x20>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80104c2c:	83 ec 08             	sub    $0x8,%esp
80104c2f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104c32:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104c35:	50                   	push   %eax
80104c36:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80104c39:	8b 40 0c             	mov    0xc(%eax),%eax
80104c3c:	83 c0 08             	add    $0x8,%eax
80104c3f:	50                   	push   %eax
80104c40:	e8 fb 01 00 00       	call   80104e40 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104c45:	83 c4 10             	add    $0x10,%esp
80104c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c4f:	90                   	nop
80104c50:	8b 17                	mov    (%edi),%edx
80104c52:	85 d2                	test   %edx,%edx
80104c54:	0f 84 76 ff ff ff    	je     80104bd0 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104c5a:	83 ec 08             	sub    $0x8,%esp
80104c5d:	83 c7 04             	add    $0x4,%edi
80104c60:	52                   	push   %edx
80104c61:	68 61 81 10 80       	push   $0x80108161
80104c66:	e8 45 ba ff ff       	call   801006b0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104c6b:	83 c4 10             	add    $0x10,%esp
80104c6e:	39 fe                	cmp    %edi,%esi
80104c70:	75 de                	jne    80104c50 <procdump+0xa0>
80104c72:	e9 59 ff ff ff       	jmp    80104bd0 <procdump+0x20>
80104c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7e:	66 90                	xchg   %ax,%ax
  }
}
80104c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c83:	5b                   	pop    %ebx
80104c84:	5e                   	pop    %esi
80104c85:	5f                   	pop    %edi
80104c86:	5d                   	pop    %ebp
80104c87:	c3                   	ret    
80104c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8f:	90                   	nop

80104c90 <find_digital_root>:

int find_digital_root(int num)
{
80104c90:	f3 0f 1e fb          	endbr32 
80104c94:	55                   	push   %ebp
80104c95:	89 e5                	mov    %esp,%ebp
80104c97:	56                   	push   %esi
80104c98:	53                   	push   %ebx
80104c99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while (num >= 10)
80104c9c:	83 fb 09             	cmp    $0x9,%ebx
80104c9f:	7e 32                	jle    80104cd3 <find_digital_root+0x43>
  {
    int temp = num;
    int res = 0;
    while (temp != 0)
    {
      int current_dig = temp % 10;
80104ca1:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cad:	8d 76 00             	lea    0x0(%esi),%esi
{
80104cb0:	89 d9                	mov    %ebx,%ecx
    int res = 0;
80104cb2:	31 db                	xor    %ebx,%ebx
80104cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      int current_dig = temp % 10;
80104cb8:	89 c8                	mov    %ecx,%eax
80104cba:	f7 e6                	mul    %esi
80104cbc:	c1 ea 03             	shr    $0x3,%edx
80104cbf:	8d 04 92             	lea    (%edx,%edx,4),%eax
80104cc2:	01 c0                	add    %eax,%eax
80104cc4:	29 c1                	sub    %eax,%ecx
      res += current_dig;
80104cc6:	01 cb                	add    %ecx,%ebx
      temp /= 10;
80104cc8:	89 d1                	mov    %edx,%ecx
    while (temp != 0)
80104cca:	85 d2                	test   %edx,%edx
80104ccc:	75 ea                	jne    80104cb8 <find_digital_root+0x28>
  while (num >= 10)
80104cce:	83 fb 09             	cmp    $0x9,%ebx
80104cd1:	7f dd                	jg     80104cb0 <find_digital_root+0x20>
    }
    num = res;
  }
  return num;
80104cd3:	89 d8                	mov    %ebx,%eax
80104cd5:	5b                   	pop    %ebx
80104cd6:	5e                   	pop    %esi
80104cd7:	5d                   	pop    %ebp
80104cd8:	c3                   	ret    
80104cd9:	66 90                	xchg   %ax,%ax
80104cdb:	66 90                	xchg   %ax,%ax
80104cdd:	66 90                	xchg   %ax,%ax
80104cdf:	90                   	nop

80104ce0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ce0:	f3 0f 1e fb          	endbr32 
80104ce4:	55                   	push   %ebp
80104ce5:	89 e5                	mov    %esp,%ebp
80104ce7:	53                   	push   %ebx
80104ce8:	83 ec 0c             	sub    $0xc,%esp
80104ceb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104cee:	68 78 88 10 80       	push   $0x80108878
80104cf3:	8d 43 04             	lea    0x4(%ebx),%eax
80104cf6:	50                   	push   %eax
80104cf7:	e8 24 01 00 00       	call   80104e20 <initlock>
  lk->name = name;
80104cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104cff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104d05:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104d08:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104d0f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d15:	c9                   	leave  
80104d16:	c3                   	ret    
80104d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1e:	66 90                	xchg   %ax,%ax

80104d20 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104d20:	f3 0f 1e fb          	endbr32 
80104d24:	55                   	push   %ebp
80104d25:	89 e5                	mov    %esp,%ebp
80104d27:	56                   	push   %esi
80104d28:	53                   	push   %ebx
80104d29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d2c:	8d 73 04             	lea    0x4(%ebx),%esi
80104d2f:	83 ec 0c             	sub    $0xc,%esp
80104d32:	56                   	push   %esi
80104d33:	e8 68 02 00 00       	call   80104fa0 <acquire>
  while (lk->locked) {
80104d38:	8b 13                	mov    (%ebx),%edx
80104d3a:	83 c4 10             	add    $0x10,%esp
80104d3d:	85 d2                	test   %edx,%edx
80104d3f:	74 1a                	je     80104d5b <acquiresleep+0x3b>
80104d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104d48:	83 ec 08             	sub    $0x8,%esp
80104d4b:	56                   	push   %esi
80104d4c:	53                   	push   %ebx
80104d4d:	e8 9e fb ff ff       	call   801048f0 <sleep>
  while (lk->locked) {
80104d52:	8b 03                	mov    (%ebx),%eax
80104d54:	83 c4 10             	add    $0x10,%esp
80104d57:	85 c0                	test   %eax,%eax
80104d59:	75 ed                	jne    80104d48 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104d5b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104d61:	e8 8a ed ff ff       	call   80103af0 <myproc>
80104d66:	8b 40 10             	mov    0x10(%eax),%eax
80104d69:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104d6c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104d6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d72:	5b                   	pop    %ebx
80104d73:	5e                   	pop    %esi
80104d74:	5d                   	pop    %ebp
  release(&lk->lk);
80104d75:	e9 e6 02 00 00       	jmp    80105060 <release>
80104d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d80 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104d80:	f3 0f 1e fb          	endbr32 
80104d84:	55                   	push   %ebp
80104d85:	89 e5                	mov    %esp,%ebp
80104d87:	56                   	push   %esi
80104d88:	53                   	push   %ebx
80104d89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d8c:	8d 73 04             	lea    0x4(%ebx),%esi
80104d8f:	83 ec 0c             	sub    $0xc,%esp
80104d92:	56                   	push   %esi
80104d93:	e8 08 02 00 00       	call   80104fa0 <acquire>
  lk->locked = 0;
80104d98:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104d9e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104da5:	89 1c 24             	mov    %ebx,(%esp)
80104da8:	e8 03 fd ff ff       	call   80104ab0 <wakeup>
  release(&lk->lk);
80104dad:	89 75 08             	mov    %esi,0x8(%ebp)
80104db0:	83 c4 10             	add    $0x10,%esp
}
80104db3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104db6:	5b                   	pop    %ebx
80104db7:	5e                   	pop    %esi
80104db8:	5d                   	pop    %ebp
  release(&lk->lk);
80104db9:	e9 a2 02 00 00       	jmp    80105060 <release>
80104dbe:	66 90                	xchg   %ax,%ax

80104dc0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104dc0:	f3 0f 1e fb          	endbr32 
80104dc4:	55                   	push   %ebp
80104dc5:	89 e5                	mov    %esp,%ebp
80104dc7:	57                   	push   %edi
80104dc8:	31 ff                	xor    %edi,%edi
80104dca:	56                   	push   %esi
80104dcb:	53                   	push   %ebx
80104dcc:	83 ec 18             	sub    $0x18,%esp
80104dcf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104dd2:	8d 73 04             	lea    0x4(%ebx),%esi
80104dd5:	56                   	push   %esi
80104dd6:	e8 c5 01 00 00       	call   80104fa0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104ddb:	8b 03                	mov    (%ebx),%eax
80104ddd:	83 c4 10             	add    $0x10,%esp
80104de0:	85 c0                	test   %eax,%eax
80104de2:	75 1c                	jne    80104e00 <holdingsleep+0x40>
  release(&lk->lk);
80104de4:	83 ec 0c             	sub    $0xc,%esp
80104de7:	56                   	push   %esi
80104de8:	e8 73 02 00 00       	call   80105060 <release>
  return r;
}
80104ded:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104df0:	89 f8                	mov    %edi,%eax
80104df2:	5b                   	pop    %ebx
80104df3:	5e                   	pop    %esi
80104df4:	5f                   	pop    %edi
80104df5:	5d                   	pop    %ebp
80104df6:	c3                   	ret    
80104df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dfe:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104e00:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104e03:	e8 e8 ec ff ff       	call   80103af0 <myproc>
80104e08:	39 58 10             	cmp    %ebx,0x10(%eax)
80104e0b:	0f 94 c0             	sete   %al
80104e0e:	0f b6 c0             	movzbl %al,%eax
80104e11:	89 c7                	mov    %eax,%edi
80104e13:	eb cf                	jmp    80104de4 <holdingsleep+0x24>
80104e15:	66 90                	xchg   %ax,%ax
80104e17:	66 90                	xchg   %ax,%ax
80104e19:	66 90                	xchg   %ax,%ax
80104e1b:	66 90                	xchg   %ax,%ax
80104e1d:	66 90                	xchg   %ax,%ax
80104e1f:	90                   	nop

80104e20 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104e20:	f3 0f 1e fb          	endbr32 
80104e24:	55                   	push   %ebp
80104e25:	89 e5                	mov    %esp,%ebp
80104e27:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104e2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104e33:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104e36:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104e3d:	5d                   	pop    %ebp
80104e3e:	c3                   	ret    
80104e3f:	90                   	nop

80104e40 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104e40:	f3 0f 1e fb          	endbr32 
80104e44:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104e45:	31 d2                	xor    %edx,%edx
{
80104e47:	89 e5                	mov    %esp,%ebp
80104e49:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104e4a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104e4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104e50:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104e53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e57:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e58:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104e5e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104e64:	77 1a                	ja     80104e80 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104e66:	8b 58 04             	mov    0x4(%eax),%ebx
80104e69:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104e6c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104e6f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e71:	83 fa 0a             	cmp    $0xa,%edx
80104e74:	75 e2                	jne    80104e58 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104e76:	5b                   	pop    %ebx
80104e77:	5d                   	pop    %ebp
80104e78:	c3                   	ret    
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104e80:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104e83:	8d 51 28             	lea    0x28(%ecx),%edx
80104e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e8d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104e90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e96:	83 c0 04             	add    $0x4,%eax
80104e99:	39 d0                	cmp    %edx,%eax
80104e9b:	75 f3                	jne    80104e90 <getcallerpcs+0x50>
}
80104e9d:	5b                   	pop    %ebx
80104e9e:	5d                   	pop    %ebp
80104e9f:	c3                   	ret    

80104ea0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ea0:	f3 0f 1e fb          	endbr32 
80104ea4:	55                   	push   %ebp
80104ea5:	89 e5                	mov    %esp,%ebp
80104ea7:	53                   	push   %ebx
80104ea8:	83 ec 04             	sub    $0x4,%esp
80104eab:	9c                   	pushf  
80104eac:	5b                   	pop    %ebx
  asm volatile("cli");
80104ead:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104eae:	e8 bd ea ff ff       	call   80103970 <mycpu>
80104eb3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104eb9:	85 c0                	test   %eax,%eax
80104ebb:	74 13                	je     80104ed0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104ebd:	e8 ae ea ff ff       	call   80103970 <mycpu>
80104ec2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ec9:	83 c4 04             	add    $0x4,%esp
80104ecc:	5b                   	pop    %ebx
80104ecd:	5d                   	pop    %ebp
80104ece:	c3                   	ret    
80104ecf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104ed0:	e8 9b ea ff ff       	call   80103970 <mycpu>
80104ed5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104edb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104ee1:	eb da                	jmp    80104ebd <pushcli+0x1d>
80104ee3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ef0 <popcli>:

void
popcli(void)
{
80104ef0:	f3 0f 1e fb          	endbr32 
80104ef4:	55                   	push   %ebp
80104ef5:	89 e5                	mov    %esp,%ebp
80104ef7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104efa:	9c                   	pushf  
80104efb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104efc:	f6 c4 02             	test   $0x2,%ah
80104eff:	75 31                	jne    80104f32 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104f01:	e8 6a ea ff ff       	call   80103970 <mycpu>
80104f06:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104f0d:	78 30                	js     80104f3f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f0f:	e8 5c ea ff ff       	call   80103970 <mycpu>
80104f14:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104f1a:	85 d2                	test   %edx,%edx
80104f1c:	74 02                	je     80104f20 <popcli+0x30>
    sti();
}
80104f1e:	c9                   	leave  
80104f1f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f20:	e8 4b ea ff ff       	call   80103970 <mycpu>
80104f25:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104f2b:	85 c0                	test   %eax,%eax
80104f2d:	74 ef                	je     80104f1e <popcli+0x2e>
  asm volatile("sti");
80104f2f:	fb                   	sti    
}
80104f30:	c9                   	leave  
80104f31:	c3                   	ret    
    panic("popcli - interruptible");
80104f32:	83 ec 0c             	sub    $0xc,%esp
80104f35:	68 83 88 10 80       	push   $0x80108883
80104f3a:	e8 51 b4 ff ff       	call   80100390 <panic>
    panic("popcli");
80104f3f:	83 ec 0c             	sub    $0xc,%esp
80104f42:	68 9a 88 10 80       	push   $0x8010889a
80104f47:	e8 44 b4 ff ff       	call   80100390 <panic>
80104f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f50 <holding>:
{
80104f50:	f3 0f 1e fb          	endbr32 
80104f54:	55                   	push   %ebp
80104f55:	89 e5                	mov    %esp,%ebp
80104f57:	56                   	push   %esi
80104f58:	53                   	push   %ebx
80104f59:	8b 75 08             	mov    0x8(%ebp),%esi
80104f5c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104f5e:	e8 3d ff ff ff       	call   80104ea0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104f63:	8b 06                	mov    (%esi),%eax
80104f65:	85 c0                	test   %eax,%eax
80104f67:	75 0f                	jne    80104f78 <holding+0x28>
  popcli();
80104f69:	e8 82 ff ff ff       	call   80104ef0 <popcli>
}
80104f6e:	89 d8                	mov    %ebx,%eax
80104f70:	5b                   	pop    %ebx
80104f71:	5e                   	pop    %esi
80104f72:	5d                   	pop    %ebp
80104f73:	c3                   	ret    
80104f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104f78:	8b 5e 08             	mov    0x8(%esi),%ebx
80104f7b:	e8 f0 e9 ff ff       	call   80103970 <mycpu>
80104f80:	39 c3                	cmp    %eax,%ebx
80104f82:	0f 94 c3             	sete   %bl
  popcli();
80104f85:	e8 66 ff ff ff       	call   80104ef0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104f8a:	0f b6 db             	movzbl %bl,%ebx
}
80104f8d:	89 d8                	mov    %ebx,%eax
80104f8f:	5b                   	pop    %ebx
80104f90:	5e                   	pop    %esi
80104f91:	5d                   	pop    %ebp
80104f92:	c3                   	ret    
80104f93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fa0 <acquire>:
{
80104fa0:	f3 0f 1e fb          	endbr32 
80104fa4:	55                   	push   %ebp
80104fa5:	89 e5                	mov    %esp,%ebp
80104fa7:	56                   	push   %esi
80104fa8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104fa9:	e8 f2 fe ff ff       	call   80104ea0 <pushcli>
  if(holding(lk))
80104fae:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104fb1:	83 ec 0c             	sub    $0xc,%esp
80104fb4:	53                   	push   %ebx
80104fb5:	e8 96 ff ff ff       	call   80104f50 <holding>
80104fba:	83 c4 10             	add    $0x10,%esp
80104fbd:	85 c0                	test   %eax,%eax
80104fbf:	0f 85 7f 00 00 00    	jne    80105044 <acquire+0xa4>
80104fc5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104fc7:	ba 01 00 00 00       	mov    $0x1,%edx
80104fcc:	eb 05                	jmp    80104fd3 <acquire+0x33>
80104fce:	66 90                	xchg   %ax,%ax
80104fd0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104fd3:	89 d0                	mov    %edx,%eax
80104fd5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104fd8:	85 c0                	test   %eax,%eax
80104fda:	75 f4                	jne    80104fd0 <acquire+0x30>
  __sync_synchronize();
80104fdc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104fe1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104fe4:	e8 87 e9 ff ff       	call   80103970 <mycpu>
80104fe9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104fec:	89 e8                	mov    %ebp,%eax
80104fee:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ff0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104ff6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104ffc:	77 22                	ja     80105020 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104ffe:	8b 50 04             	mov    0x4(%eax),%edx
80105001:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80105005:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80105008:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010500a:	83 fe 0a             	cmp    $0xa,%esi
8010500d:	75 e1                	jne    80104ff0 <acquire+0x50>
}
8010500f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105012:	5b                   	pop    %ebx
80105013:	5e                   	pop    %esi
80105014:	5d                   	pop    %ebp
80105015:	c3                   	ret    
80105016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80105020:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80105024:	83 c3 34             	add    $0x34,%ebx
80105027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010502e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105030:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105036:	83 c0 04             	add    $0x4,%eax
80105039:	39 d8                	cmp    %ebx,%eax
8010503b:	75 f3                	jne    80105030 <acquire+0x90>
}
8010503d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105040:	5b                   	pop    %ebx
80105041:	5e                   	pop    %esi
80105042:	5d                   	pop    %ebp
80105043:	c3                   	ret    
    panic("acquire");
80105044:	83 ec 0c             	sub    $0xc,%esp
80105047:	68 a1 88 10 80       	push   $0x801088a1
8010504c:	e8 3f b3 ff ff       	call   80100390 <panic>
80105051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010505f:	90                   	nop

80105060 <release>:
{
80105060:	f3 0f 1e fb          	endbr32 
80105064:	55                   	push   %ebp
80105065:	89 e5                	mov    %esp,%ebp
80105067:	53                   	push   %ebx
80105068:	83 ec 10             	sub    $0x10,%esp
8010506b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010506e:	53                   	push   %ebx
8010506f:	e8 dc fe ff ff       	call   80104f50 <holding>
80105074:	83 c4 10             	add    $0x10,%esp
80105077:	85 c0                	test   %eax,%eax
80105079:	74 22                	je     8010509d <release+0x3d>
  lk->pcs[0] = 0;
8010507b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105082:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105089:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010508e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105094:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105097:	c9                   	leave  
  popcli();
80105098:	e9 53 fe ff ff       	jmp    80104ef0 <popcli>
    panic("release");
8010509d:	83 ec 0c             	sub    $0xc,%esp
801050a0:	68 a9 88 10 80       	push   $0x801088a9
801050a5:	e8 e6 b2 ff ff       	call   80100390 <panic>
801050aa:	66 90                	xchg   %ax,%ax
801050ac:	66 90                	xchg   %ax,%ax
801050ae:	66 90                	xchg   %ax,%ax

801050b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801050b0:	f3 0f 1e fb          	endbr32 
801050b4:	55                   	push   %ebp
801050b5:	89 e5                	mov    %esp,%ebp
801050b7:	57                   	push   %edi
801050b8:	8b 55 08             	mov    0x8(%ebp),%edx
801050bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801050be:	53                   	push   %ebx
801050bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801050c2:	89 d7                	mov    %edx,%edi
801050c4:	09 cf                	or     %ecx,%edi
801050c6:	83 e7 03             	and    $0x3,%edi
801050c9:	75 25                	jne    801050f0 <memset+0x40>
    c &= 0xFF;
801050cb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801050ce:	c1 e0 18             	shl    $0x18,%eax
801050d1:	89 fb                	mov    %edi,%ebx
801050d3:	c1 e9 02             	shr    $0x2,%ecx
801050d6:	c1 e3 10             	shl    $0x10,%ebx
801050d9:	09 d8                	or     %ebx,%eax
801050db:	09 f8                	or     %edi,%eax
801050dd:	c1 e7 08             	shl    $0x8,%edi
801050e0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801050e2:	89 d7                	mov    %edx,%edi
801050e4:	fc                   	cld    
801050e5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801050e7:	5b                   	pop    %ebx
801050e8:	89 d0                	mov    %edx,%eax
801050ea:	5f                   	pop    %edi
801050eb:	5d                   	pop    %ebp
801050ec:	c3                   	ret    
801050ed:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801050f0:	89 d7                	mov    %edx,%edi
801050f2:	fc                   	cld    
801050f3:	f3 aa                	rep stos %al,%es:(%edi)
801050f5:	5b                   	pop    %ebx
801050f6:	89 d0                	mov    %edx,%eax
801050f8:	5f                   	pop    %edi
801050f9:	5d                   	pop    %ebp
801050fa:	c3                   	ret    
801050fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050ff:	90                   	nop

80105100 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105100:	f3 0f 1e fb          	endbr32 
80105104:	55                   	push   %ebp
80105105:	89 e5                	mov    %esp,%ebp
80105107:	56                   	push   %esi
80105108:	8b 75 10             	mov    0x10(%ebp),%esi
8010510b:	8b 55 08             	mov    0x8(%ebp),%edx
8010510e:	53                   	push   %ebx
8010510f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105112:	85 f6                	test   %esi,%esi
80105114:	74 2a                	je     80105140 <memcmp+0x40>
80105116:	01 c6                	add    %eax,%esi
80105118:	eb 10                	jmp    8010512a <memcmp+0x2a>
8010511a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105120:	83 c0 01             	add    $0x1,%eax
80105123:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105126:	39 f0                	cmp    %esi,%eax
80105128:	74 16                	je     80105140 <memcmp+0x40>
    if(*s1 != *s2)
8010512a:	0f b6 0a             	movzbl (%edx),%ecx
8010512d:	0f b6 18             	movzbl (%eax),%ebx
80105130:	38 d9                	cmp    %bl,%cl
80105132:	74 ec                	je     80105120 <memcmp+0x20>
      return *s1 - *s2;
80105134:	0f b6 c1             	movzbl %cl,%eax
80105137:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105139:	5b                   	pop    %ebx
8010513a:	5e                   	pop    %esi
8010513b:	5d                   	pop    %ebp
8010513c:	c3                   	ret    
8010513d:	8d 76 00             	lea    0x0(%esi),%esi
80105140:	5b                   	pop    %ebx
  return 0;
80105141:	31 c0                	xor    %eax,%eax
}
80105143:	5e                   	pop    %esi
80105144:	5d                   	pop    %ebp
80105145:	c3                   	ret    
80105146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010514d:	8d 76 00             	lea    0x0(%esi),%esi

80105150 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105150:	f3 0f 1e fb          	endbr32 
80105154:	55                   	push   %ebp
80105155:	89 e5                	mov    %esp,%ebp
80105157:	57                   	push   %edi
80105158:	8b 55 08             	mov    0x8(%ebp),%edx
8010515b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010515e:	56                   	push   %esi
8010515f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105162:	39 d6                	cmp    %edx,%esi
80105164:	73 2a                	jae    80105190 <memmove+0x40>
80105166:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105169:	39 fa                	cmp    %edi,%edx
8010516b:	73 23                	jae    80105190 <memmove+0x40>
8010516d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105170:	85 c9                	test   %ecx,%ecx
80105172:	74 13                	je     80105187 <memmove+0x37>
80105174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105178:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010517c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010517f:	83 e8 01             	sub    $0x1,%eax
80105182:	83 f8 ff             	cmp    $0xffffffff,%eax
80105185:	75 f1                	jne    80105178 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105187:	5e                   	pop    %esi
80105188:	89 d0                	mov    %edx,%eax
8010518a:	5f                   	pop    %edi
8010518b:	5d                   	pop    %ebp
8010518c:	c3                   	ret    
8010518d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105190:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105193:	89 d7                	mov    %edx,%edi
80105195:	85 c9                	test   %ecx,%ecx
80105197:	74 ee                	je     80105187 <memmove+0x37>
80105199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801051a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801051a1:	39 f0                	cmp    %esi,%eax
801051a3:	75 fb                	jne    801051a0 <memmove+0x50>
}
801051a5:	5e                   	pop    %esi
801051a6:	89 d0                	mov    %edx,%eax
801051a8:	5f                   	pop    %edi
801051a9:	5d                   	pop    %ebp
801051aa:	c3                   	ret    
801051ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051af:	90                   	nop

801051b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801051b0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
801051b4:	eb 9a                	jmp    80105150 <memmove>
801051b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051bd:	8d 76 00             	lea    0x0(%esi),%esi

801051c0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801051c0:	f3 0f 1e fb          	endbr32 
801051c4:	55                   	push   %ebp
801051c5:	89 e5                	mov    %esp,%ebp
801051c7:	56                   	push   %esi
801051c8:	8b 75 10             	mov    0x10(%ebp),%esi
801051cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051ce:	53                   	push   %ebx
801051cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801051d2:	85 f6                	test   %esi,%esi
801051d4:	74 32                	je     80105208 <strncmp+0x48>
801051d6:	01 c6                	add    %eax,%esi
801051d8:	eb 14                	jmp    801051ee <strncmp+0x2e>
801051da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801051e0:	38 da                	cmp    %bl,%dl
801051e2:	75 14                	jne    801051f8 <strncmp+0x38>
    n--, p++, q++;
801051e4:	83 c0 01             	add    $0x1,%eax
801051e7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801051ea:	39 f0                	cmp    %esi,%eax
801051ec:	74 1a                	je     80105208 <strncmp+0x48>
801051ee:	0f b6 11             	movzbl (%ecx),%edx
801051f1:	0f b6 18             	movzbl (%eax),%ebx
801051f4:	84 d2                	test   %dl,%dl
801051f6:	75 e8                	jne    801051e0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801051f8:	0f b6 c2             	movzbl %dl,%eax
801051fb:	29 d8                	sub    %ebx,%eax
}
801051fd:	5b                   	pop    %ebx
801051fe:	5e                   	pop    %esi
801051ff:	5d                   	pop    %ebp
80105200:	c3                   	ret    
80105201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105208:	5b                   	pop    %ebx
    return 0;
80105209:	31 c0                	xor    %eax,%eax
}
8010520b:	5e                   	pop    %esi
8010520c:	5d                   	pop    %ebp
8010520d:	c3                   	ret    
8010520e:	66 90                	xchg   %ax,%ax

80105210 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105210:	f3 0f 1e fb          	endbr32 
80105214:	55                   	push   %ebp
80105215:	89 e5                	mov    %esp,%ebp
80105217:	57                   	push   %edi
80105218:	56                   	push   %esi
80105219:	8b 75 08             	mov    0x8(%ebp),%esi
8010521c:	53                   	push   %ebx
8010521d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105220:	89 f2                	mov    %esi,%edx
80105222:	eb 1b                	jmp    8010523f <strncpy+0x2f>
80105224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105228:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010522c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010522f:	83 c2 01             	add    $0x1,%edx
80105232:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105236:	89 f9                	mov    %edi,%ecx
80105238:	88 4a ff             	mov    %cl,-0x1(%edx)
8010523b:	84 c9                	test   %cl,%cl
8010523d:	74 09                	je     80105248 <strncpy+0x38>
8010523f:	89 c3                	mov    %eax,%ebx
80105241:	83 e8 01             	sub    $0x1,%eax
80105244:	85 db                	test   %ebx,%ebx
80105246:	7f e0                	jg     80105228 <strncpy+0x18>
    ;
  while(n-- > 0)
80105248:	89 d1                	mov    %edx,%ecx
8010524a:	85 c0                	test   %eax,%eax
8010524c:	7e 15                	jle    80105263 <strncpy+0x53>
8010524e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105250:	83 c1 01             	add    $0x1,%ecx
80105253:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105257:	89 c8                	mov    %ecx,%eax
80105259:	f7 d0                	not    %eax
8010525b:	01 d0                	add    %edx,%eax
8010525d:	01 d8                	add    %ebx,%eax
8010525f:	85 c0                	test   %eax,%eax
80105261:	7f ed                	jg     80105250 <strncpy+0x40>
  return os;
}
80105263:	5b                   	pop    %ebx
80105264:	89 f0                	mov    %esi,%eax
80105266:	5e                   	pop    %esi
80105267:	5f                   	pop    %edi
80105268:	5d                   	pop    %ebp
80105269:	c3                   	ret    
8010526a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105270 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105270:	f3 0f 1e fb          	endbr32 
80105274:	55                   	push   %ebp
80105275:	89 e5                	mov    %esp,%ebp
80105277:	56                   	push   %esi
80105278:	8b 55 10             	mov    0x10(%ebp),%edx
8010527b:	8b 75 08             	mov    0x8(%ebp),%esi
8010527e:	53                   	push   %ebx
8010527f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105282:	85 d2                	test   %edx,%edx
80105284:	7e 21                	jle    801052a7 <safestrcpy+0x37>
80105286:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010528a:	89 f2                	mov    %esi,%edx
8010528c:	eb 12                	jmp    801052a0 <safestrcpy+0x30>
8010528e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105290:	0f b6 08             	movzbl (%eax),%ecx
80105293:	83 c0 01             	add    $0x1,%eax
80105296:	83 c2 01             	add    $0x1,%edx
80105299:	88 4a ff             	mov    %cl,-0x1(%edx)
8010529c:	84 c9                	test   %cl,%cl
8010529e:	74 04                	je     801052a4 <safestrcpy+0x34>
801052a0:	39 d8                	cmp    %ebx,%eax
801052a2:	75 ec                	jne    80105290 <safestrcpy+0x20>
    ;
  *s = 0;
801052a4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801052a7:	89 f0                	mov    %esi,%eax
801052a9:	5b                   	pop    %ebx
801052aa:	5e                   	pop    %esi
801052ab:	5d                   	pop    %ebp
801052ac:	c3                   	ret    
801052ad:	8d 76 00             	lea    0x0(%esi),%esi

801052b0 <strlen>:

int
strlen(const char *s)
{
801052b0:	f3 0f 1e fb          	endbr32 
801052b4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801052b5:	31 c0                	xor    %eax,%eax
{
801052b7:	89 e5                	mov    %esp,%ebp
801052b9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801052bc:	80 3a 00             	cmpb   $0x0,(%edx)
801052bf:	74 10                	je     801052d1 <strlen+0x21>
801052c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052c8:	83 c0 01             	add    $0x1,%eax
801052cb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801052cf:	75 f7                	jne    801052c8 <strlen+0x18>
    ;
  return n;
}
801052d1:	5d                   	pop    %ebp
801052d2:	c3                   	ret    

801052d3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801052d3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801052d7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801052db:	55                   	push   %ebp
  pushl %ebx
801052dc:	53                   	push   %ebx
  pushl %esi
801052dd:	56                   	push   %esi
  pushl %edi
801052de:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801052df:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801052e1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801052e3:	5f                   	pop    %edi
  popl %esi
801052e4:	5e                   	pop    %esi
  popl %ebx
801052e5:	5b                   	pop    %ebx
  popl %ebp
801052e6:	5d                   	pop    %ebp
  ret
801052e7:	c3                   	ret    
801052e8:	66 90                	xchg   %ax,%ax
801052ea:	66 90                	xchg   %ax,%ax
801052ec:	66 90                	xchg   %ax,%ax
801052ee:	66 90                	xchg   %ax,%ax

801052f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801052f0:	f3 0f 1e fb          	endbr32 
801052f4:	55                   	push   %ebp
801052f5:	89 e5                	mov    %esp,%ebp
801052f7:	53                   	push   %ebx
801052f8:	83 ec 04             	sub    $0x4,%esp
801052fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801052fe:	e8 ed e7 ff ff       	call   80103af0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105303:	8b 00                	mov    (%eax),%eax
80105305:	39 d8                	cmp    %ebx,%eax
80105307:	76 17                	jbe    80105320 <fetchint+0x30>
80105309:	8d 53 04             	lea    0x4(%ebx),%edx
8010530c:	39 d0                	cmp    %edx,%eax
8010530e:	72 10                	jb     80105320 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105310:	8b 45 0c             	mov    0xc(%ebp),%eax
80105313:	8b 13                	mov    (%ebx),%edx
80105315:	89 10                	mov    %edx,(%eax)
  return 0;
80105317:	31 c0                	xor    %eax,%eax
}
80105319:	83 c4 04             	add    $0x4,%esp
8010531c:	5b                   	pop    %ebx
8010531d:	5d                   	pop    %ebp
8010531e:	c3                   	ret    
8010531f:	90                   	nop
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105325:	eb f2                	jmp    80105319 <fetchint+0x29>
80105327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532e:	66 90                	xchg   %ax,%ax

80105330 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105330:	f3 0f 1e fb          	endbr32 
80105334:	55                   	push   %ebp
80105335:	89 e5                	mov    %esp,%ebp
80105337:	53                   	push   %ebx
80105338:	83 ec 04             	sub    $0x4,%esp
8010533b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010533e:	e8 ad e7 ff ff       	call   80103af0 <myproc>

  if(addr >= curproc->sz)
80105343:	39 18                	cmp    %ebx,(%eax)
80105345:	76 31                	jbe    80105378 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105347:	8b 55 0c             	mov    0xc(%ebp),%edx
8010534a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010534c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010534e:	39 d3                	cmp    %edx,%ebx
80105350:	73 26                	jae    80105378 <fetchstr+0x48>
80105352:	89 d8                	mov    %ebx,%eax
80105354:	eb 11                	jmp    80105367 <fetchstr+0x37>
80105356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535d:	8d 76 00             	lea    0x0(%esi),%esi
80105360:	83 c0 01             	add    $0x1,%eax
80105363:	39 c2                	cmp    %eax,%edx
80105365:	76 11                	jbe    80105378 <fetchstr+0x48>
    if(*s == 0)
80105367:	80 38 00             	cmpb   $0x0,(%eax)
8010536a:	75 f4                	jne    80105360 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010536c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010536f:	29 d8                	sub    %ebx,%eax
}
80105371:	5b                   	pop    %ebx
80105372:	5d                   	pop    %ebp
80105373:	c3                   	ret    
80105374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105378:	83 c4 04             	add    $0x4,%esp
    return -1;
8010537b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105380:	5b                   	pop    %ebx
80105381:	5d                   	pop    %ebp
80105382:	c3                   	ret    
80105383:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105390 <fetchfloat>:
int
fetchfloat(uint addr, float *fp)
{
80105390:	f3 0f 1e fb          	endbr32 
80105394:	55                   	push   %ebp
80105395:	89 e5                	mov    %esp,%ebp
80105397:	53                   	push   %ebx
80105398:	83 ec 04             	sub    $0x4,%esp
8010539b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010539e:	e8 4d e7 ff ff       	call   80103af0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801053a3:	8b 00                	mov    (%eax),%eax
801053a5:	39 d8                	cmp    %ebx,%eax
801053a7:	76 17                	jbe    801053c0 <fetchfloat+0x30>
801053a9:	8d 53 04             	lea    0x4(%ebx),%edx
801053ac:	39 d0                	cmp    %edx,%eax
801053ae:	72 10                	jb     801053c0 <fetchfloat+0x30>
    return -1;
  *fp = *(float*)(addr);
801053b0:	d9 03                	flds   (%ebx)
801053b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801053b5:	d9 18                	fstps  (%eax)
  return 0;
801053b7:	31 c0                	xor    %eax,%eax
}
801053b9:	83 c4 04             	add    $0x4,%esp
801053bc:	5b                   	pop    %ebx
801053bd:	5d                   	pop    %ebp
801053be:	c3                   	ret    
801053bf:	90                   	nop
    return -1;
801053c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053c5:	eb f2                	jmp    801053b9 <fetchfloat+0x29>
801053c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ce:	66 90                	xchg   %ax,%ax

801053d0 <argint>:
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801053d0:	f3 0f 1e fb          	endbr32 
801053d4:	55                   	push   %ebp
801053d5:	89 e5                	mov    %esp,%ebp
801053d7:	56                   	push   %esi
801053d8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053d9:	e8 12 e7 ff ff       	call   80103af0 <myproc>
801053de:	8b 55 08             	mov    0x8(%ebp),%edx
801053e1:	8b 40 18             	mov    0x18(%eax),%eax
801053e4:	8b 40 44             	mov    0x44(%eax),%eax
801053e7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801053ea:	e8 01 e7 ff ff       	call   80103af0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053ef:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801053f2:	8b 00                	mov    (%eax),%eax
801053f4:	39 c6                	cmp    %eax,%esi
801053f6:	73 18                	jae    80105410 <argint+0x40>
801053f8:	8d 53 08             	lea    0x8(%ebx),%edx
801053fb:	39 d0                	cmp    %edx,%eax
801053fd:	72 11                	jb     80105410 <argint+0x40>
  *ip = *(int*)(addr);
801053ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105402:	8b 53 04             	mov    0x4(%ebx),%edx
80105405:	89 10                	mov    %edx,(%eax)
  return 0;
80105407:	31 c0                	xor    %eax,%eax
}
80105409:	5b                   	pop    %ebx
8010540a:	5e                   	pop    %esi
8010540b:	5d                   	pop    %ebp
8010540c:	c3                   	ret    
8010540d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105415:	eb f2                	jmp    80105409 <argint+0x39>
80105417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010541e:	66 90                	xchg   %ax,%ax

80105420 <argf>:
int
argf(int n, float *fp)
{
80105420:	f3 0f 1e fb          	endbr32 
80105424:	55                   	push   %ebp
80105425:	89 e5                	mov    %esp,%ebp
80105427:	56                   	push   %esi
80105428:	53                   	push   %ebx
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105429:	e8 c2 e6 ff ff       	call   80103af0 <myproc>
8010542e:	8b 55 08             	mov    0x8(%ebp),%edx
80105431:	8b 40 18             	mov    0x18(%eax),%eax
80105434:	8b 40 44             	mov    0x44(%eax),%eax
80105437:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010543a:	e8 b1 e6 ff ff       	call   80103af0 <myproc>
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
8010543f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105442:	8b 00                	mov    (%eax),%eax
80105444:	39 c6                	cmp    %eax,%esi
80105446:	73 18                	jae    80105460 <argf+0x40>
80105448:	8d 53 08             	lea    0x8(%ebx),%edx
8010544b:	39 d0                	cmp    %edx,%eax
8010544d:	72 11                	jb     80105460 <argf+0x40>
  *fp = *(float*)(addr);
8010544f:	d9 43 04             	flds   0x4(%ebx)
80105452:	8b 45 0c             	mov    0xc(%ebp),%eax
80105455:	d9 18                	fstps  (%eax)
  return 0;
80105457:	31 c0                	xor    %eax,%eax
}
80105459:	5b                   	pop    %ebx
8010545a:	5e                   	pop    %esi
8010545b:	5d                   	pop    %ebp
8010545c:	c3                   	ret    
8010545d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105465:	eb f2                	jmp    80105459 <argf+0x39>
80105467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010546e:	66 90                	xchg   %ax,%ax

80105470 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105470:	f3 0f 1e fb          	endbr32 
80105474:	55                   	push   %ebp
80105475:	89 e5                	mov    %esp,%ebp
80105477:	56                   	push   %esi
80105478:	53                   	push   %ebx
80105479:	83 ec 10             	sub    $0x10,%esp
8010547c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010547f:	e8 6c e6 ff ff       	call   80103af0 <myproc>
 
  if(argint(n, &i) < 0)
80105484:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105487:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105489:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010548c:	50                   	push   %eax
8010548d:	ff 75 08             	pushl  0x8(%ebp)
80105490:	e8 3b ff ff ff       	call   801053d0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105495:	83 c4 10             	add    $0x10,%esp
80105498:	85 c0                	test   %eax,%eax
8010549a:	78 24                	js     801054c0 <argptr+0x50>
8010549c:	85 db                	test   %ebx,%ebx
8010549e:	78 20                	js     801054c0 <argptr+0x50>
801054a0:	8b 16                	mov    (%esi),%edx
801054a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054a5:	39 c2                	cmp    %eax,%edx
801054a7:	76 17                	jbe    801054c0 <argptr+0x50>
801054a9:	01 c3                	add    %eax,%ebx
801054ab:	39 da                	cmp    %ebx,%edx
801054ad:	72 11                	jb     801054c0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801054af:	8b 55 0c             	mov    0xc(%ebp),%edx
801054b2:	89 02                	mov    %eax,(%edx)
  return 0;
801054b4:	31 c0                	xor    %eax,%eax
}
801054b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054b9:	5b                   	pop    %ebx
801054ba:	5e                   	pop    %esi
801054bb:	5d                   	pop    %ebp
801054bc:	c3                   	ret    
801054bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801054c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c5:	eb ef                	jmp    801054b6 <argptr+0x46>
801054c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ce:	66 90                	xchg   %ax,%ax

801054d0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801054d0:	f3 0f 1e fb          	endbr32 
801054d4:	55                   	push   %ebp
801054d5:	89 e5                	mov    %esp,%ebp
801054d7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801054da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054dd:	50                   	push   %eax
801054de:	ff 75 08             	pushl  0x8(%ebp)
801054e1:	e8 ea fe ff ff       	call   801053d0 <argint>
801054e6:	83 c4 10             	add    $0x10,%esp
801054e9:	85 c0                	test   %eax,%eax
801054eb:	78 13                	js     80105500 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801054ed:	83 ec 08             	sub    $0x8,%esp
801054f0:	ff 75 0c             	pushl  0xc(%ebp)
801054f3:	ff 75 f4             	pushl  -0xc(%ebp)
801054f6:	e8 35 fe ff ff       	call   80105330 <fetchstr>
801054fb:	83 c4 10             	add    $0x10,%esp
}
801054fe:	c9                   	leave  
801054ff:	c3                   	ret    
80105500:	c9                   	leave  
    return -1;
80105501:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105506:	c3                   	ret    
80105507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550e:	66 90                	xchg   %ax,%ax

80105510 <syscall>:
[SYS_print_info] sys_print_info
};

void
syscall(void)
{
80105510:	f3 0f 1e fb          	endbr32 
80105514:	55                   	push   %ebp
80105515:	89 e5                	mov    %esp,%ebp
80105517:	53                   	push   %ebx
80105518:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010551b:	e8 d0 e5 ff ff       	call   80103af0 <myproc>
80105520:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105522:	8b 40 18             	mov    0x18(%eax),%eax
80105525:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105528:	8d 50 ff             	lea    -0x1(%eax),%edx
8010552b:	83 fa 1f             	cmp    $0x1f,%edx
8010552e:	77 20                	ja     80105550 <syscall+0x40>
80105530:	8b 14 85 e0 88 10 80 	mov    -0x7fef7720(,%eax,4),%edx
80105537:	85 d2                	test   %edx,%edx
80105539:	74 15                	je     80105550 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010553b:	ff d2                	call   *%edx
8010553d:	89 c2                	mov    %eax,%edx
8010553f:	8b 43 18             	mov    0x18(%ebx),%eax
80105542:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105545:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105548:	c9                   	leave  
80105549:	c3                   	ret    
8010554a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105550:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105551:	8d 43 78             	lea    0x78(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105554:	50                   	push   %eax
80105555:	ff 73 10             	pushl  0x10(%ebx)
80105558:	68 b1 88 10 80       	push   $0x801088b1
8010555d:	e8 4e b1 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105562:	8b 43 18             	mov    0x18(%ebx),%eax
80105565:	83 c4 10             	add    $0x10,%esp
80105568:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010556f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105572:	c9                   	leave  
80105573:	c3                   	ret    
80105574:	66 90                	xchg   %ax,%ax
80105576:	66 90                	xchg   %ax,%ax
80105578:	66 90                	xchg   %ax,%ax
8010557a:	66 90                	xchg   %ax,%ax
8010557c:	66 90                	xchg   %ax,%ax
8010557e:	66 90                	xchg   %ax,%ax

80105580 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	57                   	push   %edi
80105584:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
80105585:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105588:	53                   	push   %ebx
80105589:	83 ec 34             	sub    $0x34,%esp
8010558c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010558f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if ((dp = nameiparent(path, name)) == 0)
80105592:	57                   	push   %edi
80105593:	50                   	push   %eax
{
80105594:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105597:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if ((dp = nameiparent(path, name)) == 0)
8010559a:	e8 b1 ca ff ff       	call   80102050 <nameiparent>
8010559f:	83 c4 10             	add    $0x10,%esp
801055a2:	85 c0                	test   %eax,%eax
801055a4:	0f 84 46 01 00 00    	je     801056f0 <create+0x170>
    return 0;
  ilock(dp);
801055aa:	83 ec 0c             	sub    $0xc,%esp
801055ad:	89 c3                	mov    %eax,%ebx
801055af:	50                   	push   %eax
801055b0:	e8 ab c1 ff ff       	call   80101760 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
801055b5:	83 c4 0c             	add    $0xc,%esp
801055b8:	6a 00                	push   $0x0
801055ba:	57                   	push   %edi
801055bb:	53                   	push   %ebx
801055bc:	e8 ef c6 ff ff       	call   80101cb0 <dirlookup>
801055c1:	83 c4 10             	add    $0x10,%esp
801055c4:	89 c6                	mov    %eax,%esi
801055c6:	85 c0                	test   %eax,%eax
801055c8:	74 56                	je     80105620 <create+0xa0>
  {
    iunlockput(dp);
801055ca:	83 ec 0c             	sub    $0xc,%esp
801055cd:	53                   	push   %ebx
801055ce:	e8 2d c4 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
801055d3:	89 34 24             	mov    %esi,(%esp)
801055d6:	e8 85 c1 ff ff       	call   80101760 <ilock>
    if (type == T_FILE && ip->type == T_FILE)
801055db:	83 c4 10             	add    $0x10,%esp
801055de:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801055e3:	75 1b                	jne    80105600 <create+0x80>
801055e5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801055ea:	75 14                	jne    80105600 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801055ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055ef:	89 f0                	mov    %esi,%eax
801055f1:	5b                   	pop    %ebx
801055f2:	5e                   	pop    %esi
801055f3:	5f                   	pop    %edi
801055f4:	5d                   	pop    %ebp
801055f5:	c3                   	ret    
801055f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055fd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105600:	83 ec 0c             	sub    $0xc,%esp
80105603:	56                   	push   %esi
    return 0;
80105604:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105606:	e8 f5 c3 ff ff       	call   80101a00 <iunlockput>
    return 0;
8010560b:	83 c4 10             	add    $0x10,%esp
}
8010560e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105611:	89 f0                	mov    %esi,%eax
80105613:	5b                   	pop    %ebx
80105614:	5e                   	pop    %esi
80105615:	5f                   	pop    %edi
80105616:	5d                   	pop    %ebp
80105617:	c3                   	ret    
80105618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010561f:	90                   	nop
  if ((ip = ialloc(dp->dev, type)) == 0)
80105620:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105624:	83 ec 08             	sub    $0x8,%esp
80105627:	50                   	push   %eax
80105628:	ff 33                	pushl  (%ebx)
8010562a:	e8 b1 bf ff ff       	call   801015e0 <ialloc>
8010562f:	83 c4 10             	add    $0x10,%esp
80105632:	89 c6                	mov    %eax,%esi
80105634:	85 c0                	test   %eax,%eax
80105636:	0f 84 cd 00 00 00    	je     80105709 <create+0x189>
  ilock(ip);
8010563c:	83 ec 0c             	sub    $0xc,%esp
8010563f:	50                   	push   %eax
80105640:	e8 1b c1 ff ff       	call   80101760 <ilock>
  ip->major = major;
80105645:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105649:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010564d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105651:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105655:	b8 01 00 00 00       	mov    $0x1,%eax
8010565a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010565e:	89 34 24             	mov    %esi,(%esp)
80105661:	e8 3a c0 ff ff       	call   801016a0 <iupdate>
  if (type == T_DIR)
80105666:	83 c4 10             	add    $0x10,%esp
80105669:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010566e:	74 30                	je     801056a0 <create+0x120>
  if (dirlink(dp, name, ip->inum) < 0)
80105670:	83 ec 04             	sub    $0x4,%esp
80105673:	ff 76 04             	pushl  0x4(%esi)
80105676:	57                   	push   %edi
80105677:	53                   	push   %ebx
80105678:	e8 f3 c8 ff ff       	call   80101f70 <dirlink>
8010567d:	83 c4 10             	add    $0x10,%esp
80105680:	85 c0                	test   %eax,%eax
80105682:	78 78                	js     801056fc <create+0x17c>
  iunlockput(dp);
80105684:	83 ec 0c             	sub    $0xc,%esp
80105687:	53                   	push   %ebx
80105688:	e8 73 c3 ff ff       	call   80101a00 <iunlockput>
  return ip;
8010568d:	83 c4 10             	add    $0x10,%esp
}
80105690:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105693:	89 f0                	mov    %esi,%eax
80105695:	5b                   	pop    %ebx
80105696:	5e                   	pop    %esi
80105697:	5f                   	pop    %edi
80105698:	5d                   	pop    %ebp
80105699:	c3                   	ret    
8010569a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801056a0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++; // for ".."
801056a3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801056a8:	53                   	push   %ebx
801056a9:	e8 f2 bf ff ff       	call   801016a0 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801056ae:	83 c4 0c             	add    $0xc,%esp
801056b1:	ff 76 04             	pushl  0x4(%esi)
801056b4:	68 80 89 10 80       	push   $0x80108980
801056b9:	56                   	push   %esi
801056ba:	e8 b1 c8 ff ff       	call   80101f70 <dirlink>
801056bf:	83 c4 10             	add    $0x10,%esp
801056c2:	85 c0                	test   %eax,%eax
801056c4:	78 18                	js     801056de <create+0x15e>
801056c6:	83 ec 04             	sub    $0x4,%esp
801056c9:	ff 73 04             	pushl  0x4(%ebx)
801056cc:	68 7f 89 10 80       	push   $0x8010897f
801056d1:	56                   	push   %esi
801056d2:	e8 99 c8 ff ff       	call   80101f70 <dirlink>
801056d7:	83 c4 10             	add    $0x10,%esp
801056da:	85 c0                	test   %eax,%eax
801056dc:	79 92                	jns    80105670 <create+0xf0>
      panic("create dots");
801056de:	83 ec 0c             	sub    $0xc,%esp
801056e1:	68 73 89 10 80       	push   $0x80108973
801056e6:	e8 a5 ac ff ff       	call   80100390 <panic>
801056eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056ef:	90                   	nop
}
801056f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801056f3:	31 f6                	xor    %esi,%esi
}
801056f5:	5b                   	pop    %ebx
801056f6:	89 f0                	mov    %esi,%eax
801056f8:	5e                   	pop    %esi
801056f9:	5f                   	pop    %edi
801056fa:	5d                   	pop    %ebp
801056fb:	c3                   	ret    
    panic("create: dirlink");
801056fc:	83 ec 0c             	sub    $0xc,%esp
801056ff:	68 82 89 10 80       	push   $0x80108982
80105704:	e8 87 ac ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105709:	83 ec 0c             	sub    $0xc,%esp
8010570c:	68 64 89 10 80       	push   $0x80108964
80105711:	e8 7a ac ff ff       	call   80100390 <panic>
80105716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571d:	8d 76 00             	lea    0x0(%esi),%esi

80105720 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	56                   	push   %esi
80105724:	89 d6                	mov    %edx,%esi
80105726:	53                   	push   %ebx
80105727:	89 c3                	mov    %eax,%ebx
  if (argint(n, &fd) < 0)
80105729:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010572c:	83 ec 18             	sub    $0x18,%esp
  if (argint(n, &fd) < 0)
8010572f:	50                   	push   %eax
80105730:	6a 00                	push   $0x0
80105732:	e8 99 fc ff ff       	call   801053d0 <argint>
80105737:	83 c4 10             	add    $0x10,%esp
8010573a:	85 c0                	test   %eax,%eax
8010573c:	78 2a                	js     80105768 <argfd.constprop.0+0x48>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010573e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105742:	77 24                	ja     80105768 <argfd.constprop.0+0x48>
80105744:	e8 a7 e3 ff ff       	call   80103af0 <myproc>
80105749:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010574c:	8b 44 90 34          	mov    0x34(%eax,%edx,4),%eax
80105750:	85 c0                	test   %eax,%eax
80105752:	74 14                	je     80105768 <argfd.constprop.0+0x48>
  if (pfd)
80105754:	85 db                	test   %ebx,%ebx
80105756:	74 02                	je     8010575a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105758:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010575a:	89 06                	mov    %eax,(%esi)
  return 0;
8010575c:	31 c0                	xor    %eax,%eax
}
8010575e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105761:	5b                   	pop    %ebx
80105762:	5e                   	pop    %esi
80105763:	5d                   	pop    %ebp
80105764:	c3                   	ret    
80105765:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105768:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010576d:	eb ef                	jmp    8010575e <argfd.constprop.0+0x3e>
8010576f:	90                   	nop

80105770 <sys_dup>:
{
80105770:	f3 0f 1e fb          	endbr32 
80105774:	55                   	push   %ebp
  if (argfd(0, 0, &f) < 0)
80105775:	31 c0                	xor    %eax,%eax
{
80105777:	89 e5                	mov    %esp,%ebp
80105779:	56                   	push   %esi
8010577a:	53                   	push   %ebx
  if (argfd(0, 0, &f) < 0)
8010577b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010577e:	83 ec 10             	sub    $0x10,%esp
  if (argfd(0, 0, &f) < 0)
80105781:	e8 9a ff ff ff       	call   80105720 <argfd.constprop.0>
80105786:	85 c0                	test   %eax,%eax
80105788:	78 1e                	js     801057a8 <sys_dup+0x38>
  if ((fd = fdalloc(f)) < 0)
8010578a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for (fd = 0; fd < NOFILE; fd++)
8010578d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010578f:	e8 5c e3 ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd] == 0)
80105798:	8b 54 98 34          	mov    0x34(%eax,%ebx,4),%edx
8010579c:	85 d2                	test   %edx,%edx
8010579e:	74 20                	je     801057c0 <sys_dup+0x50>
  for (fd = 0; fd < NOFILE; fd++)
801057a0:	83 c3 01             	add    $0x1,%ebx
801057a3:	83 fb 10             	cmp    $0x10,%ebx
801057a6:	75 f0                	jne    80105798 <sys_dup+0x28>
}
801057a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801057ab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801057b0:	89 d8                	mov    %ebx,%eax
801057b2:	5b                   	pop    %ebx
801057b3:	5e                   	pop    %esi
801057b4:	5d                   	pop    %ebp
801057b5:	c3                   	ret    
801057b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057bd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801057c0:	89 74 98 34          	mov    %esi,0x34(%eax,%ebx,4)
  filedup(f);
801057c4:	83 ec 0c             	sub    $0xc,%esp
801057c7:	ff 75 f4             	pushl  -0xc(%ebp)
801057ca:	e8 a1 b6 ff ff       	call   80100e70 <filedup>
  return fd;
801057cf:	83 c4 10             	add    $0x10,%esp
}
801057d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057d5:	89 d8                	mov    %ebx,%eax
801057d7:	5b                   	pop    %ebx
801057d8:	5e                   	pop    %esi
801057d9:	5d                   	pop    %ebp
801057da:	c3                   	ret    
801057db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057df:	90                   	nop

801057e0 <sys_read>:
{
801057e0:	f3 0f 1e fb          	endbr32 
801057e4:	55                   	push   %ebp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057e5:	31 c0                	xor    %eax,%eax
{
801057e7:	89 e5                	mov    %esp,%ebp
801057e9:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057ec:	8d 55 ec             	lea    -0x14(%ebp),%edx
801057ef:	e8 2c ff ff ff       	call   80105720 <argfd.constprop.0>
801057f4:	85 c0                	test   %eax,%eax
801057f6:	78 48                	js     80105840 <sys_read+0x60>
801057f8:	83 ec 08             	sub    $0x8,%esp
801057fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057fe:	50                   	push   %eax
801057ff:	6a 02                	push   $0x2
80105801:	e8 ca fb ff ff       	call   801053d0 <argint>
80105806:	83 c4 10             	add    $0x10,%esp
80105809:	85 c0                	test   %eax,%eax
8010580b:	78 33                	js     80105840 <sys_read+0x60>
8010580d:	83 ec 04             	sub    $0x4,%esp
80105810:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105813:	ff 75 f0             	pushl  -0x10(%ebp)
80105816:	50                   	push   %eax
80105817:	6a 01                	push   $0x1
80105819:	e8 52 fc ff ff       	call   80105470 <argptr>
8010581e:	83 c4 10             	add    $0x10,%esp
80105821:	85 c0                	test   %eax,%eax
80105823:	78 1b                	js     80105840 <sys_read+0x60>
  return fileread(f, p, n);
80105825:	83 ec 04             	sub    $0x4,%esp
80105828:	ff 75 f0             	pushl  -0x10(%ebp)
8010582b:	ff 75 f4             	pushl  -0xc(%ebp)
8010582e:	ff 75 ec             	pushl  -0x14(%ebp)
80105831:	e8 ba b7 ff ff       	call   80100ff0 <fileread>
80105836:	83 c4 10             	add    $0x10,%esp
}
80105839:	c9                   	leave  
8010583a:	c3                   	ret    
8010583b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010583f:	90                   	nop
80105840:	c9                   	leave  
    return -1;
80105841:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105846:	c3                   	ret    
80105847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584e:	66 90                	xchg   %ax,%ax

80105850 <sys_write>:
{
80105850:	f3 0f 1e fb          	endbr32 
80105854:	55                   	push   %ebp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105855:	31 c0                	xor    %eax,%eax
{
80105857:	89 e5                	mov    %esp,%ebp
80105859:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010585c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010585f:	e8 bc fe ff ff       	call   80105720 <argfd.constprop.0>
80105864:	85 c0                	test   %eax,%eax
80105866:	78 48                	js     801058b0 <sys_write+0x60>
80105868:	83 ec 08             	sub    $0x8,%esp
8010586b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010586e:	50                   	push   %eax
8010586f:	6a 02                	push   $0x2
80105871:	e8 5a fb ff ff       	call   801053d0 <argint>
80105876:	83 c4 10             	add    $0x10,%esp
80105879:	85 c0                	test   %eax,%eax
8010587b:	78 33                	js     801058b0 <sys_write+0x60>
8010587d:	83 ec 04             	sub    $0x4,%esp
80105880:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105883:	ff 75 f0             	pushl  -0x10(%ebp)
80105886:	50                   	push   %eax
80105887:	6a 01                	push   $0x1
80105889:	e8 e2 fb ff ff       	call   80105470 <argptr>
8010588e:	83 c4 10             	add    $0x10,%esp
80105891:	85 c0                	test   %eax,%eax
80105893:	78 1b                	js     801058b0 <sys_write+0x60>
  return filewrite(f, p, n);
80105895:	83 ec 04             	sub    $0x4,%esp
80105898:	ff 75 f0             	pushl  -0x10(%ebp)
8010589b:	ff 75 f4             	pushl  -0xc(%ebp)
8010589e:	ff 75 ec             	pushl  -0x14(%ebp)
801058a1:	e8 ea b7 ff ff       	call   80101090 <filewrite>
801058a6:	83 c4 10             	add    $0x10,%esp
}
801058a9:	c9                   	leave  
801058aa:	c3                   	ret    
801058ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058af:	90                   	nop
801058b0:	c9                   	leave  
    return -1;
801058b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058b6:	c3                   	ret    
801058b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058be:	66 90                	xchg   %ax,%ax

801058c0 <sys_close>:
{
801058c0:	f3 0f 1e fb          	endbr32 
801058c4:	55                   	push   %ebp
801058c5:	89 e5                	mov    %esp,%ebp
801058c7:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, &fd, &f) < 0)
801058ca:	8d 55 f4             	lea    -0xc(%ebp),%edx
801058cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058d0:	e8 4b fe ff ff       	call   80105720 <argfd.constprop.0>
801058d5:	85 c0                	test   %eax,%eax
801058d7:	78 27                	js     80105900 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801058d9:	e8 12 e2 ff ff       	call   80103af0 <myproc>
801058de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801058e1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801058e4:	c7 44 90 34 00 00 00 	movl   $0x0,0x34(%eax,%edx,4)
801058eb:	00 
  fileclose(f);
801058ec:	ff 75 f4             	pushl  -0xc(%ebp)
801058ef:	e8 cc b5 ff ff       	call   80100ec0 <fileclose>
  return 0;
801058f4:	83 c4 10             	add    $0x10,%esp
801058f7:	31 c0                	xor    %eax,%eax
}
801058f9:	c9                   	leave  
801058fa:	c3                   	ret    
801058fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058ff:	90                   	nop
80105900:	c9                   	leave  
    return -1;
80105901:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105906:	c3                   	ret    
80105907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590e:	66 90                	xchg   %ax,%ax

80105910 <sys_fstat>:
{
80105910:	f3 0f 1e fb          	endbr32 
80105914:	55                   	push   %ebp
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
80105915:	31 c0                	xor    %eax,%eax
{
80105917:	89 e5                	mov    %esp,%ebp
80105919:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
8010591c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010591f:	e8 fc fd ff ff       	call   80105720 <argfd.constprop.0>
80105924:	85 c0                	test   %eax,%eax
80105926:	78 30                	js     80105958 <sys_fstat+0x48>
80105928:	83 ec 04             	sub    $0x4,%esp
8010592b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010592e:	6a 14                	push   $0x14
80105930:	50                   	push   %eax
80105931:	6a 01                	push   $0x1
80105933:	e8 38 fb ff ff       	call   80105470 <argptr>
80105938:	83 c4 10             	add    $0x10,%esp
8010593b:	85 c0                	test   %eax,%eax
8010593d:	78 19                	js     80105958 <sys_fstat+0x48>
  return filestat(f, st);
8010593f:	83 ec 08             	sub    $0x8,%esp
80105942:	ff 75 f4             	pushl  -0xc(%ebp)
80105945:	ff 75 f0             	pushl  -0x10(%ebp)
80105948:	e8 53 b6 ff ff       	call   80100fa0 <filestat>
8010594d:	83 c4 10             	add    $0x10,%esp
}
80105950:	c9                   	leave  
80105951:	c3                   	ret    
80105952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105958:	c9                   	leave  
    return -1;
80105959:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010595e:	c3                   	ret    
8010595f:	90                   	nop

80105960 <sys_link>:
{
80105960:	f3 0f 1e fb          	endbr32 
80105964:	55                   	push   %ebp
80105965:	89 e5                	mov    %esp,%ebp
80105967:	57                   	push   %edi
80105968:	56                   	push   %esi
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105969:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010596c:	53                   	push   %ebx
8010596d:	83 ec 34             	sub    $0x34,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105970:	50                   	push   %eax
80105971:	6a 00                	push   $0x0
80105973:	e8 58 fb ff ff       	call   801054d0 <argstr>
80105978:	83 c4 10             	add    $0x10,%esp
8010597b:	85 c0                	test   %eax,%eax
8010597d:	0f 88 ff 00 00 00    	js     80105a82 <sys_link+0x122>
80105983:	83 ec 08             	sub    $0x8,%esp
80105986:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105989:	50                   	push   %eax
8010598a:	6a 01                	push   $0x1
8010598c:	e8 3f fb ff ff       	call   801054d0 <argstr>
80105991:	83 c4 10             	add    $0x10,%esp
80105994:	85 c0                	test   %eax,%eax
80105996:	0f 88 e6 00 00 00    	js     80105a82 <sys_link+0x122>
  begin_op();
8010599c:	e8 8f d3 ff ff       	call   80102d30 <begin_op>
  if ((ip = namei(old)) == 0)
801059a1:	83 ec 0c             	sub    $0xc,%esp
801059a4:	ff 75 d4             	pushl  -0x2c(%ebp)
801059a7:	e8 84 c6 ff ff       	call   80102030 <namei>
801059ac:	83 c4 10             	add    $0x10,%esp
801059af:	89 c3                	mov    %eax,%ebx
801059b1:	85 c0                	test   %eax,%eax
801059b3:	0f 84 e8 00 00 00    	je     80105aa1 <sys_link+0x141>
  ilock(ip);
801059b9:	83 ec 0c             	sub    $0xc,%esp
801059bc:	50                   	push   %eax
801059bd:	e8 9e bd ff ff       	call   80101760 <ilock>
  if (ip->type == T_DIR)
801059c2:	83 c4 10             	add    $0x10,%esp
801059c5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059ca:	0f 84 b9 00 00 00    	je     80105a89 <sys_link+0x129>
  iupdate(ip);
801059d0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801059d3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if ((dp = nameiparent(new, name)) == 0)
801059d8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801059db:	53                   	push   %ebx
801059dc:	e8 bf bc ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
801059e1:	89 1c 24             	mov    %ebx,(%esp)
801059e4:	e8 57 be ff ff       	call   80101840 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
801059e9:	58                   	pop    %eax
801059ea:	5a                   	pop    %edx
801059eb:	57                   	push   %edi
801059ec:	ff 75 d0             	pushl  -0x30(%ebp)
801059ef:	e8 5c c6 ff ff       	call   80102050 <nameiparent>
801059f4:	83 c4 10             	add    $0x10,%esp
801059f7:	89 c6                	mov    %eax,%esi
801059f9:	85 c0                	test   %eax,%eax
801059fb:	74 5f                	je     80105a5c <sys_link+0xfc>
  ilock(dp);
801059fd:	83 ec 0c             	sub    $0xc,%esp
80105a00:	50                   	push   %eax
80105a01:	e8 5a bd ff ff       	call   80101760 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
80105a06:	8b 03                	mov    (%ebx),%eax
80105a08:	83 c4 10             	add    $0x10,%esp
80105a0b:	39 06                	cmp    %eax,(%esi)
80105a0d:	75 41                	jne    80105a50 <sys_link+0xf0>
80105a0f:	83 ec 04             	sub    $0x4,%esp
80105a12:	ff 73 04             	pushl  0x4(%ebx)
80105a15:	57                   	push   %edi
80105a16:	56                   	push   %esi
80105a17:	e8 54 c5 ff ff       	call   80101f70 <dirlink>
80105a1c:	83 c4 10             	add    $0x10,%esp
80105a1f:	85 c0                	test   %eax,%eax
80105a21:	78 2d                	js     80105a50 <sys_link+0xf0>
  iunlockput(dp);
80105a23:	83 ec 0c             	sub    $0xc,%esp
80105a26:	56                   	push   %esi
80105a27:	e8 d4 bf ff ff       	call   80101a00 <iunlockput>
  iput(ip);
80105a2c:	89 1c 24             	mov    %ebx,(%esp)
80105a2f:	e8 5c be ff ff       	call   80101890 <iput>
  end_op();
80105a34:	e8 67 d3 ff ff       	call   80102da0 <end_op>
  return 0;
80105a39:	83 c4 10             	add    $0x10,%esp
80105a3c:	31 c0                	xor    %eax,%eax
}
80105a3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a41:	5b                   	pop    %ebx
80105a42:	5e                   	pop    %esi
80105a43:	5f                   	pop    %edi
80105a44:	5d                   	pop    %ebp
80105a45:	c3                   	ret    
80105a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105a50:	83 ec 0c             	sub    $0xc,%esp
80105a53:	56                   	push   %esi
80105a54:	e8 a7 bf ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105a59:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105a5c:	83 ec 0c             	sub    $0xc,%esp
80105a5f:	53                   	push   %ebx
80105a60:	e8 fb bc ff ff       	call   80101760 <ilock>
  ip->nlink--;
80105a65:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a6a:	89 1c 24             	mov    %ebx,(%esp)
80105a6d:	e8 2e bc ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105a72:	89 1c 24             	mov    %ebx,(%esp)
80105a75:	e8 86 bf ff ff       	call   80101a00 <iunlockput>
  end_op();
80105a7a:	e8 21 d3 ff ff       	call   80102da0 <end_op>
  return -1;
80105a7f:	83 c4 10             	add    $0x10,%esp
80105a82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a87:	eb b5                	jmp    80105a3e <sys_link+0xde>
    iunlockput(ip);
80105a89:	83 ec 0c             	sub    $0xc,%esp
80105a8c:	53                   	push   %ebx
80105a8d:	e8 6e bf ff ff       	call   80101a00 <iunlockput>
    end_op();
80105a92:	e8 09 d3 ff ff       	call   80102da0 <end_op>
    return -1;
80105a97:	83 c4 10             	add    $0x10,%esp
80105a9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a9f:	eb 9d                	jmp    80105a3e <sys_link+0xde>
    end_op();
80105aa1:	e8 fa d2 ff ff       	call   80102da0 <end_op>
    return -1;
80105aa6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aab:	eb 91                	jmp    80105a3e <sys_link+0xde>
80105aad:	8d 76 00             	lea    0x0(%esi),%esi

80105ab0 <sys_unlink>:
{
80105ab0:	f3 0f 1e fb          	endbr32 
80105ab4:	55                   	push   %ebp
80105ab5:	89 e5                	mov    %esp,%ebp
80105ab7:	57                   	push   %edi
80105ab8:	56                   	push   %esi
  if (argstr(0, &path) < 0)
80105ab9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105abc:	53                   	push   %ebx
80105abd:	83 ec 54             	sub    $0x54,%esp
  if (argstr(0, &path) < 0)
80105ac0:	50                   	push   %eax
80105ac1:	6a 00                	push   $0x0
80105ac3:	e8 08 fa ff ff       	call   801054d0 <argstr>
80105ac8:	83 c4 10             	add    $0x10,%esp
80105acb:	85 c0                	test   %eax,%eax
80105acd:	0f 88 7d 01 00 00    	js     80105c50 <sys_unlink+0x1a0>
  begin_op();
80105ad3:	e8 58 d2 ff ff       	call   80102d30 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
80105ad8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105adb:	83 ec 08             	sub    $0x8,%esp
80105ade:	53                   	push   %ebx
80105adf:	ff 75 c0             	pushl  -0x40(%ebp)
80105ae2:	e8 69 c5 ff ff       	call   80102050 <nameiparent>
80105ae7:	83 c4 10             	add    $0x10,%esp
80105aea:	89 c6                	mov    %eax,%esi
80105aec:	85 c0                	test   %eax,%eax
80105aee:	0f 84 66 01 00 00    	je     80105c5a <sys_unlink+0x1aa>
  ilock(dp);
80105af4:	83 ec 0c             	sub    $0xc,%esp
80105af7:	50                   	push   %eax
80105af8:	e8 63 bc ff ff       	call   80101760 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105afd:	58                   	pop    %eax
80105afe:	5a                   	pop    %edx
80105aff:	68 80 89 10 80       	push   $0x80108980
80105b04:	53                   	push   %ebx
80105b05:	e8 86 c1 ff ff       	call   80101c90 <namecmp>
80105b0a:	83 c4 10             	add    $0x10,%esp
80105b0d:	85 c0                	test   %eax,%eax
80105b0f:	0f 84 03 01 00 00    	je     80105c18 <sys_unlink+0x168>
80105b15:	83 ec 08             	sub    $0x8,%esp
80105b18:	68 7f 89 10 80       	push   $0x8010897f
80105b1d:	53                   	push   %ebx
80105b1e:	e8 6d c1 ff ff       	call   80101c90 <namecmp>
80105b23:	83 c4 10             	add    $0x10,%esp
80105b26:	85 c0                	test   %eax,%eax
80105b28:	0f 84 ea 00 00 00    	je     80105c18 <sys_unlink+0x168>
  if ((ip = dirlookup(dp, name, &off)) == 0)
80105b2e:	83 ec 04             	sub    $0x4,%esp
80105b31:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105b34:	50                   	push   %eax
80105b35:	53                   	push   %ebx
80105b36:	56                   	push   %esi
80105b37:	e8 74 c1 ff ff       	call   80101cb0 <dirlookup>
80105b3c:	83 c4 10             	add    $0x10,%esp
80105b3f:	89 c3                	mov    %eax,%ebx
80105b41:	85 c0                	test   %eax,%eax
80105b43:	0f 84 cf 00 00 00    	je     80105c18 <sys_unlink+0x168>
  ilock(ip);
80105b49:	83 ec 0c             	sub    $0xc,%esp
80105b4c:	50                   	push   %eax
80105b4d:	e8 0e bc ff ff       	call   80101760 <ilock>
  if (ip->nlink < 1)
80105b52:	83 c4 10             	add    $0x10,%esp
80105b55:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105b5a:	0f 8e 23 01 00 00    	jle    80105c83 <sys_unlink+0x1d3>
  if (ip->type == T_DIR && !isdirempty(ip))
80105b60:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b65:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105b68:	74 66                	je     80105bd0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105b6a:	83 ec 04             	sub    $0x4,%esp
80105b6d:	6a 10                	push   $0x10
80105b6f:	6a 00                	push   $0x0
80105b71:	57                   	push   %edi
80105b72:	e8 39 f5 ff ff       	call   801050b0 <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80105b77:	6a 10                	push   $0x10
80105b79:	ff 75 c4             	pushl  -0x3c(%ebp)
80105b7c:	57                   	push   %edi
80105b7d:	56                   	push   %esi
80105b7e:	e8 dd bf ff ff       	call   80101b60 <writei>
80105b83:	83 c4 20             	add    $0x20,%esp
80105b86:	83 f8 10             	cmp    $0x10,%eax
80105b89:	0f 85 e7 00 00 00    	jne    80105c76 <sys_unlink+0x1c6>
  if (ip->type == T_DIR)
80105b8f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b94:	0f 84 96 00 00 00    	je     80105c30 <sys_unlink+0x180>
  iunlockput(dp);
80105b9a:	83 ec 0c             	sub    $0xc,%esp
80105b9d:	56                   	push   %esi
80105b9e:	e8 5d be ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105ba3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105ba8:	89 1c 24             	mov    %ebx,(%esp)
80105bab:	e8 f0 ba ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105bb0:	89 1c 24             	mov    %ebx,(%esp)
80105bb3:	e8 48 be ff ff       	call   80101a00 <iunlockput>
  end_op();
80105bb8:	e8 e3 d1 ff ff       	call   80102da0 <end_op>
  return 0;
80105bbd:	83 c4 10             	add    $0x10,%esp
80105bc0:	31 c0                	xor    %eax,%eax
}
80105bc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bc5:	5b                   	pop    %ebx
80105bc6:	5e                   	pop    %esi
80105bc7:	5f                   	pop    %edi
80105bc8:	5d                   	pop    %ebp
80105bc9:	c3                   	ret    
80105bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
80105bd0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105bd4:	76 94                	jbe    80105b6a <sys_unlink+0xba>
80105bd6:	ba 20 00 00 00       	mov    $0x20,%edx
80105bdb:	eb 0b                	jmp    80105be8 <sys_unlink+0x138>
80105bdd:	8d 76 00             	lea    0x0(%esi),%esi
80105be0:	83 c2 10             	add    $0x10,%edx
80105be3:	39 53 58             	cmp    %edx,0x58(%ebx)
80105be6:	76 82                	jbe    80105b6a <sys_unlink+0xba>
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
80105be8:	6a 10                	push   $0x10
80105bea:	52                   	push   %edx
80105beb:	57                   	push   %edi
80105bec:	53                   	push   %ebx
80105bed:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105bf0:	e8 6b be ff ff       	call   80101a60 <readi>
80105bf5:	83 c4 10             	add    $0x10,%esp
80105bf8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80105bfb:	83 f8 10             	cmp    $0x10,%eax
80105bfe:	75 69                	jne    80105c69 <sys_unlink+0x1b9>
    if (de.inum != 0)
80105c00:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105c05:	74 d9                	je     80105be0 <sys_unlink+0x130>
    iunlockput(ip);
80105c07:	83 ec 0c             	sub    $0xc,%esp
80105c0a:	53                   	push   %ebx
80105c0b:	e8 f0 bd ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105c10:	83 c4 10             	add    $0x10,%esp
80105c13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c17:	90                   	nop
  iunlockput(dp);
80105c18:	83 ec 0c             	sub    $0xc,%esp
80105c1b:	56                   	push   %esi
80105c1c:	e8 df bd ff ff       	call   80101a00 <iunlockput>
  end_op();
80105c21:	e8 7a d1 ff ff       	call   80102da0 <end_op>
  return -1;
80105c26:	83 c4 10             	add    $0x10,%esp
80105c29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c2e:	eb 92                	jmp    80105bc2 <sys_unlink+0x112>
    iupdate(dp);
80105c30:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105c33:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105c38:	56                   	push   %esi
80105c39:	e8 62 ba ff ff       	call   801016a0 <iupdate>
80105c3e:	83 c4 10             	add    $0x10,%esp
80105c41:	e9 54 ff ff ff       	jmp    80105b9a <sys_unlink+0xea>
80105c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c55:	e9 68 ff ff ff       	jmp    80105bc2 <sys_unlink+0x112>
    end_op();
80105c5a:	e8 41 d1 ff ff       	call   80102da0 <end_op>
    return -1;
80105c5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c64:	e9 59 ff ff ff       	jmp    80105bc2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105c69:	83 ec 0c             	sub    $0xc,%esp
80105c6c:	68 a4 89 10 80       	push   $0x801089a4
80105c71:	e8 1a a7 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105c76:	83 ec 0c             	sub    $0xc,%esp
80105c79:	68 b6 89 10 80       	push   $0x801089b6
80105c7e:	e8 0d a7 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105c83:	83 ec 0c             	sub    $0xc,%esp
80105c86:	68 92 89 10 80       	push   $0x80108992
80105c8b:	e8 00 a7 ff ff       	call   80100390 <panic>

80105c90 <sys_open>:

int sys_open(void)
{
80105c90:	f3 0f 1e fb          	endbr32 
80105c94:	55                   	push   %ebp
80105c95:	89 e5                	mov    %esp,%ebp
80105c97:	57                   	push   %edi
80105c98:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c99:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105c9c:	53                   	push   %ebx
80105c9d:	83 ec 24             	sub    $0x24,%esp
  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ca0:	50                   	push   %eax
80105ca1:	6a 00                	push   $0x0
80105ca3:	e8 28 f8 ff ff       	call   801054d0 <argstr>
80105ca8:	83 c4 10             	add    $0x10,%esp
80105cab:	85 c0                	test   %eax,%eax
80105cad:	0f 88 8a 00 00 00    	js     80105d3d <sys_open+0xad>
80105cb3:	83 ec 08             	sub    $0x8,%esp
80105cb6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105cb9:	50                   	push   %eax
80105cba:	6a 01                	push   $0x1
80105cbc:	e8 0f f7 ff ff       	call   801053d0 <argint>
80105cc1:	83 c4 10             	add    $0x10,%esp
80105cc4:	85 c0                	test   %eax,%eax
80105cc6:	78 75                	js     80105d3d <sys_open+0xad>
    return -1;

  begin_op();
80105cc8:	e8 63 d0 ff ff       	call   80102d30 <begin_op>

  if (omode & O_CREATE)
80105ccd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105cd1:	75 75                	jne    80105d48 <sys_open+0xb8>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(path)) == 0)
80105cd3:	83 ec 0c             	sub    $0xc,%esp
80105cd6:	ff 75 e0             	pushl  -0x20(%ebp)
80105cd9:	e8 52 c3 ff ff       	call   80102030 <namei>
80105cde:	83 c4 10             	add    $0x10,%esp
80105ce1:	89 c6                	mov    %eax,%esi
80105ce3:	85 c0                	test   %eax,%eax
80105ce5:	74 7e                	je     80105d65 <sys_open+0xd5>
    {
      end_op();
      return -1;
    }
    ilock(ip);
80105ce7:	83 ec 0c             	sub    $0xc,%esp
80105cea:	50                   	push   %eax
80105ceb:	e8 70 ba ff ff       	call   80101760 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
80105cf0:	83 c4 10             	add    $0x10,%esp
80105cf3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105cf8:	0f 84 c2 00 00 00    	je     80105dc0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80105cfe:	e8 fd b0 ff ff       	call   80100e00 <filealloc>
80105d03:	89 c7                	mov    %eax,%edi
80105d05:	85 c0                	test   %eax,%eax
80105d07:	74 23                	je     80105d2c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105d09:	e8 e2 dd ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
80105d0e:	31 db                	xor    %ebx,%ebx
    if (curproc->ofile[fd] == 0)
80105d10:	8b 54 98 34          	mov    0x34(%eax,%ebx,4),%edx
80105d14:	85 d2                	test   %edx,%edx
80105d16:	74 60                	je     80105d78 <sys_open+0xe8>
  for (fd = 0; fd < NOFILE; fd++)
80105d18:	83 c3 01             	add    $0x1,%ebx
80105d1b:	83 fb 10             	cmp    $0x10,%ebx
80105d1e:	75 f0                	jne    80105d10 <sys_open+0x80>
  {
    if (f)
      fileclose(f);
80105d20:	83 ec 0c             	sub    $0xc,%esp
80105d23:	57                   	push   %edi
80105d24:	e8 97 b1 ff ff       	call   80100ec0 <fileclose>
80105d29:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105d2c:	83 ec 0c             	sub    $0xc,%esp
80105d2f:	56                   	push   %esi
80105d30:	e8 cb bc ff ff       	call   80101a00 <iunlockput>
    end_op();
80105d35:	e8 66 d0 ff ff       	call   80102da0 <end_op>
    return -1;
80105d3a:	83 c4 10             	add    $0x10,%esp
80105d3d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d42:	eb 6d                	jmp    80105db1 <sys_open+0x121>
80105d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105d48:	83 ec 0c             	sub    $0xc,%esp
80105d4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105d4e:	31 c9                	xor    %ecx,%ecx
80105d50:	ba 02 00 00 00       	mov    $0x2,%edx
80105d55:	6a 00                	push   $0x0
80105d57:	e8 24 f8 ff ff       	call   80105580 <create>
    if (ip == 0)
80105d5c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105d5f:	89 c6                	mov    %eax,%esi
    if (ip == 0)
80105d61:	85 c0                	test   %eax,%eax
80105d63:	75 99                	jne    80105cfe <sys_open+0x6e>
      end_op();
80105d65:	e8 36 d0 ff ff       	call   80102da0 <end_op>
      return -1;
80105d6a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d6f:	eb 40                	jmp    80105db1 <sys_open+0x121>
80105d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105d78:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105d7b:	89 7c 98 34          	mov    %edi,0x34(%eax,%ebx,4)
  iunlock(ip);
80105d7f:	56                   	push   %esi
80105d80:	e8 bb ba ff ff       	call   80101840 <iunlock>
  end_op();
80105d85:	e8 16 d0 ff ff       	call   80102da0 <end_op>

  f->type = FD_INODE;
80105d8a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105d90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d93:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105d96:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105d99:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105d9b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105da2:	f7 d0                	not    %eax
80105da4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105da7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105daa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105dad:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105db1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105db4:	89 d8                	mov    %ebx,%eax
80105db6:	5b                   	pop    %ebx
80105db7:	5e                   	pop    %esi
80105db8:	5f                   	pop    %edi
80105db9:	5d                   	pop    %ebp
80105dba:	c3                   	ret    
80105dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dbf:	90                   	nop
    if (ip->type == T_DIR && omode != O_RDONLY)
80105dc0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105dc3:	85 c9                	test   %ecx,%ecx
80105dc5:	0f 84 33 ff ff ff    	je     80105cfe <sys_open+0x6e>
80105dcb:	e9 5c ff ff ff       	jmp    80105d2c <sys_open+0x9c>

80105dd0 <sys_mkdir>:

int sys_mkdir(void)
{
80105dd0:	f3 0f 1e fb          	endbr32 
80105dd4:	55                   	push   %ebp
80105dd5:	89 e5                	mov    %esp,%ebp
80105dd7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105dda:	e8 51 cf ff ff       	call   80102d30 <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
80105ddf:	83 ec 08             	sub    $0x8,%esp
80105de2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105de5:	50                   	push   %eax
80105de6:	6a 00                	push   $0x0
80105de8:	e8 e3 f6 ff ff       	call   801054d0 <argstr>
80105ded:	83 c4 10             	add    $0x10,%esp
80105df0:	85 c0                	test   %eax,%eax
80105df2:	78 34                	js     80105e28 <sys_mkdir+0x58>
80105df4:	83 ec 0c             	sub    $0xc,%esp
80105df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dfa:	31 c9                	xor    %ecx,%ecx
80105dfc:	ba 01 00 00 00       	mov    $0x1,%edx
80105e01:	6a 00                	push   $0x0
80105e03:	e8 78 f7 ff ff       	call   80105580 <create>
80105e08:	83 c4 10             	add    $0x10,%esp
80105e0b:	85 c0                	test   %eax,%eax
80105e0d:	74 19                	je     80105e28 <sys_mkdir+0x58>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e0f:	83 ec 0c             	sub    $0xc,%esp
80105e12:	50                   	push   %eax
80105e13:	e8 e8 bb ff ff       	call   80101a00 <iunlockput>
  end_op();
80105e18:	e8 83 cf ff ff       	call   80102da0 <end_op>
  return 0;
80105e1d:	83 c4 10             	add    $0x10,%esp
80105e20:	31 c0                	xor    %eax,%eax
}
80105e22:	c9                   	leave  
80105e23:	c3                   	ret    
80105e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105e28:	e8 73 cf ff ff       	call   80102da0 <end_op>
    return -1;
80105e2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e32:	c9                   	leave  
80105e33:	c3                   	ret    
80105e34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e3f:	90                   	nop

80105e40 <sys_mknod>:

int sys_mknod(void)
{
80105e40:	f3 0f 1e fb          	endbr32 
80105e44:	55                   	push   %ebp
80105e45:	89 e5                	mov    %esp,%ebp
80105e47:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105e4a:	e8 e1 ce ff ff       	call   80102d30 <begin_op>
  if ((argstr(0, &path)) < 0 ||
80105e4f:	83 ec 08             	sub    $0x8,%esp
80105e52:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e55:	50                   	push   %eax
80105e56:	6a 00                	push   $0x0
80105e58:	e8 73 f6 ff ff       	call   801054d0 <argstr>
80105e5d:	83 c4 10             	add    $0x10,%esp
80105e60:	85 c0                	test   %eax,%eax
80105e62:	78 64                	js     80105ec8 <sys_mknod+0x88>
      argint(1, &major) < 0 ||
80105e64:	83 ec 08             	sub    $0x8,%esp
80105e67:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e6a:	50                   	push   %eax
80105e6b:	6a 01                	push   $0x1
80105e6d:	e8 5e f5 ff ff       	call   801053d0 <argint>
  if ((argstr(0, &path)) < 0 ||
80105e72:	83 c4 10             	add    $0x10,%esp
80105e75:	85 c0                	test   %eax,%eax
80105e77:	78 4f                	js     80105ec8 <sys_mknod+0x88>
      argint(2, &minor) < 0 ||
80105e79:	83 ec 08             	sub    $0x8,%esp
80105e7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e7f:	50                   	push   %eax
80105e80:	6a 02                	push   $0x2
80105e82:	e8 49 f5 ff ff       	call   801053d0 <argint>
      argint(1, &major) < 0 ||
80105e87:	83 c4 10             	add    $0x10,%esp
80105e8a:	85 c0                	test   %eax,%eax
80105e8c:	78 3a                	js     80105ec8 <sys_mknod+0x88>
      (ip = create(path, T_DEV, major, minor)) == 0)
80105e8e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105e92:	83 ec 0c             	sub    $0xc,%esp
80105e95:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105e99:	ba 03 00 00 00       	mov    $0x3,%edx
80105e9e:	50                   	push   %eax
80105e9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105ea2:	e8 d9 f6 ff ff       	call   80105580 <create>
      argint(2, &minor) < 0 ||
80105ea7:	83 c4 10             	add    $0x10,%esp
80105eaa:	85 c0                	test   %eax,%eax
80105eac:	74 1a                	je     80105ec8 <sys_mknod+0x88>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80105eae:	83 ec 0c             	sub    $0xc,%esp
80105eb1:	50                   	push   %eax
80105eb2:	e8 49 bb ff ff       	call   80101a00 <iunlockput>
  end_op();
80105eb7:	e8 e4 ce ff ff       	call   80102da0 <end_op>
  return 0;
80105ebc:	83 c4 10             	add    $0x10,%esp
80105ebf:	31 c0                	xor    %eax,%eax
}
80105ec1:	c9                   	leave  
80105ec2:	c3                   	ret    
80105ec3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ec7:	90                   	nop
    end_op();
80105ec8:	e8 d3 ce ff ff       	call   80102da0 <end_op>
    return -1;
80105ecd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ed2:	c9                   	leave  
80105ed3:	c3                   	ret    
80105ed4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105edf:	90                   	nop

80105ee0 <sys_chdir>:

int sys_chdir(void)
{
80105ee0:	f3 0f 1e fb          	endbr32 
80105ee4:	55                   	push   %ebp
80105ee5:	89 e5                	mov    %esp,%ebp
80105ee7:	56                   	push   %esi
80105ee8:	53                   	push   %ebx
80105ee9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105eec:	e8 ff db ff ff       	call   80103af0 <myproc>
80105ef1:	89 c6                	mov    %eax,%esi

  begin_op();
80105ef3:	e8 38 ce ff ff       	call   80102d30 <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105ef8:	83 ec 08             	sub    $0x8,%esp
80105efb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105efe:	50                   	push   %eax
80105eff:	6a 00                	push   $0x0
80105f01:	e8 ca f5 ff ff       	call   801054d0 <argstr>
80105f06:	83 c4 10             	add    $0x10,%esp
80105f09:	85 c0                	test   %eax,%eax
80105f0b:	78 73                	js     80105f80 <sys_chdir+0xa0>
80105f0d:	83 ec 0c             	sub    $0xc,%esp
80105f10:	ff 75 f4             	pushl  -0xc(%ebp)
80105f13:	e8 18 c1 ff ff       	call   80102030 <namei>
80105f18:	83 c4 10             	add    $0x10,%esp
80105f1b:	89 c3                	mov    %eax,%ebx
80105f1d:	85 c0                	test   %eax,%eax
80105f1f:	74 5f                	je     80105f80 <sys_chdir+0xa0>
  {
    end_op();
    return -1;
  }
  ilock(ip);
80105f21:	83 ec 0c             	sub    $0xc,%esp
80105f24:	50                   	push   %eax
80105f25:	e8 36 b8 ff ff       	call   80101760 <ilock>
  if (ip->type != T_DIR)
80105f2a:	83 c4 10             	add    $0x10,%esp
80105f2d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105f32:	75 2c                	jne    80105f60 <sys_chdir+0x80>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105f34:	83 ec 0c             	sub    $0xc,%esp
80105f37:	53                   	push   %ebx
80105f38:	e8 03 b9 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
80105f3d:	58                   	pop    %eax
80105f3e:	ff 76 74             	pushl  0x74(%esi)
80105f41:	e8 4a b9 ff ff       	call   80101890 <iput>
  end_op();
80105f46:	e8 55 ce ff ff       	call   80102da0 <end_op>
  curproc->cwd = ip;
80105f4b:	89 5e 74             	mov    %ebx,0x74(%esi)
  return 0;
80105f4e:	83 c4 10             	add    $0x10,%esp
80105f51:	31 c0                	xor    %eax,%eax
}
80105f53:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f56:	5b                   	pop    %ebx
80105f57:	5e                   	pop    %esi
80105f58:	5d                   	pop    %ebp
80105f59:	c3                   	ret    
80105f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105f60:	83 ec 0c             	sub    $0xc,%esp
80105f63:	53                   	push   %ebx
80105f64:	e8 97 ba ff ff       	call   80101a00 <iunlockput>
    end_op();
80105f69:	e8 32 ce ff ff       	call   80102da0 <end_op>
    return -1;
80105f6e:	83 c4 10             	add    $0x10,%esp
80105f71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f76:	eb db                	jmp    80105f53 <sys_chdir+0x73>
80105f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7f:	90                   	nop
    end_op();
80105f80:	e8 1b ce ff ff       	call   80102da0 <end_op>
    return -1;
80105f85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f8a:	eb c7                	jmp    80105f53 <sys_chdir+0x73>
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f90 <sys_exec>:

int sys_exec(void)
{
80105f90:	f3 0f 1e fb          	endbr32 
80105f94:	55                   	push   %ebp
80105f95:	89 e5                	mov    %esp,%ebp
80105f97:	57                   	push   %edi
80105f98:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80105f99:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105f9f:	53                   	push   %ebx
80105fa0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80105fa6:	50                   	push   %eax
80105fa7:	6a 00                	push   $0x0
80105fa9:	e8 22 f5 ff ff       	call   801054d0 <argstr>
80105fae:	83 c4 10             	add    $0x10,%esp
80105fb1:	85 c0                	test   %eax,%eax
80105fb3:	0f 88 8b 00 00 00    	js     80106044 <sys_exec+0xb4>
80105fb9:	83 ec 08             	sub    $0x8,%esp
80105fbc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105fc2:	50                   	push   %eax
80105fc3:	6a 01                	push   $0x1
80105fc5:	e8 06 f4 ff ff       	call   801053d0 <argint>
80105fca:	83 c4 10             	add    $0x10,%esp
80105fcd:	85 c0                	test   %eax,%eax
80105fcf:	78 73                	js     80106044 <sys_exec+0xb4>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105fd1:	83 ec 04             	sub    $0x4,%esp
80105fd4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for (i = 0;; i++)
80105fda:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105fdc:	68 80 00 00 00       	push   $0x80
80105fe1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105fe7:	6a 00                	push   $0x0
80105fe9:	50                   	push   %eax
80105fea:	e8 c1 f0 ff ff       	call   801050b0 <memset>
80105fef:	83 c4 10             	add    $0x10,%esp
80105ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  {
    if (i >= NELEM(argv))
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80105ff8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105ffe:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106005:	83 ec 08             	sub    $0x8,%esp
80106008:	57                   	push   %edi
80106009:	01 f0                	add    %esi,%eax
8010600b:	50                   	push   %eax
8010600c:	e8 df f2 ff ff       	call   801052f0 <fetchint>
80106011:	83 c4 10             	add    $0x10,%esp
80106014:	85 c0                	test   %eax,%eax
80106016:	78 2c                	js     80106044 <sys_exec+0xb4>
      return -1;
    if (uarg == 0)
80106018:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010601e:	85 c0                	test   %eax,%eax
80106020:	74 36                	je     80106058 <sys_exec+0xc8>
    {
      argv[i] = 0;
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
80106022:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106028:	83 ec 08             	sub    $0x8,%esp
8010602b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010602e:	52                   	push   %edx
8010602f:	50                   	push   %eax
80106030:	e8 fb f2 ff ff       	call   80105330 <fetchstr>
80106035:	83 c4 10             	add    $0x10,%esp
80106038:	85 c0                	test   %eax,%eax
8010603a:	78 08                	js     80106044 <sys_exec+0xb4>
  for (i = 0;; i++)
8010603c:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
8010603f:	83 fb 20             	cmp    $0x20,%ebx
80106042:	75 b4                	jne    80105ff8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80106044:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106047:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010604c:	5b                   	pop    %ebx
8010604d:	5e                   	pop    %esi
8010604e:	5f                   	pop    %edi
8010604f:	5d                   	pop    %ebp
80106050:	c3                   	ret    
80106051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106058:	83 ec 08             	sub    $0x8,%esp
8010605b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80106061:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106068:	00 00 00 00 
  return exec(path, argv);
8010606c:	50                   	push   %eax
8010606d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80106073:	e8 08 aa ff ff       	call   80100a80 <exec>
80106078:	83 c4 10             	add    $0x10,%esp
}
8010607b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010607e:	5b                   	pop    %ebx
8010607f:	5e                   	pop    %esi
80106080:	5f                   	pop    %edi
80106081:	5d                   	pop    %ebp
80106082:	c3                   	ret    
80106083:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010608a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106090 <sys_pipe>:

int sys_pipe(void)
{
80106090:	f3 0f 1e fb          	endbr32 
80106094:	55                   	push   %ebp
80106095:	89 e5                	mov    %esp,%ebp
80106097:	57                   	push   %edi
80106098:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80106099:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010609c:	53                   	push   %ebx
8010609d:	83 ec 20             	sub    $0x20,%esp
  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
801060a0:	6a 08                	push   $0x8
801060a2:	50                   	push   %eax
801060a3:	6a 00                	push   $0x0
801060a5:	e8 c6 f3 ff ff       	call   80105470 <argptr>
801060aa:	83 c4 10             	add    $0x10,%esp
801060ad:	85 c0                	test   %eax,%eax
801060af:	78 4e                	js     801060ff <sys_pipe+0x6f>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
801060b1:	83 ec 08             	sub    $0x8,%esp
801060b4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060b7:	50                   	push   %eax
801060b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801060bb:	50                   	push   %eax
801060bc:	e8 2f d3 ff ff       	call   801033f0 <pipealloc>
801060c1:	83 c4 10             	add    $0x10,%esp
801060c4:	85 c0                	test   %eax,%eax
801060c6:	78 37                	js     801060ff <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
801060c8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for (fd = 0; fd < NOFILE; fd++)
801060cb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801060cd:	e8 1e da ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
801060d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
801060d8:	8b 74 98 34          	mov    0x34(%eax,%ebx,4),%esi
801060dc:	85 f6                	test   %esi,%esi
801060de:	74 30                	je     80106110 <sys_pipe+0x80>
  for (fd = 0; fd < NOFILE; fd++)
801060e0:	83 c3 01             	add    $0x1,%ebx
801060e3:	83 fb 10             	cmp    $0x10,%ebx
801060e6:	75 f0                	jne    801060d8 <sys_pipe+0x48>
  {
    if (fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801060e8:	83 ec 0c             	sub    $0xc,%esp
801060eb:	ff 75 e0             	pushl  -0x20(%ebp)
801060ee:	e8 cd ad ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
801060f3:	58                   	pop    %eax
801060f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801060f7:	e8 c4 ad ff ff       	call   80100ec0 <fileclose>
    return -1;
801060fc:	83 c4 10             	add    $0x10,%esp
801060ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106104:	eb 5b                	jmp    80106161 <sys_pipe+0xd1>
80106106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010610d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80106110:	8d 73 0c             	lea    0xc(%ebx),%esi
80106113:	89 7c b0 04          	mov    %edi,0x4(%eax,%esi,4)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80106117:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010611a:	e8 d1 d9 ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
8010611f:	31 d2                	xor    %edx,%edx
80106121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[fd] == 0)
80106128:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
8010612c:	85 c9                	test   %ecx,%ecx
8010612e:	74 20                	je     80106150 <sys_pipe+0xc0>
  for (fd = 0; fd < NOFILE; fd++)
80106130:	83 c2 01             	add    $0x1,%edx
80106133:	83 fa 10             	cmp    $0x10,%edx
80106136:	75 f0                	jne    80106128 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106138:	e8 b3 d9 ff ff       	call   80103af0 <myproc>
8010613d:	c7 44 b0 04 00 00 00 	movl   $0x0,0x4(%eax,%esi,4)
80106144:	00 
80106145:	eb a1                	jmp    801060e8 <sys_pipe+0x58>
80106147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106150:	89 7c 90 34          	mov    %edi,0x34(%eax,%edx,4)
  }
  fd[0] = fd0;
80106154:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106157:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106159:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010615c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010615f:	31 c0                	xor    %eax,%eax
}
80106161:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106164:	5b                   	pop    %ebx
80106165:	5e                   	pop    %esi
80106166:	5f                   	pop    %edi
80106167:	5d                   	pop    %ebp
80106168:	c3                   	ret    
80106169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106170 <sys_copy_file>:
}



int sys_copy_file(void)
{
80106170:	f3 0f 1e fb          	endbr32 
80106174:	55                   	push   %ebp
80106175:	89 e5                	mov    %esp,%ebp
80106177:	57                   	push   %edi
80106178:	56                   	push   %esi
80106179:	53                   	push   %ebx
8010617a:	81 ec 00 10 00 00    	sub    $0x1000,%esp
80106180:	83 0c 24 00          	orl    $0x0,(%esp)
80106184:	83 ec 34             	sub    $0x34,%esp
  char *dest;
  int fd;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &src) < 0 || argstr(1, &dest) < 0)
80106187:	8d 85 e0 ef ff ff    	lea    -0x1020(%ebp),%eax
8010618d:	50                   	push   %eax
8010618e:	6a 00                	push   $0x0
80106190:	e8 3b f3 ff ff       	call   801054d0 <argstr>
80106195:	83 c4 10             	add    $0x10,%esp
80106198:	85 c0                	test   %eax,%eax
8010619a:	0f 88 7d 01 00 00    	js     8010631d <sys_copy_file+0x1ad>
801061a0:	83 ec 08             	sub    $0x8,%esp
801061a3:	8d 85 e4 ef ff ff    	lea    -0x101c(%ebp),%eax
801061a9:	50                   	push   %eax
801061aa:	6a 01                	push   $0x1
801061ac:	e8 1f f3 ff ff       	call   801054d0 <argstr>
801061b1:	83 c4 10             	add    $0x10,%esp
801061b4:	85 c0                	test   %eax,%eax
801061b6:	0f 88 61 01 00 00    	js     8010631d <sys_copy_file+0x1ad>
    return -1;

  begin_op();
801061bc:	e8 6f cb ff ff       	call   80102d30 <begin_op>
      return -1;
    }
  }
  else
  {
    if ((ip = namei(src)) == 0)
801061c1:	83 ec 0c             	sub    $0xc,%esp
801061c4:	ff b5 e0 ef ff ff    	pushl  -0x1020(%ebp)
801061ca:	e8 61 be ff ff       	call   80102030 <namei>
801061cf:	83 c4 10             	add    $0x10,%esp
801061d2:	89 c6                	mov    %eax,%esi
801061d4:	85 c0                	test   %eax,%eax
801061d6:	0f 84 bc 01 00 00    	je     80106398 <sys_copy_file+0x228>
    {
      end_op();
      return -1;
    }
    ilock(ip);
801061dc:	83 ec 0c             	sub    $0xc,%esp
801061df:	50                   	push   %eax
801061e0:	e8 7b b5 ff ff       	call   80101760 <ilock>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
801061e5:	e8 16 ac ff ff       	call   80100e00 <filealloc>
801061ea:	83 c4 10             	add    $0x10,%esp
801061ed:	89 c7                	mov    %eax,%edi
801061ef:	85 c0                	test   %eax,%eax
801061f1:	74 29                	je     8010621c <sys_copy_file+0xac>
  struct proc *curproc = myproc();
801061f3:	e8 f8 d8 ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
801061f8:	31 d2                	xor    %edx,%edx
801061fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
80106200:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
80106204:	85 c9                	test   %ecx,%ecx
80106206:	74 38                	je     80106240 <sys_copy_file+0xd0>
  for (fd = 0; fd < NOFILE; fd++)
80106208:	83 c2 01             	add    $0x1,%edx
8010620b:	83 fa 10             	cmp    $0x10,%edx
8010620e:	75 f0                	jne    80106200 <sys_copy_file+0x90>
  {
    if (f)
      fileclose(f);
80106210:	83 ec 0c             	sub    $0xc,%esp
80106213:	57                   	push   %edi
80106214:	e8 a7 ac ff ff       	call   80100ec0 <fileclose>
80106219:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010621c:	83 ec 0c             	sub    $0xc,%esp
8010621f:	56                   	push   %esi
80106220:	e8 db b7 ff ff       	call   80101a00 <iunlockput>
    end_op();
80106225:	e8 76 cb ff ff       	call   80102da0 <end_op>
    return -1;
8010622a:	83 c4 10             	add    $0x10,%esp
8010622d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106232:	e9 59 01 00 00       	jmp    80106390 <sys_copy_file+0x220>
80106237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010623e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106240:	8d 5a 0c             	lea    0xc(%edx),%ebx
  }
  iunlock(ip);
80106243:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106246:	89 7c 98 04          	mov    %edi,0x4(%eax,%ebx,4)
  iunlock(ip);
8010624a:	56                   	push   %esi
8010624b:	e8 f0 b5 ff ff       	call   80101840 <iunlock>
  end_op();
80106250:	e8 4b cb ff ff       	call   80102da0 <end_op>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(O_RDONLY & O_WRONLY);
80106255:	b8 01 00 00 00       	mov    $0x1,%eax
  f->ip = ip;
8010625a:	89 77 10             	mov    %esi,0x10(%edi)
  f->type = FD_INODE;
8010625d:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->off = 0;
80106263:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(O_RDONLY & O_WRONLY);
8010626a:	66 89 47 08          	mov    %ax,0x8(%edi)
  if((f = myproc() -> ofile[fd]) == 0){
8010626e:	e8 7d d8 ff ff       	call   80103af0 <myproc>
80106273:	83 c4 10             	add    $0x10,%esp
80106276:	8b 44 98 04          	mov    0x4(%eax,%ebx,4),%eax
8010627a:	85 c0                	test   %eax,%eax
8010627c:	0f 84 9b 00 00 00    	je     8010631d <sys_copy_file+0x1ad>
  f->writable = (O_RDONLY & O_WRONLY) || (O_RDONLY & O_RDWR);
  
  char p[4096];
  if (my_argfd(0, 0, &f, fd) < 0)
      return -1;
  int read_chars = fileread(f, p, 4096);
80106282:	83 ec 04             	sub    $0x4,%esp
80106285:	8d bd e8 ef ff ff    	lea    -0x1018(%ebp),%edi
8010628b:	68 00 10 00 00       	push   $0x1000
80106290:	57                   	push   %edi
80106291:	50                   	push   %eax
80106292:	e8 59 ad ff ff       	call   80100ff0 <fileread>
80106297:	89 85 d4 ef ff ff    	mov    %eax,-0x102c(%ebp)
  //dest
  int fd2;
  struct file *f2;
  struct inode *ip2;
  begin_op();
8010629d:	e8 8e ca ff ff       	call   80102d30 <begin_op>
      return -1;
    }
  }
  else
  {
    if ((ip2 = namei(dest)) == 0)
801062a2:	58                   	pop    %eax
801062a3:	ff b5 e4 ef ff ff    	pushl  -0x101c(%ebp)
801062a9:	e8 82 bd ff ff       	call   80102030 <namei>
801062ae:	83 c4 10             	add    $0x10,%esp
801062b1:	89 c3                	mov    %eax,%ebx
801062b3:	85 c0                	test   %eax,%eax
801062b5:	0f 84 dd 00 00 00    	je     80106398 <sys_copy_file+0x228>
    {
      end_op();
      return -1;
    }
    ilock(ip2);
801062bb:	83 ec 0c             	sub    $0xc,%esp
801062be:	50                   	push   %eax
801062bf:	e8 9c b4 ff ff       	call   80101760 <ilock>
    if (ip2->type == T_DIR && dest != O_RDONLY)
801062c4:	83 c4 10             	add    $0x10,%esp
801062c7:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801062cc:	75 0a                	jne    801062d8 <sys_copy_file+0x168>
801062ce:	8b b5 e4 ef ff ff    	mov    -0x101c(%ebp),%esi
801062d4:	85 f6                	test   %esi,%esi
801062d6:	75 34                	jne    8010630c <sys_copy_file+0x19c>
      end_op();
      return -1;
    }
  }

  if ((f2 = filealloc()) == 0 || (fd2 = fdalloc(f2)) < 0)
801062d8:	e8 23 ab ff ff       	call   80100e00 <filealloc>
801062dd:	89 c6                	mov    %eax,%esi
801062df:	85 c0                	test   %eax,%eax
801062e1:	74 29                	je     8010630c <sys_copy_file+0x19c>
  struct proc *curproc = myproc();
801062e3:	e8 08 d8 ff ff       	call   80103af0 <myproc>
  for (fd = 0; fd < NOFILE; fd++)
801062e8:	31 d2                	xor    %edx,%edx
801062ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd] == 0)
801062f0:	8b 4c 90 34          	mov    0x34(%eax,%edx,4),%ecx
801062f4:	85 c9                	test   %ecx,%ecx
801062f6:	74 30                	je     80106328 <sys_copy_file+0x1b8>
  for (fd = 0; fd < NOFILE; fd++)
801062f8:	83 c2 01             	add    $0x1,%edx
801062fb:	83 fa 10             	cmp    $0x10,%edx
801062fe:	75 f0                	jne    801062f0 <sys_copy_file+0x180>
  {
    if (f2)
      fileclose(f2);
80106300:	83 ec 0c             	sub    $0xc,%esp
80106303:	56                   	push   %esi
80106304:	e8 b7 ab ff ff       	call   80100ec0 <fileclose>
80106309:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip2);
8010630c:	83 ec 0c             	sub    $0xc,%esp
8010630f:	53                   	push   %ebx
80106310:	e8 eb b6 ff ff       	call   80101a00 <iunlockput>
    end_op();
80106315:	e8 86 ca ff ff       	call   80102da0 <end_op>
    return -1;
8010631a:	83 c4 10             	add    $0x10,%esp
8010631d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106322:	eb 6c                	jmp    80106390 <sys_copy_file+0x220>
80106324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80106328:	83 c2 0c             	add    $0xc,%edx
  }
  iunlock(ip2);
8010632b:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010632e:	89 74 90 04          	mov    %esi,0x4(%eax,%edx,4)
  iunlock(ip2);
80106332:	53                   	push   %ebx
      curproc->ofile[fd] = f;
80106333:	89 95 d0 ef ff ff    	mov    %edx,-0x1030(%ebp)
  iunlock(ip2);
80106339:	e8 02 b5 ff ff       	call   80101840 <iunlock>
  end_op();
8010633e:	e8 5d ca ff ff       	call   80102da0 <end_op>

  f2->type = FD_INODE;
  f2->ip = ip2;
  f2->off = 0;
  f2->readable = !(O_WRONLY & O_WRONLY);
80106343:	b8 00 01 00 00       	mov    $0x100,%eax
  f2->ip = ip2;
80106348:	89 5e 10             	mov    %ebx,0x10(%esi)
  f2->type = FD_INODE;
8010634b:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f2->off = 0;
80106351:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f2->readable = !(O_WRONLY & O_WRONLY);
80106358:	66 89 46 08          	mov    %ax,0x8(%esi)
  if((f = myproc() -> ofile[fd]) == 0){
8010635c:	e8 8f d7 ff ff       	call   80103af0 <myproc>
80106361:	8b 95 d0 ef ff ff    	mov    -0x1030(%ebp),%edx
80106367:	83 c4 10             	add    $0x10,%esp
8010636a:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010636e:	85 c0                	test   %eax,%eax
80106370:	74 ab                	je     8010631d <sys_copy_file+0x1ad>
  f2->writable = (O_WRONLY & O_WRONLY) || (O_WRONLY & O_RDWR);
  if (my_argfd(0, 0, &f2, fd2) < 0)
      return -1;   
  int written_chars = filewrite(f2, p, read_chars);
80106372:	8b 9d d4 ef ff ff    	mov    -0x102c(%ebp),%ebx
80106378:	83 ec 04             	sub    $0x4,%esp
8010637b:	53                   	push   %ebx
8010637c:	57                   	push   %edi
8010637d:	50                   	push   %eax
8010637e:	e8 0d ad ff ff       	call   80101090 <filewrite>
  if(written_chars != read_chars){
80106383:	83 c4 10             	add    $0x10,%esp
80106386:	39 c3                	cmp    %eax,%ebx
80106388:	0f 95 c0             	setne  %al
8010638b:	0f b6 c0             	movzbl %al,%eax
8010638e:	f7 d8                	neg    %eax
    return -1;
  }
  else{
    return 0;
  }
80106390:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106393:	5b                   	pop    %ebx
80106394:	5e                   	pop    %esi
80106395:	5f                   	pop    %edi
80106396:	5d                   	pop    %ebp
80106397:	c3                   	ret    
      end_op();
80106398:	e8 03 ca ff ff       	call   80102da0 <end_op>
      return -1;
8010639d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a2:	eb ec                	jmp    80106390 <sys_copy_file+0x220>
801063a4:	66 90                	xchg   %ax,%ax
801063a6:	66 90                	xchg   %ax,%ax
801063a8:	66 90                	xchg   %ax,%ax
801063aa:	66 90                	xchg   %ax,%ax
801063ac:	66 90                	xchg   %ax,%ax
801063ae:	66 90                	xchg   %ax,%ax

801063b0 <sys_fork>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void)
{
801063b0:	f3 0f 1e fb          	endbr32 
  return fork();
801063b4:	e9 87 de ff ff       	jmp    80104240 <fork>
801063b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063c0 <sys_exit>:
}

int sys_exit(void)
{
801063c0:	f3 0f 1e fb          	endbr32 
801063c4:	55                   	push   %ebp
801063c5:	89 e5                	mov    %esp,%ebp
801063c7:	83 ec 08             	sub    $0x8,%esp
  exit();
801063ca:	e8 41 e3 ff ff       	call   80104710 <exit>
  return 0; // not reached
}
801063cf:	31 c0                	xor    %eax,%eax
801063d1:	c9                   	leave  
801063d2:	c3                   	ret    
801063d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801063e0 <sys_wait>:

int sys_wait(void)
{
801063e0:	f3 0f 1e fb          	endbr32 
  return wait();
801063e4:	e9 c7 e5 ff ff       	jmp    801049b0 <wait>
801063e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063f0 <sys_kill>:
}

int sys_kill(void)
{
801063f0:	f3 0f 1e fb          	endbr32 
801063f4:	55                   	push   %ebp
801063f5:	89 e5                	mov    %esp,%ebp
801063f7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
801063fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063fd:	50                   	push   %eax
801063fe:	6a 00                	push   $0x0
80106400:	e8 cb ef ff ff       	call   801053d0 <argint>
80106405:	83 c4 10             	add    $0x10,%esp
80106408:	85 c0                	test   %eax,%eax
8010640a:	78 14                	js     80106420 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010640c:	83 ec 0c             	sub    $0xc,%esp
8010640f:	ff 75 f4             	pushl  -0xc(%ebp)
80106412:	e8 09 e7 ff ff       	call   80104b20 <kill>
80106417:	83 c4 10             	add    $0x10,%esp
}
8010641a:	c9                   	leave  
8010641b:	c3                   	ret    
8010641c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106420:	c9                   	leave  
    return -1;
80106421:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106426:	c3                   	ret    
80106427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010642e:	66 90                	xchg   %ax,%ax

80106430 <sys_getpid>:

int sys_getpid(void)
{
80106430:	f3 0f 1e fb          	endbr32 
80106434:	55                   	push   %ebp
80106435:	89 e5                	mov    %esp,%ebp
80106437:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010643a:	e8 b1 d6 ff ff       	call   80103af0 <myproc>
8010643f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106442:	c9                   	leave  
80106443:	c3                   	ret    
80106444:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010644b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010644f:	90                   	nop

80106450 <sys_sbrk>:

int sys_sbrk(void)
{
80106450:	f3 0f 1e fb          	endbr32 
80106454:	55                   	push   %ebp
80106455:	89 e5                	mov    %esp,%ebp
80106457:	53                   	push   %ebx
  int addr;
  int n;

  if (argint(0, &n) < 0)
80106458:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010645b:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
8010645e:	50                   	push   %eax
8010645f:	6a 00                	push   $0x0
80106461:	e8 6a ef ff ff       	call   801053d0 <argint>
80106466:	83 c4 10             	add    $0x10,%esp
80106469:	85 c0                	test   %eax,%eax
8010646b:	78 23                	js     80106490 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010646d:	e8 7e d6 ff ff       	call   80103af0 <myproc>
  if (growproc(n) < 0)
80106472:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106475:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80106477:	ff 75 f4             	pushl  -0xc(%ebp)
8010647a:	e8 41 dd ff ff       	call   801041c0 <growproc>
8010647f:	83 c4 10             	add    $0x10,%esp
80106482:	85 c0                	test   %eax,%eax
80106484:	78 0a                	js     80106490 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106486:	89 d8                	mov    %ebx,%eax
80106488:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010648b:	c9                   	leave  
8010648c:	c3                   	ret    
8010648d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106490:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106495:	eb ef                	jmp    80106486 <sys_sbrk+0x36>
80106497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010649e:	66 90                	xchg   %ax,%ax

801064a0 <sys_sleep>:

int sys_sleep(void)
{
801064a0:	f3 0f 1e fb          	endbr32 
801064a4:	55                   	push   %ebp
801064a5:	89 e5                	mov    %esp,%ebp
801064a7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
801064a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801064ab:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
801064ae:	50                   	push   %eax
801064af:	6a 00                	push   $0x0
801064b1:	e8 1a ef ff ff       	call   801053d0 <argint>
801064b6:	83 c4 10             	add    $0x10,%esp
801064b9:	85 c0                	test   %eax,%eax
801064bb:	0f 88 86 00 00 00    	js     80106547 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801064c1:	83 ec 0c             	sub    $0xc,%esp
801064c4:	68 60 65 11 80       	push   $0x80116560
801064c9:	e8 d2 ea ff ff       	call   80104fa0 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
801064ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801064d1:	8b 1d a0 6d 11 80    	mov    0x80116da0,%ebx
  while (ticks - ticks0 < n)
801064d7:	83 c4 10             	add    $0x10,%esp
801064da:	85 d2                	test   %edx,%edx
801064dc:	75 23                	jne    80106501 <sys_sleep+0x61>
801064de:	eb 50                	jmp    80106530 <sys_sleep+0x90>
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801064e0:	83 ec 08             	sub    $0x8,%esp
801064e3:	68 60 65 11 80       	push   $0x80116560
801064e8:	68 a0 6d 11 80       	push   $0x80116da0
801064ed:	e8 fe e3 ff ff       	call   801048f0 <sleep>
  while (ticks - ticks0 < n)
801064f2:	a1 a0 6d 11 80       	mov    0x80116da0,%eax
801064f7:	83 c4 10             	add    $0x10,%esp
801064fa:	29 d8                	sub    %ebx,%eax
801064fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801064ff:	73 2f                	jae    80106530 <sys_sleep+0x90>
    if (myproc()->killed)
80106501:	e8 ea d5 ff ff       	call   80103af0 <myproc>
80106506:	8b 40 30             	mov    0x30(%eax),%eax
80106509:	85 c0                	test   %eax,%eax
8010650b:	74 d3                	je     801064e0 <sys_sleep+0x40>
      release(&tickslock);
8010650d:	83 ec 0c             	sub    $0xc,%esp
80106510:	68 60 65 11 80       	push   $0x80116560
80106515:	e8 46 eb ff ff       	call   80105060 <release>
  }
  release(&tickslock);
  return 0;
}
8010651a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010651d:	83 c4 10             	add    $0x10,%esp
80106520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106525:	c9                   	leave  
80106526:	c3                   	ret    
80106527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010652e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106530:	83 ec 0c             	sub    $0xc,%esp
80106533:	68 60 65 11 80       	push   $0x80116560
80106538:	e8 23 eb ff ff       	call   80105060 <release>
  return 0;
8010653d:	83 c4 10             	add    $0x10,%esp
80106540:	31 c0                	xor    %eax,%eax
}
80106542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106545:	c9                   	leave  
80106546:	c3                   	ret    
    return -1;
80106547:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010654c:	eb f4                	jmp    80106542 <sys_sleep+0xa2>
8010654e:	66 90                	xchg   %ax,%ax

80106550 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80106550:	f3 0f 1e fb          	endbr32 
80106554:	55                   	push   %ebp
80106555:	89 e5                	mov    %esp,%ebp
80106557:	53                   	push   %ebx
80106558:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010655b:	68 60 65 11 80       	push   $0x80116560
80106560:	e8 3b ea ff ff       	call   80104fa0 <acquire>
  xticks = ticks;
80106565:	8b 1d a0 6d 11 80    	mov    0x80116da0,%ebx
  release(&tickslock);
8010656b:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
80106572:	e8 e9 ea ff ff       	call   80105060 <release>
  return xticks;
}
80106577:	89 d8                	mov    %ebx,%eax
80106579:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010657c:	c9                   	leave  
8010657d:	c3                   	ret    
8010657e:	66 90                	xchg   %ax,%ax

80106580 <sys_find_digital_root>:

int sys_find_digital_root(void)
{
80106580:	f3 0f 1e fb          	endbr32 
80106584:	55                   	push   %ebp
80106585:	89 e5                	mov    %esp,%ebp
80106587:	83 ec 08             	sub    $0x8,%esp
  int number = myproc()->tf->ebx; // register after eax
8010658a:	e8 61 d5 ff ff       	call   80103af0 <myproc>
  return find_digital_root(number);
8010658f:	83 ec 0c             	sub    $0xc,%esp
  int number = myproc()->tf->ebx; // register after eax
80106592:	8b 40 18             	mov    0x18(%eax),%eax
  return find_digital_root(number);
80106595:	ff 70 10             	pushl  0x10(%eax)
80106598:	e8 f3 e6 ff ff       	call   80104c90 <find_digital_root>
}
8010659d:	c9                   	leave  
8010659e:	c3                   	ret    
8010659f:	90                   	nop

801065a0 <sys_get_uncle_count>:

int sys_get_uncle_count(void)
{
801065a0:	f3 0f 1e fb          	endbr32 
801065a4:	55                   	push   %ebp
801065a5:	89 e5                	mov    %esp,%ebp
801065a7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
801065aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065ad:	50                   	push   %eax
801065ae:	6a 00                	push   $0x0
801065b0:	e8 1b ee ff ff       	call   801053d0 <argint>
801065b5:	83 c4 10             	add    $0x10,%esp
801065b8:	85 c0                	test   %eax,%eax
801065ba:	78 24                	js     801065e0 <sys_get_uncle_count+0x40>
  {
    return -1;
  }
  struct proc *grandFather = find_proc(pid)->parent->parent;
801065bc:	83 ec 0c             	sub    $0xc,%esp
801065bf:	ff 75 f4             	pushl  -0xc(%ebp)
801065c2:	e8 09 d7 ff ff       	call   80103cd0 <find_proc>
  return count_child(grandFather) - 1;
801065c7:	5a                   	pop    %edx
  struct proc *grandFather = find_proc(pid)->parent->parent;
801065c8:	8b 40 14             	mov    0x14(%eax),%eax
  return count_child(grandFather) - 1;
801065cb:	ff 70 14             	pushl  0x14(%eax)
801065ce:	e8 8d db ff ff       	call   80104160 <count_child>
801065d3:	83 c4 10             	add    $0x10,%esp
}
801065d6:	c9                   	leave  
  return count_child(grandFather) - 1;
801065d7:	83 e8 01             	sub    $0x1,%eax
}
801065da:	c3                   	ret    
801065db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065df:	90                   	nop
801065e0:	c9                   	leave  
    return -1;
801065e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065e6:	c3                   	ret    
801065e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ee:	66 90                	xchg   %ax,%ax

801065f0 <sys_get_process_lifetime>:
int sys_get_process_lifetime(void)
{
801065f0:	f3 0f 1e fb          	endbr32 
801065f4:	55                   	push   %ebp
801065f5:	89 e5                	mov    %esp,%ebp
801065f7:	53                   	push   %ebx
  int pid;
  if (argint(0, &pid) < 0)
801065f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801065fb:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0)
801065fe:	50                   	push   %eax
801065ff:	6a 00                	push   $0x0
80106601:	e8 ca ed ff ff       	call   801053d0 <argint>
80106606:	83 c4 10             	add    $0x10,%esp
80106609:	85 c0                	test   %eax,%eax
8010660b:	78 23                	js     80106630 <sys_get_process_lifetime+0x40>
  {
    return -1;
  }
  return ticks - (find_proc(pid)->creation_time);
8010660d:	83 ec 0c             	sub    $0xc,%esp
80106610:	ff 75 f4             	pushl  -0xc(%ebp)
80106613:	8b 1d a0 6d 11 80    	mov    0x80116da0,%ebx
80106619:	e8 b2 d6 ff ff       	call   80103cd0 <find_proc>
8010661e:	83 c4 10             	add    $0x10,%esp
80106621:	2b 58 20             	sub    0x20(%eax),%ebx
80106624:	89 d8                	mov    %ebx,%eax
}
80106626:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106629:	c9                   	leave  
8010662a:	c3                   	ret    
8010662b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010662f:	90                   	nop
    return -1;
80106630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106635:	eb ef                	jmp    80106626 <sys_get_process_lifetime+0x36>
80106637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010663e:	66 90                	xchg   %ax,%ax

80106640 <sys_set_date>:
void sys_set_date(void)
{
80106640:	f3 0f 1e fb          	endbr32 
80106644:	55                   	push   %ebp
80106645:	89 e5                	mov    %esp,%ebp
80106647:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *r;
  if (argptr(0, (void *)&r, sizeof(*r)) < 0)
8010664a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010664d:	6a 18                	push   $0x18
8010664f:	50                   	push   %eax
80106650:	6a 00                	push   $0x0
80106652:	e8 19 ee ff ff       	call   80105470 <argptr>
80106657:	83 c4 10             	add    $0x10,%esp
8010665a:	85 c0                	test   %eax,%eax
8010665c:	78 12                	js     80106670 <sys_set_date+0x30>
    cprintf("Kernel: sys_set_date() has a problem.\n");

  cmostime(r);
8010665e:	83 ec 0c             	sub    $0xc,%esp
80106661:	ff 75 f4             	pushl  -0xc(%ebp)
80106664:	e8 27 c3 ff ff       	call   80102990 <cmostime>
}
80106669:	83 c4 10             	add    $0x10,%esp
8010666c:	c9                   	leave  
8010666d:	c3                   	ret    
8010666e:	66 90                	xchg   %ax,%ax
    cprintf("Kernel: sys_set_date() has a problem.\n");
80106670:	83 ec 0c             	sub    $0xc,%esp
80106673:	68 c8 89 10 80       	push   $0x801089c8
80106678:	e8 33 a0 ff ff       	call   801006b0 <cprintf>
8010667d:	83 c4 10             	add    $0x10,%esp
  cmostime(r);
80106680:	83 ec 0c             	sub    $0xc,%esp
80106683:	ff 75 f4             	pushl  -0xc(%ebp)
80106686:	e8 05 c3 ff ff       	call   80102990 <cmostime>
}
8010668b:	83 c4 10             	add    $0x10,%esp
8010668e:	c9                   	leave  
8010668f:	c3                   	ret    

80106690 <sys_get_pid>:
80106690:	f3 0f 1e fb          	endbr32 
80106694:	e9 97 fd ff ff       	jmp    80106430 <sys_getpid>
80106699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801066a0 <sys_get_parent>:
int sys_get_pid(void)
{
  return myproc()->pid;
}
int sys_get_parent(void)
{
801066a0:	f3 0f 1e fb          	endbr32 
801066a4:	55                   	push   %ebp
801066a5:	89 e5                	mov    %esp,%ebp
801066a7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
801066aa:	e8 41 d4 ff ff       	call   80103af0 <myproc>
801066af:	8b 40 14             	mov    0x14(%eax),%eax
801066b2:	8b 40 10             	mov    0x10(%eax),%eax
}
801066b5:	c9                   	leave  
801066b6:	c3                   	ret    
801066b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066be:	66 90                	xchg   %ax,%ax

801066c0 <sys_change_queue>:
int sys_change_queue(void)
{
801066c0:	f3 0f 1e fb          	endbr32 
801066c4:	55                   	push   %ebp
801066c5:	89 e5                	mov    %esp,%ebp
801066c7:	53                   	push   %ebx
  int pid, que_id;
  if (argint(0, &pid) < 0 || argint(1, &que_id))
801066c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
801066cb:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &pid) < 0 || argint(1, &que_id))
801066ce:	50                   	push   %eax
801066cf:	6a 00                	push   $0x0
801066d1:	e8 fa ec ff ff       	call   801053d0 <argint>
801066d6:	83 c4 10             	add    $0x10,%esp
801066d9:	85 c0                	test   %eax,%eax
801066db:	78 43                	js     80106720 <sys_change_queue+0x60>
801066dd:	83 ec 08             	sub    $0x8,%esp
801066e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066e3:	50                   	push   %eax
801066e4:	6a 01                	push   $0x1
801066e6:	e8 e5 ec ff ff       	call   801053d0 <argint>
801066eb:	83 c4 10             	add    $0x10,%esp
801066ee:	89 c3                	mov    %eax,%ebx
801066f0:	85 c0                	test   %eax,%eax
801066f2:	75 2c                	jne    80106720 <sys_change_queue+0x60>
    return -1;
  cprintf("%d\n", que_id);
801066f4:	83 ec 08             	sub    $0x8,%esp
801066f7:	ff 75 f4             	pushl  -0xc(%ebp)
801066fa:	68 14 86 10 80       	push   $0x80108614
801066ff:	e8 ac 9f ff ff       	call   801006b0 <cprintf>
  struct proc *p = find_proc(pid);
80106704:	58                   	pop    %eax
80106705:	ff 75 f0             	pushl  -0x10(%ebp)
80106708:	e8 c3 d5 ff ff       	call   80103cd0 <find_proc>
  p->que_id = que_id;
8010670d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  return 0;
80106710:	83 c4 10             	add    $0x10,%esp
  p->que_id = que_id;
80106713:	89 50 28             	mov    %edx,0x28(%eax)
}
80106716:	89 d8                	mov    %ebx,%eax
80106718:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010671b:	c9                   	leave  
8010671c:	c3                   	ret    
8010671d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106720:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106725:	eb ef                	jmp    80106716 <sys_change_queue+0x56>
80106727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010672e:	66 90                	xchg   %ax,%ax

80106730 <sys_bjf_validation_process>:
int sys_bjf_validation_process(void)
{
80106730:	f3 0f 1e fb          	endbr32 
80106734:	55                   	push   %ebp
80106735:	89 e5                	mov    %esp,%ebp
80106737:	83 ec 30             	sub    $0x30,%esp
  
  int pid;
  int priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argint(0, &pid) < 0 || argint(1, &priority_ratio) < 0 || argint(2, &creation_time_ratio) < 0 || argint(3, &exec_cycle_ratio) < 0 || argint(4, &size_ratio) < 0)
8010673a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010673d:	50                   	push   %eax
8010673e:	6a 00                	push   $0x0
80106740:	e8 8b ec ff ff       	call   801053d0 <argint>
80106745:	83 c4 10             	add    $0x10,%esp
80106748:	85 c0                	test   %eax,%eax
8010674a:	0f 88 90 00 00 00    	js     801067e0 <sys_bjf_validation_process+0xb0>
80106750:	83 ec 08             	sub    $0x8,%esp
80106753:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106756:	50                   	push   %eax
80106757:	6a 01                	push   $0x1
80106759:	e8 72 ec ff ff       	call   801053d0 <argint>
8010675e:	83 c4 10             	add    $0x10,%esp
80106761:	85 c0                	test   %eax,%eax
80106763:	78 7b                	js     801067e0 <sys_bjf_validation_process+0xb0>
80106765:	83 ec 08             	sub    $0x8,%esp
80106768:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010676b:	50                   	push   %eax
8010676c:	6a 02                	push   $0x2
8010676e:	e8 5d ec ff ff       	call   801053d0 <argint>
80106773:	83 c4 10             	add    $0x10,%esp
80106776:	85 c0                	test   %eax,%eax
80106778:	78 66                	js     801067e0 <sys_bjf_validation_process+0xb0>
8010677a:	83 ec 08             	sub    $0x8,%esp
8010677d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106780:	50                   	push   %eax
80106781:	6a 03                	push   $0x3
80106783:	e8 48 ec ff ff       	call   801053d0 <argint>
80106788:	83 c4 10             	add    $0x10,%esp
8010678b:	85 c0                	test   %eax,%eax
8010678d:	78 51                	js     801067e0 <sys_bjf_validation_process+0xb0>
8010678f:	83 ec 08             	sub    $0x8,%esp
80106792:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106795:	50                   	push   %eax
80106796:	6a 04                	push   $0x4
80106798:	e8 33 ec ff ff       	call   801053d0 <argint>
8010679d:	83 c4 10             	add    $0x10,%esp
801067a0:	85 c0                	test   %eax,%eax
801067a2:	78 3c                	js     801067e0 <sys_bjf_validation_process+0xb0>
  {
    return -1;
  }
  struct proc *p = find_proc(pid);
801067a4:	83 ec 0c             	sub    $0xc,%esp
801067a7:	ff 75 e4             	pushl  -0x1c(%ebp)
801067aa:	e8 21 d5 ff ff       	call   80103cd0 <find_proc>
  p->priority_ratio = (float)priority_ratio;
801067af:	db 45 e8             	fildl  -0x18(%ebp)
  p->creation_time_ratio = (float)creation_time_ratio;
  p->executed_cycle_ratio = (float)exec_cycle_ratio;
  p->process_size_ratio = (float)size_ratio;

  return 0;
801067b2:	83 c4 10             	add    $0x10,%esp
  p->priority_ratio = (float)priority_ratio;
801067b5:	d9 98 8c 00 00 00    	fstps  0x8c(%eax)
  p->creation_time_ratio = (float)creation_time_ratio;
801067bb:	db 45 ec             	fildl  -0x14(%ebp)
801067be:	d9 98 90 00 00 00    	fstps  0x90(%eax)
  p->executed_cycle_ratio = (float)exec_cycle_ratio;
801067c4:	db 45 f0             	fildl  -0x10(%ebp)
801067c7:	d9 98 98 00 00 00    	fstps  0x98(%eax)
  p->process_size_ratio = (float)size_ratio;
801067cd:	db 45 f4             	fildl  -0xc(%ebp)
801067d0:	d9 98 9c 00 00 00    	fstps  0x9c(%eax)
  return 0;
801067d6:	31 c0                	xor    %eax,%eax
}
801067d8:	c9                   	leave  
801067d9:	c3                   	ret    
801067da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801067e0:	c9                   	leave  
    return -1;
801067e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067e6:	c3                   	ret    
801067e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067ee:	66 90                	xchg   %ax,%ax

801067f0 <sys_bjf_validation_system>:
int sys_bjf_validation_system(void)
{
801067f0:	f3 0f 1e fb          	endbr32 
801067f4:	55                   	push   %ebp
801067f5:	89 e5                	mov    %esp,%ebp
801067f7:	83 ec 20             	sub    $0x20,%esp
  int priority_ratio, creation_time_ratio, exec_cycle_ratio, size_ratio;
  if (argint(0, &priority_ratio) < 0 || argint(1, &creation_time_ratio) < 0 || argint(2, &exec_cycle_ratio) < 0 || argint(3, &size_ratio) < 0)
801067fa:	8d 45 e8             	lea    -0x18(%ebp),%eax
801067fd:	50                   	push   %eax
801067fe:	6a 00                	push   $0x0
80106800:	e8 cb eb ff ff       	call   801053d0 <argint>
80106805:	83 c4 10             	add    $0x10,%esp
80106808:	85 c0                	test   %eax,%eax
8010680a:	78 6c                	js     80106878 <sys_bjf_validation_system+0x88>
8010680c:	83 ec 08             	sub    $0x8,%esp
8010680f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106812:	50                   	push   %eax
80106813:	6a 01                	push   $0x1
80106815:	e8 b6 eb ff ff       	call   801053d0 <argint>
8010681a:	83 c4 10             	add    $0x10,%esp
8010681d:	85 c0                	test   %eax,%eax
8010681f:	78 57                	js     80106878 <sys_bjf_validation_system+0x88>
80106821:	83 ec 08             	sub    $0x8,%esp
80106824:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106827:	50                   	push   %eax
80106828:	6a 02                	push   $0x2
8010682a:	e8 a1 eb ff ff       	call   801053d0 <argint>
8010682f:	83 c4 10             	add    $0x10,%esp
80106832:	85 c0                	test   %eax,%eax
80106834:	78 42                	js     80106878 <sys_bjf_validation_system+0x88>
80106836:	83 ec 08             	sub    $0x8,%esp
80106839:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010683c:	50                   	push   %eax
8010683d:	6a 03                	push   $0x3
8010683f:	e8 8c eb ff ff       	call   801053d0 <argint>
80106844:	83 c4 10             	add    $0x10,%esp
80106847:	85 c0                	test   %eax,%eax
80106849:	78 2d                	js     80106878 <sys_bjf_validation_system+0x88>
  {
    return -1;
  }
  reset_bjf_attributes((float)priority_ratio, (float)creation_time_ratio,(float) exec_cycle_ratio,(float) size_ratio);
8010684b:	db 45 f4             	fildl  -0xc(%ebp)
8010684e:	83 ec 10             	sub    $0x10,%esp
80106851:	d9 5c 24 0c          	fstps  0xc(%esp)
80106855:	db 45 f0             	fildl  -0x10(%ebp)
80106858:	d9 5c 24 08          	fstps  0x8(%esp)
8010685c:	db 45 ec             	fildl  -0x14(%ebp)
8010685f:	d9 5c 24 04          	fstps  0x4(%esp)
80106863:	db 45 e8             	fildl  -0x18(%ebp)
80106866:	d9 1c 24             	fstps  (%esp)
80106869:	e8 f2 d1 ff ff       	call   80103a60 <reset_bjf_attributes>
  return 0;
8010686e:	83 c4 10             	add    $0x10,%esp
80106871:	31 c0                	xor    %eax,%eax
}
80106873:	c9                   	leave  
80106874:	c3                   	ret    
80106875:	8d 76 00             	lea    0x0(%esi),%esi
80106878:	c9                   	leave  
    return -1;
80106879:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010687e:	c3                   	ret    
8010687f:	90                   	nop

80106880 <sys_print_info>:
int sys_print_info(void)
{
80106880:	f3 0f 1e fb          	endbr32 
80106884:	55                   	push   %ebp
80106885:	89 e5                	mov    %esp,%ebp
80106887:	83 ec 08             	sub    $0x8,%esp
  print_bitches();
8010688a:	e8 71 d5 ff ff       	call   80103e00 <print_bitches>
  return 0;
8010688f:	31 c0                	xor    %eax,%eax
80106891:	c9                   	leave  
80106892:	c3                   	ret    

80106893 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106893:	1e                   	push   %ds
  pushl %es
80106894:	06                   	push   %es
  pushl %fs
80106895:	0f a0                	push   %fs
  pushl %gs
80106897:	0f a8                	push   %gs
  pushal
80106899:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010689a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010689e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801068a0:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801068a2:	54                   	push   %esp
  call trap
801068a3:	e8 c8 00 00 00       	call   80106970 <trap>
  addl $4, %esp
801068a8:	83 c4 04             	add    $0x4,%esp

801068ab <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801068ab:	61                   	popa   
  popl %gs
801068ac:	0f a9                	pop    %gs
  popl %fs
801068ae:	0f a1                	pop    %fs
  popl %es
801068b0:	07                   	pop    %es
  popl %ds
801068b1:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801068b2:	83 c4 08             	add    $0x8,%esp
  iret
801068b5:	cf                   	iret   
801068b6:	66 90                	xchg   %ax,%ax
801068b8:	66 90                	xchg   %ax,%ax
801068ba:	66 90                	xchg   %ax,%ax
801068bc:	66 90                	xchg   %ax,%ax
801068be:	66 90                	xchg   %ax,%ax

801068c0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801068c0:	f3 0f 1e fb          	endbr32 
801068c4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801068c5:	31 c0                	xor    %eax,%eax
{
801068c7:	89 e5                	mov    %esp,%ebp
801068c9:	83 ec 08             	sub    $0x8,%esp
801068cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801068d0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801068d7:	c7 04 c5 a2 65 11 80 	movl   $0x8e000008,-0x7fee9a5e(,%eax,8)
801068de:	08 00 00 8e 
801068e2:	66 89 14 c5 a0 65 11 	mov    %dx,-0x7fee9a60(,%eax,8)
801068e9:	80 
801068ea:	c1 ea 10             	shr    $0x10,%edx
801068ed:	66 89 14 c5 a6 65 11 	mov    %dx,-0x7fee9a5a(,%eax,8)
801068f4:	80 
  for(i = 0; i < 256; i++)
801068f5:	83 c0 01             	add    $0x1,%eax
801068f8:	3d 00 01 00 00       	cmp    $0x100,%eax
801068fd:	75 d1                	jne    801068d0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801068ff:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106902:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106907:	c7 05 a2 67 11 80 08 	movl   $0xef000008,0x801167a2
8010690e:	00 00 ef 
  initlock(&tickslock, "time");
80106911:	68 ef 89 10 80       	push   $0x801089ef
80106916:	68 60 65 11 80       	push   $0x80116560
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010691b:	66 a3 a0 67 11 80    	mov    %ax,0x801167a0
80106921:	c1 e8 10             	shr    $0x10,%eax
80106924:	66 a3 a6 67 11 80    	mov    %ax,0x801167a6
  initlock(&tickslock, "time");
8010692a:	e8 f1 e4 ff ff       	call   80104e20 <initlock>
}
8010692f:	83 c4 10             	add    $0x10,%esp
80106932:	c9                   	leave  
80106933:	c3                   	ret    
80106934:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010693b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010693f:	90                   	nop

80106940 <idtinit>:

void
idtinit(void)
{
80106940:	f3 0f 1e fb          	endbr32 
80106944:	55                   	push   %ebp
  pd[0] = size-1;
80106945:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010694a:	89 e5                	mov    %esp,%ebp
8010694c:	83 ec 10             	sub    $0x10,%esp
8010694f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106953:	b8 a0 65 11 80       	mov    $0x801165a0,%eax
80106958:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010695c:	c1 e8 10             	shr    $0x10,%eax
8010695f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106963:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106966:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106969:	c9                   	leave  
8010696a:	c3                   	ret    
8010696b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010696f:	90                   	nop

80106970 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106970:	f3 0f 1e fb          	endbr32 
80106974:	55                   	push   %ebp
80106975:	89 e5                	mov    %esp,%ebp
80106977:	57                   	push   %edi
80106978:	56                   	push   %esi
80106979:	53                   	push   %ebx
8010697a:	83 ec 1c             	sub    $0x1c,%esp
8010697d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106980:	8b 43 30             	mov    0x30(%ebx),%eax
80106983:	83 f8 40             	cmp    $0x40,%eax
80106986:	0f 84 c4 01 00 00    	je     80106b50 <trap+0x1e0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010698c:	83 e8 20             	sub    $0x20,%eax
8010698f:	83 f8 1f             	cmp    $0x1f,%eax
80106992:	77 08                	ja     8010699c <trap+0x2c>
80106994:	3e ff 24 85 98 8a 10 	notrack jmp *-0x7fef7568(,%eax,4)
8010699b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010699c:	e8 4f d1 ff ff       	call   80103af0 <myproc>
801069a1:	8b 7b 38             	mov    0x38(%ebx),%edi
801069a4:	85 c0                	test   %eax,%eax
801069a6:	0f 84 f3 01 00 00    	je     80106b9f <trap+0x22f>
801069ac:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801069b0:	0f 84 e9 01 00 00    	je     80106b9f <trap+0x22f>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801069b6:	0f 20 d1             	mov    %cr2,%ecx
801069b9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069bc:	e8 1f d0 ff ff       	call   801039e0 <cpuid>
801069c1:	8b 73 30             	mov    0x30(%ebx),%esi
801069c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
801069c7:	8b 43 34             	mov    0x34(%ebx),%eax
801069ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801069cd:	e8 1e d1 ff ff       	call   80103af0 <myproc>
801069d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801069d5:	e8 16 d1 ff ff       	call   80103af0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069da:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801069dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801069e0:	51                   	push   %ecx
801069e1:	57                   	push   %edi
801069e2:	52                   	push   %edx
801069e3:	ff 75 e4             	pushl  -0x1c(%ebp)
801069e6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801069e7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801069ea:	83 c6 78             	add    $0x78,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069ed:	56                   	push   %esi
801069ee:	ff 70 10             	pushl  0x10(%eax)
801069f1:	68 54 8a 10 80       	push   $0x80108a54
801069f6:	e8 b5 9c ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801069fb:	83 c4 20             	add    $0x20,%esp
801069fe:	e8 ed d0 ff ff       	call   80103af0 <myproc>
80106a03:	c7 40 30 01 00 00 00 	movl   $0x1,0x30(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a0a:	e8 e1 d0 ff ff       	call   80103af0 <myproc>
80106a0f:	85 c0                	test   %eax,%eax
80106a11:	74 1d                	je     80106a30 <trap+0xc0>
80106a13:	e8 d8 d0 ff ff       	call   80103af0 <myproc>
80106a18:	8b 50 30             	mov    0x30(%eax),%edx
80106a1b:	85 d2                	test   %edx,%edx
80106a1d:	74 11                	je     80106a30 <trap+0xc0>
80106a1f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106a23:	83 e0 03             	and    $0x3,%eax
80106a26:	66 83 f8 03          	cmp    $0x3,%ax
80106a2a:	0f 84 58 01 00 00    	je     80106b88 <trap+0x218>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106a30:	e8 bb d0 ff ff       	call   80103af0 <myproc>
80106a35:	85 c0                	test   %eax,%eax
80106a37:	74 0f                	je     80106a48 <trap+0xd8>
80106a39:	e8 b2 d0 ff ff       	call   80103af0 <myproc>
80106a3e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106a42:	0f 84 f0 00 00 00    	je     80106b38 <trap+0x1c8>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a48:	e8 a3 d0 ff ff       	call   80103af0 <myproc>
80106a4d:	85 c0                	test   %eax,%eax
80106a4f:	74 1d                	je     80106a6e <trap+0xfe>
80106a51:	e8 9a d0 ff ff       	call   80103af0 <myproc>
80106a56:	8b 40 30             	mov    0x30(%eax),%eax
80106a59:	85 c0                	test   %eax,%eax
80106a5b:	74 11                	je     80106a6e <trap+0xfe>
80106a5d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106a61:	83 e0 03             	and    $0x3,%eax
80106a64:	66 83 f8 03          	cmp    $0x3,%ax
80106a68:	0f 84 0b 01 00 00    	je     80106b79 <trap+0x209>
    exit();
}
80106a6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a71:	5b                   	pop    %ebx
80106a72:	5e                   	pop    %esi
80106a73:	5f                   	pop    %edi
80106a74:	5d                   	pop    %ebp
80106a75:	c3                   	ret    
    ideintr();
80106a76:	e8 65 b7 ff ff       	call   801021e0 <ideintr>
    lapiceoi();
80106a7b:	e8 40 be ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a80:	e8 6b d0 ff ff       	call   80103af0 <myproc>
80106a85:	85 c0                	test   %eax,%eax
80106a87:	75 8a                	jne    80106a13 <trap+0xa3>
80106a89:	eb a5                	jmp    80106a30 <trap+0xc0>
    if(cpuid() == 0){
80106a8b:	e8 50 cf ff ff       	call   801039e0 <cpuid>
80106a90:	85 c0                	test   %eax,%eax
80106a92:	75 e7                	jne    80106a7b <trap+0x10b>
      acquire(&tickslock);
80106a94:	83 ec 0c             	sub    $0xc,%esp
80106a97:	68 60 65 11 80       	push   $0x80116560
80106a9c:	e8 ff e4 ff ff       	call   80104fa0 <acquire>
      wakeup(&ticks);
80106aa1:	c7 04 24 a0 6d 11 80 	movl   $0x80116da0,(%esp)
      ticks++;
80106aa8:	83 05 a0 6d 11 80 01 	addl   $0x1,0x80116da0
      wakeup(&ticks);
80106aaf:	e8 fc df ff ff       	call   80104ab0 <wakeup>
      release(&tickslock);
80106ab4:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
80106abb:	e8 a0 e5 ff ff       	call   80105060 <release>
      aging();
80106ac0:	e8 3b cf ff ff       	call   80103a00 <aging>
80106ac5:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106ac8:	eb b1                	jmp    80106a7b <trap+0x10b>
    kbdintr();
80106aca:	e8 b1 bc ff ff       	call   80102780 <kbdintr>
    lapiceoi();
80106acf:	e8 ec bd ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ad4:	e8 17 d0 ff ff       	call   80103af0 <myproc>
80106ad9:	85 c0                	test   %eax,%eax
80106adb:	0f 85 32 ff ff ff    	jne    80106a13 <trap+0xa3>
80106ae1:	e9 4a ff ff ff       	jmp    80106a30 <trap+0xc0>
    uartintr();
80106ae6:	e8 55 02 00 00       	call   80106d40 <uartintr>
    lapiceoi();
80106aeb:	e8 d0 bd ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106af0:	e8 fb cf ff ff       	call   80103af0 <myproc>
80106af5:	85 c0                	test   %eax,%eax
80106af7:	0f 85 16 ff ff ff    	jne    80106a13 <trap+0xa3>
80106afd:	e9 2e ff ff ff       	jmp    80106a30 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b02:	8b 7b 38             	mov    0x38(%ebx),%edi
80106b05:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106b09:	e8 d2 ce ff ff       	call   801039e0 <cpuid>
80106b0e:	57                   	push   %edi
80106b0f:	56                   	push   %esi
80106b10:	50                   	push   %eax
80106b11:	68 fc 89 10 80       	push   $0x801089fc
80106b16:	e8 95 9b ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106b1b:	e8 a0 bd ff ff       	call   801028c0 <lapiceoi>
    break;
80106b20:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b23:	e8 c8 cf ff ff       	call   80103af0 <myproc>
80106b28:	85 c0                	test   %eax,%eax
80106b2a:	0f 85 e3 fe ff ff    	jne    80106a13 <trap+0xa3>
80106b30:	e9 fb fe ff ff       	jmp    80106a30 <trap+0xc0>
80106b35:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106b38:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106b3c:	0f 85 06 ff ff ff    	jne    80106a48 <trap+0xd8>
    yield();
80106b42:	e8 09 dd ff ff       	call   80104850 <yield>
80106b47:	e9 fc fe ff ff       	jmp    80106a48 <trap+0xd8>
80106b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106b50:	e8 9b cf ff ff       	call   80103af0 <myproc>
80106b55:	8b 70 30             	mov    0x30(%eax),%esi
80106b58:	85 f6                	test   %esi,%esi
80106b5a:	75 3c                	jne    80106b98 <trap+0x228>
    myproc()->tf = tf;
80106b5c:	e8 8f cf ff ff       	call   80103af0 <myproc>
80106b61:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106b64:	e8 a7 e9 ff ff       	call   80105510 <syscall>
    if(myproc()->killed)
80106b69:	e8 82 cf ff ff       	call   80103af0 <myproc>
80106b6e:	8b 48 30             	mov    0x30(%eax),%ecx
80106b71:	85 c9                	test   %ecx,%ecx
80106b73:	0f 84 f5 fe ff ff    	je     80106a6e <trap+0xfe>
}
80106b79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b7c:	5b                   	pop    %ebx
80106b7d:	5e                   	pop    %esi
80106b7e:	5f                   	pop    %edi
80106b7f:	5d                   	pop    %ebp
      exit();
80106b80:	e9 8b db ff ff       	jmp    80104710 <exit>
80106b85:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106b88:	e8 83 db ff ff       	call   80104710 <exit>
80106b8d:	e9 9e fe ff ff       	jmp    80106a30 <trap+0xc0>
80106b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106b98:	e8 73 db ff ff       	call   80104710 <exit>
80106b9d:	eb bd                	jmp    80106b5c <trap+0x1ec>
80106b9f:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106ba2:	e8 39 ce ff ff       	call   801039e0 <cpuid>
80106ba7:	83 ec 0c             	sub    $0xc,%esp
80106baa:	56                   	push   %esi
80106bab:	57                   	push   %edi
80106bac:	50                   	push   %eax
80106bad:	ff 73 30             	pushl  0x30(%ebx)
80106bb0:	68 20 8a 10 80       	push   $0x80108a20
80106bb5:	e8 f6 9a ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106bba:	83 c4 14             	add    $0x14,%esp
80106bbd:	68 f4 89 10 80       	push   $0x801089f4
80106bc2:	e8 c9 97 ff ff       	call   80100390 <panic>
80106bc7:	66 90                	xchg   %ax,%ax
80106bc9:	66 90                	xchg   %ax,%ax
80106bcb:	66 90                	xchg   %ax,%ax
80106bcd:	66 90                	xchg   %ax,%ax
80106bcf:	90                   	nop

80106bd0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106bd0:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106bd4:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106bd9:	85 c0                	test   %eax,%eax
80106bdb:	74 1b                	je     80106bf8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106bdd:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106be2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106be3:	a8 01                	test   $0x1,%al
80106be5:	74 11                	je     80106bf8 <uartgetc+0x28>
80106be7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106bec:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106bed:	0f b6 c0             	movzbl %al,%eax
80106bf0:	c3                   	ret    
80106bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106bf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bfd:	c3                   	ret    
80106bfe:	66 90                	xchg   %ax,%ax

80106c00 <uartputc.part.0>:
uartputc(int c)
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	89 c7                	mov    %eax,%edi
80106c06:	56                   	push   %esi
80106c07:	be fd 03 00 00       	mov    $0x3fd,%esi
80106c0c:	53                   	push   %ebx
80106c0d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106c12:	83 ec 0c             	sub    $0xc,%esp
80106c15:	eb 1b                	jmp    80106c32 <uartputc.part.0+0x32>
80106c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c1e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106c20:	83 ec 0c             	sub    $0xc,%esp
80106c23:	6a 0a                	push   $0xa
80106c25:	e8 b6 bc ff ff       	call   801028e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c2a:	83 c4 10             	add    $0x10,%esp
80106c2d:	83 eb 01             	sub    $0x1,%ebx
80106c30:	74 07                	je     80106c39 <uartputc.part.0+0x39>
80106c32:	89 f2                	mov    %esi,%edx
80106c34:	ec                   	in     (%dx),%al
80106c35:	a8 20                	test   $0x20,%al
80106c37:	74 e7                	je     80106c20 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106c39:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c3e:	89 f8                	mov    %edi,%eax
80106c40:	ee                   	out    %al,(%dx)
}
80106c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c44:	5b                   	pop    %ebx
80106c45:	5e                   	pop    %esi
80106c46:	5f                   	pop    %edi
80106c47:	5d                   	pop    %ebp
80106c48:	c3                   	ret    
80106c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c50 <uartinit>:
{
80106c50:	f3 0f 1e fb          	endbr32 
80106c54:	55                   	push   %ebp
80106c55:	31 c9                	xor    %ecx,%ecx
80106c57:	89 c8                	mov    %ecx,%eax
80106c59:	89 e5                	mov    %esp,%ebp
80106c5b:	57                   	push   %edi
80106c5c:	56                   	push   %esi
80106c5d:	53                   	push   %ebx
80106c5e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106c63:	89 da                	mov    %ebx,%edx
80106c65:	83 ec 0c             	sub    $0xc,%esp
80106c68:	ee                   	out    %al,(%dx)
80106c69:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106c6e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106c73:	89 fa                	mov    %edi,%edx
80106c75:	ee                   	out    %al,(%dx)
80106c76:	b8 0c 00 00 00       	mov    $0xc,%eax
80106c7b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c80:	ee                   	out    %al,(%dx)
80106c81:	be f9 03 00 00       	mov    $0x3f9,%esi
80106c86:	89 c8                	mov    %ecx,%eax
80106c88:	89 f2                	mov    %esi,%edx
80106c8a:	ee                   	out    %al,(%dx)
80106c8b:	b8 03 00 00 00       	mov    $0x3,%eax
80106c90:	89 fa                	mov    %edi,%edx
80106c92:	ee                   	out    %al,(%dx)
80106c93:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106c98:	89 c8                	mov    %ecx,%eax
80106c9a:	ee                   	out    %al,(%dx)
80106c9b:	b8 01 00 00 00       	mov    $0x1,%eax
80106ca0:	89 f2                	mov    %esi,%edx
80106ca2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106ca3:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106ca8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106ca9:	3c ff                	cmp    $0xff,%al
80106cab:	74 52                	je     80106cff <uartinit+0xaf>
  uart = 1;
80106cad:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106cb4:	00 00 00 
80106cb7:	89 da                	mov    %ebx,%edx
80106cb9:	ec                   	in     (%dx),%al
80106cba:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106cbf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106cc0:	83 ec 08             	sub    $0x8,%esp
80106cc3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106cc8:	bb 18 8b 10 80       	mov    $0x80108b18,%ebx
  ioapicenable(IRQ_COM1, 0);
80106ccd:	6a 00                	push   $0x0
80106ccf:	6a 04                	push   $0x4
80106cd1:	e8 5a b7 ff ff       	call   80102430 <ioapicenable>
80106cd6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106cd9:	b8 78 00 00 00       	mov    $0x78,%eax
80106cde:	eb 04                	jmp    80106ce4 <uartinit+0x94>
80106ce0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106ce4:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106cea:	85 d2                	test   %edx,%edx
80106cec:	74 08                	je     80106cf6 <uartinit+0xa6>
    uartputc(*p);
80106cee:	0f be c0             	movsbl %al,%eax
80106cf1:	e8 0a ff ff ff       	call   80106c00 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106cf6:	89 f0                	mov    %esi,%eax
80106cf8:	83 c3 01             	add    $0x1,%ebx
80106cfb:	84 c0                	test   %al,%al
80106cfd:	75 e1                	jne    80106ce0 <uartinit+0x90>
}
80106cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d02:	5b                   	pop    %ebx
80106d03:	5e                   	pop    %esi
80106d04:	5f                   	pop    %edi
80106d05:	5d                   	pop    %ebp
80106d06:	c3                   	ret    
80106d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d0e:	66 90                	xchg   %ax,%ax

80106d10 <uartputc>:
{
80106d10:	f3 0f 1e fb          	endbr32 
80106d14:	55                   	push   %ebp
  if(!uart)
80106d15:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106d1b:	89 e5                	mov    %esp,%ebp
80106d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106d20:	85 d2                	test   %edx,%edx
80106d22:	74 0c                	je     80106d30 <uartputc+0x20>
}
80106d24:	5d                   	pop    %ebp
80106d25:	e9 d6 fe ff ff       	jmp    80106c00 <uartputc.part.0>
80106d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d30:	5d                   	pop    %ebp
80106d31:	c3                   	ret    
80106d32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d40 <uartintr>:

void
uartintr(void)
{
80106d40:	f3 0f 1e fb          	endbr32 
80106d44:	55                   	push   %ebp
80106d45:	89 e5                	mov    %esp,%ebp
80106d47:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106d4a:	68 d0 6b 10 80       	push   $0x80106bd0
80106d4f:	e8 0c 9b ff ff       	call   80100860 <consoleintr>
}
80106d54:	83 c4 10             	add    $0x10,%esp
80106d57:	c9                   	leave  
80106d58:	c3                   	ret    

80106d59 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106d59:	6a 00                	push   $0x0
  pushl $0
80106d5b:	6a 00                	push   $0x0
  jmp alltraps
80106d5d:	e9 31 fb ff ff       	jmp    80106893 <alltraps>

80106d62 <vector1>:
.globl vector1
vector1:
  pushl $0
80106d62:	6a 00                	push   $0x0
  pushl $1
80106d64:	6a 01                	push   $0x1
  jmp alltraps
80106d66:	e9 28 fb ff ff       	jmp    80106893 <alltraps>

80106d6b <vector2>:
.globl vector2
vector2:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $2
80106d6d:	6a 02                	push   $0x2
  jmp alltraps
80106d6f:	e9 1f fb ff ff       	jmp    80106893 <alltraps>

80106d74 <vector3>:
.globl vector3
vector3:
  pushl $0
80106d74:	6a 00                	push   $0x0
  pushl $3
80106d76:	6a 03                	push   $0x3
  jmp alltraps
80106d78:	e9 16 fb ff ff       	jmp    80106893 <alltraps>

80106d7d <vector4>:
.globl vector4
vector4:
  pushl $0
80106d7d:	6a 00                	push   $0x0
  pushl $4
80106d7f:	6a 04                	push   $0x4
  jmp alltraps
80106d81:	e9 0d fb ff ff       	jmp    80106893 <alltraps>

80106d86 <vector5>:
.globl vector5
vector5:
  pushl $0
80106d86:	6a 00                	push   $0x0
  pushl $5
80106d88:	6a 05                	push   $0x5
  jmp alltraps
80106d8a:	e9 04 fb ff ff       	jmp    80106893 <alltraps>

80106d8f <vector6>:
.globl vector6
vector6:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $6
80106d91:	6a 06                	push   $0x6
  jmp alltraps
80106d93:	e9 fb fa ff ff       	jmp    80106893 <alltraps>

80106d98 <vector7>:
.globl vector7
vector7:
  pushl $0
80106d98:	6a 00                	push   $0x0
  pushl $7
80106d9a:	6a 07                	push   $0x7
  jmp alltraps
80106d9c:	e9 f2 fa ff ff       	jmp    80106893 <alltraps>

80106da1 <vector8>:
.globl vector8
vector8:
  pushl $8
80106da1:	6a 08                	push   $0x8
  jmp alltraps
80106da3:	e9 eb fa ff ff       	jmp    80106893 <alltraps>

80106da8 <vector9>:
.globl vector9
vector9:
  pushl $0
80106da8:	6a 00                	push   $0x0
  pushl $9
80106daa:	6a 09                	push   $0x9
  jmp alltraps
80106dac:	e9 e2 fa ff ff       	jmp    80106893 <alltraps>

80106db1 <vector10>:
.globl vector10
vector10:
  pushl $10
80106db1:	6a 0a                	push   $0xa
  jmp alltraps
80106db3:	e9 db fa ff ff       	jmp    80106893 <alltraps>

80106db8 <vector11>:
.globl vector11
vector11:
  pushl $11
80106db8:	6a 0b                	push   $0xb
  jmp alltraps
80106dba:	e9 d4 fa ff ff       	jmp    80106893 <alltraps>

80106dbf <vector12>:
.globl vector12
vector12:
  pushl $12
80106dbf:	6a 0c                	push   $0xc
  jmp alltraps
80106dc1:	e9 cd fa ff ff       	jmp    80106893 <alltraps>

80106dc6 <vector13>:
.globl vector13
vector13:
  pushl $13
80106dc6:	6a 0d                	push   $0xd
  jmp alltraps
80106dc8:	e9 c6 fa ff ff       	jmp    80106893 <alltraps>

80106dcd <vector14>:
.globl vector14
vector14:
  pushl $14
80106dcd:	6a 0e                	push   $0xe
  jmp alltraps
80106dcf:	e9 bf fa ff ff       	jmp    80106893 <alltraps>

80106dd4 <vector15>:
.globl vector15
vector15:
  pushl $0
80106dd4:	6a 00                	push   $0x0
  pushl $15
80106dd6:	6a 0f                	push   $0xf
  jmp alltraps
80106dd8:	e9 b6 fa ff ff       	jmp    80106893 <alltraps>

80106ddd <vector16>:
.globl vector16
vector16:
  pushl $0
80106ddd:	6a 00                	push   $0x0
  pushl $16
80106ddf:	6a 10                	push   $0x10
  jmp alltraps
80106de1:	e9 ad fa ff ff       	jmp    80106893 <alltraps>

80106de6 <vector17>:
.globl vector17
vector17:
  pushl $17
80106de6:	6a 11                	push   $0x11
  jmp alltraps
80106de8:	e9 a6 fa ff ff       	jmp    80106893 <alltraps>

80106ded <vector18>:
.globl vector18
vector18:
  pushl $0
80106ded:	6a 00                	push   $0x0
  pushl $18
80106def:	6a 12                	push   $0x12
  jmp alltraps
80106df1:	e9 9d fa ff ff       	jmp    80106893 <alltraps>

80106df6 <vector19>:
.globl vector19
vector19:
  pushl $0
80106df6:	6a 00                	push   $0x0
  pushl $19
80106df8:	6a 13                	push   $0x13
  jmp alltraps
80106dfa:	e9 94 fa ff ff       	jmp    80106893 <alltraps>

80106dff <vector20>:
.globl vector20
vector20:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $20
80106e01:	6a 14                	push   $0x14
  jmp alltraps
80106e03:	e9 8b fa ff ff       	jmp    80106893 <alltraps>

80106e08 <vector21>:
.globl vector21
vector21:
  pushl $0
80106e08:	6a 00                	push   $0x0
  pushl $21
80106e0a:	6a 15                	push   $0x15
  jmp alltraps
80106e0c:	e9 82 fa ff ff       	jmp    80106893 <alltraps>

80106e11 <vector22>:
.globl vector22
vector22:
  pushl $0
80106e11:	6a 00                	push   $0x0
  pushl $22
80106e13:	6a 16                	push   $0x16
  jmp alltraps
80106e15:	e9 79 fa ff ff       	jmp    80106893 <alltraps>

80106e1a <vector23>:
.globl vector23
vector23:
  pushl $0
80106e1a:	6a 00                	push   $0x0
  pushl $23
80106e1c:	6a 17                	push   $0x17
  jmp alltraps
80106e1e:	e9 70 fa ff ff       	jmp    80106893 <alltraps>

80106e23 <vector24>:
.globl vector24
vector24:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $24
80106e25:	6a 18                	push   $0x18
  jmp alltraps
80106e27:	e9 67 fa ff ff       	jmp    80106893 <alltraps>

80106e2c <vector25>:
.globl vector25
vector25:
  pushl $0
80106e2c:	6a 00                	push   $0x0
  pushl $25
80106e2e:	6a 19                	push   $0x19
  jmp alltraps
80106e30:	e9 5e fa ff ff       	jmp    80106893 <alltraps>

80106e35 <vector26>:
.globl vector26
vector26:
  pushl $0
80106e35:	6a 00                	push   $0x0
  pushl $26
80106e37:	6a 1a                	push   $0x1a
  jmp alltraps
80106e39:	e9 55 fa ff ff       	jmp    80106893 <alltraps>

80106e3e <vector27>:
.globl vector27
vector27:
  pushl $0
80106e3e:	6a 00                	push   $0x0
  pushl $27
80106e40:	6a 1b                	push   $0x1b
  jmp alltraps
80106e42:	e9 4c fa ff ff       	jmp    80106893 <alltraps>

80106e47 <vector28>:
.globl vector28
vector28:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $28
80106e49:	6a 1c                	push   $0x1c
  jmp alltraps
80106e4b:	e9 43 fa ff ff       	jmp    80106893 <alltraps>

80106e50 <vector29>:
.globl vector29
vector29:
  pushl $0
80106e50:	6a 00                	push   $0x0
  pushl $29
80106e52:	6a 1d                	push   $0x1d
  jmp alltraps
80106e54:	e9 3a fa ff ff       	jmp    80106893 <alltraps>

80106e59 <vector30>:
.globl vector30
vector30:
  pushl $0
80106e59:	6a 00                	push   $0x0
  pushl $30
80106e5b:	6a 1e                	push   $0x1e
  jmp alltraps
80106e5d:	e9 31 fa ff ff       	jmp    80106893 <alltraps>

80106e62 <vector31>:
.globl vector31
vector31:
  pushl $0
80106e62:	6a 00                	push   $0x0
  pushl $31
80106e64:	6a 1f                	push   $0x1f
  jmp alltraps
80106e66:	e9 28 fa ff ff       	jmp    80106893 <alltraps>

80106e6b <vector32>:
.globl vector32
vector32:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $32
80106e6d:	6a 20                	push   $0x20
  jmp alltraps
80106e6f:	e9 1f fa ff ff       	jmp    80106893 <alltraps>

80106e74 <vector33>:
.globl vector33
vector33:
  pushl $0
80106e74:	6a 00                	push   $0x0
  pushl $33
80106e76:	6a 21                	push   $0x21
  jmp alltraps
80106e78:	e9 16 fa ff ff       	jmp    80106893 <alltraps>

80106e7d <vector34>:
.globl vector34
vector34:
  pushl $0
80106e7d:	6a 00                	push   $0x0
  pushl $34
80106e7f:	6a 22                	push   $0x22
  jmp alltraps
80106e81:	e9 0d fa ff ff       	jmp    80106893 <alltraps>

80106e86 <vector35>:
.globl vector35
vector35:
  pushl $0
80106e86:	6a 00                	push   $0x0
  pushl $35
80106e88:	6a 23                	push   $0x23
  jmp alltraps
80106e8a:	e9 04 fa ff ff       	jmp    80106893 <alltraps>

80106e8f <vector36>:
.globl vector36
vector36:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $36
80106e91:	6a 24                	push   $0x24
  jmp alltraps
80106e93:	e9 fb f9 ff ff       	jmp    80106893 <alltraps>

80106e98 <vector37>:
.globl vector37
vector37:
  pushl $0
80106e98:	6a 00                	push   $0x0
  pushl $37
80106e9a:	6a 25                	push   $0x25
  jmp alltraps
80106e9c:	e9 f2 f9 ff ff       	jmp    80106893 <alltraps>

80106ea1 <vector38>:
.globl vector38
vector38:
  pushl $0
80106ea1:	6a 00                	push   $0x0
  pushl $38
80106ea3:	6a 26                	push   $0x26
  jmp alltraps
80106ea5:	e9 e9 f9 ff ff       	jmp    80106893 <alltraps>

80106eaa <vector39>:
.globl vector39
vector39:
  pushl $0
80106eaa:	6a 00                	push   $0x0
  pushl $39
80106eac:	6a 27                	push   $0x27
  jmp alltraps
80106eae:	e9 e0 f9 ff ff       	jmp    80106893 <alltraps>

80106eb3 <vector40>:
.globl vector40
vector40:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $40
80106eb5:	6a 28                	push   $0x28
  jmp alltraps
80106eb7:	e9 d7 f9 ff ff       	jmp    80106893 <alltraps>

80106ebc <vector41>:
.globl vector41
vector41:
  pushl $0
80106ebc:	6a 00                	push   $0x0
  pushl $41
80106ebe:	6a 29                	push   $0x29
  jmp alltraps
80106ec0:	e9 ce f9 ff ff       	jmp    80106893 <alltraps>

80106ec5 <vector42>:
.globl vector42
vector42:
  pushl $0
80106ec5:	6a 00                	push   $0x0
  pushl $42
80106ec7:	6a 2a                	push   $0x2a
  jmp alltraps
80106ec9:	e9 c5 f9 ff ff       	jmp    80106893 <alltraps>

80106ece <vector43>:
.globl vector43
vector43:
  pushl $0
80106ece:	6a 00                	push   $0x0
  pushl $43
80106ed0:	6a 2b                	push   $0x2b
  jmp alltraps
80106ed2:	e9 bc f9 ff ff       	jmp    80106893 <alltraps>

80106ed7 <vector44>:
.globl vector44
vector44:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $44
80106ed9:	6a 2c                	push   $0x2c
  jmp alltraps
80106edb:	e9 b3 f9 ff ff       	jmp    80106893 <alltraps>

80106ee0 <vector45>:
.globl vector45
vector45:
  pushl $0
80106ee0:	6a 00                	push   $0x0
  pushl $45
80106ee2:	6a 2d                	push   $0x2d
  jmp alltraps
80106ee4:	e9 aa f9 ff ff       	jmp    80106893 <alltraps>

80106ee9 <vector46>:
.globl vector46
vector46:
  pushl $0
80106ee9:	6a 00                	push   $0x0
  pushl $46
80106eeb:	6a 2e                	push   $0x2e
  jmp alltraps
80106eed:	e9 a1 f9 ff ff       	jmp    80106893 <alltraps>

80106ef2 <vector47>:
.globl vector47
vector47:
  pushl $0
80106ef2:	6a 00                	push   $0x0
  pushl $47
80106ef4:	6a 2f                	push   $0x2f
  jmp alltraps
80106ef6:	e9 98 f9 ff ff       	jmp    80106893 <alltraps>

80106efb <vector48>:
.globl vector48
vector48:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $48
80106efd:	6a 30                	push   $0x30
  jmp alltraps
80106eff:	e9 8f f9 ff ff       	jmp    80106893 <alltraps>

80106f04 <vector49>:
.globl vector49
vector49:
  pushl $0
80106f04:	6a 00                	push   $0x0
  pushl $49
80106f06:	6a 31                	push   $0x31
  jmp alltraps
80106f08:	e9 86 f9 ff ff       	jmp    80106893 <alltraps>

80106f0d <vector50>:
.globl vector50
vector50:
  pushl $0
80106f0d:	6a 00                	push   $0x0
  pushl $50
80106f0f:	6a 32                	push   $0x32
  jmp alltraps
80106f11:	e9 7d f9 ff ff       	jmp    80106893 <alltraps>

80106f16 <vector51>:
.globl vector51
vector51:
  pushl $0
80106f16:	6a 00                	push   $0x0
  pushl $51
80106f18:	6a 33                	push   $0x33
  jmp alltraps
80106f1a:	e9 74 f9 ff ff       	jmp    80106893 <alltraps>

80106f1f <vector52>:
.globl vector52
vector52:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $52
80106f21:	6a 34                	push   $0x34
  jmp alltraps
80106f23:	e9 6b f9 ff ff       	jmp    80106893 <alltraps>

80106f28 <vector53>:
.globl vector53
vector53:
  pushl $0
80106f28:	6a 00                	push   $0x0
  pushl $53
80106f2a:	6a 35                	push   $0x35
  jmp alltraps
80106f2c:	e9 62 f9 ff ff       	jmp    80106893 <alltraps>

80106f31 <vector54>:
.globl vector54
vector54:
  pushl $0
80106f31:	6a 00                	push   $0x0
  pushl $54
80106f33:	6a 36                	push   $0x36
  jmp alltraps
80106f35:	e9 59 f9 ff ff       	jmp    80106893 <alltraps>

80106f3a <vector55>:
.globl vector55
vector55:
  pushl $0
80106f3a:	6a 00                	push   $0x0
  pushl $55
80106f3c:	6a 37                	push   $0x37
  jmp alltraps
80106f3e:	e9 50 f9 ff ff       	jmp    80106893 <alltraps>

80106f43 <vector56>:
.globl vector56
vector56:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $56
80106f45:	6a 38                	push   $0x38
  jmp alltraps
80106f47:	e9 47 f9 ff ff       	jmp    80106893 <alltraps>

80106f4c <vector57>:
.globl vector57
vector57:
  pushl $0
80106f4c:	6a 00                	push   $0x0
  pushl $57
80106f4e:	6a 39                	push   $0x39
  jmp alltraps
80106f50:	e9 3e f9 ff ff       	jmp    80106893 <alltraps>

80106f55 <vector58>:
.globl vector58
vector58:
  pushl $0
80106f55:	6a 00                	push   $0x0
  pushl $58
80106f57:	6a 3a                	push   $0x3a
  jmp alltraps
80106f59:	e9 35 f9 ff ff       	jmp    80106893 <alltraps>

80106f5e <vector59>:
.globl vector59
vector59:
  pushl $0
80106f5e:	6a 00                	push   $0x0
  pushl $59
80106f60:	6a 3b                	push   $0x3b
  jmp alltraps
80106f62:	e9 2c f9 ff ff       	jmp    80106893 <alltraps>

80106f67 <vector60>:
.globl vector60
vector60:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $60
80106f69:	6a 3c                	push   $0x3c
  jmp alltraps
80106f6b:	e9 23 f9 ff ff       	jmp    80106893 <alltraps>

80106f70 <vector61>:
.globl vector61
vector61:
  pushl $0
80106f70:	6a 00                	push   $0x0
  pushl $61
80106f72:	6a 3d                	push   $0x3d
  jmp alltraps
80106f74:	e9 1a f9 ff ff       	jmp    80106893 <alltraps>

80106f79 <vector62>:
.globl vector62
vector62:
  pushl $0
80106f79:	6a 00                	push   $0x0
  pushl $62
80106f7b:	6a 3e                	push   $0x3e
  jmp alltraps
80106f7d:	e9 11 f9 ff ff       	jmp    80106893 <alltraps>

80106f82 <vector63>:
.globl vector63
vector63:
  pushl $0
80106f82:	6a 00                	push   $0x0
  pushl $63
80106f84:	6a 3f                	push   $0x3f
  jmp alltraps
80106f86:	e9 08 f9 ff ff       	jmp    80106893 <alltraps>

80106f8b <vector64>:
.globl vector64
vector64:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $64
80106f8d:	6a 40                	push   $0x40
  jmp alltraps
80106f8f:	e9 ff f8 ff ff       	jmp    80106893 <alltraps>

80106f94 <vector65>:
.globl vector65
vector65:
  pushl $0
80106f94:	6a 00                	push   $0x0
  pushl $65
80106f96:	6a 41                	push   $0x41
  jmp alltraps
80106f98:	e9 f6 f8 ff ff       	jmp    80106893 <alltraps>

80106f9d <vector66>:
.globl vector66
vector66:
  pushl $0
80106f9d:	6a 00                	push   $0x0
  pushl $66
80106f9f:	6a 42                	push   $0x42
  jmp alltraps
80106fa1:	e9 ed f8 ff ff       	jmp    80106893 <alltraps>

80106fa6 <vector67>:
.globl vector67
vector67:
  pushl $0
80106fa6:	6a 00                	push   $0x0
  pushl $67
80106fa8:	6a 43                	push   $0x43
  jmp alltraps
80106faa:	e9 e4 f8 ff ff       	jmp    80106893 <alltraps>

80106faf <vector68>:
.globl vector68
vector68:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $68
80106fb1:	6a 44                	push   $0x44
  jmp alltraps
80106fb3:	e9 db f8 ff ff       	jmp    80106893 <alltraps>

80106fb8 <vector69>:
.globl vector69
vector69:
  pushl $0
80106fb8:	6a 00                	push   $0x0
  pushl $69
80106fba:	6a 45                	push   $0x45
  jmp alltraps
80106fbc:	e9 d2 f8 ff ff       	jmp    80106893 <alltraps>

80106fc1 <vector70>:
.globl vector70
vector70:
  pushl $0
80106fc1:	6a 00                	push   $0x0
  pushl $70
80106fc3:	6a 46                	push   $0x46
  jmp alltraps
80106fc5:	e9 c9 f8 ff ff       	jmp    80106893 <alltraps>

80106fca <vector71>:
.globl vector71
vector71:
  pushl $0
80106fca:	6a 00                	push   $0x0
  pushl $71
80106fcc:	6a 47                	push   $0x47
  jmp alltraps
80106fce:	e9 c0 f8 ff ff       	jmp    80106893 <alltraps>

80106fd3 <vector72>:
.globl vector72
vector72:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $72
80106fd5:	6a 48                	push   $0x48
  jmp alltraps
80106fd7:	e9 b7 f8 ff ff       	jmp    80106893 <alltraps>

80106fdc <vector73>:
.globl vector73
vector73:
  pushl $0
80106fdc:	6a 00                	push   $0x0
  pushl $73
80106fde:	6a 49                	push   $0x49
  jmp alltraps
80106fe0:	e9 ae f8 ff ff       	jmp    80106893 <alltraps>

80106fe5 <vector74>:
.globl vector74
vector74:
  pushl $0
80106fe5:	6a 00                	push   $0x0
  pushl $74
80106fe7:	6a 4a                	push   $0x4a
  jmp alltraps
80106fe9:	e9 a5 f8 ff ff       	jmp    80106893 <alltraps>

80106fee <vector75>:
.globl vector75
vector75:
  pushl $0
80106fee:	6a 00                	push   $0x0
  pushl $75
80106ff0:	6a 4b                	push   $0x4b
  jmp alltraps
80106ff2:	e9 9c f8 ff ff       	jmp    80106893 <alltraps>

80106ff7 <vector76>:
.globl vector76
vector76:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $76
80106ff9:	6a 4c                	push   $0x4c
  jmp alltraps
80106ffb:	e9 93 f8 ff ff       	jmp    80106893 <alltraps>

80107000 <vector77>:
.globl vector77
vector77:
  pushl $0
80107000:	6a 00                	push   $0x0
  pushl $77
80107002:	6a 4d                	push   $0x4d
  jmp alltraps
80107004:	e9 8a f8 ff ff       	jmp    80106893 <alltraps>

80107009 <vector78>:
.globl vector78
vector78:
  pushl $0
80107009:	6a 00                	push   $0x0
  pushl $78
8010700b:	6a 4e                	push   $0x4e
  jmp alltraps
8010700d:	e9 81 f8 ff ff       	jmp    80106893 <alltraps>

80107012 <vector79>:
.globl vector79
vector79:
  pushl $0
80107012:	6a 00                	push   $0x0
  pushl $79
80107014:	6a 4f                	push   $0x4f
  jmp alltraps
80107016:	e9 78 f8 ff ff       	jmp    80106893 <alltraps>

8010701b <vector80>:
.globl vector80
vector80:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $80
8010701d:	6a 50                	push   $0x50
  jmp alltraps
8010701f:	e9 6f f8 ff ff       	jmp    80106893 <alltraps>

80107024 <vector81>:
.globl vector81
vector81:
  pushl $0
80107024:	6a 00                	push   $0x0
  pushl $81
80107026:	6a 51                	push   $0x51
  jmp alltraps
80107028:	e9 66 f8 ff ff       	jmp    80106893 <alltraps>

8010702d <vector82>:
.globl vector82
vector82:
  pushl $0
8010702d:	6a 00                	push   $0x0
  pushl $82
8010702f:	6a 52                	push   $0x52
  jmp alltraps
80107031:	e9 5d f8 ff ff       	jmp    80106893 <alltraps>

80107036 <vector83>:
.globl vector83
vector83:
  pushl $0
80107036:	6a 00                	push   $0x0
  pushl $83
80107038:	6a 53                	push   $0x53
  jmp alltraps
8010703a:	e9 54 f8 ff ff       	jmp    80106893 <alltraps>

8010703f <vector84>:
.globl vector84
vector84:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $84
80107041:	6a 54                	push   $0x54
  jmp alltraps
80107043:	e9 4b f8 ff ff       	jmp    80106893 <alltraps>

80107048 <vector85>:
.globl vector85
vector85:
  pushl $0
80107048:	6a 00                	push   $0x0
  pushl $85
8010704a:	6a 55                	push   $0x55
  jmp alltraps
8010704c:	e9 42 f8 ff ff       	jmp    80106893 <alltraps>

80107051 <vector86>:
.globl vector86
vector86:
  pushl $0
80107051:	6a 00                	push   $0x0
  pushl $86
80107053:	6a 56                	push   $0x56
  jmp alltraps
80107055:	e9 39 f8 ff ff       	jmp    80106893 <alltraps>

8010705a <vector87>:
.globl vector87
vector87:
  pushl $0
8010705a:	6a 00                	push   $0x0
  pushl $87
8010705c:	6a 57                	push   $0x57
  jmp alltraps
8010705e:	e9 30 f8 ff ff       	jmp    80106893 <alltraps>

80107063 <vector88>:
.globl vector88
vector88:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $88
80107065:	6a 58                	push   $0x58
  jmp alltraps
80107067:	e9 27 f8 ff ff       	jmp    80106893 <alltraps>

8010706c <vector89>:
.globl vector89
vector89:
  pushl $0
8010706c:	6a 00                	push   $0x0
  pushl $89
8010706e:	6a 59                	push   $0x59
  jmp alltraps
80107070:	e9 1e f8 ff ff       	jmp    80106893 <alltraps>

80107075 <vector90>:
.globl vector90
vector90:
  pushl $0
80107075:	6a 00                	push   $0x0
  pushl $90
80107077:	6a 5a                	push   $0x5a
  jmp alltraps
80107079:	e9 15 f8 ff ff       	jmp    80106893 <alltraps>

8010707e <vector91>:
.globl vector91
vector91:
  pushl $0
8010707e:	6a 00                	push   $0x0
  pushl $91
80107080:	6a 5b                	push   $0x5b
  jmp alltraps
80107082:	e9 0c f8 ff ff       	jmp    80106893 <alltraps>

80107087 <vector92>:
.globl vector92
vector92:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $92
80107089:	6a 5c                	push   $0x5c
  jmp alltraps
8010708b:	e9 03 f8 ff ff       	jmp    80106893 <alltraps>

80107090 <vector93>:
.globl vector93
vector93:
  pushl $0
80107090:	6a 00                	push   $0x0
  pushl $93
80107092:	6a 5d                	push   $0x5d
  jmp alltraps
80107094:	e9 fa f7 ff ff       	jmp    80106893 <alltraps>

80107099 <vector94>:
.globl vector94
vector94:
  pushl $0
80107099:	6a 00                	push   $0x0
  pushl $94
8010709b:	6a 5e                	push   $0x5e
  jmp alltraps
8010709d:	e9 f1 f7 ff ff       	jmp    80106893 <alltraps>

801070a2 <vector95>:
.globl vector95
vector95:
  pushl $0
801070a2:	6a 00                	push   $0x0
  pushl $95
801070a4:	6a 5f                	push   $0x5f
  jmp alltraps
801070a6:	e9 e8 f7 ff ff       	jmp    80106893 <alltraps>

801070ab <vector96>:
.globl vector96
vector96:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $96
801070ad:	6a 60                	push   $0x60
  jmp alltraps
801070af:	e9 df f7 ff ff       	jmp    80106893 <alltraps>

801070b4 <vector97>:
.globl vector97
vector97:
  pushl $0
801070b4:	6a 00                	push   $0x0
  pushl $97
801070b6:	6a 61                	push   $0x61
  jmp alltraps
801070b8:	e9 d6 f7 ff ff       	jmp    80106893 <alltraps>

801070bd <vector98>:
.globl vector98
vector98:
  pushl $0
801070bd:	6a 00                	push   $0x0
  pushl $98
801070bf:	6a 62                	push   $0x62
  jmp alltraps
801070c1:	e9 cd f7 ff ff       	jmp    80106893 <alltraps>

801070c6 <vector99>:
.globl vector99
vector99:
  pushl $0
801070c6:	6a 00                	push   $0x0
  pushl $99
801070c8:	6a 63                	push   $0x63
  jmp alltraps
801070ca:	e9 c4 f7 ff ff       	jmp    80106893 <alltraps>

801070cf <vector100>:
.globl vector100
vector100:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $100
801070d1:	6a 64                	push   $0x64
  jmp alltraps
801070d3:	e9 bb f7 ff ff       	jmp    80106893 <alltraps>

801070d8 <vector101>:
.globl vector101
vector101:
  pushl $0
801070d8:	6a 00                	push   $0x0
  pushl $101
801070da:	6a 65                	push   $0x65
  jmp alltraps
801070dc:	e9 b2 f7 ff ff       	jmp    80106893 <alltraps>

801070e1 <vector102>:
.globl vector102
vector102:
  pushl $0
801070e1:	6a 00                	push   $0x0
  pushl $102
801070e3:	6a 66                	push   $0x66
  jmp alltraps
801070e5:	e9 a9 f7 ff ff       	jmp    80106893 <alltraps>

801070ea <vector103>:
.globl vector103
vector103:
  pushl $0
801070ea:	6a 00                	push   $0x0
  pushl $103
801070ec:	6a 67                	push   $0x67
  jmp alltraps
801070ee:	e9 a0 f7 ff ff       	jmp    80106893 <alltraps>

801070f3 <vector104>:
.globl vector104
vector104:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $104
801070f5:	6a 68                	push   $0x68
  jmp alltraps
801070f7:	e9 97 f7 ff ff       	jmp    80106893 <alltraps>

801070fc <vector105>:
.globl vector105
vector105:
  pushl $0
801070fc:	6a 00                	push   $0x0
  pushl $105
801070fe:	6a 69                	push   $0x69
  jmp alltraps
80107100:	e9 8e f7 ff ff       	jmp    80106893 <alltraps>

80107105 <vector106>:
.globl vector106
vector106:
  pushl $0
80107105:	6a 00                	push   $0x0
  pushl $106
80107107:	6a 6a                	push   $0x6a
  jmp alltraps
80107109:	e9 85 f7 ff ff       	jmp    80106893 <alltraps>

8010710e <vector107>:
.globl vector107
vector107:
  pushl $0
8010710e:	6a 00                	push   $0x0
  pushl $107
80107110:	6a 6b                	push   $0x6b
  jmp alltraps
80107112:	e9 7c f7 ff ff       	jmp    80106893 <alltraps>

80107117 <vector108>:
.globl vector108
vector108:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $108
80107119:	6a 6c                	push   $0x6c
  jmp alltraps
8010711b:	e9 73 f7 ff ff       	jmp    80106893 <alltraps>

80107120 <vector109>:
.globl vector109
vector109:
  pushl $0
80107120:	6a 00                	push   $0x0
  pushl $109
80107122:	6a 6d                	push   $0x6d
  jmp alltraps
80107124:	e9 6a f7 ff ff       	jmp    80106893 <alltraps>

80107129 <vector110>:
.globl vector110
vector110:
  pushl $0
80107129:	6a 00                	push   $0x0
  pushl $110
8010712b:	6a 6e                	push   $0x6e
  jmp alltraps
8010712d:	e9 61 f7 ff ff       	jmp    80106893 <alltraps>

80107132 <vector111>:
.globl vector111
vector111:
  pushl $0
80107132:	6a 00                	push   $0x0
  pushl $111
80107134:	6a 6f                	push   $0x6f
  jmp alltraps
80107136:	e9 58 f7 ff ff       	jmp    80106893 <alltraps>

8010713b <vector112>:
.globl vector112
vector112:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $112
8010713d:	6a 70                	push   $0x70
  jmp alltraps
8010713f:	e9 4f f7 ff ff       	jmp    80106893 <alltraps>

80107144 <vector113>:
.globl vector113
vector113:
  pushl $0
80107144:	6a 00                	push   $0x0
  pushl $113
80107146:	6a 71                	push   $0x71
  jmp alltraps
80107148:	e9 46 f7 ff ff       	jmp    80106893 <alltraps>

8010714d <vector114>:
.globl vector114
vector114:
  pushl $0
8010714d:	6a 00                	push   $0x0
  pushl $114
8010714f:	6a 72                	push   $0x72
  jmp alltraps
80107151:	e9 3d f7 ff ff       	jmp    80106893 <alltraps>

80107156 <vector115>:
.globl vector115
vector115:
  pushl $0
80107156:	6a 00                	push   $0x0
  pushl $115
80107158:	6a 73                	push   $0x73
  jmp alltraps
8010715a:	e9 34 f7 ff ff       	jmp    80106893 <alltraps>

8010715f <vector116>:
.globl vector116
vector116:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $116
80107161:	6a 74                	push   $0x74
  jmp alltraps
80107163:	e9 2b f7 ff ff       	jmp    80106893 <alltraps>

80107168 <vector117>:
.globl vector117
vector117:
  pushl $0
80107168:	6a 00                	push   $0x0
  pushl $117
8010716a:	6a 75                	push   $0x75
  jmp alltraps
8010716c:	e9 22 f7 ff ff       	jmp    80106893 <alltraps>

80107171 <vector118>:
.globl vector118
vector118:
  pushl $0
80107171:	6a 00                	push   $0x0
  pushl $118
80107173:	6a 76                	push   $0x76
  jmp alltraps
80107175:	e9 19 f7 ff ff       	jmp    80106893 <alltraps>

8010717a <vector119>:
.globl vector119
vector119:
  pushl $0
8010717a:	6a 00                	push   $0x0
  pushl $119
8010717c:	6a 77                	push   $0x77
  jmp alltraps
8010717e:	e9 10 f7 ff ff       	jmp    80106893 <alltraps>

80107183 <vector120>:
.globl vector120
vector120:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $120
80107185:	6a 78                	push   $0x78
  jmp alltraps
80107187:	e9 07 f7 ff ff       	jmp    80106893 <alltraps>

8010718c <vector121>:
.globl vector121
vector121:
  pushl $0
8010718c:	6a 00                	push   $0x0
  pushl $121
8010718e:	6a 79                	push   $0x79
  jmp alltraps
80107190:	e9 fe f6 ff ff       	jmp    80106893 <alltraps>

80107195 <vector122>:
.globl vector122
vector122:
  pushl $0
80107195:	6a 00                	push   $0x0
  pushl $122
80107197:	6a 7a                	push   $0x7a
  jmp alltraps
80107199:	e9 f5 f6 ff ff       	jmp    80106893 <alltraps>

8010719e <vector123>:
.globl vector123
vector123:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $123
801071a0:	6a 7b                	push   $0x7b
  jmp alltraps
801071a2:	e9 ec f6 ff ff       	jmp    80106893 <alltraps>

801071a7 <vector124>:
.globl vector124
vector124:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $124
801071a9:	6a 7c                	push   $0x7c
  jmp alltraps
801071ab:	e9 e3 f6 ff ff       	jmp    80106893 <alltraps>

801071b0 <vector125>:
.globl vector125
vector125:
  pushl $0
801071b0:	6a 00                	push   $0x0
  pushl $125
801071b2:	6a 7d                	push   $0x7d
  jmp alltraps
801071b4:	e9 da f6 ff ff       	jmp    80106893 <alltraps>

801071b9 <vector126>:
.globl vector126
vector126:
  pushl $0
801071b9:	6a 00                	push   $0x0
  pushl $126
801071bb:	6a 7e                	push   $0x7e
  jmp alltraps
801071bd:	e9 d1 f6 ff ff       	jmp    80106893 <alltraps>

801071c2 <vector127>:
.globl vector127
vector127:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $127
801071c4:	6a 7f                	push   $0x7f
  jmp alltraps
801071c6:	e9 c8 f6 ff ff       	jmp    80106893 <alltraps>

801071cb <vector128>:
.globl vector128
vector128:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $128
801071cd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801071d2:	e9 bc f6 ff ff       	jmp    80106893 <alltraps>

801071d7 <vector129>:
.globl vector129
vector129:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $129
801071d9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801071de:	e9 b0 f6 ff ff       	jmp    80106893 <alltraps>

801071e3 <vector130>:
.globl vector130
vector130:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $130
801071e5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801071ea:	e9 a4 f6 ff ff       	jmp    80106893 <alltraps>

801071ef <vector131>:
.globl vector131
vector131:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $131
801071f1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801071f6:	e9 98 f6 ff ff       	jmp    80106893 <alltraps>

801071fb <vector132>:
.globl vector132
vector132:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $132
801071fd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107202:	e9 8c f6 ff ff       	jmp    80106893 <alltraps>

80107207 <vector133>:
.globl vector133
vector133:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $133
80107209:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010720e:	e9 80 f6 ff ff       	jmp    80106893 <alltraps>

80107213 <vector134>:
.globl vector134
vector134:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $134
80107215:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010721a:	e9 74 f6 ff ff       	jmp    80106893 <alltraps>

8010721f <vector135>:
.globl vector135
vector135:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $135
80107221:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107226:	e9 68 f6 ff ff       	jmp    80106893 <alltraps>

8010722b <vector136>:
.globl vector136
vector136:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $136
8010722d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107232:	e9 5c f6 ff ff       	jmp    80106893 <alltraps>

80107237 <vector137>:
.globl vector137
vector137:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $137
80107239:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010723e:	e9 50 f6 ff ff       	jmp    80106893 <alltraps>

80107243 <vector138>:
.globl vector138
vector138:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $138
80107245:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010724a:	e9 44 f6 ff ff       	jmp    80106893 <alltraps>

8010724f <vector139>:
.globl vector139
vector139:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $139
80107251:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107256:	e9 38 f6 ff ff       	jmp    80106893 <alltraps>

8010725b <vector140>:
.globl vector140
vector140:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $140
8010725d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107262:	e9 2c f6 ff ff       	jmp    80106893 <alltraps>

80107267 <vector141>:
.globl vector141
vector141:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $141
80107269:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010726e:	e9 20 f6 ff ff       	jmp    80106893 <alltraps>

80107273 <vector142>:
.globl vector142
vector142:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $142
80107275:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010727a:	e9 14 f6 ff ff       	jmp    80106893 <alltraps>

8010727f <vector143>:
.globl vector143
vector143:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $143
80107281:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107286:	e9 08 f6 ff ff       	jmp    80106893 <alltraps>

8010728b <vector144>:
.globl vector144
vector144:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $144
8010728d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107292:	e9 fc f5 ff ff       	jmp    80106893 <alltraps>

80107297 <vector145>:
.globl vector145
vector145:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $145
80107299:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010729e:	e9 f0 f5 ff ff       	jmp    80106893 <alltraps>

801072a3 <vector146>:
.globl vector146
vector146:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $146
801072a5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801072aa:	e9 e4 f5 ff ff       	jmp    80106893 <alltraps>

801072af <vector147>:
.globl vector147
vector147:
  pushl $0
801072af:	6a 00                	push   $0x0
  pushl $147
801072b1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801072b6:	e9 d8 f5 ff ff       	jmp    80106893 <alltraps>

801072bb <vector148>:
.globl vector148
vector148:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $148
801072bd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801072c2:	e9 cc f5 ff ff       	jmp    80106893 <alltraps>

801072c7 <vector149>:
.globl vector149
vector149:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $149
801072c9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801072ce:	e9 c0 f5 ff ff       	jmp    80106893 <alltraps>

801072d3 <vector150>:
.globl vector150
vector150:
  pushl $0
801072d3:	6a 00                	push   $0x0
  pushl $150
801072d5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801072da:	e9 b4 f5 ff ff       	jmp    80106893 <alltraps>

801072df <vector151>:
.globl vector151
vector151:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $151
801072e1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801072e6:	e9 a8 f5 ff ff       	jmp    80106893 <alltraps>

801072eb <vector152>:
.globl vector152
vector152:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $152
801072ed:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801072f2:	e9 9c f5 ff ff       	jmp    80106893 <alltraps>

801072f7 <vector153>:
.globl vector153
vector153:
  pushl $0
801072f7:	6a 00                	push   $0x0
  pushl $153
801072f9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801072fe:	e9 90 f5 ff ff       	jmp    80106893 <alltraps>

80107303 <vector154>:
.globl vector154
vector154:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $154
80107305:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010730a:	e9 84 f5 ff ff       	jmp    80106893 <alltraps>

8010730f <vector155>:
.globl vector155
vector155:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $155
80107311:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107316:	e9 78 f5 ff ff       	jmp    80106893 <alltraps>

8010731b <vector156>:
.globl vector156
vector156:
  pushl $0
8010731b:	6a 00                	push   $0x0
  pushl $156
8010731d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107322:	e9 6c f5 ff ff       	jmp    80106893 <alltraps>

80107327 <vector157>:
.globl vector157
vector157:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $157
80107329:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010732e:	e9 60 f5 ff ff       	jmp    80106893 <alltraps>

80107333 <vector158>:
.globl vector158
vector158:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $158
80107335:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010733a:	e9 54 f5 ff ff       	jmp    80106893 <alltraps>

8010733f <vector159>:
.globl vector159
vector159:
  pushl $0
8010733f:	6a 00                	push   $0x0
  pushl $159
80107341:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107346:	e9 48 f5 ff ff       	jmp    80106893 <alltraps>

8010734b <vector160>:
.globl vector160
vector160:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $160
8010734d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107352:	e9 3c f5 ff ff       	jmp    80106893 <alltraps>

80107357 <vector161>:
.globl vector161
vector161:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $161
80107359:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010735e:	e9 30 f5 ff ff       	jmp    80106893 <alltraps>

80107363 <vector162>:
.globl vector162
vector162:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $162
80107365:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010736a:	e9 24 f5 ff ff       	jmp    80106893 <alltraps>

8010736f <vector163>:
.globl vector163
vector163:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $163
80107371:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107376:	e9 18 f5 ff ff       	jmp    80106893 <alltraps>

8010737b <vector164>:
.globl vector164
vector164:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $164
8010737d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107382:	e9 0c f5 ff ff       	jmp    80106893 <alltraps>

80107387 <vector165>:
.globl vector165
vector165:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $165
80107389:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010738e:	e9 00 f5 ff ff       	jmp    80106893 <alltraps>

80107393 <vector166>:
.globl vector166
vector166:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $166
80107395:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010739a:	e9 f4 f4 ff ff       	jmp    80106893 <alltraps>

8010739f <vector167>:
.globl vector167
vector167:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $167
801073a1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801073a6:	e9 e8 f4 ff ff       	jmp    80106893 <alltraps>

801073ab <vector168>:
.globl vector168
vector168:
  pushl $0
801073ab:	6a 00                	push   $0x0
  pushl $168
801073ad:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801073b2:	e9 dc f4 ff ff       	jmp    80106893 <alltraps>

801073b7 <vector169>:
.globl vector169
vector169:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $169
801073b9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801073be:	e9 d0 f4 ff ff       	jmp    80106893 <alltraps>

801073c3 <vector170>:
.globl vector170
vector170:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $170
801073c5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801073ca:	e9 c4 f4 ff ff       	jmp    80106893 <alltraps>

801073cf <vector171>:
.globl vector171
vector171:
  pushl $0
801073cf:	6a 00                	push   $0x0
  pushl $171
801073d1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801073d6:	e9 b8 f4 ff ff       	jmp    80106893 <alltraps>

801073db <vector172>:
.globl vector172
vector172:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $172
801073dd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801073e2:	e9 ac f4 ff ff       	jmp    80106893 <alltraps>

801073e7 <vector173>:
.globl vector173
vector173:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $173
801073e9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801073ee:	e9 a0 f4 ff ff       	jmp    80106893 <alltraps>

801073f3 <vector174>:
.globl vector174
vector174:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $174
801073f5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801073fa:	e9 94 f4 ff ff       	jmp    80106893 <alltraps>

801073ff <vector175>:
.globl vector175
vector175:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $175
80107401:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107406:	e9 88 f4 ff ff       	jmp    80106893 <alltraps>

8010740b <vector176>:
.globl vector176
vector176:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $176
8010740d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107412:	e9 7c f4 ff ff       	jmp    80106893 <alltraps>

80107417 <vector177>:
.globl vector177
vector177:
  pushl $0
80107417:	6a 00                	push   $0x0
  pushl $177
80107419:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010741e:	e9 70 f4 ff ff       	jmp    80106893 <alltraps>

80107423 <vector178>:
.globl vector178
vector178:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $178
80107425:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010742a:	e9 64 f4 ff ff       	jmp    80106893 <alltraps>

8010742f <vector179>:
.globl vector179
vector179:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $179
80107431:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107436:	e9 58 f4 ff ff       	jmp    80106893 <alltraps>

8010743b <vector180>:
.globl vector180
vector180:
  pushl $0
8010743b:	6a 00                	push   $0x0
  pushl $180
8010743d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107442:	e9 4c f4 ff ff       	jmp    80106893 <alltraps>

80107447 <vector181>:
.globl vector181
vector181:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $181
80107449:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010744e:	e9 40 f4 ff ff       	jmp    80106893 <alltraps>

80107453 <vector182>:
.globl vector182
vector182:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $182
80107455:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010745a:	e9 34 f4 ff ff       	jmp    80106893 <alltraps>

8010745f <vector183>:
.globl vector183
vector183:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $183
80107461:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107466:	e9 28 f4 ff ff       	jmp    80106893 <alltraps>

8010746b <vector184>:
.globl vector184
vector184:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $184
8010746d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107472:	e9 1c f4 ff ff       	jmp    80106893 <alltraps>

80107477 <vector185>:
.globl vector185
vector185:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $185
80107479:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010747e:	e9 10 f4 ff ff       	jmp    80106893 <alltraps>

80107483 <vector186>:
.globl vector186
vector186:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $186
80107485:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010748a:	e9 04 f4 ff ff       	jmp    80106893 <alltraps>

8010748f <vector187>:
.globl vector187
vector187:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $187
80107491:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107496:	e9 f8 f3 ff ff       	jmp    80106893 <alltraps>

8010749b <vector188>:
.globl vector188
vector188:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $188
8010749d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801074a2:	e9 ec f3 ff ff       	jmp    80106893 <alltraps>

801074a7 <vector189>:
.globl vector189
vector189:
  pushl $0
801074a7:	6a 00                	push   $0x0
  pushl $189
801074a9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801074ae:	e9 e0 f3 ff ff       	jmp    80106893 <alltraps>

801074b3 <vector190>:
.globl vector190
vector190:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $190
801074b5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801074ba:	e9 d4 f3 ff ff       	jmp    80106893 <alltraps>

801074bf <vector191>:
.globl vector191
vector191:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $191
801074c1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801074c6:	e9 c8 f3 ff ff       	jmp    80106893 <alltraps>

801074cb <vector192>:
.globl vector192
vector192:
  pushl $0
801074cb:	6a 00                	push   $0x0
  pushl $192
801074cd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801074d2:	e9 bc f3 ff ff       	jmp    80106893 <alltraps>

801074d7 <vector193>:
.globl vector193
vector193:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $193
801074d9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801074de:	e9 b0 f3 ff ff       	jmp    80106893 <alltraps>

801074e3 <vector194>:
.globl vector194
vector194:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $194
801074e5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801074ea:	e9 a4 f3 ff ff       	jmp    80106893 <alltraps>

801074ef <vector195>:
.globl vector195
vector195:
  pushl $0
801074ef:	6a 00                	push   $0x0
  pushl $195
801074f1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801074f6:	e9 98 f3 ff ff       	jmp    80106893 <alltraps>

801074fb <vector196>:
.globl vector196
vector196:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $196
801074fd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107502:	e9 8c f3 ff ff       	jmp    80106893 <alltraps>

80107507 <vector197>:
.globl vector197
vector197:
  pushl $0
80107507:	6a 00                	push   $0x0
  pushl $197
80107509:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010750e:	e9 80 f3 ff ff       	jmp    80106893 <alltraps>

80107513 <vector198>:
.globl vector198
vector198:
  pushl $0
80107513:	6a 00                	push   $0x0
  pushl $198
80107515:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010751a:	e9 74 f3 ff ff       	jmp    80106893 <alltraps>

8010751f <vector199>:
.globl vector199
vector199:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $199
80107521:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107526:	e9 68 f3 ff ff       	jmp    80106893 <alltraps>

8010752b <vector200>:
.globl vector200
vector200:
  pushl $0
8010752b:	6a 00                	push   $0x0
  pushl $200
8010752d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107532:	e9 5c f3 ff ff       	jmp    80106893 <alltraps>

80107537 <vector201>:
.globl vector201
vector201:
  pushl $0
80107537:	6a 00                	push   $0x0
  pushl $201
80107539:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010753e:	e9 50 f3 ff ff       	jmp    80106893 <alltraps>

80107543 <vector202>:
.globl vector202
vector202:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $202
80107545:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010754a:	e9 44 f3 ff ff       	jmp    80106893 <alltraps>

8010754f <vector203>:
.globl vector203
vector203:
  pushl $0
8010754f:	6a 00                	push   $0x0
  pushl $203
80107551:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107556:	e9 38 f3 ff ff       	jmp    80106893 <alltraps>

8010755b <vector204>:
.globl vector204
vector204:
  pushl $0
8010755b:	6a 00                	push   $0x0
  pushl $204
8010755d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107562:	e9 2c f3 ff ff       	jmp    80106893 <alltraps>

80107567 <vector205>:
.globl vector205
vector205:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $205
80107569:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010756e:	e9 20 f3 ff ff       	jmp    80106893 <alltraps>

80107573 <vector206>:
.globl vector206
vector206:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $206
80107575:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010757a:	e9 14 f3 ff ff       	jmp    80106893 <alltraps>

8010757f <vector207>:
.globl vector207
vector207:
  pushl $0
8010757f:	6a 00                	push   $0x0
  pushl $207
80107581:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107586:	e9 08 f3 ff ff       	jmp    80106893 <alltraps>

8010758b <vector208>:
.globl vector208
vector208:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $208
8010758d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107592:	e9 fc f2 ff ff       	jmp    80106893 <alltraps>

80107597 <vector209>:
.globl vector209
vector209:
  pushl $0
80107597:	6a 00                	push   $0x0
  pushl $209
80107599:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010759e:	e9 f0 f2 ff ff       	jmp    80106893 <alltraps>

801075a3 <vector210>:
.globl vector210
vector210:
  pushl $0
801075a3:	6a 00                	push   $0x0
  pushl $210
801075a5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801075aa:	e9 e4 f2 ff ff       	jmp    80106893 <alltraps>

801075af <vector211>:
.globl vector211
vector211:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $211
801075b1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801075b6:	e9 d8 f2 ff ff       	jmp    80106893 <alltraps>

801075bb <vector212>:
.globl vector212
vector212:
  pushl $0
801075bb:	6a 00                	push   $0x0
  pushl $212
801075bd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801075c2:	e9 cc f2 ff ff       	jmp    80106893 <alltraps>

801075c7 <vector213>:
.globl vector213
vector213:
  pushl $0
801075c7:	6a 00                	push   $0x0
  pushl $213
801075c9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801075ce:	e9 c0 f2 ff ff       	jmp    80106893 <alltraps>

801075d3 <vector214>:
.globl vector214
vector214:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $214
801075d5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801075da:	e9 b4 f2 ff ff       	jmp    80106893 <alltraps>

801075df <vector215>:
.globl vector215
vector215:
  pushl $0
801075df:	6a 00                	push   $0x0
  pushl $215
801075e1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801075e6:	e9 a8 f2 ff ff       	jmp    80106893 <alltraps>

801075eb <vector216>:
.globl vector216
vector216:
  pushl $0
801075eb:	6a 00                	push   $0x0
  pushl $216
801075ed:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801075f2:	e9 9c f2 ff ff       	jmp    80106893 <alltraps>

801075f7 <vector217>:
.globl vector217
vector217:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $217
801075f9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801075fe:	e9 90 f2 ff ff       	jmp    80106893 <alltraps>

80107603 <vector218>:
.globl vector218
vector218:
  pushl $0
80107603:	6a 00                	push   $0x0
  pushl $218
80107605:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010760a:	e9 84 f2 ff ff       	jmp    80106893 <alltraps>

8010760f <vector219>:
.globl vector219
vector219:
  pushl $0
8010760f:	6a 00                	push   $0x0
  pushl $219
80107611:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107616:	e9 78 f2 ff ff       	jmp    80106893 <alltraps>

8010761b <vector220>:
.globl vector220
vector220:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $220
8010761d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107622:	e9 6c f2 ff ff       	jmp    80106893 <alltraps>

80107627 <vector221>:
.globl vector221
vector221:
  pushl $0
80107627:	6a 00                	push   $0x0
  pushl $221
80107629:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010762e:	e9 60 f2 ff ff       	jmp    80106893 <alltraps>

80107633 <vector222>:
.globl vector222
vector222:
  pushl $0
80107633:	6a 00                	push   $0x0
  pushl $222
80107635:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010763a:	e9 54 f2 ff ff       	jmp    80106893 <alltraps>

8010763f <vector223>:
.globl vector223
vector223:
  pushl $0
8010763f:	6a 00                	push   $0x0
  pushl $223
80107641:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107646:	e9 48 f2 ff ff       	jmp    80106893 <alltraps>

8010764b <vector224>:
.globl vector224
vector224:
  pushl $0
8010764b:	6a 00                	push   $0x0
  pushl $224
8010764d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107652:	e9 3c f2 ff ff       	jmp    80106893 <alltraps>

80107657 <vector225>:
.globl vector225
vector225:
  pushl $0
80107657:	6a 00                	push   $0x0
  pushl $225
80107659:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010765e:	e9 30 f2 ff ff       	jmp    80106893 <alltraps>

80107663 <vector226>:
.globl vector226
vector226:
  pushl $0
80107663:	6a 00                	push   $0x0
  pushl $226
80107665:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010766a:	e9 24 f2 ff ff       	jmp    80106893 <alltraps>

8010766f <vector227>:
.globl vector227
vector227:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $227
80107671:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107676:	e9 18 f2 ff ff       	jmp    80106893 <alltraps>

8010767b <vector228>:
.globl vector228
vector228:
  pushl $0
8010767b:	6a 00                	push   $0x0
  pushl $228
8010767d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107682:	e9 0c f2 ff ff       	jmp    80106893 <alltraps>

80107687 <vector229>:
.globl vector229
vector229:
  pushl $0
80107687:	6a 00                	push   $0x0
  pushl $229
80107689:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010768e:	e9 00 f2 ff ff       	jmp    80106893 <alltraps>

80107693 <vector230>:
.globl vector230
vector230:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $230
80107695:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010769a:	e9 f4 f1 ff ff       	jmp    80106893 <alltraps>

8010769f <vector231>:
.globl vector231
vector231:
  pushl $0
8010769f:	6a 00                	push   $0x0
  pushl $231
801076a1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801076a6:	e9 e8 f1 ff ff       	jmp    80106893 <alltraps>

801076ab <vector232>:
.globl vector232
vector232:
  pushl $0
801076ab:	6a 00                	push   $0x0
  pushl $232
801076ad:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801076b2:	e9 dc f1 ff ff       	jmp    80106893 <alltraps>

801076b7 <vector233>:
.globl vector233
vector233:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $233
801076b9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801076be:	e9 d0 f1 ff ff       	jmp    80106893 <alltraps>

801076c3 <vector234>:
.globl vector234
vector234:
  pushl $0
801076c3:	6a 00                	push   $0x0
  pushl $234
801076c5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801076ca:	e9 c4 f1 ff ff       	jmp    80106893 <alltraps>

801076cf <vector235>:
.globl vector235
vector235:
  pushl $0
801076cf:	6a 00                	push   $0x0
  pushl $235
801076d1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801076d6:	e9 b8 f1 ff ff       	jmp    80106893 <alltraps>

801076db <vector236>:
.globl vector236
vector236:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $236
801076dd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801076e2:	e9 ac f1 ff ff       	jmp    80106893 <alltraps>

801076e7 <vector237>:
.globl vector237
vector237:
  pushl $0
801076e7:	6a 00                	push   $0x0
  pushl $237
801076e9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801076ee:	e9 a0 f1 ff ff       	jmp    80106893 <alltraps>

801076f3 <vector238>:
.globl vector238
vector238:
  pushl $0
801076f3:	6a 00                	push   $0x0
  pushl $238
801076f5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801076fa:	e9 94 f1 ff ff       	jmp    80106893 <alltraps>

801076ff <vector239>:
.globl vector239
vector239:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $239
80107701:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107706:	e9 88 f1 ff ff       	jmp    80106893 <alltraps>

8010770b <vector240>:
.globl vector240
vector240:
  pushl $0
8010770b:	6a 00                	push   $0x0
  pushl $240
8010770d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107712:	e9 7c f1 ff ff       	jmp    80106893 <alltraps>

80107717 <vector241>:
.globl vector241
vector241:
  pushl $0
80107717:	6a 00                	push   $0x0
  pushl $241
80107719:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010771e:	e9 70 f1 ff ff       	jmp    80106893 <alltraps>

80107723 <vector242>:
.globl vector242
vector242:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $242
80107725:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010772a:	e9 64 f1 ff ff       	jmp    80106893 <alltraps>

8010772f <vector243>:
.globl vector243
vector243:
  pushl $0
8010772f:	6a 00                	push   $0x0
  pushl $243
80107731:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107736:	e9 58 f1 ff ff       	jmp    80106893 <alltraps>

8010773b <vector244>:
.globl vector244
vector244:
  pushl $0
8010773b:	6a 00                	push   $0x0
  pushl $244
8010773d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107742:	e9 4c f1 ff ff       	jmp    80106893 <alltraps>

80107747 <vector245>:
.globl vector245
vector245:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $245
80107749:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010774e:	e9 40 f1 ff ff       	jmp    80106893 <alltraps>

80107753 <vector246>:
.globl vector246
vector246:
  pushl $0
80107753:	6a 00                	push   $0x0
  pushl $246
80107755:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010775a:	e9 34 f1 ff ff       	jmp    80106893 <alltraps>

8010775f <vector247>:
.globl vector247
vector247:
  pushl $0
8010775f:	6a 00                	push   $0x0
  pushl $247
80107761:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107766:	e9 28 f1 ff ff       	jmp    80106893 <alltraps>

8010776b <vector248>:
.globl vector248
vector248:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $248
8010776d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107772:	e9 1c f1 ff ff       	jmp    80106893 <alltraps>

80107777 <vector249>:
.globl vector249
vector249:
  pushl $0
80107777:	6a 00                	push   $0x0
  pushl $249
80107779:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010777e:	e9 10 f1 ff ff       	jmp    80106893 <alltraps>

80107783 <vector250>:
.globl vector250
vector250:
  pushl $0
80107783:	6a 00                	push   $0x0
  pushl $250
80107785:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010778a:	e9 04 f1 ff ff       	jmp    80106893 <alltraps>

8010778f <vector251>:
.globl vector251
vector251:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $251
80107791:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107796:	e9 f8 f0 ff ff       	jmp    80106893 <alltraps>

8010779b <vector252>:
.globl vector252
vector252:
  pushl $0
8010779b:	6a 00                	push   $0x0
  pushl $252
8010779d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801077a2:	e9 ec f0 ff ff       	jmp    80106893 <alltraps>

801077a7 <vector253>:
.globl vector253
vector253:
  pushl $0
801077a7:	6a 00                	push   $0x0
  pushl $253
801077a9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801077ae:	e9 e0 f0 ff ff       	jmp    80106893 <alltraps>

801077b3 <vector254>:
.globl vector254
vector254:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $254
801077b5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801077ba:	e9 d4 f0 ff ff       	jmp    80106893 <alltraps>

801077bf <vector255>:
.globl vector255
vector255:
  pushl $0
801077bf:	6a 00                	push   $0x0
  pushl $255
801077c1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801077c6:	e9 c8 f0 ff ff       	jmp    80106893 <alltraps>
801077cb:	66 90                	xchg   %ax,%ax
801077cd:	66 90                	xchg   %ax,%ax
801077cf:	90                   	nop

801077d0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801077d0:	55                   	push   %ebp
801077d1:	89 e5                	mov    %esp,%ebp
801077d3:	57                   	push   %edi
801077d4:	56                   	push   %esi
801077d5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801077d7:	c1 ea 16             	shr    $0x16,%edx
{
801077da:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801077db:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801077de:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801077e1:	8b 1f                	mov    (%edi),%ebx
801077e3:	f6 c3 01             	test   $0x1,%bl
801077e6:	74 28                	je     80107810 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077e8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801077ee:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801077f4:	89 f0                	mov    %esi,%eax
}
801077f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801077f9:	c1 e8 0a             	shr    $0xa,%eax
801077fc:	25 fc 0f 00 00       	and    $0xffc,%eax
80107801:	01 d8                	add    %ebx,%eax
}
80107803:	5b                   	pop    %ebx
80107804:	5e                   	pop    %esi
80107805:	5f                   	pop    %edi
80107806:	5d                   	pop    %ebp
80107807:	c3                   	ret    
80107808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010780f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107810:	85 c9                	test   %ecx,%ecx
80107812:	74 2c                	je     80107840 <walkpgdir+0x70>
80107814:	e8 17 ae ff ff       	call   80102630 <kalloc>
80107819:	89 c3                	mov    %eax,%ebx
8010781b:	85 c0                	test   %eax,%eax
8010781d:	74 21                	je     80107840 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010781f:	83 ec 04             	sub    $0x4,%esp
80107822:	68 00 10 00 00       	push   $0x1000
80107827:	6a 00                	push   $0x0
80107829:	50                   	push   %eax
8010782a:	e8 81 d8 ff ff       	call   801050b0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010782f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107835:	83 c4 10             	add    $0x10,%esp
80107838:	83 c8 07             	or     $0x7,%eax
8010783b:	89 07                	mov    %eax,(%edi)
8010783d:	eb b5                	jmp    801077f4 <walkpgdir+0x24>
8010783f:	90                   	nop
}
80107840:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107843:	31 c0                	xor    %eax,%eax
}
80107845:	5b                   	pop    %ebx
80107846:	5e                   	pop    %esi
80107847:	5f                   	pop    %edi
80107848:	5d                   	pop    %ebp
80107849:	c3                   	ret    
8010784a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107850 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107850:	55                   	push   %ebp
80107851:	89 e5                	mov    %esp,%ebp
80107853:	57                   	push   %edi
80107854:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107856:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010785a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010785b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107860:	89 d6                	mov    %edx,%esi
{
80107862:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107863:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107869:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010786c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010786f:	8b 45 08             	mov    0x8(%ebp),%eax
80107872:	29 f0                	sub    %esi,%eax
80107874:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107877:	eb 1f                	jmp    80107898 <mappages+0x48>
80107879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107880:	f6 00 01             	testb  $0x1,(%eax)
80107883:	75 45                	jne    801078ca <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107885:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107888:	83 cb 01             	or     $0x1,%ebx
8010788b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010788d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107890:	74 2e                	je     801078c0 <mappages+0x70>
      break;
    a += PGSIZE;
80107892:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010789b:	b9 01 00 00 00       	mov    $0x1,%ecx
801078a0:	89 f2                	mov    %esi,%edx
801078a2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801078a5:	89 f8                	mov    %edi,%eax
801078a7:	e8 24 ff ff ff       	call   801077d0 <walkpgdir>
801078ac:	85 c0                	test   %eax,%eax
801078ae:	75 d0                	jne    80107880 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801078b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801078b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801078b8:	5b                   	pop    %ebx
801078b9:	5e                   	pop    %esi
801078ba:	5f                   	pop    %edi
801078bb:	5d                   	pop    %ebp
801078bc:	c3                   	ret    
801078bd:	8d 76 00             	lea    0x0(%esi),%esi
801078c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801078c3:	31 c0                	xor    %eax,%eax
}
801078c5:	5b                   	pop    %ebx
801078c6:	5e                   	pop    %esi
801078c7:	5f                   	pop    %edi
801078c8:	5d                   	pop    %ebp
801078c9:	c3                   	ret    
      panic("remap");
801078ca:	83 ec 0c             	sub    $0xc,%esp
801078cd:	68 20 8b 10 80       	push   $0x80108b20
801078d2:	e8 b9 8a ff ff       	call   80100390 <panic>
801078d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078de:	66 90                	xchg   %ax,%ax

801078e0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	57                   	push   %edi
801078e4:	56                   	push   %esi
801078e5:	89 c6                	mov    %eax,%esi
801078e7:	53                   	push   %ebx
801078e8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801078ea:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801078f0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801078f6:	83 ec 1c             	sub    $0x1c,%esp
801078f9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801078fc:	39 da                	cmp    %ebx,%edx
801078fe:	73 5b                	jae    8010795b <deallocuvm.part.0+0x7b>
80107900:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107903:	89 d7                	mov    %edx,%edi
80107905:	eb 14                	jmp    8010791b <deallocuvm.part.0+0x3b>
80107907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010790e:	66 90                	xchg   %ax,%ax
80107910:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107916:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107919:	76 40                	jbe    8010795b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010791b:	31 c9                	xor    %ecx,%ecx
8010791d:	89 fa                	mov    %edi,%edx
8010791f:	89 f0                	mov    %esi,%eax
80107921:	e8 aa fe ff ff       	call   801077d0 <walkpgdir>
80107926:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107928:	85 c0                	test   %eax,%eax
8010792a:	74 44                	je     80107970 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010792c:	8b 00                	mov    (%eax),%eax
8010792e:	a8 01                	test   $0x1,%al
80107930:	74 de                	je     80107910 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107932:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107937:	74 47                	je     80107980 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107939:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010793c:	05 00 00 00 80       	add    $0x80000000,%eax
80107941:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107947:	50                   	push   %eax
80107948:	e8 23 ab ff ff       	call   80102470 <kfree>
      *pte = 0;
8010794d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107953:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107956:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107959:	77 c0                	ja     8010791b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010795b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010795e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107961:	5b                   	pop    %ebx
80107962:	5e                   	pop    %esi
80107963:	5f                   	pop    %edi
80107964:	5d                   	pop    %ebp
80107965:	c3                   	ret    
80107966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010796d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107970:	89 fa                	mov    %edi,%edx
80107972:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107978:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010797e:	eb 96                	jmp    80107916 <deallocuvm.part.0+0x36>
        panic("kfree");
80107980:	83 ec 0c             	sub    $0xc,%esp
80107983:	68 86 83 10 80       	push   $0x80108386
80107988:	e8 03 8a ff ff       	call   80100390 <panic>
8010798d:	8d 76 00             	lea    0x0(%esi),%esi

80107990 <seginit>:
{
80107990:	f3 0f 1e fb          	endbr32 
80107994:	55                   	push   %ebp
80107995:	89 e5                	mov    %esp,%ebp
80107997:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010799a:	e8 41 c0 ff ff       	call   801039e0 <cpuid>
  pd[0] = size-1;
8010799f:	ba 2f 00 00 00       	mov    $0x2f,%edx
801079a4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801079aa:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801079ae:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
801079b5:	ff 00 00 
801079b8:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
801079bf:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801079c2:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
801079c9:	ff 00 00 
801079cc:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
801079d3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801079d6:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
801079dd:	ff 00 00 
801079e0:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
801079e7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801079ea:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
801079f1:	ff 00 00 
801079f4:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
801079fb:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801079fe:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80107a03:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107a07:	c1 e8 10             	shr    $0x10,%eax
80107a0a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107a0e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107a11:	0f 01 10             	lgdtl  (%eax)
}
80107a14:	c9                   	leave  
80107a15:	c3                   	ret    
80107a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a1d:	8d 76 00             	lea    0x0(%esi),%esi

80107a20 <switchkvm>:
{
80107a20:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107a24:	a1 a4 6d 11 80       	mov    0x80116da4,%eax
80107a29:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107a2e:	0f 22 d8             	mov    %eax,%cr3
}
80107a31:	c3                   	ret    
80107a32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a40 <switchuvm>:
{
80107a40:	f3 0f 1e fb          	endbr32 
80107a44:	55                   	push   %ebp
80107a45:	89 e5                	mov    %esp,%ebp
80107a47:	57                   	push   %edi
80107a48:	56                   	push   %esi
80107a49:	53                   	push   %ebx
80107a4a:	83 ec 1c             	sub    $0x1c,%esp
80107a4d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107a50:	85 f6                	test   %esi,%esi
80107a52:	0f 84 cb 00 00 00    	je     80107b23 <switchuvm+0xe3>
  if(p->kstack == 0)
80107a58:	8b 46 08             	mov    0x8(%esi),%eax
80107a5b:	85 c0                	test   %eax,%eax
80107a5d:	0f 84 da 00 00 00    	je     80107b3d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107a63:	8b 46 04             	mov    0x4(%esi),%eax
80107a66:	85 c0                	test   %eax,%eax
80107a68:	0f 84 c2 00 00 00    	je     80107b30 <switchuvm+0xf0>
  pushcli();
80107a6e:	e8 2d d4 ff ff       	call   80104ea0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107a73:	e8 f8 be ff ff       	call   80103970 <mycpu>
80107a78:	89 c3                	mov    %eax,%ebx
80107a7a:	e8 f1 be ff ff       	call   80103970 <mycpu>
80107a7f:	89 c7                	mov    %eax,%edi
80107a81:	e8 ea be ff ff       	call   80103970 <mycpu>
80107a86:	83 c7 08             	add    $0x8,%edi
80107a89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a8c:	e8 df be ff ff       	call   80103970 <mycpu>
80107a91:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107a94:	ba 67 00 00 00       	mov    $0x67,%edx
80107a99:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107aa0:	83 c0 08             	add    $0x8,%eax
80107aa3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107aaa:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107aaf:	83 c1 08             	add    $0x8,%ecx
80107ab2:	c1 e8 18             	shr    $0x18,%eax
80107ab5:	c1 e9 10             	shr    $0x10,%ecx
80107ab8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107abe:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107ac4:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107ac9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107ad0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107ad5:	e8 96 be ff ff       	call   80103970 <mycpu>
80107ada:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107ae1:	e8 8a be ff ff       	call   80103970 <mycpu>
80107ae6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107aea:	8b 5e 08             	mov    0x8(%esi),%ebx
80107aed:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107af3:	e8 78 be ff ff       	call   80103970 <mycpu>
80107af8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107afb:	e8 70 be ff ff       	call   80103970 <mycpu>
80107b00:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107b04:	b8 28 00 00 00       	mov    $0x28,%eax
80107b09:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107b0c:	8b 46 04             	mov    0x4(%esi),%eax
80107b0f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107b14:	0f 22 d8             	mov    %eax,%cr3
}
80107b17:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b1a:	5b                   	pop    %ebx
80107b1b:	5e                   	pop    %esi
80107b1c:	5f                   	pop    %edi
80107b1d:	5d                   	pop    %ebp
  popcli();
80107b1e:	e9 cd d3 ff ff       	jmp    80104ef0 <popcli>
    panic("switchuvm: no process");
80107b23:	83 ec 0c             	sub    $0xc,%esp
80107b26:	68 26 8b 10 80       	push   $0x80108b26
80107b2b:	e8 60 88 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107b30:	83 ec 0c             	sub    $0xc,%esp
80107b33:	68 51 8b 10 80       	push   $0x80108b51
80107b38:	e8 53 88 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107b3d:	83 ec 0c             	sub    $0xc,%esp
80107b40:	68 3c 8b 10 80       	push   $0x80108b3c
80107b45:	e8 46 88 ff ff       	call   80100390 <panic>
80107b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b50 <inituvm>:
{
80107b50:	f3 0f 1e fb          	endbr32 
80107b54:	55                   	push   %ebp
80107b55:	89 e5                	mov    %esp,%ebp
80107b57:	57                   	push   %edi
80107b58:	56                   	push   %esi
80107b59:	53                   	push   %ebx
80107b5a:	83 ec 1c             	sub    $0x1c,%esp
80107b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b60:	8b 75 10             	mov    0x10(%ebp),%esi
80107b63:	8b 7d 08             	mov    0x8(%ebp),%edi
80107b66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107b69:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107b6f:	77 4b                	ja     80107bbc <inituvm+0x6c>
  mem = kalloc();
80107b71:	e8 ba aa ff ff       	call   80102630 <kalloc>
  memset(mem, 0, PGSIZE);
80107b76:	83 ec 04             	sub    $0x4,%esp
80107b79:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107b7e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107b80:	6a 00                	push   $0x0
80107b82:	50                   	push   %eax
80107b83:	e8 28 d5 ff ff       	call   801050b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107b88:	58                   	pop    %eax
80107b89:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107b8f:	5a                   	pop    %edx
80107b90:	6a 06                	push   $0x6
80107b92:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b97:	31 d2                	xor    %edx,%edx
80107b99:	50                   	push   %eax
80107b9a:	89 f8                	mov    %edi,%eax
80107b9c:	e8 af fc ff ff       	call   80107850 <mappages>
  memmove(mem, init, sz);
80107ba1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ba4:	89 75 10             	mov    %esi,0x10(%ebp)
80107ba7:	83 c4 10             	add    $0x10,%esp
80107baa:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107bad:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bb3:	5b                   	pop    %ebx
80107bb4:	5e                   	pop    %esi
80107bb5:	5f                   	pop    %edi
80107bb6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107bb7:	e9 94 d5 ff ff       	jmp    80105150 <memmove>
    panic("inituvm: more than a page");
80107bbc:	83 ec 0c             	sub    $0xc,%esp
80107bbf:	68 65 8b 10 80       	push   $0x80108b65
80107bc4:	e8 c7 87 ff ff       	call   80100390 <panic>
80107bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107bd0 <loaduvm>:
{
80107bd0:	f3 0f 1e fb          	endbr32 
80107bd4:	55                   	push   %ebp
80107bd5:	89 e5                	mov    %esp,%ebp
80107bd7:	57                   	push   %edi
80107bd8:	56                   	push   %esi
80107bd9:	53                   	push   %ebx
80107bda:	83 ec 1c             	sub    $0x1c,%esp
80107bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107be0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107be3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107be8:	0f 85 99 00 00 00    	jne    80107c87 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80107bee:	01 f0                	add    %esi,%eax
80107bf0:	89 f3                	mov    %esi,%ebx
80107bf2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107bf5:	8b 45 14             	mov    0x14(%ebp),%eax
80107bf8:	01 f0                	add    %esi,%eax
80107bfa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107bfd:	85 f6                	test   %esi,%esi
80107bff:	75 15                	jne    80107c16 <loaduvm+0x46>
80107c01:	eb 6d                	jmp    80107c70 <loaduvm+0xa0>
80107c03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c07:	90                   	nop
80107c08:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107c0e:	89 f0                	mov    %esi,%eax
80107c10:	29 d8                	sub    %ebx,%eax
80107c12:	39 c6                	cmp    %eax,%esi
80107c14:	76 5a                	jbe    80107c70 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107c16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107c19:	8b 45 08             	mov    0x8(%ebp),%eax
80107c1c:	31 c9                	xor    %ecx,%ecx
80107c1e:	29 da                	sub    %ebx,%edx
80107c20:	e8 ab fb ff ff       	call   801077d0 <walkpgdir>
80107c25:	85 c0                	test   %eax,%eax
80107c27:	74 51                	je     80107c7a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107c29:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107c2b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107c2e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107c33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107c38:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107c3e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107c41:	29 d9                	sub    %ebx,%ecx
80107c43:	05 00 00 00 80       	add    $0x80000000,%eax
80107c48:	57                   	push   %edi
80107c49:	51                   	push   %ecx
80107c4a:	50                   	push   %eax
80107c4b:	ff 75 10             	pushl  0x10(%ebp)
80107c4e:	e8 0d 9e ff ff       	call   80101a60 <readi>
80107c53:	83 c4 10             	add    $0x10,%esp
80107c56:	39 f8                	cmp    %edi,%eax
80107c58:	74 ae                	je     80107c08 <loaduvm+0x38>
}
80107c5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107c5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c62:	5b                   	pop    %ebx
80107c63:	5e                   	pop    %esi
80107c64:	5f                   	pop    %edi
80107c65:	5d                   	pop    %ebp
80107c66:	c3                   	ret    
80107c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c6e:	66 90                	xchg   %ax,%ax
80107c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107c73:	31 c0                	xor    %eax,%eax
}
80107c75:	5b                   	pop    %ebx
80107c76:	5e                   	pop    %esi
80107c77:	5f                   	pop    %edi
80107c78:	5d                   	pop    %ebp
80107c79:	c3                   	ret    
      panic("loaduvm: address should exist");
80107c7a:	83 ec 0c             	sub    $0xc,%esp
80107c7d:	68 7f 8b 10 80       	push   $0x80108b7f
80107c82:	e8 09 87 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107c87:	83 ec 0c             	sub    $0xc,%esp
80107c8a:	68 20 8c 10 80       	push   $0x80108c20
80107c8f:	e8 fc 86 ff ff       	call   80100390 <panic>
80107c94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c9f:	90                   	nop

80107ca0 <allocuvm>:
{
80107ca0:	f3 0f 1e fb          	endbr32 
80107ca4:	55                   	push   %ebp
80107ca5:	89 e5                	mov    %esp,%ebp
80107ca7:	57                   	push   %edi
80107ca8:	56                   	push   %esi
80107ca9:	53                   	push   %ebx
80107caa:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107cad:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107cb0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107cb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107cb6:	85 c0                	test   %eax,%eax
80107cb8:	0f 88 b2 00 00 00    	js     80107d70 <allocuvm+0xd0>
  if(newsz < oldsz)
80107cbe:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107cc4:	0f 82 96 00 00 00    	jb     80107d60 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107cca:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107cd0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107cd6:	39 75 10             	cmp    %esi,0x10(%ebp)
80107cd9:	77 40                	ja     80107d1b <allocuvm+0x7b>
80107cdb:	e9 83 00 00 00       	jmp    80107d63 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107ce0:	83 ec 04             	sub    $0x4,%esp
80107ce3:	68 00 10 00 00       	push   $0x1000
80107ce8:	6a 00                	push   $0x0
80107cea:	50                   	push   %eax
80107ceb:	e8 c0 d3 ff ff       	call   801050b0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107cf0:	58                   	pop    %eax
80107cf1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107cf7:	5a                   	pop    %edx
80107cf8:	6a 06                	push   $0x6
80107cfa:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107cff:	89 f2                	mov    %esi,%edx
80107d01:	50                   	push   %eax
80107d02:	89 f8                	mov    %edi,%eax
80107d04:	e8 47 fb ff ff       	call   80107850 <mappages>
80107d09:	83 c4 10             	add    $0x10,%esp
80107d0c:	85 c0                	test   %eax,%eax
80107d0e:	78 78                	js     80107d88 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107d10:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107d16:	39 75 10             	cmp    %esi,0x10(%ebp)
80107d19:	76 48                	jbe    80107d63 <allocuvm+0xc3>
    mem = kalloc();
80107d1b:	e8 10 a9 ff ff       	call   80102630 <kalloc>
80107d20:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107d22:	85 c0                	test   %eax,%eax
80107d24:	75 ba                	jne    80107ce0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107d26:	83 ec 0c             	sub    $0xc,%esp
80107d29:	68 9d 8b 10 80       	push   $0x80108b9d
80107d2e:	e8 7d 89 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107d33:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d36:	83 c4 10             	add    $0x10,%esp
80107d39:	39 45 10             	cmp    %eax,0x10(%ebp)
80107d3c:	74 32                	je     80107d70 <allocuvm+0xd0>
80107d3e:	8b 55 10             	mov    0x10(%ebp),%edx
80107d41:	89 c1                	mov    %eax,%ecx
80107d43:	89 f8                	mov    %edi,%eax
80107d45:	e8 96 fb ff ff       	call   801078e0 <deallocuvm.part.0>
      return 0;
80107d4a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107d51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d57:	5b                   	pop    %ebx
80107d58:	5e                   	pop    %esi
80107d59:	5f                   	pop    %edi
80107d5a:	5d                   	pop    %ebp
80107d5b:	c3                   	ret    
80107d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107d60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107d63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d69:	5b                   	pop    %ebx
80107d6a:	5e                   	pop    %esi
80107d6b:	5f                   	pop    %edi
80107d6c:	5d                   	pop    %ebp
80107d6d:	c3                   	ret    
80107d6e:	66 90                	xchg   %ax,%ax
    return 0;
80107d70:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107d77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d7d:	5b                   	pop    %ebx
80107d7e:	5e                   	pop    %esi
80107d7f:	5f                   	pop    %edi
80107d80:	5d                   	pop    %ebp
80107d81:	c3                   	ret    
80107d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107d88:	83 ec 0c             	sub    $0xc,%esp
80107d8b:	68 b5 8b 10 80       	push   $0x80108bb5
80107d90:	e8 1b 89 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107d95:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d98:	83 c4 10             	add    $0x10,%esp
80107d9b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107d9e:	74 0c                	je     80107dac <allocuvm+0x10c>
80107da0:	8b 55 10             	mov    0x10(%ebp),%edx
80107da3:	89 c1                	mov    %eax,%ecx
80107da5:	89 f8                	mov    %edi,%eax
80107da7:	e8 34 fb ff ff       	call   801078e0 <deallocuvm.part.0>
      kfree(mem);
80107dac:	83 ec 0c             	sub    $0xc,%esp
80107daf:	53                   	push   %ebx
80107db0:	e8 bb a6 ff ff       	call   80102470 <kfree>
      return 0;
80107db5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107dbc:	83 c4 10             	add    $0x10,%esp
}
80107dbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107dc5:	5b                   	pop    %ebx
80107dc6:	5e                   	pop    %esi
80107dc7:	5f                   	pop    %edi
80107dc8:	5d                   	pop    %ebp
80107dc9:	c3                   	ret    
80107dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107dd0 <deallocuvm>:
{
80107dd0:	f3 0f 1e fb          	endbr32 
80107dd4:	55                   	push   %ebp
80107dd5:	89 e5                	mov    %esp,%ebp
80107dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
80107dda:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107de0:	39 d1                	cmp    %edx,%ecx
80107de2:	73 0c                	jae    80107df0 <deallocuvm+0x20>
}
80107de4:	5d                   	pop    %ebp
80107de5:	e9 f6 fa ff ff       	jmp    801078e0 <deallocuvm.part.0>
80107dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107df0:	89 d0                	mov    %edx,%eax
80107df2:	5d                   	pop    %ebp
80107df3:	c3                   	ret    
80107df4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107dff:	90                   	nop

80107e00 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107e00:	f3 0f 1e fb          	endbr32 
80107e04:	55                   	push   %ebp
80107e05:	89 e5                	mov    %esp,%ebp
80107e07:	57                   	push   %edi
80107e08:	56                   	push   %esi
80107e09:	53                   	push   %ebx
80107e0a:	83 ec 0c             	sub    $0xc,%esp
80107e0d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107e10:	85 f6                	test   %esi,%esi
80107e12:	74 55                	je     80107e69 <freevm+0x69>
  if(newsz >= oldsz)
80107e14:	31 c9                	xor    %ecx,%ecx
80107e16:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107e1b:	89 f0                	mov    %esi,%eax
80107e1d:	89 f3                	mov    %esi,%ebx
80107e1f:	e8 bc fa ff ff       	call   801078e0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107e24:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107e2a:	eb 0b                	jmp    80107e37 <freevm+0x37>
80107e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107e30:	83 c3 04             	add    $0x4,%ebx
80107e33:	39 df                	cmp    %ebx,%edi
80107e35:	74 23                	je     80107e5a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107e37:	8b 03                	mov    (%ebx),%eax
80107e39:	a8 01                	test   $0x1,%al
80107e3b:	74 f3                	je     80107e30 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107e3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107e42:	83 ec 0c             	sub    $0xc,%esp
80107e45:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107e48:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107e4d:	50                   	push   %eax
80107e4e:	e8 1d a6 ff ff       	call   80102470 <kfree>
80107e53:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107e56:	39 df                	cmp    %ebx,%edi
80107e58:	75 dd                	jne    80107e37 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107e5a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107e5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e60:	5b                   	pop    %ebx
80107e61:	5e                   	pop    %esi
80107e62:	5f                   	pop    %edi
80107e63:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107e64:	e9 07 a6 ff ff       	jmp    80102470 <kfree>
    panic("freevm: no pgdir");
80107e69:	83 ec 0c             	sub    $0xc,%esp
80107e6c:	68 d1 8b 10 80       	push   $0x80108bd1
80107e71:	e8 1a 85 ff ff       	call   80100390 <panic>
80107e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e7d:	8d 76 00             	lea    0x0(%esi),%esi

80107e80 <setupkvm>:
{
80107e80:	f3 0f 1e fb          	endbr32 
80107e84:	55                   	push   %ebp
80107e85:	89 e5                	mov    %esp,%ebp
80107e87:	56                   	push   %esi
80107e88:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107e89:	e8 a2 a7 ff ff       	call   80102630 <kalloc>
80107e8e:	89 c6                	mov    %eax,%esi
80107e90:	85 c0                	test   %eax,%eax
80107e92:	74 42                	je     80107ed6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107e94:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e97:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107e9c:	68 00 10 00 00       	push   $0x1000
80107ea1:	6a 00                	push   $0x0
80107ea3:	50                   	push   %eax
80107ea4:	e8 07 d2 ff ff       	call   801050b0 <memset>
80107ea9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107eac:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107eaf:	83 ec 08             	sub    $0x8,%esp
80107eb2:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107eb5:	ff 73 0c             	pushl  0xc(%ebx)
80107eb8:	8b 13                	mov    (%ebx),%edx
80107eba:	50                   	push   %eax
80107ebb:	29 c1                	sub    %eax,%ecx
80107ebd:	89 f0                	mov    %esi,%eax
80107ebf:	e8 8c f9 ff ff       	call   80107850 <mappages>
80107ec4:	83 c4 10             	add    $0x10,%esp
80107ec7:	85 c0                	test   %eax,%eax
80107ec9:	78 15                	js     80107ee0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ecb:	83 c3 10             	add    $0x10,%ebx
80107ece:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107ed4:	75 d6                	jne    80107eac <setupkvm+0x2c>
}
80107ed6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ed9:	89 f0                	mov    %esi,%eax
80107edb:	5b                   	pop    %ebx
80107edc:	5e                   	pop    %esi
80107edd:	5d                   	pop    %ebp
80107ede:	c3                   	ret    
80107edf:	90                   	nop
      freevm(pgdir);
80107ee0:	83 ec 0c             	sub    $0xc,%esp
80107ee3:	56                   	push   %esi
      return 0;
80107ee4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107ee6:	e8 15 ff ff ff       	call   80107e00 <freevm>
      return 0;
80107eeb:	83 c4 10             	add    $0x10,%esp
}
80107eee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ef1:	89 f0                	mov    %esi,%eax
80107ef3:	5b                   	pop    %ebx
80107ef4:	5e                   	pop    %esi
80107ef5:	5d                   	pop    %ebp
80107ef6:	c3                   	ret    
80107ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107efe:	66 90                	xchg   %ax,%ax

80107f00 <kvmalloc>:
{
80107f00:	f3 0f 1e fb          	endbr32 
80107f04:	55                   	push   %ebp
80107f05:	89 e5                	mov    %esp,%ebp
80107f07:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107f0a:	e8 71 ff ff ff       	call   80107e80 <setupkvm>
80107f0f:	a3 a4 6d 11 80       	mov    %eax,0x80116da4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107f14:	05 00 00 00 80       	add    $0x80000000,%eax
80107f19:	0f 22 d8             	mov    %eax,%cr3
}
80107f1c:	c9                   	leave  
80107f1d:	c3                   	ret    
80107f1e:	66 90                	xchg   %ax,%ax

80107f20 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107f20:	f3 0f 1e fb          	endbr32 
80107f24:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f25:	31 c9                	xor    %ecx,%ecx
{
80107f27:	89 e5                	mov    %esp,%ebp
80107f29:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107f2c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f2f:	8b 45 08             	mov    0x8(%ebp),%eax
80107f32:	e8 99 f8 ff ff       	call   801077d0 <walkpgdir>
  if(pte == 0)
80107f37:	85 c0                	test   %eax,%eax
80107f39:	74 05                	je     80107f40 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107f3b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107f3e:	c9                   	leave  
80107f3f:	c3                   	ret    
    panic("clearpteu");
80107f40:	83 ec 0c             	sub    $0xc,%esp
80107f43:	68 e2 8b 10 80       	push   $0x80108be2
80107f48:	e8 43 84 ff ff       	call   80100390 <panic>
80107f4d:	8d 76 00             	lea    0x0(%esi),%esi

80107f50 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107f50:	f3 0f 1e fb          	endbr32 
80107f54:	55                   	push   %ebp
80107f55:	89 e5                	mov    %esp,%ebp
80107f57:	57                   	push   %edi
80107f58:	56                   	push   %esi
80107f59:	53                   	push   %ebx
80107f5a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107f5d:	e8 1e ff ff ff       	call   80107e80 <setupkvm>
80107f62:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107f65:	85 c0                	test   %eax,%eax
80107f67:	0f 84 9b 00 00 00    	je     80108008 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107f6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107f70:	85 c9                	test   %ecx,%ecx
80107f72:	0f 84 90 00 00 00    	je     80108008 <copyuvm+0xb8>
80107f78:	31 f6                	xor    %esi,%esi
80107f7a:	eb 46                	jmp    80107fc2 <copyuvm+0x72>
80107f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107f80:	83 ec 04             	sub    $0x4,%esp
80107f83:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107f89:	68 00 10 00 00       	push   $0x1000
80107f8e:	57                   	push   %edi
80107f8f:	50                   	push   %eax
80107f90:	e8 bb d1 ff ff       	call   80105150 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107f95:	58                   	pop    %eax
80107f96:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107f9c:	5a                   	pop    %edx
80107f9d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107fa0:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107fa5:	89 f2                	mov    %esi,%edx
80107fa7:	50                   	push   %eax
80107fa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107fab:	e8 a0 f8 ff ff       	call   80107850 <mappages>
80107fb0:	83 c4 10             	add    $0x10,%esp
80107fb3:	85 c0                	test   %eax,%eax
80107fb5:	78 61                	js     80108018 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107fb7:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107fbd:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107fc0:	76 46                	jbe    80108008 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107fc2:	8b 45 08             	mov    0x8(%ebp),%eax
80107fc5:	31 c9                	xor    %ecx,%ecx
80107fc7:	89 f2                	mov    %esi,%edx
80107fc9:	e8 02 f8 ff ff       	call   801077d0 <walkpgdir>
80107fce:	85 c0                	test   %eax,%eax
80107fd0:	74 61                	je     80108033 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107fd2:	8b 00                	mov    (%eax),%eax
80107fd4:	a8 01                	test   $0x1,%al
80107fd6:	74 4e                	je     80108026 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107fd8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107fda:	25 ff 0f 00 00       	and    $0xfff,%eax
80107fdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107fe2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107fe8:	e8 43 a6 ff ff       	call   80102630 <kalloc>
80107fed:	89 c3                	mov    %eax,%ebx
80107fef:	85 c0                	test   %eax,%eax
80107ff1:	75 8d                	jne    80107f80 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107ff3:	83 ec 0c             	sub    $0xc,%esp
80107ff6:	ff 75 e0             	pushl  -0x20(%ebp)
80107ff9:	e8 02 fe ff ff       	call   80107e00 <freevm>
  return 0;
80107ffe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108005:	83 c4 10             	add    $0x10,%esp
}
80108008:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010800b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010800e:	5b                   	pop    %ebx
8010800f:	5e                   	pop    %esi
80108010:	5f                   	pop    %edi
80108011:	5d                   	pop    %ebp
80108012:	c3                   	ret    
80108013:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108017:	90                   	nop
      kfree(mem);
80108018:	83 ec 0c             	sub    $0xc,%esp
8010801b:	53                   	push   %ebx
8010801c:	e8 4f a4 ff ff       	call   80102470 <kfree>
      goto bad;
80108021:	83 c4 10             	add    $0x10,%esp
80108024:	eb cd                	jmp    80107ff3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80108026:	83 ec 0c             	sub    $0xc,%esp
80108029:	68 06 8c 10 80       	push   $0x80108c06
8010802e:	e8 5d 83 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108033:	83 ec 0c             	sub    $0xc,%esp
80108036:	68 ec 8b 10 80       	push   $0x80108bec
8010803b:	e8 50 83 ff ff       	call   80100390 <panic>

80108040 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108040:	f3 0f 1e fb          	endbr32 
80108044:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108045:	31 c9                	xor    %ecx,%ecx
{
80108047:	89 e5                	mov    %esp,%ebp
80108049:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010804c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010804f:	8b 45 08             	mov    0x8(%ebp),%eax
80108052:	e8 79 f7 ff ff       	call   801077d0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108057:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108059:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010805a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010805c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108061:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108064:	05 00 00 00 80       	add    $0x80000000,%eax
80108069:	83 fa 05             	cmp    $0x5,%edx
8010806c:	ba 00 00 00 00       	mov    $0x0,%edx
80108071:	0f 45 c2             	cmovne %edx,%eax
}
80108074:	c3                   	ret    
80108075:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010807c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108080 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108080:	f3 0f 1e fb          	endbr32 
80108084:	55                   	push   %ebp
80108085:	89 e5                	mov    %esp,%ebp
80108087:	57                   	push   %edi
80108088:	56                   	push   %esi
80108089:	53                   	push   %ebx
8010808a:	83 ec 0c             	sub    $0xc,%esp
8010808d:	8b 75 14             	mov    0x14(%ebp),%esi
80108090:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108093:	85 f6                	test   %esi,%esi
80108095:	75 3c                	jne    801080d3 <copyout+0x53>
80108097:	eb 67                	jmp    80108100 <copyout+0x80>
80108099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801080a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801080a3:	89 fb                	mov    %edi,%ebx
801080a5:	29 d3                	sub    %edx,%ebx
801080a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801080ad:	39 f3                	cmp    %esi,%ebx
801080af:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801080b2:	29 fa                	sub    %edi,%edx
801080b4:	83 ec 04             	sub    $0x4,%esp
801080b7:	01 c2                	add    %eax,%edx
801080b9:	53                   	push   %ebx
801080ba:	ff 75 10             	pushl  0x10(%ebp)
801080bd:	52                   	push   %edx
801080be:	e8 8d d0 ff ff       	call   80105150 <memmove>
    len -= n;
    buf += n;
801080c3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801080c6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801080cc:	83 c4 10             	add    $0x10,%esp
801080cf:	29 de                	sub    %ebx,%esi
801080d1:	74 2d                	je     80108100 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801080d3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801080d5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801080d8:	89 55 0c             	mov    %edx,0xc(%ebp)
801080db:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801080e1:	57                   	push   %edi
801080e2:	ff 75 08             	pushl  0x8(%ebp)
801080e5:	e8 56 ff ff ff       	call   80108040 <uva2ka>
    if(pa0 == 0)
801080ea:	83 c4 10             	add    $0x10,%esp
801080ed:	85 c0                	test   %eax,%eax
801080ef:	75 af                	jne    801080a0 <copyout+0x20>
  }
  return 0;
}
801080f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801080f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801080f9:	5b                   	pop    %ebx
801080fa:	5e                   	pop    %esi
801080fb:	5f                   	pop    %edi
801080fc:	5d                   	pop    %ebp
801080fd:	c3                   	ret    
801080fe:	66 90                	xchg   %ax,%ax
80108100:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108103:	31 c0                	xor    %eax,%eax
}
80108105:	5b                   	pop    %ebx
80108106:	5e                   	pop    %esi
80108107:	5f                   	pop    %edi
80108108:	5d                   	pop    %ebp
80108109:	c3                   	ret    
